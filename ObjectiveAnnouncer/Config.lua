local NAME, S = ...
local ObjAnn = _G.ObjAnnouncer
local optionsGUI = {}

local L = LibStub("AceLocale-3.0"):GetLocale("Objective Announcer")
local ACD = LibStub("AceConfigDialog-3.0")
local ACR = LibStub("AceConfigRegistry-3.0")
local LSM = LibStub("LibSharedMedia-3.0")

local CHAT, SAY, PARTY, INSTANCE, RAID, GUILD, OFFICER, CHANNEL = _G.CHAT, _G.CHAT_MSG_SAY, _G.CHAT_MSG_PARTY, _G.INSTANCE_CHAT_MESSAGE, _G.CHAT_MSG_RAID, _G.CHAT_MSG_GUILD, _G.CHAT_MSG_OFFICER, _G.CHANNEL
local ENABLE, DISABLED = _G.ENABLE, _G.ADDON_DISABLED

local myOptions = {
	name = L["ObjectiveAnnouncer"].." "..NAME.." "..S.VERSION.." |cFFFF7F00by Bantou|r |cFF339900and Eincrou|r",
	type = "group",
	childGroups = "tab",
	args = {
		options = {
			name = _G.GENERAL,
			type="group",
			order = 1,
			args={
				announceModes = {
				--	inline = true,
					name = "|TInterface\\Icons\\Ability_Warrior_RallyingCry:18|t "..L["announcemode"],
					desc = L["announcedesc"],
					type="group",
					order = 1,
					args = {
						annchandesc = {
							order = 1,
							type = "description",
							name = L["announcedesc"],
						},								
						announce = {
							name = L["announcemode"],
							desc = L["annmodesdesc"],
							type = "select",
							style = "radio",
							values = L["annvalues"],
							set = function(info,val) ObjAnn.db.profile.annType = val end,
							get = function(info) return ObjAnn.db.profile.annType end,
							order = 2,
						},
						progressbar = {
							name = L["progressbardesc"],
							type = "description",
							order = 3,							
							width = "full"						
						},						
						progressbarint = {
							name = L["progbarinterval"],
							desc = L["progbarintervaldesc"],
							type = "range",
							min = 0.05,
							max = 0.5,
							set = function(info,val) ObjAnn.db.profile.progBarInterval = val * 100 end,
							get = function(info) return ObjAnn.db.profile.progBarInterval / 100 end,			
							step = 0.05,
							order = 4,
							isPercent = true,
							disabled = function ()
								local disableRange = true
								if ObjAnn.db.profile.annType == 3 then
									disableRange = false 
								end
								return disableRange
							end,
						},
					},
				},
				announceChannels = {
				--	inline = true,
					name = "|TInterface\\Icons\\Warrior_disruptingshout:18|t "..L["annchannels"],
					desc = L["annchannelsdesc"],
					type="group",
					order = 2,
					args = {
						annchandesc = {
							order = 1,
							type = "description",
							name = L["annchannelsdesc"],
						},						
					--[[ Private ]]--
						header1 = {
							name = L["privateannheader"],
							type = "header",
							order = 2,
							width = "double"
						},
						mememe = {
							name = L["Self"],
							desc = L["selfdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.selftell = val end,
							get = function(info) return ObjAnn.db.profile.selftell end,
							order = 4,
							disabled = function() return ObjAnn.db.profile.selftellalways end,
							width = "half"
						},
						mememealways = {
							name = L["selfalways"],
							desc = L["selfalwaysdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.selftellalways = val end,
							get = function(info) return ObjAnn.db.profile.selftellalways end,
							order = 6,
							width = "normal"
						},
						selfTextColor = {
							name = L["selfcolor"],
							desc = L["selfcolordesc"],
							type = "color",
							get = function() return ObjAnn.db.profile.selfColor.r, ObjAnn.db.profile.selfColor.g, ObjAnn.db.profile.selfColor.b, 1.0 end,
							set = function(info, r, g, b, a)
								ObjAnn.db.profile.selfColor.r, ObjAnn.db.profile.selfColor.g, ObjAnn.db.profile.selfColor.b = r, g, b
								ObjAnn.db.profile.selfColor.hex = "|cff"..string.format("%02x%02x%02x", ObjAnn.db.profile.selfColor.r * 255, ObjAnn.db.profile.selfColor.g * 255, ObjAnn.db.profile.selfColor.b * 255) 
								end,								
							order = 8,
						},
					--[[ Public ]]--				
						header2 = {
							name = L["publicheader"],
							type = "header",
							order = 10,
							width = "double"
						},
						say = {
							name = "|cFFFFFFFF"..SAY.."|r",
							desc = L["saydesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.saychat = val end,
							get = function(info) return ObjAnn.db.profile.saychat end,
							order = 12,							
							width = "half"
						},
						party = {
							name = "|cFFA8A8FF"..PARTY.."|r",	-- /dump ChatTypeInfo.PARTY
							desc = L["partydesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.partychat = val end,
							get = function(info) return ObjAnn.db.profile.partychat end,
							order = 14,
							width = "half"
						},
						instance = {
							name = "|cFFFD8100"..INSTANCE.."|r",
							desc = L["instancedesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.instancechat = val end,
							get = function(info) return ObjAnn.db.profile.instancechat end,
							order = 16,
							width = "half"
						},
						raid = {
							name = "|cFFFF7F00"..RAID.."|r",
							desc = "Sets whether to announce to Raid Chat.",
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.raidchat = val end,
							get = function(info) return ObjAnn.db.profile.raidchat end,
							order = 18,
							width = "half"
						},
						guild = {
							name = "|cFF40FF40"..GUILD.."|r",
							desc = L["guilddesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.guildchat = val end,
							get = function(info) return ObjAnn.db.profile.guildchat end,
							order = 20,
							width = "half"
						},
						officer = {
							name = "|cFF40C040"..OFFICER.."|r",
							desc = L["officerdesc"],
							type = "toggle",
							disabled = function() return ObjAnn.db.profile.guildchat end,
							set = function(info,val) ObjAnn.db.profile.officerchat = val end,
							get = function(info) return ObjAnn.db.profile.officerchat end,
							order = 22,
							width = "half",
						},
						channel = {
							name = "|cFFFFC0C0"..CHANNEL.."|r",
							desc = L["channeldesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.channelchat = val end,
							get = function(info) return ObjAnn.db.profile.channelchat end,
							order = 24,
						},
						channelName = {
							name = L["channelselect"],
							desc = L["channelselectdesc"],
							type = "select",
							values = function()
								local ChatChannelList = {}
								for i = 1, 10 do
									local channelID = select((i*2)-1, GetChannelList())
									if channelID then
										ChatChannelList[channelID] = "|cff2E9AFE"..channelID..".|r  "..select(i*2,GetChannelList())
									end
								end
								return ChatChannelList
							end,
							set = function(info,val) ObjAnn.db.profile.chanName = val end,
							get = function(info) return ObjAnn.db.profile.chanName end,
							order = 26,
						},
					},
				},
				oorAlerts = {
				--	inline = true,
					name = "|TInterface\\Icons\\ability_rogue_combatexpertise:18|t "..L["oor"],
					desc = L["oordesc"],
					type="group",
					order = 4,
					args={
						oorrequires = {
							order = 1,
							type = "description",
							name = L["oorrequires"],
						},					
						qlink = {
							name = L["oorenable"],
							desc = L["oorenabledesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.enableOOR = val end,
							get = function(info) return ObjAnn.db.profile.enableOOR end,
							order = 2,
						},							
					},
				},					
				extraInfo = {
				--	inline = true,
					name = "|TInterface\\Icons\\inv_jewelry_trinket_15:18|t "..L["extrainfo"],
					desc = L["extrainfodesc"],
					type="group",
					order = 4,
					args={
						infodesc = {
							order = 1,
							type = "description",
							name = L["extrainfodesc"],
						},
						qlink = {
							name = L["extrainfoquestlink"],
							desc = L["extrainfoquestlinkdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questlink = val end,
							get = function(info) return ObjAnn.db.profile.questlink end,
							order = 2,
						},
						qgroupsize = {
							name = L["extrainfosugggroup"],
							desc = L["extrainfosugggroupdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.infoSuggGroup = val end,
							get = function(info) return ObjAnn.db.profile.infoSuggGroup end,
							order = 3,
						},
						qtag = {
							name = L["extrainfoquesttag"],
							desc = L["extrainfoquesttagdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.infoTag = val end,
							get = function(info) return ObjAnn.db.profile.infoTag end,
							order = 4,
						},
						qfreq = {
							name = L["extrainfofreq"],
							desc = L["extrainfofreqdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.infoFrequency = val end,
							get = function(info) return ObjAnn.db.profile.infoFrequency end,
							order = 5,
						},									
						qlevel = {
							name = L["extrainfoquestlevel"],
							desc = L["extrainfoquestleveldesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.infoLevel = val end,
							get = function(info) return ObjAnn.db.profile.infoLevel end,
							order = 6,
						},
			
					},
				},
				questStartEnd = {
				--	inline = true,
					name = "|TInterface\\Icons\\Achievement_quests_completed_08:18|t "..L["queststartend"],
					desc = L["qsedesc"],
					type="group",
					order = 5,
					args={
						oordesc = {
							order = 10,
							type = "description",
							name = L["qsedesc"],
						},			
						taskArea = {
							name = L["qsebonusobj"],
							desc = L["qsebonusobjdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questTask = val end,
							get = function(info) return ObjAnn.db.profile.questTask end,
							order = 11,
							width = "double",
						},
						header1 = {
							name = L["headerstart"],
							type = "header",
							order = 20,
							width = "double"
						},						
						accept = {
							name = L["qseaccept"],
							desc = L["qseacceptdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questAccept = val end,
							get = function(info) return ObjAnn.db.profile.questAccept end,
							order = 30,
							width = "normal",
						},
						escort = {
							name = L["qseescort"],
							desc = L["qseescortdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questEscort = val end,
							get = function(info) return ObjAnn.db.profile.questEscort end,
							order = 50,
							width = "double",
						},						
						header2 = {
							name = L["headerend"],
							type = "header",
							order = 60,
							width = "double"
						},										
						turnIn = {
							name = L["qseturnin"],
							desc = L["qseturnindesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questTurnin = val end,
							get = function(info) return ObjAnn.db.profile.questTurnin end,
							order = 70,
						},
						qabandon = {
							name = L["qseabandon"],
							desc = L["qseabandondesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questAbandon = val end,
							get = function(info) return ObjAnn.db.profile.questAbandon end,
							order = 80,
						},	
						qfailed = {
							name = L["qsefail"],
							desc = L["qsefaildesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questFail = val end,
							get = function(info) return ObjAnn.db.profile.questFail end,
							order = 90,
						},	
						questXP = {
							name = L["qseexp"],
							desc = L["qseexpdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questXP = val end,
							get = function(info) return ObjAnn.db.profile.questXP end,
							order = 100,
						},		
						questRewards = {
							name = L["qserewards"],
							desc = L["qserewardsdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.questRewards = val end,
							get = function(info) return ObjAnn.db.profile.questRewards end,
							order = 110,
						},							
									
						qautocomp = {
							name = L["qseautocomplete"],
							desc = L["qseautocompletedesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.infoAutoComp = val end,
							get = function(info) return ObjAnn.db.profile.infoAutoComp end,
							order = 120,								
						},
					},
				},					
				soundOptions = {
				--	inline = true,
					name = "|TInterface\\Icons\\Inv_misc_archaeology_trolldrum:18|t ".._G.SOUND_LABEL,
					desc = L["sounddesc"],
					type="group",
					order = 6,
					args={
						oordesc = {
							order = 10,
							type = "description",
							name = L["sounddesc"],
						},						
						header1 = {
							name = L["soundcompletion"],
							type = "header",
							order = 20,
							width = "double"
						},							
						soundCompletion = {
							name = ENABLE,
							desc = L["soundcompletiondesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.enableCompletionSound = val end,
							get = function(info) return ObjAnn.db.profile.enableCompletionSound end,
							order = 30,
							width = "half",
						},
						soundFileObj = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							values = AceGUIWidgetLSMlists.sound,
							order = 40,
							name = L["soundobjcompletefile"],
							desc = L["soundobjcompletefiledesc"],
							get = function() return ObjAnn.db.profile.annSoundName end,
							set = function(info, value)
								ObjAnn.db.profile.annSoundName = value
								ObjAnn.db.profile.annSoundFile = LSM:Fetch("sound", ObjAnn.db.profile.annSoundName)									
							end,
						},
						soundFileQuest = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							values = AceGUIWidgetLSMlists.sound,
							order = 50,
							name = L["soundquestcompletefile"],
							desc = L["soundquestcompletefiledesc"],
							get = function() return ObjAnn.db.profile.compSoundName end,
							set = function(info, value)
								ObjAnn.db.profile.compSoundName = value
								ObjAnn.db.profile.compSoundFile = LSM:Fetch("sound", ObjAnn.db.profile.compSoundName)
								
							end,
						},
						header2 = {
							name = L["soundacceptfail"],
							type = "header",
							order = 60,
							width = "double"
						},							
						soundAcceptFail = {
							name = ENABLE,
							desc = L["soundacceptfaildesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.enableAcceptFailSound = val end,
							get = function(info) return ObjAnn.db.profile.enableAcceptFailSound end,
							order = 70,
							width = "half",
						},
						soundFileAccept = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							values = AceGUIWidgetLSMlists.sound,
							order = 80,
							name = L["soundacceptfile"],
							desc = L["soundacceptfiledesc"],
							get = function() return ObjAnn.db.profile.acceptSoundName end,
							set = function(info, value)
								ObjAnn.db.profile.acceptSoundName = value
								ObjAnn.db.profile.acceptSoundFile = LSM:Fetch("sound", ObjAnn.db.profile.acceptSoundName)									
							end,
						},
						soundFileFail = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							values = AceGUIWidgetLSMlists.sound,
							order = 90,
							name = L["soundfailfile"],
							desc = L["soundfailfiledesc"],
							get = function() return ObjAnn.db.profile.failSoundName end,
							set = function(info, value)
								ObjAnn.db.profile.failSoundName = value
								ObjAnn.db.profile.failSoundFile = LSM:Fetch("sound", ObjAnn.db.profile.failSoundName)
								
							end,
						},	
						header3 = {
							name = L["soundcommunication"],
							type = "header",
							order = 100,
							width = "double"
						},							
						soundComm = {
							name = ENABLE,
							desc = L["soundcommunicationdesc"],
							type = "toggle",
							set = function(info,val) ObjAnn.db.profile.enableCommSound = val end,
							get = function(info) return ObjAnn.db.profile.enableCommSound end,
							order = 110,
							width = "half",
						},	
						soundFileComm = {
							type = 'select',
							dialogControl = 'LSM30_Sound',
							values = AceGUIWidgetLSMlists.sound,
							order = 120,
							name = L["soundcommfile"],
							desc = L["soundcommfiledesc"],
							get = function() 
								return ObjAnn.db.profile.commSoundName
							end,
							set = function(info, value)
								ObjAnn.db.profile.commSoundName = value
								ObjAnn.db.profile.commSoundFile = LSM:Fetch("sound", ObjAnn.db.profile.commSoundName)								
							end,
						},							
					},
				},
			},
		},
	},
}

local helpText = [[Usage:
   |cff55ffff/oa or /obja|r Open options interface
   |cff55ff55/oa quest|r Quests Only
   |cff55ff55/oa obj|r Objectives Only
   |cff55ff55/oa both|r Both Quests & Objectives
   |cff55ff55/oa prog|r Objectives Progress
   |cff55ff55/oa progq|r Progress and Completed Quests
   |cff55ff55/oa self|r Toggle Self Messages
   |cff55ff55/oa pub |r<|cff55ff55channel|r> Toggle Public Channels
   |cff55ff55/oa oor|r Toggle Out-of-range Alerts]]
 --[[   |cff55ff55/oa accept|r Toggle "Accept A Quest"
   |cff55ff55/oa turnin|r Toggle "Turn In A Quest"
   |cff55ff55/oa xp|r Toggle "Quest Experience"
   |cff55ff55/oa escort|r Toggle "Auto-Accept Escort/Event Quests"
   |cff55ff55/oa fail|r Toggle "Quest Failure"
   |cff55ff55/oa soundcomp|r Toggle Completion Sounds
   |cff55ff55/oa soundaf|r Toggle Accept/Fail Sounds   
   |cff55ff55/oa soundcomm|r Toggle Communication Sounds]]
   
local slashCommands = {
	["quest"] = function()
		ObjAnn.db.profile.annType = 1
		ObjAnnouncer:Print(L["slashquest"])
	end,
	["obj"] = function()
		ObjAnn.db.profile.annType = 2
		ObjAnnouncer:Print(L["slashobj"])
	end,
	["both"] = function()
		ObjAnn.db.profile.annType = 3
		ObjAnnouncer:Print(L["slashboth"])
	end,
	["prog"] = function()
		ObjAnn.db.profile.annType = 4
		ObjAnnouncer:Print(L["slashprog"])
	end,
	["progq"] = function()
		ObjAnn.db.profile.annType = 5
		ObjAnnouncer:Print(L["slashprogq"])		
	end,
	["self"] = function()
		if ObjAnn.db.profile.selftell then
			ObjAnn.db.profile.selftell = false
			ObjAnn.db.profile.selftellalways = false
			ObjAnnouncer:Print(L["slashself"].." |cFFFF0000".._G.ADDON_DISABLED.."|r "..L["slashselfdis"])
		else
			ObjAnn.db.profile.selftell = true
			ObjAnnouncer:Print(L["slashself"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,
	["pub"] = function(v)
		if v == "say" then
			if ObjAnn.db.profile.saychat then
				ObjAnn.db.profile.saychat = false
				ObjAnnouncer:Print("|cFFFFFFFF"..SAY.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.saychat = true
				ObjAnnouncer:Print("|cFFFFFFFF"..SAY.." "..CHAT.."|r |cFF00FF00"..L["enabled"].."|r")
			end
		elseif	v == "party" then
			if ObjAnn.db.profile.partychat then
				ObjAnn.db.profile.partychat = false
				ObjAnnouncer:Print("|cFFA8A8FF"..PARTY.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.partychat = true
				ObjAnnouncer:Print("|cFFA8A8FF"..PARTY.." "..CHAT.."|r |cFF00FF00"..L["enabled"].."|r")
			end
		elseif v == "instance" then
			if ObjAnn.db.profile.instancechat then
				ObjAnn.db.profile.instancechat = false
				ObjAnnouncer:Print("|cFFFD8100"..INSTANCE.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.instancechat = true
				ObjAnnouncer:Print("|cFFFD8100"..INSTANCE.." "..CHAT.."|r |cFF00FF00"..L["enabled"].."|r")
			end
		elseif v == "raid" then
			if ObjAnn.db.profile.raidchat then
				ObjAnn.db.profile.raidchat = false
				ObjAnnouncer:Print("|cFFFF7F00"..RAID.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.raidchat = true
				ObjAnnouncer:Print("|cFFFF7F00"..RAID.." "..CHAT.."|r |cFF00FF00"..L["enabled"].."|r")
			end		
		elseif v == "guild" then
			if ObjAnn.db.profile.guildchat then
				ObjAnn.db.profile.guildchat = false
				ObjAnnouncer:Print("|cFF40ff40"..GUILD.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.guildchat = true
				ObjAnnouncer:Print("|cFF40ff40"..GUILD.." "..CHAT.."|r |cFF00FF00"..L["enabled"].."|r")
			end
		elseif v == "officer" then
			if ObjAnn.db.profile.officerchat then
				ObjAnn.db.profile.officerchat = false
				ObjAnnouncer:Print("|cFF40c040"..OFFICER.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.officerchat = true
				ObjAnn.db.profile.guildchat = false
				ObjAnnouncer:Print("|cFF40c040"..OFFICER.." "..CHAT.."|r |cFF00FF00"..L["enabled"].."|r".." (|cFF40ff40"..GUILD.." "..CHAT.."|r |cFFFF0000"..DISABLED.."|r)")
			end
		elseif v == "channel" then
			if ObjAnn.db.profile.channelchat then
				ObjAnn.db.profile.channelchat = false
				ObjAnnouncer:Print("|cFFffc0c0"..CHAT.." "..CHANNEL.."|r |cFFFF0000"..DISABLED.."|r")
			else
				ObjAnn.db.profile.channelchat = true
				ObjAnnouncer:Print("|cFFffc0c0"..CHAT.." "..CHANNEL.."|r |cFF00FF00"..L["enabled"].."|r")
			end
		else
			ObjAnnouncer:Print(L["slashpublicerror"])
		end
	end,
	["oor"] = function()
		if ObjAnn.db.profile.enableOOR then
			ObjAnn.db.profile.enableOOR = false
			ObjAnnouncer:Print(L["oor"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.enableOOR = true
			ObjAnnouncer:Print(L["oor"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,			
	["accept"] = function()
		if ObjAnn.db.profile.questAccept then
			ObjAnn.db.profile.questAccept = false
			ObjAnnouncer:Print(L["slashquestaccept"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.questAccept = true
			ObjAnnouncer:Print(L["slashquestaccept"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,		
	["turnin"] = function()
		if ObjAnn.db.profile.questTurnin then
			ObjAnn.db.profile.questTurnin = false			
			ObjAnnouncer:Print(L["slashquestturnin"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.questTurnin = true			
			ObjAnnouncer:Print(L["slashquestturnin"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,
	["xp"] = function()
		if ObjAnn.db.profile.questXP then
			ObjAnn.db.profile.questXP = false			
			ObjAnnouncer:Print(L["slashquestexp"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.questXP = true			
			ObjAnnouncer:Print(L["slashquestexp"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,	
	["reward"] = function()
		if ObjAnn.db.profile.questRewards then
			ObjAnn.db.profile.questRewards = false			
			ObjAnnouncer:Print(L["slashquestrewards"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.questRewards = true			
			ObjAnnouncer:Print(L["slashquestrewards"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,		
	["escort"] = function()
		if ObjAnn.db.profile.questEscort then
			ObjAnn.db.profile.questEscort = false
			ObjAnnouncer:Print(L["slashquestescort"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.questEscort = true
			ObjAnnouncer:Print(L["slashquestescort"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,			
	["fail"] = function()
		if ObjAnn.db.profile.questFail then
			ObjAnn.db.profile.questFail = false
			ObjAnnouncer:Print(L["slashquestfail"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.questFail = true
			ObjAnnouncer:Print(L["slashquestfail"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,		
	["soundcomp"] = function()
		if ObjAnn.db.profile.enableCompletionSound then
			ObjAnn.db.profile.enableCompletionSound = false
			ObjAnnouncer:Print(L["slashsoundcompletion"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.enableCompletionSound = true
			ObjAnnouncer:Print(L["slashsoundcompletion"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,
	["soundaf"] = function()
		if ObjAnn.db.profile.enableAcceptFailSound then
			ObjAnn.db.profile.enableAcceptFailSound = false
			ObjAnnouncer:Print(L["slashsoundacceptfail"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.enableAcceptFailSound = true
			ObjAnnouncer:Print(L["slashsoundacceptfail"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,		
	["soundcomm"] = function()
		if ObjAnn.db.profile.enableCommSound then
			ObjAnn.db.profile.enableCommSound = false
			ObjAnnouncer:Print(L["slashsoundcomm"].." |cFFFF0000"..DISABLED.."|r")
		else
			ObjAnn.db.profile.enableCommSound = true
			ObjAnnouncer:Print(L["slashsoundcomm"].." |cFF00FF00"..L["enabled"].."|r")
		end
	end,		
}	

function ObjAnn:oacommandHandler(input)
	local k,v = string.match(string.lower(input), "([%w%+%-%=]+) ?(.*)")
	if slashCommands[k] then	-- If valid...
		slashCommands[k](v)
	elseif k then	-- If user typed something invalid, show help.
	   ObjAnn:Print(helpText)		
	else
		if ACD.OpenFrames[NAME] then
			ACD:Close(NAME)
		else
			ACD:Open(NAME)
		end			
	--	InterfaceOptionsFrame_OpenToCategory(optionsGUI.general)
	end
end

	--[[ LibSharedMedia ]]--
LSM:Register("sound", "PVPFlagCapturedHorde","Sound\\Interface\\PVPFlagCapturedHordeMono.ogg")
LSM:Register("sound", "PVPFlagCaptured", "Sound\\Interface\\PVPFlagCapturedMono.ogg")
LSM:Register("sound", "!工作完成", "Sound\\Creature\\Peon\\PeonBuildingComplete1.ogg")
LSM:Register("sound", "GM ChatWarning", "Sound\\Interface\\GM_ChatWarning.ogg")
LSM:Register("sound", "Hearthstone-QuestAccepted", "Interface\\Addons\\ObjectiveAnnouncer\\Sounds\\Hearthstone-QuestingAdventurer_QuestAccepted.ogg")
LSM:Register("sound", "Hearthstone-QuestFailed", "Interface\\Addons\\ObjectiveAnnouncer\\Sounds\\Hearthstone-QuestingAdventurer_QuestFailed.ogg")

ObjAnn.myOptions = myOptions
ACR:RegisterOptionsTable(NAME, myOptions)
LibStub("AceConfig-3.0"):RegisterOptionsTable("Objective Announcer", myOptions)
optionsGUI.general = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Objective Announcer", L["Objective Announcer"])
optionsGUI.libsink = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Objective Announcer", L["Self Outputs"], L["Objective Announcer"], "libsink")
optionsGUI.profile = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Objective Announcer", L["Profiles"], L["Objective Announcer"], "profile")

ObjAnn:RegisterChatCommand("oa", "oacommandHandler")
ObjAnn:RegisterChatCommand("obja", "oacommandHandler")