local options
local L = LibStub("AceLocale-3.0"):GetLocale("EmoteCenter", false)
local icon = LibStub("LibDBIcon-1.0")
function EmoteCenter_GetOptions()
	local db = EmoteCenter.db

	options = {
		name = L["EmoteCenter"],
		handler = addon,
		type = "group",
		order = 1,
		args = {
			reset = {
				name = L["Reset the options to default."],
				desc = L["Reset the options to default."],
				type = "execute",
				func = function()
					EmoteCenter:ResetOptions()
				end,
				order = 0,
				width = "full",
			},

			miniToggle = {
				name = L["Show minimap button."],
				desc = L["Toggle the display of the minimap button."],
				type = "toggle",
				get = function() return not db.global.LibDBIcon.hide end,
				set = function(_, value)
					db.global.LibDBIcon.hide = not value
					if (value) then
						icon:Show("EmoteCenter")
					else
						icon:Hide("EmoteCenter")
					end
				end,
				order = 1,
				width = "full",
				},

			showSlash = {
				name = L["Show slash commands."],
				desc = L["Toggle the display of slash commands."],
				type = "toggle",
				get = function() return db.profile.showSlashCommand end,
				set = function(_, value)
					db.profile.showSlashCommand = value
				end,
				order = 2,
				width = "full",
				},

			showFlag = {
				name = L["Show A&V flags."],
				desc = L["Toggle the display of A&V flags."],
				type = "toggle",
				get = function() return db.profile.showFlag end,
				set = function(_, value)
					db.profile.showFlag = value
				end,
				order = 3,
				width = "full",
				},


		},
	}
	return options
end
