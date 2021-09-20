--- Kaliel's Tracker
--- Copyright (c) 2012-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local M = KT:NewModule(addonName.."_Help")
KT.Help = M

local T = LibStub("MSA-Tutorials-1.0")
local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

local db, dbChar
local mediaPath = "Interface\\AddOns\\"..addonName.."\\Media\\"
local helpPath = mediaPath.."Help\\"
local helpName = "help"
local helpNumPages = 11
local cTitle = "|cffffd200"
local cBold = "|cff00ffe3"
local cNew = "|cff00ff00"
local cWarning = "|cffff7f00"
local cDots = "|cff808080"
local offs = "\n|T:1:9|t"
local beta = "|cffff7fff[Beta]|r"

local KTF = KT.frame

--------------
-- Internal --
--------------

local function AddonInfo(name)
	local info = "\n插件 "..name
	if IsAddOnLoaded(name) then
		info = info.." |cff00ff00已安裝|r。可以在設定選項中啟用/停用支援性。"
	else
		info = info.." |cffff0000未安裝|r。"
	end
	return info
end

local function SetupTutorials()
	T.RegisterTutorial(helpName, {
		savedvariable = KT.db.global,
		key = "helpTutorial",
		title = KT.title.." |cffffffffv"..KT.version.."|r",
		icon = helpPath.."KT_logo",
		font = "Fonts\\bLEI00D.ttf",
		width = 552,
		imageHeight = 256,
		{	-- 1
			image = helpPath.."help_kaliels-tracker",
			text = cTitle..KT.title.."|r 以遊戲預設的任務目標清單為基礎，並且增強它的功能。\n\n"..
				"包含下面這些功能:\n"..
				"- 更改目標清單位置\n"..
				"- 根據目標清單位置 (方向) 展開/收起目標清單\n"..
				"- 根據內容自動調整目標清單高度，可以限制最大高度\n"..
				"- 內容較多，超出最大高度時可以捲動\n"..
				"- 登出/結束遊戲時會記憶收起的目標清單狀態\n\n"..
				"... 還有更多其他增強功能（請繼續看下一頁）。",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 2
			image = helpPath.."help_header-buttons",
			imageHeight = 128,
			text = cTitle.."標題列按鈕|r\n\n"..
				"最小化按鈕:                               其他按鈕:\n"..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:0:14:0:14:209:170:0|t "..cDots.."...|r 展開目標清單                    "..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:2:-1:32:64:16:30:0:14:209:170:0|t  "..cDots.."...|r 開啟任務日誌\n"..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:0:14:16:30:209:170:0|t "..cDots.."...|r 收起目標清單                    "..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:2:-1:32:64:16:30:16:30:209:170:0|t  "..cDots.."...|r 開啟成就視窗\n"..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:0:14:32:46:209:170:0|t "..cDots.."...|r 目標清單是空的時候          "..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:2:-1:32:64:16:30:32:46:209:170:0|t  "..cDots.."...|r 開啟過濾方式選單\n\n"..
				"按鈕 |T"..mediaPath.."UI-KT-HeaderButtons:14:14:0:-1:32:64:16:30:0:14:209:170:0|t 和 "..
				"|T"..mediaPath.."UI-KT-HeaderButtons:14:14:0:-1:32:64:16:30:16:30:209:170:0|t 可以在設定選項中停用。\n\n"..
				"可以幫最小化按鈕設定"..cBold.." [快速鍵]|r 來最小化目標清單。\n"..
				cBold.."Alt+左鍵|r 點擊最小化按鈕會開啟 "..KT.title.."的設定選項。",
			textY = 16,
			shine = KTF.MinimizeButton,
			shineTop = 13,
			shineBottom = -14,
			shineRight = 16,
		},
		{	-- 3
			image = helpPath.."help_quest-title-tags",
			imageHeight = 128,
			text = cTitle.."特殊文字標籤|r\n\n"..
				"任物標題的前方可以看到像是這樣的標籤 |cffff8000[100|cff00b3ffhc!|cffff8000]|r。\n"..
				"任務日誌中的標題也會顯示任務標籤。\n\n"..
				"|cff00b3ff!|r|T:14:3|t "..cDots.."........|r 每日任務|T:14:100|t|cff00b3ffr|r "..cDots.."........|r 團隊任務\n"..
				"|cff00b3ff!!|r "..cDots.."......|r 每週任務|T:14:106|t|cff00b3ffr10|r "..cDots.."....|r 10人團隊任務\n"..
				"|cff00b3ff+|r "..cDots..".......|r 精英任務|T:14:102|t|cff00b3ffr25|r "..cDots.."....|r 25人團隊任務\n"..
				"|cff00b3ffg|r "..cDots.."........|r 組隊任務|T:14:99|t|cff00b3ffs|r "..cDots.."........|r 事件任務\n"..
				"|cff00b3ffpvp|r "..cDots.."...|r PvP 任務|T:14:99|t|cff00b3ffa|r "..cDots.."........|r 帳號共通任務\n"..
				"|cff00b3ffd|r "..cDots.."........|r 副本任務|T:14:100|t|cff00b3ffleg|r "..cDots.."....|r 傳說任務\n"..
				"|cff00b3ffhc|r "..cDots.."......|r 英雄副本任務|T:14:1|t",
			shineTop = 10,
			shineBottom = -9,
			shineLeft = -12,
			shineRight = 10,
		},
		{	-- 4
			image = helpPath.."help_tracker-filters",
			text = cTitle.."任務過濾|r\n\n"..
				"要開啟過濾方式選單請"..cBold.."點一下|r 這個按鈕 |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:16:30:32:46:209:170:0|t。\n\n"..
				"過濾方式分為兩種類型:\n"..
				cTitle.."固定過濾|r - 新增任務/成就依據條件（例如 \"每日\"）可以手動新增/移除項目。\n"..
				cTitle.."動態過濾|r - 自動新增任務/成就依據條件（例如 \"|cff00ff00自動|r區域\"）"..
				"會持續更新項目。這種類型不允許手動新增/移除項目。"..
				"啟用動態過濾時，標題按鈕是綠色 |T"..mediaPath.."UI-KT-HeaderButtons:14:14:-1:-1:32:64:16:30:32:46:0:255:0|t。\n\n"..
				"更改成就的搜尋類別時，也會影響過濾的結果。\n\n"..
				"這個選單也會顯示影響目標清單內容的其他選項（例如 戰寵助手插件 PetTracker 所使用的選項）。",
			textY = 16,
			shine = KTF.FilterButton,
			shineTop = 10,
			shineBottom = -11,
			shineLeft = -10,
			shineRight = 11,
		},
		{	-- 5
			image = helpPath.."help_quest-item-buttons",
			text = cTitle.."任務物品按鈕|r\n\n"..
				"按鈕在任務目標清單外面，因為暴雪不允許預設的清單介面使用動作按鈕。\n\n"..
				"|T"..helpPath.."help_quest-item-buttons_2:32:32:1:0:64:32:0:32:0:32|t "..cDots.."...|r  這個標籤代表任務中的任務物品。裡面的數字用來辨別\n"..
				"                移動後的任務物品按鈕。\n\n"..
				"|T"..helpPath.."help_quest-item-buttons_2:32:32:0:3:64:32:32:64:0:32|t "..cDots.."...|r  真正的任務物品按鈕已經移動到清單的左/右側\n"..
				"               （依據所選擇的對齊畫面位置）。標籤數字仍然相同。\n\n"..
				cWarning.."特別注意:|r\n"..
				"在某些戰鬥中，任務物品按鈕的動作會被暫停，直到戰鬥結束後才能使用。",
			shineTop = 3,
			shineBottom = -2,
			shineLeft = -4,
			shineRight = 3,
		},
		{	-- 6
			image = helpPath.."help_active-button",
			text = cTitle.."大型任務物品按鈕|r\n\n"..
				"大型任務物品按鈕提供任務物品較佳的使用方式。將 '距離最近' 的任務的物品顯示為額外快捷鍵。(類似德拉諾的要塞技能)\n\n"..
				"功能:\n"..
				"- 接近可以使用任務物品的地方時"..
				offs.."自動顯示大型任務物品按鈕。\n"..
				"- 可以設定"..cBold.." [快速鍵]|r 來使用任務物品。在設定選項中指定要綁定的按鍵。"..
				offs.."大型任務物品按鈕使用和額外快捷鍵相同的按鍵綁定。\n"..
				"- 可以使用其它插件來移動按鈕 (例如 達美樂快捷列 - Dominos、版面配置 - MoveAnything)。\n"..
				offs.."要更改位置，請移動 \"額外快捷鍵\" 而不是 \"額外快捷列\"。\n\n"..
				cWarning.."特別注意:|r\n"..
				"- 只有已經追蹤的任務才能使用大型任務物品按鈕。\n"..
				"- 目標清單收合起來的時候，會一併暫停大型任務物品按鈕的功能。",
			shineTop = 30,
			shineBottom = -30,
			shineLeft = -80,
			shineRight = 80,
		},
		{	-- 7
			image = helpPath.."help_addon-masque",
			text = cTitle.."支援插件: 按鈕外觀 - Masque|r\n\n"..
				"Masque 提供更改任務物品按鈕外觀的功能，同時也會影響大型任務物品按鈕 (請看上一頁)。\n"..
				AddonInfo("Masque"),
		},
		{	-- 8
			image = helpPath.."help_addon-pettracker",
			text = cTitle.."支援插件: 戰寵助手 - PetTracker|r\n\n"..
				"支援在"..KT.title.."裡面顯示 PetTracker 的區域寵物追蹤，同時也修正了顯示上的一些問題。\n"..
				AddonInfo("PetTracker"),
		},
		{	-- 9
			image = helpPath.."help_addon-tomtom",
			text = cTitle.."支援插件: 箭頭導航 - TomTom|r\n\n"..
				"TomTom 的支援性整合了暴雪的 POI 和 TomTom 的箭頭。\n\n"..
				"|TInterface\\WorldMap\\UI-QuestPoi-NumberIcons:28:28:-2:1:256:256:224:256:224:256|t"..
				"|TInterface\\WorldMap\\UI-QuestPoi-NumberIcons:28:28:-2:1:256:256:128:160:96:128|t"..cDots.."...|r  暴雪預設的 POI 按鈕\n"..
				"|T"..mediaPath.."UI-QuestPoi-NumberIcons:28:28:-2:1:256:256:224:256:224:256|t"..
				"|T"..mediaPath.."UI-QuestPoi-NumberIcons:28:28:-2:1:256:256:128:160:96:128|t"..cDots.."...|r  使用 TomTom 箭頭導引的任務的 POI 按鈕\n \n"..
				"功能:\n"..
				"- 新加入追蹤的任務會自動開啟箭頭導引。\n"..
				"- 取消追蹤或放棄的任務會自動移除箭頭導引。\n"..
				"- "..cBold.."點一下|r POI 按鈕會新增箭頭導引，或啟用已有的箭頭導引。\n"..
				"- 如果任務沒有 POI 按鈕，"..cBold.."右鍵點一下|r 任務會顯示功能選單。\n"..
				"- 或使用"..cBold.."[組合鍵]+左鍵點一下|r，在"..KT.title.."的設定選項中\n|T:1:9|t可以設定組合鍵。\n"..
				AddonInfo("TomTom"),
			shineTop = 10,
			shineBottom = -10,
			shineLeft = -11,
			shineRight = 11,
		},
		{	-- 10
			image = helpPath.."help_tracker-modules",
			text = cTitle.."模組順序|r "..beta.."\n\n"..
					"允許更改模組在目標清單中的順序。支援所有的模組，也包含外部插件 (例如：戰寵助手)。",
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		{	-- 11
			text = cTitle.."         版本更新資訊 |cffffffff2.1.9|r\n\n"..
				"- 修正 - issue #235 - 啟用 \"自動區域任務\" 過濾方式而且此區域中沒有任務時，"..
				offs.."自動加入世界任務和區域獎勵任務後清單不會展開。\n"..
				"- 修正 - 在自動/手動切換追蹤世界任務後，目標清單會收合起來。\n"..
				"- 修正 - 在所有模組中顯示較長的分隔線 (例如：成就)。\n"..
				"- 新增 - 目標清單收合起來時會顯示 Kaliel's Tracker 的 LOGO。\n"..
				"- 新增 - 目標清單沒有背景時，收合起來後文字會靠右對齊。\n"..
				"- 新增 - 在目標清單和任務記錄中顯示 Wowhead URL 選單項目。\n"..
				"- 移除 - 目標清單收合起來後所顯示的每日任務訊息，看起來有點亂。\n"..
				"- 更新 - 支援插件 - PetTracker v7.3.0, TomTom v70300-1.0.0,"..
				offs.."ElvUI v10.73, Tukui v17.17, RealUI v8.1 r20h, SyncUI v1.5.4, SuperVillain UI"..
				offs.."v1.4.2。\n"..
				"- 更新 - 說明 - 模組排列順序。\n"..
				"- 以及一些小改善。\n\n"..

				cTitle.."已知問題|r\n"..
				"- 在戰鬥中使用世界地圖會產生 LUA 錯誤。這是因為在軍臨天下的版本中，世界地圖"..
				offs.."被改成為受保護的框架，並且使用到任務目標清單的一些功能。"..
				offs..cWarning.."我無法修正這個錯誤 - 根本是不可能任務!|r\n\n"..

				cTitle.."回報問題|r\n"..
				"請使用下方的 "..cBold.."回報單網址|r 而不是在 Curse.com 留言。\n\n\n\n"..

				cWarning.."回報錯誤之前，請先停用所有其他的插件，以確保不是和其他插件相衝突。|r",
			textY = -20,
			editbox = "https://wow.curseforge.com/projects/kaliels-tracker/issues",
			editboxBottom = 20,
			shine = KTF,
			shineTop = 5,
			shineBottom = -5,
			shineLeft = -6,
			shineRight = 6,
		},
		onShow = function(self, i)
			if dbChar.collapsed then
				ObjectiveTracker_MinimizeButton_OnClick()
			end
			if i == 2 then
				if KTF.FilterButton then
					self[i].shineLeft = db.hdrOtherButtons and -75 or -35
				else
					self[i].shineLeft = db.hdrOtherButtons and -55 or -15
				end
			elseif i == 3 then
				local questID, _ = GetQuestWatchInfo(1)
				local block = QUEST_TRACKER_MODULE.usedBlocks[questID]
				if block then
					self[i].shine = block
				end
			elseif i == 5 then
				self[i].shine = KTF.Buttons
			elseif i == 6 then
				self[i].shine = KTF.ActiveButton
			elseif i == 9 then
				for j=1, GetNumQuestWatches() do
					local questID, _ = GetQuestWatchInfo(j)
					local hasLocalPOI = select(16, GetQuestWatchInfo(j))
					local block = QUEST_TRACKER_MODULE.usedBlocks[questID]
					if block and hasLocalPOI then
						self[i].shine = QuestPOI_FindButton(ObjectiveTrackerFrame.BlocksFrame, questID)
						break
					end
				end
			end
		end
	})
end

--------------
-- External --
--------------

function M:OnInitialize()
	_DBG("|cffffff00初始化|r - "..self:GetName(), true)
	db = KT.db.profile
	dbChar = KT.db.char
end

function M:OnEnable()
	_DBG("|cff00ff00啟用|r - "..self:GetName(), true)
	SetupTutorials()
	local last = false
	if KT.version ~= KT.db.global.version then
		local data = T.GetTutorial(helpName)
		local index = data.savedvariable[data.key]
		if index then
			last = index < helpNumPages and index or true
			T.ResetTutorial(helpName)
		end
	end
	T.TriggerTutorial(helpName, helpNumPages, last)
end

function M:ShowHelp(index)
	InterfaceOptionsFrame:Hide()
	T.ResetTutorial(helpName)
	T.TriggerTutorial(helpName, helpNumPages, index or false)
end