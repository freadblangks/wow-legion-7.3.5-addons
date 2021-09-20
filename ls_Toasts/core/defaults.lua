local _, addonTable = ...

-- Mine
local C, D = {}, {}
addonTable.C, addonTable.D = C, D

D.profile = {
	max_active_toasts = 12,
	scale = 1,
	strata = "DIALOG",
	fadeout_delay = 2.8,
	growth_direction = "UP",
	skin = "default",
	font = {
		-- name = nil,
		size = 14,
	},
	colors = {
		name = true,
		border = true,
		icon_border = true,
		threshold = 1,
	},
	point = {
		p = "TOPLEFT",
		rP = "BOTTOMLEFT",
		x = 270,
		y = 370,
	},
	types = {},
}
