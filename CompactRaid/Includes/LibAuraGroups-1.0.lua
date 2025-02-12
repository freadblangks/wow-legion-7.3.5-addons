------------------------------------------------------------
-- LibAuraGroups-1.0.lua
--
-- A library for maintaining "aura groups", that is, buffs/debuffs those provide similar
-- effects, for example, Druid spell "Mark of the Wild" and Paladin spell "Blessing of Kings"
-- both provide "+5% to all stats", so they belong to the same aura group called "STATS".
--
-- Abin
-- 2012/9/08
--
------------------------------------------------------------
-- API documentation:
------------------------------------------------------------

-- lib = _G["LibAuraGroups"]
--
-- Get an object handle of the library.
------------------------------------------------------------

-- lib:GetGroupLocalName("group")
--
-- Returns localized name of the group.
------------------------------------------------------------

-- lib:GetAuraGroup("aura")
--
-- Returns name of the group to which the given aura belongs, if one exists.
------------------------------------------------------------

-- lib:GetGroupAuras("group")
--
-- Returns a table contains all auras belong to the given group, in format of { ["aura"] = spellId, ... },
-- or nil if the group does not exist.
------------------------------------------------------------

-- lib:UnitAura("unit", "aura" [, "group"])
--
-- Find the first aura that belongs to the same group with the given aura, if "group" is not
-- specified, the function searches for all groups until a match is found. Return values are:
-- name, icon, count, dispelType, duration, expires, caster, harmful.
------------------------------------------------------------

-- lib:AuraSameGroup("aura1", "aura2")
--
-- Returns name of the group to which both of the 2 given auras belong to.

------------------------------------------------------------
-- Group names & contents:
------------------------------------------------------------
--
-- BLOODLUST
-- ICE_BLOCK
-- DEVINE_SHIELD
-- POWERWORD_SHIELD

------------------------------------------------------------

local AURA_GROUPS = {

	["BLOODLUST"] = {	-- ��Ѫ����

		2825,		-- ������˾����Ѫ
		32182,		-- ������˾��Ӣ��
		80353,		-- ��ʦ��ʱ��Ť��
		160452,		-- ����������֮��
		90355,		-- ����Ȯ��Զ�ſ���
		57723,		-- ��ƣ����
		57724,		-- ��������
		80354,		-- ʱ�մ�λ
	},

	["ICE_BLOCK"] = {	-- ��ʦ

		27619,		-- ��������
		41425,		-- ����
	},

	["DEVINE_SHIELD"] = {	-- ʥ��ʿ

		642,		-- ʥ����
		1022,		-- ����֮��
		25771,		-- ����
	},

	["POWERWORD_SHIELD"] = {-- ��ʦ

		17,		-- ����������
		6788,		-- �������
	},
}

local type = type
local select = select
local GetSpellInfo = GetSpellInfo
local pairs = pairs
local ipairs = ipairs
local UnitBuff = UnitBuff
local UnitDebuff = UnitDebuff

local LIBNAME = "LibBuffGroups-1.0"
local VERSION = 1.21

local lib = _G[LIBNAME]
if lib and lib.version >= VERSION then return end

if not lib then
	lib = {}
	_G[LIBNAME] = lib
end
lib.version = VERSION
_G.LibBuffGroups = lib

lib.auraGroupList = {}

local function AddGroup(groupList, group, ...)
	if type(group) ~= "string" then
		return
	end

	local count = select("#", ...)
	if count < 1 then
		return
	end

	local list = groupList[group]
	if not list then
		list = {}
		groupList[group] = list
	end

	local i
	for i = 1, count do
		local id = select(i, ...)
		local name = GetSpellInfo(id)
		if name then
			list[name] = id
		end
	end
end

function lib:GetAuraGroup(aura)
	if not aura then
		return
	end

	local group
	for group, list in pairs(lib.auraGroupList) do
		if list[aura] then
			return group
		end
	end
end

local function InternalGetGroupAuras(group)
	return lib.auraGroupList[group]
end

function lib:GetGroupAuras(group)
	local list = InternalGetGroupAuras(group)
	if not list then
		return
	end

	local temp = {}
	local k, v
	for k, v in pairs(list) do
		temp[k] = v
	end
	return temp
end

local function FindAura(list, unit, exclude)
	if not list then
		return
	end

	local _, aura, name, icon, count, dispelType, duration, expires, caster
	for aura in pairs(list) do
		if aura ~= exclude then
			name, _, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, aura)
			if name then
				return name, icon, count, dispelType, duration, expires, caster
			end

			name, _, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, aura)
			if name then
				return name, icon, count, dispelType, duration, expires, caster, 1
			end
		end
	end
end

function lib:UnitAura(unit, aura, group)
	if type(unit) ~= "string" then
		return
	end

	if type(aura) ~= "string" then
		return FindAura(InternalGetGroupAuras(group), unit)
	end

	local name, _, icon, count, dispelType, duration, expires, caster = UnitBuff(unit, aura)
	if name then
		return name, icon, count, dispelType, duration, expires, caster
	end

	name, _, icon, count, dispelType, duration, expires, caster = UnitDebuff(unit, aura)
	if name then
		return name, icon, count, dispelType, duration, expires, caster, 1
	end

	local list = InternalGetGroupAuras(group)
	if not list then
		local _, v
		for _, v in pairs(lib.auraGroupList) do
			if v[aura] then
				list = v
				break
			end
		end
	end

	return FindAura(list, unit, aura)
end

function lib:AuraSameGroup(aura1, aura2)
	if aura1 and aura2 and aura1 ~= aura2 then
		local group, list
		for group, list in pairs(lib.auraGroupList) do
			if list[aura1] and list[aura2] then
				return group
			end
		end
	end
end

local GROUP_NAMES = {
	BLOODLUST = GetSpellInfo(2825),
	ICE_BLOCK = GetSpellInfo(27691),
	DEVINE_SHIELD = GetSpellInfo(642),
	POWERWORD_SHIELD = GetSpellInfo(17),
}

function lib:GetGroupLocalName(group)
	return GROUP_NAMES[group]
end

do
	local group, data
	for group, data in pairs(AURA_GROUPS) do
		local list = {}
		lib.auraGroupList[group] = list

		local _, id
		for _, id in ipairs(data) do
			local name = GetSpellInfo(id)
			if name then
				list[name] = id
			end
		end
	end
end