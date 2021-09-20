-- 
-- options.lua
-- 
-- Contains options setup and management
--


local addonName, addonTable = ...

-- Cached globals
local format = format;
local wipe = wipe;

-- Non-cached globals (for mikk's FindGlobals script)
-- GLOBALS: LibStub, InterfaceOptionsFrame_OpenToCategory

-- Set up module
local addon = addonTable[1];
local options = addon:NewModule("options");
addon.options = options;


addon.dbDefaults.realm.options = {
	purgeEnabled = false,
	purgeMaxParseAge = 30,
	purgeMinPlayerParsesPerFight = 2,
}

local optionsTable;
local function createOptionsTable()
	optionsTable = {
		name = "Skada 戰鬥統計 公會排名",
		handler = options,
		get = "GetRealmOptionValue",
		set = "SetRealmOptionValue",
		type = 'group',
		args = {
			versionHeader = {
				order = 1,
				type = "header",
				name = format("版本：%s", addon.versionName),
				width = "Full",
			},
			generalSettings = {
				name = "一般",
				type = "group",
				inline = true,
				order = 5,
				args = {
					ShowMinimapIcon = {
						name = "小地圖按鈕",
						desc = "切換小地圖按鈕。",
						type = "toggle",
						width = "full",
						order = 10,
						get = function()
							return addon.ldb:IsMinimapIconShown();
						end,
						set = function(info, v)
							addon.ldb:SetMinimapIconShown(v);
						end,
					},
				},
			},
			actions = {
				name = "動作",
				type = "group",
				inline = true,
				order = 10,
				args = {
					RemoveParses = {
						order = 10,
						type = 'execute',
						name = '刪除所有資料',
						desc = '刪除所有已儲存的資料。',
						confirm = function()
							return '是否確定要刪除所有已儲存的資料?'
								.. ' 這個動作將無法還原!';
						end,
						func = function()
							wipe(addon.highscore:GetDB());
							addon:SetupDatabase();
							addon:Print("所有已儲存的資料都已刪除。");
						end,
					},
				},
			},
			purgeSettings = {
				name = "清理設定",
				type = "group",
				inline = true,
				order = 20,
				args = {
					purgeEnabled = {
						order = 1,
						type = "toggle",
						name = "啟用資料清理",
						desc = "清理符合指定條件的資料。",
					},
					purgeMaxParseAge = {
						order = 3,
						type = "range",
						min = 0,
						max = 60,
						step = 1,
						name = "最長保存時間 (天)",
						desc = "資料最多保留的天數。",
						disabled = function() return not addon.db.realm.options.purgeEnabled; end,
					},
					purgeMinPlayerParsesPerFight = {
						order = 5,
						type = "range",
						min = 0,
						softMax = 20,
						max = 100,
						step = 1,
						name = "每位玩家/戰鬥至少保存",
						desc = "指定玩家或戰鬥最少保存的資料數量，就算超過天數也不會被刪除。",
						disabled = function() return not addon.db.realm.options.purgeEnabled; end,
					}
				},
			},
			creditsSeparator = {
				name = "",
				order = -1,
				type = "header",
				width = "Full",
			},
			credits = {
				name = "特別感謝",
				order = -1,
				type = "group",
				inline = true,
				args = {
					text = {
						order = 1,
						type = "description",
						name = "十分感謝 Zalk 幫忙測試這個插件!",
					},
				},
			},
		},
	};
end

function options.GetRealmOptionValue(self, info)
	local key = info[#info];
	return addon.db.realm.options[key];
end

function options.SetRealmOptionValue(self, info, value)
	local key = info[#info];
	addon.db.realm.options[key] = value;
end

function options:GetOptionsTable()
	if not optionsTable then
		createOptionsTable()
	end
	return optionsTable
end

function options:ShowOptionsFrame()
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame);
end

--
-- Helper Methods for accessing db option properties
--

function options:GetPurgeEnabled()
	return addon.db.realm.options["purgeEnabled"];
end

function options:GetPurgeMaxParseAge()
	return addon.db.realm.options["purgeMaxParseAge"];
end

function options:GetPurgeMinPlayerParsesPerFight()
	return addon.db.realm.options["purgeMinPlayerParsesPerFight"];
end

function options:OnEnable()
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(addonName, options.GetOptionsTable);
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "戰鬥-公會排名");
end
