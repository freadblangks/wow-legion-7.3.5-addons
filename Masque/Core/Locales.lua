--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Core\Locales.lua
	* Author.: StormFX

	[ Notes ]

	The contents of this file are automatically generated. Please use the localization application on WoWAce.com
	to submit translations. https://www.wowace.com/projects/masque/localization
]]

local _, Core = ...

-- Locales Table
local L = {}

-- Thanks, Tekkub/Rabbit.
Core.Locale = setmetatable(L, {
	__index = function(self, k)
		self[k] = k
		return k
	end
})

--[[ enUS/enGB: For reference only.
L["Addons"] = "Addons"
L["Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."] = "Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."
L["Adjust the skin of all buttons registered to %s: %s."] = "Adjust the skin of all buttons registered to %s: %s."
L["Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."] = "Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."
L["Backdrop Settings"] = "Backdrop Settings"
L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."] = "Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."
L["Checked"] = "Checked"
L["Click this button to load Masque's options. You can also use the %s or %s chat command."] = "Click this button to load Masque's options. You can also use the %s or %s chat command."
L["Click to open Masque's options window."] = "Click to open Masque's options window."
L["Color"] = "Color"
L["Colors"] = "Colors"
L["Cooldown"] = "Cooldown"
L["Debug Mode"] = "Debug Mode"
L["Disable the skinning of this group."] = "Disable the skinning of this group."
L["Disable"] = "Disable"
L["Disabled"] = "Disabled"
L["Enable the backdrop texture."] = "Enable the backdrop texture."
L["Enable the minimap icon."] = "Enable the minimap icon."
L["Enable"] = "Enable"
L["Equipped"] = "Equipped"
L["Flash"] = "Flash"
L["General"] = "General"
L["Global"] = "Global"
L["Gloss Settings"] = "Gloss Settings"
L["Highlight"] = "Highlight"
L["Load Masque Options"] = "Load Masque Options"
L["Loading Masque Options..."] = "Loading Masque Options..."
L["Masque debug mode disabled."] = "Masque debug mode disabled."
L["Masque debug mode enabled."] = "Masque debug mode enabled."
L["Masque is a dynamic button skinning add-on."] = "Masque is a dynamic button skinning add-on."
L["Minimap Icon"] = "Minimap Icon"
L["Normal"] = "Normal"
L["Opacity"] = "Opacity"
L["Profiles"] = "Profiles"
L["Pushed"] = "Pushed"
L["Reset Skin"] = "Reset Skin"
L["Reset all skin options to the defaults."] = "Reset all skin options to the defaults."
L["Set the color of the backdrop texture."] = "Set the color of the backdrop texture."
L["Set the color of the checked texture."] = "Set the color of the checked texture."
L["Set the color of the cooldown animation."] = "Set the color of the cooldown animation."
L["Set the color of the disabled texture."] = "Set the color of the disabled texture."
L["Set the color of the equipped item texture."] = "Set the color of the equipped item texture."
L["Set the color of the flash texture."] = "Set the color of the flash texture."
L["Set the color of the gloss texture."] = "Set the color of the gloss texture."
L["Set the color of the highlight texture."] = "Set the color of the highlight texture."
L["Set the color of the normal texture."] = "Set the color of the normal texture."
L["Set the color of the pushed texture."] = "Set the color of the pushed texture."
L["Set the intensity of the gloss color."] = "Set the intensity of the gloss color."
L["Set the skin for this group."] = "Set the skin for this group."
L["Skin"] = "Skin"
L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."] = "This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."
]]

do
	local LOC = GetLocale()
	if LOC == "zhCN" then
L["Addons"] = "插件"
L["Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."] = "将皮肤应用到所有已注册到%s的按钮上。这会覆盖所有群组的设定。"
L["Adjust the skin of all buttons registered to %s: %s."] = "将皮肤应用到所有已注册到%s：%s的按钮上。"
L["Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."] = "将皮肤应用到所有已注册的按钮上。这会覆盖所有插件的设定。"
L["Backdrop Settings"] = "背景设置"
L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."] = "无论何时 Masque 遇到了一个插件问题或者皮肤问题，都让其屏蔽 Lua 错误。"
L["Checked"] = "已选中"
L["Click this button to load Masque's options. You can also use the %s or %s chat command."] = "单击这个按钮来载入 Masque 的选项。你也可以使用%s或%s命令来实现。"
L["Click to open Masque's options window."] = "点击打开 Masque 选项窗口。"
L["Color"] = "颜色"
L["Colors"] = "颜色"
--Translation missing 
-- L["Cooldown"] = ""
L["Debug Mode"] = "调试模式"
L["Disable"] = "禁用"
L["Disable the skinning of this group."] = "禁用此群组换肤。"
L["Disabled"] = "已禁用"
L["Enable"] = "启用"
L["Enable the backdrop texture."] = "启用背景材质。"
L["Enable the minimap icon."] = "启用小地图图标。"
--Translation missing 
-- L["Equipped"] = ""
L["Flash"] = "闪光"
L["General"] = "一般"
L["Global"] = "全局"
L["Gloss Settings"] = "光泽设置"
L["Highlight"] = "高亮"
L["Load Masque Options"] = "载入 Masque 选项"
L["Loading Masque Options..."] = "Masque 选项载入中……"
L["Masque debug mode disabled."] = "Masque 调试模式禁用。"
L["Masque debug mode enabled."] = "Masque 调试模式启用。"
L["Masque is a dynamic button skinning add-on."] = "Masque 是一款模块化插件换肤引擎。"
L["Minimap Icon"] = "小地图图标"
L["Normal"] = "正常"
L["Opacity"] = "不透明度"
L["Profiles"] = "配置文件"
L["Pushed"] = "加粗"
L["Reset all skin options to the defaults."] = "重置所有皮肤选项为默认。"
L["Reset Skin"] = "重置皮肤"
L["Set the color of the backdrop texture."] = "设置背景材质颜色"
L["Set the color of the checked texture."] = "设置已选中材质颜色。"
--Translation missing 
-- L["Set the color of the cooldown animation."] = ""
L["Set the color of the disabled texture."] = "设置已禁用材质颜色。"
--Translation missing 
-- L["Set the color of the equipped item texture."] = ""
L["Set the color of the flash texture."] = "设置闪光材质颜色。"
L["Set the color of the gloss texture."] = "设置光泽材质颜色。"
L["Set the color of the highlight texture."] = "设置高亮材质颜色。"
L["Set the color of the normal texture."] = "设置一般材质颜色。"
L["Set the color of the pushed texture."] = "设置加粗材质颜色。"
L["Set the intensity of the gloss color."] = "设置光泽颜色亮度。"
L["Set the skin for this group."] = "为此群组设置皮肤。"
L["Skin"] = "皮肤"
L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."] = "这个部分将允许你将使用 Masque 注册的插件与插件群组的按钮进行换肤。"

-- ToC
L["A dynamic button skinning add-on."] = "一个动态按钮皮肤插件。"

	elseif LOC == "zhTW" then
L["Addons"] = "插件"
L["Adjust the skin of all buttons registered to %s. This will overwrite any per-group settings."] = "將所有按鈕的佈景主題套用到%s。這會覆蓋所有群組的設定。"
L["Adjust the skin of all buttons registered to %s: %s."] = "將所有按鈕的佈景主題套用到%s：%s。"
L["Adjust the skin of all registered buttons. This will overwrite any per-add-on settings."] = "將佈景主題套用到所有按鈕。這會覆蓋所有的插件設定。"
L["Backdrop Settings"] = "背景設定"
L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."] = "每當遭遇插件或是佈景問題都會讓按鈕外觀丟出Lua錯誤。"
L["Checked"] = "已勾選"
L["Click this button to load Masque's options. You can also use the %s or %s chat command."] = "點擊按鈕載入按鈕外觀的設定。你也可以使用%s或是%s聊天指令。"
L["Click to open Masque's options window."] = "點擊開啟按鈕外觀的設定視窗。"
L["Color"] = "顏色"
L["Colors"] = "顏色"
L["Cooldown"] = "冷卻中"
L["Debug Mode"] = "除錯模式"
L["Disable"] = "停用"
L["Disable the skinning of this group."] = "停用佈景主題套用在此群組。"
L["Disabled"] = "已停用"
L["Enable"] = "啟用"
L["Enable the backdrop texture."] = "啟用背景材質。"
L["Enable the minimap icon."] = "啟用小地圖圖示。"
L["Equipped"] = "已裝備"
L["Flash"] = "閃光"
L["General"] = "一般"
L["Global"] = "全部"
L["Gloss Settings"] = "光澤設定"
L["Highlight"] = "顯著標示"
L["Load Masque Options"] = "載入按鈕外觀設定"
L["Loading Masque Options..."] = "正在載入按鈕外觀設定..."
L["Masque debug mode disabled."] = "按鈕外觀除錯模式已停用。"
L["Masque debug mode enabled."] = "按鈕外觀除錯模式已啟用。"
L["Masque is a dynamic button skinning add-on."] = "按鈕外觀 Masque 為可動態變換按鈕佈景主題的插件。"
L["Minimap Icon"] = "小地圖圖示"
L["Normal"] = "一般"
L["Opacity"] = "不透明度"
L["Profiles"] = "設定檔"
L["Pushed"] = "按下"
L["Reset all skin options to the defaults."] = "重置所有佈景主題為預設值。"
L["Reset Skin"] = "重置佈景主題"
L["Set the color of the backdrop texture."] = "設定背景材質顏色。"
L["Set the color of the checked texture."] = "設定已勾選材質顏色。"
L["Set the color of the cooldown animation."] = "設定冷卻倒數動畫顏色。"
L["Set the color of the disabled texture."] = "設定已停用材質顏色。"
L["Set the color of the equipped item texture."] = "設定已裝備物品材質顏色。"
L["Set the color of the flash texture."] = "設定閃光材質顏色。"
L["Set the color of the gloss texture."] = "設定光澤材質顏色。"
L["Set the color of the highlight texture."] = "設定高亮材質顏色。"
L["Set the color of the normal texture."] = "設定一般材質顏色。"
L["Set the color of the pushed texture."] = "設定按下材質顏色。"
L["Set the intensity of the gloss color."] = "設定光澤顏色亮度。"
L["Set the skin for this group."] = "設定佈景主題套用在此群組。"
L["Skin"] = "佈景主題"
L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."] = "此區塊允許使用者將註冊在按鈕外觀 Masque 底下的插件按鈕套用佈景主題。"
L["Masque"] = "按鈕外觀"
-- ToC
L["A dynamic button skinning add-on."] = "動態套用按鈕佈景主題的插件。"

	end
end
