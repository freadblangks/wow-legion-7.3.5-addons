RaidCheck = LibStub("AceAddon-3.0"):NewAddon("Raid Check", "AceEvent-3.0", "AceConsole-3.0")

local L = LibStub("AceLocale-3.0"):GetLocale("Raid Check", true)

-- Command line options
local options = {
	name = "Raid Check",
	handler = RaidCheck,
	type = "group",
	args = {
		Announce = {
			type = "execute",
			name = L["announce"],
			desc = L["announcetxt"],
			func = "Announce",
			order = 4,
		},
		Show = {
			type = "execute",
			name = L["show"],
			desc = L["showText"],
			func = "OpenMain",
			order = 1,
		},
		Hide = {
			type = "execute",
			name = L["hide"],
			desc = L["hideText"],
			func = "Hide",
			order = 2,
		},
		Settings = {
			type = "execute",
			name = L["settings"],
			desc = L["settingsText"],
			func = "OpenSettings",
			order = 3,
		},
		Whisper = {
			type = "execute",
			name = L["whisper"],
			desc = L["whispertxt"],
			func = "WhisperAll",
			order = 5,
		},
	},
}

--Register the addon with LibDataBroker for the minimap button
rcLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Raid Check", {
	type = "launcher",
	text = "Raid Check",
	icon = "Interface\\Icons\\Inv_potion_41",
	OnClick = function(self, button, down)
		if button == "LeftButton" then
			if IsControlKeyDown() then
				RaidCheck:Announce();
			else
				RaidCheck:OpenMain();
			end
		elseif button == "RightButton" then
			RaidCheck:OpenSettings();
		end
	end,
	OnTooltipShow = function(tt)
		tt:AddLine(L["MinimapTooltip1"]);
		tt:AddLine(L["MinimapTooltip3"]);
		tt:AddLine(L["MinimapTooltip2"]);
	end
})
rcIcon = LibStub:GetLibrary("LibDBIcon-1.0")

-- Default Settings of the Addon
local defaults = {
	char = {
		Allow = {
			FelFocuser = true,
		},
		Announce = {
			BossStart = false,
			Flask = true,
			Food = true,
			LeaderAssistOnly = true,
			ReadyCheck = true,
			Rune = true,
			WisdomBuffTargets = false,
		},
		classColors = true,
		Frame = {
			height = 500,
			top = 800,
			left = 50,
			width = 325,
		},
		IgnoreGroup7_8 = false,
		Show = {
			Minimap = {
				hide = false,
			},
			RaidCheckonReady = true,
			Realm = true,
			Rune = true,
			StartCombatHide = true,
			WisdomBuffTargets = false,
		},
		Threshold = {
		  Flask = 1, -- 1st item in the Flask table 1300
		  Food = 3, -- 3rd item in the Food table 375
		  Rune = 1, -- 1st item in the Rune table 325
		  VantusRune = 1, -- 1st item in the Vantus Rune table:  None
		},
		Whisper = {
			OnControl = true,
			OnReadyCheck = false,
			VantusRune = false, -- Checkbox for whispering to use Vantus Rune on the selected Boss.
		},
	}
}

function RaidCheck:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("RaidCheckDB", defaults)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("Raid Check", options, {"raidcheck", "rc"})

	rcIcon:Register(RaidCheck.AddOn_Name, rcLDB, self.db.char.Minimap)
end

function RaidCheck:OnEnable()
	RaidCheck:RegisterEvent("READY_CHECK", "RdyChk")
	RaidCheck:RegisterEvent("PLAYER_REGEN_DISABLED", "CombatHide")
	RaidCheck:RegisterEvent("ADDON_LOADED", "RefreshConfig")
	RaidCheck:RegisterEvent("ENCOUNTER_START", "RaidBossStart")
end

function RaidCheck:RefreshConfig()
	self:loadData()
	self:UpdateMinimap()
end

-- Hide or Show the minimap icon
function RaidCheck:UpdateMinimap()
	if self.db.char.Show.Minimap.hide or not RaidCheck:IsEnabled() then
		rcIcon:Hide(RaidCheck.AddOn_Name)
	else
		rcIcon:Show(RaidCheck.AddOn_Name)
	end
end

function RaidCheck:UIresettoDefault()
	RaidCheck:Hide()
	self.db:ResetDB("RaidCheckDB", "char")
	RaidCheck:OpenSettings()
end
