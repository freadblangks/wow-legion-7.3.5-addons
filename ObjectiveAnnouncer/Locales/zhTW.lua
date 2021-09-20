local L = LibStub("AceLocale-3.0"):NewLocale("Objective Announcer", "zhTW", false)

	-------------------
	-- Configuration --
	-------------------

	-- General --
		-- Announcement Modes --
L["announcemode"] = "通報模式"
L["announcedesc"] = "設定何時要通報任務目標的完成進度。"
L["annmodesdesc"] = "選擇通報類型。|n|cFF9ffbff完成任務：|r只有整個任務全部完成時才通報。|n|cFF9ffbff達成目標：|r只有任務內的其中一個任務目標完成時才通報。|n|cFF9ffbff任務 & 目標：|r 達成任務目標或任務全部完成時都要通報。|n|cFF9ffbff目標進度：|r任務目標每次有新的進度時都要通報。|n|cFF9ffbff進度 & 完成任務：|r任務目標每次有新的進度和任務全部完成時都要通報。"
L["annvalues"] = {	"完成任務",
					"達成目標",
					"任務 & 目標",
					"目標進度",
					"進度 & 完成任務" }
L["progressbardesc"] = "使用 \"任務 & 目標\" 模式，而且獎勵目標有進度條時，設定通報的發佈頻率。"
L["progbarinterval"] = "進度條 % 間隔"
L["progbarintervaldesc"] = "進度條任務發佈通報的頻率。|n|cFF9ffbff只對 \"任務 & 目標\"、\"目標進度\" 和 \"進度 & 完成任務\" 有效，每次有新的進度時都會通報。|r"

		-- Announcement Channels --
L["annchannels"] = "通報到"
L["annchannelsdesc"] = "設定誰會看到通報。"
L["privateannheader"] = "私人通報"
L["Self"] = "自己"
L["selfdesc"] = "設定沒有公開的通報時，是否要通報給自己。|n|cFF9ffbff在上方的通知自己標籤頁面中選擇輸出給自己的訊息的位置。"
L["selfalways"] = "永遠通報給自己"
L["selfalwaysdesc"] = "就算已有公開的通報，也還是要通報給自己。"
L["selfcolor"] = "通報給自己的訊息顏色"
L["selfcolordesc"] = "選擇顏色。"
L["publicheader"] = "公開通報"
L["saydesc"] = "設定是否要通報到一般說話頻道。"
L["partydesc"] = "設定是否要通報到隊伍聊天頻道。"
L["instancedesc"] = "設定在隨機隊伍中時，是否要通報到副本聊天頻道。"
L["raiddesc"] = "設定是否要通報到團隊聊天頻道。"
L["guilddesc"] = "設定是否要通報到公會聊天頻道。|n|cFFF02121(將會停用通報到公會幹部聊天頻道)"
L["officerdesc"] = "設定是否要通報到公會幹部聊天頻道。|n|cFF9ffbff(只在沒有通報到公會聊天頻道時才有作用)"
L["channeldesc"] = "設定是否要通報到聊天頻道。請先確定不會干擾到其他玩家!"
L["channelselect"] = "選擇頻道"
L["channelselectdesc"] = "|n|cFF9ffbff如果加入頻道時已經開啟了這個選項選單，請關閉再重新開啟介面選單，以便更新頻道列表。"

	-- Out of Range Alerts --
L["oor"] = "超出範圍警告"
L["oordesc"] = "無法獲得擊殺類型任務的進度時會提醒。"
L["oorrequires"] = "超出範圍警告需要隊友或團隊成員也有安裝這個 Objective Announcer 插件才能發揮作用。"
L["oorenable"] = "啟用超出範圍警告"
L["oorenabledesc"] = "也有安裝 Objective Announcer 插件的隊友擊殺任務怪，但你卻無法獲得任務進度時，要發佈通報。"

	-- Extra Information --
L["extrainfo"] = "更多資訊"
L["extrainfodesc"] = "在通報中加入任務相關的更多資訊。"
L["extrainfoquestlink"] = "任務連結"
L["extrainfoquestlinkdesc"] = "在目標和進度通報中加入可以點擊的相關任務連結。"
L["extrainfosugggroup"] = "建議隊伍人數"
L["extrainfosugggroupdesc"] = "在通報中加入建議的任務隊伍人數。"
L["extrainfoquesttag"] = "任務標籤"
L["extrainfoquesttagdesc"] = "在通報中加入任務的特殊標籤。|n|cFF9ffbff小隊、團隊、帳號共通...等等。"
L["extrainfofreq"] = "每日和每週"
L["extrainfofreqdesc"] = "在通報中加入這是每日或每週任務。"
L["extrainfoquestlevel"] = "任務等級"
L["extrainfoquestleveldesc"] = "在通報中加入任務等級。"

	-- Quest Start / End --
L["queststartend"] = "任務開始/結束"
L["headerstart"] = "任務開始"
L["headerend"] = "任務結束"
L["qsedesc"] = "任務開始和結束時發佈通報。"
L["qseaccept"] = "接受任務"
L["qseacceptdesc"] = "接受任務時發佈通報。"
L["qseturnin"] = "交回任務"
L["qseturnindesc"] = "交回任務時發佈通報。"
L["qseabandon"] = "放棄任務"
L["qseabandondesc"] = "放棄任務時發佈通報。"
L["qsefail"] = "任務失敗"
L["qsefaildesc"] = "任務失敗時發佈通報。"
L["qseexp"] = "獲得經驗值"
L["qseexpdesc"] = "發佈交回任務時獲得多少經驗值的通報。"
L["qserewards"] = "選擇獎勵"
L["qserewardsdesc"] = "發佈你所獲得的獎勵的通報。"
L["qseescort"] = "自動接受護送/事件任務"
L["qseescortdesc"] = "自動接受由隊友所開始的事件任務。"
L["qseautocomplete"] = "自動完成"
L["qseautocompletedesc"] = "當你完成可以遠距離完成的任務時發佈額外的通報。|n|cFF9ffbff也會顯示遠距離交回任務的對話視窗。"
L["qsebonusobj"] = "獎勵目標 & 世界任務"
L["qsebonusobjdesc"] = "獎勵目標和世界任務區域發佈額外的通報。|n|cFF9ffbff進入區域或離開該區域。"

	-- Sound --
L["sounddesc"] = "任務相關事件播放的音效。"
L["soundcompletion"] = "完成音效"
L["soundcompletiondesc"] = "設定發佈通報時是否要播放音效。|n|cFF9ffbff只有會發佈通報的才會播放"
L["soundobjcompletefile"] = "達成目標"
L["soundobjcompletefiledesc"] = "選擇達成任務目標時要播放的音效"
L["soundquestcompletefile"] = "任務完成"
L["soundquestcompletefiledesc"] = "選擇任務完成時要播放的音效"
L["soundacceptfail"] = "接受/失敗音效"
L["soundacceptfaildesc"] = "設定接受任務和任務失敗時是否要播放音效。|n|cFF9ffbff只有會發佈通報的才會播放"
L["soundacceptfile"] = "接受任務"
L["soundacceptfiledesc"] = "選擇接受任務時要播放的音效"
L["soundfailfile"] = "任務失敗"
L["soundfailfiledesc"] = "選擇任務失敗時要播放的音效"
L["soundcommunication"] = "他人任務通報音效"
L["soundcommunicationdesc"] = "設定其他使用 Objective Announcer 插件的玩家發佈通報時是否要播放音效。"
L["soundcommfile"] = "他人任務通報"
L["soundcommfiledesc"] = "選擇其他玩家發佈任務目標通報時要播放的音效"

	-- Self Outputs (LibSink) --
L["selfoutput"] = "通知自己"
L["selfoutputdesc"] = "選擇輸出給自己的任務目標訊息的位置。"

	-- Chat Slash Commands --
L["enabled"] = "啟用"
L["chat"] = " 聊天 "
L["slashquest"] = "現在只會通報完成任務"
L["slashobj"] = "現在只會通報達成目標"
L["slashboth"] = "現在會通報完成任務 & 達成目標"
L["slashprog"] = "現在會通報目標進度"
L["slashprogq"] = "現在會通報目標進度 & 完成任務"
L["slashself"] = "通知自己"
L["slashselfdis"] = "(永遠通報給自己也已停用)"
L["slashpublicerror"] = "有效的聊天頻道名稱為：say, party, instance, raid, guild, officer & channel。"
		-- Quest Start/End --	
L["slashquestaccept"] = "通報接受任務"
L["slashquestturnin"] = "通報交回任務"
L["slashquestexp"] = "通報獲得的經驗值"
L["slashquestrewards"] = "通報任務獎勵"
L["slashquestescort"] = "自動接受護送任務"
L["slashquestfail"] = "通報任務失敗"
		-- Sounds --
L["slashsoundcompletion"] = "任務/目標完成音效"
L["slashsoundacceptfail"] = "任務接受/失敗音效"
L["slashsoundcomm"] = "他人通報音效"



	-------------------
	-- Announcements --
	-------------------
	
--L[""] = 
L["areaentered"] = "進入區域"
L["arealeft"] = "離開區域"
L["taskcomplete"] = "完成獎勵目標"
L["worldquestcomplete"] = "完成世界任務"
L["autoaccept1"] = "自動接受"
L["autoaccept2"] = "開始，由"
L["autocompletealert"] = "自動完成警告"
L["expgain"] = "獲得經驗值"
L["rewardchosen"] = "獲得獎勵，來自"
L["oornotreceived"] = "無法獲得任務進度：\""	-- Be sure to keep the ( \" ) at the end of the string.
L["questaccepted"] = "接受任務"
L["questfailed"] = "任務失敗"
L["questturnin"] = "交回任務"



	-------------
	-- Strings --
	-------------
	
L["slain"] = "擊殺"	-- The exact word used for quests to kill mobs.
L["killed"] = "已擊殺"	-- The exact word used for quests to kill mobs.


	------------
	-- Popups --
	------------

L["popupoorupdate"] = "任務進度通報 Objective Announcer 插件的超出範圍警告功能已經更新，請告知你的隊友更新，以避免發生錯誤。"

L["ObjectiveAnnouncer"] = "任務進度通報"
L["Objective Announcer"] = "任務-進度通報"
L["Self Outputs"] = "通知自己"
L["Profiles"] = "設定檔"