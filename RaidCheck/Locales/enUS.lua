local L = LibStub("AceLocale-3.0"):NewLocale("Raid Check", "enUS", true)

if L then

--Announces
L["missingbuffs"]	= "Missing buffs:";
L["noissues"]		= "Check passed without issues.";
L["warningfood"]	= "Food ";
L["warningflask"]	= "Flask ";
L["warningrune"]	= "Rune ";
L["warningvantus"]	= "Vantus ";
L["allchecksdisabled"]	= "Announcing Flask, Food, and Rune buffs is disabled.";

--Extensions
L["expires"]		= "(expires)";

--Whispers
L["useFlask"]		= "Please use a Flask, with a benefit of at least ";
L["expFlask"]		= "Your Flask expires soon!";
L["useFood"]		= "Please eat Food with a gain of at least ";
L["expFood"]		= "Your Food expires soon!";
L["useRune"]		= "Please use a Rune that increases stats by at least ";
L["expRune"]		= "Your Rune expires soon!";
L["useVantus"]		= "Please use a Vantus Rune on this Boss:";

--GUI
L["yes"]			= "Yes";
L["no"]				= "No";
L["exp"]			= "Exp";
L["hide"]			= "Hide";
L["show"]			= "Show";
L["hideText"]		= "Hide the addon Interface.";
L["settingsText"]	= "Open the addon interface to the Settings tab.";
L["showText"]		= "Show the addon Interface.";
L["none"]			= "None";

--Buttons
L["main"]			= "Main";
L["settings"]		= "Settings";
L["announcetxt"]	= "Announce players without buffs to Raid, Party or Say";
L["announce"]		= "Announce";
L["whispertxt"] 	= "Whisper players without buffs personally";
L["whisper"] 		= "Whisper";
L["refreshtxt"] 	= "Reload buff data";
L["refresh"] 		= "Refresh";

--Headline
L["player"] 		= "Player";
L["flask"] 			= "Flask";
L["food"] 			= "Food";
L["rune"] 			= "Rune";
L["vantusrune"]		= "Vantus Rune";

--Minimap
L["MinimapTooltip1"]	= "Left-click to toggle Raid Check window.";
L["MinimapTooltip2"]	= "Right-click to enter settings.";
L["MinimapTooltip3"]	= "Control-Left-click to Announce."
L["showMinimap"] 	= "Show Minimap Button.";

--Settings
L["Data"]			= "Data";
L["Misc"]			= "Miscellaneous";
L["Beha"]			= "Behavior";
L["UI"]				= "User Interface";

L["enRune"]			= "Enable Rune checking.";
L["allowFelFocuser"]	= "Count Fel Focuser as Flask.";
L["colorClass"]		= "Color Names by Class.";

L["annFood"]		= "Announce/Whisper Food.";
L["annFlask"]		= "Announce/Whisper Flasks.";
L["annRunes"]		= "Announce/Whisper Runes.(Rune checking has to be enabled)";
L["whispVantus"]	= "Whisper Vantus Runes on enabled Boss.";
L["ctrlWhi"]		= "CTRL-click to whisper a single player.";
L["annBossStart"]	= "Announce when a Raid Boss is engaged."

L["hideCombat"]		= "Hide when combat starts.";
L["rdyCheck"]		= "Show and refresh on ReadyCheck.";
L["rdyAnn"]			= "Announce on ReadyCheck.";
L["rdyWhi"]			= "Whisper on ReadyCheck.";
L["ign78"]			= "Ignore group 7 and 8.";
L["showRealms"]		= "Show Realm Names.";
L["LeaderAssistOnly"]	="Announce only when Leader or Assistant.";

L["windowSizeSlider"]	= "Window Height:";
L["resetDefault"] 	= "Reset Settings";

end
