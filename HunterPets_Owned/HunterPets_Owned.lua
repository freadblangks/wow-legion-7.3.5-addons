local LibQTip = LibStub('LibQTip-1.0')

local selectedCharacter
local selectedRealm
local isReadyForUpdate = false

function HunterPetsOwned_OnLoad()
	HunterPetsOwned:RegisterEvent("PLAYER_LOGIN");
	SetPortraitToTexture(HunterPetsOwnedPortrait,"Interface\\Icons\\ability_physical_taunt");
	HunterPetsOwned.TitleText:SetFormattedText("獸欄寵物瀏覽器");
--	HunterPetsOwned:Show()
end

function HunterPetsOwned_Toggle()
	if HunterPetsOwned:IsShown() then
		HunterPetsOwned:Hide()
	else
		HunterPetsOwned:Show()
	end
end

function HunterPetsOwnedCharacterMenu_OnLoad()
	for realm in pairs(HunterPetsGlobal.data) do
		for character in pairs(HunterPetsGlobal.data[realm]) do
			if (character ~= selectedCharacter) then
				info = {}
				info.text       = realm .. " - " .. character;
				info.value      = realm .. " - " .. character;
				info.func       = function() selectedCharacter = character; selectedRealm = realm; HunterPetsOwned_Update(); HunterPetsOwnedCharacterListButtonText:SetText(selectedCharacter); end
				UIDropDownMenu_AddButton(info);
			end
		end
	end
end

function HunterPetsOwned_GenerateTooltip(anchor, name, subtext, displayId, npc)
	local OwnedToolTip = LibQTip:Acquire("HunterPetsOwned", 1, "LEFT");
	OwnedToolTip:SetAutoHideDelay(0.1, anchor)
	OwnedToolTip:SmartAnchorTo(anchor)	
	OwnedToolTip:Clear()
	
	OwnedToolTip:SetCellMarginH(0)
	OwnedToolTip:SetCellMarginV(1)

	OwnedToolTip:SetCell(OwnedToolTip:AddLine(), 1, name, GameFontNormalLarge, "LEFT", 0)
	OwnedToolTip:SetCell(OwnedToolTip:AddLine(), 1, subtext, GameFontHighlight, "LEFT", 0)

	if (displayId) then
		duplicates = HunterPets:FindDuplicate(selectedRealm, selectedCharacter, name, displayId)
	end
	if (duplicates) then
		OwnedToolTip:AddSeparator(1, 0.5, 0.5, 0.5)
		OwnedToolTip:SetCell(OwnedToolTip:AddLine(), 1, "發現重複:", GameFontSmall, "LEFT", 0)

		for dup in pairs(duplicates["pets"]) do
			OwnedToolTip:SetCell(OwnedToolTip:AddLine(), 1, duplicates["pets"][dup][3] .. " ("..duplicates["pets"][dup][1].." - "..duplicates["pets"][dup][2]..")", GameFontSmall, "LEFT", 0)
		end
	end

	if displayId then
		if not OwnedToolTip.displayFrame then
			OwnedToolTip.displayFrame = CreateFrame("PlayerModel", "OwnedDisplayFrame", OwnedToolTip);
			OwnedToolTip.displayFrame:SetWidth(150);
			OwnedToolTip.displayFrame:SetHeight(150);
			OwnedToolTip.displayFrame:SetRotation(0.5)
		end
		OwnedToolTip.displayFrame:SetCreature(npc)

		OwnedToolTip.displayFrame:SetPoint("TOP",0,8-OwnedToolTip:GetHeight())
		OwnedToolTip:SetHeight(OwnedToolTip:GetHeight()+150)
		if (OwnedToolTip:GetWidth() < 150) then
			OwnedToolTip:SetWidth(160)
		end
		OwnedToolTip.displayFrame:Show();
	else
		if OwnedToolTip.displayFrame then
			OwnedToolTip.displayFrame:Hide()
		end
	end
	OwnedToolTip:Show()
end

function HunterPetsOwned_ReleaseTooltip(anchor)
   -- Release the tooltip
--   LibQTip:Release(anchor.tooltip)
 --  anchor.tooltip = nil
end

function HunterPetsOwned_OnEvent(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		selectedCharacter = UnitName("player");
		selectedRealm = GetRealmName();
		HunterPetsOwnedCharacterListButtonText:SetText(selectedCharacter)
	end
end

function HunterPetsOwned_Update()
	local numPets, numPetsScanned = HunterPets:GetNumPets(selectedRealm, selectedCharacter);
	HunterPetsOwnedStats:SetText(numPets .. " 隻寵物 (" .. "已完整掃描 " .. numPetsScanned .. ")")
	local totalSlots = (NUM_PET_STABLE_SLOTS*NUM_PET_STABLE_PAGES)+NUM_PET_ACTIVE_SLOTS

	for i=1, totalSlots do
		local button = _G["HunterPetsOwnedStabledPet"..i];
		if not HunterPetsGlobal.data[selectedRealm] then return end
		if not HunterPetsGlobal.data[selectedRealm][selectedCharacter] then return end
		if (HunterPetsGlobal.data[selectedRealm][selectedCharacter].OwnedPets[i]) then	
			button:Enable()
			HunterPetsOwned_UpdateSlot(button, i)
		else
			SetItemButtonTexture(button, "");
			button.tooltip = "空的獸欄欄位"
			button.tooltilSubtext = ""
			button:Disable()
			button.Checked:Hide()
		end
	end
end

function HunterPetsOwned_UpdateSlot(button, slotIndex)
	local icon, name, level, family, npc_id, displayId  = strsplit(":",HunterPetsGlobal.data[selectedRealm][selectedCharacter].OwnedPets[slotIndex])

	level = tonumber(level)
	if npc_id then npc_id = tonumber(npc_id); button.npc = npc_id end
	if displayId then displayId = tonumber(displayId) end
	button.tooltip = name;
	button.tooltipSubtext = format("等級 %1$d %2$s", level, family);

--	if (button.PetName) then
--		button.PetName:SetText(name);
--	end
	
--	if ( GameTooltip:IsOwned(button) ) then
--		button:GetScript("OnEnter")(button);
--	end
	
	if  (npc_id) then
		button.Checked:Show()
	else
		button.Checked:Hide()
	end
	
	if (displayId) then
		button.displayId = displayId
	else
		button.displayId = nil
	end

	SetItemButtonTexture(button, icon);

end

function HunterPetsOwned_SetText(displayId, text, text2)
	HunterPetsOwnedTooltipTextLeft1:SetText(NORMAL_FONT_COLOR_CODE .. text .. FONT_COLOR_CODE_CLOSE)
	HunterPetsOwnedTooltipTextLeft1:Show()
	HunterPetsOwnedTooltipTextLeft2:SetText(text2)
	HunterPetsOwnedTooltipTextLeft2:Show()
	if (displayId) then
		HunterPetsOwnedTooltip:SetHeight(225)
		HunterPetsOwnedTooltip.ModelFrame:SetDisplayInfo(displayId)
		HunterPetsOwnedTooltip.ModelFrame:Show()
	else
		HunterPetsOwnedTooltip:SetHeight(50)
		HunterPetsOwnedTooltip.ModelFrame:Hide()

	end
end

function HunterPetsOwned_CheckIfTracked(name)
	if not HunterPetsGlobal[selectedCharacter]["TrackedIds"] then
		return
	end

	for k in pairs(HunterPetsGlobal[selectedCharacter]["TrackedIds"]) do
		local data = HunterPetsGlobal[selectedCharacter]["TrackedIds"][k]
		local npc_id, trackedname, displayId = strsplit(":", data)
		if trackedname == name then
			return true
		end
	end
	return false
end