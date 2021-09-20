
local L, locale = OVERACHIEVER_STRINGS, GetLocale()

L.SEARCH_TAB = "Search";
L.SEARCH_HELP = "Use this tab to search for achievements. You can also search for achievements by name or ID using slash commands. See Overachiever's readme.txt file for details.";
L.SEARCH_NAME = "Name or ID:";
L.SEARCH_DESC = "Description:";
L.SEARCH_CRITERIA = "Criteria:";
L.SEARCH_REWARD = "Reward:";
L.SEARCH_ANY = "Any of the above:";
L.SEARCH_FULLLIST = "Include unlisted|nachievements";
L.SEARCH_FULLLIST_TIP = "Include in the search achievements that aren't normally listed in the default UI, such as those exclusive to the opposing faction, unacquired Feats of Strength, etc.";
L.SEARCH_TYPE = "Type:";
L.SEARCH_TYPE_INDIV = "Personal";
L.SEARCH_TYPE_GUILD = "Guild";
L.SEARCH_TYPE_ALL = "All";
L.SEARCH_SUBMIT = "Search";
L.SEARCH_RESET = "Reset";
L.SEARCH_RESULTS = "Found %s |4achievement:achievements;.";

L.SUGGESTIONS_TAB = "Suggestions";
L.SUGGESTIONS_HELP = "Suggested achievements are listed here based on your current location. Also listed are all \"Recent Reminder\" achievements.|n|n|cffffffffShift-right-click|r on a suggested achievement to hide it. (This is character-specific and affects all locations.)";
L.SUGGESTIONS_REFRESH = "Refresh";
L.SUGGESTIONS_EMPTY = "Overachiever has no suggestions for you at this time.";
L.SUGGESTIONS_RESULTS = "%d |4suggestion:suggestions; found.";
L.SUGGESTIONS_RESULTS_HIDDEN = "%d |4suggestion:suggestions; found.|n(%d |4is:are; hidden.)";
L.SUGGESTIONS_RESULTS_TRADESKILL = "%s: %d |4suggestion:suggestions; found.";
L.SUGGESTIONS_RESULTS_TRADESKILL_HIDDEN = "%s: %d |4suggestion:suggestions; found.|n(%d |4is:are; hidden.)";
L.SUGGESTIONS_EMPTY_TRADESKILL = "%s: Overachiever has no suggestions for you at this time.";
L.SUGGESTIONS_LOCATION = "Location:"
L.SUGGESTIONS_LOCATION_TIP = "Override Zone/Instance Location"
L.SUGGESTIONS_LOCATION_TIP2 = "Leave blank to get suggestions for your current location or start typing to get a matching valid zone or instance name to use instead. Press |cffffffffTab|r to cycle between locations that match the text to the left of the cursor. |cffffffffShift+Tab|r cycles in reverse order. If the cursor is at the leftmost position, it cycles between all valid locations.|n|nYou can also enter the name of certain holidays/world events (such as \"Hallow's End\")."
L.SUGGESTIONS_LOCATION_SUBZONE = "Subzone:"
L.SUGGESTIONS_LOCATION_NOSUBZONE = "(unspecified)"
L.SUGGESTIONS_DIFFICULTY = "Instance Difficulty:"
L.SUGGESTIONS_DIFFICULTY_AUTO = "Auto-Detect"
L.SUGGESTIONS_DIFFICULTY_NORMAL = "Normal"
L.SUGGESTIONS_DIFFICULTY_HEROIC = "Heroic"
L.SUGGESTIONS_DIFFICULTY_MYTHIC = "Mythic"
L.SUGGESTIONS_RAIDSIZE = "Raid Size:"
L.SUGGESTIONS_RAIDSIZE_AUTO = "Auto-Detect"
L.SUGGESTIONS_RAIDSIZE_10 = "10-man"
L.SUGGESTIONS_RAIDSIZE_25 = "25-man"
L.SUGGESTIONS_SHOWHIDDEN = "Show Hidden"
L.SUGGESTIONS_SHOWHIDDEN_TIP = "Check to show hidden suggestions for this location."
L.SUGGESTIONS_SHOWHIDDEN_TIP2 = "If you want to see all hidden suggestions regardless of location, enter \"hidden\" into the Location field, above.|n|n|cffffffffShift-right-click|r on an achievement to toggle whether it is hidden."
L.SUGGESTIONS_HIDDENLOCATION = "hidden"

L.SUGGESTIONS_ZONERENAME_DALARAN_NORTHREND = "Dalaran (Northrend)"
L.SUGGESTIONS_ZONERENAME_DALARAN_BROKENISLES = "Dalaran (Broken Isles)"
L.SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_OUTLAND = "Shadowmoon Valley (Outland)"
L.SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_DRAENOR = "Shadowmoon Valley (Draenor)"
L.SUGGESTIONS_ZONERENAME_NAGRAND_OUTLAND = "Nagrand (Outland)"
L.SUGGESTIONS_ZONERENAME_NAGRAND_DRAENOR = "Nagrand (Draenor)"
L.SUGGESTIONS_ZONERENAME_KARAZHAN_LEGION = "Return to Karazhan"

L.WATCH_TAB = "Watch";
L.WATCH_HELP = "Create your watch list by |cffffffffalt+clicking|r on achievements in the other tabs or achievement chat links. |cffffffffAlt+click|r on one displayed here to stop watching it.";
L.WATCH_EMPTY = "Your watch list is empty. Alt+click on an achievement in another tab or an achievement's chat link to watch it.";
L.WATCH_EMPTY_SHORT = "Empty List";
L.WATCH_DISPLAYEDLIST = "Displayed List:";
L.WATCH_DEFAULTLIST = "Default List:";
L.WATCH_DEFAULTLIST_TIP = "The specified list will be the Displayed List at the beginning of each session.";
L.WATCH_COPY = "Copy to List:";
L.WATCH_COPY_TIP = "When enabled, if you |cffffffffshift+alt+click|r on an achievement on this tab, it will be added to the specified watch list.";
L.WATCH_LIST_GLOBAL = "Global";
L.WATCH_LIST_PERCHAR = "Character-specific";
L.WATCH_NEW = "New";
L.WATCH_DELETE = "Delete";
L.WATCH_CLEAR = "Clear";
L.WATCH_COPY = "Copy To:";
L.WATCH_POPUP_NEWLIST = "Enter the name of your new achievement watch list:";
L.WATCH_POPUP_DELETELIST = "Are you sure you want to permanently delete the current achievement watch list?";
L.WATCH_POPUP_CLEARLIST = "Are you sure you want to clear the contents of the current achievement watch list?";
L.WATCH_ERR_INVALIDID = 'Removed "%s" from Watch List: An achievement with that ID could not be found.';

L.RELATED_TAB = "Related";
L.RELATED_HELP = "This tab shows achievements that are related to one another. One achievement was chosen as the base. The rest are in the same series as the base, are one of the criteria of the base or of another in its series, or have as one of their own criteria either the base or an achievement in its series.";
L.RELATED_RESULTS = "Found %s |4achievement:achievements;.";
L.RELATED_BASE = "Base Achievement:";
L.RELATED_CLOSE = "Close";
L.RELATED_RECURSIVE = "Extended";
L.RELATED_RECURSIVE_TIP = "Do a recursive search so all achievements that are indirectly related to the base achievement are also included.";

L.TAB_SORT = "Sort by:";
L.TAB_SORT_NAME = "Name";
L.TAB_SORT_ID = "ID";
L.TAB_SORT_POINTS = "Point value";
L.TAB_SORT_COMPLETE = "Date completed";
L.TAB_SORT_RELATION = "Relation";
L.TAB_HELP = "|cffffffffCtrl-click|r on an achievement to jump to its place in the standard UI.|n|n|cffffffffCtrl-shift-click|r on an achievement to view related achievements.|n|nA |cffffffffblue background|r means it is part of a series for which you haven't completed an earlier step.|n|nA |cffffffffred background|r means it cannot be found in the standard UI for this character. It may be exclusive to the opposing faction or is an unacquired Feat of Strength.|n|nA |cffffffffgreen background|r means the achievement is on the \"Recent Reminder\" list. It became especially relevant within the last 2 minutes (e.g. because its timer started or an objective was seen in a tooltip).";

L.EVENTNOTICE_ONGOING = "This event is ongoing.";
L.EVENTNOTICE_STARTED_TODAY = "This event started earlier today.";
L.EVENTNOTICE_STARTS_HOURS = "This event starts in|cff7eff00 %s |4hour:hours;|r.";
L.EVENTNOTICE_STARTS_MINUTES = "This event starts in|cff7eff00 %s |4minute:minutes;|r.";
L.EVENTNOTICE_ENDED_TODAY = "|cffff2020This event ended|r earlier today."
L.EVENTNOTICE_ENDS_DAYS = "It ends in|cffff2020 %s |4day:days;|r.";
L.EVENTNOTICE_ENDS_HOURS = "It ends in|cffff2020 %s |4hour:hours;|r.";
L.EVENTNOTICE_ENDS_MINUTES = "It ends in|cffff2020 %s |4minute:minutes;|r.";
L.EVENTNOTICE_ENDS_DATETIME = "It ends on %2$d/%1$02d at %3$s (server time).";  -- 1 - day 2 - month 3 - time
L.EVENTNOTICE_ENDS_TIME = "It ends today at %3$s (server time).";
L.EVENTNOTICE_TIP = "Hold |cffffffffShift|r for more details.";
L.EVENTNOTICE_HELP = "|cffffffffClick|r to see related achievements.|n|cffffffffCtrl-click|r to open the calendar.|n|cffffffffShift-right-click|r to temporarily hide this notice."; --|n|cffffffffRight-click|r for more options.";


--if (locale == "enGB") then  -- English (EU)
-- Unfortunately, GetLocale() returns "enUS" even when "enGB" would be more appropriate, and the SHORTDATE
-- global string is defined incorrectly for enGB clients (it's set as it is for enUS), so we have to do things
-- this way:
if (ACHIEVEMENT_TOOLTIP_COMPLETE == "Achievement earned by %1$s on %3$d/%2$d/20%4$02d") then
	L.EVENTNOTICE_ENDS_DATETIME = "It ends on %1$d/%2$02d at %3$s (server time).";  -- 1 - day 2 - month 3 - time
end

if (locale == "zhTW") then  -- Traditional Chinese
-- Tabs
--Translation missing 
-- L["EVENTNOTICE_ENDED_TODAY"] = ""
--Translation missing 
-- L["EVENTNOTICE_ENDS_DATETIME"] = ""
--Translation missing 
-- L["EVENTNOTICE_ENDS_DAYS"] = ""
--Translation missing 
-- L["EVENTNOTICE_ENDS_HOURS"] = ""
--Translation missing 
-- L["EVENTNOTICE_ENDS_MINUTES"] = ""
--Translation missing 
-- L["EVENTNOTICE_ENDS_TIME"] = ""
--Translation missing 
-- L["EVENTNOTICE_HELP"] = ""
--Translation missing 
-- L["EVENTNOTICE_ONGOING"] = ""
--Translation missing 
-- L["EVENTNOTICE_STARTED_TODAY"] = ""
--Translation missing 
-- L["EVENTNOTICE_STARTS_HOURS"] = ""
--Translation missing 
-- L["EVENTNOTICE_STARTS_MINUTES"] = ""
--Translation missing 
-- L["EVENTNOTICE_TIP"] = ""
--Translation missing 
-- L["RELATED_BASE"] = ""
--Translation missing 
-- L["RELATED_CLOSE"] = ""
--Translation missing 
-- L["RELATED_HELP"] = ""
--Translation missing 
-- L["RELATED_RECURSIVE"] = ""
--Translation missing 
-- L["RELATED_RECURSIVE_TIP"] = ""
--Translation missing 
-- L["RELATED_RESULTS"] = ""
--Translation missing 
-- L["RELATED_TAB"] = ""
L["SEARCH_ANY"] = "以上皆可："
L["SEARCH_CRITERIA"] = "條件："
L["SEARCH_DESC"] = "描述："
L["SEARCH_FULLLIST"] = "搜索所有成就"
L["SEARCH_FULLLIST_TIP"] = "包括所有成就、已完成的、未完成的、無法完成的，等等。"
L["SEARCH_HELP"] = "使用此標籤來搜索成就。您也可以使用命令搜索成就的名稱或編號。見 Overachiever 的 Readme.txt 文件的相關內容。"
L["SEARCH_NAME"] = "名稱："
L["SEARCH_RESET"] = "重置"
L["SEARCH_RESULTS"] = "搜索到 %s 個成就。"
L["SEARCH_REWARD"] = "獎勵："
L["SEARCH_SUBMIT"] = "搜索"
L["SEARCH_TAB"] = "搜索"
L["SEARCH_TYPE"] = "類型:"
L["SEARCH_TYPE_ALL"] = "全部"
L["SEARCH_TYPE_GUILD"] = "公會"
L["SEARCH_TYPE_INDIV"] = "個人"
L["SUGGESTIONS_DIFFICULTY"] = "副本難度:"
L["SUGGESTIONS_DIFFICULTY_AUTO"] = "自動偵測"
L["SUGGESTIONS_DIFFICULTY_HEROIC"] = "英雄"
L["SUGGESTIONS_DIFFICULTY_MYTHIC"] = "傳奇"
L["SUGGESTIONS_DIFFICULTY_NORMAL"] = "普通"
L["SUGGESTIONS_EMPTY"] = "Overachiever現在沒有任何建議。"
L["SUGGESTIONS_EMPTY_TRADESKILL"] = "%s: Overachiever 此時無法提供建議."
L["SUGGESTIONS_HELP"] = "根據你目前的位置建議追蹤成就。"
L["SUGGESTIONS_HIDDENLOCATION"] = "隱藏"
L["SUGGESTIONS_LOCATION"] = "區域："
L["SUGGESTIONS_LOCATION_NOSUBZONE"] = "(未指定)"
L["SUGGESTIONS_LOCATION_SUBZONE"] = "子區域："
L["SUGGESTIONS_LOCATION_TIP"] = "無視區域/副本位置"
L["SUGGESTIONS_LOCATION_TIP2"] = "在欄位中輸入一個完整的有效區域或副本名稱，以取得提示。若欄位保持空白，則會根據你目前的所在位置。當游標在欄位中時，按下|cffffffffTab|r鍵可根據已輸入的內容依序產生有效的完整位置名稱。按下|cffffffffShift+Tab|r則產生前一個名稱。如果游標在欄位的最左側，它將依序產生所有有效位置名稱。"
L["SUGGESTIONS_RAIDSIZE"] = "團隊大小:"
L["SUGGESTIONS_RAIDSIZE_10"] = "10-人"
L["SUGGESTIONS_RAIDSIZE_25"] = "25-人"
L["SUGGESTIONS_RAIDSIZE_AUTO"] = "自動偵測"
L["SUGGESTIONS_REFRESH"] = "刷新"
L["SUGGESTIONS_RESULTS"] = "找到 %d 個建議。"
L["SUGGESTIONS_RESULTS_HIDDEN"] = "找到 %d 個建議。|n(%d 個已隱藏。)"
L["SUGGESTIONS_RESULTS_TRADESKILL"] = "%s: 找到 %d 個建議."
L["SUGGESTIONS_RESULTS_TRADESKILL_HIDDEN"] = "%s: 找到 %d 個建議。|n(%d 個已隱藏。)"
L["SUGGESTIONS_SHOWHIDDEN"] = "顯示隱藏建議"
L["SUGGESTIONS_SHOWHIDDEN_TIP"] = "顯示這個位置的隱藏建議。"
L["SUGGESTIONS_SHOWHIDDEN_TIP2"] = "如果你想要看到所有隱藏建議，不分地區，在上方的地區欄位中輸入 \\\"隱藏\\\"。|n|n|cffffffffShift-右鍵|r點擊成就切換顯示/隱藏。"
L["SUGGESTIONS_TAB"] = "建議"
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_DALARAN_BROKENISLES"] = ""
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_DALARAN_NORTHREND"] = ""
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_KARAZHAN_LEGION"] = ""
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_NAGRAND_DRAENOR"] = ""
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_NAGRAND_OUTLAND"] = ""
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_DRAENOR"] = ""
--Translation missing 
-- L["SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_OUTLAND"] = ""
L["TAB_HELP"] = "|cffffffffCtrl + 點選|r 所選成就會跳轉到該成就的頁面.|n|n |cffffffff藍色背景|r表示此成就是你還沒有完成前續內容的系列成就部分.|n|n |cffffffff紅色背景|r表示此成就無法在你當前人物的標準成就界面中找到,因為這是陣營專屬成就,或者是你尚未取得的『光輝事跡』成就."
L["TAB_SORT"] = "類型:"
L["TAB_SORT_COMPLETE"] = "完成時間"
L["TAB_SORT_ID"] = "成就ID"
L["TAB_SORT_NAME"] = "名稱"
L["TAB_SORT_POINTS"] = "成就點數"
--Translation missing 
-- L["TAB_SORT_RELATION"] = ""
L["WATCH_CLEAR"] = "清除"
L["WATCH_COPY"] = "複製到:"
L["WATCH_COPY_TIP"] = "當啟用時，假如你 |cffffffffshift+alt+點擊|r 在一個標籤上的成就，將會新增至指定的觀察列表中。"
L["WATCH_DEFAULTLIST"] = "預設列表:"
L["WATCH_DEFAULTLIST_TIP"] = "指定列表會顯示列表在任何場景的開始時候。"
L["WATCH_DELETE"] = "刪除"
L["WATCH_DISPLAYEDLIST"] = "顯示列表:"
L["WATCH_EMPTY"] = "你的觀察列表是空的。Alt+點擊在其它成就標籤上或是成就連結來觀察。"
L["WATCH_EMPTY_SHORT"] = "空的列表"
L["WATCH_ERR_INVALIDID"] = "已從觀察列表移除\"%s\": 此成就ID並未被發現。"
L["WATCH_HELP"] = "在其它成就標籤上或是成就連結使用 |cffffffffalt+點擊|r新建你的觀察列表。 |cffffffffAlt+點擊|r 停止觀察。"
L["WATCH_LIST_GLOBAL"] = "全部"
L["WATCH_LIST_PERCHAR"] = "字符特殊"
L["WATCH_NEW"] = "新的"
L["WATCH_POPUP_CLEARLIST"] = "要將這個成就觀察列表的內容清除?"
L["WATCH_POPUP_DELETELIST"] = "要將這個成就觀察列表刪除?"
L["WATCH_POPUP_NEWLIST"] = "輸入新建成就列表的名稱:"
L["WATCH_TAB"] = "觀察"


elseif (locale == "zhCN") then  -- Simplified Chinese
-- Tabs
L["EVENTNOTICE_ENDED_TODAY"] = "在更早些时刻|cffff2020这个事件已开始|r。"
L["EVENTNOTICE_ENDS_DATETIME"] = "将在 %2$d/%1$02d 的 %3$s 结束(服务器时间)."
L["EVENTNOTICE_ENDS_DAYS"] = "距结束还有|cffff2020 %s |4day:天;|r。"
L["EVENTNOTICE_ENDS_HOURS"] = "距结束还有|cffff2020 %s |4hour:小时;|r。"
L["EVENTNOTICE_ENDS_MINUTES"] = "距结束还有|cffff2020 %s |4minute:分钟;|r。"
L["EVENTNOTICE_ENDS_TIME"] = "将在今天的 %3$s 结束(服务器时间)."
L["EVENTNOTICE_HELP"] = "|cffffffff点击|r查看相关成就。|n|cffffffffCtrl-点击|r打开日历。|n|cffffffffShift-右-点击|r暂时隐藏本提示。"
L["EVENTNOTICE_ONGOING"] = "这个事件正在进行中。"
L["EVENTNOTICE_STARTED_TODAY"] = "这个事件开始于更早的时刻。"
L["EVENTNOTICE_STARTS_HOURS"] = "距事件开始还有|cff7eff00 %s |4hour:小时;|r。"
L["EVENTNOTICE_STARTS_MINUTES"] = "距事件开始还有|cff7eff00 %s |4minute:分钟;|r。"
L["EVENTNOTICE_TIP"] = "按住|cffffffffShift|r显示更多细节。"
L["RELATED_BASE"] = "成就成果:"
L["RELATED_CLOSE"] = "关闭"
--Translation missing 
-- L["RELATED_HELP"] = ""
L["RELATED_RECURSIVE"] = "额外"
--Translation missing 
-- L["RELATED_RECURSIVE_TIP"] = ""
L["RELATED_RESULTS"] = "找到 %s |4achievement:成就;。"
L["RELATED_TAB"] = "相关的"
L["SEARCH_ANY"] = "以上所有："
L["SEARCH_CRITERIA"] = "条件："
L["SEARCH_DESC"] = "描述："
L["SEARCH_FULLLIST"] = "包含隐藏成就"
L["SEARCH_FULLLIST_TIP"] = "包括没有在默认列表中显示的成就，例如阵营专属成就、‘光辉事迹’成就等。"
L["SEARCH_HELP"] = "使用这个标签来搜索成就。你也可以通过斜杠命令用名字或ID来搜索成就。详细请参见Overachiever的readme.txt文件。"
L["SEARCH_NAME"] = "名称或者ID："
L["SEARCH_RESET"] = "重置"
L["SEARCH_RESULTS"] = "找到 %s 个成就。"
L["SEARCH_REWARD"] = "奖励："
L["SEARCH_SUBMIT"] = "搜索"
L["SEARCH_TAB"] = "搜索"
L["SEARCH_TYPE"] = "类型："
L["SEARCH_TYPE_ALL"] = "全部"
L["SEARCH_TYPE_GUILD"] = "公会"
L["SEARCH_TYPE_INDIV"] = "个人"
L["SUGGESTIONS_DIFFICULTY"] = "地下城难度："
L["SUGGESTIONS_DIFFICULTY_AUTO"] = "自动检测"
L["SUGGESTIONS_DIFFICULTY_HEROIC"] = "英雄"
L["SUGGESTIONS_DIFFICULTY_MYTHIC"] = "史诗"
L["SUGGESTIONS_DIFFICULTY_NORMAL"] = "普通"
L["SUGGESTIONS_EMPTY"] = "Overachiever当前没有建议。"
L["SUGGESTIONS_EMPTY_TRADESKILL"] = "%s：Overachiever当前没有建议。"
L["SUGGESTIONS_HELP"] = "根据你的当前区域建议追踪成就。"
L["SUGGESTIONS_HIDDENLOCATION"] = "隐藏"
L["SUGGESTIONS_LOCATION"] = "区域："
L["SUGGESTIONS_LOCATION_NOSUBZONE"] = "（未指定）"
L["SUGGESTIONS_LOCATION_SUBZONE"] = "子区域："
L["SUGGESTIONS_LOCATION_TIP"] = "无视区域/副本位置"
L["SUGGESTIONS_LOCATION_TIP2"] = "在字段中输入一个完整的有效区域或副本名称，以取得提示。若字段保持空白，则会根据你目前的所在位置。当光标在字段中时，按下|cffffffffTab|r键可根据已输入的内容依序产生有效的完整位置名称。按下|cffffffffShift+Tab|r则产生前一个名称。如果光标在字段的最左侧，它将依序产生所有有效位置名称。"
L["SUGGESTIONS_RAIDSIZE"] = "团队模式："
L["SUGGESTIONS_RAIDSIZE_10"] = "10人"
L["SUGGESTIONS_RAIDSIZE_25"] = "25人"
L["SUGGESTIONS_RAIDSIZE_AUTO"] = "自动检测"
L["SUGGESTIONS_REFRESH"] = "刷新"
L["SUGGESTIONS_RESULTS"] = "找到 %d 个建议。"
--Translation missing 
-- L["SUGGESTIONS_RESULTS_HIDDEN"] = ""
L["SUGGESTIONS_RESULTS_TRADESKILL"] = "%s：找到 %d 个建议。"
--Translation missing 
-- L["SUGGESTIONS_RESULTS_TRADESKILL_HIDDEN"] = ""
--Translation missing 
-- L["SUGGESTIONS_SHOWHIDDEN"] = ""
--Translation missing 
-- L["SUGGESTIONS_SHOWHIDDEN_TIP"] = ""
--Translation missing 
-- L["SUGGESTIONS_SHOWHIDDEN_TIP2"] = ""
L["SUGGESTIONS_TAB"] = "建议"
L["SUGGESTIONS_ZONERENAME_DALARAN_BROKENISLES"] = "达拉然 (破碎群岛)"
L["SUGGESTIONS_ZONERENAME_DALARAN_NORTHREND"] = "达拉然 (诺森德)"
L["SUGGESTIONS_ZONERENAME_KARAZHAN_LEGION"] = "重返卡拉赞"
L["SUGGESTIONS_ZONERENAME_NAGRAND_DRAENOR"] = "纳兰格 (德拉诺)"
L["SUGGESTIONS_ZONERENAME_NAGRAND_OUTLAND"] = "纳兰格 (外域)"
L["SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_DRAENOR"] = "影月谷 (德拉诺)"
L["SUGGESTIONS_ZONERENAME_SHADOWMOONVALLEY_OUTLAND"] = "影月谷 (外域)"
L["TAB_HELP"] = "|cffffffffCtrl-点击|r跳转到该成就在成就界面的位置。|n|n|cffffffffCtrl-shift-点击|r查看相关的成就。|n|n一个|cffffffff蓝色背景|r表示你还没有完成该前续步骤的成就。|n|n一个|cffffffff红色背景|r表示该成就无法在当前人物的成就界面中找到，因为这是阵营专属或是无法取得的光辉事迹。|n|n一个|cffffffff绿色背景|r表示该成就会出现在‘最近的提醒’列表。 它会在过去的2分钟内显得特别重要 (列如：它的计时器或者目标会显示在鼠标提示上)。"
L["TAB_SORT"] = "排序："
L["TAB_SORT_COMPLETE"] = "完成时间"
L["TAB_SORT_ID"] = "成就ID"
L["TAB_SORT_NAME"] = "名称"
L["TAB_SORT_POINTS"] = "成就点数"
L["TAB_SORT_RELATION"] = "相关"
L["WATCH_CLEAR"] = "清除"
L["WATCH_COPY"] = "复制"
L["WATCH_COPY_TIP"] = "当启用时，假如你 |cffffffffshift+alt+点击|r 一个标签上的成就，将会新增至指定的监视列表中。"
L["WATCH_DEFAULTLIST"] = "默认列表："
L["WATCH_DEFAULTLIST_TIP"] = "The specified list will be the Displayed List at the beginning of each session."
L["WATCH_DELETE"] = "删除"
L["WATCH_DISPLAYEDLIST"] = "已显示列表："
L["WATCH_EMPTY"] = "你的监视列表是空的。在成就标签上或是成就链接上 Alt+点击 来监视。"
L["WATCH_EMPTY_SHORT"] = "清空列表"
L["WATCH_ERR_INVALIDID"] = "已将\"%s\"从监视列表中移除：找不到这个成就。"
L["WATCH_HELP"] = "在其他成就标签上或是成就链接使用 |cffffffffalt+点击|r来新建你的监视列表. |cffffffffAlt+点击|r 将停止监视. "
L["WATCH_LIST_GLOBAL"] = "全局"
L["WATCH_LIST_PERCHAR"] = "字符特殊"
L["WATCH_NEW"] = "新增"
L["WATCH_POPUP_CLEARLIST"] = "确定要清除这个成就监视列表的内容么？"
L["WATCH_POPUP_DELETELIST"] = "确定要删除这个成就监视列表么？"
L["WATCH_POPUP_NEWLIST"] = "输入一个新的成就监视列表名称："
L["WATCH_TAB"] = "监视"

end



if (locale == "zhTW") then  -- Traditional Chinese
	L["SUBZONES"] = {
		["Argent Pavilion"] = "銀白亭閣",
		["Argent Tournament Grounds"] = "銀白聯賽場地",
		["Formation Grounds"] = "構築之地",
		["Razorscale's Aerie"] = "銳鱗之巢",
		["Silver Covenant Pavilion"] = "白銀誓盟亭閣",
		["Sunreaver Pavilion"] = "奪日者亭閣",
		["The Alliance Valiants' Ring"] = "聯盟驍士競技場",
		["The Argent Valiants' Ring"] = "銀白驍士競技場",
		["The Aspirants' Ring"] = "志士競技場",
		["The Assembly of Iron"] = "鐵之集會所",
		["The Celestial Planetarium"] = "星穹渾天儀",
		["The Clash of Thunder"] = "雷鳴之廳",
		["The Colossal Forge"] = "巨熔爐",
		["The Conservatory of Life"] = "生命溫室",
		["The Descent into Madness"] = "驟狂斜廊",
		["The Halls of Winter"] = "凜冬之廳",
		["The Horde Valiants' Ring"] = "部落驍士競技場",
		["The Observation Ring"] = "觀察之環",
		["The Prison of Yogg-Saron"] = "尤格薩倫之獄",
		["The Ring of Champions"] = "勇士競技場",
		["The Scrapyard"] = "廢料場",
		["The Shattered Walkway"] = "破碎走道",
		["The Spark of Imagination"] = "創思之廳",
	}

elseif (locale == "zhCN") then  -- Simplified Chinese
	L["SUBZONES"] = {
		["Argent Pavilion"] = "银色大帐",
		["Argent Tournament Grounds"] = "银色比武场",
		["Formation Grounds"] = "练兵场",
		["Razorscale's Aerie"] = "锋鳞之巢",
		["Silver Covenant Pavilion"] = "银色盟约大帐",
		["Sunreaver Pavilion"] = "夺日者大帐",
		["The Alliance Valiants' Ring"] = "联盟勇士赛场",
		["The Argent Valiants' Ring"] = "银色勇士赛场",
		["The Aspirants' Ring"] = "候选者赛场",
		["The Assembly of Iron"] = "钢铁议会",
		["The Celestial Planetarium"] = "天文台",
		["The Clash of Thunder"] = "雷霆角斗场",
		["The Colossal Forge"] = "巨人熔炉",
		["The Conservatory of Life"] = "生命温室",
		["The Descent into Madness"] = "疯狂阶梯",
		["The Halls of Winter"] = "寒冬大厅",
		["The Horde Valiants' Ring"] = "部落勇士赛场",
		["The Observation Ring"] = "观测场",
		["The Prison of Yogg-Saron"] = "尤格-萨隆的监狱",
		["The Ring of Champions"] = "冠军赛场",
		["The Scrapyard"] = "废料场",
		["The Shattered Walkway"] = "破碎通道",
		["The Spark of Imagination"] = "思想火花",
	}

end

if (not L.SUBZONES) then
	L.SUBZONES = {
	-- Ulduar:
		["Formation Grounds"] = "Formation Grounds",
		["Razorscale's Aerie"] = "Razorscale's Aerie",
		["The Assembly of Iron"] = "The Assembly of Iron",
		["The Celestial Planetarium"] = "The Celestial Planetarium",
		["The Clash of Thunder"] = "The Clash of Thunder",
		["The Colossal Forge"] = "The Colossal Forge",
		["The Conservatory of Life"] = "The Conservatory of Life",
		["The Descent into Madness"] = "The Descent into Madness",
		["The Halls of Winter"] = "The Halls of Winter",
		["The Observation Ring"] = "The Observation Ring",
		["The Prison of Yogg-Saron"] = "The Prison of Yogg-Saron",
		["The Scrapyard"] = "The Scrapyard",
		["The Shattered Walkway"] = "The Shattered Walkway",
		["The Spark of Imagination"] = "The Spark of Imagination",
	-- Icecrown:
		["Argent Tournament Grounds"] = "Argent Tournament Grounds",
		["The Ring of Champions"] = "The Ring of Champions",
		["Argent Pavilion"] = "Argent Pavilion",
		["The Argent Valiants' Ring"] = "The Argent Valiants' Ring",
		["The Aspirants' Ring"] = "The Aspirants' Ring",
		["The Alliance Valiants' Ring"] = "The Alliance Valiants' Ring",
		["Silver Covenant Pavilion"] = "Silver Covenant Pavilion",
		["Sunreaver Pavilion"] = "Sunreaver Pavilion",
		["The Horde Valiants' Ring"] = "The Horde Valiants' Ring",
	}
end
