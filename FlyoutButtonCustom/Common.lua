--[[ Common ]]

--const
local MIN_VISIBLE_BUTTONS_SETTINGS_MODE = 1
FBC_BUTTON_PLACE_SIZE 	= 36
FBC_BUTTON_PLACE_OFFSET	= 4
FBC_FRAME_OFFSET 		= 5
FBC_ARROW_OFFSET 		= 4

--arrow button directions
FBC_DIR_UP		= 1
FBC_DIR_LEFT	= 2
FBC_DIR_DOWN	= 3
FBC_DIR_RIGHT	= 4

function FlyoutButton_GetFullSpellName(name, rank)
	--[[if not(rank) then
		rank = ""
	end
	if (name) then
		return name.."("..rank..")"
	end
	return nil, nil]]
	return name
end

function FlyoutButton_GetGenericSpellNameById(id)
	local name, rank = GetSpellInfo(id)
	return FlyoutButton_GetFullSpellName(name, rank)
end

function FlyoutButton_FindSpellId(spellName)
	local link = GetSpellLink(spellName)
	if link then
		return tonumber(select(3, strfind(link, "spell:(%d+):")))
	else
		return nil
	end
end

local function GetMountIndexBySpellID(id)
	local creatureName, spellID, _, mountID
	for i = 1, C_MountJournal.GetNumMounts() do
		creatureName, spellID, _, _, _, _, _, _, _, _, _, mountID = C_MountJournal.GetDisplayedMountInfo(i)
		--print("GetMountIndexBySpellID", creatureName, spellID, mountID)
		if id == spellID then
			return i, mountID;
		end
	end
end

function FlyoutButton_SetCursor(command, value, subValue, id)
	--print("SetCursorValues", command, value, subValue, id)
	if not(command) then
		return
	end

	ClearCursor()
	if (command == "spell") then
		local mountIndex, mountID = GetMountIndexBySpellID(id)
		if mountIndex then
			--print(mountIndex, mountID)
			C_MountJournal.Pickup(mountIndex)
		else
			PickupSpell(id)
			local cmd, v, s, i = GetCursorInfo()
			if not v then
				PickupSpell(value)
			end
		end
	elseif (command == "item") then
		PickupItem(value)	--itemID or "itemString" or "itemName" or "itemLink"
	elseif (command == "macro") then
		PickupMacro(value)
	elseif (command == "equipmentset") then
		PickupEquipmentSetByName(value)
	elseif (command == "battlepet") then
		C_PetJournal.PickupPet(value)
	end
end

function FlyoutButton_GetCursorValues()
	local command, value, subValue, id = GetCursorInfo()
	--print("GetCursorValues", command, value, subValue, id)
	if (command == "spell") then
		value = FlyoutButton_GetGenericSpellNameById(id)
	--elseif (command == "item") or (command == "equipmentset") then
		--nothing to do, value is item id
	elseif (command == "macro") then		
		subValue = value -- value is macro index	
		value = GetMacroInfo(value) --name, texture, body
	elseif (command == "mount") then
		command = "spell"
		value, id = C_MountJournal.GetMountInfoByID(value) --creatureName, spellID
		subValue = "spell"
		--print(command, value, subValue, id)		
	end
	return command, value, subValue, id
end

function FlyoutButton_GetListButtonsCount(listTable)
	local count = 0
	if listTable then
		for i = 1, #listTable do
			if (listTable[i]) and (listTable[i].value) then
				count = i
			end
		end
	end
	local settingsCount = count
	
	if FbcSettingsMode then
		if count < MIN_VISIBLE_BUTTONS_SETTINGS_MODE then
			settingsCount = MIN_VISIBLE_BUTTONS_SETTINGS_MODE
		else
			settingsCount = count + 1
		end
	end
	return count, settingsCount
end

function FlyoutButton_GetSpecialization()
	if FbcSeparateSpecs then
		return GetSpecialization()
	else
		return 1
	end
end