-- Random fun things to do while fishing
--
-- Turn on the fish finder
-- Change your title to "Salty"
-- Bring out a "fishing buddy"

local FL = LibStub("LibFishing-1.0");

-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

local CurLoc = GetLocale();

-- wrap settings
local FBGetSetting = FishingBuddy.GetSetting;
local FBGetSettingBool = FishingBuddy.GetSettingBool;

local function GetSettingBool(setting)
	if (FBGetSettingBool("FishingFluff")) then
		return FBGetSettingBool(setting);
	end
	-- return nil;
end

local function GetSetting(setting)
	if (FBGetSettingBool("FishingFluff")) then
		return FBGetSetting(setting);
	end
	-- return nil;
end

local FluffEvents = {};

local unTrack = nil;
local resetPVP = nil;

local LastSpecialBait = nil;
local SpecialBait = 
{
	[7] = {
		110274,		-- Jawless Skulker Bait
		110289,		-- Fat Sleeper Bait
		110290,		-- Blind Lake Sturgeon Bait
		110291,		-- Fire Ammonite Bait
		110292,		-- Sea Scorpion Bait
		110293,		-- Abyssal Gulper Eel Bait
		110294,		-- Blackwater Whiptail Bait
	},
	[8] = {
		139175,		-- Arcane lure
	}
};

FluffEvents[FBConstants.FISHING_ENABLED_EVT] = function()
	LastSpecialBait = nil;
	if ( FishingBuddy.GetSettingBool("FishingFluff")) then
		if ( GetSettingBool("FindFish") ) then
			local findid = FL:GetFindFishID();
			if ( findid ) then
				local _, _, active, _ = GetTrackingInfo(findid);
				if (not active) then
					unTrack = true;
					SetTracking(findid, true);
				end
			end
		end
		
		if ( GetSettingBool("TurnOffPVP") ) then
			if (1 == GetPVPDesired() ) then
				resetPVP = true;
				SetPVP(0);
			end
		end
	end
end

local function Untrack(yes)
	if ( yes ) then
		local findid = FL:GetFindFishID();
		if ( findid ) then
			SetTracking(findid, false);
		end
	end
end

FluffEvents[FBConstants.FISHING_DISABLED_EVT] = function(started, logout)
	if ( resetPVP ) then
		SetPVP(1);
	end
	if ( logout ) then
		FishingBuddy_Player["Untrack"] = unTrack;
	else
		Untrack(unTrack);
	end
	unTrack = nil;
	resetPVP = nil;
	LastSpecialBait = nil;
end

FluffEvents[FBConstants.LOGIN_EVT] = function()
	if ( FishingBuddy_Player ) then
		if ( FishingBuddy_Player["Untrack"] ) then
			FishingBuddy_Player["Untrack"] = nil;
			Untrack(1);
		end
	end
end

local GSB = FishingBuddy.GetSettingBool;
local QuestBaits = {
	{
		item = 114628,		-- Icespine Stinger Bait
		spell = 168448,
	},
	{
		item = 114874,		-- Moonshell Claw Bait
		spell = 168868,
	},
};

local objectiveMapID = { 941, 946, 947, 948, 949, 950 }
local function IsQuestFishing(item)
	-- Check for hookshot
	if (GetItemCount(116755) > 0) then
		-- Better Nat's quest checking by Bodar (Curse)
		local questLogIndex = GetQuestLogIndexByID(36611);
		if (questLogIndex > 0) then
			local currentMapID = GetCurrentMapAreaID();
			local numObjectives = GetNumQuestLeaderBoards(questLogIndex);
			for i = 1, numObjectives do
				local text, objectiveType, finished = GetQuestLogLeaderBoard(i, questLogIndex);
				if (not finished and currentMapID == objectiveMapID[i]) then
					return true;
				end
			end
		end
	end

	-- and intro quest baits
	for _,bait in ipairs(QuestBaits) do
		if (GetItemCount(bait.item) > 0 or FL:HasBuff(bait.spell)) then
			return true;
		end
	end
end

local function SetupSpecialItem(id, info, fixsetting, fixloc)
	info.id = id
	if (fixsetting and info.enUS and not info.setting) then
		info.setting = info.enUS:gsub("%s+", "")
	end
	if (fixloc and not info[CurLoc]) then
		local link = "item:"..id;
		local n,l,_,_,_,_,_,_ = FL:GetItemInfo(link);
		if (n and l) then
			info[CurLoc] = n
		else
			info[CurLoc] = info.enUS
		end
	end

	return info;
end
FishingBuddy.SetupSpecialItem = SetupSpecialItem

local function AlreadyUsedFishingItem(id, info)
	if (info.spell) then
		return FL:HasBuff(info.spell)
	end
end

local function CanUseFishingItems(setting, items)
	if (GSB(setting)) then
		local foundone = false;
		for id,info in pairs(items) do
			foundone = true;
			if (AlreadyUsedFishingItem(id, info)) then
				return false;
			end
		end
		return foundone;
	end
	return false;
end

local FishingItems = {};
FishingItems[85973] = {
	["enUS"] = "Ancient Pandaren Fishing Charm",
	["tooltip"] = FBConstants.CONFIG_FISHINGCHARM_INFO,
	spell = 125167,
	setting = "UsePandarenCharm",
	usable = function(item)
			-- only usable in Pandoria
			local C,_,_,_ = FL:GetCurrentPlayerPosition();
			return (C == 6);
		end,
	["default"] = true,
};
FishingItems[122742] = {
	["enUS"] = "Bladebone Hook",					-- 1 hour duration
	["spell"] = 182226,
	setting = "UseBladeboneHook",
	visible = function(option)
			return true;
		end,
	usable = function(item)
			-- only usable in Draenor
			local C,_,_,_ = FL:GetCurrentPlayerPosition();
			return (C == 7);
		end,
	["default"] = false,
};
FishingItems[116755] = {
	["enUS"] = "Nat's Hookshot",
	spell = 171740,
	usable = IsQuestFishing,
};

local LevelingItems = {}
LevelingItems[139652] = {
	["enUS"] = "Leyshimmer Blenny", -- AP
}
LevelingItems[133725] = {
	["enUS"] = "Leyshimmer Blenny", -- skill
}
LevelingItems[139653] = {
	["enUS"] = "Nar'thalas Hermit", -- AP
}
LevelingItems[133726] = {
	["enUS"] = "Nar'thalas Hermit", -- skill
}
LevelingItems[139654] = {
	["enUS"] = "Ghostly Queenfish", -- AP
}
LevelingItems[133727] = {
	["enUS"] = "Ghostly Queenfish", -- skill
}
LevelingItems[139655] = {
	["enUS"] = "Terrorfin", -- AP
}
LevelingItems[133728] = {
	["enUS"] = "Terrorfin", -- skill
}
LevelingItems[139656] = {
	["enUS"] = "Thorned Flounder*", -- AP
}
LevelingItems[133729] = {
	["enUS"] = "Thorned Flounder*", -- skill
}
LevelingItems[139657] = {
	["enUS"] = "Ancient Mossgill", -- AP
}
LevelingItems[133730] = {
	["enUS"] = "Ancient Mossgill", -- skill
}
LevelingItems[139658] = {
	["enUS"] = "Mountain Puffer", -- AP
}
LevelingItems[133731] = {
	["enUS"] = "Mountain Puffer", -- skill
}
LevelingItems[139659] = {
	["enUS"] = "Coldriver Carp", -- AP
}
LevelingItems[133732] = {
	["enUS"] = "Coldriver Carp", -- skill
}
LevelingItems[139660] = {
	["enUS"] = "Ancient Highmountain Salmon", -- AP
}
LevelingItems[133733] = {
	["enUS"] = "Ancient Highmountain Salmon", -- skill
}
LevelingItems[139661] = {
	["enUS"] = "Oodelfjisk", -- AP
}
LevelingItems[133734] = {
	["enUS"] = "Oodelfjisk", -- skill
}
LevelingItems[139662] = {
	["enUS"] = "Graybelly Lobster", -- AP
}
LevelingItems[133735] = {
	["enUS"] = "Graybelly Lobster", -- skill
}
LevelingItems[139663] = {
	["enUS"] = "Thundering Stormray", -- AP
}
LevelingItems[133736] = {
	["enUS"] = "Thundering Stormray", -- skill
}
LevelingItems[139664] = {
	["enUS"] = "Magic-Eater Frog", -- AP
}
LevelingItems[133737] = {
	["enUS"] = "Magic-Eater Frog", -- skill
}
LevelingItems[139665] = {
	["enUS"] = "Seerspine Puffer", -- AP
}
LevelingItems[133738] = {
	["enUS"] = "Seerspine Puffer", -- skill
}
LevelingItems[139666] = {
	["enUS"] = "Tainted Runescale Koi", -- AP
}
LevelingItems[133739] = {
	["enUS"] = "Tainted Runescale Koi", -- skill
}
LevelingItems[139667] = {
	["enUS"] = "Axefish", -- AP
}
LevelingItems[133740] = {
	["enUS"] = "Axefish", -- skill
}
LevelingItems[139668] = {
	["enUS"] = "Seabottom Squid", -- AP
}
LevelingItems[133741] = {
	["enUS"] = "Seabottom Squid", -- skill
}
LevelingItems[139669] = {
	["enUS"] = "Ancient Black Barracuda", -- AP
}
LevelingItems[133742] = {
	["enUS"] = "Ancient Black Barracuda", -- skill
}

local function CastAndThrow()
	if GSB("AutoOpen") then
		for id,info in pairs(LevelingItems) do
			if GetItemCount(id) > 0 then
				return "/use "..info[CurLoc].."\n/cast "..PROFESSIONS_FISHING
			end
		end
	end
end
FishingBuddy.CastAndThrow = CastAndThrow

-- Dalaran coin lures
local CoinLures = {};
local function CanUseCoinLure()
	return CanUseFishingItems("DalaranLures", CoinLures);
end

CoinLures[138956] = {
	["enUS"] = "Hypermagnetic Lure",
	setting = "DalaranLures",
	spell = 217835,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138959] = {
	["enUS"] = "Micro-Vortex Generator",
	setting = "DalaranLures",
	spell = 217838,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138961] = {
	["enUS"] = "Alchemical Bonding Agent",
	setting = "DalaranLures",
	spell = 217840,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138962] = {
	["enUS"] = "Starfish on a String",
	setting = "DalaranLures",
	spell = 217842,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138957] = {
	["enUS"] = "Auriphagic Sardine",
	setting = "DalaranLures",
	spell = 217836,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138960] = {
	["enUS"] = "Wish Crystal",
	setting = "DalaranLures",
	spell = 217839,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138963] = {
	["enUS"] = "Tiny Little Grabbing Apparatus",
	setting = "DalaranLures",
	spell = 217844,
	usable = CanUseCoinLure,
	ignore = true,
};
CoinLures[138958] = {
	["enUS"] = "Glob of Really Sticky Glue",
	setting = "DalaranLures",
	spell = 217837,
	usable = CanUseCoinLure,
	ignore = true,
};

local seascorpion = {
	["Shadowmoon Valley (Draenor)"] = {
		["Darktide Strait"] = true,
		["The Evanescent Sea"] = true,
		["Karabor Harbor"] = true,
		["Tanaan Channel"] = true,
	},
	["Gorgrond"] = {
		["Colossal Depths"] = true,
		["Barrier Sea"] = true,
		["Iron Sea"] = true,
		["Orunai Coast"] = true,
	},
	["Talador"] = {
		["Aarko's Estate"] = true,
		["Orunai Delta"] = true,
		["The South Sea"] = true,
		["Sha'tari Anchorage"] = true,
		["Shattrath Port Authority"] = true,
		["Beacon of Sha'tar"] = true,
		["The Sunset Shore"] = true,
		["Orunai Bay"] = true,
		["Orunai Coast"] = true,
	},
	["Frostfire Ridge"] = {
		["Colossal Depths"] = true,
		["Frostboar Point"] = true,
		["Frostbite Deep"] = true,
		["Southwind Inlet"] = true,
		["Ata'gar Promontory"] = true,
		["Tor'goroth's Tooth"] = true,
		["Cold Snap Coast"] = true,
		["Zangar Sea"] = true,
		["Frostangler Bay"] = true,
		["Southwind Cliffs"] = true,
		["The Pale Cove"] = true,
		["Throm'var Landing"] = true,
		["Glacier Bay"] = true,
		["Ozgor's Launch"] = true,
		["Iron Sea"] = true,
	},
	["Nagrand (Draenor)"] = {
		["The Colossal's Fist"] = true,
		["Lernaen Shore"] = true,
		["Zangar Shore"] = true,
		["Cerulean Lagoon"] = true,
		["Ironfist Harbor"] = true,
		["Zangar Sea"] = true,
		["Windroc Bay"] = true,
		["The South Sea"] = true,
		["The Cliffs of Highmaul"] = true,
		["Highmaul Harbor"] = true,
	},
	["Tanaan Jungle"] = {
		["Tanaan Channel"] = true,
		["Barrier Sea"] = true,
	},
	["Spires of Arak"] = {
		["Pinchwhistle Gearworks"] = true,
		["Echidnean Shelf"] = true,
		["The South Sea"] = true,
		["Wreck of the Mother Lode"] = true,
		["The Writhing Mire"] = true,
		["Southport"] = true,
		["Bloodmane Pridelands"] = true,
		["The Evanescent Sea"] = true,
	},
};

local function CurrentSpecialBait()
	local continent = GetCurrentMapContinent();
	local baits = SpecialBait[continent];
	if (baits) then
		for _,id in ipairs(baits) do
			local bait = FishingItems[id];
			if (bait and FL:HasBuff(bait.spell)) then
				return id;
			end
		end
	end
	-- return nil
end

local function CheckSpecialBait(info, buff, need)
	local continent = GetCurrentMapContinent();
	if (SpecialBait[continent]) then
		if ( GSB("DraenorBaitMaintainOnly") and LastSpecialBait ) then
			return true, LastSpecialBait;
		else
			if (not FL:HasBuff(info.spell)) then
				return true, info.id;
			end
		end
	end
end

local function VerifySpecialBait(info, checkscorpion)
	if (not IsQuestFishing()) then
		if (GSB("EasyLures") and GSB("DraenorBait")) then
			local continent = GetCurrentMapContinent();
			if ( GSB("DraenorBaitMaintainOnly") ) then
				local baitid = CurrentSpecialBait();
				if ( not baitid and LastSpecialBait ) then
					if (GetItemCount(LastSpecialBait) > 0) then
						return true;
					end
				else
					LastSpecialBait = baitid;
				end
			elseif (continent == 7 ) then
				local zone, subzone = FL:GetBaseZoneInfo();
				if ( checkscorpion ) then
					return (seascorpion[zone] and seascorpion[zone][subzone]);
				elseif ( zone == info.zone) then
					return not seascorpion[zone][subzone];
				end
			end
		end
	end
	-- return nil;
end

local function UseSeaScorpionBait(info)
	return VerifySpecialBait(info, true);
end


local function UsableSpecialBait(info)
	return VerifySpecialBait(info, false);
end

-- Blind Lake Sturgeon, 158035
FishingItems[110290] = {
	["enUS"] = "Blind Lake Sturgeon Bait",
	spell = 158035,
	zone = "Shadowmoon Valley (Draenor)",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};
FishingItems[110293] = {
	["enUS"] = "Abyssal Gulper Eel Bait",
	spell = 158038,
	zone = "Spires of Arak",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};
FishingItems[110294] = {
	["enUS"] = "Blackwater Whiptail Bait",
	spell = 158039,
	zone = "Talador",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};
FishingItems[110289] = {
	["enUS"] = "Fat Sleeper Bait",
	spell = 158034,
	zone = "Nagrand (Draenor)",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};
FishingItems[110291] = {
	["enUS"] = "Fire Ammonite Bait",
	spell = 158036,
	zone = "Frostfire Ridge",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};
FishingItems[110274] = {
	["enUS"] = "Jawless Skulker Bait",
	spell = 158031,
	zone = "Gorgrond",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};
FishingItems[128229] = {
	["enUS"] = "Felmouth Frenzy Bait",
	spell = 188904,
	zone = "Tanaan Jungle",
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};

FishingItems[110292] = {
	["enUS"] = "Sea Scorpion Bait",
	spell = 158037,
	zone = "Non-inland water",
	usable = UseSeaScorpionBait,
	check = CheckSpecialBait,
};

FishingItems[139175] = {
	["enUS"] = "Arcane Lure",
	spell = 218861,
	usable = UsableSpecialBait,
	check = CheckSpecialBait,
};

FishingBuddy.FishingItems = FishingItems;

local FISHINGHATS = {
	[118393] = true,        -- Tentacled Hat
	[118380] = true,        -- HightFish Cap
};
FishingBuddy.FishingHats = FISHINGHATS;

local FluffOptions = {
	["FishingFluff"] = {
		["text"] = FBConstants.CONFIG_FISHINGFLUFF_ONOFF,
		["tooltip"] = FBConstants.CONFIG_FISHINGFLUFF_INFO,
		["v"] = 1,
		["m1"] = 1,
		["p"] = 1,
		["default"] = true
	},
	["FindFish"] = {
		["text"] = FBConstants.CONFIG_FINDFISH_ONOFF,
		["tooltip"] = FBConstants.CONFIG_FINDFISH_INFO,
		["v"] = 1,
		["m"] = 1,
		["parents"] = { ["FishingFluff"] = "d" },
		["default"] = true
	},
	["DrinkHeavily"] = {
		["text"] = FBConstants.CONFIG_DRINKHEAVILY_ONOFF,
		["tooltip"] = FBConstants.CONFIG_DRINKHEAVILY_INFO,
		["v"] = 1,
		["m"] = 1,
		["parents"] = { ["FishingFluff"] = "d" },
		["default"] = true
	},
};

local function ItemInit(option, button)
	local n, _, _, _, _, _, _, _,_, _ = GetItemInfo(option.id);
	if (n) then
		option.text = n;
	else
		option.text = option.enUS;
	end
end

local function ItemVisible(option)
	return GetItemCount(option.id) > 0;
end

local function UpdateItemOption(id, info)
	info.id = id;
	if (info.setting and not info.ignore) then
		local option = {};

		option.id = id;
		option.enUS = info.enUS;

		if (info.visible) then
			option.visible = info.visible;
		else
			option.visible = ItemCountVisible;
		end

		option.init = ItemInit;

		option.tooltip = info.tooltip;
		option.setup = info.setup;
		option.enabled = info.enabled;
		option.default = info.default;

		option.v = 1;
		-- option.deps = { ["FishingFluff"] = "d" };
		FluffOptions[info.setting] = option;

		if (info.option) then
			local sub = {};
			sub.text = info.option.text;
			sub.tooltip = info.option.tooltip;
			sub.default = info.option.default;
			sub.visible = option.visible;
			sub.v = 1;
			sub.parents = {};
			sub.parents[info.setting] = "d";
			FluffOptions[info.option.setting] = sub;
		end
	end
end
FishingBuddy.UpdateFluffOption = UpdateItemOption

local function UpdateItemOptions()
	for id,info in pairs(FishingItems) do
		UpdateItemOption(id, info)
	end
	
	FishingBuddy.FluffOptions = FluffOptions;
end

local function SetupSpecialItems(items, fixsetting, fixloc, skipitem)
	for id,info in pairs(items) do
		info = SetupSpecialItem(id, info, fixsetting, fixloc);
		if ( not skipitem ) then
			FishingItems[id] = info;
			UpdateItemOption(id, info)
		end
	end
end
FishingBuddy.SetupSpecialItems = SetupSpecialItems

local function AddFluffOptions(options)
	FishingBuddy.OptionsFrame.HandleOptions(FBConstants.CONFIG_FISHINGFLUFF_ONOFF, "Interface\\Icons\\inv_misc_food_164_fish_seadog", options);
end
FishingBuddy.AddFluffOptions = AddFluffOptions

FluffEvents["VARIABLES_LOADED"] = function(started)
	-- Let's make sure we have buffs on all the items we currently know about
	for id,info in pairs(FishingItems) do
		SetupSpecialItem(id, info);
	end

	SetupSpecialItems(CoinLures);
	SetupSpecialItems(LevelingItems, false, true, true);
end

FluffEvents[FBConstants.FIRST_UPDATE_EVT] = function()
	UpdateItemOptions();
	AddFluffOptions(FluffOptions)
end

FishingBuddy.RegisterHandlers(FluffEvents);

if ( FishingBuddy.Commands["debug"] ) then
	FishingBuddy.SeaScorpion = seascorpion;
	
	FishingBuddy.CurrentSpecialBait = CurrentSpecialBait;
end
