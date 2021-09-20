-- simple library to work with SavedVariables
-- credits: Another
-- example
--[[
	local storage = LibStub("EasyStorage-1.4", false)

	MyAddon_SavedVariablesPerCharacter = MyAddon_SavedVariablesPerCharacter or {}
	MyAddonPerChar = storage:New(MyAddon_SavedVariablesPerCharacter)
	...
	MyAddon_SavedVariables = MyAddon_SavedVariables or {}
	MyAddonGlobal = storage:New(MyAddon_SavedVariables)
	...
	value1 = MyAddonPerChar:Get({"node_root", "node2"}, true)
	value2 = MyAddonGlobal:Get({"node_root", "node3"}, 10)
	...
	MyAddonPerChar:Set({"node_root", "node2"}, some_value)
	MyAddonGlobal:Set({"node_root", "node3"}, 20)
	MyAddonGlobal:Set("node_root.node4.node5", "something")
]]

local MAJOR, MINOR = "EasyStorage-1.4", 0
local EasyStorage = LibStub:NewLibrary(MAJOR, MINOR)

if not EasyStorage then return end

EasyStorageClass = EasyStorageClass or {}
local ESClass = EasyStorageClass
ESClass.__index = ESClass

function EasyStorage:New(storage)
	local instance = {}
	setmetatable(instance, ESClass)
	instance.storage = storage
	return instance
end

local function ToArray(path)
	if (type(path) == "string") then
		return {strsplit(".", path)}
	elseif (type(path) == "table") then
		return path
	else
		error("Not a table or string")
	end
end

local function CheckNodeType(v, index)
	if not(type(v) == "string" or type(v) == "number") then
		error("array value "..tostring(index).." not a string or number")
	end
end

local function deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

function EasyStorageClass:Get(path, default)
	local a = ToArray(path)

	local sv = self.storage
	for i = 1, #a do
		local v = a[i]
		CheckNodeType(v, i)
		
		if (type(sv) == "table") and (sv[v] ~= nil) then
			if i == #a and (type(sv[v]) == "table") then
				sv = deepcopy(sv[v])
			else
				sv = sv[v]
			end
		else
			return default
		end
	end
	return sv
end

local function CheckIsEmpty(value)
	if (type(value) == "table") then
		-- check is simple array first
		if #value > 0 then
			return false
		end
		-- hashtable
		for k, v in pairs(value) do
			if v ~= nil then
				return false
			end
		end
		return true
	else -- not a table
		return false
	end
end

function EasyStorageClass:Set(path, value)
	local a = ToArray(path)

	local sv = self.storage
	for i = 1, #a do
		local v = a[i]
		CheckNodeType(v, i)

		if i == #a then
			if (type(value) == "table") then
				sv[v] = deepcopy(value)
			else
				sv[v] = value
			end
		else
			sv[v] = sv[v] or {}
			sv = sv[v]
		end
	end
	
	if value == nil then
		-- make path to last node
		local temp_keys = {}
		for i = 1, #a - 1 do
			temp_keys[i] = a[i]
		end
		-- get node
		local temp = self:Get(temp_keys, nil)
		if temp then
			if CheckIsEmpty(temp) then
				self:Set(temp_keys, nil)
			else
				return
			end
		end
	end
end

function EasyStorageClass:Remove(path, key)
	local a = ToArray(path)

	local sv = self.storage
	for i = 1, #a do
		local v = a[i]
		CheckNodeType(v, i)
		
		if (type(sv) == "table") and (sv[v] ~= nil) then
			sv = sv[v]
		end
	end
	if (type(sv) == "table") then
		table.remove(sv, key)
	end
end