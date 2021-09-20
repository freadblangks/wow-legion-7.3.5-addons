local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Tooltip", "AceEvent-3.0")
local Debug = core.Debug

local globaldb
function module:OnInitialize()
	globaldb = core.db.global

	self.db = core.db:RegisterNamespace("Tooltip", {
		profile = {
			achievement = true,
			id = false,
		},
	})

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.tooltip = {
			tooltip = {
				type = "group",
				name = "滑鼠提示",
				order = 93,
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v) self.db.profile[info[#info]] = v end,
				args = {
					about = config.desc("稀有怪獸與牠們的產地能夠在怪物的滑鼠提示說明中增加一些資訊。對於稀有怪來說，會顯示是否真的需要擊殺牠才能達成成就。", 0),
					achievement = config.toggle("成就", "顯示達成成就是否需要這個稀有怪"),
					id = config.toggle("單位 ID", "在滑鼠提示中顯示稀有怪的 ID"),
				},
			},
		}
	end
end

function module:OnEnable()
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function module:UPDATE_MOUSEOVER_UNIT()
	self:UpdateTooltip(core:UnitID('mouseover'))
end

-- This is split out entirely so I can test this without having to actually hunt down a rare:
-- /script SilverDragon:GetModule('Tooltip'):UpdateTooltip(51059)
function module:UpdateTooltip(id)
	if not id then
		return
	end

	if self.db.profile.id then
		GameTooltip:AddDoubleLine("id", id, 1, 1, 0, 1, 1, 0)
	end

	if self.db.profile.achievement then
		ns:UpdateTooltipWithCompletion(GameTooltip, id)
	end

	GameTooltip:Show()
end
