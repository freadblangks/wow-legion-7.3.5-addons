-- Charge Cooldown stuff

local numChargeCooldowns = 0;
local function Lib_CreateChargeCooldownFrame(parent)
	numChargeCooldowns = numChargeCooldowns + 1;
	local cooldown = CreateFrame("Cooldown", "Lib_ChargeCooldown"..numChargeCooldowns, parent, "CooldownFrameTemplate");
	cooldown:SetHideCountdownNumbers(true);
	cooldown:SetDrawSwipe(false);

	cooldown:SetAllPoints(parent);
	cooldown:SetFrameStrata("TOOLTIP");

	return cooldown;
end

function Lib_StartChargeCooldown(parent, chargeStart, chargeDuration)
	if chargeStart == 0 then
		Lib_ClearChargeCooldown(parent);
		return;
	end

	parent.chargeCooldown = parent.chargeCooldown or Lib_CreateChargeCooldownFrame(parent);

	CooldownFrame_Set(parent.chargeCooldown, chargeStart, chargeDuration, true, true);
end

function Lib_ClearChargeCooldown(parent)
	if parent.chargeCooldown then
		CooldownFrame_Clear(parent.chargeCooldown);
	end
end