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


local DisplayFrame = {}

--- Private state table, which is inacessible outside of this class
local defaultValues = {
	
	isEnabled = true,
	assignedSpec = 0, -- 0 -> Part of the display for all specs
--	FrameObject = {}, -- This should be overwritten by the instanced classes to replace it with an actual WOW Frame object
	numInstances = 0,
	Parent = "UIParent",
	name = "",
	position = { 0, 0 },
	anchorPoint = "CENTER",
	targetAnchorPoint = "CENTER",
	
}

-- Uninitialised values should be looked up in defaultValues
local mt = {}
setmetatable(DisplayFrame, mt)
mt.__index = function(table, key)
	
--	TotalAP.Debug("-- DisplayFrame -> Meta lookup for key = " .. key .. " in defaultValues")
	return defaultValues[key]
	
end

-- This lookup is used by objects of derived classes
DisplayFrame.__index = function(table, key)

	-- Don't look up FrameObjects, as they're unique to each instance and can't be shared
	if key == "FrameObject" then return end
	
--	TotalAP.Debug("Meta lookup of key " .. key .. " in DisplayFrame")
	
	if TotalAP.GUI.DisplayFrame[key] ~= nil then
	--	TotalAP.Debug("Key " .. key .. " was found in DisplayFrame, using it")
		return TotalAP.GUI.DisplayFrame[key]
	else
		--TotalAP.Debug("- Key " .. key .. " wasn't found in DisplayFrame")
		return 
	end
	
end


--- Retrieves the enabled status for this object
-- @param self Reference to the caller
-- @return Whether or not the contained FrameObject should be rendered as part of the View
local function GetEnabled(self)

	return self.isEnabled
	
end

--- Toggles the enabled status for this object
-- @param self Reference to the caller
-- @param enabledStatus Whether or not the contained FrameObject should be rendered as part of the View
local function SetEnabled(self, enabledStatus)

	self.isEnabled = enabledStatus
	
end

-- Alias for SetEnabled(true)
-- @param self Reference to the caller
local function Enable(self)

	self.isEnabled = true
	
end

--- Alias for SetEnabled(false)
-- @param self Reference to the caller
local function Disable(self)

	self.isEnabled = false
	
end

--- Returns the number of times an object of this class has been instantiated so far. This is NOT the active number of instances, and is only used to avoid naming conflicts when creating frames
-- @param self Reference to the caller
-- @return Number of total created objects derived from this base class
local function GetNumInstances(self)

	return self.numInstances
	
end

--- Returns the parent frame for currently displayed frames
-- @param self Reference to the caller
-- @returns A reference to the parent frame if the contained FrameObject has been rendered; The name of the one that will be applied to the FrameObject when it is being rendered otherwise
local function GetParent(self)

	if self.FrameObject.GetParent then return self.FrameObject:GetParent():GetName() end
	
	return self.Parent

end

--- Sets the parent that should be applied to the FrameObject when it is being rendered
-- @param self Reference to the caller
-- @param[opt] newParent Name (string) or reference (object) of the new parent frame
local function SetParent(self, newParent)

	self.Parent = newParent or UIParent -- Will not be applied to the FrameObject until it is actually rendered as part of the View
	
end

--- Sets the name that will also be used to identify the actual WOW Frame when it is being rendered
-- @param self Reference to the caller
-- @param newName The name that should be used to refer to the contained FrameObject going forward
local function SetName(self, newName)

	self.name = newName

end

--- Get the DisplayFrame's name (which is also the name of the actual WOW Frame, if it has been created)
-- @param self Reference to the caller
-- @return The name of the contained Frame object, which is also the Frame's variable name in the global namespace
local function GetName(self)
	
	if self.FrameObject.GetName then return self.FrameObject:GetName() end
	
	return self.name

end

--- Retrieves the currently assigned spec number
-- @param self Reference to the caller
-- @returns The number of the spec that is assigned to this container
local function GetAssignedSpec(self)

	return self.assignedSpec or defaultValues.assignedSpec

end

--- Assigns a spec number to this container
-- @param self Reference to the caller
-- @param assignedSpec The spec number (1-4) that this container will be assigned to
local function SetAssignedSpec(self, assignedSpec)

	self.assignedSpec = assignedSpec or self.assignedSpec

end

--- Prototype method. Must be overwritten by derived classes to be useful, as update requirements are different for each frame type
local function Update()

	TotalAP.Debug("Tried to update prototype DisplayFrame -> Something's not quite right...")
	return
	
end

--- Prototype method. Must be overwritten by derived classes to be useful, as rendering is different for each frame type
local function Render()

	TotalAP.Debug("Tried to render prototype DisplayFrame -> Something's not quite right...")
	return
	
end

-- Prototype constructor. Must be overwritten by derived classes to be useful, as instantiation is different for each frame type
local function CreateNew()

	TotalAP.Debug("Tried to create new instance of prototype DisplayFrame - Something's not quite right!")
	return
	
end

--- Returns the contained WOW Frame object
-- @param self Reference to the caller
-- @return A reference to the Frame object representing the WOW Frame
local function GetFrameObject(self)
	
	return self.FrameObject
	
end


--- Retrieves position of the contained FrameObject relative to its parent frame
-- @param self Reference to the caller
-- @return Position as array { posX, posY } - use unpack() if necessary
local function GetRelativePosition(self)
	
	return self.position or defaultValues.position
	
end

--- Sets position of the contained FrameObject relative to its parent frame
-- @param self Reference to the caller
-- @param[opt] posX X-Offset (defaults to 0)
-- @param[opt] posY X-Offset (defaults to 0)
local function SetRelativePosition(self, posX, posY)

	local pos = { posX or 0, posY or 0 }

	self.position = pos
	
end

---
local function GetAnchorPoint(self)

	return self.anchorPoint or defaultValues.anchorPoint

end

---
local function SetAnchorPoint(self, anchorPoint)

	self.anchorPoint = anchorPoint or self.anchorPoint

end

---
local function GetTargetAnchorPoint(self)

	return self.targetAnchorPoint or defaultValues.targetAnchorPoint

end

---
local function SetTargetAnchorPoint(self, targetAnchorPoint)

	self.targetAnchorPoint = targetAnchorPoint or self.targetAnchorPoint
	
end

-- Public methods (interface table)
DisplayFrame.CreateNew = CreateNew
DisplayFrame.GetEnabled = GetEnabled
DisplayFrame.SetEnabled = SetEnabled
DisplayFrame.Enable = Enable
DisplayFrame.Disable = Disable
DisplayFrame.Update = Update
DisplayFrame.Render = Render
DisplayFrame.GetNumInstances = GetNumInstances
DisplayFrame.GetParent = GetParent
DisplayFrame.SetParent = SetParent
DisplayFrame.SetName = SetName
DisplayFrame.GetName = GetName
DisplayFrame.GetAssignedSpec = GetAssignedSpec
DisplayFrame.SetAssignedSpec = SetAssignedSpec
DisplayFrame.GetFrameObject = GetFrameObject
DisplayFrame.GetRelativePosition = GetRelativePosition
DisplayFrame.SetRelativePosition = SetRelativePosition
DisplayFrame.GetAnchorPoint = GetAnchorPoint
DisplayFrame.SetAnchorPoint = SetAnchorPoint
DisplayFrame.GetTargetAnchorPoint = GetTargetAnchorPoint
DisplayFrame.SetTargetAnchorPoint = SetTargetAnchorPoint

TotalAP.GUI.DisplayFrame = DisplayFrame

return DisplayFrame
