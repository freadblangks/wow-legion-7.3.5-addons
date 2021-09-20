local btn = CreateFrame("Button", "ObeliskQuestAcceptAllQuestsButton", GossipFrame, "UIPanelButtonTemplate")
btn:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
btn:RegisterEvent("GOSSIP_SHOW")
btn:RegisterEvent("QUEST_DETAIL")
btn:RegisterEvent("QUEST_GREETING")

btn:SetText("全部接受")
btn:SetWidth(btn:GetTextWidth() + 20)

local currentState = ""
local availableQuestsInfo = {}
local acceptQuestsCoroutine

local function SetState(state)
	currentState = state

	if currentState == "GOSSIP_SHOW" then
		btn:SetParent(GossipFrame)
		btn:SetPoint("BOTTOMLEFT", GossipFrame, "BOTTOMLEFT", 2, 4)
	elseif currentState == "QUEST_GREETING" then
		btn:SetParent(QuestFrameGreetingPanel)
		btn:SetPoint("BOTTOMLEFT", QuestFrameGreetingPanel, "BOTTOMLEFT", 2, 20)
	end
end

function GetAvailableQuestInfoTable()
	local temp = {}

	if currentState == "GOSSIP_SHOW" then
		local availableQuests = { GetGossipAvailableQuests() }

		for i = 1, GetNumGossipAvailableQuests() do
			temp[i] = {
				title = availableQuests[i * 7 - 6],
				-- level = availableQuests[i * 7 - 5],
				-- isTrivial = availableQuests[i * 7 - 4],
				-- frequency = availableQuests[i * 7 - 3],
				-- isRepeatable = availableQuests[i * 7 - 2],
				-- isLegendary = availableQuests[i * 7 - 1],
			}
		end
	elseif currentState == "QUEST_GREETING" then -- Handle QUEST_GREETING, because why consistency?
		for i = 1, GetNumAvailableQuests() do
			temp[i] = {
				title = GetAvailableTitle(i),
				-- level = GetAvailableLevel(1),
				-- isTrivial = isTrivial,
				-- frequency = frequency,
				-- isRepeatable = isRepeatable,
				-- isLegendary = isLegendary,
			}
		end
	else
		return nil
	end

	return temp
end

local function OnGossipShow()
	if acceptQuestsCoroutine and coroutine.status(acceptQuestsCoroutine) == "suspended" then
		coroutine.resume(acceptQuestsCoroutine)
		return
	end

	local shouldShow = false

	for _, v in pairs(GetAvailableQuestInfoTable()) do
		if not v.isIgnored and not shouldShow then
			shouldShow = true
		end
	end

	if shouldShow then
		btn:Show()
	else
		btn:Hide()
	end
end

function btn:GOSSIP_SHOW()
	SetState("GOSSIP_SHOW")
	OnGossipShow()
end

function btn:QUEST_GREETING()
	SetState("QUEST_GREETING")
	OnGossipShow()
end

local currentIndex = 0

function btn:QUEST_DETAIL()
	if availableQuestsInfo[currentIndex] then

		AcceptQuest()
		CloseQuest()

		-- If dead, delete coroutine. This makes sure we don't auto accept quests unintendedly
		if currentIndex == 1 then
			acceptQuestsCoroutine = nil
		end
	end

	currentIndex = currentIndex - 1
end

btn:SetScript("OnClick", function()
	wipe(availableQuestsInfo)
	availableQuestsInfo = GetAvailableQuestInfoTable()

	acceptQuestsCoroutine = coroutine.create(function()
		currentIndex = #availableQuestsInfo

		if currentIndex < 2 then
			if currentState == "GOSSIP_SHOW" then
				SelectGossipAvailableQuest(1)
			elseif currentState == "QUEST_GREETING" then
				SelectAvailableQuest(1)
			end
		else
			for i = currentIndex, 1, -1 do
				if currentState == "GOSSIP_SHOW" then
					SelectGossipAvailableQuest(i)
				elseif currentState == "QUEST_GREETING" then
					SelectAvailableQuest(i)
				end
				
				-- Don't yield on last iteration, to allow coroutine to die
				if i > 1 then
					coroutine.yield()
				end
			end
		end
	end)

	-- Start coroutine
	coroutine.resume(acceptQuestsCoroutine)
end)