local RC = LibStub("AceAddon-3.0"):GetAddon("Raid Check")
local L = LibStub("AceLocale-3.0"):GetLocale("Raid Check", true)

function RC:loadData()
	RC.playerData = {};

	local numPlayers = GetNumGroupMembers()
	local pName, pRealm = RC:getMemberName(-1)

	-- We only want to populate the table of Boss Names once, otherwise every time we open the Settings tab it would populate the Boss Names, this is also the best location to perform this addition
	if table.getn(RC.VantusBossNames) == 1 then
		for k = 1, table.getn(RC.EncounterIds) do
			local encounterName = EJ_GetEncounterInfo(RC.EncounterIds[k])

			table.insert(RC.VantusBossNames, encounterName)
		end
	end

	-- As the first entry in the Array is denoted as 'None' then first check that we have a Vantus Rune Boss to check
	RC.VantusRuneCheckEnabled = false
	if self.db.char.Threshold.VantusRune > 1 then
		local guid = UnitGUID("target")
		if guid then
			local _, _, _, _, _, npcID = strsplit('-', guid)
			local npcID = tonumber(npcID) -- We need to convert the value to a number for the comparison later
			local bossId = RC.VantusBossIds[self.db.char.Threshold.VantusRune]

			for j = 1, table.getn(bossId) do
				if (npcID == bossId[j]) then
					RC.VantusRuneCheckEnabled = true
				end
			end
		end
	end

	if IsInRaid() then
		for i = 1, numPlayers do
			_, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);
			if not ((subgroup == 7 or subgroup == 8) and self.db.char.IgnoreGroup7_8) then
				name, realm	= RC:getMemberName(i);
				hasFlask, hasFood, hasRune, hasVantusRune = unpack(RC:playerHasBuff(i));
				RC.playerData[i] = {name, realm, hasFlask, hasFood, hasRune, RC:getPlayerClass(i), RC:getPlayerRole(i), hasVantusRune};
				RC:checkForRetPaladin(i);
			end
		end
	elseif IsInGroup() then
		hasFlask, hasFood, hasRune, hasVantusRune = unpack(RC:playerHasBuff(-1));
		RC.playerData[1] = {pName, pRealm, hasFlask, hasFood, hasRune, RC:getPlayerClass(-1), RC:getPlayerRole(-1), hasVantusRune};
		RC:checkForRetPaladin(1);

		for i = 1, (numPlayers -1) do
			name, realm	= RC:getMemberName(i);
			hasFlask, hasFood, hasRune, hasVantusRune = unpack(RC:playerHasBuff(i));
			RC.playerData[i+1] = {name, realm, hasFlask, hasFood, hasRune, RC:getPlayerClass(i), RC:getPlayerRole(i), hasVantusRune};
			RC:checkForRetPaladin(i+1);
		end
	else
		hasFlask, hasFood, hasRune, hasVantusRune = unpack(RC:playerHasBuff(-1));
		RC.playerData[1] = {pName, pRealm, hasFlask, hasFood, hasRune, RC:getPlayerClass(-1), RC:getPlayerRole(-1), hasVantusRune};
		RC:checkForRetPaladin(1);
	end
end

function RC:getMemberName(index)
	local pName, pRealm

	if(IsInRaid()) then
		pName, pRealm = UnitFullName("raid"..index);
	elseif(IsInGroup() and index > -1) then
		pName, pRealm = UnitFullName("party"..index);
	elseif(index == -1) then
		pName, pRealm = UnitFullName("player");
	end

	if not pRealm then
		pRealm = GetRealmName();
	end

	return pName, pRealm;
end

function RC:playerHasBuff(index)
	local checkArrFl = RC.Flask;
	local checkArrFo = RC.Food;
	local checkArrRu = RC.Runes;
	local checkArrVa = RC.VantusSpellIds[self.db.char.Threshold.VantusRune];
	local thresholdFl = RC.FlaskLevels[self.db.char.Threshold.Flask]
	local thresholdFo = RC.FoodLevels[self.db.char.Threshold.Food]
	local thresholdRu = RC.RuneLevels[self.db.char.Threshold.Rune]
	local hasFlask, hasFood, hasRune, pandaFood, hasVantusRune;

	local pandaCheck = RC:CheckForPandaren(index);
	if(self.db.char.Allow.FelFocuser) then
		table.insert(checkArrFl, RC.FelFocus);
	end

	data 		= RC:getPlayerBuffs(index);
	buffs 		= data[1];
	duration 	= data[2];
	value 		= data[3];
	caster		= data[4];

	--We iterate through the players buffs, this minimizes the number of loops we have to go through
	for i = 1, table.getn(buffs) do
		--We check if hasFlask/hasRune/hasFood already have values, as we loop through the buffs once we find an
		--appropriate buff (flask/food/rune) there is no need to continue checking for that particular buff
		if not hasFlask then
			hasFlask = RC:checkForBuff(buffs[i], value[i], duration[i], checkArrFl, thresholdFl)
		end

		if not hasRune then
			hasRune = RC:checkForBuff(buffs[i], value[i], duration[i], checkArrRu, thresholdRu)
		end

		if not hasFood then
			-- Pandaren have a racial ability that double's the amount of food buff they receive so we halve it here
			if pandaCheck then
				pandaFood = value[i] / 2 -- we use a special variable here so we do not affect the value in the table for other statements down the line.
				hasFood = RC:checkForBuff(buffs[i], pandaFood, duration[i], checkArrFo, thresholdFo)
			else
				hasFood = RC:checkForBuff(buffs[i], value[i], duration[i], checkArrFo, thresholdFo)
			end

		end

		-- If we haven't found the vantus rune yet and if Vantus Rune Checking is enabled (parameter set above none and the proper npc is targeted)
		if not hasVantusRune and RC.VantusRuneCheckEnabled then
			hasVantusRune = RC:checkForBuff(buffs[i], value[i], duration[i], checkArrVa, value[i])
		end

		if buffs[i] == RC.GBoW then
			if RC.NumRetPaladins then
				--SendChatMessage("Caster: "..caster[i], "WHISPER", nil, "Torsin");
				if (RC.playerData[index][7] == "HEALER") then
					-- SendChatMessage("Applied to: "..RC.playerData[index][1], "WHISPER", nil, "Torsin");
				end
			end
		end
	end

	if not hasFlask then hasFlask = 0 end
	if not hasFood then hasFood = 0 end
	if not hasRune then hasRune = 0 end
	if not hasVantusRune then hasVantusRune = 0 end

	return {hasFlask, hasFood, hasRune, hasVantusRune};
end

function RC:checkForBuff(buff, value, duration, checkArr, threshold)
	local val;

	for id, spellID in pairs(checkArr) do
		if(buff and spellID and threshold) then
			if(value) then val = value; else val = 2; end

			if(buff == spellID and val >= threshold) then
				if(duration == -1337) then
					return 3;
				elseif(duration < 10) then
					return 2;
				else
					return 1;
				end
			end
		end
	end
end

function RC:getPlayerRole(index)
	local role

	if(IsInRaid()) then
		role = UnitGroupRolesAssigned("raid"..index);
	elseif(IsInGroup() and index > -1) then
		role = UnitGroupRolesAssigned("party"..index);
	elseif(index == -1) then
		role = GetSpecializationRole(GetSpecialization());
	end

	return role;
end

function RC:checkForRetPaladin(index)
	if self.db.char.Show.WisdomBuffTargets then
		if ((RC.playerData[index][6] == "PALADIN") and (RC.playerData[index][7] == "DAMAGER")) then
			if (not RC.NumRetPaladins) then
				RC.NumRetPaladins = 1
			else
				RC.NumRetPaladins = RC.NumRetPaladins + 1
			end
		end
	end
end

function RC:CheckForPandaren(index)
	unitBuffTarget = "player";
	if(index ~= -1) then
		unitBuffTarget = RC:getMemberName(index);
	end

	_,englishRace = UnitRace(unitBuffTarget);

	if englishRace == "Pandaren" then
		return true;
	end

	return false;
end

function RC:getPlayerBuffs(index)
	local pandaCheck = RC:CheckForPandaren(index);
	buffs = {};
	duration = {};
	buffCaster = {};
	buffName = {};
	buffValue = {};
	pclass = nil;

	unitBuffTarget = "player";

	if(index ~= -1) then
		unitBuffTarget = RC:getMemberName(index);
	end

	-- Iterate through the buffs on a target, index for UnitBuff has a maximum value of 40
	for i=1,40 do
		local spell, _, _, _, _, _,dur,_, caster, _, spellId,_,_,_,_,_,v2 = UnitBuff(unitBuffTarget,i);

		if spell then
			buffs[i] = spellId;

			if(dur == 0) then
				duration[i] = math.floor(-1337);
			else
				duration[i] = math.floor((dur-GetTime())/60);
			end

			--Patch Pepper Breath FireBalls and Feasts to Secondary stat values
			--Pandarens receive double food buff, since all of these are food overrides we need to double the values here since we halve panda buffs later.
			if (buffs[i] == RC.OverRide225) then
				v2 = 225;
				if pandaCheck then v2 = v2 * 2 end
			end

			if (buffs[i] == RC.OverRide300) then
				v2 = 300;
				if pandaCheck then v2 = v2 * 2 end
			end

			if (buffs[i] == RC.OverRide375) then
				v2 = 375;
				if pandaCheck then v2 = v2 * 2 end
			end

			for j = 1, table.getn(RC.OverRide400) do
				if(buffs[i] == RC.OverRide400[J]) then
					v2 = 400;
					if pandaCheck then v2 = v2 * 2 end
				end
			end

			for j = 1, table.getn(RC.OverRide500) do
				if(buffs[i] == RC.OverRide500) then
					v2 = 500;
					if pandaCheck then v2 = v2 * 2 end
				end
			end

			if(buffs[i] == RC.FelFocus) then v2 = 1300; end

			buffCaster[i] = caster;

			if(v2) then
				buffValue[i] = v2;
			else
				buffValue[i] = 0;
			end

		end
	end
	return {buffs, duration, buffValue, buffCaster};
end

function RC:getPlayerClass(index)
	unitBuffTarget = "player";
	if(index ~= -1) then
		unitBuffTarget = RC:getMemberName(index);
	end

	_,englishClass,pclass = UnitClass(unitBuffTarget);

	return englishClass;
end

function RC:PlayerName(barNr)
	local pName, pRealm

	if(RC.playerData[barNr]) then
		pName = RC.playerData[barNr][1];
		pRealm = RC.playerData[barNr][2];
	end

	if (self.db.char.Show.Realm) and pName and pRealm then
		pName = pName.."-"..pRealm
		if(string.len(pName) > 20) then
			pName = string.sub(pName, 0, 20).."..";
		end
	end

	return pName
end

function RC:SetClassColor(barNr)
	local pClass, pColor = {1,1,1};

	if not (self.db.char.classColors) then
		return pColor
	end

	if(RC.playerData[barNr]) then
		pClass = RC.playerData[barNr][6]
	end

	for k,v in pairs(RAID_CLASS_COLORS) do
		if k == pClass then
			return { v.r, v.g, v.b }
		end
	end

	return pColor
end

function RC:SetFlFoRu(i, pDataNum)
	local pData = {
		status,
		color,
		number,
	}

	if(RC.playerData[i]) then
		pData.number = RC.playerData[i][pDataNum]
	end

	if (pData.number == 1) or (pFlask == 3) then
		pData.status = L["yes"];
		pData.color = {0, 1, 0};
	elseif(pData.number == 0) then
		pData.status = L["no"];
		pData.color = {1, 0, 0};
	elseif(pData.number == 2) then
		pData.status = L["exp"];
		pData.color = {1, 0.5, 0};
	else
		pData.status = "";
		pData.color = {0, 0, 0};
	end

	return pData.status, pData.color
end

function RC:RdyChk()
	if self.db.char.Announce.LeaderAssistOnly then
		if not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
			return
		end
	end

	local show = self.db.char.Show.RaidCheckonReady;
	local ann = self.db.char.Announce.ReadyCheck;
	local whisp = self.db.char.Whisper.OnReadyCheck;

	if(show or ann or whisp) then
		RC:Show("RC_Main")
		if not show then
			RC:Hide()
		end

		if(ann) then
			RC:Announce();
		end

		if(whisp) then
			RC:Whisper(-1);
		end
	end
end

function RC:CombatHide()
	if not self:IsEnabled() then
		return
	end

	if RC_Frame then
		if self.db.char.Show.StartCombatHide then
			if RC_Frame:IsShown() then
				RC:Hide()
			end
		end
	end
end

function RC:RaidBossStart()
	if not self:IsEnabled() then
		return
	end

	-- We should only announce if we are the leader or have assist
	if self.db.char.Announce.LeaderAssistOnly then
		if not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
			return
		end
	end

	if RC_Frame then
		if (self.db.char.Announce.BossStart) then
			RC:Announce();
		end
	else
		RC:OpenMain()
		if (self.db.char.Announce.BossStart) then
			RC:Announce();
		end
		RC:Hide()
	end

end

function RC:Announce()
	if not self:IsEnabled() then
		return
	end

	if not RC_Frame then
		RC:OpenMain()
		RC:Hide()
	else
		RC:loadData();
		RC:updateGUI();
	end

	local numPlayers = GetNumGroupMembers()
	if numPlayers == 0 then
		numPlayers = 1
	end

	local nofood 	= "";
	local noflask = "";
	local norune  = "";
	local novantusrune= "";

	local expfood 	= "";
	local expflask 	= "";
	local exprune 	= "";

	local issuesFood		= true;
	local issuesFlask		= true;
	local issuesRune		= true;
	local issuesVantusRune	= true;

	local name = "";

	local extensionFlask 	= " (+"..RC.FlaskLevels[self.db.char.Threshold.Flask]..")";
	local extensionFood 	= " (+"..RC.FoodLevels[self.db.char.Threshold.Food]..")";
	local extensionRune		= " (+"..RC.RuneLevels[self.db.char.Threshold.Rune]..")";

	local vantusRuneBoss	= " ("..RC.VantusBossNames[self.db.char.Threshold.VantusRune]..")";

	for i = 1, numPlayers do
		if(RC.playerData[i]) then
			name = RC.playerData[i][1];

			if(self.db.char.Show.Realm) then
				local realm = RC.playerData[i][2];
				name = name.."-"..realm
			end


			_, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);

			if((subgroup == 7 or subgroup == 8) and self.db.char.IgnoreGroup7_8) then
				local ignoredGroup = 1;--Dummy
			else
				if(RC.playerData[i][3] == 0) then noflask 	= noflask..""..name..", "; end
				if(RC.playerData[i][3] == 2) then expflask 	= expflask..""..name.." "..L["expires"]..", "; end

				if(RC.playerData[i][4] == 0) then nofood 	= nofood..""..name..", "; end
				if(RC.playerData[i][4] == 2) then expfood 	= expfood..""..name.." "..L["expires"]..", "; end

				if(RC.playerData[i][5] == 0) then norune 	= norune..""..name..", "; end
				if(RC.playerData[i][5] == 2) then exprune 	= exprune..""..name.." "..L["expires"]..", "; end

				if(RC.playerData[i][8] == 0) then novantusrune 	= novantusrune..""..name..", "; end
			end
		end
	end

	channel = (IsInGroup(2) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY"

	--Print if everything is good
	if (self.db.char.Announce.Flask and string.len(noflask) == 0 and string.len(expflask) == 0) or (not self.db.char.Announce.Flask) then
		issuesFlask = false;
	end

	if (self.db.char.Announce.Food and string.len(nofood) == 0 and string.len(expfood) == 0) or (not self.db.char.Announce.Food) then
		issuesFood = false;
	end

	if (self.db.char.Announce.Rune and string.len(norune) == 0 and string.len(exprune) == 0) or (not self.db.char.Announce.Rune) or (not self.db.char.Show.Rune) then
		issuesRune = false;
	end

	if (RC.VantusRuneCheckEnabled and string.len(novantusrune) == 0) or not (RC.VantusRuneCheckEnabled) then
		issuesVantusRune = false;
	end

	if (not issuesFood and not issuesRune and not issuesFlask and not issuesVantusRune) then
		if not (self.db.char.Announce.Flask or self.db.char.Announce.Food or self.db.char.Announce.Rune or RC.VantusRuneCheckEnabled) then
			SendChatMessage(L["allchecksdisabled"], channel, nil, nil);
		else
			SendChatMessage(L["noissues"], channel, nil, nil);
		end
	end

	if (issuesFood or issuesRune or issuesFlask or issuesVantusRune) then
		SendChatMessage(L["missingbuffs"], channel, nil, nil);
	end

	--Print warnings
	if (self.db.char.Announce.Flask) and (string.len(noflask) > 1 or string.len(expflask) > 1) then
		--Cut trailing comma
		printnames = noflask..expflask;
		printnames = string.sub(printnames, 0, -3);

		local chatMsg = L["warningflask"]..extensionFlask..": "..printnames

		if (string.len(chatMsg) > 510) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256, 510), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 511), channel, nil, nil);
		elseif (string.len(chatMsg) > 255) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256), channel, nil, nil);
		else
			SendChatMessage(string.sub(chatMsg, 1), channel, nil, nil);
		end
	end

	if (self.db.char.Announce.Food) and (string.len(nofood) > 1 or string.len(expfood) > 1) then
		--Cut trailing comma
		printnames = nofood..expfood;
		printnames = string.sub(printnames, 0, -3);

		local chatMsg = L["warningfood"]..extensionFood..": "..printnames

		if (string.len(chatMsg) > 510) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256, 510), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 511), channel, nil, nil);
		elseif (string.len(chatMsg) > 255) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256), channel, nil, nil);
		else
			SendChatMessage(chatMsg, channel, nil, nil);
		end
	end

	if ((self.db.char.Announce.Rune) and (self.db.char.Show.Rune) and (string.len(norune) > 1)) then
		--Cut trailing comma
		printnames = norune..exprune;
		printnames = string.sub(printnames, 0, -3);

		local chatMsg = L["warningrune"]..extensionRune..": "..printnames

		if (string.len(chatMsg) > 510) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256, 510), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 511), channel, nil, nil);
		elseif (string.len(chatMsg) > 255) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256), channel, nil, nil);
		else
			SendChatMessage(chatMsg, channel, nil, nil);
		end
	end

	if (RC.VantusRuneCheckEnabled and (string.len(novantusrune) > 1)) then
		printnames = novantusrune..exprune;
		printnames = string.sub(printnames, 0, -3);

		local chatMsg = L["warningvantus"]..vantusRuneBoss..": "..printnames

		if (string.len(chatMsg) > 510) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256, 510), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 511), channel, nil, nil);
		elseif (string.len(chatMsg) > 255) then
			SendChatMessage(string.sub(chatMsg, 1, 255), channel, nil, nil);
			SendChatMessage(string.sub(chatMsg, 256), channel, nil, nil);
		else
			SendChatMessage(chatMsg, channel, nil, nil);
		end
	end
end

function RC:WhisperAll()
	RC:Whisper(-1);
end

function RC:Whisper(specific)
	if not self:IsEnabled() then
		return
	end

	if not RC_Frame then
		RC:OpenMain()
		RC:Hide()
	else
		RC:loadData();
		RC:updateGUI();
	end

	local numPlayers = GetNumGroupMembers()
	if numPlayers == 0 then
		numPlayers = 1
	end

	local expfood 	= "";
	local expflask 	= "";
	local exprune 	= "";

	local extensionFlask 	= " (+"..RC.FlaskLevels[self.db.char.Threshold.Flask]..")。";
	local extensionFood 	= " (+"..RC.FoodLevels[self.db.char.Threshold.Food]..")。";
	local extensionRune		= " (+"..RC.RuneLevels[self.db.char.Threshold.Rune]..")。";

	local vantusRuneBoss	= " "..RC.VantusBossNames[self.db.char.Threshold.VantusRune];

	local RC_wAll = true;
	local name = "";

	if(specific == -1) then
		specific = 1;
		goTo = numPlayers;
		RC_wAll = true;
	else
		goTo = specific;
		RC_wAll = false;
	end;

	for i = specific, goTo do
		if(RC.playerData[i]) then
			name = RC.playerData[i][1];
			if(self.db.char.Show.Realm) then
				local realm = RC.playerData[i][2];
				name = name.."-"..realm
				if(string.len(name) > 20) then
					name = string.sub(name, 0, 20).."..";
				end
			end
			_, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);

			if((subgroup == 7 or subgroup == 8) and self.db.char.IgnoreGroup7_8 and RC_wAll) then
				--ignored subgrp
			else
				--Flasks
				if(self.db.char.Announce.Flask) then
					if(RC.playerData[i][3] == 0) then
						SendChatMessage(L["RaidCheck"]..": "..L["useFlask"]..extensionFlask, "WHISPER", nil, name);
					elseif (RC.playerData[i][3] == 2) then
						SendChatMessage(L["RaidCheck"]..": "..L["expFlask"], "WHISPER", nil, name);
					end
				end

				--Food
				if(self.db.char.Announce.Food) then
					if(RC.playerData[i][4] == 0) then
						SendChatMessage(L["RaidCheck"]..": "..L["useFood"]..extensionFood, "WHISPER", nil, name);
					elseif (RC.playerData[i][4] == 2) then
						SendChatMessage(L["RaidCheck"]..": "..L["expFood"], "WHISPER", nil, name);
					end
				end

				--Runes
				if ((self.db.char.Announce.Rune) and (self.db.char.Show.Rune)) then
					if(RC.playerData[i][5] == 0) then
						SendChatMessage(L["RaidCheck"]..": "..L["useRune"]..extensionRune, "WHISPER", nil, name);
					elseif (RC.playerData[i][5] == 2) then
						SendChatMessage(L["RaidCheck"]..": "..L["expRune"], "WHISPER", nil, name);
					end
				end

				--Vantus Rune
				if (RC.VantusRuneCheckEnabled and self.db.char.Whisper.VantusRune) then
					if(RC.playerData[i][8] == 0) then
						SendChatMessage(L["RaidCheck"]..": "..L["useVantus"]..vantusRuneBoss, "WHISPER", nil, name);
					end
				end
			end
		end
	end
end

--Ended up not needing this function, but we should keep it for the Future
function RC:GetNPCNameFromID(npcID)
	local npcName
	local DatamineTooltip = _G.CreateFrame("GameTooltip", "RaidCheckDatamineTooltip", _G.UIParent, "GameTooltipTemplate")

	DatamineTooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")
	DatamineTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(npcID))

	npcName = _G['RaidCheckDatamineTooltipTextLeft1']:GetText()

	if npcName and npcName ~= "" then
		return npcName
	else
		return "None"
	end
end
