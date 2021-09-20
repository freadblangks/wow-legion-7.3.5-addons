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

--- Designed to handle interaction with the player, react to their input, and adjust program behaviour accordingly
-- @module Controllers

--- EventHandlers.lua.
-- Provides a simple interface to toggle specific categories of event triggers and react to them according to the addon's needs. Only events that are caused by some player action are covered here.
-- @section GUI


local addonName, TotalAP = ...
if not TotalAP then return end

-- Upvalues
local UnitInVehicle = UnitInVehicle

-- State indicators (to detect transitions)
local eventStates = {}
local isBankOpen, isPlayerUsingVehicle, isPlayerEngagedInCombat, isPetBattleInProgress, hasPlayerLostControl = false, false, false, false, false

--- Scans the contents of either the player's inventory, or their bank
-- @param[opt] scanBank Whether or not the bank should be scanned instead of the player's inventory (defaults to false)
local function ScanInventory(scanBank)

	local foundTome = false -- For BoA tomes -> The display must display them before any AP tokens if any were found 
	
	 -- Temporary values that will be overwritten with the next item
	local bagID, maxBagID, tempItemLink, tempItemID
	local isTome, isToken = false, false -- Refers to current item
	
	-- To be saved in the Inventory cache
	local displayItem = {} -- The item that is going to be displayed on the actionButton (after the next call to GUI.Update())
	local numItems, numTomes, artifactPowerSum = 0, 0, 0 -- These are for the current scan
	local spellDescription, spellID, artifactPowerValue = nil, nil, 0  -- These are for the current item
	
		-- Queue IDs for all relevant bag that need to be scanned (this is mainly because the generic bank slot counts as a different "bag", but needs to be scanned as well)
	local bagSlots = {}
	
	if scanBank then -- Scan generic bank and set bag IDs 
	
		-- Set bag IDs to only scan bank bags
		bagSlots[1] = BANK_CONTAINER
		for i = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do -- Add all bags of the actual bank to the queue
		
			bagSlots[#bagSlots + 1] = i -- Add new entry for all regular bank bags (while preserving the generic one)
		
		end
	
	else -- Scan inventory bags
	
		-- Set bag IDs to only scan inventory bags
		for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do -- Add all bags of the actual bank to the queue
		
			bagSlots[#bagSlots + 1] = i -- Add new entry for all regular bank bags (while preserving the generic one)
		
		end
		
		-- TODO: If Tome was found in bank, can't use it but will it be displayed?
	
	end
	
	for index, bag in ipairs(bagSlots) do -- Iterate over this bag's contents
	
		for slot = 1, GetContainerNumSlots(bag) do -- Compare items in the current bag with DB entries to detect AP tokens
	
			tempItemLink = GetContainerItemLink(bag, slot)

			if tempItemLink and tempItemLink:match("item:%d") then -- Is a valid item
			
					tempItemID = GetItemInfoInstant(tempItemLink)
					
					isTome = TotalAP.DB.IsResearchTome(tempItemID)
					isToken = TotalAP.DB.IsArtifactPowerToken(tempItemID)
--TotalAP.Debug("Checked item: " .. tempItemLink .. " (" .. tempItemID .. ")-> isTome = " .. tostring(isTome) .. ", isToken = " .. tostring(isToken))
					-- TODO: Move this to DB\ResearchTomes or something, and access via helper function (similar to artifacts)
					if isTome then -- AK Tome is available for use -> Display button regardless of current AP tokens
					
						foundTome = not (UnitLevel("player") < 110) -- Only display tomes for max level characters (alts can't use them before level 110)
						
						if not foundTome then
							TotalAP.Debug("Found Artifact Research tome, but the player's level is below 110 -> Tome is unusable by low-level characters and won't be displayed")
						end

						numTomes = numTomes + 1
						TotalAP.Debug("Found research tome: " .. tempItemLink .. " -> numTomes = " .. numTomes)	
						
					end
					
					if isToken then -- Found token -> Use it in calculations

						numItems = numItems + 1
						
						-- Extract AP amount (after AK) from the description
						spellID = TotalAP.DB.GetItemSpellEffect(tempItemID)
						spellDescription = GetSpellDescription(spellID) -- Always contains the AP number, as only AP tokens are in the LUT 
						
						artifactPowerValue = TotalAP.Scanner.ParseSpellDesc(spellDescription) -- Scans spell description and extracts AP amount based on locale (as they use slightly different formats to display the numbers)
						artifactPowerSum = artifactPowerSum + artifactPowerValue
						
						TotalAP.Debug("Found AP token: " .. tempItemLink .. " -> numItems = " .. numItems .. ", artifactPowerSum = " .. artifactPowerSum)	
						
					end
				
					if not scanBank and (isTome and foundTome) or (isToken and not foundTome) then -- Set this item as the currently displayed one (so that the GUI can use it)
					
						displayItem.ID = tempItemID
						displayItem.link = tempItemLink
						displayItem.texture = GetItemIcon(displayItem.ID)
						displayItem.isToken = isToken
						displayItem.isTome = isTome
						displayItem.artifactPowerValue = artifactPowerValue
						displayItem.bag = bag
						displayItem.slot = slot
						
					end
				
				end
					
		end
	
	end
	
	if scanBank then -- Calculate AP value for bank bags and update bankCache so that other modules can access it)
		
		local bankCache = TotalAP.bankCache
		bankCache.numItems = numItems
		bankCache.inBankAP = artifactPowerSum
		
		TotalAP.Cache.UpdateBankCache()

	else	-- Calculate AP value for inventory bags and update inventory cache so that other modules can access it)

		local inventoryCache = TotalAP.inventoryCache
		inventoryCache.foundTome = foundTome -- TODO: Kind of obsolete now, can just do if numTomes > 0
		inventoryCache.numTomes = numTomes
		inventoryCache.displayItem = displayItem
		inventoryCache.numItems = numItems
		inventoryCache.inBagsAP = artifactPowerSum
		
	end
	
end

--- Scan inventory contents and update the addon's inventoryCache accordingly
local function ScanBags()

		ScanInventory(false)
	
end

--- Scan bank contents and update the addon's bankCache accordingly
local function ScanBank()
	
	ScanInventory(true)
	
end

--- Scan currently equipped artifact and update the addon's artifactCache accordingly
local function ScanArtifact()

	if not TotalAP.ArtifactInterface.HasCorrectSpecArtifactEquipped() then -- Player likely didn't have the correct artifact in their inventory, so another spec's artifact is still equipped (but shouldn't be scanned)
	
		TotalAP.Debug("ScanArtifact -> Aborted scan because the right artifact weapon was not equipped")
		return
	
	end
	
	if IsEquippedItem(133755) then -- TODO: ULA handling here
		TotalAP.Debug("ScanArtifact -> Detected Underlight Angler being equipped -> Not yet implemented :(")
		return
	end
	
	local aUI = C_ArtifactUI
	
	if not aUI then -- Can't get valid info -> Skip this scan (usually occurs once when logging in)
		TotalAP.Debug("ScanArtifact() -> Skipping this update because C_ArtifactUI is not available (yet)")
		return
	end
	
	local unspentAP = select(5, aUI.GetEquippedArtifactInfo())
	local numTraitsPurchased = select(6, aUI.GetEquippedArtifactInfo())
	local artifactTier = select(13, aUI.GetEquippedArtifactInfo())
	local artifactKnowledge = aUI.GetArtifactKnowledgeLevel()
	
	-- TODO: Ugly workaround for the issues reported after 7.3 hit - needs more investigation: Why does it happen, and when? Seems entirely random so far, but it might be due to some changes made in 7.3 that I am unaware of...
	if type(artifactTier) == "number" and artifactTier > 3 then -- This can't be right -> Replace it with tier = 2 for the time being (AFAIK there's no tier 3, and tier 1 is applied automatically after reaching 35 traits?)
		artifactTier = (numTraitsPurchased >= 35 and 2) or 1 -- Tiers upgrade automatically upon purchasing all the original traits
		--[===[@debug@
		-- Add obvious notification in case it ever happens while testing... so far it hasn't, though :/
		TotalAP.ChatMsg("Cache/artifactTier has become corrupted -> Workaround was applied. How did this happen!? Must... investigate...")
		--@end-debug@]===]
	end
	
	-- Update the Cache (stored in SavedVars)
	TotalAP.Cache.SetUnspentAP(unspentAP)
	TotalAP.Cache.SetNumTraits(numTraitsPurchased)
	TotalAP.Cache.SetArtifactTier(artifactTier)
	
	-- This has to be updated once every session, which isn't ideal but it's much easier to do it this way than to guarantee seamless Cache integration
	TotalAP.artifactCache.artifactKnowledgeLevel = artifactKnowledge or 0

end

--- Toggle a GUI Update (which is handled by the GUI controller and not the Event controller itself)
local function UpdateGUI()

	-- Update event states so that the GUI controller can hide/show frames accordingly
	eventStates.isBankOpen = isBankOpen
	eventStates.isPlayerUsingVehicle = isPlayerUsingVehicle
	eventStates.isPlayerEngagedInCombat = isPlayerEngagedInCombat
	eventStates.isPetBattleInProgress = isPetBattleInProgress
	eventStates.hasPlayerLostControl = hasPlayerLostControl
	
	local testState = UnitInVehicle("player")
	if testState ~= eventStates.isPlayerUsingVehicle then -- This can happen because there are some ways to "exit" vehicles that don't trigger the appropriate event... Before, this would bug the display or hide it
		TotalAP.Debug("Resetting isPlayerUsingVehicle state flag since a mismatch in vehicle states was detected")
		eventStates.isPlayerUsingVehicle = testState
	end
	
	-- Force update, using the most recent available information to render the GUI
	TotalAP.Controllers.RenderGUI()
	
end

--- Rescan artifact for the current spec
local function OnSpecChanged()

	TotalAP.Debug("OnSpecChanged triggered")

	ScanArtifact()
	UpdateGUI()
	
end

--- Scan the currently equipped artifact and update the addon's artifactCache accordingly
local function OnArtifactUpdate()
	
	-- TODO: Is this necessary or will OnInventoryUpdate cover this? Maybe scan artifact data here only instead of having it scanned with every item change (Bag update)?
	
	TotalAP.Debug("OnArtifactUpdate triggered")
	
	-- Re-scan inventory and update all stored values
	--ScanBags() TODO: Is this necessary? I think not.
	
	-- Scan equipped artifact
	ScanArtifact()
	-- Update GUI to display the most current information
	UpdateGUI()
	
end

--- Called when an inventory update finishes
local function OnInventoryUpdate()

	TotalAP.Debug("OnInventoryUpdate triggered")
	
	-- Re-scan inventory and update all stored values
	ScanBags()
	if isBankOpen then -- Update bankCache also (in case items were moved between inventory and bank)
		ScanBank()
	end
	
	-- Scan equipped artifact (TODO: Kind of doesn't belong here, but is necessary to initially cache a spec that hasn't been used before?)
	ScanArtifact()
	
	-- Update GUI to display the most current information
	UpdateGUI()
	
end

--- Called when player accesses the bank
local function OnBankOpened()

	TotalAP.Debug("OnBankOpened triggered")
	isBankOpen = true
	
	-- Re-scan bank and update all stored values
	ScanBank()
	
	-- Update GUI to display the most current information
	UpdateGUI()
	
end

--- Called when player closes the bank
local function OnBankClosed()
	
	TotalAP.Debug("OnBankClosed triggered")
	isBankOpen = false
	
end

--- Called when player switches bags or changes items in the generic bank storage
local function OnPlayerBankSlotsChanged()

	TotalAP.Debug("OnPlayerBankSlotsChanged triggered")
	
		-- Re-scan bank and update all stored values
	ScanBank()
	
	-- Update GUI to display the most current information
	UpdateGUI()
	
end

--- Called when player enters combat
local function OnEnterCombat()

	TotalAP.Debug("OnEnterCombat triggered")
	isPlayerEngagedInCombat = true

	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

--- Called when player leaves combat
local function OnLeaveCombat()

	TotalAP.Debug("OnLeaveCombat triggered")
	isPlayerEngagedInCombat = false
	
	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

--- Called when pet battle begins
local function OnPetBattleStart()

	TotalAP.Debug("OnPetBattleStart triggered")
	isPetBattleInProgress = true
	
	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

--- Called when pet battle ends
local function OnPetBattleEnd()

	TotalAP.Debug("OnPetBattleEnd triggered")
	isPetBattleInProgress = false
	
	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

-- Called when unit enters vehicle
local function OnUnitVehicleEnter(...)

	local args = { ... }
	local unit = args[2]
	
	TotalAP.Debug("OnUnitVehicleEnter triggered for unit = " .. tostring(unit))
	if unit ~= "player" then return end
	isPlayerUsingVehicle = true
	
	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

-- Called when unit exits vehicle
local function OnUnitVehicleExit(...)

	local args = { ... }
	local unit = args[2]
	
	TotalAP.Debug("OnUnitVehicleExit triggered for unit = " .. tostring(unit))
	if unit ~= "player" then return end
	isPlayerUsingVehicle = false
	
	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

-- Called when player uses flight master taxi services
local function OnPlayerControlLost()

	TotalAP.Debug("OnPlayerControlLost triggered")
	hasPlayerLostControl = true
	
	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

-- Called when player finishes using flight master taxi services
local function OnPlayerControlGained()

	TotalAP.Debug("OnPlayerControlGained triggered")
	hasPlayerLostControl = false

	-- Update GUI to show/hide displays when necessary
	UpdateGUI()
	
end

-- List of event listeners that the addon uses and their respective handler functions
local eventList = {

	-- Re-scan and update GUI
	["ARTIFACT_XP"] = OnArtifactUpdate,
	["ARTIFACT_UPDATE"] = OnArtifactUpdate,
	["BAG_UPDATE_DELAYED"] = OnInventoryUpdate,
	--["ACTIVE_TALENT_GROUP_CHANGED"] = OnSpecChanged, -- TODO: Not necessary if using
	["PLAYER_SPECIALIZATION_CHANGED"] = OnSpecChanged,
	
	-- Scan bank contents
	["BANKFRAME_OPENED"] = OnBankOpened,
	["BANKFRAME_CLOSED"] = OnBankClosed,
	["PLAYERBANKSLOTS_CHANGED"] = OnPlayerBankSlotsChanged, -- generic slots OR bags (not item in bags) have changed
	
	-- Toggle GUI and start/stop scanning or updating
	["PLAYER_REGEN_DISABLED"] = OnEnterCombat,
	["PLAYER_REGEN_ENABLED"] = OnLeaveCombat,
	["PET_BATTLE_OPENING_START"] = OnPetBattleStart,
	["PET_BATTLE_CLOSE"] = OnPetBattleEnd,
	["UNIT_ENTERED_VEHICLE"] = OnUnitVehicleEnter,
	["UNIT_EXITED_VEHICLE"] = OnUnitVehicleExit,
	["PLAYER_CONTROL_LOST"] = OnPlayerControlLost,
	["PLAYER_CONTROL_GAINED"] = OnPlayerControlGained,
	
}

-- Register listeners for all relevant events
local function RegisterAllEvents()
	
	for key, eventHandler in pairs(eventList) do -- Register this handler for the respective event (via AceEvent-3.0)
	
		TotalAP.Addon:RegisterEvent(key, eventHandler)
		TotalAP.Debug("Registered for event = " .. key)
	
	end
	
end

-- Unregister listeners for all relevant events
local function UnregisterAllEvents() -- TODO: Is this still necessary after the rewrite/refactoring of the loader?

	for key, eventHandler in pairs(eventList) do -- Unregister this handler for the respective event (via AceEvent-3.0)
	
		TotalAP.Addon:UnregisterEvent(key, eventHandler)
		TotalAP.Debug("Unregistered for event = " .. key)
	
	end

end


-- Make functions available in the addon namespace
TotalAP.EventHandlers.UnregisterAllEvents = UnregisterAllEvents
TotalAP.EventHandlers.RegisterAllEvents = RegisterAllEvents

TotalAP.eventStates = eventStates


return TotalAP.EventHandlers
