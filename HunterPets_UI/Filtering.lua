function HunterPetJournal_InitializeFilter()
	HunterPetJournal.filterTypes = {};
	HunterPetJournal.filterZoneOnly = false;
	HunterPetJournal.filterRares = true;
	HunterPetJournal.filterElites = true;
	HunterPetJournal.filterExotic = true;
	HunterPetJournal.filterNormal = true;
	HunterPetJournal.filterByBuff = 0;
	HunterPetJournal.filterByExpac = {};
	HunterPetJournal.filterByVanilla = true;
	HunterPetJournal.filterByOwnedPets = true;
	HunterPetJournal.filterByOwnedLooks = true;
	HunterPetJournal_AddAllExpacs();
	HunterPetJournal_AddAllTypesAG();
	HunterPetJournal_AddAllTypesHW();
	HunterPetJournal_UpdateCachedList(HunterPetJournal);
end

function HunterPetJournal_HasSavedPets()
	if not HunterPetsGlobal then
		return false
	else
		for realm in pairs(HunterPetsGlobal.data) do
			for character in pairs(HunterPetsGlobal.data[realm]) do
				if HunterPetsGlobal.data[realm][character].OwnedPets then
					return true
				end
			end
		end
	end
end

function HunterPetJournal_IsPetExotic(index)
	return HunterPets.Types[HunterPetJournal_FindTruePetTypeIndex(HunterPets.Pets.Type[index])].Exotic
end

function HunterPetJournal_IsPetRare(index)
	for i=1, #HunterPets.Rares do
		if (HunterPets.Rares[i] == HunterPets.Pets.Id[index]) then return true end
	end
	return false
end

function HunterPetJournal_IsPetElite(index)
	for i=1, #HunterPets.Elites do
		if (HunterPets.Elites[i] == HunterPets.Pets.Id[index]) then return true end
	end
	return false
end

function HunterPetJournal_IsPetNormal(index)
	local isNormal = true
	if HunterPetJournal_IsPetExotic(index) then isNormal = false return isNormal end
	if HunterPetJournal_IsPetRare(index) then isNormal = false return isNormal end
	if HunterPetJournal_IsPetElite(index) then isNormal = false return isNormal end
	return isNormal
end


function HunterPetJournal_PetHasBuff(index)
	local petType = HunterPets.Types[HunterPetJournal_FindTruePetTypeIndex(HunterPets.Pets.Type[index])].Name
	for type in pairs(HunterPets.Buffs[HunterPetJournal.filterByBuff].PetTypes) do
		if HunterPets.Buffs[HunterPetJournal.filterByBuff].PetTypes[type] == petType then return true end
	end
	return false
end

function HunterPetJournal_IsPetOfType(index, petType)
	return HunterPets.Types[petType].Id == HunterPets.Pets.Type[index] 
end

function HunterPetJournal_IsPetOfExpac(index, expac)
	for subZones in pairs(HunterPets.Zones[expac]) do
		if	(HunterPets.Pets.Location[index] == HunterPets.Zones[expac][subZones]) then
			return true
		end
	end
end

function HunterPetJournal_IsPetOfVanilla(index)
	local isOfVanilla = true
	for i=1, #HunterPets.Zones do
		for subZones in pairs(HunterPets.Zones[i]) do
			if	(HunterPets.Pets.Location[index] == HunterPets.Zones[i][subZones]) then
				isOfVanilla = false
			end
		end
	end
	return isOfVanilla
end

function HunterPetJournal_IsPetExotic(index)
	return HunterPets.Types[HunterPetJournal_FindTruePetTypeIndex(HunterPets.Pets.Type[index])].Exotic
end

function HunterPetJournal_PetOwned(index)
	for realm in pairs(HunterPetsGlobal.data) do
		for character in pairs(HunterPetsGlobal.data[realm]) do
			for savedPet in pairs(HunterPetsGlobal.data[realm][character].OwnedPets) do
				local icon, name, level, family, npc_id, displayId  = strsplit(":",HunterPetsGlobal.data[realm][character].OwnedPets[savedPet])
				if npc_id then
					if HunterPets.Pets.Id[index] == tonumber(npc_id) then return true end
				end
			end
		end
	end
	
	return false
end

function HunterPetJournal_LookOwned(index)
	for realm in pairs(HunterPetsGlobal.data) do
		for character in pairs(HunterPetsGlobal.data[realm]) do
			for savedPet in pairs(HunterPetsGlobal.data[realm][character].OwnedPets) do
				local icon, name, level, family, npc_id, displayId  = strsplit(":",HunterPetsGlobal.data[realm][character].OwnedPets[savedPet])
				if displayId then
					if HunterPets.Pets.DisplayId[index] == tonumber(displayId) then return true end
				end
			end
		end
	end

	return false
end

function HunterPetJournal_HunterPetMatchesSearch(name)
	if ( HunterPetJournal.searchString ) then
		if ( string.find(string.lower(name), HunterPetJournal.searchString, 1, true) ) then
			return true;
		else
			return false;
		end
	end
end

function HunterPetJournal_AddAllExpacs()
	for i=1, #Expacs do
		HunterPetJournal.filterByExpac[i] = true;
		HunterPetJournal.filterByVanilla = true;
	end
end

function HunterPetJournal_ClearAllExpacs()
	for i=1, #Expacs do
		HunterPetJournal.filterByExpac[i] = false;
		HunterPetJournal.filterByVanilla = false;
	end
end

function HunterPetJournal_AddAllTypesAG()
	local endIndex = 25
	--[[
	for i=1,#HunterPets.Types do
		if string.sub(HunterPets.Types[i].Name,0,1) == "H" then
			endIndex = i;
		end
	end
	--]]
	for i=1,endIndex do
		HunterPetJournal.filterTypes[i] = true
	end
end

function HunterPetJournal_AddAllTypesHW()
	local startIndex = 26;
	--[[
	for i=1,#HunterPets.Types do
		if string.sub(HunterPets.Types[i].Name,0,1) == "M" then
			startIndex = i;
			break;
		end
	end
	--]]
	for i=startIndex,#HunterPets.Types do
		HunterPetJournal.filterTypes[i] = true
	end
end

function HunterPetJournal_ClearAllTypesAG()
	local endIndex = 25
	--[[
	for i=1,#HunterPets.Types do
		if string.sub(HunterPets.Types[i].Name,0,1) == "H" then
			endIndex = i;
		end
	end
	--]]
	for i=1,endIndex do
		HunterPetJournal.filterTypes[i] = false
	end
end

function HunterPetJournal_ClearAllTypesHW()
	local startIndex = 26;
	--[[
	for i=1,#HunterPets.Types do
		if string.sub(HunterPets.Types[i].Name,0,1) == "M" then
			startIndex = i;
			break;
		end
	end
	--]]
	for i=startIndex,#HunterPets.Types do
		HunterPetJournal.filterTypes[i] = false
	end
end

function HunterPetJournal_SetTypeFilter(sourceType,value)
	HunterPetJournal.filterTypes[sourceType] = value;
end

function HunterPetJournal_IsTypeNotFiltered(sourceType)
	if ( not HunterPetJournal.filterTypes or (sourceType == 0) ) then
		return true;
	end
	return HunterPetJournal.filterTypes[sourceType]
end

function HunterPetJournalFilterDropDown_Initialize(self, level)
	local info = UIDropDownMenu_CreateInfo();
	info.keepShownOnClick = true;	

	if level == 1 then
		info.text = "稀有"
		info.isNotRadio = true;
		info.checked = function() return HunterPetJournal.filterRares end;
		info.func = function(_, _, _, value) HunterPetJournal.filterRares = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
		UIDropDownMenu_AddButton(info, level)

		info.text = "精英"
		info.checked = function() return HunterPetJournal.filterElites end;
		info.func = function(_, _, _, value) HunterPetJournal.filterElites = value;HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
		UIDropDownMenu_AddButton(info, level)

		info.text = "特別色"
		info.checked = function() return HunterPetJournal.filterExotic end;
		info.func = function(_, _, _, value) HunterPetJournal.filterExotic = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
		UIDropDownMenu_AddButton(info, level)
	
		info.text = "普通"
		info.checked = function() return HunterPetJournal.filterNormal end;
		info.func = function(_, _, _, value) HunterPetJournal.filterNormal = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
		UIDropDownMenu_AddButton(info, level)

		if HunterPetJournal_HasSavedPets() then
			info.text = "已有的寵物"
			info.checked = function() return HunterPetJournal.filterByOwnedPets end;
			info.func = function(_, _, _, value) HunterPetJournal.filterByOwnedPets = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
			UIDropDownMenu_AddButton(info, level)

			info.text = "已有的外觀"
			info.checked = function() return HunterPetJournal.filterByOwnedLooks end;
			info.func = function(_, _, _, value) HunterPetJournal.filterByOwnedLooks = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
			UIDropDownMenu_AddButton(info, level)

		end


		info.checked = 	nil;
		info.isNotRadio = nil;
		info.func =  nil;
		info.hasArrow = true;
		info.notCheckable = true;
		
		info.text = "資料片版本";
		info.value = 4;
		UIDropDownMenu_AddButton(info, level)

		info.checked = 	nil;
		info.isNotRadio = nil;
		info.func =  nil;
		info.hasArrow = true;
		info.notCheckable = true;
		
		info.text = "種類 1";
		info.value = 1;
		UIDropDownMenu_AddButton(info, level)

		info.checked = 	nil;
		info.isNotRadio = nil;
		info.func =  nil;
		info.hasArrow = true;
		info.notCheckable = true;
		
		info.text = "種類 2";
		info.value = 2;
		UIDropDownMenu_AddButton(info, level)

		info.checked = 	nil;
		info.isNotRadio = nil;
		info.func =  nil;
		info.hasArrow = true;
		info.notCheckable = true;
		
		info.text = "增益效果";
		info.value = 3;
		UIDropDownMenu_AddButton(info, level)
	
	else --if level == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == 1 then
			info.hasArrow = false;
			info.isNotRadio = true;
			info.notCheckable = true;
				
			info.text = CHECK_ALL
			info.func = function()
							HunterPetJournal_AddAllTypesAG();
							UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2);
							HunterPetJournal_UpdateCachedList(HunterPetJournal);
						end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = UNCHECK_ALL
			info.func = function()
							HunterPetJournal_ClearAllTypesAG();
							UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2);
							HunterPetJournal_UpdateCachedList(HunterPetJournal);
						end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = false;

			local endIndex = 25
			--[[
			for i=1,#HunterPets.Types do
				if string.sub(HunterPets.Types[i].Name,0,1) == "H" then
					endIndex = i;
				end
			end
			--]]
			for i=1,endIndex do
				info.text = HunterPets.Types[i].Name
				info.checked = function() return HunterPetJournal_IsTypeNotFiltered(i) end;
				info.func = function(_, _, _, value) HunterPetJournal.filterTypes[i] = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
				UIDropDownMenu_AddButton(info, level);
			end
		end
		if UIDROPDOWNMENU_MENU_VALUE == 2 then
			info.hasArrow = false;
			info.isNotRadio = true;
			info.notCheckable = true;
				
			info.text = CHECK_ALL
			info.func = function()
							HunterPetJournal_AddAllTypesHW();
							UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2);
							HunterPetJournal_UpdateCachedList(HunterPetJournal);
						end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = UNCHECK_ALL
			info.func = function()
							HunterPetJournal_ClearAllTypesHW();
							UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2);
							HunterPetJournal_UpdateCachedList(HunterPetJournal);
						end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = false;

			local startIndex = 26;
			--[[
			for i=1,#HunterPets.Types do
				if string.sub(HunterPets.Types[i].Name,0,1) == "M" then
					startIndex = i;
					break;
				end
			end
			--]]
			for i=startIndex,#HunterPets.Types do
				info.text = HunterPets.Types[i].Name
				info.checked = function() return HunterPetJournal_IsTypeNotFiltered(i) end;
				info.func = function(_, _, _, value) HunterPetJournal.filterTypes[i] = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
				UIDropDownMenu_AddButton(info, level);
			end
		end
		if UIDROPDOWNMENU_MENU_VALUE == 3 then
			info.hasArrow = false;
			info.isNotRadio = nil;
			info.notCheckable = nil;
			
			info.text = "全部"
			info.checked = function() if HunterPetJournal.filterByBuff == 0 then return true end end;
			info.func = function() HunterPetJournal.filterByBuff = 0; UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2); HunterPetJournal_UpdateCachedList(HunterPetJournal); end
			UIDropDownMenu_AddButton(info, level)

			for k in pairs(HunterPets.Buffs) do
				info.text = HunterPets.Buffs[k].Name
				info.checked = function() if HunterPetJournal.filterByBuff == k then return true end end
				info.func = function() HunterPetJournal.filterByBuff = k; UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2); HunterPetJournal_UpdateCachedList(HunterPetJournal); end
				UIDropDownMenu_AddButton(info, level)

			end
		end
		if UIDROPDOWNMENU_MENU_VALUE == 4 then
			info.hasArrow = false;
			info.isNotRadio = true;
			info.notCheckable = true;
				
			info.text = CHECK_ALL
			info.func = function()
							HunterPetJournal_AddAllExpacs()
							UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2);
							HunterPetJournal_UpdateCachedList(HunterPetJournal)
						end
			UIDropDownMenu_AddButton(info, level)
			
			info.text = UNCHECK_ALL
			info.func = function()
							HunterPetJournal_ClearAllExpacs()
							UIDropDownMenu_Refresh(HunterPetJournalFilterDropDown, 1, 2);
							HunterPetJournal_UpdateCachedList(HunterPetJournal)
						end
			UIDropDownMenu_AddButton(info, level)

			info.notCheckable = false;

			info.text = "艾澤拉斯"
			info.checked = function() return HunterPetJournal.filterByVanilla end;
			info.func = function(_, _, _, value) HunterPetJournal.filterByVanilla = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
			UIDropDownMenu_AddButton(info, level);

			

			for i=1, #Expacs do
				info.text = Expacs[i]
				info.checked = function() return HunterPetJournal.filterByExpac[i] end;
				info.func = function(_, _, _, value) HunterPetJournal.filterByExpac[i] = value; HunterPetJournal_UpdateCachedList(HunterPetJournal); end;
				UIDropDownMenu_AddButton(info, level);
			end
		end
	end
end
