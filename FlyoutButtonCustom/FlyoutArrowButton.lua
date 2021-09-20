--[[ FlyoutArrowButton ]]

local ARROW_BUTTON_DEF_WIDTH = 36
local ACCEPTABLE_COMMANDS = {
	["spell"] = true,
	["item"] = true,
	["macro"] = true,
	["companion"] = true,
	["macrotext"] = true,
	["equipmentset"] = true,
	["battlepet"] = true,
}
FlyoutArrowButton = {}
local MovedFlyoutArrowButton = nil


local ArrowButtonOnClickSnippet = [=[
	local B_PLACE_SIZE = 36
	local B_PLACE_OFFSET = 4

	local D_UP		= 1
	local D_LEFT	= 2
	local D_DOWN	= 3
	local D_RIGHT	= 4

	if button == "LeftButton" then
		local lfRef = self:GetFrameRef("FlyoutListFrame_Ref")
		
		local width = B_PLACE_SIZE + 2 * B_PLACE_OFFSET
		local height = self:GetAttribute("bcount") * (B_PLACE_SIZE + B_PLACE_OFFSET) + B_PLACE_OFFSET
		
		if self:GetAttribute("expandDir") == D_UP or self:GetAttribute("expandDir") == D_DOWN then
			lfRef:SetWidth(width)
			lfRef:SetHeight(height)
		else
			lfRef:SetWidth(height)
			lfRef:SetHeight(width)
		end

		if self:GetAttribute("expanded") then
			self:SetAttribute("expanded", false)
			lfRef:Hide()
		else
			--close other opened lists
			local stub = self:GetFrameRef("StubFrame")
			if stub and stub:GetAttribute("unique-list") then
				local count = stub:GetAttribute("ArrowButtonsCount")
				if count then
					for i = 1, count do
						local ab = stub:GetFrameRef("FbcArrowButtons"..i)
						if ab and ab:GetAttribute("expanded") then
							local lf = ab:GetFrameRef("FlyoutListFrame_Ref")
							if lf then
								ab:SetAttribute("expanded", false)
								lf:Hide()
							end
						end
					end
				end
			end
			
			self:SetAttribute("expanded", true)
			lfRef:Show()
		end
	end
]=]

local ArrowButtonOnEnterSnippet = [=[
	if not(self:GetAttribute("onmouseoverenabled")) then
		return
	end
	if not(self:GetAttribute("mouseoverincombat")) and (self:GetAttribute("incombat") > 0) then
		return
	end
	
	local B_PLACE_SIZE = 36
	local B_PLACE_OFFSET = 4

	local D_UP		= 1
	local D_LEFT	= 2
	local D_DOWN	= 3
	local D_RIGHT	= 4

	local lfRef = self:GetFrameRef("FlyoutListFrame_Ref")
	
	local width = B_PLACE_SIZE + 2 * B_PLACE_OFFSET
	local height = self:GetAttribute("bcount") * (B_PLACE_SIZE + B_PLACE_OFFSET) + B_PLACE_OFFSET
	
	if self:GetAttribute("expandDir") == D_UP or self:GetAttribute("expandDir") == D_DOWN then
		lfRef:SetWidth(width)
		lfRef:SetHeight(height)
	else
		lfRef:SetWidth(height)
		lfRef:SetHeight(width)
	end

	if self:GetAttribute("expanded") then
		self:SetAttribute("expanded", false)
		lfRef:Hide()
	else
		--close other opened lists
		local stub = self:GetFrameRef("StubFrame")
		if stub and stub:GetAttribute("unique-list") then
			local count = stub:GetAttribute("ArrowButtonsCount")
			if count then
				for i = 1, count do
					local ab = stub:GetFrameRef("FbcArrowButtons"..i)
					if ab and ab:GetAttribute("expanded") then
						local lf = ab:GetFrameRef("FlyoutListFrame_Ref")
						if lf then
							ab:SetAttribute("expanded", false)
							lf:Hide()
						end
					end
				end
			end
		end
		
		self:SetAttribute("expanded", true)
		lfRef:Show()
	end
]=]

local ArrowButtonCombatSnippet = [=[
	if newstate == 1 and self:GetAttribute("bcount") == 0 and self:IsVisible() then
		self:SetAttribute("expanded", false)
		self:Hide()
	end
	self:SetAttribute("incombat", newstate)
]=]

local ArrowButtonVehicleSnippet = [=[
	if newstate == 1 and self:IsVisible() then
		self:SetAttribute("was_visible_vehicle", true)
		self:SetAttribute("expanded", false)
		self:Hide()
	elseif self:GetAttribute("was_visible_vehicle") then
		self:SetAttribute("was_visible_vehicle", false)
		self:SetAttribute("expanded", true)
		self:Show()
	end
]=]

function FlyoutArrowButton:SetTextureRotation(expandDir, expanded)
	if expanded then
		if expandDir == FBC_DIR_UP then
			SetClampedTextureRotation(self.FlyoutArrow, 180)
		elseif expandDir == FBC_DIR_LEFT then
			SetClampedTextureRotation(self.FlyoutArrow, 90)
		elseif expandDir == FBC_DIR_DOWN then
			SetClampedTextureRotation(self.FlyoutArrow, 0)
		else --if expandDir == FBC_DIR_RIGHT then
			SetClampedTextureRotation(self.FlyoutArrow, 270)
		end
	else
		if expandDir == FBC_DIR_UP then
			SetClampedTextureRotation(self.FlyoutArrow, 0)
		elseif expandDir == FBC_DIR_LEFT then
			SetClampedTextureRotation(self.FlyoutArrow, 270)
		elseif expandDir == FBC_DIR_DOWN then
			SetClampedTextureRotation(self.FlyoutArrow, 180)
		else --if expandDir == FBC_DIR_RIGHT then
			SetClampedTextureRotation(self.FlyoutArrow, 90)
		end
	end
end

function FlyoutArrowButton:SetFrameSize(expandDir)
	if expandDir == FBC_DIR_UP or expandDir == FBC_DIR_DOWN then
		self:SetWidth(ARROW_BUTTON_DEF_WIDTH)
		self:SetHeight(FbcArrowButtonsHeight)
	else
		self:SetWidth(FbcArrowButtonsHeight)
		self:SetHeight(ARROW_BUTTON_DEF_WIDTH)
	end
end

function FlyoutArrowButton:SetAnchor(parent, expandDir)
	self:ClearAllPoints()
	self.FlyoutArrow:ClearAllPoints()
	if expandDir == FBC_DIR_UP then
		self:SetPoint("TOP", parent, "TOP", 0, FBC_ARROW_OFFSET)
		self.FlyoutArrow:SetPoint("TOP")
	elseif expandDir == FBC_DIR_LEFT then
		self:SetPoint("LEFT", parent, "LEFT", -FBC_ARROW_OFFSET, 0)
		self.FlyoutArrow:SetPoint("LEFT")
	elseif expandDir == FBC_DIR_DOWN then
		self:SetPoint("BOTTOM", parent, "BOTTOM", 0, -FBC_ARROW_OFFSET)
		self.FlyoutArrow:SetPoint("BOTTOM")
	else
		self:SetPoint("RIGHT", parent, "RIGHT", FBC_ARROW_OFFSET, 0)
		self.FlyoutArrow:SetPoint("RIGHT")
	end
end

function FlyoutArrowButton:SetHighlight(value)
	if value then
		self:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight", "ADD")
	else
		self:SetHighlightTexture("")
	end
end

function FlyoutArrowButton_New(parent)
	parent.customFlyout = true
	local actnBtnName = parent:GetName()
	local tempFrame = _G[actnBtnName.."ArrowBtn"]

	local arrowBtn
	if tempFrame then
		FbcArrowButtons[actnBtnName] = tempFrame --reuse frame
		arrowBtn = FbcArrowButtons[actnBtnName]
	else
		FbcArrowButtons[actnBtnName] = CreateFrame("CheckButton", actnBtnName.."ArrowBtn", parent, "CustomFlyoutArrowButtonTemplate")
		arrowBtn = FbcArrowButtons[actnBtnName]
		
		-- adding methods to arrow button
		for k, v in pairs(FlyoutArrowButton) do
			if type(v) == "function" then
				arrowBtn[k] = v
			end
		end
		
		--set reference in stub
		local count = FbcStubFrame:GetAttribute("ArrowButtonsCount")
		if not(count) then
			count = 1
		else
			count = count + 1
		end
		FbcStubFrame:SetAttribute("ArrowButtonsCount", count)
		FbcStubFrame:SetFrameRef("FbcArrowButtons"..count, arrowBtn)
		arrowBtn:SetFrameRef("StubFrame", FbcStubFrame)
		arrowBtn:SetHighlight(FbcHighlight)
	
		SecureHandlerWrapScript(arrowBtn, "OnEnter", arrowBtn, ArrowButtonOnEnterSnippet)
		RegisterStateDriver(arrowBtn, "combat", "[nocombat] 0; [combat] 1;")
		RegisterStateDriver(arrowBtn, "vehicle", "[novehicleui] 0; [vehicleui] 1;")
	end
	--arrowBtn:SetFrameLevel(arrowBtn:GetParent():GetFrameLevel() + 1)

	if not(arrowBtn.FlyoutListFrame) then
		arrowBtn.FlyoutListFrame = FlyoutListFrame_New(arrowBtn)
		arrowBtn:SetFrameRef("FlyoutListFrame_Ref", arrowBtn.FlyoutListFrame)
	end

	arrowBtn:SetAttribute("mouseoverincombat", FbcEnableMouseoverInCombat)
	arrowBtn:SetAttribute("incombat", 0)

	arrowBtn:SetAttribute("_onclick", ArrowButtonOnClickSnippet)
	if FbcEnableMouseover then
		arrowBtn:SetAttribute("onmouseoverenabled", true)
	else
		arrowBtn:SetAttribute("onmouseoverenabled", false)
	end
	arrowBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	--self, stateid, newstate
	arrowBtn:SetAttribute("_onstate-combat", ArrowButtonCombatSnippet)

	arrowBtn:SetAttribute("_onstate-vehicle", ArrowButtonVehicleSnippet)
	-- same for posession ?
	
	arrowBtn:SetMovable(FbcArrowBtnMovable)
	arrowBtn:RegisterForDrag("LeftButton")
	return arrowBtn
end

function GetFlyoutArrowButton(frame)
	if not(frame) or (frame:GetName() == "") then
		return nil
	end
	
	return FbcArrowButtons[frame:GetName()]
end

function FlyoutArrowButton_Attach(frame)
	if not(frame) or frame:GetName() == "" or InCombatLockdown() then
		if (frame.action and GetActionInfo(frame.action) == "flyout") or (frame._state_action and GetActionInfo(frame._state_action) == "flyout") then
			return
		end
	end
	
	local actnBtnName = frame:GetName()
	local currentSet = FlyoutButton_GetSpecialization()
	local expandDir = FBC_DIR_UP

	local arrowBtn = GetFlyoutArrowButton(frame)	
	if not(arrowBtn) then --create new
		arrowBtn = FlyoutArrowButton_New(frame)
	end
	
	if (frame:GetParent() == MultiBarRight or frame:GetParent() == MultiBarLeft) then
		expandDir = FlyoutButtonES:Get({"expandDir", currentSet, actnBtnName}, FBC_DIR_LEFT)
		--expandDir = FlyoutButtonES:Get("expandDir."..currentSet.."."..actnBtnName, FBC_DIR_LEFT)
	else
		expandDir = FlyoutButtonES:Get({"expandDir", currentSet, actnBtnName}, FBC_DIR_UP)
		--expandDir = FlyoutButtonES:Get("expandDir."..currentSet.."."..actnBtnName, FBC_DIR_UP)
	end
	arrowBtn:SetAnchor(frame, expandDir)
	arrowBtn:SetAttribute("expandDir", expandDir)
	
	local flf = arrowBtn.FlyoutListFrame
	flf:SetAnchor(arrowBtn, expandDir)

	local temp = FlyoutButtonES:Get({actnBtnName, currentSet}, nil)
	if (temp) and (type(temp) == "table") then
		for i, v in ipairs(temp) do
			local btn = FlyoutListButton_AttachToList(flf, i, expandDir)
			--print("FlyoutArrowButton_Attach", v.command, v.value, v.subValue, v.id)
			if ACCEPTABLE_COMMANDS[v.command] then
				if (v.command == "spell") then
					if not(v.value) then
						print(tostring(v.command).." "..tostring(v.subValue).." removed")
						btn:SaveCommand(nil, nil, nil, nil)
						btn:Set(nil, nil, nil, nil)
						btn:SetKey(nil)
					else
						if not(v.id) then
							--fix broken spells
							v.id = FlyoutButton_FindSpellId(v.value)
							--print(tostring(v.value).." fixed id="..tostring(v.id))
						end
						btn:Set(v.command, v.value, v.subValue, v.id)
						btn:SetKey(v.keybind)
					end
				else
					if not(v.value) then
						print(tostring(v.command).." "..tostring(v.subValue).." removed")
						btn:SaveCommand(nil, nil, nil, nil)
						btn:Set(nil, nil, nil, nil)
						btn:SetKey(nil)
					else
						btn:Set(v.command, v.value, v.subValue, v.id, v.macroValues)
						btn:SetKey(v.keybind)
					end
				end
			else
				btn:Set(nil, nil, nil, nil)
				btn:SetKey(nil)
			end
		end
		--in case some removed
		local count = FlyoutButton_GetListButtonsCount(temp)
		arrowBtn:SetAttribute("bcount", count)

		arrowBtn:Show()
		arrowBtn:SetAlpha(1)
		arrowBtn.FlyoutArrow:Show()
	else
		arrowBtn:SetAttribute("bcount", 0)
		arrowBtn:Hide()
	end
	flf:SetScale(FbcButtonsScale)
	
	hooksecurefunc(frame.icon, "SetTexture", FlyoutArrowButton_SetActionButtonTexture)

	arrowBtn:SetFrameSize(expandDir)
	
	arrowBtn:SetAttribute("expanded", false)
	arrowBtn:SetTextureRotation(expandDir, false)
end

function FlyoutArrowButton_SetActionButtonTexture(icon)
	if not(FbcLeftClickSet) or icon.settingOurOwnSetTexture then
		return -- we triggered this SetTexture, ignore
	else
		local actionButton = icon:GetParent()
		local actBtnName = actionButton:GetName()
		if actBtnName and not(actBtnName:match("^ButtonForge%d+$")) then
			local attr_type = actionButton:GetAttribute("type")
			local attr_value = actionButton:GetAttribute(attr_type)
			local texture
			-- get a texture from the action button's attributes
			if attr_type == "item" then
				texture = select(10, GetItemInfo(attr_value))
			elseif attr_type == "spell" then
				texture = GetSpellTexture(attr_value)
			end
			if texture and icon:GetTexture() ~= texture then
				icon.settingOurOwnSetTexture = 1
				icon:SetTexture(texture)
				icon.settingOurOwnSetTexture = nil
			end
		end
	end
end

function FlyoutArrowButton:ShowArrow()
	if InCombatLockdown() then
		return
	end
	
	self:SetTextureRotation(self:GetAttribute("expandDir"), self:GetAttribute("expanded"))
	
	self:Show()
	self.FlyoutArrow:Show()
	if (self:GetAttribute("bcount") > 0) then
		self:SetAlpha(1)
	else
		self:SetAlpha(0.5)
	end
end

function FlyoutArrowButton:HideArrow()
	if InCombatLockdown() then
		return
	end
	
	if (self:GetAttribute("bcount") > 0) then
		self:SetAlpha(1)
	else
		self:SetAttribute("expanded", false)
		self.FlyoutListFrame:Hide()
		self.FlyoutArrow:Hide()
		self:Hide()
	end
end

function FlyoutArrowButton:UpdateArrow()
	if InCombatLockdown() or not(self:GetParent().customFlyout) then
		return
	end
	
	local currentSet = FlyoutButton_GetSpecialization()
	local actnBtnName = self:GetParent():GetName()
	local flf = self.FlyoutListFrame
	
	--move buttons to lower slots	
	for i = 1, #flf.ButtonList do
		if not(flf.ButtonList[i].command) then
			for j = i + 1, #flf.ButtonList do
				if flf.ButtonList[j].command then
					--move button
					flf.ButtonList[i]:Set(flf.ButtonList[j].command, flf.ButtonList[j].value, flf.ButtonList[j].subValue, flf.ButtonList[j].id)
					flf.ButtonList[i]:SaveCommand(flf.ButtonList[j].command, flf.ButtonList[j].value, flf.ButtonList[j].subValue, flf.ButtonList[j].id)
					flf.ButtonList[j]:Set(nil, nil, nil, nil)
					flf.ButtonList[j]:SaveCommand(nil, nil, nil, nil)
					break
				end
			end
		end
	end
	
	--get count to show
	local count, settingsCount = FlyoutButton_GetListButtonsCount(FlyoutButtonES:Get({actnBtnName, currentSet}, nil))
	self:SetAttribute("bcount", count)
	self.FlyoutListFrame:SetAttribute("bcount", count)
	flf:SetSize(self:GetAttribute("expandDir"), settingsCount)
	
	--hide empty
	for i, v in ipairs(flf.ButtonList) do
		if not(v.command) then
			if FbcSettingsMode then
				if i > count then
					v:HideButton()
				end
			else
				v:HideButton()
			end
		end
		v:SetAnchor(flf, i, self:GetAttribute("expandDir"))
	end
	
	--add empty button at top
	if FbcSettingsMode then
		for i = count + 1, settingsCount do
			local btn = FlyoutListButton_AttachToList(flf, i, self:GetAttribute("expandDir"))
			btn:Set(nil, nil, nil, nil)
		end
	end
end

function FlyoutArrowButton:PostClick(button)
	if not(InCombatLockdown()) then
		if button == "LeftButton" then
			if FbcSettingsMode then
				self:UpdateArrow()
			else
				--cleanup
				for i, v in ipairs(self.FlyoutListFrame.ButtonList) do
					if v.command then
						v:Show()
					else
						v:HideButton()
					end
				end
				self.FlyoutListFrame:SetSize(self:GetAttribute("expandDir"), self:GetAttribute("bcount"))
			end
		elseif button == "RightButton" and not(FbcArrowBtnDirLocked) then
			local expandDir = self:GetAttribute("expandDir")
			expandDir = expandDir + 1
			if expandDir > FBC_DIR_RIGHT then
				expandDir = FBC_DIR_UP
			end

			FlyoutButtonES:Set({"expandDir", FlyoutButton_GetSpecialization(), self:GetParent():GetName()}, expandDir)

			self:SetAnchor(self:GetParent(), expandDir)
			self:SetFrameSize(expandDir)
			self:SetTextureRotation(expandDir, self:GetAttribute("expanded"))
			self:SetAttribute("expandDir", expandDir)

			self.FlyoutListFrame:SetAnchor(self, expandDir)
			self:UpdateArrow()
		end
	end
end

local function deepcopy(object)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

function FlyoutArrowButton:OnDragStart()
	if not(FbcSettingsMode) or not(FbcArrowBtnMovable) then
		return
	end
	
	local found = false
	-- set temp storage of what dragged
	MovedFlyoutArrowButton = self --deepcopy()
	-- get first available button and put into cursor
	local bcount = self:GetAttribute("bcount")
	local lf = self.FlyoutListFrame
	if bcount > 0 and lf then
		local bl = lf.ButtonList
		for i = 1, #bl do
			if (bl[i].command) then
				if not(found) then
					-- pickup first available icon
					-- print "moving"
					print("要移動箭頭按鈕，請將它拖曳到另一個箭頭按鈕上。")
					FlyoutButton_SetCursor(bl[i].command, bl[i].value, bl[i].subValue, bl[i].id)
				end
				found = true
				break
			end
		end
		self:UpdateArrow()
	end
	
	if not(found) then
		-- else set it to nil
		MovedFlyoutArrowButton = nil
	end
end

function FlyoutArrowButton:OnReceiveDrag()
	local command, value, subValue, id = FlyoutButton_GetCursorValues()
	if not(FbcSettingsMode) or not(MovedFlyoutArrowButton) or not(command) then
		MovedFlyoutArrowButton = nil
		return
	end
	
	local pbcount = MovedFlyoutArrowButton:GetAttribute("bcount")
	local sbcount = self:GetAttribute("bcount")
	local plf = MovedFlyoutArrowButton.FlyoutListFrame
	local slf = self.FlyoutListFrame
	local expandDir = self:GetAttribute("expandDir")
	
	if pbcount > 0 and plf then
		local bl = plf.ButtonList
		local p = 1
		for i = 1, #bl do
			command, value, subValue, id = bl[i].command, bl[i].value, bl[i].subValue, bl[i].id
			if ACCEPTABLE_COMMANDS[command] then
				local btn = FlyoutListButton_AttachToList(slf, sbcount + p, expandDir)
				btn:Set(command, value, subValue, id)
				btn:SetKey(bl[i].keybind)
				btn:SaveCommand(command, value, subValue, id)
				p = p + 1
			end
			bl[i]:Set(nil, nil, nil, nil)
			bl[i]:SetKey(nil)
			bl[i]:SaveCommand(nil, nil, nil, nil)
		end
		self:SetAttribute("bcount", FlyoutButton_GetListButtonsCount(slf.ButtonList))
		self:Show()
		self:SetAlpha(1)
		self.FlyoutArrow:Show()
	end
	MovedFlyoutArrowButton:UpdateArrow()
	MovedFlyoutArrowButton = nil
	ClearCursor()
	self.FlyoutListFrame:Show()
end

function FlyoutArrowButton:OnEnter()
	if not(FbcSettingsMode) or not(MovedFlyoutArrowButton) then
		return
	end
	local command, value, subValue = FlyoutButton_GetCursorValues()
	if not(command) then
		MovedFlyoutArrowButton = nil
		return
	end
	
	self:SetAttribute("expanded", true)
	self:PostClick("LeftButton")
	self.FlyoutListFrame:Show()
	self:ShowArrow()
end

function FlyoutArrowButton:OnLeave()
	if not(FbcSettingsMode) or not(MovedFlyoutArrowButton) then
		return
	end
	
	self:SetAttribute("expanded", false)
	self:PostClick("LeftButton")
	self.FlyoutListFrame:Hide()
	self:ShowArrow()
end