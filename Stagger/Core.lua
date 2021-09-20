-------------------------
-- Stagger, by Siweia
-------------------------
local _, ns = ...
local cfg = ns.cfg
if cfg.MyClass ~= "MONK" then return end
local cr, cg, cb = cfg.cc.r, cfg.cc.g, cfg.cc.b

-- APIs
local CreateBD = function(f, a, s)
	f:SetBackdrop({
		bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = cfg.glowTex, edgeSize = s or 3,
		insets = {left = s or 3, right = s or 3, top = s or 3, bottom = s or 3},
	})
	f:SetBackdropColor(0, 0, 0, a or .5)
	f:SetBackdropBorderColor(0, 0, 0)
end

local CreateSD = function(f, m, s, n)
	if f.Shadow then return end
	f.Shadow = CreateFrame("Frame", nil, f)
	f.Shadow:SetPoint("TOPLEFT", f, -m, m)
	f.Shadow:SetPoint("BOTTOMRIGHT", f, m, -m)
	f.Shadow:SetBackdrop({
		edgeFile = cfg.glowTex, edgeSize = s })
	f.Shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.Shadow:SetFrameLevel(n or f:GetFrameLevel())
	return f.Shadow
end

local CreateIF = function(f)
	CreateSD(f, 3, 3)
	f.Icon = f:CreateTexture(nil, "ARTWORK")
	f.Icon:SetAllPoints()
	f.Icon:SetTexCoord(unpack(cfg.TexCoord))
	f.CD = CreateFrame("Cooldown", nil, f, "CooldownFrameTemplate")
	f.CD:SetAllPoints()
	f.CD:SetReverse(true)
end

local CreateSB = function(f, spark)
	f:SetStatusBarTexture(cfg.normTex)
	f:SetStatusBarColor(cr, cg, cb)
	CreateSD(f, 3, 3)
	f.BG = f:CreateTexture(nil, "BACKGROUND")
	f.BG:SetAllPoints()
	f.BG:SetTexture(cfg.normTex)
	f.BG:SetVertexColor(cr, cg, cb, .2)
	if spark then
		f.Spark = f:CreateTexture(nil, "OVERLAY")
		f.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		f.Spark:SetBlendMode("ADD")
		f.Spark:SetAlpha(.8)
		f.Spark:SetPoint("TOPLEFT", f:GetStatusBarTexture(), "TOPRIGHT", -10, 10)
		f.Spark:SetPoint("BOTTOMRIGHT", f:GetStatusBarTexture(), "BOTTOMRIGHT", 10, -10)
	end
end

local SetMover = function(Frame, Text, key, Pos, w, h)
	if not MoverDB[key] then MoverDB[key] = {} end
	local Mover = CreateFrame("Frame", nil, UIParent)
	Mover:SetWidth(w or Frame:GetWidth())
	Mover:SetHeight(h or Frame:GetHeight())
	CreateBD(Mover)
	Mover.Text = Mover:CreateFontString(nil, "OVERLAY")
	Mover.Text:SetFont(unpack(cfg.Font))
	Mover.Text:SetPoint("CENTER")
	Mover.Text:SetText(Text)
	if not MoverDB[key]["Mover"] then 
		Mover:SetPoint(unpack(Pos))
	else
		Mover:SetPoint(unpack(MoverDB[key]["Mover"]))
	end
	Mover:EnableMouse(true)
	Mover:SetMovable(true)
	Mover:SetClampedToScreen(true)
	Mover:SetFrameStrata("HIGH")
	Mover:RegisterForDrag("LeftButton")
	Mover:SetScript("OnDragStart", function(self) Mover:StartMoving() end)
	Mover:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		local AnchorF, _, AnchorT, X, Y = self:GetPoint()
		MoverDB[key]["Mover"] = {AnchorF, "UIParent", AnchorT, X, Y}
	end)
	Mover:Hide()
	Frame:SetPoint("TOPLEFT", Mover)
	return Mover
end

local Numb = function(n)
	if (n >= 1e4) then
		return ("%.1f萬"):format(n / 1e4)				  
	else
		return ("%.0f"):format(n)
	end
end

local CreateFS = function(f, size, text, classcolor, anchor, x, y)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(cfg.Font[1], size, cfg.Font[3])
	fs:SetText(text)
	fs:SetWordWrap(false)
	if classcolor then
		fs:SetTextColor(cr, cg, cb)
	end
	if (anchor and x and y) then
		fs:SetPoint(anchor, x, y)
	else
		fs:SetPoint("CENTER", 1, 0)
	end
	return fs
end

-- Style
local IconSize = cfg.IconSize
local bu, bar = {}
local function StaggerGo()
	if bar then bar:Show() return end

	bar = CreateFrame("StatusBar", "NDui_Stagger", UIParent)
	bar:SetSize(IconSize*4 + 15, cfg.BarHeight)
	bar:SetPoint("CENTER", 0, -200)
	bar:SetFrameStrata("HIGH")
	CreateSB(bar, true)
	bar:SetMinMaxValues(0, 100)
	bar:SetValue(0)
	bar.Count = CreateFS(bar, 16, "", false, "TOPRIGHT", 0, -7)

	local spells = {214326, 115072, 115308, 124275}
	for i = 1, 4 do
		bu[i] = CreateFrame("Frame", nil, UIParent)
		bu[i]:SetSize(IconSize, IconSize)
		bu[i]:SetFrameStrata("HIGH")
		CreateIF(bu[i])
		bu[i].Icon:SetTexture(GetSpellTexture(spells[i]))
		bu[i].Count = CreateFS(bu[i], 16, "")
		bu[i].Count:SetPoint("BOTTOMRIGHT", 4, -2)
		if i == 1 then
			bu[i]:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", 0, 5)
		else
			bu[i]:SetPoint("LEFT", bu[i-1], "RIGHT", 5, 0)
		end
	end

	local Mover = SetMover(bar, NPE_MOVE, "Stagger", cfg.StaggerPos, bar:GetWidth(), 20)
	SlashCmdList["STAGGER"] = function(msg)
		if InCombatLockdown() then return end
		if msg:lower() == "reset" then
			wipe(MoverDB["Stagger"])
			ReloadUI()
		else
			if Mover:IsVisible() then
				Mover:Hide()
			else
				Mover:Show()
			end
		end
	end
	SLASH_STAGGER1 = "/stg"
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_TALENT_UPDATE")
f:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" or event == "PLAYER_TALENT_UPDATE" then
		if GetSpecializationInfo(GetSpecialization()) == 268 then
			StaggerGo()
			bar:SetAlpha(cfg.FadeAlpha)
			for i = 1, 4 do
				bu[i]:Show()
				bu[i]:SetAlpha(cfg.FadeAlpha)
			end

			f:RegisterUnitEvent("UNIT_AURA", "player")
			f:RegisterEvent("UNIT_MAXHEALTH")
			f:RegisterEvent("SPELL_UPDATE_COOLDOWN")
			f:RegisterEvent("SPELL_UPDATE_CHARGES")
		else
			if bar then bar:Hide() end
			for i = 1, 4 do
				if bu[i] then bu[i]:Hide() end
			end

			f:UnregisterEvent("UNIT_AURA")
			f:UnregisterEvent("UNIT_MAXHEALTH")
			f:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
			f:UnregisterEvent("SPELL_UPDATE_CHARGES")
		end
	else
		-- Exploding Keg
		if IsPlayerSpell(214326) then
			local start, duration = GetSpellCooldown(214326)
			if start and duration > 1.5 then
				bu[1]:SetAlpha(cfg.FadeAlpha)
				bu[1].CD:SetCooldown(start, duration)
			else
				bu[1]:SetAlpha(1)
				bu[1].CD:SetCooldown(0, 0)
			end
		else
			bu[1]:SetAlpha(cfg.FadeAlpha)
			bu[1].CD:SetCooldown(0, 0)
		end

		-- Expel Harm
		do
			local count = GetSpellCount(115072)
			bu[2].Count:SetText(count)
			if count > 0 then
				bu[2]:SetAlpha(1)
			else
				bu[2]:SetAlpha(cfg.FadeAlpha)
			end
		end

		-- Ironskin Brew
		do
			local name, _, _, _, _, dur, exp = UnitBuff("player", GetSpellInfo(215479))
			local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(115308)
			local start, duration = GetSpellCooldown(115308)
			bu[3].Count:SetText(charges)
			if name then
				bu[3].Count:ClearAllPoints()
				bu[3].Count:SetPoint("TOP", 0, 18)
				bu[3]:SetAlpha(1)
				ClearChargeCooldown(bu[3])
				bu[3].CD:SetReverse(true)
				bu[3].CD:SetCooldown(exp - dur, dur)
				ActionButton_ShowOverlayGlow(bu[3])
			else
				bu[3].Count:ClearAllPoints()
				bu[3].Count:SetPoint("BOTTOMRIGHT", 4, -2)
				bu[3].CD:SetReverse(false)
				if charges < maxCharges and charges > 0 then
					StartChargeCooldown(bu[3], chargeStart, chargeDuration)
					bu[3].CD:SetCooldown(0, 0)
				elseif start and duration > 1.5 then
					ClearChargeCooldown(bu[3])
					bu[3].CD:SetCooldown(start, duration)
				elseif charges == maxCharges then
					bu[3]:SetAlpha(cfg.FadeAlpha)
					ClearChargeCooldown(bu[3])
					bu[3].CD:SetCooldown(0, 0)
				end
				ActionButton_HideOverlayGlow(bu[3])
			end
		end

		-- Stagger
		do
			local Per
			local name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, _, _, value = UnitAura("player", GetSpellInfo(124275), "", "HARMFUL")
			if (not name) then name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, _, _, value = UnitAura("player", GetSpellInfo(124274), "", "HARMFUL") end
			if (not name) then name, _, icon, _, _, duration, expire, _, _, _, _, _, _, _, _, _, value = UnitAura("player", GetSpellInfo(124273), "", "HARMFUL") end
			if name and value > 0 and duration > 0 then
				Per = UnitStagger("player") / UnitHealthMax("player") * 100
				bar:SetAlpha(1)
				bu[4]:SetAlpha(1)
				bu[4].Icon:SetTexture(icon)
				bu[4].CD:SetCooldown(expire - 10, 10)
			else
				value = 0
				Per = 0
				bar:SetAlpha(cfg.FadeAlpha)
				bu[4]:SetAlpha(cfg.FadeAlpha)
				bu[4].Icon:SetTexture(GetSpellTexture(124275))
				bu[4].CD:SetCooldown(0, 0)
			end
			bar:SetValue(Per)
			bar.Count:SetText(cfg.InfoColor..Numb(value).." "..cfg.MyColor..Numb(Per).."%")
			if UnitAura("player", GetSpellInfo(124273), "", "HARMFUL") then
				ActionButton_ShowOverlayGlow(bu[4])
			else
				ActionButton_HideOverlayGlow(bu[4])
			end
		end
	end

	if not InCombatLockdown() then
		if bar then bar:SetAlpha(cfg.OOCAlpha) end
		for i = 1, 4 do
			if bu[i] then bu[i]:SetAlpha(cfg.OOCAlpha) end
		end
	end
end)