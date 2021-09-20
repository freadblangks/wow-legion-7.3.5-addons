local anchorPoint = {
	"BOTTOM", -- Anchor point of text
	"TOP", -- Anchor point of parent frame
	0, -- x offset
	10 -- y offset
}

--ARGB
local questTitleColor = "FFFFD100"

----------------------------
---	End of customization ---
----------------------------

local _, ns = ...

--Generic nameplate stuff
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEAVING_WORD")
frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_REMOVED")
frame:RegisterEvent("QUEST_LOG_UPDATE")
frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
frame:RegisterEvent("NAME_PLATE_CREATED") --plate is created
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED") --plate is shown
frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED") --plate is hidden
frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

-- Enable quest information in tooltip, required for scraping
SetCVar("showQuestTrackingTooltips", "1")

local playerName = UnitName("player")

local WorldQuestsAndBonusObjectives = {
	-- [questName] = questId
}

local QuestCache = {
	-- [questName] = questId
}

function frame:PLAYER_LOGIN()
	local mapAreaId = GetCurrentMapAreaID()
	for _, wq in pairs(C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaId)) do
		if wq.inProgress then
			local questId = wq.questId
			local name = C_TaskQuest.GetQuestInfoByQuestID(questId)
			if name then
				WorldQuestsAndBonusObjectives[name] = questId
			end
		end
	end
end

function frame:QUEST_ACCEPTED(logIndex, questId)
	if IsQuestTask(questId) then --bonus objectives
		local name = C_TaskQuest.GetQuestInfoByQuestID(questId)
		if name then
			WorldQuestsAndBonusObjectives[name] = questId
		end
	end
end

function frame:QUEST_REMOVED(questId)
	local name = C_TaskQuest.GetQuestInfoByQuestID(questId)
	if name and WorldQuestsAndBonusObjectives[name] then
		WorldQuestsAndBonusObjectives[name] = nil
	end
end

local function GetTitle(text)
	if WorldQuestsAndBonusObjectives[text] then
		return text, "worldQuestTitle"
	elseif QuestCache[text] then
		return text, "questTitle"
	elseif text == GetMapNameByID(GetCurrentMapAreaID()) or ns.ZoneNameSubstitutions[text] then
		return text, "instanceTitle"
	end

	return nil
end

local function GetObjectiveText(text)
	--Matches a potential character name (if in group), and whatever remains
	local characterName, noProgressObjectiveText = string.match(text, "^ ?([^ ]-) %- (.+)$")

	--Matches prefix x/y style objective text
	local progressPrefix, progressObjectiveTextPrefix = string.match(text, " ?- (%d+/%d+) (.+)$")

	--Matches postfix x/y style objective text
	local progressObjectiveTextPostfix, progressPostfix = string.match(text, "%- (.+): (%d+/%d+)$")

	local objectiveTextType = "objectiveText"

	if characterName and characterName ~= "" and characterName ~= playerName then
		objectiveTextType = "objectiveTextParty"
	end

	if progressObjectiveTextPrefix or progressObjectiveTextPostfix or noProgressObjectiveText then
		return progressObjectiveTextPrefix or progressObjectiveTextPostfix or noProgressObjectiveText, progressPrefix or progressPostfix, characterName, objectiveTextType
	else 
		return nil
	end
end

local sourceTooltip = CreateFrame("GameTooltip", "ObeliskSourceTooltip", nil, "GameTooltipTemplate")

local function QuestTooltipScrape(unitId)
	sourceTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	sourceTooltip:SetUnit(unitId)

	local tooltipTexts = {}

	for i = 3, sourceTooltip:NumLines() do
		local str = _G["ObeliskSourceTooltipTextLeft" .. i]
		local text = str and str:GetText()
		if not text then return end

		tooltipTexts[#tooltipTexts + 1] = text
	end

	return tooltipTexts
end

local function ArrangeTexts(scrapedTexts)
	local arrangedTexts = {}

	for i = 1, #scrapedTexts do
		local titleText, titleType = GetTitle(scrapedTexts[i])
		local objectiveText, objectiveProgress, characterName, objectiveTextType = GetObjectiveText(scrapedTexts[i])

		if titleText then
			arrangedTexts[#arrangedTexts + 1] = {
				rawText = scrapedTexts[i],
				text = titleText,
				type = titleType,
				objectives = {
					--[num] = objectiveInfo
				}
			}
		elseif objectiveText and arrangedTexts[#arrangedTexts] and arrangedTexts[#arrangedTexts].objectives then
			local obj = arrangedTexts[#arrangedTexts].objectives

			obj[#obj + 1] = {
				rawText = scrapedTexts[i],
				text = objectiveText,
				progress = objectiveProgress,
				characterName = characterName,
				type = objectiveTextType
			}
		end
	end

	return arrangedTexts
end

local function FilterQuestTexts(arrangedTexts)
	local addedWorldQuests = {}
	local addedInstanceQuests = {}
	local filtered = {}

	for i = 1, #arrangedTexts do
		if not addedWorldQuests[arrangedTexts[i].text] and not addedInstanceQuests[arrangedTexts[i].text] then --Filter recurring world and instance quests, removing quests from party members. First one should be ours
			if arrangedTexts[i].type == "worldQuestTitle" then
				addedWorldQuests[arrangedTexts[i].text] = true
			elseif arrangedTexts[i].type == "instanceTitle" then
				addedInstanceQuests[arrangedTexts[i].text] = true
			end

			filtered[#filtered + 1] = ns.Util.CopyTable(arrangedTexts[i])
			filtered[#filtered].objectives = {}

			local obj = arrangedTexts[i].objectives

			--Objectives
			for k = 1, #obj do

				--Don't add quests from partymembers
				if obj[k].type == "objectiveTextParty" then
					filtered[#filtered].objectives[k] = nil --Remove already added title
					k = #obj --skip to end
				else
					filtered[#filtered].objectives[k] = ns.Util.CopyTable(obj[k])
				end
			end
		end
	end

	return filtered
end

local function FormatQuestText(filteredTexts)
	local formattedText = ""

	for i = 1, #filteredTexts do
		if formattedText ~= "" then
			formattedText = formattedText .. "|n"
		end

		formattedText = formattedText .. "|c" .. questTitleColor .. filteredTexts[i].text .. "|r"
		
		if filteredTexts[i].type == "worldQuestTitle" then
			local questId = WorldQuestsAndBonusObjectives[filteredTexts[i].text]
			local progress = C_TaskQuest.GetQuestProgressBarInfo(questId)

			if type(progress) == "number" then
				formattedText = formattedText .. " - " .. progress .. "%"
			end
		end

		--objectives
		local obj = filteredTexts[i].objectives
		for k = 1, #obj do
			formattedText = formattedText .. "|n"

			if obj[k].progress then
				formattedText = formattedText .. " - " .. obj[k].progress .. " " .. obj[k].text
			else
				formattedText = formattedText .. " - " .. obj[k].text
			end
		end
	end

	return formattedText
end

local function UpdateProgressText(frame)
	C_Timer.After(0.001, function()
		local tooltipTexts = QuestTooltipScrape(frame.unitId)
		local arrangedTexts = ArrangeTexts(tooltipTexts)
		local filteredTexts = FilterQuestTexts(arrangedTexts)
		local formattedText = FormatQuestText(filteredTexts)

		frame.questText:SetText(formattedText)
		frame:Show()
	end)
end

local HelperPlates = {
	-- [plate] = frame
}

local ActiveHelperPlates = {
	-- [plate] = frame
}

function frame:NAME_PLATE_CREATED(plate)
	local f = CreateFrame("Frame", nil, plate)
	f:Hide()
	f:SetAllPoints()

	local textAnchor, parentAnchor, x, y = unpack(anchorPoint)
	local questText = f:CreateFontString(nil, "BACKGROUND", "GameFontWhiteSmall")
	questText:SetPoint(textAnchor, f, parentAnchor, x, y)
	questText:SetJustifyH("LEFT")
	questText:SetJustifyV("CENTER")
	questText:SetShadowOffset(1, -1)
	f.questText = questText

	HelperPlates[plate] = f
end

function frame:NAME_PLATE_UNIT_ADDED(unitId)
	if GetUnitName(unitId) == playerName then return end

	local plate = C_NamePlate.GetNamePlateForUnit(unitId)
	local f = HelperPlates[plate]
	ActiveHelperPlates[plate] = f

	f.unitId = unitId

	UpdateProgressText(f)
end

function frame:NAME_PLATE_UNIT_REMOVED(unitId)
	local plate = C_NamePlate.GetNamePlateForUnit(unitId)
	local f = ActiveHelperPlates[plate]

	if f then
		f:Hide()
	end

	ActiveHelperPlates[plate] = nil
end

local function BuildQuestCache()
	wipe(QuestCache)

	for i = 1, GetNumQuestLogEntries() do
		local title, _, _, isHeader, _, isComplete, _, questId = GetQuestLogTitle(i)
		if not isHeader then
			QuestCache[title] = questId
		end
	end
end

function frame:UNIT_QUEST_LOG_CHANGED(unitId)
	if unitId == "player" then
		BuildQuestCache()
	end

	for _, frame in pairs(ActiveHelperPlates) do
		UpdateProgressText(frame)
	end
end

function frame:QUEST_LOG_UPDATE()
	BuildQuestCache()
end

function frame:PLAYER_LEAVING_WORD()
	frame:UnregisterEvent("QUEST_LOG_UPDATE")
end

function frame:PLAYER_ENTERING_WORLD()
	frame:RegisterEvent("QUEST_LOG_UPDATE")
end