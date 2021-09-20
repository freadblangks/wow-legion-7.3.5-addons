local _,L = ...
local rematch = Rematch
local panel = RematchTeamTabs
local dialog, iconPicker, settings, saved

--[[ Team tabs are defined in settings.TeamGroups as an ordered table (tab#=table index)

	Within each index of TeamGroups is a table of the following:

	[1] = Name of the tab
	[2] = Icon of the tab
	[3] = An ordered table of keys if the tab is custom sorted, nil if not custom sorted
	[4] = A table of leveling preferences if the tab has any, nil otherwise
	[5] = True if the tab is to be sorted by win record

]]

local MAX_TABS = 16

-- this table describes the {yoffset,scale} to nudge the tabs to make room for more.
-- the index is the number of tabs to display (not including the + New Tabs button)
-- a nil yoffset means to center it to the side of the parent
local tabNudges = {[11]={-64,1},[12]={-28,1},[13]={nil,0.95},[14]={nil,0.9},[15]={nil,0.85},[16]={nil,0.85}}

rematch:InitModule(function()
	rematch.TeamTabs = panel
	settings = RematchSettings
	saved = RematchSaved
	dialog = RematchDialog
	iconPicker = dialog.TeamTabIconPicker
	panel.Tabs = {} -- where the tab buttons will go

	local function isFirstTab(self,index) return index==1 end

	rematch:RegisterMenu("TabMenu", { -- menu for Tab buttons
		{ title=true, text=function(self,index) return settings.TeamGroups[index][1] end, },
		{ text=L["Edit Tab"], func=panel.ShowTabEditDialog, tooltipBody=L["Change the name or icon of this tab."] },
		{ text=L["Custom Sort"], check=true,
				value=function(entry,index)
					return settings.TeamGroups[index] and settings.TeamGroups[index][3] and true
				end,
				func=function(entry,index)
					local tab = settings.TeamGroups[index]
					if not tab then return end
					if tab[3] then
						local dialog = rematch:ShowDialog("DeleteCustomSort",300,172,L["Remove Custom Sort"],nil,YES,function() tab[3]=nil rematch:UpdateUI() end,NO)
						dialog:ShowText(L["Are you sure you want to remove the custom sort order?\n\nThe saved order of teams will be lost and turning this option back on will not restore the old order."],240,96,"TOP",0,-32)
					else
						tab[3] = {}
					end
					rematch:HideMenu()
					rematch:UpdateUI()
				end,
				tooltipBody=L["While checked, you can rearrange the order of teams within this tab from the teams' right-click menu."] },
		{ text=L["Sort By Wins"], check=true,
				disabled=function(entry,index) return settings.TeamGroups[index][3] and true end,
				disabledReason=L["This option is disabled while Custom Sort is active."],
				value=function(entry,index) return settings.TeamGroups[index][5] end,
				func=function(entry,index)
					local tab = settings.TeamGroups[index]
					tab[5] = not tab[5]
					rematch:UpdateUI()
				end,
				tooltipBody=L["Sort teams in this tab by their wins.\n\nFavorited teams will still list at the top."]
				},
		{ text=L["Leveling Preferences"], func=function(entry,index) rematch:ShowPreferencesDialog("tab",index) end, tooltipBody=L["Set leveling preferences for all teams within this tab.\n\nIf a team within this tab also has preferences, the tab's preferences will take priority over the team's preferences."] },
		{ text=L["Export Tab"], func=function() Rematch.Dialog.Share:ExportTeamTab() end, tooltipBody=L["Export all teams in this tab to a string you can copy elsewhere, such as forums or emails.\n\nOther Rematch users can then paste these teams into their Rematch via Import Teams.\n\nYou can export a single team by right-clicking one and choosing its Share menu."] },
		{ text=L["Import Teams"], func=rematch.ShowImportDialog, tooltipBody=L["Import a single team or many teams that was exported from Rematch."] },
		{ text=L["Delete Tab"], hidden=isFirstTab, func=panel.ShowTabDeleteDialog, tooltipBody=L["Delete this tab and either move all of its teams to the default tab or delete the teams too."] },
      { text=L["Delete Teams"], hidden=function(self,index) return index~=1 end, func=panel.ShowDeleteFirstTabDialog, tooltipBody=L["Permanently delete all teams in this tab."] },
		{ text=L["Move Up"], hidden=isFirstTab, icon="Interface\\Buttons\\UI-MicroStream-Yellow", iconCoords={0.075,0.925,0.925,0.075}, stay=true,
			disabled=function(entry,index) return index==2 end,
			func=function(entry,index) panel:SwapTabs(index,index-1) end },
		{ text=L["Move Down"], hidden=isFirstTab, icon="Interface\\Buttons\\UI-MicroStream-Yellow", stay=true,
			disabled=function(entry,index) return index==#settings.TeamGroups end,
			func=function(entry,index) panel:SwapTabs(index,index+1) end },
		{ text=OKAY },
	})

end)

-- returns the selected team tab (and assigns it to first tab if anything weird happened)
function panel:GetSelectedTab()
	local selected = settings.SelectedTab
	if not selected or not settings.TeamGroups[selected] then
		settings.SelectedTab = 1
		return 1
	else
		return selected
	end
end

function panel:Update()
	panel:GetSelectedTab() -- changes settings.SelectedTab to 1 if selected tab doesn't eixt
	for index=1,MAX_TABS do
		panel:TabButtonUpdate(index)
	end
	panel:SetHeight(min(MAX_TABS,#settings.TeamGroups+1)*44)

	-- anchor/rescale the parent TeamTabs frame depending on number of tabs to show
	local numTabs = #settings.TeamGroups
	local yoffset, scale = -92, 1 -- default to -92 from top of parent, 1.0 scale
	local parent = panel:GetParent()
	if tabNudges[numTabs] then
		yoffset, scale = tabNudges[numTabs][1], tabNudges[numTabs][2]
	end
	panel:ClearAllPoints()
	if yoffset then
		if settings.TeamTabsToLeft and settings.AlwaysTeamTabs and parent==rematch.Frame then
			panel:SetPoint("TOPRIGHT",parent,"TOPLEFT",-5,yoffset) -- tabs anchored to topleft
		else
			panel:SetPoint("TOPLEFT",parent,"TOPRIGHT",-1,yoffset) -- tabs anchored to topright
		end
	else
		if settings.TeamTabsToLeft and settings.AlwaysTeamTabs and parent==rematch.Frame then
			panel:SetPoint("RIGHT",parent,"LEFT",-5,0) -- tabs anchored to left center
		else
			panel:SetPoint("LEFT",parent,"RIGHT",-1,0) -- tabs anchored to right center
		end
	end
	panel:SetScale(scale)
end

function panel:SelectTeamTab(index)
	rematch.TeamPanel:SetTeamSearch(nil)
	settings.SelectedTab = index or 1
	panel:Update()
	if not rematch.TeamPanel:IsVisible() and not rematch:IsDialogOpen("SaveAs") and not rematch:IsDialogOpen("ImportDialog") and not rematch:IsDialogOpen("ReceiveDialog") then
		rematch:ShowTeam() -- if teams not shown then switch to panel
	else
		rematch.TeamPanel:Update()
	end
	rematch:ListScrollToTop(rematch.TeamPanel.List.ScrollFrame)
	rematch.Dialog:UpdateTabPicker()
end

function panel:TabOnClick(button)
	rematch:HideMenu()
	local index = self:GetID()
	local groups = settings.TeamGroups
	if button=="RightButton" then
		if index<=#groups then
			rematch:SetMenuSubject(index)
			panel:SelectTeamTab(index)
			rematch:ShowMenu("TabMenu","cursor")
		end
		return
	end
	if index>0 and index<=#groups then
		panel:SelectTeamTab(index)
	else
		if index>#groups then
			panel:ShowTabEditDialog(index)
		end
	end
end

function panel:TabButtonOnEnter()
	local index = self:GetID()
	if index>#settings.TeamGroups then
		rematch.ShowTooltip(self,L["Create New Tab"])
	else
		local numTeams = 0
		for k,v in pairs(saved) do
			if (v.tab or 1)==index then
				numTeams = numTeams + 1
			end
		end
		local info = rematch.info
		wipe(info)
		tinsert(info,settings.TeamGroups[index][1])
		tinsert(info,format(L["Teams: %d"],numTeams))
		if settings.TeamGroups[index][4] then
			tinsert(info,"")
			rematch.ShowPreferencesTooltip(self,"tab",index,nil,info)
		else
			rematch:ShowTableTooltip(self,info)
		end
	end
end


function panel:ShowTabEditDialog(index)
	local groups = settings.TeamGroups
	local name, icon
	if index>#groups then
		name = L["New Tab"]
		icon = "Interface\\Icons\\PetJournalPortrait"
	else
		name = groups[index][1]
		icon = groups[index][2]
	end
	rematch:ShowDialog("TabEdit",390,456,name or L["New Tab"],L["Choose a name and icon"],SAVE,panel.IconPickerSave,CANCEL)
	dialog:SetContext("tab",index)
	dialog:SetContext("name",name)
	dialog:SetContext("icon",icon)

	dialog.EditBox:SetPoint("TOP",22,-40)
	dialog.EditBox:SetWidth(180)
	dialog.EditBox:Show()
	dialog.EditBox:SetText(name)

	dialog.Slot:SetPoint("RIGHT",dialog.EditBox,"LEFT",-8,0)
	dialog.Slot:Show()
	dialog.Slot.Icon:SetTexture(icon)

	iconPicker:SetPoint("TOP",0,-80)
	if not iconPicker.ScrollFrame.buttons then
		-- scrollframe hasn't been set up yet
		local scrollFrame = iconPicker.ScrollFrame
		scrollFrame.update = panel.UpdateTabIconPickerList
		scrollFrame.ScrollBar.doNotHide = true
		scrollFrame.stepSize = 270
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchTeamTabPickerListTemplate")
	end
	-- set up icon choices (recreating table each time on purpose; don't want to keep these huge tables)
	local iconChoices = dialog:SetContext("iconChoices",{})
	tinsert(iconChoices,"Interface\\Icons\\PetJournalPortrait")
	panel:AddMoreIcons(iconChoices) -- add icons from bags, inventory, etc
--	GetLooseMacroIcons(iconChoices)
	GetMacroIcons(iconChoices)
	GetMacroItemIcons(iconChoices)
	panel:UpdateTabIconPickerList()
	iconPicker:Show()
end

-- when save clicked on IconPicker
function panel:IconPickerSave()
	local groups = settings.TeamGroups
	local index = dialog:GetContext("tab")
	groups[index] = groups[index] or {}
	groups[index][1] = dialog.EditBox:GetText() or ""
	groups[index][2] = dialog:GetContext("icon")
	panel:SelectTeamTab(index)
end

-- update of icon list in iconpicker
function panel:UpdateTabIconPickerList()
	-- data points to searchChoices if a search is used, or iconChoices (all icons) otherwise
	local data = dialog:GetContext("iconChoices")
	if not data then return end
	local numData = ceil(#data/10)
	local scrollFrame = iconPicker.ScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local selectedIcon = dialog:GetContext("icon")
	for i=1,#buttons do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData) then
			for j=1,10 do
				local subbutton = button.Icons[j]
				local iconID = data[(index-1)*10+j]
				subbutton.iconID = iconID
				if iconID then
					subbutton.Texture:SetTexture(iconID)
					subbutton.Selected:SetShown(iconID==selectedIcon)
					subbutton:Show()
				else
					subbutton:Hide()
				end
			end
			button:Show()
		else
			button:Hide()
		end
	end
	HybridScrollFrame_Update(scrollFrame,30*numData,30)
end

function panel:IconOnClick()
	local iconID = self.iconID
	if iconID then
		dialog:SetContext("icon",iconID)
		dialog.Slot.Icon:SetTexture(iconID)
		panel:UpdateTabIconPickerList()
	end
end

--[[ Delete ]]

-- (for now) the first team tab can't be deleted, so it has its own dialog to delete teams within the team
function panel:ShowDeleteFirstTabDialog()
   rematch:ShowDialog("TabDeleteFirst",300,150,L["Delete Teams?"],L["Delete ALL teams in the first tab?"],YES,
      function()
         for key,team in pairs(saved) do
            if not team.tab or team.tab==1 then
               saved[key] = nil
            end
         end
         rematch:UpdateUI()
      end,NO)
   dialog:ShowText(format(L["%sWARNING!\124r This will %sPERMANENTLY DELETE\124r all teams in this tab!"],rematch.hexRed,rematch.hexWhite),180,40,"TOP",0,-40)
end

-- non-default tabs get a "Delete Tab" option instead with an option to delete teams too
function panel:ShowTabDeleteDialog(index)
	local groups = settings.TeamGroups
	rematch:ShowDialog("TabDelete",300,192,groups[index][1],L["Delete this tab?"],YES,panel.ConfirmDeleteTab,NO)
	dialog:SetContext("tab",index)
	dialog:ShowText(format(L["Deleting this tab will move its teams to the %s tab."],groups[1][1]),180,40,"TOP",22,-40)
	dialog.Slot:SetPoint("RIGHT",dialog.Text,"LEFT",-8,0)
	dialog.Slot:Show()
	dialog.Slot.Icon:SetTexture(groups[index][2])
	dialog.CheckButton:SetPoint("BOTTOMLEFT",32,70)
	dialog.CheckButton.text:SetText(L["Delete teams within the tab too"])
	dialog.CheckButton:SetChecked(false)
	dialog.CheckButton:Show()
	dialog.CheckButton:SetScript("OnClick",panel.DeleteTeamsOnClick)
end

function panel:DeleteTeamsOnClick()
	local deleteTeams = self:GetChecked() and true
	local groups = settings.TeamGroups	
	dialog:SetContext("TabDeleteTeamsToo",deleteTeams)
	dialog.Text:SetText(deleteTeams and format(L["%sWARNING!\124r This will %sPERMANENTLY DELETE\124r all teams in this tab!"],rematch.hexRed,rematch.hexWhite) or format(L["Deleting this tab will move its teams to the %s tab."],groups[1][1]))
end

function panel:ConfirmDeleteTab()
	local index = dialog:GetContext("tab")
	if index and index>1 then
		-- if checkbutton "Delete teams within this tab too" is checked, remove teams
		if dialog:GetContext("TabDeleteTeamsToo") then
			for key,team in pairs(saved) do
				if team.tab==index then
					saved[key] = nil
				end
			end
		end
		-- move any teams that belong to this tab to the general tab
		-- (and move any beyond this tab to the prior tab)
		for _,team in pairs(saved) do
			if team.tab==index then
				team.tab = nil -- remove .tab from teams belonging to this tab (move them to general)
			elseif team.tab and team.tab>index then
				team.tab = team.tab-1 -- move teams in tabs beyond deleted one to one previous
			end
		end
		tremove(settings.TeamGroups,index) -- and delete the tab
		panel:SelectTeamTab(1) -- go to first tab (this will update tabs and team panel)
	end
end

-- swaps two tabs (index 2 to #groups) for moving tabs up/down
function panel:SwapTabs(index1,index2)
	local groups = settings.TeamGroups
	if index1==1 or index2==1 or index1>#groups or index2>#groups then
		return -- don't swap first tab! (or beyond last tab)
	end
	for teamName,teamData in pairs(saved) do
		local teamTab = teamData.tab
		if teamTab==index1 then
			teamData.tab = index2
		elseif teamTab==index2 then
			teamData.tab = index1
		end
	end

	-- swap the contents of groups[index1] and groups[index2]
	for i=1,5 do
		local old = groups[index1][i]
		groups[index1][i] = groups[index2][i]
		groups[index2][i] = old
	end

	rematch:SetMenuSubject(index2) -- change menu subject to destination tab
	panel:SelectTeamTab(index2)
end

function panel:Configure(parent)
	panel:SetParent(parent)
	-- there used to be a lot more here (to reanchor tabs) that's now handled in the Update
	panel:Show()
end

-- adds more icons to iconChoices (since default has only like 3.8k out of 15k icons)
function panel:AddMoreIcons(iconChoices)
	local function add(icon)
		if icon and not tContains(iconChoices,icon) then
			tinsert(iconChoices,icon)
		end
	end
	-- add icons from items in bags
	for i=0,4 do
		for j=1,GetContainerNumSlots(i) do
			add(GetContainerItemInfo(i,j))
		end
	end
	-- add icons from worn gear
	for i=1,19 do
		add(GetInventoryItemTexture("player",i))
	end
	-- add all pet icons
	for speciesID in rematch.Roster:AllSpecies() do
		add(rematch:GetPetIcon(speciesID))
	end
end

-- returns the tab index that a team key belongs to
function rematch:GetTabFromTeam(key)
	if saved[key] then
		return saved[key].tab or 1
	end
end

-- locks highlights on a specific tab (or unlocks highlight of all tabs if tab is nil)
function rematch:HighlightTeamTab(tab)
	local searching = rematch.TeamPanel:GetTeamSearchInfo()
	for i=1,MAX_TABS do
		if panel.Tabs[i] then
			if i==tab and searching then
				panel.Tabs[i]:LockHighlight()
			else
				panel.Tabs[i]:UnlockHighlight()
			end
		end
	end
end

function panel:TabButtonOnMouseDown()
	self.Icon:SetSize(28,28)
	self.Icon:SetVertexColor(0.75,0.75,0.75)
end

function panel:TabButtonOnMouseUp()
	self.Icon:SetSize(30,30)
	self.Icon:SetVertexColor(1,1,1)
end

-- returns a tab button by its index (and creates if it hasn't been made yet)
function panel:GetTabButton(index)
	if not panel.Tabs[index] then
		panel.Tabs[index] = CreateFrame("Button",nil,panel,"RematchTeamTabTemplate")
		panel.Tabs[index]:RegisterForClicks("AnyUp")
		panel.Tabs[index]:SetID(index)
		panel.Tabs[index]:SetPoint("TOPLEFT",0,(index-1)*-44)
	end
	return panel.Tabs[index]
end

function panel:TabButtonUpdate(index)
	local selected = panel:GetSelectedTab()
	local numGroups = #settings.TeamGroups
	local searchText,searchTabs = rematch.TeamPanel:GetTeamSearchInfo()

	-- texcoords and icon anchoring is flipped when button goes to left
	local left,right,centerSelected,centerUnselected = 0,0.6875,1,-5
	if settings.TeamTabsToLeft and settings.AlwaysTeamTabs and panel:GetParent()==rematch.Frame then
		left,right,centerSelected,centerUnselected = 0.6875,0,-1,5
	end

	if index>0 and index<=numGroups then
		local button = panel:GetTabButton(index)
		if index==selected and not searchText then
			button.Background:SetTexCoord(left,right,0,0.34375)
			button.Icon:SetPoint("CENTER",centerSelected,2)
		else
			button.Background:SetTexCoord(left,right,0.5,0.84375)
			button.Icon:SetPoint("CENTER",centerUnselected,2)
		end
		local desat = searchText and not searchTabs[index]
		button.Icon:SetDesaturated(desat)
		button.Custom:SetDesaturated(desat)
		button.Preferences:SetDesaturated(desat)
		if searchText and not searchTabs[index] then
			button.Icon:SetVertexColor(0.4,0.4,0.4)
		else
			button.Icon:SetVertexColor(1,1,1)
		end
		local group = settings.TeamGroups[index]
		button.Icon:SetTexture(group[2])
		button.Custom:SetShown(group[3] and true)
		button.Preferences:SetShown(group[4] and true)
		button:Show()
	elseif index==(numGroups+1) and index<=MAX_TABS then
		local button = panel:GetTabButton(index)
		button.Background:SetTexCoord(left,right,0.5,0.84375)
		button.Icon:SetPoint("CENTER",centerUnselected,2)
		button.Icon:SetTexture("Interface\\GuildBankFrame\\UI-GuildBankFrame-NewTab")
		button.Custom:Hide()
		button.Preferences:Hide()
		button:Show()
	elseif panel.Tabs[index] then
		panel.Tabs[index]:Hide()
	end
end
