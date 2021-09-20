--CONFIG--------------------------------------------
local x1 = 103		y1 = 23				-- Coordinate for the first blood and the second unholy rune
local x2 = 72		y2 = 61				-- Coordinate for the second blood and the first unholy rune
local x3 = 25		y3 = 80				-- Coordinate for the first and second frost runes
local barX = 0 							-- Coordinate for the horizontal position of the runic power bar
---------------------------------------------------------

do
local classLocal, class = UnitClass("player")

	--Creating frames
	CreateFrame("Frame", "RuneHUD_OptionsFrame", UIParent );
	CreateFrame("Button", "RuneHUD_OptionsFrame_ResetButton", RuneHUD_OptionsFrame, "UIPanelButtonTemplate")
	CreateFrame("CheckButton", "RuneHUD_OptionsFrame_EnableBar", RuneHUD_OptionsFrame, "InterfaceOptionsCheckButtonTemplate")
	CreateFrame("CheckButton", "RuneHUD_OptionsFrame_BarNoCombat", RuneHUD_OptionsFrame, "InterfaceOptionsCheckButtonTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_BarPosition", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_BarPosition", RuneHUD_OptionsFrame_BarPosition, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_BarWidth", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_BarWidth", RuneHUD_OptionsFrame_BarWidth, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_BarHeight", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_BarHeight", RuneHUD_OptionsFrame_BarHeight, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_Scale", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_Scale", RuneHUD_OptionsFrame_Scale, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_CombatAlpha", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_CombatAlpha", RuneHUD_OptionsFrame_CombatAlpha, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_NoCombatAlpha", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_NoCombatAlpha", RuneHUD_OptionsFrame_NoCombatAlpha, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_BarNoCombatAlpha", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha", RuneHUD_OptionsFrame_BarNoCombatAlpha, "InputBoxTemplate")
	CreateFrame("Slider", "RuneHUD_OptionsFrame_BarCombatAlpha", RuneHUD_OptionsFrame, "OptionsSliderTemplate")
	CreateFrame("EditBox", "RuneHUD_OptionsFrame_EditBox_BarCombatAlpha", RuneHUD_OptionsFrame_BarCombatAlpha, "InputBoxTemplate")
		
	--Making the options frame
	RuneHUD_OptionsFrame:Hide()
	RuneHUD_OptionsFrame:SetWidth(300)
	RuneHUD_OptionsFrame:SetHeight(610)
	RuneHUD_OptionsFrame:SetFrameStrata("DIALOG")
	RuneHUD_OptionsFrame.name = "死亡騎士";
	InterfaceOptions_AddCategory(RuneHUD_OptionsFrame);

	--Title and explanation texts
	RuneHUD_OptionsFrame_Title = RuneHUD_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	RuneHUD_OptionsFrame_Title:SetPoint("TOPLEFT", 16, -16)
	RuneHUD_OptionsFrame_Title:SetText("死亡騎士符文條")
	
	RuneHUD_OptionsFrame_Runes = RuneHUD_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	RuneHUD_OptionsFrame_Runes:SetPoint("TOPLEFT", 20, -40)
	RuneHUD_OptionsFrame_Runes:SetText("符文選項")
	
	RuneHUD_OptionsFrame_Bar = RuneHUD_OptionsFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	RuneHUD_OptionsFrame_Bar:SetPoint("TOPLEFT", 20, -215)
	RuneHUD_OptionsFrame_Bar:SetText("符能條選項")
	
	
	--RUNIC POWER BAR OPTIONS
	--Bar on/off
	RuneHUD_OptionsFrame_EnableBar:SetPoint("TOPLEFT", 15, -230)
	RuneHUD_OptionsFrame_EnableBar:SetHitRectInsets(0, -190, 0, 0)
	RuneHUD_OptionsFrame_EnableBarText:SetText("啟用/停用符能條")
	RuneHUD_OptionsFrame_EnableBar:SetScript("OnClick", function(self)
		if RHBarEnable == true then
			RHBarEnable = false
			if class == "DEATHKNIGHT" then
				RuneHUDFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
				RuneHUDBar:Hide()
			end
		else
			RHBarEnable = true
			if class == "DEATHKNIGHT" then
				RuneHUDFrame:RegisterUnitEvent("UNIT_POWER_FREQUENT","player")
				if InCombatLockdown() == true then
					RuneHUDBar:Show()
				elseif RHBarNoCombat == true then
					RuneHUDBar:Show()
				end
			end
		end
		self:SetChecked(RHBarEnable)
	end)


	--Bar out of combat
	RuneHUD_OptionsFrame_BarNoCombat:SetPoint("TOPLEFT", 300, -230)
	RuneHUD_OptionsFrame_BarNoCombat:SetHitRectInsets(0, -190, 0, 0)
	RuneHUD_OptionsFrame_BarNoCombatText:SetText("非戰鬥中顯示符能條")
	RuneHUD_OptionsFrame_BarNoCombat:SetScript("OnClick", function(self)
		if RHBarNoCombat == true then
			RHBarNoCombat = false
			if InCombatLockdown() == false and class == "DEATHKNIGHT"then
				RuneHUDBar:Hide()
			end
		else
			RHBarNoCombat = true
			if class == "DEATHKNIGHT" then
				RuneHUDBar:Show()
			end
		end
		self:SetChecked(RHBarNoCombat)
	end)
	
	
	--Bar alpha in combat
	RuneHUD_OptionsFrame_BarCombatAlpha:SetWidth(580)
	RuneHUD_OptionsFrame_BarCombatAlpha:SetHeight(16)
	RuneHUD_OptionsFrame_BarCombatAlpha:SetPoint("TOPLEFT", 20, -275)
	RuneHUD_OptionsFrame_BarCombatAlphaLow:SetText("0")
	RuneHUD_OptionsFrame_BarCombatAlphaHigh:SetText("1")
	RuneHUD_OptionsFrame_BarCombatAlpha:SetMinMaxValues(0,1)
	RuneHUD_OptionsFrame_BarCombatAlpha:SetValueStep(.01)
	RuneHUD_OptionsFrame_BarCombatAlphaText:SetFormattedText("戰鬥中透明度", RuneHUD_OptionsFrame_BarCombatAlpha:GetValue())
	RuneHUD_OptionsFrame_BarCombatAlpha:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetNumber(value)
		RHBarCombatAlpha = value
		if InCombatLockdown() == true and class == "DEATHKNIGHT" then
			RuneHUDBar:SetAlpha(RHBarCombatAlpha)
			RuneHUDBarDepleted:SetAlpha(RHBarCombatAlpha)
			RuneHUDBackground:SetAlpha(RHBarCombatAlpha)
		end
	end)

	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetMaxLetters(4)
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetScript("OnEnterPressed", function(self)
		RHBarCombatAlpha = RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:GetNumber()
		if InCombatLockdown() == true and class == "DEATHKNIGHT" then
			RuneHUDBar:SetAlpha(RHBarCombatAlpha)
			RuneHUDBarDepleted:SetAlpha(RHBarCombatAlpha)
			RuneHUDBackground:SetAlpha(RHBarCombatAlpha)
		end
		RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:ClearFocus()
	end)
	RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetNumber(RHBarCombatAlpha)
	end)
	
	--Bar alpha out of combat
	RuneHUD_OptionsFrame_BarNoCombatAlpha:SetWidth(580)
	RuneHUD_OptionsFrame_BarNoCombatAlpha:SetHeight(16)
	RuneHUD_OptionsFrame_BarNoCombatAlpha:SetPoint("TOPLEFT", 20, -330)
	RuneHUD_OptionsFrame_BarNoCombatAlphaLow:SetText("0")
	RuneHUD_OptionsFrame_BarNoCombatAlphaHigh:SetText("1")
	RuneHUD_OptionsFrame_BarNoCombatAlpha:SetMinMaxValues(0,1)
	RuneHUD_OptionsFrame_BarNoCombatAlpha:SetValueStep(.01)
	RuneHUD_OptionsFrame_BarNoCombatAlphaText:SetFormattedText("非戰鬥中透明度 (只有啟用非戰鬥中顯示符能條時)", RuneHUD_OptionsFrame_BarNoCombatAlpha:GetValue())
	RuneHUD_OptionsFrame_BarNoCombatAlpha:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetNumber(value)
		RHBarNoCombatAlpha = value
		if InCombatLockdown() == false and RHBarNoCombat == true and class == "DEATHKNIGHT" then
			RuneHUDBar:SetAlpha(RHBarNoCombatAlpha)
			RuneHUDBarDepleted:SetAlpha(RHBarNoCombatAlpha)
			RuneHUDBackground:SetAlpha(RHBarNoCombatAlpha)
		end
	end)

	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetMaxLetters(4)
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetScript("OnEnterPressed", function(self)
		RHBarNoCombatAlpha = RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:GetNumber()
		if InCombatLockdown() == false and RHBarNoCombat == true and class == "DEATHKNIGHT" then
			RuneHUDBar:SetAlpha(RHBarNoCombatAlpha)
			RuneHUDBarDepleted:SetAlpha(RHBarNoCombatAlpha)
			RuneHUDBackground:SetAlpha(RHBarNoCombatAlpha)
		end
		RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:ClearFocus()
	end)
	RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetNumber(RHBarNoCombatAlpha)
	end)

		
	--Vertical position
	RuneHUD_OptionsFrame_BarPosition:SetWidth(580)
	RuneHUD_OptionsFrame_BarPosition:SetHeight(16)
	RuneHUD_OptionsFrame_BarPosition:SetPoint("TOPLEFT", 20, -385)
	RuneHUD_OptionsFrame_BarPositionLow:SetText("-500")
	RuneHUD_OptionsFrame_BarPositionHigh:SetText("500")
	RuneHUD_OptionsFrame_BarPosition:SetMinMaxValues(-500,500)
	RuneHUD_OptionsFrame_BarPosition:SetValueStep(1)
	RuneHUD_OptionsFrame_BarPositionText:SetFormattedText("垂直位置", RuneHUD_OptionsFrame_BarPosition:GetValue())
	RuneHUD_OptionsFrame_BarPosition:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_BarPosition:SetNumber(value)
		RHBarPosition = value
		if class == "DEATHKNIGHT" then
			RuneHUDBar:SetPoint("CENTER", UIParent, "CENTER", 0, RHBarPosition)
		end
	end)

	RuneHUD_OptionsFrame_EditBox_BarPosition:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetMaxLetters(4)
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetScript("OnEnterPressed", function(self)
		RHBarPosition = RuneHUD_OptionsFrame_EditBox_BarPosition:GetNumber()
		if class == "DEATHKNIGHT" then
			RuneHUDBar:SetPoint("CENTER", UIParent, "CENTER", 0, RHBarPosition)
		end
		RuneHUD_OptionsFrame_EditBox_BarPosition:ClearFocus()
	end)
	RuneHUD_OptionsFrame_EditBox_BarPosition:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_BarPosition:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_BarPosition:SetNumber(RHBarPosition)
	end)
	
	
	--Width
	RuneHUD_OptionsFrame_BarWidth:SetWidth(580)
	RuneHUD_OptionsFrame_BarWidth:SetHeight(16)
	RuneHUD_OptionsFrame_BarWidth:SetPoint("TOPLEFT", 20, -440)
	RuneHUD_OptionsFrame_BarWidthLow:SetText("0")
	RuneHUD_OptionsFrame_BarWidthHigh:SetText("500")
	RuneHUD_OptionsFrame_BarWidth:SetMinMaxValues(0,500)
	RuneHUD_OptionsFrame_BarWidth:SetValueStep(1)
	RuneHUD_OptionsFrame_BarWidthText:SetFormattedText("寬度", RuneHUD_OptionsFrame_BarWidth:GetValue())
	RuneHUD_OptionsFrame_BarWidth:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_BarWidth:SetNumber(value)
		RHBarWidth = value
		if class == "DEATHKNIGHT" then
			RuneHUDBar:SetWidth(RHBarWidth)
			RuneHUDBackground:SetWidth(RHBarWidth + 2)
		end
	end)
	
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetMaxLetters(3)
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetScript("OnEnterPressed", function(self)
		RHBarWidth = RuneHUD_OptionsFrame_EditBox_BarWidth:GetNumber()
		if class == "DEATHKNIGHT" then
			RuneHUDBar:SetWidth(RHBarWidth)
			RuneHUDBackground:SetWidth(RHBarWidth + 2)
		end
		RuneHUD_OptionsFrame_EditBox_BarWidth:ClearFocus()
	end)
	RuneHUD_OptionsFrame_EditBox_BarWidth:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_BarWidth:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_BarWidth:SetNumber(RHBarWidth)
	end)
	
	
	--Height
	RuneHUD_OptionsFrame_BarHeight:SetWidth(580)
	RuneHUD_OptionsFrame_BarHeight:SetHeight(16)
	RuneHUD_OptionsFrame_BarHeight:SetPoint("TOPLEFT", 20, -495)
	RuneHUD_OptionsFrame_BarHeightLow:SetText("0")
	RuneHUD_OptionsFrame_BarHeightHigh:SetText("50")
	RuneHUD_OptionsFrame_BarHeight:SetMinMaxValues(0,50)
	RuneHUD_OptionsFrame_BarHeight:SetValueStep(1)
	RuneHUD_OptionsFrame_BarHeightText:SetFormattedText("高度", RuneHUD_OptionsFrame_BarHeight:GetValue())
	RuneHUD_OptionsFrame_BarHeight:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_BarHeight:SetNumber(value)
		RHBarHeight = value
		if class == "DEATHKNIGHT" then
			RuneHUDBar:SetHeight(RHBarHeight)
			RuneHUDBackground:SetHeight(RHBarHeight + 2)
			local fontSize = RHBarHeight-RHBarHeight*0,1
			RunicPowerValue:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
		end
	end)
	
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetMaxLetters(2)
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_BarHeight:SetScript("OnEnterPressed", function(self)
		RHBarHeight = RuneHUD_OptionsFrame_EditBox_BarHeight:GetNumber()
		if class == "DEATHKNIGHT" then
			RuneHUDBar:SetHeight(RHBarHeight)
			RuneHUDBackground:SetHeight(RHBarHeight + 2)	
			local fontSize = RHBarHeight-RHBarHeight*0,1
			RunicPowerValue:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "OUTLINE")
		end
	end)
	RuneHUD_OptionsFrame_EditBox_BarHeight:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_BarHeight:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_BarHeight:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_BarHeight:SetNumber(RHBarHeight)
	end)

	
	--RUNE OPTIONS
	--Scaling
	RuneHUD_OptionsFrame_Scale:SetWidth(580)
	RuneHUD_OptionsFrame_Scale:SetHeight(16)
	RuneHUD_OptionsFrame_Scale:SetPoint("TOPLEFT", 20, -60)
	RuneHUD_OptionsFrame_ScaleLow:SetText("0.1")
	RuneHUD_OptionsFrame_ScaleHigh:SetText("2")
	RuneHUD_OptionsFrame_Scale:SetMinMaxValues(0.1,2)
	RuneHUD_OptionsFrame_Scale:SetValueStep(.1)
	RuneHUD_OptionsFrame_ScaleText:SetFormattedText("縮放大小", RuneHUD_OptionsFrame_Scale:GetValue())
	RuneHUD_OptionsFrame_Scale:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_Scale:SetNumber(value)
		RHScale = value
		if class == "DEATHKNIGHT" then
			RuneFrame:SetScale(RHScale)
		end
	end)
	
	RuneHUD_OptionsFrame_EditBox_Scale:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_Scale:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_Scale:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_Scale:SetMaxLetters(3)
	RuneHUD_OptionsFrame_EditBox_Scale:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_Scale:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_Scale:SetScript("OnEnterPressed", function(self)
		RHScale = RuneHUD_OptionsFrame_EditBox_Scale:GetNumber()
		RuneHUD_OptionsFrame_Scale:SetValue(RHScale)
		if class == "DEATHKNIGHT" then
			RuneFrame:SetScale(RHScale)
		end
		RuneHUD_OptionsFrame_EditBox_Scale:ClearFocus()
	end)
		RuneHUD_OptionsFrame_EditBox_Scale:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_Scale:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_Scale:SetNumber(RHScale)
	end)
	
	
	--In of combat alpha
	RuneHUD_OptionsFrame_CombatAlpha:SetWidth(580)
	RuneHUD_OptionsFrame_CombatAlpha:SetHeight(16)
	RuneHUD_OptionsFrame_CombatAlpha:SetPoint("TOPLEFT", 20, -115)
	RuneHUD_OptionsFrame_CombatAlphaLow:SetText("0")
	RuneHUD_OptionsFrame_CombatAlphaHigh:SetText("1")
	RuneHUD_OptionsFrame_CombatAlpha:SetMinMaxValues(0,1)
	RuneHUD_OptionsFrame_CombatAlpha:SetValueStep(.01)
	RuneHUD_OptionsFrame_CombatAlphaText:SetFormattedText("戰鬥中透明度", RuneHUD_OptionsFrame_CombatAlpha:GetValue())
	RuneHUD_OptionsFrame_CombatAlpha:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetNumber(value)
		RHCombatAlpha = value
		if InCombatLockdown() == true and class == "DEATHKNIGHT" then
			RuneFrame:SetAlpha(RHCombatAlpha)
		end
	end)
	
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetMaxLetters(4)
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetScript("OnEnterPressed", function(self)
		RHCombatAlpha = RuneHUD_OptionsFrame_EditBox_CombatAlpha:GetNumber()
		RuneHUD_OptionsFrame_CombatAlpha:SetValue(RHCombatAlpha)
		if InCombatLockdown() == true and class == "DEATHKNIGHT" then 
			RuneFrame:SetAlpha(RHCombatAlpha)
		end
		RuneHUD_OptionsFrame_EditBox_CombatAlpha:ClearFocus()
	end)
		RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_CombatAlpha:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetNumber(RHCombatAlpha)
	end)


	--Out of combat alpha
	RuneHUD_OptionsFrame_NoCombatAlpha:SetWidth(580)
	RuneHUD_OptionsFrame_NoCombatAlpha:SetHeight(16)
	RuneHUD_OptionsFrame_NoCombatAlpha:SetPoint("TOPLEFT", 20, -170)
	RuneHUD_OptionsFrame_NoCombatAlphaLow:SetText("0")
	RuneHUD_OptionsFrame_NoCombatAlphaHigh:SetText("1")
	RuneHUD_OptionsFrame_NoCombatAlpha:SetMinMaxValues(0,1)
	RuneHUD_OptionsFrame_NoCombatAlpha:SetValueStep(.01)
	RuneHUD_OptionsFrame_NoCombatAlphaText:SetFormattedText("非戰鬥中透明度", RuneHUD_OptionsFrame_NoCombatAlpha:GetValue())
	RuneHUD_OptionsFrame_NoCombatAlpha:SetScript("OnValueChanged", function(self, value)
		RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetNumber(value)
		RHNoCombatAlpha = value
		if InCombatLockdown() == false and class == "DEATHKNIGHT" then
			RuneFrame:SetAlpha(RHNoCombatAlpha)
		end
	end)

	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetPoint("CENTER", 0, -17)
	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetWidth(50)
	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetHeight(20)
	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetMaxLetters(4)
	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetAutoFocus(false)
	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetJustifyH("CENTER")
	RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetScript("OnEnterPressed", function(self)
		RHNoCombatAlpha = RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:GetNumber()
		RuneHUD_OptionsFrame_NoCombatAlpha:SetValue(RHNoCombatAlpha)
		if InCombatLockdown() == false and class == "DEATHKNIGHT" then 
			RuneFrame:SetAlpha(RHNoCombatAlpha)
		end
		RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:ClearFocus()
	end)
		RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetScript("OnEscapePressed", function(self)
		RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:ClearFocus()
		RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetNumber(RHNoCombatAlpha)
	end)

	--Reset button
	RuneHUD_OptionsFrame_ResetButton:SetPoint("BOTTOMLEFT", 16, 16)
	RuneHUD_OptionsFrame_ResetButton:SetSize(140,25)
	RuneHUD_OptionsFrame_ResetButtonText:SetText("重置")
	RuneHUD_OptionsFrame_ResetButton:SetScript("OnClick", function(self,button,down)
		StaticPopup_Show ("RUNEHUD_RESET_POPUP")
	end)
	--Setting values when opening options frame
	function RuneHUD_Options_OnShow()
		RuneHUD_OptionsFrame_Scale:SetValue(RHScale)
		RuneHUD_OptionsFrame_BarNoCombat:SetChecked(RHBarNoCombat)
		RuneHUD_OptionsFrame_EnableBar:SetChecked(RHBarEnable)
		RuneHUD_OptionsFrame_BarCombatAlpha:SetValue(RHBarCombatAlpha)
		RuneHUD_OptionsFrame_BarNoCombatAlpha:SetValue(RHBarNoCombatAlpha)
		RuneHUD_OptionsFrame_BarPosition:SetValue(RHBarPosition)
		RuneHUD_OptionsFrame_CombatAlpha:SetValue(RHCombatAlpha)
		RuneHUD_OptionsFrame_NoCombatAlpha:SetValue(RHNoCombatAlpha)
		RuneHUD_OptionsFrame_BarHeight:SetValue(RHBarHeight)
		RuneHUD_OptionsFrame_BarWidth:SetValue(RHBarWidth)
	end

	RuneHUD_OptionsFrame:SetScript("OnShow", RuneHUD_Options_OnShow)
	
end

--Adding slash command
SLASH_RUNEHUD1, SLASH_RUNEHUD2 = '/runehud', '/rh';
local function handler(msg, editbox)
local command, rest = msg:match("^(%S*)%s*(.-)$")
	InterfaceOptionsFrame_OpenToCategory(RuneHUD_OptionsFrame);
	InterfaceOptionsFrame_OpenToCategory(RuneHUD_OptionsFrame);
end
SlashCmdList["RUNEHUD"] = handler;

--Reset check
StaticPopupDialogs["RUNEHUD_RESET_POPUP"] = {
		text = "是否確定要重置所有設定?",
		button1 = "是",
		button2 = "否",
		OnAccept = function()
			RHScale = 1.2
			RHNoCombatAlpha = 0.1
			RHCombatAlpha = 1
			RHBarCombatAlpha = 1
			RHBarNoCombatAlpha = 1
			RHBarWidth = 250
			RHBarHeight = 15
			RHBarPosition = -145
			RHBarEnable = true
			RHBarNoCombat = false
			
			if InCombatLockdown() == false then
				RuneHUDBar:Hide()
			end
			
			local fontSize = RHBarHeight-RHBarHeight*0,1
			RuneHUD_OptionsFrame_BarNoCombat:SetChecked(RHBarNoCombat)
			RuneHUD_OptionsFrame_EnableBar:SetChecked(RHBarEnable)
			RuneHUD_OptionsFrame_Scale:SetValue(RHScale)
			RuneHUD_OptionsFrame_EditBox_Scale:SetNumber(RHScale)
			RuneHUD_OptionsFrame_BarNoCombatAlpha:SetValue(RHBarNoCombatAlpha)
			RuneHUD_OptionsFrame_EditBox_BarNoCombatAlpha:SetNumber(RHBarNoCombatAlpha)
			RuneHUD_OptionsFrame_BarCombatAlpha:SetValue(RHBarCombatAlpha)
			RuneHUD_OptionsFrame_EditBox_BarCombatAlpha:SetNumber(RHBarCombatAlpha)
			RuneHUD_OptionsFrame_BarPosition:SetValue(RHBarPosition)
			RuneHUD_OptionsFrame_EditBox_BarPosition:SetNumber(RHBarPosition)
			RuneHUD_OptionsFrame_CombatAlpha:SetValue(RHCombatAlpha)
			RuneHUD_OptionsFrame_EditBox_CombatAlpha:SetNumber(RHCombatAlpha)
			RuneHUD_OptionsFrame_NoCombatAlpha:SetValue(RHNoCombatAlpha)
			RuneHUD_OptionsFrame_EditBox_NoCombatAlpha:SetNumber(RHNoCombatAlpha)
			RuneHUD_OptionsFrame_BarHeight:SetValue(RHBarHeight)
			RuneHUD_OptionsFrame_EditBox_BarHeight:SetNumber(RHBarHeight)
			if RHName == ("Flundrine" or "Flundran") and IsAddOnLoaded("SharedMedia") then
				RunicPowerValue:SetFont("Interface\\AddOns\\SharedMedia_MyMedia\\font\\Tw_Cen_MT_Bold.ttf", 15, "OUTLINE")
			else
				RunicPowerValue:SetFont("Fonts\\ARIALN.ttf", fontSize, "OUTLINE")
			end
			RuneHUD_OptionsFrame_BarWidth:SetValue(RHBarWidth)
			RuneHUD_OptionsFrame_EditBox_BarWidth:SetNumber(RHBarWidth)
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
}


local function RuneHUD_OnEvent(self, event, ...)
local classLocal, class = UnitClass("player")
	if class == "DEATHKNIGHT" then
		--Update runic power bar
		if event == "UNIT_POWER_FREQUENT" then
			if RHBarEnable == true then
				RuneHUDBar:SetValue(UnitPower("player"))
				RunicPowerValue:SetText(UnitPower("player"))
			else
				RuneHUDFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
			end
		--Leaving combat
		elseif event == "PLAYER_REGEN_ENABLED" and UnitInVehicleControlSeat("player") == false and UnitHasVehicleUI("player") == false then
			--RuneHUDBar:SetMinMaxValues(0, UnitPowerMax("player", SPELL_POWER_RUNIC_POWER))
			if RHBarEnable == true and 	RHBarNoCombat == true then
				RuneHUDBar:SetFrameStrata("LOW")
				RuneHUDBar:SetAlpha(RHBarNoCombatAlpha)
				RuneHUDBarDepleted:SetAlpha(RHBarNoCombatAlpha)
				RuneHUDBackground:SetAlpha(RHBarNoCombatAlpha)
			elseif RHBarNoCombat == false then
				RuneHUDBar:Hide()
			end
			RuneFrame:SetAlpha(RHNoCombatAlpha)
			RuneFrame:SetFrameStrata("LOW")
		--Entering combat
		elseif event == "PLAYER_REGEN_DISABLED" and UnitInVehicleControlSeat("player") == false and UnitHasVehicleUI("player") == false then
			--RuneHUDBar:SetMinMaxValues(0, UnitPowerMax("player", SPELL_POWER_RUNIC_POWER))
			if RHBarEnable == true then
				RuneHUDBar:Show()
				RuneHUDBar:SetAlpha(RHBarCombatAlpha)
				RuneHUDBarDepleted:SetAlpha(RHBarCombatAlpha)
				RuneHUDBackground:SetAlpha(RHBarCombatAlpha)
				RuneHUDBar:SetFrameStrata("HIGH")
			end
			
			RuneFrame:SetAlpha(RHCombatAlpha)
			RuneFrame:SetFrameStrata("HIGH")
		--Entering vehicle	
		elseif event == "UNIT_ENTERING_VEHICLE" and UnitInVehicleControlSeat("player") == true and  UnitHasVehicleUI("player") == true then
			RuneFrame:Hide()
			RuneHUDBar:Hide()
		--Leaving vehicle
		elseif event == "UNIT_EXITING_VEHICLE" then
			RuneFrame:Show()
			if InCombatLockdown() == true then
				RuneFrame:SetAlpha(RHCombatAlpha)
				if RHBarEnable == true then
					RuneHUDBar:Show()
					RuneHUDBar:SetAlpha(RHBarCombatAlpha)
					RuneHUDBarDepleted:SetAlpha(RHBarCombatAlpha)
					RuneHUDBackground:SetAlpha(RHBarCombatAlpha)
				else
					RuneHUDBar:Hide()
				end
			else
				RuneFrame:SetAlpha(RHNoCombatAlpha)
				if RHBarEnable == true and RHBarNoCombat == true then
					RuneHUDBar:Show()
					RuneHUDBar:SetAlpha(RHBarNoCombatAlpha)
					RuneHUDBarDepleted:SetAlpha(RHBarNoCombatAlpha)
					RuneHUDBackground:SetAlpha(RHBarNoCombatAlpha)
				else
					RuneHUDBar:Hide()
				end
			end	
		elseif event == "PLAYER_ENTERING_WORLD" then
			if UnitInVehicleControlSeat("player") == false and UnitHasVehicleUI("player") == false then
				if InCombatLockdown() == false then
					if RHBarEnable == true and RHBarNoCombat == false then
						RuneHUDBar:Hide()
					elseif RHBarEnable == true and RHBarNoCombat == true then
						RuneHUDBar:Show()
						RuneHUDBar:SetAlpha(RHBarNoCombatAlpha)
						RuneHUDBarDepleted:SetAlpha(RHBarNoCombatAlpha)
						RuneHUDBackground:SetAlpha(RHBarNoCombatAlpha)
						RuneHUDBar:SetFrameStrata("LOW")
					else
						RuneHUDBar:Hide()
					end
					RuneFrame:SetAlpha(RHNoCombatAlpha)	
					RuneFrame:SetFrameStrata("LOW")	
				else
					if RHBarEnable == true then
						RuneHUDBar:Show()
						RuneHUDBar:SetFrameStrata("HIGH")
						RuneHUDBar:SetAlpha(RHBarCombatAlpha)
						RuneHUDBarDepleted:SetAlpha(RHBarCombatAlpha)
						RuneHUDBackground:SetAlpha(RHBarCombatAlpha)
					else
						RuneHUDBar:Hide()
					end
					RuneFrame:SetAlpha(RHCombatAlpha)
					RuneFrame:SetFrameStrata("HIGH")
				end
			else
				RuneFrame:Hide()
			end
		--Setting up addon for first login
		elseif event == "ADDON_LOADED" then
			RuneFrame.Rune1:ClearAllPoints()
			RuneFrame.Rune2:ClearAllPoints()
			RuneFrame.Rune3:ClearAllPoints()
			RuneFrame.Rune4:ClearAllPoints()
			RuneFrame.Rune5:ClearAllPoints()
			RuneFrame.Rune6:ClearAllPoints()

			RuneFrame.Rune1:SetPoint("CENTER", UIParent, "CENTER", -x1, y1)
			RuneFrame.Rune2:SetPoint("CENTER", UIParent, "CENTER", -x2, y2)
			RuneFrame.Rune3:SetPoint("CENTER", UIParent, "CENTER", -x3, y3)
			RuneFrame.Rune4:SetPoint("CENTER", UIParent, "CENTER", x3, y3)
			RuneFrame.Rune5:SetPoint("CENTER", UIParent, "CENTER", x2, y2)
			RuneFrame.Rune6:SetPoint("CENTER", UIParent, "CENTER", x1, y1)

			RuneFrame.Rune1:EnableMouse(false)
			RuneFrame.Rune2:EnableMouse(false)
			RuneFrame.Rune3:EnableMouse(false)
			RuneFrame.Rune4:EnableMouse(false)
			RuneFrame.Rune5:EnableMouse(false)
			RuneFrame.Rune6:EnableMouse(false)
			
			if RHScale == nil then
				RHScale = 1.2
			end
			if RHName == nil then
				RHName = UnitName("player")
			end
			if RHNoCombatAlpha == nil then
				RHNoCombatAlpha = 0.1
			end
			if RHCombatAlpha == nil then
				RHCombatAlpha = 1
			end
			if RHBarWidth == nil then
				RHBarWidth = 250
			end
			if RHBarHeight == nil then
				RHBarHeight = 15
			end
			if RHBarEnable == nil then
				RHBarEnable = true
			end
			if RHBarPosition == nil then
				RHBarPosition = -145
			end
			if RHBarNoCombat == nil then
				RHBarNoCombat = false
			end
			if RHBarCombatAlpha == nil then
				RHBarCombatAlpha = 1
			end
			if RHBarNoCombatAlpha == nil then
				RHBarNoCombatAlpha = 1
			end

			RuneFrame:SetScale(RHScale)
	
			CreateFrame("StatusBar", "RuneHUDBar", UIParent)
			RuneHUDBar:CreateFontString("RunicPowerValue", "OVERLAY")
			RuneHUDBar:CreateTexture("RuneHUDBarDepleted", "BORDER")
			RuneHUDBar:CreateTexture("RuneHUDBackground", "BACKGROUND")
			RuneHUDBar:SetPoint("CENTER", UIParent, "CENTER", barX, RHBarPosition)
			RuneHUDBar:SetWidth(RHBarWidth)
			RuneHUDBar:SetHeight(RHBarHeight)
			if RHName == ("Flundrine" or "Flundran") and IsAddOnLoaded("SharedMedia") then
				RuneHUDBar:SetStatusBarTexture("Interface\\AddOns\\SharedMedia\\statusbar\\Flat")
			else
				RuneHUDBar:SetStatusBarTexture("Interface\\AddOns\\RuneHUD\\StatusBar")
			end
			RuneHUDBar:GetStatusBarTexture():SetHorizTile(false)
			RuneHUDBar:GetStatusBarTexture():SetVertTile(false)
			RuneHUDBar:SetStatusBarColor(0, 0.8, 1)
			RuneHUDBar:SetMinMaxValues(0, UnitPowerMax("player", SPELL_POWER_RUNIC_POWER)) 
			RuneHUDBar:SetValue(UnitPower("player"))

			RuneHUDBarDepleted:SetTexture("Interface\\AddOns\\RuneHUD\\Background")
			RuneHUDBarDepleted:SetAllPoints(true)
			RuneHUDBarDepleted:SetVertexColor(0.2, 0.2, 0.2)
	
			RuneHUDBackground:SetPoint("CENTER", RuneHUDBar, "CENTER", 0, 0)
			RuneHUDBackground:SetWidth(RHBarWidth + 2)
			RuneHUDBackground:SetHeight(RHBarHeight + 2)
			RuneHUDBackground:SetTexture("Interface\\AddOns\\RuneHUD\\Background")
			RuneHUDBackground:SetVertexColor(0, 0, 0)
			
			RunicPowerValue:SetPoint("CENTER", RuneHUDBar, "CENTER", 0, 0)
			local fontSize = (RHBarHeight-1)
			if RHName == ("Flundrine" or "Flundran") and IsAddOnLoaded("SharedMedia") then
				RunicPowerValue:SetFont("Interface\\AddOns\\SharedMedia_MyMedia\\font\\Tw_Cen_MT_Bold.ttf", 15, "OUTLINE")
			else
				RunicPowerValue:SetFont("Fonts\\ARIALN.ttf", fontSize, "OUTLINE")
			end
			RunicPowerValue:SetJustifyH("CENTER")
			RunicPowerValue:SetJustifyV("MIDDLE")
			RunicPowerValue:SetTextColor(1, 1, 1)
			RunicPowerValue:SetText(UnitPower("player"))
		elseif event == "UNIT_MAXPOWER" then
			RuneHUDBar:SetMinMaxValues(0, UnitPowerMax("player", SPELL_POWER_RUNIC_POWER))
		end
	else
		RuneHUDFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
		RuneHUDFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		RuneHUDFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
		RuneHUDFrame:UnregisterEvent("ADDON_LOADED")
		RuneHUDFrame:UnregisterEvent("UNIT_MAXPOWER")
		RuneHUDFrame:UnregisterEvent("UNIT_EXITING_VEHICLE")
		RuneHUDFrame:UnregisterEvent("UNIT_ENTERING_VEHICLE")
		RuneHUDFrame:UnregisterEvent("UNIT_POWER_FREQUENT")
	end
end


local f = CreateFrame("Frame","RuneHUDFrame",UIParent)
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("UNIT_MAXPOWER")
f:RegisterUnitEvent("UNIT_EXITING_VEHICLE","player")
f:RegisterUnitEvent("UNIT_ENTERING_VEHICLE","player")
f:RegisterUnitEvent("UNIT_POWER_FREQUENT","player")
f:SetScript("OnEvent", RuneHUD_OnEvent)
RuneHUDFrame.unit = "player"
RuneFrame:SetParent("RuneHUDFrame")