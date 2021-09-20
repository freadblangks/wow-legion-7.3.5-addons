
local LFH = LibStub("LibTabbedFrame-1.0");
local LO = LibStub("LibOptionsFrame-1.0");
local LS = LibStub("LibSideTabFrame-1.0");

local FBFRAMES = {
	[1] = {
		["frame"] = "FishingLocationsFrame",
		["name"] = FBConstants.LOCATIONS_TAB,
		["tooltip"] = FBConstants.LOCATIONS_INFO,
		["toggle"] = "_LOC",
		["first"] = 1,
	},
	[2] = {
		["frame"] = "FishingOptionsFrame",
		["name"] = FBConstants.OPTIONS_TAB,
		["tooltip"] = FBConstants.OPTIONS_INFO,
		["toggle"] = "_OPT",
		["ultimate"] = 1,
	}
};

local ManagedFrames = {};
local function DisableSubFrame(target)
	FishingBuddyFrame:DisableSubFrame(target);
end
FishingBuddy.DisableSubFrame = DisableSubFrame;

local function EnableSubFrame(target)
	FishingBuddyFrame:EnableSubFrame(target);
end
FishingBuddy.EnableSubFrame = EnableSubFrame;

local function ManageFrame(target, tabname, tooltip, toggle)
	FishingBuddyFrame:ManageFrame(target, tabname, tooltip, toggle);
end
FishingBuddy.ManageFrame = ManageFrame;

local function Group_OnClick(tabframe, tabname)
	for idx,group in ipairs(tabframe.target.groups) do
		if group.name == tabname then
			group.frame:Show()
		else
			group.frame:Hide()
		end
	end
end

local function CreateManagedFrameGroup(tabname, tooltip, toggle, groups, optiontab)
	local target = FishingBuddyFrame:CreateManagedFrame("Managed"..tabname, tabname, tooltip, toggle);
	LS:Embed(target)	
	target:SetScript("OnShow", function (self) self:HandleOnShow(self:GetSelected()); end);
	target:SetScript("OnHide", function (self) self:HideTabs(); end);
	target.groups = groups
	for idx,group in ipairs(groups) do
		local tabframe = target:CreateTab(group.name, group.icon, Group_OnClick, group.tooltip or group.name);
		group.frame:SetParent(target)
		group.frame:Hide()
	end
	if ( optiontab ) then
		local frame = CreateFrame("Frame", "Options"..tabname, target)
		FishingBuddy.EmbeddedOptions(frame)
		frame:SetScript("OnShow", function (self)
			self:ShowButtons();
		end)
		tinsert(groups, {
			["name"] = optiontab.name,
			["icon"] = optiontab.icon,
			["frame"] = frame
		})
		frame.options = optiontab
		frame.ontabclick = Group_OnClick
		target.handoff = frame
		FishingBuddy.OptionsFrame.HandleOptions(optiontab.name, optiontab.icon, optiontab.options, optiontab.setter, optiontab.getter, optiontab.last, target)
	end
	target:ResetTabFrames();
	target:SelectTab(target:GetSelected());
end
FishingBuddy.CreateManagedFrameGroup = CreateManagedFrameGroup;

function ToggleFishingBuddyFrame(target)
	FishingBuddyFrame:ToggleTab(target);
end

local function OnVariablesLoaded(self, event, ...)
	-- set up mappings
	for idx,info in pairs(FBFRAMES) do
		local tf = FishingBuddyFrame:MakeFrameTab(info.frame, info.name, info.tooltip, info.toggle);
		if ( info.first) then
			FishingBuddyFrame:MakePrimary(info.frame);
		elseif ( info.ultimate ) then
			FishingBuddyFrame:MakeUltimate(info.frame);
		end
	end
	FishingBuddyFrame:ShowSubFrame("FishingLocationsFrame");
end

local function OnShow()
	FishingBuddy.RunHandlers(FBConstants.FRAME_SHOW_EVT);
end

FishingBuddyFrame = LFH:CreateFrameHandler("FishingBuddyFrame",
			"Interface\\LootFrame\\FishingLoot-Icon", FBConstants.WINDOW_TITLE, "FISHINGBUDDY",
			OnShow, nil, OnVariablesLoaded);
FishingBuddyFrame:Show();
FishingBuddyFrame:Hide();
