local L = LibStub("AceLocale-3.0"):NewLocale("Objective Announcer", "enUS", true)

	-------------------
	-- Configuration --
	-------------------

	-- General --
		-- Announcement Modes --
L["announcemode"] = "Announcement Modes"
L["announcedesc"] = "Set when to send announcements for quests and objectives."
L["annmodesdesc"] = "Select which type of announcements are made.|n|cFF9ffbffCompleted Quests:|r Announce only when quests are finished.|n|cFF9ffbffCompleted Objectives:|r Announce only finished objectives.|n|cFF9ffbffBoth Quests & Objectives:|r Announces finished objectives and when the quest is fully complete.|n|cFF9ffbffObjective Progress:|r Announce each time an objective is advanced.|n|cFF9ffbffProgress & Completed Quests:|r Announce each time an objective is advanced and when the quest is fully completed."
L["annvalues"] = {	"Completed Quests",
					"Completed Objectives",
					"Both Quests & Objectives",
					"Objective Progress",
					"Progress & Comp. Quests" }
L["progressbardesc"] = "When using \"Both Quests & Objectives\" mode and a bonus objective has a progress bar, set how often announcements are sent."
L["progbarinterval"] = "Progress Bar % Interval"
L["progbarintervaldesc"] = "How often to announce your progress bar quests.|n|cFF9ffbffOnly effective with \"Both Quests & Objectives.\" \"Objective Progress\" or \"Progress & Comp. Quests\" announce every time progress advances.|r"

		-- Announcement Channels --
L["annchannels"] = "Announce To"
L["annchannelsdesc"] = "Set who will see your announcements."
L["privateannheader"] = "Private Announcements"
L["Self"] = true
L["selfdesc"] = "Sets whether to announce to yourself when no public announcements have been made.|n|cFF9ffbffChoose where to output your self messages in the Self Output tab above."
L["selfalways"] = "Always Self Announce"
L["selfalwaysdesc"] = "Announce to self even when a public message has been sent."
L["selfcolor"] = "Color for self messages"
L["selfcolordesc"] = "Choose your color."
L["publicheader"] = "Public Announcements"
L["saydesc"] = "Sets whether to announce to Say."
L["partydesc"] = "Sets whether to announce to Party Chat."
L["instancedesc"] = "Sets whether to announce to Instance Chat if in a Looking For Dungeon group."
L["raiddesc"] = "Sets whether to announce to Raid Chat."
L["guilddesc"] = "Sets whether to announce to Guild Chat|n|cFFF02121(Disables Officer Chat announcements)."
L["officerdesc"] = "Sets whether to announce to Officer Chat.|n|cFF9ffbff(Only if no announcement has already been sent to Guild)"
L["channeldesc"] = "Sets whether to announce to a channel. Please don't be rude!"
L["channelselect"] = "Select a Channel"
L["channelselectdesc"] = "|n|cFF9ffbffIf you join a channel while this options menu is open, close and reopen the Interface menu to update the channels list."

	-- Out of Range Alerts --
L["oor"] = "Out-Of-Range Alerts"
L["oordesc"] = "Announce when you miss credit for a kill quest."
L["oorrequires"] = "Out-Of-Range Alerts requires party or raid members to have Objective Announcer."
L["oorenable"] = "Enable OOR Alerts"
L["oorenabledesc"] = "Send announcements if you do not receive credit when party members using Objective Announcer advance kill quests."

	-- Extra Information --
L["extrainfo"] = "Extra Information"
L["extrainfodesc"] = "Add additional information about quests to announcements."
L["extrainfoquestlink"] = "Quest Link"
L["extrainfoquestlinkdesc"] = "Adds a clickable link of the relevant quest to your objective and progress announcements."
L["extrainfosugggroup"] = "Suggested Group"
L["extrainfosugggroupdesc"] = "Adds the quest's suggested group size to your announcements."
L["extrainfoquesttag"] = "Quest Tag"
L["extrainfoquesttagdesc"] = "Adds special tagging of quest to announcements.|n|cFF9ffbffGroup, Raid, Account, etc."
L["extrainfofreq"] = "Frequency"
L["extrainfofreqdesc"] = "Adds whether it's a daily or weekly quest to your announcements."
L["extrainfoquestlevel"] = "Quest Level"
L["extrainfoquestleveldesc"] = "Adds the intended level of the quest to announcements."

	-- Quest Start / End --
L["queststartend"] = "Quest Start/End"
L["headerstart"] = "Quest Start"
L["headerend"] = "Quest End"
L["qsedesc"] = "Announcements and assistance for beginning and ending quests."
L["qseaccept"] = "Accept a Quest"
L["qseacceptdesc"] = "Make an announcement when you accept a new quest."
L["qseturnin"] = "Turn in a Quest"
L["qseturnindesc"] = "Make an announcement when you turn in a quest."
L["qseabandon"] = "Abandon a Quest"
L["qseabandondesc"] = "Make an announcement when you abandon a quest."
L["qsefail"] = "Fail a Quest"
L["qsefaildesc"] = "Make an announcement when you fail a quest."
L["qseexp"] = "Experience Gained"
L["qseexpdesc"] = "Make an announcement of how much experience you received after turning in a quest."
L["qserewards"] = "Reward Chosen"
L["qserewardsdesc"] = "Make an announcement of the quest reward you received."
L["qseescort"] = "Auto-accept escort/event quests"
L["qseescortdesc"] = "Automatically accepts event quests started by party members."
L["qseautocomplete"] = "Auto-Complete"
L["qseautocompletedesc"] = "Send an extra announcement when you complete a quest that can be completed remotely.|n|cFF9ffbffAlso causes the remote turn-in dialogue window to appear."
L["qsebonusobj"] = "Bonus Objectives & World Quests"
L["qsebonusobjdesc"] = "Sends extra announcements for Bonus Objective and World Quest areas.|n|cFF9ffbffArea Entered, Area Left."

	-- Sound --
L["sounddesc"] = "Play sounds for questing events."
L["soundcompletion"] = "Completion Sounds"
L["soundcompletiondesc"] = "Sets whether to play sounds when announcements are made.|n|cFF9ffbffOnly plays if an announcement is sent"
L["soundobjcompletefile"] = "Objective Complete"
L["soundobjcompletefiledesc"] = "Select a sound to play when you complete an objective"
L["soundquestcompletefile"] = "Quest Complete"
L["soundquestcompletefiledesc"] = "Select a sound to play when you complete a quest"
L["soundacceptfail"] = "Accept/Fail Sounds"
L["soundacceptfaildesc"] = "Sets whether to play sounds when accepting or failing a quest.|n|cFF9ffbffOnly plays if an announcement is sent"
L["soundacceptfile"] = "Quest Accept"
L["soundacceptfiledesc"] = "Select a sound to play when you accept a new quest"
L["soundfailfile"] = "Quest Fail"
L["soundfailfiledesc"] = "Select a sound to play when you fail a quest"
L["soundcommunication"] = "OA Communication Sounds"
L["soundcommunicationdesc"] = "Sets whether to play a sound when other players with Objective Announcer send announcements"
L["soundcommfile"] = "OA Communication"
L["soundcommfiledesc"] = "Select a sound to play when another player announces an objective"

	-- Self Outputs (LibSink) --
L["selfoutput"] = "Self Outputs"
L["selfoutputdesc"] = "Select where to send your Objective Announcer messages."

	-- Chat Slash Commands --
L["enabled"] = "Enabled"
L["chat"] = " Chat "
L["slashquest"] = "Now Announcing Completed Quests Only"
L["slashobj"] = "Now Announcing Completed Objectives Only"
L["slashboth"] = "Now Announcing Both Completed Quests & Objectives"
L["slashprog"] = "Now Announcing Objective Progress"
L["slashprogq"] = "Now Announcing Objective Progress & Completed Quests"
L["slashself"] = "Self Messages"
L["slashselfdis"] = "(Always Self Announce also disabled)"
L["slashpublicerror"] = "Valid public chat names are: say, party, instance, raid, guild, officer & channel."
		-- Quest Start/End --	
L["slashquestaccept"] = "Announce Accepted Quests"
L["slashquestturnin"] = "Announce Turned-in Quests"
L["slashquestexp"] = "Announce Experience Gained"
L["slashquestrewards"] = "Announce Quest Rewards"
L["slashquestescort"] = "Auto-accept Escort Quests"
L["slashquestfail"] = "Announce Failed Quests"
		-- Sounds --
L["slashsoundcompletion"] = "Quest/Objective Complete Sounds"
L["slashsoundacceptfail"] = "Quest Accept/Fail Sounds"
L["slashsoundcomm"] = "Communication Sounds"



	-------------------
	-- Announcements --
	-------------------
	
--L[""] = 
L["areaentered"] = "AREA ENTERED"
L["arealeft"] = "AREA LEFT"
L["taskcomplete"] = "BONUS OBJECTIVE COMPLETE"
L["worldquestcomplete"] = "WORLD QUEST COMPLETE"
L["autoaccept1"] = "Automatically accepted"
L["autoaccept2"] = "Started by"
L["autocompletealert"] = "AUTO-COMPLETE ALERT"
L["expgain"] = "Experience Gained"
L["rewardchosen"] = "Reward Received From"
L["oornotreceived"] = "'s Objective Credit Not Received: \""	-- Be sure to keep the ( \" ) at the end of the string.
L["questaccepted"] = "Quest Accepted"
L["questfailed"] = "QUEST FAILED"
L["questturnin"] = "Quest Turned In"



	-------------
	-- Strings --
	-------------
	
L["slain"] = true	-- The exact word used for quests to kill mobs.
L["killed"] = true	-- The exact word used for quests to kill mobs.


	------------
	-- Popups --
	------------

L["popupoorupdate"] = "Objective Announcer's Out-of-range feature has been updated. Please have your group members update to prevent errors."

L["ObjectiveAnnouncer"] = ""
L["Objective Announcer"] = true
L["Self Outputs"] = true
L["Profiles"] = true