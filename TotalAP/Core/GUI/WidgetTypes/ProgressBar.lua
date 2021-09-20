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
local ProgressBar = {}

--- Default values that are applied to newly created frames automatically
local defaultValues = {

	-- General settings (applied to all bars)
	texture = "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar.blp",
	width = 100,
	height = 16,

	-- Empty bar (background)
	colour = "#FAFAFA",
	alpha = 0.2,
	
	-- UnspentBar (AP applied to artifact but not used)
	UnspentBar = {
	
		enabled = true,
		width = 0,
		alpha = 1,
		colour = "#3296FA",
		
	},
	
	-- InBagsBar (AP in the player's inventory)
	InBagsBar = {
	
		enabled = true,
		width = 0,
		alpha = 1,
		colour = "#325F96",
	
	},
	
	-- InBankBar (AP in the player's bank)
	InBankBar = {
		
		enabled = true,
		width = 0,
		alpha = 1,
		colour = "#325F5F",
		
	},
	
	-- MiniBar (small "carry" display)
	MiniBar = {
	
		enabled = true,
		width = 0,
		height = 2,
		alpha = 1,
		colour = "#EFE5B0",
	
	}
	
}


-- ProgressBar inherits from DisplayFrame
setmetatable(ProgressBar, TotalAP.GUI.DisplayFrame) 

--- Returns the value for a given bar and key (for internal use only)
-- @param self Reference to the caller
-- @param key Key that is to be looked up
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function GetValue(self, key, bar)
	
	--TotalAP.Debug("GetValue with key = " .. tostring(key) .. " and bar = " .. tostring(bar))
	local value = nil
	
	if bar then -- Return width for this bar
		
		if self[bar] then
			if self[bar][key] ~= nil then
				value= self[bar][key]
			else
				 value = defaultValues[bar][key]
			end
		else
			value = defaultValues[bar][key]
		end
		
	end
	
	value = value or rawget(self, key) or defaultValues[key]
	
	--TotalAP.Debug("Result: " .. tostring(value))
	return value

end

--- Sets the value for a given bar and key (for internal use only)
-- @param self Reference to the caller
-- @param key Key that is to be looked up
-- @param value Value this key is to be set to
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function SetValue(self, key, value, bar)

	if bar and self[bar] then -- Set width for this bar
		self[bar][key] = value
		return
	end

	rawset(self, key, value or self[key])

end

--- Retrieves currently used bar texture
-- @param self Reference to the caller
-- @return Currently used texture for all bars
local function GetTexture(self)

	return rawget(self, "texture") or defaultValues.texture

end

--- Sets bar texture
-- @param self Reference to the caller
-- @param newTexture Texture that will be applied
local function SetTexture(self, texture)

	self.texture = texture or self.texture

end

--- Retrieves currently used width for a given bar
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
-- @return Currently used width for the given bar
local function GetWidth(self, bar)
	
	return GetValue(self, "width", bar)
	
end

--- Sets width used for a given bar
-- @param self Reference to the caller
-- @param width The width of the bar
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function SetWidth(self, width, bar)

	SetValue(self, "width", width, bar)
	
end

---
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function GetHeight(self, bar)

	return GetValue(self, "height", bar)

end

---
-- @param self Reference to the caller

-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function SetHeight(self, height, bar)

	SetValue(self, "height", height, bar)

end

---
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function GetColour(self, bar)

	return GetValue(self, "colour", bar)

end

---
-- @param self Reference to the caller

-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function SetColour(self, bar, colour)

	SetValue(self, "colour", colour, bar)

end

---
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function GetAlpha(self, bar)

	return GetValue(self, "alpha", bar)
	
end

---
-- @param self Reference to the caller

-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function SetAlpha(self, alpha, bar)

	SetValue(self, "alpha", alpha, bar)
	
end

---
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function IsBarEnabled(self, bar)

	return GetValue(self, "enabled", bar)

end

---
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function EnableBar(self, bar)

	SetValue(self, "enabled", true, bar)

end

---
-- @param self Reference to the caller
-- @param[opt] bar Name of the bar (defaults to the empty bar if omitted)
local function DisableBar(self, bar)

	SetValue(self, "enabled", false, bar)

end

--- TODO: More aliases?s


--- Applies all the contained information to the underlying FrameObject to display them ingame
-- @param self Reference to the caller
local function Render(self)
	
	local FrameObject = self:GetFrameObject()
	
	-- Make sure Frame is created properly (and ProgressBar was instantiated at some point)
	if not FrameObject then
		TotalAP.Debug("FrameObject not found (called Render() before CreateNew()?) -> aborting...")
		return
	end
	
	local isEnabled = self:GetEnabled()
	if isEnabled then -- Display Frame and apply changes where necessary
	
		-- Shorthands
		local UnspentBar = self.UnspentBar
		local InBagsBar = self.InBagsBar
		local InBankBar = self.InBankBar
		local MiniBar = self.MiniBar
	
		-- Set texture
		FrameObject.texture:SetTexture(self:GetTexture())
		FrameObject.texture:SetAllPoints(FrameObject)
		local r, g, b = TotalAP.Utils.HexToRGB(self:GetColour())
		FrameObject.texture:SetVertexColor(r / 255, g / 255, b / 255, self:GetAlpha())
		
		UnspentBar.texture:SetTexture(self:GetTexture())
		UnspentBar.texture:SetAllPoints(UnspentBar)
		r, g, b = TotalAP.Utils.HexToRGB(self:GetColour("UnspentBar"))
		UnspentBar.texture:SetVertexColor(r / 255, g / 255, b / 255, self:GetAlpha("UnspentBar"))
		
		InBagsBar.texture:SetTexture(self:GetTexture())
		InBagsBar.texture:SetAllPoints(InBagsBar)
		r, g, b = TotalAP.Utils.HexToRGB(self:GetColour("InBagsBar"))
		InBagsBar.texture:SetVertexColor(r / 255, g / 255, b / 255, self:GetAlpha("InBagsBar"))
		
		InBankBar.texture:SetTexture(self:GetTexture())
		InBankBar.texture:SetAllPoints(InBankBar)
		r, g, b = TotalAP.Utils.HexToRGB(self:GetColour("InBankBar"))
		InBankBar.texture:SetVertexColor(r / 255, g / 255, b / 255, self:GetAlpha("InBankBar"))
		
		MiniBar.texture:SetTexture(self:GetTexture())
		MiniBar.texture:SetAllPoints(MiniBar)
		r, g, b = TotalAP.Utils.HexToRGB(self:GetColour("MiniBar"))
		MiniBar.texture:SetVertexColor(r / 255, g / 255, b / 255, self:GetAlpha("MiniBar"))
		
		-- Reposition 
		FrameObject:ClearAllPoints()
		UnspentBar:ClearAllPoints()
		InBagsBar:ClearAllPoints()
		InBagsBar:ClearAllPoints()
		MiniBar:ClearAllPoints()
		
		local posX, posY = unpack(self:GetRelativePosition())
		FrameObject:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY)
		UnspentBar:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY) 
		InBagsBar:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY) 
		InBankBar:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY) 
		MiniBar:SetPoint("TOPLEFT", self:GetParent(), "TOPLEFT", posX, posY - self:GetHeight() - self:GetHeight("MiniBar") + 2)

		-- Resize
		FrameObject:SetSize(self:GetWidth(), self:GetHeight())
		UnspentBar:SetSize(self:GetWidth("UnspentBar"), self:GetHeight("UnspentBar"))
		InBagsBar:SetSize(self:GetWidth("InBagsBar"), self:GetHeight("InBagsBar"))
		InBankBar:SetSize(self:GetWidth("InBankBar"), self:GetHeight("InBankBar"))
		MiniBar:SetSize(self:GetWidth("MiniBar"), self:GetHeight("MiniBar"))
		
		-- Hide bars if they are disabled
		if not self:IsBarEnabled("UnspentBar") then
				UnspentBar.texture:SetVertexColor(0, 0, 0, 0)
		end
		
		if not self:IsBarEnabled("InBagsBar") then
				InBagsBar.texture:SetVertexColor(0, 0, 0, 0)
		end
		
		if not self:IsBarEnabled("InBankBar") then
				InBankBar.texture:SetVertexColor(0, 0, 0, 0)
		end
		
		if not self:IsBarEnabled("MiniBar") then
				MiniBar.texture:SetVertexColor(0, 0, 0, 0)
		end
		
	end

	-- Toggle visibility
	FrameObject:SetShown(isEnabled)

end


--- Create (and return) a new ProgressBar widget
-- @param self Reference to the caller
-- @param[opt] name Name of the contained FrameObject; defaults to TotalAPProgressBarN (where N is the number of instances) if omitted
-- @param[opt] parent Name of the parent frame; defaults to "UIParent" if omitted
-- @return ProgressBarObject representing the frame's container
local function CreateNew(self, name, parent)

	local ProgressBarObject = {
		FrameObject = {}, -- holds the actual WOW Frame object (userdata) that is unique to each instance of this class
		-- child frames (needn't be accessed directly from the outside)
		UnspentBar = {},
		InBagsBar = {},
		InBankBar = {},
		MiniBar = {},
	}
	
	setmetatable(ProgressBarObject, self)  -- Set newly created object to inherit from ProgressBar (template, as defined here)
	self.__index = function(table, key) 

--		TotalAP.Debug("CreateNew -> Meta lookup of key: " .. key .. " in ProgressBar")
		if self[key] ~= nil then -- Key exists in ProgressBar class (or DisplayFrame) -> Use it (no need to look anything up, really)
		
			return self[key]  -- DisplayFrame is the actual superclass, but the Frame API calls should be used on a FrameObject instead
			
		end

	end
	
	-- Create actual WOW Frame (will be invisible, as backdrop etc. will only be applied when rendering, which happens later)
	name = addonName .. (name or (self:GetName() or "ProgressBar" .. self:GetNumInstances()))  -- e.g., "TotalAPProgressBar1" if no other name was provided
	parent = (parent and (addonName .. parent)) or parent or "UIParent"
--	TotalAP.Debug("CreateNew -> Creating frame with name = " .. name .. ", parent = " .. parent) 
	ProgressBarObject:SetName(name)
	ProgressBarObject:SetParent(parent)
	ProgressBarObject.FrameObject = CreateFrame("Frame", name, _G[parent] or UIParent) 
	ProgressBarObject.FrameObject:SetFrameStrata("LOW") 
	
	-- Create frames for the contained bars
	ProgressBarObject.UnspentBar = CreateFrame("Frame", name .. "UnspentBar", ProgressBarObject.FrameObject) 
	ProgressBarObject.InBagsBar = CreateFrame("Frame", name .. "InBagsBar", ProgressBarObject.FrameObject) 
	ProgressBarObject.InBankBar = CreateFrame("Frame", name .. "InBankBar", ProgressBarObject.FrameObject) 
	ProgressBarObject.MiniBar = CreateFrame("Frame", name .. "MiniBar", ProgressBarObject.FrameObject) 
	
	ProgressBarObject.UnspentBar:SetFrameStrata("LOW") 
	ProgressBarObject.InBagsBar:SetFrameStrata("LOW") 
	ProgressBarObject.InBankBar:SetFrameStrata("LOW") 
	ProgressBarObject.MiniBar:SetFrameStrata("MEDIUM") 
	
	-- Create empty texture objects
	ProgressBarObject.FrameObject.texture = ProgressBarObject.FrameObject:CreateTexture()
	ProgressBarObject.UnspentBar.texture = ProgressBarObject.UnspentBar:CreateTexture()
	ProgressBarObject.InBagsBar.texture = ProgressBarObject.InBagsBar:CreateTexture()
	ProgressBarObject.InBankBar.texture = ProgressBarObject.InBankBar:CreateTexture()
	ProgressBarObject.MiniBar.texture = ProgressBarObject.MiniBar:CreateTexture()
	
	self.numInstances =  self:GetNumInstances() + 1 -- As this new frame is added to the pool, future frames should not use its number to avoid potential name clashes (even though there is no guarantee this ID is actually used, wasting some makes little difference)

	return ProgressBarObject
	
end


-- Public methods (interface table -> accessible by the View and GUI Controller)
ProgressBar.CreateNew = CreateNew
ProgressBar.GetTexture = GetTexture
ProgressBar.SetTexture = SetTexture
ProgressBar.GetWidth = GetWidth
ProgressBar.SetWidth = SetWidth
ProgressBar.GetHeight = GetHeight
ProgressBar.SetHeight = SetHeight
ProgressBar.GetAlpha = GetAlpha
ProgressBar.SetAlpha = SetAlpha
ProgressBar.GetColour = GetColour
ProgressBar.SetColour = SetColour
ProgressBar.IsBarEnabled = IsBarEnabled
ProgressBar.EnableBar = EnableBar
ProgressBar.DisableBar = DisableBar
ProgressBar.Render = Render

-- Make class available in the addon namespace
TotalAP.GUI.ProgressBar = ProgressBar

return ProgressBar
