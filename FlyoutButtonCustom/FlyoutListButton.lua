--[[ FlyoutListButton ]]

local StoredCursor = {}
local ParentAlpha
local QUICK_SLOT = "Interface\\Buttons\\UI-Quickslot"
local QUICK_SLOT_2 = "Interface\\Buttons\\UI-Quickslot2"
local QUESTION_MARK = "Interface\\Icons\\INV_Misc_QuestionMark"
FlyoutListButton = {}


local OnClickWrapScript_HideSet = [=[
	local listFrame = self:GetParent()
	if listFrame then
		local arrowBtn = listFrame:GetParent()
		if arrowBtn then
			arrowBtn:SetAttribute("expanded", false)
			listFrame:Hide()
			
			local actionButton = arrowBtn:GetParent()
			local attr_type = self:GetAttribute("type")
			if (attr_type == "spell") or (attr_type == "item") or (attr_type == "macro") then
				actionButton:SetAttribute("type", attr_type)
				actionButton:SetAttribute(attr_type, self:GetAttribute(attr_type))
				self:SetAttribute("override_pending", true)
				actionButton:SetAttribute("fbc_tooltip_source", self:GetName())
			end
		end
	end	
]=]

local OnClickWrapScript_Hide = [=[
	local listFrame = self:GetParent()
	if listFrame then
		local arrowBtn = listFrame:GetParent()
		if arrowBtn then
			arrowBtn:SetAttribute("expanded", false)
			listFrame:Hide()
		end
	end	
]=]

local OnClickWrapScript_Set = [=[
	local listFrame = self:GetParent()
	if listFrame then
		local arrowBtn = listFrame:GetParent()
		if arrowBtn then
			local actionButton = arrowBtn:GetParent()
			local attr_type = self:GetAttribute("type")
			if (attr_type == "spell") or (attr_type == "item") or (attr_type == "macro") then
				actionButton:SetAttribute("type", attr_type)
				actionButton:SetAttribute(attr_type, self:GetAttribute(attr_type))
				self:SetAttribute("override_pending", true)
				actionButton:SetAttribute("fbc_tooltip_source", self:GetName())
			end
		end
	end	
]=]

-- presets

local preset_by_spell = {
	["UpdateText"] 		= "EmptyFunc",
	["UpdateCount"] 	= "UpdateCountSpell",
	["SetTooltip"] 		= "SetTooltipSpell",
	["SetUpdateTooltip"] 	= "UpdateTooltipSpell",
	["GetTexture"] 		= "GetTextureSpell",
	["UpdateChecked"] 	= "UpdateCheckedSpell",
	["UpdateEquipped"] 	= "UpdateEquippedNotItem",
	["UpdateCooldown"] 	= "UpdateCooldownSpell",
	["GetUsable"] 		= "GetUsableSpell",
	["InRange"] 		= "InRangeSpell",
	["GlowShow"]		= "SpellGlowShow",
	["GlowHide"]		= "SpellGlowHide",
}

local preset_by_item = {
	["UpdateText"] 		= "EmptyFunc",
	["UpdateCount"] 	= "UpdateCountItem",
	["SetTooltip"] 		= "SetTooltipItem",
	["SetUpdateTooltip"] 	= "UpdateTooltipItem",
	["GetTexture"] 		= "GetTextureItem",
	["UpdateChecked"] 	= "UpdateCheckedItem",
	["UpdateEquipped"] 	= "UpdateEquippedItem",
	["UpdateCooldown"] 	= "UpdateCooldownItem",
	["GetUsable"] 		= "GetUsableItem",
	["InRange"] 		= "InRangeItem",
	["GlowShow"]		= "EmptyFunc",
	["GlowHide"]		= "EmptyFunc",
}

local preset_by_macro = {
	["UpdateText"] 		= "UpdateTextMacro",
	["UpdateCount"] 	= "EmptyFunc",
	["SetTooltip"] 		= "SetTooltipMacro",
	["SetUpdateTooltip"]	= "UpdateTooltipMacro",
	["GetTexture"] 		= "GetTextureMacro",
	["UpdateChecked"] 	= "UpdateCheckedMacro",
	["UpdateEquipped"] 	= "UpdateEquippedNotItem",
	["UpdateCooldown"] 	= "UpdateCooldownMacro",
	["GetUsable"] 		= "GetUsableMacro",
	["InRange"] 		= "InRangeMacro",
	["GlowShow"]		= "MacroGlowShow",
	["GlowHide"]		= "MacroGlowHide",
}

local preset_by_macrotext = {
	["UpdateText"] 		= "EmptyFunc",
	["UpdateCount"] 	= "UpdateCountMacroText",
	["SetTooltip"] 		= "SetTooltipMacroText",
	["SetUpdateTooltip"]	= "UpdateTooltipMacroText",
	["GetTexture"] 		= "GetTextureMacroText",
	["UpdateChecked"] 	= "UpdateCheckedMacro",
	["UpdateEquipped"] 	= "UpdateEquippedNotItem",
	["UpdateCooldown"] 	= "UpdateCooldownMacroText",
	["GetUsable"] 		= "GetUsableMacroText",
	["InRange"] 		= "InRangeMacroText",
	["GlowShow"]		= "MacroTextGlowShow",
	["GlowHide"]		= "MacroTextGlowHide",
}

local preset_by_equipmentset = {
	["UpdateText"] 		= "UpdateTextEquipmentset",
	["UpdateCount"] 	= "EmptyFunc",
	["SetTooltip"] 		= "SetTooltipEquipmentset",
	["SetUpdateTooltip"] 	= "UpdateTooltipEquipmentset",
	["GetTexture"] 		= "GetTextureEquipmentset",
	["UpdateChecked"] 	= "UpdateCheckedEquipmentset",
	["UpdateEquipped"] 	= "UpdateEquippedNotItem",
	["UpdateCooldown"] 	= "UpdateCooldownNone",
	["GetUsable"] 		= "GetUsableEquipmentset",
	["InRange"] 		= "InRangeEquipmentset",
	["GlowShow"]		= "EmptyFunc",
	["GlowHide"]		= "EmptyFunc",
}

local preset_by_battlepet = {
	["UpdateText"] 		= "EmptyFunc",
	["UpdateCount"] 	= "EmptyFunc",
	["SetTooltip"] 		= "SetTooltipBattlepet",
	["SetUpdateTooltip"] 	= "UpdateTooltipBattlepet",
	["GetTexture"] 		= "GetTextureBattlepet",
	["UpdateChecked"] 	= "UpdateCheckedBattlepet",
	["UpdateEquipped"] 	= "UpdateEquippedNotItem",
	["UpdateCooldown"] 	= "UpdateCooldownNone",
	["GetUsable"] 		= "GetUsableBattlepet",
	["InRange"] 		= "InRangeBattlepet",
	["GlowShow"]		= "EmptyFunc",
	["GlowHide"]		= "EmptyFunc",
}			

function FlyoutListButton_New(parent, idx)
	parent.ButtonList[idx] = CreateFrame("CheckButton", parent:GetName().."ListButton"..idx, parent, "CustomFlyoutListButtonTemplate")
	local btn = parent.ButtonList[idx]
	btn.index = idx
	btn.border = _G[btn:GetName().."Border"]
	btn.count = _G[btn:GetName().."Count"]
	btn.name = _G[btn:GetName().."Name"]
	btn.hotkey = _G[btn:GetName().."HotKey"]
	btn.ntexture = _G[btn:GetName().."NormalTexture"]
	btn.flash = _G[btn:GetName().."Flash"]
	btn.flf = parent
	btn.arrBtn = parent:GetParent()
	btn.actnBtn = btn.arrBtn:GetParent()
	btn.actnBtnName = btn.actnBtn:GetName()
	
	-- adding methods to button
	for k, v in pairs(FlyoutListButton) do
		if type(v) == "function" then
			btn[k] = v
		end
	end
	
	btn:SetMovable(true)
	if FbcSettingsMode then
		btn.configure:Show()
	else
		btn.configure:Hide()
	end
	btn:RegisterForDrag("LeftButton")
	btn:SetNormalTexture(QUICK_SLOT)
	btn:SetAttribute("checkselfcast", true)
	btn:SetAttribute("checkfocuscast", true)
	if FbcRightClickSelfCast then
		btn:SetAttribute("unit2", "player") --right-click self cast
	end
	btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	btn:SetClickHandler(FbcHideOnClick, FbcLeftClickSet)

	return btn
end

function FlyoutListButton_AttachToList(parent, idx, expandDir)
	local btn = parent.ButtonList[idx]
	if not(btn) then
		btn = FlyoutListButton_New(parent, idx)
		btn:ClearHandlers()	
		if (FBC_MasqueMasterGroup) then
			FBC_MasqueMasterGroup:AddButton(btn)
		end
	end
	btn:SetAnchor(parent, idx, expandDir)

	return btn
end

function FlyoutListButton:ClearHandlers()
	for k, v in pairs(preset_by_spell) do
		self[k] = self.EmptyFunc
	end
end

function FlyoutListButton:EmptyFunc()
	return nil
end

function FlyoutListButton:SetClickHandler(hide, click)
	self:UnwrapScript(self, "OnClick")
	if hide then
		if click then
			self:WrapScript(self, "OnClick", OnClickWrapScript_HideSet)
		else
			self:WrapScript(self, "OnClick", OnClickWrapScript_Hide)
		end
	else
		if click then
			self:WrapScript(self, "OnClick", OnClickWrapScript_Set)
		end
	end
end

function FlyoutListButton:SetRightClickSelfCast(value)
	if value then
		self:SetAttribute("unit2", "player") --right-click self cast enabled
	else
		self:SetAttribute("unit2", "") --right-click self cast disabled
	end
end

function FlyoutListButton:SetAnchor(parent, idx, expandDir)
	self:ClearAllPoints()
	if expandDir == FBC_DIR_UP then
		self:SetPoint("BOTTOM", parent, "BOTTOM", 0, idx * FBC_BUTTON_PLACE_OFFSET + (idx - 1) * FBC_BUTTON_PLACE_SIZE)
	elseif expandDir == FBC_DIR_LEFT then
		self:SetPoint("RIGHT", parent, "RIGHT", - (idx * FBC_BUTTON_PLACE_OFFSET + (idx - 1) * FBC_BUTTON_PLACE_SIZE), 0)
	elseif expandDir == FBC_DIR_DOWN then
		self:SetPoint("TOP", parent, "TOP", 0, - (idx * FBC_BUTTON_PLACE_OFFSET + (idx - 1) * FBC_BUTTON_PLACE_SIZE))
	else
		self:SetPoint("LEFT", parent, "LEFT", idx * FBC_BUTTON_PLACE_OFFSET + (idx - 1) * FBC_BUTTON_PLACE_SIZE, 0)
	end
end

function FlyoutListButton:OnCustomize()
	FlyoutButtonCustom_MacroTextCustomizeFrame_Toogle(self)
end

-- keybind stuff

function FlyoutListButton:GetHotkey()
	local key = GetBindingKey("CLICK "..self:GetName()..":LeftButton")
	local displayKey = FbcLibKeyBound:ToShortKey(key)
	return displayKey
end

function FlyoutListButton:SetKey(key) -- binds the given key to the given button
	local binding = "CLICK "..self:GetName()..":LeftButton"
	if (key ~= "" and key ~= nil) then
		SetBinding(key, binding)
		self.hotkey:SetText(GetBindingText(key, "KEY_", 1))
		if not self.hotkey.__LBF_SetPoint then
			self.hotkey:ClearAllPoints()
			self.hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", -2, -2)
		end
		self.hotkey:SetVertexColor(0.6, 0.6, 0.6)
		self.hotkey:Show()
	else
		self.hotkey:SetText(RANGE_INDICATOR)
		if not self.hotkey.__LBF_SetPoint then
			self.hotkey:ClearAllPoints()
			self.hotkey:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -2)
		end
		self.hotkey:Hide()
	end
	self.keybind = key

	FlyoutButtonES:Set({self.actnBtnName, FlyoutButton_GetSpecialization(), self.index, "keybind"}, key)
end

function FlyoutListButton:ClearBindings() -- removes all keys bound to the given button
	local binding = "CLICK "..self:GetName()..":LeftButton"
	while GetBindingKey(binding) do
		SetBinding(GetBindingKey(binding), nil)
		self:SetKey(nil)
	end
end

function FlyoutListButton:FreeKey(key) -- unbinds the given key from all other buttons
	for _, arrowBtn in pairs(FbcArrowButtons) do
		for i, v in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			if v.keybind == key then
				v:SetKey(nil)
			end
		end
	end
end

--tooltip

function FlyoutListButton:UpdateTooltipSpell()
	if (self.id) and GameTooltip:SetSpellByID(self.id) then --tooltipValue
		self.UpdateTooltip = self.UpdateTooltipSpell
	else
		self.UpdateTooltip = nil
	end
end
function FlyoutListButton:UpdateTooltipItem()
	if (self.tooltipValue) then --itemID
		--print("item", self.tooltipValue, PlayerHasToy(self.tooltipValue))
		if (GetCVar("UberTooltips") == "1") then
			GameTooltip_SetDefaultAnchor(GameTooltip, self)
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
		
		if PlayerHasToy(self.tooltipValue) then
			--print('set by toy', self.tooltipValue)
			if GameTooltip:SetToyByItemID(self.tooltipValue) then
				self.UpdateTooltip = self.UpdateTooltipItem
				return
			end
		elseif GameTooltip:SetItemByID(self.tooltipValue) then
			self.UpdateTooltip = self.UpdateTooltipItem
			return
		end
	end
	self.UpdateTooltip = nil
end
function FlyoutListButton:UpdateTooltipMacro()
	if (self.tooltipValue) then
		GameTooltip:SetText(self.tooltipValue, 1.0, 1.0, 1.0)
		self.UpdateTooltip = self.UpdateTooltipMacro
	else
		self.UpdateTooltip = nil
	end
end
function FlyoutListButton:UpdateTooltipMacroText()
	local t = self.macroValues
	if (self.tooltipValue) and (self.tooltipValue ~= '') then
		local temp = string.gsub(self.tooltipValue, "||", "|")
		GameTooltip:SetText(temp, 1.0, 1.0, 1.0, 1, 1)
		return
	elseif t and type(t) == "table" then
		if self.subValue == "spell" then
			if (t.id) and GameTooltip:SetSpellByID(t.id) then
				self.UpdateTooltip = self.UpdateTooltipMacroText
				return
			end
		elseif self.subValue == "item" then
			if (t.id) and GameTooltip:SetItemByID(t.id) then
				self.UpdateTooltip = self.UpdateTooltipMacroText
				return
			end
		end
	end
	self.UpdateTooltip = nil
end
function FlyoutListButton:UpdateTooltipEquipmentset()
	if (self.tooltipValue) and GameTooltip:SetEquipmentSet(self.tooltipValue) then
		self.UpdateTooltip = self.UpdateTooltipEquipmentset
	else
		self.UpdateTooltip = nil
	end
end
function FlyoutListButton:UpdateTooltipBattlepet()
	if (self.value) and (self.tooltipValue) then -- self.tooltipValue is hyperlinklink
		--speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique
		local speciesID, customName, level = C_PetJournal.GetPetInfoByPetID(self.value)
		local _, _, _, breedQuality, maxHealth, power, speed, _ = strsplit(":", self.tooltipValue)
		BattlePetToolTip_Show(speciesID, level, tonumber(breedQuality), maxHealth, power, speed, customName) 
		self.UpdateTooltip = self.UpdateTooltipBattlepet
	else
		self.UpdateTooltip = nil
	end
end
function FlyoutListButton:OnEnter()
	if (self.GetHotkey) then
		FbcLibKeyBound:Set(self)
	end
	
	if (GetCVar("UberTooltips") == "1") then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
	else
		local bar = self.actnBtn:GetParent()
		if (bar == MultiBarBottomRight or bar == MultiBarRight or bar == MultiBarLeft) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end
	end
	
	self:SetUpdateTooltip()

	-- anti fading stuff
	local parent = self.actnBtn
	while parent do
		local bar = parent:GetParent()
		if not(bar) or bar == UIParent then
			break
		elseif bar:GetAlpha() ~= 1 then
			ParentAlpha = {}
			ParentAlpha.bar = bar
			ParentAlpha.alpha = bar:GetAlpha()
			bar:SetAlpha(1)
			break
		end
		parent = bar
	end
end

function FlyoutListButton:OnLeave()
	GameTooltip:Hide()
	BattlePetTooltip:Hide()
	
	-- anti fading stuff
	if ParentAlpha and ParentAlpha.bar then
		ParentAlpha.bar:SetAlpha(ParentAlpha.alpha)
		ParentAlpha = nil
	end
end

function FlyoutListButton:SetTooltipSpell()
	self.tooltipValue = self.value
end
function FlyoutListButton:SetTooltipItem()
	self.tooltipValue = self.value --itemId
end
function FlyoutListButton:SetTooltipMacro()
	self.tooltipValue = self.value
end
function FlyoutListButton:SetTooltipMacroText()
	self.tooltipValue = self.id --tooltip stored in id
end
function FlyoutListButton:SetTooltipEquipmentset()
	self.tooltipValue = self.value
end
function FlyoutListButton:SetTooltipBattlepet()
	self.tooltipValue = C_PetJournal.GetBattlePetLink(self.value)
end

--texture

function FlyoutListButton:GetTextureSpell()
	local texture = nil

	texture = GetSpellTexture(self.value) 
	if not(texture) and self.id then
		texture = GetSpellTexture(self.id)
	end
	return texture
end
function FlyoutListButton:GetTextureItem()
	return GetItemIcon(self.value)
end
function FlyoutListButton:GetTextureMacro()
	local _, texture = GetMacroInfo(self.value)
	return texture
end
function FlyoutListButton:GetTextureMacroText()
	local t = self.macroValues
	local texture
	if t and type(t) == "table" then
		if t.textureIsCustom then
			texture = t.texture
		else
			if self.subValue == "spell" then
				t.texture = GetSpellTexture(t.value)
				texture = t.texture
			elseif self.subValue == "item" then
				t.texture = GetItemIcon(t.value)
				texture = t.texture
			end
		end
	end

	return texture
end
function FlyoutListButton:GetTextureEquipmentset()
	local _, texture = GetEquipmentSetInfoByName(self.value)
	--print(texture)
	return texture
end
function FlyoutListButton:GetTextureBattlepet()
	-- speciesID,customName,level,xp,maxXp,displayID,isFavorite,name,icon 
	local icon = select(9, C_PetJournal.GetPetInfoByPetID(self.value)) --_,_,_,_,_,_,_,_,icon = C_PetJournal.GetPetInfoByPetID(self.value) --
	return icon
end
function FlyoutListButton:UpdateTexture()
	local icon = self.icon
	if not(self.command) then
		icon:Hide()
		self.cooldown:Hide()
		self:SetNormalTexture(QUICK_SLOT)
		return
	end

	local texture = self:GetTexture()

	if (texture) then
		icon:SetTexture(texture)
		icon:SetVertexColor(1.0, 1.0, 1.0, 1.0)
		icon:Show()
		if FbcShowBorders then
			self:SetNormalTexture(QUICK_SLOT_2)
		else
			self:SetNormalTexture("") --remove border
		end
	else
		icon:SetTexture(QUESTION_MARK)
		icon:SetVertexColor(1.0, 1.0, 1.0, 0.5)
		icon:Show()
		self:SetNormalTexture(QUICK_SLOT_2)		
	end
end

--checked

function FlyoutListButton:UpdateCheckedSpell()
	local result = false
	local id = self.id
	if id then
		result = IsCurrentSpell(id) or IsAutoRepeatSpell(id)
	end
	self:SetChecked(result)
end
function FlyoutListButton:UpdateCheckedItem()
	self:SetChecked(IsCurrentItem(self.value))
end
function FlyoutListButton:UpdateCheckedMacro()
	self:SetChecked(false)
end
function FlyoutListButton:UpdateCheckedEquipmentset()
	self:SetChecked(false) --todo get somehow is equipped
end
function FlyoutListButton:UpdateCheckedBattlepet()
	self:SetChecked(self.value == C_PetJournal.GetSummonedPetGUID())
end

--equipped

function FlyoutListButton:UpdateEquippedItem()
	local border = self.border

	if IsEquippedItem(self.value) then
		border:SetVertexColor(0, 1.0, 0, 0.35)
		border:Show()
	else
		border:Hide()
	end
end
function FlyoutListButton:UpdateEquippedNotItem()
	self.border:Hide()
end

--cooldown

local function SetCooldownNormal(self)
	if ( self.cooldown.currentCooldownType ~= COOLDOWN_TYPE_NORMAL ) then
		self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
		self.cooldown:SetSwipeColor(0, 0, 0)
		self.cooldown:SetHideCountdownNumbers(false)
		self.cooldown.currentCooldownType = COOLDOWN_TYPE_NORMAL
	end
end
local function OnCooldownDone(self)
	self:SetScript("OnCooldownDone", nil)
	self:GetParent():UpdateCooldown()
end
function FlyoutListButton:UpdateCooldownSpell()
	local locStart, locDuration = GetSpellLossOfControlCooldown(self.value)
	local start, duration, enable = GetSpellCooldown(self.value)
	local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(self.value)
	
	if not(locStart) or not(start) then
		self:UpdateCooldownNone()
	elseif ( (locStart + locDuration) > (start + duration) ) then
		if ( self.cooldown.currentCooldownType ~= COOLDOWN_TYPE_LOSS_OF_CONTROL ) then
			self.cooldown:SetEdgeTexture("Interface\\Cooldown\\edge-LoC")
			self.cooldown:SetSwipeColor(0.17, 0, 0)
			self.cooldown:SetHideCountdownNumbers(true)
			self.cooldown.currentCooldownType = COOLDOWN_TYPE_LOSS_OF_CONTROL
		end
    
		CooldownFrame_Set(self.cooldown, locStart, locDuration, true, true)
		Lib_ClearChargeCooldown(self)
	else
		SetCooldownNormal(self)

		if( locStart > 0 ) then
			self.cooldown:SetScript("OnCooldownDone", OnCooldownDone )
		end

		if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
			Lib_StartChargeCooldown(self, chargeStart, chargeDuration)
		else
			Lib_ClearChargeCooldown(self)
		end

		CooldownFrame_Set(self.cooldown, start, duration, enable)
	end
end
function FlyoutListButton:UpdateCooldownItem()
	SetCooldownNormal(self)
	CooldownFrame_Set(self.cooldown, GetItemCooldown(self.value))
end
function FlyoutListButton:UpdateCooldownMacro()
	local index = self.subValue --GetMacroIndexByName(value)
	if (index) then
		local name, rank = GetMacroSpell(index)
		if (name) then
			local spell = FlyoutButton_GetFullSpellName(name, rank)
			local start, duration, enable = GetSpellCooldown(spell)
			if start then
				CooldownFrame_Set(self.cooldown, start, duration, enable)
			else
				self:UpdateCooldownNone()
			end
		end
	end
end
function FlyoutListButton:UpdateCooldownMacroText()
	SetCooldownNormal(self)
	local t = self.macroValues
	if t and type(t) == "table" then 
		if self.subValue == "spell" and t.value then
			local start, duration, enable = GetSpellCooldown(t.value)
			if start then
				local charges, maxCharges = GetSpellCharges(self.value)
				CooldownFrame_Set(self.cooldown, start, duration, enable, charges, maxCharges)
				return
			end			
		elseif self.subValue == "item" and t.id then
			CooldownFrame_Set(self.cooldown, GetItemCooldown(t.id))
			return
		end
	end
	self:UpdateCooldownNone()
end
function FlyoutListButton:UpdateCooldownNone()
	SetCooldownNormal(self)
	CooldownFrame_Set(self.cooldown, 0, 0, 0)
	self.cooldown:Hide()
end

--usable

function FlyoutListButton:GetUsableSpell()
	return IsUsableSpell(self.value) --self.id
end
function FlyoutListButton:GetUsableItem()
	return IsUsableItem(self.value) or PlayerHasToy(self.value)
end
function FlyoutListButton:GetUsableMacro()
	return true
end
function FlyoutListButton:GetUsableMacroText()
	local t = self.macroValues
	if t and type(t) == "table" then 
		if self.subValue == "spell" and t.value then
			return IsUsableSpell(t.value)
		elseif self.subValue == "item" and t.id then
			return IsUsableItem(t.id)
		end
	end
	return true
end
function FlyoutListButton:GetUsableEquipmentset()
	return not(InCombatLockdown())
end
function FlyoutListButton:GetUsableBattlepet()
	return true
end
function FlyoutListButton:UpdateUsable()
	local isUsable, notEnoughMana = self:GetUsable()

	local icon = self.icon
	local ntexture = self.ntexture
	if (isUsable) then
		icon:SetVertexColor(1.0, 1.0, 1.0)
		ntexture:SetVertexColor(1.0, 1.0, 1.0)
	elseif (notEnoughMana and not(self.subValue == "MOUNT")) then
		icon:SetVertexColor(0.5, 0.5, 1.0)
		ntexture:SetVertexColor(0.5, 0.5, 1.0)
	else
		icon:SetVertexColor(0.4, 0.4, 0.4)
		ntexture:SetVertexColor(1.0, 1.0, 1.0)
	end	
end

--update text

function FlyoutListButton:UpdateTextMacro()
	-- name, iconTexture, body, isLocal = GetMacroInfo("name" or macroSlot)
	name = GetMacroInfo(self.subValue) --by slot
	self.name:SetText(name)
end
function FlyoutListButton:UpdateTextEquipmentset()
	self.name:SetText(self.value)
end

--range

function FlyoutListButton:InRangeSpell()
	return IsSpellInRange(self.value, "target")
end
function FlyoutListButton:InRangeItem()
	return IsItemInRange(self.value, "target")
end
function FlyoutListButton:InRangeMacro()
	return nil
end
function FlyoutListButton:InRangeMacroText()
	local t = self.macroValues
	if t and type(t) == "table" then 
		if self.subValue == "spell" and t.value then
			return IsSpellInRange(t.value, "target")
		elseif self.subValue == "item" and t.id then
			return IsItemInRange(t.id, "target")
		end
	end
	return nil
end
function FlyoutListButton:InRangeEquipmentset()
	return nil
end
function FlyoutListButton:InRangeBattlepet()
	return nil
end
function FlyoutListButton:UpdateRange()
	local hotkey = self.hotkey
	local valid = self:InRange()
	if ( hotkey:GetText() == RANGE_INDICATOR ) then
		if ( valid == 0 ) then
			hotkey:Show()
			hotkey:SetVertexColor(1.0, 0.1, 0.1)
		elseif ( valid == 1 ) then
			hotkey:Show()
			hotkey:SetVertexColor(0.6, 0.6, 0.6)
		else
			hotkey:Hide()
		end
	else
		if ( valid == 0 ) then
			hotkey:SetVertexColor(1.0, 0.1, 0.1)
		else
			hotkey:SetVertexColor(0.6, 0.6, 0.6)
		end
	end
end

-- count

local function GetCountText(count)
	if (count > 999) then
		return "*"
	else
		return count
	end
end
function FlyoutListButton:UpdateCountSpell()
	local text = ""
	if self.id then
		local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(self.id)
		if (maxCharges) and (charges) and (maxCharges > 1) then
			text = GetCountText(charges)
		end
	end
	self.count:SetText(text)
	if (text) and (text ~= "") then
		self.count:Show()
	end
end
function FlyoutListButton:UpdateCountItem()
	local charges = GetItemCount(self.value, false, true)
	if charges > 1 then
		charges = GetCountText(charges)
	else
		charges = ""
	end
	self.count:SetText(charges)
	if (charges) and (charges ~= "") then
		self.count:Show()
	end
end
function FlyoutListButton:UpdateCountMacroText()
	local text = ""
	local t = self.macroValues
	if t and type(t) == "table" then 
		if self.subValue == "spell" and t.value then
			local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(t.value)
			if (maxCharges) and (charges) and (maxCharges > 1) then
				text = GetCountText(charges)
			end
		elseif self.subValue == "item" and t.id then
			local charges = GetItemCount(t.id, false, true)
			if charges > 1 then
				text = GetCountText(charges)
			else
				text = ""
			end
		end
	end
	self.count:SetText(text)
	if (text) and (text ~= "") then
		self.count:Show()
	end
end

-- glow

function FlyoutListButton:SpellGlowShow(...)
	local arg1 = ...
	if self.id and self.id == arg1 then
		Lib_ActionButton_ShowOverlayGlow(self)
	end
end
function FlyoutListButton:MacroGlowShow(...)
	local arg1 = ...
	if self.subValue  then
		local _, _, spellId = GetMacroSpell(self.subValue) --index
		if spellId and spellId == arg1 then
			Lib_ActionButton_ShowOverlayGlow(self)
		end
	end
end
function FlyoutListButton:MacroTextGlowShow(...)
	local arg1 = ...
	local t = self.macroValues
	if t and type(t) == "table" then 
		if self.subValue == "spell" then
			local spellId = t.id
			if spellId and spellId == arg1 and IsSpellOverlayed(spellId) then
				Lib_ActionButton_ShowOverlayGlow(self)
			end
		end
	end
end
function FlyoutListButton:SpellGlowHide(...)
	local arg1 = ...
	if self.id and self.id == arg1 then
		Lib_ActionButton_HideOverlayGlow(self)
	end
end
function FlyoutListButton:MacroGlowHide(...)
	local arg1 = ...
	if self.subValue then
		local _, _, spellId = GetMacroSpell(self.subValue) --index
		if spellId and spellId == arg1 then
			Lib_ActionButton_HideOverlayGlow(self)
		end
	end
end
function FlyoutListButton:MacroTextGlowHide(...)
	local arg1 = ...
	local t = self.macroValues
	if t and type(t) == "table" then 
		if self.subValue == "spell" then
			local spellId = t.id
			if spellId and spellId == arg1 then
				Lib_ActionButton_HideOverlayGlow(self)
			end
		end
	end
end

-- click

function FlyoutListButton:Click(button)
	BattlePetTooltip:Hide()
	if (self.command == "battlepet") and self.value then
		C_PetJournal.SummonPetByGUID(self.value)
	--elseif (self.command == "item") and (self.value and PlayerHasToy(self.value)) then
	--	UseToy(self.value)
	end
end

-- common

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

function FlyoutListButton:Set(command, value, subValue, id, macroValues)
	--print("Set", command, value, subValue, id)
	self.command, self.value, self.subValue, self.id = command, value, subValue, id
	self.macroValues = deepcopy(macroValues)

	self.macroSpellName = nil
	self.name:SetText("")
	self.count:SetText("")
	self:SetAttribute("type", "")
	self:SetAttribute("spell", "")
	self:SetAttribute("item", "")
	self:SetAttribute("macro", "")
	self:SetAttribute("macrotext", "")
	self:SetAttribute("clickbutton", "")
	self:SetAttribute("_onclick", "")

	if command then
		if (command == "spell") then
			self:SetAttribute("type", command)
			for k, v in pairs(preset_by_spell) do
				self[k] = self[v]
			end

			self:SetAttribute(command, value) --id
		elseif command == "item" then
			for k, v in pairs(preset_by_item) do
				self[k] = self[v]
			end

			local itemname = GetItemInfo(value)
			self:SetAttribute("type", command)
			self:SetAttribute("item", itemname)
		elseif (command == "macro") then
			for k, v in pairs(preset_by_macro) do
				self[k] = self[v]
			end

			self:SetAttribute("type", command)
			self:SetAttribute(command, value)
		elseif (command == "equipmentset") then
			for k, v in pairs(preset_by_equipmentset) do
				self[k] = self[v]
			end

			self:SetAttribute("type", "macro")
			self:SetAttribute("macrotext", "/equipset "..value)
		elseif command == "battlepet" then
			for k, v in pairs(preset_by_battlepet) do
				self[k] = self[v]
			end

			self:SetAttribute("type", "click")
			self:SetAttribute("clickbutton", self)
			--local speciesID, customName, level, xp, maxXp, displayID, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(value)
		elseif command == "macrotext" then
			-- value is macro text, subValue is spell name, id is tooltip
			for k, v in pairs(preset_by_macrotext) do
				self[k] = self[v]
			end
			
			self:SetAttribute("type", "macro")
			self:SetAttribute("macro", nil)
			self:SetAttribute(command, value)
		else
			self:ClearHandlers()
		end
	else
		self:ClearHandlers()
	end
	
	self:UpdateButton()
	self:Show()
	if command then
		self:RegisterEvents()
	else
		self:UnregisterEvents()
	end
end

function FlyoutListButton:PreClick(button)
	if InCombatLockdown() then
		ClearCursor()
		return
	end
	
	StoredCursor = {}
	local command, value, subValue, id = FlyoutButton_GetCursorValues()
	if button == "LeftButton" then
		if command then
			StoredCursor.command, StoredCursor.value, StoredCursor.subValue, StoredCursor.id = command, value, subValue, id
			self:SetAttribute("type", nil) --to avoid click event (spell cast)
		end
	elseif button == "RightButton" and FbcRightClickSet then
		StoredCursor.prevCommand = self:GetAttribute("type")
		self:SetAttribute("type", nil) --to avoid click event (spell cast)
	end
end

function FlyoutListButton:PostClick(button)
	if FbcLeftClickSet and self:GetAttribute("override_pending") 
	and (self.actnBtn:GetAttribute("fbc_tooltip_source") == self:GetName()) then
		FlyoutArrowButton_SetActionButtonTexture(self.actnBtn.icon)
	end
		
	if InCombatLockdown() then
		return
	end
	
	if button == "LeftButton" and StoredCursor.command then
		FlyoutButton_SetCursor(StoredCursor.command, StoredCursor.value, StoredCursor.subValue, StoredCursor.id)
		StoredCursor = {}
		self:OnReceiveDrag()
	end
	
	if (self:GetAttribute("override_pending") and (self.actnBtn:GetAttribute("fbc_tooltip_source") == self:GetName()))
	or (button == "RightButton" and FbcRightClickSet) then
		self:SetAttribute("override_pending", nil)
		local actnBtn = self.actnBtn
		actnBtn:SetAttribute("fbc_tooltip_source", nil)
		if StoredCursor.prevCommand then
			self:SetAttribute("type", StoredCursor.prevCommand)
		end
		local actBtnName = actnBtn:GetName()
		--print("Post click", actBtnName)
		if self.command then
			-- frame._state_action for BT4 ?
			if actBtnName:match("^ButtonForge%d+$") and BFButton and BFButton.OnReceiveDrag then
				FlyoutButton_SetCursor(self.command, self.value, self.subValue, self.id)
				BFButton.OnReceiveDrag(actnBtn)
				ClearCursor()
			elseif actBtnName:match("^BT4Button%d+$") or actBtnName:match("^ElvUI_Bar%dButton%d+$") then
				local atype, action = actnBtn:GetAction()
				if atype == "action" then
					FlyoutButton_SetCursor(self.command, self.value, self.subValue, self.id)
					PlaceAction(action)
					actnBtn:UpdateAction(true)
					ClearCursor()
				end
			elseif actBtnName:find("TinyExtraBars") and actnBtn.OnReceiveDrag then
				FlyoutButton_SetCursor(self.command, self.value, self.subValue, self.id)
				actnBtn:OnReceiveDrag()
				ClearCursor()
			elseif actnBtn.action and actnBtn.action <= 120 then
				FlyoutButton_SetCursor(self.command, self.value, self.subValue, self.id)
				PlaceAction(actnBtn.action)
				ActionButton_Update(actnBtn) 				
				ClearCursor()
			end
		end
		self:SetChecked(nil)
	else
		self:SetAttribute("override_pending", nil)
	end
end

function FlyoutListButton:SaveCommand(command, value, subValue, id, macroValues)
	local actnBtnName = self.actnBtnName
	local currentSet = FlyoutButton_GetSpecialization()
	--print("SaveCommand", actnBtnName, currentSet, self.index)
	if command then
		FlyoutButtonES:Set({actnBtnName, currentSet, self.index, "command"}, command)
		FlyoutButtonES:Set({actnBtnName, currentSet, self.index, "value"}, value)
		FlyoutButtonES:Set({actnBtnName, currentSet, self.index, "subValue"}, subValue)
		FlyoutButtonES:Set({actnBtnName, currentSet, self.index, "id"}, id)
		FlyoutButtonES:Set({actnBtnName, currentSet, self.index, "macroValues"}, macroValues)
	else
		--empty tables to nil
		FlyoutButtonES:Set({actnBtnName, currentSet, self.index}, nil)
	end
end

function FlyoutListButton:OnReceiveDrag()
	if InCombatLockdown() or not(FbcSettingsMode) then
		ClearCursor()
		return
	end

	local command, value, subValue, id = FlyoutButton_GetCursorValues()

	ClearCursor()
	if self.command then
		FlyoutButton_SetCursor(self.command, self.value, self.subValue, self.id)
	end

	self:Set(command, value, subValue, id)
	self:SaveCommand(command, value, subValue, id)
	
	self:GetParent():GetParent():UpdateArrow()
end

function FlyoutListButton:OnDragStart()
	if InCombatLockdown() or not(FbcSettingsMode) then
		return
	end
	
	local arrowBtn = self:GetParent():GetParent()

	if self.command then
		FlyoutButton_SetCursor(self.command, self.value, self.subValue, self.id)
	end
	
	FlyoutButtonES:Set({self.actnBtnName, FlyoutButton_GetSpecialization(), self.index}, {})
	
	self:Set(nil, nil, nil, nil)
	self:SaveCommand(nil, nil, nil, nil)
	
	arrowBtn:UpdateArrow()
end

function FlyoutListButton:HideButton()
	self.tooltipValue = nil
	self:SetAttribute("type", "none")
	self.icon:Hide()
	self.cooldown:Hide()
	self.border:Hide()
	self.count:Hide()
	self.name:SetText("")
	self.hotkey:Hide()
	self:SetNormalTexture(QUICK_SLOT)
	self:SetChecked(0)
	self:Hide()
end

function FlyoutListButton:UpdateButton()
	self:SetTooltip()
	self:UpdateTexture()
	self:UpdateCooldown()
	self:UpdateChecked()
	self:UpdateEquipped()
	self:UpdateUsable()
	self:UpdateText()
	self:UpdateCount()
	if self.command then
		self.rangeTimer = -1
	else
		self.rangeTimer = nil
	end
end

local function EventCooldownUpdate(self, ...)
	self:UpdateCooldown()
end

local function EventCheckedUpdate(self, ...)
	self:UpdateChecked()
end

local function EventEquippedUpdate(self, ...)
	self:UpdateEquipped()
	self:UpdateText()
	self:UpdateCooldown()
	self:UpdateChecked()
end

local function EventUsableUpdate(self, ...)
	self:UpdateUsable()
	self:UpdateText()
	self:UpdateCooldown()
end

local function EventMacroUpdate(self, ...)
	if InCombatLockdown() then
		return
	end

	if self.command == "macro" then
		--command = "macro", value = macro name, subValue = macro index
		local command, subValue = self.command, self.subValue
		local value = GetMacroInfo(subValue)
		self:Set(command, value, subValue, nil)
		self:SaveCommand(command, value, subValue, nil)
		self.arrBtn:UpdateArrow()
	end
end

local function EventRangeUpdate(self, ...)
	self:UpdateRange()
	self.rangeTimer = TOOLTIP_UPDATE_TIME
end

local function EventChargesUpdate(self, ...)
	self:UpdateCount()
end

local function EventSpellsChanged(self, ...)
	self:UpdateButton()
end

local function EventGlowShow(self, ...)
	self:GlowShow(...)
end

local function EventGlowHide(self, ...)
	self:GlowHide(...)
end

local function EventLeavingCombat(self, ...)
	if self:GetAttribute("override_pending") then
		self:PostClick(nil) --"RightButton"
	end
end

function FlyoutListButton:OnUpdate(elapsed)
	local rangeTimer = self.rangeTimer
	if ( rangeTimer ) then
		rangeTimer = rangeTimer - elapsed

		if ( rangeTimer <= 0 ) then
			self:UpdateRange()
			rangeTimer = TOOLTIP_UPDATE_TIME
		end
		
		self.rangeTimer = rangeTimer
	end
end

function FlyoutListButton:OnEvent(event, ...)
	--print("flb "..tostring(event))
	if self.EventHandlersTable[event] then
		self.EventHandlersTable[event](self, ...)
	end
end

function FlyoutListButton:RegisterEvents()
	--event table
	self.EventHandlersTable = {
		--cooldown
		["SPELL_UPDATE_COOLDOWN"] 			= EventCooldownUpdate,
		["BAG_UPDATE_COOLDOWN"] 			= EventCooldownUpdate,
		["ACTIONBAR_UPDATE_COOLDOWN"] 		= EventCooldownUpdate,
		["UPDATE_SHAPESHIFT_COOLDOWN"] 		= EventCooldownUpdate,
		["LOSS_OF_CONTROL_UPDATE"]			= EventLossOfControlUpdate,
		--checked
		["TRADE_SKILL_SHOW"] 				= EventCheckedUpdate,
		["TRADE_SKILL_CLOSE"] 				= EventCheckedUpdate,
		["ARCHAEOLOGY_TOGGLE"] 				= EventCheckedUpdate,
		["ARCHAEOLOGY_CLOSED"] 				= EventCheckedUpdate,
		["COMPANION_UPDATE"] 				= EventCheckedUpdate,
		["CURRENT_SPELL_CAST_CHANGED"] 		= EventCheckedUpdate,
		["ACTIONBAR_UPDATE_STATE"] 			= EventCheckedUpdate,
		["PLAYER_ENTER_COMBAT"] 			= EventCheckedUpdate,
		["PLAYER_LEAVE_COMBAT"] 			= EventCheckedUpdate,
		["START_AUTOREPEAT_SPELL"] 			= EventCheckedUpdate,
		["STOP_AUTOREPEAT_SPELL"] 			= EventCheckedUpdate,
		["UPDATE_BONUS_ACTIONBAR"] 			= EventCheckedUpdate,
		["ACTIONBAR_PAGE_CHANGED"] 			= EventCheckedUpdate,
		--equipment
		["PLAYER_EQUIPMENT_CHANGED"] 		= EventEquippedUpdate,
		["BAG_UPDATE"] 						= EventEquippedUpdate,
		--usable
		["BAG_UPDATE"] 						= EventUsableUpdate,
		--["UNIT_INVENTORY_CHANGED"] 		= EventUsableUpdate,
		["SPELL_UPDATE_USABLE"] 			= EventUsableUpdate,
		["PLAYER_CONTROL_LOST"] 			= EventUsableUpdate,
		["PLAYER_CONTROL_GAINED"] 			= EventUsableUpdate,
		["UPDATE_BONUS_ACTIONBAR"] 			= EventUsableUpdate,
		["ACTIONBAR_UPDATE_USABLE"] 		= EventUsableUpdate,
		["VEHICLE_UPDATE"] 					= EventUsableUpdate,
		["UPDATE_WORLD_STATES"] 			= EventUsableUpdate,
		--macro
		["UPDATE_MACROS"]					= EventMacroUpdate,
		--range
		["PLAYER_TARGET_CHANGED"]			= EventRangeUpdate,
		--charges
		["SPELL_UPDATE_CHARGES"]			= EventChargesUpdate,
		--spells
		["ACTIVE_TALENT_GROUP_CHANGED"]		= EventSpellsChanged,
		["SPELLS_CHANGED"]					= EventSpellsChanged,
		["LEARNED_SPELL_IN_TAB"] 			= EventSpellsChanged,
		["PLAYER_GUILD_UPDATE"] 			= EventSpellsChanged,
		["PLAYER_SPECIALIZATION_CHANGED"] 	= EventSpellsChanged,
		["COMPANION_LEARNED"] 				= EventSpellsChanged,
		["UPDATE_SHAPESHIFT_FORM"] 			= EventSpellsChanged,
		["PET_JOURNAL_LIST_UPDATE"]			= EventSpellsChanged,
		["TOYS_UPDATED"]					= EventSpellsChanged, -- here?
		--glow
		["SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"] = EventGlowShow,
		["SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"] = EventGlowHide,
		--regen to save overrides
		["PLAYER_REGEN_ENABLED"] 			= EventLeavingCombat,
	}
	
	for k, _ in pairs(self.EventHandlersTable) do
		self:RegisterEvent(k)
	end

	self:SetScript("OnEvent", FlyoutListButton.OnEvent)
	self:SetScript("OnUpdate", FlyoutListButton.OnUpdate)
end

function FlyoutListButton:UnregisterEvents()
	if self.EventHandlersTable then
		for k, _ in pairs(self.EventHandlersTable) do
			self:UnregisterEvent(k)
		end
	end
	self.EventHandlersTable = {}
	self.rangeTimer = nil
	self.hotkey:Hide()
end

