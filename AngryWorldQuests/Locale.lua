local ADDON, Addon = ...
local Locale = Addon:NewModule('Locale')

local default_locale = "enUS"
local current_locale

local langs = {}
langs.enUS = {
	UPGRADES = "Upgrades",
	config_showAtTop = "Display at the top of the Quest Log", 
	config_onlyCurrentZone = "Only show World Quests for the current zone", 
	config_showEverywhere = "Show World Quests on every map",
	config_hideFilteredPOI = "Hide filtered World Quest POI icons on the world map", 
	config_hideUntrackedPOI = "Hide untracked World Quest POI icons on the world map", 
	config_showHoveredPOI = "Always show hovered World Quest POI icon",
	config_showContinentPOI = "Show World Quest POI icons on the Broken Isles map",
	config_lootFilterUpgrades = "Show only upgrades for Loot filter",
	config_timeFilterDuration = "Time Remaining filter duration",
	config_enabledFilters = "Enabled Filters",
	config_sortMethod = "Sort World Quests by",
	config_sortMethod_1 = NAME,
	config_sortMethod_2 = CLOSES_IN,
	config_sortMethod_3 = ZONE,
	config_sortMethod_4 = FACTION,
	config_sortMethod_5 = REWARDS,
	config_characterConfig = "Per-character configuration",
	config_saveFilters = "Save active filters between logins",
	config_lootUpgradesLevel = "Loot filter shows upgrades",
	config_lootUpgradesLevelValue1 = "Higher ilvl only",
	config_lootUpgradesLevelValue2 = "Up to same ilvl",
	config_lootUpgradesLevelValue = "Up to %d ilvls less",
	CURRENT_ZONE = "Current Zone",
	addon_name = "Angry World Quests",
	addon_option_name = "Angry World Quests",
}

langs.zhCN = {
	UPGRADES = "可升级",
	config_showAtTop = "将任务列表置于任务日志顶部",
	config_onlyCurrentZone = "仅显示当前区域的任务列表",
	config_showEverywhere = "在所有的地图显示任务列表",
	config_hideFilteredPOI = "在世界地图上隐藏被过滤的任务",
	config_hideUntrackedPOI = "在世界地图上隐藏未被追踪的任务",
	config_showHoveredPOI = "总是显示鼠标悬停的世界任务",
	config_showContinentPOI = "在破碎群岛的地图上显示世界任务图标",
	config_lootFilterUpgrades = "在物品过滤里仅显示更高装等的物品任务",
	config_timeFilterDuration = "剩余时间过滤时长",
	config_enabledFilters = "启用过滤",
	config_sortMethod = "任务列表排序",
	config_sortMethod_1 = "名字",
	config_sortMethod_2 = "剩余时间",
	config_sortMethod_3 = "区域",
	config_sortMethod_4 = "声望",
	config_characterConfig = "为角色进行独立的配置",
	config_saveFilters = "自动保存最后选择的过滤",
	config_lootUpgradesLevel = "可升级物品装等过滤",
	config_lootUpgradesLevelValue1 = "仅显示更高装等",
	config_lootUpgradesLevelValue2 = "显示最高同等级",
	config_lootUpgradesLevelValue = "最多相差%d装等",
	CURRENT_ZONE = "当前区域",
}

langs.zhTW = {
	UPGRADES = "可升級",
	config_showAtTop = "顯示在任務記錄的最上方", 
	config_onlyCurrentZone = "只顯示目前區域的世界任務", 
	config_showEverywhere = "所有地圖都顯示世界任務清單",
	config_hideFilteredPOI = "隱藏世界地圖上被過濾掉的世界任務圖示", 
	config_hideUntrackedPOI = "隱藏世界地圖上沒有追蹤的世界任務圖示", 
	config_showHoveredPOI = "總是顯示滑鼠指向的世界任務圖示",
	config_showContinentPOI = "在破碎群島全區地圖上顯示世界任務圖示",
	config_lootFilterUpgrades = "戰利品過濾方式只顯示可提升裝等的任務",
	config_timeFilterDuration = "剩餘時間過濾掉超過",
	config_enabledFilters = "啟用的過濾方式",
	config_sortMethod = "世界任務排序方式",
	config_sortMethod_1 = NAME,
	config_sortMethod_2 = CLOSES_IN,
	config_sortMethod_3 = ZONE,
	config_sortMethod_4 = FACTION,
	config_sortMethod_5 = REWARDS,
	config_characterConfig = "角色專用的設定",
	config_saveFilters = "儲存啟用的過濾方式供每次登入使用",
	config_lootUpgradesLevel = "戰利品過濾顯示",
	config_lootUpgradesLevelValue1 = "只有更高的物品等級",
	config_lootUpgradesLevelValue2 = "相同或更高的物品等級",
	config_lootUpgradesLevelValue = "最多低 %d 物品等級",
	CURRENT_ZONE = "目前區域",
	addon_name = "世界任務清單",
	addon_option_name = "任務-世界任務",
}

function Locale:Get(key)
	if langs[current_locale] and langs[current_locale][key] ~= nil then
		return langs[current_locale][key]
	else
		return langs[default_locale][key]
	end
end

function Locale:Exists(key)
	return langs[default_locale][key] ~= nil
end

setmetatable(Locale, {__index = Locale.Get})

current_locale = GetLocale()
