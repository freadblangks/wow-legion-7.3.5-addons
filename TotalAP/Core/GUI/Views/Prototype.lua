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

--- Contains various layouts for displaying the addon's data and providing interactive UI elements to access its functionality
-- @module Views

--- Prototype.lua.
-- An abstract parent class that allows each view to inherit general functionality and structure from it.
-- @section GUI

local addonName, TotalAP = ...
if not TotalAP then return end


-- Private variables (default values that will be inherited)
local name = "PrototypeView"
local elementsList = {} -- No elements in this view, for obvious reasons

local View = {}

--- Prototype constructor. This will be overwritten by derived classes and should not be called directly
local function CreateNew()

	-- Nothing because a) prototype and b) only preset views are supported yet, but not entirely custom ones (TODO) :P
	TotalAP.Debug("Attempted to instantiate Prototype View object -> Something's not quite right!")
	return
	
end

--- Returns the name of this view
-- @param self Reference to the ViewObject representing the View
-- @return name Name of the view
local function GetName(self)

	return self.name

end

--- Sets the name of this view
-- @param self Reference to the ViewObject representing the View
-- @param[opt] name Name that will be set for this ViewObject; Defaults to "" (empty String) if none is given
local function SetName(self, name)
	
	self.name = name or ""

end

--- Renders all the elements that are part of the view, according to their attribute. This displays the GUI if the view is active, but doesn't show anything otherwise
-- @param self Reference to the ViewObject representing the View
local function Render(self)

	local elementsList = self.elementsList
	
	if not elementsList or not (#elementsList > 0) then -- No elements that could be rendered
		TotalAP.ChatMsg("Failed to render View -> No elements exist for View = " .. self:GetName())
		return
	end
	
	-- Disable all elements that can't be shown due to event state restrictions (combat, pet battle, vehicle, loss of control)
	
	-- Render all enabled elements (show frames) 
	for index, Element in ipairs(elementsList) do
		if Element ~= nil then
		
			-- Skip frames that can't be shown due to being assigned to actual specs that don't exist for the current character's class - the maximum no. is always created, but not all of them need to be rendered
			if GetNumSpecializations() > 0 then -- Spec data is available (it's not during some loading screens...)
				if Element:GetAssignedSpec() > GetNumSpecializations() then -- Disable this icon, as the player's class has fewer specs
					Element:SetEnabled(false)
				else
					Element:SetEnabled(true)
				end
			end
		
			-- Don't update GUI while combat lockdown is active (to eradicate any taint errors)
			if InCombatLockdown() then -- No spreading of taint, please!
				TotalAP.Debug("Prevented GUI Updating due to anti-taint measures")
				return
			end
			
--			TotalAP.Debug("Rendering View element " .. index .. ": " .. Element:GetName())
			Element:Update() -- Prepare internal state to reflect the most current information available to the addon (handled by view)
			Element:Render() -- Display element according to its internal state (handled by widget class)
		end
	end
	
end

--- Get the number of elements that make up this view (Only enabled elements count)
-- @param self Reference to the ViewObject representing the View
local function GetNumElements(self)

	local n = 0
	
	-- Count elements that are part of this view
	for i in pairs(elementsList) do 
		if elementsList[i] ~= nil and elementsList[i]:IsEnabled() then -- This element exists, and is enabled
			n = n + 1
		end
	end

	return n

end


-- Public methods
View.CreateNew = CreateNew
View.GetName = GetName
View.SetName = SetName
View.Render = Render
View.GetNumElements = GetNumElements


TotalAP.GUI.View = View

return View
