local me,ns=...
local lang=GetLocale()
local l=LibStub("AceLocale-3.0")
local L=l:NewLocale(me,"enUS",true,true)
L["%1$d%% lower than %2$d%%. Lower %s"] = true
L["%s for a wowhead link popup"] = true
L["%s start the mission without even opening the mission page. No question asked"] = true
L["%s starts missions"] = true
L["%s to actually start mission"] = true
L["%s to blacklist"] = true
L["%s to remove from blacklist"] = true
L[ [=[%s, please review the tutorial
(Click the icon to dismiss this message and start the tutorial)]=] ] = true
L["%s, please review the tutorial\\n(Click the icon to dismiss this message)"] = true
L["Allow to start a mission directly from the mission list page (no single mission page shown)"] = true
L["Always counter increased resource cost"] = true
L["Always counter increased time"] = true
L["Always counter kill troops (ignored if we can only use troops with just 1 durability left)"] = true
L["Always counter no bonus loot threat"] = true
L["Artifact shown value is the base value without considering knowledge multiplier"] = true
L["Attempting %s"] = true
L["Base Chance"] = true
L["Better parties available in next future"] = true
L["Blacklisted"] = true
L["Blacklisted missions are ignored in Mission Control"] = true
L["Bonus Chance"] = true
L["Building Final report"] = true
L["but using troops with just one durability left"] = true
L["Capped %1$s. Spend at least %2$d of them"] = true
L["Changes the sort order of missions in Mission panel"] = true
L["Combat ally is proposed for missions so you can consider unassigning him"] = true
L["Complete all missions without confirmation"] = true
L["Configuration for mission party builder"] = true
L["Cost reduced"] = true
L["Could not fulfill mission, aborting"] = true
L["Counter kill Troops"] = true
L["Customization options (non mission related)"] = true
L["Disables warning: "] = true
L["Dont use this slot"] = true
L["Don't use troops"] = true
L["Duration reduced"] = true
L["Duration Time"] = true
L["Elite: Prefer overcap"] = true
L["Elites mission mode"] = true
L["Empty missions sorted as last"] = true
L["Empty or 0% success mission are sorted as last. Does not apply to \"original\" method"] = true
L["Equipped by following champions:"] = true
L["Expiration Time"] = true
L["Favours leveling follower for xp missions"] = true
L["For elite missions, tries hard to not go under 100% even at cost of overcapping"] = true
L["General"] = true
L["Global approx. xp reward"] = true
L["Global approx. xp reward per hour"] = true
L["HallComander Quick Mission Completion"] = true
L["If %1$s is lower than this, then we try to achieve at least %2$s without going over 100%%. Ignored for elite missions."] = true
L["If not checked, inactive followers are used as last chance"] = true
L[ [=[If you %s, you will lose them
Click on %s to abort]=] ] = true
L["Ignore busy followers"] = true
L["Ignore inactive followers"] = true
L["Keep cost low"] = true
L["Keep extra bonus"] = true
L["Keep time short"] = true
L["Keep time VERY short"] = true
L[ [=[Launch the first filled mission with at least one locked follower.
Keep %s pressed to actually launch, a simple click will only print mission name with its followers list]=] ] = true
L[ [=[Launch the first filled mission with at least one locked follower.
Keep SHIFT pressed to actually launch, a simple click will only print mission name with its followers list]=] ] = true
L["Level"] = true
L["Lock all"] = true
L["Lock this follower"] = true
L["Locked follower are only used in this mission"] = true
L["Make Order Hall Mission Panel movable"] = true
L["Makes sure that no troops will be killed"] = true
L["Max champions"] = true
L["Maximize xp gain"] = true
L["Mission duration reduced"] = true
L["Mission was capped due to total chance less than"] = true
L["Missions"] = true
L["Never kill Troops"] = true
L["No follower gained xp"] = true
L["No suitable missions. Have you reserved at least one follower?"] = true
L["Not blacklisted"] = true
L["Nothing to report"] = true
L["Notifies you when you have troops ready to be collected"] = true
L["Only accept missions with time improved"] = true
L["Only consider elite missions"] = true
L["Only need %s instead of %s to start a mission from mission list"] = true
L["Only use champions even if troops are available"] = true
L["Open configuration"] = true
L[ [=[OrderHallCommander overrides GarrisonCommander for Order Hall Management.
 You can revert to GarrisonCommander simply disabling OrderhallCommander.
If instead you like OrderHallCommander remember to add it to Curse client and keep it updated]=] ] = true
L["Original method"] = true
L["Position is not saved on logout"] = true
L["Prefer high durability"] = true
L["Quick start first mission"] = true
L["Remove no champions warning"] = true
L["Restart tutorial from beginning"] = true
L["Resume tutorial"] = true
L["Resurrect troops effect"] = true
L["Reward type"] = true
L["Sets all switches to a very permissive setup. Very similar to 1.4.4"] = true
L["Show tutorial"] = true
L["Show/hide OrderHallCommander mission menu"] = true
L["Sort missions by:"] = true
L["Started with "] = true
L["Success Chance"] = true
L["Troop ready alert"] = true
L["Unable to fill missions, raise \"%s\""] = true
L["Unable to fill missions. Check your switches"] = true
L["Unable to start mission, aborting"] = true
L["Unlock all"] = true
L["Unlock this follower"] = true
L["Unlocks all follower and slots at once"] = true
L["Unsafe mission start"] = true
L["Upgrading to |cff00ff00%d|r"] = true
L["URL Copy"] = true
L["Use at most this many champions"] = true
L["Use combat ally"] = true
L["Use this slot"] = true
L["Uses troops with the highest durability instead of the ones with the lowest"] = true
L["When no free followers are available shows empty follower"] = true
L["When we cant achieve the requested %1$s, we try to reach at least this one without (if possible) going over 100%%"] = true
L["Would start with "] = true
L["You are wasting |cffff0000%d|cffffd200 point(s)!!!"] = true
L[ [=[You need to close and restart World of Warcraft in order to update this version of OrderHallCommander.
Simply reloading UI is not enough]=] ] = true
L["You now need to press both %s and %s to start mission"] = true

-- Tutorial
L[ [=[%1$s and %2$s switches work together to customize how you want your mission filled

The value you set for %1$s (right now %3$s%%) is the minimum acceptable chance for attempting to achieve bonus while the value to set for %2$s (right now %4$s%%) is the chance you want achieve when you are forfaiting bonus (due to not enough powerful followers)]=] ] = true
L[ [=[A requested window is not open
Tutorial will resume as soon as possible]=] ] = true
L[ [=[Clicking a party button will assign its followers to the current mission.
Use it to verify OHC calculated chance with Blizzard one.
If they differs please take a screenshot and open a ticket :).]=] ] = true
L[ [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, drag and drop from bags raise an error.
if you drag and drop an item from a bag, you receive an error.
In order to assign equipments which are not listed (I update the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=] ] = true
L[ [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, if you drag and drop an item from a bag, you receive an error.
In order to assign equipment which are not listed (I updated the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=] ] = true
L[ [=[For example, let's say a mission can reach 95%%, 130%% and 180%% success chance.
If %1$s is set to 170%%, the 180%% one will be choosen.
If %1$s is set to 200%% OHC will try to find the nearest to 100%% respecting %2$s setting
If for example %2$s is set to 100%%, then the 130%% one will be choosen, but if %2$s is set to 90%% then the 95%% one will be choosen]=] ] = true
L["If instead you just want to always see the best available mission just set %1$s to 100%% and %2$s to 0%%"] = true
L[ [=[If you dont understand why OHC choosed a setup for a mission, you can request a full analysis.
Analyze party will show all the possible combinations and how OHC evaluated them]=] ] = true
L["Prefer high durability"] = true
L["Restart the tutorial"] = true
L[ [=[Slots (non the follower in it but just the slot) can be banned.
When you ban a slot, that slot will not be filled for that mission.
Exploiting the fact that troops are always in the leftmost slot(s) you can achieve a nice degree of custom tailoring, reducing the overall number of followers used for a mission]=] ] = true
L["Terminate the tutorial. You can resume it anytime clicking on the info icon in the side menu"] = true
L["Thank you for reading this, enjoy %s"] = true
L["There are %d tutorial step you didnt read"] = true
L[ [=[Usually OrderHallCOmmander tries to use troops with the lowest durability in order to let you enque new troops request as soon as possible.
Checking %1$s reverse it and OrderHallCOmmander will choose for each mission troops with the highest possible durability]=] ] = true
L[ [=[Welcome to a new release of OrderHallCommander
Please follow this short tutorial to discover all new functionalities.
You will not regret it]=] ] = true
L[ [=[With %1$s you ask to always counter the Hazard kill troop.
This means that OHC will try to counter it OR use a troop with just one durability left.
The target for this switch is to avoid wasting durability point, NOT to avoid troops' death.]=] ] = true
L[ [=[With %2$s you ask to never let a troop die.
This not only implies %1$s and %3$s, but force OHC to never send to mission a troop which will die.
The target for this switch is to totally avoid killing troops, even it for this we cant fill the party]=] ] = true
L[ [=[You can blacklist missions right clicking mission button.
Since 1.5.1 you can start a mission witout passing from mission page shift-clicking the mission button.
Be sure you liked the party because no confirmation is asked]=] ] = true
L["You can choose not to use a troop type clicking its icon"] = true
L[ [=[You can choose to limit how much champions are sent together.
Right now OHC is not using more than %3$s champions in the same mission-

Note that %2$s overrides it.]=] ] = true

L=l:NewLocale(me,"zhCN")
if (L) then
L["%1$d%% lower than %2$d%%. Lower %s"] = "%1$d%%低于%2$d%%，降低%s"
--Translation missing 
L["%s for a wowhead link popup"] = "%s for a wowhead link popup"
L["%s start the mission without even opening the mission page. No question asked"] = "Shift-点击可以不打开任务页面就启动任务。没有问题"
--Translation missing 
L["%s starts missions"] = "%s starts missions"
--Translation missing 
L["%s to actually start mission"] = "%s to actually start mission"
L["%s to blacklist"] = "点击右键加入黑名单"
L["%s to remove from blacklist"] = "点击右键从黑名单中删除"
--Translation missing 
L[ [=[%s, please review the tutorial
(Click the icon to dismiss this message and start the tutorial)]=] ] = [=[%s, please review the tutorial
(Click the icon to dismiss this message and start the tutorial)]=]
L["%s, please review the tutorial\\n(Click the icon to dismiss this message)"] = "%s，请检查教程\\n（单击图标取消此消息）"
--Translation missing 
L["Allow to start a mission directly from the mission list page (no single mission page shown)"] = "Allow to start a mission directly from the mission list page (no single mission page shown)"
L["Always counter increased resource cost"] = "总是反制增加资源花费"
L["Always counter increased time"] = "总是反制增加任务时间"
L["Always counter kill troops (ignored if we can only use troops with just 1 durability left)"] = "总是反制杀死部队(如果我们用只剩一次耐久的部队则忽略)"
L["Always counter no bonus loot threat"] = "总是反制没有额外奖励的威胁"
L["Artifact shown value is the base value without considering knowledge multiplier"] = "神器显示的值是基础值，没有经过神器知识的加成"
L["Attempting %s"] = "尝试%s"
L["Base Chance"] = "基础机率"
L["Better parties available in next future"] = "在将来有更好的队伍"
L["Blacklisted"] = "加入黑名单"
L["Blacklisted missions are ignored in Mission Control"] = "加入黑名单的任务将会在任务面板被忽略"
L["Bonus Chance"] = "额外奖励机率"
L["Building Final report"] = "构建最终报告"
L["but using troops with just one durability left"] = "使用只有一个生命值的部队"
L["Capped %1$s. Spend at least %2$d of them"] = "%1$s封顶了。花费至少%2$d在它身上"
L["Changes the sort order of missions in Mission panel"] = "改变任务面板上的任务排列顺序"
L["Combat ally is proposed for missions so you can consider unassigning him"] = "战斗盟友被建议到任务，所以你可以考虑取消指派他"
L["Complete all missions without confirmation"] = "完成所有任务不须确认"
L["Configuration for mission party builder"] = "任务队伍构建设置"
L["Cost reduced"] = "已降低花费"
L["Could not fulfill mission, aborting"] = "任务无法执行被忽略"
L["Counter kill Troops"] = "反制危害（致命）防止部队阵亡"
--Translation missing 
L["Customization options (non mission related)"] = "Customization options (non mission related)"
L["Disables warning: "] = "停用警告："
L["Dont use this slot"] = "不要使用这个空位"
L["Don't use troops"] = "不要使用部队"
L["Duration reduced"] = "持续时间已缩短"
L["Duration Time"] = "持续时间"
--Translation missing 
L["Elite: Prefer overcap"] = "Elite: Prefer overcap"
L["Elites mission mode"] = "精英任务模式"
L["Empty missions sorted as last"] = "空的任务排在最后"
L["Empty or 0% success mission are sorted as last. Does not apply to \"original\" method"] = "空或者0%成功率的任务排在最后，对于\\\"原始\\\"方式排序无效。"
--Translation missing 
L["Equipped by following champions:"] = "Equipped by following champions:"
L["Expiration Time"] = "到期时间"
L["Favours leveling follower for xp missions"] = "倾向于使用升级中追隨者在经验值任务"
--Translation missing 
L["For elite missions, tries hard to not go under 100% even at cost of overcapping"] = "For elite missions, tries hard to not go under 100% even at cost of overcapping"
L["General"] = "一般"
L["Global approx. xp reward"] = "整体大约经验值奖励"
L["Global approx. xp reward per hour"] = "每小时获得的整体经验值奖励"
L["HallComander Quick Mission Completion"] = "大厅指挥官快速任务完成"
L["If %1$s is lower than this, then we try to achieve at least %2$s without going over 100%%. Ignored for elite missions."] = "如果 %1$s 低于此值，那么我们至少尝试达到 %2$s 而不超过100%%。 忽略精英任务。"
L["If not checked, inactive followers are used as last chance"] = "不勾选时，未激活的追随者会成为最后的考虑"
L[ [=[If you %s, you will lose them
Click on %s to abort]=] ] = [=[如果你继续，你会失去它们
点击%s來取消]=]
L["Ignore busy followers"] = "忽略任务中的追随者"
L["Ignore inactive followers"] = "忽略未激活的追随者"
L["Keep cost low"] = "节省大厅资源"
L["Keep extra bonus"] = "优先额外奖励"
L["Keep time short"] = "减少任务时间"
L["Keep time VERY short"] = "最短任务时间"
--Translation missing 
L[ [=[Launch the first filled mission with at least one locked follower.
Keep %s pressed to actually launch, a simple click will only print mission name with its followers list]=] ] = [=[Launch the first filled mission with at least one locked follower.
Keep %s pressed to actually launch, a simple click will only print mission name with its followers list]=]
--Translation missing 
L[ [=[Launch the first filled mission with at least one locked follower.
Keep SHIFT pressed to actually launch, a simple click will only print mission name with its followers list]=] ] = [=[Launch the first filled mission with at least one locked follower.
Keep SHIFT pressed to actually launch, a simple click will only print mission name with its followers list]=]
L["Level"] = "等级"
L["Lock all"] = "全部锁定"
L["Lock this follower"] = "锁定此追随者"
L["Locked follower are only used in this mission"] = "锁定只用于此任务的追随者"
L["Make Order Hall Mission Panel movable"] = "让大厅任务面板可移动"
L["Makes sure that no troops will be killed"] = "确保没有部队会阵亡"
L["Max champions"] = "最多的勇士数量"
L["Maximize xp gain"] = "获取最多的经验"
L["Mission duration reduced"] = "任务执行时间已缩短"
L["Mission was capped due to total chance less than"] = "任务限制由于总的几率少于"
L["Missions"] = "任务"
L["Never kill Troops"] = "确保部队绝不阵亡"
L["No follower gained xp"] = "没有追随者获得经验"
L["No suitable missions. Have you reserved at least one follower?"] = "没有合适的任务。 您是否至少保留了一位追随者？"
L["Not blacklisted"] = "未加入黑名单"
L["Nothing to report"] = "没什么可报告"
L["Notifies you when you have troops ready to be collected"] = "当部队已准备好获取时提醒你"
L["Only accept missions with time improved"] = "只允许有时间改善的任务"
L["Only consider elite missions"] = "只考虑精英任务"
--Translation missing 
L["Only need %s instead of %s to start a mission from mission list"] = "Only need %s instead of %s to start a mission from mission list"
L["Only use champions even if troops are available"] = "有可用的部队时，仍然只使用追随者"
L["Open configuration"] = "打开配置"
--Translation missing 
L[ [=[OrderHallCommander overrides GarrisonCommander for Order Hall Management.
 You can revert to GarrisonCommander simply disabling OrderhallCommander.
If instead you like OrderHallCommander remember to add it to Curse client and keep it updated]=] ] = [=[OrderHallCommander overrides GarrisonCommander for Order Hall Management.
 You can revert to GarrisonCommander simply disabling OrderhallCommander.
If instead you like OrderHallCommander remember to add it to Curse client and keep it updated]=]
L["Original method"] = "原始方法"
L["Position is not saved on logout"] = "位置不会在登出后储存"
L["Prefer high durability"] = "喜欢高生命值"
L["Quick start first mission"] = "快速开始第一个任务"
L["Remove no champions warning"] = "取消没有追随者警告"
--Translation missing 
L["Restart tutorial from beginning"] = "Restart tutorial from beginning"
--Translation missing 
L["Resume tutorial"] = "Resume tutorial"
L["Resurrect troops effect"] = "复活部队效果"
L["Reward type"] = "奖励类型"
--Translation missing 
L["Sets all switches to a very permissive setup. Very similar to 1.4.4"] = "Sets all switches to a very permissive setup. Very similar to 1.4.4"
L["Show tutorial"] = "显示教程"
L["Show/hide OrderHallCommander mission menu"] = "显示/隐藏大厅指挥官任务选单"
L["Sort missions by:"] = "排列任务根据："
L["Started with "] = "开始"
L["Success Chance"] = "成功机率"
L["Troop ready alert"] = "部队装备提醒"
L["Unable to fill missions, raise \"%s\""] = "无法指派任务，请提升 \\\"%s\\"
L["Unable to fill missions. Check your switches"] = "无法指派任务，请检查您的设定选项"
L["Unable to start mission, aborting"] = "无法开始任务，中止"
L["Unlock all"] = "全部解除锁定"
L["Unlock this follower"] = "解锁此追随者"
L["Unlocks all follower and slots at once"] = "一次性解锁所有追随者和空位"
--Translation missing 
L["Unsafe mission start"] = "Unsafe mission start"
L["Upgrading to |cff00ff00%d|r"] = "升级到|cff00ff00%d|r"
L["URL Copy"] = "复制网址"
L["Use at most this many champions"] = "最多使用不超过这个数量的勇士"
L["Use combat ally"] = "使用战斗盟友"
L["Use this slot"] = "使用这个空位"
L["Uses troops with the highest durability instead of the ones with the lowest"] = "使用最高生命值的部队，而不是最低的部队"
--Translation missing 
L["When no free followers are available shows empty follower"] = "When no free followers are available shows empty follower"
--Translation missing 
L["When we cant achieve the requested %1$s, we try to reach at least this one without (if possible) going over 100%%"] = "When we cant achieve the requested %1$s, we try to reach at least this one without (if possible) going over 100%%"
L["Would start with "] = "将开始"
L["You are wasting |cffff0000%d|cffffd200 point(s)!!!"] = "你浪费了|cffff0000%d|cffffd200 点数!!!"
--Translation missing 
L[ [=[You need to close and restart World of Warcraft in order to update this version of OrderHallCommander.
Simply reloading UI is not enough]=] ] = [=[You need to close and restart World of Warcraft in order to update this version of OrderHallCommander.
Simply reloading UI is not enough]=]
--Translation missing 
L["You now need to press both %s and %s to start mission"] = "You now need to press both %s and %s to start mission"

-- Tutorial
--Translation missing 
L[ [=[%1$s and %2$s switches work together to customize how you want your mission filled

The value you set for %1$s (right now %3$s%%) is the minimum acceptable chance for attempting to achieve bonus while the value to set for %2$s (right now %4$s%%) is the chance you want achieve when you are forfaiting bonus (due to not enough powerful followers)]=] ] = [=[%1$s and %2$s switches work together to customize how you want your mission filled

The value you set for %1$s (right now %3$s%%) is the minimum acceptable chance for attempting to achieve bonus while the value to set for %2$s (right now %4$s%%) is the chance you want achieve when you are forfaiting bonus (due to not enough powerful followers)]=]
--Translation missing 
L[ [=[A requested window is not open
Tutorial will resume as soon as possible]=] ] = [=[A requested window is not open
Tutorial will resume as soon as possible]=]
--Translation missing 
L[ [=[Clicking a party button will assign its followers to the current mission.
Use it to verify OHC calculated chance with Blizzard one.
If they differs please take a screenshot and open a ticket :).]=] ] = [=[Clicking a party button will assign its followers to the current mission.
Use it to verify OHC calculated chance with Blizzard one.
If they differs please take a screenshot and open a ticket :).]=]
--Translation missing 
L[ [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, drag and drop from bags raise an error.
if you drag and drop an item from a bag, you receive an error.
In order to assign equipments which are not listed (I update the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=] ] = [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, drag and drop from bags raise an error.
if you drag and drop an item from a bag, you receive an error.
In order to assign equipments which are not listed (I update the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=]
--Translation missing 
L[ [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, if you drag and drop an item from a bag, you receive an error.
In order to assign equipment which are not listed (I updated the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=] ] = [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, if you drag and drop an item from a bag, you receive an error.
In order to assign equipment which are not listed (I updated the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=]
--Translation missing 
L[ [=[For example, let's say a mission can reach 95%%, 130%% and 180%% success chance.
If %1$s is set to 170%%, the 180%% one will be choosen.
If %1$s is set to 200%% OHC will try to find the nearest to 100%% respecting %2$s setting
If for example %2$s is set to 100%%, then the 130%% one will be choosen, but if %2$s is set to 90%% then the 95%% one will be choosen]=] ] = [=[For example, let's say a mission can reach 95%%, 130%% and 180%% success chance.
If %1$s is set to 170%%, the 180%% one will be choosen.
If %1$s is set to 200%% OHC will try to find the nearest to 100%% respecting %2$s setting
If for example %2$s is set to 100%%, then the 130%% one will be choosen, but if %2$s is set to 90%% then the 95%% one will be choosen]=]
L["If instead you just want to always see the best available mission just set %1$s to 100%% and %2$s to 0%%"] = "相反，如果你只想总是看到最好的可用任务，只需要设置%1$s到100%，%2$s到0%。"
--Translation missing 
L[ [=[If you dont understand why OHC choosed a setup for a mission, you can request a full analysis.
Analyze party will show all the possible combinations and how OHC evaluated them]=] ] = [=[If you dont understand why OHC choosed a setup for a mission, you can request a full analysis.
Analyze party will show all the possible combinations and how OHC evaluated them]=]
--Translation missing 
L["Prefer high durability"] = "Prefer high durability"
L["Restart the tutorial"] = "重新启动教程"
--Translation missing 
L[ [=[Slots (non the follower in it but just the slot) can be banned.
When you ban a slot, that slot will not be filled for that mission.
Exploiting the fact that troops are always in the leftmost slot(s) you can achieve a nice degree of custom tailoring, reducing the overall number of followers used for a mission]=] ] = [=[Slots (non the follower in it but just the slot) can be banned.
When you ban a slot, that slot will not be filled for that mission.
Exploiting the fact that troops are always in the leftmost slot(s) you can achieve a nice degree of custom tailoring, reducing the overall number of followers used for a mission]=]
L["Terminate the tutorial. You can resume it anytime clicking on the info icon in the side menu"] = "终止教程。您可以随时点击侧边菜单的信息图标恢复它"
--Translation missing 
L["Thank you for reading this, enjoy %s"] = "Thank you for reading this, enjoy %s"
--Translation missing 
L["There are %d tutorial step you didnt read"] = "There are %d tutorial step you didnt read"
--Translation missing 
L[ [=[Usually OrderHallCOmmander tries to use troops with the lowest durability in order to let you enque new troops request as soon as possible.
Checking %1$s reverse it and OrderHallCOmmander will choose for each mission troops with the highest possible durability]=] ] = [=[Usually OrderHallCOmmander tries to use troops with the lowest durability in order to let you enque new troops request as soon as possible.
Checking %1$s reverse it and OrderHallCOmmander will choose for each mission troops with the highest possible durability]=]
--Translation missing 
L[ [=[Welcome to a new release of OrderHallCommander
Please follow this short tutorial to discover all new functionalities.
You will not regret it]=] ] = [=[Welcome to a new release of OrderHallCommander
Please follow this short tutorial to discover all new functionalities.
You will not regret it]=]
--Translation missing 
L[ [=[With %1$s you ask to always counter the Hazard kill troop.
This means that OHC will try to counter it OR use a troop with just one durability left.
The target for this switch is to avoid wasting durability point, NOT to avoid troops' death.]=] ] = [=[With %1$s you ask to always counter the Hazard kill troop.
This means that OHC will try to counter it OR use a troop with just one durability left.
The target for this switch is to avoid wasting durability point, NOT to avoid troops' death.]=]
--Translation missing 
L[ [=[With %2$s you ask to never let a troop die.
This not only implies %1$s and %3$s, but force OHC to never send to mission a troop which will die.
The target for this switch is to totally avoid killing troops, even it for this we cant fill the party]=] ] = [=[With %2$s you ask to never let a troop die.
This not only implies %1$s and %3$s, but force OHC to never send to mission a troop which will die.
The target for this switch is to totally avoid killing troops, even it for this we cant fill the party]=]
--Translation missing 
L[ [=[You can blacklist missions right clicking mission button.
Since 1.5.1 you can start a mission witout passing from mission page shift-clicking the mission button.
Be sure you liked the party because no confirmation is asked]=] ] = [=[You can blacklist missions right clicking mission button.
Since 1.5.1 you can start a mission witout passing from mission page shift-clicking the mission button.
Be sure you liked the party because no confirmation is asked]=]
--Translation missing 
L["You can choose not to use a troop type clicking its icon"] = "You can choose not to use a troop type clicking its icon"
--Translation missing 
L[ [=[You can choose to limit how much champions are sent together.
Right now OHC is not using more than %3$s champions in the same mission-

Note that %2$s overrides it.]=] ] = [=[You can choose to limit how much champions are sent together.
Right now OHC is not using more than %3$s champions in the same mission-

Note that %2$s overrides it.]=]

return
end
L=l:NewLocale(me,"zhTW")
if (L) then
L["%1$d%% lower than %2$d%%. Lower %s"] = "%1$d%%低於%2$d%%，降低%s"
L["%s for a wowhead link popup"] = "%s跳出wowhead連結"
L["%s start the mission without even opening the mission page. No question asked"] = "按下 %s 一鍵派出任務。不用打開任務頁面，不做任何詢問。"
L["%s starts missions"] = "按下 %s 派出任務"
L["%s to actually start mission"] = "按下 %s 馬上派出任務"
L["%s to blacklist"] = "%s 加入忽略清單"
L["%s to remove from blacklist"] = "%s 從忽略清單移除"
L[ [=[%s, please review the tutorial
(Click the icon to dismiss this message and start the tutorial)]=] ] = [=[%s，請查看教學說明
(點擊圖示關閉這個訊息並且打開教學說明)]=]
L["%s, please review the tutorial\\n(Click the icon to dismiss this message)"] = "%s，請查看教學說明\\n(點擊圖示這個關閉訊息)"
L["Allow to start a mission directly from the mission list page (no single mission page shown)"] = "允許直接從任務列表頁面啟動任務（不會顯示個別任務頁面）"
L["Always counter increased resource cost"] = "總是反制增加資源花費"
L["Always counter increased time"] = "總是反制增加任務時間"
L["Always counter kill troops (ignored if we can only use troops with just 1 durability left)"] = "總是反制殺死部隊(如果我們用只剩一次耐久的部隊則忽略)"
L["Always counter no bonus loot threat"] = "總是反制沒有額外獎勵的威脅"
L["Artifact shown value is the base value without considering knowledge multiplier"] = "神兵顯示的值是基礎值，沒有經過神兵知識的加成。"
L["Attempting %s"] = "嘗試%s"
L["Base Chance"] = "基礎機率"
L["Better parties available in next future"] = "在將來有更好的隊伍"
L["Blacklisted"] = "已在忽略清單"
L["Blacklisted missions are ignored in Mission Control"] = "任務控制會忽略在忽略清單內的任務"
L["Bonus Chance"] = "額外獎勵機率"
L["Building Final report"] = "建立總結報告"
L["but using troops with just one durability left"] = "但使用只有一個耐久度的部隊"
L["Capped %1$s. Spend at least %2$d of them"] = "%1$s封頂了。花費至少%2$d在它身上"
L["Changes the sort order of missions in Mission panel"] = "改變任務面板上的任務排列順序"
L["Combat ally is proposed for missions so you can consider unassigning him"] = "戰鬥盟友被建議到任務，所以你可以考慮取消指派他"
L["Complete all missions without confirmation"] = "完成所有任務不須確認"
L["Configuration for mission party builder"] = "任務隊伍構建設置"
L["Cost reduced"] = "花費已降低"
L["Could not fulfill mission, aborting"] = "任務無法履行，忽略"
L["Counter kill Troops"] = "反制殺死部隊"
L["Customization options (non mission related)"] = "自定義選項（非任務相關）"
L["Disables warning: "] = "停用警告："
L["Dont use this slot"] = "不要使用這個空槽"
L["Don't use troops"] = "不要使用部隊"
L["Duration reduced"] = "持續時間已縮短"
L["Duration Time"] = "持續時間"
L["Elite: Prefer overcap"] = "精英: 寧願增加花費"
L["Elites mission mode"] = "精英任務模式"
L["Empty missions sorted as last"] = "空的任務排在最後"
L["Empty or 0% success mission are sorted as last. Does not apply to \"original\" method"] = "空的或成功率 0% 的任務排列在最後面。不要套用到  \"原始方法\"。"
L["Equipped by following champions:"] = "已裝備在下列勇士："
L["Expiration Time"] = "到期時間"
L["Favours leveling follower for xp missions"] = "傾向於使用升級中追隨者在經驗值任務"
L["For elite missions, tries hard to not go under 100% even at cost of overcapping"] = "對於精英任務，就算花費會增加，也別讓成功率低於 100%。"
L["General"] = "(G) 一般"
L["Global approx. xp reward"] = "整體大約經驗值獎勵"
L["Global approx. xp reward per hour"] = "每小時獲得整體經驗值獎勵"
L["HallComander Quick Mission Completion"] = "大廳任務快速完成"
L["If %1$s is lower than this, then we try to achieve at least %2$s without going over 100%%. Ignored for elite missions."] = "如果%1$s低於此值，那麼我們嘗試至少達到%2$s而不超過100%%。 忽視精英任務。"
L["If not checked, inactive followers are used as last chance"] = "不勾選時，閒置的追隨者會成為最後的考量。"
L[ [=[If you %s, you will lose them
Click on %s to abort]=] ] = [=[如果您繼續，您會失去它們
點擊%s來取消]=]
L["Ignore busy followers"] = "忽略任務中的追隨者"
L["Ignore inactive followers"] = "忽略閒置的追隨者"
L["Keep cost low"] = "保持低花費"
L["Keep extra bonus"] = "保持額外獎勵"
L["Keep time short"] = "保持短時間"
L["Keep time VERY short"] = "保持非常短的時間"
L[ [=[Launch the first filled mission with at least one locked follower.
Keep %s pressed to actually launch, a simple click will only print mission name with its followers list]=] ] = [=[至少使用一個鎖定的追隨者來出第一個任務。
按住 %s 會實際派出，點一下只會顯示任務名稱和和追隨者清單。]=]
L[ [=[Launch the first filled mission with at least one locked follower.
Keep SHIFT pressed to actually launch, a simple click will only print mission name with its followers list]=] ] = [=[至少使用一個鎖定的追隨者來出第一個任務。
按住 SHIFT 會實際派出，點一下只會顯示任務名稱和和追隨者清單。]=]
L["Level"] = "等級"
L["Lock all"] = "全部鎖定"
L["Lock this follower"] = "鎖定此追隨者"
L["Locked follower are only used in this mission"] = "鎖定只用於此任務的追隨者"
L["Make Order Hall Mission Panel movable"] = "讓大廳任務面板可移動"
L["Makes sure that no troops will be killed"] = "確保沒有部隊會被殺害"
L["Max champions"] = "最多勇士"
L["Maximize xp gain"] = "最大化經驗獲取"
L["Mission duration reduced"] = "任務時間已縮短"
L["Mission was capped due to total chance less than"] = "任務花費提高了，因為總成功率低於"
L["Missions"] = "(M) 任務"
L["Never kill Troops"] = "絕不殺死部隊"
L["No follower gained xp"] = "沒有追隨者獲得經驗"
L["No suitable missions. Have you reserved at least one follower?"] = "沒有合適的任務。 您是否至少保留一位追隨者？"
L["Not blacklisted"] = "不在忽略清單"
L["Nothing to report"] = "沒什麼可報告"
L["Notifies you when you have troops ready to be collected"] = "當部隊已準備好獲取時提醒你"
L["Only accept missions with time improved"] = "只允許有時間改善的任務"
L["Only consider elite missions"] = "只考慮精英任務"
L["Only need %s instead of %s to start a mission from mission list"] = "要從任務清單派出任務，只需要 %s 而不是 %s。"
L["Only use champions even if troops are available"] = "有可用的部隊時，仍然只要使用勇士。"
L["Open configuration"] = "開啟設置選項"
L[ [=[OrderHallCommander overrides GarrisonCommander for Order Hall Management.
 You can revert to GarrisonCommander simply disabling OrderhallCommander.
If instead you like OrderHallCommander remember to add it to Curse client and keep it updated]=] ] = [=[職業大廳指揮官已經取代要塞指揮官來管理職業大廳。
要返回使用要塞指揮官，只要停用職業大廳指揮官插件就可以了。]=]
L["Original method"] = "原始方式"
L["Position is not saved on logout"] = "位置不會在登出後儲存"
L["Prefer high durability"] = "喜好高耐久度"
L["Quick start first mission"] = "快速開始第一個任務"
L["Remove no champions warning"] = "移除缺少勇士警告"
L["Restart tutorial from beginning"] = "從開始的地方重啟指南"
L["Resume tutorial"] = "繼續指南"
L["Resurrect troops effect"] = "復活部隊效果"
L["Reward type"] = "獎勵類型"
L["Sets all switches to a very permissive setup. Very similar to 1.4.4"] = "所有設定都更改為非常寬鬆的設定，和 1.44 版非常相似。"
L["Show tutorial"] = "顯示指南"
L["Show/hide OrderHallCommander mission menu"] = "顯示/隱藏大廳指揮官任務選單"
L["Sort missions by:"] = "任務排序依據："
L["Started with "] = "已經派出 "
L["Success Chance"] = "成功機率"
L["Troop ready alert"] = "部隊整備提醒"
L["Unable to fill missions, raise \"%s\""] = "無法指派任務，請提升 \"%s\""
L["Unable to fill missions. Check your switches"] = "無法分派任務，請檢查你的設定選項。"
L["Unable to start mission, aborting"] = "無法開始任務，中止"
L["Unlock all"] = "全部解除鎖定"
L["Unlock this follower"] = "解鎖此追隨者"
L["Unlocks all follower and slots at once"] = "一次解鎖所有追隨者和空槽"
L["Unsafe mission start"] = "不安全的一鍵派出"
L["Upgrading to |cff00ff00%d|r"] = "升級到|cff00ff00%d|r"
L["URL Copy"] = "複製網址"
L["Use at most this many champions"] = "至少使用這個數量的勇士"
L["Use combat ally"] = "使用戰鬥盟友"
L["Use this slot"] = "使用此空槽"
L["Uses troops with the highest durability instead of the ones with the lowest"] = "使用最高耐久性的部隊，而不是最低的部隊"
L["When no free followers are available shows empty follower"] = "沒有可用的追隨者時，顯示空欄位。"
L["When we cant achieve the requested %1$s, we try to reach at least this one without (if possible) going over 100%%"] = "當我們無法實現請求的%1$s時, 我們嘗試至少達到這一目標, 而不 (如果可能) 超過100%%"
L["Would start with "] = "將會派出 "
L["You are wasting |cffff0000%d|cffffd200 point(s)!!!"] = "你浪費了|cffff0000%d|cffffd200 點數!!!"
L[ [=[You need to close and restart World of Warcraft in order to update this version of OrderHallCommander.
Simply reloading UI is not enough]=] ] = [=[您需要關閉並重新啟動魔獸世界才能更新此版本的OrderHallCommander。
簡單的重新載入UI是不夠的]=]
L["You now need to press both %s and %s to start mission"] = "您現在需要同時按下%s和%s來啟動任務"

-- Tutorial
L[ [=[%1$s and %2$s switches work together to customize how you want your mission filled

The value you set for %1$s (right now %3$s%%) is the minimum acceptable chance for attempting to achieve bonus while the value to set for %2$s (right now %4$s%%) is the chance you want achieve when you are forfaiting bonus (due to not enough powerful followers)]=] ] = [=[%1$s與%2$s一起交換運作以定制你想要任務如何分派

你為 %1$s 設置的值(目前為 %3$s%%)是最低可接受的額外獎勵機率，而為為 %2$s 設置的值(目前為 %4$s%%)是你想要實現的機率，當你是為了爭取獎勵（由於沒有足夠強大的追隨者）]=]
L[ [=[A requested window is not open
Tutorial will resume as soon as possible]=] ] = [=[請求的視窗未打開
指南將盡快恢復]=]
L[ [=[Clicking a party button will assign its followers to the current mission.
Use it to verify OHC calculated chance with Blizzard one.
If they differs please take a screenshot and open a ticket :).]=] ] = [=[點擊一個隊伍按鈕將會將其追隨者分配給當前的任務。
使用它來比較驗證OHC與暴雪計算的機率。
如果他們不同，請拍攝截圖並開啟一個問題回報:)。]=]
L[ [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, drag and drop from bags raise an error.
if you drag and drop an item from a bag, you receive an error.
In order to assign equipments which are not listed (I update the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=] ] = [=[設備和升級在這裡被列為可點擊的按鈕。
由於Blizzard 系統汙染的問題，從包中拖放會導致錯誤。
如果您從包中拖放了一個物品，則會收到錯誤。
為了指定未列出的設備（我經常更新列表，但有時暴雪更快），您可以右鍵單擊包中的物品，然後左鍵單擊跟隨者。
這種方式您不會收到任何錯誤]=]
L[ [=[Equipment and upgrades are listed here as clickable buttons.
Due to an issue with Blizzard Taint system, if you drag and drop an item from a bag, you receive an error.
In order to assign equipment which are not listed (I updated the list often but sometimes Blizzard is faster), you can right click the item in the bag and the left click the follower.
This way you dont receive any error]=] ] = [=[這裡列出的裝備和升級物品是可以點擊的按鈕。
因為暴雪本身的問題，如果從背包將物品拖曳過來會發生錯誤。
為了避免有些裝備不會列出 (我已經很常更新清單了，但有時暴雪的手腳更快)，可以使用右鍵點擊背包內的物品，然後用左鍵點擊追隨者。
使用這種操作方式便不會發生錯誤。]=]
L[ [=[For example, let's say a mission can reach 95%%, 130%% and 180%% success chance.
If %1$s is set to 170%%, the 180%% one will be choosen.
If %1$s is set to 200%% OHC will try to find the nearest to 100%% respecting %2$s setting
If for example %2$s is set to 100%%, then the 130%% one will be choosen, but if %2$s is set to 90%% then the 95%% one will be choosen]=] ] = [=[例如，假設一個任務可以達到95%%，130%%和180%%的成功機會。
如果%1$s設置為170%%，則會選擇180%%。 如果%1$s 被設置為200%% OHC將嘗試找到最接近100%%
至於%2$s設置
假設%2$s設置為100%%，那麼將會選擇130%%，但如果%2$s設置為90%%，那麼將選擇95%%
假設％2$s設置為100%%，那麼將會選擇130%%，但如果％2$s設置為90%%，那麼將選擇95%%]=]
L["If instead you just want to always see the best available mission just set %1$s to 100%% and %2$s to 0%%"] = "如果您只是希望始終看到最佳可用任務，只需將%1$s設置為100%%，將%2$s設置為0%%"
L[ [=[If you dont understand why OHC choosed a setup for a mission, you can request a full analysis.
Analyze party will show all the possible combinations and how OHC evaluated them]=] ] = [=[如果你不明白OHC如何選擇一個任務的設置，你可以要求一個完整的分析。
分析隊伍將顯示所有可能的組合, 以及OHC如何評估他們]=]
L["Prefer high durability"] = "高耐久度優先"
L["Restart the tutorial"] = "重啟指南"
L[ [=[Slots (non the follower in it but just the slot) can be banned.
When you ban a slot, that slot will not be filled for that mission.
Exploiting the fact that troops are always in the leftmost slot(s) you can achieve a nice degree of custom tailoring, reducing the overall number of followers used for a mission]=] ] = [=[可以禁用欄位 (不放入追隨者，只有空的欄位)。
禁用欄位時，任務的這個欄位不會放入追隨者。
利用部隊總是從最左邊開始的原則，可以很方便的達到控制人員的效果，減少任務所需的追隨者數量。]=]
L["Terminate the tutorial. You can resume it anytime clicking on the info icon in the side menu"] = "終止本指南。您可以隨時點擊側面選單中的訊息圖標來恢復"
L["Thank you for reading this, enjoy %s"] = "感謝您的閱讀，享受%s"
L["There are %d tutorial step you didnt read"] = "還有 %d 個教學說明尚未閱讀"
L[ [=[Usually OrderHallCOmmander tries to use troops with the lowest durability in order to let you enque new troops request as soon as possible.
Checking %1$s reverse it and OrderHallCOmmander will choose for each mission troops with the highest possible durability]=] ] = "通常，OrderHallCOmmander嘗試使用最低耐久性的部隊，以便盡快請求新的部隊。 勾選%1$s反向操作，OrderHallCOmmander將為每個任務選擇盡可能高耐久度的部隊"
L[ [=[Welcome to a new release of OrderHallCommander
Please follow this short tutorial to discover all new functionalities.
You will not regret it]=] ] = [=[歡迎使用新版本的職業大廳指揮官
請閱讀這個簡短的教學說明來認識所有新功能。
保證不會後悔!]=]
L[ [=[With %1$s you ask to always counter the Hazard kill troop.
This means that OHC will try to counter it OR use a troop with just one durability left.
The target for this switch is to avoid wasting durability point, NOT to avoid troops' death.]=] ] = "至於%1$s你要求總是反制危險殺死部隊。 這意味著OHC將試圖對付它，或者使用一個只有一個耐久度的部隊。 這種切換的目標是避免浪費耐久度，而不是避免部隊死亡。"
L[ [=[With %2$s you ask to never let a troop die.
This not only implies %1$s and %3$s, but force OHC to never send to mission a troop which will die.
The target for this switch is to totally avoid killing troops, even it for this we cant fill the party]=] ] = [=[至於%2$s你要求不要讓部隊死亡。
這不僅意味著%1$s和%3$s，而且強制OHC永遠不會派一個部隊會死亡的任務。
這個轉變的目標是完全避免殺死部隊，即使這樣我們也不能填補隊伍]=]
L[ [=[You can blacklist missions right clicking mission button.
Since 1.5.1 you can start a mission witout passing from mission page shift-clicking the mission button.
Be sure you liked the party because no confirmation is asked]=] ] = [=[右鍵點擊任務可以加入忽略清單。
從 1.5.1 版開始，使用 Shift-右鍵點擊可以直接派出任務，不用進入任務頁面。
請先確定你喜歡任務的隊伍，因為不會有任何確認和詢問。
]=]
L["You can choose not to use a troop type clicking its icon"] = "您可以單擊其圖標選擇不使用的部隊類型"
L[ [=[You can choose to limit how much champions are sent together.
Right now OHC is not using more than %3$s champions in the same mission-

Note that %2$s overrides it.]=] ] = [=[您可以選擇限制一起分派的勇士數量。 現在OHC沒有在同一個任務中使用超過 %3$s 的勇士 -

請注意，%2$s會覆蓋它。]=]

L["Missions' results"] = "任務結果"
L["and then by:"] = "接著依據："
L["Changes the second sort order of missions in Mission panel"] = "改變任務面板上任務的第二排列順序"
L["Disable blacklisting"] = "停用忽略清單"
L["%s no longer blacklist missions"] = "%s 不會再忽略任務"
L["OrderHallCOmmander additions"] = "職業大廳指揮官提供的額外功能"
L["Maximum chance was"] = "最高的成功率是"

return
end
