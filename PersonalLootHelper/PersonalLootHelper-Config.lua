function PLH_CreateOptionsPanel()

	local VERTICAL_SPACE_BETWEEN_ELEMENTS = 15

	--[[ Main Panel ]]--
	local PLHConfigFrame = CreateFrame('Frame', 'PLHConfigFrame', InterfaceOptionsFramePanelContainer)
	PLHConfigFrame:Hide()
	PLHConfigFrame.name = PLH_LONG_ADDON_NAME
	InterfaceOptions_AddCategory(PLHConfigFrame)

	--[[ Title ]]--
	local TitleLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	TitleLabel:SetPoint('TOPLEFT', PLHConfigFrame, 'TOPLEFT', 16, -16)
	TitleLabel:SetText(PLH_FULL_ADDON_NAME)

	-- [[ Version ]] --
	local AddonVersion = GetAddOnMetadata("PersonalLootHelper", "Version")
	local VersionLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	VersionLabel:SetPoint('BOTTOMLEFT', TitleLabel, 'BOTTOMRIGHT', 8, 0)
	VersionLabel:SetText('v' .. AddonVersion)

	--[[ Author ]]--
	local AuthorLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	AuthorLabel:SetPoint('TOPRIGHT', PLHConfigFrame, 'TOPRIGHT', -16, -24)
	AuthorLabel:SetText('作者：' .. PLH_AUTHOR_NAME)

	--[[ PLH_INCLUDE_BOE ]]--
	PLH_IncludeBOECheckbox = CreateFrame('CheckButton', 'PLHIncludeBOE', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_IncludeBOECheckbox:SetPoint('TOPLEFT', TitleLabel, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_IncludeBOECheckbox:SetChecked(PLH_INCLUDE_BOE)

	local IncludeBOELabel = PLH_IncludeBOECheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	IncludeBOELabel:SetPoint('LEFT', PLH_IncludeBOECheckbox, 'RIGHT', 0, 0)
	IncludeBOELabel:SetText('包含裝備綁定的物品')

	--[[ PLH_CURRENT_SPEC_ONLY ]]--
	PLH_CurrentSpecOnlyCheckbox = CreateFrame('CheckButton', 'PLHCurrentSpecOnly', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_CurrentSpecOnlyCheckbox:SetPoint('TOPLEFT', PLH_IncludeBOECheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_CurrentSpecOnlyCheckbox:SetChecked(PLH_CURRENT_SPEC_ONLY)

	local CurrentSpecOnlyLabel = PLH_CurrentSpecOnlyCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	CurrentSpecOnlyLabel:SetPoint('LEFT', PLH_CurrentSpecOnlyCheckbox, 'RIGHT', 0, 0)
	CurrentSpecOnlyLabel:SetText('只檢查當前專精')

	--[[ PLH_NOTIFY_GROUP ]]--
	PLH_NotifyGroupCheckbox = CreateFrame('CheckButton', 'PLHNotifyGroup', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_NotifyGroupCheckbox:SetPoint('TOPLEFT', PLH_CurrentSpecOnlyCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_NotifyGroupCheckbox:SetChecked(PLH_NOTIFY_GROUP)

	local NotifyGroupLabel = PLH_NotifyGroupCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	NotifyGroupLabel:SetPoint('LEFT', PLH_NotifyGroupCheckbox, 'RIGHT', 0, 0)
	NotifyGroupLabel:SetText('通知隊伍/團隊成員 (隨機團隊中會自動關閉)')

	--[[ PLH_COORDINATE_ROLLS ]]--
	PLH_CoordinateRollsCheckbox = CreateFrame('CheckButton', 'PLHCoordinateRolls', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_CoordinateRollsCheckbox:SetPoint('TOPLEFT', PLH_NotifyGroupCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_CoordinateRollsCheckbox:SetChecked(PLH_COORDINATE_ROLLS)

	PLH_CoordinateRollsLabel1 = PLH_CoordinateRollsCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	PLH_CoordinateRollsLabel1:SetPoint('LEFT', PLH_CoordinateRollsCheckbox, 'RIGHT', 0, 0)
	PLH_CoordinateRollsLabel1:SetText('發起骰裝 (只有隊長或助理)')

	PLH_CoordinateRollsLabel2 = PLH_CoordinateRollsCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	PLH_CoordinateRollsLabel2:SetPoint('TOPLEFT', PLH_CoordinateRollsLabel1, 'BOTTOMLEFT', 20, -10)
	PLH_CoordinateRollsLabel2:SetText('提出和管理分裝。玩家可以密隊長或助理 "交易" 或 "交易 [裝備連結]" 來開始擲骰要分享的裝備。')
	PLH_CoordinateRollsLabel2:SetWordWrap(true)
	PLH_CoordinateRollsLabel2:SetJustifyH('LEFT')
	PLH_CoordinateRollsLabel2:SetWidth(450)

	--[[ PLH_CHECK_CHARACTER_LEVEL ]]--
	PLH_CheckCharacterLevelCheckbox = CreateFrame('CheckButton', 'PLHCheckCharacterLevel', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_CheckCharacterLevelCheckbox:SetPoint('TOPLEFT', PLH_CoordinateRollsCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS*3)
	PLH_CheckCharacterLevelCheckbox:SetChecked(PLH_CHECK_CHARACTER_LEVEL)

	local CheckCharacterLevelLabel = PLH_CheckCharacterLevelCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	CheckCharacterLevelLabel:SetPoint('LEFT', PLH_CheckCharacterLevelCheckbox, 'RIGHT', 0, 0)
	CheckCharacterLevelLabel:SetText('不包含等級太低無法裝備物品的角色')

	--[[ PLH_HIGHLIGHT_RAID_FRAMES ]]--
	PLH_HighlightRaidFramesCheckbox = CreateFrame('CheckButton', 'PLHHighlightRaidFrames', PLHConfigFrame, 'InterfaceOptionsCheckButtonTemplate')
	PLH_HighlightRaidFramesCheckbox:SetPoint('TOPLEFT', PLH_CheckCharacterLevelCheckbox, 'BOTTOMLEFT', 0, -VERTICAL_SPACE_BETWEEN_ELEMENTS)
	PLH_HighlightRaidFramesCheckbox:SetChecked(PLH_HIGHLIGHT_RAID_FRAMES)

	local HighlightRaidFramesLabel = PLH_HighlightRaidFramesCheckbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	HighlightRaidFramesLabel:SetPoint('LEFT', PLH_HighlightRaidFramesCheckbox, 'RIGHT', 0, 0)
	HighlightRaidFramesLabel:SetText('在團隊框架中顯示可以交易的物品')

	--[[ PLH_HIGHLIGHT_SIZE ]]--
	PLH_HighlightSizeSlider = CreateFrame("Slider", "PLHHighlightSize", PLHConfigFrame, "OptionsSliderTemplate")
	PLHConfigFrame.ScalingSlider = slider
	PLH_HighlightSizeSlider:SetOrientation("HORIZONTAL")
	PLH_HighlightSizeSlider:SetMinMaxValues(10, 30)
	PLH_HighlightSizeSlider:SetValueStep(1)
	PLH_HighlightSizeSlider:SetObeyStepOnDrag(true)
	PLH_HighlightSizeSlider:SetWidth(180)
	PLH_HighlightSizeSlider:SetHeight(16)
	PLH_HighlightSizeSlider:SetPoint("LEFT", HighlightRaidFramesLabel, "RIGHT", 20, 0)
	_G[PLH_HighlightSizeSlider:GetName().."High"]:SetText("大")
	_G[PLH_HighlightSizeSlider:GetName().."Low"]:SetText("小")
	_G[PLH_HighlightSizeSlider:GetName().."Text"]:SetText("圖示大小")
	PLH_HighlightSizeSlider:SetValue(PLH_HIGHLIGHT_SIZE)
	
	--[[ Thank you message ]] --
	local ThankYouLabel = PLHConfigFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	ThankYouLabel:SetPoint('BOTTOM', PLHConfigFrame, 'BOTTOM', 0, 48)
	ThankYouLabel:SetText('感謝所有樂意將裝備分享給需要的人的玩家！\n你的慷慨大方讓魔獸處處充滿愛、世界更美好。\n你最棒了!!!')
	ThankYouLabel:SetWidth(400)
	ThankYouLabel:SetWordWrap(true)

	--[[ OnShow Event]]
	PLHConfigFrame:SetScript('OnShow', function(frame)
		PLH_IncludeBOECheckbox:SetChecked(PLH_INCLUDE_BOE)
		PLH_CurrentSpecOnlyCheckbox:SetChecked(PLH_CURRENT_SPEC_ONLY)
		PLH_CheckCharacterLevelCheckbox:SetChecked(PLH_CHECK_CHARACTER_LEVEL)
		PLH_HighlightRaidFramesCheckbox:SetChecked(PLH_HIGHLIGHT_RAID_FRAMES)
		PLH_NotifyGroupCheckbox:SetChecked(PLH_NOTIFY_GROUP)
		PLH_CoordinateRollsCheckbox:SetChecked(PLH_COORDINATE_ROLLS)
		PLH_HighlightSizeSlider:SetValue(PLH_HIGHLIGHT_SIZE)
	end)

	--[[ Okay Action ]]--
	function PLHConfigFrame.okay(arg1, arg2, arg3, ...)
		PLH_INCLUDE_BOE = PLH_IncludeBOECheckbox:GetChecked()
		PLH_CURRENT_SPEC_ONLY = PLH_CurrentSpecOnlyCheckbox:GetChecked()
		PLH_CHECK_CHARACTER_LEVEL = PLH_CheckCharacterLevelCheckbox:GetChecked()
		PLH_HIGHLIGHT_RAID_FRAMES = PLH_HighlightRaidFramesCheckbox:GetChecked()
		PLH_NOTIFY_GROUP = PLH_NotifyGroupCheckbox:GetChecked()
		PLH_COORDINATE_ROLLS = PLH_CoordinateRollsCheckbox:GetChecked()
		PLH_HIGHLIGHT_SIZE = PLH_HighlightSizeSlider:GetValue()
		PLH_ResizeHighlights()
	end

end