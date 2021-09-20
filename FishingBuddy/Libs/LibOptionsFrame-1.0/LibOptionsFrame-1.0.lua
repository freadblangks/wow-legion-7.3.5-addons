--[[
Name: LibOptionsFrame-1.0
Maintainers: Sutorix <sutorix@hotmail.com>
Description: Layout checkboxes and such in a frame.
Copyright (c) by The Software Cobbler
Licensed under a Creative Commons "Attribution Non-Commercial Share Alike" License
--]]

local MAJOR_VERSION = "LibOptionsFrame-1.0"
local MINOR_VERSION = 90000 + tonumber(("1000"):match("%d+"))

if not LibStub then error(MAJOR_VERSION .. " requires LibStub") end

local OptionsLib, oldLib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not OptionsLib then
	return
end

-- managed control support
local function Slider_OnLoad(self, info, height, width)
	self.info = info;
	self.textfield = _G[info.name.."Text"];
	_G[info.name.."High"]:SetText();
	_G[info.name.."Low"]:SetText();
	self:SetMinMaxValues(info.min, info.max);
	self:SetValueStep(info.step or 1);
	self:SetHeight(height or 17);
	self:SetWidth(width or 130);
end

local function Slider_OnShow(self)
	local where = FishingBuddy.GetSetting(self.info.setting);
	if (where) then
		self:SetValue(where);
		self.textfield:SetText(string.format(self.info.format, where));
	end
end

local function Slider_OnValueChanged(self)
	local where = self:GetValue();
	self.textfield:SetText(string.format(self.info.format, where));
	FishingBuddy.SetSetting(self.info.setting, where);
	if (self.info.action) then
		self.info.action(self);
	end
end

-- info contains
-- name
-- format -- how to print the value
-- min
-- max
-- step -- default to 1
-- rightextra -- extra room needed, if any
-- setting -- what this slider changes
function OptionsLib:CreateSlider(info)
	local s = _G[info.name];
	if (not s) then
		s = CreateFrame("Slider", info.name, nil, "OptionsSliderTemplate");
	end
	Slider_OnLoad(s, info);
	s:SetScript("OnShow", Slider_OnShow);
	s:SetScript("OnValueChanged", Slider_OnValueChanged);
	s.info = info
	return s;
end

local function ParentValue(button)
	local value = true;
	if ( button.parents ) then
		for _,b in pairs(button.parents) do
			if ( b.checkbox and not b:GetChecked() ) then
				value = false;
			end
		end
	end
	return value;
end

local function ParentEnabled(button)
	if ( button.parents ) then
		for _,b in pairs(button.parents) do
			if ( not b:IsEnabled() ) then
				return false;
			end
		end
	end
	if ( button.controlled ) then
		for _,b in pairs(button.controlled) do
			if ( not b:GetChecked() ) then
				return false;
			end
		end
	end
	return true;
end

-- we only set value if we need to force a behavior
local function CheckBox_Able(button, value)
	if ( not button ) then
		return;
	end
	if ( value == nil ) then
		value = ParentValue(button);
	end
	local color;
	if ( value ) then
		if (button.checkbox) then
			button:Enable();
		end
		color = NORMAL_FONT_COLOR;
		if (button.overlay) then
			button.overlay:Hide();
		end
	else
		if ( button.checkbox ) then
			button:Disable();
		end
		if (button.overlay) then
			button.overlay:ClearAllPoints();
			button.overlay:SetPoint("TOPLEFT", button.label, "TOPLEFT");
			button.overlay:SetSize(button:GetWidth(), button:GetHeight());
			button.overlay:SetFrameLevel(button:GetFrameLevel()+2);
			button.overlay:Show();
		end
		color = GRAY_FONT_COLOR;
	end
	local text = _G[button:GetName().."Text"];
	if ( text ) then
		text:SetTextColor(color.r, color.g, color.b);
	end
end

local function hideOrDisable(button, what)
	local enabled = ParentEnabled(button);
	local value = false;
	
	if ( enabled ) then
		if ( type(what) == "function" ) then
			what, value = what();
		else
			value =	ParentValue(button);
		end
	else
		what = "d";
	end
	-- "i" means ignore, but since we check explicitly...
	if ( what == "d" ) then
		CheckBox_Able(button, value);
	elseif ( what == "h" ) then
		 button:Hide();
		 if ( value  ) then
			if ( not button.visible or button.visible(button.option) ) then
				button:Show();
			end
		end
	end
end

local copyfuncs = {};

function OptionsLib:GetFrameInfo(f)
	local n;
	if ( type(f) == "string" ) then
		n = f;
		f = _G[f];
	else
		n = f:GetName();
	end
	return f, n;
end
tinsert(copyfuncs, "GetFrameInfo");

function OptionsLib:HandleDeps(parent)
	local value = (not parent.checkbox or parent:GetChecked());
	if ( parent.children ) then
		for dep,what in pairs(parent.children) do
			hideOrDisable(dep, what);
			self:HandleDeps(dep);
		end
	end
	
	if ( parent.controls ) then
		for dep,what in pairs(parent.controls) do
			hideOrDisable(dep, what);
			self:HandleDeps(dep);
		end
	end
end
tinsert(copyfuncs, "HandleDeps");

local overlaybuttons = {};
local optionbuttons = {};
local optionmap = {};

function OptionsLib:_processchildren(button, parents)
	for n,what in pairs(parents) do
		local b = optionmap[n];
		if ( b ) then
			if ( not b.children ) then
				b.children = {};
			end
			b.children[button] = what;
			if ( not button.parents ) then
				button.parents = {};
			end
			tinsert(button.parents, b);
		end
	end
end
tinsert(copyfuncs, "_processchildren");

function OptionsLib:_processdepends(button, depends)
	for n,what in pairs(depends) do
		local b = optionmap[n];
		if ( b ) then
			if ( not b.controls ) then
				b.controls = {};
			end
			b.controls[button] = what;
			if ( not button.controlled ) then
				button.controlled = {};
			end
			tinsert(button.controlled, b);
		end
	end
end
tinsert(copyfuncs, "_processdepends");

function OptionsLib:_arrangebuttons(btnlist)
	if not btnlist then
		return {};
	end
	
	local order = {};
	local used = {};
	for idx=1,#btnlist do
		local b = btnlist[idx];
		if ( b.alone ) then
			tinsert(order, idx);
			used[b.name] = true;
		end
	end
	
	for idx=1,#btnlist do
		local b = btnlist[idx];
		if (b.children and not used[b.name] ) then
			local group = {};
			local last = {};
			used[b.name] = true;
			tinsert(order, idx);
			for d,_ in pairs(b.children) do
				for jdx=1,#btnlist do
					if ( not used[d.name] and btnlist[jdx].name == d.name) then
						used[d.name] = true;
						if (d.custom) then
							tinsert(last, jdx);
						else
							tinsert(group, jdx);
						end
					end
				end
			end
			-- here we should arrange order so that as many pairs as possible are
			-- an appropriate width. For now make all the odd ones the shortest ones.
			table.sort(group, function(a,b)
				a = btnlist[a];
				b = btnlist[b];
				return a.width and b.width and a.width < b.width;
			end);
			for jdx=1,#group do
				local kdx = #group-jdx+1;
				if (kdx > jdx) then
					tinsert(order, group[jdx]);
					tinsert(order, group[kdx]);
				elseif (kdx == jdx) then
					tinsert(order, group[jdx]);
				end
			end
			for jdx=1,#last do
				tinsert(order, last[jdx]);
			end
		end
	end
	local last = {};
	local group = {};
	for idx=1,#btnlist do
		local b = btnlist[idx];
		if ( not used[b.name] ) then
			if (b.custom) then
				tinsert(last, idx);
			else
				tinsert(group, idx);
			end
		end
	end

	table.sort(group, function(a,b)
		a = btnlist[a];
		b = btnlist[b];
		return a.width and b.width and a.width < b.width;
	end);

	for jdx=1,#group do
		local kdx = #group-jdx+1;
		if (kdx > jdx) then
			tinsert(order, group[jdx]);
			tinsert(order, group[kdx]);
		elseif (kdx == jdx) then
			tinsert(order, group[jdx]);
		end
	end

	for jdx=1,#last do
		tinsert(order, last[jdx]);
	end

	return order;
end
tinsert(copyfuncs, "_arrangebuttons");

local RIGHT_OFFSET = 16;
local BUTTON_SEP = 8;
function OptionsLib:_layoutorder(btnlist, maxwidth)
	if not btnlist then
		return {};
	end

	local order = self:_arrangebuttons(btnlist);
	local layout = {};
	local used = {};

	local idx = 1;
	while (idx <= #order ) do
		if ( not used[idx] ) then
			local left = order[idx];
			local leftbut = btnlist[left];
			local rightbut = nil;
			if ( not leftbut.alone ) then
				local tw = RIGHT_OFFSET + BUTTON_SEP + leftbut.width;
				for jdx=#order,idx+1,-1 do
					if ( not rightbut and not used[jdx] ) then
						local tr = order[jdx];
						local tb = btnlist[tr];
						if ((tb.width + tw) <= maxwidth) then
							used[jdx] = true;
							rightbut = tb;
						end
					end
				end
			end
			
			tinsert(layout, { leftbut, rightbut } );
		end
		idx = idx + 1;
	end

	return layout;
end
tinsert(copyfuncs, "_layoutorder");

function OptionsLib:_firstposition(button, xoffset, yoffset)
	xoffset = xoffset or 4;
	yoffset = yoffset or -4;
	button:SetPoint("TOPLEFT", self.reference, "TOPLEFT", xoffset, yoffset);
end
tinsert(copyfuncs, "_firstposition");

local SQUISH_OFF = 6;
function OptionsLib:_dolayout(layout, lastbutton, firstoff)
	firstoff = firstoff or 0;
	for idx,line in ipairs(layout) do
		local lb, rb = line[1], line[2];
		local yoff = nil;
		if ( lb.margin ) then
			yoff = -(lb.margin[2] or SQUISH_OFF);
			firstoff = firstoff + lb.margin[1] or 0;
		end
		if ( not lastbutton ) then
			self:_firstposition(lb, firstoff, yoff);
		else
			yoff = SQUISH_OFF;
			lb:SetPoint("TOPLEFT", lastbutton, "BOTTOMLEFT", firstoff, yoff);
			firstoff = 0;
		end
		lastbutton = lb;
		if ( rb ) then
			rb.right = 1;
			rb.adjacent = lastbutton;
			if ( rb.margin ) then
				yoff = yoff + (rb.margin[2] or 0);
			end
			rb:SetPoint("TOP", lb, "TOP");
			if ( rb.checkbox ) then
				rb:SetPoint("RIGHT", self.reference, "RIGHT", -rb.width, 0);
				rb:SetHitRectInsets(0, -rb.width, 0, 0);
			else
				rb:SetPoint("RIGHT", self.reference, "RIGHT", -rb.slider, 0);
			end
		end
	end
	
	return lastbutton;
end
tinsert(copyfuncs, "_dolayout");

local function CleanupButton(button)
	button.name = nil;
	button.alone = nil;
	button.width = 0;
	button.slider = 0;
	button.update = nil;
	button.enabled = nil;
	button.text = "";
	button.tooltipText = nil;
	button.disabledTooltipText = nil;
	button.primary = nil;
	button.right = nil;
	button.layoutright = nil;
	button.margin = nil;
	button.visible = nil;
	button.adjacent = nil;
	button.parents = nil;
	button.children = nil;
	button.controls = nil;
	button.controlled = nil;
	if (button.overlay) then
		button.overlay:Hide();
		button.overlay = nil;
	end
	CheckBox_Able(button, 0);
	button:ClearAllPoints();
	if (button.checkbox) then
		button:SetHitRectInsets(0, -100, 0, 0);
		button:SetScript("OnShow", nil);
		button:SetScript("OnClick", nil);
		button.checkbox = nil;
	end
	button.custom = nil;
	button.option = nil;
	button:Hide();
	button:SetParent(nil);

	local text = _G[button:GetName().."Text"];
	if (text) then
		text:SetText(button:GetName());
	end
end

local insidewidth = 0;
function OptionsLib:LayoutOptions(options)
	insidewidth = self.reference:GetWidth();

-- Clear out all the stuff we put on the old buttons
	for name,button in pairs(optionmap) do
		CleanupButton(button);
	end
	optionmap = {};

	local overlayidx = 1;
	local index = 1;
	for name,option in pairs(options) do
		local button = nil;
		if (not option.visible or option.visible(option)) then
			if ( option.button ) then
				if ( type(option.button) == "string" ) then
					button = _G[option.button];
				else
					button = option.button;
				end
				if ( button ) then
					button.custom = true;
					button.checkbox = (button:GetObjectType() == "CheckButton");
				end
			elseif ( option.v ) then
				button = optionbuttons[index];
				if ( not button ) then
					button = CreateFrame(
						"CheckButton", self.name.."Opt"..index,
						self.reference, "OptionsSmallCheckButtonTemplate");
					optionbuttons[index] = button;
				end
				button.checkbox = true;
				index = index + 1;
			end
			if ( button ) then
				optionmap[name] = button;

				button.option = option;
				button.name = name;

				button:ClearAllPoints();
				button:SetParent(self);
				button:SetFrameLevel(self.reference:GetFrameLevel() + 2);

				if ( button.checkbox and option.v ) then
					-- override OnShow and OnClick
					button:SetScript("OnShow", self.onshow);
					button:SetScript("OnClick", self.onclick);
				end

				if (option.init) then
					option.init(option, button);
				end
				
				button.alone = option.alone;
				button.layoutright = option.layoutright;
				button.margin = option.margin;
				button.update = option.update;
				button.visible = option.visible;
				button.enabled = option.enabled;
				button.width = button:GetWidth();

				if ( option.text ) then
					button.text = option.text;
					local text = _G[button:GetName().."Text"];
					if (text) then
						text:SetText(option.text);
						button.width = button.width + text:GetWidth();
					end
				else
					button.text = "";
				end

				button.tooltipText = option.tooltip;
				
				if ( button.checkbox ) then
					if (self.GetSettingBool) then
						button:SetChecked(self.GetSettingBool(name));
					end
					button:SetHitRectInsets(0, -button.width, 0, 0);
				end
				-- hack for sliders (why?)
				if (button:GetObjectType() == "Slider") then
					button.slider = 16;
					Slider_OnShow(button)
				else
					button.slider = 0;
				end

				if ( option.tooltipd ) then
					local tooltip = option.tooltipd;
					if ( type(tooltip) == "function" ) then
						tooltip = tooltip(option);
					end
					
					if ( tooltip ) then
						local overlay = overlaybuttons[overlayidx];
						if ( not overlay ) then
							overlay = CreateFrame("Button");
							overlay:Hide();
							overlaybuttons[overlayidx] = overlay;
							overlay:SetParent(self);
							overlay:SetScript("OnEnter", Handle_OnEnter);
							overlay:SetScript("OnLeave", Handle_OnLeave);
						end
						overlay:SetSize(button.width or button:GetWidth(), button:GetHeight());
						overlay:SetPoint("LEFT", button, "LEFT");
						overlay.tooltipText = tooltip;
						button.overlay = overlay;
						overlayidx = overlayidx + 1;
					end
				end

				if ( option.setup ) then
					option.setup(button);
				end
			end
		end
	end

	local toplevel = {};
	for name,option in pairs(options) do
		local button = optionmap[name];
		if ( button ) then
			if ( option.parents ) then
				button.primary = option.primary;
				self:_processchildren(button, option.parents);
			else
				tinsert(toplevel, name);
			end
			
			if (option.depends) then
				self:_processdepends(button, option.depends);
			end
		end
	end

	-- move the primaries with no dependents to the top, and stack them next to other
	-- then put everything else underneath. need to make the dep button layout code
	-- useful for the toplevel non-dep buttons then
	local pb = {};
	local maxwidth = 0;
	for _,name in pairs(toplevel) do
		local button = optionmap[name];
		if ( button and not button.children and not button.custom ) then
			tinsert(pb, button);
		end
	end

	local layout = self:_layoutorder(pb, insidewidth);	
	local lastbutton = self:_dolayout(layout);
	
	local primaries = {};
	for _,name in pairs(toplevel) do
		local button = optionmap[name];
		if ( button and button.children ) then
			tinsert(primaries, name);
		end
	end
	for _,name in pairs(toplevel) do
		local button = optionmap[name];
		if ( button and button.custom ) then
			tinsert(primaries, name);
		end
	end

	local lastoff = 0;
	for _,name in pairs(primaries) do
		local button = optionmap[name];
		if ( not lastbutton ) then
			local yoff, firstoff;
			if ( button.margin ) then
				yoff = -(button.margin[2] or SQUISH_OFF);
				firstoff = button.margin[1] or 0;
			end
			self:_firstposition(button, firstoff, yoff);
		else
			local yoff = SQUISH_OFF;
			if ( button.margin ) then
				yoff = yoff - button.margin[2];
			end
			if ( lastbutton.margin ) then
				yoff = yoff - lastbutton.margin[2];
			end
			button:SetPoint("TOPLEFT", lastbutton, "BOTTOMLEFT", lastoff, yoff);
		end
		lastbutton = button;
		lastoff = 0;
		if ( button.children ) then
			local deps = {};
			for b,n in pairs(button.children) do
				if ( optionmap[b.name] and (not b.primary or b.primary == name) and b.name ~= button.layoutright) then
					tinsert(deps, b);
				end
			end
			layout = self:_layoutorder(deps, insidewidth - RIGHT_OFFSET);
			lastbutton = self:_dolayout(layout, lastbutton, RIGHT_OFFSET);
			lastoff = -RIGHT_OFFSET;
		end
		if ( button.layoutright ) then
			 local toright = optionmap[button.layoutright];
			 if (toright) then
				 toright:ClearAllPoints();
				 toright:SetPoint("CENTER", button, "CENTER", 0, 0);
				 toright:SetPoint("RIGHT", self.reference, "RIGHT", -32, 0);
			 end
		end
	end
end
tinsert(copyfuncs, "LayoutOptions");

function OptionsLib:ShowButtons()
	-- now that we've collected all of the dependencies, handle them
	for name,button in pairs(optionmap) do
		local button = optionmap[name];
		if ( button ) then
			local showit = true;
			if ( button.visible ) then
				showit = button.visible(button.option);
			end
			if ( showit ) then
				button:Show();
			else
				button:Hide();
			end
		end
	end
	for name,button in pairs(optionmap) do
		if ( not button.parents ) then
			local value = true;
			if (button.enabled) then
				value = button.enabled(button);
			end
			CheckBox_Able(button, value);
			self:HandleDeps(button);
		end
	end
end
tinsert(copyfuncs, "ShowButtons");

function OptionsLib:FitInFrame(width)
	local check = self.reference:GetWidth();
	-- Default to something that should be close in case we haven't
	-- seen the window yet
	if (check == 0) then
		check = 327;
	end
	return width < (check - RIGHT_OFFSET - BUTTON_SEP);
end
tinsert(copyfuncs, "FitInFrame");

-- Based on code from the LibStub wiki page
OptionsLib.previousClients = OptionsLib.previousClients or {};
function OptionsLib:Embed(target, onclick, onshow, reference)
	local f, n = OptionsLib:GetFrameInfo(target);
	for _,name in pairs(copyfuncs) do
		f[name] = OptionsLib[name];
	end
	OptionsLib.previousClients[f] = true;
	f.name = n;
	f.reference = reference or f;
	f.onclick = onclick;
	f.onshow = onshow;
end

for target,_ in pairs(OptionsLib.previousClients) do
	OptionsLib:Embed(target)
end
