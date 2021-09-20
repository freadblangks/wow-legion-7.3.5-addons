local _G = _G

-- addon name and namespace
local ADDON, NS = ...

local Addon = LibStub("AceAddon-3.0"):GetAddon(ADDON)

-- the Tooltip module
local Tooltip = Addon:NewModule("Tooltip")

-- tooltip library
local QT = LibStub:GetLibrary("LibQTip-1.0")

-- get translations
local L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(ADDON)

-- local functions
local ipairs   = ipairs
local pairs    = pairs
local strlower = strlower
local strfind  = strfind
local tinsert  = table.insert
local tsort    = table.sort

-- local variables
local _

local tooltip = nil

local sortedNames = {}
local lookupNameToId = {}

-- callbacks
local function ToggleText(cell, arg, button)
	local class = nil
	local type  = nil
	
	if arg[Addon.CLASS_MESSAGE] then
		class = Addon.CLASS_MESSAGE
		type  = arg[class]
	elseif arg[Addon.CLASS_CHANNEL] then
		class = Addon.CLASS_CHANNEL
		type  = arg[class]
	end
	
	if type then
		local options = Addon:GetModule("Options")
		
		if options then
			options:ToggleText(class, type)
		
			Tooltip:Refresh()
		end
	end
end

local function ToggleSound(cell, arg, button)
	local class = nil
	local type  = nil
	
	if arg[Addon.CLASS_MESSAGE] then
		class = Addon.CLASS_MESSAGE
		type  = arg[class]
	elseif arg[Addon.CLASS_CHANNEL] then
		class = Addon.CLASS_CHANNEL
		type  = arg[class]
	end

	if type then
		local options = Addon:GetModule("Options")
		
		if options then
			options:ToggleSound(class, type)
		
			Tooltip:Refresh()
		end
	end
end

-- module handling
function Tooltip:OnInitialize()
	-- empty
end

function Tooltip:OnEnable()
	-- empty
end

function Tooltip:OnDisable()
	self:Remove()
end

function Tooltip:Create(obj, autoHideDelay)
	if not self:IsEnabled() then
		return
	end

	autoHideDelay = autoHideDelay and autoHideDelay or 0.1

	tooltip = QT:Acquire(ADDON.."TT", 3)
	
	tooltip:Hide()
	tooltip:Clear()
	tooltip:SetScale(1)
		
	self:Draw()

	tooltip:SetAutoHideDelay(autoHideDelay, obj)
	tooltip:EnableMouse()
	tooltip:SmartAnchorTo(obj)
	tooltip:Show()
end

function Tooltip:Remove()
	if tooltip then
		tooltip:Hide()
		QT:Release(tooltip)
		tooltip = nil
	end
end

function Tooltip:Refresh()
	if not self:IsEnabled() then
		self:Remove()
		return
	end
	
	self:Draw()
	
	tooltip:Show()
end

function Tooltip:Draw()
	if not tooltip then
		return
	end

	tooltip:Hide()
	tooltip:Clear()
	
	local options = Addon:GetModule("Options")
	
	if not options then
		return
	end
	
	-- module header
	local lineNum = tooltip:AddHeader(" ")
	tooltip:SetCell(lineNum, 1, NS:Colorize("White", L[Addon.FULLNAME] ), "CENTER", tooltip:GetColumnCount())
	tooltip:AddLine(" ")
	
	-- events header
	lineNum = tooltip:AddLine(" ")
	tooltip:SetCell(lineNum, 1, NS:Colorize("Yellow", L["Message"]), "LEFT")
	tooltip:SetCell(lineNum, 2, NS:Colorize("Yellow", L["Text"]),    "LEFT")
	tooltip:SetCell(lineNum, 3, NS:Colorize("Yellow", L["Sound"]),   "LEFT")
	
    local chatType
    local textStatus
    local soundStatus

	NS:ClearTable(sortedNames)
	NS:ClearTable(lookupNameToId)
	
    for id, _ in pairs(Addon.events) do
		sortedNames[#sortedNames+1] = L[id]
		lookupNameToId[L[id]] = id
	end
	
	tsort(sortedNames)
	
    for _, name in ipairs(sortedNames) do
		local id = lookupNameToId[name]
		local text  = options:GetText(Addon.CLASS_MESSAGE, id)
		local sound = options:GetSound(Addon.CLASS_MESSAGE, id)

		chatType = Addon:ColorizeTextLikeChatUI(Addon.CLASS_MESSAGE, Addon:GetExampleEventByType(id), name..":")
		
		if text == 1 then 
			textStatus = NS:Colorize("Green", L["enabled"])
		elseif text == 2 then 
			textStatus = NS:Colorize("Yellow", L["filtered"])
		else 
			textStatus = NS:Colorize("Red", L["disabled"])
		end
		if sound == 1 then 
			soundStatus = NS:Colorize("Green", L["enabled"])
		elseif sound == 2 then 
			soundStatus = NS:Colorize("Yellow", L["filtered"])
		else 
			soundStatus = NS:Colorize("Red", L["disabled"])
		end

		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, chatType,    "LEFT")
		tooltip:SetCell(lineNum, 2, textStatus,  "LEFT")
		tooltip:SetCell(lineNum, 3, soundStatus, "LEFT")
		
		-- toggle states via tooltip
		tooltip:SetCellScript( lineNum, 2, "OnMouseDown", ToggleText,  {[Addon.CLASS_MESSAGE] = id})
		tooltip:SetCellScript( lineNum, 3, "OnMouseDown", ToggleSound, {[Addon.CLASS_MESSAGE] = id})
    end
	tooltip:AddLine(" ")

	-- channels header
	lineNum = tooltip:AddLine(" ")
	tooltip:SetCell(lineNum, 1, NS:Colorize("Yellow", L["Channel"]), "LEFT")
	tooltip:SetCell(lineNum, 2, NS:Colorize("Yellow", L["Text"]   ), "LEFT")
	tooltip:SetCell(lineNum, 3, NS:Colorize("Yellow", L["Sound"]  ), "LEFT")

	NS:ClearTable(sortedNames)
	NS:ClearTable(lookupNameToId)
	
	for id = 1, Addon.MAXALERTCHANNELS do
		local name = Addon:GetChannelName(id)
		if name then
			sortedNames[#sortedNames+1] = name
			lookupNameToId[name] = id
		end
	end

    for _, name in ipairs(sortedNames) do	
		local text  = options:GetText(Addon.CLASS_CHANNEL, name)
		local sound = options:GetSound(Addon.CLASS_CHANNEL, name)

		chatType = Addon:ColorizeTextLikeChatUI(Addon.CLASS_CHANNEL, lookupNameToId[name], tostring(lookupNameToId[name]) .. ". " .. name .. ":")
		
		if text == 1 then 
			textStatus = NS:Colorize("Green", L["enabled"])
		elseif text == 2 then 
			textStatus = NS:Colorize("Yellow", L["filtered"])
		else 
			textStatus = NS:Colorize("Red", L["disabled"])
		end
		if sound == 1 then 
			soundStatus = NS:Colorize("Green", L["enabled"])
		elseif sound == 2 then 
			soundStatus = NS:Colorize("Yellow", L["filtered"])
		else 
			soundStatus = NS:Colorize("Red", L["disabled"])
		end

		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, chatType,    "LEFT")
		tooltip:SetCell(lineNum, 2, textStatus,  "LEFT")
		tooltip:SetCell(lineNum, 3, soundStatus, "LEFT")

		-- toggle states via tooltip
		tooltip:SetCellScript(lineNum, 2, "OnMouseDown", ToggleText,  {[Addon.CLASS_CHANNEL] = name})
		tooltip:SetCellScript(lineNum, 3, "OnMouseDown", ToggleSound, {[Addon.CLASS_CHANNEL] = name})
	end
	
	-- hint to show options
	if not options:GetSetting("HideHint") then
		tooltip:AddLine(" ")
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Brownish", L["Right-Click"] .. ":") .. " " .. NS:Colorize("Yellow", L["Open option menu."] ), "LEFT", tooltip:GetColumnCount())
		lineNum = tooltip:AddLine(" ")
		tooltip:SetCell(lineNum, 1, NS:Colorize("Brownish", L["Left-Click Tip"] .. ":") .. " " .. NS:Colorize("Yellow", L["Toggle selected setting."] ), "LEFT", tooltip:GetColumnCount())
	end
	
end

-- test
function Tooltip:Debug(msg)
	Addon:Debug("(Tooltip) " .. msg)
end
