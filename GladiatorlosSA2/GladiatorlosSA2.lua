﻿ GladiatorlosSA = LibStub("AceAddon-3.0"):NewAddon("GladiatorlosSA", "AceEvent-3.0","AceConsole-3.0","AceTimer-3.0")

 local AceConfigDialog = LibStub("AceConfigDialog-3.0")
 local AceConfig = LibStub("AceConfig-3.0")
 local L = LibStub("AceLocale-3.0"):GetLocale("GladiatorlosSA")
 local LSM = LibStub("LibSharedMedia-3.0")
 local self, GSA, PlaySoundFile = GladiatorlosSA, GladiatorlosSA, PlaySoundFile
 local GSA_TEXT = L["GladiatorlosSA"]
 local GSA_VERSION = "|cffFF7D0A v1.17 |r(|cFF00FF967.3 Legion|r)"
 local GSA_AUTHOR = " "
 local gsadb
 local soundz,sourcetype,sourceuid,desttype,destuid = {},{},{},{},{}

 local LSM_GSA_SOUNDFILES = {
	["GSA-Demo"] = "Interface\\AddOns\\GladiatorlosSA2\\Voice_Custom\\Will-Demo.ogg",
 }

 local GSA_LOCALEPATH = {
	enUS = "GladiatorlosSA2\\Voice_enUS",
 }
 self.GSA_LOCALEPATH = GSA_LOCALEPATH

 local GSA_LANGUAGE = {
	["GladiatorlosSA2\\Voice_enUS"] = L["English(female)"],
 }
 self.GSA_LANGUAGE = GSA_LANGUAGE

 local GSA_EVENT = {
	SPELL_CAST_SUCCESS = L["Spell_CastSuccess"],
	SPELL_CAST_START = L["Spell_CastStart"],
	SPELL_AURA_APPLIED = L["Spell_AuraApplied"],
	SPELL_AURA_REMOVED = L["Spell_AuraRemoved"],
	SPELL_INTERRUPT = L["Spell_Interrupt"],
	SPELL_SUMMON = L["Spell_Summon"],
	--UNIT_AURA = "Unit aura changed",
 }
 self.GSA_EVENT = GSA_EVENT

 local GSA_UNIT = {
	any = L["Any"],
	player = L["Player"],
	target = L["Target"],
	focus = L["Focus"],
	mouseover = L["Mouseover"],
	--party = L["Party"],
	--raid = L["Raid"],
	--arena = L["Arena"],
	--boss = L["Boss"],
	custom = L["Custom"], 
 }
 self.GSA_UNIT = GSA_UNIT

 local GSA_TYPE = {
	[COMBATLOG_FILTER_EVERYTHING] = L["Any"],
	[COMBATLOG_FILTER_FRIENDLY_UNITS] = L["Friendly"],
	[COMBATLOG_FILTER_HOSTILE_PLAYERS] = L["Hostile player"],
	[COMBATLOG_FILTER_HOSTILE_UNITS] = L["Hostile unit"],
	[COMBATLOG_FILTER_NEUTRAL_UNITS] = L["Neutral"],
	[COMBATLOG_FILTER_ME] = L["Myself"],
	[COMBATLOG_FILTER_MINE] = L["Mine"],
	[COMBATLOG_FILTER_MY_PET] = L["My pet"],
	[COMBATLOG_FILTER_UNKNOWN_UNITS] = "Unknown unit",
 }
 self.GSA_TYPE = GSA_TYPE

--local sourcetype,sourceuid,desttype,destuid = {},{},{},{}
--local gsadb
--local PlaySoundFile = PlaySoundFile
 local dbDefaults = {
	profile = {
		all = false,
		arena = true,
		battleground = true,
		disablelargebg = false,
		field = false,
		path = GSA_LOCALEPATH[GetLocale()], -- or "GladiatorlosSA2\\Voice_enUS",
		path_male = GSA_LOCALEPATH[GetLocale()], -- or "GladiatorlosSA2\\Voice_enUS",
		path_neutral = GSA_LOCALEPATH[GetLocale()], -- or "GladiatorlosSA2\\Voice_enUS",
		path_menu = GSA_LOCALEPATH[GetLocale()], -- or "GladiatorlosSA2\\Voice_enUS",
		throttle = 0,
		smartDisable = false,
		outputUnlock = false,
		output_menu = "MASTER",
		
		aruaApplied = false,
		aruaRemoved = false,
		castStart = false,
		castSuccess = false,
		interrupt = false,

		aonlyTF = false,
		conlyTF= false,
		sonlyTF = false,
		ronlyTF = false,
		drinking = false,
		class = false,
		interruptedfriendly = true,
		
		purge = false,
		spellSteal = false,
		diceRoll = false,
		implosion = false,
		littleMoon = false,
		middleMoon = false,
		explosiveKeg = false,
		cure = false,
		dispel = false,
		rapture = false,
		unstableAffliction = false,
		PredatorSwiftness = false,
		eyeBeam = false,
		
		success = false,
		
		chaosBolt = false,
		apocalypse = false,
		karmaDown = false,
		
		soothingMist = false,
		shiningForce = false,
		thunderstorm = false,
		stickyBomb = false,
		typhoon = false,
		felLash = false,
		camouflage = false,
		stealth = false,
		prowl = false,
		barrage = false,
		
		leapOfFaith = false,
		deathGrip = false,
		hook = false,
		forbearanceDown = false,
		mageShield = false,
		strikeOfTheWindlord = false,
		
		--PH sounds are disabled until they match the rest of the voice pack, however that ends up being.
		--Remember to rename the sound files.
		_PHgreaterFade = false,
		_PHgreaterFadeDown = false,
		_PHfaerieSwarm = false,
		_PHringOfPeace = false,
		_PHcallObserver = false,
		_PHdarkglare = false,
		_PHinnerFocus = false,
		_PHinnerFocusDown = false,
		_PHmarkOfAluneth = false,
		_PHebonbolt = false,
		_PHthalkiel = false,
		_PHashamanesFrenzy = false,
		
		--The following defaults were changed in 1.16.3.
		vampiricBlood = false,
		tombstone = false,
		tombstoneDown = false,
		runetap = false,
		dash = false,
		cenarionWard = false,
		BristlingFur = false,
		mastersCall = false,
		cheetah = false, 
		mendingBandage = false,
		manaTea = false,
		zenMeditation = false,
		zenMeditationDown = false,
		lightAegis = false, 
		ardentDefender = false,
		defenderDown = false,
		ancientKings = false,
		kingsDown = false,
		archangelHealing = false,
		archangelDamage = false,
		sprint = false,
		spiritLink = false, 
		spiritLinkDown = false,
		sacrificialPact = false,
		shieldWall = false,
		shieldWallDown = false,
		
		bigHeal = false,		
		shackleUndead = false,
		cataclysm = false,
		
		battleStandard = false,
		gorefiendGrasp = false,
		defile = false,
		chillStreak = false,
		sindragosaFury = false,
		manaBreak = false,
		displacerBeast = false,
		renewal = false,
		wildCharge = false,
		Exhilaration = false,
		murderOfCrows = false, 
		snakeHunter = false,
		presenceOfMind = false,
		CometStorm = false,
		Meteor = false,
		iceFloes = false, 
		invokeOx = false, 
		pony = false,
		shadowfiend = false,
		desperatePrayer = false, 
		mindbender = false,
		holySerenity = false, 
		cannonballBarrage = false,
		exsanguinate = false,
		stormElemental = false,
		fireElemental = false,
		earthElemental = false,
		windRushTotem = false,
		LiquidMagma = false,
		protectionTotem = false,
		commandingShout = false,
		dragonRoar = false,
		Ravager = false,
		demoShout = false,
		
		custom = {},
	}	
 }

 GSA.log = function(msg) DEFAULT_CHAT_FRAME:AddMessage(L["|cFF33FF22GladiatorlosSA|r: "]..msg) end

 -- LSM BEGIN / inspired from MSBTMedia.lua
 local function RegisterSound(soundName, soundPath)
	if (type(soundName) ~= "string" or type(soundPath) ~= "string") then return end
	if (soundName == "" or soundPath == "") then return end

	soundz[soundName] = soundPath
	LSM:Register("sound", soundName, soundPath)
 end

 for soundName, soundPath in pairs(LSM_GSA_SOUNDFILES) do RegisterSound(soundName, soundPath) end
 for index, soundName in pairs(LSM:List("sound")) do soundz[soundName] = LSM:Fetch("sound", soundName) end

 local function LSMRegistered(event, mediaType, name)
	if (mediaType == "sound") then
		soundz[name] = LSM:Fetch(mediaType, name)
	end
 end
 -- LSM END

 function GladiatorlosSA:OnInitialize()
	if not self.spellList then
		self.spellList = self:GetSpellList()
	end
	for _,v in pairs(self.spellList) do
		for _,spell in pairs(v) do
			if dbDefaults.profile[spell] == nil then dbDefaults.profile[spell] = true end
		end
	end
	
	self.db1 = LibStub("AceDB-3.0"):New("GladiatorlosSADB",dbDefaults, "Default");
	-- DEFAULT_CHAT_FRAME:AddMessage(GSA_TEXT .. GSA_VERSION .. GSA_AUTHOR .." ");
	self:RegisterChatCommand("GladiatorlosSA", "ShowConfig")
	self:RegisterChatCommand("gsa", "ShowConfig")
	self:RegisterChatCommand("gsaz", "ShowConfig") -- ***** @
	self.db1.RegisterCallback(self, "OnProfileChanged", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileCopied", "ChangeProfile")
	self.db1.RegisterCallback(self, "OnProfileReset", "ChangeProfile")
	gsadb = self.db1.profile
	local options = {
		name = L["GladiatorlosSA"],
		desc = L["PVP Voice Alert"],
		type = 'group',
		args = {
			creditdesc = {
			order = 1,
			type = "description",
			name = L["GladiatorlosSACredits"].."\n",
			cmdHidden = true
			},
			gsavers = {
			order = 2,
			type = "description",
			name = GSA_VERSION,
			cmdHidden = true
			},
		},
	}
	local bliz_options = CopyTable(options)
	bliz_options.args.load = {
		name = L["Load Configuration"],
		desc = L["Load Configuration Options"],
		type = 'execute',
		func = function() 
		self:OnOptionCreate() 
			bliz_options.args.load.disabled = true
			GameTooltip:Hide() 
			--fix for in 5.3 BLZOptionsFrame can't refresh on load
			InterfaceOptionsFrame:Hide() 
			InterfaceOptionsFrame:Show() 
		end,
		handler = GladiatorlosSA,
	}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("GladiatorlosSA_bliz", bliz_options)
	AceConfigDialog:AddToBlizOptions("GladiatorlosSA_bliz", L["GladiatorlosSA"])
	LSM.RegisterCallback(LSM_GSA_SOUNDFILES, "LibSharedMedia_Registered", LSMRegistered)
 end

 function GladiatorlosSA:OnEnable()
	GladiatorlosSA:RegisterEvent("PLAYER_ENTERING_WORLD")
	GladiatorlosSA:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	GladiatorlosSA:RegisterEvent("UNIT_AURA")
	if not GSA_LANGUAGE[gsadb.path] then gsadb.path = GSA_LOCALEPATH[GetLocale()] end
	self.throttled = {}
	self.smarter = 0
 end

 function GladiatorlosSA:OnDisable()

 end

--local GSA_GENDER = {"gsadb.path_neutral","gsadb.path_male","gsadb.path"}

 function GSA:GetGenderPath(genderZ)
	if genderZ == 1 then return gsadb.path_neutral
	elseif genderZ == 2 then return gsadb.path_male
	else return gsadb.path
	end
 end

-- play sound by file name
 function GSA:PlaySound(fileName, extend, genderZ)
	local gender_path = self:GetGenderPath(genderZ)
	PlaySoundFile("Interface\\Addons\\" ..gender_path.. "\\"..fileName .. "." .. (extend or "ogg"), gsadb.output_menu)
 end

 function GladiatorlosSA:ArenaClass(id)
	for i = 1 , 5 do
		if id == UnitGUID("arena"..i) then
			return select(2, UnitClass ("arena"..i))
		end
	end
 end

 function GladiatorlosSA:PLAYER_ENTERING_WORLD()
	--CombatLogClearEntries()
 end

-- play sound by spell id and spell type AND gender
 function GladiatorlosSA:PlaySpell(listName, spellID, sourceGUID, destGUID, ...)
	local list = self.spellList[listName]
	if not list[spellID] then return end
	if not gsadb[list[spellID]] then return	end
	if gsadb.throttle ~= 0 and self:Throttle("playspell",gsadb.throttle) then return end
	if gsadb.smartDisable then
		if (GetNumGroupMembers() or 0) > 20 then return end
		if self:Throttle("smarter",20) then
			self.smarter = self.smarter + 1
			if self.smarter > 30 then return end
		else 
			self.smarter = 0
		end
	end
	
	local genderZ
	if gsadb.genderVoice then
		if (sourceGUID ~= nil or destGUID ~= nil) then
			if (sourceGUID == ('') or sourceGUID == nil ) then
				local _, _, _, _, sex, _, _ = GetPlayerInfoByGUID(destGUID)
				genderZ = sex
			else
				local _, _, _, _, sex, _, _ = GetPlayerInfoByGUID(sourceGUID)
				genderZ = sex
			end
		else
			GSA.log ("sourceGUID or destGUID error")
			print("--",sourceGUID,destGUID,listName,spellID)
		end
	end

		self:PlaySound(list[spellID],extend,genderZ)

 end

 function GladiatorlosSA:COMBAT_LOG_EVENT_UNFILTERED(event , ...)
	--Disable By Location
	local _,currentZoneType = IsInInstance()
	local _,isBigBG = GetInstanceInfo(mapID)
--	if (not ((currentZoneType == "none" and gsadb.field) or ((currentZoneType == "pvp" and gsadb.battleground) and ((isBigBG == "30" or "628") and gsadb.disablelargebg)) or (currentZoneType == "arena" and gsadb.arena) or gsadb.all)) then
	if (not ((currentZoneType == "none" and gsadb.field) or (currentZoneType == "pvp" and gsadb.battleground) or (currentZoneType == "arena" and gsadb.arena) or gsadb.all)) then
		return
	end
	--Disable If Large Battleground
--	local _,isBigBG = GetInstanceInfo(mapID)
--		if ((isBigBG == "30" or "628") and gsadb.disablelargebg) then
--		return
--	end
	--testlines Disable If Not Flagged In World
--	local _,flaggedPvP = UnitIsPVP("player")
--	if ((flaggedPvP == "1") and gsadb.onlyflagged and currentZoneType == "none") then
--	end
	local timestamp,event,hideCaster,sourceGUID,sourceName,sourceFlags,sourceFlags2,destGUID,destName,destFlags,destFlags2,spellID,spellName= select ( 1 , ... );
	if not GSA_EVENT[event] then return end

	--	print(sourceName,sourceGUID,destName,destGUID,destFlags,"|cffFF7D0A" .. event.. "|r",spellName,"|cffFF7D0A" .. spellID.. "|r")
	--	print("|cffff0000timestamp|r",timestamp,"|cffff0000event|r",event,"|cffff0000hideCaster|r",hideCaster,"|cffff0000sourceGUID|r",sourceGUID,"|cffff0000sourceName|r",sourceName,"|cffff0000sourceFlags|r",sourceFlags,"|cffff0000sourceFlags2|r",sourceFlags2,"|cffff0000destGUID|r",destGUID,"|cffff0000destName|r",destName,"|cffff0000destFlags|r",destFlags,"|cffff0000destFlags2|r",destFlags2,"|cffff0000spellID|r",spellID,"|cffff0000spellName|r",spellName)
		
		
	if (destFlags) then
		for k in pairs(GSA_TYPE) do
			desttype[k] = CombatLog_Object_IsA(destFlags,k)
			--log("desttype:"..k.."="..(desttype[k] or "nil"))
		end
	else
		for k in pairs(GSA_TYPE) do
			desttype[k] = nil
		end
	end
	if (destGUID) then
		for k in pairs(GSA_UNIT) do
			destuid[k] = (UnitGUID(k) == destGUID)
			--log("destuid:"..k.."="..(destuid[k] and "true" or "false"))
		end
	else
		for k in pairs(GSA_UNIT) do
			destuid[k] = nil
			--log("destuid:"..k.."="..(destuid[k] and "true" or "false"))
		end
	end
	destuid.any = true
	if (sourceFlags) then
		for k in pairs(GSA_TYPE) do
			sourcetype[k] = CombatLog_Object_IsA(sourceFlags,k)
			--log("sourcetype:"..k.."="..(sourcetype[k] or "nil"))
		end
	else
		for k in pairs(GSA_TYPE) do
			sourcetype[k] = nil
			--log("sourcetype:"..k.."="..(sourcetype[k] or "nil"))
		end
	end
	if (sourceGUID) then
		for k in pairs(GSA_UNIT) do
			sourceuid[k] = (UnitGUID(k) == sourceGUID)
			--log("sourceuid:"..k.."="..(sourceuid[k] and "true" or "false"))
		end
	else
		for k in pairs(GSA_UNIT) do
			sourceuid[k] = nil
			--log("sourceuid:"..k.."="..(sourceuid[k] and "true" or "false"))
		end
	end
	sourceuid.any = true

	if (event == "SPELL_AURA_APPLIED" and desttype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.aonlyTF or destuid.target or destuid.focus) and not gsadb.aruaApplied) then
	--The following section is to disable alerts for aura applications (such as dispel protection) from your team onto theirs. IDs should be identical to the ones below.
	-- 87204 = Vampiric Embrace || 196364 = Unstable Affliction || 207171 = Remorseless Winter || 1330 = Garrote - Silence || 1833 = Cheap Shot || 6770 = Sap || 3355 = Freezing Trap || 212332 = Smash (DK Abomination) || 212337 = Powerful Smash (DK Abomination) || 91800 = Gnaw (DK Ghoul) || 91797 = Monstrous Blow (DK Ghoul) || 163505 = Druid Rake Stun
		if spellID == 87204 or spellID == 196364 or spellID == 207171 or spellID == 1330 or spellID == 1833 or spellID == 6770 or spellID == 3355 or spellID == 212332 or spellID == 212337 or spellID == 91800 or spellID == 91797 or spellID == 163505 then return end
			--if (MapID == 40 or InstanceMapID == 4710) and gsadb.disablelargebg then return end
				self:PlaySpell("auraApplied", spellID, sourceGUID, destGUID)
	elseif (event == "SPELL_AURA_APPLIED" and (desttype[COMBATLOG_FILTER_FRIENDLY_UNITS] or desttype[COMBATLOG_FILTER_ME]) and (not gsadb.aonlyTF or destuid.target or destuid.focus) and not gsadb.auraApplied) then
	--The following section is to enable alerts for aura applications (such as dispel protection) onto your team from theirs. IDs should be identical to the ones below.
		if spellID == 87204 or spellID == 196364 or spellID == 207171 or spellID == 1330 or spellID == 1833 or spellID == 6770 or spellID == 3355 or spellID == 212332 or spellID == 212337 or spellID == 91800 or spellID == 91797 or spellID == 163505 then
			--if (MapID == 40 or InstanceMapID == 4710) and gsadb.disablelargebg then return end
				self:PlaySpell("auraApplied", spellID, sourceGUID, destGUID)
		end
	elseif (event == "SPELL_AURA_REMOVED" and desttype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.ronlyTF or destuid.target or destuid.focus) and not gsadb.auraRemoved) then
			--if (MapID == 40 or InstanceMapID == 4710) and gsadb.disablelargebg then return end
			self:PlaySpell("auraRemoved", spellID, sourceGUID, destGUID)
	elseif (event == "SPELL_CAST_START" and sourcetype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.conlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castStart) then
			--if (MapID == 40 or InstanceMapID == 4710) and gsadb.disablelargebg then return end
				--if spellID == 2060 or spellID == 82326 or spellID == 77472 or spellID == 5185 or spellID == 116670 or spellID == 194509 or spellID == 152118 then
				--	if currentZoneType == "arena" then
				--		self:PlaySpell("castStart", spellID, sourceGUID, destGUID)
				--else return end
			self:PlaySpell("castStart", spellID, sourceGUID, destGUID)
	elseif (event == "SPELL_CAST_SUCCESS" and sourcetype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and (not gsadb.sonlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castSuccess) then
			--if (MapID == 40 or InstanceMapID == 4710) and gsadb.disablelargebg then return end
		if self:Throttle(tostring(spellID).."default", 0.05) then return end
		if gsadb.class and currentZoneType == "arena" then
			if spellID == 42292 or spellID == 208683 or spellID == 195710 then
				local c = self:ArenaClass(sourceGUID) -- PvP Trinket Class Callout
					if c then 
					self:PlaySound(c);
				end
			else 
				self:PlaySpell("castSuccess", spellID, sourceGUID, destGUID)
			end
		else
			self:PlaySpell("castSuccess", spellID, sourceGUID, destGUID)
		end
	elseif (event == "SPELL_INTERRUPT" and desttype[COMBATLOG_FILTER_HOSTILE_PLAYERS] and not gsadb.interrupt) then 
		self:PlaySpell ("friendlyInterrupt", spellID, sourceGUID, destGUID)
	elseif (event == "SPELL_INTERRUPT" and (desttype[COMBATLOG_FILTER_FRIENDLY_UNITS] or desttype[COMBATLOG_FILTER_ME]) and not gsadb.interruptedfriendly) then 
		self:PlaySpell ("friendlyInterrupted", spellID, sourceGUID, destGUID)
	end

	--[[ Test lines ]]
	--if (event == "SPELL_AURA_APPLIED" and desttype[COMBATLOG_FILTER_EVERYTHING] and (not gsadb.aonlyTF or destuid.target or destuid.focus) and not gsadb.aruaApplied) then
		--self:PlaySpell("auraApplied", spellID, sourceGUID, destGUID);
	--elseif (event == "SPELL_AURA_REMOVED" and desttype[COMBATLOG_FILTER_EVERYTHING] and (not gsadb.ronlyTF or destuid.target or destuid.focus) and not gsadb.auraRemoved) then
		--self:PlaySpell("auraRemoved", spellID, sourceGUID, destGUID)
	--elseif (event == "SPELL_CAST_START" and sourcetype[COMBATLOG_FILTER_EVERYTHING] and (not gsadb.conlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castStart) then
		--self:PlaySpell("castStart", spellID, sourceGUID, destGUID)
	--elseif ((event == "SPELL_CAST_SUCCESS" or event == "SPELL_SUMMON") and sourcetype[COMBATLOG_FILTER_EVERYTHING] and (not gsadb.sonlyTF or sourceuid.target or sourceuid.focus) and not gsadb.castSuccess) then
		--if self:Throttle(tostring(spellID).."default", 0.05) then return end
		--if (spellID == 42292 or spellID == 59752) and gsadb.class then
			--local _,c,_ = UnitClass("player"); -- localizedClass, englishClass, classIndex = 
			--if c then 
				--self:PlaySound(c);
			--end
		--else	
			--self:PlaySpell("castSuccess", spellID, sourceGUID, destGUID)
		--end
	--elseif (event == "SPELL_INTERRUPT" and desttype[COMBATLOG_FILTER_EVERYTHING] and not gsadb.interrupt) then 
		--self:PlaySpell ("friendlyInterrupt", spellID, sourceGUID, destGUID)
	--end


	-- play custom spells
	for k, css in pairs (gsadb.custom) do
		if css.destuidfilter == "custom" and destName == css.destcustomname then 
			destuid.custom = true  
		else 
			destuid.custom = false
		end
		if css.sourceuidfilter == "custom" and sourceName == css.sourcecustomname then
			sourceuid.custom = true  
		else
			sourceuid.custom = false 
		end

		if css.eventtype[event] and destuid[css.destuidfilter] and desttype[css.desttypefilter] and sourceuid[css.sourceuidfilter] and sourcetype[css.sourcetypefilter] and spellID == tonumber(css.spellid) then
			if self:Throttle(tostring(spellID)..css.name, 0.1) then return end
			--PlaySoundFile(css.soundfilepath, "Master")

			if css.existingsound then -- Added to 2.3.3
				if (css.existinglist ~= nil and css.existinglist ~= ('')) then
					local soundz = LSM:Fetch('sound', css.existinglist)
					PlaySoundFile(soundz, gsadb.output_menu)
				else
					GSA.log (L["No sound selected for the Custom alert : |cffC41F4B"] .. css.name .. "|r.")
				end
			else
				PlaySoundFile(css.soundfilepath, gsadb.output_menu)
			end
		end
	end
 end

-- play drinking in arena
 local DRINK_SPELL, REFRESHMENT_SPELL, FOOD_SPELL = GetSpellInfo(104270), GetSpellInfo(167152), GetSpellInfo(5006), GetSpellInfo(138292)
 function GladiatorlosSA:UNIT_AURA(event,uid)
 
 	local _,currentZoneType = IsInInstance()

	if uid:find("arena") and gsadb.drinking then
	-- if gsadb.drinking then
		if (UnitAura(uid,DRINK_SPELL) or UnitAura(uid,REFRESHMENT_SPELL) or UnitAura(uid,FOOD_SPELL)) and currentZoneType == "arena" then

			local genderZ
			if gsadb.genderVoice then
				genderZ = UnitSex(uid)
			end

			if self:Throttle(tostring(104270) .. uid, 4) then return end
			self:PlaySound("drinking",extend,genderZ)
		end
	end
 end

 function GladiatorlosSA:Throttle(key,throttle)
	if (not self.throttled) then
		self.throttled = {}
	end
	-- Throttling of Playing
	if (not self.throttled[key]) then
		self.throttled[key] = GetTime()+throttle
		return false
	elseif (self.throttled[key] < GetTime()) then
		self.throttled[key] = GetTime()+throttle
		return false
	else
		return true
	end
 end 