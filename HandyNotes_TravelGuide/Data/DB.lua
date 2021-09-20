-- Functions
local _G = getfenv(0)
local pairs = _G.pairs;
-- Libraries
-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local FOLDER_NAME, private = ...
local LibStub = _G.LibStub
local L = LibStub("AceLocale-3.0"):GetLocale(private.addon_name);

local function GetLocaleLibBabble(typ)
	local rettab = {}
	local tab = LibStub(typ):GetBaseLookupTable()
	local loctab = LibStub(typ):GetUnstrictLookupTable()
	for k,v in pairs(loctab) do
		rettab[k] = v;
	end
	for k,v in pairs(tab) do
		if not rettab[k] then
			rettab[k] = v;
		end
	end
	return rettab;
end
local BZ = GetLocaleLibBabble("LibBabble-SubZone-3.0");
local function mapFile(mapID)
	return HandyNotes:GetMapIDtoMapFile(mapID)
end

local DB = {}

private.DB = DB

DB.points = {
	--[[ structure:
	[mapFile] = { -- "_terrain1" etc will be stripped from attempts to fetch this
		[coord] = {
			label=[string], 		-- label: text that'll be the label, optional
			npc=[id], 				-- related npc id, used to display names in tooltip
			type=[string], 			-- the pre-define icon type which can be found in Constant.lua
			class=[CLASS NAME],		-- specified the class name so that this node will only be available for this class
			faction="FACTION",      -- shows only for selected faction
			note=[string],			-- additional notes for this node
			level=[number]			-- map level from dropdown
		},
	},
	--]]
--Legion----------------------------------------------------------------------------------------------------------------------------------------------------------
	[mapFile(1014)] = { -- Dalaran Broken Isles
		[38296559] = { portal=true, level=10, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shrine of Seven Stars"]), faction="Alliance" },
		[56802336] = { portal=true, level=10, label=format(L[" Portal to Orgrimmar \n Portal to Undercity \n Portal to Thunder Bluff \n Portal to Silvermoon \n Portal to Shrine of Two Moons"]), faction="Horde" },
		[49354757] = { portal=true, level=10, label=L[" Caverns of Time \n Shattrath \n Wyrmrest Temple \n Dalaran Crater \n Karazhan"]  },
		[38747963] = { portal=true, level=12, label=format(L["Portal to Caverns of Time"]) },
		[35658549] = { portal=true, level=12, label=format(L["Portal to Shattrath"]) },
		[30798447] = { portal=true, level=12, label=format(L["Portal to Wyrmrest Temple"]) },
		[28777754] = { portal=true, level=12, label=format(L["Portal to Dalaran Crater, Alterac Mtn."]) },
		[31967150] = { portal=true, level=12, label=format(L["Portal to Karazhan"]) },
	},
	[mapFile(1007)] = { -- Broken Isles
		[30712543] = { portal=true, label=format(L[" Portal to Dalaran \n Portal to Emerald Dreamway"]), class="DRUID" },
		[45666494] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shrine of Seven Stars \n Portal to Caverns of Time \n Portal to Shattrath \n Portal to Wyrmrest Temple \n Portal to Dalaran Crater \n Portal to Karazhan"]), faction="Alliance" },
		[45666495] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Vale of Eternal Blossoms \n Portal to Caverns of Time \n Portal to Shattrath \n Portal to Wyrmrest Temple \n Portal to Dalaran Crater \n Portal to Karazhan"]), faction="Horde" },
	},
	[mapFile(1018)] = { -- Val'sharah
		[41742385] = { portal=true, label=format(L[" Portal to Dalaran \n Portal to Emerald Dreamway"]), class="DRUID" },
	},
	[mapFile(1017)] = { -- Stormheim
		[30104070] = { portal=true, label=format(L["Portal to Dalaran"])},
		[73503954] = { portal=true, label=format(L["Portal to Helheim"])},
	},
--Warlords of Draenor----------------------------------------------------------------------------------------------------------------------------------------------
    [mapFile(962)] = { -- Draenor
		[73004300] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Vol'mar"]), faction="Horde"},
		[73014305] = { portal=true, label=format(L[" Portal to Stromwind \n Portal to Ironforge \n Portal to Darnassus \n Portal to Lion's watch"]), faction="Alliance"},
        [34693700] = { portal=true, label=format(L["Portal to Warspear (Ashran)"]), note=L["Requirement: Garrison lvl 3"], faction="Horde"},
		[52406200] = { portal=true, label=format(L["Portal to Stormshield (Ashran)"]), note=L["Requirement: Garrison lvl 3"], faction="Alliance"},
		[60424563] = { portal=true, label=format(L["Portal to Warspear (Ashran)"]), note=L["Vol'mar unlocked"], faction="Horde"},
		[60524943] = { portal=true, label=format(L["Portal to Stormshield (Ashran)"]), note=L["Lion's Watch unlocked"], faction="Alliance"},
	},
	[mapFile(978)] = { -- Ashran
		[44001300] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Vol'mar"]), faction="Horde"},
		[40009000] = { portal=true, label=format(L[" Portal to Stromwind \n Portal to Ironforge \n Portal to Darnassus \n Portal to Lion's watch"]), faction="Alliance"},
	},
	[mapFile(976)] = { -- Frostwall (Garrison)
		[75104890] = { portal=true, label=format(L["Portal to Warspear (Ashran)"]), faction="Horde"},
	},
	[mapFile(941)] = { -- Frostfire Ridge
		[51526596] = { portal=true, label=format(L["Portal to Warspear (Ashran)"]), faction="Horde"},
	},
	[mapFile(971)] = { -- Lunarfall (Garrison)
		[70102750] = { portal=true, label=format(L["Portal to Stormshield (Ashran)"]), faction="Alliance"},
	},
	[mapFile(947)] = { -- Shadowmoon Valley
		[32861554] = { portal=true, label=format(L["Portal to Stormshield (Ashran)"]), faction="Alliance"},
	},
	[mapFile(945)] = { -- Tanaan Jungle
		[61004734] = { portal=true, label=format(L["Portal to Warspear (Ashran)"]), faction="Horde"},
		[58506000] = { portal=true, label=format(L["Portal to Stormshield (Ashran)"]), faction="Alliance"},
	},
	[mapFile(1011)] = { -- Warspear (Ashran)
		[50002450] = { portal=true, label=format(L["Portal to Thunder Bluff"]), faction="Horde"},
		[60705160] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde"},
		[63202410] = { portal=true, label=format(L["Portal to Undercity"]), faction="Horde"},
		[53104390] = { portal=true, label=format(L["Portal to Vol'mar"]), note=L["need Garrison lvl3, shipyard, and Quest progress"], faction="Horde"},
	},
[mapFile(1009)] = { -- Stormshield (Ashran)
		[51305090] = { portal=true, label=format(L["Portal to Ironforge"]), faction="Alliance"},
		[60903800] = { portal=true, label=format(L["Portal to Stromwind"]), faction="Alliance"},
		[63406440] = { portal=true, label=format(L["Portal to Darnassus"]), faction="Alliance"},
		[36104100] = { portal=true, label=format(L["Portal to Lion's watch"]), note=L["need Garrison lvl3, shipyard, and Quest progress"], faction="Alliance"},
	},	
--Mists of Pandaria-------------------------------------------------------------------------------------------------------------------------------------------------
	[mapFile(811)] = { -- Vale of Eternal Blossoms
		[87276493] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Alliance" },
		[63141292] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Horde" },
	},
	[mapFile(862)] = { -- Pandaria
		[54465630] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Ironforge \n Portal to Darnasuss \n Portal to Exodar \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Alliance" },
		[29494649] = { portal=true, label=format(L["Portal to Isle of Thunder"]) },
		[20261537] = { portal=true, label=format(L["Portal to Shado-Pan Garrison"]) },
		[50734785] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Thunder Bluff \n Portal to Undercity \n Portal to Silvermoon \n Portal to Shattrath \n Portal to Dalaran-Northrend"]), faction="Horde" },
	},
	[mapFile(810)] = { -- Townlong Steppes
		[49706870] = { portal=true, label=format(L["Portal to Isle of Thunder"]), faction="Alliance"},
		[50607340] = { portal=true, label=format(L["Portal to Isle of Thunder"]), faction="Horde"},
	},
	[mapFile(806)] = { -- The Jade Forest
		[28501400] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde"},
	},
	[mapFile(928)] = { -- Isle of Thunder
		[64707348] = { portal=true, label=format(L["Portal to Shado-Pan Garrison"]), faction="Alliance"},
		[33213269] = { portal=true, label=format(L["Portal to Shado-Pan Garrison"]), faction="Horde"},
	},
--Cataclysm---------------------------------------------------------------------------------------------------------------------------------------------------------
	[mapFile(606)] = { -- Mount Hyjal
		[62522429] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[63492444] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
	},
	[mapFile(640)] = { -- Deepholm
		[49485184] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[50935310] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
	},
	[mapFile(709)] = { -- Tol Barad Peninsula
		[75255887] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[56277966] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
	},
--Wrath of the Lich King-------------------------------------------------------------------------------------------------------------------------------------------
	[mapFile(504)] = { -- Dalaran Northrend
		[40086282] = { portal=true, level=1, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[55432550] = { portal=true, level=1, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
		[25634785] = { portal=true, level=1, label=format(L[" Portal to Caverns of Time \n Portal to the Purple Parlor"]) },
	},
	[mapFile(510)] = { -- Crystalsong Forest
		[26194278] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Cavern of Time"]), faction="Alliance" },
		[31273177] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Cavern of Time"]), faction="Horde" },
	},
	[mapFile(485)] = { -- Northrend
		[47874119] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Cavern of Time"]), faction="Alliance" },
		[47894119] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Cavern of Time"]), faction="Horde" },
		[80748454] = { boat=true, label=format(L["Boat to Menethil Harbor"]), faction="Alliance" },
		[23117069] = { boat=true, label=format(L["Boat to Stormwind"]), faction="Alliance" },
		[46596733] = { boat=true, label=format(L[" Boat to Unu'Pe \n Boat to Kamagua"]) },
		[29306561] = { boat=true, label=format(L["Boat to Moa'Ki Harbor"]) },
		[67738283] = { boat=true, label=format(L["Boat to Moa'Ki Harbor"]) },
		[17556488] = { zeppelin=true, label=format(L["Zeppelin to Orgrimmar"]), note=L["Durotar"], faction="Horde" },
		[86237276] = { zeppelin=true, label=format(L["Zeppelin to Undercity"]), note=L["Trisfal Glades"], faction="Horde" },
	},
	[mapFile(488)] = { -- Dragonblight
		[47797887] = { boat=true, label=format(L["Boat to Unu'Pe"]) },
		[49847853] = { boat=true, label=format(L["Boat to Kamagua"]) },
	},
	[mapFile(486)] = { -- Borean Tundra
		[79015383] = { boat=true, label=format(L["Boat to Moa'Ki Harbor"]) },
		[59946947] = { boat=true, label=format(L["Boat to Stormwind"]), faction="Alliance" },
		[41255344] = { zeppelin=true, label=format(L["Zeppelin to Orgrimmar"]), note=L["Durotar"], faction="Horde" },
	},
	[mapFile(491)] = { -- Howling Fjord
		[23295769] = { boat=true, label=format(L["Boat to Moa'Ki Harbor"]) },
		[61506270] = { boat=true, label=format(L["Boat to Menethil Harbor"]), faction="Alliance" },
		[77612813] = { zeppelin=true, label=format(L["Zeppelin to Undercity"]), note=L["Trisfal Glades"], faction="Horde" },
	},
--The Burning Crusade-------------------------------------------------------------------------------------------------------------------------------------------
	[mapFile(465)] = { -- Hellfire Peninsula
		[89225101] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[89234946] = { portal=true, label=format(L["Portal to  Orgrimmar"]), faction="Horde" },
	},
	[mapFile(481)] = { -- Shattrath
		[57224827] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[48594200] = { portal=true, label=format(L["Portal to Isle of Quel'Danas"]) },
		[56834888] = { portal=true, label=format(L["Portal to  Orgrimmar"]), faction="Horde" },
	},
	[mapFile(466)] = { -- Outland
		[43886598] = { portal=true, label=format(L[" Portal to Stormwind \n Portal to Isle of Quel'Danas"]), faction="Alliance" },
		[43886599] = { portal=true, label=format(L[" Portal to Orgrimmar \n Portal to Isle of Quel'Danas"]), faction="Horde" },
		[69025230] = { portal=true, label=format(L["Portal to Stormwind"]), faction="Alliance" },
		[69025231] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
	},
	[mapFile(471)] = { -- Exodar
		[48156305] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[47616214] = { portal=true, label=format(L["Portal to Darnassus"]), faction="Alliance" },
	},
	[mapFile(464)] = { -- Azuremyst Isle
		[20125424] = { boat=true, label=format(L["Boat to Darnassus"]), faction="Alliance" },
	},
	[mapFile(480)] = { -- Silvermoon
		[58402100] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[49401510] = { portal=true, label=format(L["Portal to Undercity"]), note=L["Orb of translocation"], faction="Horde" },
	},
	[mapFile(462)] = { -- Eversong Woods
		[54003300] = { portal=true, label=format(L[" Portal to Undercity \n Portal to Hellfire Peninsula"]), faction="Horde" },
	},
	[mapFile(19)] = { -- Blasted Lands
		[72644947] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
	},
--Vanilla-------------------------------------------------------------------------------------------------------------------------------------------------------
	[mapFile(301)] = { -- Stormwind
		[48948733] = { portal=true, label=format(L[" Portal to Blasted Lands \n Portal to Hellfire Peninsula"]), faction="Alliance" },
		[87543524] = { portal=true, label=format(L["Portal to Ashran"]), faction="Alliance" },
		[22015670] = { boat=true, label=format(L["Boat to Darnassus"]), note=L["Rut'theran Village"], faction="Alliance" },
		[17592553] = { boat=true, label=format(L["Boat to Borean Tundra"]), note=L["Valiance Keep"], faction="Alliance" },
		[74481841] = { portal=true, label=format(L[" Portal to Tol Barad \n Portal ro Uldum \n Portal to Deepholm \n Portal to Vashj'ir \n Portal to Twilight Highlands \n Portal to Hyjal"]), faction="Alliance" },
		[68761714] = { portal=true, label=format(L["Portal to Pandaria"]), faction="Alliance" },
		[80253485] = { portal=true, label=format(L["Portal to Dalaran"]), faction="Alliance" },
	},
	[mapFile(321)] = { -- Orgrimmar
		[44466670] = { portal=true, level=02, label=format(L[" Portal to Blasted Lands \n Portal to Dalaran"]), faction="Horde" },
		[30275833] = { portal=true, level=02, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[36137094] = { portal=true, level=02, label=format(L["Portal to Dalaran"]), faction="Horde" },
		[46116002] = { portal=true, level=01, label=format(L[" Portal to Blasted Lands \n Portal to Dalaran \n Portal to Hellfire Peninsula"]), faction="Horde" },
		[50435651] = { zeppelin=true, level=01, label=format(L["Zeppelin to Undercity"]), note=L["Tirisfal Glades"], faction="Horde" },
		[42636567] = { zeppelin=true, level=01, label=format(L["Zeppelin to Thunder Bluff"]), note=L["Mulgore"], faction="Horde" },
		[50103773] = { portal=true, level=01, label=format(L[" Portal to Tol Barad \n Portal to Uldum \n Portal to Deepholm \n Portal to Vashj'ir \n Portal to Twilight Highlands \n Portal to Hyjal"]), faction="Horde" },
		[68824039] = { portal=true, level=01, label=format(L["Portal to Pandaria"]) },
		[45306178] = { zeppelin=true, level=01, label=format(L["Zeppelin to Borean Tundra"]), note=L["Warsong Hold"], faction="Horde" },
		[52885242] = { zeppelin=true, level=01, label=format(L["Zeppelin to Stranglethorn Vale"]), note=L["Grom'gol Base Camp"], faction="Horde" },
		},
	[mapFile(382)] = { -- Undercity
		[84781646] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		},
	[mapFile(20)] = { -- Trisfal Glades
		[65766857] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[59506740] = { portal=true, label=format(L["Portal to Silvermoon"]), note=L["Orb of translocation"], faction="Horde" },
		[60475885] = { zeppelin=true, label=format(L["Zeppelin to Orgrimmar"]), note=L["Durotar"], faction="Horde" },
		[62035926] = { zeppelin=true, label=format(L["Zeppelin to Stranglethorn Vale"]), note=L["Grom'gol Base Camp"], faction="Horde" },
		[58875901] = { zeppelin=true, label=format(L["Zeppelin to Howling Fjord"]), note=L["Vengeance Landing"], faction="Horde" },
		},
	[mapFile(362)] = { -- Thunder Bluff
		[23221350] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[14222574] = { zeppelin=true, label=format(L["Zeppelin to Orgrimmar"]), note=L["Durotar"], faction="Horde" },
		},
	[mapFile(9)] = { -- Mulgore
		[35412133] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[33692368] = { zeppelin=true, label=format(L["Zeppelin to Orgrimmar"]), note=L["Durotar"], faction="Horde" },
		},
	[mapFile(40)] = { -- Wetlands
		[06216261] = { boat=true, label=format(L["Boat to Theramore"]), note=L["Dustwallow Marsh"], faction="Alliance" },
		[04415718] = { boat=true, label=format(L["Boat to Howling Fjord"]), note=L["Valgarde"], faction="Alliance" },
	},
	[mapFile(13)] = { -- Kalimdor
		[59276854] = { boat=true, label=format(L["Boat to Menethil Harbor"]), faction="Alliance" },
		[56835629] = { boat=true, label=format(L["Boat to Booty Bay"]) },
		[43181817] = { boat=true, label=format(L[" Boat to Stormwind \n Boat to Exodar"]), faction="Alliance" },
		[39551281] = { portal=true, label=format(L[" Portal to Hellfire Peninsula \n Portal to Exodar"]), faction="Alliance" },
		[29992737] = { portal=true, label=format(L[" Portal to Hellfire Peninsula \n Portal to Darnassus"]), faction="Alliance" },
		[29312826] = { boat=true, label=format(L["Boat to Darnassus"]) },
		[45965583] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[45375637] = { zeppelin=true, label=format(L["Zeppelin to Orgrimmar"]), note=L["Durotar"], faction="Horde" },
		[60174524] = { zeppelin=true, label=format(L["Orgrimmar Zeplins"]), note=L[" Zeppelin to Thunder Bluff \n Zeppelin to Undercity \n Zeppelin to Grom'gol \n Zeppelin to Borean Tundra"], faction="Horde" },
		},
	[mapFile(11)] = { -- Northern Barrens
		[70307341] = { boat=true, label=format(L["Boat to Booty Bay"]) },
	},
	[mapFile(673)] = { -- Cape of Stranglethorn
		[38546670] = { boat=true, label=format(L["Boat to Ratchet"]) },
	},
	[mapFile(14)] = { -- Eastern Kingdom
		[41107209] = { boat=true, label=format(L["Stormwind Dock"]), note=L[" Boat to Darnassus \n Boat to Borean Tundra"], faction="Alliance" },
		[46885813] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[42933465] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Horde" },
		[56561300] = { portal=true, label=format(L[" Portal to Undercity \n Portal to Hellfire Peninsula"]), faction="Horde" },
		[54078458] = { portal=true, label=format(L["Portal to Orgrimmar"]), faction="Horde" },
		[45995488] = { boat=true, label=format(L["Menethil Harbor"]), note=L[" Boat to Theramore \n Boat to Howling Fjord"], faction="Alliance" },
		[42999362] = { boat=true, label=format(L["Boat to Ratchet"]) },
		[44068694] = { zeppelin=true, label=format(L["Grom'gol Base Camp"]), note=L[" Zeppelin to Orgrimmar \n Zeppelin to Undercity"], faction="Horde" },
		[43863354] = { zeppelin=true, label=format(L["Trisfal Glades"]), note=L[" Zeppelin to Orgrimmar \n Zeppelin to Grom'gol Base Camp"], faction="Horde" },
	},
	[mapFile(37)] = { -- Northern Stranglethorn
		[37195161] = { boat=true, label=format(L["Grom'gol Base Camp"]), note=L[" Zeppelin to Orgrimmar \n Zeppelin to Undercity"], faction="Horde" },
	},
	[mapFile(341)] = { -- Ironforge
		[27260699] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[48948733] = { portal=true, label=format(L["Portal to Blasted Lands"]), faction="Alliance" },
	},
	[mapFile(141)] = { -- Dustwallow Marsh
		[71625648] = { boat=true, label=format(L["Boat to Menethil Harbor"]), note=L["Wetlands"], faction="Alliance" },
	},
	[mapFile(381)] = { -- Darnassus
		[43997817] = { portal=true, label=format(L["Portal to Hellfire Peninsula"]), faction="Alliance" },
		[44247867] = { portal=true, label=format(L["Portal to Exodar"]), faction="Alliance" },
	},
	[mapFile(41)] = { -- Teldrassil
		[29085646] = { portal=true, label=format(L[" Portal to Hellfire Peninsula \n Portal to Exodar"]), faction="Alliance" },
		[54939412] = { boat=true, label=format(L["Boat to Stormwind"]), faction="Alliance" },
		[52048951] = { boat=true, label=format(L["Boat to Exodar"]), faction="Alliance" },
	},
}
