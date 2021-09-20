local addonName, ns = ...
ns.ObjectiveTracker = ns.ObjectiveTracker or {}

--Frame to properly load SavedVariables
local frame = CreateFrame("Frame", "ObeliskQuestObjectiveTrackerHeader")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

frame:SetSize(200, 25)
frame:SetPoint("TOP", ObjectiveTrackerBlocksFrame, "TOP")
frame:SetFrameStrata("BACKGROUND")

local function HeaderContextMenu_ToggleLock(self)
	ns.ObjectiveTracker.SetLocked(not OQ.ObjectiveTracker.locked)
end

local function HeaderContextMenu(frame, level, menuList)
	local info = UIDropDownMenu_CreateInfo()

	info.func = HeaderContextMenu_ToggleLock

	if OQ.ObjectiveTracker.locked then
		info.text = "Unlock"
	else
		info.text = "Lock"
	end

	UIDropDownMenu_AddButton(info)
end

function ns.ObjectiveTracker.SetLocked(locked)
	OQ.ObjectiveTracker.locked = locked

	if ns.ObjectiveTracker.OnLockedChanged then
		ns.ObjectiveTracker.OnLockedChanged(locked)
	end
end

function frame:ADDON_LOADED(name)
	if name == addonName then
		OQ = OQ or {}
		OQ.ObjectiveTracker = OQ.ObjectiveTracker or {}

		if OQ.ObjectiveTracker.locked == nil then
			ns.ObjectiveTracker.SetLocked(true)
		else
			ns.ObjectiveTracker.SetLocked(OQ.ObjectiveTracker.locked)
		end
	end
end

local dropdown

local function ShowDropDown(self, btn)
	if btn == "RightButton" then
		ToggleDropDownMenu(1, nil, dropdown, "cursor", 3, -3)
	end
end

function frame:PLAYER_LOGIN()
	if not dropdown then
		dropdown = CreateFrame("Frame", "ObjectiveTrackerHeaderDropdown", UIParent, "UIDropdownMenuTemplate")
		UIDropDownMenu_SetWidth(dropdown, 200)
		UIDropDownMenu_Initialize(dropdown, HeaderContextMenu, "MENU")
	end

	ns.Util.AppendScript(ObeliskQuestObjectiveTrackerHeader, "OnMouseDown", ShowDropDown)
end