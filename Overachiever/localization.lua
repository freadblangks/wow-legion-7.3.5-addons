
-- Thank you to all of the translators that have helped localize Overachiever. In addition to those mentioned
-- below in their respective sections, recognition is due to all who have used the localization system provided
-- for Overachiever by Curse Forge. See a list of them here:
-- http://wow.curseforge.com/projects/overachiever/localization/translators/

OVERACHIEVER_STRINGS = {
	THIS_TITLE = "Overachiever";
	BINDING_NAME_OVERACHIEVER_TAB_SEARCH = "Open Search Tab";
	BINDING_NAME_OVERACHIEVER_TAB_SUGGESTIONS = "Open Suggestions Tab";
	BINDING_NAME_OVERACHIEVER_TAB_WATCH = "Open Watch Tab";

	OVERACHIEVER_INSTALLED_TOAST = "OVERACHIEVER INSTALLED!";
	OVERACHIEVER_INSTALLED_MSG = "|cff7eff00Overachiever|r v%s was installed.";
	OVERACHIEVER_UPDATED_TOAST = "OVERACHIEVER UPDATED!";
	OVERACHIEVER_UPDATED_MSG = "|cff7eff00Overachiever|r was updated to v%s.";

	STARTTOAST_EVENT = "Happening Today";

	SERIESTIP = "Part of a series:";
	REQUIREDFORMETATIP = "Required for:";
	PROGRESSIFOTHERCOMPLETED = "%s's Progress:";
	RECENTREMINDERCRITERIA = "Recently spotted objective:";

	PROGRESS = "Progress";
	YOURPROGRESS = "Your Progress";
	COMPLETEDATE = "Completed on %2$d/%1$02d/%3$02d";  -- 1 - day 2 - month 3 - year
	INCOMPLETE = "Incomplete";

	MULTI_NEED = "%s (needed for %s achievements)";

	KILL_INCOMPLETE = "Need to kill";
	KILL_COMPLETE = "Already killed";
	--? "Need to defeat" -- for things you need to defeat but not kill

	CRITTER = "Critter";
	WILDPET = "Wild Pet";
	ACH_LOVECRITTERS_INCOMPLETE = "Needs some /love";
	ACH_LOVECRITTERS_COMPLETE = "Already /loved";

	ACH_WELLREAD_INCOMPLETE = "Needs to be read";
	ACH_WELLREAD_COMPLETE = "Already read";

	ACH_ANGLER_INCOMPLETE = "Need to fish";
	ACH_ANGLER_COMPLETE = "Already fished";
	-- Since some achievements say to catch a certain fish but don't require fishing from a specific node and so don't give the node's name in the criteria,
	-- use this to make reminder tooltips work on those nodes where the fish name is known but the node's full name isn't. The %s is a stand-in for the
	-- fish name. Put each possibility on a new line.
	ACH_FISHSCHOOL_FORMAT = [[%s School
School of %s
%s Swarm]];

	-- For fishing achievements that have only one criteria and which require fishing from a node. Put each on a new line. Format: <achievement ID>=<fishing node names (separated by commas)>
	ACH_ANGLER_COUNT = [[9455=Fire Ammonite School
9456=Abyssal Gulper School,Oily Abyssal Gulper School
9457=Blackwater Whiptail School
9458=Blind Lake Sturgeon School
9459=Fat Sleeper School
9460=Jawless Skulker School
9461=Sea Scorpion School,Oily Sea Scorpion School
]];

	ACH_CONSUME_INCOMPLETE = "Need to consume";
	ACH_CONSUME_COMPLETE = "Already consumed";
	ACH_CONSUME_INCOMPLETE_EXTRA = "Haven't consumed";

	ACH_CONSUME_91_INCOMPLETE = "I dare you to eat 91 all at once!";
	ACH_CONSUME_91_COMPLETE = "Gluttony already proven"; --"1000% Satisfied";

	ACH_LETITSNOW_INCOMPLETE = "Need to use Handful of Snowflakes";
	ACH_LETITSNOW_COMPLETE = "Already used Handful of Snowflakes";
	ACH_FISTFULOFLOVE_INCOMPLETE = "Need to use Handful of Rose Petals";
	ACH_FISTFULOFLOVE_COMPLETE = "Already used Handful of Rose Petals";
	ACH_BUNNYMAKER_INCOMPLETE = "Need to use Spring Flowers";
	ACH_BUNNYMAKER_COMPLETE = "Already used Spring Flowers";
	ACH_CHECKYOURHEAD_INCOMPLETE = "Needs a pumpkin head";
	ACH_CHECKYOURHEAD_COMPLETE = "Already pumpkin-headed";
	ACH_TURKEYLURKEY_INCOMPLETE = "Needs feathers";
	ACH_TURKEYLURKEY_COMPLETE = "Already feathered";

	HOLIDAY_DARKMOONFAIRE = "Darkmoon Faire";
	HOLIDAY_LUNARFESTIVAL = "Lunar Festival";
	HOLIDAY_LOVEISINTHEAIR = "Love is in the Air";
	HOLIDAY_NOBLEGARDEN = "Noblegarden";
	HOLIDAY_CHILDRENSWEEK = "Children's Week";
	HOLIDAY_MIDSUMMER = "Midsummer Fire Festival";
	HOLIDAY_MIDSUMMER_SHORT = "Midsummer";
	HOLIDAY_PIRATESDAY = "Pirates' Day";
	HOLIDAY_BREWFEST = "Brewfest";
	HOLIDAY_HALLOWSEND = "Hallow's End";
	HOLIDAY_DAYOFTHEDEAD = "Day of the Dead";
	HOLIDAY_PIGRIMSBOUNTY = "Pilgrim's Bounty";
	HOLIDAY_WINTERVEIL = "Feast of Winter Veil";
	HOLIDAY_WINTERVEIL_SHORT = "Winter Veil";

	MSG_INVALIDID = "Invalid input: No achievement with that ID.";
	MSG_NAMENOTFOUND = 'No achievement with name containing "|cffffffff%s|r" was found.';
	MSG_OPENINGTO = "Opening to: ";
	MSG_ONEFOUND = "1 other achievement found: ";
	MSG_NUMFOUNDLIST = "%s other achievements found:";
	MSG_ACHNOTFOUND = "Achievement not found.";
	MSG_CRITERIAPROGRESS = "|cff7eff00Achievement Progress:|r %s (%s)";

	OPTPANEL_REMINDERTOOLTIPS = "Reminder Tooltips";

	OPT_LABEL_SEASONALACHS = "SEASONAL ACHIEVEMENTS";

	OPT_LABEL_ACHTWO = '"%s" and "%s"';
	OPT_LABEL_ACHTHREE = '"%s," "%s," and "%s"';
	OPT_LABEL_ACHFOUR = '"%s," "%s,"|n"%s," "%s"';
	OPT_LABEL_ACHFIVE = '"%s," "%s,"|n"%s," "%s"|n"%s"';
	OPT_LABEL_ACHSIX = '"%s," "%s,"|n"%s," "%s"|n"%s," "%s"';
	OPT_LABEL_ACHSEVEN = '"%s," "%s,"|n"%s," "%s"|n"%s," "%s," "%s"';

	OPT_ACHUNKNOWN = "<Unknown>";

	OPT_LABEL_TOOLTIPS = "Achievement Tooltips and Links";
	OPT_SHOWPROGRESS = "Add your progress";
	OPT_SHOWPROGRESS_TIP = 'Add your progress when an achievement has quantity-based criteria, such as "Obtain 10 mounts."';
	OPT_SHOWPROGRESS_OTHER = "Compare progress in others' links";
	OPT_SHOWPROGRESS_OTHER_TIP = "Add your progress when the achievement info shown is that of another player.";
	OPT_SHOWID = "Show achievement IDs";

	OPT_LABEL_TRACKING = "Achievement Tracking";
	OPT_AUTOTRACKTIMED = "Auto-track timed achievements (non-battleground)";
	OPT_AUTOTRACKTIMED_TIP = "Automatically track achievements with timed criteria when the timer starts. If you are already tracking the maximum number of achievements, it will attempt to take the place of an auto-tracked exploration achievement; otherwise, it won't be tracked.|n|nExcludes achievements that require a battleground win.";
	OPT_AUTOTRACKTIMED_BG = "Auto-track timed battleground achievements";
	OPT_AUTOTRACKTIMED_TIP_BG = "When a battleground match starts, automatically track the achievement for winning it in a set amount of time (if it is incomplete).|n|nThe achievement is untracked upon leaving the battleground.";
	OPT_AUTOTRACKEXPLORE = "Auto-track exploration achievements as you travel";
	OPT_AUTOTRACKEXPLORE_TIP = "When you enter a zone, automatically track its exploration achievement. If already tracking an exploration achievement, this will replace the previous automatically-tracked one if there is one or another exploration achievement otherwise.";
	OPT_AUTOTRACKEXPLORE_COMPLETED = "Including completed achievements";
	OPT_AUTOTRACK_CRITERIATOAST = 'Auto-track upon "Achievement Progress" toast';
	OPT_AUTOTRACK_CRITERIATOAST_TIP = 'When the "Achievement Progress" toast appears, automatically track the achievement (if the tracking limit permits).';

	OPT_LABEL_CRITERIATOAST = "Progress Reaction (Non-Tracking)";
	OPT_CRITERIATOAST_CHATLOG = "Add to chat log";
	OPT_CRITERIATOAST_CHATLOG_TIP = 'When the "Achievement Progress" toast appears, link the achievement and show the completed criteria in the chat log.';
	OPT_CRITERIATOAST_SUGGEST = "Add to Recent Reminders (Suggestions)";
	OPT_CRITERIATOAST_SUGGEST_TIP = 'When the "Achievement Progress" toast appears, temporarily add the achievement to the Suggestions tab as a "Recent Reminder."';

	OPT_CRITTERTIPS = "Critter /loved?";
	OPT_CRITTERTIPS_TIP = "If this achievement is incomplete, add a line to the tooltips of critters that are part of its criteria to indicate whether you still need to /love that type of critter.";
	OPT_PESTCONTROLTIPS = "Pest exterminated?";
	OPT_PESTCONTROLTIPS_TIP = "If this achievement is incomplete, add a line to the tooltips of critters that are part of its criteria to indicate whether you still need to exterminate them.";
	OPT_WELLREADTIPS = "Book read?";
	OPT_WELLREADTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of books that are part of its criteria to indicate whether you need to read them.";
	OPT_ANGLERTIPS = "Fishing node fished?";
	OPT_ANGLERTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of fishing nodes that are part of its criteria to indicate whether you need to fish from them.";
	OPT_ANGLERTIPS_TIP_ALWAYS = "Add a line to the tooltips of fishing nodes that are part of its criteria to indicate whether you need to fish from them.";
	OPT_LABEL_DRAENORANGLER = '"%s" Sub-Achievements';

	OPT_LETITSNOWTIPS = "Handful of Snowflakes used?";
	OPT_LETITSNOWTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of players of an appropriate race/class combo to indicate whether you need to use a Handful of Snowflakes on them.";
	OPT_FISTFULOFLOVETIPS = "Handful of Rose Petals used?";
	OPT_FISTFULOFLOVETIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of players of an appropriate race/class combo to indicate whether you need to use a Handful of Rose Petals on them.";
	OPT_BUNNYMAKERTIPS = "Spring Flowers used?";
	OPT_BUNNYMAKERTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of players of an appropriate gender and level to indicate whether you need to use Spring Flowers on them. Note that enemy players that are 10 or more levels higher than you are assumed to be at least level 18.";
	OPT_CHECKYOURHEADTIPS = "Weighted Jack-o'-Lantern used?";
	OPT_CHECKYOURHEADTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of players to indicate whether you need to use a Weighted Jack-o'-Lantern on them.";
	OPT_TURKEYLURKEYTIPS = "Turkey Shooter used?";
	OPT_TURKEYLURKEYTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of players to indicate whether you need to use your Turkey Shooter on them.";

	OPT_CONSUMEITEMTIPS = "Item consumed?";
	OPT_CONSUMEITEMTIPS_TIP = "If the achievement is incomplete, add a line to the tooltips of items that are part of its criteria to indicate whether you need to consume them.";
	OPT_CONSUMEITEMTIPS_TIP2 = "Items that you are too low level to consume will not trigger a reminder sound.";
	--OPT_CONSUMEITEMTIPS_TIP3 = "Note: This option can add a few seconds to your initial load time.";
	OPT_CONSUMEITEMTIPS_WHENCOMPLETE = "Show even if achievement is complete";

	OPT_SATISFIEDTIPS = "1000% Satisfied?";
	OPT_SATISFIEDTIPS_TIP = "Add a line to the tooltips of items that are part the achievement's criteria to indicate whether you need to consume them.";

	OPT_LABEL_NEEDTOKILL = 'Kill Creature Achievements ("%s," "%s," etc.)';
	OPT_KILLCREATURETIPS = "Creature killed?";
	OPT_KILLCREATURETIPS_TIP = "Add a line to the tooltips of creatures (excluding critters) that need to be killed to meet the criteria of an incomplete achievement indicating whether you still need to kill them.";
	OPT_KILLCREATURETIPS_TIP2 = "Note: At startup (or when this is option is enabled), every achievement is scanned to find unit IDs. Not all achievements provide such IDs. Most do, but the tooltips of creatures which are the criteria of those that don't won't be altered by this option.";

	OPT_LABEL_MAINUI = "Main Achievement UI Modifications";
	OPT_UI_SERIESTIP = "Tooltip for achievements that are part of a series";
	OPT_UI_SERIESTIP_TIP = "When the cursor is over an achievement that is part of a series, display the names of others in the series and its relation to them.";
	OPT_UI_REQUIREDFORMETATIP = "Tooltip for achievements required by others";
	OPT_UI_REQUIREDFORMETATIP_TIP = "When the cursor is over an achievement that is required to earn another achievement, display the name of the meta-achievement.";
	OPT_UI_PROGRESSIFOTHERCOMPLETED = "Tooltip for quantity-based progress if completed by another";
	OPT_UI_PROGRESSIFOTHERCOMPLETED_TIP = "When the cursor is over a quantity-based achievement (e.g. critera of \"Obtain 10 mounts\") that was completed but not by the current character, display the current character's progress.";
	OPT_DRAGGABLE = "Make draggable";
	OPT_DRAGSAVE = "Remember position";
	OPT_UI_HOLIDAYNOTICE = "Display notice if a holiday event is active";
	OPT_UI_HOLIDAYNOTICE_SUGGESTIONSTABONLY = "On Suggestions tab only";
	OPT_UI_HOLIDAYNOTICE_TIP = "If there is a holiday event today (e.g. Brewfest or Darkmoon Faire), a graphical notice appears next to the achievement UI. Clicking it displays achievements for that event. Put your cursor over it for more details.";
	OPT_UI_HOLIDAYNOTICE_TIP2 = "|cffffffffTabs module with Suggestions tab is required.|r";

	OPT_LABEL_TRADESKILLUI = "Professions UI Modifications";
	OPT_TRADESKILL_SHOWCOMPLETEDACH_COOKING = "Indicate uncooked recipes for complete achievements";
	OPT_TRADESKILL_SHOWCOMPLETEDACH_COOKING_TIP = "If Overachiever's Trade module is enabled, then an achievement icon appears next to recipes that you need to cook in order to earn certain achievements. If this option is checked, then these icons will appear next to uncooked recipes even if the associated achievement is complete.";

	OPT_LABEL_STARTTOAST = "Holiday/Event Toasts";
	OPT_STARTTOAST_HOLIDAY = "Show today's holidays";
	OPT_STARTTOAST_HOLIDAY_TIP = "Show today's holidays in toast notifications upon entering the game world.";
	OPT_STARTTOAST_MICROHOLIDAY = "Show today's micro-holidays";
	OPT_STARTTOAST_MICROHOLIDAY_TIP = "Show today's micro-holidays in toast notifications upon entering the game world.";
	OPT_STARTTOAST_BONUS = "Show today's bonus events";
	OPT_STARTTOAST_BONUS_TIP = "Show today's bonus events in toast notifications upon entering the game world.";
	OPT_STARTTOAST_DUNGEON = "Show today's dungeon events";
	OPT_STARTTOAST_DUNGEON_TIP = "Show today's dungeon events in toast notifications upon entering the game world.";
	OPT_STARTTOAST_PVPBRAWL = "Show today's PvP brawl";
	OPT_STARTTOAST_PVPBRAWL_TIP = "Show today's PvP brawl in toast notifications upon entering the game world.";
	OPT_STARTTOAST_MISC = "Show today's misc. holidays";
	OPT_STARTTOAST_MISC_TIP = "Show today's miscellaneous \"holiday\" events in toast notifications upon entering the game world.";
	OPT_STARTTOAST_MISC_TIP2 = "These are events found in the default calendar as \"holidays\" but are neither considered full holidays nor covered by another category given here. Examples include WoW Anniversaries and raid release days (for new raids or difficulties, not weekly resets).";
	OPT_STARTTOAST_TIMEFADE = "Do not automatically hide";
	OPT_STARTTOAST_TIMEFADE_TIP = "Prevent toast notifications you don't interact with from fading after a few seconds.";
	OPT_STARTTOAST_ONLYCLICKFADE = "Require click to hide";
	OPT_STARTTOAST_ONLYCLICKFADE_TIP = "Prevent toast notifications from fading unless left- or right-clicked. (If unchecked, they will also fade if the cursor goes over them and then moves away.)";

	OPT_SELECTSOUND = "Incomplete Achievement Reminder Sound";
	OPT_SELECTSOUND_TIP = "Play the selected sound when an incomplete achievement reminder is added to the tooltip.";
	OPT_SELECTSOUND_TIP2 = "Sounds will only play once every 15 seconds.";
	OPT_SELECTSOUND_ANGLERCHECKPOLE = "Exclude fishing node reminders if pole is equipped";
	OPT_SELECTSOUND_ANGLERCHECKPOLE_TIP = "Don't play reminder sound from fishing nodes if your fishing pole is equipped.";
	OPT_SELECTSOUND_CHECKCOMBAT = "Exclude kill reminders if in combat with creature";
	OPT_SELECTSOUND_CHECKCOMBAT_TIP = "Don't play reminder sound from needing to kill a creature while you are in combat with it.";

	OPT_LABEL_MISC = "Miscellaneous";
	OPT_THROTTLE_ACHLOOKUP = "Startup: Throttle achievement lookup";
	OPT_THROTTLE_ACHLOOKUP_TIP = "Overachiever looks up certain data on startup. If this is unchecked, lookup happens all at once while the UI is first loading. If checked, data is gathered over time after the player enters the world.|n|nThe advantage to throttled lookup is a faster initial loading time, but, for some users and on some characters, this can temporarily impact performance.";

	SOUND_BELL_ALLIANCE = "Bell - Alliance";
	SOUND_BELL_HORDE = "Bell - Horde";
	SOUND_BELL_NIGHTELF = "Bell - Night Elf";
	SOUND_DRUMHIT = "Drum Hit";
	SOUND_BELL_BOATARRIVED = "Bells - Boat Arrived";
	SOUND_GONG_TROLL = "Gong - Troll";
	SOUND_BELL_MELLOW = "Mellow Bells";
	SOUND_ENTERQUEUE = "Enter Queue";
	SOUND_HEARTHBIND = "Hearthstone Bind";
	SOUND_BELL_KARA = "Karazhan Bell";
	SOUND_DING_AUCTION = "Auction Ding";
	SOUND_BELL_AUCTION = "Auction Bells";
	SOUND_ALARM1 = "Alarm Clock 1";
	SOUND_ALARM2 = "Alarm Clock 2";
	SOUND_ALARM3 = "Alarm Clock 3";
	SOUND_MAP_PING = "Map Ping";
	SOUND_SIMON_DING = "Simon Ding";
	SOUND_SIMON_STARTGAME = "Simon Start Game";
	SOUND_SIMON_STARTLEVEL = "Simon Start Level";
	SOUND_YAR = "Yarrrr";
	SOUND_AGGRO_WARNING = "Aggro Warning";
	SOUND_AGGRO_PULLED = "Aggro Pulled";
	SOUND_GLYPH_CREATE_MAJOR = "Glyph Create Major";
	SOUND_GLYPH_CREATE_MINOR = "Glyph Create Minor";
	SOUND_GLYPH_DESTROY_MAJOR = "Glyph Destroy Major";
	SOUND_GLYPH_DESTROY_MINOR = "Glyph Destroy Minor";
	SOUND_BGTIMER = "Battleground Timer";
	SOUND_MEDAL_EXPIRES = "Medal Expires";
	SOUND_GARRISON_INVASION = "Garrison Invasion Alert";
}

local L, locale = OVERACHIEVER_STRINGS, GetLocale()

--if (locale == "enGB") then  -- English (EU)
-- Unfortunately, GetLocale() returns "enUS" even when "enGB" would be more appropriate, and the SHORTDATE
-- global string is defined incorrectly for enGB clients (it's set as it is for enUS), so we have to do things
-- this way:
if (ACHIEVEMENT_TOOLTIP_COMPLETE == "Achievement earned by %1$s on %3$d/%2$d/20%4$02d") then
	L["COMPLETEDATE"] = "Completed on %1$d/%2$02d/%3$02d";  -- 1 - day 2 - month 3 - year
end

if (locale == "zhTW") then  -- Traditional Chinese
L["THIS_TITLE"] = "成就"
-- Thanks to user xyrho at wowinterface.com and laincat at curse.com for many of these translations:
L["ACH_ANGLER_COMPLETE"] = "已釣過"
--Translation missing 
-- L["ACH_ANGLER_COUNT"] = ""
L["ACH_ANGLER_INCOMPLETE"] = "未釣過"
L["ACH_BUNNYMAKER_COMPLETE"] = "已經使用春日鮮花"
L["ACH_BUNNYMAKER_INCOMPLETE"] = "需要使用春日鮮花"
L["ACH_CHECKYOURHEAD_COMPLETE"] = "已經使用增重的南瓜燈籠"
L["ACH_CHECKYOURHEAD_INCOMPLETE"] = "需要使用增重的南瓜燈籠"
--Translation missing 
-- L["ACH_CONSUME_91_COMPLETE"] = ""
--Translation missing 
-- L["ACH_CONSUME_91_INCOMPLETE"] = ""
L["ACH_CONSUME_COMPLETE"] = "已使用過"
L["ACH_CONSUME_INCOMPLETE"] = "需要使用"
L["ACH_CONSUME_INCOMPLETE_EXTRA"] = "未使用過"
L["ACH_FISHSCHOOL_FORMAT"] = "%s系"
L["ACH_FISTFULOFLOVE_COMPLETE"] = "已用過一把玫瑰花瓣"
L["ACH_FISTFULOFLOVE_INCOMPLETE"] = "需使用一把玫瑰花瓣"
L["ACH_LETITSNOW_COMPLETE"] = "已用過一捧雪花"
L["ACH_LETITSNOW_INCOMPLETE"] = "需使用一捧雪花"
L["ACH_LOVECRITTERS_COMPLETE"] = "已 /愛 過"
L["ACH_LOVECRITTERS_INCOMPLETE"] = "需要 /愛"
L["ACH_TURKEYLURKEY_COMPLETE"] = "已經使用過火雞獵槍"
L["ACH_TURKEYLURKEY_INCOMPLETE"] = "需要使用火雞獵槍"
L["ACH_WELLREAD_COMPLETE"] = "已讀過"
L["ACH_WELLREAD_INCOMPLETE"] = "未讀過"
L["BINDING_NAME_OVERACHIEVER_TAB_SEARCH"] = "開啟搜尋標籤頁面"
L["BINDING_NAME_OVERACHIEVER_TAB_SUGGESTIONS"] = "開啟建議標籤頁面"
L["BINDING_NAME_OVERACHIEVER_TAB_WATCH"] = "開啟觀察標籤頁面"
L["COMPLETEDATE"] = "已完成 %2$d/%1$02d/%3$02d"
L["CRITTER"] = "小動物"
--Translation missing 
-- L["HOLIDAY_BREWFEST"] = ""
--Translation missing 
-- L["HOLIDAY_CHILDRENSWEEK"] = ""
--Translation missing 
-- L["HOLIDAY_DARKMOONFAIRE"] = ""
--Translation missing 
-- L["HOLIDAY_DAYOFTHEDEAD"] = ""
--Translation missing 
-- L["HOLIDAY_HALLOWSEND"] = ""
--Translation missing 
-- L["HOLIDAY_LOVEISINTHEAIR"] = ""
--Translation missing 
-- L["HOLIDAY_LUNARFESTIVAL"] = ""
--Translation missing 
-- L["HOLIDAY_MIDSUMMER"] = ""
--Translation missing 
-- L["HOLIDAY_MIDSUMMER_SHORT"] = ""
--Translation missing 
-- L["HOLIDAY_NOBLEGARDEN"] = ""
--Translation missing 
-- L["HOLIDAY_PIGRIMSBOUNTY"] = ""
--Translation missing 
-- L["HOLIDAY_PIRATESDAY"] = ""
--Translation missing 
-- L["HOLIDAY_WINTERVEIL"] = ""
--Translation missing 
-- L["HOLIDAY_WINTERVEIL_SHORT"] = ""
L["INCOMPLETE"] = "未完成"
L["KILL_COMPLETE"] = "已擊殺"
L["KILL_INCOMPLETE"] = "需要擊殺"
L["MSG_ACHNOTFOUND"] = "找不到該成就。"
--Translation missing 
-- L["MSG_CRITERIAPROGRESS"] = ""
L["MSG_INVALIDID"] = "無效輸入：沒有成就有這編號。"
L["MSG_NAMENOTFOUND"] = "沒有包含 \"|cffffffff%s|r\" 的成就名稱被找到。"
L["MSG_NUMFOUNDLIST"] = "另外找到 %s 項成就："
L["MSG_ONEFOUND"] = "找到 1 項成就："
L["MSG_OPENINGTO"] = "開啟："
--Translation missing 
-- L["MULTI_NEED"] = ""
L["OPT_ACHUNKNOWN"] = "<未知>"
L["OPT_ANGLERTIPS"] = "提示魚點是否釣過？"
L["OPT_ANGLERTIPS_TIP"] = "如果成就有缺少，新增一行提示到魚點的標準說明從任何你需要來釣魚的魚點。"
--Translation missing 
-- L["OPT_ANGLERTIPS_TIP_ALWAYS"] = ""
L["OPT_AUTOTRACK_CRITERIATOAST"] = "自動追蹤彈出的 \"成就進度\""
L["OPT_AUTOTRACK_CRITERIATOAST_TIP"] = "\"成就進度\" 訊息彈出時，自動追蹤成就 (沒有超過追蹤數量上限時)。"
L["OPT_AUTOTRACKEXPLORE"] = "自動追蹤探索成就"
L["OPT_AUTOTRACKEXPLORE_COMPLETED"] = "包括已完成的成就"
L["OPT_AUTOTRACKEXPLORE_TIP"] = "轉換地圖時自動追蹤該區域探索成就。"
L["OPT_AUTOTRACKTIMED"] = "自動追蹤計時相關的成就 (戰場除外)"
L["OPT_AUTOTRACKTIMED_BG"] = "自動追蹤計時相關的戰場成就"
L["OPT_AUTOTRACKTIMED_TIP"] = "開始計時的時候自動追蹤有時間限制標準的成就。如果已經達到能夠追蹤的成就數量上限，會嘗試取代自動追蹤的探索成就；否則將不會被追蹤。|n|n不包含需要戰場勝利的成就。"
L["OPT_AUTOTRACKTIMED_TIP_BG"] = "戰場配對開始時，自動追蹤在特定時間內勝利的成就 (如果尚未完成的話)。|n|n離開戰場時會取消追蹤成就。"
L["OPT_BUNNYMAKERTIPS"] = "新增任何你需要許用春日鮮花"
L["OPT_BUNNYMAKERTIPS_TIP"] = "如果這個成就尚未完成，在18級以上女性玩家的提示訊息中提示你是否需要對她使用春日鮮花。注意假如是大於你10級的敵對角色，會被假設為至少18級。"
L["OPT_CHECKYOURHEADTIPS"] = "提示是否需要使用增重的南瓜燈籠"
L["OPT_CHECKYOURHEADTIPS_TIP"] = "如果這個成就尚未完成，在玩家的提示訊息中提示你是否需要對他使用增重的南瓜燈籠。"
L["OPT_CONSUMEITEMTIPS"] = "提示食物是否吃過？"
L["OPT_CONSUMEITEMTIPS_TIP"] = "增加食物提示說明"
L["OPT_CONSUMEITEMTIPS_TIP2"] = "如果你的等級不足以食用這個物品時，將不做提示"
L["OPT_CONSUMEITEMTIPS_WHENCOMPLETE"] = "完成後是否繼續提示"
L["OPT_CRITERIATOAST_CHATLOG"] = "新增到聊天內容"
L["OPT_CRITERIATOAST_CHATLOG_TIP"] = "\"成就進度\" 訊息彈出時，連結成就並且在聊天內容中顯示達成條件。"
L["OPT_CRITERIATOAST_SUGGEST"] = "新增到近期提醒 (建議)"
L["OPT_CRITERIATOAST_SUGGEST_TIP"] = "\"成就進度\" 訊息彈出時，將成就暫時加入到建議標籤頁做為 \"近期提醒\"。"
L["OPT_CRITTERTIPS"] = "提示小動物是否愛過"
L["OPT_CRITTERTIPS_TIP"] = "在小動物的提示說明中註明."
L["OPT_DRAGGABLE"] = "可拖曳移動"
L["OPT_DRAGSAVE"] = "記住視窗位置"
L["OPT_FISTFULOFLOVETIPS"] = "提示是否需要使用一把玫瑰花瓣"
L["OPT_FISTFULOFLOVETIPS_TIP"] = "增加玩家提示說明。"
L["OPT_KILLCREATURETIPS"] = "新增您是否需要殺死的怪物"
L["OPT_KILLCREATURETIPS_TIP"] = "新增一行動物提示(不包括小動物 )需要加以殺害，以符合標準的未完成的成就說明，表明您是否仍然需要殺死他們。"
L["OPT_KILLCREATURETIPS_TIP2"] = "注意：在啟動時(或是這設定啟用)，每個成就會被掃描來找出單位編號。並非所有成就提供編號。大部分如此，但是其中的生物的提示不會因為這設定而有改變。"
--Translation missing 
-- L["OPT_LABEL_ACHFIVE"] = ""
L["OPT_LABEL_ACHFOUR"] = "\"%s,\" \"%s,\"|n\"%s,\" \"%s\""
--Translation missing 
-- L["OPT_LABEL_ACHSEVEN"] = ""
L["OPT_LABEL_ACHSIX"] = "\"%s,\" \"%s,\"|n\"%s,\" \"%s\"|n\"%s,\" \"%s\""
L["OPT_LABEL_ACHTHREE"] = "\"%s,\" \"%s,\" 和 \"%s\""
L["OPT_LABEL_ACHTWO"] = "\"%s\" 和 \"%s\""
L["OPT_LABEL_CRITERIATOAST"] = "進度相關動作 (不追蹤)"
--Translation missing 
-- L["OPT_LABEL_DRAENORANGLER"] = ""
L["OPT_LABEL_MAINUI"] = "成就視窗微調"
L["OPT_LABEL_NEEDTOKILL"] = "擊殺怪物成就 (\"%s\",\"%s\",及其他)"
L["OPT_LABEL_SEASONALACHS"] = "世界事件成就"
L["OPT_LABEL_STARTTOAST"] = "節慶/事件彈出通知"
L["OPT_LABEL_TOOLTIPS"] = "成就提示和連結"
L["OPT_LABEL_TRACKING"] = "成就追蹤"
L["OPT_LABEL_TRADESKILLUI"] = "專業視窗微調"
L["OPT_LETITSNOWTIPS"] = "提示是否需要使用一捧雪花？"
L["OPT_LETITSNOWTIPS_TIP"] = "如果成就尚未完成，在適當種族與職業組合玩家的提示訊息中提示你是否需要使用一捧雪花。"
L["OPT_PESTCONTROLTIPS"] = "顯示是否需要擊殺害蟲的提示"
L["OPT_PESTCONTROLTIPS_TIP"] = "如果這個成就尚未完成，在那些害蟲的提示訊息中提示你是否需要擊殺牠們。"
L["OPT_SATISFIEDTIPS"] = "1000%滿足?"
--Translation missing 
-- L["OPT_SATISFIEDTIPS_TIP"] = ""
L["OPT_SELECTSOUND"] = "缺少成就提醒音效"
L["OPT_SELECTSOUND_ANGLERCHECKPOLE"] = "裝備魚竿時不提示釣魚成就"
L["OPT_SELECTSOUND_ANGLERCHECKPOLE_TIP"] = "裝備魚竿時不聲音提示釣魚成就"
L["OPT_SELECTSOUND_CHECKCOMBAT"] = "戰鬥對象正確時不提示擊殺成就"
L["OPT_SELECTSOUND_CHECKCOMBAT_TIP"] = "正在與成就所需要擊殺的生物戰鬥時，不要播放提醒音效。"
L["OPT_SELECTSOUND_TIP"] = "在發現一個需要完成的成就提示時播出提示音效"
L["OPT_SELECTSOUND_TIP2"] = "這個聲音每15秒只會出現1次"
L["OPT_SHOWID"] = "顯示成就ID"
L["OPT_SHOWPROGRESS"] = "顯示進度"
L["OPT_SHOWPROGRESS_OTHER"] = "比較其他人的進度連結"
L["OPT_SHOWPROGRESS_OTHER_TIP"] = "在別人的成就訊息連結說明中顯示自己的進度."
L["OPT_SHOWPROGRESS_TIP"] = "在提示說明中顯示成就進度."
L["OPT_STARTTOAST_BONUS"] = "顯示今天的獎勵事件"
L["OPT_STARTTOAST_BONUS_TIP"] = "進入遊戲時顯示今天的獎勵事件彈出通知。"
L["OPT_STARTTOAST_DUNGEON"] = "顯示今天的地城事件"
L["OPT_STARTTOAST_DUNGEON_TIP"] = "進入遊戲時顯示今天的地城事件彈出通知。"
L["OPT_STARTTOAST_PVPBRAWL"] = "顯示今天的 PvP 大亂鬥";
L["OPT_STARTTOAST_PVPBRAWL_TIP"] = "進入遊戲時顯示今天的 PvP 大亂鬥彈出通知。";
L["OPT_STARTTOAST_MISC"] = "顯示今天的其他節慶";
L["OPT_STARTTOAST_MISC_TIP"] = "進入遊戲時顯示顯示今天的其他 \"節慶\" 活動彈出通知。";
L["OPT_STARTTOAST_MISC_TIP2"] = "在預設行事曆中顯示為 \"節慶\" 的活動，但不是完整的節日，也不包含在這裡的其他分類之中。例如魔獸世界周年慶和開放團隊副本 (新的團隊副本或新的難度，不是每週的重置。)";
L["OPT_STARTTOAST_HOLIDAY"] = "顯示今天的節慶"
L["OPT_STARTTOAST_HOLIDAY_TIP"] = "進入遊戲時顯示顯示今天的節慶彈出通知。"
L["OPT_STARTTOAST_MICROHOLIDAY"] = "顯示今天的小型節慶"
L["OPT_STARTTOAST_MICROHOLIDAY_TIP"] = "進入遊戲時顯示今天的小型節慶彈出通知。"
L["OPT_STARTTOAST_ONLYCLICKFADE"] = "需要滑鼠點擊來隱藏通知"
L["OPT_STARTTOAST_ONLYCLICKFADE_TIP"] = "彈出通知不會自動消失除非使用滑鼠左鍵或右鍵點擊。 (停用時，滑鼠游標指向通知然後移開便會消失。)"
L["OPT_STARTTOAST_TIMEFADE"] = "不要自動隱藏"
L["OPT_STARTTOAST_TIMEFADE_TIP"] = "避免尚未使用滑鼠指向或點擊的彈出通知在幾秒後隱藏。"
L["OPT_TRADESKILL_SHOWCOMPLETEDACH_COOKING"] = "標示未烹飪食譜來完成成就"
L["OPT_TRADESKILL_SHOWCOMPLETEDACH_COOKING_TIP"] = "如果Overachiever_Trade模組啟用，那麼成就圖示顯示在你需要烹飪的食譜旁邊為了獲得一些成就。如果設定被勾選，那麼這些圖示會顯示在未被烹飪食譜旁邊即使相關成就已經完成。"
L["OPT_TURKEYLURKEYTIPS"] = "提示是否需要使用火雞獵槍"
L["OPT_TURKEYLURKEYTIPS_TIP"] = "如果成就尚未完成，在玩家的提示訊息中提示你是否需要對他使用火雞獵槍。"
L["OPT_UI_HOLIDAYNOTICE"] = "節慶事件開始時顯示提醒通知"
L["OPT_UI_HOLIDAYNOTICE_SUGGESTIONSTABONLY"] = "只顯示於建議標籤頁面"
L["OPT_UI_HOLIDAYNOTICE_TIP"] = "如果今天有節慶事件 (例如 啤酒節 或 暗月馬戲團)，成就介面旁會顯示提醒通知的圖形。點一下通知圖形顯示這個事件的成就，滑鼠指向時會顯示更多詳細說明。"
L["OPT_UI_HOLIDAYNOTICE_TIP2"] = "|cffffffff需要載入標籤頁模組和建議標籤頁面。|r"
L["OPT_UI_PROGRESSIFOTHERCOMPLETED"] = "滑鼠提示中顯示當前角色的數量進度"
L["OPT_UI_PROGRESSIFOTHERCOMPLETED_TIP"] = "滑鼠指向以數量為主的成就 (例如 \"獲得10個坐騎\") 若是由其他角色完成，當前的角色尚未完成，仍要顯示當前角色的進度。"
L["OPT_UI_REQUIREDFORMETATIP"] = "顯示其他需要此成就來完成的提示"
L["OPT_UI_REQUIREDFORMETATIP_TIP"] = "當游標位於一個成就，需要獲得的另一項成就，顯示成就樹名稱。"
L["OPT_UI_SERIESTIP"] = "顯示系列成就的提示"
L["OPT_UI_SERIESTIP_TIP"] = "當滑鼠指向一個系列成就時，顯示系列中其他成就的名字和與目前成就的關係"
L["OPT_WELLREADTIPS"] = "提示書本是否閱讀過"
L["OPT_WELLREADTIPS_TIP"] = "增加書本提示說明."
L["OPTPANEL_REMINDERTOOLTIPS"] = "滑鼠提示提醒"
L["OVERACHIEVER_INSTALLED_MSG"] = "|cff7eff00彩虹ui|r 已經安裝。"
L["OVERACHIEVER_INSTALLED_TOAST"] = "安裝彩虹ui !"
L["OVERACHIEVER_UPDATED_MSG"] = "|cff7eff00彩虹ui|r 已經更新。"
L["OVERACHIEVER_UPDATED_TOAST"] = "更新彩虹ui !"
L["PROGRESS"] = "進度"
L["PROGRESSIFOTHERCOMPLETED"] = "%s的進度"
--Translation missing 
-- L["RECENTREMINDERCRITERIA"] = ""
L["REQUIREDFORMETATIP"] = "需要："
L["SERIESTIP"] = "系列成就:"
--Translation missing 
-- L["SOUND_AGGRO_PULLED"] = ""
--Translation missing 
-- L["SOUND_AGGRO_WARNING"] = ""
L["SOUND_ALARM1"] = "鬧鈴聲 1"
L["SOUND_ALARM2"] = "鬧鈴聲 2"
L["SOUND_ALARM3"] = "鬧鈴聲 3"
L["OPT_LABEL_MISC"] = "其他";
L["OPT_THROTTLE_ACHLOOKUP"] = "加速啟動: 延後收集成就資料";
L["OPT_THROTTLE_ACHLOOKUP_TIP"] = "非凡成就視窗會在啟動時尋找一些資料。停用這個選項時，只有第一次載入介面時會執行收集資料的動作。啟用時，會在玩家進入遊戲後陸續收集資料。|n|n啟用這個選項的好處是可以加快介面載入的時間，但某些玩家或角色有可能會暫時性的影響遊戲效能。";
L["SOUND_BELL_ALLIANCE"] = "提示音效 - 聯盟"
L["SOUND_BELL_AUCTION"] = "拍賣場音效"
L["SOUND_BELL_BOATARRIVED"] = "提示音效 - 船進港時"
L["SOUND_BELL_HORDE"] = "提示音效 - 部落"
L["SOUND_BELL_KARA"] = "卡拉贊音效"
L["SOUND_BELL_MELLOW"] = "柔和的鈴聲"
L["SOUND_BELL_NIGHTELF"] = "提示音效 - 夜精靈"
--Translation missing 
-- L["SOUND_BGTIMER"] = ""
L["SOUND_DING_AUCTION"] = "拍賣場音效"
L["SOUND_DRUMHIT"] = "擊鼓聲"
L["SOUND_ENTERQUEUE"] = "進入佇列"
--Translation missing 
-- L["SOUND_GARRISON_INVASION"] = ""
--Translation missing 
-- L["SOUND_GLYPH_CREATE_MAJOR"] = ""
--Translation missing 
-- L["SOUND_GLYPH_CREATE_MINOR"] = ""
--Translation missing 
-- L["SOUND_GLYPH_DESTROY_MAJOR"] = ""
--Translation missing 
-- L["SOUND_GLYPH_DESTROY_MINOR"] = ""
L["SOUND_GONG_TROLL"] = "銅鑼音效"
L["SOUND_HEARTHBIND"] = "爐石束縛"
L["SOUND_MAP_PING"] = "點擊地圖音效"
--Translation missing 
-- L["SOUND_MEDAL_EXPIRES"] = ""
L["SOUND_SIMON_DING"] = "賽門音效"
L["SOUND_SIMON_STARTGAME"] = "賽門遊戲開始音效"
L["SOUND_SIMON_STARTLEVEL"] = "賽門等級開始音效"
L["SOUND_YAR"] = "Yarrrr音效"
L["STARTTOAST_EVENT"] = "今日正在舉行"
--Translation missing 
-- L["WILDPET"] = ""
L["YOURPROGRESS"] = "你的進度"


elseif (locale == "zhCN") then  -- Simplified Chinese
-- Thanks to user Miste(晨光麦) at wowinterface.com and yeah-chen and chrisccc at curse.com for many of these translations:
L["ACH_ANGLER_COMPLETE"] = "已钓过"
--Translation missing 
-- L["ACH_ANGLER_COUNT"] = ""
L["ACH_ANGLER_INCOMPLETE"] = "未钓过"
L["ACH_BUNNYMAKER_COMPLETE"] = "已使用过春季花束"
L["ACH_BUNNYMAKER_INCOMPLETE"] = "需要使用春季花束"
L["ACH_CHECKYOURHEAD_COMPLETE"] = "已使用过沉重的南瓜灯"
L["ACH_CHECKYOURHEAD_INCOMPLETE"] = "需要使用沉重的南瓜灯"
L["ACH_CONSUME_91_COMPLETE"] = "已经获得1000%的满足感"
L["ACH_CONSUME_91_INCOMPLETE"] = "一次吃掉91块曲奇！"
L["ACH_CONSUME_COMPLETE"] = "已使用过"
L["ACH_CONSUME_INCOMPLETE"] = "需要使用"
L["ACH_CONSUME_INCOMPLETE_EXTRA"] = "未使用过"
L["ACH_FISHSCHOOL_FORMAT"] = "群"
L["ACH_FISTFULOFLOVE_COMPLETE"] = "已使用过一堆玫瑰花瓣"
L["ACH_FISTFULOFLOVE_INCOMPLETE"] = "需要使用一堆玫瑰花瓣"
L["ACH_LETITSNOW_COMPLETE"] = "已使用过一捧雪花"
L["ACH_LETITSNOW_INCOMPLETE"] = "需要使用一捧雪花"
L["ACH_LOVECRITTERS_COMPLETE"] = "已 /爱 过"
L["ACH_LOVECRITTERS_INCOMPLETE"] = "需要 /爱"
L["ACH_TURKEYLURKEY_COMPLETE"] = "已使用过火鸡枪"
L["ACH_TURKEYLURKEY_INCOMPLETE"] = "需要使用火鸡枪"
L["ACH_WELLREAD_COMPLETE"] = "已读过"
L["ACH_WELLREAD_INCOMPLETE"] = "未读过"
L["BINDING_NAME_OVERACHIEVER_TAB_SEARCH"] = "打开搜索标签"
L["BINDING_NAME_OVERACHIEVER_TAB_SUGGESTIONS"] = "打开建议标签"
L["BINDING_NAME_OVERACHIEVER_TAB_WATCH"] = "打开监视标签"
L["COMPLETEDATE"] = "完成于 %3$d-%2$02d-%1$02d"
L["CRITTER"] = "小动物"
L["HOLIDAY_BREWFEST"] = "美酒节"
L["HOLIDAY_CHILDRENSWEEK"] = "儿童周"
L["HOLIDAY_DARKMOONFAIRE"] = "暗月马戏团"
L["HOLIDAY_DAYOFTHEDEAD"] = "悼念日"
L["HOLIDAY_HALLOWSEND"] = "万圣节"
L["HOLIDAY_LOVEISINTHEAIR"] = "情人节"
L["HOLIDAY_LUNARFESTIVAL"] = "春节"
L["HOLIDAY_MIDSUMMER"] = "仲夏火焰节"
L["HOLIDAY_MIDSUMMER_SHORT"] = "仲夏"
L["HOLIDAY_NOBLEGARDEN"] = "复活节"
L["HOLIDAY_PIGRIMSBOUNTY"] = "感恩节"
L["HOLIDAY_PIRATESDAY"] = "海盗节"
L["HOLIDAY_WINTERVEIL"] = "冬幕节盛会"
L["HOLIDAY_WINTERVEIL_SHORT"] = "冬幕节"
L["INCOMPLETE"] = "未完成"
L["KILL_COMPLETE"] = "已经击杀"
L["KILL_INCOMPLETE"] = "需要击杀"
L["MSG_ACHNOTFOUND"] = "找不到该成就。"
L["MSG_CRITERIAPROGRESS"] = "|cff7eff00成就进度:|r %s (%s)"
L["MSG_INVALIDID"] = "无效输入：没有此成就ID。"
L["MSG_NAMENOTFOUND"] = "找不到含有 \"|cffffffff%s|r\" 的成就。"
L["MSG_NUMFOUNDLIST"] = "另外找到%s项成就："
L["MSG_ONEFOUND"] = "找到1项成就："
L["MSG_OPENINGTO"] = "开启："
L["MULTI_NEED"] = "%s (还需要 %s 成就)"
L["OPT_ACHUNKNOWN"] = "<未知>"
L["OPT_ANGLERTIPS"] = "提示渔点是否钓过"
L["OPT_ANGLERTIPS_TIP"] = "提示渔点是否钓过。"
--Translation missing 
-- L["OPT_ANGLERTIPS_TIP_ALWAYS"] = ""
L["OPT_AUTOTRACK_CRITERIATOAST"] = "自动追踪奖杯的\"成就进度\""
L["OPT_AUTOTRACK_CRITERIATOAST_TIP"] = "当奖杯的\"成就进度\"出现时，自动追踪该成就(假如允许追踪的话)."
L["OPT_AUTOTRACKEXPLORE"] = "自动追踪探索成就"
L["OPT_AUTOTRACKEXPLORE_COMPLETED"] = "包括已完成的成就"
L["OPT_AUTOTRACKEXPLORE_TIP"] = "转换地图时自动追踪该区域探索成就。"
L["OPT_AUTOTRACKTIMED"] = "自动追踪计时成就"
L["OPT_AUTOTRACKTIMED_BG"] = "自动追踪战场成就"
L["OPT_AUTOTRACKTIMED_TIP"] = "自动在计时成就开始时显示时限。"
L["OPT_AUTOTRACKTIMED_TIP_BG"] = "当战场开始时，自动追踪成就完成所需的时间(如果它还没被完成的话)。|n|n该成就追踪会在离开战场后停止。"
L["OPT_BUNNYMAKERTIPS"] = "提示是否需要使用春季花束"
L["OPT_BUNNYMAKERTIPS_TIP"] = "提示是否需要使用春季花束。"
L["OPT_CHECKYOURHEADTIPS"] = "提示是否需要使用沉重的南瓜灯"
L["OPT_CHECKYOURHEADTIPS_TIP"] = "提示是否需要使用沉重的南瓜灯。"
L["OPT_CONSUMEITEMTIPS"] = "提示食物是否吃过"
L["OPT_CONSUMEITEMTIPS_TIP"] = "增加食物提示说明。"
L["OPT_CONSUMEITEMTIPS_TIP2"] = "如果你的等级不足以食用这个食物时，将不做提示。"
L["OPT_CONSUMEITEMTIPS_WHENCOMPLETE"] = "完成后继续提示"
L["OPT_CRITERIATOAST_CHATLOG"] = "添加到聊天记录"
L["OPT_CRITERIATOAST_CHATLOG_TIP"] = "当\"成就进度\"的奖杯出现时，链接到成就和显示完成方式在聊天记录中。"
L["OPT_CRITERIATOAST_SUGGEST"] = "添加到最近的提醒 (建议)"
L["OPT_CRITERIATOAST_SUGGEST_TIP"] = "当\"成就进度\"的奖杯出现时， 临时添加成就的建议标签作为一个\"最近的提醒\"。"
L["OPT_CRITTERTIPS"] = "提示小动物是否被 /爱 过"
L["OPT_CRITTERTIPS_TIP"] = "增加小动物提示说明。"
L["OPT_DRAGGABLE"] = "解锁"
L["OPT_DRAGSAVE"] = "记住位置"
L["OPT_FISTFULOFLOVETIPS"] = "提示是否需要使用一堆玫瑰花瓣"
L["OPT_FISTFULOFLOVETIPS_TIP"] = "提示是否需要使用一堆玫瑰花瓣。"
L["OPT_KILLCREATURETIPS"] = "新增需要杀死的怪物"
L["OPT_KILLCREATURETIPS_TIP"] = "新增需要杀死的怪物提示（不包括小动物）。"
L["OPT_KILLCREATURETIPS_TIP2"] = "Note: At startup (or when this is option is enabled), every achievement is scanned to find unit IDs. Not all achievements provide such IDs. Most do, but the tooltips of creatures which are the criteria of those that don't won't be altered by this option."
L["OPT_LABEL_ACHFIVE"] = "\"%s,\" \"%s,\"|n\"%s,\" \"%s\"|n\"%s\""
L["OPT_LABEL_ACHFOUR"] = "\"%s\"、\"%s\"、|n\"%s\"、\"%s\""
L["OPT_LABEL_ACHSEVEN"] = "\"%s,\" \"%s,\"|n\"%s,\" \"%s\"|n\"%s,\" \"%s,\" \"%s\""
L["OPT_LABEL_ACHSIX"] = "\"%s,\" \"%s,\"|n\"%s,\" \"%s\"|n\"%s,\" \"%s\""
L["OPT_LABEL_ACHTHREE"] = "\"%s\"、\"%s\"和|n\"%s\""
L["OPT_LABEL_ACHTWO"] = "\"%s\"和\"%s\""
L["OPT_LABEL_CRITERIATOAST"] = "进度反馈 (非跟踪)"
L["OPT_LABEL_DRAENORANGLER"] = "\"%s\" 子成就"
L["OPT_LABEL_MAINUI"] = "主成就界面修改"
L["OPT_LABEL_NEEDTOKILL"] = "击杀怪物成就（\"%s\"、\"%s\"及其它）"
L["OPT_LABEL_SEASONALACHS"] = "节日成就"
L["OPT_LABEL_STARTTOAST"] = "节日/事件庆典"
L["OPT_LABEL_TOOLTIPS"] = "成就提示和链接"
L["OPT_LABEL_TRACKING"] = "成就追踪"
L["OPT_LABEL_TRADESKILLUI"] = "专业技能窗口修改"
L["OPT_LETITSNOWTIPS"] = "提示是否需要使用一捧雪花"
L["OPT_LETITSNOWTIPS_TIP"] = "提示是否需要使用一捧雪花。"
L["OPT_PESTCONTROLTIPS"] = "提示是否需要击杀害虫"
L["OPT_PESTCONTROLTIPS_TIP"] = "提示是否需要击杀害虫。"
L["OPT_SATISFIEDTIPS"] = "提示是否需要吃曲奇"
L["OPT_SATISFIEDTIPS_TIP"] = "提示是否需要连续吃91块曲奇。"
L["OPT_SELECTSOUND"] = "未完成成就提示音效"
L["OPT_SELECTSOUND_ANGLERCHECKPOLE"] = "装备鱼竿时不提示钓鱼成就"
L["OPT_SELECTSOUND_ANGLERCHECKPOLE_TIP"] = "装备鱼竿时不声音提示钓鱼成就。"
L["OPT_SELECTSOUND_CHECKCOMBAT"] = "额外击杀提示， 假如在与生物战斗中"
L["OPT_SELECTSOUND_CHECKCOMBAT_TIP"] = "不要在战斗中击杀特定的怪物时播放提醒声音。"
L["OPT_SELECTSOUND_TIP"] = "在发现一个需要完成的成就时播放提示音。"
L["OPT_SELECTSOUND_TIP2"] = "每15秒此音效只会出现一次。"
L["OPT_SHOWID"] = "显示成就ID"
L["OPT_SHOWPROGRESS"] = "显示进度"
L["OPT_SHOWPROGRESS_OTHER"] = "与其他人的进度链接进行比较"
L["OPT_SHOWPROGRESS_OTHER_TIP"] = "在別人的成就链接说明中显示自己的进度。"
L["OPT_SHOWPROGRESS_TIP"] = "在提示说明中显示成就进度。"
L["OPT_STARTTOAST_BONUS"] = "显示今日奖励事件"
--Translation missing 
-- L["OPT_STARTTOAST_BONUS_TIP"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_DUNGEON"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_DUNGEON_TIP"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_HOLIDAY"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_HOLIDAY_TIP"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_MICROHOLIDAY"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_MICROHOLIDAY_TIP"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_ONLYCLICKFADE"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_ONLYCLICKFADE_TIP"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_TIMEFADE"] = ""
--Translation missing 
-- L["OPT_STARTTOAST_TIMEFADE_TIP"] = ""
L["OPT_TRADESKILL_SHOWCOMPLETEDACH_COOKING"] = "已完成的烹饪成就仍然提示"
L["OPT_TRADESKILL_SHOWCOMPLETEDACH_COOKING_TIP"] = "即使烹饪成就已完成，仍然在技能旁显示提示图标。"
L["OPT_TURKEYLURKEYTIPS"] = "提示是否需要使用火鸡枪"
L["OPT_TURKEYLURKEYTIPS_TIP"] = "提示是否需要使用火鸡枪。"
L["OPT_UI_HOLIDAYNOTICE"] = "如果节日事件是进行中的则显示通知"
L["OPT_UI_HOLIDAYNOTICE_SUGGESTIONSTABONLY"] = "只限于tab建议"
--Translation missing 
-- L["OPT_UI_HOLIDAYNOTICE_TIP"] = ""
L["OPT_UI_HOLIDAYNOTICE_TIP2"] = "|cffffffffTab建议是必须的tab模块.|r"
L["OPT_UI_PROGRESSIFOTHERCOMPLETED"] = "数量进度会显示在鼠标提示上，假如完成另一个"
--Translation missing 
-- L["OPT_UI_PROGRESSIFOTHERCOMPLETED_TIP"] = ""
L["OPT_UI_REQUIREDFORMETATIP"] = "提示成就树"
L["OPT_UI_REQUIREDFORMETATIP_TIP"] = "当鼠标滑过一个需要先决条件的成就时，显示成就树的名称。"
L["OPT_UI_SERIESTIP"] = "提示系列成就"
L["OPT_UI_SERIESTIP_TIP"] = "当鼠标滑过一个系列成就时，显示系列中其他成就的名字和与当前成就的关系。"
L["OPT_WELLREADTIPS"] = "提示书本是否读过"
L["OPT_WELLREADTIPS_TIP"] = "增加书本提示说明。"
L["OPTPANEL_REMINDERTOOLTIPS"] = "工具提示"
L["OVERACHIEVER_INSTALLED_MSG"] = "|cff7eff00Overachiever|r v%s 已安装."
L["OVERACHIEVER_INSTALLED_TOAST"] = "OVERACHIEVER 已安装!"
L["OVERACHIEVER_UPDATED_MSG"] = "|cff7eff00Overachiever|r 需要更新到 v%s."
L["OVERACHIEVER_UPDATED_TOAST"] = "OVERACHIEVER 更新完毕!"
L["PROGRESS"] = "进度"
L["PROGRESSIFOTHERCOMPLETED"] = "%s的进度:"
L["RECENTREMINDERCRITERIA"] = "最近发现的目标:"
L["REQUIREDFORMETATIP"] = "需要："
L["SERIESTIP"] = "系列成就："
L["SOUND_AGGRO_PULLED"] = "激活注意"
L["SOUND_AGGRO_WARNING"] = "激活警告"
L["SOUND_ALARM1"] = "闹铃声1"
L["SOUND_ALARM2"] = "闹铃声2"
L["SOUND_ALARM3"] = "闹铃声3"
L["SOUND_BELL_ALLIANCE"] = "钟声 - 联盟"
L["SOUND_BELL_AUCTION"] = "铃声 - 拍卖行"
L["SOUND_BELL_BOATARRIVED"] = "钟声 - 船只到港"
L["SOUND_BELL_HORDE"] = "钟声 - 部落"
L["SOUND_BELL_KARA"] = "钟声 - 卡拉赞"
L["SOUND_BELL_MELLOW"] = "圆润的钟声"
L["SOUND_BELL_NIGHTELF"] = "钟声 - 暗夜精灵"
L["SOUND_BGTIMER"] = "战场计时器"
L["SOUND_DING_AUCTION"] = "拍卖行 - 叮"
L["SOUND_DRUMHIT"] = "击鼓声"
L["SOUND_ENTERQUEUE"] = "进入队列声"
L["SOUND_GARRISON_INVASION"] = "要塞入侵警报"
L["SOUND_GLYPH_CREATE_MAJOR"] = "大雕文创建"
L["SOUND_GLYPH_CREATE_MINOR"] = "小雕文创建"
L["SOUND_GLYPH_DESTROY_MAJOR"] = "大雕文摧毁"
L["SOUND_GLYPH_DESTROY_MINOR"] = "小雕文摧毁"
L["SOUND_GONG_TROLL"] = "锣声 - 巨魔"
L["SOUND_HEARTHBIND"] = "炉石绑定声"
L["SOUND_MAP_PING"] = "小地图信号声"
L["SOUND_MEDAL_EXPIRES"] = "奖牌到期"
L["SOUND_SIMON_DING"] = "叮（奥格瑞拉小游戏）"
L["SOUND_SIMON_STARTGAME"] = "游戏开始（奥格瑞拉小游戏）"
L["SOUND_SIMON_STARTLEVEL"] = "升级（奥格瑞拉小游戏）"
L["SOUND_YAR"] = "啊啊啊啊啊……"
L["STARTTOAST_EVENT"] = "今日所发生的事情"
L["WILDPET"] = "小动物"
L["YOURPROGRESS"] = "你的进度"

end

BINDING_HEADER_OVERACHIEVER = L.THIS_TITLE;
BINDING_NAME_OVERACHIEVER_TAB_SEARCH = L.BINDING_NAME_OVERACHIEVER_TAB_SEARCH;
BINDING_NAME_OVERACHIEVER_TAB_SUGGESTIONS = L.BINDING_NAME_OVERACHIEVER_TAB_SUGGESTIONS;
BINDING_NAME_OVERACHIEVER_TAB_WATCH = L.BINDING_NAME_OVERACHIEVER_TAB_WATCH;
