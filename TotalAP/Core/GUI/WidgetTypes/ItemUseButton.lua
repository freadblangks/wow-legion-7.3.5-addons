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

local addonName, TotalAP = ...
if not TotalAP then return end

local LBG = LibStub("LibButtonGlow-1.0")

-- Localized globals
local _G = _G -- Required to get parent frame references from their names


-- Private variables
local ItemUseButton = {}

--- Default values that are applied to newly created frames automatically
local defaultValues = {

	icon = "",
	isFlashing = false,
	borderTexture = "",

}


-- ItemUseButton inherits from DisplayFrame
setmetatable(ItemUseButton, TotalAP.GUI.DisplayFrame) 

--- Retrieves the currently used icon texture
-- @param self Reference to the caller
-- @return Icon texture path (relative path in the WOW client)
local function GetIcon(self)
	
	return self.icon or defaultValues.icon
	
end

--- Sets the icon texture that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param icon Icon texture path (relative path in the WOW client)
local function SetIcon(self, icon)

	self.icon = icon or self.icon

end

--- Returns whether or not the contained FrameObject is set to be flashing
-- @param self Reference to the caller
-- @returns True if the FrameObject is set to be flashing; false otherwise
local function GetFlashing(self)

	return (self.isFlashing ~= nil and self.isFlashing) or defaultValues.isFlashing -- TODO: Needs to be done for all widgets... Refactor first to save work

end

--- Toggles the glow effect (flash) that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param flashingStatus Whether or not the Frame should be flashed
local function SetFlashing(self, flashingStatus)

	if flashingStatus ~= nil then
		self.isFlashing = flashingStatus
	end
	
end

--- Toggles the glow effect (flash) and directly applies it to the contained FrameObject without altering the flashing status. Used to re-enable the glow effect without waiting for the next call to Render()
local function ToggleFlashing(self)

	-- TODO: Move this to DisplayFrame?
	local FrameObject = self:GetFrameObject()
	if not FrameObject then return end

	if self:GetFlashing() then -- Turn off glow effect prior to re-enabling it
	
		LBG.HideOverlayGlow(FrameObject)
		LBG.ShowOverlayGlow(FrameObject)
		
	end
	
end

--- Retrieves the currently used border texture
-- @param self Reference to the caller
-- @return Border texture path (relative path in the WOW client)
local function GetBorder(self)

	return self.borderTexture or defaultValues.borderTexture

end

--- Sets the border texture that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param borderTexture Border texture path (relative path in the WOW client)
local function SetBorder(self, borderTexture)

	self.borderTexture = borderTexture or self.borderTexture

end

--- Applies all the contained information to the underlying FrameObject to display them ingame
-- @param self Reference to the caller
local function Render(self)
	
	local FrameObject = self:GetFrameObject()
	
	-- Make sure Frame is created properly (and ItemUseButton was instantiated at some point)
	if not FrameObject then
		TotalAP.Debug("FrameObject not found (called Render() before CreateNew()?) -> aborting...")
		return
	end
	
	local isEnabled = self:GetEnabled()
	if isEnabled then -- Display Frame and apply changes where necessary
	
		-- Set icon
		
		-- Set border

		-- Masque update (if required)
		TotalAP.Utils.MasqueUpdate(FrameObject, "ItemUseButton")
		
		-- Apply or remove glow effect (TODO: Can this be moved to DisplayFrame?)
		if self:GetFlashing() then 

			LBG.ShowOverlayGlow(FrameObject)
			
		else

			LBG.HideOverlayGlow(FrameObject)
			
		end
		
		-- Reposition 
		if self:GetParent() ~= "UIParent" then -- Position relatively to its parent and the given settings to have it align automatically
		
			FrameObject:ClearAllPoints()
			local posX, posY = unpack(self:GetRelativePosition())

			FrameObject:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY)
			
		else -- Is top level frame and mustn't be reset, as its position is stored in WOW's Layout Cache
		
		end
		
	end
	
		-- Toggle visibility
	FrameObject:SetShown(isEnabled)

end


--- Create (and return) a new ItemUseButton widget
-- @param self Reference to the caller
-- @param[opt] name Name of the contained FrameObject; defaults to TotalAPItemUseButtonN (where N is the number of instances) if omitted
-- @param[opt] parent Name of the parent frame; defaults to "UIParent" if omitted
-- @return ItemUseButtonObject representing the frame's container
local function CreateNew(self, name, parent)

	local ItemUseButtonObject = {
		FrameObject = {} -- holds the actual WOW Frame object (userdata) that is unique to each instance of this class
	}
	
	setmetatable(ItemUseButtonObject, self)  -- Set newly created object to inherit from ItemUseButton (template, as defined here)
	self.__index = function(table, key) 

--		TotalAP.Debug("CreateNew -> Meta lookup of key: " .. key .. " in ItemUseButton")
		if self[key] ~= nil then -- Key exists in ItemUseButton class (or DisplayFrame) -> Use it (no need to look anything up, really)
		
			return self[key]  -- DisplayFrame is the actual superclass, but the Frame API calls should be used on a FrameObject instead
			
		else -- Key will have to be looked up in the WOW Frame object
		
			TotalAP.Debug("Key " .. tostring(key) .. " not found in ItemUseButton or DisplayFrame, checking for FrameObject now")
			
			if table.FrameObject and table.FrameObject[key] then -- This ItemUseButton has a valid FrameObject being stored -> Use it
			
--				TotalAP.Debug("CreateNew -> " .. key .. " will be looked up in FrameObject")
				return table.FrameObject[key]
				
			end
			
		end

	end
	
	-- Create actual WOW Frame (will be invisible, as backdrop etc. will only be applied when rendering, which happens later)
	name = addonName .. (name or (self:GetName() or "ItemUseButton" .. self:GetNumInstances()))  -- e.g., "TotalAPItemUseButton1" if no other name was provided
	parent = (parent and (addonName .. parent)) or parent or "UIParent"
--	TotalAP.Debug("CreateNew -> Creating frame with name = " .. name .. ", parent = " .. parent) 
	
	-- TODO: Ugly workaround to not break legacy keybinds (which are assigned to TotalAPButton, which didn't really exist after r25 and the GUI rework - needs a better solution?)
	name = "TotalAPButton"
	
	ItemUseButtonObject:SetName(name)
	ItemUseButtonObject:SetParent(parent)
	ItemUseButtonObject.FrameObject = CreateFrame("Button", name, _G[parent] or UIParent, "ActionButtonTemplate, SecureActionButtonTemplate") 
	ItemUseButtonObject.FrameObject:SetFrameStrata("MEDIUM") 
		
	self.numInstances =  self:GetNumInstances() + 1 -- As this new frame is added to the pool, future frames should not use its number to avoid potential name clashes (even though there is no guarantee this ID is actually used, wasting some makes little difference)

	-- Register button with Masque
	TotalAP.Utils.MasqueRegister(ItemUseButtonObject.FrameObject, "ItemUseButton")
	
	return ItemUseButtonObject
	
end


-- Public methods (interface table -> accessible by the View and GUI Controller)
ItemUseButton.CreateNew = CreateNew
ItemUseButton.GetIcon = GetIcon
ItemUseButton.SetIcon = SetIcon
ItemUseButton.GetFlashing = GetFlashing
ItemUseButton.SetFlashing = SetFlashing
ItemUseButton.GetBorder = GetBorder
ItemUseButton.SetBorder = SetBorder
ItemUseButton.ToggleFlashing = ToggleFlashing
ItemUseButton.Render = Render

-- Make class available in the addon namespace
TotalAP.GUI.ItemUseButton = ItemUseButton

return ItemUseButton
