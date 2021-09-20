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

--- FQCN.lua.
-- Utilities for dealing with fully-qualified character names
-- @section FQCN

local addonName, TotalAP = ...

if not TotalAP then return end

--- Build a fully-qualified character name from the given character and realm names (uses the current character if none are given)
-- @param[opt] characterName The name of a character
-- @param[opt] realm The realm said character exists on
-- @return Fully-qualified character name that can directly be used as a unique lookup key for many tables
-- @usage GetFQCN("Duckwhale", "Outland") -> "Duckwhale - Outland"
-- @usage GetFQCN() -> "Duckwhale - Outland" (if this is the currently active character
-- @usage GetFQCN("Swimmingly") -> "Swimmingly - Outland" (if the currently active character is located on the realm "Outland")
-- @usage GetFQCN(nil, "Outland") -> "Swimmingly - Outland" (if "Swimmingly" is the name of the currently active character, regardless of the realm)
local function GetFQCN(characterName, realm)
	
	characterName = (type(characterName) == "string" and characterName) or UnitName("player")
	realm = (type(realm) == "string" and realm) or GetRealmName()
	local key = format("%s - %s", characterName, realm)	 

	return key
	
end


-- Public methods
TotalAP.Utils.GetFQCN = GetFQCN


return TotalAP.Utils.GetFQCN
