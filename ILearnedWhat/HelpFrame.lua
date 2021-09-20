
local addonName, _addonData = ...;

local _help = _addonData.help;

local HELP_BUTTON_NORMAL_SIZE = 46;

local function ShowTooltip(self)
	ShowUIPanel(self:GetParent().Tooltip);
	self:GetParent().Box:Hide();
	ShowUIPanel(self:GetParent().GlowFrame);
end

local function HideTooltip(self)
	self:GetParent().Tooltip:Hide();
	ShowUIPanel(self:GetParent().Box);
	self:GetParent().GlowFrame:Hide();
end

local function CreateButtonAnimation(self)
	self.animGroup_Show = self:CreateAnimationGroup();
	self.animGroup_Show.translate = self.animGroup_Show:CreateAnimation("Translation");
	self.animGroup_Show.translate:SetSmoothing("IN");
	self.animGroup_Show.alpha = self.animGroup_Show:CreateAnimation("Alpha");
	self.animGroup_Show.alpha:SetFromAlpha(1);
	self.animGroup_Show.alpha:SetToAlpha(0);
	self.animGroup_Show.alpha:SetSmoothing("IN");
	self.animGroup_Show.parent = self;
end

local function ShowButtonAnimation(self)
	if self.animGroup_Show == nil then
		CreateButtonAnimation(self)
	end
	local point, relative, relPoint, xOff, yOff = self:GetPoint();
	self.animGroup_Show.translate:SetOffset( (-1*xOff), (-1*yOff) );
	self.animGroup_Show.translate:SetDuration(0.5);
	self.animGroup_Show.alpha:SetDuration(0.5);
	self.animGroup_Show:Play(true);
end

function _help:Initialize(parent, data)
	ILW_HelpFrame:SetParent(parent);
	ILW_HelpFrame:ClearAllPoints();
	ILW_HelpFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", data.FramePos.x, data.FramePos.y);
	ILW_HelpFrame:SetSize(data.FrameSize.width, data.FrameSize.height);
	
	
	for k, subData in ipairs(data) do
		local helpRegion = CreateFrame("FRAME", "ILW_HelpRegion".. k, ILW_HelpFrame, "ILW_HelpRegionTemplate");
		
		helpRegion.Box:SetScript("OnEnter", ShowTooltip);
		helpRegion.GlowFrame:SetScript("OnLeave", HideTooltip);
	
		--local subData = data[1];
		helpRegion.Box:ClearAllPoints();
		helpRegion.Box:SetPoint("TOPLEFT", parent, "TOPLEFT", subData.HighLightBox.x, subData.HighLightBox.y);
		helpRegion.Box:SetSize(subData.HighLightBox.width, subData.HighLightBox.height);
		
		helpRegion.GlowFrame:ClearAllPoints();
		helpRegion.GlowFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", subData.HighLightBox.x, subData.HighLightBox.y);
		helpRegion.GlowFrame:SetSize(subData.HighLightBox.width, subData.HighLightBox.height);
		
		helpRegion.Button:ClearAllPoints();
		helpRegion.Button:SetPoint("TOPLEFT", parent, "TOPLEFT", subData.ButtonPos.x, subData.ButtonPos.y);
		helpRegion.Button:SetSize(HELP_BUTTON_NORMAL_SIZE, HELP_BUTTON_NORMAL_SIZE);
		helpRegion.Button:SetScript("OnShow", function(self) ShowButtonAnimation(self) end);
		helpRegion.Button:SetScript("OnEnter", ShowTooltip);
		helpRegion.Button:SetScript("OnLeave", HideTooltip);
		
		helpRegion.Button.HelpIGlow:Hide();
		helpRegion.Button.BgGlow:Hide();
		
		
		
		
		local tt = helpRegion.Tooltip;
		tt:ClearAllPoints();
		--tt:SetPoint("TOP", helpRegion.Button, "BOTTOM", 0, -10);
		tt.Text:SetText(subData.ToolTipText);
		tt:SetHeight(tt.Text:GetHeight()+20);
		tt:SetFrameLevel(tt:GetParent():GetFrameLevel()+2);
		
		if (subData.ToolTipDir == "UP") then
			tt:SetPoint("BOTTOM", helpRegion.Button, "TOP", 0, 10);
			tt.ArrowUp:Show();
		elseif (subData.ToolTipDir == "DOWN") then
			tt:SetPoint("TOP", helpRegion.Button, "BOTTOM", 0, -10);
			tt.ArrowDown:Show();
		end
	
	end
	
end

function _help:ShowTutorial()
	ShowUIPanel(ILW_HelpFrame);
end

function _help:HideTutorial()
	ILW_HelpFrame:Hide();
end