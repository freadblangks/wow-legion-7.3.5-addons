-- EmoteCenter by Graçi revamp of EmoteLDB by Cilraaz/Allisu of Rexxar-US

-- Basic addon info
local addonName, addon = ...

EmoteCenter = LibStub("AceAddon-3.0"):NewAddon("EmoteCenter")


-- Initialize localization
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local locale = GetLocale()

-- Set up environment variables
local _G = getfenv(0)

local string = _G.string
local pairs = _G.pairs
local gsub = string.gsub

local emoteVer = ""

-- Debug setting
addon.debug = false

-- Declare Libs
local self = EmoteCenter
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local QTC = LibStub('LibQTip-1.0')
local icon = LibStub("LibDBIcon-1.0")

-- Frame
local tooltip
local options
local frame = CreateFrame("Frame")
local EmoteCenterObj

local menuLevel = 1
local infoArray = {}


--debugging
local processingEmote = 0
local debugEmoteNum = 0
local maxEmoteNum = 453

--scroll
local tooltipLinesMin = 5
local tooltipMaxHeight = 500
local cellMaxWidth = 500

-- DB Defaults
local defaults = {
	profile = {
		showSlashCommand = true,
		showFlag = true,
		hideDetails = true,
	},
	global = {
		LibDBIcon = { hide = false },
		fav = {},
		locals = {},
	}
}

-- Local Functions
function EmoteCenter:ResetOptions()
	self.db = defaults
end


function EmoteCenter:GetEmoteText(k, target, genderCode)
	local emoteText

	local genderHe = nil
	local genderHis = nil
	local genderhe = nil
	local genderhis = nil
	if (genderCode == 2) then -- male
		genderHe = L["He"]
		genderHis = L["His"]
		genderhe = L["he"]
		genderhis = L["his"]
	else -- female (we hope)
		genderHe = L["She"]
		genderHis = L["Her"]
		genderhe = L["she"]
		genderhis = L["her"]
	end

	if (target) then 
		emoteText = gsub(L[k.."_TARGET"],"<Target>", target)
	else 
		emoteText = L[k]
	end

	emoteText = gsub(emoteText,"<He>",genderHe)
	emoteText = gsub(emoteText,"<His>",genderHis)
	emoteText = gsub(emoteText,"<he>",genderhe)
	emoteText = gsub(emoteText,"<his>",genderhis)

	return emoteText
end

function EmoteCenter:GetOnDemandText(k, v, target, genderCode)
	local color
	local flag = nil
	local returnCode
	local emoteText = EmoteCenter:GetEmoteText(k, target, genderCode)

	if (EC_React[v.react] == "") then -- None
		color = "fffefefe"
	elseif (EC_React[v.react] == "A") then -- Animated, Purple
		color = "ffa335ee"
		flag = L["A"]
	elseif (EC_React[v.react] == "V") then -- Voice, Orange
		color = "ffff8000"
		flag = L["V"]
	elseif (EC_React[v.react] == "AV") then -- Both, Green
		color = "ff1eff00"
		flag = L["AV"]
	else -- Shouldn't happen, Grey
		color = "ff9d9d9d"
	end

	returnCode = "|c" .. color .. emoteText .. FONT_COLOR_CODE_CLOSE
	return returnCode, flag
end


function HandleEmoteClick(_, k)
	if (k) then
		local shift = IsShiftKeyDown();
		if (shift) then -- manage favorite
			if (not self.db.global.fav) then
				self.db.global.fav = {}
			end
			local fav = self.db.global.fav
			if (fav[k]) then -- remove from favorite
				print(fav[k]..L[" removed from favorites."])
				fav[k] = nil
				if (menuLevel <= 1) then  -- reload the tooltip
					EmoteCenter:ShowMenu(nil, menuLevel, nil)
				end
			else -- add to favorite
				fav[k] = infoArray[k].slash
				print(fav[k]..L[" added to favorites."])
			end
			
		else -- do emote
			if (EC_Emotes[k].custom == 1) then -- Custom emote
				local emoteText = EmoteCenter:GetEmoteText(k, UnitName("target"), UnitSex("player"))
				
				EmoteCenterObj.text = k
				EmoteCenterObj.k = k
				SendChatMessage(emoteText,"EMOTE")
				HideTooltip()
			else
				emoteToken = _G["EMOTE" .. EC_Emotes[k].num .. "_TOKEN"]
				EmoteCenterObj.text = _G["EMOTE" .. EC_Emotes[k].num .. "_CMD1"]
				EmoteCenterObj.k = k
				DoEmote(emoteToken);
				HideTooltip()
			end
		end
	end
end

-- Handler Function
function HandlerFunc(_, name, button, ...)
	debugPrint("name = " .. name)
	if name == "menu" then -- go back to main menu
		menuLevel = 1
		infoArray = {}

	elseif name == "locals" then -- generate the locals list for debugging purpose
		-- you have to clic once per Emote
		if (debugEmoteNum == 0) then
			frame:RegisterEvent("CHAT_MSG_TEXT_EMOTE");
			frame:SetScript("OnEvent", EmoteCenter_OnEmoteEvent)
		end
		if (debugEmoteNum == maxEmoteNum) then
			frame:UnregisterEvent("CHAT_MSG_TEXT_EMOTE");
			debugEmoteNum = 0
		else
			local token
			while(not token and debugEmoteNum < maxEmoteNum ) do 
				if (processingEmote == 0) then
					debugEmoteNum = debugEmoteNum + 1
				end
				token = _G["EMOTE"..debugEmoteNum.."_TOKEN"]
				print("SEND : test token ", debugEmoteNum)
			end
			if (token and token ~= "UNUSED" and token ~= "SIT" and token ~= "STAND" and token ~= "TRAIN" and token ~="MOUNTSPECIAL" and token ~="READ" and (token ~="PROMISE" or UnitName("target"))) then
				processingEmote = 1
				print ("SEND : found token ", token)
				DoEmote(token);
				-- give hand to EmoteCenter_OnEvent
			end
		end

	
	else  -- build the emote list
		local hasTarget = UnitName("target")
		local genderCode = UnitSex("player")
		
		for k, v in pairs(EC_Emotes) do
			for k2, v2 in pairs(v.types) do
				if (name == v2) then
					local emoteText, flag = EmoteCenter:GetOnDemandText(k, v, hasTarget, genderCode)

					if (v.custom == 1) then
						slshCmd = L["Custom"]
					else
						slshCmd = _G["EMOTE" .. EC_Emotes[k].num .. "_CMD1"]
					end
			
					infoArray[k] = {["desc"] = emoteText, ["flag"] = flag, ["slash"] = slshCmd, }
				end
			end
		end
		menuLevel = 2
	end
	EmoteCenter:ShowMenu(infoArray, menuLevel, name)
end

function EmoteCenter_OnEmoteEvent(_, event, message, sender)
	if (sender == UnitName("player")) then
		--save the message
		local token = _G["EMOTE"..debugEmoteNum.."_TOKEN"];
		local slash = _G["EMOTE"..debugEmoteNum.."_CMD1"];
		print("RECEIVE : token: ", token, " slash: ", slash, " target: ", UnitName("target"), " message: ", message)
		if (not self.db.global.locals) then
			self.db.global.locals = {}
		end
		if (not self.db.global.locals[locale]) then
			self.db.global.locals[locale] = {["Description"] = {}, ["WithTarget"] = {}}
		end
		if (UnitName("target")) then
			self.db.global.locals[locale]["WithTarget"][token] = string.gsub(string.gsub(message, UnitName("target"), "<Target>"), "|2", "de")
		else
			self.db.global.locals[locale]["Description"][token] = message
		end
		processingEmote = 0
	end
end





-- Startup
EmoteCenterObj = ldb:NewDataObject("EmoteCenter", {
		type = "data source",
		icon = "Interface\\ICONS\\Spell_Misc_EmotionHappy.blp",
		label = L["EmoteCenter"],
		text = L["Last Emote Used"],
	})
	
function EmoteCenter:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("EmoteCenterDB", defaults)
	self.options = EmoteCenter_GetOptions()
	self.default = function() return addon:ResetOptions() end

	LibStub("AceConfig-3.0"):RegisterOptionsTable(self.name, self.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(self.name, L["EmoteCenter"], nil)

	icon:Register("EmoteCenter", EmoteCenterObj, self.db.global.LibDBIcon) -- Minimap
	icon:Show("EmoteCenter")
	if self.db.global.LibDBIcon.hide then
		icon:Hide("EmoteCenter")
	end
end

-- Tooltip
function HideTooltip()
	if not tooltip then return end
	if MouseIsOver(tooltip) then return end
--	tooltip:SetScript("OnLeave", nil)
	QTC:Release(tooltip)
	tooltip = nil
	self.tooltip = nil
	infoArray = {}
	menuLevel = 0
end

function EmoteCenterObj.OnEnter(self)
	menuLevel = 0
	EmoteCenter:ShowTooltip(self, menuLevel)
end

function EmoteCenterObj.OnLeave(self)
	HideTooltip()
end

function EmoteCenterObj.ToggleMenu(self)
	if (not tooltip) then
		menuLevel = 1
		EmoteCenter:ShowTooltip(self, menuLevel)
	else
		HideTooltip()
	end
end

function EmoteCenterObj.OnClick(self, button)
	emoteToUse = EmoteCenterObj.k
	if (button == "LeftButton") then
		if EmoteCenterObj.text == L["Last Emote Used"] then 
			EmoteCenterObj.ToggleMenu(self)
		return 
		end
		HandleEmoteClick(_, emoteToUse)
	elseif (button == "RightButton") then
		EmoteCenterObj.ToggleMenu(self)
	else
		debugPrint(button.." clicked")
	end
end

function EmoteCenter:ShowTooltip(self, menuLevel)
	tooltip = QTC:Acquire("EmoteCenterTooltip", 3, "LEFT", "LEFT", "LEFT")
	self.tooltip = tooltip
	tooltip:SmartAnchorTo(self)
	tooltip:SetAutoHideDelay(0.5, self)  
	EmoteCenter:ShowMenu(nil, menuLevel, nil)
end

function EmoteCenter:ShowMenu(info, menuLevel, menu)
	tooltip:Clear()
--	tooltip:SetScale(1)

	-- Display Header in tooltip
	local y = tooltip:AddHeader()
	tooltip:SetCell(y, 1, L["EmoteCenter"], nil, nil, 2)
	if (menuLevel > 0) then -- version
		tooltip:SetCell(y, 3, format("%s", "|c00FF00FF" .. emoteVer), nil, "RIGHT")
	end

	if (menuLevel == 0) then -- favorites
		local fav = self.db.global.fav
		for k, slash in pairs(fav) do
			y = tooltip:AddLine()
			tooltip:SetCell(y, 1, slash)
			tooltip:SetLineScript(y, "OnMouseDown", HandleEmoteClick, k)
		end

	elseif (menuLevel == 1) then -- menu

		tooltip:AddSeparator()
		
		-- Display initial menu
		for i, v in ipairs(EC_Types) do
			y = tooltip:AddLine()
			tooltip:SetCell(y, 1, " + " .. L[v], nil, nil, 3)
			tooltip:SetLineScript(y, "OnMouseDown", HandlerFunc, i)
		end

		tooltip:AddSeparator()

		-- Display favorites
		
		y = tooltip:AddLine()
		tooltip:SetCell(y, 1, L["Favorites"], nil, nil, 3)

		local fav = self.db.global.fav
		local hasTarget = UnitName("target")
		local genderCode = UnitSex("player")
		y = tooltip:AddLine()
		tooltip:SetCell(y, 1, L["Shift-Click on an emote to add to or remove from favorites."], nil, nil, 3)
		for k, slash in pairs(fav) do
			y = tooltip:AddLine()
			if (self.db.profile.showSlashCommand) then
				tooltip:SetCell(y, 1, slash)
			end
			local emoteText, flag = EmoteCenter:GetOnDemandText(k, EC_Emotes[k], hasTarget, genderCode)
			if (self.db.profile.showFlag) then
				tooltip:SetCell(y, 2, flag)
			end
			tooltip:SetCell(y, 3, emoteText, nul, nil, nil, nil, nil, nil, cellMaxWidth)
			tooltip:SetLineScript(y, "OnMouseDown", HandleEmoteClick, k)
		end

		if (addon.debug) then
			tooltip:AddSeparator()
			-- Count total emotes if debugging
			local emoteCount = 0
			for k, v in pairs(EC_Emotes) do
				if ( v.custom == 0 ) then
					emoteCount = emoteCount + 1
				end
			end

			tooltip:AddLine(" ")
			y = tooltip:AddLine()
			tooltip:SetCell(y, 1, "Total Emotes: " .. format(" %d", emoteCount), nil, nil, 3)

			y = tooltip:AddLine()
			tooltip:SetCell(y, 1, "Generate locals, one clic per Emote. do it once with a target, then once without", nil, nil, 3)
			tooltip:SetLineScript(y, "OnMouseDown", HandlerFunc, "locals")
			y = tooltip:AddLine()
			if (debugEmoteNum == maxEmoteNum) then
				tooltip:SetCell(y, 3, "Done")
			else
				tooltip:SetCell(y, 3, format("%d/%d", debugEmoteNum, maxEmoteNum))
			end
		end
		
	elseif (menuLevel == 2) and (info) then
		-- menu title
		y = tooltip:AddHeader()
		tooltip:SetCell(y, 1, " - "..L[EC_Types[menu]], nil, nil, 3)
		tooltip:SetLineScript(y, "OnMouseDown", HandlerFunc, "menu")

		tooltip:AddSeparator()
		
		local count = 0
		for k, v in pairs(info) do
			y = tooltip:AddLine()
			if (self.db.profile.showSlashCommand) then
				tooltip:SetCell(y, 1, v.slash)
			end
			if (self.db.profile.showFlag) then
				tooltip:SetCell(y, 2, v.flag)
			end
			tooltip:SetCell(y, 3, v.desc, nul, nil, nil, nil, nil, nil, cellMaxWidth)
			tooltip:SetLineScript(y, "OnMouseDown", HandleEmoteClick, k)
			count = count + 1
		end

		if (count < tooltipLinesMin) then
			-- Add filler lines
			local fillerLines = tooltipLinesMin - count
			for i=1,fillerLines do
				tooltip:AddLine(" ")
			end
		end
	else
		HideTooltip()
		return
	end

	tooltip:UpdateScrolling(tooltipMaxHeight)
	tooltip:Show()
end




function debugPrint(text)
	if (addon.debug) then
		DEFAULT_CHAT_FRAME:AddMessage(text)
	end
end
