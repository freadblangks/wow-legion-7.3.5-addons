local _G = _G
local ipairs = ipairs
local hooksecurefunc = hooksecurefunc

local MovAny = _G.MovAny
local MOVANY = _G.MOVANY

local cats = {
	{name = "成就 & 任務"},
	{name = "競技場"},
	{name = "暴雪快捷列"},
	{name = "暴雪背包"},
	{name = "暴雪銀行和虛空倉庫"},
	{name = "暴雪按鈕列"},
	{name = "戰場 & PvP"},
	{name = "職業限定"},
	{name = "地城和團隊"},
	{name = "首領限定框架"},
	{name = "遊戲選單"},
	{name = "要塞"},
	{name = "船塢"},
	{name = "職業大廳"},
	{name = "公會"},
	{name = "資訊內容面板"},
	{name = "戰利品"},
	{name = "地圖"},
	{name = "小地圖"},
	{name = "其他"},
	{name = "版面配置插件"},
	{name = "單位: 專注"},
	{name = "單位: 隊伍"},
	{name = "單位: 寵物"},
	{name = "單位: 玩家"},
	{name = "單位: 目標"},
	{name = "載具"},
	{name = "寵物對戰"},
	{name = "遊戲商城"},
}

local API

local m = {
	Enable = function(self)
		API = MovAny.API
		self:LoadList()
		MovAny:DeleteModule(self)
		API = nil
		--m = nil
	end,
	LoadList = function(self)
		API.default = true
		for i, c in ipairs(cats) do
			API:AddCategory(c)
		end
		cats = nil
		local c, e
		c = API:GetCategory("成就 & 任務")
		API:AddElement({name = "AchievementFrame", displayName = "成就"}, c)
		API:AddElement({name = "AchievementAlertFrame1", displayName = "成就通知 1", runOnce = AchievementFrame_LoadUI, create = "AchievementAlertFrameTemplate"}, c)
		API:AddElement({name = "AchievementAlertFrame2", displayName = "成就通知 2", runOnce = AchievementFrame_LoadUI, create = "AchievementAlertFrameTemplate"}, c)
		API:AddElement({name = "CriteriaAlertFrame1", displayName = "標準通知 1", create = "CriteriaAlertFrameTemplate"}, c)
		API:AddElement({name = "CriteriaAlertFrame2", displayName = "標準通知 2", create = "CriteriaAlertFrameTemplate"}, c)
		local gcaf = API:AddElement({name = "GuildChallengeAlertFrame", displayName = "公會挑戰成就通知"}, c)
		API:AddElement({name = "ObjectiveTrackerFrameMover", displayName = "任務目標清單視窗", scaleWH = 1}, c)
		API:AddElement({name = "ObjectiveTrackerFrameScaleMover", displayName = "任務目標清單視窗縮放"}, c)
		API:AddElement({name = "ObjectiveTrackerBonusBannerFrame", displayName = "任務目標大標題"}, c)
		--[[local qldf = API:AddElement({name = "QuestLogDetailFrame", displayName = "任務詳細內容", runOnce = function()
			if not QuestLogDetailFrame:IsShown() then
				ShowUIPanel(QuestLogDetailFrame)
				HideUIPanel(QuestLogDetailFrame)
			end
		end}, c)]]
		API:AddElement({name = "QuestLogPopupDetailFrame", displayName = "任務詳細內容"}, c)
		API:AddElement({name = "QuestNPCModel", displayName = "任務記錄 NPC 模組"}, c)
		--local qlf = API:AddElement({name = "QuestLogFrame", displayName = "任務記錄"}, c)
		local qf = API:AddElement({name = "QuestFrame", displayName = "任務提供/交回", runOnce = function()
			hooksecurefunc(QuestFrame, "Show", function()
				if MovAny:IsModified("QuestFrame") then
					HideUIPanel(GossipFrame)
				end
			end)
			hooksecurefunc("DeclineQuest", function()
				HideUIPanel(GossipFrame)
			end)
		end}, c)
		API:AddElement({name = "QuestChoiceFrame", displayName = "任務選擇框架"}, c)
		API:AddElement({name = "WorldQuestCompleteAlertFrame", displayName = "世界任務完成通知"}, c)
		API:AddElement({name = "TalkingHeadFrame", displayName = "任務說話的頭框架", runOnce = TalkingHead_LoadUI}, c)
		--API:AddElement({name = "QuestTimerFrame", displayName = "任務計時器"}, c)
		c = API:GetCategory("競技場")
		--API:AddElement({name = "ArenaEnemyFrames", displayName = "ArenaEnemyFrames", noScale = 1}, c)
		--API:AddElement({name = "ArenaPrepFrames", displayName = "ArenaPrepFrames", noScale = 1}, c)
		API:AddElement({name = "ArenaEnemyFrame1", displayName = "競技場對手 1", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame2", displayName = "競技場對手 2", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame3", displayName = "競技場對手 3", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame4", displayName = "競技場對手 4", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame5", displayName = "競技場對手 5", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		local ttt1 = API:AddElement({name = "TimerTrackerTimer1", displayName = "時間記錄"}, c)
		API:AddElement({name = "ArenaEnemyFrame1PetFrame", displayName = "競技場對手寵物 1", create = "ArenaEnemyPetFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame2PetFrame", displayName = "競技場對手寵物 2", create = "ArenaEnemyPetFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame3PetFrame", displayName = "競技場對手寵物 3", create = "ArenaEnemyPetFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame4PetFrame", displayName = "競技場對手寵物 4", create = "ArenaEnemyPetFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame5PetFrame", displayName = "競技場對手寵物 5", create = "ArenaEnemyPetFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame1CastingBar", displayName = "競技場對手施法條 1", create = "ArenaCastingBarFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame2CastingBar", displayName = "競技場對手施法條 2", create = "ArenaCastingBarFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame3CastingBar", displayName = "競技場對手施法條 3", create = "ArenaCastingBarFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame4CastingBar", displayName = "競技場對手施法條 4", create = "ArenaCastingBarFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame5CastingBar", displayName = "競技場對手施法條 5", create = "ArenaCastingBarFrameTemplate", runOnce = Arena_LoadUI}, c)
		--API:AddElement({name = "PVPTeamDetails", displayName = "競技場團隊詳細內容"}, c)
		--API:AddElement({name = "ArenaFrame", displayName = "競技場排隊佇列清單"}, c)
		--API:AddElement({name = "ArenaRegistrarFrame", displayName = "競技場登記處"}, c)
		--API:AddElement({name = "PVPBannerFrame", displayName = "競技場大標題"}, c)
		API:AddElement({name = "ArenaPrepFrame1", displayName = "競技場準備 1", create = "ArenaPrepFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaPrepFrame2", displayName = "競技場準備 2", create = "ArenaPrepFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaPrepFrame3", displayName = "競技場準備 3", create = "ArenaPrepFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaPrepFrame4", displayName = "競技場準備 4", create = "ArenaPrepFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaPrepFrame5", displayName = "競技場準備 5", create = "ArenaPrepFrameTemplate", runOnce = Arena_LoadUI}, c)
		c = API:GetCategory("戰場 & PvP")
		local pvpf = API:AddElement({name = "PVPUIFrame", displayName = "PVP 視窗"}, c)
		ttt1:AddCategory(c)
		--API:AddElement({name = "BattlefieldMinimap", displayName = "戰場小地圖"}, c)
		--API:AddElement({name = "MiniMapBattlefieldFrame", displayName = "戰場小地圖按鈕"}, c)
		API:AddElement({name = "QueueStatusMinimapButton", displayName = "戰場小地圖按鈕"}, c)
		API:AddElement({name = "QueueStatusFrame", displayName = "戰場小地圖按鈕滑鼠提示"}, c)
		--API:AddElement({name = "BattlefieldFrame", displayName = "戰場排隊佇列"}, c)
		API:AddElement({name = "WorldStateScoreFrame", displayName = "戰場得分板"}, c)
		API:AddElement({name = "WorldStateCaptureBar1", displayName = "搶旗計時列", onlyOnceCreated = 1}, c)
		local wsauf = API:AddElement({name = "WorldStateAlwaysUpFrame", displayName = "中間上方狀態顯示", noUnanchorRelatives = 1}, c)
		API:AddElement({name = "AlwaysUpFrame1", displayName = "上方框架 1", create = "WorldStateAlwaysUpTemplate", onlyOnceCreated = 1}, c)
		API:AddElement({name = "AlwaysUpFrame2", displayName = "上方框架 2", create = "WorldStateAlwaysUpTemplate", onlyOnceCreated = 1}, c)
		API:AddElement({name = "AlwaysUpFrame3", displayName = "上方框架 3", create = "WorldStateAlwaysUpTemplate", onlyOnceCreated = 1}, c)
		API:AddElement({name = "PrestigeLevelUpBanner", displayName = "榮譽升級大標題"}, c)
		c = API:GetCategory("暴雪背包")
		API:AddElement({name = "BagsMover", displayName = "所有背包", noHide = 1}, c)
		API:AddElement({name = "BagButtonsMover", displayName = "背包按鈕"}, c)
		API:AddElement({name = "BagButtonsVerticalMover", displayName = "背包按鈕 - 垂直"}, c)
		API:AddElement({name = "BagItemSearchBox", displayName = "搜尋背包物品"}, c)
		API:AddElement({name = "BagItemAutoSortButton", displayName = "清理背包"}, c)
		API:AddElement({name = "BagFrame1", displayName = "主背包"}, c)
		API:AddElement({name = "BagFrame2", displayName = "背包 1"}, c) --refuseSync = 1
		API:AddElement({name = "BagFrame3", displayName = "背包 2"}, c)
		API:AddElement({name = "BagFrame4", displayName = "背包 3"}, c)
		API:AddElement({name = "BagFrame5", displayName = "背包 4"}, c)
		--API:AddElement({name = "KeyRingFrame", displayName = "鑰匙圈"}, c)
		API:AddElement({name = "MainMenuBarBackpackButton", displayName = "主背包按鈕"}, c)
		API:AddElement({name = "CharacterBag0Slot", displayName = "背包按鈕 1"}, c)
		API:AddElement({name = "CharacterBag1Slot", displayName = "背包按鈕 2"}, c)
		API:AddElement({name = "CharacterBag2Slot", displayName = "背包按鈕 3"}, c)
		API:AddElement({name = "CharacterBag3Slot", displayName = "背包按鈕 4"}, c)
		--API:AddElement({name = "KeyRingButton", displayName = "鑰匙圈按鈕"}, c)
		c = API:GetCategory("暴雪快捷列")
		API:AddElement({name = "BasicActionButtonsMover", displayName = "快捷列", linkedScaling = {"ActionBarDownButton", "ActionBarUpButton"}}, c)
		API:AddElement({name = "BasicActionButtonsVerticalMover", displayName = "快捷列 - 垂直"}, c)
		API:AddElement({name = "MultiBarBottomLeft", displayName = "左下快捷列"}, c)
		API:AddElement({name = "MultiBarBottomRight", displayName = "右下快捷列"}, c)
		--[[API:AddElement({name = "MultiBarRightMovert", displayName = "右方快捷列", run = function()
			if MovAny:IsModified("MultiBarRightHorizontalMover") then
				MovAny:ResetFrame("MultiBarRightHorizontalMover")
			end
		end}, c)]]
		API:AddElement({name = "MultiBarRightMover", displayName = "右方快捷列"}, c)
		API:AddElement({name = "MultiBarRightHorizontalMover", displayName = "右方快捷列 - 水平"}, c)
		--[[API:AddElement({name = "MultiBarLeft", displayName = "右方快捷列 2", run = function()
			if MovAny:IsModified("MultiBarLeftHorizontalMover") then
				MovAny:ResetFrame("MultiBarLeftHorizontalMover")
			end
		end}, c)]] --MultiBarLeftMover
		API:AddElement({name = "MultiBarLeftMover", displayName = "右方快捷列 2"}, c)
		API:AddElement({name = "MultiBarLeftHorizontalMover", displayName = "右方快捷列 2 - 水平"}, c)
		API:AddElement({name = "MainMenuBarPageNumber", displayName = "快捷列頁數"}, c)
		API:AddElement({name = "ActionBarUpButton", displayName = "快捷列上一頁"}, c)
		API:AddElement({name = "ActionBarDownButton", displayName = "快捷列下一頁"}, c)
		API:AddElement({name = "ExtraActionBarFrame", displayName = "額外快捷鍵"}, c)
		API:AddElement({name = "ZoneAbilityFrame", displayName = "區域特殊能力"}, c)
		API:AddElement({name = "PetActionButtonsMover", displayName = "寵物快捷列"}, c)
		API:AddElement({name = "PetActionButtonsVerticalMover", displayName = "寵物快捷列 - 垂直"}, c)
		API:AddElement({name = "StanceButtonsMover", displayName = "姿勢形態按鈕"}, c)
		API:AddElement({name = "StanceButtonsVerticalMover", displayName = "姿勢形態按鈕 - 垂直"}, c)
		c = API:GetCategory("暴雪銀行和虛空倉庫")
		local bf = API:AddElement({name = "BankFrame", displayName = "銀行"}, c)
		API:AddElement({name = "BankItemSearchBox", displayName = "搜尋銀行物品"}, c)
		API:AddElement({name = "BankItemAutoSortButton", displayName = "清理銀行"}, c)
		API:AddElement({name = "BankBagItemsMover", displayName = "銀行背包物品"}, c)
		API:AddElement({name = "BankBagSlotsMover", displayName = "銀行背包欄位"}, c)
		--[[API:AddElement({name = "BankFrameBag1", displayName = "銀行背包欄位 1"}, c)
		API:AddElement({name = "BankFrameBag2", displayName = "銀行背包欄位 2"}, c)
		API:AddElement({name = "BankFrameBag3", displayName = "銀行背包欄位 3"}, c)
		API:AddElement({name = "BankFrameBag4", displayName = "銀行背包欄位 4"}, c)
		API:AddElement({name = "BankFrameBag5", displayName = "銀行背包欄位 5"}, c)
		API:AddElement({name = "BankFrameBag6", displayName = "銀行背包欄位 6"}, c)
		API:AddElement({name = "BankFrameBag7", displayName = "銀行背包欄位 7"}, c)]]
		API:AddElement({name = "BankFrameMoneyFrame", displayName = "銀行存款"}, c)
		API:AddElement({name = "BankFrameMoneyFrameGoldButton", displayName = "銀行存款金幣"}, c)
		API:AddElement({name = "BankFrameMoneyFrameSilverButton", displayName = "銀行存款銀幣"}, c)
		API:AddElement({name = "BankFrameMoneyFrameCopperButton", displayName = "銀行存款銅幣"}, c)
		--API:AddElement({name = "BankFrameMoneyFrameBorder", displayName = "銀行存款邊框"}, c)
		--API:AddElement({name = "BankFrameMoneyFrameInset", displayName = "銀行存款往內縮小"}, c)
		API:AddElement({name = "BankBagFrame1", displayName = "銀行背包 1"}, c)
		API:AddElement({name = "BankBagFrame2", displayName = "銀行背包 2"}, c)
		API:AddElement({name = "BankBagFrame3", displayName = "銀行背包 3"}, c)
		API:AddElement({name = "BankBagFrame4", displayName = "銀行背包 4"}, c)
		API:AddElement({name = "BankBagFrame5", displayName = "銀行背包 5"}, c)
		API:AddElement({name = "BankBagFrame6", displayName = "銀行背包 6"}, c)
		API:AddElement({name = "BankBagFrame7", displayName = "銀行背包 7"}, c)
		local gbf = API:AddElement({name = "GuildBankFrame", displayName = "公會銀行"}, c)
		local gbt1 = API:AddElement({name = "GuildBankTab1", displayName = "公會銀行頁面 1"}, c)
		local gbt2 = API:AddElement({name = "GuildBankTab2", displayName = "公會銀行頁面 2"}, c)
		local gbt3 = API:AddElement({name = "GuildBankTab3", displayName = "公會銀行頁面 3"}, c)
		local gbt4 = API:AddElement({name = "GuildBankTab4", displayName = "公會銀行頁面 4"}, c)
		local gbt5 = API:AddElement({name = "GuildBankTab5", displayName = "公會銀行頁面 5"}, c)
		local gbt6 = API:AddElement({name = "GuildBankTab6", displayName = "公會銀行頁面 6"}, c)
		local gbt7 = API:AddElement({name = "GuildBankTab7", displayName = "公會銀行頁面 7"}, c)
		local gbt8 = API:AddElement({name = "GuildBankTab8", displayName = "公會銀行頁面 8"}, c)
		local gisb = API:AddElement({name = "GuildItemSearchBox", displayName = "搜尋公會銀行物品"}, c)
		local gbis = API:AddElement({name = "GuildBankInfoSaveButton", displayName = "公會銀行儲存按鈕"}, c)
		local gbfw = API:AddElement({name = "GuildBankFrameWithdrawButton", displayName = "公會銀行取出按鈕"}, c)
		local gbfd = API:AddElement({name = "GuildBankFrameDepositButton", displayName = "公會銀行存入按鈕"}, c)
		local gbwm = API:AddElement({name = "GuildBankWithdrawMoneyFrame", displayName = "公會銀行取出存款"}, c)
		local gbwmg = API:AddElement({name = "GuildBankWithdrawMoneyFrameGoldButton", displayName = "公會銀行取出存款金幣"}, c)
		local gbwms = API:AddElement({name = "GuildBankWithdrawMoneyFrameSilverButton", displayName = "公會銀行取出存款銀幣"}, c)
		local gbwmc = API:AddElement({name = "GuildBankWithdrawMoneyFrameCopperButton", displayName = "公會銀行取出存款銅幣"}, c)
		local gbmf = API:AddElement({name = "GuildBankMoneyFrame", displayName = "公會銀行存款"}, c)
		local gbmfg = API:AddElement({name = "GuildBankMoneyFrameGoldButton", displayName = "公會銀行存款金幣"}, c)
		local gbmfs = API:AddElement({name = "GuildBankMoneyFrameSilverButton", displayName = "公會銀行存款銀幣"}, c)
		local gbmfc = API:AddElement({name = "GuildBankMoneyFrameCopperButton", displayName = "公會銀行存款銅幣"}, c)
		API:AddElement({name = "VoidStorageFrame", displayName = "虛空倉庫"}, c) --refuseSync = MOVANY.FRAME_ONLY_WHEN_VOIDSTORAGE_IS_OPEN
		c = API:GetCategory("暴雪按鈕列")
		API:AddElement({name = "MainMenuBar", displayName = "主要功能列", run = function ()
			if not MovAny:IsModified(OverrideActionBar) then
				local v = _G["OverrideActionBar"]
				v:ClearAllPoints()
				v:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (UIParentGetWidth() / 2) - (v:GetWidth() / 2), 0)
			end
		end, hideList = {
			{"MainMenuBarArtFrame", "BACKGROUND","ARTWORK"},
			{"PetActionBarFrame", "OVERLAY"},
			{"StanceBarFrame", "OVERLAY"},
			{"MainMenuBar", "DISABLEMOUSE"},
			}
		}, c)
		API:AddElement({name = "MainMenuBarLeftEndCap", displayName = "左邊獅鷲圖案"}, c)
		API:AddElement({name = "MainMenuBarRightEndCap", displayName = "右邊獅鷲圖案"}, c)
		API:AddElement({name = "MainMenuExpBar", displayName = "經驗條", scaleWH = 1, hideOnScale = {
			MainMenuXPBarTexture0,
			MainMenuXPBarTexture1,
			MainMenuXPBarTexture2,
			MainMenuXPBarTexture3,
			ExhaustionTick,
			ExhaustionTickNormal,
			ExhaustionTickHighlight,
			ExhaustionLevelFillBar,
			MainMenuXPBarTextureLeftCap,
			MainMenuXPBarTextureRightCap,
			MainMenuXPBarTextureMid,
			MainMenuXPBarDiv1,
			MainMenuXPBarDiv2,
			MainMenuXPBarDiv3,
			MainMenuXPBarDiv4,
			MainMenuXPBarDiv5,
			MainMenuXPBarDiv6,
			MainMenuXPBarDiv7,
			MainMenuXPBarDiv8,
			MainMenuXPBarDiv9,
			MainMenuXPBarDiv10,
			MainMenuXPBarDiv11,
			MainMenuXPBarDiv12,
			MainMenuXPBarDiv13,
			MainMenuXPBarDiv14,
			MainMenuXPBarDiv15,
			MainMenuXPBarDiv16,
			MainMenuXPBarDiv17,
			MainMenuXPBarDiv18,
			MainMenuXPBarDiv19,
			}, runOnce = function()
				hooksecurefunc("MainMenuExpBar_SetWidth", function()
					MovAny.API:SyncElement("MainMenuExpBar")
				end)
			end
		}, c)
		API:AddElement({name = "HonorWatchBar", displayName = "榮譽條"}, c)
		API:AddElement({name = "ArtifactWatchBar", displayName = "神兵之力條"}, c)
		API:AddElement({name = "MainMenuBarMaxLevelBar", displayName = "最高等級條列過濾", noFE = 1, noScale = 1}, c)
		API:AddElement({name = "ReputationWatchBar", displayName = "聲望進度條", runOnce = function()
			if ReputationWatchBar_Update then
				hooksecurefunc("ReputationWatchBar_Update", MovAny.hReputationWatchBar_Update)
			end
		end, scaleWH = 1, linkedScaling = {"ReputationWatchStatusBar"}, hideOnScale = {
				ReputationWatchBarTexture0,
				ReputationWatchBarTexture1,
				ReputationWatchBarTexture2,
				ReputationWatchBarTexture3,
				ReputationXPBarTexture0,
				ReputationXPBarTexture1,
				ReputationXPBarTexture2,
				ReputationXPBarTexture3,
			}
		}, c)
		API:AddElement({name = "MicroButtonsMover", displayName = "微型選單"}, c)
		API:AddElement({name = "MicroButtonsSplitMover", displayName = "微型選單 - 分開"}, c)
		API:AddElement({name = "MicroButtonsVerticalMover", displayName = "微型選單 - 垂直"}, c)
		API:AddElement({name = "MainMenuBarVehicleLeaveButton", displayName = "離開載具按鈕"}, c)
		c = API:GetCategory("職業限定")
		API:AddElement({name = "PlayerFrameAlternateManaBar", displayName = "替代法力條"}, c)
		API:AddElement({name = "ComboPointPlayerFrame", displayName = "連擊點數框架"}, c)
		API:AddElement({name = "RuneFrame", displayName = "死亡騎士符文框架"}, c)
		API:AddElement({name = "PaladinPowerBarFrame", displayName = "聖騎士能量框架"}, c)
		API:AddElement({name = "MageArcaneChargesFrame", displayName = "法師祕法充能框架"}, c)
		API:AddElement({name = "WarlockPowerFrame", displayName = "術士能量框架"}, c)
		API:AddElement({name = "MonkHarmonyBarFrameMover", displayName = "武僧真氣框架"}, c)
		API:AddElement({name = "MonkStaggerBar", displayName = "武僧醉仙緩勁框架"}, c)
		API:AddElement({name = "MultiCastActionBarFrame", displayName = "薩滿圖騰框架"}, c)
		API:AddElement({name = "TotemFrame", displayName = "圖騰框架"}, c)
		c = API:GetCategory("地城和團隊")
		API:AddElement({name = "PVEFrame", displayName = "地城搜尋器"}, c)
		API:AddElement({name = "EncounterJournal", displayName = "地城冒險指南"}, c)
		--API:AddElement({name = "LFGSearchStatus", displayName = "地城/團隊搜尋器排隊佇列狀態"}, c)
		API:AddElement({name = "ChallengesKeystoneFrame", displayName = "挑戰鑰石"}, c)
		API:AddElement({name = "DungeonCompletionAlertFrame1", displayName = "地城完成通知"}, c)
		API:AddElement({name = "ScenarioAlertFrame1", displayName = "事件完成通知 1"}, c)
		API:AddElement({name = "ScenarioAlertFrame2", displayName = "事件完成通知 2"}, c)
		API:AddElement({name = "LevelUpDisplay", displayName = "升級通知"}, c)
		API:AddElement({name = "QueueStatusMinimapButton", displayName = "地城狀態按鈕"}, c)
		API:AddElement({name = "QueueStatusFrame", displayName = "地城狀態按鈕滑鼠提示"}, c)
		API:AddElement({name = "LFGDungeonReadyDialog", displayName = "地城準備完成對話框"}, c)
		API:AddElement({name = "LFGDungeonReadyPopup", displayName = "地城準備完成彈出視窗"}, c)
		API:AddElement({name = "LFGDungeonReadyStatus", displayName = "地城準備完成狀態"}, c)
		API:AddElement({name = "LFDRoleCheckPopup", displayName = "地城角色檢查彈出視窗"}, c)
		API:AddElement({name = "RaidBossEmoteFrame", displayName = "團隊首領表情顯示"}, c)
		API:AddElement({name = "Boss1TargetFrame", displayName = "團隊首領血條 1", create = "BossTargetFrameTemplate"}, c)
		API:AddElement({name = "Boss1TargetFramePowerBarAlt", displayName = "團隊首領能量條 1"}, c)
		API:AddElement({name = "Boss2TargetFrame", displayName = "團隊首領血條 2", create = "BossTargetFrameTemplate"}, c)
		API:AddElement({name = "Boss2TargetFramePowerBarAlt", displayName = "團隊首領能量條 2"}, c)
		API:AddElement({name = "Boss3TargetFrame", displayName = "團隊首領血條 3", create = "BossTargetFrameTemplate"}, c)
		API:AddElement({name = "Boss3TargetFramePowerBarAlt", displayName = "團隊首領能量條 3"}, c)
		API:AddElement({name = "Boss4TargetFrame", displayName = "團隊首領血條 4", create = "BossTargetFrameTemplate"}, c)
		API:AddElement({name = "Boss4TargetFramePowerBarAlt", displayName = "團隊首領能量條 4"}, c)
		API:AddElement({name = "Boss5TargetFrame", displayName = "團隊首領血條 5", create = "BossTargetFrameTemplate"}, c)
		API:AddElement({name = "Boss5TargetFramePowerBarAlt", displayName = "團隊首領能量條 5"}, c)
		API:AddElement({name = "RaidBrowserFrame", displayName = "其他團隊"}, c)
		--API:AddElement({name = "RaidParentFrame", displayName = "團隊搜尋器"}, c)
		API:AddElement({name = "CompactRaidGroup1", displayName = "團隊隊伍 1"}, c)
		API:AddElement({name = "CompactRaidGroup2", displayName = "團隊隊伍 2"}, c)
		API:AddElement({name = "CompactRaidGroup3", displayName = "團隊隊伍 3"}, c)
		API:AddElement({name = "CompactRaidGroup4", displayName = "團隊隊伍 4"}, c)
		API:AddElement({name = "CompactRaidGroup5", displayName = "團隊隊伍 5"}, c)
		API:AddElement({name = "CompactRaidGroup6", displayName = "團隊隊伍 6"}, c)
		API:AddElement({name = "CompactRaidGroup7", displayName = "團隊隊伍 7"}, c)
		API:AddElement({name = "CompactRaidGroup8", displayName = "團隊隊伍 8"}, c)
		API:AddElement({name = "CompactRaidFrameManager", displayName = "團隊功能面板"}, c)
		API:AddElement({name = "CompactRaidFrameManagerToggleButton", displayName = "團隊功能面板切換按鈕", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidFrameBuffTooltipsMover", displayName = "團隊框架增益效果滑鼠提示"}, c)
		API:AddElement({name = "CompactRaidFrameDebuffTooltipsMover", displayName = "團隊框架減益效果滑鼠提示"}, c)
		API:AddElement({name = "RolePollPopup", displayName = "團隊角色彈出視窗"}, c)
		API:AddElement({name = "RaidUnitFramesMover", displayName = "團隊單位框架"}, c)
		API:AddElement({name = "RaidWarningFrame", displayName = "團隊警告"}, c)
		API:AddElement({name = "ReadyCheckFrame", displayName = "團隊確認"}, c)
		c = API:GetCategory("首領限定框架")
		API:AddElement({name = "BossBanner", displayName = "首領大標題"}, c)
		local pbab = API:AddElement({name = "PlayerPowerBarAltMover", displayName = "玩家替代能量條"}, c)
		local tbab = API:AddElement({name = "TargetFramePowerBarAltMover", displayName = "目標替代能量條"}, c)
		c = API:GetCategory("遊戲選單")
		API:AddElement({name = "GameMenuFrame", displayName = "遊戲選單",
			hideList = {
				{"GameMenuFrame", "BACKGROUND","ARTWORK","BORDER"},
			}
		}, c)
		API:AddElement({name = "VideoOptionsFrame", displayName = "影像選項", runOnce = function()
				hooksecurefunc(VideoOptionsFrame, "Show", function()
					if MovAny:IsModified("VideoOptionsFrame") then
						HideUIPanel(GameMenuFrame)
					end
				end)
			end, positionReset = function(self, f, opt, readOnly)
		end}, c)
		API:AddElement({name = "AudioOptionsFrame", displayName = "聲音 & 音效選項", runOnce = function()
			hooksecurefunc(AudioOptionsFrame, "Show", function()
				if MovAny:IsModified("AudioOptionsFrame") then
					HideUIPanel(GameMenuFrame)
				end
			end)
		end}, c)
		API:AddElement({name = "InterfaceOptionsFrame", displayName = "介面選項", runOnce = function()
			hooksecurefunc(InterfaceOptionsFrame, "Show", function()
				if MovAny:IsModified("InterfaceOptionsFrame") then
					HideUIPanel(GameMenuFrame)
				end
			end)
		end}, c)
		API:AddElement({name = "KeyBindingFrame", displayName = "按鍵設定選項"}, c)
		API:AddElement({name = "MacroFrame", displayName = "巨集選項"}, c)
		c = API:GetCategory("要塞")
		API:AddElement({name = "GarrisonLandingPage", displayName = "要塞報告"}, c)
		API:AddElement({name = "GarrisonLandingPageMinimapButton", displayName = "要塞小地圖按鈕"}, c)
		API:AddElement({name = "GarrisonBuildingFrame", displayName = "要塞建築"}, c)
		API:AddElement({name = "GarrisonMissionFrame", displayName = "要塞任務"}, c)
		API:AddElement({name = "GarrisonMissionAlertFrame", displayName = "要塞任務通知"}, c)
		API:AddElement({name = "GarrisonBuildingAlertFrame", displayName = "要塞建築通知"}, c)
		API:AddElement({name = "GarrisonFollowerAlertFrame", displayName = "要塞追隨者通知"}, c)
		API:AddElement({name = "GarrisonCapacitiveDisplayFrame", displayName = "要塞訂單"}, c)
		API:AddElement({name = "GarrisonMonumentFrame", displayName = "要塞紀念碑"}, c)
		c = API:GetCategory("船塢")
		API:AddElement({name = "GarrisonShipyardFrame", displayName = "海軍作戰"}, c)
		API:AddElement({name = "GarrisonShipMissionAlertFrame", displayName = "船塢任務通知"}, c)
		API:AddElement({name = "GarrisonShipFollowerAlertFrame", displayName = "船塢追隨者通知"}, c)
		c = API:GetCategory("職業大廳")
		API:AddElement({name = "OrderHallCommandBar", displayName = "職業大廳資訊條"}, c)
		API:AddElement({name = "OrderHallMissionFrame", displayName = "職業大廳任務"}, c)
		API:AddElement({name = "OrderHallTalentFrame", displayName = "職業大廳天賦"}, c)
		API:AddElement({name = "GarrisonTalentAlertFrame", displayName = "職業大廳天賦通知"}, c)
		c = API:GetCategory("公會")
		API:AddElement({name = "GuildFrame", displayName = "公會"}, c)
		gbf:AddCategory(c)
		gbt1:AddCategory(c)
		gbt2:AddCategory(c)
		gbt3:AddCategory(c)
		gbt4:AddCategory(c)
		gbt5:AddCategory(c)
		gbt6:AddCategory(c)
		gbt7:AddCategory(c)
		gbt8:AddCategory(c)
		gisb:AddCategory(c)
		gbis:AddCategory(c)
		gbfw:AddCategory(c)
		gbfd:AddCategory(c)
		gbwm:AddCategory(c)
		gbwmg:AddCategory(c)
		gbwms:AddCategory(c)
		gbwmc:AddCategory(c)
		gbmf:AddCategory(c)
		gbmfg:AddCategory(c)
		gbmfs:AddCategory(c)
		gbmfc:AddCategory(c)
		gcaf:AddCategory(c)
		API:AddElement({name = "GuildControlUI", displayName = "公會控制"}, c)
		local lfgf = API:AddElement({name = "LookingForGuildFrame", displayName = "公會搜尋器"}, c)
		--API:AddElement({name = "GuildInfoFrame", displayName = "公會資訊"}, c)
		API:AddElement({name = "GuildInviteFrame", displayName = "公會邀請"}, c)
		--API:AddElement({name = "GuildLogContainer", displayName = "公會日誌"}, c)
		API:AddElement({name = "GuildMemberDetailFrame", displayName = "公會成員詳細內容"}, c)
		API:AddElement({name = "GuildRegistrarFrame", displayName = "公會註冊員"}, c)
		c = API:GetCategory("資訊內容面板")
		API:AddElement({name = "UIPanelMover1", displayName = "通用資訊內容面板 1 左", noHide = 1}, c)
		API:AddElement({name = "UIPanelMover2", displayName = "通用資訊內容面板 2 中", noHide = 1}, c)
		API:AddElement({name = "UIPanelMover3", displayName = "通用資訊內容面板 3 右", noHide = 1}, c)
		bf:AddCategory(c)
		API:AddElement({name = "CharacterFrame", displayName = "角色 / 聲望 / 兌換通貨"}, c)
		API:AddElement({name = "DressUpFrame", displayName = "試衣間"}, c)
		--API:AddElement({name = "LFDParentFrame", displayName = "地城搜尋器"}, c)
		API:AddElement({name = "ArtifactFrame", displayName = "神兵武器框架"}, c)
		API:AddElement({name = "TaxiFrame", displayName = "飛行路徑"}, c)
		API:AddElement({name = "FlightMapFrame", displayName = "飛行地圖"}, c)
		lfgf:AddCategory(c)
		API:AddElement({name = "GossipFrame", displayName = "閒聊"}, c)
		API:AddElement({name = "InspectFrame", displayName = "觀察"}, c)
		--API:AddElement({name = "LFRParentFrame", displayName = "隨機團隊"}, c)
		--API:AddElement({name = "MacroFrame", displayName = "巨集"}, c)
		API:AddElement({name = "MailFrame", displayName = "信箱"}, c)
		API:AddElement({name = "MerchantFrame", displayName = "商人"}, c)
		API:AddElement({name = "OpenMailFrame", displayName = "開啟郵件"}, c)
		API:AddElement({name = "PetStableFrame", displayName = "獸欄"}, c)
		API:AddElement({name = "FriendsFrame", displayName = "社交 - 好友 / 查詢 / 公會 / 聊天 / 團隊"}, c)
		API:AddElement({name = "WardrobeFrame", displayName = "塑形"}, c)
		pvpf:AddCategory(c)
		--qldf:AddCategory(c)
		--qlf:AddCategory(c)
		qf:AddCategory(c)
		API:AddElement({name = "SpellBookFrame", displayName = "法術書 / 專業"}, c)
		API:AddElement({name = "ItemUpgradeFrame", displayName = "物品升級"}, c)
		API:AddElement({name = "CollectionsJournal", displayName = "收藏"}, c)
		API:AddElement({name = "TabardFrame", displayName = "設計外袍"}, c)
		API:AddElement({name = "PlayerTalentFrame", displayName = "專精 / 天賦 / 雕紋", refuseSync = MOVANY.FRAME_ONLY_ONCE_OPENED}, c)
		API:AddElement({name = "TradeFrame", displayName = "交易"}, c)
		API:AddElement({name = "ArchaeologyFrame", displayName = "考古學"}, c)
		API:AddElement({name = "ReforgingFrame", displayName = "重鑄"}, c)
		API:AddElement({name = "TradeSkillFrame", displayName = "專業技能"}, c)
		API:AddElement({name = "ClassTrainerFrame", displayName = "職業訓練師"}, c)
		API:AddElement({name = "GarrisonCapacitiveDisplayFrame", displayName = "工作訂單"}, c)
		API:AddElement({name = "ReportPlayerNameDialog", displayName = "檢舉玩家名稱"}, c)
		API:AddElement({name = "ReportCheatingDialog", displayName = "檢舉玩家作弊"}, c)
		c = API:GetCategory("戰利品")
		API:AddElement({name = "LootFrame", displayName = "戰利品"}, c)
		API:AddElement({name = "AlertFrame", displayName = "通知框架"}, c)
		--API:AddElement({name = "LootWonAlertFrame1", displayName = "贏得戰利品通知框架 1"}, c)
		--API:AddElement({name = "GroupLootContainer", displayName = "所有戰利品骰子框架", create = "GroupLootFrameTemplate", noScale = 1}, c)
		--API:AddElement({name = "LootWonAlertMover1", displayName = "贏得戰利品通知框架 1"}, c)
		--API:AddElement({name = "LootWonAlertMover2", displayName = "贏得戰利品通知框架 2"}, c)
		--API:AddElement({name = "LootWonAlertMover3", displayName = "贏得戰利品通知框架 3"}, c)
		--API:AddElement({name = "LootWonAlertMover4", displayName = "贏得戰利品通知框架 4"}, c)
		--API:AddElement({name = "LootWonAlertMover5", displayName = "贏得戰利品通知框架 5"}, c)
		--API:AddElement({name = "LootWonAlertMover6", displayName = "贏得戰利品通知框架 6"}, c)
		--API:AddElement({name = "LootWonAlertMover7", displayName = "贏得戰利品通知框架 7"}, c)
		--API:AddElement({name = "LootWonAlertMover8", displayName = "贏得戰利品通知框架 8"}, c)
		--API:AddElement({name = "LootWonAlertMover9", displayName = "贏得戰利品通知框架 9"}, c)
		--API:AddElement({name = "LootWonAlertMover10", displayName = "贏得戰利品通知框架 10"}, c)
		API:AddElement({name = "BonusRollFrame", displayName = "額外戰利品骰子框架", create = "BonusRollFrameTemplate"}, c)
		API:AddElement({name = "BonusRollLootWonFrame", displayName = "贏得的額外物品", create = "LootWonAlertFrameTemplate"}, c)
		API:AddElement({name = "BonusRollMoneyWonFrame", displayName = "贏得的額外金幣", create = "MoneyWonAlertFrameTemplate"}, c)
		--API:AddElement({name = "MoneyWonAlertMover1", displayName = "贏得金幣框架 1"}, c)
		--API:AddElement({name = "MoneyWonAlertMover2", displayName = "贏得金幣框架 2"}, c)
		--API:AddElement({name = "MoneyWonAlertMover3", displayName = "贏得金幣框架 3"}, c)
		--API:AddElement({name = "MoneyWonAlertMover4", displayName = "贏得金幣框架 4"}, c)
		--API:AddElement({name = "MoneyWonAlertMover5", displayName = "贏得金幣框架 5"}, c)
		--API:AddElement({name = "MissingLootFrame", displayName = "遺失戰利品框架"}, c)
		API:AddElement({name = "GroupLootFrame1", displayName = "戰利品骰子 1", create = "GroupLootFrameTemplate"}, c)
		API:AddElement({name = "GroupLootFrame2", displayName = "戰利品骰子 2", create = "GroupLootFrameTemplate"}, c)
		API:AddElement({name = "GroupLootFrame3", displayName = "戰利品骰子 3", create = "GroupLootFrameTemplate"}, c)
		API:AddElement({name = "GroupLootFrame4", displayName = "戰利品骰子 4", create = "GroupLootFrameTemplate"}, c)
		c = API:GetCategory("地圖")
		API:AddElement({name = "WorldMapFrame", displayName = "世界地圖"}, c)
		--API:AddElement({name = "WorldMapLevelDropDown", displayName = "地圖等級"}, c)
		--API:AddElement({name = "WorldMapShowDropDown", displayName = "地圖選項"}, c)
		--API:AddElement({name = "WorldMapTrackQuest", displayName = "地圖追蹤任務"}, c)
		--API:AddElement({name = "WorldMapPositioningGuide", displayName = "地圖座標"}, c)
		c = API:GetCategory("小地圖")
		API:AddElement({name = "MinimapCluster", displayName = "小地圖"}, c)
		API:AddElement({name = "MinimapBorder", displayName = "小地圖邊框材質"}, c)
		API:AddElement({name = "MinimapZoneTextButton", displayName = "小地圖區域文字"}, c)
		API:AddElement({name = "MinimapBorderTop", displayName = "小地圖上方邊框", noScale = 1}, c)
		API:AddElement({name = "MinimapBackdrop", displayName = "小地圖圓形邊框", noAlpha = 1, noScale = 1, hideList = {{"MinimapBackdrop", "ARTWORK"}}}, c)
		API:AddElement({name = "MinimapNorthTag", displayName = "小地圖北方指示圖示", noScale = 1}, c)
		API:AddElement({name = "GameTimeFrame", displayName = "小地圖行事曆按鈕"}, c)
		API:AddElement({name = "TimeManagerClockButton", displayName = "小地圖時鐘按鈕"}, c)
		API:AddElement({name = "MiniMapInstanceDifficulty", displayName = "小地圖地城難度"}, c)
		API:AddElement({name = "GuildInstanceDifficulty", displayName = "小地圖公會隊伍旗幟"}, c)
		API:AddElement({name = "QueueStatusMinimapButton", displayName = "小地圖排隊佇列按鈕"}, c)
		API:AddElement({name = "MiniMapMailFrame", displayName = "小地圖郵件通知"}, c)
		API:AddElement({name = "MiniMapTracking", displayName = "小地圖追蹤按鈕"}, c)
		API:AddElement({name = "MinimapZoomIn", displayName = "小地圖放大按鈕"}, c)
		API:AddElement({name = "MinimapZoomOut", displayName = "小地圖縮小按鈕"}, c)
		API:AddElement({name = "MiniMapWorldMapButton", displayName = "小地圖世界地圖按鈕"}, c)
		API:AddElement({name = "BattlefieldMinimap", displayName = "區域小地圖"}, c)
		c = API:GetCategory("其他")
		API:AddElement({name = "ActionStaus", displayName = "動作狀態"}, c)
		API:AddElement({name = "TimeManagerFrame", displayName = "鬧鐘"}, c)
		API:AddElement({name = "BlackMarketFrame", displayName = "黑市拍賣場", runOnce = BlackMarketFrame_Show}, c)
		API:AddElement({name = "AuctionFrame", displayName = "拍賣場", runOnce = function()
			local af = _G.AuctionFrame
			if not af then
				return true
			end
			local f = _G.SideDressUpFrame
			if f and not MovAny:IsModified(f) then
				f:ClearAllPoints()
				f:SetPoint("TOPLEFT", af, "TOPRIGHT", - 2, - 28)
			end
		end}, c)
		API:AddElement({name = "SideDressUpFrame", displayName = "拍賣場試衣間"}, c)
		API:AddElement({name = "AuctionProgressFrame", displayName = "拍賣場建立拍賣進度"}, c)
		API:AddElement({name = "BarberShopFrame", displayName = "美容院"}, c)
		API:AddElement({name = "BNToastFrame", displayName = "Battle.Net 彈出訊息"}, c)
		API:AddElement({name = "QuickJoinToastMover", displayName = "快速加入彈出訊息"}, c)
		API:AddElement({name = "QuickJoinToast2Mover", displayName = "快速加入彈出訊息 2"}, c)
		API:AddElement({name = "QuickJoinToastButton", displayName = "快速加入彈出訊息按鈕"}, c)
		API:AddElement({name = "MirrorTimer1", displayName = "呼吸疲勞條"}, c)
		API:AddElement({name = "CalendarFrame", displayName = "行事曆"}, c)
		API:AddElement({name = "CalendarViewEventFrame", displayName = "行事曆活動"}, c)
		API:AddElement({name = "ChannelPullout", displayName = "頻道清單"}, c)
		API:AddElement({name = "ChatConfigFrame", displayName = "聊天頻道設定"}, c)
		API:AddElement({name = "ChatEditBoxesMover", displayName = "聊天輸入框"}, c)
		API:AddElement({name = "ChatEditBoxesLengthMover", displayName = "聊天輸入框長度", scaleWH = 1}, c)
		API:AddElement({name = "ColorPickerFrame", displayName = "顏色選取器"}, c)
		API:AddElement({name = "TokenFramePopup", displayName = "兌換通貨選項"}, c)
		API:AddElement({name = "ItemRefTooltip", displayName = "聊天彈出視窗滑鼠提示"}, c)
		API:AddElement({name = "DurabilityFrame", displayName = "耐久度圖示"}, c)
		API:AddElement({name = "UIErrorsFrame", displayName = "顯示錯誤 & 警告"}, c)
		API:AddElement({name = "FramerateLabelMover", displayName = "每秒幀數", noScale = 1, noUnanchorRelatives = 1}, c)
		API:AddElement({name = "ItemSocketingFrame", displayName = "寶石插槽"}, c)
		API:AddElement({name = "HelpFrame", displayName = "客服支援"}, c)
		API:AddElement({name = "LevelUpDisplay", displayName = "升級通知"}, c)
		API:AddElement({name = "MacroPopupFrame", displayName = "巨集名稱 & 圖示"}, c)
		API:AddElement({name = "StaticPopup1", displayName = "固定彈出視窗 1"}, c)
		API:AddElement({name = "StaticPopup2", displayName = "固定彈出視窗 2"}, c)
		API:AddElement({name = "StaticPopup3", displayName = "固定彈出視窗 3"}, c)
		API:AddElement({name = "StaticPopup4", displayName = "固定彈出視窗 4"}, c)
		API:AddElement({name = "StreamingIcon", displayName = "串流下載圖示"}, c)
		API:AddElement({name = "ItemTextFrame", displayName = "閱讀內容"}, c)
		API:AddElement({name = "ReputationDetailFrame", displayName = "聲望詳細內容"}, c)
		API:AddElement({name = "GhostFrame", displayName = "回到墓地按鈕"}, c)
		API:AddElement({name = "HelpOpenWebTicketButton", displayName = "回報單狀態"}, c)
		API:AddElement({name = "HelpOpenTicketButtonTutorial", displayName = "回報單狀態說明"}, c)
		API:AddElement({name = "TooltipMover", displayName = "滑鼠提示"}, c)
		API:AddElement({name = "BagItemTooltipMover", displayName = "滑鼠提示 - 背包物品"}, c)
		API:AddElement({name = "GuildBankItemTooltipMover", displayName = "滑鼠提示 - 公會銀行物品"}, c)
		wsauf:AddCategory(c)
		API:AddElement({name = "TalentMicroButtonAlert", displayName = "尚未儲存的天賦變更通知"}, c)
		API:AddElement({name = "TutorialFrameAlertButton", displayName = "說明通知按鈕"}, c)
		API:AddElement({name = "VoiceChatTalkers", displayName = "語音聊天人員"}, c)
		API:AddElement({name = "ZoneTextFrame", displayName = "地區文字"}, c)
		API:AddElement({name = "SubZoneTextFrame", displayName = "子地區文字"}, c)
		c = API:GetCategory("版面配置插件")
		API:AddElement({name = "MAOptions", displayName = "版面配置視窗",
			hideList = {
				{"MAOptions", "ARTWORK","BORDER"},
			}
		}, c)
		--API:AddElement({name = "MA_FEMover", displayName = "MoveAnything Frame Editor Config", noHide = 1}, c)
		API:AddElement({name = "MANudger", displayName = "版面配置移動控制項"}, c)
		API:AddElement({name = "GameMenuButtonMoveAnything", displayName = "版面配置遊戲選單按鈕"}, c)
		c = API:GetCategory("單位: 專注")
		API:AddElement({name = "FocusFrame", displayName = "專注目標"}, c)
		API:AddElement({name = "FocusFrameTextureFramePVPIcon", displayName = "專注目標 PVP 圖示"}, c)
		API:AddElement({name = "FocusBuffsMover", displayName = "專注目標增益效果"}, c)
		API:AddElement({name = "FocusDebuffsMover", displayName = "專注目標減益效果"}, c)
		API:AddElement({name = "FocusFrameSpellBar", displayName = "專注目標施法條", noAlpha = 1}, c)
		API:AddElement({name = "FocusFrameToT", displayName = "專注目標的目標"}, c)
		API:AddElement({name = "FocusFrameToTDebuffsMover", displayName = "專注目標的目標減益效果"}, c)
		c = API:GetCategory("單位: 隊伍")
		API:AddElement({name = "PartyMemberFrame1", displayName = "隊伍成員 1"}, c)
		API:AddElement({name = "PartyMember1DebuffsMover", displayName = "隊伍成員 1 減益效果"}, c)
		API:AddElement({name = "PartyMemberFrame2", displayName = "隊伍成員 2"}, c)
		API:AddElement({name = "PartyMember2DebuffsMover", displayName = "隊伍成員 2 減益效果"}, c)
		API:AddElement({name = "PartyMemberFrame3", displayName = "隊伍成員 3"}, c)
		API:AddElement({name = "PartyMember3DebuffsMover", displayName = "隊伍成員 3 減益效果"}, c)
		API:AddElement({name = "PartyMemberFrame4", displayName = "隊伍成員 4"}, c)
		API:AddElement({name = "PartyMember4DebuffsMover", displayName = "隊伍成員 4 減益效果"}, c)
		c = API:GetCategory("單位: 寵物")
		API:AddElement({name = "PetFrame", displayName = "寵物"}, c)
		API:AddElement({name = "PetCastingBarFrame", displayName = "寵物施法條"}, c)
		API:AddElement({name = "PetDebuffsMover", displayName = "寵物減益效果"}, c)
		API:AddElement({name = "PartyMemberFrame1PetFrame", displayName = "隊伍寵物 1"}, c)
		API:AddElement({name = "PartyMemberFrame2PetFrame", displayName = "隊伍寵物 2"}, c)
		API:AddElement({name = "PartyMemberFrame3PetFrame", displayName = "隊伍寵物 3"}, c)
		API:AddElement({name = "PartyMemberFrame4PetFrame", displayName = "隊伍寵物 4"}, c)
		c = API:GetCategory("單位: 玩家")
		API:AddElement({name = "PlayerFrame", displayName = "玩家"}, c)
		API:AddElement({name = "PlayerPVPIcon", displayName = "玩家 PVP 圖示"}, c)
		API:AddElement({name = "PlayerRestIcon", displayName = "玩家休息狀態圖示"}, c)
		API:AddElement({name = "PlayerRestGlow", displayName = "玩家休息狀態圖示發光"}, c)
		API:AddElement({name = "PlayerAttackIcon", displayName = "玩家攻擊圖示"}, c)
		API:AddElement({name = "PlayerAttackGlow", displayName = "玩家攻擊圖示發光"}, c)
		API:AddElement({name = "PlayerAttackBackground", displayName = "玩家攻擊圖示背景"}, c)
		API:AddElement({name = "PlayerStatusTexture", displayName = "玩家狀態材質"}, c)
		API:AddElement({name = "PlayerStatusGlow", displayName = "玩家狀態發光"}, c)
		API:AddElement({name = "PlayerLeaderIcon", displayName = "玩家隊長圖示"}, c)
		API:AddElement({name = "PlayerMasterIcon", displayName = "玩家主要圖示"}, c)
		API:AddElement({name = "PlayerBuffsMover", displayName = "玩家增益效果 - 預設"}, c)
		API:AddElement({name = "PlayerBuffsMover2", displayName = "玩家增益效果 - 右至左"}, c)
		--API:AddElement({name = "ConsolidatedBuffs", displayName = "合併增益效果"}, c)
		--API:AddElement({name = "ConsolidatedBuffsTooltip", displayName = "玩家增益效果 - 合併增益效果滑鼠提示"}, c)
		API:AddElement({name = "PlayerDebuffsMover", displayName = "玩家減益效果 - 預設"}, c)
		API:AddElement({name = "PlayerDebuffsMover2", displayName = "玩家減益效果 - 右至左"}, c)
		API:AddElement({name = "DigsiteCompleteToastFrame", displayName = "挖掘完成方塊"}, c)
		API:AddElement({name = "ArcheologyDigsiteProgressBar", displayName = "考古學挖掘進度條"}, c)
		API:AddElement({name = "PlayerHitIndicator", displayName = "治療/傷害數字"}, c)
		API:AddElement({name = "CastingBarFrame", displayName = "施法條", noAlpha = 1}, c)
		API:AddElement({name = "PlayerFrameGroupIndicator", displayName = "玩家小隊提示"}, c)
		API:AddElement({name = "LossOfControlFrame", displayName = "失去控制"}, c)
		pbab:AddCategory(c)
		API:AddElement({name = "SpellActivationOverlayFrame", displayName = "職業技能觸發效果"}, c)
		API:AddElement({name = "PlayerTalentFrame", displayName = "天賦 / 雕紋"}, c)
		c = API:GetCategory("單位: 目標")
		API:AddElement({name = "TargetFrame", displayName = "目標"}, c)
		API:AddElement({name = "TargetFrameTextureFramePVPIcon", displayName = "目標 PVP 圖示"}, c)
		API:AddElement({name = "TargetBuffsMover", displayName = "目標增益效果"}, c)
		API:AddElement({name = "TargetDebuffsMover", displayName = "目標減益效果"}, c)
		--API:AddElement({name = "ComboFrame", displayName = "目標上的連擊點數"}, c)
		API:AddElement({name = "TargetFrameSpellBar", displayName = "目標施法條", noAlpha = 1}, c)
		API:AddElement({name = "TargetFrameToT", displayName = "目標的目標"}, c)
		API:AddElement({name = "TargetFrameToTDebuffsMover", displayName = "目標的目標減益效果"}, c)
		API:AddElement({name = "TargetFrameNumericalThreat", displayName = "目標仇恨提示"}, c)
		tbab:AddCategory(c)
		c = API:GetCategory("載具")
		API:AddElement({name = "OverrideActionBar", displayName = "載具列",
			hideList = {
				{"OverrideActionBar", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
				{"OverrideActionBarLeaveFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
				--{"OverrideActionBarArtFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
				--{"OverrideActionBarButtonFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"}
			}
		}, c)
		API:AddElement({name = "OverrideActionBarExpBar", displayName = "載具經驗值條", onlyOnceCreated = 1}, c)
		API:AddElement({name = "OverrideActionButtonsMover", displayName = "載具快捷列", runOnce = function()
			OverrideActionBarButtonFrame:SetSize((OverrideActionBarButton1:GetWidth() + 2) * VEHICLE_MAX_ACTIONBUTTONS, OverrideActionBarButton1:GetHeight() + 2)
		 end}, c)
		API:AddElement({name = "OverrideActionBarHealthBar", displayName = "載具血量條", onlyOnceCreated = 1}, c)
		API:AddElement({name = "OverrideActionBarPowerBar", displayName = "載具能量條", onlyOnceCreated = 1}, c)
		API:AddElement({name = "OverrideActionBarLeaveFrame", displayName = "載具離開框架"}, c)
		--API:AddElement({name = "MicroButtonsVehicleMover", displayName = "載具微型條"}, c)
		API:AddElement({name = "VehicleSeatIndicator", displayName = "載具騎乘提示"}, c)
		c = API:GetCategory("寵物對戰")
		API:AddElement({name = "PetBattleMover7", displayName = "右上方圖案", noScale = 1}, c)
		API:AddElement({name = "PetBattleMover8", displayName = "左上方圖案", noScale = 1}, c)
		API:AddElement({name = "PetBattleMover9", displayName = "左上方中間", noScale = 1}, c)
		API:AddElement({name = "PetBattleMover3", displayName = "天氣"},c)
		API:AddElement({name = "PetBattleMover1", displayName = "玩家寵物框架"}, c)
		API:AddElement({name = "PetBattleMover2", displayName = "對手寵物框架"}, c)
		API:AddElement({name = "PetBattleMover6", displayName = "下方框架"}, c)
		API:AddElement({name = "PetBattleMover5", displayName = "選擇寵物框架"}, c)
		API:AddElement({name = "PetBattleMover4", displayName = "跳過這一回合按鈕"}, c)
		API:AddElement({name = "PetBattleMover11", displayName = "玩家寵物 2"}, c)
		API:AddElement({name = "PetBattleMover12", displayName = "玩家寵物 3"}, c)
		API:AddElement({name = "PetBattleMover22", displayName = "對手寵物 2"}, c)
		API:AddElement({name = "PetBattleMover23", displayName = "對手寵物 3"}, c)
		API:AddElement({name = "PetBattleMover24", displayName = "玩家寵物增益效果"}, c)
		API:AddElement({name = "PetBattleMover25", displayName = "玩家寵物減益效果"}, c)
		API:AddElement({name = "PetBattleMover26", displayName = "玩家寵物持續增益效果"}, c)
		API:AddElement({name = "PetBattleMover27", displayName = "玩家寵物持續減益效果"}, c)
		API:AddElement({name = "PetBattleMover28", displayName = "對手寵物增益效果"}, c)
		API:AddElement({name = "PetBattleMover29", displayName = "對手寵物減益效果"}, c)
		API:AddElement({name = "PetBattleMover30", displayName = "對手寵物持續增益效果"}, c)
		API:AddElement({name = "PetBattleMover31", displayName = "對手寵物持續減益效果"}, c)
		API:AddElement({name = "PetBattlePrimaryAbilityTooltip", displayName = "寵物對戰主要技能滑鼠提示"}, c)
		API:AddElement({name = "PetBattlePrimaryUnitTooltip", displayName = "寵物對戰主要單位滑鼠提示"}, c)
		API:AddElement({name = "BattlePetTooltip", displayName = "寵物對戰滑鼠提示"}, c)
		API:AddElement({name = "FloatingBattlePetTooltip", displayName = "寵物對戰浮動滑鼠提示"}, c)
		API:AddElement({name = "FloatingPetBattleAbilityTooltip", displayName = "寵物對戰技能浮動滑鼠提示"}, c)
		API:AddElement({name = "StartSplash", displayName = "戰鬥開始提示"}, c)
		c = API:GetCategory("遊戲商城")
		API:AddElement({name = "StorePurchaseAlertFrame", displayName = "商城購買通知"}, c)
		API:AddElement({name = "ModelPreviewFrame", displayName = "商成模組預覽"}, c)
		c = API:AddCategory({name = "版面配置插件內部元素"})
		--API:AddElement({name = "AlwaysUpFrame1", hidden = 1, onlyOnceCreated = 1}, c)
		--API:AddElement({name = "AlwaysUpFrame2", hidden = 1, onlyOnceCreated = 1}, c)
		--API:AddElement({name = "AlwaysUpFrame3", hidden = 1, onlyOnceCreated = 1}, c)
		API:AddElement({name = "MainMenuBarArtFrame", hidden = 1, noScale = 1}, c)
		--API:AddElement({name = "WorldMapFrame", hidden = 1, refuseSync = "Unsuppported", unsupported = 1}, c)
		API:AddElement({name = "PaperDollFrame", hidden = 1, unsupported = 1}, c)
		API.default = nil
		API.customCat = API:AddCategory({name = "自訂框架"})
	end
}

MovAny:AddCore("FrameList", m)
