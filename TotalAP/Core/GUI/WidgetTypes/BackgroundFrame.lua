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


-- Localized globals
local _G = _G -- Required to get parent frame references from their names


-- Private variables
local BackgroundFrame = {}

--- Default values that are applied to newly created frames automatically
local defaultValues = {

	backdropColour = "#C0C0C0", -- Saved as HEX code (different format from the API, and also it doesn't provide a Get() method for this)
	backdropAlpha = 1,
	backdropFile = "Interface\\CHATFRAME\\CHATFRAMEBACKGROUND.BLP",

--	TODO: Edges not supported yet, ditto for tiling (because I couldn't be bothered right now. All Views use simple backgrounds for the time being) -> Create Get/Set methods and voilá
	edgeFile = "", -- Interface/Tooltips/UI-Tooltip-Border
	edgeSize = 0,
	isTiled = false, -- Stretched otherwise
	tileSize = 0,
	insets = { 0, 0, 0, 0 },

}


-- BackgroundFrame inherits from DisplayFrame
setmetatable(BackgroundFrame, TotalAP.GUI.DisplayFrame) 



--- Retrieves currently used backdrop colour as HTML-style hex code
-- @param self Reference to the caller
-- @return The colour used as the FrameObject's backdrop if it has been rendered; the one that will be applied to it otherwise
local function GetBackdropColour(self)

	return self.backdropColour or defaultValues.backdropColour
	
end

--- Sets backdrop colour that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param hexString HTML-style colour code that represents the background colour
local function SetBackdropColour(self, hexString)

	self.backdropColour = hexString or self.backdropColour
	
end

--- Retrieves currently used backdrop alpha value (opacity)
-- @param self Reference to the caller
-- @return Alpha value as a percentage, i.e., between 0 and 1
local function GetBackdropAlpha(self)

	return self.backdropAlpha or defaultValues.backdropAlpha
	
end

--- Sets backdrop alpha value (opacity) that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param newAlphaValue New alpha value as a percentage, i.e., between 0 and 1
local function SetBackdropAlpha(self, newAlphaValue)

	self.backdropAlpha = newAlphaValue or self.backdropAlpha
	
end

--- Retrieves currently used backdrop file (path)
-- @param self Reference to the caller
-- @return Backdrop file path (as a relative path in the WOW client) 
local function GetBackdropFile(self)

	return self.backdropFile or defaultValues.backdropFile
	
end

--- Sets the backdrop file that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param newFile New backdrop file path (as a relative path in the WOW client)
local function SetBackdropFile(self, newFile)

	self.backdropFile = newFile or self.backdropFile
	
end


--- Retrieves currently used edge file (path)
-- @param self Reference to the caller
-- @return Edge file path (as a relative path in the WOW client)
local function GetEdgeFile(self)

	return self.edgeFile or defaultValues.edgeFile
	
end

--- Sets the edge file that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param newFile New edge file path (as a relative path in the WOW client)
local function SetEdgeFile(self, newFile)

	self.edgeFile = newFile or self.edgeFile
	
end

--- Retrieves currently used size of the edge
-- @param self Reference to the caller
-- @return Size of the Frame's edge (in pixels)
local function GetEdgeSize(self)
	
	return self.edgeSize or defaultValues.edgeSize
	
end

--- Sets the edge size that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param newSize New size of the edge (in pixels)
local function SetEdgeSize(self, newSize)

	self.edgeSize = newSize or self.edgeSize

end

-- Returns whether or not the background image is tiled
-- @param self Reference to the caller
-- @returns Whether or not the backdrop image is set to be displayed as tiles
local function GetTiled(self)

	return self.isTiled or defaultValues.isTiled

end

--- Alias for GetTiled()
local function IsTiled(self)

	return GetTiled(self)

end

--- Sets whether or not tiling should be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param tiledFlag Whether or not the backdrop image should be tiled
local function SetTiled(self, tiledFlag)

	self.isTiled = tiledFlag or self.isTiled

end

--- Retrieves the current size of each tile (only applies if tiling is enabled)
-- @param self Reference to the caller
-- @return Size of each tile (in pixels)
local function GetTileSize(self)

	return self.tileSize or defaultValues.tileSize

end

--- Sets how large each tile should be (if tiling is enabled) upon applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param newSize New size of each tile (in pixels)
local function SetTileSize(self, newSize)

	self.tileSize = newSize or self.tileSize

end

--- Returns array containing the currently used insets
-- @param self Reference to the caller
-- @return An array containing the insets
local function GetInsets(self)

	return self.insets or defaultValues.insets

end

--- Sets the insets that will be applied upon rendering the contained FrameObject
-- @param self Reference to the caller
-- @param insetsArray An array of insets. Must contain valid insets, such as 1, 2, or 4 integer values (for "universal", "horizontal/vertical", and "individual" edge sizes, respectively)
local function SetInsets(self, insetsArray)

	self.insets = insetsArray or self.insets

end

--- Applies all the contained information to the underlying FrameObject to display them ingame
-- @param self Reference to the caller
local function Render(self)
	
	local FrameObject = self:GetFrameObject()
	
	-- Make sure Frame is created properly (and BackgroundFrame was instantiated at some point)
	if not FrameObject then
		TotalAP.Debug("FrameObject not found (called Render() before CreateNew()?) -> aborting...")
		return
	end
	
	local isEnabled = self:GetEnabled()
	if isEnabled then -- Display Frame and apply changes where necessary
	
		-- Set backdrop
		FrameObject:SetBackdrop( { bgFile = self:GetBackdropFile(),  edgeFile = self:GetEdgeFile(),  tile = self:IsTiled(), tileSize = self:GetTileSize(), edgeSize = self:GetEdgeSize(), insets = self:GetInsets() } )
		local r, g, b = TotalAP.Utils.HexToRGB(self:GetBackdropColour())
		FrameObject:SetBackdropColor(r/255, g/255, b/255, self:GetBackdropAlpha())
		
		-- Reposition 
		if self:GetParent() ~= "UIParent" then -- Position relatively to its parent and the given settings to have it align automatically
		
			FrameObject:ClearAllPoints()
			local posX, posY = unpack(self:GetRelativePosition())

			FrameObject:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY)
			
		else -- Is top level frame and mustn't be reset, as its position is stored in WOW's Layout Cache
			
			local numPoints = FrameObject:GetNumPoints()
			if numPoints == 0 then -- Frame isn't anchored anywhere and therefore invisible (can happen after errors occur somehow?)
				FrameObject:SetPoint("CENTER", UIParent, "CENTER")
			end
			
		end
		
	end
	
	-- Toggle visibility
	FrameObject:SetShown(isEnabled)

end


--- Create (and return) a new BackgroundFrame widget
-- @param self Reference to the caller
-- @param[opt] name Name of the contained FrameObject; defaults to TotalAPBackgroundFrameN (where N is the number of instances) if omitted
-- @param[opt] parent Name of the parent frame; defaults to "UIParent" if omitted
-- @return BackgroundFrameObject representing the frame's container
local function CreateNew(self, name, parent)

	local BackgroundFrameObject = {
		FrameObject = {} -- holds the actual WOW Frame object (userdata) that is unique to each instance of this class
	}
	
	setmetatable(BackgroundFrameObject, self)  -- Set newly created object to inherit from BackgroundFrame (template, as defined here)
	self.__index = function(table, key) 

--		TotalAP.Debug("CreateNew -> Meta lookup of key: " .. key .. " in BackgroundFrame")
		if self[key] ~= nil then -- Key exists in BackgroundFrame class (or DisplayFrame) -> Use it (no need to look anything up, really)
		
			return self[key]  -- DisplayFrame is the actual superclass, but the Frame API calls should be used on a FrameObject instead
			
		end

	end
	
	-- Create actual WOW Frame (will be invisible, as backdrop etc. will only be applied when rendering, which happens later)
	name = addonName .. (name or (self:GetName() or "BackgroundFrame" .. self:GetNumInstances()))  -- e.g., "TotalAPBackgroundFrame1" if no other name was provided
	parent = (parent and (addonName .. parent)) or parent or "UIParent"
--	TotalAP.Debug("CreateNew -> Creating frame with name = " .. name .. ", parent = " .. parent) 
	
	BackgroundFrameObject:SetName(name)
	BackgroundFrameObject:SetParent(parent)
	BackgroundFrameObject.FrameObject = CreateFrame("Frame", name, _G[parent] or UIParent) 
	BackgroundFrameObject.FrameObject:SetFrameStrata("BACKGROUND") 
		
	self.numInstances =  self:GetNumInstances() + 1 -- As this new frame is added to the pool, future frames should not use its number to avoid potential name clashes (even though there is no guarantee this ID is actually used, wasting some makes little difference)

	return BackgroundFrameObject
	
end


-- Public methods (interface table -> accessible by the View and GUI Controller)
BackgroundFrame.CreateNew = CreateNew
BackgroundFrame.GetBackdropColour = GetBackdropColour
BackgroundFrame.SetBackdropColour = SetBackdropColour
BackgroundFrame.GetBackdropAlpha = GetBackdropAlpha
BackgroundFrame.SetBackdropAlpha = SetBackdropAlpha
BackgroundFrame.GetBackdropFile = GetBackdropFile
BackgroundFrame.SetBackdropFile = SetBackdropFile
BackgroundFrame.GetEdgeFile = GetEdgeFile
BackgroundFrame.SetEdgeFile = SetEdgeFile
BackgroundFrame.GetEdgeSize = GetEdgeSize
BackgroundFrame.SetEdgeSize = SetEdgeSize
BackgroundFrame.GetTiled = GetTiled
BackgroundFrame.SetTiled = SetTiled
BackgroundFrame.IsTiled = IsTiled
BackgroundFrame.GetTileSize = GetTileSize
BackgroundFrame.SetTileSize = SetTileSize
BackgroundFrame.GetInsets = GetInsets
BackgroundFrame.SetInsets = SetInsets
BackgroundFrame.Render = Render

-- Make class available in the addon namespace
TotalAP.GUI.BackgroundFrame = BackgroundFrame

return BackgroundFrame
