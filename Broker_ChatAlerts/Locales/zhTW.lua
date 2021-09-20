--[[ *******************************************************************
Project                 : Broker_ChatAlerts
Description             : Traditional Chinese translation file (zhTW)
Author                  : 
Translator              : 彩虹ui
Revision                : $Rev: 1 $
********************************************************************* ]]

local ADDON = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON, "zhTW")
if not L then return end

L["Deactivated"] = "停用"
L["Activated"] = "啟用"
L["Filtered"] = "過濾"

L["Settings"] = "設定"

L["General"] = "一般"
L["Setup general options."] = "設定一般選項。"

L["Default Alert Location"] = "預設通知位置"
L["Choose what method you would like to use for displaying text alerts. SCT, Mik's Scrolling Battle Text, Parrot, Blizzard Scrolling Text, and the default UI are supported. Grayed-out entries are currently not active."] = "選擇你想要用來顯示文字通知的方法。支援 SCT, MSBT捲動戰鬥文字, Parrot, 暴雪捲動文字和預設介面。灰色的項目代表目前無法使用。"
L["Message Filters"] = "訊息過濾器"
L["Message filters will be applied before processing channel messages. Message filters are introduced by other addons such as spam filtering addons."] = "訊息過濾器會在處理頻道訊息之前套用。訊息過濾器是由其他插件所提供的功能，像是過濾濫發訊息的插件。"
L["Notification Sound"] = "通知音效"
L["Choose sound to be played on notifications."] = "選擇通知時要播放的音效。"
L["Play Sound"] = "播放音效"
L["Play selected notification sound."] = "播放選擇的音效。"
L["Show in Combat"] = "戰鬥中顯示"
L["Show alerts while engaged in combat."] = "正在戰鬥時也要顯示訊息。"
L["Show out of Combat"] = "非戰鬥中顯示"
L["Show alerts while out of combat."] = "不在戰鬥中時顯示訊息。"
L["Show own Messages"] = "顯示我的訊息"
L["Show your own messages."] = "也顯示自己的訊息。"

L["Message Format"] =  "訊息格式"
L["Setup message format."] = "設定訊息格式。"
L["Wrap Lines"] = "自動換行"
L["Wrap lines before displaying text alerts."] = "顯示文字通知前先換行。"
L["Line Length"] = "每行長度"
L["Wrap message for text alerts to this line length if wrapping is active."] = "啟用自動換行時，將文字通知的訊息內容調整為這裡所設定的每行長度。"
L["Show Sender Icon"] = "顯示發送者圖示"
L["Show icon indicating race and gender of sender character."] = "顯示代表訊息發送者角色的種族和性別圖示。"
L["Show Client Icon"] = "顯示程式圖示"
L["Show icon indicating client of sender in Battle.Net conversations."] = "在 Battle.Net 對話中顯示代表訊息發送者所使用的程式圖示。"
L["Icon Size"] = "圖示大小"
L["Size of displayed icons."] = "顯示的圖示大小。"

L["Display Addons"] = "顯示插件"
L["Setup supported display addons."] = "設定已支援的顯示插件。"

L["Scroll Area"] = "捲動區域"
L["Select display area used by provider."] = "選擇插件所使用的顯示區域。"
L["Sticky"] = "只在區域內顯示"
L["Make alert text sicky in scroll area."] = "通知文字只在這個捲動區域內顯示。"
				
L["Message Events"] = "訊息活動"
L["Set up alerts for message events"] = "為訊息活動設定通知。"
L["Channel Alerts"] = "頻道通知"
L["Set up alerts for specific channels"] = "為指定的頻道設定通知。"

L["Text Message Alerts"] = "文字訊息通知"
L["Choose message types where you want text displayed."] = "選擇要顯示文字通知的訊息類型。"
L["Set text alerts for specific channels"] = "為指定的頻道設定文字通知"
L["Sound Alerts"] = "音效通知"
L["Choose message types where you to hear a notify sound."] = "選擇要聽到提醒音效的訊息類型。"
L["Set sounds for specific channels"] = "為指定的頻道設定音效"
L["Scroll Area"] = "捲動區域"
L["Choose a specific location for the message alert other than the default location."] = "選擇預設位置以外，要顯示訊息通知的指定區域。"
L["Choose a specific location for the channel alert other than the default location."] = "選擇預設位置以外，要顯示頻道通知的指定區域。"

L["Loot Options"] = "拾取選項"
L["Choose message types where you want text displayed."] = "選擇要顯示文字通知的訊息類型。"

L["Minimum Rarity - Self"] = "最低稀有程度 - 自己"
L["Choose the minimum rarity to alert when looting."] = "選擇自己拾取戰利品時要顯示通知的最低稀有程度。"
L["Minimum Rarity - Others"] = "最低稀有程度 - 其他"
L["Choose the minimum rarity to alert when OTHERS are looting."] = "選擇其他人拾取戰利品時要顯示通知的最低稀有程度。"
L["Show my loot only"] = "只顯示我的拾取"
L["Toggle whether or not to show other looters or just your own."] = "切換要顯示其他人的拾取還是只有自己的。"
L["Show total quanity"] = "顯示全部的數量"
L["Toggle whether the total quantity in your bags should be shown in the loot text alert."] = "切換是否要在拾取文字通知中顯示背包中的全部數量"
L["Show need and winner only"] = "只顯示需到的"
L["Toggle whether to show only Need and Winner on rolls."] = "切換擲骰物品時是否只顯示需求並且贏得的。"

L["Filter Options"] = "過濾選項"
L["Filter for events and channel messages."] = "過濾活動和頻道訊息。"

L["Player Name"] = "玩家名字"
L["Message will be shown if it contains the player name."] = "包含指定的玩家名字時會顯示訊息。"
L["Keywords"] = "關鍵字"
L["List of keywords. Message will be shown if any keyword is matched."] = "關鍵字清單。符合任何一個關鍵字時會顯示訊息。"

L["Test Alert Locations"] = "測試通知位置"
L["Test text alerts settings."] = "測試文字通知的設定。"

L["Test Event"] = "測試事件"
L["Select event mimicked for the test."] = "選擇用來測試模擬的活動。"
L["Test Text"] = "測試文字"
L["Text to display for test."] = "要顯示的測試文字。"
L["Execute Test"] = "執行測試"
L["Execute test event."] = "執行測試活動。"

L["Minimap Button"] = "小地圖按鈕"
L["Show Minimap Button"] = "顯示小地圖按鈕。"
L["Hide Hint"] = "隱藏提示"
L["Hide usage hint in tooltip"] = "隱藏滑鼠提示說明"

L["Default"] = "預設"

L["Version"] = "版本"

L["Usage:"] = "指令用法:"
L["/bchatalerts arg"] = "/bchatalerts 參數"
L["/bca arg"] = "/bca 參數"
L["Args:"] = "可用參數:"
L["version - display version information"] = "version - 顯示版本資訊"
L["menu - display options menu"] = "menu - 顯示選項設定"
L["help - display this help"] = "help - 顯示指令用法說明"

L["Poor"] = "粗糙"
L["Common"] = "一般"
L["Uncommon"] = "優秀"
L["Rare"] = "精良"
L["Epic"] = "史詩"
L["Legendary"] = "傳說"
L["Artifact"] = "神兵武器"

L["system"] = "系統"
L["whisper"] = "密語"
L["party"] = "隊伍"
L["raid"] = "團隊"
L["instance"] = "副本"
L["bg"] = "戰場"
L["bnet"] = "Battle.net 密語"
L["say"] = "說"
L["yell"] = "大喊"
L["emote"] = "表情指令"
L["guild"] = "公會對話"
L["officer"] = "幹部對話"
L["monster"] = "小怪"
L["boss"] = "團隊首領"
L["loot"] = "拾取"

L["General"] = "綜合"
L["Trade"] = "交易"
L["LocalDefense"] = "本地防務"
L["LookingForGroup"] = "尋求組隊"
L["GuildRecruitment"] = "公會徵人"

L["Toggle %s Messages"] = "切換 %s 的訊息通知"
L["Toggle %s Sound Alert"] = "切換 %s 的音效通知"
L["Choose specific Alert Location for %s Messages."] = "為 %s 訊息選擇指定的通知位置。"
L["Message"] = "訊息"
L["Channel"] = "頻道"
L["Text"] = "文字"
L["Sound"] = "音效"

L["disabled"] = "停用"
L["enabled"] = "啟用"
L["filtered"] = "過濾"

L["Right-Click"] = "右鍵"
L["Open option menu."] = "開啟選項設定。"
L["Left-Click Tip"] = "左鍵"
L["Toggle selected setting."] = "切換選擇的設定。"

L["default"] = "(預設) 錯誤訊息框架"
L["rw"]      = "團隊警告"
L["sct"]     = "SCT - 捲動戰鬥文字"
L["msbt"]    = "MSBT - 捲動戰鬥文字"
L["parrot"]  = "Parrot - 聊天增強"
L["blizz"]   = "暴雪捲動文字"
L["Globally set Location"] = "整體設定的位置"

L["Toggle text for "] = "切換文字通知於"
L["Toggle sound for "] = "切換音效通知於"

L["Location"] = "位置"
L["Choose specific Alert Location for "] = "選擇指定的位置給"
L["NEED"] = "需求"

L["Broker: Chat Alerts"] = "聊天-通知"
L["Test text."] = "測試 文字，測試文字。"
