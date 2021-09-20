local _G = getfenv(0)
local ADDON_NAME, addon = ...

local string = _G.string
local table = _G.table
local math = _G.math
local pairs = _G.pairs
local ipairs = _G.ipairs
local select = _G.select
local LibStub = _G.LibStub

local ShieldTracker = LibStub("AceAddon-3.0"):NewAddon("ShieldTracker", "AceConsole-3.0", "AceEvent-3.0","AceTimer-3.0")

-- Try to remove the Git hash at the end, otherwise return the passed in value.
local function cleanupVersion(version)
	local iter = string.gmatch(version, "(.*)-[a-z0-9]+$")
	if iter then
		local ver = iter()
		if ver and #ver >= 3 then
			return ver
		end
	end
	return version
end

addon.addonTitle = _G.GetAddOnMetadata(ADDON_NAME,"Title")
addon.addonVersion = cleanupVersion("7.3.5")

addon.CURRENT_BUILD, addon.CURRENT_INTERNAL, 
    addon.CURRENT_BUILD_DATE, addon.CURRENT_UI_VERSION = _G.GetBuildInfo()
addon.Legion = addon.CURRENT_UI_VERSION >= 70000

-- Define Bar for now but the rest is at the bottom of the file.
local Bar = {}

-- Local versions for performance
local tinsert, tremove, tgetn = table.insert, table.remove, table.getn
local tconcat = table.concat
local floor, ceil, abs = math.floor, math.ceil, math.abs
local rawget = _G.rawget
local wipe = _G.wipe
local tostring, tonumber = _G.tostring, _G.tonumber
local type, unpack = _G.type, _G.unpack

-- Local for Wow APIs
local UnitAura = _G.UnitAura
local UnitDebuff = _G.UnitDebuff
local GetTime = _G.GetTime
local UnitExists = _G.UnitExists
local UnitName = _G.UnitName

local function GetUnitName(unit)
	local name, server = UnitName(unit)
	if (server and server ~= "") then
		return name.."-"..server
	else
		return name
	end
end

ShieldTracker.playerName = UnitName("player")
ShieldTracker.bars = {}
ShieldTracker.options = nil
ShieldTracker.watchingMouseover = false
ShieldTracker.mouseover = nil
ShieldTracker.mouseoverBars = {}
ShieldTracker.watchedUnits = {}
ShieldTracker.watchedGroupUnits = {}
ShieldTracker.currentRoster = {}
-- Settings to allow custom fonts and textures which override the
-- user set options.
ShieldTracker.CustomUI = {
	texture = nil,
	font = nil,
	fontSize = nil,
	fontFlags = nil,
	showBorders = nil,
}

local AGU = LibStub("AceGUI-3.0")
local Completing = LibStub("AceGUI-3.0-Completing-EditBox")
local L = LibStub("AceLocale-3.0"):GetLocale("ShieldTracker", true)
local LDB = LibStub("LibDataBroker-1.1")
local LibQTip = LibStub("LibQTip-1.0")
local icon = LibStub("LibDBIcon-1.0")
local LSM = LibStub:GetLibrary("LibSharedMedia-3.0")

local CURRENT_BUILD, CURRENT_INTERNAL, 
    CURRENT_BUILD_DATE, CURRENT_UI_VERSION = GetBuildInfo()

local LookupOrKeyMT = {__index = function (t,k) return k end}

local ItemIds = {
	["Indomitable Pride"] = 77211,
--	["Shieldtronic Shield"] = 118006,
	["Purified Shard of the Third Moon"] = 133598,
}
local ItemNames = {}
setmetatable(ItemNames, LookupOrKeyMT)
local function LoadItemNames()
	for k,v in pairs(ItemIds) do
		if not ItemNames[k] then
			ItemNames[k] = (_G.GetItemInfo(ItemIds[k]))
		end
	end
end
LoadItemNames()

local SpellIds = {
	-- Druid
	["Tooth and Claw"] = 135601,
	-- Priest
	["Power Word: Shield"] = 17,
	["Power Word: Shield (Divine Insight)"] = 123258,
	["Divine Aegis"] = 47753,
	["Spirit Shell"] = 114908,
	["Angelic Bulwark"] = 114214,
	["Clarity of Will"] = 152118,
	-- Paladin
	["Illuminated Healing"] = 86273,
	["Sacred Shield"] = 65148,
	["Saved by the Light"] = 157047,
	["Avenger's Reprieve"] = 185676,
	["Greater Blessing of Kings"] = 203538,
	["Bulwark of Order"] = 209388,
	["Shield of Vengeance"] = 184662,
	-- Death Knight
	["Blood Shield"] = 77535,
	["Death Barrier"] = 115635,  -- Removed in Legion?
	["Anti-Magic Shell"] = 48707,
	["Shroud of Purgatory"] = 116888,
	["Tombstone"] = 219809,
	["Frost Shield"] = 207203,
	-- Warrior
	["Shield Barrier"] = 112048,
	["Ignore Pain"] = 190456,
	-- Mage
	["Ice Barrier"] = 11426,
	["Prismatic Barrier"] = 235450,
	["Blazing Barrier"] = 235313,
	["Incanter's Ward"] = 1463,  -- Removed in Legion?
	-- Monk
	["Life Cocoon"] = 116849,
	["Guard"] = 115295,
	["Guard (Glyphed)"] = 123402,
	["Guard (Black Ox Statue)"] = 118604,
	-- Warlock
	["Dark Pact"] = 108416,
	["Twilight Ward"] = 6229,  -- Removed in Legion?
	["Fury Ward"] = 119839,  -- Removed in Legion?
	["Soul Leech"] = 108366,
	-- Items
	["Indomitable"] = 108008,
--	["Shieldtronic Shield"] = 173260,  -- Engineering Item
	["Bulwark of Purity (Demons)"] = 201414, -- Purified Shard of the Third Moon
	["Bulwark of Purity"] = 202052, -- Purified Shard of the Third Moon
	["Xavaric's Magnum Opus"] = 207472,
	-- ["好朋友項鍊"] = 207472,
	["煉獄契約"] = 225140,
	["活化甲殼"] = 225033,
	["阿克蒙德復甦之恨"] = 235169,
	-- Miscellaneous
	["Crystal Shell"] = 137633,  -- Heroic Tortos
	["Resolve"] = 158300,
	["Weak Ancient Barrier"] = 142863,
	["Ancient Barrier"] = 142864,
	["Strong Ancient Barrier"] = 142865,
	["Nullification Barrier"] = 156803,
	["Nullification Barrier (Player)"] = 163134,
	["Time Release"] = 206610,
}
local SpellIdsRev = {}
for k,v in pairs(SpellIds) do
	SpellIdsRev[v] = k
end
local SpellNames = {}
setmetatable(SpellNames, LookupOrKeyMT)
local function LoadSpellNames()
	for k,v in pairs(SpellIds) do
		if rawget(SpellNames, k) == nil then
			SpellNames[k] = _G.GetSpellInfo(v)
		end
	end
end
LoadSpellNames()

local UsesSecondValue = {
	[SpellIds["Greater Blessing of Kings"]] = true,
}

local SpellTracking = {
	[SpellIds["Greater Blessing of Kings"]] = "secondValue",
}

local TipFrame = _G.CreateFrame("GameTooltip", "ShieldTrackerTooltipFrame", _G.UIParent, "GameTooltipTemplate")
TipFrame:SetOwner(_G.UIParent, "ANCHOR_NONE")
local function ConcatenateSpellText(spellName, ...)
	local final = ""
    for i = 1, select("#", ...) do
        local region = select(i, ...)
        if region and region:GetObjectType() == "FontString" then
            local regionText = region:GetText()
			if regionText and regionText ~= SpellNames[spellName] then
				final = final .. regionText .. "\n"
			end
		end
	end
	return final
end
local function GetSpellText(spellName)
	TipFrame:ClearLines()
	TipFrame:SetSpellByID(SpellIds[spellName])
	return ConcatenateSpellText(spellName, TipFrame:GetRegions())
end

local AbsorbsTrackedOrder = {
	L["Death Knight"],
	L["Druid"],
	L["Mage"],
	L["Monk"],
	L["Paladin"],
	L["Priest"],
	L["Warlock"],
	L["Warrior"],
	L["Items"],
	L["Special Debuffs"],
}
local AbsorbsTracked = {
	[L["Priest"]] = {
		["Power Word: Shield"] = true,
		--["Divine Aegis"] = true,
		--["Spirit Shell"] = true,
		--["Angelic Bulwark"] = true,
		--["Power Word: Shield (Divine Insight)"] = true,
		["Clarity of Will"] = true,
	},
	[L["Paladin"]] = {
		--["Illuminated Healing"] = true,
		--["Sacred Shield"] = true,
		--["Saved by the Light"] = true,
		--["Avenger's Reprieve"] = true,
		["Greater Blessing of Kings"] = true,
		["Bulwark of Order"] = true,
		["Shield of Vengeance"] = true,
	},
	[L["Death Knight"]] = {
		["Blood Shield"] = true,
		--["Death Barrier"] = true,
		["Anti-Magic Shell"] = true,
		["Tombstone"] = true,
		["Frost Shield"] = true,
	},
	[L["Druid"]] = {
		--["Tooth and Claw"] = true,
	},
	[L["Monk"]] = {
		["Life Cocoon"] = true,
		--["Guard"] = true,
		--["Guard (Glyphed)"] = true,
		--["Guard (Black Ox Statue)"] = true,
	},
	[L["Mage"]] = {
		["Ice Barrier"] = true,
		["Prismatic Barrier"] = true,
		["Blazing Barrier"] = true,
		--["Incanter's Ward"] = true,
	},
	[L["Warlock"]] = {
		["Dark Pact"] = true,
		["Soul Leech"] = true,
		--["Twilight Ward"] = true,
		--["Fury Ward"] = true,
	},
	[L["Warrior"]] = {
		["Ignore Pain"] = true,
	},
	[L["Items"]] = {
		["Indomitable"] = true,
--		["Shieldtronic Shield"] = true,
		["Bulwark of Purity (Demons)"] = true,
		["Bulwark of Purity"] = true,
		["Xavaric's Magnum Opus"] = true,
		-- ["好朋友項鍊"] = true,
		["煉獄契約"] = true,
		["活化甲殼"] = true,
		["阿克蒙德復甦之恨"] = true,
	},
	[L["Special Debuffs"]] = {
		["Crystal Shell"] = true,
		["Shroud of Purgatory"] = true,
		["Weak Ancient Barrier"] = true,
		["Ancient Barrier"] = true,
		["Strong Ancient Barrier"] = true,
		["Nullification Barrier"] = true,
		["Time Release"] = true,
	},
}

local millFmtOne = "%.1fm"
local thousandFmtOne = "%.1f 萬"
local millFmtZero = "%.0fm"
local thousandFmtZero = "%.0f 萬"
local millFmt = millFmtZero
local thousandFmt = thousandFmtZero

local ThousandsDelim = ('%.1f'):format(1/5):match('([^0-9])') == '.' and ',' or '.'
local BillionDelimFmt = '%s%d' .. ThousandsDelim .. '%03d' .. ThousandsDelim .. '%03d' .. ThousandsDelim .. '%03d'
local MillionDelimFmt = '%s%d' .. ThousandsDelim .. '%03d' .. ThousandsDelim .. '%03d'
local ThousandDelimFmt = '%s%d' .. ThousandsDelim..'%03d'

local function round(number)
    if not number then return 0 end
    return floor(number+0.5)
end

local function FormatNumberDelimited(number)
    if tonumber(number) == nil then
        return number
    end

	local sign = ""
	if number < 0 then
		sign = "-"
		number = abs(number)
	end

    if number >= 1000000000 then
      return BillionDelimFmt:format(sign, number / 1000000000, (number / 1000000) % 1000, (number / 1000) % 1000, number % 1000)
    elseif number >= 1000000 then
      return MillionDelimFmt:format(sign, number / 1000000, (number / 1000) % 1000, number % 1000)
    elseif number >= 1000 then
      return ThousandDelimFmt:format(sign, number / 1000, number % 1000)
    else
      return tostring(number)
    end
end

local function FormatNumberAbbreviated(number)
    if tonumber(number) == nil then
        return number
    end

    if number > 10000 then
        return thousandFmt:format(number / 10000)
    end

    return number
end

local function FormatNumberRaw(number)
	return tostring(number)
end

local FormatNumber = FormatNumberAbbreviated

function ShieldTracker:SetNumberFormat(format)
	if format == "Delimited" then
		FormatNumber = FormatNumberDelimited
	elseif format == "Raw" then
		FormatNumber = FormatNumberRaw
	else
		FormatNumber = FormatNumberAbbreviated
	end
end

local Broker = _G.CreateFrame("Frame")
Broker.obj = LDB:NewDataObject(_G.GetAddOnMetadata(ADDON_NAME, "Title"), {
    type = "data source",
    icon = "Interface\\Icons\\inv_shield_07",
    label = _G.GetAddOnMetadata(ADDON_NAME, "Title"),
    text = _G.GetAddOnMetadata(ADDON_NAME, "Title"),
    barValue = 0,
    barR = 0,
    barG = 0,
    barB = 1,
	OnClick = function(clickedframe, button)
		if button == "RightButton" then
			local optionsFrame = _G.InterfaceOptionsFrame
			if optionsFrame:IsVisible() then
				optionsFrame:Hide()
			else
				ShieldTracker:ShowOptions()
			end
		elseif button == "LeftButton" and _G.IsShiftKeyDown() then
        end
	end
} )

local GREEN = "|cff00ff00"
local RED = "|cffff0000"
local YELLOW = "|cffffff00"
local BLUE = "|cff0198e1"
local ORANGE = "|cffff9933"
local addonHdr = BLUE.."%s %s"
local barInfoFmt1 = "%s%s"
local barInfoFmt2 = "%s%s"
function Broker.obj:OnEnter()
	local tooltip = LibQTip:Acquire("ShieldTrackerTooltip", 2, "LEFT", "RIGHT")
	self.tooltip = tooltip 

    tooltip:AddHeader(L["Shield Tracker"])
    tooltip:AddLine()
	tooltip:AddLine(L["Bar Name"], L["Unit"])
	tooltip:AddSeparator(1)

	for name, bar in pairs(ShieldTracker.bars) do
		local color = bar.db.enabled and GREEN or RED
		tooltip:AddLine(barInfoFmt1:format(color, tostring(bar.name)),
			 barInfoFmt2:format(ORANGE, bar.unit or ""))
	end

	tooltip:SmartAnchorTo(self)
	tooltip:Show()
end

function Broker.obj:OnLeave()
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end

local defaults = {
    profile = {
		minimap = {
			hide = true,
		},
        verbose = false,
        precision = "Zero",
		numberFormat = "Abbreviated",
		-- Font Settings
		font_size = 12,
		font_face = "Friz Quadrata TT",
		font_outline = true,
		font_monochrome = false,
		font_thickoutline = false,
        -- Skinning options
		skinning = {
			elvui = {
		        enabled = true,
		        borders = true,
		        texture = true,
		        font = true,
		        font_flags = true,
			},
			tukui = {
		        enabled = true,
		        borders = true,
		        texture = true,
		        font = true,
		        font_flags = true,
			},
		},
		-- Bars
		bars = {
			-- Provide defaults for all bars.
			-- These are inherited if no bar or no value is set.
			['**'] = {
				enabled = false,
				shown = true,
				locked = false,
				texture = "Blizzard",
				border = true,
				color = {r = 1.0, g = 0.0, b = 0.0, a = 1},
				bgcolor = {r = 0.65, g = 0.0, b = 0.0, a = 0.8},
				textcolor = {r = 1.0, g = 1.0, b = 1.0, a = 1},
				x = 0, 
				y = 0,
				width = 75,
				height = 15,
				scale = 1,
				anchorFrame = "None",
				anchorBar = "",
				anchorFrameCustom = "",
				anchorFramePt = "BOTTOM",
				anchorPt = "TOP",
				anchorX = 0,
				anchorY = -8,
				alwaysShow = false,
				timeRemaining = "None",
				unit = "player",
				unitName = "",
				unitSubgroup = 1,
				unitIndex = 1,
				tracked = "Selected",
				tracking = {},
				label = {
					enabled = false,
					anchorPoint = "BOTTOM",
					anchorX = 0,
					anchorY = -8,
					overrideFontSize = false,
					fontSize = 11,
					overrideText = false,
					text = nil,
				},
			},
		},
	},
}

function ShieldTracker:ShowOptions()
	_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.Main)
	_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame.Main)
end

function ShieldTracker:SetSkin(update)
    local Tukui = _G.Tukui
    local ElvUI = _G.ElvUI

    if Tukui and self.db.profile.skinning.tukui.enabled then
        local T, C, L = unpack(Tukui)
        if C and C["media"] then
            local media = C["media"]
            if media.normTex and self.db.profile.skinning.tukui.texture then
                self.CustomUI.texture = media.normTex
            end
            if media.font and self.db.profile.skinning.tukui.font then
                self.CustomUI.font = media.normFont
            end
            if self.db.profile.skinning.tukui.font_flags then
                self.CustomUI.fontFlags = ""
            end
            if self.db.profile.skinning.tukui.borders then
                self.CustomUI.showBorders = false
            end
        else
            self:Print(L["Could not find Tukui config."])
        end
    elseif ElvUI and self.db.profile.skinning.elvui.enabled then
        local E, L, P, G = unpack(ElvUI)
        if E and E["media"] then
            local media = E["media"]
            if media.normTex and self.db.profile.skinning.elvui.texture then
                self.CustomUI.texture = media.normTex
            end
            if media.normFont and self.db.profile.skinning.elvui.font then
                self.CustomUI.font = media.normFont
            end
            if self.db.profile.skinning.elvui.font_flags then
                self.CustomUI.fontFlags = ""
            end
            if self.db.profile.skinning.elvui.borders then
                self.CustomUI.showBorders = false
            end
        else
            self:Print(L["Could not find the ElvUI config."])
        end
	else
        self.CustomUI.texture = nil
        self.CustomUI.font = nil
        self.CustomUI.fontSize = nil
        self.CustomUI.fontFlags = nil
        self.CustomUI.showBorders = nil
    end

	if update then
		for name, bar in pairs(self.bars) do
			bar:Reset()
		end
	end
end

function ShieldTracker:GetOptions()
    if not self.options then
        self.options = {
            type = "group",
            name = L["Shield Tracker"],
            args = {
				description = {
					order = 1,
					type = "description",
					name = L["ShieldTracker_Desc"],
				},
				generalOpts = {
					order = 2,
					type = "group",
					name = L["General Options"],
					args = self:GetGeneralOptions(),
				},
				barOpts = {
					order = 3,
					type = "group",
					name = L["Bars"],
					args = self:GetBarOptions(),
				},
				skinningOpts = {
					order = 4,
					type = "group",
					name = L["Skinning"],
					args = self:GetSkinningOptions(),
				},
            },
        }
		--options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    end
    return self.options
end

function ShieldTracker:GetGeneralOptions()
	local testNumber = 12000
	local core = {
	    generalOptions = {
	        order = 2,
	        type = "group",
			guiInline = true,
	        name = L["General Options"],
			args = {
	    	    minimap = {
	    			order = 20,
	                name = L["Minimap Button"],
	                desc = L["Toggle the minimap button"],
	                type = "toggle",
	                set = function(info,val)
	                    	-- Reverse the value since the stored value is to hide it
	                        self.db.profile.minimap.hide = not val
	                    	if self.db.profile.minimap.hide then
	                    		icon:Hide("ShieldTrackerLDB")
	                    	else
	                    		icon:Show("ShieldTrackerLDB")
	                    	end
	                      end,
	                get = function(info)
	            	        -- Reverse the value since the stored value is to hide it
	                        return not self.db.profile.minimap.hide
	                      end,
	            },
				numberFormat = {
					name = L["Number Format"],
					desc = L["NumberFormat_OptionDesc"],
					type = "select",
					values = {
					    ["Raw"] = L["Raw"] .. 
							" (" .. FormatNumberRaw(testNumber) .. ")",
					    ["Delimited"] = L["Delimited"] .. 
							" (" .. FormatNumberDelimited(testNumber) .. ")",
					    ["Abbreviated"] = L["Abbreviated"] .. 
							" (" .. FormatNumberAbbreviated(testNumber) .. ")"
					},
					order = 34,
					set = function(info, val)
					    self.db.profile.numberFormat = val
						self:SetNumberFormat(val)
					end,
	                get = function(info)
	                    return self.db.profile.numberFormat
	                end,
				},
				precision = {
					name = L["Precision"],
					desc = L["Precision_OptionDesc"],
					type = "select",
					values = {
					    ["Zero"] = L["Zero"],
					    ["One"] = L["One"]
					},
					order = 35,
					set = function(info, val)
					    self.db.profile.precision = val
					    if val == "One" then
	                        millFmt = millFmtOne
	                        thousandFmt = thousandFmtOne
				        else
	                        millFmt = millFmtZero
	                        thousandFmt = thousandFmtZero
	                    end
					end,
	                get = function(info)
	                    return self.db.profile.precision
	                end,
				},
				config_mode = {
					name = L["Config Mode"],
					desc = L["Toggle config mode"],
					type = "execute",
					order = 50,
					func = function()
					    self.configMode = not self.configMode
						for name, bar in pairs(self.bars) do
							if self.configMode then
								bar.bar:Show()
							else
								bar.bar:Hide()
							end
						end
					end,
				},
			},
		},
	    fonts = {
	        order = 60,
	        type = "group",
			guiInline = true,
	        name = L["Font"],
			args = {
				bar_font_size = {
					order = 70,
					name = L["Font size"],
					desc = L["Font size for the bars."],
					type = "range",
					min = 8,
					max = 30,
					step = 1,
					set = function(info, val) 
						self.db.profile.font_size = val
						for k, v in pairs(self.bars) do
							if v then v:ResetFonts() end
						end
					end,
					get = function(info,val) return self.db.profile.font_size end,
				},
				bar_font = {
					order = 80,
					type = "select",
					name = L["Font"],
					desc = L["Font to use."],
					values = LSM:HashTable("font"),
					dialogControl = 'LSM30_Font',
					get = function() return self.db.profile.font_face end,
					set = function(info, val) 
					    self.db.profile.font_face = val
						for k, v in pairs(self.bars) do
							if v then v:ResetFonts() end
						end
					end
				},
				bar_font_outline = {
					name = L["Outline"],
					desc = L["FontOutline_OptionDesc"],
					type = "toggle",
					order = 90,
					set = function(info, val)
					    self.db.profile.font_outline = val
						for k, v in pairs(self.bars) do
							if v then v:ResetFonts() end
						end
					end,
		            get = function(info)
		                return self.db.profile.font_outline
		            end,
				},
				bar_font_monochrome = {
					name = L["Monochrome"],
					desc = L["FontMonochrome_OptionDesc"],
					type = "toggle",
					order = 100,
					set = function(info, val)
					    self.db.profile.font_monochrome = val
						for k, v in pairs(self.bars) do
							if v then v:ResetFonts() end
						end
					end,
		            get = function(info)
		                return self.db.profile.font_monochrome
		            end,
				},
				bar_font_thickoutline = {
					name = L["Thick Outline"],
					desc = L["FontThickOutline_OptionDesc"],
					type = "toggle",
					order = 110,
					set = function(info, val)
					    self.db.profile.font_thickoutline = val
						for k, v in pairs(self.bars) do
							if v then v:ResetFonts() end
						end
					end,
		            get = function(info)
		                return self.db.profile.font_thickoutline
		            end,
				},
			},
		},
	}
	return core
end

function ShieldTracker:GetBarOptions()
	local barOpts = {
		createBar = {
			order = 2,
			type = "input",
			name = L["Create Bar"],
			desc = L["CreateBarDesc"],
			--validate = function(info, val)
			--	if val and rawget(self.db.profile.bars, val) ~= nil then
			--		return "A bar already exists with that name"
			--	end
			--end,
			set = function(info, val)
				if val and val ~= "" and 
					rawget(self.db.profile.bars, val) == nil then
					self:CreateNewBar(val)
				end
			end,
		},
	}

	for name, bar in pairs(self.bars) do
		local bar = self.bars[name]
		barOpts[name.."_Bar"] = {
			order = 100,
			type = "group",
			childGroups = "tab",
			name = function() return bar.name end,
			args = self:GetOptionsForBar(bar.name),
		}
	end

	return barOpts
end

function ShieldTracker:CreateNewBar(name)
	if name and rawget(self.db.profile.bars, name) == nil then
		self.db.profile.bars[name] = self.db.profile.bars[name] or {}
		local bar = Bar:Create(name)
		self.options.args.barOpts.args[name.."_Bar"] = {
			order = 100,
			type = "group",
			childGroups = "tab",
			name = function() return bar.name end,
			args = self:GetOptionsForBar(bar.name),
		}
	end
end

function ShieldTracker:RemoveBar(name)
	self.options.args.barOpts.args[name.."_Bar"] = nil
	self.bars[name]:Remove()
end

function ShieldTracker:RenameBar(old, new)
	self.db.profile.bars[new] = self.db.profile.bars[old]
	self.db.profile.bars[old] = nil
	for name,bar in pairs(self.db.profile.bars) do
		if bar.anchorBar and bar.anchorBar == old then
			bar.anchorBar = new
		end
	end
	self.bars[new] = self.bars[old]
	self.bars[old] = nil
	self.bars[new].name = new
	self.bars[new].friendlyName = new
	self.options.args.barOpts.args[new.."_Bar"] = 
		self.options.args.barOpts.args[old.."_Bar"]
	self.options.args.barOpts.args[old.."_Bar"] = nil
end

function ShieldTracker:GetOptionsForBar(name)
	if Completing then
		Completing:Register ("AutocompleteCharNames", 
			_G.AUTOCOMPLETE_LIST.ALL)
	end

	local bar = self.bars[name]
	local barOpts = {
		generalOpts = {
			order = 210,
			type = "group",
			name = L["General Options"],
			args = {
				renameBar = {
					order = 1,
					type = "input",
					name = L["Rename Bar"],
					desc = L["RenameBarDesc"],
					--validate = function(info, val)
					--	if val and rawget(self.db.profile.bars, val) ~= nil then
					--		return "A bar already exists with that name"
					--	end
					--end,
					set = function(info, val)
						if val and val ~= "" and 
							rawget(self.db.profile.bars, val) == nil then
							self:RenameBar(bar.name, val)
						end
					end,
				},
				deleteBar = {
					order = 2,
					type = "execute",
					name = L["Delete Bar"],
					desc = L["DeleteBarDesc"],
					width = "half",
					confirm = function()
						return L["DeleteConfirmMsg"]
					end,
					func = function()
						self:RemoveBar(bar.name)
					end,
				},
				showBar = {
					order = 3,
					type = "execute",
					name = L["Show Bar"],
					desc = L["ShowBarConfig_Desc"],
					width = "half",
					func = function()
						if self.bars[bar.name].bar:IsShown() then
							self.bars[bar.name].bar:Hide()
						else
							self.bars[bar.name].bar:Show()
						end
					end,
				},
	            generalOptions = {
	                order = 5,
	                type = "group",
	                name = L["General Options"],
					guiInline = true,
					args = {
			    		enabled = {
							name = L["Enabled"],
							desc = L["EnableBarDesc"],
							type = "toggle",
							order = 10,
							set = function(info, val)
							    self.db.profile.bars[bar.name].enabled = val
								self.bars[bar.name]:UpdateVisibility()
							end,
			                get = function(info)
								return self.db.profile.bars[bar.name].enabled
							end,
						},
						lock = {
							name = L["Lock bar"],
							desc = L["LockBarDesc"],
							type = "toggle",
							order = 20,
							set = function(info, val)
							    self.db.profile.bars[bar.name].locked = val 
								self.bars[bar.name]:Lock()
							end,
			                get = function(info)
								return self.db.profile.bars[bar.name].locked
							end,
						},
						unit = {
							name = L["Unit"],
							desc = L["UnitDesc"],
							order = 30,
							type = "select",
							values = {
							    ["player"] = L["Player"],
							    ["target"] = L["Target"],
							    ["focus"] = L["Focus"],
							    ["named"] = L["Named"],
							    ["pet"] = L["Pet"],
							    ["mouseover"] = L["Mouseover"],
								["group"] = L["Group"],
							},
							set = function(info, val)
							    self.db.profile.bars[bar.name].unit = val
								self.bars[bar.name]:UpdateUnit()
							end,
			                get = function(info)
								return self.db.profile.bars[bar.name].unit
							end,
						},
						unitName = {
							name = L["Unit Name"],
							desc = L["UnitNameDesc"],
							order = 40,
							type = "input",
							dialogControl = "EditBoxAutocompleteCharNames",
							set = function(info, val)
							    self.db.profile.bars[bar.name].unitName = val
								self.bars[bar.name]:UpdateUnit()
							end,
			                get = function(info)
								return self.db.profile.bars[bar.name].unitName
							end,
							disabled = function()
								return self.db.profile.bars[bar.name].unit ~= "named"
							end,
						},
						unitSubgroup = {
							name = L["Subgroup"],
							desc = L["SubgroupDesc"],
							order = 41,
							type = "select",
							width = "half",
							values = {
								[1] = "1",
								[2] = "2",
								[3] = "3",
								[4] = "4",
								[5] = "5",
								[6] = "6",
								[7] = "7",
								[8] = "8",
							},
							set = function(info, val)
							    self.db.profile.bars[bar.name].unitSubgroup = val
								self.bars[bar.name]:UpdateUnit()
							end,
			                get = function(info)
								return self.db.profile.bars[bar.name].unitSubgroup
							end,
							disabled = function()
								return self.db.profile.bars[bar.name].unit ~= "group"
							end,
						},
						unitIndex = {
							name = L["Index"],
							desc = L["IndexDesc"],
							order = 42,
							type = "select",
							width = "half",
							values = {
								[1] = "1",
								[2] = "2",
								[3] = "3",
								[4] = "4",
								[5] = "5",
							},
							set = function(info, val)
							    self.db.profile.bars[bar.name].unitIndex = val
								self.bars[bar.name]:UpdateUnit()
							end,
			                get = function(info)
								return self.db.profile.bars[bar.name].unitIndex
							end,
							disabled = function()
								return self.db.profile.bars[bar.name].unit ~= "group"
							end,
						},
						timeRemaining = {
							name = L["Time Remaining"],
							desc = L["TimeRemaining_OptionDesc"],
							type = "select",
							values = {
							    ["None"] = L["None"],
							    ["RIGHT"] = L["Right"],
							    ["LEFT"] = L["Left"],
							},
							order = 50,
							width = "double",
							set = function(info, val)
							    self.db.profile.bars[bar.name].timeRemaining = val
								if val == "None" then
							        self.bars[bar.name].bar.time:Hide()
								else
							        self.bars[bar.name].bar.time:SetPoint(val or "RIGHT")
							        self.bars[bar.name].bar.time:SetJustifyH(val or "RIGHT")
							        self.bars[bar.name]:CheckTracking()
								end
							end,
			                get = function(info)
			                    return self.db.profile.bars[bar.name].timeRemaining
			                end,
						},
					},
				},
	            dimensions = {
	                order = 300,
	                type = "group",
					guiInline = true,
	                name = L["Dimensions"],
					args = {
						width = {
							order = 310,
							name = L["Width"],
							desc = L["BarWidth_Desc"],	
							type = "range",
							min = 50,
							max = 300,
							step = 1,
							set = function(info, val)
							    self.db.profile.bars[bar.name].width = val 
								self.bars[bar.name].bar:SetWidth(val)
								self.bars[bar.name].bar.border:SetWidth(val+9)
							end,
							get = function(info, val)
							    return self.db.profile.bars[bar.name].width
							end,
						},
						height = {
							order = 320,
							name = L["Height"],
							desc = L["BarHeight_Desc"],
							type = "range",
							min = 10,
							max = 30,
							step = 1,
							set = function(info, val)
							    self.db.profile.bars[bar.name].height = val 
								self.bars[bar.name].bar:SetHeight(val)
								self.bars[bar.name].bar.border:SetHeight(val + 8)
							end,
							get = function(info, val)
							    return self.db.profile.bars[bar.name].height
							end,					
						},
						scale = {
							order = 330,
							name = L["Scale"],
							desc = L["ScaleDesc"],
							type = "range",
							min = 0.1,
							max = 3,
							step = 0.1,
							get = function()
								return self.db.profile.bars[bar.name].scale
							end,
							set = function(info, val)
							    self.db.profile.bars[bar.name].scale = val
							    self.bars[bar.name].bar:SetScale(val)
							end
						},
					},
				},
	            position = {
	                order = 400,
	                type = "group",
					guiInline = true,
	                name = L["Position"],
					args = {
						x = {
							order = 410,
							name = L["X Offset"],
							desc = L["XOffset_Desc"],	
							type = "range",
							softMin = -floor(_G.GetScreenWidth()/2),
							softMax = floor(_G.GetScreenWidth()/2),
							bigStep = 1,
							set = function(info, val)
							    self.db.profile.bars[bar.name].x = val
								self.bars[bar.name].bar:SetPoint(
									"CENTER", _G.UIParent, "CENTER", 
									self.db.profile.bars[bar.name].x, 
									self.db.profile.bars[bar.name].y)
							end,
							get = function(info, val)
							    return self.db.profile.bars[bar.name].x
							end,
						},
						y = {
							order = 420,
							name = L["Y Offset"],
							desc = L["YOffset_Desc"],	
							type = "range",
							softMin = -floor(_G.GetScreenHeight()/2),
							softMax = floor(_G.GetScreenHeight()/2),
							bigStep = 1,
							set = function(info, val)
							    self.db.profile.bars[bar.name].y = val
								self.bars[bar.name].bar:SetPoint(
									"CENTER", _G.UIParent, "CENTER", 
									self.db.profile.bars[bar.name].x, 
									self.db.profile.bars[bar.name].y)
							end,
							get = function(info, val)
							    return self.db.profile.bars[bar.name].y
							end,
						},
					},
				},
			},
		},
		appearanceOpts = {
			order = 215,
			type = "group",
			name = L["Appearance"],
			args = {
	            colors = {
	                order = 500,
	                type = "group",
					guiInline = true,
	                name = L["Colors"],
					args = {
						textcolor = {
							order = 510,
							name = L["Text Color"],
							desc = L["BarTextColor_OptionDesc"],
							type = "color",
							hasAlpha = true,
							set = function(info, r, g, b, a)
							    local c = self.db.profile.bars[bar.name].textcolor
							    c.r, c.g, c.b, c.a = r, g, b, a
							    self.bars[bar.name]:UpdateGraphics()
							end,
							get = function(info)
						        local c = self.db.profile.bars[bar.name].textcolor
							    return c.r, c.g, c.b, c.a
							end,					
						},
						color = {
							order = 520,
							name = L["Bar Color"],
							desc = L["BarColor_OptionDesc"],
							type = "color",
							hasAlpha = true,
							set = function(info, r, g, b, a)
							    local c = self.db.profile.bars[bar.name].color
							    c.r, c.g, c.b, c.a = r, g, b, a
							    self.bars[bar.name]:UpdateGraphics()
							end,
							get = function(info)
						        local c = self.db.profile.bars[bar.name].color
							    return c.r, c.g, c.b, c.a
							end,					
						},
						bgcolor = {
							order = 530,
							name = L["Bar Background Color"],
							desc = L["BarBackgroundColor_OptionDesc"],
							type = "color",
							hasAlpha = true,
							set = function(info, r, g, b, a)
							    local c = self.db.profile.bars[bar.name].bgcolor
							    c.r, c.g, c.b, c.a = r, g, b, a
							    self.bars[bar.name]:UpdateGraphics()
							end,
							get = function(info)
						        local c = self.db.profile.bars[bar.name].bgcolor
							    return c.r, c.g, c.b, c.a
							end,					
						},
					},
				},
	            font = {
	                order = 550,
	                type = "group",
					guiInline = true,
	                name = L["Font"],
					args = {
						font_size = {
							order = 70,
							name = L["Font size"],
							desc = L["Font size"],
							type = "range",
							min = 8,
							max = 30,
							step = 1,
							set = function(info, val) 
								self.db.profile.bars[bar.name].font_size = val
								self.bars[bar.name]:ResetFonts()
							end,
							get = function(info,val)
								return self.db.profile.bars[bar.name].font_size 
									or self.db.profile.font_size
							end,
						},
						font = {
							order = 80,
							type = "select",
							name = L["Font"],
							desc = L["Font to use."],
							values = LSM:HashTable("font"),
							dialogControl = 'LSM30_Font',
							get = function()
								return self.db.profile.bars[bar.name].font_face 
									or self.db.profile.font_face
							end,
							set = function(info, val) 
							    self.db.profile.bars[bar.name].font_face = val
								self.bars[bar.name]:ResetFonts()
							end
						},
						font_outline = {
							name = L["Outline"],
							desc = L["FontOutline_OptionDesc"],
							type = "toggle",
							order = 90,
							set = function(info, val)
							    self.db.profile.bars[bar.name].font_outline = val
								self.bars[bar.name]:ResetFonts()
							end,
				            get = function(info)
				                return self.db.profile.bars[bar.name].font_outline
									or self.db.profile.font_outline
				            end,
						},
						font_monochrome = {
							name = L["Monochrome"],
							desc = L["FontMonochrome_OptionDesc"],
							type = "toggle",
							order = 100,
							set = function(info, val)
							    self.db.profile.bars[bar.name].font_monochrome = val
								self.bars[bar.name]:ResetFonts()
							end,
				            get = function(info)
				                return self.db.profile.bars[bar.name].font_monochrome
									or self.db.profile.font_monochrome
				            end,
						},
						font_thickoutline = {
							name = L["Thick Outline"],
							desc = L["FontThickOutline_OptionDesc"],
							type = "toggle",
							order = 110,
							set = function(info, val)
							    self.db.profile.bars[bar.name].font_thickoutline = val
								self.bars[bar.name]:ResetFonts()
							end,
				            get = function(info)
				                return self.db.profile.bars[bar.name].font_thickoutline
									or self.db.profile.font_thickoutline
				            end,
						},
					},
				},
	            appearance = {
	                order = 600,
	                type = "group",
					guiInline = true,
	                name = L["Appearance"],
					args = {
						texture = {
							order = 610,
							name = L["Texture"],
							desc = L["BarTexture_OptionDesc"],
							type = "select",
							values = LSM:HashTable("statusbar"),
							dialogControl = 'LSM30_Statusbar',
							get = function()
							    return self.db.profile.bars[bar.name].texture
							end,
							set = function(info, val)
							    self.db.profile.bars[bar.name].texture = val
							    self.bars[bar.name]:UpdateTexture()
							end,
							disabled = function()
							    return not self.db.profile.bars[bar.name].shown
							end,
						},
						borderVisible = {
							order = 620,
							name = L["ShowBorder"],
							desc = L["ShowBorderDesc"],
							type = "toggle",
							get = function()
							    return self.db.profile.bars[bar.name].border
							end,
							set = function(info, val)
							    self.db.profile.bars[bar.name].border = val
							    self.bars[bar.name]:UpdateBorder()
							end,
						},
						barVisible = {
							order = 630,
							name = L["ShowBar"],
							desc = L["ShowBarDesc"],
							type = "toggle",
							get = function()
								return self.db.profile.bars[bar.name].shown
							end,
							set = function(info,val) 
						        self.db.profile.bars[bar.name].shown = val
						        self.bars[bar.name]:UpdateVisibility()
						    end,
						},
					},
				},
			},
		},
		absorbOpts = {
			order = 220,
			type = "group",
			name = L["Absorbs Tracked"],
			args = {
				absorbsTracked = {
					name = L["Absorbs Tracked"],
					desc = L["AbsorbsTracked_OptionDesc"],
					type = "select",
					values = {
					    ["All"] = L["All"],
					    ["Selected"] = L["Selected"],
					    ["Excluding"] = L["All Minus Selected"],
					},
					order = 1,
					set = function(info, val)
					    self.db.profile.bars[bar.name].tracked = val
						self.bars[bar.name]:CheckTracking()
					end,
	                get = function(info)
	                    return self.db.profile.bars[bar.name].tracked
	                end,
				},
			},
		},
		labelOpts = {
			order = 230,
			type = "group",
			name = L["Label"],
			args = self:GetLabelOptions(bar.name),
		},
		anchorOpts = {
			order = 240,
			type = "group",
			name = L["Anchor"],
			args = self:GetAdvancedPositioning(bar.name),
		},
	}

	if Completing then
		barOpts.generalOpts.args.generalOptions.args.unitName.dialogControl = "EditBoxAutocompleteCharNames"
	end

	local i = 810
	for j, category in ipairs(AbsorbsTrackedOrder) do
		barOpts.absorbOpts.args["ATC_"..category] = {
			order = i,
            type = "header",
            name = category,
		}
		i = i + 1
		
		for spell, enabled in pairs(AbsorbsTracked[category]) do
			barOpts.absorbOpts.args["AT_"..spell] = {
				order = i,
				name = SpellNames[spell],
				desc = GetSpellText(spell),
				type = "toggle",
				get = function()
					return self.db.profile.bars[bar.name].tracking[spell]
				end,
				set = function(info,val) 
			        self.db.profile.bars[bar.name].tracking[spell] = val
					self.bars[bar.name]:CheckTracking()
			    end,
				disabled = function()
					return self.db.profile.bars[bar.name].tracked == "All"
				end,
			}
			i = i + 1
		end
	end

	return barOpts
end

function ShieldTracker:GetSkinningOptions()
	local skinningOpts = {
	    description = {
	        order = 1,
	        type = "description",
	        name = L["Skinning_Desc"],
	    },
	    elvuiOptions = {
	        order = 10,
	        type = "group",
			guiInline = true,
	        name = L["ElvUI"],
			args = {
	            elvui_enabled = {
	                name = L["Enabled"],
					order = 20,
	                desc = L["ElvUIEnabled_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.elvui.enabled = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.elvui.enabled
	                end,
	            },
	            elvui_borders = {
	                name = L["Borders"],
					order = 30,
	                desc = L["ElvUIBorders_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.elvui.borders = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.elvui.borders
	                end,
	            },
	            elvui_texture = {
	                name = L["Texture"],
					order = 40,
	                desc = L["ElvUITexture_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.elvui.texture = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.elvui.texture
	                end,
	            },
	            elvui_font = {
	                name = L["Font"],
					order = 50,
	                desc = L["ElvUIFont_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.elvui.font = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.elvui.font
	                end,
	            },
	            elvui_font_flags = {
	                name = L["Font Flags"],
					order = 60,
	                desc = L["ElvUIFontFlags_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.elvui.font_flags = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.elvui.font_flags
	                end,
	            },
			},
		},
	    tukuiOptions = {
	        order = 100,
	        type = "group",
			guiInline = true,
	        name = L["Tukui"],
			args = {
	            tukui_enabled = {
	                name = L["Enabled"],
					order = 110,
	                desc = L["TukuiEnabled_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.tukui.enabled = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.tukui.enabled
	                end,
	            },
	            tukui_borders = {
	                name = L["Borders"],
					order = 120,
	                desc = L["TukuiBorders_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.tukui.borders = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.tukui.borders
	                end,
	            },
	            tukui_texture = {
	                name = L["Texture"],
					order = 130,
	                desc = L["TukuiTexture_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.tukui.texture = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.tukui.texture
	                end,
	            },
	            tukui_font = {
	                name = L["Font"],
					order = 140,
	                desc = L["TukuiFont_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.tukui.font = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.tukui.font
	                end,
	            },
	            tukui_font_flags = {
	                name = L["Font Flags"],
					order = 150,
	                desc = L["TukuiFontFlags_OptionDesc"],
	                type = "toggle",
	                set = function(info, val)
	                    self.db.profile.skinning.tukui.font_flags = val
						self:SetSkin(true)
	                end,
	                get = function(info)
	                    return self.db.profile.skinning.tukui.font_flags
	                end,
	            },
			},
		},
    }
	return skinningOpts
end

function ShieldTracker:GetAnchorList(barName)
	local bar = self.bars[barName]
	bar.anchorList = bar.anchorList or {}
	wipe(bar.anchorList)
    bar.anchorList["None"] = L["None"]
    bar.anchorList["Custom"] = L["Custom"]
    bar.anchorList["Bar"] = L["Bar"]
	if select(6, _G.GetAddOnInfo("CompactRunes")) ~= "MISSING" or 
		self.db.profile.bars[bar.name].anchorFrame == "Compact Runes" then
		bar.anchorList["Compact Runes"] = L["Compact Runes"]
	end
	return bar.anchorList
end

function ShieldTracker:GetBarList(barName)
	local bar = self.bars[barName]
	bar.barList = bar.barList or {}
	wipe(bar.barList)
	for name, obj in pairs(self.bars) do
		if name ~= bar.name and not bar.disableAnchor then
			bar.barList[name] = name
		end
	end
	return bar.barList
end

function ShieldTracker:GetLabelOptions(name)
	local bar = self.bars[name]
	local options = {
	    description = {
	        order = 501,
	        type = "description",
	        name = L["Label_Desc"],
		},
		generalHdr = {
			order = 510,
			type = "header",
			name = L["General Options"],
		},
        enabled = {
			order = 515,
            name = L["Enabled"],
            desc = L["Enabled"],
            type = "toggle",
            set = function(info, val)
                self.db.profile.bars[bar.name].label.enabled = val
				bar:UpdateLabel()
            end,
            get = function(info)
                return self.db.profile.bars[bar.name].label.enabled
            end,
        },
		textHdr = {
			order = 520,
			type = "header",
			name = L["Label"],
		},
		overrideText = {
			order = 525,
			name = L["Custom"],
			desc = L["Custom"],
			type = "toggle",
			set = function(info, val)
				self.db.profile.bars[bar.name].label.overrideText = val
				bar:UpdateLabel()
			end,
			get = function(info)
				return self.db.profile.bars[bar.name].label.overrideText
			end,
		},
		labelText = {
			order = 528,
			type = "input",
			name = L["Label"],
			desc = L["Label"],
			set = function(info, val)
				self.db.profile.bars[bar.name].label.text = val
				bar:UpdateLabel()
			end,
			get = function(info)
				return self.db.profile.bars[bar.name].label.text
			end,
			disabled = function()
				return not self.db.profile.bars[bar.name].label.overrideText
			end,
		},
		fontSizeHdr = {
			order = 530,
			type = "header",
			name = L["Font size"],
		},
		overrideFontSize = {
			order = 535,
			name = L["Custom"],
			desc = L["Custom"],
			type = "toggle",
			set = function(info, val)
				self.db.profile.bars[bar.name].label.overrideFontSize = val
				bar:UpdateLabel()
			end,
			get = function(info)
				return self.db.profile.bars[bar.name].label.overrideFontSize
			end,
			},
		fontSize = {
			order = 538,
			name = L["Font size"],
			desc = L["Font size"],
			type = "range",
			min = 8,
			max = 30,
			step = 1,
			set = function(info, val) 
				self.db.profile.bars[bar.name].label.fontSize = val
				bar:UpdateLabel()
			end,
			get = function(info,val) return self.db.profile.bars[bar.name].label.fontSize end,
			disabled = function()
				return not self.db.profile.bars[bar.name].label.overrideFontSize
			end,
		},
		anchorHdr = {
			order = 550,
			type = "header",
			name = L["Anchor"],
		},
		anchorPoint = {
			order = 560,
			name = L["Anchor Point"],
			desc = L["LabelAnchorPoint_OptDesc"],
			type = "select",
			values = {
			    ["TOP"] = L["Top"],
			    ["BOTTOM"] = L["Bottom"],
			    ["LEFT"] = L["Left"],
			    ["RIGHT"] = L["Right"],
				["CENTER"] = L["Center"],
			},
			set = function(info, val)
			    self.db.profile.bars[bar.name].label.anchorPoint = val
				bar:UpdateLabel()
			end,
	        get = function(info)
	            return self.db.profile.bars[bar.name].label.anchorPoint
	        end,
			disabled = function()
				return not self.db.profile.bars[bar.name].label.enabled
			end,
		},
		anchorX = {
			order = 570,
			name = L["X Offset"],
			desc = L["XOffsetAnchor_Desc"],	
			type = "range",
			softMin = -floor(_G.GetScreenWidth()),
			softMax = floor(_G.GetScreenWidth()),
			bigStep = 1,
			set = function(info, val)
			    self.db.profile.bars[bar.name].label.anchorX = val
				bar:UpdateLabel()
			end,
			get = function(info, val)
			    return self.db.profile.bars[bar.name].label.anchorX
			end,
			disabled = function()
				return not self.db.profile.bars[bar.name].label.enabled
			end,
		},
		anchorY = {
			order = 580,
			name = L["Y Offset"],
			desc = L["YOffsetAnchor_Desc"],	
			type = "range",
			softMin = -floor(_G.GetScreenHeight()),
			softMax = floor(_G.GetScreenHeight()),
			bigStep = 1,
			set = function(info, val)
			    self.db.profile.bars[bar.name].label.anchorY = val
				bar:UpdateLabel()
			end,
			get = function(info, val)
			    return self.db.profile.bars[bar.name].label.anchorY
			end,
			disabled = function()
				return not self.db.profile.bars[bar.name].label.enabled
			end,
		},
	}
	return options
end

function ShieldTracker:GetAdvancedPositioning(name)
	local bar = self.bars[name]
	local options = {
	    description = {
	        order = 1001,
	        type = "description",
	        name = L["Anchor_Desc"],
		},
		anchorFrame = {
			name = L["Anchor"],
			desc = L["Anchor_OptDesc"],
			type = "select",
			values = function()
				return self:GetAnchorList(bar.name)
			end,
			order = 1010,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorFrame = val
				bar:UpdatePosition()
			end,
	        get = function(info)
	            return self.db.profile.bars[bar.name].anchorFrame
	        end,
		},
		anchorBar = {
			name = L["Bar"],
			desc = L["AnchorBar_OptDesc"],
			type = "select",
			values = function()
				return self:GetBarList(bar.name)
			end,
			order = 1015,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorBar = val
				bar:UpdatePosition()
			end,
	        get = function(info)
	            return self.db.profile.bars[bar.name].anchorBar
	        end,
			disabled = function()
				return self.db.profile.bars[bar.name].anchorFrame ~= "Bar"
			end,
		},
		anchorFrameCustom = {
			name = L["Frame"],
			desc = L["Frame_OptDesc"],
			type = "input",
			width = "double",
			order = 1020,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorFrameCustom = val
				bar:UpdatePosition()
			end,
	        get = function(info)
	            return self.db.profile.bars[bar.name].anchorFrameCustom
	        end,
			disabled = function()
				return self.db.profile.bars[bar.name].anchorFrame ~= "Custom"
			end,
		},
		anchorFramePt = {
			name = L["Anchor Point"],
			desc = L["AnchorPoint_OptDesc"],
			type = "select",
			values = {
			    ["TOP"] = L["Top"],
			    ["BOTTOM"] = L["Bottom"],
			    ["LEFT"] = L["Left"],
			    ["RIGHT"] = L["Right"],
			},
			order = 1030,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorFramePt = val
				bar:UpdatePosition()
			end,
	        get = function(info)
	            return self.db.profile.bars[bar.name].anchorFramePt
	        end,
			disabled = function()
				return self.db.profile.bars[bar.name].anchorFrame == "None"
			end,
		},
		anchorPt = {
			name = L["Bar Point"],
			desc = L["BarPoint_OptDesc"],
			type = "select",
			values = {
			    ["TOP"] = L["Top"],
			    ["BOTTOM"] = L["Bottom"],
			    ["LEFT"] = L["Left"],
			    ["RIGHT"] = L["Right"],
			},
			order = 1040,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorPt = val
				bar:UpdatePosition()
			end,
	        get = function(info)
	            return self.db.profile.bars[bar.name].anchorPt
	        end,
			disabled = function()
				return self.db.profile.bars[bar.name].anchorFrame == "None"
			end,
		},
		anchorX = {
			order = 1050,
			name = L["X Offset"],
			desc = L["XOffsetAnchor_Desc"],	
			type = "range",
			softMin = -floor(_G.GetScreenWidth()),
			softMax = floor(_G.GetScreenWidth()),
			bigStep = 1,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorX = val
				bar:UpdatePosition()
			end,
			get = function(info, val)
			    return self.db.profile.bars[bar.name].anchorX
			end,
			disabled = function()
				return self.db.profile.bars[bar.name].anchorFrame == "None"
			end,
		},
		anchorY = {
			order = 1060,
			name = L["Y Offset"],
			desc = L["YOffsetAnchor_Desc"],	
			type = "range",
			softMin = -floor(_G.GetScreenHeight()),
			softMax = floor(_G.GetScreenHeight()),
			bigStep = 1,
			set = function(info, val)
			    self.db.profile.bars[bar.name].anchorY = val
				bar:UpdatePosition()
			end,
			get = function(info, val)
			    return self.db.profile.bars[bar.name].anchorY
			end,
			disabled = function()
				return self.db.profile.bars[bar.name].anchorFrame == "None"
			end,
		},
	}
	return options
end

local function splitWords(str)
  local w = {}
  local function helper(word) table.insert(w, word) return nil end
  str:gsub("(%w+)", helper)
  return w
end

function ShieldTracker:ChatCommand(input)
    if not input or input:trim() == "" then
        self:ShowOptions()
    else
		local cmds = splitWords(input)
        if cmds[1] and cmds[1] == "debug" then
			if cmds[2] and cmds[2] == "on" then
				self.db.profile.debug = true
	            self:Print("Debugging on.  Use '/stracker debug off' to disable.")
		    elseif cmds[2] and cmds[2] == "off" then
				self.db.profile.debug = false
	            self:Print("Debugging off.")
			else
				self:Print("Debugging is "..(self.db.profile.debug and "on." or "off."))
			end
		end
	end
end

function ShieldTracker:OnInitialize()
    -- Load the settings
    self.db = LibStub("AceDB-3.0"):New("ShieldTrackerDB", defaults, "Default")

	-- Set the number format
	self:SetNumberFormat(self.db.profile.numberFormat)

    -- Set the precision
    if self.db.profile.precision == "One" then
        millFmt = millFmtOne
        thousandFmt = thousandFmtOne
    else
        millFmt = millFmtZero
        thousandFmt = thousandFmtZero
    end

	icon:Register("ShieldTrackerLDB", Broker.obj, self.db.profile.minimap)
	LSM.RegisterCallback(ShieldTracker, "LibSharedMedia_Registered")

	self:SetSkin()

	-- Loop through the bars and create them
	for k, v in pairs(self.db.profile.bars) do
		Bar:Create(k)
	end
end

function ShieldTracker:OnEnable()
	self:Load()
	LoadSpellNames()
	self:CheckForOldUnitNames()

	if not self.optionsFrame then
	    local displayName = _G.GetAddOnMetadata(ADDON_NAME, "Title")
		local options = self:GetOptions()
	    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(displayName, options)

	    self.optionsFrame = {}
	    local ACD = LibStub("AceConfigDialog-3.0")
		self.optionsFrame.Main = ACD:AddToBlizOptions(
		    displayName, L["Shield Tracker"], nil)
		--self.optionsFrame.Bars = ACD:AddToBlizOptions(
		--    displayName, L["Bars"], displayName, "barOpts")
		LibStub("AceConfig-3.0"):RegisterOptionsTable("ShieldTracker-Profiles", 
			LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
		self.optionsFrame.Profiles = ACD:AddToBlizOptions(
		    "ShieldTracker-Profiles", L["Profiles"], L["Shield Tracker"])
	    self:RegisterChatCommand("shieldtracker", "ChatCommand")
	    self:RegisterChatCommand("stracker", "ChatCommand")
	end
end

local WatchedEvents = {
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"PLAYER_TARGET_CHANGED",
	"UNIT_AURA",
	"PLAYER_FOCUS_CHANGED",
	"GROUP_ROSTER_UPDATE",
}
function ShieldTracker:Load()
	for i = 1, #WatchedEvents do
		self:RegisterEvent(WatchedEvents[i])
	end
end

function ShieldTracker:Unload()
end

function ShieldTracker:OnDisable()
	for i = 1, #WatchedEvents do
		self:UnregisterEvent(WatchedEvents[i])
	end
end

function ShieldTracker:Reset()
	-- Reset positions
	for name,bar in pairs(self.bars) do
		bar.db = self.db.profile.bars[bar.name]
		bar:Reset()
	end
end

function ShieldTracker:GetFontSettings(name)
	local ff, fh, fontFlags
	local profile = self.db.profile
	local bar = self.bars[name]

    -- If a custom font is set, then override the settings
    if self.CustomUI.font then
        ff = self.CustomUI.font
    else
	    ff = LSM:Fetch("font", bar and bar.db.font_face or profile.font_face)
    end
    if self.CustomUI.fontSize and not (bar and bar.db.font_size) then
        fh = self.CustomUI.fontSize
    else
        fh = bar and bar.db.font_size or profile.font_size
    end
    if self.CustomUI.fontFlags then
        fontFlags = self.CustomUI.fontFlags
    else
        fontFlags = self:GetFontFlags()
    end

	return ff, fh, fontFlags
end

function ShieldTracker:GetFontFlags(name)
    local flags = {}
	local profile = self.db.profile
	local bar = self.bars[name]

    if bar and bar.db.font_outline or profile.font_outline then
        tinsert(flags, "OUTLINE")
    end
    if bar and bar.db.font_monochrome or profile.font_monochrome then
        tinsert(flags, "MONOCHROME")
    end
    if bar and bar.db.font_thickoutline or profile.font_thickoutline then
        tinsert(flags, "THICKOUTLINE")
    end
    return tconcat(flags, ",")
end

function ShieldTracker:LibSharedMedia_Registered(event, mediatype, key)
	self:Reset()
end

local function onUpdateTimer(self, elapsed)
	self.lastUpdate = (self.lastUpdate or 0) + elapsed
	self.timer = self.timer - elapsed
	if self.lastUpdate >= 0.1 then
		self.lastUpdate = 0
		if self.active then
			if self.timer < 0 then
				self.timer = 0
				self.active = false
				self:SetScript("OnUpdate", nil)
				self:Hide()
			else
				self:Show()
				self:SetValue(self.timer)
				if self.object.db.timeRemaining ~= "None" then
					self.time:SetText(round(self.timer))
				end
			end
		else
			self:Hide()
		end
	end
end

local function onUpdateTimerBasic(self, elapsed)
	self.lastUpdate = (self.lastUpdate or 0) + elapsed
	self.timer = self.timer - elapsed
	if self.lastUpdate >= 0.1 then
		self.lastUpdate = 0
		if self.active then
			if self.timer < 0 then
				self.timer = 0
				self.active = false
				self:SetScript("OnUpdate", nil)
				self:Hide()
			else
				self:Show()
			end
		else
			self:Hide()
		end
	end
end

local ShieldsFound = {}
local ExpiresFound = {}
local DurationFound = {}

function ShieldTracker:CheckAuras(unit)
	local unitName = GetUnitName(unit)
	if not self.watchedUnits[unit] and not self.watchedUnits[unitName] and
		not self.watchedGroupUnits[unitName] and
		not (self.watchingMouseover and self.mouseover == unitName) then
		return
	end

	local name, rank, icon, count, dispelType, duration, expires,
		caster, stealable, consolidate, spellId, canApplyAura, isBossDebuff,
		castByPlayer, new1, new2, value, value2

	local shields = ShieldsFound
	wipe(shields)

	local i = 1
	repeat
		name, rank, icon, count, dispelType, duration, expires, caster, stealable, 
		consolidate, spellId, canApplyAura, isBossDebuff, 
		castByPlayer, new1, new2, value, value2 = UnitAura(unit, i)
		if name == nil or spellId == nil then break end
		local lookup = SpellIdsRev[spellId]
		if lookup then
			shields[lookup] = (shields[lookup] or 0) + (UsesSecondValue[spellId] and value2 or value)
		end
		i = i + 1
	until name == nil

	i = 1
	repeat
		name, rank, icon, count, dispelType, duration, expires, caster, stealable, 
		consolidate, spellId, canApplyAura, isBossDebuff, 
		castByPlayer, new1, new2, value, value2 = UnitDebuff(unit, i)
		if name == nil or spellId == nil then break end
		local lookup = SpellIdsRev[spellId]
		if lookup then
			shields[lookup] = (shields[lookup] or 0) + (UsesSecondValue[spellId] and value2 or value)
		end
		i = i + 1
	until name == nil

	for barName, bar in pairs(self.bars) do
		if bar.db.enabled and (bar.unit == unit or 
			(bar.unit == unitName) or 
			(bar.unit == "mouseover" and unitName == self.mouseover)) then

			local totalValue = 0
			if UnitExists(unit) or UnitExists(unitName) then
				if bar.db.tracked == "All" then
					totalValue = _G.UnitGetTotalAbsorbs(bar.unit) or 0
				else
					for k, v in pairs(bar.db.tracking) do
						if k and v then
							totalValue = totalValue + (shields[k] or 0)
						end
					end
					if bar.db.tracked == "Excluding" then
						totalValue = (_G.UnitGetTotalAbsorbs(bar.unit) or 0) 
							- totalValue
					end
				end

				if totalValue > 0 or (bar.singleSpell and shields[bar.singleSpell]) then
					bar:SetValue(totalValue)
					bar.bar:Show()
					if bar.singleSpell then
				        name, rank, icon, count, dispelType, duration, 
						expires, caster, stealable, consolidate, spellId, 
						canApplyAura, isBossDebuff, castByPlayer, 
						new1, new2, value, value2
						= UnitAura(unit, SpellNames[bar.singleSpell])
						if not name then
					        name, rank, icon, count, dispelType, duration, 
							expires, caster, stealable, consolidate, spellId, 
							canApplyAura, isBossDebuff, castByPlayer, 
							new1, new2, value, value2
							= UnitDebuff(unit, SpellNames[bar.singleSpell])
						end
						if name then
							if duration and duration > 0 then
								bar.bar.active = true
								bar.bar.timer = expires - GetTime()
								local tracking = SpellTracking[spellId]
								if tracking == "secondValue" then
									bar.bar:SetMinMaxValues(0, value or 1)
									bar.bar:SetValue(value2 or 1)
									bar.bar:SetScript("OnUpdate", onUpdateTimerBasic)
								else
									bar.bar:SetMinMaxValues(0, duration)
									bar.bar:SetScript("OnUpdate", onUpdateTimer)
								end
							else
								bar.bar:SetMinMaxValues(0, 1)
								bar.bar:SetValue(1)
								bar.bar:SetScript("OnUpdate", nil)
							end
						end
					else
						bar.bar:SetMinMaxValues(0, 1)
						bar.bar:SetValue(1)
					end
				else
					bar.bar:Hide()
					bar.bar.active = false
					bar.bar.timer = 0
					bar.bar:SetScript("OnUpdate", nil)
				end
			else
				bar.bar:Hide()
				bar.bar.active = false
				bar.bar.timer = 0
				bar.bar:SetScript("OnUpdate", nil)
			end
		end
	end
end

function ShieldTracker:PLAYER_REGEN_DISABLED(event)
end

function ShieldTracker:PLAYER_REGEN_ENABLED(event)
end

function ShieldTracker:PLAYER_TARGET_CHANGED(event, unit)
	self:CheckAuras("target")
end

function ShieldTracker:PLAYER_FOCUS_CHANGED(event, unit)
	self:CheckAuras("focus")
end

function ShieldTracker:GROUP_ROSTER_UPDATE(event)
	for i, v in ipairs(self.currentRoster) do
		wipe(v)
	end
	local group = 0
	local unit = 0
	for i = 1, _G.GetNumGroupMembers() do
		local name, rank, subgroup = _G.GetRaidRosterInfo(i)
		if group ~= subgroup then
			group = subgroup
			unit = 1
		else
			unit = unit + 1
		end
		self.currentRoster[subgroup] = self.currentRoster[subgroup] or {}
		self.currentRoster[subgroup][unit] = name
	end
	self:UpdateWatchedGroupUnits()
end

function ShieldTracker:UpdateWatchedGroupUnits()
	wipe(self.watchedGroupUnits)
	for k, bar in pairs(self.bars) do
		if bar and bar.db.unit == "group" then
			local subgroup = bar.db.unitSubgroup or 0
			local unitindex = bar.db.unitIndex or 0
			local name = self.currentRoster[subgroup] and 
				self.currentRoster[subgroup][unitindex]
			if name then
				self.watchedGroupUnits[name] = true
				if bar.unit ~= name then
					bar.unit = name
					bar:Hide()
				end
			else
				bar.unit = nil
				bar:Hide()
			end
		end
	end
end

function ShieldTracker:UPDATE_MOUSEOVER_UNIT(event, unit)
	self.mouseover = GetUnitName("mouseover")
	if self.mouseover then
		self:CheckAuras("mouseover")
	else
		for k, v in pairs(self.mouseoverBars) do
			if k then
				k.bar:SetScript("OnUpdate", nil)
				k.bar.active = false
				k.bar:Hide()
			end
		end
	end
end

function ShieldTracker:CheckMouseover()
	self.watchingMouseover = 
		(self.watchedUnits["mouseover"] or 0) > 0 and true or false

	wipe(self.mouseoverBars)
	for k, v in pairs(self.bars) do
		if v and v.unit == "mouseover" then
			self.mouseoverBars[v] = true
		end
	end

	if self.watchingMouseover then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	else
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

function ShieldTracker:UNIT_AURA(event, unit)
	self:CheckAuras(unit)
end

function ShieldTracker:CheckForOldUnitNames()
	-- Check for the older Blizzard GetUnitName() format.  
	-- There should be no spaces around the dash between
	-- the player name and server name.
	local fmt = "Invalid unit name for bar '%s'."
	for name, bar in pairs(self.db.profile.bars) do
		if bar and bar.unitName then
			local check = bar.unitName:gmatch("[ ][-][ ]")
			if check and check() then
				self:Print(fmt:format(name or "nil"))
			end
		end
	end
end

local FrameNames = {
	["Compact Runes"] = "CompactRunes_RunicPowerBar",
}

local function IsFrame(frame)
	if frame and type(frame) == "string" then
		local f = _G.GetClickFrame(frame)
		if f and type(f) == "table" and f.SetPoint and f.GetName then
			return true
		end
	end
	return false
end

-- Define a generic class for the bars
Bar.__index = Bar

function Bar:Create(name, friendlyName, disableAnchor)
	if ShieldTracker.bars[name] then return end
    local object = _G.setmetatable({}, Bar)
	object.name = name
	object.friendlyName = friendlyName or name
	object.anchorTries = 0
	object.disableAnchor = disableAnchor
	local profile = ShieldTracker.db.profile
	object.db = profile.bars[object.name]
	object.watchingGroup = false
	if object.db.unit ~= "group" then
		object.unit = (object.db.unit == "named") and 
			object.db.unitName or object.db.unit
		ShieldTracker.watchedUnits[object.unit] = 
			(ShieldTracker.watchedUnits[object.unit] or 0) + 1
	else
		object.watchingGroup = true
	end
	object.singleSpell = nil
	ShieldTracker:CheckMouseover()
	-- Add the bar to the addon's table of bars
	ShieldTracker.bars[name] = object
	object:Initialize()
	object:UpdatePosition()
	object:CheckTracking()
	object:Skin()
	return object
end

function Bar:Initialize()
	self.frameName = "ShieldTracker_"..self.name
    local bar = _G.CreateFrame("StatusBar", self.frameName, _G.UIParent)
	self.bar = bar
	bar.object = self
	bar.active = false
	bar.timer = 0
    --bar:SetPoint("CENTER", _G.UIParent, "CENTER", self.db.x, self.db.y)
	bar:SetScale(self.db.scale)
    bar:SetOrientation("HORIZONTAL")
    bar:SetWidth(self.db.width)
    bar:SetHeight(self.db.height)
	local bt
    if ShieldTracker.CustomUI.texture then
        bt = ShieldTracker.CustomUI.texture
    else
	    bt = LSM:Fetch("statusbar", self.db.texture)
    end
    bar:SetStatusBarTexture(bt)
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
    local bc = self.db.color
    bar:SetStatusBarColor(bc.r, bc.g, bc.b, bc.a)
    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetTexture(bt)
    bar.bg:SetAllPoints(true)
    local bgc = self.db.bgcolor
    bar.bg:SetVertexColor(bgc.r, bgc.g, bgc.b, bgc.a)
    bar.border = bar:CreateTexture(nil, "BACKGROUND")
    bar.border:SetPoint("CENTER")
    bar.border:SetWidth(bar:GetWidth()+9)
    bar.border:SetHeight(bar:GetHeight()+8)
    bar.border:SetTexture("Interface\\Tooltips\\UI-StatusBar-Border")
	if not self.db.border or ShieldTracker.CustomUI.showBorders == false then
		bar.border:Hide()
	end
	local ff, fh, fontFlags = ShieldTracker:GetFontSettings(self.name)
    bar.value = bar:CreateFontString(nil, "OVERLAY")
    bar.value:SetPoint("CENTER")
    bar.value:SetFont(ff, fh, fontFlags)
    bar.value:SetJustifyH("CENTER")
    bar.value:SetShadowOffset(1, -1)
    local tc = self.db.textcolor
    bar.value:SetTextColor(tc.r, tc.g, tc.b, tc.a)
    bar.value:SetText("0")
    bar.lock = false

    bar.time = bar:CreateFontString(nil, "OVERLAY")
    bar.time:SetFont(ff, fh, fontFlags)
    bar.time:SetJustifyH(self.db.time_pos or "RIGHT")
    bar.time:SetShadowOffset(1, -1)
    bar.time:SetTextColor(tc.r, tc.g, tc.b, tc.a)
    bar.time:SetText("0")
	if self.db.timeRemaining == "None" then
	    bar.time:SetPoint("RIGHT")
	else
	    bar.time:SetPoint(self.db.timeRemaining or "RIGHT")
	end

    bar.label = bar:CreateFontString(nil, "OVERLAY")
    bar.label:SetJustifyH("CENTER")
    bar.label:SetShadowOffset(1, -1)
	self:UpdateLabel()

    bar:SetMovable(true)
    bar:RegisterForDrag("LeftButton")
    bar:SetScript("OnDragStart",
        function(self, button)
			if not self.lock then
            	self:StartMoving()
			end
        end)
    bar:SetScript("OnDragStop",
        function(self)
            self:StopMovingOrSizing()
			local scale = self:GetEffectiveScale() / _G.UIParent:GetEffectiveScale()
			local x, y = self:GetCenter()
			x, y = x * scale, y * scale
			x = x - _G.GetScreenWidth()/2
			y = y - _G.GetScreenHeight()/2
			x = x / self:GetScale()
			y = y / self:GetScale()
			self.object.db.x, self.object.db.y = x, y
			self:SetUserPlaced(false);
        end)
    bar:EnableMouse(true)
    bar:SetMinMaxValues(0, 1)
    bar:SetValue(1)
    bar:Hide()
	self:Lock(self.db.locked)
end

function Bar:UpdateLabel()
	local ff, fh, fontFlags = ShieldTracker:GetFontSettings(self.name)
	local fontSize = self.db.label.overrideFontSize and self.db.label.fontSize or fh
	self.bar.label:SetFont(ff, fontSize, fontFlags)
	local tc = self.db.textcolor
	self.bar.label:SetTextColor(tc.r, tc.g, tc.b, tc.a)
	self.bar.label:SetText(self.db.label.overrideText and self.db.label.text or self.friendlyName)

	local localAnchors = {
		["BOTTOM"] = "TOP",
		["RIGHT"] = "LEFT",
		["LEFT"] = "RIGHT",
		["TOP"] = "BOTTOM",
		["CENTER"] = "CENTER",
	}
	self.bar.label:ClearAllPoints()
	self.bar.label:SetPoint(localAnchors[self.db.label.anchorPoint] or "CENTER", self.bar, 
		self.db.label.anchorPoint, self.db.label.anchorX, self.db.label.anchorY)
	if self.db.label.enabled then
		self.bar.label:Show()
	else
		self.bar.label:Hide()
	end
end

function Bar:Lock(locked)
	if locked == nil then
		locked = self.db.locked
	end

	self.bar.lock = locked
    if locked then
        self.bar:EnableMouse(false)
    else
        self.bar:EnableMouse(true)
    end
end

function Bar:Hide()
	self.bar:Hide()
end

function Bar:Remove()
	ShieldTracker.watchedUnits[self.unit] = 
		(ShieldTracker.watchedUnits[self.unit] or 0) + 1
	ShieldTracker.db.profile.bars[self.name] = nil
	ShieldTracker.bars[self.name] = nil
	ShieldTracker:CheckMouseover()
	self.bar:Hide()
end

function Bar:UpdateUnit()
	local oldUnit = self.unit
	if oldUnit and not self.watchingGroup then
		ShieldTracker.watchedUnits[oldUnit] = 
			(ShieldTracker.watchedUnits[oldUnit] or 0) - 1
		if ShieldTracker.watchedUnits[oldUnit] < 1 then
			ShieldTracker.watchedUnits[oldUnit] = nil
		end
	end

	if self.db.unit ~= "group" then
		local newUnit = (self.db.unit == "named") and 
			self.db.unitName or self.db.unit
		self.unit = newUnit
		self.watchingGroup = false
		ShieldTracker.watchedUnits[newUnit] = 
			(ShieldTracker.watchedUnits[newUnit] or 0) + 1
	else
		self.watchingGroup = true
	end

	ShieldTracker:CheckMouseover()
	ShieldTracker:UpdateWatchedGroupUnits()
end

function Bar:CheckTracking()
	local tracked, spell = 0, nil
	if self.db.tracked == "Selected" then
		for k, v in pairs(self.db.tracking) do
			if k and v then
				tracked = tracked + 1
				spell = k
			end
		end
	end

	if self.db.tracked == "Selected" and tracked == 1 then
		self.singleSpell = spell
		if self.db.timeRemaining == "None" then
			self.bar.time:Hide()
		else
			self.bar.time:Show()
		end
	else
		self.bar.time:Hide()
		self.singleSpell = nil
	end
end

function Bar:SetValue(value)
	if self.db.enabled then
		self.bar.value:SetText(FormatNumber(value))
	end
end

function Bar:Reset()
	self:Lock()
	self:UpdatePosition()
	self:UpdateTexture()
	self:UpdateBorder()
	self:UpdateVisibility()
	self:UpdateGraphics()
	self:CheckTracking()
end

function Bar:Skin()
    local Tukui = _G.Tukui
    local ElvUI = _G.ElvUI

    if (ElvUI and ShieldTracker.db.profile.skinning.elvui.enabled) or
		(Tukui and ShieldTracker.db.profile.skinning.tukui.enabled) then
		self:Reset()
	end
end

function Bar:UpdatePosition()
	local anchorFrame = FrameNames[self.db.anchorFrame]
	if not anchorFrame and self.db.anchorFrame == "Custom" then
		anchorFrame = self.db.anchorFrameCustom
	elseif self.db.anchorFrame == "Bar" then
		local bar = ShieldTracker.bars[self.db.anchorBar]
		if bar then
			anchorFrame = bar.frameName
		end
	end

	self.bar:ClearAllPoints()

	local isFrame = IsFrame(anchorFrame)
	local ST = ShieldTracker
	if anchorFrame and isFrame then
		if ST.db.profile.debug then
			ST:Print("Found anchor for bar '"..tostring(self.name).."'.")
		end
		self.bar:SetPoint(
			self.db.anchorPt, anchorFrame, self.db.anchorFramePt, 
			self.db.anchorX, self.db.anchorY)
		self.anchorTries = 0
	else
		self.bar:SetPoint("CENTER", _G.UIParent, "CENTER", self.db.x, self.db.y)
		if anchorFrame and not isFrame and self.anchorTries < 13 then
			if ST.db.profile.debug then
				ST:Print("Waiting for anchor for bar '"..tostring(self.name).."'.")
			end
	    	ST:ScheduleTimer(Bar.UpdatePosition, 5, self)
			self.anchorTries = (self.anchorTries or 0) + 1
		else
			self.anchorTries = 0
		end
	end
end

function Bar:ResetFonts()
	local ff, fh, fontFlags = ShieldTracker:GetFontSettings(self.name)
	self.bar.value:SetFont(ff, fh, fontFlags)						
	self.bar.value:SetText(self.bar.value:GetText())
	self.bar.time:SetFont(ff, fh, fontFlags)
	self.bar.time:SetText(self.bar.time:GetText())
end

function Bar:UpdateVisibility()
	local show = self.db.shown
	if not show then
		self.bar:SetStatusBarTexture("")
		self.bar.bg:SetTexture("")
		self.bar.border:Hide()
	else
		self:UpdateTexture()
		self:UpdateBorder()
	end
end

function Bar:UpdateBorder()
    local bar = self.bar
	if bar then
	    if ShieldTracker.CustomUI.showBorders ~= nil then
	        if ShieldTracker.CustomUI.showBorders == true then
	            bar.border:Show()
            else
                bar.border:Hide()
            end
        else
    		if self.db.border then
    			bar.border:Show()
    		else
    			bar.border:Hide()
    		end
		end

	    local Tukui = _G.Tukui and ShieldTracker.db.profile.skinning.tukui.enabled
	    local ElvUI = _G.ElvUI and ShieldTracker.db.profile.skinning.elvui.enabled
		if Tukui or ElvUI then
			bar:CreateBackdrop()
		end
	end
end

function Bar:UpdateTexture()
	if not self.db.shown then
		return
	end

	local bt
    if ShieldTracker.CustomUI.texture then
        bt = ShieldTracker.CustomUI.texture
    else
	    bt = LSM:Fetch("statusbar", self.db.texture)
    end
	self.bar:SetStatusBarTexture(bt)
	self.bar.bg:SetTexture(bt)
    self.bar:GetStatusBarTexture():SetHorizTile(false)
    self.bar:GetStatusBarTexture():SetVertTile(false)
	self:UpdateGraphics()
end

function Bar:UpdateGraphics()
    local bc, bgc, tc

	if self.altcolor then
	    bc = self.db.alt_color
	    bgc = self.db.alt_bgcolor
	    tc = self.db.alt_textcolor
	else
	    bc = self.db.color
	    bgc = self.db.bgcolor
	    tc = self.db.textcolor
	end

    self.bar:SetStatusBarColor(bc.r, bc.g, bc.b, bc.a)
    self.bar.bg:SetVertexColor(bgc.r, bgc.g, bgc.b, bgc.a)
    self.bar.value:SetTextColor(tc.r, tc.g, tc.b, tc.a)

    if self.db.timeRemaining == "None" then
	    self.bar.time:SetPoint("RIGHT")
    else
		self.bar.time:SetPoint(self.db.timeRemaining or "RIGHT")
    end
    self.bar.time:SetTextColor(tc.r, tc.g, tc.b, tc.a)
end
