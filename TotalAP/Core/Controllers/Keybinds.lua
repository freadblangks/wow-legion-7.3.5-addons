  ----------------------------------------------------------------------------------------------------------------------
    -- This program is free software: you can redistribute it and/or modify
    -- it under the terms of the GNU General Public License as published by
    -- the Free Software Foundation, either version 3 of the License, or
    -- (at your option) any later version.
	
    -- This program is distributed in the hope that it will be useful,
    -- but WITHOUT ANY WARRANTY; without even the implied warranty of
    -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    -- GNU General Public License for more details.

    -- You should have received a copy of the GNU General Public License
    -- along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------

--- Controllers\Keybinds
-- @module Controllers

--- Keybinds.lua.
-- Handling of keybinds and delegation of tasks when they are being used
-- @section Keybinds


local addonName, TotalAP = ...

if not TotalAP then return end

-- AceLocale localisation table -> used for keybind header and descriptions
local L =  TotalAP.L

-- TODO: Use AceDB for this
local settings


-- Actual handling of keybind actions
-- TODO: This settings as parameter thingy... I don't like it (even though it works, it isn't a good way of solving the closure issue)
local keybindHandlers = {
	
	["AllDisplaysToggle"] = function(settings) -- Toggle the entire display via keybind or slash command (will override individual components' settings, but not overwrite them)
		
		TotalAP.Debug("Toggled display manually - individual components are unaffected, but won't be checked for as long as this is active")
		settings.enabled = not settings.enabled;
		
	end,
	
	["ActionButtonToggle"] = function(settings) -- Toggle action button (and buttonText)via keybind or slash command

			if settings.actionButton.enabled then
				TotalAP.ChatMsg(L["Action button is now hidden."]);
			else
				TotalAP.ChatMsg(L["Action button is now shown."]);
			end
		
		settings.actionButton.enabled = not settings.actionButton.enabled;
	
	end,
	
	["SpecIconsToggle"] = function(settings) -- Toggle the spec icons (and text) via keybind or slash command
	
		if settings.specIcons.enabled then
			TotalAP.ChatMsg(L["Icons are now hidden."] );
		else
			TotalAP.ChatMsg(L["Icons are now shown."] );
		end
		
		settings.specIcons.enabled = not settings.specIcons.enabled;
		
	end,
	
	["BarDisplayToggle"] = function(settings) -- Toggle the InfoFrame (bar display) via keybind or slash command
	
		if settings.infoFrame.enabled then
			TotalAP.ChatMsg(L["Bar display is now hidden."]);
		else
			TotalAP.ChatMsg(L["Bar display is now shown."]);
		end
		
		settings.infoFrame.enabled = not settings.infoFrame.enabled;
		
	end,
	
	["TooltipToggle"] = function(settings)	-- Toggle the tooltip display via keybind or slash command

-- TODO: Show/hide tooltip when toggling this? Which way feels most intuititive?

		if settings.tooltip.enabled then
			TotalAP.ChatMsg(L["Tooltip display is now hidden."]);
		else
			TotalAP.ChatMsg(L["Tooltip display is now shown."]);
		end
		
		settings.tooltip.enabled = not settings.tooltip.enabled;

	end,
	
}


local function KeybindHandler(action, isUserInput)

	if not isUserInput then -- This was called by some function and NOT via Blizzard Keybind UI = actual keypress (as defined in Bindings.xml) -> most likely via slash commands
		-- Something, something (TODO)
	end
	
	if InCombatLockdown() or UnitAffectingCombat("player") then -- Disable keybinds to avoid spreading taint if display is toggled while in combat
		TotalAP.ChatMsg(L["You cannot use keybinds to change the display while in combat."]) -- TODO: Only deactive commands that actually affect the GUI? (But then, which command does NOT do that?)
		return
	end
	
	-- Call corresponding action handler (if one exists for the requested keybind action)
	local actionHandler = keybindHandlers[action] 
	if actionHandler then
		TotalAP.Debug("Recognized keybind: " .. action .. " - calling action handler with isUserInput = " .. tostring(isUserInput))
		local settings = TotalAP.Settings.GetReference() -- Load saved vars (at runtime - they won't be available if loaded beforehand as this module is read before the actual ADDON_LOADED event occurs)
		actionHandler(settings)
	else
		TotalAP.Debug("Keybind not recognized: " .. action .. " - skipping call to action handler because none exists for this keybind")
	end

	-- Always update displays to make sure any changes will be displayed immediately
	TotalAP.Controllers.RenderGUI()
	
end


-- Register supported bindings with the Blizzard Keybind UI
local function RegisterKeybinds()

	-- TODO: Binding names / XML setup?
		BINDING_HEADER_TOTALAP = L["TotalAP - Artifact Power Tracker"];
	_G["BINDING_NAME_CLICK TotalAPButton:LeftButtonUp"] = L["Use Next AP Token"];
	_G["BINDING_NAME_TOTALAPALLDISPLAYSTOGGLE"] = L["Show/Hide All Displays"];
	_G["BINDING_NAME_TOTALAPBUTTONTOGGLE"] = L["Show/Hide Button"];
	_G["BINDING_NAME_TOTALAPTOOLTIPTOGGLE"] = L["Show/Hide Tooltip Info"];
	_G["BINDING_NAME_TOTALAPBARDISPLAYTOGGLE"] = L["Show/Hide Bar Display"];
	_G["BINDING_NAME_TOTALAPICONSTOGGLE"] = L["Show/Hide Icons"];
	
end	


-- Make functions available in the addon namespace
TotalAP.Controllers.RegisterKeybinds = RegisterKeybinds
TotalAP.Controllers.KeybindHandler = KeybindHandler

return TotalAP.Controllers
