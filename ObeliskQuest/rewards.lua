local frame = CreateFrame("Frame", nil, QuestFrame)
frame:SetSize(20, 20)
frame:SetFrameStrata("HIGH")

frame.tex = frame:CreateTexture(nil, "OVERLAY")
frame.tex:SetAtlas("Auctioneer")
frame.tex:SetAllPoints()

frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
frame:RegisterEvent("QUEST_COMPLETE")
frame:RegisterEvent("QUEST_DETAIL")
frame:RegisterEvent("QUEST_TURNED_IN")
frame:RegisterEvent("QUEST_FINISHED")

local function GetMax(t)
	if #t == 0 then return nil, nil end

	local key, value = 1, t[1]

	for i = 2, #t do
		if t[i] > value then
			key, value = i, t[i]
		end
	end

	return key, value
end

function frame:QUEST_COMPLETE()
	local numRewards = GetNumQuestChoices()
	local itemValues = {}

	if numRewards > 0 then
		for i = 1, numRewards do
			local itemLink = GetQuestItemLink("choice", i)
			local rewardValue = select(11, GetItemInfo(tostring(itemLink)))

			table.insert(itemValues, rewardValue)
		end

		local key = GetMax(itemValues)
		self:SetPoint("BOTTOMRIGHT", "QuestInfoRewardsFrameQuestInfoItem" .. key, "BOTTOMRIGHT", -3, 3)
		self:Show()
	end
end

function frame:QUEST_TURNED_IN()
	self:Hide()
end

function frame:QUEST_DETAIL()
	self:Hide()
end

function frame:QUEST_FINISHED()
	self:Hide()
end