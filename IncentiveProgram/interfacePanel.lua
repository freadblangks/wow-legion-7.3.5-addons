-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

local function setSetting(element, value)
	if not element.settingKey then return false end

	if element.userSetting then
		IncentiveProgram:GetSettings():SetUserSetting(element.settingKey, value)
	elseif element.dungeonSetting and element.dungeonID then
		
	else
		IncentiveProgram:GetSettings():SetSetting(element.settingKey, value)
	end
	
	IncentiveProgram:GetFrame():UpdatedSettings()
	IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()) --Refresh Count
	InterfaceOptionsOptionsFrame_RefreshAddOns()
end

local function getSetting(element)
	if not element.settingKey then return false end
	
	if element.userSetting then
		return IncentiveProgram:GetSettings():GetUserSetting(element.settingKey)
	elseif element.dungeonSetting and element.dungeonID then
	
	else
		return IncentiveProgram:GetSettings():GetSetting(element.settingKey)
	end
	
	return false
end

local function checkButtonOnClick(self, button)
	if self.buttonList then
		for _, b in pairs(self.buttonList) do
			if b == self then
				self:SetChecked(true)
				setSetting(self, self.value)
			else
				b:SetChecked(false)
			end
		end
	else
		setSetting(self, self:GetChecked())
		self:SetChecked(getSetting(self))
	end
end

local function loadSettings(panel)
	--Roles
	panel.rolesTank:SetChecked(getSetting(panel.rolesTank))
	panel.rolesHealer:SetChecked(getSetting(panel.rolesHealer))
	panel.rolesDamage:SetChecked(getSetting(panel.rolesDamage))
	
	--General Settings
	panel.generalHideInParty:SetChecked(getSetting(panel.generalHideInParty))
	panel.generalHideAlways:SetChecked(getSetting(panel.generalHideAlways))
	panel.generalHideEmpty:SetChecked(getSetting(panel.generalHideEmpty))
	panel.generalAlert:SetChecked(getSetting(panel.generalAlert))
	panel.generalAlertToast:SetChecked(getSetting(panel.generalAlertToast))
	panel.generalIgnoreCompletedLFR:SetChecked(getSetting(panel.generalIgnoreCompletedLFR))
	
	--Sounds
	panel.soundsAlertPing:SetChecked(getSetting(panel.soundsAlertPing))
	panel.soundsAlertSound:SetText(getSetting(panel.soundsAlertSound))
	panel.soundsAlertRepeats:SetText(getSetting(panel.soundsAlertRepeats))
	panel.soundsToastPing:SetChecked(getSetting(panel.soundsToastPing))
	panel.soundsToastSound:SetText(getSetting(panel.soundsToastSound))
	panel.soundsToastRepeats:SetText(getSetting(panel.soundsToastRepeats))
	
	--Cycles
	panel.cyclesCount:SetText(getSetting(panel.cyclesCount))
	panel.cyclesContinuous:SetChecked(getSetting(panel.cyclesContinuous))
	
	local channel = getSetting(panel.soundsChannelDefault)
	for _, b in pairs(panel.soundsChannelDefault.buttonList) do
		if b.value == channel then
			b:SetChecked(true)
		else
			b:SetChecked(false)
		end
	end
end

local function createCheckButton(panel, subname, text, anchorFrame, anchorPoint, anchorTo, xOffset, yOffset, settingKey, userSetting, dungeonSetting, dungeonID, tooltip)
	local cb = CreateFrame("CheckButton", panel:GetName()..subname, panel, "UICheckButtonTemplate")
	cb.text:SetText(text) --.text from UICheckButtonTemplate
	cb:SetPoint(anchorPoint, anchorFrame, anchorTo, xOffset, yOffset)
	cb.settingKey = settingKey
	cb.userSetting = userSetting
	cb.dungeonSetting = dungeonSetting
	cb.dungeonID = dungeonID
	cb.tooltip = tooltip
	cb:SetScript("OnClick", checkButtonOnClick)

	cb:SetScript("OnEnter", function(self, ...)
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(IncentiveProgram.ADDON_DISPLAY_NAME, 1.0, 1.0, 1.0)
			GameTooltip:AddLine(self.tooltip, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	
	cb:SetScript("OnLeave", function(self, ...)
		GameTooltip:Hide()
	end)
	
	return cb
end

local function createEditBox(panel, subname, text, anchorFrame, anchorPoint, anchorTo, xOffset, yOffset, settingKey, userSetting, dungeonSetting, dungeonID, tooltip)
	local eb = CreateFrame("EditBox", panel:GetName()..subname, panel, "InputBoxInstructionsTemplate")
	eb.Instructions:SetText(text) --.Instructions from InputBoxInstructionsTemplate
	eb:SetPoint(anchorPoint, anchorFrame, anchorTo, xOffset, yOffset)
	eb:SetHeight(18)
	eb:SetWidth(65)
	eb.settingKey = settingKey
	eb.userSetting = userSetting
	eb.dungeonSetting = dungeonSetting
	eb.dungeonID = dungeonID
	eb.tooltip = tooltip
	eb:SetAutoFocus(false)
	eb:SetScript("OnEditFocusGained", function(self, ...)
		self.originalValue = self:GetText()
	end)
	eb:SetScript("OnEditFocusLost", function(self, ...)
		if self:GetText() ~= "" and tonumber(self:GetText()) and tonumber(self:GetText()) > 0 then
			setSetting(self, self:GetText())
		else
			self:SetText(self.originalValue or getSetting(self) or "")
		end
	end)
	
	eb:SetScript("OnEscapePressed", function(self, ...)
		self:SetText(self.originalValue or getSetting(self) or "")
		self:ClearFocus()
	end)
	
	eb:SetScript("OnEnterPressed", function(self, ...)
		self:ClearFocus()
	end)
	
	eb:SetScript("OnEnter", function(self, ...)
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(IncentiveProgram.ADDON_DISPLAY_NAME, 1.0, 1.0, 1.0)
			GameTooltip:AddLine(self.tooltip, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	
	eb:SetScript("OnLeave", function(self, ...)
		GameTooltip:Hide()
	end)
	
	return eb
end

local function createRadioButton(panel, subname, text, anchorFrame, anchorPoint, anchorTo, xOffset, yOffset, settingKey, userSetting, dungeonSetting, dungeonID, tooltip, buttonList, value)
	local rb = CreateFrame("CheckButton", panel:GetName()..subname, panel, "UIRadioButtonTemplate")
	rb.text:SetText(text) --.text from UICheckButtonTemplate
	rb:SetPoint(anchorPoint, anchorFrame, anchorTo, xOffset, yOffset)
	rb.settingKey = settingKey
	rb.userSetting = userSetting
	rb.dungeonSetting = dungeonSetting
	rb.dungeonID = dungeonID
	rb.tooltip = tooltip
	rb:SetScript("OnClick", checkButtonOnClick)

	rb:SetScript("OnEnter", function(self, ...)
		if self.tooltip then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:AddLine(IncentiveProgram.ADDON_DISPLAY_NAME, 1.0, 1.0, 1.0)
			GameTooltip:AddLine(self.tooltip, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	
	rb:SetScript("OnLeave", function(self, ...)
		GameTooltip:Hide()
	end)
	
	table.insert(buttonList, rb)
	rb.buttonList = buttonList
	rb.value = value
	
	return rb
end

local function createInterfacePanel()

	--Add an interface panel to the blizzard AddOn Interface UI
	local panel = CreateFrame("Frame","IncentiveProgramInterfacePanel",UIParent)
	panel.name = IncentiveProgram.ADDON_DISPLAY_NAME
	
	panel.okay = function(self, ...)
	end
	
	panel.default = function(self, ...)
	end
	
	panel.refresh = function(self, ...)
		loadSettings(self)
	end
	
	InterfaceOptions_AddCategory(panel)
	
	--Header
	panel.title = panel:CreateFontString(panel:GetName().."Title", "ARTWORK", "Game18Font")
	panel.title:SetText(IncentiveProgram.ADDON_DISPLAY_NAME)
	panel.title:SetTextColor(1,0.82,0)
	panel.title:SetPoint("TOPLEFT", 10, -10)
	
	--Roles
	panel.rolesHeader = panel:CreateFontString(panel:GetName().."RolesHeader", "ARTWORK", "Game15Font")
	panel.rolesHeader:SetText(IncentiveProgram.ContextLabels["ROLES"])
	panel.rolesHeader:SetPoint("TOPLEFT", panel.title, "BOTTOMLEFT", 0, -25)
	local tank, healer, damage = C_LFGList.GetAvailableRoles()
	if ( tank ) then tank = "" else tank = "\124CFFC41F3B" end
	if ( healer ) then healer = "" else healer = "\124CFFC41F3B" end
	if ( damage ) then damage = "" else damage = "\124CFFC41F3B" end

	panel.rolesTank = createCheckButton(panel, "RolesTankCheckBox", tank..IncentiveProgram.ContextLabels["TANK"],
		panel.rolesHeader, "LEFT", "RIGHT", 35, 0, IncentiveProgram.Settings["ROLE_TANK"], true, nil, nil)
		
	panel.rolesHealer = createCheckButton(panel, "RolesHealerCheckBox", healer..IncentiveProgram.ContextLabels["HEALER"],
		panel.rolesTank, "LEFT", "RIGHT", 100, 0, IncentiveProgram.Settings["ROLE_HEALER"], true, nil, nil)
		
	panel.rolesDamage = createCheckButton(panel, "RolesDamageCheckBox", damage..IncentiveProgram.ContextLabels["DAMAGE"],
		panel.rolesHealer, "LEFT", "RIGHT", 100, 0, IncentiveProgram.Settings["ROLE_DAMAGE"], true, nil, nil)

	
	--General Settings
	panel.generalHeader = panel:CreateFontString(panel:GetName().."GeneralHeader", "ARTWORK", "Game15Font")
	panel.generalHeader:SetText(IncentiveProgram.ContextLabels["SETTINGS"])
	panel.generalHeader:SetPoint("TOPLEFT", panel.rolesHeader, "BOTTOMLEFT", 0, -25)
	
	panel.generalHideInParty = createCheckButton(panel, "GeneralHideInParty", IncentiveProgram.ContextLabels["HIDE_IN_PARTY"],
		panel.generalHeader, "LEFT", "RIGHT", 15, 0, IncentiveProgram.Settings["HIDE_IN_PARTY"], nil, nil, nil)
	
	panel.generalHideAlways = createCheckButton(panel, "GeneralHideAlways", IncentiveProgram.ContextLabels["HIDE_ALWAYS"],
		panel.generalHideInParty, "LEFT", "RIGHT", 100, 0, IncentiveProgram.Settings["HIDE_ALWAYS"], nil, nil, nil)
	
	panel.generalHideEmpty = createCheckButton(panel, "GenerlaHideEmpty", IncentiveProgram.ContextLabels["HIDE_EMPTY"],
		panel.generalHideAlways, "LEFT", "RIGHT", 100, 0, IncentiveProgram.Settings["HIDE_EMPTY"], nil, nil, nil)
	
	panel.generalAlert = createCheckButton(panel, "GeneralAlert", IncentiveProgram.ContextLabels["ALERT"],
		panel.generalHideInParty, "TOPLEFT", "BOTTOMLEFT", 0, 0, IncentiveProgram.Settings["ALERT"], nil, nil, nil)
	
	panel.generalAlertToast = createCheckButton(panel, "GeneralAlertToast", IncentiveProgram.ContextLabels["ALERT_TOAST"],
		panel.generalAlert, "LEFT", "RIGHT", 100, 0, IncentiveProgram.Settings["ALERT_TOAST"], nil, nil, nil)
	
	panel.generalIgnoreCompletedLFR = createCheckButton(panel, "GeneralIgnoreCompletedLFR", IncentiveProgram.ContextLabels["IGNORE_COMPLETED_LFR"],
		panel.generalAlert, "TOPLEFT", "BOTTOMLEFT", 0, 0, IncentiveProgram.Settings["IGNORE_COMPLETED_LFR"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_IGNORE_LFR"])

	
	--Sounds
	panel.soundsHeader = panel:CreateFontString(panel:GetName().."SoundsHeader", "ARTWORK", "Game15Font")
	panel.soundsHeader:SetText(IncentiveProgram.ContextLabels["SOUNDS"])
	panel.soundsHeader:SetPoint("TOPLEFT", panel.generalHeader, "BOTTOMLEFT", 0, -95)
	
	--Sounds
	----Alert Ping
	panel.soundsAlertPing = createCheckButton(panel, "SoundsAlertPing", IncentiveProgram.ContextLabels["ALERT_PING"],
		panel.soundsHeader, "LEFT", "RIGHT", 20, 0, IncentiveProgram.Settings["ALERT_PING"], nil, nil, nil)
		
	panel.soundsAlertSoundLabel = panel:CreateFontString(panel:GetName().."SoundAlertSoundLabel", "ARTWORK", "GameFontNormalSmall")
	panel.soundsAlertSoundLabel:SetText(IncentiveProgram.ContextLabels["SOUND_ID"])
	panel.soundsAlertSoundLabel:SetPoint("LEFT", panel.soundsAlertPing, "RIGHT", 65, -1)
		
	panel.soundsAlertSound = createEditBox(panel, "SoundsAlertSound", IncentiveProgram.ContextLabels["SOUND_ID"],
		panel.soundsAlertSoundLabel, "LEFT", "RIGHT", 15, 1, IncentiveProgram.Settings["ALERT_SOUND"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_SOUND_ID_1"])
	
	panel.soundsAlertTest = CreateFrame("Button", panel:GetName().."SoundsAlertTest", panel, "UIPanelButtonTemplate")
	panel.soundsAlertTest:SetPoint("LEFT", panel.soundsAlertSound, "RIGHT", 10, -1)
	panel.soundsAlertTest.Text:SetText("測試") --.Text from UIPanelButtonTemplate
	panel.soundsAlertTest:SetScript("OnClick", function(self)
		local soundID = getSetting(panel.soundsAlertSound)
		local channel = getSetting(panel.soundsChannelDefault)
		
		-- 自訂播放音樂
		if (soundID == 1069 or soundID == "1069") then
			PlaySoundFile("Interface\\Addons\\IncentiveProgram\\PPAP_MoritzGart.mp3", channel)
		elseif (soundID == 5487 or soundID == "5487") then
			PlaySoundFile("Interface\\Addons\\IncentiveProgram\\004_applepie.mp3", channel)
		else 
			PlaySound(soundID, channel)
		end
	end)
		
	panel.soundsAlertRepeatsLabel = panel:CreateFontString(panel:GetName().."SoundAlertRepeatsLabel", "ARTWORK", "GameFontNormalSmall")
	panel.soundsAlertRepeatsLabel:SetText(IncentiveProgram.ContextLabels["REPEATS"])
	panel.soundsAlertRepeatsLabel:SetPoint("LEFT", panel.soundsAlertTest, "RIGHT", 15, 0)
	
	panel.soundsAlertRepeats = createEditBox(panel, "SoundsAlertRepeats", IncentiveProgram.ContextLabels["REPEATS"],
		panel.soundsAlertRepeatsLabel, "LEFT", "RIGHT", 15, 1, IncentiveProgram.Settings["ALERT_REPEATS"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_SOUND_REPEATS"])
	
	--Sounds
	----Toast Ping
	panel.soundsToastPing = createCheckButton(panel, "SoundsToastPing", IncentiveProgram.ContextLabels["TOAST_PING"],
		panel.soundsAlertPing, "TOPLEFT", "BOTTOMLEFT", 0, 0, IncentiveProgram.Settings["TOAST_PING"], nil, nil, nil)
		
	panel.soundsToastSoundLabel = panel:CreateFontString(panel:GetName().."SoundToastSoundLabel", "ARTWORK", "GameFontNormalSmall")
	panel.soundsToastSoundLabel:SetText(IncentiveProgram.ContextLabels["SOUND_ID"])
	panel.soundsToastSoundLabel:SetPoint("LEFT", panel.soundsToastPing, "RIGHT", 65, -1)
		
	panel.soundsToastSound = createEditBox(panel, "SoundsToastSound", IncentiveProgram.ContextLabels["SOUND_ID"],
		panel.soundsToastSoundLabel, "LEFT", "RIGHT", 15, 1, IncentiveProgram.Settings["TOAST_SOUND"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_SOUND_ID_2"])
			
	panel.soundsToastTest = CreateFrame("Button", panel:GetName().."SoundsToastTest", panel, "UIPanelButtonTemplate")
	panel.soundsToastTest:SetPoint("LEFT", panel.soundsToastSound, "RIGHT", 10, -1)
	panel.soundsToastTest.Text:SetText("測試") --.Text from UIPanelButtonTemplate
	panel.soundsToastTest:SetScript("OnClick", function(self)
		local soundID = getSetting(panel.soundsToastSound)
		local channel = getSetting(panel.soundsChannelDefault)

		-- 自訂播放音樂
		if (soundID == 1069 or soundID == "1069") then
			PlaySoundFile("Interface\\Addons\\IncentiveProgram\\PPAP_MoritzGart.mp3", channel)
		elseif (soundID == 5487 or soundID == "5487") then
			PlaySoundFile("Interface\\Addons\\IncentiveProgram\\004_applepie.mp3", channel)
		else 
			PlaySound(soundID, channel)
		end
	end)
		
	panel.soundsToastRepeatsLabel = panel:CreateFontString(panel:GetName().."SoundToastRepeatsLabel", "ARTWORK", "GameFontNormalSmall")
	panel.soundsToastRepeatsLabel:SetText(IncentiveProgram.ContextLabels["REPEATS"])
	panel.soundsToastRepeatsLabel:SetPoint("LEFT", panel.soundsToastTest, "RIGHT", 15, 0)
	
	panel.soundsToastRepeats = createEditBox(panel, "SoundsToastRepeats", IncentiveProgram.ContextLabels["REPEATS"],
		panel.soundsToastRepeatsLabel, "LEFT", "RIGHT", 15, 1, IncentiveProgram.Settings["TOAST_REPEATS"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_SOUND_REPEATS"])
	
	--Sounds
	----Channel Radio
	local tblRadioChannel = {}
	
	panel.soundsChannelLabel = panel:CreateFontString(panel:GetName().."SoundChannelLabel", "ARTWORK", "GameFontNormalSmall")
	panel.soundsChannelLabel:SetText("聲音頻道：")
	panel.soundsChannelLabel:SetPoint("TOPLEFT", panel.soundsToastPing, "BOTTOMLEFT", 0, -10)
	
	panel.soundsChannelDefault = createRadioButton(panel, "SoundsChannelDefault", "音效 *", panel.soundsChannelLabel, "LEFT", "RIGHT", 15, 0, IncentiveProgram.Settings["CHANNEL"]
	, nil, nil, nil, "這是預設的頻道。", tblRadioChannel, "SFX")	
	panel.soundsChannelMusic = createRadioButton(panel, "SoundsChannelMusic", "音樂", panel.soundsChannelDefault, "LEFT", "RIGHT", 60, 0, IncentiveProgram.Settings["CHANNEL"]
	, nil, nil, nil, nil, tblRadioChannel, "Music")	
	panel.soundsChannelAmbience = createRadioButton(panel, "SoundsChannelAmbience", "環境", panel.soundsChannelMusic, "LEFT", "RIGHT", 60, 0, IncentiveProgram.Settings["CHANNEL"]
	, nil, nil, nil, nil, tblRadioChannel, "Ambience")	
	panel.soundsChannelMaster = createRadioButton(panel, "SoundsChannelMaster", "主音量 *", panel.soundsChannelAmbience, "LEFT", "RIGHT", 60, 0, IncentiveProgram.Settings["CHANNEL"]
	, nil, nil, nil, "一律使用主音量大小來播放，無論音效是否已經停用。", tblRadioChannel, "Master")
	
	--Cycles
	panel.cyclesHeader = panel:CreateFontString(panel:GetName().."SoundsHeader", "ARTWORK", "Game15Font")
	panel.cyclesHeader:SetText(IncentiveProgram.ContextLabels["ANIM_CYCLES"])
	panel.cyclesHeader:SetPoint("TOPLEFT", panel.soundsHeader, "BOTTOMLEFT", 0, -95)
	
	panel.cyclesCount = createEditBox(panel, "CyclesCount", IncentiveProgram.ContextLabels["ANIM_CYCLES"],
		panel.cyclesHeader, "LEFT", "RIGHT", 35, 0, IncentiveProgram.Settings["CYCLE_COUNT"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_CYCLE_COUNT"])
	
	panel.cyclesContinuous = createCheckButton(panel, "CyclesContinuous", IncentiveProgram.ContextLabels["CONTINUOUSLY_CYCLE"],
		panel.cyclesCount, "LEFT", "RIGHT", 65, 0, IncentiveProgram.Settings["CONTINUOUSLY_CYCLE"], nil, nil, nil, IncentiveProgram.ContextLabels["TOOLTIP_CONTINUOUSLY_CYCLE"])
	
	
	--Reset Button
	panel.resetPositionBtn = CreateFrame("BUTTON", panel:GetName().."ResetPosition", panel, "UIPanelButtonTemplate")
	panel.resetPositionBtn:SetText(IncentiveProgram.ContextLabels["RESET_POSITION"])
	panel.resetPositionBtn:SetWidth(100)
	panel.resetPositionBtn:SetPoint("TOPLEFT", panel.cyclesHeader, "BOTTOMLEFT", 0, -25)
	panel.resetPositionBtn:SetScript("OnClick", function()
		IncentiveProgram:GetFrame():ResetFramePosition()
	end)
	
	--Tell Bliz's interface frame to update and show the interface panel
    InterfaceAddOnsList_Update();
	
	--test
	--InterfaceOptionsFrame_OpenToCategory(IncentiveProgramInterfacePanel) 
end

IncentiveProgram.CreateInterfacePanel = createInterfacePanel