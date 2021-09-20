local ADDON, e = ...

local BACKDROP = {
bgFile = "Interface/Tooltips/UI-Tooltip-Background",
edgeFile = nil, tile = true, tileSize = 16, edgeSize = 16,
insets = {left = 0, right = 0, top = 0, bottom = 0}
}

local BACKDROP2 = {
bgFile = "Interface/Tooltips/UI-Tooltip-Background",
edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16, edgeSize = 1,
insets = {left = 0, right = 0, top = 0, bottom = 0}
}

local POSITIONS = {
	[1] = 'LEFT',
	[2] = 'CENTER',
	[3] = 'RIGHT',
}

local BACKDROPBUTTON = {
bgFile = nil,
edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 0, edgeSize = 1,
insets = {left = 0, right = 0, top = 0, bottom = 0}
}

local FONT_HEADER = "Interface\\AddOns\\AstralKeys\\Media\\big_noodle_titling.TTF"
local FONT_CONTENT = "Fonts\\bLEI00D.TTF"
local FONT_SIZE = 16

local FONT_OBJECT_LEFT = CreateFont("FONT_OBJECT_LEFT")
FONT_OBJECT_LEFT:SetFont(FONT_CONTENT, FONT_SIZE)
FONT_OBJECT_LEFT:SetJustifyH('LEFT')
FONT_OBJECT_LEFT:SetTextColor(1, 1, 1)

local FONT_OBJECT_RIGHT = CreateFont("FONT_OBJECT_RIGHT")
FONT_OBJECT_RIGHT:SetFont(FONT_CONTENT, FONT_SIZE)
FONT_OBJECT_RIGHT:SetJustifyH('RIGHT')
FONT_OBJECT_RIGHT:SetTextColor(1, 1, 1)

local FONT_OBJECT_CENTRE = CreateFont("FONT_OBJECT_CENTRE")
FONT_OBJECT_CENTRE:SetFont(FONT_CONTENT, FONT_SIZE)
FONT_OBJECT_CENTRE:SetJustifyH('CENTER')
FONT_OBJECT_CENTRE:SetTextColor(1, 1, 1)

local FONT_OBJECT_HIGHLIGHT = CreateFont("FONT_OBJECT_HIGHLIGHT")
FONT_OBJECT_HIGHLIGHT:SetFont(FONT_CONTENT, FONT_SIZE)
FONT_OBJECT_HIGHLIGHT:SetJustifyH('CENTER')
FONT_OBJECT_HIGHLIGHT:SetTextColor(192/255, 192/255, 192/255)

local AstralOptionsFrame = CreateFrame('FRAME', 'AstralOptionsFrame', UIParent)
AstralOptionsFrame:SetFrameStrata('DIALOG')
AstralOptionsFrame:SetFrameLevel(5)
AstralOptionsFrame:SetHeight(450)
AstralOptionsFrame:SetWidth(650)
AstralOptionsFrame:SetPoint('CENTER', UIParent, 'CENTER')
AstralOptionsFrame:SetBackdrop(e.BACKDROP)
AstralOptionsFrame:SetBackdropColor(0, 0, 0, 1)
AstralOptionsFrame:SetMovable(true)
AstralOptionsFrame:EnableMouse(true)
AstralOptionsFrame:RegisterForDrag('LeftButton')
AstralOptionsFrame:EnableKeyboard(true)
AstralOptionsFrame:SetPropagateKeyboardInput(true)
AstralOptionsFrame:SetClampedToScreen(true)
AstralOptionsFrame:Hide()

AstralOptionsFrame:SetScript('OnDragStart', function(self)
	self:StartMoving()
	end)

AstralOptionsFrame:SetScript('OnDragStop', function(self)
	self:StopMovingOrSizing()
	end)

local logo = AstralOptionsFrame:CreateTexture('ARTWORK')
logo:SetSize(64, 64)
logo:SetTexture('Interface\\AddOns\\AstralKeys\\Media\\Astral.tga')
logo:SetPoint('TOPLEFT', AstralOptionsFrame, 'TOPLEFT', 10, -10)

local title = e.CreateHeader(AstralOptionsFrame, 'title', 300, 20, 'Astral Keys Options', 26)
title:SetPoint('LEFT', logo, 'RIGHT', 10, -10)

local closeButton = CreateFrame('BUTTON', nil, AstralOptionsFrame)
closeButton:SetSize(15, 15)
closeButton:SetNormalFontObject(FONT_OBJECT_CENTRE)
closeButton:SetHighlightFontObject(FONT_OBJECT_HIGHLIGHT)
closeButton:SetText('X')
closeButton:SetPoint('TOPRIGHT', AstralOptionsFrame, 'TOPRIGHT', -10, -10)

closeButton:SetScript('OnClick', function()
	AstralOptionsFrame:Hide()
end)

-- Content frame to anchor all option panels
-- 
local contentFrame = CreateFrame('FRAME', 'AstralFrame_OptionContent', AstralOptionsFrame)
contentFrame:SetPoint('TOPLEFT', logo, 'BOTTOMLEFT', 5, -10)
contentFrame:SetSize(630, 350)

contentFrame.header = e.CreateHeader(contentFrame, 'general_header', 200, 20, '一般選項', 10, FONT_CONTENT)
contentFrame.header:SetPoint('TOPLEFT', contentFrame, 'TOPLEFT', 5, 0)

local showOffLine = e.CreateCheckBox(contentFrame, '顯示離線玩家')
showOffLine:SetPoint('TOPLEFT', contentFrame.header, 'BOTTOMLEFT', 0, -5)
showOffLine:SetScript('OnClick', function(self)
	AstralKeysSettings.options.showOffline = self:GetChecked()
	AstralContentFrame:ResetSlider()
	e.UpdateFrames()
	end)

local showMinimap = e.CreateCheckBox(contentFrame, '顯示小地圖按鈕')
showMinimap:SetPoint('LEFT', showOffLine, 'RIGHT', 10, 0)
showMinimap:SetScript('OnClick', function(self)
	AstralKeysSettings.options.showMiniMapButton = self:GetChecked()
	if AstralKeysSettings.options.showMiniMapButton then
		e.icon:Show('AstralKeys')
	else
		e.icon:Hide('AstralKeys')
	end
	if IsAddOnLoaded('ElvUI_Enhanced') then
		ElvUI[1]:GetModule('MinimapButtons'):UpdateLayout()
	end
	end)

local announceKeys = e.CreateCheckBox(contentFrame, '自動通報新的鑰石到隊伍')
announceKeys:SetPoint('LEFT', showMinimap, 'RIGHT', 10, 0)
announceKeys:SetScript('OnClick', function(self)
	e.ToggleAnnounce()
	end)

local showTooltip = e.CreateCheckBox(contentFrame, '在滑鼠提示中顯示目前的鑰石')
showTooltip:SetPoint('TOPLEFT', showOffLine, 'BOTTOMLEFT', 0, -5)
showTooltip:SetScript('OnClick', function(self)
	AstralKeysSettings.options.showTooltip = self:GetChecked()
	end)

contentFrame.syncHeader = e.CreateHeader(contentFrame, 'sync_header', 200, 20, '同步選項', 10, FONT_CONTENT)
contentFrame.syncHeader:SetPoint('TOPLEFT', showTooltip, 'BOTTOMLEFT', 0, -20)

local syncFriends = e.CreateCheckBox(contentFrame, '和好友同步資料')
syncFriends:SetPoint('TOPLEFT', contentFrame.syncHeader, 'BOTTOMLEFT', 0, -5)
syncFriends:SetScript('OnClick', function(self)
	AstralKeysSettings.options.friendSync= self:GetChecked()
	AstralKeyFrame:ToggleLists()
	e.ToggleFriendSync()
	end)

local minFriendSync = e.CreateEditBox(contentFrame, 25, '發送給好友的鑰石最低層數是', 2, 99, 'LEFT')
minFriendSync:SetPoint('LEFT', syncFriends, 'RIGHT', 245, 0)
minFriendSync:HookScript('OnEditFocusLost', function(self)
	AstralKeysSettings.options.minFriendSync = self:GetNumber()
	end)

local otherFaction = e.CreateCheckBox(contentFrame, '顯示其他陣營')
otherFaction:SetPoint('TOPLEFT', syncFriends, 'BOTTOMLEFT', 0, -5)
otherFaction:SetScript('OnClick', function(self)
	AstralKeysSettings.options.showOtherFaction = self:GetChecked()
	e.UpdateFrames()
	end)

local filter_header = e.CreateHeader(contentFrame, 'filter_header', 200, 20, '公會名單過濾', 10, FONT_CONTENT)
filter_header:SetPoint('TOPLEFT', otherFaction, 'BOTTOMLEFT', 0, -20)

local filter_descript = contentFrame:CreateFontString('BACKGROUND')
filter_descript:SetFont(FONT_CONTENT, FONT_SIZE)
filter_descript:SetText('在公會名單中顯示這些會階')
filter_descript:SetJustifyH('LEFT')

filter_descript:SetPoint('TOPLEFT', filter_header, 'BOTTOMLEFT', 3, -2)

local _ranks = {}
for i = 1, 10 do
	_ranks[i] = e.CreateCheckBox(contentFrame, ' ')
	_ranks[i].id = i
end

function InitData()
	otherFaction:SetChecked(AstralKeysSettings.options.showOtherFaction)
	showOffLine:SetChecked(AstralKeysSettings.options.showOffline)
	showMinimap:SetChecked(AstralKeysSettings.options.showMiniMapButton)
	announceKeys:SetChecked(AstralKeysSettings.options.announceKey)
	showTooltip:SetChecked(AstralKeysSettings.options.showTooltip)
	syncFriends:SetChecked(AstralKeysSettings.options.friendSync)
	minFriendSync:SetNumber(AstralKeysSettings.options.minFriendSync)

	for i = 1, GuildControlGetNumRanks() do
	_ranks[i]:SetText(GuildControlGetRankName(i))

	for i = GuildControlGetNumRanks() + 1, 10 do
		_ranks[i]:Hide()
	end

	if i < 4 then
		_ranks[i]:SetPoint('TOPLEFT', filter_descript, 'BOTTOMLEFT', (i-1)%3 * 210, -5)
		elseif i < 7 then
			_ranks[i]:SetPoint('TOPLEFT', filter_descript, 'BOTTOMLEFT', (i-1)%3 * 210, -25)
		elseif i < 10 then
			_ranks[i]:SetPoint('TOPLEFT', filter_descript, 'BOTTOMLEFT', (i-1)%3 * 210, -45)
		else
			_ranks[i]:SetPoint('TOPLEFT', filter_descript, 'BOTTOMLEFT', (i-1)%3 * 210, -65)
		end

		_ranks[i]:SetChecked(AstralKeysSettings.options.rankFilters[i])

		_ranks[i]:SetScript('OnClick', function(self)
			AstralKeysSettings.options.rankFilters[self.id] = self:GetChecked()
			if AstralKeysSettings.frameOptions.list == 'guild' then
				e.UpdateFrames()
			end
			end)
	end
end
AstralEvents:Register('PLAYER_LOGIN', InitData, 'initOptions')

AstralOptionsFrame:SetScript('OnKeyDown', function(self, key)
	if key == 'ESCAPE' then
		self:SetPropagateKeyboardInput(false)
		AstralOptionsFrame:Hide()
	end
	end)

AstralOptionsFrame:SetScript('OnShow', function(self)
	self:SetPropagateKeyboardInput(true)
	end)
