local locales = {
	["enUS"] = {
		["Always display CD icons at full opacity (ReloadUI is needed)"] = "Always display CD icons at full opacity (ReloadUI is needed)",
		["Click on icon to enable/disable tracking"] = "Click on icon to enable/disable tracking",
		Copy = "Copy",
		["Copy other profile to current profile:"] = "Copy other profile to current profile:",
		["Current profile: [%s]"] = "Current profile: [%s]",
		["Data from '%s' has been successfully copied to '%s'"] = "Data from '%s' has been successfully copied to '%s'",
		Delete = "Delete",
		["Delete profile:"] = "Delete profile:",
		["Disable test mode"] = "Disable test mode",
		["Enable test mode (need at least one visible nameplate)"] = "Enable test mode (need at least one visible nameplate)",
		General = "General",
		["Icon size"] = "Icon size",
		["Icon X-coord offset"] = "Icon X-coord offset",
		["Icon Y-coord offset"] = "Icon Y-coord offset",
		MISC = "Misc",
		["New spell has been added: %s"] = "New spell has been added: %s",
		["Options are not available in combat!"] = "Options are not available in combat!",
		Profiles = "Profiles",
		["Profile '%s' has been successfully deleted"] = "Profile '%s' has been successfully deleted",
		["Show border around interrupts"] = "Show border around interrupts",
		["Show border around trinkets"] = "Show border around trinkets",
		["Unknown spell: %s"] = "Unknown spell: %s",
		["Value must be a number"] = "Value must be a number",
		["Font:"] = "Font:",
		["options:general:disable-addon-btn"] = "Disable addon",
		["options:general:enable-addon-btn"] = "Enable addon",
		["chat:addon-is-disabled-note"] = "Please note: this addon is disabled. You can enable it in options dialog (/nc)",
		["chat:addon-is-enabled"] = "Addon is enabled",
		["chat:addon-is-disabled"] = "Addon is disabled",
	},
	["zhCN"] = {
		["Always display CD icons at full opacity (ReloadUI is needed)"] = "始终以完全不透明显示在冷却的图标（需要重载界面）",
		["Click on icon to enable/disable tracking"] = "点击图标启用/禁用跟踪",
		["Copy"] = "复制",
		["Copy other profile to current profile:"] = "复制其他配置文件至当前配置文件：",
		["Current profile: [%s]"] = "当前配置文件：[%s]",
		["Data from '%s' has been successfully copied to '%s'"] = "从 '%s' 的数据已被成功复制到 '%s'",
		["Delete"] = "删除",
		["Delete profile:"] = "删除配置文件",
		["Disable test mode"] = "关闭测试模式",
		["Enable test mode (need at least one visible nameplate)"] = "启用测试模式（至少需要一个可见的姓名板）",
		["Font:"] = "字体：",
		["General"] = "综合",
		["Icon size"] = "图标大小",
		["Icon X-coord offset"] = "图标的X坐标偏移",
		["Icon Y-coord offset"] = "图标的Y坐标偏移",
		["MISC"] = "杂项",
		["New spell has been added: %s"] = "新的法术已添加：%s",
		["Options are not available in combat!"] = "选项在战斗中不可用！",
		["Profile '%s' has been successfully deleted"] = "配置文件 '%s' 已成功删除",
		["Profiles"] = "配置文件",
		["Show border around interrupts"] = "为打断技能显示边框",
		["Show border around trinkets"] = "为饰品显示边框",
		["Unknown spell: %s"] = "未知的法术：%s",
		["Value must be a number"] = "值必须是数字"
	},
	["zhTW"] = {
		["Always display CD icons at full opacity (ReloadUI is needed)"] = "圖示完全不透明 (需要重新載入介面)",
		["chat:addon-is-disabled"] = "插件已停用",
		["chat:addon-is-disabled-note"] = "請注意：這個插件已經停用，可以在設定選項 (/nc) 中啟用。",
		["chat:addon-is-enabled"] = "插件已啟用",
		["Click on icon to enable/disable tracking"] = "點一下圖示來啟用/停用監控",
		["Copy"] = "複製",
		["Copy other profile to current profile:"] = "複製現有的設定檔到目前設定檔:",
		["Current profile: [%s]"] = "目前設定檔: [%s]",
		["Data from '%s' has been successfully copied to '%s'"] = "已經成功地將資料從 '%s' 複製到 '%s'",
		["Delete"] = "刪除",
		["Delete profile:"] = "刪除設定檔:",
		["Disable test mode"] = "關閉測試模式",
		["Enable test mode (need at least one visible nameplate)"] = "開啟測試模式 (範圍內至少要能看見一個血條)",
		["Font:"] = "字體:",
		["General"] = "一般",
		["Icon size"] = "圖示大小",
		["Icon X-coord offset"] = "圖示水平位置",
		["Icon Y-coord offset"] = "圖示垂直位置",
		["MISC"] = "其他",
		["New spell has been added: %s"] = "已加入新的法術：%s",
		["Options are not available in combat!"] = "戰鬥中無法調整設定!",
		["options:general:disable-addon-btn"] = "停用插件",
		["options:general:enable-addon-btn"] = "啟用插件",
		["Profile '%s' has been successfully deleted"] = "已經成功地刪除設定檔 '%s'",
		["Profiles"] = "設定檔",
		["Show border around interrupts"] = "斷法技能顯示邊框",
		["Show border around trinkets"] = "飾品圖示顯示邊框",
		["Unknown spell: %s"] = "未知的法術：%s",
		["Value must be a number"] = "必須填寫數字",

		["Sort mode:"] = "排列順序:",
		["none"] = "無",
		["trinkets, then interrupts, then other spells"] = "飾品、斷法、其他法術",
		["interrupts, then trinkets, then other spells"] = "斷法、飾品、其他法術",
		["trinkets, then other spells"] = "飾品、其他法術",
		["interrupts, then other spells"] = "斷法、其他法術",
		["NameplateCooldowns"] = "PVP 血條技能監控",
	},
};

-- locales["koKR"] = locales["enUS"];
-- locales["zhCN"] = locales["enUS"];
-- locales["zhTW"] = locales["enUS"];

--			Test
--locales["ruRU"] = locales["zhTW"];

local localizedClasses = {};
FillLocalizedClassList(localizedClasses);
for _, localeTable in pairs(locales) do
	for classToken, localizedClassName in pairs(localizedClasses) do
		localeTable[classToken] = localizedClassName;
	end
end

local _, addonTable = ...;
addonTable.L = locales[GetLocale()];
addonTable.L = setmetatable(addonTable.L, {
	__index = function(t, key)
		return locales["enUS"][key];
	end
});
