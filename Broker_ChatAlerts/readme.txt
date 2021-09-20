Broker_ChatAlerts, a World of Warcraft® user interface addon.
Copyright© 2010 Bernhard Voigt, aka tritium - All rights reserved.
License is given to copy, distribute and to make derivative works.

Broker_ChatAlerts - A broker addon that shows on screen messages for certain events and channel activities.

New -

	* Added 'Raid Warning' as possible text alert output.
	* For text alerts assign any of the possible areas provided by display addons (SCT, MSBT, Parrot)
	* Make messages sticky or floating for SCT, MSBT, Parrot or the Blizzard Floating Combat Text
	* Test text alerts for all message events in the 'Test Alert Locations' section in the options.
	* Show class colors for author of messages.
	* Included Battle.net conversations.
	* 'Yell' no longer bundled with 'Say' but own event.
	* Option to show alerts in combat and out of combat.
	* Option to wrap lines at a specific line length.
	* Channel and chat settings shown in their respective colors in tooltip.
	* Removed own spam-filtering attempts. 
	* Spam filtering through external addons. Set option 'Message Filters' to apply filters of external spam-addons before processing messages.

Features -

	* Supports two different types of alerts: Text alerts & Sound alerts
	* Text alerts can be displayed in the UI Error Message Frame, SCT, MSBT, Parrot or the Blizzard Floating Combat Text
	* Chat types supported: Raid, Battleground, Party, Guild, Officer, System, Battle.net, Whisper, Say, Yell, Emotes, Monster emotes/yells
	* Channels supported: Receive alerts for Blizzard Channels like General, Trade etc  or custom channels
	* Each chat type and channel can have assigned it's own display location. If none is specifically set global setting will be used.
	* Filter options to highlight only selected messages (Player name, keywords)
	* Whitelist filter matches each single word (ignores case) 
	* Looting alerts: Receive alert messages for rolls and items looted
	* Text alerts inherit the colors used in the Chat Frame.
	* Profile support for settings.
	
Install -

	Copy the Broker_ChatAlerts folder to your Interface\AddOns directory.
		
Commands - 

	/bchatalerts arg
	/bca arg

	With arg:
	menu - display options menu
	version - display the version information
	help - display this help
	
Usage -

	* Set global option where all alerts will be displayed. For each messsage event and channel an individual display location can be selected.
	* All 4 supported display locations can always be set in the options. Locations that are not available are grayed out but still can be selected.
	* Default UI Frame is fallback location if non-available locations is set for display. This way temporarily disabled addons won't mess with your settings.
	
	