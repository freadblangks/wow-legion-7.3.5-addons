		------------------------------------------------
		-- Paragon Reputation 1.18 by Sev US-Drakkari --
		------------------------------------------------

		  --[[	  Special thanks to Ammako for
				  helping me with the vars and
				  the options.						]]--

ParagonReputation = {} -- Localization
local L = ParagonReputation -- GetStrings
local reward = CreateFrame("FRAME")	-- RewardToast
local toast = false -- ActiveToastCheck
local rewardid = {
	[48976] = 2170, -- Argussian Reach
	[46777] = 2045, -- Armies of Legionfall
	[48977] = 2165, -- Army of the Light
	[46745] = 1900, -- Court of Farondis
	[46747] = 1883, -- Dreamweavers
	[46743] = 1828, -- Highmountain Tribes
	[46748] = 1859, -- The Nightfallen
	[46749] = 1894, -- The Wardens
	[46746] = 1948  -- Valarjar
}

reward:RegisterEvent("QUEST_ACCEPTED") --RegisterQuestAccepted

-- Paragon Tooltip
hooksecurefunc("ReputationParagonFrame_SetupParagonTooltip",function(frame, factionID)
	ReputationParagonTooltip:ClearLines()
	local factionName = GetFactionInfoByID(factionID)
	local _, _, rewardQuestID = C_Reputation.GetFactionParagonInfo(factionID)
	local description = PARAGON_REPUTATION_TOOLTIP_TEXT:format(factionName)
	local questIndex = GetQuestLogIndexByID(rewardQuestID)
	local text = GetQuestLogCompletionText(questIndex)
	local style = TOOLTIP_QUEST_REWARDS_STYLE_DEFAULT
	if text and text ~= "" then description = text end
	ReputationParagonTooltip:SetText(L["PARAGON"])
	ReputationParagonTooltip:AddLine(description, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, 1)
	GameTooltip_AddBlankLinesToTooltip(ReputationParagonTooltip, style.prefixBlankLineCount)
	ReputationParagonTooltip:AddLine(style.headerText, style.headerColor.r, style.headerColor.g, style.headerColor.b, style.wrapHeaderText)
	EmbeddedItemTooltip_SetItemByQuestReward(ReputationParagonTooltip.ItemTooltip, 1, rewardQuestID)
	ReputationParagonTooltip:Show()
end)

-- Reputation Watchbar (Thanks Hoalz)
hooksecurefunc("MainMenuBar_UpdateExperienceBars",function()
	local _, _, _, _, _, factionID = GetWatchedFactionInfo()
	if factionID and ReputationWatchBar:IsShown() and C_Reputation.IsFactionParagon(factionID) then
		ReputationWatchBar.StatusBar:SetStatusBarColor(ParagonReputationDB.r, ParagonReputationDB.g, ParagonReputationDB.b)
	end
end)

-- Reputation Watchbar - Paragon Tooltip Hide
hooksecurefunc("ReputationParagonWatchBar_OnEnter",function(self)
	local _, _, _, _, _, factionID = GetWatchedFactionInfo()
	local _, _, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
	if not hasRewardPending then
		ReputationParagonTooltip:Hide()
	end
end)

-- Reward Toast
reward:SetScript("OnEvent",function(self,event,...)
	if ParagonReputationDB.enable == true then
		local _, _, _, _, _, _, _, questID = GetQuestLogTitle(...)
		if rewardid[questID] and toast == false then
			toast = true
			if ParagonReputationDB.sound == true then PlaySound(44295, "master", true) end
			local name = GetFactionInfoByID(rewardid[questID])
			local questIndex = GetQuestLogIndexByID(questID)
			local text = GetQuestLogCompletionText(questIndex)
			local reset = ParagonReputationDB.fade + 1
			paragon_toast:EnableMouse(false)
			paragon_toast_title:SetText(name)
			paragon_toast_title:SetAlpha(0)
			paragon_toast_text:SetText(text)
			paragon_toast_text:SetAlpha(0)
			paragon_toast_reset_button:Hide()
			paragon_toast_lock_button:Hide()
			UIFrameFadeIn(paragon_toast, .5, 0, 1)
			C_Timer.After(.5,function()
				UIFrameFadeIn(paragon_toast_title, .5, 0, 1)
			end)
			C_Timer.After(.75,function()
				UIFrameFadeIn(paragon_toast_text, .5, 0, 1)
			end)
			C_Timer.After(ParagonReputationDB.fade,function()
				UIFrameFadeOut(paragon_toast, 1, 1, 0)
			end)
			C_Timer.After(reset,function()
				toast = false
				paragon_toast:Hide()
			end)
		end
	end
end)

-- Reputation Frame
hooksecurefunc("ReputationFrame_Update",function()
	ReputationFrame.paragonFramesPool:ReleaseAll()
	local numFactions = GetNumFactions()
	local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
	for i=1, NUM_FACTIONS_DISPLAYED, 1 do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar"..i]
		local factionBar = _G["ReputationBar"..i.."ReputationBar"]
		local factionStanding = _G["ReputationBar"..i.."ReputationBarFactionStanding"]
		if factionIndex <= numFactions then
			local _, _, _, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
			if factionID and C_Reputation.IsFactionParagon(factionID) then
				local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
				if currentValue then
					local value = mod(currentValue, threshold)
					if hasRewardPending then
						local paragonFrame = ReputationFrame.paragonFramesPool:Acquire()
						paragonFrame.factionID = factionID
						paragonFrame:SetPoint("RIGHT", factionRow, 11, 0)
						paragonFrame.Glow:SetShown(true)
						paragonFrame.Check:SetShown(true)
						paragonFrame:Show()
						value = value + threshold
					end
					factionBar:SetMinMaxValues(0, threshold)
					factionBar:SetValue(value)
					factionBar:SetStatusBarColor(ParagonReputationDB.r, ParagonReputationDB.g, ParagonReputationDB.b)
					factionRow.rolloverText = HIGHLIGHT_FONT_COLOR_CODE.." "..format(REPUTATION_PROGRESS_FORMAT, BreakUpLargeNumbers(value), BreakUpLargeNumbers(threshold))..FONT_COLOR_CODE_CLOSE
					if ParagonReputationDB.default == true then
						factionStanding:SetText(L["PARAGON"])
						factionRow.standingText = L["PARAGON"]
					elseif ParagonReputationDB.total == true  then
						factionStanding:SetText(BreakUpLargeNumbers(value))
						factionRow.standingText = BreakUpLargeNumbers(value)
					elseif ParagonReputationDB.value == true then
						factionStanding:SetText(" "..BreakUpLargeNumbers(value).." / "..BreakUpLargeNumbers(threshold))
						factionRow.standingText = (" "..BreakUpLargeNumbers(value).." / "..BreakUpLargeNumbers(threshold))
						factionRow.rolloverText = nil					
					elseif ParagonReputationDB.deficit == true then
						if hasRewardPending then
							value = value - threshold
							factionStanding:SetText("+"..BreakUpLargeNumbers(value))
							factionRow.standingText = "+"..BreakUpLargeNumbers(value)
						else
							value = threshold - value
							factionStanding:SetText(BreakUpLargeNumbers(value))
							factionRow.standingText = BreakUpLargeNumbers(value)
						end
						factionRow.rolloverText = nil
					end
				end
			end
		else
			factionRow:Hide()
		end
	end
end)