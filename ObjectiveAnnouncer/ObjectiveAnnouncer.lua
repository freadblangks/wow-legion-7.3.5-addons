local NAME, S = ...
S.VERSION = GetAddOnMetadata(NAME, "Version")
S.NUMVERSION = 7300	-- 7.3.0
S.NAME = "Objective Announcer v"..S.VERSION

ObjAnnouncer = LibStub("AceAddon-3.0"):NewAddon("Objective Announcer", "AceComm-3.0", "AceEvent-3.0", "AceConsole-3.0", "LibSink-2.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Objective Announcer")
	
	---------------------
	-- Local Variables --
	---------------------
local oorUpdated = false
	
local self = ObjAnnouncer
local pairs = pairs
local tostring = tostring
local floor = math.floor
local DAILY, GROUP, WEEKLY, QUEST_COMPLETE, ABANDON_QUEST = _G.DAILY, _G.GROUP, _G.CALENDAR_REPEAT_WEEKLY, _G.QUEST_WATCH_QUEST_COMPLETE, _G.ABANDON_QUEST

local playerName, realmName
local questLogStatus = {}
local objCSaved = {}
local questCSaved = {}
local objDescSaved = {}
local oorGroupStorage = {}
local questTurnedIn = false
local qidComplete = 0
local turnLink = nil
local questExpReceived = nil
local pbThresholds = {}

local defaults = {
	profile = {
		--[[ General ]]--
		annType = 3,
		progBarInterval = 25,
			-- Announce to --
		selftell = true, selftellalways = false,
		selfColor = {r = 1.0, g = 1.0, b = 1.0, hex = "|cffFFFFFF"},
		sink20OutputSink = "ChatFrame",
		sink20Sticky = true,
		saychat = false,
		partychat = true,
		instancechat = true,
		raidchat = false,
		guildchat = false,
		officerchat = false,
		channelchat = false,
		chanName = 1,
			-- Additional Info --
		questlink = true, infoSuggGroup = false, infoLevel = false, infoFrequency = false, infoTag = false,
			--Quest Start/End --
		questAccept = false, questTurnin = false, questEscort = false, infoAutoComp = false, questFail = false, questAbandon = false, questTask = false, questXP = false, questRewards = false,
			-- Sound --
		enableCompletionSound = true, enableCommSound = false, enableAcceptFailSound = false,
		annSoundName = "PVPFlagCapturedHorde", annSoundFile = "Sound\\Interface\\PVPFlagCapturedHordeMono.ogg",
		compSoundName = "PVPFlagCaptured", compSoundFile = "Sound\\Interface\\PVPFlagCapturedMono.ogg",
		-- compSoundName = "PeonBuildingComplete", compSoundFile = "Sound\\Creature\\Peon\\PeonBuildingComplete1.ogg",
		commSoundName = "GM ChatWarning", commSoundFile = "Sound\\Interface\\GM_ChatWarning.ogg",
		acceptSoundName = "Hearthstone-QuestAccepted", acceptSoundFile = "Interface\\Addons\\ObjectiveAnnouncer\\Sounds\\Hearthstone-QuestingAdventurer_QuestAccepted.ogg",		
		failSoundName = "Hearthstone-QuestFailed", failSoundFile = "Interface\\Addons\\ObjectiveAnnouncer\\Sounds\\Hearthstone-QuestingAdventurer_QuestFailed.ogg",
			-- Out of Range Alerts --
		enableOOR = false,
	},
	char = {taskStorage = {},},
	global = {oorNotifyVersion = 0,},
}

	-------------
	-- Popups --
	-------------

StaticPopupDialogs["ObjAnn_OORUPDATED"] = {
  text = L["popupoorupdate"],
  button1 = ACCEPT,
  OnAccept = function()
      self.db.global.oorNotifyVersion = S.NUMVERSION
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = false,
}

	---------------------
	-- Local Functions --
	---------------------
	
local function oaBuildInitialTable(event, ...)
	local numEntries, numQuests = GetNumQuestLogEntries()
	for entryIndex = 1, numEntries do
		questLogStatus["numEntries"] = numEntries
		questLogStatus["numQuests"] = numQuests
		local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory = GetQuestLogTitle(entryIndex)
		if not isHeader then
			questLogStatus[questID] = {complete = isComplete, qLink = GetQuestLink(questID), isTask = isTask}
			for boardIndex = 1, GetNumQuestLeaderBoards(entryIndex) do
				local objDesc, objType, objComplete = GetQuestLogLeaderBoard(boardIndex, entryIndex)
				questLogStatus[questID][boardIndex] = {complete = objComplete}
				if (objType == "progressbar") then
					questLogStatus[questID][boardIndex] = {description = GetQuestProgressBarPercent(questID), complete = objComplete}
				else						
					questLogStatus[questID][boardIndex] = {description = objDesc, complete = objComplete}
				end
			end				
		end		
	end
	ObjAnnouncer:UnregisterEvent("QUEST_LOG_UPDATE")	
end	


	-- [[ Message Functions ]] --

local function oaMessageHandler(announcement, enableSelf, enableSound, enableComm, isComplete, oorAlert)
	local selfTest = true	-- Variable to see if any conditions have fired.
	if self.db.profile.raidchat == true and IsInRaid() then
		SendChatMessage(announcement, "RAID")
		if enableComm then ObjAnnouncer:SendCommMessage("Obj Announcer", "quest raid", "RAID") end
		selfTest = false
	elseif self.db.profile.instancechat and IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
		SendChatMessage(announcement, "INSTANCE_CHAT")
		if enableComm then ObjAnnouncer:SendCommMessage("Obj Announcer", "quest instance", "PARTY") end
		selfTest = false
	elseif self.db.profile.partychat and IsInGroup(LE_PARTY_CATEGORY_HOME) then
		SendChatMessage(announcement, "PARTY")
		if enableComm then ObjAnnouncer:SendCommMessage("Obj Announcer", "quest party", "PARTY") end
		selfTest = false
	elseif self.db.profile.saychat and UnitIsDeadOrGhost("player") == nil then
		SendChatMessage(announcement, "SAY")
	--	if enableComm then ObjAnnouncer:SendCommMessage("Obj Announcer", "quest say", "PARTY") end
		selfTest = false
	end
	if self.db.profile.guildchat and IsInGuild() then
		SendChatMessage(announcement, "GUILD")
	--	if enableComm then ObjAnnouncer:SendCommMessage("Obj Announcer", "quest guild", "GUILD") end
		selfTest = false
	elseif self.db.profile.officerchat and CanViewOfficerNote() then
		SendChatMessage(announcement, "OFFICER")
	--	if enableComm then ObjAnnouncer:SendCommMessage("Obj Announcer", "quest officer", "GUILD") end
		selfTest = false
	end
	if self.db.profile.channelchat then
		SendChatMessage(announcement, "CHANNEL", nil, self.db.profile.chanName)
		selfTest = false
	end
--	if enableSelf then	-- Every announcement message is currently enabled for self reporting, so this test is unnecessary.  It might be useful in the future though, so I'll just comment it out.
		if self.db.profile.selftellalways then
			ObjAnnouncer:Pour(announcement, self.db.profile.selfColor.r, self.db.profile.selfColor.g, self.db.profile.selfColor.b)
		elseif self.db.profile.selftell and selfTest then
			ObjAnnouncer:Pour(announcement, self.db.profile.selfColor.r, self.db.profile.selfColor.g, self.db.profile.selfColor.b)
		end
--	end
	if enableSound then
		if isComplete == 1 and self.db.profile.enableCompletionSound then
			PlaySoundFile(self.db.profile.compSoundFile,"Master")
		elseif self.db.profile.enableCompletionSound then
			PlaySoundFile(self.db.profile.annSoundFile,"Master")			
		elseif isComplete == -1 and self.db.profile.enableAcceptFailSound then	
			PlaySoundFile(self.db.profile.failSoundFile,"Master")
		end
	end
end

local function oaMessageCreator(questID, objDesc, objComplete, level, suggestedGroup, isComplete, frequency)

	local divider = false
	local questLink = GetQuestLink(questID)
	-- 暫時性修正與 GW2 UI 任務目標清單的相容性
	if questLink and self.db.profile.questlink then
		messageInfoLink = strjoin("", "  --  ", questLink)
	else
		messageInfoLink = ""
	end
	if (suggestedGroup > 0) and self.db.profile.infoSuggGroup then		
		messageInfoSuggGroup = strjoin("", " ["..GROUP..": ", suggestedGroup, "]")
		divider = true
	else
		messageInfoSuggGroup = ""
	end
	if (frequency > 1) and self.db.profile.infoFrequency then
		if frequency == 2 then messageInfoFrequency = " "..DAILY elseif frequency == 3 then messageInfoFrequency = " "..WEEKLY end
		divider = true
	else
		messageInfoFrequency = ""
	end
	if self.db.profile.infoTag then
		local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, displayTimeLeft = GetQuestTagInfo(questID)
		if tagID then 
			messageInfoTag = " "..tagName
			divider = true
		else
			messageInfoTag = ""	
		end		
	else
		messageInfoTag = ""			
	end
	if self.db.profile.infoLevel then
		local temp = tostring(level)
		messageInfoLevel = strjoin("", " [", temp, "]")
		divider = true
	else
		messageInfoLevel = ""
	end
	if divider then 
		infoDivider = " --" 
	else
		infoDivider = ""
	end
	
	if self.db.profile.annType == 1 then
		finalAnnouncement = string.upper(QUEST_COMPLETE).." -- "..questLink..infoDivider..messageInfoSuggGroup..messageInfoFrequency..messageInfoTag..messageInfoLevel	-- This announcement type ignores self.db.profile.questlink to ensure that a quest link is always displayed.
	else
		finalAnnouncement = objDesc..messageInfoLink..infoDivider..messageInfoSuggGroup..messageInfoFrequency..messageInfoLevel
		if (self.db.profile.annType == 3 or self.db.profile.annType == 5) and isComplete == 1 then
			finalAnnouncement = finalAnnouncement.." -- "..string.upper(QUEST_COMPLETE)
		end
	end
	oaMessageHandler(finalAnnouncement, true, objComplete, objComplete, isComplete)
end	

local function progressAnnCheck(percent, questID)	-- Check progress bar announcement interval to see if we should make an announcement.
	local makeAnnounce = false
	local interval = self.db.profile.progBarInterval
	if not pbThresholds[questID] then
		pbThresholds[questID] = interval
	end	
	if percent >= pbThresholds[questID] then
		local threshold = (floor(percent / interval) * interval) + interval
		if threshold > 100 then threshold = 100 end
		pbThresholds[questID] = threshold
		makeAnnounce = true
	end	
	return makeAnnounce
end

-- [[ Out-Of-Range Functions ]] 

local function oaOORHandler(prefix, text, dist, groupMember)
	if groupMember == playerName then return end
	local oorQuestID, oorBoardIndex, oorObjCurrent, oorObjTotal, oorObjText, isTask, _ = strsplit("\a", text, 7)
	oorQuestID = tonumber(oorQuestID)
	oorObjCurrent =  tonumber(oorObjCurrent)
	oorBoardIndex = tonumber(oorBoardIndex)
	if not oorGroupStorage[groupMember] then
		oorGroupStorage[groupMember] = {}
	end
	if not oorGroupStorage[groupMember][oorQuestID] then
		oorGroupStorage[groupMember][oorQuestID] = {}
	end
	local myLogIndex = GetQuestLogIndexByID(oorQuestID)	
	if self.db.profile.enableOOR and (myLogIndex > 0 or isTask == "true") then	-- Is quest in our log? Also handles tasks, even if not in the log right now.
		local myObjDesc, myObjType, myObjComplete = GetQuestObjectiveInfo(oorQuestID, oorBoardIndex)
		local myObjCurrent, myObjTotal, myObjText
		local validTaskInfo = false
		
		if (isTask == "false") then	-- Parse objective information and validate task info.	
			myObjCurrent, myObjTotal, myObjText = string.match(myObjDesc, "(%d+)/(%d+) ?(.*)")
			myObjCurrent = tonumber(myObjCurrent)
			myObjTotal = tonumber(myObjTotal)
		elseif self.db.char.taskStorage[oorQuestID] then
			if self.db.char.taskStorage[oorQuestID][oorBoardIndex] then
				if (myObjType == "progressbar") then
					myObjCurrent = GetQuestProgressBarPercent(oorQuestID)
					myObjTotal = 100
					myObjText = myObjDesc
				else
					myObjCurrent, myObjTotal, myObjText = string.match(myObjDesc, "(%d+)/(%d+) ?(.*)")
					myObjCurrent = tonumber(myObjCurrent)
					myObjTotal = tonumber(myObjTotal)
				end
				if myObjCurrent == self.db.char.taskStorage[oorQuestID][oorBoardIndex].taskObjCurrent then	-- Validate queried info against saved data.
					validTaskInfo = true
				else
					myObjCurrent = self.db.char.taskStorage[oorQuestID][oorBoardIndex].taskObjCurrent	-- Load saved objective info.
					validTaskInfo = true
				end
			end
		end
		
		if (myObjComplete == false) and ((isTask == "false") or validTaskInfo) then	-- Don't execute if we're already done with the objective. If no saved data about a task, do something else.				
			if not oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] then
				oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] = {savedDelta = oorObjCurrent - myObjCurrent}
			end
			local currentDelta = oorObjCurrent - myObjCurrent		
			if (currentDelta > oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta) then	-- If current delta increased over previous delta, we missed an objective. If delta decreased, do nothing.
				local qlink = GetQuestLink(oorQuestID) or self.db.char.taskStorage[oorQuestID].taskQuestLink
				local announcement = groupMember..L["oornotreceived"]..myObjText.."\" -- "..qlink
				oaMessageHandler(announcement, true, false, false, false, true)
			end	
			oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta = currentDelta
		elseif (not myObjComplete) then	-- Handles tasks the player has not encountered.
			if (not oorGroupStorage[groupMember][oorQuestID][oorBoardIndex]) then	-- Create new group storage entry
				oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] = {savedDelta = oorObjCurrent}
			else	-- Otherwise, we've either completed this task previously, or have not progressed it at all.  Update delta, assuming that our task progress is 0.
				oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta = oorObjCurrent
			end
		end
	else	-- If quest is not in questlog and not a task, still save the delta so we can use it when needed.
		if not oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] then
			oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] = {savedDelta = oorObjCurrent}
		else
			oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta = oorObjCurrent
		end
	end
end

local function oaOORSendComm(questID, boardIndex, objDesc, isTask, objType)
	local objCurrent, objTotal, objText
	local reserved = ""	-- Reserving function parameters so any future OOR additional functionality doesn't break players using previous versions.
	local chanType = "RAID"	-- "RAID" sends messages to party if not in raid, but check to be sure.
	if IsInGroup() and (not IsInRaid()) then chanType = "PARTY" end
--	chanType = "GUILD"	--debug
	if (objType == "progressbar") then
		objCurrent = tostring(GetQuestProgressBarPercent(questID))
		objTotal = "100"
		objText = objDesc
	else
		objCurrent, objTotal, objText = string.match(objDesc, "(%d+)/(%d+) ?(.*)")
	end
	oorCommMessage = strjoin("\a", questID, boardIndex, objCurrent, objTotal, objText, tostring(isTask), reserved)								
	ObjAnnouncer:SendCommMessage("ObjA OOR", oorCommMessage, chanType)	
end

-- [[ Core Functionality ]] --
local function oaUpdateQuestLog()
	-- 暫時性修正與 GW2 UI 任務目標清單的相容性
	if not questLogStatus.numEntries then return end
	
	local numEntries, numQuests = GetNumQuestLogEntries()
	--ObjAnnouncer:Print("numEntries: "..numEntries..", SavedNumEntries: "..questLogStatus.numEntries..", numQuests: "..numQuests)
	if (numEntries ~= questLogStatus.numEntries) or (numQuests ~= questLogStatus.numQuests) then
		if numEntries > questLogStatus.numEntries then
			for entryIndex = 1,  numEntries do
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory = GetQuestLogTitle(entryIndex)
				if (not isHeader) and (not questLogStatus[questID]) then
					questLogStatus[questID] = {complete = isComplete, qLink = GetQuestLink(questID), isTask = isTask}
					for boardIndex = 1, GetNumQuestLeaderBoards(entryIndex) do
						local objDesc, objType, objComplete = GetQuestLogLeaderBoard(boardIndex, entryIndex)
						questLogStatus[questID][boardIndex] = {complete = objComplete}
						if (objType == "progressbar") then
							questLogStatus[questID][boardIndex] = {description = GetQuestProgressBarPercent(questID), complete = objComplete}
						else
							questLogStatus[questID][boardIndex] = {description = objDesc, complete = objComplete}
						end
						if isTask then
							if (not self.db.char.taskStorage[questID]) then
								self.db.char.taskStorage[questID] = {taskQuestLink = GetQuestLink(questID)}
							end
							if (IsInGroup() or IsInRaid()) and ((objType == "progressbar") or string.find(objDesc, L["slain"]) or string.find(objDesc, L["killed"])) then -- Send initial OOR when picking up a new task
								oaOORSendComm(questID, boardIndex, objDesc, isTask, objType)
							end
						end
					end
					if isTask and self.db.profile.questTask then
						local taskMessage = L["areaentered"].." -- "..GetQuestLink(questID)
						oaMessageHandler(taskMessage, true, false, false, isComplete)
					end										
				end
			end
		else
			-- Quest Removed
		end	
		questLogStatus.numEntries = numEntries
		questLogStatus.numQuests = numQuests
	else
		for entryIndex = 1, numEntries do
			local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, questID, startEvent, displayQuestID, isOnMap, hasLocalPOI, isTask, isBounty, isStory = GetQuestLogTitle(entryIndex)
			if (not questLogStatus[questID]) then	-- For when tasks appear immediately after turning in a quest
				questLogStatus[questID] = {complete = isComplete, qLink = GetQuestLink(questID), isTask = isTask}
				questLogStatus.numQuests = questLogStatus.numQuests + 1
			end
			if not isHeader then
		--[[ Announcements Logic ]]--
			--[[ Failed Quests ]]--
				if isComplete == -1 and self.db.profile.questFail and isComplete ~= questLogStatus[questID].complete then
					questLogStatus[questID].complete = isComplete
					local questLink = GetQuestLink(questID)
					local failedMessage = questLink.." -- "..L["questfailed"]
					oaMessageHandler(failedMessage, true, false, false, isComplete)
				end
			--[[ Completed Quests Only ]]--
				if isComplete == 1 and isComplete ~= questLogStatus[questID].complete then
					questLogStatus[questID].complete = isComplete
					if self.db.profile.annType ==  1 then
						oaMessageCreator(questID, nil, true, level, suggestedGroup, isComplete, frequency)
					end
				end
			--[[ Completed Objectives (and Completed Quests, if Announce Type 3 is selected) ]]--
				for boardIndex = 1, GetNumQuestLeaderBoards(entryIndex) do
					local objDesc, objType, objComplete = GetQuestLogLeaderBoard(boardIndex, entryIndex)
					if (not questLogStatus[questID][boardIndex]) then	-- For quests where objectives are progressively added
						questLogStatus[questID][boardIndex] = {complete = objComplete, description = objDesc}						
					end
					local percent = nil
					if (objType == "progressbar") then percent = GetQuestProgressBarPercent(questID) end
					if (objComplete) and objComplete ~= questLogStatus[questID][boardIndex].complete then
						questLogStatus[questID][boardIndex].complete = objComplete
						if self.db.profile.annType == 2 or self.db.profile.annType == 3 then					
							oaMessageCreator(questID, objDesc, objComplete, level, suggestedGroup, isComplete, frequency)
						end
					end
					if isTask then	-- Use saved variables to keep track of tasks.
						local storeObjCurrent, storeObjTotal, storeObjText
						if (objType == "progressbar") then
							storeObjCurrent = percent
							storeObjTotal = 100
							storeObjText = objDesc
						else
							storeObjCurrent, storeObjTotal, storeObjText = string.match(objDesc, "(%d+)/(%d+) ?(.*)")
							storeObjCurrent = tonumber(storeObjCurrent)
							storeObjTotal = tonumber(storeObjTotal)								
						end	
						if self.db.char.taskStorage[questID] then
							if (not self.db.char.taskStorage[questID][boardIndex]) then
								self.db.char.taskStorage[questID][boardIndex] = {taskObjCurrent = storeObjCurrent, taskObjTotal = storeObjTotal, taskObjText = storeObjText}
							elseif (self.db.char.taskStorage[questID][boardIndex].taskObjCurrent ~= storeObjCurrent) then
								self.db.char.taskStorage[questID][boardIndex].taskObjCurrent = storeObjCurrent
							end
						end
					end
				--[[ Announces the progress of objectives (and Completed Quests, if Announce Type 5 is selected)]]--
					if (objType == "progressbar") then
						if percent ~= questLogStatus[questID][boardIndex].description then
							if percent > 0 then
								questLogStatus[questID][boardIndex].description = percent	
								if (progressAnnCheck(percent, questID) and self.db.profile.annType == 3) or (self.db.profile.annType == 4) or (self.db.profile.annType == 5) then	-- Run pAC() first to ensure that pbThresholds[qID] stays up to date.
									local percObjDesc = objDesc..": "..floor(percent).."%"
									if (isComplete == 1) then objComplete = true end
									oaMessageCreator(questID, percObjDesc, objComplete, level, suggestedGroup, isComplete, frequency)
								end
							--[[  Send progress to other OA users for OOR Alerts. ]]--	
								if IsInGroup() or IsInRaid() then
									oaOORSendComm(questID, boardIndex, objDesc, isTask, objType)
								end
							elseif percent == 0 then	-- Task quests report 0 when complete!
								questLogStatus[questID].complete = 1
							end
						end
					elseif objDesc ~= questLogStatus[questID][boardIndex].description then
						--ObjAnnouncer:Print("objDesc: "..objDesc..", savedDescription: "..questLogStatus[questID][boardIndex].description)
						if objDesc then		-- objDesc sometimes returns nil
							if isTask and string.find(objDesc, "0/") then	-- Task quests report 0 when complete!
								questLogStatus[questID].complete = 1
							end							
							questLogStatus[questID][boardIndex].description = objDesc	
							if self.db.profile.annType == 4 or self.db.profile.annType == 5 then
								oaMessageCreator(questID, objDesc, objComplete, level, suggestedGroup, isComplete, frequency)
							end
						--[[  Send progress to other OA users for OOR Alerts. ]]--
							if (IsInGroup() or IsInRaid()) and (string.find(objDesc, L["slain"]) or string.find(objDesc, L["killed"])) then
								oaOORSendComm(questID, boardIndex, objDesc, isTask, objType)
							end							
						end
					end
				end
				if self.db.char.taskStorage[questID] and questLogStatus[questID].complete == 1 then --(isComplete == 1) then	-- Prune database character task storage of unneeded data.
					self.db.char.taskStorage[questID] = nil
				end				
			end			
		end
	end
end

local function oaOnQuestLogChanged(event, ...)
	local unitID = ...
	if unitID ~= "player" then return end
	--ObjAnnouncer:Print("UNIT_QUEST_LOG_CHANGED")
	oaUpdateQuestLog()	
end

-- [[ Addon Communication Functions ]]--

local function oareceivedComm(prefix, commIn, dist, sender)
	local announceType, announceChannel = ObjAnnouncer:GetArgs(commIn, 2, 1)
	if  self.db.profile.enableCommSound and sender ~= playerName and (announceChannel == "party" or announceChannel == "raid") == true then
		PlaySoundFile(self.db.profile.commSoundFile)
	end
end

-- [[ Out-Of-Range Functions ]] 

local function oaOORHandler(prefix, text, dist, groupMember)
	if groupMember == playerName then return end
	local oorQuestID, oorBoardIndex, oorObjCurrent, oorObjTotal, oorObjText, isTask, _ = strsplit("\a", text, 7)
	oorQuestID = tonumber(oorQuestID)
	oorObjCurrent =  tonumber(oorObjCurrent)
	oorBoardIndex = tonumber(oorBoardIndex)
	if not oorGroupStorage[groupMember] then
		oorGroupStorage[groupMember] = {}
	end
	if not oorGroupStorage[groupMember][oorQuestID] then
		oorGroupStorage[groupMember][oorQuestID] = {}
	end
	local myLogIndex = GetQuestLogIndexByID(oorQuestID)	
	if self.db.profile.enableOOR and (myLogIndex > 0 or isTask == "true") then	-- Is quest in our log? Also handles tasks, even if not in the log right now.
		local myObjDesc, myObjType, myObjComplete = GetQuestObjectiveInfo(oorQuestID, oorBoardIndex)
		local myObjCurrent, myObjTotal, myObjText
		local validTaskInfo = false
		
		if (isTask == "false") then	-- Parse objective information and validate task info.	
			myObjCurrent, myObjTotal, myObjText = string.match(myObjDesc, "(%d+)/(%d+) ?(.*)")
			myObjCurrent = tonumber(myObjCurrent)
			myObjTotal = tonumber(myObjTotal)
		elseif self.db.char.taskStorage[oorQuestID] then
			if self.db.char.taskStorage[oorQuestID][oorBoardIndex] then
				if (myObjType == "progressbar") then
					myObjCurrent = GetQuestProgressBarPercent(oorQuestID)
					myObjTotal = 100
					myObjText = myObjDesc
				else
					myObjCurrent, myObjTotal, myObjText = string.match(myObjDesc, "(%d+)/(%d+) ?(.*)")
					myObjCurrent = tonumber(myObjCurrent)
					myObjTotal = tonumber(myObjTotal)
				end
				if myObjCurrent == self.db.char.taskStorage[oorQuestID][oorBoardIndex].taskObjCurrent then	-- Validate queried info against saved data.
					validTaskInfo = true
				else
					myObjCurrent = self.db.char.taskStorage[oorQuestID][oorBoardIndex].taskObjCurrent	-- Load saved objective info.
					validTaskInfo = true
				end
			end
		end
		
		if (myObjComplete == false) and ((isTask == "false") or validTaskInfo) then	-- Don't execute if we're already done with the objective. If no saved data about a task, do something else.				
			if not oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] then
				oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] = {savedDelta = oorObjCurrent - myObjCurrent}
			end
			local currentDelta = oorObjCurrent - myObjCurrent		
			if (currentDelta > oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta) then	-- If current delta increased over previous delta, we missed an objective. If delta decreased, do nothing.
				local qlink = GetQuestLink(oorQuestID) or self.db.char.taskStorage[oorQuestID].taskQuestLink
				local announcement = groupMember..L["oornotreceived"]..myObjText.."\" -- "..qlink
				oaMessageHandler(announcement, true, false, false, false, true)
			end	
			oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta = currentDelta
		elseif (not myObjComplete) then	-- Handles tasks the player has not encountered.
			if (not oorGroupStorage[groupMember][oorQuestID][oorBoardIndex]) then	-- Create new group storage entry
				oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] = {savedDelta = oorObjCurrent}
			else	-- Otherwise, we've either completed this task previously, or have not progressed it at all.  Update delta, assuming that our task progress is 0.
				oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta = oorObjCurrent
			end
		end
	else	-- If quest is not in questlog and not a task, still save the delta so we can use it when needed.
		if not oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] then
			oorGroupStorage[groupMember][oorQuestID][oorBoardIndex] = {savedDelta = oorObjCurrent}
		else
			oorGroupStorage[groupMember][oorQuestID][oorBoardIndex].savedDelta = oorObjCurrent
		end
	end
end

local function oaOORSendComm(questID, boardIndex, objDesc, isTask, objType)
	local objCurrent, objTotal, objText
	local reserved = ""	-- Reserving function parameters so any future OOR additional functionality doesn't break players using previous versions.
	local chanType = "RAID"	-- "RAID" sends messages to party if not in raid, but check to be sure.
	if IsInGroup() and (not IsInRaid()) then chanType = "PARTY" end
--	chanType = "GUILD"	--debug
	if (objType == "progressbar") then
		objCurrent = tostring(GetQuestProgressBarPercent(questID))
		objTotal = "100"
		objText = objDesc
	else
		objCurrent, objTotal, objText = string.match(objDesc, "(%d+)/(%d+) ?(.*)")
	end
	oorCommMessage = strjoin("\a", questID, boardIndex, objCurrent, objTotal, objText, tostring(isTask), reserved)								
	ObjAnnouncer:SendCommMessage("ObjA OOR", oorCommMessage, chanType)	
end

-- [[ Extra Announcements Functions ]] --

local function oaQuestAccepted(event, ...)
	local questLogIndex = ...
	oaUpdateQuestLog()
	if self.db.profile.questAccept and (not select(13,GetQuestLogTitle(questLogIndex))) then
		local qID = select(8, GetQuestLogTitle(questLogIndex))
		local acceptedLink = GetQuestLink(qID)
		local Message = L["questaccepted"].." -- "..acceptedLink
		if self.db.profile.enableAcceptFailSound then PlaySoundFile(self.db.profile.acceptSoundFile,"Master") end
		oaMessageHandler(Message, true)
	end
end

local function oaQuestTurnin(event, ...)
	turnLink = GetQuestLink(GetQuestID())
	questExpReceived = GetRewardXP()
end

local function oaAutoComplete(event, ...)
	if self.db.profile.infoAutoComp then
		local qID = ...
		local qLink = GetQuestLink(qID)
		local message = L["autocompletealert"].." -- "..qLink
		oaMessageHandler(message, true)
		ShowQuestComplete(GetQuestLogIndexByID(qID))	-- Automatically brings up the quest turn-in dialog window.
	end
end

local function oaAcceptEscort(event, ...)
	if self.db.profile.questEscort then
		local starter, questTitle = ...
		ConfirmAcceptQuest()
		StaticPopup_Hide("QUEST_ACCEPT")
		local starterClass = select(2, UnitClass(starter))
		local classColor = RAID_CLASS_COLORS[starterClass]
		local colorStarter = "|cff"..string.format("%02X%02X%02X",classColor.r*255, classColor.g*255, classColor.b*255)..starter.."|r"
		local message = L["autoaccept1"]..": |cffffef82"..questTitle.."|r -- "..L["autoaccept2"]..": "..colorStarter
		ObjAnnouncer:Print(message)
	end
end	

local function oaQuestRemoved(event, ...)
	local questID =  ...
	--ObjAnnouncer:Print("QUEST_REMOVED: "..questID)
	if questTurnedIn then
		local qIDstring = tostring(questID)		
		--[[ Clear oorGroupStorage of unneeded data. ]]--
		for k, _ in pairs(oorGroupStorage) do				
			if oorGroupStorage[k][qIDstring] then
				oorGroupStorage[k][qIDstring] = nil
			end
		end
		--[[ Announce Quest Turn-in ]]--
		if self.db.profile.questTurnin and turnLink then
			local Message = L["questturnin"].." -- "..turnLink
			oaMessageHandler(Message, true)				
		end
		--[[ Announce Quest Experience Gained ]]--
		if self.db.profile.questXP and questExpReceived and turnLink then
			if questExpReceived > 0 then
				local message = questExpReceived.." "..L["expgain"].." -- "..turnLink
				oaMessageHandler(message, true)		
			end
		end
		questExpReceived = nil
		turnLink = nil		
		questTurnedIn = false
	-- GW2UI 相容性修正
	elseif questLogStatus[questID] and questLogStatus[questID].isTask then
		if questLogStatus[questID].complete == 1 and (self.db.profile.annType ==  1 or self.db.profile.annType ==  3 or self.db.profile.annType ==  5) then
			local taskType
			if QuestUtils_IsQuestWorldQuest(questID) then
				taskType = L["worldquestcomplete"]
			else
				taskType = L["taskcomplete"]
			end			
			local message = taskType.." -- "..questLogStatus[questID].qLink
			oaMessageHandler(message)
		elseif self.db.profile.questTask then
			local message = L["arealeft"].." -- "..questLogStatus[questID].qLink
			oaMessageHandler(message)
		end		
	else
		if self.db.profile.questAbandon then
			local message = ABANDON_QUEST.." -- "..questLogStatus[questID].qLink
			oaMessageHandler(message)
		end				
	end
	questLogStatus[questID] = nil	
	oaUpdateQuestLog()
end

	--------------------
	-- Initialization --
	--------------------

function ObjAnnouncer:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("ObjectiveAnnouncerDB", defaults, true)
	self.myOptions.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)	
		--[[ LibSink ]]--
	self.myOptions.args.libsink = self:GetSinkAce3OptionsDataTable()
	local libsink = self.myOptions.args.libsink
	libsink.name = L["selfoutput"]
	libsink.desc = L["selfoutputdesc"]
	libsink.order = 2
		--[[ Hide LibSink outputs that would conflict with public announcements ]]--
	libsink.args.Channel.hidden = true	-- If someone selected a channel here, ObjAnn messages would report to a public channel if all public channels were disabled in OA.  Best to disable this.
	libsink.args.None.hidden = true		-- We already have a way to disable ObjAnn announcements
	libsink.args.Default.hidden = true	--  Could cause ObjAnn announcements to announce to public channels...maybe.  In any case, unnecessary.
	
	self:SetSinkStorage(self.db.profile)

	for boardSaved = 1, 100 do
		objCSaved[boardSaved] = {}
		objDescSaved[boardSaved] = {}
	end
		
	playerName, realmName = UnitName("player")	
	
	if oorUpdated and (S.NUMVERSION > self.db.global.oorNotifyVersion) then
		StaticPopup_Show("ObjAnn_OORUPDATED")
	end	
end

function ObjAnnouncer:OnEnable()
	-- [[ Hook: Announce Quest Rewards ]]--
	local origQuestRewardCompleteButton_OnClick = QuestFrameCompleteQuestButton:GetScript("OnClick")
	QuestFrameCompleteQuestButton:SetScript("OnClick", function(...)
		questTurnedIn = true
		if self.db.profile.questRewards and QuestInfoFrame.itemChoice and QuestInfoFrame.itemChoice > 0 then
			 local rewardMessage = L["rewardchosen"].." "..turnLink.." -- "..GetQuestItemLink("choice", QuestInfoFrame.itemChoice)
			 oaMessageHandler(rewardMessage, true)
		end
		return origQuestRewardCompleteButton_OnClick(...)
	end)
	
	--ObjAnnouncer:RegisterEvent("QUESTTASK_UPDATE", oqTaskUpdateHandler)
	ObjAnnouncer:RegisterEvent("QUEST_LOG_UPDATE", oaBuildInitialTable)
	ObjAnnouncer:RegisterEvent("UNIT_QUEST_LOG_CHANGED", oaOnQuestLogChanged)
	ObjAnnouncer:RegisterEvent("QUEST_ACCEPTED", oaQuestAccepted)
	ObjAnnouncer:RegisterEvent("QUEST_COMPLETE", oaQuestTurnin)
	ObjAnnouncer:RegisterEvent("QUEST_ACCEPT_CONFIRM", oaAcceptEscort)
	ObjAnnouncer:RegisterEvent("QUEST_AUTOCOMPLETE", oaAutoComplete)
	ObjAnnouncer:RegisterEvent("QUEST_REMOVED", oaQuestRemoved)
	ObjAnnouncer:RegisterComm("Obj Announcer", oareceivedComm)
	ObjAnnouncer:RegisterComm("ObjA OOR", oaOORHandler)	-- Always enabled so group objective progress can be recorded. This allows OOR alerts to work immediately upon being enabled.
end