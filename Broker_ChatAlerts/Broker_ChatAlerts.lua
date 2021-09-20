-- TODO:
-- load all known channel options at startup

local _G = _G

-- addon name and namespace
local ADDON, NS = ...

-- local functions
local ipairs   = ipairs
local pairs    = pairs
local format   = string.format 
local strlower = strlower
local strfind  = strfind
local strsub   = strsub

local BNGetGameAccountInfo  = _G.BNGetGameAccountInfo
local GetItemCount          = _G.GetItemCount
local GetItemInfo           = _G.GetItemInfo
local GetChannelName        = _G.GetChannelName
local GetPlayerInfoByGUID   = _G.GetPlayerInfoByGUID
local PlaySound             = _G.PlaySound
local PlaySoundFile         = _G.PlaySoundFile
local UnitAffectingCombat   = _G.UnitAffectingCombat

local ChatFrame_GetMessageEventFilters = _G.ChatFrame_GetMessageEventFilters

local RaidNotice_AddMessage = _G.RaidNotice_AddMessage
local RaidWarningFrame      = _G.RaidWarningFrame
local UIErrorsFrame         = _G.UIErrorsFrame

local _

-- setup libs
local LibStub   = LibStub
local LDB       = LibStub:GetLibrary("LibDataBroker-1.1")

-- get translations
local L         = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- line wrap function (shortened and taken from http://lua-users.org/wiki/StringRecipes)
local function wrap(str, limit)
	limit = limit or 60
	local here = 1
	return str:gsub("(%s+)()(%S+)()",
		function(sp, st, word, fi)
			if fi-here > limit then
				here = st
				return "\n"..word
			end
		end)
end

-- addon and locals
local Addon = LibStub:GetLibrary("AceAddon-3.0"):NewAddon(ADDON, "AceEvent-3.0", "AceConsole-3.0")

-- addon constants
Addon.MODNAME   = "BrokerChatAlerts"
Addon.FULLNAME  = "Broker: Chat Alerts"
Addon.SHORTNAME = "Chat Alerts"

-- lookup for localized names
local localizedChannels = {
	L["General"],
	L["Trade"],
	L["LocalDefense"],
	L["LookingForGroup"],
	L["GuildRecruitment"],
}

-- icons for client and race
local BNET_CLIENT_ICONS = {
	[BNET_CLIENT_WOW] = "Interface\\ChatFrame\\UI-ChatIcon-WOW",
	[BNET_CLIENT_SC2] = "Interface\\ChatFrame\\UI-ChatIcon-SC2",
	[BNET_CLIENT_D3]  = "Interface\\ChatFrame\\UI-ChatIcon-D3",
}

local RACE_ICONS = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races"

local RACE_ICON_COORDS = {
	-- neutral
	nil,
	-- male
	{
		Human		= "0:32:0:128",
		Dwarf		= "32:64:0:128",
		Gnome		= "64:96:0:128",
		NightElf	= "96:128:0:128",
		Draenei		= "128:160:0:128",
		Worgen		= "160:192:0:128",

		Tauren		= "0:32:128:256",
		Scourge		= "32:64:128:256",
		Troll		= "64:96:128:256",
		Orc			= "96:128:128:256",
		BloodElf	= "128:160:128:256",
		Goblin		= "160:192:128:256",
	},
	-- female
	{
		Human		= "0:32:256:384",
		Dwarf		= "32:64:256:384",
		Gnome		= "64:96:256:384",
		NightElf	= "96:128:256:384",
		Draenei		= "128:160:256:384",
		Worgen		= "160:192:256:384",
		
		Tauren		= "0:32:384:512",
		Scourge		= "32:64:384:512",
		Troll		= "64:96:384:512",
		Orc			= "96:128:384:512",
		BloodElf	= "128:160:384:512",
		Goblin		= "160:192:384:512",
	},
}

local ICON = "Interface\\Addons\\"..ADDON.."\\icon.tga"

-- event list
-- custom groupings of the different chat events
-- NOTE: text coloring makes use of first entry in each section
Addon.events = {
	['system'] = {
		"CHAT_MSG_SYSTEM",
		"CHAT_MSG_BG_SYSTEM_ALLIANCE",
		"CHAT_MSG_BG_SYSTEM_HORDE",
		"CHAT_MSG_BG_SYSTEM_NEUTRAL",
	},
	['whisper'] = {
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_WHISPER_INFORM",
	},
	['party'] = {
		"CHAT_MSG_PARTY",
		"CHAT_MSG_PARTY_LEADER",
	},
	['raid'] = {
		"CHAT_MSG_RAID",
		"CHAT_MSG_RAID_LEADER",
	},
	['instance'] = {
		"CHAT_MSG_INSTANCE_CHAT",
		"CHAT_MSG_INSTANCE_CHAT_LEADER",
	},
	['bnet'] = {
		"CHAT_MSG_BN_WHISPER",
		"CHAT_MSG_BN_CONVERSATION",
		"CHAT_MSG_BN_WHISPER_INFORM",
	},
	['say'] = {
		"CHAT_MSG_SAY",
	},
	['yell'] = {
		"CHAT_MSG_YELL",
	},
	['emote'] = {
		"CHAT_MSG_EMOTE",
		"CHAT_MSG_TEXT_EMOTE",
	},
	['guild'] = {
		"CHAT_MSG_GUILD",
	},
	['officer'] = {
		"CHAT_MSG_OFFICER",
	},
	['monster'] = {
		"CHAT_MSG_MONSTER_YELL",
		"CHAT_MSG_MONSTER_SAY",
		"CHAT_MSG_MONSTER_WHISPER",
		"CHAT_MSG_MONSTER_EMOTE",
		"CHAT_MSG_MONSTER_PARTY",
	},
	['boss'] = {
		"CHAT_MSG_RAID_BOSS_EMOTE",
		"CHAT_MSG_RAID_BOSS_WHISPER",
	},
	['loot'] = {
		"CHAT_MSG_LOOT",
	},
}

-- loot patterns
local lootStrings = {
	item = { 
		pattern = LOOT_ITEM:gsub('%%s', '(.*)'),
		multiple = false,
		self = false,
		roll = false,        
	},
	multiple = { 
		pattern = LOOT_ITEM_MULTIPLE:gsub('%%s', '(.*)'):gsub('%%d', '(%%d+)'),
		multiple = true,
		self = false,         
		roll = false,
	},
	pushItem = { 
		pattern = LOOT_ITEM_PUSHED_SELF:gsub('%%s', '(.*)'),
		multiple = false,
		self = true,         
		roll = false,
	},
	pushMultiple = { 
		pattern = LOOT_ITEM_PUSHED_SELF_MULTIPLE:gsub('%%s', '(.*)'):gsub('%%d', '(%%d+)'),
		multiple = true,
		self = true,         
		roll = false,
	},
	selfItem = { 
		pattern = LOOT_ITEM_SELF:gsub('%%s', '(.*)'),
		multiple = false,
		self = true,         
		roll = false,
	},
	selfMultiple = { 
		pattern = LOOT_ITEM_SELF_MULTIPLE:gsub('%%s', '(.*)'):gsub('%%d', '(%%d+)'),
		multiple = true,
		self = true,         
		roll = false,
	},
	greed = { 
		pattern = LOOT_ROLL_GREED:gsub('%%s', '(.*)'),
		multiple = false,
		self = false,         
		roll = "greed",
	},
	selfGreed = { 
		pattern = LOOT_ROLL_GREED_SELF:gsub('%%s', '(.*)'),
		multiple = false,
		self = true,         
		roll = "greed",
	},
	need = { 
		pattern = LOOT_ROLL_NEED:gsub('%%s', '(.*)'),
		multiple = false,
		self = false,         
		roll = "need",
	},
	selfNeed = { 
		pattern = LOOT_ROLL_NEED_SELF:gsub('%%s', '(.*)'),
		multiple = false,
		self = true,         
		roll = "need",
	},
	won = { 
		pattern = LOOT_ROLL_WON:gsub('%%s', '(.*)'),
		multiple = false,
		self = true,         
		roll = "won",
	},
	selfWon = { 
		pattern = LOOT_ROLL_YOU_WON:gsub('%%s', '(.*)'),
		multiple = false,
		self = true,         
		roll = "won",
	},
}

-- infrastructure
function Addon:OnInitialize()
	-- constants
	self.CLASS_CHANNEL = "channel"
	self.CLASS_MESSAGE = "message"

	-- default maximum number of channels
	self.MAXALERTCHANNELS = 10

	-- setup player
	self.PlayerName = UnitName("player")
	self.playerName = strlower(self.PlayerName)

	-- debug
	self.debug = false

	-- constants
	self.DEFAULT_AREA = {
		blizz  = "dummy",
		msbt   = _G.MikSBT and _G.MikSBT.DISPLAYTYPE_NOTIFICATION or "Notification",
		parrot = "Notification",
		sct    = "Messages",
	}
	
	self.SCT_FRAMES = { "Incoming", "Outgoing", "Messages" }

	-- table of message handlers
	self.messageHandlers = {}
		
	-- active channels id->name
	self.channels = {}
	
	-- class cache
	self.unitCache	= {}
	
	-- combat state
	self.inCombat = false
	
	self:RegisterChatCommand("bchatalerts", "ChatCommand")
    self:RegisterChatCommand("bca",         "ChatCommand")
	
	self:SetupTextAlerts()	
end

function Addon:OnEnable()
	-- set module references
	Options       = self:GetModule("Options")
	Tooltip       = self:GetModule("Tooltip")
	MinimapButton = self:GetModule("MinimapButton")
	DataBroker    = self:GetModule("DataBroker")

	Options.RegisterCallback(self, ADDON .. "_SETTING_CHANGED", "UpdateSetting")	

	self:SetupEventHandlers()
	self:UpdateAlertEvents()
		
	-- set initial combat state
	self:UpdateCombatState()
	
	MinimapButton:SetShow(Options:GetSetting("Minimap"))
end

function Addon:OnDisable()
	self:ResetEventHandlers()
	self:UnregisterAlertEvents()
	
	MinimapButton:SetShow(false)
end

function Addon:OnOptionsReloaded()
	MinimapButton:SetShow(Options:GetSetting("Minimap"))

	self:UpdateAlertEvents()
	self:Update()
end

function Addon:ChatCommand(input)
    if input then  
		args = NS:GetArgs(input)
		
		self:TriggerAction(unpack(args))
	        
        NS:ReleaseTable(args)
	else
		self:TriggerAction("help")
	end
end

function Addon:Update()
	self:UpdateData()
	self:UpdateLabel()
end

function Addon:UpdateData()
  -- nothing
end

function Addon:UpdateLabel()
  -- nothing
end

function Addon:OnClick(button)
	if ( button == "RightButton" ) then 
		if IsShiftKeyDown() then
			-- unused
		elseif IsControlKeyDown() then
			-- unused
		elseif IsAltKeyDown() then
			-- unused
		else
			-- open options menu
			self:TriggerAction("menu")
		end
	elseif ( button == "LeftButton" ) then 
		if IsShiftKeyDown() then
			-- unused
		elseif IsControlKeyDown() then
			-- unused
		elseif IsAltKeyDown() then
			-- unused
		else
			-- unused
		end
	end
end

function Addon:TriggerAction(action, ...)
    local args = NS:NewTable(...)

	action = type(action) == "string" and string.lower(action) or ""	

	if action == "menu" then
		-- open options menu
		InterfaceOptionsFrame_OpenToCategory(L[self.FULLNAME])
		InterfaceOptionsFrame_OpenToCategory(L[self.FULLNAME])
	elseif action == "debug" then
		if args[1] == "on" then
			self:Output("debug mode turned on")
			self.debug = true
		end
		if args[1] == "off" then
			self:Output("debug mode turned off")
			self.debug = false
		end
	elseif action == "version" then
		-- print version information
		self:PrintVersionInfo()
	elseif action == "update" then
		self:UpdateAlertEvents()
	else -- if action == "help" then
		-- display help
		self:Output(L["Usage:"])
		self:Output(L["/bchatalerts arg"])
		self:Output(L["/bca arg"])
		self:Output(L["Args:"])
		self:Output(L["version - display version information"])
		self:Output(L["menu - display options menu"])
		self:Output(L["help - display this help"])
	end
    
    NS:ReleaseTable(args)
end

function Addon:CreateTooltip(obj)
	Tooltip:Create(obj)
end

function Addon:RemoveTooltip()
	Tooltip:Remove()
end

function Addon:SetupEventHandlers()
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "CHAT_MSG_CHANNEL_NOTICE")
	self:RegisterEvent("CHAT_MSG_CHANNEL")
	
	-- register events to track combat
	self:RegisterEvent("PLAYER_REGEN_ENABLED",  "UpdateCombatState", false)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateCombatState", true)
end

function Addon:ResetEventHandlers()
	self:UnregisterEvent("CHAT_MSG_CHANNEL_NOTICE")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("CHAT_MSG_CHANNEL")
	
	-- unregister events to track combat
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

-- Setup different sinks for displaying text alerts
-- so far: SCT, MSBT, Default ST, or Error Frame
function Addon:SetupTextAlerts()
	self.sctColors = { }
	self.messageHandlers["sct"] = function (msg, r, g, b)
		self.sctColors.r = r
		self.sctColors.g = g
		self.sctColors.b = b

		local location = Options:GetProviderSetting("sct", "addonarea") or self.DEFAULT_AREA["sct"]
		local sticky   = Options:GetProviderSetting("sct", "sticky")
		
		if location == "Outgoing" then
			location = _G.SCT.FRAME1
		elseif location == "Incoming" then
			location = _G.SCT.FRAME2
		else
			location = _G.SCT.MSG
		end
		
		_G.SCT:DisplayCustomEvent(msg, self.sctColors, sticky, location)
	end
	
	self.messageHandlers["msbt"] = function (msg, r, g, b)
		r = r * 255
		g = g * 255
		b = b * 255
		
		local location = Options:GetProviderSetting("msbt", "addonarea") or self.DEFAULT_AREA["msbt"]
		local sticky   = Options:GetProviderSetting("msbt", "sticky")
		
		_G.MikSBT.DisplayMessage(msg, location, sticky, r, g, b)
	end

	self.messageHandlers["parrot"] = function (msg, r, g, b)
		local location = Options:GetProviderSetting("parrot", "addonarea") or self.DEFAULT_AREA["parrot"]
		local sticky   = Options:GetProviderSetting("parrot", "sticky")
		
		_G.Parrot:ShowMessage(msg, location, sticky, r, g, b)
	end
	
	
	self.messageHandlers["blizz"] = function (msg, r, g, b)
		local sticky   = Options:GetProviderSetting("blizz", "sticky")
		
		if type(_G.CombatText_AddMessage) == "nil" then
			UIParentLoadAddOn("Blizzard_CombatText")
		end
		_G.CombatText_AddMessage(msg, _G.COMBAT_TEXT_SCROLL_FUNCTION, r, g, b, sticky and "crit")
	end

	self.rw_colors = {}
	self.messageHandlers["rw"] = function (msg, r, g, b)
		self.rw_colors.r = (r or 0) * 255
		self.rw_colors.g = (g or 0) * 255
		self.rw_colors.b = (b or 0) * 255
		
		RaidNotice_AddMessage(RaidWarningFrame, msg, self.rw_colors)
	end
	
	self.messageHandlers["default"] = function (msg, r, g, b)
		UIErrorsFrame:AddMessage(msg, r, g, b, 1, 1.75)
	end	
end

function Addon:GetIcon()
	return ICON
end

-- settings
function Addon:UpdateSetting(event, setting, value, old, category, arg1, arg2)
	if category == "Alert" then
		if arg1 == "Text" or arg1 == "Sound" then
			if arg2 == self.CLASS_MESSAGE then
				self:UpdateAlertEvents()
			end
		end
	elseif setting == "Minimap" then
		MinimapButton:SetShow(Options:GetSetting("Minimap"))
	end
end

function Addon:GetSetting(setting)
	return Options:GetSetting(setting)
end

-- channel handling

-- build a custom list of channel ids
function Addon:RefreshChannelIDs()
	self.channels = { }
	local id, name
	
	for i = 1, self.MAXALERTCHANNELS do
		id, name = GetChannelName(i)
		if id > 0 and name ~= nil then
			-- channel exists
			self.channels[id] = name
		else
			-- channel does not exist
			self.channels[id] = nil
		end
	end
end

-- handle channel events
-- NOTE: we keep the options for channels we left (so we can configure trade, lfg etc. while out of town)
function Addon:CHAT_MSG_CHANNEL_NOTICE()
	self:RefreshChannelIDs()
	
	for id = 1, self.MAXALERTCHANNELS do
		local name = self:GetChannelName(id)
		if name and not Options:HasCustomChannelOpts(name) then
			Options:InsertCustomChannelOpts(name)
		end
	end	
end

-- message handling

-- register enabled and unregister disabled events
function Addon:UpdateAlertEvents()
	for k, v in pairs(self.events) do
		if Options:GetText(self.CLASS_MESSAGE, k) > 0 or Options:GetSound(self.CLASS_MESSAGE, k) > 0 then
			-- check to see that it is registered and register if not
			for num, event in pairs(v) do
				self:RegisterEvent(event, "CHAT_MSG")
			end
		else
			-- check to see that it is registered and unregister
			for num, event in pairs(v) do
				self:UnregisterEvent(event)
			end
		end
	end
end

--unregister all events
function Addon:UnregisterAlertEvents()
	for k, v in pairs(self.events) do
		for num, event in pairs(v) do
			self:UnregisterEvent(event)
		end
	end
end

-- event handling

-- handle channel messages
function Addon:CHAT_MSG_CHANNEL(event, ...)
	local message, author, _, _, _, _, _, channelId, _, _, _, guid = ...

	if Options:GetSetting("messageFilters") and self:IsFilteredByMessageEventFilters(event, ...) then
		-- message is filtered out
		self:Debug("CHAT_MSG_CHANNEL: filtered out msg '" .. tostring(message) .. "'")
		return
	end
		
	self:ChatEventHandler(message, author, event, channelId, guid)
end

-- handle all other chat events
function Addon:CHAT_MSG(event, ...)
	local message, author, _, _, _, _, _, _, _, _, _, guid, presenceId = ...

	if self.events.loot[1] == event then
		-- special treatment for loot messages
		self:HandleLootMessage(event, message)
	else
		local client = nil
		
		-- special treatment for bnet conversations
		if self:IsBNetEvent(event) then
			-- get client info
			local toon = nil
			
			_, toon, client = BNGetGameAccountInfo(presenceId)

			-- reset guid
			guid = nil
		end

		if self:IsSendWhisperEvent(event) then
			author = self.PlayerName
		end
		
		self:ChatEventHandler(message, author, event, nil, guid, client)
	end
end

-- message processing

-- general message handling
function Addon:ChatEventHandler(message, author, event, channelId, guid, client)
	-- check if own messages are ok
	if author == self.PlayerName and not Options:GetSetting("showPlayerMsg") then
		return
	end
	
	-- check if alerts can be used in current combat state
	if not self:CombatStateAllowsAlerts() then
		return
	end
	
	local class
	local type
	local id
	
	if channelId then
		class = self.CLASS_CHANNEL
		type  = self:GetChannelName(channelId)
		id    = channelId
	else
		class = self.CLASS_MESSAGE
		type  = self:GetMessageType(event)
		id    = event
	end
	
	local text  = Options:GetText(class, type)
	local sound = Options:GetSound(class, type)	
	
	local hit = true		

	if text == 2 or sound == 2 then
		hit = self:FilterHit(message)
	end
	
	if text > 0 then
		if text == 1 or hit then
			-- store authors unit information
			self:AddToUnitCache(author, guid)
			
			local color      = self:GetColorFromChatUI(class, id)
			local scrollarea = Options:GetScrollArea(class, type) or Options:GetSetting("scrollarea")
			
			self:ChatAlertMessage(message, author, color, scrollarea, client)
		end
	end
	
	if sound > 0 then 
		if sound == 1 or hit then
			self:PlaySoundFile()
		end
	end
end

-- loot message handling
function Addon:HandleLootMessage(event, message)
	local itemLink, itemName, rarity, qty, count, who, roll
	
	for _, loot in pairs(lootStrings) do
		if message:find(loot.pattern) then
			if not loot.self then
				if loot.multiple then
					who, itemLink, qty = message:match(loot.pattern)
				else
					who, itemLink = message:match(loot.pattern)
				end
			else
				if loot.multiple then
					itemLink, qty = message:match(loot.pattern)
				else
					itemLink = message:match(loot.pattern)
				end
			end
			
			if loot.self then
				who = "You"
			end
			
			if not loot.multiple then
				qty = 1
			end
			
			roll = loot.roll

			itemName, _, rarity = GetItemInfo(itemLink)
			count = qty + GetItemCount(itemLink)
		end
	end
	
	if itemName and count and who then
		local minQuality
		
		if who == "You" then
			if Options:GetLootSetting("countEm") and count > 1 then 
				message = message..NS:Colorize("Yellow", " ("..count..")") 
			end
			minQuality = Options:GetLootSetting("minPlayer")
		elseif not Options:GetLootSetting("onlyMyLoot") then
			minQuality = Options:GetLootSetting("minOther")
		else
			minQuality = 8        
		end
				
		if roll then
			if roll == "need" then
				message = string.gsub(message, "Need", NS:Colorize("White", L["NEED"]))
			end
			if Options:GetLootSetting("needy") then
				if roll == "need" or roll == "won" then
					self:ChatEventHandler(message, nil, event)
				end
			else
				self:ChatEventHandler(message, nil, event)
			end
		elseif rarity >= minQuality then
			self:ChatEventHandler(message, nil, event)
		end 
	end
end

-- text alerts

-- display chat messages in the desired scroll area
function Addon:ChatAlertMessage(msg, author, color, scrollarea, client)
	-- set colors based on chat frames
	if not color or type(color) ~= "table" then
		color = { }
	end
	
	local r = color.r or 0.9
	local g = color.g or 0.9
	local b = color.b or 0.9

	-- display message 
	local handler = self:GetMessageHandler(scrollarea)
	
	if handler then
		if author and strlen(author) > 0 then
			msg = self:ColorizeChar(author) .. ":  " .. msg
		end
		
		if Options:GetSetting("wrapLines") then
			msg = wrap(msg, Options:GetSetting("lineLength"))
		end
		
		if client then
			if Options:GetSetting("clientIcon") then
				msg = self:GetClientIcon(client) .." " .. msg
			end
		else
			if Options:GetSetting("raceIcon") then
				msg = self:GetRaceIconForChar(author) .." " .. msg
			end
		end
		
		handler(msg, r, g, b)
	end	
end

function Addon:GetMessageHandler(name)
	if self:IsMessageHandlerReady(name) then
		return self.messageHandlers[name]
	else
		return self.messageHandlers["default"]
	end
end

function Addon:IsMessageHandlerReady(name)
	-- checks for msbt, parrot and sct looked up in LibSink-2.0 so thanks to ckk as well :-)
	if name == "sct" then
		return _G.SCT and _G.SCT:IsEnabled()
	elseif name == "msbt" then
		-- NOTE: only works with version 5, no legacy support though
		return _G.MikSBT and not _G.MikSBT.IsModDisabled()
	elseif name == "parrot" then
		if _G.Parrot then 
			return _G.Parrot.IsEnabled and _G.Parrot:IsEnabled() or _G.Parrot:IsActive()
		end
		
		return false
	elseif name == "blizz" then
		return _G.COMBAT_TEXT_TYPE_INFO and true or false
	elseif name == "rw" then
		return true
	elseif name == "default" then
		return true
	end

	return false
end

function Addon:CheckMessageHandlerLocation(name, target)
	if name == "sct" then
		for _, location in pairs(self.SCT_FRAMES) do
			if target == location then
				return true
			end
		end
	elseif name == "msbt" then
		locations = _G.MikSBT and _G.MikSBT:IterateScrollAreas() or {}
		for _, location in locations do
			if target == location then
				return true
			end
		end		
	elseif name == "parrot" then
		local locations
		
		if _G.Parrot then
			if _G.Parrot.GetScrollAreasChoices then
				locations = _G.Parrot:GetScrollAreasChoices() or {}
			else
				locations = _G.Parrot:GetScrollAreasValidate() or {}
			end
		end
		
		for _, location in pairs(locations) do
			if target == location then
				return true
			end
		end
	elseif name == "blizz" then
		return true
	elseif name == "rw" then
		return true
	elseif name == "default" then
		return true
	end

	return false
end

-- user functions
function Addon:PrintVersionInfo()
    self:Output(L["Version"] .. " " .. NS:Colorize("White", GetAddOnMetadata(ADDON, "Version")))
end

-- utilities

-- check if channel is currently active
function Addon:IsActiveChannel(name)
	for i = 1, self.MAXALERTCHANNELS do
		if name == self:GetChannelName(i) then
			return true
		end
	end
	
	return false
end

function Addon:GetExampleEventByType(type)
	if self.events[type] then
		return self.events[type][1]
	end
end

-- get defined type for event
function Addon:GetMessageType(event)
	for type, v in pairs(self.events) do
		for num, check in pairs(v) do
			if event == check then
				return type
			end
		end
	end
end

-- gets localized name for the channel
function Addon:GetChannelName(id)
	local name = self.channels[id]
	
	if name then
		for k, v in pairs(localizedChannels) do
			if string.find(name, v) then
				return v
			end
		end
	end
	
	return name
end

function Addon:FilterHit(message)
	local msg = strlower(message)

	if Options:GetSetting("filterPlayer") == true and strfind(msg, self.playerName) then
		return true
	end

	for _, keyword in Options:IterateKeywords() do
		if strfind(msg, keyword) then
			return true
		end
	end
	
	return false
end

function Addon:PlaySoundFile()
	local sound = Options:GetSoundFile(Options:GetSetting("notificationSound"))

	if ((string.sub(sound, -4) == ".ogg") or (string.sub(sound, -4) == ".mp3")) then
		PlaySoundFile(sound)
	else
		-- PlaySound(sound)
	end
end

function Addon:UpdateCombatState(inCombat)
	if inCombat == nil then
		self.inCombat = UnitAffectingCombat("player")
	else
		self.inCombat = inCombat
	end
end

function Addon:CombatStateAllowsAlerts()
	if self.inCombat then
		return Options:GetSetting("showInCombat")
	else
		return Options:GetSetting("showOutOfCombat")
	end
end

function Addon:AddToUnitCache(name, guid)
	if not guid or type(guid) ~= "string" or guid:len() == 0 then
		return
	end
	
	if name and not self.unitCache[name] then
		local _, class, _, race, sex = GetPlayerInfoByGUID(guid)
		
		if class then
			self.unitCache[name] = {
				class = class,
				race  = race,
				sex   = sex,
			}
		end
	end
end

function Addon:ColorizeChar(name)
	if not name then
		return
	end
	
	local unit = self.unitCache[name]
	
	if unit then
		local colortable = _G["CUSTOM_CLASS_COLORS"] or _G["RAID_CLASS_COLORS"]
		local color = colortable[unit.class] or {}
		return "|cff" .. string.format("%02x%02x%02x", (color.r or 0)*255, (color.g or 0)*255, (color.b or 0)*255) .. name .. "|r"
	else
		return name
	end
end

-- colorize text alerts the same color as the chat frame
function Addon:GetColorFromChatUI(class, id)
	local color
	
	if id then
		if class == self.CLASS_CHANNEL then
			color = ChatTypeInfo["CHANNEL"..tostring(id)]
		elseif class == self.CLASS_MESSAGE and self:GetMessageType(id) then
			-- use first registered event as example color
			color = ChatTypeInfo[strsub(id, 10)]
		end
	end
	
	if not color then
		color = { r = 0.9, g = 0.9, b = 0.9 }
	end
	
	return color
end

function Addon:ColorizeTextLikeChatUI(class, id, text)
	local color = self:GetColorFromChatUI(class, id)
	
	if color and type(color) == "table" then
		return "|cff" .. string.format("%02x%02x%02x", (color.r or 0)*255, (color.g or 0)*255, (color.b or 0)*255) .. text .. "|r"
	end
	
	return text
end

function Addon:Output(msg)
	if ( msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( self.MODNAME..": "..msg, 0.6, 1.0, 1.0 )
	end
end

function Addon:IsFilteredByMessageEventFilters(event, ...)
	local chatFilters = ChatFrame_GetMessageEventFilters(event)
	
	if chatFilters then
		for _, filterFunc in next, chatFilters do
			if filterFunc(nil, event, ...) then 
				return true
			end
		end 
	end 
	
	return false
end

function Addon:IsBNetEvent(event)
	for _, bnet in ipairs(self.events.bnet) do
		if event == bnet then
			return true
		end
	end
	
	return false
end

function Addon:IsSendWhisperEvent(event)
	return event and type(event) == "string" and event:find("_INFORM") ~= nil or false
end

function Addon:GetRaceIconForChar(name)
	if not name then
		return ""
	end
	
	local unit = self.unitCache[name]
	
	if unit then
		return self:GetRaceIcon(unit.race, unit.sex)
	end

	return ""
end

function Addon:GetRaceIcon(race, sex)
	if not RACE_ICON_COORDS[sex] or not RACE_ICON_COORDS[sex][race] then
		return ""
	end
	
	local coords = RACE_ICON_COORDS[sex][race]
	local size   = Options:GetSetting("iconSize")
	local offset = -4 + size/2
	
	return format("|T%s:%s:%s:0:%s:256:512:%s|t", RACE_ICONS, size, size, offset, coords)
end

function Addon:GetClientIcon(client)
	if not BNET_CLIENT_ICONS[client] then
		return ""
	end
	
	local icon   = BNET_CLIENT_ICONS[client]
	local size   = Options:GetSetting("iconSize")
	local offset = -4 + size/2

	return format("|T%s:%s:%s:0:%s|t", icon, size, size, offset)
end

-- test
function Addon:Debug(msg)
	if ( self.debug and msg ~= nil and DEFAULT_CHAT_FRAME ) then
		DEFAULT_CHAT_FRAME:AddMessage( self.MODNAME .. " (dbg): " .. msg, 1.0, 0.37, 0.37 )
	end
end
