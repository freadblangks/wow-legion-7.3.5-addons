local _,adapt = ...

Adapt = adapt -- global for access outside this addon
adapt.portraits = {} -- this is indexed by the original texture objects
adapt.runway = {} -- queue for models to be drawn
adapt.forbid = { -- these are texture names that we never attempt to set a portrait
	["AchievementFrameComparisonHeaderPortrait"] = true, -- appears as player portrait; TODO: why?
}
adapt.Blackcache = {} -- cache for blacklisted portraits
adapt.minSize = 30 -- minimum size for a portrait to be animated

adapt.main = CreateFrame("Frame",nil,UIParent)
adapt.main:Hide()
adapt.main:SetScript("OnEvent",function(self,event,unit)
	if event=="UNIT_MODEL_CHANGED" then
		for texture,portrait in pairs(adapt.portraits) do
			if portrait.unit==unit then
				adapt.AddToRunway(texture,"low")
			end
		end
	elseif (event=="PLAYER_UNGHOST" or (event=="UNIT_EXITED_VEHICLE" and unit=="player")) and PlayerPortrait and adapt.portraits[PlayerPortrait] then
		-- for client bug with sliding PlayerPortrait when exiting vehicles (model set, not rendered)
		-- also new bug in legion when "dismounting" from "leap" from "skyhold" (the flickering explody model never ends with a UNIT_MODEL_CHANGED)
		C_Timer.After(0.5,function() adapt.AddToRunway(PlayerPortrait,"low") end)
	elseif event=="UI_SCALE_CHANGED" or event=="DISPLAY_SIZE_CHANGED" then
		adapt:RefreshAll()
	elseif event=="PLAYER_LOGIN" then
		adapt:InitOptions()
		adapt.UpdateBlackcache()
		hooksecurefunc("SetPortraitTexture",adapt.NewSetPortraitTexture)
		self:SetScript("OnUpdate",adapt.WalkRunway)
		self:RegisterEvent("UNIT_MODEL_CHANGED")
		self:RegisterEvent("UNIT_EXITED_VEHICLE")
		self:RegisterEvent("UI_SCALE_CHANGED")
		self:RegisterEvent("DISPLAY_SIZE_CHANGED")
		self:RegisterEvent("PLAYER_UNGHOST")
	end
end)
adapt.main:RegisterEvent("PLAYER_LOGIN")

-- when priority is "high" (guid change), SetUnit will happen on next frame
-- for low priority updates (UNIT_MODEL_CHANGED), we can afford to wait
function adapt.AddToRunway(texture,priority)
	if adapt.runway[texture]=="high" then
		return -- already here on high priority
	end
	adapt.runway[texture] = priority
	adapt.main.timer = 0
	adapt.main:Show()
end

function adapt.WalkRunway(self,elapsed)
	-- process high priority updates right away
	for texture,priority in pairs(adapt.runway) do
		if priority=="high" then
			adapt.SetUnit(texture)
			adapt.runway[texture] = nil
		end
	end
	self.timer = self.timer + elapsed
	if self.timer > .25 then
		for texture,priority in pairs(adapt.runway) do
			adapt.SetUnit(texture)
		end
		self:Hide()
		self.timer = 0
		wipe(adapt.runway) -- show is over!
	end
end

function adapt.UpdateBlackcache()
	wipe(adapt.Blackcache)
	for texture in pairs(AdaptSettings.Blacklist) do
		if _G[texture] then
			adapt.Blackcache[_G[texture]] = 1
		end
	end
end

-- primary hook. when SetPortraitTexture happens, this function is also called
-- and creates a model to take its place.
function adapt.NewSetPortraitTexture(texture,unit)
	if UnitExists(unit) and not adapt.Blackcache[texture] and not adapt.forbid[texture:GetName()] then
		local portrait = adapt.portraits[texture]
		if not portrait then
			portrait = adapt.CreateModel(texture,unit)
			adapt.SetUnit(texture) -- for first-time models, kick off first update
		end
		local guid = UnitGUID(unit)
		if guid~=portrait.guid then
			adapt.AddToRunway(texture,"high")
		end
		portrait.guid = guid
	end
end

-- creates a model to mimic the intended texture and unit
function adapt.CreateModel(texture,unit)

	adapt.portraits[texture] = {}
	local portrait = adapt.portraits[texture]

	-- store attributes of the original texture we'll need later
	portrait.unit = unit
	local drawLayer = texture:GetDrawLayer()
	portrait.cx = texture:GetWidth()
	portrait.cy = texture:GetHeight()

	-- create a backLayer whose parent is the old texture's parent
	portrait.backLayer = texture:GetParent():CreateTexture(nil,drawLayer=="OVERLAY" and "ARTWORK" or drawLayer)
	portrait.backLayer:Hide()
	portrait.backLayer:SetTexture("Interface\\AddOns\\Adapt\\Adapt-ModelBack")
	portrait.backLayer:SetWidth(portrait.cx)
	portrait.backLayer:SetHeight(portrait.cy)
	for i=1,texture:GetNumPoints() do
		portrait.backLayer:SetPoint(texture:GetPoint(i))
	end

	-- create a modelLayer whose parent is the old texture's parent, with useParentLevel="true"
	portrait.modelLayer = CreateFrame("PlayerModel",nil,texture:GetParent(),"AdaptModelLevelTemplate")
	portrait.modelLayer:Hide()
	portrait.modelLayer.parentTexture = texture

	portrait.maskLayer = texture:GetParent():CreateTexture(nil,"OVERLAY",nil,-8)
	portrait.maskLayer:SetPoint("TOPLEFT",portrait.backLayer)
	portrait.maskLayer:SetPoint("BOTTOMRIGHT",portrait.backLayer)
	portrait.maskLayer:SetTexture("Interface\\AddOns\\Adapt\\Adapt-Mask")

	local parent = texture:GetParent()
	parent.adaptPortrait = adapt.portraits[texture]
	parent:HookScript("OnShow",function(self) adapt.AddToRunway(self.adaptPortrait.modelLayer.parentTexture,"high") end)

	adapt.ShapeModel(texture)

	return adapt.portraits[texture]
end

-- when shown, models sometimes need their camera reset
function adapt.ModelOnShow(self)
	local parent = self.parentTexture
	if adapt.portraits[parent] then
		adapt.AddToRunway(parent,"high")
	end
end

-- draws the unit for a texture which is now a model
function adapt.SetUnit(texture)
	local portrait = adapt.portraits[texture]
	local unit = portrait.unit
	local parent = texture:GetParent()

	local textureName = texture:GetName()
	if unit and UnitIsVisible(unit) and parent:IsVisible() and (not parent.unit or parent.unit==unit) and (not AdaptSettings.HideAnon or textureName) and (not textureName or not AdaptSettings.Blacklist[textureName]) and portrait.cx>=adapt.minSize then
--		print("adapt SetUnit",unit,GetTime())
		portrait.modelLayer:SetUnit(unit)
		portrait.modelLayer:SetAnimation(804) -- 804 is StandCharacterCreate to make character stand without idle animations
		adapt.SetCamera(texture)
		adapt.ColorBackLayer(texture,unit)
		portrait.backLayer:Show()
		portrait.modelLayer:Show()
		portrait.maskLayer:SetShown(AdaptSettings.Shape==1 and AdaptSettings.UseMask)
		texture:Hide()
	else
		portrait.backLayer:Hide()
		portrait.modelLayer:Hide()
		portrait.maskLayer:Hide()
		texture:Show()
	end
end

function adapt.ShapeModel(texture)
	local portrait = adapt.portraits[texture]
	local xoff,yoff,toff = 0,0,0.2
	if AdaptSettings.Shape==1 then -- round portraits
		-- old coefficient was 0.0985 but corners stuck out; they stop at 0.1175 but clip too much imho :(
		local coeff = AdaptSettings.TrueInset and 0.16 or 0.1175
		xoff = coeff*portrait.cx -- circle portrait has model slightly smaller
		yoff = coeff*portrait.cy
		toff = 0 -- and full texcoord of background texture
	end
	portrait.modelLayer:SetPoint("TOPLEFT",portrait.backLayer,"TOPLEFT",xoff,-yoff)
	portrait.modelLayer:SetPoint("BOTTOMRIGHT",portrait.backLayer,"BOTTOMRIGHT",-xoff,yoff)
	portrait.backLayer:SetTexCoord(toff,1-toff,toff,1-toff)
	portrait.maskLayer:SetShown(AdaptSettings.Shape==1 and AdaptSettings.UseMask)
	if AdaptSettings.Zoom==2 then
		portrait.modelLayer:SetRotation(MODELFRAME_DEFAULT_ROTATION)
	else
		portrait.modelLayer:SetRotation(0)
	end
end

function adapt.ShapeAllModels()
	for texture in pairs(adapt.portraits) do
		adapt.ShapeModel(texture)
	end
end

function adapt.SetCamera(texture)
	local zoom = AdaptSettings.Zoom==3 and 0.33 or AdaptSettings.Zoom==2 and 0.75 or 1
	adapt.portraits[texture].modelLayer:SetPortraitZoom(zoom)
end

function adapt.SetAllCameras()
	for texture,portrait in pairs(adapt.portraits) do
		adapt.SetCamera(texture)
	end
end

function adapt.ColorBackLayer(texture,unit)
	unit = unit or adapt.portraits[texture].unit
	local color,mute = AdaptSettings.BackColor,1
	if AdaptSettings.Back==2 then
		color,mute = RAID_CLASS_COLORS[select(2,UnitClass(unit))],0.65
	end
	local r,g,b,a
	if color then
		r,g,b,a = color.r*mute,color.g*mute,color.b*mute,color.a or 1
	else
		r,g,b,a = 0.5,0.5,0.5,1
	end
	adapt.portraits[texture].backLayer:SetVertexColor(r,g,b,a)
	adapt.portraits[texture].maskLayer:SetVertexColor(r*0.75,g*0.75,b*0.75,a)
end

function adapt.ColorAllBackLayers()
	for texture in pairs(adapt.portraits) do
		adapt.ColorBackLayer(texture)
	end
end

function adapt.RefreshAll()
	adapt.ShapeAllModels()
	adapt.ColorAllBackLayers()
	for texture,portrait in pairs(adapt.portraits) do
		if portrait.modelLayer:GetParent():IsVisible() then
			adapt.AddToRunway(portrait.modelLayer.parentTexture,"high")
		end
	end
end

-- /adapt slash command to show options
SlashCmdList["ADAPT"] = function(msg)
	if msg=="debug" then
		print("__ Defined portraits __")
		for texture,portrait in pairs(adapt.portraits) do
			local model = tostring(portrait.modelLayer:GetDisplayInfo()) -- portrait.modelLayer:GetModel() or ""
			model = model:len()>1 and model:match(".+\\(.-)$") or ""
			print(texture:GetName() or "nil child of "..(texture:GetParent():GetName() or "nil"),"\""..model.."\"")
		end
	else
		InterfaceOptionsFrame_OpenToCategory("頭像-3D")
		if not AdaptOptionsPortrait:IsVisible() then -- need to go to it again if it didn't really open
			InterfaceOptionsFrame_OpenToCategory("頭像-3D")
		end
	end
end
SLASH_ADAPT1 = "/adapt"
