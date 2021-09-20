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


---	Consists of various utilities that make working with things easier across all other modules
-- @module Utils

--- Masque.lua.
-- Utilities for interacting with the Masque styling library
-- @section Masque


local addonName, TotalAP = ...
if not TotalAP then return end


--- Registers an action button with Masque
-- @param button Reference to the button (frame)
-- @param subGroup Name of the Masque subgroup
local function MasqueRegister(button, subGroup) 

	 if not TotalAP.Masque then return end
	 
	 local group = TotalAP.Masque:Group(TotalAP.L["TotalAP - Artifact Power Tracker"], subGroup)
	 group:AddButton(button)
--	 TotalAP.Debug(format("Added button %s to Masque group %s.", button:GetName(), subGroup))
		 
end

--- Updates the style (by re-skinning) if using Masque, and keep button proportions so that it remains square
-- @param button Reference to the button (frame)
-- @param subGroup Name of the Masque subgroup
local function MasqueUpdate(button, subGroup)

	 if not TotalAP.Masque then -- Hide ugly border (which Masque usually overwrites)
	 
		button:SetNormalTexture(nil)
		-- TODO: These are only useful for specIcons?
		--button.Border:Hide()
		--button:SetPushedTexture(nil)
		return
		
	 end
 
	 local group = TotalAP.Masque:Group(TotalAP.L["TotalAP - Artifact Power Tracker"], subGroup)
	 group:ReSkin()
--	 TotalAP.Debug(format("Updated Masque skin for group: %s", subGroup))
	 
end


TotalAP.Utils.MasqueRegister = MasqueRegister
TotalAP.Utils.MasqueUpdate = MasqueUpdate


local R = {

	MasqueRegister = MasqueRegister,
	MasqueUpdate = MasqueUpdate,

}

return R
