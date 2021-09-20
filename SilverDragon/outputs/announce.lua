local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Announce", "AceTimer-3.0", "LibSink-2.0")
local Debug = core.Debug

local LSM = LibStub("LibSharedMedia-3.0")

-- 偵測方式翻譯為中文
local L = {}
L["fake"] = "假的"
L["mouseover"] = "滑鼠指向"
L["target"] = "目標"
L["vignette"] = "小地圖星號"
L["macro"] = "巨集"
L["nameplate"] = "血條"
L["GUILD"] = "公會"
L["PARTY"] = "隊伍"

if LSM then
	-- Register some media
	LSM:Register("sound", "Rubber Ducky", [[Sound\Doodad\Goblin_Lottery_Open01.ogg]])
	LSM:Register("sound", "Cartoon FX", [[Sound\Doodad\Goblin_Lottery_Open03.ogg]])
	LSM:Register("sound", "Explosion", [[Sound\Doodad\Hellfire_Raid_FX_Explosion05.ogg]])
	LSM:Register("sound", "Shing!", [[Sound\Doodad\PortcullisActive_Closed.ogg]])
	LSM:Register("sound", "Wham!", [[Sound\Doodad\PVP_Lordaeron_Door_Open.ogg]])
	LSM:Register("sound", "Simon Chime", [[Sound\Doodad\SimonGame_LargeBlueTree.ogg]])
	LSM:Register("sound", "War Drums", [[Sound\Event Sounds\Event_wardrum_ogre.ogg]])--NPC Scan default
	LSM:Register("sound", "Scourge Horn", [[Sound\Events\scourge_horn.ogg]])--NPC Scan default
	LSM:Register("sound", "Pygmy Drums", [[Sound\Doodad\GO_PygmyDrumsStage_Custom0_Loop.ogg]])
	LSM:Register("sound", "Cheer", [[Sound\Event Sounds\OgreEventCheerUnique.ogg]])
	LSM:Register("sound", "Humm", [[Sound\Spells\SimonGame_Visual_GameStart.ogg]])
	LSM:Register("sound", "Short Circuit", [[Sound\Spells\SimonGame_Visual_BadPress.ogg]])
	LSM:Register("sound", "Fel Portal", [[Sound\Spells\Sunwell_Fel_PortalStand.ogg]])
	LSM:Register("sound", "Fel Nova", [[Sound\Spells\SeepingGaseous_Fel_Nova.ogg]])
	LSM:Register("sound", "PVP Flag", [[Sound\Spells\PVPFlagTaken.ogg]])
	LSM:Register("sound", "Algalon: Beware!", [[Sound\Creature\AlgalonTheObserver\UR_Algalon_BHole01.ogg]])
	LSM:Register("sound", "Yogg Saron: Laugh", [[Sound\Creature\YoggSaron\UR_YoggSaron_Slay01.ogg]])
	LSM:Register("sound", "Illidan: Not Prepared", [[Sound\Creature\Illidan\BLACK_Illidan_04.ogg]])
	LSM:Register("sound", "Magtheridon: I am Unleashed", [[Sound\Creature\Magtheridon\HELL_Mag_Free01.ogg]])
	LSM:Register("sound", "Loatheb: I see you", [[Sound\Creature\Loathstare\Loa_Naxx_Aggro02.ogg]])
	LSM:Register("sound", "NPCScan", [[Sound\Event Sounds\Event_wardrum_ogre.ogg]])--Sound file is actually bogus, this just forces the option NPCScan into menu. We hack it later.
end

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Announce", {
		profile = {
			sink = true,
			drums = true,
			sound = true,
			soundgroup = true,
			soundguild = false,
			sound_mount = true,
			sound_boss = true,
			soundfile = "Loatheb: I see you",
			soundfile_mount = "Illidan: Not Prepared",
			soundfile_boss = "Magtheridon: I am Unleashed",
			sound_loop = 1,
			sound_mount_loop = 3,
			sound_boss_loop = 1,
			flash = true,
			instances = false,
			dead = true,
			already = false,
			sink_opts = {},
		},
	})

	self:SetSinkStorage(self.db.profile.sink_opts)

	core.RegisterCallback(self, "Seen")

	local config = core:GetModule("Config", true)
	if config then
		local toggle = config.toggle
		local get = function(info) return self.db.profile[info[#info]] end
		local set = function(info, v) self.db.profile[info[#info]] = v end

		local sink_config = self:GetSinkAce3OptionsDataTable()
		sink_config.inline = true
		sink_config.order = 15

		local faker = function(id, name, zone, x, y)
			return {
				type = "execute", name = name,
				desc = "假裝看到 " .. name,
				func = function()
					-- id, zone, x, y, is_dead, source, unit
					core.events:Fire("Seen", id, zone, x, y, false, "fake", false)
				end,
			}
		end

		local options = {
			general = {
				type = "group", name = "一般", inline = true,
				order = 10,
				get = get, set = set,
				args = {
					already = toggle("已經找到過", "發現已經擊殺過 / 成就已達成的稀有怪 (如果能夠知道的話) 要顯示通知"),
					dead = toggle("已經死亡", "發現已經死亡的稀有怪 (如果能夠知道的話) 要通知。並非所有的掃描方法都能夠知道稀有怪是否已經死亡，所以並不完全可靠。"),
					flash = toggle("閃爍", "閃爍螢幕四周邊緣"),
					instances = toggle("副本", "在副本中要顯示通知"),
				},
			},
			message = {
				type = "group", name = "訊息",
				order = 20,
				get = get, set = set,
				args = {
					sink = toggle("啟用", "傳送訊息到你正在使用的任何一種捲動文字插件。", 10),
					output = sink_config,
				},
			},
			test = {
				type = "group", name = "測試!",
				inline =  true,
				args = {
					-- id, name, zone, x, y, is_dead, is_new_location, source, unit
					time = faker(32491, "時光流逝元龍 (坐騎!)", 495, 0.490, 0.362),
					anger = faker(60491, "憤怒之煞 (首領!)", 809, 0.5, 0.5),
					vyragosa = faker(32630, "維拉苟莎 (無趣)", 495, 0.5, 0.5),
					deathmaw = faker(10077, "死亡之喉 (寵物!)", 29, 0.5, 0.5),
					haakun = faker(83008, "『盡噬者』赫昆", 946, 0.5, 0.5),
				},
			},
		}
		if LSM then
			local soundfile = function(enabled_key, order)
				return {
					type = "select", dialogControl = "LSM30_Sound",
					name = "播放音效", desc = "選擇要播放的音效",
					values = AceGUIWidgetLSMlists.sound,
					disabled = function() return not self.db.profile[enabled_key] end,
					order = order,
				}
			end
			local soundrange = function(order)
				return {
					type = "range",
					name = "重複...",
					desc = "音效重複播放的次數",
					min = 1, max = 10, step = 1,
					order = order,
				}
			end
			options.sound = {
				type = "group", name = "音效",
				get = get, set = set,
				order = 10,
				args = {
					about = config.desc("發現稀有怪時要播放音效通知? 特別的稀有怪還可以有特別音效。*絕對* 不會讓你錯過... 像是... 時光流逝元龍，絕對不會...", 0),
					sound = toggle("啟動", "就是要播放聲音!", 10),
					drums = toggle("鼓聲", "搭配鼓聲更有氣氛", 12),
					soundgroup = toggle("隊伍同步音效", "從隊伍/團隊成員同步稀有怪時播放音效", 13),
					soundguild = toggle("公會同步音效", "從不在隊伍中的公會成員同步稀有怪時播放音效", 14),
					soundfile = soundfile("sound", 15),
					sound_loop = soundrange(17),
					mount = {type="header", name="", order=20,},
					sound_mount = toggle("坐騎音效", "掉落坐騎的稀有怪播放特別的音效", 21),
					soundfile_mount = soundfile("sound_mount", 25),
					sound_mount_loop = soundrange(27),
					boss = {type="header", name="", order=30,},
					sound_boss = toggle("首領音效", "需要組隊擊殺的稀有怪播放特別的音效", 31),
					soundfile_boss = soundfile("sound_boss", 35),
					sound_boss_loop = soundrange(37),
				},
			}
		end
		config.options.args.outputs.plugins.announce = options
	end
end

function module:Seen(callback, id, zone, x, y, is_dead, ...)
	Debug("Announce:Seen", id, zone, x, y, is_dead, ...)

	if not self.db.profile.instances and IsInInstance() then
		return
	end

	if not self:ShouldAnnounce(id, zone, x, y, is_dead, ...) then
		return
	end

	core.events:Fire("Announce", id, zone, x, y, is_dead, ...)
end

function module:ShouldAnnounce(id, zone, x, y, is_dead)
	if is_dead and not self.db.profile.dead then
		return
	end

	if not self.db.profile.already then
		-- hide already-completed mobs
		local quest, achievement = ns:CompletionStatus(id)
		if quest ~= nil or achievement ~= nil then
			-- knowable
			if achievement ~= nil then
				-- achievement knowable
				if quest ~= nil then
					-- quest also knowable
					return not quest
				end
				-- can just fall back on achievement
				return not achievement
			else
				-- just quest knowable
				return not quest
			end
		end
	end

	return true
end

core.RegisterCallback("SD Announce Sink", "Announce", function(callback, id, zone, x, y, dead, source)
	if not module.db.profile.sink then
		return
	end

	Debug("Pouring")
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel and player then
			local localized_zone = GetMapNameByID(zone) or UNKNOWN
			source = "由" .. L[channel] .. "的 " .. player .. " 發現" .. "；在" .. localized_zone
		end
	end
	if x and y then
		local sourceText
		if L[source] then
		sourceText = L[source]
		else 
			sourceText = source
		end
		source = sourceText .. " @ " .. core.round(x * 100, 1) .. ", " .. core.round(y * 100, 1)
	end
	local prefix = "發現稀有怪："
	module:Pour((prefix .. "%s%s (%s)"):format(core:GetMobLabel(id) or UNKNOWN, dead and "... 但是已經死了" or '', source or ''))
end)

function module:PlaySound(s)
	-- Arg is a table, to make scheduling the loops easier. I am lazy.
	Debug("Playing sound", s.soundfile, s.loops)
	-- boring check:
	if not s.loops or s.loops == 0 then return end
	-- now, noise!
	local drums = self.db.profile.drums
	if s.soundfile == "NPCScan" then
		--Override default behavior and force npcscan behavior of two sounds at once
		drums = true
		PlaySoundFile(LSM:Fetch("sound", "Scourge Horn"), "Master")
	else
		--Play whatever sound is set
		PlaySoundFile(LSM:Fetch("sound", s.soundfile), "Master")
	end
	if drums then
		PlaySoundFile(LSM:Fetch("sound", "War Drums"), "Master")
	end
	s.loops = s.loops - 1
	if s.loops > 0 then
		self:ScheduleTimer("PlaySound", 4.5, s)
	end
end
core.RegisterCallback("SD Announce Sound", "Announce", function(callback, id, zone, x, y, dead, source)
	if not (module.db.profile.sound and LSM) then
		return
	end
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" and not module.db.profile.soundguild or (channel == "PARTY" or channel == "RAID") and not module.db.profile.soundgroup then return end
	end
	local soundfile, loops
	if module.db.profile.sound_mount and ns.mobdb[id] and ns.mobdb[id].mount then
		soundfile = module.db.profile.soundfile_mount
		loops = module.db.profile.sound_mount_loop
	elseif module.db.profile.sound_boss and ns.mobdb[id] and ns.mobdb[id].boss then
		soundfile = module.db.profile.soundfile_boss
		loops = module.db.profile.sound_boss_loop
	else
		soundfile = module.db.profile.soundfile
		loops = module.db.profile.sound_loop
	end
	module:PlaySound{soundfile = soundfile, loops = loops}
end)

do
	local flashframe
	core.RegisterCallback("SD Announce Flash", "Announce", function(callback)
		if not module.db.profile.flash then
			return
		end
		if not flashframe then
			flashframe = CreateFrame("Frame", nil, WorldFrame)
			flashframe:SetClampedToScreen(true)
			flashframe:SetFrameStrata("FULLSCREEN_DIALOG")
			flashframe:SetToplevel(true)
			flashframe:SetAllPoints(UIParent)
			flashframe:Hide()

			-- Use the OutOfControl (blue) and LowHealth (red) textures to get a purple flash
			local texture = flashframe:CreateTexture(nil, "BACKGROUND")
			texture:SetTexture([[Interface\FullScreenTextures\OutOfControl]])
			texture:SetBlendMode("ADD")
			texture:SetAllPoints()

			texture = flashframe:CreateTexture(nil, "BACKGROUND")
			texture:SetTexture([[Interface\FullScreenTextures\LowHealth]])
			texture:SetBlendMode("ADD")
			texture:SetAllPoints()

			local group = flashframe:CreateAnimationGroup()
			group:SetLooping("BOUNCE")
			local pulse = group:CreateAnimation("Alpha")
			pulse:SetFromAlpha(0.3)
			pulse:SetToAlpha(0.75)
			pulse:SetDuration(0.5236)

			local loops = 0
			group:SetScript("OnLoop", function(frame, state)
				loops = loops + 1
				if loops == 9 then
					group:Finish()
				end
			end)
			group:SetScript("OnFinished", function(self)
				loops = 0
				flashframe:Hide()
			end)

			flashframe:SetScript("OnShow", function(self)
				group:Play()
			end)

			sdf = flashframe
		end

		Debug("Flashing")
		flashframe:Show()
	end)
end
