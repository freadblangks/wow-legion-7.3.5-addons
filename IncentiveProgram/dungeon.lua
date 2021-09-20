-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

--Local copy of the class
local dungeon

---------------------------------------
-- getDungeonInfo is a helper class that populates the "static" tables
-- @params
--      nil
-- @returns
--		dungeonIDs - iterable table of the joinable LFGs IDs
--		dungeonNames - iterable table of the joinable LFGs Names
--		dungeonTypes - iterable table of the dungeonTypes
---------------------------------------   
local function getDungeonInfo()
    local dungeonIDs, dungeonNames, dungeonTypes = {}, {}, {}
    
    for i=1, GetNumRFDungeons() do
        local id, name = GetRFDungeonInfo(i)
        IncentiveProgram:GetSettings():SetDungeonSetting(id, IncentiveProgram.Settings["DUNGEON_NAME"], name)
        IncentiveProgram:GetSettings():SetDungeonSetting(id, IncentiveProgram.Settings["DUNGEON_TYPE"], LE_LFG_CATEGORY_RF)
        if IsLFGDungeonJoinable(id) then
            tinsert(dungeonIDs, id)
            tinsert(dungeonNames, name)
            tinsert(dungeonTypes, LE_LFG_CATEGORY_RF)
        end
    end
    
    for i=1, GetNumRandomDungeons() do
        local id, name = GetLFGRandomDungeonInfo(i)
        IncentiveProgram:GetSettings():SetDungeonSetting(id, IncentiveProgram.Settings["DUNGEON_NAME"], name)
        IncentiveProgram:GetSettings():SetDungeonSetting(id, IncentiveProgram.Settings["DUNGEON_TYPE"], LE_LFG_CATEGORY_LFD)
        if IsLFGDungeonJoinable(id) then
            tinsert(dungeonIDs, id)
            tinsert(dungeonNames, name)
            tinsert(dungeonTypes, LE_LFG_CATEGORY_LFD)
        end
    end
    
    return dungeonIDs, dungeonNames, dungeonTypes
end

---------------------------------------
-- canQueueForRoles accepts the shortage state of the roles and applies additional logic to see if these should
--	  be considered when counting dungeons.  I haven't added any logic yet.
-- @params
--      tank - boolean shortage status of Tank role
--		healer - boolean shortage status of Healer role
--		damage - boolean shortage status of Damage role
-- @returns
--      tank - boolean shortage status of Tank role
--		healer - boolean shortage status of Healer role
--		damage - boolean shortage status of Damage role
---------------------------------------   
local function canQueueForRoles(tank, healer, damage)
	local roleTank = IncentiveProgram:GetSettings():GetUserSetting(IncentiveProgram.Settings["ROLE_TANK"])
	local roleHealer = IncentiveProgram:GetSettings():GetUserSetting(IncentiveProgram.Settings["ROLE_HEALER"])
	local roleDamage = IncentiveProgram:GetSettings():GetUserSetting(IncentiveProgram.Settings["ROLE_DAMAGE"])
	
	tank = tank and roleTank
	healer = healer and roleHealer
	damage = damage and roleDamage

    return tank, healer, damage
end

---------------------------------------
-- getAlertText takes the Shortage Key and returns what I want Line 2 of the Toast to say
-- Shortage Key is ShortageType..TankStatus..HealerStatus..DamageStatus..ItemCount..MoneyCount..XPCount
-- e.g. 1ThD200 says there is a Tank and Damage shortage with 2 available items.
-- @params
--      tempKey - Shortage Key from the temp table
-- @returns
--      returnString - What I want Line 2 of the Toast to say based on shortage Roles
---------------------------------------   
local function getAlertText(tempKey)
    local returnString
    
    if ( string.find(tempKey, "T") ) then
        returnString = IncentiveProgram.TOAST_TANK
    end
    
    if ( string.find(tempKey, "H") ) then
        if ( returnString ) then
            returnString = returnString.." | "..IncentiveProgram.TOAST_HEALER
        else
            returnString = IncentiveProgram.TOAST_HEALER
        end
    end
    
    if ( string.find(tempKey, "D") ) then
        if ( returnString ) then
            returnString = returnString.." | "..IncentiveProgram.TOAST_DAMAGE
        else
            returnString = IncentiveProgram.TOAST_DAMAGE
        end
    end
    
    return returnString
end

local function sendAlert(dungeonID, tempKey)
	local flair = IncentiveProgram.Flair[dungeonID] or ""
	local name = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["DUNGEON_NAME"]) or ""
	local line1 = flair..name
	
	local line2 = getAlertText(tempKey) or ""

	local texture = select(11, GetLFGDungeonInfo(dungeonID))
	if ( texture and texture ~= "" and type(texture) ~= "number" ) then
		texture = "Interface\\LFGFrame\\UI-LFG-BACKGROUND-"..texture
	else
		texture = texture or 348520
	end
	
	local ignoreCompletedLFRs = IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["IGNORE_COMPLETED_LFR"])
	local ignoreDungeon = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["IGNORE"])
	
	if ( ignoreCompletedLFRs ) then
		local encounterDone, encounterTotal = GetLFGDungeonNumEncounters(dungeonID)

		if ( encounterDone == 0 ) then --Not an LFR, so alert.
			IncentiveProgram:SetAlert(line1, line2, texture, dungeonID)
		elseif ( encounterDone ~= encounterTotal ) then --all of the LFRs have not been completed.
			IncentiveProgram:SetAlert(line1, line2, texture, dungeonID)
		end
	elseif (not ignoreDungeon ) then
		IncentiveProgram:SetAlert(line1, line2, texture, dungeonID)
	end
end

---------------------------------------
-- Class: Dungeon
-- This class looks for shortages and returns data revolving around any Dungeon logic.
---------------------------------------
local IncentiveProgramDungeon = {
    new = function(self)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
        
        self.dungeonIDShortage = {}
        self.dungeonIDShortageTemp = {}
        self.dungeonIDs, self.dungeonNames, self.dungeonTypes = getDungeonInfo()
        
        return obj
    end,

---------------------------------------
-- GetShortage gets a current list of all Shortage dungeons and compares them to the saved shortage list.
-- It looks for a count and any changes in the shortage list.
-- @params
--      self - toast Class
-- @returns
--		self.dungeonIDShortage - table reference to the saved shortage list.
--		hasRemoved - boolean - if any shortages are removed since last checking
--		hasAdded - boolean - if any shortages have been added since last checking
--		hasDifference - boolean - if any shortages have changed available roles since last checking
---------------------------------------
    GetShortage = function(self)
        wipe(self.dungeonIDShortageTemp)
        
        local shortageType = 0
        
        for i=1, #self.dungeonIDs do
            for j=1, LFG_ROLE_NUM_SHORTAGE_TYPES do
                local eligible, forTank, forHealer, forDamage, itemCount, money, xp = GetLFGRoleShortageRewards(self.dungeonIDs[i], j)
                forTank, forHealer, forDamage = canQueueForRoles(forTank, forHealer, forDamage)
                eligible = eligible and (forTank or forHealer or forDamage)
                if ( eligible and ( itemCount ~= 0 or money ~= 0 or xp ~= 0 ) ) then
                    shortageType = j
                    if forTank then forTank = "T" else forTank = "t" end
                    if forHealer then forHealer = "H" else forHealer = "h" end
                    if forDamage then forDamage = "D" else forDamage = "d" end
                    self.dungeonIDShortageTemp[self.dungeonIDs[i]] = j..forTank..forHealer..forDamage..itemCount..money..xp
                end
            end
        end
        
        local hasRemoved, hasAdded, hasDifference
        
        for key, value in pairs(self.dungeonIDShortage) do
            if ( not self.dungeonIDShortageTemp[key] ) then
                --Removed from the shortage list
                hasRemoved = true
            end
        end
        
        for key, value in pairs(self.dungeonIDShortageTemp) do
            if ( not self.dungeonIDShortage[key] ) then
                --Added to shortage list
                hasAdded = true
                sendAlert(key, value)
            elseif ( value ~= self.dungeonIDShortage[key]) then
                --Difference in the roles eligble for shortage bonus
                hasDifference = true
                sendAlert(key, value)
            end
        end
        
        wipe(self.dungeonIDShortage)
        for key, value in pairs(self.dungeonIDShortageTemp) do
            self.dungeonIDShortage[key] = value
        end
        
        return self.dungeonIDShortage, hasRemoved, hasAdded, hasDifference
    end,
 
---------------------------------------
-- GetShortageCount gets a count of shortages, not counting ignored and ones already queued.
-- @params
--      self - Dungeon Class
-- @returns
--		count - number of shortages
--------------------------------------- 
    GetShortageCount = function(self)
        local tShortage = self:GetShortage()
        local count = 0
        for key, value in pairs(tShortage) do
            
            if ( self:IsQueued(key) ) then
            
            elseif ( IncentiveProgram:GetSettings():GetDungeonSetting(key, IncentiveProgram.Settings["IGNORE"]) ) then
            
            elseif ( not self:CanQueueForDungeon(key) ) then
            
			elseif ( IncentiveProgram:GetSettings():GetSetting(IncentiveProgram.Settings["IGNORE_COMPLETED_LFR"]) ) then
				local encounterDone, encounterTotal = GetLFGDungeonNumEncounters(key)

				if ( encounterDone == 0 ) then --Not an LFR, so alert.
					count = count + 1
				elseif ( encounterDone ~= encounterTotal ) then --all of the LFRs have not been completed.
					count = count + 1
				end
            else
                count = count + 1
            end
        end
        
        return count
    end,
	
---------------------------------------
-- GetCount gets a count of shortages, counting ignored and ones already queued.
-- @params
--      self - Dungeon Class
-- @returns
--		count - number of shortages
--------------------------------------- 
    GetCount = function(self)
        local tShortage = self:GetShortage()
        local count = 0
        for key, value in pairs(tShortage) do
            count = count + 1
        end
        
        return count
    end,
    
---------------------------------------
-- GetDungeonList returns the static copies of the dungeon tables
-- @params
--      self - Dungeon Class
-- @returns
--		self.dungeonIDs - iterable table of the joinable LFGs IDs
--		self.dungeonNames - iterable table of the joinable LFGs Names
--		self.dungeonTypes - iterable table of the dungeonTypes
--------------------------------------- 
    GetDungeonList = function(self)
        return self.dungeonIDs, self.dungeonNames, self.dungeonTypes
    end,
    
---------------------------------------
-- GetShortageRoles returns a list of eligible roles for a given dungeon
-- @params
--      self - Dungeon Class
--		dungeonID - ID of the dungeon
-- @returns
--		tank - boolean is tank eligible
--		healer - boolean is healer eligible
--		damage - boolean is damage eligible
--------------------------------------- 
    GetShortageRoles = function(self, dungeonID)
        local tank, healer, damage = false, false, false
        
        for i=1, LFG_ROLE_NUM_SHORTAGE_TYPES do
            local eligible, forTank, forHealer, forDamage, itemCount, money, xp = GetLFGRoleShortageRewards(dungeonID, i)
            if ( eligible and ( itemCount ~= 0 or money ~= 0 or xp ~= 0 ) ) then
                tank = tank or forTank
                healer = healer or forHealer
                damage = damage or forDamage
            end
        end
        
        return canQueueForRoles(tank, healer, damage)
    end,
    
---------------------------------------
-- CanQueueForDungeon returns all roles availble for shortage considering settings
-- @params
--      self - Dungeon Class
--		dungeonID - ID of the dungeon
-- @returns
--		eligible - boolean if eligible for shortage rewards
--		tank - boolean is tank eligible
--		healer - boolean is healer eligible
--		damage - boolean is damage eligible
---------------------------------------
    CanQueueForDungeon = function(self, dungeonID)
        local shortageTank, shortageHealer, shortageDamage = self:GetShortageRoles(dungeonID)
      
        local queueAsTank =  IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["QA_TANK"])
        local queueAsHealer = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["QA_HEALER"])
        local queueAsDamage = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["QA_DAMAGE"])

        if ( ( shortageTank and queueAsTank ) or ( shortageHealer and queueAsHealer ) or ( shortageDamage and queueAsDamage ) ) then
            return true, ( shortageTank and queueAsTank ), ( shortageHealer and queueAsHealer ), ( shortageDamage and queueAsDamage )
        else
            return false, false, false, false
        end
    end,
    
---------------------------------------
-- IsQueued returns if the dungeon ID is currently queued
-- @params
--      self - Dungeon Class
--		dungeonID - ID of the dungeon
-- @returns
--		boolean - returns true if dungeon ID is already queued for.
---------------------------------------
    IsQueued = function(self, dungeonID)
        for i=1, NUM_LE_LFG_CATEGORYS do
            for key, value in pairs(GetLFGQueuedList(i)) do
                if key == dungeonID then
                    return true
                end
            end
        end 
        return false
    end
}

---------------------------------------
-- IncentiveProgram:GetDungeon() is a global function.  This returns the Dungeon Class
-- @params
--      nil
-- @returns
--		Dungeon Class
---------------------------------------  
function IncentiveProgram:GetDungeon()
    if not dungeon then
        dungeon = IncentiveProgramDungeon:new()
    end
    
    return dungeon
end