local tankUpdateQueued = false

local function UpdateTank(self, event)
    if event == "GROUP_ROSTER_UPDATE" and IsInGroup() then
        if InCombatLockdown() then
            tankUpdateQueued = true
        else
            self.mdButton:SetAttribute("unit", FindTank())
        end
    elseif event == "PLAYER_REGEN_ENABLED" and tankUpdateQueued then
        self.mdButton:SetAttribute("unit", FindTank())
        tankUpdateQueued = false
	-- 不在隊伍中或沒有坦克時，誤導給寵物。
	else
		self.mdButton:SetAttribute("unit","pet")
		tankUpdateQueued = false
    end
end

function FindTank()
    local groupType = IsInRaid() and "raid" or "party"
	-- local hasTank = false
    for i = 1, GetNumGroupMembers() do
        local unit = groupType .. i
        
        if UnitGroupRolesAssigned(unit) == "TANK" then
			-- hasTank = true
            return unit
        end
    end
	-- 隊伍中沒有坦克時，誤導給寵物。
	-- if not hasTank then
	return "pet"
	-- end
end

local frame = CreateFrame("Frame")

frame.mdButton = CreateFrame("Button", "MisdirectTankButton", UIParent, "SecureActionButtonTemplate")
frame.mdButton:SetAttribute("type", "spell")
frame.mdButton:SetAttribute("spell", "誤導")
frame.mdButton:SetAttribute("checkselfcast", false)
frame.mdButton:SetAttribute("checkfocuscast", false)

frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", UpdateTank)