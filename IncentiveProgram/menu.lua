-----------------------------
------Incentive Program------
----Created by: Jacob Beu----
-----Xubera @ US-Alleria-----
--------r16 | 08/30/2017-----
-----------------------------

local addonName, IncentiveProgram = ...

--Local copy of the class
local menu

-- Right Click Menu Table
local tank, healer, damage = C_LFGList.GetAvailableRoles()
if ( tank ) then tank = "" else tank = "\124CFFC41F3B" end
if ( healer ) then healer = "" else healer = "\124CFFC41F3B" end
if ( damage ) then damage = "" else damage = "\124CFFC41F3B" end
local menuData = {
    [1] = {
        ["text"] = IncentiveProgram.ContextLabels["ROLES"],
        ["notCheckable"] = true,
        ["hasArrow"] = true,
        ["value"] = { --submenu
            [1] = {
                ["text"] = tank..IncentiveProgram.ContextLabels["TANK"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["ROLES"],
                ["arg2"] = IncentiveProgram.Settings["ROLE_TANK"],
                ["keepShownOnClick"] = true
            },
            [2] = {
                ["text"] = healer..IncentiveProgram.ContextLabels["HEALER"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["ROLES"],
                ["arg2"] = IncentiveProgram.Settings["ROLE_HEALER"],
                ["keepShownOnClick"] = true
            },
            [3] = {
                ["text"] = damage..IncentiveProgram.ContextLabels["DAMAGE"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["ROLES"],
                ["arg2"] = IncentiveProgram.Settings["ROLE_DAMAGE"],
                ["keepShownOnClick"] = true
            }
        }
    },
    
    [2] = {
        ["notCheckable"] = true,
        ["text"] = IncentiveProgram.ContextLabels["IGNORED"],
        ["hasArrow"] = true,
        ["value"] = IncentiveProgram.ContextMenu["IGNORE"]
    },
    
    [3] = {
        ["iconOnly"] = true,
        ["notCheckable"] = true,
        ["keepShownOnClick"] = true,
        ["disabled"] = true,
        ["icon"] = IncentiveProgram.Icons["CONTEXT_MENU_DIVIDER"],
        ["iconInfo"] = {
            ["tCoordLeft"] = 0,
            ["tCoordRight"] = 1,
            ["tFitDropDownSizeX"] = true,
            ["tCoordTop"] = 0,
            ["tCoordBottom"] = 1,
            ["tSizeX"] = 0,
            ["tSizeY"] = 8
        }
    },
    
    [4] = {
        ["text"] = IncentiveProgram.ContextLabels["SETTINGS"],
        ["notCheckable"] = true,
        ["hasArrow"] = true,
        ["value"] = {
            [1] = {
                ["text"] = IncentiveProgram.ContextLabels["HIDE_IN_PARTY"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["SETTINGS"],
                ["arg2"] = IncentiveProgram.Settings["HIDE_IN_PARTY"],
                ["keepShownOnClick"] = true
            },
            [2] = {
                ["text"] = IncentiveProgram.ContextLabels["HIDE_ALWAYS"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["SETTINGS"],
                ["arg2"] = IncentiveProgram.Settings["HIDE_ALWAYS"],
                ["keepShownOnClick"] = true,
				["tooltipTitle"] = IncentiveProgram.ADDON_DISPLAY_NAME,
				["tooltipText"] = IncentiveProgram.ContextLabels["TOOLTIP_HIDE_ALWAYS"],
				["tooltipOnButton"] = 1
            },
            [3] = {
                ["text"] = IncentiveProgram.ContextLabels["ALERT"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["SETTINGS"],
                ["arg2"] = IncentiveProgram.Settings["ALERT"],
                ["keepShownOnClick"] = true
            },
            [4] = {
                ["text"] = IncentiveProgram.ContextLabels["ALERT_TOAST"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["SETTINGS"],
                ["arg2"] = IncentiveProgram.Settings["ALERT_TOAST"],
                ["keepShownOnClick"] = true
            },
            [5] = {
                ["text"] = IncentiveProgram.ContextLabels["IGNORE_COMPLETED_LFR"],
                ["isNotRadio"] = true,
                ["arg1"] = IncentiveProgram.ContextMenu["SETTINGS"],
                ["arg2"] = IncentiveProgram.Settings["IGNORE_COMPLETED_LFR"],
                ["keepShownOnClick"] = true,
				["tooltipTitle"] = IncentiveProgram.ADDON_DISPLAY_NAME,
				["tooltipText"] = IncentiveProgram.ContextLabels["TOOLTIP_IGNORE_LFR"],
				["tooltipOnButton"] = 1
            },
			[6] = {
				text = IncentiveProgram.ContextLabels["INTERFACE_PANEL"],
				arg1 = IncentiveProgram.ContextMenu["INTERFACE_PANEL"],
				notCheckable = true,
				leftPadding = 16
			}
        }
    }
}

---------------------------------------
-- createTitleInfo is a helper function that handles adding a Title to the frame's menu.
-- @params
--      level - Level of the context menu
-- @returns
--		nil
---------------------------------------   
local function createTitleInfo(level)
    local info = Lib_UIDropDownMenu_CreateInfo()
    
    --Add title
    info.text = IncentiveProgram.ADDON_DISPLAY_NAME
    info.isTitle = true
    info.notCheckable = true
    
    Lib_UIDropDownMenu_AddButton(info, level)
end

---------------------------------------
-- createSettingsMenu is a helper function that adds the settings based on the menuData table
--	 to the context menu
-- @params
--      level - Level of the context menu
--		level2Table - table passed in from Blizzard's UIDROPDOWNMENU interface 
-- @returns
--		nil
---------------------------------------   
local function createSettingsMenu(level, level2Table)
    if ( level == 1 ) then
        for i=1, #menuData do
            local info = Lib_UIDropDownMenu_CreateInfo();
            for key,value in pairs(menuData[i]) do
                info[key] = value
            end
            info.func = menu.MenuOnClick
            Lib_UIDropDownMenu_AddButton(info, level)
        end
    elseif ( level == 2 ) then
        for i=1, #level2Table do
            local info = Lib_UIDropDownMenu_CreateInfo();
            for key,value in pairs(level2Table[i]) do
                info[key] = value
            end
            if level2Table[i]["arg1"] == IncentiveProgram.ContextMenu["ROLES"] then
                info.checked = IncentiveProgram:GetSettings():GetUserSetting(level2Table[i]["arg2"])
            elseif level2Table[i]["arg1"] == IncentiveProgram.ContextMenu["SETTINGS"] then
                info.checked = IncentiveProgram:GetSettings():GetSetting(level2Table[i]["arg2"])
            end
            
            info.func = menu.MenuOnClick
            Lib_UIDropDownMenu_AddButton(info, level)
        end
    end
end

---------------------------------------
-- createSettingsIgnoreList is a helper function that adds any dungeons on the ignore list
--	 to the context menu
-- @params
--      level - Level of the context menu
-- @returns
--		nil
---------------------------------------   
local function createSettingsIgnoreList(level)
    local count = 0
    for key, value in pairs (IncentiveProgram:GetSettings().db.dungeonSettings) do
        if ( IncentiveProgram:GetSettings():GetDungeonSetting(key, IncentiveProgram.Settings["IGNORE"]) ) then
            local info = Lib_UIDropDownMenu_CreateInfo()
            info.text = value[IncentiveProgram.Settings["DUNGEON_NAME"]]
            info.notCheckable = true
            info.func = menu.MenuOnClick
            info.arg1 = IncentiveProgram.ContextMenu["IGNORE"]
            info.arg2 = key
            
            info.icon = IncentiveProgram.Icons["CONTEXT_MENU_RED_X"]
            info.padding = 8
            
            Lib_UIDropDownMenu_AddButton(info, level)
            count = count + 1
            if ( count >= 10 ) then break end
        end
    end
    
    if ( count == 0 ) then
        local info = Lib_UIDropDownMenu_CreateInfo()
        info.text = IncentiveProgram.ContextLabels["NO_IGNORED"]
        info.notCheckable = true
        info.disabled = true
        
        Lib_UIDropDownMenu_AddButton(info, level)
    end
end

---------------------------------------
-- createDungeonEntry is a helper function that adds dungeons to the left-click menu
-- @params
--		dungeonID - the ID of the dungeonID
--		name - the name of the dungeon
--      level - Level of the context menu
--		isShortage - boolean that indicates this entry is in the shortage list
--		showAll - boolean that asks to create all possible entries, including ignored and non-shortage
-- @returns
--		nil
---------------------------------------   
local function createDungeonEntry(dungeonID, name, level, isShortage, showAll)
    local info = Lib_UIDropDownMenu_CreateInfo()
    local isAvailble, isAvaibleToPlayer = IsLFGDungeonJoinable(dungeonID)

    if not ( isAvailble and isAvaibleToPlayer ) then
        info.disabled = true
    else
        info.hasArrow = true
    end

	local encounterDone, encounterTotal = GetLFGDungeonNumEncounters(dungeonID)
	local lfrCompleted = ( encounterDone == encounterTotal )
	if lfrCompleted and encounterDone > 0 then
		info.colorCode = "|cFF33FF44"
	end
    
    --Color red if ignored but showing all anyways
	local ignored = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["IGNORE"])
    if ( ignored and showAll ) then
        info.colorCode = "|cFFC41F3B"
    end
    
    --Queue Check
    if ( IncentiveProgram:GetDungeon():IsQueued(dungeonID) ) then
        info.colorCode = "|cFF69CCF0"
    end

    local flair = IncentiveProgram.Flair[dungeonID] or ""
    info.text = flair..name
    info.value = dungeonID
    info.notCheckable = true
    
    
    --Color gray if not in the shortage list but still showing all.
    if ( not isShortage and showAll ) then
        info.colorCode = "|cFF666666"
        Lib_UIDropDownMenu_AddButton(info, level)
	elseif ( ignored and showAll ) then
        Lib_UIDropDownMenu_AddButton(info, level)
    elseif ( isShortage and not ignored ) then
        Lib_UIDropDownMenu_AddButton(info, level)
    end  
end

---------------------------------------
-- createIgnoreButton is a helper function that adds the settings based ignore button to the dungeon's
--	 context menu
-- @params
--		dungeonID - ID of the dungeon
--      level - Level of the context menu
-- @returns
--		nil
---------------------------------------   
local function createIgnoreButton(dungeonID, level)
    local info = Lib_UIDropDownMenu_CreateInfo()
    
    if ( IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["IGNORE"]) ) then
        info.text = IncentiveProgram.ContextLabels["UNIGNORE"]
    else
        info.text = IncentiveProgram.ContextLabels["IGNORE"]
    end
    
    info.arg1 = IncentiveProgram.ContextMenu["QUEUE"]
    info.arg2 = IncentiveProgram.Settings["IGNORE"]
    info.value = dungeonID
    info.func = menu.MenuOnClick
    info.notCheckable = true
    Lib_UIDropDownMenu_AddButton(info, level)
end

---------------------------------------
-- createRoleButtons is a helper function that adds the dungeon settings based role buttons to the 
--    dungeon's context menu
-- @params
--		dungeonID - ID of the dungeon
--      level - Level of the context menu
--		showAll - Shows all roles, regardless of shortage (to help adjust settings)
-- @returns
--		nil
---------------------------------------   
local function createRoleButtons(dungeonID, level, showAll)
    local tank, healer, damage = C_LFGList.GetAvailableRoles()
    local shortageTank, shortageHealer, shortageDamage = IncentiveProgram:GetDungeon():GetShortageRoles(dungeonID)
    
    --Tank
    if ( tank and ( shortageTank or showAll ) ) then
        local info = Lib_UIDropDownMenu_CreateInfo()
        info.text = IncentiveProgram.ContextLabels["TANK"]
        info.arg1 = IncentiveProgram.ContextMenu["QUEUE"]
        info.arg2 = IncentiveProgram.Settings["QA_TANK"]
        info.value = dungeonID
        info.checked = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["QA_TANK"])
        info.isNotRadio = true
        info.func = menu.MenuOnClick
        info.keepShownOnClick = true
        
        if ( not shortageTank ) then
            info.colorCode = "|CFF666666"
        end
        
        Lib_UIDropDownMenu_AddButton(info, level)
    end
    
    --Healer
    if ( healer and ( shortageHealer or showAll ) ) then
        local info = Lib_UIDropDownMenu_CreateInfo()
        info.text = IncentiveProgram.ContextLabels["HEALER"]
        info.arg1 = IncentiveProgram.ContextMenu["QUEUE"]
        info.arg2 = IncentiveProgram.Settings["QA_HEALER"]
        info.value = dungeonID
        info.checked = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["QA_HEALER"])
        info.isNotRadio = true
        info.func = menu.MenuOnClick
        info.keepShownOnClick = true
        
        if ( not shortageHealer ) then
            info.colorCode = "|CFF666666"
        end
        
        Lib_UIDropDownMenu_AddButton(info, level)
    end
    
    --Damage
    if ( damage and ( shortageDamage or showAll ) ) then
        local info = Lib_UIDropDownMenu_CreateInfo()
        info.text = IncentiveProgram.ContextLabels["DAMAGE"]
        info.arg1 = IncentiveProgram.ContextMenu["QUEUE"]
        info.arg2 = IncentiveProgram.Settings["QA_DAMAGE"]
        info.value = dungeonID
        info.checked = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["QA_DAMAGE"])
        info.isNotRadio = true
        info.func = menu.MenuOnClick
        info.keepShownOnClick = true
        
        if ( not shortageDamage ) then
            info.colorCode = "|CFF666666"
        end
        
        Lib_UIDropDownMenu_AddButton(info, level)
    end
        
end

---------------------------------------
-- createJoinButton is a helper function that adds Join Queue button to the dungeon context menu
-- @params
--		dungeonID - ID of the dungeon
--      level - Level of the context menu
-- @returns
--		nil
---------------------------------------   
local function createJoinButton(dungeonID, level)
    local info = Lib_UIDropDownMenu_CreateInfo()
    info.text = IncentiveProgram.ContextLabels["JOIN_QUEUE"]
    info.arg1 = IncentiveProgram.ContextMenu["QUEUE"]
    info.arg2 = IncentiveProgram.ContextMenu["JOIN"]
    info.value = dungeonID
    info.func = menu.MenuOnClick
    info.notCheckable = true
    
    --If Queued, disabled
    if ( IncentiveProgram:GetDungeon():IsQueued(dungeonID) ) then
        info.disabled = true
    end
   
    if ( not IncentiveProgram:GetDungeon():CanQueueForDungeon(dungeonID) ) then
        info.disabled = true
    end
    
    Lib_UIDropDownMenu_AddButton(info, level)
end

---------------------------------------
-- Class: Menu
-- The Menu Class that draws the Left/Right click menu when interacting with the frame
-- or data broker.
---------------------------------------
local IncentiveProgramMenu = {
    new = function(self, parent)
        local obj = {}
        setmetatable(obj, self)
        self.__index = self
    
        local frame = CreateFrame("Frame", "IncentiveProgramFrameMenu", parent, "Lib_UIDropDownMenuTemplate", 1)
        obj.frame = frame
        return obj
    end,
    
---------------------------------------
-- MenuOnLoad is the function that is called when the drop down is asked for.  Blizzard's UIDROPDOWNMENU interface
-- calls this function.
--
-- The helper functions above really make this function easy to read
-- @params
--		menuFrame - the actual drop down menu frame (not "self" to reduce confusion)
--		level - what level in the drop down menu we are currently loading
-- @returns
--		nil
---------------------------------------   
    MenuOnLoad = function(menuFrame, level)
        if ( menu == menuFrame) then return end --Blizzard's Menu UI calls this function, shouldn't self call this.
        if ( menuFrame.button == "LeftButton" ) then
            if ( level == 1 ) then
                createTitleInfo(level)
                local showAll = IsShiftKeyDown()

                local dungeonIDs, dungeonNames, dungeonTypes = IncentiveProgram:GetDungeon():GetDungeonList()
                local shortage = IncentiveProgram:GetDungeon():GetShortage()
                
                for key, dungeonID in pairs(dungeonIDs) do
                    local name = dungeonNames[key]
                    if ( shortage[dungeonID] ) then
                        createDungeonEntry(dungeonID, name, level, true, showAll)
                    else
                        createDungeonEntry(dungeonID, name, level, false, showAll)
                    end
                end
            elseif ( level == 2 ) then
                local dungeonID = LIB_UIDROPDOWNMENU_MENU_VALUE
                local showAll = IsShiftKeyDown()
                
                createIgnoreButton(dungeonID, level)
                createRoleButtons(dungeonID, level, showAll)
                createJoinButton(dungeonID, level)
            end
        elseif (menuFrame.button == "RightButton" ) then
            if ( level == 1 ) then
                createTitleInfo(level)
                createSettingsMenu(level)
            elseif ( level == 2 ) then
                local level2Table = LIB_UIDROPDOWNMENU_MENU_VALUE
                if ( level2Table == IncentiveProgram.ContextMenu["IGNORE"] ) then
                    createSettingsIgnoreList(level)
                else
                    createSettingsMenu(level, level2Table)
                end
            end
        end
    end,
    
---------------------------------------
-- MenuOnClick is the function that is called when any button is clicked.  The button clicked is what calls
-- this function.
--
-- @params
--		menuButton - the button inside the drop down menu that was clicked
--		arg1 - arg1 stored in the menuButton
--		arg2 - arg2 stored in the menuButton
-- @returns
--		nil
---------------------------------------    
    MenuOnClick = function(menuButton, arg1, arg2)
        if ( arg1 == IncentiveProgram.ContextMenu["ROLES"] ) then
            if ( arg2 == IncentiveProgram.Settings["ROLE_TANK"] ) then
                IncentiveProgram:GetSettings():SetUserSetting(IncentiveProgram.Settings["ROLE_TANK"], menuButton.checked)
            elseif ( arg2 == IncentiveProgram.Settings["ROLE_HEALER"] ) then
                IncentiveProgram:GetSettings():SetUserSetting(IncentiveProgram.Settings["ROLE_HEALER"], menuButton.checked)
            elseif ( arg2 == IncentiveProgram.Settings["ROLE_DAMAGE"] ) then
                IncentiveProgram:GetSettings():SetUserSetting(IncentiveProgram.Settings["ROLE_DAMAGE"], menuButton.checked)
            end
            
            IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()) --Refresh Count
        elseif ( arg1 == IncentiveProgram.ContextMenu["IGNORE"] ) then
            IncentiveProgram:GetSettings():SetDungeonSetting(arg2, IncentiveProgram.Settings["IGNORE"], false)
            IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()) --Refresh Count
            
        elseif ( arg1 == IncentiveProgram.ContextMenu["SETTINGS"] ) then
            IncentiveProgram:GetSettings():SetSetting(arg2, menuButton.checked)
            IncentiveProgram:GetFrame():UpdatedSettings() --In case new settings now hide frame
            
        elseif ( arg1 == IncentiveProgram.ContextMenu["QUEUE"] ) then
            local dungeonID = LIB_UIDROPDOWNMENU_MENU_VALUE
            if ( arg2 == IncentiveProgram.Settings["IGNORE"] ) then
                local ignoreSetting = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, arg2)
                IncentiveProgram:GetSettings():SetDungeonSetting(dungeonID, arg2, not ignoreSetting)
            elseif ( ( arg2 == IncentiveProgram.Settings["QA_TANK"] ) or
                     ( arg2 == IncentiveProgram.Settings["QA_HEALER"] ) or 
                     ( arg2 == IncentiveProgram.Settings["QA_DAMAGE"] ) ) then
                IncentiveProgram:GetSettings():SetDungeonSetting(dungeonID, arg2, menuButton.checked)
            elseif ( arg2 == IncentiveProgram.ContextMenu["JOIN"] ) then
                menu:JoinDungeon(dungeonID, true)
            end
            
            IncentiveProgram:SetCount(IncentiveProgram:GetDungeon():GetShortageCount()) --Refresh Count
        elseif ( arg1 == IncentiveProgram.ContextMenu["INTERFACE_PANEL"] ) then
			InterfaceOptionsFrame_OpenToCategory(IncentiveProgramInterfacePanel) 
		end
    end,
   
---------------------------------------
-- JoinDungeon prepares the LFG Roles in the game to queue up for the eligble Incentive roles.
-- It saves the current state, applies the Incentive State, then tells the Addon to switch back
-- to the current state when done, as to not mess with the user's in-game settings.
--
-- For ease of use and to help the user experience what they would in game, this function actually
-- mimics the function calls of clicking the Join Button in Blizzard's interface.  I also hope that this
-- makes it forward compatible with future releases of the game if Blizzard changes their logic.
--
-- @params
--		self - the Menu Class
--		dungeonID - the ID of the dungeon
--		fromDropDownMenu - boolean to indicate if this was called from drop down or Toast.  If it was
--			called from Toast, we don't want to "Toggle" the drop down menu back on.
-- @returns
--		nil
---------------------------------------     
    JoinDungeon = function(self, dungeonID, fromDropDownMenu)
        local dungeonType = IncentiveProgram:GetSettings():GetDungeonSetting(dungeonID, IncentiveProgram.Settings["DUNGEON_TYPE"])
        local canQueue, tank, healer, damage = IncentiveProgram:GetDungeon():CanQueueForDungeon(dungeonID)
        local lfgLeader, lfgTank, lfgHealer, lfgDamage = GetLFGRoles()
        
        if ( ( dungeonType == LE_LFG_CATEGORY_RF ) and canQueue ) then
            SetLFGRoles(lfgLeader, tank, healer, damage)
            RaidFinderQueueFrame.raid = dungeonID
            RaidFinderQueueFrame_Join() --Blizzard function in RaidFinder.lua
            
            IncentiveProgram.SavedLFGRoles.isUpdated = true
            IncentiveProgram.SavedLFGRoles.Leader = lfgLeader
            IncentiveProgram.SavedLFGRoles.Tank = lfgTank
            IncentiveProgram.SavedLFGRoles.Healer = lfgHealer
            IncentiveProgram.SavedLFGRoles.Damage = lfgDamage
        elseif ( dungeonType == LE_LFG_CATEGORY_LFD ) and canQueue then
            SetLFGRoles(lfgLeader, tank, healer, damage)
            
            LFDQueueFrame.type = dungeonID
            LFDQueueFrame_Join() --Blizzard Function in LFGFrame.lua
            
            IncentiveProgram.SavedLFGRoles.isUpdated = true
            IncentiveProgram.SavedLFGRoles.Leader = lfgLeader
            IncentiveProgram.SavedLFGRoles.Tank = lfgTank
            IncentiveProgram.SavedLFGRoles.Healer = lfgHealer
            IncentiveProgram.SavedLFGRoles.Damage = lfgDamage
        end
        
        if ( fromDropDownMenu ) then
            Lib_ToggleDropDownMenu(1, nil, IncentiveProgram:GetFrame():GetUIMenuFrame(), IncentiveProgram:GetFrame():GetAnchorFrame() or IncentiveProgram:GetFrame():GetUIFrame(), 0, 0) --Close context menu and lock until LFGRoles reset
        end
    end
}

---------------------------------------
-- IncentiveProgram:CreateMenu() is a global function.  The Frame Class is intended to call the create where other
-- parts of the addon should just use GetMenu().  Create Menu allows you to change the parent if needed as well.
-- @params
--      parent - sets the parent of the menu frame.  This needs to be a Widget
-- @returns
--		Menu Class
---------------------------------------   
function IncentiveProgram:CreateMenu(parent)
    if ( not parent ) then return end
    if ( not menu ) then
        menu = IncentiveProgramMenu:new(parent)
    else
        menu.frame:SetParent(parent)
    end
    
    return menu
end

---------------------------------------
-- IncentiveProgram:GetMenu() is a global function.  This returns the Menu Class if it has already been created.
-- @params
--      nil
-- @returns
--		Menu Class
---------------------------------------  
function IncentiveProgram:GetMenu()
    if ( not menu ) then return end
    
    return menu
end