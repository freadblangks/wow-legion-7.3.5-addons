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

--- DB.lua.
-- Provides an interface for the addon's static database (i.e., all files stored in the \DB\ folder)
-- @section DB


local addonName, TotalAP = ...

if not TotalAP then return end

--- Returns a reference to the top-level DB object. Temporary crutch for ongoing refactoring/migration of modules :)
local function GetReference()

	return TotalAP.DB
	
end

-- Artifact weapons DB

--- Returns a reference to the artifact weapons DB object. For internal use only
local function GetArtifactWeapons()

	local db = GetReference()
	return db["artifacts"]

end

-- TODO Unused, for now?
-- local function GetArtifactWeaponsForClass(classID)
-- end

--- Returns the item ID of the artifact weapon for the given class and spec
-- @param classID The class identifier (as returned by UnitClass("player")). Usually, this is a number between 1 and 12
-- @param specID The specialization identifier (as returned by GetSpecialization()). Usually, this is a number between 1 and 4
-- @return Item ID of the corresponding artifact weapon; NIL if no DB entry exists
local function GetArtifactItemID(classID, specID)

	local db = GetArtifactWeapons()
	
	if not (classID and specID and db[classID] and db[classID][specID] and db[classID][specID]["itemID"]) then -- Invalid parameters
	
		TotalAP.Debug("Attempted to retrieve artifact weapon ID, but the class or spec IDs were invalid")
		return
		
	end

	return db[classID][specID]["itemID"]
	
end	

-- Artifact items (tokens) DB // TODO: Actually, itemEffectsDB would be a more fitting name... but it serves as DB for the items themselves

--- Returns a reference to the item effects DB (spell effects). For internal use only
-- @return A reference to the ItemEffectsDB
local function GetItemEffects()
	
	local db = GetReference()
	return db["itemEffects"]
	
end

--- Returns the item spell effect for a given itemID
-- @param itemID The identifier for a specific artifact power item
-- @return ID of the spell effect corresponding to the given artifact power item's "Empowering" spell (which is how AP is applied to the currently equipped artifact ingame); NIL if the itemID was invalid or no DB entry exists
local function GetItemSpellEffect(itemID)

	local itemEffects = GetItemEffects()
	
	if not (itemID and itemEffects[itemID]) then
	
		--TotalAP.Debug("Attempted to retrieve item effect for an invalid itemID")
		return
	end
	
	return itemEffects[itemID]

end


--- Returns whether or not an item is an Artifact Power Token
-- @param itemLink The item ID of an item
-- @return true if the item is an AP token; false otherwise
local function IsArtifactPowerToken(itemID)
					
	local spellID = GetItemSpellEffect(itemID)
	
	return spellID ~= nil and spellID and type(spellID) == "number"
	
end


---- ULA items DB (TODO)

--- Returns a reference to the  Research Tomes DB (for AK research). For internal use only
-- @return A reference to the ResearchTomesDB
local function GetResearchTomes()
	
	local db = GetReference()
	return db["ResearchTomes"]

end

--- Returns whether or not an item is a Research Tome
-- @param itemID The item ID of an item
-- @return true if the item is a reseach tome; false otherwise
local function IsResearchTome(itemID)

	local researchTomesDB = GetResearchTomes()
	
	return itemID and type(itemID) == "number" and researchTomesDB[itemID] ~= nil

end

--- Returns the recommended artifact traits (based on icy-veins.com) for a given class and spec
-- @param class The class number (1-12)
-- @param spec The specialization no. (1-4)
-- @return A table containing the three "best" artifact traits (in order of importance) as tables containing spellID and icon
local function GetRecommendedRelicTraits(class, spec)

	-- Use currently logged in character's class and spec if none was given
	class = class or select(3, UnitClass("player")) -- numeric ID, not string or STRING, to be used as key for the table lookup
	spec = spec or GetSpecialization()
	
	if not TotalAP.DB.RelicTraits[class] then return end
	return TotalAP.DB.RelicTraits[class][spec]

end


-- Public methods
TotalAP.DB.GetArtifactItemID = GetArtifactItemID
TotalAP.DB.GetItemSpellEffect = GetItemSpellEffect
TotalAP.DB.IsResearchTome = IsResearchTome
TotalAP.DB.IsArtifactPowerToken = IsArtifactPowerToken
TotalAP.DB.GetRecommendedRelicTraits = GetRecommendedRelicTraits


-- Keep these private, unless they're needed elsewhere?
-- TotalAP.DB.GetArtifactWeapons = GetArtifactWeapons

return TotalAP.DB

