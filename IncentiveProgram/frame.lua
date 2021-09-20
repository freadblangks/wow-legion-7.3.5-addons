-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

--Local copy of the class
local frame


---------------------------------------
-- Class: Frame
-- This class creates the user frame that the user interacts with
---------------------------------------
local IncentiveProgramFrame = {
    new = function(self)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        return obj
    end,
    
---------------------------------------
-- CreateFrame creates a frame and stores it within the object
-- @params
--      self - Frame Class
-- @returns
--		nil
---------------------------------------
    CreateFrame = function(self)
        local ipFrame = CreateFrame("Button", "IncentiveProgramFrame", UIParent)
        ipFrame:SetWidth(32)
        ipFrame:SetHeight(32)
        local top = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["FRAME_TOP"])
        local left = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["FRAME_LEFT"])
        
        if ( top == -1 ) then --frame has not been set yet
            ipFrame:SetPoint("CENTER", 32, 0)
        else
            ipFrame:SetPoint("BOTTOMLEFT", left, top - ipFrame:GetHeight())
        end
        
        ipFrame:EnableMouse(true)
        ipFrame:SetMovable(true)
        ipFrame:SetClampedToScreen(true)
        ipFrame:RegisterForDrag("LeftButton")
        ipFrame:RegisterForClicks("AnyUp")
        ipFrame:SetScript("OnDragStart", function(s) s:StartMoving() end)
        ipFrame:SetScript("OnDragStop", function(s)
            s:StopMovingOrSizing()
            IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["FRAME_TOP"], s:GetTop())
            IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["FRAME_LEFT"], s:GetLeft())
        end)
        ipFrame:SetScript("OnClick", function(s, button, down)
            self:OnClick(button, down)
        end)
        
        --Set Texture
        ipFrame.tex = ipFrame:CreateTexture(nil, "BACKGROUND")
        ipFrame.tex:SetAllPoints(ipFrame)
        ipFrame.tex:SetTexture(IncentiveProgram.Icons["INCENTIVE_NONE"]);
        
        --Set Text on the button, Gradiants make text easier to see
        ipFrame.leftGradiant = ipFrame:CreateTexture(nil, "BORDER")
        ipFrame.leftGradiant:SetWidth(16)
        ipFrame.leftGradiant:SetHeight(14)
        ipFrame.leftGradiant:SetPoint("LEFT", 0, -5)
        ipFrame.leftGradiant:SetTexture(1,0,0,1)
        ipFrame.leftGradiant:SetGradientAlpha("Horizontal", 0, 0, 0, 0.2, 0, 0, 0, 1)
        
        ipFrame.rightGradiant = ipFrame:CreateTexture(nil, "BORDER")
        ipFrame.rightGradiant:SetWidth(16)
        ipFrame.rightGradiant:SetHeight(14)
        ipFrame.rightGradiant:SetPoint("RIGHT", 0, -5)
        ipFrame.rightGradiant:SetTexture(1,0,0,1)
        ipFrame.rightGradiant:SetGradientAlpha("Horizontal", 0, 0, 0, 1, 0, 0, 0, 0.2)
        
        ipFrame.text = ipFrame:CreateFontString(nil, "ARTWORK", "GameFontWhite")
        ipFrame.text:SetJustifyH("CENTER")
        ipFrame.text:SetText("0")
        ipFrame.text:SetWidth(40)
        ipFrame.text:SetHeight(14)
        ipFrame.text:SetPoint("CENTER", 0, -5)
        ipFrame.text:SetNonSpaceWrap(false)
        
        ipFrame.menu = IncentiveProgram:CreateMenu(ipFrame)
        Lib_UIDropDownMenu_Initialize(ipFrame.menu.frame, ipFrame.menu.MenuOnLoad, "MENU")
        
        self.ipFrame = ipFrame
    end,
  
---------------------------------------
-- OnClick is the OnClick event handler of the frame
-- @params
--      self - Frame Class
--		button - which mouse button clicked the frame
--	    down - boolean if the mouse key is currently down
--		anchorFrame - frame to anchor the drop down menu.  Broker class will call this function as
--			as well, so we can anchor the drop down menu to the broker icon instead.
-- @returns
--		nil
---------------------------------------  
    OnClick = function(self, button, down, anchorFrame)
        self.ipFrame.menu.frame.button = button
        anchorFrame = anchorFrame or self.ipFrame
        self.ipFrame.anchorFrame = anchorFrame
        
        if ( button == "LeftButton" ) then
            self:GetUIMenuFrame().point = "BOTTOMLEFT"
            self:GetUIMenuFrame().relativeTo = anchorFrame
            self:GetUIMenuFrame().relativePoint = "TOPRIGHT"
            Lib_ToggleDropDownMenu(1, nil, self:GetUIMenuFrame(), anchorFrame, 0, 0)
        elseif ( button == "RightButton" ) then
            self:GetUIMenuFrame().point = "BOTTOMLEFT"
            self:GetUIMenuFrame().relativeTo = anchorFrame
            self:GetUIMenuFrame().relativePoint = "TOPRIGHT"
            Lib_ToggleDropDownMenu(1, nil, self:GetUIMenuFrame(), anchorFrame, 0, 0)
        end
    end,
    
---------------------------------------
-- HideTextures removes the count text and sets the image to the default red
-- @params
--      self - Frame Class
-- @returns
--		nil
---------------------------------------
    HideTextures = function(self)
        self.ipFrame.tex:SetTexture(IncentiveProgram.Icons["INCENTIVE_NONE"])
        self.ipFrame.leftGradiant:Hide()
        self.ipFrame.rightGradiant:Hide()
        self.ipFrame.text:Hide()
		self:UpdatedSettings() --Hide when count 0
    end,
    
---------------------------------------
-- ShowTextures shows the count string and sets the texture.  If none is provided, default to gold coin
-- @params
--      self - Frame Class
-- @returns
--		nil
---------------------------------------
    ShowTextures = function(self, count, texture)
        if texture then
            self.ipFrame.tex:SetTexture(texture)
        else
            self.ipFrame.tex:SetTexture(IncentiveProgram.Icons["INCENTIVE_RARE"])
        end
        
        self.ipFrame.leftGradiant:Show()
        self.ipFrame.rightGradiant:Show()
        self.ipFrame.text:Show()
        self.ipFrame.text:SetText(count or 0)   
		self:UpdatedSettings() --Hide when count 0
    end,
    
---------------------------------------
-- ShowFrame shows the frame.  We use this helper because the Frame Class isn't the actual widget, so it 
--		just makes it look cleaner.
-- @params
--      self - Frame Class
-- @returns
--		nil
---------------------------------------
    ShowFrame = function(self)
        self.ipFrame:Show()
    end,
    
---------------------------------------
-- HideFrame hides the frame.  We use this helper because the Frame Class isn't the actual widget, so it 
--		just makes it look cleaner.
-- @params
--      self - Frame Class
-- @returns
--		nil
---------------------------------------
    HideFrame = function(self)
        self.ipFrame:Hide()
    end,
    
---------------------------------------
-- UpdatedSettings is called when settings change in case new settings hide or show the frame
-- @params
--      self - Frame Class
-- @returns
--		nil
---------------------------------------
    UpdatedSettings = function(self)
        local hideAlways = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["HIDE_ALWAYS"])
        local hideInParty = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["HIDE_IN_PARTY"])
		local hideEmpty = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["HIDE_EMPTY"])
		
		if ( hideAlways ) then
			self:HideFrame()
		elseif ( hideInParty and IsInGroup() ) then
			self:HideFrame()
		elseif ( hideEmpty and IncentiveProgram:GetDungeon():GetCount() == 0 ) then
			self:HideFrame()
		else
			self:ShowFrame()
		end
		
    end,
    
---------------------------------------
-- GetUIFrame returns the actual widget
-- @params
--      self - Frame Class
-- @returns
--		ipFrame - Widget of the actual frame
---------------------------------------
    GetUIFrame = function(self)
        return self.ipFrame
    end,
   
---------------------------------------
-- GetAnchorFrame returns the current anchor frame
-- @params
--      self - Frame Class
-- @returns
--		anchorFrame - currently assigned anchor frame
---------------------------------------   
    GetAnchorFrame = function(self)
        return self.ipFrame.anchorFrame
    end,
    
---------------------------------------
-- GetUIMenuFrame returns the Drop Down Menu Frame
-- @params
--      self - Frame Class
-- @returns
--		menuFrame - widget of the drop down menu
---------------------------------------
    GetUIMenuFrame = function(self)
        return self.ipFrame.menu.frame
    end,
	
---------------------------------------
-- ResetFramePosition places the frame in the center of the screen
-- @params
--      self - Frame Class
-- @returns
--		Nil
---------------------------------------
	ResetFramePosition = function(self)
		self.ipFrame:ClearAllPoints()
		self.ipFrame:SetPoint("CENTER", 32, 0)
        IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["FRAME_TOP"], self.ipFrame:GetTop())
        IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["FRAME_LEFT"], self.ipFrame:GetLeft())
	end
}

---------------------------------------
-- IncentiveProgram:GetFrame() is a global function.  This returns the Frame Class
-- @params
--      nil
-- @returns
--		Frame Class
---------------------------------------  
function IncentiveProgram:GetFrame()
    if not frame then
        frame = IncentiveProgramFrame:new()
        frame:CreateFrame()
    end
    
    return frame
end