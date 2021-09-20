local Tabs = LibStub('SecureTabs-2.0')
local PET_BUTTON_HEIGHT = 46;

function HunterPetJournal_Toggle()
	if not CollectionsJournal:IsShown() then
		local tabNum = 0
		for i=1, CollectionsJournal.numTabs do
			local text = _G["CollectionsJournalTab"..i]:GetText()
			if text == "獵人寵物" then
				tabNum = i
			end
		end
		ToggleCollectionsJournal(tabNum)
	else
		ToggleCollectionsJournal(tabNum)
	end
end

function HunterPetJournal_Show()
	PlaySound(SOUNDKIT.UI_TOYBOX_TABS);
	hooksecurefunc('CollectionsJournal_UpdateSelectedTab', function(...) Tabs:Update(...); end)
	MountJournal:Hide();
	PetJournal:Hide();
	ToyBox:Hide();
	HeirloomsJournal:Hide();
	WardrobeCollectionFrame:Hide();
	HunterPetJournal:Show();
	HunterPetJournal_UpdateCachedList(HunterPetJournal);
	if (HunterPetJournal.selectedID) then
		HunterPetJournal_Select(HunterPetJournal.selectedID)
	else
		HunterPetJournal_Select(HunterPets.Pets.Id[HunterPetJournal.cachedPets[1]]);
	end
	if not (IsAddOnLoaded("HunterPets_Owned")) then
		HunterPetJournalStabledPetsButton:Hide()
	else
		HunterPetJournalStabledPetsButton:Show()
	end
	SetPortraitToTexture(CollectionsJournalPortrait,"Interface\\Icons\\Ability_Physical_Taunt");
	CollectionsJournalTitleText:SetText("獵人寵物");
end


function HunterPetJournal_OnLoad(self)
	--[[local journals = {CollectionsJournal};
	for i,v in ipairs({CollectionsJournal:GetChildren()})do
		if (v.GetObjectType and v:GetObjectType("Frame") and v:GetName() and issecurevariable(v:GetName()) and CollectionsJournal:GetHeight()==v:GetHeight()) then
			tinsert(journals,v);
		end
	end

	Tabs:Startup(unpack(journals));
	HunterPetJournal.Tab = Tabs:Add(CollectionsJournal, HunterPetJournal, "Hunter Pets", 6);
	CollectionsJournal:HookScript('OnShow', HunterPetJournal_Show);
	]]

	CollectionsJournal_LoadUI()
	HunterPetsJournal_PanelTab = LibStub('SecureTabs-2.0'):Add(CollectionsJournal, HunterPetJournal, "獵人寵物")
	HunterPetsJournal_PanelTab.OnSelect = function()
		HunterPetJournal_Show();
	end

	self.ListScrollFrame.update = HunterPetJournal_UpdatePetList;
	self.ListScrollFrame.scrollBar.doNotHide = true;
	HybridScrollFrame_CreateButtons(self.ListScrollFrame, "HunterPetListButtonTemplate", 44, 0);
	Expacs = { "燃燒的遠征", "巫妖王之怒", "浩劫與重生", "潘達利亞之謎", "德拉諾之霸", "軍臨天下" }

	HunterPetJournal.currentZone = GetRealZoneText();
	HunterPetJournal.zoneId = 0;
	HunterPetJournal_GetLocationId();
	HunterPetJournal_InitializeFilter();
	if (HunterPetsSettings) then
		HunterPetJournal.filterZoneOnly = HunterPetsSettings.filterZoneOnly;
		HunterPetJournal.ShowOnlyInZone.CheckButton:SetChecked(HunterPetsSettings.filterZoneOnly);
		HunterPetJournal:RegisterEvent("ZONE_CHANGED")
		HunterPetJournal:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	end

end

function HunterPetJournal_OnEvent(self, event)
	if  event == "ZONE_CHANGED"  then
		if CollectionsJournal:IsShown() then
			if HunterPetJournal_GetLocationId() then HunterPetJournal_UpdateCachedList(HunterPetJournal) end
		end
	end
	if event == "ZONE_CHANGED_NEW_AREA" then
		if CollectionsJournal:IsShown() then
			if HunterPetJournal_GetLocationId() then HunterPetJournal_UpdateCachedList(HunterPetJournal) end
		end
	end
end

function HunterPetJournal_GetLocationId()
	local tmpId = 0
	for k in pairs(HunterPets.Locations) do
		if (HunterPets.Locations[k] == GetRealZoneText()) then
			tmpId = k;
		end
	end
	if tmpId ~= HunterPetJournal.zoneId then
		HunterPetJournal.zoneId = tmpId;
		return true
	end
	return false
end

function HunterPetJournal_ZoneOnlyCheckButton_OnClick(self)
	if ( self:GetChecked() ) then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		HunterPetJournal:RegisterEvent("ZONE_CHANGED")
		HunterPetJournal:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		HunterPetJournal_GetLocationId()
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF);
		HunterPetJournal:UnregisterEvent("ZONE_CHANGED")
		HunterPetJournal:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end
	HunterPetsSettings.filterZoneOnly = self:GetChecked();
	HunterPetJournal.filterZoneOnly = self:GetChecked()
	HunterPetJournal_UpdateCachedList(HunterPetJournal)

end

function HunterPetJournal_GetNumPets()
	return #HunterPets.Pets.Name
end

function HunterPetJournal_GetButtonBackground(button, index)
	local expac = 0
	for i=1, #HunterPets.Zones do
		for subZones in pairs(HunterPets.Zones[i]) do
			if	(HunterPets.Pets.Location[index] == HunterPets.Zones[i][subZones]) then
				expac = i
			end			
		end
	end
	if expac == 0 then
		button:SetNormalTexture("")
	end
	if expac == 1 then 
		button:SetNormalTexture("Interface\\Addons\\HunterPets_UI\\Graphics\\Burning.tga");
	end
	if expac == 2 then 
		button:SetNormalTexture("Interface\\Addons\\HunterPets_UI\\Graphics\\Wrath.tga");
	end
	if expac == 3 then 
		button:SetNormalTexture("Interface\\Addons\\HunterPets_UI\\Graphics\\Cata.tga");
	end
	if expac == 4 then 
		button:SetNormalTexture("Interface\\Addons\\HunterPets_UI\\Graphics\\Mists.tga");
	end
	if expac == 5 then 
		button:SetNormalTexture("Interface\\Addons\\HunterPets_UI\\Graphics\\Warlords.tga");
	end
	if expac == 6 then 
		button:SetNormalTexture("Interface\\Addons\\HunterPets_UI\\Graphics\\Legion.tga");
	end
end

function HunterPetJournal_UpdatePetList()

	local scrollFrame = HunterPetJournal.ListScrollFrame;
	local offset = HybridScrollFrame_GetOffset(scrollFrame);
	local buttons = scrollFrame.buttons;
	
	local showPets = true
	if  ( #HunterPetJournal.cachedPets < 1 ) then
		MountJournal.MountDisplay.NoMounts:Show();
		for i=1, #buttons do buttons[i]:SetNormalTexture("") end
		showPets = false;
	else
		MountJournal.MountDisplay.NoMounts:Hide();
	end


	for i=1, #buttons do
		local button = buttons[i];
		local displayIndex = i + offset;
		if ( displayIndex <= #HunterPetJournal.cachedPets and showPets) then
			local petIndex = HunterPetJournal.cachedPets[displayIndex];

			button.name:SetText(HunterPets.Pets.Name[petIndex]);
			button.index = petIndex;
			button.npcID = HunterPets.Pets.Id[petIndex];
			button:Show();
			button.icon:SetTexture("");
			button.active = false;
			button.MiniModelFrame:Show();
			button.MiniModelFrame:SetDisplayInfo(HunterPets.Pets.DisplayId[petIndex]);
			
			if ( HunterPetJournal.selectedID == HunterPets.Pets.Id[petIndex] ) then
				button.selected = true;
				button.selectedTexture:Show();
			else
				button.selected = false;
				button.selectedTexture:Hide();
			end
			
			if ( HunterPetJournal_IsPetExotic(petIndex) ) then
				button.exotic:Show()
			else
				button.exotic:Hide()
			end
			
			if ( HunterPetJournal_IsPetRare(petIndex) ) then
				button.rare:Show()
			else
				button.rare:Hide()
			end

			if ( HunterPetJournal_IsPetElite(petIndex) ) then
				button.elite:Show()
			else
				button.elite:Hide()
			end
			HunterPetJournal_GetButtonBackground(button, petIndex)
			button:SetEnabled(true);
			button.favorite:Hide();
			button.background:SetVertexColor(1, 1, 1, 1);
						

			button.additionalText = nil;
			button.icon:SetDesaturated(false);
			button.icon:SetAlpha(1.0);
			button.name:SetFontObject("GameFontNormal");				

		else
			button.name:SetText("");
			button.icon:SetTexture("Interface\\PetBattles\\MountJournalEmptyIcon");
			button:SetNormalTexture("");
			button.MiniModelFrame:Hide();
			button.rare:Hide()
			button.elite:Hide()
			button.exotic:Hide()
			button.index = nil;
			button.npcID = 0;
			button.selected = false;
			button.selectedTexture:Hide();
			button:SetEnabled(false);
			button.icon:SetDesaturated(true);
			button.icon:SetAlpha(0.5);
			button.favorite:Hide();
			button.factionIcon:Hide();
			button.background:SetVertexColor(1, 1, 1, 1);
			button.iconBorder:Hide();
		end
	end
	local numLooks = 0
	for id in pairs (HunterPetJournal.cachedLooks) do
		numLooks = numLooks + 1
	end
	HunterPetJournal.TamableLooks.Count:SetText(numLooks);
	HunterPetJournal.TamablePets.Count:SetText(#HunterPetJournal.cachedPets);
	if ( not showPets ) then
		HunterPetJournal.selectedID = 0;
		HunterPetJournal_UpdatePetDisplay()
	end

	local totalHeight = #HunterPetJournal.cachedPets * PET_BUTTON_HEIGHT;
	HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight());

end

function HunterPetJournal_GetLevelText(index)
	if (HunterPets.Pets.Max[index] == -1 or HunterPets.Pets.Min[index] == -1) then
		return ("" .. HunterPets.Pets.Min[index] .. " - " .. HunterPets.Pets.Max[index])
	elseif (HunterPets.Pets.Max[index] == 0) then
		return "Unknown"
	elseif (HunterPets.Pets.Max[index] == 9999) then
		return "Raid Boss"
	elseif (HunterPets.Pets.Min[index] == HunterPets.Pets.Max[index]) then
		return ("" .. HunterPets.Pets.Min[index])
	elseif (HunterPets.Pets.Min[index] ~= HunterPets.Pets.Max[index]) then
		return ("" .. HunterPets.Pets.Min[index] .. " - " .. HunterPets.Pets.Max[index])
	end

end

function HunterPetJournal_FindTruePetTypeIndex(index)
	for i=1, #HunterPets.Types do
		if (HunterPets.Types[i].Id == index) then return i end;
	end
end
function HunterPetJournal_GetHunterPetInfo(index)
	local trueTypeIndex = HunterPetJournal_FindTruePetTypeIndex(HunterPets.Pets.Type[index]);
	local petName = HunterPets.Pets.Name[index];
	local petId = HunterPets.Pets.Id[index];
	local location = HunterPets.Locations[HunterPets.Pets.Location[index]];
	local icon = "Interface\\Icons\\" .. HunterPets.Types[trueTypeIndex].Icon;

	local petText = NORMAL_FONT_COLOR_CODE .. "區域: " .. FONT_COLOR_CODE_CLOSE .. HunterPets.Locations[HunterPets.Pets.Location[index]] .. "|n" ..
			NORMAL_FONT_COLOR_CODE .. "等級: " .. FONT_COLOR_CODE_CLOSE .. HunterPetJournal_GetLevelText(index)

	local displayId = HunterPets.Pets.DisplayId[index]

	local abilities =  {}
	
	for i=1, #HunterPets.Types[trueTypeIndex].Spells do
		abilities[i] = HunterPets.Types[trueTypeIndex].Spells[i]
	end
	local petType = HunterPets.Types[trueTypeIndex].Name
	return petName, petId, icon, location, petText, abilities, displayId, petType
end


function HunterPetJournal_UpdatePetDisplay()
	local index = HunterPetJournal_FindSelectedIndex();
	if ( index ) then
		if ( HunterPetJournal.PetDisplay.lastDisplayed ~= HunterPetJournal.selectedID ) then
			local petName, petId, icon, location, petText, abilities, displayId, petType = HunterPetJournal_GetHunterPetInfo(index);
			HunterPetLocations_Update(index);
			HunterPetJournal.PetDisplay.InfoButton.Name:SetText(petName);
			HunterPetJournal.PetDisplay.InfoButton.Icon:SetTexture(icon);
			
			HunterPetJournal.PetDisplay.InfoButton.Source:SetText(petText);

			HunterPetJournal.PetDisplay.InfoButton.Abilities:SetText(NORMAL_FONT_COLOR_CODE .. "種類:" .. FONT_COLOR_CODE_CLOSE .. " " .. petType)

			if (abilities[1]) then
				local name, rank ,icon = GetSpellInfo(abilities[1])
				HunterPetJournal.PetDisplay.AIcon1.spellID = abilities[1];
				HunterPetJournal.PetDisplay.AIcon1.Icon:SetTexture(icon);
			else
				HunterPetJournal.PetDisplay.AIcon1.spellID = nil;
				HunterPetJournal.PetDisplay.AIcon1.Icon:SetTexture();
			end
			if (abilities[2]) then
				local name, rank ,icon = GetSpellInfo(abilities[2])
				HunterPetJournal.PetDisplay.AIcon2.spellID = abilities[2];
				HunterPetJournal.PetDisplay.AIcon2.Icon:SetTexture(icon);
			else
				HunterPetJournal.PetDisplay.AIcon2.spellID = nil;
				HunterPetJournal.PetDisplay.AIcon2.Icon:SetTexture();
			end
			if (abilities[3]) then
				local name, rank ,icon = GetSpellInfo(abilities[3])
				HunterPetJournal.PetDisplay.AIcon3.spellID = abilities[3];
				HunterPetJournal.PetDisplay.AIcon3.Icon:SetTexture(icon);
			else
				HunterPetJournal.PetDisplay.AIcon3.spellID = nil;
				HunterPetJournal.PetDisplay.AIcon3.Icon:SetTexture();
			end
			if (abilities[4]) then
				local name, rank ,icon = GetSpellInfo(abilities[4])
				HunterPetJournal.PetDisplay.AIcon4.spellID = abilities[4];
				HunterPetJournal.PetDisplay.AIcon4.Icon:SetTexture(icon);
			else
				HunterPetJournal.PetDisplay.AIcon4.spellID = nil;
				HunterPetJournal.PetDisplay.AIcon4.Icon:SetTexture();
			end

			HunterPetJournal.PetDisplay.lastDisplayed = HunterPetJournal.selectedID;

			HunterPetJournal.PetDisplay.ModelFrame:SetDisplayInfo(displayId);

		end

		HunterPetJournal.PetDisplay.ModelFrame:Show();
		HunterPetJournal.PetDisplay.InfoButton:Show();
		HunterPetJournal.PetDisplay.NoPets:Hide();
	else
		HunterPetJournal.PetDisplay.InfoButton:Hide();
		HunterPetJournal.PetDisplay.ModelFrame:Hide();
		HunterPetJournal.PetDisplay.NoPets:Show();
		HunterPetJournal.PetDisplay.AIcon1.Icon:SetTexture();
		HunterPetJournal.PetDisplay.AIcon2.Icon:SetTexture();
		HunterPetJournal.PetDisplay.AIcon3.Icon:SetTexture();
		HunterPetJournal.PetDisplay.AIcon4.Icon:SetTexture();

	end
end

function HunterPetJournal_FindSelectedIndex()
	local selectedID = HunterPetJournal.selectedID;
	if ( selectedID ) then
		for i=1, HunterPetJournal_GetNumPets() do
			--local creatureName, spellID, icon, active = MountJournal_GetMountInfo(i);
			if ( HunterPets.Pets.Id[i] == selectedID ) then
				return i;
			end
		end
	end

	return nil;
end

function HunterPetJournal_Select(index)
	HunterPetJournal.selectedID = index;
	HunterPetJournal_UpdatePetList();
	HunterPetJournal_UpdatePetDisplay();
end


function HunterPetListItem_OnClick(self, button)
	HunterPetJournal_Select(self.npcID);
end

function HunterPetJournalFilterDropDown_OnLoad(self)
	UIDropDownMenu_Initialize(self, HunterPetJournalFilterDropDown_Initialize, "MENU");
end


function HunterPetJournal_UpdateCachedList(self)
	self.cachedPets = {};
	self.cachedLooks = {};
	for i=1, HunterPetJournal_GetNumPets() do
		local doAdd = true;

		if HunterPetJournal.searchString then
			doAdd = false
			if HunterPetJournal_HunterPetMatchesSearch(HunterPets.Pets.Name[i]) or HunterPetJournal_HunterPetMatchesSearch(HunterPets.Locations[HunterPets.Pets.Location[i]]) then
				doAdd = true
			end

		end
		if doAdd then
			if HunterPetJournal.filterZoneOnly then
				if tonumber(HunterPets.Pets.Location[i]) ~= tonumber(HunterPetJournal.zoneId) then
					doAdd = false;
				end
			end
		end
		if doAdd then
			if HunterPetJournal.filterByBuff > 0 then
				if not HunterPetJournal_PetHasBuff(i) then
					doAdd = false;
				end
			end
		end
		if doAdd then
			if not HunterPetJournal.filterExotic then
				if HunterPetJournal_IsPetExotic(i) then
					doAdd = false;
				end
			end
		end
		if doAdd then
			if not HunterPetJournal.filterRares then
				if HunterPetJournal_IsPetRare(i) then
					doAdd = false
				end
			end
		end
		if doAdd then
			if not HunterPetJournal.filterElites then
				if HunterPetJournal_IsPetElite(i) then
					doAdd = false
				end
			end
		end

		if doAdd then
			if not HunterPetJournal.filterNormal then
				if HunterPetJournal_IsPetNormal(i) then
					doAdd = false
				end
			end
		end
		for a=1, #HunterPets.Types do
			if doAdd then
				if not HunterPetJournal.filterTypes[a] then
					if HunterPetJournal_IsPetOfType(i, a) then
						doAdd = false
					end
				end
			end
		end
		
		if doAdd then
			if not HunterPetJournal.filterByVanilla then
				if HunterPetJournal_IsPetOfVanilla(i) then
					doAdd = false
				end
			end
		end

		for a=1, #Expacs do
			if doAdd then
				if not HunterPetJournal.filterByExpac[a] then
					if HunterPetJournal_IsPetOfExpac(i, a) then
						doAdd = false;
					end
				end
			end
		end

		if doAdd then
			if not HunterPetJournal.filterByOwnedPets then
				if HunterPetJournal_PetOwned(i) then
					doAdd = false;
				end
			end
		end

		if doAdd then
			if not HunterPetJournal.filterByOwnedLooks then
				if HunterPetJournal_LookOwned(i) then
					doAdd = false;
				end
			end
		end


		if (doAdd) then
			self.cachedPets[#self.cachedPets + 1] = i;
			self.cachedLooks[HunterPets.Pets.DisplayId[i]] = true
		end
	end
	HunterPetJournal_UpdatePetList();
end

function HunterPetJournal_OnSearchTextChanged(self)
	SearchBoxTemplate_OnTextChanged(self);

	local text = self:GetText();
	local oldText = HunterPetJournal.searchString;
	if ( text == "" ) then
		HunterPetJournal.searchString = nil;
	else
		HunterPetJournal.searchString = string.lower(text);
	end

	if ( oldText ~= HunterPetJournal.searchString ) then
		HunterPetJournal_UpdateCachedList(HunterPetJournal);
	end
end
