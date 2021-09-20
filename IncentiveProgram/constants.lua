-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

--Core
IncentiveProgram.VERSION_NUMBER = GetAddOnMetadata(addonName, "Version") 
IncentiveProgram.ADDON_DISPLAY_NAME = "隨機獎勵通知"

IncentiveProgram.Flair = {
    [849] = "HM1 - ",
    [850] = "HM2 - ",
    [851] = "HM3 - ",
    [847] = "BRF1 - ",
    [846] = "BRF2 - ",
    [848] = "BRF3 - ",
    [823] = "BRF4 - ",
    [982] = "HC1 - ",
    [983] = "HC2 - ",
    [984] = "HC3 - ",
    [985] = "HC4 - ",
    [986] = "HC5 - ",
    [1287] = "EN1 - ",
    [1288] = "EN2 - ",
    [1289] = "EN3 - ",
	[1411] = "TV1 - ",
    [1290] = "NH1 - ",
    [1291] = "NH2 - ",
    [1292] = "NH3 - ",
    [1293] = "NH4 - ",
	[1494] = "TS1 - ",
	[1495] = "TS2 - ",
	[1496] = "TS3 - ",
	[1497] = "TS4 - "
    
}

--Icon File Paths
IncentiveProgram.Icons = {
    ["INCENTIVE_NONE"] = "Interface\\ICONS\\Ability_Malkorok_BlightofYshaarj_Red",
    ["INCENTIVE_RARE"] = "Interface\\Icons\\INV_Misc_Coin_17",
    ["INCENTIVE_UNCOMMON"] = "Interface\\Icons\\INV_Misc_Coin_18",
    ["INCENTIVE_PLENTIFUL"] = "Interface\\Icons\\INV_Misc_Coin_19",
    ----------------------
    ["CONTEXT_MENU_DIVIDER"] = "Interface\\Common\\UI-TooltipDivider-Transparent",
    ["CONTEXT_MENU_RED_X"] = "Interface\\Common\\VOICECHAT-MUTED"
  }
  
--Settings
IncentiveProgram.Settings = {
    QA_TANK = "queueAsTank",
    QA_HEALER = "queueAsHealer",
    QA_DAMAGE = "queueAsDamage",
    IGNORE = "ignore",
    DUNGEON_NAME = "dungeonName",
    DUNGEON_TYPE = "dungeonType",
    HIDE_IN_PARTY = "hideInParty",
    HIDE_ALWAYS = "hideAlways", --still shows in databroker
	HIDE_EMPTY = "hideEmpty",
    ALERT = "alert",
    ALERT_TOAST = "toastAlert",
    COUNT_EVEN_IF_NOT_SELECTED = "countEvenIfNotSelected",
    COUNT_EVEN_IF_NOT_ROLE_ELIGIBLE = "countEvenIfNotRoleEligible",
	IGNORE_COMPLETED_LFR = "ignoreCompletedLFR",
    
    ROLE_TANK = "roleTank",
    ROLE_HEALER = "roleHealer",
    ROLE_DAMAGE = "roleDamage",
    
    FRAME_TOP = "frameTop",
    FRAME_LEFT = "frameLeft",
    TOAST_TOP = "toastTop",
    TOAST_LEFT = "toastLeft",
	
	ALERT_PING = "alertPing",
	ALERT_SOUND = "alertSound",
	ALERT_REPEATS = "alertRepeats",
	TOAST_PING = "toastPing",
	TOAST_SOUND = "toastSound",
	TOAST_REPEATS = "toastRepeats",
	CYCLE_COUNT = "cycleCount",
	CONTINUOUSLY_CYCLE = "continuouslyCycle",
	CHANNEL = "channel",
	CHANNEL_SFX = "SFX",
	CHANNEL_MUSIC = "MUSIC",
	CHANNEL_AMBIENT = "AMBIENT",
	CHANNEL_MASTER = "MASTER"
}

IncentiveProgram.TickRate  = 20
IncentiveProgram.SoundRate = 1
IncentiveProgram.CycleRate = 1.5

IncentiveProgram.ALERT = 1
IncentiveProgram.TOAST = 2

--Dungeon Constants
IncentiveProgram.DUNGEON_REMOVED = 1
IncentiveProgram.DUNGEON_ADDED = 2
IncentiveProgram.DUNGEON_DIFFERENCE = 3

IncentiveProgram.TOAST_TANK = "\124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:0:19:22:41\124t 坦克"
IncentiveProgram.TOAST_HEALER = "\124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:1:20\124t 治療者"
IncentiveProgram.TOAST_DAMAGE = "\124TInterface\\LFGFRAME\\UI-LFG-ICON-PORTRAITROLES:20:20:0:0:64:64:20:39:22:41\124t 傷害輸出"


--Context Menu
IncentiveProgram.ContextMenu = {
    TANK = 2,
    HEALER = 3,
    DAMAGE = 4,
    
    ROLES = "roles",
    IGNORE = "ignore",
    SETTINGS = "settings",
    
    QUEUE = "queue",
    JOIN = "join",
	
	INTERFACE_PANEL = "interfacePanel"
}

IncentiveProgram.ContextLabels = {
    ROLES = "角色",
    TANK = "坦克",
    HEALER = "治療者",
    DAMAGE = "傷害輸出",
    
    IGNORED = "忽略",
    NO_IGNORED = "沒有忽略的副本",
    
    SETTINGS = "設定",
    HIDE_IN_PARTY = "有隊伍時隱藏",
    HIDE_ALWAYS = "總是隱藏",
	HIDE_EMPTY = "沒有獎勵時隱藏",
    ALERT = "新獎勵時通知",
    ALERT_TOAST = "使用彈出式面板通知",
	IGNORE_COMPLETED_LFR = "忽略已完成的隨機團隊",
	INTERFACE_PANEL = "設定通知音效",
    
    IGNORE = "忽略",
    UNIGNORE = "取消忽略",
    
    JOIN_QUEUE = "加入隨機隊伍",
	
	TOOLTIP_IGNORE_LFR = "已經擊殺過的隨機團隊首領將不再顯示通知和計數，但是左鍵點擊時的選單仍會顯示。",
	TOOLTIP_HIDE_ALWAYS = "總是隱藏這個框架。適用於 Data Brokers 插件，輸入 /ip 取消隱藏。",
	
	TOOLTIP_SOUND_ID_1 = "音效ID輸入 1069 是 PPAP，輸入 5487 是 好吃的蘋果派。\n\n造訪 http://www.wowhead.com/sounds 可以找到更多音效ID。找到喜愛的音效時，ID 會顯示在網址列 (例如 http://www.wowhead.com/sound=47615/ui-groupfinderreceiveapplication)",
	TOOLTIP_SOUND_ID_2 = "音效ID輸入 1069 是 PPAP，輸入 5487 是 好吃的蘋果派。\n\n造訪 http://www.wowhead.com/sounds 可以找到更多音效ID。找到喜愛的音效時，ID 會顯示在網址列 (例如 http://www.wowhead.com/sound=18019/ui-bnettoast)",
	TOOLTIP_SOUND_REPEATS = "音效播放的次數。",
	TOOLTIP_CYCLE_COUNT = "有新的通知時，三種顏色的錢幣圖示循環顯示的次數。",
	TOOLTIP_CONTINUOUSLY_CYCLE = "有新的通知時，錢幣圖示會不停的循環顯示。",
	
	SOUNDS = "音效",
	SOUND_ID = "音效ID",
	REPEATS = "播放次數",
	ALERT_PING = "通知時",
	TOAST_PING = "彈出時",
	TEST = "測試",
	
	ANIM_CYCLES = "圖示",
	CONTINUOUSLY_CYCLE = "持續閃爍",
	
	RESET_POSITION = "重設位置",
}