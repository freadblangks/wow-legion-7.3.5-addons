if mOnAr_OptionsFrameGeneral == nil then
	mOnAr_OptionsFrameGeneral = CreateFrame("FRAME", "mOnAr_OptionsFrameGeneral")
	mOnAr_OptionsFrameGeneral.name = "收藏-衣櫃"
	InterfaceOptions_AddCategory(mOnAr_OptionsFrameGeneral)

	mOnAr_OptionsFrameGeneral.TextTitle = mOnAr_OptionsFrameGeneral:CreateFontString("mOnAr_OptionsFrameGeneral_TextTitle", "ARTWORK", "GameFontNormalLarge")
	mOnAr_OptionsFrameGeneral.TextTitle:SetPoint("TOPLEFT", 16, -16)
	mOnAr_OptionsFrameGeneral.TextTitle:SetJustifyH("LEFT")
	mOnAr_OptionsFrameGeneral.TextTitle:SetJustifyV("TOP")
	mOnAr_OptionsFrameGeneral.TextTitle:SetText("mOnAr 的插件選項")

	mOnAr_OptionsFrameGeneral.TextSub = mOnAr_OptionsFrameGeneral:CreateFontString("mOnAr_OptionsFrameGeneral_TextSub", "ARTWORK", "GameFontHighlightSmall")
	mOnAr_OptionsFrameGeneral.TextSub:SetPoint("TOPLEFT", "mOnAr_OptionsFrameGeneral_TextTitle", "BOTTOMLEFT", 0, -8)
	mOnAr_OptionsFrameGeneral.TextSub:SetPoint("RIGHT", -32, 0)
	mOnAr_OptionsFrameGeneral.TextSub:SetJustifyH("LEFT")
	mOnAr_OptionsFrameGeneral.TextSub:SetJustifyV("TOP")
	mOnAr_OptionsFrameGeneral.TextSub:SetHeight(24)
	mOnAr_OptionsFrameGeneral.TextSub:SetText("這裡包含了由 mOnAr (Seamoon) 製作的所有插件的設定")
end
