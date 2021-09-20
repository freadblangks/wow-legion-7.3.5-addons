--[[
	Updater.lua
		Handles ranged updating + buff highlighting updating
--]]

-- Original code by Tuller. Modified by Starslayer.

Dominos_BuffTimes = LibStub("AceAddon-3.0"):NewAddon("Dominos_BuffTimes", 'AceConsole-3.0')

-- Uncomment for debug messages
--local bufftimes_debug = 1
Dominos_BuffTimes.debugLevel = 0

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};

--[[ Dominos_BuffTimes functions ]]--

function Dominos_BuffTimes:Debug(level, output)
    if level <= self.debugLevel then
        self:Print(output)
    end
end

function Dominos_BuffTimes:CheckDB()

	-- only initialise with default values if db has not been created
	local needsDefaults = (not self.db.char.ignored and
	   					   not self.db.char.yourbuffs and
	   					   not self.db.char.alldebuffs and
	   					   not self.db.char.selfbuffs and
	   					   not self.db.char.translated and
						   not self.db.char.override)
 
	-- populate db with default values if none are present
	if not self.db.char.ignored then
		self.db.char.ignored = {}
	end
	if not self.db.char.yourbuffs then
		self.db.char.yourbuffs = {}
	end
	if not self.db.char.alldebuffs then
		self.db.char.alldebuffs = {}
	end
	if not self.db.char.selfbuffs then
		self.db.char.selfbuffs = {}
	end
	if not self.db.char.translated then
		self.db.char.translated = {}
	end
	if not self.db.char.override then
		self.db.char.override = {}
	end
	
	if needsDefaults then
		local _, playerClass = UnitClass("player")
		local _, playerRace = UnitRace("player")
		
		self:SetDefaults(playerClass, playerRace)
	end
end

function Dominos_BuffTimes:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("Dominos_BuffTimesDB")
	self:CheckDB()
	self:RegisterSlashCommands()
	
	self.options = {}
	self:InitOptions()
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Dominos_BuffTimes", self.options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Dominos_BuffTimes", "快捷列-增益時間")
end

function Dominos_BuffTimes:OnEnable()
    -- Called when the addon is enabled
end

function Dominos_BuffTimes:OnDisable()
    -- Called when the addon is disabled
end

--[[ Local Functions ]]--

--clear a table, returning true if there was stuff to clear
local function ClearTable(t)
	if next(t) then
		wipe(t)
		return true
	end
end

--remove any values from t that are not in toClone
--adds any values from tableToClone that are not in t
--requires that both tables be using the same key value pairs
local function CloneTable(from, to)
	local changed = false

	for i,oldVal in pairs(to) do
		local newVal = from[i]
		if (not newVal and oldVal) or (newVal and not oldVal) or (oldVal and newVal and (oldVal.start ~= newVal.start or oldVal.duration ~= newVal.duration)) then
			to[i] = newVal
			changed = true
		end
	end

	for i,newVal in pairs(from) do
		local oldVal = to[i]
		if (not newVal and oldVal) or (newVal and not oldVal) or (oldVal and newVal and (oldVal.start ~= newVal.start or oldVal.duration ~= newVal.duration)) then
			to[i] = newVal
			changed = true
		end
	end

	return changed
end

--[[
	The Code
--]]

local Updater = CreateFrame('Frame')

Updater.targetBuffs = {}
Updater.targetBuffs['target'] = {}
Updater.targetBuffs['focus'] = {}
Updater.playerBuffs = {}
Updater.buttons = {}

--buff and debuff caches
local newVals = {} --store new info in here

function Dominos_BuffTimes:DebugOutputTable()
    self:Print('================')
	self:Print('Self:')
	self:OutputTable(Updater.playerBuffs)
	
	self:Print('Buff:')
	self:OutputTable(Updater.targetBuffs['target'])
	
	self:Print('newvals:')
	self:OutputTable(newVals)
	self:Print('================')
	
end

function Dominos_BuffTimes:OutputTable(table)
	for i,val in pairs(table) do
		local count = table[i].count
		if not count then count = 0 end
		self:Print(i .. ': ' ..  table[i].start .. ' ' .. table[i].duration .. ' (' .. count .. ')')
	end
end



--on update script, handles throttled buff and debuff updating as well as range updating
Updater:SetScript('OnUpdate', function(self, elapsed)
	if self.shouldUpdateBuffs then
		self.shouldUpdateBuffs = nil
        
        for _,b in pairs(self.buttons) do
		
			if b:IsVisible() and b.action and HasAction(b.action) then
				--ActionButton_UpdateState(b)
				if b.DBT_Update then
				    b.DBT_Update(b)
				end
			end
		end
	end
end)
Updater.nextUpdate = 1
Updater.delay = 0.025


--[[ Update Functions ]]--

function Updater:UpdatePlayerBuffs()
	local changed = false
	
	local name, duration, expirationTime, caster, count
	local i = 1
	repeat
		name, _, _, count, _, duration, expirationTime, caster = UnitBuff('player', i, 1)
		local isMine = PLAYER_UNITS[caster]
		
		if name then
			name = string.lower(name)
			if isMine or (not Dominos_BuffTimes:IsYourBuff(name) and not newVals[name]) then
				newVals[name] = {}
				newVals[name].start = expirationTime - duration
				newVals[name].duration = duration
				newVals[name].isMine = isMine
				newVals[name].count = count
			end
		end
		i = i + 1
	until not name

	if CloneTable(newVals, self.playerBuffs) then
		changed = true
	end
	
	ClearTable(newVals)

	--something changed, trigger update buffs
	if changed then
		self.shouldUpdateBuffs = true
	end
end

function Updater:UpdateTargetBuffs(unit, forceRefresh)
	local changed = false
	
	if(forceRefresh) then
		ClearTable(self.targetBuffs[unit])
	end
	
	if UnitExists(unit) then
		if UnitIsFriend('player', unit) then
			changed = self:UpdateFriendlyTargetBuffs(unit)
		else
			changed = self:UpdateEnemyTargetDebuffs(unit)
		end
	else
		changed = self:ClearTargetBuffsAndDebuffs(unit)
	end

	--if change, mark for updating
	if changed or forceRefresh then
		self.shouldUpdateBuffs = true
	end
end


function Updater:UpdateFriendlyTargetBuffs(unit)
	--friendly target, clear target debuffs
	local changed = false
	
	--add all target buffs into newVals
	local i = 1
	local name, duration, expirationTime, caster, count
	repeat
		name, _, _, count, _, duration, expirationTime, caster = UnitBuff(unit, i, 1)
		local isMine = PLAYER_UNITS[caster]
		
		if name then
			name = string.lower(name)
			-- prioritise our buffs over others
			if isMine or (not Dominos_BuffTimes:IsYourBuff(name) and not newVals[name]) then
				newVals[name] = {}
				newVals[name].start = expirationTime - duration
				newVals[name].duration = duration
				newVals[name].isMine = isMine
				newVals[name].count = count
			end
		end
		i = i + 1
	until not name

	--set changed to true if the target buffs table has changed
	if CloneTable(newVals, self.targetBuffs[unit]) then
		changed = true
	end
	
	ClearTable(newVals)

	return changed
end

function Updater:UpdateEnemyTargetDebuffs(unit)
	--enemy target, clear target buffs
	local changed = false

	--update debuffs on enemy targets
	local i = 1
	local name, duration, expirationTime, caster, count
	repeat
		name, _, _, count, _, duration, expirationTime, caster = UnitDebuff(unit, i)
		local isMine = PLAYER_UNITS[caster]
				
		if name then
			name = string.lower(name)
			-- prioritise our buffs over others
			if isMine or (not newVals[name] and Dominos_BuffTimes:IsAllDebuff(name)) then
				newVals[name] = {}
				newVals[name].start = expirationTime - duration
				newVals[name].duration = duration
				newVals[name].isMine = isMine
				newVals[name].count = count
			end
		end
		i = i + 1
	until not name

	--set changed to true if the target debuffs table has changed
	if CloneTable(newVals, self.targetBuffs[unit]) then
		changed = true
	end
	
	ClearTable(newVals)

	return changed
end

function Updater:ClearTargetBuffsAndDebuffs(unit)
	local changed = false

	if ClearTable(self.targetBuffs[unit]) then
		changed = true
	end
	
	return changed
end


--[[ Access Functions ]]--

function Updater:GetTargetBuff(unit, buff)
	return self.targetBuffs[unit][buff]
end

function Updater:GetTargetDebuff(unit, debuff)
	return self.targetBuffs[unit][debuff]
end

function Updater:PlayerHasBuff(buff)
	return self.playerBuffs[buff]
end


--[[ Action Button Updating ]]--

local function ShouldShowTimer(spell, buff, spellBuff, cdstart, cdduration)
	if Dominos_BuffTimes:IsIgnored(spell) then return nil end
	
	if Dominos_BuffTimes:IsSelfBuff(spell) then return 1 end
	
	if buff == 1 and Dominos_BuffTimes:IsYourBuff(spell) and not spellBuff.isMine then return nil end
	
	if buff == 0 and not Dominos_BuffTimes:IsAllDebuff(spell) and not spellBuff.isMine then return nil end
	
	if cdstart == nil or cdduration == 0 or Dominos_BuffTimes:IsOverride(spell) or spellBuff.start + spellBuff.duration > cdstart + cdduration then return 1 end
		
	return nil
end

local function HideDBTCooldown(self)
    if self.DBTCooldown and self.DBTCooldown:IsShown() then
        if bufftimes_debug then
           Dominos_BuffTimes:Print('HideDBTCooldown')
        end
        -- if there's still time on the timer then set it to zero
        -- otherwise, leave it so that OmniCC picks it up 
        self.DBTCooldown:SetCooldown(0, 0)
        self.DBTCooldown:Hide()
    end
end

local function GetRelevantBuff(spellBuff, otherBuff)
    local ret = spellBuff
    
    if otherBuff then
        local start, duration, enabled
        
        if not spellBuff or otherBuff.start + otherBuff.duration > spellBuff.start + spellBuff.duration then
            ret = otherBuff
        end
    end
    
    return ret
end

local function ActionButton_GetRelevantBuff(self, spell)
    local spellBuff = nil
    local isBuff = true
    
    if spell then
        local unit = self.unit
        
        -- translate spells
        local spellsToCheck = Dominos_BuffTimes:GetSpellTranslations(spell)
        
        if Dominos_BuffTimes:IsSelfBuff(spell) then
            for i in pairs(spellsToCheck) do
                local thisSpellBuff = Updater:PlayerHasBuff(i)
                spellBuff = GetRelevantBuff(spellBuff, thisSpellBuff)
            end
        else
            if UnitExists(unit) then
                if UnitIsFriend('player', unit) then
                    for i in pairs(spellsToCheck) do
                        local thisSpellBuff = Updater:GetTargetBuff(unit, i)
                        spellBuff = GetRelevantBuff(spellBuff, thisSpellBuff)
                    end
                else
                    for i in pairs(spellsToCheck) do
                        local thisSpellBuff = Updater:GetTargetDebuff(unit, i)
                        spellBuff = GetRelevantBuff(spellBuff, thisSpellBuff)
                    end
                    
                    if spellBuff then
                        -- must be debuff
                        isBuff = false
                    end
                end
            end
        end
    end
    
    return spellBuff, isBuff
end

local function ActionButton_CreateCooldown(self)
	  Dominos_BuffTimes:Debug(1, "Creating cooldown for " .. self.name)
	  local _G = getfenv(0)
    local name = self.name
    self.DBTOrigcooldown = _G[name .. 'Cooldown']
    self.DBTCooldown = CreateFrame('Cooldown', nil, self, 'CooldownFrameTemplate')
    self.DBTCooldown:SetAllPoints(self)
    
    -- create the charges
    self.DBTCooldown.count = self.DBTCooldown:CreateFontString(nil, nil, 'NumberFontNormalSmall')
    self.DBTCooldown.count:SetJustifyH('LEFT')
    self.DBTCooldown.count:SetPoint('BOTTOMLEFT', self.DBTCooldown, 'BOTTOMLEFT')
    self.DBTCooldown.count:SetAlpha(0.7)
end

local function ActionButton_ShowCount(self, count)
	if Dominos_BuffTimes:IsCountEnabled() and count > 1 then
		self.DBTCooldown.count:SetText(count)
		self.DBTCooldown.count:Show()
	else
		self.DBTCooldown.count:Hide()
	end	
end

local function ActionButton_UpdateTimer(self, spell, spellBuff)
    local showBorder = false
    
    if spellBuff and spellBuff.start ~= nil then
        local start, duration, enabled
        start, duration, enabled = GetSpellCooldown(spell)
        
        if ShouldShowTimer(spell, buff, spellBuff, start, duration) then
            if bufftimes_debug then
                Dominos_BuffTimes:Print('Showing cooldown' .. spell)
            end
            
            if self.DBTCooldown == nil then
                ActionButton_CreateCooldown(self)
            end
            
            self.DBTOrigcooldown:Hide()
            self.DBTCooldown:SetCooldown(spellBuff.start, spellBuff.duration)
            ActionButton_ShowCount(self, spellBuff.count)
            
            showBorder = true
        elseif self.DBTCooldown and self.DBTCooldown:IsShown() then
            if bufftimes_debug then
                Dominos_BuffTimes:Print('Setting to zero: ' .. spell)
            end
            
            HideDBTCooldown(self)
        elseif bufftimes_debug then
            if self.DBTCooldown then
                Dominos_BuffTimes:Print('DBTCooldown is not shown: ' .. spell)
            else
                Dominos_BuffTimes:Print('DBTCooldown is nil: ' .. spell)
            end
        end
        
        -- need to still show the border if start and duration is zero
        -- to show absolute corruption
        if spellBuff.start == 0 and spellBuff.duration == 0 then
            showBorder = true
        end
        
        -- this is expensive, just comment out for now
        -- uncomment for actual debugging
        --Dominos_BuffTimes:Debug(2, "ActionButton_UpdateTimer: " .. spell .. ": " .. start .. ", " .. (duration or "nil") .. ": ".. tostring(showBorder))
    end
    return showBorder
end

local function ActionButton_UpdateBorder(self, spell)
    local showBorder = nil
    
	if spell then
	
	    spell = string.lower(spell)
	
	    local spellBuff, isBuff = ActionButton_GetRelevantBuff(self, spell)
	       
        if spellBuff then
            if isBuff then
                self:GetCheckedTexture():SetVertexColor(0, 1, 0)
            else
                self:GetCheckedTexture():SetVertexColor(1, 0, 1)
            end
        end
	    
	    if spellBuff and spellBuff.isMine then --and spellBuff.duration ~= 0 then
	        return ActionButton_UpdateTimer(self, spell, spellBuff)
        else
            HideDBTCooldown(self)
            
            -- corner case - targeting enemy and spell is a buff
            -- show the border but not the timer
            local playerBuff = Updater:PlayerHasBuff(spell)
            if playerBuff and not UnitIsFriend('player', self.unit) and playerBuff.duration ~= 0 then
                self:GetCheckedTexture():SetVertexColor(0, 1, 0)
                return true
            end
            
            return false
        end
	end
	
	return showBorder
end

local function ActionButton_CheckCooldown (self)
	if self.DBTCooldown then
		if self.DBTCooldown:IsShown() then
		    if bufftimes_debug then
               Dominos_BuffTimes:Print('Hiding original cd')
            end
			self.DBTOrigcooldown:Hide()
		end
	end
end



local function ActionButton_IsSpellInUse(self)
	local spellID = self.DBTSpellID
	if spellID then
		if self.type == 'macro' then
			return ActionButton_UpdateBorder(self, GetMacroSpell(spellID))
		end
		return ActionButton_UpdateBorder(self, spellID)
	end
end

function ActionButton_GetPagedID (self)
    return self.action;
end

local BT4ButtonPrefix = 'BT4Button'

local function IsBT4Button(name)
	return name and string.sub(name, 1, string.len(BT4ButtonPrefix)) == BT4ButtonPrefix 
end

local function ActionButton_UpdateSpell(self)
    if not self.name then
    	-- must be a Blizzard button
    	self.name = self:GetName()
    end
    
    if IsBT4Button(self.name) then
    	local type, id = self:GetAction()
    	if type == 'action' then
    	    self.action = id
    	else
    	    self.action = nil
    	end
    end
    		
    if self.action then
		local type, id, _, globalID = GetActionInfo(self.action)
		self.unit = 'target'
		self.type = type
		
		if type == 'spell' then
			if id and id > 0 then
			    self.DBTSpellID = GetSpellInfo(id)
			elseif globalID then
				self.DBTSpellID = GetSpellInfo(globalID)
			else
				self.DBTSpellID = nil
			end
		elseif type == 'item' then
			self.DBTSpellID = GetItemSpell(id)
		else
			self.DBTSpellID = id
			local macroSpell = GetMacroSpell(self.DBTSpellID)
		end
		
		if type == 'macro' then
			local macroName, macroIcon, macroBody, macroLocal = GetMacroInfo(id)
			
			if macroName ~= nil then
				-- check if we have ' Focus' in the macro name, if so, target is 'focus' for this button
				local startPos, endPos = string.find(macroName, '%sFocus')
			
				if startPos ~= nil then
					self.unit = 'focus'
				end
			end
		end
	end
end

local function ActionButton_UpdateStateHook(self)
	local isChecked = self:GetChecked()
    local shouldBeChecked = ActionButton_IsSpellInUse(self) or isChecked
    
    if isChecked ~= shouldBeChecked then
    	self:SetChecked(shouldBeChecked)
    end
end

hooksecurefunc('ActionButton_UpdateState', ActionButton_UpdateStateHook)
hooksecurefunc('ActionButton_Update', ActionButton_UpdateSpell)
hooksecurefunc('ActionButton_UpdateCooldown', ActionButton_CheckCooldown)

--[[ Events ]]--

--buff and debuff updating stuff
Updater:SetScript('OnEvent', function(self, event, unit)
	if event == 'PLAYER_TARGET_CHANGED' then
		self:UpdateTargetBuffs('target', true)
		if bufftimes_debug then
		    Dominos_BuffTimes:Print("Player target changed")
		end
	elseif event == 'PLAYER_FOCUS_CHANGED' then
		self:UpdateTargetBuffs('focus', true)
	elseif event == 'UNIT_AURA' then
		if unit == 'target' or unit == 'focus' then
			self:UpdateTargetBuffs(unit)
		elseif unit == 'player' then
			self:UpdatePlayerBuffs()
		end
		
		if bufftimes_debug then
            Dominos_BuffTimes:Print("Unit aura")
        end
	elseif event == 'PLAYER_ENTERING_WORLD' then
		self:UpdateTargetBuffs('target')
		self:UpdateTargetBuffs('focus')
		self:UpdatePlayerBuffs()
	elseif event == 'ACTIONBAR_UPDATE_COOLDOWN' or event == 'ACTIONBAR_UPDATE_STATE' then
		self.shouldUpdateBuffs = true
	end
end)

Updater:RegisterEvent('UNIT_AURA')
Updater:RegisterEvent('PLAYER_TARGET_CHANGED')
Updater:RegisterEvent('PLAYER_FOCUS_CHANGED')
Updater:RegisterEvent('PLAYER_ENTERING_WORLD')

Updater:RegisterEvent('ACTIONBAR_UPDATE_COOLDOWN')
Updater:RegisterEvent('ACTIONBAR_UPDATE_STATE')

--[[ Loading ]]--

--register buttons
local function RegisterButton(button, updateHook)
	if button then
	  Dominos_BuffTimes:Debug(1, "Registered button")
		table.insert(Updater.buttons, button)
		button.DBT_Update = updateHook
	end
end

for id = 1, NUM_ACTIONBAR_BUTTONS do
	RegisterButton(_G['ActionButton' .. id], ActionButton_UpdateState)
	RegisterButton(_G['BonusActionButton' .. id], ActionButton_UpdateState)
	RegisterButton(_G['MultiBarRightButton' .. id], ActionButton_UpdateState)
	RegisterButton(_G['MultiBarLeftButton' .. id], ActionButton_UpdateState)
	RegisterButton(_G['MultiBarBottomRightButton' .. id], ActionButton_UpdateState)
	RegisterButton(_G['MultiBarBottomLeftButton' .. id], ActionButton_UpdateState)
end

local function LAB_Update(self)
	self:UpdateAction(true)
end

local DominosButtonPrefix = 'DominosActionButton'

if Dominos then
	for id = 1, 120 do
		if _G[DominosButtonPrefix .. id] then
			RegisterButton(_G[DominosButtonPrefix .. id], ActionButton_UpdateState)
		end
	end
end

if Bartender4 then
	for id = 1, 120 do
		if _G[BT4ButtonPrefix .. id] then
			RegisterButton(_G[BT4ButtonPrefix .. id], LAB_Update)
		end
	end
end

--register any stock action buttons created after this addon is loaded
    hooksecurefunc('ActionButton_OnLoad', function(self)
	table.insert(Updater.buttons, self)
	RegisterButton(self, ActionButton_UpdateState)
end)

-- register LibActionButton hooks
local LAB = LibStub("LibActionButton-1.0", true)

if LAB then
	LAB.RegisterCallback(Dominos_BuffTimes, "OnButtonCreated", function(_, button)
		RegisterButton(button, LAB_Update)
	end)
	LAB.RegisterCallback(Dominos_BuffTimes, "OnButtonUpdate", function(_, button) ActionButton_UpdateSpell(button) end)
	LAB.RegisterCallback(Dominos_BuffTimes, "OnButtonState", function(_, button) ActionButton_UpdateStateHook(button) end)
end

