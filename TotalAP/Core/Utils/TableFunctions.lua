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

--- TableFunctions.lua.
-- Utilities for dealing with tables
-- @section TableFunctions


local addonName, T = ...
if not T then return end


--- Dynamic name lookup (read) - from the Lua manual - Used as a helper function, but only rarely because it is extremely slow
-- @param f The dynamic field name (string) that should be looked up
-- @param[opt] t The table that the field should be set in (defaults to _G)
-- @usage getfield("some.field", defaultSettings) -> value of defaultSettings["some"]["field"]
-- @usage getfield("some.field") -> value of _G["some"]["field"]
local function FieldLookup (f, t)
	
	local v = t or _G    -- start with the table of globals
 
		for w in string.gmatch(f, "[%w_]+") do
			v = v[w]
		end
      
	return v
 
 end
 
 
T.Utils.FieldLookup = FieldLookup

return FieldLookup
