local addon = LibStub("AceAddon-3.0"):NewAddon("CursorCDtimer", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("CursorCDtimer")
local ACD = LibStub("AceConfigDialog-3.0")
local dbVersion = 1

local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)

addon:SetDefaultModuleState(false)
addon:SetDefaultModuleLibraries("AceEvent-3.0")

local defaults, options
local showRequests = {}

function addon:Show(name)
	showRequests[name] = true
	self.anchor:Show()
end

function addon:Hide(name)
	showRequests[name] = false
	
	local hide = true
	for _,v in pairs(showRequests) do
		if v then
			hide = false
		end
	end
	if hide then
		self.anchor:Hide()
	end
end

function addon:InitializeDefaults()
	defaults = {
		profile = {
			offset = {
				x = 12,
				y = -12
			},
			position = {
				x = 400,
				y = 400
			},
			attachToMouse = true,
			talentSpecs = {true, true, true, true},
			modules = {}
		}
	}

	for name, module in self:IterateModules() do
		defaults.profile.modules[name] = true
	end
end

function addon:InitializeOptions()
	options = {
		name = L["CursorCDtimer"],
		type = "group",
		args = {
			unlock = {
				name = L["Unlock"],
				type = "execute",
				func = function() addon:Unlock() end,
				order = 1
			},
			info = {
				name = L["All specified colors are vertex colors! (see wowwiki.com)"],
				type = "description",
				order = 2
			},
			general = {
				name = L["General"],
				type = "group",
				args = {
					position = {
						name = L["Position"],
						type = "header",
						order = 0
					},
					mouse = {
						name = L["Attach to cursor"],
						type = "toggle",
						get = function(info) return self.db.profile.attachToMouse end,
						set = function(info,val)
								self.db.profile.attachToMouse = val
							end,
						order = 1
					},
					xOff = {
						name = L["Horizontal Offset"],
						type = "range",
						min = 0,
						max = 64,
						step = 1,
						disabled = function() return not self.db.profile.attachToMouse end,
						get = function(info) return self.db.profile.offset.x end,
						set = function(info, val)
									self.db.profile.offset.x = val
                                    self:ApplyOptions()
								end,
						order = 2
					},
					yOff = {
						name = L["Vertical Offset"],
						type = "range",
						min = -64,
						max = 0,
						step = 1,
						disabled = function() return not self.db.profile.attachToMouse end,
						get = function(info) return self.db.profile.offset.y end,
						set = function(info, val)
									self.db.profile.offset.y = val
                                    self:ApplyOptions()
								end,
						order = 3
					},
					x = {
						name = L["Left"],
						type = "input",
						disabled = function() return self.db.profile.attachToMouse end,
						get = function(info) return tostring(self.db.profile.position.x) end,
						set = function(info, val)
									self.db.profile.position.x = tonumber(val)
									self:ApplyOptions()
								end,
						validate = function(_, value)
											if tonumber(value) then
												return true
											else
												return L["Left has to be a number!"]
											end
										end,
						order = 4
					},
					y = {
						name = L["Bottom"],
						type = "input",
						disabled = function() return self.db.profile.attachToMouse end,
						get = function(info) return tostring(self.db.profile.position.y) end,
						set = function(info, val)
									self.db.profile.position.y = tonumber(val)
									self:ApplyOptions()
								end,
						validate = function(_, value)
											if tonumber(value) then
												return true
											else
												return L["Bottom has to be a number!"]
											end
										end,
						order = 5
					},
					specs = {
						name = L["Talent Specs"],
						type = "header",
						order = 10
					},
					primary = {
						name = function() return select(2, GetSpecializationInfo(1)) end,--L["Primary"],
						type = "toggle",
						get = function(info) return self.db.profile.talentSpecs[1] end,
						set = function(info,val)
								self.db.profile.talentSpecs[1] = val
								self:ACTIVE_TALENT_GROUP_CHANGED()
							end,
						order = 11
					},
					secondary = {
						name = function() return select(2, GetSpecializationInfo(2)) end,
						type = "toggle",
						get = function(info) return self.db.profile.talentSpecs[2] end,
						set = function(info,val)
								self.db.profile.talentSpecs[2] = val
								self:ACTIVE_TALENT_GROUP_CHANGED()
							end,
						order = 12
					},
					tertiary = {
						name = function() return select(2, GetSpecializationInfo(3)) end,
						type = "toggle",
						disabled = function() return GetNumSpecializations() < 3 end,
						get = function(info) return self.db.profile.talentSpecs[3] end,
						set = function(info,val)
								self.db.profile.talentSpecs[3] = val
								self:ACTIVE_TALENT_GROUP_CHANGED()
							end,
						order = 13
					},
					quaternary = {
						name = function() return select(2, GetSpecializationInfo(4)) end,
						type = "toggle",
						disabled = function() return GetNumSpecializations() < 4 end,
						get = function(info) return self.db.profile.talentSpecs[4] end,
						set = function(info,val)
								self.db.profile.talentSpecs[4] = val
								self:ACTIVE_TALENT_GROUP_CHANGED()
							end,
						order = 14
					},
                    icon = {
                        type = "toggle",
                        name = L["Minimap Icon"],
                        desc = L["Enable the minimap icon."],
                        get = function()
                            return not self.db.MinimapIcon.hide
                        end,
                        set = function(info, val)
                            self.db.MinimapIcon.hide = not val
                            if not val then
                                LDBIcon:Hide("CCDT")
                            else
                                LDBIcon:Show("CCDT")
                            end
                        end,
                        order = 20,
                    },
				},
				order = 10
			}
		}
	}
	local i = 2
	for name, module in self:IterateModules() do
		local modOptions = module:GetOptions()
		modOptions.order = i*10
		modOptions.args.enabled = {
			name = L["Enabled"],
			type = "toggle",
			get = function(info) return self.db.profile.modules[name] end,
			set = function(info,val)
					self.db.profile.modules[name] = val
					if val then
						self:GetModule(name):Enable()
					else
						self:GetModule(name):Disable()
					end
				end,
			order = 0
		}
		options.args[name] = modOptions
		i = i + 1
	end
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
end

local function OnUpdate(self, elapsed)
	local x, y, xOff, yOff
	if addon.db.profile.attachToMouse then
		x, y = GetCursorPosition(UIParent);
		x = x + addon.db.profile.offset.x
		y = y + addon.db.profile.offset.y
	else
		x, y = addon.db.profile.position.x, addon.db.profile.position.y
	end
	self:ClearAllPoints()
	self:SetPoint('CENTER', UIParent, 'BOTTOMLEFT', x / self:GetEffectiveScale(), y / self:GetEffectiveScale())
end

function addon:FixDatabase()
	if not self.db.profile.version then -- first time logging in OR unversioned database
		if self.db.char  then -- unversioned database
			if self.db.char.attachToMouse ~= nil then
				self.db.profile.attachToMouse = self.db.char.attachToMouse
			end
			if self.db.char.talentSpecs then
				if self.db.char.talentSpecs[1] ~= nil then
					self.db.profile.talentSpecs.primary = self.db.char.talentSpecs[1]
				end
				if self.db.char.talentSpecs[2] ~= nil then
					self.db.profile.talentSpecs.secondary = self.db.char.talentSpecs[2]
				end
				if self.db.char.talentSpecs[3] ~= nil then
					self.db.profile.talentSpecs.secondary = self.db.char.talentSpecs[3]
				end
				if self.db.char.talentSpecs[4] ~= nil then
					self.db.profile.talentSpecs.secondary = self.db.char.talentSpecs[4]
				end
			end
			for i,v in pairs(self.db.profile.modules) do
				if self.db.char.modules and self.db.char.modules[i] ~= nil then
					self.db.profile.modules[i] = self.db.char.modules[i]
				end
			end
			self.db.char = nil
			self.db.profile.version = 1
		end
	end
	if self.db.profile.version then
		-- nothing to do yet
	end
	self.db.profile.version = dbVersion
end

function addon:OnInitialize()
	self:InitializeDefaults()
	self.db = LibStub("AceDB-3.0"):New("GCDDB", defaults)
	self:FixDatabase()
	
	self:InitializeOptions()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("CursorCDtimer", options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("CursorCDtimer", L["CursorCDtimer"])
	ACD:SetDefaultSize("CursorCDtimer", 640, 480)
	self:RegisterChatCommand("CursorCdtimer", self.OpenConfig)
	if LDB then
        local CCDToptions = LDB:NewDataObject("CursorCDtimer", {
            type = "launcher",
            icon = "Interface\\AddOns\\CursorCDtimer\\Textures\\CursorCDtimer",
            OnClick = function(clickedframe, button)
                addon:OpenConfig()
            end,
            OnTooltipShow = function(tt)
                tt:AddLine(L["CursorCDtimer"])
                tt:AddLine(" ")
                tt:AddLine("|cffffff00" .. L["Click|r to open the CursorCDtimer window"])
            end,
        })
        if not self.db.MinimapIcon then
            self.db.MinimapIcon = {
                hide = true,
                minimapPos = 220,
                radius = 80,
            }
        end
        if LDBIcon then
            LDBIcon:Register("CCDT", CCDToptions, self.db.MinimapIcon)
            self.db.MinimapIcon.hide = not val
            if not val then
                LDBIcon:Hide("CCDT")
            end
        end
    end
end

function addon:OnEnable()
	self:ApplyOptions()
	local activeSpec = GetSpecialization()
	if (self.db.profile.talentSpecs[activeSpec]) then
		for name, _ in self:IterateModules() do
			if self.db.profile.modules[name] then
				self:EnableModule(name)
			end
		end
	end
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	return true
end

function addon:OnDisable()
	if self.anchor then self.anchor:Hide() end
	for _, module in self:IterateModules() do
		if module:IsEnabled() then
			module:Disable()
		end
	end
	self:UnregisterAllEvents()
	return true
end

function addon:ACTIVE_TALENT_GROUP_CHANGED()
	local activeSpec = GetSpecialization()
	if (self.db.profile.talentSpecs[activeSpec]) then
		self:OnEnable()
	else
		self:OnDisable()
		self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	end
end

function addon:ApplyOptions()
	local anchor = self.anchor or CreateFrame("Frame")
	anchor:Hide()
	anchor:ClearAllPoints()
	anchor:SetFrameStrata("HIGH")
	anchor:SetScript('OnUpdate', OnUpdate)
	anchor:SetWidth(64)
	anchor:SetHeight(64)
	
	self.anchor = anchor
	
	local activeSpec = GetSpecialization()
	if (self.db.profile.talentSpecs[activeSpec]) then
		for name, _ in self:IterateModules() do
			if self.db.profile.modules[name] then
				self:EnableModule(name)
			else
				self:DisableModule(name)
			end
		end
	end
end

function addon:OpenConfig()
	ACD:Open("CursorCDtimer")
end

--[[
		Unlock
]]

local cursorBackdrop = {bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
							edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
							tile = true, tileSize = 16, edgeSize = 16, 
							insets = { left = 4, right = 4, top = 4, bottom = 4 }}
local cursorFrame

function addon:Unlock()
	local unlocked = false
	for name, module in self:IterateModules() do
		if self.db.profile.modules[name] and module.Unlock then
			unlocked = true
		end
	end
	if unlocked then
		local cursor = cursorFrame or CreateFrame("Frame")
		cursor:SetWidth(20)
		cursor:SetHeight(20)
		cursor:SetBackdrop(cursorBackdrop)
		cursor:SetBackdropColor(255,0,0,1)
		cursor:SetFrameStrata('HIGH')
		cursor:SetPoint("CENTER", UIParent, "BOTTOMLEFT", self.db.profile.position.x / cursor:GetEffectiveScale(), self.db.profile.position.y / cursor:GetEffectiveScale())
		cursor:SetScript("OnMouseDown", cursor.StartMoving)
		cursor:SetScript("OnMouseUp", function(self, button)
											self:StopMovingOrSizing()
											if button == "RightButton" then
												local x, y = self:GetCenter()
												addon.db.profile.position.x, addon.db.profile.position.y = x, y
												self:Hide()
												for name, module in addon:IterateModules() do
													if addon.db.profile.modules[name] and module.Lock then
														module:Lock()
													end
												end
											end
										end)
		cursor:SetScript("OnEnter", function(self)
										GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
										GameTooltip:SetText(L["Right Click"])
										GameTooltip:AddLine(L["to lock the icons and save their positions"], 1, 1, 1)
										GameTooltip:Show()
									end)
		cursor:SetScript("OnLeave", function(self)
										GameTooltip:Hide()
									end)
		cursor:SetMovable(true)
		cursor:EnableMouse(true)
		cursor:Show()
		
		for name, module in self:IterateModules() do
			if self.db.profile.modules[name] and module.Unlock then
				module:Unlock(cursor)
			end
		end
		
		ACD:Close("CursorCDtimer")
		return true
	else
		return L["All unlockable modules are disabled!"]
	end
end
