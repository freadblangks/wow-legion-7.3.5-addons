-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

--Local copy of the class
local settings

local defaultSettings = {}
    defaultSettings[IncentiveProgram.Settings["QA_TANK"]] = true
    defaultSettings[IncentiveProgram.Settings["QA_HEALER"]] = true
    defaultSettings[IncentiveProgram.Settings["QA_DAMAGE"]] = true
    defaultSettings[IncentiveProgram.Settings["IGNORE"]] = false
    defaultSettings[IncentiveProgram.Settings["HIDE_IN_PARTY"]] = true
    defaultSettings[IncentiveProgram.Settings["HIDE_ALWAYS"]] = false
	defaultSettings[IncentiveProgram.Settings["HIDE_EMPTY"]] = false
    defaultSettings[IncentiveProgram.Settings["ALERT"]] = true
    defaultSettings[IncentiveProgram.Settings["ALERT_TOAST"]] = true
    defaultSettings[IncentiveProgram.Settings["COUNT_EVEN_IF_NOT_SELECTED"]] = false
    defaultSettings[IncentiveProgram.Settings["COUNT_EVEN_IF_NOT_ROLE_ELIGIBLE"]] = false

    --default values for roles you want to play determined
    --by the roles you can play
    local tank, healer, damage = C_LFGList.GetAvailableRoles()
    defaultSettings[IncentiveProgram.Settings["ROLE_TANK"]] = tank
    defaultSettings[IncentiveProgram.Settings["ROLE_HEALER"]] = healer
    defaultSettings[IncentiveProgram.Settings["ROLE_DAMAGE"]] = damage
    
    defaultSettings[IncentiveProgram.Settings["FRAME_TOP"]] = -1
    defaultSettings[IncentiveProgram.Settings["TOAST_TOP"]] = -1
	
	defaultSettings[IncentiveProgram.Settings["ALERT_PING"]] = true
	defaultSettings[IncentiveProgram.Settings["ALERT_SOUND"]] = 1069
	defaultSettings[IncentiveProgram.Settings["ALERT_REPEATS"]] = 1
	defaultSettings[IncentiveProgram.Settings["TOAST_PING"]] = true
	defaultSettings[IncentiveProgram.Settings["TOAST_SOUND"]] = 5487
	defaultSettings[IncentiveProgram.Settings["TOAST_REPEATS"]] = 1
	defaultSettings[IncentiveProgram.Settings["CYCLE_COUNT"]] = 2
	defaultSettings[IncentiveProgram.Settings["CONTINUOUSLY_CYCLE"]] = false
	defaultSettings[IncentiveProgram.Settings["CHANNEL"]] = "SFX"


---------------------------------------
-- Class: Settings
-- This class gets and sets current settings
---------------------------------------
local IncentiveProgramSettings = {
    new = function(self)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        
		
		IncentiveProgramDB = IncentiveProgramDB or {}
		
        local db = IncentiveProgramDB
        db.settings = db.settings or {}
        db.dungeonSettings = db.dungeonSettings or {}
        db.userSettings = db.userSettings or {}
        
        obj.db = db
        
        return obj
    end,
    
---------------------------------------
-- GetSetting gets the current setting
-- @params
--      self - Setting Class
--		key - Setting key
-- @returns
--		setting result
---------------------------------------
    GetSetting = function(self, key)
        if not key then return end
        if not self.db then return end
        if not self.db.settings then self.db.settings = {} end
        
        if self.db.settings[key] == nil then
            self.db.settings[key] = defaultSettings[key] or false
        end
        
        return self.db.settings[key]
    end,

    
---------------------------------------
-- SetSetting Sets the current setting
-- @params
--      self - Setting Class
--		key - Setting key
--		value - new setting value
-- @returns
--		nil
---------------------------------------    
    SetSetting = function(self, key, value)
        if value == nil then return end
        if not key then return end
        if not self.db then return end
        if not self.db.settings then self.db.settings = {} end
        
        self.db.settings[key] = value
    end,
    
    
---------------------------------------
-- GetDungeonSetting gets the current setting relating to the given dungeon
-- @params
--      self - Setting Class
--		id - id of the dungeon
--		key - Setting key
-- @returns
--		setting result
---------------------------------------
    GetDungeonSetting = function(self, id, key)
        if ( not id or not key ) then return end
        if not self.db then return end
        if not self.db.dungeonSettings then self.db.dungeonSettings = {} end
        if not self.db.dungeonSettings[id] then self.db.dungeonSettings[id] = {} end
        
        if self.db.dungeonSettings[id][key] == nil then
            self.db.dungeonSettings[id][key] = defaultSettings[key] or false
        end
        
        return self.db.dungeonSettings[id][key]        
    end,
   
    
---------------------------------------
-- SetDungeonSetting Sets the current setting relating to the given dungeon
-- @params
--      self - Setting Class
--		id - id of the dungeon
--		key - Setting key
--		value - new value of setting
-- @returns
--		nil
---------------------------------------   
    SetDungeonSetting = function(self, id, key, value)
        if value == nil then return end
        if ( not id or not key ) then return end
        if not self.db.dungeonSettings then self.db.dungeonSettings = {} end
        if not self.db.dungeonSettings[id] then self.db.dungeonSettings[id] = {} end
        
        self.db.dungeonSettings[id][key] = value
    end,
    
---------------------------------------
-- GetUserSetting gets the current user's setting
-- @params
--      self - Setting Class
--		key - Setting key
-- @returns
--		setting result
---------------------------------------
    GetUserSetting = function(self, key)
        if not key then return end
        if not self.db then return end
        if not self.db.userSettings then self.db.userSettings = {} end
     
		if not self.guid then self.guid = UnitGUID("player") end
		if not self.guid then return (defaultSettings[key] or false) end
	 
        if not self.db.userSettings[self.guid] then self.db.userSettings[self.guid] = {} end
        
        if self.db.userSettings[self.guid][key] == nil then
            self.db.userSettings[self.guid][key] = defaultSettings[key] or false
        end
        
        return self.db.userSettings[self.guid][key]
    end,
    
    
---------------------------------------
-- SetUserSetting Sets the current user's setting
-- @params
--      self - Setting Class
--		key - Setting key
--		value - new setting value
-- @returns
--		nil
---------------------------------------  
    SetUserSetting = function(self, key, value)
        if value == nil then return end
        if not key then return end
        if not self.db then return end
        if not self.db.userSettings then self.db.userSettings = {} end
		
		if not self.guid then self.guid = UnitGUID("player") end
		if self.guid then
			if not self.db.userSettings[self.guid] then self.db.userSettings[self.guid] = {} end
			
			self.db.userSettings[self.guid][key] = value
		end
    end
}

---------------------------------------
-- IncentiveProgram:GetSettings() is a global function.  This returns the Settings Class
-- @params
--      nil
-- @returns
--		Settings Class
---------------------------------------  
function IncentiveProgram:GetSettings()
    if not settings then
        settings = IncentiveProgramSettings:new()
		IncentiveProgram.CreateInterfacePanel() --Settings are now loaded, load up the Interface Panel
    end
    
    return settings
end
