if GetLocale() ~= "zhTW" then
	return
end

local MOVANY = {
ADD = "新增",
ADDNEW = "新增",
CLOSEGUIONESC = "按 Esc 鍵關閉主視窗",
CMD_SYNTAX_DELETE = "語法： /movedelete 設定檔名稱",
CMD_SYNTAX_EXPORT = "語法：/moveexport 設定檔名稱",
CMD_SYNTAX_HIDE = "語法：/hide 設定檔名稱",
CMD_SYNTAX_IMPORT = "語法：/moveimport 設定檔名稱",
CMD_SYNTAX_MAFE = "語法：/mafe 框架名稱",
CMD_SYNTAX_UNMOVE = "語法：/unmove 框架名稱",
DELETE = "刪除",
DISABLED_DURING_COMBAT = "戰鬥中停用",
DISERRORMES = "開啟/關閉顯示錯誤訊息。",
DISERRORMESNO = "停用錯誤訊息",
DONSEARCHFRAMENAME = "停用搜尋實際框架名稱。",
DONTSEARCH = "不要搜尋框架名稱",
DONTSYNCINCOMBAT = [=[啟用/停用戰鬥結束後 MoveAnything 同步待處理的框架。

停用這個選項時，戰鬥結束後需要手動同步被保護的框架。]=],
DONTSYNCINCOMBATNO = "戰鬥結束後停用同步",
ELEMENT_NOT_FOUND = "無法找到UI元素",
ELEMENT_NOT_FOUND_NAMED = "無法找到UI元素：%s",
-- Needs review
ERROR_FRAME_FAILED = "同步 %s 時發生錯誤。要再次調整這個框架之前，請重置框架並且 /reload ，便可以解決這個問題。選項設定中可以停用這個訊息，但若持續發生這個問題，請向作者回報下列資訊： %s %s %s",
-- Needs review
ERROR_MODULE_FAILED = "調整 %s - %s 時發生錯誤。選項設定中可以停用這個訊息，但若持續發生這個問題，請向作者回報下列資訊： %s %s %s",
ERROR_NOT_A_TABLE = " \"%s\"  為不支援的類型",
FE_FORCED_LOCK_POSITION_CONFIRM = "是否確定要強制鎖定位置? 請於5秒內再次點擊以確認這項操作。",
FE_FORCED_LOCK_POSITION_TOOLTIP = [=[覆寫這個元素的 SetPoint 定位方法，
使用空的程序來取代。

如果這個元素受到保護，並且在戰鬥中
呼叫程序的話，可能會造成錯誤。

要恢復原本的 SetPoint 定位方法，取消
勾選選項後必須重新載入，或是重新登入。]=],
FE_GROUP_RESET_CONFIRM = "是否要重置群組 %i? 請於5秒內點擊以確認這個動作。",
FE_GROUPS_TOOLTIP = "群組 %i",
FE_UNREGISTER_ALL_EVENTS_CONFIRM = "是否要註銷所有事件? 請於5秒內點擊以確認這個動作。",
FE_UNREGISTER_ALL_EVENTS_TOOLTIP = [=[註銷框架所監聽的任何事件，將框架重新繪製成不做任何反應。

要重新啟用已被註銷的事件，取消勾選選項後必須重新載入
或是重新登入。]=],
FRAME_NO_FRAME_EDITOR = "已停用 %s 的框架編輯器",
FRAME_ONLY_ONCE_OPENED = " %s 顯示後只能與它互動",
FRAME_ONLY_WHEN_BANK_IS_OPEN = "開啟銀行後只能與 %s 互動",
FRAME_ONLY_WHEN_VOIDSTORAGE_IS_OPEN = "%s 打開後才能與它互動",
FRAME_PROTECTED_DURING_COMBAT = "戰鬥中無法與 %s 互動",
FRAME_UNPOSITIONED = "%s 目前還沒有位置，還無法移動它。",
FRAME_VISIBILITY_ONLY = "%s 只能隱藏",
HOOKALLOWED = [=[啟用/停用 MoveAnything 連結 CreateFrame。

需要重新載入才會生效。]=],
HOOKALLOWEDNO = "停用新建視窗相關功能",
LIST_HEADING_CATEGORY_AND_FRAMES = "分類與框架",
LIST_HEADING_HIDE = "隱藏",
LIST_HEADING_MOVER = "移動",
LIST_HEADING_SEARCH_RESULTS = "搜尋結果: %i",
NOMMWP = [=[啟用/停用滑鼠滾輪縮放小地圖。

需要重新載入才會生效。]=],
NOMMWPNO = "停用滑鼠滾輪縮放小地圖功能",
NO_NAMED_FRAMES_FOUND = "無法找到這個名稱的元素",
NUDGER1 = "主視窗顯示移動控制項",
ONLY_ONCE_CREATED = "%s 只有在被建立後才能修改",
OPTBAGS1 = [=[啟用/停用 MoveAnything 連結背包分類。

使用其他插件移動背包時請勾選。]=],
OPTBAGSTOOLTIP = "停用背包分類相關功能",
OPTIONTOOLTIP1 = [=[啟用時，主視窗會顯示移動控制項。

預設只有在與框架互動時才會顯示移動控制項。]=],
OPTIONTOOLTIP2 = [=[啟用/停用顯示滑鼠提示。

滑鼠指向元素時按住 Shift 鍵，會反轉顯示滑鼠提示的行為。]=],
PLAYSOUND = "播放音效",
PLAYSOUNDS = "開啟和關閉主視窗時 MoveAnything 是否要播放音效。",
PROFILE_ADD_TEXT = "輸入新的設定檔名稱",
PROFILE_ALREADY_EXISTS = "設定檔 \"%s\" 已經存在",
PROFILE_CANT_DELETE_CURRENT_IN_COMBAT = "戰鬥中無法刪除目前的設定檔",
PROFILE_CANT_DELETE_DEFAULT = "無法刪除預設的設定檔",
PROFILE_CURRENT = "目前",
PROFILE_DELETED = "已刪除設定檔: %s",
PROFILE_DELETE_TEXT = "是否要刪除設定檔: %s ?",
PROFILE_EXPORTED = "\"%s\" 匯出至 \"%s\"",
PROFILE_IMPORTED = "\"%s\" 已經匯入到 \"%s\"",
PROFILE_RENAME_TEXT = "替 \"%s\" 輸入新名稱",
PROFILE_RESET_CONFIRM = "是否要重置目前設定檔中的所有框架?",
PROFILES = "設定檔",
PROFILE_SAVE_AS_TEXT = "輸入新設定檔名稱",
PROFILES_CANT_SWITCH_DURING_COMBAT = "戰鬥中無法切換設定檔",
PROFILE_UNKNOWN = "未知的設定檔: %s",
RENAME = "重新命名",
RESETALL1 = "重置 MoveAnything 恢復成預設設定，刪除所有框架的設定和自訂框架清單。",
RESET_ALL_CONFIRM = "是否要重置所有版面配置，恢復成最初安裝的狀態?",
RESET_FRAME_CONFIRM = "是否要重置 %s? 請於5秒內再按一次以確認這個動作。",
RESETPROFILE1 = "重置設定檔",
RESETTING_FRAME = "正在重置 %s",
SAVE = "儲存",
SAVEAS = "另存為",
SEARCH_TEXT = "搜尋",
SHOWTOOLTIPS = "顯示滑鼠提示",
SQUARMAP = [=[啟用/停用方形小地圖。

在 "小地圖" 分類中隱藏 "圓形邊框"，去除作為遮罩的外框。]=],
SQUARMAPNO = "使用方形小地圖",
UNSERIALIZE_FRAME_INVALID_FORMAT = "無效的格式",
UNSERIALIZE_FRAME_NAME_DIFFERS = "匯入的框架名稱和匯入目標不相同",
UNSERIALIZE_PROFILE_COMPLETED = "已經將 %i 個元素匯入到設定檔 \"%s\"",
UNSERIALIZE_PROFILE_NO_NAME = "無法取得設定檔名稱",
UNSUPPORTED_FRAME = "不支援的框架: %s",
UNSUPPORTED_TYPE = "不支援的類型: %s"
}

_G.MOVANY = MOVANY