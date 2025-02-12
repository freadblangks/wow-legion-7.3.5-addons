--[[
	Action Button.lua
		A Dominos action button
--]]

local AddonName, Addon = ...
local KeyBound = LibStub('LibKeyBound-1.0')
local Tooltips = Addon:GetModule('Tooltips')

local ActionButton = Addon:CreateClass('CheckButton', Addon.BindableButton)
local HiddenFrame = CreateFrame('Frame'); HiddenFrame:Hide()

ActionButton.unused = {}
ActionButton.active = {}

local function CreateActionButton(id)
	local name = ('%sActionButton%d'):format(AddonName, id)

	return CreateFrame('CheckButton', name, nil, 'ActionBarButtonTemplate')
end

local function GetOrCreateActionButton(id)
	if id <= 12 then
		local button = _G[('ActionButton%d'):format(id)]

		button.buttonType = 'ACTIONBUTTON'

		return button
	elseif id <= 24 then
		return CreateActionButton(id - 12)
	elseif id <= 36 then
		return _G[('MultiBarRightButton%d'):format(id - 24)]
	elseif id <= 48 then
		return _G[('MultiBarLeftButton%d'):format(id - 36)]
	elseif id <= 60 then
		return _G[('MultiBarBottomRightButton%d'):format(id - 48)]
	elseif id <= 72 then
		return _G[('MultiBarBottomLeftButton%d'):format(id - 60)]
	else
		return CreateActionButton(id - 60)
	end
end

--constructor
function ActionButton:New(id)
	local button = self:Restore(id) or self:Create(id)

	if button then
		button:SetAttribute('showgrid', 0)
		button:SetAttribute('action--base', id)
		button:SetAttribute('_childupdate-action', [[
			local state = message
			local overridePage = self:GetParent():GetAttribute('state-overridepage')
			local newActionID

			if state == 'override' then
				newActionID = (self:GetAttribute('button--index') or 1) + (overridePage - 1) * 12
			else
				newActionID = state and self:GetAttribute('action--' .. state) or self:GetAttribute('action--base')
			end

			if newActionID ~= self:GetAttribute('action') then
				self:SetAttribute('action', newActionID)
				self:CallMethod('UpdateState')
			end
		]])

		Addon.BindingsController:Register(button, button:GetName():match(AddonName .. 'ActionButton%d'))
		Addon:GetModule('Tooltips'):Register(button)

		--get rid of range indicator text
		local hotkey = button.HotKey
		if hotkey:GetText() == _G['RANGE_INDICATOR'] then
			hotkey:SetText('')
		end

		button:UpdateGrid()
		button:UpdateMacro()
		button:UpdateShowEquippedItemBorders()

		self.active[id] = button
	end

	return button
end

function ActionButton:Create(id)
	local button = GetOrCreateActionButton(id)

	if button then
		self:Bind(button)

		--this is used to preserve the button's old id
		--we cannot simply keep a button's id at > 0 or blizzard code will take control of paging
		--but we need the button's id for the old bindings system
		button:SetAttribute('bindingid', button:GetID())
		button:SetID(0)

		button:ClearAllPoints()
		button:SetAttribute('useparent-actionpage', nil)
		button:SetAttribute('useparent-unit', true)
		button:EnableMouseWheel(true)
		button:HookScript('OnEnter', self.OnEnter)

		Addon:GetModule('ButtonThemer'):Register(button, '快捷列')
	end

	return button
end

function ActionButton:Restore(id)
	local button = self.unused[id]

	if button then
		self.unused[id] = nil

		button:LoadEvents()
		ActionButton_UpdateAction(button)
		button:Show()

		self.active[id] = button
		return button
	end
end

--destructor
do
	local HiddenActionButtonFrame = CreateFrame('Frame')
	HiddenActionButtonFrame:Hide()

	function ActionButton:Free()
		local id = self:GetAttribute('action--base')

		self.active[id] = nil

		Addon:GetModule('Tooltips'):Unregister(self)
		Addon.BindingsController:Unregister(self)

		self:SetParent(HiddenActionButtonFrame)
		self:Hide()

		self.unused[id] = self
	end
end

--these are all events that are registered OnLoad for action buttons
function ActionButton:LoadEvents()
	ActionBarActionEventsFrame_RegisterFrame(self)
end

--keybound support
function ActionButton:OnEnter()
	KeyBound:Set(self)
end

--override the old update hotkeys function
hooksecurefunc('ActionButton_UpdateHotkeys', ActionButton.UpdateHotkey)

--button visibility
function ActionButton:UpdateGrid()
	if InCombatLockdown() then return end

	if self:GetAttribute('showgrid') > 0 then
		ActionButton_ShowGrid(self)
	else
		ActionButton_HideGrid(self)
	end
end

--macro text
function ActionButton:UpdateMacro()
	if Addon:ShowMacroText() then
		self.Name:Show()
	else
		self.Name:Hide()
	end
end

function ActionButton:SetFlyoutDirection(direction)
	if InCombatLockdown() then return end

	self:SetAttribute('flyoutDirection', direction)
	ActionButton_UpdateFlyout(self)
end

function ActionButton:UpdateState()
	ActionButton_UpdateState(self)
end

function ActionButton:UpdateShowEquippedItemBorders()
	self.Border:SetParent(Addon:ShowEquippedItemBorders() and self or HiddenFrame)
end

function ActionButton:UpdateState()
	ActionButton_UpdateState(self)
end

--utility function, resyncs the button's current action, modified by state
function ActionButton:LoadAction()
	local state = self:GetParent():GetAttribute('state-page')
	local id = state and self:GetAttribute('action--' .. state) or self:GetAttribute('action--base')

	self:SetAttribute('action', id)
end

--[[ exports ]]--

Addon.ActionButton = ActionButton
