local function newSlider(parent, name, description, minRange, maxRange, stepSize, startValue, onValueChangedHook)
	--mostly from AdvancedInterfaceOptions
	local label = name
	local slider = CreateFrame('Slider', 'QJN_Options_Slider' .. name, parent, 'OptionsSliderTemplate')

	slider.name = name
	stepSize = stepSize or 1
	slider:SetValueStep(stepSize)
	slider:SetObeyStepOnDrag(true)

	slider:SetMinMaxValues(minRange, maxRange)
	slider.minText = _G[slider:GetName() .. 'Low']
	slider.maxText = _G[slider:GetName() .. 'High']
	slider.text = _G[slider:GetName() .. 'Text']
	slider.minText:SetText(minRange)
	slider.maxText:SetText(maxRange)
	slider.text:SetText(label)
	slider:SetValue(startValue);

	local valueText = slider:CreateFontString(nil, nil, 'GameFontHighlight')
	valueText:SetPoint('TOP', slider, 'BOTTOM', 0, -5)
	valueText:SetText(startValue);
	slider.valueText = valueText
	slider:HookScript('OnValueChanged', function(self, value)
		local factor = 1 / stepSize
		value = floor(value * factor + 0.5) / factor
		valueText:SetText(value)
	end)
	slider:HookScript("OnValueChanged", onValueChangedHook);

	slider.tooltipText = label
	slider.tooltipRequirement = description
	return slider
end

local function newCheckbox(parent, name, description, optionName)
	--mostly from AdvancedInterfaceOptions
	local label = name
	local check = CreateFrame("CheckButton", "QJN_Options_Checkbox" .. label, parent, "InterfaceOptionsCheckButtonTemplate")
	check.optionName = optionName

	check.GetValue = function(self)
		return QJN_Options[self.optionName]
	end
	check.SetValue = function(self, checked)
		QJN_Options[self.optionName] = checked
	end
	check:SetChecked(check:GetValue())
	check:SetScript('OnShow', function(self) self:SetChecked(self:GetValue()) end)
	check:SetScript("OnClick", function(self)
		local checked = self:GetChecked()
		-- PlaySound(checked and "igMainMenuOptionCheckBoxOn" or "igMainMenuOptionCheckBoxOff")
		PlaySound(checked and 856 or 857)
		self:SetValue(checked)
	end)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = label
	check.tooltipRequirement = description
	return check
end

function init_QJN_OptionsPanel () 
	local QJN_OptionsPanel = CreateFrame("FRAME");
	QJN_OptionsPanel.name = "快速加入"
	InterfaceOptions_AddCategory(QJN_OptionsPanel);

	--update this value after every element and use it to position the next one
	local nextAnchor = nil;
	
	local title = QJN_OptionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
	title:SetPoint("TOPLEFT", 16, -16);
	title:SetText("快速加入通知");
	nextAnchor = title
	
	local QJN_Options_DisableBlizzard = newCheckbox(QJN_OptionsPanel, "停用暴雪的快速加入彈出通知", "停用遊戲預設的的快速加入彈出通知。", "HIDE_BLIZZARD_TOASTS")
	QJN_Options_DisableBlizzard:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -15)
	QJN_Options_DisableBlizzard:HookScript("OnClick", QJN_processOptions)
	nextAnchor = QJN_Options_DisableBlizzard
	
	local QJN_Options_Chat = newCheckbox(QJN_OptionsPanel, "顯示聊天通知", "在預設的聊天視窗顯示快速加入的訊息。", "CHAT_ENABLED")
	QJN_Options_Chat:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -10)
	nextAnchor = QJN_Options_Chat
	
	local QJN_Options_Toasts = newCheckbox(QJN_OptionsPanel, "顯示通知面板", "在聊天視窗上方用小視窗顯示快速加入的訊息。", "TOASTS_ENABLED")
	QJN_Options_Toasts:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -10)
	nextAnchor = QJN_Options_Toasts
	local QJN_Options_ToastSound = newCheckbox(QJN_OptionsPanel, "啟用音效", "勾選時，彈出通知出現時會播放音效。", "TOAST_SOUND_ENABLED")
	QJN_Options_ToastSound:SetPoint("TOPLEFT", QJN_Options_Toasts, "TOPRIGHT", _G[QJN_Options_Toasts:GetName() .. "Text"]:GetWidth() + 10, 0)
	
	local QJN_Options_EnabledInRaids = newCheckbox(QJN_OptionsPanel, "團隊中啟用", "勾選時，當你在團隊副本內會顯示通知。", "ENABLED_IN_RAIDS")
	QJN_Options_EnabledInRaids:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -10)
	nextAnchor = QJN_Options_EnabledInRaids
	local QJN_Options_EnabledInDungeons = newCheckbox(QJN_OptionsPanel, "地城中啟用", "勾選時，當你在5人副本內會顯示通知。", "ENABLED_IN_DUNGEONS")
	QJN_Options_EnabledInDungeons:SetPoint("TOPLEFT", QJN_Options_EnabledInRaids, "TOPRIGHT", _G[QJN_Options_EnabledInRaids:GetName() .. "Text"]:GetWidth() + 10, 0)
	
	local QJN_Options_EnabledInArenas = newCheckbox(QJN_OptionsPanel, "技競場中啟用", "勾選時，當你在競技場內會顯示通知。", "ENABLED_IN_ARENAS")
	QJN_Options_EnabledInArenas:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -10)
	nextAnchor = QJN_Options_EnabledInArenas
	local QJN_Options_EnabledInBattlegrounds = newCheckbox(QJN_OptionsPanel, "戰場中啟用", "勾選時，當你在戰場內會顯示通知。", "ENABLED_IN_BATTLEGROUNDS")
	QJN_Options_EnabledInBattlegrounds:SetPoint("TOPLEFT", QJN_Options_EnabledInArenas, "TOPRIGHT", _G[QJN_Options_EnabledInArenas:GetName() .. "Text"]:GetWidth() + 10, 0)
	

	local QJN_Options_Width = newSlider(QJN_OptionsPanel, "寬度", "設定快速加入通知面板的寬度。", 100, 600, 10, QJN_Options["TOASTFRAME_WIDTH"], function (self, value)
		QJN_Options["TOASTFRAME_WIDTH"] = value
		QJN_applyToastOptions()
	end)
	QJN_Options_Width:ClearAllPoints();
	QJN_Options_Width:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -25);
	nextAnchor = QJN_Options_Width
	
	local QJN_Options_Height = newSlider(QJN_OptionsPanel, "高度", "設定快速加入通知面板的高度。", 50, 250, 5, QJN_Options["TOASTFRAME_HEIGHT"], function (self, value)
		QJN_Options["TOASTFRAME_HEIGHT"] = value
		QJN_applyToastOptions()
	end)
	QJN_Options_Height:ClearAllPoints();
	QJN_Options_Height:SetPoint("TOPLEFT", nextAnchor, "TOPRIGHT", 20, 0);
	
	local QJN_Options_ToastDuration = newSlider(QJN_OptionsPanel, "持續時間 (秒)", "設定通知持續顯示的時間。", 3, 15, 1, QJN_Options["TOAST_DURATION"], function(self, value)
		QJN_Options["TOAST_DURATION"] = value
		QJN_applyToastOptions()
	end)
	QJN_Options_ToastDuration:ClearAllPoints()
	QJN_Options_ToastDuration:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -50);
	nextAnchor = QJN_Options_ToastDuration

	
	local QJN_Options_GrowdirectionLabel = QJN_OptionsPanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	QJN_Options_GrowdirectionLabel:SetPoint('TOPLEFT', nextAnchor, 'BOTTOMLEFT', 0, -40)
	QJN_Options_GrowdirectionLabel:SetText('選擇增長方向：')
	local QJN_Options_Growdirection = CreateFrame("Frame", "QJN_Options_Growdirection", QJN_OptionsPanel, "UIDropDownMenuTemplate")
	QJN_Options_Growdirection:SetPoint("LEFT", QJN_Options_GrowdirectionLabel, "RIGHT", 5, 0);
	QJN_Options_Growdirection.initialize = function(dropdown)
		local directions = { "TOP", "BOTTOM" }
		local directionsText = { "上", "下" }
		for k, v in pairs(directions) do
			local info = UIDropDownMenu_CreateInfo();
			info.text = directionsText[k];
			info.value = v;
			info.func = function(self)
				QJN_Options["TOASTFRAME_GROWDIRECTION"] = self.value;
				if QJN_Options["TOASTFRAME_GROWDIRECTION"] == "TOP" then
					QJN_Options["TOASTFRAME_ANCHORPOS"] = "BOTTOM";
				else
					QJN_Options["TOASTFRAME_ANCHORPOS"] = "TOP";
				end
				QJN_resetPosition()
				UIDropDownMenu_SetSelectedValue(dropdown, self.value);
			end
			UIDropDownMenu_AddButton(info);
		end
		UIDropDownMenu_SetSelectedValue(dropdown, QJN_Options["TOASTFRAME_GROWDIRECTION"]);
	end
	QJN_Options_Growdirection.initialize(QJN_Options_Growdirection)
	nextAnchor = QJN_Options_GrowdirectionLabel	
	
	
	local QJN_Options_ToggleLock = CreateFrame("Button", "QJN_Options_LockButton", QJN_OptionsPanel, "UIPanelButtonTemplate");
	QJN_Options_ToggleLock:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -20)
	-- QJN_Options_AddTestToast:SetSize(40, 32) -- width, height
	QJN_Options_ToggleLock:SetText("切換鎖定")
	QJN_Options_ToggleLock:SetWidth(QJN_Options_ToggleLock:GetTextWidth() + 20);
	QJN_Options_ToggleLock:SetScript("OnClick", function()
		QJN_toggleLock()
	end)
	local QJN_Options_ResetPosition = CreateFrame("Button", "QJN_Options_ResetPositionButton", QJN_OptionsPanel, "UIPanelButtonTemplate");
	QJN_Options_ResetPosition:SetPoint("TOPLEFT", QJN_Options_ToggleLock, "TOPRIGHT", 20, 0)
	-- QJN_Options_AddTestToast:SetSize(40, 32) -- width, height
	QJN_Options_ResetPosition:SetText("重設位置")
	QJN_Options_ResetPosition:SetWidth(QJN_Options_ResetPosition:GetTextWidth() + 20);
	QJN_Options_ResetPosition:SetScript("OnClick", function()
		QJN_resetPosition()
	end)
	nextAnchor = QJN_Options_ToggleLock
	
	--###########TEST BUTTON SHOULD ALWAYS BE THE LAST ELEMENT###########
	local QJN_Options_AddTestToast = CreateFrame("Button", "QJN_Options_TestButton", QJN_OptionsPanel, "UIPanelButtonTemplate");
	QJN_Options_AddTestToast:SetPoint("TOPLEFT", nextAnchor, "BOTTOMLEFT", 0, -20)
	-- QJN_Options_AddTestToast:SetSize(40, 32) -- width, height
	QJN_Options_AddTestToast:SetText("測試通知")
	QJN_Options_AddTestToast:SetWidth(QJN_Options_AddTestToast:GetTextWidth() + 20);
	QJN_Options_AddTestToast:SetScript("OnClick", function()
		QJN_addQuickJoinNotification("彩虹ui", "正在測試：", "這是快速加入通知的測試");
	end)
end

--QJN_Options
-- local QJN_Defaults["TOASTFRAME_WIDTH"] = 400;
-- local QJN_Defaults["TOASTFRAME_HEIGHT"] = 80;
-- local QJN_Defaults["TOASTFRAME_PADDING"] = 10;
-- local QJN_Defaults["TOASTFRAME_MARGIN"] = 15;
-- local QJN_Defaults["TOASTCONTAINER_YOFFSET"] = 40;
-- local QJN_Defaults["TOASTCONTAINER_MAXTOASTS"] = 3;
-- local QJN_Defaults["TOASTFRAME_GROWDIRECTION"] = "TOP";