local L = LibStub("AceLocale-3.0"):NewLocale("Spy", "zhTW")
if not L then return end
-- TOC Note: "偵測並警告你附近有敵方玩家出沒。"

-- Addon information
L["Spy"] = "偵測敵方玩家 Spy"
L["Version"] = "版本"
L["LoadDescription"] = "|cff9933ff偵測敵方玩家插件已載入，輸入 |cffffffff/spy|cff9933ff 查看更多指令選項。"
L["SpyEnabled"] = "|cff9933ff偵測敵方玩家插件已啟用。"
L["SpyDisabled"] = "|cff9933ff偵測敵方玩家插件已停用，輸入 |cffffffff/spy enable|cff9933ff 來啟用。"
L["UpgradeAvailable"] = "|cff9933ff偵測敵方玩家插件已有新版本，可以到這裡下載：\n|cffffffffhttps://mods.curse.com/addons/wow/spy"

-- Configuration frame name
L["Spy Option"] = "PVP 偵測敵方玩家"

-- Configuration strings
L["Profiles"] = "設定檔"

L["GeneralSettings"] = "一般設定"
L["SpyDescription1"] = [[
Spy 是一個可以警告你附近有敵方玩家出沒的插件。
]]
L["SpyDescription2"] = [[

|cffffd000附近清單|cffffffff
附近清單會顯示已經被偵測到在附近的任何敵方玩家。點一下清單中的名字可以將玩家選取為目標，但是只能在非戰鬥中使用。一段時間後沒有偵測到的玩家會從清單中自動移除。

標題列的清空按鈕可以立即清空清單，按住 CTRL 鍵來清空可以快速啟用/停用 Spy。

|cffffd000最近清單|cffffffff
最近清單會顯示最近一小時內偵測到的所有敵方玩家。

|cffffd000忽略清單|cffffffff
Spy 不會顯示被加入到忽略清單中的玩家。透過滑鼠右鍵選單，或是按住 CTRL 鍵點擊名字將玩家加入清單和移除。

|cffffd000即殺清單|cffffffff
偵測到在即殺清單清單中的玩家時會發出警告。透過滑鼠右鍵選單，或是按住 SHIFT 鍵點擊名字將玩家加入清單和移除。

滑鼠右鍵選單也可以設定將某人加入到即殺清單的原因。如果你想要輸入不在清單中的原因，請在其他清單中使用 "自行輸入原因..."。


|cffffd000Author: http://www.curse.com/users/slipjack|cffffffff

]]
L["EnableSpy"] = "啟用"
L["EnableSpyDescription"] = "現在和登入時都要啟用 Spy。"
L["EnabledInBattlegrounds"] = "戰場中啟用"
L["EnabledInBattlegroundsDescription"] = "身處在戰場中時啟用或停用 Spy。"
L["EnabledInArenas"] = "競技場中啟用"
L["EnabledInArenasDescription"] = "身處在競技場中時啟用或停用 Spy。"
L["EnabledInWintergrasp"] = "世界戰鬥區域中啟用"
L["EnabledInWintergraspDescription"] = "身處在世界戰鬥區中時啟用或停用 Spy，例如北裂境的冬握湖。"
L["DisableWhenPVPUnflagged"] = "非 PVP 狀態時停用"
L["DisableWhenPVPUnflaggedDescription"] = "依據自身的 PVP 狀態啟用或停用 Spy。"

L["DisplayOptions"] = "顯示"
L["DisplayOptionsDescription"] = [[
自動顯示或隱藏 Spy。
]]
L["ShowOnDetection"] = "偵測到敵方玩家時顯示"
L["ShowOnDetectionDescription"] = "偵測到敵方玩家時會自動將隱藏的 Spy 視窗和附近清單顯示出來。"
L["HideSpy"] = "沒有偵測到敵方玩家時隱藏"
L["HideSpyDescription"] = "附近清單內容是空的時候會自動隱藏。手動清空清單時不會隱藏 Spy。"
L["LockSpy"] = "鎖定視窗"
L["LockSpyDescription"] = "鎖定 Spy 視窗讓它不能被移動。"
L["InvertSpy"] = "翻轉視窗"
L["InvertSpyDescription"] = "上下翻轉 Spy 視窗。"
L["ResizeSpy"] = "自動調整視窗大小"
L["ResizeSpyDescription"] = "新增和移除敵方玩家時自動調整 Spy 視窗的大小。"
L["TooltipDisplayWinLoss"] = "滑鼠提示中顯示勝/敗統計"
L["TooltipDisplayWinLossDescription"] = "在玩家的滑鼠提示中顯示該玩家的勝/敗統計資訊。"
L["TooltipDisplayKOSReason"] = "滑鼠提示中顯示即殺原因"
L["TooltipDisplayKOSReasonDescription"] = "在玩家的滑鼠提示中顯示該玩家被加入到即殺清單中的原因。"
L["TooltipDisplayLastSeen"] = "滑鼠提示中顯示上次遇到的詳情"
L["TooltipDisplayLastSeenDescription"] = "在玩家的滑鼠提示中顯示最近一次遇到該玩家的時間和地點。"
L["SelectFont"] = "選擇字體"
L["SelectFontDescription"] = "選擇 Spy 視窗使用的字體。"
L["RowHeight"] = "選擇列高"
L["RowHeightDescription"] = "選擇 Spy 視窗橫列的高度。"

L["AlertOptions"] = "警告"
L["AlertOptionsDescription"] = [[
遇到時可以將詳情通報到聊天頻道，並且控制偵測到敵方玩家時 Spy 該如何發出警告。
]]
L["Announce"] = "通報到:"
L["None"] = "無"
L["NoneDescription"] = "偵測到敵方玩家時不要通報。"
L["Self"] = "自己"
L["SelfDescription"] = "偵測到敵方玩家時通知自己。"
L["Party"] = "隊伍"
L["PartyDescription"] = "偵測到敵方玩家時通報到你的隊伍。"
L["Guild"] = "公會"
L["GuildDescription"] = "偵測到敵方玩家時通報到你的公會。"
L["Raid"] = "團隊"
L["RaidDescription"] = "偵測到敵方玩家時通報到你的團隊。"
L["LocalDefense"] = "本地防務"
L["LocalDefenseDescription"] = "偵測到敵方玩家時通報到本地防務頻道。"
L["OnlyAnnounceKoS"] = "只通報即殺的敵方玩家"
L["OnlyAnnounceKoSDescription"] = "設定為只通報在即殺清單中的敵方玩家。"
L["WarnOnStealth"] = "隱形偵測警告"
L["WarnOnStealthDescription"] = "敵方玩家獲得隱形時顯示警告和音效。"
L["WarnOnKOS"] = "即殺偵測警告"
L["WarnOnKOSDescription"] = "偵測到在即殺清單中的敵方玩家時顯示警告和音效。"
L["WarnOnKOSGuild"] = "公會即殺偵測警告"
L["WarnOnKOSGuildDescription"] = "偵測到和即殺清單中有相同公會的敵方玩家時顯示警告和音效。"
L["WarnOnRace"] = "種族偵測警告"
L["WarnOnRaceDescription"] = "偵測到指定的種族時發出音效警告。"
L["SelectWarnRace"] = "選擇要偵測的種族"
L["SelectWarnRaceDescription"] = "選擇要發出警告音效的種族。"
L["WarnRaceNote"] = "注意: 至少需要將敵人選取為目標一次 (點 Spy 視窗中的玩家名字) 他的種族才會加入到資料庫中，下次偵測到時便可以發出警告音效。和偵測附近敵人一樣，戰鬥中無法點選。"
L["DisplayWarningsInErrorsFrame"] = "在錯誤訊息框架顯示警告"
L["DisplayWarningsInErrorsFrameDescription"] = "使用錯誤訊息框架來顯示警告，而不是使用圖形介面的彈出視窗。"
L["EnableSound"] = "啟用警告音效"
L["EnableSoundDescription"] = "偵測到敵方玩家時啟用警告音效，隱形和即殺清單中的敵方玩家會發出不同的警告音效。"
L["OnlySoundKoS"] = "只有即殺清單使用警告音效"
L["OnlySoundKoSDescription"] = "只有偵測到即殺清單中的敵方玩家時才播放警告音效。"

L["ListOptions"] = "附近清單"
L["ListOptionsDescription"] = [[
設定 Spy 該如何將敵方玩家加入附近清單和移除。
]]
L["RemoveUndetected"] = "多久後從附近清單中移除敵方玩家:"
L["1Min"] = "1 分鐘"
L["1MinDescription"] = "移除超過 1 分鐘未偵測到的敵方玩家。"
L["2Min"] = "2 分鐘"
L["2MinDescription"] = "移除超過 2 分鐘未偵測到的敵方玩家。"
L["5Min"] = "5 分鐘"
L["5MinDescription"] = "移除超過 5 分鐘未偵測到的敵方玩家。"
L["10Min"] = "10 分鐘"
L["10MinDescription"] = "移除超過 10 分鐘未偵測到的敵方玩家。"
L["15Min"] = "15 分鐘"
L["15MinDescription"] = "移除超過 15 分鐘未偵測到的敵方玩家。"
L["Never"] = "永不移除"
L["NeverDescription"] = "永遠不要移除敵方玩家，仍然可以使用手動的方式清除附近清單。"
L["ShowNearbyList"] = "偵測到敵方玩家時自動切換到附近清單"
L["ShowNearbyListDescription"] = "偵測到敵方玩家時顯示附近清單，如果原本沒有顯示的話。"
L["PrioritiseKoS"] = "附近清單中優先排序即殺的敵方玩家"
L["PrioritiseKoSDescription"] = "在附近清單中總是將即殺的敵方玩家顯示在最前面。"

L["MinimapOptions"] = "地圖"
L["MinimapOptionsDescription"] = [[
提供額外的功能給能夠從小地圖追蹤人形生物的玩家。

能夠追蹤人形生物的玩家包括獵人、德魯伊，或是透過其他方式獲得這個能力，像是吃焦黑的座狼排。
]]
L["MinimapTracking"] = "啟用小地圖追蹤"
L["MinimapTrackingDescription"] = "啟用小地圖追蹤和偵測，在小地圖偵測到的已知敵方玩家會加入到附近清單。"
L["MinimapDetails"] = "滑鼠提示中顯示等級/職業細節"
L["MinimapDetailsDescription"] = "更新小地圖的滑鼠提示，隨著敵人名字一併顯示等級/職業的詳細資訊。"
L["DisplayOnMap"] = "在地圖上顯示敵人位置"
L["DisplayOnMapDescription"] = "在世界地圖和小地圖上顯示由隊伍、團隊或公會其他 Spy 使用者偵測到的敵人位置。"
L["SwitchToZone"] = "偵測到敵人時切換到目前區域的地圖"
L["SwitchToZoneDescription"] = "打開世界地圖並且偵測到敵人時，會自動切換到玩家目前所在的區域地圖。"
L["MapDisplayLimit"] = "限制顯示的地圖圖示:"
L["LimitNone"] = "任何地方"
L["LimitNoneDescription"] = "無視目前所在的地區，在地圖上顯示所有偵測到的敵人。"
L["LimitSameZone"] = "相同區域"
L["LimitSameZoneDescription"] = "只顯示同一個區域中偵測到的敵人。"
L["LimitSameContinent"] = "相同大陸"
L["LimitSameContinentDescription"] = "只顯示同一塊大陸中偵測到的敵人。"

L["DataOptions"] = "資料維護"
L["DataOptionsDescription"] = [[
設定 Spy 如何收集和維護資料。
]]
L["PurgeData"] = "清除多久後未偵測到的敵方玩家:"
L["OneDay"] = "1 天"
L["OneDayDescription"] = "清除超過 1 天未偵測到的敵方玩家資料。"
L["FiveDays"] = "5 天"
L["FiveDaysDescription"] = "清除超過 5 天未偵測到的敵方玩家資料。"
L["TenDays"] = "10 天"
L["TenDaysDescription"] = "清除超過 10 天未偵測到的敵方玩家資料。"
L["ThirtyDays"] = "30 天"
L["ThirtyDaysDescription"] = "清除超過 30 天未偵測到的敵方玩家資料。"
L["SixtyDays"] = "60 天"
L["SixtyDaysDescription"] = "清除超過 60 天未偵測到的敵方玩家資料。"
L["NinetyDays"] = "90 天"
L["NinetyDaysDescription"] = "清除超過 90 天未偵測到的敵方玩家資料。"
L["PurgeKoS"] = "也要清除未偵測到的即殺玩家"
L["PurgeKoSDescription"] = "使用相同的時間，清除未偵測到的即殺玩家。"
L["PurgeWinLossData"] = "也要清除勝/敗資料"
L["PurgeWinLossDataDescription"] = "使用相同的時間，清除勝/敗資料。"
L["ShareData"] = "和其他 Spy 使用者分享資料"
L["ShareDataDescription"] = "和隊伍、團隊和公會中也有使用 Spy 插件的玩家分享你遇到敵方玩家的詳情。"
L["UseData"] = "使用來自於其他 Spy 使用者的資料"
L["UseDataDescription"] = [[使用從隊伍、團隊和公會中也有使用 Spy 插件的玩家收集到的資料。

另一個 Spy 使用者偵測到的敵方玩家，也會加入到你的附近清單中 (如果還有空間的話)。
]]
L["ShareKOSBetweenCharacters"] = "不同角色共用即殺玩家資料"
L["ShareKOSBetweenCharactersDescription"] = "分享標記為即殺的玩家給你在同一個伺服器、同陣營的其他角色。"

L["SlashCommand"] = "聊天視窗指令"
L["SpySlashDescription"] = "這些按鈕會執行在聊天視窗輸入 /spy 時相同的指令選項動作。"
L["Enable"] = "啟用"
L["EnableDescription"] = "啟用 Spy 並顯示主視窗。"
L["Reset"] = "重置"
L["ResetDescription"] = "重設主視窗的位置和外觀。"
L["Config"] = "設定"
L["ConfigDescription"] = "開啟介面 > 插件中的 Spy 設定選項。"
L["KOS"] = "即殺"
L["KOSDescription"] = "從即殺清單加入/移除玩家。"
L["Ignore"] = "忽略"
L["IgnoreDescription"] = "從忽略清單加入/移除玩家。"

-- Lists
L["Nearby"] = "附近"
L["LastHour"] = "最近"
L["Ignore"] = "忽略"
L["KillOnSight"] = "即殺"

--Stats
--L["Last"] = "Last"
L["Time"] = "時間"	
L["List"] = "清單"	
L["Show Only"] = "只顯示"
L["Won/Lost"] = "勝/敗"
L["Reason"] = "原因"	  
L["HonorKills"] = "榮譽擊殺"
L["PvPDeatchs"] = "PvP 死亡"

--++ Class descriptions
L["DEATHKNIGHT"] = "死亡騎士"
L["DEMONHUNTER"] = "惡魔獵人"
L["DRUID"] = "德魯伊"
L["HUNTER"] = "獵人"
L["MAGE"] = "法師"
L["MONK"] = "武僧"
L["PALADIN"] = "聖騎士"
L["PRIEST"] = "牧師"
L["ROGUE"] = "盜賊"
L["SHAMAN"] = "薩滿"
L["WARLOCK"] = "術士"
L["WARRIOR"] = "戰士"
L["UNKNOWN"] = "未知"

--++ Race descriptions
L["BLOOD ELF"] = "血精靈"
L["DRAENEI"] = "德萊尼"
L["DWARF"] = "矮人"
L["GOBLIN"] = "哥布林"
L["GNOME"] = "地精"
L["HUMAN"] = "人類"
L["NIGHT ELF"] = "夜精靈"
L["ORC"] = "獸人"
L["PANDAREN"] = "熊貓人"
L["TAUREN"] = "牛頭人"
L["TROLL"] = "食人妖"
L["UNDEAD"] = "不死族"
L["WORGEN"] = "狼人"
L["VOID ELF"] = "虛無精靈"	
L["LIGHTFORGED DRAENEI"] = "光鑄德萊尼"
L["NIGHTBORNE"] = "夜裔精靈"
L["HIGHMOUNTAIN TAUREN"] = "高嶺牛頭人"

--++ Font descriptions
L["2002"] = "2002"
L["2002 BOLD"] = "2002 Bold"
L["ARIAL NARROW"] = "Arial Narrow" -- default chat font
L["FRIZ QUADRATA TT"] = "Friz Quadrata TT" -- default main UI font
L["FRIZQUADRATACTT"] = "FrizQuadrataCTT"
L["MOK"] = "MoK"
L["MORPHEUS"] = "Morpheus" -- default in game mail font
L["NIMROD MT"] = "Nimrod MT"
L["SKURRI"] = "Skurri" -- default unit frame combat font
						
-- Stealth abilities
L["Stealth"] = "隱形"
L["Prowl"] = "潛行"

-- Channel names
L["LocalDefenseChannelName"] = "本地防務"

--++ Minimap color codes
L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L["MinimapClassTextDEMONHUNTER"] = "|cffa330c9"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
L["MinimapClassTextMONK"] = "|cff00ff96"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"

-- Output messages
L["AlertStealthTitle"] = "偵測到隱形玩家!"
L["AlertKOSTitle"] = "偵測到即殺玩家!"
L["AlertKOSGuildTitle"] = "偵測到公會即殺玩家!"
L["AlertTitle_kosaway"] = "發現即殺玩家的位置，由 "
L["AlertTitle_kosguildaway"] = "發現公會即殺玩家的位置，由 "
L["StealthWarning"] = "|cff9933ff偵測到隱形玩家：|cffffffff"
L["KOSWarning"] = "|cffff0000偵測到即殺玩家：|cffffffff"
L["KOSGuildWarning"] = "|cffff0000偵測到公會即殺玩家：|cffffffff"
L["SpySignatureColored"] = "|cff9933ff[Spy] "
L["PlayerDetectedColored"] = "偵測到玩家：|cffffffff"
L["PlayersDetectedColored"] = "偵測到玩家：|cffffffff"
L["KillOnSightDetectedColored"] = "偵測到即殺玩家：|cffffffff"
L["PlayerAddedToIgnoreColored"] = "玩家加入到忽略清單：|cffffffff"
L["PlayerRemovedFromIgnoreColored"] = "從忽略清單移除玩家：|cffffffff"
L["PlayerAddedToKOSColored"] = "玩家加入到即殺清單：|cffffffff"
L["PlayerRemovedFromKOSColored"] = "從即殺清單移除玩家：|cffffffff"
L["PlayerDetected"] = "[Spy] 偵測到玩家："
L["KillOnSightDetected"] = "[Spy] 偵測到即殺玩家："
L["Level"] = "等級"
L["LastSeen"] = "上次遇到"
L["LessThanOneMinuteAgo"] = "小於 1 分鐘前"
L["MinutesAgo"] = "分鐘前"
L["HoursAgo"] = "小時前"
L["DaysAgo"] = "天前"
L["Close"] = "關閉"
L["CloseDescription"] = "|cffffffff隱藏 Spy 主視窗。預設下次偵測到敵方玩家時會再次顯示。."
L["Left/Right"] = "左 / 右"
L["Left/RightDescription"] = "|cffffffff切換顯示附近、最近、忽略和即殺清單。"
L["Clear"] = "清空"
L["ClearDescription"] = "|cffffffff清空已經偵測到的玩家清單。顯示時 CTRL+左鍵點擊會啟用/停用 Spy。"
L["NearbyCount"] = "附近數量"
L["NearbyCountDescription"] = "|cffffffff將附近玩家的數量發送到聊天視窗。"
L["Statistics"] = "統計資料" 
L["StatsDescription"] = "|cffffffff顯示遇過的敵方玩家、勝/敗記錄和上次在哪遇到的清單。"
L["AddToIgnoreList"] = "加入忽略清單"
L["AddToKOSList"] = "加入即殺清單"
L["RemoveFromIgnoreList"] = "從忽略清單移除"
L["RemoveFromKOSList"] = "從即殺清單移除"
L["RemoveFromStatsList"] = "從統計列表中刪除"   --++
L["AnnounceDropDownMenu"] = "通報"
L["KOSReasonDropDownMenu"] = "設定即殺原因"
L["PartyDropDownMenu"] = "隊伍"
L["RaidDropDownMenu"] = "團隊"
L["GuildDropDownMenu"] = "公會"
L["LocalDefenseDropDownMenu"] = "本地防務"
L["Player"] = " (玩家)"
L["KOSReason"] = "即殺"
L["KOSReasonIndent"] = "    "
L["KOSReasonOther"] = "自行輸入原因..."
L["KOSReasonClear"] = "清空"
L["StatsWins"] = "|cff40ff00勝："
L["StatsSeparator"] = "  "
L["StatsLoses"] = "|cff0070dd敗："
L["Located"] = "位置:"
L["Yards"] = "碼"

Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
	[1] = {
		["title"] = "主動攻擊";
		["content"] = {
			"毫無理由攻擊我",
			"接任務時攻擊我", 
			"在鳥點攻擊我",
			"在副本入口攻擊我",
			"我 AFK 暫離時攻擊我",
			"我在趕路/飛行時攻擊我",
			"我的血量/法力很低時攻擊我",
		};
	},
	[2] = {
		["title"] = "戰鬥風格";
		["content"] = {
			"偷襲我",
			"總是讓我看到他再殺我",
			"使用高等級角色殺我",
			"和一群敵人一起輾壓我",
			"沒有人支援時不會攻擊",
			"老是向外求援",
			"使用超多控場技",
		};
	},
	[3] = {
		["title"] = "守屍守點";
		["content"] = {
			"守我屍體",
			"守我分身",
			"守低等級的必取",
			"會隱形來守點",
			"和公會成員一起守點",
			"守遊戲的 NPC/任務點",
			"守城市/村莊",
		};
	},
	[4] = {
		["title"] = "妨礙任務";
		["content"] = {
			"正在解任務時攻擊我",
			"幫忙解任務後攻擊我",
			"擾亂任務目標",
			"搶我的任務",
			"殺死我方陣營的 NPC",
			"殺死任務 NPC",
		};
	},
	[5] = {
		["title"] = "偷搶資源";
		["content"] = {
			"搶我的草",
			"搶我的礦",
			"搶我的資源",
			"殺死我然後搶走我的目標/稀有怪",
			"殺死我要殺的怪",
			"搶走我要殺的怪",
			"搶我的魚點",
		};
	},
	[6] = {
		["title"] = "其他";
		["content"] = {
			"就愛殺人",
			"把我推下懸崖",
			"使用工程學道具",
			"總是落跑",
			"使用物品或技能落跑",
			"濫用遊戲機制",
			"自行輸入原因...",
		};
	},
}

StaticPopupDialogs["Spy_SetKOSReasonOther"] = {
	preferredIndex=STATICPOPUPS_NUMDIALOGS,  -- http://forums.wowace.com/showthread.php?p=320956
	text = "輸入 %s 的即殺原因:",
	button1 = "設定",
	button2 = "取消",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
    	OnAccept = function(self)
		local reason = self.editBox:GetText()
		Spy:SetKOSReason(self.playerName, "自行輸入原因...", reason)
	end,
};

Spy_AbilityList = {

-----------------------------------------------------------
-- Allows an estimation of the race, class and level of a
-- player to be determined from what abilities are observed
-- in the combat log.
-----------------------------------------------------------

--++ Racials ++
	["石像形態"] = 				{ race = "Dwarf", level = 1, },
	["逃命專家"] = 				{ race = "Gnome", level = 1, },
	["人人為己"] = 				{ race = "Human", level = 1, },
	["影遁"] = 					{ race = "Night Elf", level = 1, },
	["那魯的祝福"] = 			{ race = "Draenei", level = 1, },
	["暗月疾奔"] = 				{ race = "Worgen", level = 1, },
	["雙重形態"] = 				{ race = "Worgen", level = 1, },
	["野性奔跑"] = 				{ race = "Worgen", level = 1, },
	["血之烈怒"] = 				{ race = "Orc", level = 1, },
	["戰爭踐踏"] = 				{ race = "Tauren", level = 1, },
	["狂暴"] = 					{ race = "Troll", level = 1, },
	["亡靈意志"] = 				{ race = "Undead", level = 1, },
	["食屍"] = 					{ race = "Undead", level = 1, },
	["奧流之術"] = 				{ race = "Blood Elf", level = 1, },
	["火箭跳躍"] = 				{ race = "Goblin", level = 1, },
	["火箭彈"] = 				{ race = "Goblin", level = 1, },
	["攜帶大哥布林"] = 			{ race = "Goblin", level = 1, },
	["震動掌"] =					{ race = "Pandaren", level = 1, },

--++ Death Knight Abilities ++
	["冰息術"] = 			{ class = "DEATHKNIGHT", level = 1, },	--7
	["屍爆術"] = 		{ class = "DEATHKNIGHT", level = 25, },	--7
	["血魄瘟疫"] = 			{ class = "DEATHKNIGHT", level = 55, }, 
	["死亡之握"] = 			{ class = "DEATHKNIGHT", level = 55, }, 
	["死亡之握"] = 		 		{ class = "DEATHKNIGHT", level = 55, },
	["死亡打擊"] = 				{ class = "DEATHKNIGHT", level = 55, }, --7m  	
	["冰霜熱疫"] = 			{ class = "DEATHKNIGHT", level = 55, },	
	["冰剃符文"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["符文鑄造"] = 			{ class = "DEATHKNIGHT", level = 55, },  
	["反魔法護罩"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7m
	["黑暗敕令"]  = 				{ class = "DEATHKNIGHT", level = 58, },	--7m
	["骸馬騎術"] = 				{ class = "DEATHKNIGHT", level = 61, }, 
	["心智冰封"] = 				{ class = "DEATHKNIGHT", level = 62, },  
	["冰霜之徑"] = 				{ class = "DEATHKNIGHT", level = 66, }, 
	["操控不死生物"] = 			{ class = "DEATHKNIGHT", level = 69, },  
	["墮落十字軍符文"] = { class = "DEATHKNIGHT", level = 70, },	
 	["盟友復生"] = 				{ class = "DEATHKNIGHT", level = 72, },
	["石膚石像鬼符文"] = { class = "DEATHKNIGHT", level = 72, },
--++ Death Knight Artifact Traits ++
	["天啟"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n
	["吞噬"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n
	["辛德拉苟莎之怒"] = 	{ class = "DEATHKNIGHT", level = 100, }, --7n
--++ Death Knight Specialization ++
	--++ Blood/Frost/Unholy ++
 	["闇境靈行"] = 				{ class = "DEATHKNIGHT", level = 60, }, --7n
	["冰錮堅韌"] = 				{ class = "DEATHKNIGHT", level = 57, }, --7.2.5m	
	--++ Blood/Unholy ++	
	["死亡凋零"] = 				{ class = "DEATHKNIGHT", level = 56, }, --7m	
	--++ Frost/Unholy ++
	["黑暗救贖"] = 			{ class = "DEATHKNIGHT", level = 58, },	--7n
	["冰鍊術"] = 		{ class = "DEATHKNIGHT", level = 63, }, --7m 	
	--++ Blood ++
--	["窒息術"] = 			{ class = "DEATHKNIGHT", level = 1, }, --??	
	["碎心打擊"]  = 		{ class = "DEATHKNIGHT", level = 1, }, --7 
	["撕骨裂髓"]  = 			{ class = "DEATHKNIGHT", level = 55, }, --7n	
	["沸血術"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7m
	["符文武器幻舞"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7m
	["死亡的撫慰"] = 		{ class = "DEATHKNIGHT", level = 58, },	--7n
	["血族之裔"] = 		{ class = "DEATHKNIGHT", level = 60, },	--7.2.5m	
	["第三次大戰精兵"] = { class = "DEATHKNIGHT", level = 60, },
	["赤血災禍"] = 		{ class = "DEATHKNIGHT", level = 84, },	
	["血魔之握"] = 	{ class = "DEATHKNIGHT", level = 64, }, --7m
--	["還擊"] = 				{ class = "DEATHKNIGHT", level = 76, }, --++ conflict	
	["血魄護盾"] = 			{ class = "DEATHKNIGHT", level = 78, },
	--++ Frost ++ 
	["強化符能"] = 	{ class = "DEATHKNIGHT", level = 1, }, --7m??
	["冰霜熱疫"] = 			{ class = "DEATHKNIGHT", level = 55, },	--7n	
	["冰霜打擊"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["凜風衝擊"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["滅寂"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["殺戮酷刑"] = 		{ class = "DEATHKNIGHT", level = 56, },	  
 	["強力符文武器"] = 	{ class = "DEATHKNIGHT", level = 57, },	--7n
	["冰霜之柱"] = 		{ class = "DEATHKNIGHT", level = 57, },	
	["凝霜"] = 					{ class = "DEATHKNIGHT", level = 59, },
	["寒冰之心"] = 			{ class = "DEATHKNIGHT", level = 78, },	
	--++ Unholy ++  
	["膿瘡傷口"] = 		{ class = "DEATHKNIGHT", level = 1, }, --7n	
	["符能腐化"] = 		{ class = "DEATHKNIGHT", level = 1, }, --7m??	
	["死亡纏繞"] = 			{ class = "DEATHKNIGHT", level = 55, }, --7m 
--	["死神逼近"] = 		{ class = "DEATHKNIGHT", level = 55, },	--7 Hotfix removed
	["膿瘡潰擊"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["疫病爆發"] = 				{ class = "DEATHKNIGHT", level = 55, }, --7m	
	["死者復生"] = 			{ class = "DEATHKNIGHT", level = 55, }, --7m
	["天譴打擊"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["厄運驟臨"] = 			{ class = "DEATHKNIGHT", level = 64, },
	["黑暗變身"] = 		{ class = "DEATHKNIGHT", level = 74, },	  
	["召喚石像鬼"] = 		{ class = "DEATHKNIGHT", level = 75, },	  
	["恐怖之刃"] = 			{ class = "DEATHKNIGHT", level = 78, },
	["亡靈大軍"] = 			{ class = "DEATHKNIGHT", level = 82, }, --7m	
--++ Death Knight Talents ++
	--++ Blood ++
	["飲血者"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7n
	["血蟲"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7n
	["碎心者"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7n
	["急速腐敗"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7n
--	["吞食靈魂"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7.2.5r
	["冰之心"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7.2.5n	
	["鬼靈偏折"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7n
	["反魔法屏障"] = 	{ class = "DEATHKNIGHT", level = 58, }, --7n	
	["血魄轉化"] = 			{ class = "DEATHKNIGHT", level = 58, }, --7m
	["藏骨堂"] = 				{ class = "DEATHKNIGHT", level = 58, }, --7n
	["血魄印記"] = 		{ class = "DEATHKNIGHT", level = 60, }, --7n	
	["腥紅飢渴"] = 			{ class = "DEATHKNIGHT", level = 60, }, --7n	
	["墓碑"] = 			{ class = "DEATHKNIGHT", level = 60, }, --7n	
	["遭譴者行軍"] = 	{ class = "DEATHKNIGHT", level = 75, }, --7n	
	["緊縛之握"] = 		{ class = "DEATHKNIGHT", level = 75, }, --7n	
	["死亡顫慄"] = 	{ class = "DEATHKNIGHT", level = 75, }, --7n	
	["腐惡壁壘"] = 			{ class = "DEATHKNIGHT", level = 90, }, --7n	
	["符文轉化"] = 				{ class = "DEATHKNIGHT", level = 90, },	--7m
 	["亡域意志"] = { class = "DEATHKNIGHT", level = 90, }, --7m	
 	["血魄之鏡"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n
 	["骸骨風暴"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n	
 	["贖魂"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7m	
	--++ Frost ++ 
	["冰結之爪"] = 			{ class = "DEATHKNIGHT", level = 56, },	--7m	
	["符能散射"] = 	{ class = "DEATHKNIGHT", level = 56, }, --7.3m		
	["碎身打擊"] = 	{ class = "DEATHKNIGHT", level = 56, }, --7n
	["冰封之霧"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7n
	["凜冬號角"] = 		{ class = "DEATHKNIGHT", level = 57, }, --7m
	["致命效能"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7.3m	
	["崩擊"] = 			{ class = "DEATHKNIGHT", level = 58, }, --7n
	["冰川突進"] = 		{ class = "DEATHKNIGHT", level = 58, }, --7.3m	
	["極地冰帽"] = 				{ class = "DEATHKNIGHT", level = 58, }, --7n
	["兇惡之力"] = 	{ class = "DEATHKNIGHT", level = 60, }, --7n
	["致盲凍雨"] = 		{ class = "DEATHKNIGHT", level = 60, }, --7n
	["凜冬將至"] = 		{ class = "DEATHKNIGHT", level = 60, }, --7n
	["無情之擊"] =	{ class = "DEATHKNIGHT", level = 75, }, --7.3n	
	["極寒冰霜"] = 			{ class = "DEATHKNIGHT", level = 75, }, --7n
--	["爆寒護罩"] = 	{ class = "DEATHKNIGHT", level = 75, }, --7.3r
	["腐惡壁壘"] = 			{ class = "DEATHKNIGHT", level = 75, }, --7n
	["冰霜鐮刀"] = 			{ class = "DEATHKNIGHT", level = 90, }, --7n
	["冰凍脈衝"] = 			{ class = "DEATHKNIGHT", level = 90, }, --7.3m	
	["蓄寒冰暴"] = 		{ class = "DEATHKNIGHT", level = 90, }, --7n
	["辛德拉苟莎之息"]=	{ class = "DEATHKNIGHT", level = 100, }, --7m
	["飢狂符文武器"] = { class = "DEATHKNIGHT", level = 100, }, --7.3m		
	["滅體抹殺"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n		
	--++ Unholy ++ 
	["亡者皆奴"] =		{ class = "DEATHKNIGHT", level = 56, },--7n
	["爆裂瘡瘍"] =		{ class = "DEATHKNIGHT", level = 56, },--7n	
	["黯黑熱疫"] =			{ class = "DEATHKNIGHT", level = 56, },--7n	
	["荒疫符文武器"] =	{ class = "DEATHKNIGHT", level = 57, },--7n	
	["疫情蔓延"] =			 	{ class = "DEATHKNIGHT", level = 57, },--7n	
	["瘟疫膿瘡"] =	{ class = "DEATHKNIGHT", level = 57, },--7n	
	["鞭撻者"] =			{ class = "DEATHKNIGHT", level = 58, },--7n	
	["暗影爪襲"] =		{ class = "DEATHKNIGHT", level = 58, },--7n	
	["邪惡狂熱"] = 		{ class = "DEATHKNIGHT", level = 58, },	--7m 
	["窒息術"] = 			{ class = "DEATHKNIGHT", level = 60, },
	["衰弱寄生"] = { class = "DEATHKNIGHT", level = 60, },--7n
	["淤泥噴射者"] =		{ class = "DEATHKNIGHT", level = 60, },--7n
	["屍盾術"] =			{ class = "DEATHKNIGHT", level = 75, },--7n
	["陰魂不散"] =	{ class = "DEATHKNIGHT", level = 75, },--7n
	["噬魔者"] =			{ class = "DEATHKNIGHT", level = 75, },--7n
	["感染爪擊"] =		{ class = "DEATHKNIGHT", level = 90, },--7n	
	["死亡之疽"] = 				{ class = "DEATHKNIGHT", level = 90, },	--7m
	["闇能灌注"] =		{ class = "DEATHKNIGHT", level = 90, },--7n	
	["黑暗仲裁者"] =			{ class = "DEATHKNIGHT", level = 100, },--7n
	["褻瀆"] =			 	{ class = "DEATHKNIGHT", level = 100, },--7m
	["靈魂收割者"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7m	
--++ Death Knight PvP Talents
	["絞殺"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["反魔法力場"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["黑暗幻象"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["腐朽光環"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["遊蕩瘟疫"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["死亡鎖鍊"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["屠殺機器"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["寒冰凍能"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["復生亡骸"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["亡域打擊"]=		{ class = "DEATHKNIGHT", level = 100, },--7n

--++ Demon Hunter Abilities ++
--	["致命一擊"]=		{ class = "DEMONHUNTER", level = 98, }, Conflict
--	["招架"]=					{ class = "DEMONHUNTER", level = 98, }, Conflict
	["混沌之擊"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["吞噬魔法"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["惡魔之咬"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["二段跳"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
--	["能量恢復"]=			{ class = "DEMONHUNTER", level = 98, }, --7n??
	["魔眼光束"]=				{ class = "DEMONHUNTER", level = 98, }, --7n+
	["魔化衝刺"]=				{ class = "DEMONHUNTER", level = 98, }, --7n+
	["滑翔"]=					{ class = "DEMONHUNTER", level = 98, }, --7n+
	["靈視"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["投擲戰刃"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["惡魔化身"]=			{ class = "DEMONHUNTER", level = 99, }, --7n+	
	["殲滅"]=			{ class = "DEMONHUNTER", level = 99, }, --7n+
	["劍刃之舞"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["殘影"]=					{ class = "DEMONHUNTER", level = 100, }, --7n+
	["混沌新星"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["黑暗"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["死亡掃擊"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+	
	["囚禁"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["蠻恨撤離"]=		{ class = "DEMONHUNTER", level = 100, }, --7n+
--++ Demon Hunter Artifact Traits ++
	["伊利達瑞怒火"]=	{ class = "DEMONHUNTER", level = 100, }, --7n
	["靈魂屠夫"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
--++ Demon Hunter Specialization ++
	--++ Havoc/Vengeance ++	
	["粉碎靈魂"]=		{ class = "DEMONHUNTER", level = 98, }, --7n+
	--++ Havoc ++	
	["魔化之心"]= 		{ class = "DEMONHUNTER", level = 98, }, --7n+
	--++ Vengeance ++	
	["獻祭光環"]=		{ class = "DEMONHUNTER", level = 100, }, --7n+
--	["提高威脅值"]=		{ class = "DEMONHUNTER", level = 98, }, --7n ??
	["煉獄轟擊"]=		{ class = "DEMONHUNTER", level = 100, }, --7n+
--	["魔痛"]=					{ class = "DEMONHUNTER", level = 98, }, --7n ??
	["折磨"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["惡魔尖刺"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["惡魔結界"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["熾炎烙印"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["魔化之血"]=	  			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["削斬"]=					{ class = "DEMONHUNTER", level = 100, }, --7n+
	["火焰符印"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["破魂斬"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
--	["還擊"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+ Conflict
--	["鎖鏈符印"]=		{ class = "DEMONHUNTER", level = 100, }, --7n  ??
 	["黑暗"]=		{ class = "DEMONHUNTER", level = 101, },  --7.1c 
	["強化結界"]=			{ class = "DEMONHUNTER", level = 103, }, --7.1c 	
	["苦難符印"]=		{ class = "DEMONHUNTER", level = 105, }, --7.1c 	
--++ Demon Hunter Talents ++
	["裂魂"]=			{ class = "DEMONHUNTER", level = 104, },  --7n
	["精通魔能"]=			{ class = "DEMONHUNTER", level = 106, }, --7n
	--++ Havoc ++	
	["目盲之怒"]=				{ class = "DEMONHUNTER", level = 99, }, --7n 
	["魔刃"]=				{ class = "DEMONHUNTER", level = 99, }, --7.1.5m	
	["混沌順劈"]=			{ class = "DEMONHUNTER", level = 102, }, --7.1.5c 
	["精通魔能"]=			{ class = "DEMONHUNTER", level = 99, }, --7n 
	["惡魔之刃"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
	["惡魔饗宴"]=		{ class = "DEMONHUNTER", level = 100, }, --7n
	["嚴陣以待"]=				{ class = "DEMONHUNTER", level = 100, }, --7n
	["放血"]=				{ class = "DEMONHUNTER", level = 102, }, --7n
	["第一滴血"]=			{ class = "DEMONHUNTER", level = 102, }, --7n
	["殊死直覺"]=	{ class = "DEMONHUNTER", level = 104, }, --7n
	["虛空穿越"]=				{ class = "DEMONHUNTER", level = 104, }, --7n
	["氣勢如虹"]=				{ class = "DEMONHUNTER", level = 106, }, --7n
	["死敵"]=				{ class = "DEMONHUNTER", level = 106, }, --7n
	["戰刃大師"]=	{ class = "DEMONHUNTER", level = 108, }, --7n
	["惡魔重生"]=			{ class = "DEMONHUNTER", level = 108, }, --7n
	["力量綻放"]=		{ class = "DEMONHUNTER", level = 108, }, --7n
	["混沌之刃"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
	["魔體轉化"]=				{ class = "DEMONHUNTER", level = 110, }, --7n
	["魔化彈幕"]=			{ class = "DEMONHUNTER", level = 110, },--7n
	--++ Vengeance ++
	["深淵之擊"]=			{ class = "DEMONHUNTER", level = 99, }, --7n
	["苦惱之焰"]=		{ class = "DEMONHUNTER", level = 99, }, --7n
	["鋒銳尖刺"]=			{ class = "DEMONHUNTER", level = 99, }, --7n
	["烈焰活焚"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
	["輻射落塵"]=				{ class = "DEMONHUNTER", level = 100, }, --7n
	["靈魂饗宴"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
	["烈焰撞擊"]=			{ class = "DEMONHUNTER", level = 102, }, --7n
	["貪食魔"]=				{ class = "DEMONHUNTER", level = 102, }, --7n
	["餵食惡魔"]=			{ class = "DEMONHUNTER", level = 104, }, --7n
	["切裂"]=				{ class = "DEMONHUNTER", level = 104, }, --7n
 	["符印專注"]=	{ class = "DEMONHUNTER", level = 106, }, --7n
	["符印加速"]=		{ class = "DEMONHUNTER", level = 106, }, --7n
	["劍刃轉向"]=			{ class = "DEMONHUNTER", level = 108, }, --7n
	["魔化破滅"]=		{ class = "DEMONHUNTER", level = 108, }, --7n
	["劍刃轉向"]=			{ class = "DEMONHUNTER", level = 108, }, --7n
	["惡魔灌注"]=		{ class = "DEMONHUNTER", level = 108, }, --7.1.5n	
	["最後手段"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
--	["虛空連結"]=			{ class = "DEMONHUNTER", level = 110, }, --7.1.5r
	["靈魂屏障"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
--++ Demon Hunter PvP Talents ++
	["破除法力"]=				{ class = "DEMONHUNTER", level = 110, }, --7n
	["反彈魔法"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
	["惡魔踐踏"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["伊利丹之握"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["李奧薩拉斯之眼"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["從天而降"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["法力裂隙"]=				{ class = "DEMONHUNTER", level = 110, }, --7.1.5n	
	
--++ Druid Abilities ++
	["獵豹形態"] = 				{ class = "DRUID", level = 1, },
--	["追蹤人形生物"] = 		{ class = "DRUID", level = 1, }, 7 Conflict
	["豹之優雅"] = 			{ class = "DRUID", level = 6, },
	["熊形態"] = 			{ class = "DRUID", level = 8, },
	["節能施法"] =	 		{ class = "DRUID", level = 10, },
	["月火術"] = 				{ class = "DRUID", level = 10, },
	["低吼"] = 				{ class = "DRUID", level = 13, },
	["夢行"] = 			{ class = "DRUID", level = 14, }, --7n
	["復活"] = 				{ class = "DRUID", level = 14, },
	["傳送：月光林地"] = 	{ class = "DRUID", level = 14, },
	["旅行形態"] = 			{ class = "DRUID", level = 18, },
	["日炎術"] = 				{ class = "DRUID", level = 18, },--7m??
	["痛擊"] = 		 		{ class = "DRUID", level = 18, }, --7??
	["糾纏根鬚"] = 		{ class = "DRUID", level = 10, }, 
--	["突進"] = 					{ class = "DRUID", level = 24, }, 7 Conflict
	["魅惑林地生物"] = { class = "DRUID", level = 40, },	--7m
	["振翅"] = 					{ class = "DRUID", level = 40, }, --7n	
	["雄鹿形態"] = 			{ class = "DRUID", level = 40, }, --7n	
--	["追蹤野獸"] = 			{ class = "DRUID", level = 40, }, 7 Conflict	
	["復生"] = 				{ class = "DRUID", level = 56, },
	["飛行形態"] = 			{ class = "DRUID", level = 58, },
--++ Druid Artifact Traits ++
	["亞夏曼之狂"] = 	{ class = "DRUID", level = 100, }, --7n	
	["格哈尼爾的精華"] = 	{ class = "DRUID", level = 100, }, --7n	
	["新月"] = 				{ class = "DRUID", level = 100, }, --7n		
	["沉睡者之怒"] = 	{ class = "DRUID", level = 100, }, --7n	
--++ Druid Specialization ++
	--++ Balance/Feral/Guardian/Restoration ++
	["潛行"] = 				{ class = "DRUID", level = 5, }, --7m
	--++ Balance/Restoration ++
	["啟動"] = 			{ class = "DRUID", level = 54, }, --7m	
	--++ Balance/Feral/Guardian ++
	["癒合"] = 				{ class = "DRUID", level = 5, }, --7.1n
	["解除腐化"] = 	{ class = "DRUID", level = 18, },
	--++ Balance/Guardian/Restoration ++
	["樹皮術"] = 				{ class = "DRUID", level = 36, }, --x Moved
	--++ Feral/Guardian ++
--	["致命一擊"] = 		{ class = "DRUID", level = 1, }, --7m Conflict
	["培育天性"] = 	{ class = "DRUID", level = 10, },
	["揮擊"] = 				{ class = "DRUID", level = 32, }, --7m
	["求生本能"] = 	{ class = "DRUID", level = 40, },
	["碎顱猛擊"] = 			{ class = "DRUID", level = 64, },
	["奔竄咆哮"] = 		{ class = "DRUID", level = 83, }, --7m	
	--++ Balance ++
	["星界效應"] = 		{ class = "DRUID", level = 10, }, --7n	
	["太陽之怒"] = 			{ class = "DRUID", level = 10, }, --7n	??
	["星湧術"] = 			{ class = "DRUID", level = 12, },
	["月光之擊"] = 			{ class = "DRUID", level = 12, }, --7n
	["梟獸形態"] = 			{ class = "DRUID", level = 16, },
	["太陽光束"] = 			{ class = "DRUID", level = 28, },
	["星殞術"] = 				{ class = "DRUID", level = 76, },
	["星穹連線"] = 	{ class = "DRUID", level = 64, },	
	["星光閃爍"] = 			{ class = "DRUID", level = 78, }, --7n
	--++ Feral ++
	["撕碎"] = 				{ class = "DRUID", level = 1, },
	["兇猛撕咬"] = 		{ class = "DRUID", level = 6, }, --7m	
	["掃擊"] = 					{ class = "DRUID", level = 6, }, 	
	["豹之迅捷"] = 		{ class = "DRUID", level = 10, }, --7m
	["猛虎之怒"] = 			{ class = "DRUID", level = 12, },
	["撕扯"] = 					{ class = "DRUID", level = 20, }, 
	["猛獸迅捷"] = 	{ class = "DRUID", level = 28, },
	["清晰預兆"] = 		{ class = "DRUID", level = 38, }, --7m ??
	["感染之傷"] = 		{ class = "DRUID", level = 40, }, --7m	
	["狂暴"] = 				{ class = "DRUID", level = 48, }, --7m
	["傷殘術"] = 					{ class = "DRUID", level = 72, }, 
	["鋒利之爪"] = 			{ class = "DRUID", level = 78, },
	--++ Guardian ++ 
	["割碎"] = 				{ class = "DRUID", level = 6, }, --7m
	["槌擊"] = 					{ class = "DRUID", level = 10, }, --x Moved
	["厚皮"] = 			{ class = "DRUID", level = 10, }, 
	["癱瘓咆哮"] = 	{ class = "DRUID", level = 28, }, --7n	
	["浴血奮戰"] = 					{ class = "DRUID", level = 34, }, --7n
	["鋼鐵毛皮"] = 				{ class = "DRUID", level = 44, }, --7n	
	["狂暴恢復"] = { class = "DRUID", level = 50, }, --7m
--	["Mark of Ursol"] = 		{ class = "DRUID", level = 72, }, --7.2.5r	
	["自然守護者"] = 	{ class = "DRUID", level = 78, }, 
	--++ Restoration ++  
	["回春術"] = 			{ class = "DRUID", level = 12, }, --7m
	["迅癒"] = 			{ class = "DRUID", level = 12, }, 
	["自然療癒"] = 		{ class = "DRUID", level = 18, },
	["治療之觸"] = 		{ class = "DRUID", level = 26, }, --7.1m	
	["生命種子"] = 			{ class = "DRUID", level = 28, },
	["生命之花"] = 			{ class = "DRUID", level = 32, },
	["群體復活"] = 			{ class = "DRUID", level = 44, }, --7n	
	["厄索之旋"] = 		{ class = "DRUID", level = 48, }, --7m	
	["鐵樹皮術"] = 				{ class = "DRUID", level = 52, },
	["野性痊癒"] = 			{ class = "DRUID", level = 64, },
	["寧靜"] = 			{ class = "DRUID", level = 72, },
	["和諧"] = 				{ class = "DRUID", level = 78, },
	["百花綻放"] = 		{ class = "DRUID", level = 82, }, --7n	
	--++ Druid Talents ++
	["狂野衝鋒"] = 			{ class = "DRUID", level = 15, }, 
	["群體糾纏"] = 	{ class = "DRUID", level = 60, }, 
	["猛力重擊"] = 			{ class = "DRUID", level = 60, }, 
	["颱風"] = 				{ class = "DRUID", level = 60, }, 	
	--++ Balance/Feral/Restoration ++
	["守護者共鳴"] = 	{ class = "DRUID", level = 45, }, --7n ??
	["獸性位移"] = 		{ class = "DRUID", level = 30, }, 	
	--++ Balance/Feral/Guardian ++
	["復原"] = 				{ class = "DRUID", level = 30, },
	["恢復共鳴"] = 	{ class = "DRUID", level = 45, }, --7n
	["森林之魂"] = 	{ class = "DRUID", level = 75, }, --??
	--++ Feral/Guardian ++
	["平衡共鳴"] = 		{ class = "DRUID", level = 45, }, --7n
	["野性戰鬥共鳴"] = 		{ class = "DRUID", level = 45, }, --7n	
	--++ Balance ++	
	["自然之力"] = 		{ class = "DRUID", level = 15, },
	["星爵"] = 				{ class = "DRUID", level = 15, }, --7n
	["伊露恩戰士"] = 		{ class = "DRUID", level = 15, }, --7n
	["化身：伊露恩天選者"] = { class = "DRUID", level = 75, }, --7n
	["星光閃焰"] =		 	{ class = "DRUID", level = 75, }, 
	["星體共融"] = 		{ class = "DRUID", level = 90, }, --7m
	["古樹祝福"] = { class = "DRUID", level = 90, }, --7n
	["流星術"] = 		{ class = "DRUID", level = 90, }, --7m
	["伊露恩之怒"] = 		{ class = "DRUID", level = 100, }, --7n
	["自然平衡"] = 		{ class = "DRUID", level = 100, }, --7n
	["星際漂泊"] = 		{ class = "DRUID", level = 100, }, --7n
	--++ Feral ++
	["鮮血氣息"] =			{ class = "DRUID", level = 15, }, --7n	
	["月之鼓舞"] =		{ class = "DRUID", level = 15, }, 	
	["捕獵者"] =				{ class = "DRUID", level = 15, }, --7n
	["化身：叢林之王"] = { class = "DRUID", level = 75, }, --7n
	["遍體鱗傷"] = 		{ class = "DRUID", level = 75, }, --7.3m	
	["兇蠻刈殺"] = 			{ class = "DRUID", level = 90, }, --7.3m
	["劍齒"] = 			{ class = "DRUID", level = 90, }, --7n
	["兇蠻咆哮"] = 			{ class = "DRUID", level = 90, }, --7.3m
	["血爪"] = 			{ class = "DRUID", level = 100, }, 
	["伊露恩的指引"] = 		{ class = "DRUID", level = 100, }, --7.3mn	
	--++ Guardian ++	
	["血之狂暴"] = 			{ class = "DRUID", level = 15, }, --7n	
	["刺藤"] = 				{ class = "DRUID", level = 15, }, --7n	
	["針刺毛皮"] = 		{ class = "DRUID", level = 15, },
	["粗啞咆哮"] = 		{ class = "DRUID", level = 30, }, --7n	
	["破膽咆哮"] = 	{ class = "DRUID", level = 30, }, --7.1.5n	
	["星河守護者"] = 	{ class = "DRUID", level = 75, }, --7n	
	["化身：厄索克守護者"] = { class = "DRUID", level = 75, }, --7n
	["大地看守者"] = 			{ class = "DRUID", level = 90, }, --7n	
	["伊露恩的守護者"] =	 	{ class = "DRUID", level = 90, }, 
	["適者生存"] = { class = "DRUID", level = 90, }, --7m
	["月之光"] = 			{ class = "DRUID", level = 100, }, --7n	
	["粉碎"] = 			{ class = "DRUID", level = 100, }, 
	["碎裂撕扯"] = 		{ class = "DRUID", level = 100, }, --7n		
	--++ Restoration ++
	["豐足"] = 			{ class = "DRUID", level = 15, }, --7n	
	["塞納里奧結界"] = 		{ class = "DRUID", level = 15, },
	["富饒"] = 			{ class = "DRUID", level = 15, }, --7n
	["栽培"] = 			{ class = "DRUID", level = 75, }, --7n
	["化身：生命之樹"] = { class = "DRUID", level = 75, }, --7n
	["萌芽生長"] = 			{ class = "DRUID", level = 90, }, --7n	
	["內在平靜"] = 			{ class = "DRUID", level = 90, }, --7n
	["春暖花開"] = 		{ class = "DRUID", level = 90, }, --7n
	["繁茂"] = 				{ class = "DRUID", level = 100, }, --7n
	["石樹皮術"] = 			{ class = "DRUID", level = 100, }, --7n
	["清晰時刻"] =	 	{ class = "DRUID", level = 100, }, --7.1.5m	
--++ Druid PvP Talents ++
	["颶風術"] =				{ class = "DRUID", level = 100, }, --7n
--	["Demoralizing Roar"] =		{ class = "DRUID", level = 100, }, --7n ?r
--	["Enraged Mangle"] =		{ class = "DRUID", level = 100, }, --7.1.5r
	["暴走"] =				{ class = "DRUID", level = 100, }, --7n
--	["Focused Growth"] =		{ class = "DRUID", level = 100, }, --7n r
	["蔓生術"] =			{ class = "DRUID", level = 100, }, --7n
	["荊棘術"] =				{ class = "DRUID", level = 100, }, --7n
	["精靈群襲"] =			{ class = "DRUID", level = 100, }, --7n
	["荊棘術"] =				{ class = "DRUID", level = 100, }, --7.1.5n
	["怒殘術"] =			{ class = "DRUID", level = 100, }, --7.1.5n 
	
--++ Hunter Abilities ++
	["召喚寵物1"] = 			{ class = "HUNTER", level = 1, },
	["標記射擊"] = 			{ class = "HUNTER", level = 1, }, --7n	
	["治療寵物"] = 				{ class = "HUNTER", level = 1, },	
	["復活寵物"] = 			{ class = "HUNTER", level = 1, },
	["獵豹守護"] = { class = "HUNTER", level = 5, },
	["召喚寵物2"] = 			{ class = "HUNTER", level = 10 },
	["控制寵物"] = 			{ class = "HUNTER", level = 10, },	
	["解散野獸"] = 			{ class = "HUNTER", level = 10, },
	["馴服野獸"] = 			{ class = "HUNTER", level = 10, },
	["餵養寵物"] = 				{ class = "HUNTER", level = 11, },
	["野獸知識"] = 			{ class = "HUNTER", level = 12, },	
	["鷹眼術"] = 			{ class = "HUNTER", level = 16, },
	["假死"] = 			{ class = "HUNTER", level = 32, },
	["叫醒"] = 				{ class = "HUNTER", level = 32, }, --7n	
	["召喚寵物3"] = 			{ class = "HUNTER", level = 42, },	
	["照明彈"] = 				{ class = "HUNTER", level = 38, },
	["變色龍守護"] = { class = "HUNTER", level = 40, }, --7n
	["取物"] = 				{ class = "HUNTER", level = 40, }, 
	["煙火"] = 			{ class = "HUNTER", level = 40, }, 	
	["裝死"] = 			{ class = "HUNTER", level = 40, }, --7n		
	["巨龜守護"] = 	{ class = "HUNTER", level = 50, }, 	--7n	
	["召喚寵物4"] = 			{ class = "HUNTER", level = 62, },
	["召喚寵物5"] = 			{ class = "HUNTER", level = 82, },
--++ Hunter Artifact Traits ++
	["飛鷹怒火"] = 	{ class = "HUNTER", level = 100, }, --7n
	["泰坦雷擊"] = 		{ class = "HUNTER", level = 100, }, --7n
	["風爆"] = 			{ class = "HUNTER", level = 100, }, --7n
--++ Hunter Specialization ++
	--++ Beast Mastery/Marksmanship ++
	["震盪射擊"] = 		{ class = "HUNTER", level = 8, }, --7m	
	["逃脫"] = 			{ class = "HUNTER", level = 45, }, --7.1.5c	
	["駁火反擊"] = 			{ class = "HUNTER", level = 24, }, --7m
	["多重射擊"] = 			{ class = "HUNTER", level = 28, }, --7m
	["誤導"] = 			{ class = "HUNTER", level = 42, }, --7m
	--++ Beast Mastery/Marksmanship/Survival ++
	["冰凍陷阱"] = 		{ class = "HUNTER", level = 28, }, --7m	
	["心曠神怡"] = 			{ class = "HUNTER", level = 36, }, --7m ??
	["瀝青陷阱"] = 				{ class = "HUNTER", level = 36, }, --7.1.5m	
	--++ Beast Mastery ++
	["眼鏡蛇射擊"] = 			{ class = "HUNTER", level = 1, },	
	["擊殺命令"] = 			{ class = "HUNTER", level = 3, },
	["凶暴野獸"] = 			{ class = "HUNTER", level = 10, }, --7mm
	["奇特野獸"] = 		{ class = "HUNTER", level = 10, },	
	["野性守護"] = 	{ class = "HUNTER", level = 18, }, --7n
	["野性呼喚"] = 			{ class = "HUNTER", level = 22, }, --7n
	["獸劈斬"] = 			{ class = "HUNTER", level = 29, },
	["狂野怒火"] = 		{ class = "HUNTER", level = 40, },
	["血系相連"] = 		{ class = "HUNTER", level = 44, },
	["萬獸之王"] = 		{ class = "HUNTER", level = 78, },
	--++ Marksmanship ++ 
	["瞄準射擊"] = 			{ class = "HUNTER", level = 10, },
	["秘法射擊"] = 			{ class = "HUNTER", level = 10 }, --7m
	["獵人印記"] = 		{ class = "HUNTER", level = 18, }, --7m
	["標記射擊"] = 			{ class = "HUNTER", level = 18, }, --7n	
	["爆破射擊"] = 		{ class = "HUNTER", level = 22, }, --7n		
	["連續狩獵"] = 		{ class = "HUNTER", level = 34, }, --7n
	["強擊"] = 				{ class = "HUNTER", level = 39, }, --7n
	["神射手的專注"] = 		{ class = "HUNTER", level = 44, }, --7.1.5n	
	["連環火網"] = 			{ class = "HUNTER", level = 62, },
	["狙擊訓練"] = 		{ class = "HUNTER", level = 78, }, 
	--++ Survival ++  
	["側翼攻擊"] = 		{ class = "HUNTER", level = 10, }, --7n
	["猛禽一擊"] = 		{ class = "HUNTER", level = 10, }, --7n	
	["摔絆"] = 			{ class = "HUNTER", level = 10, }, --7n	
	["生存專家"] = 			{ class = "HUNTER", level = 16, }, --7.1.5c	
	["貓鼬撕咬"] = 		{ class = "HUNTER", level = 18, }, --7n	
	["投擲短斧"] = 			{ class = "HUNTER", level = 19, }, --7n	
	["魚叉"] = 				{ class = "HUNTER", level = 22, }, --7n	
	["封口"] = 				{ class = "HUNTER", level = 24, }, --7n
	["割裂"] = 				{ class = "HUNTER", level = 26, }, --7	
	["神鷹守護"] = 	{ class = "HUNTER", level = 44, }, --7n	
	["爆炸陷阱"] = 		{ class = "HUNTER", level = 48, }, --7m	
	["橫劈"] = 				{ class = "HUNTER", level = 54, }, --7n	
	["狩獵夥伴"] = 	{ class = "HUNTER", level = 90, }, --7n
--++ Hunter Talents ++
	["追獵高手"] = 			{ class = "HUNTER", level = 45, }, --7.1n
	["疾影術"] = 			{ class = "HUNTER", level = 45, },
	--++ Beast Mastery/Marksmanship/Survival ++
	["黑鴉獵殺"] = 	{ class = "HUNTER", level = 90, }, --??
	--++ Beast Mastery/Marksmanship ++
	["遠行者"] = 			{ class = "HUNTER", level = 45, }, --7.1.5c 	
	["禁錮射擊"] = 			{ class = "HUNTER", level = 75, }, 
	["蠍尾獅釘刺"] = 			{ class = "HUNTER", level = 75, },	
	["彈幕"] = 				{ class = "HUNTER", level = 90, },
	["箭雨"] = 				{ class = "HUNTER", level = 90, },	--7n
	--++ Beast Mastery/Survival ++
	["野獸守護"] = 	{ class = "HUNTER", level = 100, }, --7m
	--++ Marksmanship/Survival ++
	["偽裝"] = 			{ class = "HUNTER", level = 75, }, --7m	
	--++ Beast Mastery ++	
	["動物本能"] = 		{ class = "HUNTER", level = 15, }, --7n		
	["凶暴獸欄"] = 			{ class = "HUNTER", level = 15, }, --7n	
	["眼鏡蛇之道"] = 		{ class = "HUNTER", level = 15, }, --7n		
	["奇美拉射擊"] = 		{ class = "HUNTER", level = 30, }, --7m
	["凶暴狂亂"] = 			{ class = "HUNTER", level = 30, }, --7n	
	["踐踏"] = 				{ class = "HUNTER", level = 30, }, --7n	
	["野獸之怒"] = 			{ class = "HUNTER", level = 60, }, --7n	
	["閃現追擊"] = 		{ class = "HUNTER", level = 60, },
	["與獸群合一"] = 	{ class = "HUNTER", level = 60, }, --7n		
	["威嚇"] = 			{ class = "HUNTER", level = 75, },	
	["致命蛇咬"] = 			{ class = "HUNTER", level = 100, }, --7n		
	["獸群奔竄"] = 				{ class = "HUNTER", level = 100, }, --7m	
	--++ Marksmanship ++
	["仔細瞄準"] = 			{ class = "HUNTER", level = 15, }, --7m	
	["孤狼"] =		 		{ class = "HUNTER", level = 15, }, 	
	["穩固集中"] = 			{ class = "HUNTER", level = 15, }, --7m
	["黑蝕箭"] = 			{ class = "HUNTER", level = 30, }, --7m
	["蓄勢待發"] = 		{ class = "HUNTER", level = 30, }, --7m
	["精確瞄準"] = 				{ class = "HUNTER", level = 30, }, --7n
	["爆裂射擊"] = 		{ class = "HUNTER", level = 60, }, --7m
	["有耐心的狙擊手"] =		{ class = "HUNTER", level = 60, }, --7n
	["哨兵"] = 				{ class = "HUNTER", level = 60, }, --7n	
	["穿透射擊"] = 		{ class = "HUNTER", level = 100, }, --7m
	["響尾蛇射擊"] = 			{ class = "HUNTER", level = 100, }, --7n
	["特技射擊"] = 			{ class = "HUNTER", level = 100, }, --7n	
	--++ Survival ++
	["動物本能"] = 		{ class = "HUNTER", level = 15, }, --7n	
	["投擲飛斧"] = 		{ class = "HUNTER", level = 15, }, --7n	
	["摩克納薩爾之道"] = { class = "HUNTER", level = 15, }, --7n	
	["黑鴉獵殺"] = 	{ class = "HUNTER", level = 30, }, --7n
	["致死重傷"] = 		{ class = "HUNTER", level = 30, }, --7n	
	["毒蛇獵人"] = 			{ class = "HUNTER", level = 30, }, --7n	
	["釘爪刺"] = 				{ class = "HUNTER", level = 60, }, --7n	
	["強化陷阱"] = 		{ class = "HUNTER", level = 60, }, --7n	
	["鋼鐵陷阱"] = 			{ class = "HUNTER", level = 60, }, --7n	
	["遊俠獵網"] = 			{ class = "HUNTER", level = 75, }, --7n	
	["黏性炸彈"] = 			{ class = "HUNTER", level = 75, }, --7n	
	["屠宰"] = 				{ class = "HUNTER", level = 90, }, --7n		
	["龍火手榴彈"] = 	{ class = "HUNTER", level = 90, }, --7n	
	["毒蛇釘刺"] = 		{ class = "HUNTER", level = 90, }, --7m	
	["陷阱專家"] = 		{ class = "HUNTER", level = 100, }, --7n		
	["噴液眼鏡蛇"] = 		{ class = "HUNTER", level = 100, }, --7n	
--++ Hunter PvP Talents ++
	["主人的呼喚"] = 		{ class = "HUNTER", level = 100, }, --7n
	["蜘蛛釘刺"] = 			{ class = "HUNTER", level = 100, }, --7n
	["狙擊射擊"] = 			{ class = "HUNTER", level = 100, }, --7n
	["代受"] = 			{ class = "HUNTER", level = 100, }, --7.2.5n	
	["凶暴野獸：石化蜥蜴"] = 	{ class = "HUNTER", level = 100, }, --7n
	["凶暴野獸：獵鷹"] = 		{ class = "HUNTER", level = 100, }, --7n
--	["Freezing Arrow"] = 		{ class = "HUNTER", level = 100, }, --7.1.5r
	["高爆陷阱"] = 	{ class = "HUNTER", level = 100, }, --7.1.5n	
	["冰凍之箭"] = 		{ class = "HUNTER", level = 100, }, --7n
	["癒合繃帶"] = 		{ class = "HUNTER", level = 100, }, --7n
	["驅散射擊"] = 			{ class = "HUNTER", level = 100, }, --7n

--++ Mage Abilities ++
	["幻象"] = 				{ class = "MAGE", level = 1, }, --7n?? Honor
	["冰霜新星"] = 			{ class = "MAGE", level = 3, },
	["閃現術"] = 				{ class = "MAGE", level = 7, },
	["變形術"] = 			{ class = "MAGE", level = 18, },
	["召喚餐點"] = 	{ class = "MAGE", level = 22, },
	["緩落術"] = 			{ class = "MAGE", level = 32, },
	["變形術"] = 			{ class = "MAGE", level = 32, }, --7n	
	["法術反制"] = 			{ class = "MAGE", level = 34, },
	["寒冰屏障"] = 			{ class = "MAGE", level = 26, }, --7.1.5m	
	["秘法語言學家"] = 		{ class = "MAGE", level = 58, }, --7n	
	["時間扭曲"] = 			{ class = "MAGE", level = 65, },	
	["法術竊取"] = 			{ class = "MAGE", level = 72, },
	["傳送門：達納蘇斯"] = 	{ class = "MAGE", level = 42, },
	["傳送門：艾克索達"] = 		{ class = "MAGE", level = 42, },
	["傳送門：鐵爐堡"] = 	{ class = "MAGE", level = 42, },
	["傳送門：奧格瑪"] = 	{ class = "MAGE", level = 42, },
	["傳送門：銀月城"] = 	{ class = "MAGE", level = 42, },
	["傳送門：奧格瑪"] = 	{ class = "MAGE", level = 42, },
	["傳送門：塞拉摩"] = 	{ class = "MAGE", level = 42, },
	["傳送門：雷霆崖"] =	{ class = "MAGE", level = 42, },
	["傳送門：幽暗城"] = 	{ class = "MAGE", level = 42, },	
	["傳送門：斯通納德"] = 		{ class = "MAGE", level = 52, },	
	["傳送：撒塔斯"] = 	{ class = "MAGE", level = 66, },	
	["遠古傳送：達拉然"] = { class = "MAGE", level = 74, }, 
	["傳送：達拉然－北裂境"] = { class = "MAGE", level = 74, }, --7n	
	["傳送門：達拉然－北裂境"] = { class = "MAGE", level = 74, }, --7n	
	["傳送門：托巴拉德"] = 	{ class = "MAGE", level = 85, },
	["傳送門：恆春谷"] = { class = "MAGE", level = 90, },
	["傳送門：暴風之盾"] = 	{ class = "MAGE", level = 92, }, --7n	
	["傳送門：戰爭之矛"] = 	{ class = "MAGE", level = 92, }, --7n	
	["傳送：守護者殿堂"] = { class = "MAGE", level = 14, }, --7n
	["傳送：達納蘇斯"] = 	{ class = "MAGE", level = 17, },
	["傳送：達納蘇斯"] = 		{ class = "MAGE", level = 17, },
	["傳送：鐵爐堡"] = 	{ class = "MAGE", level = 17, },
	["傳送：奧格瑪"] = 	{ class = "MAGE", level = 17, },
	["傳送：銀月城"] = 	{ class = "MAGE", level = 17, },
	["傳送：暴風城"] = 	{ class = "MAGE", level = 17, },
	["傳送：塞拉摩"] = 	{ class = "MAGE", level = 17, },
	["傳送：雷霆崖"] = { class = "MAGE", level = 17, },
	["傳送：幽暗城"] = 	{ class = "MAGE", level = 17, },
	["傳送：斯通納德"] = 	{ class = "MAGE", level = 52, },	
	["傳送：撒塔斯"] = 	{ class = "MAGE", level = 62, },
	["遠古傳送：達拉然"] = { class = "MAGE", level = 71, }, 
	["傳送：達拉然－破碎群島"] = 	{ class = "MAGE", level = 71, }, --7n
	["傳送門：達拉然－北裂境"] = 	{ class = "MAGE", level = 71, }, --7n	
	["傳送：托巴拉德"] = 	{ class = "MAGE", level = 85, },
	["傳送：恆春谷"] = { class = "MAGE", level = 90, }, 
	["傳送：暴風之盾"] = { class = "MAGE", level = 92, }, --7n	
	["傳送：戰爭之矛"] = 	{ class = "MAGE", level = 92, }, --7n	
--++ Mage Artifact Traits ++
	["亞魯涅斯印記"] = 		{ class = "MAGE", level = 100, }, --7n
	["鳳凰烈焰"] = 		{ class = "MAGE", level = 100, }, --7n
	["黯冰箭"] = 				{ class = "MAGE", level = 100, }, --7n
--++ Mage Specialization ++
	--++ Fire/Frost ++ 
	["隱形術"] = 			{ class = "MAGE", level = 50, }, --7m
	--++ Arcane ++
	["秘法衝擊"] = 			{ class = "MAGE", level = 10, }, 
	["秘法彈幕"] = 		{ class = "MAGE", level = 10, },	
	["秘法充能"] = 		{ class = "MAGE", level = 10, }, --7??
	["秘法飛彈"] = 		{ class = "MAGE", level = 14, },
	["位移"] = 			{ class = "MAGE", level = 24, }, --7n
	["稜彩屏障"] = 	{ class = "MAGE", level = 26, }, --7.1.5n	
	["魔爆術"] = 		{ class = "MAGE", level = 28, }, --x Moved
	["減速術"] = 					{ class = "MAGE", level = 36, },
	["喚醒"] = 			{ class = "MAGE", level = 40, }, --x Moved
	["秘法強化"] = 			{ class = "MAGE", level = 44, },
	["強效隱形"] = 	{ class = "MAGE", level = 50, }, --7m
	["氣定神閒"] = 		{ class = "MAGE", level = 15, }, --7.1.5m	
--	["Mage Armor"] = 			{ class = "MAGE", level = 56, }, --7.1.5r
	["法力學者"] =			 	{ class = "MAGE", level = 78, }, --7n	
	--++ Fire ++ 
 	["致命烈炎"] = 		{ class = "MAGE", level = 56, }, --7.1.5m
	["火球術"] = 				{ class = "MAGE", level = 10, },
	["炎爆術"] = 			{ class = "MAGE", level = 10, },
	["火焰衝擊"] = 			{ class = "MAGE", level = 11, }, --7m
	["焦炎之痕"] = 			{ class = "MAGE", level = 12, }, --7n
	["增強控火術"] = { class = "MAGE", level = 14, }, --7n	
	["龍之吐息"] = 		{ class = "MAGE", level = 24, }, 
	["熾炎屏障"] = 		{ class = "MAGE", level = 26, }, --7.1.5 	
	["燃灼"] = 			{ class = "MAGE", level = 28, },
	["炎甲術"] = 			{ class = "MAGE", level = 36, },
	["灼燒"] = 				{ class = "MAGE", level = 40, }, 	
	["烈焰風暴"] = 			{ class = "MAGE", level = 44, }, --x Moved	
	["燒灼"] = 			{ class = "MAGE", level = 52, }, --7.1.5m	
	["點燃"] = 				{ class = "MAGE", level = 80, },
	--++ Frost ++ 
	["寒冰箭"] = 			{ class = "MAGE", level = 1, },
	["冰霜長矛"] = 			{ class = "MAGE", level = 5, }, --x Moved
	["召喚水元素"] = { class = "MAGE", level = 10, },
	["碎冰"] = 				{ class = "MAGE", level = 12, }, --x Moved
--	["冰雪紛飛"] = 				{ class = "MAGE", level = 12, }, 7n Conflict
	["冰霜之指"] = 		{ class = "MAGE", level = 24, },
	["寒冰護體"] = 			{ class = "MAGE", level = 16, }, --7.1.5m		
	["腦部凍結"] = 			{ class = "MAGE", level = 28, },
	["冰錐術"] = 			{ class = "MAGE", level = 28, }, --7m	
	["冰寒脈動"] = 			{ class = "MAGE", level = 40, },
	["暴風雪"] = 				{ class = "MAGE", level = 44, }, --x Moved
	["急速冷卻"] = 			{ class = "MAGE", level = 30, }, --7.1.5m	
--	["Frost Armor"] = 			{ class = "MAGE", level = 56, }, --7.1.5r
	["冰柱"] = 				{ class = "MAGE", level = 78, },	
	["冰霜之球"] = 			{ class = "MAGE", level = 83, },
--++ Mage Talents ++
	["閃爍"] = 				{ class = "MAGE", level = 30, }, --7n
	["咒法之流"] = 		{ class = "MAGE", level = 45, }, --7n 
	["鏡像"] = 			{ class = "MAGE", level = 45, }, 
	["力之符文"] = 		{ class = "MAGE", level = 45, }, 
	["寒冰結界"] = 				{ class = "MAGE", level = 75, }, 	
	["霜之環"] = 		{ class = "MAGE", level = 75, }, 
	["不穩定的魔法"] = 		{ class = "MAGE", level = 90, }, 	
	--++ Arcane ++
	["增幅"] = 		{ class = "MAGE", level = 15, }, --7.1.5n
	["秘法魔寵"] = 		{ class = "MAGE", level = 15, }, --7n	
	["秘法真言"] = 		{ class = "MAGE", level = 15, }, --7n
	["法力護盾"] = 			{ class = "MAGE", level = 30, }, --7.1.5n
	["流動魔法"] = 			{ class = "MAGE", level = 30, }, --7.1.5n	
	["充能完成"] = 			{ class = "MAGE", level = 60, }, --7n	
	["共鳴"] = 			{ class = "MAGE", level = 60, }, --7n	
	["超級新星"] = 			{ class = "MAGE", level = 60, }, --x
	["時光轉移"] = 			{ class = "MAGE", level = 75, }, --7.1.5n
	["侵蝕"] = 				{ class = "MAGE", level = 90, }, --7n	
	["虛空暴雨"] = 		{ class = "MAGE", level = 90, }, --7n	
	["秘法光球"] = 			{ class = "MAGE", level = 100, }, --x
	["能量滿載"] = 			{ class = "MAGE", level = 100, }, --x
--	["秘法加速"] = 			{ class = "MAGE", level = 100, }, --7.1.5r
	["時光湧流"] = 		{ class = "MAGE", level = 100, }, --7.1.5n	
	--++ Fire ++ 
	["焚焰"] =			{ class = "MAGE", level = 15, }, --7n
	["縱火狂"] =			{ class = "MAGE", level = 15, }, --7n	
	["火焰狂熱"] = 			{ class = "MAGE", level = 15, }, --7m
	["衝擊波"] = 			{ class = "MAGE", level = 30, }, --7.1.5m
	["熾熱之魂"] = 			{ class = "MAGE", level = 30, }, --7.1.5n	
	["雅立史卓莎之怒"] = 	{ class = "MAGE", level = 60, }, --7.1.5n	
	["控制火勢"] =		{ class = "MAGE", level = 60, }, --7n
	["燃燒吧"] =				{ class = "MAGE", level = 60, }, --7n
	["狂暴加速"] = 		{ class = "MAGE", level = 75, }, --7.1.5n		
	["烈焰之地"] =			{ class = "MAGE", level = 90, }, --7n	
	["活體爆彈"] = 			{ class = "MAGE", level = 90, },
	["燼火風暴"] =			{ class = "MAGE", level = 100, }, --7n
	["引火"] = 				{ class = "MAGE", level = 100, }, --x
	["隕石"] = 				{ class = "MAGE", level = 100, }, --x
	--++ Frost ++ 
	["冰寒徹骨"] =			{ class = "MAGE", level = 15, }, --7n
	["孤寂寒冬"] =			{ class = "MAGE", level = 15, }, --7n	
	["冰霜射線"] =			{ class = "MAGE", level = 15, }, --7n
	["冰川絕熱"] = 	{ class = "MAGE", level = 30, }, --7.1.5n
	["浮冰"] = 			{ class = "MAGE", level = 30, }, --7.1.5m	
	["凍結之觸"] =			{ class = "MAGE", level = 60, }, --7n	
	["寒冰新星"] =	 			{ class = "MAGE", level = 60, }, --x
	["嚴寒之風"] = 			{ class = "MAGE", level = 75, }, --7.1.5n	
	["極地狂風"] =			{ class = "MAGE", level = 90, }, --7n 	
	["冰霜炸彈"] = 			{ class = "MAGE", level = 90, },
	["彗星風暴"] = 			{ class = "MAGE", level = 100, }, --x
	["冰川長槍"] =			{ class = "MAGE", level = 100, }, --7n	
	["熱能虛空"] = 			{ class = "MAGE", level = 100, }, --x
--++ Mage PvP Talents ++
	["時光護盾"] = 		{ class = "MAGE", level = 100, }, --7n
	["寒冰形體"] = 				{ class = "MAGE", level = 100, }, --7n
	["群體隱形術"] = 	{ class = "MAGE", level = 100, }, --7n
	["大炎爆術"] = 	{ class = "MAGE", level = 100, }, --7n

--++ Monk Abilities ++
--	["招架"]   = 				{ class = "MONK", level = 1, },	Conflict
	["虎掌"]   = 			{ class = "MONK", level = 1, },	
	["御風禪"] =   			{ class = "MONK", level = 1, },
	["滅寂腿"]   = 		{ class = "MONK", level = 3, },
	["迅空翻"]   = 				{ class = "MONK", level = 5, }, 
 	["嘲心嘯"]   = 			{ class = "MONK", level = 13, },  
 	["回命訣"]   = 		{ class = "MONK", level = 14, },
	["禪定歸宗"]   = 		{ class = "MONK", level = 20, },  
	["禪定歸宗:返"] = { class = "MONK", level = 30, },
	["碎玉轟雷掌"]  = { class = "MONK", level = 36, },  
	["點穴"]   = 			{ class = "MONK", level = 48, },  
	["超凡入聖"]   = 		{ class = "MONK", level = 87, },  
	["超凡入聖：轉"] = { class = "MONK", level = 87, },
--++ Monk Artifact Traits ++
	["爆炸桶"] = 		{ class = "MONK", level = 100, }, --7n
	["雪崙的贈禮"] = 		{ class = "MONK", level = 100, }, --7n
	["馭風打擊"] = { class = "MONK", level = 100, }, --7n
--++ Monk Specialization ++
	--++ Brewmaster/Mistweaver/Windwalker ++
	["流洩"]   = 				{ class = "MONK", level = 8, },	--7n
	["化毒袪病"]   = 				{ class = "MONK", level = 22, }, --7m
	--++ Brewmaster/Windwalker ++
--	["致命一擊"] =		{ class = "MONK", level = 1, }, --x Conflict
	["天矛鎖喉手"]   = 	{ class = "MONK", level = 32, }, --7m		
	--++ Mistweaver/Windwalker ++	
	["翔陽腳"] = 		{ class = "MONK", level =  18, }, --7m	
	["鶴旋踢"]   = { class = "MONK", level = 46, },  --7m	
	--++ Brewmaster ++ 
	["滅寂猛攻"]   = 	{ class = "MONK", level = 3, },	 --7n
	["酒罈破"]   = 			{ class = "MONK", level = 10, }, 
	["醉仙緩勁"]   = 			{ class = "MONK", level = 10, }, --7n	
	["火焰吐息"]   = 		{ class = "MONK", level = 18, },
 	["斗轉星移"]   = 			{ class = "MONK", level = 26, }, --7m 	
 	["金鐘絕釀"]   = 		{ class = "MONK", level = 28, }, --7n
	["玄牛之賜"]   = 		{ class = "MONK", level = 40, }, 
	["天尊籤詩"]   = 	{ class = "MONK", level = 45, }, --7n
	["清心絕釀"]   = 		{ class = "MONK", level = 54, }, 
	["冥思禪功"]   = 		{ class = "MONK", level = 65, }, 	
	["飄渺絕學"]   = 	{ class = "MONK", level = 78, },
	--++ Mistweaver ++ 	
	["迷霧繚繞"]   = 	{ class = "MONK", level = 10, },
	["舒和之霧"]   = 		{ class = "MONK", level = 10, }, 
	["僧院教義"] = { class = "MONK", level = 10, }, 	
	["回生迷霧"]   = 		{ class = "MONK", level = 24, }, 
	["氣繭護體"]   = 		{ class = "MONK", level = 28, }, 
	["生氣勃勃"]   = 				{ class = "MONK", level = 32, }, --7n 	
	["復甦"]   = 			{ class = "MONK", level = 44, }, --7n 	
 	["聚雷茶"]   = 	{ class = "MONK", level = 54, },
	["石形絕釀"]   = 	{ class = "MONK", level = 55, }, --7.2m	
	["精華之泉"]   = 		{ class = "MONK", level = 58, }, --7.2m	
	["五氣歸元"]   = 			{ class = "MONK", level = 65, }, 
	["洶湧迷霧"]   = 		{ class = "MONK", level = 78, }, --7n 	
	--++ Windwalker ++ 
	["猛虎式"] = { class = "MONK", level = 1, }, --7n
	["連段破"] = 		{ class = "MONK", level =  10, },
	["翔龍腳"] = 	{ class = "MONK", level =  10, },	
	["颶風連擊"] = 		{ class = "MONK", level =  12, }, --7n	
	["御風而行"] = 			{ class = "MONK", level =  12, }, --7n	 
	["因戰制宜"] = 	{ class = "MONK", level =  20, }, 
	["乾坤挪移"] = 		{ class = "MONK", level =  24, }, 
	["幽冥掌"]   = 		{ class = "MONK", level = 24, }, --7m
	["傷筋斷骨"]   = 			{ class = "MONK", level = 25, }, --x Moved	
	["轉生靈魄"] = 			{ class = "MONK", level =  26, }, 
	["狂拳連打"] = 		{ class = "MONK", level =  28, }, 
	["風、火、大地"] = { class = "MONK", level =  65, },
	["連環打"] = 		{ class = "MONK", level =  78, }, --7n	
--++ Monk Talents ++
	["真氣爆裂"]  = 			{ class = "MONK", level = 15, },
	["真氣波"]  = 			{ class = "MONK", level = 15, },  --7.2m	
	["迅靈身法"]  = 			{ class = "MONK", level = 30, },  
	["真氣飛龍穿"] = 			{ class = "MONK", level = 30, },  
	["猛虎出閘"] =  		{ class = "MONK", level = 30, }, 
	["掃葉腿"]  = 			{ class = "MONK", level = 60, }, 
	["和平之環"]  = 		{ class = "MONK", level = 60, }, 
	["卸勁訣"]  = 			{ class = "MONK", level = 75, },  
 	--++ Brewmaster/Windwalker ++
	["猛虎之眼"]  = 	{ class = "MONK", level = 15, }, --7n
	["召喚玄牛雕像"] = { class = "MONK", level = 60, }, --7.1.5m	
	["飛玉疾風"]  = 	{ class = "MONK", level = 90, },
	--++ Windwalker/Mistweaver ++ 	
	["祛魔訣"]  = 		{ class = "MONK", level = 75, }, --7.1.5m	
	--++ Brewmaster ++	
	["玄牛絕釀"]  = 		{ class = "MONK", level = 45, }, --7n
	["迷霧之賜"]  = 	{ class = "MONK", level = 45, }, --7n
	["清爽佳釀"]  = 		{ class = "MONK", level = 45, }, --7n
	["神秘活力"]  = 		{ class = "MONK", level = 75, }, --7.1.5n	
	["召喚玄牛怒兆"] = { class = "MONK", level = 90, }, --7n
	["特別快遞"]  = 	{ class = "MONK", level = 90, }, --7n
	["滅寂連打"]  = 		{ class = "MONK", level = 100, }, --7n
	["飄渺微步"]  = 		{ class = "MONK", level = 100, }, --7n
	["千杯不醉"]  = 		{ class = "MONK", level = 100, }, --7n
	--++ Mistweaver ++ 
 --	["Mistwalk"] = 				{ class = "MONK", level = 15, }, --7.2r 
	["禪心脈動"] = 			{ class = "MONK", level = 15, }, --7n
	["生生不息"] = 			{ class = "MONK", level = 45, }, --7n
	["迷霧裹身"] = 			{ class = "MONK", level = 45, }, --7n
	["鶴靈"] = 	{ class = "MONK", level = 45, }, --7n	
	["赤吉之歌"] = 		{ class = "MONK", level = 60, }, --7n
	["召喚紅鶴赤吉"] = { class = "MONK", level = 90, }, --7n
	["翠玉清風"] = 	{ class = "MONK", level = 90, }, --7n
	["召喚玉蛟雕像"] = { class = "MONK", level = 90, }, --7m
	["天雷聚頂"] = 		{ class = "MONK", level = 100, }, --7n	
	["法力茶"]   = 			{ class = "MONK", level = 100, }, --7m 	
	["破空雷擊"] = 		{ class = "MONK", level = 100, }, --7n
	--++ Windwalker ++ 	
	["昇華"]  = 			{ class = "MONK", level = 45, }, 	
	["凝神靈酒"] = 	{ class = "MONK", level =  45, }, --7n
	["聚氣打擊"]  = 		{ class = "MONK", level = 45, },
--	["Dizzying Kicks"]  = 		{ class = "MONK", level = 60, }, --7.1.5r
	["連珠狂拳"]  =	 		{ class = "MONK", level = 90, }, --7n
	["召喚白虎雪怒"] = { class = "MONK", level = 90, },
	["真氣環身"]  = 			{ class = "MONK", level = 100, }, --7n	
	["冰心訣"] = 				{ class = "MONK", level = 100, }, --x
	["迴龍升天破"] = { class = "MONK", level = 100, }, --7n	
--++ Monk PvP Talents ++
	["石形絕釀"] = 		{ class = "MONK", level = 100, }, --7.2m  
--	["迴焰之華"] = { class = "MONK", level = 100, }, --7.2.5r
	["虎眼絕釀"] = 		{ class = "MONK", level = 100, }, --7.2.5n
	["護身氣勁"] = 		 		{ class = "MONK", level = 100, }, --7n
	["雙酒罈"] = 		{ class = "MONK", level = 100, }, --7n
	["玄牛踢"] = 		{ class = "MONK", level = 100, }, --7n
	["治療玉"] = 		{ class = "MONK", level = 100, }, --7n
	["製造：靈動絕釀"] = 	{ class = "MONK", level = 100, }, --7n
	["仙鶴之道"] = 		{ class = "MONK", level = 100, }, --7n

--++ Paladin Abilities ++
--	["格擋"] =			 		{ class = "PALADIN", level = 1, }, --7n Conflict
	["無邊信念"] = 	{ class = "PALADIN", level = 1, },	
	["十字軍聖擊"] = 		{ class = "PALADIN", level = 1, },
--	["招架"]=					{ class = "PALADIN", level = 1, }, 7 Conflict	
	["審判"] = 				{ class = "PALADIN", level = 3, },	
	["清算之手"] = 	{ class = "PALADIN", level = 13, }, --7n
	["救贖"] = 			{ class = "PALADIN", level = 14, },
	["聖盾術"] = 		{ class = "PALADIN", level = 18, },
	["召喚主教的伊萊克"] = { class = "PALADIN", level = 20, },	--7n
	["召喚日行者科多獸"] = { class = "PALADIN", level = 20, },	--7n
	["召喚薩拉斯戰馬"] = { class = "PALADIN", level = 20, }, --7n
	["召喚戰馬"] = 		{ class = "PALADIN", level = 20, },	--7n	
	["聖療術"] = 			{ class = "PALADIN", level = 22, },
	["神性戰馬"] = 			{ class = "PALADIN", level = 28, }, --7n Hotfix	 	
	["沉思"] = 		{ class = "PALADIN", level = 40, },
	["十字軍之心"] = { class = "PALADIN", level = 40, },	
	["召喚戰騎"] = 		{ class = "PALADIN", level = 40, },	--7n
	["召喚大主教伊萊克"] = { class = "PALADIN", level = 40, }, --7n
	["召喚大型日行者科多獸"] = { class = "PALADIN", level = 40, }, --7n
	["召喚薩拉斯戰騎"] = { class = "PALADIN", level = 40, }, --7n
	["自由祝福"] = 	{ class = "PALADIN", level = 52, },	--7n
--++ Paladin Artifact Traits ++
	["提爾之眼"] = 			{ class = "PALADIN", level = 100, }, --7n
	["提爾救贖"] = 	{ class = "PALADIN", level = 100, }, --7n
	["灰燼甦醒"] = 		{ class = "PALADIN", level = 100, }, --7n
--++ Paladin Specialization ++
	--++ Holy/Protection/Retribution ++	
	["制裁之錘"] = 	{ class = "PALADIN", level = 5, }, --7m
	["聖光閃現"] = 		{ class = "PALADIN", level = 8, }, --7m	
	["保護祝福"] = { class = "PALADIN", level = 48, }, --7n
	["復仇之怒"] = 		{ class = "PALADIN", level = 72, }, --7m
	--++ Holy/Retribution ++	
	["聖佑術"] = 	{ class = "PALADIN", level = 26, }, --7m	
	["奉獻"] = 			{ class = "PALADIN", level = 32, }, --7m	
	["犧牲祝福"] = { class = "PALADIN", level = 56, }, --7n
	--++ Protection/Retribution ++ 
	["淨化毒素"] = 		{ class = "PALADIN", level = 21, }, --7n
	["責難"] = 				{ class = "PALADIN", level = 36, }, --7m
	--++ Holy ++
	["殉難者之光"] =  	{ class = "PALADIN", level = 1, }, --7n??
	["神聖震擊"] = 			{ class = "PALADIN", level = 10, },
	["淨化術"] = 				{ class = "PALADIN", level = 21, }, --7m
	["聖光信標"] = 		{ class = "PALADIN", level = 36, },
--	["赦免"] = 			{ class = "PALADIN", level = 44, },	--7n Conflict
	["聖光灌注"] = 	{ class = "PALADIN", level = 50, },
	["正義"] = 		{ class = "PALADIN", level = 50, }, --7n
	["聖光術"] = 			{ class = "PALADIN", level = 54, },
	["黎明曙光"] = 		{ class = "PALADIN", level = 58, },
	["精通光環"] = 			{ class = "PALADIN", level = 65, },	--7n
	["光明使者"] = 			{ class = "PALADIN", level = 78, },	--7n
	--++ Protection ++ 
	["復仇之盾"] = 		{ class = "PALADIN", level = 10, },
	["聖光守護"] = 	{ class = "PALADIN", level = 10, },
	["公正之錘"] = { class = "PALADIN", level = 10, },	
	["正義之怒"] = 		{ class = "PALADIN", level = 10, }, --7m
	["庇護"] = 			{ class = "PALADIN", level = 10, },	
	["守護之光"] = { class = "PALADIN", level = 12, }, --7n
	["睿智審判"] = { class = "PALADIN", level = 28, },
	["公正之盾"] = { class = "PALADIN", level = 38, },
	["大十字軍"] = 		{ class = "PALADIN", level = 50, },
	["忠誠防衛者"] = 		{ class = "PALADIN", level = 65, },	
--	["還擊"] =		 		{ class = "PALADIN", level = 76, }, --7 Conflict
	["神聖壁壘"] = 		{ class = "PALADIN", level = 78, },
	["遠古諸王守護者"] = { class = "PALADIN", level = 83, },		
	--++ Retribution ++  
	["聖殿騎士之裁決"] = 	{ class = "PALADIN", level = 10, },
--	["Sword of Light"] = 		{ class = "PALADIN", level = 12, }, remove
	["正義之刃"] = 		{ class = "PALADIN", level = 16, }, --7n
	["復仇聖盾"] = 	{ class = "PALADIN", level = 24, }, --7n	
	["封阻之手"] = 	{ class = "PALADIN", level = 26, }, --7n
	["神性風暴"] = 			{ class = "PALADIN", level = 32, },
--	["Greater Blessing of Might"] = { class = "PALADIN", level = 42, }, --7.1.5r
	["強效王者祝福"] = { class = "PALADIN", level = 44, }, --7n	
	["強效智慧祝福"] = { class = "PALADIN", level = 46, }, --7n
	["懲戒"] =			{ class = "PALADIN", level = 56, }, --7n
	["神性審判"] =		{ class = "PALADIN", level = 78, }, --7n
--++ Paladin Talents ++
--	["馳馭駿馬"] = 				{ class = "PALADIN", level = 30, }, --7n hotfix 60 Prot, 90 Ret
	["盲目之光"] = 		{ class = "PALADIN", level = 45, }, 
	["懺悔"] = 			{ class = "PALADIN", level = 45, },
	["光明審判"] = 	{ class = "PALADIN", level = 90, }, --7.1.5m	
	--++ Holy/Protection ++ 
	["制裁之拳"] = 		{ class = "PALADIN", level = 45, }, --7.1.5m
	--++ Holy ++	
	["賦予信念"] = 			{ class = "PALADIN", level = 15, },	--7n
	["十字軍之力"] = 		{ class = "PALADIN", level = 15, },	--7n
	["聖光之錘"] = 		{ class = "PALADIN", level = 15, },
	["依法而治"] =			{ class = "PALADIN", level = 30, },	--7n
	["不屈精神"] =	{ class = "PALADIN", level = 30, },
	["慈悲光環"] = 		{ class = "PALADIN", level = 60, }, --7n	
	["犧牲光環"] = 	{ class = "PALADIN", level = 60, }, --7n	
	["虔誠光環"] = 		{ class = "PALADIN", level = 60, }, --7m
	["神聖意圖"] = 		{ class = "PALADIN", level = 75, }, --7??
	["神聖復仇者"] = 			{ class = "PALADIN", level = 75, },
	["神聖稜石"] = 			{ class = "PALADIN", level = 75, },
	["熾熱殉難者"] = 		{ class = "PALADIN", level = 90, }, --7n
	["聖化之怒"] = 		{ class = "PALADIN", level = 90, },	
	["虔信信標"] =		{ class = "PALADIN", level = 100, }, --x
	["光明使者信標"] = { class = "PALADIN", level = 100, }, --7n
	["美德信標"] =		{ class = "PALADIN", level = 100, }, --7n
	--++ Protection ++ 
	["聖光堡壘"] = 		{ class = "PALADIN", level = 15, },	--7n
	["十字軍的審判"] = 	{ class = "PALADIN", level = 15, },	--7n
	["復仇先行者"] = 		{ class = "PALADIN", level = 15, },	--7n
	["祝福之錘"] = 		{ class = "PALADIN", level = 30, },	--7n
	["奉獻戰錘"] = 	{ class = "PALADIN", level = 30, },	--7n
	["神聖之盾"] = 			{ class = "PALADIN", level = 30, }, --x
	["救贖祝福"] = { class = "PALADIN", level = 60, },	--7n
	["抗咒祝福"] =  { class = "PALADIN", level = 60, },	--7n
	["懲罰光環"] = 		{ class = "PALADIN", level = 60, },	--7n
	["屹立不搖"] = 			{ class = "PALADIN", level = 75, },	--7n
	["保衛者之手"] = { class = "PALADIN", level = 75, },	--7n	
	["聖殿騎兵"] = 		{ class = "PALADIN", level = 75, },	--7n
	["聖光禦盾"] = 		{ class = "PALADIN", level = 90, },	--7n
	["神聖之地"] = 	{ class = "PALADIN", level = 90, },	--7n
	["最後防禦者"] = 		{ class = "PALADIN", level = 100, }, --7n
	["公正守衛者"] = 	{ class = "PALADIN", level = 100, }, --7n 	
	["六翼天使"] = 				{ class = "PALADIN", level = 100, }, --x
	--++ Retribution ++ 	
	["奉獻"] = 			{ class = "PALADIN", level = 15, }, --7n
	["死刑宣判"] = 	{ class = "PALADIN", level = 15, },	
	["最終裁決"] = 		{ class = "PALADIN", level = 15, }, --7n
	["強效審判"] = 		{ class = "PALADIN", level = 30, }, --7n
	["正義怒火"] = 	{ class = "PALADIN", level = 30, }, --7n
	["狂熱"] = 					{ class = "PALADIN", level = 30, }, --7n
	["制裁之拳"] = 		{ class = "PALADIN", level = 45, }, --7.1.5n	
	["憤怒之刃"] = 		{ class = "PALADIN", level = 60, }, --7n
	["神聖之錘"] = 		{ class = "PALADIN", level = 60, }, --7n
	["聖德之刃"] = 		{ class = "PALADIN", level = 60, }, --7n
	["以眼還眼"] = 		{ class = "PALADIN", level = 75, }, --7n
	["審判者的復仇"] = 	{ class = "PALADIN", level = 75, }, --7n
	["榮耀聖言"] = 		{ class = "PALADIN", level = 75, }, --7n
	["神聖干涉"] = 	{ class = "PALADIN", level = 90, }, --7n
	["光明審判"] = 	{ class = "PALADIN", level = 90, }, --7.1.5n	
--	["Seal of Light"] = 		{ class = "PALADIN", level = 90, }, --7.1.5r
	["十字軍"] = 				{ class = "PALADIN", level = 100, }, --7n	
	["神聖意圖"] = 	 	{ class = "PALADIN", level = 100, }, --7n	
	["神聖憤怒"] = 			{ class = "PALADIN", level = 100, }, --7m
--++ Paladin PvP Talents ++
	["縮小"] = 	{ class = "PALADIN", level = 100, }, --7n
	["庇護祝福"] = { class = "PALADIN", level = 100, }, --7n
	["神恩術"] = 			{ class = "PALADIN", level = 100, }, --7n
	["美德之盾"] = 		{ class = "PALADIN", level = 100, }, --7n
	["復仇十字軍"] = 	{ class = "PALADIN", level = 100, }, --7n
	["遺忘女王守護者"] = { class = "PALADIN", level = 100, }, --7n

--++ Priest Abilities ++
	["懺悔者"] = 			{ class = "PRIEST", level = 1, }, --7.2.5m
	["懲擊"] = 				{ class = "PRIEST", level = 1, },
	["真言術：壁"] = 	{ class = "PRIEST", level = 5, }, --7m??
	["復活術"] = 			{ class = "PRIEST", level = 14, },
	["驅散魔法"] = 			{ class = "PRIEST", level = 26, },
	["束縛不死生物"] = 		{ class = "PRIEST", level = 32, },
	["精神控制"] = 			{ class = "PRIEST", level = 36, }, --7m
	["漸隱術"] = 					{ class = "PRIEST", level = 38, },
	["群體驅魔"] = 			{ class = "PRIEST", level = 72, },
--++ Priest Artifact Traits ++
	["杜爾之光"] = 		{ class = "PRIEST", level = 100, }, --7n
	["聖光之怒"] = 		{ class = "PRIEST", level = 100, }, --7n
	["虛無洪流"] = 			{ class = "PRIEST", level = 100, }, --7n
--++ Priest Specialization ++
	--++ Discipline/Holy/Shadow ++
	["漂浮術"] = 				{ class = "PRIEST", level = 28, }, --7m	
	--++ Discipline/Holy ++
	["驅淨術"] = 				{ class = "PRIEST", level = 22, },
	["意志專注"] = 			{ class = "PRIEST", level = 34, },
	["群體復活"] = 	{ class = "PRIEST", level = 44, }, --7n
	["虔信之躍"] = 		{ class = "PRIEST", level = 83, }, --7m
	--++ Discipline/Shadow ++
	["暗影癒合"] = 			{ class = "PRIEST", level = 1, }, --7n		
	["暗言術：痛"] = 	{ class = "PRIEST", level = 3, }, --7m
	["真言術：盾"] = 	{ class = "PRIEST", level = 5, }, --7m	
	["心靈尖嘯"] = 		{ class = "PRIEST", level = 12, }, --7m
	["暗影惡魔"] = 			{ class = "PRIEST", level = 42, }, --7m	
	["心靈幻象"] = 			{ class = "PRIEST", level = 42, }, --7m	
	--++ Discipline ++
	["祈求"] = 					{ class = "PRIEST", level = 7, }, --7n	
	["懺悟"] = 				{ class = "PRIEST", level = 10, },
	["贖罪"] = 			{ class = "PRIEST", level = 24, },
	["真言術：輝"] = 	{ class = "PRIEST", level = 46, }, --7n	
	["狂喜"] = 				{ class = "PRIEST", level = 50, },	
	["痛苦鎮壓"] = 		{ class = "PRIEST", level = 56, },
	--++ Holy ++
	["快速治療"] = 			{ class = "PRIEST", level = 10, }, --7m
	["恢復"] = 				{ class = "PRIEST", level = 10, }, 
	["神聖之火"] = 			{ class = "PRIEST", level = 18, }, --7m	
	["聖言術：寧"] = 	{ class = "PRIEST", level = 18, }, --7n	
	["聖言術：譴"] = 	{ class = "PRIEST", level = 24, },
	["救贖之靈"] = 	{ class = "PRIEST", level = 29, },
	["治療術"] = 					{ class = "PRIEST", level = 34, },
	["治療禱言"] = 	{ class = "PRIEST", level = 40, },
	["機緣回復"] = 			{ class = "PRIEST", level = 42, },	
	["聖言術：庇"] = 	{ class = "PRIEST", level = 50, }, --7n
	["絕望禱言"] = 		{ class = "PRIEST", level = 52, }, --7.1.5m
	["守護聖靈"] = 		{ class = "PRIEST", level = 54, },	
	["癒合禱言"] = 	{ class = "PRIEST", level = 58, }, --7m	
	["神聖新星"] = 			{ class = "PRIEST", level = 65, },
	["神聖禮頌"] = 			{ class = "PRIEST", level = 76, },
	["光明迴響"] = 		{ class = "PRIEST", level = 78, },
	--++ Shadow ++
	["精神鞭笞"] = 			{ class = "PRIEST", level = 10, },
	["虛無箭"] = 			{ class = "PRIEST", level = 10, }, --7n
	["虛無爆發"] = 		{ class = "PRIEST", level = 10, }, --7n
	["虛無形態"] = 				{ class = "PRIEST", level = 10, }, --7n
	["暗影形態"] = 			{ class = "PRIEST", level = 12, }, --7.1n
	["心靈震爆"] = 			{ class = "PRIEST", level = 16, }, 
	["驅淨疾病"] = 		{ class = "PRIEST", level = 22, }, --7n
	["吸血之觸"] = 		{ class = "PRIEST", level = 24, },
	["心靈烙印"] = 			{ class = "PRIEST", level = 76, }, --7m	
	["暗言術：死"] = 	{ class = "PRIEST", level = 28, }, --7??	
	["暗影幻靈"] = 	{ class = "PRIEST", level = 34, },
	["沉默"] = 				{ class = "PRIEST", level = 50, },
	["影散"] = 			{ class = "PRIEST", level = 58, },
	["吸血鬼的擁抱"] = 		{ class = "PRIEST", level = 65, },
	["暗影癲狂"] = 				{ class = "PRIEST", level = 78, }, --7n	
--++ Priest Talents ++
	--++ Discipline/Holy ++	
	["天使之羽"] = 		{ class = "PRIEST", level = 30, },	
	["閃耀聖力"] = 		{ class = "PRIEST", level = 45, }, --7n	
	["神性之星"] = 			{ class = "PRIEST", level = 90, },	
	["輝環"] = 					{ class = "PRIEST", level = 90, },	
	--++ Discipline/Shadow ++	
	["身心合一"] = 		{ class = "PRIEST", level = 30, },
	["受虐"] = 			{ class = "PRIEST", level = 30, }, --7n	
	["主導意志"] = 		{ class = "PRIEST", level = 45, },
	["心靈之聲"] = 		{ class = "PRIEST", level = 45, }, --7n
	["屈心魔"] = 			{ class = "PRIEST", level = 60, },	
	["注入能量"] = 		{ class = "PRIEST", level = 75, },
	--++ Discipline ++	
	["厲懲"] = 			{ class = "PRIEST", level = 15, }, --7n
	["暗影分裂"] = 				{ class = "PRIEST", level = 15, }, --7n
	["真言術：慰"] = 	{ class = "PRIEST", level = 60, }, --7n
	["護盾戒律"] = 	{ class = "PRIEST", level = 60, }, --7n
--	["Contrition"] = 			{ class = "PRIEST", level = 75, }, --7.2.5r
	["意志清明"] = 		{ class = "PRIEST", level = 75, }, --7.2.5m
	["庇護"] = 			{ class = "PRIEST", level = 75, }, --7.2.5n	
	["暗影聖約"] = 		{ class = "PRIEST", level = 75, }, --7.2.5m
	["驅淨邪惡"] = 		{ class = "PRIEST", level = 90, }, --7.2.5m	
	["恩典"] = 				{ class = "PRIEST", level = 100, }, --7
	["佈道"] = 			{ class = "PRIEST", level = 100, }, --7.2.5n	
	--++ Shadow ++	
	["命運無常"] = 		{ class = "PRIEST", level = 75, },		
	--++ Holy ++
	["持續恢復"] = 		{ class = "PRIEST", level = 15, }, --7n
	["啟蒙"] = 		{ class = "PRIEST", level = 15, }, --7m
	["聖光顯跡"] = 		{ class = "PRIEST", level = 15, }, --7n
	["身心合一"] = 		{ class = "PRIEST", level = 30, }, --7n
	["不撓意志"] = 			{ class = "PRIEST", level = 30, }, --7.1.5n
	["來生"] = 			{ class = "PRIEST", level = 45, }, --7n
	["譴責"] = 				{ class = "PRIEST", level = 45, }, --7n
	["守護天使"] = 		{ class = "PRIEST", level = 60, }, --7n	
	["那魯之光"] =	{ class = "PRIEST", level = 60, }, --7n	
	["希望象徵"] = 		{ class = "PRIEST", level = 60, }, --7n	
	["束縛治療"] = 			{ class = "PRIEST", level = 75, }, --7m
	["虔敬"] = 				{ class = "PRIEST", level = 75, }, --7n	
	["光之澎湃"] = 		{ class = "PRIEST", level = 75, }, --7n
	["聖潔"] = 				{ class = "PRIEST", level = 90, }, --7n
	["神化"] = 			{ class = "PRIEST", level = 100, }, --7n
	["祈福"] = 			{ class = "PRIEST", level = 100, }, --7n
	["治療之環"] = 	{ class = "PRIEST", level = 100, }, --7m
	--++ Shadow ++
	["心靈要塞"] = 	{ class = "PRIEST", level = 15, }, --7n
	["暗言術：無"] = 	{ class = "PRIEST", level = 15, }, --7n
	["瘋狂"] = 				{ class = "PRIEST", level = 30, }, --7n
--	["心靈炸彈"] = 			{ class = "PRIEST", level = 45, }, --7.1.5r
	["瘋狂殘念"] = 	{ class = "PRIEST", level = 60, }, --7.1.5n	
	["奪魂之言"] = 		{ class = "PRIEST", level = 60, }, --7n
--	["瘋狂殘念"] = 			{ class = "PRIEST", level = 60, }, --7.1.5r
	["虛無射線"] = 				{ class = "PRIEST", level = 60, }, --7n
	["祥瑞之靈"] = 	{ class = "PRIEST", level = 75, }, 
	["煞婪"] = 				{ class = "PRIEST", level = 75, }, --7n
	["幽暗洞察"] = 		{ class = "PRIEST", level = 75, }, --7n
	["悲慘"] = 				{ class = "PRIEST", level = 90, }, --7.1.5n	
	["暗影暴擊"] = 			{ class = "PRIEST", level = 100, }, --7.1.5m
	["殘遺虛無"] = 	{ class = "PRIEST", level = 100, }, --7n
--	["心靈鑽刺"] = 			{ class = "PRIEST", level = 100, }, --7.1.5r
	["獻身瘋狂"] = 	{ class = "PRIEST", level = 100, }, --7n
--++ Priest PvP Talents ++
	["虛空移形"] = 			{ class = "PRIEST", level = 100, }, --7n
	["心靈專注"] = 			{ class = "PRIEST", level = 100, }, --7n
	["希望曙光"] = 			{ class = "PRIEST", level = 100, }, --7n
	["大天使"] = 			{ class = "PRIEST", level = 100, }, --7n
	["預示"] = 			{ class = "PRIEST", level = 100, }, --7n
	["懼靈魔"] = 				{ class = "PRIEST", level = 100, }, --7n
	["真言術：韌"] = { class = "PRIEST", level = 100, }, --7n
	["強效漸隱術"] = 			{ class = "PRIEST", level = 100, }, --7n
	["神聖結界"] = 			{ class = "PRIEST", level = 100, }, --7n
	["救贖者靈魂"] = { class = "PRIEST", level = 100, }, --7n

--++ Rogue Abilities ++
--	["致命一擊"] = 		{ class = "DRUID", level = 1, }, --x Conflict
	["偵測"] = 			{ class = "ROGUE", level = 1, }, --7m
--	["招架"]=					{ class = "ROGUE", level = 1, }, 7 Conflict		
	["赤紅藥瓶"] = 			{ class = "ROGUE", level = 14, }, --7n	
	["腳踢"] = 					{ class = "ROGUE", level = 18, },
	["開鎖"] = 			{ class = "ROGUE", level = 24, },
	["疾跑"] = 				{ class = "ROGUE", level = 26, },
	["偵測陷阱"] = 			{ class = "ROGUE", level = 42, },
	["暗影披風"] = 		{ class = "ROGUE", level = 58, },
	["迅足"] = 			{ class = "ROGUE", level = 62, },
	["安全降落"] = 			{ class = "ROGUE", level = 48, }, 	
	["飛舞刀刃"] = 		{ class = "ROGUE", level = 66, }, --7??
	["偷天換日"] = 	{ class = "ROGUE", level = 78, },
--++ Rogue Artifact Traits ++
	["驚懼雙刀的詛咒"] = { class = "ROGUE", level = 100, }, --7n
	["破喉之咬"] = 		{ class = "ROGUE", level = 100, }, --7n
	["王禍"] = 			{ class = "ROGUE", level = 100, }, --7n
--++ Rogue Specialization ++
	--++ Assassination/Outlaw/Subtlety ++  
	["潛行"] = 				{ class = "ROGUE", level = 5, }, --7m	
	["悶棍"] = 					{ class = "ROGUE", level = 12, }, --7m
	["偷竊"] = 			{ class = "ROGUE", level = 16, }, --7m
	["致盲"] = 				{ class = "ROGUE", level = 24, }, --7.1.5m		
	["擾亂"] = 				{ class = "ROGUE", level = 28, }, --7m	
	["偷襲"] = 			{ class = "ROGUE", level = 30, }, --7m	
	["消失"] = 				{ class = "ROGUE", level = 32, }, --7m	
	--++ Assassination/Subtlety ++  
	["閃避"] = 				{ class = "ROGUE", level = 8, }, --7m	
	["暗影閃現"] = 			{ class = "ROGUE", level = 13, }, --7m
	["腎擊"] = 			{ class = "ROGUE", level = 40, }, --7m	
	--++ Assassination ++  
	["截肢"] = 				{ class = "ROGUE", level = 1, },
	["致命毒藥"] = 		{ class = "ROGUE", level = 2, }, --7m
	["毒化"] = 				{ class = "ROGUE", level = 3, },
	["刺客的決心"] = 	{ class = "ROGUE", level = 10, },
	["強化毒藥"] = 		{ class = "ROGUE", level = 10, },
	["劇毒匕首"] = 		{ class = "ROGUE", level = 10, }, --7n
	["切中要害"] = 		{ class = "ROGUE", level = 20, }, 
	["割裂"] = 				{ class = "ROGUE", level = 22, }, --7m	
	["劇毒創傷"] = 		{ class = "ROGUE", level = 22, },
	["致傷毒藥"] = 			{ class = "ROGUE", level = 25, }, --7m	
	["封印命運"] = 			{ class = "ROGUE", level = 27, },
	["致殘毒藥"] = 		{ class = "ROGUE", level = 38, }, --7.1.5m	
	["絞喉"] = 				{ class = "ROGUE", level = 48, }, --7m
	["宿怨"] = 				{ class = "ROGUE", level = 72, },
	["強烈毒藥"] = 		{ class = "ROGUE", level = 78, },
	--++ Outlaw ++  	
--	["還擊"] = 				{ class = "ROGUE", level = 10, }, -- Conflict
	["刺穿"] = 			{ class = "ROGUE", level = 10, }, --7n
	["刀劍斬擊"] = 			{ class = "ROGUE", level = 10, }, --7n
	["活力"] = 				{ class = "ROGUE", level = 10, },	
	["手槍射擊"] = 			{ class = "ROGUE", level = 12, }, --7n
	["伏擊"] = 				{ class = "ROGUE", level = 14, }, --7m
	["鑿擊"] = 				{ class = "ROGUE", level = 22, }, --7m	
	["正中眉心"] = 		{ class = "ROGUE", level = 25, }, --7n
	["無情"] = 			{ class = "ROGUE", level = 27, },
	["作戰潛能"] = 		{ class = "ROGUE", level = 34, },
	["命運之骰"] = 		{ class = "ROGUE", level = 36, }, --7n
	["劍刃亂舞"] = 			{ class = "ROGUE", level = 48, },	
	["不息之刃"] = 		{ class = "ROGUE", level = 50, },
	["收買"] = 				{ class = "ROGUE", level = 54, }, --7n	
	["能量刺激"] = 		{ class = "ROGUE", level = 72, },
	["左右開弓"] = 			{ class = "ROGUE", level = 78, },
	--++ Subtlety ++
	["背刺"] = 				{ class = "ROGUE", level = 10, },
	["恢復活力"] = 	{ class = "ROGUE", level = 10, },
	["剔骨"] = 			{ class = "ROGUE", level = 10, }, --7m
	["手裏劍"] = 		{ class = "ROGUE", level = 11, }, --7m
	["暗影打擊"] = 		 	{ class = "ROGUE", level = 22, }, --7n
	["暗影技法"] = 	{ class = "ROGUE", level = 27, }, --7n
	["死亡徵兆"] = 		{ class = "ROGUE", level = 34, }, --7n
	["暗影之舞"] = 			{ class = "ROGUE", level = 36, },
	["深邃暗影"] = 	{ class = "ROGUE", level = 42, }, --7n
	["夜刃"] = 			{ class = "ROGUE", level = 46, }, --7n	
	["無情打擊"] = 	{ class = "ROGUE", level = 50, }, 	
	["手裏劍風暴"] = 		{ class = "ROGUE", level = 66, }, --7n
	["連發手裏劍"] = 		{ class = "ROGUE", level = 70, }, --7.2.5n	
	["暗影之刃"] = 		{ class = "ROGUE", level = 72, }, --7m	
	["處決者"] = 			{ class = "ROGUE", level = 78, },
--++ Rogue Talents ++
	["預知"] = 			{ class = "ROGUE", level = 45 }, 
	["精明戰略"] = 		{ class = "ROGUE", level = 45 }, --7n	
	["精力"] = 				{ class = "ROGUE", level = 45 }, --7n	
	["死亡謊言"] = 			{ class = "ROGUE", level = 60, }, 
	["隱匿"] = 			{ class = "ROGUE", level = 60, }, 
	["欺壓弱小"] = 		{ class = "ROGUE", level = 75, }, 
	["矯捷"] = 				{ class = "ROGUE", level = 90, }, --7n
	["死從天降"] = 		{ class = "ROGUE", level = 100, },
	["死亡標記"] =		{ class = "ROGUE", level = 100, }, 
	--++ Assassination/Subtlety ++  
	["夜巡者"] = 			{ class = "ROGUE", level = 30, },
	["暗影專注"] = 			{ class = "ROGUE", level = 30, },	
	["欺敵"] = 			{ class = "ROGUE", level = 30, },	
	--++ Assassination ++ 
	["精密計畫"] = 	{ class = "ROGUE", level = 15, }, --7n
	["出血"] = 			{ class = "ROGUE", level = 15, }, --7m	
	["毒藥大師"] = 		{ class = "ROGUE", level = 15, }, --7m
	["吸血毒藥"] = 		{ class = "ROGUE", level = 60, },
	["內出血"] = 	{ class = "ROGUE", level = 75, }, --x
	["殺人不見血"] = 				{ class = "ROGUE", level = 75, }, --7n	
--	["Agonizing Poison"] = 		{ class = "ROGUE", level = 90, }, --7.2.5r	
	["放血"] = 			{ class = "ROGUE", level = 90, }, --7n	
	["劇毒之刃"] = 			{ class = "ROGUE", level = 90, }, --7.2.5n	
	["毒液刺激"] = 			{ class = "ROGUE", level = 100, }, --x
	--++ Outlaw ++ 	
	["鬼魅攻擊"] = 		{ class = "ROGUE", level = 15, }, --7n
	["快速拔槍"] = 			{ class = "ROGUE", level = 15, }, --7n
	["劍術師"] = 			{ class = "ROGUE", level = 15, }, --7n
	["特技打擊"] = 	{ class = "ROGUE", level = 30, }, --7n
	["繩鉤"] = 		{ class = "ROGUE", level = 30, }, --7n
	["打帶跑"] = 			{ class = "ROGUE", level = 30, }, --7n
	["鐵胃"] = 			{ class = "ROGUE", level = 60, }, --7n
	["卑鄙手段"] = 			{ class = "ROGUE", level = 75, },
	["談判"] = 				{ class = "ROGUE", level = 75, }, --7n
	["砲彈彈幕"] = 	{ class = "ROGUE", level = 90, }, --7n
	["狂舞殘殺"] = 		{ class = "ROGUE", level = 90, }, --7m
	["切割"] = 		{ class = "ROGUE", level = 100, }, --7m	
	--++ Subtlety ++  	
	["幽暗刃"] = 			{ class = "ROGUE", level = 15, }, --7n	
	["敏銳大師"] = 	{ class = "ROGUE", level = 15 }, --7m
	["武器大師"] = 			{ class = "ROGUE", level = 15, }, --7n
	["靜謐黑暗"] = 	{ class = "ROGUE", level = 60, }, --7n
	["暗影突襲"] = { class = "ROGUE", level = 75, }, --7n
	["糾纏暗影"] = 		{ class = "ROGUE", level = 75 }, --7n
	["漆黑暗影"] = 			{ class = "ROGUE", level = 90 }, --7.2.5n	
	["暗影籠罩"] = 	{ class = "ROGUE", level = 100, }, --7n
--	["預謀"] = 		{ class = "ROGUE", level = 90, }, --7.2.5r
	["暗影大師"] = 	{ class = "ROGUE", level = 100, }, --7n
--++ Rogue PvP Talents ++
--	["急起直追"] = 		{ class = "ROGUE", level = 100, }, --7.2.5r
	["掠奪護甲"] = 		{ class = "ROGUE", level = 100, }, --7n
	["神經毒素"] = 			{ class = "ROGUE", level = 100, }, --7.2.5m
	["暗影決鬥"] = 			{ class = "ROGUE", level = 100, }, --7n
	["卸除武裝"] = 			{ class = "ROGUE", level = 100, }, --7n
	["煙霧彈"] = 			{ class = "ROGUE", level = 100, }, --7n
	["冷血"] = 			{ class = "ROGUE", level = 100, }, --7n
	["毒襲"] = 					{ class = "ROGUE", level = 100, }, --7.2.5m	

--++ Shaman Abilities ++
	["中止圖騰"] = 		{ class = "SHAMAN", level = 1, }, --7n??
	["先祖之魂"] = 		{ class = "SHAMAN", level = 14, },
	["鬼魂之狼"] = 			{ class = "SHAMAN", level = 16, },
	["水上行走"] = 		{ class = "SHAMAN", level = 24, },
	["視界術"] = 			{ class = "SHAMAN", level = 36, },
	["妖術"] = 					{ class = "SHAMAN", level = 42, },
	["星界傳送"] = 		{ class = "SHAMAN", level = 44, },	
	["星界轉移"] = 			{ class = "SHAMAN", level = 52, },	
	["淨魔術"] = 				{ class = "SHAMAN", level = 58, },	
	["嗜血術"] = 			{ class = "SHAMAN", level = 65, },
	["英勇氣概"] = 				{ class = "SHAMAN", level = 65, },
--++ Shaman Artifact Traits ++
	["末日之風"] = 			{ class = "SHAMAN", level = 100, }, --7n
	["女王之賜"] = 	{ class = "SHAMAN", level = 100, }, --7n
	["風暴守護者"] = 			{ class = "SHAMAN", level = 100, }, --7n
--++ Shaman Specialization ++
	--++ Elemental/Enhancement/Restoration ++
	["閃電箭"] = 		{ class = "SHAMAN", level = 1, }, --7m		
	["洶湧治療"] = 		{ class = "SHAMAN", level = 7, }, --7m		
	["削風術"] = 			{ class = "SHAMAN", level = 22, }, --7m	
	--++ Elemental/Enhancement ++
	["洶湧治療"] = 	{ class = "SHAMAN", level = 3, }, --7n??	
	["淨化靈魂"] = 		{ class = "SHAMAN", level = 18, }, --7m
	--++ Elemental/Restoration ++ 
	["烈焰震擊"] = 			{ class = "SHAMAN", level = 3, }, --7m	
	["熔岩爆發"] = 			{ class = "SHAMAN", level = 12, },
	["閃電鏈"] = 		{ class = "SHAMAN", level = 28, }, --7m		
	["熔岩奔騰"] = 			{ class = "SHAMAN", level = 38, },	
	--++ Elemental ++ 
	["撼天雷電"] = 			{ class = "SHAMAN", level = 1, },	
	["大地震擊"] = 			{ class = "SHAMAN", level = 3, }, --x 
	["元素之怒"] = 		{ class = "SHAMAN", level = 10, }, 
	["恢復薩滿"] = 	{ class = "SHAMAN", level = 10, },	
	["雷霆風暴"] = 			{ class = "SHAMAN", level = 16, },
	["冰霜震擊"] = 			{ class = "SHAMAN", level = 22, }, --7m
	["元素集中"] = 		{ class = "SHAMAN", level = 40, }, 
	["火元素"] = 		{ class = "SHAMAN", level = 48, }, --7n	
	["地震術"] = 		{ class = "SHAMAN", level = 52, }, --7n	 
	["土元素"] = 		{ class = "SHAMAN", level = 72, }, --7n	
	["元素超載"] = 	{ class = "SHAMAN", level = 78, },
	--++ Enhancement ++
--	["致命一擊"] = 		{ class = "DRUID", level = 1, }, --x Conflict
	["熔岩暴擊"] = 			{ class = "SHAMAN", level = 10, },
	["石化打擊"] = 			{ class = "SHAMAN", level = 10, }, --7n	
	["火舌打擊"] = 			{ class = "SHAMAN", level = 12, }, --7n
	["冰封打擊"] = 			{ class = "SHAMAN", level = 19, }, --7n	
	["風暴打擊"] = 			{ class = "SHAMAN", level = 26, },
	["閃電轟擊"] = 		{ class = "SHAMAN", level = 28, }, --7n
	["風怒"] = 				{ class = "SHAMAN", level = 30, }, --7n
	["風暴鞭笞"] = 			{ class = "SHAMAN", level = 38, }, --7n
	["風暴使者"] = 			{ class = "SHAMAN", level = 40, }, --7n
	["野性之魂"] = 			{ class = "SHAMAN", level = 48, }, --7n
	["氣漩武器"] = 		{ class = "SHAMAN", level = 52, },
	["幽魂步伐"] = 			{ class = "SHAMAN", level = 72, },
	["強化元素"] = 	{ class = "SHAMAN", level = 78, },
	--++ Restoration ++
	["激流"] = 				{ class = "SHAMAN", level = 10, },
	["治療之泉圖騰"] = 	{ class = "SHAMAN", level = 13, },	
	["淨化靈魂"] = 		{ class = "SHAMAN", level = 18, },
	["治療鍊"] = 			{ class = "SHAMAN", level = 26, }, --x Moved	
	["復甦"] = 			{ class = "SHAMAN", level = 40, },
	["先祖之視"] = 		{ class = "SHAMAN", level = 44, }, --7n
	["治癒之雨"] = 			{ class = "SHAMAN", level = 48, },
	["治療之潮"] = 			{ class = "SHAMAN", level = 50, },
	["療癒之潮圖騰"] = 	{ class = "SHAMAN", level = 54, }, 
	["治療波"] = 			{ class = "SHAMAN", level = 56, },	
	["靈魂連結圖騰"] = 	{ class = "SHAMAN", level = 62, },
	["靈行者之賜"] = 	{ class = "SHAMAN", level = 72, }, 	
	["深度治療"] = 			{ class = "SHAMAN", level = 78, },
--++ Shaman Talents ++
	["風驟圖騰"] = 		{ class = "SHAMAN", level = 30, }, --7n
	["陷地圖騰"] = 		{ class = "SHAMAN", level = 45, },
	["閃電奔流圖騰"] = { class = "SHAMAN", level = 45, }, --7n
	["巫毒圖騰"] = 			{ class = "SHAMAN", level = 45, }, --7n
	["卓越術"] = 			{ class = "SHAMAN", level = 100, }, --7n	
	--++ Elemental/Enhancement ++
	["先祖迅捷"] = 	{ class = "SHAMAN", level = 60, },	
	--++ Elemental/Restoration ++
	["先祖導引"] = 	{ class = "SHAMAN", level = 30, },
	["陣風"] = 			{ class = "SHAMAN", level = 30, }, --7n
	["元素迴響"] = 	{ class = "SHAMAN", level = 60, },	
	--++ Elemental ++	
	["大地怒火"] = 			{ class = "SHAMAN", level = 15, }, --7n
	["烈焰之徑"] = 		{ class = "SHAMAN", level = 15, }, --7n
	["精通圖騰"] = 		{ class = "SHAMAN", level = 15, }, --7n	
	["餘震"] = 			{ class = "SHAMAN", level = 60, }, --7.1.5m	
	["精通元素"] = 	{ class = "SHAMAN", level = 60, }, --7.1.5m	
	["元素衝擊"] = 		{ class = "SHAMAN", level = 75, }, --7.1.5m
	["元素融合"] = 		{ class = "SHAMAN", level = 75, }, --x
	["原始元素師"] = 	{ class = "SHAMAN", level = 75, },
	["岩漿圖騰"] = 	{ class = "SHAMAN", level = 90, }, --7.1.5m	
	["風暴元素"] = 		{ class = "SHAMAN", level = 90, }, --7n
	["冰怒"] = 				{ class = "SHAMAN", level = 100, }, --7.1.5m	
	["聚雷針"] = 		{ class = "SHAMAN", level = 100, }, --7n	
	--++ Enhancement ++	
	["炙手"] = 				{ class = "SHAMAN", level = 15, }, --7n
	["崩石流土"] = 			{ class = "SHAMAN", level = 15, }, --7.2.5m	
	["風之歌"] = 				{ class = "SHAMAN", level = 15, }, --7n
	["野性突擊"] = 			{ class = "SHAMAN", level = 30, }, --7n
	["時雨"] = 				{ class = "SHAMAN", level = 30, }, --7n
	["冰風暴"] = 			{ class = "SHAMAN", level = 60, }, --7n
	["閃電之盾"] = 		{ class = "SHAMAN", level = 60, }, --7m
	["強化風暴鞭笞"] = 	{ class = "SHAMAN", level = 75, }, --7n
	["電能超載"] = 			{ class = "SHAMAN", level = 75, }, --7n
	["暴風雨"] = 				{ class = "SHAMAN", level = 75, }, --7n
	["暴風轟擊"] = 		{ class = "SHAMAN", level = 90, }, --7n
	["旋風之怒"] = 			{ class = "SHAMAN", level = 90, }, --7n
	["裂地浩劫"] = 			{ class = "SHAMAN", level = 90, }, --7n
	["巨石拳"] = 			{ class = "SHAMAN", level = 100, }, --7.2.5m	
	["大地尖刺"] = 		{ class = "SHAMAN", level = 100, }, --7n
	--++ Restoration ++
	["洪流"] = 				{ class = "SHAMAN", level = 15, }, --7n
	["治療波動"] = 			{ class = "SHAMAN", level = 15, }, --7n
	["優雅靈魂"] = 		{ class = "SHAMAN", level = 30, }, --7n
	["浪潮洶湧"] = 		{ class = "SHAMAN", level = 60, }, --7n
	["洪水"] = 				{ class = "SHAMAN", level = 60, }, --7n
	["先祖保護圖騰"] = { class = "SHAMAN", level = 75, }, --7n
	["先祖活力"] = 		{ class = "SHAMAN", level = 75, }, --7n
	["大地護盾圖騰"] = 	{ class = "SHAMAN", level = 75, }, --7n
	["無底深淵"] = 	{ class = "SHAMAN", level = 90, }, --7n
	["雲爆圖騰"] = 		{ class = "SHAMAN", level = 90, }, --x
	["浪潮高漲"] = 			{ class = "SHAMAN", level = 100, }, --x
	["泉湧"] = 			{ class = "SHAMAN", level = 100, }, --7n
--++ Shaman PvP Talents ++
	["大地之盾"] = 			{ class = "SHAMAN", level = 100, }, --7n
	["靈魂連結"] = 			{ class = "SHAMAN", level = 100, }, --7n
	["天怒圖騰"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["反制圖騰"] = 	{ class = "SHAMAN", level = 100, }, --7n
	["風怒圖騰"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["根基圖騰"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["雷霆充能"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["熔岩操控"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["閃電套索"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["靈體形態"] = 		{ class = "SHAMAN", level = 100, }, --7n

--++ Warlock Abilities ++
	["混沌彈幕"] = 		{ class = "WARLOCK", level = 1, }, --7n??
	["靈魂汲取"] = 			{ class = "WARLOCK", level = 1, },  --7m??
	["混沌箭"] = 			{ class = "WARLOCK", level = 1, }, --7m ??
	["暗影箭"] = 			{ class = "WARLOCK", level = 1, }, --7 ??
	["靈魂裂片"] = 			{ class = "WARLOCK", level = 1, }, --7.2.5n	
	["召喚小鬼"] = 			{ class = "WARLOCK", level = 1, },	
	["製造治療石"] = 	{ class = "WARLOCK", level = 5, },	
	["召喚虛無行者"] = 	{ class = "WARLOCK", level = 8, },
	["惡魔號令"] = 		{ class = "WARLOCK", level = 10, },
	["恐懼術"] = 					{ class = "WARLOCK", level = 16, },
	["靈魂石"] = 			{ class = "WARLOCK", level = 18, },
	["生命通道"] = 		{ class = "WARLOCK", level = 19, },	
	["惡魔戰馬"] = 				{ class = "WARLOCK", level = 20, },	--7n 
	["基爾羅格之眼"] = 		{ class = "WARLOCK", level = 22, },
	["魔息術"] = 		{ class = "WARLOCK", level = 24, },
	["召喚魅魔"] = 		{ class = "WARLOCK", level = 28, },	
	["惡魔號令"] = 		{ class = "WARLOCK", level = 31, },	
	["放逐術"] = 				{ class = "WARLOCK", level = 32, },	
	["召喚惡魔獵犬"] = 		{ class = "WARLOCK", level = 35, },
	["恐懼戰馬"] = 			{ class = "WARLOCK", level = 40, },	--7n
	["召喚煉獄火"] = 		{ class = "WARLOCK", level = 50, },
	["奴役惡魔"] = 		{ class = "WARLOCK", level = 54, },
	["召喚末日守衛"] = 		{ class = "WARLOCK", level = 58, },
	["心志堅定"] = 		{ class = "WARLOCK", level = 62, },
	["製造靈魂之井"] = 		{ class = "WARLOCK", level = 65, },
	["召喚儀式"] = 	{ class = "WARLOCK", level = 72, },	
	["惡魔之門"] = 		{ class = "WARLOCK", level = 87, }, 
--++ Warlock Artifact Traits ++
	["次元裂隙"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["收割靈魂"] = 			{ class = "WARLOCK", level = 100, }, --7n
	["薩奇爾之噬"] = { class = "WARLOCK", level = 100, }, --7n
--++ Warlock Specialization ++
	--++ Affliction/Demonology/Destruction ++	
	["生命分流"] = 				{ class = "WARLOCK", level = 16, }, --x Moved
	--++ Affliction ++
	["腐蝕術"] = 			{ class = "WARLOCK", level = 3, }, --7m
	["痛苦"] = 				{ class = "WARLOCK", level = 10, },
	["痛苦動盪"] = 	{ class = "WARLOCK", level = 10, },
--	["Secrets of the Necrolyte"] = 	{ class = "WARLOCK", level = 10, },	--7.1.5r
	["吸取生命"] = 			{ class = "WARLOCK", level = 13, }, --7.1.5m
	["吸取靈魂"] = 			{ class = "WARLOCK", level = 15, }, --7m	
	["腐蝕種子"] = 	{ class = "WARLOCK", level = 38 },
	["強效痛苦"] = 	{ class = "WARLOCK", level = 78, },
	--++ Demonology ++
	["古爾丹之手"] = 		{ class = "WARLOCK", level = 10, },		
	["惡魔強化"] = 	{ class = "WARLOCK", level = 12, },	--7n
	["召喚恐懼潛獵犬"] = 	{ class = "WARLOCK", level = 14, }, --7n
	["末日"] = 					{ class = "WARLOCK", level = 26, }, --x	
	["惡魔怒火"] = 			{ class = "WARLOCK", level = 36, }, --7n
	["召喚惡魔守衛"] = 		{ class = "WARLOCK", level = 40, },
	["靈魂鏈結"] = 			{ class = "WARLOCK", level = 42, },	
	["惡魔學識大師"] = 	{ class = "WARLOCK", level = 78, },
	--++ Destruction ++
	["獻祭"] = 				{ class = "WARLOCK", level = 10, },	
	["燒盡"] = 			{ class = "WARLOCK", level = 10, },
	["焚燒"] = 			{ class = "WARLOCK", level = 10, },
	["火焰之雨"] = 			{ class = "WARLOCK", level = 38, }, 
	["浩劫"] = 				{ class = "WARLOCK", level = 40, },
	["混沌能量"] = 		{ class = "WARLOCK", level = 78, }, --7n
--++ Warlock Talents ++
	["惡魔法陣"] = 		{ class = "WARLOCK", level = 45, }, --7m	
	["死影纏繞"] = 			{ class = "WARLOCK", level = 45, },
	["靈魂收割"] = 			{ class = "WARLOCK", level = 60, }, --7m	
	["燃燒狂奔"] = 			{ class = "WARLOCK", level = 75, },
	["黑暗契約"] = 			{ class = "WARLOCK", level = 75, }, --7n
	["惡魔皮膚"] = 			{ class = "WARLOCK", level = 75, }, --7n
	["服侍魔典"] = 	{ class = "WARLOCK", level = 90, },
	["至尊魔典"] = { class = "WARLOCK", level = 90, },
	["靈魂導體"] = 			{ class = "WARLOCK", level = 100, }, --7n
	--++ Affliction/Destruction ++
--	["Mana Tap"] = 				{ class = "WARLOCK", level = 30, }, --7.1.5r
	["強化生命分流"] = 	{ class = "WARLOCK", level = 30, }, --7.1.5n	
	["犧牲魔典"] = { class = "WARLOCK", level = 90, },
	--++ Demonology/Destruction ++
	["暗影之怒"] = 			{ class = "WARLOCK", level = 45, }, 	
	--++ Affliction ++	
	["蝕魂術"] = 				{ class = "WARLOCK", level = 15, },	--7m
	["惡毒之握"] = 		{ class = "WARLOCK", level = 15, },	--7.1.5n	
	["痛苦折騰"] = 		{ class = "WARLOCK", level = 15, }, --7n
	["絕對腐化"] = 	{ class = "WARLOCK", level = 30, }, --7n 
	["動盪蔓延"] = 			{ class = "WARLOCK", level = 30, }, --7n 
	["恐懼嚎叫"] = 		{ class = "WARLOCK", level = 45, }, --x 
	["散播魔種"] = 		{ class = "WARLOCK", level = 60, }, --7n 
	["幻魅奇異點"] = 	{ class = "WARLOCK", level = 60, }, --7.2.5m
	["致命扼殺"] = 		{ class = "WARLOCK", level = 100, }, --7.2.5n 
	["生命虹吸"] = 			{ class = "WARLOCK", level = 100, }, --7.2.5m	
--	["靈魂幻影"] = 			{ class = "WARLOCK", level = 100, }, --7.2.5r 
	--++ Demonology ++
	["惡魔呼喚"] = 		{ class = "WARLOCK", level = 15, }, --7n 
	["暗影之焰"] = 			{ class = "WARLOCK", level = 15, }, --7n
	["暗影啟發"] = 	{ class = "WARLOCK", level = 15, }, --7n 
	["末日逼近"] = 		{ class = "WARLOCK", level = 30, }, --7n 
	["小鬼爆破"] = 			{ class = "WARLOCK", level = 30, }, --7n 
	["強化恐懼潛獵犬"] = { class = "WARLOCK", level = 30, }, --7n 
	["末日之手"] = 			{ class = "WARLOCK", level = 60, }, --7n 
	["力量漫遊"] = 			{ class = "WARLOCK", level = 60, }, --7n 
	["協調魔典"] = 	{ class = "WARLOCK", level = 90, }, --x
	["惡魔箭"] = 			{ class = "WARLOCK", level = 100, }, --x
	["召喚暗凝"] = 		{ class = "WARLOCK", level = 100, }, --7n 
	--++ Destruction ++
	["爆燃"] = 			{ class = "WARLOCK", level = 15 }, --7m
	["咆哮之炎"] = 		{ class = "WARLOCK", level = 15, }, --7n
	["暗影灼燒"] = 			{ class = "WARLOCK", level = 15, },
	["滅絕"] = 			{ class = "WARLOCK", level = 30, }, --7m
	["逆轉熵值"] = 		{ class = "WARLOCK", level = 30, }, --7n
	["災變"] = 			{ class = "WARLOCK", level = 60, }, --7.1.5m	
	["硫磺與火焰"] = 	{ class = "WARLOCK", level = 60, }, --7m
	["引導惡魔火焰"] = 	{ class = "WARLOCK", level = 100, }, --7n
	["浩劫肆虐"] = 			{ class = "WARLOCK", level = 100, }, --7n
--++ Warlock PvP Talents ++
--	["靈魂調換"] = 			{ class = "WARLOCK", level = 100, }, --7.1.5r
	["暗影詛咒"] = 		{ class = "WARLOCK", level = 100, }, --7.1.5n
	["語言詛咒"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["虛弱詛咒"] = 	{ class = "WARLOCK", level = 100, }, --7n
	["脆弱詛咒"] = 	{ class = "WARLOCK", level = 100, }, --7n
	["浩劫之禍"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["召喚觀察者"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["火焰石"] = 			{ class = "WARLOCK", level = 100, }, --7n
	["虛空結界"] = 			{ class = "WARLOCK", level = 100, }, --7n
	["召喚惡魔領主"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["召喚惡魔獵犬"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["焦化魔法"] = 			{ class = "WARLOCK", level = 100, }, --7n
--	["靈魂炙燃"] = 				{ class = "WARLOCK", level = 100, }, --7.1.5r
	["靈魂粉碎"] = 			{ class = "WARLOCK", level = 100, }, --7.1.5n	
	["施放法陣"] = 		{ class = "WARLOCK", level = 100, }, --7n

--++ Warrior Abilities ++
	["攻擊"] = 				{ class = "WARRIOR", level = 1, }, --7n
--	["格擋"] = 				{ class = "WARRIOR", level = 1, }, --7 Conflict
--	["招架"] = 				{ class = "WARRIOR", level = 1, }, --7 Conflict
	["衝鋒"] = 				{ class = "WARRIOR", level = 3, },
	["嘲諷"] = 				{ class = "WARRIOR", level = 14, },
	["英勇投擲"] = 			{ class = "WARRIOR", level = 22, },
	["拳擊"] = 				{ class = "WARRIOR", level = 24, },
	["英勇躍擊"] = 			{ class = "WARRIOR", level = 26, },	
	["重傷"] = 			{ class = "WARRIOR", level = 32, }, --x Moved
--++ Warrior Artifact Traits ++
	["奈薩里奧之怒"] = 	{ class = "WARRIOR", level = 100, }, --7n
	["歐丁之怒"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["破戰制霸"] = 			{ class = "WARRIOR", level = 100, }, --7n
--++ Warrior Specialization ++
	--++ Arms/Fury/Protection ++
	["集中怒氣"] = 			{ class = "WARRIOR", level = 12, }, --7.1.5m	
	["狂暴之怒"] = 		{ class = "WARRIOR", level = 40, }, --7m
	["戰鬥狂嘯"] = 			{ class = "WARRIOR", level = 60, },	--7n
	--++ Arms/Fury ++
	["斬殺"] = 				{ class = "WARRIOR", level = 8, }, --7m
	["旋風斬"] = 			{ class = "WARRIOR", level = 28, },		
	["破膽怒吼"] = 	{ class = "WARRIOR", level = 70, }, --7m
	["命令之吼"] = 		{ class = "WARRIOR", level = 83, },	
	--++ Arms/Protection ++	
	["勝利衝擊"] = 			{ class = "WARRIOR", level = 10 }, --7m
	--++ Arms ++	
	["猛擊"] = 					{ class = "WARRIOR", level = 1, },	
	["致死打擊"] = 		{ class = "WARRIOR", level = 5, },
--	["Seasoned Soldier"] = 		{ class = "WARRIOR", level = 10, }, removed
	["千鈞潰擊"] = 		{ class = "WARRIOR", level = 18, }, --x Moved	
	["戰術大師"] = 			{ class = "WARRIOR", level = 18, }, --7n	
	["順劈斬"] = 				{ class = "WARRIOR", level = 32 }, --7m
	["斷筋"] = 			{ class = "WARRIOR", level = 36, }, --7m
	["劍下亡魂"] = 		{ class = "WARRIOR", level = 50, },
	["劍刃風暴"] = 			{ class = "WARRIOR", level = 75, },	--7m ??
	["巨像之力"] = 		{ class = "WARRIOR", level = 78, },	--7n
	--++ Fury ++
	["嗜血"] = 			{ class = "WARRIOR", level = 10, },
	["狂怒"] = 				{ class = "WARRIOR", level = 10, }, --x Moved	
	["狂暴斬擊"] = 		{ class = "WARRIOR", level = 10, }, --7n		
	["泰坦之握"] = 			{ class = "WARRIOR", level = 10, }, 
	["狂怒恢復"] = 	{ class = "WARRIOR", level = 12, }, --7m
	["狂怒之擊"] = 			{ class = "WARRIOR", level = 13, },
	["暴怒！"] = 				{ class = "WARRIOR", level = 18, },	 --7n
	["刺耳怒吼"] = 		{ class = "WARRIOR", level = 26, }, --7m
	["一心狂怒"] = 	{ class = "WARRIOR", level = 38, }, 
	["旋風斬"] = 			{ class = "WARRIOR", level = 58, }, 
	["釋放怒火"] = 		{ class = "WARRIOR", level = 78, },
	--++ Protection ++  
	["防禦姿態"] = 		{ class = "WARRIOR", level = 9, }, --7m	 ??
--	["Resolve"] = 				{ class = "WARRIOR", level = 10, }, --x Conflict with Druid/Monk
	["S盾牌猛擊"] = 			{ class = "WARRIOR", level = 10, },
	["堅定哨戒"] = 	{ class = "WARRIOR", level = 10, },
	["挫敗"] = 			{ class = "WARRIOR", level = 12, },
	["雷霆一擊"] = 			{ class = "WARRIOR", level = 16, }, --x Moved	
	["盾牌格擋"] = 			{ class = "WARRIOR", level = 18, },	
	["復仇"] = 				{ class = "WARRIOR", level = 28, },
	["無視苦痛"] = 			{ class = "WARRIOR", level = 34, }, --7n
	["破釜沉舟"] = 			{ class = "WARRIOR", level = 36, },
	["盾牆"] = 			{ class = "WARRIOR", level = 48, }, --x Moved
	["挫志怒吼"] = 	{ class = "WARRIOR", level = 50, },
	["固若金湯"] = 	{ class = "WARRIOR", level = 60, },
	["法術反射"] = 		{ class = "WARRIOR", level = 65, }, --7m
	["攔截"] = 			{ class = "WARRIOR", level = 72, }, --7n
--	["還擊"] = 				{ class = "WARRIOR", level = 76, }, --7 Conflict
	["極效格檔"] = 		{ class = "WARRIOR", level = 78, },
--++ Warrior Talents ++
	--++ Arms/Fury/Protection ++	
	["震懾波"] = 			{ class = "WARRIOR", level = 15, }, --7??
	["暴風怒擲"] = 			{ class = "WARRIOR", level = 15, }, --7?? 
	["昂首闊步"] = 		{ class = "WARRIOR", level = 60, }, --7n	
	--++ Arms/Fury ++	
	["雙倍速"] = 			{ class = "WARRIOR", level = 30, },	
	--++ Arms/Protection ++	
	["憤怒掌控"] = 		{ class = "WARRIOR", level = 100, }, --x
	["劫毀旋刃"] = 				{ class = "WARRIOR", level = 100, }, --x	
	--++ Arms ++
	["無懼"] = 			{ class = "WARRIOR", level = 15, }, --7n
	["壓制"] = 			{ class = "WARRIOR", level = 15, }, --7m	
	["橫掃攻擊"] = 		{ class = "WARRIOR", level = 15, },
	["撕裂"] =				 	{ class = "WARRIOR", level = 45, }, --7m	
	["巨像化身"] = 				{ class = "WARRIOR", level = 45, },
	["創傷"] = 				{ class = "WARRIOR", level = 45, }, --7.2.5m	
	["復甦之風"] = 			{ class = "WARRIOR", level = 60, },
	["沙場熱血"] = 		{ class = "WARRIOR", level = 75, }, --7.2.5m		
	["致死連擊"] = 			{ class = "WARRIOR", level = 75, }, --7n
	["泰坦之力"] = 		{ class = "WARRIOR", level = 75, }, --7.2.5m	
	["致命沉著"] = 			{ class = "WARRIOR", level = 90, }, --7n
	["集中怒氣"] = 			{ class = "WARRIOR", level = 90, }, --7.2.5m
	["趕盡殺絕"] = 		{ class = "WARRIOR", level = 90, }, --7.2.5m	
	["伺機攻擊"] = 	{ class = "WARRIOR", level = 100, }, --7n??
	--++ Fury ++
	["戰爭機器"] = 			{ class = "WARRIOR", level = 15, }, --7n	
	["無盡狂怒"] = 			{ class = "WARRIOR", level = 15, }, --7n	
	["屠宰鮮肉"] = 			{ class = "WARRIOR", level = 15, }, --7n
	["破壞鐵球"] = 		{ class = "WARRIOR", level = 45, }, --7n
	["烈怒爆發"] = 				{ class = "WARRIOR", level = 45, }, --7n
	["狂烈衝鋒"] = 		{ class = "WARRIOR", level = 60, }, --7n
	["戰爭塗裝"] = 				{ class = "WARRIOR", level = 60, }, --7n
	["殘殺"] = 				{ class = "WARRIOR", level = 75, }, --7n
	["飛沫戰狂"] =	{ class = "WARRIOR", level = 75, }, --7n
	["大屠殺"] = 				{ class = "WARRIOR", level = 75, }, --7n
	["浴血"] = 			{ class = "WARRIOR", level = 90, },
	["狂亂"] = 				{ class = "WARRIOR", level = 90, }, --7n
	["心靈之怒"] = 			{ class = "WARRIOR", level = 90, }, --7n
	["盡情放縱"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["龍吼"] = 			{ class = "WARRIOR", level = 100, }, 
	--++ Protection ++
	["戰爭使者"] = 			{ class = "WARRIOR", level = 15, }, 
	["勝利在望"] = 	{ class = "WARRIOR", level = 30, },
	["振奮風采"] = 	{ class = "WARRIOR", level = 30, }, --x	
	["安全守護"] = 			{ class = "WARRIOR", level = 30, },
	["冷酷復仇"] = 		{ class = "WARRIOR", level = 45, }, --7.1.5m	
	["怒火重燃"] = 			{ class = "WARRIOR", level = 45, }, --7n	
--	["最後通諜"] = 			{ class = "WARRIOR", level = 45, }, --7.1.5r
	["督軍的挑戰"] = 	{ class = "WARRIOR", level = 60, }, --7n
	["崩響雷霆"] = 	{ class = "WARRIOR", level = 60, }, --7n
	["毀滅者"] = 			{ class = "WARRIOR", level = 75, }, --7.1.5n
	["不撓"] = 			{ class = "WARRIOR", level = 75, }, --7n
	["復仇"] = 			{ class = "WARRIOR", level = 90, }, --7m
	["身先士卒"] = 		{ class = "WARRIOR", level = 90, }, --7n
	["震耳嗓音"] = 		{ class = "WARRIOR", level = 90, }, --7n
	["沉重反衝"] = 	{ class = "WARRIOR", level = 100, }, --x	
--++ Warrior PvP Talents ++
	["繳械"] = 				{ class = "WARRIOR", level = 100, }, --7.1.5n
	["決鬥"] = 					{ class = "WARRIOR", level = 100, }, --7.1.5n
	["攔截"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["打磨利刃"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["盾擊"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["死亡之願"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["巨龍衝鋒"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["保鏢"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["群體法術反射"] = { class = "WARRIOR", level = 100, }, --7n
	["法術反射"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["戰旗"] = 			{ class = "WARRIOR", level = 100, }, --7.1.5n	
};
