--[[--------------------------------------------------------------------
    Copyright (C) 2009, 2010, 2011, 2012 Sidoine De Wispelaere.
    Copyright (C) 2012, 2013, 2014 Johnny C. Lam.
    See the file LICENSE.txt for copying permission.
--]]----------------------------------------------------------------------

local OVALE, Ovale = ...
Ovale = LibStub("AceAddon-3.0"):NewAddon(Ovale or {}, OVALE or "Ovale", "AceEvent-3.0")

-- Export "Ovale" symbol to global namespace.
_G["Ovale"] = Ovale

--<private-static-properties>
local AceGUI = LibStub("AceGUI-3.0")

-- Localized strings table.
local L = nil

local assert = assert
local format = string.format
local ipairs = ipairs
local next = next
local pairs = pairs
local select = select
local strfind = string.find
local strjoin = strjoin
local strlen = string.len
local strmatch = string.match
local tostring = tostring
local tostringall = tostringall		-- FrameXML/RestrictedInfrastructure
local type = type
local unpack = unpack
local wipe = wipe
local API_GetItemInfo = GetItemInfo
local API_GetTime = GetTime
local API_UnitCanAttack = UnitCanAttack
local API_UnitClass = UnitClass
local API_UnitExists = UnitExists
local API_UnitGUID = UnitGUID
local API_UnitHasVehicleUI = UnitHasVehicleUI
local API_UnitIsDead = UnitIsDead
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local INFINITY = math.huge

local OVALE_VERSION = "7.3.0.3"
local REPOSITORY_KEYWORD = "@" .. "project-version" .. "@"

-- Table of strings to display once per session.
local self_oneTimeMessage = {}

-- List of the last MAX_REFRESH_INTERVALS elapsed times between refreshes.
local MAX_REFRESH_INTERVALS = 500
local self_refreshIntervals = {}
local self_refreshIndex = 1
--</private-static-properties>

--<public-static-properties>
-- Localization string table.
Ovale.L = nil
-- Player's class.
Ovale.playerClass = select(2, API_UnitClass("player"))
-- Player's GUID (initialized after PLAYER_LOGIN event).
Ovale.playerGUID = nil
-- AceDB-3.0 database to handle SavedVariables (managed by OvaleOptions).
Ovale.db = nil
--the frame with the icons
Ovale.frame = nil
-- Checkbox and dropdown definitions from evaluating the script.
Ovale.checkBox = {}
Ovale.list = {}
-- Checkbox and dropdown GUI controls.
Ovale.checkBoxWidget = {}
Ovale.listWidget = {}
-- List of units that require refreshing the best action.
Ovale.refreshNeeded = {}
-- Prefix of messages received via CHAT_MSG_ADDON for Ovale.
Ovale.MSG_PREFIX = OVALE
--</public-static-properties>

--<private-static-methods>
local function OnCheckBoxValueChanged(widget)
	-- Reflect the value change into the profile (model).
	local name = widget:GetUserData("name")
	Ovale.db.profile.check[name] = widget:GetValue()
	Ovale:SendMessage("Ovale_CheckBoxValueChanged", name)
end

local function OnDropDownValueChanged(widget)
	-- Reflect the value change into the profile (model).
	local name = widget:GetUserData("name")
	Ovale.db.profile.list[name] = widget:GetValue()
	Ovale:SendMessage("Ovale_ListValueChanged", name)
end
--</private-static-methods>

--<public-static-methods>
-- GLOBALS: BINDING_HEADER_OVALE
-- GLOBALS: BINDING_NAME_OVALE_CHECKBOX0
-- GLOBALS: BINDING_NAME_OVALE_CHECKBOX1
-- GLOBALS: BINDING_NAME_OVALE_CHECKBOX2
-- GLOBALS: BINDING_NAME_OVALE_CHECKBOX3
-- GLOBALS: BINDING_NAME_OVALE_CHECKBOX4
function Ovale:OnInitialize()
	-- Localization.
	L = Ovale.L
	-- Key bindings.
	BINDING_HEADER_OVALE = L["Ovale"]
	local toggleCheckBox = L["Inverser la boîte à cocher "]
	BINDING_NAME_OVALE_CHECKBOX0 = toggleCheckBox .. "(1)"
	BINDING_NAME_OVALE_CHECKBOX1 = toggleCheckBox .. "(2)"
	BINDING_NAME_OVALE_CHECKBOX2 = toggleCheckBox .. "(3)"
	BINDING_NAME_OVALE_CHECKBOX3 = toggleCheckBox .. "(4)"
	BINDING_NAME_OVALE_CHECKBOX4 = toggleCheckBox .. "(5)"
end

function Ovale:OnEnable()
	self.playerGUID = API_UnitGUID("player")

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterMessage("Ovale_CombatStarted")
	self:RegisterMessage("Ovale_OptionChanged")

	self.frame = AceGUI:Create(OVALE .. "Frame")
	self:UpdateFrame()
end

function Ovale:OnDisable()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
	self:UnregisterMessage("Ovale_CombatEnded")
	self:UnregisterMessage("Ovale_OptionChanged")
	self.frame:Hide()
end

--Called when the player target change
--Used to update the visibility e.g. if the user chose
--to hide Ovale if a friendly unit is targeted
function Ovale:PLAYER_ENTERING_WORLD()
	wipe(self_refreshIntervals)
	self_refreshIndex = 1
	self:ClearOneTimeMessages()
end

function Ovale:PLAYER_TARGET_CHANGED()
	self:UpdateVisibility()
end

function Ovale:Ovale_CombatStarted(event, atTime)
	self:UpdateVisibility()
end

function Ovale:Ovale_CombatEnded(event, atTime)
	self:UpdateVisibility()
end

function Ovale:Ovale_OptionChanged(event, eventType)
	if eventType == "visibility" then
		self:UpdateVisibility()
	else
		if eventType == "layout" then
			self.frame:UpdateFrame()
		end
		self:UpdateFrame()
	end
end

function Ovale:IsPreloaded(moduleList)
	local preloaded = true
	for _, moduleName in pairs(moduleList) do
		preloaded = preloaded and self[moduleName].ready
	end
	return preloaded
end

function Ovale:ToggleOptions()
	self.frame:ToggleOptions()
end

function Ovale:UpdateVisibility()
	local visible = true
	local profile = self.db.profile

	if not profile.apparence.enableIcons then
		visible = false
	elseif not self.frame.hider:IsVisible() then
		visible = false
	else
		if profile.apparence.hideVehicule and API_UnitHasVehicleUI("player") then
			visible = false
		end
		if profile.apparence.avecCible and not API_UnitExists("target") then
			visible = false
		end
		if profile.apparence.enCombat and not Ovale.OvaleFuture.inCombat then
			visible = false
		end
		if profile.apparence.targetHostileOnly and (API_UnitIsDead("target") or not API_UnitCanAttack("player", "target")) then
			visible = false
		end
	end

	if visible then
		self.frame:Show()
	else
		self.frame:Hide()
	end
end

function Ovale:ResetControls()
	wipe(self.checkBox)
	wipe(self.list)
end

function Ovale:UpdateControls()
	local profile = self.db.profile

	-- Create a new CheckBox widget for each checkbox declared in the script.
	wipe(self.checkBoxWidget)
	for name, checkBox in pairs(self.checkBox) do
		if checkBox.text then
			local widget = AceGUI:Create("CheckBox")
			-- XXX Workaround for GetItemInfo() possibly returning nil.
			local text = self:FinalizeString(checkBox.text)
			widget:SetLabel(text)
			if profile.check[name] == nil then
				profile.check[name] = checkBox.checked
			end
			if profile.check[name] then
				widget:SetValue(profile.check[name])
			end
			widget:SetUserData("name", name)
			widget:SetCallback("OnValueChanged", OnCheckBoxValueChanged)
			self.frame:AddChild(widget)
			self.checkBoxWidget[name] = widget
		else
			self:OneTimeMessage("Warning: checkbox '%s' is used but not defined.", name)
		end
	end

	-- Create a new Dropdown widget for each list declared in the script.
	wipe(self.listWidget)
	for name, list in pairs(self.list) do
		if next(list.items) then
			local widget = AceGUI:Create("Dropdown")
			widget:SetList(list.items)
			if not profile.list[name] then
				profile.list[name] = list.default
			end
			if profile.list[name] then
				widget:SetValue(profile.list[name])
			end
			widget:SetUserData("name", name)
			widget:SetCallback("OnValueChanged", OnDropDownValueChanged)
			self.frame:AddChild(widget)
			self.listWidget[name] = widget
		else
			self:OneTimeMessage("Warning: list '%s' is used but has no items.", name)
		end
	end
end

function Ovale:UpdateFrame()
	self.frame:ReleaseChildren()
	self.frame:UpdateIcons()
	self:UpdateControls()
	self:UpdateVisibility()
end

function Ovale:GetCheckBox(name)
	local widget
	if type(name) == "string" then
		widget = self.checkBoxWidget[name]
	elseif type(name) == "number" then
		-- "name" is a number, so count checkboxes until we reach the k'th one (indexed from 0).
		local k = 0
		for _, frame in pairs(self.checkBoxWidget) do
			if k == name then
				widget = frame
				break
			end
			k = k + 1
		end
	end
	return widget
end

function Ovale:IsChecked(name)
	local widget = self:GetCheckBox(name)
	return widget and widget:GetValue()
end

function Ovale:GetListValue(name)
	local widget = self.listWidget[name]
	return widget and widget:GetValue()
end

-- Set the checkbox control to the specified on/off (true/false) value.
function Ovale:SetCheckBox(name, on)
	local widget = self:GetCheckBox(name)
	if widget then
		local oldValue = widget:GetValue()
		if oldValue ~= on then
			widget:SetValue(on)
			OnCheckBoxValueChanged(widget)
		end
	end
end

-- Toggle the checkbox control.
function Ovale:ToggleCheckBox(name)
	local widget = self:GetCheckBox(name)
	if widget then
		local on = not widget:GetValue()
		widget:SetValue(on)
		OnCheckBoxValueChanged(widget)
	end
end

function Ovale:AddRefreshInterval(milliseconds)
	if milliseconds < INFINITY then
		self_refreshIntervals[self_refreshIndex] = milliseconds
		self_refreshIndex = (self_refreshIndex < MAX_REFRESH_INTERVALS) and (self_refreshIndex + 1) or 1
	end
end

function Ovale:GetRefreshIntervalStatistics()
	local sumRefresh, minRefresh, maxRefresh, count = 0, INFINITY, 0, 0
	for k, v in ipairs(self_refreshIntervals) do
		if v > 0 then
			if minRefresh > v then
				minRefresh = v
			end
			if maxRefresh < v then
				maxRefresh = v
			end
			sumRefresh = sumRefresh + v
			count = count + 1
		end
	end
	local avgRefresh = (count > 0) and (sumRefresh / count) or 0
	return avgRefresh, minRefresh, maxRefresh, count
end

function Ovale:FinalizeString(s)
	local item, id = strmatch(s, "^(item:)(.+)")
	if item then
		s = API_GetItemInfo(id)
	end
	return s
end

--[[
	Return a string from the parameters.  If the first parameter is a format string,
	use the remaining parameters as parameters for the format string; otherwise,
	concatenate all of the parameters together.
--]]
function Ovale:MakeString(s, ...)
	if s and strlen(s) > 0 then
		if (...) then
			if strfind(s, "%%%.%d") or strfind(s, "%%[%w]") then
				-- "s" looks like a format string.
				s = format(s, tostringall(...))
			else
				s = strjoin(" ", s, tostringall(...))
			end
		end
	else
		s = tostring(nil)
	end
	return s
end

-- Print the parameters to DEFAULT_CHAT_FRAME, headed by the name of the module.
-- NOTE: This method is mirrored to the module prototype for new modules.
function Ovale:Print(...)
	local name = self:GetName()
	local s = Ovale:MakeString(...)
	-- Match output format from AceConsole-3.0 Print() method.
	DEFAULT_CHAT_FRAME:AddMessage(format("|cff33ff99%s|r: %s", name, s))
end

-- Print the error message and flag the next frame to be traced by OvaleDebug.
-- NOTE: This method is mirrored to the module prototype for new modules.
function Ovale:Error(...)
	local s = Ovale:MakeString(...)
	self:Print("Fatal error: %s", s)
	Ovale.OvaleDebug.bug = true
end

function Ovale:OneTimeMessage(...)
	local s = self:MakeString(...)
	if not self_oneTimeMessage[s] then
		self_oneTimeMessage[s] = true
	end
end

function Ovale:ClearOneTimeMessages()
	wipe(self_oneTimeMessage)
end

function Ovale:PrintOneTimeMessages()
	for s in pairs(self_oneTimeMessage) do
		if self_oneTimeMessage[s] ~= "printed" then
			self:Print(s)
			self_oneTimeMessage[s] = "printed"
		end
	end
end

function Ovale:GetMethod(methodName, subModule)
	local func, arg = self[methodName], self
	if not func then
		func, arg = subModule[methodName], subModule
	end
	assert(func ~= nil)
	return func, arg
end
--</public-static-methods>

--<private-static-properties>
--[[
	Ovale module prototype.

	The module prototype has a dummy Log method to mimic the API of the state machine.
	This makes it easier to write module methods that are mirrored to the state machine.
--]]
do
	local function DoNothing()
		-- no-op
	end

	local modulePrototype = {
		Error = Ovale.Error,
		Log = DoNothing,
		Print = Ovale.Print,
		GetMethod = Ovale.GetMethod,
	}

	Ovale:SetDefaultModulePrototype(modulePrototype)
end
--</private-static-properties>
