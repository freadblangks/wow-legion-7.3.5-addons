
local addonName, _addonData = ...;
local _L = _addonData.L;

local _aVar = _addonData.variables;
local playerClass = select(2, UnitClass("player"));
local playerFaction = UnitFactionGroup("player");--GetPlayerFactionGroup();

_addonData.variables = {}
local _aVar = _addonData.variables;
_aVar.CLASSIC_RAID = 0;
_aVar.TBC_HEROIC = -1;
_aVar.TBC_RAID = -2;
_aVar.WOTLK_HEROIC = -3;
_aVar.WOTLK_RAID = -4;
_aVar.CATA_HEROIC = -5;
_aVar.CATA_RAID = -6;
_aVar.MOP_HEROIC = -7;
_aVar.MOP_RAID = -8;
_aVar.WOD_HEROIC = -9;
_aVar.WOD_RAID = -10;
_aVar.LEGION_HEROIC = -11;
_aVar.LEGION_RAID = -12;

_addonData.unlockData = {};

local function AddUnlock(list, level, unlock)
	if not list[level] then list[level] = {} end;
	table.insert(list[level], unlock);
end

--------------------------
-- UI
--------------------------

_addonData.unlockData["UI"] = {};
	AddUnlock(_addonData.unlockData["UI"], 10, {["id"] = 1, ["name"] = _L["UI_TALENTS"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				if (PlayerTalentFrame == nil) then
					LoadAddOn("Blizzard_TalentUI");
				end
				ShowUIPanel(PlayerTalentFrame); 
			end});
	AddUnlock(_addonData.unlockData["UI"], 10, {["id"] = 2, ["name"] = _L["UI_GROUP_FINDER"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				ShowUIPanel(PVEFrame); 
				GroupFinderFrame_ShowGroupFrame(_G["LFGListPVEStub"]);
			end});
	AddUnlock(_addonData.unlockData["UI"], 11, {["id"] = 3, ["name"] = _L["UI_GUIDE"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				if (EncounterJournal == nil) then
					LoadAddOn("Blizzard_EncounterJournal");
				end
				ShowUIPanel(EncounterJournal);
			end});
	AddUnlock(_addonData.unlockData["UI"], 15, {["id"] = 4, ["name"] = _L["UI_DUNGEON_FINDER"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				ShowUIPanel(PVEFrame); 
				GroupFinderFrame_ShowGroupFrame(_G["LFDParentFrame"]);
			end});
	AddUnlock(_addonData.unlockData["UI"], 15, {["id"] = 5, ["name"] = _L["UI_EQUIPMENT"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				ShowUIPanel(CharacterFrame); 
				PaperDollFrame_SetSidebar(nil, 3);
			end});
	AddUnlock(_addonData.unlockData["UI"], 85, {["id"] = 6, ["name"] = _L["UI_SCENARIOS"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				ShowUIPanel(PVEFrame); 
				GroupFinderFrame_ShowGroupFrame(_G["ScenarioFinderFrame"]);
			end});
	AddUnlock(_addonData.unlockData["UI"], 85, {["id"] = 7, ["name"] = _L["UI_RAID_FINDER"], ["subText"] = _L["INTERFACE_FEATURE"], ["func"] = function() 
				ShowUIPanel(PVEFrame); 
				GroupFinderFrame_ShowGroupFrame(_G["RaidFinderFrame"]);
			end});
--------------------------
-- Talent Points
--------------------------

_addonData.unlockData["talents"] = { }; 
local talentLevels = {15, 30, 45, 60, 75, 90, 100};
if (playerClass == "DEATHKNIGHT") then
	talentLevels = {56, 57, 58, 60, 75, 90, 100};
elseif (playerClass == "DEMONHUNTER") then
	talentLevels = {99, 100, 102, 104, 106, 108, 110};
end

for k, level in ipairs(talentLevels) do
	_addonData.unlockData["talents"][level] = true;
end

--------------------------
-- Riding
--------------------------

_addonData.unlockData["riding"] = { };
	AddUnlock(_addonData.unlockData["riding"], 20, {["id"] = 33388});
	AddUnlock(_addonData.unlockData["riding"], 40, {["id"] = 33391});
	AddUnlock(_addonData.unlockData["riding"], 60, {["id"] = 34090});
	AddUnlock(_addonData.unlockData["riding"], 60, {["id"] = 90267});
	AddUnlock(_addonData.unlockData["riding"], 70, {["id"] = 34091});
	AddUnlock(_addonData.unlockData["riding"], 80, {["id"] = 90265});
	--AddUnlock(_addonData.unlockData["riding"], 68, {["id"] = 54197});
	--AddUnlock(_addonData.unlockData["riding"], 85, {["id"] = 115913});
	--AddUnlock(_addonData.unlockData["riding"], 90, {["id"] = 191645});

--------------------------
-- Instances
--------------------------

-- /run print(GetMouseFocus().instanceID) 
_addonData.unlockData["instances"] = { };
-- Vanilla
	AddUnlock(_addonData.unlockData["instances"], 15, {["subText"] = _L["DUNGEON"], ["id"] = 226, ["icon"] = "Interface/LFGFRAME/LFGICON-RAGEFIRECHASM"});
	AddUnlock(_addonData.unlockData["instances"], 15, {["subText"] = _L["DUNGEON"], ["id"] = 63, ["icon"] = "Interface/LFGFRAME/LFGICON-DEADMINES"});
	AddUnlock(_addonData.unlockData["instances"], 17, {["subText"] = _L["DUNGEON"], ["id"] = 240, ["icon"] = "Interface/LFGFRAME/LFGICON-WAILINGCAVERNS"});
	AddUnlock(_addonData.unlockData["instances"], 17, {["subText"] = _L["DUNGEON"], ["id"] = 64, ["icon"] = "Interface/LFGFRAME/LFGICON-SHADOWFANGKEEP"});
	AddUnlock(_addonData.unlockData["instances"], 20, {["subText"] = _L["DUNGEON"], ["id"] = 227, ["icon"] = "Interface/LFGFRAME/LFGICON-BLACKFATHOMDEEPS"});
	AddUnlock(_addonData.unlockData["instances"], 20, {["subText"] = _L["DUNGEON"], ["id"] = 238, ["icon"] = "Interface/LFGFRAME/LFGICON-STORMWINDSTOCKADES"});
	AddUnlock(_addonData.unlockData["instances"], 24, {["subText"] = _L["DUNGEON"], ["id"] = 231, ["icon"] = "Interface/LFGFRAME/LFGICON-GNOMEREGAN"});
	AddUnlock(_addonData.unlockData["instances"], 26, {["subText"] = _L["DUNGEON"], ["id"] = 311, ["icon"] = "Interface/LFGFRAME/LFGICON-SCARLETMONASTERY"});
	AddUnlock(_addonData.unlockData["instances"], 28, {["subText"] = _L["DUNGEON"], ["id"] = 316, ["icon"] = "Interface/LFGFRAME/LFGICON-SCARLETMONASTERY"});
	AddUnlock(_addonData.unlockData["instances"], 30, {["subText"] = _L["DUNGEON"], ["id"] = 232, ["icon"] = "Interface/LFGFRAME/LFGICON-MARAUDON"});
	AddUnlock(_addonData.unlockData["instances"], 30, {["subText"] = _L["DUNGEON"], ["id"] = 234, ["icon"] = "Interface/LFGFRAME/LFGICON-RAZORFENKRAUL"});
	AddUnlock(_addonData.unlockData["instances"], 32, {["subText"] = _L["DUNGEON"], ["id"] = 232, ["icon"] = "Interface/LFGFRAME/LFGICON-MARAUDON"});
	AddUnlock(_addonData.unlockData["instances"], 34, {["subText"] = _L["DUNGEON"], ["id"] = 232, ["icon"] = "Interface/LFGFRAME/LFGICON-MARAUDON"});
	AddUnlock(_addonData.unlockData["instances"], 35, {["subText"] = _L["DUNGEON"], ["id"] = 233, ["icon"] = "Interface/LFGFRAME/LFGICON-RAZORFENDOWNS"});
	AddUnlock(_addonData.unlockData["instances"], 36, {["subText"] = _L["DUNGEON"], ["id"] = 230, ["icon"] = "Interface/LFGFRAME/LFGICON-DIREMAUL"});
	AddUnlock(_addonData.unlockData["instances"], 38, {["subText"] = _L["DUNGEON"], ["id"] = 246, ["icon"] = "Interface/LFGFRAME/LFGICON-SCHOLOMANCE"});
	AddUnlock(_addonData.unlockData["instances"], 39, {["subText"] = _L["DUNGEON"], ["id"] = 230, ["icon"] = "Interface/LFGFRAME/LFGICON-DIREMAUL"});
	AddUnlock(_addonData.unlockData["instances"], 40, {["subText"] = _L["DUNGEON"], ["id"] = 239, ["icon"] = "Interface/LFGFRAME/LFGICON-ULDAMAN"});
	AddUnlock(_addonData.unlockData["instances"], 42, {["subText"] = _L["DUNGEON"], ["id"] = 230, ["icon"] = "Interface/LFGFRAME/LFGICON-DIREMAUL"});
	AddUnlock(_addonData.unlockData["instances"], 42, {["subText"] = _L["DUNGEON"], ["id"] = 236, ["icon"] = "Interface/LFGFRAME/LFGICON-STRATHOLME"});
	AddUnlock(_addonData.unlockData["instances"], 44, {["subText"] = _L["DUNGEON"], ["id"] = 241, ["icon"] = "Interface/LFGFRAME/LFGICON-ZULFARAK"});
	AddUnlock(_addonData.unlockData["instances"], 46, {["subText"] = _L["DUNGEON"], ["id"] = 236, ["icon"] = "Interface/LFGFRAME/LFGICON-STRATHOLME"});
	AddUnlock(_addonData.unlockData["instances"], 47, {["subText"] = _L["DUNGEON"], ["id"] = 228, ["icon"] = "Interface/LFGFRAME/LFGICON-BLACKROCKDEPTHS"});
	AddUnlock(_addonData.unlockData["instances"], 50, {["subText"] = _L["DUNGEON"], ["id"] = 237, ["icon"] = "Interface/LFGFRAME/LFGICON-SUNKENTEMPLE"});
	AddUnlock(_addonData.unlockData["instances"], 51, {["subText"] = _L["DUNGEON"], ["id"] = 228, ["icon"] = "Interface/LFGFRAME/LFGICON-BLACKROCKDEPTHS"});
	AddUnlock(_addonData.unlockData["instances"], 55, {["subText"] = _L["DUNGEON"], ["id"] = 229, ["icon"] = "Interface/LFGFRAME/LFGICON-BLACKROCKSPIRE"});
	AddUnlock(_addonData.unlockData["instances"], 60, {["subText"] = _L["RAID"], ["name"] = _L["RAIDS_CLASSIC"], ["id"] = _aVar.CLASSIC_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGICON-MOLTENCORE"});
-- TBC
	AddUnlock(_addonData.unlockData["instances"], 58, {["subText"] = _L["DUNGEON"], ["id"] = 248, ["icon"] = "Interface/LFGFRAME/LFGICON-HELLFIRECITADEL"});
	AddUnlock(_addonData.unlockData["instances"], 59, {["subText"] = _L["DUNGEON"], ["id"] = 256, ["icon"] = "Interface/LFGFRAME/LFGICON-HELLFIRECITADEL"});
	AddUnlock(_addonData.unlockData["instances"], 60, {["subText"] = _L["DUNGEON"], ["id"] = 260, ["icon"] = "Interface/LFGFRAME/LFGICON-COILFANG"});
	AddUnlock(_addonData.unlockData["instances"], 61, {["subText"] = _L["DUNGEON"], ["id"] = 262, ["icon"] = "Interface/LFGFRAME/LFGICON-COILFANG"});
	AddUnlock(_addonData.unlockData["instances"], 62, {["subText"] = _L["DUNGEON"], ["id"] = 250, ["icon"] = "Interface/LFGFRAME/LFGICON-AUCHINDOUN"});
	AddUnlock(_addonData.unlockData["instances"], 63, {["subText"] = _L["DUNGEON"], ["id"] = 247, ["icon"] = "Interface/LFGFRAME/LFGICON-AUCHINDOUN"});
	AddUnlock(_addonData.unlockData["instances"], 64, {["subText"] = _L["DUNGEON"], ["id"] = 251, ["icon"] = "Interface/LFGFRAME/LFGICON-CAVERNSOFTIME"});
	AddUnlock(_addonData.unlockData["instances"], 65, {["subText"] = _L["DUNGEON"], ["id"] = 252, ["icon"] = "Interface/LFGFRAME/LFGICON-AUCHINDOUN"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 258, ["icon"] = "Interface/LFGFRAME/LFGICON-TEMPESTKEEP"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 253, ["icon"] = "Interface/LFGFRAME/LFGICON-AUCHINDOUN"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 259, ["icon"] = "Interface/LFGFRAME/LFGICON-HELLFIRECITADEL"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 257, ["icon"] = "Interface/LFGFRAME/LFGICON-TEMPESTKEEP"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 261, ["icon"] = "Interface/LFGFRAME/LFGICON-COILFANG"});
	AddUnlock(_addonData.unlockData["instances"], 68, {["subText"] = _L["DUNGEON"], ["id"] = 249, ["icon"] = "Interface/LFGFRAME/LFGICON-MAGISTERSTERRACE"});
	AddUnlock(_addonData.unlockData["instances"], 68, {["subText"] = _L["DUNGEON"], ["id"] = 255, ["icon"] = "Interface/LFGFRAME/LFGICON-CAVERNSOFTIME"});
	AddUnlock(_addonData.unlockData["instances"], 68, {["subText"] = _L["DUNGEON"], ["id"] = 254, ["icon"] = "Interface/LFGFRAME/LFGICON-TEMPESTKEEP"});
	AddUnlock(_addonData.unlockData["instances"], 70, {["subText"] = _L["DUNGEON_HEROIC"], ["name"] = _L["HEROIC_OUTLAND"], ["id"] = _aVar.TBC_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGICON-DUNGEON"});
	AddUnlock(_addonData.unlockData["instances"], 70, {["subText"] = _L["RAID"], ["name"] = _L["RAID_OUTLAND"], ["id"] = _aVar.TBC_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGICON-BLACKTEMPLE"});
-- WotLK
	AddUnlock(_addonData.unlockData["instances"], 58, {["subText"] = _L["DUNGEON"], ["id"] = 285, ["icon"] = "Interface/LFGFRAME/LFGIcon-Utgarde"});
	AddUnlock(_addonData.unlockData["instances"], 59, {["subText"] = _L["DUNGEON"], ["id"] = 281, ["icon"] = "Interface/LFGFRAME/LFGIcon-TheNexus"});
	AddUnlock(_addonData.unlockData["instances"], 60, {["subText"] = _L["DUNGEON"], ["id"] = 272, ["icon"] = "Interface/LFGFRAME/LFGIcon-AzjolNerub"});
	AddUnlock(_addonData.unlockData["instances"], 61, {["subText"] = _L["DUNGEON"], ["id"] = 271, ["icon"] = "Interface/LFGFRAME/LFGIcon-Ahnkalet"});
	AddUnlock(_addonData.unlockData["instances"], 62, {["subText"] = _L["DUNGEON"], ["id"] = 273, ["icon"] = "Interface/LFGFRAME/LFGIcon-DrakTharon"});
	AddUnlock(_addonData.unlockData["instances"], 63, {["subText"] = _L["DUNGEON"], ["id"] = 283, ["icon"] = "Interface/LFGFRAME/LFGIcon-TheVioletHold"});
	AddUnlock(_addonData.unlockData["instances"], 64, {["subText"] = _L["DUNGEON"], ["id"] = 274, ["icon"] = "Interface/LFGFRAME/LFGIcon-Gundrak"});
	AddUnlock(_addonData.unlockData["instances"], 65, {["subText"] = _L["DUNGEON"], ["id"] = 277, ["icon"] = "Interface/LFGFRAME/LFGIcon-HallsofStone"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 275, ["icon"] = "Interface/LFGFRAME/LFGICON-HALLSOFLIGHTNING"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 282, ["icon"] = "Interface/LFGFRAME/LFGIcon-TheOculus"});
	AddUnlock(_addonData.unlockData["instances"], 67, {["subText"] = _L["DUNGEON"], ["id"] = 286, ["icon"] = "Interface/LFGFRAME/LFGIcon-UtgardePinnacle"});
	AddUnlock(_addonData.unlockData["instances"], 68, {["subText"] = _L["DUNGEON"], ["id"] = 279, ["icon"] = "Interface/LFGFRAME/LFGIcon-OldStratholme"});
	AddUnlock(_addonData.unlockData["instances"], 68, {["subText"] = _L["DUNGEON"], ["id"] = 284, ["icon"] = "Interface/LFGFRAME/LFGIcon-ArgentDungeon"});
	AddUnlock(_addonData.unlockData["instances"], 70, {["subText"] = _L["DUNGEON"], ["id"] = 280, ["icon"] = "Interface/LFGFRAME/LFGIcon-TheForgeofSouls"});
	AddUnlock(_addonData.unlockData["instances"], 70, {["subText"] = _L["DUNGEON"], ["id"] = 278, ["icon"] = "Interface/LFGFRAME/LFGIcon-PitofSaron"});
	AddUnlock(_addonData.unlockData["instances"], 70, {["subText"] = _L["DUNGEON"], ["id"] = 276, ["icon"] = "Interface/LFGFRAME/LFGIcon-HallsofReflection"});
	AddUnlock(_addonData.unlockData["instances"], 80, {["subText"] = _L["DUNGEON_HEROIC"], ["name"] = _L["HEROIC_NORTHREND"], ["id"] = _aVar.WOTLK_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGICON-DUNGEON"});
	AddUnlock(_addonData.unlockData["instances"], 80, {["subText"] = _L["RAID"], ["name"] = _L["RAID_NORTHRED"], ["id"] = _aVar.WOTLK_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGIcon-IcecrownCitadel"});
-- Cataclysm
	AddUnlock(_addonData.unlockData["instances"], 80, {["subText"] = _L["DUNGEON"], ["id"] = 66, ["icon"] = "Interface/LFGFRAME/LFGICON-BLACKROCKCAVERNS"});
	AddUnlock(_addonData.unlockData["instances"], 80, {["subText"] = _L["DUNGEON"], ["id"] = 65, ["icon"] = "Interface/LFGFRAME/LFGICON-THRONEOFTHETIDES"});
	AddUnlock(_addonData.unlockData["instances"], 81, {["subText"] = _L["DUNGEON"], ["id"] = 67, ["icon"] = "Interface/LFGFRAME/LFGICON-THESTONECORE"});
	AddUnlock(_addonData.unlockData["instances"], 81, {["subText"] = _L["DUNGEON"], ["id"] = 68, ["icon"] = "Interface/LFGFRAME/LFGICON-THEVORTEXPINNACLE"});
	AddUnlock(_addonData.unlockData["instances"], 84, {["subText"] = _L["DUNGEON"], ["id"] = 69, ["icon"] = "Interface/LFGFRAME/LFGICON-LOSTCITYOFTOLVIR"});
	AddUnlock(_addonData.unlockData["instances"], 84, {["subText"] = _L["DUNGEON"], ["id"] = 70, ["icon"] = "Interface/LFGFRAME/LFGICON-HALLSOFORIGINATION"});
	AddUnlock(_addonData.unlockData["instances"], 84, {["subText"] = _L["DUNGEON"], ["id"] = 71, ["icon"] = "Interface/LFGFRAME/LFGICON-GRIMBATOLRAID"});
	AddUnlock(_addonData.unlockData["instances"], 85, {["subText"] = _L["DUNGEON_HEROIC"], ["name"] = _L["HEROIC_CATACLYSM"], ["id"] = _aVar.CATA_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGICON-DUNGEON"});
	AddUnlock(_addonData.unlockData["instances"], 85, {["subText"] = _L["RAID"], ["name"] = _L["RAID_CATACLYSM"], ["id"] = _aVar.CATA_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGIcon-FallofDeathwing"});
-- Mist of Pandaria
	AddUnlock(_addonData.unlockData["instances"], 80, {["subText"] = _L["DUNGEON"], ["id"] = 302, ["icon"] = "Interface/LFGFRAME/LFGIcon-StormstoutBrewery"});
	AddUnlock(_addonData.unlockData["instances"], 80, {["subText"] = _L["DUNGEON"], ["id"] = 313, ["icon"] = "Interface/LFGFRAME/LFGIcon-TempleoftheJadeSerpent"});
	AddUnlock(_addonData.unlockData["instances"], 82, {["subText"] = _L["DUNGEON"], ["id"] = 312, ["icon"] = "Interface/LFGFRAME/LFGIcon-ShadowpanMonastery"});
	AddUnlock(_addonData.unlockData["instances"], 82, {["subText"] = _L["DUNGEON"], ["id"] = 321, ["icon"] = "Interface/LFGFRAME/LFGIcon-MogushanPalace"});
	AddUnlock(_addonData.unlockData["instances"], 83, {["subText"] = _L["DUNGEON"], ["id"] = 303, ["icon"] = "Interface/LFGFRAME/LFGIcon-GateoftheSettingSun"});
	AddUnlock(_addonData.unlockData["instances"], 83, {["subText"] = _L["DUNGEON"], ["id"] = 324, ["icon"] = "Interface/LFGFRAME/LFGIcon-SiegeofNizaoTemple"});
	AddUnlock(_addonData.unlockData["instances"], 90, {["subText"] = _L["DUNGEON_HEROIC"], ["name"] = _L["HEROIC_PANDARIA"], ["id"] = _aVar.MOP_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGICON-DUNGEON"});
	AddUnlock(_addonData.unlockData["instances"], 90, {["subText"] = _L["RAID"], ["name"] = _L["RAID_PANDARIA"], ["id"] = _aVar.MOP_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGIcon-OrgrimmarGates"});
-- WoD
	AddUnlock(_addonData.unlockData["instances"], 90, {["subText"] = _L["DUNGEON"], ["id"] = 385, ["icon"] = "Interface/LFGFRAME/LFGIcon-BloodmaulSlagMines"});
	AddUnlock(_addonData.unlockData["instances"], 92, {["subText"] = _L["DUNGEON"], ["id"] = 558, ["icon"] = "Interface/LFGFRAME/LFGIcon-IronDocks"});
	AddUnlock(_addonData.unlockData["instances"], 94, {["subText"] = _L["DUNGEON"], ["id"] = 547, ["icon"] = "Interface/LFGFRAME/LFGIcon-AuchindounWOD"});
	AddUnlock(_addonData.unlockData["instances"], 97, {["subText"] = _L["DUNGEON"], ["id"] = 476, ["icon"] = "Interface/LFGFRAME/LFGIcon-Skyreach"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 536, ["icon"] = "Interface/LFGFRAME/LFGIcon-GrimrailDepot"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 537, ["icon"] = "Interface/LFGFRAME/LFGIcon-ShadowmoonBurialGrounds"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 556, ["icon"] = "Interface/LFGFRAME/LFGIcon-Everbloom"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 559, ["icon"] = "Interface/LFGFRAME/LFGIcon-UpperBlackrockSpire"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON_HEROIC"], ["name"] = _L["HEROIC_DRAENOR"], ["id"] = _aVar.WOD_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGICON-DUNGEON"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["RAID"], ["name"] = _L["RAID_DRAENOR"], ["id"] = _aVar.WOD_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGICON-HELLFIRECITADELRAID"});
-- Legion
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 762, ["icon"] = "Interface/LFGFRAME/LFGIcon-DarkheartThicket"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 716, ["icon"] = "Interface/LFGFRAME/LFGIcon-EyeofAzshara"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 721, ["icon"] = "Interface/LFGFRAME/LFGIcon-HallsofValor"});
	AddUnlock(_addonData.unlockData["instances"], 100, {["subText"] = _L["DUNGEON"], ["id"] = 767, ["icon"] = "Interface/LFGFRAME/LFGIcon-NeltharionsLair"});
	AddUnlock(_addonData.unlockData["instances"], 105, {["subText"] = _L["DUNGEON"], ["id"] = 777, ["icon"] = "Interface/LFGFRAME/LFGIcon-AssaultonVioletHold"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON"], ["id"] = 740, ["icon"] = "Interface/LFGFRAME/LFGIcon-BlackRookHold"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON"], ["id"] = 800, ["icon"] = "Interface/LFGFRAME/LFGIcon-CourtofStars"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON"], ["id"] = 727, ["icon"] = "Interface/LFGFRAME/LFGIcon-MawofSouls"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON"], ["id"] = 726, ["icon"] = "Interface/LFGFRAME/LFGIcon-TheArcway"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON"], ["id"] = 707, ["icon"] = "Interface/LFGFRAME/LFGIcon-VaultoftheWardens"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON_HEROIC"], ["name"] = _L["HEROIC_LEGION"], ["id"] = _aVar.LEGION_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGICON-DUNGEON"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["DUNGEON_MYTHIC"], ["name"] = _L["MYTHIC_LEGION"], ["id"] = _aVar.LEGION_HEROIC, ["icon"] = "Interface/LFGFRAME/LFGIcon-OnyxiaEncounter"});
	AddUnlock(_addonData.unlockData["instances"], 110, {["subText"] = _L["RAID"], ["name"] =  _L["RAID_LEGION"], ["id"] = _aVar.LEGION_RAID, ["isRaid"] = true, ["icon"] = "Interface/LFGFRAME/LFGIcon-TheEmeraldNightmare-RiftofAln"});


	
--------------------------
-- Battlegrounds
--------------------------

_addonData.unlockData["PVP"] = { };
	AddUnlock(_addonData.unlockData["PVP"], 10, {["subText"] = _L["BATTLEGROUND"], ["id"] = 1, ["icon"] = "Interface/ICONS/achievement_bg_winwsg"});
	AddUnlock(_addonData.unlockData["PVP"], 10, {["subText"] = _L["BATTLEGROUND"], ["id"] = 2, ["icon"] = "Interface/ICONS/achievement_bg_takexflags_ab"});
	AddUnlock(_addonData.unlockData["PVP"], 35, {["subText"] = _L["BATTLEGROUND"], ["id"] = 3, ["icon"] = "Interface/ICONS/Achievement_Zone_Netherstorm_01"});
	AddUnlock(_addonData.unlockData["PVP"], 45, {["subText"] = _L["BATTLEGROUND"], ["id"] = 4, ["icon"] = "Interface/ICONS/achievement_bg_defendxtowers_av"});
	AddUnlock(_addonData.unlockData["PVP"], 65, {["subText"] = _L["BATTLEGROUND"], ["id"] = 10, ["icon"] = "Interface/LFGFRAME/LFGICON-STRANDOFTHEANCIENTS"});
	AddUnlock(_addonData.unlockData["PVP"], 75, {["subText"] = _L["BATTLEGROUND"], ["id"] = 5, ["icon"] = "Interface/LFGFRAME/LFGICON-THEBATTLEFORGILNEAS"});
	AddUnlock(_addonData.unlockData["PVP"], 75, {["subText"] = _L["BATTLEGROUND"], ["id"] = 6, ["icon"] = "Interface/LFGFRAME/LFGIcon-TwinPeaksBG"});
	AddUnlock(_addonData.unlockData["PVP"], 75, {["subText"] = _L["BATTLEGROUND"], ["id"] = 11, ["icon"] = "Interface/LFGFRAME/LFGIcon-IsleOfConquest"});
	AddUnlock(_addonData.unlockData["PVP"], 75, {["subText"] = _L["WORLD_PVP"], ["id"] = 1, ["icon"] = "Interface/ICONS/INV_EssenceOfWintergrasp"});
	AddUnlock(_addonData.unlockData["PVP"], 85, {["subText"] = _L["WORLD_PVP"], ["id"] = 2, ["icon"] = "Interface/ICONS/Achievement_Zone_TolBarad"});
	AddUnlock(_addonData.unlockData["PVP"], 90, {["subText"] = _L["BATTLEGROUND"], ["id"] = 9, ["icon"] = "Interface/LFGFRAME/LFGIcon-DeepwindGorge"});
	AddUnlock(_addonData.unlockData["PVP"], 90, {["subText"] = _L["BATTLEGROUND"], ["id"] = 7, ["icon"] = "Interface/LFGFRAME/LFGIcon-SilvershardMines"});
	AddUnlock(_addonData.unlockData["PVP"], 90, {["subText"] = _L["BATTLEGROUND"], ["id"] = 8, ["icon"] = "Interface/LFGFRAME/LFGIcon-TempleofKotmogu"});
	AddUnlock(_addonData.unlockData["PVP"], 100, {["subText"] = _L["WORLD_PVP"], ["id"] = 3, ["icon"] = "Interface/ICONS/Achievement_Zone_Ashran"});
	
	
	
--------------------------
-- Spells
--------------------------

--
-- MAGE
--

if (playerClass == "MAGE")	then
local mageSpecs = {
	62 -- Arcana
	,63 -- Fire
	,64 -- Frost
};

local mageSkills = { };
	AddUnlock(mageSkills, 3, {["id"] = 108853}); -- Fire Blast
	AddUnlock(mageSkills, 5, {["id"] = 122}); -- Frost Nova
	AddUnlock(mageSkills, 8, {["id"] = 118}); -- Polymorph
	AddUnlock(mageSkills, 10, {["id"] = 30455, ["specs"] = {64}}); -- Ice Lance
	AddUnlock(mageSkills, 10, {["id"] = 44425, ["specs"] = {62}}); -- Arcane Barrage
	AddUnlock(mageSkills, 10, {["id"] = 30451, ["specs"] = {62}}); -- Arcane Blast
	AddUnlock(mageSkills, 10, {["id"] = 117216, ["specs"] = {63}}); -- Crititcal Mass
	AddUnlock(mageSkills, 10, {["id"] = 133, ["specs"] = {63}}); -- Fireball
	AddUnlock(mageSkills, 12, {["id"] = 11366, ["specs"] = {63}}); -- Pyroblast
	AddUnlock(mageSkills, 12, {["id"] = 31687, ["specs"] = {64}}); -- Summon Water Elemental
	AddUnlock(mageSkills, 12, {["id"] = 5143, ["specs"] = {62}}); -- Arcane Missiles
	AddUnlock(mageSkills, 14, {["id"] = 231568, ["specs"] = {63}}); -- Fire Blast 2
	AddUnlock(mageSkills, 14, {["id"] = 195283, ["specs"] = {63}}); -- Hot Streak
	AddUnlock(mageSkills, 14, {["id"] = 12982, ["specs"] = {64}}); -- Shatter
	AddUnlock(mageSkills, 16, {["id"] = 1953}); -- Blink
	AddUnlock(mageSkills, 18, {["id"] = 1449, ["specs"] = {62}}); -- Arcane Explosion
	AddUnlock(mageSkills, 18, {["id"] = 190356, ["specs"] = {64}}); -- Blizzard
	AddUnlock(mageSkills, 18, {["id"] = 2948, ["specs"] = {63}}); -- Scorch
	AddUnlock(mageSkills, 20, {["id"] = 12051, ["specs"] = {62}}); -- Evocation
	AddUnlock(mageSkills, 20, {["id"] = 2120, ["specs"] = {63}}); -- Flamestrike
	AddUnlock(mageSkills, 20, {["id"] = 44614, ["specs"] = {64}}); -- Flurry
	AddUnlock(mageSkills, 22, {["id"] = 2139}); -- Counterspell
	AddUnlock(mageSkills, 24, {["id"] = 112965, ["specs"] = {64}}); -- Fingers of Frost
	AddUnlock(mageSkills, 26, {["id"] = 235313, ["specs"] = {63}}); -- Blazing Barrier
	AddUnlock(mageSkills, 26, {["id"] = 11426, ["specs"] = {64}}); -- Ice Barrier
	AddUnlock(mageSkills, 26, {["id"] = 235450, ["specs"] = {62}}); -- Prismatic Barrier
	AddUnlock(mageSkills, 28, {["id"] = 190447, ["specs"] = {64}}); -- Brain Freeze
	AddUnlock(mageSkills, 32, {["id"] = 31661, ["specs"] = {63}}); -- Dragon's Breath
	AddUnlock(mageSkills, 32, {["id"] = 31589, ["specs"] = {62}}); -- Slow
	AddUnlock(mageSkills, 34, {["id"] = 231564, ["specs"] = {62}}); -- Arcane Barrage 2
	AddUnlock(mageSkills, 34, {["id"] = 120, ["specs"] = {64}}); -- Cone of Cold
	AddUnlock(mageSkills, 35, {["id"] = 157642, ["specs"] = {63}}); -- Enhanced Pyrotechnics
	AddUnlock(mageSkills, 36, {["id"] = 231582, ["specs"] = {64}}); -- Shatter 2
	AddUnlock(mageSkills, 38, {["id"] = 130}); -- Slow Fall
	AddUnlock(mageSkills, 40, {["id"] = 12042, ["specs"] = {62}}); -- Arcane Power
	AddUnlock(mageSkills, 40, {["id"] = 190319, ["specs"] = {63}}); -- Combustion
	AddUnlock(mageSkills, 40, {["id"] = 12472, ["specs"] = {64}}); -- Icy Veins
	AddUnlock(mageSkills, 42, {["id"] = 66, ["specs"] = {63, 64, 62}}); -- Invisibility
	AddUnlock(mageSkills, 48, {["id"] = 231584, ["specs"] = {64}}); -- Brain Freeze 2
	AddUnlock(mageSkills, 42, {["id"] = 195676, ["specs"] = {62}}); -- Displacement
	AddUnlock(mageSkills, 48, {["id"] = 231567, ["specs"] = {63}}); -- Fire Blast 3
	AddUnlock(mageSkills, 50, {["id"] = 45438}); -- Ice Block
	AddUnlock(mageSkills, 52, {["id"] = 49361}); -- Portal: Stonard
	AddUnlock(mageSkills, 52, {["id"] = 49358}); -- Teleport: Stonard
	AddUnlock(mageSkills, 52, {["id"] = 86949, ["specs"] = {63}}); -- Cauterize
	AddUnlock(mageSkills, 52, {["id"] = 235219, ["specs"] = {64}}); -- Cold Snap
	AddUnlock(mageSkills, 54, {["id"] = 205025, ["specs"] = {62}}); -- Presence of Mind
	AddUnlock(mageSkills, 56, {["id"] = 231565, ["specs"] = {62}}); -- Evocation 2
	AddUnlock(mageSkills, 57, {["id"] = 84714, ["specs"] = {64}}); -- Frozen Orb
	AddUnlock(mageSkills, 63, {["id"] = 236662, ["specs"] = {64}}); -- Blizzard 2
	AddUnlock(mageSkills, 65, {["id"] = 231630, ["specs"] = {63}}); -- Crititcal Mass 2
	AddUnlock(mageSkills, 65, {["id"] = 110959, ["specs"] = {62}}); -- Greater Invisibility
	AddUnlock(mageSkills, 70, {["id"] = 30449}); -- Spellsteal
	AddUnlock(mageSkills, 71, {["id"] = 120145,}); -- Ancient Teleport: Dalaran
	AddUnlock(mageSkills, 71, {["id"] = 224869}); -- Teleport: Dalaran - Broken Isles
	AddUnlock(mageSkills, 71, {["id"] = 53140}); -- Teleport: Dalaran - Northrend
	AddUnlock(mageSkills, 74, {["id"] = 120146}); -- Ancient Portal: Dalaran
	AddUnlock(mageSkills, 74, {["id"] = 224871}); -- Ancient Portal: Dalaran - Broken Isles
	AddUnlock(mageSkills, 74, {["id"] = 53142}); -- Portal: Dalaran - Northrend
	AddUnlock(mageSkills, 78, {["id"] = 76613, ["specs"] = {64}}); -- Mastery: Icicles
	AddUnlock(mageSkills, 78, {["id"] = 12846, ["specs"] = {63}}); -- Mastery: Ignite
	AddUnlock(mageSkills, 78, {["id"] = 190740, ["specs"] = {62}}); -- Mastery: Savant
	AddUnlock(mageSkills, 80, {["id"] = 80353}); -- Time Warp

if (playerFaction == "Alliance") then
	AddUnlock(mageSkills, 17, {["id"] = 3565});
	AddUnlock(mageSkills, 17, {["id"] = 32271});
	AddUnlock(mageSkills, 17, {["id"] = 3562});
	AddUnlock(mageSkills, 17, {["id"] = 3561});
	AddUnlock(mageSkills, 17, {["id"] = 49359});
	AddUnlock(mageSkills, 42, {["id"] = 11419}); -- Portal: Darnassus
	AddUnlock(mageSkills, 42, {["id"] = 32266}); -- Portal: Exodar
	AddUnlock(mageSkills, 42, {["id"] = 11416}); -- Portal: Ironforge
	AddUnlock(mageSkills, 42, {["id"] = 10059}); -- Portal: Stormwind
	AddUnlock(mageSkills, 42, {["id"] = 49360}); -- Portal: Theramore
	AddUnlock(mageSkills, 62, {["id"] = 33690}); -- Teleport: Shattrath
	AddUnlock(mageSkills, 66, {["id"] = 33691}); -- Portal: Shattrath
	AddUnlock(mageSkills, 85, {["id"] = 88342}); -- Teleport: Tol Barad
	AddUnlock(mageSkills, 85, {["id"] = 88345}); -- Portal: Tol Barad
	AddUnlock(mageSkills, 90, {["id"] = 132621}); -- Teleport: Vale of Eternal Blossoms
	AddUnlock(mageSkills, 90, {["id"] = 132620}); -- Portal: Vale of Eternal Blossoms
	AddUnlock(mageSkills, 92, {["id"] = 176248}); -- Teleport: Stormshield
	AddUnlock(mageSkills, 92, {["id"] = 176246}); -- Portal: Stormshield
else
	AddUnlock(mageSkills, 17,{["id"] = 32272}); 
	AddUnlock(mageSkills, 17,{["id"] = 3567});
	AddUnlock(mageSkills, 17,{["id"] = 3566});
	AddUnlock(mageSkills, 17,{["id"] = 3563});
	AddUnlock(mageSkills, 42,{["id"] = 11417}); -- Portal: Orgrimmar
	AddUnlock(mageSkills, 42,{["id"] = 32267}); -- Portal: Silvermoon
	AddUnlock(mageSkills, 42,{["id"] = 11420}); -- Portal: Thunder Bluff
	AddUnlock(mageSkills, 42,{["id"] = 11418}); -- Portal: Undercity
	AddUnlock(mageSkills, 62,{["id"] = 35715}); -- Teleport: Shattrath
	AddUnlock(mageSkills, 66,{["id"] = 35717}); -- Portal: Shattrath
	AddUnlock(mageSkills, 85,{["id"] = 88344}); -- Teleport: Tol Barad
	AddUnlock(mageSkills, 85,{["id"] = 88346}); -- Portal: Tol Barad
	AddUnlock(mageSkills, 90,{["id"] = 132627}); -- Teleport: Vale of Eternal Blossoms
	AddUnlock(mageSkills, 90,{["id"] = 132626}); -- Portal: Vale of Eternal Blossoms
	AddUnlock(mageSkills, 92,{["id"] = 176242}); -- Teleport: Warspear
	AddUnlock(mageSkills, 92,{["id"] = 176244}); -- Portal: Warspear
end                             

_addonData.unlockData["skills"] = mageSkills;
_addonData.unlockData["specs"] = mageSpecs;

end

--
-- PALADIN
--

if (playerClass == "PALADIN")	then
local paladinSpecs = {
	65 -- Holy
	,66 -- Protection
	,70 -- Retribution
};

local paladinSkills = { };
	AddUnlock(paladinSkills, 3, {["id"] = 20271}); -- Judgement
	AddUnlock(paladinSkills, 5, {["id"] = 19750}); -- Flash of Light
	AddUnlock(paladinSkills, 8, {["id"] = 853}); -- Hammer of Justice
	AddUnlock(paladinSkills, 10, {["id"] = 31935, ["specs"] = {66}}); -- Avenger's Shield
	AddUnlock(paladinSkills, 10, {["id"] = 53592, ["specs"] = {66}}); -- Guarded by the Light
	AddUnlock(paladinSkills, 10, {["id"] = 53595, ["specs"] = {66}}); -- Hammer of the Righteous
	AddUnlock(paladinSkills, 10, {["id"] = 20473, ["specs"] = {65}}); -- Holy Shock
	AddUnlock(paladinSkills, 10, {["id"] = 25780, ["specs"] = {66}}); -- Righteous Fury
	AddUnlock(paladinSkills, 10, {["id"] = 105805, ["specs"] = {66}}); -- Sanctuary
	AddUnlock(paladinSkills, 10, {["id"] = 85256, ["specs"] = {70}}); -- Templar's Verdict
	AddUnlock(paladinSkills, 12, {["id"] = 62124}); -- Hand of Reckoning
	AddUnlock(paladinSkills, 14, {["id"] = 7328}); -- Redemption
	AddUnlock(paladinSkills, 16, {["id"] = 231661, ["specs"] = {70}}); -- Judgement 2
	AddUnlock(paladinSkills, 18, {["id"] = 642}); -- Divine Shield
	AddUnlock(paladinSkills, 20, {["id"] = 53563, ["specs"] = {65}}); -- Beacon of Light
	AddUnlock(paladinSkills, 20, {["id"] = 184575, ["specs"] = {70}}); -- Blade of Justice
	AddUnlock(paladinSkills, 20, {["id"] = 53600, ["specs"] = {66}}); -- Shield of the Righteous
	AddUnlock(paladinSkills, 22, {["id"] = 4987, ["specs"] = {65}}); -- Cleanse
	AddUnlock(paladinSkills, 22, {["id"] = 213644, ["specs"] = {66, 70}}); -- Cleanse Toxins
	AddUnlock(paladinSkills, 24, {["id"] = 183218, ["specs"] = {70}}); -- Hand of Hindrance
	AddUnlock(paladinSkills, 25, {["id"] = 85043, ["specs"] = {66}}); -- Grand Crusader
	AddUnlock(paladinSkills, 25, {["id"] = 82326, ["specs"] = {65}}); -- Holy Light
	AddUnlock(paladinSkills, 26, {["id"] = 231667, ["specs"] = {65, 70}}); -- Crusader Strike
	AddUnlock(paladinSkills, 28, {["id"] = 105424, ["specs"] = {66}}); -- Judgments of the Wise
	AddUnlock(paladinSkills, 28, {["id"] = 190784}); -- Divine Shield
	AddUnlock(paladinSkills, 32, {["id"] = 498, ["specs"] = {65, 66}}); -- Divine Protection
	AddUnlock(paladinSkills, 32, {["id"] = 184662, ["specs"] = {70}}); -- Shield of Vengeance
	AddUnlock(paladinSkills, 35, {["id"] = 53576, ["specs"] = {65}}); -- Infusion of Light
	AddUnlock(paladinSkills, 35, {["id"] = 96231, ["specs"] = {66, 70}}); -- Rebuke
	AddUnlock(paladinSkills, 38, {["id"] = 1044}); -- Blessing of Freedom
	AddUnlock(paladinSkills, 40, {["id"] = 53385, ["specs"] = {70}}); -- Divine Storm
	AddUnlock(paladinSkills, 40, {["id"] = 85222, ["specs"] = {65}}); -- Light of Dawn
	AddUnlock(paladinSkills, 40, {["id"] = 184092, ["specs"] = {66}}); -- Light of the Protector
	AddUnlock(paladinSkills, 42, {["id"] = 231665, ["specs"] = {66}}); -- Avenger's Shield
	AddUnlock(paladinSkills, 42, {["id"] = 231664, ["specs"] = {65}}); -- Judgment 2
	AddUnlock(paladinSkills, 42, {["id"] = 231657, ["specs"] = {66}}); -- Judgment 2
	AddUnlock(paladinSkills, 42, {["id"] = 231663, ["specs"] = {70}}); -- Judgment 2
	AddUnlock(paladinSkills, 44, {["id"] = 32223}); -- Heart of the Crusader
	AddUnlock(paladinSkills, 48, {["id"] = 1022, ["specs"] = {65, 66, 70}}); -- Blessing of Protection
	AddUnlock(paladinSkills, 50, {["id"] = 31850, ["specs"] = {66}}); -- Argent Defender
	AddUnlock(paladinSkills, 50, {["id"] = 183998, ["specs"] = {65}}); -- Light of the Martyr
	AddUnlock(paladinSkills, 50, {["id"] = 86102, ["specs"] = {66}}); -- Plate Specialization
	AddUnlock(paladinSkills, 50, {["id"] = 86103, ["specs"] = {65}}); -- Plate Specialization
	AddUnlock(paladinSkills, 50, {["id"] = 86539, ["specs"] = {70}}); -- Plate Specialization
	AddUnlock(paladinSkills, 52, {["id"] = 231663, ["specs"] = {65}}); -- Beacon of Light 2
	AddUnlock(paladinSkills, 55, {["id"] = 633}); -- Lay on Hands
	AddUnlock(paladinSkills, 56, {["id"] = 6940, ["specs"] = {65, 66}}); -- Blessing of Sacrifice
	AddUnlock(paladinSkills, 58, {["id"] = 203538, ["specs"] = {70}}); -- Greater Blessing of Kings
	AddUnlock(paladinSkills, 63, {["id"] = 227068, ["specs"] = {65}}); -- Righteousness
	AddUnlock(paladinSkills, 65, {["id"] = 203539, ["specs"] = {70}}); -- Greater Blessing of Wisdom
	AddUnlock(paladinSkills, 65, {["id"] = 227068, ["specs"] = {66}}); -- Riposte
	AddUnlock(paladinSkills, 66, {["id"] = 212056, ["specs"] = {65}}); -- Absolution
	AddUnlock(paladinSkills, 70, {["id"] = 31821, ["specs"] = {65}}); -- Aura Mastery
	AddUnlock(paladinSkills, 70, {["id"] = 86659, ["specs"] = {66}}); -- Guardian of Ancient Kings
	AddUnlock(paladinSkills, 70, {["id"] = 183435, ["specs"] = {70}}); -- Riposte
	AddUnlock(paladinSkills, 78, {["id"] = 76671, ["specs"] = {66}}); -- Mastery: Divine Bulwark
	AddUnlock(paladinSkills, 78, {["id"] = 76672, ["specs"] = {70}}); -- Mastery: Divine Judgment
	AddUnlock(paladinSkills, 78, {["id"] = 183997, ["specs"] = {65}}); -- Mastery: Lightbringer
	AddUnlock(paladinSkills, 80, {["id"] = 31842, ["specs"] = {65}}); -- Avenging Wrath
	AddUnlock(paladinSkills, 80, {["id"] = 31884, ["specs"] = {66, 70}}); -- Avenging Wrath
	
	local _, race = UnitRace("player");
	if (race == "Draenei") then
		AddUnlock(paladinSkills, 20, {["id"] = 73629}); -- Summon Exarch's Elekk
		AddUnlock(paladinSkills, 40, {["id"] = 73630}); -- Summon Great Exarch's Elekk
	elseif (race == "Tauren") then
		AddUnlock(paladinSkills, 20, {["id"] = 69820}); -- Summon Exarch's Kodo
		AddUnlock(paladinSkills, 40, {["id"] = 69826}); -- Summon Great Exarch's Kodo
	elseif (race == "Blood Elf") then
		AddUnlock(paladinSkills, 20, {["id"] = 34769}); -- Summon Thalassian Warhorse
		AddUnlock(paladinSkills, 40, {["id"] = 34767}); -- Summon Great Thalassian Warhorse
	else -- dwarf / human
		AddUnlock(paladinSkills, 20, {["id"] = 13819}); -- Summon Warhorse
		AddUnlock(paladinSkills, 40, {["id"] = 23214}); -- Summon Great Warhorse
	end

_addonData.unlockData["skills"] = paladinSkills;
_addonData.unlockData["specs"] = paladinSpecs;

end

--
-- WARRIOR
--

if (playerClass == "WARRIOR") then
local warriorSpecs = {
	71 -- Arms
	,72 -- Fury
	,73 -- Protection
};

local warriorSkills = { };
	-- AddUnlock(warriorSkills, 52, {["id"] = 231663, ["specs"] = {65}, ["isPassive"] = true, ["rank"] = 2}); -- Beacon of Light 2
	
	AddUnlock(warriorSkills, 3, {["id"] = 100}); -- Charge
	AddUnlock(warriorSkills, 5, {["id"] = 34428, ["specs"] = {71, 73}}); -- Victory Rush
	AddUnlock(warriorSkills, 8, {["id"] = 5308, ["specs"] = {72}}); -- Execute
	AddUnlock(warriorSkills, 8, {["id"] = 163201, ["specs"] = {71}}); -- Execute
	AddUnlock(warriorSkills, 10, {["id"] = 71, ["specs"] = {73}}); -- Defensive Stance
	AddUnlock(warriorSkills, 10, {["id"] = 23881, ["specs"] = {72}}); -- Bloodthirst
	AddUnlock(warriorSkills, 10, {["id"] = 20243, ["specs"] = {73}}); -- Devastate
	AddUnlock(warriorSkills, 10, {["id"] = 100130, ["specs"] = {72}}); -- Furious Slash
	AddUnlock(warriorSkills, 10, {["id"] = 12294, ["specs"] = {71}}); -- Mortal Strike
	AddUnlock(warriorSkills, 10, {["id"] = 23922, ["specs"] = {73}}); -- Shield Slam
	AddUnlock(warriorSkills, 10, {["id"] = 231842, ["specs"] = {72}}); -- Dual Wield
	AddUnlock(warriorSkills, 10, {["id"] = 46917, ["specs"] = {72}}); -- Titan's Grip
	AddUnlock(warriorSkills, 10, {["id"] = 29144, ["specs"] = {73}}); -- Unwavering Sentinel
	AddUnlock(warriorSkills, 12, {["id"] = 184367, ["specs"] = {72}}); -- Rampage
	AddUnlock(warriorSkills, 13, {["id"] = 355}); -- Taunt
	AddUnlock(warriorSkills, 14, {["id"] = 184361, ["specs"] = {72}}); -- Enrage
	AddUnlock(warriorSkills, 14, {["id"] = 6343, ["specs"] = {73}}); -- Thunder Clap
	AddUnlock(warriorSkills, 17, {["id"] = 57755}); -- Heroic Throw
	AddUnlock(warriorSkills, 20, {["id"] = 167105, ["specs"] = {71}}); -- Colossus Smash
	AddUnlock(warriorSkills, 20, {["id"] = 85288, ["specs"] = {72}}); -- Raging Blow
	AddUnlock(warriorSkills, 20, {["id"] = 2565, ["specs"] = {73}}); -- Shield Block
	AddUnlock(warriorSkills, 22, {["id"] = 845, ["specs"] = {71}}); -- Cleave
	AddUnlock(warriorSkills, 22, {["id"] = 231824, ["specs"] = {72}}); -- Furious Slash 2
	AddUnlock(warriorSkills, 22, {["id"] = 6572, ["specs"] = {73}}); -- Revenge
	AddUnlock(warriorSkills, 24, {["id"] = 6552}); -- Pummel
	AddUnlock(warriorSkills, 26, {["id"] = 6544}); -- Heroic Leap
	AddUnlock(warriorSkills, 28, {["id"] = 231827, ["specs"] = {72}}); -- Execute 2
	AddUnlock(warriorSkills, 28, {["id"] = 231830, ["specs"] = {71}}); -- Execute 2
	AddUnlock(warriorSkills, 32, {["id"] = 1715, ["specs"] = {71}}); -- Hamstring
	AddUnlock(warriorSkills, 32, {["id"] = 12323, ["specs"] = {72}}); -- Piercing Howl
	AddUnlock(warriorSkills, 32, {["id"] = 12975, ["specs"] = {73}}); -- Last Stand
	AddUnlock(warriorSkills, 34, {["id"] = 231834, ["specs"] = {73}}); -- Shield Slam 2
	AddUnlock(warriorSkills, 34, {["id"] = 184783, ["specs"] = {71}}); -- Tacttician
	AddUnlock(warriorSkills, 36, {["id"] = 118038, ["specs"] = {71}}); -- Die by the Sword
	AddUnlock(warriorSkills, 36, {["id"] = 184364, ["specs"] = {72}}); -- Enrged Regeneration
	AddUnlock(warriorSkills, 38, {["id"] = 231847, ["specs"] = {73}}); -- Shield Block 2
	AddUnlock(warriorSkills, 40, {["id"] = 190456, ["specs"] = {73}}); -- Ignore Pain
	AddUnlock(warriorSkills, 40, {["id"] = 1680, ["specs"] = {71}}); -- Whirlwind
	AddUnlock(warriorSkills, 40, {["id"] = 190411, ["specs"] = {72}}); -- Whirlwind
	AddUnlock(warriorSkills, 42, {["id"] = 18499, ["specs"] = {71, 72, 73}}); -- Berserker Rage
	AddUnlock(warriorSkills, 48, {["id"] = 1160, ["specs"] = {73}}); -- Demoralizing Shout
	AddUnlock(warriorSkills, 50, {["id"] = 1719, ["specs"] = {71, 72, 73}}); -- Battle Cry
	AddUnlock(warriorSkills, 50, {["id"] = 86101, ["specs"] = {71}}); -- Plate Specialization
	AddUnlock(warriorSkills, 50, {["id"] = 86110, ["specs"] = {72}}); -- Plate Specialization
	AddUnlock(warriorSkills, 50, {["id"] = 86535, ["specs"] = {73}}); -- Plate Specialization
	AddUnlock(warriorSkills, 55, {["id"] = 231833, ["specs"] = {71}}); -- Cleave 2
	AddUnlock(warriorSkills, 55, {["id"] = 871, ["specs"] = {73}}); -- Shield Wall
	AddUnlock(warriorSkills, 55, {["id"] = 12950, ["specs"] = {72}}); -- Whirlwind 2
	AddUnlock(warriorSkills, 60, {["id"] = 84608, ["specs"] = {73}}); -- Bastion of Defense
	AddUnlock(warriorSkills, 65, {["id"] = 227847, ["specs"] = {71}}); -- Bladestorm
	AddUnlock(warriorSkills, 65, {["id"] = 161798, ["specs"] = {73}}); -- Riposte
	AddUnlock(warriorSkills, 70, {["id"] = 5246, ["specs"] = {71, 72}}); -- Intimidating Shout
	AddUnlock(warriorSkills, 78, {["id"] = 76838, ["specs"] = {71}}); -- Mastery: Colossal Might
	AddUnlock(warriorSkills, 78, {["id"] = 76857, ["specs"] = {73}}); -- Mastery: Critical Block
	AddUnlock(warriorSkills, 78, {["id"] = 76856, ["specs"] = {72}}); -- Mastery: Unshackled Fury
	AddUnlock(warriorSkills, 80, {["id"] = 97462, ["specs"] = {71, 72}}); -- Commanding Shout
	AddUnlock(warriorSkills, 80, {["id"] = 23920, ["specs"] = {73}}); -- Spell Reflection

_addonData.unlockData["skills"] = warriorSkills;
_addonData.unlockData["specs"] = warriorSpecs;

end

--
-- DRUID
--

if (playerClass == "DRUID") then
local druidSpecs = {
	102 -- Balance
	,103 -- Feral
	,104 -- Guardian
	,105 -- Restoration
};

local druidSkills = { };
	AddUnlock(druidSkills, 3, {["id"] = 8921}); -- Moonfire
	AddUnlock(druidSkills, 5, {["id"] = 8936}); -- Regrowth
	AddUnlock(druidSkills, 8, {["id"] = 768}); -- Cat Form
	AddUnlock(druidSkills, 8, {["id"] = 1850}); -- Dash
	AddUnlock(druidSkills, 10, {["id"] = 5487}); -- Bear Form
	AddUnlock(druidSkills, 10, {["id"] = 22568, ["specs"] = {103}}); -- Ferocious Bite
	AddUnlock(druidSkills, 10, {["id"] = 108299, ["specs"] = {102, 105}}); -- Killer Instinct
	AddUnlock(druidSkills, 10, {["id"] = 33917, ["specs"] = {104}}); -- Mangle
	AddUnlock(druidSkills, 10, {["id"] = 6807, ["specs"] = {104}}); -- Maul
	AddUnlock(druidSkills, 10, {["id"] = 33873, ["specs"] = {103, 104}}); -- Nurturing Instinct
	AddUnlock(druidSkills, 10, {["id"] = 774, ["specs"] = {105}}); -- Rejuvenation
	AddUnlock(druidSkills, 10, {["id"] = 5221, ["specs"] = {103}}); -- Shred
	AddUnlock(druidSkills, 10, {["id"] = 78674, ["specs"] = {102}}); -- Starsurge
	AddUnlock(druidSkills, 12, {["id"] = 194153, ["specs"] = {102}}); -- Lunar Strike
	AddUnlock(druidSkills, 12, {["id"] = 1822, ["specs"] = {103}}); -- Rake
	AddUnlock(druidSkills, 12, {["id"] = 18562, ["specs"] = {105}}); -- Swiftmend
	AddUnlock(druidSkills, 12, {["id"] = 106832, ["specs"] = {103, 104}}); -- Thrash
	AddUnlock(druidSkills, 13, {["id"] = 6795}); -- Growl
	AddUnlock(druidSkills, 13, {["id"] = 5217, ["specs"] = {103}}); -- Tiger's Fury
	AddUnlock(druidSkills, 14, {["id"] = 50769}); -- Revive
	AddUnlock(druidSkills, 14, {["id"] = 18960}); -- Teleport: Moonglade
	AddUnlock(druidSkills, 16, {["id"] = 24858, ["specs"] = {102}}); -- Moonkin Form
	AddUnlock(druidSkills, 16, {["id"] = 5215, ["specs"] = {102, 103, 104, 105}}); -- Prowl
	AddUnlock(druidSkills, 16, {["id"] = 93402, ["specs"] = {102, 105}}); -- Sunfire
	AddUnlock(druidSkills, 18, {["id"] = 783}); -- Travel Form
	AddUnlock(druidSkills, 20, {["id"] = 192081, ["specs"] = {104}}); -- Ironfur
	AddUnlock(druidSkills, 20, {["id"] = 33763, ["specs"] = {105}}); -- Lifebloom
	AddUnlock(druidSkills, 20, {["id"] = 1079, ["specs"] = {103}}); -- Riposte
	AddUnlock(druidSkills, 22, {["id"] = 88423, ["specs"] = {105}}); -- Nature's Cure
	AddUnlock(druidSkills, 22, {["id"] = 2782, ["specs"] = {102, 103, 104}}); -- Remove Corruption
	AddUnlock(druidSkills, 24, {["id"] = 339}); -- Entangling Roots
	AddUnlock(druidSkills, 24, {["id"] = 5185, ["specs"] = {105}}); -- Healing Touch
	AddUnlock(druidSkills, 25, {["id"] = 231052, ["specs"] = {103}}); -- Rake 2
	AddUnlock(druidSkills, 26, {["id"] = 22812, ["specs"] = {102, 104, 105}}); -- Barkskin
	AddUnlock(druidSkills, 28, {["id"] = 99, ["specs"] = {104}}); -- Incapacitating Roar
	AddUnlock(druidSkills, 32, {["id"] = 231050, ["specs"] = {102, 105}}); -- Sunfire 2
	AddUnlock(druidSkills, 32, {["id"] = 213764, ["specs"] = {103, 104}}); -- Swipe
	AddUnlock(druidSkills, 34, {["id"] = 197524, ["specs"] = {102}}); -- Astral Influence
	AddUnlock(druidSkills, 34, {["id"] = 131768, ["specs"] = {103}}); -- Feline Swiftness
	AddUnlock(druidSkills, 34, {["id"] = 16931, ["specs"] = {104}}); -- Thick Hide
	AddUnlock(druidSkills, 34, {["id"] = 145108, ["specs"] = {105}}); -- Ysera's Gift
	AddUnlock(druidSkills, 36, {["id"] = 61336, ["specs"] = {103, 104}}); -- Survival Insticts
	AddUnlock(druidSkills, 40, {["id"] = 210053}); -- Stag Form
	AddUnlock(druidSkills, 40, {["id"] = 106951, ["specs"] = {103}}); -- Berserker
	AddUnlock(druidSkills, 40, {["id"] = 22842, ["specs"] = {104}}); -- Frenzied Regeneration
	AddUnlock(druidSkills, 40, {["id"] = 191034, ["specs"] = {102}}); -- Starfall
	AddUnlock(druidSkills, 40, {["id"] = 48438, ["specs"] = {105}}); -- Wild Growth
	AddUnlock(druidSkills, 42, {["id"] = 20484}); -- Rebirth
	AddUnlock(druidSkills, 44, {["id"] = 231064, ["specs"] = {104}}); -- Mangle
	AddUnlock(druidSkills, 44, {["id"] = 231032, ["specs"] = {105}}); -- Regrowth 2
	AddUnlock(druidSkills, 44, {["id"] = 231063, ["specs"] = {103}}); -- Shred 2
	AddUnlock(druidSkills, 44, {["id"] = 231283, ["specs"] = {103}}); -- Swipe 2
	AddUnlock(druidSkills, 48, {["id"] = 194223, ["specs"] = {102}}); -- Celestial Alignment
	AddUnlock(druidSkills, 48, {["id"] = 210706, ["specs"] = {104}}); -- Gorefiend
	AddUnlock(druidSkills, 48, {["id"] = 16864, ["specs"] = {103}}); -- Omen of Clarity
	AddUnlock(druidSkills, 48, {["id"] = 113043, ["specs"] = {105}}); -- Oem of Clarity
	AddUnlock(druidSkills, 50, {["id"] = 29166, ["specs"] = {102, 105}}); -- Innervate
	AddUnlock(druidSkills, 50, {["id"] = 86093, ["specs"] = {105}}); -- Leather Specialization
	AddUnlock(druidSkills, 50, {["id"] = 86096, ["specs"] = {104}}); -- Leather Specialization
	AddUnlock(druidSkills, 50, {["id"] = 86097, ["specs"] = {103}}); -- Leather Specialization
	AddUnlock(druidSkills, 50, {["id"] = 86104, ["specs"] = {102}}); -- Leather Specialization
	AddUnlock(druidSkills, 50, {["id"] = 106898, ["specs"] = {103, 104}}); -- Stampeding Roar
	AddUnlock(druidSkills, 52, {["id"] = 231040, ["specs"] = {105}}); -- Rejuvenation 2
	AddUnlock(druidSkills, 52, {["id"] = 231055, ["specs"] = {103}}); -- Tiger's Fury 2
	AddUnlock(druidSkills, 54, {["id"] = 48484, ["specs"] = {103}}); -- Infected Wounds
	AddUnlock(druidSkills, 54, {["id"] = 102342, ["specs"] = {105}}); -- Ironbark
	AddUnlock(druidSkills, 54, {["id"] = 231070, ["specs"] = {104}}); -- Ironfur 2
	AddUnlock(druidSkills, 54, {["id"] = 231042, ["specs"] = {102}}); -- Moonkin Form 2
	AddUnlock(druidSkills, 56, {["id"] = 48500, ["specs"] = {105}}); -- Living Seed
	AddUnlock(druidSkills, 56, {["id"] = 231057, ["specs"] = {103}}); -- Shred 3
	AddUnlock(druidSkills, 58, {["id"] = 165962}); -- Flight Form
	AddUnlock(druidSkills, 63, {["id"] = 22570, ["specs"] = {103}}); -- Maim
	AddUnlock(druidSkills, 63, {["id"] = 102793, ["specs"] = {105}}); -- Ursol's Vortex
	AddUnlock(druidSkills, 65, {["id"] = 231065, ["specs"] = {104}}); -- Lightning Reflexes
	AddUnlock(druidSkills, 65, {["id"] = 231049, ["specs"] = {102}}); -- Starfall 2
	AddUnlock(druidSkills, 66, {["id"] = 231056, ["specs"] = {103}}); -- Ferocious Bite 2
	AddUnlock(druidSkills, 66, {["id"] = 212040, ["specs"] = {105}}); -- Revitalize
	AddUnlock(druidSkills, 70, {["id"] = 145205, ["specs"] = {105}}); -- Efflorescence
	AddUnlock(druidSkills, 70, {["id"] = 106839, ["specs"] = {103, 104}}); -- Skull Bash
	AddUnlock(druidSkills, 70, {["id"] = 231021, ["specs"] = {102}}); -- Starsurge 20
	AddUnlock(druidSkills, 78, {["id"] = 77495, ["specs"] = {105}}); -- Mastery: Harmony
	AddUnlock(druidSkills, 78, {["id"] = 155783, ["specs"] = {104}}); -- Mastery: Nature's Guardian
	AddUnlock(druidSkills, 78, {["id"] = 77493, ["specs"] = {103}}); -- Mastery: Raxor Claws
	AddUnlock(druidSkills, 78, {["id"] = 77492, ["specs"] = {102}}); -- Mastery: Starlight
	AddUnlock(druidSkills, 80, {["id"] = 16974, ["specs"] = {103}}); -- Predatory Swiftness
	AddUnlock(druidSkills, 80, {["id"] = 78675, ["specs"] = {102}}); -- Solar Beam
	AddUnlock(druidSkills, 80, {["id"] = 740, ["specs"] = {105}}); -- Tranquility

_addonData.unlockData["skills"] = druidSkills;
_addonData.unlockData["specs"] = druidSpecs;

end

--
-- DEATH KNIGHT
--

if (playerClass == "DEATHKNIGHT") then
local dkSpecs = {
	250 -- Blood
	,251 -- Frost
	,252 -- Unholy
};

local dkSkills = { };
	AddUnlock(dkSkills, 56, {["id"] = 50842, ["specs"] = {250}}); -- Blood Boil
	AddUnlock(dkSkills, 56, {["id"] = 43265, ["specs"] = {250, 252}}); -- Deat and Decay
	AddUnlock(dkSkills, 56, {["id"] = 51128, ["specs"] = {251}}); -- Killing Machine
	AddUnlock(dkSkills, 57, {["id"] = 48707}); -- Anti-magic Shell
	AddUnlock(dkSkills, 57, {["id"] = 49028, ["specs"] = {250}}); -- Dancing Rune Weapon
	AddUnlock(dkSkills, 57, {["id"] = 47568, ["specs"] = {251}}); -- Empower Rune Weapon
	AddUnlock(dkSkills, 57, {["id"] = 48792, ["specs"] = {250, 251, 252}}); -- Icebound Fortitude
	AddUnlock(dkSkills, 57, {["id"] = 51271, ["specs"] = {251}}); -- Pillar of Frost
	AddUnlock(dkSkills, 57, {["id"] = 196770, ["specs"] = {251}}); -- Remorseless Winter
	AddUnlock(dkSkills, 58, {["id"] = 56222}); -- Dark Command
	AddUnlock(dkSkills, 58, {["id"] = 178819, ["specs"] = {251, 252}}); -- 178819
	AddUnlock(dkSkills, 58, {["id"] = 195292, ["specs"] = {250}}); -- Death's Caress
	AddUnlock(dkSkills, 59, {["id"] = 59057, ["specs"] = {251}}); -- Rime
	AddUnlock(dkSkills, 60, {["id"] = 55233, ["specs"] = {250}}); -- Vampiric Blood
	AddUnlock(dkSkills, 60, {["id"] = 212552, ["specs"] = {250, 251, 252}}); -- Wraith Walk
	AddUnlock(dkSkills, 61, {["id"] = 51986}); -- On a Pale Horse
	AddUnlock(dkSkills, 62, {["id"] = 47528}); -- Mind Freeze
	AddUnlock(dkSkills, 63, {["id"] = 45524, ["specs"] = {251, 252}}); -- Chains of Ice
	AddUnlock(dkSkills, 63, {["id"] = 81136, ["specs"] = {250}}); -- Crimson Scourge
	AddUnlock(dkSkills, 64, {["id"] = 108199, ["specs"] = {250}}); -- Gorefiend's Grasp
	AddUnlock(dkSkills, 64, {["id"] = 49530, ["specs"] = {252}}); -- Sudden Doom
	AddUnlock(dkSkills, 66, {["id"] = 3714}); -- Path of Frost
	AddUnlock(dkSkills, 69, {["id"] = 111673}); -- Control Undead
	AddUnlock(dkSkills, 70, {["id"] = 53344}); -- Rune of the Fallen Crusader
	AddUnlock(dkSkills, 72, {["id"] = 61999}); -- Raise Ally
	AddUnlock(dkSkills, 72, {["id"] = 62158}); -- Rune of the Stoneskin Gargoyle
	AddUnlock(dkSkills, 74, {["id"] = 63560, ["specs"] = {252}}); -- Dark Transformation
	AddUnlock(dkSkills, 75, {["id"] = 49206, ["specs"] = {252}}); -- Summon Gargoyle
	AddUnlock(dkSkills, 76, {["id"] = 161797, ["specs"] = {250}}); -- Riposte
	AddUnlock(dkSkills, 78, {["id"] = 77513, ["specs"] = {250}}); -- Mastery: Blood Shield
	AddUnlock(dkSkills, 78, {["id"] = 77515, ["specs"] = {252}}); -- Mastery: Dreadblade
	AddUnlock(dkSkills, 78, {["id"] = 77514, ["specs"] = {251}}); -- Mastery: Frozen Heart
	AddUnlock(dkSkills, 82, {["id"] = 42650, ["specs"] = {252}}); -- Army of the Dead

_addonData.unlockData["skills"] = dkSkills;
_addonData.unlockData["specs"] = dkSpecs;
end

--
-- HUNTER
--

if (playerClass == "HUNTER") then
local hunterSpecs = {
	253 -- Beast Mastery
	,254 -- Marksmanship
	,255 -- Survival
};

local hunterSkills = { };
	AddUnlock(hunterSkills, 4, {["id"] = 5116, ["specs"] = {253, 254}}); -- Concussive Shot
	AddUnlock(hunterSkills, 4, {["id"] = 1494}); -- Track Beasts
	AddUnlock(hunterSkills, 4, {["id"] = 19878}); -- Track Demons
	AddUnlock(hunterSkills, 4, {["id"] = 19879}); -- Track Dragonkin
	AddUnlock(hunterSkills, 4, {["id"] = 19880}); -- Track Elementals
	AddUnlock(hunterSkills, 4, {["id"] = 19882}); -- Track Giants
	AddUnlock(hunterSkills, 4, {["id"] = 19885}); -- Track Hidden
	AddUnlock(hunterSkills, 4, {["id"] = 19883}); -- Track Humanoids
	AddUnlock(hunterSkills, 4, {["id"] = 19884}); -- Track Undead
	AddUnlock(hunterSkills, 6, {["id"] = 781, ["specs"] = {253, 254}}); -- Disengage
	AddUnlock(hunterSkills, 10, {["id"] = 185358, ["specs"] = {254}}); -- Arcane Shot
	AddUnlock(hunterSkills, 10, {["id"] = 53270, ["specs"] = {253}}); -- Exotic Beasts
	AddUnlock(hunterSkills, 10, {["id"] = 190925, ["specs"] = {255}}); -- Harpoon
	AddUnlock(hunterSkills, 10, {["id"] = 34026, ["specs"] = {253}}); -- Kill Command
	AddUnlock(hunterSkills, 10, {["id"] = 186270, ["specs"] = {255}}); -- Raptor Strike
	AddUnlock(hunterSkills, 10, {["id"] = 195645, ["specs"] = {255}}); -- Wing Clip
	AddUnlock(hunterSkills, 10, {["id"] = 93321}); -- Control Pet
	AddUnlock(hunterSkills, 10, {["id"] = 2641}); -- Dismiss Pet
	AddUnlock(hunterSkills, 12, {["id"] = 19434, ["specs"] = {254}}); -- Aimed Shot
	AddUnlock(hunterSkills, 12, {["id"] = 120679, ["specs"] = {253}}); -- Dire Beast
	AddUnlock(hunterSkills, 12, {["id"] = 202800, ["specs"] = {255}}); -- Flanking Strike
	AddUnlock(hunterSkills, 13, {["id"] = 1462}); -- Beast Lore
	AddUnlock(hunterSkills, 13, {["id"] = 83242}); -- Call Pet 2 
	AddUnlock(hunterSkills, 13, {["id"] = 6991}); -- Feed Pet
	AddUnlock(hunterSkills, 13, {["id"] = 1515}); -- Tame Beast
	AddUnlock(hunterSkills, 14, {["id"] = 193265, ["specs"] = {255}}); -- Hatchet Toss
	AddUnlock(hunterSkills, 14, {["id"] = 136}); -- Mend Pet
	AddUnlock(hunterSkills, 16, {["id"] = 2643, ["specs"] = {253, 254}}); -- Multi-Shot
	AddUnlock(hunterSkills, 16, {["id"] = 164856, ["specs"] = {255}}); -- Survivalist
	AddUnlock(hunterSkills, 18, {["id"] = 6197}); -- Eagle Eye
	AddUnlock(hunterSkills, 18, {["id"] = 187650, ["specs"] = {253, 254, 255}}); -- Freezing Traps
	AddUnlock(hunterSkills, 20, {["id"] = 185987, ["specs"] = {254}}); -- Hunter's Mark 
	AddUnlock(hunterSkills, 20, {["id"] = 185901, ["specs"] = {254}}); -- Marked Shot 
	AddUnlock(hunterSkills, 20, {["id"] = 190928, ["specs"] = {255}}); -- Mongoose Bite
	AddUnlock(hunterSkills, 20, {["id"] = 185789, ["specs"] = {253}}); -- Wild Call
	AddUnlock(hunterSkills, 22, {["id"] = 186257}); -- Aspect of the Cheetah
	AddUnlock(hunterSkills, 24, {["id"] = 109304, ["specs"] = {253, 254, 255}}); -- Exhilaration
	AddUnlock(hunterSkills, 26, {["id"] = 193530, ["specs"] = {253}}); -- Aspect of the Wild
	AddUnlock(hunterSkills, 26, {["id"] = 186387, ["specs"] = {254}}); -- Bursting Shot
	AddUnlock(hunterSkills, 26, {["id"] = 185855, ["specs"] = {255}}); -- Lacerate
	AddUnlock(hunterSkills, 28, {["id"] = 5384}); -- Feign Death
	AddUnlock(hunterSkills, 32, {["id"] = 210000}); -- Wake Up 
	AddUnlock(hunterSkills, 32, {["id"] = 147362, ["specs"] = {253, 254}}); -- Counter Shot
	AddUnlock(hunterSkills, 32, {["id"] = 187707, ["specs"] = {255}}); -- Muzzle
	AddUnlock(hunterSkills, 34, {["id"] = 83243}); -- Call Pet 3 
	AddUnlock(hunterSkills, 36, {["id"] = 187698, ["specs"] = {253, 254, 255}}); -- Tar Trap 
	AddUnlock(hunterSkills, 38, {["id"] = 1543}); -- Flare
	AddUnlock(hunterSkills, 40, {["id"] = 186289, ["specs"] = {255}}); -- Aspect of the Eagle
	AddUnlock(hunterSkills, 40, {["id"] = 19574, ["specs"] = {253}}); -- Bestial Wrath
	AddUnlock(hunterSkills, 40, {["id"] = 193526, ["specs"] = {254}}); -- Trueshot
	AddUnlock(hunterSkills, 42, {["id"] = 187708, ["specs"] = {255}}); -- Carve
	AddUnlock(hunterSkills, 42, {["id"] = 34477, ["specs"] = {253, 254}}); -- Misdiraction
	AddUnlock(hunterSkills, 44, {["id"] = 56315, ["specs"] = {253}}); -- Kindrad Spirits
	AddUnlock(hunterSkills, 44, {["id"] = 231554, ["specs"] = {254}}); -- Marksman's Focus
	AddUnlock(hunterSkills, 44, {["id"] = 234955, ["specs"] = {255}}); -- Waylay
	AddUnlock(hunterSkills, 48, {["id"] = 231546, ["specs"] = {253, 254, 255}}); -- Exhilaration 2 
	AddUnlock(hunterSkills, 50, {["id"] = 115939, ["specs"] = {253}}); -- Beast Cleave 
	AddUnlock(hunterSkills, 50, {["id"] = 35110, ["specs"] = {254}}); -- Bombardment 
	AddUnlock(hunterSkills, 50, {["id"] = 191433, ["specs"] = {255}}); -- Explosive Trap 
	AddUnlock(hunterSkills, 54, {["id"] = 231555, ["specs"] = {255}}); -- Aspect of the Eagle 2 
	AddUnlock(hunterSkills, 54, {["id"] = 231548, ["specs"] = {253}}); -- Beastial Wrath 2 
	AddUnlock(hunterSkills, 57, {["id"] = 83244}); -- Call Pet 4 
	AddUnlock(hunterSkills, 58, {["id"] = 212658, ["specs"] = {254}}); -- Hunting Party 
	AddUnlock(hunterSkills, 65, {["id"] = 231549, ["specs"] = {253, 254}}); -- Disengage 2 
	AddUnlock(hunterSkills, 65, {["id"] = 231550, ["specs"] = {255}}); -- Harpoon 2 
	AddUnlock(hunterSkills, 78, {["id"] = 237327, ["specs"] = {255}}); -- Flanking Strike 2 
	AddUnlock(hunterSkills, 78, {["id"] = 191334, ["specs"] = {255}}); -- Mastery: Hunting Companion
	AddUnlock(hunterSkills, 78, {["id"] = 76657, ["specs"] = {253}}); -- Mastery: Master of Beasts
	AddUnlock(hunterSkills, 78, {["id"] = 193468, ["specs"] = {254}}); -- Mastery: Sniper Training
	AddUnlock(hunterSkills, 80, {["id"] = 83245}); -- Call Pet 5 

_addonData.unlockData["skills"] = hunterSkills;
_addonData.unlockData["specs"] = hunterSpecs;

end

--
-- PRIEST
--

if (playerClass == "PRIEST") then
local priestSpecs = {
	256 -- Disciplin
	,257 -- Holy
	,258 -- Shadow
};

local priestSkills = { };
	AddUnlock(priestSkills, 3, {["id"] = 589, ["specs"] = {256, 258}}); -- Shadow Word: Pain 
	AddUnlock(priestSkills, 5, {["id"] = 2061, ["specs"] = {256, 257, 258}}); -- Flash Heal
	AddUnlock(priestSkills, 8, {["id"] = 17, ["specs"] = {256, 258}}); -- Power Word: Shield 
	AddUnlock(priestSkills, 10, {["id"] = 14914, ["specs"] = {257}}); -- Holy Shock
	AddUnlock(priestSkills, 10, {["id"] = 2050, ["specs"] = {257}}); -- Holy Word: Serenity 
	AddUnlock(priestSkills, 10, {["id"] = 8092, ["specs"] = {258}}); -- Mind Blast
	AddUnlock(priestSkills, 10, {["id"] = 15407, ["specs"] = {258}}); -- Mind Flay 
	AddUnlock(priestSkills, 10, {["id"] = 47540, ["specs"] = {256}}); -- Penance
	AddUnlock(priestSkills, 12, {["id"] = 139, ["specs"] = {257}}); -- Renew
	AddUnlock(priestSkills, 12, {["id"] = 232698, ["specs"] = {258}}); -- Shadowform
	AddUnlock(priestSkills, 13, {["id"] = 2096, ["specs"] = {256, 258}}); -- Mind Vision
	AddUnlock(priestSkills, 14, {["id"] = 2006}); -- Resurrection
	AddUnlock(priestSkills, 18, {["id"] = 88625, ["specs"] = {257}}); -- Holy Word: Chastise
	AddUnlock(priestSkills, 18, {["id"] = 8122, ["specs"] = {256, 258}}); -- Penance
	AddUnlock(priestSkills, 20, {["id"] = 81749, ["specs"] = {256}}); -- Atonement
	AddUnlock(priestSkills, 20, {["id"] = 63733, ["specs"] = {257}}); -- Serendipity
	AddUnlock(priestSkills, 20, {["id"] = 228260, ["specs"] = {258}}); -- Void Eruption
	AddUnlock(priestSkills, 20, {["id"] = 228264, ["specs"] = {258}}); -- Voidform 
	AddUnlock(priestSkills, 20, {["id"] = 228266, ["specs"] = {258}}); -- Void Bolt
	AddUnlock(priestSkills, 22, {["id"] = 527, ["specs"] = {256, 257}}); -- Purify
	AddUnlock(priestSkills, 22, {["id"] = 213634, ["specs"] = {258}}); -- Purify Disease
	AddUnlock(priestSkills, 24, {["id"] = 2060, ["specs"] = {257}}); -- Heal
	AddUnlock(priestSkills, 24, {["id"] = 200829, ["specs"] = {256}}); -- Plea
	AddUnlock(priestSkills, 24, {["id"] = 34914, ["specs"] = {258}}); -- Vampiric Touch
	AddUnlock(priestSkills, 26, {["id"] = 132157, ["specs"] = {257}}); -- Holy Nova
	AddUnlock(priestSkills, 26, {["id"] = 234702, ["specs"] = {258}}); -- Mind Sear
	AddUnlock(priestSkills, 28, {["id"] = 596, ["specs"] = {257}}); -- Prayer of Healing
	AddUnlock(priestSkills, 28, {["id"] = 186263, ["specs"] = {256, 258}}); -- Shadow Mend
	AddUnlock(priestSkills, 32, {["id"] = 1706, ["specs"] = {256, 257, 258}}); -- Levitate
	AddUnlock(priestSkills, 32, {["id"] = 20711, ["specs"] = {257}}); -- Spirit of Redemption
	AddUnlock(priestSkills, 34, {["id"] = 9484}); -- Shackle Undead
	AddUnlock(priestSkills, 36, {["id"] = 231687, ["specs"] = {257}}); -- Holy Fire 2 
	AddUnlock(priestSkills, 36, {["id"] = 231682, ["specs"] = {256}}); -- Smite 2 
	AddUnlock(priestSkills, 36, {["id"] = 231688, ["specs"] = {258}}); -- Void Bolt 2 
	AddUnlock(priestSkills, 38, {["id"] = 45243, ["specs"] = {256, 257}}); -- Focused Will
	AddUnlock(priestSkills, 38, {["id"] = 78203, ["specs"] = {258}}); -- Shadowy Apparitions
	AddUnlock(priestSkills, 40, {["id"] = 34861, ["specs"] = {257}}); -- Holy Word: Sanctify
	AddUnlock(priestSkills, 40, {["id"] = 34433, ["specs"] = {256, 258}}); -- Shadowfiend 
	AddUnlock(priestSkills, 42, {["id"] = 605}); -- Mind Control
	AddUnlock(priestSkills, 44, {["id"] = 586}); -- Fade 
	AddUnlock(priestSkills, 48, {["id"] = 47585, ["specs"] = {258}}); -- Dispersion
	AddUnlock(priestSkills, 48, {["id"] = 47788, ["specs"] = {257}}); -- Guardian Spirit
	AddUnlock(priestSkills, 48, {["id"] = 33206, ["specs"] = {256}}); -- Pain Suppression
	AddUnlock(priestSkills, 50, {["id"] = 33076, ["specs"] = {257}}); -- Prayer of Mending
	AddUnlock(priestSkills, 50, {["id"] = 47536, ["specs"] = {256}}); -- Rapture 
	AddUnlock(priestSkills, 50, {["id"] = 32379, ["specs"] = {258}}); -- Shadow Word: Death
	AddUnlock(priestSkills, 52, {["id"] = 19236, ["specs"] = {257}}); -- Desperate Prayer
	AddUnlock(priestSkills, 52, {["id"] = 194509, ["specs"] = {256}}); -- Power Word: Radiance
	AddUnlock(priestSkills, 52, {["id"] = 15487, ["specs"] = {258}}); -- Silence
	AddUnlock(priestSkills, 56, {["id"] = 528}); -- Dispel Magic 
	AddUnlock(priestSkills, 63, {["id"] = 73325, ["specs"] = {256, 257}}); -- Leap of Faith
	AddUnlock(priestSkills, 65, {["id"] = 231689, ["specs"] = {258}}); -- Shadow Word: Death
	AddUnlock(priestSkills, 66, {["id"] = 212036, ["specs"] = {256, 257}}); -- Mass Resurrection
	AddUnlock(priestSkills, 70, {["id"] = 64843, ["specs"] = {257}}); -- Divine Hymn
	AddUnlock(priestSkills, 70, {["id"] = 62618, ["specs"] = {256}}); -- Power Word: Barrier
	AddUnlock(priestSkills, 70, {["id"] = 15286, ["specs"] = {258}}); -- Vampiric Embrace
	AddUnlock(priestSkills, 78, {["id"] = 77484, ["specs"] = {256}}); -- Mastery: Absolution
	AddUnlock(priestSkills, 78, {["id"] = 77485, ["specs"] = {257}}); -- Mastery: Echo of Light
	AddUnlock(priestSkills, 78, {["id"] = 77486, ["specs"] = {258}}); -- Mastery: Madness
	AddUnlock(priestSkills, 80, {["id"] = 32375}); -- Mass Dispel

_addonData.unlockData["skills"] = priestSkills;
_addonData.unlockData["specs"] = priestSpecs;

end

--
-- ROGUE
--

if (playerClass == "ROGUE") then
local rogueSpecs = {
	259 -- Assassination
	,260 -- Outlaw
	,261 -- Subtlety
};

local rogueSkills = { };
	AddUnlock(rogueSkills, 3, {["id"] = 196819, ["specs"] = {259, 261}}); -- Eviscerate
	AddUnlock(rogueSkills, 5, {["id"] = 1784, ["specs"] = {259, 260, 261}}); -- Stealth
	AddUnlock(rogueSkills, 8, {["id"] = 1833, ["specs"] = {259, 260, 261}}); -- Cheap Shot 
	AddUnlock(rogueSkills, 10, {["id"] = 84601, ["specs"] = {259}}); -- Assassin's Resolve 
	AddUnlock(rogueSkills, 10, {["id"] = 53, ["specs"] = {261}}); -- Backstab
	AddUnlock(rogueSkills, 10, {["id"] = 2823, ["specs"] = {259}}); -- Deadly Poison
	AddUnlock(rogueSkills, 10, {["id"] = 79152, ["specs"] = {261}}); -- Energy Recovery
	AddUnlock(rogueSkills, 10, {["id"] = 14117, ["specs"] = {259}}); -- Improved Poisons
	AddUnlock(rogueSkills, 10, {["id"] = 185565, ["specs"] = {259}}); -- Poisoned Knife
	AddUnlock(rogueSkills, 10, {["id"] = 2098, ["specs"] = {260}}); -- Run Through
	AddUnlock(rogueSkills, 10, {["id"] = 193315, ["specs"] = {260}}); -- Saber Slash
	AddUnlock(rogueSkills, 10, {["id"] = 114014, ["specs"] = {261}}); -- Shurken Toss
	AddUnlock(rogueSkills, 10, {["id"] = 61329, ["specs"] = {260}}); -- Assassin's Resolve 
	AddUnlock(rogueSkills, 12, {["id"] = 703, ["specs"] = {259}}); -- Garrote
	AddUnlock(rogueSkills, 12, {["id"] = 185763, ["specs"] = {260}}); -- Pistol Shot
	AddUnlock(rogueSkills, 12, {["id"] = 185438, ["specs"] = {261}}); -- Shadowstrike
	AddUnlock(rogueSkills, 13, {["id"] = 921, ["specs"] = {259, 260, 261}}); -- Pick Pocket
	AddUnlock(rogueSkills, 14, {["id"] = 6770, ["specs"] = {259, 260, 261}}); -- Sap
	AddUnlock(rogueSkills, 16, {["id"] = 185311}); -- Crimson Vial
	AddUnlock(rogueSkills, 18, {["id"] = 1766}); -- Kick
	AddUnlock(rogueSkills, 20, {["id"] = 199804, ["specs"] = {260}}); -- Between the Eyes
	AddUnlock(rogueSkills, 20, {["id"] = 51667, ["specs"] = {259}}); -- Cut to the Chase
	AddUnlock(rogueSkills, 20, {["id"] = 195452, ["specs"] = {261}}); -- Nightblade
	AddUnlock(rogueSkills, 20, {["id"] = 1943, ["specs"] = {259}}); -- Rupture
	AddUnlock(rogueSkills, 22, {["id"] = 8676, ["specs"] = {260}}); -- Ambush
	AddUnlock(rogueSkills, 22, {["id"] = 36554, ["specs"] = {259, 261}}); -- Shadowstep
	AddUnlock(rogueSkills, 24, {["id"] = 1804}); -- Pick Lock
	AddUnlock(rogueSkills, 24, {["id"] = 2094, ["specs"] = {259, 260, 261}}); -- Blind
	AddUnlock(rogueSkills, 26, {["id"] = 5277, ["specs"] = {259, 261}}); -- Evasion
	AddUnlock(rogueSkills, 26, {["id"] = 199754, ["specs"] = {260}}); -- Ripsote
	AddUnlock(rogueSkills, 28, {["id"] = 14161, ["specs"] = {260}}); -- Ruthlessness
	AddUnlock(rogueSkills, 28, {["id"] = 14190, ["specs"] = {259}}); -- Seal Fate
	AddUnlock(rogueSkills, 28, {["id"] = 196912, ["specs"] = {261}}); -- Shadow Techniques
	AddUnlock(rogueSkills, 32, {["id"] = 2983}); -- Sprint
	AddUnlock(rogueSkills, 34, {["id"] = 1776, ["specs"] = {260}}); -- Gouge
	AddUnlock(rogueSkills, 34, {["id"] = 408, ["specs"] = {259, 261}}); -- Kidney Shot
	AddUnlock(rogueSkills, 36, {["id"] = 32645, ["specs"] = {259}}); -- Envenom
	AddUnlock(rogueSkills, 36, {["id"] = 212283, ["specs"] = {261}}); -- Symbols of Death
	AddUnlock(rogueSkills, 38, {["id"] = 3408, ["specs"] = {259}}); -- Crippling Poison
	AddUnlock(rogueSkills, 38, {["id"] = 1725, ["specs"] = {259, 260, 261}}); -- Distract
	AddUnlock(rogueSkills, 40, {["id"] = 1329, ["specs"] = {259}}); -- Mutilate
	AddUnlock(rogueSkills, 40, {["id"] = 193316, ["specs"] = {260}}); -- Roll the Bones
	AddUnlock(rogueSkills, 40, {["id"] = 185313, ["specs"] = {261}}); -- Shadow Dance
	AddUnlock(rogueSkills, 42, {["id"] = 2836}); -- Detect Traps
	AddUnlock(rogueSkills, 42, {["id"] = 235484, ["specs"] = {260}}); -- Between the Eyes
	AddUnlock(rogueSkills, 42, {["id"] = 231719, ["specs"] = {259}}); -- Garrote
	AddUnlock(rogueSkills, 42, {["id"] = 231718, ["specs"] = {261}}); -- Shadowstrike
	AddUnlock(rogueSkills, 44, {["id"] = 1966}); -- Feint
	AddUnlock(rogueSkills, 48, {["id"] = 1856, ["specs"] = {259, 260, 261}}); -- Vanish
	AddUnlock(rogueSkills, 50, {["id"] = 35551, ["specs"] = {260}}); -- Combat Potency
	AddUnlock(rogueSkills, 50, {["id"] = 58423, ["specs"] = {261}}); -- Assassin's Resolve 
	AddUnlock(rogueSkills, 50, {["id"] = 79096, ["specs"] = {260}}); -- Restless Bladestorm
	AddUnlock(rogueSkills, 50, {["id"] = 79134, ["specs"] = {259}}); -- Venomous Wounds
	AddUnlock(rogueSkills, 52, {["id"] = 231716, ["specs"] = {261}}); -- Eviscerate
	AddUnlock(rogueSkills, 54, {["id"] = 199740, ["specs"] = {260}}); -- Bribe
	AddUnlock(rogueSkills, 54, {["id"] = 185314, ["specs"] = {261}}); -- Deepening Shadows
	AddUnlock(rogueSkills, 54, {["id"] = 8679, ["specs"] = {259}}); -- Wound Poison
	AddUnlock(rogueSkills, 56, {["id"] = 13750, ["specs"] = {260}}); -- Adrenaline Rush
	AddUnlock(rogueSkills, 56, {["id"] = 121471, ["specs"] = {261}}); -- Shadow Blades 
	AddUnlock(rogueSkills, 56, {["id"] = 79140, ["specs"] = {259}}); -- Vendetta
	AddUnlock(rogueSkills, 58, {["id"] = 31209}); -- Fleet Footed
	AddUnlock(rogueSkills, 61, {["id"] = 245751, ["specs"] = {261}}); -- Sprint 2
	AddUnlock(rogueSkills, 62, {["id"] = 1860}); -- Safe Fall
	AddUnlock(rogueSkills, 63, {["id"] = 13877, ["specs"] = {260}}); -- Blade Flurry
	AddUnlock(rogueSkills, 63, {["id"] = 51723, ["specs"] = {259}}); -- Fan of Knives
	AddUnlock(rogueSkills, 63, {["id"] = 197835, ["specs"] = {261}}); -- Shuriken Storm 
	AddUnlock(rogueSkills, 66, {["id"] = 231691, ["specs"] = {259, 260, 261}}); -- Sprint 2 	
	AddUnlock(rogueSkills, 68, {["id"] = 114018}); -- Shroud of Concealment
	AddUnlock(rogueSkills, 70, {["id"] = 57934}); -- Tricks of the Trade
	AddUnlock(rogueSkills, 70, {["id"] = 84601, ["specs"] = {261}}); -- Shuriken Combo
	AddUnlock(rogueSkills, 78, {["id"] = 76808, ["specs"] = {261}}); -- Mastery: Executioner
	AddUnlock(rogueSkills, 78, {["id"] = 76806, ["specs"] = {260}}); -- Mastery: Main Gauche
	AddUnlock(rogueSkills, 78, {["id"] = 76803, ["specs"] = {259}}); -- Mastery: Potent Poisons
	AddUnlock(rogueSkills, 80, {["id"] = 31224}); -- Cloak of Shadows

_addonData.unlockData["skills"] = rogueSkills;
_addonData.unlockData["specs"] = rogueSpecs;

end

--
-- SHAMAN
--

if (playerClass == "SHAMAN") then
local shamanSpecs = {
	262 -- Elemental
	,263 -- Enhancement
	,264 -- Restoration
};

local shamanSkills = { };
	AddUnlock(shamanSkills, 3, {["id"] = 188389, ["specs"] = {262}}); -- Flame Shock
	AddUnlock(shamanSkills, 3, {["id"] = 188838, ["specs"] = {264}}); -- Flame Shock
	AddUnlock(shamanSkills, 5, {["id"] = 8004, ["specs"] = {262, 264}}); -- Healing Surge
	AddUnlock(shamanSkills, 5, {["id"] = 188070, ["specs"] = {263}}); -- Healing Surge
	AddUnlock(shamanSkills, 8, {["id"] = 2484}); -- Earthbind Totem 
	AddUnlock(shamanSkills, 10, {["id"] = 157444, ["specs"] = {263}}); -- Critical Strikes
	AddUnlock(shamanSkills, 10, {["id"] = 86629, ["specs"] = {263}}); -- Dual Wield
	AddUnlock(shamanSkills, 10, {["id"] = 8042, ["specs"] = {262}}); -- Earth Shock
	AddUnlock(shamanSkills, 10, {["id"] = 60103, ["specs"] = {263}}); -- Lava Lash
	AddUnlock(shamanSkills, 10, {["id"] = 61295, ["specs"] = {264}}); -- Riptide
	AddUnlock(shamanSkills, 10, {["id"] = 193786, ["specs"] = {263}}); -- Rockbiter
	AddUnlock(shamanSkills, 12, {["id"] = 193796, ["specs"] = {263}}); -- Flametongue
	AddUnlock(shamanSkills, 12, {["id"] = 51505, ["specs"] = {262, 264}}); -- Lava Burst 
	AddUnlock(shamanSkills, 13, {["id"] = 6196}); -- Far Sight
	AddUnlock(shamanSkills, 13, {["id"] = 232643, ["specs"] = {262}}); -- Flame Shock 2
	AddUnlock(shamanSkills, 14, {["id"] = 2008}); -- Ancestral Spirit 
	AddUnlock(shamanSkills, 14, {["id"] = 5394, ["specs"] = {264}}); -- Healing Steam Totem
	AddUnlock(shamanSkills, 16, {["id"] = 2645}); -- Ghost Wolf 
	AddUnlock(shamanSkills, 18, {["id"] = 57994, ["specs"] = {262, 263, 264}}); -- Wind Shear
	AddUnlock(shamanSkills, 20, {["id"] = 1064, ["specs"] = {264}}); -- Chain Heal
	AddUnlock(shamanSkills, 20, {["id"] = 231721, ["specs"] = {262, 264}}); -- Lava Burst 2
	AddUnlock(shamanSkills, 20, {["id"] = 17364, ["specs"] = {263}}); -- Stormstrike
	AddUnlock(shamanSkills, 22, {["id"] = 51886, ["specs"] = {262, 263}}); -- Cleanse Spirit 
	AddUnlock(shamanSkills, 22, {["id"] = 77130, ["specs"] = {264}}); -- Purify Spirit 
	AddUnlock(shamanSkills, 24, {["id"] = 77472, ["specs"] = {264}}); -- Healing Wave 
	AddUnlock(shamanSkills, 24, {["id"] = 51490, ["specs"] = {262}}); -- Thunderstorm 
	AddUnlock(shamanSkills, 24, {["id"] = 33757, ["specs"] = {263}}); -- Windfury
	AddUnlock(shamanSkills, 26, {["id"] = 20608}); -- Reincarnation 
	AddUnlock(shamanSkills, 28, {["id"] = 421, ["specs"] = {264}}); -- Chain Lightning 
	AddUnlock(shamanSkills, 28, {["id"] = 188443, ["specs"] = {262}}); -- Chain Lightning 
	AddUnlock(shamanSkills, 28, {["id"] = 187874, ["specs"] = {263}}); -- Crash Lightning
	AddUnlock(shamanSkills, 32, {["id"] = 546}); -- Water Walking 
	AddUnlock(shamanSkills, 34, {["id"] = 60188, ["specs"] = {262}}); -- Elemental Fury 
	AddUnlock(shamanSkills, 34, {["id"] = 51564, ["specs"] = {264}}); -- Tidal Wave 
	AddUnlock(shamanSkills, 36, {["id"] = 198103, ["specs"] = {262}}); -- Earth Elemental 
	AddUnlock(shamanSkills, 36, {["id"] = 51533, ["specs"] = {263}}); -- Feral Spirit 
	AddUnlock(shamanSkills, 36, {["id"] = 79206, ["specs"] = {264}}); -- Spiritwalker's Grace 
	AddUnlock(shamanSkills, 38, {["id"] = 196840, ["specs"] = {262}}); -- Frost Shock 
	AddUnlock(shamanSkills, 38, {["id"] = 196834, ["specs"] = {263}}); -- Frostbrand 
	AddUnlock(shamanSkills, 38, {["id"] = 231725, ["specs"] = {264}}); -- Riptide 2 
	AddUnlock(shamanSkills, 40, {["id"] = 73920, ["specs"] = {264}}); -- Healing Rain
	AddUnlock(shamanSkills, 40, {["id"] = 77756, ["specs"] = {262, 264}}); -- Lava Surge 
	AddUnlock(shamanSkills, 40, {["id"] = 187880, ["specs"] = {263}}); -- Maelstrom Weapon 	
	AddUnlock(shamanSkills, 42, {["id"] = 51514}); -- Hex 
	AddUnlock(shamanSkills, 44, {["id"] = 556}); -- Astral Recall 
	AddUnlock(shamanSkills, 48, {["id"] = 61882, ["specs"] = {262}}); -- Earthquake 
	AddUnlock(shamanSkills, 48, {["id"] = 16196, ["specs"] = {264}}); -- Resurgence 
	AddUnlock(shamanSkills, 48, {["id"] = 201845, ["specs"] = {263}}); -- Stormbringer 
	AddUnlock(shamanSkills, 50, {["id"] = 86099, ["specs"] = {263}}); -- Mail Specialization 
	AddUnlock(shamanSkills, 50, {["id"] = 86100, ["specs"] = {264}}); -- Mail Specialization 
	AddUnlock(shamanSkills, 50, {["id"] = 86108, ["specs"] = {262}}); -- Mail Specialization 
	AddUnlock(shamanSkills, 52, {["id"] = 108271}); -- Astral Shift 
	AddUnlock(shamanSkills, 54, {["id"] = 231780, ["specs"] = {264}}); -- Chain Heal 2
	AddUnlock(shamanSkills, 56, {["id"] = 231723, ["specs"] = {263}}); -- Feral Spirit 2 
	AddUnlock(shamanSkills, 56, {["id"] = 198067, ["specs"] = {262}}); -- Fire Elemental 
	AddUnlock(shamanSkills, 56, {["id"] = 98008, ["specs"] = {264}}); -- Spirit Link Totem
	AddUnlock(shamanSkills, 63, {["id"] = 370}); -- Purge
	AddUnlock(shamanSkills, 66, {["id"] = 212048, ["specs"] = {264}}); -- Ancestral Vision 
	AddUnlock(shamanSkills, 70, {["id"] = 231722, ["specs"] = {262}}); -- Chain Lightning 2 
	AddUnlock(shamanSkills, 70, {["id"] = 195255, ["specs"] = {263}}); -- Stormlash 
	AddUnlock(shamanSkills, 70, {["id"] = 231785, ["specs"] = {264}}); -- Tidal Waves 2 
	AddUnlock(shamanSkills, 78, {["id"] = 77226, ["specs"] = {264}}); -- Mastery: Deep Healing
	AddUnlock(shamanSkills, 78, {["id"] = 168534, ["specs"] = {262}}); -- Mastery: Elemental Overload
	AddUnlock(shamanSkills, 78, {["id"] = 77223, ["specs"] = {263}}); -- Mastery: Enhanced Elements
	AddUnlock(shamanSkills, 80, {["id"] = 16164, ["specs"] = {262}}); -- Elemental Focus 
	AddUnlock(shamanSkills, 80, {["id"] = 108280, ["specs"] = {264}}); -- Healing Tide Totem 
	AddUnlock(shamanSkills, 80, {["id"] = 58875, ["specs"] = {263}}); -- Spirit Walk
	
if (playerFaction == "Alliance") then
	AddUnlock(shamanSkills, 50, {["id"] = 32182}); -- Wannabe Bloodlust
else
	AddUnlock(shamanSkills, 50, {["id"] = 2825}); -- Bloodlust
end

_addonData.unlockData["skills"] = shamanSkills;
_addonData.unlockData["specs"] = shamanSpecs;

end

--
-- WARLOCK
--

if (playerClass == "WARLOCK") then
local warlockSpecs = {
	265 -- Affliction
	,266 -- Demonology
	,267 -- Destruction
};

local warlockSkills = { };
	AddUnlock(warlockSkills, 3, {["id"] = 172, ["specs"] = {265}}); -- Corruption
	AddUnlock(warlockSkills, 5, {["id"] = 688}); -- Summon Imp
	AddUnlock(warlockSkills, 8, {["id"] = 1454, ["specs"] = {265, 266, 267}}); -- Life Tap
	AddUnlock(warlockSkills, 10, {["id"] = 93375}); -- Control Demon 
	AddUnlock(warlockSkills, 10, {["id"] = 980, ["specs"] = {265}}); -- Agony 
	AddUnlock(warlockSkills, 10, {["id"] = 17962, ["specs"] = {267}}); -- Conflagrate 
	AddUnlock(warlockSkills, 10, {["id"] = 105174, ["specs"] = {266}}); -- Hand of Gul'dan 
	AddUnlock(warlockSkills, 10, {["id"] = 348, ["specs"] = {267}}); -- Immolate 
	AddUnlock(warlockSkills, 12, {["id"] = 116858, ["specs"] = {267}}); -- Chaos Bolt 
	AddUnlock(warlockSkills, 12, {["id"] = 193396, ["specs"] = {266}}); -- Demonic Empowerment 
	AddUnlock(warlockSkills, 13, {["id"] = 234153, ["specs"] = {266, 267}}); -- Drain Life 
	AddUnlock(warlockSkills, 13, {["id"] = 198590, ["specs"] = {265}}); -- Drain Soul 
	AddUnlock(warlockSkills, 14, {["id"] = 104316, ["specs"] = {266}}); -- Call Dreadstalkers 
	AddUnlock(warlockSkills, 14, {["id"] = 29722, ["specs"] = {267}}); -- Incinerate 
	AddUnlock(warlockSkills, 14, {["id"] = 30108, ["specs"] = {265}}); -- Unstable Affliction
	AddUnlock(warlockSkills, 16, {["id"] = 5782}); -- Fear 
	AddUnlock(warlockSkills, 18, {["id"] = 6201}); -- Create Healthstone 
	AddUnlock(warlockSkills, 20, {["id"] = 5784}); -- Felsteed 
	AddUnlock(warlockSkills, 20, {["id"] = 697}); -- Summon Voidwalker 
	AddUnlock(warlockSkills, 22, {["id"] = 755}); -- Health Funnel 
	AddUnlock(warlockSkills, 24, {["id"] = 126}); -- Eye of Kilrogg 
	AddUnlock(warlockSkills, 24, {["id"] = 5697}); -- Unending Breath
	AddUnlock(warlockSkills, 26, {["id"] = 603, ["specs"] = {266}}); -- Doom 
	AddUnlock(warlockSkills, 26, {["id"] = 5740, ["specs"] = {267}}); -- Rain of Fire 
	AddUnlock(warlockSkills, 26, {["id"] = 231791, ["specs"] = {265}}); -- Unstable Corruption 2
	AddUnlock(warlockSkills, 28, {["id"] = 712}); -- Summon Succubus 
	AddUnlock(warlockSkills, 32, {["id"] = 710}); -- Banish 
	AddUnlock(warlockSkills, 34, {["id"] = 108370}); -- Soul Leech 
	AddUnlock(warlockSkills, 36, {["id"] = 691}); -- Summon Felhunter 
	AddUnlock(warlockSkills, 38, {["id"] = 119898}); -- Command Demon 
	AddUnlock(warlockSkills, 38, {["id"] = 27243, ["specs"] = {265}}); -- Seed of Corruption
	AddUnlock(warlockSkills, 40, {["id"] = 23161}); -- Dreadsteed 
	AddUnlock(warlockSkills, 40, {["id"] = 80240, ["specs"] = {267}}); -- Havoc 
	AddUnlock(warlockSkills, 40, {["id"] = 30146, ["specs"] = {266}}); -- Summon Felguard
	AddUnlock(warlockSkills, 42, {["id"] = 698}); -- Ritual of Summoning 
	AddUnlock(warlockSkills, 44, {["id"] = 20707}); -- Soulstone 
	AddUnlock(warlockSkills, 48, {["id"] = 193440, ["specs"] = {266}}); -- Demonwrath 
	AddUnlock(warlockSkills, 48, {["id"] = 231795, ["specs"] = {267}}); -- Firebolt 2 
	AddUnlock(warlockSkills, 48, {["id"] = 231799, ["specs"] = {265}}); -- Shadow Bite 2
	AddUnlock(warlockSkills, 50, {["id"] = 18540}); -- Summon Doomguard 
	AddUnlock(warlockSkills, 52, {["id"] = 231792, ["specs"] = {265}}); -- Agony 2 
	AddUnlock(warlockSkills, 52, {["id"] = 231793, ["specs"] = {267}}); -- Conflagrate 
	AddUnlock(warlockSkills, 52, {["id"] = 108415, ["specs"] = {266}}); -- Soul Link
	AddUnlock(warlockSkills, 54, {["id"] = 104773}); -- Unending Resolve 
	AddUnlock(warlockSkills, 56, {["id"] = 1098}); -- Enslave Demon 
	AddUnlock(warlockSkills, 58, {["id"] = 1122}); -- Summon Infernal 
	AddUnlock(warlockSkills, 63, {["id"] = 231794, ["specs"] = {267}}); -- Unending Resolve 2 
	AddUnlock(warlockSkills, 66, {["id"] = 29893}); -- Create Soulwell 
	AddUnlock(warlockSkills, 70, {["id"] = 231811, ["specs"] = {265, 266, 267}}); -- Soulstone
	AddUnlock(warlockSkills, 78, {["id"] = 77220, ["specs"] = {267}}); -- Mastery: Chaotic Energies
	AddUnlock(warlockSkills, 78, {["id"] = 77219, ["specs"] = {266}}); -- Mastery: Master Demonologist
	AddUnlock(warlockSkills, 78, {["id"] = 77215, ["specs"] = {265}}); -- Mastery: Potent Afflictions
	AddUnlock(warlockSkills, 80, {["id"] = 111771}); -- Demonic Gateway
	
_addonData.unlockData["skills"] = warlockSkills;
_addonData.unlockData["specs"] = warlockSpecs;

end

--
-- MONK
--

if (playerClass == "MONK") then
local monkSpecs = {
	268		-- Brewmaster
	,269	-- Windwalker
	,270	-- Mistweaver
};

local monkSkills = { };
	AddUnlock(monkSkills, 3, {["id"] = 100784}); -- Blackout Kick
	AddUnlock(monkSkills, 5, {["id"] = 109132}); -- Roll 
	AddUnlock(monkSkills, 8, {["id"] = 116694, ["specs"] = {268, 269, 270}}); -- Effuse
	AddUnlock(monkSkills, 10, {["id"] = 209525}); -- Smoothing Mist 
	AddUnlock(monkSkills, 10, {["id"] = 205523, ["specs"] = {268}}); -- Blackout Strike
	AddUnlock(monkSkills, 10, {["id"] = 245013, ["specs"] = {268}}); -- Brwemaster's Balance 
	AddUnlock(monkSkills, 10, {["id"] = 121253, ["specs"] = {268}}); -- Keg Smash 
	AddUnlock(monkSkills, 10, {["id"] = 107428, ["specs"] = {269, 270}}); -- Rising Sun Kick 
	AddUnlock(monkSkills, 10, {["id"] = 193884, ["specs"] = {270}}); -- Soothing Mist 
	AddUnlock(monkSkills, 12, {["id"] = 231602, ["specs"] = {268, 269}}); -- Effuse 2 
	AddUnlock(monkSkills, 12, {["id"] = 124682, ["specs"] = {270}}); -- Enveloping Mist 
	AddUnlock(monkSkills, 12, {["id"] = 116645, ["specs"] = {270}}); -- Teaching of the Monastery
	AddUnlock(monkSkills, 13, {["id"] = 115546}); -- Provoke 
	AddUnlock(monkSkills, 14, {["id"] = 115178}); -- Resuscitate 
	AddUnlock(monkSkills, 14, {["id"] = 126892}); -- Zen Pilgrimage 
	AddUnlock(monkSkills, 16, {["id"] = 116095, ["specs"] = {269}}); -- Disable 
	AddUnlock(monkSkills, 16, {["id"] = 115069, ["specs"] = {268}}); -- Stager
	AddUnlock(monkSkills, 18, {["id"] = 117952}); -- Crackling Jade Lightning  
	AddUnlock(monkSkills, 20, {["id"] = 128595, ["specs"] = {269}}); -- Combat Conditioning 
	AddUnlock(monkSkills, 20, {["id"] = 113656, ["specs"] = {269}}); -- Fists of Fury 
	AddUnlock(monkSkills, 20, {["id"] = 115308, ["specs"] = {268}}); -- Ironskin Brew 
	AddUnlock(monkSkills, 20, {["id"] = 115151, ["specs"] = {270}}); -- Renewing Mist 
	AddUnlock(monkSkills, 22, {["id"] = 115450, ["specs"] = {270}}); -- Blackout Strike
	AddUnlock(monkSkills, 22, {["id"] = 218164, ["specs"] = {268, 269}}); -- Blackout Strike
	AddUnlock(monkSkills, 25, {["id"] = 115078}); -- Paralusis 
	AddUnlock(monkSkills, 28, {["id"] = 116092, ["specs"] = {269}}); -- Afterlife 
	AddUnlock(monkSkills, 28, {["id"] = 119582, ["specs"] = {268}}); -- Purifying Brew 
	AddUnlock(monkSkills, 28, {["id"] = 116670, ["specs"] = {270}}); -- Vivify
	AddUnlock(monkSkills, 32, {["id"] = 231605, ["specs"] = {270}}); -- Enveloping Mist 2 
	AddUnlock(monkSkills, 32, {["id"] = 124502, ["specs"] = {268}}); -- Gift of the Ox 
	AddUnlock(monkSkills, 32, {["id"] = 115080, ["specs"] = {269}}); -- Touch of Death 
	AddUnlock(monkSkills, 35, {["id"] = 116849, ["specs"] = {270}}); -- Life Cocoon 
	AddUnlock(monkSkills, 35, {["id"] = 116705, ["specs"] = {268, 269}}); -- Spear Hand Strike 
	AddUnlock(monkSkills, 38, {["id"] = 157411, ["specs"] = {269}}); -- Windwalking 
	AddUnlock(monkSkills, 40, {["id"] = 115181, ["specs"] = {268}}); -- Breath of Fire 
	AddUnlock(monkSkills, 40, {["id"] = 101546, ["specs"] = {269}}); -- Cyclone Strikes 
	AddUnlock(monkSkills, 40, {["id"] = 191837, ["specs"] = {269}}); -- Essence Font 
	AddUnlock(monkSkills, 42, {["id"] = 137384, ["specs"] = {269}}); -- Combo Breaker 
	AddUnlock(monkSkills, 42, {["id"] = 231606, ["specs"] = {270}}); -- Renewing Mist 2 
	AddUnlock(monkSkills, 48, {["id"] = 101545, ["specs"] = {269}}); -- Flying Serpent Kick 
	AddUnlock(monkSkills, 50, {["id"] = 115072, ["specs"] = {268}}); -- Expel Harm 
	AddUnlock(monkSkills, 50, {["id"] = 120224, ["specs"] = {269}}); -- Leather Specialization 
	AddUnlock(monkSkills, 50, {["id"] = 120225, ["specs"] = {268}}); -- Leather Specialization 
	AddUnlock(monkSkills, 50, {["id"] = 120227, ["specs"] = {270}}); -- Leather Specialization 
	AddUnlock(monkSkills, 50, {["id"] = 137639, ["specs"] = {269}}); -- Storm, Earth, and Fire
	AddUnlock(monkSkills, 50, {["id"] = 116680, ["specs"] = {270}}); -- Thunder Focus Tea 
	AddUnlock(monkSkills, 55, {["id"] = 115203, ["specs"] = {268}}); -- Fortifying Brew 
	AddUnlock(monkSkills, 55, {["id"] = 243435, ["specs"] = {270}}); -- Fortifying Brew 
	AddUnlock(monkSkills, 55, {["id"] = 122470, ["specs"] = {269}}); -- Touch of Karma 
	AddUnlock(monkSkills, 58, {["id"] = 231633, ["specs"] = {270}}); -- Essence Font 2 
	AddUnlock(monkSkills, 63, {["id"] = 231876, ["specs"] = {270}}); -- Thunder Focus Tea 
	AddUnlock(monkSkills, 65, {["id"] = 115176, ["specs"] = {268}}); -- Zen Meditation 
	AddUnlock(monkSkills, 66, {["id"] = 212051, ["specs"] = {270}}); -- Reawaken
	AddUnlock(monkSkills, 70, {["id"] = 216519, ["specs"] = {268}}); -- Celestial Fortune 
	AddUnlock(monkSkills, 70, {["id"] = 115310, ["specs"] = {270}}); -- Revival 
	AddUnlock(monkSkills, 70, {["id"] = 231627, ["specs"] = {269}}); -- Storm, Earth, and Fire 2 
	AddUnlock(monkSkills, 78, {["id"] = 115636, ["specs"] = {269}}); -- Mastery: Combo Strikes
	AddUnlock(monkSkills, 78, {["id"] = 117906, ["specs"] = {268}}); -- Mastery: Elusive Brawler
	AddUnlock(monkSkills, 78, {["id"] = 117907, ["specs"] = {270}}); -- Mastery: Gust of Mists
	AddUnlock(monkSkills, 80, {["id"] = 101643}); -- Transcendence
	AddUnlock(monkSkills, 80, {["id"] = 119996}); -- Transcendence: Transfer

_addonData.unlockData["skills"] = monkSkills;
_addonData.unlockData["specs"] = monkSpecs;

end

--
-- DEMON HUNTER
--

if (playerClass == "DEMONHUNTER") then
local dhSpecs = {
	577 -- Havoc
	, 581 -- Vengeance
};

local dhSkills = { };
	AddUnlock(dhSkills, 100, {["id"] = 196718, ["specs"] = {577}}); -- Darkness
	AddUnlock(dhSkills, 101, {["id"] = 202137, ["specs"] = {581}}); -- Sigil of Silence
	AddUnlock(dhSkills, 103, {["id"] = 218256, ["specs"] = {581}}); -- Empower Wards
	AddUnlock(dhSkills, 105, {["id"] = 207684, ["specs"] = {581}}); -- Sigil of Misery

_addonData.unlockData["skills"] = dhSkills;
_addonData.unlockData["specs"] = dhSpecs;

end

--------------------------
-- Zones
--------------------------

_addonData.unlockData["zones"] = { };


AddUnlock(_addonData.unlockData["zones"], 35, {["id"] = 22, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_WesternPlaguelands_01"}); -- Western Plaguelands
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 23, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_EasternPlaguelands"}); -- Eastern Plaguelands
AddUnlock(_addonData.unlockData["zones"], 30, {["id"] = 26, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Hinterlands_01"}); -- Hinterlands
AddUnlock(_addonData.unlockData["zones"], 25, {["id"] = 16, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_ArathiHighlands_01"}); -- Arathi Highlands
AddUnlock(_addonData.unlockData["zones"], 84, {["id"] = 700, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_TwilightHighlands"}); -- Twilight Highlands
AddUnlock(_addonData.unlockData["zones"], 80, {["id"] = 613, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Vashjir"}); -- Vash'jir
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 17, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Badlands_01"}); -- Badlands
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 28, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_SearingGorge_01"}); -- Searing Gorge
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 29, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_BurningSteppes_01"}); -- Burning Steppes
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 38, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_SwampSorrows_01"}); -- Swamp of Sorrows
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 19, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_BlastedLands_01"}); -- Blasted Lands
AddUnlock(_addonData.unlockData["zones"], 25, {["id"] = 37, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Stranglethorn_01"}); -- Northren Stranglethorn
AddUnlock(_addonData.unlockData["zones"], 30, {["id"] = 673, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Stranglethorn_01"}); -- Cape of Stranglethorn


AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 281, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Winterspring"}); -- Winterspring
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 182, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Felwood"}); -- Felwood
AddUnlock(_addonData.unlockData["zones"], 80, {["id"] = 606, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Mount Hyjal"}); -- Mount Hyjal
AddUnlock(_addonData.unlockData["zones"], 15, {["id"] = 13, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Ashenvale_01"}); -- Ashenvale
AddUnlock(_addonData.unlockData["zones"], 20, {["id"] = 81, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Stonetalon_01"}); -- Stonetalon
AddUnlock(_addonData.unlockData["zones"], 30, {["id"] = 101, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Desolace"}); -- Desolace
AddUnlock(_addonData.unlockData["zones"], 25, {["id"] = 607, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Barrens_01"}); -- Southern Barrens
AddUnlock(_addonData.unlockData["zones"], 35, {["id"] = 141, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_DustwallowMarsh"}); -- Dustwallow
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 61, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_ThousandNeedles_01"}); -- Thousand Needles
AddUnlock(_addonData.unlockData["zones"], 35, {["id"] = 121, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Feralas"}); -- Feralas
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 261, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Silithus_01"}); -- Silithus
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 201, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_UnGoroCrater_01"}); -- Un'Goro
AddUnlock(_addonData.unlockData["zones"], 40, {["id"] = 161, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Tanaris_01"}); -- Tanaris
AddUnlock(_addonData.unlockData["zones"], 83, {["id"] = 720, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Uldum"}); -- Uldum

AddUnlock(_addonData.unlockData["zones"], 82, {["id"] = 640, ["continentID"] = 751, ["icon"] = "Interface/ICONS/Achievement_Zone_DeepHolm"}); -- Deepholm

AddUnlock(_addonData.unlockData["zones"], 58, {["id"] = 465, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_HellfirePeninsula_01"}); -- Hellfire Peninsula
AddUnlock(_addonData.unlockData["zones"], 60, {["id"] = 467, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_Zangarmarsh"}); -- Zangarmarsh
AddUnlock(_addonData.unlockData["zones"], 62, {["id"] = 478, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_Terrokar"}); -- Terrokar
AddUnlock(_addonData.unlockData["zones"], 64, {["id"] = 477, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_Nagrand_01"}); -- Nagrand
AddUnlock(_addonData.unlockData["zones"], 65, {["id"] = 475, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_BladesEdgeMtns_01"}); -- Blade's Edge
AddUnlock(_addonData.unlockData["zones"], 67, {["id"] = 479, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_Netherstorm_01"}); -- Netherstorm
AddUnlock(_addonData.unlockData["zones"], 67, {["id"] = 473, ["continentID"] = 466, ["icon"] = "Interface/ICONS/Achievement_Zone_Shadowmoon"}); -- Shadowmoon

AddUnlock(_addonData.unlockData["zones"], 58, {["id"] = 486, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_BoreanTundra_01"}); -- Borean Tundra
AddUnlock(_addonData.unlockData["zones"], 58, {["id"] = 491, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_HowlingFjord_01"}); -- Howling Fjord
AddUnlock(_addonData.unlockData["zones"], 61, {["id"] = 488, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_DragonBlight_01"}); -- DragonBlight
AddUnlock(_addonData.unlockData["zones"], 63, {["id"] = 490, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_GrizzlyHills_01"}); -- Grizzly Hiils
AddUnlock(_addonData.unlockData["zones"], 64, {["id"] = 496, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_ZulDrak_01"}); -- Zul'drak
AddUnlock(_addonData.unlockData["zones"], 65, {["id"] = 493, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_Sholazar_01"}); -- Sholazar
AddUnlock(_addonData.unlockData["zones"], 67, {["id"] = 495, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_StormPeaks_01"}); -- Storm Peaks
AddUnlock(_addonData.unlockData["zones"], 67, {["id"] = 492, ["continentID"] = 485, ["icon"] = "Interface/ICONS/Achievement_Zone_IceCrown_01"}); -- Icerown

AddUnlock(_addonData.unlockData["zones"], 80, {["id"] = 806, ["continentID"] = 862, ["icon"] = "Interface/ICONS/Achievement_Zone_JadeForest"}); -- The Jade Forest
AddUnlock(_addonData.unlockData["zones"], 81, {["id"] = 807, ["continentID"] = 862, ["icon"] = "Interface/ICONS/Achievement_Zone_ValleyofFourWinds"}); -- Valley of Four Winds
AddUnlock(_addonData.unlockData["zones"], 81, {["id"] = 857, ["continentID"] = 862, ["icon"] = "Interface/ICONS/Achievement_Zone_KrasarangWilds"}); -- Krasarang Wilds
AddUnlock(_addonData.unlockData["zones"], 82, {["id"] = 809, ["continentID"] = 862, ["icon"] = "Interface/ICONS/Achievement_Zone_KunLaiSummit"}); -- Kun-Lai Summit
AddUnlock(_addonData.unlockData["zones"], 83, {["id"] = 810, ["continentID"] = 862, ["icon"] = "Interface/ICONS/Achievement_Zone_TownlongSteppes"}); -- Townlong Steppes
AddUnlock(_addonData.unlockData["zones"], 84, {["id"] = 858, ["continentID"] = 862, ["icon"] = "Interface/ICONS/Achievement_Zone_DreadWastes"}); -- Dread Wastes

AddUnlock(_addonData.unlockData["zones"], 90, {["id"] = 941, ["continentID"] = 962, ["icon"] = "Interface/ICONS/Achievement_Zone_Frostfire"}); -- Frostfire Ridge
AddUnlock(_addonData.unlockData["zones"], 90, {["id"] = 947, ["continentID"] = 962, ["icon"] = "Interface/ICONS/Achievement_Zone_Newshadowmoonvalley"}); -- Shadowmoon
AddUnlock(_addonData.unlockData["zones"], 92, {["id"] = 949, ["continentID"] = 962, ["icon"] = "Interface/ICONS/Achievement_Zone_Gorgrond"}); -- Gorgrond
AddUnlock(_addonData.unlockData["zones"], 94, {["id"] = 946, ["continentID"] = 962, ["icon"] = "Interface/ICONS/Achievement_Zone_Talador"}); -- Talador
AddUnlock(_addonData.unlockData["zones"], 96, {["id"] = 948, ["continentID"] = 962, ["icon"] = "Interface/ICONS/Achievement_Zone_SpiresofArak"}); -- Bladespire
AddUnlock(_addonData.unlockData["zones"], 98, {["id"] = 950, ["continentID"] = 962, ["icon"] = "Interface/ICONS/Achievement_Zone_Nagrand_02"}); -- Nagrand

AddUnlock(_addonData.unlockData["zones"], 100, {["id"] = 1015, ["continentID"] = 1007, ["icon"] = "Interface/ICONS/Achievements_Zone_Azsuna"}); -- Azsuna
AddUnlock(_addonData.unlockData["zones"], 100, {["id"] = 1018, ["continentID"] = 1007, ["icon"] = "Interface/ICONS/Achievements_Zone_ValSharah"}); -- Val'Sharah
AddUnlock(_addonData.unlockData["zones"], 100, {["id"] = 1024, ["continentID"] = 1007, ["icon"] = "Interface/ICONS/Achievements_Zone_Highmountain"}); -- Highmountain
AddUnlock(_addonData.unlockData["zones"], 100, {["id"] = 1017, ["continentID"] = 1007, ["icon"] = "Interface/ICONS/Achievements_Zone_Stormheim"}); -- Stormheim


if (playerFaction == "Alliance") then
	AddUnlock(_addonData.unlockData["zones"], 15, {["id"] = 36, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_RedridgeMountains"}); -- Redridge
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 35, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_LochModan"}); -- Loch Modan
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 476, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_BloodmystIsle_01"}); -- Bloodmyst Isle
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 42, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Darkshore_01"}); -- Darkshore
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 39, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_WestFall_01"}); -- Westfall
	AddUnlock(_addonData.unlockData["zones"], 20, {["id"] = 34, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Duskwood"}); -- Duskwood
	AddUnlock(_addonData.unlockData["zones"], 25, {["id"] = 40, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Wetlands_01"}); -- Wetlands
else
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 181, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Azshara_01"}); -- Azshara
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 463, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Ghostlands"}); -- Ghostlands
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 11, ["continentID"] = 13, ["icon"] = "Interface/ICONS/Achievement_Zone_Barrens_01"}); -- Northren Barrens
	AddUnlock(_addonData.unlockData["zones"], 10, {["id"] = 21, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_Silverpine_01"}); -- Silverpine
	AddUnlock(_addonData.unlockData["zones"], 15, {["id"] = 24, ["continentID"] = 14, ["icon"] = "Interface/ICONS/Achievement_Zone_HillsbradFoothills"}); -- Hillsbrad
end










