local _, vars = ...;
local L = vars.L

local name = "ClassSpecStats"
local sFrameInit = false
local pHooked = false
local elapsedTime = 0

local function CPrint(msg)
	print("|cFF99FF99裝備屬性建議：|r"..msg)
end

stats_Frame = CreateFrame("Frame",stats_Frame,UIParent)

function stats_Frame:CreateWin()
    if PaperDollFrame:IsVisible() then
        if not stats_Window then
            stats_Window = CreateFrame("Frame",stats_Window,stats_Frame)
            local f = stats_Frame
			f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                    tile = true, tileSize = 16, edgeSize = 16,
                    insets = { left = 1, right = 1, top = 1, bottom = 1 }})
            f:SetBackdropColor(0,0,0,1)
            f:SetFrameStrata("TOOLTIP")
            f:SetWidth(PaperDollFrame:GetWidth()-50)
			f:SetHeight(45)

			stats_txt = f:CreateFontString(nil,"OVERLAY","GameFontWhite")
			local ft = stats_txt
			ft:ClearAllPoints()
			ft:SetAllPoints(stats_Frame)
			ft:SetJustifyH("CENTER")
			ft:SetJustifyV("CENTER")
            f:ClearAllPoints()
            f:SetPoint("BOTTOMRIGHT",PaperDollFrame,"TOPRIGHT",0,0)
            f:SetParent(PaperDollFrame)
            f:Show()

			local fw = stats_Window
			fw:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                    tile = true, tileSize = 16, edgeSize = 16,
                    insets = { left = 1, right = 1, top = 1, bottom = 1 }})
            fw:SetBackdropColor(0,0,0,1)
            fw:SetFrameStrata("TOOLTIP")
            fw:SetWidth(PaperDollFrame:GetWidth()-50)
			fw:SetHeight(25)

			statsw_txt = fw:CreateFontString(nil,"OVERLAY","GameFontWhite")
			local ftw = statsw_txt
			ftw:ClearAllPoints()
			ftw:SetAllPoints(stats_Window)
			ftw:SetJustifyH("CENTER")
			ftw:SetJustifyV("CENTER")
            fw:ClearAllPoints()
            fw:SetPoint("BOTTOMRIGHT",stats_Frame,"TOPRIGHT",0,-3)
			fw:SetParent(stats_Frame)
			fw:Show()
        end
        return true
    end
    return false
end

function stats_Frame:Update()
    if GetSpecialization() == nil then
          return false
    end

	local specID = select(1,GetSpecializationInfo(GetSpecialization()))

    if stats_Frame:CreateWin() then
        local s = stats_Table[specID]
		local v = stats_Table["Version"]

        if s then
            s = gsub(s,"Strength","Str")
            s = gsub(s,"Agility","Agi")
            s = gsub(s,"Intellect","Int")
            s = gsub(s,"Stamina","Stam")
            s = gsub(s,"Versatility","Vers")

			-- H.Sch For multiple language
			s = gsub(s,"Int", L["Int"])
			s = gsub(s,"Crit", L["Crit"])
			s = gsub(s,"Str", L["Str"])
			s = gsub(s,"Agi", L["Agi"])
			s = gsub(s,"Stam", L["Sta"])
			s = gsub(s,"Vers", L["Vers"])
			s = gsub(s,"Haste", L["Haste"])
			s = gsub(s,"Mast", L["Mastery"])
			s = gsub(s,"Armor", L["Armor"])
			-- H.Sch End for multiple language
			statsw_txt:SetText(v)
            stats_txt:SetText(s)
        end
		sFrameInit = true
    end
end

local f = stats_Frame
f:RegisterEvent("SPELLS_CHANGED")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == name then
		stats_Frame:Update()
		PaperDollFrame:HookScript("OnShow", function() stats_Frame:Update() end)
		pHooked = true
		-- CPrint("loaded.")
    elseif event == "SPELLS_CHANGED" then
        if IsAddOnLoaded(name) then
            stats_Frame:Update()
        end
    end
end)

local delayTimer = CreateFrame("Frame")
delayTimer:SetScript("OnUpdate", function (self, elapsed)

	elapsedTime = elapsedTime + elapsed

	if (elapsedTime < 10) then
		return
	else
		elapsedTime = 0
	end

	if not sFrameInit then
		stats_Frame:Update()
		if not pHooked then
			PaperDollFrame:HookScript("OnShow", function() stats_Frame:Update() end)
			pHooked = true
			CPrint("載入延遲!")
		end
	end

end)
