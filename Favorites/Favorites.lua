Favorites = LibStub("AceAddon-3.0"):NewAddon("Favorites", "AceEvent-3.0", "AceHook-3.0","AceConsole-3.0")
local defaults = {
  profile = {
	colorBackground = false,
	classColorOppositeFaction = false,
	favTypes = {
		["最愛"] = {	},
	},
	favBTs = {	}
  }
}
local friendSearchValue = ""
local old = FriendsFrame_UpdateFriendButton
local oldFLU = FriendsList_Update
local oldFriendsList_GetScrollFrameTopButton = FriendsList_GetScrollFrameTopButton
local oldFriendsFrame_UpdateFriends = FriendsFrame_UpdateFriends
local FriendListEntries = { }
local BNET_HEADER_TEXT = 6;
local BNET_SEARCH = 20;
FRIENDS_BUTTON_HEIGHTS[FRIENDS_BUTTON_TYPE_DIVIDER] = 10
FRIENDS_BUTTON_HEIGHTS[BNET_HEADER_TEXT] = 25;
FRIENDS_BUTTON_HEIGHTS[BNET_SEARCH] = 25;
local ONE_MINUTE = 60;
local ONE_HOUR = 60 * ONE_MINUTE;
local ONE_DAY = 24 * ONE_HOUR;
local ONE_MONTH = 30 * ONE_DAY;
local ONE_YEAR = 12 * ONE_MONTH;
-- local ONE_MILLENIUM = 1000 * ONE_YEAR; 	for the future
local INVITE_RESTRICTION_NO_GAME_ACCOUNTS = 0;
local INVITE_RESTRICTION_CLIENT = 1;
local INVITE_RESTRICTION_LEADER = 2;
local INVITE_RESTRICTION_FACTION = 3;
local INVITE_RESTRICTION_INFO = 4;
local INVITE_RESTRICTION_NONE = 5;

function BNGetNumFavs(t)
  local count = 0
  local online = 0
  for _ in pairs(Favorites.db.profile.favTypes[t]) do count = count + 1 end
  for i=1, BNGetNumFriends() do
		local _, _, battleTag, _, _, _, client, o = BNGetFriendInfo(i);
		if Favorites.db.profile.favTypes[t][battleTag] then
			if o then
				online = online+1
			end
		end
  end
  return count, online
end

function Favorites:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("favsDB", defaults, true)
	self:SetupOptions()
end 

local function FriendsList_UpdateFIX(forceUpdate)

	local numBNetTotal, numBNetOnline = BNGetNumFriends();
	local numBNetOffline = numBNetTotal - numBNetOnline;
	local numWoWTotal, numWoWOnline = GetNumFriends();
	local numWoWOffline = numWoWTotal - numWoWOnline;
	
	QuickJoinToastButton:UpdateDisplayedFriendCount();
	if ( not FriendsListFrame:IsShown() and not forceUpdate) then
		return;
	end

	local addButtonIndex = 0;
	local totalButtonHeight = 0;
	local function AddButtonInfo(buttonType, id, favName, bnSep)
		local na = nil
		if ( buttonType == FRIENDS_BUTTON_TYPE_BNET ) then
			_, _, na, _, ca, _, _, _ = BNGetFriendInfo(id);
		elseif ( buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
			na, _, _, _, _, _, _, _, _ = GetFriendInfo(id);
		end
		if not (friendSearchValue == "") then
			if (na and ca) and (not string.find(string.lower(na), string.lower(friendSearchValue)) and ca and not string.find(string.lower(ca), string.lower(friendSearchValue))) then
				return
			elseif (na and not ca) and (not string.find(string.lower(na), string.lower(friendSearchValue))) then
				return
			elseif (not na and ca) and (not string.find(string.lower(ca), string.lower(friendSearchValue))) then
				return
			end
		end
		addButtonIndex = addButtonIndex + 1;
		if ( not FriendListEntries[addButtonIndex] ) then
			FriendListEntries[addButtonIndex] = { };
		end
		FriendListEntries[addButtonIndex].buttonType = buttonType;
		FriendListEntries[addButtonIndex].id = id;
		FriendListEntries[addButtonIndex].favName = favName;
		FriendListEntries[addButtonIndex].bnSep = bnSep;
		totalButtonHeight = totalButtonHeight + FRIENDS_BUTTON_HEIGHTS[buttonType];
	end

	-- invites
	local numInvites = BNGetNumFriendInvites();
	if ( numInvites > 0 ) then
		AddButtonInfo(FRIENDS_BUTTON_TYPE_INVITE_HEADER, nil);
		if ( not GetCVarBool("friendInvitesCollapsed") ) then
			for i = 1, numInvites do
				AddButtonInfo(FRIENDS_BUTTON_TYPE_INVITE, i);
			end
			-- add divider before friends
			if ( numBNetTotal + numWoWTotal > 0 ) then
				AddButtonInfo(FRIENDS_BUTTON_TYPE_DIVIDER, nil);
			end
		end
	end	
	-- search
	AddButtonInfo(BNET_SEARCH, nil, nil, false);
	-- favs
	for l, s in pairs(Favorites.db.profile.favTypes) do
		local _, online = BNGetNumFavs(l)
		if online > 0 then
			AddButtonInfo(BNET_HEADER_TEXT, nil, l)
			-- favorite Battlenet friends
			local addedAny = false
			for i = 1, numBNetOffline+numBNetOnline do
				local id, _, battleTag , _, _, _, client, o = BNGetFriendInfo(i);
				if s[id] then
					s[id] = nil;
					s[battleTag] = true
				end
				if o and s[battleTag] then
					addedAny = true
					AddButtonInfo(FRIENDS_BUTTON_TYPE_BNET, i);			
				end
			end
		end
	end
	AddButtonInfo(BNET_HEADER_TEXT, nil, nil, true);

	
	-- online Battlenet friends
	for i = 1, numBNetOnline do
		local _, _, battleTag, _, _, _, client = BNGetFriendInfo(i);
		local addIt = true
		for l, s in pairs(Favorites.db.profile.favTypes) do
			if s[battleTag] then
				addIt = false
			end
		end
		if addIt then
			AddButtonInfo(FRIENDS_BUTTON_TYPE_BNET, i);
		end
	end
	-- online WoW friends
	for i = 1, numWoWOnline do
		AddButtonInfo(FRIENDS_BUTTON_TYPE_WOW, i);
	end
	-- divider between online and offline friends
	if ( (numBNetOnline > 0 or numWoWOnline > 0) and (numBNetOffline > 0 or numWoWOffline > 0) ) then
		AddButtonInfo(FRIENDS_BUTTON_TYPE_DIVIDER, nil);
	end
	-- offline Battlenet friends
	for i = 1, numBNetOffline do
		AddButtonInfo(FRIENDS_BUTTON_TYPE_BNET, i + numBNetOnline);
	end
	-- offline WoW friends
	for i = 1, numWoWOffline do
		AddButtonInfo(FRIENDS_BUTTON_TYPE_WOW, i + numWoWOnline);
	end

	FriendsFrameFriendsScrollFrame.totalFriendListEntriesHeight = totalButtonHeight;
	FriendsFrameFriendsScrollFrame.numFriendListEntries = addButtonIndex;

	-- selection
	local selectedFriend = 0;
	-- check that we have at least 1 friend
	if ( numBNetTotal + numWoWTotal > 0 ) then
		-- get friend
		if ( FriendsFrame.selectedFriendType == FRIENDS_BUTTON_TYPE_WOW ) then
			selectedFriend = GetSelectedFriend();
		elseif ( FriendsFrame.selectedFriendType == FRIENDS_BUTTON_TYPE_BNET ) then
			selectedFriend = BNGetSelectedFriend();
		end
		-- set to first in list if no friend
		if ( not selectedFriend or selectedFriend == 0 ) then
			FriendsFrame_SelectFriend(FriendListEntries[1].buttonType, 1);
			selectedFriend = 1;
		end
		-- check if friend is online
		local isOnline;
		if ( FriendsFrame.selectedFriendType == FRIENDS_BUTTON_TYPE_WOW ) then
			local name, level, class, area;
			name, level, class, area, isOnline = GetFriendInfo(selectedFriend);
		elseif ( FriendsFrame.selectedFriendType == FRIENDS_BUTTON_TYPE_BNET ) then
			local bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, client;
			bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, client, isOnline = BNGetFriendInfo(selectedFriend);
			if ( not accountName ) then
				isOnline = false;
			end
		end
		if ( isOnline ) then
			FriendsFrameSendMessageButton:Enable();
		else
			FriendsFrameSendMessageButton:Disable();
		end
	else
		FriendsFrameSendMessageButton:Disable();
	end
	FriendsFrame.selectedFriend = selectedFriend;
	FriendsFrame_UpdateFriends();

	-- RID warning, upon getting the first RID invite
	local showRIDWarning = false;
	local numInvites = BNGetNumFriendInvites();
	if ( numInvites > 0 and not GetCVarBool("pendingInviteInfoShown") ) then
		local _, _, _, _, _, _, isRIDEnabled = BNGetInfo();
		if ( isRIDEnabled ) then
			for i = 1, numInvites do
				local inviteID, accountName, isBattleTag = BNGetFriendInviteInfo(i);
				if ( not isBattleTag ) then
					-- found one
					showRIDWarning = true;
					break;
				end
			end
		end
	end
	if ( showRIDWarning ) then
		FriendsListFrame.RIDWarning:Show();
		FriendsFrameFriendsScrollFrame.scrollBar:Disable();
		FriendsFrameFriendsScrollFrame.scrollUp:Disable();
		FriendsFrameFriendsScrollFrame.scrollDown:Disable();
	else
		FriendsListFrame.RIDWarning:Hide();
	end
end

local function FriendsFrame_UpdateFriendsNEW()
	local scrollFrame = FriendsFrameFriendsScrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	local numButtons = #buttons;
	local numFriendButtons = scrollFrame.numFriendListEntries;

	local usedHeight = 0;

	scrollFrame.dividerPool:ReleaseAll();
	scrollFrame.invitePool:ReleaseAll();
	scrollFrame.PendingInvitesHeaderButton:Hide();
	for i = 1, numButtons do
		local button = buttons[i];
		local index = offset + i;
		if ( index <= numFriendButtons ) then
			button.index = index;
			local height = FriendsFrame_UpdateFriendButton(button);
			button:SetHeight(height);
			usedHeight = usedHeight + height;
		else
			button.index = nil;
			button:Hide();
		end
	end
	HybridScrollFrame_Update(scrollFrame, scrollFrame.totalFriendListEntriesHeight, usedHeight);
end

local function fix(button)
	local function getEmbeddedFactionIcon(factionGroup)
		if ( factionGroup == "Alliance" ) then
			return "Interface\\TargetingFrame\\UI-PVP-ALLIANCE";
		elseif ( factionGroup == "Horde" ) then
			return "Interface\\TargetingFrame\\UI-PVP-HORDE";
		else --Say what?
			return "";
		end
	end
	local index = button.index;
	button.buttonType = FriendListEntries[index].buttonType;
	button.id = FriendListEntries[index].id;
	button.favName = FriendListEntries[index].favName
	button.bnSep = FriendListEntries[index].bnSep
	if button.header then
		button.header:Hide()
	end
	if button.searchBox and not (button.buttonType == BNET_SEARCH) then
		button.searchBox.updating = true;
		button.searchBox:Hide()
	end
	if button.facIcon then button.facIcon:Hide() end
	local height = FRIENDS_BUTTON_HEIGHTS[button.buttonType];
	local nameText, nameColor, infoText, broadcastText;	
	local hasTravelPassButton = false;
	if ( button.buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
		local name, level, class, area, connected, status, note, isRaF, guid = GetFriendInfo(FriendListEntries[index].id);
		broadcastText = nil;
		if ( connected ) then
			button.background:SetColorTexture(FRIENDS_WOW_BACKGROUND_COLOR.r, FRIENDS_WOW_BACKGROUND_COLOR.g, FRIENDS_WOW_BACKGROUND_COLOR.b, FRIENDS_WOW_BACKGROUND_COLOR.a);
			if ( status == "" ) then
				button.status:SetTexture(FRIENDS_TEXTURE_ONLINE);
			elseif ( status == CHAT_FLAG_AFK ) then
				button.status:SetTexture(FRIENDS_TEXTURE_AFK);
			elseif ( status == CHAT_FLAG_DND ) then
				button.status:SetTexture(FRIENDS_TEXTURE_DND);
			end
			nameText = name..", "..format(FRIENDS_LEVEL_TEMPLATE, level, class);
			nameColor = RAID_CLASS_COLORS[string.upper(class)];
		else
			button.background:SetColorTexture(FRIENDS_OFFLINE_BACKGROUND_COLOR.r, FRIENDS_OFFLINE_BACKGROUND_COLOR.g, FRIENDS_OFFLINE_BACKGROUND_COLOR.b, FRIENDS_OFFLINE_BACKGROUND_COLOR.a);
			button.status:SetTexture(FRIENDS_TEXTURE_OFFLINE);
			nameText = name;
			nameColor = FRIENDS_GRAY_COLOR;
		end
		infoText = area;
		button.gameIcon:Hide();
		button.summonButton:ClearAllPoints();
		button.summonButton:SetPoint("TOPRIGHT", button, "TOPRIGHT", 1, -1);
		FriendsFrame_SummonButton_Update(button.summonButton);
	elseif ( button.buttonType == FRIENDS_BUTTON_TYPE_BNET ) then
		local bnetIDAccount, accountName, battleTag, isBattleTag, characterName, bnetIDGameAccount, client, isOnline, lastOnline, isBnetAFK, isBnetDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(FriendListEntries[index].id);
		broadcastText = messageText;
		-- set up player name and character name
		local characterName = characterName;
		if ( accountName ) then
			nameText = accountName;
			if ( isOnline ) then
				characterName = BNet_GetValidatedCharacterName(characterName, battleTag, client);
			end
		else
			nameText = UNKNOWN;				
		end

		-- append character name
		if ( characterName ) then
			local gf = true
			if not Favorites.db.profile.classColorOppositeFaction then
				gf = CanCooperateWithGameAccount(bnetIDGameAccount)
			end
			if ( client == BNET_CLIENT_WOW and gf) then
				local _, _, _, _, _, faction, _, class, _, _, _, _, _, _, _, _, _, _, _, _ = BNGetGameAccountInfo(bnetIDGameAccount);
				if not class then 
					nameText = nameText.." ".."("..FRIENDS_WOW_NAME_COLOR_CODE..characterName..FONT_COLOR_CODE_CLOSE..")";
				else
					class = string.gsub(string.upper(class), "%s+", "")
					if RAID_CLASS_COLORS[class] then 
						nameText = nameText.." ".."(".."|c"..RAID_CLASS_COLORS[class].colorStr..characterName..FONT_COLOR_CODE_CLOSE..")";
					end
				end
			else
				if ( ENABLE_COLORBLIND_MODE == "1" ) then
					characterName = characterName..CANNOT_COOPERATE_LABEL;
				end
				nameText = nameText.." "..FRIENDS_OTHER_NAME_COLOR_CODE.."("..characterName..")"..FONT_COLOR_CODE_CLOSE;
			end
		end

		if ( isOnline ) then
			local _, _, _, realmName, realmID, faction, _, _, _, zoneName, _, gameText, _, _, _, _, _, isGameAFK, isGameBusy, guid = BNGetGameAccountInfo(bnetIDGameAccount);
			button.background:SetColorTexture(FRIENDS_BNET_BACKGROUND_COLOR.r, FRIENDS_BNET_BACKGROUND_COLOR.g, FRIENDS_BNET_BACKGROUND_COLOR.b, FRIENDS_BNET_BACKGROUND_COLOR.a);
			if Favorites.db.profile.colorBackground then
				if faction == "Alliance" then
					button.background:SetColorTexture(0.2, 0.2, 0.7, 0.2);
				elseif faction == "Horde" then
					button.background:SetColorTexture(0.7, 0.2, 0.2, 0.2);
				end
			end
			if ( isBnetAFK or isGameAFK ) then
				button.status:SetTexture(FRIENDS_TEXTURE_AFK);
			elseif ( isBnetDND or isGameBusy ) then
				button.status:SetTexture(FRIENDS_TEXTURE_DND);
			else
				button.status:SetTexture(FRIENDS_TEXTURE_ONLINE);
			end
			if ( client == BNET_CLIENT_WOW ) then
				if ( not zoneName or zoneName == "" ) then
					infoText = UNKNOWN;
				else
					infoText = zoneName;
				end
				if not button.facIcon then button.facIcon = button:CreateTexture("facIcon"); end
				button.facIcon:ClearAllPoints();
				button.facIcon:SetPoint("RIGHT", button.gameIcon, "LEFT", 7, -5);
				button.facIcon:SetWidth(button.gameIcon:GetWidth())
				button.facIcon:SetHeight(button.gameIcon:GetHeight())
				button.facIcon:SetTexture(getEmbeddedFactionIcon(faction));
				button.facIcon:Show()
			else			
				infoText = gameText;
			end
			button.gameIcon:SetTexture(BNet_GetClientTexture(client));
			nameColor = FRIENDS_BNET_NAME_COLOR;

			--Note - this logic should match the logic in FriendsFrame_ShouldShowSummonButton

			local shouldShowSummonButton = FriendsFrame_ShouldShowSummonButton(button.summonButton);
			button.gameIcon:SetShown(not shouldShowSummonButton);

			-- travel pass
			hasTravelPassButton = true;
			local restriction = FriendsFrame_GetInviteRestriction(button.id);
			if ( restriction == INVITE_RESTRICTION_NONE ) then
				button.travelPassButton:Enable();
			else
				button.travelPassButton:Disable();
			end
		else
			button.background:SetColorTexture(FRIENDS_OFFLINE_BACKGROUND_COLOR.r, FRIENDS_OFFLINE_BACKGROUND_COLOR.g, FRIENDS_OFFLINE_BACKGROUND_COLOR.b, FRIENDS_OFFLINE_BACKGROUND_COLOR.a);
			button.status:SetTexture(FRIENDS_TEXTURE_OFFLINE);
			nameColor = FRIENDS_GRAY_COLOR;
			button.gameIcon:Hide();
			if ( not lastOnline or lastOnline == 0 or time() - lastOnline >= ONE_YEAR ) then
				infoText = FRIENDS_LIST_OFFLINE;
			else
				infoText = string.format(BNET_LAST_ONLINE_TIME, FriendsFrame_GetLastOnline(lastOnline));
			end
		end
		button.summonButton:ClearAllPoints();
		button.summonButton:SetPoint("CENTER", button.gameIcon, "CENTER", 1, 0);
		FriendsFrame_SummonButton_Update(button.summonButton);
	elseif ( button.buttonType == FRIENDS_BUTTON_TYPE_DIVIDER ) then
		local scrollFrame = FriendsFrameFriendsScrollFrame;
		local divider = scrollFrame.dividerPool:Acquire();
		divider:SetParent(scrollFrame.ScrollChild);
		divider:SetAllPoints(button);
		divider:Show();
		nameText = nil;
	elseif ( button.buttonType == FRIENDS_BUTTON_TYPE_INVITE_HEADER ) then
		local header = FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton;
		header:SetPoint("TOPLEFT", button, 1, 0);
		header:Show();
		header:SetFormattedText(FRIEND_REQUESTS, BNGetNumFriendInvites());
		local collapsed = GetCVarBool("friendInvitesCollapsed");
		if ( collapsed ) then
			header.DownArrow:Hide();
			header.RightArrow:Show();
		else
			header.DownArrow:Show();
			header.RightArrow:Hide();
		end
		nameText = nil;
	elseif ( button.buttonType == FRIENDS_BUTTON_TYPE_INVITE ) then
		local scrollFrame = FriendsFrameFriendsScrollFrame;
		local invite = scrollFrame.invitePool:Acquire();
		invite:SetParent(scrollFrame.ScrollChild);
		invite:SetAllPoints(button);
		invite:Show();
		local inviteID, accountName = BNGetFriendInviteInfo(button.id);
		invite.Name:SetText(accountName);
		invite.inviteID = inviteID;
		invite.inviteIndex = button.id;
		nameText = nil;
	elseif (button.buttonType == BNET_HEADER_TEXT) then
		local scrollFrame = FriendsFrameFriendsScrollFrame;
		local header = button.header 
		if not header then
			header = CreateFrame("Button", "favHeader", scrollFrame.ScrollChild);
			header:SetDisabledFontObject(GameFontNormalSmall)
			header:SetHighlightFontObject(GameFontNormalSmall)
			header:SetNormalFontObject(GameFontNormalSmall)
			header:Disable()
		end
	--	local header = FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton;
		header:SetWidth(button:GetWidth())
		header:SetHeight(height)
		header:SetParent(scrollFrame.ScrollChild);
		header:SetAllPoints(button);
		header:Show();
		if button.bnSep then 
			header:SetText("BattleNet 好友");
		else
			local ft, fo = BNGetNumFavs(button.favName)
			header:SetFormattedText(button.favName.." (%d/%d)", fo, ft);
		end
		button.header = header;
		local scrollFrame = FriendsFrameFriendsScrollFrame;
		local divider = scrollFrame.dividerPool:Acquire();
		divider:ClearAllPoints()
		divider:SetPoint("BOTTOM", header ,"BOTTOM", 0, -8);
		divider:SetParent(scrollFrame.ScrollChild);
		divider:Show();

		nameText = nil;
	elseif (button.buttonType == BNET_SEARCH) then
		local scrollFrame = FriendsFrameFriendsScrollFrame;
		local searchBox = button.searchBox 
		if not searchBox then
			searchBox = CreateFrame("EditBox", "searchBox", scrollFrame.ScrollChild, "SearchBoxTemplate");
			searchBox.Instructions:SetText("搜尋好友");
			searchBox:SetScript("OnHide", FriendSearch_OnHide)
			searchBox:SetScript("OnTextChanged", FriendSearch_OnTextChanged)
			searchBox:SetScript("OnChar", FriendSearch_OnChar)
			searchBox:SetScript("OnEditFocusLost", FriendSearch_OnEditFocusLost)
			searchBox:SetScript("OnEditFocusGained", FriendSearch_OnEditFocusGained)
			searchBox:SetWidth(button:GetWidth()-20)
			searchBox:SetHeight(30)
			searchBox:SetPoint("TOPLEFT", button, 10, 0);
		end
		searchBox:Show();
		button.searchBox = searchBox;
		nameText = nil;
	end
	-- travel pass?
	if ( hasTravelPassButton ) then
		button.travelPassButton:Show();
	else
		button.travelPassButton:Hide();
	end
	-- selection
	if ( FriendsFrame.selectedFriendType == FriendListEntries[index].buttonType and FriendsFrame.selectedFriend == FriendListEntries[index].id ) then
		button:LockHighlight();
	else
		button:UnlockHighlight();
	end
	-- finish setting up button if it's not a header
	if ( nameText ) then
		button.name:SetText(nameText);
		if nameColor then
			button.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b);
		end
		button.info:SetText(infoText);
		button:Show();
	else
		button:Hide();
	end
	-- update the tooltip if hovering over a button
	if ( FriendsTooltip.button == button ) then
		FriendsFrameTooltip_Show(button);
	end
	if ( GetMouseFocus() == button ) then
		FriendsFrameTooltip_Show(button);
	end
	if button.searchBox then
		button.searchBox.updating = false;
	end

	return height;
end
function BNGetBTAG(t)
  local bTAG = nil
  for i=1, BNGetNumFriends() do
		local bnetIDAccount, _, battleTag, _, _, _, client, o = BNGetFriendInfo(i);
		if t == bnetIDAccount then
		bTAG = battleTag
		end
  end
  return bTAG
end
local function fixDropDown()
   if UIDROPDOWNMENU_OPEN_MENU.which == "BN_FRIEND" or UIDROPDOWNMENU_OPEN_MENU.which == "BN_FRIEND_OFFLINE" then
		local inOne = false
		local btag = BNGetBTAG(FriendsDropDown.bnetIDAccount)
		for s, i in pairs (Favorites.db.profile.favTypes) do
			if i[btag] then 
				inOne = true
				local info = UIDropDownMenu_CreateInfo()
				info.text = i[btag] and "從"..s.."移除"
				info.value = s
				info.notCheckable = true;
				info.func = function(self) 
					if Favorites.db.profile.favTypes[self.value][btag] then
						Favorites.db.profile.favTypes[self.value][btag] = nil
					else
						Favorites.db.profile.favTypes[self.value][btag] = true
					end
					FriendsList_Update(true)
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end
		if not inOne then
			for s, i in pairs (Favorites.db.profile.favTypes) do
				local info = UIDropDownMenu_CreateInfo()
				info.text = "加入"..s
				info.value = s
				info.notCheckable = true;
				info.func = function(self) 
					if Favorites.db.profile.favTypes[self.value][btag] then
						Favorites.db.profile.favTypes[self.value][btag] = nil
					else
						Favorites.db.profile.favTypes[self.value][btag] = true
					end
					FriendsList_Update(true)
				end
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end
hooksecurefunc("FriendsFrameBNOfflineDropDown_Initialize", fixDropDown)
hooksecurefunc("FriendsFrameBNDropDown_Initialize", fixDropDown)
local function FriendsList_GetScrollFrameTopButtonNEW(offset)
	local usedHeight = 0;
	for i = 1, #FriendListEntries do
		local buttonHeight = FRIENDS_BUTTON_HEIGHTS[FriendListEntries[i].buttonType];
		if ( usedHeight + buttonHeight >= offset ) then
			return i - 1, offset - usedHeight;
		else
			usedHeight = usedHeight + buttonHeight;
		end
	end
end
FriendsList_Update = FriendsList_UpdateFIX
FriendsFrame_UpdateFriendButton = fix
FriendsList_GetScrollFrameTopButton = FriendsList_GetScrollFrameTopButtonNEW
FriendsFrame_UpdateFriends = FriendsFrame_UpdateFriendsNEW
FriendsFrameFriendsScrollFrame.dynamic = FriendsList_GetScrollFrameTopButton
FriendsFrameFriendsScrollFrame.update = FriendsFrame_UpdateFriends


function FriendSearch_OnHide(self)
	if not self.updating then
		self.clearButton:Click();
		FriendSearch_OnTextChanged(self);
	end
end

function FriendSearch_OnTextChanged(self, userChanged)
	if ( not self:HasFocus() and self:GetText() == "" ) then
		self.searchIcon:SetVertexColor(0.6, 0.6, 0.6);
		self.clearButton:Hide();
	else
		self.searchIcon:SetVertexColor(1.0, 1.0, 1.0);
		self.clearButton:Show();
	end
	friendSearchValue = self:GetText()
	FriendsList_Update(true)
	self.Instructions:SetShown(self:GetText() == "")
end

function FriendSearch_OnChar(self, text)
	-- clear focus if the player is repeating keys (ie - trying to move)
	-- TODO: move into base editbox code?
	local MIN_REPEAT_CHARACTERS = 4;
	local searchString = self:GetText();
	if (string.len(searchString) >= MIN_REPEAT_CHARACTERS) then
		local repeatChar = true;
		for i=1, MIN_REPEAT_CHARACTERS - 1, 1 do
			if ( string.sub(searchString,(0-i), (0-i)) ~= string.sub(searchString,(-1-i),(-1-i)) ) then
				repeatChar = false;
				break;
			end
		end
		if ( repeatChar ) then
			self:ClearFocus();
		end
	end
end

function FriendSearch_OnEditFocusLost(self)
	if ( self:GetText() == "" ) then
		self.searchIcon:SetVertexColor(0.6, 0.6, 0.6);
		self.clearButton:Hide();
	end
end
function FriendSearch_OnEditFocusGained(self)
	self.searchIcon:SetVertexColor(1.0, 1.0, 1.0);
	self.clearButton:Show();
end