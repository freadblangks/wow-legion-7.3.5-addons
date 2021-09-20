local RC = LibStub("AceAddon-3.0"):GetAddon("Raid Check")
local L = LibStub("AceLocale-3.0"):GetLocale("Raid Check", true)
local RC_UI = LibStub("AceGUI-3.0")

local RC_Main = nil
local RC_Settings = nil
local RC_Tabs = nil
local _activeTab = "RC_Main"

-- release everything when the UI is closed
local function onMainFrameClose(widget)
	RC_UI:Release(widget)
	RC["ReleaseTab" .. _activeTab](RC)

	RC_Main = nil
	RC_Settings = nil
	RC_Tabs = nil
end


-- This will create the Main Tab of the addon, where the players will be listed with their current status
function RC:MainTab(container)
	-- Load the Data first, so we can use it while building the Player Table
	RC:loadData()

	-- Group to hold the three tab buttons, for easy movement and organization
	local buttonGroup = RC_UI:Create("SimpleGroup")
	buttonGroup:SetWidth(RC.GrpWidth);
	buttonGroup:SetPoint("TOPLEFT")
	buttonGroup:SetLayout("Flow")

	-- Announce Button
	local announceBtn = RC_UI:Create("Button")
	announceBtn:SetWidth(RC.ButtonWidth)
	announceBtn:SetHeight(RC.ButtonHeight)
	announceBtn:SetPoint("TOPLEFT", 0, -5)
	announceBtn:SetText(L["announce"])
	announceBtn:SetCallback("OnClick", function()
		RC:Announce();
	end )
	announceBtn:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["announcetxt"]);
		GameTooltip:Show();
	end)
	announceBtn:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	buttonGroup:AddChild(announceBtn)

	-- Whisper Button
	local whisperBtn = RC_UI:Create("Button")
	whisperBtn:SetWidth(RC.ButtonWidth)
	whisperBtn:SetHeight(RC.ButtonHeight)
	whisperBtn:SetPoint("TOPLEFT", (RC.ButtonWidth + 5), -5)
	whisperBtn:SetText(L["whisper"])
	whisperBtn:SetCallback("OnClick", function()
		RC:Whisper(-1);
	end)
	whisperBtn:SetCallback("OnEnter", function(self)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["whispertxt"]);
		GameTooltip:Show();
	end)
	whisperBtn:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	buttonGroup:AddChild(whisperBtn)

	-- Refresh Button
	local refreshBtn = RC_UI:Create("Button")
	refreshBtn:SetWidth(RC.ButtonWidth)
	refreshBtn:SetHeight(RC.ButtonHeight)
	refreshBtn:SetPoint("TOPLEFT", (RC.ButtonWidth + 5) * 2, -5)
	refreshBtn:SetText(L["refresh"])
	refreshBtn:SetCallback("OnClick", function()
		RC:Hide()
		RC:OpenMain()
		collectgarbage("collect");
	end)
	refreshBtn:SetCallback("OnEnter", function(self)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["refreshtxt"]);
		GameTooltip:Show();
	end)
	refreshBtn:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	buttonGroup:AddChild(refreshBtn)

	-- Group to hold the heading labels for the list of players
	local headGroup = RC_UI:Create("SimpleGroup")
	headGroup:SetWidth(RC.GrpWidth);
	headGroup:SetHeight(15)
	headGroup:SetPoint("TOPLEFT", 8, -35) ;
	headGroup:SetLayout("Flow")

	-- Player heading
	local playLbl = RC_UI:Create("Label")
	playLbl:SetText(L["player"])
	playLbl:SetWidth(RC.PlayerWidth)
	playLbl:SetPoint("TOPLEFT", 5, -2)
	headGroup:AddChild(playLbl)

	-- Flask heading
	local flaskLbl = RC_UI:Create("Label")
	flaskLbl:SetText(L["flask"])
	flaskLbl:SetWidth(RC.FlFoRuWidth)
	flaskLbl:SetPoint("TOPLEFT", (5 + RC.PlayerWidth + RC.Spacing), -2)
	headGroup:AddChild(flaskLbl)

	-- Food heading
	local foodLbl = RC_UI:Create("Label")
	foodLbl:SetText(L["food"])
	foodLbl:SetWidth(RC.FlFoRuWidth)
	foodLbl:SetPoint("TOPLEFT", (5 + RC.PlayerWidth + (RC.Spacing * 2) + RC.FlFoRuWidth), -2)
	headGroup:AddChild(foodLbl)

	-- Rune heading
	if(self.db.char.Show.Rune) then
		local runeLbl = RC_UI:Create("Label")
		runeLbl:SetText(L["rune"])
		runeLbl:SetWidth(RC.FlFoRuWidth)
		runeLbl:SetPoint("TOPLEFT", (5 + RC.PlayerWidth + (RC.Spacing * 3) + (RC.FlFoRuWidth * 2)), -2)
		headGroup:AddChild(runeLbl)
	end

	-- Vantus Rune heading
	if RC.VantusRuneCheckEnabled then
		local vantusRuneLbl = RC_UI:Create("Label")
		vantusRuneLbl:SetText(L["vantusrune"])
		vantusRuneLbl:SetWidth(RC.FlFoRuWidth)
		vantusRuneLbl:SetPoint("TOPLEFT", (5 + RC.PlayerWidth + (RC.Spacing * 3) + (RC.FlFoRuWidth * 2)), -2)
		headGroup:AddChild(vantusRuneLbl)
	end

	-- Scrolling container to hold the list of players and the status of their Flask/Food/Rune
	local scrollcontainer = RC_UI:Create("SimpleGroup") -- "InlineGroup" is also good
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill")

	scroll = RC_UI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)

	local numPlayers = GetNumGroupMembers()
	if numPlayers == 0 then
		numPlayers = 1
	end
	playerBar = {}
	nameTbl = {}
	flaskTbl = {}
	foodTbl = {}
	runeTbl = {}
	vantusruneTbl = {}

	for i=1,numPlayers do
		local posY = -2-(15*(i-1))

		RC:PlayerRow(posY, i)
	end

	-- This adds each Group of controls to the container, or tab, we add them all in one place for ease of manipulation
	container:AddChild(buttonGroup)
	container:AddChild(headGroup)
	container:AddChild(scrollcontainer)
end

function RC:PlayerRow(positionY, row)
	local flStatus, flColor, foStatus, foColor, ruStatus, ruColor
	local allowCtrlWhisper = self.db.char.Whisper.OnControl
	_, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(row);

	if ((subgroup == 7 or subgroup == 8) and self.db.char.IgnoreGroup7_8) then
		return
	end

	if(row%2 == 0) then
		playerBar[row] = RC_UI:Create("RCSimpleGroup_LG")
	else
		playerBar[row] = RC_UI:Create("RCSimpleGroup_DG")
	end
	playerBar[row]:SetHeight(15)
	playerBar[row]:SetPoint("TOPLEFT", 0, positionY)
	playerBar[row]:SetLayout("Flow")

	nameTbl[row] = RC_UI:Create("InteractiveLabel")
	nameTbl[row]:SetText(RC:PlayerName(row))
	nameTbl[row]:SetColor(unpack(RC:SetClassColor(row)))
	nameTbl[row]:SetPoint("TOPLEFT", 2, -2)
	nameTbl[row]:SetWidth(RC.PlayerWidth)
	nameTbl[row]:SetCallback("OnClick", function(self, button)
		if(IsControlKeyDown() and allowCtrlWhisper) then
			RC:Whisper(row);
		end
	end)
	playerBar[row]:AddChild(nameTbl[row])

	flStatus, flColor = RC:SetFlFoRu(row, 3)
	flaskTbl[row] = RC_UI:Create("InteractiveLabel")
	flaskTbl[row]:SetText(flStatus)
	flaskTbl[row]:SetColor(unpack(flColor))
	flaskTbl[row]:SetPoint("TOPLEFT", 140, -2)
	flaskTbl[row]:SetWidth(RC.FlFoRuWidth)
	flaskTbl[row]:SetCallback("OnClick", function(self, button)
		if(IsControlKeyDown() and allowCtrlWhisper) then
			RC:Whisper(row);
		end
	end)
	playerBar[row]:AddChild(flaskTbl[row])

	foStatus, foColor = RC:SetFlFoRu(row, 4)
	foodTbl[row] = RC_UI:Create("InteractiveLabel")
	foodTbl[row]:SetText(foStatus)
	foodTbl[row]:SetColor(unpack(foColor))
	foodTbl[row]:SetPoint("TOPLEFT", 200, -2)
	foodTbl[row]:SetWidth(RC.FlFoRuWidth)
	foodTbl[row]:SetCallback("OnClick", function(self, button)
		if(IsControlKeyDown() and allowCtrlWhisper) then
			RC:Whisper(row);
		end
	end)
	playerBar[row]:AddChild(foodTbl[row])

	if(self.db.char.Show.Rune) then
		ruStatus, ruColor = RC:SetFlFoRu(row, 5)
		runeTbl[row] = RC_UI:Create("InteractiveLabel")
		runeTbl[row]:SetText(ruStatus)
		runeTbl[row]:SetColor(unpack(ruColor))
		runeTbl[row]:SetPoint("TOPLEFT", 260, -2)
		runeTbl[row]:SetWidth(RC.FlFoRuWidth)
		runeTbl[row]:SetCallback("OnClick", function(self, button)
		if(IsControlKeyDown() and allowCtrlWhisper) then
			RC:Whisper(row);
		end
	end)
		playerBar[row]:AddChild(runeTbl[row])
	end

	if RC.VantusRuneCheckEnabled then
		vaStatus, vaColor = RC:SetFlFoRu(row, 8)
		vantusruneTbl[row] = RC_UI:Create("InteractiveLabel")
		vantusruneTbl[row]:SetText(vaStatus)
		vantusruneTbl[row]:SetColor(unpack(vaColor))
		vantusruneTbl[row]:SetPoint("TOPLEFT", 260, -2)
		vantusruneTbl[row]:SetWidth(RC.FlFoRuWidth)
		vantusruneTbl[row]:SetCallback("OnClick", function(self, button)
		if(IsControlKeyDown() and allowCtrlWhisper) then
			RC:Whisper(row);
		end
	end)
		playerBar[row]:AddChild(vantusruneTbl[row])
	end

	scroll:AddChild(playerBar[row])
end

function RC:updateGUI()
	local numPlayers = GetNumGroupMembers()
	if numPlayers == 0 then
		numPlayers = 1
	end

	-- If RC is open and a player leaves, when using refresh we need to ensure we are removing the extra row
	local numRows = table.getn(playerBar)
	if numPlayers < numRows then
		local extraRow = numRows - numPlayers
		for j = 1, extraRow do
			table.remove(playerBar)  -- without passing a position to the remove function it just removes the last element in the array
		end
	end

	for i = 1, numPlayers do
		_, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i);
		if not ((subgroup == 7 or subgroup == 8) and self.db.char.IgnoreGroup7_8) then
			if not playerBar[i] then
				local posY = -2-(15*(i-1))
				RC:PlayerRow(posY, i)
			end

			if(RC.playerData[i]) then
				RC:SetPlayerText(i);
			end
		end
	end
end

function RC:SetPlayerText(barNr)
	local flStatus, flColor, foStatus, foColor, ruStatus, ruColor
	flStatus, flColor = RC:SetFlFoRu(barNr, 3)
	foStatus, foColor = RC:SetFlFoRu(barNr, 4)
	ruStatus, ruColor = RC:SetFlFoRu(barNr, 5)

	nameTbl[barNr]:SetText(RC:PlayerName(barNr));
	nameTbl[barNr]:SetColor(unpack(RC:SetClassColor(barNr)))

	--Update Flask
	flaskTbl[barNr]:SetText(flStatus)
	flaskTbl[barNr]:SetColor(unpack(flColor))

	--Update Food
	foodTbl[barNr]:SetText(foStatus)
	foodTbl[barNr]:SetColor(unpack(foColor))

	--Update Rune
	if(self.db.char.Show.Rune) then
		runeTbl[barNr]:SetText(ruStatus)
		runeTbl[barNr]:SetColor(unpack(ruColor))
	end
end

function RC:SettingsTab(container)
	-- Flask Group
	local flaskGroup = RC_UI:Create("InlineGroup")
	flaskGroup:SetTitle(L["flask"])
	flaskGroup:SetWidth(RC.GrpWidth)

	local flaskDD = RC_UI:Create("Dropdown")
	flaskDD:SetList(RC.FlaskLevels)
	flaskDD:SetValue(self.db.char.Threshold.Flask)
	flaskDD:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Threshold.Flask = value;
	end)
	flaskDD:SetWidth(RC.DDWidth)
	flaskGroup:AddChild(flaskDD)

	local announceFlask = RC_UI:Create("CheckBox")
	announceFlask:SetLabel(L["annFlask"])
	announceFlask:SetType("checkbox")
	announceFlask:SetValue(self.db.char.Announce.Flask)
	announceFlask:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Announce.Flask = value;
	end)
	flaskGroup:AddChild(announceFlask)

	local felFocuser = RC_UI:Create("CheckBox")
	felFocuser:SetLabel(L["allowFelFocuser"])
	felFocuser:SetType("checkbox")
	felFocuser:SetValue(self.db.char.Allow.FelFocuser)
	felFocuser:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Allow.FelFocuser = value;
	end)
	flaskGroup:AddChild(felFocuser)

	-- Food Group
	local foodGroup = RC_UI:Create("InlineGroup")
	foodGroup:SetTitle(L["food"])
	foodGroup:SetWidth(RC.GrpWidth)

	local foodDD = RC_UI:Create("Dropdown")
	foodDD:SetList(RC.FoodLevels)
	foodDD:SetValue(self.db.char.Threshold.Food)
	foodDD:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Threshold.Food = value;
	end)
	foodDD:SetWidth(RC.DDWidth)
	foodGroup:AddChild(foodDD)

	local announceFood = RC_UI:Create("CheckBox")
	announceFood:SetLabel(L["annFood"])
	announceFood:SetType("checkbox")
	announceFood:SetValue(self.db.char.Announce.Food)
	announceFood:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Announce.Food = value;
	end)
	foodGroup:AddChild(announceFood)

	-- Rune Group
	local runeGroup = RC_UI:Create("InlineGroup")
	runeGroup:SetTitle(L["rune"])
	runeGroup:SetWidth(RC.GrpWidth)

	local runeDD = RC_UI:Create("Dropdown")
	runeDD:SetList(RC.RuneLevels)
	runeDD:SetValue(self.db.char.Threshold.Rune)
	runeDD:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Threshold.Rune = value;
	end)
	runeDD:SetWidth(RC.DDWidth)
	runeGroup:AddChild(runeDD)

	local runeCb = RC_UI:Create("CheckBox")
	runeCb:SetLabel(L["enRune"])
	runeCb:SetType("checkbox")
	runeCb:SetValue(self.db.char.Show.Rune)
	runeCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Show.Rune = value;
	end)
	runeGroup:AddChild(runeCb)

	local announceRune = RC_UI:Create("CheckBox")
	announceRune:SetLabel(L["annRunes"])
	announceRune:SetType("checkbox")
	announceRune:SetValue(self.db.char.Announce.Rune)
	announceRune:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Announce.Rune = value;
	end)
	announceRune:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["annRunes"]);
		GameTooltip:Show();
	end)
	announceRune:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	runeGroup:AddChild(announceRune)

	-- Vantus Rune
	local vantusGroup = RC_UI:Create("InlineGroup")
	vantusGroup:SetTitle(L["vantusrune"])
	vantusGroup:SetWidth(RC.GrpWidth)

	local vantusDD = RC_UI:Create("Dropdown")
	vantusDD:SetList(RC.VantusBossNames)
	vantusDD:SetValue(self.db.char.Threshold.VantusRune)
	vantusDD:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Threshold.VantusRune = value;
	end)
	vantusDD:SetWidth(RC.DDWidth*2)
	vantusGroup:AddChild(vantusDD)

	local whispVantus = RC_UI:Create("CheckBox")
	whispVantus:SetLabel(L["whispVantus"])
	whispVantus:SetType("checkbox")
	whispVantus:SetValue(self.db.char.Whisper.VantusRune)
	whispVantus:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Whisper.VantusRune = value;
	end)
	whispVantus:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["whispVantus"]);
		GameTooltip:Show();
	end)
	whispVantus:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	vantusGroup:AddChild(whispVantus)

	-- Behavior
	local behavGroup = RC_UI:Create("InlineGroup")
	behavGroup:SetTitle(L["Beha"])
	behavGroup:SetWidth(RC.GrpWidth)

	local rdyCheckCb = RC_UI:Create("CheckBox")
	rdyCheckCb:SetLabel(L["rdyCheck"])
	rdyCheckCb:SetType("checkbox")
	rdyCheckCb:SetValue(self.db.char.Show.RaidCheckonReady)
	rdyCheckCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Show.RaidCheckonReady = value;
	end)
	behavGroup:AddChild(rdyCheckCb)

	local annRdyCheckCb = RC_UI:Create("CheckBox")
	annRdyCheckCb:SetLabel(L["rdyAnn"])
	annRdyCheckCb:SetType("checkbox")
	annRdyCheckCb:SetValue(self.db.char.Announce.ReadyCheck)
	annRdyCheckCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Announce.ReadyCheck = value;
	end)
	behavGroup:AddChild(annRdyCheckCb)

	local whispRdyCheckCb = RC_UI:Create("CheckBox")
	whispRdyCheckCb:SetLabel(L["rdyWhi"])
	whispRdyCheckCb:SetType("checkbox")
	whispRdyCheckCb:SetValue(self.db.char.Whisper.OnReadyCheck)
	whispRdyCheckCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Whisper.OnReadyCheck = value;
	end)
	behavGroup:AddChild(whispRdyCheckCb)

	local combatHideCb = RC_UI:Create("CheckBox")
	combatHideCb:SetLabel(L["hideCombat"])
	combatHideCb:SetType("checkbox")
	combatHideCb:SetValue(self.db.char.Show.StartCombatHide)
	combatHideCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Show.StartCombatHide = value;
	end)
	behavGroup:AddChild(combatHideCb)

	local ldrAsstOnlyCb = RC_UI:Create("CheckBox")
	ldrAsstOnlyCb:SetLabel(L["LeaderAssistOnly"])
	ldrAsstOnlyCb:SetType("checkbox")
	ldrAsstOnlyCb:SetValue(self.db.char.Announce.LeaderAssistOnly)
	ldrAsstOnlyCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Announce.LeaderAssistOnly = value
	end)
	ldrAsstOnlyCb:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["LeaderAssistOnly"]);
		GameTooltip:Show();
	end)
	ldrAsstOnlyCb:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	behavGroup:AddChild(ldrAsstOnlyCb)

	local annBossStartCb = RC_UI:Create("CheckBox")
	annBossStartCb:SetLabel(L["annBossStart"])
	annBossStartCb:SetType("checkbox")
	annBossStartCb:SetValue(self.db.char.Announce.BossStart)
	annBossStartCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Announce.BossStart = value
	end)
	annBossStartCb:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["annBossStart"]);
		GameTooltip:Show();
	end)
	annBossStartCb:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	behavGroup:AddChild(annBossStartCb)

	local showRealms = RC_UI:Create("CheckBox")
	showRealms:SetLabel(L["showRealms"])
	showRealms:SetType("checkbox")
	showRealms:SetValue(self.db.char.Show.Realm)
	showRealms:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Show.Realm = value;
	end)
	behavGroup:AddChild(showRealms)

	local ign78Cb = RC_UI:Create("CheckBox")
	ign78Cb:SetLabel(L["ign78"])
	ign78Cb:SetType("checkbox")
	ign78Cb:SetValue(self.db.char.IgnoreGroup7_8)
	ign78Cb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.IgnoreGroup7_8 = value;
	end)
	behavGroup:AddChild(ign78Cb)

	-- UI Group
	local uiGroup = RC_UI:Create("InlineGroup")
	uiGroup:SetTitle(L["UI"])
	uiGroup:SetWidth(RC.GrpWidth)

	local miniMapCb = RC_UI:Create("CheckBox")
	miniMapCb:SetLabel(L["showMinimap"])
	miniMapCb:SetType("checkbox")
	miniMapCb:SetValue(not self.db.char.Show.Minimap.hide)
	miniMapCb:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Show.Minimap.hide = not value;
		RaidCheck:UpdateMinimap();
	end)
	uiGroup:AddChild(miniMapCb)

	local classColors = RC_UI:Create("CheckBox")
	classColors:SetLabel(L["colorClass"])
	classColors:SetType("checkbox")
	classColors:SetValue(self.db.char.classColors)
	classColors:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.classColors = value;
	end)
	uiGroup:AddChild(classColors)

	local ctrlWhisp = RC_UI:Create("CheckBox")
	ctrlWhisp:SetLabel(L["ctrlWhi"])
	ctrlWhisp:SetType("checkbox")
	ctrlWhisp:SetValue(self.db.char.Whisper.OnControl)
	ctrlWhisp:SetCallback("OnValueChanged", function(_, _, value)
		self.db.char.Whisper.OnControl = value;
	end)
	ctrlWhisp:SetCallback("OnEnter", function()
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR");
		GameTooltip:SetText(L["ctrlWhi"]);
		GameTooltip:Show();
	end)
	ctrlWhisp:SetCallback("OnLeave", function(self)
		GameTooltip:Hide()
	end)
	uiGroup:AddChild(ctrlWhisp)

	local mainWindowHeight = RC_UI:Create("Slider")
	mainWindowHeight:SetLabel(L["windowSizeSlider"])
	mainWindowHeight:SetSliderValues(RC.MinHeight, RC.MaxHeight, RC.SliderStep) -- Minimum, Maximum, Step value
	mainWindowHeight:SetValue(self.db.char.Frame.height)
	mainWindowHeight:SetCallback("OnMouseUp", function(_, _, value)
		self.db.char.Frame.height = value;
		RC_Frame:ApplyStatus()
	end)
	uiGroup:AddChild(mainWindowHeight)

	local resetSettingsDefault = RC_UI:Create("Button")
	resetSettingsDefault:SetText(L["resetDefault"])
	resetSettingsDefault:SetCallback("OnClick", function ()
		RC:UIresettoDefault()
	end)
	uiGroup:AddChild(resetSettingsDefault)

	local scrollcontainer = RC_UI:Create("SimpleGroup") -- "InlineGroup" is also good
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetLayout("Fill")

	local scroll = RC_UI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scroll:AddChild(flaskGroup)
	scroll:AddChild(foodGroup)
	scroll:AddChild(runeGroup)
	scroll:AddChild(vantusGroup)
	scroll:AddChild(behavGroup)
	scroll:AddChild(uiGroup)
	scrollcontainer:AddChild(scroll)

	container:AddChild(scrollcontainer)
end

-- Callback function for OnGroupSelected
local function SelectGroup(container, event, group)
   container:ReleaseChildren()
   if group == "RC_Main" then
      RC:MainTab(container)
   elseif group == "RC_Settings" then
      RC:SettingsTab(container)
   end
end

function RC:MainFrame(opentotab)
	if opentotab then
		_activeTab = opentotab
	end

	-- Create the frame container
	RC_Frame = RC_UI:Create("Window")
	RC_Frame:SetTitle(L["Raid Check"]..L["  [Version: "]..GetAddOnMetadata("RaidCheck", "Version").."]")
	RC_Frame:SetStatusTable(self.db.char.Frame)
	RC_Frame:ApplyStatus()
	RC_Frame:EnableResize(false)

	-- Fill Layout - the TabGroup widget will fill the whole frame
	RC_Frame:SetLayout("Fill")

	RC_Tabs = RC_UI:Create("TabGroup")
	RC_Tabs:SetLayout("Flow")
	-- Setup which tabs to show
	RC_Tabs:SetTabs({{text=L["main"], value="RC_Main"}, {text=L["settings"], value="RC_Settings"}})
	-- Register callback
	RC_Tabs:SetCallback("OnGroupSelected", SelectGroup)
	-- Set initial Tab (this will fire the OnGroupSelected callback)
	RC_Tabs:SetFullWidth(true)
	RC_Tabs:SelectTab(_activeTab)

	RC_Frame:AddChild(RC_Tabs)
end

-- toggle visibility of the UI
function RC:Toggle(tab)
	if not self:IsEnabled() then return end

	if not tab then
		tab = _activeTab
	end

	if not RC_Frame then
		self:Show(tab)
	elseif RC_Frame:IsShown() then
		self:Hide()
	else
		self:Show(tab)
	end
end

-- hide the UI if it is currently showing
function RC:Hide()
	if ((not self:IsEnabled()) or (not RC_Frame)) then return end

	RC_Frame:Hide()
end

-- show the UI if it is not currently showing
function RC:Show(tab)
	if not self:IsEnabled() then
		return
	elseif RC_Frame then
		if RC_Frame:IsShown() then
			return
		end
	end

	if not tab then
		RC:MainFrame("RC_Main")
	elseif tab == "RC_Main" or tab == "RC_Settings" then
		RC:MainFrame(tab)
	end
end

function RC:OpenMain()
	RC:Toggle("RC_Main")
end

function RC:OpenSettings()
	RC:Toggle("RC_Settings")
end
