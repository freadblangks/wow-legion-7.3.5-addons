local myname, ns = ...

local core = LibStub("AceAddon-3.0"):GetAddon("SilverDragon")
local module = core:NewModule("Macro", "AceEvent-3.0", "AceConsole-3.0")
local Debug = core.Debug

local HBD = LibStub("HereBeDragons-1.0")

function module:OnInitialize()
	self.db = core.db:RegisterNamespace("Macro", {
		profile = {
			enabled = true,
			verbose = true,
		},
	})
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	HBD.RegisterCallback(self, "PlayerZoneChanged", "Update")
	core.RegisterCallback(self, "Seen", "Update")
	core.RegisterCallback(self, "Ready", "Update")

	local config = core:GetModule("Config", true)
	if config then
		config.options.args.scanning.plugins.macro = {
			macro = {
				type = "group",
				name = "巨集",
				get = function(info) return self.db.profile[info[#info]] end,
				set = function(info, v)
					self.db.profile[info[#info]] = v
					self:Update()
				end,
				args = {
					about = config.desc("建立一個將可能在附近的稀有怪選為目標、可用於巨集的按鈕。\n\n"..
							"你可以自行建立一個巨集：/click SilverDragonMacroButton\n\n"..
							"...或按下下方的 '建立巨集' 按鈕，會建立一個叫做 SilverDragon 的新巨集，將它拖曳到快捷列上，按下時會將可能在附近的稀有怪選為目標。",
							0),
					verbose = {
						type = "toggle",
						name = "通知",
						desc = "加上一個簡單的輸出訊息，以便知道巨集在尋找什麼",
					},
					create = {
						type = "execute",
						name = "建立巨集",
						desc = "按一下建立巨集",
						func = function()
							self:CreateMacro()
						end
					},
				},
				-- order = 99,
			},
		}
	end
end

function module:Update()
	if InCombatLockdown() then
		self.waiting = true
		return
	end
	if not self.db.profile.enabled then
		self.button:SetAttribute("macrotext", "/print \"掃描巨集已經停用\"")
		return
	end
	Debug("Updating Macro")
	-- first, create the macro text on the button:
	local zone = HBD:GetPlayerZone()
	local mobs = zone and ns.mobsByZone[zone]
	local macro = {}
	local count = 0
	if mobs then
		for id in pairs(mobs) do
			local name = core:NameForMob(id)
			if name and not core.db.global.ignore[id] then
				table.insert(macro, "/targetexact " .. name)
				count = count + 1
			end
		end
	end
	if count == 0 then
		table.insert(macro, "/print \"沒有已知的稀有怪可以掃描\"")
	end
	if self.db.profile.verbose then
		table.insert(macro, 1, ("/print \"正在掃描 %d 個附近的稀有怪...\""):format(count))
	end
	self.button:SetAttribute("macrotext", ("\n"):join(unpack(macro)))
	table.wipe(macro)
end

function module:CreateMacro()
	if InCombatLockdown() then
		return self:Print("|cffff0000戰鬥中無法建立巨集!|r")
	end
	LoadAddOn("Blizzard_MacroUI") -- required for MAX_ACCOUNT_MACROS
	local macroIndex = GetMacroIndexByName("SilverDragon")
	if macroIndex == 0 then
		local numglobal,numperchar = GetNumMacros()
		if numglobal < MAX_ACCOUNT_MACROS then
			--/script for i=1,GetNumMacroIcons() do if GetMacroIconInfo(i):match("SniperTraining$") then DEFAULT_CHAT_FRAME:AddMessage(i) end end
			CreateMacro("SilverDragon", [[ABILITY_HUNTER_SNIPERTRAINING]], "/click SilverDragonMacroButton", nil, nil)
			self:Print("SilverDragon 巨集已經建立。輸入 /巨集 開啟巨集介面，然後將它拖曳到快捷列上來使用。")
		else
			self:Print("|cffff0000無法建立掃描稀有怪的巨集，巨集數量已達上限。|r")
		end
	else
		self:Print("|cffff0000名稱為 SilverDragon 的巨集已經存在。|r")
	end
end

function module:PLAYER_REGEN_ENABLED()
	if self.waiting then
		self.waiting = false
		self:Update()
	end
end

local button = CreateFrame("Button", "SilverDragonMacroButton", nil, "SecureActionButtonTemplate")
button:SetAttribute("type", "macro")
button:SetAttribute("macrotext", "/script DEFAULT_CHAT_FRAME:AddMessage('SilverDragon 巨集：尚未初始化。', 1, 0, 0)")
module.button = button

-- /spew SilverDragonMacroButton:GetAttribute("macrotext")
