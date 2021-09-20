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

-- [[ Artifacts.lua ]]
-- DB of artifact weapons for each class and spec

-- TODO: Outdated format (offhand info is useless, as the design has changed significantly and a simple LUT would be sufficient now)

local addonName, TotalAP = ...

if not TotalAP then return end

-- (Legacy comment)
-- Format: [classID] = { [specID] = { itemID, IsOffhandWeapon (meaning, slot = 17 instead of 16) } } 
-- Note that IsOffhandWeapon should be considered more like "CanOccupyOffhandSlot" or even "IsPrimaryArtifact" for some specs... it's not exclusive, at least not in all cases
-- The "false" entries could also be removed (and later checked for nil instead), but I don't like that as it leaves the DB somewhat incomplete


-- Only main hand weapons are listed, as that should be sufficient (TODO: separate into mainhand/offhand fields if need be?)
local artifactsByClass = {

	{ -- 1 	Warrior 	WARRIOR
		{ -- 1	Arms
			 itemID = 128910  -- Strom'kar, the Warbreaker 
		},
		
		{ -- 2	Fury
			itemID = 128908 , -- Odyn's Fury
		--	itemID = 134553 -- Helya's Wrath 
		},
		
		{ -- 3	Protection
		--	itemID = 128288, --  Scaleshard
			itemID = 128289 -- Scale of the Earth-Warder 
		}
	},
	
	{ -- 2 	Paladin 	PALADIN
		{ -- 1	Holy
			itemID = 128823 -- The Silver Hand 
		},
		
		{ -- 2	Protection
			itemID = 128866, -- Truthguard
		--	itemID = 128867 -- Oathseeker
		},
		
		{ -- 3	Retribution
			itemID = 120978 -- Ashbringer
		}
	},
	
	{ -- 3 	Hunter 	HUNTER
		{ -- 1	Beast Mastery
			itemID = 128861 -- Titanstrike
		},
		
		{ -- 2	Marksmanship
			itemID = 128826 -- Thas'dorah, Legacy of the Windrunners
		},
		
		{ -- 3	Survival
			itemID = 128808 -- Talonstrike
		}
	},
	
	{ -- 4 	Rogue 	ROGUE
		{ -- 1	Assassination
		--	itemID = 128870,  -- Anguish
			itemID = 128869 -- Sorrow
		},
		
		{ -- 2	Outlaw
			itemID = 128872, -- Fate
		--	itemID = 134552 -- Fortune
		},
		
		{ -- 3	Subtletly
			itemID = 128476, -- Gorefang
		--	itemID = 128479 -- Akaari's Will
		}
	},
	
	{ -- 5 	Priest 	PRIEST
		{ -- 1	Discipline
			itemID = 128868 -- Light's Wrath
		},
		
		{ -- 2	Holy
			itemID = 128825 -- T'uure, Beacon of the Naaru 
		},
		
		{ -- 3	Shadow
			itemID = 128827, -- Xal'atath, Blade of the Black Empire 
		--	itemID = 133958 -- Secrets of the Void 
		}
	},
	
	{ -- 6 	Death Knight 	DEATHKNIGHT
		{ -- 1	Blood
			itemID = 128402 -- Maw of the Damned
		},
		
		{ -- 2	Frost
			itemID = 128292, -- Frostreaper
		--	itemID = 128293 } -- Icebringer
		},
		
		{ -- 3	Unholy
			itemID = 128403 -- Apocalypse
		}
	},
	
	{ -- 7 	Shaman 	SHAMAN
		{ -- 1	Elemental
			itemID = 128935, -- The Fist of Ra-den
		--	itemID = 128936 -- The Highkeeper's Ward
		},
		
		{ -- 2	Enhancement
			itemID = 128819, -- Doomhammer
		--	itemID = 128873 -- Fury of the Stonemother
		},
		
		{ -- 3	Restoration
			itemID = 128911, -- Sharas'dal, Scepter of Tides 
		--	itemID = 128934, true -- Shield of the Sea Queen 
		}
	},
	
	{ -- 8 	Mage 	MAGE
		{ -- 1	Arcane
			itemID = 127857 -- Aluneth
		},
		
		{ -- 2	Fire
			itemID = 128820, -- Felo'melorn
		--	133959, true -- Heart of the Phoenix
		},
		
		{ -- 3	Frost
			itemID = 128862 -- Ebonchill
		}
	},
	
	{ -- 9 	Warlock 	WARLOCK
		{ -- 1	Affliction
			itemID = 128942 -- Ulthalesh, the Deadwind Harvester 
		},
		
		{ -- 2	Demonology
			itemID = 128943, -- Skull of the Man'ari
		--	itemID = 137246 -- Spine of Thal'kiel 
		},
		
		{ -- 3	Destruction
			itemID = 128941 -- Scepter of Sargeras
		}
	},
	
	{ -- 10 	Monk 	MONK
		{ -- 1	Brewmaster
			itemID = 128938 -- Fu Zan, the Wanderer's Companion
		},
		
		{ -- 2	Mistweaver
			itemID = 128937-- Sheilun, Staff of the Mists (
		},
		
		{ -- 3	Windwalker
			itemID = 128940, -- Al'burq
		--	itemID = 133948 -- Alra'ed
		}
	},

	{ -- 11 	Druid 	DRUID
		{ -- 1	Balance
			itemID = 128858 -- Scythe of Elune
		},
		
		{ -- 2	Feral
			itemID = 128860, -- Fangs of Ashamane (MH)
		--	itemID = 128859 -- Fangs of Ashamane (OH)
		},
		
		{ -- 3	Guardian
			itemID = 128821, -- Claws of Ursoc (MH)
		--	itemID = 128822 -- Claws of Ursoc (OH)
		},
		
		{ -- 4	Restoration
			itemID = 128306 -- G'Hanir, the Mother Tree 
		}
	},
	
	{ -- 12 	Demon Hunter 	DEMONHUNTER
		{ -- 1	Havoc
			itemID = 127829, -- Verus
		--	itemID = 127830 -- Muramas
		},
		
		{ -- 2	Vengeance
			itemID = 128832, -- Aldrachi Warblades (MH)
		--	itemID = 128831 -- Aldrachi Warblades (OH)
		}
	},
};


-- Populate DB
TotalAP.DB["artifacts"] = artifactsByClass

return TotalAP.DB["artifacts"]


-- (Legacy format)
-- local artifactsByClass = {

	-- { -- 1 	Warrior 	WARRIOR
		-- { -- 1	Arms
			-- { 128910, false }  -- Strom'kar, the Warbreaker 
		-- },
		
		-- { -- 2	Fury
			-- { 128908, true } , -- Odyn's Fury
			-- { 134553, true } -- Helya's Wrath 
		-- },
		
		-- { -- 3	Protection
			-- { 128288, false }, --  Scaleshard
			-- { 128289, true } -- Scale of the Earth-Warder 
		-- }
	-- },
	
	-- { -- 2 	Paladin 	PALADIN
		-- { -- 1	Holy
			-- { 128823, false } -- The Silver Hand 
		-- },
		
		-- { -- 2	Protection
			-- { 128866, true }, -- Truthguard
			-- { 128867, false } -- Oathseeker
		-- },
		
		-- { -- 3	Retribution
			-- { 120978, false } -- Ashbringer
		-- }
	-- },
	
	-- { -- 3 	Hunter 	HUNTER
		-- { -- 1	Beast Mastery
			-- { 128861, false } -- Titanstrike
		-- },
		
		-- { -- 2	Marksmanship
			-- { 128826, false } -- Thas'dorah, Legacy of the Windrunners
		-- },
		
		-- { -- 3	Survival
			-- { 128808, false } -- Talonstrike
		-- }
	-- },
	
	-- { -- 4 	Rogue 	ROGUE
		-- { -- 1	Assassination
			-- { 128870, false }, -- Anguish
			-- { 128869, true } -- Sorrow
		-- },
		
		-- { -- 2	Outlaw
			-- { 128872, false }, -- Fate
			-- { 134552, true } -- Fortune
		-- },
		
		-- { -- 3	Subtletly
			-- { 128476, false }, -- Gorefang
			-- { 128479, true } -- Akaari's Will
		-- }
	-- },
	
	-- { -- 5 	Priest 	PRIEST
		-- { -- 1	Discipline
			-- { 128868, false } -- Light's Wrath
		-- },
		
		-- { -- 2	Holy
			-- { 128825, false } -- T'uure, Beacon of the Naaru 
		-- },
		
		-- { -- 3	Shadow
			-- { 128827, false }, -- Xal'atath, Blade of the Black Empire 
			-- { 133958, true } -- Secrets of the Void 
		-- }
	-- },
	
	-- { -- 6 	Death Knight 	DEATHKNIGHT
		-- { -- 1	Blood
			-- {128402, false } -- Maw of the Damned
		-- },
		
		-- { -- 2	Frost
			-- { 128292, false }, -- Frostreaper
			-- { 128293, true } -- Icebringer
		-- },
		
		-- { -- 3	Unholy
			-- { 128403, false } -- Apocalypse
		-- }
	-- },
	
	-- { -- 7 	Shaman 	SHAMAN
		-- { -- 1	Elemental
			-- { 128935, false }, -- The Fist of Ra-den
			-- { 128936, true } -- The Highkeeper's Ward
		-- },
		
		-- { -- 2	Enhancement
			-- { 128819, false }, -- Doomhammer
			-- { 128873, true } -- Fury of the Stonemother
		-- },
		
		-- { -- 3	Restoration
			-- { 128911, false }, -- Sharas'dal, Scepter of Tides 
			-- { 128934, true } -- Shield of the Sea Queen 
		-- }
	-- },
	
	-- { -- 8 	Mage 	MAGE
		-- { -- 1	Arcane
			-- { 127857, false } -- Aluneth
		-- },
		
		-- { -- 2	Fire
			-- { 128820, false }, -- Felo'melorn
			-- { 133959, true } -- Heart of the Phoenix
		-- },
		
		-- { -- 3	Frost
			-- { 128862, false } -- Ebonchill
		-- }
	-- },
	
	-- { -- 9 	Warlock 	WARLOCK
		-- { -- 1	Affliction
			-- { 128942, false } -- Ulthalesh, the Deadwind Harvester 
		-- },
		
		-- { -- 2	Demonology
			-- { 128943, true }, -- Skull of the Man'ari
			-- { 137246, false } -- Spine of Thal'kiel 
		-- },
		
		-- { -- 3	Destruction
			-- { 128941, false } -- Scepter of Sargeras
		-- }
	-- },
	
	-- { -- 10 	Monk 	MONK
		-- { -- 1	Brewmaster
			-- { 128938, false } -- Fu Zan, the Wanderer's Companion
		-- },
		
		-- { -- 2	Mistweaver
			-- { 128937, false } -- Sheilun, Staff of the Mists (
		-- },
		
		-- { -- 3	Windwalker
			-- { 128940, false }, -- Al'burq
			-- { 133948, true } -- Alra'ed
		-- }
	-- },

	-- { -- 11 	Druid 	DRUID
		-- { -- 1	Balance
			-- { 128858, false } -- Scythe of Elune
		-- },
		
		-- { -- 2	Feral
			-- { 128860, false }, -- Fangs of Ashamane (MH)
			-- { 128859, true } -- Fangs of Ashamane (OH)
		-- },
		
		-- { -- 3	Guardian
			-- { 128821, false }, -- Claws of Ursoc (MH)
			-- { 128822, true } -- Claws of Ursoc (OH)
		-- },
		
		-- { -- 4	Restoration
			-- { 128306, false } -- G'Hanir, the Mother Tree 
		-- }
	-- },
	
	-- { -- 12 	Demon Hunter 	DEMONHUNTER
		-- { -- 1	Havoc
			-- { 127829, false }, -- Verus
			-- { 127830, true } -- Muramas
		-- },
		
		-- { -- 2	Vengeance
			-- { 128832, false }, -- Aldrachi Warblades (MH)
			-- { 128831, true } -- Aldrachi Warblades (OH)
		-- }
	-- },
-- };


-- (Legacy comment)
-- Use IDs with API_GetClassInfo(1 .. GetNumClass() ): classDisplayName, classTag, classID = GetClassInfo(index)
-- Class ID 	Class Name 	englishClass
-- By accessing artifactsByClass(classID), only the relevant artifacts are returned, which can then be checked against the active spec's ID (1 = first entry, etc.)
-- Important: Since some specs have two different artifacts (and Fury warriors, for example, can wield them in either main- OR offhand), ALL entries should be checked -> one would have IsOffhandWeapon = true, the other = false
