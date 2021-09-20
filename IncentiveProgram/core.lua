-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

local eventFrame = CreateFrame("Frame", "IncentiveProgramEventFrame", UIParent)
eventFrame:RegisterEvent("VARIABLES_LOADED")
eventFrame:SetScript("OnEvent", function(self, ...) self:OnEvent(...) end)
eventFrame:SetScript("OnUpdate", function(self, ...) self:OnUpdate(...) end)

-----------------------------------------
---- Variables
-----------------------------------------
IncentiveProgram.SavedLFGRoles = {
    isUpdated = false,
    Leader = false,
    Tank = false,
    Healer = false,
    Damage = false
}

-----------------------------------------
---- Slash Command
-----------------------------------------

SLASH_INCENTIVEPROGRAM1 = "/ip"
function SlashCmdList.INCENTIVEPROGRAM(msg, editbox)
    --IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["HIDE_IN_PARTY"], false)
    --IncentiveProgram:GetSettings():SetSetting(IncentiveProgram.Settings["HIDE_ALWAYS"], false)
    --IncentiveProgram:GetFrame():ShowFrame()
	InterfaceOptionsFrame_OpenToCategory(IncentiveProgramInterfacePanel) 
end

-----------------------------------------
---- OnEvent is the Event Handler for the Frame
---- Registered Events:
----      VARIABLES_LOADED
----      GROUP_ROSTER_UPDATE
----      LFG_UPDATE_RANDOM_INFO
----      LFG_ROLE_UPDATE
-----------------------------------------
function eventFrame:OnEvent(event, ...)
    if ( event == "VARIABLES_LOADED" ) then
        IncentiveProgram:SetCount(0)
        IncentiveProgram:GetFrame():UpdatedSettings()
        
        self:RegisterEvent("GROUP_ROSTER_UPDATE")
        self:RegisterEvent("LFG_UPDATE_RANDOM_INFO")
        self:RegisterEvent("LFG_ROLE_UPDATE")
    elseif ( event == "GROUP_ROSTER_UPDATE" or event == "LFG_UPDATE" ) then --Party Update
        if IsInGroup() then
            if ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["HIDE_IN_PARTY"]) ) then
                IncentiveProgram:GetFrame():HideFrame()
            end
            
            IncentiveProgram:SetCount(0)
        else
            IncentiveProgram:GetFrame():UpdatedSettings()
            RequestLFDPlayerLockInfo()
        end
    elseif ( event == "LFG_UPDATE_RANDOM_INFO" ) then --Received new LFD Info
		local count = IncentiveProgram:GetDungeon():GetShortageCount()
        IncentiveProgram:SetCount(count)
		if ( count == 0 ) then
			eventFrame.continousEnabled = false
		else
			if ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CONTINUOUSLY_CYCLE"]) ) then
				eventFrame.continousEnabled = true
			else
				eventFrame.continousEnabled = false
			end
		end
    end
    
    if ( IncentiveProgram.SavedLFGRoles.isUpdated ) then
	    IncentiveProgram.SavedLFGRoles.isUpdated = false
        SetLFGRoles(IncentiveProgram.SavedLFGRoles.Leader, IncentiveProgram.SavedLFGRoles.Tank, IncentiveProgram.SavedLFGRoles.Healer, IncentiveProgram.SavedLFGRoles.Damage)
    end
end

function eventFrame:OnUpdate(e)
    self.elapsed = self.elapsed or (IncentiveProgram.TickRate - 5)
    self.elapsed = self.elapsed + e
	
	self.soundElapsed = self.soundElapsed or 0
	self.soundElapsed = self.soundElapsed + e
	self.soundCountAlert = self.soundCountAlert or 0
	self.soundCountToast = self.soundCountToast or 0
	
	self.cycleElapsed = self.cycleElapsed or 0
	self.cycleElapsed = self.cycleElapsed + e
    self.cycleCount = self.cycleCount or 0

	if ( self.elapsed >= IncentiveProgram.TickRate ) then
		self.elapsed = 0
		if ( not IsInGroup() ) then --can't get incentives in a group anyways.  Seems to still trigger
									--when in LFR dungeons anyways, so ignore it now.
			RequestLFDPlayerLockInfo()
		end
	end
	
	if ( self.soundElapsed >= IncentiveProgram.SoundRate ) then
		self.soundElapsed = 0
		if ( self.soundCountAlert > 0 ) then
			-- 自訂播放音樂
			successful = false
			local soundIdAlert = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["ALERT_SOUND"])
			if (soundIdAlert == 1069 or soundIdAlert == "1069") then
				PlaySoundFile("Interface\\Addons\\IncentiveProgram\\PPAP_MoritzGart.mp3", IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CHANNEL"]))
				successful = true
			elseif (soundIdAlert == 5487 or soundIdAlert == "5487") then
				PlaySoundFile("Interface\\Addons\\IncentiveProgram\\004_applepie.mp3", IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CHANNEL"]))
				successful = true
			else 
				successful = PlaySound(soundIdAlert, IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CHANNEL"]))
			end
			if successful then self.soundCountAlert = self.soundCountAlert - 1 end
		end
		
		if ( self.soundCountToast > 0 ) then
			-- 自訂播放音樂
			successful = false
			local soundIdToast = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["TOAST_SOUND"])
			if (soundIdToast == 1069 or soundIdToast == "1069") then
				PlaySoundFile("Interface\\Addons\\IncentiveProgram\\PPAP_MoritzGart.mp3", IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CHANNEL"]))
				successful = true
			elseif (soundIdToast == 5487 or soundIdToast == "5487") then
				PlaySoundFile("Interface\\Addons\\IncentiveProgram\\004_applepie.mp3", IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CHANNEL"]))
				successful = true
			else 
				successful = PlaySound(soundIdToast, IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CHANNEL"]))
			end
			if successful then self.soundCountToast = self.soundCountToast - 1 end
		end
	end
	
	if ( self.cycleElapsed >= IncentiveProgram.CycleRate ) then
		self.cycleElapsed = 0
		
		if ( self.cycleCount == 0 and self.continousEnabled ) then
			self.cycleCount = 3
		end
		if ( self.cycleCount > 0 ) then
			if ( ( self.cycleCount % 3 ) == 0 ) then
				IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()
					,IncentiveProgram.Icons["INCENTIVE_PLENTIFUL"])
			elseif ( ( self.cycleCount % 3 ) == 1 ) then
				IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()
					,IncentiveProgram.Icons["INCENTIVE_UNCOMMON"])
			else
				IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()
					,IncentiveProgram.Icons["INCENTIVE_RARE"])
			end
			self.cycleCount = self.cycleCount - 1
		end
	end
	
	
    --[[if ( ( self.alertCount > 0 ) and ( self.elapsed > 1.5 ) ) then
        if ( ( self.alertCount % 3 ) == 0 ) then
            IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()
                ,IncentiveProgram.Icons["INCENTIVE_PLENTIFUL"])
        elseif ( ( self.alertCount % 3 ) == 1 ) then
            IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()
                ,IncentiveProgram.Icons["INCENTIVE_UNCOMMON"])
        else
            IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()
                ,IncentiveProgram.Icons["INCENTIVE_RARE"])
        end
        PlaySoundKitID(47615)
        self.alertCount = self.alertCount - 1
        
        if ( self.alertCount > 0 ) then
            self.elapsed = 0
        else
            self.elapsed = IncentiveProgram.TickRate - self.elapsed
        end
    end]]
end

---------------------------------------
-- SetCount is a global that can allow the setting of the count.  Updates frame and dbroker
-- @params
--      count - (Optional) Sets the text in the frame and the broker
--		texture - (Optional) Sets the texture of the frame and the broker
-- @returns
--		nil
---------------------------------------
function IncentiveProgram:SetCount(count, texture)
	if ( not count ) then count = 0 end
    if ( not texture ) then
        texture = IncentiveProgram.Icons["INCENTIVE_RARE"]
    end

    if ( count > 0 ) then
        IncentiveProgram:GetFrame():ShowTextures(count, texture)
        IncentiveProgram:GetDataBroker():SetData(count, texture)
    else
        IncentiveProgram:GetFrame():HideTextures()
        IncentiveProgram:GetDataBroker():SetData(count, IncentiveProgram.Icons["INCENTIVE_NONE"])
    end       
end

---------------------------------------
-- SetAlert has the frame and broker chime or provide parameters for the Toast.
-- @params
--      line1 - (Optional) Line 1 of the Toast
--		line2 - (Optional) Line 2 of the Toast
--		texture - (Optional) texture of the Toast
--		arg1 - (Optional) the dungeon ID of the Toast for the OnClick function
--		arg2 - Not in use
-- @returns
--		nil
---------------------------------------
function IncentiveProgram:SetAlert(line1, line2, texture, arg1, arg2)
    if ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["ALERT"]) ) then
        eventFrame.cycleCount = 3 * IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["CYCLE_COUNT"])
		IncentiveProgram:SetSound(IncentiveProgram.ALERT)
    end
    
    if ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["ALERT_TOAST"]) ) then
        IncentiveProgram:GetToast():AddToast(line1, line2, texture, arg1, arg2, IncentiveProgram:GetMenu().JoinDungeon)
		IncentiveProgram:SetSound(IncentiveProgram.TOAST)
    end
end

---------------------------------------
-- SetSound queues up the Event Frame to play sounds.  I did have this just in SetAlert, but I decided
-- 		I wanted the Toast Sounds to queue up on each new Toast pop up.  But then I decided again that
--		I did not want that, but I kept the function just in case I changed my mind again.
-- @params
--      alertType - Enum ALERT or TOAST to queue up a sound.
-- @returns
--		nil
---------------------------------------
function IncentiveProgram:SetSound(alertType)
	if ( alertType == IncentiveProgram.ALERT ) then
		if ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["ALERT_PING"]) ) then
			eventFrame.soundCountAlert = tonumber(IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["ALERT_REPEATS"])) or 0
		end
	elseif ( alertType == IncentiveProgram.TOAST ) then
		if ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["TOAST_PING"]) ) then
			eventFrame.soundCountToast = tonumber(IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["TOAST_REPEATS"])) or 0
		end
	end
end