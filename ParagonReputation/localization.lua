		------------------------------------------------
		-- Paragon Reputation 1.18 by Sev US-Drakkari --
		------------------------------------------------

		  --[[	  Special thanks to Ammako for
				  helping me with the vars and
				  the options.						]]--		

local L = ParagonReputation -- SetStrings
local LOCALE = GetLocale() -- GetClientLocale


-- Chinese (Simplified) (Thanks dxlmike)
if LOCALE == "zhCN" then 
	L["PARAGON"] = "巅峰"
	L["OPTIONDESC"] = "可以自定巅峰声望条的一些设定."
	L["TOASTDESC"] = "切换获得巅峰奖励时是否弹出通知."
	L["LABEL001"] = "声望条颜色"
	L["LABEL002"] = "文字格式"
	L["LABEL003"] = "弹出奖励通知"
	L["BLUE"] = "巅峰蓝"
	L["GREEN"] = "预设绿"
	L["YELLOW"] = "中立黄"
	L["ORANGE"] = "敌对橙"
	L["RED"] = "淡红"
	L["DEFICIT"] = "还需要多少声望"
	L["SOUND"] = "音效通知"
	L["ANCHOR"] = "锚点"

-- Chinese (Traditional) (Thanks gaspy10 & BNSSNB)
elseif LOCALE == "zhTW" then
	L["PARAGON"] = "巅峰"
	L["OPTIONDESC"] = "這些選項可讓你自訂巔峰聲望條的一些設定。"
	L["TOASTDESC"] = "切換獲得巔峰聲望獎勵時的彈出式通知。"
	L["LABEL001"] = "聲望條顏色"
	L["LABEL002"] = "文字格式"
	L["LABEL003"] = "彈出獎勵通知"
	L["BLUE"] = "巔峰藍"
	L["GREEN"] = "預設綠"
	L["YELLOW"] = "中立黃"
	L["ORANGE"] = "不友好橘"
	L["RED"] = "淡紅色"
	L["DEFICIT"] = "還需要多少聲望"
	L["SOUND"] = "音效通知"
	L["ANCHOR"] = "移動"
	L["RESET"] = "重設位置"
	L["Paragon Reputation"] = "聲望條"
	L["|cff0088eeParagon|r Reputation |cff0088eev"] = "|cff0088ee巔峰|r聲望條 |cff0088eev"

-- English (DEFAULT)
else
	L["PARAGON"] = "Paragon"
	L["OPTIONDESC"] = "This options allow you to customize some settings of Paragon Reputation."
	L["TOASTDESC"] = "Toggle a toast window that will warn you when you have a Paragon Reward."
	L["LABEL001"] = "Bars Color"
	L["LABEL002"] = "Text Format"
	L["LABEL003"] = "Reward Toast"
	L["BLUE"] = "Paragon Blue"
	L["GREEN"] = "Default Green"
	L["YELLOW"] = "Neutral Yellow"
	L["ORANGE"] = "Unfriendly Orange"
	L["RED"] = "Lightish Red"
	L["DEFICIT"] = "Reputation Deficit"
	L["SOUND"] = "Sound Warning"
	L["ANCHOR"] = "Toggle Anchor"
	L["Paragon Reputation"] = true
	L["|cff0088eeParagon|r Reputation |cff0088eev"] = true

end