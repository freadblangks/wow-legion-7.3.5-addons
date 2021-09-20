 --[[ TotalAP - Artifact Power tracking addon for World of Warcraft: Legion
 
	-- LICENSE (short version):
	
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
--]]


--- 
-- @module Core

--- Settings.lua.
-- Provides an interface for the addon's settings database (i.e., all settings stored in the SavedVariables\TotalAP.lua file)
-- @section Settings


local addonname, TotalAP = ...

if not TotalAP then return end


-- Default settings (to check against when valdiating the saved vars, and as default values for AceDB)
local defaultSettings =	{	

		-- General addon options
		debugMode = false,
		verbose = true,
		showLoginMessage = true,
		enabled = true,		-- This controls the entire display, but NOT the individual parts (which will be hidden, but their settings won't be overridden)
		autoHide = false,
		numberFormat = GetLocale(),
		scanBank = true,
		
		stateIcons = {
			enabled = true,
		},
		
		-- Display options for the action button
		actionButton = {
			enabled = true,
			showGlowEffect = true,
			minResize = 20,
			maxResize = 100,
			showText = true
		},

		-- Display options for the spec icons
		specIcons = {
			enabled = true,
			showGlowEffect = true,
			size = 18,
			border = 1,
			inset = 1,
			showNumTraits = true,
		},
		
		-- Controls what information is displayed in the tooltip
		tooltip = {
			enabled = true, 
			showProgressReport = true,
			showNumItems = true,
			showRelicRecommendations = false,
		},
		
		-- Display options for the bar displays
		infoFrame = {
			enabled = true,
			barTexture = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar.blp", -- Default texture. TODO. SharedMedia
			barHeight = 16,
			border = 1,
			inset = 1,
			showMiniBar = true,
			alignment = "center", -- TODO: Provide option via GUI (AceConfig)
			
			progressBar = {
				red = 250,
				green = 250,
				blue = 250,
				alpha = 0.2
			},
			
			unspentBar = {
				red = 50,
				green = 150,
				blue = 250,
				alpha = 1
			},
			
			inBagsBar = {
				red = 50,
				green = 95,
				blue = 150,
				alpha = 1
			},
			
			inBankBar = {
				red = 50,
				green = 95,
				blue = 95,
				alpha = 1
			}
		}
		
	}
	

-- Validator functions
-- TODO: Move to global scope and re-use (DRY) in Cache module
local function IsBoolean(value)
	return type(value) == "boolean"
end	

local function IsTable(value)
	return type(value) == "table"
end	

local function IsNumber(value)
	return type(value) == "number"
end	

local function IsRGB(value)
	return IsNumber(value) and value > 0 and value < 255
end

local function IsDecimalFraction(value)
	return IsNumber(value) and value > 0 and value <= 1
end

local function IsNumberFormat(value)

	local validNumberFormats = {
		legacy = true,
		enUS = true, -- also enGB?
		enGB = true, -- will use enUS format
		deDE = true,
		esES = true, -- also esMX?
		esMX = true, -- will use esES format
		frFR = true,
		itIT = true,
		koKR = true,
		ptBR = true,
		ruRU = true,
		zhCN = true,
		zhTW = true,
	}

	return type(value) == "string" and validNumberFormats[value] ~= nil
end

local function IsString(value)
	
	return type(value) == "string"

end

local function IsAlignmentString(value)

	local validAlignmentStrings = {
		["center"] = true,
		["top"] = true,
		["bottom"] = true,
	}

	return IsString(value) and validAlignmentStrings[value] ~= nil
	
end

-- LUT for validator functions
local validators = {
	
	["debugMode"] = IsBoolean,
	["enabled"] = IsBoolean,
	["autoHide"] = IsBoolean,
	["numberFormat"] = IsNumberFormat,
	["showLoginMessage"] = IsBoolean,
	["verbose"] = IsBoolean,
	["scanBank"] = IsBoolean,
	
	["actionButton"] = IsTable,
	["actionButton.enabled"] = IsBoolean,
	["actionButton.maxResize"] = IsNumber,
	["actionButton.minResize"] = IsNumber,
	["actionButton.showGlowEffect"] = IsBoolean,
	["actionButton.showText"] = IsBoolean,
	
	["infoFrame"] = IsTable,
	["infoFrame.alignment"] = IsAlignmentString,
	["infoFrame.border"] = IsNumber,
	["infoFrame.barHeight"] = IsNumber,
	["infoFrame.barTexture"] = IsString,
	["infoFrame.enabled"] = IsBoolean,
	["infoFrame.inset"] = IsNumber,
	["infoFrame.showMiniBar"] = IsBoolean,
	
	["infoFrame.progressBar"] = IsTable,
	["infoFrame.progressBar.red"] = IsRGB,
	["infoFrame.progressBar.green"] = IsRGB,
	["infoFrame.progressBar.blue"] = IsRGB,
	["infoFrame.progressBar.alpha"] = IsDecimalFraction,
	
	["infoFrame.unspentBar"] = IsTable,
	["infoFrame.unspentBar.red"] = IsRGB,
	["infoFrame.unspentBar.green"] = IsRGB,
	["infoFrame.unspentBar.blue"] = IsRGB,
	["infoFrame.unspentBar.alpha"] = IsDecimalFraction,
	
	["infoFrame.inBagsBar"] = IsTable,
	["infoFrame.inBagsBar.red"] = IsRGB,
	["infoFrame.inBagsBar.green"] = IsRGB,
	["infoFrame.inBagsBar.blue"] = IsRGB,
	["infoFrame.inBagsBar.alpha"] = IsDecimalFraction,
	
	["infoFrame.inBankBar"] = IsTable,
	["infoFrame.inBankBar.red"] = IsRGB,
	["infoFrame.inBankBar.green"] = IsRGB,
	["infoFrame.inBankBar.blue"] = IsRGB,
	["infoFrame.inBankBar.alpha"] = IsDecimalFraction,
	
	["specIcons"] = IsTable,
	["specIcons.border"] = IsNumber,
	["specIcons.enabled"] = IsBoolean,
	["specIcons.inset"] = IsNumber,
	["specIcons.showGlowEffect"] = IsBoolean,
	["specIcons.size"] = IsNumber,
	["specIcons.showNumTraits"] = IsBoolean,
	
	["tooltip"] = IsTable,
	["tooltip.enabled"] = IsBoolean,
	["tooltip.showNumItems"] = IsBoolean,
	["tooltip.showProgressReport"] = IsBoolean,
	["tooltip.showRelicRecommendations"] = IsBoolean,
	
	["stateIcons"] = IsTable,
	["stateIcons.enabled"] = IsBoolean,
}	


--- Validates the given table by calling a validator function for the given path
-- @param t The table that is going to be validated
-- @param[opt] relPath The relative path of the current node in the table; defaults to "" (empty string) if none is given
-- @param[opt] v The list (table) of validator functions; uses a predefined list if none is given
-- @usage ValidateTable(settings) -> Validates all entries in the addon's settings, dropping deprecated values and replacing invalid ones with their default value (Note: This is an expensive operation and should not happen too much)
local function ValidateTable(t, relPath, v)

	if not relPath then -- Use root as path if none was given
	
--		TotalAP.Debug("ValidateTable -> Using root as relative path because none was given")
		relPath = ""
	
	end
	
	if not v then -- Use local validators table (TODO)
	
--		TotalAP.Debug("ValidateTable -> Using default validator functions because none were supplied")
		v = validators
	
	end
	
	if t == nil or not type(t) == "table" then -- Skip validation for invalid table parameter
	
--		TotalAP.Debug("ValidateTable -> Skipped validation because an invalid table parameter was supplied (with relPath = " .. tostring(relPath) .. ")")
		return
	
	end
	
	
	-- Iterate over entries in the table and validate them individually
	for key, value in pairs(t) do
		
		--print("Validating entry with key = " .. key .. " and value = " .. tostring(value))
		local absPath = relPath .. (relPath ~= "" and "." or "") .. key
		--print("Validating key = " .. key .. " for absPath = " .. absPath)
		local IsValid = v[absPath]

		if IsValid == nil then -- No validation routine existed -> Value is likely deprecated and no longer required
		
			TotalAP.Debug("ValidateTable -> Found deprecated value for key = " .. tostring(key) .. " (lookup = " .. tostring(absPath) .. ")")
			
			-- Remove obsolete value
			t[key] = nil -- TODO: THis is not working,because absPath can be representing a nested table entry
			TotalAP.Debug("ValidateTable -> Dropped obsolete value for key = " .. tostring(key))
		
		else
			
			if not (type(IsValid) == "function" and IsValid(value)) then -- Validation failed -> Reset to default
		
				TotalAP.Debug("ValidateTable -> Validation failed for key: " .. tostring(key) .. " (lookup = " .. tostring(absPath) .. ")")
				
				-- Load default value
				t[key] = TotalAP.Utils.FieldLookup(absPath, defaultSettings) -- VERY slow, but it shouldn't really happen all that often that a saved variable gets corrupted or otherwise messed up
				TotalAP.Debug("ValidateTable -> Restored default value for key = " .. tostring(key))
				
			else -- Validation was successful -> Everything is in order
		
				--print("Validation passed for key: " .. key .. " (lookup = " .. absPath .. ")")
				
			end
		end
		
		if type(value) == "table" then -- Validate the table that was found, recursively
			
			--print("Found table for key: " .. key)
			--print("Using absPath = " .. absPath .. " as relPath of recursion")
			--print("Entering recursive step with new relPath = " .. absPath)
			ValidateTable(t[key], absPath)
			
		end
		
	end

	return true
	
end

--- Retrieve the table containing all of the addon's settings for the currently active profile (managed by AceDB)
-- @return Reference to the settings table
local function GetReference()
	
	return TotalAP.Addon.db.profile
	
end

--- Returns the default settings for first startup or manual/automatic resets during validation at a later point in time
-- @return Table containing the default values for all settings
local function GetDefaults()

	return defaultSettings
	
end

--- Reset all settings to their default values
local function RestoreDefaults()

	local db = TotalAP.Addon.db
	db:ResetProfile()

end

--- Migrate existing saved variables to the AceDB profiles table
-- @param savedVars A reference to the saved variables table
-- @return True if migration completed without errors, false otherwise
local function MigrateToAceDB(savedVars)

	-- Skip if SV aren't handled by AceDB at all (must be a wrong reference being passed), or if they are empty (which also shouldn't happen normally, as they have been initialised before this is called)
	if savedVars and savedVars.profiles ~= nil and savedVars.profiles.Default ~= nil then -- SV exist and are handled by AceDB (Default profile should always exist)
	
		if savedVars.actionButton ~= nil then -- Since this is the most basic addon feature, it can be safely assumed that there are other settings on the top-level as well
		
			-- Migrate existing settings
			local defaultSettings = GetDefaults()
			local settings = GetReference()
			
			for key, value in pairs(savedVars) do -- Check if this setting is still required (not all are, as some might be outdated -> Those will be dropped by the validation routine once they are in the AceDB profiles table)
			
				TotalAP.Debug("MigrateToAceDB -> Checking key = " .. tostring(key) .. " with value = " .. tostring(value))
			
				if not (key == "profiles" or key == "profileKeys") and value ~= nil then -- It's not a key that was set by AceDB -> Migrate it
				
					TotalAP.Debug("Current value in AceDB: " .. tostring(settings[key]))
					settings[key] = value -- Migrate to AceDB profile
					savedVars[key] = nil -- Drop obsolete entry
					TotalAP.Debug("MigrateToAceDB -> Dropped obsolete entry for key = " .. tostring(key) .. " after copying it to AceDB profile")
				
				end
			
			end
		
		else
			
			TotalAP.Debug("MigrateToAceDB -> Aborted - No top-level entries exist")
			return false
		
		end
	
	else
				
		TotalAP.Debug("MigrateToAceDB -> Aborted - SavedVars are not currently managed by AceDB")
		return false
				
	end
	
	return true
	
end

--- Validate all settings and reset those that weren't found to be corret to their default values (while printing a debug message)
local function Validate()

	-- Migrate settings to AceDB format if some are still in the old format
	local savedVars = TotalArtifactPowerSettings -- direct reference to the saved vars that are now handled by AceDB
	local migratedSuccessfully = MigrateToAceDB(savedVars)
	
	if migratedSuccessfully then
		TotalAP.Debug("Migration completed successfully")
	else
		TotalAP.Debug("Migration aborted before it could finish")
	end

	-- Validate existing entries
	local settings = GetReference()
	local validatedSuccessfully = ValidateTable(settings) 	-- Also deletes unused (deprecated) entries -> everything that is stored in the saved variables should now be correct
	
	-- Settings that aren't set will be read from the default values (via AceDB)
	
	return validatedSuccessfully
	
end

-- Initialises the addon's settings and validates them (run at startup)
local function Initialise()
	
	-- Register settings with AceDB
	local defaultSettings = GetDefaults()
	
	-- Create defaults in AceDB format (wrapper around actual default values for use with profiles)
	local defaults = {
		profile = defaultSettings
	}	
	
	local self = TotalAP.Addon
	self.db = LibStub("AceDB-3.0"):New("TotalArtifactPowerSettings", defaults, true) -- Use the "Default" profile for all settings
	self.db:RegisterDefaults(defaults)
	
	-- Register callbacks -> Used to update the displays when the current profile is altered in any way
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")

	-- Validate existing settings to weed out invalid entries / drop obsolete keys
	Validate()
	
end
	

TotalAP.Settings.GetReference = GetReference
TotalAP.Settings.GetDefaults = GetDefaults
TotalAP.Settings.Initialise = Initialise
TotalAP.Settings.MigrateToAceDB = MigrateToAceDB
TotalAP.Settings.RestoreDefaults = RestoreDefaults
TotalAP.Settings.Validate = Validate

return TotalAP.Settings
