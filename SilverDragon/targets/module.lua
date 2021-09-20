local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("ClickTarget", "AceEvent-3.0")
local Debug = core.Debug

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("ClickTarget", {
		profile = {
			show = true,
			locked = true,
			style = "SilverDragon",
			closeAfter = 30,
			sources = {
				target = false,
				grouptarget = true,
				mouseover = true,
				nameplate = true,
				vignette = true,
				['point-of-interest'] = true,
				groupsync = true,
				guildsync = false,
				fake = true,
			},
		},
	})
	core.RegisterCallback(self, "Announce")
	core.RegisterCallback(self, "Marked")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")

	local config = core:GetModule("Config", true)
	if config then
		config.options.plugins.clicktarget = {
			clicktarget = {
				type = "group",
				name = "目標框架",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					local oldpopup = self.popup
					self.popup = self:CreatePopup()
					if oldpopup:IsVisible() then
						self:ShowFrame(oldpopup.data)
					end
					oldpopup:Hide()
				end,
				order = 25,
				args = {
					about = config.desc("發現稀有怪的時候能夠馬上將牠選為目標是很棒的，只要點一下彈出的小視窗就能做到。要顯示稀有怪的 3D 模組必須知道牠的 ID (透過已輸入的資料)，或是經由選為目標來發現牠的，透過血條發現的沒辦法。", 0),
					show = config.toggle("顯示", "顯示可點擊的目標框架", 10),
					locked = config.toggle("鎖定", "鎖住可點擊的目標框架的位置，要按住 Alt 才能移動。", 15),
					closeAfter = {
						type = "range",
						name = "自動關閉時間",
						desc = "沒有與它互動後多久時間要自動關閉框架，單位為秒。",
						width = "full",
						min = 5,
						max = 600,
						step = 1,
					},
					sources = {
						type="multiselect",
						name = "稀有怪來源",
						desc = "何種方式發現的稀有怪要顯示框架?",
						get = function(info, key) return self.db.profile.sources[key] end,
						set = function(info, key, v) self.db.profile.sources[key] = v end,
						values = {
							target = "目標",
							grouptarget = "隊友目標",
							mouseover = "滑鼠指向",
							nameplate = "血條",
							vignette = "小地圖星號",
							['point-of-interest'] = "地圖目標圓點",
							groupsync = "隊伍同步",
							guildsync = "公會同步",
						},
					},
					style = {
						type = "select",
						name = "風格",
						desc = "框架的外觀樣式",
						values = {},
					},
				},
			},
		}
		for key in pairs(self.Looks) do
			config.options.plugins.clicktarget.clicktarget.args.style.values[key] = key
		end
	end

	self.popup = self:CreatePopup()
end

local pending
function module:Announce(callback, id, zone, x, y, dead, source, unit)
	if source:match("^sync") then
		local channel, player = source:match("sync:(.+):(.+)")
		if channel == "GUILD" then
			source = "guildsync"
		else
			source = "groupsync"
		end
	end
	if not self.db.profile.sources[source] then
		return
	end
	local data = {
		id = id,
		unit = unit,
		source = source,
		dead = dead,
	}
	if InCombatLockdown() then
		pending = data
	else
		self:ShowFrame(data)
	end
	FlashClientIcon() -- If you're tabbed out, bounce the WoW icon if we're in a context that supports that
	data.unit = nil -- can't be trusted to remain the same
end

function module:Marked(callback, id, marker, unit)
	if self.popup.data and self.popup.data.id == id then
		self.popup:SetRaidIcon(marker)
	end
end

function module:PLAYER_REGEN_ENABLED()
	if pending then
		pending = nil
		self:ShowFrame(pending)
	end
end
