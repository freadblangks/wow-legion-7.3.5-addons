		------------------------------------------------
		-- Paragon Reputation 1.18 by Sev US-Drakkari --
		------------------------------------------------

		  --[[	  Special thanks to Ammako for
				  helping me with the vars and
				  the options.						]]--		

local L = ParagonReputation -- GetStrings
local vars = CreateFrame("FRAME") -- Variables

vars:RegisterEvent("ADDON_LOADED") --RegisterAddonLoad

-- Toast Frame
paragon_toast = CreateFrame("FRAME", "paragon_toast", UIParent)
paragon_toast:SetPoint("CENTER", UIParent, "CENTER", 0, 256)
paragon_toast:SetWidth(302)
paragon_toast:SetHeight(70)
paragon_toast:SetMovable(true)
paragon_toast:SetUserPlaced(false)
paragon_toast:SetClampedToScreen(true)
paragon_toast:RegisterForDrag("LeftButton")
paragon_toast:SetScript("OnDragStart", paragon_toast.StartMoving)
paragon_toast:SetScript("OnDragStop", paragon_toast.StopMovingOrSizing)
paragon_toast:Hide()

-- Toast Texture
paragon_toast_texture = paragon_toast:CreateTexture(nil, "BACKGROUND")
paragon_toast_texture:SetTexture("Interface\\AddOns\\ParagonReputation\\toast")
paragon_toast_texture:SetPoint("CENTER", paragon_toast, "CENTER", 0, 0)
paragon_toast.texture = paragon_toast_texture

-- Toast Title
paragon_toast_title = paragon_toast:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
paragon_toast_title:SetPoint("TOPLEFT", 23, -10)
paragon_toast_title:SetWidth(260)
paragon_toast_title:SetHeight(16)
paragon_toast_title:SetJustifyV("TOP")
paragon_toast_title:SetJustifyH("LEFT")

-- Toast Text
paragon_toast_text = paragon_toast:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
paragon_toast_text:SetPoint("TOPLEFT", paragon_toast_title, 1, -23)
paragon_toast_text:SetWidth(258)
paragon_toast_text:SetHeight(32)			
paragon_toast_text:SetJustifyV("TOP")
paragon_toast_text:SetJustifyH("LEFT")

-- Toast Reset Button
paragon_toast_reset_button = CreateFrame("Button", nil, paragon_toast, "OptionsButtonTemplate")
paragon_toast_reset_button:SetPoint("BOTTOMLEFT", paragon_toast, "BOTTOMLEFT", 5, 6)
paragon_toast_reset_button:SetWidth(146)
paragon_toast_reset_button:SetScript("OnClick",function()
	paragon_toast:ClearAllPoints()
	paragon_toast:SetPoint("CENTER", UIParent, "CENTER", 0, 256)
end)

-- Toast Lock Button
paragon_toast_lock_button = CreateFrame("Button", nil, paragon_toast, "OptionsButtonTemplate")
paragon_toast_lock_button:SetPoint("BOTTOMRIGHT", paragon_toast, "BOTTOMRIGHT", -5, 6)
paragon_toast_lock_button:SetWidth(146)
paragon_toast_lock_button:SetScript("OnClick",function()
	ParagonReputationDB.x = paragon_toast:GetLeft()
	ParagonReputationDB.y = paragon_toast:GetTop()
	InterfaceOptionsFrame_OpenToCategory(L["Paragon Reputation"])
	paragon_toast:Hide()
	paragon_toast_lock_button:Hide()
	paragon_toast_reset_button:Hide()
	paragon_toast_title:SetText("")
	paragon_toast_text:SetText("")
	paragon_toast:EnableMouse(false)
end)

-- Load Variables
vars:SetScript("OnEvent",function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "ParagonReputation" then
		if ParagonReputationDB == nil then
			ParagonReputationDB = {
				-- Color Values
				r = 0, -- Color Red
				g = .5, -- Color Green
				b = .9, -- Color Blue

				-- Toggle Color
				bluecheck = true, -- Toggle Paragon Blue
				greencheck = false, -- Toggle Default Green
				yellowcheck = false, -- Toggle Neutral Yellow
				orangecheck = false, -- Toggle Unfriendly Orange
				redcheck = false, -- Toggle Lightish Red

				-- Toggle Text
				default = true, -- Toggle Paragon (0/10,000)
				exalted = false, -- Toggle Exalted (0/10,000)
				total = false, -- Toggle 0 (0/10,000)
				value = false, -- Toggle 0/10,000
				deficit = false, -- Toggle Reputation Deficit

				-- Toast Values
				enable = true, -- Toggle Toast
				sound = true, -- Toggle Sound
				fade = 5, -- Slider Fade
				x = 0, -- X Position Toast
				y = 256 -- Y Position Toast
			}
		else
			-- Color Values
			if ParagonReputationDB.r == nil then ParagonReputationDB.r = 0 end -- Color Red
			if ParagonReputationDB.g == nil then ParagonReputationDB.g = .5 end -- Color Green
			if ParagonReputationDB.b == nil then ParagonReputationDB.b = .9 end -- Color Blue

			-- Toggle Color	
			if ParagonReputationDB.bluecheck == nil then ParagonReputationDB.bluecheck = true end -- Toggle Paragon Blue
			if ParagonReputationDB.greencheck == nil then ParagonReputationDB.greencheck = false end -- Toggle Default Green
			if ParagonReputationDB.yellowcheck == nil then ParagonReputationDB.yellowcheck = false end -- Toggle Neutral Yellow
			if ParagonReputationDB.orangecheck == nil then ParagonReputationDB.orangecheck = false end -- Toggle Unfriendly Orange
			if ParagonReputationDB.redcheck == nil then ParagonReputationDB.redcheck = false end -- Toggle Lightish Red

			-- Toggle Text
			if ParagonReputationDB.default == nil then ParagonReputationDB.default = true end -- Toggle Paragon (0/10,000)
			if ParagonReputationDB.exalted == nil then ParagonReputationDB.exalted = false end -- Toggle Exalted (0/10,000)
			if ParagonReputationDB.total == nil then ParagonReputationDB.total = false end -- Toggle 0 (0/10,000)
			if ParagonReputationDB.value == nil then ParagonReputationDB.value = false end -- Toggle 0/10,000
			if ParagonReputationDB.deficit == nil then ParagonReputationDB.deficit = false end -- Toggle Reputation Deficit

			-- Toast Values
			if ParagonReputationDB.enable == nil then ParagonReputationDB.enable = false end -- Toggle Toast
			if ParagonReputationDB.sound == nil then ParagonReputationDB.sound = true end -- Toggle Sound
			if ParagonReputationDB.fade == nil then ParagonReputationDB.fade = 5 end -- Slider Fade
			if ParagonReputationDB.x == nil then ParagonReputationDB.x = 0 end -- X Position Toast
			if ParagonReputationDB.y == nil then ParagonReputationDB.y = 256 end -- Y Position Toast
		end
		ParagonReputation:Position() -- Anchor Position
		ParagonReputation:Options() -- Paragon Options
	end
end)

-- Anchor Position
function ParagonReputation:Position()
	paragon_toast:ClearAllPoints()
	if ParagonReputationDB.x ~= 0 or ParagonReputationDB.y ~= 256 then
		paragon_toast:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", ParagonReputationDB.x, ParagonReputationDB.y)
	else
		paragon_toast:SetPoint("CENTER", UIParent, "CENTER", 0, 256)
	end
end

-- Paragon Options
function ParagonReputation:Options()
	local paragon_options = CreateFrame("FRAME", "paragon_options")
	paragon_options.name = L["Paragon Reputation"]
	InterfaceOptions_AddCategory(paragon_options)

	-- Title
	local title_options = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title_options:SetPoint("TOPLEFT", 16, -16)
	title_options:SetText(L["|cff0088eeParagon|r Reputation |cff0088eev"]..GetAddOnMetadata("ParagonReputation", "Version").."|r")

	-- Description
	local desc_title = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	desc_title:SetPoint("TOPLEFT", title_options, "BOTTOMLEFT", 0, -8)
	desc_title:SetText(L["OPTIONDESC"])
	desc_title:SetJustifyH("LEFT")
	desc_title:SetWidth(592)

	-- Color Label
	local label_color = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	label_color:SetPoint("TOPLEFT", desc_title, "BOTTOMLEFT", -1, -9)
	label_color:SetText(L["LABEL001"])

	-- Text Label
	local label_text = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	label_text:SetPoint("LEFT", label_color, "LEFT", 210, -1)
	label_text:SetText(L["LABEL002"])

	-- Paragon Blue CheckButton
	local check_blue = CreateFrame("CheckButton", "check_blue", paragon_options, "ChatConfigCheckButtonTemplate")
	check_blue:SetPoint("TOPLEFT", label_color, "BOTTOMLEFT", -2, 0)
	check_blue:SetWidth(30)
	check_blue:SetHeight(30)
	_G[check_blue:GetName().."Text"]:SetText("|cff0088ee"..L["BLUE"].."|r")
	check_blue:SetChecked(ParagonReputationDB.bluecheck)
	check_blue:SetScript("OnClick",function()
		check_blue:SetChecked(true)
		check_green:SetChecked(false)
		check_yellow:SetChecked(false)
		check_orange:SetChecked(false)
		check_red:SetChecked(false)
		ParagonReputationDB.bluecheck = true
		ParagonReputationDB.greencheck = false
		ParagonReputationDB.yellowcheck = false
		ParagonReputationDB.orangecheck = false
		ParagonReputationDB.redcheck = false
		ParagonReputationDB.r = 0
		ParagonReputationDB.g = .5
		ParagonReputationDB.b = .9
		MainMenuBar_UpdateExperienceBars()
	end)

	-- Default Green CheckButton
	local check_green = CreateFrame("CheckButton", "check_green", paragon_options, "ChatConfigCheckButtonTemplate")
	check_green:SetPoint("TOPLEFT", label_color, "BOTTOMLEFT", -2, -20)
	check_green:SetWidth(30)
	check_green:SetHeight(30)
	_G[check_green:GetName().."Text"]:SetText("|cff009919"..L["GREEN"].."|r")
	check_green:SetChecked(ParagonReputationDB.greencheck)
	check_green:SetScript("OnClick",function()
		check_blue:SetChecked(false)
		check_green:SetChecked(true)
		check_yellow:SetChecked(false)
		check_orange:SetChecked(false)
		check_red:SetChecked(false)
		ParagonReputationDB.bluecheck = false
		ParagonReputationDB.greencheck = true
		ParagonReputationDB.yellowcheck = false
		ParagonReputationDB.orangecheck = false
		ParagonReputationDB.redcheck = false		
		ParagonReputationDB.r = 0
		ParagonReputationDB.g = .6
		ParagonReputationDB.b = .1
		MainMenuBar_UpdateExperienceBars()
	end)

	-- Neutral Yellow CheckButton
	local check_yellow = CreateFrame("CheckButton", "check_yellow", paragon_options, "ChatConfigCheckButtonTemplate")
	check_yellow:SetPoint("TOPLEFT", label_color, "BOTTOMLEFT", -2, -40)
	check_yellow:SetWidth(30)
	check_yellow:SetHeight(30)
	_G[check_yellow:GetName().."Text"]:SetText("|cffe6b200"..L["YELLOW"].."|r")
	check_yellow:SetChecked(ParagonReputationDB.yellowcheck)
	check_yellow:SetScript("OnClick",function()
		check_blue:SetChecked(false)
		check_green:SetChecked(false)
		check_yellow:SetChecked(true)
		check_orange:SetChecked(false)
		check_red:SetChecked(false)
		ParagonReputationDB.bluecheck = false
		ParagonReputationDB.greencheck = false
		ParagonReputationDB.yellowcheck = true
		ParagonReputationDB.orangecheck = false
		ParagonReputationDB.redcheck = false		
		ParagonReputationDB.r = .9
		ParagonReputationDB.g = .7
		ParagonReputationDB.b = 0
		MainMenuBar_UpdateExperienceBars()
	end)

	-- Unfriendly Orange CheckButton
	local check_orange = CreateFrame("CheckButton", "check_orange", paragon_options, "ChatConfigCheckButtonTemplate")
	check_orange:SetPoint("TOPLEFT", label_color, "BOTTOMLEFT", -2, -60)
	check_orange:SetWidth(30)
	check_orange:SetHeight(30)
	_G[check_orange:GetName().."Text"]:SetText("|cffbf4500"..L["ORANGE"].."|r")
	check_orange:SetChecked(ParagonReputationDB.orangecheck)
	check_orange:SetScript("OnClick",function()
		check_blue:SetChecked(false)
		check_green:SetChecked(false)
		check_yellow:SetChecked(false)
		check_orange:SetChecked(true)
		check_red:SetChecked(false)
		ParagonReputationDB.bluecheck = false
		ParagonReputationDB.greencheck = false
		ParagonReputationDB.yellowcheck = false
		ParagonReputationDB.orangecheck = true
		ParagonReputationDB.redcheck = false		
		ParagonReputationDB.r = .75
		ParagonReputationDB.g = .27
		ParagonReputationDB.b = 0
		MainMenuBar_UpdateExperienceBars()
	end)

	-- Lightish Red CheckButton
	local check_red = CreateFrame("CheckButton", "check_red", paragon_options, "ChatConfigCheckButtonTemplate")
	check_red:SetPoint("TOPLEFT", label_color, "BOTTOMLEFT", -2, -80)
	check_red:SetWidth(30)
	check_red:SetHeight(30)
	_G[check_red:GetName().."Text"]:SetText("|cffff40a0"..L["RED"].."|r")
	check_red:SetChecked(ParagonReputationDB.redcheck)
	check_red:SetScript("OnClick",function()
		check_blue:SetChecked(false)
		check_green:SetChecked(false)
		check_yellow:SetChecked(false)
		check_orange:SetChecked(false)
		check_red:SetChecked(true)
		ParagonReputationDB.bluecheck = false
		ParagonReputationDB.greencheck = false
		ParagonReputationDB.yellowcheck = false
		ParagonReputationDB.orangecheck = false
		ParagonReputationDB.redcheck = true		
		ParagonReputationDB.r = 1
		ParagonReputationDB.g = .25
		ParagonReputationDB.b = .62
		MainMenuBar_UpdateExperienceBars()
	end)

	-- Paragon CheckButton
	local check_paragon = CreateFrame("CheckButton", "check_paragon", paragon_options, "ChatConfigCheckButtonTemplate")
	check_paragon:SetPoint("TOPLEFT", label_text, "BOTTOMLEFT", -4, 0)
	check_paragon:SetWidth(30)
	check_paragon:SetHeight(30)
	_G[check_paragon:GetName().."Text"]:SetText(L["PARAGON"].." |cffa0a0a0(0/10,000)|r")
	check_paragon:SetChecked(ParagonReputationDB.default)
	check_paragon:SetScript("OnClick",function()
		check_paragon:SetChecked(true)
		check_exalted:SetChecked(false)
		check_current:SetChecked(false)
		check_value:SetChecked(false)
		check_deficit:SetChecked(false)
		ParagonReputationDB.default = true
		ParagonReputationDB.exalted = false
		ParagonReputationDB.total = false
		ParagonReputationDB.value = false
		ParagonReputationDB.deficit = false
	end)

	-- Exalted CheckButton
	local check_exalted = CreateFrame("CheckButton", "check_exalted", paragon_options, "ChatConfigCheckButtonTemplate")
	check_exalted:SetPoint("TOPLEFT", label_text, "BOTTOMLEFT", -4, -20)
	check_exalted:SetWidth(30)
	check_exalted:SetHeight(30)
	_G[check_exalted:GetName().."Text"]:SetText(FACTION_STANDING_LABEL8.." |cffa0a0a0(0/10,000)|r")
	check_exalted:SetChecked(ParagonReputationDB.exalted)
	check_exalted:SetScript("OnClick",function()
		check_paragon:SetChecked(false)
		check_exalted:SetChecked(true)
		check_current:SetChecked(false)
		check_value:SetChecked(false)
		check_deficit:SetChecked(false)
		ParagonReputationDB.default = false
		ParagonReputationDB.exalted = true
		ParagonReputationDB.total = false
		ParagonReputationDB.value = false
		ParagonReputationDB.deficit = false
	end)

	-- 0 (0/10,000) CheckButton
	local check_current = CreateFrame("CheckButton", "check_current", paragon_options, "ChatConfigCheckButtonTemplate")
	check_current:SetPoint("TOPLEFT", label_text, "BOTTOMLEFT", -4, -40)
	check_current:SetWidth(30)
	check_current:SetHeight(30)
	_G[check_current:GetName().."Text"]:SetText("0 |cffa0a0a0(0/10,000)|r")
	check_current:SetChecked(ParagonReputationDB.total)
	check_current:SetScript("OnClick",function()
		check_paragon:SetChecked(false)
		check_exalted:SetChecked(false)
		check_current:SetChecked(true)
		check_value:SetChecked(false)
		check_deficit:SetChecked(false)
		ParagonReputationDB.default = false
		ParagonReputationDB.exalted = false
		ParagonReputationDB.total = true
		ParagonReputationDB.value = false
		ParagonReputationDB.deficit = false
	end)

	-- 0/10,000 CheckButton
	local check_value = CreateFrame("CheckButton", "check_value", paragon_options, "ChatConfigCheckButtonTemplate")
	check_value:SetPoint("TOPLEFT", label_text, "BOTTOMLEFT", -4, -60)
	check_value:SetWidth(30)
	check_value:SetHeight(30)
	_G[check_value:GetName().."Text"]:SetText("0/10,000")
	check_value:SetChecked(ParagonReputationDB.value)
	check_value:SetScript("OnClick",function()
		check_paragon:SetChecked(false)
		check_exalted:SetChecked(false)
		check_current:SetChecked(false)
		check_value:SetChecked(true)
		check_deficit:SetChecked(false)
		ParagonReputationDB.default = false
		ParagonReputationDB.exalted = false
		ParagonReputationDB.total = false
		ParagonReputationDB.value = true
		ParagonReputationDB.deficit = false
	end)

	-- Deficit CheckButton
	local check_deficit = CreateFrame("CheckButton", "check_deficit", paragon_options, "ChatConfigCheckButtonTemplate")
	check_deficit:SetPoint("TOPLEFT", label_text, "BOTTOMLEFT", -4, -80)
	check_deficit:SetWidth(30)
	check_deficit:SetHeight(30)
	_G[check_deficit:GetName().."Text"]:SetText(L["DEFICIT"])
	check_deficit:SetChecked(ParagonReputationDB.deficit)
	check_deficit:SetScript("OnClick",function()
		check_paragon:SetChecked(false)
		check_exalted:SetChecked(false)
		check_current:SetChecked(false)
		check_value:SetChecked(false)
		check_deficit:SetChecked(true)
		ParagonReputationDB.default = false
		ParagonReputationDB.exalted = false
		ParagonReputationDB.total = false
		ParagonReputationDB.value = false
		ParagonReputationDB.deficit = true
	end)

	-- Toast Label
	local label_toast = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	label_toast:SetPoint("TOPLEFT", desc_title, "BOTTOMLEFT", 25, -140)
	label_toast:SetText(L["LABEL003"])

	-- Toast CheckButton
	local check_toast = CreateFrame("CheckButton", nil, paragon_options, "ChatConfigCheckButtonTemplate")
	check_toast:SetPoint("RIGHT", label_toast, "LEFT", 2, 0)
	check_toast:SetWidth(30)
	check_toast:SetHeight(30)
	check_toast:SetChecked(ParagonReputationDB.enable)
	check_toast:SetScript("OnClick",function()
		ParagonReputationDB.enable = check_toast:GetChecked()		
	end)	

	-- Toast Description
	local desc_toast = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	desc_toast:SetPoint("TOPLEFT", label_toast, "BOTTOMLEFT", -25, -8)
	desc_toast:SetText(L["TOASTDESC"])
	desc_toast:SetJustifyH("LEFT")
	desc_toast:SetWidth(592)

	-- Fade Selected Time
	local slider_fade_value = paragon_options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	slider_fade_value:SetPoint("TOPLEFT", desc_toast, "BOTTOMLEFT", 63, -38.5)
	slider_fade_value:SetText(ParagonReputationDB.fade.."s")
	slider_fade_value:SetJustifyH("CENTER")
	slider_fade_value:SetWidth(32)

	-- Fade Timer Slider
	local slider_fade = CreateFrame("Slider", "slider_fade", paragon_options, "OptionsSliderTemplate")
	slider_fade:ClearAllPoints()
	slider_fade:SetPoint("TOPLEFT", desc_toast, "BOTTOMLEFT", 4, -24)
	slider_fade:SetMinMaxValues(3, 10)
	slider_fade:SetValue(ParagonReputationDB.fade)
	slider_fade:SetValueStep(1)
	slider_fade:SetObeyStepOnDrag(true)
	slider_fade:SetOrientation("HORIZONTAL")
	_G[slider_fade:GetName() .. "Low"]:SetText("3s")
	_G[slider_fade:GetName() .. "High"]:SetText("10s")
	_G[slider_fade:GetName() .. "Text"]:SetText(AUCTION_DURATION)
	slider_fade:SetScript("OnValueChanged",function() 
		ParagonReputationDB.fade = slider_fade:GetValue()
		slider_fade_value:SetText(slider_fade:GetValue().."s")		
	end)

	-- Sound CheckButton
	local check_sound = CreateFrame("CheckButton", "check_sound", paragon_options, "ChatConfigCheckButtonTemplate")
	check_sound:SetPoint("TOPLEFT", desc_toast, "BOTTOMLEFT", -3, -53)
	check_sound:SetWidth(30)
	check_sound:SetHeight(30)
	_G[check_sound:GetName().."Text"]:SetText(L["SOUND"])
	check_sound:SetChecked(ParagonReputationDB.sound)
	check_sound:SetScript("OnClick",function()
		ParagonReputationDB.sound = check_sound:GetChecked()
	end)

	-- Toggle Anchor
	local button_anchor_toggle = CreateFrame("Button", nil, paragon_options, "OptionsButtonTemplate")
	button_anchor_toggle:SetPoint("TOPLEFT", desc_toast, "BOTTOMLEFT", 208, -10)
	button_anchor_toggle:SetText(L["ANCHOR"])
	button_anchor_toggle:SetWidth(192)
	button_anchor_toggle:SetScript("OnClick",function()
		if paragon_toast:IsVisible() then
			ParagonReputationDB.x = paragon_toast:GetLeft()
			ParagonReputationDB.y = paragon_toast:GetTop()
			paragon_toast:Hide()
			paragon_toast_reset_button:Hide()
			paragon_toast_lock_button:Hide()
			paragon_toast_title:SetText("")
			paragon_toast_text:SetText("")
			paragon_toast:EnableMouse(false)
		else
			HideUIPanel(InterfaceOptionsFrame)
			HideUIPanel(GameMenuFrame)
			paragon_toast:Show()
			paragon_toast_reset_button:Show()
			paragon_toast_lock_button:Show()
			paragon_toast:SetAlpha(1)
			paragon_toast_title:SetAlpha(1)
			paragon_toast_text:SetAlpha(1)
			paragon_toast:EnableMouse(true)
			paragon_toast_title:SetText(MOVE_FRAME)
			paragon_toast_text:SetText("")
			paragon_toast_reset_button:SetText(RESET_POSITION)
			paragon_toast_lock_button:SetText(LOCK)
		end
	end)

	-- Reset Anchor
	local button_anchor_toggle = CreateFrame("Button", nil, paragon_options, "OptionsButtonTemplate")
	button_anchor_toggle:SetPoint("TOPLEFT", desc_toast, "BOTTOMLEFT", 208, -32)
	button_anchor_toggle:SetText(RESET_POSITION)
	button_anchor_toggle:SetWidth(192)
	button_anchor_toggle:SetScript("OnClick",function()
		paragon_toast:ClearAllPoints()
		paragon_toast:SetPoint("CENTER", UIParent, "CENTER", 0, 256)
	end)

end