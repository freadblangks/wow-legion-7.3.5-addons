--------------------------------------------------------------------------------------------------------------------------------------------
-- Initialize Variables
--------------------------------------------------------------------------------------------------------------------------------------------
local NS = select( 2, ... );
local L = NS.localization;
NS.versionString = "2.06";
NS.version = tonumber( NS.versionString );
--
NS.options = {};
--
NS.initialized = false;
NS.realmName = GetRealmName();
NS.playerLoginMsg = {};
NS.AuctionFrameTab = nil;
NS.scan = {};
NS.modes = { "MOUNTS", "PETS", "TOYS", "APPEARANCES" };
NS.modeNames = { L["Mounts"], L["Pets"], L["Toys"], L["Appearances"] };
NS.modeNums = { [NS.modes[1]] = 1, [NS.modes[2]] = 2, [NS.modes[3]] = 3, [NS.modes[4]] = 4 };
NS.modeColorCodes = { ITEM_QUALITY_COLORS[6].hex, ITEM_QUALITY_COLORS[5].hex, "|cff66bbff", "|c" .. TRANSMOGRIFY_FONT_COLOR:GenerateHexColor() };
NS.modeFilters = {};
NS.modeFiltersFlyout = {};
NS.mode = nil;
NS.modeName = nil;
NS.modeColorCode = nil;
--
NS.mountCollection = {};
NS.petCollection = {};
NS.toyCollection = {};
NS.appearanceCollection = {
	categoryNames = {},
	appearances = {},
	sources = {},
	getAllReady = false,
};
NS.shopAppearancesBy = nil; -- appearance, source
--
NS.auction = {
	data = {
		live = {
			itemIds = {},
			appearanceSources = {},
		},
		groups = {},
		sortKey = nil,
		sortOrder = nil,
	},
};
NS.linkLevel = nil;
NS.linkSpecID = nil;
NS.numAuctionsWon = 0;
NS.copperAuctionsWon = 0;
NS.auctionsWon = {};
--
NS.adjustScrollFrame = true;
NS.isPctItemValue = nil; -- Set in ScrollFrame:Adjust()
NS.tsmPriceSources = nil;
NS.NextAdjustScroll = false;
NS.disableFlyoutChecks = false;
NS.buyAll = false;
NS.invTypeToSlotId = {
    ['INVTYPE_HEAD'] = 1,
    ['INVTYPE_SHOULDER'] = 3,
    ['INVTYPE_CLOAK'] = 15,
    ['INVTYPE_CHEST'] = 5,
    ['INVTYPE_ROBE'] = 5,
    ['INVTYPE_BODY'] = 4,
    ['INVTYPE_TABARD'] = 19,
    ['INVTYPE_WRIST'] = 9,
    ['INVTYPE_HAND'] = 10,
    ['INVTYPE_WAIST'] = 6,
    ['INVTYPE_LEGS'] = 7,
    ['INVTYPE_FEET'] = 8,
    ['INVTYPE_WEAPON'] = 16,
	['INVTYPE_WEAPONMAINHAND'] = 16,
	['INVTYPE_2HWEAPON'] = 16,
	['INVTYPE_RANGED'] = 16,
	['INVTYPE_RANGEDRIGHT'] = 16,
    ['INVTYPE_WEAPONOFFHAND'] = 17,
	['INVTYPE_SHIELD'] = 17,
    ['INVTYPE_HOLDABLE'] = 17,
};
NS.craftingProfessions = { 2259,2018,7411,4036,45357,25229,2108,3908 };
for i = 1, #NS.craftingProfessions do
	NS.craftingProfessions[i] = GetSpellInfo( NS.craftingProfessions[i] );
end
NS.ridingSpells = { 90265,34091,34090,33391,33388 };
for i = 1, #NS.ridingSpells do
	NS.ridingSpells[i] = GetSpellInfo( NS.ridingSpells[i] );
end
NS.cachedDressUpIds = {};
NS.mountInfo = {
	-- As of 08/31/2017
	--[mountItemId] = { displayID, spellID }, -- creatureName -- itemName
	[71718] = { 17011, 101573 }, -- Swift Shorestrider -- Swift Shorestrider
	[52200] = { 25279, 73313 }, -- Crimson Deathcharger -- Reins of the Crimson Deathcharger
	[34060] = { 22719, 44153 }, -- Flying Machine -- Flying Machine
	[79771] = { 40568, 113120 }, -- Feldrake -- Feldrake
	[128671] = { 64960, 191314 }, -- Minion of Grumpus -- Minion of Grumpus
	[41508] = { 25871, 55531 }, -- Mechano-Hog -- Mechano-Hog
	[82453] = { 42185, 120043 }, -- Jeweled Onyx Panther -- Jeweled Onyx Panther
	[83087] = { 42499, 121838 }, -- Ruby Panther -- Ruby Panther
	[72582] = { 38972, 102514 }, -- Corrupted Hippogryph -- Corrupted Hippogryph
	[72145] = { 16992, 102349 }, -- Swift Springstrider -- Swift Springstrider
	[54069] = { 31803, 74856 }, -- Blazing Hippogryph -- Blazing Hippogryph
	[49283] = { 21973, 42776 }, -- Spectral Tiger -- Reins of the Spectral Tiger
	[49285] = { 23656, 46197 }, -- X-51 Nether-Rocket -- X-51 Nether-Rocket
	[95416] = { 46686, 134359 }, -- Sky Golem -- Sky Golem
	[69228] = { 38048, 97581 }, -- Savage Raptor -- Savage Raptor
	[87250] = { 43637, 126507 }, -- Depleted-Kyparium Rocket -- Depleted-Kyparium Rocket
	[72575] = { 37204, 102488 }, -- White Riding Camel -- White Riding Camel
	[34061] = { 22720, 44151 }, -- Turbo--Charged Flying Machine -- Turbo-Charged Flying Machine
	[72146] = { 1961, 102350 }, -- Swift Lovebird -- Swift Lovebird
	[83088] = { 42502, 121837 }, -- Jade Panther -- Jade Panther
	[128311] = { 64426, 189364 }, -- Coalfist Gronnling -- Coalfist Gronnling
	[116794] = { 54114, 171851 }, -- Garn Nighthowl -- Garn Nighthowl
	[68008] = { 37231, 93623 }, -- Mottled Drake -- Mottled Drake
	[93671] = { 48014, 136505 }, -- Ghastly Charger -- Ghastly Charger's Skull
	[65891] = { 35750, 93326 }, -- Sandstone Drake -- Vial of the Sands
	[44413] = { 25870, 60424 }, -- Mekgineer's Chopper -- Mekgineer's Chopper
	[49286] = { 23647, 46199 }, -- X-51 Nether-Rocket X-TREME -- X-51 Nether-Rocket X-TREME
	[68825] = { 37800, 96503 }, -- Amani Dragonhawk -- Amani Dragonhawk
	[83089] = { 42501, 121839 }, -- Sunstone Panther -- Sunstone Panther
	[87251] = { 43638, 126508 }, -- Geosynchronous World Spinner -- Geosynchronous World Spinner
	[137686] = { 70099, 213209 }, -- Steelbound Devourer -- Steelbound Harness
	[44554] = { 28082, 61451 }, -- Flying Carpet -- Flying Carpet
	[83090] = { 42500, 121836 }, -- Sapphire Panther -- Sapphire Panther
	[54068] = { 31721, 74918 }, -- Wooly White Rhino -- Wooly White Rhino
	[49282] = {	25335, 51412 }, -- Big Battle Bear -- Big Battle Bear
	[49284] = { 21974, 42777 }, -- Swift Spectral Tiger -- Reins of the Swift Spectral Tiger
	[67151] = { 34955, 98718 }, -- Subdued Seahorse -- Reins of Poseidus
	[49290] = { 34655, 65917 }, -- Magic Rooster -- Magic Rooster Egg
};
NS.petInfo = {
	-- As of 08/31/2017
	--[companionPetItemId] = { speciesID, creatureID }, -- itemName
	[151645] = { 2001, 117340 }, -- Model D1-BB-L3R
	[151269] = { 2002, 117341 }, -- Naxxy
	[151569] = { 2063, 124389 }, -- Sneaky Marmot
	[151633] = { 2065, 124594 }, -- Dig Rat
	[142448] = { 1984, 116080 }, -- Albino Buzzard
	[141532] = { 1943, 33975 }, -- Noblegarden Bunny
	[116403] = { 1516, 85846 }, -- Bush Chicken
	[116439] = { 1517, 85872 }, -- Blazing Cindercrawler
	[116756] = { 1518, 85994 }, -- Stout Alemental
	[89587] = { 381, 61086 }, -- Porcupette
	[116801] = { 1521, 86061 }, -- Cursed Birman
	[116804] = { 1523, 86067 }, -- Widget the Departed
	[8485] = { 40, 7385 }, -- Bombay Cat
	[10822] = { 56, 7543 }, -- Dark Whelpling
	[11027] = { 64, 7550 }, -- Wood Frog
	[70908] = { 319, 53884 }, -- Feline Familiar
	[23083] = { 128, 16701 }, -- Spirit of Summer
	[46398] = { 224, 34364 }, -- Calico Cat
	[101570] = { 1276, 72160 }, -- Moon Moon
	[117528] = { 1533, 86532 }, -- Lanticore Spawnling
	[118101] = { 1536, 86715 }, -- Zangar Spore
	[118105] = { 1539, 86718 }, -- Seaborne Spore
	[11026] = { 65, 7549 }, -- Tree Frog
	[33154] = { 162, 23909 }, -- Sinister Squashling
	[39896] = { 194, 32589 }, -- Tickbird Hatchling
	[130167] = { 1803, 99389 }, -- Thistleleaf Adventurer
	[90900] = { 1039, 67230 }, -- Imperial Moth
	[90902] = { 1040, 67233 }, -- Imperial Silkworm
	[85220] = { 650, 63365 }, -- Terrible Turnip
	[39899] = { 195, 32590 }, -- White Tickbird Hatchling
	[60216] = { 262, 43916 }, -- De-Weaponized Mechanical Companion
	[8486] = { 41, 7384 }, -- Cornish Rex Cat
	[8494] = { 49, 7391 }, -- Hyacinth Macaw
	[34535] = { 57, 7547 }, -- Azure Whelpling
	[20769] = { 114, 15429 }, -- Disgusting Oozeling
	[44721] = { 196, 32592 }, -- Proto-Drake Whelp
	[118675] = { 1563, 7546 }, -- Bronze Whelpling
	[118741] = { 1565, 88134 }, -- Mechanical Scorpid
	[118921] = { 1566, 88222 }, -- Everbloom Peachick
	[118923] = { 1567, 88225 }, -- Sentinel's Companion
	[46821] = { 229, 34724 }, -- Shimmering Wyrmling (Horde)
	[46820] = { 229, 34724 }, -- Shimmering Wyrmling (Alliance)
	[91003] = { 1061, 67319 }, -- Darkmoon Hatchling
	[91040] = { 1063, 67332 }, -- Darkmoon Eye
	[67274] = { 267, 46898 }, -- Enchanted Lantern
	[127704] = { 1577, 88514 }, -- Bloodthorn Hatchling
	[88148] = { 792, 65314 }, -- Jade Crane Chick
	[127703] = { 1588, 88415 }, -- Dusty Sporewing
	[8491] = { 42, 7383 }, -- Black Tabby Cat
	[8492] = { 50, 7387 }, -- Green Wing Macaw
	[8499] = { 58, 7544 }, -- Crimson Whelpling
	[8500] = { 68, 7553 }, -- Great Horned Owl
	[21277] = { 116, 15699 }, -- Tranquil Mechanical Yeti
	[29363] = { 136, 20408 }, -- Mana Wyrmling
	[44794] = { 200, 32791 }, -- Spring Rabbit
	[48112] = { 232, 35396 }, -- Darting Hatchling
	[127701] = { 1598, 88575 }, -- Glowing Sporebat
	[104202] = { 1343, 73668 }, -- Bonkers
	[29364] = { 137, 20472 }, -- Brown Rabbit
	[48114] = { 233, 35395 }, -- Deviate Hatchling
	[104317] = { 1349, 73741 }, -- Rotten Little Helper
	[21309] = { 117, 15710 }, -- Tiny Snowman
	[29901] = { 138, 21010 }, -- Blue Moth
	[48116] = { 234, 35400 }, -- Gundrak Hatchling
	[74610] = { 341, 55571 }, -- Lunar Lantern
	[29902] = { 139, 21009 }, -- Red Moth
	[48118] = { 235, 35387 }, -- Leaping Hatchling
	[74611] = { 342, 55574 }, -- Festival Lantern
	[8487] = { 43, 7382 }, -- Orange Tabby Cat
	[8498] = { 59, 7545 }, -- Emerald Whelpling
	[21308] = { 118, 15706 }, -- Winter Reindeer
	[48120] = { 236, 35399 }, -- Obsidian Hatchling
	[132519] = { 1886, 106210 }, -- Trigger
	[136921] = { 1886, 106210 }, -- Trigger
	[136924] = { 1889, 106278 }, -- Felbat Pup
	[44970] = { 205, 33194 }, -- Dun Morogh Cub
	[48122] = { 237, 35397 }, -- Ravasaur Hatchling
	[29953] = { 142, 21055 }, -- Golden Dragonhawk Hatchling
	[111660] = { 1387, 77221 }, -- Iron Starlette
	[29956] = { 143, 21064 }, -- Red Dragonhawk Hatchling
	[44973] = { 207, 33198 }, -- Durotar Scorpion
	[48126] = { 239, 35394 }, -- Razzashi Hatchling
	[8490] = { 44, 7380 }, -- Siamese Cat
	[8497] = { 72, 7560 }, -- Snowshoe Rabbit
	[138810] = { 1911, 109216 }, -- Sting Ray Pup
	[21305] = { 120, 15705 }, -- Winter's Little Helper
	[29957] = { 144, 21063 }, -- Silver Dragonhawk Hatchling
	[111402] = { 1403, 79410 }, -- Mechanical Axebeak
	[127748] = { 1662, 93143 }, -- Cinder Pup
	[127753] = { 1664, 93483 }, -- Nightmare Bell
	[112057] = { 1412, 80329 }, -- Lifelike Mechanical Frostboar
	[127749] = { 1672, 94623 }, -- Corrupted Nest Guardian
	[29960] = { 146, 21076 }, -- Firefly
	[44980] = { 210, 33219 }, -- Mulgore Hatchling
	[67275] = { 292, 50545 }, -- Magic Lamp
	[29904] = { 141, 21018 }, -- White Moth
	[67282] = { 293, 50722 }, -- Elementium Geode
	[29903] = { 140, 21008 }, -- Yellow Moth
	[113569] = { 1429, 83584 }, -- Autumnal Sproutling
	[87526] = { 844, 64899 }, -- Mechanical Pandaren Dragonling
	[127856] = { 1687, 94867 }, -- Left Shark
	[118595] = { 1432, 83594 }, -- Nightshade Sproutling
	[127868] = { 1688, 94927 }, -- Crusher
	[22235] = { 122, 16085 }, -- Peddlefeet
	[44984] = { 212, 33205 }, -- Ammen Vale Lashling
	[94573] = { 1205, 70154 }, -- Direhorn Runt
	[44971] = { 206, 33197 }, -- Tirisfal Batling
	[80008] = { 848, 59358 }, -- Darkmoon Rabbit
	[94935] = { 1209, 70260 }, -- Tiny White Carp
	[94190] = { 1185, 69848 }, -- Spectral Porcupette
	[94932] = { 1206, 70257 }, -- Tiny Red Carp
	[94934] = { 1208, 70259 }, -- Tiny Green Carp
	[44982] = { 213, 33227 }, -- Enchanted Broom
	[85447] = { 652, 63559 }, -- Tiny Goldfish
	[128533] = { 1699, 96403 }, -- Enchanted Cauldron
	[128534] = { 1700, 96404 }, -- Enchanted Torch
	[128535] = { 1701, 96405 }, -- Enchanted Pen
	[44965] = { 204, 33188 }, -- Teldrassil Sproutling
	[10360] = { 75, 7565 }, -- Black Kingsnake
	[82775] = { 846, 61883 }, -- Sapphire Cub
	[94574] = { 1200, 70083 }, -- Pygmy Direhorn
	[94595] = { 1201, 70098 }, -- Spawn of G'nathus
	[45002] = { 215, 33274 }, -- Mechanopeep
	[8489] = { 46, 7386 }, -- White Kitten
	[94933] = { 1207, 70258 }, -- Tiny Blue Carp
	[45606] = { 218, 33810 }, -- Sen'jin Fetish
	[128770] = { 1725, 97229 }, -- Grumpling
	[48124] = { 238, 35398 }, -- Razormaw Hatchling
	[130154] = { 1907, 108568 }, -- Pygmy Owl
	[72068] = { 311, 53283 }, -- Guardian Cub
	[46707] = { 166, 24753 }, -- Pint-Sized Pink Pachyderm
	[94903] = { 1204, 70082 }, -- Pierre
	[11825] = { 85, 9656 }, -- Pet Bombling
	[59597] = { 261, 43800 }, -- Personal World Destroyer
	[69239] = { 306, 52831 }, -- Winterspring Cub
	[82774] = { 845, 61877 }, -- Jade Owl
	[116064] = { 1478, 85527 }, -- Syd the Squid
	[8501] = { 67, 7555 }, -- Hawk Owl
	[10361] = { 77, 7562 }, -- Brown Snake
	[11826] = { 86, 9657 }, -- Lil' Smoky
	[8488] = { 45, 7381 }, -- Silver Tabby Cat
	[8495] = { 51, 7389 }, -- Senegal
	[29958] = { 145, 21056 }, -- Blue Dragonhawk Hatchling
	[10394] = { 70, 14421 }, -- Brown Prairie Dog
	[44822] = { 74, 7561 }, -- Albino Snake
	[117404] = { 115, 86445 }, -- Land Shark
	[4401] = { 39, 2671 }, -- Mechanical Squirrel
	[8496] = { 47, 7390 }, -- Cockatiel
	[10393] = { 55, 7395 }, -- Undercity Cockroach
	[118919] = { 1495, 85667 }, -- Ore Eater
	[10392] = { 78, 7567 }, -- Crimson Snake
	[127705] = { 1661, 93142 }, -- Lost Netherpup
	[21301] = { 119, 15698 }, -- Father Winter's Helper
	[127754] = { 1663, 93352 }, -- Periwinkle Calf
	[126926] = { 1665, 93808 }, -- Ghostshell Crab
	[11023] = { 52, 7394 }, -- Ancona Chicken
	[129216] = { 1764, 98236 }, -- Energized Manafiend
	[44974] = { 209, 33200 }, -- Elwynn Lamb
	[129218] = { 1765, 98238 }, -- Empyreal Manafiend
	[39898] = { 197, 32591 }, -- Cobra Hatchling
	[129217] = { 1766, 98237 }, -- Empowered Manafiend
	[116155] = { 1511, 85710 }, -- Lovebird Hatchling
	[100905] = { 1256, 71693 }, -- Rascal-Bot
	[15996] = { 95, 12419 }, -- Lifelike Toad
	[140323] = { 1930, 112167 }, -- Lagan
	[89368] = { 849, 66104 }, -- Chi-Ji Kite
	[10398] = { 83, 8376 }, -- Mechanical Chicken
	[88147] = { 820, 64232 }, -- Singing Cricket
	[126925] = { 1666, 93814 }, -- Blorp
	[141348] = { 1937, 113827 }, -- Wonderous Wisdomball
	[91031] = { 1062, 67329 }, -- Darkmoon Glowfly
	[140761] = { 1933, 112945 }, -- Nightmare Treant
	[94191] = { 1184, 69849 }, -- Stunted Direhorn
	[89367] = { 850, 66105 }, -- Yu'lon Kite
	[143756] = { 1998, 117180 }, -- Everliving Spore
	[143754] = { 1999, 117182 }, -- Cavern Moccasin
	[143755] = { 2000, 117184 }, -- Young Venomfang
	[146953] = { 2042, 120397 }, -- Scraps
};
NS.toyInfo = {
	-- As of 08/31/2017
	--[toyItemId] = { catNum, subCatNum }, -- itemName
	[151652] = { 6, 1 }, -- Wormhole Generator: Argus
	[144393] = { 12, 4 }, -- Portable Yak Wash
	[142265] = { 12, 4 }, -- Big Red Raygun
	[122681] = { 12, 4 }, -- Sternfathom's Pet Journal
	[129956] = { 12, 4 }, -- Leather Love Seat
	[130157] = { 12, 4 }, -- Syxsehnz Rod
	[130169] = { 12, 4 }, -- Tournament Favor
	[130171] = { 12, 4 }, -- Cursed Orb
	[130191] = { 12, 4 }, -- Trapped Treasure Chest Kit
	[130214] = { 12, 4 }, -- Worn Doll
	[130232] = { 12, 4 }, -- Moonfeather Statue
	[130251] = { 6, 8 }, -- JewelCraft
	[130254] = { 12, 4 }, -- Chatterstone
	[132518] = { 6, 1 }, -- Blingtron's Circuit Design Tutorial
	[109167] = { 6, 1 }, -- Findle's Loot-A-Rang
	[112059] = { 6, 1 }, -- Wormhole Centrifuge
	[128536] = { 12, 4 }, -- Leylight Brazier
	[128807] = { 12, 4 }, -- Coin of Many Faces
	[87215] = { 6, 1 }, -- Wormhole Generator: Pandaria
	[88531] = { 6, 5 }, -- Lao Chin's Last Mug
	[108739] = { 12, 1 }, -- Pretty Draenor Pearl
	[40727] = { 6, 1 }, -- Gnomish Gravity Well
	[60854] = { 6, 1 }, -- Loot-A-Rang
	[134007] = { 12, 4 }, -- Eternal Black Diamond Ring
	[40768] = { 6, 1 }, -- MOLL-E
	[45984] = { 12, 4 }, -- Unusual Compass
	[48933] = { 6, 1 }, -- Wormhole Generator: Northrend
	[52201] = { 12, 4 }, -- Muradin's Favor
	[52253] = { 12, 4 }, -- Sylvanas' Music Box
	[30542] = { 6, 1 }, -- Dimensional Ripper - Area 52
	[30544] = { 6, 1 }, -- Ultrasafe Transporter: Toshley's Station
	[18984] = { 6, 1 }, -- Dimensional Ripper - Everlook
	[18986] = { 6, 1 }, -- Ultrasafe Transporter: Gadgetzan
	[23767] = { 6, 1 }, -- Crashin' Thrashin' Robot
	[108631] = { 12, 3 }, -- Crashin' Thrashin' Roller Controller
	[108633] = { 12, 3 }, -- Crashin' Thrashin' Cannon Controller
	[108634] = { 12, 3 }, -- Crashin' Thrashin' Mortar Controller
	[108635] = { 12, 3 }, -- Crashin' Thrashin' Killdozer Controller
	[17716] = { 6, 1 }, -- Snowmaster 9000
	[140363] = { 12, 4 }, -- Pocket Fel Spreader
	[1973] = { 12, 4 }, -- Orb of Deception
	[18660] = { 6, 1 }, -- World Enlarger
	[36862] = { 6, 8 }, -- Worn Troll Dice
	[36863] = { 6, 8 }, -- Decahedral Dwarven Dice
	[63269] = { 6, 8 }, -- Loaded Gnomish Dice
	[71628] = { 6, 8 }, -- Sack of Starfish
	[101571] = { 6, 8 }, -- Moonfang Shroud
	[105898] = { 6, 8 }, -- Moonfang's Paw
	[108745] = { 6, 1 }, -- Personal Hologram
	[109183] = { 6, 1 }, -- World Shrinker
	[116689] = { 12, 3 }, -- Pineapple Lounge Cushion
	[116690] = { 12, 3 }, -- Safari Lounge Cushion
	[116691] = { 12, 3 }, -- Zhevra Lounge Cushion
	[116692] = { 12, 3 }, -- Fuzzy Green Lounge Cushion
	[118427] = { 12, 4 }, -- Autographed Hearthstone Card
	[119210] = { 6, 8 }, -- Hearthstone Board
	[119212] = { 6, 8 }, -- Winning Hand
	[127695] = { 12, 4 }, -- Spirit Wand
	[127707] = { 12, 4 }, -- Indestructible Bone
	[128310] = { 12, 1 }, -- Burning Blade
	[128794] = { 12, 4 }, -- Sack of Spectral Spiders
	[129211] = { 6, 8 }, -- Steamy Romance Novel Kit
	[129958] = { 10, 11 }, -- Leather Pet Leash
	[129960] = { 10, 11 }, -- Leather Pet Bed
	[129961] = { 10, 11 }, -- Flaming Hoop
};
NS.mountItemIds = {};
NS.petItemIds = { 82800 };
NS.toyItemIds = {};
NS.appearanceItemIds = {};
for k, v in pairs( NS.mountInfo ) do
	NS.mountItemIds[#NS.mountItemIds + 1] = k;
end
for k, v in pairs( NS.petInfo ) do
	NS.petItemIds[#NS.petItemIds + 1] = k;
end
for k, v in pairs( NS.toyInfo ) do
	NS.toyItemIds[#NS.toyItemIds + 1] = k;
end
NS.TRANSMOGRIFY_FONT_COLOR_CODE = "|c" .. TRANSMOGRIFY_FONT_COLOR:GenerateHexColor();
if not ITEM_QUALITY_COLORS[-1] then
	ITEM_QUALITY_COLORS[-1] = { hex="|cff9d9d9d", r=0, g=0, b=0 };
end
NS.SELECT_AN_AUCTION = function()
	return string.format( L["Select an auction to buy or click \"Buy All\""] .. ( NS.mode == "APPEARANCES" and "\n" .. L["%sEach result is the lowest buyout auction for an|r %s"] or "" ), HIGHLIGHT_FONT_COLOR_CODE, NS.modeColorCode .. ( NS.shopAppearancesBy == "appearance" and L["Appearance"] or L["Appearance Source"] ) .. FONT_COLOR_CODE_CLOSE );
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Default SavedVariables/PerCharacter & Upgrade
--------------------------------------------------------------------------------------------------------------------------------------------
NS.DefaultSavedVariables = function()
	return {
		["version"] = NS.version,
		["getAllScan"] = {},
		["flyoutPanelOpen"] = true,
		["undressCharacter"] = true,
		["live"] = false,
		["auctionsWonReminder"] = true,
		["maxItemPriceCopper"] = { [NS.modes[1]] = 0, [NS.modes[2]] = 0, [NS.modes[3]] = 0, [NS.modes[4]] = 0 },
		["tsmItemValueSource"] = "",
		["modeFilters"] = { [NS.modes[1]] = {}, [NS.modes[2]] = {}, [NS.modes[3]] = {}, [NS.modes[4]] = {} },
	};
end
--
NS.DefaultSavedVariablesPerCharacter = function()
	return {
		["version"] = NS.version,
	};
end
--
NS.Upgrade = function()
	local vars = NS.DefaultSavedVariables();
	local version = NS.db["version"];
	-- 1.05
	if version < 1.05 then
		NS.db["tsmItemValueSource"] = vars["tsmItemValueSource"]; -- New db variable
	end
	-- 2.0
	if version < 2.0 then
		wipe( NS.db["getAllScan"] ); -- New data structure and information requirements
	end
	--
	NS.db["version"] = NS.version;
end
--
NS.UpgradePerCharacter = function()
	local varspercharacter = NS.DefaultSavedVariablesPerCharacter();
	local version = NS.dbpc["version"];
	-- X.xx
	--if version < X.xx then
		-- Do upgrade
	--end
	--
	NS.dbpc["version"] = NS.version;
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- AuctionFrameTab / SideDressUpModel
--------------------------------------------------------------------------------------------------------------------------------------------
NS.AuctionFrameTab_OnClick = function( self, button, down, index ) -- AuctionFrameTab_OnClick
	if NS.AuctionFrameTab:GetID() == self:GetID() then
		AuctionFrameTopLeft:SetTexture( "Interface\\AuctionFrame\\UI-AuctionFrame-Bid-TopLeft" );
		AuctionFrameTop:SetTexture( "Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Top" );
		AuctionFrameTopRight:SetTexture( "Interface\\AuctionFrame\\UI-AuctionFrame-Auction-TopRight" );
		AuctionFrameBotLeft:SetTexture( "Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotLeft" );
		AuctionFrameBot:SetTexture( "Interface\\AuctionFrame\\UI-AuctionFrame-Auction-Bot" );
		AuctionFrameBotRight:SetTexture( "Interface\\AuctionFrame\\UI-AuctionFrame-Bid-BotRight" );
		AuctionFrameMoneyFrame:Show();
		AuctionFrameCollectionShop:Show();
		--
		NS.linkLevel = UnitLevel( "player" );
		CollectionShopEventsFrame:RegisterEvent( "PLAYER_SPECIALIZATION_CHANGED" );
		CollectionShopEventsFrame:RegisterEvent( "INSPECT_READY" );
		CollectionShopEventsFrame:RegisterEvent( "UI_ERROR_MESSAGE" );
		NotifyInspect( "player" );
	elseif AuctionFrameCollectionShop:IsShown() then
		AuctionFrameCollectionShop:Hide();
	end
end
--
NS.IsTabShown = function()
	if AuctionFrameCollectionShop and AuctionFrame:IsShown() and PanelTemplates_GetSelectedTab( AuctionFrame ) == NS.AuctionFrameTab:GetID() then
		return true;
	else
		return false;
	end
end
--
NS.SideDressUpModelCloseButton_OnClick = function()
	if AuctionFrameCollectionShop and AuctionFrameCollectionShop:IsShown() then
		AuctionFrameCollectionShop_FlyoutPanel:Reset();
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- AuctionFrameCollectionShop
--------------------------------------------------------------------------------------------------------------------------------------------
NS.Reset = function( filterOnClick )
	CollectionShopEventsFrame:UnregisterEvent( "CHAT_MSG_SYSTEM" );
	NS.scan:Reset(); -- Also Unregisters AUCTION_ITEM_LIST_UPDATE
	wipe( NS.auction.data.live.itemIds );
	wipe( NS.auction.data.live.appearanceSources );
	wipe( NS.auction.data.groups );
	NS.disableFlyoutChecks = false;
	NS.buyAll = false;
	if AuctionFrame and not NS.IsTabShown() then -- Stop monitoring spec and UI errors, unset mode, and reset buyout tracking when tab is changed or Auction House closed
		CollectionShopEventsFrame:UnregisterEvent( "PLAYER_SPECIALIZATION_CHANGED" );
		CollectionShopEventsFrame:UnregisterEvent( "INSPECT_READY" );
		CollectionShopEventsFrame:UnregisterEvent( "UI_ERROR_MESSAGE" );
		NS.SetMode( nil, "noReset" );
		if NS.numAuctionsWon > 0 and NS.db["auctionsWonReminder"] then
			NS.Print( RED_FONT_COLOR_CODE .. string.format( L["Remember when leaving %s to equip or use auctions won to update your Collections for future Shop results."], L[NS.title] ) .. FONT_COLOR_CODE_CLOSE );
		end
		NS.numAuctionsWon = 0;
		NS.copperAuctionsWon = 0;
		wipe( NS.auctionsWon );
		wipe( NS.mountCollection );
		wipe( NS.petCollection );
		wipe( NS.toyCollection );
		if NS.options.MainFrame:IsShown() then
			NS.options.MainFrame:Hide(); -- Close options frame, prevents errors on Buyouts tab
		end
	end
	if NS.mode then -- Max Item Price
		AuctionFrameCollectionShop_MaxItemPriceFrameText:SetText( string.format( L["Max Item Price: %s"], ( NS.db["maxItemPriceCopper"][NS.mode] == 0 and L["None"] or NS.MoneyToString( NS.db["maxItemPriceCopper"][NS.mode] ) ) ) );
		AuctionFrameCollectionShop_MaxItemPriceFrame:Show();
	else
		AuctionFrameCollectionShop_MaxItemPriceFrame:Hide();
	end
	if NS.mode == "APPEARANCES" then -- Undress Character
		AuctionFrameCollectionShop_UndressCharacterCheckButton:SetChecked( NS.db["undressCharacter"] );
		AuctionFrameCollectionShop_UndressCharacterCheckButton:Show();
	else
		AuctionFrameCollectionShop_UndressCharacterCheckButton:Hide();
	end
	if NS.adjustScrollFrame then
		AuctionFrameCollectionShop_ScrollFrame:Adjust(); -- Must go before sort buttons to set NS.isPctItemValue
	end
	if NS.mode then
		NS.AuctionSortButtons_Action( "Show" );
		NS.AuctionSortButtons_Action( "Arrow:Hide" );
		NS.AuctionSortButtons_Action( "Enable" );
		if NS.isPctItemValue then
			AuctionFrameCollectionShop_PctItemValueSortButton:Click();
		else
			AuctionFrameCollectionShop_ItemPriceSortButton:Click();
		end
	else
		NS.AuctionSortButtons_Action( "Hide" );
	end
	AuctionFrameCollectionShop_ModeSelectionButton:Reset();
	AuctionFrameCollectionShop_ScrollFrame:Reset(); -- Includes: UpdateTitleText()
	if NS.mode then -- Mode Message or Mode Selection
		AuctionFrameCollectionShop_ModeSelectionFrame:Hide();
		NS.JumbotronFrame_Message( ( NS.db["live"] or NS.db["getAllScan"][NS.realmName] ) and L["Ready"] or L["Auction House data required"] );
		NS.StatusFrame_Message( ( not NS.db["live"] and not NS.db["getAllScan"][NS.realmName] ) and L["Press \"Scan\" to perform a GetAll scan"] or L["Press \"Shop\""] );
	else
		AuctionFrameCollectionShop_JumbotronFrame:Hide();
		AuctionFrameCollectionShop_ModeSelectionFrame:Show();
		NS.StatusFrame_Message( L["Choose Collection Mode"] );
	end
	NS.UpdateTimeSinceLastScan();
	AuctionFrameCollectionShop_LiveCheckButton:Enable();
	AuctionFrameCollectionShop_LiveCheckButton:SetChecked( NS.db["live"] );
	AuctionFrameCollectionShop_ScanButton:Reset();
	AuctionFrameCollectionShop_ShopButton:Reset();
	AuctionFrameCollectionShop_BuyAllButton:Reset();
	AuctionFrameCollectionShop_FlyoutPanel:Reset( filterOnClick );
	HideUIPanel( SideDressUpFrame );
end
--
NS.AuctionSortButtons_Action = function( action )
	local buttons = { "Name", "Lvl", "Category", "ItemPrice" };
	if NS.isPctItemValue then
		buttons[#buttons + 1] = "PctItemValue"; -- % Item Value
	end
	for i = 1, #buttons do
		local button = _G["AuctionFrameCollectionShop_" .. buttons[i] .. "SortButton"];
		local arrow = _G[button:GetName() .. "Arrow"];
		if action == "Arrow:Hide" then
			arrow:Hide();
		elseif action == "Disable" then
			button:Disable();
		elseif action == "Enable" then
			if arrow:IsShown() then
				button:Enable();
			else
				button:Enable();
				arrow:Hide();
			end
		elseif action == "Hide" then
			button:Hide();
		elseif action == "Show" then
			button:Show();
		end
	end
end
--
NS.JumbotronFrame_Message = function( text )
	AuctionFrameCollectionShop_JumbotronFrameText:SetText( ( text and ( NS.modeColorCode .. NS.modeName .. FONT_COLOR_CODE_CLOSE .. ": " .. text ) or nil ) );
	AuctionFrameCollectionShop_JumbotronFrame:Show();
end
--
NS.SetMode = function( mode, noReset )
	NS.mode = mode and NS.modes[mode] or nil;
	NS.modeName = mode and NS.modeNames[mode] or nil;
	NS.modeColorCode = mode and NS.modeColorCodes[mode] or nil;
	wipe( NS.modeFilters );
	wipe( NS.modeFiltersFlyout );
	-- filter: key(1), string(2), default(3), info(4)
	-- modeFilters: qualities(1), categories(2), collected(3), petLevels(4), misc(5)
	local poor = { ITEM_QUALITY0_DESC, ITEM_QUALITY_COLORS[0].hex .. ITEM_QUALITY0_DESC .. FONT_COLOR_CODE_CLOSE, true, 0 };
	local common = { ITEM_QUALITY1_DESC, ITEM_QUALITY_COLORS[1].hex .. ITEM_QUALITY1_DESC .. FONT_COLOR_CODE_CLOSE, true, 1 };
	local uncommon = { ITEM_QUALITY2_DESC, ITEM_QUALITY_COLORS[2].hex .. ITEM_QUALITY2_DESC .. FONT_COLOR_CODE_CLOSE, true, 2 };
	local rare = { ITEM_QUALITY3_DESC, ITEM_QUALITY_COLORS[3].hex .. ITEM_QUALITY3_DESC .. FONT_COLOR_CODE_CLOSE, true, 3 };
	local epic = { ITEM_QUALITY4_DESC, ITEM_QUALITY_COLORS[4].hex .. ITEM_QUALITY4_DESC .. FONT_COLOR_CODE_CLOSE, true, 4 };
	local notCollected = NS.mode and { "notCollected", NS.modeColorCode .. L["Not Collected"] .. FONT_COLOR_CODE_CLOSE, true } or nil;
	local collected = { "collected", RED_FONT_COLOR_CODE .. L["Collected"] .. FONT_COLOR_CODE_CLOSE, false };
	local requiresLevel = { "requiresLevel", RED_FONT_COLOR_CODE .. L["Requires Level"] .. FONT_COLOR_CODE_CLOSE, false };
	local requiresProfession = { "requiresProfession", RED_FONT_COLOR_CODE .. L["Requires Profession"] .. FONT_COLOR_CODE_CLOSE, false };
	if NS.mode == "MOUNTS" then
		NS.modeFilters = {
			{ rare, epic },
			{},
			{ notCollected, collected },
			{},
			{
				requiresLevel, requiresProfession,
				{ "requiresRidingSkill", RED_FONT_COLOR_CODE .. L["Requires Riding Skill"] .. FONT_COLOR_CODE_CLOSE, false },
			},
		};
		AuctionFrameCollectionShop_FlyoutPanel_ToggleCategories:Disable(); -- Mounts have no categories
	elseif NS.mode == "PETS" then
		NS.modeFilters = {
			{ common, uncommon, rare, epic },
			( function()
				local categories,categoryName = {};
				for i = 1, #AuctionCategories[10].subCategories do
					categoryName = AuctionCategories[10].subCategories[i].name;
					categories[#categories + 1] = { categoryName, ( i == 11 and ( L["Include"] .. " " ) or "" ) .. categoryName, true }; -- Pet Family (or Include Companion Pets)
				end
				return categories;
			end )(),
			{
				notCollected,
				{ "collected", NORMAL_FONT_COLOR_CODE .. L["Collected (1-2/3)"] .. FONT_COLOR_CODE_CLOSE, false },
				{ "collectedMax", RED_FONT_COLOR_CODE .. L["Collected (3/3)"] .. FONT_COLOR_CODE_CLOSE, false },
			},
			{
				{ "petLevels1", L["Level 1-10"], true },
				{ "petLevels2", L["Level 11-15"], true },
				{ "petLevels3", L["Level 16-20"], true },
				{ "petLevels4", L["Level 21-24"], true },
				{ "petLevels5", L["Level 25"], true },
			},
			{
				{ "groupBySpecies", L["Group By Species"], true },
			},
		};
	elseif NS.mode == "TOYS" then
		NS.modeFilters = {
			{ common, uncommon, rare, epic },
			( function()
				local cnums = {
					{ 6, 1 }, -- Consumables > Explosives and Devices
					{ 6, 5 }, -- Consumables > Food & Drink
					{ 6, 8 }, -- Consumables > Other
					{ 12, 1 }, -- Miscellaneous > Junk
					{ 10, 11 }, -- Battle Pets > Companion Pets
					{ 12, 3 }, -- Miscellaneous > Holiday
					{ 12, 4 }, -- Miscellaneous > Other
				};
				local categories,categoryName = {};
				for i = 1, #cnums do
					categoryName = AuctionCategories[cnums[i][1]].subCategories[cnums[i][2]].name .. " (" .. AuctionCategories[cnums[i][1]].name .. ")";
					categories[#categories + 1] = { categoryName, categoryName, true, { cnums[i][1], cnums[i][2] } };
				end
				return categories;
			end )(),
			{ notCollected, collected },
			{},
			{ requiresLevel, requiresProfession },
		};
	elseif NS.mode == "APPEARANCES" then
		NS.modeFilters = {
			{ uncommon, rare, epic },
			( function()
				local auctionCategoryIndexes = {};
				-- Weapons - One-Handed, Two-Handed, Ranged
				for i = 1, 3 do
					for x = 1, #AuctionCategories[1].subCategories[i].subCategories do
						auctionCategoryIndexes[AuctionCategories[1].subCategories[i].subCategories[x].name] = { 1, i, x };
					end
				end
				-- Armor - Plate, Mail, Leather, Cloth
				local classArmorIndexes = { -- 1 = Plate, 2 = Mail, 3 = Leather, 4 = Cloth
					["WARRIOR"] = 1,
					["DEATHKNIGHT"] = 1,
					["PALADIN"] = 1,
					["MONK"] = 3,
					["PRIEST"] = 4,
					["SHAMAN"] = 2,
					["DRUID"] = 3,
					["ROGUE"] = 3,
					["MAGE"] = 4,
					["WARLOCK"] = 4,
					["HUNTER"] = 2,
					["DEMONHUNTER"] = 3,
				};
				local classArmorIndex = classArmorIndexes[select( 2, UnitClass( "player" ) )];
				for i = 1, 4 do
					if i == classArmorIndex then -- Just one
						for x = 1, #AuctionCategories[2].subCategories[i].subCategories do
							auctionCategoryIndexes[AuctionCategories[2].subCategories[i].subCategories[x].name] = { 2, i, x };
						end
					end
				end
				-- Armor - Miscellaneous - Cloak, Held In Off-hand, Shields, Shirt
				auctionCategoryIndexes[BACKSLOT] = { 2, 5, 2 }; -- Appearances calls this "Back" - AuctionCategories[2].subCategories[5].subCategories[2].name
				auctionCategoryIndexes[AuctionCategories[2].subCategories[5].subCategories[5].name] = { 2, 5, 5 };
				auctionCategoryIndexes[AuctionCategories[2].subCategories[5].subCategories[6].name] = { 2, 5, 6 };
				auctionCategoryIndexes[AuctionCategories[2].subCategories[5].subCategories[7].name] = { 2, 5, 7 };
				-- Categories
				local categories,categoryName = {};
				for i = 1, NUM_LE_TRANSMOG_COLLECTION_TYPES do
					categoryName = C_TransmogCollection.GetCategoryInfo( i );
					NS.appearanceCollection.categoryNames[i] = categoryName or false;
					if categoryName and categoryName ~= TABARDSLOT and auctionCategoryIndexes[categoryName] then
						categories[#categories + 1] = { categoryName, categoryName, true, auctionCategoryIndexes[categoryName] };
					end
				end
				return categories;
			end )(),
			{
				notCollected,
				{ "collectedUnknownSources", NORMAL_FONT_COLOR_CODE .. L["Collected - Unknown Sources"] .. FONT_COLOR_CODE_CLOSE, false },
				{ "collectedKnownSources", RED_FONT_COLOR_CODE .. L["Collected - Known Sources"] .. FONT_COLOR_CODE_CLOSE, false },
			},
			{},
			{ requiresLevel, requiresProfession },
		};
	end
	-- Combine Filters for Flyout
	for i = 1, #NS.modeFilters do
		for x = 1, #NS.modeFilters[i] do
			NS.modeFiltersFlyout[#NS.modeFiltersFlyout + 1] = NS.modeFilters[i][x];
			if NS.db["modeFilters"][NS.mode][NS.modeFilters[i][x][1]] == nil then
				NS.db["modeFilters"][NS.mode][NS.modeFilters[i][x][1]] = NS.modeFilters[i][x][3]; -- default
			end
		end
	end
	-- Toggle Categories Button
	if NS.mode == "PETS" then
		AuctionFrameCollectionShop_FlyoutPanel_ToggleCategories:SetText( L["Toggle Pet Families"] );
	else
		AuctionFrameCollectionShop_FlyoutPanel_ToggleCategories:SetText( L["Toggle Categories"] );
	end
	-- Update and/or Reset
	if NS.mode == "MOUNTS" then
		if not next( NS.mountCollection ) then
			NS.UpdateMountCollection();
		else
			NS.Reset();
		end
	elseif NS.mode == "TOYS" then
		if not next( NS.toyCollection ) then
			NS.UpdateToyCollection();
		else
			NS.Reset();
		end
	elseif NS.mode == "APPEARANCES" then -- appearanceCollection is updated just before ImportShopData
		NS.Reset();
	elseif ( not NS.mode and not noReset ) or NS.mode == "PETS" then -- petCollection updated during ImportShopData
		NS.Reset();
	end
end
--
NS.StatusFrame_Message = function( text )
	AuctionFrameCollectionShop_DialogFrame_StatusFrameText:SetText( text );
	AuctionFrameCollectionShop_DialogFrame_BuyoutFrame:Hide();
	AuctionFrameCollectionShop_DialogFrame_StatusFrame:Show();
end
--
NS.BuyoutFrame_Activate = function()
	AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton:Enable();
	AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_CancelButton:Enable();
	AuctionFrameCollectionShop_DialogFrame_StatusFrame:Hide();
	AuctionFrameCollectionShop_DialogFrame_BuyoutFrame:Show();
end
--
NS.UpdateTimeSinceLastScan = function()
	local timeSinceLastGetAllScan = NS.db["getAllScan"][NS.realmName] and ( time() - NS.db["getAllScan"][NS.realmName]["time"] ) or nil;
	local timeSinceLastGetAllScanText = ( function()
		if NS.db["live"] then
			return GREEN_FONT_COLOR_CODE .. L["Live"] .. FONT_COLOR_CODE_CLOSE;
		elseif type( timeSinceLastGetAllScan ) ~= "number" or timeSinceLastGetAllScan > 900 then -- 900 sec = 15 min
			return RED_FONT_COLOR_CODE .. ( timeSinceLastGetAllScan and NS.SecondsToStrTime( timeSinceLastGetAllScan ) or L["Never"] ) .. FONT_COLOR_CODE_CLOSE;
		else
			return HIGHLIGHT_FONT_COLOR_CODE .. NS.SecondsToStrTime( timeSinceLastGetAllScan ) .. FONT_COLOR_CODE_CLOSE;
		end
	end )();
	AuctionFrameCollectionShop_TimeSinceLastGetAllScanFrameText:SetText( string.format( L["Time since last scan: %s"], timeSinceLastGetAllScanText ) );
end
--
NS.UpdateTitleText = function()
	local text = {};
	if #NS.auction.data.groups > 0 then
		text[#text + 1] = NS.FormatNum( #NS.auction.data.groups ) .. " 個 " .. NS.modeColorCode .. ( ( NS.mode == "APPEARANCES" and NS.shopAppearancesBy == "source" ) and L["Appearance Sources"] or NS.modeName ) .. FONT_COLOR_CODE_CLOSE;
	end
	if NS.numAuctionsWon > 0 then
		text[#text + 1] = NS.numAuctionsWon .. " " .. GREEN_FONT_COLOR_CODE .. ( NS.numAuctionsWon == 1 and L["Buyout"] or L["Buyouts"] ) .. FONT_COLOR_CODE_CLOSE .. " (" .. NS.MoneyToString( NS.copperAuctionsWon, HIGHLIGHT_FONT_COLOR_CODE ) .. ")";
	end
	AuctionFrameCollectionShop_TitleText:SetText( table.concat( text, HIGHLIGHT_FONT_COLOR_CODE .. "   " .. FONT_COLOR_CODE_CLOSE ) );
	AuctionFrameCollectionShop_BuyoutsMailButton:SetText( NS.numAuctionsWon );
	if not NS.mode or NS.numAuctionsWon == 0 then
		AuctionFrameCollectionShop_BuyoutsMailButton:Hide();
	else
		AuctionFrameCollectionShop_BuyoutsMailButton:Show();
	end
end
--
NS.AuctionSortButton_OnClick = function( button, itemInfoKey )
	-- Update Arrows
	local arrow = _G[button:GetName() .. "Arrow"];
	local l,_,_,_,r,t,_,b = arrow:GetTexCoord();
	local direction = ( function() if t == 0 and b == 1.0 then return "down" else return "up" end end )();
	local order;
	--
	if arrow:IsShown() and direction == "up" or not arrow:IsShown() then
		t = 0;
		b = 1.0;
		order = "ASC"; -- Arrow facing downward
	else
		t = 1.0;
		b = 0;
		order = "DESC"; -- Arrow facing upward
	end
	--
	NS.AuctionSortButtons_Action( "Arrow:Hide" );
	arrow:SetTexCoord( 0, 0.5625, t, b );
	arrow:Show();
	-- Return sorted data to frame
	NS.auction.data.sortKey = itemInfoKey;
	NS.auction.data.sortOrder = order;
	NS.AuctionDataGroups_Sort();
	if NS.buyAll then
		NS.AuctionGroup_OnClick( 1 );
	else
		AuctionFrameCollectionShop_ScrollFrame:Update();
	end
end
--
NS.AuctionGroup_OnClick = function( groupKey )
	if NS.scan.status == "ready" or NS.scan.status == "selected" then
		-- SELECT
		local auction = CopyTable( NS.auction.data.groups[groupKey][5][1] ); -- auctions(5), first auction(1)
		NS.scan.query.remaining = 1;
		NS.scan.query.auction = auction;
		NS.scan.query.auction.groupKey = groupKey;
		NS.scan.query.name = NS.auction.data.groups[groupKey][2]; -- name(2)
		NS.scan.query.page = 0;
		NS.scan.query.rarity = auction[4]; -- quality/rarity(4)
		NS.scan.query.exactMatch = true;
		NS.scan.query.filterData = nil;
		if NS.buyAll and groupKey == 1 then
			AuctionFrameCollectionShop_ScrollFrame:SetVerticalScroll( 0 ); -- Scroll to top when first group is selected during Buy All
		end
		AuctionFrameCollectionShop_ScrollFrame:Update();
		NS.scan:Start( "SELECT" );
	elseif NS.scan.status == "buying" then
		NS.Print( L["Selection ignored, buying"] );
	else
		NS.Print( L["Selection ignored, scanning"] );
	end
end
--
NS.AuctionGroup_AuctionMissing = function( groupKey, OnMessageOnly )
	PlaySound( 1427 ); -- SPELL_Shadow_Fizzle
	local itemPrice = NS.auction.data.groups[groupKey][5][1][1]; -- auctions(5), first auction(1), itemPrice(1)
	local itemLink = NS.auction.data.groups[groupKey][5][1][2]; -- auctions(5), first auction(1), itemLink(2)
	local itemId = NS.auction.data.groups[groupKey][5][1][6]; -- auctions(5), first auction(1), itemId(6)
	local groupAuctions = NS.auction.data.groups[groupKey][5]; -- auctions(5)
	local auction,removed,RemoveAuctions,RemovalComplete;
	--
	RemoveAuctions = function()
		if not NS.db["live"] then
			local scanAuctions = NS.db["getAllScan"][NS.realmName]["data"]["itemIds"][itemId];
			-- Remove auctions(5) that match by itemPrice(1) and itemLink(2) from scan data
			auction = 1;
			while auction <= #scanAuctions do
				if NS.scan.status ~= "scanning" and NS.scan.status ~= "buying" then return end -- Check for Reset
				--
				if scanAuctions[auction][1] == itemPrice and ( itemId == 82800 and scanAuctions[auction][2] or NS.NormalizeItemLink( scanAuctions[auction][2] ) ) == itemLink then
					table.remove( scanAuctions, auction ); -- Remove auction from scan data
				else
					auction = auction + 1;
				end
			end
			if #scanAuctions == 0 then
				scanAuctions = nil; -- Remove empty itemId from scan data
			end
		end
		-- Remove auctions(5) that match by itemPrice(1) and itemLink(2) or itemId(6) from group
		auction = 1;
		while auction <= #groupAuctions do
			if NS.scan.status ~= "scanning" and NS.scan.status ~= "buying" then return end -- Check for Reset
			--
			if groupAuctions[auction][1] ~= itemPrice then break end -- Auctions in a group are sorted by itemPrice(1) ASC, so once we exceed itemPrice we won't find any matches
			--
			if NS.NormalizeItemLink( groupAuctions[auction][2] ) == itemLink then
				table.remove( groupAuctions, auction ); -- Remove auction from group
			else
				auction = auction + 1;
			end
		end
		--
		if #groupAuctions == 0 then
			-- All auctions removed, so just remove Group
			NS.AuctionDataGroups_RemoveGroup( groupKey );
			removed = "group";
			return RemovalComplete();
		else
			-- Some auctions removed, update and filter group
			NS.AuctionDataGroups_UpdateGroup( groupKey );
			local groupId = NS.auction.data.groups[groupKey][1]; -- itemId(1) or speciesID(1) or itemLink(1) or appearanceID(1) or sourceID(1)
			NS.scan:FilterGroups( function()
				-- Was group removed?
				if not NS.AuctionDataGroups_FindGroupKey( groupId ) then
					removed = "group";
				else
					removed = "auction";
				end
				return RemovalComplete();
			end, groupKey );
		end
	end
	--
	RemovalComplete = function()
		NS.scan.status = "ready";
		if removed == "group" then
			-- Group removed
			NS.AuctionGroup_Deselect();
			if #NS.auction.data.groups > 0 then
				-- More groups exist
				if NS.buyAll then
					NS.AuctionGroup_OnClick( 1 );
				else
					NS.StatusFrame_Message( NS.SELECT_AN_AUCTION() );
					AuctionFrameCollectionShop_BuyAllButton:Enable();
					OnMessageOnly(); -- Callback
				end
			else
				-- No groups exist
				NS.StatusFrame_Message( L["No additional auctions matched your settings"] );
				AuctionFrameCollectionShop_BuyAllButton:Reset();
				OnMessageOnly(); -- Callback
			end
		elseif removed == "auction" then
			-- Single auction removed
			NS.AuctionDataGroups_Sort();
			if NS.buyAll then
				NS.AuctionGroup_OnClick( 1 );
			else
				NS.NextAdjustScroll = true;
				NS.AuctionGroup_OnClick( NS.scan.query.auction.groupKey );
				NS.Print( string.format( NS.mode == "APPEARANCES" and L["Selecting %s for %s, same %s."] or L["Selecting %s for %s, next cheapest."], NS.scan.query.auction[2], NS.MoneyToString( NS.scan.query.auction[1] ), ( NS.mode == "APPEARANCES" and ( NS.shopAppearancesBy == "appearance" and L["appearance"] or L["source"] ) or nil ) ) );
			end
		end
	end
	--
	RemoveAuctions();
end
--
NS.AuctionGroup_Deselect = function()
	NS.scan.status = "ready";
	wipe( NS.scan.query.auction );
	AuctionFrameCollectionShop_ScrollFrame:Update();
	if NS.mode == "MOUNTS" or NS.mode == "PETS" or NS.mode == "APPEARANCES" then
		HideUIPanel( SideDressUpFrame );
		AuctionFrameCollectionShop_FlyoutPanel:Reset();
	end
end
--
NS.FlyoutPanelToggleCategories = function()
	local checked = false;
	for i = 1, #NS.modeFilters[2] do
		if NS.mode == "PETS" and i == #NS.modeFilters[2] then break end -- Skip Include Companion Pets
		if not NS.db["modeFilters"][NS.mode][NS.modeFilters[2][i][1]] then
			checked = true;
			break;
		end
	end
	for i = 1, #NS.modeFilters[2] do
		if NS.mode == "PETS" and i == #NS.modeFilters[2] then break end -- Skip Include Companion Pets
		NS.db["modeFilters"][NS.mode][NS.modeFilters[2][i][1]] = checked;
	end
	NS.Reset( true );
end
--
NS.FlyoutPanelSetChecks = function( checked )
	for i = 1, #NS.modeFiltersFlyout do
		NS.db["modeFilters"][NS.mode][NS.modeFiltersFlyout[i][1]] = checked;
	end
	NS.Reset( true );
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Item Link & Tooltip
--------------------------------------------------------------------------------------------------------------------------------------------
NS.NormalizeItemLink = function( itemLink )
	if string.match( itemLink, "|Hbattlepet:" ) then return itemLink; end
	local itemString = string.match( itemLink, "item[%-?%d:]+" );
	local itemStringPieces = {};
	for piece in string.gmatch( itemString, "([^:]*):?" ) do
		if #itemStringPieces == 9 then
			piece = NS.linkLevel; -- Player level
		elseif #itemStringPieces == 10 then
			piece = NS.linkSpecID; -- Player Spec ID
		end
		itemStringPieces[#itemStringPieces + 1] = piece;
	end
	if not string.match( itemString, ":$" ) then
		itemStringPieces[#itemStringPieces] = nil;
	end
	itemString = table.concat( itemStringPieces, ":" );
	return string.gsub( itemLink, "item[%-?%d:]+", itemString );
end
--
NS.FindInTooltip = function( itemLink, textColor, textPatterns, minLine, maxLine )
	NS.GameTooltip:ClearLines();
	NS.GameTooltip:SetHyperlink( itemLink );
	local gtn,totalLines = NS.GameTooltip:GetName(),NS.GameTooltip:NumLines();
	local textLeft,textLeftText,textLeftColor = nil,nil,{};
	if totalLines == 1 and _G[gtn ..'TextLeft' .. 1]:GetText() == RETRIEVING_ITEM_INFO then
		return "retry"; -- Retrieving Item Information
	else
		for line = 1, totalLines do
			if maxLine and line > maxLine then break end
			if not minLine or line >= minLine then
				--
				textLeft = _G[gtn ..'TextLeft' .. line];
				textLeftText = textLeft:GetText();
				if not textLeftText then return end
				--
				local textLeftColorMatch = false;
				if textColor then
					textLeftColor.r, textLeftColor.g, textLeftColor.b = textLeft:GetTextColor();
					if textColor.r == math.floor( textLeftColor.r * 256 ) and textColor.g == math.floor( textLeftColor.g * 256 ) and textColor.b == math.floor( textLeftColor.b * 256 ) then
						textLeftColorMatch = true;
					end
				end
				--
				local textLeftPatternMatch = false;
				if textPatterns and ( ( textColor and textLeftColorMatch ) or not textColor ) then
					for i = 1, #textPatterns do
						if string.match( textLeftText, textPatterns[i] ) then
							textLeftPatternMatch = true;
							break; -- Gotcha sucka!
						end
					end
				end
				--
				if ( ( textColor and textPatterns ) and ( textLeftColorMatch and textLeftPatternMatch ) ) or ( ( textColor and not textPatterns ) and textLeftColorMatch ) or ( ( textPatterns and not textColor ) and textLeftPatternMatch ) then
					return textLeftText;
				end
			end
		end
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Auction Data Groups
--------------------------------------------------------------------------------------------------------------------------------------------
NS.AuctionDataGroups_FindGroupKey = function( groupId )
	for groupKey = 1, #NS.auction.data.groups do
		if NS.auction.data.groups[groupKey][1] == groupId then
			return groupKey;
		end
	end
	return nil;
end
--
NS.AuctionDataGroups_RemoveAuction = function( groupKey )
	local groupAuctions = NS.auction.data.groups[groupKey][5];
	table.remove( groupAuctions, 1 ); -- auctions(5), first auction(1)
	-- Remove or update group
	if #groupAuctions == 0 then
		NS.AuctionDataGroups_RemoveGroup( groupKey );
		return "group";
	else
		NS.AuctionDataGroups_UpdateGroup( groupKey );
		return "auction";
	end
end
--
NS.AuctionDataGroups_RemoveGroup = function( groupKey )
	table.remove( NS.auction.data.groups, groupKey );
	return "group";
end
--
NS.AuctionDataGroups_UpdateGroup = function( groupKey )
	-- First, normalize itemLink to match current player's AH links.
	-- The GetAll scan may have been performed on another character or when current character was a different spec or level.
	if not NS.db["live"] then
		NS.auction.data.groups[groupKey][5][1][2] = NS.NormalizeItemLink( NS.auction.data.groups[groupKey][5][1][2] );
	end
	-- Update Group
	local itemValue = NS.isPctItemValue and ( NS.tsmPriceSources[NS.db["tsmItemValueSource"]] and TSMAPI:GetItemValue( NS.auction.data.groups[groupKey][5][1][2], NS.db["tsmItemValueSource"] ) or TSMAPI:GetCustomPriceValue( NS.db["tsmItemValueSource"], NS.auction.data.groups[groupKey][5][1][2] ) ) or nil;
	NS.auction.data.groups[groupKey][2] = string.match( NS.auction.data.groups[groupKey][5][1][2], "%|h%[(.+)%]%|h" ); -- group name(2) copied from auctions(5), then first auction(1), get name via itemLink(2)
	NS.auction.data.groups[groupKey][4] = NS.auction.data.groups[groupKey][5][1][1]; -- group itemPrice(4) copied from auctions(5), then first auction(1), then itemPrice(1)
	NS.auction.data.groups[groupKey][6] = NS.mode == "PETS" and NS.auction.data.groups[groupKey][5][1][9] or NS.auction.data.groups[groupKey][5][1][5]; -- group lvl(6) copied from auctions(5), then first auction(1), then lvl(9) or requiresLevel(5)
	NS.auction.data.groups[groupKey][7] = ( not itemValue or itemValue == 0 ) and 123456789 or ( ( NS.auction.data.groups[groupKey][4] * 100 ) / itemValue ); -- pctItemValue(7)
end
--
NS.AuctionDataGroups_Filter = function( groupKey, FilterFunction, OnGroupsComplete, filterNotMatch, filter )
	if not filter then return OnGroupsComplete(); end
	--
	local groupKeyStart,groupKeyStop,groupBatchNum,groupBatchSize,groupBatchRetry,filterGroupIds,NextGroup,GroupsComplete;
	local groupKeyList = type( groupKey ) == "table" and CopyTable( groupKey ) or nil;
	local groupKey = not groupKeyList and groupKey or nil;
	--
	NextGroup = function()
		if NS.scan.status ~= "scanning" and NS.scan.status ~= "buying" then return end -- Check for Reset
		--
		if groupKey <= groupKeyStop then
			if not groupKeyList or groupKeyList[groupKey] then
				if not groupBatchRetry.inProgress or ( groupBatchRetry.inProgress and groupBatchRetry.groupBatchNum[groupBatchNum] ) then -- Not currently retrying or retrying and match
					local match = FilterFunction( NS.auction.data.groups[groupKey] );
					--
					-- DEBUG
					--
					-- if match == "retry" and groupBatchRetry.attempts == groupBatchRetry.attemptsMax then
					-- 	NS.Print( string.format( L["Filter failed at %s for %s"], RETRIEVING_ITEM_INFO, NS.auction.data.groups[groupKey][5][1][2] ) ); -- auctions(5) first auction(1) itemLink(2)
					-- end
					--
					-- Validate - ignore, retry, or match
					if match == "retry" and groupBatchRetry.attempts < groupBatchRetry.attemptsMax then
						-- Retry required, add it
						if not groupBatchRetry.inProgress then
							groupBatchRetry.count = groupBatchRetry.count + 1;
							groupBatchRetry.groupBatchNum[groupBatchNum] = true;
						end
					elseif ( ( not match or match == "retry" ) and filterNotMatch ) or ( match and match ~= "retry" and not filterNotMatch ) then
						--
						-- FILTER
						--
						table.insert( filterGroupIds, NS.auction.data.groups[groupKey][1] ); -- groupId(1)
					end
					-- Retry successful, remove it
					if groupBatchRetry.inProgress and ( not match or match ~= "retry" ) then
						groupBatchRetry.count = groupBatchRetry.count - 1;
						groupBatchRetry.groupBatchNum[groupBatchNum] = nil;
					end
				end
			end
			-- Batch Complete
			if groupBatchNum == groupBatchSize or groupKey == groupKeyStop then
				if groupBatchRetry.count > 0 and ( not groupBatchRetry.inProgress or ( groupBatchRetry.inProgress and groupBatchRetry.attempts < groupBatchRetry.attemptsMax ) ) then
					-- Start Batch Retry
					groupBatchRetry.inProgress = true;
					groupBatchRetry.attempts = groupBatchRetry.attempts + 1;
					groupKey = ( groupKey - groupBatchNum ) + 1; -- Reset groupKey to start of batch for retry
					groupBatchNum = 1;
					local after = groupBatchRetry.attempts * 0.01;
					return C_Timer.After( after, NextGroup );
				else
					-- No Batch Retry
					groupBatchRetry.inProgress = false;
					groupBatchRetry.count = 0;
					groupBatchRetry.attempts = 0;
					wipe( groupBatchRetry.groupBatchNum );
					groupKey = groupKey + 1;
					groupBatchNum = 1;
					return C_Timer.After( 0.001, NextGroup );
				end
			end
			-- Group Complete
			groupKey = groupKey + 1;
			groupBatchNum = groupBatchNum + 1;
			return NextGroup();
		else
			return GroupsComplete();
		end
	end
	--
	GroupsComplete = function()
		if NS.scan.status ~= "scanning" and NS.scan.status ~= "buying" then return end -- Check for Reset
		if filter == "analyze" then return OnGroupsComplete( filterGroupIds ); end -- Return for analysis -- DO NOT REMOVE GROUPS --
		--
		local recheckGroupIds = {}; -- APPEARANCES ONLY
		-- Remove filtered auction or group
		for i = 1, #filterGroupIds do
			local groupKey = NS.AuctionDataGroups_FindGroupKey( filterGroupIds[i] );
			if ( NS.mode == "APPEARANCES" and NS.AuctionDataGroups_RemoveAuction( groupKey ) or NS.AuctionDataGroups_RemoveGroup( groupKey ) ) ~= "group" then
				-- Auction removed, group must be rechecked -- APPEARANCES ONLY --
				table.insert( recheckGroupIds, filterGroupIds[i] ); -- i.e. appearanceID or sourceID
			end
		end
		-- Recheck auction removed groups, their new first auction may be a match
		if #recheckGroupIds > 0 then
			local recheckGroupKeys = {};
			for i = 1, #recheckGroupIds do
				recheckGroupKeys[NS.AuctionDataGroups_FindGroupKey( recheckGroupIds[i] )] = true;
			end
			return NS.AuctionDataGroups_Filter( recheckGroupKeys, FilterFunction, OnGroupsComplete, filterNotMatch, filter );
		else
			return OnGroupsComplete();
		end
	end
	--
	groupKeyStart = groupKey or 1;
	groupKeyStop = groupKey or #NS.auction.data.groups;
	groupKey = groupKeyStart;
	groupBatchNum = 1;
	groupBatchSize = 50;
	groupBatchRetry = { inProgress = false, count = 0, attempts = 0, attemptsMax = 50, groupBatchNum = {} };
	filterGroupIds = {};
	NextGroup();
end
--
NS.AuctionDataGroups_Sort = function()
	if #NS.auction.data.groups == 0 then return end
	--
	local groupId;
	if NS.scan.query.auction.groupKey then
		groupId = NS.auction.data.groups[NS.scan.query.auction.groupKey][1]; -- itemId(1) or speciesID(1) or itemLink(1) or appearanceID(1)
	end
	--
	table.sort ( NS.auction.data.groups,
		function ( item1, item2 )
			if item1[NS.auction.data.sortKey] == item2[NS.auction.data.sortKey] then
				if item1[4] ~= item2[4] then -- itemPrice
					return item1[4] < item2[4]; -- itemPrice
				else
					return item1[3] < item2[3]; -- category
				end
			end
			if NS.auction.data.sortOrder == "ASC" then
				return item1[NS.auction.data.sortKey] < item2[NS.auction.data.sortKey];
			elseif NS.auction.data.sortOrder == "DESC" then
				return item1[NS.auction.data.sortKey] > item2[NS.auction.data.sortKey];
			end
		end
	);
	-- Find selected groupKey after reordering them
	if groupId then
		NS.scan.query.auction.groupKey = NS.AuctionDataGroups_FindGroupKey( groupId );
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Scan
--------------------------------------------------------------------------------------------------------------------------------------------
function NS.scan:Reset()
	CollectionShopEventsFrame:UnregisterEvent( "AUCTION_ITEM_LIST_UPDATE" );
	-- Check if GETALL scan was interupted
	if self.type == "GETALL" and self.status == "scanning" then
		if ( CanSendAuctionQuery() ) then
			QueryAuctionItems( "CLEAR_BROWSE_FRAME_RESULTS", nil, nil, 0, false, nil, false, false, nil ); -- Prevents WoW from crashing on subsequent queries, not sure why
		end
	end
	--
	self.query = {
		queue = {},
		categoryName = nil,
		subCategoryName = nil,
		remaining = 1,
		auction = {}, 	-- SELECT
		name = "",
		page = 0,
		rarity = nil,
		exactMatch = false,
		filterData = nil,
		qualities = {}, -- SHOP
		totalPages = 0,
		attempts = 1,
		maxAttempts = 50,
	};
	self.type = nil;
	self.status = "ready"; -- ready, scanning, selected, buying
	self.ailu = "LISTEN";
end
--
function NS.scan:Start( type )
	if self.status ~= "ready" and self.status ~= "selected" then return end
	--
	self.status = "scanning";
	self.type = type;
	wipe( self.query.qualities );
	NS.AuctionSortButtons_Action( "Disable" );
	AuctionFrameCollectionShop_JumbotronFrame:Hide();
	AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton:Disable();
	AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_CancelButton:Disable();
	AuctionFrameCollectionShop_LiveCheckButton:Disable();
	AuctionFrameCollectionShop_ScanButton:Disable();
	AuctionFrameCollectionShop_BuyAllButton:Disable();
	NS.disableFlyoutChecks = true;
	AuctionFrameCollectionShop_FlyoutPanel_ScrollFrame:Update();
	--
	if type == "GETALL" then
		NS.JumbotronFrame_Message( L["Scanning Auction House"] );
		NS.StatusFrame_Message( L["Request sent, waiting on auction data... This can take a minute, please wait..."] );
		AuctionFrameCollectionShop_ShopButton:Disable();
		for i = 1, 4 do
			self.query.qualities[i] = true;
		end
		self:QueryGetAllSend();
	elseif type == "SELECT" then
		AuctionFrameCollectionShop_ShopButton:SetText( L["Abort"] );
		self.query.qualities[self.query.rarity] = true;
		self:QueryPageSend();
	elseif type == "SHOP" then
		NS.JumbotronFrame_Message( L["Shopping"] );
		NS.StatusFrame_Message( "..." );
		AuctionFrameCollectionShop_ShopButton:SetText( L["Abort"] );
		-- ALL MODES: Qualities
		for i = 1, #NS.modeFilters[1] do
			if NS.db["modeFilters"][NS.mode][NS.modeFilters[1][i][1]] then
				self.query.qualities[NS.modeFilters[1][i][4]] = true;
			end
		end
		if not next( self.query.qualities ) then
			return self:Complete( RED_FONT_COLOR_CODE .. L["You must check at least one rarity filter"] .. FONT_COLOR_CODE_CLOSE );
		end
		-- MOST MODES: Categories Filter Check
		if NS.mode == "PETS" or NS.mode == "TOYS" or NS.mode == "APPEARANCES" then
			local categoriesFilterCheck = false;
			for i = 1, #NS.modeFilters[2] do
				if NS.db["modeFilters"][NS.mode][NS.modeFilters[2][i][1]] and not ( NS.mode == "PETS" and i == #NS.modeFilters[2] ) then -- Companion Pets doesn't count, not a Pet Family
					categoriesFilterCheck = true;
					break;
				end
			end
			if not categoriesFilterCheck then
				return self:Complete( RED_FONT_COLOR_CODE .. string.format( L["You must check at least one %s filter"], ( NS.mode == "PETS" and L["Pet Family"] ) or ( NS.mode == "TOYS" and L["Auction Category"] ) or ( NS.mode == "APPEARANCES" and L["Appearance Category"] ) ) .. FONT_COLOR_CODE_CLOSE );
			end
		end
		-- ALL MODES: Collected Filter Check
		local collectedFilterCheck = false;
		for i = 1, #NS.modeFilters[3] do
			if NS.db["modeFilters"][NS.mode][NS.modeFilters[3][i][1]] then
				collectedFilterCheck = true;
				break;
			end
		end
		if not collectedFilterCheck then
			return self:Complete( RED_FONT_COLOR_CODE .. L["You must check at least one Collected filter"] .. FONT_COLOR_CODE_CLOSE );
		end
		-- SHOP BY MODE
		--------------------------------------------------------------------------------------------------------------------------------------------
		if NS.mode == "MOUNTS" then
			if NS.db["live"] then
				self.query.filterData = AuctionCategories[12].subCategories[5].filters; -- Miscellaneous => Mount
				self.query.categoryName = AuctionCategories[12].name; -- Miscellaneous
				self.query.subCategoryName = AuctionCategories[12].subCategories[5].name; -- Mount
				self:QueryPageSend();
			else
				self:ImportShopData();
			end
		--------------------------------------------------------------------------------------------------------------------------------------------
		elseif NS.mode == "PETS" then
			if NS.db["live"] then
				-- Auction Categories
				for i = 1, #AuctionCategories[10].subCategories do
					if NS.db["modeFilters"][NS.mode][AuctionCategories[10].subCategories[i].name] then
						table.insert( self.query.queue, function()
							self.query.filterData = AuctionCategories[10].subCategories[i].filters; -- Battle Pets => Pet Family (or Companion Pets)
							self.query.categoryName = AuctionCategories[10].name; -- Battle Pets
							self.query.subCategoryName = AuctionCategories[10].subCategories[i].name; -- Pet Family (or Companion Pets)
						end );
					end
				end
				-- Pet Levels Filter Check
				local petLevelsFilterCheck = false;
				for i = 1, #NS.modeFilters[4] do
					if NS.db["modeFilters"][NS.mode][NS.modeFilters[4][i][1]] then
						petLevelsFilterCheck = true;
						break;
					end
				end
				if not petLevelsFilterCheck then
					return self:Complete( RED_FONT_COLOR_CODE .. L["You must check at least one Level filter"] .. FONT_COLOR_CODE_CLOSE );
				end
				--
				self.query.remaining = #self.query.queue;
				self.query.queue[1]();
				self:QueryPageSend();
			else
				self:ImportShopData();
			end
		--------------------------------------------------------------------------------------------------------------------------------------------
		elseif NS.mode == "TOYS" then
			if NS.db["live"] then
				for i = 1, #NS.modeFilters[2] do
					if NS.db["modeFilters"][NS.mode][NS.modeFilters[2][i][1]] then
						local cat,subcat = unpack( NS.modeFilters[2][i][4] );
						table.insert( self.query.queue, function()
							self.query.filterData = AuctionCategories[cat].subCategories[subcat].filters; -- Category => Subcategory
							self.query.categoryName = AuctionCategories[cat].name; -- Category
							self.query.subCategoryName = AuctionCategories[cat].subCategories[subcat].name; -- Subcategory
						end );
					end
				end
				self.query.remaining = #self.query.queue;
				self.query.queue[1]();
				self:QueryPageSend();
			else
				self:ImportShopData();
			end
		--------------------------------------------------------------------------------------------------------------------------------------------
		elseif NS.mode == "APPEARANCES" then
			NS.shopAppearancesBy = ( NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] or NS.db["modeFilters"][NS.mode][NS.modeFilters[3][3][1]] ) and "source" or "appearance";
			if NS.db["live"] then
				for i = 1, #NS.modeFilters[2] do
					if NS.db["modeFilters"][NS.mode][NS.modeFilters[2][i][1]] then
						local cat,subcat1,subcat2 = unpack( NS.modeFilters[2][i][4] );
						table.insert( self.query.queue, function()
							self.query.filterData = AuctionCategories[cat].subCategories[subcat1].subCategories[subcat2].filters; -- Category => Subcategory1 => Subcateogry2
							self.query.categoryName = AuctionCategories[cat].name; -- Category
							self.query.subCategoryName = AuctionCategories[cat].subCategories[subcat1].name .. " > " .. AuctionCategories[cat].subCategories[subcat1].subCategories[subcat2].name; -- Subcategory1 > Subcategory2
						end );
					end
				end
				self.query.remaining = #self.query.queue;
				self.query.queue[1]();
				self:QueryPageSend();
			else
				if not NS.appearanceCollection.getAllReady then
					self:UpdateAppearanceCollection();
				else
					self:ImportShopData();
				end
			end
		end
	end
end
--
function NS.scan:QueryPageSend()
	if self.status ~= "scanning" then return end
	if CanSendAuctionQuery( "list" ) and self.ailu ~= "IGNORE" then
		self.query.attempts = 1; -- Set to default on successful attempt
		local name = self.query.name;
		local page = self.query.page;
		local usable = false;
		local rarity = self.query.rarity;
		local getAll = false;
		local exactMatch = self.query.exactMatch;
		local filterData = self.query.filterData;
		local minLevel,maxLevel;
		SortAuctionClearSort( "list" );
		if NS.db["maxItemPriceCopper"][NS.mode] > 0 or self.type == "SELECT" then
			SortAuctionSetSort( "list", "buyout" );
			SortAuctionApplySort( "list" );
		end
		CollectionShopEventsFrame:RegisterEvent( "AUCTION_ITEM_LIST_UPDATE" );
		QueryAuctionItems( name, minLevel, maxLevel, page, usable, rarity, getAll, exactMatch, filterData );
	elseif self.query.attempts < self.query.maxAttempts then
		-- Increment attempts, delay and reattempt
		self.query.attempts = self.query.attempts + 1;
		C_Timer.After( 0.10, function() self:QueryPageSend() end );
	else
		-- Abort
		NS.Print( L["Could not query Auction House after several attempts. Please try again later."] );
		NS.Reset();
	end
end
--
function NS.scan:QueryGetAllSend()
	if self.status ~= "scanning" then return end
	local canQuery, canMassQuery = CanSendAuctionQuery( "list" );
	if canQuery and canMassQuery and self.ailu ~= "IGNORE" then
		local name = "";
		local page = 0;
		local usable = false;
		local getAll = true;
		local exactMatch = false;
		local minLevel,maxLevel,rarity,filterData;
		SortAuctionClearSort( "list" );
		CollectionShopEventsFrame:RegisterEvent( "AUCTION_ITEM_LIST_UPDATE" );
		--
		if NS.db["getAllScan"][NS.realmName] then
			NS.db["getAllScan"][NS.realmName] = nil;
		end
		--
		NS.appearanceCollection.getAllReady = false;
		--
		NS.db["getAllScan"][NS.realmName] = {
			["data"] = {
				["itemIds"] = {},
				["appearanceSources"] = {}
			},
			["time"] = time(),
		};
		--
		QueryAuctionItems( name, minLevel, maxLevel, page, usable, rarity, getAll, exactMatch, filterData );
	else
		-- Abort
		NS.Print( L["Blizzard allows a GetAll scan once every 15 minutes. Please try again later."] );
		NS.Reset();
	end
end
--
function NS.scan:OnAuctionItemListUpdate() -- AUCTION_ITEM_LIST_UPDATE
	CollectionShopEventsFrame:UnregisterEvent( "AUCTION_ITEM_LIST_UPDATE" );
	if self.ailu == "AUCTION_WON" then self:AfterAuctionWon(); end
	if self.ailu == "IGNORE" then self.ailu = "LISTEN"; return end
	if self.status ~= "scanning" then return end
	if self.type == "GETALL" then
		self:QueryGetAllRetrieve();
	else
		self:QueryPageRetrieve();
	end
end
--
function NS.scan:AuctionItemType( itemId )
	if NS.mountInfo[itemId] then
		return "mount";
	elseif itemId == 82800 or NS.petInfo[itemId] then
		return "pet";
	elseif NS.toyInfo[itemId] then
		return "toy";
	else
		local _,_,_,invType = GetItemInfoInstant( itemId );
		if invType and NS.invTypeToSlotId[invType] then
			return "possible-appearance";
		else
			return nil; -- No type
		end
	end
end
--
function NS.scan:GetAuctionItemInfo( index )
	local data = ( self.type == "GETALL" and NS.db["getAllScan"][NS.realmName]["data"] ) or ( self.type == "SHOP" and NS.auction.data.live );
	local _,texture,count,quality,_,level,levelColHeader,_,_,buyoutPrice,_,_,_,_,_,_,itemId = GetAuctionItemInfo( "list", index );
	local itemLink;
	if ( self.type == "SHOP" or self.type == "SELECT" ) and NS.db["maxItemPriceCopper"][NS.mode] > 0 and buyoutPrice > NS.db["maxItemPriceCopper"][NS.mode] then
		return "maxprice";
	elseif count == 1 and buyoutPrice > 0 and ( self.type ~= "SELECT" or buyoutPrice == self.query.auction[1] ) and ( quality == -1 or self.query.qualities[quality] ) then
		local auctionItemType = self:AuctionItemType( itemId );
		if not auctionItemType then return end -- Skip auctions that aren't the type we need
		--
		if self.query.qualities[quality] then
			itemLink = GetAuctionItemLink( "list", index ); -- Ignore missing quality (-1) to force retry
		end
		--
		if not itemLink then
			return "retry";
		else
			if self.type == "SHOP" or self.type == "GETALL" then
				local appearanceID,sourceID;
				--
				if auctionItemType == "possible-appearance" then
					if quality > 1 then -- Transmoggable gear is uncommon or higher quality
						appearanceID,sourceID = NS.GetAppearanceSourceInfo( itemLink );
						if not appearanceID then
							return "retry-possible-appearance"; -- Retry for appearanceID or if item has none then prevent inclusion after max retries
						end
						if not NS.FindKeyByValue( data["appearanceSources"], sourceID ) then
							data["appearanceSources"][#data["appearanceSources"] + 1] = sourceID; -- List of unique sources to update appearanceCollection
						end
					else
						return nil; -- No poor and common quality items
					end
				end
				--
				if not data["itemIds"][itemId] then
					data["itemIds"][itemId] = {}; -- Store auctions by itemId
				end
				-- Add auction
				data["itemIds"][itemId][#data["itemIds"][itemId] + 1] = {
					buyoutPrice, -- itemPrice
					itemLink,
					texture,
					quality,
					( levelColHeader == "REQ_LEVEL_ABBR" and level or 1 ), -- requiresLevel
					appearanceID,
					sourceID,
				};
			elseif self.type == "SELECT" and itemLink == self.query.auction[2] then -- itemLink(2)
				return "found";
			end
		end
	end
end
--
function NS.scan:QueryPageRetrieve()
	if self.status ~= "scanning" then return end -- Scan interrupted
	local batchAuctions, totalAuctions = GetNumAuctionItems( "list" );
	self.query.totalPages = ceil( totalAuctions / NUM_AUCTION_ITEMS_PER_PAGE );
	local auctionBatchNum,auctionBatchRetry,maxItemPriceExceeded,NextAuction,PageComplete;
	--
	if self.type == "SHOP" then
		NS.StatusFrame_Message( string.format( L["Scanning %s: Page %d of %d"], HIGHLIGHT_FONT_COLOR_CODE .. self.query.categoryName .. " > " .. self.query.subCategoryName .. FONT_COLOR_CODE_CLOSE, ( self.query.page + 1 ), self.query.totalPages ) );
	end
	--
	NextAuction = function()
		if self.status ~= "scanning" then return end -- Scan interrupted
		--
		if not auctionBatchRetry.inProgress or ( auctionBatchRetry.inProgress and auctionBatchRetry.auctionBatchNum[auctionBatchNum] ) then -- Not currently retrying or retrying and match
			local get = self:GetAuctionItemInfo( auctionBatchNum );
			if get == "retry" or ( get == "retry-possible-appearance" and ( not auctionBatchRetry.inProgress or auctionBatchRetry.attempts < 10 ) ) then
				-- Retry required
				if not auctionBatchRetry.inProgress then
					auctionBatchRetry.count = auctionBatchRetry.count + 1;
					auctionBatchRetry.auctionBatchNum[auctionBatchNum] = true;
				end
			else
				if get == "maxprice" then
					--
					-- MAX ITEM PRICE EXCEEDED!!!
					--
					maxItemPriceExceeded = true;
					return PageComplete();
				elseif get == "found" then
					--
					-- SELECT MATCH FOUND!!!
					--
					self.query.auction.found = true;
					self.query.auction.index = auctionBatchNum;
					return PageComplete();
				elseif auctionBatchRetry.inProgress then
					-- Retry successful (or max Appearance attempts)
					auctionBatchRetry.count = auctionBatchRetry.count - 1;
					auctionBatchRetry.auctionBatchNum[auctionBatchNum] = nil;
				end
			end
		end
		-- Batch Complete
		if auctionBatchNum == batchAuctions then
			if auctionBatchRetry.count > 0 and ( not auctionBatchRetry.inProgress or ( auctionBatchRetry.inProgress and auctionBatchRetry.attempts < auctionBatchRetry.attemptsMax ) ) then
				-- Start Batch Retry
				auctionBatchRetry.inProgress = true;
				auctionBatchRetry.attempts = auctionBatchRetry.attempts + 1;
				auctionBatchNum = 1;
				local after = auctionBatchRetry.attempts * 0.01;
				return C_Timer.After( after, NextAuction );
			else
				-- No Batch Retry
				return PageComplete();
			end
		else
			-- Auction Complete
			auctionBatchNum = auctionBatchNum + 1;
			return NextAuction();
		end
	end
	--
	PageComplete = function()
		if not maxItemPriceExceeded and ( self.type == "SHOP" or ( self.type == "SELECT" and not self.query.auction.found ) ) and self.query.page < ( self.query.totalPages - 1 ) then -- Subtract 1 because the first page is 0
			-- Query next page
			self.query.page = self.query.page + 1; -- Increment to next page
			self:QueryPageSend(); -- Send query for next page to scan
		else
			-- Query complete
			self.query.remaining = self.query.remaining - 1;
			self.query.page = 0; -- Reset to default
			if self.query.remaining == 0 then
				if self.type == "SHOP" then -- Live
					if NS.mode == "APPEARANCES" then
						self:UpdateAppearanceCollection(); -- SHOP scan "almost" complete
					else
						self:ImportShopData(); -- SHOP scan "almost" complete
					end
				else
					self:Complete(); -- SELECT scan complete
				end
			else
				self.query.queue[#self.query.queue - ( self.query.remaining - 1 )]();
				self:QueryPageSend();
			end
		end
	end
	--
	if batchAuctions == 0 then
		PageComplete();
	else
		auctionBatchNum = 1;
		auctionBatchRetry = { inProgress = false, count = 0, attempts = 0, attemptsMax = 50, auctionBatchNum = {} };
		NextAuction();
	end
end
--
function NS.scan:QueryGetAllRetrieve()
	if self.status ~= "scanning" then return end -- Scan interrupted
	local totalAuctions = GetNumAuctionItems( "list" );
	local auctionNum,auctionBatchNum,auctionBatchSize,auctionBatchRetry,NextAuction;
	--
	NextAuction = function()
		if self.status ~= "scanning" then return end -- Scan interrupted
		--
		if auctionNum <= totalAuctions then
			if not auctionBatchRetry.inProgress or ( auctionBatchRetry.inProgress and auctionBatchRetry.auctionBatchNum[auctionBatchNum] ) then -- Not currently retrying or retrying and match
				local get = self:GetAuctionItemInfo( auctionNum );
				if get == "retry" or ( get == "retry-possible-appearance" and ( not auctionBatchRetry.inProgress or auctionBatchRetry.attempts < 10 ) ) then
					-- Retry required
					if not auctionBatchRetry.inProgress then
						auctionBatchRetry.count = auctionBatchRetry.count + 1;
						auctionBatchRetry.auctionBatchNum[auctionBatchNum] = true;
					end
				elseif auctionBatchRetry.inProgress then
					-- Retry successful (or max Appearance attempts)
					auctionBatchRetry.count = auctionBatchRetry.count - 1;
					auctionBatchRetry.auctionBatchNum[auctionBatchNum] = nil;
				end
			end
			-- Batch Complete
			if auctionBatchNum == auctionBatchSize or auctionNum == totalAuctions then
				if auctionBatchRetry.count > 0 and ( not auctionBatchRetry.inProgress or ( auctionBatchRetry.inProgress and auctionBatchRetry.attempts < auctionBatchRetry.attemptsMax ) ) then
					-- Start Batch Retry
					auctionBatchRetry.inProgress = true;
					auctionBatchRetry.attempts = auctionBatchRetry.attempts + 1;
					auctionNum = ( auctionNum - auctionBatchNum ) + 1; -- Reset auctionNum to start of batch for retry
					auctionBatchNum = 1;
					local after = auctionBatchRetry.attempts * 0.01;
					return C_Timer.After( after, NextAuction );
				else
					-- NotRequired/Stop/Reset Batch Retry
					auctionBatchRetry.inProgress = false;
					auctionBatchRetry.count = 0;
					auctionBatchRetry.attempts = 0;
					wipe( auctionBatchRetry.auctionBatchNum );
					auctionBatchNum = 0; -- +1 @ auction complete
					NS.StatusFrame_Message( string.format( L["%s remaining auctions...\n\nCollecting auction item links for all modes."], HIGHLIGHT_FONT_COLOR_CODE .. ( totalAuctions - auctionNum ) .. FONT_COLOR_CODE_CLOSE ) );
				end
			end
			-- Auction Complete
			auctionNum = auctionNum + 1;
			auctionBatchNum = auctionBatchNum + 1;
			return NextAuction();
		else
			-- ALL AUCTIONS COMPLETE
			self:Complete();
		end
	end
	--
	auctionNum = 1;
	auctionBatchNum = 1;
	auctionBatchSize = 50;
	auctionBatchRetry = { inProgress = false, count = 0, attempts = 0, attemptsMax = 50, auctionBatchNum = {} };
	NextAuction();
end
--
function NS.scan:UpdateAppearanceCollection()
	local data1 = NS.db["live"] and NS.auction.data.live or NS.db["getAllScan"][NS.realmName]["data"];
	--
	NS.JumbotronFrame_Message( L["Updating Collection"] );
	--
	NS.BatchDataLoop( {
		data = data1["appearanceSources"],
		attemptsMax = 50,
		AbortFunction = function()
			if self.status ~= "scanning" then
				return true;
			end
		end,
		DataFunction = function( data, dataNum )
			local sourceID = data[dataNum];
			--
			if not NS.appearanceCollection.sources[sourceID] then -- Skip existing sources
				local isInfoReady, canCollect = C_TransmogCollection.PlayerCanCollectSource( sourceID );
				--
				if isInfoReady and canCollect then
					local categoryID,appearanceID,_,_,sourceCollected,itemLink = C_TransmogCollection.GetAppearanceSourceInfo( sourceID );
					if categoryID ~= 6 then -- Exclude TABARDSLOT
						-- Appearance
						if not NS.appearanceCollection.appearances[appearanceID] then
							local appearanceCollected = sourceCollected;
							if not sourceCollected then
								local sources = C_TransmogCollection.GetAllAppearanceSources( appearanceID );
								if sources then -- You never know, this API is wonky sometimes
									for i = 1, #sources do
										local _,_,_,_,isCollected = C_TransmogCollection.GetAppearanceSourceInfo( sources[i] );
										if isCollected then
											appearanceCollected = true;
											break; -- Stop ASAP
										end
									end
								end
							end
							NS.appearanceCollection.appearances[appearanceID] = { nil, appearanceCollected }; -- nil was categoryID but is not currently being used
						end
						-- Source
						NS.appearanceCollection.sources[sourceID] = { appearanceID, sourceCollected };
						-- ItemID
						local itemId = tonumber( string.match( itemLink, "item:(%d+):" ) );
						local itemIdKey = NS.FindKeyByField( NS.appearanceItemIds, 1, itemId );
						if not itemIdKey then
							NS.appearanceItemIds[#NS.appearanceItemIds + 1] = { itemId, categoryID };
						end
					end
				elseif not isInfoReady then
					return "retry";
				end
			end
		end,
		EndBatchFunction = function( data, dataNum )
			NS.StatusFrame_Message( string.format( L["%s items remaining..."], HIGHLIGHT_FONT_COLOR_CODE .. ( #data - dataNum ) .. FONT_COLOR_CODE_CLOSE ) );
		end,
		CompleteFunction = function()
			if not NS.db["live"] then
				NS.appearanceCollection.getAllReady = true;
			end
			NS.JumbotronFrame_Message( L["Shopping"] );
			self:ImportShopData();
		end,
	} );
end
--
function NS.scan:ImportShopData()
	local data = NS.db["live"] and NS.auction.data.live.itemIds or NS.db["getAllScan"][NS.realmName]["data"]["itemIds"];
	local itemIds = ( NS.mode == "MOUNTS" and NS.mountItemIds ) or ( NS.mode == "PETS" and NS.petItemIds ) or ( NS.mode == "TOYS" and NS.toyItemIds ) or ( NS.mode == "APPEARANCES" and NS.appearanceItemIds );
	--
	local itemNum,itemId,category,speciesID,appearanceID,petLevel,sourceID,auctionNum,auctionBatchNum,auctionBatchSize,getAppearanceAttempts,getAppearanceAttemptsMax,NextItem,NextAuction,AdvanceBatch,AddToGroup,GetAppearance;
	--
	AddToGroup = function()
		if self.status ~= "scanning" then return end
		local groupId = ( NS.mode == "MOUNTS" and itemId ) or ( NS.mode == "PETS" and ( ( NS.db["modeFilters"][NS.mode][NS.modeFilters[5][1][1]] and speciesID ) or ( itemId == 82800 and data[itemId][auctionNum][2] ) or itemId ) ) or ( NS.mode == "TOYS" and itemId ) or ( NS.mode == "APPEARANCES" and ( NS.shopAppearancesBy == "appearance" and appearanceID or sourceID ) ); -- 82800 is Pet Cage for Battle Pets, misc(5), Group By Species(1), key(1), itemLink(2)
		local groupKey = NS.AuctionDataGroups_FindGroupKey( groupId );
		if not groupKey then
			groupKey = #NS.auction.data.groups + 1;
			NS.auction.data.groups[groupKey] = {
				groupId,		-- [1] itemId or speciesID or itemLink or appearanceID or sourceID
				"",				-- [2] itemName
				category,		-- [3] category
				0,				-- [4] itemPrice
				{},				-- [5] auctions
				0,				-- [6] lvl
				0,				-- [7] pctItemValue
			};
		end
		-- Add data to auction data groups
		NS.auction.data.groups[groupKey][5][#NS.auction.data.groups[groupKey][5] + 1] = CopyTable( data[itemId][auctionNum] ); -- Add to auctions(5)
		NS.auction.data.groups[groupKey][5][#NS.auction.data.groups[groupKey][5]][6] = itemId; -- Add itemId(6) to auction
		NS.auction.data.groups[groupKey][5][#NS.auction.data.groups[groupKey][5]][7] = category; -- Add category(7) to auction
		NS.auction.data.groups[groupKey][5][#NS.auction.data.groups[groupKey][5]][8] = ( NS.mode == "PETS" and speciesID ) or ( NS.mode == "APPEARANCES" and appearanceID ) or nil; -- Add speciesID(8) or appearanceID(8) to auction
		NS.auction.data.groups[groupKey][5][#NS.auction.data.groups[groupKey][5]][9] = ( NS.mode == "PETS" and petLevel ) or ( NS.mode == "APPEARANCES" and sourceID ) or nil; -- Add petLevel(9) or sourceID(9) to auction
		return AdvanceBatch();
	end
	--
	AdvanceBatch = function()
		auctionNum = auctionNum + 1;
		if auctionBatchNum == auctionBatchSize then
			NS.StatusFrame_Message( string.format( L["%s remaining items..."], HIGHLIGHT_FONT_COLOR_CODE .. ( #itemIds - itemNum ) .. FONT_COLOR_CODE_CLOSE ) );
			auctionBatchNum = 1;
			return C_Timer.After( 0.001, NextAuction );
		else
			auctionBatchNum = auctionBatchNum + 1;
			return NextAuction();
		end
	end
	--
	NextAuction = function()
		if self.status ~= "scanning" then return end
		--
		if auctionNum <= #data[itemId] then
			-- Filter: Quality
			-- Option: Max Item Price
			if self.query.qualities[data[itemId][auctionNum][4]] and ( NS.db["maxItemPriceCopper"][NS.mode] == 0 or data[itemId][auctionNum][1] <= NS.db["maxItemPriceCopper"][NS.mode] ) then
				local discard;
				if NS.mode == "MOUNTS" then
					if NS.mountCollection[itemId] and ( ( NS.mountCollection[itemId] == 0 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][1][1]] ) or ( NS.mountCollection[itemId] > 0 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] ) ) then -- collected(3), Not Collected(1)/Collected(2), key(1)
						discard = true;
					end
				elseif NS.mode == "PETS" then
					if itemId == 82800 then
						-- Battle Pet
						local _;
						_,speciesID,petLevel = strsplit( ":", data[itemId][auctionNum][2] ); -- battlepet:0:speciesID:level:breedQuality:maxHealth:power:speed:customName
						speciesID,petLevel = tonumber( speciesID ), tonumber( petLevel );
					else
						-- Companion Pet
						speciesID,petLevel = NS.petInfo[itemId][1], 1;
					end
					-- Filter: category
					category = AuctionCategories[10].subCategories[select( 3, C_PetJournal.GetPetInfoBySpeciesID( speciesID ) )].name;
					if not NS.db["modeFilters"][NS.mode][category] then
						discard = true;
					end
					-- Filter: collected
					if not discard then
						local collected,collectedMax;
						if not NS.petCollection[speciesID] then
							collected,collectedMax = C_PetJournal.GetNumCollectedInfo( speciesID );
							NS.petCollection[speciesID] = { collected, collectedMax };
						else
							collected,collectedMax = unpack( NS.petCollection[speciesID] );
						end
						if collected == 0 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][1][1]] then -- collected(3), Collected (0/3)(1), key(1)
							discard = true;
						elseif collected > 0 and collected < collectedMax and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] then -- collected(3), Collected (1-2/3)(2), key(1)
							discard = true;
						elseif collected == collectedMax and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][3][1]] then -- collected(3), Collected (3/3)(3), key(1)
							discard = true;
						end
					end
					-- Filter: petLevels
					if not discard then
						if petLevel <= 10 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[4][1][1]] then -- petLevels(4), Level 1-10(1), key(1)
							discard = true;
						elseif petLevel >= 11 and petLevel <= 15 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[4][2][1]] then -- petLevels(4), Level 11-15(2), key(1)
							discard = true;
						elseif petLevel >= 16 and petLevel <= 20 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[4][3][1]] then -- petLevels(4), Level 16-20(3), key(1)
							discard = true;
						elseif petLevel >= 21 and petLevel <= 24 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[4][4][1]] then -- petLevels(4), Level 21-24(4), key(1)
							discard = true;
						elseif petLevel == 25 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[4][5][1]] then -- petLevels(4), Level 25(5), key(1)
							discard = true;
						end
					end
				elseif NS.mode == "TOYS" then
					if NS.toyCollection[itemId] and ( ( NS.toyCollection[itemId] == 0 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][1][1]] ) or ( NS.toyCollection[itemId] > 0 and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] ) ) then -- collected(3), Not Collected(1)/Collected(2), key(1)
						discard = true;
					end
				end
				if not discard and ( ( NS.mode == "PETS" or NS.db["modeFilters"][NS.mode][NS.modeFilters[5][1][1]] ) or data[itemId][auctionNum][5] <= NS.linkLevel ) then -- misc(5), Requires Level(1), key(1), requiresLevel(5)
					if NS.mode == "APPEARANCES" then
						appearanceID, sourceID = data[itemId][auctionNum][6], data[itemId][auctionNum][7]; -- appearanceID(6), sourceID(7)
						if NS.appearanceCollection.appearances[appearanceID] and ( ( not NS.appearanceCollection.appearances[appearanceID][2] and NS.db["modeFilters"][NS.mode][NS.modeFilters[3][1][1]] ) or ( NS.appearanceCollection.appearances[appearanceID][2] and not NS.appearanceCollection.sources[sourceID][2] and NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] ) or ( NS.appearanceCollection.appearances[appearanceID][2] and NS.appearanceCollection.sources[sourceID][2] and NS.db["modeFilters"][NS.mode][NS.modeFilters[3][3][1]] ) ) then -- isCollected(2)
							return AddToGroup();
						else
							return AdvanceBatch();
						end
					else
						return AddToGroup();
					end
				end
			end
			--
			return AdvanceBatch();
		else
			itemNum = itemNum + 1;
			return NextItem();
		end
	end
	--
	NextItem = function()
		if self.status ~= "scanning" then return end
		--
		if itemNum <= #itemIds then
			itemId = NS.mode == "APPEARANCES" and itemIds[itemNum][1] or itemIds[itemNum];
			category = ( NS.mode == "MOUNTS" and AuctionCategories[12].subCategories[5].name ) or ( NS.mode == "PETS" and "tbd" ) or ( NS.mode == "TOYS" and AuctionCategories[NS.toyInfo[itemId][1]].subCategories[NS.toyInfo[itemId][2]].name .. " (" .. AuctionCategories[NS.toyInfo[itemId][1]].name .. ")" ) or ( NS.mode == "APPEARANCES" and NS.appearanceCollection.categoryNames[itemIds[itemNum][2]] );
			--
			if ( NS.mode == "MOUNTS" or ( NS.mode == "PETS" and ( itemId == 82800 or NS.db["modeFilters"][NS.mode][NS.modeFilters[2][#NS.modeFilters[2]][1]] ) ) or ( NS.mode == "TOYS" and NS.db["modeFilters"][NS.mode][category] ) or ( NS.mode == "APPEARANCES" and NS.db["modeFilters"][NS.mode][category] ) ) and data[itemId] then -- categories(2), Companion Pets(#2), key(1)
				-- Start auctions for item
				auctionNum = 1;
				return NextAuction();
			else
				-- Skip item, category not checked or no auctions
				itemNum = itemNum + 1;
				return NextItem();
			end
		else
			-- ALL ITEMS COMPLETE
			for groupKey = 1, #NS.auction.data.groups do
				NS.Sort( NS.auction.data.groups[groupKey][5], 1, "ASC" ); -- auctions(5) by itemPrice(1) in ASC
				NS.AuctionDataGroups_UpdateGroup( groupKey ); -- Update itemName and itemPrice and Lvl to match first auction in group
			end
			--
			NS.StatusFrame_Message( L["Filtering, one moment please..."] );
			self:FilterGroups( function() self:Complete() end );
		end
	end
	--
	itemNum = 1;
	auctionBatchNum = 1;
	auctionBatchSize = 50;
	NextItem();
end
--
function NS.scan:FilterGroups( OnComplete, groupKey )
	-- Filter: Red - Crafting Professions
	NS.AuctionDataGroups_Filter( groupKey, function( group )
		return NS.FindInTooltip( group[5][1][2], { r=255, g=32, b=32 }, NS.craftingProfessions, 4 ); -- auctions(5), first auction(1), itemLink(2)
	end, function()
		-- Filter: Red - Requires Riding Skill
		NS.AuctionDataGroups_Filter( groupKey, function( group )
			return NS.FindInTooltip( group[5][1][2], { r=255, g=32, b=32 }, NS.ridingSpells, 4 ); -- auctions(5), first auction(1), itemLink(2)
		end, function()
			-- Complete
			return OnComplete();
		end, false, ( NS.mode == "MOUNTS" and not NS.db["modeFilters"][NS.mode][NS.modeFilters[5][3][1]] or false ) ); -- misc(5), Requires Riding Skill(3), key(1)
	end, false, ( NS.mode ~= "PETS" and not NS.db["modeFilters"][NS.mode][NS.modeFilters[5][2][1]] ) ); -- misc(5), Requires Profession(2), key(1)
end
--
function NS.scan:Complete( cancelMessage )
	if self.status ~= "scanning" then return end -- Scan interrupted
	--
	if self.type == "SELECT" then
		-- SELECT: If not found, remove auction. Otherwise, set status to "Selected" and activate buyout frame
		if not self.query.auction.found then
			-- NOT FOUND
			NS.Print( string.format( L["%s for %s is no longer available and has been removed"], self.query.auction[2], NS.MoneyToString( self.query.auction[1] ) ) ); -- itemLink(2), itemPrice(1)
			return NS.AuctionGroup_AuctionMissing( self.query.auction.groupKey, function()
				-- OnMessageOnly
				NS.AuctionSortButtons_Action( "Enable" );
				NS.disableFlyoutChecks = false;
				AuctionFrameCollectionShop_FlyoutPanel_ScrollFrame:Update();
				AuctionFrameCollectionShop_ScanButton:Reset();
				AuctionFrameCollectionShop_ShopButton:Reset();
			end );
		else
			-- FOUND
			self.status = "selected";
			if NS.mode ~= "TOYS" then
				AuctionFrameCollectionShop_FlyoutPanel:Hide();
				-- Mount and Pets DressUp data
				local creatureID,displayID;
				if NS.mode == "MOUNTS" or NS.mode == "PETS" then
					if NS.mode == "MOUNTS" then
						-- Mount
						creatureID,displayID = nil, NS.mountInfo[self.query.auction[6]][1]; -- itemId(6), displayID(1)
					elseif self.query.auction[6] == 82800 then -- itemId(6)
						-- Battle Pet
						creatureID,displayID = GetAuctionItemBattlePetInfo( "list", self.query.auction.index );
					else
						-- Companion Pet
						creatureID,displayID = NS.petInfo[self.query.auction[6]][2], 0; -- itemId(6), creatureID(2)
					end
				end
				-- DressUp to open SideDressUpFrame
				if not SideDressUpFrame:IsShown() then
					if NS.mode == "APPEARANCES" then
						DressUpVisual( self.query.auction[2] ); -- itemLink(2)
					elseif ( creatureID or displayID ) then
						DressUpBattlePet( creatureID, displayID );
					end
				end
				-- DressUp for real
				if NS.mode == "APPEARANCES" then
					-- Appearance
					if NS.db["undressCharacter"] then
						SideDressUpModel:Undress();
						PlaySound( 798 ); -- gsTitleOptionOK: Keeps the sound consistent with the ResetButton click below
					else
						SideDressUpModelResetButton:Click(); -- ^^
					end
					DressUpVisual( self.query.auction[2] ); -- itemLink(2)
				elseif ( creatureID or displayID ) then
					-- Mount or Pet
					DressUpBattlePet( creatureID, displayID );
					-- DressUp again after delay to allow model time to load if not seen before
					local dressUpID = ( creatureID and creatureID ~= 0 ) and creatureID or displayID;
					if not NS.cachedDressUpIds[dressUpID] then
						C_Timer.After( 0.3, function() DressUpBattlePet( creatureID, displayID ); end );
						NS.cachedDressUpIds[dressUpID] = true;
					end
				else
					NS.Print( string.format( L["%s cannot be previewed, no model data. Please report to addon developer"], self.query.auction[2] ) ); -- itemLink(2)
				end
			end
			NS.BuyoutFrame_Activate();
			AuctionFrameCollectionShop_BuyAllButton:Enable();
		end
	elseif self.type == "SHOP" then
		-- SHOP: Clicked the "Shop" button
		self.status = "ready";
		wipe( self.query.queue );
		wipe( NS.auction.data.live.itemIds );
		wipe( NS.auction.data.live.appearanceSources );
		--
		collectgarbage( "collect" );
		NS.AuctionDataGroups_Sort();
		AuctionFrameCollectionShop_JumbotronFrame:Hide();
		AuctionFrameCollectionShop_ScrollFrame:Update();
		--
		if #NS.auction.data.groups > 0 then
			NS.StatusFrame_Message( NS.SELECT_AN_AUCTION() );
			AuctionFrameCollectionShop_BuyAllButton:Enable();
		else
			NS.StatusFrame_Message( cancelMessage or L["No auctions were found that matched your settings"] );
		end
	elseif self.type == "GETALL" then
		-- GETALL: Clicked the "Scan" button
		self.status = "ready";
		collectgarbage( "collect" );
		if ( CanSendAuctionQuery() ) then
			QueryAuctionItems( "CLEAR_BROWSE_FRAME_RESULTS", nil, nil, 0, false, nil, false, false, nil ); -- Prevents WoW from crashing on subsequent queries, not sure why
		end
		NS.JumbotronFrame_Message( L["Auction House scan complete. Ready"] );
		NS.StatusFrame_Message( string.format( L["Blizzard allows a GetAll scan once every %s. Press \"Shop\""], RED_FONT_COLOR_CODE .. L["15 min"] .. FONT_COLOR_CODE_CLOSE ) );
		NS.UpdateTimeSinceLastScan();
	end
	--
	NS.AuctionSortButtons_Action( "Enable" );
	NS.disableFlyoutChecks = false;
	AuctionFrameCollectionShop_FlyoutPanel_ScrollFrame:Update();
	AuctionFrameCollectionShop_LiveCheckButton:Enable();
	AuctionFrameCollectionShop_ScanButton:Reset();
	AuctionFrameCollectionShop_ShopButton:Reset();
end
--
function NS.scan:OnChatMsgSystem( ... ) -- CHAT_MSG_SYSTEM
	local arg1 = ...;
	if not arg1 then return end
	if arg1 == ERR_AUCTION_BID_PLACED then
		-- Bid Acccepted.
		self.ailu = "IGNORE"; -- Ignore the list update after "Bid accepted."
		CollectionShopEventsFrame:RegisterEvent( "AUCTION_ITEM_LIST_UPDATE" );
	elseif arg1 == string.format( ERR_AUCTION_WON_S, NS.auction.data.groups[self.query.auction.groupKey][2] ) then -- itemName(2)
		-- You won an auction for %s
		self.ailu = "AUCTION_WON"; -- Helps decide to Ignore or Listen to the list update after "You won an auction for %s"
		CollectionShopEventsFrame:RegisterEvent( "AUCTION_ITEM_LIST_UPDATE" );
		CollectionShopEventsFrame:UnregisterEvent( "CHAT_MSG_SYSTEM" );
	end
end
--
function NS.scan:OnUIErrorMessage( ... ) -- UI_ERROR_MESSAGE
	local arg2 = select( 2, ... );
	if not arg2 then return end
	if self.status ~= "buying" then
		-- Not Buying
		if arg2 == ERR_AUCTION_DATABASE_ERROR then
			NS.Print( RED_FONT_COLOR_CODE .. arg2 .. FONT_COLOR_CODE_CLOSE );
			return NS.Reset(); -- Reset on Internal Auction Error
		else
			return -- Ignore errors unexpected when not buying an auction
		end
	elseif (
		-- Buying
		arg2 ~= ERR_AUCTION_DATABASE_ERROR and
		arg2 ~= ERR_ITEM_NOT_FOUND and
		arg2 ~= ERR_AUCTION_HIGHER_BID and
		arg2 ~= ERR_AUCTION_BID_OWN and
		arg2 ~= ERR_NOT_ENOUGH_MONEY and
		arg2 ~= ERR_RESTRICTED_ACCOUNT and	-- Starter Edition account
		arg2 ~= ERR_ITEM_MAX_COUNT ) then
		return -- Ignore errors unexpected during buying an auction
	end
	--
	-- Handle error expected when buying an auction
	--
	CollectionShopEventsFrame:UnregisterEvent( "CHAT_MSG_SYSTEM" );
	--
	if arg2 == ERR_ITEM_NOT_FOUND or arg2 == ERR_AUCTION_HIGHER_BID or arg2 == ERR_AUCTION_BID_OWN then
		if arg2 == ERR_ITEM_NOT_FOUND or arg2 == ERR_AUCTION_HIGHER_BID then
			NS.Print( RED_FONT_COLOR_CODE .. L["That auction is no longer available and has been removed"] .. FONT_COLOR_CODE_CLOSE );
		elseif arg2 == ERR_AUCTION_BID_OWN then
			NS.Print( RED_FONT_COLOR_CODE .. L["That auction belonged to a character on your account and has been removed"] .. FONT_COLOR_CODE_CLOSE );
		end
		--
		return NS.AuctionGroup_AuctionMissing( self.query.auction.groupKey, function()
			-- OnMessageOnly
			NS.AuctionSortButtons_Action( "Enable" );
			AuctionFrameCollectionShop_ScanButton:Reset();
			AuctionFrameCollectionShop_ShopButton:Enable();
		end );
	else
		self.status = "ready";
		NS.StatusFrame_Message( arg2 );
		AuctionFrameCollectionShop_BuyAllButton:Enable();
	end
	--
	NS.AuctionSortButtons_Action( "Enable" );
	AuctionFrameCollectionShop_ScanButton:Reset();
	AuctionFrameCollectionShop_ShopButton:Enable();
end
--
function NS.scan:AfterAuctionWon()
	self.ailu = "IGNORE";
	-- Update buyouts and money spent
	NS.numAuctionsWon = NS.numAuctionsWon + 1;
	NS.copperAuctionsWon = NS.copperAuctionsWon + self.query.auction[1]; -- itemPrice(1)
	self.query.auction.modeNum = NS.modeNums[NS.mode];
	table.insert( NS.auctionsWon, CopyTable( self.query.auction ) ); -- auction
	-- Remove ONE matching auction from GetAll scan data
	if not NS.db["live"] then
		local scanAuctions = NS.db["getAllScan"][NS.realmName]["data"]["itemIds"][self.query.auction[6]];
		for auction = 1, #scanAuctions do
			if #NS.auction.data.groups == 0 then return end -- Check for Reset
			-- Match by itemPrice(1) and itemLink(2)
			if scanAuctions[auction][1] == self.query.auction[1] and ( self.query.auction[6] == 82800 and scanAuctions[auction][2] or NS.NormalizeItemLink( scanAuctions[auction][2] ) ) == self.query.auction[2] then -- Don't waste precious time here normalizing a battlepet: itemLink
				table.remove( scanAuctions, auction );
				break; -- Just ONE
			end
		end
		if #scanAuctions == 0 then
			scanAuctions = nil; -- Remove empty itemId from scan data
		end
	end
	-- Update collection counts and decide what to remove from Groups
	local removeGroup,removeSpecies;
	if NS.mode == "MOUNTS" then
		NS.mountCollection[self.query.auction[6]] = 1; -- itemId(6), collected(1)
		if not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] then -- collected(3), Collected(2), key(1)
			removeGroup = true;
		end
	elseif NS.mode == "PETS" then
		NS.petCollection[self.query.auction[8]][1] = math.min( ( NS.petCollection[self.query.auction[8]][1] + 1 ), NS.petCollection[self.query.auction[8]][2] ); -- speciesID(8), collected(1), collectedMax(2)
		local collected,collectedMax = unpack( NS.petCollection[self.query.auction[8]] );
		if ( collected < collectedMax and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] ) or ( collected == collectedMax and not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][3][1]] ) then -- collected(3), Collected (1-2/3)(2)/Collected (3/3)(3), key(1)
			removeSpecies = true;
		end
	elseif NS.mode == "TOYS" then
		NS.toyCollection[self.query.auction[6]] = 1; -- item(6), collected(1)
		if not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][2][1]] then -- collected(3), Collected(2), key(1)
			removeGroup = true;
		end
	elseif NS.mode == "APPEARANCES" then
		NS.appearanceCollection.appearances[self.query.auction[8]][2] = true; -- appearanceID(8), isCollected(2)
		NS.appearanceCollection.sources[self.query.auction[9]][2] = true; -- sourceID(9), isCollected(2)
		if NS.shopAppearancesBy == "appearance" or not NS.db["modeFilters"][NS.mode][NS.modeFilters[3][3][1]] then -- collected(3), Collected - Known Sources(3), key(1)
			removeGroup = true;
		end
	end
	-- Remove Group(s) or Auction
	local groupId; -- If Auction removed instead of Group, we need groupKey to reselect
	if removeGroup or ( removeSpecies and NS.db["modeFilters"][NS.mode][NS.modeFilters[5][1][1]] ) then -- misc(5), Group By Species(1), key(1)
		NS.AuctionDataGroups_RemoveGroup( self.query.auction.groupKey );
	elseif removeSpecies and not NS.db["modeFilters"][NS.mode][NS.modeFilters[5][1][1]] then -- misc(5), Group By Species(1), key(1)
		local groupKey = 1;
		while groupKey <= #NS.auction.data.groups do
			if NS.auction.data.groups[groupKey][5][1][8] == self.query.auction[8] then -- auctions(5), first auction(1), speciesID(8)
				NS.AuctionDataGroups_RemoveGroup( groupKey );
			else
				groupKey = groupKey + 1;
			end
		end
	elseif NS.AuctionDataGroups_RemoveAuction( self.query.auction.groupKey ) == "auction" then
		groupId = NS.auction.data.groups[NS.scan.query.auction.groupKey][1];
	end
	--
	NS.AuctionGroup_Deselect();
	if #NS.auction.data.groups > 0 then
		-- More groups exist
		if NS.buyAll then
			return NS.AuctionGroup_OnClick( 1 );
		elseif groupId then
			NS.AuctionDataGroups_Sort();
			NS.NextAdjustScroll = true;
			return NS.AuctionGroup_OnClick( NS.AuctionDataGroups_FindGroupKey( groupId ) );
		else
			NS.StatusFrame_Message( NS.SELECT_AN_AUCTION() );
			AuctionFrameCollectionShop_BuyAllButton:Enable();
		end
	else
		-- No groups exist
		NS.StatusFrame_Message( L["No additional auctions matched your settings"] );
		AuctionFrameCollectionShop_BuyAllButton:Reset();
	end
	--
	NS.AuctionSortButtons_Action( "Enable" );
	AuctionFrameCollectionShop_ScanButton:Reset();
	AuctionFrameCollectionShop_ShopButton:Enable();
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Mounts, Toys, & Appearances
--------------------------------------------------------------------------------------------------------------------------------------------
NS.UpdateMountCollection = function()
	local addonMountsTotal = NS.Count( NS.mountInfo );
	local addonmountsUpdated = 0;
	--
	local mountIDs = C_MountJournal.GetMountIDs();
	for i = 1, #mountIDs do
		local _,spellID,_,_,_,_,_,_,_,_,isCollected = C_MountJournal.GetMountInfoByID( mountIDs[i] );
		local creatureDisplayID = C_MountJournal.GetMountInfoExtraByID( mountIDs[i] );
		local itemId = NS.PairsFindKeyByField( NS.mountInfo, 2, spellID );
		if itemId then
			NS.mountCollection[itemId] = isCollected and 1 or 0;
			addonmountsUpdated = addonmountsUpdated + 1;
			if addonmountsUpdated == addonMountsTotal then
				break;
			end
		end
	end
	NS.Reset();
end
--
NS.UpdateToyCollection = function()
	for itemId,_ in pairs( NS.toyInfo ) do
		NS.toyCollection[itemId] = PlayerHasToy( itemId ) and 1 or 0;
	end
	NS.Reset();
end
--
NS.GetAppearanceSourceInfo = function( itemLink )
    local _,_,_,invType = GetItemInfoInstant( itemLink );
    local slotId = NS.invTypeToSlotId[invType];
	if NS.linkSpecID == 72 and invType == "INVTYPE_2HWEAPON" and GetInventoryItemID( "player", slotId ) then
		slotId = 17; -- Fury Warrior requires 2H Weapons in the "Off Hand" unless no weapon is equipped in the "Main Hand"
	end
    NS.Model:Undress();
    NS.Model:TryOn( itemLink, slotId );
    local sourceID = NS.Model:GetSlotTransmogSources( slotId );
    if sourceID then
		local _,appearanceID = C_TransmogCollection.GetAppearanceSourceInfo( sourceID );
        return appearanceID, sourceID;
    else
		return nil;
	end
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- Slash Commands
--------------------------------------------------------------------------------------------------------------------------------------------
NS.SlashCmdHandler = function( cmd )
	if not NS.initialized then return end
	--
	if cmd == "buyoutbuttonclick" and NS.IsTabShown() then
		AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton:Click();
		return; -- Stop function
	end
	--
	if NS.options.MainFrame:IsShown() then
		NS.options.MainFrame:Hide();
	elseif cmd == "" or cmd == "options" then
		NS.options.MainFrame:ShowTab( 1 );
	elseif cmd == "buyouts" then
		NS.options.MainFrame:ShowTab( 2 );
	elseif cmd == "getallscandata" then
		NS.options.MainFrame:ShowTab( 3 );
	elseif cmd == "help" then
		NS.options.MainFrame:ShowTab( 4 );
	elseif cmd == "data" then
		if NS.db["getAllScan"][NS.realmName] then
			local data = NS.db["getAllScan"][NS.realmName]["data"];
			local uniqueItemIds = NS.Count( data["itemIds"] );
			local auctions = 0;
			local appearanceSources = #data["appearanceSources"];
			for itemId,_ in pairs( data["itemIds"] ) do
				auctions = NS.Count( data["itemIds"][itemId] ) + auctions;
			end
			NS.Print( GREEN_FONT_COLOR_CODE .. string.format( L["Realm: %s, UniqueItemIds: %d, Auctions: %d, Appearance Sources: %d"], NS.realmName, uniqueItemIds, auctions, appearanceSources ) .. FONT_COLOR_CODE_CLOSE );
		else
			NS.Print( RED_FONT_COLOR_CODE .. string.format( L["Realm: %s, No data"], NS.realmName ) .. FONT_COLOR_CODE_CLOSE );
		end
	elseif string.match( cmd, "^app" ) or string.match( cmd, "^appearance" ) then
		if not NS.IsTabShown() then
			NS.Print( string.format( L["%s auction house tab must be shown."], NS.title ) );
			return; -- STOP
		end
		local _,itemIdStringLink = strsplit( " ", strtrim( cmd ), 2 );
		if itemIdStringLink then
			NS.GetItemInfo( itemIdStringLink, function( itemName,itemLink,_,_,_,_,_,_,invType,texture )
				local itemID = itemLink and GetItemInfoInstant( itemLink ) or nil;
				--
				if not itemID then
					NS.Print( string.format( L["%s, item not found"], itemIdStringLink ) );
					return; -- STOP
				end
				--
				if not invType then
					NS.Print( string.format( L["%s, invType missing"], itemLink ) );
					return; -- STOP
				end
				--
				local slotId = NS.invTypeToSlotId[invType];
				--
				if not slotId then
					NS.Print( string.format( L["%s, slotId missing"], itemLink ) );
					return; -- STOP;
				end
				--
				local appearanceID,sourceID = NS.GetAppearanceSourceInfo( itemLink );
				--
				if not appearanceID or not sourceID then
					NS.Print( string.format( L["%s, appearanceID or sourceID missing"], itemLink ) );
					return; -- STOP
				end
				-- Reverse Lookup
				local _,rlAppearanceID,_,rlTexture = C_TransmogCollection.GetAppearanceSourceInfo( sourceID );
				--
				if appearanceID ~= rlAppearanceID or texture ~= rlTexture then
					NS.Print( string.format( L["%s, model malfunction, data mismatch"], itemLink ) );
					return; -- STOP
				end
				--
				NS.Print( string.format( L["ItemID: %s, invType: %s, slotId: %s"], itemID, invType, slotId ) );
				NS.Print( string.format( L["AppearanceID: %s, SourceID: %s, |T%s:32|t %s"], appearanceID, sourceID, texture, itemLink ) );
			end );
		else
			NS.Print( "/cs appearance [itemID] or [itemString] or [itemLink]" );
		end
	else
		NS.options.MainFrame:ShowTab( 4 );
		NS.Print( L["Unknown command, opening Help"] );
	end
end
--
SLASH_COLLECTIONSHOP1 = "/collectionshop";
SLASH_COLLECTIONSHOP2 = "/cs";
SlashCmdList["COLLECTIONSHOP"] = function( msg ) NS.SlashCmdHandler( msg ) end;
--------------------------------------------------------------------------------------------------------------------------------------------
-- CollectionShopInterfaceOptionsPanel : Interface > Addons > CollectionShop
--------------------------------------------------------------------------------------------------------------------------------------------
--[[
NS.Frame( "CollectionShopInterfaceOptionsPanel", UIParent, {
	topLevel = true,
	hidden = true,
	setPoint = { "TOPLEFT" },
	OnLoad = function( self )
		self.name = NS.title;
	end,
} );
NS.TextFrame( "Text", CollectionShopInterfaceOptionsPanel, L["Use either slash command, /cs or /collectionshop"], {
	setAllPoints = true,
	setPoint = { "TOPLEFT", 16, -16 },
	justifyV = "TOP",
} );
--]]
--------------------------------------------------------------------------------------------------------------------------------------------
-- "CollectionShop" AuctionFrame Tab (AuctionFrameCollectionShop)
--------------------------------------------------------------------------------------------------------------------------------------------
NS.Blizzard_AuctionUI_OnLoad = function()
	if AuctionFrameCollectionShop then return end -- Make absolute sure this code only runs once
	NS.tsmPriceSources = TSMAPI and TSMAPI:GetPriceSources() or nil; -- TSM Price Sources
	--
	NS.Frame( "AuctionFrameCollectionShop", UIParent, {
		topLevel = true,
		hidden = true,
		size = { 824, 447 }, --f:SetSize( 758, 447 ); 66 x removed from close button
		OnShow = NS.Reset,
		OnHide = NS.Reset,
	} );
	NS.Model = NS.Frame( "_DressUpModel", AuctionFrameCollectionShop, {
		type = "DressUpModel",
		OnLoad = function( self )
			self:SetUnit( "player" );
		end,
	} );
	NS.GameTooltip = NS.Frame( NS.addon .. "_GameTooltip", UIParent, {
		topLevel = true,
		type = "GameTooltip",
		OnLoad = function( self )
			self:SetOwner( UIParent, "ANCHOR_NONE" );
			self:AddFontStrings(
				self:CreateFontString( "$parentTextLeft1", nil, "GameTooltipText" ),
				self:CreateFontString( "$parentTextRight1", nil, "GameTooltipText" )
			);
		end,
	} );
	NS.TextFrame( "_Title", AuctionFrameCollectionShop, "", {
		setPoint = {
			{ "TOPLEFT", 74, -24 },
			{ "RIGHT", -20, 0 },
		},
		justifyH = "CENTER",
	} );
	NS.CheckButton( "_UndressCharacterCheckButton", AuctionFrameCollectionShop, L["Undress Character"], {
		template = "InterfaceOptionsSmallCheckButtonTemplate",
		size = { 16, 16 },
		setPoint = { "RIGHT", "#sibling", "RIGHT", -100, 0 },
		tooltip = L["Show character with\nselected item only"],
		db = "undressCharacter",
	} );
	NS.TextFrame( "_MaxItemPriceFrame", AuctionFrameCollectionShop, "", {
		size = { 150, 16 },
		setPoint = { "LEFT", "$parent_Title", "LEFT", 3, 0 },
		fontObject = "GameFontHighlightSmall",
	} );
	NS.Button( "_NameSortButton", AuctionFrameCollectionShop, NAME, {
		template = "AuctionSortButtonTemplate",
		size = { 297, 19 },
		setPoint = { "TOPLEFT", 65, -52 },
		OnClick = function( self )
			NS.AuctionSortButton_OnClick( self, 2 );
		end,
	} );
	NS.Button( "_LvlSortButton", AuctionFrameCollectionShop, L["Lvl"], {
		template = "AuctionSortButtonTemplate",
		size = { 54, 19 },
		setPoint = { "TOPLEFT", "#sibling", "TOPRIGHT", -2, 0 },
		OnClick = function( self )
			NS.AuctionSortButton_OnClick( self, 6 );
		end,
	} );
	NS.Button( "_CategorySortButton", AuctionFrameCollectionShop, L["Category"], {
		template = "AuctionSortButtonTemplate",
		size = { 202, 19 },
		setPoint = { "TOPLEFT", "#sibling", "TOPRIGHT", -2, 0 },
		OnClick = function( self )
			NS.AuctionSortButton_OnClick( self, 3 );
		end,
	} );
	NS.Button( "_ItemPriceSortButton", AuctionFrameCollectionShop, L["Item Price"], {
		template = "AuctionSortButtonTemplate",
		size = { 188, 19 },
		setPoint = { "TOPLEFT", "#sibling", "TOPRIGHT", -2, 0 },
		OnClick = function( self )
			NS.AuctionSortButton_OnClick( self, 4 );
		end,
	} );
	NS.Button( "_PctItemValueSortButton", AuctionFrameCollectionShop, L["% Item Value"], {
		template = "AuctionSortButtonTemplate",
		size = { 95, 19 },
		setPoint = { "TOPLEFT", "#sibling", "TOPRIGHT", -2, 0 },
		OnClick = function( self )
			NS.AuctionSortButton_OnClick( self, 7 );
		end,
	} );
	NS.ScrollFrame( "_ScrollFrame", AuctionFrameCollectionShop, {
		size = { 733, ( 30 * 9 - 5 ) },
		setPoint = { "TOPLEFT", "$parent_NameSortButton", "BOTTOMLEFT", 1, -5 },
		buttonTemplate = "AuctionFrameCollectionShop_ScrollFrameButtonTemplate",
		update = {
			numToDisplay = 9,
			buttonHeight = 30,
			UpdateFunction = function( sf )
				local items = NS.auction.data.groups;
				local numItems = #items;
				FauxScrollFrame_Update( sf, numItems, sf.numToDisplay, sf.buttonHeight );
				-- Next auction selected, possibly out of view
				if NS.NextAdjustScroll then
					NS.NextAdjustScroll = false;
					local maxScroll = numItems <= sf.numToDisplay and 0 or ( ( numItems - sf.numToDisplay ) * sf.buttonHeight );
					local midScrollPosition = math.floor( sf.numToDisplay / 2 );
					local vScroll = NS.scan.query.auction.groupKey <= midScrollPosition and 0 or ( ( NS.scan.query.auction.groupKey - midScrollPosition ) * sf.buttonHeight );
					sf:SetVerticalScroll( vScroll > maxScroll and maxScroll or vScroll );
				end
				--
				local offset = FauxScrollFrame_GetOffset( sf );
				-- Is selected auction in view?
				if NS.scan.status == "selected" then
					if NS.scan.query.auction.groupKey >= ( offset + 1 ) and NS.scan.query.auction.groupKey <= ( offset + sf.numToDisplay ) then
						AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton:Enable();
						AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_CancelButton:Enable();
					else
						AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton:Disable();
						AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_CancelButton:Disable();
					end
				end
				--
				for num = 1, sf.numToDisplay do
					local bn = sf.buttonName .. num; -- button name
					local b = _G[bn]; -- button
					local k = offset + num; -- key
					b:UnlockHighlight();
					if k <= numItems then
						local OnClick = function()
							NS.AuctionGroup_OnClick( k );
						end
						local IsHighlightLocked = function()
							if NS.scan.query.auction.groupKey and NS.scan.query.auction.groupKey == k then
								return true;
							else
								return false;
							end
						end
						b:SetScript( "OnClick", OnClick );
						_G[bn .. "_IconTexture"]:SetNormalTexture( items[k][5][1][3] ); -- auctions(5), first auction(1), texture(3)
						_G[bn .. "_IconTexture"]:SetScript( "OnEnter", function( self )
							GameTooltip:SetOwner( self, "ANCHOR_RIGHT" );
							if string.match( items[k][5][1][2], "|Hbattlepet:" ) then -- auctions(5), first auction(1), itemLink(2)
								local _,speciesID,level,breedQuality,maxHealth,power,speed,customName = strsplit( ":", items[k][5][1][2] )
								BattlePetToolTip_Show( tonumber( speciesID ), tonumber( level ), tonumber( breedQuality ), tonumber( maxHealth ), tonumber( power ), tonumber( speed ), customName );
							else
								GameTooltip:SetHyperlink( items[k][5][1][2] );
							end
							b:LockHighlight();
						end );
						_G[bn .. "_IconTexture"]:SetScript( "OnLeave", function() GameTooltip_Hide(); if not IsHighlightLocked() then b:UnlockHighlight(); end end );
						_G[bn .. "_IconTexture"]:SetScript( "OnClick", OnClick );
						_G[bn .. "_NameText"]:SetText( items[k][2] ); -- group name(2)
						_G[bn .. "_NameText"]:SetTextColor( GetItemQualityColor( items[k][5][1][4] ) ); -- auctions(5), first auction(1), quality(4)
						_G[bn .. "_LvlText"]:SetText( ( NS.mode ~= "PETS" and items[k][6] > NS.linkLevel ) and RED_FONT_COLOR_CODE .. items[k][6] .. FONT_COLOR_CODE_CLOSE or items[k][6] ); -- group lvl(6)
						--
						local category = items[k][3];
						if NS.mode == "MOUNTS" then
							category = ( NS.mountCollection[items[k][5][1][6]] == 0 and NS.modeColorCode .. category .. FONT_COLOR_CODE_CLOSE ) or RED_FONT_COLOR_CODE .. category .. FONT_COLOR_CODE_CLOSE; -- auctions(5), first auction(1), itemId(6)
						elseif NS.mode == "PETS" then
							local collected,collectedMax = unpack( NS.petCollection[items[k][5][1][8]] );
							category = ( collected == 0 and NS.modeColorCode .. category .. FONT_COLOR_CODE_CLOSE ) or ( collected < collectedMax and NORMAL_FONT_COLOR_CODE .. category .. FONT_COLOR_CODE_CLOSE ) or RED_FONT_COLOR_CODE .. category .. FONT_COLOR_CODE_CLOSE;
						elseif NS.mode == "TOYS" then
							category = ( NS.toyCollection[items[k][5][1][6]] == 0 and NS.modeColorCode .. category .. FONT_COLOR_CODE_CLOSE ) or RED_FONT_COLOR_CODE .. category .. FONT_COLOR_CODE_CLOSE; -- auctions(5), first auction(1), itemId(6)
						elseif NS.mode == "APPEARANCES" then
							local appearanceID, sourceID = items[k][5][1][8], items[k][5][1][9]; -- auctions(5), first auction(1), appearanceID(8), sourceID(9)
							category = ( not NS.appearanceCollection.appearances[appearanceID][2] and NS.modeColorCode .. category .. FONT_COLOR_CODE_CLOSE ) or ( not NS.appearanceCollection.sources[sourceID][2] and NORMAL_FONT_COLOR_CODE .. category .. FONT_COLOR_CODE_CLOSE ) or RED_FONT_COLOR_CODE .. category .. FONT_COLOR_CODE_CLOSE; -- isCollected(2)
						end
						_G[bn .. "_CategoryText"]:SetText( category ); -- group category(3)
						--
						MoneyFrame_Update( bn .. "_ItemPriceSmallMoneyFrame", items[k][4] ); -- group itemPrice(4)
						--
						_G[bn .. "_PctItemValueText"]:SetText( items[k][7] == 123456789 and RED_FONT_COLOR_CODE .. L["N/A"] .. FONT_COLOR_CODE_CLOSE or math.floor( items[k][7] ) .. "%" ); -- group pctItemValue(7)
						b:Show();
						if IsHighlightLocked() then b:LockHighlight(); end
					else
						b:Hide();
					end
				end
				--
				NS.UpdateTitleText();
			end
		},
		OnLoad = function( self )
			function self:Adjust()
				NS.adjustScrollFrame = false;
				if TSMAPI and NS.db["tsmItemValueSource"] ~= "" then
					NS.isPctItemValue = true;
					AuctionFrameCollectionShop_NameSortButton:SetSize( 272, 19 );
					AuctionFrameCollectionShop_CategorySortButton:SetSize( 152, 19 );
					AuctionFrameCollectionShop_ItemPriceSortButton:SetSize( 170, 19 );
					AuctionFrameCollectionShop_PctItemValueSortButton:Show();
					for i = 1, self.numToDisplay do
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_Name"]:SetSize( 235, 30 );
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_Category"]:SetSize( 150, 30 );
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_ItemPrice"]:SetSize( 168, 30 );
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_PctItemValue"]:Show();
					end
				else
					NS.isPctItemValue = false;
					AuctionFrameCollectionShop_NameSortButton:SetSize( 297, 19 );
					AuctionFrameCollectionShop_CategorySortButton:SetSize( 202, 19 );
					AuctionFrameCollectionShop_ItemPriceSortButton:SetSize( 188, 19 );
					AuctionFrameCollectionShop_PctItemValueSortButton:Hide();
					for i = 1, self.numToDisplay do
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_Name"]:SetSize( 260, 30 );
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_Category"]:SetSize( 200, 30 );
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_ItemPrice"]:SetSize( 186, 30 );
						_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_PctItemValue"]:Hide();
					end
				end
			end
		end,
	} );
	NS.TextFrame( "_JumbotronFrame", AuctionFrameCollectionShop, "", {
		hidden = true,
		size = { 733, ( 334 - 22 ) },
		setPoint = { "TOPLEFT", "$parent_ScrollFrame", "TOPLEFT" },
		fontObject = "GameFontHighlightLarge",
		justifyH = "CENTER",
	} );
	NS.Frame( "_ModeSelectionFrame", AuctionFrameCollectionShop, {
		hidden = true,
		size = { 733, ( 334 - 22 ) },
		setPoint = { "TOPLEFT", "$parent_ScrollFrame", "TOPLEFT" },
	} );
	NS.TextFrame( "_ModeHoverFrame", AuctionFrameCollectionShop_ModeSelectionFrame, "", {
		size = { 733, 17 },
		setPoint = { "TOPLEFT", "$parent", "TOPLEFT", 0, ( -108 + 17 + 20 ) },
		fontObject = "GameFontHighlightLarge",
		justifyH = "CENTER",
	} );
	NS.Button( "_MountsModeButton", AuctionFrameCollectionShop_ModeSelectionFrame, nil, {
		template = false,
		size = { 96, 96 },
		setPoint = { "TOPLEFT", "$parent", "TOPLEFT", 144.5, -108 },
		normalTexture = 631718,
		OnClick = function ()
			NS.SetMode( 1 ); -- MOUNTS
		end,
		OnEnter = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText( NS.modeColorCodes[1] .. NS.modeNames[1] .. FONT_COLOR_CODE_CLOSE );
		end,
		OnLeave = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText();
		end,
	} );
	NS.Button( "_PetsModeButton", AuctionFrameCollectionShop_ModeSelectionFrame, nil, {
		template = false,
		size = { 96, 96 },
		setPoint = { "LEFT", "#sibling", "RIGHT", 20, 0 },
		normalTexture = 631719,
		OnClick = function ()
			NS.SetMode( 2 ); -- PETS
		end,
		OnEnter = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText( NS.modeColorCodes[2] .. NS.modeNames[2] .. FONT_COLOR_CODE_CLOSE );
		end,
		OnLeave = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText();
		end,
	} );
	NS.Button( "_ToysModeButton", AuctionFrameCollectionShop_ModeSelectionFrame, nil, {
		template = false,
		size = { 96, 96 },
		setPoint = { "LEFT", "#sibling", "RIGHT", 20, 0 },
		normalTexture = 454046,
		OnClick = function ()
			NS.SetMode( 3 ); -- TOYS
		end,
		OnEnter = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText( NS.modeColorCodes[3] .. NS.modeNames[3] .. FONT_COLOR_CODE_CLOSE );
		end,
		OnLeave = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText();
		end,
	} );
	NS.Button( "_AppearancesModeButton", AuctionFrameCollectionShop_ModeSelectionFrame, nil, {
		template = false,
		size = { 96, 96 },
		setPoint = { "LEFT", "#sibling", "RIGHT", 20, 0 },
		normalTexture = 132658,
		OnClick = function ()
			NS.SetMode( 4 ); -- APPEARANCES
		end,
		OnEnter = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText( NS.modeColorCodes[4] .. NS.modeNames[4] .. FONT_COLOR_CODE_CLOSE );
		end,
		OnLeave = function()
			AuctionFrameCollectionShop_ModeSelectionFrame_ModeHoverFrameText:SetText();
		end,
	} );
	NS.Frame( "_DialogFrame", AuctionFrameCollectionShop, {
		size = { 733, 64 },
		setPoint = { "TOP", "$parent_ScrollFrame", "BOTTOM" },
	} );
	NS.Frame( "_BuyoutFrame", AuctionFrameCollectionShop_DialogFrame, {
		hidden = true,
		setAllPoints = true,
	} );
	NS.Button( "_CancelButton", AuctionFrameCollectionShop_DialogFrame_BuyoutFrame, CANCEL, {
		size = { 120, 30 },
		setPoint = { "LEFT", "$parent", "CENTER", 5, 0 },
		OnClick = function()
			if NS.buyAll then
				AuctionFrameCollectionShop_BuyAllButton:Click();
			else
				NS.AuctionGroup_Deselect();
				NS.StatusFrame_Message( NS.SELECT_AN_AUCTION() );
			end
		end,
	} );
	NS.Button( "_BuyoutButton", AuctionFrameCollectionShop_DialogFrame_BuyoutFrame, BUYOUT, {
		size = { 120, 30 },
		setPoint = { "RIGHT", "$parent", "CENTER", -5, 0 },
		OnClick = function( self )
			if NS.scan.status == "selected" then
				NS.scan.status = "buying";
				NS.AuctionSortButtons_Action( "Disable" );
				AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton:Disable();
				AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_CancelButton:Disable();
				AuctionFrameCollectionShop_ScanButton:Disable();
				AuctionFrameCollectionShop_ShopButton:Disable();
				AuctionFrameCollectionShop_BuyAllButton:Disable();
				CollectionShopEventsFrame:RegisterEvent( "CHAT_MSG_SYSTEM" );
				PlaceAuctionBid( "list", NS.scan.query.auction.index, NS.scan.query.auction[1] ); -- itemPrice(1)
			end
		end,
	} );
	NS.TextFrame( "_StatusFrame", AuctionFrameCollectionShop_DialogFrame, "", {
		setAllPoints = true,
		justifyH = "CENTER",
	} );
	NS.Button( "_CloseButton", AuctionFrameCollectionShop, CLOSE, {
		size = { 80, 22 },
		setPoint = { "BOTTOMRIGHT", 0, 14 },
		OnClick = function() AuctionFrame_Hide() end,
	} );
	NS.Button( "_BuyAllButton", AuctionFrameCollectionShop, L["Buy All"], {
		size = { 80, 22 },
		setPoint = { "RIGHT", "#sibling", "LEFT" },
		OnClick = function( self )
			if NS.buyAll then
				NS.buyAll = false;
				self:SetText( L["Buy All"] );
				NS.StatusFrame_Message( string.format( L["Buy All has been stopped. %s"], NS.SELECT_AN_AUCTION() ) );
				NS.AuctionGroup_Deselect();
			else
				NS.buyAll = true;
				self:SetText( L["Stop"] );
				NS.StatusFrame_Message( L["Scanning..."] );
				NS.AuctionGroup_OnClick( 1 );
			end
		end,
		OnLoad = function( self )
			function self:Reset()
				NS.buyAll = false;
				self:Disable();
				self:SetText( L["Buy All"] );
			end
		end,
	} );
	NS.Button( "_ShopButton", AuctionFrameCollectionShop, L["Shop"], {
		size = { 80, 22 },
		setPoint = { "RIGHT", "#sibling", "LEFT" },
		OnClick = function( self )
			if NS.scan.status == "ready" or NS.scan.status == "selected" then
				-- Shop
				NS.Reset();
				NS.scan:Start( "SHOP" );
			else
				-- Abort
				NS.Reset();
			end
		end,
		OnLoad = function( self )
			function self:Reset()
				if NS.mode and ( NS.db["live"] or NS.db["getAllScan"][NS.realmName] ) then
					self:Enable();
				else
					self:Disable();
				end
				self:SetText( L["Shop"] );
			end
		end,
	} );
	NS.Button( "_ScanButton", AuctionFrameCollectionShop, L["Scan"], {
		size = { 80, 22 },
		setPoint = { "RIGHT", "#sibling", "LEFT" },
		OnClick = function( self )
			if NS.scan.status == "ready" or NS.scan.status == "selected" then
				-- Scan
				NS.Reset();
				NS.scan:Start( "GETALL" );
			else
				-- Should not fire, but just in case. Also, no Abort option for this scan type
				NS.Print( L["Selection ignored, busy scanning or buying an auction"] );
			end
		end,
		OnLoad = function( self )
			function self:Reset()
				if NS.mode and not NS.db["live"] and ( not NS.db["getAllScan"][NS.realmName] or ( time() - NS.db["getAllScan"][NS.realmName]["time"] ) > 900 ) then
					self:Enable();
				else
					self:Disable();
				end
				self:SetText( L["Scan"] );
			end
		end,
	} );
	NS.TextFrame( "_TimeSinceLastGetAllScanFrame", AuctionFrameCollectionShop, "", {
		size = { 270, 22 },
		setPoint = { "RIGHT", "#sibling", "LEFT", -47, 0 },
		fontObject = "GameFontNormalSmall",
		justifyH = "CENTER",
	} );
	NS.CheckButton( "_LiveCheckButton", AuctionFrameCollectionShop, L["Live"], {
		template = "InterfaceOptionsSmallCheckButtonTemplate",
		size = { 16, 16 },
		setPoint = { "RIGHT", "$parent_ScanButton", "LEFT", -30, 0 },
		tooltip = L["Scan Auction House live when\npressing \"Shop\" instead of\nusing GetAll scan data\n\nLive scans only search\nthe pages required for the\nfilters you checked and may\nbe faster in certain modes or\nwhen using a low max price"],
		db = "live",
		OnClick = function()
			NS.Reset();
		end,
	} );
	NS.Button( "_OptionsButton", AuctionFrameCollectionShop, nil, {
		template = false,
		size = { 32, 32 },
		setPoint = { "TOPRIGHT", "$parent_NameSortButton", "BOTTOMLEFT", -6, -9 },
		normalTexture = 134063,
		tooltip = L["Options"],
		OnClick = function()
			NS.SlashCmdHandler( "" );
		end,
		OnLoad = function( self )
			self.tooltipAnchor = { self, "ANCHOR_BOTTOMRIGHT", 3, 33 };
		end,
	} );
	NS.Button( "_ModeSelectionButton", AuctionFrameCollectionShop, nil, {
		template = false,
		size = { 32, 32 },
		setPoint = { "TOP", "#sibling", "BOTTOM", 0, -6 },
		normalTexture = 631718,
		tooltip = L["Choose Collection Mode"],
		OnClick = function( self )
			if NS.scan.status == "ready" or NS.scan.status == "selected" then
				NS.SetMode( nil );
			else
				NS.Print( L["Selection ignored, busy scanning or buying an auction"] );
			end
		end,
		OnLoad = function( self )
			self.tooltipAnchor = { self, "ANCHOR_BOTTOMRIGHT", 3, 33 };
			function self:Reset()
				if not NS.mode then
					self:Hide();
				elseif not self:IsShown() then
					if NS.mode == "MOUNTS" then
						self:SetNormalTexture( 631718 );
					elseif NS.mode == "PETS" then
						self:SetNormalTexture( 631719 );
					elseif NS.mode == "TOYS" then
						self:SetNormalTexture( 454046 );
					elseif NS.mode == "APPEARANCES" then
						self:SetNormalTexture( 132658 );
					end
					self:Show();
				end
			end
		end,
	} );
	NS.Button( "_BuyoutsMailButton", AuctionFrameCollectionShop, nil, {
		template = false,
		size = { 32, 32 },
		setPoint = { "TOP", "#sibling", "BOTTOM", 0, -6 },
		normalTexture = 133471,
		tooltip = L["Buyouts"],
		OnClick = function( self )
			NS.SlashCmdHandler( "buyouts" );
		end,
		OnLoad = function( self )
			self.tooltipAnchor = { self, "ANCHOR_BOTTOMRIGHT", 3, 33 };
		end,
	} );
	NS.Frame( "_FlyoutPanel", AuctionFrameCollectionShop, {
		template = "BasicFrameTemplate",
		size = { 247, 423 }, -- 274 with scrollbar, 247 without scrollbar
		setPoint = { "LEFT", "$parent", "RIGHT", 8, -1 },
		bg = { "Interface\\FrameGeneral\\UI-Background-Marble", true, true },
		OnLoad = function( self )
			function self:Reset( filterOnClick )
				if not filterOnClick then
					AuctionFrameCollectionShop_FlyoutPanel_ScrollFrame:SetVerticalScroll( 0 ); -- Scroll to top
				end
				AuctionFrameCollectionShop_FlyoutPanel_ScrollFrame:Update();
				if NS.mode and NS.db["flyoutPanelOpen"] and not self:IsShown() then
					self:Show();
				elseif ( not NS.mode or not NS.db["flyoutPanelOpen"] ) and self:IsShown() then
					self:Hide();
				end
			end
			self.TitleText:SetWordWrap( false );
			self.TitleText:SetPoint( "LEFT", 4, 0 );
			self.TitleText:SetPoint( "RIGHT", -28, 0 );
			self.TitleText:SetText( L["Shop Filters"] );
			self.CloseButton:SetScript( "OnClick", function( self )
				self:GetParent().FlyoutPanelButton:Click();
			end );
		end,
		OnShow = function( self )
			self.FlyoutPanelButton:SetNormalTexture( "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up" );
			self.FlyoutPanelButton:SetPushedTexture( "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down" );
		end,
		OnHide = function( self )
			self.FlyoutPanelButton:SetNormalTexture( "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up" );
			self.FlyoutPanelButton:SetPushedTexture( "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down" );
		end,
	} );
	NS.ScrollFrame( "_ScrollFrame", AuctionFrameCollectionShop_FlyoutPanel, {
		size = { 242, ( 20 * 17 - 5 ) },
		setPoint = { "TOPLEFT", 1, -27 },
		buttonTemplate = "AuctionFrameCollectionShop_FlyoutPanel_ScrollFrameButtonTemplate",
		update = {
			numToDisplay = 17,
			buttonHeight = 20,
			UpdateFunction = function( sf )
				local items = NS.modeFiltersFlyout;
				local numItems = #items;
				FauxScrollFrame_Update( sf, numItems, sf.numToDisplay, sf.buttonHeight );
				-- Adjust FlyoutPanel width for scrollbar
				local flyoutWidth = ( function() if numItems > sf.numToDisplay then return 274 else return 247 end end )();
				AuctionFrameCollectionShop_FlyoutPanel:SetWidth( flyoutWidth );
				if NS.disableFlyoutChecks then
					AuctionFrameCollectionShop_FlyoutPanel_ToggleCategories:Disable();
					AuctionFrameCollectionShop_FlyoutPanel_UncheckAll:Disable();
					AuctionFrameCollectionShop_FlyoutPanel_CheckAll:Disable();
				else
					if NS.mode ~= "MOUNTS" then -- Mounts have no categories
						AuctionFrameCollectionShop_FlyoutPanel_ToggleCategories:Enable();
					end
					AuctionFrameCollectionShop_FlyoutPanel_UncheckAll:Enable();
					AuctionFrameCollectionShop_FlyoutPanel_CheckAll:Enable();
				end
				-- Filter: key(1), string(2), default(3), info(4)
				for num = 1, sf.numToDisplay do
					local k = FauxScrollFrame_GetOffset( sf ) + num; -- key
					local bn = sf.buttonName .. num; -- button name
					local b = _G[bn]; -- button
					local c = _G[bn .. "_Check"]; -- check
					b:UnlockHighlight();
					if NS.disableFlyoutChecks then
						c:Disable();
					else
						c:Enable();
					end
					if k <= numItems then
						b:SetScript( "OnClick", function() c:Click() end );
						_G[bn .. "_NameText"]:SetText( items[k][2] );
						--
						c:SetChecked( NS.db["modeFilters"][NS.mode][items[k][1]] );
						c:SetScript( "OnEnter", function() b:LockHighlight(); end );
						c:SetScript( "OnLeave", function() b:UnlockHighlight(); end );
						c:SetScript( "OnClick", function() NS.db["modeFilters"][NS.mode][items[k][1]] = c:GetChecked(); NS.Reset( true ); end );
						--
						b:Show();
					else
						b:Hide();
					end
				end
			end
		},
	} );
	NS.Button( "_UncheckAll", AuctionFrameCollectionShop_FlyoutPanel, L["Uncheck All"], {
		size = { 96, 20 },
		setPoint = { "BOTTOMRIGHT", "$parent", "BOTTOM", -2, 9 },
		fontObject = "GameFontNormalSmall",
		OnClick = function()
			NS.FlyoutPanelSetChecks( false );
		end,
	} );
	NS.Button( "_ToggleCategories", AuctionFrameCollectionShop_FlyoutPanel, "", {
		size = { 144, 20 },
		setPoint = { "BOTTOM", "$parent", "BOTTOM", 0, 32 },
		fontObject = "GameFontNormalSmall",
		OnClick = function()
			NS.FlyoutPanelToggleCategories();
		end,
	} );
	NS.Button( "_CheckAll", AuctionFrameCollectionShop_FlyoutPanel, L["Check All"], {
		size = { 96, 20 },
		setPoint = { "BOTTOMLEFT", "$parent", "BOTTOM", 2, 9 },
		fontObject = "GameFontNormalSmall",
		OnClick = function()
			NS.FlyoutPanelSetChecks( true );
		end,
	} );
	NS.Button( "_FlyoutPanelButton", AuctionFrameCollectionShop, nil, {
		template = false,
		size = { 28, 28 },
		setPoint = { "TOPRIGHT", "$parent", "TOPRIGHT", 5, -34 },
		normalTexture = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up",
		pushedTexture = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down",
		highlightTexture = "Interface\\Buttons\\UI-Common-MouseHilight",
		OnClick = function ( self )
			if not NS.mode then return end
			if self.FlyoutPanel:IsShown() then
				self.FlyoutPanel:Hide();
				NS.db["flyoutPanelOpen"] = false;
			else
				self.FlyoutPanel:Show();
				NS.db["flyoutPanelOpen"] = true;
			end
		end,
		OnLoad = function( self )
			self.FlyoutPanel = _G[self:GetParent():GetName() .. "_FlyoutPanel"];
			self.FlyoutPanel.FlyoutPanelButton = self;
		end,
	} );
	-- Add "CollectionShop" tab to AuctionFrame
	local numTab = AuctionFrame.numTabs + 1;
	NS.AuctionFrameTab = NS.Button( "AuctionFrameTab" .. numTab, AuctionFrame, L[NS.title], {
		topLevel = true,
		template = "AuctionTabTemplate",
		setPoint = { "LEFT", "AuctionFrameTab" .. ( numTab - 1 ), "RIGHT", -8, 0 },
		OnLoad = function( self )
			self:SetID( numTab );
		end,
	} );
	PanelTemplates_SetNumTabs( AuctionFrame, numTab );
	PanelTemplates_EnableTab( AuctionFrame, numTab );
	-- Set AuctionFrameCollectionShop inside AuctionFrame
	AuctionFrameCollectionShop:SetParent( AuctionFrame );
	AuctionFrameCollectionShop:SetPoint( "TOPLEFT" );
	-- Hook tab click
	hooksecurefunc( "AuctionFrameTab_OnClick", NS.AuctionFrameTab_OnClick );
	-- Hook SideDressUpModelCloseButton
	SideDressUpModelCloseButton:HookScript( "OnClick", NS.SideDressUpModelCloseButton_OnClick );
	-- Add new appearance sources to appearanceCollection to prevent unnecessary source lookups
	CollectionShopEventsFrame:RegisterEvent( "TRANSMOG_COLLECTION_SOURCE_ADDED" );
end
--------------------------------------------------------------------------------------------------------------------------------------------
-- CollectionShopEventsFrame
--------------------------------------------------------------------------------------------------------------------------------------------
NS.Frame( "CollectionShopEventsFrame", UIParent, {
	topLevel = true,
	hidden = true,
	OnEvent = function ( self, event, ... )
		if		event == "ADDON_LOADED"						then
			if IsAddOnLoaded( NS.addon ) then
				if not NS.initialized then
					-- Set Default SavedVariables
					if not COLLECTIONSHOP_SAVEDVARIABLES then
						COLLECTIONSHOP_SAVEDVARIABLES = NS.DefaultSavedVariables();
					end
					-- Set Default SavedVariablesPerCharacter
					if not COLLECTIONSHOP_SAVEDVARIABLESPERCHARACTER then
						COLLECTIONSHOP_SAVEDVARIABLESPERCHARACTER = NS.DefaultSavedVariablesPerCharacter();
					end
					-- Localize SavedVariables
					NS.db = COLLECTIONSHOP_SAVEDVARIABLES;
					NS.dbpc = COLLECTIONSHOP_SAVEDVARIABLESPERCHARACTER;
					-- Upgrade if old version
					if NS.db["version"] < NS.version then
						NS.Upgrade();
					end
					-- Upgrade Per Character if old version
					if NS.dbpc["version"] < NS.version then
						NS.UpgradePerCharacter();
					end
					--
					NS.initialized = true;
				elseif IsAddOnLoaded( "Blizzard_AuctionUI" ) then
					self:UnregisterEvent( "ADDON_LOADED" );
					NS.Blizzard_AuctionUI_OnLoad();
				end
			end
		elseif	event == "PLAYER_LOGIN"						then
			self:UnregisterEvent( "PLAYER_LOGIN" );
			-- InterfaceOptions_AddCategory( CollectionShopInterfaceOptionsPanel );
			if #NS.playerLoginMsg > 0 then
				for _,msg in ipairs( NS.playerLoginMsg ) do
					NS.Print( msg );
				end
			end
		elseif	event == "AUCTION_ITEM_LIST_UPDATE"			then	NS.scan:OnAuctionItemListUpdate();
		elseif	event == "CHAT_MSG_SYSTEM"					then	NS.scan:OnChatMsgSystem( ... );
		elseif	event == "UI_ERROR_MESSAGE"					then	NS.scan:OnUIErrorMessage( ... );
		elseif	event == "TRANSMOG_COLLECTION_SOURCE_ADDED"	then
			local arg1 = ...;
			if not arg1 then return end
			--
			local sourceID = arg1;
			local _,appearanceID = C_TransmogCollection.GetAppearanceSourceInfo( sourceID );
			if appearanceID then
				-- Update Appearances and Sources
				NS.appearanceCollection.appearances[appearanceID] = { nil, true }; -- categoryID(1) not currently being used, isCollected(2)
				NS.appearanceCollection.sources[sourceID] = { appearanceID, true }; -- isCollected(2)
			end
		elseif	event == "PLAYER_SPECIALIZATION_CHANGED"	then
			local arg1 = select( 1, ... );
			if not arg1 then return end
			if arg1 == "player" then
				AuctionFrameTab1:Click(); -- Go to browse tab if player changes specs while using addon, AH links are based on spec
			end
		elseif	event == "INSPECT_READY"					then
			self:UnregisterEvent( "INSPECT_READY" );
			NS.linkSpecID = GetInspectSpecialization( "player" );
		end
	end,
	OnLoad = function( self )
		self:RegisterEvent( "ADDON_LOADED" );
		self:RegisterEvent( "PLAYER_LOGIN" );
	end,
} );
