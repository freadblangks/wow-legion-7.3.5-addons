local RTBDuration = 0
local RTBBuffs = 0

local function isOutlaw()
	local _, class = UnitClass("player")
	return (class == "ROGUE" and GetSpecialization() == 2)
end

local BuffGUI = CreateFrame("Frame", "BuffGUI", UIParent)
BuffGUI:SetWidth(175)
BuffGUI:SetHeight(25)
BuffGUI:SetPoint("TOPLEFT",0,0, PlayerNameplateParent)
BuffGUI:Hide()
BuffGUI:SetBackdrop({
	bgFile = "Interface\\dialogframe\\ui-dialogbox-background-dark",
	edgeFile = "Interface\\tooltips\\UI-tooltip-Border",
	tile = true,
	tileSize = 32,
	edgeSize = 1,
	insets = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
})

TimerText_Create()
CreatePistolGUI()
CrimsonVial_Create()

hooksecurefunc("CompactUnitFrame_OnUpdate", function(frame)
    if C_NamePlate.GetNamePlateForUnit("player") ~= nil then
        if C_NamePlate.GetNamePlateForUnit(frame.unit) == C_NamePlate.GetNamePlateForUnit("player") then
            local point, relativeTo, relativePoint, xOfs, yOfs = C_NamePlate.GetNamePlateForUnit("player").UnitFrame:GetPoint(n)
            BuffGUI:SetPoint(point, relativeTo, relativePoint, xOfs - 8, yOfs - 55)
        end
    end
    if(InCombatLockdown() and isOutlaw()) then
        BuffGUI:Show()
    else
        BuffGUI:Hide()
    end
end)

local BuffGUIBackground = BuffGUI:CreateTexture("BuffGUIBackground")
BuffGUIBackground:SetWidth(256)
BuffGUIBackground:SetHeight(64)
BuffGUIBackground:SetTexture("Interface\\AddOns\\RogueBox\\BarOff.tga")
BuffGUIBackground:SetPoint("CENTER", 0, 10, BuffGUI)

function BuffGUI_Create_Buff(x, IconNum)
    local BuffGUI_Buff = CreateFrame("Frame", nil, BuffGUI)
    BuffGUI_Buff:SetWidth(30)
    BuffGUI_Buff:SetHeight(30)
    BuffGUI_Buff:SetPoint("CENTER", x, 0, "BuffGUI")
    BuffGUI_Buff:SetBackdrop({
        bgFile = "Interface\\Icons\\ability_rogue_rollthebones"..IconNum,
        edgeFile = "Interface\\tooltips\\UI-tooltip-Border",
        tile = false,
        tileSize = 30,
        edgeSize = 8,
        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1,
        },
    })
    BuffGUI_Buff:SetBackdropColor(0.2,0.2,0.2,1)
    return BuffGUI_Buff
end

-- events
function BuffGUI:CHARACTER_POINTS_CHANGED(self, event, ...)
	if isOutlaw() then
		if not alreadyRegistered then
			BuffGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = true
		end
        if InCombatLockdown() then
            BuffGUI:Show()
        end
	else
		if alreadyRegistered then
			BuffGUI:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = false
		end
		BuffGUI:Hide()
	end
end

function BuffGUI:PLAYER_TALENT_UPDATE(self, event, ...)
	if isOutlaw() then
		if not alreadyRegistered then
			BuffGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = true
		end
		if InCombatLockdown() then
            BuffGUI:Show()
        end
	else
		if alreadyRegistered then
			BuffGUI:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = false
		end
		BuffGUI:Hide()
	end
end

function BuffGUI:ACTIVE_TALENT_GROUP_CHANGED(self, event, ...)
	if isOutlaw() then
		if not alreadyRegistered then
			BuffGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = true
		end
		if InCombatLockdown() then
            BuffGUI:Show()
        end
	else
		if alreadyRegistered then
			BuffGUI:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			alreadyRegistered = false
		end
		BuffGUI:Hide()
	end
end

function BuffGUI:PLAYER_ENTERING_WORLD(self, event, ...)	
	-- only if they pass the checks will we actually look at the combat log
	if isOutlaw() then
		BuffGUI:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		if InCombatLockdown() then
            BuffGUI:Show()
        end
		
		alreadyRegistered = true
	else
		BuffGUI:Hide()
	end
	
	-- events to watch to see if they switched to a demo spec
	BuffGUI:RegisterEvent("CHARACTER_POINTS_CHANGED")
	BuffGUI:RegisterEvent("PLAYER_TALENT_UPDATE")
	BuffGUI:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	
	BuffGUI:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

local BuffGUI_JollyRoger = BuffGUI_Create_Buff(-75,"01")
local BuffGUI_GrandMelee = BuffGUI_Create_Buff(-45,"02")
local BuffGUI_SharkInfestedWaters = BuffGUI_Create_Buff(-15,"03")
local BuffGUI_TrueBearing = BuffGUI_Create_Buff(15,"04")
local BuffGUI_BuriedTreasure = BuffGUI_Create_Buff(45,"05")
local BuffGUI_Broadsides = BuffGUI_Create_Buff(75,"07")

function LightUpBuffs()
    if(UnitBuff("player", "黑旗") ~= nil) then
        BuffGUI_JollyRoger:SetBackdropColor(1,1,1,1)
    else
        BuffGUI_JollyRoger:SetBackdropColor(0.2,0.2,0.2,1)
    end
    
    if(UnitBuff("player", "大亂鬥") ~= nil) then
        BuffGUI_GrandMelee:SetBackdropColor(1,1,1,1)
    else
        BuffGUI_GrandMelee:SetBackdropColor(0.2,0.2,0.2,1)
    end
    
    if(UnitBuff("player", "兇鯊海域") ~= nil) then
        BuffGUI_SharkInfestedWaters:SetBackdropColor(1,1,1,1)
    else
        BuffGUI_SharkInfestedWaters:SetBackdropColor(0.2,0.2,0.2,1)
    end
    
    if(UnitBuff("player", "絕對方位") ~= nil) then
        BuffGUI_TrueBearing:SetBackdropColor(1,1,1,1)
    else
        BuffGUI_TrueBearing:SetBackdropColor(0.2,0.2,0.2,1)
    end
    
    if(UnitBuff("player", "地底藏寶") ~= nil) then
        BuffGUI_BuriedTreasure:SetBackdropColor(1,1,1,1)
    else
        BuffGUI_BuriedTreasure:SetBackdropColor(0.2,0.2,0.2,1)
    end
    
    if(UnitBuff("player", "側舷截擊") ~= nil) then
        BuffGUI_Broadsides:SetBackdropColor(1,1,1,1)
    else
        BuffGUI_Broadsides:SetBackdropColor(0.2,0.2,0.2,1)
    end
end

function TickConst()
    if(RTBDuration>0) then
        RTBDuration = RTBDuration - 1 --count it down
        TimerText_Show(RTBDuration)
        if(RTBBuffs >= 2) then
            BuffGUIBackground:SetTexture("Interface\\AddOns\\RogueBox\\Bar.tga")
        end
    end
    if(RTBDuration == 0) then
        TimerText_Hide()
        RTBBuffs = 0 --there are no buffs now
        BuffGUIBackground:SetTexture("Interface\\AddOns\\RogueBox\\BarOff.tga")
    end
end
C_Timer.NewTicker(1, function() TickConst() end)

function BuffGUI:COMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	local compTime = GetTime()
	local combatEvent = select(1, ...)
	local sourceGUID = select(3, ...)
	local sourceName = select(4, ...)
	local destGUID = select(7, ...)
	local destName = select(8, ...)
    local spellId = select(11, ...)
    local spellName = select(12, ...)
    
    CrimsonVial_CombatLog(combatEvent, destGUID, spellId)
    
    LightUpBuffs()
    
    if combatEvent == "SPELL_AURA_APPLIED" and sourceGUID == UnitGUID("player") then
        if(spellId == 199600 or spellId == 193356 or spellId == 199603 or spellId == 193359 or spellId == 193357 or spellId == 193358) then
            local name, rank, icon, count, dispelType, duration = UnitAura("player", spellName)
            RTBDuration = ceil(duration)
            RTBBuffs = RTBBuffs + 1
        end
    end
    
    if combatEvent == "SPELL_AURA_REMOVED" then
        if(spellId == 199600 or spellId == 193356 or spellId == 199603 or spellId == 193359 or spellId == 193357 or spellId == 193358) then
            TimerText_Hide()
            RTBBuffs = 0
            BuffGUIBackground:SetTexture("Interface\\AddOns\\RogueBox\\BarOff.tga")
        end
    end
    if combatEvent == "SPELL_AURA_APPLIED" and destGUID == UnitGUID("player") and spellId == 195627 then
        HasShot()
	end
    if combatEvent == "SPELL_AURA_REMOVED" and destGUID == UnitGUID("player") and spellId == 195627 then
        EndShot()
	end
end

BuffGUI:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
BuffGUI:RegisterEvent("PLAYER_ENTERING_WORLD")