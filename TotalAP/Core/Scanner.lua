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
-- @module Core

--- Scanner.lua.
-- Handles scanning of spell descriptions for artifact power tokens
-- @section Scanner


local addonName, TotalAP = ...


--- Looks up string-characters to find their regexp pattern string (purely for ease of use and readability)
-- @param c The character that the pattern should represent
-- @return The Lua-expression pattern that can be used to match this character
local function RegexEscapeChar(c)
	
	local esc = {
		["."] = "%.",
		[","] = ",",
		[" "] = "%s"
	}
	
	if not esc[c] then return c end -- Also works for "empty space" as used by zhCN/zhTW and koKR locales in leading/trailingSpace, respectively
	
	return esc[c]

end


--- Scans spell description and extracts AP amount based on locale (some use different formats to display numbers)
-- @param spellDescription The localized spell description text as returned by the WOW API
-- @param[opt] localeString The locale in the typical format (enUS, deDE, frFR, ...). Defaults to currently active locale if omitted
-- @return The number of artifact power that this spell will apply to the current artifact
local function ParseSpellDesc(spellDescription, localeString)
	
	-- 7.2 AP number format detection (should work for > 1 billion and all locales)
	
	-- Obtain locale-specific details such as separators and the words used to indicate the textual format (> 1 mil)
	local l = TotalAP.GetLocaleNumberFormat(localeString or GetLocale())
	local thousandsSeparator, decimalSeparator, unitsTable, leadingSpace, trailingSpace = l["thousandsSeparator"], l["decimalSeparator"], l["unitsTable"], l["leadingSpace"], l["trailingSpace"]

	-- Find integer values
	local m = spellDescription:match(RegexEscapeChar(leadingSpace) .. "(%d+" .. RegexEscapeChar(thousandsSeparator) .. "?%d+)" .. RegexEscapeChar(trailingSpace)) -- Used for numbers < 1 million and the numeric part of millions/billions: 100,000 (could also be 10 million, but that doesn't matter for this part)

	-- Find decimal values
	if not m then
	   m = spellDescription:match(RegexEscapeChar(leadingSpace) .. "(%d+".. RegexEscapeChar(decimalSeparator) .. "?%d*)" .. RegexEscapeChar(trailingSpace)) -- Used for > 1 million (since AP numbers are always integers, a decimal number indicates the abbreviated textual format: 1.5 million)
	end

	
	m = m:gsub(RegexEscapeChar(thousandsSeparator), "") -- Remove commas, points etc. so the numbers can be parsed (leave decimals though, as they're required for multiplication)
	m = m:gsub(RegexEscapeChar(decimalSeparator), ".") -- Only decimal points can be read by tonumber, apparently
	
	local n = tonumber(m) -- Making sure arithmetic can be done no matter which format was used

	-- For abbreviated / textual format: Multiply to get the true value
	if unitsTable then
		for i in ipairs(unitsTable) do -- Search for unit suffix
			for key in pairs(unitsTable[i]) do
				if spellDescription:match(key) then 
					n = n * unitsTable[i][key]
					return n
				end
			end
		end
	end

	return n
	
end				
				
				
if not TotalAP then return end
TotalAP.Scanner.ParseSpellDesc = ParseSpellDesc

return TotalAP.Scanner
