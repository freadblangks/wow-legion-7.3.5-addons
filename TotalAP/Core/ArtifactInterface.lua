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

--- Core\ArtifactInterface.lua
-- @module Core

--- ArtifactInterface.lua.
-- Provides utilities and manages interaction with Blizzard's ArtifactUI (as well as Artifact Knowledge/Research Notes, which are accessed via GarrisonUI)
-- @section ArtifactInterface


-- Note: Most of these are just thin wrappers / already available elsewhere, but API changes will be easier to maintain if they're all in one place

local addonName, T = ...

if not T then return end


-- Shorthands
local aUI = C_ArtifactUI 


--- Returns information about the currently queued Artifact Research work order status
-- @return Localized name of the work order item (this is "Artifact Research Notes" in English)
-- @return Localized string representing the time left until the next work order is available for pickup
-- @return Duration (in seconds) until the next work order is available for pickup
-- @return Time (in seconds) that has elapsed since the current work order has been started
-- @return Number of work orders that are available for pickup
-- @return Total number of work orders that are currently in progress
-- @return Name of the item (That, too, is "Artifact Research Notes" in English)
local function GetResearchNotesShipmentInfo()
   
   local looseShipments = C_Garrison.GetLooseShipments (LE_GARRISON_TYPE_7_0) -- Contains: Nomi's work orders, OH Research/Troops, AK Research Notes
   
   if looseShipments and #looseShipments > 0 then -- Shipments are in progress/available
      
      for i = 1, #looseShipments do -- Find Research Notes
         
         local name, texture, shipmentCapacity, shipmentsReady, shipmentsTotal, creationTime, duration, timeLeftString, itemName, itemTexture, itemID  = C_Garrison.GetLandingPageShipmentInfoByContainerID (looseShipments [i])
       --  if name and creationTime and creationTime > 0 and texture == 237446 then -- Shipment is Artifact Research Notes
        if name and texture == 237446 then -- Shipment is Artifact Research Notes
               
			local elapsedTime, timeLeft = 0, 0 -- in case it's waiting to be picked up already
			if creationTime then -- Research in progress (not finished) -> Calculate time until it is finished
				elapsedTime = time() - creationTime
				timeLeft = duration - elapsedTime
			 end  
        
            return name, timeLeftString, timeLeft, elapsedTime, shipmentsReady, shipmentsTotal, itemName
            
         end
         
      end
      
   end
   
end

--- Returns the number of Artifact Research Notes that are ready for pickup
-- @return Amount of Research Notes that are available for pickup
-- @return Maximum number of shipments that have been queued
local function GetNumAvailableResearchNotes()

	local shipmentsReady = select(5, GetResearchNotesShipmentInfo()) or 0
	local shipmentsTotal = select(6, GetResearchNotesShipmentInfo()) or 0
	
	return shipmentsReady, shipmentsTotal

end

--- Returns the time (integer timestamp, String) until the next Artifact Research Notes are ready to be picked up
-- @return Localized string representing the time left until the next work order is available for pickup
-- @return Duration (in seconds) until the next work order is available for pickup
local function GetTimeUntilNextResearchNoteIsReady()
	
	local timeLeftString, timeLeft = select(2, GetResearchNotesShipmentInfo())
	
	return timeLeft, timeLeftString

end

--- Returns the the current AK level (same as used in Blizzard's Forge tooltip)
-- @return Current Artifact Knowledge Level
local function GetArtifactKnowledgeLevel()

	--Obsolete since 7.3 <= local name, amount, texturePath, earnedThisWeek, weeklyMax, totalMax, isDiscovered, quality = GetCurrencyInfo(1171) -- Hidden currency -> always available (unlike the crappy ArtifactUI :| )

	local amount = TotalAP.artifactCache.artifactKnowledgeLevel
	
	return amount
	--return aUI.GetArtifactKnowledgeLevel() -- Only available when ArtifactFrame is shown... -> not ideal, as it would have to be cached

end

-- Returns the multiplier for the current Artifact Knowledge level (same as used in Blizzard's Forge tooltip)
-- TODO: Only works if ArtifactFrame is currently open -> needs caching before it can be used
-- local function GetArtifactKnowledgeMultiplier()

	-- if not aUI then return 0	end
	
	-- return aUI.GetArtifactKnowledgeMultiplier()
	
-- end


--- Returns the number of traits that can be purchased
-- @param rank The current artifact level (number of purchased traits)
-- @param artifactPowerValue Number of unspent artifact power applied to the weapon
-- @param tier Artifact tier (defaults to 1; new tiers unlock additional traits)
-- @return Number of traits that can be purchased
local function GetNumRanksPurchasableWithAP(rank, artifactPowerValue, tier)

	tier = 2 -- A bit of a hack; but it works because the AP requirements for <35 traits are identical for all artifact tiers so it automatically calculates the correct amount [Yes, this is the lazy way out]
	
	-- The MainMenuBar function returns multiple values, but they aren't needed here. It might be practical, but it is also confusing
	local availableRanks = select(1, MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(rank, artifactPowerValue, tier))
	
	-- Tier 1 artifacts are limited to 54 traits, but the API does not consider this cap
	if tier == 1 then
		availableRanks = min(min(54, rank + availableRanks) - rank, availableRanks) -- This is the number of available ranks after considering the hard cap of 54
	end

	return availableRanks
	
end

--- Calculates the total number of purchaseable traits (using AP from both the equipped artifact and from AP tokens in the player's inventory and bank)
-- @return The number of available traits using AP from all available sources
local function GetNumAvailableTraits()
	
	if not aUI or not HasArtifactEquipped() then
		TotalAP.Debug("ArtifactInterface -> Attempted to calculate number of available traits, but the artifact UI was not available (No/wrong artifact weapon?)")
		return 0
	end
	
	local settings = TotalAP.Settings.GetReference()
	local thisLevelUnspentAP, numTraitsPurchased, _, _, _, _, _, _, tier = select(5, aUI.GetEquippedArtifactInfo())
	local numTraitsAvailable = GetNumRanksPurchasableWithAP(numTraitsPurchased, thisLevelUnspentAP + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0), tier) or 0
--	TotalAP.Debug(format("ArtifactInterface -> %s new traits available from all sources", numTraitsAvailable))
	
	return numTraitsAvailable
	
end


--- Returns progress towards the next trait (after considering all available "level ups")
-- @param rank The current artifact level (number of purchased traits)
-- @param artifactPowerValue Number of unspent artifact power applied to the weapon
-- @param tier Artifact tier (defaults to 1; new tiers unlock additional traits)
-- @return Percentage towards the next available trait (after buying as many as possible)
local function GetProgressTowardsNextRank(rank, artifactPowerValue, tier)

	tier = 2 -- A bit of a hack; but it works because the AP requirements for <35 traits are identical for all artifact tiers so it automatically calculates the correct amount [Yes, this is the lazy way out]

	local numPoints, artifactXP, xpForNextPoint = MainMenuBar_GetNumArtifactTraitsPurchasableFromXP(rank, artifactPowerValue, tier)
	
	local maxAttainableRank, leftoverAP = rank + numPoints, artifactXP
	local percentage = (leftoverAP / xpForNextPoint) * 100
	
	return percentage

end


--- Calculates progress towards next artifact trait (for the equipped artifact). Only used to calculate progress for the current artifact level (0 to 100%); GetProgressTowardsNextRank is used therwise
-- @return The percentage towards the next artifact trait for the currently equipped artifact (Maxes out at 100)
local function GetArtifactProgressPercent()
	
	if not aUI or not HasArtifactEquipped() then
		TotalAP.Debug("ArtifactInterface -> Attempted to calculate artifact progress, but the artifact UI was not available (No/wrong artifact weapon?)");
		return
	end

	local thisLevelUnspentAP, numTraitsPurchased, _, _, _, _, _, _, tier  = select(5, aUI.GetEquippedArtifactInfo())	

	local nextLevelRequiredAP = aUI.GetCostForPointAtRank(numTraitsPurchased, tier)
	local settings = TotalAP.Settings.GetReference()
	local percentageOfCurrentLevelUp = (thisLevelUnspentAP + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0)) / nextLevelRequiredAP * 100
	
--	TotalAP.Debug(format("ArtifactInterface -> Calculated progress towards next trait to be  %s%% ", percentageOfCurrentLevelUp or 0)) 
	
	return min(100, percentageOfCurrentLevelUp or 0)
	
end

--- Returns the percentage a given artifact power value would add to the currently equipped artifact
-- Does NOT consider multiple level ups
local function GetProgressForValue(value)

	if not aUI or not HasArtifactEquipped() then
		TotalAP.Debug("ArtifactInterface -> Attempted to calculate progress for value, but the artifact UI was not available (No/wrong artifact weapon?)");
		return
	end
	
	value = value or 0
	
	-- Retrieve current progress
	local thisLevelUnspentAP, numTraitsPurchased, _, _, _, _, _, _, tier  = select(5, aUI.GetEquippedArtifactInfo())	
	local nextLevelRequiredAP = aUI.GetCostForPointAtRank(numTraitsPurchased, tier)

	-- Calculate how much the given value would add
	if type(value) ~= number then -- No monkey business here!
	
		if value <= 0 then return 0 end
		
		return 100 * value/nextLevelRequiredAP -- If the item gives more than one level up, this can easily be detected by comparing it to 100 (even if the actual number of level ups is not being calculated)
	
	end
	
end


--- Returns whether or not the player is currently wearing their spec's artifact weapon
-- @return True if the equipped weapon is the right artifact; false otherwise
local function HasCorrectSpecArtifactEquipped()
	
	local _, _, classID = UnitClass("player"); -- 1 to 12
	local specID = GetSpecialization(); -- 1 to 4

	-- Check all artifacts for this spec
	TotalAP.Debug(format("Checking artifacts for class %d, spec %d", classID, specID));
	
	local itemID = TotalAP.DB.GetArtifactItemID(classID, specID)

	if not IsEquippedItem(itemID) then
		TotalAP.Debug(format("Expected to find artifact weapon %s, but it isn't equipped", GetItemInfo(itemID) or "<none>"));
		return false 
	end
	
	-- All checks passed -> Looks like the equipped weapon is in fact (one of) the class' artifact weapon 
	return true;
	
end

--- Returns whether or not an artifact is already maxed
-- @param numTraits The number of traits for the given artifact
-- @param tier The artifact tier of the given artifact
-- @returns True if the artifact is already maxed; nil otherwise (also in the case of invalid parameters)
local function IsArtifactMaxed(numTraits, tier)

	if numTraits and type(numTraits) == "number" and numTraits == 54 and tier == 1 then -- Artifact is maxed tier 1 artifact (before finishing the empowerment quest)
		return true
	end
	
	-- Everything else is just a giant ball of nope

end


-- Public methods
T.ArtifactInterface.GetNumAvailableResearchNotes = GetNumAvailableResearchNotes
--T.ArtifactInterface.GetArtifactKnowledgeMultiplier = GetArtifactKnowledgeMultiplier
T.ArtifactInterface.GetArtifactKnowledgeLevel = GetArtifactKnowledgeLevel
T.ArtifactInterface.GetTimeUntilNextResearchNoteIsReady = GetTimeUntilNextResearchNoteIsReady
--T.ArtifactInterface.GetNumRanksPurchased = GetNumRanksPurchased
T.ArtifactInterface.GetNumRanksPurchasableWithAP = GetNumRanksPurchasableWithAP
T.ArtifactInterface.GetProgressTowardsNextRank = GetProgressTowardsNextRank
T.ArtifactInterface.GetNumAvailableTraits = GetNumAvailableTraits
T.ArtifactInterface.GetArtifactProgressPercent = GetArtifactProgressPercent
T.ArtifactInterface.HasCorrectSpecArtifactEquipped = HasCorrectSpecArtifactEquipped
T.ArtifactInterface.IsArtifactMaxed = IsArtifactMaxed
T.ArtifactInterface.GetProgressForValue = GetProgressForValue

-- Keep this private, since it isn't used anywhere else
-- T.ArtifactInterface.GetResearchNotesShipmentInfo = GetResearchNotesShipmentInfo
-- T.ArtifactInterface.
-- T.ArtifactInterface.
-- T.ArtifactInterface.
-- T.ArtifactInterface.


return T.ArtifactInterface
