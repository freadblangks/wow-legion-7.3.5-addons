local _, ns = ...

ns.Util = ns.Util or {}

function ns.Util.AppendScript(frame, handler, func)
	local old = frame:GetScript(handler)

	if old == nil then
		frame:SetScript(handler, func)
	else
		frame:SetScript(handler, function( ... )
			old(...)
			func(...)
		end)
	end
end

function ns.Util.MergeFunc(f1, f2)
	if f1 == nil and f2 == nil then return end

	if f1 == nil and f2 then
		return f2
	end

	if f2 == nil and f1 then
		return f1
	end

	return function( ... )
		f1(...)
		f2(...)
	end
end

function ns.Util.CopyTable(source)
	if not source then return end

	local destination = {}

    for k,v in pairs(source) do
        if type(v) ~= "table" then
            destination[k] = v
        end
    end

    return destination
end

function ns.Util.Dump(value, depth)
	if type(value) == "nil" then return "" end

	depth = depth or 0

	local str = ""

	if type(value) ~= "table" then
		return str .. " " .. tostring(value)
	else
		if depth > 0 then
			str = str .. " {|n"
		else
			str = str .. "|n"
		end

		for k,v in pairs(value) do
			for i = 1, depth do
				str = str .. "  "
			end

			str = str .. "- |cFFFF00FF" .. k .. "|r:" .. ns.Util.Dump(v, depth + 1) .. ",|n"
		end

		if depth > 0 then
			str = str .. "}"
		end
	end

	if depth == 0 then
		print(str)
	else
		return str
	end
end