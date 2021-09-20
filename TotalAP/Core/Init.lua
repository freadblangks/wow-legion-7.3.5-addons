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

--- Sets up table structure for modules and global/shared vars
-- @script Init.lua


local addonName, TotalAP = ...

if not TotalAP then return end


-- Shared local variables (usually those used by logic AND display, or different modules) -> Shared by means of the addon Table
TotalAP.versionString = GetAddOnMetadata("TotalAP", "Version")
--[===[@debug@
TotalAP.versionString = "DEBUG"
--@end-debug@]===]

-- Core modules
TotalAP.ArtifactInterface = {}
TotalAP.Scanner = {}
TotalAP.Cache = {}
TotalAP.DBHandler = {} 
TotalAP.Settings = {}

-- Controllers & Input handling
TotalAP.Controllers = {}
TotalAP.EventHandlers = {}

-- User Interface & Views
TotalAP.GUI = {}

-- Utility and helper functions
TotalAP.Utils = {}

-- Localization table
TotalAP.L = LibStub("AceLocale-3.0"):GetLocale("TotalAP", false)

-- Volatile data storage (caches) -- TODO: Deprecated, store directly in SavedVars
TotalAP.artifactCache = { -- Re-introduced because I am too lazy to save it in the actual Cache (requires tests etc. to be updated to make sure it doesn't break stuff); this will do even if it isn't saved across sessions
	artifactKnowledgeLevel = 0
}
TotalAP.bankCache = {

	inBankAP = 0,
	numItems = 0,

}
TotalAP.inventoryCache = {

	inBagsAP = 0,
	numItems = 0,
	numTomes = 0,
	foundTome = false,

	displayItem = {
		
	}
}


-- Global functions (TODO: Move to separate file if there will be more?)
-- TODO: Custom colour codes (in Utils) -> not implemented yet
-- Print debug messages (if enabled)
local function Debug(msg)

	local settings = TotalAP.Settings.GetReference()

	if settings.debugMode then
		print(format("|c000072CA" .. "%s-Debug: " .. "|c00E6CC80%s", addonName, msg)); 
	end
end

	
-- Print regular addon messages (if enabled)
local function ChatMsg(msg)

	local settings = TotalAP.Settings.GetReference()

	if settings.verbose then
		print(format("|c00CC5500" .. "%s: " .. "|c00E6CC80%s", addonName, msg)); 
	end
end


TotalAP.Debug = Debug
TotalAP.ChatMsg = ChatMsg

return TotalAP
