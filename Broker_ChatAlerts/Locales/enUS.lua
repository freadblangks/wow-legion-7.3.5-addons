--[[ *******************************************************************
Project                 : Broker_ChatAlerts
Description             : English translation file (enUS)
Author                  : 
Translator              : 
Revision                : $Rev: 1 $
********************************************************************* ]]

local ADDON = ...

local L = LibStub:GetLibrary("AceLocale-3.0"):NewLocale(ADDON, "enUS", true, true)
if not L then return end

L["Deactivated"] = true
L["Activated"] = true
L["Filtered"] = true

L["Settings"] = true

L["General"] = true
L["Setup general options."] = true

L["Default Alert Location"] = true
L["Choose what method you would like to use for displaying text alerts. SCT, Mik's Scrolling Battle Text, Parrot, Blizzard Scrolling Text, and the default UI are supported. Grayed-out entries are currently not active."] = true
L["Message Filters"] = true
L["Message filters will be applied before processing channel messages. Message filters are introduced by other addons such as spam filtering addons."] = true
L["Notification Sound"] = true
L["Choose sound to be played on notifications."] = true
L["Play Sound"] = true
L["Play selected notification sound."] = true
L["Show in Combat"] = true
L["Show alerts while engaged in combat."] = true
L["Show out of Combat"] = true
L["Show alerts while out of combat."] = true
L["Show own Messages"] = true
L["Show your own messages."] = true

L["Message Format"] =  true
L["Setup message format."] = true
L["Wrap Lines"] = true
L["Wrap lines before displaying text alerts."] = true
L["Line Length"] = true
L["Wrap message for text alerts to this line length if wrapping is active."] = true
L["Show Sender Icon"] = true
L["Show icon indicating race and gender of sender character."] = true
L["Show Client Icon"] = true
L["Show icon indicating client of sender in Battle.Net conversations."] = true
L["Icon Size"] = true
L["Size of displayed icons."] = true

L["Display Addons"] = true
L["Setup supported display addons."] = true

L["Scroll Area"] = true
L["Select display area used by provider."] = true
L["Sticky"] = true
L["Make alert text sicky in scroll area."] = true
				
L["Message Events"] = true
L["Set up alerts for message events"] = true
L["Channel Alerts"] = true
L["Set up alerts for specific channels"] = true

L["Text Message Alerts"] = true
L["Choose message types where you want text displayed."] = true
L["Set text alerts for specific channels"] = true
L["Sound Alerts"] = true
L["Choose message types where you to hear a notify sound."] = true
L["Set sounds for specific channels"] = true
L["Scroll Area"] = true
L["Choose a specific location for the message alert other than the default location."] = true
L["Choose a specific location for the channel alert other than the default location."] = true

L["Loot Options"] = true
L["Choose message types where you want text displayed."] = true

L["Minimum Rarity - Self"] = true
L["Choose the minimum rarity to alert when looting."] = true
L["Minimum Rarity - Others"] = true
L["Choose the minimum rarity to alert when OTHERS are looting."] = true
L["Show my loot only"] = true
L["Toggle whether or not to show other looters or just your own."] = true
L["Show total quanity"] = true
L["Toggle whether the total quantity in your bags should be shown in the loot text alert."] = true
L["Show need and winner only"] = true
L["Toggle whether to show only Need and Winner on rolls."] = true

L["Filter Options"] = true
L["Filter for events and channel messages."] = true

L["Player Name"] = true
L["Message will be shown if it contains the player name."] = true
L["Keywords"] = true
L["List of keywords. Message will be shown if any keyword is matched."] = true

L["Test Alert Locations"] = true
L["Test text alerts settings."] = true

L["Test Event"] = true
L["Select event mimicked for the test."] = true
L["Test Text"] = true
L["Text to display for test."] = true
L["Execute Test"] = true
L["Execute test event."] = true

L["Minimap Button"] = true
L["Show Minimap Button"] = true
L["Hide Hint"] = true
L["Hide usage hint in tooltip"] = true

L["Default"] = true

L["Version"] = true

L["Usage:"] = true
L["/bchatalerts arg"] = true
L["/bca arg"] = true
L["Args:"] = true
L["version - display version information"] = true
L["menu - display options menu"] = true
L["help - display this help"] = true

L["Poor"] = true
L["Common"] = true
L["Uncommon"] = true
L["Rare"] = true
L["Epic"] = true
L["Legendary"] = true
L["Artifact"] = true

L["system"] = "System"
L["whisper"] = "Whisper"
L["party"] = "Party"
L["raid"] = "Raid"
L["instance"] = "Instance"
L["bg"] = "Battleground"
L["bnet"] = "Battle.net"
L["say"] = "Say"
L["yell"] = "Yell"
L["emote"] = "Emote"
L["guild"] = "Guild"
L["officer"] = "Officer"
L["monster"] = "Monster"
L["boss"] = "Raid Boss"
L["loot"] = "Loot"

L["General"] = true
L["Trade"] = true
L["LocalDefense"] = true
L["LookingForGroup"] = true
L["GuildRecruitment"] = true

L["Toggle %s Messages"] = true
L["Toggle %s Sound Alert"] = true
L["Choose specific Alert Location for %s Messages."] = true
L["Message"] = true
L["Channel"] = true
L["Text"] = true
L["Sound"] = true

L["disabled"] = true
L["enabled"] = true
L["filtered"] = true

L["Right-Click"] = true
L["Open option menu."] = true
L["Left-Click Tip"] = true
L["Toggle selected setting."] = true

L["default"] = "Default UI Frame"
L["rw"]      = "Raid Warning"
L["sct"]     = "SCT - Scrolling Combat Text"
L["msbt"]    = "Mik's Scrolling Battle Text"
L["parrot"]  = "Parrot"
L["blizz"]   = "Blizzard Scrolling Text"
L["Globally set Location"] = true

L["Toggle text for "] = true
L["Toggle sound for "] = true

L["Location"] = true
L["Choose specific Alert Location for "] = true
L["NEED"] = true

