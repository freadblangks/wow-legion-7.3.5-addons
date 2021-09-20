Custom Flyout buttons.

==Overview
Custom Flyout buttons similar to Blizzard buttons like traps and teleports. Now you can make your own buttons!

==HowTo
*To make your own button lists open Spellbook (or use slash command to enter SettingsMode): you will see small arrow-buttons attached to your action buttons. To start adding buttons click arrow-button: appears empty button list, drag there spells, companions, mounts, items. Close spellbook: buttons ready to use.
*To set flyout arrow direction right-click arrow button

==Features
*Action buttons right-click while not in combat to set action to bar button. Supported default Blizzard action bars and "Button Forge".
*Action buttons right-click while in combat - selfcast

==Slash commands
"/fbc" or "/fbcustom"
params:
empty or 'help' to see available
'border' to toggle button borders
'kb' or 'keybind' to toggle keybinding mode
'mouseover' to toggle opening/hiding lists on arrow button mouseover
'hide' to toggle hiding on list button click
'height value' to set arrow button height, values 5-36
'settings' to toggle SettingsMode
'unique' to toggle only 1 list visible

==What can't be done due to restrictions
*replacing action buttons on last used from list

==Tested with
Default Blizzard action bar, Button Forge, Bartender 4, Dominos.


Changes:

v2.82
Glow and MacroText libraries through LibStub

v2.81
workarounds with spell API bugs of patch 7.3

v2.80
toc changed for 7.3
PlaySound fixes

v2.79
toc changed for 7.2
GetEquipmentSetInfoByName fix

v2.78
MacroToolkitFrame workaround

v2.77
fixed: EquipmentSet textures

v2.76
Tooltip etc fixes

v2.74
Taint fixes


v2.74
Taint fixes

v2.71
Masque support

v2.70
MacroText icon selection fixes Battlpet fixes Mount fixes

v2.69
"Separate specs" option

v2.68
SpellGoup fixes

v2.67
Legion fixes

v2.66
toc changed for 6.2

v2.65
PetJournalParent to CollectionsJournal fix

v2.64
TogglePetJournal fixed

v2.63
mounts fixed

v2.62
toc changed for WoD

v2.61
Option in settings to enable/disable using Shift

v2.60
MacroText support like in TinyExtrBars

v2.57
taint caused by glow functions finally fixed

v2.56
fixed error Usage: GetPetLink(ID) with battlepets

v2.55
buttons can be dragged with Shift pressed

v2.54
more restrictions to prevent dragging button while in combat or not in settings mode

v2.51
'arrow buttons dir locked' option

v2.50
global variables fixes

v2.49
battlepets

v2.48
ButtonForge back again
battlepet's checked disabled due to GetSummonedPetID function removal by Blizzard
battlepet's summon disabled due to SummonPetByID function removal by Blizzard

v2.47
toc changed for v5.1.0

v2.46
tonumber for FindSpellId
changes to be compatible with LastEffect addon

v2.45
fixed moving whole arrow button

v2.44
fix for hooksecurefunc(GameTooltip, ...)
fixed: item tooltips

v2.43
set parent button action on click now optional (default "off")

v2.42
hangs fix

v2.41
tooltips for action buttons changed on click while in combat

v2.40
TinyExtraBars support
button glow support
proper item charges
parent action buttons can now receive action and texture on left click (including "in combat", thanks to Ro from US forums)

v2.39
global to local fixes
will wait on loading world in combat instead of throwing error

v2.38
EasyStorage updated to v1.1.0

v2.37
battlepet tooltip more info
minor changes

v2.36
SavedVariables logic moved into separate library
companions (battlepets), almost everything works except cooldowns and "right-click set"

v2.35
fixed: tooltips for mounts through spell id while through hyperlinks still bugged
some improvements:
redone work with saves
redone work with button's functions presets

v2.34
right-click mount to set fix
SetFrameStrata while InCombat fix

v2.33
FlyoutListButton "compare number with nil" fixed
taint by not local "_" (hopefully)

v2.32
toc Interface changed back to 50001
Lua error on talents change fixed

v2.31
GetFullSpellName error fixed

v2.30
more changes and fixes
optimized handlers
fixed "many-named" spells with generic names

v2.26
macro fixed

v2.25
Drag and drop, "Right click to set" fixes

v2.24
GetCompanionCooldown disabled to avoid error "attempt to call global 'GetCompanionCooldown' (a nil value)"

v2.23
hunter's pets fixed

v2.22
fixes from v2.15 Live:
 fixed bug on removing button from list
 removing button in the middle of list will rearrange buttons

v2.21
auto show arrow buttons hiding counts opened windows that triggers OnShow

v2.20
MoP changes
fixed interference between "Right-Click self cast" and "Right-Click set" in options
auto show arrow buttons on Spellbook and Character Window "OnShow"
added option "Arrow button movable" to prevent or allow moving

known issue: unable to use MountJournal and PetJournal "OnShow"

v2.11
mouseover fixes

v2.10
buttons can be scaled

v2.08
back to possibility to use several action bars addons

v2.06
moving arrow button's visual improvement

v2.05
ability to move arrow buttons, cursor during drag&drop have first available icon and message in chat window "FlyoutButtonCustom moving arrow button, drop it onto another arrow button"

v2.00
ElvUI support
skipped creation of arrow buttons for standard action bar's buttons while ElvUI or Bartender4 found (reduced memory usage)

v1.98
equipment set support

v1.97
toc changed for v4.3

v1.96
right-click button set available for Bartender4
also "right-click button set" and "right-click button self cast" optional and available through settings

v1.95
removed loading delay and LibTimer dependancy
ButtonFacade, Bartender4, ButtonForge, Dominos now in OptionalDeps

v1.91
toc updated for v4.2

v1.90
toc updated for v4.1

v1.89
fixed: amount of empty buttons above used in settngs mode reduced to 1

v1.88
fixed: error on arrow button cleanup in Settings mode
default amount of empty buttons in settngs mode reduced to 1
startup delay to avoid problems with server stored values (see http://tain.wowinterface.com/forums/showthread.php?t=37039 for more info)

v1.87
fixed: PickupCompanion check

v1.86
fixed: tooltip error when creatureSpellID = nil

v1.85
check for parent bar not nil

v1.84
fixed: debug info left

v1.82
option to enable/disable arrow button highlight on mouseover

v1.81
fixed: show/hide grid event registration
fixed: settings dialog properly show keybinding mode

v1.80
frame strata adjustment while grid shown/hidden

v1.79
attempt to do something with Dominos transparency

v1.78
fixed: button anchors while right clicking arrow buttons

v1.77
fixed: arrow button RIGHT flyout error

v1.76
fixed: macro update error

v1.75
settings window, to show type /fbc
slash command list now "/fbc help"
ability to disable opening/hiding lists on mouseover while in combat
LibKeybound revision increased to avoid overriding with bugged old versions from Bartender libs etc

v1.71
fixed "OnReceiveDrag" error

v1.70
keybindings (based on LibKeyBound-1.0, same library used in Bartender4, so usage similar)
range indicators
some fixes

v1.60
split on several modules
arrow button opacity manipulation replaced with highlight texture, "alpha" slash command removed

v1.51
hiding button list on action button click (optional)
hard work to make arrow texture smaller :)

v1.50
right-click self cast while in combat
working modifiers for focus and selfcast
"rescan" removed, used entering SettingsMode instead to find new bars/buttons
"unique" slash command to turn on/off only 1 list visible
right-click while not in combat to set action bar button for Button Forge

v1.45
fixed arrow directions (sometime it was up instead of down)
fixed button click event (cast) while dragging with clicking
transparent list border texture removed
right-click while NOT in combat to set action bar button "action" to clicked (at moment only for Blizz action bars since making it for 3-rd party action bars requires specific actions for any action bar addon)

v1.41
"rescan" slash option to rescan action bars (for example Button Forge not notifying on adding new buttons or bars, rescan after that sort of solution)

v1.40
Only 1 open button list possible now, autohiding other lists. That makes show/hide on mouseover not so annoying.

v1.35
Button Facade support

v1.30
opening list on mouseover arrow buttons (optional)

v1.25
added list of slash commands on empty or "help" parametr
added options to set borders visibility ("border" slash command) and opacity for arrow buttons ("alpha value" slash command)

v1.20
macro support

v1.15b
slash commands to enter/exit Settings mode or set arrow buttons height
ability to set flyout direction, now left-click on arrow button to show/hide list, right-click to set direction (not in combat)

v1.10b
now seems works with Bartender
hiding on entering vehicle
event manager redesigned

v1.05b
fixes to hide arrows and empty frames when combat started in SettingsMode (spellbook open)