local SpellCVHealth = 0.70
local BuffGUICrimsonVial

function CrimsonVial_Create()
    BuffGUICrimsonVial = BuffGUI:CreateTexture("BuffGUICrimsonVial")
    BuffGUICrimsonVial:SetWidth(45)
    BuffGUICrimsonVial:SetHeight(45)
    BuffGUICrimsonVial:SetTexture("Interface\\AddOns\\RogueBox\\Vial.tga")
    BuffGUICrimsonVial:SetPoint("CENTER", -90, 43, "BuffGUI")
    BuffGUICrimsonVial:Hide()
end

function CrimsonVial_Tick()
    local start, duration, enabled = GetSpellCooldown("Crimson Vial");
    --Check if player health % is less than that regained by Crimson Vial
    if(start == 0 and duration == 0 and enabled == 1) then
        if((UnitHealth("player") / UnitHealthMax("player")) <= SpellCVHealth) then
            BuffGUICrimsonVial:Show()
        else
            BuffGUICrimsonVial:Hide()
        end
    else
        BuffGUICrimsonVial:Hide()
    end
    
    if(IsPlayerSpell(193546)) then
        SpellCVHealth = 0.58
    else
        SpellCVHealth = 0.70
    end
end
C_Timer.NewTicker(1, function() CrimsonVial_Tick() end)

function CrimsonVial_CombatLog(combatEvent, destGUID, spellId)
    if combatEvent == "SPELL_AURA_APPLIED" and destGUID == UnitGUID("player") and spellId == 185311 then --crimson vial
        BuffGUICrimsonVial:Hide()
	end
end
