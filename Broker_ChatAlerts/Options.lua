local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local Addon = LibStub("AceAddon-3.0"):GetAddon(ADDON)

-- the Options module
local Options = Addon:NewModule("Options")

-- internal event handling
Options.callbacks = LibStub("CallbackHandler-1.0"):New(Options)

-- setup libs
local AceGUI            = LibStub("AceGUI-3.0")
local AceConfig 		= LibStub:GetLibrary("AceConfig-3.0")
local AceConfigReg 		= LibStub:GetLibrary("AceConfigRegistry-3.0")
local AceConfigDialog	= LibStub:GetLibrary("AceConfigDialog-3.0")

local LibSharedMedia = LibStub("LibSharedMedia-3.0", true)

-- get translations
local L              = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- local functions
local strlower = strlower
local strfind  = strfind
local strsub   = strsub
local tsort    = table.sort

local _

-- local variables
local defaults = {
	profile = {
		msg = {
			text = {
				system   = 1,
				whisper  = 1,
				party    = 1,
				raid     = 1,
				instance = 1,
				bnet     = 1,
				say      = 0,
				emote    = 0,
				guild    = 2,
				officer  = 0,
				monster  = 0,
				boss     = 0,
				loot     = 1,
			},
			sound = {
				system   = 0,
				whisper  = 0,
				party    = 0,
				raid     = 0,
				instance = 0,
				bnet     = 0,
				say      = 0,
				emote    = 0,
				guild    = 2,
				officer  = 0,
				monster  = 0,
				boss     = 0,
				loot     = 0,
			},
			scrollarea = {
				guild = "rw",
			},
		},
		channel = {
			text 		= { },
			sound 		= { },
			scrollarea 	= { },
		},
		scrollarea = "default",	          
		drops = {
			minPlayer	= 1,
			minOther 	= 1,
			onlyMyLoot	= false,
			countEm		= true,
			needy		= true,
		},
		addonarea =
		{
			msbt   = "BrokerChatAlerts",
			parrot = "BrokerChatAlerts",
			sct    = "Messages",
		},
		sticky =
		{
			blizz  = true,
			msbt   = true,
			parrot = true,
			sct    = true,
		},
		wrapLines			= false,
		lineLength			= 60,
		filterPlayer		= true,
		keywordString		= "傳奇\n開組",
		keywords			= {"傳奇","開組",},
		notificationSound	= 2,
		showPlayerMsg       = false,
		showInCombat		= true,
		showOutOfCombat		= true,
		messageFilters		= true,
		raceIcon            = true,
		clientIcon          = true,
		iconSize            = 20,
		HideHint			= false,
        Minimap				= true,
	}
}

local providerOptions = {
	sticky    = true,
	addonarea = true,
}

--local constants
local GLOBAL_AREA = "_global"

local soundFiles = {
	[0] = "Sound\\interface\\iTellMessage.ogg",
	[1] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\002_10kwai.mp3",
	[2] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\004_applepie.mp3",
	[3] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\010_watercookie.mp3",
	[4] = "Sound\\Character/BloodElf/BloodElfFemaleRaspberry01.ogg",
	[5] = "sound\\CREATURE\\MANDOKIR\\VO_ZG2_MANDOKIR_LEVELUP_EVENT_01.ogg",
	[6] = "Sound\\Creature\\Meathook\\CS_Meathook_Spawn.ogg",
	[7] = "Sound\\Creature\\BabyMurloc\\BabyMurlocA.ogg",
	[8] = "Sound\\Creature\\MobileAlertBot\\MobileAlertBotIntruderAlert01.ogg",
	[9] = "Sound\\Events\\gruntling_horn_bb.ogg",
	[10] = "Sound\\Interface\\ReadyCheck.ogg",
	[11] = "Sound\\Interface\\RaidWarning.ogg",
	[12] = "Sound\\Creature\\Illidan\\VO_WOE_Illidan_Escort_11.ogg",
	[13] = "sound\\Creature\\Illidan\\BLACK_Illidan_04.ogg",
	[14] = "Sound/Creature/YoggSaron/UR_YoggSaron_Slay01.ogg",
	[15] = "Sound/Creature/WarmasterBlackhorn/VO_DS_Blackhorn_Spell_02.ogg",
	[16] = "Sound/Creature/ShaOfPride/VO_54_SHA_OF_PRIDE_WoundCrit_05.ogg",
	[17] = "Sound/Creature/SiegecrafterBlackfuse/VO_54_SIEGECRAFTER_BLACKFUSE_WoundCrit_05.ogg",
	[18] = "Sound\\spells\\pvpwarningalliance.ogg",
	[19] = "Sound\\spells\\pvpwarninghorde.ogg",
	[20] = "Sound\\Interface\\PVPFlagTakenMono.ogg",
	[21] = "Sound\\doodad\\fx_ograid_siege_weaponmachine_warning.ogg",
	[22] = "Sound\\Creature\\Peon\\PeonReady1.ogg",
	[23] = "Sound\\spells\\achievmentsound1.ogg",
	[24] = "Sound\\interface\\alarmclockwarning2.ogg",
	[25] = "Sound\\doodad\\boatdockedwarning.ogg",
	[26] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\水晶.ogg",
	[27] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\交響.ogg",
	[28] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石搖滾音樂.ogg",
	[29] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石牛頭大佬.ogg",
	[30] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石閃金鎮步卒.ogg",
	[31] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石登場音效1.ogg",
	[32] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石登場音效2.ogg",
	[33] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石塔之丁狗.ogg",
	[34] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石憎惡體.ogg",
	[35] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石霍格.ogg",
	[36] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石霜狼蠻兵.ogg",
	[37] = "Interface\\AddOns\\Broker_ChatAlerts\\Sounds\\爐石嚴厲的士官.ogg",
}

local soundNames = {
	[0] = L["Default"].." (通知訊息)",
	[1] = "白癡公主-十塊",
	[2] = "白癡公主-好吃的蘋果派",
	[3] = "白癡公主-潮吹餅乾",
	[4] = "趣味-吐舌",
	[5] = "趣味-升級啦",
	[6] = "趣味-遊戲時間",
	[7] = "趣味-Baby魚人",
	[8] = "趣味-入侵警報",
	[9] = "趣味-號角",
	[10] = "副本-準備確認",
	[11] = "副本-團隊警告",
	[12] = "副本-伊利丹1",
	[13] = "副本-伊利丹2",
	[14] = "副本-尤格薩倫",
	[15] = "副本-將領黑角",
	[16] = "副本-傲慢之煞",
	[17] = "副本-黑引信",
	[18] = "PVP-聯盟",
	[19] = "PVP-部落",
	[20] = "PVP-戰場拔旗",
	[21] = "攻城武器警報",
	[22] = "其他-準備工作",
	[23] = "其他-成就音效",
	[24] = "其他-鬧鐘音效",
	[25] = "其他-船舶停靠",
	[26] = "其他-水晶",
	[27] = "其他-交響",
	[28] = "爐石-搖滾音樂",
	[29] = "爐石-牛頭大佬",
	[30] = "爐石-閃金鎮步卒",
	[31] = "爐石-登場音效1",
	[32] = "爐石-登場音效2",
	[33] = "爐石-塔之丁狗",
	[34] = "爐石-憎惡體",
	[35] = "爐石-霍格",
	[36] = "爐石-霜狼蠻兵",
	[37] = "爐石-嚴厲的士官",
}

local tristate = {
	[0]  = NS:Colorize("Red",    L["Deactivated"]), 
	[1]  = NS:Colorize("Green",  L["Activated"]), 
	[2]  = NS:Colorize("Yellow", L["Filtered"]), 
}

local providers = {"blizz", "msbt", "parrot", "sct"}

-- coloring
NS.HexColors["Poor"]      = "9d9d9d"
NS.HexColors["Common"]    = "ffffff"
NS.HexColors["Uncommon"]  = "1eff00"
NS.HexColors["Rare"]      = "0070dd"
NS.HexColors["Epic"]      = "a334ee"
NS.HexColors["Legendary"] = "ff8000"
NS.HexColors["Artifact"]  = "e6cc80"

local lootLevel = {
	[0] = NS:Colorize("Poor",      L["Poor"]), 
	[1] = NS:Colorize("Common",    L["Common"]),
	[2] = NS:Colorize("Uncommon",  L["Uncommon"]),
	[3] = NS:Colorize("Rare",      L["Rare"]),
	[4] = NS:Colorize("Epic",      L["Epic"]),
	[5] = NS:Colorize("Legendary", L["Legendary"]),
	[6] = NS:Colorize("Artifact",  L["Artifact"]),
}

-- for sorted keyword list we only care that the shortest keywords (which are more likely to produce a match) are first
local function KeywordLessThan(a, b) 
	return a:len() < b:len() 
end

-- module handling
function Options:OnInitialize()
	-- options
	self.options = {}
	
	-- options
	self.db = LibStub:GetLibrary("AceDB-3.0"):New(Addon.MODNAME.."_DB", defaults, "Default")
		
	self:Setup()
		
	-- profile support
	self.options.args.profile = LibStub:GetLibrary("AceDBOptions-3.0"):GetOptionsTable(self.db)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied",  "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset",   "OnProfileChanged")

	AceConfigReg:RegisterOptionsTable(Addon.FULLNAME, self.options)
	AceConfigDialog:AddToBlizOptions(Addon.FULLNAME, L[Addon.FULLNAME])
end

function Options:OnEnable()
	-- empty
end

function Options:OnDisable()
	-- empty
end

function Options:OnProfileChanged(event, database, newProfileKey)
	self.db.profile = database.profile
	
	Addon:OnOptionsReloaded()
end

function Options:Setup()
    self.options = {
		handler = Options,
		type = 'group',
		name = L[Addon.FULLNAME],
		args = {
			general = {
				type = 'group',
				name = L["General"],
				order = 5,
				desc = L["Setup general options."],
				args = {
					scrollarea = { 
						type = 'select',
						name = L["Default Alert Location"],
						desc = L["Choose what method you would like to use for displaying text alerts. SCT, Mik's Scrolling Battle Text, Parrot, Blizzard Scrolling Text, and the default UI are supported. Grayed-out entries are currently not active."],
						order = 1,
						get  = function() return self:GetSetting("scrollarea") end,
						set  = function(info, value)
							self:SetSetting("scrollarea", value) 
						end,
						values = "QueryLocations",
					},
					messageFilters = {
						type = 'toggle',
						name = L["Message Filters"],
						desc = L["Message filters will be applied before processing channel messages. Message filters are introduced by other addons such as spam filtering addons."],
						get  = function() return self:GetSetting("messageFilters") end,
						set  = function()
							self:ToggleSetting("messageFilters") 
						end,
						order = 2,
					},
					notificationSound = { 
						type = 'select',
						name = L["Notification Sound"],
						desc = L["Choose sound to be played on notifications."],
						order = 3,
						get  = function() return self:GetSetting("notificationSound") end,
						set  = function(info, value)
							self:SetSetting("notificationSound", value) 
						end,
						values = soundNames,
					},
					playSound = { 
						type = 'execute',
						name = L["Play Sound"],
						desc = L["Play selected notification sound."],
						order = 4,
						func = function() Addon:PlaySoundFile() end,	
					},
					inCombat = {
						type = 'toggle',
						name = L["Show in Combat"],
						desc = L["Show alerts while engaged in combat."],
						order = 5,
						get  = function() return self:GetSetting("showInCombat") end,
						set  = function()
							self:ToggleSetting("showInCombat") 
						end,
					},
					outOfCombat = {
						type = 'toggle',
						name = L["Show out of Combat"],
						desc = L["Show alerts while out of combat."],
						order = 6,
						get  = function() return self:GetSetting("showOutOfCombat") end,
						set  = function()
							self:ToggleSetting("showOutOfCombat") 
						end,
					},
					showPlayerMsg = {
						type = 'toggle',
						name = L["Show own Messages"],
						desc = L["Show your own messages."],
						order = 7,
						get  = function() return self:GetSetting("showPlayerMsg") end,
						set  = function()
							self:ToggleSetting("showPlayerMsg") 
						end,
					},
				},
			},
			format = {
				type = 'group',
				name = L["Message Format"],
				order = 5,
				desc = L["Setup message format."],
				args = {
					wrapLines = {
						type = 'toggle',
						name = L["Wrap Lines"],
						desc = L["Wrap lines before displaying text alerts."],
						order = 1,
						get  = function() return self:GetSetting("wrapLines") end,
						set  = function()
							self:ToggleSetting("wrapLines") 
						end,
					},
					lineLength = {
						type = 'range',
						name = L["Line Length"],
						desc = L["Wrap message for text alerts to this line length if wrapping is active."],
						order = 2,
						get  = function() return self:GetSetting("lineLength") end,
						set  = function(info, value)
							self:SetSetting("lineLength", value) 
						end,
						min = 10,
						max = 200,
						step = 1,
					},
					raceIcon = {
						type = 'toggle',
						name = L["Show Sender Icon"],
						desc = L["Show icon indicating race and gender of sender character."],
						order = 3,
						get  = function() return self:GetSetting("raceIcon") end,
						set  = function()
							self:ToggleSetting("raceIcon") 
						end,
					},
					clientIcon = {
						type = 'toggle',
						name = L["Show Client Icon"],
						desc = L["Show icon indicating client of sender in Battle.Net conversations."],
						order = 4,
						get  = function() return self:GetSetting("clientIcon") end,
						set  = function()
							self:ToggleSetting("clientIcon") 
						end,
					},
					iconSize = {
						type = 'range',
						name = L["Icon Size"],
						desc = L["Size of displayed icons."],
						order = 5,
						get  = function() return self:GetSetting("iconSize") end,
						set  = function(info, value)
							self:SetSetting("iconSize", value) 
						end,
						min = 8,
						max = 64,
						step = 2,
					},
				},
			},
			providers = {
				type = 'group',
				name = L["Display Addons"],
				order = 10,
				desc = L["Setup supported display addons."],
				args = {
					-- to be filled
				},
			},
			events = {
				type = 'group',
				name = L["Message Events"],
				order = 10,
				desc = L["Set up alerts for message events"],
				args = {
					text = {
						type = 'group',
						name = L["Text Message Alerts"],
						order = 1,
						desc = L["Choose message types where you want text displayed."],
						args = {
							-- about to be filled
						},
					},
					sound = {
						type = 'group',
						name = L["Sound Alerts"],
						order = 2,
						desc = L["Choose message types where you to hear a notify sound."],
						args = {
							-- about to be filled
						},
					},
					scrollarea = {
						type = 'group',
						name = L["Scroll Area"],
						order = 3,
						desc = L["Choose a specific location for the message alert other than the default location."],
						args = {
							-- about to be filled
						},
					},
				},
			},
			channels = {
				type = 'group',
				name = L["Channel Alerts"],
				order = 15,
				desc = L["Set up alerts for specific channels"],
				args = {
					text = {
						type = 'group',
						name = L["Text Message Alerts"],
						order = 1,
						desc = L["Set text alerts for specific channels"],
						args = {
							-- blank until channels learned
						},
					},
					sound = {
						type = 'group',
						name = L["Sound Alerts"],
						order = 2,
						desc = L["Set sounds for specific channels"],
						args = {
							-- blank until channels learned
						},
					},
					scrollarea = {
						type = 'group',
						name = L["Scroll Area"],
						order = 3,
						desc = L["Choose a specific location for the channel alert other than the default location."],
						args = {
							-- blank until channels learned
						},
					},
				},
			},
			drops = {
				type = 'group',
				name = L["Loot Options"],
				order = 20,
				desc = L["Choose message types where you want text displayed."],
				args = {
					rarity = {
						type = 'select',
						name = L["Minimum Rarity - Self"],
						desc = L["Choose the minimum rarity to alert when looting."],
						order = 1,
						get  = function() return self:GetLootSetting("minPlayer") end,
						set  = function(info, value)
							self:SetLootSetting("minPlayer", value) 
						end,
						values = lootLevel,
					},
					others = {
						type = 'select',
						name = L["Minimum Rarity - Others"],
						desc = L["Choose the minimum rarity to alert when OTHERS are looting."],
						order = 2,
						get  = function() return self:GetLootSetting("minOther") end,
						set  = function(info, value)
							self:SetLootSetting("minOther", value) 
						end,
						values = lootLevel,
					},
					myloot  = {
						type = "toggle",
						name = L["Show my loot only"],
						order = 3,
						desc = L["Toggle whether or not to show other looters or just your own."],
						get  = function() return self:GetLootSetting("onlyMyLoot") end,
						set  = function()
							self:ToggleLootSetting("onlyMyLoot") 
						end,
					},
					count  = {
						type = "toggle",
						name = L["Show total quanity"],
						order = 4,
						desc = L["Toggle whether the total quantity in your bags should be shown in the loot text alert."],
						get  = function() return self:GetLootSetting("countEm") end,
						set  = function()
							self:ToggleLootSetting("countEm") 
						end,
					},
					needy  = {
						type = "toggle",
						name = L["Show need and winner only"],
						order = 5,
						desc = L["Toggle whether to show only Need and Winner on rolls."],
						get  = function() return self:GetLootSetting("needy") end,
						set  = function()
							self:ToggleLootSetting("needy") 
						end,
					},
				},
			},
			filter = {
				type = 'group',
				name = L["Filter Options"],
				order = 25,
				desc = L["Filter for events and channel messages."],
				args = {
					player = {
						type = 'toggle',
						name = L["Player Name"],
						desc = L["Message will be shown if it contains the player name."],
						order = 1,
						get  = function() return self:GetSetting("filterPlayer") end,
						set  = function()
							self:ToggleSetting("filterPlayer") 
						end,
					},
					keywords = {
						type = "input",
						name = L["Keywords"],
						desc = L["List of keywords. Message will be shown if any keyword is matched."],
						order = 2,
						multiline = 3,
						get = function() return self:GetKeywords() end,
						set  = function(info, value)
							self:SetKeywords(value) 
						end,
					},
				},
			},
			test = {
				type = 'group',
				name = L["Test Alert Locations"],
				desc = L["Test text alerts settings."],
				order = 30,
				args = {
					event = { 
						type = 'select',
						name = L["Test Event"],
						desc = L["Select event mimicked for the test."],
						order = 1,
						get = function() return self.testEvent end,	
						set = function(info, key)
							self.testEvent = key
						end,
						values = "QueryTestEvents",
					},
					message = {
						type = "input",
						name = L["Test Text"],
						desc = L["Text to display for test."],
						order = 2,
						multiline = 3,
						get = function()
								return self.testText or L["Test text."]
							end,
						set = function(info, key)
							self.testText = key
						end,
					},
					runtest = { 
						type = 'execute',
						name = L["Execute Test"],
						desc = L["Execute test event."],
						order = 3,
						func = function() self:RunTest() end,	
					},
				},
			},
			minimap = {
				type = 'toggle',
				name = L["Minimap Button"],
				desc = L["Show Minimap Button"],
				order = 1,
				get  = function() return self:GetSetting("Minimap") end,
				set  = function()
					self:ToggleSetting("Minimap")
				end,
			},
			hint = {
				type = 'toggle',
				name = L["Hide Hint"],
				desc = L["Hide usage hint in tooltip"],
				order = 2,
				get  = function() return self:GetSetting("HideHint") end,
				set  = function()
					self:ToggleSetting("HideHint") 
				end,
			},
		},
	}

	self:InsertProviderOpts()
	self:InsertEventOpts()
end

function Options:InsertProviderOpts()
	local order = 1
	
	for index, provider in pairs(providers) do
		
		self.options.args.providers.args[provider.."_description"] = { 
			type = "header",
			name = L[provider],
			order = order,
		}
		
		self.options.args.providers.args[provider] = { 
			type = 'select',
			name = L["Scroll Area"],
			desc = L["Select display area used by provider."],
			order = order + 1,
			get  = function() return self:GetProviderSetting(provider, "addonarea") or Addon.DEFAULT_AREA[provider] end,
			set  = function(info, value)
				self:SetProviderSetting(provider, "addonarea", value) 
			end,
			values = "QueryProviderLocations",
		}
		
		self.options.args.providers.args[provider.."_sticky"] = {
			type = 'toggle',
			name = L["Sticky"],
			desc = L["Make alert text sicky in scroll area."],
			order = order + 2,
			get  = function() return self:GetProviderSetting(provider, "sticky") end,
			set  = function()
				self:ToggleProviderSetting(provider, "sticky") 
			end,
		}
	
		order = order + 3
	end
end

function Options:InsertEventOpts()
	for event, _ in pairs(Addon.events) do
		local name = L[event]
		
		self.options.args.events.args.text.args[event] = {
			type = "select",
			name = name,
			desc = string.format(L["Toggle %s Messages"], name),
			get = function() return self:GetText(Addon.CLASS_MESSAGE, event) end,
			set = function(info, key) 
				self:SetText(Addon.CLASS_MESSAGE, event, key)
			end,
			values = tristate,
		}
		
		self.options.args.events.args.sound.args[event] = {
			type = "select",
			name = name,
			desc = string.format(L["Toggle %s Sound Alert"], name),
			get = function() return self:GetSound(Addon.CLASS_MESSAGE, event) end,
			set = function(info, key) 
				self:SetSound(Addon.CLASS_MESSAGE, event, key)
			end,
			values = tristate,
		}

		self.options.args.events.args.scrollarea.args[event] = {
			type = 'select',
			name = name,
			desc = string.format(L["Choose specific Alert Location for %s Messages."], name),
			get = function()
				return self:GetScrollArea(Addon.CLASS_MESSAGE, event) or GLOBAL_AREA
			end,	
			set = function(info, key) 
				self:SetScrollArea(Addon.CLASS_MESSAGE, event, key)
			end,
			values = "QueryLocations",
		}
	end
end

function Options:HasCustomChannelOpts(name)
	if self.options.args.channels.args.text.args[name] then
		return true
	end
end

function Options:InsertCustomChannelOpts(name)
	-- check if already present
	if self:HasCustomChannelOpts(name) then
		return
	end

	-- setup options tables
	local textOpts = {
		type = "select",
		name = name,
		desc = L["Toggle text for "]..name,
		get = function() return self:GetText(Addon.CLASS_CHANNEL, name) end,
		set = function(info, key) 
			self:SetText(Addon.CLASS_CHANNEL, name, key)
		end,
		values = tristate,
	}

	local soundOpts = {
		type = "select",
		name = name,
		desc = L["Toggle sound for "]..name,
		get = function() return self:GetSound(Addon.CLASS_CHANNEL, name) end,
		set = function(info, key) 
			self:SetSound(Addon.CLASS_CHANNEL, name, key)
		end,
		values = tristate,
	}

	local areaOpts = {
		type = 'select',
		name = name .. " " .. L["Location"],
		desc = L["Choose specific Alert Location for "]..name,
		get = function() 
			return self:GetScrollArea(Addon.CLASS_CHANNEL, name) or GLOBAL_AREA
		end,	
		set = function(info, key)
			self:SetScrollArea(Addon.CLASS_CHANNEL, name, key)
		end,
		values = "QueryLocations",
	}
	
	-- assign to main option table
	self.options.args.channels.args.text.args[name] = textOpts
	self.options.args.channels.args.sound.args[name] = soundOpts
	self.options.args.channels.args.scrollarea.args[name] = areaOpts
	
	AceConfigReg:NotifyChange(Addon.FULLNAME)
end

function Options:RemoveCustomChannelOpts(name)
	self.options.args.channels.args.text.args[name] = {}
	self.options.args.channels.args.sound.args[name] = {}
	self.options.args.channels.args.scrollarea.args[name] = {}

	AceConfigReg:NotifyChange(Addon.FULLNAME)
end

-- helper
function Options:QueryLocations(info)
	local locations = {}

	if info[#info-1] == "scrollarea" then
		locations[GLOBAL_AREA] = L["Globally set Location"]
	end

	locations["default"] = L["default"]

	locations["rw"] = L["rw"]
	
	if Addon:IsMessageHandlerReady("sct") then
		locations["sct"] = L["sct"]
	else
		locations["sct"] = NS:Colorize("GrayOut", L["sct"])
	end
		
	if Addon:IsMessageHandlerReady("msbt") then
		locations["msbt"] = L["msbt"]
	else
		locations["msbt"] = NS:Colorize("GrayOut", L["msbt"])
	end

	if Addon:IsMessageHandlerReady("parrot") then
		locations["parrot"] = L["parrot"]
	else
		locations["parrot"] = NS:Colorize("GrayOut", L["parrot"])
	end
		
	if Addon:IsMessageHandlerReady("blizz") then
		locations["blizz"] = L["blizz"]
	else
		locations["blizz"] = NS:Colorize("GrayOut", L["blizz"])	
	end

	return locations
end

function Options:QueryProviderLocations(info)
	local locations = {}

	local addon = info[#info]

	if addon == "sct" then
		for _, location in pairs(Addon.SCT_FRAMES) do
			locations[location] = location
		end
	elseif addon == "parrot" then
		local parrotLocs
	
		if _G.Parrot then
			if _G.Parrot.GetScrollAreasChoices then
				parrotLocs = _G.Parrot:GetScrollAreasChoices()
			else
				parrotLocs = _G.Parrot:GetScrollAreasValidate()
			end
		end
		
		for _, location in pairs(parrotLocs or {}) do
			locations[location] = location
		end
		
		-- add default location
		locations[Addon.DEFAULT_AREA[addon]] = L["Default"]
		
		-- add current setting, even if not available anymore
		local current = self:GetProviderSetting("parrot", "addonarea")
		
		if current and not locations[current] then
			locations[current] = NS:Colorize("GrayOut", current)
		end
	elseif addon == "msbt" then
		if _G.MikSBT and _G.MikSBT.IterateScrollAreas then
			for _, location in _G.MikSBT:IterateScrollAreas() do
				locations[location] = location
			end
		end
		
		-- add default location
		locations[Addon.DEFAULT_AREA[addon]] = L["Default"]
		
		-- add current setting, even if not available anymore
		local current = self:GetProviderSetting("msbt", "addonarea")
		
		if current and not locations[current] then
			locations[current] = NS:Colorize("GrayOut", current)
		end
	elseif addon == "blizz" then
		-- add default location
		locations[Addon.DEFAULT_AREA[addon]] = L["Default"]
	end
	
	return locations
end

-- settings

-- getter and info
function Options:GetSetting(option)
	return self.db.profile[option]
end

function Options:SetSetting(option, value)
	local current = self:GetSetting(option)

	if current == value then
		return
	end
	
	self.db.profile[option] = value

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", option, value, current)
end

function Options:ToggleSetting(option)
	self:SetSetting(option, not self:GetSetting(option) and true or false)
end

function Options:ToggleSettingTrueNil(option)
	self:SetSetting(option, not self:GetSetting(option) and true or nil)
end

-- loot
function Options:GetLootSetting(option)
	return self.db.profile.drops[option]
end

function Options:SetLootSetting(option, value)
	local current = self:GetLootSetting(option)

	if current == value then
		return
	end
	
	self.db.profile.drops[option] = value

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", option, value, current, "Loot")
end

function Options:ToggleLootSetting(option)
	self:SetLootSetting(option, not self:GetLootSetting(option) and true or false)
end

-- scroll area
function Options:GetScrollArea(class, id)
	if class == Addon.CLASS_MESSAGE then
		return self.db.profile.msg.scrollarea[id]
	elseif class == Addon.CLASS_CHANNEL then
		return self.db.profile.channel.scrollarea[id]
	end
end

function Options:SetScrollArea(class, id, value)
	if value == GLOBAL_AREA then
		value = nil
	end
	
	local current = self:GetScrollArea(class, id)
	
	if current == value then
		return
	end
	
	if class == Addon.CLASS_MESSAGE then
		self.db.profile.msg.scrollarea[id] = value
	elseif class == Addon.CLASS_CHANNEL then
		self.db.profile.channel.scrollarea[id] = value
	else
		return
	end

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", id, value, current, "Alert", "ScrollArea", class)
end

-- text
function Options:GetText(class, id)
	if class == Addon.CLASS_MESSAGE then
		if self.db.profile.msg.text[id] then
			return self.db.profile.msg.text[id]
		end
	elseif class == Addon.CLASS_CHANNEL then
		if self.db.profile.channel.text[id] then
			return self.db.profile.channel.text[id]
		end
	end
		
	return 0
end

function Options:SetText(class, id, value)
	if type(value) ~= "number" then
		return
	end

	value = value % 3
	
	if value == 0 and class == Addon.CLASS_CHANNEL then
		value = nil
	end
	
	local current = self:GetText(class, id)
	
	if current == value then
		return
	end

	if class == Addon.CLASS_CHANNEL then
		self.db.profile.channel.text[id] = value
	elseif class == Addon.CLASS_MESSAGE then
		self.db.profile.msg.text[id] = value
	else
		return
	end

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", id, value, current, "Alert", "Text", class)
end

function Options:ToggleText(class, id)
	local value = (self:GetText(class, id) + 1) % 3
	
	self:SetText(class, id, value)
end

-- sound
function Options:GetSound(class, id)
	if class == Addon.CLASS_MESSAGE then
		if self.db.profile.msg.sound[id] then
			return self.db.profile.msg.sound[id]
		end
	elseif class == Addon.CLASS_CHANNEL then
		if self.db.profile.channel.sound[id] then
			return self.db.profile.channel.sound[id]
		end
	end
		
	return 0
end

function Options:SetSound(class, id, value)
	if type(value) ~= "number" then
		return
	end

	value = value % 3
	
	if value == 0 and class == Addon.CLASS_CHANNEL then
		value = nil
	end
	
	local current = self:GetSound(class, id)
	
	if current == value then
		return
	end

	if class == Addon.CLASS_CHANNEL then
		self.db.profile.channel.sound[id] = value
	elseif class == Addon.CLASS_MESSAGE then
		self.db.profile.msg.sound[id] = value
	else
		return
	end

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", id, value, current, "Alert", "Sound", class)
end

function Options:ToggleSound(class, id)
	local value = (self:GetSound(class, id) + 1) % 3

	self:SetSound(class, id, value)
end

-- provider
function Options:GetProviderSetting(provider, option)
	return self.db.profile[option] and self.db.profile[option][provider]
end

function Options:SetProviderSetting(provider, option, value)
	if not providerOptions[option] then
		return
	end

	local current = self:GetProviderSetting(provider, option)

	if current == value then
		return
	end
	
	self.db.profile[option][provider] = value

	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", option, value, current, "Provider")
end

function Options:ToggleProviderSetting(option)
	self:SetProviderSetting(option, not self:GetProviderSetting(option) and true or false)
end

-- keywords
function Options:GetKeywords()
	return self.db.profile.keywordString
end

function Options:SetKeywords(keywords)
	local current = self:GetKeywords()
	
	if current == keywords then
		return
	end
	
	self.db.profile.keywordString = keywords

	-- update keyword list
	NS:ClearTable(self.db.profile.keywords)
	
	-- get all words excluding spaces, punctuation, control chars
	-- pattern [%a%d]+ does not work for unicode chars
	for word in string.gmatch(keywords, "[^%s%p%c]+") do 
		table.insert(self.db.profile.keywords, strlower(word))
	end
	
	-- sort list by keyword length, shortest first
	tsort(self.db.profile.keywords, KeywordLessThan)
	
	-- fire event when setting changed
	self.callbacks:Fire(ADDON .. "_SETTING_CHANGED", keywordString, value, current, "Keywords")
end

function Options:IterateKeywords()
	return ipairs(self.db.profile.keywords)
end

-- utility
function Options:GetSoundFile(id)
	return soundFiles[id] or soundFiles[0]
end

-- testing
function Options:QueryTestEvents(info)
	local testEvents = {}

	for id = 1, Addon.MAXALERTCHANNELS do	
		local name = Addon:GetChannelName(id)
		if name then
			if not self.testEvent then
				self.testEvent = "channel-"..tostring(id)
			end
			
			testEvents["channel-"..tostring(id)] = Addon:ColorizeTextLikeChatUI(Addon.CLASS_CHANNEL, id, name)
		end
	end
	
	for type, _ in pairs(Addon.events) do
		local event = Addon:GetExampleEventByType(type)
		if not self.testEvent then
			self.testEvent = "event-"..event
		end
		
		testEvents["event-"..event] = Addon:ColorizeTextLikeChatUI(Addon.CLASS_MESSAGE, event, L[type])
	end

	return testEvents
end

function Options:RunTest()
	local msg = self.testText or L["Test text."]

	local test = self.testEvent or 1
	
	local class
	local type
	local id
	
	if strsub(test, 1, 8) == "channel-" then
		class = Addon.CLASS_CHANNEL
		id    = tonumber(strsub(test, 9))
		type  = Addon:GetChannelName(id)
	else
		class = Addon.CLASS_MESSAGE
		id    = strsub(test, 7)
		type  = Addon:GetMessageType(id)
	end

	local color      = Addon:GetColorFromChatUI(class, id)
	local scrollarea = self:GetScrollArea(class, type) or self:GetSetting("scrollarea")	
	
	-- make sure we got the unit information for ourself
	local guid = UnitGUID("player")
		
	Addon:AddToUnitCache(Addon.PlayerName, guid)
	
	-- print the message
	Addon:ChatAlertMessage(msg, Addon.PlayerName, color, scrollarea)
end

function Options:Debug(msg)
	Addon:Debug("(Options) " .. msg)
end
