local MAJOR_VERSION = "MacroText_Customize-1.00"
local MINOR_VERSION = 1

if not LibStub then 
	error(MAJOR_VERSION .. " requires LibStub.") 
end
local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then 
	return 
end


local function SpellIconSelectionButton_Callback(btn, texture)
	local customizeFrame = btn:GetParent():GetParent()
	--print('SpellIconSelectionButton_Callback', customizeFrame:GetName(), texture)
	if (type(texture) == "number") then
		customizeFrame.spellIcon.icon:SetTexture(texture)
	else
		customizeFrame.spellIcon.icon:SetTexture("INTERFACE\\ICONS\\"..texture)
	end
	customizeFrame.macroTextTextureIsCustom = true
end

function LibMT_MacroTextButton_ReceiveDrag(self)
	local command, value, subValue, id = GetCursorInfo()
	--print("LibMT_MacroTextButton_ReceiveDrag", command, value, subValue, id)
	ClearCursor()
	if not(command) then
		return
	end
	
	local texture
	local customizeFrame = self:GetParent()
	--print('LibMT_MacroTextButton_ReceiveDrag', customizeFrame:GetName())
	customizeFrame.macroTextSpellID = id
	customizeFrame.macroTextTextureIsCustom = false

	local icon = customizeFrame.spellIcon.icon
	
	customizeFrame.macroTextCommandType = command
	
	if command == "spell" and (subValue ~= "MOUNT") then
		local name, rank = GetSpellInfo(id)
		--print(name, rank)
		
		if id then
			texture = GetSpellTexture(id)
		end
		if not(texture) then
			texture = GetSpellTexture(name) 
		end
		--print(texture)
		customizeFrame.EditBoxIcon:SetText(name)
		customizeFrame.CommandType:SetText("法術")
	elseif command == "item" and value then
		customizeFrame.macroTextItemID = value
		texture = GetItemIcon(value)
		local name = GetItemInfo(value)
		customizeFrame.EditBoxIcon:SetText(name)
		customizeFrame.CommandType:SetText("物品")
	end
	
	if (texture) then
		icon:SetTexture(texture)
		icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
		icon:Show()
	else
		icon:SetTexture(nil)
		icon:SetVertexColor(1.0, 1.0, 1.0, 0.5)
		icon:Show()
	end
end

function LibMT_MacroTextButton_OnClick(self, button, down)
	local temp = GetCursorInfo()
	if temp then
		LibMT_MacroTextButton_ReceiveDrag(self)
	else
		local f = LibMT_IconSelectionDialogPopup
		if not(f) then
			return
		end
	
		if f:IsVisible() then
			f:Hide()
		else
			f:ClearAllPoints()
			f:SetPoint("TOPLEFT", self:GetParent(), "TOPRIGHT", 20, 0)
			LibMT_IconSelectionDialogPopup_SetCallback(SpellIconSelectionButton_Callback)
			f:Show()
		end
		self:SetChecked(false)
	end
end
