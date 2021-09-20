--[[
	OrderHallIcon, replace the OrderHallDemandBar
	Siweia
]]
-- Configure
local DefaultPoint = {"TOP", 0, -20}

-- Class and Colors
local MyClass = select(2, UnitClass("player"))
local cc = RAID_CLASS_COLORS[MyClass]
local MyColor = format("|cff%02x%02x%02x", cc.r*255, cc.g*255, cc.b*255)

-- Style
local hall = CreateFrame("Frame", "OrderHallIcon", UIParent)
hall:SetSize(50, 50)
hall:SetPoint(unpack(DefaultPoint))
hall:SetMovable(true)
hall:SetUserPlaced(true)
hall:SetClampedToScreen(true)
hall:SetScript("OnMouseDown", function(self) self:StartMoving() end)
hall:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)

hall.Icon = hall:CreateTexture(nil, "ARTWORK")
hall.Icon:SetAllPoints()
hall.Icon:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
hall.Icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[strupper(MyClass)]))
hall.Category = {}

-- Function
local function RetrieveData(self)
	local currency = C_Garrison.GetCurrencyTypes(LE_GARRISON_TYPE_7_0)
	self.name, self.amount, self.texture = GetCurrencyInfo(currency)

	local categoryInfo = C_Garrison.GetClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
	self.numCategory = #categoryInfo
	for i, category in ipairs(categoryInfo) do
		self.Category[i] = {category.name, category.count, category.limit, category.description, category.icon}
	end
end

-- Event
hall:RegisterUnitEvent("UNIT_AURA", "player")
hall:RegisterEvent("PLAYER_ENTERING_WORLD")
hall:RegisterEvent("ADDON_LOADED")
hall:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "Blizzard_OrderHallUI" then
		OrderHallCommandBar:Hide()
		OrderHallCommandBar.Show = function() return end
		GarrisonLandingPageTutorialBox:SetClampedToScreen(true)
		self:UnregisterEvent("ADDON_LOADED")
	elseif event == "UNIT_AURA" or event == "PLAYER_ENTERING_WORLD" then
		local inOrderHall = C_Garrison.IsPlayerInGarrison(LE_GARRISON_TYPE_7_0)
		self:SetShown(inOrderHall)
	elseif event == "MODIFIER_STATE_CHANGED" and arg1 == "LSHIFT" then
		self:GetScript("OnEnter")(self)
	end
end)

hall:SetScript("OnEnter", function(self)
	C_Garrison.RequestClassSpecCategoryInfo(LE_FOLLOWER_TYPE_GARRISON_7_0)
	RetrieveData(self)

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	GameTooltip:ClearAllPoints()
	GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 5, -5)
	GameTooltip:ClearLines()
	GameTooltip:AddLine(MyColor.._G["ORDER_HALL_"..MyClass])
	GameTooltip:AddLine(" ")
	local icon = " |T"..self.texture..":12:12:0:0:64:64:4:60:4:60|t"
	GameTooltip:AddDoubleLine(self.name, self.amount..icon, 1,1,1, 1,1,1)
	local blank
	for i = 1, self.numCategory do
		if not blank then
			GameTooltip:AddLine(" ")
			blank = true
		end
		local name, count, limit, description, texture = unpack(self.Category[i])
		GameTooltip:AddDoubleLine(name, count.."/"..limit, 1,1,1, 1,1,1)
		if IsShiftKeyDown() then
			GameTooltip:AddLine(description, .6,.8,1,true)
		end
	end
	GameTooltip:AddDoubleLine(" ", "--------------", 1,1,1, .6,.8,1)
	GameTooltip:AddDoubleLine(" ", "按住 Shift 鍵顯示詳細內容", 1,1,1, .6,.8,1)
	GameTooltip:Show()

	self:RegisterEvent("MODIFIER_STATE_CHANGED")
end)

hall:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
	self:UnregisterEvent("MODIFIER_STATE_CHANGED")
end)