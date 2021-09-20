local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("Spy", "enUS", true)
if not L then return end

-- Addon information
L["Spy"] = "Spy"
L["Version"] = "Version"
L["LoadDescription"] = "|cff9933ffSpy addon loaded. Type |cffffffff/spy|cff9933ff for options."
L["SpyEnabled"] = "|cff9933ffSpy addon enabled."
L["SpyDisabled"] = "|cff9933ffSpy addon disabled. Type |cffffffff/spy enable|cff9933ff to enable."
L["UpgradeAvailable"] = "|cff9933ffA new version of Spy is available. It can be downloaded from:\n|cffffffffhttps://mods.curse.com/addons/wow/spy"

-- Configuration frame name
L["Spy Option"] = "Spy"

-- Configuration strings
L["Profiles"] = "Profiles"

L["GeneralSettings"] = "General Settings"
L["SpyDescription1"] = [[
Spy is an addon that will alert you to the presence of nearby enemy players.
]]
L["SpyDescription2"] = [[

|cffffd000Nearby list|cffffffff
The Nearby list displays any enemy players that have been detected nearby. Clicking the list allows you to target the player, however this only works out of combat. Players are removed from the list if they have not been detected after a period of time.

The clear button in the title bar can be used to clear the list, and holding Control while clearing the list will allow you to quickly enable/disable Spy.

|cffffd000Last Hour list|cffffffff
The Last Hour list displays all enemies that have been detected in the last hour.

|cffffd000Ignore list|cffffffff
Players that are added to the Ignore list will not be reported by Spy. You can add and remove players to/from this list by using the button's drop down menu or by holding the Control key while clicking the button.

|cffffd000Kill On Sight list|cffffffff
Players on your Kill On Sight list cause an alarm to sound when detected. You can add and remove players to/from this list by using the button's drop down menu or by holding the Shift key while clicking the button.

The drop down menu can also be used to set the reasons why you have added someone to the Kill On Sight list. If you want to enter a specific reason that is not in the list, then use the "Enter your own reason..." in the Other list.


|cffffd000Author: http://www.curse.com/users/slipjack|cffffffff

]]
L["EnableSpy"] = "Enable Spy"
L["EnableSpyDescription"] = "Enables or disables Spy both now and also on login."
L["EnabledInBattlegrounds"] = "Enable Spy in battlegrounds"
L["EnabledInBattlegroundsDescription"] = "Enables or disables Spy when you are in a battleground."
L["EnabledInArenas"] = "Enable Spy in arenas"
L["EnabledInArenasDescription"] = "Enables or disables Spy when you are in an arena."
L["EnabledInWintergrasp"] = "Enable Spy in world combat zones"
L["EnabledInWintergraspDescription"] = "Enables or disables Spy when you are in world combat zones such as Lake Wintergrasp in Northrend."
L["DisableWhenPVPUnflagged"] = "Disable Spy when not flagged for PVP"
L["DisableWhenPVPUnflaggedDescription"] = "Enables or disables Spy depending on your PVP status."

L["DisplayOptions"] = "Display"
L["DisplayOptionsDescription"] = [[
Spy can be shown or hidden automatically.
]]
L["ShowOnDetection"] = "Show Spy when enemy players are detected"
L["ShowOnDetectionDescription"] = "Set this to display the Spy window and the Nearby list if Spy is hidden when enemy players are detected."
L["HideSpy"] = "Hide Spy when no enemy players are detected"
L["HideSpyDescription"] = "Set this to hide Spy when the Nearby list is displayed and it becomes empty. Spy will not be hidden if you clear the list manually."
L["LockSpy"] = "Lock the Spy window"
L["LockSpyDescription"] = "Locks the Spy window in place so it doesn't move."
L["InvertSpy"] = "Invert the Spy window"
L["InvertSpyDescription"] = "Flips the Spy window upside down."
L["ResizeSpy"] = "Resize the Spy window automatically"
L["ResizeSpyDescription"] = "Set this to automatically resize the Spy window as enemy players are added and removed."
L["TooltipDisplayWinLoss"] = "Display win/loss statistics in tooltip"
L["TooltipDisplayWinLossDescription"] = "Set this to display the win/loss statistics of a player in the player's tooltip."
L["TooltipDisplayKOSReason"] = "Display Kill On Sight reasons in tooltip"
L["TooltipDisplayKOSReasonDescription"] = "Set this to display the Kill On Sight reasons of a player in the player's tooltip."
L["TooltipDisplayLastSeen"] = "Display last seen details in tooltip"
L["TooltipDisplayLastSeenDescription"] = "Set this to display the last known time and location of a player in the player's tooltip."
L["SelectFont"] = "Select a Font"
L["SelectFontDescription"] = "Select a Font for the Spy Window."
L["RowHeight"] = "Select the Row Height"
L["RowHeightDescription"] = "Select the Row Height for the Spy window."

L["AlertOptions"] = "Alerts"
L["AlertOptionsDescription"] = [[
You can announce the details on an encounter to a chat channel and control how Spy alerts you when enemy players are detected.
]]
L["Announce"] = "Announce to:"
L["None"] = "None"
L["NoneDescription"] = "Do not announce when enemy players are detected."
L["Self"] = "Self"
L["SelfDescription"] = "Announce to yourself when enemy players are detected."
L["Party"] = "Party"
L["PartyDescription"] = "Announce to your party when enemy players are detected."
L["Guild"] = "Guild"
L["GuildDescription"] = "Announce to your guild when enemy players are detected."
L["Raid"] = "Raid"
L["RaidDescription"] = "Announce to your raid when enemy players are detected."
L["LocalDefense"] = "Local Defense"
L["LocalDefenseDescription"] = "Announce to the Local Defense channel when enemy players are detected."
L["OnlyAnnounceKoS"] = "Only announce enemy players that are Kill On Sight"
L["OnlyAnnounceKoSDescription"] = "Set this to only announce enemy players that are on your Kill On Sight list."
L["WarnOnStealth"] = "Warn upon stealth detection"
L["WarnOnStealthDescription"] = "Set this to display a warning and sound an alert when an enemy player gains stealth."
L["WarnOnKOS"] = "Warn upon Kill On Sight detection"
L["WarnOnKOSDescription"] = "Set this to display a warning and sound an alert when an enemy player on your Kill On Sight list is detected."
L["WarnOnKOSGuild"] = "Warn upon Kill On Sight guild detection"
L["WarnOnKOSGuildDescription"] = "Set this to display a warning and sound an alert when an enemy player in the same guild as someone on your Kill On Sight list is detected."
L["WarnOnRace"] = "Warn upon Race detection"
L["WarnOnRaceDescription"] = "Set this to sound an alert when the selected Race is detected."
L["SelectWarnRace"] = "Select Race for detection"
L["SelectWarnRaceDescription"] = "Select a Race for audio alert."
L["WarnRaceNote"] = "Note: You must target the enemy at least once so their Race can be added to the database. Upon the next detection an alert will sound. This does not work the same as detecting nearby enemies in combat."
L["DisplayWarningsInErrorsFrame"] = "Display warnings in the errors frame"
L["DisplayWarningsInErrorsFrameDescription"] = "Set this to use the errors frame to display warnings instead of using the graphical popup frames."
L["EnableSound"] = "Enable audio alerts"
L["EnableSoundDescription"] = "Set this to enable audio alerts when enemy players are detected. Different alerts sound if an enemy player gains stealth or if an enemy player is on your Kill On Sight list."
L["OnlySoundKoS"] = "Only sound audio alerts for the KoS list"
L["OnlySoundKoSDescription"] = "Set this to only play audio alerts when enemy players on the Kill on Sight list are detected."

L["ListOptions"] = "Nearby List"
L["ListOptionsDescription"] = [[
You can configure how Spy adds and removes enemy players to and from the Nearby list.
]]
L["RemoveUndetected"] = "Remove enemy players from the Nearby list after:"
L["1Min"] = "1 minute"
L["1MinDescription"] = "Remove an enemy player who has been undetected for over 1 minute."
L["2Min"] = "2 minutes"
L["2MinDescription"] = "Remove an enemy player who has been undetected for over 2 minutes."
L["5Min"] = "5 minutes"
L["5MinDescription"] = "Remove an enemy player who has been undetected for over 5 minutes."
L["10Min"] = "10 minutes"
L["10MinDescription"] = "Remove an enemy player who has been undetected for over 10 minutes."
L["15Min"] = "15 minutes"
L["15MinDescription"] = "Remove an enemy player who has been undetected for over 15 minutes."
L["Never"] = "Never remove"
L["NeverDescription"] = "Never remove enemy players. The Nearby list can still be cleared manually."
L["ShowNearbyList"] = "Switch to the Nearby list upon enemy player detection"
L["ShowNearbyListDescription"] = "Set this to display the Nearby list if it is not already visible when enemy players are detected."
L["PrioritiseKoS"] = "Prioritise Kill On Sight enemy players in the Nearby list"
L["PrioritiseKoSDescription"] = "Set this to always show Kill On Sight enemy players first in the Nearby list."

L["MinimapOptions"] = "Map"
L["MinimapOptionsDescription"] = [[
For players who can track humanoids the minimap can be utilised to provide additional features.

Players who can track humanoids include hunters, druids, and those who have received the ability through other means such as eating a Blackened Worg Steak.
]]
L["MinimapTracking"] = "Enable minimap tracking"
L["MinimapTrackingDescription"] = "Set this to enable minimap tracking and detection. Known enemy players detected on the minimap will be added to the Nearby list."
L["MinimapDetails"] = "Display level/class details in tooltips"
L["MinimapDetailsDescription"] = "Set this to update the map tooltips so that level/class details are displayed alongside enemy names."
L["DisplayOnMap"] = "Display enemy location on map"
L["DisplayOnMapDescription"] = "Set this to display on the world map and minimap the location of enemies detected by other Spy users in your party, raid and guild."
L["SwitchToZone"] = "Switch to current zone map on enemy detection"
L["SwitchToZoneDescription"] = "If the World Map is open this will change the map to the players current zone map when enemies are detected."
L["MapDisplayLimit"] = "Limit displayed map icons to:"
L["LimitNone"] = "Everywhere"
L["LimitNoneDescription"] = "Displayes all detected enemies on the map regardless of your current location."
L["LimitSameZone"] = "Same zone"
L["LimitSameZoneDescription"] = "Only displays detected enemies on the map if you are in the same zone."
L["LimitSameContinent"] = "Same continent"
L["LimitSameContinentDescription"] = "Only displays detected enemies on the map if you are on the same continent."

L["DataOptions"] = "Data Management"
L["DataOptionsDescription"] = [[
You can configure how Spy maintains and gathers its data.
]]
L["PurgeData"] = "Purge undetected enemy player data after:"
L["OneDay"] = "1 day"
L["OneDayDescription"] = "Purge data for enemy players that have been undetected for 1 day."
L["FiveDays"] = "5 days"
L["FiveDaysDescription"] = "Purge data for enemy players that have been undetected for 5 days."
L["TenDays"] = "10 days"
L["TenDaysDescription"] = "Purge data for enemy players that have been undetected for 10 days."
L["ThirtyDays"] = "30 days"
L["ThirtyDaysDescription"] = "Purge data for enemy players that have been undetected for 30 days."
L["SixtyDays"] = "60 days"
L["SixtyDaysDescription"] = "Purge data for enemy players that have been undetected for 60 days."
L["NinetyDays"] = "90 days"
L["NinetyDaysDescription"] = "Purge data for enemy players that have been undetected for 90 days."
L["PurgeKoS"] = "Purge Kill on Sight players based on undetected time."
L["PurgeKoSDescription"] = "Set this to purge Kill on Sight players that have been undetected based on the time settings for undetected players."
L["PurgeWinLossData"] = "Purge win/loss data based on undetected time."
L["PurgeWinLossDataDescription"] = "Set this to purge win/loss data of your enemy encounters based on the time settings for undetected players."
L["ShareData"] = "Share data with other Spy addon users"
L["ShareDataDescription"] = "Set this to share the details of your enemy player encounters with other Spy users in your party, raid and guild."
L["UseData"] = "Use data from other Spy addon users"
L["UseDataDescription"] = [[Set this to use the data collected by other Spy users in your party, raid and guild.

If another Spy user detects an enemy player then that enemy player will be added to your Nearby list if there is room.
]]
L["ShareKOSBetweenCharacters"] = "Share Kill On Sight players between your characters"
L["ShareKOSBetweenCharactersDescription"] = "Set this to share the players you mark as Kill On Sight between other characters that you play on the same server and faction."

L["SlashCommand"] = "Slash Command"
L["SpySlashDescription"] = "These buttons execute the same functions as the ones in the slash command /spy"
L["Enable"] = "Enable"
L["EnableDescription"] = "Enables Spy and shows the main window."
L["Reset"] = "Reset"
L["ResetDescription"] = "Resets the position and appearance of the main window."
L["Config"] = "Config"
L["ConfigDescription"] = "Open the Interface Addons configuration window for Spy."
L["KOS"] = "KOS"
L["KOSDescription"] = "Add/remove a player to/from the Kill On Sight list."
L["Ignore"] = "Ignore"
L["IgnoreDescription"] = "Add/remove a player to/from the Ignore list."

-- Lists
L["Nearby"] = "Nearby"
L["LastHour"] = "Last Hour"
L["Ignore"] = "Ignore"
L["KillOnSight"] = "Kill On Sight"

--Stats
--L["Last"] = "Last"
L["Time"] = "Time"	
L["List"] = "List"	
L["Show Only"] = "Show Only"
L["Won/Lost"] = "Won/Lost"
L["Reason"] = "Reason"	 
L["HonorKills"] = "Honor Kills"
L["PvPDeaths"] = "PvP Deaths"

--++ Class descriptions
L["DEATHKNIGHT"] = "Death Knight"
L["DEMONHUNTER"] = "Demon Hunter"
L["DRUID"] = "Druid"
L["HUNTER"] = "Hunter"
L["MAGE"] = "Mage"
L["MONK"] = "Monk"
L["PALADIN"] = "Paladin"
L["PRIEST"] = "Priest"
L["ROGUE"] = "Rogue"
L["SHAMAN"] = "Shaman"
L["WARLOCK"] = "Warlock"
L["WARRIOR"] = "Warrior"
L["UNKNOWN"] = "Unknown"

--++ Race descriptions
L["BLOOD ELF"] = "Blood Elf"
L["DRAENEI"] = "Draenei"
L["DWARF"] = "Dwarf"
L["GOBLIN"] = "Goblin"
L["GNOME"] = "Gnome"
L["HUMAN"] = "Human"
L["NIGHT ELF"] = "Night Elf"
L["ORC"] = "Orc"
L["PANDAREN"] = "Pandaren"
L["TAUREN"] = "Tauren"
L["TROLL"] = "Troll"
L["UNDEAD"] = "Undead"
L["WORGEN"] = "Worgen"
L["VOID ELF"] = "Void Elf"	
L["LIGHTFORGED DRAENEI"] = "Lightforged Draenei"
L["NIGHTBORNE"] = "Nightborne"
L["HIGHMOUNTAIN TAUREN"] = "Highmountain Tauren"

--++ Font descriptions
L["2002"] = "2002"
L["2002 BOLD"] = "2002 Bold"
L["ARIAL NARROW"] = "Arial Narrow" -- default chat font
L["FRIZ QUADRATA TT"] = "Friz Quadrata TT" -- default main UI font
L["FRIZQUADRATACTT"] = "FrizQuadrataCTT"
L["MOK"] = "MoK"
L["MORPHEUS"] = "Morpheus" -- default in game mail font
L["NIMROD MT"] = "Nimrod MT"
L["SKURRI"] = "Skurri" -- default unit frame combat font
						
-- Stealth abilities
L["Stealth"] = "Stealth"
L["Prowl"] = "Prowl"

-- Channel names
L["LocalDefenseChannelName"] = "LocalDefense"

--++ Minimap color codes
L["MinimapClassTextDEATHKNIGHT"] = "|cffc41e3a"
L["MinimapClassTextDEMONHUNTER"] = "|cffa330c9"
L["MinimapClassTextDRUID"] = "|cffff7c0a"
L["MinimapClassTextHUNTER"] = "|cffaad372"
L["MinimapClassTextMAGE"] = "|cff68ccef"
L["MinimapClassTextMONK"] = "|cff00ff96"
L["MinimapClassTextPALADIN"] = "|cfff48cba"
L["MinimapClassTextPRIEST"] = "|cffffffff"
L["MinimapClassTextROGUE"] = "|cfffff468"
L["MinimapClassTextSHAMAN"] = "|cff2359ff"
L["MinimapClassTextWARLOCK"] = "|cff9382c9"
L["MinimapClassTextWARRIOR"] = "|cffc69b6d"
L["MinimapClassTextUNKNOWN"] = "|cff191919"
L["MinimapGuildText"] = "|cffffffff"

-- Output messages
L["AlertStealthTitle"] = "Stealth player detected!"
L["AlertKOSTitle"] = "Kill On Sight player detected!"
L["AlertKOSGuildTitle"] = "Kill On Sight player guild detected!"
L["AlertTitle_kosaway"] = "Kill On Sight player located by "
L["AlertTitle_kosguildaway"] = "Kill On Sight player guild located by "
L["StealthWarning"] = "|cff9933ffStealth player detected: |cffffffff"
L["KOSWarning"] = "|cffff0000Kill On Sight player detected: |cffffffff"
L["KOSGuildWarning"] = "|cffff0000Kill On Sight player guild detected: |cffffffff"
L["SpySignatureColored"] = "|cff9933ff[Spy] "
L["PlayerDetectedColored"] = "Player detected: |cffffffff"
L["PlayersDetectedColored"] = "Players detected: |cffffffff"
L["KillOnSightDetectedColored"] = "Kill On Sight player detected: |cffffffff"
L["PlayerAddedToIgnoreColored"] = "Added player to Ignore list: |cffffffff"
L["PlayerRemovedFromIgnoreColored"] = "Removed player from Ignore list: |cffffffff"
L["PlayerAddedToKOSColored"] = "Added player to Kill On Sight list: |cffffffff"
L["PlayerRemovedFromKOSColored"] = "Removed player from Kill On Sight list: |cffffffff"
L["PlayerDetected"] = "[Spy] Player detected: "
L["KillOnSightDetected"] = "[Spy] Kill On Sight player detected: "
L["Level"] = "Level"
L["LastSeen"] = "Last seen"
L["LessThanOneMinuteAgo"] = "less than a minute ago"
L["MinutesAgo"] = "minutes ago"
L["HoursAgo"] = "hours ago"
L["DaysAgo"] = "days ago"
L["Close"] = "Close"
L["CloseDescription"] = "|cffffffffHides the Spy window. By default will show again when the next enemy player is detected."
L["Left/Right"] = "Left/Right"
L["Left/RightDescription"] = "|cffffffffNavigates between the Nearby, Last Hour, Ignore and Kill On Sight lists."
L["Clear"] = "Clear"
L["ClearDescription"] = "|cffffffffClears the list of players that have been detected. CTRL click will Enable/Disable Spy while displayed."
L["NearbyCount"] = "Nearby Count"
L["NearbyCountDescription"] = "|cffffffffSends the count of nearby players to chat."
L["Statistics"] = "Statistics"
L["StatsDescription"] = "|cffffffffShows a list of enemy players encountered, win/loss records and where they were last seen."
L["AddToIgnoreList"] = "Add to Ignore list"
L["AddToKOSList"] = "Add to Kill On Sight list"
L["RemoveFromIgnoreList"] = "Remove from Ignore list"
L["RemoveFromKOSList"] = "Remove from Kill On Sight list"
L["RemoveFromStatsList"] = "Remove from Statistics List"   --++
L["AnnounceDropDownMenu"] = "Announce"
L["KOSReasonDropDownMenu"] = "Set Kill On Sight reason"
L["PartyDropDownMenu"] = "Party"
L["RaidDropDownMenu"] = "Raid"
L["GuildDropDownMenu"] = "Guild"
L["LocalDefenseDropDownMenu"] = "Local Defense"
L["Player"] = " (Player)"
L["KOSReason"] = "Kill On Sight"
L["KOSReasonIndent"] = "    "
L["KOSReasonOther"] = "Enter your own reason..."
L["KOSReasonClear"] = "Clear"
L["StatsWins"] = "|cff40ff00Wins: "
L["StatsSeparator"] = "  "
L["StatsLoses"] = "|cff0070ddLoses: "
L["Located"] = "located:"
L["Yards"] = "yards"

Spy_KOSReasonListLength = 6
Spy_KOSReasonList = {
	[1] = {
		["title"] = "Started combat";
		["content"] = {
			"Attacked me for no reason",
			"Attacked me at a quest giver", 
			"Attacked me while I was fighting NPCs",
			"Attacked me while I was near an instance",
			"Attacked me while I was AFK",
			"Attacked me while I was mounted/flying",
			"Attacked me while I had low health/mana",
		};
	},
	[2] = {
		["title"] = "Style of combat";
		["content"] = {
			"Ambushed me",
			"Always attacks me on sight",
			"Killed me with a higher level character",
			"Steamrolled me with a group of enemies",
			"Doesn't attack without backup",
			"Always calls for help",
			"Uses too much crowd control",
		};
	},
	[3] = {
		["title"] = "Camping";
		["content"] = {
			"Camped me",
			"Camped an alt",
			"Camped lowbies",
			"Camped from stealth",
			"Camped guild members",
			"Camped game NPCs/objectives",
			"Camped a city/site",
		};
	},
	[4] = {
		["title"] = "Questing";
		["content"] = {
			"Attacked me while I was questing",
			"Attacked me after I helped with a quest",
			"Interfered with a quest objective",
			"Started a quest I wanted to do",
			"Killed my faction's NPCs",
			"Killed a quest NPC",
		};
	},
	[5] = {
		["title"] = "Stole resources";
		["content"] = {
			"Gathered herbs I wanted",
			"Gathered minerals I wanted",
			"Gathered resources I wanted",
			"Killed me and stole my target/rare NPC",
			"Skinned my kills",
			"Salvaged my kills",
			"Fished in my pool",
		};
	},
	[6] = {
		["title"] = "Other";
		["content"] = {
			"Flagged for PvP",
			"Pushed me off a cliff",
			"Uses engineering tricks",
			"Always manages to escape",
			"Uses items and skills to escape",
			"Exploits game mechanics",
			"Enter your own reason...",
		};
	},
}

StaticPopupDialogs["Spy_SetKOSReasonOther"] = {
	preferredIndex=STATICPOPUPS_NUMDIALOGS,  -- http://forums.wowace.com/showthread.php?p=320956
	text = "Enter the Kill On Sight reason for %s:",
	button1 = "Set",
	button2 = "Cancel",
	timeout = 20,
	hasEditBox = 1,
	whileDead = 1,
	hideOnEscape = 1,
	OnShow = function(self)
		self.editBox:SetText("");
	end,
    	OnAccept = function(self)
		local reason = self.editBox:GetText()
		Spy:SetKOSReason(self.playerName, "Enter your own reason...", reason)
	end,
};

Spy_AbilityList = {

-----------------------------------------------------------
-- Allows an estimation of the race, class and level of a
-- player to be determined from what abilities are observed
-- in the combat log.
-----------------------------------------------------------

--++ Racials ++
	["Stoneform"] = 			{ race = "Dwarf", level = 1, },
	["Escape Artist"] = 		{ race = "Gnome", level = 1, },
	["Every Man for Himself"] = { race = "Human", level = 1, },
	["Shadowmeld"] = 			{ race = "Night Elf", level = 1, },
	["Gift of the Naaru"] = 	{ race = "Draenei", level = 1, },
	["Darkflight"] = 			{ race = "Worgen", level = 1, },
	["Two Forms"] = 			{ race = "Worgen", level = 1, },
	["Running Wild"] = 			{ race = "Worgen", level = 1, },
	["Blood Fury"] = 			{ race = "Orc", level = 1, },
	["War Stomp"] = 			{ race = "Tauren", level = 1, },
	["Berserking"] = 			{ race = "Troll", level = 1, },
	["Will of the Forsaken"] = 	{ race = "Undead", level = 1, },
	["Cannibalize"] = 			{ race = "Undead", level = 1, },
	["Arcane Torrent"] = 		{ race = "Blood Elf", level = 1, },
	["Rocket Jump"] = 			{ race = "Goblin", level = 1, },
	["Rocket Barrage"] = 		{ race = "Goblin", level = 1, },
	["Pack Hobgoblin"] = 		{ race = "Goblin", level = 1, },
	["Quaking Palm"] =			{ race = "Pandaren", level = 1, },

--++ Death Knight Abilities ++
	["Frost Breath"] = 			{ class = "DEATHKNIGHT", level = 1, },	--7
	["Corpse Explosion"] = 		{ class = "DEATHKNIGHT", level = 25, },	--7
	["Blood Plague"] = 			{ class = "DEATHKNIGHT", level = 55, }, 
	["Death Gate"] = 			{ class = "DEATHKNIGHT", level = 55, }, 
	["Death Grip"] = 			{ class = "DEATHKNIGHT", level = 55, },
	["Death Strike"] = 			{ class = "DEATHKNIGHT", level = 55, }, --7m  	
	["Frost Fever"] = 			{ class = "DEATHKNIGHT", level = 55, },	
	["Rune of Razorice"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Runeforging"] = 			{ class = "DEATHKNIGHT", level = 55, },  
	["Anti-Magic Shell"] = 		{ class = "DEATHKNIGHT", level = 57, }, --7m
	["Dark Command"]  = 		{ class = "DEATHKNIGHT", level = 58, },	--7m
	["On a Pale Horse"] = 		{ class = "DEATHKNIGHT", level = 61, }, 
	["Mind Freeze"] = 			{ class = "DEATHKNIGHT", level = 62, },  
	["Path of Frost"] = 		{ class = "DEATHKNIGHT", level = 66, }, 
	["Control Undead"] = 		{ class = "DEATHKNIGHT", level = 69, },  
	["Rune of Fallen Crusader"] = { class = "DEATHKNIGHT", level = 70, },	
 	["Raise Ally"] = 			{ class = "DEATHKNIGHT", level = 72, },
	["Rune of the Stoneskin Gargoyle"] = { class = "DEATHKNIGHT", level = 72, },
--++ Death Knight Artifact Traits ++
	["Apocalypse"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n
	["Consumption"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n
	["Sindragosa's Fury"] = 	{ class = "DEATHKNIGHT", level = 100, }, --7n
--++ Death Knight Specialization ++
	--++ Blood/Frost/Unholy ++
 	["Wraith Walk"] = 			{ class = "DEATHKNIGHT", level = 60, }, --7n
	["Icebound Fortitude"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7.2.5m	
	--++ Blood/Unholy ++	
	["Death and Decay"] = 		{ class = "DEATHKNIGHT", level = 56, }, --7m	
	--++ Frost/Unholy ++
	["Dark Succor"] = 			{ class = "DEATHKNIGHT", level = 58, },	--7n
	["Chains of Ice"] = 		{ class = "DEATHKNIGHT", level = 63, }, --7m 	
	--++ Blood ++
--	["Asphyxiate"] = 			{ class = "DEATHKNIGHT", level = 1, }, --??	
	["Heart Strike"]  = 		{ class = "DEATHKNIGHT", level = 1, }, --7 
	["Marrowrend"]  = 			{ class = "DEATHKNIGHT", level = 55, }, --7n	
	["Blood Boil"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7m
	["Dancing Rune Weapon"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7m
	["Death's Caress"] = 		{ class = "DEATHKNIGHT", level = 58, },	--7n
	["Vampiric Blood"] = 		{ class = "DEATHKNIGHT", level = 60, },	--7.2.5m	
	["Veteran of the Third War"] = { class = "DEATHKNIGHT", level = 60, },
	["Crimson Scourge"] = 		{ class = "DEATHKNIGHT", level = 84, },	
	["Gorefiend's Grasp"] = 	{ class = "DEATHKNIGHT", level = 64, }, --7m
--	["Ripsote"] = 				{ class = "DEATHKNIGHT", level = 76, }, --++ conflict	
	["Blood Shield"] = 			{ class = "DEATHKNIGHT", level = 78, },
	--++ Frost ++ 
	["Runic Empowerment"] = 	{ class = "DEATHKNIGHT", level = 1, }, --7m??
	["Frost Fever"] = 			{ class = "DEATHKNIGHT", level = 55, },	--7n	
	["Frost Strike"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Howling Blast"] = 		{ class = "DEATHKNIGHT", level = 55, },	  
	["Obliterate"] = 			{ class = "DEATHKNIGHT", level = 55, },	  
	["Killing Machine"] = 		{ class = "DEATHKNIGHT", level = 56, },	  
 	["Empower Rune Weapon"] = 	{ class = "DEATHKNIGHT", level = 57, },	--7n
	["Pillar of Frost"] = 		{ class = "DEATHKNIGHT", level = 57, },	
	["Rime"] = 					{ class = "DEATHKNIGHT", level = 59, },
	["Frozen Heart"] = 			{ class = "DEATHKNIGHT", level = 78, },	
	--++ Unholy ++  
	["Festering Wound"] = 		{ class = "DEATHKNIGHT", level = 1, }, --7n	
	["Runic Corruption"] = 		{ class = "DEATHKNIGHT", level = 1, }, --7m??	
	["Death Coil"] = 			{ class = "DEATHKNIGHT", level = 55, }, --7m 
--	["Death's Advance"] = 		{ class = "DEATHKNIGHT", level = 55, },	--7 Hotfix removed
	["Festering Strike"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Outbreak"] = 				{ class = "DEATHKNIGHT", level = 55, }, --7m	
	["Raise Dead"] = 			{ class = "DEATHKNIGHT", level = 55, }, --7m
	["Scourge Strike"] = 		{ class = "DEATHKNIGHT", level = 55, },
	["Sudden Doom"] = 			{ class = "DEATHKNIGHT", level = 64, },
	["Dark Transformation"] = 	{ class = "DEATHKNIGHT", level = 74, },	  
	["Summon Gargoyle"] = 		{ class = "DEATHKNIGHT", level = 75, },	  
	["Dreadblade"] = 			{ class = "DEATHKNIGHT", level = 78, },
	["Army of the Dead"] = 		{ class = "DEATHKNIGHT", level = 82, }, --7m	
--++ Death Knight Talents ++
	--++ Blood ++
	["Blooddrinker"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7n
	["Bloodworms"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7n
	["Heartbreaker"] = 			{ class = "DEATHKNIGHT", level = 56, }, --7n
	["Rapid Decomposition"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7n
--	["Soulgorge"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7.2.5r
	["Heart of Ice"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7.2.5n	
	["Special Deflection"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7n
	["Anti-Maigc Barrier"] = 	{ class = "DEATHKNIGHT", level = 58, }, --7n	
	["Blood Tap"] = 			{ class = "DEATHKNIGHT", level = 58, }, --7m
	["Ossuary"] = 				{ class = "DEATHKNIGHT", level = 58, }, --7n
	["Mark of Blood"] = 		{ class = "DEATHKNIGHT", level = 60, }, --7n	
	["Red Thirst"] = 			{ class = "DEATHKNIGHT", level = 60, }, --7n	
	["Tombstone"] = 			{ class = "DEATHKNIGHT", level = 60, }, --7n	
	["March of the Damned"] = 	{ class = "DEATHKNIGHT", level = 75, }, --7n	
	["Tighten Grasp"] = 		{ class = "DEATHKNIGHT", level = 75, }, --7n	
	["Tremble Before Me"] = 	{ class = "DEATHKNIGHT", level = 75, }, --7n	
	["Foul Bulwark"] = 			{ class = "DEATHKNIGHT", level = 90, }, --7n	
	["Rune Tap"] = 				{ class = "DEATHKNIGHT", level = 90, },	--7m
 	["Will of the Necropolis"] = { class = "DEATHKNIGHT", level = 90, }, --7m	
 	["Blood Mirror"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n
 	["Bonestorm"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n	
 	["Purgatory"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7m	
	--++ Frost ++ 
	["Icy Talons"] = 			{ class = "DEATHKNIGHT", level = 56, },	--7m	
	["Runic Attenuation"] = 	{ class = "DEATHKNIGHT", level = 56, }, --7.3m		
	["Shattering Strikes"] = 	{ class = "DEATHKNIGHT", level = 56, }, --7n
	["Freezing Fog"] = 			{ class = "DEATHKNIGHT", level = 57, }, --7n
	["Horn of Winter"] = 		{ class = "DEATHKNIGHT", level = 57, }, --7m
	["Murderous Efficiency"] = 	{ class = "DEATHKNIGHT", level = 57, }, --7.3m	
	["Avalanche"] = 			{ class = "DEATHKNIGHT", level = 58, }, --7n
	["Glacial Advance"] = 		{ class = "DEATHKNIGHT", level = 58, }, --7.3m	
	["Icecap"] = 				{ class = "DEATHKNIGHT", level = 58, }, --7n
	["Abomination's Might"] = 	{ class = "DEATHKNIGHT", level = 60, }, --7n
	["Blinding Sleet"] = 		{ class = "DEATHKNIGHT", level = 60, }, --7n
	["Winter is Coming"] = 		{ class = "DEATHKNIGHT", level = 60, }, --7n
	["Inexorable Assault"] =	{ class = "DEATHKNIGHT", level = 75, }, --7.3n	
	["Permafrost"] = 			{ class = "DEATHKNIGHT", level = 75, }, --7n
--	["Volatile Shielding"] = 	{ class = "DEATHKNIGHT", level = 75, }, --7.3r
	["White Walker"] = 			{ class = "DEATHKNIGHT", level = 75, }, --7n
	["Fostscythe"] = 			{ class = "DEATHKNIGHT", level = 90, }, --7n
	["Frozen Pulse"] = 			{ class = "DEATHKNIGHT", level = 90, }, --7.3m	
	["Gathering Storm"] = 		{ class = "DEATHKNIGHT", level = 90, }, --7n
	["Breath of Sindragosa"]=	{ class = "DEATHKNIGHT", level = 100, }, --7m
	["Hungering Rune Weapon"] = { class = "DEATHKNIGHT", level = 100, }, --7.3m		
	["Obliteration"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7n		
	--++ Unholy ++ 
	["All Will Serve"] =		{ class = "DEATHKNIGHT", level = 56, },--7n
	["Bursting Sores"] =		{ class = "DEATHKNIGHT", level = 56, },--7n	
	["Ebon Fever"] =			{ class = "DEATHKNIGHT", level = 56, },--7n	
	["Blighted Rune Weapon"] =	{ class = "DEATHKNIGHT", level = 57, },--7n	
	["Epidemic"] =			 	{ class = "DEATHKNIGHT", level = 57, },--7n	
	["Pestilent Pustules"] =	{ class = "DEATHKNIGHT", level = 57, },--7n	
	["Castigator"] =			{ class = "DEATHKNIGHT", level = 58, },--7n	
	["Clawing Shadows"] =		{ class = "DEATHKNIGHT", level = 58, },--7n	
	["Unholy Frenzy"] = 		{ class = "DEATHKNIGHT", level = 58, },	--7m 
	["Asphyxiate"] = 			{ class = "DEATHKNIGHT", level = 60, },
	["Debilitating Infestation"] = { class = "DEATHKNIGHT", level = 60, },--7n
	["Sludge Belcher"] =		{ class = "DEATHKNIGHT", level = 60, },--7n
	["Corpse Shield"] =			{ class = "DEATHKNIGHT", level = 75, },--7n
	["Lingering Apperation"] =	{ class = "DEATHKNIGHT", level = 75, },--7n
	["Spell Eater"] =			{ class = "DEATHKNIGHT", level = 75, },--7n
	["Infected Claws"] =		{ class = "DEATHKNIGHT", level = 90, },--7n	
	["Necrosis"] = 				{ class = "DEATHKNIGHT", level = 90, },	--7m
	["Shadow Infusion"] =		{ class = "DEATHKNIGHT", level = 90, },--7n	
	["Dark Arbiter"] =			{ class = "DEATHKNIGHT", level = 100, },--7n
	["Defile"] =			 	{ class = "DEATHKNIGHT", level = 100, },--7m
	["Soul Reaper"] = 			{ class = "DEATHKNIGHT", level = 100, }, --7m	
--++ Death Knight PvP Talents
	["Strangulate"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["Anti-Magic Zone"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["Dark Simulacrum"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["Decomposing Aura"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["Wandering Plague"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["Death Chain"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["Killing Machine"]=		{ class = "DEATHKNIGHT", level = 100, },--7n
	["Chill Streak"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["Reanimation"]=			{ class = "DEATHKNIGHT", level = 100, },--7n
	["Necrotic Strike"]=		{ class = "DEATHKNIGHT", level = 100, },--7n

--++ Demon Hunter Abilities ++
--	["Critical Strikes"]=		{ class = "DEMONHUNTER", level = 98, }, Conflict
--	["Parry"]=					{ class = "DEMONHUNTER", level = 98, }, Conflict
	["Chaos Strike"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Consume Magic"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Demon's Bite"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Double Jump"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
--	["Energy Regen"]=			{ class = "DEMONHUNTER", level = 98, }, --7n??
	["Eye Beam"]=				{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Fel Rush"]=				{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Glide"]=					{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Spectral Sight"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Throw Glaive"]=			{ class = "DEMONHUNTER", level = 98, }, --7n+
	["Metamorphosis"]=			{ class = "DEMONHUNTER", level = 99, }, --7n+	
	["Annihilation"]=			{ class = "DEMONHUNTER", level = 99, }, --7n+
	["Blade Dance"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Blur"]=					{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Chaos Nova"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Darkness"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Death Sweep"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+	
	["Imprison"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Vengeful Retreat"]=		{ class = "DEMONHUNTER", level = 100, }, --7n+
--++ Demon Hunter Artifact Traits ++
	["Fury of the Illidari"]=	{ class = "DEMONHUNTER", level = 100, }, --7n
	["Soul Carver"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
--++ Demon Hunter Specialization ++
	--++ Havoc/Vengeance ++	
	["Shattered Souls"]=		{ class = "DEMONHUNTER", level = 98, }, --7n+
	--++ Havoc ++	
	["Demonic Presence"]= 		{ class = "DEMONHUNTER", level = 98, }, --7n+
	--++ Vengeance ++	
	["Immolation Aura"]=		{ class = "DEMONHUNTER", level = 100, }, --7n+
--	["Increased Threat"]=		{ class = "DEMONHUNTER", level = 98, }, --7n ??
	["Infernal Strike"]=		{ class = "DEMONHUNTER", level = 100, }, --7n+
--	["Pain"]=					{ class = "DEMONHUNTER", level = 98, }, --7n ??
	["Torment"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Demon Spikes"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Demonic Wards"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Fiery Brand"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Fel Blood"]=	  			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Shear"]=					{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Sigil of Flame"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
	["Soul Cleave"]=			{ class = "DEMONHUNTER", level = 100, }, --7n+
--	["Riposte"]=				{ class = "DEMONHUNTER", level = 100, }, --7n+ Conflict
--	["Sigil of Chains"]=		{ class = "DEMONHUNTER", level = 100, }, --7n  ??
 	["Sigil of Silence"]=		{ class = "DEMONHUNTER", level = 101, },  --7.1c 
	["Empower Wards"]=			{ class = "DEMONHUNTER", level = 103, }, --7.1c 	
	["Sigil of Misery"]=		{ class = "DEMONHUNTER", level = 105, }, --7.1c 	
--++ Demon Hunter Talents ++
	["Soul Rending"]=			{ class = "DEMONHUNTER", level = 104, },  --7n
	["Fel Eruption"]=			{ class = "DEMONHUNTER", level = 106, }, --7n
	--++ Havoc ++	
	["Blind Fury"]=				{ class = "DEMONHUNTER", level = 99, }, --7n 
	["Felblade"]=				{ class = "DEMONHUNTER", level = 99, }, --7.1.5m	
	["Chaos Cleave"]=			{ class = "DEMONHUNTER", level = 102, }, --7.1.5c 
	["Fel Mastery"]=			{ class = "DEMONHUNTER", level = 99, }, --7n 
	["Demon Blades"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
	["Demonic Appetite"]=		{ class = "DEMONHUNTER", level = 100, }, --7n
	["Prepared"]=				{ class = "DEMONHUNTER", level = 100, }, --7n
	["Bloodlet"]=				{ class = "DEMONHUNTER", level = 102, }, --7n
	["First Blood"]=			{ class = "DEMONHUNTER", level = 102, }, --7n
	["Desperate Instincts"]=	{ class = "DEMONHUNTER", level = 104, }, --7n
	["Netherwalk"]=				{ class = "DEMONHUNTER", level = 104, }, --7n
	["Momentum"]=				{ class = "DEMONHUNTER", level = 106, }, --7n
	["Nemesis"]=				{ class = "DEMONHUNTER", level = 106, }, --7n
	["Master of the Glaive"]=	{ class = "DEMONHUNTER", level = 108, }, --7n
	["Demon Reborn"]=			{ class = "DEMONHUNTER", level = 108, }, --7n
	["Unleashed Power"]=		{ class = "DEMONHUNTER", level = 108, }, --7n
	["Chaos Blades"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
	["Demonic"]=				{ class = "DEMONHUNTER", level = 110, }, --7n
	["Fel Barrage"]=			{ class = "DEMONHUNTER", level = 110, },--7n
	--++ Vengeance ++
	["Abyssal Strike"]=			{ class = "DEMONHUNTER", level = 99, }, --7n
	["Agonizing Flames"]=		{ class = "DEMONHUNTER", level = 99, }, --7n
	["Razor Spikes"]=			{ class = "DEMONHUNTER", level = 99, }, --7n
	["Burning Alive"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
	["Fallout"]=				{ class = "DEMONHUNTER", level = 100, }, --7n
	["Feast of Souls"]=			{ class = "DEMONHUNTER", level = 100, }, --7n
	["Flame Crash"]=			{ class = "DEMONHUNTER", level = 102, }, --7n
	["Gluttony"]=				{ class = "DEMONHUNTER", level = 102, }, --7n
	["Feed the Demon"]=			{ class = "DEMONHUNTER", level = 104, }, --7n
	["Fracture"]=				{ class = "DEMONHUNTER", level = 104, }, --7n
 	["Concentrated Sigils"]=	{ class = "DEMONHUNTER", level = 106, }, --7n
	["Quickened Sigils"]=		{ class = "DEMONHUNTER", level = 106, }, --7n
	["Blade Turning"]=			{ class = "DEMONHUNTER", level = 108, }, --7n
	["Fel Devastation"]=		{ class = "DEMONHUNTER", level = 108, }, --7n
	["Spirit Bomb"]=			{ class = "DEMONHUNTER", level = 108, }, --7n
	["Demonic Infusion"]=		{ class = "DEMONHUNTER", level = 108, }, --7.1.5n	
	["Last Resort"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
--	["Nether Bond"]=			{ class = "DEMONHUNTER", level = 110, }, --7.1.5r
	["Soul Barrier"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
--++ Demon Hunter PvP Talents ++
	["Mana Break"]=				{ class = "DEMONHUNTER", level = 110, }, --7n
	["Reverse Magic"]=			{ class = "DEMONHUNTER", level = 110, }, --7n
	["Demonic Trample"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["Illidan's Grasp"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["Eye of Leotheras"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["Rain from Above"]=		{ class = "DEMONHUNTER", level = 110, }, --7n
	["Mana Rift"]=				{ class = "DEMONHUNTER", level = 110, }, --7.1.5n	
	
--++ Druid Abilities ++
	["Cat Form"] = 				{ class = "DRUID", level = 1, },
--	["Track Humanoids"] = 		{ class = "DRUID", level = 1, }, 7 Conflict
	["Feline Grace"] = 			{ class = "DRUID", level = 6, },
	["Bear Form"] = 			{ class = "DRUID", level = 8, },
	["Clearcasting"] =	 		{ class = "DRUID", level = 10, },
	["Moonfire"] = 				{ class = "DRUID", level = 10, },
	["Growl"] = 				{ class = "DRUID", level = 13, },
	["Dreamwalk"] = 			{ class = "DRUID", level = 14, }, --7n
	["Revive"] = 				{ class = "DRUID", level = 14, },
	["Teleport: Moonglade"] = 	{ class = "DRUID", level = 14, },
	["Travel Form"] = 			{ class = "DRUID", level = 18, },
	["Sunfire"] = 				{ class = "DRUID", level = 18, },--7m??
	["Thrash"] = 		 		{ class = "DRUID", level = 18, }, --7??
	["Entangling Roots"] = 		{ class = "DRUID", level = 10, }, 
--	["Dash"] = 					{ class = "DRUID", level = 24, }, 7 Conflict
	["Charm Woodland Creature"] = { class = "DRUID", level = 40, },	--7m
	["Flap"] = 					{ class = "DRUID", level = 40, }, --7n	
	["Stag Form"] = 			{ class = "DRUID", level = 40, }, --7n	
--	["Track Beast"] = 			{ class = "DRUID", level = 40, }, 7 Conflict	
	["Rebirth"] = 				{ class = "DRUID", level = 56, },
	["Flight Form"] = 			{ class = "DRUID", level = 58, },
--++ Druid Artifact Traits ++
	["Ashamane's Frenzy"] = 	{ class = "DRUID", level = 100, }, --7n	
	["Essence of G'Hanir"] = 	{ class = "DRUID", level = 100, }, --7n	
	["New Moon"] = 				{ class = "DRUID", level = 100, }, --7n		
	["Rage of the Sleeper"] = 	{ class = "DRUID", level = 100, }, --7n	
--++ Druid Specialization ++
	--++ Balance/Feral/Guardian/Restoration ++
	["Prowl"] = 				{ class = "DRUID", level = 5, }, --7m
	--++ Balance/Restoration ++
	["Innervate"] = 			{ class = "DRUID", level = 54, }, --7m	
	--++ Balance/Feral/Guardian ++
	["Regrowth"] = 				{ class = "DRUID", level = 5, }, --7.1n
	["Remove Corruption"] = 	{ class = "DRUID", level = 18, },
	--++ Balance/Guardian/Restoration ++
	["Barkskin"] = 				{ class = "DRUID", level = 36, }, --x Moved
	--++ Feral/Guardian ++
--	["Critical Strikes"] = 		{ class = "DRUID", level = 1, }, --7m Conflict
	["Nurturing Instinct"] = 	{ class = "DRUID", level = 10, },
	["Swipe"] = 				{ class = "DRUID", level = 32, }, --7m
	["Survival Instincts"] = 	{ class = "DRUID", level = 40, },
	["Skull Bash"] = 			{ class = "DRUID", level = 64, },
	["Stampeding Roar"] = 		{ class = "DRUID", level = 83, }, --7m	
	--++ Balance ++
	["Astral Influence"] = 		{ class = "DRUID", level = 10, }, --7n	
	["Solar Wrath"] = 			{ class = "DRUID", level = 10, }, --7n	??
	["Starsurge"] = 			{ class = "DRUID", level = 12, },
	["Lunar Strike"] = 			{ class = "DRUID", level = 12, }, --7n
	["Moonkin Form"] = 			{ class = "DRUID", level = 16, },
	["Solar Beam"] = 			{ class = "DRUID", level = 28, },
	["Starfall"] = 				{ class = "DRUID", level = 76, },
	["Celestial Alignment"] = 	{ class = "DRUID", level = 64, },	
	["Starlight"] = 			{ class = "DRUID", level = 78, }, --7n
	--++ Feral ++
	["Shred"] = 				{ class = "DRUID", level = 1, },
	["Ferocious Bite"] = 		{ class = "DRUID", level = 6, }, --7m	
	["Rake"] = 					{ class = "DRUID", level = 6, }, 	
	["Feline Swiftness"] = 		{ class = "DRUID", level = 10, }, --7m
	["Tiger's Fury"] = 			{ class = "DRUID", level = 12, },
	["Rip"] = 					{ class = "DRUID", level = 20, }, 
	["Predatory Swiftness"] = 	{ class = "DRUID", level = 28, },
	["Omen of Clarity"] = 		{ class = "DRUID", level = 38, }, --7m ??
	["Infected Wounds"] = 		{ class = "DRUID", level = 40, }, --7m	
	["Berserk"] = 				{ class = "DRUID", level = 48, }, --7m
	["Maim"] = 					{ class = "DRUID", level = 72, }, 
	["Razor Claws"] = 			{ class = "DRUID", level = 78, },
	--++ Guardian ++ 
	["Mangle"] = 				{ class = "DRUID", level = 6, }, --7m
	["Maul"] = 					{ class = "DRUID", level = 10, }, --x Moved
	["Thick Hide"] = 			{ class = "DRUID", level = 10, }, 
	["Incapacitating Roar"] = 	{ class = "DRUID", level = 28, }, --7n	
	["Gore"] = 					{ class = "DRUID", level = 34, }, --7n
	["Ironfur"] = 				{ class = "DRUID", level = 44, }, --7n	
	["Frenzied Regeneration"] = { class = "DRUID", level = 50, }, --7m
	["Mark of Ursol"] = 		{ class = "DRUID", level = 72, }, --7n	
	["Nature's Guardian"] = 	{ class = "DRUID", level = 78, }, 
	--++ Restoration ++  
	["Rejuvenation"] = 			{ class = "DRUID", level = 12, }, --7m
	["Swiftmend"] = 			{ class = "DRUID", level = 12, }, 
	["Nature's Cure"] = 		{ class = "DRUID", level = 18, },
	["Healing Touch"] = 		{ class = "DRUID", level = 26, }, --7.1m	
	["Living Seed"] = 			{ class = "DRUID", level = 28, },
	["Lifebloom"] = 			{ class = "DRUID", level = 32, },
	["Revitalize"] = 			{ class = "DRUID", level = 44, }, --7n	
	["Ursol's Vortex"] = 		{ class = "DRUID", level = 48, }, --7m	
	["Ironbark"] = 				{ class = "DRUID", level = 52, },
	["Wild Growth"] = 			{ class = "DRUID", level = 64, },
	["Tranquility"] = 			{ class = "DRUID", level = 72, },
	["Harmony"] = 				{ class = "DRUID", level = 78, },
	["Efflorescence"] = 		{ class = "DRUID", level = 82, }, --7n	
	--++ Druid Talents ++
	["Wild Charge"] = 			{ class = "DRUID", level = 15, }, 
	["Mass Entanglement"] = 	{ class = "DRUID", level = 60, }, 
	["Mighty Bash"] = 			{ class = "DRUID", level = 60, }, 
	["Typhoon"] = 				{ class = "DRUID", level = 60, }, 	
	--++ Balance/Feral/Restoration ++
	["Guardian Affinity"] = 	{ class = "DRUID", level = 45, }, --7n ??
	["Displacer Beast"] = 		{ class = "DRUID", level = 30, }, 	
	--++ Balance/Feral/Guardian ++
	["Renewal"] = 				{ class = "DRUID", level = 30, },
	["Restoration Affinity"] = 	{ class = "DRUID", level = 45, }, --7n
	["Soul of the Forest"] = 	{ class = "DRUID", level = 75, }, --??
	--++ Feral/Guardian ++
	["Balance Affinity"] = 		{ class = "DRUID", level = 45, }, --7n
	["Feral Affinity"] = 		{ class = "DRUID", level = 45, }, --7n	
	--++ Balance ++	
	["Force of Nature"] = 		{ class = "DRUID", level = 15, },
	["Starlord"] = 				{ class = "DRUID", level = 15, }, --7n
	["Warrior of Elune"] = 		{ class = "DRUID", level = 15, }, --7n
	["Incarnation: Chosen of Elune"] = { class = "DRUID", level = 75, }, --7n
	["Stellar Flare"] =		 	{ class = "DRUID", level = 75, }, 
	["Astral Communion"] = 		{ class = "DRUID", level = 90, }, --7m
	["Blessing of the Ancients"] = { class = "DRUID", level = 90, }, --7n
	["Shooting Stars"] = 		{ class = "DRUID", level = 90, }, --7m
	["Fury of Elune"] = 		{ class = "DRUID", level = 100, }, --7n
	["Nature's Balance"] = 		{ class = "DRUID", level = 100, }, --7n
	["Stellar Drift"] = 		{ class = "DRUID", level = 100, }, --7n
	--++ Feral ++
	["Blood Scent"] =			{ class = "DRUID", level = 15, }, --7n	
	["Lunar Inspiration"] =		{ class = "DRUID", level = 15, }, 	
	["Predator"] =				{ class = "DRUID", level = 15, }, --7n
	["Incarnation: King of the Jungle"] = { class = "DRUID", level = 75, }, --7n
	["Jagged Wounds"] = 		{ class = "DRUID", level = 75, }, --7.3m	
	["Brutal Slash"] = 			{ class = "DRUID", level = 90, }, --7.3m
	["Sabertooth"] = 			{ class = "DRUID", level = 90, }, --7n
	["Savage Roar"] = 			{ class = "DRUID", level = 90, }, --7.3m
	["Bloodtalons"] = 			{ class = "DRUID", level = 100, }, 
	["Elune's Guidance"] = 		{ class = "DRUID", level = 100, }, --7.3mn	
	--++ Guardian ++	
	["Blood Frenzy"] = 			{ class = "DRUID", level = 15, }, --7n	
	["Brambles"] = 				{ class = "DRUID", level = 15, }, --7n	
	["Bristling Fur"] = 		{ class = "DRUID", level = 15, },
	["Guttural Roars"] = 		{ class = "DRUID", level = 30, }, --7n	
	["Intimidating Roar"] = 	{ class = "DRUID", level = 30, }, --7.1.5n	
	["Galactic Guardian"] = 	{ class = "DRUID", level = 75, }, --7n	
	["Incarnation: Guardian of Ursoc"] = { class = "DRUID", level = 75, }, --7n
	["Earthwarden"] = 			{ class = "DRUID", level = 90, }, --7n	
	["Guardian of Elune"] =	 	{ class = "DRUID", level = 90, }, 
	["Survival of the Fittest"] = { class = "DRUID", level = 90, }, --7m
	["Lunar Beam"] = 			{ class = "DRUID", level = 100, }, --7n	
	["Pulverize"] = 			{ class = "DRUID", level = 100, }, 
	["Rend and Tear"] = 		{ class = "DRUID", level = 100, }, --7n		
	--++ Restoration ++
	["Abundance"] = 			{ class = "DRUID", level = 15, }, --7n	
	["Cenarion Ward"] = 		{ class = "DRUID", level = 15, },
	["Prosperity"] = 			{ class = "DRUID", level = 15, }, --7n
	["Cultivation"] = 			{ class = "DRUID", level = 75, }, --7n
	["Incarnation: Tree of Life"] = { class = "DRUID", level = 75, }, --7n
	["Germination"] = 			{ class = "DRUID", level = 90, }, --7n	
	["Inner Peace"] = 			{ class = "DRUID", level = 90, }, --7n
	["Spring Blossoms"] = 		{ class = "DRUID", level = 90, }, --7n
	["Flourish"] = 				{ class = "DRUID", level = 100, }, --7n
	["Stonebark"] = 			{ class = "DRUID", level = 100, }, --7n
	["Moment of Clarity"] =	 	{ class = "DRUID", level = 100, }, --7.1.5m	
--++ Druid PvP Talents ++
	["Cyclone"] =				{ class = "DRUID", level = 100, }, --7n
--	["Demoralizing Roar"] =		{ class = "DRUID", level = 100, }, --7n r
--	["Enraged Mangle"] =		{ class = "DRUID", level = 100, }, --7.1.5r
	["Overrun"] =				{ class = "DRUID", level = 100, }, --7n
--	["Focused Growth"] =		{ class = "DRUID", level = 100, }, --7n r
	["Overgrowth"] =			{ class = "DRUID", level = 100, }, --7n
	["Thorns"] =				{ class = "DRUID", level = 100, }, --7n
	["Faerie Swarm"] =			{ class = "DRUID", level = 100, }, --7n
	["Thorns"] =				{ class = "DRUID", level = 100, }, --7.1.5n
	["Enraged Maim"] =			{ class = "DRUID", level = 100, }, --7.1.5n
	
--++ Hunter Abilities ++
	["Call Pet 1"] = 			{ class = "HUNTER", level = 1, },
	["Marked Shot"] = 			{ class = "HUNTER", level = 1, }, --7n	
	["Mend Pet"] = 				{ class = "HUNTER", level = 1, },	
	["Revive Pet"] = 			{ class = "HUNTER", level = 1, },
	["Aspect of the Cheetah"] = { class = "HUNTER", level = 5, },
	["Call Pet 2"] = 			{ class = "HUNTER", level = 10 },
	["Control Pet"] = 			{ class = "HUNTER", level = 10, },	
	["Dismiss Pet"] = 			{ class = "HUNTER", level = 10, },
	["Tame Beast"] = 			{ class = "HUNTER", level = 10, },
	["Feed Pet"] = 				{ class = "HUNTER", level = 11, },
	["Beast Lore"] = 			{ class = "HUNTER", level = 12, },	
	["Eagle Eye"] = 			{ class = "HUNTER", level = 16, },
	["Feign Death"] = 			{ class = "HUNTER", level = 32, },
	["Wake Up"] = 				{ class = "HUNTER", level = 32, }, --7n	
	["Call Pet 3"] = 			{ class = "HUNTER", level = 42, },	
	["Flare"] = 				{ class = "HUNTER", level = 38, },
	["Aspect of the Chameleon"] = { class = "HUNTER", level = 40, }, --7n
	["Fetch"] = 				{ class = "HUNTER", level = 40, }, 
	["Fireworks"] = 			{ class = "HUNTER", level = 40, }, 	
	["Play Dead"] = 			{ class = "HUNTER", level = 40, }, --7n		
	["Aspect of the Turtle"] = 	{ class = "HUNTER", level = 50, }, 	--7n	
	["Call Pet 4"] = 			{ class = "HUNTER", level = 62, },
	["Call Pet 5"] = 			{ class = "HUNTER", level = 82, },
--++ Hunter Artifact Traits ++
	["Fury of the Eagle"] = 	{ class = "HUNTER", level = 100, }, --7n
	["Titan's Thunder"] = 		{ class = "HUNTER", level = 100, }, --7n
	["Windburst"] = 			{ class = "HUNTER", level = 100, }, --7n
--++ Hunter Specialization ++
	--++ Beast Mastery/Marksmanship ++
	["Concussive Shot"] = 		{ class = "HUNTER", level = 8, }, --7m	
	["Disengage"] = 			{ class = "HUNTER", level = 45, }, --7.1.5c	
	["Counter Shot"] = 			{ class = "HUNTER", level = 24, }, --7m
	["Multi-Shot"] = 			{ class = "HUNTER", level = 28, }, --7m
	["Misdirection"] = 			{ class = "HUNTER", level = 42, }, --7m
	--++ Beast Mastery/Marksmanship/Survival ++
	["Freezing Trap"] = 		{ class = "HUNTER", level = 28, }, --7m	
	["Exhilaration"] = 			{ class = "HUNTER", level = 36, }, --7m ??
	["Tar Trap"] = 				{ class = "HUNTER", level = 36, }, --7.1.5m	
	--++ Beast Mastery ++
	["Cobra Shot"] = 			{ class = "HUNTER", level = 1, },	
	["Kill Command"] = 			{ class = "HUNTER", level = 3, },
	["Dire Beast"] = 			{ class = "HUNTER", level = 10, }, --7mm
	["Exotic Beasts"] = 		{ class = "HUNTER", level = 10, },	
	["Aspect of the Wild"] = 	{ class = "HUNTER", level = 18, }, --7n
	["Wild Call"] = 			{ class = "HUNTER", level = 22, }, --7n
	["Beast Cleave"] = 			{ class = "HUNTER", level = 29, },
	["Bestial Wrath"] = 		{ class = "HUNTER", level = 40, },
	["Kindred Spirits"] = 		{ class = "HUNTER", level = 44, },
	["Master of Beasts"] = 		{ class = "HUNTER", level = 78, },
	--++ Marksmanship ++ 
	["Aimed Shot"] = 			{ class = "HUNTER", level = 10, },
	["Arcane Shot"] = 			{ class = "HUNTER", level = 10 }, --7m
	["Hunter's Mark"] = 		{ class = "HUNTER", level = 18, }, --7m
	["Marked Shot"] = 			{ class = "HUNTER", level = 18, }, --7n	
	["Bursting Shot"] = 		{ class = "HUNTER", level = 22, }, --7n		
	["Hunting Party"] = 		{ class = "HUNTER", level = 34, }, --7n
	["Trueshot"] = 				{ class = "HUNTER", level = 39, }, --7n
	["Marksman's Focus"] = 		{ class = "HUNTER", level = 44, }, --7.1.5n	
	["Bombardment"] = 			{ class = "HUNTER", level = 62, },
	["Sniper Training"] = 		{ class = "HUNTER", level = 78, }, 
	--++ Survival ++  
	["Flanking Strike"] = 		{ class = "HUNTER", level = 10, }, --7n
	["Raptor Strike"] = 		{ class = "HUNTER", level = 10, }, --7n	
	["Wing Clip"] = 			{ class = "HUNTER", level = 10, }, --7n	
	["Survivalist"] = 			{ class = "HUNTER", level = 16, }, --7.1.5c	
	["Mongoose Bite"] = 		{ class = "HUNTER", level = 18, }, --7n	
	["Hatchet Toss"] = 			{ class = "HUNTER", level = 19, }, --7n	
	["Harpoon"] = 				{ class = "HUNTER", level = 22, }, --7n	
	["Muzzle"] = 				{ class = "HUNTER", level = 24, }, --7n
	["Lacerate"] = 				{ class = "HUNTER", level = 26, }, --7	
	["Aspect of the Eagle"] = 	{ class = "HUNTER", level = 44, }, --7n	
	["Explosive Trap"] = 		{ class = "HUNTER", level = 48, }, --7m	
	["Carve"] = 				{ class = "HUNTER", level = 54, }, --7n	
	["Hunting Companion"] = 	{ class = "HUNTER", level = 90, }, --7n
--++ Hunter Talents ++
	["Trailblazer"] = 			{ class = "HUNTER", level = 45, }, --7.1n
	["Posthaste"] = 			{ class = "HUNTER", level = 45, },
	--++ Beast Mastery/Marksmanship/Survival ++
	["A Murder of Crows"] = 	{ class = "HUNTER", level = 90, }, --??
	--++ Beast Mastery/Marksmanship ++
	["Farstrider"] = 			{ class = "HUNTER", level = 45, }, --7.1.5c 	
	["Binding Shot"] = 			{ class = "HUNTER", level = 75, }, 
	["Wyvern Sting"] = 			{ class = "HUNTER", level = 75, },	
	["Barrage"] = 				{ class = "HUNTER", level = 90, },
	["Volley"] = 				{ class = "HUNTER", level = 90, },	--7n
	--++ Beast Mastery/Survival ++
	["Aspect of the Beast"] = 	{ class = "HUNTER", level = 100, }, --7m
	--++ Marksmanship/Survival ++
	["Camouflage"] = 			{ class = "HUNTER", level = 75, }, --7m	
	--++ Beast Mastery ++	
	["Big Game Hunter"] = 		{ class = "HUNTER", level = 15, }, --7n		
	["Dire Stable"] = 			{ class = "HUNTER", level = 15, }, --7n	
	["Way of the Cobra"] = 		{ class = "HUNTER", level = 15, }, --7n		
	["Chimaera Shot"] = 		{ class = "HUNTER", level = 30, }, --7m
	["Dire Frenzy"] = 			{ class = "HUNTER", level = 30, }, --7n	
	["Stomp"] = 				{ class = "HUNTER", level = 30, }, --7n	
	["Bestial Fury"] = 			{ class = "HUNTER", level = 60, }, --7n	
	["Blink Strikes"] = 		{ class = "HUNTER", level = 60, },
	["One with the Pack"] = 	{ class = "HUNTER", level = 60, }, --7n		
	["Intimidation"] = 			{ class = "HUNTER", level = 75, },	
	["Killer Corba"] = 			{ class = "HUNTER", level = 100, }, --7n		
	["Stampede"] = 				{ class = "HUNTER", level = 100, }, --7m	
	--++ Marksmanship ++
	["Careful Aim"] = 			{ class = "HUNTER", level = 15, }, --7m	
	["Lone Wolf"] =		 		{ class = "HUNTER", level = 15, }, 	
	["Steady Focus"] = 			{ class = "HUNTER", level = 15, }, --7m
	["Black Arrow"] = 			{ class = "HUNTER", level = 30, }, --7m
	["Lock and Load"] = 		{ class = "HUNTER", level = 30, }, --7m
	["True Aim"] = 				{ class = "HUNTER", level = 30, }, --7n
	["Explosive Shot"] = 		{ class = "HUNTER", level = 60, }, --7m
	["Patient Sniper"] =		{ class = "HUNTER", level = 60, }, --7n
	["Sentinal"] = 				{ class = "HUNTER", level = 60, }, --7n	
	["Piercing Shot"] = 		{ class = "HUNTER", level = 100, }, --7m
	["Sidewinders"] = 			{ class = "HUNTER", level = 100, }, --7n
	["Trick Shot"] = 			{ class = "HUNTER", level = 100, }, --7n	
	--++ Survival ++
	["Animal Instincts"] = 		{ class = "HUNTER", level = 15, }, --7n	
	["Throwing Axes"] = 		{ class = "HUNTER", level = 15, }, --7n	
	["Way of the Mok'Nathal"] = { class = "HUNTER", level = 15, }, --7n	
	["A Murder of Crows"] = 	{ class = "HUNTER", level = 30, }, --7n
	["Mortal Wounds"] = 		{ class = "HUNTER", level = 30, }, --7n	
	["Snake Hunter"] = 			{ class = "HUNTER", level = 30, }, --7n	
	["Caltrops"] = 				{ class = "HUNTER", level = 60, }, --7n	
	["Improved Traps"] = 		{ class = "HUNTER", level = 60, }, --7n	
	["Steel Trap"] = 			{ class = "HUNTER", level = 60, }, --7n	
	["Ranger's Net"] = 			{ class = "HUNTER", level = 75, }, --7n	
	["Sticky Bomb"] = 			{ class = "HUNTER", level = 75, }, --7n	
	["Butchery"] = 				{ class = "HUNTER", level = 90, }, --7n		
	["Dragonsfire Grenade"] = 	{ class = "HUNTER", level = 90, }, --7n	
	["Serpent Sting"] = 		{ class = "HUNTER", level = 90, }, --7m	
	["Expert Trapper"] = 		{ class = "HUNTER", level = 100, }, --7n		
	["Spitting Cobra"] = 		{ class = "HUNTER", level = 100, }, --7n	
--++ Hunter PvP Talents ++
	["Master's Call"] = 		{ class = "HUNTER", level = 100, }, --7n
	["Spider Sting"] = 			{ class = "HUNTER", level = 100, }, --7n
	["Sniper Shot"] = 			{ class = "HUNTER", level = 100, }, --7n
	["Interlope"] = 			{ class = "HUNTER", level = 100, }, --7.2.5n	
	["Dire Beast: Basilisk"] = 	{ class = "HUNTER", level = 100, }, --7n
	["Dire Beast: Hawk"] = 		{ class = "HUNTER", level = 100, }, --7n
--	["Freezing Arrow"] = 		{ class = "HUNTER", level = 100, }, --7.1.5r
	["Hi-Explosive Trap"] = 	{ class = "HUNTER", level = 100, }, --7.1.5n	
	["Tracker's Net"] = 		{ class = "HUNTER", level = 100, }, --7n
	["Mending Bandage"] = 		{ class = "HUNTER", level = 100, }, --7n
	["Scatter Shot"] = 			{ class = "HUNTER", level = 100, }, --7n

--++ Mage Abilities ++
	["Illusion"] = 				{ class = "MAGE", level = 1, }, --7n?? Honor
	["Frost Nova"] = 			{ class = "MAGE", level = 3, },
	["Blink"] = 				{ class = "MAGE", level = 7, },
	["Polymorph"] = 			{ class = "MAGE", level = 18, },
	["Conjure Refreshment"] = 	{ class = "MAGE", level = 22, },
	["Slow Fall"] = 			{ class = "MAGE", level = 32, },
	["Water Jet"] = 			{ class = "MAGE", level = 32, }, --7n	
	["Counterspell"] = 			{ class = "MAGE", level = 34, },
	["Ice Block"] = 			{ class = "MAGE", level = 26, }, --7.1.5m	
	["Arcane Linguist"] = 		{ class = "MAGE", level = 58, }, --7n	
	["Time Warp"] = 			{ class = "MAGE", level = 65, },	
	["Spellsteal"] = 			{ class = "MAGE", level = 72, },
	["Portal: Darnassus"] = 	{ class = "MAGE", level = 42, },
	["Portal: Exodar"] = 		{ class = "MAGE", level = 42, },
	["Portal: Ironforge"] = 	{ class = "MAGE", level = 42, },
	["Portal: Orgrimmar"] = 	{ class = "MAGE", level = 42, },
	["Portal: Silvermoon"] = 	{ class = "MAGE", level = 42, },
	["Portal: Stormwind"] = 	{ class = "MAGE", level = 42, },
	["Portal: Theramore"] = 	{ class = "MAGE", level = 42, },
	["Portal: Thunder Bluff"] =	{ class = "MAGE", level = 42, },
	["Portal: Undercity"] = 	{ class = "MAGE", level = 42, },	
	["Portal: Stonard"] = 		{ class = "MAGE", level = 52, },	
	["Portal: Shattrath"] = 	{ class = "MAGE", level = 66, },	
	["Ancient Portal: Dalaran"] = { class = "MAGE", level = 74, }, 
	["Portal: Dalaran - Broken Isles"] = { class = "MAGE", level = 74, }, --7n	
	["Portal: Dalaran - Northrend"] = { class = "MAGE", level = 74, }, --7n	
	["Portal: Tol Barad"] = 	{ class = "MAGE", level = 85, },
	["Portal: Vale of Eternal Blossoms"] = { class = "MAGE", level = 90, },
	["Portal: Stormshield"] = 	{ class = "MAGE", level = 92, }, --7n	
	["Portal: Warspear"] = 	{ class = "MAGE", level = 92, }, --7n	
	["Teleport: Hall of the Guardian"] = { class = "MAGE", level = 14, }, --7n
	["Teleport: Darnassus"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Exodar"] = 		{ class = "MAGE", level = 17, },
	["Teleport: Ironforge"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Orgrimmar"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Silvermoon"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Stormwind"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Theramore"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Thunder Bluff"] = { class = "MAGE", level = 17, },
	["Teleport: Undercity"] = 	{ class = "MAGE", level = 17, },
	["Teleport: Stonard"] = 	{ class = "MAGE", level = 52, },	
	["Teleport: Shattrath"] = 	{ class = "MAGE", level = 62, },
	["Ancient Teleport: Dalaran"] = { class = "MAGE", level = 71, }, 
	["Teleport: Dalaran - Broken Isles"] = 	{ class = "MAGE", level = 71, }, --7n
	["Teleport: Dalaran - Northrend"] = 	{ class = "MAGE", level = 71, }, --7n	
	["Teleport: Tol Barad"] = 	{ class = "MAGE", level = 85, },
	["Teleport: Vale of Eternal Blossoms"] = { class = "MAGE", level = 90, }, 
	["Teleport: Stormshield"] = { class = "MAGE", level = 92, }, --7n	
	["Teleport: Warspear"] = 	{ class = "MAGE", level = 92, }, --7n	
--++ Mage Artifact Traits ++
	["Mark of Aluneth"] = 		{ class = "MAGE", level = 100, }, --7n
	["Phoenix Flames"] = 		{ class = "MAGE", level = 100, }, --7n
	["Ebonbolt"] = 				{ class = "MAGE", level = 100, }, --7n
--++ Mage Specialization ++
	--++ Fire/Frost ++ 
	["Invisibility"] = 			{ class = "MAGE", level = 50, }, --7m
	--++ Arcane ++
	["Arcane Blast"] = 			{ class = "MAGE", level = 10, }, 
	["Arcane Barrage"] = 		{ class = "MAGE", level = 10, },	
	["Arcane Charge"] = 		{ class = "MAGE", level = 10, }, --7??
	["Arcane Missiles"] = 		{ class = "MAGE", level = 14, },
	["Displacement"] = 			{ class = "MAGE", level = 24, }, --7n
	["Prismatic Barrier"] = 	{ class = "MAGE", level = 26, }, --7.1.5n	
	["Arcane Explosion"] = 		{ class = "MAGE", level = 28, }, --x Moved
	["Slow"] = 					{ class = "MAGE", level = 36, },
	["Evocation"] = 			{ class = "MAGE", level = 40, }, --x Moved
	["Arcane Power"] = 			{ class = "MAGE", level = 44, },
	["Greater Invisibility"] = 	{ class = "MAGE", level = 50, }, --7m
	["Presence of Mind"] = 		{ class = "MAGE", level = 15, }, --7.1.5m	
--	["Mage Armor"] = 			{ class = "MAGE", level = 56, }, --7.1.5r
	["Savant"] =			 	{ class = "MAGE", level = 78, }, --7n	
	--++ Fire ++ 
 	["Critical Mass"] = 		{ class = "MAGE", level = 10, }, --7.1.5m
	["Fireball"] = 				{ class = "MAGE", level = 10, },
	["Pyroblast"] = 			{ class = "MAGE", level = 10, },
	["Fire Blast"] = 			{ class = "MAGE", level = 11, }, --7m
	["Hot Streak"] = 			{ class = "MAGE", level = 12, }, --7n
	["Enhanced Pyrotechnics"] = { class = "MAGE", level = 14, }, --7n	
	["Dragon's Breath"] = 		{ class = "MAGE", level = 24, }, 
	["Blazing Barrier"] = 		{ class = "MAGE", level = 26, }, --7.1.5 	
	["Combustion"] = 			{ class = "MAGE", level = 28, },
	["Molten Armor"] = 			{ class = "MAGE", level = 36, },
	["Scorch"] = 				{ class = "MAGE", level = 40, }, 	
	["Flamestrike"] = 			{ class = "MAGE", level = 44, }, --x Moved	
	["Cauterize"] = 			{ class = "MAGE", level = 52, }, --7.1.5m	
	["Ignite"] = 				{ class = "MAGE", level = 80, },
	--++ Frost ++ 
	["Frostbolt"] = 			{ class = "MAGE", level = 1, },
	["Ice Lance"] = 			{ class = "MAGE", level = 5, }, --x Moved
	["Summon Water Elemental"] = { class = "MAGE", level = 10, },
	["Shatter"] = 				{ class = "MAGE", level = 12, }, --x Moved
--	["Flurry"] = 				{ class = "MAGE", level = 12, }, 7n Conflict
	["Fingers of Frost"] = 		{ class = "MAGE", level = 24, },
	["Ice Barrier"] = 			{ class = "MAGE", level = 16, }, --7.1.5m		
	["Brain Freeze"] = 			{ class = "MAGE", level = 28, },
	["Cone of Cold"] = 			{ class = "MAGE", level = 28, }, --7m	
	["Icy Veins"] = 			{ class = "MAGE", level = 40, },
	["Blizzard"] = 				{ class = "MAGE", level = 44, }, --x Moved
	["Cold Snap"] = 			{ class = "MAGE", level = 30, }, --7.1.5m	
--	["Frost Armor"] = 			{ class = "MAGE", level = 56, }, --7.1.5r
	["Icicles"] = 				{ class = "MAGE", level = 78, },	
	["Frozen Orb"] = 			{ class = "MAGE", level = 83, },
--++ Mage Talents ++
	["Shimmer"] = 				{ class = "MAGE", level = 30, }, --7n
	["Incanter's Flow"] = 		{ class = "MAGE", level = 45, }, --7n 
	["Mirror Image"] = 			{ class = "MAGE", level = 45, }, 
	["Rune of Power"] = 		{ class = "MAGE", level = 45, }, 
	["Ice Ward"] = 				{ class = "MAGE", level = 75, }, 	
	["Ring of Frost"] = 		{ class = "MAGE", level = 75, }, 
	["Unstable Magic"] = 		{ class = "MAGE", level = 90, }, 	
	--++ Arcane ++
	["Amplification"] = 		{ class = "MAGE", level = 15, }, --7.1.5n
	["Arcane Familiar"] = 		{ class = "MAGE", level = 15, }, --7n	
	["Words of Power"] = 		{ class = "MAGE", level = 15, }, --7n
	["Mana Shield"] = 			{ class = "MAGE", level = 30, }, --7.1.5n
	["Slipstream"] = 			{ class = "MAGE", level = 30, }, --7.1.5n	
	["Charged Up"] = 			{ class = "MAGE", level = 60, }, --7n	
	["Resonance"] = 			{ class = "MAGE", level = 60, }, --7n	
	["Supernova"] = 			{ class = "MAGE", level = 60, }, --x
	["Chrono Shift"] = 			{ class = "MAGE", level = 75, }, --7.1.5n
	["Erosion"] = 				{ class = "MAGE", level = 90, }, --7n	
	["Nether Tempest"] = 		{ class = "MAGE", level = 90, }, --7n	
	["Arcane Orb"] = 			{ class = "MAGE", level = 100, }, --x
	["Overpowered"] = 			{ class = "MAGE", level = 100, }, --x
--	["Quickening"] = 			{ class = "MAGE", level = 100, }, --7.1.5r
	["Temporal Flux"] = 		{ class = "MAGE", level = 100, }, --7.1.5n	
	--++ Fire ++ 
	["Conflagration"] =			{ class = "MAGE", level = 15, }, --7n
	["Firestarter"] =			{ class = "MAGE", level = 15, }, --7n	
	["Pyromaniac"] = 			{ class = "MAGE", level = 15, }, --7m
	["Blast Wave"] = 			{ class = "MAGE", level = 30, }, --7.1.5m
	["Blazing Soul"] = 			{ class = "MAGE", level = 30, }, --7.1.5n	
	["Alexstrasza's Fury"] = 	{ class = "MAGE", level = 60, }, --7.1.5n	
	["Controlled Burn"] =		{ class = "MAGE", level = 60, }, --7n
	["Flame On"] =				{ class = "MAGE", level = 60, }, --7n
	["Frenetic Speed"] = 		{ class = "MAGE", level = 75, }, --7.1.5n		
	["Flame Patch"] =			{ class = "MAGE", level = 90, }, --7n	
	["Living Bomb"] = 			{ class = "MAGE", level = 90, },
	["Cinderstorm"] =			{ class = "MAGE", level = 100, }, --7n
	["Kindling"] = 				{ class = "MAGE", level = 100, }, --x
	["Meteor"] = 				{ class = "MAGE", level = 100, }, --x
	--++ Frost ++ 
	["Bone Chilling"] =			{ class = "MAGE", level = 15, }, --7n
	["Lonely Winter"] =			{ class = "MAGE", level = 15, }, --7n	
	["Ray of Frost"] =			{ class = "MAGE", level = 15, }, --7n
	["Glacial Insulation"] = 	{ class = "MAGE", level = 30, }, --7.1.5n
	["Ice Floes"] = 			{ class = "MAGE", level = 30, }, --7.1.5m	
	["Frozen Touch"] =			{ class = "MAGE", level = 60, }, --7n	
	["Ice Nova"] =	 			{ class = "MAGE", level = 60, }, --x
	["Frigid Winds"] = 			{ class = "MAGE", level = 75, }, --7.1.5n	
	["Arctic Gale"] =			{ class = "MAGE", level = 90, }, --7n 	
	["Frost Bomb"] = 			{ class = "MAGE", level = 90, },
	["Comet Storm"] = 			{ class = "MAGE", level = 100, }, --x
	["Glacial Spike"] =			{ class = "MAGE", level = 100, }, --7n	
	["Thermal Void"] = 			{ class = "MAGE", level = 100, }, --x
--++ Mage PvP Talents ++
	["Temporal Shield"] = 		{ class = "MAGE", level = 100, }, --7n
	["Ice Form"] = 				{ class = "MAGE", level = 100, }, --7n
	["Mass Invisibility"] = 	{ class = "MAGE", level = 100, }, --7n
	["Greater Pyroblast"] = 	{ class = "MAGE", level = 100, }, --7n

--++ Monk Abilities ++
--	["Parry"]   = 				{ class = "MONK", level = 1, },	Conflict
	["Tiger Palm"]   = 			{ class = "MONK", level = 1, },	
	["Zen Flight"] =   			{ class = "MONK", level = 1, },
	["Blackout Kick"]   = 		{ class = "MONK", level = 3, },
	["Roll"]   = 				{ class = "MONK", level = 5, }, 
 	["Provoke"]   = 			{ class = "MONK", level = 13, },  
 	["Resuscitate"]   = 		{ class = "MONK", level = 14, },
	["Zen Pilgrimage"]   = 		{ class = "MONK", level = 20, },  
	["Zen Pilgrimage: Return"] = { class = "MONK", level = 30, },
	["Crackling Jade Lightning"]  = { class = "MONK", level = 36, },  
	["Paralysis"]   = 			{ class = "MONK", level = 48, },  
	["Transcendence"]   = 		{ class = "MONK", level = 87, },  
	["Transcendence: Transfer"] = { class = "MONK", level = 87, },
--++ Monk Artifact Traits ++
	["Exploding Keg"] = 		{ class = "MONK", level = 100, }, --7n
	["Sheilun's Gift"] = 		{ class = "MONK", level = 100, }, --7n
	["Strike of the Windlord"] = { class = "MONK", level = 100, }, --7n
--++ Monk Specialization ++
	--++ Brewmaster/Mistweaver/Windwalker ++
	["Effuse"]   = 				{ class = "MONK", level = 8, },	--7n
	["Detox"]   = 				{ class = "MONK", level = 22, }, --7m
	--++ Brewmaster/Windwalker ++
--	["Critical Strikes"] =		{ class = "MONK", level = 1, }, --x Conflict
	["Spear Hand Strike"]   = 	{ class = "MONK", level = 32, }, --7m		
	--++ Mistweaver/Windwalker ++	
	["Rising Sun Kick"] = 		{ class = "MONK", level =  18, }, --7m	
	["Spinning Crane Kick"]   = { class = "MONK", level = 46, },  --7m	
	--++ Brewmaster ++ 
	["Blackout Strike"]   = 	{ class = "MONK", level = 3, },	 --7n
	["Keg Smash"]   = 			{ class = "MONK", level = 10, }, 
	["Stagger"]   = 			{ class = "MONK", level = 10, }, --7n	
	["Breath of Fire"]   = 		{ class = "MONK", level = 18, },
 	["Expel Harm"]   = 			{ class = "MONK", level = 26, }, --7m 	
 	["Ironskin Brew"]   = 		{ class = "MONK", level = 28, }, --7n
	["Gift of the Ox"]   = 		{ class = "MONK", level = 40, }, 
	["Celestial Fortune"]   = 	{ class = "MONK", level = 45, }, --7n
	["Purifying Brew"]   = 		{ class = "MONK", level = 54, }, 
	["Zen Meditation"]   = 		{ class = "MONK", level = 65, }, 	
	["Elusive Brawler"]   = 	{ class = "MONK", level = 78, },
	--++ Mistweaver ++ 	
	["Enveloping Mist"]   = 	{ class = "MONK", level = 10, },
	["Soothing Mist"]   = 		{ class = "MONK", level = 10, }, 
	["Teachings of the Monastery"] = { class = "MONK", level = 10, }, 	
	["Renewing Mist"]   = 		{ class = "MONK", level = 24, }, 
	["Life Cocoon"]   = 		{ class = "MONK", level = 28, }, 
	["Vivify"]   = 				{ class = "MONK", level = 32, }, --7n 	
	["Reawaken"]   = 			{ class = "MONK", level = 44, }, --7n 	
 	["Thunder Focus Tea"]   = 	{ class = "MONK", level = 54, },
	["Fortifying Brew"]   = 	{ class = "MONK", level = 55, }, --7.2m	
	["Essence Font"]   = 		{ class = "MONK", level = 58, }, --7.2m	
	["Revival"]   = 			{ class = "MONK", level = 65, }, 
	["Gust of Mist"]   = 		{ class = "MONK", level = 78, }, --7n 	
	--++ Windwalker ++ 
	["Stance of the Fierce Tiger"] = { class = "MONK", level = 1, }, --7n
	["Combo Breaker"] = 		{ class = "MONK", level =  10, },
	["Flying Serpent Kick"] = 	{ class = "MONK", level =  10, },	
	["Cyclone Strikes"] = 		{ class = "MONK", level =  12, }, --7n	
	["Windwalking"] = 			{ class = "MONK", level =  12, }, --7n	 
	["Combat Conditioning"] = 	{ class = "MONK", level =  20, }, 
	["Touch of Karma"] = 		{ class = "MONK", level =  24, }, 
	["Touch of Death"]   = 		{ class = "MONK", level = 24, }, --7m
	["Disable"]   = 			{ class = "MONK", level = 25, }, --x Moved	
	["Afterlife"] = 			{ class = "MONK", level =  26, }, 
	["Fists of Fury"] = 		{ class = "MONK", level =  28, }, 
	["Storm, Earth and Fire"] = { class = "MONK", level =  65, },
	["Combo Strikes"] = 		{ class = "MONK", level =  78, }, --7n	
--++ Monk Talents ++
	["Chi Burst"]  = 			{ class = "MONK", level = 15, },
	["Chi Wave"]  = 			{ class = "MONK", level = 15, },  --7.2m	
	["Celerity"]  = 			{ class = "MONK", level = 30, },  
	["Chi Torpedo"] = 			{ class = "MONK", level = 30, },  
	["Tiger's Lust"] =  		{ class = "MONK", level = 30, }, 
	["Leg Sweep"]  = 			{ class = "MONK", level = 60, }, 
	["Ring of Peace"]  = 		{ class = "MONK", level = 60, }, 
	["Dampen Harm"]  = 			{ class = "MONK", level = 75, },  
 	--++ Brewmaster/Windwalker ++
	["Eye of the Tiger"]  = 	{ class = "MONK", level = 15, }, --7n
	["Summon Black Ox Statue"] = { class = "MONK", level = 60, }, --7.1.5m	
	["Rushing Jade Wind"]  = 	{ class = "MONK", level = 90, },
	--++ Windwalker/Mistweaver ++ 	
	["Diffuse Magic"]  = 		{ class = "MONK", level = 75, }, --7.1.5m	
	--++ Brewmaster ++	
	["Black Ox Brew"]  = 		{ class = "MONK", level = 45, }, --7n
	["Gift of the Mists"]  = 	{ class = "MONK", level = 45, }, --7n
	["Light Brewing"]  = 		{ class = "MONK", level = 45, }, --7n
	["Mystic Vitality"]  = 		{ class = "MONK", level = 75, }, --7.1.5n	
	["Invoke Niuzao, the Black Ox"] = { class = "MONK", level = 90, }, --7n
	["Special Delivery"]  = 	{ class = "MONK", level = 90, }, --7n
	["Blackout Combo"]  = 		{ class = "MONK", level = 100, }, --7n
	["Elusive Dance"]  = 		{ class = "MONK", level = 100, }, --7n
	["High Tolerance"]  = 		{ class = "MONK", level = 100, }, --7n
	--++ Mistweaver ++ 
 --	["Mistwalk"] = 				{ class = "MONK", level = 15, }, --7.2r 
	["Zen Pulse"] = 			{ class = "MONK", level = 15, }, --7n
	["Lifecycles"] = 			{ class = "MONK", level = 45, }, --7n
	["Mist Wrap"] = 			{ class = "MONK", level = 45, }, --7n
	["Spirit of the Crane"] = 	{ class = "MONK", level = 45, }, --7n	
	["Song of Chi-Ji"] = 		{ class = "MONK", level = 60, }, --7n
	["Invoke Chi-Ji, the Red Crane"] = { class = "MONK", level = 90, }, --7n
	["Refreshing Jade Wind"] = 	{ class = "MONK", level = 90, }, --7n
	["Summon Jade Serpent Statue"] = { class = "MONK", level = 90, }, --7m
	["Focused Thunder"] = 		{ class = "MONK", level = 100, }, --7n	
	["Mana Tea"]   = 			{ class = "MONK", level = 100, }, --7m 	
	["Rising Thunder"] = 		{ class = "MONK", level = 100, }, --7n
	--++ Windwalker ++ 	
	["Ascension"]  = 			{ class = "MONK", level = 45, }, 	
	["Energizing Elixir"] = 	{ class = "MONK", level =  45, }, --7n
	["Power Strikes"]  = 		{ class = "MONK", level = 45, },
--	["Dizzying Kicks"]  = 		{ class = "MONK", level = 60, }, --7.1.5r
	["Hit Combo"]  =	 		{ class = "MONK", level = 90, }, --7n
	["Invoke Xuen, the White Tiger"] = { class = "MONK", level = 90, },
	["Chi Orbit"]  = 			{ class = "MONK", level = 100, }, --7n	
	["Serenity"] = 				{ class = "MONK", level = 100, }, --x
	["Whirling Dragon Punch"] = { class = "MONK", level = 100, }, --7n	
--++ Monk PvP Talents ++
	["Fortifying Brew"] = 		{ class = "MONK", level = 100, }, --7.2m
--	["Spinning Fire Blossom"] = { class = "MONK", level = 100, }, --7.2.5r
	["Tigereye Brew"] = 		{ class = "MONK", level = 100, }, --7.2.5n
	["Guard"] = 		 		{ class = "MONK", level = 100, }, --7n
	["Double Barrel"] = 		{ class = "MONK", level = 100, }, --7n
	["Mighty Ox Kick"] = 		{ class = "MONK", level = 100, }, --7n
	["Healing Sphere"] = 		{ class = "MONK", level = 100, }, --7n
	["Craft: Nimble Brew"] = 	{ class = "MONK", level = 100, }, --7n
	["Way of the Crane"] = 		{ class = "MONK", level = 100, }, --7n

--++ Paladin Abilities ++
--	["Block"] =			 		{ class = "PALADIN", level = 1, }, --7n Conflict
	["Boundless Conviction"] = 	{ class = "PALADIN", level = 1, },	
	["Crusader Strike"] = 		{ class = "PALADIN", level = 1, },
--	["Parry"]=					{ class = "PALADIN", level = 1, }, 7 Conflict	
	["Judgment"] = 				{ class = "PALADIN", level = 3, },	
	["Hand of Reckoning"] = 	{ class = "PALADIN", level = 13, }, --7n
	["Redemption"] = 			{ class = "PALADIN", level = 14, },
	["Divine Shield"] = 		{ class = "PALADIN", level = 18, },
	["Summon Exarch's Elekk"] = { class = "PALADIN", level = 20, },	--7n
	["Summon Sunwalker Kodo"] = { class = "PALADIN", level = 20, },	--7n
	["Summon Thalassian Warhorse"] = { class = "PALADIN", level = 20, }, --7n
	["Summon Warhorse"] = 		{ class = "PALADIN", level = 20, },	--7n	
	["Lay on Hands"] = 			{ class = "PALADIN", level = 22, },
	["Divine Steed"] = 			{ class = "PALADIN", level = 28, }, --7n Hotfix		
	["Contemplation"] = 		{ class = "PALADIN", level = 40, },
	["Heart of the Crusader"] = { class = "PALADIN", level = 40, },	
	["Summon Charger"] = 		{ class = "PALADIN", level = 40, },	--7n
	["Summon Great Exarch's Elekk"] = { class = "PALADIN", level = 40, }, --7n
	["Summon Great Sunwalker Kodo"] = { class = "PALADIN", level = 40, }, --7n
	["Summon Thalassian Charger"] = { class = "PALADIN", level = 40, }, --7n
	["Blessing of Freedom"] = 	{ class = "PALADIN", level = 52, },	--7n
--++ Paladin Artifact Traits ++
	["Eye of Tyr"] = 			{ class = "PALADIN", level = 100, }, --7n
	["Tyr's Deliverance"] = 	{ class = "PALADIN", level = 100, }, --7n
	["Wake of Ashes"] = 		{ class = "PALADIN", level = 100, }, --7n
--++ Paladin Specialization ++
	--++ Holy/Protection/Retribution ++	
	["Hammer of Justice"] = 	{ class = "PALADIN", level = 5, }, --7m
	["Flash of Light"] = 		{ class = "PALADIN", level = 8, }, --7m	
	["Blessing of Protection"] = { class = "PALADIN", level = 48, }, --7n
	["Avenging Wrath"] = 		{ class = "PALADIN", level = 72, }, --7m
	--++ Holy/Retribution ++	
	["Divine Protection"] = 	{ class = "PALADIN", level = 26, }, --7m	
	["Consecration"] = 			{ class = "PALADIN", level = 32, }, --7m	
	["Blessing of Sacrifice"] = { class = "PALADIN", level = 56, }, --7n
	--++ Protection/Retribution ++ 
	["Cleanse Toxins"] = 		{ class = "PALADIN", level = 21, }, --7n
	["Rebuke"] = 				{ class = "PALADIN", level = 36, }, --7m
	--++ Holy ++
	["Light of the Martyr"] =  	{ class = "PALADIN", level = 1, }, --7n??
	["Holy Shock"] = 			{ class = "PALADIN", level = 10, },
	["Cleanse"] = 				{ class = "PALADIN", level = 21, }, --7m
	["Beacon of Light"] = 		{ class = "PALADIN", level = 36, },
--	["Absolution"] = 			{ class = "PALADIN", level = 44, },	--7n Conflict
	["Infusion of Light"] = 	{ class = "PALADIN", level = 50, },
	["Righteousness"] = 		{ class = "PALADIN", level = 50, }, --7n
	["Holy Light"] = 			{ class = "PALADIN", level = 54, },
	["Light of Dawn"] = 		{ class = "PALADIN", level = 58, },
	["Aura Mastery"] = 			{ class = "PALADIN", level = 65, },	--7n
	["Lightbringer"] = 			{ class = "PALADIN", level = 78, },	--7n
	--++ Protection ++ 
	["Avenger's Shield"] = 		{ class = "PALADIN", level = 10, },
	["Guarded by the Light"] = 	{ class = "PALADIN", level = 10, },
	["Hammer of the Righteous"] = { class = "PALADIN", level = 10, },	
	["Righteous Fury"] = 		{ class = "PALADIN", level = 10, }, --7m
	["Sanctuary"] = 			{ class = "PALADIN", level = 10, },	
	["Light of the Protector"] = { class = "PALADIN", level = 12, }, --7n
	["Judgments of the Wise"] = { class = "PALADIN", level = 28, },
	["Shield of the Righteous"] = { class = "PALADIN", level = 38, },
	["Grand Crusader"] = 		{ class = "PALADIN", level = 50, },
	["Ardent Defender"] = 		{ class = "PALADIN", level = 65, },	
--	["Riposte"] =		 		{ class = "PALADIN", level = 76, }, --7 Conflict
	["Divine Bulwark"] = 		{ class = "PALADIN", level = 78, },
	["Guardian of the Ancient Kings"] = { class = "PALADIN", level = 83, },		
	--++ Retribution ++  
	["Templar's Verdict"] = 	{ class = "PALADIN", level = 10, },
--	["Sword of Light"] = 		{ class = "PALADIN", level = 12, }, -- removed
	["Blade of Justice"] = 		{ class = "PALADIN", level = 16, }, --7n
	["Shield of Vengeance"] = 	{ class = "PALADIN", level = 24, }, --7n	
	["Hand of Hindrance"] = 	{ class = "PALADIN", level = 26, }, --7n
	["Divine Storm"] = 			{ class = "PALADIN", level = 32, },
--	["Greater Blessing of Might"] = { class = "PALADIN", level = 42, }, --7.1.5r
	["Greater Blessing of Kings"] = { class = "PALADIN", level = 44, }, --7n	
	["Greater Blessing of Wisdom"] = { class = "PALADIN", level = 46, }, --7n
	["Retribution"] =			{ class = "PALADIN", level = 56, }, --7n
	["Divine Judgment"] =		{ class = "PALADIN", level = 78, }, --7n
--++ Paladin Talents ++
--	["Cavalier"] = 				{ class = "PALADIN", level = 30, }, --7n hotfix 60 Prot, 90 Ret
	["Blinding Light"] = 		{ class = "PALADIN", level = 45, }, 
	["Repentance"] = 			{ class = "PALADIN", level = 45, },
	["Judgment of Light"] = 	{ class = "PALADIN", level = 90, }, --7.1.5m	
	--++ Holy/Protection ++ 
	["Fist of Justice"] = 		{ class = "PALADIN", level = 45, }, --7.1.5m
	--++ Holy ++	
	["Bestow Faith"] = 			{ class = "PALADIN", level = 15, },	--7n
	["Crusader's Might"] = 		{ class = "PALADIN", level = 15, },	--7n
	["Light's Hammer"] = 		{ class = "PALADIN", level = 15, },
	["Rule of Law"] =			{ class = "PALADIN", level = 30, },	--7n
	["Unbreakable Spirit"] =	{ class = "PALADIN", level = 30, },
	["Aura of Mercy"] = 		{ class = "PALADIN", level = 60, }, --7n	
	["Aura of Sacrifice"] = 	{ class = "PALADIN", level = 60, }, --7n	
	["Devotion Aura"] = 		{ class = "PALADIN", level = 60, }, --7m
	["Divine Purpose"] = 		{ class = "PALADIN", level = 75, }, --7??
	["Holy Avenger"] = 			{ class = "PALADIN", level = 75, },
	["Holy Prism"] = 			{ class = "PALADIN", level = 75, },
	["Fervent Martyr"] = 		{ class = "PALADIN", level = 90, }, --7n
	["Sanctified Wrath"] = 		{ class = "PALADIN", level = 90, },	
	["Beacon of Faith"] =		{ class = "PALADIN", level = 100, }, --x
	["Beacon of the Lightbringer"] = { class = "PALADIN", level = 100, }, --7n
	["Beacon of Virtue"] =		{ class = "PALADIN", level = 100, }, --7n
	--++ Protection ++ 
	["Bastion of Light"] = 		{ class = "PALADIN", level = 15, },	--7n
	["Crusader's Judgment"] = 	{ class = "PALADIN", level = 15, },	--7n
	["First Avenger"] = 		{ class = "PALADIN", level = 15, },	--7n
	["Blessed Hammer"] = 		{ class = "PALADIN", level = 30, },	--7n
	["Consecrated Hammer"] = 	{ class = "PALADIN", level = 30, },	--7n
	["Holy Shield"] = 			{ class = "PALADIN", level = 30, }, --x
	["Blessing of Salvation"] = { class = "PALADIN", level = 60, },	--7n
	["Blessing of Spellwarding"] =  { class = "PALADIN", level = 60, },	--7n
	["Retribution Aura"] = 		{ class = "PALADIN", level = 60, },	--7n
	["Final Stand"] = 			{ class = "PALADIN", level = 75, },	--7n
	["Hand of the Protector"] = { class = "PALADIN", level = 75, },	--7n	
	["Knight Templar"] = 		{ class = "PALADIN", level = 75, },	--7n
	["Aegis of Light"] = 		{ class = "PALADIN", level = 90, },	--7n
	["Consecrated Ground"] = 	{ class = "PALADIN", level = 90, },	--7n
	["Last Defender"] = 		{ class = "PALADIN", level = 100, }, --7n
	["Righteous Protector"] = 	{ class = "PALADIN", level = 100, }, --7n 	
	["Seraphim"] = 				{ class = "PALADIN", level = 100, }, --x
	--++ Retribution ++ 	
	["Consecration"] = 			{ class = "PALADIN", level = 15, }, --7n
	["Execution Sentence"] = 	{ class = "PALADIN", level = 15, },	
	["Final Verdict"] = 		{ class = "PALADIN", level = 15, }, --7n
	["Greater Judgment"] = 		{ class = "PALADIN", level = 30, }, --7n
	["The Fires of Justice"] = 	{ class = "PALADIN", level = 30, }, --7n
	["Zeal"] = 					{ class = "PALADIN", level = 30, }, --7n
	["Fist of Justice"] = 		{ class = "PALADIN", level = 45, }, --7.1.5n	
	["Blade of Wrath"] = 		{ class = "PALADIN", level = 60, }, --7n
	["Divine Hammer"] = 		{ class = "PALADIN", level = 60, }, --7n
	["Virtue's Blade"] = 		{ class = "PALADIN", level = 60, }, --7n
	["Eye for an Eye"] = 		{ class = "PALADIN", level = 75, }, --7n
	["Justicar's Vengeance"] = 	{ class = "PALADIN", level = 75, }, --7n
	["Word of Glory"] = 		{ class = "PALADIN", level = 75, }, --7n
	["Divine Intervention"] = 	{ class = "PALADIN", level = 90, }, --7n
	["Judgement of Light"] = 	{ class = "PALADIN", level = 90, }, --7.1.5n	
--	["Seal of Light"] = 		{ class = "PALADIN", level = 90, }, --7.1.5r
	["Crusade"] = 				{ class = "PALADIN", level = 100, }, --7n	
	["Divine Purpose"] = 	 	{ class = "PALADIN", level = 100, }, --7n	
	["Holy Wrath"] = 			{ class = "PALADIN", level = 100, }, --7m
--++ Paladin PvP Talents ++
	["Hammer of Reckoning"] = 	{ class = "PALADIN", level = 100, }, --7n
	["Blessing of Sanctuary"] = { class = "PALADIN", level = 100, }, --7n
	["Divine Favor"] = 			{ class = "PALADIN", level = 100, }, --7n
	["Shield of Virtue"] = 		{ class = "PALADIN", level = 100, }, --7n
	["Avenging Crusader"] = 	{ class = "PALADIN", level = 100, }, --7n
	["Guardian of the Forgotten Queen"] = { class = "PALADIN", level = 100, }, --7n

--++ Priest Abilities ++
	["The Penitent"] = 			{ class = "PRIEST", level = 1, }, --7.2.5m
	["Smite"] = 				{ class = "PRIEST", level = 1, },
	["Power Word: Barrier"] = 	{ class = "PRIEST", level = 5, }, --7m??
	["Resurrection"] = 			{ class = "PRIEST", level = 14, },
	["Dispel Magic"] = 			{ class = "PRIEST", level = 26, },
	["Shackle Undead"] = 		{ class = "PRIEST", level = 32, },
	["Mind Control"] = 			{ class = "PRIEST", level = 36, }, --7m
	["Fade"] = 					{ class = "PRIEST", level = 38, },
	["Mass Dispel"] = 			{ class = "PRIEST", level = 72, },
--++ Priest Artifact Traits ++
	["Light of T'uure"] = 		{ class = "PRIEST", level = 100, }, --7n
	["Light's Wrath"] = 		{ class = "PRIEST", level = 100, }, --7n
	["Void Torrent"] = 			{ class = "PRIEST", level = 100, }, --7n
--++ Priest Specialization ++
	--++ Discipline/Holy/Shadow ++
	["Levitate"] = 				{ class = "PRIEST", level = 28, }, --7m	
	--++ Discipline/Holy ++
	["Purify"] = 				{ class = "PRIEST", level = 22, },
	["Focused Will"] = 			{ class = "PRIEST", level = 34, },
	["Mass Resurrection"] = 	{ class = "PRIEST", level = 44, }, --7n
	["Leap of Faith"] = 		{ class = "PRIEST", level = 83, }, --7m
	--++ Discipline/Shadow ++
	["Shadow Mend"] = 			{ class = "PRIEST", level = 1, }, --7n		
	["Shadow Word: Pain"] = 	{ class = "PRIEST", level = 3, }, --7m
	["Power Word: Shield"] = 	{ class = "PRIEST", level = 5, }, --7m	
	["Psychic Scream"] = 		{ class = "PRIEST", level = 12, }, --7m
	["Shadowfiend"] = 			{ class = "PRIEST", level = 42, }, --7m	
	["Mind Vision"] = 			{ class = "PRIEST", level = 42, }, --7m	
	--++ Discipline ++
	["Plea"] = 					{ class = "PRIEST", level = 7, }, --7n	
	["Penance"] = 				{ class = "PRIEST", level = 10, },
	["Atonement"] = 			{ class = "PRIEST", level = 24, },
	["Power Word: Radiance"] = 	{ class = "PRIEST", level = 46, }, --7n	
	["Rapture"] = 				{ class = "PRIEST", level = 50, },	
	["Pain Suppression"] = 		{ class = "PRIEST", level = 56, },
	--++ Holy ++
	["Flash Heal"] = 			{ class = "PRIEST", level = 10, }, --7m
	["Renew"] = 				{ class = "PRIEST", level = 10, }, 
	["Holy Fire"] = 			{ class = "PRIEST", level = 18, }, --7m	
	["Holy Word: Serenity"] = 	{ class = "PRIEST", level = 18, }, --7n	
	["Holy Word: Chastise"] = 	{ class = "PRIEST", level = 24, },
	["Spirit of Redemption"] = 	{ class = "PRIEST", level = 29, },
	["Heal"] = 					{ class = "PRIEST", level = 34, },
	["Prayer of Healing"] = 	{ class = "PRIEST", level = 40, },
	["Serendipity"] = 			{ class = "PRIEST", level = 42, },	
	["Holy Word: Sanctify"] = 	{ class = "PRIEST", level = 50, }, --7n
	["Desperate Prayer"] = 		{ class = "PRIEST", level = 52, }, --7.1.5m
	["Guardian Spirit"] = 		{ class = "PRIEST", level = 54, },	
	["Prayer of Mending"] = 	{ class = "PRIEST", level = 58, }, --7m	
	["Holy Nova"] = 			{ class = "PRIEST", level = 65, },
	["Divine Hymn"] = 			{ class = "PRIEST", level = 76, },
	["Echo of Light"] = 		{ class = "PRIEST", level = 78, },
	--++ Shadow ++
	["Mind Flay"] = 			{ class = "PRIEST", level = 10, },
	["Void Bolt"] = 			{ class = "PRIEST", level = 10, }, --7n
	["Void Eruption"] = 		{ class = "PRIEST", level = 10, }, --7n
	["Voidform"] = 				{ class = "PRIEST", level = 10, }, --7n
	["Shadowform"] = 			{ class = "PRIEST", level = 12, }, --7.1n
	["Mind Blast"] = 			{ class = "PRIEST", level = 16, }, 
	["Purify Disease"] = 		{ class = "PRIEST", level = 22, }, --7n
	["Vampiric Touch"] = 		{ class = "PRIEST", level = 24, },
	["Mind Sear"] = 			{ class = "PRIEST", level = 76, }, --7m	
	["Shadow Word: Death"] = 	{ class = "PRIEST", level = 28, }, --7??	
	["Shadowy Apparitions"] = 	{ class = "PRIEST", level = 34, },
	["Silence"] = 				{ class = "PRIEST", level = 50, },
	["Dispersion"] = 			{ class = "PRIEST", level = 58, },
	["Vampiric Embrace"] = 		{ class = "PRIEST", level = 65, },
	["Madness"] = 				{ class = "PRIEST", level = 78, }, --7n	
--++ Priest Talents ++
	--++ Discipline/Holy ++	
	["Angelic Feather"] = 		{ class = "PRIEST", level = 30, },	
	["Shining Force"] = 		{ class = "PRIEST", level = 45, }, --7n	
	["Divine Star"] = 			{ class = "PRIEST", level = 90, },	
	["Halo"] = 					{ class = "PRIEST", level = 90, },	
	--++ Discipline/Shadow ++	
	["Body and Soul"] = 		{ class = "PRIEST", level = 30, },
	["Masochism"] = 			{ class = "PRIEST", level = 30, }, --7n	
	["Dominate Mind"] = 		{ class = "PRIEST", level = 45, },
	["Psychic Voice"] = 		{ class = "PRIEST", level = 45, }, --7n
	["Mindbender"] = 			{ class = "PRIEST", level = 60, },	
	["Power Infusion"] = 		{ class = "PRIEST", level = 75, },
	--++ Discipline ++	
	["Castigation"] = 			{ class = "PRIEST", level = 15, }, --7n
	["Schism"] = 				{ class = "PRIEST", level = 15, }, --7n
	["Power Word: Solace"] = 	{ class = "PRIEST", level = 60, }, --7n
	["Shield Discipline"] = 	{ class = "PRIEST", level = 60, }, --7n
--	["Contrition"] = 			{ class = "PRIEST", level = 75, }, --7.2.5r
	["Clarity of Will"] = 		{ class = "PRIEST", level = 75, }, --7.2.5m
	["Sanctuary"] = 			{ class = "PRIEST", level = 75, }, --7.2.5n	
	["Shadow Covenant"] = 		{ class = "PRIEST", level = 75, }, --7.2.5m
	["Purge the Wicked"] = 		{ class = "PRIEST", level = 90, }, --7.2.5m	
	["Grace"] = 				{ class = "PRIEST", level = 100, }, --7
	["Evangelism"] = 			{ class = "PRIEST", level = 100, }, --7.2.5n	
	--++ Shadow ++	
	["Twist of Fate"] = 		{ class = "PRIEST", level = 75, },		
	--++ Holy ++
	["Enduring Renewal"] = 		{ class = "PRIEST", level = 15, }, --7n
	["Enlightenment"] = 		{ class = "PRIEST", level = 15, }, --7m
	["Trail of Light"] = 		{ class = "PRIEST", level = 15, }, --7n
	["Body and Mind"] = 		{ class = "PRIEST", level = 30, }, --7n
	["Perseverance"] = 			{ class = "PRIEST", level = 30, }, --7.1.5n
	["Afterlife"] = 			{ class = "PRIEST", level = 45, }, --7n
	["Censure"] = 				{ class = "PRIEST", level = 45, }, --7n
	["Guardian Angel"] = 		{ class = "PRIEST", level = 60, }, --7n	
	["Light of the Naaru"] =	{ class = "PRIEST", level = 60, }, --7n	
	["Symbol of Hope"] = 		{ class = "PRIEST", level = 60, }, --7n	
	["Binding Heal"] = 			{ class = "PRIEST", level = 75, }, --7m
	["Piety"] = 				{ class = "PRIEST", level = 75, }, --7n	
	["Surge of Light"] = 		{ class = "PRIEST", level = 75, }, --7n
	["Divinity"] = 				{ class = "PRIEST", level = 90, }, --7n
	["Apotheosis"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Benediction"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Circle of Healing"] = 	{ class = "PRIEST", level = 100, }, --7m
	--++ Shadow ++
	["Fortress of the Mind"] = 	{ class = "PRIEST", level = 15, }, --7n
	["Shadow Word: Void"] = 	{ class = "PRIEST", level = 15, }, --7n
	["Mania"] = 				{ class = "PRIEST", level = 30, }, --7n
--	["Mind Bomb"] = 			{ class = "PRIEST", level = 45, }, --7.1.5r
	["Lingering Insanity"] = 	{ class = "PRIEST", level = 60, }, --7.1.5n	
	["Reaper of Souls"] = 		{ class = "PRIEST", level = 60, }, --7n
--	["Void Lord"] = 			{ class = "PRIEST", level = 60, }, --7.1.5r
	["Void Ray"] = 				{ class = "PRIEST", level = 60, }, --7n
	["Auspicious Spirits"] = 	{ class = "PRIEST", level = 75, }, 
	["San'layn"] = 				{ class = "PRIEST", level = 75, }, --7n
	["Shadowy Insight"] = 		{ class = "PRIEST", level = 75, }, --7n
	["Misery"] = 				{ class = "PRIEST", level = 90, }, --7.1.5n	
	["Shadow Crash"] = 			{ class = "PRIEST", level = 100, }, --7.1.5m
	["Legacy of the Void"] = 	{ class = "PRIEST", level = 100, }, --7n
--	["Mind Spike"] = 			{ class = "PRIEST", level = 100, }, --7.1.5r
	["Surrender to Madness"] = 	{ class = "PRIEST", level = 100, }, --7n
--++ Priest PvP Talents ++
	["Void Shift"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Inner Focus"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Ray of Hope"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Archangel"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Premonition"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Psyfiend"] = 				{ class = "PRIEST", level = 100, }, --7n
	["Power Word: Fortitude"] = { class = "PRIEST", level = 100, }, --7n
	["Greater Fade"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Holy Ward"] = 			{ class = "PRIEST", level = 100, }, --7n
	["Spirit of the Redeemer"] = { class = "PRIEST", level = 100, }, --7n

--++ Rogue Abilities ++
--	["Critical Strikes"] = 		{ class = "DRUID", level = 1, }, --x Conflict
	["Detection"] = 			{ class = "ROGUE", level = 1, }, --7m
--	["Parry"]=					{ class = "ROGUE", level = 1, }, 7 Conflict		
	["Crimson Vial"] = 			{ class = "ROGUE", level = 14, }, --7n	
	["Kick"] = 					{ class = "ROGUE", level = 18, },
	["Pick Lock"] = 			{ class = "ROGUE", level = 24, },
	["Sprint"] = 				{ class = "ROGUE", level = 26, },
	["Detect Traps"] = 			{ class = "ROGUE", level = 42, },
	["Cloak of Shadows"] = 		{ class = "ROGUE", level = 58, },
	["Fleet Footed"] = 			{ class = "ROGUE", level = 62, },
	["Safe Fall"] = 			{ class = "ROGUE", level = 48, }, 	
	["Fan of Knives"] = 		{ class = "ROGUE", level = 66, }, --7??
	["Tricks of the Trade"] = 	{ class = "ROGUE", level = 78, },
--++ Rogue Artifact Traits ++
	["Curse of the Dreadblades"] = { class = "ROGUE", level = 100, }, --7n
	["Goremaw's Bite"] = 		{ class = "ROGUE", level = 100, }, --7n
	["Kingsbane"] = 			{ class = "ROGUE", level = 100, }, --7n
--++ Rogue Specialization ++
	--++ Assassination/Outlaw/Subtlety ++  
	["Stealth"] = 				{ class = "ROGUE", level = 5, }, --7m	
	["Sap"] = 					{ class = "ROGUE", level = 12, }, --7m
	["Pick Pocket"] = 			{ class = "ROGUE", level = 16, }, --7m
	["Blind"] = 				{ class = "ROGUE", level = 24, }, --7.1.5m		
	["Distract"] = 				{ class = "ROGUE", level = 28, }, --7m	
	["Cheap Shot"] = 			{ class = "ROGUE", level = 30, }, --7m	
	["Vanish"] = 				{ class = "ROGUE", level = 32, }, --7m	
	--++ Assassination/Subtlety ++  
	["Evasion"] = 				{ class = "ROGUE", level = 8, }, --7m	
	["Shadowstep"] = 			{ class = "ROGUE", level = 13, }, --7m
	["Kidney Shot"] = 			{ class = "ROGUE", level = 40, }, --7m	
	--++ Assassination ++  
	["Mutilate"] = 				{ class = "ROGUE", level = 1, },
	["Deadly Poison"] = 		{ class = "ROGUE", level = 2, }, --7m
	["Envenom"] = 				{ class = "ROGUE", level = 3, },
	["Assassin's Resolve"] = 	{ class = "ROGUE", level = 10, },
	["Improved Poisons"] = 		{ class = "ROGUE", level = 10, },
	["Poisoned Knife"] = 		{ class = "ROGUE", level = 10, }, --7n
	["Cut to the Chase"] = 		{ class = "ROGUE", level = 20, }, 
	["Rupture"] = 				{ class = "ROGUE", level = 22, }, --7m	
	["Venomous Wounds"] = 		{ class = "ROGUE", level = 22, },
	["Wound Poison"] = 			{ class = "ROGUE", level = 25, }, --7m	
	["Seal Fate"] = 			{ class = "ROGUE", level = 27, },
	["Crippling Poison"] = 		{ class = "ROGUE", level = 38, }, --7.1.5m	
	["Garrote"] = 				{ class = "ROGUE", level = 48, }, --7m
	["Vendetta"] = 				{ class = "ROGUE", level = 72, },
	["Potent Poisons"] = 		{ class = "ROGUE", level = 78, },
	--++ Outlaw ++  	
--	["Ripsote"] = 				{ class = "ROGUE", level = 10, }, -- Conflict
	["Run Through"] = 			{ class = "ROGUE", level = 10, }, --7n
	["Saber Slash"] = 			{ class = "ROGUE", level = 10, }, --7n
	["Vitality"] = 				{ class = "ROGUE", level = 10, },	
	["Pistol Shot"] = 			{ class = "ROGUE", level = 12, }, --7n
	["Ambush"] = 				{ class = "ROGUE", level = 14, }, --7m
	["Gouge"] = 				{ class = "ROGUE", level = 22, }, --7m	
	["Between the Eyes"] = 		{ class = "ROGUE", level = 25, }, --7n
	["Ruthlessness"] = 			{ class = "ROGUE", level = 27, },
	["Combat Potency"] = 		{ class = "ROGUE", level = 34, },
	["Roll the Bones"] = 		{ class = "ROGUE", level = 36, }, --7n
	["Blade Flurry"] = 			{ class = "ROGUE", level = 48, },	
	["Restless Blades"] = 		{ class = "ROGUE", level = 50, },
	["Bribe"] = 				{ class = "ROGUE", level = 54, }, --7n	
	["Adrenaline Rush"] = 		{ class = "ROGUE", level = 72, },
	["Main Gauche"] = 			{ class = "ROGUE", level = 78, },
	--++ Subtlety ++
	["Backstab"] = 				{ class = "ROGUE", level = 10, },
	["Energetic Recovery"] = 	{ class = "ROGUE", level = 10, },
	["Eviscerate"] = 			{ class = "ROGUE", level = 10, }, --7m
	["Shuriken Toss"] = 		{ class = "ROGUE", level = 11, }, --7m
	["Shadowstrike"] = 		 	{ class = "ROGUE", level = 22, }, --7n
	["Shadow Techniques"] = 	{ class = "ROGUE", level = 27, }, --7n
	["Symbols of Death"] = 		{ class = "ROGUE", level = 34, }, --7n
	["Shadow Dance"] = 			{ class = "ROGUE", level = 36, },
	["Deepening Shadows"] = 	{ class = "ROGUE", level = 42, }, --7n
	["Nightblade"] = 			{ class = "ROGUE", level = 46, }, --7n	
	["Relentless Strikes"] = 	{ class = "ROGUE", level = 50, }, 	
	["Shuriken Storm"] = 		{ class = "ROGUE", level = 66, }, --7n
	["Shuriken Combo"] = 		{ class = "ROGUE", level = 70, }, --7.2.5n	
	["Shadow Blades"] = 		{ class = "ROGUE", level = 72, }, --7m	
	["Executioner"] = 			{ class = "ROGUE", level = 78, },
--++ Rogue Talents ++
	["Anticipation"] = 			{ class = "ROGUE", level = 45 }, 
	["Deeper Stratagem"] = 		{ class = "ROGUE", level = 45 }, --7n	
	["Vigor"] = 				{ class = "ROGUE", level = 45 }, --7n	
	["Cheat Death"] = 			{ class = "ROGUE", level = 60, }, 
	["Elusiveness"] = 			{ class = "ROGUE", level = 60, }, 
	["Prey on the Weak"] = 		{ class = "ROGUE", level = 75, }, 
	["Alacrity"] = 				{ class = "ROGUE", level = 90, }, --7n
	["Death from Above"] = 		{ class = "ROGUE", level = 100, },
	["Marked for Death"] =		{ class = "ROGUE", level = 100, }, 
	--++ Assassination/Subtlety ++  
	["Nightstalker"] = 			{ class = "ROGUE", level = 30, },
	["Shadow Focus"] = 			{ class = "ROGUE", level = 30, },	
	["Subterfuge"] = 			{ class = "ROGUE", level = 30, },	
	--++ Assassination ++ 
	["Elaborate Planning"] = 	{ class = "ROGUE", level = 15, }, --7n
	["Hemorrhage"] = 			{ class = "ROGUE", level = 15, }, --7m	
	["Master Poisoner"] = 		{ class = "ROGUE", level = 15, }, --7m
	["Leeching Poison"] = 		{ class = "ROGUE", level = 60, },
	["Internal Bleeding"] = 	{ class = "ROGUE", level = 75, }, --x
	["Thuggee"] = 				{ class = "ROGUE", level = 75, }, --7n	
--	["Agonizing Poison"] = 		{ class = "ROGUE", level = 90, }, --7.2.5r	
	["Exsanguinate"] = 			{ class = "ROGUE", level = 90, }, --7n	
	["Toxic Blade"] = 			{ class = "ROGUE", level = 90, }, --7.2.5n	
	["Venom Rush"] = 			{ class = "ROGUE", level = 100, }, --x
	--++ Outlaw ++ 	
	["Ghostly Strike"] = 		{ class = "ROGUE", level = 15, }, --7n
	["Quick Draw"] = 			{ class = "ROGUE", level = 15, }, --7n
	["Swordmaster"] = 			{ class = "ROGUE", level = 15, }, --7n
	["Acrobatic Strikes"] = 	{ class = "ROGUE", level = 30, }, --7n
	["Grappling Hook"] = 		{ class = "ROGUE", level = 30, }, --7n
	["Hit and Run"] = 			{ class = "ROGUE", level = 30, }, --7n
	["Iron Stomach"] = 			{ class = "ROGUE", level = 60, }, --7n
	["Dirty Tricks"] = 			{ class = "ROGUE", level = 75, },
	["Parley"] = 				{ class = "ROGUE", level = 75, }, --7n
	["Cannonball Barrage"] = 	{ class = "ROGUE", level = 90, }, --7n
	["Killing Spree"] = 		{ class = "ROGUE", level = 90, }, --7m
	["Slice and Dice"] = 		{ class = "ROGUE", level = 100, }, --7m	
	--++ Subtlety ++  	
	["Gloomblade"] = 			{ class = "ROGUE", level = 15, }, --7n	
	["Master of Subtlety"] = 	{ class = "ROGUE", level = 15 }, --7m
	["Weaponmaster"] = 			{ class = "ROGUE", level = 15, }, --7n
	["Soothing Darkness"] = 	{ class = "ROGUE", level = 60, }, --7n
	["Strike from the Shadows"] = { class = "ROGUE", level = 75, }, --7n
	["Tangled Shadow"] = 		{ class = "ROGUE", level = 75 }, --7n
	["Dark Shadow"] = 			{ class = "ROGUE", level = 90 }, --7.2.5n	
	["Enveloping Shadows"] = 	{ class = "ROGUE", level = 100, }, --7n
--	["Premeditation"] = 		{ class = "ROGUE", level = 90, }, --7.2.5r
	["Master of Shadows"] = 	{ class = "ROGUE", level = 100, }, --7n
--++ Rogue PvP Talents ++
--	["Cut to the Chase"] = 		{ class = "ROGUE", level = 100, }, --7.2.5r
	["Plunder Armor"] = 		{ class = "ROGUE", level = 100, }, --7n
	["Neurotoxin"] = 			{ class = "ROGUE", level = 100, }, --7.2.5m
	["Shadowy Duel"] = 			{ class = "ROGUE", level = 100, }, --7n
	["Dismantle"] = 			{ class = "ROGUE", level = 100, }, --7n
	["Smoke Bomb"] = 			{ class = "ROGUE", level = 100, }, --7n
	["Cold Blood"] = 			{ class = "ROGUE", level = 100, }, --7n
	["Shiv"] = 					{ class = "ROGUE", level = 100, }, --7.2.5m	

--++ Shaman Abilities ++
	["Disabling Totem"] = 		{ class = "SHAMAN", level = 1, }, --7n??
	["Ancestral Spirit"] = 		{ class = "SHAMAN", level = 14, },
	["Ghost Wolf"] = 			{ class = "SHAMAN", level = 16, },
	["Water Walking"] = 		{ class = "SHAMAN", level = 24, },
	["Far Sight"] = 			{ class = "SHAMAN", level = 36, },
	["Hex"] = 					{ class = "SHAMAN", level = 42, },
	["Astral Recall"] = 		{ class = "SHAMAN", level = 44, },	
	["Astral Shift"] = 			{ class = "SHAMAN", level = 52, },	
	["Purge"] = 				{ class = "SHAMAN", level = 58, },	
	["Bloodlust"] = 			{ class = "SHAMAN", level = 65, },
	["Heroism"] = 				{ class = "SHAMAN", level = 65, },
--++ Shaman Artifact Traits ++
	["Doom Winds"] = 			{ class = "SHAMAN", level = 100, }, --7n
	["Gift of the Queen"] = 	{ class = "SHAMAN", level = 100, }, --7n
	["Stormkeeper"] = 			{ class = "SHAMAN", level = 100, }, --7n
--++ Shaman Specialization ++
	--++ Elemental/Enhancement/Restoration ++
	["Lightning Bolt"] = 		{ class = "SHAMAN", level = 1, }, --7m		
	["Healing Surge"] = 		{ class = "SHAMAN", level = 7, }, --7m		
	["Wind Shear"] = 			{ class = "SHAMAN", level = 22, }, --7m	
	--++ Elemental/Enhancement ++
	["Maelstrom Controller"] = 	{ class = "SHAMAN", level = 3, }, --7n??	
	["Cleanse Spirit"] = 		{ class = "SHAMAN", level = 18, }, --7m
	--++ Elemental/Restoration ++ 
	["Flame Shock"] = 			{ class = "SHAMAN", level = 3, }, --7m	
	["Lava Burst"] = 			{ class = "SHAMAN", level = 12, },
	["Chain Lightning"] = 		{ class = "SHAMAN", level = 28, }, --7m		
	["Lava Surge"] = 			{ class = "SHAMAN", level = 38, },	
	--++ Elemental ++ 
	["Fulmination"] = 			{ class = "SHAMAN", level = 1, },	
	["Earth Shock"] = 			{ class = "SHAMAN", level = 3, }, --x 
	["Elemental Fury"] = 		{ class = "SHAMAN", level = 10, }, 
	["Spiritual Insight"] = 	{ class = "SHAMAN", level = 10, },	
	["Thunderstorm"] = 			{ class = "SHAMAN", level = 16, },
	["Frost Shock"] = 			{ class = "SHAMAN", level = 22, }, --7m
	["Elemental Focus"] = 		{ class = "SHAMAN", level = 40, }, 
	["Fire Elemental"] = 		{ class = "SHAMAN", level = 48, }, --7n	
	["Earthquake Totem"] = 		{ class = "SHAMAN", level = 52, }, --7n	 
	["Earth Elemental"] = 		{ class = "SHAMAN", level = 72, }, --7n	
	["Elemental Overload"] = 	{ class = "SHAMAN", level = 78, },
	--++ Enhancement ++
--	["Critical Strikes"] = 		{ class = "DRUID", level = 1, }, --x Conflict
	["Lava Lash"] = 			{ class = "SHAMAN", level = 10, },
	["Rockbiter"] = 			{ class = "SHAMAN", level = 10, }, --7n	
	["Flametongue"] = 			{ class = "SHAMAN", level = 12, }, --7n
	["Frostbrand"] = 			{ class = "SHAMAN", level = 19, }, --7n	
	["Stormstrike"] = 			{ class = "SHAMAN", level = 26, },
	["Crash Lightning"] = 		{ class = "SHAMAN", level = 28, }, --7n
	["Windfury"] = 				{ class = "SHAMAN", level = 30, }, --7n
	["Stormlash"] = 			{ class = "SHAMAN", level = 38, }, --7n
	["Stormbringer"] = 			{ class = "SHAMAN", level = 40, }, --7n
	["Feral Spirit"] = 			{ class = "SHAMAN", level = 48, }, --7n
	["Maelstrom Weapon"] = 		{ class = "SHAMAN", level = 52, },
	["Spirit Walk"] = 			{ class = "SHAMAN", level = 72, },
	["Enhanced Elements"] = 	{ class = "SHAMAN", level = 78, },
	--++ Restoration ++
	["Riptide"] = 				{ class = "SHAMAN", level = 10, },
	["Healing Stream Totem"] = 	{ class = "SHAMAN", level = 13, },	
	["Purify Spirit"] = 		{ class = "SHAMAN", level = 18, },
	["Chain Heal"] = 			{ class = "SHAMAN", level = 26, }, --x Moved	
	["Resurgence"] = 			{ class = "SHAMAN", level = 40, },
	["Ancestral Vision"] = 		{ class = "SHAMAN", level = 44, }, --7n
	["Healing Rain"] = 			{ class = "SHAMAN", level = 48, },
	["Tidal Waves"] = 			{ class = "SHAMAN", level = 50, },
	["Healing Tide Totem"] = 	{ class = "SHAMAN", level = 54, }, 
	["Healing Wave"] = 			{ class = "SHAMAN", level = 56, },	
	["Spirit Link Totem"] = 	{ class = "SHAMAN", level = 62, },
	["Spiritwalker's Grace"] = 	{ class = "SHAMAN", level = 72, }, 	
	["Deep Healing"] = 			{ class = "SHAMAN", level = 78, },
--++ Shaman Talents ++
	["Wind Rush Totem"] = 		{ class = "SHAMAN", level = 30, }, --7n
	["Earthgrab Totem"] = 		{ class = "SHAMAN", level = 45, },
	["Lightning Surge Totem"] = { class = "SHAMAN", level = 45, }, --7n
	["Voodoo Totem"] = 			{ class = "SHAMAN", level = 45, }, --7n
	["Ascendance"] = 			{ class = "SHAMAN", level = 100, }, --7n	
	--++ Elemental/Enhancement ++
	["Ancestral Swiftness"] = 	{ class = "SHAMAN", level = 60, },	
	--++ Elemental/Restoration ++
	["Ancestral Guidance"] = 	{ class = "SHAMAN", level = 30, },
	["Gust of Wind"] = 			{ class = "SHAMAN", level = 30, }, --7n
	["Echo of the Elements"] = 	{ class = "SHAMAN", level = 60, },	
	--++ Elemental ++	
	["Earthen Rage"] = 			{ class = "SHAMAN", level = 15, }, --7n
	["Path of Flame"] = 		{ class = "SHAMAN", level = 15, }, --7n
	["Totem Mastery"] = 		{ class = "SHAMAN", level = 15, }, --7n	
	["Aftershock"] = 			{ class = "SHAMAN", level = 60, }, --7.1.5m	
	["Elemental Mastery"] = 	{ class = "SHAMAN", level = 60, }, --7.1.5m	
	["Elemental Blast"] = 		{ class = "SHAMAN", level = 75, }, --7.1.5m
	["Elemental Fusion"] = 		{ class = "SHAMAN", level = 75, }, --x
	["Primal Elementalist"] = 	{ class = "SHAMAN", level = 75, },
	["Liquid Magma Totem"] = 	{ class = "SHAMAN", level = 90, }, --7.1.5m	
	["Storm Elemental"] = 		{ class = "SHAMAN", level = 90, }, --7n
	["Icefury"] = 				{ class = "SHAMAN", level = 100, }, --7.1.5m	
	["Lightning Rod"] = 		{ class = "SHAMAN", level = 100, }, --7n	
	--++ Enhancement ++	
	["Hot Hand"] = 				{ class = "SHAMAN", level = 15, }, --7n
	["Landslide"] = 			{ class = "SHAMAN", level = 15, }, --7.2.5m	
	["Windsong"] = 				{ class = "SHAMAN", level = 15, }, --7n
	["Feral Lunge"] = 			{ class = "SHAMAN", level = 30, }, --7n
	["Rainfall"] = 				{ class = "SHAMAN", level = 30, }, --7n
	["Hailstorm"] = 			{ class = "SHAMAN", level = 60, }, --7n
	["Lightning Shield"] = 		{ class = "SHAMAN", level = 60, }, --7m
	["Empowered Stormlash"] = 	{ class = "SHAMAN", level = 75, }, --7n
	["Overcharge"] = 			{ class = "SHAMAN", level = 75, }, --7n
	["Tempest"] = 				{ class = "SHAMAN", level = 75, }, --7n
	["Crashing Storm"] = 		{ class = "SHAMAN", level = 90, }, --7n
	["Fury of Air"] = 			{ class = "SHAMAN", level = 90, }, --7n
	["Sundering"] = 			{ class = "SHAMAN", level = 90, }, --7n
	["Boulderfist"] = 			{ class = "SHAMAN", level = 100, }, --7.2.5m	
	["Earthen Spike"] = 		{ class = "SHAMAN", level = 100, }, --7n
	--++ Restoration ++
	["Torrent"] = 				{ class = "SHAMAN", level = 15, }, --7n
	["Undulation"] = 			{ class = "SHAMAN", level = 15, }, --7n
	["Graceful Spirit"] = 		{ class = "SHAMAN", level = 30, }, --7n
	["Crashing Waves"] = 		{ class = "SHAMAN", level = 60, }, --7n
	["Deluge"] = 				{ class = "SHAMAN", level = 60, }, --7n
	["Ancestral Protection Totem"] = { class = "SHAMAN", level = 75, }, --7n
	["Ancestral Vigor"] = 		{ class = "SHAMAN", level = 75, }, --7n
	["Earthen Shield Totem"] = 	{ class = "SHAMAN", level = 75, }, --7n
	["Bottomless Depths"] = 	{ class = "SHAMAN", level = 90, }, --7n
	["Cloudburst Totem"] = 		{ class = "SHAMAN", level = 90, }, --x
	["High Tide"] = 			{ class = "SHAMAN", level = 100, }, --x
	["Wellspring"] = 			{ class = "SHAMAN", level = 100, }, --7n
--++ Shaman PvP Talents ++
	["Earth Shield"] = 			{ class = "SHAMAN", level = 100, }, --7n
	["Spirit Link"] = 			{ class = "SHAMAN", level = 100, }, --7n
	["Skyfury Totem"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["Counterstrike Totem"] = 	{ class = "SHAMAN", level = 100, }, --7n
	["Windfury Totem"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["Grounding Totem"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["Thundercharge"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["Control of Lava"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["Lightning Lasso"] = 		{ class = "SHAMAN", level = 100, }, --7n
	["Ethereal Form"] = 		{ class = "SHAMAN", level = 100, }, --7n

--++ Warlock Abilities ++
	["Chaos Barrage"] = 		{ class = "WARLOCK", level = 1, }, --7n??
	["Soul Leech"] = 			{ class = "WARLOCK", level = 1, },  --7m??
	["Chaos Bolt"] = 			{ class = "WARLOCK", level = 1, }, --7m ??
	["Shadow Bolt"] = 			{ class = "WARLOCK", level = 1, }, --7 ??
	["Soul Shards"] = 			{ class = "WARLOCK", level = 1, }, --7.2.5n	
	["Summon Imp"] = 			{ class = "WARLOCK", level = 1, },	
	["Create Healthstone"] = 	{ class = "WARLOCK", level = 5, },	
	["Summon Voidwalker"] = 	{ class = "WARLOCK", level = 8, },
	["Control Demon"] = 		{ class = "WARLOCK", level = 10, },
	["Fear"] = 					{ class = "WARLOCK", level = 16, },
	["Soulstone"] = 			{ class = "WARLOCK", level = 18, },
	["Health Funnel"] = 		{ class = "WARLOCK", level = 19, },	
	["Felsteed"] = 				{ class = "WARLOCK", level = 20, },	--7n 
	["Eye of Kilrogg"] = 		{ class = "WARLOCK", level = 22, },
	["Unending Breath"] = 		{ class = "WARLOCK", level = 24, },
	["Summon Succubus"] = 		{ class = "WARLOCK", level = 28, },	
	["Command Demon"] = 		{ class = "WARLOCK", level = 31, },	
	["Banish"] = 				{ class = "WARLOCK", level = 32, },	
	["Summon Felhunter"] = 		{ class = "WARLOCK", level = 35, },
	["Dreadsteed"] = 			{ class = "WARLOCK", level = 40, },	--7n
	["Summon Infernal"] = 		{ class = "WARLOCK", level = 50, },
	["Enslave Demon"] = 		{ class = "WARLOCK", level = 54, },
	["Summon Doomguard"] = 		{ class = "WARLOCK", level = 58, },
	["Unending Resolve"] = 		{ class = "WARLOCK", level = 62, },
	["Create Soulwell"] = 		{ class = "WARLOCK", level = 65, },
	["Ritual of Summoning"] = 	{ class = "WARLOCK", level = 72, },	
	["Demonic Gateway"] = 		{ class = "WARLOCK", level = 87, }, 
--++ Warlock Artifact Traits ++
	["Dimensional Rift"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["Reap Souls"] = 			{ class = "WARLOCK", level = 100, }, --7n
	["Thal'kiel's Consumption"] = { class = "WARLOCK", level = 100, }, --7n
--++ Warlock Specialization ++
	--++ Affliction/Demonology/Destruction ++	
	["Life Tap"] = 				{ class = "WARLOCK", level = 16, }, --x Moved
	--++ Affliction ++
	["Corruption"] = 			{ class = "WARLOCK", level = 3, }, --7m
	["Agony"] = 				{ class = "WARLOCK", level = 10, },
	["Unstable Affliction"] = 	{ class = "WARLOCK", level = 10, },
--	["Secrets of the Necrolyte"] = 	{ class = "WARLOCK", level = 10, },	--7.1.5r
	["Drain Life"] = 			{ class = "WARLOCK", level = 13, }, --7.1.5m
	["Drain Soul"] = 			{ class = "WARLOCK", level = 15, }, --7m	
	["Seed of Corruption"] = 	{ class = "WARLOCK", level = 38 },
	["Potent Afflictions"] = 	{ class = "WARLOCK", level = 78, },
	--++ Demonology ++
	["Hand of Gul'dan"] = 		{ class = "WARLOCK", level = 10, },		
	["Demonic Empowerment"] = 	{ class = "WARLOCK", level = 12, },	--7n
	["Call Dreadstalkers"] = 	{ class = "WARLOCK", level = 14, }, --7n
	["Doom"] = 					{ class = "WARLOCK", level = 26, }, --x	
	["Demonwrath"] = 			{ class = "WARLOCK", level = 36, }, --7n
	["Summon Felguard"] = 		{ class = "WARLOCK", level = 40, },
	["Soul Link"] = 			{ class = "WARLOCK", level = 42, },	
	["Master Demonologist"] = 	{ class = "WARLOCK", level = 78, },
	--++ Destruction ++
	["Immolate"] = 				{ class = "WARLOCK", level = 10, },	
	["Incinerate"] = 			{ class = "WARLOCK", level = 10, },
	["Conflagrate"] = 			{ class = "WARLOCK", level = 10, },
	["Rain of Fire"] = 			{ class = "WARLOCK", level = 38, }, 
	["Havoc"] = 				{ class = "WARLOCK", level = 40, },
	["Chaotic Energies"] = 		{ class = "WARLOCK", level = 78, }, --7n
--++ Warlock Talents ++
	["Demonic Circle: Summon"] = { class = "WARLOCK", level = 45, }, --7m	
	["Mortal Coil"] = 			{ class = "WARLOCK", level = 45, },
	["Soul Harvest"] = 			{ class = "WARLOCK", level = 60, }, --7m	
	["Burning Rush"] = 			{ class = "WARLOCK", level = 75, },
	["Dark Pact"] = 			{ class = "WARLOCK", level = 75, }, --7n
	["Demon Skin"] = 			{ class = "WARLOCK", level = 75, }, --7n
	["Grimoire of Service"] = 	{ class = "WARLOCK", level = 90, },
	["Grimoire of Supremacy"] = { class = "WARLOCK", level = 90, },
	["Soul Conduit"] = 			{ class = "WARLOCK", level = 100, }, --7n
	--++ Affliction/Destruction ++
--	["Mana Tap"] = 				{ class = "WARLOCK", level = 30, }, --7.1.5r
	["Empowered Life Tap"] = 	{ class = "WARLOCK", level = 30, }, --7.1.5n	
	["Grimoire of Sacrifice"] = { class = "WARLOCK", level = 90, },
	--++ Demonology/Destruction ++
	["Shadowfury"] = 			{ class = "WARLOCK", level = 45, }, 	
	--++ Affliction ++	
	["Haunt"] = 				{ class = "WARLOCK", level = 15, },	--7m
	["Malefic Grasp"] = 		{ class = "WARLOCK", level = 15, },	--7.1.5n	
	["Writhe in Agony"] = 		{ class = "WARLOCK", level = 15, }, --7n
	["Absolute Corruption"] = 	{ class = "WARLOCK", level = 30, }, --7n 
	["Contagion"] = 			{ class = "WARLOCK", level = 30, }, --7n 
	["Howl of Terror"] = 		{ class = "WARLOCK", level = 45, }, --x 
	["Sow the Seeds"] = 		{ class = "WARLOCK", level = 60, }, --7n 
	["Phantom Singularity"] = 	{ class = "WARLOCK", level = 60, }, --7.2.5m
	["Death's Embrace"] = 		{ class = "WARLOCK", level = 100, }, --7.2.5n 
	["Siphon Life"] = 			{ class = "WARLOCK", level = 100, }, --7.2.5m	
--	["Soul Effigy"] = 			{ class = "WARLOCK", level = 100, }, --7.2.5r 
	--++ Demonology ++
	["Demonic Calling"] = 		{ class = "WARLOCK", level = 15, }, --7n 
	["Shadowflame"] = 			{ class = "WARLOCK", level = 15, }, --7n
	["Shadowy Inspiration"] = 	{ class = "WARLOCK", level = 15, }, --7n 
	["Impending Doom"] = 		{ class = "WARLOCK", level = 30, }, --7n 
	["Implosion"] = 			{ class = "WARLOCK", level = 30, }, --7n 
	["Improved Dreadstalkers"] = { class = "WARLOCK", level = 30, }, --7n 
	["Hand of Doom"] = 			{ class = "WARLOCK", level = 60, }, --7n 
	["Power Trip"] = 			{ class = "WARLOCK", level = 60, }, --7n 
	["Grimoire of Synergy"] = 	{ class = "WARLOCK", level = 90, }, --x
	["Demonbolt"] = 			{ class = "WARLOCK", level = 100, }, --x
	["Summon Darkglare"] = 		{ class = "WARLOCK", level = 100, }, --7n 
	--++ Destruction ++
	["Backdraft"] = 			{ class = "WARLOCK", level = 15 }, --7m
	["Roaring Blaze"] = 		{ class = "WARLOCK", level = 15, }, --7n
	["Shadowburn"] = 			{ class = "WARLOCK", level = 15, },
	["Eradication"] = 			{ class = "WARLOCK", level = 30, }, --7m
	["Reverse Entropy"] = 		{ class = "WARLOCK", level = 30, }, --7n
	["Cataclysm"] = 			{ class = "WARLOCK", level = 60, }, --7.1.5m	
	["Fire and Brimstone"] = 	{ class = "WARLOCK", level = 60, }, --7m
	["Channel Demonfire"] = 	{ class = "WARLOCK", level = 100, }, --7n
	["Wreak Havoc"] = 			{ class = "WARLOCK", level = 100, }, --7n
--++ Warlock PvP Talents ++
--	["Soul Swap"] = 			{ class = "WARLOCK", level = 100, }, --7.1.5r
	["Curse of Shadows"] = 		{ class = "WARLOCK", level = 100, }, --7.1.5n
	["Curse of Tongues"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["Curse of Weakness"] = 	{ class = "WARLOCK", level = 100, }, --7n
	["Curse of Fragility"] = 	{ class = "WARLOCK", level = 100, }, --7n
	["Bane of Havoc"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["Call Observer"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["Firestone"] = 			{ class = "WARLOCK", level = 100, }, --7n
	["Nether Ward"] = 			{ class = "WARLOCK", level = 100, }, --7n
	["Call Fel Lord"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["Call Felhunter"] = 		{ class = "WARLOCK", level = 100, }, --7n
	["Singe Magic"] = 			{ class = "WARLOCK", level = 100, }, --7n
--	["Soulburn"] = 				{ class = "WARLOCK", level = 100, }, --7.1.5r
	["Soulshatter"] = 			{ class = "WARLOCK", level = 100, }, --7.1.5n	
	["Casting Circle"] = 		{ class = "WARLOCK", level = 100, }, --7n

--++ Warrior Abilities ++
	["Attack"] = 				{ class = "WARRIOR", level = 1, }, --7n
--	["Block"] = 				{ class = "WARRIOR", level = 1, }, --7 Conflict
--	["Parry"] = 				{ class = "WARRIOR", level = 1, }, --7 Conflict
	["Charge"] = 				{ class = "WARRIOR", level = 3, },
	["Taunt"] = 				{ class = "WARRIOR", level = 14, },
	["Heroic Throw"] = 			{ class = "WARRIOR", level = 22, },
	["Pummel"] = 				{ class = "WARRIOR", level = 24, },
	["Heroic Leap"] = 			{ class = "WARRIOR", level = 26, },	
	["Deep Wounds"] = 			{ class = "WARRIOR", level = 32, }, --x Moved
--++ Warrior Artifact Traits ++
	["Neltharion's Fury"] = 	{ class = "WARRIOR", level = 100, }, --7n
	["Odyn's Fury"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["Warbreaker"] = 			{ class = "WARRIOR", level = 100, }, --7n
--++ Warrior Specialization ++
	--++ Arms/Fury/Protection ++
	["Focused Rage"] = 			{ class = "WARRIOR", level = 12, }, --7.1.5m	
	["Berserker Rage"] = 		{ class = "WARRIOR", level = 40, }, --7m
	["Battle Cry"] = 			{ class = "WARRIOR", level = 60, },	--7n
	--++ Arms/Fury ++
	["Execute"] = 				{ class = "WARRIOR", level = 8, }, --7m
	["Whirlwind"] = 			{ class = "WARRIOR", level = 28, },		
	["Intimidating Shout"] = 	{ class = "WARRIOR", level = 70, }, --7m
	["Commanding Shout"] = 		{ class = "WARRIOR", level = 83, },	
	--++ Arms/Protection ++	
	["Victory Rush"] = 			{ class = "WARRIOR", level = 10 }, --7m
	--++ Arms ++	
	["Slam"] = 					{ class = "WARRIOR", level = 1, },	
	["Mortal Strike"] = 		{ class = "WARRIOR", level = 5, },
--	["Seasoned Soldier"] = 		{ class = "WARRIOR", level = 10, }, -- removed
	["Colossus Smash"] = 		{ class = "WARRIOR", level = 18, }, --x Moved	
	["Tactician"] = 			{ class = "WARRIOR", level = 18, }, --7n	
	["Cleave"] = 				{ class = "WARRIOR", level = 32 }, --7m
	["Hamstring"] = 			{ class = "WARRIOR", level = 36, }, --7m
	["Die by the Sword"] = 		{ class = "WARRIOR", level = 50, },
	["Bladestorm"] = 			{ class = "WARRIOR", level = 75, },	--7m ??
	["Colossal Might"] = 		{ class = "WARRIOR", level = 78, },	--7n
	--++ Fury ++
	["Bloodthirst"] = 			{ class = "WARRIOR", level = 10, },
	["Enrage"] = 				{ class = "WARRIOR", level = 10, }, --x Moved	
	["Furious Slash"] = 		{ class = "WARRIOR", level = 10, }, --7n		
	["Titan's Grip"] = 			{ class = "WARRIOR", level = 10, }, 
	["Enraged Regeneration"] = 	{ class = "WARRIOR", level = 12, }, --7m
	["Raging Blow"] = 			{ class = "WARRIOR", level = 13, },
	["Rampage"] = 				{ class = "WARRIOR", level = 18, },	 --7n
	["Piercing Howl"] = 		{ class = "WARRIOR", level = 26, }, --7m
	["Single-Minded Fury"] = 	{ class = "WARRIOR", level = 38, }, 
	["Meat Cleaver"] = 			{ class = "WARRIOR", level = 58, }, 
	["Unshackled Fury"] = 		{ class = "WARRIOR", level = 78, },
	--++ Protection ++  
	["Defensive Stance"] = 		{ class = "WARRIOR", level = 9, }, --7m	 ??
--	["Resolve"] = 				{ class = "WARRIOR", level = 10, }, --x Conflict with Druid/Monk
	["Shield Slam"] = 			{ class = "WARRIOR", level = 10, },
	["Unwavering Sentinel"] = 	{ class = "WARRIOR", level = 10, },
	["Devastate"] = 			{ class = "WARRIOR", level = 12, },
	["Thunder Clap"] = 			{ class = "WARRIOR", level = 16, }, --x Moved	
	["Shield Block"] = 			{ class = "WARRIOR", level = 18, },	
	["Revenge"] = 				{ class = "WARRIOR", level = 28, },
	["Ignore Pain"] = 			{ class = "WARRIOR", level = 34, }, --7n
	["Last Stand"] = 			{ class = "WARRIOR", level = 36, },
	["Shield Wall"] = 			{ class = "WARRIOR", level = 48, }, --x Moved
	["Demoralizing Shout"] = 	{ class = "WARRIOR", level = 50, },
	["Bastion of Defense"] = 	{ class = "WARRIOR", level = 60, },
	["Spell Reflection"] = 		{ class = "WARRIOR", level = 65, }, --7m
	["Intercept"] = 			{ class = "WARRIOR", level = 72, }, --7n
--	["Ripsote"] = 				{ class = "WARRIOR", level = 76, }, --7 Conflict
	["Critical Block"] = 		{ class = "WARRIOR", level = 78, },
--++ Warrior Talents ++
	--++ Arms/Fury/Protection ++	
	["Shockwave"] = 			{ class = "WARRIOR", level = 15, }, --7??
	["Storm Bolt"] = 			{ class = "WARRIOR", level = 15, }, --7?? 
	["Bounding Stride"] = 		{ class = "WARRIOR", level = 60, }, --7n	
	--++ Arms/Fury ++	
	["Double Time"] = 			{ class = "WARRIOR", level = 30, },	
	--++ Arms/Protection ++	
	["Anger Management"] = 		{ class = "WARRIOR", level = 100, }, --x
	["Ravager"] = 				{ class = "WARRIOR", level = 100, }, --x	
	--++ Arms ++
	["Dauntless"] = 			{ class = "WARRIOR", level = 15, }, --7n
	["Overpower"] = 			{ class = "WARRIOR", level = 15, }, --7m	
	["Sweeping Strikes"] = 		{ class = "WARRIOR", level = 15, },
	["Rend"] =				 	{ class = "WARRIOR", level = 45, }, --7m	
	["Avatar"] = 				{ class = "WARRIOR", level = 45, },
	["Trauma"] = 				{ class = "WARRIOR", level = 45, }, --7.2.5m	
	["Second Wind"] = 			{ class = "WARRIOR", level = 60, },
	["Fervor of Battle"] = 		{ class = "WARRIOR", level = 75, }, --7.2.5m		
	["Mortal Combo"] = 			{ class = "WARRIOR", level = 75, }, --7n
	["Titanic Might"] = 		{ class = "WARRIOR", level = 75, }, --7.2.5m	
	["Deadly Calm"] = 			{ class = "WARRIOR", level = 90, }, --7n
	["Focused Rage"] = 			{ class = "WARRIOR", level = 90, }, --7.2.5m
	["In for the Kill"] = 		{ class = "WARRIOR", level = 90, }, --7.2.5m	
	["Opportunity Strikes"] = 	{ class = "WARRIOR", level = 100, }, --7n??
	--++ Fury ++
	["War Machine"] = 			{ class = "WARRIOR", level = 15, }, --7n	
	["Endless Rage"] = 			{ class = "WARRIOR", level = 15, }, --7n	
	["Fresh Meat"] = 			{ class = "WARRIOR", level = 15, }, --7n
	["Wrecking Ball"] = 		{ class = "WARRIOR", level = 45, }, --7n
	["Outburst"] = 				{ class = "WARRIOR", level = 45, }, --7n
	["Furious Charge"] = 		{ class = "WARRIOR", level = 60, }, --7n
	["Warpaint"] = 				{ class = "WARRIOR", level = 60, }, --7n
	["Massacre"] = 				{ class = "WARRIOR", level = 75, }, --7n
	["Frothing Berserker"] =	{ class = "WARRIOR", level = 75, }, --7n
	["Carnage"] = 				{ class = "WARRIOR", level = 75, }, --7n
	["Bloodbath"] = 			{ class = "WARRIOR", level = 90, },
	["Frenzy"] = 				{ class = "WARRIOR", level = 90, }, --7n
	["Inner Rage"] = 			{ class = "WARRIOR", level = 90, }, --7n
	["Reckless Abandon"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["Dragon Roar"] = 			{ class = "WARRIOR", level = 100, }, 
	--++ Protection ++
	["Warbringer"] = 			{ class = "WARRIOR", level = 15, }, 
	["Impending Victory"] = 	{ class = "WARRIOR", level = 30, },
	["Inspiring Presence"] = 	{ class = "WARRIOR", level = 30, }, --x	
	["Safeguard"] = 			{ class = "WARRIOR", level = 30, },
	["Best Served Cold"] = 		{ class = "WARRIOR", level = 45, }, --7.1.5m	
	["Renewed Fury"] = 			{ class = "WARRIOR", level = 45, }, --7n	
--	["Ultimatum"] = 			{ class = "WARRIOR", level = 45, }, --7.1.5r
	["Warlord's Challenge"] = 	{ class = "WARRIOR", level = 60, }, --7n
	["Crackling Thunder"] = 	{ class = "WARRIOR", level = 60, }, --7n
	["Devastator"] = 			{ class = "WARRIOR", level = 75, }, --7.1.5n
	["Indomitable"] = 			{ class = "WARRIOR", level = 75, }, --7n
	["Vengeance"] = 			{ class = "WARRIOR", level = 90, }, --7m
	["Into the Frey"] = 		{ class = "WARRIOR", level = 90, }, --7n
	["Booming Voice"] = 		{ class = "WARRIOR", level = 90, }, --7n
	["Heavy Repercussions"] = 	{ class = "WARRIOR", level = 100, }, --x	
--++ Warrior PvP Talents ++
	["Disarm"] = 				{ class = "WARRIOR", level = 100, }, --7.1.5n
	["Duel"] = 					{ class = "WARRIOR", level = 100, }, --7.1.5n
	["Intercept"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["Sharpen Blade"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["Shield Bash"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["Death Wish"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["Dragon Charge"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["Bodyguard"] = 			{ class = "WARRIOR", level = 100, }, --7n
	["Mass Spell Reflection"] = { class = "WARRIOR", level = 100, }, --7n
	["Spell Reflection"] = 		{ class = "WARRIOR", level = 100, }, --7n
	["War Banner"] = 			{ class = "WARRIOR", level = 100, }, --7.1.5n	
};
