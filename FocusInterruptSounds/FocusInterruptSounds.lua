----------------------------
--      Constants         --
----------------------------

local _

local CASTING_SOUND_FILE = "Interface\\AddOns\\FocusInterruptSounds\\kickcast.ogg"
local CC_SOUND_FILE = "Interface\\AddOns\\FocusInterruptSounds\\cc.ogg"
local INTERRUPTED_SOUND_FILE = "Interface\\AddOns\\FocusInterruptSounds\\interrupted.ogg"
local POLYMORPH_SOUND_FILE = "Interface\\AddOns\\FocusInterruptSounds\\sheep.ogg"
local INNERVATE_SOUND_FILE = "Interface\\AddOns\\FocusInterruptSounds\\innervate.ogg"

local SCHOOL_PHYSICAL	= 0x01;
local SCHOOL_HOLY	= 0x02;
local SCHOOL_FIRE	= 0x04;
local SCHOOL_NATURE	= 0x08;
local SCHOOL_FROST	= 0x10;
local SCHOOL_SHADOW	= 0x20;
local SCHOOL_ARCANE	= 0x40;
local SCHOOL_ALL	= 0x7F;

local DEFAULT_GLOBAL_OVERRIDES = 
[[
]];

local DEFAULT_BLACKLIST = 
[[
星裔觀察者->星辰轟擊
]];

local DEFAULT_PLAYER_INTERRUPT_SPELLS =
[[
太陽光束
颱風
碎顱猛擊
猛力重擊
癱瘓咆哮
心智冰封
死亡之握
窒息術
天矛鎖喉手
點穴
法術反制
沉默
暗影之怒
吞噬魔法
混沌新星
沉默符印
偷襲
腳踢
制裁之錘
責難
盲目之光
拳擊
刺耳怒吼
暴風怒擲
駁火反擊
封口
削風術
]];

local DEFAULT_PET_INTERRUPT_SPELLS =
[[
虛空衝擊
法術封鎖

]];

local DEFAULT_AURA_BLACKLIST = 
[[氣定神閒 -> *
神聖之盾 -> *
]];

local DEFAULT_INCOMING_CC = 
[[恐懼
變形術
致盲
]];

local DEFAULT_INCOMING_CC_LASHBACK = 
[[變形術
致盲
]];

local DEFAULT_PARTNER_CC_MAGIC = 
[[變形術
懺悔
致盲
]];

local DEFAULT_PARTNER_CC_POISON = 
[[蠍獅釘刺
]];


local DEFAULT_ARENA_PURGE = 
[[
]];

local DEFAULT_PVE_PURGE = 
[[符文護盾
符文屏障
]];

------------------------------
--      Initialization      --
------------------------------

FocusInterruptSounds = LibStub("AceAddon-3.0"):NewAddon("FocusInterruptSounds", "AceEvent-3.0", "AceConsole-3.0")

local options = {
	type = "group",
	name = "斷法提醒和通報",
	get = function(info) return FocusInterruptSounds.db.profile[ info[#info] ] end,
	set = function(info, value) FocusInterruptSounds.db.profile[ info[#info] ] = value end,
	args = {
		General = {
			order = 1,
			type = "group",
			name = "一般設定",
			desc = "一般設定",
			args = {
				intro = {
					order = 1,
					type = "description",
					name = "你的敵對目標開始施放可以中斷的法術時，會有語音提醒快打斷。"
							.. "PvP 和 PvE 也有其他特殊事件的音效。發現 BUG 了嗎? 請在遊戲中"
							.. "寫信給 Corg, 部落, Detheroc, US PvP (因為有可能我沒注意到 "
							.. "Ace 討論區)。",
				},

				fEnableText = {
					type = "toggle",
					name = "啟用文字",
					desc = "啟用/停用斷法提醒的聊天視窗文字。",
					order = 2,
				},
				fEnableSound = {
					type = "toggle",
					name = "啟用音效",
					desc = "啟用/停用斷法提醒的音效。",
					order = 2,
				},
				fIgnoreMute = {
					type = "toggle",
					name = "忽略靜音",
					desc = "忽略/使用遊戲的靜音設定 (Ctrl+N)。啟用音效時才能使用這個選項。",
					order = 3,
				},
				fTargetFallback = {
					type = "toggle",
					name = "當前目標",
					desc = "沒有設定專注目標時，對當前目標也使用斷法提醒。",
					order = 4,
				},
				fPositiveReinforcement = {
					type = "toggle",
					name = "斷法成功通知",
					desc = "斷法成功時播放音效並顯示文字。",
					order = 5,
				},
				fCheckSpellAvailability = {
					type = "toggle",
					name = "檢查法術是否可用",
					desc = "提醒前會檢查是否有可用的斷法和反控場技能。",
					order = 6,
				},
				fDisableInVehicle = {
					type = "toggle",
					name = "忽略載具/坐騎",
					desc = "在載具/坐騎上時關閉音效。",
					order = 7,
				},
				fAnnounceInterrupts = {
					type = "toggle",
					name = "斷法通報到頻道",
					desc = "斷法成功會通報到隊伍/團隊頻道。",
					order = 8,
				},
				iMinimumCastTime = {
					type = "range",
					name = "最小施法時間 (毫秒)",
					desc = "施法時間小於這個數值的法術不會提醒，以毫秒為單位。",
					order = 9,
					softMin = 0,
					softMax = 3000,
					min = 0,
					max = 20000,
					bigStep = 100,
				},


				strGlobalOverrides = {
					type = "input",
					name = "整體優先設定",
					desc = "列出一定要發出提醒的施法者和法術 (就算不是"
							.. "你的目標或專注目標)，分隔使用 \"->\"。使用星號 \"*\" 代表任何施法者"
							.. "或任何法術 (但不能同時代表兩者!)。",
					order = 10,
					multiline = true,
					width = "double",
				},

				strBlacklist = {
					type = "input",
					name = "施法者 -> 法術 忽略清單",
					desc = "列出要忽略的施法者和法術配對，分隔使用 \"->\"。"
							.. "使用星號 \"*\"代表任何施法者或任何法術 (但不能同時代表兩者!)。",
					order = 11,
					multiline = true,
					width = "double",
				},
				fIgnorePhysical = {
					type = "toggle",
					name = "忽略物理傷害法術",
					desc = "忽略標示為 \"物理傷害\"。",
					order = 12,
				},
				fEnableBlizzardBlacklist = {
					type = "toggle",
					name = "使用暴雪API忽略清單",
					desc = "忽略 UnitCastingInfo() 標示為不可打斷的法術。",
					order = 13,
				},
				strAuraBlacklist = {
					type = "input",
					name = "光環 -> 法術 忽略清單",
					desc = "列出指定光還要忽略的法術。分隔使用 \"->\"。"
							.. "使用星號 \"*\" 代表任何法術。",
					order = 14,
					multiline = true,
					width = "double",
				},

				strPlayerInterruptSpells = {
					type = "input",
					name = "玩家斷法技能 (加入你的技能，將其他刪除)",
					desc = "列出玩家可以使用的斷法招數。"
							.. "只有在啟用 \"檢查法術是否可用\" 選項時才會用到這個清單。",
					order = 15,
					multiline = true,
					width = "double",
				},

				strPetInterruptSpells = {
					type = "input",
					name = "寵物斷法技能",
					desc = "列出玩家的寵物可以使用的斷法招數。"
							.. "只有在啟用 \"檢查法術是否可用\" 選項時才會用到這個清單。",
					order = 16,
					multiline = true,
					width = "double",
				},

				strIncomingCC = {
					type = "input",
					name = "PvP 即將來臨的控場法術",
					desc = "列出在競技場或附近，即將到來的控場技能。",
					order = 17,
					multiline = true,
					width = "double",
				},

				strPartnerCC = {
					type = "input",
					name = "競技場隊友的控場減益效果",
					desc = "列出套用到競技場隊友身上、需要提醒的減益效果。",
					order = 18,
					multiline = true,
					width = "double",
				},

				strArenaPurge = {
					type = "input",
					name = "競技場要驅散的增益效果",
					desc = "列出競技場對手所獲得、需要提醒的增益效果。",
					order = 19,
					multiline = true,
					width = "double",
				},

				strPvePurge = {
					type = "input",
					name = "PvE 要驅散的增益效果",
					desc = "列出 NPC 身上需要驅散的增益效果。",
					order = 20,
					multiline = true,
					width = "double",
				},
			},
		},
	},
};


function FocusInterruptSounds:OnInitialize()

	local strGlobalOverrides = DEFAULT_GLOBAL_OVERRIDES;
	local strAuraBlacklist = DEFAULT_AURA_BLACKLIST;
	local strPlayerInterruptSpells = DEFAULT_PLAYER_INTERRUPT_SPELLS;
	local strPetInterruptSpells = DEFAULT_PET_INTERRUPT_SPELLS;
	local strIncomingCC = "";
	local strPartnerCC = "";
	local strPvePurge = "";

	_, self.strClassName = UnitClass("player");

	self.fAntiCCIsLashback = false;
	self.fHasPurge = false;
	self.fCanDispel = false;
	self.fCanDepoison = false;

	if ("WARLOCK" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_SHADOW;
		self.str30YardSpellName = "射擊";
		self.fHasPurge = true;
		self.fCanDispel = true;
	elseif ("MAGE" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_ARCANE;
		self.str30YardSpellName = "射擊";
		self.fHasPurge = true;
	elseif ("SHAMAN" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_NATURE;
		self.strAntiCCSpellName = "巫毒圖騰";
		self.str30YardSpellName = "閃電箭";
		self.fHasPurge = true;
		self.fCanDepoison = true;
	elseif ("WARRIOR" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_PHYSICAL;
		self.str30YardSpellName = "射擊";
	elseif ("ROGUE" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_PHYSICAL;
		self.strAntiCCSpellName = "暗影披風";
		self.str30YardSpellName = "射擊";
	elseif ("PRIEST" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_SHADOW;
		self.strAntiCCSpellName = "暗言術：死";
		self.fAntiCCIsLashback = true;
		self.str30YardSpellName = "暗言術：痛";
		self.fHasPurge = true;
		self.fCanDispel = true;
	elseif ("HUNTER" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_PHYSICAL;
		self.strAntiCCSpellName = "假死";
		self.str30YardSpellName = "震盪射擊";
		self.fHasPurge = true;
	elseif ("DRUID" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_PHYSICAL;
		self.str30YardSpellName = "治療之觸";
		self.fCanDepoison = true;
	elseif ("DEATHKNIGHT" == self.strClassName) then
		self.iInterruptSchool = SCHOOL_FROST;
		self.strAntiCCSpellName = "反魔法護罩";
		self.str30YardSpellName = "死亡之握";
	elseif ("PALADIN" == self.strClassName) then
		self.fCanDispel = true;
		self.fCanDepoison = true;
	elseif ("MONK" == self.strClassName) then
		self.fCanDispel = true;
		self.fCanDepoison = true;
	end

	-- Add additional auras for classes with physical interrupts
	if (self.iInterruptSchool == SCHOOL_PHYSICAL) then
		strAuraBlacklist = strAuraBlacklist .. "保護祝福 -> *\n";
	end

	-- Set up incoming CC warning defaults
	if (nil ~= self.strAntiCCSpellName) then
		if (self.fAntiCCIsLashback) then
			strIncomingCC = DEFAULT_INCOMING_CC_LASHBACK;
		else
			strIncomingCC = DEFAULT_INCOMING_CC;
		end
	end

	-- Set up partner CC defaults
	if (self.fCanDispel) then
		strPartnerCC = strPartnerCC .. DEFAULT_PARTNER_CC_MAGIC;
	end

	if (self.fCanDepoison) then
		strPartnerCC = strPartnerCC .. DEFAULT_PARTNER_CC_POISON;
	end

	-- Set up purge defaults
	if (self.fHasPurge) then
		strPvePurge = DEFAULT_PVE_PURGE;
	end

	-- Build the default settings array
	local DEFAULTS = {
		profile = {
			fEnableText = true,
			fEnableSound = true,
			fIgnoreMute = true,
			fTargetFallback = true,
			fPositiveReinforcement = true,
			fCheckSpellAvailability = true,
			fDisableInVehicle = true,
			fAnnounceInterrupts = true,

			iMinimumCastTime = 800,
			strGlobalOverrides = strGlobalOverrides,
			strBlacklist = DEFAULT_BLACKLIST,
			fIgnorePhysical = false,
			fEnableBlizzardBlacklist = true,
			strAuraBlacklist = strAuraBlacklist,
			strPlayerInterruptSpells = strPlayerInterruptSpells,
			strPetInterruptSpells = strPetInterruptSpells,
			strIncomingCC = strIncomingCC,
			strPartnerCC = strPartnerCC,
			strArenaPurge = DEFAULT_ARENA_PURGE,
			strPvePurge = strPvePurge,
		}
	};
	self.db = LibStub("AceDB-3.0"):New("FocusInterruptSoundsDB", DEFAULTS, self.strClassName)

	options.args.Profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	LibStub("AceConfig-3.0"):RegisterOptionsTable("FocusInterruptSounds", options)
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("FocusInterruptSounds", 640, 480)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FocusInterruptSounds", "斷法", nil, "General")
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("FocusInterruptSounds", "設定檔", "斷法", "Profile")
	self:RegisterChatCommand("fis", function() LibStub("AceConfigDialog-3.0"):Open("FocusInterruptSounds") end)

end


function FocusInterruptSounds:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	-- self:CheckAndPrintMessage("插件已啟用，職業為" .. self.strClassName);
end

function FocusInterruptSounds:OnDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

------------------------------
--        Functions         --
------------------------------

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:CheckAndPrintMessage
--
--		Prints a message, only if the options permit it.
--
function FocusInterruptSounds:CheckAndPrintMessage(strMsg)

	if (self.db.profile.fEnableText) then
		DEFAULT_CHAT_FRAME:AddMessage("|cff7fff7f斷法|r: " .. strMsg);
	end

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:CheckAndPlaySound
--
--		Plays a sound, only if the options permit it.
--
function FocusInterruptSounds:CheckAndPlaySound(strFile)

	if (self.db.profile.fEnableSound) then
		local strChannel = "SFX";
		if (self.db.profile.fIgnoreMute) then
			strChannel = "MASTER"; 
		end
		PlaySoundFile(strFile, strChannel);
	end

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsSourceFocusOrTarget
--
--		Returns true if the source flags are for the target we're making sounds for.
--
function FocusInterruptSounds:FIsSourceFocusOrTarget(iSourceFlags)

	-- Filter out non-hostile sources
	if (0 == bit.band(iSourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)) then
		return false;
	end

	-- We want to react to focus actions
	if (0 ~= bit.band(iSourceFlags, COMBATLOG_OBJECT_FOCUS)) then
		return true;
	end

	-- If there is no hostile focus, allow fallback on the current target
	if (0 ~= bit.band(iSourceFlags, COMBATLOG_OBJECT_TARGET)
			and self.db.profile.fTargetFallback
			and not UnitCanAttack("player", "focus")
	) then
		return true;
	end

	return false;
end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:StrEscapeForRegExp
--
--		Returns the string escaped for use with LUA regular expressions.
--
function FocusInterruptSounds:StrEscapeForRegExp(str)

	-- Special characters: ^$()%.[]*+-?
	str = string.gsub(str, "%^", "%%%^");
	str = string.gsub(str, "%$", "%%%$");
	str = string.gsub(str, "%(", "%%%(");
	str = string.gsub(str, "%)", "%%%)");
	str = string.gsub(str, "%%", "%%%%");
	str = string.gsub(str, "%.", "%%%.");
	str = string.gsub(str, "%[", "%%%[");
	str = string.gsub(str, "%]", "%%%]");
	str = string.gsub(str, "%*", "%%%*");
	str = string.gsub(str, "%+", "%%%+");
	str = string.gsub(str, "%-", "%%%-");
	str = string.gsub(str, "%?", "%%%?");

	return str;

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FInList
--
--		Returns true if the given element is in the given newline-delimited list.
--
function FocusInterruptSounds:FInList(strElement, strList)

	--self:CheckAndPrintMessage("Looking for " .. strElement);

	return string.find("\n" .. strList .. "\n", "\n%s*" .. self:StrEscapeForRegExp(strElement) .. "%s*\n");

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FInMap
--
--		Returns true if the given key and value are in the given newline-delimited list.
--
function FocusInterruptSounds:FInMap(strKey, strValue, strMap)

	local strKeyEscaped;
	local strValueEscaped;

	if (nil == strKey) then
		strKeyEscaped = ".*";
	else
		strKeyEscaped = self:StrEscapeForRegExp(strKey);
	end

	if (nil == strValue) then
		strValueEscaped = ".*";
	else
		strValueEscaped = self:StrEscapeForRegExp(strValue);
	end

	return string.find("\n" .. strMap .. "\n", "\n%s*" .. strKeyEscaped
				.. "%s*%->%s*" .. strValueEscaped .. "%s*\n");

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsCasterOrSpellGlobalOverride
--
--		Returns true if the given spell (or cast+spell combo) is in the global override list.
--
function FocusInterruptSounds:FIsCasterOrSpellGlobalOverride(strMobName, iMobFlags, strSpellId, strSpellName, iSpellSchool)

	-- Is the spell in the global override?
	if (self:FInMap("*", strSpellName, self.db.profile.strGlobalOverrides)) then
		return true;
	end

	-- Only allow caster overrides for NPCs
	if (0 ~= bit.band(iMobFlags, COMBATLOG_OBJECT_CONTROL_NPC)) then
		-- Is the caster blacklisted?
		if (self:FInMap(strMobName, "*", self.db.profile.strGlobalOverrides)) then
			return true;
		end

		-- Is the caster+spell combo blacklisted?
		if (self:FInMap(strMobName, strSpellName, self.db.profile.strGlobalOverrides)) then
			return true;
		end
	end

	return false;

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsCasterOrSpellBlacklisted
--
--		Returns true if the given spell (or cast+spell combo) is blacklisted.
--
function FocusInterruptSounds:FIsCasterOrSpellBlacklisted(strMobName, iMobFlags, strSpellId, strSpellName, iSpellSchool)

	--- Blacklist based on UnitCastingInfo() API
	if (self.db.profile.fEnableBlizzardBlacklist or self.db.profile.iMinimumCastTime > 0) then
		local strMobId = "target";

		if (0 ~= bit.band(iMobFlags, COMBATLOG_OBJECT_FOCUS)) then
			strMobId = "focus";
		end

		local strSpellNameVerify, _, _, _, _, iEndTime, _, _, fInterruptImmune = UnitCastingInfo(strMobId);

		-- Is this a channel rather than a cast?
		if (nil == strSpellNameVerify) then
			strSpellNameVerify, _, _, _, _, iEndTime, _, fInterruptImmune = UnitChannelInfo(strMobId);
		end

		if (nil == strSpellNameVerify) then
			-- If the caster is no longer casting, it was probably a really fast cast (e.g. Nature's Swiftness)
			return true;
		elseif (strSpellNameVerify ~= strSpellName) then
			self:CheckAndPrintMessage("錯誤: UnitCastingInfo 檢查失敗: strSpellNameVerify="
				.. strSpellNameVerify .. " strSpellName=" .. strSpellName);
		else
			if (self.db.profile.fEnableBlizzardBlacklist and fInterruptImmune) then
				return true;
			end

			if (iEndTime - GetTime() * 1000 < self.db.profile.iMinimumCastTime) then
				return true;
			end
			
		end
	end

	-- Blacklist physical spells
	if (self.db.profile.fIgnorePhysical and 0 ~= bit.band(iSpellSchool, SCHOOL_PHYSICAL)) then
		return true;
	end

	-- Is the spell blacklisted?
	if (self:FInMap("*", strSpellName, self.db.profile.strBlacklist)) then
		return true;
	end

	-- Only allow caster blacklists for NPCs
	if (0 ~= bit.band(iMobFlags, COMBATLOG_OBJECT_CONTROL_NPC)) then
		-- Is the caster blacklisted?
		if (self:FInMap(strMobName, "*", self.db.profile.strBlacklist)) then
			return true;
		end

		-- Is the caster+spell combo blacklisted?
		if (self:FInMap(strMobName, strSpellName, self.db.profile.strBlacklist)) then
			return true;
		end
	end

	return false;

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsAuraBlacklisted
--
--		Returns true if the given spell (or cast+spell combo) is blacklisted.
--
function FocusInterruptSounds:FIsAuraBlacklisted(strAura, strSpellId, strSpellName, iSpellSchool)

	-- self:CheckAndPrintMessage("id = " .. strSpellId .. "; spell name = " .. strSpellName);

	-- Is the aura blacklisted?
	if (self:FInMap(strAura, "*", self.db.profile.strAuraBlacklist)) then
		return true;
	end

	-- Is the aura+spell combo blacklisted?
	if (self:FInMap(strAura, strSpellName, self.db.profile.strAuraBlacklist)) then
		return true;
	end

	return false;

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsSpellCastStart
--
--		Returns true if the given event is the start of a spell cast.  Note that for channeled
--		spells, this is actually going to be SPELL_CAST_SUCCESS.
--
function FocusInterruptSounds:FIsSpellCastStart(strEventType, iMobFlags, strSpellId, strSpellName, iSpellSchool)

	if ("SPELL_CAST_START" == strEventType) then
		return true;
	elseif ("SPELL_CAST_SUCCESS" == strEventType) then
		local strMobId = "target";

		if (0 ~= bit.band(iMobFlags, COMBATLOG_OBJECT_FOCUS)) then
			strMobId = "focus";
		end

		local strSpellNameVerify, _, _, _, _, _, _, _ = UnitChannelInfo(strMobId);
		return strSpellNameVerify == strSpellName;
	end

	return false;

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsCCSpell
--
--		Returns true if the given event is the start of a CC.
--
function FocusInterruptSounds:FIsCCSpell(strSpellId, strSpellName, iSpellSchool)

	return self:FInList(strSpellName, self.db.profile.strIncomingCC);

end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FHasBlacklistedAura
--
--		Returns true if the focus/target has an aura that will make the caster immune to
--		interrupts or will make the cast instant.
--
function FocusInterruptSounds:FHasBlacklistedAura(iSourceFlags, strSpellId, strSpellName, iSpellSchool)

	-- Go through recently cast buffs
	if (nil ~= self.lastInstacastSelfBuffName
		and GetTime() - self.lastInstacastSelfBuffTime < 1
		and self:FIsAuraBlacklisted(self.lastInstacastSelfBuffName, strSpellId, strSpellName, iSpellSchool)
	) then
		return true;
	end

	-- Go through the current buffs
	for i = 1, 40 do
		local strBuffName;

		if (0 ~= bit.band(iSourceFlags, COMBATLOG_OBJECT_FOCUS)) then
			strBuffName, _, _, _, _, _ = UnitBuff("focus", i);
		elseif (0 ~= bit.band(iSourceFlags, COMBATLOG_OBJECT_TARGET)) then
			strBuffName, _, _, _, _, _ = UnitBuff("target", i);
		end

		if (nil ~= strBuffName and self:FIsAuraBlacklisted(strBuffName, strSpellId, strSpellName, iSpellSchool)) then
			return true;
		end
	end

	return false;
end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsPetSpellAvailable
--
--		Returns true if the pet can cast the given spell.
--
function FocusInterruptSounds:FIsPetSpellAvailable(strSpellName)

	-- Make sure the user wants these extra checks
	if (not self.db.profile.fCheckSpellAvailability) then
		return true;
	end

	-- Make sure that there is a spell
	if (nil == strSpellName) then
		return false;
	end

	-- Verify that the pet can act (i.e. isn't feared)
	if (not GetPetActionsUsable()) then
		return false;
	end

	-- Verify that the spell isn't on cooldown (also checks existence)
	local iStartTime, _, fSpellEnabled = GetSpellCooldown(strSpellName, BOOKTYPE_PET);
	if (iStartTime ~= 0 or not fSpellEnabled) then
		return false;
	end

	-- Verify mana/energy
	local _, _, _, iCost, _, _, _, _, _ = GetSpellInfo(strSpellName);
	local iPetMana = UnitMana("playerpet");
	if (nil == iCost or nill == iPetMana or iPetMana < iCost) then
		return false;
	end

	return true;
end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsPlayerSpellAvailable
--
--		Returns true if you can cast the given spell.
--
function FocusInterruptSounds:FIsPlayerSpellAvailable(strSpellName)

	local strSpellDisplayNameVerify = nil;

	-- Is there a | special character?
	local iBarIndex = strSpellName:find("|");
	if (nil ~= iBarIndex) then
		strSpellDisplayNameVerify = strSpellName:sub(iBarIndex + 1);
		strSpellName = strSpellName:sub(0, iBarIndex - 1);
	end

	-- Make sure the user wants these extra checks
	if (not self.db.profile.fCheckSpellAvailability) then
		return true;
	end

	-- Make sure that there is a spell
	if (nil == strSpellName) then
		return false;
	end

	-- Verify that the spell isn't on cooldown
	local iStartTime, _, fSpellEnabled = GetSpellCooldown(strSpellName);
	if (iStartTime ~= 0 or not fSpellEnabled) then
		return false;
	end

	-- Verify display name (if applicable) and mana/energy
	local strSpellDisplayName, _, _, iCost, _, _, _, _, _ = GetSpellInfo(strSpellName);
	if (nil ~= strSpellDisplayNameVerify and strSpellDisplayNameVerify ~= strSpellDisplayName) then
		return false
	elseif (UnitMana("player") < iCost) then
		return false;
	end

	return true;
end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:FIsInterruptAvailable
--
--		Returns true if you can cast any interrupt.
--
function FocusInterruptSounds:FIsInterruptAvailable()

	-- Make sure the user wants these extra checks
	if (not self.db.profile.fCheckSpellAvailability) then
		return true;
	end

	for strSpell in string.gmatch(self.db.profile.strPlayerInterruptSpells, "[^%s][^\r\n]+[^%s]") do
		if (self:FIsPlayerSpellAvailable(strSpell)) then
			return true;
		end
	end

	if (GetPetActionsUsable()) then
		for strSpell in string.gmatch(self.db.profile.strPetInterruptSpells, "[^%s][^\r\n]+[^%s]") do
			if (self:FIsPetSpellAvailable(strSpell)) then
				return true;
			end
		end
	end

	return false;
end

---------------------------------------------------------------------------------------------------
--	FocusInterruptSounds:COMBAT_LOG_EVENT_UNFILTERED
--
--		Handler for combat log events.
--
function FocusInterruptSounds:COMBAT_LOG_EVENT_UNFILTERED(event, iTimestamp, strEventType, fHideCaster, strSourceGuid, strSourceName, iSourceFlags, iSourceFlags2, strDestGuid, strDestName, iDestFlags, iDestFlags2, varParam1, varParam2, varParam3, varParam4, varParam5, varParam6, ...)

	local fHandled = false;

	-- Short circuit this processing if we're essentially disabled
	if (not self.db.profile.fEnableText and not self.db.profile.fEnableSound) then
		return
	end

	-- Track instacast buffs
	if (self:FIsSourceFocusOrTarget(iSourceFlags)
			and "SPELL_CAST_SUCCESS" == strEventType
			and self:FInMap(varParam2, nil, self.db.profile.strAuraBlacklist)
	) then
		self.lastInstacastSelfBuffName = varParam2;
		self.lastInstacastSelfBuffTime = GetTime();
	end

	-- Turn off all notifications while in a vehicle
	if (self.db.profile.fDisableInVehicle and UnitInVehicle("player")) then
		return
	end

	-- Global override sounds
	if (not fHandled
			and self:FIsSpellCastStart(strEventType, iSourceFlags, varParam1, varParam2, varParam3)
			and self:FIsCasterOrSpellGlobalOverride(strSourceName, iSourceFlags, varParam1, varParam2, varParam3)
	) then
		self:CheckAndPrintMessage(strSourceName .. " 正在施放 |cffff4444" .. varParam2 .. "|r!");
		self:CheckAndPlaySound(CASTING_SOUND_FILE);
		fHandled = true;
	end

	-- Your partner is sheeped, play a sound
	if (not fHandled
			and 0 ~= bit.band(iDestFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY)
			and 0 ~= bit.band(iDestFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY)
			and "SPELL_AURA_APPLIED" == strEventType
			and self:FInList(varParam2, self.db.profile.strPartnerCC)
			and IsActiveBattlefieldArena()
	) then
		self:CheckAndPrintMessage(strDestName .. " 被變羊了!");
		self:CheckAndPlaySound(POLYMORPH_SOUND_FILE);
		fHandled = true;
	end

	-- Enemy player in an arena is innervated, play a sound
	if (not fHandled
			and 0 ~= bit.band(iDestFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)
			and "SPELL_AURA_APPLIED" == strEventType
			and ((IsActiveBattlefieldArena()
					and self:FInList(varParam2, self.db.profile.strArenaPurge))
				or 0 ~= bit.band(iDestFlags, COMBATLOG_OBJECT_CONTROL_NPC)
					and self:FInList(varParam2, self.db.profile.strPvePurge))
	) then
		self:CheckAndPrintMessage(strDestName .. " 獲得 " .. varParam2 .. "!");
		self:CheckAndPlaySound(INNERVATE_SOUND_FILE);
		fHandled = true;
	end

	-- Play a sound when the Focus starts casting
	if (not fHandled
			and self:FIsSourceFocusOrTarget(iSourceFlags)
			and self:FIsSpellCastStart(strEventType, iSourceFlags, varParam1, varParam2, varParam3)
			and not self:FIsCasterOrSpellBlacklisted(strSourceName, iSourceFlags, varParam1, varParam2, varParam3)
			and not self:FHasBlacklistedAura(iSourceFlags, varParam1, varParam2, varParam3)
			and self:FIsInterruptAvailable()
	) then
		self:CheckAndPrintMessage(strSourceName .. " 正在施放 |cffff4444" .. varParam2 .. "|r!");
		self:CheckAndPlaySound(CASTING_SOUND_FILE);
		fHandled = true;
	end

	-- Play a sound when a hostile player is attempting to CC you
	if (0 ~= bit.band(iSourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)
			and 0 == bit.band(iSourceFlags, COMBATLOG_OBJECT_CONTROL_NPC)
			and self:FIsSpellCastStart(strEventType, iSourceFlags, varParam1, varParam2, varParam3)
			and self:FIsCCSpell(varParam1, varParam2, varParam3)
	) then
		if ((nil ~= self.strAntiCCSpellName or self:FIsSpellAvailable(self.strAntiCCSpellName))
				and (IsActiveBattlefieldArena() or 1 == IsSpellInRange(self.str30YardSpellName, strTarget))
		) then
			self:CheckAndPrintMessage(strSourceName .. " 正在施放控場技: |cffffcc44" .. varParam2 .. "|r。");
			if (not fHandled) then
				self:CheckAndPlaySound(CC_SOUND_FILE);
				fHandled = true;
			end
		else
			self:CheckAndPrintMessage(strSourceName .. " 正在施放控場技: |cffffcc44" .. varParam2 .. "|r (距離過遠/無法動作)。");
		end
	end

	-- Play sound when you interrupt a hostile target
	if (not fHandled
			and "SPELL_INTERRUPT" == strEventType
			and 0 ~= bit.band(iSourceFlags, COMBATLOG_OBJECT_AFFILIATION_MINE)
			and 0 ~= bit.band(iDestFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)
	) then
		self:CheckAndPrintMessage("已成功打斷 |cffaaffff" .. varParam5 .. "|r。");
		if (self.db.profile.fPositiveReinforcement) then
			self:CheckAndPlaySound(INTERRUPTED_SOUND_FILE);
		end
		if (self.db.profile.fAnnounceInterrupts) then
			local strChannel = nil;
			local fInInstance, instanceType = IsInInstance();
			
			-- 修正副本中無法正確通報的問題
			local _, _, difficultyIndex, _, _, _, _, _ = GetInstanceInfo();
			
			-- if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or instanceType == "pvp" or instanceType == "arena") then
			if (fInInstance and (7 == difficultyIndex or 17 == difficultyIndex or 12 == difficultyIndex or IsLFGModeActive(LE_LFG_CATEGORY_LFD))) then
				strChannel = "INSTANCE_CHAT";
			-- elseif (IsInRaid(LE_PARTY_CATEGORY_HOME)) then
			elseif (IsInRaid() and 12 ~= difficultyIndex) then
				strChannel = "RAID";
			-- elseif (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
			elseif (IsInGroup() and 12 ~= difficultyIndex) then
				strChannel = "PARTY";
			end

			if (nil ~= strChannel) then
				SendChatMessage("[斷法] 已打斷 " .. strDestName .. " 的 " .. GetSpellLink(varParam4), strChannel);
			end
		end
		fHandled = true;
	end
end
