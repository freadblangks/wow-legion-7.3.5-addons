local AddOnName, Engine = ...;
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local L = AceLocale:NewLocale(AddOnName, "zhTW", false, false);
if not L then return end

L['Modules'] = "功能模組";
L['Left-Click'] = "左鍵";
L['Right-Click'] = "右鍵";
L['k'] = "千"; -- short for 1000
L['M'] = "百萬"; -- short for 1000000
L['B'] = "十億"; -- short for 1000000000
L['L'] = "本地"; -- For the local ping
L['W'] = "世界"; -- For the world ping
L['w'] = "萬";
L['e'] = "億";
L['c'] = "兆";


-- General
L["Positioning"] = "位置";
L['Bar Position'] = "資訊列位置";
L['Top'] = "上";
L['Bottom'] = "下";
L['Bar Color'] = "資訊列顏色";
L['Use Class Color for Bar'] = "使用職業顏色";
L["Miscellaneous"] = "其他";
L['Hide Bar in combat'] = "戰鬥中隱藏";
L['Bar Padding'] = "資訊列內距 (縮放大小)";
L['Module Spacing'] = "模組間距";
L['Hide order hall bar'] = "隱藏職業大廳列";

-- Positioning Options
L['Positioning Options'] = "位置選項";
L['Horizontal Position'] = "水平位置";
L['Bar Width'] = "資訊列寬度";
L['Left'] = "左";
L['Center'] = "中";
L['Right'] = "右";

-- Media
L['Font'] = "字體";
L['Small Font Size'] = "小字體大小";
L['Text Style'] = "文字樣式";

-- Text Colors
L["Colors"] = "顏色";
L['Text Colors'] = "文字顏色";
L['Normal'] = "平時";
L['Inactive'] = "未使用時";
L["Use Class Color for Text"] = "使用職業顏色";
L["Only the alpha can be set with the color picker"] = "顏色選擇器中只能設定透明度";
L['Use Class Colors for Hover'] = "使用職業顏色";
L['Hover'] = "滑鼠指向時";

-------------------- MODULES ---------------------------

L['Social'] = "好友";
L['Micromenu'] = "微型選單";
L['Show Social Tooltips'] = "顯示公會/好友名單";
L['Main Menu Icon Right Spacing'] = "主選單圖示右方間距";
L['Icon Spacing'] = "圖示間距";
L['Open Guild Page'] = "開啟公會視窗";
L['No Tag'] = "沒有 Tag";
L['Whisper BNet'] = "密語 Battle Tag";
L['Whisper Character'] = "密語角色";
L['Hide Social Text'] = "隱藏人數";
L["GMOTD in Tooltip"] = "顯示公會今日資訊";
L["Modifier for friend invite"] = "組隊邀請的組合鍵";
L['Show/Hide Buttons'] = "顯示/隱藏按鈕";
L['Show Menu Button'] = "顯示選單按鈕";
L['Show Chat Button'] = "顯示聊天按鈕";
L['Show Guild Button'] = "顯示公會按鈕";
L['Show Social Button'] = "顯示好友按鈕";
L['Show Character Button'] = "顯示角色按鈕";
L['Show Spellbook Button'] = "顯示法術書按鈕";
L['Show Talents Button'] = "顯示天賦按鈕";
L['Show Achievements Button'] = "顯示成就按鈕";
L['Show Quests Button'] = "顯示任務按鈕";
L['Show LFG Button'] = "顯示隊伍搜尋器按鈕";
L['Show Journal Button'] = "顯示冒險指南按鈕";
L['Show PVP Button'] = "顯示 PVP 按鈕";
L['Show Pets Button'] = "顯示收藏按鈕";
L['Show Shop Button'] = "顯示遊戲商城按鈕";
L['Show Help Button'] = "顯示客服支援按鈕";

L['Always Show Item Level'] = "總是顯示物品等級";
L['Minimum Durability to Become Active'] = "耐久度低於多少時顯示";
L['Maximum Durability to Show Item Level'] = "耐久度高於多少時顯示成物品等級";

L['Master Volume'] = "主音量";
L["Volume step"] = "每點一下調整的值";

L['Time Format'] = "時間格式";
L['Use Server Time'] = "使用伺服器時間";
L['New Event!'] = "新活動!";
L['Local Time'] = "本地時間";
L['Realm Time'] = "伺服器時間";
L['Open Calendar'] = "開啟行事曆";
L['Open Clock'] = "開啟時鐘";
L['Hide Event Text'] = "隱藏活動文字";

L['Travel'] = "旅行";
L['Port Options'] = "傳送選項";
L['Ready'] = "完成";
L['Travel Cooldowns'] = "旅行冷卻時間";
L['Change Port Option'] = "變更傳送選項";

L['Always Show Silver and Copper'] = "總是顯示銀和銅";
L['Shorten Gold'] = "金額縮寫";
L['Toggle Bags'] = "打開/關閉背包";
L['Session Total'] = "本次登入總計";

L['Show XP Bar Below Max Level'] = "未滿等時顯示經驗條";
L['Use Class Colors for XP Bar'] = "使用職業顏色";
L['Show Tooltips'] = "顯示滑鼠提示";
L['Text on Right'] = "文字在右側";
L['Currency Select'] = "要顯示的兌換通貨";
L['First Currency'] = "第一種兌換通貨";
L['Second Currency'] = "第二種兌換通貨";
L['Third Currency'] = "第三種兌換通貨";
L['Rested'] = "休息加成";

L['Show World Ping'] = "顯示世界延遲";
L['Number of Addons To Show'] = "顯示的插件數目";
L['Addons to Show in Tooltip'] = "顯示插件數目";
L['Show All Addons in Tooltip with Shift'] = "按住 Shift 顯示全部";
L['Memory Usage'] = "記憶體使用量";
L['Garbage Collect'] = "清理記憶體";
L['Cleaned'] = "已清理";

L['Use Class Colors'] = "使用職業顏色";
L['Cooldowns'] = "冷卻時間";

L['Set Specialization'] = "切換專精";
L['Set Loot Specialization'] = "切換優先拾取的專精";
L['Current Specialization'] = "目前職業專精";
L['Current Loot Specialization'] = "目前優先拾取的專精";
L['Talent Minimum Width'] = "天賦最小寬度";
L['Open Artifact'] = "檢視神兵武器";
L['Remaining'] = "還需要";
L['Available Ranks'] = "神兵武器等級";
L['Artifact Knowledge'] = "神兵知識等級";

L['XIV Bar'] = "資訊列";
L['Profiles'] = "設定檔";
L['Money'] = "金錢"
L['Enable in combat'] = "戰鬥中可使用"
L["Gold rounded values"] = "只顯示金的部分"
L['Daily Total'] = "本日總計"
L["Registered characters"] = "記錄的角色"
L["All the characters listed above are currently registered in the gold database. To delete one or several character, plase uncheck the box correponding to the character(s) to delete.\nThe boxes will remain unchecked for the deleted character(s), untill you reload or logout/login"] = "上方列出金錢資料庫中有記錄的所有角色。要刪除角色的記錄，請取消勾選角色前方的核取方塊。\n取消勾選的角色會保持存在，直到重新載入介面或重新登入遊戲。"
L["Overwatch"] = "鬥陣特攻"
L["Heroes of the Storm"] = "暴雪英霸"
L["Hearthstone"] = "爐石戰記"
L["Starcraft 2"] = "星海爭霸 II"
L["Diablo 3"] = "暗黑破壞神 III"
L['Starcraft Remastered'] = "星海爭霸 高畫質重製版"
L['Destiny 2'] = "天命 2"
L["Hide when in flight"] = "使用鳥點飛行時隱藏"

