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

--- Format.lua.
-- Utilities for number formatting and parsing
-- @section Format


local addonName, T = ...


 --- Format number as short textual representation
 -- Adheres to international standards for orders of magnitude ('k' for thousands, 'm' for millions, etc.)
 -- @param value The number (value) to be formatted
 -- @param[opt] format Whether or not the formatting should be applied directly. Will return the original value alongside a format string that can be used with string.format(...) otherwise
 -- @param[opt] locale Which localised format should be applied to the number, if any. Will use the legacy format (m = millions, b = billions, etc.) otherwise
 -- @return The formatted output if the 'format' parameter was given; a format string otherwise
 -- @return[opt] The number this formatted string can be applied to in order to obtain the same textual representation; nil if the 'format' parameter wasn't given
 -- @usage FormatShort(15365, true) -> "15.3k"
 -- @usage FormatShort(15365) -> { "%.1fk", 15.365 }
 -- @usage FormatShort(15365, true, "enUS") -> { "15.3K"} 
 local function FormatShort(value, format, locale) 
 
	if type(value) == "number" then
	
		local fmt, decimalSeparator, unitsPattern = "%d", ".", "[k|m|b]" -- The default format will be replaced by localised version below if locale parameter was given
		
		if not locale or locale == "legacy" then -- Use legacy format
			if value >= 1000000000 or value <= -1000000000 then
				fmt = "%.1fb"
				value = value / 1000000000
			elseif value >= 10000000 or value <= -10000000 then
				fmt = "%.1fm"
				value = value / 1000000
			elseif value >= 1000000 or value <= -1000000 then
				fmt = "%.2fm"
				value = value / 1000000
			elseif value >= 100000 or value <= -100000 then
				fmt = "%.0fk"
				value = value / 1000
			elseif value >= 10000 or value <= -10000 then
				fmt = "%.1fk"
				value = value / 1000
			else
				fmt = "%d"
				value = math.floor(value + 0.5)
			end
		else -- Use localised format (depends on locale parameter)
			
			value = math.floor(value + 0.5) -- round to nearest integer before formatting anything
			
			local formatTable = T.GetLocaleNumberFormat(locale)
			local unitsShort = formatTable["unitsShort"]

			for k, v in ipairs(unitsShort) do -- Apply format, starting with largest divisor (billions for English), then continue until no further divisons are possible
			
				local divisor, unitString, numDigits = v["divisor"], v["unitString"], v["numDigits"]
				
				if value >= divisor or value <= -divisor then -- Divide and use this unit
				
					fmt = "%." .. numDigits .. "f" .. unitString
					value = value / divisor
					decimalSeparator = formatTable["decimalSeparator"]
					
					unitsPattern = unitString:gsub(" ", "%%s") -- Escape whitespace for use in regex pattern
					unitsPattern = unitsPattern:gsub("%.", "%%.") -- Escape decimal point for use in regex pattern
					
					break -- Found the largest divisor -> There's no need to continue
				end
				
			end
			
		end
		
		if format then -- Apply format to number and return formatted string

			fmt = fmt:format(value)

			local integerPart, fractionalPart, unit = fmt:match("^(%d+)%.([1-9]?)0*(" .. unitsPattern .. ")") -- Remove trailing zeroes (e.g., 4.00 m => 4m, 13.0k => 13k, etc.)
			
			if integerPart and unit then -- Is a valid number that can be returned
			
				if fractionalPart and tonumber(fractionalPart) then -- Number needs to include decimalSeparator and fractionalPart as well
					
					return integerPart .. decimalSeparator .. fractionalPart .. unit -- e.g., "3.55m"
					
				end
		
            return integerPart .. unit -- e.g., "3m"
			
			end
		 
			return fmt	
			
		end
		
		return fmt, value
		
	else -- Only numbers are supported
		return	
	end
	
end


if not T then return end
T.Utils.FormatShort = FormatShort

return FormatShort
