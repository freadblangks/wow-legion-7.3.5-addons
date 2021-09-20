-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

-- Local copy of the class
local toast

-- Stores Toasts
local IPToasts = {}

---------------------------------------
-- Class: Toast
-- This class allows you to call the Toast Frame
---------------------------------------
local IncentiveProgramToast = {
    new = function(self)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        return obj
    end,
    
---------------------------------------
-- CreateFrame creates a frame and stores it within the object
-- @params
--      self - toast Class
-- @returns
--		nil
---------------------------------------
    CreateFrame = function(self)
        local toastFrame = CreateFrame("Frame", "IncentiveProgramToastFrame", UIParent)
        toastFrame:Hide()
        
        toastFrame:SetFrameStrata("LOW")
        toastFrame:SetWidth(250)
        toastFrame:SetHeight(50)
        toastFrame:SetMovable(true)
        toastFrame:SetClampedToScreen(true)
        
        toastFrame:SetPoint("CENTER",0,50)
        
        --Backdrop
        toastFrame:SetBackdrop( {
            bgFile = "Interface\\FriendsFrame\\UI-Toast-Background",
            edgeFile = "Interface\\FriendsFrame\\UI-Toast-Border",
            tile = true, tileSize = 12, edgeSize = 12,
            insets = { left = 5, right = 5, top = 5, bottom = 5 }
        })
        
        toastFrame.waitAndAnimOut = toastFrame:CreateAnimationGroup("IncentiveProgramToastFrameWaitAndAnimOut")
        local waaoAlpha = toastFrame.waitAndAnimOut:CreateAnimation("Alpha")
        waaoAlpha:SetParent(toastFrame.waitAndAnimOut)
        waaoAlpha:SetOrder(1)
        waaoAlpha:SetFromAlpha(1)
        waaoAlpha:SetToAlpha(0)
        waaoAlpha:SetDuration(1.5)
        waaoAlpha:SetStartDelay(4.05)
        waaoAlpha:SetScript("OnFinished", function() toastFrame:Hide() end)
        toastFrame.waitAndAnimOut.animOut = waaoAlpha
        
        --BORDER Layer
        local iconTexture = toastFrame:CreateTexture("IncentiveProgramToastFrameIconTexture", "BORDER")
        iconTexture:SetWidth(40)
        iconTexture:SetHeight(40)
        iconTexture:SetPoint("LEFT",4,0)
        iconTexture:SetTexture(348520) --satchel texture ID
        toastFrame.iconTexture = iconTexture
        
        local topLine = toastFrame:CreateFontString("IncentiveProgramToastFrameTopLine", "BORDER", "FriendsFont_Normal")
        topLine:SetJustifyH("LEFT")
        topLine:SetJustifyV("MIDDLE")
        topLine:SetWidth(0)
        topLine:SetHeight(10)
        topLine:SetPoint("TOPLEFT", 49, -7)
        topLine:SetPoint("RIGHT", -20, 0)
        topLine:SetTextColor(0.510, 0.773, 1)
        topLine:SetText(IncentiveProgram.ADDON_DISPLAY_NAME)
        toastFrame.topLine = topLine
        
        local middleLine = toastFrame:CreateFontString("IncentiveProgramToastFrameMiddleLine", "BORDER", "FriendsFont_Normal")
        middleLine:SetJustifyH("LEFT")
        middleLine:SetJustifyV("MIDDLE")
        middleLine:SetWidth(0)
        middleLine:SetHeight(10)
        middleLine:SetPoint("TOPLEFT", topLine, "BOTTOMLEFT", 0, -4)
        middleLine:SetTextColor(0.486, 0.518, 0.541)
        middleLine:SetText("隨機英雄地城")
        toastFrame.middleLine = middleLine
        
        local bottomLine = toastFrame:CreateFontString("IncentiveProgramToastFrameBottomLine", "BORDER", "FriendsFont_Normal")
        bottomLine:SetJustifyH("LEFT")
        bottomLine:SetJustifyV("MIDDLE")
        bottomLine:SetWidth(0)
        bottomLine:SetHeight(10)
        bottomLine:SetPoint("TOPLEFT", middleLine, "BOTTOMLEFT", 0, -4)
        bottomLine:SetTextColor(0.486, 0.518, 0.541)
        bottomLine:SetText("{T} 坦克 | {H} 治療者")
        toastFrame.bottomLine = bottomLine
        
        local clickFrame = CreateFrame("Button", "IncentiveProgramToastFrameClickFrame", toastFrame)
        clickFrame:SetAllPoints(toastFrame)
        clickFrame:SetScript("OnEnter", function(...)
            toastFrame.waitAndAnimOut:Stop()
        end)
        clickFrame:SetScript("OnLeave", function(...)
            toastFrame.waitAndAnimOut.animOut:SetStartDelay(1)
            toastFrame.waitAndAnimOut:Play()
        end)

        clickFrame:EnableMouse(true)
        clickFrame:SetMovable(true)
        clickFrame:RegisterForDrag("LeftButton")
        clickFrame:RegisterForClicks("AnyUp")
        clickFrame:SetScript("OnDragStart", function(s) s:GetParent():StartMoving() end)
        clickFrame:SetScript("OnDragStop", function(s)
            s:GetParent():StopMovingOrSizing()
            IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["TOAST_TOP"], s:GetParent():GetTop())
            IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["TOAST_LEFT"], s:GetParent():GetLeft())
        end)
        
        toastFrame.clickFrame = clickFrame
        
        local glowFrame = CreateFrame("Frame", "IncentiveProgramToastFrameGlowFrame", toastFrame)
        glowFrame:SetAllPoints(toastFrame)
        glowFrame.glow = glowFrame:CreateTexture("IncentiveProgramToastFrameGlowFrameGlow", "OVERLAY")
        glowFrame.glow:SetWidth(252)
        glowFrame.glow:SetHeight(56)
        glowFrame.glow:SetAlpha(1)
        glowFrame.glow:SetTexture("Interface\\FriendsFrame\\UI-Toast-Flair")
        glowFrame.glow:SetBlendMode("ADD")
        glowFrame.glow:Hide()
        glowFrame.glow:SetPoint("TOPLEFT", -1, 3)
        glowFrame.glow:SetPoint("BOTTOMRIGHT", 1, -3)
        
        glowFrame.animIn = glowFrame:CreateAnimationGroup("IncentiveProgramToastFrameGlowFrameAnimIn")
        
        local alpha1 = glowFrame.animIn:CreateAnimation("Alpha")
        alpha1:SetParent(glowFrame.animIn)
        alpha1:SetOrder(1)
        alpha1:SetFromAlpha(0)
        alpha1:SetToAlpha(1)
        alpha1:SetDuration(0.2)
        local alpha2 = glowFrame.animIn:CreateAnimation("Alpha")
        alpha2:SetParent(glowFrame.animIn)
        alpha2:SetOrder(2)
        alpha2:SetFromAlpha(1)
        alpha2:SetToAlpha(0)
        alpha2:SetDuration(0.5)
        
        glowFrame.animIn:SetScript("OnPlay",function(...) 
            glowFrame.glow:Show()
        end)
        glowFrame.animIn:SetScript("OnFinished",function(...) 
            glowFrame.glow:Hide()
        end)
        toastFrame.glowFrame = glowFrame
        
        local closeButton = CreateFrame("Button", "IncentiveProgramToastFrameCloseButton", toastFrame)
        closeButton:SetWidth(18)
        closeButton:SetHeight(18)
        closeButton:SetPoint("TOPRIGHT", -4, -3)
        closeButton:SetNormalTexture("Interface\\FriendsFrame\\UI-Toast-CloseButton-Up")
        closeButton:SetPushedTexture("Interface\\FriendsFrame\\UI-Toast-CloseButton-Down")
        closeButton:SetHighlightTexture("Interface\\FriendsFrame\\UI-Toast-CloseButton-Highlight")
        --closeButton:GetHighlightTexture():SetBlendMode("ADD")
        closeButton:SetScript("OnClick", function() 
            for i = #IPToasts, 1, -1 do tremove(IPToasts,i) end
            toastFrame:Hide()
        end)
        toastFrame.closeButton = closeButton
        
        local frameLevel = clickFrame:GetFrameLevel()
        closeButton:SetFrameLevel(frameLevel + 1)
        glowFrame:SetFrameLevel(frameLevel + 2)
        
        toastFrame:SetScript("OnHide", function()
            if #IPToasts > 0 then
                self:ShowToast()
            end
        end)
        
        self.toastFrame = toastFrame
    end,
   
---------------------------------------
-- ShowToast iterates through IPToasts table to clear out any remaining toast alerts
-- @params
--      self - toast Class
-- @returns
--		nil
---------------------------------------   
    ShowToast = function(self)
        local toastFrame = self.toastFrame
        local line1, line2, texture = IPToasts[1].line1, IPToasts[1].line2, IPToasts[1].texture
        local arg1, arg2, func = IPToasts[1].arg1, IPToasts[1].arg2, IPToasts[1].func
        tremove(IPToasts,1)
        
        toastFrame.middleLine:SetText(line1)
        toastFrame.bottomLine:SetText(line2)
        if ( texture and type(texture) == "number" and texture ~= 348520 ) then
            toastFrame.iconTexture:SetTexture(texture)
			toastFrame.iconTexture:SetTexCoord(0.1, 0.6, 0, 1)
        elseif ( texture ) then
            toastFrame.iconTexture:SetTexture(texture)
			toastFrame.iconTexture:SetTexCoord(0, 1, 0, 1)
		else
            toastFrame.iconTexture:SetTexture(348520) --satchel texture ID
			toastFrame.iconTexture:SetTexCoord(0, 1, 0, 1)
        end
        
        if arg1 then
            toastFrame.clickFrame.arg1 = arg1
        else
            toastFrame.clickFrame.arg1 = nil
        end
        
        if arg2 then
            toastFrame.clickFrame.arg2 = arg2
        else
            toastFrame.clickFrame.arg2 = nil
        end
        
        if func then
            toastFrame.clickFrame.func = func
            toastFrame.clickFrame:SetScript("OnClick", function(s, ...)
                s.func(IncentiveProgram:GetMenu(), s.arg1, s.arg2)
                toastFrame:Hide()
            end)
        else
            toastFrame.clickFrame:SetScript("OnClick", function() end)
        end
        
        self:UpdateAnchor()
        toastFrame:Show();
        --PlaySoundKitID(18019) --BNet toast frame ping --Done in core.lua now.
		--IncentiveProgram:SetSound(IncentiveProgram.TOAST) --decided against playing sound on each toast refresh
        toastFrame.glowFrame.animIn:Play()
        toastFrame.waitAndAnimOut:Stop()
        if toastFrame:IsMouseOver() then
            toastFrame.waitAndAnimOut.animOut:SetStartDelay(1);
        else
            toastFrame.waitAndAnimOut.animOut:SetStartDelay(4.5)
            toastFrame.waitAndAnimOut:Play()
        end
    end,

---------------------------------------
-- AddToast adds a new toast with relevant information into IPToasts table.
-- @params
--      self - toast Class
--		line1 - (Optional) Line 1 of the Toast
--		line2 - (Optional) Line 2 of the Toast
--		texture - (Optional) texture of the Toast. Defaults to the Satchel awarded in Legion
--		arg1 - (Optional) Passes arg1 into the provided func (Intended to be DungeonID at this time)
--		arg2 - (Optional) Passes arg2 into the provided func (no intended use at this time)
--		func - (Optional) The OnClick Function of the Toast, passing arg1 and arg2 as parameters
-- @returns
--		nil
--------------------------------------- 
    AddToast = function(self, line1, line2, texture, arg1, arg2, func)
        local toast = {}
        toast.line1 = line1 or ""
        toast.line2 = line2 or ""
        toast.texture = texture or 348520
        toast.arg1 = arg1
        toast.arg2 = arg2
        toast.func = func
        tinsert(IPToasts, toast)
        
        if not self.toastFrame:IsShown() then
            self:ShowToast()
        end
    end,

---------------------------------------
-- UpdateAnchor readjusts the toast area in the UI to the settings
-- @params
--      self - toast Class
-- @returns
--		nil
---------------------------------------   	
    UpdateAnchor = function(self)
        local toastFrame = self.toastFrame
        toastFrame:ClearAllPoints()
        
        local top = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["TOAST_TOP"])
        local left = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["TOAST_LEFT"])
        if ( top == -1 ) then
            toastFrame:SetPoint("CENTER",0,50)
        else
            toastFrame:SetPoint("BOTTOMLEFT", left, top - toastFrame:GetHeight())
        end
    end
}

---------------------------------------
-- IncentiveProgram:GetToast() is a global function.  This returns the Toast Class
-- @params
--      nil
-- @returns
--		Toast Class
---------------------------------------   
function IncentiveProgram:GetToast()
    if not toast then
        toast = IncentiveProgramToast:new()
        toast:CreateFrame()
    end
    
    return toast
end