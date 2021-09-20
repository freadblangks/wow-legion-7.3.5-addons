
----------------------------------------
-- Variables
----------------------------------------

local _addonName, _addonData = ...;
local _L = _addonData.L;
local _version = GetAddOnMetadata(_addonName, "version");
local _aVar = _addonData.variables;

-- Globals to use in xml
ILW_BANNER_TEXT = _L["BANNER_UNLOCKED"];
ILW_TOOLTIP_CLEARBUTTON = _L["TOOLTIP_CLEARBUTTON"];
ILW_NONEW_INFO = _L["NONEW_INFO"];
ILW_NONEW_TITLE = _L["NONEW_TITLE "];

local ILWAddon = LibStub("AceAddon-3.0"):NewAddon(_addonName);
local ILWBroker = LibStub("LibDataBroker-1.1"):NewDataObject(_addonName, {
	type = "launcher",
	text = _L["I Learned What?"],
	icon = "Interface/ICONS/Spell_Holy_SurgeOfLight",
	OnClick = function(self, button, down)
		-- if (InCombatLockdown()) then
			-- return;
		-- end
		if (ILW_UnlockContainer:IsShown()) then
			HideUIPanel(ILW_UnlockContainer);
		else
			ILW_UnlockContainer:Open();
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine(_L["I Learned What?"], 1, 1, 1);
		tt:AddLine(_L["MINIMAP_TOOLTIP"]);
	end	
})
local _icon = LibStub("LibDBIcon-1.0")

local _defaults = {
	["global"] = {	
		showPopup = true,
		minimap = {
			hide = false,
		},
		["trackers"] = {
			["Spells"] = true,
			["Talents"] = true,
			["Dungeons"] = true,
			["Riding"] = true,
			["UI"] = true,
			["Battlegrounds"] = true,
			["Zones"] = true,
		}
	}
	,["char"] = {
		["unlockedList"] = {},
		["specLastLevel"] = {},
	}
}

local _trackers = {
		["Spells"] = true
		,["Talents"] = true
		,["Dungeons"] = true
		,["Riding"] = true
		,["Battlegrounds"] = true
		,["UI"] = true
		,["Zones"] = true
	}
	
local _trackerLabels = {
		["Spells"] = _L["TRACKER_SPELLS"]
		,["Talents"] = _L["TRACKER_TALENTS"]
		,["Dungeons"] = _L["TRACKER_DUNGEONS"]
		,["Riding"] = _L["TRACKER_RIDING"]
		,["Battlegrounds"] = _L["TRACKER_BATTLEGROUNDS"]
		,["UI"] = _L["TRACKER_UI"]
		,["Zones"] = _L["TRACKER_ZONES"]
	}

_addonData.help = {}
local _help = _addonData.help;

local UNLOCKTYPE_SPELL = 1;
local UNLOCKTYPE_TALENT = 2;
local UNLOCKTYPE_DUNGEON = 3;
local UNLOCKTYPE_RAID = 4;
local UNLOCKTYPE_PVP = 5;
local UNLOCKTYPE_RIDING = 6;
local UNLOCKTYPE_UI = 7;
local UNLOCKTYPE_TUTORIAL = 8;
local UNLOCKTYPE_ZONES = 9;

local ICON_TALENT = "Interface/ICONS/Ability_Marksmanship";
local ICON_UI = "Interface/ICONS/INV_Scroll_02";

local UNLOCK_SUBTYPE_TUTORIAL = 0;
local UNLOCK_SUBTYPE_UPCOMMING = 1;

local UNLOCKS_PER_PAGE = 5;

local MAXLEVEL = GetMaxPlayerLevel();
local MINLEVEL = 1;
local _playerClass = select(2, UnitClass("player"));
if (_playerClass == "DEATHKNIGHT") then
	MINLEVEL = 55
elseif (_playerClass == "DEMONHUNTER") then
	MINLEVEL = 98
end

local _helpPlate = {
	FramePos = { x = 5,	y = -25 },
	FrameSize = { width = 440, height = 495	},
	[1] = { ButtonPos = { x = 210,	y = -95}, HighLightBox = { x = 30, y = -85, width = 395, height = 348 }, ToolTipDir = "DOWN", ToolTipText = _L["HELP_INFO"] }
	,[2] = { ButtonPos = { x = 210,	y = -445}, HighLightBox = { x = 10, y = -445, width = 430, height = 70 }, ToolTipDir = "UP", ToolTipText = _L["HELP_INFO_CHART"] }
}
local _typeIcons = {
		[UNLOCKTYPE_SPELL] = {["left"] = 0.205078125, ["right"] = 0.267578125, ["top"] = 0.9296875, ["bottom"] = 0.990234375}
		,[UNLOCKTYPE_UI] = {["left"] = 0.46484375, ["right"] = 0.53125, ["top"] = 0.59765625, ["bottom"] = 0.6640625}
		,[UNLOCKTYPE_DUNGEON] = {["left"] = 0.1328125, ["right"] = 0.19921875, ["top"] = 0.6590625, ["bottom"] = 0.72546875}
		,[UNLOCKTYPE_RAID] = {["left"] = 0.1328125, ["right"] = 0.19921875, ["top"] = 0.72546875, ["bottom"] = 0.791875}
		,[UNLOCKTYPE_TALENT] = {["left"] = 0.06640625, ["right"] = 0.1328125, ["top"] = 0.265625, ["bottom"] = 0.33203125}
		,[UNLOCKTYPE_PVP] = {["left"] = 0, ["right"] = 0.06640625, ["top"] = 0.9296875, ["bottom"] = 0.99609375}
		,[UNLOCKTYPE_RIDING] = {["left"] = 0.06640625, ["right"] = 0.1328125, ["top"] = 0.86328125, ["bottom"] = 0.9296875}
		,[UNLOCKTYPE_ZONES] = {["left"] = 0.73046875, ["right"] = 0.796875, ["top"] = 0.265625, ["bottom"] = 0.33203125}
	};

function ILW_ShowHelpUnlocks(show)
	local unlocklist = ILWAddon.db.char.unlockedList;
	
	-- when showing help, if there's no unlocks, show dummy unlocks
	if (show and #unlocklist == 0) then
		table.insert(unlocklist, {["type"] = UNLOCKTYPE_SPELL, ["level"] = 3, ["icon"] = "Interface/ICONS/spell_fire_fireball02", ["name"] = _L["EXAMPLE_ABILITY"] , ["subText"] = COMBATLOG_HIGHLIGHT_ABILITY, ["subType"] = UNLOCK_SUBTYPE_TUTORIAL});
		table.insert(unlocklist, {["type"] = UNLOCKTYPE_SPELL, ["level"] = 5, ["icon"] = "Interface/ICONS/spell_frost_frostbolt02", ["name"] = _L["EXAMPLE_ABILITY"] , ["subText"] = COMBATLOG_HIGHLIGHT_ABILITY, ["subType"] = UNLOCK_SUBTYPE_TUTORIAL});
		table.insert(unlocklist, {["type"] = UNLOCKTYPE_DUNGEON, ["level"] = 5, ["icon"] = "Interface/LFGFRAME/LFGICON-DIREMAUL", ["name"] = _L["EXAMPLE_DUNGEON"] , ["subText"] = CALENDAR_TYPE_DUNGEON, ["subType"] = UNLOCK_SUBTYPE_TUTORIAL});
		table.insert(unlocklist, {["type"] = UNLOCKTYPE_SPELL, ["level"] = 7, ["icon"] = "Interface/ICONS/spell_nature_wispsplode", ["name"] = _L["EXAMPLE_ABILITY"] , ["subText"] = COMBATLOG_HIGHLIGHT_ABILITY, ["subType"] = UNLOCK_SUBTYPE_TUTORIAL});
		table.insert(unlocklist, {["type"] = UNLOCKTYPE_SPELL, ["level"] = 7, ["icon"] = "Interface/ICONS/ability_mage_wintersgrasp", ["name"] = _L["EXAMPLE_PASSIVE"] , ["subText"] = SPELL_PASSIVE , ["subType"] = UNLOCK_SUBTYPE_TUTORIAL});
	end
	
	-- when hiding help, remove dummy unlocks
	if (not show and unlocklist) then
		for i=#unlocklist, 1, -1 do
			if (unlocklist[i]["subType"] == UNLOCK_SUBTYPE_TUTORIAL) then
				table.remove(unlocklist, i);
			end
		end
	end
	
	ILW_UnlockContainer:UpdateUnlockDisplay();
end

local function GetPlayerSpec()
	if (GetSpecialization() ~= nil) then
		return GetSpecializationInfo(GetSpecialization());
	end
	
	return nil;
end


ILW_DATA_MIXIN = {};

function ILW_DATA_MIXIN:Initialize()
	self.unlockedList = ILWAddon.db.char.unlockedList;
	self.upcomming = {};
	self.upcommingLevel = 0;
	self.filteredList = {};
	self.filteredChart = {};
	self.unlockData = _addonData.unlockData;
	self.unlockTables = {};
	self.playerLevel = UnitLevel("player");
	
	self.quickFilters = {
			[UNLOCKTYPE_DUNGEON] = function() return ILWAddon.db.global.trackers["Dungeons"] end
			,[UNLOCKTYPE_RAID] = function() return ILWAddon.db.global.trackers["Dungeons"] end
			,[UNLOCKTYPE_PVP] = function() return ILWAddon.db.global.trackers["Battlegrounds"] end
			,[UNLOCKTYPE_RIDING] = function() return ILWAddon.db.global.trackers["Riding"] end
			,[UNLOCKTYPE_SPELL] = function() return ILWAddon.db.global.trackers["Spells"] end
			,[UNLOCKTYPE_TALENT] = function() return ILWAddon.db.global.trackers["Talents"] end
			,[UNLOCKTYPE_UI] = function() return ILWAddon.db.global.trackers["UI"] end
			,[UNLOCKTYPE_ZONES] = function() return ILWAddon.db.global.trackers["Zones"] end
		}
end

function ILW_DATA_MIXIN:LoadUnlockTable()
	wipe(self.unlockTables)
	
	local newTable = nil;
	for i = MINLEVEL, MAXLEVEL do
		if newTable == nil then
			newTable = {};
		end
		
		self:AddUnlocksOfLevel(i, newTable);
		
		if #newTable > 0 then
			self.unlockTables[i] = newTable;
			newTable = nil;
		end
	end
end

function ILW_DATA_MIXIN:UpdateFilteredList()
	wipe(self.filteredList);
	for k, unlock in ipairs(self.unlockedList) do
		if (self.quickFilters[unlock.type]() or unlock.subType == UNLOCK_SUBTYPE_UPCOMMING) then
			table.insert(self.filteredList, unlock);
		end
	end
end

function ILW_DATA_MIXIN:UpdateFilteredChart()
	wipe(self.filteredChart);
	for level, list in pairs(self.unlockTables) do
		for k, unlock in ipairs(list) do
			if (self.quickFilters[unlock.type]()) then
				if not self.filteredChart[level] then
					self.filteredChart[level]  = {};
				end
				table.insert(self.filteredChart[level], unlock);
			end
		end
	end
end

function ILW_DATA_MIXIN:ClearList()
	local list = self.unlockedList 
	for i = #list, 1, -1 do
		if list[i].subType ~= UNLOCK_SUBTYPE_UPCOMMING then
			table.remove(list, i);
		end
	end
	
	self.upcommingLevel = 0;
end

function ILW_DATA_MIXIN:LoadUnlocksForLevel(level)
	self:ClearUpcommingFromList();
	local newUnlocks = self.unlockTables[level or self.playerLevel];
	if newUnlocks then
		for k, unlock in ipairs(newUnlocks) do
		-- Skip if already on the list
		if (not self:AlreadyContainsUnlock(self.unlockedList, unlock)) then
			table.insert(self.unlockedList, unlock);
		end
		
		end
		self:UpdateFilteredList();
	end
end

function ILW_DATA_MIXIN:AddUnlocksOfLevel(level, list, ignoreSpec)
		
	local trackOptions = ILWAddon.db.global.trackers
	local spec = GetPlayerSpec();
	local addedNew = false;
	local unlocks;
	list = list or self.unlockedList;
	
	if (spec ~= nil) then
		ILWAddon.db.char.specLastLevel[spec] = level;
	end
	
	-- Check for skills
	unlocks = self.unlockData.skills[level]
	if (unlocks) then
		for k, unlock in ipairs(unlocks) do
			-- always show if not spec specific
			if unlock.specs == nil then
				self:AddUnlock(list, UNLOCKTYPE_SPELL, unlock, level, nil)
				addedNew = true;
			-- Otherwise, if you have a spec, check if it's the same as yours
			elseif spec ~= nil or ignoreSpec then
				for specKey, cSpec in ipairs(unlock.specs) do
					if ignoreSpec or cSpec == GetPlayerSpec() then
						self:AddUnlock(list, UNLOCKTYPE_SPELL, unlock, level, spec)
						addedNew = true;
						break; -- It's part of a spec, don't check the rest
					end
				end
			end
		end
	end
	
	-- Check for talents
	if (self.unlockData.talents[level]) then
		self:AddUnlock(list, UNLOCKTYPE_TALENT, nil, level);
		addedNew = true;
	end

	-- Check for riding skills
	unlocks = self.unlockData.riding[level]
	if (unlocks) then
		for k, unlock in ipairs(unlocks) do
			self:AddUnlock(list, UNLOCKTYPE_RIDING, unlock, level)
			addedNew = true;
		end
	end
	
	-- Check for UI
	unlocks = self.unlockData.UI[level]
	if (unlocks) then
		for k, unlock in ipairs(unlocks) do
			self:AddUnlock(list, UNLOCKTYPE_UI, unlock, level, unlock.func);
			addedNew = true;
		end
	end
	
	-- Check for zones
	unlocks = self.unlockData.zones[level]
	if (unlocks) then
		for k, unlock in ipairs(unlocks) do
			self:AddUnlock(list, UNLOCKTYPE_ZONES, unlock, level);
			addedNew = true;
		end
	end
	
	-- Check for dungeons
	unlocks = self.unlockData.instances[level]
	if (unlocks) then
		for k, unlock in ipairs(unlocks) do
			self:AddUnlock(list, (unlock.isRaid and UNLOCKTYPE_RAID or UNLOCKTYPE_DUNGEON), unlock, level);
			addedNew = true;
		end
	end
	
	-- Check for PvP
	unlocks = self.unlockData.PVP[level]
	if (unlocks) then
		for k, unlock in ipairs(unlocks) do
			self:AddUnlock(list, UNLOCKTYPE_PVP, unlock, level);
			addedNew = true;
		end
	end
	
	return addedNew;
end

function ILW_DATA_MIXIN:LoadUpcommingUnlocks()
	local level = self.playerLevel;
	if (level == self.upcommingLevel) then return; end
	self.upcommingLevel = level;
	local numUnlocks = 0;
	local unlockTable = nil;
	-- find the first next unlock
	while (level < MAXLEVEL and numUnlocks == 0) do
		level = level + 1;
		unlockTable = self.unlockTables[level];
		if unlockTable then
			numUnlocks = #self.unlockTables[level];
		end
	end
	
	if numUnlocks > 0 then
		-- wipe it, we want copies of these unlocks so we can change the subType without changing the origional
		wipe(self.upcomming)
		
		self:AddUnlocksOfLevel(level, self.upcomming);
		
		for k, unlock in ipairs(self.upcomming) do
			unlock.subType = UNLOCK_SUBTYPE_UPCOMMING;
			table.insert(self.unlockedList, unlock);
		end
	end
	
	self:UpdateFilteredList();
	
	return self.upcomming and #self.upcomming or 0, level;
end

function ILW_DATA_MIXIN:AddUnlock(list, typeID, unlock, level, extra)
	local id, icon, name, spec, subText, func;
	if unlock then
		id = unlock.id;
		icon = unlock.icon;
		name = unlock.name;
		subText = unlock.subText;
	end
	
	if (typeID == UNLOCKTYPE_SPELL or typeID == UNLOCKTYPE_RIDING) then
		local spellName, rank, spellIcon, castingTime, minRange, maxRange, spellID = GetSpellInfo(unlock.id);
		local isRank = rank:match("%d");
		local isPassive = IsPassiveSpell(unlock.id);
		subText = ""
		
		if typeID == UNLOCKTYPE_SPELL then
			if (isRank) then
				subText = rank .. ", ";
			end
			if (isPassive) then
				subText = subText .. SPELL_PASSIVE;
			end
			if subText == "" then
				subText = COMBATLOG_HIGHLIGHT_ABILITY;
			end
			if (unlock.subText) then
				subText = subText .. (subText == "" and "" or ", ") .. unlock.subText;
			end
		elseif typeID == UNLOCKTYPE_RIDING then
			subText = _L["REQUIRES TRAINING"];
		end
		name = spellName;
		icon = spellIcon;
		spec = extra;
		
	elseif (typeID == UNLOCKTYPE_TALENT) then
		icon = ICON_TALENT;
		name = _L["TALENT_POINT"];
		subText = TALENT;
	
	elseif (typeID == UNLOCKTYPE_UI) then
		icon = ICON_UI;
		func = extra
	elseif (typeID == UNLOCKTYPE_ZONES) then
		name = GetMapNameByID(unlock.id);
		subText = ZONE .. ", " .. GetMapNameByID(unlock.continentID);
	end
	
	table.insert(list, {["type"] = typeID, ["level"] = level, ["id"] = id, ["icon"] = icon, ["name"] = name ,["spec"] = spec, ["func"] = func, ["subText"] = subText});
	ILW_UnlockContainer:UpdateUnlockDisplay();
end

function ILW_DATA_MIXIN:AlreadyContainsUnlock(list, toCheck)
	for key, unlock in ipairs(list) do
		if (unlock.id == toCheck.id and unlock.type == toCheck.type) then
			return true;
		end
	end
	return false;
end

function ILW_DATA_MIXIN:CheckSpecMissedUnlocks(level, spec)

	self:ClearUpcommingFromList();
	
	if ILWAddon.db.global.trackers["Spells"] then
		local unlocks = self.unlockData.skills[level]
		if (not unlocks) then return; end
		
		for k, unlock in ipairs(unlocks) do
			if (unlock.specs) then
				local isForSpec = false;
				for specKey, cSpec in ipairs(unlock.specs) do
					if cSpec == GetPlayerSpec() then
						isForSpec = true;
						break;
					end
				end
				if (isForSpec) then
					self:AddUnlock(self.unlockedList, UNLOCKTYPE_SPELL, unlock, level, spec)
				end
			end
		end
	end
	
	
end

function ILW_DATA_MIXIN:ClearUpcommingFromList()
	for i = #self.unlockedList, 1, -1 do
		if (self.unlockedList[i].subType == UNLOCK_SUBTYPE_UPCOMMING) then
			table.remove(self.unlockedList, i);
		end
	end
end

function ILW_DATA_MIXIN:RemoveUnlock(data)
	local unlockItem;
	for i=1, #self.unlockedList do
		unlockItem = self.unlockedList[i];
		if (unlockItem.type == data.type and unlockItem.id == data.id) then
			table.remove(self.unlockedList, i);
			return;
		end
	end	
end

function ILW_DATA_MIXIN:SortUnlockedList()
	table.sort(self.unlockedList, function(a, b)
			if (a.level == b.level) then
				if (a.type == b.type) then
					return a.name < b.name;
				end
				return a.type < b.type;
			end
			return a.level < b.level;
		end
	);
	
	self:UpdateFilteredList();
end




ILW_UNLOCK_MIXIN = {};

-- When the player clicks on the icon of an unlock
function ILW_UNLOCK_MIXIN:OnClick(button)
	-- prevent 'checked' visualf
	self:SetChecked(false);

	if (self.data.subType == UNLOCK_SUBTYPE_UPCOMMING) then
		return;
	end
	
	-- find the clicked unlock and remove it from the list
	--local nr = string.match(self:GetName(), "(%d+)");
	--nr = nr + ((ILW_UnlockContainer.Navigation.CurrentPage - 1) * UNLOCKS_PER_PAGE);
	--table.remove(ILWAddon.db.char.unlockedList, nr);
	ILW_UnlockContainer.dataProvider:RemoveUnlock(self.data);
	
	-- Don't have to open anything if it's right mouse
	if (button == "RightButton") then
		
		ILW_UnlockContainer:UpdateUnlockDisplay();
		return;
	end
	-- Open spellbook if spell
	if (self.unlockType == UNLOCKTYPE_SPELL) then
		PickupSpell(self.unlockId);
	-- Open talents
	elseif (self.unlockType == UNLOCKTYPE_TALENT) then
		if (PlayerTalentFrame == nil) then
			LoadAddOn("Blizzard_TalentUI");
		end
		ShowUIPanel(PlayerTalentFrame);
	-- Open encounter journal if instance
	elseif (self.unlockType == UNLOCKTYPE_DUNGEON or self.unlockType == UNLOCKTYPE_RAID) then
		if (EncounterJournal == nil) then
			LoadAddOn("Blizzard_EncounterJournal");
		end
		ShowUIPanel(EncounterJournal);
		if (self.unlockId ~= nil) then
			
			-- id > 0 = specific instance so open journal to that instance
			-- otherwise see _aVar and open to instance list
			if (self.unlockId > 0) then
				-- actual instance so open journal to specific instance
				EncounterJournal_DisplayInstance(self.unlockId);
			elseif (self.unlockId == _aVar.CLASSIC_RAID) then
				EncounterJournal_TierDropDown_Select(_, 1)
				EJ_ContentTab_Select(3);
			elseif (self.unlockId == _aVar.TBC_HEROIC) then
				EncounterJournal_TierDropDown_Select(_, 2)
				EJ_ContentTab_Select(2);
			elseif (self.unlockId == _aVar.TBC_RAID) then
				EncounterJournal_TierDropDown_Select(_, 2)
				EJ_ContentTab_Select(3);
			elseif (self.unlockId == _aVar.WOTLK_HEROIC) then
				EncounterJournal_TierDropDown_Select(_, 3)
				EJ_ContentTab_Select(2);
			elseif (self.unlockId == _aVar.WOTLK_RAID) then
				EncounterJournal_TierDropDown_Select(_, 3)
				EJ_ContentTab_Select(3);
			elseif (self.unlockId == _aVar.CATA_HEROIC) then
				EncounterJournal_TierDropDown_Select(_, 4)
				EJ_ContentTab_Select(2);
			elseif (self.unlockId == _aVar.CATA_RAID) then
				EncounterJournal_TierDropDown_Select(_, 4)
				EJ_ContentTab_Select(3);
			elseif (self.unlockId == _aVar.MOP_HEROIC) then
				EncounterJournal_TierDropDown_Select(_, 5)
				EJ_ContentTab_Select(2);
			elseif (self.unlockId == _aVar.MOP_RAID) then
				EncounterJournal_TierDropDown_Select(_, 5)
				EJ_ContentTab_Select(3);
			elseif (self.unlockId == _aVar.WOD_HEROIC) then
				EncounterJournal_TierDropDown_Select(_, 6)
				EJ_ContentTab_Select(2);
			elseif (self.unlockId == _aVar.WOD_RAID) then
				EncounterJournal_TierDropDown_Select(_, 6)
				EJ_ContentTab_Select(3);
			elseif (self.unlockId == _aVar.LEGION_HEROIC) then
				EncounterJournal_TierDropDown_Select(_, 7)
				EJ_ContentTab_Select(2);
			elseif (self.unlockId == _aVar.LEGION_RAID) then
				EncounterJournal_TierDropDown_Select(_, 7)
				EJ_ContentTab_Select(3);
			end
		end
	elseif (self.unlockType == UNLOCKTYPE_PVP) then
		ShowUIPanel(PVEFrame);
		PVEFrame_ShowFrame("PVPUIFrame", "HonorFrame");
	elseif (self.unlockType == UNLOCKTYPE_UI) then
		if (self.data.func) then 
			self.data.func()
		end
	elseif (self.unlockType == UNLOCKTYPE_ZONES) then
		ShowUIPanel(WorldMapFrame);
		SetMapByID(self.data.id);
	end
	
	ILW_UnlockContainer:UpdateUnlockDisplay();
end

function ILW_UNLOCK_MIXIN:OnEnter(motion)
	-- hide the "New!" tag and mark as read to prevent animation
	self.NewText:SetText("");
	self.NewTextBG:Hide();
	self.data.read = true;
	
	-- show tooltip depending on type
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if (self.unlockType == UNLOCKTYPE_SPELL) then
		GameTooltip:SetSpellByID(self.unlockId);
	else
		GameTooltip:SetText(self.data.name, 1, 1, 1);
		if (self.unlockType == UNLOCKTYPE_RIDING) then
			GameTooltip:AddLine(_L["TOOLTIP_RIDING"]);
		elseif (self.unlockType == UNLOCKTYPE_TALENT) then
			GameTooltip:AddLine(_L["TOOLTIP_TALENT"]);
		elseif (self.unlockType == UNLOCKTYPE_DUNGEON or self.unlockType == UNLOCKTYPE_RAID) then
			GameTooltip:AddLine(_L["TOOLTIP_INSTANCE"]);
		elseif (self.unlockType == UNLOCKTYPE_PVP) then
			GameTooltip:AddLine(_L["TOOLTIP_PVP"]);
		elseif (self.unlockType == UNLOCKTYPE_UI) then
			GameTooltip:AddLine(_L["TOOLTIP_UI"]);
		elseif (self.unlockType == UNLOCKTYPE_ZONES) then
			GameTooltip:AddLine(_L["TOOLTIP_ZONE"]);
		end
	end
	GameTooltip:Show();
end

function ILW_UNLOCK_MIXIN:Reset()
	local name = self:GetName();
	local iconTexture = _G[name.."IconTexture"];
	self.animation:Stop();
	iconTexture:Hide();
	iconTexture:SetTexture("");
	self.Blocker:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT");
	self:SetAlpha(0);
	self.SpellName:SetText("");
	self.SpellName:SetHeight(self.SpellName:GetStringHeight());
	self.unlockType = nil;
	self.SpellSubName:SetText("");
	self.unlockId = nil;
	self.read = false;
	self.new = true;
	self.NewText:SetText("");
	self.NewTextBG:Hide();
	self.Level:Hide();
	self.DigitBg:Hide();
end

function ILW_UNLOCK_MIXIN:Update(unlock, showLevel)
	local name = self:GetName();
	local iconTexture = _G[name.."IconTexture"];
	self:SetAlpha(1);
	self.Blocker:SetPoint("BOTTOMRIGHT", self, "TOPLEFT");
	
	iconTexture:Show();
	iconTexture:SetTexture(unlock.icon);
	self.data = unlock;
	-- check if unlock has been read before.
	self.read = unlock.read;
	
	ShowUIPanel(self);
	
	self.SpellName:SetText(unlock.name);
	self.SpellName:Show();
	self.SpellName:SetHeight(self.SpellName:GetStringHeight());
	self.unlockType = unlock.type;
	self.unlockId = unlock.id;
	
	self.TypeIcon:SetTexCoord(0, 0, 0, 0);
	local coords = _typeIcons[self.unlockType];
	if coords then
		self.TypeIcon:SetTexCoord(coords.left, coords.right, coords.top, coords.bottom);
	end
	
	local subText = "";

	if (unlock.subText ~= nil) then
		subText = subText .. unlock.subText;
	end
	
	if (unlock.spec ~= nil) then
		local id, specName, description, icon, background, role, class = GetSpecializationInfoByID(unlock.spec);
		subText = subText ..", ".. specName;
	end
	
	self.SpellSubName:SetText(subText);
	self.SpellSubName:Show();
	self.SpellSubName:SetHeight(self.SpellSubName:GetStringHeight());
	
	-- Only show level for the first one
	if (showLevel) then
		self.DigitBg:Show();
		self.Level:Show();
		self.Level:SetText(unlock.level);
	end
	
	if (unlock.subType == UNLOCK_SUBTYPE_UPCOMMING) then
		iconTexture:SetDesaturated(true);
		self.SlotFrame:SetDesaturated(true);
		self.TypeIcon:SetDesaturated(true);
		self.Level:SetTextColor(0.7, 0.7, 0.7, 1);
		self.SpellName:SetTextColor(0.7, 0.7, 0.7, 1);
		self.DigitBg:SetVertexColor(1, 1, 1, 0.85);
		self.TextBackground:SetDesaturated(true);
		
	else
		iconTexture:SetDesaturated(false);
		self.SlotFrame:SetDesaturated(false);
		self.TypeIcon:SetDesaturated(false);
		self.Level:SetTextColor(1, 0.82, 0, 1);
		self.SpellName:SetTextColor(1, 0.82, 0, 1);
		self.DigitBg:SetVertexColor(1, 0.82, 0, 0.85);
		self.TextBackground:SetDesaturated(false);
		
		unlock.new = (unlock.new == nil and true or unlock.new );
		if (not self.read) then
		
			self.NewText:SetText(_L["NEW"]);
			if (self.NewText:GetWidth() > self:GetWidth()) then
				self.NewText:SetTextHeight(13);
			end
			self.NewTextBG:Show();
		end
		-- set unlock as read
		
		if unlock.new then
			self.animation:Play();
			unlock.new = false;
		end

	end
end




ILW_CORE_MIXIN = {}

function ILW_CORE_MIXIN:OnShow()
	HideUIPanel(ILW_AlertPopup);
	self:UpdateUnlockDisplay();
	PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN);
	
	-- Update chart
	ILW_Chart:SetToLevel();
end

function ILW_CORE_MIXIN:OnHide()
	HideUIPanel(ILW_HelpFrame);
	ILW_ShowHelpUnlocks(false);
	PlaySound(SOUNDKIT.IG_SPELLBOOK_CLOSE);
end

function ILW_CORE_MIXIN:OnLoad()

	self.dataProvider = CreateFromMixins(ILW_DATA_MIXIN);
	
	self:RegisterForDrag("LeftButton");
	self:SetScript("OnDragStart", self.StartMoving );
	self:SetScript("OnDragStop", self.StopMovingOrSizing);
	-- allows the player to close the frame using Esc like regular blizzard windows
	table.insert(UISpecialFrames, "ILW_UnlockContainer");
	UIPanelWindows["ILW_UnlockContainer"] = { area = "left", pushable = 4 };
	
	self.Navigation.CurrentPage = 1;
	
	for i=1, UNLOCKS_PER_PAGE do
		local button = _G["ILW_UnlockContainerUnlock"..i];
		button:RegisterForDrag("LeftButton");
		button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
		button.read = false;
	end
	
	SetPortraitToTexture(ILW_UnlockContainerPortrait, "Interface\\ICONS\\Spell_Holy_SurgeOfLight");
	ILW_UnlockContainerTitleText:SetText(_L["I Learned What?"])
	
	ButtonFrameTemplate_HideButtonBar(self);
	ButtonFrameTemplate_HideAttic(self);
end

function ILW_CORE_MIXIN:OnMouseWheel(delta)
	if delta == 1 then
		self.Navigation:PrevPageButton_OnClick();
	else
		self.Navigation:NextPageButton_OnClick();
	end
end

function ILW_CORE_MIXIN:ClearButton_OnClick()
	self.dataProvider:ClearList(); 
	self:UpdateUnlockDisplay();
end

function ILW_CORE_MIXIN:Open()
	ShowUIPanel(self);
end

function ILW_CORE_MIXIN:LevelUp(level, skipChartUpdate)
	self.dataProvider:LoadUnlocksForLevel(level);
	if (ILW_UnlockContainer:IsShown()) then
		self:UpdateUnlockDisplay();
		if (not skipChartUpdate) then
			ILW_Chart:SetToLevel(level);
		end
	else 
		if (newUnlocks) then
			ILW_AlertPopup:Present();
		end
	end
end

function ILW_CORE_MIXIN:ResetButtons()
	for i=1, UNLOCKS_PER_PAGE do
		local button = _G["ILW_UnlockContainerUnlock"..i];
		button:Reset();
	end
	
	self.Navigation:Update();
end

function ILW_CORE_MIXIN:UpdateUnlockDisplay()
	if (not self:IsShown()) then return; end
	
	self:ResetButtons();
	self.dataProvider:UpdateFilteredList();
	local unlockedList = self.dataProvider.filteredList;
	if (#unlockedList == 0) then
		self.dataProvider:LoadUpcommingUnlocks();
		self.dataProvider:UpdateFilteredList();
	end
	
	if (#unlockedList == 0) then
		self.NoNew:Show();
		self.Navigation:Update();
		return;
	else
		self.NoNew:Hide();
	end
	
	self.BannerText:SetText(_L["BANNER_UNLOCKED"]);
	-- If what we are currently showing are upcomming unlocks, change the title
	if (#unlockedList > 0 and unlockedList[1].subType == UNLOCK_SUBTYPE_UPCOMMING) then
		self.BannerText:SetText(_L["BANNER_NEXT"]);
	end
	
	local prevDisplayLevel = 0;
	local count = 1;
	local unlock = nil;
	local pageNr = self.Navigation.CurrentPage;
	local start = (pageNr-1) * UNLOCKS_PER_PAGE;
	local nrToShow = (#unlockedList-start) > UNLOCKS_PER_PAGE and UNLOCKS_PER_PAGE or #unlockedList-start;
	for i = start + 1, (start + nrToShow) do
		unlock = unlockedList[i];
		unlock.displayID = i;
			local button = _G["ILW_UnlockContainerUnlock"..count];
			button:Update(unlock, (unlock.level~=prevDisplayLevel));
			prevDisplayLevel = unlock.level;

		count = count +1;
	end

	self.Navigation:Update();
end

function ILW_CORE_MIXIN:SpecChanged()
	local spec = GetPlayerSpec();
	local level = UnitLevel("player");
	
	if (spec == nil) then return; end
	
	local lastLevel = ILWAddon.db.char.specLastLevel[spec];
	lastLevel = (lastLevel or 1);
	
	-- add spec specific unlocks since last time the spec was used
	for i = (lastLevel + 1), level do
		self.dataProvider:CheckSpecMissedUnlocks(i, spec);
	end
	
	-- sort unlocks by level to get new spec abilities in the right position
	table.sort(ILWAddon.db.char.unlockedList, function(a, b) return a.level < b.level end)

	ILWAddon.db.char.specLastLevel[spec] = level;
	
	-- Update unlock chart unlocks for new spec
	self.dataProvider:LoadUnlockTable();
	self.dataProvider:UpdateFilteredChart();
	self.Chart:Update();
	
	self.dataProvider:UpdateFilteredList();
	if (not self:IsShown()) then
		ILW_AlertPopup:Present();
	end
	
	self:UpdateUnlockDisplay();
end

function ILW_CORE_MIXIN:UpdateChartTooltip()
	local hightledBlock = self.Chart.hightledBlock;
	if (hightledBlock) == nil then return; end
	GameTooltip:SetOwner(hightledBlock, "ANCHOR_RIGHT");
	GameTooltip:SetText(UNIT_LEVEL_TEMPLATE:format(hightledBlock.blockLevel));
	
	if (not hightledBlock.unlocks) then return end;
	local lastType;
	local iconString = "";
	
	for k, unlock in ipairs(hightledBlock.unlocks) do
		if (unlock.type ~= lastType) then
		
			local texSize = 512;
			local texCoords = _typeIcons[unlock.type];
			local x1 = texCoords.left * texSize;
			local x2 = texCoords.right * texSize;
			local y1 = texCoords.top * texSize;
			local y2 = texCoords.bottom * texSize;
			
			iconString = "|TInterface\\MINIMAP\\ObjectIconsAtlas:0:0:0:0:"..texSize..":"..texSize..":"..x1..":"..x2..":"..y1..":"..y2..":|t ";
			lastType = unlock.type;
		end
		
		GameTooltip:AddLine(iconString .. unlock.name, 1, 1, 1);
	end
	GameTooltip:Show();
end

function ILW_CORE_MIXIN:TutorialButton_OnClick()
	if InCombatLockdown() then return; end
	if ILW_HelpFrame:IsShown() then
		_help:HideTutorial();
		ILW_ShowHelpUnlocks(false);
	else
		_help:ShowTutorial();
		ILW_ShowHelpUnlocks(true);
	end
end





ILW_NAVIGATION_MIXIN = {};

function ILW_NAVIGATION_MIXIN:PrevPageButton_OnClick()
	if (self.CurrentPage == 1) then return; end
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN);
	self.CurrentPage = self.CurrentPage - 1;
	self.Text:SetText(PAGE_NUMBER:format(self.CurrentPage));
	ILW_UnlockContainer:UpdateUnlockDisplay();
end

function ILW_NAVIGATION_MIXIN:NextPageButton_OnClick()
	if (self.CurrentPage >= ceil(#ILW_UnlockContainer.dataProvider.filteredList/UNLOCKS_PER_PAGE)) then return; end
	PlaySound(SOUNDKIT.IG_ABILITY_PAGE_TURN);
	self.CurrentPage = self.CurrentPage + 1;
	self.Text:SetText(PAGE_NUMBER:format(self.CurrentPage));
	ILW_UnlockContainer:UpdateUnlockDisplay();
end

function ILW_NAVIGATION_MIXIN:Update()
	local totalPages = ceil(#ILW_UnlockContainer.dataProvider.filteredList/UNLOCKS_PER_PAGE);

	if (totalPages > 0 and self.CurrentPage > totalPages) then
		self.CurrentPage = totalPages;
	elseif (totalPages == 0) then
		self.CurrentPage = 1;
	end

	self.Text:SetText(PAGE_NUMBER:format(self.CurrentPage));
	
	self.Prev:Enable();
	self.Next:Enable();

	-- disable prev on first page;
	if (self.CurrentPage == 1) then
		self.Prev:Disable();
	end

	-- disable next page if on last page
	if (totalPages == 0 or self.CurrentPage == totalPages) then
		self.Next:Disable();
	end
end





function ILWAddon:InitFilter(dd, level)
	local info = Lib_UIDropDownMenu_CreateInfo();
	info.keepShownOnClick = true;	

	if level == 1 then
		info.text = _L["OPTION_MINIMAP"];
		info.func = function(_, _, _, value)
						ILWAddon.db.global.minimap.hide = not value;
						if (ILWAddon.db.global.minimap.hide) then
							_icon:Hide(_addonName);
						else
							_icon:Show(_addonName);
						end
					end 
		info.checked = not ILWAddon.db.global.minimap.hide;
		info.isNotRadio = true;
		Lib_UIDropDownMenu_AddButton(info, level)

		info.text = _L["OPTION_POPUP"];
		info.func = function(_, _, _, value)
						ILWAddon.db.global.showPopup = value;
					end 
		info.checked = ILWAddon.db.global.showPopup;
		info.isNotRadio = true;
		Lib_UIDropDownMenu_AddButton(info, level)
	
		info.checked = 	nil;
		info.isNotRadio = nil;
		info.func =  nil;
		info.hasArrow = true;
		info.notCheckable = true;
		
		info.text = _L["OPTION_TRACKERS"];
		info.value = 1;
		Lib_UIDropDownMenu_AddButton(info, level)
	else --if level == 2 then
		
		info.hasArrow = false;
		info.isNotRadio = true;
		info.notCheckable = true;
			
		info.text = CHECK_ALL
		info.func = function()
						ILWAddon:SetAllSourcesTo(true);
						Lib_UIDropDownMenu_Refresh(dd, 1, 2);
						ILW_UnlockContainer.dataProvider:UpdateFilteredChart();
						ILW_UnlockContainer:UpdateUnlockDisplay();
						ILW_Chart:Update();
					end
		Lib_UIDropDownMenu_AddButton(info, level)
		
		info.text = UNCHECK_ALL
		info.func = function()
						ILWAddon:SetAllSourcesTo(false);
						Lib_UIDropDownMenu_Refresh(dd, 1, 2);
						ILW_UnlockContainer.dataProvider:UpdateFilteredChart();
						ILW_UnlockContainer:UpdateUnlockDisplay();
						ILW_Chart:Update();
					end
		Lib_UIDropDownMenu_AddButton(info, level)

		
		info.notCheckable = false;
		for k, v in pairs(_trackers) do
			info.text = _trackerLabels[k];
			info.func = function(_, _, _, value)
								ILWAddon.db.global.trackers[k] = value;
								ILW_UnlockContainer.dataProvider:UpdateFilteredChart();
								ILW_UnlockContainer:UpdateUnlockDisplay();
								ILW_Chart:Update();
							end
			info.checked = function() return ILWAddon.db.global.trackers[k] end;
			Lib_UIDropDownMenu_AddButton(info, level);			
		end
	end
end

function ILWAddon:SetAllSourcesTo(enable)
	for k, v in pairs(ILWAddon.db.global.trackers) do
		ILWAddon.db.global.trackers[k] = enable;
	end
end





ILW_POPUP_MIXIN = {};

function ILW_POPUP_MIXIN:OnShow()
	self.animLightUp:Play();
end

function ILW_POPUP_MIXIN:OnClick(button)
	if(button == "LeftButton") then
		ILW_UnlockContainer:Open();
	end
	HideUIPanel(self)
end

function ILW_POPUP_MIXIN:Present()
	local list = ILW_UnlockContainer.dataProvider.filteredList;
	if (#list > 0 and list[1].subType == UNLOCK_SUBTYPE_UPCOMMING) then return; end;
	if (ILW_UnlockContainer:IsShown() or #list == 0 or not ILWAddon.db.global.showPopup ) then return; end
	if (InCombatLockdown()) then
		self.shownDuringCombat = true;
		return;
	end
	self.text:SetText(_L["POPUP_FORMAT"]:format(#list));
	ShowUIPanel(self);
end





local NUM_CHART_BLOCKS = 15;

ILW_CHART_MIXIN = {}

function ILW_CHART_MIXIN:OnLoad()
	self:SetFrameLevel(ILW_UnlockContainer:GetFrameLevel()+3);
	
	local lastBlock = nil;
	for i=1, NUM_CHART_BLOCKS do
		local block = self:GetOrCreateBlock(i);
		if lastBlock then
			block:SetPoint("LEFT", lastBlock, "RIGHT", 0, 0);
		else
			block:SetPoint("TOPLEFT", self, "TOPLEFT", 3, -5);
		end
		lastBlock = block;
	end
	
	self.offset = 0;
	self.playerLevel = UnitLevel("player");
	self.playerSpec = GetPlayerSpec();
	
	local sliderWidth = ILW_Chart.Slider:GetWidth();
		local sliderButtonWidth = NUM_CHART_BLOCKS/(MAXLEVEL - MINLEVEL-1) * sliderWidth;
		if (sliderButtonWidth >= sliderWidth) then
			ILW_Chart.Slider.ThumbTexture:SetAlpha(0);
		end
		sliderButtonWidth = min(sliderButtonWidth, sliderWidth);
		ILW_Chart.Slider.ThumbTexture:SetWidth(sliderButtonWidth);
		
		self.setSliderSize = nil;
	
	self.setSliderSize = true;
end

function ILW_CHART_MIXIN:OnMouseWheel(delta)
	self.offset = self.offset + delta * -1;
	self.offset = max(self.offset, MINLEVEL-1);
	self.offset = min(self.offset, MAXLEVEL - NUM_CHART_BLOCKS);
	
	self:Update();
	ILW_UnlockContainer:UpdateChartTooltip();
end

function ILW_CHART_MIXIN:GetOrCreateBlock(index)
	local block = self.BlockArray and self.BlockArray[index];
	if block then
		block:Show();
		return block;
	end

	block = CreateFrame("FRAME", nil, self, "ILW_ChartBlock_Template");
	block.unlocks = {};
	block:SetWidth((432-6)/NUM_CHART_BLOCKS)

	return block;
end

function ILW_CHART_MIXIN:Update(fromSlider)
	if (not self.BlockArray) then return; end
	self.offset = max(self.offset, MINLEVEL-1);
	self.offset = min(self.offset, MAXLEVEL - NUM_CHART_BLOCKS);
	if (not fromSlider) then
		self.Slider:SetValue(self.offset);
		local minValue, maxValue = self.Slider:GetMinMaxValues();
	end
	
	for i=1, NUM_CHART_BLOCKS do
		local block = self.BlockArray[i];
		block.blockLevel = i + self.offset;
		block:Update();
	end
	
	self.Slider:UpdateProgress();
end

function ILW_CHART_MIXIN:SetToLevel(level)
	self.playerLevel = ILW_UnlockContainer.dataProvider.playerLevel;
	local minValue, maxValue = self.Slider:GetMinMaxValues();
	
	local value = self.playerLevel - 5;
	value = max(value, minValue);
	value = min(value, maxValue);
	self.offset = value;
	self:Update();
end




ILW_CHART_BLOCK_MIXIN = {}

function ILW_CHART_BLOCK_MIXIN:Update()
	local lightUp = self.blockLevel <= self:GetParent().playerLevel;
	self.Progress:SetAlpha(lightUp and 1 or 0);
	
	-- levels
	self.Level:SetText("");
	self.LevelFlag:SetAlpha(0);
	if (self.blockLevel % 5 == 0) then
		self.Level:SetText(self.blockLevel);
		self.LevelFlag:SetAlpha(1);
		self.Level:SetFontObject(lightUp and GameFontNormalSmall or ILW_GameFontLightGraySmall);
		if (lightUp) then
			self.LevelFlag:SetVertexColor(1, 0.82, 0);
		else
			self.LevelFlag:SetVertexColor(1, 1, 1);
		end
	end
	
	-- unlocks
	self.unlocks = ILW_UnlockContainer.dataProvider.filteredChart[self.blockLevel];
	
	self.Number:SetText("");
	self.NumberBG:SetAlpha(0);
	self.NumberBG2:SetAlpha(0);
	if (self.unlocks) then
		self.Number:SetText(#self.unlocks);
		self.NumberBG:SetAlpha(0.75);
		
		self.NumberBG2:SetDesaturated(not lightUp);
		self.NumberBG2:SetAlpha(1);
		-- if lightUp then
		-- self.NumberBG2:SetVertexColor(1, 0.82, 0, 1);
		-- else
		-- self.NumberBG2:SetVertexColor(0, 0, 0, 1);
		-- end
		self.Number:SetFontObject(lightUp and GameFontNormalSmall or ILW_GameFontLightGraySmall);
	end
	
end

function ILW_CHART_BLOCK_MIXIN:OnEnter()
	
	self.HighlightTop:SetAlpha(1);
	self.HighlightBottom:SetAlpha(1);
	
	self:GetParent().hightledBlock = self;
	
	ILW_UnlockContainer:UpdateChartTooltip();
end

function ILW_CHART_BLOCK_MIXIN:OnLeave()
	self:GetParent().hightledBlock = nil;
	GameTooltip:Hide();
	self.HighlightTop:SetAlpha(0);
	self.HighlightBottom:SetAlpha(0);
end

function ILW_CHART_BLOCK_MIXIN:OnMouseUp(button)
	if (button ~= "LeftButton" or  self.blockLevel > ILW_UnlockContainer.dataProvider.playerLevel or not self.unlocks or #self.unlocks == 0) then
		return;
	end
	ILW_UnlockContainer:LevelUp(self.blockLevel, true);
	ILW_UnlockContainer.dataProvider:SortUnlockedList();
	ILW_UnlockContainer:UpdateUnlockDisplay();
end



ILW_CHARTSLIDER_MIXIN = {}

function ILW_CHARTSLIDER_MIXIN:OnLoad()
	self:SetOrientation("HORIZONTAL")

	
	
	local maxValue = max(NUM_CHART_BLOCKS, MAXLEVEL - NUM_CHART_BLOCKS)
	local minValue = min(MINLEVEL-1, maxValue);
	self:SetMinMaxValues(minValue, maxValue);
	self:SetValueStep(1);
	self:SetValue(UnitLevel("player")-5);
end

function ILW_CHARTSLIDER_MIXIN:OnValueChanged(value, playerSet)
	local parent = self:GetParent();
	value = floor(value);
	if (not playerSet or value == parent.offset) then return; end

	ILW_Chart.offset = value;
	ILW_Chart:Update(true);
end

function ILW_CHARTSLIDER_MIXIN:UpdateProgress()
	
	--local minValue, maxValue = self.:GetMinMaxValues();
	
	local width = self:GetWidth();
	local progress = (UnitLevel("player") - MINLEVEL + 1) / (MAXLEVEL - MINLEVEL );
	self.Progress:SetWidth(progress * width)
end





function ILWAddon:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ILWDB", _defaults, true);
	_icon:Register(_addonName, ILWBroker, self.db.global.minimap);
	
	ILW_UnlockContainer.dataProvider:Initialize();
	if (not self.db.global.version) then
		wipe(ILW_UnlockContainer.dataProvider.unlockedList)
	end
	self.db.global.version = _version;
end

function ILWAddon:OnEnable()
	local spec = GetPlayerSpec();
	if (spec ~= nil) then
		self.db.char.specLastLevel[spec] = UnitLevel("player");
	end
	
	Lib_UIDropDownMenu_Initialize(ILW_UnlockContainerOptionsDropDown, function(self, level) ILWAddon:InitFilter(self, level) end, "MENU");
	
	-- Get official names for dungeons, battlegounds and worldPVP zones
	-- This has to be done here as some info (mainly BGs) is not available before the addon is done loading.
	-- Get names for official instances
	for level, instances in pairs(_addonData.unlockData.instances) do
		for k, instance in ipairs(instances) do
			if (instance.subText == _L["DUNGEON"]) then
				instance.name = EJ_GetInstanceInfo(instance.id);
			end
		end
	end
	
	-- Official names
	for level, unlocks in pairs(_addonData.unlockData.PVP) do
		for k, unlock in ipairs(unlocks) do
			if (unlock.subText == _L["BATTLEGROUND"]) then
				unlock.name = GetBattlegroundInfo(unlock.id);
			elseif (unlock.subText == _L["WORLD_PVP"]) then
				unlock.name = select(2, GetWorldPVPAreaInfo(unlock.id));
			end
		end
	end
	
	ILW_UnlockContainer.dataProvider:LoadUnlockTable();
	ILW_UnlockContainer.dataProvider:UpdateFilteredChart();
	
	
	
	-- Opening the frame once allows it to be used during combat. for some reason
	ShowUIPanel(ILW_UnlockContainer);
	HideUIPanel(ILW_UnlockContainer);
end

local L_ILWhat_LoadFrame = CreateFrame("FRAME", "ILWhat_LoadFrame"); 
ILWhat_LoadFrame:RegisterEvent("PLAYER_LEVEL_UP");
ILWhat_LoadFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
ILWhat_LoadFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
ILWhat_LoadFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
ILWhat_LoadFrame:RegisterEvent("ADDON_LOADED");
ILWhat_LoadFrame:RegisterEvent("PLAYER_LOGOUT");
ILWhat_LoadFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

function ILWhat_LoadFrame:PLAYER_LEVEL_UP(level, hp, mp, talentPoints, strength, agility, stamina, intellect, spirit)
	ILW_UnlockContainer.dataProvider.playerLevel = level;

	ILW_UnlockContainer:LevelUp(level);
end

function ILWhat_LoadFrame:PLAYER_REGEN_DISABLED()
	ILW_AlertPopup:Hide();
	HideUIPanel(ILW_UnlockContainer);
end

function ILWhat_LoadFrame:PLAYER_REGEN_ENABLED()
	if ILW_AlertPopup.shownDuringCombat then
		ILW_AlertPopup:Present();
		ILW_AlertPopup.shownDuringCombat = false;
	end
end

function ILWhat_LoadFrame:PLAYER_SPECIALIZATION_CHANGED(player)
	if(player == "player") then
		ILW_UnlockContainer:SpecChanged();
	end
end

function ILWhat_LoadFrame:PLAYER_LOGOUT(loadedAddon)
	ILW_ShowHelpUnlocks(false);
end

function ILWhat_LoadFrame:ADDON_LOADED(loadedAddon)
	if (loadedAddon ~= _addonName) then return; end
	
	ILWhat_LoadFrame:UnregisterEvent("ADDON_LOADED")
	
	_help:Initialize(ILW_UnlockContainer, _helpPlate);

end

----------------------------------------
-- Slash Commands
----------------------------------------

SLASH_ILEARNEDWHAT1 = '/ilwhat';
SLASH_ILEARNEDWHAT2 = '/ilearnedwhat';
SLASH_ILEARNEDWHAT3 = '/ilw';
local function slashcmd(msg, editbox)
--[[
	if msg then
		local start, stop = msg:match("(%d+) (%d+)");
		if not stop then
			stop = msg:match("%d+");
		end
		for i=(tonumber(start) or MINLEVEL), (tonumber(stop) or MAXLEVEL) do
			ILW_UnlockContainer:LevelUp(i);
		end
		return;
	end
	]]--

	if (ILW_UnlockContainer:IsShown()) then
		HideUIPanel(ILW_UnlockContainer);
	else--if(not InCombatLockdown()) then
		ILW_UnlockContainer:Open();
	end
end
SlashCmdList["ILEARNEDWHAT"] = slashcmd