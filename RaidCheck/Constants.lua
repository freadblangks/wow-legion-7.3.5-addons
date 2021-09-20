local RC = LibStub("AceAddon-3.0"):GetAddon("Raid Check")
local L = LibStub("AceLocale-3.0"):GetLocale("Raid Check", true)

-- Player Data Array is currently composed of: Name, Realm, hasFlask, hasFood, hasRune, Class, Role, hasVantusRune
RC.playerData = {};

RC.AddOn_Name = "Raid Check";

RC.MainFrameWidth = 325;

RC.GrpWidth = RC.MainFrameWidth-5;
RC.DDWidth = 100;

RC.ButtonWidth = 85;
RC.ButtonHeight = 25;

RC.PlayerWidth = 115;
RC.FlFoRuWidth = 40;
RC.Spacing = 5;

-- UI Height Slider Variables
RC.UserScreenResolution = ({GetScreenResolutions()})[GetCurrentResolution()];
if RC.UserScreenResolution then
	RC.MaxWidth, RC.MaxHeight = RC.UserScreenResolution:match("([^,]+)x([^,]+)")
else
	RC.MaxWidth = 325
	RC.MaxHeight = 800
end
RC.MinHeight = 240;
RC.SliderStep = 10;

RC.GBoW = 203539; -- Retribution Paladin's Greater Blessing of Wisdom

RC.FoodLevels = {
	225,
	300,
	375,
	400,
	500,
};

RC.Food = {
	201641, -- Feast Stamina 725 (500)
	201640, -- Feast Intellect 500
	201639, -- Feast Agility 500
	201638, -- Feast Strength 500

	201637, -- Feast Stamina 600 (400)
	201636, -- Feast Intellect 400
	201635, -- Feast Agility 400
	201634, -- Feast Strength 400

	225606, -- Fishbrul Special (375)
	225603, -- Haste 375
	225602, -- Crit 375
	225604, -- Mastery 375
	225605, -- Versatility 375

	225601, -- Drogbar-Style Salmon (300)
	225598, -- Legion Haste (300)
	225597, -- Legion Crit (300)
	225599, -- Legion Mastery (300)
	225600, -- Legion Versatility (300)
	225613, -- Legion Crit (300) OPTIONAL WOWHEAD FOUND
	225614, -- Legion Haste (300) OPTIONAL WOWHEAD FOUND
	225615, -- Legion Mastery (300) OPTIONAL WOWHEAD FOUND
	225616, -- Legion Versatility (300) OPTIONAL WOWHEAD FOUND

	201332, -- Mastery 225
	201334, -- Versatility 225
	201330, -- Haste 225
	201223, -- Crit 225
	201336, -- Spiced Rip Roast (225)
};

RC.FlaskLevels = {
	1300, -- Legion Flasks
};

RC.Flask = {
	188034, --Legion Strength
	188035, --Legion Stamina
	188031, --Legion Intellect
	188033, --Legion Agi
};

RC.RuneLevels = {
	325, --Legion Rune
};
RC.Runes = {
	224001, --defiled-augmentation
};

RC.FelFocus = 242551; --Fel Focus 7.2

--Vantus Rune Checking
RC.VantusRuneCheckEnabled = false  -- Global variable to assist in checking for Vantus Rune buffs only when we are at the selected Boss

--These are set as sub tables because when we check for a Spell we are using a table, in this way we only need to provide the selected SpellID that corresponds to the selected Vantus Rune to check
RC.VantusSpellIds = {
	{0},
	{237825}, -- Kil'jaeden
	{250153}, -- Garothi Worldbreaker
	{250156}, -- Felhounds of Sargeras
	{250167}, -- Antoran High Command
	{250160}, -- Portal Keeper Hasabel
	{250150}, -- Eonar the Life-Binder
	{250158}, -- Imonar the Soulhunter
	{250148}, -- Kin'garoth
	{250165}, -- Varimathras
	{250163}, -- The Coven of Shivarra
	{250144}, -- Aggramar
	{250146}, -- Argus the Unmaker
};

--Since some of the fights are Council fights, then we need to utilize sub-tables for consistency, it also appears that there are multiple IDs?
RC.VantusBossIds = {
	{0},
	{117269},	-- Kil'jaeden
	{122450},	-- Garothi Worldbreaker
	{122135,122477},	--F'harg, Shatug
	{122369,122333,122367},	--Chief Engineer Ishkar, General Erodus, Admiral Svirax
	{122104},	-- Portal Keeper Hasabel
	{124445},	-- Eonar the Life-Binder
	{124158,125692},	-- Imonar the Soulhunter
	{122578},	-- Kin'garoth
	{122366},	-- Varimathras
	{122467,122468,122469,125436},	-- Noura, Asara, Diima, Thu'raya (mythic only)
	{121975},	-- Aggramar
	{124828},	-- Argus the Unmaker
};

-- In Game if you run the following, it gives you the list of all Encounter IDs, we are going to use this to find the proper IDs to populate the Encounter Names.
-- The script is from WowInterface user Ketho:  http://www.wowinterface.com/forums/showthread.php?t=53806
-- /run local i=1 while EJ_GetInstanceByIndex(i,true)do local a1,a2=EJ_GetInstanceByIndex(i,true)print(a1,a2)EJ_SelectInstance(a1)i=i+1 local j=1 while EJ_GetEncounterInfoByIndex(j,a1)do local b1,_,b2=EJ_GetEncounterInfoByIndex(j,a1)print(b2,b1)j=j+1 end end
RC.EncounterIds = {
	1898, --Kil'jaeden
	1992, --Garothi Worldbreaker
	1987, --Felhounds of Sargeras
	1997, --Antoran High Command
	1985, --Portal Keeper Hasabel
	2025, --Eonar the Life-Binder
	2009, --Imonar the Soulhunter
	2004, --Kin'garoth
	1983, --Varimathras
	1986, --The Coven of Shivarra
	1984, --Aggramar
	2031, --Argus the Unmaker
};

--We want this to be a localized list, so we populate all the Boss Names when the Settings tab is opened, we use the Encounter IDs
RC.VantusBossNames = {
	L["none"],
};


--The following are override values for items that may not give the exact number appropriately
RC.OverRide225 = 201336; -- Spiced Rib Roast (225)
RC.OverRide300 = 225601; -- Drogbar-Style Salmon (300)
RC.OverRide375 = 225606; -- Fishbrul Special (375)

RC.OverRide400 = {
	201637, -- Feast Stamina 600 (400)
	201636, -- Feast Intellect 400
	201635, -- Feast Agility 400
	201634, -- Feast Strength 400

};

RC.OverRide500 = {
	201641, -- Feast Stamina 725 (500)
	201640, -- Feast Intellect 500
	201639, -- Feast Agility 500
	201638, -- Feast Strength 500
};
