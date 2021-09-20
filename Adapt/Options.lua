local _,adapt = ...
local opt = AdaptOptions -- the InterfaceOptionsPanel frame
local settings

local defaults = {
	Shape = 1, -- 1=Round, 2=Square
	Zoom = 1, -- 1=Head, 2=Torso, 3=Full
	Back = 2, -- 1=Specific Color, 2=Class Color
	BackColor = {r=0.5, g=0.5, b=0.5, a=0.5}, -- the default background color
	UseMask = true, -- whether to show "mask" overlay for round portraits
	TrueInset = false, -- whether to bring in corners of round portraits
	HideAnon = false, -- true if anonymous portraits should not be animated
	Blacklist = {}, -- list of named portraits to not animate
}

opt.blacklistCandidates = {} -- list of named frames encountered for potential blacklisting

function adapt:InitOptions()
	adapt:ValidateSavedVariables()
	opt.refresh = function()
		SetPortraitTexture(opt.Portrait,"player")
		adapt:OptionsUpdateBlacklistCandidates()
		adapt:OptionsUpdate()
	end
	-- following line fixes a bug in legion where first rendering won't show (or first walkway run); TODO: find out why
	opt:SetScript("OnShow",function() C_Timer.After(0,adapt.RefreshAll) opt:SetScript("OnShow",nil) end)
end

-- updates SavedVariables and sets up defaults if needed
function adapt:ValidateSavedVariables()
	if type(AdaptSettings)~="table" then
		AdaptSettings = {}
	end
	settings = AdaptSettings

	-- go through each default and make sure setting has something for it
	for defaultKey,defaultValue in pairs(defaults) do
		local defaultType = type(defaultValue)
		if defaultType~=type(settings[defaultKey]) then
			if defaultType=="table" then
				settings[defaultKey] = {}
			else
				settings[defaultKey] = defaultValue
			end
		end
		-- for table values copy default values if the settings' table is empty
		if defaultType=="table" and not next(settings[defaultKey]) then
			for subKey,subValue in pairs(defaultValue) do
				settings[defaultKey][subKey] = subValue
			end
		end
	end
	-- now remove any old settings that are no longer relevant
	for settingsKey in pairs(settings) do
		if defaults[settingsKey]==nil then -- some default[]s are false (so explicitly check for nil)
			settings[settingsKey] = nil
		end
	end
end

-- the .refresh function for the InterfaceOptionPanel (called by UI when options UI first opened)
-- also called whenever any setting changes from within the options UI
function adapt:OptionsUpdate()
	-- update radio buttons
	for _,var in pairs({"Shape","Zoom","Back"}) do
		for i,checkbutton in ipairs(opt[var]) do
			checkbutton:SetChecked(settings[var]==i)
		end
	end
	-- enable/disable UseMask and TrueInset checkbuttons depending on whether Shape==1 (round)
	local round = settings.Shape==1
	local color = round and 1 or 0.5
	for _,var in pairs({"UseMask","TrueInset"}) do
		opt[var]:SetEnabled(round)
		opt[var].Text:SetTextColor(color,color,color)
	end
	-- update checkbuttons
	opt.UseMask:SetChecked(settings.UseMask)
	opt.HideAnon:SetChecked(settings.HideAnon)
	-- portrait border over portrait
	opt.PortraitBorder:SetTexture(settings.Shape==1 and "Interface\\AddOns\\Adapt\\CircleBorder" or "Interface\\AddOns\\Adapt\\SquareBorder")
	-- update color swatch
	local color = settings.BackColor
	opt.Back[1].Swatch.Color:SetVertexColor(color.r,color.g,color.b,color.a)
end

function adapt:OptionsRadioOnClick()
	if settings[self.radio]~=self:GetID() then
		settings[self.radio] = self:GetID()
		adapt:OptionsUpdate()
		if self.radio=="Zoom" then
			adapt:RefreshAll() -- for zoom setting we need to SetUnit again
		else -- for the rest of the options it's sufficient to update just shape and color
			adapt:ShapeAllModels()
			adapt:ColorAllBackLayers()
		end
	else -- if re-clicking a radio already checked, don't toggle its check
		self:SetChecked(true)
	end
end

function adapt:OptionsCheckOnClick()
	if self.variable then
		settings[self.variable] = self:GetChecked()
		adapt:OptionsUpdate()
		adapt:ShapeAllModels()
		adapt:ColorAllBackLayers()
		if self.variable=="HideAnon" then
			adapt:RefreshAll()
		end
	elseif self:GetParent()==opt.Blacklist then -- for blacklist check OnClicks, it's something in the blacklist
		local name = self.Text:GetText()
		settings.Blacklist[self.Text:GetText()] = self:GetChecked() or nil
		adapt:RefreshAll()
	end
end

function adapt:OptionsOnEnter()
	if self.tooltip then
		GameTooltip:SetOwner(self,"ANCHOR_LEFT")
		GameTooltip:AddLine(self.Text:GetText(),1,1,1)
		GameTooltip:AddLine(self.tooltip,1,0.82,0,true)
		GameTooltip:Show()
	end
end

--[[ Color Swatch ]]

function adapt:OptionsColorSwatchOnClick()
	local color = settings.BackColor
	ColorPickerFrame.func = adapt.OptionsBackColorChanged
	ColorPickerFrame.opacityFunc = adapt.OptionsBackColorChanged
	ColorPickerFrame.cancelFunc = adapt.OptionsBackColorCancelled
	ColorPickerFrame.hasOpacity = true
	ColorPickerFrame.opacity = 1-color.a
	ColorPickerFrame.previousValues = {r=color.r,g=color.g,b=color.b,a=color.a}
	ColorPickerFrame:SetColorRGB(color.r,color.g,color.b)
	ColorPickerFrame:Hide()
	ColorPickerFrame:Show()
end

function adapt:OptionsBackColorChanged()
	local r,g,b = ColorPickerFrame:GetColorRGB()
	local a = 1-OpacitySliderFrame:GetValue()
	adapt:OptionsUpdateColors(r,g,b,a)
end

function adapt.OptionsBackColorCancelled(color)
	adapt:OptionsUpdateColors(color.r,color.g,color.b,color.a)
end

-- changes BackColor (and the swatch color) to the passed r,g,b,a
function adapt:OptionsUpdateColors(r,g,b,a)
	opt.Back[1].Swatch.Color:SetVertexColor(r,g,b,a)
	settings.BackColor.r, settings.BackColor.g, settings.BackColor.b, settings.BackColor.a = r,g,b,a
	adapt:ColorAllBackLayers()
end

--[[ Blacklist ]]

-- populates opt.blacklistCandidates with named portraits seen and previously blacklisted
function adapt:OptionsUpdateBlacklistCandidates()
	-- add any portraits seen this session
	for texture,portrait in pairs(adapt.portraits) do
		local name = texture:GetName()
		if name and portrait.cx>adapt.minSize and texture~=AdaptOptionsPortrait and not adapt.forbid[name] and not tContains(opt.blacklistCandidates,name) then
			table.insert(opt.blacklistCandidates,name)
		end
	end
	-- now add any previously blacklisted portraits
	for name in pairs(settings.Blacklist) do
		if not adapt.forbid[name] and not tContains(opt.blacklistCandidates,name) then
			table.insert(opt.blacklistCandidates,name)
		end
	end
	table.sort(opt.blacklistCandidates)
	adapt:OptionsBlacklistScrollFrameUpdate()
end

-- updates the FauxScrollFrame with blacklistCandidates
function adapt:OptionsBlacklistScrollFrameUpdate()
	local data = opt.blacklistCandidates
	local numData = #opt.blacklistCandidates
	local scrollFrame = opt.Blacklist.ScrollFrame
	local numButtons = #opt.Blacklist.Buttons
	local offset = FauxScrollFrame_GetOffset(scrollFrame)
	FauxScrollFrame_Update(scrollFrame, numData, numButtons, 24)
	for i,button in ipairs(opt.Blacklist.Buttons) do
		local index = offset + i
		if index<=numData then
			button.Text:SetText(data[index])
			button:SetChecked(settings.Blacklist[data[index]] and true)
			button:Show()
		else
			button:Hide()
		end
	end
end

