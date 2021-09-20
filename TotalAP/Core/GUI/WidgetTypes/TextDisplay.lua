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

local round = function(num) 
        if num >= 0 then return math.floor(num+.5) 
        else return math.ceil(num-.5) end
    end

-- Private variables
local TextDisplay = {}

--- Default values that are applied to newly created frames automatically
local defaultValues = {

	text = "",
	textAlignment = "left",
	verticalAlignment = "bottom",
	template = "GameFontNormal",

}


-- TextDisplay inherits from DisplayFrame
setmetatable(TextDisplay, TotalAP.GUI.DisplayFrame) 


--- Retrieves the currently used template (font object to inherit from)
-- @self A reference to the caller
-- @returns The currently used template
local function GetTemplate(self)

	return self.template or defaultValues.template

end

--- Sets the template (font object to inherit from)
-- @self A reference to the caller
-- @param template The template the contained FontString object inherited from
local function SetTemplate(self, template)

	self.template = template or self.template

end

--- Retrieves the currently displayed text 
-- @self A reference to the caller
-- @return The text that is displayed after rendering
local function GetText(self)

	return self.text or defaultValues.text

end

--- Sets the text that will be displayed upon next rendering the contained FrameObject
-- @self A reference to the caller
-- @param text The text that is to be displayed
local function SetText(self, text)

	self.text = text or self.text

end

--- Retrieves the current text alignment (HTML style)
-- @self A reference to the caller
-- @return The text alignment that the text will have after rendering
local function GetTextAlignment(self)

	return self.textAlignment or defaultValues.textAlignment

end

--- Sets the text that will be displayed upon next rendering the contained FrameObject
-- @self A reference to the caller
-- @param text The text that is to be displayed
local function SetTextAlignment(self, textAlignment)

	self.textAlignment = textAlignment or self.textAlignment

end

--- Retrieves the current text alignment (HTML style)
-- @self A reference to the caller
-- @return The text alignment that the text will have after rendering
local function GetVerticalAlignment(self)

	return self.verticalAlignment or defaultValues.verticalAlignment

end

--- Sets the text that will be displayed upon next rendering the contained FrameObject
-- @self A reference to the caller
-- @param text The text that is to be displayed
local function SetVerticalAlignment(self, textAlignment)

	self.verticalAlignment = textAlignment or self.verticalAlignment

end


--- Applies all the contained information to the underlying FrameObject to display them ingame
-- @param self Reference to the caller
local function Render(self)
	
	local FrameObject = self:GetFrameObject()
	
	-- Make sure Frame is created properly (and TextDisplay was instantiated at some point)
	if not FrameObject then
		TotalAP.Debug("FrameObject not found (called Render() before CreateNew()?) -> aborting...")
		return
	end
	
	local isEnabled = self:GetEnabled()
	if isEnabled then -- Display Frame and apply changes where necessary

		FrameObject:SetText(self:GetText())
	
		-- Reposition and align -  This alignment is relative to the parent frame and depends on the FontString's width/text length
		FrameObject:ClearAllPoints()
		
		local posX, posY = unpack(self:GetRelativePosition())
		local xOffset, yOffset = 0, 0
		local alignment = self:GetTextAlignment()
		local verticalAlignment = self:GetVerticalAlignment()
		
		if alignment == "center" then -- position to the center of the parentFrame
			
			xOffset = (FrameObject:GetParent():GetWidth() - FrameObject:GetWidth()) / 2
			
		elseif alignment == "right" then -- position to the right of the parentFrame
		
			xOffset = (FrameObject:GetParent():GetWidth() - FrameObject:GetWidth())
			
		end
		
		
		FrameObject:SetJustifyV("TOP") -- This is the default behaviour of a FontString unless specified otherwise
		-- -- yOffset = FrameObject:GetParent():GetHeight() - FrameObject:GetHeight()
		-- if verticalAlignment == "center" then -- position to the center of the parentFrame
			-- -- yOffset = (FrameObject:GetParent():GetHeight() - FrameObject:GetHeight()) / 2
			-- FrameObject:SetJustifyV("CENTER")
		-- elseif verticalAlignment == "top" then -- position to the top of the parentFrame
			-- --yOffset = 0
			-- FrameObject:SetJustifyV("TOP")
		-- end
	
		FrameObject:SetPoint(self:GetAnchorPoint(), self:GetParent(), self:GetTargetAnchorPoint(), round(posX + xOffset), round(posY + 1)) -- TODO: Seems still glitched, if the 1px offset is removed OR the justifyH isn't top this doesn't work...
		
		
		-- Recreate if text or template changed (TODO)
	
	end

		-- Toggle visibility
	FrameObject:SetShown(isEnabled)

	
end

--- Create (and return) a new TextDisplay widget
-- @param self Reference to the caller
-- @param[opt] name Name of the contained FrameObject; defaults to TotalAPTextDisplayN (where N is the number of instances) if omitted
-- @param[opt] parent Name of the parent frame; defaults to "UIParent" if omitted
-- @return TextDisplayObject representing the frame's container
local function CreateNew(self, name, parent, template)

	local TextDisplayObject = {
		FrameObject = {}, -- holds the actual WOW Frame object (userdata) that is unique to each instance of this class
	}
	
	setmetatable(TextDisplayObject, self)  -- Set newly created object to inherit from TextDisplay (template, as defined here)
	self.__index = function(table, key) 

--		TotalAP.Debug("CreateNew -> Meta lookup of key: " .. key .. " in TextDisplay")
		if self[key] ~= nil then -- Key exists in TextDisplay class (or DisplayFrame) -> Use it (no need to look anything up, really)
		
			return self[key]  -- DisplayFrame is the actual superclass, but the Frame API calls should be used on a FrameObject instead
			
		end

	end
	
	-- Create actual WOW Frame (will be invisible, as backdrop etc. will only be applied when rendering, which happens later)
	name = addonName .. (name or (self:GetName() or "TextDisplay" .. self:GetNumInstances()))  -- e.g., "TotalAPTextDisplay1" if no other name was provided
	parent = (parent and (addonName .. parent)) or parent or "UIParent"
--	TotalAP.Debug("CreateNew -> Creating frame with name = " .. name .. ", parent = " .. parent) 
	TextDisplayObject:SetName(name)
	TextDisplayObject:SetParent(parent)
	local ParentFrame = _G[parent] or UIParent
	
	if template then -- Set template if one was given
		self:SetTemplate(template)
	end
	
	TextDisplayObject.FrameObject = ParentFrame:CreateFontString(name, "OVERLAY", self:GetTemplate()) -- TODO: If template changes, this needs to be recreated 

	
	self.numInstances =  self:GetNumInstances() + 1 -- As this new frame is added to the pool, future frames should not use its number to avoid potential name clashes (even though there is no guarantee this ID is actually used, wasting some makes little difference)

	return TextDisplayObject
	
end


-- Public methods (interface table -> accessible by the View and GUI Controller)
TextDisplay.CreateNew = CreateNew
TextDisplay.GetTemplate = GetTemplate
TextDisplay.SetTemplate = SetTemplate
TextDisplay.GetText = GetText
TextDisplay.SetText = SetText
TextDisplay.GetTextAlignment = GetTextAlignment
TextDisplay.SetTextAlignment = SetTextAlignment
TextDisplay.GetVerticalAlignment = GetVerticalAlignment
TextDisplay.SetVerticalAlignment = SetVerticalAlignment
TextDisplay.Render = Render

-- Make class available in the addon namespace
TotalAP.GUI.TextDisplay = TextDisplay

return TextDisplay
