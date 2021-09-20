local L = LibStub("AceLocale-3.0"):NewLocale("Raid Check", "zhTW")

if L then

--TW Translation
L["missingbuffs"]	= "有人缺少增益效果：";
L["noissues"]		= "團隊檢查通過，超棒der~ No.1";
L["warningfood"]	= "缺少食物";
L["warningflask"]	= "缺少精煉";
L["warningrune"]	= "缺少符文";
L["warningvantus"]	= "缺少梵陀";
L["allchecksdisabled"]	= "已停用通報精煉、食物或符文增益效果。";

--Extensions
L["expires"]		= "(快過期)";

--Whispers
L["useFlask"]		= "請喝精煉，最低要求為 ";
L["expFlask"]		= "你的精煉快過期了! 請補一下。";
L["useFood"]		= "請吃食物，最低要求為 ";
L["expFood"]		= "你的食物快過期了! 請補一下。";
L["useRune"]		= "請使用符文，最低要求為 ";
L["expRune"]		= "你的符文快過期了! 請補一下。";
L["useVantus"]		= "請對這個首領使用梵陀符文：";

--GUI
L["yes"]			= "是";
L["no"]				= "否";
L["exp"]			= "過期";
L["hide"]			= "隱藏";
L["show"]			= "顯示";
L["hideText"]		= "隱藏插件介面。";
L["settingsText"]	= "開啟插件的設定選項介面。";
L["showText"]		= "顯示插件介面。";
L["none"]			= "無";

--Buttons
L["main"]			= "主要";
L["settings"]		= "設定";
L["announcetxt"]	= "將缺少增益效果的玩家通報到團隊、隊伍或說話頻道";
L["announce"]		= "通報";
L["whispertxt"]		= "私下密語缺少增益效果的玩家";
L["whisper"]		= "密語";
L["refreshtxt"]		= "重新載入增益效果資料";
L["refresh"]		= "更新";

--Headline
L["player"]			= "玩家";
L["flask"]			= "精煉";
L["food"]			= "食物";
L["rune"]			= "符文";
L["vantusrune"]		= "梵陀符文";

--Minimap
L["MinimapTooltip1"]	= "左鍵 檢查食物精煉";
L["MinimapTooltip2"]	= "右鍵 開啟設定選項";
L["MinimapTooltip3"]	= "Ctrl+左鍵 通報到頻道"
L["showMinimap"]	= "顯示小地圖按鈕";

--Settings
L["Data"]			= "資料";
L["Misc"]			= "其他";
L["Beha"]			= "行為";
L["UI"]				= "介面";

L["enRune"]			= "啟用檢查符文";
L["allowFelFocuser"]	= "魔能聚焦器也算精煉";
L["colorClass"]		= "名字顯示職業顏色";

L["annFlask"]		= "通報/密語精煉";
L["annFood"]		= "通報/密語食物";
L["annRunes"]		= "通報/密語符文 (必須啟用檢查符文)";
L["whispVantus"]	= "密語對指定的首領使用梵陀符文。";
L["ctrlWhi"]		= "Ctrl+左鍵點擊 密語單一玩家";
L["annBossStart"]	= "遇到團隊首領時通報";

L["hideCombat"]		= "戰鬥開始時隱藏視窗";
L["rdyCheck"]		= "準備確認時顯示並更新";
L["rdyAnn"]			= "準備確認時通報";
L["rdyWhi"]			= "準備確認時密語";
L["ign78"]			= "忽略小隊 7 和 8";
L["showRealms"]		= "顯示伺服器名稱";
L["LeaderAssistOnly"]	= "只有隊長和助理才通報";

L["windowSizeSlider"]	= "視窗高度:";
L["resetDefault"]	= "重置設定";

L["RaidCheck"] = "團隊檢查";
L["Raid Check"] = "檢查食物精煉";
L["  [Version: "] = "  [版本: ";

end
