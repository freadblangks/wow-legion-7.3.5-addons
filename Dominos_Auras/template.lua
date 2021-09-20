local Goranaws_AuraTemplate = {}
Goranaws_TemplateManager = {}
local Masque = LibStub('Masque', true)
function Goranaws_TemplateManager.Merge(source, destination)
	if not destination then
		destination = {}
	end
	if not source then
		return destination
	end
	for i, b in pairs(source) do
		if (type(b) == 'table') then
			destination[i] = Merge(b, destination[i])
		else
			destination[i] = b
		end
	end
	return destination
end
local allOverlays = {}
function Goranaws_TemplateManager:New(self, kind)
	Goranaws_TemplateManager.Merge(Goranaws_AuraTemplate, self)
	self.kind = kind
	if Masque then
		self.masque = self.masque or Masque:Group("Dominos", kind)
	end
	self.allOverlays = self.allOverlays or {}
	self:CreateHeader(kind)
	self:GetOverlays()
	self:Layout()
	self:UpdateFilter()
	self:UpdateTarget()
	self:UpdateAuras()
end
local temp = Goranaws_AuraTemplate
function temp:NumButtons()
	return self:NumColumns() * self:NumRows()
end
function temp:NumColumns()
	return self.sets.columns
end
function temp:NumRows()
	return self.sets.rows
end
function temp:UpdateAuraLayout(spacing, cols, rows, LR, TB, method, direction)
	local self = self.headerAura
	local base = (30 + spacing)
	self:SetAttribute("minWidth", base);
	self:SetAttribute("minHeight", base);
	self:SetAttribute("wrapAfter", cols);
	self:SetAttribute("maxWraps", rows);
	local hori, vert
	if not LR then
		vert = "Left"
		self:SetAttribute("xOffset", base);
		self:SetAttribute("yOffset", 0);
	else
		vert = "Right"
		self:SetAttribute("xOffset", -base);
		self:SetAttribute("yOffset", 0);
	end
	if not TB then
		hori = "Top"
		self:SetAttribute("wrapXOffset", 0);
		self:SetAttribute("wrapYOffset", -base);
	else
		hori = "Bottom"
		self:SetAttribute("wrapXOffset", 0);
		self:SetAttribute("wrapYOffset", base);
	end
	self:SetAttribute("point", hori..vert);
	local items = {["1"] = "Time", ["2"] = "Index", ["3"] = "Name"}
	local m = items[tostring(method)] or method
	self:SetAttribute("sortMethod", string.upper(m)); -- INDEX or NAME or TIME
	self:SetAttribute("sortDirection", direction); -- - to reverse
end
function temp:CreateHeader()
	self.headerAura = self.headerAura or CreateFrame("Frame", "Goranaws_"..self.kind.."_Bar", self, "SecureAuraHeaderTemplate")
	self.total = self.total or 0
	RegisterUnitWatch(self.headerAura)
	self.headerAura:SetScript("OnShow", function()
		self:UpdateAuras()
	end)
	self:SetScript("OnEvent", function(s, event, ...)
		self:OnEvent(event, ...)
	end)
	self.headerAura:SetAttribute("template", "GoranawsAuraTemplate"); -- must be the template name of your XML
	local headerAura = self.headerAura
	self.headerAura.UpdateLayout = function()
		if self.sets then
			local sets = self.sets
			local dir = "+"
			if (sets.direction == 1) or (sets.direction == true) then
				dir = "-"
			end
			self:UpdateAuraLayout(sets.spacing, sets.columns, sets.rows, sets.isRightToLeft, sets.isBottomToTop, sets.method, dir)
		else
			self:UpdateAuraLayout(3, "TopLeft", 4, 4, true, true,"Time", "+")
		end
	end
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("UNIT_TARGET");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterUnitEvent("UNIT_AURA", "player", "vehicle");
	self:RegisterEvent("GROUP_ROSTER_UPDATE");
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
	self.headerAura:UpdateLayout(3, "TopLeft", 4, 4, true, true,"Time", "+")
	self:UpdateAuras()
end
local index = 1
local function GetOverlay(self)
	if _G["Goranaws_OverlayButton_"..index] then
		index = index + 1
		return GetOverlay(self)
	end
	local overlay = CreateFrame("Button", "Goranaws_OverlayButton_"..index , self, "GoranawsOverlayAuraTemplate")
	overlay:EnableMouse(false)
	if self.masque then
		self.masque:AddButton(overlay, {Icon = overlay.icon, Cooldown = overlay.cooldown})
	end
	
	overlay.cooldown:SetHideCountdownNumbers(true)
	overlay.cooldown:SetAllPoints(overlay.icon)
	-- overlay.txt:SetPoint("Top", overlay.cooldown, "Bottom", 0, -10)
	tinsert(self.allOverlays, overlay)
	index = index + 1
	return overlay
end
function temp:GetOverlays()
	self.numoverButtons = self.numoverButtons or 0
	local numButtons = self:NumButtons()
	if (numButtons > self.numoverButtons) then
		for i = self.numoverButtons+1, numButtons do
			local overlay = GetOverlay(self)
		end
		self.numoverButtons = self:NumButtons()
	end
end
function temp:ResetOverlay(overlay)
	if overlay and overlay:IsShown() then
		overlay:ClearAllPoints()
		overlay.icon:SetTexture("");
		overlay.cooldown:SetCooldown(0, 0)
		overlay.cooldown:Hide()
		overlay.txt:SetText("");
		overlay:Hide()
		overlay.name, overlay.Icon, overlay.count, overlay.debuffType, overlay.dura, overlay.expirationTime = nil, nil, nil, nil, nil, nil
	end
end




--[[
Cooldown:SetCooldown(start, duration[, modRate]) - Shows a cooldown animation.
duration = Cooldown:GetCooldownDuration() - Returns the duration currently shown by the cooldown frame in milliseconds
startTime, duration = Cooldown:GetCooldownTimes() - Returns the starting time and duration of the cooldown frame in milliseconds
Cooldown:SetReverse(boolean) - Controls the direction of the cooldown animation.
Cooldown:SetBlingDuration(duration) - (New in 5.2)
Cooldown:GetDrawBling() - This function is not yet documented
enabled = Cooldown:GetDrawEdge() - Returns whether a bright line should be drawn on the moving edge of the cooldown animation
Cooldown:GetDrawSwipe() - This function is not yet documented
enabled = Cooldown:GetReverse() - Returns whether the bright and dark portions of the cooldown animation should be inverted
Cooldown:SetBlingTexture() - This function is not yet documented
Cooldown:SetCooldownDuration() - This function is not yet documented
Cooldown:SetCooldownUNIX() - This function is not yet documented
Cooldown:SetDrawBling() - This function is not yet documented
Cooldown:SetDrawEdge(enable) - Sets whether a bright line should be drawn on the moving edge of the cooldown animation
Cooldown:SetDrawSwipe() - This function is not yet documented
Cooldown:SetEdgeTexture() - This function is not yet documented
Cooldown:SetHideCountdownNumbers(hide) - Show or hide text cooldown timer
Cooldown:SetSwipeColor() - This function is not yet documented
Cooldown:SetSwipeTexture() - This function is not yet documented
--]]

local r, b, g, a = 1,1,1,1
local texture = "Interface\\Addons\\Dominos_Auras\\cooldown"

function temp:ToggleCoolDownTexture()
	for i, overlay in pairs(self.allOverlays) do
		overlay.cooldown:SetSwipeColor(r, b, g, a ) 
		overlay.cooldown:SetSwipeTexture(texture)
		if self.sets.hideCooldown then
			overlay.cooldown:SetDrawSwipe(false)
			overlay.cooldown:SetDrawEdge(false)
		else
			overlay.cooldown:SetDrawSwipe(true)
			overlay.cooldown:SetDrawEdge(false)
		end
		
		if self.sets.hideCooldownText or  _G["OmniCC"] then
			overlay.cooldown:SetHideCountdownNumbers(true)
		else
			overlay.cooldown:SetHideCountdownNumbers(false)
		end
		
	end
end

function temp:UpdateAuras()
	self.total = 1
	local t = 1
	for i, overlay in pairs(self.allOverlays) do
		local aura = self.headerAura:GetAttribute("child" .. i)
		if aura and aura:IsShown() then
			overlay:SetAllPoints(aura)
			local name, _, icon, count, debuffType, dura, expirationTime = UnitAura(self.headerAura:GetAttribute("unit"), aura:GetID(), self.headerAura:GetAttribute("filter"))
			if name then
				if (name ~= overlay.name) or (icon ~= overlay.Icon) or (count ~= overlay.count) or (debuffType ~= overlay.debuffType) or (dura ~= overlay.dura) or (expirationTime ~= overlay.expirationTime) then
					overlay.icon:SetTexture(icon);
					if (dura or expirationTime) and ((dura>0) or (expirationTime>0)) then
						overlay.cooldown:SetCooldown(expirationTime - dura, dura);
					else
						overlay.cooldown:SetCooldown(0, 0)
						overlay.cooldown:Hide()
					end
					if not (count>1)then count=""end
					overlay.txt:SetText(count);
					overlay:Show()
				end
				overlay.name, overlay.Icon, overlay.count, overlay.debuffType, overlay.dura, overlay.expirationTime = name, icon, count, debuffType, dura, expirationTime
			else
				self:ResetOverlay(overlay)
				if not aura then
					break
				end
			end
		else
			self:ResetOverlay(overlay)
			if not aura then
				break
			end
		end
	end

end
function temp:UpdateFilter()
	self.headerAura:SetAttribute("filter", self:GetFilter()); -- to activate UNITAURA event refresh
	self:UpdateAuras()
end
function temp:GetTarget()
	return self.sets.target or "player"
end
function temp:UpdateTarget()
	self:RegisterUnitEvent("UNIT_AURA", self:GetTarget());
	self.headerAura:SetAttribute("unit", self:GetTarget())
	self:UpdateAuras()
end
function temp:SetTarget(unit)
	self.sets.target = unit or "player"
	self:UpdateTarget()
end
function temp:GetSpacing()
	return self.sets.spacing
end
function temp:SetSpacing(spacing)
	self.sets.spacing = spacing
	self:Layout()
end
function temp:OnEvent(event, ...)
	self:UpdateAuras()
end
function temp:Layout()
	if not InCombatLockdown() then
		local sets = self.sets
		local w,h = 30, 30
		local newWidth = max((((30 + sets.spacing) * sets.columns) - sets.spacing) +(sets.padding*2), 8)
		local newHeight = max((((30 + sets.spacing) * sets.rows) - sets.spacing) +(sets.padding*2), 8)
		self:SetSize(newWidth, newHeight)
		local hori, vert, padhori, padvert = "Left", "Top", sets.padding, -sets.padding
		if  sets.isRightToLeft then
			hori, padhori = "Right", -sets.padding
		end
		if sets.isBottomToTop then
			vert, padvert = "Bottom", sets.padding
		end
		self.headerAura:ClearAllPoints()
		self.headerAura:SetPoint(vert..hori, self, vert..hori, padhori, padvert)
		local dir = "+"
		if (sets.direction == 1) or (sets.direction == true) then
			dir = "-"
		end
		self:UpdateAuraLayout(sets.spacing, sets.columns, sets.rows, sets.isRightToLeft, sets.isBottomToTop, sets.method, dir)
		self:GetScript("OnEvent")()
		self:GetOverlays()
		if 	self.HideBlizz then
			self:HideBlizz()
		end
		self:RegisterUnitEvent("UNIT_AURA", self:GetTarget());
		self:ToggleCoolDownTexture()
	end
end
local function NewSlider(panel, name, min, max, arg)
	local slider = panel:NewSlider({
		name = name,
		min = min,
		max = max,
		get = function(self) --Getter
			return panel.owner.sets[arg]
		end,
		set = function(self) --Setter
			local owner = panel.owner
			owner.sets[arg] = self:GetValue()
			owner:Layout()
			return owner.sets[arg]
		end,
	})
end
local function NewCheckButton(panel, name, arg)
	local c = panel:NewCheckButton{
		name = name,
		get = function() return panel.owner.sets[arg] end,
		set = function(self, enable)
			panel.owner.sets[arg] = self:GetChecked()
			panel.owner:Layout()
		end
	}
end

local function NewDropdown(panel, name, arg, items)
	local c = panel:NewDropdown{
		name = name,
		get = function()
			return panel.owner.sets[arg]
		end,
		set = function(_, value)
			panel.owner.sets[arg] = value
			panel.owner:Layout()
		end,
		items = items
	}
end
local function AddLayoutPanel(menu)
	local p = menu:NewPanel("外觀")
	NewCheckButton(p, "左右方向對調", "isRightToLeft")
	NewCheckButton(p, "上下方向對調", "isBottomToTop")
	NewCheckButton(p, "隱藏倒數旋轉動畫", "hideCooldown")
	NewCheckButton(p, "隱藏倒數時間文字", "hideCooldownText")


	
	
	p:NewScaleSlider()
	NewSlider(p, "間距", -13, 32, "padding")
	NewSlider(p, "行數", 1, 20, "columns")
	NewSlider(p, "列數", 1, 20, "rows")
	p:NewSpacingSlider()
	p:NewFadeSlider()
	p:NewOpacitySlider()
end
--viable unit check
local base = {
	"player",
	"target",
	"pet",
	"focus",
	"arena%d+",
	"boss%d+",
	"party%d+",
	"partypet%d+",
	"raid%d+",
	"raidpet%d+",
	"mouseover",
}
local max = {
	raid = 40,
	raidpet = 40,
	arena = 4,
	boss = 4,
	party = 4,
	partypet = 4,
}
local function IsViable(unit)
	local keep = unit
	unit = string.lower(unit)
	local count = 0
	if string.match (unit, "target" , 2) then
		_, count = string.gsub(string.sub (unit, 2, string.len(unit)), "target", "")
		if (unit == "player") and count > 0 then
			return nil
		else
			unit = string.gsub (unit, "target", "", count)
		end
	end
	local can
	for test, match in pairs(base) do
		if string.match(string.gsub(match, "%d+", ""), string.gsub(unit, "%d+", "") ) then
			hasLimit = max[string.gsub( unit, "%d+", "" ) ]
			if hasLimit then
				local o = string.gsub(unit, string.gsub(unit, "%d+", ""),"")
				o = tonumber(o)
				if o and ( (o < 1) or (o>hasLimit) ) then
					return nil
				end
			end
			return string.lower(keep)
		end
	end
end
local hideBlizz
local function HideBlizz(panel)
	if not hideBlizz then
		NewCheckButton(panel, "停用遊戲內建的增益效果", "hideBlizz")
		hideBlizz = true
	end
end
local function AddAdvancedOptions(menu)
	local L = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')
	local panel = menu:NewPanel(L.Advanced)
	HideBlizz(panel)
	panel:NewClickThroughCheckbox()
	panel:NewShowInOverrideUICheckbox()
	panel:NewShowInPetBattleUICheckbox()
	panel.TargetingEditBox = panel:NewTextInput{
		name = "監控對象",
		multiline = true,
		width = 290,
		height = 64,
		get = function() return panel.owner:GetTarget() or '' end,
		set = function(self, value)
			local text = value
			if IsViable(text) then
				panel.owner:SetTarget(text ~= '' and text or nil)
			else
				print("無效的單位："..text)
			end
			panel.TargetingEditBox.editBox:ClearFocus()
		end
	}
	local editBox = panel.TargetingEditBox.editBox
	editBox:SetScript('OnShow',            function(self) self:SetText(self.owner:GetSavedValue() or '') end)
	editBox:SetScript('OnEscapePressed',   function(self) self:ClearFocus() end)
	editBox:SetScript('OnEnterPressed',    function(self) self:Save() self:ClearFocus() end)
	editBox:SetScript('OnTextChanged', nil)
	editBox:SetScript('OnEditFocusGained', function(self) self:HighlightText() self.owner:OnEditFocusGained() end)
	editBox:SetScript('OnEditFocusLost',   function(self) self:HighlightText(0, 0) self:Save() end)
end
local function AddSortPanel(self)
	local p = self:NewPanel("排序")
	NewCheckButton(p, "反向排序", "direction")
	NewDropdown(p, "排序方式", "method", {
		{text = "時間", value = '1'},
		{text = "索引", value = '2'},
		{text = "名稱", value = '3'},
	})
	return p
end
function temp:CreateMenu()
	local menu = Dominos:NewMenu(self.id)
	AddLayoutPanel(menu)
	AddSortPanel(menu)
	AddAdvancedOptions(menu)
	self.menu = menu
end
