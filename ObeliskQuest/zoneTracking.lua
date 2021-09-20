local _, ns = ...

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("LOADING_SCREEN_DISABLED")

-- Disable blizzard automatic quest tracking
SetCVar("autoQuestWatch", "0")

local function UntrackAll()
	for i = 1, GetNumQuestLogEntries() do
		if IsQuestWatched(i) then
			RemoveQuestWatch(i)
		end
	end
end

local function TrackByZone()
	UntrackAll()

	--local currentMapName = GetZoneText()
	SetMapToCurrentZone()
	local currentMapName = GetMapNameByID(GetCurrentMapAreaID())

	local i = 1
	local watchQuest = false

	while GetQuestLogTitle(i) do
		local title, _, _, isHeader, _, _, _, questID = GetQuestLogTitle(i)

		if isHeader then
			if title == currentMapName or (ns.ZoneNameSubstitutions[currentMapName] and tContains(ns.ZoneNameSubstitutions[currentMapName], title)) then
				watchQuest = true
			elseif watchQuest then
				break
			end
		elseif watchQuest then
			AddQuestWatch(GetQuestLogIndexByID(questID))
		end

		i = i + 1
	end

	--Consider the following for tracking world quests
	--[[

	for k, task in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(GetCurrentMapAreaID())) do
		if task.inProgress then
			-- track active world quests
			local questID = task.questId
			local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
			if questName then
				print(k, questID, questName)
			end
		end
	end

	]]
end

function frame:QUEST_ACCEPTED()
	TrackByZone()
end

function frame:ZONE_CHANGED_NEW_AREA()
	TrackByZone()
end

function frame:LOADING_SCREEN_DISABLED()
	TrackByZone()
end

