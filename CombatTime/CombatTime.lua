-- Tweakable settings

-- timer color in combat
local COMBAT_R = 1
local COMBAT_G = 1
local COMBAT_B = 0
-- timer color out of combat
local NOCOMBAT_R = 0.5
local NOCOMBAT_G = 0.5
local NOCOMBAT_B = 0
local trigger_SW = false  -- set true to also trigger the in-game stopwatch on combat
local debugEnabled = false -- for addon debugging

local CombatTimeSettingsDefault = {
  ["locked"] = false,
  ["hide"] = false,
}

-- Non-tweakable settings
local addonName = "CombatTime"
local start_time = 0
local elapsed_time = 0.0
local combatzone = nil
local hiddenFrame = CreateFrame("Button", "CombatTimeHiddenFrame", UIParent)

local function chatMsg(msg) 
     DEFAULT_CHAT_FRAME:AddMessage("戰鬥時間："..msg)
end
local function debug(msg) 
  if debugEnabled then
     chatMsg(msg)
  end
end

function CombatTime_OnLoad(frame)
	-- frame:RegisterEvent("UNIT_COMBAT")
	frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
  frame:RegisterEvent("PLAYER_DEAD")
  frame:RegisterEvent("PLAYER_ALIVE")  
  frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
  frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out
	frame:RegisterForClicks("AnyUp")
  CombatTimeFrameText:SetTextColor(NOCOMBAT_R,NOCOMBAT_G,NOCOMBAT_B,1)		
  CombatTimeFrame:SetClampedToScreen(true)
  CombatTimeFrame:SetClampRectInsets(10,-10,-10,10)
end

function CombatTime_EnterCombat()
    combatzone = GetRealZoneText()
    debug("Entering combat in "..combatzone)
		-- start the timer
		start_time = GetTime()
    CombatTimeFrameText:SetTextColor(COMBAT_R,COMBAT_G,COMBAT_B,1)		
    hiddenFrame:SetScript("OnUpdate", CombatTime_OnUpdate);			
    CombatTime_UpdateText();
    		
    if (trigger_SW and StopwatchFrame and StopwatchFrame:IsShown() and not Stopwatch_IsPlaying()) then
       Stopwatch_Clear()
       Stopwatch_Play()
    end
end

function CombatTime_ExitCombat()
    debug("Exiting combat")
    CombatTimeFrameText:SetTextColor(NOCOMBAT_R,NOCOMBAT_G,NOCOMBAT_B,1)			
		CombatTime_UpdateText()
    hiddenFrame:SetScript("OnUpdate", nil);			
		
    if (trigger_SW and StopwatchFrame and StopwatchFrame:IsShown()) then
       Stopwatch_Pause()
    end		
end

SLASH_COMBATTIME1 = "/combattime"
SlashCmdList["COMBATTIME"] = function(msg)
	local cmd = msg:lower()
	if cmd == "reset" then
	  chatMsg("已恢復為預設值")
	  CombatTime_Reset()
	elseif cmd == "hide" then
	  chatMsg("已隱藏")
	  CombatTime_Hide()
	elseif cmd == "show" then
	  chatMsg("已顯示")
	  CombatTime_Show()	 
	elseif cmd == "toggle" then
	  chatMsg("切換顯示/隱藏")
	  CombatTime_Toggle()	   	  
	end
end

local function frameLock(locked)
    CombatTimeSettings.locked = locked
    if locked then
       CombatTimeFrame:SetMovable(false)     
    	 CombatTimeFrame:RegisterForDrag(nil)       
    else   
       CombatTimeFrame:SetMovable(true)
    	 CombatTimeFrame:RegisterForDrag("LeftButton")              
    end
end

local LDB, LDBo
local function setupLDB()
  if LDB then
    return
  end
  if AceLibrary and AceLibrary:HasInstance("LibDataBroker-1.1") then
    LDB = AceLibrary("LibDataBroker-1.1")
  elseif LibStub then
    LDB = LibStub:GetLibrary("LibDataBroker-1.1",true)
  end
  if LDB then
    LDBo = LDB:NewDataObject("CombatTime", {
        type = "data source",
        text = string.format("|cff%02x%02x%02x00:00|r", NOCOMBAT_R*255, NOCOMBAT_G*255, NOCOMBAT_B*255),
        label = "CombatTime",
        icon = "Interface\\Icons\\Ability_DualWield",
        OnClick = function(self, button)
                CombatTime_Toggle()
                if button == "RightButton" then
                        -- print("Right")
                else
                        -- print("Left")
                end
        end,
        OnTooltipShow = function(tooltip)
                if tooltip and tooltip.AddLine then
                        tooltip:SetText("CombatTime")
                        --tooltip:AddLine(L["|cffff8040Left Click|r to toggle the buff window"])
                        --tooltip:AddLine(L["|cffff8040Right Click|r for menu"])
                        tooltip:Show()
                end
        end,
     })
   end
end

function CombatTime_OnClick(self, button, down)
  debug("CombatTime_OnClick: "..button)
  if button == "RightButton" then
    frameLock(not CombatTimeSettings.locked)
    chatMsg("已"..((CombatTimeSettings.locked and "鎖定") or "解鎖").."位置")    
  end
end

function CombatTime_Reset()
  debug("CombatTime_Reset()")
	CombatTimeFrame:ClearAllPoints()
	CombatTimeFrame:SetPoint("TOPLEFT", "Minimap", "BOTTOMLEFT", 0, -10)	
	local  xOffset, yOffset = CombatTimeFrame:GetCenter();
	CombatTimeSettings.posX = xOffset
  CombatTimeSettings.posY = yOffset	
  frameLock(false)
end

function CombatTime_Hide()
  CombatTimeFrame:Hide()
  CombatTimeSettings.hide = true
end

function CombatTime_Show()
  CombatTimeFrame:Show()
  CombatTimeSettings.hide = false
end

function CombatTime_Toggle()
  if CombatTimeFrame:IsShown() then
    CombatTime_Hide()
  else
    CombatTime_Show()  
  end
end

function CombatTime_OnEvent(frame, event, name, ...)
	if event == "PLAYER_REGEN_ENABLED" then
		-- This event is called when the player exits combat
    debug("PLAYER_REGEN_ENABLED")		
		CombatTime_ExitCombat()
	elseif event == "PLAYER_REGEN_DISABLED" then
		-- This event is called when we enter combat
    debug("PLAYER_REGEN_DISABLED")			
    CombatTime_EnterCombat()
	elseif event == "PLAYER_DEAD" then
		-- This event is called when player dies
    debug("PLAYER_DEAD")			
	elseif event == "PLAYER_ALIVE" then
		-- This event is called when player releases or accepts a rez
    debug("PLAYER_ALIVE")			     
	elseif event == "ADDON_LOADED" and name == addonName then  
	  --CombatTimeFrame:SetUserPlaced(true) -- this autoloads the last position
	  if not CombatTimeSettings then
	    CombatTimeSettings = CombatTimeSettingsDefault
	    CombatTime_Reset()	  	    
	  else 
	    CombatTimeFrame:ClearAllPoints()
	    CombatTimeFrame:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", CombatTimeSettings.posX, CombatTimeSettings.posY)	  
	    frameLock(CombatTimeSettings.locked)
	  end	  
	  debug("ADDON_LOADED: CombatTimeSettings.posX="..CombatTimeSettings.posX.."  CombatTimeSettings.posY="..CombatTimeSettings.posY)
          if CombatTimeSettings.hide then
             CombatTime_Hide()
          else
             CombatTime_Show()  
          end	  
	elseif event == "ADDON_LOADED" and CombatTimeSettings then  
   	  setupLDB()
	elseif event == "PLAYER_LOGOUT" then
	  local  xOffset, yOffset = CombatTimeFrame:GetCenter();
	  CombatTimeSettings.posX = xOffset
	  CombatTimeSettings.posY = yOffset
	  debug("PLAYER_LOGOUT: CombatTimeSettings.posX="..CombatTimeSettings.posX.."  CombatTimeSettings.posY="..CombatTimeSettings.posY)
	  -- CombatTimeFrame:SetUserPlaced(true)
	end
end

function CombatTime_OnUpdate(self, elapsed)
    CombatTime_UpdateText(elapsed);
end

local SEC_TO_MINUTE_FACTOR = 1/60;
local SEC_TO_HOUR_FACTOR = SEC_TO_MINUTE_FACTOR*SEC_TO_MINUTE_FACTOR;

function CombatTime_UpdateText(elapsed)
  if elapsed then -- optimize away unnecessary updates
     elapsed_time = elapsed_time + elapsed
     if elapsed_time < 0.25 then
       return
     end
  else
     elapsed_time = 0.0
  end
  local total_time = GetTime() - start_time;
  local hour = min(floor(total_time*SEC_TO_HOUR_FACTOR), 99);
  local minute = mod(total_time*SEC_TO_MINUTE_FACTOR, 60);
  local second = mod(total_time, 60);	

	local status
	if hour == 0 then
	  status = string.format("%02d:%02d", minute, second)
	else
	  status = string.format("%02d:%02d:%02d", hour, minute, second)
	end

	CombatTimeFrameText:SetText(status)
	if LDBo then
	  local textR, textG, textB, textAlpha = CombatTimeFrameText:GetTextColor()
	  LDBo.text = string.format("|cff%02x%02x%02x%s|r", 
	                            textR*255, textG*255, textB*255, status)
	end
end

