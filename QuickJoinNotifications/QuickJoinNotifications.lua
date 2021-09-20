local QJN_Addon, private_table = ...

local QJN_Defaults = { };
QJN_Defaults["CHAT_ENABLED"] = false;
QJN_Defaults["TOASTS_ENABLED"] = true;
QJN_Defaults["TOASTFRAME_WIDTH"] = 320;
QJN_Defaults["TOASTFRAME_HEIGHT"] = 70;
QJN_Defaults["TOASTFRAME_PADDING"] = 10;
QJN_Defaults["TOASTFRAME_MARGIN"] = 15;
QJN_Defaults["TOAST_DURATION"] = 4;
QJN_Defaults["TOASTCONTAINER_XOFFSET"] = 0;
QJN_Defaults["TOASTCONTAINER_YOFFSET"] = 40;
QJN_Defaults["TOASTCONTAINER_MAXTOASTS"] = 3;
QJN_Defaults["TOASTFRAME_GROWDIRECTION"] = "TOP";
QJN_Defaults["TOAST_SOUND_ENABLED"] = true;
QJN_Defaults["ENABLED_IN_RAIDS"] = true;
QJN_Defaults["ENABLED_IN_DUNGEONS"] = true;
QJN_Defaults["ENABLED_IN_ARENAS"] = true;
QJN_Defaults["ENABLED_IN_BATTLEGROUNDS"] = true;
QJN_Defaults["HIDE_BLIZZARD_TOASTS"] = true;

local function loadOptions()
	if ( type(QJN_Options) ~= "table" ) then QJN_Options = { } end;
	for k,v in pairs(QJN_Defaults) do
		if ( type(QJN_Options[k]) ~= type(v) ) then
			QJN_Options[k] = v;
		end
	end
	
	if QJN_Options["TOASTFRAME_GROWDIRECTION"] == "TOP" then
		QJN_Options["TOASTFRAME_ANCHORPOS"] = "BOTTOM";
	else
		QJN_Options["TOASTFRAME_ANCHORPOS"] = "TOP";
	end
end

local toastBG = {
  -- path to the background texture
  bgFile = "Interface\\FriendsFrame\\UI-Toast-Background",  
  -- path to the border texture
  edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border",
  -- true to repeat the background texture to fill the frame, false to scale it
  tile = true,
  -- size (width or height) of the square repeating background tiles (in pixels)
  tileSize = 12,
  -- thickness of edge segments and square size of edge corners (in pixels)
  edgeSize = 12,
  -- distance from the edges of the frame to those of the background texture (in pixels)
  insets = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5
  }
}

local toastContainer;

local function createToastFrame(friendName, queueFlavorText, queueDescription, id, parent)
	local newToastFrame = CreateFrame("FRAME", "quickJoinToastFrame"..id, parent or UIParent);
	newToastFrame:SetPoint(QJN_Options["TOASTFRAME_GROWDIRECTION"]);
	newToastFrame:SetSize(QJN_Options["TOASTFRAME_WIDTH"], QJN_Options["TOASTFRAME_HEIGHT"]);
	newToastFrame:SetBackdrop(toastBG);
	newToastFrame.id = id;
	
	newToastFrame:SetScript("OnMouseUp", function (self, button)
		if ( button == "LeftButton" ) then
			--from FriendsFrame.lua - ToggleFriendsSubPanel
			--PanelTemplates_SetTab(FriendsFrame, 1); --Friends panel
			--PanelTemplates_SetTab(FriendsTabHeader, 2); --QuickJoin subpanel
			--FriendsFrame_Update();
			--ShowUIPanel(FriendsFrame);
			ToggleQuickJoinPanel() --maybe use this to close panel on second click?
		elseif ( button == "RightButton" ) then
			self:close();
		end
	end);
	
	newToastFrame.friendName = newToastFrame:CreateFontString(newToastFrame:GetName() .. "FriendName", "OVERLAY", "FriendsFont_Normal");
	local fontName, fontSize, flags = newToastFrame.friendName:GetFont();
	newToastFrame.friendName:SetFont(fontName, fontSize+2, flags);
	newToastFrame.friendName:SetText(friendName);
	newToastFrame.friendName:SetPoint("TOPLEFT", QJN_Options["TOASTFRAME_PADDING"], -1 * QJN_Options["TOASTFRAME_PADDING"]);
	
	newToastFrame.isQueuedText = newToastFrame:CreateFontString(newToastFrame:GetName() .. "IsQueuedText", "OVERLAY", "FriendsFont_Normal");
	newToastFrame.isQueuedText:SetTextColor(0.8, 0.8, 0.8, 1);
	newToastFrame.isQueuedText:SetWidth(QJN_Options["TOASTFRAME_WIDTH"] - 3 * QJN_Options["TOASTFRAME_PADDING"] - newToastFrame.friendName:GetWidth());
	newToastFrame.isQueuedText:SetWordWrap(false);
	newToastFrame.isQueuedText:SetJustifyH("LEFT");
	newToastFrame.isQueuedText:SetText(queueFlavorText);
	newToastFrame.isQueuedText:SetPoint("LEFT", newToastFrame.friendName, "RIGHT", 0, 0);
	
	newToastFrame.queueName = newToastFrame:CreateFontString(newToastFrame:GetName() .. "QueueName", "OVERLAY", "FriendsFont_Normal");
	newToastFrame.queueName:SetTextColor(0.8, 0.8, 0.8, 1);
	newToastFrame.queueName:SetWidth(QJN_Options["TOASTFRAME_WIDTH"] - 3 * QJN_Options["TOASTFRAME_PADDING"] - 50); --50 from join button
	newToastFrame.queueName:SetHeight(QJN_Options["TOASTFRAME_HEIGHT"] - 4 * QJN_Options["TOASTFRAME_PADDING"] - newToastFrame.friendName:GetHeight());
	newToastFrame.queueName:SetWordWrap(true);
	newToastFrame.queueName:SetJustifyH("LEFT");
	newToastFrame.queueName:SetJustifyV("BOTTOM");
	newToastFrame.queueName:SetText(queueDescription);
	newToastFrame.queueName:SetPoint("BOTTOMLEFT", QJN_Options["TOASTFRAME_PADDING"], QJN_Options["TOASTFRAME_PADDING"]);
	
	newToastFrame.animation = newToastFrame:CreateAnimationGroup();
	newToastFrame.animation.fadeInAnimation = newToastFrame.animation:CreateAnimation("Alpha");
	newToastFrame.animation.fadeInAnimation:SetDuration(0.2);
	newToastFrame.animation.fadeInAnimation:SetSmoothing("IN");
	newToastFrame.animation.fadeInAnimation:SetFromAlpha(0);
	newToastFrame.animation.fadeInAnimation:SetToAlpha(1);
	newToastFrame.animation.fadeInAnimation:SetOrder(1);
	newToastFrame.animation.fadeOutAnimation = newToastFrame.animation:CreateAnimation("Alpha");
	newToastFrame.animation.fadeOutAnimation:SetStartDelay(QJN_Options["TOAST_DURATION"]);
	newToastFrame.animation.fadeOutAnimation:SetDuration(1.5);
	newToastFrame.animation.fadeOutAnimation:SetSmoothing("OUT");
	newToastFrame.animation.fadeOutAnimation:SetFromAlpha(1);
	newToastFrame.animation.fadeOutAnimation:SetToAlpha(0);
	newToastFrame.animation.fadeOutAnimation:SetOrder(2);
	newToastFrame.animation.fadeOutAnimation:SetScript("OnFinished", function(self)
		self:GetParent():GetParent():close();
	end);
	
	newToastFrame.joinButton = CreateFrame("Button", newToastFrame:GetName() .. "JoinButton", newToastFrame, "UIPanelButtonTemplate")
	newToastFrame.joinButton:SetPoint("BOTTOMRIGHT", newToastFrame, "BOTTOMRIGHT", -5, 5)
	newToastFrame.joinButton:SetSize(50, 32) -- width, height
	newToastFrame.joinButton:SetText("加入")
	
	newToastFrame.rolesFrame = CreateFrame("FRAME", newToastFrame:GetName() .. "RolesFrame", newToastFrame)
	newToastFrame.rolesFrame:SetPoint("TOPRIGHT", newToastFrame, "TOPRIGHT", -QJN_Options["TOASTFRAME_PADDING"], -QJN_Options["TOASTFRAME_PADDING"])
	newToastFrame.rolesFrame:SetSize(50, QJN_Options["TOASTFRAME_HEIGHT"])
	
	newToastFrame.rolesFrame.damagerIcon = newToastFrame.rolesFrame:CreateTexture(newToastFrame:GetName() .. "DamagerIcon")
	newToastFrame.rolesFrame.damagerIcon:SetAtlas("groupfinder-icon-role-large-dps")
	newToastFrame.rolesFrame.damagerIcon:SetSize(17, 17)
	newToastFrame.rolesFrame.damagerIcon:SetPoint("TOPRIGHT", newToastFrame.rolesFrame, "TOPRIGHT")
	newToastFrame.rolesFrame.damagerText = newToastFrame.rolesFrame:CreateFontString(newToastFrame.rolesFrame:GetName() .. "DamagerText", "OVERLAY", "GameFontHighlightSmall");
	newToastFrame.rolesFrame.damagerText:SetPoint("RIGHT", newToastFrame.rolesFrame.damagerIcon, "LEFT")
	newToastFrame.rolesFrame.healerIcon = newToastFrame.rolesFrame:CreateTexture(newToastFrame:GetName() .. "HealerIcon")
	newToastFrame.rolesFrame.healerIcon:SetAtlas("groupfinder-icon-role-large-heal")
	newToastFrame.rolesFrame.healerIcon:SetSize(17, 17)
	newToastFrame.rolesFrame.healerIcon:SetPoint("RIGHT", newToastFrame.rolesFrame.damagerText, "LEFT")
	newToastFrame.rolesFrame.healerText = newToastFrame.rolesFrame:CreateFontString(newToastFrame.rolesFrame:GetName() .. "HealerText", "OVERLAY", "GameFontHighlightSmall");
	newToastFrame.rolesFrame.healerText:SetPoint("RIGHT", newToastFrame.rolesFrame.healerIcon, "LEFT")
	newToastFrame.rolesFrame.tankIcon = newToastFrame.rolesFrame:CreateTexture(newToastFrame:GetName() .. "TankIcon")
	newToastFrame.rolesFrame.tankIcon:SetAtlas("groupfinder-icon-role-large-tank")
	newToastFrame.rolesFrame.tankIcon:SetSize(17, 17)
	newToastFrame.rolesFrame.tankIcon:SetPoint("RIGHT", newToastFrame.rolesFrame.healerText, "LEFT")
	newToastFrame.rolesFrame.tankText = newToastFrame.rolesFrame:CreateFontString(newToastFrame.rolesFrame:GetName() .. "TankText", "OVERLAY", "GameFontHighlightSmall");
	newToastFrame.rolesFrame.tankText:SetPoint("RIGHT", newToastFrame.rolesFrame.tankIcon, "LEFT")
	
	newToastFrame.setFriendName = function (self, friendName)
		self.friendName:SetText(friendName);
		self.isQueuedText:ClearAllPoints();
		self.isQueuedText:SetPoint("LEFT", self.friendName, "RIGHT", 0, 0);
	end
	newToastFrame.setIsQueuedText = function (self, isQueuedText)
		self.isQueuedText:SetText(isQueuedText);
	end
	newToastFrame.setQueueName = function (self, queueName)
		self.queueName:SetText(queueName);
	end
	newToastFrame.close = function(self)
		toastContainer:close(self.id);
	end
	newToastFrame.refreshFontStringSize = function(self)
		self.isQueuedText:SetWidth(QJN_Options["TOASTFRAME_WIDTH"] - 3 * QJN_Options["TOASTFRAME_PADDING"] - self.friendName:GetWidth());
		self.queueName:SetWidth(QJN_Options["TOASTFRAME_WIDTH"] - 3 * QJN_Options["TOASTFRAME_PADDING"] - 50);
		--self.queueName:SetWidth(QJN_Options["TOASTFRAME_WIDTH"] - 3 * QJN_Options["TOASTFRAME_PADDING"]);
	end
	
	return newToastFrame;
end

local function init_toastContainer()
	toastContainer = CreateFrame("FRAME", "quickJoinToastContainer", UIParent);
	toastContainer:SetSize(QJN_Options["TOASTFRAME_WIDTH"], QJN_Options["TOASTCONTAINER_MAXTOASTS"] * (QJN_Options["TOASTFRAME_HEIGHT"] + QJN_Options["TOASTFRAME_MARGIN"]));
	toastContainer:SetPoint("BOTTOM" .. DEFAULT_CHAT_FRAME.buttonSide, DEFAULT_CHAT_FRAME, "TOP" .. DEFAULT_CHAT_FRAME.buttonSide, QJN_Options["TOASTCONTAINER_XOFFSET"], QJN_Options["TOASTCONTAINER_YOFFSET"])
	toastContainer:RegisterForDrag("LeftButton")
	toastContainer:SetClampedToScreen(true)
	
	toastContainer.toastQueue = {};
	toastContainer.nextToastID = QJN_Options["TOASTCONTAINER_MAXTOASTS"] + 1;
	
	--hide a frame, update index, reposition all frames and look if there are new toasts to update in toastQueue
	toastContainer.close = function (self, closeID)
		local lastRepositionedToastFrame = nil;
		local closedToastFrame = nil;
		
		for k, toast in pairs(self.toast) do
			if ( toast.id == closeID ) then
				toast:Hide();
				toast.id = self.nextToastID;
				self.nextToastID = self.nextToastID + 1;
				closedToastFrame = toast;
			end
		end

		table.sort(self.toast, function (toast1, toast2)
			return toast1.id < toast2.id;
		end);
		for k, toast in pairs(self.toast) do
			toast:ClearAllPoints();
			if ( lastRepositionedToastFrame == nil ) then
				toast:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide, toastContainer, QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide);
			else
				local margin = QJN_Options["TOASTFRAME_MARGIN"]
				if QJN_Options["TOASTFRAME_GROWDIRECTION"] == "BOTTOM" then
					margin = -1 * margin
				end
				toast:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"], lastRepositionedToastFrame, QJN_Options["TOASTFRAME_GROWDIRECTION"], 0, margin);
			end;
			lastRepositionedToastFrame = toast;
		end;
		
		self:processQueue();
	end;
	
	toastContainer.processQueue = function (self)
		if ( #self.toastQueue == 0 ) then
			return; --no new toasts to display
		end;
	
		local availableToastIndex = -1;
		local lowestToastID = self.nextToastID + 1; --higher number than all existing IDs
		for index, toast in pairs(self.toast) do
			if ( not toast:IsShown() and toast.id < lowestToastID ) then
				availableToastIndex = index;
				lowestToastID = toast.id;
			end;
		end;
		if ( availableToastIndex == -1 ) then
			return; --no toastFrame is currently available to receive information
		end;
		
		local toastData = table.remove(self.toastQueue, 1);
		self.toast[availableToastIndex]:setFriendName(toastData["friendName"]);
		self.toast[availableToastIndex]:setIsQueuedText(toastData["queueFlavorText"]);
		self.toast[availableToastIndex]:setQueueName(toastData["queueDescription"]);
		self.toast[availableToastIndex]:refreshFontStringSize();
		self.toast[availableToastIndex]:Show();
		self.toast[availableToastIndex].animation:Stop();
		self.toast[availableToastIndex].animation:Play();
		
		if toastData["queueType"] == "lfglist" then
			self.toast[availableToastIndex].joinButton.lfgListID = toastData["queueJoinInfo"]
			self.toast[availableToastIndex].joinButton:SetScript("OnClick", function(self)
				LFGListApplicationDialog_Show(LFGListApplicationDialog, self.lfgListID)
			end)
			self.toast[availableToastIndex].joinButton:Show()
		elseif toastData["queueType"] == "lfg" then
			self.toast[availableToastIndex].joinButton.quickJoinGUID = toastData["queueJoinInfo"]
			self.toast[availableToastIndex].joinButton:SetScript("OnClick", function(self)
				QuickJoinRoleSelectionFrame:ShowForGroup(self.quickJoinGUID);
			end)
			self.toast[availableToastIndex].joinButton:Show()
		else
			self.toast[availableToastIndex].joinButton:Hide()
		end
		
		if toastData["roles"] then
			self.toast[availableToastIndex].rolesFrame.damagerText:SetText(toastData["roles"]["DAMAGER"])
			self.toast[availableToastIndex].rolesFrame.healerText:SetText(toastData["roles"]["HEALER"])
			self.toast[availableToastIndex].rolesFrame.tankText:SetText(toastData["roles"]["TANK"])
			self.toast[availableToastIndex].rolesFrame:Show()
		else
			self.toast[availableToastIndex].rolesFrame:Hide()
		end
		
		if ( QJN_Options["TOAST_SOUND_ENABLED"] ) then
			PlaySound(79739); --UI_71_Social_Queueing_Toast
		end
		
		--process the queue again if there was more than one data set waiting and more than one frame available
		self:processQueue();
	end;
	
	toastContainer.addToast = function(self, friendName, queueFlavorText, queueDescription, queueType, queueJoinInfo, roles)
		local toastData = { ["friendName"] = friendName, ["queueFlavorText"] = queueFlavorText, ["queueDescription"] = queueDescription, ["queueType"] = queueType, ["queueJoinInfo"] = queueJoinInfo, ["roles"] = roles};
		table.insert(self.toastQueue, toastData);
		self:processQueue();
	end
	
	toastContainer.refreshFrameSize = function(self) 
		toastContainer:SetSize(QJN_Options["TOASTFRAME_WIDTH"], QJN_Options["TOASTCONTAINER_MAXTOASTS"] * (QJN_Options["TOASTFRAME_HEIGHT"] + QJN_Options["TOASTFRAME_MARGIN"]));
		for i=1,QJN_Options["TOASTCONTAINER_MAXTOASTS"] do
			toastContainer.toast[i]:SetSize(QJN_Options["TOASTFRAME_WIDTH"], QJN_Options["TOASTFRAME_HEIGHT"]);
			toastContainer.toast[i]:refreshFontStringSize();
		end
	end
	
	toastContainer.refreshAnimations = function(self)
		for i=1,QJN_Options["TOASTCONTAINER_MAXTOASTS"] do
			self.toast[i].animation.fadeOutAnimation:SetStartDelay(QJN_Options["TOAST_DURATION"])
		end
	end
	
	toastContainer.unlock = function(self)
		self:SetMovable(true)
		self:EnableMouse(true)
		self:SetScript("OnDragStart", function(self)
			self:StartMoving()
		end)
		self:SetScript("OnDragStop", function(self)
			--self:SetPoint(DEFAULT_CHAT_FRAME.buttonSide);
			local xOffset
			if ( string.upper(DEFAULT_CHAT_FRAME.buttonSide) == "LEFT" ) then
				xOffset = self:GetLeft() - DEFAULT_CHAT_FRAME:GetLeft()
			else
				xOffset = self:GetRight() - DEFAULT_CHAT_FRAME:GetRight()
			end
			local yOffset
			if ( QJN_Options["TOASTFRAME_ANCHORPOS"] == "BOTTOM" ) then
				yOffset = self:GetBottom() - DEFAULT_CHAT_FRAME:GetTop()
			else
				yOffset = self:GetTop() - DEFAULT_CHAT_FRAME:GetBottom()
			end
			self:StopMovingOrSizing()
			self:ClearAllPoints()
			--QJN_Options["TOASTCONTAINER_XOFFSET"], QJN_Options["TOASTCONTAINER_YOFFSET"]
			--toastContainer:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide, DEFAULT_CHAT_FRAME, QJN_Options["TOASTFRAME_GROWDIRECTION"] .. DEFAULT_CHAT_FRAME.buttonSide)
			--local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint(1)
			QJN_Options["TOASTCONTAINER_XOFFSET"] = xOffset
			QJN_Options["TOASTCONTAINER_YOFFSET"] = yOffset
			self:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide, DEFAULT_CHAT_FRAME, QJN_Options["TOASTFRAME_GROWDIRECTION"] .. DEFAULT_CHAT_FRAME.buttonSide, QJN_Options["TOASTCONTAINER_XOFFSET"], QJN_Options["TOASTCONTAINER_YOFFSET"])
		end)
		self:SetBackdrop(toastBG)
	end
	
	toastContainer.lock = function(self)
		self:SetMovable(false)
		self:EnableMouse(false)
		self:SetScript("OnDragStart", nil)
		self:SetScript("OnDragStop", nil)
		self:SetBackdrop(nil)
	end
	
	toastContainer.resetPosition = function(self)
		QJN_Options["TOASTCONTAINER_XOFFSET"] = QJN_Defaults["TOASTCONTAINER_XOFFSET"]
		QJN_Options["TOASTCONTAINER_YOFFSET"] = QJN_Defaults["TOASTCONTAINER_YOFFSET"]
		self:ClearAllPoints()
		--self:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide, DEFAULT_CHAT_FRAME, QJN_Options["TOASTFRAME_GROWDIRECTION"] .. DEFAULT_CHAT_FRAME.buttonSide, QJN_Options["TOASTCONTAINER_XOFFSET"], QJN_Options["TOASTCONTAINER_YOFFSET"])
		self:SetPoint("BOTTOM" .. DEFAULT_CHAT_FRAME.buttonSide, DEFAULT_CHAT_FRAME, "TOP" .. DEFAULT_CHAT_FRAME.buttonSide, QJN_Options["TOASTCONTAINER_XOFFSET"], QJN_Options["TOASTCONTAINER_YOFFSET"])
		--reset position of all toastFrames by closing them
		for k, toast in pairs(self.toast) do
			self:close(toast.id)
		end
	end
	
	--create and reuse frames;
	toastContainer.toast = {};
	for i=1,QJN_Options["TOASTCONTAINER_MAXTOASTS"] do
		toastContainer.toast[i] = createToastFrame("", "", "", i, toastContainer);
		toastContainer.toast[i]:Hide();
		
		if ( i == 1 ) then
			toastContainer.toast[i]:ClearAllPoints();
			toastContainer.toast[i]:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide, toastContainer, QJN_Options["TOASTFRAME_ANCHORPOS"] .. DEFAULT_CHAT_FRAME.buttonSide);
		else
			toastContainer.toast[i]:ClearAllPoints();
			local margin = QJN_Options["TOASTFRAME_MARGIN"]
			if QJN_Options["TOASTFRAME_GROWDIRECTION"] == "BOTTOM" then
				margin = -1 * margin
			end
			toastContainer.toast[i]:SetPoint(QJN_Options["TOASTFRAME_ANCHORPOS"], toastContainer.toast[i-1], QJN_Options["TOASTFRAME_GROWDIRECTION"], 0, margin);
		end;
	end;
end;

local function checkIfLeader(leaderName, friendName)
	if leaderName == friendName then
		--this is the case for guild mates that are not your Battle.net friends
		return true
	end
	local bnetFriendName = ""
	for i=1,BNGetNumFriends() do
		local bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, client, isOnline, lastOnline, isBnetAFK, isBnetDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(i);
		if isOnline then
			local hasFocus, characterName, client, realmName, realmID, faction, race, class, _, zoneName, level, gameText = BNGetGameAccountInfo(bnetIDGameAccount);
			local playerRealmName = GetRealmName();
			if accountName == friendName then
				bnetFriendName = characterName
				if realmName ~= playerRealmName then
					bnetFriendName = bnetFriendName.."-"..realmName
				end
			end
		end
	end
	return leaderName == bnetFriendName
end


--"public" functions
function QJN_addQuickJoinNotification(friendName, queueFlavorText, queueDescription, queueType, ...)
	if ( QJN_Options["CHAT_ENABLED"] ) then
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00快速加入：|r"..friendName..queueFlavorText.." "..queueDescription)
	end
	--toastContainer might not be initialised yet if an event fires during the loading process
	if ( QJN_Options["TOASTS_ENABLED"] and toastContainer ~= nil ) then
		toastContainer:addToast(friendName, queueFlavorText, queueDescription, queueType, ...)
	end
end

function QJN_applyToastOptions()
	toastContainer:refreshFrameSize()
	toastContainer:refreshAnimations()
end

function QJN_processOptions()
	--hide or show blizzards toasts
	if ( QJN_Options["HIDE_BLIZZARD_TOASTS"] ) then
		QuickJoinToastButton.ShouldSuppressAllToasts = function(self)
			return true;
		end
	else
		QuickJoinToastButton.ShouldSuppressAllToasts = function(self)
			return IsInGroup() or QUICK_JOIN_CONFIG.TOASTS_DISABLED;
		end
	end
end

local locked = true
function QJN_toggleLock()
	locked = not locked
	if locked then
		toastContainer:lock()
	else
		toastContainer:unlock()
	end
end

function QJN_resetPosition()
	toastContainer:resetPosition()
end

local function AppendQueueName(textTable, name, nameFormatter)
	if ( name ) then
		if ( nameFormatter ) then
			name = nameFormatter:format(name);
		end

		table.insert(textTable, name);
	end
end

--from Blizzard's SocialQueue.lua, but no formatting of the return value
local function QJN_SocialQueueUtil_GetQueueName(queue, nameFormatter)
	local nameText = {};

	if ( queue.queueType == "lfg" ) then
		for i, lfgID in ipairs(queue.lfgIDs) do
			local name, typeID, subtypeID, minLevel, maxLevel, recLevel, minRecLevel, maxRecLevel, expansionLevel, groupID, textureFilename, difficulty, maxPlayers, description, isHoliday, _, _, isTimeWalker = GetLFGDungeonInfo(lfgID);
			if ( typeID == TYPEID_RANDOM_DUNGEON or isTimeWalker or isHoliday ) then
				-- Name remains unchanged
			elseif ( subtypeID == LFG_SUBTYPEID_DUNGEON ) then
				name = SOCIAL_QUEUE_FORMAT_DUNGEON:format(name);
			elseif ( subtypeID == LFG_SUBTYPEID_HEROIC ) then
				name = SOCIAL_QUEUE_FORMAT_HEROIC_DUNGEON:format(name);
			elseif ( subtypeID == LFG_SUBTYPEID_RAID ) then
				name = SOCIAL_QUEUE_FORMAT_RAID:format(name);
			elseif ( subtypeID == LFG_SUBTYPEID_FLEXRAID ) then
				name = SOCIAL_QUEUE_FORMAT_RAID:format(name);
			elseif ( subtypeID == LFG_SUBTYPEID_WORLDPVP ) then
				name = SOCIAL_QUEUE_FORMAT_WORLDPVP:format(name);
			else
				-- Name remains unchanged
			end

			AppendQueueName(nameText, name, nameFormatter);
		end
	elseif ( queue.queueType == "pvp" ) then
		local battlefieldType = queue.battlefieldType;
		local isBrawl = queue.isBrawl;
		local name = queue.mapName;
		if (isBrawl) then
			local brawlInfo = C_PvP.GetBrawlInfo();
			if (brawlInfo and brawlInfo.active) then
				name = brawlInfo.name;
			end
		elseif ( battlefieldType == "BATTLEGROUND" ) then
			name = SOCIAL_QUEUE_FORMAT_BATTLEGROUND:format(name);
		elseif ( battlefieldType == "ARENA" ) then
			name = SOCIAL_QUEUE_FORMAT_ARENA:format(queue.teamSize);
		elseif ( battlefieldType == "ARENASKIRMISH" ) then
			name = SOCIAL_QUEUE_FORMAT_ARENA_SKIRMISH;
		end

		AppendQueueName(nameText, name, nameFormatter);
	elseif ( queue.queueType == "lfglist" ) then
		local name;
		if ( queue.lfgListID ) then
			name = select(3, C_LFGList.GetSearchResultInfo(queue.lfgListID));
		else
			if ( queue.activityID ) then
				name = C_LFGList.GetActivityInfo(queue.activityID);
			end
		end

		AppendQueueName(nameText, name, nameFormatter);
	end
	
	return nameText;
end

--Event frame
local IGNORE_EVENTS_TIME = 10; --seconds
local timeOfAddonEvent;
local QJNframe = CreateFrame("Frame", "QJN_Eventframe");
QJNframe:RegisterEvent("SOCIAL_QUEUE_UPDATE");
QJNframe:RegisterEvent("ADDON_LOADED");


function QJNframe:OnEvent(event, ...)
	if ( event == "SOCIAL_QUEUE_UPDATE" ) then
		--Blizzard's code seems to have issues with looking up names in the first seconds after logging in, probably before all addon and item information is loaded
		--so don't handle any quick join queues in the first seconds after the addon loaded
		if ( time() - timeOfAddonEvent <= IGNORE_EVENTS_TIME ) then
			return;
		end
		
	
		local guid, numAddedItems = ...;
		
		if ( numAddedItems == 0 or C_SocialQueue.GetGroupMembers(guid) == nil) then
			--this seems to indicate that no additional data is provided for this event, therefore we ignore it
			return;
		end
		
		function dump_table(t, prefix)
			if prefix == nil then prefix = ""; end
			if type(t) == "table" then
				for k,v in pairs(t) do
					dump_table(v, prefix..k.." => ")
				end
			else
				print(prefix .. tostring(t));
			end
		end
		
		--[[for k,v in pairs(C_SocialQueue.GetGroupQueues(guid)) do
			if type(v) == "table" then
				for k2,v2 in pairs(v) do
					if type(v2) == "table" then
						for k3,v3 in pairs(v2) do
							print(k.." => "..k2.." => "..k3.." => "..tostring(v3));
						end
					else
						print(k.." => "..k2.." => "..tostring(v2));
					end
				end
			else
				print(k.." => "..v);
			end
		end
		--]]
		--dump_table(C_SocialQueue.GetGroupQueues(guid));
		--print("C_SocialQueue.GetGroupQueues")
		--queueinfo = {C_SocialQueue.GetGroupQueues(guid)};
		--dump_table(queueinfo);
		--print("#####")
		--print("C_SocialQueue.GetGroupQueues")
		--info = {C_LFGList.GetSearchResultInfo(C_SocialQueue.GetGroupQueues(guid)[1].queueData.lfgListID)};
		--dump_table(info);
		--print("#####")
		--print("C_LFGList.GetActivityInfo")
		--info2 = {C_LFGList.GetActivityInfo(info[2])};
		--dump_table(info2);
		--print(SocialQueueUtil_GetQueueName(queueinfo[1][1].queueData));
		
		--instanceType can be arena, none, party, pvp, raid, scenario
		instanceType, _ = select(2, GetInstanceInfo())
		local instanceTypeToOptionName = { ["arena"] = "ENABLED_IN_ARENAS", ["party"] = "ENABLED_IN_DUNGEONS", ["pvp"] = "ENABLED_IN_BATTLEGROUNDS", ["raid"] = "ENABLED_IN_RAIDS" }
		if QJN_Options[instanceTypeToOptionName[instanceType]] == false then
			return;
		end
		
		local members, playerName, color;
		if C_SocialQueue.GetGroupMembers(guid) ~= nil then
			members = SocialQueueUtil_SortGroupMembers(C_SocialQueue.GetGroupMembers(guid));
			playerName, color = SocialQueueUtil_GetNameAndColor(members[1]);
		end
		local coloredPlayerName = color..playerName.."|r"
		
		local queues = C_SocialQueue.GetGroupQueues(guid);
		if queues ~= nil then
			if ( queues[1].queueData.queueType == "lfglist" ) then
				if ( queues[1].eligible ) then
					--lfglist groups can't queue in the regular LFG tool, so we only need to check this queue
					local queue = queues[1];
					
					local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, numMembers = C_LFGList.GetSearchResultInfo(queue.queueData.lfgListID);
					local activityName, shortName, categoryID, groupID, minItemLevel, filters, minLevel, maxPlayers, displayType, _, useHonorLevel = C_LFGList.GetActivityInfo(activityID);
					
					--extract info about roles; roles are "DAMAGER", "TANK" and "HEALER"
					local roles = { TANK = 0, HEALER = 0, DAMAGER = 0 }
					for i=1,numMembers do
						local role, class, classLocalized = C_LFGList.GetSearchResultMemberInfo(queue.queueData.lfgListID, i);
						roles[role] = roles[role] + 1
					end
					rolesShortText = "("..roles["TANK"].."/"..roles["HEALER"].."/"..roles["DAMAGER"]..")"
					
					--ignore groups created by the addon World Quest Group Finder
					if ( string.find(comment, "World Quest Group Finder") ) then
						return
					end
					
					--create flavor text
					local friendIsLeader = checkIfLeader(leaderName, playerName)
					local flavorText = ""
					if friendIsLeader then
						flavorText = " 正在尋找隊友："
					else
						flavorText = " 加入了隊伍："
					end
					
					if ( comment == "" ) then
						QJN_addQuickJoinNotification(coloredPlayerName, flavorText, activityName.."："..name, "lfglist", queue.queueData.lfgListID, roles);
					else
						QJN_addQuickJoinNotification(coloredPlayerName, flavorText, activityName.."："..name.."\n("..comment..")", "lfglist", queue.queueData.lfgListID, roles);
					end
				end
			else
				--maybe several queues, concat all of them for displaying
				local queueSummaryName = "";
				local anyEligibleQueue = false;
				for id, queue in pairs(queues) do
					if ( queue.eligible ) then
						anyEligibleQueue = true;
						local queueNameTable = QJN_SocialQueueUtil_GetQueueName(queue.queueData);
						local queueName = "";
						for queueId, name in pairs(queueNameTable) do
							if queueName == "" then
								queueName = name;
							else
								queueName = queueName..", "..name;
							end
						end
						if ( queueSummaryName == "" ) then
							queueSummaryName = queueName;
						else
							queueSummaryName = queueSummaryName..", "..queueName;
						end
					end
				end
				if ( anyEligibleQueue ) then
					QJN_addQuickJoinNotification(coloredPlayerName, " 加入了等候：", queueSummaryName, "lfg", guid);
				end
			end
		end
	elseif ( event == "ADDON_LOADED" and ... == QJN_Addon ) then
		timeOfAddonEvent = time();
		loadOptions();
		init_QJN_OptionsPanel();
		init_toastContainer();
		QJN_processOptions();
	end
end

QJNframe:SetScript("OnEvent", QJNframe.OnEvent);

SLASH_QJN_QJNDEBUG1 = "/qjndebug";
SlashCmdList["QJN_QJNDEBUG"] = function (msg) 
	if ( msg == "add" ) then
		toastContainer:addToast("testName", "queueueueueued", "testQueueDescription");
	end
end