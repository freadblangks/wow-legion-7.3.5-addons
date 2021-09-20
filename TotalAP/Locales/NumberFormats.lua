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

local addonName, T = ...

	-- Format styles used by the client for different locales (in the spell descriptions of AP "Empowering" spells, and elsewhere after 7.2)
	-- koKR / zhTW / zhCN: <text><whitespace><integer number><unit multiplier><whitespace><text>
	-- All other locales: <text><whitespace><integer or decimal number><whitespace><unit multiplier><whitespace><text>
	-- For the unit tables, indices matter, as the plural terms need to be checked first for some locales that use similar wordings (e.g., mil millones > millones) to match properly
local localeNumberFormats = {
	
	-- enUS: English (United States)
	["enUS"] = {	
		["thousandsSeparator"] = ",",
		["decimalSeparator"] = ".",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
			[1] = {
				["million"] = 1000000,
			},
			[2] = {
				["millions"] = 1000000,
			},
			[3] = {
				["billion"] =  1000000000,
			},
			[4] = {
				["billions"] = 1000000000,
			}
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = "B",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = "M",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "K",
				["numDigits"] = 1,
			}
		}
	},
	
	-- deDE: German (Germany)
	["deDE"] = {	
		["thousandsSeparator"] = ".",
		["decimalSeparator"] = ",",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
			[1] = {
				["Millionen"] = 1000000,
			},
			[2] = {
				["Million"] = 1000000,
			},
			[3] = {
				["Milliarden"] = 1000000000,
			},
			[4] = {
				["Milliarde"] = 1000000000,
			},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = " Mrd.",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = " Mio.",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = " Tsd.",
				["numDigits"] = 1,
			}
		}
	},
	 
	-- esES: Spanish (Spain)
	["esES"] = {	
		["thousandsSeparator"] = " ",
		["decimalSeparator"] = ",",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
				[1] = {
					["millón"] = 1000000
				},
				[2] = {
					["mil millones"] =  1000000000
				},
				[3] = {
					["millones"] = 1000000
				},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = " bil.",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = " mil.",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "K",
				["numDigits"] = 1,
			}
		}
	},

	-- esES: Spanish (Mexico & Latin America)
	["esMX"] = {	
		["thousandsSeparator"] = ",",
		["decimalSeparator"] = ".",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
				[1] = {
					["millón"] = 1000000
				},
				[2] = {
					["mil millones"] =  1000000000
				},
				[3] = {
					["millones"] = 1000000
				},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = " bil.",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = " mil.",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "K",
				["numDigits"] = 1,
			}
		}
	},
	
	
	-- frFR: French (France)
	["frFR"] = {	
		["thousandsSeparator"] = " ",
		["decimalSeparator"] = ",",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
			[1] = {
				["million"] = 1000000,
			},
			[2] = {
				["milliard"] = 1000000000,
			},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = "B",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = "M",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "K",
				["numDigits"] = 1,
			}
		}
	},

	-- itIT: Italian (Italy)
	["itIT"] = {	
		["thousandsSeparator"] = ".",
		["decimalSeparator"] = ",",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
			[1] = {
				["milioni"] = 1000000,
			},
			[2] = {
				["milione"] = 1000000,
			},
			[3] = {
				["milardi"] =  1000000000,
			},
			[4] = {
				["miliardo"] = 1000000000,
			}
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = "B",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = "M",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "K",
				["numDigits"] = 1,
			}
		}
	},

	-- koKR: Korean (Korea)
	["koKR"] = {	
		["thousandsSeparator"] = ",",  -- not actually used 
		["decimalSeparator"] = ".", -- not actually used
		["leadingSpace"] = " ",
		["trailingSpace"] = "",
		["unitsTable"] = {
			[1] = {
				["만"] = 10000,
			},
			[2] = {
				["억"] = 100000000,
			},
			[3] = {
				["조"] = 1000000000000,
			},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000000,
				["unitString"] = "조",
				["numDigits"] = 2,
			},
			
			[2] = {
				["divisor"] = 100000000,
				["unitString"] = "억",
				["numDigits"] = 2,
			},
			
			[3] = {
				["divisor"] = 10000,
				["unitString"] = "만",
				["numDigits"] = 2,
			}
		}
	},

	-- ptBR: Portuguese (Brazil)
	["ptBR"] = {	
		["thousandsSeparator"] = ",", -- TODO: Seems to also use "." ingame!? This is not going to end well...
		["decimalSeparator"] = ".",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
			[1] = {
				["milhões"] = 1000000,
			},
			[2] = {
				["milhão"] = 1000000,
			},
			[3] = {
				["bilhões"] = 1000000000,
			},
			[4] = {
				["bilhão"] = 1000000000,
			},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = "B",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = "M",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "K",
				["numDigits"] = 1,
			}
		}
	},

	-- ruRU: Russian (Russia) 
	["ruRU"] = {	
		["thousandsSeparator"] = " ",
		["decimalSeparator"] = ",",
		["leadingSpace"] = " ",
		["trailingSpace"] = " ",
		["unitsTable"] = {
			[1] = {
				["млрд"] = 1000000000,
			},
			[2] = {
				["млн"] =  1000000,
			},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000,
				["unitString"] = " млрд",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 1000000,
				["unitString"] = " млн",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 1000,
				["unitString"] = "к",
				["numDigits"] = 1,
			}
		}
	},

	-- zhCN: Chinese (Simplified, PRC)
	["zhCN"] = {	
		["thousandsSeparator"] = ",",
		["decimalSeparator"] = ".",
		["leadingSpace"] = "",
		["trailingSpace"] = "",
		["unitsTable"] = {
			[1] = {
				["万"] = 10000,
			},
			[2] = {
				["亿"] = 100000000,
			},
		},
		["unitsShort"] = {
			[1] = {
				["divisor"] = 100000000,
				["unitString"] = "亿",
				["numDigits"] = 2,
			},
			
			[2] = {
				["divisor"] = 10000,
				["unitString"] = "万",
				["numDigits"] = 2
			},
		}
	},
	
	-- zhTW: Chinese (Traditional, Taiwan)
	 ["zhTW"] = { 
		["thousandsSeparator"] = ",",
		["decimalSeparator"] = ".",
		["leadingSpace"] = "",
		["trailingSpace"] = "",
		["unitsTable"] = {
			 [1] = {
				 ["萬"] = 10000,
			 },
			 [2] = {
				 ["億"] = 100000000,
			 },
			 [3] = {
				 ["兆"] = 1000000000000,
			 },
		 },
		["unitsShort"] = {
			[1] = {
				["divisor"] = 1000000000000,
				["unitString"] = "兆",
				["numDigits"] = 1,
			},
			
			[2] = {
				["divisor"] = 100000000,
				["unitString"] = "億",
				["numDigits"] = 1,
			},
			
			[3] = {
				["divisor"] = 10000,
				["unitString"] = "萬",
				["numDigits"] = 2,
			},
			
			[4] = {
				["divisor"] = 1000,
				["unitString"] = "千",
				["numDigits"] = 1,
			}
		}
	},

}

 -- enGB: English (United Kingdom) - enGB clients return enUS
localeNumberFormats["enGB"] = localeNumberFormats["enUS"] -- Not sure if necessary, but it's better to be safe than sorry (in case enGB is indexed... which does seems unlikely due to the enGB client returning enUS via GetLocale())


-- Returns number format for nonstandard locales (ease of use)
-- Will return a single key if given its index, or the entire formats table by default
local function GetLocaleNumberFormat(locale, key)
	
	if not locale then
		locale = GetLocale()
	end
	
	if not key then
		return localeNumberFormats[locale]
	end
	
	return localeNumberFormats[locale][key]
	
end
	

	-- Make functions available in the addon's namespace  (T is the addonTable)
if not T then return end
T.GetLocaleNumberFormat = GetLocaleNumberFormat

return T
