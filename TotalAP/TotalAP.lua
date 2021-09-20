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


--- Contains low-level interfaces for interacting with the data (DB, SavedVars) and WoW's Lua environment itself
-- @module Core

--- TotalAP.lua.
-- This is the addon loader, which performs various startup tasks.
-- @section TotalAP


-- Libraries
local Addon = LibStub("AceAddon-3.0"):NewAddon("TotalAP", "AceConsole-3.0", "AceEvent-3.0"); -- AceAddon object -> local because it's not really needed elsewhere
--local SharedMedia = LibStub("LibSharedMedia-3.0");  -- TODO: Not implemented yet... But "soon" (TM) -> allow styling of bars and font strings (I'm really just waiting until the config/options are done properly for this -> AceConfig)
local Masque = LibStub("Masque", true); -- optional (will use default client style if not found)


local addonName, T = ...
if not T then return end


TotalAP = T -- Make modules available globally (for keybinds, mainly, which don't seem to have access to the addon table (TODO: Check if this is actually true - lazy me, I know)
local TotalAP = TotalAP -- ... but use local copy to avoid lookups in global environment
local L = T.L -- Localization table
T.Addon = Addon -- to allow access to AceDB methods
T.Masque = Masque -- to allow buttons to register and update themselves more easily


-- One-time checks (per login... not stored otherwise)
local specIgnoredWarningGiven = false 


local settings = {} --  (TODO: Remove this, as it's not really needed after the GUI rework)


-- Standard methods (via AceAddon) -> They use the local object and not the shared container variable (which are for the modularised functions in other lua files)
-- TODO: Use AceConfig to create slash commands automatically for simplicity?

function Addon:OnProfileChanged(event, database, newProfileKey)

	TotalAP.Debug("Profile changed!")
	
end

--- Called on ADDON_LOADED
function Addon:OnInitialize() -- Called on ADDON_LOADED
	
	-- Initialise settings (saved variables), handled via AceDB
	TotalAP.Settings.Initialise()
	settings = TotalAP.Settings.GetReference() -- TODO: Is this necessary?
	

	-- Make sure at least one View is usable (TODO: Pointless for now; Always prepares the DefaultView, as others aren't implemented yet)
	TotalAP.Controllers.InitialiseGUI()
	
	-- TODO: via AceGUI?
	-- TODO: Allow custom views to be loaded instead of (or in addition to) the default one, and toggling of views, respectively

	-- Register slash commands
	self:RegisterChatCommand(TotalAP.Controllers.GetSlashCommand(), TotalAP.Controllers.SlashCommandHandler)
	self:RegisterChatCommand(TotalAP.Controllers.GetSlashCommandAlias(), TotalAP.Controllers.SlashCommandHandler_UsedAlias) -- alias is /ap instead of /totalap - with the latter providing a fallback mechanism in case some other addon chose to use /ap as well or for lazy people (like me)
	
	-- Add keybinds to Blizzard's KeybindUI
	TotalAP.Controllers.RegisterKeybinds()
	
	-- Hook script handler to display tooltip additions when hovering over an AP item (and the action button itself) - TODO: Global handling of script handlers somewhere else, including those that are used as part of the GUI?
	GameTooltip:HookScript('OnTooltipSetItem', TotalAP.GUI.Tooltips.ShowActionButtonTooltip)

end

--- Called on PLAYER_LOGIN or ADDON_LOADED (if addon is loaded-on-demand)
function Addon:OnEnable()

	local clientVersion, clientBuild = GetBuildInfo()
	
	-- Initialise caches -> Specs should be available here
	TotalAP.Cache.Initialise()
	
	TotalAP.Controllers.RenderGUI()
	
	-- if settings.showLoginMessage then TotalAP.ChatMsg(format(L["%s %s for WOW %s loaded!"], addonName, TotalAP.versionString, clientVersion)); end
	
	TotalAP.EventHandlers.RegisterAllEvents()
	
end

--- Called when addon is unloaded or disabled manually
function Addon:OnDisable()
	
	-- Shed a tear because the addon was disabled ;'(
	
end
