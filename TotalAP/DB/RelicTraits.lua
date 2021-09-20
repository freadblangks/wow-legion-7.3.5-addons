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


local traitsByClass = {

	{ -- 1 	Warrior 	WARRIOR
		{ -- 1	Arms
			{
				spellID = 216274, -- Many Will Fall (with Fervor of Battle taken)
				icon = "ability_whirlwind",
			},
			{
				spellID = 209492, -- Precise Strikes
				icon = "ability_warrior_colossussmash",
			},
			{
				spellID = 209494, -- Exploit the Weakness
				icon = "ability_warrior_warbringer",
			},
		},
		
		{ -- 2	Fury
			 {
				spellID = 200860, -- Unrivaled Strength
				icon = "ability_warrior_strengthofarms",
			 },
			 {
				spellID = 200849, -- Wrath and Fury
				icon = "warrior_wild_strike",
			 },
			 {
				spellID = 200861, -- Raging Berserker
				icon = "ability_warrior_endlessrage",
			 },
		},
		
		{ -- 3	Protection
			 {
				spellID = 238077, -- Bastion of the Aspects
				icon = "ability_warrior_criticalblock",
			 },
			 {
				spellID = 188635, -- Vrykul Shield Training
				icon = "inv_misc_monsterscales_07",
			 },
			 {
				spellID = 203225, -- Dragon Skin
				icon = "ability_warrior_intensifyrage",
			 },
		}
	},
	
	{ -- 2 	Paladin 	PALADIN
		{ -- 1	Holy
			 {
				spellID = 200315, -- Shock Treatment
				icon = "spell_holy_searinglight",
			 },
			 {
				spellID = 200294, -- Deliver the Light
				icon = "spell_holy_surgeoflight",
			 },
			 {
				spellID = 200482, -- Second Sunrise
				icon = "spell_paladin_lightofdawn",
			 },
		},
		
		{ -- 2	Protection
			 {
				spellID = 209220, -- Unflinching Defense
				icon = "spell_holy_ardentdefender",
			 },
			 {
				spellID = 213570, -- Righteous Crusader
				icon = "ability_paladin_shieldofvengeance",
			 },
			 {
				spellID = 211912, -- Faith's Armor
				icon = "inv_misc_armorkit_23",
			 },
		},
		
		{ -- 3	Retribution
			 {
				spellID = 186945, -- Wrath of the Ashbringer
				icon = "ability_paladin_sanctifiedwrath",
			 },
			 {
				spellID = 186927, -- Deliver the Justice
				icon = "spell_holy_sealofvengeance",
			 },
			 {
				spellID = 238062, -- Righteous Verdict
				icon = "ability_paladin_bladeofjustice",
			 },
		}
	},
	
	{ -- 3 	Hunter 	HUNTER
		{ -- 1	Beast Mastery
			 {
				spellID = 197162, -- Jaws of Thunder (Dire Frenzy Build - raiding)
				icon = "ability_thunderking_balllightning",
			 },
			 {
				spellID = 197080, -- Pack Leader
				icon = "ability_hunter_killcommand",
			 },
			 {
				spellID = 238051, -- Slithering Serpents
				icon = "ability_hunter_cobrashot",
			 },
		},
		
		{ -- 2	Marksmanship
			 {
				spellID = 238052, -- Unerring Arrows
				icon = "creatureportrait_blackrockv2_shieldgong_broken",
			 },
			 {
				spellID = 190457, -- Windrunner's Guidance
				icon = "ability_hunter_markedshot",
			 },
			 {
				spellID = 190520, -- Precision
				icon = "ability_hunter_zenarchery",
			 },
		},
		
		{ -- 3	Survival
			 {
				spellID = 203566, -- Sharpened Fang (single target)
				icon = "ability_hunter_mongoosebite",
			 },
			 {
				spellID = 203673, -- Hellcarver (multi target)
				icon = "ability_hunter_carve",
			 },
			 {
				spellID = 238053, -- Jaws of the Mongoose
				icon = "ability_hunter_mongoosebite",
			 },
			 {
				spellID = 203669, -- Fluffy, Go
				icon = "ability_mount_blackdirewolf",
			 },
		}
	},
	
	{ -- 4 	Rogue 	ROGUE
		{ -- 1	Assassination
			 {
				spellID = 192349, -- Master Assassin
				icon = "ability_rogue_deadliness",
			 },
			 {
				spellID = 192318, -- Master Alchemist
				icon = "trade_brewpoison",
			 },
			 {
				spellID = 192310, -- Toxic Blades
				icon = "ability_rogue_disembowel",
			 },
		},
		
		{ -- 2	Outlaw
			 {
				spellID = 202514, -- Fate's Thirst
				icon = "ability_rogue_waylay",
			 },
			 {
				spellID = 202907, -- Fortune's Boon
				icon = "ability_rogue_surpriseattack2",
			 },
			 {
				spellID = 202524, -- Fatebringer
				icon = "ability_rogue_cuttothechase",
			 },
		},
		
		{ -- 3	Subtletly
			 {
				spellID = 197234, -- Gutripper
				icon = "ability_rogue_eviscerate",
			 },
			 {
				spellID = 197239, -- Energetic Stabbing
				icon = "inv_knife_1h_pvppandarias3_c_02",
			 },
			 {
				spellID = 238068, -- Weak Point
				icon = "ability_criticalstrike",
			 },
		}
	},
	
	{ -- 5 	Priest 	PRIEST
		{ -- 1	Discipline
			 {
				spellID = 197708, -- Confession
				icon = "spell_holy_penance",
			 },
			 {
				spellID = 197715, -- The Edge of Dark and Light
				icon = "spell_shadow_shadowwordpain",
			 },
			 {
				spellID = 197729, -- Shield of Faith
				icon = "spell_holy_powerwordshield",
			 },
		},
		
		{ -- 2	Holy
			 {
				spellID = 196358, -- Say Your Prayers
				icon = "spell_holy_prayerofmendingtga",
			 },
			 {
				spellID = 196430, -- Words of Healing
				icon = "spell_holy_persecution",
			 },
			 {
				spellID = 196489, -- Power of the Naaru
				icon = "spell_holy_pureofheart",
			 },
			 {
				spellID = 196434, -- Holy Guidance		
				icon = "spell_holy_prayerofhealing02",
			 },	
		},
		
		{ -- 3	Shadow
			 {
				spellID = 238065, -- Fiending Dark
				icon = "spell_shadow_shadowfiend",
			 },
			 {
				spellID = 194002, -- Creeping Shadows 
				icon = "spell_priest_voidtendrils",
			 },
			 {
				spellID = 193644, -- To the Pain
				icon = "spell_shadow_shadowwordpain",
			 },
 			 {
				spellID = 194007, -- Touch of Darkness
				icon = "spell_shadow_chilltouch",
			 }, 
		}
	},
	
	{ -- 6 	Death Knight 	DEATHKNIGHT
		{ -- 1	Blood
			 {
				spellID = 238042, -- Carrion Feast
				icon = "spell_deathknight_butcher2",
			 },
			 {
				spellID = 192457, -- Veinrender
				icon = "ability_skeer_bloodletting",
			 },
			 {
				spellID = 192514, -- Dance of Darkness
				icon = "spell_shadow_rune",
			 },
		},
		
		{ -- 2	Frost
			 {
				spellID = 189080, -- Cold as Ice (All traits AoE)
				icon = "inv_misc_frostemblem_01",
			 },
			 {
				spellID = 189086, -- Blast Radius
				icon = "spell_mage_frostbomb",
			 },
			 {
				spellID = 189164, -- Dead of Winter
				icon = "ability_deathknight_remorselesswinters",
			 },
		},
		
		{ -- 3	Unholy
			 {
				spellID = 191485, -- Plaguebearer
				icon = "ability_creature_disease_02",
			 },
			 {
				spellID = 191488, -- The Darkest Crusade 
				icon = "spell_deathknight_vendetta",
			 },
			 {
				spellID = 191419, -- Deadliest Coil
				icon = "spell_shadow_deathcoil",
			 },
		}
	},
	
	{ -- 7 	Shaman 	SHAMAN
		{ -- 1	Elemental
			 {
				spellID = 238069, -- Elemental Destabilization
				icon = "spell_fire_volcano",
			 },
			 {
				spellID = 191504, -- Lava Imbued 
				icon = "spell_shaman_lavaburst",
			 },
			 {
				spellID = 191740, -- Firestorm
				icon = "spell_fire_flameshock",
			 },
		},
		
		{ -- 2	Enhancement
			 {
				spellID = 198292, -- Wind Strikes
				icon = "ability_skyreach_four_wind",
			 },
			 {
				spellID = 198247, -- Wind Surge 
				icon = "spell_shaman_unleashweapon_wind",
			 },
			 {
				spellID = 198349, -- Gathering of the Maelstrom
				icon = "spell_shaman_staticshock",
			 },
			 {
				spellID = 198236, -- Forged in Lava
				icon = "spell_shaman_improvelavalash",
			 },
		},
		
		{ -- 3	Restoration
			 {
				spellID = 207088, -- Tidal Chains (Dungeons)
				icon = "spell_frost_chainsofice",
			 },
			 {
				spellID = 207285, -- Queen Ascendant
				icon = "ability_shaman_watershield",
			 },
			 {
				spellID = 207092, -- Buffeting Waves 
				icon = "ability_skyreach_four_wind",
			 },
		}
	},
	
	{ -- 8 	Mage 	MAGE
		{ -- 1	Arcane
			 {
				spellID = 187276, -- Ethereal Sensitivity
				icon = "ability_socererking_arcanereplication",
			 },
			 {
				spellID = 187321, -- Aegwynn's Wrath 
				icon = "spell_arcane_arcanetorrent",
			 },
			 {
				spellID = 187258, -- Blasting Rod
				icon = "spell_arcane_blast",
			 },
		},
		
		{ -- 2	Fire
			 {
				spellID = 194314, -- Everburning Consumption
				icon = "ability_felarakkoa_feldetonation_red",
			 },
			 {
				spellID = 194312, -- Burning Gaze 
				icon = "inv_darkmoon_eye",
			 },
			 {
				spellID = 194239, -- Pyroclasmic Paranoia
				icon = "spell_fire_volcano",
			 },
		},
		
		{ -- 3	Frost
			 {
				spellID = 195322, -- Let It Go
				icon = "spell_frost_frostblast",
			 },
			 {
				spellID = 238056, -- Obsidian Lance 
				icon = "spell_frost_frostblast",
			 },
			 {
				spellID = 195345, -- Frozen Veins
				icon = "spell_frost_coldhearted",
			 },
		}
	},
	
	{ -- 9 	Warlock 	WARLOCK
		{ -- 1	Affliction
			 {
				spellID = 199158, -- Perdition
				icon = "6bf_blackrock_nova",
			 },
	 {
				spellID = 199163, -- Shadowy Incantations 
				icon = "inv_misc_volatileshadow",
			 },
		 {
				spellID = 238072, -- Winnowing
				icon = "sha_inv_misc_slime_01_nightmare",
			 },
		},
		
		{ -- 2	Demonology
			 {
				spellID = 211119, -- Infernal Furnace
				icon = "spell_fire_firebolt02",
			 },
			 {
				spellID = 211106, -- The Doom of Azeroth 
				icon = "spell_shadow_auraofdarkness",
			 },
			 {
				spellID = 211099, -- Maw of Shadows
				icon = "spell_shadow_shadowbolt",
			 },
		},
		
		{ -- 3	Destruction
			 {
				spellID = 196432, -- Burning Hunger
				icon = "spell_fire_immolation",
			 },
			 {
				spellID = 196227, -- Residual Flames 
				icon = "spell_fire_immolation",
			 },
			 {
				spellID = 196217, -- Chaotic Instability
				icon = "ability_warlock_chaosbolt",
			 },
		}
	},
	
	{ -- 10 	Monk 	MONK
		{ -- 1	Brewmaster
			 {
				spellID = 213116, -- Face Palm
				icon = "ability_monk_tigerpalm",
			 },
			 {
				spellID = 227683, -- Hot Blooded 
				icon = "ability_monk_breathoffire",
			 },
			 {
				spellID = 213047, -- Potent Kick
				icon = "ability_monk_ironskinbrew",
			 },
		},
		
		{ -- 2	Mistweaver
			 {
				spellID = 199485, -- Essence of the Mists
				icon = "ability_monk_essencefont",
			 },
			 {
				spellID = 199372, -- Extended Healing 
				icon = "ability_monk_renewingmists",
			 },
			 {
				spellID = 199380, -- Infusion of Life
				icon = "ability_monk_vivify",
			 },
		},
		
		{ -- 3	Windwalker
			 {
				spellID = 195291, -- Fists of the Wind
				icon = "ability_monk_jab",
			 },
			 {
				spellID = 195263, -- Rising Winds 
				icon = "ability_monk_risingsunkick",
			 },
			 {
				spellID = 195243, -- Inner Peace
				icon = "ability_monk_jasmineforcetea",
			 },
		}
	},

	{ -- 11 	Druid 	DRUID
		{ -- 1	Balance
			 {
				spellID = 202445, -- Falling Star (All traits AoE)
				icon = "spell_nature_starfall",
			 },
			 {
				spellID = 202386, -- Twilight Glow 
				icon = "spell_nature_moonglow",
			 },
			 {
				spellID = 202466, -- Sunfire Burns
				icon = "spell_druid_sunfall",
			 },
		},
		
		{ -- 2	Feral
			 {
				spellID = 210593, -- Tear the Flesh
				icon = "ability_druid_disembowel",
			 },
			 {
				spellID = 210579, -- Ashamane's Energy 
				icon = "ability_mount_jungletiger",
			 },
			 {
				spellID = 210571, -- Feral Power
				icon = "ability_druid_ravage",
			 },
		},
		
		{ -- 3	Guardian
			 {
				spellID = 200409, -- Jagged Claws (All traits AoE)
				icon = "inv_misc_monsterclaw_03",
			 },
			 {
				spellID = 200440, -- Vicious Bites 
				icon = "ability_druid_mangle2",
			 },
			 {
				spellID = 208762, -- Mauler
				icon = "ability_druid_maul",
			 },
		},
		
		{ -- 4	Restoration
			 {
				spellID = 186396, -- Persistence
				icon = "spell_nature_starfall",
			 },
			 {
				spellID = 189772, -- Knowledge of the Ancients 
				icon = "ability_druid_manatree",
			 },
			 {
				spellID = 186320, -- Grovewalker 
				icon = "spell_nature_healingtouch",
			 },
		}
	},
	
	{ -- 12 	Demon Hunter 	DEMONHUNTER
		{ -- 1	Havoc
			 {
				spellID = 201455, -- Critical Chaos
				icon = "ability_demonhunter_chaosstrike",
			 },
			 {
				spellID = 201460, -- Unleashed Demons 
				icon = "ability_demonhunter_metamorphasisdps",
			 },
			 {
				spellID = 201454, -- Contained Fury
				icon = "ability_warrior_improveddisciplines",
			 },
		},
		
		{ -- 2	Vengeance
			 {
				spellID = 212817, -- Fiery Demise
				icon = "ability_demonhunter_fierybrand",
			 },
			 {
				spellID = 212816, -- Embrace the Pain
				icon = "ability_demonhunter_metamorphasistank",
			 },
			 {
				spellID = 238046, -- Lingering Ordeal
				icon = "ability_demonhunter_metamorphasistank",
			 },
		}
	},
}


TotalAP.DB.RelicTraits = traitsByClass

return TotalAP.DB.RelicTraits
