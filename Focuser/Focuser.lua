local modifier = "shift" -- shift, alt 或 ctrl
local mouseButton = "1" -- 1 = 左鍵, 2 = 右鍵, 3 = 中鍵, 4 和 5 = 滑鼠的其他按鍵。

local function SetFocusHotkey(frame)
	frame:SetAttribute(modifier.."-type"..mouseButton,"focus")
end

local function CreateFrame_Hook(type, name, parent, template)
	if template == "SecureUnitButtonTemplate" then
		SetFocusHotkey(_G[name])
	end
end

hooksecurefunc("CreateFrame", CreateFrame_Hook)

-- Keybinding override so that models can be shift/alt/ctrl+clicked
local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
f:SetAttribute("type1","macro")
f:SetAttribute("macrotext","/focus mouseover")
SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton")

-- Set the keybindings on the default unit frames since we won't get any CreateFrame notification about them
local duf = {
	PlayerFrame,
	PetFrame,
	PartyMemberFrame1,
	PartyMemberFrame2,
	PartyMemberFrame3,
	PartyMemberFrame4,
	PartyMemberFrame1PetFrame,
	PartyMemberFrame2PetFrame,
	PartyMemberFrame3PetFrame,
	PartyMemberFrame4PetFrame,
	TargetFrame,
	TargetofTargetFrame,
}

for i,frame in pairs(duf) do
	SetFocusHotkey(frame)
end