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

--- 
-- @module GUI

--- DefaultView.lua.
-- The classic TotalAP GUI as it was used in earlier versions
-- @section GUI


local addonName, TotalAP = ...
if not TotalAP then return end


local DefaultView = {}

	-- TODO: Get those from the settings, so that they can be changed in the options GUI (under tab: Views -> DefaultView, along with enabling/disabling/repositioning individual display components)
	-- Stuff that needs to be moved to AceConfig settings
	
	local hSpace, vSpace = 1, 5 -- space between display elements
	
	local barWidth, barHeight, barInset = 100, 16, 2
	
	local minButtonSize, maxButtonSize = 20, 60 -- TODO: smaller than 60 looks odd, 80 before? should be 4x size of the bars at most, and 1x at the least to cover all specs
	local defaultButtonSize = 40 -- TODO: Layout Cache or via settings?
	
	local buttonTextTemplate = "GameFontNormal"
	
	local specIconSize = 17
	local specIconBorderWidth = 1
	local specIconTextWidth = 40
	
	local specIconTextTemplate = "GameFontNormal"
	
	local stateIconSpacer = 2
	local stateIconWidth = (maxButtonSize - 3 * stateIconSpacer) / 4
	local stateIconHeight = stateIconWidth
	
	local sliderHeight = 20
		
	-- End stuff that needs to be moved to AceConfig settings
	
--- Returns the rearranged order of specs for display in an ordered View
-- @return The order that specs will be displayed in after taking into account ignored specs (which won't be counted as they are hidden)
local function GetSpecDisplayOrder()

	local displayOrder = { 1, 2, 3, 4 } -- default order, used if no specs are being ignored
	local order = 1 -- 0 is used to indicate ignored displays
	
	for i = 1, GetNumSpecializations() do 
	
		if TotalAP.Cache.IsSpecIgnored(i) then -- ignored spec -> order is 0 (hidden)
			displayOrder[i] = 0
		else -- proceed with the order as if there were no hidden displays
			displayOrder[i] = order
			order = order + 1
		end
	
	end

	return displayOrder
	
end

-- Returns the rearranged order of a given spec for display in an ordered View
-- @param spec The spec number (1-4)
-- @return The order in which it should be displayed (0-4; 0 meaning "ignored" = don't display)
local function GetDisplayOrderForSpec(spec)

	local displayOrder = GetSpecDisplayOrder()
	return displayOrder[spec] or 0

end

--- Returns the offsets for calculating the position of display elements when using alignment options
-- @param anchorFrameHeight The height of the anchor frame
-- @return
-- TODO: Not the best solution...
local function GetDelta(anchorFrameHeight) -- TODO: Delete

	local settings = TotalAP.Settings.GetReference()

	local combinedBarsHeight = (GetNumSpecializations() - TotalAP.Cache.GetNumIgnoredSpecs()) * (2 * barInset + barHeight + hSpace)

	-- Align progress bars (via their surrounding frame)
	local delta
	if settings.infoFrame.alignment == "bottom" then -- Move to bottom border (above non-existing AK slider)
		delta = anchorFrameHeight - (barHeight + 2 * barInset + hSpace) - combinedBarsHeight
	elseif settings.infoFrame.alignment == "center" then -- Move to center
		delta = (anchorFrameHeight - (barHeight + 2 * barInset + hSpace) - combinedBarsHeight) / 2
	else -- Leave aligned at the top (below non-existent ULA bar)
		delta = 0
	end
	
	return delta, combinedBarsHeight

end

--- Creates a new ViewObject
-- @param self Reference to the caller
-- @return A representation of the View (ViewObject)
local function CreateNew(self)
	
	local ViewObject = {}

	setmetatable(ViewObject, self) -- The new object inherits from this class
	self.__index = TotalAP.GUI.View -- ... and this class inherits from the generic View template
	
	-- Locals that are required to update individual view elements
	local settings = TotalAP.Settings.GetReference()
	local fqcn = TotalAP.Utils.GetFQCN()
	
	-- References to view elements (TODO: Add the remaining ones here and remove ugly workaround/hooking to access elements that weren't defined prior to the current element)
	local AnchorFrameContainer, CombatStateIconContainer, PetBattleStateIconContainer, VehicleStateIconContainer, PlayerControlStateIconContainer, UnderlightAnglerFrameContainer, ActionButtonFrameContainer, ActionButtonContainer, ActionButtonTextContainer, SpecIcon1FrameContainer, SpecIcon2FrameContainer, SpecIcon3FrameContainer, SpecIcon4FrameContainer, SpecIcon1Container, SpecIcon2Container, SpecIcon3Container, SpecIcon4Container, SpecIcon1TextContainer, SpecIcon2TextContainer, SpecIcon3TextContainer, SpecIcon4TextContainer, ProgressBarsFrameContainer, ProgressBar1Container, ProgressBar2Container, ProgressBar3Container, ProgressBar4Container -- Widget references
	local AnchorFrame, CombatStateIcon, PetBattleStateIcon, VehicleStateIcon, PlayerControlStateIcon, UnderlightAnglerFrame, ActionButtonFrame, ActionButton, ActionButtonText, SpecIcon1Frame, SpecIcon2Frame, SpecIcon3Frame, SpecIcon4Frame, SpecIcon1, SpecIcon2, SpecIcon3, SpecIcon4, SpecIcon1Text, SpecIcon2Text, SpecIcon3Text, SpecIcon4Text, ProgressBarsFrame, ProgressBar1, ProgressBar2, ProgressBar3, ProgressBar4 -- Frame references
	
	-- Anchor frame: Parent of all displays and buttons (used to toggle the entire addon, as well as move its displays)
	AnchorFrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_AnchorFrame")
	AnchorFrame = AnchorFrameContainer:GetFrameObject()

	
-- TODO: Utility functions (move elsewhere when refactoring)
	-- GUI calculations -> TODO: Move elsewhere, and generalise to calculate more than just the alignment offsets?
	-- Return offset for display elements depending on the selected alignment
	local GetDeltas = function(widgetType)

		-- Calculate position dynamically while considering alignment options, ignored specs, bar settings, and whether or not the ActionButtonText must be accounted for
		local showText = settings.actionButton.showText
		local align = settings.infoFrame.alignment -- shorthand
		local h = 2 * barInset + barHeight + hSpace -- The overall height of a single bar
		local numDisplayedSpecs = GetNumSpecializations() - TotalAP.Cache.GetNumIgnoredSpecs() -- How many progress bars will be displayed
		local b = maxButtonSize + hSpace -- + (showText and (ActionButtonText:GetStringHeight() + hSpace) or hSpace) -- Overall height of the button and attached text display -- TODO: FontString doesn't update until after the first render AFTER everything is initialised?
--TotalAP.Debug("maxButtonSize = " .. maxButtonSize .. ", showText = " .. tostring(showText) .. ", GetStringHeight() = " .. ActionButtonText:GetStringHeight() .. ", hSpace = " .. hSpace)

--TotalAP.Debug("GetDeltas -> h = " .. h .. ", numDisplayedSpecs = " .. numDisplayedSpecs .. ", b = " .. b)
		local dy = 0 -- For alignment == top, nothing has to change
		
		if widgetType == "button" then -- need to consider the buttonText, too
		
			dy = (align == "bottom" or align == "center") and (4 * h - b) or dy -- For alignment == bottom, move it by the maximum size of the AnchorFrame (= 4 progress bars) and make sure the bottom aligns
			dy = (align == "center") and (dy / 2) or dy -- For alignment == center, move it by half of the empty space

		else -- TODO: other widget types aren't really used right now, so this always means "bars" or "icons"

			dy = (align == "bottom" or align == "center") and ((4 - numDisplayedSpecs) * h) or dy
			dy = (align == "center") and (dy / 2) or dy
			
		end
		
--TotalAP.Debug("GetDeltas -> align = " .. tostring(align) .. " dx " .. 0 .. " dy " .. dy)
		return 0, dy -- TODO: dx NYI
		
	end
	
	-- local GetDeltas = function(overrideAlign)
		
		-- local align = overrideAlign or settings.infoFrame.alignment
		-- local dx, dy = 0, 0
		
		-- local n = TotalAP.Cache.GetNumIgnoredSpecs() -- This will be used to calculate the empty space (from specs that are hidden)
		-- local b = 2 * barInset + barHeight + hSpace -- This is the space one progress bar takes up -> formerly "combinedBarHeight"
	-- --	local showText = settings.actionButton.showText -- If the text is hidden, alignment for the button has to consider that fact
		-- -- TODO: buttonTextHeight ? For now, it's not required, but if there are options to change it then it must be evaluated, too
		
		-- if align == "center" then  -- Align == "center" ->
			-- dy = -1 / 2 * n * b
		-- elseif align == "bottom" then -- Anchor to the bottom and leave some space  (TODO: Might look odd if specs are being ignored?)
			-- dy = - n * b
		-- -- implied else align == "top" -> leave dy as 0 Anchor bars, icons, and buttonFrame right below the state icons/ULA bar (NYI)	
		-- end
		
		-- TotalAP.ChatMsg("dx " .. dx .. " dy " .. dy)
		-- return dx, dy
		
	-- end
		
	-- Shared script handler functions
	-- TODO: Proper handler functions. Could also toggle AP level as separate text on the progress bars
	-- TODO: Move this elsewhere
	local AnchorFrame_OnDragStart = function (self) -- Dragging moves the entire display (ALT + Click)
		
		if AnchorFrame:IsMovable() and IsAltKeyDown() then -- Move display
		
			AnchorFrame:StartMoving()
			AnchorFrame.isMoving = true
			
			AnchorFrameContainer:SetBackdropAlpha(0.5)
			AnchorFrameContainer:Render()
			
		end

	end

	-- TODO: Move elsewhere
	local AnchorFrame_OnDragStop = function (self) -- Stopping to drag leaves the display at its new location
		
		AnchorFrame:StopMovingOrSizing()
		AnchorFrame.isMoving = false
		
		AnchorFrameContainer:SetBackdropAlpha(0)
		AnchorFrameContainer:Render()
		
	end
	
	do -- AnchorFrame
	
		-- Layout and visuals
		AnchorFrame:SetFrameStrata("BACKGROUND")
		AnchorFrameContainer:SetBackdropColour("#D0D0D0")
		AnchorFrameContainer:SetBackdropAlpha(0)
	
		-- Player interaction
		AnchorFrame:SetMovable(true) 
		AnchorFrame:EnableMouse(true)
		AnchorFrame:RegisterForDrag("LeftButton")
		
		AnchorFrameContainer.Update = function(self)
		
			local numSpecs = GetNumSpecializations()
			local numIgnoredSpecs = TotalAP.Cache.GetNumIgnoredSpecs()
			local numDisplayedSpecs = numSpecs - numIgnoredSpecs
		
			local hideFrame = false
			-- Hide when:
			hideFrame = (hideFrame
			or UnitLevel("player") < 98 -- Player is too low level for Legion content (Artifact Quest)
			or not settings.enabled -- Display as a whole is being manually hidden (regardless of individual component's visibility)
			or settings.autoHide and TotalAP.eventStates.isPlayerEngagedInCombat -- Player is engaged in combat
			or settings.autoHide and TotalAP.eventStates.isPlayerUsingVehicle -- Player is using a vehicle
			or settings.autoHide and TotalAP.eventStates.isPetBattleInProgress -- Player is participating in a pet battle
			or settings.autoHide and TotalAP.eventStates.hasPlayerLostControl -- Player is using a Flight Master or stuck in film sequences, animations etc. 
			or numIgnoredSpecs == numSpecs) -- All specs are being ignored
			
			self:SetEnabled(not hideFrame)
			
			if hideFrame then return end
		
			-- Calculate and update size depending on number of (displayed) specs
			local width = maxButtonSize + vSpace + barWidth + vSpace + specIconSize + 2 * specIconBorderWidth + vSpace + specIconTextWidth
			
			-- TODO: DRY
			local totalBarHeight = barHeight + 2 * barInset
			local progressBarHeight = numDisplayedSpecs * (totalBarHeight) + (numDisplayedSpecs - 1) * hSpace
			local height = totalBarHeight + hSpace + max(maxButtonSize, progressBarHeight) + hSpace + sliderHeight -- ULA Bar + Progress Bars  + Slider (NYI)
--TotalAP.Debug("AnchorFrame dimensions: width = " .. width .. ", height = " .. height .. " -> progressBarHeight = " .. progressBarHeight .. ", maxButtonSize = " .. maxButtonSize)
			AnchorFrame:SetSize(width, height) -- TODO: Update dynamically (script handlers?) to account for variable number of specs
		
		
		end
		
		-- Script handlers	
		AnchorFrame:SetScript("OnMouseDown", function(self) -- Show background if user pressed drag modifier to indicate the display can be dragged
			
			if IsAltKeyDown() and not InCombatLockdown() then -- Make background visible
				
				AnchorFrameContainer:SetBackdropAlpha(0.5)
				AnchorFrameContainer:Render()
				
			end
		
		end)
		
		AnchorFrame:SetScript("OnMouseUp", function(self) -- Hide background

			AnchorFrameContainer:SetBackdropAlpha(0)
			AnchorFrameContainer:Render()
		
		end)
		
		AnchorFrame:SetScript("OnDragStart", AnchorFrame_OnDragStart)
		
		AnchorFrame:SetScript("OnDragStop", AnchorFrame_OnDragStop)
		
	end
	
	-- Event state icons: Indicate state of events that affect the ability to use AP items (TODO: Settings to show/hide and style these)
	CombatStateIconContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_CombatStateIcon", "_DefaultView_AnchorFrame")
	CombatStateIcon = CombatStateIconContainer:GetFrameObject()
	do -- CombatStateIcon
		
		-- Layout and visuals
		CombatStateIconContainer:SetRelativePosition(0, - stateIconHeight / 2)
		CombatStateIconContainer:SetBackdropColour("#EC3413")
		CombatStateIconContainer:SetBackdropAlpha(0)
		CombatStateIconContainer:SetEnabled(false) -- Don't show this by default
		
		CombatStateIcon:SetSize(stateIconWidth, stateIconHeight)
		CombatStateIcon.texture = CombatStateIcon:CreateTexture()
		CombatStateIcon.texture:SetTexture([[Interface\CharacterFrame\UI-StateIcon]]) -- TODO: Settings for this?
		CombatStateIcon.texture:SetAllPoints(CombatStateIcon)
		CombatStateIcon.texture:SetTexCoord(0.57, 0.90, 0.08, 0.41)
		
		
		-- Player interaction
		CombatStateIconContainer.Update = function(self)
		
			-- Indicate combat is currently in progress
			self:SetEnabled(settings.stateIcons.enabled and TotalAP.eventStates.isPlayerEngagedInCombat)
		
		end
		
	end
	
	PetBattleStateIconContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_PetBattleStateIcon", "_DefaultView_AnchorFrame")
	PetBattleStateIcon = PetBattleStateIconContainer:GetFrameObject()
	do -- PetBattleStateIcon
		
		-- Layout and visuals
		PetBattleStateIconContainer:SetRelativePosition(stateIconWidth + stateIconSpacer, - stateIconHeight / 2)
		PetBattleStateIconContainer:SetBackdropColour("#F05238")
		PetBattleStateIconContainer:SetBackdropAlpha(0)
		PetBattleStateIconContainer:SetEnabled(false) -- Don't show this by default
		
		PetBattleStateIcon:SetSize(stateIconWidth, stateIconHeight)
		PetBattleStateIcon.texture = PetBattleStateIcon:CreateTexture()
		PetBattleStateIcon.texture:SetTexture([[Interface\ICONS\Tracking_WildPet]]) -- TODO: Settings for this? -- [[Interface\ICONS\INV_Pet_BattlePetTraining]] [[Interface\Cursor\UnableWildPet]] [[Interface\Vehicles\UI-VEHICLES-RAID-ICON] [[Interface\Icons\Ability_CheapShot]]] Ability_Rogue_KidneyShot  [[Interface\Minimap\Tracking\FlightMaster]]
		PetBattleStateIcon.texture:SetAllPoints(PetBattleStateIcon)
		PetBattleStateIcon.texture:SetTexCoord(0, 1, 0, 1)
		
		-- Player interaction
		PetBattleStateIconContainer.Update = function(self)
		
			-- Indicate combat is currently in progress
			self:SetEnabled(settings.stateIcons.enabled and TotalAP.eventStates.isPetBattleInProgress)
		
		end
		
	end
	
	VehicleStateIconContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_VehicleStateIcon", "_DefaultView_AnchorFrame")
	VehicleStateIcon = VehicleStateIconContainer:GetFrameObject()
	do -- VehicleStateIcon
		
		-- Layout and visuals
		VehicleStateIconContainer:SetRelativePosition(2 * (stateIconWidth + stateIconSpacer), - stateIconHeight / 2)
		VehicleStateIconContainer:SetBackdropColour("#F3725D")
		VehicleStateIconContainer:SetBackdropAlpha(0)
		VehicleStateIconContainer:SetEnabled(false) -- Don't show this by default
		
		VehicleStateIcon:SetSize(stateIconWidth, stateIconHeight)
		VehicleStateIcon.texture = VehicleStateIcon:CreateTexture()
		VehicleStateIcon.texture:SetTexture([[Interface\Vehicles\UI-VEHICLES-RAID-ICON]]) -- TODO: Settings for this? --  [[Interface\Icons\Ability_CheapShot]]] Ability_Rogue_KidneyShot  [[Interface\Minimap\Tracking\FlightMaster]]
		VehicleStateIcon.texture:SetAllPoints(VehicleStateIcon)
		VehicleStateIcon.texture:SetTexCoord(0, 1, 0, 1)
		
		-- Player interaction
		VehicleStateIconContainer.Update = function(self)
		
			-- Indicate combat is currently in progress
			self:SetEnabled(settings.stateIcons.enabled and TotalAP.eventStates.isPlayerUsingVehicle)
		
		end
		
	end
	
	PlayerControlStateIconContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_PlayerControlStateIcon", "_DefaultView_AnchorFrame")
	PlayerControlStateIcon = PlayerControlStateIconContainer:GetFrameObject()
	do -- PlayerControlStateIcon
	
		-- Layout and visuals
		PlayerControlStateIconContainer:SetRelativePosition(3 * (stateIconWidth + stateIconSpacer), - stateIconHeight / 2)
		PlayerControlStateIconContainer:SetBackdropColour("#F69282")
		PlayerControlStateIconContainer:SetBackdropAlpha(0)	
		PlayerControlStateIconContainer:SetEnabled(false) -- Don't show this by default
		
		PlayerControlStateIcon:SetSize(stateIconWidth, stateIconHeight)
		PlayerControlStateIcon.texture = PlayerControlStateIcon:CreateTexture()
		PlayerControlStateIcon.texture:SetTexture([[Interface\Minimap\Tracking\FlightMaster]]) 
		PlayerControlStateIcon.texture:SetAllPoints(PlayerControlStateIcon)
		PlayerControlStateIcon.texture:SetTexCoord(0, 1, 0, 1)
		
		-- Player interaction
		PlayerControlStateIconContainer.Update = function(self)
		
			-- Indicate combat is currently in progress
			self:SetEnabled(settings.stateIcons.enabled and TotalAP.eventStates.hasPlayerLostControl)
		
		end
	
	end
	
	UnderlightAnglerFrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_UnderlightAnglerFrame", "_DefaultView_AnchorFrame")
	UnderlightAnglerFrame = UnderlightAnglerFrameContainer:GetFrameObject()
	do -- UnderlightAnglerFrame
	
		-- Layout and visuals
		UnderlightAnglerFrameContainer:SetBackdropColour("#9CCCF8")
		UnderlightAnglerFrameContainer:SetRelativePosition(barInset + 4 * (stateIconWidth + vSpace), -barInset)
		
		UnderlightAnglerFrame:SetSize(barWidth, barHeight)
		
		UnderlightAnglerFrameContainer.Update = function(self)
		
			-- Disable unless the ULA artifact is equipped
			self:SetEnabled(false) -- TODO: No ULA support just yet :) But... soon (TM)
		
		end
		
	end
	
	ActionButtonFrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_ActionButtonFrameContainer", "_DefaultView_AnchorFrame")
	ActionButtonFrame = ActionButtonFrameContainer:GetFrameObject()
	do -- ActionButtonFrame
	
		-- Layout and visuals
		ActionButtonFrameContainer:SetBackdropColour("#123456")
		ActionButtonFrameContainer:SetBackdropAlpha(0)
		ActionButtonFrame:SetSize(maxButtonSize, maxButtonSize)
		
		ActionButtonFrameContainer.Update = function()
		
			-- local dy = 0
			-- local b = 2 * barInset + barHeight + hSpace -- Bar height (TODO: DRY)
			-- local t = ActionButtonText:GetHeight()
		
			-- if settings.actionButton.showText then -- ActionButtonText needs to be considered as well -> Adjust position slightly to make room for it
				-- if settings.infoFrame.alignment == "bottom" then
					-- dy = - (AnchorFrame:GetHeight() ) t + hSpace
				-- elseif settings.infoFrame.alignment == "center" then
					-- dy = dy + 1 / 2 * t
				-- end
			-- else
				-- if settings.infoFrame.alignment == "bottom" then
					-- dy = dy
				-- elseif settings.infoFrame.alignment == "center" then
					-- dy = dy + 1 / 2 * b
				-- end
			-- end
			local _, dy = GetDeltas("button")
			ActionButtonFrameContainer:SetRelativePosition(0, - ( 2 * barInset + barHeight + hSpace) - dy) -- One extra h is to account for the StateIcons (and later ULA bar), which are always anchored at the very top
				
		end
		
	end
	
	ActionButtonContainer = TotalAP.GUI.ItemUseButton:CreateNew("_DefaultView_ActionButton", "_DefaultView_ActionButtonFrameContainer")
	ActionButton = ActionButtonContainer:GetFrameObject()
	do -- ActionButton
		
		-- Layout and visuals
		ActionButton:SetSize(defaultButtonSize, defaultButtonSize)
		ActionButton:SetMinResize(minButtonSize, minButtonSize) -- Let's not go there and make it TINY, shall we?
		ActionButton:SetMaxResize(maxButtonSize, maxButtonSize) -- ... but no one likes a stretched, giant button either)
		
		-- Player interaction
		ActionButton:EnableMouse(true) -- for resizing and dragging the display
		ActionButton:SetMovable(true) -- for dragging the AnchorFrame
		ActionButton:SetResizable(true)
		ActionButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		ActionButton:RegisterForDrag("LeftButton") -- left button = resize or reposition
		
		ActionButtonContainer.Update = function(self)
		
			local spec = GetSpecialization()

			local hideButton = false
			
			-- Hide when:
			hideButton = (hideButton
			or not settings.actionButton.enabled -- Button is disabled via settings
			or not (TotalAP.inventoryCache.numItems > 0)  -- No AP items (or Research Tomes) in inventory
			or not TotalAP.inventoryCache.displayItem.ID -- No item set to button (usually happens on load only)
			or TotalAP.Cache.IsCurrentSpecIgnored() -- Current spec is being ignored
			or (TotalAP.Cache.IsCurrentSpecCached() and TotalAP.ArtifactInterface.IsArtifactMaxed(TotalAP.Cache.GetNumTraits(), TotalAP.Cache.GetArtifactTier())) -- Artifact weapon is maxed (54 traits and tier 1)
			or not TotalAP.ArtifactInterface.HasCorrectSpecArtifactEquipped() -- Current weapon is not the correct artifact, which means AP can't be used anyway
			-- TODO: Underlight Angler -> Show when fish is in inventory
			) and not TotalAP.inventoryCache.foundTome -- BUT: Don't hide if Research Tome exists, regardless of the other conditions being met 
			
			self:SetEnabled(not hideButton)
			if hideButton then return end -- Update is finished, as ActionButton won't be shown
	
			
			local flashButton = false
			
			-- Flash when:
			flashButton = (flashButton
			or TotalAP.ArtifactInterface.GetNumAvailableTraits() > 0	-- Current spec has at least one available trait
			or (TotalAP.inventoryCache.foundTome and TotalAP.DB.IsResearchTome(TotalAP.inventoryCache.displayItem.ID))  -- Current item is Research Tome that can be used (level 110, not maxed AK depending on item (TODO)?)
			) and settings.actionButton.showGlowEffect -- BUT: Only flash if glow effect is enabled for the action button

			-- Set current item to button
			ActionButton.icon:SetTexture(TotalAP.inventoryCache.displayItem.texture)
			local bagSlotString = TotalAP.inventoryCache.displayItem.bag .. " " .. TotalAP.inventoryCache.displayItem.slot -- e.g., 1 5 = bag 1 slot 5 -> refers to the item's position in bags
			if bagSlotString:match("%d%s%d") then -- Is a valid string that refers to an item in the player's inventory
			
				ActionButton:SetAttribute("type", "item")
				ActionButton:SetAttribute("item", bagSlotString)
				
			end
			
			-- Transfer cooldown animation to the button (would otherwise remain static when items are used, which feels artificial)
			local start, duration, enabled = GetItemCooldown(TotalAP.inventoryCache.displayItem.ID)
			if duration > 0 then -- Has visible cooldown that should be displayed on the button (mirroring the item itself if observed in the player's inventory)
					ActionButton.cooldown:SetCooldown(start, duration)
			end
			
			-- Display tooltip when mouse hovers over the action button
			if ActionButton:IsMouseOver() then 
				GameTooltip:SetHyperlink(TotalAP.inventoryCache.displayItem.link)
			end
			
			-- Flash action button
			self:SetFlashing(flashButton)
			
			-- Resize and reposition
			local w, h = ActionButton:GetWidth(), ActionButton:GetHeight()
			if w > h then ActionButton:SetWidth(h) else ActionButton:SetHeight(w) end -- Keep aspect ratio square (1:1)
			
			local dx, dy = (ActionButtonFrame:GetWidth() - ActionButton:GetWidth()) / 2, (ActionButtonFrame:GetHeight() - ActionButton:GetHeight()) / 2 -- deltas to reposition button in the centre of the surrounding ActionButtonFrame
			ActionButtonContainer:SetRelativePosition(max(0, dx), - dy)

		end
		
		-- Script handlers
		ActionButton:SetScript("OnMouseDown", function(self) -- Show background if user pressed drag modifier to indicate the display can be dragged
			
			if IsAltKeyDown() then -- Make background visible
				
				AnchorFrameContainer:SetBackdropAlpha(0.5)
				if not InCombatLockdown() then
					AnchorFrameContainer:Render()
				end
			end
			
			if IsShiftKeyDown() then -- Make ActionButton background visible
		
				ActionButtonFrameContainer:SetBackdropAlpha(0.5)
				if not InCombatLockdown() then
					ActionButtonFrameContainer:Render()
				end
			end
		
		end)
		
		ActionButton:SetScript("OnMouseUp", function(self) -- Hide background

			ActionButtonFrameContainer:SetBackdropAlpha(0)
			
			if not InCombatLockdown() then
				ActionButtonFrameContainer:Render()
			end
			
		end)
		
		ActionButton:SetScript("OnEnter", function(self)  -- (to show the tooltip on mouseover)
		
			if TotalAP.inventoryCache.displayItem.ID then -- An item is assigned to the button and can be displayed in the tooltip
			
				GameTooltip:SetOwner(ActionButton, "ANCHOR_RIGHT");
				GameTooltip:SetHyperlink(TotalAP.inventoryCache.displayItem.link)
				
			end
			
		end)
		
		ActionButton:SetScript("OnLeave", function(self)  -- (to hide the tooltip afterwards)
		
			GameTooltip:Hide()
			
		end)
			
		ActionButton:SetScript("OnHide", function(self) -- (to clear the set item when hiding the button)
		
			if not InCombatLockdown() and not UnitAffectingCombat("player") then -- Don't reset attributes just yet -> TODO: Is this really necessary? Should actually be triggered BEFORE combat begins?
				self:SetAttribute("type", nil)
				self:SetAttribute("item", nil)
			end
			
		end)
	
		ActionButton:SetScript("OnDragStart", function(self) -- (to allow dragging the button, and also to resize it)
		
			if self:IsMovable() and IsAltKeyDown() then -- Alt -> Move display
			
				AnchorFrame.isMoving = true
				AnchorFrame:StartMoving() 
		
			elseif self:IsResizable() and IsShiftKeyDown() then -- Shift -> Resize button
			
				self:StartSizing()
				self.isSizing = true
				-- Show background frame (max size) while dragging
				ActionButtonFrameContainer:SetBackdropAlpha(0.5)
				if not InCombatLockdown() then
					ActionButtonFrameContainer:Render()
				end
			end
				
		end)
		
		ActionButton:SetScript("OnUpdate", function(self) -- (to update the button skin and proportions while being resized)
			
			if self.isSizing then -- Update graphics to make sure the border/glow effect etc. is re-applied correctly (especially when resizing)
				
				ActionButtonContainer:Update()
				ActionButtonContainer:Render()
				
			end
		end)
		
		ActionButton:SetScript("OnDragStop", function(self) -- (to update the button skin and stop it from being moved after dragging has ended)

			self:StopMovingOrSizing()
			AnchorFrame:StopMovingOrSizing()
			AnchorFrame.isMoving = false
			self.isSizing = false
			
			-- Hide background frame once more
			ActionButtonFrameContainer:SetBackdropAlpha(0)
			ActionButtonFrameContainer:Render()
			
			AnchorFrameContainer:SetBackdropAlpha(0)
			AnchorFrameContainer:Render()
			
			if not IsAltKeyDown() and ActionButtonContainer:GetFlashing() then -- Re-flash to show glow effect properly if button's size changed (and it isn't currently being resized) -- TODO: Maybe this should be done while rendering instead
					
				ActionButtonContainer:ToggleFlashing()
					
			end
			
			ActionButtonContainer:Update()
			ActionButtonContainer:Render()
				
		end)
		
	end
	
	ActionButtonTextContainer = TotalAP.GUI.TextDisplay:CreateNew("_DefaultView_ActionButtonText", "_DefaultView_ActionButtonFrameContainer", buttonTextTemplate)
	ActionButtonText = ActionButtonTextContainer:GetFrameObject()
	do -- ActionButtonTextContainer
	
		-- Layout and visuals
		ActionButtonTextContainer:SetAnchorPoint("TOPLEFT")
		ActionButtonTextContainer:SetTargetAnchorPoint("BOTTOMLEFT")
		ActionButtonTextContainer:SetTextAlignment("center")
		ActionButtonTextContainer.Update = function(self) -- TODO: More options to change the displayed text format - planned once advanced config is implemented via AceConfig
		
			local offset = max(hSpace, (maxButtonSize - ActionButton:GetHeight()) / 2 - hSpace) -- This offset moves the text alongside the button if it changes size
			ActionButtonTextContainer:SetRelativePosition(0, - hSpace + offset - 5) -- Always keep 5 pixels of space between the two visible elements so that the text remains readable
			local text = ""
			
			if settings.actionButton.showText and not TotalAP.inventoryCache.foundTome and TotalAP.inventoryCache.numItems > 0 then -- Display current item's AP value as text (if enabled)

				if TotalAP.inventoryCache.numItems > 1 then -- Display total AP in bags
			
					if settings.scanBank and TotalAP.bankCache.numItems > 0 and TotalAP.bankCache.inBankAP > 0 then -- Also include banked AP
				
						text = TotalAP.Utils.FormatShort(TotalAP.inventoryCache.displayItem.artifactPowerValue, true, settings.numberFormat) .. "\n(" .. TotalAP.Utils.FormatShort(TotalAP.inventoryCache.inBagsAP, true, settings.numberFormat) .. ")\n[" .. TotalAP.Utils.FormatShort(TotalAP.bankCache.inBankAP, true, settings.numberFormat) .. "]" -- e.g., 75m\n(300m)\n[25m] = display current, inBags, and banked AP
						
					else -- Only display current item and inventory AP
			
						text = TotalAP.Utils.FormatShort(TotalAP.inventoryCache.displayItem.artifactPowerValue, true, settings.numberFormat) .. "\n(" .. TotalAP.Utils.FormatShort(TotalAP.inventoryCache.inBagsAP, true, settings.numberFormat) .. ")" -- e.g., 75m\n(300m)
					 
					 end
					 
				else -- Only display the current item's AP, as well as banked AP if it was saved (i.e., omit inventory AP) - TODO: This seems messy, and should likely be reworked to be more straight-forward / remove duplicate code
		
					if settings.scanBank and TotalAP.bankCache.numItems > 0 and TotalAP.bankCache.inBankAP > 0 then -- Also include banked AP
						
						text = TotalAP.Utils.FormatShort(TotalAP.inventoryCache.displayItem.artifactPowerValue, true, settings.numberFormat) .. "\n[" .. TotalAP.Utils.FormatShort(TotalAP.bankCache.inBankAP, true, settings.numberFormat) .. "]"
					
					else
					
						text = TotalAP.Utils.FormatShort(TotalAP.inventoryCache.displayItem.artifactPowerValue, true, settings.numberFormat)
						
					end
					
				end
					
			end
			
			self:SetText(text)
			
			self:SetEnabled(ActionButtonContainer:GetEnabled())
			
		end
		
		-- Script handlers
		ActionButton:HookScript("OnDragStop", function(self) -- Required to reposition the button text while the button is being dragged
		
			ActionButtonTextContainer:Update()
			ActionButtonTextContainer:Render()
		
		end)
		
	end
	
	SpecIcon1FrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_SpecIcon1Container", "_DefaultView_AnchorFrame")
	SpecIcon1Frame = SpecIcon1FrameContainer:GetFrameObject()
	SpecIcon2FrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_SpecIcon2Container", "_DefaultView_AnchorFrame")
	SpecIcon2Frame = SpecIcon2FrameContainer:GetFrameObject()
	SpecIcon3FrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_SpecIcon3Container", "_DefaultView_AnchorFrame")
	SpecIcon3Frame = SpecIcon3FrameContainer:GetFrameObject()
	SpecIcon4FrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_SpecIcon4Container", "_DefaultView_AnchorFrame")
	SpecIcon4Frame = SpecIcon4FrameContainer:GetFrameObject()
	do -- SpecIconFrames
	
		-- Layout and visuals
		SpecIcon1FrameContainer:SetBackdropColour("#654321")
		SpecIcon2FrameContainer:SetBackdropColour("#654321")
		SpecIcon3FrameContainer:SetBackdropColour("#654321")
		SpecIcon4FrameContainer:SetBackdropColour("#654321")

		SpecIcon1Frame:SetSize(specIconSize + 2 * specIconBorderWidth, specIconSize + 2 * specIconBorderWidth)
		SpecIcon2Frame:SetSize(specIconSize + 2 * specIconBorderWidth, specIconSize + 2 * specIconBorderWidth)
		SpecIcon3Frame:SetSize(specIconSize + 2 * specIconBorderWidth, specIconSize + 2 * specIconBorderWidth)
		SpecIcon4Frame:SetSize(specIconSize + 2 * specIconBorderWidth, specIconSize + 2 * specIconBorderWidth)
		
		-- Player interaction
		SpecIcon1FrameContainer:SetAssignedSpec(1)
		SpecIcon2FrameContainer:SetAssignedSpec(2)
		SpecIcon3FrameContainer:SetAssignedSpec(3)
		SpecIcon4FrameContainer:SetAssignedSpec(4)
		
		local UpdateFunction = function(self)
			
			local spec = self:GetAssignedSpec()
			
			if spec == GetSpecialization() then -- Indicate active spec via background colour
			
				self:SetBackdropColour("#FF8000")
			
			else -- Show normal background (TODO: Hide)
			
				self:SetBackdropColour("#000000")
			
			end
			
			local hideFrame = false
			
			-- Hide when:
			hideFrame = (hideFrame
			or not settings.specIcons.enabled -- Spec icons have been disabled
			or TotalAP.Cache.IsSpecIgnored(spec) -- Assigned spec is being ignored
			or GetNumSpecializations() < spec -- Class doesn't have as many specs
			)
			
			self:SetEnabled(not hideFrame)
			if hideFrame then return end
			
			-- Reposition if any specs have been ignored to make sure there are no odd-looking gaps in the display
			local displaySpec = GetDisplayOrderForSpec(spec)
			local specOffset = (displaySpec - 1) * (barHeight + 2 * barInset + hSpace)-- This offset is to move each spec into its correct place (from the top)
			local glueOffset = ((barHeight + 2 * barInset) - (specIconSize + 2 * specIconBorderWidth)) / 2 -- This offset makes sure the spec icons are always next to the progress bars
			local _, alignmentOffset = GetDeltas() -- This offset is for repositioning them according to the /ap alignment-X setting
			local hiddenProgressBarsOffset = 0 -- If progress bars are hidden, move spec icons in their place
			if not ProgressBarsFrame:IsShown() then hiddenProgressBarsOffset = barWidth + 2 * barInset + vSpace end -- TODO: function to calculate GUI element positions (can be unique to each view, allowing customisation for different ones without changing the main view code?) This would remove all the duplicate code and allow settings to change views more easily
			self:SetRelativePosition(maxButtonSize + vSpace + barWidth + 2 * barInset + vSpace - hiddenProgressBarsOffset, - ( barHeight + 2 * barInset + hSpace + specOffset + glueOffset + alignmentOffset))
			
		end
		
		SpecIcon1FrameContainer.Update = UpdateFunction
		SpecIcon2FrameContainer.Update = UpdateFunction
		SpecIcon3FrameContainer.Update = UpdateFunction
		SpecIcon4FrameContainer.Update = UpdateFunction
		
	end
	
	SpecIcon1Container = TotalAP.GUI.SpecIcon:CreateNew("_DefaultView_SpecIcon1", "_DefaultView_SpecIcon1Container")
	SpecIcon1 = SpecIcon1Container:GetFrameObject()
	SpecIcon2Container = TotalAP.GUI.SpecIcon:CreateNew("_DefaultView_SpecIcon2", "_DefaultView_SpecIcon2Container")	
	SpecIcon2 = SpecIcon2Container:GetFrameObject()
	SpecIcon3Container = TotalAP.GUI.SpecIcon:CreateNew("_DefaultView_SpecIcon3", "_DefaultView_SpecIcon3Container")
	SpecIcon3 = SpecIcon3Container:GetFrameObject()
	SpecIcon4Container = TotalAP.GUI.SpecIcon:CreateNew("_DefaultView_SpecIcon4", "_DefaultView_SpecIcon4Container")
	SpecIcon4 = SpecIcon4Container:GetFrameObject()
	do -- SpecIcons
		
		-- Layout and visuals
		SpecIcon1Container:SetRelativePosition(specIconBorderWidth, -specIconBorderWidth)
		SpecIcon2Container:SetRelativePosition(specIconBorderWidth, -specIconBorderWidth)
		SpecIcon3Container:SetRelativePosition(specIconBorderWidth, -specIconBorderWidth)
		SpecIcon4Container:SetRelativePosition(specIconBorderWidth, -specIconBorderWidth)
		
		SpecIcon1:SetSize(specIconSize, specIconSize)
		SpecIcon2:SetSize(specIconSize, specIconSize)
		SpecIcon3:SetSize(specIconSize, specIconSize)
		SpecIcon4:SetSize(specIconSize, specIconSize)

		-- Player interaction
		SpecIcon1Container:SetAssignedSpec(1)
		SpecIcon2Container:SetAssignedSpec(2)
		SpecIcon3Container:SetAssignedSpec(3)
		SpecIcon4Container:SetAssignedSpec(4)
		
		local SpecIconUpdateFunction = function(self)
		
			local spec = self:GetAssignedSpec()
			
			-- Set textures (TODO: only needs to be done once, as specs are generally static)
			self:GetFrameObject().icon:SetTexture(select(4, GetSpecializationInfo(spec)))
			
			if not TotalAP.Cache.IsSpecCached(spec) then return end
			
			local numTraitsPurchased = TotalAP.Cache.GetNumTraits(spec)
			local unspentAP = TotalAP.Cache.GetUnspentAP(spec)
			local artifactTier = TotalAP.Cache.GetArtifactTier(spec)
			
			local numTraitsAvailable = TotalAP.ArtifactInterface.GetNumRanksPurchasableWithAP(numTraitsPurchased,  unspentAP + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0), artifactTier)
			
			local flashButton = false
			-- Flash when:
			flashButton = (flashButton
			or numTraitsAvailable > 0 -- New traits are available
			) and settings.specIcons.showGlowEffect -- BUT: Only flash if glow effect is enabled
			and not TotalAP.ArtifactInterface.IsArtifactMaxed(numTraitsPurchased, artifactTier) -- AND only if the artifact is not maxed yet
		
			-- Flash spec icon button
			self:SetFlashing(flashButton)
			
		end
		
		SpecIcon1Container.Update = SpecIconUpdateFunction
		SpecIcon2Container.Update = SpecIconUpdateFunction
		SpecIcon3Container.Update = SpecIconUpdateFunction
		SpecIcon4Container.Update = SpecIconUpdateFunction
		
		-- Script handlers
		-- TODO: Button script handlers in separate file to clean up  this mess and start refactoring it
		local SpecIconOnMouseUpFunction = function(self, button) -- When clicked, change spec accordingly to the button's icon (click) OR ignore the spec (right-click)
	
			local spec = tonumber(self:GetName():match(".*(%d)"))
		
			 if button == "RightButton" then -- Ignore spec
	
				 -- Add spec to ignored specs (actually, it is flagged as "ignored" for the current character only)
				 if TotalAP.Cache.IsSpecIgnored(spec) then  -- Spec is already being ignored
					TotalAP.Debug("Attempting to ignore spec, but spec " .. spec .. " is already ignored for character " .. fqcn)
					return
				 end
				 
				 TotalAP.ChatMsg(format(TotalAP.L["Ignoring spec %d (%s) for character %s"], spec, select(2, GetSpecializationInfo(spec)), fqcn))
				 TotalAP.Cache.IgnoreSpec(spec)
				 
				 -- Show one-time warning if necessary
				if not TotalAP.specIgnoredWarningGiven then
					TotalAP.ChatMsg(format(TotalAP.L["Type %s to reset all currently ignored specs for this character"], "/" .. TotalAP.Controllers.GetSlashCommandAlias() .. " unignore"))
					TotalAP.specIgnoredWarningGiven = true
				end
				
				-- Hide spec icon for the now.ignored spec
				TotalAP.Controllers.RenderGUI()
			
			else -- Activate spec
				
				if AnchorFrame.isMoving then -- Stop moving, but ignore this click

					AnchorFrame_OnDragStop(self)
					return -- Don't activate spec while moving is enabled (technically, the AnchorFrame is being moved, so the specIcon should not be clicked)
					
				end
		
				-- Change spec as per the player's selection (if it isn't active already)
				if GetSpecialization() ~= spec then
				
					-- Dismount if not flying (wouldn't want to kill the player, now would we?) / SHOULD also cancel shapeshifts of any kind, at least out of combat -- TODO: Setting to allow forced dismount even if flying/Test with chakras and other "weird" shapeshifts
					if (IsMounted() or GetShapeshiftForm() > 0) and not (IsFlying() or InCombatLockdown() or UnitAffectingCombat("player")) then
					
						Dismount()
						CancelShapeshiftForm() -- TODO: Protected -> may cause issues if called in combat? (Not sure if InCombatLockdown is enough to detect this reliably)
						
					end
					
					SetSpecialization(spec)
					
				end
			
			end
			 
		end
 
		SpecIcon1:SetScript("OnMouseUp", SpecIconOnMouseUpFunction)
		SpecIcon2:SetScript("OnMouseUp", SpecIconOnMouseUpFunction)
		SpecIcon3:SetScript("OnMouseUp", SpecIconOnMouseUpFunction)
		SpecIcon4:SetScript("OnMouseUp", SpecIconOnMouseUpFunction)
		
		SpecIcon1:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowSpecIconTooltip)
		SpecIcon2:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowSpecIconTooltip)
		SpecIcon3:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowSpecIconTooltip)
		SpecIcon4:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowSpecIconTooltip)
		
		SpecIcon1:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideSpecIconTooltip)
		SpecIcon2:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideSpecIconTooltip)
		SpecIcon3:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideSpecIconTooltip)
		SpecIcon4:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideSpecIconTooltip)
		
		SpecIcon1:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		SpecIcon2:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		SpecIcon3:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		SpecIcon4:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		
		-- OnDragStop is handled by the spec icon's OnClick function

	end
	
	SpecIcon1TextContainer = TotalAP.GUI.TextDisplay:CreateNew("_DefaultView_SpecIcon1Text", "_DefaultView_SpecIcon1Container", specIconTextTemplate)
	SpecIcon1Text = SpecIcon1TextContainer:GetFrameObject()
	SpecIcon2TextContainer = TotalAP.GUI.TextDisplay:CreateNew("_DefaultView_SpecIcon2Text", "_DefaultView_SpecIcon2Container", specIconTextTemplate)
	SpecIcon2Text = SpecIcon2TextContainer:GetFrameObject()
	SpecIcon3TextContainer = TotalAP.GUI.TextDisplay:CreateNew("_DefaultView_SpecIcon3Text", "_DefaultView_SpecIcon3Container", specIconTextTemplate)
	SpecIcon3Text = SpecIcon3TextContainer:GetFrameObject()
	SpecIcon4TextContainer = TotalAP.GUI.TextDisplay:CreateNew("_DefaultView_SpecIcon4Text", "_DefaultView_SpecIcon4Container", specIconTextTemplate)
	SpecIcon4Text = SpecIcon4TextContainer:GetFrameObject()
	do -- SpecIconsText
	
		-- Layout and visuals
		
		
		-- Player interaction
		SpecIcon1TextContainer:SetAssignedSpec(1)
		SpecIcon2TextContainer:SetAssignedSpec(2)
		SpecIcon3TextContainer:SetAssignedSpec(3)
		SpecIcon4TextContainer:SetAssignedSpec(4)
		
		local SpecIconTextUpdateFunction = function(self)
		
			local spec = self:GetAssignedSpec()
			
			if not TotalAP.Cache.IsSpecCached(spec) then return end
			
			local text = ""
			
			local numTraitsPurchased = TotalAP.Cache.GetNumTraits(spec)
			local unspentAP = TotalAP.Cache.GetUnspentAP(spec)
			local artifactTier = TotalAP.Cache.GetArtifactTier(spec)
			
			local numTraitsAvailable = TotalAP.ArtifactInterface.GetNumRanksPurchasableWithAP(numTraitsPurchased,  unspentAP + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0), artifactTier)
			local nextLevelRequiredAP = C_ArtifactUI.GetCostForPointAtRank(numTraitsPurchased, artifactTier)
			local percentageOfCurrentLevelUp = (unspentAP  + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0)) / nextLevelRequiredAP*100;
			
			if numTraitsAvailable > 0  then -- Set text to display number of available traits
			
				text = format("x%d", numTraitsAvailable)
				
			else -- Display percentage instead
			
				text = format("%d%%", percentageOfCurrentLevelUp)
				
			end
			
			if not (numTraitsPurchased < 54 or artifactTier > 1) then -- Artifact is maxed
				text = "---" -- TODO: MAX? Empty? Anything else?
			end
			
			if settings.specIcons.showNumTraits then
				text = "[|cffffffff" .. numTraitsPurchased .. "|r] " .. text 
			end -- Change text to format: (XX) YY% instead of the old default, YY%
			self:SetText(text)
		
			-- Reposition and set anchors (needs to be done here, as the FontString size is 1 initially)
			SpecIcon1TextContainer:SetRelativePosition(vSpace, -(SpecIcon1Frame:GetHeight() - SpecIcon1Text:GetHeight()) / 2)
			SpecIcon1TextContainer:SetAnchorPoint("TOPLEFT")
			SpecIcon1TextContainer:SetTargetAnchorPoint("TOPRIGHT")
			SpecIcon1TextContainer:SetVerticalAlignment("center")
			
			SpecIcon2TextContainer:SetRelativePosition(vSpace, -(SpecIcon2Frame:GetHeight() - SpecIcon2Text:GetHeight()) / 2)
			SpecIcon2TextContainer:SetAnchorPoint("TOPLEFT")
			SpecIcon2TextContainer:SetTargetAnchorPoint("TOPRIGHT")
			SpecIcon2TextContainer:SetVerticalAlignment("center")
			
			SpecIcon3TextContainer:SetRelativePosition(vSpace, -(SpecIcon3Frame:GetHeight() - SpecIcon3Text:GetHeight()) / 2)
			SpecIcon3TextContainer:SetAnchorPoint("TOPLEFT")
			SpecIcon3TextContainer:SetTargetAnchorPoint("TOPRIGHT")
			SpecIcon3TextContainer:SetVerticalAlignment("center")
			
			SpecIcon4TextContainer:SetRelativePosition(vSpace, -(SpecIcon4Frame:GetHeight() - SpecIcon4Text:GetHeight()) / 2)
			SpecIcon4TextContainer:SetAnchorPoint("TOPLEFT")
			SpecIcon4TextContainer:SetTargetAnchorPoint("TOPRIGHT")
			SpecIcon4TextContainer:SetVerticalAlignment("center")
		
		end
		
		SpecIcon1TextContainer.Update = SpecIconTextUpdateFunction
		SpecIcon2TextContainer.Update = SpecIconTextUpdateFunction
		SpecIcon3TextContainer.Update = SpecIconTextUpdateFunction
		SpecIcon4TextContainer.Update = SpecIconTextUpdateFunction
		
	end
	
	ProgressBarsFrameContainer = TotalAP.GUI.BackgroundFrame:CreateNew("_DefaultView_ProgressBarsFrame", "_DefaultView_AnchorFrame")
	ProgressBarsFrame = ProgressBarsFrameContainer:GetFrameObject()
	do -- ProgressBarsFrame
	 
		-- Layout and visuals
		ProgressBarsFrameContainer:SetBackdropFile("Interface\\GLUES\\COMMON\\Glue-Tooltip-Background.blp") -- semi-transparent
		ProgressBarsFrameContainer:SetBackdropColour("#000000")

		-- Player interaction		
		ProgressBarsFrameContainer.Update = function(self)
		
			local hideFrame = false
			hideFrame = (hideFrame or
				not settings.infoFrame.enabled -- Bars are diabled via settings (TODO: infoFrame no longer exists -> rename settings?)
			)
			
			self:SetEnabled(not hideFrame)
			if hideFrame then return end
		
			local _, dy = GetDeltas()
			local combinedBarsHeight = (GetNumSpecializations() - TotalAP.Cache.GetNumIgnoredSpecs()) * (2 * barInset + barHeight + hSpace) -- One bar per spec that is not ignored, and the ULA bar (NYI) / StateIcons
			self:SetRelativePosition(maxButtonSize + vSpace, - ( barHeight + 2 * barInset + hSpace) - dy)
			self:GetFrameObject():SetSize(barWidth + 2 * barInset, combinedBarsHeight)
		
		end
		
		-- Script handlers
		
	 end
	
	ProgressBar1Container = TotalAP.GUI.ProgressBar:CreateNew("_DefaultView_ProgressBar1", "_DefaultView_ProgressBarsFrame")
	ProgressBar1 = ProgressBar1Container:GetFrameObject()
	ProgressBar2Container = TotalAP.GUI.ProgressBar:CreateNew("_DefaultView_ProgressBar2", "_DefaultView_ProgressBarsFrame")
	ProgressBar2 = ProgressBar2Container:GetFrameObject()
	ProgressBar3Container = TotalAP.GUI.ProgressBar:CreateNew("_DefaultView_ProgressBar3", "_DefaultView_ProgressBarsFrame")
	ProgressBar3 = ProgressBar3Container:GetFrameObject()
	ProgressBar4Container = TotalAP.GUI.ProgressBar:CreateNew("_DefaultView_ProgressBar4", "_DefaultView_ProgressBarsFrame")
	ProgressBar4 = ProgressBar4Container:GetFrameObject()
	do -- ProgressBars
	
		-- Layout and visuals

		-- Player interaction
		ProgressBar1Container:SetAssignedSpec(1)
		ProgressBar2Container:SetAssignedSpec(2)
		ProgressBar3Container:SetAssignedSpec(3)
		ProgressBar4Container:SetAssignedSpec(4)
		
		local ProgressBarUpdateFunction = function(self)
		
			local spec = self:GetAssignedSpec()
		
			local hideFrame = false
			-- Hide when:
			hideFrame = (hideFrame
			or spec > GetNumSpecializations() -- Class doesn't have as many specs
			or not TotalAP.Cache.IsSpecCached(spec) -- Spec is not cached
			or TotalAP.Cache.IsSpecIgnored(spec) -- Spec is being ignored
			or not settings.infoFrame.enabled -- Bars are diabled via settings (TODO: infoFrame no longer exists -> rename settings?)
			)
			
			self:SetEnabled(not hideFrame)
			if hideFrame then return end
			
			-- Set progress bar widths according to the cached artifact data
			if not TotalAP.Cache.IsSpecCached(spec) then return end
			
			local unspentAP = TotalAP.Cache.GetUnspentAP(spec)
			local numTraitsPurchased = TotalAP.Cache.GetNumTraits(spec)
			local artifactTier = TotalAP.Cache.GetArtifactTier(spec)
			
			local percentageUnspentAP = min(100, math.floor(unspentAP / C_ArtifactUI.GetCostForPointAtRank(numTraitsPurchased, artifactTier) * 100)) 	-- Cap values at 100 (width) to prevent the bar from overflowing and glitching out
			local percentageInBagsAP = min(math.floor(TotalAP.inventoryCache.inBagsAP/ C_ArtifactUI.GetCostForPointAtRank(numTraitsPurchased, artifactTier) * 100), 100 - percentageUnspentAP)
			local percentageInBankAP = min(math.floor(TotalAP.bankCache.inBankAP/ C_ArtifactUI.GetCostForPointAtRank(numTraitsPurchased, artifactTier) * 100), 100 - percentageUnspentAP - percentageInBagsAP)
			local maxAttainableRank =  numTraitsPurchased + TotalAP.ArtifactInterface.GetNumRanksPurchasableWithAP(numTraitsPurchased, unspentAP + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0),  artifactTier) 
			local progressPercent = TotalAP.ArtifactInterface.GetProgressTowardsNextRank(numTraitsPurchased , unspentAP + TotalAP.inventoryCache.inBagsAP + tonumber(settings.scanBank and TotalAP.bankCache.inBankAP or 0), artifactTier)
TotalAP.Debug("spec " .. spec .. ": unspentAP = " .. unspentAP .. ", numTraitsPurchased = " .. numTraitsPurchased .. ", artifactTier = " .. artifactTier); TotalAP.Debug("spec " .. spec .. ": percentageUnspentAP = " .. percentageUnspentAP .. ", percentageInBagsAP = " .. percentageInBagsAP .. ", percentageInBankAP = " .. percentageInBankAP .. ", maxAttainableRank = " .. maxAttainableRank .. ", progressPercent = " .. progressPercent)
					
			self:SetWidth(percentageUnspentAP, "UnspentBar")
			self:SetWidth(percentageUnspentAP + percentageInBagsAP, "InBagsBar")
			self:SetWidth(percentageUnspentAP + percentageInBagsAP + percentageInBankAP, "InBankBar")
			self:SetWidth(progressPercent, "MiniBar")
			
			-- Toggle visibility for individual progress bars
			if percentageUnspentAP > 0 then -- Display UnspentBar
				
				self:EnableBar("UnspentBar")
			
			else
				
				self:DisableBar("UnspentBar")
			
			end

			if maxAttainableRank > numTraitsPurchased and progressPercent > 0 and settings.infoFrame.showMiniBar and not TotalAP.ArtifactInterface.IsArtifactMaxed(maxAttainableRank, artifactTier) then -- Display MiniBar
			
				self:EnableBar("MiniBar")
			
			else

				self:DisableBar("MiniBar")
			
			end
			
			if percentageInBagsAP > 0 then -- Display inBagsBar
			
				self:EnableBar("InBagsBar")
			
			else
				
				self:DisableBar("InBagsBar")
				
			end
			
			if percentageInBankAP > 0 and settings.scanBank then -- Display inBankBar
			
				self:EnableBar("InBankBar")
			
			else
				
				self:DisableBar("InBankBar")
				
			end
			
			-- If the artifact is maxed, display "white" bar and hide the others to indicate this fact
			if TotalAP.ArtifactInterface.IsArtifactMaxed(numTraitsPurchased, artifactTier) then -- Overwrite bars
			
				self:SetWidth(100, "UnspentBar")
				self:EnableBar("UnspentBar")
				self:DisableBar("InBagsBar")
				self:DisableBar("InBankBar")
			
				self:SetColour("UnspentBar", "#EFE5B0") -- Colour bar white-ish
			
			else -- Reset unspent bar to its default colour
			
				self:SetColour("UnspentBar", "#3296FA")
			
			end
			
			-- Reposition if any specs have been ignored to make sure there are no odd-looking gaps in the display
			local displaySpec = GetDisplayOrderForSpec(spec)
			local offsetY = (spec - displaySpec) * (hSpace + barHeight + 2 * barInset)
			self:SetRelativePosition(barInset, - barInset - (spec - 1) * (barHeight + 2 * barInset + hSpace) + offsetY)
		
		end
		
		ProgressBar1Container.Update = ProgressBarUpdateFunction
		ProgressBar2Container.Update = ProgressBarUpdateFunction
		ProgressBar3Container.Update = ProgressBarUpdateFunction
		ProgressBar4Container.Update = ProgressBarUpdateFunction
		
		-- Script handlers
		ProgressBar1:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowArtifactKnowledgeTooltip)
		ProgressBar1:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideArtifactKnowledgeTooltip)
		ProgressBar2:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowArtifactKnowledgeTooltip)
		ProgressBar2:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideArtifactKnowledgeTooltip)
		ProgressBar3:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowArtifactKnowledgeTooltip)
		ProgressBar3:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideArtifactKnowledgeTooltip)
		ProgressBar4:SetScript("OnEnter", TotalAP.GUI.Tooltips.ShowArtifactKnowledgeTooltip)
		ProgressBar4:SetScript("OnLeave", TotalAP.GUI.Tooltips.HideArtifactKnowledgeTooltip)
		
		ProgressBar1:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		ProgressBar1:SetScript("OnMouseUp", AnchorFrame_OnDragStop)
		ProgressBar2:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		ProgressBar2:SetScript("OnMouseUp", AnchorFrame_OnDragStop)
		ProgressBar3:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		ProgressBar3:SetScript("OnMouseUp", AnchorFrame_OnDragStop)			
		ProgressBar4:SetScript("OnMouseDown", AnchorFrame_OnDragStart)
		ProgressBar4:SetScript("OnMouseUp", AnchorFrame_OnDragStop)
		
	end
	
	ViewObject.elementsList = { 	-- This is the actual view, which consists of individual DisplayFrame objects and their properties
	
		AnchorFrameContainer,
		CombatStateIconContainer,
		PetBattleStateIconContainer,
		VehicleStateIconContainer,
		PlayerControlStateIconContainer,
		UnderlightAnglerFrameContainer,
		ActionButtonFrameContainer,
		ActionButtonContainer,
		ActionButtonTextContainer,
		ProgressBarsFrameContainer,
		ProgressBar1Container,
		ProgressBar2Container,
		ProgressBar3Container,
		ProgressBar4Container,
		SpecIcon1FrameContainer,
		SpecIcon1Container,
		SpecIcon2FrameContainer,
		SpecIcon2Container,
		SpecIcon3FrameContainer,
		SpecIcon3Container,
		SpecIcon4FrameContainer,
		SpecIcon4Container,
		SpecIcon1TextContainer,
		SpecIcon2TextContainer,
		SpecIcon3TextContainer,
		SpecIcon4TextContainer,
	}
	
	return ViewObject
	
end

DefaultView.CreateNew = CreateNew

TotalAP.GUI.DefaultView = DefaultView

return DefaultView
