local _, ns = ...

ns.ZoneNameSubstitutions = {
        ["The Temple of Atal'hakkar"] = { "Sunken Temple", },
        ["Temple of Ahn'Qiraj"] = { "Ahn'Qiraj", },
        ["Ruins of Ahn'Qiraj"] = { "Ahn'Qiraj", },
        ["Tanaan Jungle"] = { "Assault on the Dark Portal", },
        ["Lunarfall"] = { "Shadowmoon Valley", "Garrison", "Garrison Support", },
        ["Frostwall"] = { "Frostfire Ridge", "Garrison", "Garrison Support", },
        ["Thunder Totem"] = { "Highmountain", },
        -- ["Karazhan"] = "Karazhan [A] (Start)";
        -- ["Black Temple"] = "Black Temple [A] (Start)";
}


-- ns.InstanceTooltipName  = {

-- 	-------------
-- 	---Azeroth---
-- 	-------------

-- 	--Eastern Kingdoms
-- 	["Baradin Hold"] = true,
-- 	["Bastion of Twilight"] = true,
-- 	["Blackrock Caverns"] = true,
-- 	["Blackrock Depths Detention "] = true,
-- 	["Blackrock Depths Upper City"] = true,
-- 	["Blackwing Descent"] = true,
-- 	["Blackwing Lair"] = true,
-- 	["Deadmines"] = true,
-- 	["Gnomeregan"] = true,
-- 	["Grim Batol"] = true,
-- 	["Karazhan"] = true,
-- 	["Lower Blackrock Spire"] = true,
-- 	["Magisters' Terrace"] = true,
-- 	["Molten Core"] = true,
-- 	["Scarlet Halls"] = true,
-- 	["Scarlet Monastery"] = true,
-- 	["Scholomance"] = true,
-- 	["Shadowfang Keep"] = true,
-- 	["Stormwind Stockade"] = true,
-- 	["Stratholme Main Gate"] = true,
-- 	["Stratholme Service Entrance"] = true,
-- 	["Sunwell Plateau"] = true,
-- 	["Temple of Atal'Hakkar"] = true,
-- 	["Throne of the Tides"] = true,
-- 	["Uldaman"] = true,
-- 	["Upper Blackrock Spire"] = true,
-- 	["Zul'Aman"] = true,
-- 	["Zul'Gurub"] = true,

-- 	--Kalimdor
-- 	["Ragefire Chasm"] = true,
-- 	["Wailing Caverns"] = true,
-- 	["Blackfathom Deeps"] = true,
-- 	["Razorfen Kraul"] = true,
-- 	["Maraudon Purple Crystals"] = true,
-- 	["Maraudon Orange Crystals"] = true,
-- 	["Maraudon Pristine Waters"] = true,
-- 	["Dire Maul Warpwood "] = true,
-- 	["Dire Maul Capital Gardens"] = true,
-- 	["Razorfen Downs"] = true,
-- 	["Dire Maul Gordok Commons"] = true,
-- 	["Zul'Farrak"] = true,
-- 	["Ruins of Ahn'Qiraj"] = true,
-- 	["Temple of Ahn'Qiraj"] = true,
-- 	["Escape from Durnholde Kee"] = true,
-- 	["Opening the Dark Portal"] = true,
-- 	["Battle for Mount Hyjal"] = true,
-- 	["Culling of Stratholme"] = true,
-- 	["Onyxia's Lair"] = true,
-- 	["Vortex Pinnacle"] = true,
-- 	["Halls of Origination"] = true,
-- 	["Lost City of the Tol'vir"] = true,
-- 	["Throne of the Four Winds"] = true,
-- 	["Firelands"] = true,
-- 	["End Time"] = true,
-- 	["Well of Eternity"] = true,
-- 	["Hour of Twilight"] = true,
-- 	["Dragon Soul"] = true,

-- 	--Maelstrom
-- 	["Stonecore"] = true,

-- 	--Northrend
-- 	["Utgarde Keep"] = true,
-- 	["The Nexus"] = true,
-- 	["Azjol-Nerub"] = true,
-- 	["Ahn'kahet: The Old Kingdom"] = true,
-- 	["Drak'Tharon Keep"] = true,
-- 	["Violet Hold"] = true,
-- 	["Gundrak"] = true,
-- 	["Halls of Stone"] = true,
-- 	["Utgarde Pinnacle"] = true,
-- 	["Oculus"] = true,
-- 	["Halls of Lightning"] = true,
-- 	["Trial of the Champion"] = true,
-- 	["Forge of Souls"] = true,
-- 	["Pit of Saron"] = true,
-- 	["Halls of Reflection"] = true,
-- 	["Naxxramas"] = true,
-- 	["Obsidian Sanctum"] = true,
-- 	["Eye of Eternity"] = true,
-- 	["Vault of Archavon"] = true,
-- 	["Ulduar"] = true,
-- 	["Trial of the Crusader"] = true,
-- 	["Ruby Sanctum"] = true,
-- 	["Icecrown Citadel"] = true,

-- 	--Pandaria
-- 	["Temple of the Jade Serpent"] = true,
-- 	["Stormstout Brewery"] = true,
-- 	["Shado-Pan Monastery"] = true,
-- 	["Mogu'shan Palace"] = true,
-- 	["Gate of the Setting Sun"] = true,
-- 	["Siege of Niuzao Temple"] = true,
-- 	["Mogu'shan Vaults"] = true,
-- 	["Heart of Fear"] = true,
-- 	["Terrace of Endless Spring"] = true,
-- 	["Throne of Thunder"] = true,
-- 	["Siege of Orgrimmar"] = true,

-- 	--Broken Isles
-- 	["Assault on Violet Hold"] = true,
-- 	["Black Rook Hold"] = true,
-- 	["Court of Stars"] = true,
-- 	["Darkheart Thicket"] = true,
-- 	["Eye of Azshara"] = true,
-- 	["Halls of Valor"] = true,
-- 	["Maw of Souls"] = true,
-- 	["Neltharion's Lair"] = true,
-- 	["The Arcway"] = true,
-- 	["Vault of the Wardens"] = true,
-- 	["The Emerald Nightmare"] = true,
-- 	["The Nighthold"] = true,

-- 	-------------
-- 	---Outland---
-- 	-------------

-- 	["Hellfire Ramparts"] = true,
-- 	["Blood Furnace"] = true,
-- 	["The Slave Pens"] = true,
-- 	["The Underbog"] = true,
-- 	["Mana-Tombs"] = true,
-- 	["Auchenai Crypts"] = true,
-- 	["Sethekk Halls"] = true,
-- 	["Steamvault"] = true,
-- 	["Shadow Labyrinth"] = true,
-- 	["Mechanar"] = true,
-- 	["Botanica"] = true,
-- 	["Shattered Halls"] = true,
-- 	["Arcatraz"] = true,
-- 	["Gruul's Lair"] = true,
-- 	["Magtheridon's Lair"] = true,
-- 	["Serpentshrine Cavern"] = true,
-- 	["The Eye"] = true,
-- 	["Black Temple"] = true,

-- 	-------------
-- 	---Draenor---
-- 	-------------

-- 	["Bloodmaul Slag Mines"] = true,
-- 	["Iron Docks"] = true,
-- 	["Auchindoun"] = true,
-- 	["Skyreach"] = true,
-- 	["Grimrail Depot"] = true,
-- 	["Shadowmoon Burial Grounds"] = true,
-- 	["The Everbloom"] = true,
-- 	["Highmaul"] = true,
-- 	["Blackrock Foundry"] = true,
-- 	["Hellfire Citadel"] = true,
-- }

