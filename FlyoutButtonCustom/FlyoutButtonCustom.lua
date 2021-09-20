--[[
	Author: another
	
	Custom flyout buttons support
]]
	
local ARROW_BUTTON_DEF_HEIGHT, ARROW_BUTTON_MIN_HEIGHT, ARROW_BUTTON_MAX_HEIGHT = 15, 5, 36
local BUTTON_MIN_SCALE, BUTTON_MAX_SCALE, BUTTON_SCALE_STEP = 0.1, 3, 0.1
local BF_SETTINGS_GROUP = "Button Facade"


--variables
local AddonName, AddonTable = ...
FbcButtonFrames = {}
FbcArrowButtons = {}

-- variables
FbcSettingsMode = nil
FbcKeybindMode = nil
FbcArrowButtonsHeight = nil
FbcButtonsScale = nil
FbcShowBorders = nil
FbcEnableMouseover = nil
FbcEnableMouseoverInCombat = nil
FbcHideOnClick = nil
FbcHighlight = nil
FbcRightClickSelfCast = nil
FbcLeftClickSet = nil
FbcRightClickSet = nil
FbcArrowBtnMovable = nil
FbcUseShift = nil
FbcSeparateSpecs = nil
FbcEnteredSettingsMode = 0
FbcStubFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerBaseTemplate")

local EventHandlersTable = {}
local EnteringWorldOrVariablesLoaded = 0
local UpdateMacroCount = 0
--Masque stuff
local LBF
FBC_MasqueMasterGroup = nil

local FbcSettingsWindow
local FBC_SETTINGS_CHECKBOX, FBC_SETTINGS_SLIDER = 1, 2
local customizeFrame, iconSelectionDialogPopupFrame
local isInit = false


--[[structures
ActionButton
	- customFlyout
	ArrowBtn
		- FlyoutArrow		
		- expandDir: up, left, down, right
		- expanded
	
		- FlyoutListFrame	--also through SetFrameRef
			- ButtonList
]]

local function RegisterFrames()
	FbcButtonFrames = {}
	local frame = EnumerateFrames()
	while frame do
		local fname = frame:GetName()
		if fname and frame.IsProtected and frame:IsProtected() --exists and true
		and frame.GetObjectType and frame.GetScript and 
		frame:GetObjectType() == "CheckButton" then
			--print("frame is button", frame:GetName())
			if fname:match("^ElvUI_Bar%dButton%d+$") then
				tinsert(FbcButtonFrames, frame)
			elseif fname:match("^BT4Button%d+$") then
				tinsert(FbcButtonFrames, frame)
			elseif fname:match("^TinyExtraBarsContainerFrame%dButtonFrame%dButton%d_%d+$") then
				tinsert(FbcButtonFrames, frame)
			elseif fname:match("^ButtonForge%d+$") then
				tinsert(FbcButtonFrames, frame)
			elseif frame.action and (frame.action < 120) then
				if fname:match("^ActionButton%d+$") 
				or fname:match("^MultiBarBottomLeftButton%d+$") or fname:match("^MultiBarBottomRightButton%d+$") 
				or fname:match("^MultiBarLeftButton%d+$") or fname:match("^MultiBarRightButton%d+$") then
					tinsert(FbcButtonFrames, frame)
				end
			end
		end
		frame = EnumerateFrames(frame)
	end
end

local function AttachToAllActionButtons()
	for _, frame in ipairs(FbcButtonFrames) do
		if frame.action or frame._state_action then
			FlyoutArrowButton_Attach(frame)
		end
	end
end

local function ShowAllFlyoutButtons()
	for _, frame in ipairs(FbcButtonFrames) do
		if frame.action or frame._state_action then
			local arrowBtn = FbcArrowButtons[frame:GetName()]
			if arrowBtn then 
				arrowBtn:ShowArrow()
			end
		end
	end
end

local function HideUnusedFlyoutButtons()
	for _, frame in ipairs(FbcButtonFrames) do
		if frame.action or frame._state_action then
			local arrowBtn = FbcArrowButtons[frame:GetName()]
			if arrowBtn then 
				arrowBtn:UpdateArrow()
				arrowBtn:HideArrow()
			end
		end
	end
end

local function HideFlyoutFrames()
	for _, frame in ipairs(FbcButtonFrames) do
		if frame.action or frame._state_action then
			if frame and not(InCombatLockdown()) then
				local arrowBtn = FbcArrowButtons[frame:GetName()]
				if (arrowBtn) then 
					arrowBtn:SetAttribute("expanded", false)
					arrowBtn.FlyoutListFrame:Hide()
				end
			end
		end
	end
end

local function SetButtonsConfigure(value)
	for _, arrowBtn in pairs(FbcArrowButtons) do
		for _, btn in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			if value then
				btn.configure:Show()
			else
				btn.configure:Hide()
			end
		end
	end
end


-- MacroText

local customizableButton

local function FlyoutButtonCustom_MacroTextCustomizeFrame_OkClick(self)
	local frame = self:GetParent()
	local macroText = frame.ScrollMacro.EditBoxMacro:GetText()
	local iconSpellName = frame.EditBoxIcon:GetText()
	local tooltip = frame.ScrollTooltip.EditBoxTooltip:GetText()
	--set button
	if customizableButton then
		if macroText and macroText ~= "" then
			local command, value, id = "macrotext", macroText, tooltip
			local t = {}
			t.texture = customizeFrame.spellIcon.icon:GetTexture()
			t.textureIsCustom = customizeFrame.macroTextTextureIsCustom
			t.value = iconSpellName -- spell name or item hint
			
			subValue = customizeFrame.macroTextCommandType
			if customizeFrame.macroTextCommandType == "spell" then
				t.id = customizeFrame.macroTextSpellID
			elseif customizeFrame.macroTextCommandType == "item" then
				t.id = customizeFrame.macroTextItemID
			else
				t.id = nil
			end
			
			customizableButton:Set(command, value, subValue, id, t)
			customizableButton:SaveCommand(command, value, subValue, id, t)
		else
			customizableButton:Set(nil, nil, nil, nil)
			customizableButton:SaveCommand(nil, nil, nil, nil)
		end
	end
	frame:Hide()
end

function FlyoutButtonCustom_MacroTextCustomizeFrame_Toogle(btn)
	if InCombatLockdown() then
		return
	end
	
	if customizeFrame:IsVisible() then
		customizeFrame:Hide()
	else
		--[[customizeFrame.macroTextCommandType = nil
		customizeFrame.macroTextItemID = nil
		customizeFrame.macroTextSpellID = nil
		customizeFrame.macroTextTextureIsCustom = nil]]
		
		customizeFrame:Show()

		--SetText
		local command, value, subValue, id = btn.command, btn.value, btn.subValue, btn.id
		
		customizeFrame.CommandType:SetText("")
		
		if command == "macrotext" and value then
			customizeFrame.ScrollMacro.EditBoxMacro:SetText(value)
		else
			customizeFrame.ScrollMacro.EditBoxMacro:SetText("")
		end
		if command == "macrotext" then
			local t = btn.macroValues
			local texture
			if t and type(t) == "table" then 
				customizeFrame.macroTextTextureIsCustom = t.textureIsCustom
				if customizeFrame.macroTextTextureIsCustom then
					texture = t.texture
				else
					if subValue == "spell" then
						texture = GetSpellTexture(t.value)
					elseif subValue == "item" then
						texture = GetItemIcon(t.value)
					end
				end
			end
			--set spell/item text
			if subValue == "spell" then
				customizeFrame.CommandType:SetText("spell")
			elseif subValue == "item" then
				customizeFrame.CommandType:SetText("item")
			else
				customizeFrame.CommandType:SetText("")
			end
			if t.value then
				customizeFrame.EditBoxIcon:SetText(t.value)
			else
				customizeFrame.EditBoxIcon:SetText("")
			end
			customizeFrame.spellIcon.icon:SetTexture(texture)
		else
			customizeFrame.EditBoxIcon:SetText("")
			customizeFrame.spellIcon.icon:SetTexture(nil)
		end
		if command == "macrotext" and id then
			customizeFrame.ScrollTooltip.EditBoxTooltip:SetText(id)
		else
			customizeFrame.ScrollTooltip.EditBoxTooltip:SetText("")
		end
		customizableButton = btn
		
		-- handler
		customizeFrame.OK:SetScript("OnClick", FlyoutButtonCustom_MacroTextCustomizeFrame_OkClick)
	end
end


--[[ events stuff ]]

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
EventFrame:RegisterEvent("VARIABLES_LOADED")
EventFrame:RegisterEvent("UPDATE_MACROS")
EventFrame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")

function EventFrame:LIBKEYBOUND_ENABLED()
	FbcKeybindMode = true
end

function EventFrame:LIBKEYBOUND_DISABLED()
	FbcKeybindMode = nil
end

function EventFrame:LIBKEYBOUND_MODE_COLOR_CHANGED()
	print("顏色已變更")
end


--event handlers

local function EventEnteringCombat(self, ...)
	FbcSettingsMode = false
	FbcEnteredSettingsMode = 0
end

local function EventTalentGroupChanged(self, ...)
	--FlyoutButton_CacheSpells()
	if InCombatLockdown() then
		return
	end
		
	for _, arrowBtn in pairs(FbcArrowButtons) do
		for i, v in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			v:Set(nil, nil, nil, nil)
		end
	end

	HideFlyoutFrames()
	FbcArrowButtons = {}
	RegisterFrames()
	AttachToAllActionButtons()
end

local function ModifierStateChanged(self, key, state)
	--print(key, state)
	if InCombatLockdown() or not(FbcUseShift) then
		return
	end
	
	if ((key == "LSHIFT") or (key == "RSHIFT")) and (state ~= 0) then
		FlyoutButtonCustom_SettingsIncCounter()
	else
		FlyoutButtonCustom_SettingsDecCounter()
	end
end

local function RegisterEvents()
	--event table
	EventHandlersTable = {
		--common
		["PLAYER_REGEN_DISABLED"] 			= EventEnteringCombat,
		["PLAYER_SPECIALIZATION_CHANGED"]	= EventTalentGroupChanged,
		--["SPELLS_CHANGED"] 					= EventSpellsChanged,
		["MODIFIER_STATE_CHANGED"] 			= ModifierStateChanged,
		--["COMPANION_LEARNED"]				= EventCompanionChanged,
		--["COMPANION_UNLEARNED"]				= EventCompanionChanged,
		--["COMPANION_UPDATE"]				= EventCompanionChanged,
		--["MOUNT_JOURNAL_USABILITY_CHANGED"]	= EventCompanionChanged,
	}
	
	for k, _ in pairs(EventHandlersTable) do
		EventFrame:RegisterEvent(k)
	end
end


--[[ slash handlers ]]

local function SlashTable_border(rest)
	FbcShowBorders = not(FbcShowBorders)
	FlyoutButtonES:Set({"ShowBorders"}, FbcShowBorders)
	print("ShowBorders = "..tostring(FbcShowBorders))

	for _, arrowBtn in pairs(FbcArrowButtons) do
		local flf = arrowBtn.FlyoutListFrame
		for i, v in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			if v.command then
				v:UpdateTexture()
			end
		end
	end
end

local function SlashTable_hide(rest)
	FbcHideOnClick = not(FbcHideOnClick)
	FlyoutButtonES:Set({"HideOnClick"}, FbcHideOnClick)
	print("HideOnClick = "..tostring(FbcHideOnClick))

	for _, arrowBtn in pairs(FbcArrowButtons) do
		for _, v in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			v:SetClickHandler(FbcHideOnClick, FbcLeftClickSet)
		end
	end
end

local function SlashTable_highlight(rest)
	FbcHighlight = not(FbcHighlight)
	FlyoutButtonES:Set({"Highlight"}, FbcHighlight)
	print("Highlight = "..tostring(FbcHighlight))

	for _, arrowBtn in pairs(FbcArrowButtons) do
		arrowBtn:SetHighlight(FbcHighlight)
	end
end

local function SlashTable_height(rest)
	if rest ~= "" then
		local temp = tonumber(rest)
		if not(temp) or (temp < ARROW_BUTTON_MIN_HEIGHT) or (temp > ARROW_BUTTON_MAX_HEIGHT) then
			print("新的高度數值 '"..rest.."' 超出有效範圍 "..ARROW_BUTTON_MIN_HEIGHT.."-"..ARROW_BUTTON_MAX_HEIGHT)
		else
			FbcArrowButtonsHeight = temp
			FlyoutButtonES:Set({"ArrowButtonsHeight"}, FbcArrowButtonsHeight)
			
			for _, arrowBtn in pairs(FbcArrowButtons) do
				arrowBtn:SetFrameSize(arrowBtn:GetAttribute("expandDir"))
			end
		end
	end
end

local function SlashTable_scale(rest)
	if rest ~= "" then
		local temp = tonumber(rest)
		if not(temp) or (temp < BUTTON_MIN_SCALE) or (temp > BUTTON_MAX_SCALE) then
			print("新的縮放數值 '"..rest.."' 超出有效範圍 "..ARROW_BUTTON_MIN_HEIGHT.."-"..ARROW_BUTTON_MAX_HEIGHT)
		else
			FbcButtonsScale = temp
			FlyoutButtonES:Set({"ButtonsScale"}, FbcButtonsScale)
			
			for _, arrowBtn in pairs(FbcArrowButtons) do
				-- set buttons scales through parent frame
				arrowBtn.FlyoutListFrame:SetScale(FbcButtonsScale)
			end
		end
	end
end

local function SlashTable_keybind(rest)
	FbcLibKeyBound:Toggle()
end

local function SlashTable_mouseover(rest)
	if InCombatLockdown() then
		print("戰鬥中無法切換滑鼠指向功能")
		return
	end
	
	FbcEnableMouseover = not(FbcEnableMouseover)
	FlyoutButtonES:Set({"EnableMouseover"}, FbcEnableMouseover)
	print("EnableMouseover = "..tostring(FbcEnableMouseover))
	for _, arrowBtn in pairs(FbcArrowButtons) do
		if FbcEnableMouseover then
			arrowBtn:SetAttribute("onmouseoverenabled", true)
		else
			arrowBtn:SetAttribute("onmouseoverenabled", false)
		end
	end
end

local function SlashTable_mouseoverincombat(rest)
	if InCombatLockdown() then
		print("戰鬥中無法切換滑鼠指向功能")
		return
	end
	
	FbcEnableMouseoverInCombat = not(FbcEnableMouseoverInCombat)
	FlyoutButtonES:Set({"EnableMouseoverInCombat"}, FbcEnableMouseoverInCombat)
	print("EnableMouseoverInCombat = "..tostring(FbcEnableMouseoverInCombat))
	for _, arrowBtn in pairs(FbcArrowButtons) do
		arrowBtn:SetAttribute("mouseoverincombat", FbcEnableMouseoverInCombat)
	end
end

local function EnterSettingsMode(force)
	FbcEnteredSettingsMode = FbcEnteredSettingsMode + 1
	if not(FbcSettingsMode) or force then
		FbcSettingsMode = true
		EventTalentGroupChanged()
		ShowAllFlyoutButtons()
		SetButtonsConfigure(true)
	end
end

local function LeaveSettingsMode(force)
	FbcEnteredSettingsMode = FbcEnteredSettingsMode - 1
	if FbcEnteredSettingsMode <= 0 or force then
		FbcEnteredSettingsMode = 0
		FbcSettingsMode = false
		HideUnusedFlyoutButtons()
		SetButtonsConfigure(false)
	end
end

local function SlashTable_settings(rest)
	if InCombatLockdown() then
		print("戰鬥中無法進入設定模式")
		return
	end
	
	FbcSettingsMode = not(FbcSettingsMode)
	print("SettingsMode = "..tostring(FbcSettingsMode))
	if FbcSettingsMode then
		EnterSettingsMode(true)
	else
		LeaveSettingsMode(true)
	end
end

local function SlashTable_unique(rest)
	if InCombatLockdown() then
		print("戰鬥中無法設定單一顯示")
		return
	end
	
	FbcStubFrame:SetAttribute("unique-list", not(FbcStubFrame:GetAttribute("unique-list")))
	FlyoutButtonES:Set({"UniqueList"}, FbcStubFrame:GetAttribute("unique-list"))
	print("unique list = "..tostring(FbcStubFrame:GetAttribute("unique-list")))
end

local function SlashTable_rightClickSelfCast(rest)
	FbcRightClickSelfCast = not(FbcRightClickSelfCast)
	FlyoutButtonES:Set({"RightClickSelfCast"}, FbcRightClickSelfCast)
	print("right-click self cast = "..tostring(FbcRightClickSelfCast))

	for _, arrowBtn in pairs(FbcArrowButtons) do
		for _, v in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			v:SetRightClickSelfCast(FbcRightClickSelfCast)
		end
	end
end

local function SlashTable_leftClickSet(rest)
	FbcLeftClickSet = not(FbcLeftClickSet)
	FlyoutButtonES:Set({"LeftClickSet"}, FbcLeftClickSet)
	print("set parent on cast = "..tostring(FbcLeftClickSet))

	for _, arrowBtn in pairs(FbcArrowButtons) do
		for _, v in ipairs(arrowBtn.FlyoutListFrame.ButtonList) do
			v:SetClickHandler(FbcHideOnClick, FbcLeftClickSet)
		end
	end
end

local function SlashTable_rightClickSet(rest)
	FbcRightClickSet = not(FbcRightClickSet)
	FlyoutButtonES:Set({"RightClickSet"}, FbcRightClickSet)
	print("right-click set = "..tostring(FbcRightClickSet))
end

local function SlashTable_arrowBtnMovale(rest)
	FbcArrowBtnMovable = not(FbcArrowBtnMovable)
	FlyoutButtonES:Set({"ArrowBtnMovable"}, FbcArrowBtnMovable)
	print("arrow buttons movable = "..tostring(FbcArrowBtnMovable))

	for _, arrowBtn in pairs(FbcArrowButtons) do
		arrowBtn:SetMovable(FbcArrowBtnMovable)
	end
end

local function SlashTable_arrowBtnDirLocked(rest)
	FbcArrowBtnDirLocked = not(FbcArrowBtnDirLocked)
	FlyoutButtonES:Set({"ArrowBtnDirLocked"}, FbcArrowBtnDirLocked)
	print("arrow buttons dir locked = "..tostring(FbcArrowBtnDirLocked))
end

local function SlashTable_useShift(rest)
	FbcUseShift = not(FbcUseShift)
	FlyoutButtonES:Set({"UseShift"}, FbcUseShift)
	print("use Shift = "..tostring(FbcUseShift))
end

local function SlashTable_SeparateSpecs(rest)
	FbcSeparateSpecs = not(FbcSeparateSpecs)
	FlyoutButtonES:Set({"SeparateSpecs"}, FbcSeparateSpecs)
	print("separate specs = "..tostring(FbcSeparateSpecs))
	EventTalentGroupChanged()
end


local FlyoutButtonCustom_SlashTable = {
	{
		['name'] = '顯示邊框',
		['hint'] = "顯示按鈕邊框",
		['func'] = SlashTable_border,
		['get'] = function() return FbcShowBorders; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '自動隱藏',
		['hint'] = "按下按鈕後隱藏彈出的按鈕清單",
		['func'] = SlashTable_hide,
		['get'] = function() return FbcHideOnClick; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '顯著標示',
		['hint'] = "滑鼠指向箭頭時顯著標示",
		['func'] = SlashTable_highlight,
		['get'] = function() return FbcHighlight; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '設定快捷鍵',
		['hint'] = "進入按鍵綁定模式",
		['func'] = SlashTable_keybind,
		['get'] = function() return FbcKeybindMode; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '滑鼠指向時彈出',
		['hint'] = "滑鼠指向箭頭按鈕時，展開/收合彈出的按鈕清單",
		['func'] = SlashTable_mouseover,
		['get'] = function() return FbcEnableMouseover; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '滑鼠指向時彈出 (戰鬥中)',
		['hint'] = "戰鬥中啟用/停用滑鼠指向時彈出按鈕清單",
		['func'] = SlashTable_mouseoverincombat,
		['get'] = function() return FbcEnableMouseoverInCombat; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '設定模式',
		['hint'] = "進入設定模式",
		['func'] = SlashTable_settings,
		['get'] = function() return FbcSettingsMode; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '只顯示一個按鈕清單',
		['hint'] = "每次只會顯示一個彈出的按鈕清單",
		['func'] = SlashTable_unique,
		['get'] = function() return FlyoutButtonES:Get({"UniqueList"}, true); end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '右鍵自我施法',
		['hint'] = "右鍵自我施法",
		['func'] = SlashTable_rightClickSelfCast,
		['get'] = function() return FbcRightClickSelfCast; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '左鍵設為主按鈕',
		['hint'] = "施放技能時設為主按鈕",
		['func'] = SlashTable_leftClickSet,
		['get'] = function() return FbcLeftClickSet; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '右鍵設為主按鈕',
		['hint'] = "非戰鬥中右鍵點擊會設為主按鈕",
		['func'] = SlashTable_rightClickSet,
		['get'] = function() return FbcRightClickSet; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '可移動的箭頭按鈕',
		['hint'] = "箭頭按鈕的清單可以移動/複製",
		['func'] = SlashTable_arrowBtnMovale,
		['get'] = function() return FbcArrowBtnMovable; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '鎖定箭頭按鈕方向',
		['hint'] = "鎖定箭頭按鈕的方向",
		['func'] = SlashTable_arrowBtnDirLocked,
		['get'] = function() return FbcArrowBtnDirLocked; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '使用 Shift 鍵移動',
		['hint'] = "按住 Shift 鍵不放可拖曳移動鎖定的按鈕",
		['func'] = SlashTable_useShift,
		['get'] = function() return FbcUseShift; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = '專精專用設定',
		['hint'] = "每種專精使用不同的按鈕設定",
		['func'] = SlashTable_SeparateSpecs,
		['get'] = function() return FbcSeparateSpecs; end,
		['type'] = FBC_SETTINGS_CHECKBOX
	},
	{
		['name'] = "箭頭按鈕高度",
		['hint'] = "設定箭頭按鈕的高度，數值為 "..ARROW_BUTTON_MIN_HEIGHT.."-"..ARROW_BUTTON_MAX_HEIGHT,
		['func'] = SlashTable_height,
		['min'] = ARROW_BUTTON_MIN_HEIGHT,
		['max'] = ARROW_BUTTON_MAX_HEIGHT,
		['step'] = 1,
		['get'] = function() return FbcArrowButtonsHeight; end,
		['type'] = FBC_SETTINGS_SLIDER
	},
	{
		['name'] = "按鈕縮放大小",
		['hint'] = "設定按鈕的縮放大小，數值為 "..BUTTON_MIN_SCALE.."-"..BUTTON_MAX_SCALE,
		['func'] = SlashTable_scale,
		['min'] = BUTTON_MIN_SCALE,
		['max'] = BUTTON_MAX_SCALE,
		['step'] = BUTTON_SCALE_STEP,
		['get'] = function() return FbcButtonsScale; end,
		['type'] = FBC_SETTINGS_SLIDER
	},
}

local function FlyoutButtonCustom_SlashHandler(msg, editbox)
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	-- Any leading non-whitespace is captured into command
	-- the rest (minus leading whitespace) is captured into rest.
	command = string.lower(command)
	
	if command == "" then
		FbcSettingsWindow:Show()
	elseif command == "help" then
		print("FlyoutButton Custom slash commands:\n/fbc or /fbcustom, params:")
		for _, v in ipairs(FlyoutButtonCustom_SlashTable) do
			print(v.name.." : "..v.hint)
		end
	else
		local found = false
		for _, v in ipairs(FlyoutButtonCustom_SlashTable) do
			if v.name == command then
				found = true
				v.func(rest)
				break
			end
		end
		
		if not(found) then
			print("unknown command '"..command.."'")
		end
	end
end

function FlyoutButtonCustom_SettingsIncCounter()
	if isInit and not(InCombatLockdown()) then
		EnterSettingsMode()
	end
end

function FlyoutButtonCustom_SettingsDecCounter()
	if isInit and not(InCombatLockdown()) then
		LeaveSettingsMode()
	end
end

local OnShowHookFrames = {SpellBookFrame, PaperDollFrame} --, MacroFrame, CollectionsJournal
local function SettingsHookFrames()
	for _, v in pairs(OnShowHookFrames) do
		v:HookScript("OnShow", FlyoutButtonCustom_SettingsIncCounter)
		v:HookScript("OnHide", FlyoutButtonCustom_SettingsDecCounter)		
	end
end

local function SettingsHookFunc()
	hooksecurefunc("ShowMacroFrame", function()
		FlyoutButtonCustom_SettingsIncCounter()
		MacroFrame:HookScript("OnHide", FlyoutButtonCustom_SettingsDecCounter)
	end)
	
	hooksecurefunc("ToggleCollectionsJournal", function()
		if CollectionsJournal:IsShown() then
			--print("CollectionsJournal:IsShown")
			--FlyoutButton_MountJournal_UpdateCachedList()
			
			FlyoutButtonCustom_SettingsIncCounter()
			CollectionsJournal:HookScript("OnHide", FlyoutButtonCustom_SettingsDecCounter)
		end
	end)
	
	if (MacroToolkitFrame) then  
		MacroToolkitFrame:HookScript("OnHide", FlyoutButtonCustom_SettingsDecCounter)
	end
end

local function SetActionButtonTooltip()
	if not(FbcLeftClickSet) then
		return
	end
	
	local frame = GameTooltip:GetOwner()
	if frame then
		local flyoutButtonName = frame:GetAttribute("fbc_tooltip_source")
		if flyoutButtonName then
			local flyoutButton = _G[flyoutButtonName]
			if flyoutButton then
				flyoutButton:UpdateTooltip()
			end
		end
	end
end

local function Init()
	if InCombatLockdown() then
		print("彈出按鈕會在戰鬥結束後載入")
		EventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end
	
	assert(LibStub, "LibStub not found")

	--EasyStorage
	local storage = LibStub("EasyStorage-1.4", false)
	
	FlyoutButtonCustom_Settings = FlyoutButtonCustom_Settings or {}
	FlyoutButtonES = storage:New(FlyoutButtonCustom_Settings)
	
	--FlyoutButtonCustom_Settings_Global = FlyoutButtonCustom_Settings_Global or {}
	--FlyoutButtonGS = storage:New(FlyoutButtonCustom_Settings_Global)
	
	--read settings
	FbcArrowButtonsHeight 		= FlyoutButtonES:Get({"ArrowButtonsHeight"}, ARROW_BUTTON_DEF_HEIGHT)
	FbcButtonsScale 			= FlyoutButtonES:Get({"ButtonsScale"}, 1)
	FbcShowBorders 				= FlyoutButtonES:Get({"ShowBorders"}, true)
	FbcEnableMouseover			= FlyoutButtonES:Get({"EnableMouseover"}, false)
	FbcEnableMouseoverInCombat 	= FlyoutButtonES:Get({"EnableMouseoverInCombat"}, true)
	FbcHideOnClick 				= FlyoutButtonES:Get({"HideOnClick"}, true)
	FbcHighlight 				= FlyoutButtonES:Get({"Highlight"}, true)
	FbcRightClickSelfCast		= FlyoutButtonES:Get({"RightClickSelfCast"}, true)
	FbcLeftClickSet				= FlyoutButtonES:Get({"LeftClickSet"}, false)
	FbcRightClickSet			= FlyoutButtonES:Get({"RightClickSet"}, true)
	FbcArrowBtnMovable			= FlyoutButtonES:Get({"ArrowBtnMovable"}, false)
	FbcArrowBtnDirLocked		= FlyoutButtonES:Get({"ArrowBtnDirLocked"}, false)
	FbcUseShift					= FlyoutButtonES:Get({"UseShift"}, false)
	FbcSeparateSpecs			= FlyoutButtonES:Get({"SeparateSpecs"}, false)
	
	FbcStubFrame:SetAttribute("unique-list", FlyoutButtonES:Get({"UniqueList"}, true))
	
	--Button Facade
	LBF = LibStub("Masque", true)
	if (LBF) then
		FBC_MasqueMasterGroup = LBF:Group("FlyoutButtonCustom")
	end
	
	RegisterEvents() --before button to set proper event order for cache, before button events
	RegisterFrames()
	AttachToAllActionButtons()
	
	--LibKeyBound
	FbcLibKeyBound = LibStub("LibKeyBound-1.0", false)
	if (FbcLibKeyBound) then
		FbcLibKeyBound.RegisterCallback(EventFrame, "LIBKEYBOUND_ENABLED")
		FbcLibKeyBound.RegisterCallback(EventFrame, "LIBKEYBOUND_DISABLED")
		FbcLibKeyBound.RegisterCallback(EventFrame, "LIBKEYBOUND_MODE_COLOR_CHANGED")
	end

	SLASH_FBCUSTOM1, SLASH_FBCUSTOM2, SLASH_FBCUSTOM3 = "/fbc", "/fbcustom", "/彈出按鈕"
	SlashCmdList["FBCUSTOM"] = FlyoutButtonCustom_SlashHandler
	
	--SettingsWindow
	FbcSettingsWindow = CreateFrame("Frame", "FBCSettingsDialog", UIParent, "FBCSettingsDialogTemplate")
	local top = -60
	for i, v in ipairs(FlyoutButtonCustom_SlashTable) do
		local name = "FlyoutButtonCustom_SettingsButton_"..v.name
		if v.type == FBC_SETTINGS_CHECKBOX then
			v.widget = CreateFrame("CheckButton", name, FbcSettingsWindow, "FBCSettingsButtonTemplate")
			local btn = v.widget
			_G[name.."Text"]:SetText(v.name)
			btn.tooltipText = v.hint
			btn.func = v.func
			btn.get = v.get
			btn.type = v.type
			btn:SetPoint("TOPLEFT", FbcSettingsWindow, "TOPLEFT", 80, top)
			top = top - 25
		elseif v.type == FBC_SETTINGS_SLIDER then
			v.widget = CreateFrame("Slider", name, FbcSettingsWindow, "OptionsSliderTemplate")
			local slider = v.widget

			local subText = slider:CreateFontString(name.."Value", "ARTWORK", "GameFontHighlight")
			subText:SetPoint("CENTER", slider, "CENTER", 0, -12)
			
			_G[name.."Text"]:SetText(v.name)
			_G[name.."Low"]:SetText(v.min)
			_G[name.."High"]:SetText(v.max)
			slider.valueText = _G[name.."Value"]
			slider:SetValueStep(v.step)
			slider:SetMinMaxValues(v.min, v.max)
			slider.tooltipText = v.hint
			slider.func = v.func
			slider.get = v.get
			slider.type = v.type
			top = top - 25
			slider:SetPoint("TOPLEFT", FbcSettingsWindow, "TOPLEFT", 80, top)
			top = top - 25
			slider:SetScript("OnValueChanged", function(self) self.valueText:SetText(self:GetValue()); end)
		end
	end
	FbcSettingsWindow:SetHeight(-top + 80)

	SettingsHookFrames()
	SettingsHookFunc()

	hooksecurefunc(GameTooltip, "SetAction", SetActionButtonTooltip)
	
	customizeFrame = _G["MacroText_CustomizeFrame"]
	if not(customizeFrame) then
		customizeFrame = CreateFrame('Frame', 'MacroText_CustomizeFrame', UIParent, 'LibMT_MacroTextCustomizeFrame_Template')
		RegisterStateDriver(customizeFrame, "visibility", "[combat] hide; [vehicleui] hide")
		tinsert(UISpecialFrames, customizeFrame:GetName())
	end
	iconSelectionDialogPopupFrame = _G["LibMT_IconSelectionDialogPopup"]
	if not(iconSelectionDialogPopupFrame) then
		iconSelectionDialogPopupFrame = CreateFrame('Frame', 'LibMT_IconSelectionDialogPopup', customizeFrame, 'LibMT_IconSelectionDialogPopupTemplate')
		tinsert(UISpecialFrames, iconSelectionDialogPopupFrame:GetName())
	end
	
	isInit = true
end

function FBCSettingsDialogTemplate_OnShow(self)
	local buttons = { self:GetChildren() }
	for i, b in ipairs(buttons) do
		if b.get then
			b.old = b.get()
			if b.type == FBC_SETTINGS_CHECKBOX then
				b:SetChecked(b.get())
			elseif b.type == FBC_SETTINGS_SLIDER then
				b:SetValue(b.get())
				b.valueText:SetText(b.get())
			end
		end
	end
end

local function toboolean(v)
	return not not v
end

function FBCSettingsDialogTemplate_Apply(self)
	local buttons = { self:GetChildren() }
	for i, b in ipairs(buttons) do
		if b.func then
			if b.type == FBC_SETTINGS_CHECKBOX then
				if toboolean(b.old) ~= toboolean(b:GetChecked()) then
					b.func()
				end
			elseif b.type == FBC_SETTINGS_SLIDER then
				local value = b:GetValue()
				if b.old ~= value then
					b.func(value)
				end
			end
		end
	end
end

local function OnEvent(self, event, ...)
	--print("fbc "..tostring(event))
	if EventHandlersTable[event] then
		if isInit then
			EventHandlersTable[event](self, ...)
		end
	elseif event == "PLAYER_ENTERING_WORLD" or event == "VARIABLES_LOADED" or event == "UPDATE_MACROS" or event == "PET_JOURNAL_LIST_UPDATE" then
		EnteringWorldOrVariablesLoaded = EnteringWorldOrVariablesLoaded + 1
		if event == "PLAYER_ENTERING_WORLD" then EventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD") end
		if event == "VARIABLES_LOADED" then EventFrame:UnregisterEvent("VARIABLES_LOADED") end
		if event == "PET_JOURNAL_LIST_UPDATE" then EventFrame:UnregisterEvent("PET_JOURNAL_LIST_UPDATE") end
		if event == "UPDATE_MACROS" then
			--local numglobal, numperchar = GetNumMacros()
			--print('UpdateMacroCount = '..UpdateMacroCount..', numglobal = '..numglobal..', numperchar = '..numperchar)
			UpdateMacroCount = UpdateMacroCount + 1
			if UpdateMacroCount > 1 then
				EventFrame:UnregisterEvent("UPDATE_MACROS")
			end
		end
		if EnteringWorldOrVariablesLoaded > 4 then -- 3 without PET_JOURNAL_LIST_UPDATE
			Init()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		EventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
		Init()
	end
end

EventFrame:SetScript("OnEvent", OnEvent)
