----------------------------------------------------------------------
-- 	Leatrix Plus 7.3.33 (2nd May 2018, www.leatrix.com)
----------------------------------------------------------------------

--	01:Functions	20:Live			50:Player		72:Profile		
--	02:Locks		30:Isolated 	60:RunOnce		74:Logout	
--	03:Restarts		40:Variable		70:Events		80:Commands

----------------------------------------------------------------------
-- 	Leatrix Plus
----------------------------------------------------------------------

--  Create global table
	_G.LeaPlusDB = _G.LeaPlusDB or {}

-- 	Create locals
	local LeaPlusLC, LeaPlusCB, LeaDropList, LeaConfigList = {}, {}, {}, {}
	local ClientVersion = GetBuildInfo()
	local GameLocale = GetLocale()
	local void

--	Version
	LeaPlusLC["AddonVer"] = "7.3.33"

----------------------------------------------------------------------
--	L00: Leatrix Plus
----------------------------------------------------------------------

-- 	Get locale table
	local void, Leatrix_Plus = ...
	local L = Leatrix_Plus.L

--	Initialise variables
	LeaPlusLC["ShowErrorsFlag"] = 1
	LeaPlusLC["NumberOfPages"] = 9
	LeaPlusLC["RaidColors"] = RAID_CLASS_COLORS

--	Create event frame
	local LpEvt = CreateFrame("FRAME")
	LpEvt:RegisterEvent("ADDON_LOADED")
	LpEvt:RegisterEvent("VARIABLES_LOADED")
	LpEvt:RegisterEvent("PLAYER_ENTERING_WORLD")

----------------------------------------------------------------------
--	L01: Functions
----------------------------------------------------------------------

	-- Print text
	function LeaPlusLC:Print(text)
		DEFAULT_CHAT_FRAME:AddMessage(L[text], 1.0, 0.85, 0.0)
	end

	-- Lock and unlock an item
	function LeaPlusLC:LockItem(item, lock)
		if lock then
			item:Disable()
			item:SetAlpha(0.3)
		else
			item:Enable()
			item:SetAlpha(1.0)
		end
	end

	-- Hide configuration panels
	function LeaPlusLC:HideConfigPanels()
		for k, v in pairs(LeaConfigList) do
			v:Hide()
		end
	end

	-- Load a string variable or set it to default if it's not set to "On" or "Off"
	function LeaPlusLC:LoadVarChk(var, def)
		if LeaPlusDB[var] and type(LeaPlusDB[var]) == "string" and LeaPlusDB[var] == "On" or LeaPlusDB[var] == "Off" then
			LeaPlusLC[var] = LeaPlusDB[var]
		else
			LeaPlusLC[var] = def
			LeaPlusDB[var] = def
		end
	end

	-- Load a numeric variable and set it to default if it's not within a given range
	function LeaPlusLC:LoadVarNum(var, def, valmin, valmax)
		if LeaPlusDB[var] and type(LeaPlusDB[var]) == "number" and LeaPlusDB[var] >= valmin and LeaPlusDB[var] <= valmax then
			LeaPlusLC[var] = LeaPlusDB[var]
		else
			LeaPlusLC[var] = def
			LeaPlusDB[var] = def
		end
	end

	-- Load an anchor point variable and set it to default if the anchor point is invalid
	function LeaPlusLC:LoadVarAnc(var, def)
		if LeaPlusDB[var] and type(LeaPlusDB[var]) == "string" and LeaPlusDB[var] == "CENTER" or LeaPlusDB[var] == "TOP" or LeaPlusDB[var] == "BOTTOM" or LeaPlusDB[var] == "LEFT" or LeaPlusDB[var] == "RIGHT" or LeaPlusDB[var] == "TOPLEFT" or LeaPlusDB[var] == "TOPRIGHT" or LeaPlusDB[var] == "BOTTOMLEFT" or LeaPlusDB[var] == "BOTTOMRIGHT" then
			LeaPlusLC[var] = LeaPlusDB[var]
		else
			LeaPlusLC[var] = def
			LeaPlusDB[var] = def
		end
	end

	-- Show tooltips for checkboxes
	function LeaPlusLC:TipSee()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = self:GetParent()
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (parent:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Show tooltips for configuration buttons and dropdown menus
	function LeaPlusLC:ShowTooltip()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = LeaPlusLC["PageF"]
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (LeaPlusLC["PageF"]:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Show tooltips for interface settings (not currently used)
	function LeaPlusLC:ShowFacetip()
		GameTooltip:SetOwner(self, "ANCHOR_TOP")
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Create configuration button
	function LeaPlusLC:CfgBtn(name, parent)
		local CfgBtn = CreateFrame("BUTTON", nil, parent)
		LeaPlusCB[name] = CfgBtn
		CfgBtn:SetWidth(20)
		CfgBtn:SetHeight(20)
		CfgBtn:SetPoint("LEFT", parent.f, "RIGHT", 0, 0)

		CfgBtn.t = CfgBtn:CreateTexture(nil, "BORDER")
		CfgBtn.t:SetAllPoints()
		CfgBtn.t:SetTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn.t:SetTexCoord(0, 0.50, 0, 0.50);
		CfgBtn.t:SetVertexColor(1.0, 0.82, 0, 1.0)

		CfgBtn:SetHighlightTexture("Interface\\WorldMap\\Gear_64.png")
		CfgBtn:GetHighlightTexture():SetTexCoord(0, 0.50, 0, 0.50);

		CfgBtn.tiptext = L["Click to configure the settings for this option."]
		CfgBtn:SetScript("OnEnter", LeaPlusLC.ShowTooltip)
		CfgBtn:SetScript("OnLeave", GameTooltip_Hide)
	end

	-- Capitalise first character in a string
	function LeaPlusLC:CapFirst(str)
		return gsub(string.lower(str), "^%l", strupper)
	end

	-- Toggle Zygor addon
	function LeaPlusLC:ZygorToggle()
		if select(2, GetAddOnInfo("ZygorGuidesViewer")) then
			if not IsAddOnLoaded("ZygorGuidesViewer") then
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					EnableAddOn("ZygorGuidesViewer")
					ReloadUI();
				end
			else
				DisableAddOn("ZygorGuidesViewer")
				ReloadUI();
			end
		else
			-- Zygor cannot be found
			LeaPlusLC:Print("Zygor addon not found.");
		end
		return
	end

	-- Show memory usage stat
	function LeaPlusLC:ShowMemoryUsage(frame, anchor, x, y)

		-- Create frame
		local memframe = CreateFrame("FRAME", nil, frame)
		memframe:ClearAllPoints()
		memframe:SetPoint(anchor, x, y)
		memframe:SetWidth(100)
		memframe:SetHeight(20)

		-- Create labels
		local pretext = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		pretext:SetPoint("TOPLEFT", 0, 0)
		pretext:SetText(L["Memory Usage"])

		local memtext = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		memtext:SetPoint("TOPLEFT", 0, 0 - 30)

		-- Create stat
		local memstat = memframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		memstat:SetPoint("BOTTOMLEFT", memtext, "BOTTOMRIGHT")
		memstat:SetText("(calculating...)")

		-- Create update script
		local memtime = -1
		memframe:SetScript("OnUpdate", function(self, elapsed)
			if memtime > 2 or memtime == -1 then
				UpdateAddOnMemoryUsage();
				memtext = GetAddOnMemoryUsage("Leatrix_Plus")
				memtext = math.floor(memtext + .5) .. " KB"
				memstat:SetText(memtext);
				memtime = 0;
			end
			memtime = memtime + elapsed;
		end)

		-- Release memory
		LeaPlusLC.ShowMemoryUsage = nil

	end

	-- Check if player is in LFG queue
	function LeaPlusLC:IsInLFGQueue()
 		if 	GetLFGMode(LE_LFG_CATEGORY_LFD) or
			GetLFGMode(LE_LFG_CATEGORY_LFR) or
			GetLFGMode(LE_LFG_CATEGORY_RF) or
			GetLFGMode(LE_LFG_CATEGORY_SCENARIO) or
			GetLFGMode(LE_LFG_CATEGORY_FLEXRAID) then
			return true
		end
	end

	-- Check if player is in combat
	function LeaPlusLC:PlayerInCombat()
		if (UnitAffectingCombat("player")) then
			LeaPlusLC:Print("You cannot do that in combat.")
			return true
		end
	end

	--  Hide panel and pages
	function LeaPlusLC:HideFrames()

		-- Hide option pages
		for i = 0, LeaPlusLC["NumberOfPages"] do
			if LeaPlusLC["Page"..i] then
				LeaPlusLC["Page"..i]:Hide();
			end;
		end

		-- Hide options panel
		LeaPlusLC["PageF"]:Hide();

	end

	-- Find out if Leatrix Plus is showing (main panel or config panel)
	function LeaPlusLC:IsPlusShowing()
		if LeaPlusLC["PageF"]:IsShown() then return true end
		for k, v in pairs(LeaConfigList) do
			if v:IsShown() then
				return true
			end
		end
	end

	-- Check if a name is in your friends list or guild
	function LeaPlusLC:FriendCheck(name)

		-- Update friends list
		ShowFriends()

		-- Check character friends
		for i = 1, GetNumFriends() do
			-- Return true if name matches with or without realm
			if name == GetFriendInfo(i) or name == strsplit("-", GetFriendInfo(i), 2) then
				return true
			end
		end

		-- Get realm name or set to player's own realm (same realm does not return realm)
		local void, myRealm = UnitFullName(name)
		if not myRealm or myRealm == "" then void, myRealm = UnitFullName("player") end

		-- Add realm name to character name
		if not string.find(name, "-") then
			name = name .. "-" .. myRealm
		end

		-- Check Battle.net friends
		local numfriends = BNGetNumFriends()
		for i = 1, numfriends do
			local numtoons = BNGetNumFriendGameAccounts(i)
			for j = 1, numtoons do
				local void, toon, client, realm = BNGetFriendGameAccountInfo(i, j)
				local toonname = toon .. "-" ..realm
				if client == "WoW" and toonname == name then
					return true
				end
			end
		end

		-- Check guild roster (new members may need to press J to refresh roster)
		local gCount = GetNumGuildMembers()
		for i = 1, gCount do
			local gName, void, void, void, void, void, void, void, gOnline, void, void, void, void, gMobile = GetGuildRosterInfo(i)
			if gOnline and not gMobile then
				local gCompare = gName
				if not string.find(gName, "-") then
					gCompare = gName .. "-" .. myRealm
				end
				if gCompare == name then
					return true
				end
			end
		end

	end

	-- Convert color code (from RGB or RGB Percent to Hex or Hex Percent and vice versa)
	function LeaPlusLC:ConvertColor(r, g, b)
		if r and g and b then
			LeaPlusLC:Print("Source: |cffffffff" .. r .. " " .. g .. " " .. b .. " ")
			-- Source is RGB or RGB Percent
			local r = r <= 255 and r >= 0 and r or 0
			local g = g <= 255 and g >= 0 and g or 0
			local b = b <= 255 and b >= 0 and b or 0
			-- RGB Percent to Hex
			LeaPlusLC:Print("RGB Percent to Hex: |cffffffff" .. strupper(string.format("%02x%02x%02x", r * 255, g * 255, b * 255)))
			-- RGB to Hex
			LeaPlusLC:Print("RGB to Hex: |cffffffff" .. strupper(string.format("%02x%02x%02x", r, g, b)))
		else
			LeaPlusLC:Print("Source: |cffffffff" .. r)
			-- Source is Hex
			local rhex, ghex, bhex = string.sub(r, 1, 2), string.sub(r, 3, 4), string.sub(r, 5, 6)
			-- Hex to RGB Percent
			LeaPlusLC:Print("Hex to RGB Percent: |cffffffff" .. string.format("%.2f", tonumber(rhex, 16) / 255) ..  "  " .. string.format("%.2f", tonumber(ghex, 16) / 255) .. "  " .. string.format("%.2f", tonumber(bhex, 16) / 255))
			-- Hex to RGB
			LeaPlusLC:Print("Hex to RGB: |cffffffff" .. tonumber(rhex, 16) .. "  " .. tonumber(ghex, 16) .. "  " .. tonumber(bhex, 16))
		end
	end

----------------------------------------------------------------------
--	L02: Locks
----------------------------------------------------------------------

	-- Function to set lock state for configuration buttons
	function LeaPlusLC:LockOption(option, item, reloadreq)
		if reloadreq then
			-- Option change requires UI reload
			if LeaPlusLC[option] ~= LeaPlusDB[option] or LeaPlusLC[option] == "Off" then
				LeaPlusLC:LockItem(LeaPlusCB[item], true)
			else
				LeaPlusLC:LockItem(LeaPlusCB[item], false)
			end
		else
			-- Option change does not require UI reload
			if LeaPlusLC[option] == "Off" then
				LeaPlusLC:LockItem(LeaPlusCB[item], true)
			else
				LeaPlusLC:LockItem(LeaPlusCB[item], false)
			end
		end
	end

--	Set lock state for configuration buttons
	function LeaPlusLC:SetDim()
		LeaPlusLC:LockOption("NoShaders", "NoShadersBtn", true)					-- Manage effects
		LeaPlusLC:LockOption("AutomateGossip", "AutoGossipBtn", true)			-- Automate gossip
		LeaPlusLC:LockOption("AutoAcceptRes", "AutoResBtn", false)				-- Accept resurrection
		LeaPlusLC:LockOption("AutoReleasePvP", "AutoReleaseBtn", false)			-- Release in PvP
		LeaPlusLC:LockOption("AutoSellJunk", "SellJunkBtn", true)				-- Sell junk automatically
		LeaPlusLC:LockOption("AutoRepairOwnFunds", "RepairBtn", true)			-- Repair automatically
		LeaPlusLC:LockOption("InviteFromWhisper", "InvWhisperBtn", false)		-- Invite from whispers
		LeaPlusLC:LockOption("RecentChatWindow", "RecentChatBtn", true)			-- Recent chat window
		LeaPlusLC:LockOption("HideErrorFrameText", "HideErrorsBtn", true)		-- Hide error messages
		LeaPlusLC:LockOption("MailFontChange", "MailTextBtn", true)				-- Resize mail text
		LeaPlusLC:LockOption("QuestFontChange", "QuestTextBtn", true)			-- Resize quest text
		LeaPlusLC:LockOption("ShowMapMod", "EnhanceMapButton", true)			-- Enhance world map
		LeaPlusLC:LockOption("MinimapMod", "ModMinimapBtn", true)				-- Customise minimap
		LeaPlusLC:LockOption("TipModEnable", "MoveTooltipButton", true)			-- Manage tooltip
		LeaPlusLC:LockOption("EnhanceDressup", "ModDressupBtn", true)			-- Enhance dressup
		LeaPlusLC:LockOption("StaticCoordsEn", "ModStaticCoordsBtn", true)		-- Show coordinates
		LeaPlusLC:LockOption("ShowCooldowns", "CooldownsButton", true)			-- Show cooldowns
		LeaPlusLC:LockOption("FrmEnabled", "MoveFramesButton", true)			-- Manage frames
		LeaPlusLC:LockOption("ManageBuffFrame", "ManageBuffBtn", true)			-- Manage buff frame
		LeaPlusLC:LockOption("ClassColFrames", "ClassFramesBtn", true)			-- Class colored frames
		LeaPlusLC:LockOption("ShowPlayerChain", "ModPlayerChain", true)			-- Show player chain
		LeaPlusLC:LockOption("NoAlerts", "NoAlertsBtn", true)					-- Hide alerts
		LeaPlusLC:LockOption("ViewPortEnable", "ModViewportBtn", true)			-- Enable viewport
		LeaPlusLC:LockOption("EnableHotkey", "HotkeyBtn", true)					-- Enable hotkey
	end

----------------------------------------------------------------------
--	L03: Restarts
----------------------------------------------------------------------

	-- Set the reload button state
	function LeaPlusLC:ReloadCheck()

		-- Automation
		if	(LeaPlusLC["AutomateQuests"]		~= LeaPlusDB["AutomateQuests"])			-- Automate quests
		or	(LeaPlusLC["AutomateGossip"]		~= LeaPlusDB["AutomateGossip"])			-- Automate gossip
		or	(LeaPlusLC["AutoSellJunk"]			~= LeaPlusDB["AutoSellJunk"])			-- Sell junk automatically
		or	(LeaPlusLC["AutoRepairOwnFunds"]	~= LeaPlusDB["AutoRepairOwnFunds"])		-- Repair automatically

		-- Chat
		or	(LeaPlusLC["UseEasyChatResizing"]	~= LeaPlusDB["UseEasyChatResizing"])	-- Use easy resizing
		or	(LeaPlusLC["NoCombatLogTab"]		~= LeaPlusDB["NoCombatLogTab"])			-- Hide the combat log
		or	(LeaPlusLC["NoChatButtons"]			~= LeaPlusDB["NoChatButtons"])			-- Hide chat buttons
		or	(LeaPlusLC["NoSocialButton"]		~= LeaPlusDB["NoSocialButton"])			-- Hide social button
		or	(LeaPlusLC["UnclampChat"]			~= LeaPlusDB["UnclampChat"])			-- Unclamp chat frame
		or	(LeaPlusLC["MoveChatEditBoxToTop"]	~= LeaPlusDB["MoveChatEditBoxToTop"])	-- Move editbox to top
		or	(LeaPlusLC["NoStickyChat"]			~= LeaPlusDB["NoStickyChat"])			-- Disable sticky chat
		or	(LeaPlusLC["UseArrowKeysInChat"]	~= LeaPlusDB["UseArrowKeysInChat"])		-- Use arrow keys in chat
		or	(LeaPlusLC["NoChatFade"]			~= LeaPlusDB["NoChatFade"])				-- Disable chat fade
		or	(LeaPlusLC["UnivGroupColor"]		~= LeaPlusDB["UnivGroupColor"])			-- Universal group color
		or	(LeaPlusLC["Manageclasscolors"]		~= LeaPlusDB["Manageclasscolors"])		-- Use class colors in chat
		or	(LeaPlusLC["RecentChatWindow"]		~= LeaPlusDB["RecentChatWindow"])		-- Recent chat window
		or	(LeaPlusLC["MaxChatHstory"]			~= LeaPlusDB["MaxChatHstory"])			-- Increase chat history

		-- Text
		or	(LeaPlusLC["HideErrorFrameText"]	~= LeaPlusDB["HideErrorFrameText"])		-- Hide error text
		or	(LeaPlusLC["NoHitIndicators"]		~= LeaPlusDB["NoHitIndicators"])		-- Hide portrait text
		or	(LeaPlusLC["HideCraftedNames"]		~= LeaPlusDB["HideCraftedNames"])		-- Hide crafted names
		or	(LeaPlusLC["HideZoneText"]			~= LeaPlusDB["HideZoneText"])			-- Hide zone text
		or	(LeaPlusLC["HideSubzoneText"]		~= LeaPlusDB["HideSubzoneText"])		-- Hide subzone text
		or	(LeaPlusLC["MailFontChange"]		~= LeaPlusDB["MailFontChange"])			-- Resize mail text
		or	(LeaPlusLC["QuestFontChange"]		~= LeaPlusDB["QuestFontChange"])		-- Resize quest text

		-- Interface
		or	(LeaPlusLC["ShowMapMod"]			~= LeaPlusDB["ShowMapMod"])				-- Enhance world map
		or	(LeaPlusLC["MinimapMod"]			~= LeaPlusDB["MinimapMod"])				-- Customise minimap
		or	(LeaPlusLC["TipModEnable"]			~= LeaPlusDB["TipModEnable"])			-- Manage tooltip
		or	(LeaPlusLC["EnhanceDressup"]		~= LeaPlusDB["EnhanceDressup"])			-- Enhance dressup
		or	(LeaPlusLC["ShowVolume"]			~= LeaPlusDB["ShowVolume"])				-- Show volume slider
		or	(LeaPlusLC["AhExtras"]				~= LeaPlusDB["AhExtras"])				-- Show auction controls
		or	(LeaPlusLC["StaticCoordsEn"]		~= LeaPlusDB["StaticCoordsEn"])			-- Show coordinates
		or	(LeaPlusLC["ShowCooldowns"]			~= LeaPlusDB["ShowCooldowns"])			-- Show cooldowns
		or	(LeaPlusLC["DurabilityStatus"]		~= LeaPlusDB["DurabilityStatus"])		-- Show durability status
		or	(LeaPlusLC["ShowPetSaveBtn"]		~= LeaPlusDB["ShowPetSaveBtn"])			-- Show pet save button
		or	(LeaPlusLC["ShowWowheadLinks"]		~= LeaPlusDB["ShowWowheadLinks"])		-- Show Wowhead links

		-- Frames
		or	(LeaPlusLC["FrmEnabled"]			~= LeaPlusDB["FrmEnabled"])				-- Manage frames
		or	(LeaPlusLC["ManageBuffFrame"]		~= LeaPlusDB["ManageBuffFrame"])		-- Manage buff frame
		or	(LeaPlusLC["ClassColFrames"]		~= LeaPlusDB["ClassColFrames"])			-- Class colored frames
		or	(LeaPlusLC["ShowPlayerChain"]		~= LeaPlusDB["ShowPlayerChain"])		-- Show player chain
		or	(LeaPlusLC["ShowRaidToggle"]		~= LeaPlusDB["ShowRaidToggle"])			-- Show raid toggle button
		or	(LeaPlusLC["CombatPlates"]			~= LeaPlusDB["CombatPlates"])			-- Combat plates
		or	(LeaPlusLC["NoAlerts"]				~= LeaPlusDB["NoAlerts"])				-- Hide alerts
		or	(LeaPlusLC["HideBodyguard"]			~= LeaPlusDB["HideBodyguard"])			-- Hide bodyguard gossip
		or	(LeaPlusLC["HideTalkingFrame"]		~= LeaPlusDB["HideTalkingFrame"])		-- Hide talking frame
		or	(LeaPlusLC["HideCleanupBtns"]		~= LeaPlusDB["HideCleanupBtns"])		-- Hide clean-up buttons
		or	(LeaPlusLC["HideBossBanner"]		~= LeaPlusDB["HideBossBanner"])			-- Hide boss banner
		or	(LeaPlusLC["HideLevelUpDisplay"]	~= LeaPlusDB["HideLevelUpDisplay"])		-- Hide level-up display
		or	(LeaPlusLC["NoGryphons"]			~= LeaPlusDB["NoGryphons"])				-- Hide gryphons
		or	(LeaPlusLC["NoClassBar"]			~= LeaPlusDB["NoClassBar"])				-- Hide stance bar
		or	(LeaPlusLC["NoCommandBar"]			~= LeaPlusDB["NoCommandBar"])			-- Hide order hall bar

		-- System
		or	(LeaPlusLC["NoShaders"]				~= LeaPlusDB["NoShaders"])				-- Manage effects
		or	(LeaPlusLC["MaxCameraZoom"]			~= LeaPlusDB["MaxCameraZoom"])			-- Max camera zoom
		or	(LeaPlusLC["ViewPortEnable"]		~= LeaPlusDB["ViewPortEnable"])			-- Enable viewport
		or	(LeaPlusLC["NoRestedEmotes"]		~= LeaPlusDB["NoRestedEmotes"])			-- Silence rested emotes
		or	(LeaPlusLC["NoBagAutomation"]		~= LeaPlusDB["NoBagAutomation"])		-- Disable bag automation
		or	(LeaPlusLC["NoPetAutomation"]		~= LeaPlusDB["NoPetAutomation"])		-- Disable pet automation
		or	(LeaPlusLC["CharAddonList"]			~= LeaPlusDB["CharAddonList"])			-- Show character addons
		or	(LeaPlusLC["NoRaidRestrictions"]	~= LeaPlusDB["NoRaidRestrictions"])		-- Remove raid restrictions
		or	(LeaPlusLC["NoMapEmote"]			~= LeaPlusDB["NoMapEmote"])				-- Disable map emote
		or	(LeaPlusLC["SkipCinematics"]		~= LeaPlusDB["SkipCinematics"])			-- Skip cinematics
		or	(LeaPlusLC["FasterLooting"]			~= LeaPlusDB["FasterLooting"])			-- Faster auto loot
		or	(LeaPlusLC["LockoutSharing"]		~= LeaPlusDB["LockoutSharing"])			-- Lockout sharing

		-- Settings
		or	(LeaPlusLC["ShowMinimapIcon"]		~= LeaPlusDB["ShowMinimapIcon"])		-- Show minimap button
		or	(LeaPlusLC["EnableHotkey"]			~= LeaPlusDB["EnableHotkey"])			-- Enable hotkey

		then
			-- Enable the reload button
			LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"], false)
			LeaPlusCB["ReloadUIButton"].f:Show()
		else
			-- Disable the reload button
			LeaPlusLC:LockItem(LeaPlusCB["ReloadUIButton"], true)
			LeaPlusCB["ReloadUIButton"].f:Hide()
		end

	end

----------------------------------------------------------------------
--	L20: Live
----------------------------------------------------------------------

	function LeaPlusLC:Live()

		----------------------------------------------------------------------
		--	Automatically accept Dungeon Finder queue requests
		----------------------------------------------------------------------

		if LeaPlusLC["AutoConfirmRole"] == "On" then
			LFDRoleCheckPopupAcceptButton:SetScript("OnShow", function()
				local leader = ""
				for i=1, GetNumSubgroupMembers() do 
					if (UnitIsGroupLeader("party"..i)) then 
						leader = UnitName("party"..i);
						break;
					end
				end
				if (LeaPlusLC:FriendCheck(leader)) then
					LFDRoleCheckPopupAcceptButton:Click();
				end
			end)
		else
			LFDRoleCheckPopupAcceptButton:SetScript("OnShow", nil)
		end

		----------------------------------------------------------------------
		--	Invite from whispers
		----------------------------------------------------------------------

		if LeaPlusLC["InviteFromWhisper"] == "On" then
			LpEvt:RegisterEvent("CHAT_MSG_WHISPER");
			LpEvt:RegisterEvent("CHAT_MSG_BN_WHISPER");
		else
			LpEvt:UnregisterEvent("CHAT_MSG_WHISPER");
			LpEvt:UnregisterEvent("CHAT_MSG_BN_WHISPER");
		end

		----------------------------------------------------------------------
		--	Block duels
		----------------------------------------------------------------------

		if LeaPlusLC["NoDuelRequests"] == "On" then
			LpEvt:RegisterEvent("DUEL_REQUESTED");
		else
			LpEvt:UnregisterEvent("DUEL_REQUESTED");
		end

		----------------------------------------------------------------------
		--	Block pet battle duels
		----------------------------------------------------------------------

		if LeaPlusLC["NoPetDuels"] == "On" then
			LpEvt:RegisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED");
		else
			LpEvt:UnregisterEvent("PET_BATTLE_PVP_DUEL_REQUESTED");
		end

		----------------------------------------------------------------------
		--	Block party invites and Party from friends
		----------------------------------------------------------------------

		if LeaPlusLC["NoPartyInvites"] == "On" or LeaPlusLC["AcceptPartyFriends"] == "On" then
			LpEvt:RegisterEvent("PARTY_INVITE_REQUEST");
		else
			LpEvt:UnregisterEvent("PARTY_INVITE_REQUEST");
		end

		----------------------------------------------------------------------
		--	Release in PvP
		----------------------------------------------------------------------

		if LeaPlusLC["AutoReleasePvP"] == "On" then
			LpEvt:RegisterEvent("PLAYER_DEAD");
		else
			LpEvt:UnregisterEvent("PLAYER_DEAD");
		end

		----------------------------------------------------------------------
		--	Accept resurrection
		----------------------------------------------------------------------

		if LeaPlusLC["AutoAcceptRes"] == "On" then
			LpEvt:RegisterEvent("RESURRECT_REQUEST");
		else
			LpEvt:UnregisterEvent("RESURRECT_REQUEST");
		end

		----------------------------------------------------------------------
		--	Automatic summon
		----------------------------------------------------------------------

		if LeaPlusLC["AutoAcceptSummon"] == "On" then
			LpEvt:RegisterEvent("CONFIRM_SUMMON");
		else
			LpEvt:UnregisterEvent("CONFIRM_SUMMON");
		end

		----------------------------------------------------------------------
		--	Disable loot warnings
		----------------------------------------------------------------------

		if LeaPlusLC["NoConfirmLoot"] == "On" then
			LpEvt:RegisterEvent("CONFIRM_LOOT_ROLL")
			LpEvt:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
			LpEvt:RegisterEvent("LOOT_BIND_CONFIRM")
			LpEvt:RegisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
			LpEvt:RegisterEvent("MAIL_LOCK_SEND_ITEMS")
		else
			LpEvt:UnregisterEvent("CONFIRM_LOOT_ROLL")
			LpEvt:UnregisterEvent("CONFIRM_DISENCHANT_ROLL")
			LpEvt:UnregisterEvent("LOOT_BIND_CONFIRM")
			LpEvt:UnregisterEvent("MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL")
			LpEvt:UnregisterEvent("MAIL_LOCK_SEND_ITEMS")
		end

	end

----------------------------------------------------------------------
--	L30: Isolated
----------------------------------------------------------------------

	function LeaPlusLC:Isolated()

		----------------------------------------------------------------------
		-- Wowhead Links
		----------------------------------------------------------------------

		if LeaPlusLC["ShowWowheadLinks"] == "On" then

			-- Get localised Wowhead URL
			local wowheadLoc
			if GameLocale == "deDE" then wowheadLoc = "de.wowhead.com"
			elseif GameLocale == "esMX" then wowheadLoc = "es.wowhead.com"
			elseif GameLocale == "esES" then wowheadLoc = "es.wowhead.com"
			elseif GameLocale == "frFR" then wowheadLoc = "fr.wowhead.com"
			elseif GameLocale == "itIT" then wowheadLoc = "it.wowhead.com"
			elseif GameLocale == "ptBR" then wowheadLoc = "pt.wowhead.com"
			elseif GameLocale == "ruRU" then wowheadLoc = "ru.wowhead.com"
			elseif GameLocale == "koKR" then wowheadLoc = "ko.wowhead.com"
			elseif GameLocale == "zhCN" then wowheadLoc = "cn.wowhead.com"
			elseif GameLocale == "zhTW" then wowheadLoc = "cn.wowhead.com"
			else							 wowheadLoc = "wowhead.com"
			end

			----------------------------------------------------------------------
			-- Achievements frame
			----------------------------------------------------------------------

			-- Achievement link function
			local function DoWowheadAchievementFunc()

				-- Create editbox
				local aEB = CreateFrame("EditBox", nil, AchievementFrame)
				aEB:ClearAllPoints()
				aEB:SetPoint("BOTTOMRIGHT", -50, 1)
				aEB:SetHeight(16)
				aEB:SetFontObject("GameFontNormalSmall")
				aEB:SetBlinkSpeed(0)
				aEB:SetJustifyH("RIGHT")
				aEB:SetAutoFocus(false)
				aEB:EnableKeyboard(false)
				aEB:SetHitRectInsets(90, 0, 0, 0)
				aEB:SetScript("OnKeyDown", function() end)
				aEB:SetScript("OnMouseUp", function()
					if aEB:IsMouseOver() then 
						aEB:HighlightText()
					else
						aEB:HighlightText(0, 0)
					end
				end)

				-- Create hidden font string (used for setting width of editbox)
				aEB.z = aEB:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
				aEB.z:Hide()

				-- Store last link in case editbox is cleared
				local lastAchievementLink

				-- Function to set editbox value
				hooksecurefunc("AchievementFrameAchievements_SelectButton", function(self)
					local achievementID = self.id or nil
					if achievementID then
						-- Set editbox text
						aEB:SetText("https://" .. wowheadLoc .. "/achievement=" .. achievementID)
						lastAchievementLink = aEB:GetText()
						-- Set hidden fontstring then resize editbox to match
						aEB.z:SetText(aEB:GetText())
						aEB:SetWidth(aEB.z:GetStringWidth() + 90)
						-- Get achievement title for tooltip
						local achievementLink = GetAchievementLink(self.id)
						if achievementLink then
							aEB.tiptext = achievementLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
						end
						-- Show the editbox
						aEB:Show()
					end
				end)

				-- Create tooltip
				aEB:HookScript("OnEnter", function()
					aEB:HighlightText()
					aEB:SetFocus()
					GameTooltip:SetOwner(aEB, "ANCHOR_TOP", 0, 10)
					GameTooltip:SetText(aEB.tiptext, nil, nil, nil, nil, true)
					GameTooltip:Show()
				end)

				aEB:HookScript("OnLeave", function()
					-- Set link text again if it's changed since it was set
					if aEB:GetText() ~= lastAchievementLink then aEB:SetText(lastAchievementLink) end
					aEB:HighlightText(0, 0)
					aEB:ClearFocus()
					GameTooltip:Hide()
				end)

				-- Hide editbox when achievement is deselected
				hooksecurefunc("AchievementFrameAchievements_ClearSelection", function(self) aEB:Hide()	end)
				hooksecurefunc("AchievementCategoryButton_OnClick", function(self) aEB:Hide() end)

			end

			-- Run function when achievement UI is loaded
			if IsAddOnLoaded("Blizzard_AchievementUI") then
				DoWowheadAchievementFunc()
			else
				local waitAchievementsFrame = CreateFrame("FRAME")
				waitAchievementsFrame:RegisterEvent("ADDON_LOADED")
				waitAchievementsFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_AchievementUI" then
						DoWowheadAchievementFunc()
						waitAchievementsFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Encounter Journal frame
			----------------------------------------------------------------------

			local function DoEJFunc()

				-- Hide the title bar
				EncounterJournalTitleText:Hide()

				-- Create editbox
				local eEB = CreateFrame("EditBox", nil, EncounterJournal)
				eEB:ClearAllPoints()
				eEB:SetPoint("TOPLEFT", 70, -4)
				eEB:SetHeight(16)
				eEB:SetFontObject("GameFontNormal")
				eEB:SetBlinkSpeed(0)
				eEB:SetAutoFocus(false)
				eEB:EnableKeyboard(false)
				eEB:SetHitRectInsets(0, 90, 0, 0)
				eEB:SetScript("OnKeyDown", function() end)
				eEB:SetScript("OnMouseUp", function()
					if eEB:IsMouseOver() then 
						eEB:HighlightText()
					else
						eEB:HighlightText(0, 0)
					end
				end)

				-- Create hidden font string (used for setting width of editbox)
				eEB.z = eEB:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				eEB.z:Hide()

				-- Store last link in case user clears editbox
				local lastEJLink

				-- Function to set editbox value
				hooksecurefunc("EncounterJournal_DisplayInstance", function()
					local void, void, void, void, void, void, dungeonAreaMapID, link = EJ_GetInstanceInfo()
					local mapID, areaID = GetAreaMapInfo(dungeonAreaMapID)       
					if areaID then
						-- Set editbox text
						eEB:SetText("https://" .. wowheadLoc .. "/zone=" .. areaID)
						lastEJLink = eEB:GetText()
						-- Set hidden fontstring then resize editbox to match
						eEB.z:SetText(eEB:GetText())
						eEB:SetWidth(eEB.z:GetStringWidth() + 90)
						-- Get achievement title for tooltip
						if link then
							eEB.tiptext = link:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
						end
						-- Show the editbox
						eEB:Show()
					end
				end)

				-- Create tooltip
				eEB:HookScript("OnEnter", function()
					eEB:HighlightText()
					eEB:SetFocus()
					GameTooltip:SetOwner(eEB, "ANCHOR_BOTTOM", 0, -10)
					GameTooltip:SetText(eEB.tiptext, nil, nil, nil, nil, true)
					GameTooltip:Show()
				end)

				eEB:HookScript("OnLeave", function()
					-- Set link text again if it's changed since it was set
					if eEB:GetText() ~= lastEJLink then eEB:SetText(lastEJLink) end
					eEB:HighlightText(0, 0)
					eEB:ClearFocus()
					GameTooltip:Hide()
				end)

				-- Hide editbox when instance list is shown
				hooksecurefunc("EncounterJournal_ListInstances", function()
					eEB:Hide()
				end)

			end

			-- Run function when encounter journal is loaded
			if IsAddOnLoaded("Blizzard_EncounterJournal") then
				DoEJFunc()
			else
				local waitJournalFrame = CreateFrame("FRAME")
				waitJournalFrame:RegisterEvent("ADDON_LOADED")
				waitJournalFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_EncounterJournal" then
						DoEJFunc()
						waitJournalFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- World map frame
			----------------------------------------------------------------------

			-- Hide the title text
			WorldMapFrameTitleText:Hide()

			-- Create editbox
			local mEB = CreateFrame("EditBox", nil, WorldMapFrame.BorderFrame)
			mEB:ClearAllPoints()
			mEB:SetPoint("TOPLEFT", 100, -4)
			mEB:SetHeight(16)
			mEB:SetFontObject("GameFontNormal")
			mEB:SetBlinkSpeed(0)
			mEB:SetAutoFocus(false)
			mEB:EnableKeyboard(false)
			mEB:SetHitRectInsets(0, 90, 0, 0)
			mEB:SetScript("OnKeyDown", function() end)
			mEB:SetScript("OnMouseUp", function()
				if mEB:IsMouseOver() then 
					mEB:HighlightText()
				else
					mEB:HighlightText(0, 0)
				end
			end)

			-- Create hidden font string (used for setting width of editbox)
			mEB.z = mEB:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
			mEB.z:Hide()

			-- Function to set editbox value
			local function SetQuestInBox()
				local questID
				if QuestMapFrame.DetailsFrame:IsShown() then
					-- Get quest ID from currently showing quest in details panel
					questID = QuestMapFrame_GetDetailQuestID()
				else
					-- Get quest ID from currently selected quest on world map
					questID = GetSuperTrackedQuestID()
				end
				if questID then
					-- Hide editbox if quest ID is invalid
					if questID == 0 then mEB:Hide() else mEB:Show() end
					-- Set editbox text
					mEB:SetText("https://" .. wowheadLoc .. "/quest=" .. questID)
					-- Set hidden fontstring then resize editbox to match
					mEB.z:SetText(mEB:GetText())
					mEB:SetWidth(mEB.z:GetStringWidth() + 90)
					-- Get quest title for tooltip
					local questLink = GetQuestLink(questID) or nil
					if questLink then
						mEB.tiptext = questLink:match("%[(.-)%]") .. "|n" .. L["Press CTRL/C to copy."]
					else
						mEB.tiptext = ""
						if mEB:IsMouseOver() and WorldMapTooltip:IsShown() then WorldMapTooltip:Hide() end
					end
				end
			end

			-- Set URL when super tracked quest changes and on startup
			mEB:RegisterEvent("SUPER_TRACKED_QUEST_CHANGED")
			mEB:SetScript("OnEvent", SetQuestInBox)
			SetQuestInBox()

			-- Set URL when quest details frame is shown or hidden
			hooksecurefunc("QuestMapFrame_ShowQuestDetails", SetQuestInBox)
			hooksecurefunc("QuestMapFrame_CloseQuestDetails", SetQuestInBox)

			-- Create tooltip
			mEB:HookScript("OnEnter", function()
				mEB:HighlightText()
				mEB:SetFocus()
				WorldMapTooltip:SetOwner(mEB, "ANCHOR_BOTTOM", 0, -10)
				WorldMapTooltip:SetText(mEB.tiptext, nil, nil, nil, nil, true)
				WorldMapTooltip:Show()
			end)

			mEB:HookScript("OnLeave", function()
				mEB:HighlightText(0, 0)
				mEB:ClearFocus()
				WorldMapTooltip:Hide()
				SetQuestInBox()
			end)

		end

		----------------------------------------------------------------------
		-- Enhance dressup
		----------------------------------------------------------------------

		if LeaPlusLC["EnhanceDressup"] == "On" then

			local animLevel = 255 -- Set to 15 for test (frozen animation), 255 for live (idle animation)

			-- Create configuration panel
			local mPanel = LeaPlusLC:CreatePanel("Enhance Dressup", "mPanel")

			LeaPlusLC:MakeTx(mPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(mPanel, "ShowModelButtons", "Show nude and tabard buttons", 16, -92, false, "If checked, tabard and nude buttons will be shown in the dressing room and auction house dressing room.")
			LeaPlusLC:MakeCB(mPanel, "NoSpecialModelAnims", "Prevent special model animations", 16, -112, false, "If checked, character models shown in the dressing room, auction house dressing room and transmogrify frame will not perform special animations.")
			LeaPlusLC:MakeCB(mPanel, "HideModelControls", "Hide model positioning controls", 16, -132, false, "If checked, character positioning controls will not be shown in any dressup frame.")

			-- Help button hidden
			mPanel.h:Hide()

			-- Back button handler
			mPanel.b:SetScript("OnClick", function() 
				mPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show()
				return
			end)

			-- Reset button handler
			mPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["ShowModelButtons"] = "On"
				LeaPlusLC["NoSpecialModelAnims"] = "On"
				LeaPlusLC["HideModelControls"] = "On"

				-- Refresh side panel
				mPanel:Hide(); mPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["ModDressupBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["ShowModelButtons"] = "On"
					LeaPlusLC["NoSpecialModelAnims"] = "On"
					LeaPlusLC["HideModelControls"] = "On"
				else
					mPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			----------------------------------------------------------------------
			-- Buttons
			----------------------------------------------------------------------

			-- Add buttons to main dressup frames
			LeaPlusLC:CreateButton("DressUpNudeBtn", DressUpFrame, "Nude", "BOTTOMLEFT", 106, 79, 80, 22, false, "")
			LeaPlusCB["DressUpNudeBtn"]:ClearAllPoints()
			LeaPlusCB["DressUpNudeBtn"]:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", 0, 0)
			LeaPlusCB["DressUpNudeBtn"]:SetScript("OnClick", function()
				DressUpFrameResetButton:Click() -- Done first in case any slots refuse to clear
				for i = 1, 19 do
					DressUpModel:UndressSlot(i) -- Done this way to prevent issues with Undress
				end
			end)

			LeaPlusLC:CreateButton("DressUpTabBtn", DressUpFrame, "Tabard", "BOTTOMLEFT", 26, 79, 80, 22, false, "")
			LeaPlusCB["DressUpTabBtn"]:ClearAllPoints()
			LeaPlusCB["DressUpTabBtn"]:SetPoint("RIGHT", LeaPlusCB["DressUpNudeBtn"], "LEFT", 0, 0)
			LeaPlusCB["DressUpTabBtn"]:SetScript("OnClick", function()
				DressUpModel:UndressSlot(19)
			end)

			local BtnStrata, BtnLevel = SideDressUpModelResetButton:GetFrameStrata(), SideDressUpModelResetButton:GetFrameLevel()

			-- Add buttons to auction house dressup frame
			LeaPlusLC:CreateButton("DressUpSideBtn", SideDressUpFrame, "Tabard", "BOTTOMLEFT", 14, 20, 60, 22, false, "")
			LeaPlusCB["DressUpSideBtn"]:SetFrameStrata(BtnStrata);
			LeaPlusCB["DressUpSideBtn"]:SetFrameLevel(BtnLevel);
			LeaPlusCB["DressUpSideBtn"]:SetScript("OnClick", function()
				SideDressUpModel:UndressSlot(19)
			end)

			LeaPlusLC:CreateButton("DressUpSideNudeBtn", SideDressUpFrame, "Nude", "BOTTOMRIGHT", -18, 20, 60, 22, false, "")
			LeaPlusCB["DressUpSideNudeBtn"]:SetFrameStrata(BtnStrata);
			LeaPlusCB["DressUpSideNudeBtn"]:SetFrameLevel(BtnLevel);
			LeaPlusCB["DressUpSideNudeBtn"]:SetScript("OnClick", function()
				SideDressUpModelResetButton:Click() -- Done first in case any slots refuse to clear
				for i = 1, 19 do
					SideDressUpModel:UndressSlot(i) -- Done this way to prevent issues with Undress
				end
			end)

			-- Function to toggle buttons
			local function SetupButtons()
				if LeaPlusLC["ShowModelButtons"] == "On" then
					-- Show nude and tabard buttons
					LeaPlusCB["DressUpNudeBtn"]:Show()
					LeaPlusCB["DressUpTabBtn"]:Show()
					LeaPlusCB["DressUpSideBtn"]:Show()
					LeaPlusCB["DressUpSideNudeBtn"]:Show()
				else
					-- Hide nude and tabard buttons
					LeaPlusCB["DressUpNudeBtn"]:Hide()
					LeaPlusCB["DressUpTabBtn"]:Hide()
					LeaPlusCB["DressUpSideBtn"]:Hide()
					LeaPlusCB["DressUpSideNudeBtn"]:Hide()
				end
			end

			-- Run function when option is clicked, reset button is clicked, preset is clicked and on startup
			LeaPlusCB["ShowModelButtons"]:HookScript("OnClick", SetupButtons)
			mPanel.r:HookScript("OnClick", SetupButtons)
			LeaPlusCB["ModDressupBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					SetupButtons()
				end
			end)
			SetupButtons()

			----------------------------------------------------------------------
			-- Animations
			----------------------------------------------------------------------

			-- Function to set animations
			local function SetupAnimations(reset)
				if LeaPlusLC["NoSpecialModelAnims"] == "On" then
					-- Set idle animations
					DressUpModel:SetAnimation(animLevel)
					SideDressUpModel:SetAnimation(animLevel)
				else
					-- Set default animations only if panel controls were clicked
					if reset then
						DressUpModel:SetAnimation(0)
						SideDressUpModel:SetAnimation(0)
					end
				end
			end

			-- Dressing room
			hooksecurefunc("DressUpFrame_Show", SetupAnimations)
			DressUpFrame.ResetButton:HookScript("OnClick", SetupAnimations)
			-- Auction house dressing room
			hooksecurefunc(SideDressUpModel, "SetUnit", SetupAnimations)
			SideDressUpModelResetButton:HookScript("OnClick", SetupAnimations)
			-- Panel clicks
			LeaPlusCB["NoSpecialModelAnims"]:HookScript("OnClick", function() SetupAnimations(true) end)
			mPanel.r:HookScript("OnClick", function() SetupAnimations(true) end)
			LeaPlusCB["ModDressupBtn"]:HookScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					SetupAnimations(true)
				end
			end)

			----------------------------------------------------------------------
			-- Controls
			----------------------------------------------------------------------

			-- Function to hide controls
			local function SetupControls()
				if LeaPlusLC["HideModelControls"] == "On" then
					CharacterModelFrameControlFrame:Hide()
					DressUpModelControlFrame:Hide()
					SideDressUpModelControlFrame:Hide()
				end
			end

			-- Hide controls for character sheet, dressing room and auction house dressing room
			CharacterModelFrameControlFrame:HookScript("OnShow", SetupControls)
			DressUpModelControlFrame:HookScript("OnShow", SetupControls)
			SideDressUpModelControlFrame:HookScript("OnShow", SetupControls)

			----------------------------------------------------------------------
			-- Addons
			----------------------------------------------------------------------

			-- Collections
			local function SetTransmogAnims(reset)
				if LeaPlusLC["NoSpecialModelAnims"] == "On" then
					-- Set idle animations
					WardrobeTransmogFrame.Model:SetAnimation(animLevel)
				else
					-- Set default animations only if panel controls were clicked
					if reset then
						WardrobeTransmogFrame.Model:SetAnimation(0)
					end
				end
			end

			local function DoBlizzardCollectionsFunc()
				-- Wardrobe controls
				WardrobeTransmogFrameControlFrame:HookScript("OnShow", function()
					if LeaPlusLC["HideModelControls"] == "On" then
						WardrobeTransmogFrameControlFrame:Hide()
					end
				end)
				-- Wardrobe animations
				hooksecurefunc(WardrobeTransmogFrame.Model, "SetUnit", SetTransmogAnims)
				-- Leatrix Plus control clicks
				LeaPlusCB["NoSpecialModelAnims"]:HookScript("OnClick", function() SetTransmogAnims(true) end)
				mPanel.r:HookScript("OnClick", function() SetTransmogAnims(true) end)
				LeaPlusCB["ModDressupBtn"]:HookScript("OnClick", function()
					if IsShiftKeyDown() and IsControlKeyDown() then
						SetTransmogAnims(true)
					end
				end)
			end

			if IsAddOnLoaded("Blizzard_Collections") then
				DoBlizzardCollectionsFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Collections" then
						DoBlizzardCollectionsFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			-- Inspect System
			local function DoInspectSystemFunc()
				-- Inspect controls
				InspectModelFrameControlFrame:HookScript("OnShow", function()
					if LeaPlusLC["HideModelControls"] == "On" then
						InspectModelFrameControlFrame:Hide()
					end
				end)
			end

			if IsAddOnLoaded("Blizzard_InspectUI") then
				DoInspectSystemFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_InspectUI" then
						DoInspectSystemFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		-- Automate gossip
		----------------------------------------------------------------------

		if LeaPlusLC["AutomateGossip"] == "On" then

			-- Create configuration panel
			local GossipPanel = LeaPlusLC:CreatePanel("Automate Gossip", "GossipPanel")

			-- Add dropdown menu
			LeaPlusLC:CreateDropDown("AutoGossipMenu", "Modifier key", GossipPanel, 146, "TOPLEFT", 16, -112, {"ALT", "CTRL", L["NONE"]}, "")

			-- Help button tooltip
			GossipPanel.h.tiptext = L["If set to NONE, you can hold the shift key down to temporarily prevent automation."]

			-- Back button handler
			GossipPanel.b:SetScript("OnClick", function() 
				LeaPlusCB["ListFrameAutoGossipMenu"]:Hide(); -- Hide the dropdown list
				GossipPanel:Hide();
				LeaPlusLC["PageF"]:Show()
				LeaPlusLC["Page1"]:Show()
				return
			end) 

			-- Reset button handler
			GossipPanel.r:SetScript("OnClick", function()
				LeaPlusCB["ListFrameAutoGossipMenu"]:Hide(); -- Hide the dropdown list
				LeaPlusLC["AutoGossipMenu"] = 1
				GossipPanel:Hide(); GossipPanel:Show()
			end)

			-- Show the panel when the configuration button is clicked
			LeaPlusCB["AutoGossipBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					LeaPlusLC["AutoGossipMenu"] = 1
				else
					LeaPlusLC:HideFrames();
					GossipPanel:Show();
				end
			end)

			local function SkipGossip()
				if LeaPlusLC["AutoGossipMenu"] == 1 and not IsAltKeyDown() then return end
				if LeaPlusLC["AutoGossipMenu"] == 2 and not IsControlKeyDown() then return end
				if LeaPlusLC["AutoGossipMenu"] == 3 and IsShiftKeyDown() then return end
				local void, gossipType = GetGossipOptions()
				if gossipType and gossipType == "gossip" then
					SelectGossipOption(1)
				end
			end

			-- Create gossip watch frame and process gossip events
			local gossipFrame = CreateFrame("FRAME")
			gossipFrame:RegisterEvent("GOSSIP_SHOW")
			gossipFrame:SetScript("OnEvent", function()
				-- Special treatment for specific NPCs
				local npcGuid = UnitGUID("target") or nil
				if npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						-- Open rogue doors in Dalaran (Broken Isles) automatically
						if npcID == "96782"	-- Lucian Trias
						or npcID == "93188"	-- Mongar
						or npcID == "97004"	-- "Red" Jack Findle
						then
							SkipGossip()
							return
						end
					end
				end
				-- Process gossip
				if GetNumGossipOptions() == 1 and GetNumGossipAvailableQuests() == 0 and GetNumGossipActiveQuests() == 0 then
					SkipGossip()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Hide order hall bar
		----------------------------------------------------------------------

		if LeaPlusLC["NoCommandBar"] == "On" then

			-- Function to hide the order hall bar
			local function HideCommandBar()
				OrderHallCommandBar:HookScript("OnShow", function()
					OrderHallCommandBar:Hide()
				end)
			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_OrderHallUI") then
				HideCommandBar()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_OrderHallUI" then
						HideCommandBar()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		--	Disable pet automation
		----------------------------------------------------------------------

		if LeaPlusLC["NoPetAutomation"] == "On" then

			-- Create frame to watch for combat
			local petCombat = CreateFrame("FRAME")
			local petTicker

			-- Function to dismiss pet
			local function DismissPetTimerFunc()
				if UnitAffectingCombat("player") then
					-- Player is in combat so cancel ticker and schedule it for when combat ends
					if petTicker then petTicker:Cancel() end
					petCombat:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					-- Player is not in combat so attempt to dismiss pet
					local summonedPet = C_PetJournal.GetSummonedPetGUID()
					if summonedPet then
						C_PetJournal.SummonPetByGUID(summonedPet)
					end
				end
			end

			hooksecurefunc(C_PetJournal, "SetPetLoadOutInfo", function()
				-- Cancel existing ticker if one already exists
				if petTicker then petTicker:Cancel() end
				-- Check for combat
				if UnitAffectingCombat("player") then
					-- Player is in combat so schedule ticker for when combat ends
					petCombat:RegisterEvent("PLAYER_REGEN_ENABLED")
				else
					-- Player is not in combat so run ticker now
					petTicker = C_Timer.NewTicker(0.5, DismissPetTimerFunc, 15)
				end
			end)

			-- Script for when combat ends
			petCombat:SetScript("OnEvent", function()
				-- Combat has ended so run ticker now
				petTicker = C_Timer.NewTicker(0.5, DismissPetTimerFunc, 15)
				petCombat:UnregisterEvent("PLAYER_REGEN_ENABLED")
			end)

		end

		----------------------------------------------------------------------
		--	Show pet save button
		----------------------------------------------------------------------

		if LeaPlusLC["ShowPetSaveBtn"] == "On" then

			local function MakePetSystem()

				-- Create panel
				local pFrame = CreateFrame("Frame", nil, PetJournal)
				pFrame:ClearAllPoints()
				pFrame:SetPoint("TOPLEFT", PetJournalLoadoutBorder, "TOPLEFT", 4, 40)
				pFrame:SetSize(PetJournalLoadoutBorder:GetWidth() -10, 16)
				pFrame:Hide()
				pFrame:SetFrameLevel(5000)

				-- Add background color
				pFrame.t = pFrame:CreateTexture(nil, "BACKGROUND")
				pFrame.t:SetAllPoints()
				pFrame.t:SetColorTexture(0.05, 0.05, 0.05, 0.7)

				-- Create editbox
				local petEB = CreateFrame("EditBox", nil, pFrame)
				petEB:SetAllPoints()
				petEB:SetTextInsets(2, 2, 2, 2)
				petEB:SetFontObject("GameFontNormal")
				petEB:SetTextColor(1.0, 1.0, 1.0, 1)
				petEB:SetBlinkSpeed(0)
				petEB:SetAltArrowKeyMode(true)

				-- Prevent changes
				petEB:SetScript("OnEscapePressed", function() pFrame:Hide() end)
				petEB:SetScript("OnEnterPressed", petEB.HighlightText)
				petEB:SetScript("OnMouseDown", petEB.ClearFocus)
				petEB:SetScript("OnMouseUp", petEB.HighlightText)

				-- Create tooltip
				petEB.tiptext = L["This command will assign your current pet team and selected abilities.|n|nPress CTRL/C to copy the command then paste it into a macro or chat window with CTRL/V."]
				petEB:HookScript("OnEnter", function()
					GameTooltip:SetOwner(petEB, "ANCHOR_TOP")
					GameTooltip:SetText(petEB.tiptext, nil, nil, nil, nil, true)
				end)
				petEB:HookScript("OnLeave", GameTooltip_Hide)

				-- Function to get pet data and build macro
				local function RefreshPets()
					-- Get pet data
					local p1, p1a, p1b, p1c = C_PetJournal.GetPetLoadOutInfo(1)
					local p2, p2a, p2b, p2c = C_PetJournal.GetPetLoadOutInfo(2)
					local p3, p3a, p3b, p3c = C_PetJournal.GetPetLoadOutInfo(3)
					if p1 and p1a and p1b and p1c and p2 and p2a and p2b and p2c and p3 and p3a and p3b and p3c then
						-- Build macro string and show it in editbox
						local comTeam = "/ltp team "
						comTeam = comTeam .. p1 .. ',' .. p1a .. ',' .. p1b .. ',' .. p1c .. ","
						comTeam = comTeam .. p2 .. ',' .. p2a .. ',' .. p2b .. ',' .. p2c .. ","
						comTeam = comTeam .. p3 .. ',' .. p3a .. ',' .. p3b .. ',' .. p3c
						petEB:SetText(comTeam)
						petEB:HighlightText()
						petEB:SetFocus()
					end
				end

				-- Prevent changes to editbox value
				petEB:SetScript("OnChar", RefreshPets)
				petEB:SetScript("OnKeyUp", RefreshPets)

				-- Refresh pet data when slots are changed
				hooksecurefunc(C_PetJournal, "SetPetLoadOutInfo", RefreshPets)

				-- Add macro button
				local macroBtn = LeaPlusLC:CreateButton("PetMacroBtn", _G["PetJournalLoadoutPet1"], "", "TOPRIGHT", 0, 0, 32, 32, false, "")
				macroBtn:SetFrameLevel(5000)
				macroBtn:SetNormalTexture("Interface\\BUTTONS\\AdventureGuideMicrobuttonAlert")
				macroBtn:SetScript("OnClick", function()
					if C_PetJournal.GetPetLoadOutInfo(1) and C_PetJournal.GetPetLoadOutInfo(2) and C_PetJournal.GetPetLoadOutInfo(3) then
						if pFrame:IsShown() then
							-- Frame is already showing so hide it
							pFrame:Hide() 
						else
							-- Show macro panel
							pFrame:Show()
							RefreshPets()
						end
					else
						LeaPlusLC:Print("You need a battle pet team.")
					end
				end)
				macroBtn:HookScript("OnHide", function() pFrame:Hide() end)

			end

			-- Run system function when pet journal loads
			if IsAddOnLoaded("Blizzard_Collections") then
				MakePetSystem()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Collections" then
						MakePetSystem()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		--	Hide crafted names
		----------------------------------------------------------------------

		if LeaPlusLC["HideCraftedNames"] == "On" then
			_G.ITEM_CREATED_BY = ""
		end

		----------------------------------------------------------------------
		--	Enable hotkey
		----------------------------------------------------------------------

		if LeaPlusLC["EnableHotkey"] == "On" then

			-- Create configuration panel
			local HotkeyPanel = LeaPlusLC:CreatePanel("Hotkey", "HotkeyPanel")

			-- Add dropdown menu (item names must match binding parameter names)
			LeaPlusLC:CreateDropDown("HotkeyMenu", "Leatrix Plus", HotkeyPanel, 146, "TOPLEFT", 16, -112, {"CTRL-SHIFT-L", "CTRL-Z", "F7", "F12"}, "")

			-- Hide panel during combat
			HotkeyPanel:RegisterEvent("PLAYER_REGEN_DISABLED")
			HotkeyPanel:SetScript("OnEvent", function() 
				LeaPlusCB["ListFrameHotkeyMenu"]:Hide()
				HotkeyPanel:Hide()
			end)

			-- Create global binding function
			local BindBtn = CreateFrame("Button", "LeaPlusGlobalBinding", LeaPlusGlobalPanel)
			BindBtn:SetScript("OnClick", function() LeaPlusLC:SlashFunc() end)

			-- Function to set hotkeys
			local function SetHotkeys()
				-- Clear all bindings bound to panel
				ClearOverrideBindings(LeaPlusGlobalPanel)
				-- Set hotkey according to dropdown choice
				local key = LeaPlusLC["HotkeyMenu"]
				SetOverrideBindingClick(LeaPlusGlobalPanel, true, LeaPlusLC["HotkeyMenuTable"][key], "LeaPlusGlobalBinding")
			end

			-- Help button tooltip
			HotkeyPanel.h.tiptext = L["This panel will close automatically if you enter combat."]

			-- Back button handler
			HotkeyPanel.b:SetScript("OnClick", function()
				LeaPlusCB["ListFrameHotkeyMenu"]:Hide(); -- Hide the dropdown list
				HotkeyPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page8"]:Show()
				return
			end)

			-- Reset button handler
			HotkeyPanel.r:SetScript("OnClick", function()

				-- Reset dropdown
				LeaPlusCB["ListFrameHotkeyMenu"]:Hide(); -- Hide the dropdown list
				LeaPlusLC["HotkeyMenu"] = 1
				SetHotkeys()

				-- Refresh configuration panel
				HotkeyPanel:Hide(); HotkeyPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["HotkeyBtn"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaPlusLC["HotkeyMenu"] = 2
						SetHotkeys()
					else
						HotkeyPanel:Show()
						LeaPlusLC:HideFrames()
					end
				end
			end)

			-- Set hotkey when dropdown menu is closed and on startup
			LeaPlusCB["ListFrameHotkeyMenu"]:HookScript("OnHide", SetHotkeys)
			SetHotkeys()

		end

		----------------------------------------------------------------------
		--	Faster looting
		----------------------------------------------------------------------

		if LeaPlusLC["FasterLooting"] == "On" then

			-- Time delay
			local tDelay = 0

			-- Fast loot function
			local function FastLoot()
				if GetTime() - tDelay >= 0.3 then
					tDelay = GetTime()
 					if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
						for i = GetNumLootItems(), 1, -1 do
							LootSlot(i)
						end
						tDelay = GetTime()
					end
				end
			end

			-- Event frame
			local faster = CreateFrame("Frame")
			faster:RegisterEvent("LOOT_READY")
			faster:SetScript("OnEvent", FastLoot)

		end

		----------------------------------------------------------------------
		--	Disable bag automation
		----------------------------------------------------------------------

		if LeaPlusLC["NoBagAutomation"] == "On" then
			RunScript("hooksecurefunc('OpenAllBags', CloseAllBags)")
		end

		----------------------------------------------------------------------
		--	Hide level-up display
		----------------------------------------------------------------------

		if LeaPlusLC["HideLevelUpDisplay"] == "On" then
			hooksecurefunc(LevelUpDisplay, "Show", LevelUpDisplay.Hide)
		end

		----------------------------------------------------------------------
		--	Hide boss banner
		----------------------------------------------------------------------

		if LeaPlusLC["HideBossBanner"] == "On" then
			BossBanner:UnregisterEvent("ENCOUNTER_LOOT_RECEIVED")
			BossBanner:UnregisterEvent("BOSS_KILL")
		end

		----------------------------------------------------------------------
		--	Hide clean-up buttons
		----------------------------------------------------------------------

		if LeaPlusLC["HideCleanupBtns"] == "On" then
			-- Hide backpack clean-up button and make item search box longer
			BagItemAutoSortButton:HookScript("OnShow", BagItemAutoSortButton.Hide)
			BagItemSearchBox:SetWidth(120)

			-- Hide bank frame clean-up button and make item search box longer
			BankItemAutoSortButton:HookScript("OnShow", BankItemAutoSortButton.Hide)
			BankItemSearchBox:ClearAllPoints()
			BankItemSearchBox:SetPoint("TOPRIGHT", BankFrame, "TOPRIGHT", -27, -33)
			BankItemSearchBox:SetWidth(120)
		end

		----------------------------------------------------------------------
		--	Hide talking frame
		----------------------------------------------------------------------

		if LeaPlusLC["HideTalkingFrame"] == "On" then

			-- Function to hide the talking frame
			local function NoTalkingHeads()
				hooksecurefunc(TalkingHeadFrame, "Show", function(self)
					self:Hide()
				end)
			end

			-- Run function when Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_TalkingHeadUI") then
				NoTalkingHeads()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_TalkingHeadUI" then
						NoTalkingHeads()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		--	Automate quests
		----------------------------------------------------------------------

		if LeaPlusLC["AutomateQuests"] == "On" then

			-- Function to show quest dialog for popup quests in the objective tracker
			local function PopupQuestComplete()
				if GetNumAutoQuestPopUps() > 0 then
					local questId, questType = GetAutoQuestPopUp(1)
					if questType == "COMPLETE" then
						local index = GetQuestLogIndexByID(questId)
						ShowQuestComplete(index)
					end
					LeaPlusLC.PopupQuestTicker:Cancel()
				end
			end

			-- Funcion to ignore specific NPCs
			local function isNpcBlocked(actionType)
				local npcGuid = UnitGUID("target") or nil
				if npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						-- Ignore specific NPCs for selecting, accepting and turning-in quests (required if automation has consequences)
						if npcID == "45400" 	-- Fiona's Caravan (Eastern Plaguelands)
						or npcID == "18166" 	-- Khadgar (Allegiance to Aldor/Scryer, Shattrath)
						or npcID == "114719" 	-- Trader Caelen (Obliterum Forge, Dalaran, Broken Isles)
						or npcID == "6294" 		-- Krom Stoutarm (Heirloom Curator, Ironforge)
						or npcID == "6566" 		-- Estelle Gendry (Heirloom Curator, Undercity)
						then
							return true
						end
						-- Ignore specific NPCs for selecting quests only (required if incomplete quest turn-ins are selected automatically)
						if actionType == "Select" then
							if npcID == "15192" 	-- Anachronos (Caverns of Time)
							or npcID == "111243" 	-- Archmage Lan'dalock (Seal quest, Dalaran)
							or npcID == "119388" 	-- Chieftain Hatuun (Krokul Hovel, Krokuun)
							or npcID == "87391" 	-- Fate-Twister Seress (Seal quest, Stormshield)
							or npcID == "88570"		-- Fate-Twister Tiklal (Seal quest, Horde)
							or npcID == "87706" 	-- Gazmolf Futzwangler (Reputation quests, Nagrand, Draenor)
							or npcID == "55402" 	-- Korgol Crushskull (Darkmoon Faire, Pit Master)
							or npcID == "70022" 	-- Ku'ma (Isle of Giants, Pandaria)
							or npcID == "12944" 	-- Lokhtos Darkbargainer (Thorium Brotherhood, Blackrock Depths)
							or npcID == "109227" 	-- Meliah Grayfeather (Tradewind Roost, Highmountain)
							or npcID == "99183" 	-- Renegade Ironworker (Tanaan Jungle, repeatable quest)
							or npcID == "87393" 	-- Sallee Silverclamp (Reputation quests, Nagrand, Draenor)
							then
								return true
							end
						end
					end
				end
			end

			-- Function to check if quest requires currency
			local function QuestRequiresCurrency()
				for i = 1, 6 do
					local progItem = _G["QuestProgressItem" ..i] or nil
					if progItem and progItem:IsShown() and progItem.type == "required" and progItem.objectType == "currency" then
						return true
					end
				end
			end

			-- Function to check if quest requires gold
			local function QuestRequiresGold()
				local goldRequiredAmount = GetQuestMoneyToGet()
				if goldRequiredAmount and goldRequiredAmount > 0 then
					return true
				end
			end

			-- Register events
			local qFrame = CreateFrame("FRAME")
			qFrame:RegisterEvent("QUEST_DETAIL")
			qFrame:RegisterEvent("QUEST_ACCEPT_CONFIRM")
			qFrame:RegisterEvent("QUEST_PROGRESS")
			qFrame:RegisterEvent("QUEST_COMPLETE")
			qFrame:RegisterEvent("QUEST_GREETING")
			qFrame:RegisterEvent("QUEST_AUTOCOMPLETE")
			qFrame:RegisterEvent("GOSSIP_SHOW")
			qFrame:RegisterEvent("QUEST_FINISHED")
			qFrame:SetScript("OnEvent", function(self, event)

				-- Clear progress items when quest interaction has ceased
				if event == "QUEST_FINISHED" then
					for i = 1, 6 do
						local progItem = _G["QuestProgressItem" ..i] or nil
						if progItem and progItem:IsShown() then
							progItem:Hide()
						end
					end
					return
				end

				-- Do nothing if SHIFT key is being held
				if IsShiftKeyDown() then return end

				----------------------------------------------------------------------
				-- Accept quests automatically
				----------------------------------------------------------------------

				-- Accept quests with a quest detail window
				if event == "QUEST_DETAIL" then
					-- Don't accept blocked quests
					if isNpcBlocked("Accept") then return end
					-- Accept quest
					if QuestGetAutoAccept() then
						-- Quest has already been accepted by Wow so close the quest detail window
						CloseQuest()
					else
						-- Quest has not been accepted by Wow so accept it
						AcceptQuest()
						HideUIPanel(QuestFrame)
					end
				end

				-- Accept quests which require confirmation (such as sharing escort quests)
				if event == "QUEST_ACCEPT_CONFIRM" then
					ConfirmAcceptQuest() 
					StaticPopup_Hide("QUEST_ACCEPT")
				end

				----------------------------------------------------------------------
				-- Turn-in quests automatically
				----------------------------------------------------------------------

				-- Turn-in progression quests
				if event == "QUEST_PROGRESS" and IsQuestCompletable() then
					-- Don't continue quests for blocked NPCs
					if isNpcBlocked("Complete") then return end
					-- Don't continue if quest requires currency
					if QuestRequiresCurrency() then return end
					-- Don't continue if quest requires gold
					if QuestRequiresGold() then return end
					-- Continue quest
					CompleteQuest()
				end

				-- Turn in completed quests if only one reward item is being offered
				if event == "QUEST_COMPLETE" then
					-- Don't complete quests for blocked NPCs
					if isNpcBlocked("Complete") then return end
					-- Don't complete if quest requires currency
					if QuestRequiresCurrency() then return end
					-- Don't complete if quest requires gold
					if QuestRequiresGold() then return end
					-- Complete quest
					if GetNumQuestChoices() <= 1 then
						GetQuestReward(GetNumQuestChoices())
					end
				end

				-- Show quest dialog for quests that use the objective tracker (it will be completed automatically)
				if event == "QUEST_AUTOCOMPLETE" then
					LeaPlusLC.PopupQuestTicker = C_Timer.NewTicker(0.25, PopupQuestComplete, 20)
				end

				----------------------------------------------------------------------
				-- Select quests automatically
				----------------------------------------------------------------------

				if event == "GOSSIP_SHOW" or event == "QUEST_GREETING" then

					-- Select quests
					if UnitExists("npc") or QuestFrameGreetingPanel:IsShown() or GossipFrameGreetingPanel:IsShown() then

						-- Don't select quests for blocked NPCs
						if isNpcBlocked("Select") then return end

						-- Select quests
						if event == "QUEST_GREETING" then
							-- Quest greeting
							local availableCount = GetNumAvailableQuests() + GetNumActiveQuests()
							if availableCount >= 1 then
								for i = 1, availableCount do
									if _G["QuestTitleButton" .. i].isActive == 0 then
										-- Select available quests
										C_Timer.After(0.01, function() SelectAvailableQuest(_G["QuestTitleButton" .. i]:GetID()) end)
									else
										-- Select completed quests
										local void, isComplete = GetActiveTitle(i)
										if isComplete then
											SelectActiveQuest(_G["QuestTitleButton" .. i]:GetID())
										end
									end
								end
							end
						else
							-- Gossip frame
							local availableCount = GetNumGossipAvailableQuests() + GetNumGossipActiveQuests()
							if availableCount >= 1 then
								for i = 1, availableCount do
									if _G["GossipTitleButton" .. i].type == "Available" then
										-- Select available quests
										C_Timer.After(0.01, function() SelectGossipAvailableQuest(i) end)
									else
										-- Select completed quests
										local isComplete = select(i * 6 - 5 + 3, GetGossipActiveQuests()) -- 4th argument of 6 argument line
										if isComplete then
											if _G["GossipTitleButton" .. i].type == "Active" then
												SelectGossipActiveQuest(_G["GossipTitleButton" .. i]:GetID())
											end
										end
									end
								end
							end
						end
					end
				end

			end)

		end

		----------------------------------------------------------------------
		-- Hide bogyguard gossip
		----------------------------------------------------------------------

		if LeaPlusLC["HideBodyguard"] == "On" then
			local gFrame = CreateFrame("FRAME")
			gFrame:RegisterEvent("GOSSIP_SHOW")
			gFrame:SetScript("OnEvent", function()
				-- Do nothing if shift is being held
				if IsShiftKeyDown() then return end
				-- Traverse faction IDs for known bodyguards (http://www.wowhead.com/factions/warlords-of-draenor/barracks-bodyguards)
				local id = GetFriendshipReputation();
				if id then
					if id == 1733 -- Delvar Ironfist
					or id == 1736 -- Tormmok
					or id == 1737 -- Talonpriest Ishaal
					or id == 1738 -- Defender Illona
					or id == 1739 -- Vivianne
					or id == 1740 -- Aeda Brightdawn
					or id == 1741 -- Leorajh
					then
						-- Close gossip window if it's for a cooperating (active) bodyguard
						if UnitCanCooperate("target", "player") then
							CloseGossip()
						end
					end
				end
			end)
		end

		----------------------------------------------------------------------
		--	Disable map emote
		----------------------------------------------------------------------

		if LeaPlusLC["NoMapEmote"] == "On" then
			hooksecurefunc("DoEmote", function(emote)
				if emote == "READ" and WorldMapFrame:IsShown() then
					CancelEmote()
				end
			end)
		end

		----------------------------------------------------------------------
		--	Skip cinematics
		----------------------------------------------------------------------

		if LeaPlusLC["SkipCinematics"] == "On" then

			-- Skip cinematics
			CinematicFrame:HookScript("OnShow", function(self)
				-- Do nothing if shift key is being held
				if IsShiftKeyDown() then return	end
				-- Click the close dialog confirmation button to stop the cinematic
				if self.closeDialog and CinematicFrameCloseDialogConfirmButton then
					CinematicFrameCloseDialogConfirmButton:Click()
					-- Show confirmation message
					LeaPlusLC:Print("A cinematic skip was attempted.")
				end
			end)

			-- Skip movies
			hooksecurefunc("MovieFrame_PlayMovie", function(self, movieID)
				-- Do nothing if shift key is being held
				if IsShiftKeyDown() then return	end
				-- Do nothing if movie playback flag is on
				if LeaPlusLC["ForceMoviePlaybackFlag"] == "On" then return end
				-- Click the close dialog confirmation button to stop the movie
				if self.CloseDialog and self.CloseDialog.ConfirmButton then
					self.CloseDialog.ConfirmButton:Click()
					-- Show confirmation message
					LeaPlusLC:Print("A movie skip was attempted.")
					if movieID then
						LeaPlusLC:Print(L["Movie number"] .. ": |cffffffff" .. movieID .. "|r")
					end
				end
			end)

		end

		----------------------------------------------------------------------
		--	Sort game options addon list
		----------------------------------------------------------------------

		if LeaPlusLC["CharAddonList"] == "On" then
			-- Set the addon list to character by default
			if AddonCharacterDropDown and AddonCharacterDropDown.selectedValue then
				AddonCharacterDropDown.selectedValue = UnitName("player");
				AddonCharacterDropDownText:SetText(UnitName("player"))
			end
		end

		----------------------------------------------------------------------
		--	Sell junk automatically
		----------------------------------------------------------------------

		if LeaPlusLC["AutoSellJunk"] == "On" then

			-- Create configuration panel
			local JunkPanel = LeaPlusLC:CreatePanel("Sell Junk Automatically", "JunkPanel")

			LeaPlusLC:MakeTx(JunkPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(JunkPanel, "SellJunkSummary", "Show a summary of items sold", 16, -92, false, "If checked, a brief summary will be shown in chat when items are sold automatically.")

			-- Help button hidden
			JunkPanel.h:Hide()

			-- Back button handler
			JunkPanel.b:SetScript("OnClick", function() 
				JunkPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page1"]:Show()
				return
			end)

			-- Reset button handler
			JunkPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["SellJunkSummary"] = "On"

				-- Refresh side panel
				JunkPanel:Hide(); JunkPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["SellJunkBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["SellJunkSummary"] = "On"
				else
					JunkPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			-- Create sell junk banner
			local StartMsg = CreateFrame("FRAME", nil, MerchantFrame)
			StartMsg:ClearAllPoints()
			StartMsg:SetPoint("BOTTOMLEFT", 4, 4)
			StartMsg:SetSize(160, 22)
			StartMsg:SetToplevel(true)
			StartMsg:Hide()

			StartMsg.s = StartMsg:CreateTexture(nil, "BACKGROUND")
			StartMsg.s:SetAllPoints()
			StartMsg.s:SetColorTexture(0.1, 0.1, 0.1, 1.0)

			StartMsg.f = StartMsg:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
			StartMsg.f:SetAllPoints();
			StartMsg.f:SetText(L["SELLING JUNK"])

			-- Declarations
			local IterationCount, totalPrice = 500, 0
			local SellJunkFrame = CreateFrame("FRAME")
			local SellJunkTicker, mBagID, mBagSlot

			-- Function to stop selling
			local function StopSelling()
				if SellJunkTicker then SellJunkTicker:Cancel() end
				StartMsg:Hide()
				SellJunkFrame:UnregisterEvent("ITEM_LOCKED")
				SellJunkFrame:UnregisterEvent("ITEM_UNLOCKED")
			end

			-- Vendor function
			local function SellJunkFunc()

				-- Variables
				local SoldCount, Rarity, ItemPrice = 0, 0, 0
				local CurrentItemLink, void

				-- Traverse bags and sell grey items
				for BagID = 0, 4 do
					for BagSlot = 1, GetContainerNumSlots(BagID) do
						CurrentItemLink = GetContainerItemLink(BagID, BagSlot)
						if CurrentItemLink then
							void, void, Rarity, void, void, void, void, void, void, void, ItemPrice = GetItemInfo(CurrentItemLink)
							local void, itemCount = GetContainerItemInfo(BagID, BagSlot)
							if Rarity == 0 and ItemPrice ~= 0 then
								SoldCount = SoldCount + 1
								if MerchantFrame:IsShown() then
									-- If merchant frame is open, vendor the item
									UseContainerItem(BagID, BagSlot)
									-- Perform actions on first iteration
									if SellJunkTicker._remainingIterations == IterationCount then
										-- Calculate total price
										totalPrice = totalPrice + (ItemPrice * itemCount)
										-- Store first sold bag slot for analysis
										if SoldCount == 1 then
											mBagID, mBagSlot = BagID, BagSlot
										end
									end
								else
									-- If merchant frame is not open, stop selling
									StopSelling()
									return
								end
							end
						end
					end
				end

				-- Stop selling if no items were sold for this iteration or iteration limit was reached
				if SoldCount == 0 or SellJunkTicker and SellJunkTicker._remainingIterations == 1 then 
					StopSelling() 
					if LeaPlusLC["SellJunkSummary"] == "On" and totalPrice > 0 then 
						LeaPlusLC:Print(L["Sold junk for"] .. " " .. GetCoinText(totalPrice) .. "。")
					end
				end

			end

			-- Run sell function when merchant frame is shown
			SellJunkFrame:RegisterEvent("MERCHANT_SHOW");
			SellJunkFrame:RegisterEvent("MERCHANT_CLOSED");
			SellJunkFrame:SetScript("OnEvent", function(self, event)
				if event == "MERCHANT_SHOW" then
					-- Reset variables
					totalPrice, mBagID, mBagSlot = 0, -1, -1
					-- Do nothing if shift key is held down
					if IsShiftKeyDown() then return end
					-- Cancel existing ticker if present
					if SellJunkTicker then SellJunkTicker:Cancel() end
					-- Sell grey items using ticker (ends when all grey items are sold or iteration count reached)
					SellJunkTicker = C_Timer.NewTicker(0.2, SellJunkFunc, IterationCount)
					SellJunkFrame:RegisterEvent("ITEM_LOCKED")
					SellJunkFrame:RegisterEvent("ITEM_UNLOCKED")
				elseif event == "ITEM_LOCKED" then
					StartMsg:Show()
					SellJunkFrame:UnregisterEvent("ITEM_LOCKED")
				elseif event == "ITEM_UNLOCKED" then
					SellJunkFrame:UnregisterEvent("ITEM_UNLOCKED")
					-- Check whether vendor refuses to buy items
					if mBagID and mBagSlot and mBagID ~= -1 and mBagSlot ~= -1 then
						local texture, count, locked = GetContainerItemInfo(mBagID, mBagSlot)
						if count and not locked then
							-- Item has been unlocked but still not sold so stop selling
							StopSelling()
						end
					end
				elseif event == "MERCHANT_CLOSED" then
					-- If merchant frame is closed, stop selling
					StopSelling()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Repair automatically
		----------------------------------------------------------------------

		if LeaPlusLC["AutoRepairOwnFunds"] == "On" then

			-- Create configuration panel
			local RepairPanel = LeaPlusLC:CreatePanel("Repair Automatically", "RepairPanel")

			LeaPlusLC:MakeTx(RepairPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(RepairPanel, "AutoRepairGuildFunds", "Repair using guild funds if available", 16, -92, false, "If checked, repair costs will be taken from guild funds for characters that are guilded and have permission to repair.")
			LeaPlusLC:MakeCB(RepairPanel, "AutoRepairSummary", "Show a brief summary of repair costs", 16, -112, false, "If checked, a brief summary of repair costs will be shown in chat when an automated repair is attempted.")

			-- Help button hidden
			RepairPanel.h:Hide()

			-- Back button handler
			RepairPanel.b:SetScript("OnClick", function() 
				RepairPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page1"]:Show();
				return
			end)

			-- Reset button handler
			RepairPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["AutoRepairGuildFunds"] = "On"
				LeaPlusLC["AutoRepairSummary"] = "On"

				-- Refresh side panel
				RepairPanel:Hide(); RepairPanel:Show();

			end)

			-- Show side panal when options panel button is clicked
			LeaPlusCB["RepairBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["AutoRepairGuildFunds"] = "On"
					LeaPlusLC["AutoRepairSummary"] = "On"
				else
					RepairPanel:Show();
					LeaPlusLC:HideFrames();
				end
			end);

			-- Repair when suitable merchant frame is shown
			local function RepairFunc()
				if IsShiftKeyDown() then return end
				if CanMerchantRepair() then -- If merchant is capable of repair
					-- Process repair
					local RepairCost, CanRepair = GetRepairAllCost()
					if CanRepair then -- If merchant is offering repair
						if LeaPlusLC["AutoRepairGuildFunds"] == "On" and IsInGuild() then
							-- Guilded character and guild repair option is enabled
							if CanGuildBankRepair() then
								-- Character has permission to repair so try guild funds but fallback on character funds (if daily gold limit is reached)
								RepairAllItems(1)
								RepairAllItems()
							else
								-- Character does not have permission to repair so use character funds
								RepairAllItems()
							end
						else
							-- Unguilded character or guild repair option is disabled
							RepairAllItems()
						end
						-- Show cost summary
						if LeaPlusLC["AutoRepairSummary"] == "On" then
							LeaPlusLC:Print(L["Repaired for"] .. " " .. GetCoinText(RepairCost) .. "。")
						end
					end
				end
			end

			-- Run repair function when merchant frame is shown
			local RepairFrame = CreateFrame("FRAME")
			RepairFrame:RegisterEvent("MERCHANT_SHOW");
			RepairFrame:SetScript("OnEvent", RepairFunc)

		end

		----------------------------------------------------------------------
		-- Hide the combat log
		----------------------------------------------------------------------

		if LeaPlusLC["NoCombatLogTab"] == "On" then
			-- Ensure combat log is docked
			if ChatFrame2.isDocked then
				-- Set combat log attributes when chat windows are updated
				LpEvt:RegisterEvent("UPDATE_CHAT_WINDOWS")
				-- Set combat log tab placement when tabs are assigned by the client
				hooksecurefunc("FCF_SetTabPosition", function()
					ChatFrame2Tab:SetPoint("BOTTOMLEFT", ChatFrame1Tab, "BOTTOMRIGHT", 0, 0)
				end)
			else
				-- If combat log is undocked, do nothing but show warning
				LeaPlusLC:Print("Combat log cannot be hidden while undocked.")
			end
		end

		----------------------------------------------------------------------
		--	Show player chain
		----------------------------------------------------------------------

		if LeaPlusLC["ShowPlayerChain"] == "On" then

			-- Create configuration panel
			local ChainPanel = LeaPlusLC:CreatePanel("Player Chain", "ChainPanel")

			-- Add dropdown menu
			LeaPlusLC:CreateDropDown("PlayerChainMenu", "Chain style", ChainPanel, 146, "TOPLEFT", 16, -112, {L["RARE"], L["ELITE"], L["RARE ELITE"]}, "")

			-- Set chain style
			local function SetChainStyle()
				-- Get dropdown menu value
				local chain = LeaPlusLC["PlayerChainMenu"] -- Numeric value
				-- Set chain style according to value
				if chain == 1 then -- Rare
					PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare.blp");
				elseif chain == 2 then -- Elite
					PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite.blp");
				elseif chain == 3 then -- Rare Elite
					PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Rare-Elite.blp");
				end
			end

			-- Set style on startup
			SetChainStyle()

			-- Set style when a drop menu is selected (procs when the list is hidden)
			LeaPlusCB["ListFramePlayerChainMenu"]:HookScript("OnHide", SetChainStyle)

			-- Help button hidden
			ChainPanel.h:Hide()

			-- Back button handler
			ChainPanel.b:SetScript("OnClick", function() 
				LeaPlusCB["ListFramePlayerChainMenu"]:Hide(); -- Hide the dropdown list
				ChainPanel:Hide();
				LeaPlusLC["PageF"]:Show();
				LeaPlusLC["Page6"]:Show();
				return
			end) 

			-- Reset button handler
			ChainPanel.r:SetScript("OnClick", function()
				LeaPlusCB["ListFramePlayerChainMenu"]:Hide(); -- Hide the dropdown list
				LeaPlusLC["PlayerChainMenu"] = 2
				ChainPanel:Hide(); ChainPanel:Show();
				SetChainStyle()
			end)

			-- Show the panel when the configuration button is clicked
			LeaPlusCB["ModPlayerChain"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					LeaPlusLC["PlayerChainMenu"] = 3;
					SetChainStyle();
				else
					LeaPlusLC:HideFrames();
					ChainPanel:Show();
				end
			end)

		end

		----------------------------------------------------------------------
		-- Show raid frame toggle button
		----------------------------------------------------------------------

		if LeaPlusLC["ShowRaidToggle"] == "On" then

			-- Check to make sure raid toggle button exists
			if CompactRaidFrameManagerDisplayFrameHiddenModeToggle then

				-- Create a border for the button
				CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetBackdrop({ 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = false, tileSize = 0, edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }})

				-- Move the button (function runs after PLAYER_ENTERING_WORLD and PARTY_LEADER_CHANGED)
				hooksecurefunc("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
					if CompactRaidFrameManager and CompactRaidFrameManagerDisplayFrameHiddenModeToggle then
						local void, void, void, void, y = CompactRaidFrameManager:GetPoint()
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetWidth(40)
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:ClearAllPoints()
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, y + 22)
						CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetParent(UIParent)
					end
				end)

			end

		end

		----------------------------------------------------------------------
		-- Hide hit indicators (portrait text)
		----------------------------------------------------------------------

		if LeaPlusLC["NoHitIndicators"] == "On" then
			hooksecurefunc(PlayerHitIndicator, "Show", PlayerHitIndicator.Hide)
			hooksecurefunc(PetHitIndicator, "Show", PetHitIndicator.Hide)
		end

		----------------------------------------------------------------------
		-- Class colored frames
		----------------------------------------------------------------------

		if LeaPlusLC["ClassColFrames"] == "On" then

			-- Create background frame for player frame
			local PlayFN = CreateFrame("FRAME", nil, PlayerFrame)
			PlayFN:Hide()

			PlayFN:SetWidth(TargetFrameNameBackground:GetWidth())
			PlayFN:SetHeight(TargetFrameNameBackground:GetHeight())

			local void, void, void, x, y = TargetFrameNameBackground:GetPoint()
			PlayFN:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", -x, y)

			PlayFN.t = PlayFN:CreateTexture(nil, "BORDER")
			PlayFN.t:SetAllPoints()
			PlayFN.t:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-LevelBackground")

			local c = LeaPlusLC["RaidColors"][select(2, UnitClass("player"))]
			if c then PlayFN.t:SetVertexColor(c.r, c.g, c.b) end

			-- Create color function for target and focus frames
			local function TargetFrameCol()
				if UnitIsPlayer("target") then
					local c = LeaPlusLC["RaidColors"][select(2, UnitClass("target"))]
					if c then TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b) end
				end
		
				if UnitIsPlayer("focus") then
					local c = LeaPlusLC["RaidColors"][select(2, UnitClass("focus"))]
					if c then FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b) end
				end
			end

			local ColTar = CreateFrame("FRAME")
			ColTar:SetScript("OnEvent", TargetFrameCol) -- Events are registered if target option is enabled

			-- Refresh color if focus frame size changes
			hooksecurefunc("FocusFrame_SetSmallSize", function()
				if LeaPlusLC["ClassColTarget"] == "On" then
					TargetFrameCol()
				end
			end)

			-- Create configuration panel
			local ClassFrame = LeaPlusLC:CreatePanel("Class Colored Frames", "ClassFrame")

			LeaPlusLC:MakeTx(ClassFrame, "Settings", 16, -72)
			LeaPlusLC:MakeCB(ClassFrame, "ClassColPlayer", "Show player frame in class color", 16, -92, false, "If checked, the player frame background will be shown in class color.")
			LeaPlusLC:MakeCB(ClassFrame, "ClassColTarget", "Show target frame and focus frame in class color", 16, -112, false, "If checked, the target frame background and focus frame background will be shown in class color.")

			-- Help button hidden
			ClassFrame.h:Hide()

			-- Back button handler
			ClassFrame.b:SetScript("OnClick", function() 
				ClassFrame:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page6"]:Show();
				return
			end)

			-- Function to set class colored frames
			local function SetClassColFrames()
				-- Player frame
				if LeaPlusLC["ClassColPlayer"] == "On" then
					PlayFN:Show()
				else
					PlayFN:Hide()
				end
				-- Target and focus frames
				if LeaPlusLC["ClassColTarget"] == "On" then
					ColTar:RegisterEvent("GROUP_ROSTER_UPDATE")
					ColTar:RegisterEvent("PLAYER_TARGET_CHANGED")
					ColTar:RegisterEvent("PLAYER_FOCUS_CHANGED")
					ColTar:RegisterEvent("UNIT_FACTION")
					TargetFrameCol()
				else
					ColTar:UnregisterAllEvents()
					TargetFrame_CheckFaction(TargetFrame) -- Reset target frame colors
					TargetFrame_CheckFaction(FocusFrame) -- Reset focus frame colors
				end
			end

			-- Run function when options are clicked and on startup
			LeaPlusCB["ClassColPlayer"]:HookScript("OnClick", SetClassColFrames)
			LeaPlusCB["ClassColTarget"]:HookScript("OnClick", SetClassColFrames)
			SetClassColFrames()

			-- Reset button handler
			ClassFrame.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["ClassColPlayer"] = "On"
				LeaPlusLC["ClassColTarget"] = "On"

				-- Update colors and refresh configuration panel
				SetClassColFrames()
				ClassFrame:Hide(); ClassFrame:Show();

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["ClassFramesBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["ClassColPlayer"] = "On"
					LeaPlusLC["ClassColTarget"] = "On"
					SetClassColFrames()
				else
					ClassFrame:Show();
					LeaPlusLC:HideFrames();
				end
			end);

		end

		----------------------------------------------------------------------
		-- Coordinates
		----------------------------------------------------------------------

		if LeaPlusLC["StaticCoordsEn"] == "On" then

			-- Create movable coordinates frame
			local StaticCoordBox = CreateFrame("Frame", nil, UIParent)
			LeaPlusLC["StaticCoordBox"] = StaticCoordBox
			StaticCoordBox:Hide(); StaticCoordBox:EnableMouse(true);
			StaticCoordBox:SetClampedToScreen(true);
			StaticCoordBox:ClearAllPoints(); StaticCoordBox:SetPoint(LeaPlusLC["CoordsA"], UIParent, LeaPlusLC["CoordsR"], LeaPlusLC["CoordsX"], LeaPlusLC["CoordsY"]);
			StaticCoordBox:SetMovable(true); StaticCoordBox:RegisterForDrag("LeftButton")
			StaticCoordBox:SetScript("OnDragStart", StaticCoordBox.StartMoving)
			StaticCoordBox:SetScript("OnDragStop", function ()
				StaticCoordBox:StopMovingOrSizing();
				StaticCoordBox:SetUserPlaced(false);
				LeaPlusLC["CoordsA"], void, LeaPlusLC["CoordsR"], LeaPlusLC["CoordsX"], LeaPlusLC["CoordsY"] = StaticCoordBox:GetPoint();
			end)
			StaticCoordBox.t = StaticCoordBox:CreateTexture(nil, "BACKGROUND"); StaticCoordBox.t:SetAllPoints(); StaticCoordBox.t:SetColorTexture(0.05, 0.05, 0.05, 0.8)

			local Splay = CreateFrame("FRAME", nil, StaticCoordBox)
			Splay:SetWidth(44); Splay:SetHeight(16);
			Splay:SetPoint("TOPLEFT", 2, -2)

			Splay.x = Splay:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
			Splay.x:SetAllPoints(); Splay.x:SetJustifyH"LEFT";

			Splay.y = Splay:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
			Splay.y:SetPoint("LEFT", Splay.x, "RIGHT", 10, 0);
			Splay.y:SetJustifyH"LEFT";

			local stimer = 0; -- Internal timer for OnUpdate
			local vplayx, vplayy -- Raw coordinates

			local function ShowStaticCoordinates(self, elapsed)
				stimer = stimer + elapsed;
				if stimer > 0.2 then
					vplayx, vplayy = GetPlayerMapPosition("player")
					if vplayx and vplayy and vplayx > 0 and vplayy > 0 then
						Splay.x:SetFormattedText("%0.1f", (floor(vplayx * 1000 + 0.5)) / 10)
						Splay.y:SetFormattedText("%0.1f", (floor(vplayy * 1000 + 0.5)) / 10)
					else
						Splay.x:SetText("00.0");
						Splay.y:SetText("00.0");
					end
					stimer = 0;
				end
			end

			-- Calculate coordinates (only runs if coordinates are showing)
			StaticCoordBox:SetScript("OnUpdate", ShowStaticCoordinates)

			-- Create side panel
			local StaticPanel = LeaPlusLC:CreatePanel("Coordinates", "StaticPanel")

			LeaPlusLC:MakeTx(StaticPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(StaticPanel, "StaticCoords", "Show the coordinates frame", 16, -92, false, "If checked, the coordinates frame will be shown.|n|nIf you have the minimap button enabled, you can hold down SHIFT and right-click it to toggle this setting at any time.|n|nIf unchecked, the coordinates frame will be disabled and no CPU power will be allocated to updating it.")
			LeaPlusLC:MakeCB(StaticPanel, "StaticCoordsBack", "Darken the frame background", 16, -112, false, "If checked, a dark background will be used for the frame.")
			LeaPlusLC:MakeCB(StaticPanel, "StaticCoordsTop", "Raise the frame strata level", 16, -132, false, "If checked, the frame strata level will be set to HIGH allowing it to show on top of most frames.|n|nIf unchecked, the strata level will be set to MEDIUM.")
			LeaPlusLC:MakeCB(StaticPanel, "StaticCoordsLock", "Lock the frame and make it non-interactive", 16, -152, false, "If checked, the frame will be locked and you will not be able to move it.|n|nEnabling this option will make the frame non-interactive, meaning you will be able to click through it as if it wasn't there.|n|nThis is useful if you are showing the coordinates in a space where you would normally click (such as the game world or minimap).")

			LeaPlusLC:MakeTx(StaticPanel, "Scale", 356, -72)
			LeaPlusLC:MakeSL(StaticPanel, "StaticCoordsScale", "", 0.9, 2.0, 0.1, 356, -92, "%.1f")

			-- Function to show coordinates based on options (run by many handlers)
			local function RefreshStaticCoords()
				-- Show or hide coordinates
				if LeaPlusLC["StaticCoords"] == "On" then
					-- Show coordinates
					StaticCoordBox:Show();
				else
					StaticCoordBox:Hide();
				end
				-- Show or hide the background
				if LeaPlusLC["StaticCoordsBack"] == "On" then
					StaticCoordBox.t:Show();
				else
					StaticCoordBox.t:Hide();
				end
				-- Set scale of coordinates
				local scale = LeaPlusLC["StaticCoordsScale"]
				StaticCoordBox:SetWidth(96 * scale);
				StaticCoordBox:SetHeight(18 * scale);
				Splay:SetScale(scale);
				-- Set locked status
				if LeaPlusLC["StaticCoordsLock"] == "On" then
					StaticCoordBox:SetScript("OnDragStart", nil);
					StaticCoordBox:EnableMouse(false);
				else
					StaticCoordBox:SetScript("OnDragStart", StaticCoordBox.StartMoving)
					StaticCoordBox:EnableMouse(true);
				end
				-- Show on top
				if LeaPlusLC["StaticCoordsTop"] == "On" then
					StaticCoordBox:SetFrameStrata("HIGH")
				else
					StaticCoordBox:SetFrameStrata("MEDIUM")
				end
				-- Show coordinates
				if LeaPlusLC["StaticCoords"] == "On" then
					StaticCoordBox:Show();
				else
					StaticCoordBox:Hide();
				end
				-- Set slider formatted text
				LeaPlusCB["StaticCoordsScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["StaticCoordsScale"] * 100)
			end
		
			-- Assign file level scope to local function (so that the minimap button can run it)
			LeaPlusLC.RefreshStaticCoords = RefreshStaticCoords

			-- Refresh map when controls are clicked
			LeaPlusCB["StaticCoords"]:HookScript("OnClick", RefreshStaticCoords)
			LeaPlusCB["StaticCoordsBack"]:HookScript("OnClick", RefreshStaticCoords)
			LeaPlusCB["StaticCoordsScale"]:HookScript("OnValueChanged", RefreshStaticCoords)
			LeaPlusCB["StaticCoordsLock"]:HookScript("OnClick", RefreshStaticCoords)
			LeaPlusCB["StaticCoordsTop"]:HookScript("OnClick", RefreshStaticCoords)

			-- Hide coordinates frame when battle pet frame is shown
			hooksecurefunc("PetBattleFrame_Display", function() 
				if LeaPlusLC["StaticCoords"] == "On" then
					LeaPlusLC["StaticCoordBox"]:Hide();
				end
			end)

			-- Refresh coordinates when battle frame is hidden
			hooksecurefunc("PetBattleFrame_Remove", function() 
				if LeaPlusLC["StaticCoords"] == "On" then
					RefreshStaticCoords();
				end
			end)

			-- Hide coordinates frame when world map is shown
			local function HideWithMap()
				if LeaPlusLC["StaticCoords"] == "On" then
					if WorldMapFrame:IsShown() then
						StaticCoordBox:Hide();
					else
						StaticCoordBox:Show();
					end
				end
			end

			WorldMapFrame:HookScript("OnShow", HideWithMap);
			WorldMapFrame:HookScript("OnHide", HideWithMap);

			-- Hide coordinates if they are showing when world map is shown
			StaticCoordBox:HookScript("OnShow", function()
				if WorldMapFrame:IsShown() then
					StaticCoordBox:Hide()
				end
			end)

			-- Load settings on startup
			RefreshStaticCoords();

			-- Help button tooltip
			StaticPanel.h.tiptext = L["Drag the coordinates frame to position it."]

			-- Back button handler
			StaticPanel.b:SetScript("OnClick", function() 
				StaticPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show();
				return
			end) 

			-- Reset button handler
			StaticPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["StaticCoords"] = "On"
				LeaPlusLC["StaticCoordsBack"] = "Off"
				LeaPlusLC["StaticCoordsScale"] = 1.0;
				LeaPlusLC["StaticCoordsLock"] = "Off";
				LeaPlusLC["StaticCoordsTop"] = "Off";
				RefreshStaticCoords();

				-- Reset coordinates frame location
				LeaPlusLC["CoordsA"], LeaPlusLC["CoordsR"], LeaPlusLC["CoordsX"], LeaPlusLC["CoordsY"] = "CENTER", "CENTER", 0, 200
				StaticCoordBox:ClearAllPoints();
				StaticCoordBox:SetPoint(LeaPlusLC["CoordsA"], UIParent, LeaPlusLC["CoordsR"], LeaPlusLC["CoordsX"], LeaPlusLC["CoordsY"]);

				-- Refresh side panel
				StaticPanel:Hide(); StaticPanel:Show();

			end)

			-- Show side panal when options panel button is clicked
			LeaPlusCB["ModStaticCoordsBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["StaticCoords"] = "On"
					LeaPlusLC["StaticCoordsBack"] = "Off"
					LeaPlusLC["StaticCoordsScale"] = 2.0;
					LeaPlusLC["StaticCoordsLock"] = "Off";
					LeaPlusLC["StaticCoordsTop"] = "Off";
					LeaPlusLC["CoordsA"], LeaPlusLC["CoordsR"], LeaPlusLC["CoordsX"], LeaPlusLC["CoordsY"] = "BOTTOMRIGHT", "BOTTOMRIGHT", -300, 130
					StaticCoordBox:ClearAllPoints();
					StaticCoordBox:SetPoint(LeaPlusLC["CoordsA"], UIParent, LeaPlusLC["CoordsR"], LeaPlusLC["CoordsX"], LeaPlusLC["CoordsY"]);
					RefreshStaticCoords();
				else
					StaticPanel:Show();
					LeaPlusLC:HideFrames();
				end
			end);

			-- Refresh map when zone changes if coordinates are showing (so that coordinates update to new zone)
			local function UpdateMapZone()
				if LeaPlusLC["StaticCoords"] == "On" then
					if StaticCoordBox:IsShown() then
						SetMapToCurrentZone();
					end
				end
			end

			StaticCoordBox:RegisterEvent("ZONE_CHANGED_NEW_AREA");
			StaticCoordBox:RegisterEvent("ZONE_CHANGED");
			StaticCoordBox:RegisterEvent("ZONE_CHANGED_INDOORS");
			StaticCoordBox:RegisterEvent("NEW_WMO_CHUNK");
			StaticCoordBox:SetScript("OnEvent", UpdateMapZone);	
			StaticCoordBox:SetScript("OnShow", UpdateMapZone);	

		end

		----------------------------------------------------------------------
		-- Minimap customisation
		----------------------------------------------------------------------

		if LeaPlusLC["MinimapMod"] == "On" then

			----------------------------------------------------------------------
			-- Configuration panel
			----------------------------------------------------------------------

			-- Create minimap modification side panel
			local SideMinimap = LeaPlusLC:CreatePanel("Minimap", "SideMinimap")

			-- Hide panel during combat
			SideMinimap:RegisterEvent("PLAYER_REGEN_DISABLED")
			SideMinimap:SetScript("OnEvent", SideMinimap.Hide)

			-- Add checkboxes
			LeaPlusLC:MakeTx(SideMinimap, "Settings", 16, -72)
			LeaPlusLC:MakeCB(SideMinimap, "MergeTrackBtn", "Merge tracking button with calendar button", 16, -92, false, "If checked, the minimap tracking button will be merged with the calendar button to save space.|n|nThe new tracking button will be moved to the space normally occupied by the calendar button.|n|nYou will be able to left-click the tracking button to show the tracking menu and right-click it to show the calendar.")
			LeaPlusLC:MakeCB(SideMinimap, "HideMinimapZone", "Hide zone information above the minimap", 16, -112, false, "If checked, the zone information shown above the minimap, as well as the world map button, will be hidden.|n|nThe tooltip for the tracking button will show zone text information instead.|n|nTo show the world map, press the map bind key (M by default).")
			LeaPlusLC:MakeCB(SideMinimap, "HideMinimapTime", "Hide the clock below the minimap", 16, -132, false, "If checked, the clock will be hidden.")
			LeaPlusLC:MakeCB(SideMinimap, "MinimapMouseZoom", "Use the mousewheel to zoom in and out", 16, -152, false, "If checked, you will be able to use the mousewheel to zoom in and out of the minimap.  The zoom in/out buttons will be hidden.")

			-- Add slider control
			LeaPlusLC:MakeTx(SideMinimap, "Minimap scale", 356, -72)
			LeaPlusLC:MakeSL(SideMinimap, "MinimapScale", "", 0.5, 2, 0.1, 356, -92, "%.2f")

			----------------------------------------------------------------------
			-- Merge buttons
			----------------------------------------------------------------------

			-- Function to merge buttons
			local function SetMiniMerge()
				if LeaPlusLC["MergeTrackBtn"] == "On" then
					-- Hide calendar button
					GameTimeFrame:Hide();
					-- Move the tracking button to the calendar button space
					MiniMapTracking:ClearAllPoints();
					MiniMapTracking:SetAllPoints(GameTimeFrame);
					-- Right-clicking the tracking button shows the calendar 
					MiniMapTrackingButton:SetScript("OnMouseDown", function(self, btn)
						if btn == "RightButton" then GameTimeFrame:Click();	end
					end)
				else
					-- Show the calendar button
					GameTimeFrame:Show();
					-- Move the tracking button to its origianl position
					MiniMapTracking:ClearAllPoints();
					MiniMapTracking:SetPoint("TOPLEFT", MinimapBackdrop, "TOPLEFT", 9, -45);
					-- Remove right-click from the tracking button
					MiniMapTrackingButton:SetScript("OnMouseDown", nil);
				end
			end

			-- When the merge buttons option is checked, update the minimap
			LeaPlusCB["MergeTrackBtn"]:HookScript("OnClick", SetMiniMerge);

			-- Merge buttons on startup
			SetMiniMerge();

			----------------------------------------------------------------------
			-- Hide minimap zone text
			----------------------------------------------------------------------

			-- Store Blizzard handlers
			local origMiniMapTrackingButtonOnEnter = MiniMapTrackingButton:GetScript('OnEnter')
			local zonta,zontp,zontr,zontx,zonty = MinimapZoneTextButton:GetPoint();

			-- Function to show zone tooltip
			local function ShowZoneTip()
				if LeaPlusLC["HideMinimapZone"] == "On" then
					-- Show zone information in tooltip
					local zoneName = GetZoneText();
					local subzoneName = GetSubZoneText();
					if ( subzoneName == zoneName ) then
						subzoneName = "";	
					end
					-- Change the owner and position (needed for Minimap_SetTooltip)
					GameTooltip:SetOwner(MinimapZoneTextButton, "ANCHOR_LEFT")
					MinimapZoneTextButton:SetAllPoints(MiniMapTrackingButton)
					-- Show the tooltip
					local pvpType, isSubZonePvP, factionName = GetZonePVPInfo();
					Minimap_SetTooltip( pvpType, factionName )
					GameTooltip:Show();
				else
					MinimapZoneTextButton:ClearAllPoints();
					MinimapZoneTextButton:SetPoint(zonta,zontp,zontr,zontx,zonty)
				end
			end

			-- Function to hide zone text
			local function SetMiniZoneText()
				if LeaPlusLC["HideMinimapZone"] == "On" then
					-- Hide the minimap zone information and world map button
					MinimapZoneTextButton:Hide(); MiniMapWorldMapButton:Hide();
					MinimapBorderTop:SetTexture("");
					-- Move the minimap up to the top
					MinimapCluster:ClearAllPoints(); MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 20);
					-- Set the tooltip of the tracking button as the zone name
					MiniMapTrackingButton:SetScript("OnEnter", ShowZoneTip);
				else
					-- Show the minimap zone information and world map button
					MinimapZoneTextButton:Show(); MiniMapWorldMapButton:Show();
					MinimapBorderTop:SetTexture("Interface\\Minimap\\UI-Minimap-Border");
					-- Move the minimap to its original position
					MinimapCluster:ClearAllPoints(); MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0);
					-- Set the tooltip of the tracking button as the original one
					MiniMapTrackingButton:SetScript("OnEnter", origMiniMapTrackingButtonOnEnter);
				end
			end

			-- Function to refresh tooltip text (used when zone text option changes)
			local function ShowTextAndTip()
				SetMiniZoneText(); 
				ShowZoneTip();
			end

			-- When the hide zone text option is checked, refresh the zone tooltip
			LeaPlusCB["HideMinimapZone"]:HookScript("OnClick", ShowTextAndTip);

			-- Update the minimap on startup
			SetMiniZoneText();

			----------------------------------------------------------------------
			-- Hide the clock
			----------------------------------------------------------------------

			-- Function to show or hide the clock
			local function SetMiniClock()
				if IsAddOnLoaded("Blizzard_TimeManager") then -- Required because function runs multiple places
					if LeaPlusLC["HideMinimapTime"] == "On"	then
						TimeManagerClockButton:Hide();
					else
						TimeManagerClockButton:Show();
					end
				end
			end

			-- Run function when Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_TimeManager") then
				SetMiniClock()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_TimeManager" then
						SetMiniClock()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			-- Update the clock when the checkbox is clicked
			LeaPlusCB["HideMinimapTime"]:HookScript("OnClick", SetMiniClock);
		
			----------------------------------------------------------------------
			-- Mousewheel zoom
			----------------------------------------------------------------------

			-- Function to zoom the minimap (only used by SetMiniZoom)
			local function MiniZoom(self, arg1)
				if arg1 > 0 and self:GetZoom() < 5 then
					self:SetZoom(self:GetZoom() + 1)
				elseif arg1 < 0 and self:GetZoom() > 0 then
					self:SetZoom(self:GetZoom() - 1)
				end
			end

			-- Set the minimap zoom option
			local function SetMiniZoom()
				if LeaPlusLC["MinimapMouseZoom"] == "On" then
					MinimapZoomIn:Hide()
					MinimapZoomOut:Hide()
					Minimap:EnableMouseWheel(true)
					Minimap:SetScript("OnMouseWheel", MiniZoom);
				else
					MinimapZoomIn:Show()
					MinimapZoomOut:Show()
					Minimap:EnableMouseWheel(false)
					Minimap:SetScript("OnMouseWheel", nil);
				end
			end

			-- Update the zoom setting when checkbox is clicked
			LeaPlusCB["MinimapMouseZoom"]:HookScript("OnClick", SetMiniZoom);
	
			-- Set minimap zoom on startup
			SetMiniZoom();

			----------------------------------------------------------------------
			-- Minimap scale
			----------------------------------------------------------------------

			-- Update minimap when slider control changes
			local function SetMiniScale()
				MinimapCluster:SetScale(LeaPlusLC["MinimapScale"])
				-- Set slider formatted text
				LeaPlusCB["MinimapScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["MinimapScale"] * 100)
			end

			LeaPlusCB["MinimapScale"]:HookScript("OnValueChanged", SetMiniScale)

			----------------------------------------------------------------------
			-- Buttons
			----------------------------------------------------------------------

			-- Help button tooltip
			SideMinimap.h.tiptext = L["This panel will close automatically if you enter combat."]

			-- Back button handler
			SideMinimap.b:SetScript("OnClick", function() 
				SideMinimap:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show();
				return
			end) 

			-- Reset button handler
			SideMinimap.r:SetScript("OnClick", function()
				LeaPlusLC["MergeTrackBtn"] = "Off"; SetMiniMerge();
				LeaPlusLC["HideMinimapZone"] = "Off"; SetMiniZoneText(); ShowTextAndTip();
				LeaPlusLC["HideMinimapTime"] = "Off"; SetMiniClock();
				LeaPlusLC["MinimapMouseZoom"] = "Off"; SetMiniZoom();
				LeaPlusLC["MinimapScale"] = 1.00; SetMiniScale();
				SideMinimap:Hide(); SideMinimap:Show();
			end)

			-- Configuration button handler
			LeaPlusCB["ModMinimapBtn"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaPlusLC["MergeTrackBtn"] = "On"; SetMiniMerge();
						LeaPlusLC["HideMinimapZone"] = "On"; SetMiniZoneText(); ShowTextAndTip();
						LeaPlusLC["HideMinimapTime"] = "Off"; SetMiniClock();
						LeaPlusLC["MinimapMouseZoom"] = "Off"; SetMiniZoom();
						LeaPlusLC["MinimapScale"] = 1.30; SetMiniScale();
					else
						-- Show configuration panel
						SideMinimap:Show();
						LeaPlusLC:HideFrames();
					end
				end
			end)

			-- Set minimap scale at startup
			SetMiniScale();

		end

		----------------------------------------------------------------------
		--	Quest text size
		----------------------------------------------------------------------

		if LeaPlusLC["QuestFontChange"] == "On" then

			-- Create configuration panel
			local QuestTextPanel = LeaPlusLC:CreatePanel("Quest Text", "QuestTextPanel")

			LeaPlusLC:MakeTx(QuestTextPanel, "Text size", 16, -72)
			LeaPlusLC:MakeSL(QuestTextPanel, "LeaPlusQuestFontSize", "", 10, 36, 1, 16, -92, "%.0f")

			-- Function to update the font size
			local function QuestSizeUpdate()
				QuestTitleFont:SetFont(QuestFont:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"] + 3, nil)
				QuestFont:SetFont(QuestFontNormalSmall:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"] + 1, nil)
				QuestFontNormalSmall:SetFont(QuestFontNormalSmall:GetFont(), LeaPlusLC["LeaPlusQuestFontSize"], nil)
			end

			-- Set text size when slider changes and on startup
			LeaPlusCB["LeaPlusQuestFontSize"]:HookScript("OnValueChanged", QuestSizeUpdate)
			QuestSizeUpdate()

			-- Help button hidden
			QuestTextPanel.h:Hide()

			-- Back button handler
			QuestTextPanel.b:SetScript("OnClick", function() 
				QuestTextPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page4"]:Show()
				return
			end)

			-- Reset button handler
			QuestTextPanel.r:SetScript("OnClick", function()

				-- Reset slider
				LeaPlusLC["LeaPlusQuestFontSize"] = 18
				QuestSizeUpdate()

				-- Refresh side panel
				QuestTextPanel:Hide(); QuestTextPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["QuestTextBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["LeaPlusQuestFontSize"] = 18
					QuestSizeUpdate()
				else
					QuestTextPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Resize mail text
		----------------------------------------------------------------------

		if LeaPlusLC["MailFontChange"] == "On" then

			-- Create configuration panel
			local MailTextPanel = LeaPlusLC:CreatePanel("Mail Text", "MailTextPanel")

			LeaPlusLC:MakeTx(MailTextPanel, "Text size", 16, -72)
			LeaPlusLC:MakeSL(MailTextPanel, "LeaPlusMailFontSize", "", 10, 36, 1, 16, -92, "%.0f")

			-- Function to set the text size
			local function MailSizeUpdate()
				local MailFont = QuestFont:GetFont();
				OpenMailBodyText:SetFont(MailFont, LeaPlusLC["LeaPlusMailFontSize"])
				SendMailBodyEditBox:SetFont(MailFont, LeaPlusLC["LeaPlusMailFontSize"])
			end

			-- Set text size after changing slider and on startup
			LeaPlusCB["LeaPlusMailFontSize"]:HookScript("OnValueChanged", MailSizeUpdate)
			MailSizeUpdate()

			-- Help button hidden
			MailTextPanel.h:Hide()

			-- Back button handler
			MailTextPanel.b:SetScript("OnClick", function() 
				MailTextPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page4"]:Show()
				return
			end)

			-- Reset button handler
			MailTextPanel.r:SetScript("OnClick", function()

				-- Reset slider
				LeaPlusLC["LeaPlusMailFontSize"] = 22

				-- Refresh side panel
				MailTextPanel:Hide(); MailTextPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["MailTextBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["LeaPlusMailFontSize"] = 22
					MailSizeUpdate()
				else
					MailTextPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

		end

		----------------------------------------------------------------------
		--	Show durability status
		----------------------------------------------------------------------

		if LeaPlusLC["DurabilityStatus"] == "On" then

			-- Create durability button
			local cButton = CreateFrame("BUTTON", nil, PaperDollFrame)
			cButton:ClearAllPoints()
			cButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -2, -1)
			cButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
			cButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
			cButton:SetSize(32, 32)

			-- Create durability tables
			local Slots = {"HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "MainHandSlot", "SecondaryHandSlot"}
			local SlotsFriendly = {INVTYPE_HEAD, INVTYPE_SHOULDER, INVTYPE_CHEST, INVTYPE_WRIST, INVTYPE_HAND, INVTYPE_WAIST, INVTYPE_LEGS, INVTYPE_FEET, INVTYPE_WEAPONMAINHAND, INVTYPE_WEAPONOFFHAND}

			-- Show durability status in tooltip or status line (tip or status)
			local function ShowDuraStats(where)

				local duravaltotal, duramaxtotal, durapercent = 0, 0, 0
				local valcol, id, duraval, duramax

				if where == "tip" then
					-- Creare layout
					_G["GameTooltipTextLeft1"]:SetText("|cffffffff"); _G["GameTooltipTextRight1"]:SetText("|cffffffff")
					_G["GameTooltipTextLeft2"]:SetText("|cffffffff"); _G["GameTooltipTextRight2"]:SetText("|cffffffff")
					_G["GameTooltipTextLeft3"]:SetText("|cffffffff"); _G["GameTooltipTextRight3"]:SetText("|cffffffff")
					GameTooltip:AddLine("|cffffffff")
					GameTooltip:AddLine("|cffffffff")
					GameTooltip:AddLine("|cffffffff")
				end

				local validItems = false

				-- Traverse equipment slots
				for k, slotName in ipairs(Slots) do
					if GetInventorySlotInfo(slotName) then
						id = GetInventorySlotInfo(slotName)
						duraval, duramax = GetInventoryItemDurability(id)
						if duraval ~= nil then

							-- At least one item has durability stat
							validItems = true

							-- Add to tooltip
							if where == "tip" then
								durapercent = tonumber(format("%.0f", duraval / duramax * 100))
								valcol = (durapercent >= 80 and "|cff00FF00") or (durapercent >= 60 and "|cff99FF00") or (durapercent >= 40 and "|cffFFFF00") or (durapercent >= 20 and "|cffFF9900") or (durapercent >= 0 and "|cffFF2000") or ("|cffFFFFFF")
								_G["GameTooltipTextLeft1"]:SetText(L["Durability"])
								_G["GameTooltipTextLeft2"]:SetText(_G["GameTooltipTextLeft2"]:GetText() .. SlotsFriendly[k] .. "|n")
								_G["GameTooltipTextRight2"]:SetText(_G["GameTooltipTextRight2"]:GetText() ..  valcol .. durapercent .. "%" .. "|n")
							end

							duravaltotal = duravaltotal + duraval
							duramaxtotal = duramaxtotal + duramax
						end
					end
				end
				if duravaltotal > 0 and duramaxtotal > 0 then
					durapercent = duravaltotal / duramaxtotal * 100
				else
					durapercent = 0
				end

				if where == "tip" then

					if validItems == true then
						-- Show overall durability in the tooltip
						if durapercent >= 80 then valcol = "|cff00FF00"	elseif durapercent >= 60 then valcol = "|cff99FF00"	elseif durapercent >= 40 then valcol = "|cffFFFF00"	elseif durapercent >= 20 then valcol = "|cffFF9900"	elseif durapercent >= 0 then valcol = "|cffFF2000" else return end
						_G["GameTooltipTextLeft3"]:SetText(L["Overall"] .. " " .. valcol)
						_G["GameTooltipTextRight3"]:SetText(valcol .. string.format("%.0f", durapercent) .. "%")

						-- Show lines of the tooltip
						GameTooltipTextLeft1:Show(); GameTooltipTextRight1:Show()
						GameTooltipTextLeft2:Show(); GameTooltipTextRight2:Show()
						GameTooltipTextLeft3:Show(); GameTooltipTextRight3:Show()
						GameTooltipTextRight2:SetJustifyH"RIGHT";
						GameTooltipTextRight3:SetJustifyH"RIGHT";
						GameTooltip:Show()
					else
						-- No items have durability stat
						GameTooltip:ClearLines()
						GameTooltip:AddLine("" .. L["Durability"],1.0, 0.85, 0.0)
						GameTooltip:AddLine("" .. L["No items with durability equipped."], 1, 1, 1)
						GameTooltip:Show()
					end

				elseif where == "status" then
					if validItems == true then
						-- Show simple status line instead
						if tonumber(durapercent) >= 0 then -- Ensure character has some durability items equipped
							LeaPlusLC:Print(L["You have"] .. " " .. string.format("%.0f", durapercent) .. "%" .. " " .. L["durability"] .. "。")
						end
					end

				end
			end

			-- Hover over the durability button to show the durability tooltip
			cButton:SetScript("OnEnter", function()
				GameTooltip:SetOwner(cButton, "ANCHOR_RIGHT");
				ShowDuraStats("tip");
			end)
			cButton:SetScript("OnLeave", GameTooltip_Hide)

			-- Create frame to watch events
			local DeathDura = CreateFrame("FRAME")
			DeathDura:RegisterEvent("PLAYER_DEAD")
			DeathDura:SetScript("OnEvent", function(self, event)
				ShowDuraStats("status")
				DeathDura:UnregisterEvent("PLAYER_DEAD")
				C_Timer.After(2, function()
					DeathDura:RegisterEvent("PLAYER_DEAD")
				end)
			end)

			hooksecurefunc("AcceptResurrect", function()
				-- Player has ressed without releasing
				ShowDuraStats("status")
			end)
			
		end

		----------------------------------------------------------------------
		--	Zone text
		----------------------------------------------------------------------

		if LeaPlusLC["HideZoneText"] == "On" then
			ZoneTextFrame:SetScript("OnShow", ZoneTextFrame.Hide);
		end

		----------------------------------------------------------------------
		--	Subzone text
		----------------------------------------------------------------------

		if LeaPlusLC["HideSubzoneText"] == "On" then
			SubZoneTextFrame:SetScript("OnShow", SubZoneTextFrame.Hide);
		end

		----------------------------------------------------------------------
		--	Disable sticky chat
		----------------------------------------------------------------------

		if LeaPlusLC["NoStickyChat"] == "On" then
			-- These taint if set to anything other than nil
			ChatTypeInfo.WHISPER.sticky = nil
			ChatTypeInfo.BN_WHISPER.sticky = nil
			ChatTypeInfo.CHANNEL.sticky = nil
		end

		----------------------------------------------------------------------
		--	Hide stance bar
		----------------------------------------------------------------------

		if LeaPlusLC["NoClassBar"] == "On" then
			local stancebar = CreateFrame("FRAME")
			stancebar:Hide();
			UIPARENT_MANAGED_FRAME_POSITIONS["StanceBarFrame"] = nil;
			StanceBarFrame:SetParent(stancebar)
		end

		----------------------------------------------------------------------
		--	Remove raid restrictions
		----------------------------------------------------------------------

		if LeaPlusLC["NoRaidRestrictions"] == "On" then
			SetAllowLowLevelRaid(1);
		end

		----------------------------------------------------------------------
		--	Hide gryphons
		----------------------------------------------------------------------

		if LeaPlusLC["NoGryphons"] == "On" then
			MainMenuBarLeftEndCap:Hide();
			MainMenuBarRightEndCap:Hide();
		end

		----------------------------------------------------------------------
		--	Disable chat fade
		----------------------------------------------------------------------

		if LeaPlusLC["NoChatFade"] == "On" then
			-- Process normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i]:SetFading(false)
				end
			end
			-- Process temporary frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf]:SetFading(false)
				end
			end)
		end

		----------------------------------------------------------------------
		--	Use easy chat frame resizing
		----------------------------------------------------------------------

		if LeaPlusLC["UseEasyChatResizing"] == "On" then
			ChatFrame1Tab:HookScript("OnMouseDown", function(self,arg1)
				if arg1 == "LeftButton" then
					if select(8, GetChatWindowInfo(1)) then
						ChatFrame1:StartSizing("TOP")
					end
				end
			end)
			ChatFrame1Tab:SetScript("OnMouseUp", function(self,arg1)
				if arg1 == "LeftButton" then
					ChatFrame1:StopMovingOrSizing()
					FCF_SavePositionAndDimensions(ChatFrame1)
				end
			end)
		end

		----------------------------------------------------------------------
		--	Increase chat history
		----------------------------------------------------------------------

		if LeaPlusLC["MaxChatHstory"] == "On" then
			-- Process normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] and _G["ChatFrame" .. i]:GetMaxLines() ~= 4096 then
					_G["ChatFrame" .. i]:SetMaxLines(4096);
				end
			end
			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					if (_G[cf]:GetMaxLines() ~= 4096) then
						_G[cf]:SetMaxLines(4096);
					end
				end
			end)
		end

		----------------------------------------------------------------------
		--	Hide error text
		----------------------------------------------------------------------

		if LeaPlusLC["HideErrorFrameText"] == "On" then

			-- Create configuration panel
			local ErrorPanel = LeaPlusLC:CreatePanel("Error Text", "ErrorPanel")

			LeaPlusLC:MakeTx(ErrorPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(ErrorPanel, "ShowQuestUpdates", "Show quest updates", 16, -92, false, "If checked, quest updates will be shown in the error frame.")
			LeaPlusLC:MakeCB(ErrorPanel, "ShowImportantErrors", "Show important error text", 16, -112, false, "If checked, the following errors will be shown in the error frame:|n|n- Inventory full|n- Quest log full|n- Votekick alerts")

			-- Help button hidden
			ErrorPanel.h:Hide()

			-- Back button handler
			ErrorPanel.b:SetScript("OnClick", function() 
				ErrorPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page4"]:Show();
				return
			end)

			-- Reset button handler
			ErrorPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["ShowQuestUpdates"] = "On"
				LeaPlusLC["ShowImportantErrors"] = "On"

				-- Refresh side panel
				ErrorPanel:Hide(); ErrorPanel:Show();

			end)

			-- Show side panal when options panel button is clicked
			LeaPlusCB["HideErrorsBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["ShowQuestUpdates"] = "On"
					LeaPlusLC["ShowImportantErrors"] = "On"
				else
					ErrorPanel:Show();
					LeaPlusLC:HideFrames();
				end
			end);

			local OrigErrHandler = UIErrorsFrame:GetScript('OnEvent')

			--	Error message events
			UIErrorsFrame:SetScript('OnEvent', function (self, event, id, err, ...)

				-- Handle error messages
				if event == "UI_ERROR_MESSAGE" then
					if LeaPlusLC["ShowErrorsFlag"] == 1 then
						if LeaPlusLC["ShowImportantErrors"] == "On" then
							if err == ERR_INV_FULL or
								err == ERR_QUEST_LOG_FULL or
								err == ERR_RAID_GROUP_ONLY	or
								err == ERR_PARTY_LFG_BOOT_LIMIT or
								err == ERR_PARTY_LFG_BOOT_DUNGEON_COMPLETE or
								err == ERR_PARTY_LFG_BOOT_IN_COMBAT or
								err == ERR_PARTY_LFG_BOOT_IN_PROGRESS or
								err == ERR_PARTY_LFG_BOOT_LOOT_ROLLS or
								err == ERR_PARTY_LFG_TELEPORT_IN_COMBAT or
								err == ERR_PET_SPELL_DEAD or
								err == ERR_PLAYER_DEAD or
								err:find(format(ERR_PARTY_LFG_BOOT_NOT_ELIGIBLE_S, ".+")) then
									return OrigErrHandler(self, event, id, err, ...)
							end
						end
					else
						return OrigErrHandler(self, event, id, err, ...) 
					end
				end

				-- Handle information messages
				if event == 'UI_INFO_MESSAGE'  then
					if LeaPlusLC["ShowQuestUpdates"] == "On" then
						return OrigErrHandler(self, event, id, err, ...)
					end
				end

			end)

		end

		----------------------------------------------------------------------
		--	Minimap button
		----------------------------------------------------------------------

		if LeaPlusLC["ShowMinimapIcon"] == "On" then
	
			-- Create minimap button
			local minibtn = CreateFrame("Button", "LeaPlusMapBtn", Minimap)

			minibtn:SetFrameStrata("MEDIUM")
			minibtn:SetSize(31, 31)
			minibtn:RegisterForClicks("AnyUp")
			minibtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
			minibtn:SetMovable(true)

			local overlay = minibtn:CreateTexture(nil, "OVERLAY")
			overlay:SetSize(53, 53)
			overlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
			overlay:SetPoint("TOPLEFT")

			local background = minibtn:CreateTexture(nil, "BACKGROUND")
			background:SetSize(20, 20)
			background:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
			background:SetPoint("TOPLEFT", 7, -5)

			local icon = minibtn:CreateTexture(nil, "ARTWORK")
			icon:SetSize(20, 20)
			icon:SetTexture("Interface\\HELPFRAME\\ReportLagIcon-Movement.png")
			icon:SetPoint("CENTER", 0, 0)

			minibtn:HookScript("OnMouseDown", function() icon:SetSize(18, 18) end)
			minibtn:HookScript("OnMouseUp", function() icon:SetSize(20, 20)	end)

			-- Minimap buton tooltip
			minibtn:SetScript("OnEnter", function()
				GameTooltip:SetOwner(minibtn, "ANCHOR_NONE")
				local x, y = minibtn:GetCenter()
				local hhalf = (x > UIParent:GetWidth() * 2 / 3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
				local vhalf = (y > UIParent:GetHeight() / 2) and "TOP" or "BOTTOM"
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint(vhalf .. hhalf, minibtn, (vhalf == "TOP" and "BOTTOM" or "TOP") .. hhalf)
				GameTooltip:SetText("功能百寶箱", nil, nil, nil, nil, true)
				GameTooltip:Show()
			end)
			minibtn:SetScript("OnLeave", GameTooltip_Hide)

			local function UpdateMapBtn()
				local Xpoa, Ypoa = GetCursorPosition()
				local Xmin, Ymin = Minimap:GetLeft(), Minimap:GetBottom()
				Xpoa = Xmin - Xpoa / Minimap:GetEffectiveScale() + 70
				Ypoa = Ypoa / Minimap:GetEffectiveScale() - Ymin - 70
				LeaPlusLC["MinimapIconPos"] = math.deg(math.atan2(Ypoa, Xpoa))
				minibtn:ClearAllPoints()
				minibtn:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 52 - (80 * cos(LeaPlusLC["MinimapIconPos"])), (80 * sin(LeaPlusLC["MinimapIconPos"])) - 52)
			end

			-- Control movement
			minibtn:RegisterForDrag("LeftButton")
			minibtn:SetScript("OnDragStart", function()
				minibtn:StartMoving()
				minibtn:SetScript("OnUpdate", UpdateMapBtn)
			end)

			minibtn:SetScript("OnDragStop", function()
				minibtn:StopMovingOrSizing();
				minibtn:SetUserPlaced(false);
				minibtn:SetScript("OnUpdate", nil)
				UpdateMapBtn();
			end)

			-- Set position
			minibtn:ClearAllPoints();
			minibtn:SetPoint("TOPLEFT",Minimap,"TOPLEFT",52-(80*cos(LeaPlusLC["MinimapIconPos"])),(80*sin(LeaPlusLC["MinimapIconPos"]))-52)

			-- Control clicks
			minibtn:SetScript("OnClick", function(self,arg1)
				-- Prevent options panel from showing if Blizzard options panel is showing
				if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
				-- Left button down
				if arg1 == "LeftButton" then

					-- Control key modifier toggles target tracking
					if IsControlKeyDown() and not IsShiftKeyDown() then
						for i = 1, GetNumTrackingTypes() do
							local name, texture, active, category = GetTrackingInfo(i)
							if name == MINIMAP_TRACKING_TARGET then
								if active then
									SetTracking(i, false)
									ActionStatus_DisplayMessage(L["Target Tracking Disabled"], true);
								else
									SetTracking(i, true)
									ActionStatus_DisplayMessage(L["Target Tracking Enabled"], true);
								end
							end
						end
						return
					end

					-- Shift key modifier toggles the music
					if IsShiftKeyDown() and not IsControlKeyDown() then
						Sound_ToggleMusic();
						return
					end

					-- Shift key and control key toggles Zygor addon
					if IsShiftKeyDown() and IsControlKeyDown() then
						LeaPlusLC:ZygorToggle();
						return
					end

					-- No modifier key toggles the options panel
					if LeaPlusLC:IsPlusShowing() then
						LeaPlusLC:HideFrames()
						LeaPlusLC:HideConfigPanels()
					else
						LeaPlusLC:HideFrames()
						LeaPlusLC["PageF"]:Show()
					end
					LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
				end

				-- Right button down
				if arg1 == "RightButton" then

					-- Control key modifier toggles error messages
					if IsControlKeyDown() and not IsShiftKeyDown() then
						if LeaPlusDB["HideErrorFrameText"] == "On" then -- Checks global
							if LeaPlusLC["ShowErrorsFlag"] == 1 then 
								LeaPlusLC["ShowErrorsFlag"] = 0
								ActionStatus_DisplayMessage(L["Error frame text will be shown"], true);
							else
								LeaPlusLC["ShowErrorsFlag"] = 1
								ActionStatus_DisplayMessage(L["Error frame text will be hidden"], true);
							end
							return
						end
						return
					end

					-- Shift key modifier toggles coordinates
					if IsShiftKeyDown() and not IsControlKeyDown() then
						if LeaPlusLC["StaticCoordsEn"] == "On" then
							if LeaPlusLC["StaticCoords"] == "On" then
								LeaPlusLC["StaticCoords"] = "Off";
								ActionStatus_DisplayMessage(L["Coordinates Disabled"], true);
							else
								LeaPlusLC["StaticCoords"] = "On";
								SetMapToCurrentZone();
								ActionStatus_DisplayMessage(L["Coordinates Enabled"], true);
							end
							-- Run the coordinates refresh function
							LeaPlusLC:RefreshStaticCoords();
							-- Update side panel checkbox if it's showing
							if LeaPlusCB["StaticCoords"]:IsShown() then
								LeaPlusCB["StaticCoords"]:Hide();
								LeaPlusCB["StaticCoords"]:Show();
							end
						end
						return
					end

					-- Shift key and control key toggles maximised window mode
					if IsShiftKeyDown() and IsControlKeyDown() then

						if GetCVar("gxWindow") == "1" then
							if LeaPlusLC:PlayerInCombat() then
								return
							else
								SetCVar("gxMaximize", tostring(1 - GetCVar("gxMaximize")));
								RestartGx();
							end
						end
						return
					
					end

					-- No modifier key toggles the options panel
					if LeaPlusLC:IsPlusShowing() then
						LeaPlusLC:HideFrames()
						LeaPlusLC:HideConfigPanels()
					else
						LeaPlusLC:HideFrames()
						LeaPlusLC["PageF"]:Show()
					end
					LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()

				end

				-- Middle button modifier
				if arg1 == "MiddleButton" then
					-- Nothing (yet)
				end
			end)

		end

		-- Release memory
		LeaPlusLC.Isolated = nil

	end

----------------------------------------------------------------------
--	L40: Variable
----------------------------------------------------------------------

	function LeaPlusLC:Variable()

		----------------------------------------------------------------------
		-- Manage effects
		----------------------------------------------------------------------

		if LeaPlusLC["NoShaders"] == "On" then

			-- Function to set effects
			local function SetEffects()
				if LeaPlusLC["NoEffectsGlow"] == "On" then
					SetCVar("ffxGlow", "0")
				else
					SetCVar("ffxGlow", "1")
				end
				if LeaPlusLC["NoEffectsDeath"] == "On" then
					SetCVar("ffxDeath", "0")
				else
					SetCVar("ffxDeath", "1")
				end
				if LeaPlusLC["NoEffectsNether"] == "On" then
					SetCVar("ffxNether", "0")
				else
					SetCVar("ffxNether", "1")
				end
			end

			-- Create configuration panel
			local EffectsPanel = LeaPlusLC:CreatePanel("Effects", "EffectsPanel")

			LeaPlusLC:MakeTx(EffectsPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(EffectsPanel, "NoEffectsGlow", "Disable the screen glow", 16, -92, false, "If checked, the screen glow will be disabled.")
			LeaPlusLC:MakeCB(EffectsPanel, "NoEffectsDeath", "Disable the grey screen of death", 16, -112, false, "If checked, the grey screen of death will be disabled.")
			LeaPlusLC:MakeCB(EffectsPanel, "NoEffectsNether", "Disable the netherworld effect", 16, -132, false, "If checked, the netherworld effect will be disabled.")

			-- Help button hidden
			EffectsPanel.h:Hide()

			-- Back button handler
			EffectsPanel.b:SetScript("OnClick", function() 
				EffectsPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page7"]:Show()
				return
			end)

			-- Reset button handler
			EffectsPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["NoEffectsGlow"] = "On"
				LeaPlusLC["NoEffectsDeath"] = "On"
				LeaPlusLC["NoEffectsNether"] = "On"

				-- Refresh the settings and configuration panel
				SetEffects()
				EffectsPanel:Hide(); EffectsPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["NoShadersBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["NoEffectsGlow"] = "On"
					LeaPlusLC["NoEffectsDeath"] = "On"
					LeaPlusLC["NoEffectsNether"] = "On"
					SetEffects()
				else
					EffectsPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			-- Run function when options are clicked and on startup
			LeaPlusCB["NoEffectsGlow"]:HookScript("OnClick", SetEffects)
			LeaPlusCB["NoEffectsDeath"]:HookScript("OnClick", SetEffects)
			LeaPlusCB["NoEffectsNether"]:HookScript("OnClick", SetEffects)
			SetEffects()

		end

		----------------------------------------------------------------------
		--	Max camera zoom
		----------------------------------------------------------------------

		if LeaPlusLC["MaxCameraZoom"] == "On" then

			-- Set camera zoom setting
			SetCVar("cameraDistanceMaxZoomFactor", 2.6)

		end

		----------------------------------------------------------------------
		-- Auction House Extras
		----------------------------------------------------------------------

		if LeaPlusLC["AhExtras"] == "On" then

			local function AuctionFunc()

				-- Set default auction duration and price type values to saved settings or default settings
				AuctionFrameAuctions.duration = LeaPlusDB["AHDuration"] or 3
				AuctionFrameAuctions.priceType = LeaPlusDB["AHPriceType"] or 2

				-- Functions
				local function CreateAuctionCB(name, anchor, x, y, text)
					LeaPlusCB[name] = CreateFrame("CheckButton", nil, AuctionFrameAuctions, "OptionsCheckButtonTemplate")
					LeaPlusCB[name]:SetFrameStrata("HIGH")
					LeaPlusCB[name]:SetSize(20, 20)
					LeaPlusCB[name]:SetPoint(anchor, x, y)
					LeaPlusCB[name].f = LeaPlusCB[name]:CreateFontString(nil, 'OVERLAY', "GameFontNormal")
					LeaPlusCB[name].f:SetPoint("LEFT", 20, 0)
					LeaPlusCB[name].f:SetText(L[text])
					LeaPlusCB[name].f:Show();
					LeaPlusCB[name]:SetScript('OnClick', function()
						if LeaPlusCB[name]:GetChecked() then
							LeaPlusLC[name] = "On"
						else
							LeaPlusLC[name] = "Off"
						end
					end)
					LeaPlusCB[name]:SetScript('OnShow', function(self)
						if LeaPlusLC[name] == "On" then
							self:SetChecked(true)
						else
							self:SetChecked(false)
						end
					end)
				end

				-- Show the correct fields in the AH frame and match prices
				local function SetupAh()
					if LeaPlusLC["AhBuyoutOnly"] == "On" then
						-- Hide the start price
						StartPrice:SetAlpha(0);
						-- Set start price to buyout price 
						StartPriceGold:SetText(BuyoutPriceGold:GetText());
						StartPriceSilver:SetText(BuyoutPriceSilver:GetText());
						StartPriceCopper:SetText(BuyoutPriceCopper:GetText());
					else
						-- Show the start price
						StartPrice:SetAlpha(1);
					end
					-- If gold only is on, set copper and silver to 99
					if LeaPlusLC["AhGoldOnly"] == "On" then
						StartPriceCopper:SetText("99"); StartPriceCopper:Disable();
						StartPriceSilver:SetText("99"); StartPriceSilver:Disable();
						BuyoutPriceCopper:SetText("99"); BuyoutPriceCopper:Disable();
						BuyoutPriceSilver:SetText("99"); BuyoutPriceSilver:Disable();
					else
						StartPriceCopper:Enable();
						StartPriceSilver:Enable();
						BuyoutPriceCopper:Enable();
						BuyoutPriceSilver:Enable();
					end
					-- Validate the auction (mainly for the create auction button status)
					AuctionsFrameAuctions_ValidateAuction();
				end

				-- Create checkboxes
				CreateAuctionCB("AhBuyoutOnly", "BOTTOMLEFT", 200, 16, "Buyout Only")
				CreateAuctionCB("AhGoldOnly", "BOTTOMLEFT", 320, 16, "Gold Only")

				-- Reposition Gold Only checkbox so it does not overlap Buyout Only checkbox label
				LeaPlusCB["AhGoldOnly"]:ClearAllPoints()
				LeaPlusCB["AhGoldOnly"]:SetPoint("LEFT", LeaPlusCB["AhBuyoutOnly"].f, "RIGHT", 20, 0)

				-- Set click boundaries
				LeaPlusCB["AhBuyoutOnly"]:SetHitRectInsets(0, -LeaPlusCB["AhBuyoutOnly"].f:GetStringWidth() + 6, 0, 0);
				LeaPlusCB["AhGoldOnly"]:SetHitRectInsets(0, -LeaPlusCB["AhGoldOnly"].f:GetStringWidth() + 6, 0, 0);

				LeaPlusCB["AhBuyoutOnly"]:HookScript('OnClick', SetupAh);
				LeaPlusCB["AhBuyoutOnly"]:HookScript('OnShow', SetupAh);
	
				AuctionFrameAuctions:HookScript("OnShow", SetupAh)
				BuyoutPriceGold:HookScript("OnTextChanged", SetupAh)
				BuyoutPriceSilver:HookScript("OnTextChanged", SetupAh)
				BuyoutPriceCopper:HookScript("OnTextChanged", SetupAh)
				StartPriceGold:HookScript("OnTextChanged", SetupAh)
				StartPriceSilver:HookScript("OnTextChanged", SetupAh)
				StartPriceCopper:HookScript("OnTextChanged", SetupAh)
	
				-- Lock the create auction button if buyout gold box is empty (when using buyout only and gold only)
				AuctionsCreateAuctionButton:HookScript("OnEnable", function()
					if LeaPlusLC["AhGoldOnly"] == "On" and LeaPlusLC["AhBuyoutOnly"] == "On" then
						if BuyoutPriceGold:GetText() == "" then
							AuctionsCreateAuctionButton:Disable();
						end
					end
				end)
				
				-- Clear copper and silver prices if gold only box is unchecked
				LeaPlusCB["AhGoldOnly"]:HookScript('OnClick', function()
					if LeaPlusCB["AhGoldOnly"]:GetChecked() == false then
						BuyoutPriceCopper:SetText("")
						BuyoutPriceSilver:SetText("")
						StartPriceCopper:SetText("")
						StartPriceSilver:SetText("")
					end
					SetupAh();
				end)

				-- Create find button
				AuctionsItemText:Hide()
				LeaPlusLC:CreateButton("FindAuctionButton", AuctionsStackSizeMaxButton, "Find Item", "CENTER", 0, 74, 0, 21, false, "")
				LeaPlusCB["FindAuctionButton"]:SetParent(AuctionFrameAuctions)

				-- Show find button when the auctions tab is shown
				AuctionFrameAuctions:HookScript("OnShow", function() 
					LeaPlusCB["FindAuctionButton"]:SetEnabled(GetAuctionSellItemInfo() and true or false)
				end)

				-- Show find button when a new item is added
				AuctionsItemButton:HookScript("OnEvent", function(self, event)
					if event == "NEW_AUCTION_UPDATE" then
						LeaPlusCB["FindAuctionButton"]:SetEnabled(GetAuctionSellItemInfo() and true or false)
					end
				end)

				LeaPlusCB["FindAuctionButton"]:SetScript("OnClick", function()
					if GetAuctionSellItemInfo() then
						if BrowseWowTokenResults:IsShown() then
							-- Stop if Game Time filter is currently shown
							AuctionFrameTab1:Click()
							LeaPlusLC:Print("To use the Find button, you need to deselect the Game Time filter.")
						else
							-- Otherwise, search for the required item
							local name = GetAuctionSellItemInfo()
							BrowseName:SetText(name)
							ExactMatchCheckButton:SetChecked(true) -- Necessary for scrolling through results pages with exact match
							QueryAuctionItems(name, 0, 0, 0, 0, 0, false, true, 0)
							AuctionFrameTab1:Click()
						end
					end
				end)

				-- Clear the cursor and reset editboxes when a new item replaces an existing one
				hooksecurefunc("AuctionsFrameAuctions_ValidateAuction", function()
					if GetAuctionSellItemInfo() then
						-- Return anything you might be holding
						ClearCursor();
						-- Set copper and silver prices to 99 if gold mode is on
						if LeaPlusLC["AhGoldOnly"] == "On" then
							StartPriceCopper:SetText("99")
							StartPriceSilver:SetText("99")
							BuyoutPriceCopper:SetText("99")
							BuyoutPriceSilver:SetText("99")
						end
					end
				end)
      
				-- Clear gold editbox after an auction has been created (to force user to enter something)
				AuctionsCreateAuctionButton:HookScript("OnClick", function()
					StartPriceGold:SetText("")
					BuyoutPriceGold:SetText("")
				end)

				-- Set tab key actions (if different from defaults)
				StartPriceGold:HookScript("OnTabPressed", function()
					if not IsShiftKeyDown() then
						if LeaPlusLC["AhBuyoutOnly"] == "Off" and LeaPlusLC["AhGoldOnly"] == "On" then
							BuyoutPriceGold:SetFocus()
						end
					end
				end)

				BuyoutPriceGold:HookScript("OnTabPressed", function()
					if IsShiftKeyDown() then
						if LeaPlusLC["AhBuyoutOnly"] == "Off" and LeaPlusLC["AhGoldOnly"] == "On" then
							StartPriceGold:SetFocus()
						end
					end
				end)
			end

			-- Run function when Blizzard addon is loaded
			if IsAddOnLoaded("Blizzard_AuctionUI") then
				AuctionFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_AuctionUI" then
						AuctionFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

		end

		----------------------------------------------------------------------
		-- Enhance world map
		----------------------------------------------------------------------

		if LeaPlusLC["ShowMapMod"] == "On" then

			----------------------------------------------------------------------
			-- Cursor coordinates
			----------------------------------------------------------------------

			-- Create cursor coordinates frame
			local Cmap = CreateFrame("FRAME", nil, WorldMapFrame.BorderFrame)
			Cmap:SetWidth(38);	Cmap:SetHeight(16);
			Cmap:SetPoint("TOPRIGHT", -230, -4)

			Cmap.x = Cmap:CreateFontString(nil, "ARTWORK", "GameFontNormal") 
			Cmap.x:SetAllPoints(); Cmap.x:SetJustifyH"LEFT";

			Cmap.y = Cmap:CreateFontString(nil, "ARTWORK", "GameFontNormal") 
			Cmap.y:SetPoint("LEFT", Cmap.x, "RIGHT", 4, 0);
			Cmap.y:SetJustifyH"LEFT";

			-- Initialise variables
			local vmapx, vmapy = 0, 0
			local mtimer = 0

			-- Cursor coordinates update function
			local function UpdateCursorCoords(self, elapsed)

				mtimer = mtimer + elapsed;

				while (mtimer > 0.1) do

					-- Show cursor coordinates
					local scale = WorldMapDetailFrame:GetEffectiveScale()
					local width = WorldMapDetailFrame:GetWidth()
					local height = WorldMapDetailFrame:GetHeight()
					local cenx, ceny = WorldMapDetailFrame:GetCenter()
					local x, y = GetCursorPosition()
					local vmapx = (x / scale - (cenx - (width/2))) / width
					local vmapy = (ceny + (height/2) - y / scale) / height		

					if (vmapx >= 0  and vmapy >= 0 and vmapx <=1 and vmapy <=1) then
						Cmap.x:SetFormattedText("%0.1f", (floor(vmapx * 1000 + 0.5)) / 10)
						Cmap.y:SetFormattedText("%0.1f", (floor(vmapy * 1000 + 0.5)) / 10)
					else
						Cmap.x:SetText("0.0")
						Cmap.y:SetText("0.0")
					end

					mtimer = 0;

				end

			end

			Cmap:SetScript("OnUpdate", UpdateCursorCoords)

			----------------------------------------------------------------------
			-- Reveal map data
			----------------------------------------------------------------------

			local LeaPlusMapData = {

				-- Eastern Kingdoms
				["Arathi"] = {"CirecleofOuterBinding:215:188:332:273", "CircleofWestBinding:220:287:85:24", "NorthfoldManor:227:268:132:105", "Bouldergor:249:278:171:123", "StromgardeKeep:284:306:21:269", "FaldirsCove:273:268:77:400", "CircleofInnerBinding:228:227:201:312", "ThandolSpan:237:252:261:416", "BoulderfistHall:252:258:327:367", "RefugePoint:196:270:293:145", "WitherbarkVillage:260:220:476:359", "GoShekFarm:306:248:430:249", "DabyriesFarmstead:210:227:404:144", "CircleofEastBinding:183:238:506:126", "Hammerfall:270:271:581:118", "GalensFall:212:305:0:144"},
				["Badlands"] = {"AgmondsEnd:342:353:230:315", "AngorFortress:285:223:230:68", "ApocryphansRest:252:353:0:66", "CampBoff:274:448:407:220", "CampCagg:339:347:0:281", "CampKosh:236:260:504:19", "DeathwingScar:328:313:175:178", "HammertoesDigsite:209:196:411:116", "LethlorRavine:469:613:533:55", "TheDustbowl:214:285:144:99", "Uldaman:266:210:336:0",},
				["BlastedLands"] = {"AltarofStorms:238:195:225:110", "DreadmaulHold:272:206:258:0", "DreadmaulPost:235:188:327:182", "NethergardeKeep:295:205:530:6", "NethergardeSupplyCamps:195:199:436:0", "RiseoftheDefiler:168:170:375:102", "SerpentsCoil:218:183:459:97", "Shattershore:240:270:578:91", "SunveilExcursion:233:266:386:374", "Surwich:199:191:333:474", "TheDarkPortal:370:298:368:179", "TheRedReaches:268:354:533:268", "TheTaintedForest:348:357:132:311", "TheTaintedScar:308:226:144:175",},
				["BlastedLands_terrain1"] = {"AltarofStorms:238:195:225:110", "DreadmaulHold:272:206:258:0", "DreadmaulPost:235:188:327:182", "NethergardeKeep:295:205:530:6", "NethergardeSupplyCamps:195:199:436:0", "RiseoftheDefiler:168:170:375:102", "SerpentsCoil:218:183:459:97", "Shattershore:240:270:578:91", "SunveilExcursion:233:266:386:374", "Surwich:199:191:333:474", "TheDarkPortal:370:298:368:179", "TheRedReaches:268:354:533:268", "TheTaintedForest:348:357:132:311", "TheTaintedScar:308:226:144:175",},
				["BurningSteppes"] = {"AltarofStorms:182:360:0:0", "BlackrockMountain:281:388:79:0", "BlackrockPass:298:410:419:258", "BlackrockStronghold:320:385:235:0", "Dracodar:362:431:0:237", "DreadmaulRock:274:263:568:151", "MorgansVigil:383:413:615:255", "PillarofAsh:274:413:253:255", "RuinsofThaurissan:324:354:421:0", "TerrorWingPath:350:341:646:7",},
				["Darkshore"] = {"AmethAran:326:145:294:330", "EyeoftheVortex:330:192:300:239", "Lordanel:277:281:391:54", "Nazjvel:244:201:207:467", "RuinsofAuberdine:203:194:280:182", "RuinsofMathystra:200:263:517:28", "ShatterspearVale:250:241:596:16", "ShatterspearWarcamp:245:147:565:0", "TheMastersGlaive:303:185:277:483", "WildbendRiver:314:193:280:378", "WitheringThicket:328:250:305:118",},
				["DeadwindPass"] = {"DeadmansCrossing:617:522:83:0", "Karazhan:513:358:92:310", "TheVice:350:449:433:208",},
				["DunMorogh"] = {"AmberstillRanch:249:183:595:225", "ColdridgePass:225:276:360:340", "ColdridgeValley:398:302:100:366", "FrostmaneFront:226:335:469:256", "FrostmaneHold:437:249:50:227", "Gnomeregan:409:318:0:27", "GolBolarQuarry:198:251:663:288", "HelmsBedLake:218:234:760:268", "IceFlowLake:236:358:263:0", "Ironforge:376:347:398:0", "IronforgeAirfield:308:335:630:0", "Kharanos:184:188:449:220", "NorthGateOutpost:237:366:765:43", "TheGrizzledDen:211:160:374:287", "TheShimmeringDeep:171:234:397:132", "TheTundridHills:174:249:579:306",},
				["Duskwood"] = {"AddlesStead:299:296:32:348", "BrightwoodGrove:279:399:497:112", "Darkshire:329:314:640:128", "ManorMistmantle:219:182:661:122", "RacenHill:205:157:96:292", "RavenHillCemetary:323:309:91:132", "TheDarkenedBank:931:235:71:26", "TheHushedBank:189:307:0:152", "TheRottingOrchard:291:263:539:368", "TheTranquilGardensCemetary:291:244:627:344", "TheTwilightGrove:320:388:314:101", "TheYorgenFarmstead:233:248:401:396", "VulGolOgreMound:268:282:228:355",},
				["EasternPlaguelands"] = {"Acherus:228:273:774:102", "BlackwoodLake:238:231:382:151", "CorinsCrossing:186:213:493:289", "CrownGuardTower:202:191:258:351", "Darrowshire:248:206:211:462", "EastwallTower:181:176:541:184", "LakeMereldar:266:241:462:427", "LightsHopeChapel:196:220:687:271", "LightsShieldTower:243:162:391:271", "Northdale:265:232:570:61", "NorthpassTower:250:192:401:69", "Plaguewood:328:253:144:40", "QuelLithienLodge:277:175:351:0", "RuinsOfTheScarletEnclave:264:373:738:295", "Stratholme:310:178:118:0", "Terrordale:258:320:0:10", "TheFungalVale:274:216:183:211", "TheInfectisScar:177:266:595:263", "TheMarrisStead:202:202:133:335", "TheNoxiousGlade:297:299:650:55", "ThePestilentScar:182:320:383:348", "TheUndercroft:280:211:56:457", "ThondorilRiver:262:526:0:100", "Tyrshand:214:254:651:414", "ZulMashar:286:176:528:0",},
				["Elwynn"] = {"BrackwellPumpkinPatch:287:216:532:424", "CrystalLake:220:207:417:327", "EastvaleLoggingCamp:294:243:703:292", "FargodeepMine:269:248:240:420", "Goldshire:276:231:247:294", "JerodsLanding:230:206:396:430", "NorthshireValley:295:296:355:138", "RidgepointTower:285:194:708:442", "StonecairnLake:340:272:552:186", "Stromwind:512:422:0:0", "TowerofAzora:270:241:529:287", "WestbrookGarrison:269:313:116:355",},
				["Ghostlands"] = {"AmaniPass:404:436:598:232", "BleedingZiggurat:256:256:184:238", "DawnstarSpire:427:256:575:0", "Deatholme:512:293:95:375", "ElrendarCrossing:512:256:326:0", "FarstriderEnclave:429:256:573:136", "GoldenmistVillage:512:512:44:0", "HowlingZiggurat:256:449:340:219", "IsleofTribulations:256:256:585:0", "SanctumoftheMoon:256:256:210:126", "SanctumoftheSun:256:512:448:150", "SuncrownVillage:512:256:460:0", "ThalassiaPass:256:262:364:406", "Tranquillien:256:512:365:2", "WindrunnerSpire:256:256:40:287", "WindrunnerVillage:256:512:60:117", "ZebNowa:512:431:466:237",},
				["HillsbradFoothills"] = {"AzurelodeMine:180:182:287:399", "ChillwindPoint:447:263:555:68", "CorrahnsDagger:135:160:426:224", "CrushridgeHold:134:124:463:101", "DalaranCrater:316:238:102:137", "DandredsFold:258:113:341:0", "DarrowHill:147:160:425:279", "DunGarok:269:258:542:410", "DurnholdeKeep:437:451:565:217", "GallowsCorner:155:147:451:140", "GavinsNaze:116:129:344:254", "GrowlessCave:171:136:359:191", "HillsbradFields:302:175:191:302", "LordamereInternmentCamp:250:167:194:216", "MistyShore:158:169:321:42", "NethanderSteed:204:244:502:373", "PurgationIsle:144:139:200:505", "RuinsOfAlterac:189:181:347:85", "SlaughterHollow:148:120:413:55", "SoferasNaze:148:146:484:166", "SouthpointTower:312:254:59:310", "Southshore:229:219:383:352", "Strahnbrad:275:193:505:44", "TarrenMill:165:203:494:226", "TheHeadland:105:148:390:255", "TheUplands:212:160:441:0",},
				["Hinterlands"] = {"AeriePeak:238:267:0:236", "Agolwatha:208:204:367:159", "JinthaAlor:287:289:487:334", "PlaguemistRavine:191:278:133:105", "QuelDanilLodge:241:211:220:181", "Seradane:303:311:475:5", "ShadraAlor:240:196:220:379", "Shaolwatha:281:261:565:208", "SkulkRock:176:235:490:195", "TheAltarofZul:225:196:357:343", "TheCreepingRuin:199:199:390:252", "TheOverlookCliffs:244:401:677:267", "ValorwindLake:199:212:286:269", "Zunwatha:226:225:152:284",},
				["LochModan"] = {"GrizzlepawRidge:273:230:245:324", "IronbandsExcavationSite:397:291:481:296", "MogroshStronghold:294:249:549:52", "NorthgatePass:319:289:16:0", "SilverStreamMine:225:252:221:0", "StonesplinterValley:273:294:177:345", "StronewroughtDam:333:200:339:0", "TheFarstriderLodge:349:292:570:209", "TheLoch:330:474:340:81", "Thelsamar:455:295:0:146", "ValleyofKings:310:345:0:311",},
				["Redridge"] = {"AlthersMill:228:247:350:139", "CampEverstill:189:193:445:286", "GalardellValley:428:463:574:0", "LakeEverstill:464:250:81:214", "LakeridgeHighway:392:352:148:316", "Lakeshire:410:256:0:110", "RedridgeCanyons:413:292:37:0", "RendersCamp:357:246:214:0", "RendersValley:427:291:451:377", "ShalewindCanyon:306:324:688:283", "StonewatchFalls:316:182:525:302", "StonewatchKeep:228:420:480:0", "ThreeCorners:323:406:0:256",},
				["RuinsofGilneas"] = {"GilneasPuzzle:1002:668:0:0",},
				["Gilneas"] = {"NorthgateWoods:282:298:482:14", "GilneasCity:282:263:483:210", "StormglenVillage:321:203:516:465", "HammondFarmstead:194:236:167:352", "HaywardFishery:177:219:293:449", "TempestsReach:350:345:652:290", "TheHeadlands:328:336:160:0", "Duskhaven:286:178:272:333", "NorthernHeadlands:267:314:387:0", "Keelharbor:280:342:298:95", "CrowleyOrchard:210:166:261:427", "EmberstoneMine:281:351:639:43", "Greymanemanor:244:241:141:202", "KorothsDen:222:268:393:386", "TheBlackwald:280:224:504:394",},
				["Gilneas_terrain1"] = {"NorthgateWoods:282:298:482:14", "GilneasCity:282:263:483:210", "StormglenVillage:321:203:516:465", "HammondFarmstead:194:236:167:352", "HaywardFishery:177:219:293:449", "TempestsReach:350:345:652:290", "TheHeadlands:328:336:160:0", "Duskhaven:286:178:272:333", "NorthernHeadlands:267:314:387:0", "Keelharbor:280:342:298:95", "CrowleyOrchard:210:166:261:427", "EmberstoneMine:281:351:639:43", "Greymanemanor:244:241:141:202", "KorothsDen:222:268:393:386", "TheBlackwald:280:224:504:394",},
				["Gilneas_terrain2"] = {"NorthgateWoods:282:298:482:14", "GilneasCity:282:263:483:210", "StormglenVillage:321:203:516:465", "HammondFarmstead:194:236:167:352", "HaywardFishery:177:219:293:449", "TempestsReach:350:345:652:290", "TheHeadlands:328:336:160:0", "Duskhaven:286:178:272:333", "NorthernHeadlands:267:314:387:0", "Keelharbor:280:342:298:95", "CrowleyOrchard:210:166:261:427", "EmberstoneMine:281:351:639:43", "Greymanemanor:244:241:141:202", "KorothsDen:222:268:393:386", "TheBlackwald:280:224:504:394",},
				["SearingGorge"] = {"BlackcharCave:375:307:0:361", "BlackrockMountain:304:244:243:424", "DustfireValley:392:355:588:0", "FirewatchRidge:365:393:0:75", "GrimsiltWorksite:441:266:531:241", "TannerCamp:571:308:413:360", "TheCauldron:481:360:232:171", "ThoriumPoint:429:301:255:38",},
				["Silverpine"] = {"Ambermill:283:243:509:250", "BerensPeril:318:263:505:405", "DeepElemMine:217:198:483:212", "FenrisIsle:352:302:581:15", "ForsakenHighCommand:361:175:445:0", "ForsakenRearGuard:186:238:369:0", "NorthTidesBeachhead:174:199:323:68", "NorthTidesRun:281:345:147:0", "OlsensFarthing:251:167:312:249", "ShadowfangKeep:179:165:337:337", "TheBattlefront:255:180:349:429", "TheDecrepitFields:176:152:471:156", "TheForsakenFront:152:189:433:327", "TheGreymaneWall:409:162:318:506", "TheSepulcher:218:200:341:157", "TheSkitteringDark:227:172:236:0", "ValgansField:162:172:461:77",},
				["StranglethornJungle"] = {"BalAlRuins:159:137:267:168", "BaliaMahRuins:239:205:397:243", "Bambala:190:176:566:164", "FortLivingston:230:170:398:375", "GromGolBaseCamp:167:179:298:228", "KalAiRuins:139:150:354:184", "KurzensCompound:244:238:499:0", "LakeNazferiti:240:228:413:95", "Mazthoril:350:259:488:364", "MizjahRuins:157:173:387:246", "MoshOggOgreMound:234:206:543:253", "NesingwarysExpedition:227:190:306:63", "RebelCamp:302:166:306:0", "RuinsOfZulKunda:228:265:158:0", "TheVileReef:236:224:140:208", "ZulGurub:376:560:626:0", "ZuuldalaRuins:324:263:9:22",},
				["Sunwell"] = {"SunsReachHarbor:512:416:252:252", "SunsReachSanctum:512:512:251:4",},
				["SwampOfSorrows"] = {"Bogpaddle:262:193:600:0", "IthariusCave:268:316:7:242", "MarshtideWatch:330:342:478:0", "MistyreedStrand:402:668:600:0", "MistyValley:268:285:0:80", "PoolOfTears:257:229:575:238", "Sorrowmurk:229:418:703:80", "SplinterspearJunction:238:343:194:236", "Stagalbog:347:303:540:360", "Stonard:357:308:297:258", "TheHarborage:266:284:161:79", "TheShiftingMire:292:360:331:24",},
				["TheCapeOfStranglethorn"] = {"BootyBay:225:255:289:341", "CrystalveinMine:271:204:528:73", "GurubashiArena:238:260:345:0", "HardwrenchHideaway:356:221:208:116", "JagueroIsle:240:264:471:404", "MistvaleValley:253:242:408:248", "NekmaniWellspring:246:221:292:213", "RuinsofAboraz:184:176:533:181", "RuinsofJubuwal:155:221:468:119", "TheSundering:244:209:452:0", "WildShore:236:276:340:392",},
				["Tirisfal"] = {"AgamandMills:285:260:324:90", "BalnirFarmstead:242:179:594:324", "BrightwaterLake:210:292:573:122", "Brill:199:182:480:252", "CalstonEstate:179:169:389:255", "ColdHearthManor:212:177:418:317", "CrusaderOutpost:175:210:686:232", "Deathknell:431:407:9:207", "GarrensHaunt:190:214:477:129", "NightmareVale:225:281:347:325", "RuinsofLorderon:390:267:423:359", "ScarletMonastery:262:262:740:47", "ScarletWatchPost:161:234:692:99", "SollidenFarmstead:286:225:201:192", "TheBulwark:293:338:709:330", "VenomwebVale:250:279:752:150",},
				["TwilightHighlands"] = {"Bloodgulch:215:157:416:205", "CrucibleOfCarnage:203:208:387:268", "Crushblow:182:195:370:447", "DragonmawPass:283:206:76:120", "DragonmawPort:251:207:631:245", "DunwaldRuins:197:218:395:367", "FirebeardsPatrol:215:181:499:265", "GlopgutsHollow:174:190:291:89", "GorshakWarCamp:194:170:543:220", "GrimBatol:230:276:83:223", "Highbank:220:227:697:403", "HighlandForest:239:232:482:330", "HumboldtConflaguration:143:141:344:89", "Kirthaven:308:267:482:0", "ObsidianForest:342:288:436:380", "RuinsOfDrakgor:206:182:296:0", "SlitheringCove:198:201:622:169", "TheBlackBreach:211:210:498:121", "TheGullet:175:180:269:179", "TheKrazzworks:226:232:654:0", "TheTwilightBreach:199:212:312:192", "TheTwilightCitadel:361:354:151:314", "TheTwilightGate:165:199:327:356", "Thundermar:238:229:374:93", "TwilightShore:260:202:610:345", "VermillionRedoubt:324:264:71:16", "VictoryPoint:177:159:302:306", "WeepingWound:214:190:358:0", "WyrmsBend:191:198:205:232",},
				["TwilightHighlands_terrain1"] = {"Bloodgulch:215:157:416:205", "CrucibleOfCarnage:203:208:387:268", "Crushblow:182:195:370:447", "DragonmawPass:283:206:76:120", "DragonmawPort:251:207:631:245", "DunwaldRuins:197:218:395:367", "FirebeardsPatrol:215:181:499:265", "GlopgutsHollow:174:190:291:89", "GorshakWarCamp:194:170:543:220", "GrimBatol:230:276:83:223", "Highbank:220:227:697:403", "HighlandForest:239:232:482:330", "HumboldtConflaguration:143:141:344:89", "Kirthaven:308:267:482:0", "ObsidianForest:342:288:436:380", "RuinsOfDrakgor:206:182:296:0", "SlitheringCove:198:201:622:169", "TheBlackBreach:211:210:498:121", "TheGullet:175:180:269:179", "TheKrazzworks:226:232:654:0", "TheTwilightBreach:199:212:312:192", "TheTwilightCitadel:361:354:151:314", "TheTwilightGate:165:199:327:356", "Thundermar:238:229:374:93", "TwilightShore:260:202:610:345", "VermillionRedoubt:324:264:71:16", "VictoryPoint:177:159:302:306", "WeepingWound:214:190:358:0", "WyrmsBend:191:198:205:232",},
				["WesternPlaguelands"] = {"Andorhal:464:325:96:343", "CaerDarrow:194:208:601:390", "DalsonsFarm:325:192:300:232", "DarrowmereLake:492:314:510:354", "FelstoneField:241:212:229:228", "GahrronsWithering:241:252:495:213", "Hearthglen:432:271:235:0", "NorthridgeLumberCamp:359:182:231:123", "RedpineDell:290:133:286:211", "SorrowHill:368:220:261:448", "TheBulwark:316:316:48:235", "TheWeepingCave:185:230:551:151", "TheWrithingHaunt:169:195:472:332", "ThondrorilRiver:311:436:533:0",},
				["Westfall"] = {"AlexstonFarmstead:346:222:167:263", "DemontsPlace:201:195:203:376", "FurlbrowsPumpkinFarm:197:213:394:0", "GoldCoastQuarry:235:306:199:79", "JangoloadMine:196:229:311:0", "Moonbrook:232:213:308:325", "SaldeansFarm:244:237:451:81", "SentinelHill:229:265:404:226", "TheDaggerHills:292:273:303:395", "TheDeadAcre:193:273:531:200", "TheDustPlains:317:261:480:378", "TheGapingChasm:184:217:294:168", "TheJansenStead:202:179:474:0", "TheMolsenFarm:202:224:348:118", "WestfallLighthouse:211:167:221:477",},
				["Wetlands"] = {"AngerfangEncampment:236:256:359:201", "BlackChannelMarsh:301:232:37:240", "BluegillMarsh:321:248:31:102", "DireforgeHills:329:228:506:34", "DunAlgaz:298:215:346:419", "DunModr:257:185:356:7", "GreenwardensGrove:250:269:460:102", "IronbeardsTomb:185:224:372:76", "MenethilHarbor:325:363:0:297", "MosshideFen:369:235:506:232", "RaptorRidge:256:245:599:123", "Satlspray:250:282:218:0", "SlabchiselsSurvey:300:316:532:352", "SundownMarsh:276:243:121:63", "ThelganRock:258:207:371:335", "WhelgarsExcavationSite:298:447:185:195",},

				-- Kalimdor
				["AhnQirajTheFallenKingdom"] = {"AQKingdom:887:668:115:0",},
				["Ashenvale"] = {"Astranaar:251:271:255:164", "BoughShadow:166:211:836:148", "FallenSkyLake:287:276:529:385", "FelfireHill:277:333:714:317", "LakeFalathim:184:232:112:148", "MaelstrasPost:246:361:188:0", "NightRun:221:257:595:253", "OrendilsRetreat:244:251:143:0", "RaynewoodRetreat:231:256:481:221", "Satyrnaar:235:236:696:154", "SilverwindRefuge:347:308:338:335", "TheHowlingVale:325:239:473:97", "TheRuinsofStardust:236:271:210:331", "TheShrineofAssenia:306:283:40:275", "TheZoramStrand:262:390:0:0", "ThistlefurVillage:314:241:255:78", "ThunderPeak:203:310:377:121", "WarsongLumberCamp:231:223:771:265",},
				["Aszhara"] = {"BearsHead:256:224:113:141", "BilgewaterHarbor:587:381:395:127", "BitterReaches:321:247:477:0", "BlackmawHold:260:267:204:53", "DarnassianBaseCamp:243:262:343:3", "GallywixPleasurePalace:250:230:70:222", "LakeMennar:210:232:245:377", "OrgimmarRearGate:352:274:22:344", "RavencrestMonument:295:267:476:401", "RuinsofArkkoran:219:193:575:121", "RuinsofEldarath:218:237:228:229", "StormCliffs:207:232:407:403", "TheSecretLab:184:213:353:396", "TheShatteredStrand:206:329:316:168", "TowerofEldara:306:337:684:22",},
				["AzuremystIsle"] = {"AmmenFord:256:256:515:279", "AmmenVale:475:512:527:104", "AzureWatch:256:256:383:249", "BristlelimbVillage:256:256:174:363", "Emberglade:256:256:488:24", "FairbridgeStrand:256:128:356:0", "GreezlesCamp:256:256:507:350", "MoongrazeWoods:256:256:449:183", "OdesyusLanding:256:256:352:378", "PodCluster:256:256:281:305", "PodWreckage:128:256:462:349", "SiltingShore:256:256:291:3", "SilvermystIsle:256:222:23:446", "StillpineHold:256:256:365:49", "TheExodar:512:512:74:85", "ValaarsBerth:256:256:176:303", "WrathscalePoint:256:247:220:421",},
				["Barrens"] = {"BoulderLodeMine:278:209:511:7", "DreadmistPeak:241:195:290:104", "FarWatchPost:207:332:555:129", "GroldomFarm:243:217:448:127", "MorshanRampart:261:216:258:6", "Ratchet:219:175:547:379", "TheCrossroads:233:193:362:275", "TheDryHills:283:270:116:57", "TheForgottenPools:446:256:100:208", "TheMerchantCoast:315:212:556:456", "TheSludgeFen:257:249:403:6", "TheStagnantOasis:336:289:344:379", "TheWailingCaverns:377:325:152:318", "ThornHill:239:231:481:254",},
				["BloodmystIsle"] = {"AmberwebPass:256:512:44:62", "Axxarien:256:256:297:136", "BlacksiltShore:512:242:177:426", "Bladewood:256:256:367:209", "BloodscaleIsle:239:256:763:256", "BloodWatch:256:256:437:258", "BristlelimbEnclave:256:256:546:410", "KesselsCrossing:485:141:517:527", "Middenvale:256:256:414:406", "Mystwood:256:185:309:483", "Nazzivian:256:256:250:404", "RagefeatherRidge:256:256:481:117", "RuinsofLorethAran:256:256:556:216", "TalonStand:256:256:657:78", "TelathionsCamp:128:128:180:216", "TheBloodcursedReef:256:256:729:54", "TheBloodwash:256:256:302:27", "TheCrimsonReach:256:256:555:87", "TheCryoCore:256:256:293:285", "TheFoulPool:256:256:221:136", "TheHiddenReef:256:256:205:39", "TheLostFold:256:198:503:470", "TheVectorCoil:512:430:43:238", "TheWarpPiston:256:256:451:29", "VeridianPoint:256:256:637:0", "VindicatorsRest:256:256:232:242", "WrathscaleLair:256:256:598:338", "WyrmscarIsland:256:256:613:82",},
				["Desolace"] = {"CenarionWildlands:312:285:415:156", "GelkisVillage:274:196:207:472", "KodoGraveyard:250:215:360:273", "MagramTerritory:289:244:613:170", "MannorocCoven:326:311:381:357", "NijelsPoint:231:257:573:0", "RanzjarIsle:161:141:210:0", "Sargeron:317:293:655:0", "ShadowbreakRavine:292:266:637:402", "ShadowpreyVillage:222:299:142:369", "ShokThokar:309:349:589:319", "SlitherbladeShore:338:342:208:24", "TethrisAran:274:145:399:0", "ThargadsCamp:212:186:275:376", "ThunderAxeFortress:220:205:440:49", "ValleyofSpears:321:275:170:196",},
				["Durotar"] = {"DrygulchRavine:236:196:415:60", "EchoIsles:330:255:429:413", "NorthwatchFoothold:162:157:399:440", "Orgrimmar:259:165:309:0", "RazorHill:224:227:431:157", "RazormaneGrounds:248:158:302:264", "SenjinVillage:192:184:457:406", "SkullRock:208:157:438:0", "SouthfuryWatershed:244:222:282:174", "ThunderRidge:220:218:295:48", "TiragardeKeep:210:200:462:298", "ValleyOfTrials:254:258:304:312",},
				["Dustwallow"] = {"AlcazIsland:206:200:656:21", "BlackhoofVillage:344:183:199:0", "BrackenwllVillage:384:249:133:59", "DirehornPost:279:301:358:169", "Mudsprocket:433:351:109:313", "ShadyRestInn:317:230:137:188", "TheramoreIsle:305:247:542:223", "TheWyrmbog:436:299:359:369", "WitchHill:270:353:428:0",},
				["Dustwallow_terrain1"] = {"AlcazIsland:206:200:656:21", "BlackhoofVillage:344:183:199:0", "BrackenwllVillage:384:249:133:59", "DirehornPost:279:301:358:169", "Mudsprocket:433:351:109:313", "ShadyRestInn:317:230:137:188", "TheramoreIsle:305:247:542:223", "TheWyrmbog:436:299:359:369", "WitchHill:270:353:428:0",},
				["EversongWoods"] = {"AzurebreezeCoast:256:256:669:228", "DuskwitherGrounds:256:256:605:253", "EastSanctum:256:256:460:373", "ElrendarFalls:128:256:580:399", "FairbreezeVilliage:256:256:386:386", "FarstriderRetreat:256:128:524:359", "GoldenboughPass:256:128:243:469", "LakeElrendar:128:197:584:471", "NorthSanctum:256:256:361:298", "RuinsofSilvermoon:256:256:307:136", "RunestoneFalithas:256:172:378:496", "RunestoneShandor:256:174:464:494", "SatherilsHaven:256:256:324:384", "SilvermoonCity:512:512:440:87", "StillwhisperPond:256:256:474:314", "SunsailAnchorage:256:128:231:404", "SunstriderIsle:512:512:195:5", "TheGoldenStrand:128:253:183:415", "TheLivingWood:128:248:511:420", "TheScortchedGrove:256:128:255:507", "ThuronsLivery:256:128:539:305", "TorWatha:256:353:648:315", "TranquilShore:256:256:215:298", "WestSanctum:128:256:292:319", "Zebwatha:128:193:554:475",},
				["Felwood"] = {"BloodvenomFalls:345:192:220:231", "DeadwoodVillage:173:163:410:505", "EmeraldSanctuary:274:212:394:382", "FelpawVillage:307:161:471:0", "IrontreeWoods:261:273:406:55", "JadefireGlen:229:210:288:458", "JadefireRun:263:199:303:9", "Jaedenar:319:176:234:317", "MorlosAran:187:176:476:484", "RuinsofConstellas:268:214:278:359", "ShatterScarVale:343:250:243:107", "TalonbranchGlade:209:226:531:57",},
				["Feralas"] = {"CampMojache:174:220:671:181", "DarkmistRuins:172:198:568:287", "DireMaul:265:284:485:101", "FeathermoonStronghold:217:192:362:237", "FeralScar:191:179:457:281", "GordunniOutpost:192:157:663:116", "GrimtotemCompund:159:218:607:170", "LowerWilds:207:209:756:191", "RuinsofFeathermoon:208:204:186:229", "RuinsofIsildien:206:237:467:354", "TheForgottenCoast:194:304:375:343", "TheTwinColossals:350:334:271:0", "WrithingDeep:232:206:652:298",},
				["Hyjal"] = {"ArchimondesVengeance:270:300:320:5", "AshenLake:282:418:6:78", "DarkwhisperGorge:320:471:682:128", "DireforgeHill:270:173:303:197", "GatesOfSothann:272:334:622:320", "Nordrassil:537:323:392:0", "SethriasRoost:277:232:139:436", "ShrineOfGoldrinn:291:321:116:17", "TheRegrowth:441:319:52:253", "TheScorchedPlain:365:264:411:216", "TheThroneOfFlame:419:290:318:378",},
				["Hyjal_terrain1"] = {"ArchimondesVengeance:270:300:320:5", "AshenLake:282:418:6:78", "DarkwhisperGorge:320:471:682:128", "DireforgeHill:270:173:303:197", "GatesOfSothann:272:334:622:320", "Nordrassil:537:323:392:0", "SethriasRoost:277:232:139:436", "ShrineOfGoldrinn:291:321:116:17", "TheRegrowth:441:319:52:253", "TheScorchedPlain:365:264:411:216", "TheThroneOfFlame:419:290:318:378",},
				["Moonglade"] = {"LakeEluneara:431:319:219:273", "Nighthaven:346:244:370:135", "ShrineofRemulos:271:296:209:91", "StormrageBarrowDens:275:346:542:210",},
				["Mulgore"] = {"BaeldunDigsite:218:192:226:220", "BloodhoofVillage:302:223:319:273", "PalemaneRock:172:205:248:321", "RavagedCaravan:187:165:435:224", "RedCloudMesa:446:264:286:401", "RedRocks:186:185:514:43", "StonetalonPass:237:184:201:0", "TheGoldenPlains:186:216:448:101", "TheRollingPlains:260:243:527:291", "TheVentureCoMine:208:300:530:138", "ThunderBluff:373:259:208:62", "ThunderhornWaterWell:201:167:333:202", "WildmaneWaterWell:190:172:331:0", "WindfuryRidge:222:202:400:0", "WinterhoofWaterWell:174:185:449:340",},
				["Silithus"] = {"CenarionHold:292:260:427:143", "HiveAshi:405:267:345:4", "HiveRegal:489:358:380:310", "HiveZora:542:367:0:206", "SouthwindVillage:309:243:550:181", "TheCrystalVale:329:246:126:0", "TheScarabWall:580:213:0:455", "TwilightBaseCamp:434:231:100:151", "ValorsRest:315:285:614:0",},
				["SouthernBarrens"] = {"BaelModan:269:211:398:457", "Battlescar:384:248:274:307", "ForwardCommand:216:172:423:251", "FrazzlecrazMotherload:242:195:269:436", "HonorsStand:315:170:201:0", "HuntersHill:218:178:300:64", "NorthwatchHold:280:279:548:147", "RazorfenKraul:214:140:273:528", "RuinsofTaurajo:285:171:244:286", "TheOvergrowth:355:226:289:117", "VendettaPoint:254:214:267:196",},
				["StonetalonMountains"] = {"BattlescarValley:290:297:220:189", "BoulderslideRavine:194:156:532:512", "CliffwalkerPost:241:192:366:95", "GreatwoodVale:322:220:602:448", "KromgarFortress:183:196:588:341", "Malakajin:211:131:618:537", "MirkfallonLake:244:247:417:143", "RuinsofEldrethar:221:235:367:411", "StonetalonPeak:305:244:265:0", "SunRockRetreat:222:222:353:285", "ThaldarahOverlook:210:189:252:121", "TheCharredVale:277:274:199:368", "UnearthedGrounds:265:206:654:369", "WebwinderHollow:164:258:479:401", "WebwinderPath:267:352:468:263", "WindshearCrag:374:287:533:179", "WindshearHold:176:189:516:289",},
				["Tanaris"] = {"AbyssalSands:255:194:297:148", "BrokenPillar:195:163:413:211", "CavernsofTime:213:173:507:238", "DunemaulCompound:231:177:305:257", "EastmoonRuins:173:163:380:341", "Gadgetzan:189:180:412:92", "GadgetzanBay:254:341:479:9", "LandsEndBeach:224:216:431:452", "LostRiggerCover:178:243:615:201", "SandsorrowWatch:214:149:293:99", "SouthbreakShore:274:186:437:289", "SouthmoonRuins:232:211:301:349", "TheGapingChasm:225:187:448:364", "TheNoxiousLair:179:190:258:211", "ThistleshrubValley:221:293:185:280", "ValleryoftheWatchers:269:190:255:431", "ZulFarrak:315:190:184:0",},
				["Teldrassil"] = {"BanethilHollow:175:235:374:221", "Darnassus:298:337:149:181", "GalardellValley:178:186:466:237", "GnarlpineHold:198:181:347:355", "LakeAlameth:289:202:422:310", "PoolsofArlithrien:140:210:345:243", "RutheranVillage:317:220:329:448", "Shadowglen:241:217:481:104", "StarbreezeVillage:187:196:544:217", "TheCleft:144:226:432:109", "TheOracleGlade:194:244:276:90", "WellspringLake:165:249:382:83",},
				["ThousandNeedles"] = {"DarkcloudPinnacle:317:252:169:116", "FreewindPost:436:271:276:186", "Highperch:246:380:0:134", "RazorfenDowns:361:314:298:0", "RustmaulDiveSite:234:203:527:465", "SouthseaHoldfast:246:256:756:412", "SplithoofHeights:431:410:571:49", "TheGreatLift:272:232:136:0", "TheShimmeringDeep:411:411:591:257", "TheTwilightWithering:374:339:347:329", "TwilightBulwark:358:418:125:241", "WestreachSummit:280:325:0:0",},
				["Uldum"] = {"AkhenetFields:164:185:471:277", "CradelOfTheAncient:202:169:341:402", "HallsOfOrigination:269:242:599:184", "KhartutsTomb:203:215:542:0", "LostCityOfTheTolVir:233:321:527:291", "Marat:160:193:406:174", "Nahom:237:194:583:162", "Neferset:209:254:407:384", "ObeliskOfTheMoon:400:224:110:0", "ObeliskOfTheStars:196:170:551:121", "ObeliskOfTheSun:269:203:340:282", "Orsis:249:243:264:136", "Ramkahen:228:227:411:67", "RuinsOfAhmtul:278:173:365:0", "RuinsOfAmmon:203:249:217:289", "Schnottzslanding:312:289:28:221", "TahretGrounds:150:159:545:193", "TempleofUldum:296:209:132:127", "TheCursedlanding:237:316:752:170", "TheGateofUnendingCycles:161:236:647:15", "TheTrailOfDevestation:206:204:657:349", "TheVortexPinnacle:213:195:656:473", "ThroneOfTheFourWinds:270:229:229:433", "VirnaalDam:151:144:479:215",},
				["Uldum_terrain1"] = {"AkhenetFields:164:185:471:277", "CradelOfTheAncient:202:169:341:402", "HallsOfOrigination:269:242:599:184", "KhartutsTomb:203:215:542:0", "LostCityOfTheTolVir:233:321:527:291", "Marat:160:193:406:174", "Nahom:237:194:583:162", "Neferset:209:254:407:384", "ObeliskOfTheMoon:400:224:110:0", "ObeliskOfTheStars:196:170:551:121", "ObeliskOfTheSun:269:203:340:282", "Orsis:249:243:264:136", "Ramkahen:228:227:411:67", "RuinsOfAhmtul:278:173:365:0", "RuinsOfAmmon:203:249:217:289", "Schnottzslanding:312:289:28:221", "TahretGrounds:150:159:545:193", "TempleofUldum:296:209:132:127", "TheCursedlanding:237:316:752:170", "TheGateofUnendingCycles:161:236:647:15", "TheTrailOfDevestation:206:204:657:349", "TheVortexPinnacle:213:195:656:473", "ThroneOfTheFourWinds:270:229:229:433", "VirnaalDam:151:144:479:215",},
				["UngoroCrater"] = {"FirePlumeRidge:321:288:356:192", "FungalRock:224:191:557:0", "GolakkaHotSprings:309:277:145:226", "IronstonePlateau:197:222:706:201", "LakkariTarPits:432:294:305:0", "MarshalsStand:204:170:462:330", "MossyPile:186:185:328:179", "TerrorRun:316:293:162:357", "TheMarshlands:263:412:573:256", "TheRollingGarden:337:321:565:39", "TheScreamingReaches:332:332:157:0", "TheSlitheringScar:381:274:335:384",},
				["Winterspring"] = {"Everlook:194:229:482:195", "FrostfireHotSprings:376:289:93:118", "FrostsaberRock:332:268:304:0", "FrostwhisperGorge:317:183:424:474", "IceThistleHills:249:217:581:314", "LakeKeltheril:271:258:372:268", "Mazthoril:257:238:399:340", "OwlWingThicket:254:150:556:439", "StarfallVillage:367:340:229:33", "TheHiddenGrove:333:255:500:17", "TimbermawPost:362:252:92:302", "WinterfallVillage:221:209:588:181",},

				-- Outland
				["BladesEdgeMountains"] = {"BashirLanding:256:256:422:0", "BladedGulch:256:256:623:147", "BladesipreHold:256:507:314:161", "BloodmaulCamp:256:256:412:95", "BloodmaulOutpost:256:297:342:371", "BrokenWilds:256:256:733:109", "CircleofWrath:256:256:439:210", "DeathsDoor:256:419:512:249", "ForgeCampAnger:416:256:586:147", "ForgeCampTerror:512:252:144:416", "ForgeCampWrath:256:256:254:176", "Grishnath:256:256:286:28", "GruulsLayer:256:256:527:81", "JaggedRidge:256:254:446:414", "MokNathalVillage:256:256:658:297", "RavensWood:512:256:214:55", "RazorRidge:256:336:533:332", "RidgeofMadness:256:410:554:258", "RuuanWeald:256:512:479:98", "Skald:256:256:673:71", "Sylvanaar:256:318:289:350", "TheCrystalpine:256:256:585:0", "ThunderlordStronghold:256:396:405:272", "VeilLashh:256:240:271:428", "VeilRuuan:256:128:563:151", "VekhaarStand:256:256:629:406", "VortexPinnacle:256:462:166:206",},
				["Hellfire"] = {"DenofHaalesh:256:256:182:412", "ExpeditionArmory:512:255:261:413", "FalconWatch:512:342:183:326", "FallenSkyRidge:256:256:34:142", "ForgeCampRage:512:512:478:25", "HellfireCitadel:256:458:338:210", "HonorHold:256:256:469:298", "MagharPost:256:256:206:110", "PoolsofAggonar:256:512:326:45", "RuinsofShanaar:256:378:25:290", "TempleofTelhamat:512:512:38:152", "TheLegionFront:256:512:579:128", "TheStairofDestiny:256:512:737:156", "Thrallmar:256:256:467:154", "ThroneofKiljaeden:512:256:477:6", "VoidRidge:256:256:705:368", "WarpFields:256:260:308:408", "ZethGor:422:238:580:430",},
				["Nagrand"] = {"BurningBladeRUins:256:334:660:334", "ClanWatch:256:256:532:363", "ForgeCampFear:512:420:36:248", "ForgeCampHate:256:256:162:154", "Garadar:256:256:431:143", "Halaa:256:256:335:193", "KilsorrowFortress:256:241:558:427", "LaughingSkullRuins:256:256:351:52", "OshuGun:512:334:168:334", "RingofTrials:256:256:533:267", "SouthwindCleft:256:256:391:258", "SunspringPost:256:256:219:199", "Telaar:256:256:387:390", "ThroneoftheElements:256:256:504:53", "TwilightRidge:256:512:10:107", "WarmaulHill:256:256:157:32", "WindyreedPass:256:256:598:79", "WindyreedVillage:256:256:666:233", "ZangarRidge:256:256:277:54",},
				["Netherstorm"] = {"Area52:256:128:241:388", "ArklonRuins:256:256:328:397", "CelestialRidge:256:256:644:173", "EcoDomeFarfield:256:256:396:10", "EtheriumStagingGrounds:256:256:481:208", "ForgeBaseOG:256:256:237:22", "KirinVarVillage:256:145:490:523", "ManaforgeBanar:256:387:147:281", "ManaforgeCoruu:256:179:357:489", "ManaforgeDuro:256:256:465:336", "ManafrogeAra:256:256:171:155", "Netherstone:256:256:411:20", "NetherstormBridge:256:256:132:294", "RuinedManaforge:256:256:513:138", "RuinsofEnkaat:256:256:253:301", "RuinsofFarahlon:512:256:354:49", "SocretharsSeat:256:256:229:38", "SunfuryHold:256:217:454:451", "TempestKeep:409:384:593:284", "TheHeap:256:213:239:455", "TheScrapField:256:256:356:261", "TheStormspire:256:256:298:134",},
				["ShadowmoonValley"] = {"AltarofShatar:256:256:520:93", "CoilskarPoint:512:512:348:8", "EclipsePoint:512:358:343:310", "IlladarPoint:256:256:143:256", "LegionHold:512:512:104:155", "NetherwingCliffs:256:256:554:308", "NetherwingLedge:492:223:510:445", "ShadowmoonVilliage:512:512:116:35", "TheBlackTemple:396:512:606:126", "TheDeathForge:256:512:290:129", "TheHandofGuldan:512:512:394:90", "TheWardensCage:512:410:469:258", "WildhammerStronghold:512:439:168:229",}, 
				["TerokkarForest"] = {"AllerianStronghold:256:256:480:277", "AuchenaiGrounds:256:234:247:434", "BleedingHollowClanRuins:256:367:103:301", "BonechewerRuins:256:256:521:275", "CarrionHill:256:256:377:272", "CenarionThicket:256:256:314:0", "FirewingPoint:385:512:617:149", "GrangolvarVilliage:512:256:143:171", "RaastokGlade:256:256:505:154", "RazorthornShelf:256:256:478:19", "RefugeCaravan:128:256:316:268", "RingofObservance:256:256:310:345", "SethekkTomb:256:256:245:289", "ShattrathCity:512:512:104:4", "SkethylMountains:512:320:449:348", "SmolderingCaravan:256:208:321:460", "StonebreakerHold:256:256:397:165", "TheBarrierHills:256:256:116:4", "Tuurem:256:512:455:34", "VeilRhaze:256:256:222:362", "WrithingMound:256:256:417:327",},
				["Zangarmarsh"] = {"AngoroshGrounds:256:256:88:50", "AngoroshStronghold:256:128:124:0", "BloodscaleEnclave:256:256:596:412", "CenarionRefuge:308:256:694:321", "CoilfangReservoir:256:512:462:90", "FeralfenVillage:512:336:314:332", "MarshlightLake:256:256:81:152", "OreborHarborage:256:512:329:25", "QuaggRidge:256:343:141:325", "Sporeggar:512:256:20:202", "Telredor:256:512:569:112", "TheDeadMire:286:512:716:128", "TheHewnBog:256:512:219:51", "TheLagoon:256:256:512:303", "TheSpawningGlen:256:256:31:339", "TwinspireRuins:256:256:342:249", "UmbrafenVillage:256:207:720:461", "ZabraJin:256:256:175:232",},

				-- Northrend
				["BoreanTundra"] = {"AmberLedge:244:214:325:140", "BorGorokOutpost:396:203:314:0", "Coldarra:460:381:50:0", "DeathsStand:289:279:707:181", "GarroshsLanding:267:378:153:238", "Kaskala:385:316:509:214", "RiplashStrand:382:258:293:383", "SteeljawsCaravan:244:319:397:66", "TempleCityOfEnKilah:290:292:712:15", "TheDensOfDying:203:209:662:11", "TheGeyserFields:375:342:480:0", "TorpsFarm:186:276:272:237", "ValianceKeep:259:302:457:264", "WarsongStronghold:260:278:329:237",},
				["CrystalsongForest"] = {"ForlornWoods:544:668:129:0", "SunreaversCommand:446:369:536:40", "TheAzureFront:416:424:0:244", "TheDecrepitFlow:288:222:0:0", "TheGreatTree:252:260:0:91", "TheUnboundThicket:502:477:500:105", "VioletStand:264:303:0:176", "WindrunnersOverlook:558:285:444:383",},
				["Dragonblight"] = {"AgmarsHammer:236:218:258:203", "Angrathar:306:242:210:0", "ColdwindHeights:213:219:403:0", "EmeraldDragonshrine:196:218:543:362", "GalakrondsRest:258:225:433:118", "IcemistVillage:235:337:134:165", "LakeIndule:356:300:217:313", "LightsRest:299:278:703:7", "Naxxramas:311:272:691:160", "NewHearthglen:214:261:614:358", "ObsidianDragonshrine:304:203:256:104", "RubyDragonshrine:188:211:374:208", "ScarletPoint:235:354:569:7", "TheCrystalVice:229:259:487:0", "TheForgottenShore:301:286:698:332", "VenomSpite:226:212:661:264", "WestwindRefugeeCamp:229:299:42:187", "WyrmrestTemple:317:353:453:219",},
				["GrizzlyHills"] = {"AmberpineLodge:278:290:217:244", "BlueSkyLoggingGrounds:249:235:232:129", "CampOneqwah:324:265:548:137", "ConquestHold:332:294:17:307", "DrakilJinRuins:351:284:607:41", "DrakTheronKeep:382:285:0:46", "DunArgol:455:400:547:257", "GraniteSprings:356:224:7:207", "GrizzleMaw:294:227:358:187", "RageFangShrine:475:362:312:294", "ThorModan:329:246:509:0", "UrsocsDen:328:260:331:32", "VentureBay:274:207:18:461", "Voldrune:283:247:176:421",},
				["HowlingFjord"] = {"AncientLift:177:191:342:351", "ApothecaryCamp:263:265:99:37", "BaelgunsExcavationSite:244:305:621:327", "Baleheim:174:173:576:170", "CampWinterHoof:223:209:354:0", "CauldrosIsle:181:178:490:161", "EmberClutch:213:256:283:203", "ExplorersLeagueOutpost:232:216:585:336", "FortWildervar:251:192:490:0", "GiantsRun:298:306:572:0", "Gjalerbron:242:189:225:0", "Halgrind:187:263:397:208", "IvaldsRuin:193:201:668:223", "Kamagua:333:265:99:278", "NewAgamand:284:308:415:360", "Nifflevar:178:208:595:240", "ScalawagPoint:350:258:168:410", "Skorn:238:232:343:108", "SteelGate:222:168:222:100", "TheTwistedGlade:266:210:420:57", "UtgardeKeep:248:382:477:216", "VengeanceLanding:223:338:664:25", "WestguardKeep:347:220:90:180",},
				["IcecrownGlacier"] = {"Aldurthar:373:375:355:37", "ArgentTournamentGround:314:224:616:30", "Corprethar:308:212:342:392", "IcecrownCitadel:308:202:392:466", "Jotunheim:393:474:22:122", "OnslaughtHarbor:204:268:0:167", "Scourgeholme:245:239:690:267", "SindragosasFall:300:343:626:31", "TheBombardment:248:243:538:181", "TheBrokenFront:283:231:558:329", "TheConflagration:227:210:327:305", "TheFleshwerks:219:283:218:291", "TheShadowVault:223:399:321:15", "Valhalas:238:240:217:50", "ValleyofEchoes:269:217:715:390", "Ymirheim:223:207:444:276",},
				["SholazarBasin"] = {"KartaksHold:329:293:76:375", "RainspeakerCanopy:207:235:427:244", "RiversHeart:468:329:359:339", "TheAvalanche:322:265:596:92", "TheGlimmeringPillar:294:327:308:34", "TheLifebloodPillar:312:369:501:134", "TheMakersOverlook:233:286:705:236", "TheMakersPerch:249:248:172:135", "TheMosslightPillar:239:313:265:355", "TheSavageThicket:293:229:396:51", "TheStormwrightsShelf:268:288:138:58", "TheSuntouchedPillar:455:316:82:186",},
				["TheStormPeaks"] = {"BorsBreath:322:195:109:375", "BrunnhildarVillage:305:298:339:370", "DunNiffelem:309:383:481:285", "EngineoftheMakers:210:179:316:296", "Frosthold:244:220:134:429", "GarmsBane:184:191:395:470", "NarvirsCradle:180:239:214:144", "Nidavelir:221:200:108:206", "SnowdriftPlains:205:232:162:143", "SparksocketMinefield:251:200:242:468", "TempleofLife:182:270:570:113", "TempleofStorms:169:164:239:301", "TerraceoftheMakers:363:341:292:122", "Thunderfall:306:484:627:179", "Ulduar:369:265:218:0", "Valkyrion:228:158:98:318",},
				["ZulDrak"] = {"AltarOfHarKoa:265:257:533:345", "AltarOfMamToth:311:317:575:88", "AltarOfQuetzLun:261:288:607:251", "AltarOfRhunok:247:304:431:127", "AltarOfSseratus:237:248:288:168", "AmphitheaterOfAnguish:266:254:289:287", "DrakSotraFields:286:265:326:358", "GunDrak:336:297:629:0", "Kolramas:302:231:380:437", "LightsBreach:321:305:181:363", "ThrymsEnd:272:268:0:247", "Voltarus:218:291:174:191", "Zeramas:307:256:7:412", "ZimTorga:249:258:479:241",},

				-- Cataclysm
				["Deepholm"] = {"CrimsonExpanse:462:400:540:12", "DeathwingsFall:454:343:549:297", "NeedlerockChasm:378:359:20:0", "NeedlerockSlag:370:285:0:146", "ScouredReach:516:287:448:0", "StoneHearth:371:354:0:314", "StormsFuryWreckage:292:285:458:383", "TempleOfEarth:355:345:287:177", "ThePaleRoost:467:273:85:0", "TherazanesThrone:274:156:434:0", "TheShatteredField:430:230:141:438", "TwilightOverlook:411:248:570:420", "TwilightTerrace:237:198:297:384",},
				["Kezan"] = {"BilgewaterPort:694:290:163:148", "Drudgetown:351:301:180:367", "FirstbankofKezan:376:343:98:325", "GallywixsVilla:303:452:0:41", "Kajamine:354:360:586:308", "KajaroField:250:307:383:260", "KezanMap:1002:664:0:4", "SwindleStreet:168:213:317:232",},
				["TheLostIsles"] = {"Alliancebeachhead:177:172:129:348", "BilgewaterLumberyard:248:209:462:43", "GallywixDocks:173:180:351:21", "HordeBaseCamp:222:190:244:458", "KTCOilPlatform:156:142:433:11", "landingSite:142:133:377:359", "Lostpeak:350:517:581:21", "OoomlotVillage:221:211:508:345", "Oostan:210:258:492:161", "RaptorRise:168:205:416:368", "RuinsOfVashelan:212:216:440:452", "ScorchedGully:305:288:323:185", "ShipwreckShore:172:175:189:408", "SkyFalls:190:186:416:131", "TheSavageGlen:231:216:213:325", "TheSlavePits:212:193:279:68", "WarchiefsLookout:159:230:264:144",},
				["TheLostIsles_terrain1"] = {"Alliancebeachhead:177:172:129:348", "BilgewaterLumberyard:248:209:462:43", "GallywixDocks:173:180:351:21", "HordeBaseCamp:222:190:244:458", "KTCOilPlatform:156:142:433:11", "landingSite:142:133:377:359", "Lostpeak:350:517:581:21", "OoomlotVillage:221:211:508:345", "Oostan:210:258:492:161", "RaptorRise:168:205:416:368", "RuinsOfVashelan:212:216:440:452", "ScorchedGully:305:288:323:185", "ShipwreckShore:172:175:189:408", "SkyFalls:190:186:416:131", "TheSavageGlen:231:216:213:325", "TheSlavePits:212:193:279:68", "WarchiefsLookout:159:230:264:144",},
				["TheLostIsles_terrain2"] = {"Alliancebeachhead:177:172:129:348", "BilgewaterLumberyard:248:209:462:43", "GallywixDocks:173:180:351:21", "HordeBaseCamp:222:190:244:458", "KTCOilPlatform:156:142:433:11", "landingSite:142:133:377:359", "Lostpeak:350:517:581:21", "OoomlotVillage:221:211:508:345", "Oostan:210:258:492:161", "RaptorRise:168:205:416:368", "RuinsOfVashelan:212:216:440:452", "ScorchedGully:305:288:323:185", "ShipwreckShore:172:175:189:408", "SkyFalls:190:186:416:131", "TheSavageGlen:231:216:213:325", "TheSlavePits:212:193:279:68", "WarchiefsLookout:159:230:264:144",},
				["VashjirDepths"] = {"AbandonedReef:371:394:50:263", "AbyssalBreach:491:470:497:0", "ColdlightChasm:267:374:266:280", "DeepfinRidge:363:262:275:32", "FireplumeTrench:298:251:315:110", "KorthunsEnd:370:385:412:283", "LGhorek:306:293:162:210", "Seabrush:225:250:415:183",},
				["VashjirKelpForest"] = {"DarkwhisperGorge:220:189:528:228", "GnawsBoneyard:311:217:451:325", "GubogglesLedge:227:207:399:280", "HoldingPens:316:267:456:401", "HonorsTomb:291:206:380:43", "LegionsFate:278:315:210:35", "TheAccursedReef:340:225:365:162",},
				["VashjirRuins"] = {"BethMoraRidge:335:223:407:445", "GlimmeringdeepGorge:272:180:270:222", "Nespirah:286:269:460:261", "RuinsOfTherseral:197:223:554:175", "RuinsOfVashjir:349:361:217:268", "ShimmeringGrotto:339:278:400:0", "SilverTideHollow:480:319:150:32",},

				-- Pandaria
				["DreadWastes"] = {"KLAXXIVESS:236:206:458:110", "ZANVESS:290:283:162:385", "BREWGARDEN:250:218:351:0", "DREADWATERLAKE:322:211:437:313", "CLUTCHESOFSHEKZEER:209:318:341:125", "HORRIDMARCH:323:194:441:224", "BRINYMUCK:325:270:214:311", "SOGGYSGAMBLE:268:241:450:406", "TERRACEOFGURTHAN:209:234:593:92", "RIKKITUNVILLAGE:218:186:236:32", "HEARTOFFEAR:262:293:191:122", "KYPARIVOR:325:190:485:0",},
				["Krasarang"] = {"RedwingRefuge:212:265:317:63", "AnglersOutpost:265:194:545:205", "TempleOfTheRedCrane:219:259:300:215", "DojaniRiver:190:282:513:3", "krasarangCove:286:268:701:19", "TheDeepwild:188:412:397:59", "LostDynasty:217:279:589:27", "FallsongRiver:214:393:218:77", "TheSouthernIsles:252:313:23:267", "ZhusBastion:306:204:612:0", "RuinsOfDojan:204:383:444:44", "TheForbiddenJungle:257:300:0:79", "RuinsOfKorja:211:395:125:88", "CradleOfChiJi:272:250:176:376", "UngaIngoo:258:170:330:498", "NayeliLagoon:246:240:343:373",},
				["Krasarang_terrain1"] = {"Zhusbastion:306:204:612:0", "FallsongRiver:214:393:218:77", "DojaniRiver:190:282:513:3", "RuinsOfDojan:204:383:444:44", "TheDeepWild:188:412:397:59", "Nayelilagoon:246:240:343:373", "Ungaingoo:258:170:330:498", "KrasarangCove:295:293:701:19", "RuinsOfKorja:211:395:125:88", "LostDynasty:217:279:589:27", "TheSouthernIsles:275:329:0:267", "AnglerSoutpost:347:199:545:200", "TheForbiddenJungle:257:300:0:79", "RedWingRefuge:212:265:317:63", "TempleOfTheRedCrane:219:259:300:215", "CradleOfChiji:272:250:176:376",},
				["KunLaiSummit"] = {"BinanVillage:240:198:607:470", "Mogujia:253:208:462:411", "MuskpawRanch:229:262:603:313", "MountNeverset:313:208:228:264", "ZouchinVillage:298:219:502:64", "TempleoftheWhitetiger:250:260:587:170", "GateoftheAugust:261:162:449:506", "ShadoPanMonastery:385:385:88:92", "TheBurlapTrail:310:276:398:310", "PeakOfSerenity:287:277:333:63", "ValleyOfEmperors:224:241:453:191", "Kotapeak:252:257:233:360", "Iseoflostsouls:259:233:602:4", "FireboughNook:224:172:322:496", "TEMPLEOFTHEWHITETIGER:250:260:587:170",},
				["TheHiddenPass"] = {"TheHiddenCliffs:294:220:433:0", "TheBlackMarket:479:493:371:175", "TheHiddenSteps:290:191:412:477",},
				["TheJadeForest"] = {"GlassfinVillage:278:310:525:358", "RuinsOfGanShi:196:158:316:0", "TheArboretum:242:210:481:215", "WindlessIsle:251:348:539:43", "DawnsBlossom:234:210:325:178", "TempleOfTheJadeSerpent:264:211:468:295", "DreamersPavillion:218:148:474:520", "NectarbreezeOrchard:219:256:290:330", "HellscreamsHope:196:166:181:75", "SlingtailPits:179:180:428:416", "SerpentsSpine:191:216:388:299", "ChunTianMonastery:227:198:300:56", "JadeMines:236:142:400:146", "EmperorsOmen:202:204:430:21", "GrookinMound:253:229:182:214", "WreckOfTheSkyShark:210:158:202:0", "Waywardlanding:219:186:346:482", "NookaNooka:219:205:189:151",},
				["TheWanderingIsle"] = {"TheDawningValley:677:668:325:0", "TempleofFiveDawns:607:461:395:182", "MandoriVillage:610:374:392:294", "RidgeofLaughingWinds:313:321:183:198", "Pei-WuForest:651:262:351:406", "PoolofthePaw:220:188:297:324", "SkyfireCrash-Site:346:263:124:405", "TheRows:385:373:504:295", "TheSingingPools:372:475:545:12", "MorningBreezeVillage:261:315:203:36", "Fe-FangVillage:234:286:134:9", "TheWoodofStaves:989:466:13:202",},
				["TownlongWastes"] = {"NiuzaoTemple:296:359:213:241", "ShanzeDao:300:246:125:0", "TheSumprushes:271:205:545:369", "Sikvess:261:235:306:433", "GaoRanBlockade:353:200:546:468", "MingChiCrossroads:247:221:417:447", "palewindVillage:282:306:692:362", "OsulMesa:238:296:560:185", "ShadoPanGarrison:213:170:413:385", "KriVess:255:269:420:209", "SriVess:294:283:92:192",},
				["ValeofEternalBlossoms"] = {"GuoLaiRuins:337:349:87:3", "WhiteMoonShrine:298:262:482:10", "MistfallVillage:310:305:200:363", "SettingSunTraining:350:429:0:234", "TuShenBurialGround:267:308:349:316", "TheStairsAscent:446:359:556:267", "WinterboughGlade:361:333:4:107", "TheGoldenStair:242:254:328:16", "WhitepetalLake:267:281:278:170", "TheTwinMonoliths:272:522:444:97", "MoguShanPalace:373:385:629:22",},
				["ValleyoftheFourWinds"] = {"ThunderfootFields:380:317:622:0", "PoolsofPurity:213:246:513:58", "RumblingTerrace:277:245:582:301", "PaoquanHollow:273:246:12:105", "StormsoutBrewery:257:288:227:380", "DustbackGorge:209:308:0:343", "CliffsofDispair:510:264:215:404", "Theheartland:286:392:253:75", "SilkenFields:254:259:530:253", "HarvestHome:260:251:5:239", "GildedFan:208:292:438:41", "GrandGranery:314:212:334:325", "SingingMarshes:175:291:170:130", "ZhusDecent:303:323:699:114", "Halfhill:206:245:438:177", "NesingwarySafari:249:342:104:326", "MudmugsPlace:230:217:561:161", "KuzenVillage:199:304:224:74",},

				-- Draenor
				["FrostfireRidge"] = {"BladespireFortress:356:303:38:117", "BloodmaulStronghold:258:217:311:4", "BonesOfAgurak:273:349:729:319", "DaggermawRavine:255:191:284:91", "FrostwindDunes:274:214:121:0", "GrimfrostHill:178:203:597:210", "Grombolash:217:239:483:33", "Gromgar:282:341:505:323", "IronSiegeworks:329:294:673:156", "IronwayStation:199:335:641:304", "Magnarok:213:278:609:33", "StonefangOutpost:251:191:306:281", "TheBoneSlag:256:210:290:192", "TheCracklingPlains:266:293:439:137", "Worgol:317:233:72:292",},
				["Gorgrond"] = {"BastionRise:324:161:283:507", "BeastWatch:166:161:383:371", "EasternRuin:210:193:525:260", "Evermorn:297:181:281:444", "Foundry:211:221:455:74", "FoundrySouth:217:180:454:183", "GronnCanyon:279:241:258:213", "HighlandPass:285:323:547:73", "HighPass:209:225:411:250", "IronDocks:315:180:350:0", "Mushrooms:253:198:444:323", "StonemaulArena:217:178:259:335", "StonemaulSouth:208:142:275:416", "Stripmine:250:232:312:77", "Tangleheart:262:221:451:372",},
				["NagrandDraenor"] = {"Ancestral:234:191:239:259", "BrokenPrecipice:305:227:256:12", "Elementals:286:274:588:0", "Grommashar:256:301:600:367", "Hallvalor:236:372:766:118", "Highmaul:471:437:0:0", "IronfistHarbor:236:242:283:354", "Lokrath:316:221:382:187", "Margoks:249:288:753:380", "Mushrooms:250:287:746:25", "Oshugun:262:266:366:323", "RingOfBlood:263:287:430:0", "RingOfTrials:354:315:523:159", "SunspringWatch:274:254:312:98", "Telaar:296:272:461:353",},
				["ShadowmoonValleyDR"] = {"AnguishFortress:309:264:140:160", "DarktideRoost:282:201:468:467", "Elodor:291:266:426:0", "Embaari:346:252:270:158", "Gloomshade:229:240:319:5", "Gulvar:260:309:26:0", "Karabor:393:318:537:150", "Shazgul:282:225:259:315", "ShimmeringMoor:288:261:453:306", "Socrethar:202:201:383:411", "Swisland:173:160:309:460",},
				["SpiresOfArak"] = {"BloodbladeRedoubt:209:154:334:210", "BloodmaneValley:229:246:410:350", "CenterRavenNest:188:190:444:255", "Clutchpop:217:224:533:382", "EastMushrooms:182:244:649:155", "EmptyGarrison:190:187:282:261", "HowlingCrag:382:274:459:0", "NwCorner:314:304:102:0", "SethekkHollow:238:295:520:127", "Skettis:371:174:289:0", "SoloSpireNorth:196:284:429:84", "SoloSpireSouth:169:178:374:276", "Southport:197:179:310:328", "Veilakraz:252:230:281:83", "Veilzekk:198:232:521:268", "VentureCove:226:193:465:475", "WrithingMire:229:213:197:198",},
 				["Talador"] = {"Aruuna:389:234:597:178", "Auchindoun:309:262:338:356", "CenterIsles:252:280:546:228", "CourtOfSouls:307:229:150:264", "FortWrynn:292:235:567:42", "GordalFortress:423:290:548:378", "Gulrok:278:270:165:364", "Northgate:398:149:571:0", "OrunaiCoast:279:267:427:0", "SeEntrance:308:276:685:298", "Shattrath:406:367:173:22", "Telmor:497:157:207:511", "TombOfLights:326:212:352:271", "Tuurem:225:224:472:148", "Zangarra:287:277:713:35",},
				["TanaanJungle"] = {"DarkPortal:333:437:637:136", "DraeneiSW:174:208:81:367", "Fangrila:343:264:429:392", "FelForge:223:183:392:187", "HellfireCitadel:327:241:254:262", "IronFront:209:245:0:264", "IronHarbor:189:294:303:62", "Kiljaeden:365:276:392:23", "Kranak:338:254:54:94", "LionsWatch:270:208:465:313", "Marshlands:246:218:296:383", "Shanaar:248:314:170:354", "Volmar:238:229:501:171", "Zethgol:274:251:118:194",},

				-- Legion
				["Azsuna"] = {"Faronaar:330:265:166:202", "Felblaze:239:303:594:0", "Greenway:247:184:450:95", "IsleOfTheWatchers:321:267:281:401", "Llothienhighlands:351:245:219:69", "LostOrchard:315:185:257:0", "Narthalas:272:192:441:173", "OceanusCove:206:266:396:244", "RuinedSanctum:220:288:523:233",	"TempleLights:181:243:481:340",	"Zarkhenar:288:195:477:0",},
				["AszunaDungeonExterior"] = {"EyeOfAzshara:848:668:39:0"},
				["BrokenShore"] = {"BrokenValley:338:322:254:84", "DeadwoodLanding:182:245:220:260", "DeliverancePoint:387:314:312:302", "FelrageStrand:332:276:596:100", "SoulRuin:338:270:389:180", "TheLostTemple:308:244:632:169", "TheWeepingTerrace:276:213:350:13", "TombOfSargeras:312:301:500:0",},
				["Highmountain"] = {"BloodHuntHighlands:297:250:307:75", "Feltotem:256:326:172:31", "FrostHoofWatch:186:213:391:408", "IronhornEnclave:288:258:452:410", "NightWatchersPerch:344:295:0:244", "PineRockBasin:217:148:323:249", "Riverbend:214:308:314:360", "RockawayShallows:207:302:469:45", "ShipwreckCove:283:170:331:0", "Skyhorn:311:229:357:179", "StonehoofWatch:341:328:494:236", "Sylvanfalls:445:326:0:342", "Thundertotem:244:199:332:302", "TrueshotLodge:172:204:249:236",},
				["Stormheim"] = {"AggrammarsVault:199:185:361:210", "BlackbeakOverlook:297:210:154:129", "Dreadwake:215:247:457:412", "Dreyrgrot:132:145:689:266", "Greywatch:173:163:648:339", "HallsOfValor:252:280:585:372",	"Haustvald:200:174:612:187", "Hrydshal:631:315:0:353", "MawOfNashal:509:251:17:0", "Morheim:150:180:741:313", "Nastrondir:241:194:345:95", "QatchmansRock:135:162:623:81",	"Runewood:194:214:592:226", "ShieldsRest:289:172:689:0", "SkoldAshil:177:169:506:345", "StormsReach:180:160:510:118", "TalonRest:291:208:316:282",	"TideskornHarbor:205:199:479:183", "Valdisdall:186:158:522:288", "WeepingBluffs:386:314:56:185",},
				["Suramar"] = {"Ambervale:222:311:132:179", "CrimsonThicket:327:381:492:0", "Falanaar:248:317:23:136", "FelsoulHold:289:363:183:305", "GrandPromenade:355:291:344:285", "Jandvik:419:538:583:0", "MoonguardStronghold:480:245:58:0", "MoonwhisperGulch:428:316:201:0", "RuinsOfEluneeth:221:224:264:226", "SuramarCity:470:337:390:331", "Telanor:387:372:327:0",},
				["Valsharah"] = {"Andutalah:241:240:587:250", "BlackrookHold:250:253:262:175", "BradensBrook:311:244:259:275", "DreamGrove:294:364:283:0",	"GloamingReef:239:301:136:274",	"GroveOfCenarius:171:150:457:351", "Lorlathil:177:156:467:413",	"MoonclawVale:254:281:549:380",	"Shalanir:326:360:419:0", "Smolderhide:341:188:324:480", "TempleOfElune:216:219:459:240", "Thastalah:218:168:342:416",},
				["ArgusCore"] = {"DefiledPath:626:385:293:0", "FelfireArmory:660:668:0:0", "Terminus:467:430:535:238",},
				["ArgusMacAree"] = {"Conservatory:313:353:498:111", "RuinsOfOronaar:265:310:278:284", "SeatOfTriumvirate:463:519:265:54", "Shadowguard:498:461:0:0", "Triumvirates:284:264:410:375", "UpperTerrace:701:323:0:0",},
				["ArgusSurface"] = {"AnnihilanPits:296:336:371:178", "KrokulHovel:307:304:428:364", "Nathraxas:835:422:167:0", "PetrifiedForest:445:379:557:289", "ShatteredFields:498:530:37:138",},

			}

			-- Initialise counters
			local createdtex = 0
			local texcount = 0

			-- Create local texture table
			local MapTex = {}

			-- Map refresh function
			local function RefMap()

				if texcount > 0 then
					for i = 1, texcount do
						MapTex[i]:Hide()
					end
					texcount = 0; 
				end

				-- Get current map
				local filename, texheight, void, void, sub = GetMapInfo()
				if sub then return end
				if not filename then return end

				local texpath = format([[Interface\WorldMap\%s\]], filename)
				local zone = LeaPlusMapData[filename] or {}

				-- Map debug (prints overlay information)
				-- print(filename); for p = 1, GetNumMapOverlays() do print(GetMapOverlayInfo(p)); end;

				-- Create new textures for current map
				for travnum, num in next, zone do
					local tname, texwidth, texheight, offsetx, offsety = strsplit(":", num)
					local texturename = texpath .. tname
					local numtexwide, numtextall = math.ceil(texwidth / 256), math.ceil(texheight / 256)

					-- Work out how many textures are needed to fill the map
					local neededtex = texcount + numtextall * numtexwide

					-- Create the textures
					if neededtex > createdtex then
						for j = createdtex + 1, neededtex do
							MapTex[j] = WorldMapDetailFrame:CreateTexture(nil, "ARTWORK")
						end
						createdtex = neededtex
					end

					-- Process textures
					for j = 1, numtextall do
						local texturepxheight, texturefileheight
						if j < numtextall then
							texturepxheight = 256
							texturefileheight = 256
						else
							texturepxheight = texheight % 256
							if texturepxheight == 0 then
								texturepxheight = 256
							end
							texturefileheight = 16
							while texturefileheight < texturepxheight do
								texturefileheight = texturefileheight * 2
							end
						end

						for k = 1, numtexwide do
							if texcount > createdtex then return end
							texcount = texcount + 1
							local texture = MapTex[texcount]
							local texturepxwidth
							local texturefilewidth
							if k < numtexwide then
								texturepxwidth = 256
								texturefilewidth = 256
							else
								texturepxwidth = texwidth % 256
								if texturepxwidth == 0 then
									texturepxwidth = 256
								end
								texturefilewidth = 16
								while texturefilewidth < texturepxwidth do
									texturefilewidth = texturefilewidth * 2
								end
							end 
							texture:SetWidth(texturepxwidth)
							texture:SetHeight(texturepxheight)
							texture:SetTexCoord(0, texturepxwidth/texturefilewidth, 0, texturepxheight/texturefileheight)
							texture:ClearAllPoints()						  
							texture:SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", offsetx + (256 * (k-1)), -(offsety + (256 * (j - 1))))
							texture:SetTexture(texturename..(((j - 1) * numtexwide) + k))
							texture:Show()
						end
					end 
				end
			end

			-- Update map
			hooksecurefunc("WorldMapFrame_Update", function()
				if WorldMapFrame:IsShown() and LeaPlusLC["RevealWorldMap"] == "On" then
					RefMap();
				end
			end)

			----------------------------------------------------------------------
			-- Points of interest
			----------------------------------------------------------------------

			local dnTex = "Interface\\Minimap\\Dungeon"
			local rdTex = "Interface\\Minimap\\Raid"
			local ptTex = "Interface\\Minimap\\Vehicle-AllianceMagePortal"

			local pTable = {

				-- Portals: Suramar
				{category = "ShowSuramarPortals"	, name = L["Astravar Harbor"]				, continent = 1220	, zoneID = 1033		, x = 875		, y = 3634	, texture = ptTex		, desc = L["Portal"], reqQuest = 44740, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Evermoon Terrace"]				, continent = 1220	, zoneID = 1033		, x = 530		, y = 3771	, texture = ptTex		, desc = L["Portal"], reqQuest = 42889, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Falanaar"]						, continent = 1220	, zoneID = 1033		, x = 2369		, y = 5442	, texture = ptTex		, desc = L["Portal"], reqQuest = 42230, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Felsoul Hold"]					, continent = 1220	, zoneID = 1033		, x = 623		, y = 4477	, texture = ptTex		, desc = L["Portal"], reqQuest = 41575, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Lunastre Estate"]				, continent = 1220	, zoneID = 1033		, x = 511		, y = 4233	, texture = ptTex		, desc = L["Portal"], reqQuest = 43811, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Moon Guard Stronghold"]			, continent = 1220	, zoneID = 1033		, x = 3037		, y = 4947	, texture = ptTex		, desc = L["Portal"], reqQuest = 43808, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Ruins of Elune'eth"]			, continent = 1220	, zoneID = 1033		, x = 1697		, y = 4653	, texture = ptTex		, desc = L["Portal"], reqQuest = 40956, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Sanctum of Order"]				, continent = 1220	, zoneID = 1033		, x = 1203		, y = 4248	, texture = ptTex		, desc = L["Portal"], reqQuest = 43813, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["Tel'anor"]						, continent = 1220	, zoneID = 1033		, x = 2141		, y = 4324	, texture = ptTex		, desc = L["Portal"], reqQuest = 43809, remQuest = nil},
				{category = "ShowSuramarPortals"	, name = L["The Waning Crescent"]			, continent = 1220	, zoneID = 1033		, x = 433		, y = 4007	, texture = ptTex		, desc = L["Portal"], reqQuest = 42487, remQuest = 38649},
				{category = "ShowSuramarPortals"	, name = L["Twilight Vineyards"]			, continent = 1220	, zoneID = 1033		, x = 1209		, y = 3105	, texture = ptTex		, desc = L["Portal"], reqQuest = 44084, remQuest = nil},

				-- Portals: Stormshield (Ashran)
				{category = "ShowSuramarPortals"	, name = L["Ironforge"]						, continent = 1116	, zoneID = 1009		, x = 3675		, y = -3979	, texture = ptTex		, desc = L["Portal"]},
				{category = "ShowSuramarPortals"	, name = L["Darnassus"]						, continent = 1116	, zoneID = 1009		, x = 3614		, y = -4062	, texture = ptTex		, desc = L["Portal"]},
				{category = "ShowSuramarPortals"	, name = L["Stormwind"]						, continent = 1116	, zoneID = 1009		, x = 3735		, y = -4043	, texture = ptTex		, desc = L["Portal"]},
				{category = "ShowSuramarPortals"	, name = L["Lion's Watch"]					, continent = 1116	, zoneID = 1009		, x = 3720		, y = -3875	, texture = ptTex		, desc = L["Portal"], reqQuest = 38445},

				-- Portals: Warspear (Ashran)
				{category = "ShowSuramarPortals"	, name = L["Orgrimmar"]						, continent = 1116	, zoneID = 1011		, x = 5272		, y = -4053	, texture = ptTex		, desc = L["Portal"]},
				{category = "ShowSuramarPortals"	, name = L["Undercity"]						, continent = 1116	, zoneID = 1011		, x = 5413		, y = -4096	, texture = ptTex		, desc = L["Portal"]},
				{category = "ShowSuramarPortals"	, name = L["Thunder Bluff"]					, continent = 1116	, zoneID = 1011		, x = 5412		, y = -3989	, texture = ptTex		, desc = L["Portal"]},
				{category = "ShowSuramarPortals"	, name = L["Vol'mar"]						, continent = 1116	, zoneID = 1011		, x = 5308		, y = -4015	, texture = ptTex		, desc = L["Portal"], reqQuest = 37935},

				-- Dungeons: Eastern Kingdoms
				{category = "ShowDungeonLocs"		, name = L["Baradin Hold"]					, linkID = 752		, continent = 732	, zoneID = 708		, x = -1204		, y = 1079	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Caverns"]				, linkID = 753		, continent = 0		, zoneID = 28		, x = -7615		, y = -1242	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Caverns"]				, linkID = 753		, continent = 0		, zoneID = 29		, x = -7615		, y = -1242	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Caverns"]				, linkID = 753		, continent = 0		, zoneID = 28		, x = -7570		, y = -1328	, texture = dnTex		, desc = L["Dungeon"], level = 15},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Caverns"]				, linkID = 753		, continent = 0		, zoneID = 29		, x = -7570		, y = -1328	, texture = dnTex		, desc = L["Dungeon"], level = 15},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Depths"]				, linkID = 704		, continent = 0		, zoneID = 28		, x = -7179		, y = -922	, texture = dnTex		, desc = L["Dungeon"], level = 16},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Depths"]				, linkID = 704		, continent = 0		, zoneID = 29		, x = -7179		, y = -922	, texture = dnTex		, desc = L["Dungeon"], level = 16},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Mountain"]			, linkID = nil		, continent = 0		, zoneID = 29		, x = -7781		, y = -1128	, texture = rdTex		, desc = L["Blackrock Caverns"] .. ", " .. L["Blackrock Spire"] .. ",|n" .. L["Blackrock Depths"] .. ", " .. L["Blackwing Lair"] .. ",|n" .. L["Molten Core"]},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Mountain"]			, linkID = nil		, continent = 0		, zoneID = 28		, x = -7365		, y = -1101	, texture = rdTex		, desc = L["Blackrock Caverns"] .. ", " .. L["Blackrock Spire"] .. ",|n" .. L["Blackrock Depths"] .. ", " .. L["Blackwing Lair"] .. ",|n" .. L["Molten Core"]},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Spire"]				, linkID = nil		, continent = 0		, zoneID = 28		, x = -7524		, y = -1230	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Spire"]				, linkID = nil		, continent = 0		, zoneID = 29		, x = -7524		, y = -1230	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Blackwing Descent"]				, linkID = 754		, continent = 0		, zoneID = 29		, x = -7538		, y = -1196	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Blackwing Lair"]				, linkID = 755		, continent = 0		, zoneID = 28		, x = -7662		, y = -1218	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Blackwing Lair"]				, linkID = 755		, continent = 0		, zoneID = 29		, x = -7662		, y = -1218	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Gnomeregan"]					, linkID = 691		, continent = 0		, zoneID = 27		, x = -5184		, y = 603	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Gnomeregan"]					, linkID = 691		, continent = 0		, zoneID = 895		, x = -5183		, y = 598	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Gnomeregan"]					, linkID = 691		, continent = 0		, zoneID = 27		, x = -5145		, y = 898	, texture = dnTex		, desc = L["Dungeon"], level = 10},
				{category = "ShowDungeonLocs"		, name = L["Grim Batol"]					, linkID = 757		, continent = 0		, zoneID = 700		, x = -4058		, y = -3450	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Karazhan"]						, linkID = 799		, continent = 0		, zoneID = 32		, x = -11111	, y = -2006	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Lower Blackrock Spire"]			, linkID = 721		, continent = 0		, zoneID = 28		, x = -7518		, y = -1334	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Lower Blackrock Spire"]			, linkID = 721		, continent = 0		, zoneID = 29		, x = -7518		, y = -1334	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Magisters' Terrace"]			, linkID = 798		, continent = 530	, zoneID = 499		, x = 12884		, y = -7333	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Molten Core"]					, linkID = 696		, continent = 0		, zoneID = 28		, x = -7509		, y = -1040	, texture = rdTex		, desc = L["Raid"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Molten Core"]					, linkID = 696		, continent = 0		, zoneID = 29		, x = -7509		, y = -1040	, texture = rdTex		, desc = L["Raid"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Molten Core"]					, linkID = 696		, continent = 0		, zoneID = 28		, x = -7509		, y = -1040	, texture = rdTex		, desc = L["Raid"], level = 16},
				{category = "ShowDungeonLocs"		, name = L["Molten Core"]					, linkID = 696		, continent = 0		, zoneID = 29		, x = -7509		, y = -1040	, texture = rdTex		, desc = L["Raid"], level = 16},
				{category = "ShowDungeonLocs"		, name = L["Return to Karazhan"]			, linkID = 1115		, continent = 0		, zoneID = 32		, x = -11037	, y = -2001	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Scarlet Halls"]					, linkID = 871		, continent = 0		, zoneID = 20		, x = 2867		, y = -822	, texture = dnTex		, desc = L["Dungeon"], level = 13},
				{category = "ShowDungeonLocs"		, name = L["Scarlet Monastery"]				, linkID = nil		, continent = 0		, zoneID = 20		, x = 2828		, y = -698	, texture = dnTex		, desc = L["Scarlet Monastery"] .. ", " .. L["Scarlet Halls"]},
				{category = "ShowDungeonLocs"		, name = L["Scarlet Monastery"]				, linkID = 874		, continent = 0		, zoneID = 20		, x = 2916		, y = -802	, texture = dnTex		, desc = L["Dungeon"], level = 13},
				{category = "ShowDungeonLocs"		, name = L["Scholomance"]					, linkID = 898		, continent = 0		, zoneID = 22		, x = 1262		, y = -2581	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Shadowfang Keep"]				, linkID = 764		, continent = 0		, zoneID = 21		, x = -233		, y = 1564	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Stratholme: Crusader's Square"]	, linkID = 765		, continent = 0		, zoneID = 23		, x = 3391		, y = -3407	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Stratholme: The Gauntlet"]		, linkID = 765.2	, continent = 0		, zoneID = 23		, x = 3183		, y = -4038	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Sunwell Plateau"]				, linkID = 789		, continent = 530	, zoneID = 499		, x = 12559		, y = -6774	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Temple of Atal'Hakkar"]			, linkID = 687		, continent = 0		, zoneID = 38		, x = -10429	, y = -3829	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Bastion of Twilight"]		, linkID = 758		, continent = 0		, zoneID = 700		, x = -4895		, y = -4230	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["The Deadmines"]					, linkID = 756		, continent = 0		, zoneID = 39		, x = -11075	, y = 1527	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Deadmines"]					, linkID = 756		, continent = 0		, zoneID = 39		, x = -11207	, y = 1674	, texture = dnTex		, desc = L["Dungeon"], level = 17},
				{category = "ShowDungeonLocs"		, name = L["The Stockade"]					, linkID = 690		, continent = 0		, zoneID = 301		, x = -8806		, y = 813	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Stockade"]					, linkID = 690		, continent = 0		, zoneID = 30		, x = -8806		, y = 813	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Throne of the Tides"]			, linkID = 767		, continent = 0		, zoneID = 613		, x = -5720		, y = 5345	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Throne of the Tides"]			, linkID = 767		, continent = 0		, zoneID = 614		, x = -5720		, y = 5345	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Uldaman"]						, linkID = 692		, continent = 0		, zoneID = 17		, x = -6093		, y = -3183	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Uldaman"]						, linkID = 692		, continent = 0		, zoneID = 17		, x = -6065		, y = -2955	, texture = dnTex		, desc = L["Dungeon"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["Upper Blackrock Spire"]			, linkID = 995		, continent = 0		, zoneID = 28		, x = -7487		, y = -1324	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Upper Blackrock Spire"]			, linkID = 995		, continent = 0		, zoneID = 29		, x = -7487		, y = -1324	, texture = dnTex		, desc = L["Dungeon"], level = 14},
				{category = "ShowDungeonLocs"		, name = L["Zul'Aman"]						, linkID = 781		, continent = 530	, zoneID = 463		, x = 6851		, y = -7991	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Zul'Gurub"]						, linkID = 793		, continent = 0		, zoneID = 37		, x = -11915	, y = -1207	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Zul'Gurub"]						, linkID = 793		, continent = 0		, zoneID = 689		, x = -11915	, y = -1207	, texture = dnTex		, desc = L["Dungeon"]},

				-- Dungeons: Kalimdor
				{category = "ShowDungeonLocs"		, name = L["Blackfathom Deeps"]				, linkID = 688		, continent = 1		, zoneID = 43		, x = 4137		, y = 887	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Caverns of Time"]				, linkID = nil		, continent = 1		, zoneID = 161		, x = -8172		, y = -4746	, texture = rdTex		, desc = L["Black Morass"] .. ", " .. L["Culling of Stratholme"] .. ",|n" .. L["Dragon Soul"] .. ", " .. L["End Time"] .. ", " .. L["Hour of Twilight"] .. ",|n" .. L["Hyjal Summit"] .. ", " .. L["Old Hillsbrad Foothills"] .. ",|n" .. L["Well of Eternity"]},
				{category = "ShowDungeonLocs"		, name = L["Dire Maul: Capital Gardens"]	, linkID = 699.2	, continent = 1		, zoneID = 121		, x = -3767		, y = 1249	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Dire Maul: Gordok Commons"]		, linkID = 699		, continent = 1		, zoneID = 121		, x = -3520		, y = 1101	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Dire Maul: Warpwood Quarter"]	, linkID = 699.5	, continent = 1		, zoneID = 121		, x = -3769		, y = 934	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Firelands"]						, linkID = 800		, continent = 1		, zoneID = 606		, x = 3988		, y = -2944	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Halls of Origination"]			, linkID = 759		, continent = 1		, zoneID = 720		, x = -10182	, y = -1996	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Lost City of the Tol'vir"]		, linkID = 747		, continent = 1		, zoneID = 720		, x = -10681	, y = -1307	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Maraudon"]						, linkID = 750		, continent = 1		, zoneID = 101		, x = -1422		, y = 2922	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Maraudon: Earth Song Falls"]	, linkID = 750.2	, continent = 1		, zoneID = 101		, x = -1379		, y = 2915	, texture = dnTex		, desc = L["Dungeon"], level = 22},
				{category = "ShowDungeonLocs"		, name = L["Maraudon: Foulspore Cavern"]	, linkID = 750		, continent = 1		, zoneID = 101		, x = -1473		, y = 2617	, texture = dnTex		, desc = L["Dungeon"], level = 21},
				{category = "ShowDungeonLocs"		, name = L["Maraudon: The Wicked Grotto"]	, linkID = 750		, continent = 1		, zoneID = 101		, x = -1182		, y = 2876	, texture = dnTex		, desc = L["Dungeon"], level = 22},
				{category = "ShowDungeonLocs"		, name = L["Onyxia's Lair"]					, linkID = 718		, continent = 1		, zoneID = 141		, x = -4718		, y = -3734	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Ragefire Chasm"]				, linkID = 680		, continent = 1		, zoneID = 4		, x = 1816		, y = -4418	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Ragefire Chasm"]				, linkID = 680		, continent = 1		, zoneID = 321		, x = 1815		, y = -4418	, texture = dnTex		, desc = L["Dungeon"], level = 2},
				{category = "ShowDungeonLocs"		, name = L["Razorfen Downs"]				, linkID = 760		, continent = 1		, zoneID = 61		, x = -4722		, y = -2342	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Razorfen Kraul"]				, linkID = 761		, continent = 1		, zoneID = 607		, x = -4465		, y = -1666	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Ruins of Ahn'Qiraj"]			, linkID = 717		, continent = 1		, zoneID = 261		, x = -8414		, y = 1504	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Ruins of Ahn'Qiraj"]			, linkID = 717		, continent = 1		, zoneID = 772		, x = -8414		, y = 1504	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Temple of Ahn'Qiraj"]			, linkID = 766		, continent = 1		, zoneID = 261		, x = -8236		, y = 1993	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Temple of Ahn'Qiraj"]			, linkID = 766		, continent = 1		, zoneID = 772		, x = -8236		, y = 1993	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["The Vortex Pinnacle"]			, linkID = 769		, continent = 1		, zoneID = 720		, x = -11514	, y = -2311	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Throne of the Four Winds"]		, linkID = 773		, continent = 1		, zoneID = 720		, x = -11354	, y = 59	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Wailing Caverns"]				, linkID = 749		, continent = 1		, zoneID = 11		, x = -837		, y = -2033	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Wailing Caverns"]				, linkID = 749		, continent = 1		, zoneID = 11		, x = -742		, y = -2216	, texture = dnTex		, desc = L["Dungeon"], level = 20},
				{category = "ShowDungeonLocs"		, name = L["Zul'Farrak"]					, linkID = 686		, continent = 1		, zoneID = 161		, x = -6798		, y = -2891	, texture = dnTex		, desc = L["Dungeon"]},

				-- Dungeons: Caverns of Time
				{category = "ShowDungeonLocs"		, name = L["Dragon Soul"]					, linkID = 824		, continent = 1		, zoneID = 161		, x = -8267		, y = -4514	, texture = rdTex		, desc = L["Raid"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["End Time"]						, linkID = 820		, continent = 1		, zoneID = 161		, x = -8293		, y = -4458	, texture = dnTex		, desc = L["Dungeon"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["Hour of Twilight"]				, linkID = 819		, continent = 1		, zoneID = 161		, x = -8292		, y = -4584	, texture = dnTex		, desc = L["Dungeon"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["Hyjal Summit"]					, linkID = 775		, continent = 1		, zoneID = 161		, x = -8171		, y = -4168	, texture = rdTex		, desc = L["Raid"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["Old Hillsbrad Foothills"]		, linkID = 734		, continent = 1		, zoneID = 161		, x = -8348		, y = -4060	, texture = dnTex		, desc = L["Dungeon"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["The Black Morass"]				, linkID = 733		, continent = 1		, zoneID = 161		, x = -8752		, y = -4194	, texture = dnTex		, desc = L["Dungeon"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["The Culling of Stratholme"]		, linkID = 521		, continent = 1		, zoneID = 161		, x = -8755		, y = -4454	, texture = dnTex		, desc = L["Dungeon"], level = 18},
				{category = "ShowDungeonLocs"		, name = L["Well of Eternity"]				, linkID = 816		, continent = 1		, zoneID = 161		, x = -8595		, y = -4004	, texture = dnTex		, desc = L["Dungeon"], level = 18},

				-- Dungeons: Outland
				{category = "ShowDungeonLocs"		, name = L["Auchenai Crypts"]				, linkID = 722		, continent = 530	, zoneID = 478		, x = -3361		, y = 5136	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Black Temple"]					, linkID = 796		, continent = 530	, zoneID = 473		, x = -3648		, y = 318	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Coilfang Reservoir"]			, linkID = nil		, continent = 530	, zoneID = 467		, x = 562		, y = 6942	, texture = rdTex		, desc = L["Serpentshrine Cavern"] .. ", " .. L["Slave Pens"] .. ",|n" .. L["Steamvault"] .. ", " .. L["Underbog"]},
				{category = "ShowDungeonLocs"		, name = L["Gruul's Lair"]					, linkID = 776		, continent = 530	, zoneID = 475		, x = 3530		, y = 5121	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Hellfire Ramparts"]				, linkID = 797		, continent = 530	, zoneID = 465		, x = -363		, y = 3078	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Magtheridon's Lair"]			, linkID = 779		, continent = 530	, zoneID = 465		, x = -339		, y = 3132	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Mana-Tombs"]					, linkID = 732		, continent = 530	, zoneID = 478		, x = -3168		, y = 4943	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Sethekk Halls"]					, linkID = 723		, continent = 530	, zoneID = 478		, x = -3362		, y = 4750	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Shadow Labyrinth"]				, linkID = 724		, continent = 530	, zoneID = 478		, x = -3554		, y = 4943	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Arcatraz"]					, linkID = 731		, continent = 530	, zoneID = 479		, x = 3309		, y = 1337	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Blood Furnace"]				, linkID = 725		, continent = 530	, zoneID = 465		, x = -301		, y = 3160	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Botanica"]					, linkID = 729		, continent = 530	, zoneID = 479		, x = 3409		, y = 1486	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Eye"]						, linkID = 782		, continent = 530	, zoneID = 479		, x = 3087		, y = 1379	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["The Mechanar"]					, linkID = 730		, continent = 530	, zoneID = 479		, x = 2865		, y = 1549	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Shattered Halls"]			, linkID = 710		, continent = 530	, zoneID = 465		, x = -309		, y = 3076	, texture = dnTex		, desc = L["Dungeon"]},

				-- Dungeons: Northrend
				{category = "ShowDungeonLocs"		, name = L["Azjol-Nerub"]					, linkID = nil		, continent = 571	, zoneID = 488		, x = 3727		, y = 2152	, texture = dnTex		, desc = L["Azjol-Nerub"] .. ", " .. L["The Old Kingdom"]},
				{category = "ShowDungeonLocs"		, name = L["Drak'Tharon Keep"]				, linkID = 534		, continent = 571	, zoneID = 490		, x = 4574		, y = -2029	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Drak'Tharon Keep"]				, linkID = 534		, continent = 571	, zoneID = 496		, x = 4882		, y = -2046	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Gundrak"]						, linkID = 530		, continent = 571	, zoneID = 496		, x = 6965		, y = -4407	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Gundrak (rear entrance)"]		, linkID = 530		, continent = 571	, zoneID = 496		, x = 6709		, y = -4654	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Halls of Lightning"]			, linkID = 525		, continent = 571	, zoneID = 495		, x = 9176		, y = -1377	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Halls of Stone"]				, linkID = 526		, continent = 571	, zoneID = 495		, x = 8922		, y = -979	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Icecrown Citadel"]				, linkID = 604		, continent = 571	, zoneID = 492		, x = 5855		, y = 2103	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Naxxramas"]						, linkID = 535		, continent = 571	, zoneID = 488		, x = 3668		, y = -1260	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["The Frozen Halls"]				, linkID = nil		, continent = 571	, zoneID = 492		, x = 5691		, y = 2143	, texture = dnTex		, desc = L["The Forge of Souls"] .. ", " .. L["The Pit of Saron"] .. ",|n" .. L["The Halls of Reflection"]},
				{category = "ShowDungeonLocs"		, name = L["The Nexus"]						, linkID = nil		, continent = 571	, zoneID = 486		, x = 3864		, y = 6986	, texture = rdTex		, desc = L["The Nexus"] .. ", " .. L["The Oculus"] .. ",|n" .. L["The Eye of Eternity"]},
				{category = "ShowDungeonLocs"		, name = L["The Violet Hold"]				, linkID = 536		, continent = 571	, zoneID = 504		, x = 5690		, y = 500	, texture = dnTex		, desc = L["Dungeon"], level = 1},
				{category = "ShowDungeonLocs"		, name = L["Trial of the Champion"]			, linkID = 542		, continent = 571	, zoneID = 492		, x = 8571		, y = 792	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Trial of the Crusader"]			, linkID = 543		, continent = 571	, zoneID = 492		, x = 8515		, y = 733	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Ulduar"]						, linkID = 529		, continent = 571	, zoneID = 495		, x = 9348		, y = -1114	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Utgarde Keep"]					, linkID = 523		, continent = 571	, zoneID = 491		, x = 1101		, y = -4903	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Utgarde Pinnacle"]				, linkID = 524		, continent = 571	, zoneID = 491		, x = 1240		, y = -4857	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Vault of Archavon"]				, linkID = 532		, continent = 571	, zoneID = 501		, x = 5377		, y = 2840	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Wyrmrest Temple"]				, linkID = nil		, continent = 571	, zoneID = 488		, x = 3672		, y = 289	, texture = rdTex		, desc = L["The Ruby Sanctum"] .. ", " .. L["The Obsidian Sanctum"]},

				-- Dungeons: Deepholm
				{category = "ShowDungeonLocs"		, name = L["The Stonecore"]					, linkID = 768		, continent = 646	, zoneID = 640		, x = 1024		, y = 637	, texture = dnTex		, desc = L["Dungeon"]},

				-- Dungeons: Pandaria
				{category = "ShowDungeonLocs"		, name = L["Gate of the Setting Sun"]		, linkID = 875		, continent = 870	, zoneID = 811		, x = 694		, y = 2080	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Heart of Fear"]					, linkID = 897		, continent = 870	, zoneID = 858		, x = 166		, y = 4060	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Mogu'shan Palace"]				, linkID = 885		, continent = 870	, zoneID = 811		, x = 1392		, y = 436	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Mogu'shan Vaults"]				, linkID = 896		, continent = 870	, zoneID = 809		, x = 3982		, y = 1109	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Shado-Pan Monastery"]			, linkID = 877		, continent = 870	, zoneID = 809		, x = 3636		, y = 2536	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Siege of Niuzao Temple"]		, linkID = 887		, continent = 870	, zoneID = 810		, x = 1435		, y = 5086	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Siege of Orgrimmar"]			, linkID = 953		, continent = 870	, zoneID = 811		, x = 1203		, y = 644	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Stormstout Brewery"]			, linkID = 876		, continent = 870	, zoneID = 807		, x = -712		, y = 1263	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Temple of the Jade Serpent"]	, linkID = 867		, continent = 870	, zoneID = 806		, x = 960		, y = -2468	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Terrace of Endless Spring"]		, linkID = 886		, continent = 870	, zoneID = 873		, x = 955		, y = -56	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Throne of Thunder"]				, linkID = 930		, continent = 1064	, zoneID = 928		, x = 7253		, y = 5026	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Throne of Thunder"]				, linkID = 930		, continent = 870	, zoneID = 810		, x = 1926		, y = 4222	, texture = rdTex		, desc = L["Portal"], reqQuest = 32681}, -- Alliance
				{category = "ShowDungeonLocs"		, name = L["Throne of Thunder"]				, linkID = 930		, continent = 870	, zoneID = 810		, x = 1926		, y = 4222	, texture = rdTex		, desc = L["Portal"], reqQuest = 32680}, -- Horde

				-- Throne of Thunder
				{category = "ShowDungeonLocs"		, name = L["Eternal Guardian"]				, linkID = nil		, continent = 1098	, zoneID = 930		, x = 6288		, y = 4922	, texture = "Interface\\MINIMAP\\TempleofKotmogu_ball_orange", level = 3},
				{category = "ShowDungeonLocs"		, name = L["Eternal Guardian"]				, linkID = nil		, continent = 1098	, zoneID = 930		, x = 6110		, y = 4670	, texture = "Interface\\MINIMAP\\TempleofKotmogu_ball_orange", level = 3},
				{category = "ShowDungeonLocs"		, name = L["Eternal Guardian"]				, linkID = nil		, continent = 1098	, zoneID = 930		, x = 6495		, y = 4741	, texture = "Interface\\MINIMAP\\TempleofKotmogu_ball_orange", level = 3},

				-- Dungeons: Draenor
				{category = "ShowDungeonLocs"		, name = L["Auchindoun"]					, linkID = 984		, continent = 1116	, zoneID = 946		, x = 1489		, y = 3079	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Blackrock Foundry"]				, linkID = 988		, continent = 1116	, zoneID = 949		, x = 8029		, y = 870	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Bloodmaul Slag Mines"]			, linkID = 964		, continent = 1116	, zoneID = 941		, x = 7266		, y = 4458	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Grimrail Depot"]				, linkID = 993		, continent = 1116	, zoneID = 949		, x = 7840		, y = 551	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Hellfire Citadel"]				, linkID = 1026		, continent = 1116	, zoneID = 945		, x = 4058		, y = -683	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Highmaul"]						, linkID = 994		, continent = 1116	, zoneID = 950		, x = 3471		, y = 7434	, texture = rdTex		, desc = L["Raid"]},
				{category = "ShowDungeonLocs"		, name = L["Iron Docks"]					, linkID = 987		, continent = 1116	, zoneID = 949		, x = 8854		, y = 1359	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Shadowmoon Burial Grounds"]		, linkID = 969		, continent = 1116	, zoneID = 947		, x = 766		, y = 128	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["Skyreach"]						, linkID = 989		, continent = 1116	, zoneID = 948		, x = 27		, y = 2525	, texture = dnTex		, desc = L["Dungeon"]},
				{category = "ShowDungeonLocs"		, name = L["The Everbloom"]					, linkID = 1008		, continent = 1116	, zoneID = 949		, x = 7110		, y = 197	, texture = dnTex		, desc = L["Dungeon"]},

				-- Dungeons: Legion
				{category = "ShowDungeonLocs"		, name = L["Violet Hold"]					, linkID = 1066		, continent = 1220	, zoneID = 1014		, x = -959		, y = 4328	, texture = dnTex		, desc = L["Dungeon"], level = 10},

			}

			local btnTable = {}

			-- POI is shown if the following conditions are met:
			-- 1. If reqQuest is present, player must have completed quest with that ID
			-- 2. If remQuest is present, player must not have completed quest with that ID
			-- 3. If level is present, map must be showing that level
			-- 4. If level is not present, map must be showing level 0

			-- Map IDs
			-- https://wow.gamepedia.com/MapID#Eastern_Kingdoms

			local function mapPOIfunc()
				if WorldMapFrame:IsShown() then
					local worldMapID = GetCurrentMapAreaID()
					local mapID = GetAreaMapInfo(worldMapID)
					for k, v in pairs(pTable) do
						if worldMapID == v.zoneID and mapID == v.continent then
							-- Create POI button if required
							if not btnTable[k] then
								local button = CreateFrame("Button", nil, WorldMapPOIFrame)
								btnTable[k] = button
								button:SetSize(20, 20)
								button.Texture = button:CreateTexture(btnTable[k.."Texture"], "BACKGROUND")
								button.Texture:ClearAllPoints()
								button.Texture:SetPoint("CENTER", button)
								button.Texture:SetTexture(v.texture)
								button.Texture:SetTexCoord(0, 1, 0, 1)
								button.Texture:SetSize(30, 30)
								if v.linkID then button:SetHighlightTexture(v.texture) end
								button.HighlightTexture = button:CreateTexture(btnTable[k .. "HighlightTexture"], "HIGHLIGHT")
								button:SetScript("OnEnter", WorldMapPOI_OnEnter)
								button:SetScript("OnLeave", WorldMapPOI_OnLeave)
								button:SetScript("OnClick", function()
									if v.linkID then
										local id, level = strsplit("。", v.linkID)
										SetMapByID(id)
										if level then SetDungeonMapLevel(level) end
									end
								end)
								button.name = v.name
								button.poiID = 0
								button.description = v.desc
							end
							-- Calculate screen coordinates from world coordinates
							local void, locLeft, locTop, locRight, locBottom = GetCurrentMapZone()
							if locLeft and locTop and locRight and locBottom then
								-- Show or hide POI button
								local currLevel, minY, minX, maxY, maxX = GetCurrentMapDungeonLevel()
								if LeaPlusLC[v.category] == "On" and (not v.reqQuest or IsQuestFlaggedCompleted(v.reqQuest)) and (not v.remQuest or not IsQuestFlaggedCompleted(v.remQuest)) and (not v.level and currLevel == 0 or v.level and v.level == currLevel) then
									if minY and minX and maxY and maxX then
										WorldMapPOIFrame_AnchorPOI(btnTable[k], (maxY - v.y) / abs(maxY - minY), (maxX - v.x) / abs(maxX - minX), 201)
									else
										WorldMapPOIFrame_AnchorPOI(btnTable[k], (locLeft - v.y) / abs(locRight - locLeft), (locTop - v.x) / abs(locBottom - locTop), 201)
									end
									btnTable[k]:Show()
								else
									btnTable[k]:Hide()
								end
							end
						else
							-- Wrong zone, hide POI button
							if btnTable[k] and btnTable[k]:IsShown() then
								btnTable[k]:Hide()
							end
						end
					end
				end
			end

			hooksecurefunc("WorldMapFrame_Update", mapPOIfunc)

			----------------------------------------------------------------------
			-- Configuration panel
			----------------------------------------------------------------------

			-- Create configuration panel
			local MapPanel = LeaPlusLC:CreatePanel("World Map", "MapPanel")

			LeaPlusLC:MakeTx(MapPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(MapPanel, "RevealWorldMap", "Reveal unexplored areas of the map", 16, -92, false, "If checked, unexplored areas of the map will be revealed.")
			LeaPlusLC:MakeCB(MapPanel, "ShowRevealBox", "Show reveal checkbox at the top of the map", 16, -112, false, "If checked, a checkbox will be shown at the top of the map which will allow you to toggle unexplored areas directly from the map frame.")
			LeaPlusLC:MakeCB(MapPanel, "WorldMapCoords", "Show cursor coordinates at the top of the map", 16, -132, false, "If checked, cursor coordinates will be shown at the top of the map.")
			LeaPlusLC:MakeCB(MapPanel, "FadeMap", "Fade windowed map while moving", 16, -152, false, "If checked, the windowed map will fade while your character is moving and the cursor is not over the map.")
			LeaPlusLC:MakeCB(MapPanel, "ShowSuramarPortals", "Show portals for Suramar and Ashran", 16, -172, false, "If checked, portals for Suramar (Broken Isles) and Ashran (Draenor) will be shown.")
			LeaPlusLC:MakeCB(MapPanel, "ShowDungeonLocs", "Show older dungeon and raid locations", 16, -192, false, "If checked, dungeon and raid locations will be shown for all game expansions up to and including Warlords of Draenor.|n|nLegion dungeon and raid locations are managed by the default user interface.")

			-- Help button hidden
			MapPanel.h:Hide()

			-- Back button handler
			MapPanel.b:SetScript("OnClick", function() 
				MapPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show();
				return
			end)

			-- Create reveal checkbox
			local RevBox = CreateFrame('CheckButton', nil, WorldMapFrame.BorderFrame, "OptionsCheckButtonTemplate")
			RevBox:ClearAllPoints(); RevBox:SetPoint("TOPRIGHT", -130, 0); RevBox:SetSize(24, 24)
			RevBox.f = RevBox:CreateFontString(nil, 'OVERLAY', "GameFontNormal"); RevBox.f:SetPoint("LEFT", 24, 0);
			RevBox.f:SetText(L["Reveal"]); RevBox:SetHitRectInsets(0, 0 - RevBox.f:GetWidth(), 0, 0);

			-- Reposition checkbox so the label fits with translations
			RevBox:ClearAllPoints()
			RevBox:SetPoint("TOPRIGHT", WorldMapFrame.BorderFrame, "TOPRIGHT", -RevBox.f:GetStringWidth()-87, 0)

			-- Function to set options
			local function SetWorldMapOptions()
				-- Show or hide coordinates
				if LeaPlusLC["WorldMapCoords"] == "On" then	Cmap:Show()	else Cmap:Hide() end
				-- Set map fade
				if LeaPlusLC["FadeMap"] == "On" then	
					SetCVar("mapFade", "1")
				else
					SetCVar("mapFade", "0")
				end
				-- Reveal world map
				if LeaPlusLC["RevealWorldMap"] == "On" then	
					RevBox:SetChecked(true)
					if WorldMapFrame:IsShown() then
						RefMap()
					end
				else
					RevBox:SetChecked(false)
					if texcount > 0 then
						for i = 1, texcount do MapTex[i]:Hide()	end
						texcount = 0
					end
				end
				-- Show or hide reveal checkbox
				if LeaPlusLC["ShowRevealBox"] == "On" then RevBox:Show() else RevBox:Hide()	end
				-- Show or hide Suramar portals
				mapPOIfunc()
			end

			-- Run function when options are clicked and on startup
			LeaPlusCB["RevealWorldMap"]:HookScript("OnClick", SetWorldMapOptions)
			LeaPlusCB["ShowRevealBox"]:HookScript("OnClick", SetWorldMapOptions)
			LeaPlusCB["WorldMapCoords"]:HookScript("OnClick", SetWorldMapOptions)
			LeaPlusCB["FadeMap"]:HookScript("OnClick", SetWorldMapOptions)
			LeaPlusCB["ShowSuramarPortals"]:HookScript("OnClick", SetWorldMapOptions)
			LeaPlusCB["ShowDungeonLocs"]:HookScript("OnClick", SetWorldMapOptions)
			SetWorldMapOptions()

			-- Reset button handler
			MapPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["RevealWorldMap"] = "On"
				LeaPlusLC["ShowRevealBox"] = "On"
				LeaPlusLC["WorldMapCoords"] = "On"
				LeaPlusLC["FadeMap"] = "Off"
				LeaPlusLC["ShowSuramarPortals"] = "On"
				LeaPlusLC["ShowDungeonLocs"] = "On"
				SetWorldMapOptions()

				-- Refresh configuration panel
				MapPanel:Hide(); MapPanel:Show();

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["EnhanceMapButton"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["RevealWorldMap"] = "On"
					LeaPlusLC["ShowRevealBox"] = "On"
					LeaPlusLC["WorldMapCoords"] = "On"
					LeaPlusLC["FadeMap"] = "Off"
					LeaPlusLC["ShowSuramarPortals"] = "On"
					LeaPlusLC["ShowDungeonLocs"] = "On"
					SetWorldMapOptions()
				else
					MapPanel:Show();
					LeaPlusLC:HideFrames();
				end
			end);

			-- Reveal checkbox click handler
			RevBox:SetScript("OnClick", function()
				-- Set options panel setting according to map checkbox
				if RevBox:GetChecked() then
					LeaPlusLC["RevealWorldMap"] = "On"
				else
					LeaPlusLC["RevealWorldMap"] = "Off"
				end
				-- Refresh options panel if its showing
				if LeaPlusCB["RevealWorldMap"]:IsShown() then
					LeaPlusCB["RevealWorldMap"]:Hide(); LeaPlusCB["RevealWorldMap"]:Show();
				end
				SetWorldMapOptions()
			end)

		end

		----------------------------------------------------------------------
		-- Show volume control on character sheet
		----------------------------------------------------------------------

		if LeaPlusLC["ShowVolume"] == "On" then

			-- Function to update master volume
			local function MasterVolUpdate()
				if LeaPlusLC["ShowVolume"] == "On" then
					-- Set the volume
					SetCVar("Sound_MasterVolume", LeaPlusLC["LeaPlusMaxVol"]);
					-- Format the slider text
					LeaPlusCB["LeaPlusMaxVol"].f:SetFormattedText("%.0f", LeaPlusLC["LeaPlusMaxVol"] * 20)
				end
			end

			-- Create slider control
			LeaPlusLC["LeaPlusMaxVol"] = tonumber(GetCVar("Sound_MasterVolume"));
			LeaPlusLC:MakeSL(CharacterModelFrame, "LeaPlusMaxVol", "",	0, 1, 0.05, -34, -328, "%.2f")
			LeaPlusCB["LeaPlusMaxVol"]:SetWidth(64)

			-- Set slider control value when shown
			LeaPlusCB["LeaPlusMaxVol"]:SetScript("OnShow", function()
				LeaPlusCB["LeaPlusMaxVol"]:SetValue(GetCVar("Sound_MasterVolume"))
			end)

			-- Update volume when slider control is changed
			LeaPlusCB["LeaPlusMaxVol"]:HookScript("OnValueChanged", function()
				if IsMouseButtonDown("RightButton") and IsShiftKeyDown() then 
					-- Dual layout is active so don't adjust slider
					LeaPlusCB["LeaPlusMaxVol"].f:SetFormattedText("%.0f", LeaPlusLC["LeaPlusMaxVol"] * 20)
					LeaPlusCB["LeaPlusMaxVol"]:Hide()
					LeaPlusCB["LeaPlusMaxVol"]:Show()
					return
				else
					-- Set sound level and refresh slider
					MasterVolUpdate()
				end
			end)

			-- Dual layout
			local function SetVolumePlacement()
				if LeaPlusLC["ShowVolumeInFrame"] == "On" then
					LeaPlusCB["LeaPlusMaxVol"]:ClearAllPoints();
					LeaPlusCB["LeaPlusMaxVol"]:SetPoint("TOPLEFT", 72, -276)
				else
					LeaPlusCB["LeaPlusMaxVol"]:ClearAllPoints();
					LeaPlusCB["LeaPlusMaxVol"]:SetPoint("TOPLEFT", -34, -328)
				end
			end

			LeaPlusCB["LeaPlusMaxVol"]:SetScript('OnMouseDown', function(self, btn)
				if btn == "RightButton" and IsShiftKeyDown() then
					if LeaPlusLC["ShowVolumeInFrame"] == "On" then LeaPlusLC["ShowVolumeInFrame"] = "Off" else LeaPlusLC["ShowVolumeInFrame"] = "On" end
					SetVolumePlacement();
				end
			end)

			CharacterModelFrame:HookScript("OnShow",function()
				SetVolumePlacement();
			end)

		end

		----------------------------------------------------------------------
		--	Use arrow keys in chat
		----------------------------------------------------------------------

		if LeaPlusLC["UseArrowKeysInChat"] == "On" then
			-- Enable arrow keys for normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i .. "EditBox"]:SetAltArrowKeyMode(false)
				end
			end
			-- Enable arrow keys for temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf .. "EditBox"]:SetAltArrowKeyMode(false)
				end
			end)
		end

		----------------------------------------------------------------------
		-- Unclamp chat frame
		----------------------------------------------------------------------

		if LeaPlusLC["UnclampChat"] == "On" then

			-- Process normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then 
					_G["ChatFrame" .. i]:SetClampRectInsets(0, 0, 0, 0);
				end
			end

			-- Process temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf]:SetClampRectInsets(0, 0, 0, 0);
				end
			end)

		end

		----------------------------------------------------------------------
		-- Hide social button
		----------------------------------------------------------------------

		if LeaPlusLC["NoSocialButton"] == "On" then
			-- Create hidden frame to store social button
			local tframe = CreateFrame("FRAME")
			tframe:Hide()
			QuickJoinToastButton:SetParent(tframe)
		end

		----------------------------------------------------------------------
		-- Hide chat buttons
		----------------------------------------------------------------------

		if LeaPlusLC["NoChatButtons"] == "On" then

			-- Create hidden frame to store unwanted frames (more efficient than creating functions)
			local tframe = CreateFrame("FRAME")
			tframe:Hide()

			-- Disable integrated mouse scrolling to avoid conflicts
			SetCVar("chatMouseScroll", "0")

			-- Function to enable mouse scrolling with CTRL and SHIFT key modifiers
			local function AddMouseScroll(chtfrm)
				if _G[chtfrm] then
					_G[chtfrm]:SetScript("OnMouseWheel", function(self, direction)
						if direction == 1 then
							if IsControlKeyDown() then
								self:ScrollToTop()
							elseif IsShiftKeyDown() then
								self:PageUp()
							else
								self:ScrollUp()
							end
						else
							if IsControlKeyDown() then
								self:ScrollToBottom()
							elseif IsShiftKeyDown() then
								self:PageDown()
							else
								self:ScrollDown()
							end
						end
					end)
					_G[chtfrm]:EnableMouseWheel(true)
				end
			end

			-- Function to hide chat buttons
			local function HideButtons(chtfrm)
				_G[chtfrm .. "ButtonFrameUpButton"]:SetParent(tframe)
				_G[chtfrm .. "ButtonFrameDownButton"]:SetParent(tframe)
				_G[chtfrm .. "ButtonFrameMinimizeButton"]:SetParent(tframe)
				_G[chtfrm .. "ButtonFrameUpButton"]:Hide();
				_G[chtfrm .. "ButtonFrameDownButton"]:Hide();
				_G[chtfrm .. "ButtonFrameMinimizeButton"]:Hide();
				_G[chtfrm .. "ButtonFrame"]:SetSize(0.1,0.1)
			end

			-- Function to highlight chat tabs and click to scroll to bottom
			local function HighlightTabs(chtfrm)
				-- Set position of bottom button
				_G[chtfrm .. "ButtonFrameBottomButtonFlash"]:SetTexture("Interface/BUTTONS/GRADBLUE.png")
				_G[chtfrm .. "ButtonFrameBottomButton"]:ClearAllPoints()
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetPoint("BOTTOM",_G[chtfrm .. "Tab"],0,-6)
				_G[chtfrm .. "ButtonFrameBottomButton"]:Show()
				_G[chtfrm .. "ButtonFrameBottomButtonFlash"]:SetAlpha(0.5)
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetWidth(_G[chtfrm .. "Tab"]:GetWidth()-10)
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetHeight(24)

				-- Resize bottom button according to tab size
				_G[chtfrm .. "Tab"]:SetScript("OnSizeChanged", function()
					for j = 1, 50 do
						-- Resize bottom button to tab width
						if _G["ChatFrame" .. j .. "ButtonFrameBottomButton"] then
							_G["ChatFrame" .. j .. "ButtonFrameBottomButton"]:SetWidth(_G["ChatFrame" .. j .. "Tab"]:GetWidth()-10)
						end
					end
					-- If combat log is hidden, resize it's bottom button
					if LeaPlusLC["NoCombatLogTab"] == "On" then
						if _G["ChatFrame2ButtonFrameBottomButton"] then
							-- Resize combat log bottom button
							_G["ChatFrame2ButtonFrameBottomButton"]:SetWidth(0.1);
						end
					end
				end)

				-- Remove click from the bottom button
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetScript("OnClick", nil)

				-- Remove textures
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetNormalTexture("")
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetHighlightTexture("")
				_G[chtfrm .. "ButtonFrameBottomButton"]:SetPushedTexture("")

				-- Always scroll to bottom when clicking a tab
				_G[chtfrm .. "Tab"]:HookScript("OnClick", function(self,arg1)
					if arg1 == "LeftButton" then
						_G[chtfrm]:ScrollToBottom();
					end
				end)

			end

			-- Hide chat menu button
			ChatFrameMenuButton:SetParent(tframe)

			-- Set options for normal and existing chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					AddMouseScroll("ChatFrame" .. i);
					HideButtons("ChatFrame" .. i);
					HighlightTabs("ChatFrame" .. i)
				end
			end

			-- Do the functions above for temporary chat frames
			hooksecurefunc("FCF_OpenTemporaryWindow", function(chatType)
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					-- Set options for temporary frame
					AddMouseScroll(cf)
					HideButtons(cf)
					HighlightTabs(cf)
					-- Resize flashing alert to match tab width
					_G[cf .. "Tab"]:SetScript("OnSizeChanged", function()
						_G[cf .. "ButtonFrameBottomButton"]:SetWidth(_G[cf .. "Tab"]:GetWidth()-10)
					end)
				end
			end)

		end

		----------------------------------------------------------------------
		-- L41: Manage buff frame
		----------------------------------------------------------------------

		if LeaPlusLC["ManageBuffFrame"] == "On" then

			-- Replace frame movement function
			local buffSetPos = BuffFrame.SetPoint

			-- Set buff frame position at startup
			BuffFrame:ClearAllPoints()
			buffSetPos(BuffFrame, LeaPlusLC["BuffFrameA"], UIParent, LeaPlusLC["BuffFrameR"], LeaPlusLC["BuffFrameX"], LeaPlusLC["BuffFrameY"])
			BuffFrame:SetScale(LeaPlusLC["BuffFrameScale"])
			TemporaryEnchantFrame:SetScale(LeaPlusLC["BuffFrameScale"])

			-- Prevent changes to buff frame position
			hooksecurefunc(BuffFrame, "SetPoint", function()
				BuffFrame:ClearAllPoints()
				buffSetPos(BuffFrame, LeaPlusLC["BuffFrameA"], UIParent, LeaPlusLC["BuffFrameR"], LeaPlusLC["BuffFrameX"], LeaPlusLC["BuffFrameY"])
			end)

			-- Allow buff frame to be moved
			BuffFrame:SetMovable(true)
			BuffFrame:SetClampedToScreen(true)

			-- Create drag frame
			local dragframe = CreateFrame("FRAME")
			dragframe:SetPoint("TOPRIGHT", BuffFrame, "TOPRIGHT", 0, 2.5)
			dragframe:SetBackdropColor(0.0, 0.5, 1.0)
			dragframe:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", tile = false, tileSize = 0, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
			dragframe:SetToplevel(true)
			dragframe:Hide()
			dragframe:SetScale(LeaPlusLC["BuffFrameScale"])

			dragframe.t = dragframe:CreateTexture()
			dragframe.t:SetAllPoints()
			dragframe.t:SetColorTexture(0.0, 1.0, 0.0, 0.5)
			dragframe.t:SetAlpha(0.5)

			dragframe.f = dragframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
			dragframe.f:SetPoint('CENTER', 0, 0)
			dragframe.f:SetText(L["Buffs"])

			-- Click handler
			dragframe:SetScript("OnMouseDown", function(self, btn)
				-- Start dragging if left clicked
				if btn == "LeftButton" then
					BuffFrame:StartMoving()
				end
			end)

			dragframe:SetScript("OnMouseUp", function()
				-- Save frame positions
				BuffFrame:StopMovingOrSizing()
				LeaPlusLC["BuffFrameA"], void, LeaPlusLC["BuffFrameR"], LeaPlusLC["BuffFrameX"], LeaPlusLC["BuffFrameY"] = BuffFrame:GetPoint()
				BuffFrame:SetUserPlaced(false)
			end)

			-- Create configuration panel
			local BuffPanel = LeaPlusLC:CreatePanel("Buff Frame", "BuffPanel")

			LeaPlusLC:MakeTx(BuffPanel, "Scale", 16, -72)
			LeaPlusLC:MakeSL(BuffPanel, "BuffFrameScale", "", 0.5, 2, 0.05, 16, -92, "%.2f")

			-- Set scale when slider is changed
			LeaPlusCB["BuffFrameScale"]:HookScript("OnValueChanged", function()
				BuffFrame:SetScale(LeaPlusLC["BuffFrameScale"])
				TemporaryEnchantFrame:SetScale(LeaPlusLC["BuffFrameScale"])
				dragframe:SetScale(LeaPlusLC["BuffFrameScale"])
				-- Show formatted slider value
				LeaPlusCB["BuffFrameScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["BuffFrameScale"] * 100)
			end)

			-- Help button tooltip
			BuffPanel.h.tiptext = L["Drag the frame overlay to position the frame."]

			-- Back button handler
			BuffPanel.b:SetScript("OnClick", function()
				BuffPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page6"]:Show()
				return
			end)

			-- Reset button handler
			BuffPanel.r:SetScript("OnClick", function()

				-- Reset position and scale
				LeaPlusLC["BuffFrameA"] = "TOPRIGHT"
				LeaPlusLC["BuffFrameR"] = "TOPRIGHT"
				LeaPlusLC["BuffFrameX"] = -205
				LeaPlusLC["BuffFrameY"] = -13
				LeaPlusLC["BuffFrameScale"] = 1
				BuffFrame:ClearAllPoints()
				buffSetPos(BuffFrame, LeaPlusLC["BuffFrameA"], UIParent, LeaPlusLC["BuffFrameR"], LeaPlusLC["BuffFrameX"], LeaPlusLC["BuffFrameY"])

				-- Refresh configuration panel
				BuffPanel:Hide(); BuffPanel:Show()
				dragframe:Show()

			end)

			-- Show configuration panel when options panel button is clicked
			LeaPlusCB["ManageBuffBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["BuffFrameA"] = "TOPRIGHT"
					LeaPlusLC["BuffFrameR"] = "TOPRIGHT"
					LeaPlusLC["BuffFrameX"] = -271
					LeaPlusLC["BuffFrameY"] = 0
					LeaPlusLC["BuffFrameScale"] = 0.80
					BuffFrame:ClearAllPoints()
					buffSetPos(BuffFrame, LeaPlusLC["BuffFrameA"], UIParent, LeaPlusLC["BuffFrameR"], LeaPlusLC["BuffFrameX"], LeaPlusLC["BuffFrameY"])
					BuffFrame:SetScale(LeaPlusLC["BuffFrameScale"])
					TemporaryEnchantFrame:SetScale(LeaPlusLC["BuffFrameScale"])
				else
					-- Find out if the UI has a non-standard scale
					if GetCVar("useuiscale") == "1" then
						LeaPlusLC["gscale"] = GetCVar("uiscale")
					else
						LeaPlusLC["gscale"] = 1
					end

					-- Set drag frame size according to UI scale
					dragframe:SetWidth(280 * LeaPlusLC["gscale"])
					dragframe:SetHeight(225 * LeaPlusLC["gscale"])

					-- Show configuration panel
					BuffPanel:Show()
					LeaPlusLC:HideFrames()
					dragframe:Show()
				end
			end)

			-- Hide drag frame when configuration panel is closed
			BuffPanel:HookScript("OnHide", function() dragframe:Hide() end)

		end

		----------------------------------------------------------------------
		-- L42: Manage frames
		----------------------------------------------------------------------

		-- Frame Movement
		if LeaPlusLC["FrmEnabled"] == "On" then

			-- Lock the player and target frames
			PlayerFrame_SetLocked(true)
			TargetFrame_SetLocked(true)

			-- Remove integrated movement functions to avoid conflicts
			_G.PlayerFrame_ResetUserPlacedPosition = function() LeaPlusLC:Print("Use Leatrix Plus to reset that frame.") end
			_G.TargetFrame_ResetUserPlacedPosition = function() LeaPlusLC:Print("Use Leatrix Plus to reset that frame.") end
			_G.PlayerFrame_SetLocked = function() LeaPlusLC:Print("Use Leatrix Plus to move that frame.") end
			_G.TargetFrame_SetLocked = function() LeaPlusLC:Print("Use Leatrix Plus to move that frame.") end

			-- Create frame table (used for local traversal)
			local FrameTable = {DragPlayerFrame = PlayerFrame, DragTargetFrame = TargetFrame, DragWorldStateAlwaysUpFrame = WorldStateAlwaysUpFrame, DragGhostFrame = GhostFrame, DragMirrorTimer1 = MirrorTimer1};

			-- Create main table structure in saved variables if it doesn't exist
			if (LeaPlusDB["Frames"]) == nil then
				LeaPlusDB["Frames"] = {}
			end

			-- Create frame based table structure in saved variables if it doesn't exist and set initial scales
			for k,v in pairs(FrameTable) do
				local vf = v:GetName();
				-- Create frame table structure if it doesn't exist
				if not LeaPlusDB["Frames"][vf] then
					LeaPlusDB["Frames"][vf] = {}
				end
				-- Set saved scale value to default if it doesn't exist
				if not LeaPlusDB["Frames"][vf]["Scale"] then
					LeaPlusDB["Frames"][vf]["Scale"] = 1.00;
				end
				-- Set frame scale to saved value
				_G[vf]:SetScale(LeaPlusDB["Frames"][vf]["Scale"])
			end

			-- Set cached status
			local function LeaPlusFramesSaveCache(frame)
				if frame == "PlayerFrame" or frame == "TargetFrame" then
					_G[frame]:SetUserPlaced(true);
				else
					_G[frame]:SetUserPlaced(false);
				end
			end

			-- Set frames to manual values
			local function LeaFramesSetPos(frame, point, parent, relative, xoff, yoff)
				frame:SetMovable(true);
				frame:ClearAllPoints();
				frame:SetPoint(point, parent, relative, xoff, yoff)
			end

			-- Set frames to default values
			local function LeaPlusFramesDefaults()
				LeaFramesSetPos(PlayerFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	, -19, -4)
				LeaFramesSetPos(TargetFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	, 250, -4)
				LeaFramesSetPos(WorldStateAlwaysUpFrame	, "TOP"		, UIParent, "TOP"		, -5, -15)
				LeaFramesSetPos(GhostFrame				, "TOP"		, UIParent, "TOP"		, -5, -29)
				LeaFramesSetPos(MirrorTimer1			, "TOP"		, UIParent, "TOP"		, -5, -96)
			end

			-- Create frame customisation side panel
			local SideFrames = LeaPlusLC:CreatePanel("Frames", "SideFrames")

			-- Variable used to store currently selected frame
			local currentframe

			-- Create scale title
			LeaPlusLC:MakeTx(SideFrames, "Scale", 16, -72)
			
			-- Set initial slider value (will be changed when drag frames are selected)
			LeaPlusLC["FrameScale"] = 1.00;

			-- Create scale slider
			LeaPlusLC:MakeSL(SideFrames, "FrameScale", "", 0.5, 3.0, 0.05, 16, -92, "%.2f")
			LeaPlusCB["FrameScale"]:HookScript("OnValueChanged", function(self, value)
				if currentframe then -- If a frame is selected
					-- Set real and drag frame scale
					LeaPlusDB["Frames"][currentframe]["Scale"] = value;
					_G[currentframe]:SetScale(LeaPlusDB["Frames"][currentframe]["Scale"]);
					LeaPlusLC["Drag" .. currentframe]:SetScale(LeaPlusDB["Frames"][currentframe]["Scale"]);
					-- If target frame scale is changed, also change combo point frame
					if currentframe == "TargetFrame" then
						ComboFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
					end
					-- Set slider formatted text
					LeaPlusCB["FrameScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["FrameScale"] * 100)
				end
			end)

			-- Set initial scale slider state and value
			LeaPlusCB["FrameScale"]:HookScript("OnShow", function()
				if not currentframe then
					-- No frame selected so select the player frame
					currentframe = PlayerFrame:GetName()
					LeaPlusLC["DragPlayerFrame"].t:SetColorTexture(0.0, 1.0, 0.0,0.5)
				end
				-- Set the scale slider value to the selected frame
				LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"])
				-- Set slider formatted text
				LeaPlusCB["FrameScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["FrameScale"] * 100)
			end)

			-- Help button tooltip
			SideFrames.h.tiptext = L["Drag the frame overlays to position the frames.|n|nTo change the scale of a frame, click it to select it then adjust the scale slider.|n|nThis panel will close automatically if you enter combat."]

			-- Back button handler
			SideFrames.b:SetScript("OnClick", function()
				-- Hide outer control frame
				SideFrames:Hide();
				-- Hide drag frames
				for k, void in pairs(FrameTable) do
					LeaPlusLC[k]:Hide();
				end
				-- Show options panel at frame section
				LeaPlusLC["PageF"]:Show();
				LeaPlusLC["Page6"]:Show();
			end) 

			-- Reset button handler
			SideFrames.r:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					-- If player is in combat, print error and stop
					return
				else
					-- Set frames to default positions (presets)
					LeaPlusFramesDefaults();
					for k,v in pairs(FrameTable) do
						local vf = v:GetName()
						-- Store frame locations
						LeaPlusDB["Frames"][vf]["Point"], void, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"] = _G[vf]:GetPoint();
						-- Reset real frame scales and save them
						LeaPlusDB["Frames"][vf]["Scale"] = 1.00;
						_G[vf]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
						-- Reset drag frame scales
						LeaPlusLC[k]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
					end
					-- Set combo frame scale to match target frame scale
					ComboFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
					-- Set the scale slider value to the selected frame scale
					LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"]);
					-- Refresh the panel
					SideFrames:Hide();SideFrames:Show();
				end
			end)

			-- Show drag frames with configuration panel
			SideFrames:HookScript("OnShow", function()
				for k, void in pairs(FrameTable) do
					LeaPlusLC[k]:Show();
				end
			end)
			SideFrames:HookScript("OnHide", function()
				for k, void in pairs(FrameTable) do
					LeaPlusLC[k]:Hide();
				end
			end)

			-- Save frame positions
			local function SaveAllFrames()
				for k, v in pairs(FrameTable) do
					local vf = v:GetName();
					-- Stop real frames from moving
					v:StopMovingOrSizing();
					-- Save frame positions
					LeaPlusDB["Frames"][vf]["Point"], void, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"] = v:GetPoint();
					LeaPlusFramesSaveCache(vf)
				end
			end

			-- Prevent changes during combat
			SideFrames:RegisterEvent("PLAYER_REGEN_DISABLED")
			SideFrames:SetScript("OnEvent", function()
				-- Hide controls frame
				SideFrames:Hide();
				-- Hide drag frames
				for k,void in pairs(FrameTable) do
					LeaPlusLC[k]:Hide();
				end
				-- Save frame positions
				SaveAllFrames();
			end)

			-- Create drag frames
			local function LeaPlusMakeDrag(dragframe,realframe)

				local dragframe = CreateFrame("Frame", nil);
				LeaPlusLC[dragframe] = dragframe
				dragframe:SetSize(realframe:GetSize())
				dragframe:SetPoint("TOP", realframe, "TOP", 0, 2.5)

				dragframe:SetBackdropColor(0.0, 0.5, 1.0);
				dragframe:SetBackdrop({ 
					edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
					tile = false, tileSize = 0, edgeSize = 16,
					insets = { left = 0, right = 0, top = 0, bottom = 0 }});
				dragframe:SetToplevel(true)

				-- Unclamp frame
				realframe:SetClampedToScreen(false)

				-- Hide the drag frame and make real frame movable
				dragframe:Hide()
				realframe:SetMovable(true);

				-- Click handler
				dragframe:SetScript("OnMouseDown", function(self, btn)

					-- Start dragging if left clicked
					if btn == "LeftButton" then
						realframe:StartMoving()
					end

					-- Set all drag frames to blue then tint the selected frame to green
					for k,v in pairs(FrameTable) do
						LeaPlusLC[k].t:SetColorTexture(0.0, 0.5, 1.0, 0.5)
					end
					dragframe.t:SetColorTexture(0.0, 1.0, 0.0, 0.5)

					-- Set currentframe variable to selected frame and set the scale slider value
					currentframe = realframe:GetName();
					LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"]);

				end)

				dragframe:SetScript("OnMouseUp", function()
					-- Save frame positions
					SaveAllFrames();
				end)
	
				dragframe.t = dragframe:CreateTexture()
				dragframe.t:SetAllPoints()
				dragframe.t:SetColorTexture(0.0, 0.5, 1.0, 0.5)
				dragframe.t:SetAlpha(0.5)

				dragframe.f = dragframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
				dragframe.f:SetPoint('CENTER', 0, 0)

				-- Add titles
				if realframe:GetName() == "PlayerFrame" 			then dragframe.f:SetText(L["Player"]) end
				if realframe:GetName() == "TargetFrame" 			then dragframe.f:SetText(L["Target"]) end
				if realframe:GetName() == "WorldStateAlwaysUpFrame" then dragframe.f:SetText(L["World State"]) end
				if realframe:GetName() == "MirrorTimer1" 			then dragframe.f:SetText(L["Timer"]) end
				if realframe:GetName() == "GhostFrame" 				then dragframe.f:SetText(L["Ghost"]) end
				return LeaPlusLC[dragframe]

			end
			
			for k,v in pairs(FrameTable) do
				LeaPlusLC[k] = LeaPlusMakeDrag(k,v)
			end

			-- Set frame scales
			for k,v in pairs(FrameTable) do
				local vf = v:GetName();
				_G[vf]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
				LeaPlusLC[k]:SetScale(LeaPlusDB["Frames"][vf]["Scale"]);
			end
			ComboFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);

			-- Load defaults first then overwrite with saved values if they exist
			LeaPlusFramesDefaults();
			if LeaPlusDB["Frames"] then
				for k,v in pairs(FrameTable) do
					local vf = v:GetName()
					if LeaPlusDB["Frames"][vf] then
						if LeaPlusDB["Frames"][vf]["Point"] and LeaPlusDB["Frames"][vf]["Relative"] and LeaPlusDB["Frames"][vf]["XOffset"] and LeaPlusDB["Frames"][vf]["YOffset"] then
							LeaPlusFramesSaveCache(vf)
							_G[vf]:ClearAllPoints();
							_G[vf]:SetPoint(LeaPlusDB["Frames"][vf]["Point"], UIParent, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"])
						end
					end
				end
			end

			-- Add move button
			LeaPlusCB["MoveFramesButton"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaFramesSetPos(PlayerFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	,	"-35"	, "-14")
						LeaFramesSetPos(TargetFrame				, "TOPLEFT"	, UIParent, "TOPLEFT"	,	"190"	, "-14")
						LeaFramesSetPos(GhostFrame				, "CENTER"	, UIParent, "CENTER"	,	"3"		, "-142")
						LeaFramesSetPos(WorldStateAlwaysUpFrame	, "TOP"		, UIParent, "TOP"		,	"-40"	, "-530")
						LeaFramesSetPos(MirrorTimer1			, "TOP"		, UIParent, "TOP"		,	"0"		, "-120")
						LeaPlusDB["Frames"]["PlayerFrame"]["Scale"] = 1.20;
						PlayerFrame:SetScale(LeaPlusDB["Frames"]["PlayerFrame"]["Scale"]);
						LeaPlusLC["DragPlayerFrame"]:SetScale(LeaPlusDB["Frames"]["PlayerFrame"]["Scale"]);
						LeaPlusDB["Frames"]["TargetFrame"]["Scale"] = 1.20;
						TargetFrame:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
						LeaPlusLC["DragTargetFrame"]:SetScale(LeaPlusDB["Frames"]["TargetFrame"]["Scale"]);
						-- Set the slider to the selected frame (if there is one)
						if currentframe then LeaPlusCB["FrameScale"]:SetValue(LeaPlusDB["Frames"][currentframe]["Scale"]); end
						-- Save locations
						for k,v in pairs(FrameTable) do
							local vf = v:GetName();
							LeaPlusDB["Frames"][vf]["Point"], void, LeaPlusDB["Frames"][vf]["Relative"], LeaPlusDB["Frames"][vf]["XOffset"], LeaPlusDB["Frames"][vf]["YOffset"] = _G[vf]:GetPoint();
							LeaPlusFramesSaveCache(vf);
						end
					else
						-- Show mover frame
						SideFrames:Show();
						LeaPlusLC:HideFrames();

						-- Find out if the UI has a non-standard scale
						if GetCVar("useuiscale") == "1" then
							LeaPlusLC["gscale"] = GetCVar("uiscale")
						else
							LeaPlusLC["gscale"] = 1
						end

						-- Set all scaled sizes
						for k,v in pairs(FrameTable) do
							LeaPlusLC[k]:SetWidth(v:GetWidth() * LeaPlusLC["gscale"])
							LeaPlusLC[k]:SetHeight(v:GetHeight() * LeaPlusLC["gscale"])
						end

						-- Set specific scaled sizes for stubborn frames
						LeaPlusLC["DragWorldStateAlwaysUpFrame"]:SetSize(300 * LeaPlusLC["gscale"], 50 * LeaPlusLC["gscale"]);
						LeaPlusLC["DragMirrorTimer1"]:SetSize(206 * LeaPlusLC["gscale"], 50 * LeaPlusLC["gscale"]);
						LeaPlusLC["DragGhostFrame"]:SetSize(130 * LeaPlusLC["gscale"], 46 * LeaPlusLC["gscale"]);
					end
				end
			end)
		end

		-- Release memory
		LeaPlusLC.Variable = nil

	end

----------------------------------------------------------------------
--	L50: Player (only runs once)
----------------------------------------------------------------------

	function LeaPlusLC:Player()

		----------------------------------------------------------------------
		-- Recent chat window
		----------------------------------------------------------------------

		if LeaPlusLC["RecentChatWindow"] == "On" then

			-- Create recent chat frame (not parenting to UIParent due to editbox scaling issue)
			local editFrame = CreateFrame("ScrollFrame", nil, nil, "InputScrollFrameTemplate")

			-- Toggle frame with UIParent and pet battles
			local hideUI = false
			local function HideRecentChatFrame() if editFrame:IsShown() then hideUI = true editFrame:Hide() end	end
			local function ShowRecentChatFrame() if hideUI and not PetBattleFrame:IsShown() then editFrame:Show() hideUI = false end end
			UIParent:HookScript("OnHide", HideRecentChatFrame)
			UIParent:HookScript("OnShow", ShowRecentChatFrame)
			hooksecurefunc("PetBattleFrame_Display", HideRecentChatFrame)
			hooksecurefunc("PetBattleFrame_Remove", ShowRecentChatFrame)

			-- Create configuration panel
			local ChatPanel = LeaPlusLC:CreatePanel("Recent Chat Window", "ChatPanel")

			LeaPlusLC:MakeTx(ChatPanel, "Font size", 16, -72)
			LeaPlusLC:MakeSL(ChatPanel, "RecentChatSize", "", 10, 24, 1, 16, -92, "%.0f")

			LeaPlusLC:MakeTx(ChatPanel, "Transparency", 16, -132)
			LeaPlusLC:MakeSL(ChatPanel, "RecentChatAlpha", "", 0, 1, 0.1, 16, -152, "%.1f")

			LeaPlusLC:MakeTx(ChatPanel, "Window width", 186, -72)
			LeaPlusLC:MakeSL(ChatPanel, "RecentChatWidth", "", 0.5, 1.5, 0.1, 186, -92, "%.1f")

			LeaPlusLC:MakeTx(ChatPanel, "Window height", 186, -132)
			LeaPlusLC:MakeSL(ChatPanel, "RecentChatHeight", "", 0.5, 1.5, 0.1, 186, -152, "%.1f")

			-- Help button tooltip
			ChatPanel.h.tiptext = L["To move the recent chat window, hold CTRL and SHIFT then drag the window."]

			-- Back button handler
			ChatPanel.b:SetScript("OnClick", function() 
				ChatPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page3"]:Show()
				return
			end) 

			-- Reset button handler
			ChatPanel.r:SetScript("OnClick", function()
				LeaPlusLC["RecentChatSize"] = 18
				LeaPlusLC["RecentChatAlpha"] = 0.5
				LeaPlusLC["RecentChatWidth"] = 1
				LeaPlusLC["RecentChatHeight"] = 1
				LeaPlusLC["RecentChatA"] = "CENTER"
				LeaPlusLC["RecentChatR"] = "CENTER"
				LeaPlusLC["RecentChatX"] = 0
				LeaPlusLC["RecentChatY"] = 0
				ChatPanel:Hide(); ChatPanel:Show()
				if editFrame:IsShown() then editFrame:Hide(); editFrame:Show() end
			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["RecentChatBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["RecentChatSize"] = 18
					LeaPlusLC["RecentChatAlpha"] = 0.5
					LeaPlusLC["RecentChatWidth"] = 1
					LeaPlusLC["RecentChatHeight"] = 0.5
					LeaPlusLC["RecentChatA"] = "BOTTOM"
					LeaPlusLC["RecentChatR"] = "BOTTOM"
					LeaPlusLC["RecentChatX"] = -74
					LeaPlusLC["RecentChatY"] = 88
					ChatPanel:Show(); ChatPanel:Hide()
					if editFrame:IsShown() then editFrame:Hide(); editFrame:Show() end
				else
					ChatPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			-- Set frame parameters
			editFrame:ClearAllPoints()
			editFrame:SetPoint(LeaPlusLC["RecentChatA"], UIParent, LeaPlusLC["RecentChatR"], LeaPlusLC["RecentChatX"], LeaPlusLC["RecentChatY"])
			editFrame:SetFrameStrata("MEDIUM")
			editFrame:SetToplevel(true)
			editFrame:SetClampedToScreen(true)
			editFrame:SetMovable(true)
			editFrame.CharCount:Hide()
			editFrame:Hide()
			editFrame:SetSize(570, 370)

			-- Add background color
			editFrame.t = editFrame:CreateTexture(nil, "BACKGROUND")
			editFrame.t:SetAllPoints()
			editFrame.t:SetColorTexture(0.00, 0.00, 0.0, 1.0)

			-- Set textures
			editFrame.LeftTex:SetTexture(editFrame.RightTex:GetTexture()); editFrame.LeftTex:SetTexCoord(1, 0, 0, 1)
			editFrame.BottomTex:SetTexture(editFrame.TopTex:GetTexture()); editFrame.BottomTex:SetTexCoord(0, 1, 1, 0)
			editFrame.BottomRightTex:SetTexture(editFrame.TopRightTex:GetTexture()); editFrame.BottomRightTex:SetTexCoord(0, 1, 1, 0)
			editFrame.BottomLeftTex:SetTexture(editFrame.TopRightTex:GetTexture()); editFrame.BottomLeftTex:SetTexCoord(1, 0, 1, 0)
			editFrame.TopLeftTex:SetTexture(editFrame.TopRightTex:GetTexture()); editFrame.TopLeftTex:SetTexCoord(1, 0, 0, 1)

			-- Create editbox
			local editBox = editFrame.EditBox
			editBox:SetFontObject("ChatFontNormal")
			editBox:SetAltArrowKeyMode(false)
			editBox:SetTextInsets(4, 4, 4, 4)

			-- Maintain editbox effective height
			editFrame:HookScript("OnVerticalScroll", function(self, offset)
				editBox:SetHitRectInsets(0, 0, offset, editBox:GetHeight() - offset - editBox:GetHeight())
			end)

			-- Set position and scroll bar scale when shown
			editFrame:HookScript("OnShow", function()
				-- Set frame position
				editFrame:ClearAllPoints()
				editFrame:SetPoint(LeaPlusLC["RecentChatA"], UIParent, LeaPlusLC["RecentChatR"], LeaPlusLC["RecentChatX"], LeaPlusLC["RecentChatY"])
				-- Set scroll bar scale
				editFrame.ScrollBar:SetScale(UIParent:GetEffectiveScale())
			end)

			-- Set scroll bar scale and font size when UI scale is changed
			editFrame:RegisterEvent("UI_SCALE_CHANGED")
			editFrame:SetScript("OnEvent", function()
				-- Set scroll bar scale
				editFrame.ScrollBar:SetScale(UIParent:GetEffectiveScale())
				-- Set font size
				editBox:SetFont(editBox:GetFont(), LeaPlusLC["RecentChatSize"] * UIParent:GetEffectiveScale())
			end)

			-- Apply changes when controls are changed and on startup
			local function RefreshSettings()
				-- Set font size
				editBox:SetFont(editBox:GetFont(), LeaPlusLC["RecentChatSize"] * UIParent:GetEffectiveScale())
				-- Set alpha
				editFrame.t:SetAlpha(1 - LeaPlusLC["RecentChatAlpha"])
				LeaPlusCB["RecentChatAlpha"].f:SetFormattedText("%.0f%%", LeaPlusLC["RecentChatAlpha"] * 100)
				-- Set width
				editFrame:SetWidth(570 * LeaPlusLC["RecentChatWidth"])
				editBox:SetWidth(editFrame:GetWidth() - 30)
				LeaPlusCB["RecentChatWidth"].f:SetFormattedText("%.0f%%", LeaPlusLC["RecentChatWidth"] * 100)
				-- Set height
				editFrame:SetHeight(370 * LeaPlusLC["RecentChatHeight"])
				LeaPlusCB["RecentChatHeight"].f:SetFormattedText("%.0f%%", LeaPlusLC["RecentChatHeight"] * 100)
			end
			LeaPlusCB["RecentChatSize"]:HookScript("OnValueChanged", RefreshSettings)
			LeaPlusCB["RecentChatAlpha"]:HookScript("OnValueChanged", RefreshSettings)
			LeaPlusCB["RecentChatWidth"]:HookScript("OnValueChanged", RefreshSettings)
			LeaPlusCB["RecentChatHeight"]:HookScript("OnValueChanged", RefreshSettings)
			RefreshSettings()

			-- Function to close recent chat frame
			local function CloseChatbox()
				editBox:SetText("")
				editBox:ClearFocus()
				editFrame:Hide()
			end

			-- Movement and closure handlers
			editBox:SetScript("OnMouseDown", function(self, btn)
				if btn == "LeftButton" and IsControlKeyDown() and IsShiftKeyDown() then
					editFrame:StartMoving()
				elseif btn == "RightButton" then
					CloseChatbox()
				end
			end)

			editBox:SetScript("OnMouseUp", function(self, btn)
				if btn == "LeftButton" then
					editFrame:StopMovingOrSizing()
					editFrame:SetUserPlaced(false)
					LeaPlusLC["RecentChatA"], void, LeaPlusLC["RecentChatR"], LeaPlusLC["RecentChatX"], LeaPlusLC["RecentChatY"] = editFrame:GetPoint()
				end
			end)

			editFrame:SetScript("OnMouseDown", function(self, btn)
				if btn == "LeftButton" and IsControlKeyDown() and IsShiftKeyDown() then
					editFrame:StartMoving()
				elseif btn == "RightButton" then
					CloseChatbox()
				end
			 end)

			editFrame:SetScript("OnMouseUp", function(self, btn)
				if btn == "LeftButton" then
					editFrame:StopMovingOrSizing()
					editFrame:SetUserPlaced(false)
					LeaPlusLC["RecentChatA"], void, LeaPlusLC["RecentChatR"], LeaPlusLC["RecentChatX"], LeaPlusLC["RecentChatY"] = editFrame:GetPoint()
				end
			end)

			-- Clear focus if editbox is only being moved
			editBox:HookScript("OnEditFocusGained", function()
				if IsControlKeyDown() and IsShiftKeyDown() then
					editBox:ClearFocus()
				end
			end)

			-- Disable text changes while still allowing editing controls to work
			editBox:EnableKeyboard(false)
			editBox:SetScript("OnKeyDown", function() end)

			--- Clear highlighted text if escape key is pressed
			editBox:HookScript("OnEscapePressed", function()
				editBox:HighlightText(0, 0)
				editBox:ClearFocus()
			end)

			-- Clear highlighted text and clear focus if enter key is pressed
			editBox:SetScript("OnEnterPressed", function() 
				editBox:HighlightText(0, 0)
				editBox:ClearFocus()
			end)

			-- Populate recent chat frame with chat messages
			local function ShowChatbox(chtfrm)
				editBox:SetText("")
				local NumMsg = chtfrm:GetNumMessages()
				local StartMsg = 1
				if NumMsg > 128 then StartMsg = NumMsg - 127 end
				local totalMsgCount = 0
				for iMsg = StartMsg, NumMsg do
					local chatMessage = chtfrm:GetMessageInfo(iMsg)
					if chatMessage then
						chatMessage = gsub(chatMessage, "|T.-|t", "") -- Remove textures
						chatMessage = gsub(chatMessage, "{.-}", "") -- Remove ellipsis
						editBox:Insert(chatMessage .. "|n")
					end
					totalMsgCount = totalMsgCount + 1
				end
				if totalMsgCount == 1 then
					editBox:Insert("|cff88aabb" .. totalMsgCount .. " " .. L["message shown."] .. "  ")
				else
					editBox:Insert("|cff88aabb" .. totalMsgCount .. " " .. L["messages shown."] .. "  ")
				end
				editBox:Insert(L["Right-click to close."])
				editFrame:SetVerticalScroll(0)
				C_Timer.After(0.1, function() editFrame.ScrollBar.ScrollDownButton:Click() end)
				editFrame:Show()
				editBox:ClearFocus()
			end

			-- Hook normal chat frame tab clicks
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					_G["ChatFrame" .. i .. "Tab"]:HookScript("OnClick", function()
						if IsControlKeyDown() then
							ShowChatbox(_G["ChatFrame" .. i])
						end
					end)
				end
			end

			-- Hook temporary chat frame tab clicks
			hooksecurefunc("FCF_OpenTemporaryWindow", function()
				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then
					_G[cf .. "Tab"]:HookScript("OnClick", function()
						if IsControlKeyDown() then
							ShowChatbox(_G[cf])
						end
					end)
				end
			end)

		end

		----------------------------------------------------------------------
		--	Hide alerts
		----------------------------------------------------------------------

		if LeaPlusLC["NoAlerts"] == "On" then

			-- Create configuration panel
			local AlertPanel = LeaPlusLC:CreatePanel("Alerts", "AlertPanel")

			LeaPlusLC:MakeTx(AlertPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(AlertPanel, "NoAchieveAlerts", "Hide achievement alerts", 16, -92, false, "If checked, achievement alerts will not be shown.")
			LeaPlusLC:MakeCB(AlertPanel, "NoEncounterAlerts", "Hide encounter alerts", 16, -112, false, "If checked, encounter alerts will not be shown.|n|nThis includes dungeons, raids, scenarios, invasions, guild challenges and world quests.")
			LeaPlusLC:MakeCB(AlertPanel, "NoGarrisonAlerts", "Hide order hall and garrison alerts", 16, -132, false, "If checked, order hall and garrison alerts will not be shown.|n|nThis includes buildings, followers, missions and talents.")
			LeaPlusLC:MakeCB(AlertPanel, "NoLootAlerts", "Hide loot alerts", 16, -152, false, "If checked, loot alerts will not be shown.|n|nThis includes items, money, honor, resources and store purchases.")
			LeaPlusLC:MakeCB(AlertPanel, "NoProfessionAlerts", "Hide profession alerts", 16, -172, false, "If checked, profession alerts will not be shown.|n|nThis includes recipes and digsites.")

			-- Help button hidden
			AlertPanel.h:Hide()

			-- Back button handler
			AlertPanel.b:SetScript("OnClick", function() 
				AlertPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page6"]:Show()
				return
			end)

			-- Reset button handler
			AlertPanel.r:SetScript("OnClick", function()

				-- Reset checkboxes
				LeaPlusLC["NoAchieveAlerts"] = "On"
				LeaPlusLC["NoEncounterAlerts"] = "On"
				LeaPlusLC["NoGarrisonAlerts"] = "On"
				LeaPlusLC["NoLootAlerts"] = "On"
				LeaPlusLC["NoProfessionAlerts"] = "On"

				-- Refresh side panel
				AlertPanel:Hide(); AlertPanel:Show()

			end)

			-- Show configuration panal when options panel button is clicked
			LeaPlusCB["NoAlertsBtn"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["NoAchieveAlerts"] = "On"
					LeaPlusLC["NoEncounterAlerts"] = "On"
					LeaPlusLC["NoGarrisonAlerts"] = "On"
					LeaPlusLC["NoLootAlerts"] = "On"
					LeaPlusLC["NoProfessionAlerts"] = "On"
				else
					AlertPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			-- Alert table
			local alertTable = {

				-- Achievements
				AchievementAlertSystem, "NoAchieveAlerts", -- AchievementAlertSystem:AddAlert(5192)
				CriteriaAlertSystem, "NoAchieveAlerts", -- CriteriaAlertSystem:AddAlert(9023, "Doing great!")

				-- Encounters
				DungeonCompletionAlertSystem, "NoEncounterAlerts", -- DungeonCompletionAlertSystem
				GuildChallengeAlertSystem, "NoEncounterAlerts", -- GuildChallengeAlertSystem:AddAlert(3, 2, 5)
				InvasionAlertSystem, "NoEncounterAlerts", -- InvasionAlertSystem:AddAlert(1)
				ScenarioAlertSystem, "NoEncounterAlerts", -- ScenarioAlertSystem
				WorldQuestCompleteAlertSystem, "NoEncounterAlerts", -- WorldQuestCompleteAlertSystem:AddAlert(112)

				-- Garrisons
				GarrisonBuildingAlertSystem, "NoGarrisonAlerts", -- GarrisonBuildingAlertSystem:AddAlert("Barracks")
				GarrisonFollowerAlertSystem, "NoGarrisonAlerts", -- GarrisonFollowerAlertSystem:AddAlert(204, "Ben Stone", 90, 3, false) (C_Garrison.GetFollowerInfo)
				GarrisonMissionAlertSystem, "NoGarrisonAlerts", -- GarrisonMissionAlertSystem:AddAlert(681) (C_Garrison.GetBasicMissionInfo)
				GarrisonRandomMissionAlertSystem, "NoGarrisonAlerts", -- GarrisonRandomMissionAlertSystem
				GarrisonShipFollowerAlertSystem, "NoGarrisonAlerts", -- GarrisonShipFollowerAlertSystem:AddAlert(592, "Test", "Transport", "GarrBuilding_Barracks_1_H", 3, 2, 1)
				GarrisonTalentAlertSystem, "NoGarrisonAlerts", -- GarrisonTalentAlertSystem
				GarrisonShipMissionAlertSystem, "NoGarrisonAlerts", -- GarrisonShipMissionAlertSystem

				-- Loot
				LegendaryItemAlertSystem, "NoLootAlerts", -- LegendaryItemAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:18832:0:0:0:0:0:0:0:0:0:0\\124h[Brutality Blade]\\124h\\124r")
				LootAlertSystem, "NoLootAlerts", -- LootAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:18832:0:0:0:0:0:0:0:0:0:0\\124h[Brutality Blade]\\124h\\124r", 1, 1, 1, 1, false, false, 0, false, false)
				LootUpgradeAlertSystem, "NoLootAlerts", -- LootUpgradeAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:18832:0:0:0:0:0:0:0:0:0:0\\124h[Brutality Blade]\\124h\\124r", 1, 1, 1, nil, nil, false)
				HonorAwardedAlertSystem, "NoLootAlerts", -- HonorAwardedAlertSystem:AddAlert(204)
				MoneyWonAlertSystem, "NoLootAlerts", -- MoneyWonAlertSystem:AddAlert(815)
				StorePurchaseAlertSystem, "NoLootAlerts", -- StorePurchaseAlertSystem:AddAlert("\\124cffa335ee\\124Hitem:180545:0:0:0:0:0:0:0:0:0:0\\124h[Mystic Runesaber]\\124h\\124r", "", "", 214)
				NewPetAlertSystem, "NoLootAlerts", -- NewPetAlertSystem:AddAlert("BattlePet-0-000003B985AC")
				NewMountAlertSystem, "NoLootAlerts", -- NewMountAlertSystem:AddAlert(419)

				-- Professions
				DigsiteCompleteAlertSystem, "NoProfessionAlerts", -- DigsiteCompleteAlertSystem:AddAlert(1)
				NewRecipeLearnedAlertSystem, "NoProfessionAlerts", -- NewRecipeLearnedAlertSystem:AddAlert(204)

			}

			-- Hide alerts
			for k = 1, #alertTable, 2 do
				-- Hide alerts when shown
				hooksecurefunc(alertTable[k], "AddAlert", function(self)
					if LeaPlusLC[alertTable[k+1]] == "On" then
						for alertFrame in self.alertFramePool:EnumerateActive() do
							alertFrame:Hide()
						end
					end
				end)
				-- Hide alerts on startup
				for alertFrame in alertTable[k].alertFramePool:EnumerateActive() do
					if LeaPlusLC[alertTable[k+1]] == "On" then
						alertFrame:Hide()
					end
				end
			end

		end

		----------------------------------------------------------------------
		-- Show cooldowns
		----------------------------------------------------------------------

		if LeaPlusLC["ShowCooldowns"] == "On" then

			-- Create main table structure in saved variables if it doesn't exist
			if LeaPlusDB["Cooldowns"] == nil then
				LeaPlusDB["Cooldowns"] = {}
			end

			-- Create class tables if they don't exist
			for index = 1, GetNumClasses() do
				local classDisplayName, classTag, classID = GetClassInfo(index)
				if LeaPlusDB["Cooldowns"][classTag] == nil then
					LeaPlusDB["Cooldowns"][classTag] = {}
				end
			end

			-- Get current class and spec
			local PlayerClass = select(2, UnitClass("player"))
			local activeSpec = GetSpecialization() or 1

			-- Create local tables to store cooldown frames and editboxes
			local icon = {} -- Used to store cooldown frames
			local SpellEB = {} -- Used to store editbox values
			local iCount = 5 -- Number of cooldowns

			-- Create cooldown frames
			for i = 1, iCount do

				-- Create cooldown frame
				icon[i] = CreateFrame("Frame", nil, UIParent)
				icon[i]:SetFrameStrata("BACKGROUND")
				icon[i]:SetWidth(20)
				icon[i]:SetHeight(20)

				-- Create cooldown icon
				icon[i].c = CreateFrame("Cooldown", nil, icon[i], "CooldownFrameTemplate")
				icon[i].c:SetAllPoints()
				icon[i].c:SetReverse(true)

				-- Create blank texture (will be assigned a cooldown texture later)
				icon[i].t = icon[i]:CreateTexture(nil,"BACKGROUND")
				icon[i].t:SetAllPoints()

				-- Create frame for OnUpdate to anchor to (so it doesn't need to run unnecessarily)
				icon[i].z = CreateFrame("Frame", nil, icon[i])
				icon[i].z:Hide()

			end

			-- Change cooldown icon scale when player frame scale changes
			PlayerFrame:HookScript("OnSizeChanged", function()
				if LeaPlusLC["CooldownsOnPlayer"] == "On" then
					for i = 1, iCount do
						icon[i]:SetScale(PlayerFrame:GetScale())
					end
				end
			end)

			-- Change cooldown icon scale when target frame scale changes
			TargetFrame:HookScript("OnSizeChanged", function()
				if LeaPlusLC["CooldownsOnPlayer"] == "Off" then
					for i = 1, iCount do
						icon[i]:SetScale(TargetFrame:GetScale())
					end
				end
			end)

			-- Function to show cooldown textures in the cooldown frames
			local function ShowIcon(i, id, owner)

				local void

				-- Get spell information
				local spell, void, path = GetSpellInfo(id)

				if spell and path then

					-- Set icon texture to the spell texture
					icon[i].t:SetTexture(path)

					-- Set top level and raise frame strata (ensures tooltips show properly)
					icon[i]:SetToplevel(true)
					icon[i]:SetFrameStrata("LOW")

					-- Update cooldown tooltip
					if LeaPlusLC["CooldownTips"] == "On" then

						-- Update tooltip while OnEnter is active
						icon[i].z:SetScript("OnUpdate", function()
							if GameTooltip:IsOwned(icon[i]) then
								-- Tooltip is showing so update it
								GameTooltip:SetUnitBuff(owner, spell)
							end
						end)

						-- Show tooltip when OnEnter is active
						icon[i]:SetScript("OnEnter", function(self)
							if LeaPlusLC["CooldownTips"] == "On" then
								-- Show the tooltip for the spell
								GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 15, -25)
								GameTooltip:SetUnitBuff(owner, spell)
								-- Show the anchor frame to trigger OnUpdate
								icon[i].z:Show()
							end
						end)

						-- Hide tooltip and remove OnUpdate
						icon[i]:SetScript("OnLeave", function(self)
							if LeaPlusLC["CooldownTips"] == "On" then
								GameTooltip:Hide()
								-- Hide the anchor frame
								icon[i].z:Hide()
							end
						end)

					else

						-- Clear all script handlers if tooltips aren't required
						icon[i].z:SetScript("OnUpdate", nil)
						icon[i]:SetScript("OnEnter", nil)
						icon[i]:SetScript("OnLeave", nil)

					end
					
					-- Handle events
					icon[i]:RegisterUnitEvent("UNIT_AURA", owner)
					icon[i]:RegisterUnitEvent("UNIT_PET", "player")
					icon[i]:SetScript("OnEvent", function(self, event, arg1)

						-- If pet was dismissed (or otherwise disappears such as when flying), hide pet cooldowns
						if event == "UNIT_PET" then
							if not UnitExists("pet") then
								if LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] then
									icon[i]:Hide()
								end
							end

						-- Ensure cooldown belongs to the owner we are watching (player or pet)
						elseif arg1 == owner then

							-- Hide the cooldown frame (required for cooldowns to disappear after the duration)
							icon[i]:Hide()

							-- If buff matches cooldown we want, start the cooldown
							local buff, void, void, stack, void, length, expire = UnitBuff(owner, spell)
							if buff then
								local stackval = tonumber(SpellEB[i.."Stack"]:GetText())
								if (stackval and stack >= stackval) or (not stackval) then
									icon[i]:Show()
									local start = expire - length
									CooldownFrame_Set(icon[i].c, start, length, 1)
								end
							end

						end
					end)

				else

					-- Spell does not exist so stop watching it
					icon[i]:UnregisterEvent("UNIT_AURA")
					icon[i]:SetScript("OnEvent", nil)
					icon[i]:Hide()
					icon[i].z:SetScript("OnUpdate", nil)
					icon[i]:SetScript("OnEnter", nil)
					icon[i]:SetScript("OnLeave", nil)

				end

			end

			-- Create configuration panel
			local CooldownPanel = LeaPlusLC:CreatePanel("Cooldowns", "CooldownPanel")

			-- Function to refresh the tooltip with the spell name
			local function RefSpellTip(self,elapsed)
				local spellinfo, void, icon = GetSpellInfo(self:GetText())
				if spellinfo and spellinfo ~= "" and icon ~= "" then
					GameTooltip:SetOwner(self, "ANCHOR_NONE")
					GameTooltip:ClearAllPoints()
					GameTooltip:SetPoint("RIGHT", self, "LEFT", -10, 0)
					GameTooltip:SetText("|T" .. icon .. ":0|t " .. spellinfo, nil, nil, nil, nil, true)
				else
					GameTooltip:Hide()
				end
			end

			-- Function to create spell ID editboxes and pet checkboxes
			local function MakeSpellEB(num, x, y, tab, shifttab)

				-- Create editbox for spell ID
                SpellEB[num] = LeaPlusLC:CreateEditBox("Spell" .. num, CooldownPanel, 70, 6, "TOPLEFT", x, y - 20, "Spell" .. num .. "Stack", "Spell" .. shifttab .. "Stack")
				SpellEB[num]:SetNumeric(true)

				-- Set initial value (for current spec)
				SpellEB[num]:SetText(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. num .. "Idn"] or "")

				-- Refresh tooltip when mouse is hovering over the editbox
				SpellEB[num]:SetScript("OnEnter", function()
					SpellEB[num]:SetScript("OnUpdate", RefSpellTip)
				end)
				SpellEB[num]:SetScript("OnLeave", function()
					SpellEB[num]:SetScript("OnUpdate", nil)
					GameTooltip:Hide()
				end)

				-- Create editbox for stack size
				SpellEB[num .. "Stack"] = LeaPlusLC:CreateEditBox("Spell" .. num .. "Stack", CooldownPanel, 30, 2, "TOPLEFT", x + 80, y - 20, "Spell" .. tab, "Spell" .. num)
				SpellEB[num .. "Stack"]:SetNumeric(true)

				-- Set initial value (for current spec)
				SpellEB[num .. "Stack"]:SetText(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. num .. "Stk"] or "")

				-- Create checkbox for pet cooldown
				LeaPlusLC:MakeCB(CooldownPanel, "Spell" .. num .."Pet", "", 504, y - 20, false, "")
				LeaPlusCB["Spell" .. num .."Pet"]:SetHitRectInsets(0, 0, 0, 0)

			end

			-- Add titles
			LeaPlusLC:MakeTx(CooldownPanel, "Spell ID", 384, -92)
			LeaPlusLC:MakeTx(CooldownPanel, "Stack", 462, -92)
			LeaPlusLC:MakeTx(CooldownPanel, "Pet", 506, -92)

			-- Add editboxes and checkboxes
			MakeSpellEB(1, 386, -92, "2", "5")
			MakeSpellEB(2, 386, -122, "3", "1")
			MakeSpellEB(3, 386, -152, "4", "2")
			MakeSpellEB(4, 386, -182, "5", "3")
			MakeSpellEB(5, 386, -212, "1", "4")

			-- Add checkboxes
			LeaPlusLC:MakeTx(CooldownPanel, "Settings", 16, -72)
			LeaPlusLC:MakeCB(CooldownPanel, "CooldownTips", "Show tooltips for the cooldown icons", 16, -92, false, "If checked, cooldown icon tooltips will be shown.")
			LeaPlusLC:MakeCB(CooldownPanel, "ShowCooldownID", "Show the spell ID in buff icon tooltips", 16, -112, false, "If checked, spell IDs will be shown in buff icon tooltips located in the buff frame and under the target frame.");
			LeaPlusLC:MakeCB(CooldownPanel, "NoCooldownDuration", "Hide cooldown duration numbers (if enabled)", 16, -132, false, "If checked, cooldown duration numbers will not be shown over the cooldowns.|n|nIf unchecked, cooldown duration numbers will be shown over the cooldowns if they are enabled in the game options panel ('ActionBars' menu).")
			LeaPlusLC:MakeCB(CooldownPanel, "CooldownsOnPlayer", "Anchor the cooldown icons to the player frame", 16, -152, false, "If checked, cooldown icons will be shown above the player frame instead of the target frame.|n|nIf unchecked, cooldown icons will be shown above the target frame.")

			-- Function to save the panel control settings and refresh the cooldown icons
			local function SavePanelControls()
				for i = 1, iCount do

					-- Refresh the cooldown texture
					icon[i].c:SetCooldown(0,0)

					-- Show icons above target or player frame
					icon[i]:ClearAllPoints()
					if LeaPlusLC["CooldownsOnPlayer"] == "On" then
						icon[i]:SetPoint("TOPLEFT", PlayerFrame, "TOPLEFT", 116 + (22 * (i - 1)), 5)
						icon[i]:SetScale(PlayerFrame:GetScale())
					else
						icon[i]:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 6 + (22 * (i - 1)), 5)
						icon[i]:SetScale(TargetFrame:GetScale())
					end

					-- Save control states to globals
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Idn"] = SpellEB[i]:GetText()
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Stk"] = SpellEB[i .. "Stack"]:GetText()
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] = LeaPlusCB["Spell" .. i .."Pet"]:GetChecked()

					-- Set cooldowns
					if LeaPlusCB["Spell" .. i .."Pet"]:GetChecked() then
						ShowIcon(i, SpellEB[i]:GetText(), "pet")
					else
						ShowIcon(i, SpellEB[i]:GetText(), "player")
					end

					-- Hide cooldown duration
					if LeaPlusLC["NoCooldownDuration"] == "On" then
						icon[i].c:SetHideCountdownNumbers(true)
					else
						icon[i].c:SetHideCountdownNumbers(false)
					end

					-- Show or hide cooldown icons depending on current buffs
					local newowner
					local newspell = GetSpellInfo(SpellEB[i]:GetText())
					if newspell then
						if LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] then 
							newowner = "pet" 
						else
							newowner = "player"
						end
						-- Hide cooldown icon
						icon[i]:Hide()

						-- If buff matches spell we want, show cooldown icon
						local buff, void, void, stack, void, length, expire = UnitBuff(newowner, newspell)
						if buff then
							local stackval = tonumber(SpellEB[i .. "Stack"]:GetText())
							if (stackval and stack >= stackval) or (not stackval) then
								icon[i]:Show()

								-- Set the cooldown to the buff cooldown
								CooldownFrame_Set(icon[i].c, expire - length, length, 1)
							end
						end
					end

				end

			end

			-- Update cooldown icons when checkboxes are clicked
			LeaPlusCB["CooldownTips"]:HookScript("OnClick", SavePanelControls)
			LeaPlusCB["NoCooldownDuration"]:HookScript("OnClick", SavePanelControls)
			LeaPlusCB["CooldownsOnPlayer"]:HookScript("OnClick", SavePanelControls)

			-- Help button tooltip
			CooldownPanel.h.tiptext = L["Enter the spell IDs for the cooldown icons that you want to see.|n|nIf you want a cooldown icon to show only when it is stacked, enter the minimum stack size (otherwise leave it blank).|n|nIf a cooldown icon normally appears under the pet frame, check the pet checkbox.|n|nCooldown icons are saved to your class and specialisation."]

			-- Back button handler
			CooldownPanel.b:SetScript("OnClick", function()
				CooldownPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page5"]:Show()
				return
			end) 

			-- Reset button handler
			CooldownPanel.r:SetScript("OnClick", function()
				-- Reset the checkboxes
				LeaPlusLC["CooldownTips"] = "On"
				LeaPlusLC["ShowCooldownID"] = "On"
				LeaPlusLC["NoCooldownDuration"] = "On"
				LeaPlusLC["CooldownsOnPlayer"] = "Off"
				for i = 1, iCount do
					-- Reset the panel controls
					SpellEB[i]:SetText("");
					SpellEB[i.."Stack"]:SetText("");
					LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] = false
					-- Hide cooldowns and clear scripts
					icon[i]:Hide()
					icon[i]:UnregisterEvent("UNIT_AURA")
					icon[i]:SetScript("OnEvent", nil)
					icon[i].z:SetScript("OnUpdate", nil)
					icon[i]:SetScript("OnEnter", nil)
					icon[i]:SetScript("OnLeave", nil)
				end
				CooldownPanel:Hide(); CooldownPanel:Show()
			end)

			-- Save editboxes when changed
			for i = 1, iCount do
				-- Set initial checkbox states
				LeaPlusCB["Spell" .. i .."Pet"]:SetChecked(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"])
				-- Set checkbox states when shown
				LeaPlusCB["Spell" .. i .."Pet"]:SetScript("OnShow", function()
					LeaPlusCB["Spell" .. i .."Pet"]:SetChecked(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"])
				end)
				-- Set states when changed
				SpellEB[i]:SetScript("OnTextChanged", SavePanelControls)
				SpellEB[i.."Stack"]:SetScript("OnTextChanged", SavePanelControls)
				LeaPlusCB["Spell" .. i .."Pet"]:SetScript("OnClick", SavePanelControls)
			end

			-- Show cooldowns on startup
			SavePanelControls();

			-- Show panel when configuration button is clicked
			LeaPlusCB["CooldownsButton"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- No preset profile
				else
					-- Show panel
					CooldownPanel:Show()
					LeaPlusLC:HideFrames()
				end
			end)

			-- Create spec tag banner fontstring
			local specTagSpecID = GetSpecialization()
			local specTagSpecInfoID, specTagName = GetSpecializationInfo(specTagSpecID)
			local specTagBanner = CooldownPanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
			specTagBanner:SetPoint("TOPLEFT", 384, -72)
			specTagBanner:SetText(specTagName)

            -- Set controls when spec changes
            local swapFrame = CreateFrame("FRAME")
            swapFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
            swapFrame:SetScript("OnEvent", function()
				-- Store new spec
				activeSpec = GetSpecialization()
				-- Update controls for new spec
				for i = 1, iCount do
					SpellEB[i]:SetText(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Idn"] or "")
					SpellEB[i.."Stack"]:SetText(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Stk"] or "")
					LeaPlusCB["Spell" .. i .. "Pet"]:SetChecked(LeaPlusDB["Cooldowns"][PlayerClass]["S" .. activeSpec .. "R" .. i .. "Pet"] or false)
				end
				-- Update spec tag banner with new spec
				local specTagSpecInfoID, specTagName = GetSpecializationInfo(activeSpec)
				specTagBanner:SetText(specTagName)
				-- Refresh configuration panel
				if CooldownPanel:IsShown() then 
					CooldownPanel:Hide(); CooldownPanel:Show()
				end
				-- Save settings
				SavePanelControls()
            end)

			-- Function to show spell ID in tooltips
			local function CooldownIDFunc(unit, target, index)
				if LeaPlusLC["ShowCooldownID"] == "On" then
					local spellid = select(11, UnitAura(target, index))
					if spellid then
						GameTooltip:AddLine(L["Spell ID"] .. ": " .. spellid)
						GameTooltip:Show()
					end
				end
			end

			-- Add spell ID to tooltip when buff frame buffs are hovered
			hooksecurefunc(GameTooltip, 'SetUnitAura', CooldownIDFunc)   

			-- Add spell ID to tooltip when target frame buffs are hovered
			hooksecurefunc(GameTooltip, 'SetUnitBuff', CooldownIDFunc)

		end

		----------------------------------------------------------------------
		-- Lockout sharing
		----------------------------------------------------------------------

		if LeaPlusLC["LockoutSharing"] == "On" then
			-- Check the display menu option, update the game options panel and lockout changes
			ShowAccountAchievements(true)
			InterfaceOptionsPanel_CheckButton_Update(InterfaceOptionsSocialPanelShowAccountAchievments)
			InterfaceOptionsSocialPanelShowAccountAchievments:Disable()
			InterfaceOptionsSocialPanelShowAccountAchievments:SetAlpha(0.5)
			InterfaceOptionsSocialPanelShowAccountAchievmentsText:SetText(InterfaceOptionsSocialPanelShowAccountAchievmentsText:GetText() .. "|n" .. L["Managed by Leatrix Plus"])
		end

		----------------------------------------------------------------------
		-- Combat plates
		----------------------------------------------------------------------

		if LeaPlusLC["CombatPlates"] == "On" then

			-- Toggle nameplates with combat
			local f = CreateFrame("Frame")
			f:RegisterEvent("PLAYER_REGEN_DISABLED")
			f:RegisterEvent("PLAYER_REGEN_ENABLED")
			f:SetScript("OnEvent", function(self, event)
				SetCVar("nameplateShowEnemies", event == "PLAYER_REGEN_DISABLED" and 1 or 0)
			end)

			-- Run combat check on startup
			SetCVar("nameplateShowEnemies", UnitAffectingCombat("player") and 1 or 0)

		end

		----------------------------------------------------------------------
		-- Manage tooltip
		----------------------------------------------------------------------

		if LeaPlusLC["TipModEnable"] == "On" then

			----------------------------------------------------------------------
			--	Position the tooltip
			----------------------------------------------------------------------

			-- Position general tooltip
			hooksecurefunc("GameTooltip_SetDefaultAnchor", function(tooltip, parent)
				if LeaPlusLC["TipMoveTip"] == "On" then
					if (not tooltip or not parent) then
						return
					end
					local a,b,c,d,e = tooltip:GetPoint()
					if a ~= "BOTTOMRIGHT" or c ~= "BOTTOMRIGHT" then
						tooltip:ClearAllPoints()
					end
					tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
				end
			end)

			-- Position pet battle ability tooltips
			hooksecurefunc("PetBattleAbilityTooltip_Show", function(void, parent)
				if LeaPlusLC["TipMoveTip"] == "On" then
					if parent == UIParent then
						local a,b,c,d,e = PetBattlePrimaryAbilityTooltip:GetPoint()
						if a ~= "BOTTOMRIGHT" or c ~= "BOTTOMRIGHT" then
							PetBattlePrimaryAbilityTooltip:ClearAllPoints()
						end
						PetBattlePrimaryAbilityTooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
					end
				end
			end)

			----------------------------------------------------------------------
			--	Tooltip Configuration
			----------------------------------------------------------------------

			local LT = {}

			-- Create locale specific level string
			LT["LevelLocale"] = strtrim(strtrim(string.gsub(TOOLTIP_UNIT_LEVEL, "%%s", "")))

			-- Tooltip
			LT["ColorBlind"] = GetCVar("colorblindMode")

			-- 	Create drag frame
			local TipDrag = CreateFrame("Frame", nil, UIParent)
			TipDrag:SetToplevel(true);
			TipDrag:SetClampedToScreen(false);
			TipDrag:SetSize(130, 64);
			TipDrag:Hide();
			TipDrag:SetFrameStrata("TOOLTIP")
			TipDrag:SetMovable(true)
			TipDrag:SetBackdropColor(0.0, 0.5, 1.0);
			TipDrag:SetBackdrop({ 
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false, tileSize = 0, edgeSize = 16,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }});

			-- Show text in drag frame
			TipDrag.f = TipDrag:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
			TipDrag.f:SetPoint("CENTER", 0, 0)
			TipDrag.f:SetText(L["Tooltip"])

			-- Create texture
			TipDrag.t = TipDrag:CreateTexture();
			TipDrag.t:SetAllPoints();
			TipDrag.t:SetColorTexture(0.0, 0.5, 1.0, 0.5);
			TipDrag.t:SetAlpha(0.5);

			---------------------------------------------------------------------------------------------------------
			-- Tooltip movement settings
			---------------------------------------------------------------------------------------------------------

			-- Create tooltip customisation side panel
			local SideTip = LeaPlusLC:CreatePanel("Tooltip", "SideTip")

			-- Add controls
			LeaPlusLC:MakeTx(SideTip, "Settings", 16, -72)
			LeaPlusLC:MakeCB(SideTip, "TipMoveTip", "Reposition the tooltip", 16, -92, false, "If checked, you will be able to reposition the tooltip.")
			LeaPlusLC:MakeCB(SideTip, "TipShowRank", "Show guild ranks for your guild", 16, -112, false, "If checked, guild ranks will be shown for players in your guild.")
			LeaPlusLC:MakeCB(SideTip, "TipShowTarget", "Show the unit's target", 16, -132, false, "If checked, unit targets will be shown.")
			LeaPlusLC:MakeCB(SideTip, "TipBackSimple", "Color the backdrops based on faction", 16, -152, false, "If checked, backdrops will be tinted blue (friendly) or red (hostile).")
			LeaPlusLC:MakeCB(SideTip, "TipHideInCombat", "Hide tooltips for world units during combat", 16, -172, false, "If checked, tooltips for world units will be hidden during combat.|n|nYou can hold the shift key down to override this setting.")

			LeaPlusLC:MakeTx(SideTip, "Tooltip scale", 356, -72)
			LeaPlusLC:MakeSL(SideTip, "LeaPlusTipSize", "", 0.50, 2.00, 0.05, 356, -92, "%.2f")

			-- Help button hidden
			SideTip.h:Hide()

			-- Back button handler
			SideTip.b:SetScript("OnClick", function() 
				SideTip:Hide();
				if TipDrag:IsShown() then
					TipDrag:Hide();
				end
				LeaPlusLC["PageF"]:Show();
				LeaPlusLC["Page5"]:Show();
				return
			end) 

			-- Reset button handler
			SideTip.r:SetScript("OnClick", function()
				LeaPlusLC["TipMoveTip"] = "On";
				LeaPlusLC["TipShowRank"] = "On";
				LeaPlusLC["TipShowTarget"] = "On";
				LeaPlusLC["TipBackSimple"] = "Off";
				LeaPlusLC["TipHideInCombat"] = "Off";
				LeaPlusLC["LeaPlusTipSize"] = 1.00
				LeaPlusLC["TipOffsetX"] = -13
				LeaPlusLC["TipOffsetY"] = 94
				TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
				LeaPlusLC:SetTipScale()
				SideTip:Hide(); SideTip:Show();
			end)

			-- Show tooltip overlay only if reposition checkbox is checked
			LeaPlusCB["TipMoveTip"]:HookScript("OnClick", function()
				if LeaPlusLC["TipMoveTip"] == "On" then
					TipDrag:Show()
				else
					TipDrag:Hide()
				end
			end)

			-- Show drag frame with configuration panel
			SideTip:HookScript("OnShow", function()
				if LeaPlusLC["TipMoveTip"] == "On" then
					TipDrag:Show()
				end
			end)
			SideTip:HookScript("OnHide", function() TipDrag:Hide() end)

			-- Control movement functions
			local void, LTax, LTay, LTbx, LTby, LTcx, LTcy
			TipDrag:SetScript("OnMouseDown", function(self, btn)
				if btn == "LeftButton" then
					void, void, void, LTax, LTay = TipDrag:GetPoint()
					TipDrag:StartMoving()
					void, void, void, LTbx, LTby = TipDrag:GetPoint()
				end
			end)
			TipDrag:SetScript("OnMouseUp", function(self, btn)
				if btn == "LeftButton" then
					void, void, void, LTcx, LTcy = TipDrag:GetPoint()
					TipDrag:StopMovingOrSizing();
					LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"] = LTcx - LTbx + LTax, LTcy - LTby + LTay
					TipDrag:ClearAllPoints()
					TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"])
				end
			end)

			--	Move the tooltip
			LeaPlusCB["MoveTooltipButton"]:SetScript("OnClick", function()
				if IsShiftKeyDown() and IsControlKeyDown() then
					-- Preset profile
					LeaPlusLC["TipMoveTip"] = "On";
					LeaPlusLC["TipShowRank"] = "On";
					LeaPlusLC["TipShowTarget"] = "On";
					LeaPlusLC["TipBackSimple"] = "On";
					LeaPlusLC["TipHideInCombat"] = "Off";
					LeaPlusLC["LeaPlusTipSize"] = 1.25
					LeaPlusLC["TipOffsetX"] = -13
					LeaPlusLC["TipOffsetY"] = 94
					TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"]);
					LeaPlusLC:SetTipScale()
					LeaPlusLC:SetDim();
					LeaPlusLC:ReloadCheck();
					SideTip:Show(); SideTip:Hide(); -- Needed to update tooltip scale
					LeaPlusLC["PageF"]:Hide(); LeaPlusLC["PageF"]:Show();
				else
					-- Show tooltip configuration panel
					LeaPlusLC:HideFrames();
					SideTip:Show();

					-- Set scale
					TipDrag:SetScale(LeaPlusLC["LeaPlusTipSize"])

					-- Set position of the drag frame
					TipDrag:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", LeaPlusLC["TipOffsetX"], LeaPlusLC["TipOffsetY"])
				end			

			end)
					
			---------------------------------------------------------------------------------------------------------
			-- Tooltip scale settings
			---------------------------------------------------------------------------------------------------------

			-- Function to set the tooltip scale
			local function SetTipScale()
				if LeaPlusLC["TipModEnable"] == "On" then

					-- General tooltip
					if GameTooltip then GameTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Friends
					if FriendsTooltip then FriendsTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- AutoCompleteBox
					if AutoCompleteBox then AutoCompleteBox:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Reputation
					if ReputationParagonTooltip then ReputationParagonTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Pet battles and battle pets
					if PetBattlePrimaryAbilityTooltip then PetBattlePrimaryAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if PetBattlePrimaryUnitTooltip then PetBattlePrimaryUnitTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if BattlePetTooltip then BattlePetTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingBattlePetTooltip then FloatingBattlePetTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Garrison
					if FloatingGarrisonFollowerTooltip then FloatingGarrisonFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingGarrisonFollowerAbilityTooltip then FloatingGarrisonFollowerAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingGarrisonMissionTooltip then FloatingGarrisonMissionTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if FloatingGarrisonShipyardFollowerTooltip then FloatingGarrisonShipyardFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Order Hall
					if GarrisonFollowerMissionAbilityWithoutCountersTooltip then GarrisonFollowerMissionAbilityWithoutCountersTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if GarrisonFollowerAbilityWithoutCountersTooltip then GarrisonFollowerAbilityWithoutCountersTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Items (links, comparisons)
					if ItemRefTooltip then ItemRefTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ItemRefShoppingTooltip1 then ItemRefShoppingTooltip1:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ItemRefShoppingTooltip2 then ItemRefShoppingTooltip2:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ShoppingTooltip1 then ShoppingTooltip1:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if ShoppingTooltip2 then ShoppingTooltip2:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- World map (objectives, story, comparisons)
					if WorldMapTooltip then WorldMapTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if WorldMapCompareTooltip1 then WorldMapCompareTooltip1:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if WorldMapCompareTooltip2 then WorldMapCompareTooltip2:SetScale(LeaPlusLC["LeaPlusTipSize"]) end
					if QuestScrollFrame.StoryTooltip then
						QuestScrollFrame.StoryTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
						QuestScrollFrame.StoryTooltip:SetFrameStrata("TOOLTIP")
					end

					-- Minimap (PVP queue status)
					if QueueStatusFrame then QueueStatusFrame:SetScale(LeaPlusLC["LeaPlusTipSize"]) end

					-- Leatrix Plus
					TipDrag:SetScale(LeaPlusLC["LeaPlusTipSize"])

					-- Set slider formatted text
					LeaPlusCB["LeaPlusTipSize"].f:SetFormattedText("%.0f%%", LeaPlusLC["LeaPlusTipSize"] * 100)

				end
				return
			end

			-- Give function a file level scope
			LeaPlusLC.SetTipScale = SetTipScale

			-- Set tooltip scale when slider or checkbox changes and on startup
			LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetTipScale)
			SetTipScale()

			----------------------------------------------------------------------
			-- Contribution frame
			----------------------------------------------------------------------

			local function ContributionTipFunc()

				-- Function to set tooltip scale
				local function SetContributionTipScale()
					ContributionTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					ContributionBuffTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetContributionTipScale)
				SetContributionTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_Contribution") then
				ContributionTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Contribution" then
						ContributionTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Pet Journal tooltips
			----------------------------------------------------------------------

			local function PetJournalTipFunc()

				-- Function to set tooltip scale
				local function SetPetJournalTipScale()
					PetJournalPrimaryAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetPetJournalTipScale)
				SetPetJournalTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_Collections") then
				PetJournalTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_Collections" then
						PetJournalTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Encounter Journal tooltips
			----------------------------------------------------------------------

			local function EncounterJournalTipFunc()

				-- Function to set tooltip scale
				local function SetEncounterJournalTipScale()
					EncounterJournalTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetEncounterJournalTipScale)
				SetEncounterJournalTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_EncounterJournal") then
				EncounterJournalTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_EncounterJournal" then
						EncounterJournalTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Death Recap frame tooltips
			----------------------------------------------------------------------

			local function DeathRecapFrameFunc()

				-- Simple fix to prevent mousing over units behind the frame
				DeathRecapFrame:EnableMouse(true)

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_DeathRecap") then
				DeathRecapFrameFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_DeathRecap" then
						DeathRecapFrameFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- PVP UI tooltips
			----------------------------------------------------------------------

			local function PVPRewardTipFunc()

				-- Function to set tooltip scale
				local function PVPRewardSetTip()
					PVPRewardTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", PVPRewardSetTip)
				PVPRewardSetTip()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_PVPUI") then
				PVPRewardTipFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_PVPUI" then
						PVPRewardTipFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			----------------------------------------------------------------------
			-- Garrison tooltips
			----------------------------------------------------------------------

			local function GarrisonFunc()

				-- Function to set tooltip scale
				local function SetGarrisonTipScale()
					GarrisonFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonFollowerAbilityTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonMissionMechanicTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonMissionMechanicFollowerCounterTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonBuildingFrame.BuildingLevelTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonBonusAreaTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonShipyardMapMissionTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
					GarrisonShipyardFollowerTooltip:SetScale(LeaPlusLC["LeaPlusTipSize"])
				end

				-- Set tooltip scale when slider changes and on startup
				LeaPlusCB["LeaPlusTipSize"]:HookScript("OnValueChanged", SetGarrisonTipScale)
				SetGarrisonTipScale()

			end

			-- Run function when Blizzard addon has loaded
			if IsAddOnLoaded("Blizzard_GarrisonUI") then
				GarrisonFunc()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript("OnEvent", function(self, event, arg1)
					if arg1 == "Blizzard_GarrisonUI" then
						GarrisonFunc()
						waitFrame:UnregisterAllEvents()
					end
				end)
			end

			---------------------------------------------------------------------------------------------------------
			-- Other tooltip code
			---------------------------------------------------------------------------------------------------------

			-- Colorblind setting change
			TipDrag:RegisterEvent("CVAR_UPDATE");
			TipDrag:SetScript("OnEvent", function(self, event, arg1, arg2)
				if (arg1 == "USE_COLORBLIND_MODE") then
					LT["ColorBlind"] = arg2;
				end
			end)

			-- Store locals
			local TipMClass = LOCALIZED_CLASS_NAMES_MALE
			local TipFClass = LOCALIZED_CLASS_NAMES_FEMALE

			-- Level string
			local LevelString, LevelString2
			if GameLocale == "ruRU" then
				-- Level string for ruRU
				LevelString = "уровня"
				LevelString2 = "уровень"
			else
				-- Level string for all other locales
				LevelString = string.lower(TOOLTIP_UNIT_LEVEL:gsub("%%s",".+"))
				LevelString2 = ""
			end

			-- Tag locale (code construction from tiplang)
			local ttLevel, ttBoss, ttElite, ttRare, ttRareElite, ttRareBoss, ttTarget
			if 		GameLocale == "zhCN" then 	ttLevel = "等级"		; ttBoss = "首领"	; ttElite = "精英"	; ttRare = "精良"	; ttRareElite = "精良 精英"		; ttRareBoss = "精良 首领"		; ttTarget = "目标"
			elseif 	GameLocale == "zhTW" then 	ttLevel = "等級"		; ttBoss = "首領"	; ttElite = "精英"	; ttRare = "精良"	; ttRareElite = "精良 精英"		; ttRareBoss = "精良 首領"		; ttTarget = "目標"
			elseif 	GameLocale == "ruRU" then 	ttLevel = "Уровень"	; ttBoss = "босс"	; ttElite = "элита"	; ttRare = "Редкое"	; ttRareElite = "Редкое элита"	; ttRareBoss = "Редкое босс"	; ttTarget = "Цель"
			elseif 	GameLocale == "koKR" then 	ttLevel = "레벨"		; ttBoss = "우두머리"	; ttElite = "정예"	; ttRare = "희귀"	; ttRareElite = "희귀 정예"		; ttRareBoss = "희귀 우두머리"		; ttTarget = "대상"
			elseif 	GameLocale == "esMX" then 	ttLevel = "Nivel"	; ttBoss = "Jefe"	; ttElite = "Élite"	; ttRare = "Raro"	; ttRareElite = "Raro Élite"	; ttRareBoss = "Raro Jefe"		; ttTarget = "Objetivo"
			elseif 	GameLocale == "ptBR" then 	ttLevel = "Nível"	; ttBoss = "Chefe"	; ttElite = "Elite"	; ttRare = "Raro"	; ttRareElite = "Raro Elite"	; ttRareBoss = "Raro Chefe"		; ttTarget = "Alvo"
			elseif 	GameLocale == "deDE" then 	ttLevel = "Stufe"	; ttBoss = "Boss"	; ttElite = "Elite"	; ttRare = "Selten"	; ttRareElite = "Selten Elite"	; ttRareBoss = "Selten Boss"	; ttTarget = "Ziel"
			elseif 	GameLocale == "esES" then	ttLevel = "Nivel"	; ttBoss = "Jefe"	; ttElite = "Élite"	; ttRare = "Raro"	; ttRareElite = "Raro Élite"	; ttRareBoss = "Raro Jefe"		; ttTarget = "Objetivo"
			elseif 	GameLocale == "frFR" then 	ttLevel = "Niveau"	; ttBoss = "Boss"	; ttElite = "Élite"	; ttRare = "Rare"	; ttRareElite = "Rare Élite"	; ttRareBoss = "Rare Boss"		; ttTarget = "Cible"
			elseif 	GameLocale == "itIT" then 	ttLevel = "Livello"	; ttBoss = "Boss"	; ttElite = "Élite"	; ttRare = "Raro"	; ttRareElite = "Raro Élite"	; ttRareBoss = "Raro Boss"		; ttTarget = "Bersaglio"
			else 								ttLevel = "Level"	; ttBoss = "Boss"	; ttElite = "Elite"	; ttRare = "Rare"	; ttRareElite = "Rare Elite"	; ttRareBoss = "Rare Boss"		; ttTarget = "Target"
			end

			-- Show tooltip
			local function ShowTip()

				-- Do nothing if CTRL, SHIFT and ALT are being held
				if IsControlKeyDown() and IsAltKeyDown() and IsShiftKeyDown() then 
					return
				end

				-- Get unit information
				if GetMouseFocus() == WorldFrame then
					LT["Unit"] = "mouseover"
					-- Hide and quit if tips should be hidden during combat 
					if LeaPlusLC["TipHideInCombat"] == "On" and UnitAffectingCombat("player") and not IsShiftKeyDown() then
						GameTooltip:Hide()
						return
					end
				else
					LT["Unit"] = select(2, GameTooltip:GetUnit())
					if not (LT["Unit"]) then return end
				end

				-- Quit if unit has no reaction to player
				LT["Reaction"] = UnitReaction(LT["Unit"], "player") or nil
				if not LT["Reaction"] then 
					return
				end

				-- Quit if unit is a wild pet
				if UnitIsWildBattlePet(LT["Unit"]) then return end

				-- Setup variables
				LT["TipUnitName"], LT["TipUnitRealm"] = UnitName(LT["Unit"])
				LT["TipIsPlayer"] = UnitIsPlayer(LT["Unit"])
				LT["UnitLevel"] = UnitEffectiveLevel(LT["Unit"])
				LT["RealLevel"] = UnitLevel(LT["Unit"])
				LT["UnitClass"] = select(2, UnitClassBase(LT["Unit"]))
				LT["PlayerControl"] = UnitPlayerControlled(LT["Unit"])
				LT["PlayerRace"] = UnitRace(LT["Unit"])

				-- Get guild information
				if LT["TipIsPlayer"] then
					if GetGuildInfo(LT["Unit"]) then
						-- Unit is guilded
						if LT["ColorBlind"] == "1" then
							LT["GuildLine"], LT["InfoLine"] = 2, 4
						else
							LT["GuildLine"], LT["InfoLine"] = 2, 3
						end
						LT["GuildName"], LT["GuildRank"] = GetGuildInfo(LT["Unit"])
					else
						-- Unit is not guilded
						LT["GuildName"] = nil
						if LT["ColorBlind"] == "1" then
							LT["GuildLine"], LT["InfoLine"] = 0, 3
						else
							LT["GuildLine"], LT["InfoLine"] = 0, 2
						end
					end
					-- Lower information line if unit is charmed
					if UnitIsCharmed(LT["Unit"]) then
						LT["InfoLine"] = LT["InfoLine"] + 1
					end
				end

				-- Determine class color
				if LT["UnitClass"] then
					-- Define male or female (for certain locales)
					LT["Sex"] = UnitSex(LT["Unit"])
					if LT["Sex"] == 2 then
						LT["Class"] = TipMClass[LT["UnitClass"]]
					else
						LT["Class"] = TipFClass[LT["UnitClass"]]
					end
					-- Define class color
					LT["ClassCol"] = LeaPlusLC["RaidColors"][LT["UnitClass"]]
					LT["LpTipClassColor"] = "|cff" .. string.format("%02x%02x%02x", LT["ClassCol"].r * 255, LT["ClassCol"].g * 255, LT["ClassCol"].b * 255)
				end

				----------------------------------------------------------------------
				-- Name line
				----------------------------------------------------------------------

				if ((LT["TipIsPlayer"]) or (LT["PlayerControl"])) or LT["Reaction"] > 4 then

					-- If it's a player show name in class color
					if LT["TipIsPlayer"] then
						LT["NameColor"] = LT["LpTipClassColor"]
					else
						-- If not, set to green or blue depending on PvP status
						if UnitIsPVP(LT["Unit"]) then
							LT["NameColor"] = "|cff00ff00"
						else
							LT["NameColor"] = "|cff00aaff"
						end
					end

					-- Show name
					LT["NameText"] = UnitPVPName(LT["Unit"]) or LT["TipUnitName"]

					-- Show realm
					if LT["TipUnitRealm"] then
						LT["NameText"] = LT["NameText"] .. " - " .. LT["TipUnitRealm"]
					end

					-- Show dead units in grey
					if UnitIsDeadOrGhost(LT["Unit"]) then
						LT["NameColor"] = "|c88888888"
					end

					-- Show name line
					_G["GameTooltipTextLeft1"]:SetText(LT["NameColor"] .. LT["NameText"] .. "|cffffffff|r")
					
				elseif UnitIsDeadOrGhost(LT["Unit"]) then

					-- Show grey name for other dead units
					_G["GameTooltipTextLeft1"]:SetText("|c88888888" .. (_G["GameTooltipTextLeft1"]:GetText() or "") .. "|cffffffff|r")
					return

				end

				----------------------------------------------------------------------
				-- Guild line
				----------------------------------------------------------------------

				if LT["TipIsPlayer"] and LT["GuildName"] then
					
					-- Show guild line
					if LeaPlusLC["TipShowRank"] == "On" then
						if UnitIsInMyGuild(LT["Unit"]) then
							_G["GameTooltipTextLeft" .. LT["GuildLine"]]:SetText("|c00aaaaff" .. LT["GuildName"] .. " - " .. LT["GuildRank"] .. "|r")
						else
							_G["GameTooltipTextLeft" .. LT["GuildLine"]]:SetText("|c00aaaaff" .. LT["GuildName"] .. "|cffffffff|r")
						end
					else
						_G["GameTooltipTextLeft" .. LT["GuildLine"]]:SetText("|c00aaaaff" .. LT["GuildName"] .. "|cffffffff|r")
					end

				end

				----------------------------------------------------------------------
				-- Information line (level, class, race)
				----------------------------------------------------------------------

				if LT["TipIsPlayer"] then

					-- Show level
					if LT["Reaction"] < 5 then
						if LT["UnitLevel"] == -1 then
							LT["InfoText"] = ("|cffff3333" .. ttLevel .. " ??|cffffffff")
						else
							LT["LevelColor"] = GetCreatureDifficultyColor(LT["UnitLevel"])
							LT["LevelColor"] = string.format('%02x%02x%02x', LT["LevelColor"].r * 255, LT["LevelColor"].g * 255, LT["LevelColor"].b * 255)
							LT["InfoText"] = ("|cff" .. LT["LevelColor"] .. LT["LevelLocale"] .. " " .. LT["UnitLevel"] .. "|cffffffff")
						end
					else
						if LT["UnitLevel"] ~= LT["RealLevel"] then 
							LT["InfoText"] = LT["LevelLocale"] .. " " .. LT["UnitLevel"] .. " (" .. LT["RealLevel"] .. ")"
						else
							LT["InfoText"] = LT["LevelLocale"] .. " " .. LT["UnitLevel"]
						end
					end

					-- Show race
					if LT["PlayerRace"] then
						LT["InfoText"] = LT["InfoText"] .. " " .. LT["PlayerRace"]
					end

					-- Show class
					LT["InfoText"] = LT["InfoText"] .. " " .. LT["LpTipClassColor"] .. LT["Class"] or LT["InfoText"]

					-- Show information line
					_G["GameTooltipTextLeft" .. LT["InfoLine"]]:SetText(LT["InfoText"] .. "|cffffffff|r")

				end

				----------------------------------------------------------------------
				-- Mob name in brighter red (alive) and steel blue (tap denied)
				----------------------------------------------------------------------

				if not (LT["TipIsPlayer"]) and LT["Reaction"] < 4 and not (LT["PlayerControl"]) then
					if UnitIsTapDenied(LT["Unit"]) then
						LT["NameText"] = "|c8888bbbb" .. LT["TipUnitName"] .. "|r"
					else
						LT["NameText"] = "|cffff3333" .. LT["TipUnitName"] .. "|r"
					end
					_G["GameTooltipTextLeft1"]:SetText(LT["NameText"])
				end

				----------------------------------------------------------------------
				-- Mob level in color (neutral or lower)
				----------------------------------------------------------------------

				if UnitCanAttack(LT["Unit"], "player") and not (LT["TipIsPlayer"]) and LT["Reaction"] < 5 and not (LT["PlayerControl"]) then

					-- Find the level line
					LT["MobInfoLine"] = 0
					local line2, line3, line4 = _G["GameTooltipTextLeft2"]:GetText(), _G["GameTooltipTextLeft3"]:GetText(), _G["GameTooltipTextLeft4"]:GetText()
					if GameLocale == "ruRU" then -- Additional check for ruRU
						if line2 and string.lower(line2):find(LevelString2) then LT["MobInfoLine"] = 2 end
						if line3 and string.lower(line3):find(LevelString2) then LT["MobInfoLine"] = 3 end
						if line4 and string.lower(line4):find(LevelString2) then LT["MobInfoLine"] = 4 end
					end
					if line2 and string.lower(line2):find(LevelString) then LT["MobInfoLine"] = 2 end
					if line3 and string.lower(line3):find(LevelString) then LT["MobInfoLine"] = 3 end
					if line4 and string.lower(line4):find(LevelString) then LT["MobInfoLine"] = 4 end

					-- Show level line
					if LT["MobInfoLine"] > 1 then

						-- Level ?? mob
						if LT["UnitLevel"] == -1 then
							LT["InfoText"] = "|cffff3333" .. ttLevel .. " ??|cffffffff "

						-- Mobs within level range
						else
							LT["MobColor"] = GetCreatureDifficultyColor(LT["UnitLevel"])
							LT["MobColor"] = string.format('%02x%02x%02x', LT["MobColor"].r * 255, LT["MobColor"].g * 255, LT["MobColor"].b * 255)
							LT["InfoText"] = "|cff" .. LT["MobColor"] .. LT["LevelLocale"] .. " " .. LT["UnitLevel"] .. "|cffffffff "
						end

						-- Show creature type and classification
						LT["CreatureType"] = UnitCreatureType(LT["Unit"])
						if (LT["CreatureType"]) and not (LT["CreatureType"] == "Not specified") then
							LT["InfoText"] = LT["InfoText"] .. "|cffffffff" .. LT["CreatureType"] .. "|cffffffff "
						end

						-- Rare, elite and boss mobs
						LT["Special"] = UnitClassification(LT["Unit"])
						if LT["Special"] then
							if LT["Special"] == "elite" then
								if strfind(_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:GetText(), "(" .. ttBoss .. ")") then
									LT["Special"] = "(" .. ttBoss .. ")"
								else
									LT["Special"] = "(" .. ttElite .. ")"
								end
							elseif LT["Special"] == "rare" then
								LT["Special"] = "|c00e066ff(" .. ttRare .. ")"
							elseif LT["Special"] == "rareelite" then
								if strfind(_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:GetText(), "(" .. ttBoss .. ")") then
									LT["Special"] = "|c00e066ff(" .. ttRareBoss .. ")"
								else
									LT["Special"] = "|c00e066ff(" .. ttRareElite .. ")"
								end
							elseif LT["Special"] == "worldboss" then
								LT["Special"] = "(" .. ttBoss .. ")"
							elseif LT["UnitLevel"] == -1 and LT["Special"] == "normal" and strfind(_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:GetText(), "(" .. ttBoss .. ")") then
								LT["Special"] = "(" .. ttBoss .. ")"
							else
								LT["Special"] = nil 
							end

							if (LT["Special"]) then
								LT["InfoText"] = LT["InfoText"] .. LT["Special"]
							end
						end

						-- Show mob info line
						_G["GameTooltipTextLeft" .. LT["MobInfoLine"]]:SetText(LT["InfoText"])

					end

				end

				----------------------------------------------------------------------
				-- Backdrop color
				----------------------------------------------------------------------

				LT["TipFaction"] = UnitFactionGroup(LT["Unit"])

				if UnitCanAttack("player", LT["Unit"]) and not (UnitIsDeadOrGhost(LT["Unit"])) and not (LT["TipFaction"] == nil) and not (LT["TipFaction"] == UnitFactionGroup("player")) then
					-- Hostile faction
					if LeaPlusLC["TipBackSimple"] == "On" then
						GameTooltip:SetBackdropColor(0.5, 0.0, 0.0);
					else
						GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
					end
				else
					-- Friendly faction
					if LeaPlusLC["TipBackSimple"] == "On" then
						GameTooltip:SetBackdropColor(0.0, 0.0, 0.5);
					else
						GameTooltip:SetBackdropColor(0.0, 0.0, 0.0);
					end
				end

				----------------------------------------------------------------------
				--	Show target
				----------------------------------------------------------------------

				if LeaPlusLC["TipShowTarget"] == "On" then

					-- Get target
					LT["Target"] = UnitName(LT["Unit"] .. "target");

					-- If target doesn't exist, quit
					if LT["Target"] == nil or LT["Target"] == "" then return end

					-- If target is you, set target to YOU
					if (UnitIsUnit(LT["Target"], "player")) then 
						LT["Target"] = ("|c12ff4400>>你<<")

					-- If it's not you, but it's a player, show target in class color
					elseif UnitIsPlayer(LT["Unit"] .. "target") then
						LT["TargetBase"] = select(2, UnitClassBase(LT["Unit"] .. "target"))
						LT["TargetCol"] = LeaPlusLC["RaidColors"][LT["TargetBase"]]
						LT["TargetCol"] = "|cff" .. string.format('%02x%02x%02x', LT["TargetCol"].r * 255, LT["TargetCol"].g * 255, LT["TargetCol"].b * 255)
						LT["Target"] = (LT["TargetCol"] .. LT["Target"])

					end
					
					-- Add target line
					GameTooltip:AddLine(ttTarget .. ": " .. LT["Target"])

				end

			end

			GameTooltip:HookScript("OnTooltipSetUnit", ShowTip)
			
		end

		----------------------------------------------------------------------
		--	Move chat editbox to top
		----------------------------------------------------------------------

		if LeaPlusLC["MoveChatEditBoxToTop"] == "On" then

			-- Set options for normal chat frames
			for i = 1, 50 do
				if _G["ChatFrame" .. i] then
					-- Position the editbox
					_G["ChatFrame" .. i .. "EditBox"]:ClearAllPoints();
					_G["ChatFrame" .. i .. "EditBox"]:SetPoint("TOPLEFT", _G["ChatFrame" .. i], 0, 0);
					_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth());
					-- Ensure editbox width matches chatframe width
					_G["ChatFrame" .. i]:HookScript("OnSizeChanged", function()
						_G["ChatFrame" .. i .. "EditBox"]:SetWidth(_G["ChatFrame" .. i]:GetWidth())
					end)
				end
			end

			-- Do the functions above for other chat frames (pet battles, whispers, etc)
			hooksecurefunc("FCF_OpenTemporaryWindow", function()

				local cf = FCF_GetCurrentChatFrame():GetName() or nil
				if cf then

					-- Position the editbox
					_G[cf .. "EditBox"]:ClearAllPoints();
					_G[cf .. "EditBox"]:SetPoint("TOPLEFT", cf, "TOPLEFT", 0, 0);
					_G[cf .. "EditBox"]:SetWidth(_G[cf]:GetWidth());

					-- Ensure editbox width matches chatframe width
					_G[cf]:HookScript("OnSizeChanged", function()
						_G[cf .. "EditBox"]:SetWidth(_G[cf]:GetWidth())
					end)

				end
			end)

		end

		----------------------------------------------------------------------
		-- Viewport
		----------------------------------------------------------------------

		if LeaPlusLC["ViewPortEnable"] == "On" then

			-- Create border textures
			local BordTop = WorldFrame:CreateTexture(nil, "ARTWORK"); BordTop:SetColorTexture(0, 0, 0, 1); BordTop:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0); BordTop:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0)
			local BordBot = WorldFrame:CreateTexture(nil, "ARTWORK"); BordBot:SetColorTexture(0, 0, 0, 1); BordBot:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0); BordBot:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)
			local BordLeft = WorldFrame:CreateTexture(nil, "ARTWORK"); BordLeft:SetColorTexture(0, 0, 0, 1); BordLeft:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0); BordLeft:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 0, 0)
			local BordRight = WorldFrame:CreateTexture(nil, "ARTWORK"); BordRight:SetColorTexture(0, 0, 0, 1); BordRight:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, 0); BordRight:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 0, 0)

			-- Function to set viewport parameters
			local function RefreshViewport()

				if LeaPlusLC["ViewPortResize"] == "On" then
					-- Resize is on, remove top and bottom borders and resize game world
					BordTop:SetHeight(0)
					BordBot:SetHeight(0)
					WorldFrame:SetPoint("TOPLEFT", 0, -LeaPlusLC["ViewPortTop"])
					WorldFrame:SetPoint("BOTTOMRIGHT", 0, LeaPlusLC["ViewPortBottom"])
				else
					-- Resize is off, set top and bottom border height and maximise game world
					BordTop:SetHeight(LeaPlusLC["ViewPortTop"])
					BordBot:SetHeight(LeaPlusLC["ViewPortBottom"])
					WorldFrame:SetPoint("TOPLEFT", 0, 0)
					WorldFrame:SetPoint("BOTTOMRIGHT", 0, 0)
				end

				-- Set top and bottom border transparency
				BordTop:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])
				BordBot:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])

				-- Set left and right border width and transparency
				BordLeft:SetWidth(LeaPlusLC["ViewPortLeft"]); BordLeft:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])
				BordRight:SetWidth(LeaPlusLC["ViewPortRight"]); BordRight:SetAlpha(1 - LeaPlusLC["ViewPortAlpha"])

				-- Hide borders if they aren't being used
				if LeaPlusLC["ViewPortTop"] == 0 or LeaPlusLC["ViewPortResize"] == "On" then BordTop:Hide() else BordTop:Show() end
				if LeaPlusLC["ViewPortBottom"] == 0 or LeaPlusLC["ViewPortResize"] == "On" then BordBot:Hide() else BordBot:Show() end
				if LeaPlusLC["ViewPortLeft"] == 0 then BordLeft:Hide() else BordLeft:Show() end
				if LeaPlusLC["ViewPortRight"] == 0 then BordRight:Hide() else BordRight:Show() end

				-- Show formatted slider value
				LeaPlusCB["ViewPortAlpha"].f:SetFormattedText("%.0f%%", LeaPlusLC["ViewPortAlpha"] * 100)

			end

			-- Create viewport configuration panel
			local SideViewport = LeaPlusLC:CreatePanel("Viewport", "SideViewport")

			-- Create slider controls
			LeaPlusLC:MakeTx(SideViewport, "Top", 16, -72)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortTop", "", 0, 300, 5, 16, -92, "%.0f")
			LeaPlusCB["ViewPortTop"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Bottom", 16, -132)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortBottom", "", 0, 300, 5, 16, -152, "%.0f")
			LeaPlusCB["ViewPortBottom"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Left", 186, -72)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortLeft", "", 0, 300, 5, 186, -92, "%.0f")
			LeaPlusCB["ViewPortLeft"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Right", 186, -132)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortRight", "", 0, 300, 5, 186, -152, "%.0f")
			LeaPlusCB["ViewPortRight"]:HookScript("OnValueChanged", RefreshViewport)

			LeaPlusLC:MakeTx(SideViewport, "Transparency", 356, -132)
			LeaPlusLC:MakeSL(SideViewport, "ViewPortAlpha", "", 0, 1, 0.1, 356, -152, "%.1f")
			LeaPlusCB["ViewPortAlpha"]:HookScript("OnValueChanged", RefreshViewport)

			-- Add resize game world checkbox
			LeaPlusLC:MakeTx(SideViewport, "Settings", 16, -192)
			LeaPlusLC:MakeCB(SideViewport, "ViewPortResize", "Resize the game world", 16, -212, false, "If checked, the game world will be resized to fit between the top and bottom borders.|n|nNote that if you enable this setting, the transparency slider will no longer affect the top and bottom borders.")

			-- Help button tooltip
			SideViewport.h.tiptext = L["This panel will close automatically if you enter combat."]

			-- Back button handler
			SideViewport.b:SetScript("OnClick", function() 
				SideViewport:Hide()
				LeaPlusLC["PageF"]:Show()
				LeaPlusLC["Page7"]:Show()
				return
			end) 

			-- Reset button handler
			SideViewport.r:SetScript("OnClick", function()
				LeaPlusLC["ViewPortTop"] = 0 
				LeaPlusLC["ViewPortBottom"] = 0
				LeaPlusLC["ViewPortLeft"] = 0
				LeaPlusLC["ViewPortRight"] = 0
				LeaPlusLC["ViewPortAlpha"] = 0
				LeaPlusLC["ViewPortResize"] = "Off"
				SideViewport:Hide(); SideViewport:Show()
				RefreshViewport()
			end)

			-- Configuration button handler
			LeaPlusCB["ModViewportBtn"]:SetScript("OnClick", function()
				if LeaPlusLC:PlayerInCombat() then
					return
				else
					if IsShiftKeyDown() and IsControlKeyDown() then
						-- Preset profile
						LeaPlusLC["ViewPortTop"] = 0 
						LeaPlusLC["ViewPortBottom"] = 0
						LeaPlusLC["ViewPortLeft"] = 0
						LeaPlusLC["ViewPortRight"] = 0
						LeaPlusLC["ViewPortAlpha"] = 0.7
						LeaPlusLC["ViewPortResize"] = "On"
						RefreshViewport()
					else
						SideViewport:Show()
						LeaPlusLC:HideFrames()
					end
				end
			end)

			-- Refresh viewport when resize checkbox is clicked and on startup
			LeaPlusCB["ViewPortResize"]:HookScript("OnClick", RefreshViewport)
			RefreshViewport()

			-- Hide the configuration panel if combat starts
			SideViewport:RegisterEvent("PLAYER_REGEN_DISABLED")
			SideViewport:SetScript("OnEvent", SideViewport.Hide)

		end

		----------------------------------------------------------------------
		-- Universal group chat color
		----------------------------------------------------------------------

		-- Universal group chat color (ColorPickerFrame:GetColorRGB())
		if LeaPlusLC["UnivGroupColor"] == "On" then
			-- Set raid and instance to party colors
			ChangeChatColor("RAID", 0.67, 0.67, 1)
			ChangeChatColor("RAID_LEADER", 0.46, 0.78, 1)
			ChangeChatColor("INSTANCE_CHAT", 0.67, 0.67, 1)
			ChangeChatColor("INSTANCE_CHAT_LEADER", 0.46, 0.78, 1)
		end

		----------------------------------------------------------------------
		-- Silence rested emotes
		----------------------------------------------------------------------

		-- Manage emotes
		if LeaPlusLC["NoRestedEmotes"] == "On" then

			-- Zone table 		English					, French					, German					, Italian						, Russian					, S Chinese	, Spanish					, T Chinese	,
			local zonetable = {	"The Halfhill Market"	, "Marché de Micolline"		, "Der Halbhügelmarkt"		, "Il Mercato di Mezzocolle"	, "Рынок Полугорья"			, "半山市集"	, "El Mercado del Alcor"	, "半丘市集"	,
								"The Grim Guzzler"		, "Le Sinistre écluseur"	, "Zum Grimmigen Säufer"	, "Torvo Beone"					, "Трактир Угрюмый обжора"	, "黑铁酒吧"	, "Tragapenas"				, "黑鐵酒吧"	,
								"The Summer Terrace"	, "La terrasse Estivale"	, "Die Sommerterrasse"		, "Terrazza Estiva"				, "Летняя терраса"			, "夏之台"	, "El Bancal del Verano"	, "夏日露臺"	,
			}

			-- Function to set rested state
			local function UpdateEmoteSound()

				-- Find character's current zone
				local szone = GetSubZoneText() or "None"

				-- Find out if emote sounds are disabled or enabled
				local emoset = GetCVar("Sound_EnableEmoteSounds")

				if IsResting() then
					-- Character is resting so silence emotes
					if emoset ~= "0" then
						SetCVar("Sound_EnableEmoteSounds", "0")
					end
					return
				end

				-- Traverse zone table and silence emotes if character is in a designated zone
				for k, v in next, zonetable do
					if szone == zonetable[k] then
						if emoset ~= "0" then
							SetCVar("Sound_EnableEmoteSounds", "0")
						end
						return
					end
				end

				-- Silence emotes if character is in a pet battle
				if C_PetBattles.IsInBattle() then
					if emoset ~= "0" then
						SetCVar("Sound_EnableEmoteSounds", "0")
					end
					return
				end

				-- If the above didn't return, emote sounds should be enabled
				if emoset ~= "1" then
					SetCVar("Sound_EnableEmoteSounds", "1")
				end
				return
			
			end

			-- Set emote sound when pet battles start and end
			hooksecurefunc("PetBattleFrame_Display", UpdateEmoteSound) 
			hooksecurefunc("PetBattleFrame_Remove",	UpdateEmoteSound)

			-- Set emote sound when rest state or zone changes
			local RestEvent = CreateFrame("FRAME")
			RestEvent:RegisterEvent("PLAYER_UPDATE_RESTING")
            RestEvent:RegisterEvent("ZONE_CHANGED_NEW_AREA")
			RestEvent:RegisterEvent("ZONE_CHANGED")
			RestEvent:RegisterEvent("ZONE_CHANGED_INDOORS")
            RestEvent:RegisterEvent("SUBZONE_CHANGED_NEW_AREA")
			RestEvent:SetScript("OnEvent", UpdateEmoteSound)

			-- Set sound setting at startup
			UpdateEmoteSound()

			-- Lock emote sounds checkbox in the game options panel
			AudioOptionsSoundPanelEmoteSounds.Enable = AudioOptionsSoundPanelEmoteSounds.Disable

		end

		----------------------------------------------------------------------
		-- Manage class colors
		----------------------------------------------------------------------

		if LeaPlusLC["Manageclasscolors"] == "On" then

			-- Set local channel colors and lock checkboxes
			for i=1, 18 do
				if _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"] then
					ToggleChatColorNamesByClassGroup(true, _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"]:GetParent().type);
					LeaPlusLC:LockItem(_G["ChatConfigChatSettingsLeftCheckBox" .. i .. "ColorClasses"],true)
				end
			end

			-- Set global channel colors
			for i=1, 50 do
				ToggleChatColorNamesByClassGroup(true, "CHANNEL"..i)
			end

			-- Lock global channel checkboxes on startup
			hooksecurefunc("ChatConfig_CreateCheckboxes", function(self, checkBoxTable, checkBoxTemplate, title)
				if ChatConfigChannelSettingsLeft.checkBoxTable then
					for i=1,50 do
						if _G["ChatConfigChannelSettingsLeftCheckBox" .. i .. "ColorClasses"] then
							LeaPlusLC:LockItem(_G["ChatConfigChannelSettingsLeftCheckBox" .. i .. "ColorClasses"],true)
						end
					end
				end
			end)

		end

		----------------------------------------------------------------------
		-- Final code for Player
		----------------------------------------------------------------------

		-- Register logout event to save settings
		LpEvt:RegisterEvent("PLAYER_LOGOUT")

		-- Unregister the player section (since it should only be run once)
		LpEvt:UnregisterEvent("PLAYER_ENTERING_WORLD")

		-- Release memory
		LeaPlusLC.Player = nil

	end

----------------------------------------------------------------------
-- 	L60: RunOnce
----------------------------------------------------------------------

	function LeaPlusLC:RunOnce()

		----------------------------------------------------------------------
		-- Remove cinematic cancel confirmation
		----------------------------------------------------------------------

		-- Allow space bar, escape key and enter key to cancel cinematic without confirmation
		CinematicFrame:HookScript("OnKeyDown", function(self, key)
			if key == "ESCAPE" then
				if CinematicFrame:IsShown() and CinematicFrame.closeDialog and CinematicFrameCloseDialogConfirmButton then
					CinematicFrameCloseDialog:Hide()
				end
			end
		end)
		CinematicFrame:HookScript("OnKeyUp", function(self, key)
			if key == "SPACE" or key == "ESCAPE" or key == "ENTER" then
				if CinematicFrame:IsShown() and CinematicFrame.closeDialog and CinematicFrameCloseDialogConfirmButton then
					CinematicFrameCloseDialogConfirmButton:Click()
				end
			end
		end)
		MovieFrame:HookScript("OnKeyUp", function(self, key)
			if key == "SPACE" or key == "ESCAPE" or key == "ENTER" then
				if MovieFrame:IsShown() and MovieFrame.CloseDialog and MovieFrame.CloseDialog.ConfirmButton then
					MovieFrame.CloseDialog.ConfirmButton:Click()
				end
			end
		end)

		----------------------------------------------------------------------
		-- Media player
		----------------------------------------------------------------------

		function LeaPlusLC:MediaFunc()

			-- Create tables for list data and zone listing
			local ListData, ZoneList, playlist = {}, {}, {}
			local scrollFrame, willPlay, musicHandle, ZonePage, LastPlayed, LastFolder, TempFolder, HeadingOfClickedTrack, LastMusicHandle
			local numButtons = 15
			local uframe = CreateFrame("FRAME")

			-- Create a table for each heading
			ZoneList = {L["Eastern"], L["Kalimdor"], L["Outland"], L["Northrend"], L["Maelstrom"], L["Pandaria"], L["Draenor"], L["Broken Isles"], L["Dungeons"], L["Various"], L["Random"], L["Search"], L["Movies"]}
			for k, v in ipairs(ZoneList) do
				ZoneList[v] = {}
			end

			-- Function to create a table for each zone
			local function Zn(where, zone, tracklist)
				tinsert(ZoneList[where], {zone = zone, tracks = tracklist})
			end

			-- Debug
			-- Zn(L["Eastern"], "Debug1", {"|cffffd800" .. L["Eastern"] .. ": Debug1", "1020#1020", "1021#1021", "1022#1022", "1023#1023", "1024#1024",})
			-- Zn(L["Eastern"], "Debug2", {"|cffffd800" .. L["Eastern"] .. ": Debug2", "1020#1020",})

			-- Eastern
			Zn(L["Eastern"], "|cffffd800" .. L["Eastern"], {""})
			Zn(L["Eastern"], L["Arathi Highlands"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Arathi Highlands"], "MUS_ArathiHighlands_GD#22292", "MUS_ArathiHighlands_GN#22293", "Zone-Desert Cave#5394", "Zone-Jungle Day#2525", "Zone-Mountain Night#2537", "Zone-Haunted#2990", "Zone-Orgrimmar#2901", "Zone-Volcanic Day#2529" , "Zone - Plaguelands#6066", "Moment - Battle05#6253", "Moment - Gloomy01#6074", "Moment-Stormwind08#5294",}) -- "Zone-Mystery#6065"
			Zn(L["Eastern"], L["Badlands"]						, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Badlands"], "MUS_Badlands_GD#22294", "MUS_BadlandsGoblin#22695", "MUS_BadlandsOgre#22691", "MUS_NewKargath#22692", "MUS_ScarOfTheWorldBreaker#22693", "MUS_TombOfTheWatchers#22694",})
			Zn(L["Eastern"], L["Blasted Lands"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Blasted Lands"], "MUS_BlastedLands_GD#22296", "MUS_BlastedLandsGilnean#22688", "MUS_BlastedLandsHuman#22684", "MUS_BlastedLandsOgre#22682", "MUS_BlastedLandsShadowsworn#22679", "MUS_BlastedLandsTainted#22683", "MUS_BloodwashCavern#22680", "MUS_NethergardeMines#22686", "MUS_SunveilExcursion#22689", "MUS_TheDarkPortalIntro#22690",})
			Zn(L["Eastern"], L["Burning Steppes"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Burning Steppes"], "MUS_BurningSteppes#22298", "MUS_BurningSteppesBlackrock#22674", "MUS_BlackwingDescent#23171", "MUS_DreadmaulRock#22675", "MUS_FireplumeRidge#22737", "MUS_MorgansVigil#22677", "Zone-Cursed Land Felwood#5455", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-Orgrimmar#2901", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066",}) -- "Zone-Mystery#6065", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082"
			Zn(L["Eastern"], L["Cape of Stranglethorn"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Cape of Stranglethorn"], "MUS_CapeStranglethornA#22656", "MUS_StranglethornGoblin#23781", "MUS_StranglethornTrollB#22653", "MUS_StranglethornTrollA#22654", "Zone-Jungle Day#2525", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082",}) -- "Zone-Mystery#6065"
			Zn(L["Eastern"], L["Dun Morogh"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Dun Morogh"], "MUS_DunMorogh_GD#22303", "MUS_DunMoroghTroll#22745", "MUS_ColdMountain_GU#22154", "MUS_DarkIronforge_GU#22160", "MUS_Gnomeregan#22756", "MUS_NewTinkertown#22753", "Zone-Evil Forest Night#2534", "Zone-Mountain Night#2537", "Zone-TavernAlliance#4516", "Zone-TavernDwarf01#11806",}) -- "Zone-Mystery#6065"
			Zn(L["Eastern"], L["Duskwood"]						, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Duskwood"], "MUS_DuskwoodHaunted#22757", "MUS_DuskwoodHuman#22759", "MUS_DuskwoodWorgen#22758", "MUS_DuskwoodUndead#22760", "MUS_DustwallowOgre#22765", "MUS_HushedBank#22762", "MUS_TwilightGrove#22764", "Zone-EnchantedForest Night#2540", "Zone-EvilForest Day#2524", "Zone-Cursed Land Felwood#5455", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066",})
			Zn(L["Eastern"], L["Eastern Plaguelands"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Eastern Plaguelands"], "MUS_EasternPlaguelands#22307", "MUS_EPlaguelandsArgent#22767", "MUS_EPlaguelandsCursed#22772", "MUS_EPlaguelandsHaunted#22766", "MUS_EPlaguelandsNerubian#22768", "MUS_LightsHopeChapel#22769", "MUS_QuelLithienLodge#22770", "MUS_Stratholme#22773", "Zone-EbonHArcherusWalk#14960", "Zone-EbonHDeathsBreachWalk#14961", "Zone-Haunted#2990", "Zone-OutlandCorruptRetail#10901", "Zone-Undercity#5074",}) -- "Zone-Mystery#6065", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836", "Moment - Corrupt#9871"
			Zn(L["Eastern"], L["Elwynn Forest"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Elwynn Forest"], "Zone-Forest Day#2523", "Zone-Stormwind#2532", "Zone-TavernAlliance#4516",}) -- "Zone - Plaguelands#6066", "MUS_HillsbradFoothills_GD#22315", "MUS_HillsbradFoothills_GN#22316"
			Zn(L["Eastern"], L["Eversong Woods"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Eversong Woods"], "Zone-EversongDay#9789", "Zone-EversongNight#9790", "Zone-EversongRuinsDay#9797", "Zone-EversongRuinsNight#9798", "Zone-EversongBuildingsDay#9795", "Zone-EversongBuildingsNight#9796", "Zone-GhostlandsScenicWalk#9901", "Zone-SilvermoonDay#9793", "Zone-SilvermoonNight#9794",})
			Zn(L["Eastern"], L["Ghostlands"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Ghostlands"], "Zone-GhostlandsDay#9803", "Zone-GhostlandsNight#9804", "Zone-GhostlandsEversongDarkWalk#10869", "Zone-GhostlandsShalandisWalk#10867", "Zone-DeatholmeDay#9805", "Zone-DeatholmeNight#9806", "Zone-Desert Cave#5394", "Zone-EversongBuildingsDay#9795", "Zone-EversongBuildingsNight#9796", "Zone-Haunted#2990", "Zone-ZulamanWalkingUni#12133", "Zone - Plaguelands#6066",}) -- "Moment - Corrupt#9871"
			Zn(L["Eastern"], L["Hillsbrad Foothills"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Hillsbrad Foothills"], "MUS_HillsbradFoothills_GD#22315", "MUS_HillsbradCursed#22789", "MUS_DurnholdeKeep#22788", "MUS_SludgeFields#22791", "MUS_TarrenMill#22790",})
			Zn(L["Eastern"], L["Hinterlands"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Hinterlands"], "MUS_TheHinterlands_GD#22335", "MUS_HinterlandsMystical#22588", "MUS_HinterlandsNightElf#22565", "MUS_HinterlandsTrollA#22562", "MUS_HinterlandsTrollB#22564", "MUS_HinterlandsUndead#22563",})
			Zn(L["Eastern"], L["Isle of Quel'Danas"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Isle of Quel'Danas"], "Zone-GhostlandsDay#9803", "Zone-GhostlandsNight#9804", "Zone-QuelDanasDay#12528", "Zone-QuelDanasNight#12529",})
			Zn(L["Eastern"], L["Loch Modan"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Loch Modan"], "MUS_LochModan_GD#22319", "MUS_LochModanAlt_GD#22793", "MUS_LochModanOgre#22797", "MUS_LochModanTwilight#22799", "MUS_FarstriderLodgeIntro#22798", "MUS_IronbandsExcavationSite#22795", "MUS_IronwingCavernIntro#22796",})
			Zn(L["Eastern"], L["Northern Stranglethorn"]		, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Northern Stranglethorn"], "MUS_NorthStranglethornA#22655", "MUS_StranglethornOgre#23780", "MUS_StranglethornTrollA#22654", "MUS_StranglethornVale_GU#22208", "MUS_ZandalariTroll#24681", "Zone-Jungle Day#2525", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone - Plaguelands#6066", "Moment - Zul Gurub#8452",}) -- "Zone-Mystery#6065"
			Zn(L["Eastern"], L["Redridge Mountains"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Redridge Mountains"], "MUS_RedridgeMountains_GD#22701", "MUS_RedridgeBlackrock#22703", "MUS_Redridge_GD#22321",})
			Zn(L["Eastern"], L["Ruins of Gilneas"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Ruins of Gilneas"], "MUS_GilneasForsaken#23086", "MUS_GilneasTown#23085", "MUS_Scarred_UU#22198", "MUS_Shadows_UU#22200",})
			Zn(L["Eastern"], L["Searing Gorge"]					, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Searing Gorge"], "MUS_SearingGorgeA#22668", "MUS_SearingGorgeTwilight#22669", "MUS_TheCauldron#22671", "MUS_TheSlagPit#22673", "Zone-Volcanic Day#2529",}) -- "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Mystery#6065"
			Zn(L["Eastern"], L["Silverpine Forest"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Silverpine Forest"], "MUS_SilverpineForsaken#22665", "MUS_SilverpineHaunted#22667", "MUS_SilverpineHuman#22664", "MUS_SilverpineWorgen#22666", "MUS_ShadowfangKeep#23610", "Zone-Cursed Land Felwood#5455", "Zone-DarkForest#5376", "Zone-EvilForest Day#2524", "Zone-Haunted#2990", "Zone-TavernUndead#12137",}) -- "Moment - Battle04#6079"
			Zn(L["Eastern"], L["Swamp of Sorrows"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Swamp of Sorrows"], "MUS_SwampOfSorrowsDraenei#22541", "MUS_SwampOfSorrowsGoblin#22539", "MUS_SwampOfSorrowsTroll#22542", "Zone-Evil Forest Night#2534", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone - Plaguelands#6066",}) -- "Zone-Mystery#6065", "Moment - Battle05#6253", "Moment - Battle02#6262", "Moment - Battle06#6350"
			Zn(L["Eastern"], L["Tirisfal Glades"]				, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Tirisfal Glades"], "MUS_TirisfalHaunted#22651", "MUS_UndercityAlt#22650", "MUS_70_Artif_TombofTyr_Walk#77240", "MUS_50_SM_Dungeon_ScarletEntranceWalk#33719", "MUS_50_SM_Dungeon_VestibuleWalk#33721", "Zone-EvilForest Day#2524", "Zone-Haunted#2990", "Zone-Undercity#5074", "Zone - Plaguelands#6066", "Zone-TavernHorde01#5355", "Zone-TavernUndead#12137", "Moment-Haunted02#5174", "MUS_61_GarrisonMusicBox_15#49540",})
			Zn(L["Eastern"], L["Tol Barad"]						, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Tol Barad"], "MUS_TolBarad_BG#23627",})
			Zn(L["Eastern"], L["Twilight Highlands"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Twilight Highlands"], "MUS_TwilightHighlands_GD (1)#23144", "MUS_TwilightHighlands_GN (1)#23145", "MUS_TwilightHighlandsCrystal#23159", "MUS_TwilightHighlandsHuman#23158", "MUS_TwilightHighlandsTwilightDay#23146", "MUS_TwilightOgre#23150", "MUS_BastionOfTwilight#23167", "MUS_Crushblow#23153", "MUS_DarkshoreCoast#23002", "MUS_GrimBatol#22637", "MUS_GrimBatolDungeonAlt#23169", "MUS_Krazzworks#23160", "MUS_TwilightHive#23796", "Zone-Forest Day#2523", "Zone-Volcanic Day#2529",})
			Zn(L["Eastern"], L["Vashj'ir"]						, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Vashj'ir"], "MUS_AbyssalDepths_GN#22347", "MUS_KelpForest_GN#22349", "MUS_ShimmeringExpanse_GN#22351", "Zone-TavernPirate#11805",})
			Zn(L["Eastern"], L["Western Plaguelands"]			, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Western Plaguelands"], "MUS_WPlaguelands_GD#22352", "MUS_WPlaguelands_GN#22353", "MUS_WestPlaguelands_Cursed#22560", "MUS_WestPlaguelands_Haunted#22561", "Zone-Cursed Land Felwood#5455", "Zone-Haunted#2990", "Zone-Volcanic Day#2529", "Moment - Gloomy01#6074",}) -- "Zone-Soggy Night#6836", "Zone-Soggy Day#7082"
			Zn(L["Eastern"], L["Westfall"]						, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Westfall"], "MUS_WestfallA#22645", "MUS_WestfallB#22646", "MUS_Deadmines#23609", "Zone-BarrenDry Night#2536", "Zone-EvilForest Day#2524", "Zone-Forest Day#2523", "Zone-Plains Day#2528",}) -- "Zone-Mystery#6065", "Zone-Orgrimmar#2901"
			Zn(L["Eastern"], L["Wetlands"]						, {	"|cffffd800" .. L["Eastern"] .. ": " .. L["Wetlands"], "MUS_Wetlands_GD#22356", "MUS_Wetlands_GN#22357", "MUS_WetlandsHuman#22639", "MUS_WetlandsOrcs#22632", "MUS_WetlandsNightElf#22635", "Zone-Forest Day#2523", "Zone-Haunted#2990", "Zone-Jungle Day#2525", "Zone-Night Forest#2533", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone - Plaguelands#6066", "Zone-TavernAlliance#4516", "Zone-TavernPirate#11805",}) -- "Zone-Mystery#6065"

			-- Kalimdor
			Zn(L["Kalimdor"], "|cffffd800" .. L["Kalimdor"], {""})
			Zn(L["Kalimdor"], L["Ashenvale"]					, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Ashenvale"], "MUS_AshenvaleBarrowDen#22939", "MUS_AshenvaleDemon#22936", "MUS_AshenvaleForsaken#22929", "MUS_AshenvaleFurbolg#22930", "MUS_AshenvaleNaga#22951", "MUS_AshenvaleSatyr#22946", "MUS_AshenvaleTwilight#22942", "MUS_BoughShadow#22932", "MUS_MaestrasPost#22943", "MUS_Thunderpeak#22960", "Zone-Crossroads#7097", "Zone-Cursed Land Felwood#5455", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-Darnassus#3920", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Jungle Day#2525", "Zone - Plaguelands#6066", "Zone-OutlandsHordeBase9785", "Zone-TavernHorde#5234", "Zone-TavernOrc#12328",}) -- "Zone-Mystery#6065", "Moment - Battle06#6350"
			Zn(L["Kalimdor"], L["Azshara"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Azshara"], "MUS_Azshara_GN (1)#22965", "MUS_AzsharaCoast#22967", "MUS_AzsharaGoblin#22970", "MUS_AzsharaHaunted#22975", "MUS_AzsharaNaga#22981", "MUS_AzsharaTwilight#22983", "MUS_GallywixsVillaIntro#22546", "MUS_SecretLab#22987", "MUS_70_Zone_Highmountain_Azshara_HulnFlashback_Walk#22964", "Zone-Crossroads#7097", "Zone-Darnassus#3920", "Zone-Desert Day#4754", "Zone-Desert Cave#5394", "Zone-Haunted#2990", "Zone-Jungle Day#2525", "Zone-Mountain Night#2537", "Zone - Plaguelands#6066",}) -- "Zone-Mystery#6065", "Moment - Battle05#6253"
			Zn(L["Kalimdor"], L["Azuremyst Isle"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Azuremyst Isle"], "Zone-AzureMystWalking#9975", "Zone-AzuremystNagaWalking#9458", "Zone-AzuremystOwlWalking#10605", "Zone-OutlandsAllianceBase#9786",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Bloodmyst Isle"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Bloodmyst Isle"], "MUS_70_Zone_Highmountain_DrogbarEarth_Walk#76613", "Zone-AzuremystNagaWalking#9458", "Zone-BloodmystSatyrWalkingUni#9460",})
			Zn(L["Kalimdor"], L["Darkshore"]					, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Darkshore"], "MUS_Darkshore_GD (1)#22992", "MUS_Darkshore_GN (1)#22993", "MUS_DarkshoreCoast#23002", "MUS_DarkshoreForsaken#23009", "MUS_DarkshoreTroll#22996", "MUS_DarkshoreTwilight#23000", "MUS_BlazingStrand#22994", "MUS_EyeOfTheVortex#23007", "MUS_GroveOfTheAncients#22999", "MUS_Nazjvel#23004", "MUS_ShatterSpearPass#22995", "MUS_TheVortex#23008", "Zone - Plaguelands#6066", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Desolace"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Desolace"], "MUS_Desolace_GD#22241", "MUS_Desolace_GD (1)#23013", "MUS_DesolaceBurningBlade#23023", "MUS_DesolaceCoast#23027", "MUS_DesolaceNightElf#23021", "MUS_GelkisVillageIntro#23016", "MUS_GhostwalkerPost#23017", "MUS_KarnumsGlade#23018", "MUS_MannorocCovenIntro#23020", "MUS_RanazjarIsle#23022", "MUS_ShadowpreyVillage#23024", "MUS_SlitherbladeShoreIntro#23026", "MUS_ThunksAbodeIntro#23029", "MUS_ValleyOfBonesIntro#23030",})
			Zn(L["Kalimdor"], L["Durotar"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Durotar"], "MUS_Durotar_GD (1)#23032", "MUS_Durotar_GN (1)#23033", "MUS_DurotarCoast#23036", "MUS_DurotarTroll#23034", "MUS_BurningBladeCoven#23039", "MUS_SpitescaleCavern#23044", "Zone-Desert Cave#5394", "Zone-Jungle Day#2525", "Zone-Orgrimmar_Day#36308", "Zone-Orgrimmar_Night#36309", "Zone-Orgrimmar#2901", "Zone-Plains Day#2528", "Zone-TavernOrc#12328",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Dustwallow Marsh"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Dustwallow Marsh"], "MUS_Dustwallow_GD#22247", "MUS_Dustwallow_GN#22248", "MUS_DustwallowGoblin#22595", "MUS_DustwallowGrimtotem#22589", "MUS_DustwallowHaunted#22591", "MUS_DustwallowHuman#22590", "MUS_DustwallowJungle#22592", "MUS_DustwallowTauren#22594", "MUS_StonemaulRuins#22596", "MUS_50_Scenario_AllianceTheramore#34012", "MUS_50_Scenario_HordeTheramore#34013", "Zone-Evil Forest Night#2534", "Zone-Jungle Day#2525", "Zone-Stormwind#2532", "Zone-Volcanic Day#2529", "Zone - Orgrimmar02#6146", "Moment-Orc Barren#7474", "Moment-StormwindSouthSeas#6837",})
			Zn(L["Kalimdor"], L["Felwood"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Felwood"], "MUS_Felwood#22250", "MUS_FelwoodNightElf#22629", "MUS_FelwoodDruid#22631", "MUS_FelwoodHorde#22630", "Zone-Cursed Land Felwood#5455", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-EvilForest Day#2524", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836",})
			Zn(L["Kalimdor"], L["Feralas"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Feralas"], "MUS_Feralas_GD#22252", "MUS_Feralas_GN#22253", "MUS_FeralasBugs#22627", "MUS_FeralasGrimtotem#22604", "MUS_FeralasHaunted#22600", "MUS_FeralasHorde#22626", "MUS_FeralasNightElf#22603", "MUS_FeralasTauren#22599", "MUS_DreamBough#22601", "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Desert Day#4754", "Zone-Desert Cave#5394", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-TavernTauren#12329", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066", "Moment - Gloomy01#6074",}) -- "Zone-Mystery#6065", "Moment-Spooky01#5037"
			Zn(L["Kalimdor"], L["Moonglade"]					, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Moonglade"], "MUS_Moonglade#22860", "MUS_StormrageBarrowDens#22864", "Zone-CursedLandFelwoodFurbolg#5456", "Zone-EvilForest Day#2524", "Zone-TavernTempleofTheMoon#12136",})
			Zn(L["Kalimdor"], L["Mount Hyjal"]					, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Mount Hyjal"], "MUS_MountHyjal_GD#22906", "MUS_MountHyjal_GN#22907", "MUS_HyjalDruid#22914", "MUS_HyjalFire#22912", "MUS_HyjalLight#22923", "MUS_HyjalLycan#22920", "MUS_HyjalOgre#22913", "MUS_HyjalTwilightDay#22911", "MUS_HyjalTwilightFire#22908", "MUS_LakeEdunel#22915", "MUS_LeyarasSorrow#22918", "MUS_Nordrassil#22922",})
			Zn(L["Kalimdor"], L["Mulgore"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Mulgore"], "MUS_Mulgore_GD#22260", "MUS_Mulgore_GN#22262", "MUS_MulgoreGrimtotem#22812", "MUS_MulgoreTauren#22810", "MUS_Bael'dunDigsite#22809", "MUS_VentureCoMine#22808", "Zone-Desert Cave#5394", "Zone-Plains Day#2528", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066",})
			Zn(L["Kalimdor"], L["Northern Barrens"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Northern Barrens"], "MUS_NorthBarrens_GD#22815", "MUS_NorthBarrens_GN#22816", "MUS_NorthBarrensGreen#22818", "MUS_NorthBarrensOrcs#22824", "MUS_NorthBarrensTauren#22825", "MUS_BoulderLodeMine#22819", "MUS_DreadmistPeak#22820", "MUS_SouthBarrensHuman#22839", "MUS_TheSludgeFen#22828", "MUS_TheWailingCaverns#22829", "Zone-BarrenDry Night#2536", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Thunderbluff#7077", "Zone-Undead Dance#7083", "Zone-Undercity#5074", "Zone-Volcanic Day#2529", "Zone - Plaguelands#6066", "Zone-TavernAlliance#4516", "Zone-TavernPirate#11805",}) -- "Moment - Battle06#6350"
			Zn(L["Kalimdor"], L["Silithus"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Silithus"], "MUS_Silithus_GD#22268", "MUS_Silithus_GN#22269", "MUS_SilithusDark#22559", "MUS_SilithusTwilight#22558", "AhnQirajInteriorCenterRoom#8579", "AhnQirajKingRoom#8578", "AhnQirajTriangleRoomWalking#8577", "Zone - AhnQirajExterior#8531", "Zone Music - AhnQirajInteriorWa#8563", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-TavernNightElf02#80449",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Southern Barrens"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Southern Barrens"], "MUS_SouthBarrens_GD#22270", "MUS_SouthBarrens_GN#22271", "MUS_SouthBarrenDwarf#22833", "MUS_SouthBarrensGreen#22846", "MUS_SouthBarrensHuman#22839", "MUS_SouthBarrensTaurens#22832", "MUS_Battlescar#22835", "MUS_DesolationHold#22837", "MUS_FrazzlecrazMotherlode#22841",}) -- "Moment - Battle04#6079"
			Zn(L["Kalimdor"], L["Stonetalon Mountains"]			, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Stonetalon Mountains"], "MUS_StonetalonDruid#22856", "MUS_StonetalonGrimtotem#22848", "MUS_StonetalonNightElf#22855", "MUS_StonetalonOrcs#22854", "MUS_StonetalonTauren#22849", "MUS_StoneTalon_GU#22205", "MUS_KromgarFortress#22853", "MUS_TheSludgeworks#22850", "MUS_TheTalonDen#22857", "MUS_WebwinderHollow#22858", "MUS_WindshearHold#22859", "Zone-BarrenDry Night#2536", "Zone-EvilForest Day#2524", "Zone-Jungle Day#2525", "Zone-Night Forest#2533", "Zone - Plaguelands#6066", "Zone-TavernHorde#5234",})
			Zn(L["Kalimdor"], L["Tanaris"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Tanaris"], "MUS_Tanaris_GD#22274", "MUS_Tanaris_GN#22275", "MUS_TanarisBugs#22873", "MUS_TanarisOgre#22868", "MUS_TanarisTrollA#22867", "MUS_TanarisTrollB#22871", "MUS_Gadgetzan#22866", "MUS_Uldum_GD#22284", "MUS_Uldum_GN#22285", "MUS_43_WellOfEternity_AzsharaWalk#26581", "MUS_43_HourOfTwilight_GeneralWalk#26604", "Zone-CavernsofTimeWalk#10764", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Volcanic Day#2529", "MUS_715_TavernGoblin#80448",})
			Zn(L["Kalimdor"], L["Teldrassil"]					, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Teldrassil"], "MUS_BanethilBarrowDen#22885", "Zone-Darnassus#3920", "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Evil Forest Night#2534", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Thousand Needles"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Thousand Needles"], "MUS_ThousandNeedles_GD#22280", "MUS_ThousandNeedlesGoblin#22729", "MUS_ThousandNeedlesGrimtotem#22730", "MUS_ThousandNeedlesTwilight#22733", "Zone-Desert Day#4754", "Zone-Desert Cave#5394", "Zone-Plains Day#2528", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-Undead Dance#7083", "Zone-Undercity#5074", "Zone-TavernPirate#11805",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Uldum"]						, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Uldum"], "MUS_Uldum_GD#22284", "MUS_Uldum_GN#22285", "MUS_LostCityOfTheTolvir#23173", "MUS_Skywall#23175", "Zone-UldumAlt#23068",})
			Zn(L["Kalimdor"], L["Un'Goro Crater"]				, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Un'Goro Crater"], "MUS_FireplumeRidge#22737", "MUS_GolakkaHotSprings#22738", "MUS_UngoroBugs#22740", "Zone-Desert Day#4754", "Zone-Desert Night#4755", "Zone-Jungle Day#2525", "Zone-Soggy Night#6836", "Zone-UlduarStoneBattleWalk#14939",}) -- "Zone-Mystery#6065"
			Zn(L["Kalimdor"], L["Winterspring"]					, {	"|cffffd800" .. L["Kalimdor"] .. ": " .. L["Winterspring"], "MUS_Winterspring_GD#22288", "MUS_Winterspring_GN#22289", "MUS_WinterspringGoblin#22569", "MUS_WinterspringHaunted#22567", "MUS_WinterspringNightElf#22568", "MUS_HyjalTwilightDay#22911", "Zone-EvilForest Day#2524", "Zone - Plaguelands#6066", "Moment - Gloomy01#6074", "MUS_715_TavernGoblin#80448",}) -- "Zone-Mystery#6065", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082"

			-- Outland
			Zn(L["Outland"], "|cffffd800" .. L["Outland"], {""})
			Zn(L["Outland"], L["Blade's Edge Mountains"]		, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Blade's Edge Mountains"], "Zone-BladesEdge#9002", "Zone-BladesedgeDryForest#10609", "Zone-BladesEdgeGruulsLairWalk#10730", "Zone-OutlandsHordeBase#9785", "Zone-Shaman#10163", "Zone-ZangarmarshCoilfangWalk#10726",})
			Zn(L["Outland"], L["Hellfire Peninsula"]			, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Hellfire Peninsula"], "Zone-HellfirePeninsula#9773", "Zone-ThrallmarWalk#10864", "Zone-OutlandBloodElfBase#10606", "Zone-OutlandDraeneiBase#10607", "Zone-OutlandsAllianceBase#9786",}) -- "Zone - Plaguelands#6066"
			Zn(L["Outland"], L["Nagrand"]						, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Nagrand"], "Zone-NagrandDay#9012", "Zone-NagrandNight#9013", "Zone-OutlandsHordeBase#9785", "Zone-OutlandDraeneiBase#10607",}) -- "Zone-Volcanic Day#2529"
			Zn(L["Outland"], L["Netherstorm"]					, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Netherstorm"], "Zone-Netherstorm#9284", "Zone-NetherplantWalking#10847", "Zone-NetherstormEco-Domes#10849", "Zone-OutlandBloodElfHostile#10856", "Zone-OutlandDraeneiBase#10607",})
			Zn(L["Outland"], L["Shadowmoon Valley"]				, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Shadowmoon Valley"], "Zone-ZangarmarshCoilfangWalk#10726", "Zone-OutlandCorruptWalk#10848", "Zone-OutlandsHordeBase#9785", "Zone-OutlandsAllianceBase#9786", "Zone-OutlandDraeneiBase#10607", "Zone-BlackTempleWalk#11696", "Zone-BlackTempleKaraborWalk#11697", "Zone-BlackTempleSanctuaryWalk#11699", "Zone-BlackTempleAnguishWalk#11700", "Zone-BlackTempleVigilWalk#11701", "Zone-BlackTempleReliquaryWalk#11702", "Zone-BlackTempleDenWalk#11703",})
			Zn(L["Outland"], L["Terokkar Forest"]				, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Terokkar Forest"], "Zone-Terokkar#9150", "Zone-TerokkarAchinounWalk#10729", "Zone-BoneWastesUni#9991", "Zone-OutlandBloodElfHostile#10856", "Zone-OutlandDraeneiBase#10607", "Zone-OutlandsHordeBase#9785", "Zone-OutlandsAllianceBase#9786",})
			Zn(L["Outland"], L["Zangarmarsh"]					, {	"|cffffd800" .. L["Outland"] .. ": " .. L["Zangarmarsh"], "Zone-ZangarMarsh#9149", "Zone-ZangarmarshCoilfangWalk#10726", "Zone-ExodarWalking#9972", "Zone-OutlandsHordeBase#9785", "Zone-OutlandDraeneiBase#10607", "Zone-TavernNightElf02#80449",}) -- "Moment - Gloomy01#6074"

			-- Northrend
			Zn(L["Northrend"], "|cffffd800" .. L["Northrend"], {""})
			Zn(L["Northrend"], L["Borean Tundra"]				, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Borean Tundra"], "Zone-BoreanTundraDay#12746", "Zone-BoreanTundraNight#12747", "Zone-BoreanTundraTuskarrDay#12562", "Zone-BoreanTundraTuskarrNight#12561", "Zone-BoreanTundraGeyserFields#15101", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-ColdarraGeneralWalk#14958", "Zone-ColdarraNexusEXT#14959", "Zone-NorthrenScourge#15049", "Zone-NorthrenOrcGeneralDay#15041", "Zone-NorthrenOrcGeneralNight#15042", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045", "Zone-NorthrenDarker#15050", "Zone-NexusC#15059", "Zone-NexusD#15060", "Zone - NaxxramsDeathKnight#8687", "Zone-TavernAlliance#4516",})
			Zn(L["Northrend"], L["Crystalsong Forest"]			, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Crystalsong Forest"], "Zone-CrystalSongForest#14905", "Zone-DalaranCity#14906", "Zone-DalaranCityCitadelInterior#14995", "Zone-DalaranSewersWalkUni#14908", "Zone-TavernAlliance#4516", "Zone-TavernHorde#5234", "MUS_60_Proudmoore_03#49358",})
			Zn(L["Northrend"], L["Dragonblight"]				, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Dragonblight"], "Zone-DragonblightDay#12744", "Zone-DragonblightNight#12745", "Zone-DragonblightTuskarrDay#12563", "Zone-DragonblightTuskarrNight#12564", "Zone-DragonBlightWyrmrestDay#15121", "Zone-DragonBlightWyrmrestNight#15122", "Zone-NaxxramasAbominationBoss#8888", "Zone-NaxxramasAbomination#8883", "Zone-NaxxramasSpider#8884", "Zone-NaxxramasPlagueBoss#8886", "Zone-NaxxramasPlague#8885", "Zone-NaxxramasSpiderBoss#8887", "Zone-NaxxramasKelthuzad#8889", "Zone-NaxxramasFrostWyrm#8890", "Zone - NaxxramsDeathKnight#8687", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-SholazarWalkDay#14893", "Zone-SholazarWalkNight#14894", "Zone-NorthrenOrcGeneralDay#15041", "Zone-NorthrenOrcGeneralNight#15042", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045", "Zone-NorthrenTroll#15048", "Zone-NorthrenScourge#15049", "Zone-NorthrenDarker#15050", "Zone-AzjolNerubA#15096",}) -- "Zone-Haunted#2990", "Moment - Gloomy02#6075", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Zone-EbonHDeathsBreachWalk#14961", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Northrend"], L["Grizzly Hills"]				, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Grizzly Hills"], "Zone-GrizzlyHillsDay#12816", "Zone-GrizzlyHillsNight#12817", "Zone-GrizzlyHillsDayB#15036", "Zone-GrizzlyHillsNightB#15037", "Zone-GrizzlyHillsDayC#15038", "Zone-GrizzlyHillsNightC#15039", "Zone-GrizzlyHillsNightC-withTotems#77323", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-IronDwarfDay#12824", "Zone-IronDwarfNight#12825", "Zone-VrykulWalk#14997", "Zone-NorthrenOrcGeneralDay#15041", "Zone-NorthrenOrcGeneralNight#15042", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045", "Zone-NorthrenTroll#15048",}) -- "Zone-Mystery#6065", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Northrend"], L["Howling Fjord"]				, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Howling Fjord"], "Zone-HowlingFjordDay#12800", "Zone-HowlingFjordNight#12801", "Zone-HowlingFjordTuskarrDay#12565", "Zone-HowlingFjordTuskarrNight#12566", "Zone-TaunkaDay#12802", "Zone-TaunkaNight#12803", "Zone-IronDwarfDay#12824", "Zone-IronDwarfNight#12825", "Zone-VrykulWalk#14997", "Zone-TavernUndead#12137", "Zone-TavernAlliance#4516",}) -- "Zone-Cursed Land Felwood#5455", "Zone-Mystery#6065", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Northrend"], L["Icecrown"]					, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Icecrown"], "Zone-IcecrownGeneralWalkDay#13801", "Zone-IcecrownGeneralWalkNight#13802", "Zone-ColdarraGeneralWalk#14958", "Zone-UtgardeA#15062", "Zone-VrykulWalk#14997", "Zone-NorthrenScourge#15049", "Zone-NorthrenDarker#15050", "Zone-IcecrownDungeonWalk#17278", "AT_TournamentNightWalk#15850", "AT_TournamentDayWalk#15851",}) -- "Zone - Plaguelands#6066", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Northrend"], L["Sholazar Basin"]				, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Sholazar Basin"], "Zone-SholazarWalkDay#14893", "Zone-SholazarWalkNight#14894", "Zone-MakersTerrace#14896", "Zone-FireWalk#14897", "Zone-Pillartops#14898", "Zone-PathofLife#14902", "Zone-UlduarStoneGeneralWalk#14937",})
			Zn(L["Northrend"], L["Storm Peaks"]					, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Storm Peaks"], "Zone-StormpeaksDay#13799", "Zone-StormpeaksNight#13800", "Zone-IronDwarfDay#12824", "Zone-IronDwarfNight#12825", "Zone-UlduarStoneBattleWalk#14939", "Zone-VrykulWalk#14997", "Zone-NorthrenDarker#15050", "UR_FormationGroundsWalk#15862",}) -- "Zone-Mystery#6065", "Zone-Soggy Night#6836", "Zone-Soggy Day#7082", "Moment-Monestery#7519", "Zone-EbonHNewAvalonWalk#14964"
			Zn(L["Northrend"], L["Wintergrasp"]					, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Wintergrasp"], "Zone-WintergraspContested#14912", "Zone-UldarLightningGeneralWalk#14942",})
			Zn(L["Northrend"], L["Zul'Drak"]					, {	"|cffffd800" .. L["Northrend"] .. ": " .. L["Zul'Drak"], "Zone-ZulDrakGeneralWalkDay#13804", "Zone-ZulDrakGeneralWalkNight#13805", "Zone-ZuldrakMamtoth#15114", "Zone-ZuldrakQuetzlun#15115", "Zone-ZuldrakRhunok#15116", "Zone-ZuldrakSsertus#15117", "Zone-EbonHDeathsBreachWalk#14961", "Zone-DraktharonRaptorPens#15087", "Zone-NorthrenScourge#15049", "Zone - NaxxramsDeathKnight#8687",})

			-- Maelstrom
			Zn(L["Maelstrom"], "|cffffd800" .. L["Maelstrom"], {""})
			Zn(L["Maelstrom"], L["Deepholm"]					, {	"|cffffd800" .. L["Maelstrom"] .. ": " .. L["Deepholm"], "MUS_Deepholme#23056", "MUS_DeepholmeTwilight#23057", "MUS_DeepholmeCrystal#23058", "MUS_Bloodtrail#23063",})
			Zn(L["Maelstrom"], L["Kezan"]						, {	"|cffffd800" .. L["Maelstrom"] .. ": " .. L["Kezan"], "MUS_Kezan#22254", "MUS_KajaMine#22550", "MUS_KajaroField#22552", "MUS_Drudgetown#22544", "MUS_FirstBankOfKezan#22545", "MUS_GallywixsVilla#22547", "MUS_GallywixsYacht#22549", "MUS_TheSlick#22555", "MUS_ThePipe#22557",})
			Zn(L["Maelstrom"], L["Lost Isles"]					, {	"|cffffd800" .. L["Maelstrom"] .. ": " .. L["Lost Isles & Kazan"], "MUS_LostIsles_GD#23101", "MUS_LostIsles_GN#23102", "MUS_LostIslesMining#23107", "MUS_LostIslesPygmy#23122", "MUS_LostIslesNaga#23137", "MUS_KajamiteCavern#23115", "MUS_KTCOilPlatform#23117", "MUS_WarchiefsLookout#23142", "MUS_HordeBaseCamp#23113",})

			-- Pandaria
			Zn(L["Pandaria"], "|cffffd800" .. L["Pandaria"], {""})
			Zn(L["Pandaria"], L["Dread Wastes"]					, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Dread Wastes"], "MUS_50_DreadWastes_General_Walk#29201", "MUS_50_DW_AmberglowHollow_Walk#33841", "MUS_50_DW_RikkitunVillage_Walk#33822", "MUS_50_DW_TheSunsetBrewgarden_Walk#33829", "MUS_50_DW_TheHorridMarch_TheThunderingRun_Walk#33831", "MUS_50_DW_TerraceofGurthan_Walk#33832", "MUS_50_DW_ForgottenMire_Walk#33834", "MUS_50_DW_TheBrinyMuck_Walk#33843", "MUS_50_DW_LakeOfStars_Walk#33835", "MUS_50_DW_SoggysGamble_Walk#33836", "MUS_50_DW_KypaIk_Walk#33839", "MUS_50_DW_Klaxxivess_Walk#33840", "MUS_50_DW_WhisperingStones_Walk#33844", "MUS_50_MischiefMakers_GeneralWalk#33537", "PVP-Battle Grounds--DeepwindGorge#37659",})
			Zn(L["Pandaria"], L["Isle of Thunder"]				, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Isle of Thunder"], "MUS_52_IOTK_IsleOfThunder_General_Walk#36641", "MUS_52_IOTK_Zandalari1_General_Walk#36642", "MUS_52_IOTK_Zandalari2_General_Walk#36644", "MUS_52_IOTK_Zandalari3_General_Walk#36678", "MUS_52_IOTK_Saurok_Walk#36681", "MUS_52_IOTK_MoguGraveyard_Walk#36769", "MUS_52_IOTK_MoguCaves_Walk#36781", "MUS_52_IOTK_Raid_Wing3_AncientMogu_Walk#36782", "MUS_52_IOTK_LootRoom_Intensity1#36909", "MUS_52_IOTK_LootRoom_Intensity2#36910", "MUS_52_IOTK_LootRoom_Intensity3#36911", "MUS_52_IOTK_LootRoom_Intensity0#36916", "MUS_52_IOTK_ShadoPan_Walk#36967", "MUS_52_IOTK_HordeHub_Walk#36770", "MUS_52_IOTK_AllianceHub_Walk#36771", "MUS_52_TKRaid_ThroneOfThunder_Main#36702",})
			Zn(L["Pandaria"], L["Jade Forest"]					, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Jade Forest"], "MUS_50_JF_JadeForest_GeneralWalk_Day#29196", "MUS_50_JF_JadeForest_GeneralWalk_Night#31837", "MUS_50_JF_SerpentsHeart_Day#31838", "MUS_50_JF_SerpentsHeart_Night#31839", "MUS_50_JF_TempleoftheJadeSerpent_CourtyardWalk#29202", "MUS_50_JF_Windspire_Walk#30621", "MUS_50_JF_JadeForest_VillageWalk#33641", "MUS_50_JF_LairoftheJadeWitch_Walk#34014", "MUS_50_JF_EmperorsOmen_Walk#34022", "MUS_50_SpiritCave_Walk#29218", "MUS_50_Spirits_B#33112", "MUS_50_Hozen_Walk_Day#30437", "MUS_50_Hozen_Walk_Night#33640", "MUS_50_Mogu_Walk#30527", "MUS_50_Jinyu_Day#31124", "MUS_50_Jinyu_Night#33639", "MUS_50_PandarenTavern_A#33540", "MUS_50_TJS_FountainoftheEverseeing_Walk#30456", "MUS_50_TJS_Dungeon_FountainoftheEverseeing_Walk#31987", "MUS_50_TJS_Dungeon_ShaofDoubt_Battle#31990", "MUS_50_TJS_Dungeon_ScrollkeepersSanctum_Battle#31991", "MUS_50_TJS_Dungeon_TempleoftheJadeSerpent_GeneralWalk#31992",}) -- "Zone-IcecrownGeneralWalkDay#13801", "Zone-IcecrownGeneralWalkNight#13802"
			Zn(L["Pandaria"], L["Krasarang Wilds"]				, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Krasarang Wilds"], "MUS_50_KW_TurtleBeach_Day#33376", "MUS_50_KW_TurtleBeach_Night#33379", "MUS_50_KW_KrasarangWilds_Jungle#33894", "MUS_50_KW_KrasarangWilds_Coast#33895", "MUS_50_KW_TempleoftheRedCrane_Walk#33897", "MUS_50_KW_Hozen_Walk#33898", "MUS_51_KW_KrasarangWilds_Goblin_Walk#34884", "MUS_51_KW_KrasarangWilds_MoguCave#34885", "MUS_51_KW_LionsLanding_Day_Walk#34880", "MUS_51_KW_LionsLanding_Night_Walk#34881", "MUS_51_KW_DominationPoint_Walk#34883", "MUS_50_Mogu_Walk#30527", "MUS_50_Jinyu_Day#31124", "MUS_50_Jinyu_Night#33639", "MUS_50_GSS_SerpentSpine_VEB_DW_Walk#34001", "MUS_50_CaveGeneric_A#34021", "MUS_51_Scenario_ALittlePatience#34979",}) -- "MUS_Kezan#22254", "MUS_MulgoreTauren#22810", "MUS_FrazzlecrazMotherlode#22841", "MUS_DesolaceNightElf#23021", "MUS_43_DarkmoonFaire_IslandWalk#26536"
			Zn(L["Pandaria"], L["Kun-Lai Summit"]				, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Kun-Lai Summit"], "MUS_50_KLS_ValleyofEmperors_GeneralWalk#33885", "MUS_50_KLS_Mountains_GeneralWalk_Day#33865", "MUS_50_KLS_Mountains_GeneralWalk_Night#33866", "MUS_50_KLS_MountainHozen_Walk#33869", "MUS_50_KLS_YaungolAdvance_Walk#33867", "MUS_50_KLS_GrummleCamp_Walk#33870", "MUS_50_KLS_TempleoftheWhiteTiger_Walk#33872", "MUS_50_KLS_PeakofSerenity_Walk#33874", "MUS_50_KLS_PeakofSerenity_MistweaverWalk#33875", "MUS_50_KLS_PeakofSerenity_BrewmasterWalk#33876", "MUS_50_KLS_PeakofSerenity_WindwalkerWalk#33877", "MUS_50_KLS_PeakofSerenity_CraneWalk#33878", "MUS_50_KLS_ZouchinVillage_Walk#33880", "MUS_50_KLS_IsleofReckoning_Walk#33881", "MUS_50_KLS_ShadopanDefenseForce#33882", "MUS_50_KLS_TheBurlapTrail_Walk#33883", "MUS_50_KLS_YakWash_Walk#33886", "MUS_50_Jinyu_Day#31124", "MUS_50_Jinyu_Night#33639", "MUS_50_Spirits_B#33112", "MUS_50_MischiefMakers_GeneralWalk#33537", "MUS_50_PandarenTavern_A#33540", "MUS_50_SPM_Dungeon_ShadoPan_GeneralWalk#33651", "MUS_50_SPM_ShadoPan_GeneralWalk#33694",}) -- "Zone-Desert Cave#5394", "Zone - Plaguelands#6066" 
			Zn(L["Pandaria"], L["Timeless Isle"]				, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Timeless Isle"], "MUS_54_TI_TimelessIsle_Intro#39124", "MUS_54_TI_TimelessIsle_GeneralWalk_Day#39129", "MUS_54_TI_TimelessIsle_GeneralWalk_Night#39128", "MUS_54_TI_Timeless_VillageWalk#39126", "MUS_54_TI_Timeless_CelestialCourt#39687", "MUS_54_TI_Timeless_OrdonSantuary#39688", "MUS_54_TI_Timeless_FirewalkersPath#39689",})
			Zn(L["Pandaria"], L["Townlong Steppes"]				, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Townlong Steppes"], "MUS_50_TownlongSteppes_GeneralWalk_Day#30435", "MUS_50_TownlongSteppes_GeneralWalk_Night#31836", "MUS_50_TS_SikvessLair_Walk#33855", "MUS_50_TS_FarwatchOverlook_Walk#33856", "MUS_50_TS_GaoRan_Walk#33859", "MUS_50_TS_Sravess_Walk#33961", "MUS_50_TS_Sumprush_Walk#33858", "MUS_50_TS_HatredsVice_Walk#33861", "MUS_50_TS_FireCampGaiCho_Walk#33934", "MUS_50_TS_GaiChoBattlefield_Walk#33935", "MUS_50_SiegeofNiuzaoTemple_Hero#30624", "MUS_50_Spirits_B#33112",}) -- "Zone-Mystery#6065"
			Zn(L["Pandaria"], L["Vale of Eternal Blossoms"]		, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Vale of Eternal Blossoms"], "MUS_50_VEB_ValeofEternalBlossom_GeneralDay_Walk#29205", "MUS_50_VEB_ValeofEternalBlossom_GeneralNight_Walk#30638", "MUS_50_VEB_TheGoldenPagoda_Walk#33780", "MUS_50_VEB_AncestralRise_Walk#33781", "MUS_50_VEB_MSP_Exterior_Walk#33785", "MUS_50_VEB_Shrine_TheStarsBazaar_A_Walk#33786", "MUS_50_VEB_Shrine_TheEmperorsStep_A_Walk#33787", "MUS_50_VEB_Shrine_TheGoldenLantern_Walk#33789", "MUS_50_VEB_Shrine_ChamberofReflection_A_Walk#33791", "MUS_50_VEB_Shrine_PathofSerentiy_A_Walk#33796", "MUS_50_VEB_Shrine_EtherealCorridor_A_Walk#33797", "MUS_50_VEB_Shrine_ChamberofEnlightenment_A_Walk#33798", "MUS_50_VEB_Shrine_TheCelestialVault_A_Walk#33799", "MUS_50_VEB_Shrine_TheKeggary_Walk#33808", "MUS_50_VEB_RuinsRise_Walk#33810", "MUS_50_VEB_RuinsofGuoLai_Walk#33811", "MUS_50_VEB_TheFiveSisters_Walk#33812", "MUS_50_VEB_SettingSunGarrison_Walk#33813", "MUS_50_VEB_SettingSunGarrison_Brewery_Walk#33814", "MUS_50_VEB_TheSilentSanctuary_Walk#33815", "MUS_50_VEB_TheGoldenRose#33816", "MUS_50_VEB_WhitepetalLake_Walk#33817", "MUS_50_VEB_TheSummerFields_Walk#33991", "MUS_54_VEB_Corrupted_Worst_Day#39683", "MUS_54_VEB_Corrupted_Worst_Night#39684", "MUS_54_VEB_Corrupted_Moderate_Day#39685", "MUS_54_VEB_Corrupted_Moderate_Night#39686", "MUS_50_VEB_Shrine_ChamberofEnlightenment_H_Walk#39697", "MUS_50_VEB_Shrine_TheEmperorsStep_H_Walk#39698", "MUS_50_VEB_Shrine_PathofSerentiy_H_Walk#39699", "MUS_50_VEB_Shrine_EtherealCorridor_H_Walk#39700", "MUS_50_VEB_Shrine_TheCelestialVault_H_Walk#39701", "MUS_50_VEB_Shrine_TheStarsBazaar_H_Walk#39702",})
			Zn(L["Pandaria"], L["Valley of the Four Winds"]		, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Valley of the Four Winds"], "MUS_50_VFW_TheHeartlandWalk_Day#31830", "MUS_50_VFW_TheHeartlandWalk_Night#30533", "MUS_50_VFW_GeneralWalk_Day#33686", "MUS_50_VFW_GeneralWalk_Night#33687", "MUS_50_VFW_PeacefulWalk#33689", "MUS_50_VFW_WindsEdgeWalk#33690", "MUS_50_VFW_BreweryWalk#33691", "MUS_50_VFW_TheHiddenMaster_Walk#33688", "MUS_50_Hozen_Walk_Day#30437", "MUS_50_Spirits_B#33112", "MUS_50_Jinyu_Day#31124", "MUS_50_MischiefMakers_GeneralWalk#33537", "MUS_50_PandarenTavern_A#33540", "MUS_50_GSS_SerpentSpine_VFW_DW_Walk#34002",})
			Zn(L["Pandaria"], L["Wandering Isle"]				, {	"|cffffd800" .. L["Pandaria"] .. ": " .. L["Wandering Isle"], "MUS_50_WanderingIsle_GeneralWalk#25837", "MUS_50_WanderingIsle_GeneralIndoors#25838", "MUS_50_WanderingIsle_PeiWuWalk#25833", "MUS_50_WanderingIsle_HozenWalk#25834", "MUS_50_WanderingIsle_SpiritsWalk#25835", "MUS_50_WanderingIsle_WoodofStavesWalk#25836", "MUS_50_WanderingIsle_TrainingWalk#25851", "MUS_50_WanderingIsle_TempleWalk#25854", "MUS_50_WanderingIsle_Temple_PreFire#33596", "MUS_50_WanderingIsle_Temple_Water/Earth#33597", "MUS_50_WanderingIsle_Temple_Air#33598",})

			-- Draenor
			Zn(L["Draenor"], "|cffffd800" .. L["Draenor"], {""})
			Zn(L["Draenor"], L["Ashran"]						, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Ashran"], "MUS_60_PVP_Ashran_GeneralWalk#48481", "MUS_60_PVP_Ashran_AmphitheaterofAnnihilation_Walk#48500", "MUS_60_PVP_Ashran_AshmaulBurialGrounds#48482", "MUS_60_PVP_Ashran_MoltenQuarry_Walk#48485", "MUS_60_PVP_Ashran_OgreMine_Walk#48486", "MUS_60_PVP_Ashran_RingOfConquest_Walk#48641", "MUS_60_PVP_Ashran_RoadofGlory_Walk#48480", "MUS_60_PVP_Ashran_Stormshield_Battle#48537", "MUS_60_PVP_Ashran_Stormshield_Messhall_Harp#47068", "MUS_60_PVP_Ashran_Stormshield_Walk#48487", "MUS_60_PVP_Ashran_Warspear_Battle#48538", "MUS_60_PVP_Ashran_Warspear_Walk#48488",})
			Zn(L["Draenor"], L["Frostfire Ridge"]				, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Frostfire Ridge"], "MUS_60_FFR_General_Walk#49001", "MUS_60_FFR_General_Night_Walk#49355", "MUS_60_FFR_DarkRock#49005", "MUS_60_FFR_Fel_Walk#49194", "MUS_60_FFR_Frostwolf_Walk#49189", "MUS_60_FFR_IronHorde_Walk#49191", "MUS_60_FFR_Mushroom_Sea_Walk#49193", "MUS_60_FFR_Ogre_Battle#49195", "MUS_60_FFR_Ogre_Walk#49192", "MUS_60_FFR_Thunderlord_Walk#49190",})
			Zn(L["Draenor"], L["Gorgrond"]						, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Gorgrond"], "MUS_60_Gorgrond_Blackrock_Walk#48914", "MUS_60_Gorgrond_CrimsonFen_Walk#48915", "MUS_60_Gorgrond_Jungle_Walk#48912", "MUS_60_Gorgrond_LaughingSkull_Walk#48909", "MUS_60_Gorgrond_Mushroom_Sea_Walk#48911", "MUS_60_Gorgrond_Wasteland_Walk#48913",})
			Zn(L["Draenor"], L["Nagrand (Draenor)"]				, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Nagrand"], "MUS_60_NGD_General_Walk#49065", "MUS_60_NGD_General_Night_Walk#49066", "MUS_60_NGD_BurningBlade_Walk#49076", "MUS_60_NGD_IronHorde_Walk#49072", "MUS_60_NGD_Mushroom_Walk#49070", "MUS_60_NGD_Ogre_Walk#49068", "MUS_60_NGD_OrcAncestors_Walk#49078", "MUS_60_NGD_Oshu'gun_Walk#49069", "MUS_60_NGD_RingofTrials_ArenaFloor_Battle#49077", "MUS_60_NGD_Underpale_Walk#49075", "MUS_60_NGD_Warsong_Walk#49067",})
			Zn(L["Draenor"], L["Shadowmoon Valley (Draenor)"]	, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Shadowmoon Valley"], "MUS_60_SMV_General_Walk#48553", "MUS_60_SMV_General_Night_Walk#48554", "MUS_60_SMV_Cultist_Walk#48555", "MUS_60_SMV_DarkDraenei_Walk#49030", "MUS_60_SMV_Draenei_Karabor_Walk#48562", "MUS_60_SMV_Draenei_Walk#48559", "MUS_60_SMV_Fel_Walk#48556", "MUS_60_SMV_IronHorde_Walk#49031", "MUS_60_SMV_MoonMagic_Walk#48560", "MUS_60_SMV_Mushroom_Walk#48561", "MUS_60_SMV_NerzhulFinale_CultistBattle_Phase#49254", "MUS_60_SMV_Podling_Walk#48558", "MUS_60_SMV_Primals_Walk#48557", "MUS_60_SMV_YrelsCoronation_Phase_Playlist#49250", "MUS_60_SMV_Vignette_VindicatorTorvath#43487",})
			Zn(L["Draenor"], L["Spires of Arak"]				, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Spires of Arak"], "MUS_60_SOA_General_Walk#48883", "MUS_60_SOA_AdmiralTaylorsGarrison_Inn#49032", "MUS_60_SOA_AdmiralTaylorsGarrison_Walk#48896", "MUS_60_SOA_Arakkoa_BombingRun#49174", "MUS_60_SOA_Arakkoa_Exiles_Walk#48894", "MUS_60_SOA_Arakkoa_Exiles_Night_Walk#49034", "MUS_60_SOA_Arakkoa_High_Walk#48885", "MUS_60_SOA_AvatarofTerokk_Phase#49176", "MUS_60_SOA_Axefall_Garrison_Walk#49037", "MUS_60_SOA_Bladefist_Walk#49035", "MUS_60_SOA_Goblin_Walk#48887", "MUS_60_SOA_Mushroom_Walk#48897", "MUS_60_SOA_SethekkHollow_Walk#48895", "MUS_60_SOA_Southport_Garrison_Walk#49036",})
			Zn(L["Draenor"], L["Talador"]						, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Talador"], "MUS_60_TD_General_Walk#49079", "MUS_60_TD_Arakkoa_Walk#49085", "MUS_60_TD_Auchindoun_Walk#49082", "MUS_60_TD_CrystalMine_Walk#49088", "MUS_60_TD_DeathwebHollow_Walk#49087", "MUS_60_TD_Draenei_Walk#49081", "MUS_60_TD_DraeneiHoly_Walk#49083", "MUS_60_TD_DraeneiWartorn_Walk#49089", "MUS_60_TD_Fel_Walk#49084", "MUS_60_TD_Ogre_Walk#49086", "MUS_60_TD_Zangarra_Walk#49354",})
			Zn(L["Draenor"], L["Tanaan Jungle"]					, {	"|cffffd800" .. L["Draenor"] .. ": " .. L["Tanaan Jungle"], "MUS_60_TJ_BlackrockQuarry_Walk#48335", "MUS_60_TJ_Guldan_Walk#48333", "MUS_60_TJ_HeartBlood_Walk#48334", "MUS_60_TJ_KargathProvingGrounds_Walk#48296", "MUS_60_TJ_PathofGlory_Walk#48298", "MUS_60_TJ_UmbralHalls_Walk#48299",})

			-- Broken Isles
			Zn(L["Broken Isles"], "|cffffd800" .. L["Broken Isles"], {""})
			Zn(L["Broken Isles"], L["Antoran Wastes (Argus)"]	, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Antoran Wastes (Argus)"], "MUS_73_AntoranWastes_GeneralWalk#90584", "MUS_73_AntoranWastes_FullLegionWalk#90587", "MUS_73_AntoranWastes_HoldoutWalk#90586", "MUS_70_Invasion_Legion_GeneralWalk#75371", "MUS_70_Mardum_TheDoomFortress#56362", "MUS_73_Vindicaar_Walk_OverAntoranWastes_Gold#90700", "MUS_73_RAID_AntorusGeneralWalk#90609",})
			Zn(L["Broken Isles"], L["Azsuna"]					, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Azsuna"], "MUS_70_Zone_Azsuna_GeneralWalk_Day#73363", "MUS_70_Zone_Azsuna_GeneralWalk_Night#73362", "MUS_70_Zone_Azsuna_Artif_Walk#77082", "MUS_70_Zone_Azsuna_Legion_WalkE#75106", "MUS_70_Zone_Azsuna_Sombre_Walk#77083", "MUS_70_Zone_Azsuna_WalkB#75104", "MUS_70_Zone_Azsuna_WalkC#75105", "MUS_70_Zone_Azsuna_WalkD#75216",})
			Zn(L["Broken Isles"], L["Broken Shore"]				, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Broken Shore"], "MUS_70_BrokenShore_GeneralWalk_A#75355", "MUS_70_BrokenShore_Alliance_Walk#75363", "MUS_70_BrokenShore_Ashbringer_Moment#53990", "MUS_70_BrokenShore_Horde_Walk#75366", "MUS_70_BrokenShore_Legion_Walk_TensionA#75367", "MUS_70_BrokenShore_Legion_Walk_TensionB#75368", "MUS_70_Artif_BrokenShore_BattleWalk#53988", "MUS_70_Artif_BrokenShore_CaveWalk#53989",})
			Zn(L["Broken Isles"], L["Dalaran"]					, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Dalaran"], "MUS_70_Zone_Dalaran_Ext_GeneralWalk_DAY#70715", "MUS_70_Zone_Dalaran_Ext_GeneralWalk_NIGHT#70716", "MUS_70_Zone_Dalaran_Ext_KrasusLanding#75072", "MUS_70_Zone_Dalaran_Mage_OH_Bold#75109", "MUS_70_Zone_Dalaran_Mage_OH_Light#75108", "MUS_70_Zone_Dalaran_Mage_Walk_A#75050", "MUS_70_Zone_Dalaran_Mage_Walk_B#75052", "MUS_70_Zone_Dalaran_Rogue_Walk_A#75292", "MUS_70_Zone_Dalaran_Rogue_Walk_B#75293", "MUS_70_Zone_Dalaran_Sewers_Walk_A#75048", "MUS_70_Zone_Dalaran_Sewers_Walk_B#75049",}) -- "MUS_70_Zone_Dalaran_Brewfest_Beergarden#75107", "MUS_70_Zone_Dalaran_Sewer_DwarfBardEmitter#75094"
			Zn(L["Broken Isles"], L["Eye of Azshara"]			, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Eye of Azshara"], "MUS_70_EyeofAzshara_Walk_A#75040", "MUS_70_EyeofAzshara_Walk_C#74973",})
			Zn(L["Broken Isles"], L["Highmountain"]				, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Highmountain"], "MUS_70_Zone_Highmountain_Mountain_General_Walk#73367", "MUS_70_Zone_Highmountain_Azshara_HulnFlashback_Walk#22964", "MUS_70_Zone_Highmountain_Bloodtotem#73366", "MUS_70_Zone_Highmountain_Coast_Walk#76578", "MUS_70_Zone_Highmountain_DrogbarEarth_Walk#76613", "MUS_70_Zone_Highmountain_HunterLodge_Walk#76579", "MUS_70_Zone_Highmountain_River#76575", "MUS_70_Zone_Highmountain_ThunderTotem_Inn#76616", "MUS_70_Zone_Highmountain_ThunderTotem_Walk#76577",})
			Zn(L["Broken Isles"], L["Krokuun (Argus)"]			, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Krokuun (Argus)"], "mus_73_krokuun_generalwalk#90541", "mus_73_krokuun_battlefieldwalk#90542", "mus_73_krokuun_courtoftheavenger#90545", "mus_73_krokuun_xenedarlandingwalk#90543", "mus_73_vindicaar_walk_overkrokuun_gold#90698",})
			Zn(L["Broken Isles"], L["Mac'Aree (Argus)"]			, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Mac'Aree (Argus)"], "MUS_73_MacAree_GeneralWalk#90485", "MUS_73_MacAree_VoidFullWalk#90509", "MUS_73_MacAree_KiljaedenWalk#90510", "MUS_73_TheSeatoftheTriumvirate_VoidMediumWalk#90573", "MUS_73_Vindicaar_Walk_OverMacAree_Gold#90699",})
			Zn(L["Broken Isles"], L["Mardum"]					, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Mardum"], "MUS_70_Mardum_WalkA#56358", "MUS_70_Mardum_WalkB#56361", "MUS_70_Mardum_WalkC#56360", "MUS_70_Mardum_IllidariFoothold#56363", "MUS_70_Mardum_TheDoomFortress#56362",})
			Zn(L["Broken Isles"], L["Stormheim"]				, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Stormheim"], "MUS_70_Zone_Stormheim_General_Walk#73360", "MUS_70_Zone_Stormheim_DarkCoast_Walk#76490", "MUS_70_Zone_Stormheim_Mountain_Walk#76489", "MUS_70_Zone_Stormheim_Mystic_Walk#76491", "MUS_70_Zone_Stormheim_Valor_Walk#76492", "MUS_70_Zone_Stormheim_Village_Walk#73361",})
			Zn(L["Broken Isles"], L["Suramar"]					, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Suramar"], "MUS_70_Zone_Suramar_Forest_General_Walk#73358", "MUS_70_Zone_Suramar_MoonGuard_Walk#73359", "MUS_70_Zone_Suramar_Sombre_Walk#76667", "MUS_70_Zone_SuramarCity_Corrupted_Walk#76670", "MUS_70_Zone_SuramarCity_Magnificent_Walk#76669", "MUS_70_Zone_SuramarCity_Occupied_Walk#76668", "MUS_70_Zone_Stormheim_General_Walk#73360", "MUS_70_Zone_Stormheim_Village_Walk#73361",})
			Zn(L["Broken Isles"], L["Val'sharah"]				, {	"|cffffd800" .. L["Broken Isles"] .. ": " .. L["Val'sharah"], "MUS_70_Zone_ValSharah_GeneralWalk_Day#73365", "MUS_70_Zone_ValSharah_GeneralWalk_Night#73364", "MUS_70_Zone_ValSharah_Dark_Walk#76207", "MUS_70_Zone_ValSharah_Gilnean_Walk#76210", "MUS_70_Zone_ValSharah_NightElf_BarrowDens_Walk#51337", "MUS_70_Zone_ValSharah_NightElf_Druid_Walk#76204", "MUS_70_Zone_ValSharah_NightElf_Ruins_Walk#76206", "MUS_70_Zone_ValSharah_NightElf_TempleWalk#76205",})

			-- Dungeons: World of Warcraft
			Zn(L["Dungeons"], "|cffffd800" .. L["World of Warcraft"], {""})
			Zn(L["Dungeons"], L["Blackfathom Deeps"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackfathom Deeps"], "Zone-Desert Day#4754", "Zone-Desert Night#4755",})
			Zn(L["Dungeons"], L["Blackwing Lair"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackwing Lair"], "Zone - Plaguelands#6066",})
			Zn(L["Dungeons"], L["Deadmines"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Deadmines"], "MUS_Deadmines#23609", "MUS_ChoGall_E#22151", "Zone-Orgrimmar#2901", "Moment-Spooky01#5037",}) -- "Zone-Mystery#6065"
			Zn(L["Dungeons"], L["Dire Maul"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Dire Maul"], "Zone-EnchantedForest Day#2530", "Zone-EnchantedForest Night#2540", "Zone-Evil Forest Night#2534",})
			Zn(L["Dungeons"], L["Gnomeregan"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Gnomeregan"], "Zone-Gnomeragon#7341",})
			Zn(L["Dungeons"], L["Maraudon"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Maraudon"], "Zone-BarrenDry Night#2536", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836",}) -- "Moment - Battle02#6262"
			Zn(L["Dungeons"], L["Molten Core"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Molten Core"], "Moment - Battle01#6077", "Moment - Battle02#6262", "Moment - Battle03#6078", "Moment - Battle04#6079", "Moment - Battle05#6253", "Moment - Battle06#6350",})
			Zn(L["Dungeons"], L["Razorfen Downs"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Razorfen Downs"], "Zone-Undercity#5074", "Zone-Undead Dance#7083",})
			Zn(L["Dungeons"], L["Ruins of Ahn'Qiraj"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ruins of Ahn'Qiraj"], "Zone - AhnQirajExterior#8531",})
			Zn(L["Dungeons"], L["Scarlet Halls"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Scarlet Halls"], "MUS_50_SM_Dungeon_TrainingWalk#33725", "MUS_50_ScarletMonastery_A_Hero#30478",})
			Zn(L["Dungeons"], L["Scarlet Monastery"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Scarlet Monastery"], "MUS_50_SM_Dungeon_ChapelGardensWalk#33738", "MUS_50_SM_Dungeon_CrusaderWalk#33740", "MUS_50_SM_Dungeon_TunnelsWalk#33723", "MUS_50_SM_Dungeon_VestibuleWalk#33721", "MUS_50_ScarletMonastery_A_Hero#30478", "MUS_Haunted_UU#22182",})
			Zn(L["Dungeons"], L["Shadowfang Keep"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shadowfang Keep"], "MUS_ShadowfangKeep#23610", "MUS_Scarred_UU#22198", "MUS_Shadows_UU#22200", "Zone-EvilForest Day#2524",})
			Zn(L["Dungeons"], L["Stockade"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stockade"], "StomWindJail#4223",})
			Zn(L["Dungeons"], L["Stratholme"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stratholme"], "Zone-Undercity#5074",})
			Zn(L["Dungeons"], L["Sunken Temple"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Sunken Temple"], "MUS_SwampOfSorrowsTroll#22542", "Zone-Soggy Day#7082", "Zone-Soggy Night#6836", "Moment - Battle02#6262", "Moment - Battle05#6253", "Moment - Battle06#6350",})
			Zn(L["Dungeons"], L["Temple of Ahn'Qiraj"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Temple of Ahn'Qiraj"], "AhnQirajInteriorCenterRoom#8579", "AhnQirajKingRoom#8578", "AhnQirajTriangleRoomWalking#8577", "Zone - AhnQirajExterior#8531", "Zone Music - AhnQirajInteriorWa#8563",})
			Zn(L["Dungeons"], L["Wailing Caverns"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Wailing Caverns"], "MUS_TheWailingCaverns#22829", "Zone-Jungle Day#2525", "Zone-Jungle Night#2535", "Zone - Plaguelands#6066",})
			Zn(L["Dungeons"], L["Zul'Farrak"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Zul'Farrak"], "MUS_TanarisTrollA#22867",})

			-- Dungeons: The Burning Crusade
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["The Burning Crusade"], {""})
			Zn(L["Dungeons"], L["Arcatraz"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Arcatraz"], "Zone-TempestKeepWalkingUni#12128", "Zone-TempestKeepBosses#12129",})
			Zn(L["Dungeons"], L["Black Morass"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Black Morass"], "Zone-CavernsofTimeBlackMorassWa#10731",})
			Zn(L["Dungeons"], L["Black Temple"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Black Temple"], "Zone-BlackTempleWalk#11696", "Zone-BlackTempleKaraborWalk#11697", "Zone-BlackTempleSanctuaryWalk#11699", "Zone-BlackTempleAnguishWalk#11700", "Zone-BlackTempleVigilWalk#11701", "Zone-BlackTempleReliquaryWalk#11702", "Zone-BlackTempleDenWalk#11703",})
			Zn(L["Dungeons"], L["Hellfire Ramparts"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hellfire Ramparts"], "Zone-HellfireCitadelRampartsWal#10727",})
			Zn(L["Dungeons"], L["Hyjal Summit"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hyjal Summit"], "Zone-HyjalPastNordrassilWalk#11652", "Zone-HyjalPastSummitWalk#11653",})
			Zn(L["Dungeons"], L["Karazhan"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Karazhan"], "Zone-KarazhanGeneralDefault#12154", "Zone-KarazhanFoyerWalk#12156", "Zone-KarazhanStableWalk#12159", "Zone-KarazhanOperaWalk#12163", "Zone-KarazhanBackstageWalk#12162", "Zone-KarazhanLibraryWalk#12164", "Zone-KarazhanTowerNetherspiteW#12170", "Zone-KarazhanMalchezaarWalk#12168",})
			Zn(L["Dungeons"], L["Old Hillsbrad Foothills"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Old Hillsbrad Foothills"], "MUS_DurnholdeKeep#22788", "MUS_TarrenMill#22790", "Zone-CavernsoftimeHillsbradExtW#10770",})
			Zn(L["Dungeons"], L["Sunwell Plateau"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Sunwell Plateau"], "Zone-SunwellPlateauWalking#12536",})

			-- Dungeons: Wrath of the Lich King
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["Wrath of the Lich King"], {""})
			Zn(L["Dungeons"], L["Ahn'kahet (Old Kingdom)"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ahn'kahet (Old Kingdom)"], "Zone-AzjolNerubC#15098", "Zone-AzjolNerubD#15099", "Zone-AzjolNerubE#15100",})
			Zn(L["Dungeons"], L["Azjol-Nerub"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Azjol-Nerub"], "Zone-AzjolNerubA#15096", "Zone-AzjolNerubE#15100", "Zone-AzjolNerubB#15097", "Zone-AzjolNerubD#15099",})
			Zn(L["Dungeons"], L["Culling of Stratholme"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Culling of Stratholme"], "Zone-StratholmePastOutdoorsDay#14920", "Zone-StratholmePastOutdoorsNigh#14921",})
			Zn(L["Dungeons"], L["Drak'Tharon Keep"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Drak'Tharon Keep"], "Zone-DraktharonRaptorPens#15087",})
			Zn(L["Dungeons"], L["Forge of Souls"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Forge of Souls"], "Zone-ForgeOfSoulsWalk#17277", "MUS_70_Artif_DK_IcecrownWalk#77050",})
			Zn(L["Dungeons"], L["Halls of Reflection"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Halls of Reflection"], "Zone-IcecrownDungeonWalk#17278",})
			Zn(L["Dungeons"], L["Icecrown Citadel"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Icecrown Citadel"], "Zone-IcecrownRaidFloor2Intro#17291", "Zone-IcecrownRaidFloor2Plague#17294", "Zone-IcecrownRaidFloor2Spire#17296", "Zone-IcecrownRaidFloor2Valithria#17300", "Zone-IcecrownRaidFloor2Frost#17298", "Zone-IcecrownDungeonWalk#17278", "Zone-CrimsonHallWalk#17287", "Zone-ForgeOfSoulsWalk#17277", "Zone-FrostmourneWalk#17286", "Zone-PitofSaron#17310", "Zone-SindragosaWalk#17288",})
			Zn(L["Dungeons"], L["Naxxramas"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Naxxramas"], "NaxxramasAbominationWing#8675", "NaxxramasPlagueWing#8678", "NaxxramasSpiderWing#8679", "Zone-NaxxramasAbominationBoss#8888", "Zone-NaxxramasPlagueBoss#8886", "Zone-NaxxramasSpiderBoss#8887", "Zone-NaxxramasKelthuzad#8889", "Zone-NaxxramasFrostWyrm#8890", "Zone - NaxxramsDeathKnight#8687",})
			Zn(L["Dungeons"], L["Nexus"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Nexus"], "ColdarraNightDay#12763",})
			Zn(L["Dungeons"], L["Obsidian Sanctum"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Obsidian Sanctum"], "Zone-ChamberAspects01Day#15077", "Zone-ChamberAspects01Night#15078",})
			Zn(L["Dungeons"], L["Onyxia's Lair"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Onyxia's Lair"], "Moment-Orc Barren#7474",})
			Zn(L["Dungeons"], L["Pit of Saron"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Pit of Saron"], "Zone-PitofSaronEntry#17308", "Zone-PitofSaron#17310", "Zone-PitofSaronTyrannus#17314",})
			Zn(L["Dungeons"], L["Ruby Sanctum"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ruby Sanctum"], "RubySanctumWalk#17672",})
			Zn(L["Dungeons"], L["Ulduar"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Ulduar"], "UR_UlduarRaidGeneralWalk#15838", "UR_BaseCampWalk#15854", "UR_CelestialHallWalk#15842", "UR_ConservatoryWalk#15843", "UR_CorridorsOfIngenuityWalk#15841", "UR_DescentWalk#15839", "UR_KingLlaneWalk#15835", "UR_PrisonOfYoggSaronWalk#15840", "UR_RazorscalesAerieWalk#15868", "UR_SparkOfImaginationWalk#15847", "UR_TheColossalForgeWalk#15865", "UR_TheScrapyardWalk#15871", "UR_TramHallWalk#15901", "UR_WyrmrestTempleWalk#15837",})
			Zn(L["Dungeons"], L["Utgarde Keep"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Utgarde Keep"], "Zone-UtgardeA#15062", "Zone-UtgardeE#15066", "Music_Temp_95#14871",})
			Zn(L["Dungeons"], L["Utgarde Pinnacle"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Utgarde Pinnacle"], "Zone-UtgardeA#15062", "Zone-UtgardeD#15065", "Music_Temp_95#14871", "Music_Temp_98#14874",})
			Zn(L["Dungeons"], L["Vault of Archavon"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Vault of Archavon"], "Zone-UldarLightningGeneralWalk#14942",})

			-- Dungeons: Cataclysm
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["Cataclysm"], {""})
			Zn(L["Dungeons"], L["Bastion of Twilight"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Bastion of Twilight"], "MUS_BastionOfTwilight#23167",})
			Zn(L["Dungeons"], L["Blackrock Caverns"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackrock Caverns"], "MUS_BlackrockCaverns#23170",})
			Zn(L["Dungeons"], L["Blackwing Descent"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackwing Descent"], "MUS_BlackwingDescent#23171",})
			Zn(L["Dungeons"], L["End Time"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["End Time"], "MUS_43_EndTime_GeneralWalk#26573", "MUS_43_EndTime_EmeraldWalk#26574", "MUS_43_EndTime_MurozondIntro#26571", "Zone-NorthrenRiplashDay#15044", "Zone-NorthrenRiplashNight#15045",})
			Zn(L["Dungeons"], L["Halls of Origination"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Halls of Origination"], "MUS_HallsOfOriginationInt#23174",})
			Zn(L["Dungeons"], L["Hour of Twilight"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hour of Twilight"], "MUS_43_HourOfTwilight_GeneralWalk#26604", "MUS_43_HourOfTwilight_WyrmrestWalk#26610",})
			Zn(L["Dungeons"], L["Lost City of the Tol'vir"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Lost City of the Tol'vir"], "MUS_LostCityOfTheTolvir#23173",})
			Zn(L["Dungeons"], L["Stonecore"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stonecore"], "MUS_Stonecore#23166",})
			Zn(L["Dungeons"], L["Throne of the Four Winds"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Throne of the Four Winds"], "MUS_Skywall#23175",})
			Zn(L["Dungeons"], L["Throne of the Tides"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Throne of the Tides"], "MUS_ThroneOfTheTides#23172",})
			Zn(L["Dungeons"], L["Well of Eternity"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Well of Eternity"], "MUS_43_WellOfEternity_AzsharaWalk#26581", "MUS_43_WellOfEternity_IllidanWalk#26582", "MUS_43_WellOfEternity_MannorothWalk#26583",})
			Zn(L["Dungeons"], L["Zul'Aman"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Zul'Aman"], "Zone-ZulamanWalkingUni#12133",})
			Zn(L["Dungeons"], L["Zul'Gurub"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Zul'Gurub"], "MUS_ZA_altarofthebloodgod#24656", "MUS_ZA_mandokirsdomain#24652", "MUS_ZA_templeofbethekk#24654", "MUS_ZA_thecacheofmadness#24653", "MUS_ZA_thedevilsterrace#24655", "MUS_ZandalariTroll#24681", "Zone-Jungle Day#2525", "Zone-Jungle Night#2535",})

			-- Dungeons: Mists of Pandaria
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["Mists of Pandaria"], {""})
			Zn(L["Dungeons"], L["Gate of the Setting Sun"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Gate of the Setting Sun"], "MUS_50_GSS_Dungeon_GeneralWalk#33602",})
			Zn(L["Dungeons"], L["Mogu'shan Palace"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Mogu'shan Palace"], "MUS_50_MSP_Dungeon_BossWalk#33195", "MUS_50_MSP_Dungeon_ShaWalk#33196", "MUS_50_MSP_Dungeon_ShrineWalk#33215",})
			Zn(L["Dungeons"], L["Mogu'shan Vaults"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Mogu'shan Vaults"], "MUS_50_MSV_Raid_MoguShanVaults_GeneralWalk#29209",})
			Zn(L["Dungeons"], L["Shado-Pan Monastery"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shado-Pan Monastery"], "MUS_50_SPM_Dungeon_ShadoPan_GeneralWalk#33651",})
  			Zn(L["Dungeons"], L["Siege of Niuzao Temple"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Siege of Niuzao Temple"], "MUS_50_SoN_Dungeon_HallowedOutTreeWalk#33612", "MUS_50_SoN_Dungeon_NiuzaoExteriorWalk#33614",})
			Zn(L["Dungeons"], L["Stormstout Brewery"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Stormstout Brewery"], "MUS_50_SSB_Dungeon_StormstoutBrewhall_INTRO#33756", "MUS_50_SSB_Dungeon_StormstoutBrewhall_Walk#33757",})
			Zn(L["Dungeons"], L["Temple of the Jade Serpent"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Temple of the Jade Serpent"], "MUS_50_TJS_Dungeon_FountainoftheEverseeing_Walk#31987", "MUS_50_TJS_Dungeon_ShaofDoubt_Battle#31990", "MUS_50_TJS_Dungeon_ScrollkeepersSanctum_Battle#31991", "MUS_50_TJS_Dungeon_TempleoftheJadeSerpent_GeneralWalk#31992",})
			Zn(L["Dungeons"], L["Terrace of Endless Spring"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Terrace of Endless Spring"], "MUS_50_TES_Raid_TerraceofEndlessSpring_GeneralWalk#33625",})
			Zn(L["Dungeons"], L["Throne of Thunder"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Throne of Thunder"], "MUS_52_TKRaid_ThroneOfThunder_Main#36702", "MUS_52_TKRaid_Wing3_FleshShaping_Walk#36920", "MUS_52_TKRaid_Wing1_Troll_Walk#36921", "MUS_52_TKRaid_Wing2_Creatures_Walk#36922", "MUS_52_TKRaid_Wing4_Palace_Walk#36923", "MUS_52_TKRaid_Wing1_Troll_Battle#37010",})

			-- Dungeons: Warlords of Draenor
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["Warlords of Draenor"], {""})
			Zn(L["Dungeons"], L["Blackrock Foundry"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Blackrock Foundry"], "MUS_60_Dungeon_BlackRock_Foundry_General#49225",})
			Zn(L["Dungeons"], L["Bloodmaul Slag Mines"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Bloodmaul Slag Mines"], "MUS_60_FFR_Ogre_Walk#49192", "MUS_60_FFR_Ogre_Battle#49195",})
			Zn(L["Dungeons"], L["Everbloom"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Everbloom"], "MUS_60_Dungeon_Everbloom_Stormwind#49219", "MUS_60_Dungeon_Everbloom_PoolsofLife#49220", "MUS_60_Dungeon_Everbloom_Verdant_Grove#49221", "MUS_60_Dungeon_Everbloom_Xeritacs_Burrow#49222", "MUS_60_Dungeon_Everbloom_VioletBluff#49223",})
			Zn(L["Dungeons"], L["Hellfire Citadel"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Hellfire Citadel"], "MUS_62_Tanaan_HFC_IronHorde_Cathedral_Walk#51515", "MUS_62_Tanaan_HFC_IronHorde_Fel_Walk#51519", "MUS_62_Tanaan_HFC_Boss_Battle#51573", "MUS_62_Tanaan_HFC_Kilrogg_Batlle#51574", "MUS_62_Tanaan_HFC_Fel_Walk#51520", "MUS_62_Tanaan_HFC_Archimonde_Battle#51525", "MUS_62_Tanaan_HFC_Eredar_Walk#51521", "MUS_62_Tanaan_HFC_Iskar_Battle#51522", "MUS_62_Tanaan_HFC_Grommash_Battle#51523", "MUS_62_Tanaan_HFC_Archimonde_TwistingNether_Walk#51526",})
			Zn(L["Dungeons"], L["Highmaul"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Highmaul"], "MUS_60_Dungeon_Highmaul_General#49276", "MUS_60_Dungeon_Highmaul_ImperatorsRise#49351", "MUS_60_Dungeon_Highmaul_PathOfVictors#49345", "MUS_60_Dungeon_Highmaul_TheUnderbelly#49282",})
			Zn(L["Dungeons"], L["Iron Docks"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Iron Docks"], "MUS_60_Dungeon_IronDocks_Walk#49187", "MUS_60_Dungeon_IronDocks_BlackhandsMight#49188",})
			Zn(L["Dungeons"], L["Shadowmoon Burial Grounds"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Shadowmoon Burial Grounds"], "MUS_60_Dungeon_SMBurialGrounds_Walk#49206", "MUS_60_Dungeon_SMBurialGrounds_CryptsoftheAncients#49208", "MUS_60_Dungeon_SMBurialGrounds_PoolsofReflection#49209", "MUS_60_Dungeon_SMBurialGrounds_AltarofShadow#49210",})
			Zn(L["Dungeons"], L["Skyreach"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Skyreach"], "MUS_60_Dungeon_Skyreach_General_A#49129",})

			-- Dungeons: Legion
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["Legion"], {""})
			Zn(L["Dungeons"], L["Antorus, the Burning Throne"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Antorus, the Burning Throne"], "MUS_73_RAID_AntorusGeneralWalk#90609", "MUS_73_RAID_AntorusBattleWalk#90610", "MUS_73_RAID_AntorusElunariaWalk#90611", "MUS_73_RAID_BurningThroneWalk#90612",})
			Zn(L["Dungeons"], L["Arcway"]						, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Arcway"], "MUS_60_FFR_Ogre_Walk#49192",})
			Zn(L["Dungeons"], L["Black Rook Hold"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Black Rook Hold"], "MUS_70_BlackRookHold_WalkA#76004", "MUS_70_BlackRookHold_WalkB#76007", "MUS_70_BlackRookHold_WalkC#76009",})
			Zn(L["Dungeons"], L["Cathedral of Eternal Night"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Cathedral of Eternal Night"], "MUS_72_ToS_Dungeon_GeneralWalk#85030", "MUS_72_ToS_Dungeon_GardenWalk#85032", "MUS_72_ToS_Dungeon_ChapelWalk#85031", "MUS_72_ToS_Dungeon_LegionWalk#85033", "MUS_72_ToS_Dungeon_LibraryWalk#85169",})
			Zn(L["Dungeons"], L["Court of Stars"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Court of Stars"], "MUS_70_DGN_SuramarCityDungeon_Walk01#76837", "MUS_70_DGN_SuramarCityDungeon_Walk02#76838",})
			Zn(L["Dungeons"], L["Darkheart Thicket"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Darkheart Thicket"], "MUS_70_Nightmare_Orchestral#73385", "MUS_70_Nightmare_Solo#73392", "MUS_70_Nightmare_Synth#73386",})
			Zn(L["Dungeons"], L["Emerald Nightmare"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Emerald Nightmare"], "MUS_70_Nightmare_Orchestral#73385", "MUS_70_Nightmare_Solo#73392", "MUS_70_Nightmare_Synth#73386", "MUS_70_Nightmare_TheEmeraldDream_Walk#76859",})
			Zn(L["Dungeons"], L["Halls of Valor"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Halls of Valor"], "MUS_70_HallsofValor_WalkA#75676", "MUS_70_HallsofValor_WalkB#75678", "MUS_70_HallsofValor_WalkC#75679",})
			Zn(L["Dungeons"], L["Maw of Souls"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Maw of Souls"], "MUS_70_MawofSouls_WalkA#75548", "MUS_70_MawofSouls_WalkB#75549", "MUS_70_MawofSouls_WalkC#75551",})
			Zn(L["Dungeons"], L["Neltharion's Lair"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Neltharion's Lair"], "MUS_70_NetharionsLair_WalkA#75947", "MUS_70_NetharionsLair_WalkB#75949", "MUS_70_NetharionsLair_WalkC#75953", "MUS_70_NetharionsLair_WalkD#75954",})
			Zn(L["Dungeons"], L["Nighthold"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Nighthold"], "MUS_62_Tanaan_HFC_Archimonde_Battle#51525", "MUS_71_TheNightholdIndoorWalk#79673", "MUS_71_TheNightholdOutdoorWalk#79674", "MUS_71_TheNightholdBattleHeavy#79675", "MUS_71_TheNightholdLegionFel#79676",})
			Zn(L["Dungeons"], L["Return to Karazhan"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Return to Karazhan"], "MUS_71_KarazhanGeneralDefault#79499",})
			Zn(L["Dungeons"], L["Seat of the Triumvirate"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Seat of the Triumvirate"], "MUS_73_TheSeatoftheTriumvirate_VoidFullWalk#90572", "MUS_73_TheSeatoftheTriumvirate_VoidMediumWalk#90573",})
			Zn(L["Dungeons"], L["Tomb of Sargeras"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Tomb of Sargeras"], "MUS_72_ToS_Raid_GeneralWalk#85171", "MUS_72_ToS_Raid_LegionWalk#85887", "MUS_72_ToS_Raid_TitanWalk#85888", "MUS_72_ToS_Raid_NightElfWalk#85889", "MUS_72_ToS_Raid_Naga_GeneralWalk#86406", "MUS_72_ToS_Raid_Naga_BossWalk#86407",})
			Zn(L["Dungeons"], L["Trial of Valor"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Trial of Valor"], "MUS_70_HallsofValor_WalkA#75676", "MUS_70_HallsofValor_WalkB#75678", "MUS_70_HallsofValor_WalkC#75679", "MUS_70_Zone_Stormheim_Mystic_Walk#76491", "MUS_71_TrialOfValor-DarkCoast-Walk#79719",})
			Zn(L["Dungeons"], L["Vault of the Wardens"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Vault of the Wardens"], "MUS_70_VOTW_Walk_A#74778",})

			-- Battlegrounds
			Zn(L["Dungeons"], "|cffffd800", {""})
			Zn(L["Dungeons"], "|cffffd800" .. L["Battlegrounds"], {""})
			Zn(L["Dungeons"], L["Alterac Valley"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Alterac Valley"], "Altervac Valley_PVP#8014", "Moment - Battle04#6079", "Moment - Gloomy01#6074", "Zone-Mystery#6065",})
			Zn(L["Dungeons"], L["Arathi Basin"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Arathi Basin"], "PVP-Battle Grounds#8233", "Zone-Cursed Land Felwood#5455",})
			Zn(L["Dungeons"], L["Arathi Blizzard"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Arathi Blizzard"], "PVP-Battle Grounds#8233", "Zone-Cursed Land Felwood#5455", "Zone-Mystery#6065",})
			Zn(L["Dungeons"], L["Battle for Gilneas"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Battle for Gilneas"], "MUS_BattleForGilneas_BG#23612",})
			Zn(L["Dungeons"], L["Deepwind Gorge"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Deepwind Gorge"], "PVP-Battle Grounds--DeepwindGorge#37659",})
			Zn(L["Dungeons"], L["Eye of the Storm"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Eye of the Storm"], "PVP-Battle Grounds#8233",})
			Zn(L["Dungeons"], L["Isle of Conquest"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Isle of Conquest"], "PVP-Battle Grounds#8233", "Zone-WintergraspContested#14912",})
			Zn(L["Dungeons"], L["Silvershard Mines"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Silvershard Mines"], "PVP-Battle Grounds-SilvershardMines#33713",})
			Zn(L["Dungeons"], L["Strand of the Ancients"]		, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Strand of the Ancients"], "PVP-Battle Grounds#8233",})
			Zn(L["Dungeons"], L["Tarren Mill vs Southshore"]	, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Tarren Mill vs Southshore"], "Zone-Forest Day#2523",})
			Zn(L["Dungeons"], L["Temple of Kotmogu"]			, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Temple of Kotmogu"], "MUS_50_Scenario_TempleofKotmogu#33978", "PVP-Battle Grounds-Pandaria#33714",})
			Zn(L["Dungeons"], L["Twin Peaks"]					, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Twin Peaks"], "MUS_TwinPeaks_BG#23613",})
			Zn(L["Dungeons"], L["Warsong Gulch"]				, {	"|cffffd800" .. L["Dungeons"] .. ": " .. L["Warsong Gulch"], "PVP-Battle Grounds#8233",})

			-- Various
			Zn(L["Various"], "|cffffd800" .. L["Various"], {""})
			Zn(L["Various"], L["Anduin's Theme"]				, {	"|cffffd800" .. L["Various"] .. ": " .. L["Anduin's Theme"], "MUS_70_Zone_Stormwind_PostBrokenShore_Funeral_01#75552", "MUS_70_Zone_Stormwind_LionsRest_Day#73345", "MUS_70_Zone_Stormwind_LionsRest_Night#73344", "MUS_70_BrokenShore_ShipIntro#73387", "MUS_72_BrokenShore_Wyrnnfall_Intro#85166",})
			Zn(L["Various"], L["Cinematics"]					, {	"|cffffd800" .. L["Various"] .. ": " .. L["Cinematics"], "GS_Retail#10924", "GS_BurningCrusade#10925", "GS_LichKing#12765", "GS_Cataclysm#23640", "MUS_50_HeartofPandaria_MainTitle#28509", "MUS_60_MainTitle#40169", "MUS_70_MainTitle#56353",}) -- "MUS_1.0_MainTitle_Original#47598"
			Zn(L["Various"], L["Class Trials"]					, {	"|cffffd800" .. L["Various"] .. ": " .. L["Class Trials"], "MUS_70_ClassTrial_Horde_BattleWalk#71954", "MUS_70_ClassTrial_Alliance_BattleWalk#71959",})
			Zn(L["Various"], L["Credits"]						, {	"|cffffd800" .. L["Various"] .. ": " .. L["Credits"], "Menu-Credits01#10763", "Menu-Credits02#10804", "Menu-Credits03#13822", "Menu-Credits04#23812", "Menu-Credits05#32015", "Menu-Credits06#34020", "Menu-Credits07#56354",})
			Zn(L["Various"], L["Diablo Anniversary"]			, {	"|cffffd800" .. L["Various"] .. ": " .. L["Diablo Anniversary"], "MUS_71_Event_DiabloAnniversary_TristramGuitar (Everything)#78803",})
			Zn(L["Various"], L["Jaina's Theme"]					, {	"|cffffd800" .. L["Various"] .. ": " .. L["Jaina's Theme"], "MUS_60_Proudmoore_01#49356", "MUS_60_Proudmoore_02#49357", "MUS_60_Proudmoore_03#49358",})
			Zn(L["Various"], L["Music Rolls"]					, {	"|cffffd800" .. L["Various"] .. ": " .. L["Music Rolls"], "MUS_61_GarrisonMusicBox_01#49511", "MUS_61_GarrisonMusicBox_02#49512", "MUS_61_GarrisonMusicBox_03#49513", "MUS_61_GarrisonMusicBox_04#49514", "MUS_61_GarrisonMusicBox_05#49515", "MUS_61_GarrisonMusicBox_06#49516", "MUS_61_GarrisonMusicBox_07#49529", "MUS_61_GarrisonMusicBox_08#49530", "MUS_61_GarrisonMusicBox_09#49531", "MUS_61_GarrisonMusicBox_10#49533", "MUS_61_GarrisonMusicBox_11#49535", "MUS_61_GarrisonMusicBox_12#49536", "MUS_61_GarrisonMusicBox_13#49538", "MUS_61_GarrisonMusicBox_14#49539", "MUS_61_GarrisonMusicBox_15#49540", "MUS_61_GarrisonMusicBox_16#49541", "MUS_61_GarrisonMusicBox_17#49543", "MUS_61_GarrisonMusicBox_18#49544", "MUS_61_GarrisonMusicBox_19#49545", "MUS_61_GarrisonMusicBox_20#49546", "MUS_61_GarrisonMusicBox_21#49526", "MUS_61_GarrisonMusicBox_22#49528", "MUS_61_GarrisonMusicBox_23_Alliance#49517", "MUS_61_GarrisonMusicBox_24_Alliance#49518", "MUS_61_GarrisonMusicBox_25_Alliance#49519", "MUS_61_GarrisonMusicBox_26_Alliance#49520", "MUS_61_GarrisonMusicBox_27_Alliance#49521", "MUS_61_GarrisonMusicBox_28_Alliance#49522", "MUS_61_GarrisonMusicBox_29_Alliance#49523", "MUS_61_GarrisonMusicBox_30_Alliance#49524", "MUS_61_GarrisonMusicBox_31_Alliance#49525", "MUS_61_GarrisonMusicBox_23_Horde#49555", "MUS_61_GarrisonMusicBox_24_Horde#49554", "MUS_61_GarrisonMusicBox_25_Horde#49553", "MUS_61_GarrisonMusicBox_26_Horde#49552", "MUS_61_GarrisonMusicBox_27_Horde#49551", "MUS_61_GarrisonMusicBox_28_Horde#49550", "MUS_61_GarrisonMusicBox_29_Horde#49549", "MUS_61_GarrisonMusicBox_30_Horde#49548", "MUS_61_GarrisonMusicBox_31_Horde#49547",})

			-- Movies
			Zn(L["Movies"], "|cffffd800" .. L["Movies"], {""})
			Zn(L["Movies"], L["World of Warcraft"]				, {	"|cffffd800" .. L["Movies"] .. ": " .. L["World of Warcraft"], L["Ten Years of Warcraft"] .. " |r(1)", L["World of Warcraft"] .. " |r(2)"})
			Zn(L["Movies"], L["The Burning Crusade"]			, {	"|cffffd800" .. L["Movies"] .. ": " .. L["The Burning Crusade"], L["The Burning Crusade"] .. " |r(27)"})
			Zn(L["Movies"], L["Wrath of the Lich King"]			, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Wrath of the Lich King"], L["Wrath of the Lich King"] .. " |r(18)", L["Battle of Angrathar the Wrathgate"] .. " |r(14)", L["Fall of the Lich King"] .. " |r(16)"})
			Zn(L["Movies"], L["Cataclysm"]						, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Cataclysm"], L["Cataclysm"] .. " |r(23)", L["Last Stand"] .. " |r(21)", L["Leaving Kezan"] .. " |r(22)", L["The Dragon Soul"] .. " |r(73)", L["Spine of Deathwing"] .. " |r(74)", L["Madness of Deathwing"] .. " |r(75)", L["Fall of Deathwing"] .. " |r(76)"})
			Zn(L["Movies"], L["Mists of Pandaria"]				, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Mists of Pandaria"], L["Mists of Pandaria"] .. " |r(115)", L["Risking It All"] .. " |r(117)", L["Leaving the Wandering Isle"] .. " |r(116)", L["The King's Command"] .. " |r(119)", L["The Art of War"] .. " |r(120)", L["Battle of Serpent's Heart"] .. " |r(118)", L["The Fleet in Krasarang (Horde)"] .. " |r(128)", L["The Fleet in Krasarang (Alliance)"] .. " |r(127)", L["Hellscream's Downfall (Horde)"] .. " |r(151)", L["Hellscream's Downfall (Alliance)"] .. " |r(152)"})
			Zn(L["Movies"], L["Warlords of Draenor"]			, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Warlords of Draenor"], L["Warlords of Draenor"] .. " |r(195)", L["Darkness Falls"] .. " |r(167)", L["The Battle of Thunder Pass"] .. " |r(168)", L["And Justice for Thrall"] .. " |r(177)", L["Into the Portal"] .. " |r(185)", L["A Taste of Iron"] .. " |r(187)", L["The Battle for Shattrath"] .. " |r(188)", L["Establish Your Garrison (Horde)"] .. " |r(189)", L["Establish Your Garrison (Alliance)"] .. " |r(192)", L["Bigger is Better (Horde)"] .. " |r(190)", L["Bigger is Better (Alliance)"] .. " |r(193)", L["My Very Own Castle (Horde)"] .. " |r(191)", L["My Very Own Castle (Alliance)"] .. " |r(194)", L["Gul'dan Ascendant"] .. " |r(270)", L["Shipyard Construction (Horde)"] .. " |r(292)", L["Shipyard Construction (Alliance)"] .. " |r(293)", L["Gul'dan's Plan"] .. "  |r(294)", L["Victory in Draenor!"] .. "  |r(295)"})
			Zn(L["Movies"], L["Legion"]							, {	"|cffffd800" .. L["Movies"] .. ": " .. L["Legion"], L["Legion"] .. " |r(470)", L["The Invasion Begins"] .. " |r(469)", L["Return to the Black Temple"] .. " |r(471)", L["The Demon's Trail"] .. " |r(473)", L["The Fate of Val'sharah"] .. " |r(472)", L["Fate of the Horde"] .. " |r(474)", L["A New Life for Undeath"] .. " |r(475)", L["Harbingers Gul'dan"] .. " |r(476)", L["Harbingers Khadgar"] .. " |r(477)", L["Harbingers Illidan"] .. " |r(478)", L["The Nightborne Pact"] .. " |r(485)", L["The Battle for Broken Shore"] .. " |r(487)", L["A Falling Star"] .. " |r(489)", L["An Unclear Path"] .. " |r(490)", L["Victory at The Nighthold"] .. " |r(635)", L["A Found Memento"] .. " |r(636)", L["Kil'jaeden's Downfall"] .. " |r(656)", L["Arrival on Argus"] .. " |r(677)", L["Rejection of the Gift"] .. " |r(679)", L["Reincarnation of Alleria Windrunner"] .. " |r(682)", L["Rise of Argus"] .. " |r(687)", L["Antorus Ending"] .. " |r(689)", L["Epilogue (Horde)"] .. " |r(717)", L["Epilogue (Alliance)"] .. " |r(716)"})

			-- Give zone table a file level scope so slash command function can access it
			LeaPlusLC["ZoneList"] = ZoneList

			-- Show relevant list items
			local function UpdateList()
				FauxScrollFrame_Update(scrollFrame, #ListData, numButtons, 16)
				for index = 1, numButtons do
					local offset = index + FauxScrollFrame_GetOffset(scrollFrame)
					local button = scrollFrame.buttons[index]
					button.index = offset
					if offset <= #ListData then
						-- Show zone listing or track listing
						button:SetText(ListData[offset].zone or ListData[offset])
						-- Set width of highlight texture
						if button:GetTextWidth() > 290 then
							button.t:SetSize(290, 16)
						else
							button.t:SetSize(button:GetTextWidth(), 16)
						end
						-- Show the button
						button:Show()
						-- Hide highlight bar texture by default
						button.s:Hide()
						-- Hide highlight bar if the button is a heading
						if strfind(button:GetText(), "|c") then button.t:Hide() end
						-- Show last played track highlight bar texture 
						if LastPlayed == button:GetText() then
							local HeadingOfCurrentFolder = ListData[1]
							if HeadingOfCurrentFolder == HeadingOfClickedTrack then
								button.s:Show()
							end
						end
						-- Show last played folder highlight bar texture
						if LastFolder == button:GetText() then
							button.s:Show()
						end
						-- Set width of highlight bar
						if button:GetTextWidth() > 290 then
							button.s:SetSize(290, 16)
						else
							button.s:SetSize(button:GetTextWidth(), 16)
						end
						-- Limit click to label width
						local bWidth = button:GetFontString():GetStringWidth() or 0
						if bWidth > 290 then bWidth = 290 end
						button:SetHitRectInsets(0, 454 - bWidth, 0, 0)
						-- Disable label click movement
						button:SetPushedTextOffset(0, 0)
						-- Disable word wrap and set width
						button:GetFontString():SetWidth(290)
						button:GetFontString():SetWordWrap(false)
					else
						button:Hide()
					end
				end
			end

			-- Give function file level scope (it's used in SetPlusScale to set the highlight bar scale)
			LeaPlusLC.UpdateList = UpdateList

			-- Right-button click to go back
			local function BackClick()
				-- Return to the current zone list (back button)
				if type(ListData[1]) == "string" then
					-- Strip the color code from the list data
					local nocol = string.gsub(ListData[1], "|cffffd800", "")
					-- Strip the zone
					local backzone = strsplit(":", nocol, 2)
					-- Don't go back if random or search category is being shown
					if backzone == L["Random"] or backzone == L["Search"] then return end
					-- Show the tracklist continent 
					if ZoneList[backzone] then ListData = ZoneList[backzone] end
					UpdateList()
					scrollFrame:SetVerticalScroll(ZonePage or 0)
				end
			end

			-- Function to make navigation menu buttons
			local function MakeButton(where, y)
				local mbtn = CreateFrame("Button", nil, LeaPlusLC["Page9"])
				mbtn:Show()
				mbtn:SetAlpha(1.0)
				mbtn:SetPoint("TOPLEFT", 146, y)

				-- Create hover texture
				mbtn.t = mbtn:CreateTexture(nil, "BACKGROUND")
				mbtn.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
				mbtn.t:SetAlpha(0.7)
				mbtn.t:SetAllPoints()
				mbtn.t:Hide()

				-- Create highlight texture
				mbtn.s = mbtn:CreateTexture(nil, "BACKGROUND")
				mbtn.s:SetColorTexture(0.3, 0.3, 0.00, 0.8)
				mbtn.s:SetAlpha(1.0)
				mbtn.s:SetAllPoints()
				mbtn.s:Hide()

				-- Create fontstring
				mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				mbtn.f:SetPoint('LEFT', 1, 0)
				mbtn.f:SetText(L[where])

				mbtn:SetScript("OnEnter", function()
					mbtn.t:Show()
				end)

				mbtn:SetScript("OnLeave", function()
					mbtn.t:Hide()
				end)

				-- Set button size when shown
				mbtn:SetScript("OnShow", function()
					mbtn:SetSize(mbtn.f:GetStringWidth() + 1, 16)
				end)

				mbtn:SetScript("OnClick", function()
					-- Show zone listing for clicked item
					ListData = ZoneList[where]
					UpdateList()
				end)

				return mbtn, mbtn.s

			end

			-- Create a table for each button
			local conbtn = {}
			for q, w in pairs(ZoneList) do
				conbtn[q] = {}
			end

			-- Create buttons
			local function MakeButtonNow(title, anchor)
				conbtn[title], conbtn[title].s = MakeButton(title, height)
				conbtn[title]:ClearAllPoints()
				if title == L["Eastern"] then
					-- Set first button position
					conbtn[title]:SetPoint("TOPLEFT", LeaPlusLC["Page9"], "TOPLEFT", 145, -70)
				else
					-- Set subsequent button positions
					conbtn[title]:SetPoint("TOPLEFT", conbtn[anchor], "BOTTOMLEFT", 0, -00)
					conbtn[title].f:SetText(L[title])
				end
			end

			MakeButtonNow(L["Eastern"])
			MakeButtonNow(L["Kalimdor"], L["Eastern"])
			MakeButtonNow(L["Outland"], L["Kalimdor"])
			MakeButtonNow(L["Northrend"], L["Outland"])
			MakeButtonNow(L["Maelstrom"], L["Northrend"])
			MakeButtonNow(L["Pandaria"], L["Maelstrom"])
			MakeButtonNow(L["Draenor"], L["Pandaria"])
			MakeButtonNow(L["Broken Isles"], L["Draenor"])
			MakeButtonNow(L["Dungeons"], L["Broken Isles"])
			MakeButtonNow(L["Various"], L["Dungeons"])
			MakeButtonNow(L["Random"], L["Various"])
			MakeButtonNow(L["Search"], L["Random"])
			MakeButtonNow(L["Movies"], L["Search"])

			-- Show button highlight for clicked button
			for q, w in pairs(ZoneList) do
				if type(w) == "string" and conbtn[w] then
					conbtn[w]:HookScript("OnClick", function()
						-- Hide all button highlights
						for k, v in pairs(ZoneList) do
							if type(v) == "string" and conbtn[v] then
								conbtn[v].s:Hide()
							end
						end
						-- Show clicked button highlight
						conbtn[w].s:Show()
						LeaPlusDB["MusicContinent"] = w
						scrollFrame:SetVerticalScroll(0)
					end)
				end
			end

			-- Create scroll bar
			scrollFrame = CreateFrame("ScrollFrame", "LeaPlusScrollFrame", LeaPlusLC["Page9"], "FauxScrollFrameTemplate")
			scrollFrame:SetPoint("TOPLEFT", 0, -32)
			scrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)
			scrollFrame:SetFrameLevel(10)
			scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
				FauxScrollFrame_OnVerticalScroll(self, offset, 16, UpdateList)
			end)

			-- Add stop button
			local stopBtn = LeaPlusLC:CreateButton("StopMusicBtn", LeaPlusLC["Page9"], "Stop", "TOPRIGHT", -32, -31, 0, 25, true, "")
			stopBtn:ClearAllPoints()
			stopBtn:SetPoint("TOPLEFT", conbtn[L["Movies"]], "BOTTOMLEFT", 0, -10)
			stopBtn:Hide(); stopBtn:Show()
			LeaPlusLC:LockItem(stopBtn, true)
			stopBtn:SetScript("OnClick", function()
				if musicHandle then
					StopSound(musicHandle)
					musicHandle = nil
					-- Hide highlight bars
					LastPlayed = ""
					LastFolder = ""
					UpdateList()
				end
				-- Lock button and cancel update script
				LeaPlusLC:LockItem(stopBtn, true)
				uframe:UnregisterEvent("SOUNDKIT_FINISHED")
				uframe:UnregisterEvent("LOADING_SCREEN_DISABLED")
			end)

			-- Store currently playing track number
			local tracknumber = 1

			-- Function to play a track and show the static highlight bar
			local function PlayTrack()
				-- Play tracks
				if musicHandle then StopSound(musicHandle) end
				local file, soundID = playlist[tracknumber]:match("([^,]+)%#([^,]+)")
				willPlay, musicHandle = PlaySound(soundID, "Master", false, true)
				-- Store its handle for later use
				LastMusicHandle = musicHandle
				LastPlayed = playlist[tracknumber]
				tracknumber = tracknumber + 1
				-- Show static highlight bar
				for index = 1, numButtons do
					local button = scrollFrame.buttons[index]
					local item = button:GetText()
					if item then
						local item, void = item:match("([^,]+)%#([^,]+)")
						if item then
							if item == file and LastFolder == TempFolder then
								button.s:Show()
							else
								button.s:Hide()
							end
						end
					end
				end
			end

			-- Create editbox for search
			local sBox = LeaPlusLC:CreateEditBox("MusicSearchBox", LeaPlusLC["Page9"], 288, 10, "TOPLEFT", 250, -40, "MusicSearchBox", "MusicSearchBox")
			sBox:SetMaxLetters(50)
			sBox.label = sBox:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			sBox.label:SetPoint("BOTTOMLEFT", sBox, "TOPLEFT", -4, 0)
			sBox.label:SetText(L["Search for music name or ID"])
			sBox:Hide()

			-- Show editbox only when search category is selected
			for q, w in pairs(ZoneList) do
				if conbtn[w] then
					conbtn[w]:HookScript("OnClick", function()
						if w == L["Search"] then
							ListData[1] = "|cffffd800" .. L["Search"]
							UpdateList()
							sBox:Show()
						else
							sBox:Hide()
						end
					end)
				end
			end

			-- Function to show search results
			local function ShowSearchResults()
				-- Get unescaped editbox text
				local searchText = gsub(strlower(sBox:GetText()), '(['..("%^$().[]*+-?"):gsub("(.)", "%%%1")..'])', "%%%1")
				-- Wipe the track listing
				wipe(ListData)
				-- Set the track list heading
				ListData[1] = "|cffffd800" .. L["Search"]
				-- Traverse music listing and populate ListData
				if searchText ~= "" then
					for i, e in pairs(LeaPlusLC.ZoneList) do
						if LeaPlusLC.ZoneList[e] then
							for a, b in pairs(LeaPlusLC.ZoneList[e]) do
								if b.tracks then
									for k, v in pairs(b.tracks) do
										if strfind(v, "#") and strfind(strlower(v), searchText) and not tContains(ListData, v) then
											tinsert(ListData, v)
										end
									end
								end
							end
						end
					end
				end
				-- Refresh the track listing
				UpdateList()
				-- Set track listing to top
				scrollFrame:SetVerticalScroll(0)
			end

			-- Populate ListData when editbox is changed by user
			sBox:HookScript("OnTextChanged", function(self, userInput)
				if userInput then
					-- Show search page
					conbtn[L["Search"]]:Click()
					-- If search results are currently playing, stop playback since search results will be changed
					if LastFolder == L["Search"] then stopBtn:Click() end
					-- Show search results
					ShowSearchResults()
				end
			end)

			-- Create button to generate a random selection of tracks
			local randomBtn = LeaPlusLC:CreateButton("MusicRandomButton", LeaPlusLC["Page9"], L["Generate new random selection"], "TOPLEFT", 244, -30, 0, 25, true, "")

			-- Show button only when random category is selected
			for q, w in pairs(ZoneList) do
				if conbtn[w] then
					conbtn[w]:HookScript("OnClick", function()
						if w == L["Random"] then
							randomBtn:Show()
							-- Generate initial playlist for first run
							if #ListData == 0 then
								randomBtn:Click()
							end
						else
							randomBtn:Hide()
						end
					end)
				end
			end

			-- Button click handler
			randomBtn:SetScript("OnClick", function()
				-- If random track is currently playing, stop playback since random track list will be changed
				if LastFolder == L["Random"] then 
					stopBtn:Click()
				end
				-- Wipe the track listing for random
				wipe(ListData)
				-- Set the track list heading
				ListData[1] = "|cffffd800" .. L["Random"]
				-- Populate list data until it contains desired number of tracks
				while #ListData < 200 do
					-- Get random category
					local rCategory = GetRandomArgument(L["Eastern"], L["Kalimdor"], L["Outland"], L["Northrend"], L["Maelstrom"], L["Pandaria"], L["Draenor"], L["Broken Isles"], L["Dungeons"], L["Various"])
					-- Get random zone within category
					local rZone = random(1, #ZoneList[rCategory])
					-- Get random track within zone
					local rTrack = ZoneList[rCategory][rZone].tracks[random(1, #ZoneList[rCategory][rZone].tracks)]
					-- Insert track into ListData if it's not a duplicate
					if rTrack and rTrack ~= "" and strfind(rTrack, "#") and not tContains(ListData, rTrack) then
						tinsert(ListData, rTrack)
					end
				end
				-- Refresh the track listing
				UpdateList()
				-- Set track listing to top
				scrollFrame:SetVerticalScroll(0)
			end)

			-- Create list items
			scrollFrame.buttons = {}
			for i = 1, numButtons do
				scrollFrame.buttons[i] = CreateFrame("Button", nil, LeaPlusLC["Page9"])
				local button = scrollFrame.buttons[i]

				button:SetSize(470 - 14, 16)
				button:SetNormalFontObject("GameFontHighlightLeft")
				button:SetPoint("TOPLEFT", 246, -62+ -(i - 1) * 16 - 8)

				-- Create highlight bar texture
				button.t = button:CreateTexture(nil, "BACKGROUND")
				button.t:SetPoint("TOPLEFT", button, 0, 0)
				button.t:SetSize(516, 16)

				button.t:SetColorTexture(0.3, 0.3, 0.0, 0.8)
				button.t:SetAlpha(0.7)
				button.t:Hide()

				-- Create last playing highlight bar texture
				button.s = button:CreateTexture(nil, "BACKGROUND")
				button.s:SetPoint("TOPLEFT", button, 0, 0)
				button.s:SetSize(516, 16)

				button.s:SetColorTexture(0.3, 0.4, 0.00, 0.6)
				button.s:Hide()

				button:SetScript("OnEnter", function()
					-- Highlight links only
					if not string.match(button:GetText() or "", "|c") then
						button.t:Show()
					end
				end)

				button:SetScript("OnLeave", function()
					button.t:Hide()
				end)

				button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

				-- Handler for playing next SoundKit track in playlist
				uframe:SetScript("OnEvent", function(self, event, stoppedHandle)
					if event == "SOUNDKIT_FINISHED" then
						-- Do nothing if stopped sound kit handle doesnt match last played track handle
						if LastMusicHandle and LastMusicHandle ~= stoppedHandle then return end
						-- Reset track number if playlist has reached the end
						if tracknumber == #playlist then tracknumber = 1 end
						-- Set TempFolder to Random if random playlist is being played
						if LastFolder == L["Random"] then TempFolder = L["Random"] end
						-- Set TempFolder to Search if search results are being played
						if LastFolder == L["Search"] then TempFolder = L["Search"] end
						-- Play next track
						PlayTrack()
					elseif event == "LOADING_SCREEN_DISABLED" then
						-- Restart player if it stopped between tracks during loading screen
						if playlist and tracknumber and playlist[tracknumber] and not willPlay and not musicHandle then
							tracknumber = tracknumber - 1
							C_Timer.After(0.1, PlayTrack)
						end
					end
				end)

				-- Click handler for track, zone and back button
				button:SetScript("OnClick", function(self, btn)
					if btn == "LeftButton" then
						-- Remove focus from search box
						sBox:ClearFocus()
						-- Get clicked track text
						local item = self:GetText()
						-- Do nothing if its a blank line or heading
						if not item or strfind(item, "|c") then return end
						if strfind(item, "#") then
							-- Enable sound if required
							if GetCVar("Sound_EnableAllSound") == "0" then SetCVar("Sound_EnableAllSound", "1") end
							-- Disable music if it's currently enabled
							if GetCVar("Sound_EnableMusic") == "1" then	SetCVar("Sound_EnableMusic", "0") end
							-- Add all tracks to playlist
							wipe(playlist)
							local StartItem = 0
							-- Get item clicked row number
							for index = 1, #ListData do
								local item = ListData[index]
								if self:GetText() == item then StartItem = index end
							end
							-- Add all items from clicked item onwards to playlist
							for index = StartItem, #ListData do
								local item = ListData[index]
								if item then
									if strfind(item, "#") then 
										tinsert(playlist, item)
									end
								end
							end
							-- Add all items up to clicked item to playlist
							for index = 1, StartItem do
								local item = ListData[index]
								if item then
									if strfind(item, "#") then 
										tinsert(playlist, item)
									end
								end
							end
							-- Enable the stop button
							LeaPlusLC:LockItem(stopBtn, false)
							-- Set Temp Folder to Random if track is in Random
							if ListData[1] == "|cffffd800" .. L["Random"] then TempFolder = L["Random"] end
							-- Set Temp Folder to Search if track is in Search
							if ListData[1] == "|cffffd800" .. L["Search"] then TempFolder = L["Search"] end
							-- Store information about the track we are about to play
							tracknumber = 1
							LastPlayed = item
							LastFolder = TempFolder
							HeadingOfClickedTrack = ListData[1]
							-- Play first track
							PlayTrack()
							-- Play subsequent tracks
							uframe:RegisterEvent("SOUNDKIT_FINISHED")
							uframe:RegisterEvent("LOADING_SCREEN_DISABLED")
						elseif strfind(item, "|r") then
							-- A movie was clicked
							local movieName, movieID = item:match("([^,]+)%|r([^,]+)")
							movieID = strtrim(movieID, "()")
							if IsMoviePlayable(movieID) then
								stopBtn:Click()
								LeaPlusLC["ForceMoviePlaybackFlag"] = "On"
								MovieFrame_PlayMovie(MovieFrame, movieID)
								LeaPlusLC["ForceMoviePlaybackFlag"] = "Off"
							else
								LeaPlusLC:Print("Movie not playable.")
							end
						else
							-- A zone was clicked so show track listing
							ZonePage = scrollFrame:GetVerticalScroll()
							-- Find the track listing for the clicked zone
							for q, w in pairs(ZoneList) do
								for k, v in pairs(ZoneList[w]) do
									if item == v.zone then
										-- Show track listing
										TempFolder = item
										LeaPlusDB["MusicZone"] = item
										ListData = v.tracks
										UpdateList()
										-- Hide hover highlight if track under pointer is a heading
										if strfind(scrollFrame.buttons[i]:GetText(), "|c") then
											scrollFrame.buttons[i].t:Hide()
										end
										-- Show top of track list
										scrollFrame:SetVerticalScroll(0)
										return
									end
								end	

							end
						end
					elseif btn == "RightButton" then
						-- Back button was clicked
						BackClick()
					end
				end)

			end

			-- Right-click to go back (from anywhere on the main content area of the panel)
			LeaPlusLC["PageF"]:HookScript("OnMouseUp", function(self, btn)
				if LeaPlusLC["Page9"]:IsShown() and LeaPlusLC["Page9"]:IsMouseOver(0, 0, 0, -440) == false and LeaPlusLC["Page9"]:IsMouseOver(-330, 0, 0, 0) == false then 
					if btn == "RightButton" then
						BackClick()
					end
				end
			end)

			-- Delete the global scroll frame pointer
			_G.LeaPlusScrollFrame = nil

			-- Set zone listing on startup
			if LeaPlusDB["MusicContinent"] and LeaPlusDB["MusicContinent"] ~= "" then
				-- Saved music continent exists
				if conbtn[LeaPlusDB["MusicContinent"]] then
					-- Saved continent is valid button so click it
					conbtn[LeaPlusDB["MusicContinent"]]:Click()
				else
					-- Saved continent is not valid button so click default button
					conbtn[L["Eastern"]]:Click()
				end
			else
				-- Saved music continent does not exist so click default button
				conbtn[L["Eastern"]]:Click()
			end
			UpdateList()

			-- Manage events
			LeaPlusLC["Page9"]:RegisterEvent("PLAYER_LOGOUT")
			LeaPlusLC["Page9"]:RegisterEvent("UI_SCALE_CHANGED")
			LeaPlusLC["Page9"]:SetScript("OnEvent", function(self, event)
				if event == "PLAYER_LOGOUT" then
					-- Stop playing at reload or logout
					if musicHandle then
						StopSound(musicHandle)
					end
				elseif event == "UI_SCALE_CHANGED" then
					-- Refresh list
					UpdateList()
				end
			end)

		end

		-- Run on startup
		LeaPlusLC:MediaFunc()

		-- Release memory
		LeaPlusLC.MediaFunc = nil

		----------------------------------------------------------------------
		-- Panel alpha
		----------------------------------------------------------------------

		-- Function to set panel alpha
		local function SetPlusAlpha()
			-- Set panel alpha
			LeaPlusLC["PageF"].t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
			-- Show formatted value
			LeaPlusCB["PlusPanelAlpha"].f:SetFormattedText("%.0f%%", LeaPlusLC["PlusPanelAlpha"] * 100)
		end

		-- Set alpha on startup
		SetPlusAlpha()

		-- Set alpha after changing slider
		LeaPlusCB["PlusPanelAlpha"]:HookScript("OnValueChanged", SetPlusAlpha)

		----------------------------------------------------------------------
		-- Panel scale
		----------------------------------------------------------------------

		-- Function to set panel scale
		local function SetPlusScale()
			-- Reset panel position
			LeaPlusLC["MainPanelA"], LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
			if LeaPlusLC["PageF"]:IsShown() then 
				LeaPlusLC["PageF"]:Hide()
				LeaPlusLC["PageF"]:Show()
			end
			-- Set panel scale
			LeaPlusLC["PageF"]:SetScale(LeaPlusLC["PlusPanelScale"])
			-- Update music player highlight bar scale
			LeaPlusLC:UpdateList()
		end

		-- Set scale on startup
		LeaPlusLC["PageF"]:SetScale(LeaPlusLC["PlusPanelScale"])

		-- Set scale and reset panel position after changing slider
		LeaPlusCB["PlusPanelScale"]:HookScript("OnMouseUp", SetPlusScale)
		LeaPlusCB["PlusPanelScale"]:HookScript("OnMouseWheel", SetPlusScale)

		-- Show formatted slider value
		LeaPlusCB["PlusPanelScale"]:HookScript("OnValueChanged", function()
			LeaPlusCB["PlusPanelScale"].f:SetFormattedText("%.0f%%", LeaPlusLC["PlusPanelScale"] * 100)
		end)

		----------------------------------------------------------------------
		-- Options panel
		----------------------------------------------------------------------

		-- Hide Leatrix Plus if game options panel is shown
		InterfaceOptionsFrame:HookScript("OnShow", LeaPlusLC.HideFrames);
		VideoOptionsFrame:HookScript("OnShow", LeaPlusLC.HideFrames);

		----------------------------------------------------------------------
		-- Block friend requests
		----------------------------------------------------------------------

		-- Hide toast frame for friend requests
		hooksecurefunc("BNToastFrame_Show", function()
			if LeaPlusLC["NoFriendRequests"] == "On" then
				if BNToastFrame.toastType == 4 or BNToastFrame.toastType == 5 then
					BNToastFrame_Close()
				end
			end
		end)

		-- Function to decline friend requests
		local function DeclineReqs()
			if LeaPlusLC["NoFriendRequests"] == "On" then
				for i = BNGetNumFriendInvites(), 1, -1 do
					local id, player = BNGetFriendInviteInfo(i)
					if id and player then
						BNDeclineFriendInvite(id)
						C_Timer.After(0.1, function()
							LeaPlusLC:Print(L["A friend request from"] .. " " .. player .. " " .. L["was automatically declined."])
						end)
					end
				end
			end
		end

		-- Event frame for incoming friend requests
		local DecEvt = CreateFrame("FRAME")
		DecEvt:SetScript("OnEvent", DeclineReqs)

		-- Function to register or unregister the event
		local function ControlEvent()
			if LeaPlusLC["NoFriendRequests"] == "On" then
				DecEvt:RegisterEvent("BN_FRIEND_INVITE_ADDED")
				DeclineReqs()
			else
				DecEvt:UnregisterEvent("BN_FRIEND_INVITE_ADDED")
			end
		end

		-- Set event status when option is enabled
		LeaPlusCB["NoFriendRequests"]:HookScript("OnClick", ControlEvent)

		-- Set event status on startup
		ControlEvent()

		----------------------------------------------------------------------
		-- Accept resurrection configuration panel
		----------------------------------------------------------------------

		local ResPanel = LeaPlusLC:CreatePanel("Accept Resurrection", "ResPanel")
		LeaPlusLC:MakeTx(ResPanel, "Settings", 16, -72)
		LeaPlusLC:MakeCB(ResPanel, "ResThankYouEmote", "Thank the player who resurrected you", 16, -92, false, "If checked, your character will emote a thank you when a resurrection is automatically accepted.")
		LeaPlusLC:MakeCB(ResPanel, "NoAutoResInCombat", "Exclude combat resurrection requests", 16, -112, false, "If checked, resurrection requests will not be automatically accepted if the player resurrecting you is in combat.")
		LeaPlusLC:MakeCB(ResPanel, "NoAutoResPylon", "Exclude pylon and brazier requests", 16, -132, false, "If checked, resurrection requests from a Failure Detection Pylon or a Brazier of Awakening will not be automatically accepted.")

		-- Help button hidden
		ResPanel.h:Hide()

		-- Back button handler
		ResPanel.b:SetScript("OnClick", function() 
			ResPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page1"]:Show();
			return
		end) 

		-- Reset button handler
		ResPanel.r:SetScript("OnClick", function()
			-- Reset checkboxes
			LeaPlusLC["ResThankYouEmote"] = "On"
			LeaPlusLC["NoAutoResInCombat"] = "Off"
			LeaPlusLC["NoAutoResPylon"] = "On"
			-- Refresh configuration panel
			ResPanel:Hide(); ResPanel:Show();
		end)

		-- Configuration button handler
		LeaPlusCB["AutoResBtn"]:SetScript("OnClick", function()
			if IsShiftKeyDown() and IsControlKeyDown() then
				-- Preset profile
				LeaPlusLC["ResThankYouEmote"] = "On"
				LeaPlusLC["NoAutoResInCombat"] = "Off"
				LeaPlusLC["NoAutoResPylon"] = "On"
			else
				-- Show configuration panel
				ResPanel:Show();
				LeaPlusLC:HideFrames();
			end
		end);

		----------------------------------------------------------------------
		-- Release in PvP configuration panel
		----------------------------------------------------------------------

		-- Create configuration panel
		local ReleasePanel = LeaPlusLC:CreatePanel("Release in PvP", "ReleasePanel")

		-- Add checkboxes
		LeaPlusLC:MakeTx(ReleasePanel, "Settings", 16, -72)
		LeaPlusLC:MakeCB(ReleasePanel, "AutoRelBGs", "Battlegrounds", 16, -92, false, "If checked, you will release automatically after you die in a battleground.")
		LeaPlusLC:MakeCB(ReleasePanel, "AutoRelWintergrasp", "Wintergrasp", 16, -112, false, "If checked, you will release automatically after you die in Wintergrasp.")
		LeaPlusLC:MakeCB(ReleasePanel, "AutoRelTolBarad", "Tol Barad (the PvP zone)", 16, -132, false, "If checked, you will release automatically after you die in Tol Barad (the PvP zone).")
		LeaPlusLC:MakeCB(ReleasePanel, "AutoRelAshran", "Ashran", 16, -152, false, "If checked, you will release automatically after you die in Ashran.")

		-- Help button hidden
		ReleasePanel.h:Hide()

		-- Back button handler
		ReleasePanel.b:SetScript("OnClick", function() 
			ReleasePanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page1"]:Show();
			return
		end) 

		-- Reset button handler
		ReleasePanel.r:SetScript("OnClick", function()
			-- Reset checkboxes
			LeaPlusLC["AutoRelBGs"] = "On"
			LeaPlusLC["AutoRelWintergrasp"] = "On"
			LeaPlusLC["AutoRelTolBarad"] = "On";
			LeaPlusLC["AutoRelAshran"] = "On";
			-- Refresh configuration panel
			ReleasePanel:Hide(); ReleasePanel:Show();
		end)

		-- Configuration button handler
		LeaPlusCB["AutoReleaseBtn"]:SetScript("OnClick", function()
			if IsShiftKeyDown() and IsControlKeyDown() then
				-- Preset profile
				LeaPlusLC["AutoRelBGs"] = "On"
				LeaPlusLC["AutoRelWintergrasp"] = "On"
				LeaPlusLC["AutoRelTolBarad"] = "On";
				LeaPlusLC["AutoRelAshran"] = "On";
			else
				-- Show configuration panel
				ReleasePanel:Show();
				LeaPlusLC:HideFrames();
			end
		end);

		----------------------------------------------------------------------
		-- Invite from whisper configuration panel
		----------------------------------------------------------------------

		-- Create configuration panel
		local InvPanel = LeaPlusLC:CreatePanel("Invite from Whispers", "InvPanel")

		-- Add editbox
		LeaPlusLC:MakeTx(InvPanel, "Whisper keyword", 16, -72)
		local KeyBox = LeaPlusLC:CreateEditBox("KeyBox", InvPanel, 140, 10, "TOPLEFT", 20, -92, "KeyBox", "KeyBox");

		-- Function to save the keyword
		local function SetInvKey()
			local keytext = KeyBox:GetText()
			if keytext and keytext ~= "" then
				LeaPlusLC["InvKey"] = KeyBox:GetText()
			else
				LeaPlusLC["InvKey"] = "++"
			end
		end

		-- Save the keyword when it changes
		KeyBox:SetScript("OnTextChanged", SetInvKey)

		-- Help button hidden
		InvPanel.h:Hide()

		-- Back button handler
		InvPanel.b:SetScript("OnClick", function()
			-- Save the keyword
			SetInvKey()
			-- Show the options panel
			InvPanel:Hide(); LeaPlusLC["PageF"]:Show(); LeaPlusLC["Page2"]:Show();
			return
		end) 

		-- Add reset button
		InvPanel.r:SetScript("OnClick", function()
			-- Reset the keyword to default
			LeaPlusLC["InvKey"] = "++"
			-- Set the editbox to default
			KeyBox:SetText("++")
			-- Save the keyword
			SetInvKey();
			-- Refresh panel
			InvPanel:Hide(); InvPanel:Show();
		end)

		-- Ensure keyword is a string on startup
		LeaPlusLC["InvKey"] = tostring(LeaPlusLC["InvKey"]) or "++"

		-- Set editbox value when shown
		KeyBox:HookScript("OnShow", function()
			KeyBox:SetText(LeaPlusLC["InvKey"])
		end)

		-- Configuration button handler
		LeaPlusCB["InvWhisperBtn"]:SetScript("OnClick", function()
			if IsShiftKeyDown() and IsControlKeyDown() then
				-- Preset profile
				LeaPlusLC["InvKey"] = "++"
				KeyBox:SetText(LeaPlusLC["InvKey"]);
				SetInvKey();
			else
				-- Show panel
				InvPanel:Show()
				LeaPlusLC:HideFrames();
			end
		end)

		----------------------------------------------------------------------
		-- Final code for RunOnce
		----------------------------------------------------------------------

		-- Update addon memory usage (speeds up initial value)
		UpdateAddOnMemoryUsage();

		-- Release memory
		LeaPlusLC.RunOnce = nil

	end

----------------------------------------------------------------------
-- 	L70: Default events
----------------------------------------------------------------------

	local function eventHandler(self, event, arg1, arg2, ...)

		----------------------------------------------------------------------
		-- Invite from whisper
		----------------------------------------------------------------------

		if event == "CHAT_MSG_WHISPER" or event == "CHAT_MSG_BN_WHISPER" then
			if (not UnitExists("party1") or UnitIsGroupLeader("player")) and strlower(arg1) == strlower(LeaPlusLC["InvKey"]) then
				if not LeaPlusLC:IsInLFGQueue() then
					if event == "CHAT_MSG_WHISPER" then
						InviteUnit(arg2)
					elseif event == "CHAT_MSG_BN_WHISPER" then
						local presenceID = select(11, ...)
						if presenceID and BNIsFriend(presenceID) then
							local index = BNGetFriendIndex(presenceID);
							if index then
								local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID = BNGetFriendInfo(index);
								if toonID then
									BNInviteFriend(toonID);
								end
							end
						end
					end
				end
			end
			return
		end

		----------------------------------------------------------------------
		-- Block duel requests
		----------------------------------------------------------------------

		if event == "DUEL_REQUESTED" and not LeaPlusLC:FriendCheck(arg1) then
			CancelDuel();
			StaticPopup_Hide("DUEL_REQUESTED");
			return
		end

		----------------------------------------------------------------------
		-- Block pet battle duel requests
		----------------------------------------------------------------------

		if event == "PET_BATTLE_PVP_DUEL_REQUESTED" and not LeaPlusLC:FriendCheck(arg1) then
			C_PetBattles.CancelPVPDuel()
			return
		end

		----------------------------------------------------------------------
		-- Automatically accept resurrection requests
		----------------------------------------------------------------------

		if event == "RESURRECT_REQUEST" then

			-- Exclude pylon and brazier requests
			if LeaPlusLC["NoAutoResPylon"] == "On" then

				local pylonLoc

				-- Exclude Failure Detection Pylon
				pylonLoc = "Failure Detection Pylon"
				if 	   GameLocale == "zhCN" then pylonLoc = "故障检测晶塔"
				elseif GameLocale == "zhTW" then pylonLoc = "滅團偵測水晶塔"
				elseif GameLocale == "ruRU" then pylonLoc = "Пилон для обнаружения проблем"
				elseif GameLocale == "koKR" then pylonLoc = "고장 감지 변환기"
				elseif GameLocale == "esMX" then pylonLoc = "Pilón detector de errores"
				elseif GameLocale == "ptBR" then pylonLoc = "Pilar Detector de Falhas"
				elseif GameLocale == "deDE" then pylonLoc = "Fehlschlagdetektorpylon"
				elseif GameLocale == "esES" then pylonLoc = "Pilón detector de errores"
				elseif GameLocale == "frFR" then pylonLoc = "Pylône de détection des échecs"
				elseif GameLocale == "itIT" then pylonLoc = "Pilone d'Individuazione Fallimenti"
				end
				if arg1 == pylonLoc then return	end

				-- Exclude Brazier of Awakening
				pylonLoc = "Brazier of Awakening"
				if 	   GameLocale == "zhCN" then pylonLoc = "觉醒火盆"
				elseif GameLocale == "zhTW" then pylonLoc = "覺醒火盆"
				elseif GameLocale == "ruRU" then pylonLoc = "Жаровня пробуждения"
				elseif GameLocale == "koKR" then pylonLoc = "각성의 화로"
				elseif GameLocale == "esMX" then pylonLoc = "Blandón del Despertar"
				elseif GameLocale == "ptBR" then pylonLoc = "Braseiro do Despertar"
				elseif GameLocale == "deDE" then pylonLoc = "Kohlenbecken des Erwachens"
				elseif GameLocale == "esES" then pylonLoc = "Blandón de Despertar"
				elseif GameLocale == "frFR" then pylonLoc = "Brasero de l'Éveil"
				elseif GameLocale == "itIT" then pylonLoc = "Braciere del Risveglio"
				end
				if arg1 == pylonLoc then return	end

			end

			-- Manage other resurrection requests
			if ((UnitAffectingCombat(arg1)) and LeaPlusLC["NoAutoResInCombat"] == "Off") or not (UnitAffectingCombat(arg1)) then
				AcceptResurrect()
				StaticPopup_Hide("RESURRECT_NO_TIMER")
				if LeaPlusLC["ResThankYouEmote"] == "On" then
					C_Timer.After(1, function()
						if not UnitIsDeadOrGhost("player") then
							DoEmote("thank", arg1)
						end
					end)
				end
			end
			return

		end

		----------------------------------------------------------------------
		-- Accept summon
		----------------------------------------------------------------------

		if event == "CONFIRM_SUMMON" then
			if not UnitAffectingCombat("player") then
				ConfirmSummon()
				StaticPopup_Hide("CONFIRM_SUMMON")
			end
			return
		end

		----------------------------------------------------------------------
		-- Block party invites
		----------------------------------------------------------------------

		if event == "PARTY_INVITE_REQUEST" then

			-- If a friend, accept if you're accepting friends and not in Dungeon Finder
			if (LeaPlusLC["AcceptPartyFriends"] == "On" and LeaPlusLC:FriendCheck(arg1)) then
				if not LeaPlusLC:IsInLFGQueue() then
					AcceptGroup();
					for i=1, STATICPOPUP_NUMDIALOGS do
						if _G["StaticPopup"..i].which == "PARTY_INVITE" then
							_G["StaticPopup"..i].inviteAccepted = 1
							StaticPopup_Hide("PARTY_INVITE");
							break
						elseif _G["StaticPopup"..i].which == "PARTY_INVITE_XREALM" then
							_G["StaticPopup"..i].inviteAccepted = 1
							StaticPopup_Hide("PARTY_INVITE_XREALM");
							break
						end
					end
					return
				end
			end

			-- If not a friend and you're blocking invites, decline
			if LeaPlusLC["NoPartyInvites"] == "On" then
				if LeaPlusLC:FriendCheck(arg1) then
					return
				else
					DeclineGroup();
					StaticPopup_Hide("PARTY_INVITE");
					StaticPopup_Hide("PARTY_INVITE_XREALM");
					return
				end
			end

			return
		end

		----------------------------------------------------------------------
		-- Disable loot warnings
		----------------------------------------------------------------------

		-- Disable warnings for attempting to roll Need or Disenchant on loot
		if event == "CONFIRM_LOOT_ROLL" or event == "CONFIRM_DISENCHANT_ROLL" then
			ConfirmLootRoll(arg1, arg2)
			StaticPopup_Hide("CONFIRM_LOOT_ROLL")
			return
		end

		-- Disable warning for attempting to loot a Bind on Pickup item
		if event == "LOOT_BIND_CONFIRM" then
			ConfirmLootSlot(arg1, arg2)
			StaticPopup_Hide("LOOT_BIND",...)
			return
		end

		-- Disable warning for attempting to vendor an item within its refund window
		if event == "MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL" then
			SellCursorItem()
			return
		end

		-- Disable warning for attempting to mail an item within its refund window
		if event == "MAIL_LOCK_SEND_ITEMS" then
			RespondMailLockSendItem(arg1, true)
			return
		end

		----------------------------------------------------------------------
		-- Automatically release in battlegrounds
		----------------------------------------------------------------------

		if event == "PLAYER_DEAD" then

			-- If player has ability to self-resurrect (soulstone, reincarnation, etc), do nothing and quit
			if HasSoulstone() then return end -- HasSoulstone() affects all self-res abilities, returns valid data only while dead

			-- Resurrect if player is in a battleground
			local InstStat, InstType = IsInInstance();
			if InstStat and InstType == "pvp" then
				RepopMe()
				return
			end

			-- Get current location
			SetMapToCurrentZone()
			local areaID = GetCurrentMapAreaID() or 0

			-- Resurrect if player is in Wintergrasp (501)
			if areaID == 501 and LeaPlusLC["AutoRelWintergrasp"] == "On" then 
				RepopMe()
				return
			end

			-- Resurrect if player is in Tol Barad (708)
			if areaID == 708 and LeaPlusLC["AutoRelTolBarad"] == "On" then 
				RepopMe()
				return
			end

			-- Resurrect if player is in Ashran (978), Stormshield (1009) or Warspear (1011)
			if (areaID == 978 or areaID == 1009 or areaID == 1011) and LeaPlusLC["AutoRelAshran"] == "On" then 
				RepopMe()
				return
			end

			return

		end

		----------------------------------------------------------------------
		-- Hide the combat log
		----------------------------------------------------------------------

		if event == "UPDATE_CHAT_WINDOWS" then
			ChatFrame2Tab:EnableMouse(false)
			ChatFrame2Tab:SetText("")
			ChatFrame2Tab:SetScale(0.01)
			ChatFrame2Tab:SetWidth(0.01)
			ChatFrame2Tab:SetHeight(0.01)
		end

		----------------------------------------------------------------------
		-- L72: Profile events
		----------------------------------------------------------------------

		if event == "ADDON_LOADED" then
			if arg1 == "Leatrix_Plus" then

				-- Automation
				LeaPlusLC:LoadVarChk("AutomateQuests", "Off")				-- Automate quests
				LeaPlusLC:LoadVarChk("AutomateGossip", "Off")				-- Automate gossip
				LeaPlusLC:LoadVarNum("AutoGossipMenu", 1, 1, 3)				-- Automate gossip modifier key
				LeaPlusLC:LoadVarChk("AutoAcceptSummon", "Off")				-- Accept summon
				LeaPlusLC:LoadVarChk("AutoAcceptRes", "Off")				-- Accept resurrection
				LeaPlusLC:LoadVarChk("NoAutoResInCombat", "Off")			-- Exclude combat
				LeaPlusLC:LoadVarChk("NoAutoResPylon", "On")				-- Exclude pylon and brazier requests
				LeaPlusLC:LoadVarChk("ResThankYouEmote", "On")				-- Thanks for resurrect

				LeaPlusLC:LoadVarChk("AutoReleasePvP", "Off")				-- Release in PvP
				LeaPlusLC:LoadVarChk("AutoRelBGs", "On")					-- Release in battlegrounds
				LeaPlusLC:LoadVarChk("AutoRelWintergrasp", "On")			-- Release in Wintergrasp
				LeaPlusLC:LoadVarChk("AutoRelTolBarad", "On")				-- Release in Tol Barad
				LeaPlusLC:LoadVarChk("AutoRelAshran", "On")					-- Release in Ashran

				LeaPlusLC:LoadVarChk("AutoSellJunk", "Off")					-- Sell junk automatically
				LeaPlusLC:LoadVarChk("SellJunkSummary", "On")				-- Sell junk summary
				LeaPlusLC:LoadVarChk("AutoRepairOwnFunds", "Off")			-- Repair automatically
				LeaPlusLC:LoadVarChk("AutoRepairGuildFunds", "On")			-- Repair using guild funds
				LeaPlusLC:LoadVarChk("AutoRepairSummary", "On")				-- Repair summary

				-- Social
				LeaPlusLC:LoadVarChk("NoDuelRequests", "Off")				-- Block duels
				LeaPlusLC:LoadVarChk("NoPetDuels", "Off")					-- Block pet battle duels
				LeaPlusLC:LoadVarChk("NoPartyInvites", "Off")				-- Block party invites
				LeaPlusLC:LoadVarChk("NoFriendRequests", "Off")				-- Block friend requests

				LeaPlusLC:LoadVarChk("AcceptPartyFriends", "Off")			-- Party from friends
				LeaPlusLC:LoadVarChk("AutoConfirmRole", "Off")				-- Queue from friends
				LeaPlusLC:LoadVarChk("InviteFromWhisper", "Off")			-- Invite from whispers
				LeaPlusLC["InvKey"]	= LeaPlusDB["InvKey"] or "++"

				-- Chat
				LeaPlusLC:LoadVarChk("UseEasyChatResizing", "On")			-- Use easy resizing
				LeaPlusLC:LoadVarChk("NoCombatLogTab", "Off")				-- Hide the combat log
				LeaPlusLC:LoadVarChk("NoChatButtons", "Off")				-- Hide chat buttons
				LeaPlusLC:LoadVarChk("NoSocialButton", "Off")				-- Hide social button
				LeaPlusLC:LoadVarChk("UnclampChat", "Off")					-- Unclamp chat frame
				LeaPlusLC:LoadVarChk("MoveChatEditBoxToTop", "Off")			-- Move editbox to top

				LeaPlusLC:LoadVarChk("NoStickyChat", "Off")					-- Disable sticky chat
				LeaPlusLC:LoadVarChk("UseArrowKeysInChat", "On")			-- Use arrow keys in chat
				LeaPlusLC:LoadVarChk("NoChatFade", "Off")					-- Disable chat fade
				LeaPlusLC:LoadVarChk("UnivGroupColor", "Off")				-- Universal group color
				LeaPlusLC:LoadVarChk("Manageclasscolors", "On")			-- Use class colors in chat
				LeaPlusLC:LoadVarChk("RecentChatWindow", "Off")				-- Recent chat window
				LeaPlusLC:LoadVarNum("RecentChatSize", 18, 10, 24)			-- Recent chat size
				LeaPlusLC:LoadVarNum("RecentChatAlpha", 0.5, 0, 1)			-- Recent chat alpha
				LeaPlusLC:LoadVarNum("RecentChatWidth", 1, 0.5, 1.5)		-- Recent chat width
				LeaPlusLC:LoadVarNum("RecentChatHeight", 1, 0.5, 1.5)		-- Recent chat height
				LeaPlusLC:LoadVarAnc("RecentChatA", "CENTER")				-- Recent chat location
				LeaPlusLC:LoadVarAnc("RecentChatR", "CENTER")				-- Recent chat location
				LeaPlusLC:LoadVarNum("RecentChatX", 0, -5000, 5000)			-- Recent chat location
				LeaPlusLC:LoadVarNum("RecentChatY", 0, -5000, 5000)			-- Recent chat location
				LeaPlusLC:LoadVarChk("MaxChatHstory", "On")				-- Increase chat history

				-- Text
				LeaPlusLC:LoadVarChk("HideErrorFrameText", "Off")			-- Hide error text
				LeaPlusLC:LoadVarChk("ShowQuestUpdates", "On")				-- Show quest updates
				LeaPlusLC:LoadVarChk("ShowImportantErrors", "On")			-- Show important errors
				LeaPlusLC:LoadVarChk("NoHitIndicators", "Off")				-- Hide portrait text
				LeaPlusLC:LoadVarChk("HideCraftedNames", "Off")				-- Hide crafted names
				LeaPlusLC:LoadVarChk("HideZoneText", "Off")					-- Hide zone text
				LeaPlusLC:LoadVarChk("HideSubzoneText", "Off")				-- Hide subzone text

				LeaPlusLC:LoadVarChk("MailFontChange", "On")				-- Resize mail text
				LeaPlusLC:LoadVarNum("LeaPlusMailFontSize", 18, 10, 36)		-- Mail text slider

				LeaPlusLC:LoadVarChk("QuestFontChange", "On")				-- Resize quest text
				LeaPlusLC:LoadVarNum("LeaPlusQuestFontSize", 18, 10, 36)	-- Quest text slider

				-- Interface
				LeaPlusLC:LoadVarChk("ShowMapMod", "Off")					-- Enhance world map
				LeaPlusLC:LoadVarChk("RevealWorldMap", "On")				-- Reveal world map
				LeaPlusLC:LoadVarChk("ShowRevealBox", "On")					-- Show reveal map checkbox
				LeaPlusLC:LoadVarChk("WorldMapCoords", "On")				-- Show map coordinates
				LeaPlusLC:LoadVarChk("FadeMap", "Off")						-- Fade map while moving
				LeaPlusLC:LoadVarChk("ShowSuramarPortals", "On")			-- Show Suramar portal destinations
				LeaPlusLC:LoadVarChk("ShowDungeonLocs", "On")				-- Show dungeon and raid locations

				LeaPlusLC:LoadVarChk("MinimapMod", "Off")					-- Customise minimap
				LeaPlusLC:LoadVarChk("MergeTrackBtn", "Off")				-- Merge buttons
				LeaPlusLC:LoadVarChk("HideMinimapZone", "Off")				-- Hide zone text
				LeaPlusLC:LoadVarChk("HideMinimapTime", "Off")				-- Hide clock
				LeaPlusLC:LoadVarChk("MinimapMouseZoom", "Off")				-- Mousewheel zoom
				LeaPlusLC:LoadVarNum("MinimapScale", 1.00, 0.50, 2.00)		-- Minimap scale slider

				LeaPlusLC:LoadVarChk("TipModEnable", "Off")					-- Manage tooltip
				LeaPlusLC:LoadVarChk("TipMoveTip", "On")					-- Reposition the tooltip
				LeaPlusLC:LoadVarChk("TipShowRank", "On")					-- Show rank
				LeaPlusLC:LoadVarChk("TipShowTarget", "On")					-- Show target
				LeaPlusLC:LoadVarChk("TipBackSimple", "Off")				-- Color backdrops
				LeaPlusLC:LoadVarChk("TipHideInCombat", "Off")				-- Hide tooltips during combat
				LeaPlusLC:LoadVarNum("LeaPlusTipSize", 1.00, 0.50, 2.00)	-- Tooltip scale slider
				LeaPlusLC:LoadVarNum("TipOffsetX", -13, -5000, 5000)		-- Tooltip X offset
				LeaPlusLC:LoadVarNum("TipOffsetY", 94, -5000, 5000)			-- Tooltip Y offset

				LeaPlusLC:LoadVarChk("EnhanceDressup", "On")				-- Enhance dressup
				LeaPlusLC:LoadVarChk("ShowModelButtons", "On")				-- Show model buttons
				LeaPlusLC:LoadVarChk("NoSpecialModelAnims", "On")			-- Prevent special animations
				LeaPlusLC:LoadVarChk("HideModelControls", "On")				-- Hide model controls
				LeaPlusLC:LoadVarChk("ShowVolume", "On")					-- Show volume slider
				LeaPlusLC:LoadVarChk("ShowVolumeInFrame", "Off")			-- Volume slider dual layout
				LeaPlusLC:LoadVarChk("AhExtras", "Off")						-- Show auction controls
				LeaPlusLC:LoadVarChk("AhBuyoutOnly", "Off")					-- Auction buyout only
				LeaPlusLC:LoadVarChk("AhGoldOnly", "Off")					-- Auction gold only

				LeaPlusLC:LoadVarChk("StaticCoords", "Off")					-- Show coordinates
				LeaPlusLC:LoadVarChk("StaticCoordsEn", "Off")				-- Show coordinates
				LeaPlusLC:LoadVarChk("StaticCoordsBack", "Off")				-- Show background
				LeaPlusLC:LoadVarChk("StaticCoordsTop", "Off")				-- Show on top
				LeaPlusLC:LoadVarChk("StaticCoordsLock", "Off")				-- Lock coordinates
				LeaPlusLC:LoadVarNum("StaticCoordsScale", 1.0, 0.9, 2.0)	-- Coordinates scale slider
				LeaPlusLC:LoadVarAnc("CoordsA", "CENTER")					-- Coordinates anchor
				LeaPlusLC:LoadVarAnc("CoordsR", "CENTER")					-- Coordinates relative
				LeaPlusLC:LoadVarNum("CoordsX", 0, -5000, 5000)				-- Coordinates X axis
				LeaPlusLC:LoadVarNum("CoordsY", 200, -5000, 5000)			-- Coordinates Y axis

				LeaPlusLC:LoadVarChk("ShowCooldowns", "Off")				-- Show cooldowns
				LeaPlusLC:LoadVarChk("CooldownTips", "On")					-- Show cooldown tooltips
				LeaPlusLC:LoadVarChk("ShowCooldownID", "On")				-- Show cooldown ID in tips
				LeaPlusLC:LoadVarChk("NoCooldownDuration", "On")			-- Hide cooldown duration
				LeaPlusLC:LoadVarChk("CooldownsOnPlayer", "Off")			-- Anchor to player
				LeaPlusLC:LoadVarChk("DurabilityStatus", "On")				-- Show durability status
				LeaPlusLC:LoadVarChk("ShowPetSaveBtn", "Off")				-- Show pet save button
				LeaPlusLC:LoadVarChk("ShowWowheadLinks", "Off")				-- Show Wowhead links

				-- Frames
				LeaPlusLC:LoadVarChk("FrmEnabled", "Off")					-- Manage frames
				LeaPlusLC:LoadVarChk("ManageBuffFrame", "Off")				-- Manage buff frame
				LeaPlusLC:LoadVarAnc("BuffFrameA", "TOPRIGHT")				-- Buff frame anchor
				LeaPlusLC:LoadVarAnc("BuffFrameR", "TOPRIGHT")				-- Buff frame relative
				LeaPlusLC:LoadVarNum("BuffFrameX", -205, -5000, 5000) 		-- Buff frame X axis
				LeaPlusLC:LoadVarNum("BuffFrameY", -13, -5000, 5000)		-- Buff frame Y axis
				LeaPlusLC:LoadVarNum("BuffFrameScale", 1, 0.50, 2)			-- Buff frame scale

				LeaPlusLC:LoadVarChk("ClassColFrames", "Off")				-- Class colored frames
				LeaPlusLC:LoadVarChk("ClassColPlayer", "On")				-- Player frame in class color
				LeaPlusLC:LoadVarChk("ClassColTarget", "On")				-- Target frame in class color
				LeaPlusLC:LoadVarChk("ShowPlayerChain", "Off")				-- Show player chain
				LeaPlusLC:LoadVarNum("PlayerChainMenu", 2, 1, 3)			-- Player chain dropdown value
				LeaPlusLC:LoadVarChk("ShowRaidToggle", "Off")				-- Show raid toggle button
				LeaPlusLC:LoadVarChk("CombatPlates", "Off")					-- Combat plates

				LeaPlusLC:LoadVarChk("NoAlerts", "Off")						-- Hide alerts
				LeaPlusLC:LoadVarChk("NoAchieveAlerts", "On")				-- Hide achievement alerts
				LeaPlusLC:LoadVarChk("NoEncounterAlerts", "On")				-- Hide encounter alerts
				LeaPlusLC:LoadVarChk("NoGarrisonAlerts", "On")				-- Hide order hall and garrison alerts
				LeaPlusLC:LoadVarChk("NoLootAlerts", "On")					-- Hide loot alerts
				LeaPlusLC:LoadVarChk("NoProfessionAlerts", "On")			-- Hide profession alerts

				LeaPlusLC:LoadVarChk("HideBodyguard", "Off")				-- Hide bodyguard window
				LeaPlusLC:LoadVarChk("HideTalkingFrame", "Off")				-- Hide talking frame
				LeaPlusLC:LoadVarChk("HideCleanupBtns", "Off")				-- Hide clean-up buttons
				LeaPlusLC:LoadVarChk("HideBossBanner", "Off")				-- Hide boss banner
				LeaPlusLC:LoadVarChk("HideLevelUpDisplay", "Off")			-- Hide level-up display
				LeaPlusLC:LoadVarChk("NoGryphons", "Off")					-- Hide gryphons
				LeaPlusLC:LoadVarChk("NoClassBar", "Off")					-- Hide stance bar
				LeaPlusLC:LoadVarChk("NoCommandBar", "On")					-- Hide order hall bar

				-- System
				LeaPlusLC:LoadVarChk("NoShaders", "Off")					-- Manage effects
				LeaPlusLC:LoadVarChk("NoEffectsGlow", "On")					-- Disable screen glow
				LeaPlusLC:LoadVarChk("NoEffectsDeath", "On")				-- Disable grey screen of death
				LeaPlusLC:LoadVarChk("NoEffectsNether", "On")				-- Disable netherworld effect
				LeaPlusLC:LoadVarChk("MaxCameraZoom", "On")				-- Max camera zoom
				LeaPlusLC:LoadVarChk("ViewPortEnable", "Off")				-- Enable viewport
				LeaPlusLC:LoadVarNum("ViewPortTop", 0, 0, 300)				-- Top border
				LeaPlusLC:LoadVarNum("ViewPortBottom", 0, 0, 300)			-- Bottom border
				LeaPlusLC:LoadVarNum("ViewPortLeft", 0, 0, 300)				-- Left border
				LeaPlusLC:LoadVarNum("ViewPortRight", 0, 0, 300)			-- Right border
				LeaPlusLC:LoadVarNum("ViewPortAlpha", 0, 0, 1)				-- Border alpha
				LeaPlusLC:LoadVarChk("ViewPortResize", "Off")				-- Resize game world

				LeaPlusLC:LoadVarChk("NoRestedEmotes", "Off")				-- Silence rested emotes

				LeaPlusLC:LoadVarChk("NoBagAutomation", "Off")				-- Disable bag automation
				LeaPlusLC:LoadVarChk("NoPetAutomation", "Off")				-- Disable pet automation
				LeaPlusLC:LoadVarChk("CharAddonList", "Off")				-- Show character addons
				LeaPlusLC:LoadVarChk("NoRaidRestrictions", "Off")			-- Remove raid restrictions
				LeaPlusLC:LoadVarChk("NoConfirmLoot", "Off")				-- Disable loot warnings
				LeaPlusLC:LoadVarChk("NoMapEmote", "Off")					-- Disable map emote
				LeaPlusLC:LoadVarChk("SkipCinematics", "Off")				-- Skip cinematics
				LeaPlusLC:LoadVarChk("FasterLooting", "Off")				-- Faster auto loot
				LeaPlusLC:LoadVarChk("LockoutSharing", "Off")				-- Lockout sharing

				-- Settings
				LeaPlusLC:LoadVarChk("ShowMinimapIcon", "On")				-- Show minimap button
				LeaPlusLC:LoadVarNum("MinimapIconPos", -158.1, -180, 180)	-- Minimap button slider
				LeaPlusLC:LoadVarChk("EnableHotkey", "On")					-- Enable hotkey
				LeaPlusLC:LoadVarNum("HotkeyMenu", 1, 1, 4)					-- Leatrix Plus hotkey

				LeaPlusLC:LoadVarNum("PlusPanelScale", 1, 1, 2)				-- Panel scale
				LeaPlusLC:LoadVarNum("PlusPanelAlpha", 0, 0, 1)				-- Panel alpha

				-- Panel position
				LeaPlusLC:LoadVarAnc("MainPanelA", "CENTER")				-- Panel anchor
				LeaPlusLC:LoadVarAnc("MainPanelR", "CENTER")				-- Panel relative
				LeaPlusLC:LoadVarNum("MainPanelX", 0, -5000, 5000)			-- Panel X axis
				LeaPlusLC:LoadVarNum("MainPanelY", 0, -5000, 5000)			-- Panel Y axis

				-- Start page
				LeaPlusLC:LoadVarNum("LeaStartPage", 0, 0, LeaPlusLC["NumberOfPages"])

				-- Run other startup items
				LeaPlusLC:Live()
				LeaPlusLC:Isolated()
				LeaPlusLC:RunOnce()
				LeaPlusLC:SetDim()

			end
			return
		end

		if event == "VARIABLES_LOADED" then
			LeaPlusLC:Variable()
			return
		end

		if event == "PLAYER_ENTERING_WORLD" then
			LeaPlusLC:Player();
			collectgarbage()
			return
		end

		-- Save locals back to globals on logout
		if event == "PLAYER_LOGOUT" then

			-- Run the logout function without wipe flag
			LeaPlusLC:PlayerLogout(false)

			-- Automation
			LeaPlusDB["AutomateQuests"]			= LeaPlusLC["AutomateQuests"]
			LeaPlusDB["AutomateGossip"]			= LeaPlusLC["AutomateGossip"]
			LeaPlusDB["AutoGossipMenu"]			= LeaPlusLC["AutoGossipMenu"]
			LeaPlusDB["AutoAcceptSummon"] 		= LeaPlusLC["AutoAcceptSummon"]
			LeaPlusDB["AutoAcceptRes"] 			= LeaPlusLC["AutoAcceptRes"]
			LeaPlusDB["NoAutoResInCombat"]		= LeaPlusLC["NoAutoResInCombat"]
			LeaPlusDB["NoAutoResPylon"]			= LeaPlusLC["NoAutoResPylon"]
			LeaPlusDB["ResThankYouEmote"]		= LeaPlusLC["ResThankYouEmote"]

			LeaPlusDB["AutoReleasePvP"] 		= LeaPlusLC["AutoReleasePvP"]
			LeaPlusDB["AutoRelBGs"] 			= LeaPlusLC["AutoRelBGs"]
			LeaPlusDB["AutoRelWintergrasp"] 	= LeaPlusLC["AutoRelWintergrasp"]
			LeaPlusDB["AutoRelTolBarad"] 		= LeaPlusLC["AutoRelTolBarad"]
			LeaPlusDB["AutoRelAshran"] 			= LeaPlusLC["AutoRelAshran"]

			LeaPlusDB["AutoSellJunk"] 			= LeaPlusLC["AutoSellJunk"]
			LeaPlusDB["SellJunkSummary"] 		= LeaPlusLC["SellJunkSummary"]
			LeaPlusDB["AutoRepairOwnFunds"] 	= LeaPlusLC["AutoRepairOwnFunds"]
			LeaPlusDB["AutoRepairGuildFunds"] 	= LeaPlusLC["AutoRepairGuildFunds"]
			LeaPlusDB["AutoRepairSummary"] 		= LeaPlusLC["AutoRepairSummary"]

			-- Social
			LeaPlusDB["NoDuelRequests"] 		= LeaPlusLC["NoDuelRequests"]
			LeaPlusDB["NoPetDuels"] 			= LeaPlusLC["NoPetDuels"]
			LeaPlusDB["NoPartyInvites"]			= LeaPlusLC["NoPartyInvites"]
			LeaPlusDB["NoFriendRequests"]		= LeaPlusLC["NoFriendRequests"]

			LeaPlusDB["AcceptPartyFriends"]		= LeaPlusLC["AcceptPartyFriends"]
			LeaPlusDB["AutoConfirmRole"]		= LeaPlusLC["AutoConfirmRole"]
			LeaPlusDB["InviteFromWhisper"]		= LeaPlusLC["InviteFromWhisper"]
			LeaPlusDB["InvKey"]					= LeaPlusLC["InvKey"]

			-- Chat
			LeaPlusDB["UseEasyChatResizing"]	= LeaPlusLC["UseEasyChatResizing"]
			LeaPlusDB["NoCombatLogTab"]			= LeaPlusLC["NoCombatLogTab"]
			LeaPlusDB["NoChatButtons"]			= LeaPlusLC["NoChatButtons"]
			LeaPlusDB["NoSocialButton"]			= LeaPlusLC["NoSocialButton"]
			LeaPlusDB["UnclampChat"]			= LeaPlusLC["UnclampChat"]
			LeaPlusDB["MoveChatEditBoxToTop"]	= LeaPlusLC["MoveChatEditBoxToTop"]

			LeaPlusDB["NoStickyChat"] 			= LeaPlusLC["NoStickyChat"]
			LeaPlusDB["UseArrowKeysInChat"]		= LeaPlusLC["UseArrowKeysInChat"]
			LeaPlusDB["NoChatFade"]				= LeaPlusLC["NoChatFade"]
			LeaPlusDB["UnivGroupColor"]			= LeaPlusLC["UnivGroupColor"]
			LeaPlusDB["Manageclasscolors"]		= LeaPlusLC["Manageclasscolors"]
			LeaPlusDB["RecentChatWindow"]		= LeaPlusLC["RecentChatWindow"]
			LeaPlusDB["RecentChatSize"]			= LeaPlusLC["RecentChatSize"]
			LeaPlusDB["RecentChatAlpha"]		= LeaPlusLC["RecentChatAlpha"]
			LeaPlusDB["RecentChatWidth"]		= LeaPlusLC["RecentChatWidth"]
			LeaPlusDB["RecentChatHeight"]		= LeaPlusLC["RecentChatHeight"]
			LeaPlusDB["RecentChatA"]			= LeaPlusLC["RecentChatA"]
			LeaPlusDB["RecentChatR"]			= LeaPlusLC["RecentChatR"]
			LeaPlusDB["RecentChatX"]			= LeaPlusLC["RecentChatX"]
			LeaPlusDB["RecentChatY"]			= LeaPlusLC["RecentChatY"]
			LeaPlusDB["MaxChatHstory"]			= LeaPlusLC["MaxChatHstory"]

			-- Text
			LeaPlusDB["HideErrorFrameText"]		= LeaPlusLC["HideErrorFrameText"]
			LeaPlusDB["ShowQuestUpdates"]		= LeaPlusLC["ShowQuestUpdates"]
			LeaPlusDB["ShowImportantErrors"]	= LeaPlusLC["ShowImportantErrors"]
			LeaPlusDB["NoHitIndicators"]		= LeaPlusLC["NoHitIndicators"]
			LeaPlusDB["HideCraftedNames"] 		= LeaPlusLC["HideCraftedNames"]
			LeaPlusDB["HideZoneText"] 			= LeaPlusLC["HideZoneText"]
			LeaPlusDB["HideSubzoneText"] 		= LeaPlusLC["HideSubzoneText"]

			LeaPlusDB["MailFontChange"] 		= LeaPlusLC["MailFontChange"]
			LeaPlusDB["LeaPlusMailFontSize"] 	= LeaPlusLC["LeaPlusMailFontSize"]

			LeaPlusDB["QuestFontChange"] 		= LeaPlusLC["QuestFontChange"]
			LeaPlusDB["LeaPlusQuestFontSize"]	= LeaPlusLC["LeaPlusQuestFontSize"]

			-- Interface
			LeaPlusDB["ShowMapMod"] 			= LeaPlusLC["ShowMapMod"]
			LeaPlusDB["RevealWorldMap"] 		= LeaPlusLC["RevealWorldMap"]
			LeaPlusDB["ShowRevealBox"] 			= LeaPlusLC["ShowRevealBox"]
			LeaPlusDB["WorldMapCoords"] 		= LeaPlusLC["WorldMapCoords"]
			LeaPlusDB["FadeMap"] 				= LeaPlusLC["FadeMap"]
			LeaPlusDB["ShowSuramarPortals"] 	= LeaPlusLC["ShowSuramarPortals"]
			LeaPlusDB["ShowDungeonLocs"] 		= LeaPlusLC["ShowDungeonLocs"]

			LeaPlusDB["MinimapMod"]				= LeaPlusLC["MinimapMod"]
			LeaPlusDB["MergeTrackBtn"]			= LeaPlusLC["MergeTrackBtn"]
			LeaPlusDB["HideMinimapZone"]		= LeaPlusLC["HideMinimapZone"]
			LeaPlusDB["HideMinimapTime"]		= LeaPlusLC["HideMinimapTime"]
			LeaPlusDB["MinimapMouseZoom"]		= LeaPlusLC["MinimapMouseZoom"]
			LeaPlusDB["MinimapScale"]			= LeaPlusLC["MinimapScale"]

			LeaPlusDB["TipModEnable"]			= LeaPlusLC["TipModEnable"]
			LeaPlusDB["TipMoveTip"]				= LeaPlusLC["TipMoveTip"]
			LeaPlusDB["TipShowRank"]			= LeaPlusLC["TipShowRank"]
			LeaPlusDB["TipShowTarget"]			= LeaPlusLC["TipShowTarget"]
			LeaPlusDB["TipBackSimple"]			= LeaPlusLC["TipBackSimple"]
			LeaPlusDB["TipHideInCombat"]		= LeaPlusLC["TipHideInCombat"]
			LeaPlusDB["LeaPlusTipSize"]			= LeaPlusLC["LeaPlusTipSize"]
			LeaPlusDB["TipOffsetX"]				= LeaPlusLC["TipOffsetX"]
			LeaPlusDB["TipOffsetY"]				= LeaPlusLC["TipOffsetY"]

			LeaPlusDB["EnhanceDressup"]			= LeaPlusLC["EnhanceDressup"]
			LeaPlusDB["ShowModelButtons"]		= LeaPlusLC["ShowModelButtons"]
			LeaPlusDB["NoSpecialModelAnims"]	= LeaPlusLC["NoSpecialModelAnims"]
			LeaPlusDB["HideModelControls"]		= LeaPlusLC["HideModelControls"]
			LeaPlusDB["ShowVolume"] 			= LeaPlusLC["ShowVolume"]
			LeaPlusDB["ShowVolumeInFrame"] 		= LeaPlusLC["ShowVolumeInFrame"]
			LeaPlusDB["AhExtras"]				= LeaPlusLC["AhExtras"]
			LeaPlusDB["AhBuyoutOnly"]			= LeaPlusLC["AhBuyoutOnly"]
			LeaPlusDB["AhGoldOnly"]				= LeaPlusLC["AhGoldOnly"]

			LeaPlusDB["StaticCoords"] 			= LeaPlusLC["StaticCoords"]
			LeaPlusDB["StaticCoordsEn"] 		= LeaPlusLC["StaticCoordsEn"]
			LeaPlusDB["StaticCoordsBack"] 		= LeaPlusLC["StaticCoordsBack"]
			LeaPlusDB["StaticCoordsTop"] 		= LeaPlusLC["StaticCoordsTop"]
			LeaPlusDB["StaticCoordsLock"] 		= LeaPlusLC["StaticCoordsLock"]
			LeaPlusDB["StaticCoordsScale"] 		= LeaPlusLC["StaticCoordsScale"]
			LeaPlusDB["CoordsA"] 				= LeaPlusLC["CoordsA"]
			LeaPlusDB["CoordsR"] 				= LeaPlusLC["CoordsR"]
			LeaPlusDB["CoordsX"] 				= LeaPlusLC["CoordsX"]
			LeaPlusDB["CoordsY"] 				= LeaPlusLC["CoordsY"]

			LeaPlusDB["ShowCooldowns"]			= LeaPlusLC["ShowCooldowns"]
			LeaPlusDB["CooldownTips"]			= LeaPlusLC["CooldownTips"]
			LeaPlusDB["ShowCooldownID"]			= LeaPlusLC["ShowCooldownID"]
			LeaPlusDB["NoCooldownDuration"]		= LeaPlusLC["NoCooldownDuration"]
			LeaPlusDB["CooldownsOnPlayer"]		= LeaPlusLC["CooldownsOnPlayer"]
			LeaPlusDB["DurabilityStatus"]		= LeaPlusLC["DurabilityStatus"]
			LeaPlusDB["ShowPetSaveBtn"]			= LeaPlusLC["ShowPetSaveBtn"]
			LeaPlusDB["ShowWowheadLinks"]		= LeaPlusLC["ShowWowheadLinks"]

			-- Frames
			LeaPlusDB["FrmEnabled"]				= LeaPlusLC["FrmEnabled"]
			LeaPlusDB["ManageBuffFrame"]		= LeaPlusLC["ManageBuffFrame"]
			LeaPlusDB["BuffFrameA"]				= LeaPlusLC["BuffFrameA"]
			LeaPlusDB["BuffFrameR"]				= LeaPlusLC["BuffFrameR"]
			LeaPlusDB["BuffFrameX"]				= LeaPlusLC["BuffFrameX"]
			LeaPlusDB["BuffFrameY"]				= LeaPlusLC["BuffFrameY"]
			LeaPlusDB["BuffFrameScale"]			= LeaPlusLC["BuffFrameScale"]

			LeaPlusDB["ClassColFrames"]			= LeaPlusLC["ClassColFrames"]
			LeaPlusDB["ClassColPlayer"]			= LeaPlusLC["ClassColPlayer"]
			LeaPlusDB["ClassColTarget"]			= LeaPlusLC["ClassColTarget"]
			LeaPlusDB["ShowPlayerChain"]		= LeaPlusLC["ShowPlayerChain"]
			LeaPlusDB["PlayerChainMenu"]		= LeaPlusLC["PlayerChainMenu"]
			LeaPlusDB["ShowRaidToggle"]			= LeaPlusLC["ShowRaidToggle"]
			LeaPlusDB["CombatPlates"]			= LeaPlusLC["CombatPlates"]

			LeaPlusDB["NoAlerts"]				= LeaPlusLC["NoAlerts"]
			LeaPlusDB["NoAchieveAlerts"]		= LeaPlusLC["NoAchieveAlerts"]
			LeaPlusDB["NoEncounterAlerts"]		= LeaPlusLC["NoEncounterAlerts"]
			LeaPlusDB["NoGarrisonAlerts"]		= LeaPlusLC["NoGarrisonAlerts"]
			LeaPlusDB["NoLootAlerts"]			= LeaPlusLC["NoLootAlerts"]
			LeaPlusDB["NoProfessionAlerts"]		= LeaPlusLC["NoProfessionAlerts"]

			LeaPlusDB["NoCharControls"]			= LeaPlusLC["NoCharControls"]
			LeaPlusDB["HideBodyguard"]			= LeaPlusLC["HideBodyguard"]
			LeaPlusDB["HideTalkingFrame"]		= LeaPlusLC["HideTalkingFrame"]
			LeaPlusDB["HideCleanupBtns"]		= LeaPlusLC["HideCleanupBtns"]
			LeaPlusDB["HideBossBanner"]			= LeaPlusLC["HideBossBanner"]
			LeaPlusDB["HideLevelUpDisplay"]		= LeaPlusLC["HideLevelUpDisplay"]
			LeaPlusDB["NoGryphons"]				= LeaPlusLC["NoGryphons"]
			LeaPlusDB["NoClassBar"]				= LeaPlusLC["NoClassBar"]
			LeaPlusDB["NoCommandBar"]			= LeaPlusLC["NoCommandBar"]

			-- System
			LeaPlusDB["NoShaders"] 				= LeaPlusLC["NoShaders"]
			LeaPlusDB["NoEffectsGlow"] 			= LeaPlusLC["NoEffectsGlow"]
			LeaPlusDB["NoEffectsDeath"] 		= LeaPlusLC["NoEffectsDeath"]
			LeaPlusDB["NoEffectsNether"] 		= LeaPlusLC["NoEffectsNether"]
			LeaPlusDB["MaxCameraZoom"] 			= LeaPlusLC["MaxCameraZoom"]
			LeaPlusDB["ViewPortEnable"]			= LeaPlusLC["ViewPortEnable"]
			LeaPlusDB["ViewPortTop"]			= LeaPlusLC["ViewPortTop"]
			LeaPlusDB["ViewPortBottom"]			= LeaPlusLC["ViewPortBottom"]
			LeaPlusDB["ViewPortLeft"]			= LeaPlusLC["ViewPortLeft"]
			LeaPlusDB["ViewPortRight"]			= LeaPlusLC["ViewPortRight"]
			LeaPlusDB["ViewPortAlpha"]			= LeaPlusLC["ViewPortAlpha"]
			LeaPlusDB["ViewPortResize"]			= LeaPlusLC["ViewPortResize"]

			LeaPlusDB["NoRestedEmotes"]			= LeaPlusLC["NoRestedEmotes"]

			LeaPlusDB["NoBagAutomation"]		= LeaPlusLC["NoBagAutomation"]
			LeaPlusDB["NoPetAutomation"]		= LeaPlusLC["NoPetAutomation"]
			LeaPlusDB["CharAddonList"]			= LeaPlusLC["CharAddonList"]
			LeaPlusDB["NoRaidRestrictions"]		= LeaPlusLC["NoRaidRestrictions"]
			LeaPlusDB["NoConfirmLoot"] 			= LeaPlusLC["NoConfirmLoot"]
			LeaPlusDB["NoMapEmote"] 			= LeaPlusLC["NoMapEmote"]
			LeaPlusDB["SkipCinematics"] 		= LeaPlusLC["SkipCinematics"]
			LeaPlusDB["FasterLooting"] 			= LeaPlusLC["FasterLooting"]
			LeaPlusDB["LockoutSharing"] 		= LeaPlusLC["LockoutSharing"]

			-- Settings
			LeaPlusDB["ShowMinimapIcon"] 		= LeaPlusLC["ShowMinimapIcon"]
			LeaPlusDB["MinimapIconPos"] 		= LeaPlusLC["MinimapIconPos"]
			LeaPlusDB["EnableHotkey"] 			= LeaPlusLC["EnableHotkey"]
			LeaPlusDB["HotkeyMenu"] 			= LeaPlusLC["HotkeyMenu"]

			LeaPlusDB["PlusPanelScale"] 		= LeaPlusLC["PlusPanelScale"]
			LeaPlusDB["PlusPanelAlpha"] 		= LeaPlusLC["PlusPanelAlpha"]

			-- Panel position
			LeaPlusDB["MainPanelA"]				= LeaPlusLC["MainPanelA"]
			LeaPlusDB["MainPanelR"]				= LeaPlusLC["MainPanelR"]
			LeaPlusDB["MainPanelX"]				= LeaPlusLC["MainPanelX"]
			LeaPlusDB["MainPanelY"]				= LeaPlusLC["MainPanelY"]

			-- Start page
			LeaPlusDB["LeaStartPage"]			= LeaPlusLC["LeaStartPage"]

		end

	end

--	Register event handler
	LpEvt:SetScript("OnEvent", eventHandler);

----------------------------------------------------------------------
--	L74: Player logout
----------------------------------------------------------------------

	-- Player Logout
	function LeaPlusLC:PlayerLogout(wipe)

		----------------------------------------------------------------------
		-- Restore default values if options were unchecked or wiped
		----------------------------------------------------------------------

		-- Use class colors
		if LeaPlusDB["Manageclasscolors"] == "On" then
			if wipe or (not wipe and LeaPlusLC["Manageclasscolors"] == "Off") then
				-- Restore local channel color
				for i = 1, 18 do
					if _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"] then
						ToggleChatColorNamesByClassGroup(false, _G["ChatConfigChatSettingsLeftCheckBox" .. i .. "Check"]:GetParent().type);
					end
				end
				-- Restore global channel color
				for i = 1, 50 do
					ToggleChatColorNamesByClassGroup(false, "CHANNEL"..i)
				end
			end
		end

		-- Silence rested emotes
		if LeaPlusDB["NoRestedEmotes"] == "On" then
			if wipe or (not wipe and LeaPlusLC["NoRestedEmotes"] == "Off") then
				SetCVar("Sound_EnableEmoteSounds", "1")
			end
		end

		-- Max camera zoom
		if LeaPlusDB["MaxCameraZoom"] == "On" then
			if wipe or (not wipe and LeaPlusLC["MaxCameraZoom"] == "Off") then
				SetCVar("cameraDistanceMaxZoomFactor", 1.9)
			end
		end

		-- Set map fade
		if LeaPlusDB["ShowMapMod"] == "On" then
			if wipe or (not wipe and LeaPlusLC["FadeMap"] == "Off") then
				SetCVar("mapFade", "1")
			end
		end

		-- Manage effects
		if LeaPlusDB["NoShaders"] == "On" then
			if wipe or (not wipe and LeaPlusLC["NoShaders"] == "Off") then
				SetCVar("ffxGlow", "1")
				SetCVar("ffxDeath", "1")
				SetCVar("ffxNether", "1")
			end
		end

		-- Universal group color
		if LeaPlusDB["UnivGroupColor"] == "On" then
			if wipe or (not wipe and LeaPlusLC["UnivGroupColor"] == "Off") then
				ChangeChatColor("RAID", 1, 0.50, 0)
				ChangeChatColor("RAID_LEADER", 1, 0.28, 0.04)
				ChangeChatColor("INSTANCE_CHAT", 1, 0.50, 0)
				ChangeChatColor("INSTANCE_CHAT_LEADER", 1, 0.28, 0.04)
			end
		end

		----------------------------------------------------------------------
		-- Do other stuff during logout
		----------------------------------------------------------------------

		-- Prevent frame caching if frame customisation is enabled
		if LeaPlusDB["FrmEnabled"] == "On" then
			PlayerFrame:SetUserPlaced(false)
			TargetFrame:SetUserPlaced(false)
		end

		-- Store the auction house duration and price type values if auction house option is enabled
		if LeaPlusDB["AhExtras"] == "On" then
			if AuctionFrameAuctions then
				if AuctionFrameAuctions.duration then
					LeaPlusDB["AHDuration"] = AuctionFrameAuctions.duration
				end
				if AuctionFrameAuctions.priceType then
					LeaPlusDB["AHPriceType"] = AuctionFrameAuctions.priceType
				end
			end
		end

	end

----------------------------------------------------------------------
-- 	Options panel functions
----------------------------------------------------------------------

	-- Function to add textures to panels
	function LeaPlusLC:CreateBar(name, parent, width, height, anchor, r, g, b, alp, tex)
		local ft = parent:CreateTexture(nil, "BORDER")
		ft:SetTexture(tex)
		ft:SetSize(width, height)  
		ft:SetPoint(anchor)
		ft:SetVertexColor(r ,g, b, alp)
		if name == "MainTexture" then
			ft:SetTexCoord(0.09, 1, 0, 1);
		end
	end

	-- Create a configuration panel
	function LeaPlusLC:CreatePanel(title, globref)

		-- Create the panel
		local Side = CreateFrame("Frame", nil, UIParent)

		-- Make it a system frame
		_G["LeaPlusGlobalPanel_" .. globref] = Side
		table.insert(UISpecialFrames, "LeaPlusGlobalPanel_" .. globref)

		-- Store it in the configuration panel table
		tinsert(LeaConfigList, Side)

		-- Set frame parameters
		Side:Hide();
		Side:SetSize(570, 370); 
		Side:SetClampedToScreen(false);
		Side:SetFrameStrata("FULLSCREEN_DIALOG")

		-- Set the background color
		Side.t = Side:CreateTexture(nil, "BACKGROUND")
		Side.t:SetAllPoints()
		Side.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add a close Button
		Side.c = CreateFrame("Button", nil, Side, "UIPanelCloseButton") 
		Side.c:SetSize(30, 30)
		Side.c:SetPoint("TOPRIGHT", 0, 0)
		Side.c:SetScript("OnClick", function() Side:Hide() end)

		-- Add reset, help and back buttons
		Side.r = LeaPlusLC:CreateButton("ResetButton", Side, "Reset", "TOPLEFT", 16, -292, 0, 25, true, "Click to reset the settings on this page.")
		Side.h = LeaPlusLC:CreateButton("HelpButton", Side, "Help", "TOPLEFT", 76, -292, 0, 25, true, "No help is available for this page.")
		Side.b = LeaPlusLC:CreateButton("BackButton", Side, "Back to Main Menu", "TOPRIGHT", -16, -292, 0, 25, true, "Click to return to the main menu.")

		-- Reposition help button so it doesn't overlap reset button
		Side.h:ClearAllPoints()
		Side.h:SetPoint("LEFT", Side.r, "RIGHT", 10, 0)

		-- Remove the click texture from the help button
		Side.h:SetPushedTextOffset(0, 0)

		-- Add a reload button and syncronise it with the main panel reload button
		local reloadb = LeaPlusLC:CreateButton("ConfigReload", Side, "Reload", "BOTTOMRIGHT", -16, 10, 0, 25, true, LeaPlusCB["ReloadUIButton"].tiptext)
		LeaPlusLC:LockItem(reloadb,true)
		reloadb:SetScript("OnClick", ReloadUI)

		reloadb.f = reloadb:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		reloadb.f:SetHeight(32);
		reloadb.f:SetPoint('RIGHT', reloadb, 'LEFT', -10, 0)
		reloadb.f:SetText(LeaPlusCB["ReloadUIButton"].f:GetText())
		reloadb.f:Hide()

		LeaPlusCB["ReloadUIButton"]:HookScript("OnEnable", function()
			LeaPlusLC:LockItem(reloadb, false)
			reloadb.f:Show()
		end)

		LeaPlusCB["ReloadUIButton"]:HookScript("OnDisable", function()
			LeaPlusLC:LockItem(reloadb, true)
			reloadb.f:Hide()
		end)

		-- Set textures
		LeaPlusLC:CreateBar("FootTexture", Side, 570, 48, "BOTTOM", 0.5, 0.5, 0.5, 1.0, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaPlusLC:CreateBar("MainTexture", Side, 570, 323, "TOPRIGHT", 0.7, 0.7, 0.7, 0.7,  "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")

		-- Allow movement
		Side:EnableMouse(true)
		Side:SetMovable(true)
		Side:RegisterForDrag("LeftButton")
		Side:SetScript("OnDragStart", Side.StartMoving)
		Side:SetScript("OnDragStop", function ()
			Side:StopMovingOrSizing();
			Side:SetUserPlaced(false);
			-- Save panel position
			LeaPlusLC["MainPanelA"], void, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = Side:GetPoint()
		end)

		-- Set panel attributes when shown
		Side:SetScript("OnShow", function()
			Side:ClearAllPoints()
			Side:SetPoint(LeaPlusLC["MainPanelA"], UIParent, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"])
			Side:SetScale(LeaPlusLC["PlusPanelScale"])
			Side.t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
		end)

		-- Add title
		Side.f = Side:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		Side.f:SetPoint('TOPLEFT', 16, -16);
		Side.f:SetText(L[title])

		-- Add description
		Side.v = Side:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		Side.v:SetHeight(32);
		Side.v:SetPoint('TOPLEFT', Side.f, 'BOTTOMLEFT', 0, -8); 
		Side.v:SetPoint('RIGHT', Side, -32, 0)
		Side.v:SetJustifyH('LEFT'); Side.v:SetJustifyV('TOP');
		Side.v:SetText(L["Configuration Panel"])
	
		-- Prevent options panel from showing while side panel is showing
		LeaPlusLC["PageF"]:HookScript("OnShow", function()
			if Side:IsShown() then LeaPlusLC["PageF"]:Hide(); end
		end)

		-- Return the frame
		return Side

	end

	-- Define subheadings
	function LeaPlusLC:MakeTx(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
	end

	-- Define text
	function LeaPlusLC:MakeWD(frame, title, x, y)
		local text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
		text:SetJustifyH"LEFT";
	end

	-- Create a slider control (uses standard template)
	function LeaPlusLC:MakeSL(frame, field, caption, low, high, step, x, y, form)

		-- Create slider control
		local Slider = CreateFrame("Slider", "LeaPlusGlobalSlider" .. field, frame, "OptionssliderTemplate")
		LeaPlusCB[field] = Slider;
		Slider:SetMinMaxValues(low, high)
		Slider:SetValueStep(step)
		Slider:EnableMouseWheel(true)
		Slider:SetPoint('TOPLEFT', x,y)
		Slider:SetWidth(100)
		Slider:SetHeight(20)
		Slider:SetHitRectInsets(0, 0, 0, 0);

		-- Remove slider text
		_G[Slider:GetName().."Low"]:SetText('');
		_G[Slider:GetName().."High"]:SetText('');

		-- Create slider label
		Slider.f = Slider:CreateFontString(nil, 'BACKGROUND')
		Slider.f:SetFontObject('GameFontHighlight')
		Slider.f:SetPoint('LEFT', Slider, 'RIGHT', 12, 0)
		Slider.f:SetFormattedText("%.2f", Slider:GetValue())

		-- Process mousewheel scrolling
		Slider:SetScript("OnMouseWheel", function(self, arg1)
			if Slider:IsEnabled() then
				local step = step * arg1
				local value = self:GetValue()
				if step > 0 then
					self:SetValue(min(value + step, high))
				else
					self:SetValue(max(value + step, low))
				end
			end
		end)

		-- Process value changed
		Slider:SetScript("OnValueChanged", function(self, value)
			local value = floor((value - low) / step + 0.5) * step + low
			Slider.f:SetFormattedText(form, value)
			LeaPlusLC[field] = value
		end)

		-- Set slider value when shown
		Slider:SetScript("OnShow", function(self)
			self:SetValue(LeaPlusLC[field])
		end)

	end

	-- Create a checkbox control (uses standard template)
	function LeaPlusLC:MakeCB(parent, field, caption, x, y, reload, tip, tipstyle)

		-- Create the checkbox
		local Cbox = CreateFrame('CheckButton', nil, parent, "ChatConfigCheckButtonTemplate")
		LeaPlusCB[field] = Cbox
		Cbox:SetPoint("TOPLEFT",x, y)
		Cbox:SetScript("OnEnter", LeaPlusLC.TipSee)
		Cbox:SetScript("OnLeave", GameTooltip_Hide)

		-- Add label and tooltip
		Cbox.f = Cbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		Cbox.f:SetPoint('LEFT', 20, 0)
		if reload then
			-- Checkbox requires UI reload
			Cbox.f:SetText(L[caption] .. "*")
			Cbox.tiptext = L[tip] .. "|n|n* " .. L["Requires UI reload."]
		else
			-- Checkbox dot not require UI reload
			Cbox.f:SetText(L[caption])
			Cbox.tiptext = L[tip]
		end

		-- Set label parameters
		Cbox.f:SetJustifyH("LEFT")
		Cbox.f:SetWordWrap(false)

		-- Set maximum label width
		if parent:GetParent() == LeaPlusLC["PageF"] then
			-- Main panel checkbox labels
			if Cbox.f:GetWidth() > 152 then
				Cbox.f:SetWidth(152)
				LeaPlusLC["TruncatedLabelsList"] = LeaPlusLC["TruncatedLabelsList"] or {}
				LeaPlusLC["TruncatedLabelsList"][Cbox.f] = L[caption]
			end
		else
			-- Configuration panel checkbox labels (other checkboxes either have custom functions or blank labels)
			if Cbox.f:GetWidth() > 302 then
				Cbox.f:SetWidth(302)
				LeaPlusLC["TruncatedLabelsList"] = LeaPlusLC["TruncatedLabelsList"] or {}
				LeaPlusLC["TruncatedLabelsList"][Cbox.f] = L[caption]
			end
		end

		-- Set default checkbox state and click area
		Cbox:SetScript('OnShow', function(self)
			if LeaPlusLC[field] == "On" then
				self:SetChecked(true)
			else
				self:SetChecked(false)
			end
			Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 10, 0, 0);
		end)

		-- Process clicks
		Cbox:SetScript('OnClick', function()
			if Cbox:GetChecked() then
				LeaPlusLC[field] = "On"
			else
				LeaPlusLC[field] = "Off"
			end
			LeaPlusLC:SetDim(); -- Lock invalid options
			LeaPlusLC:ReloadCheck(); -- Show reload button if needed
			LeaPlusLC:Live(); -- Run live code
		end)
	end

	-- Create an editbox (uses standard template)
	function LeaPlusLC:CreateEditBox(frame, parent, width, maxchars, anchor, x, y, tab, shifttab)

		-- Create editbox
        local eb = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
		LeaPlusCB[frame] = eb
		eb:SetPoint(anchor, x, y)
		eb:SetWidth(width)
		eb:SetHeight(24)
		eb:SetFontObject("GameFontNormal")
		eb:SetTextColor(1.0, 1.0, 1.0)
		eb:SetAutoFocus(false) 
		eb:SetMaxLetters(maxchars) 
		eb:SetScript("OnEscapePressed", eb.ClearFocus)
		eb:SetScript("OnEnterPressed", eb.ClearFocus)

		-- Add editbox border and backdrop
		eb.f = CreateFrame("FRAME", nil, eb)
		eb.f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = false, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		eb.f:SetPoint("LEFT", -6, 0)
		eb.f:SetWidth(eb:GetWidth()+6)
		eb.f:SetHeight(eb:GetHeight())
		eb.f:SetBackdropColor(1.0, 1.0, 1.0, 0.3)

		-- Move onto next editbox when tab key is pressed
		eb:SetScript("OnTabPressed", function(self)
			self:ClearFocus()
			if IsShiftKeyDown() then
				LeaPlusCB[shifttab]:SetFocus()
			else
				LeaPlusCB[tab]:SetFocus()
			end
		end)

		return eb

	end

	-- Create a standard button (using standard button template)
	function LeaPlusLC:CreateButton(name, frame, label, anchor, x, y, width, height, reskin, tip)
		local mbtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		LeaPlusCB[name] = mbtn
		mbtn:SetSize(width, height)
		mbtn:SetPoint(anchor, x, y)
		mbtn:SetHitRectInsets(0, 0, 0, 0)
		mbtn:SetText(L[label])

		-- Create fontstring so the button can be sized correctly
		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetText(L[label])
		if width > 0 then
			-- Button should have static width
			mbtn:SetWidth(width)
		else
			-- Button should have variable width
			mbtn:SetWidth(mbtn.f:GetStringWidth() + 20)
		end

		-- Tooltip handler
		mbtn.tiptext = L[tip]
		mbtn:SetScript("OnEnter", LeaPlusLC.TipSee)
		mbtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Texture the button
		if reskin then

			-- Set skinned button textures
			mbtn:SetNormalTexture("Interface\\AddOns\\Leatrix_Plus\\Leatrix_Plus.blp")
			mbtn:GetNormalTexture():SetTexCoord(0.5, 1, 0, 1)
			mbtn:SetHighlightTexture("Interface\\AddOns\\Leatrix_Plus\\Leatrix_Plus.blp")
			mbtn:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 1)

			-- Hide the default textures
			mbtn:HookScript("OnShow", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnEnable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnDisable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnMouseDown", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
			mbtn:HookScript("OnMouseUp", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)

		end

		return mbtn
	end

	-- Create a dropdown menu (using custom function to avoid taint)
	function LeaPlusLC:CreateDropDown(ddname, label, parent, width, anchor, x, y, items, tip)

		-- Add the dropdown name to a table
		tinsert(LeaDropList, ddname)

		-- Populate variable with item list
		LeaPlusLC[ddname.."Table"] = items

		-- Create outer frame
		local frame = CreateFrame("FRAME", nil, parent); frame:SetWidth(width); frame:SetHeight(42); frame:SetPoint("BOTTOMLEFT", parent, anchor, x, y);

		-- Create dropdown inside outer frame
		local dd = CreateFrame("Frame", nil, frame); dd:SetPoint("BOTTOMLEFT", -16, -8); dd:SetPoint("BOTTOMRIGHT", 15, -4); dd:SetHeight(32);

		-- Create dropdown textures
		local lt = dd:CreateTexture(nil, "ARTWORK"); lt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); lt:SetTexCoord(0, 0.1953125, 0, 1); lt:SetPoint("TOPLEFT", dd, 0, 17); lt:SetWidth(25); lt:SetHeight(64); 
		local rt = dd:CreateTexture(nil, "BORDER"); rt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); rt:SetTexCoord(0.8046875, 1, 0, 1); rt:SetPoint("TOPRIGHT", dd, 0, 17); rt:SetWidth(25); rt:SetHeight(64); 
		local mt = dd:CreateTexture(nil, "BORDER"); mt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); mt:SetTexCoord(0.1953125, 0.8046875, 0, 1); mt:SetPoint("LEFT", lt, "RIGHT"); mt:SetPoint("RIGHT", rt, "LEFT"); mt:SetHeight(64);

		-- Create dropdown label
		local lf = dd:CreateFontString(nil, "OVERLAY", "GameFontNormal"); lf:SetPoint("TOPLEFT", frame, 0, 0); lf:SetPoint("TOPRIGHT", frame, -5, 0); lf:SetJustifyH("LEFT"); lf:SetText(L[label])
	
		-- Create dropdown placeholder for value (set it using OnShow)
		local value = dd:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		value:SetPoint("LEFT", lt, 26, 2); value:SetPoint("RIGHT", rt, -43, 0); value:SetJustifyH("LEFT")
		dd:SetScript("OnShow", function() value:SetText(LeaPlusLC[ddname.."Table"][LeaPlusLC[ddname]]) end)

		-- Create dropdown button (clicking it opens the dropdown list)
		local dbtn = CreateFrame("Button", nil, dd)
		dbtn:SetPoint("TOPRIGHT", rt, -16, -18); dbtn:SetWidth(24); dbtn:SetHeight(24)
		dbtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up"); dbtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down"); dbtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled"); dbtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight"); dbtn:GetHighlightTexture():SetBlendMode("ADD")
		dbtn.tiptext = tip; dbtn:SetScript("OnEnter", LeaPlusLC.ShowTooltip); 
		dbtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Create dropdown list
		local ddlist =  CreateFrame("Frame",nil,frame);
		LeaPlusCB["ListFrame"..ddname] = ddlist;
		ddlist:SetPoint("TOP",0,-42);
		ddlist:SetWidth(frame:GetWidth());
		ddlist:SetHeight((#items * 17) + 17 + 17);
		ddlist:SetFrameStrata("FULLSCREEN_DIALOG");
		ddlist:SetFrameLevel(12);
		ddlist:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 0, edgeSize = 32, insets = { left = 4, right = 4, top = 4, bottom = 4 }});
		ddlist:Hide();

		-- Hide list if parent is closed
		parent:HookScript("OnHide", function() ddlist:Hide() end)

		-- Create checkmark (it marks the currently selected item)
		local ddlistchk = CreateFrame("FRAME", nil, ddlist)
		ddlistchk:SetHeight(16); ddlistchk:SetWidth(16);
		ddlistchk.t = ddlistchk:CreateTexture(nil, "ARTWORK"); ddlistchk.t:SetAllPoints(); ddlistchk.t:SetTexture("Interface\\Common\\UI-DropDownRadioChecks"); ddlistchk.t:SetTexCoord(0, 0.5, 0.5, 1.0);

		-- Create dropdown list items
		for k, v in pairs(items) do

			local dditem = CreateFrame("Button", nil, LeaPlusCB["ListFrame"..ddname])
			LeaPlusCB["Drop"..ddname..k] = dditem;
			dditem:Show();
			dditem:SetWidth(ddlist:GetWidth()-22)
			dditem:SetHeight(20)
			dditem:SetPoint("TOPLEFT", 12, -k*16)

			dditem.f = dditem:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight'); 
			dditem.f:SetPoint('LEFT', 16, 0)
			dditem.f:SetText(items[k])

			dditem.t = dditem:CreateTexture(nil, "BACKGROUND")
			dditem.t:SetAllPoints()
			dditem.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
			dditem.t:Hide();

			dditem:SetScript("OnEnter", function() dditem.t:Show() end)
			dditem:SetScript("OnLeave", function() dditem.t:Hide() end)
			dditem:SetScript("OnClick", function()
				LeaPlusLC[ddname] = k
				value:SetText(LeaPlusLC[ddname.."Table"][k])
				ddlist:Hide(); -- Must be last in click handler as other functions hook it
			end)

			-- Show list when button is clicked
			dbtn:SetScript("OnClick", function()
				-- Show the dropdown
				if ddlist:IsShown() then ddlist:Hide() else 
					ddlist:Show();
					ddlistchk:SetPoint("TOPLEFT",10,select(5,LeaPlusCB["Drop"..ddname..LeaPlusLC[ddname]]:GetPoint()))
					ddlistchk:Show();
				end;
				-- Hide all other dropdowns except the one we're dealing with
				for void,v in pairs(LeaDropList) do
					if v ~= ddname then
						LeaPlusCB["ListFrame"..v]:Hide();
					end
				end
			end)

			-- Expand the clickable area of the button to include the entire menu width
			dbtn:SetHitRectInsets(-width+28, 0, 0, 0);

		end

		return frame
		
	end
	
----------------------------------------------------------------------
-- 	Create main options panel frame
----------------------------------------------------------------------

	function LeaPlusLC:CreateMainPanel()

		-- Create the panel
		local PageF = CreateFrame("Frame", nil, UIParent);

		-- Make it a system frame
		_G["LeaPlusGlobalPanel"] = PageF
		table.insert(UISpecialFrames, "LeaPlusGlobalPanel")

		-- Set frame parameters
		LeaPlusLC["PageF"] = PageF
		PageF:SetSize(570,370)
		PageF:Hide();
		PageF:SetFrameStrata("FULLSCREEN_DIALOG")
		PageF:SetClampedToScreen(false);
		PageF:EnableMouse(true)
		PageF:SetMovable(true)
		PageF:RegisterForDrag("LeftButton")
		PageF:SetScript("OnDragStart", PageF.StartMoving)
		PageF:SetScript("OnDragStop", function ()
			PageF:StopMovingOrSizing();
			PageF:SetUserPlaced(false);
			-- Save panel position
			LeaPlusLC["MainPanelA"], void, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = PageF:GetPoint()
		end)

		-- Add background color
		PageF.t = PageF:CreateTexture(nil, "BACKGROUND")
		PageF.t:SetAllPoints()
		PageF.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add textures
		LeaPlusLC:CreateBar("FootTexture", PageF, 570, 48, "BOTTOM", 0.5, 0.5, 0.5, 1.0, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaPlusLC:CreateBar("MainTexture", PageF, 440, 323, "TOPRIGHT", 0.7, 0.7, 0.7, 0.7,  "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		LeaPlusLC:CreateBar("MenuTexture", PageF, 130, 323, "TOPLEFT", 0.7, 0.7, 0.7, 0.7, "Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")

		-- Set panel position when shown
		PageF:SetScript("OnShow", function()
			PageF:ClearAllPoints()
			PageF:SetPoint(LeaPlusLC["MainPanelA"], UIParent, LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"])
		end)

		-- Add main title (shown above menu in the corner)
		PageF.mt = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		PageF.mt:SetPoint('TOPLEFT', 16, -16)
		PageF.mt:SetText("Leatrix Plus")

		-- Add version text (shown underneath main title)
		PageF.v = PageF:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		PageF.v:SetHeight(32);
		PageF.v:SetPoint('TOPLEFT', PageF.mt, 'BOTTOMLEFT', 0, -8); 
		PageF.v:SetPoint('RIGHT', PageF, -32, 0)
		PageF.v:SetJustifyH('LEFT'); PageF.v:SetJustifyV('TOP');
		PageF.v:SetNonSpaceWrap(true); PageF.v:SetText(L["Version"] .. " " .. LeaPlusLC["AddonVer"])

		-- Add reload UI Button
		local reloadb = LeaPlusLC:CreateButton("ReloadUIButton", PageF, "Reload", "BOTTOMRIGHT", -16, 10, 0, 25, true, "Your UI needs to be reloaded for some of the changes to take effect.|n|nYou don't have to click the reload button immediately but you do need to click it when you are done making changes and you want the changes to take effect.")
		LeaPlusLC:LockItem(reloadb,true)
		reloadb:SetScript("OnClick", ReloadUI)

		reloadb.f = reloadb:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		reloadb.f:SetHeight(32);
		reloadb.f:SetPoint('RIGHT', reloadb, 'LEFT', -10, 0)
		reloadb.f:SetText(L["Your UI needs to be reloaded."])
		reloadb.f:Hide()

		-- Add close Button
		local CloseB = CreateFrame("Button", nil, PageF, "UIPanelCloseButton") 
		CloseB:SetSize(30, 30)
		CloseB:SetPoint("TOPRIGHT", 0, 0)
		CloseB:SetScript("OnClick", LeaPlusLC.HideFrames) 

		-- Release memory
		LeaPlusLC.CreateMainPanel = nil

	end

	LeaPlusLC:CreateMainPanel();

----------------------------------------------------------------------
-- 	L80: Commands 
----------------------------------------------------------------------

	-- Slash command function
	function LeaPlusLC:SlashFunc(str)
		if str and str ~= "" then
			-- Get parameters in lower case with duplicate spaces removed
			local str, arg1, arg2, arg3 = strsplit(" ", string.lower(str:gsub("%s+", " ")))
			-- Traverse parameters
			if str == "wipe" then
				-- Wipe settings
				LeaPlusLC:PlayerLogout(true) -- Run logout function with wipe parameter
				wipe(LeaPlusDB)
				LpEvt:UnregisterAllEvents(); -- Don't save any settings
				ReloadUI();
			elseif str == "nosave" then
				-- Prevent Leatrix Plus from overwriting LeaPlusDB at next logout
				LpEvt:UnregisterEvent("PLAYER_LOGOUT")
				LeaPlusLC:Print("Leatrix Plus will not overwrite LeaPlusDB at next logout.")
				return
			elseif str == "reset" then
				-- Reset panel positions
				LeaPlusLC["MainPanelA"], LeaPlusLC["MainPanelR"], LeaPlusLC["MainPanelX"], LeaPlusLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
				LeaPlusLC["PlusPanelScale"] = 1
				LeaPlusLC["PlusPanelAlpha"] = 0
				LeaPlusLC["PageF"]:SetScale(1)
				LeaPlusLC["PageF"].t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
				-- Refresh panels
				LeaPlusLC["PageF"]:ClearAllPoints()
				LeaPlusLC["PageF"]:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
				-- Reset currently showing configuration panel
				for k, v in pairs(LeaConfigList) do 
					if v:IsShown() then
						v:ClearAllPoints()
						v:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
						v:SetScale(1)
						v.t:SetAlpha(1 - LeaPlusLC["PlusPanelAlpha"])
					end
				end
				-- Refresh Leatrix Plus settings menu only
				if LeaPlusLC["Page8"]:IsShown() then
					LeaPlusLC["Page8"]:Hide()
					LeaPlusLC["Page8"]:Show()
				end
			elseif str == "hk" then
				-- Print lifetime honorable kills
				local chagmsg = L["Lifetime honorable kills"]
				local ltphk = GetStatistic(588)
				if ltphk == "--" then ltphk = "0" end
				chagmsg = chagmsg .. ": |cffffffff" .. ltphk
				LeaPlusLC:Print(chagmsg)
				return
			elseif str == "taint" then
				-- Set taint log level
				if arg1 and arg1 ~= "" then
					arg1 = tonumber(arg1)
					if arg1 and arg1 >= 0 and arg1 <= 2 then
						if arg1 == 0 then
							-- Disable taint log
							ConsoleExec("taintLog 0")
							LeaPlusLC:Print("Taint level: Disabled (0).")
						elseif arg1 == 1 then
							-- Basic taint log
							ConsoleExec("taintLog 1")
							LeaPlusLC:Print("Taint level: Basic (1).")
						elseif arg1 == 2 then
							-- Full taint log
							ConsoleExec("taintLog 2")
							LeaPlusLC:Print("Taint level: Full (2).")
						end
					else
 						LeaPlusLC:Print("Invalid taint level.")
					end
				else
					-- Show current taint level
					local taintCurrent = GetCVar("taintLog")
					if taintCurrent == "0" then
						LeaPlusLC:Print("Taint level: Disabled (0).")
					elseif taintCurrent == "1" then
						LeaPlusLC:Print("Taint level: Basic (1).")
					elseif taintCurrent == "2" then
						LeaPlusLC:Print("Taint level: Full (2).")
					end
				end
				return
			elseif str == "quest" then
				-- Show quest completed status
				if arg1 and arg1 ~= "" then
					if tonumber(arg1) then
						local questCompleted = IsQuestFlaggedCompleted(arg1)
						if questCompleted then
							LeaPlusLC:Print(arg1 .. ": " .. L["Quest completed."])
						else
							LeaPlusLC:Print(arg1 .. ": " .. L["Quest not completed."])
						end
					else
						LeaPlusLC:Print("Invalid quest ID.")
					end
				else
					LeaPlusLC:Print("Missing quest ID.")
				end
				return
			elseif str == "gstaff" then
				-- Buy 10 x Rough Wooden Staff from Larana Drome in Scribes' Sacellum, Dalaran, Northrend (used for testing)
				local npcName = UnitName("target")
				local npcGuid = UnitGUID("target") or nil
				local errmsg = "Requires you to be interacting with Larana Drome.  She can be found at Scribes' Sacellum, Dalaran, Northrend."
				if npcName and npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID and npcID == "28723" then
						for k = 1, 10 do
							BuyMerchantItem(5)
						end
					else
						LeaPlusLC:Print(errmsg)
					end
				else
					LeaPlusLC:Print(errmsg)
				end
				return
			elseif str == "rest" then
				-- Show rested bubbles
				LeaPlusLC:Print(L["Rested bubbles"] .. ": |cffffffff" .. (math.floor(20 * (GetXPExhaustion() or 0) / UnitXPMax("player") + 0.5)))
				return
			elseif str == "zygor" then
				-- Toggle Zygor addon
				LeaPlusLC:ZygorToggle()
				return
			elseif str == "id" then
				-- Print NPC ID
				local npcName = UnitName("target")
				local npcGuid = UnitGUID("target") or nil
				if npcName and npcGuid then
					local void, void, void, void, void, npcID = strsplit("-", npcGuid)
					if npcID then
						LeaPlusLC:Print(npcName .. ": |cffffffff" .. npcID)
					end
				end
				return
			elseif str == "mountid" then
				-- Get mount ID by mount name
				if not arg1 or arg1 == "" then LeaPlusLC:Print("Missing mount name.") return end
				local mounts = C_MountJournal.GetMountIDs()
				local mountSuccess = false
				for i = 1, #mounts do
					local creatureName, spellID, icon, active, isUsable, sourceType = C_MountJournal.GetMountInfoByID(mounts[i])
					if strfind(strlower(creatureName), strlower(arg1)) then
						LeaPlusLC:Print(creatureName .. ": |cffffffff" .. mounts[i] .. "|r")
						mountSuccess = true
					end
				end
				if not mountSuccess then LeaPlusLC:Print("Mount not found.") end
				return
			elseif str == "petid" then
				-- Get pet ID by pet name
				if not arg1 or arg1 == "" then LeaPlusLC:Print("Missing pet name.") return end
				local numPets = C_PetJournal.GetNumPets()
				local petSuccess = false
				for i = 1, numPets do
					local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, creatureID, sourceText, description, isWildPet, canBattle, tradable, unique = C_PetJournal.GetPetInfoByIndex(i, false)
					if strfind(strlower(name), strlower(arg1)) then
						if isOwned then
							LeaPlusLC:Print(name .. ": |cffffffff" .. petID .. " |cff00ff00(" .. level .. ")|r")
							petSuccess = true
						elseif not petSuccess then
							LeaPlusLC:Print("You do not own this pet.  Only owned pets can be searched.")
							return
						end
					end
				end
				if not petSuccess then
					LeaPlusLC:Print("Pet not found.  Only owned pets that are currently showing in the journal can be searched.")
				end
				return
			elseif str == "tooltip" then
				-- Print tooltip frame name
				local enumf = EnumerateFrames()
				while enumf do
					if (enumf:GetObjectType() == "GameTooltip" or strfind((enumf:GetName() or ""):lower(),"tip")) and enumf:IsVisible() and enumf:GetPoint() then
						print(enumf:GetName())
					end 
					enumf = EnumerateFrames(enumf)
				end
				collectgarbage()
				return
			elseif str == "soil" then
				-- Enable dark soil scanning
				if not LeaPlusLC["DarkScriptlEnabled"] then
					GameTooltip:HookScript("OnUpdate", function() 
						local a = _G["GameTooltipTextLeft1"]:GetText() or "" 
						if a == "Dark Soil" then
							PlaySound(8959)
						end
					end)
					LeaPlusLC["DarkScriptlEnabled"] = true
					LeaPlusLC:Print("Dark Soil scanning activated.  Reload UI to exit.")
				else
					LeaPlusLC:Print("Dark Soil scanning is already activated.  You only need to run this once.  Reload UI to exit.")
				end
				return
			elseif str == "event" then
				-- List events (used for debug)
				LeaPlusLC["DbF"] = LeaPlusLC["DbF"] or CreateFrame("FRAME")
				if not LeaPlusLC["DbF"]:GetScript("OnEvent") then
					LeaPlusLC:Print("Tracing started.")
					LeaPlusLC["DbF"]:RegisterAllEvents()
					-- Unregister unnecessary spammy events
					LeaPlusLC["DbF"]:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
					LeaPlusLC["DbF"]:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
					LeaPlusLC["DbF"]:UnregisterEvent("BAG_UPDATE_COOLDOWN")
					LeaPlusLC["DbF"]:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
					LeaPlusLC["DbF"]:UnregisterEvent("UNIT_POWER_FREQUENT")
					LeaPlusLC["DbF"]:UnregisterEvent("SPELL_UPDATE_USABLE")
					LeaPlusLC["DbF"]:UnregisterEvent("UPDATE_INVENTORY_DURABILITY")
					LeaPlusLC["DbF"]:UnregisterEvent("CHAT_MSG_TRADESKILLS")
					LeaPlusLC["DbF"]:SetScript("OnEvent", function(self, event)
						print(event)
					end)
				else
					LeaPlusLC["DbF"]:UnregisterAllEvents()
					LeaPlusLC["DbF"]:SetScript("OnEvent", nil)
					LeaPlusLC:Print("Tracing stopped.")
				end
				return
			elseif str == "config" then
				-- Show maximum camera distance
				LeaPlusLC:Print(L["Camera distance"] .. ": |cffffffff" .. GetCVar("cameraDistanceMaxZoomFactor"))
				-- Show screen effects
				LeaPlusLC:Print(L["Shaders"] .. ": |cffffffff" .. GetCVar("ffxGlow") .. ", " .. GetCVar("ffxDeath") .. ", " .. GetCVar("ffxNether"))
				-- Show particle density
				LeaPlusLC:Print(L["Particle density"] .. ": |cffffffff" .. GetCVar("particleDensity"))
				LeaPlusLC:Print(L["Weather density"] .. ": |cffffffff" .. GetCVar("weatherDensity"))
				-- Show config
				LeaPlusLC:Print("SynchroniseConfig: |cffffffff" .. GetCVar("synchronizeConfig"))
				-- Show achievement sharing
				local achhidden = AreAccountAchievementsHidden()
				if achhidden then
					LeaPlusLC:Print("Account achievements are hidden.")
				else
					LeaPlusLC:Print("Account achievements are being shared.")
				end
				return
			elseif str == "move" then
				-- Move minimap
				MinimapZoneTextButton:Hide()
				MinimapBorderTop:SetTexture("")
				MiniMapWorldMapButton:Hide()
				MinimapBackdrop:ClearAllPoints()
				MinimapBackdrop:SetPoint("CENTER", UIParent, "CENTER", -330, -75)
				Minimap:SetPoint("CENTER", UIParent, "CENTER", -320, -50)
				return
			elseif str == "tipcol" then
				-- Show default tooltip title color
				if GameTooltipTextLeft1:IsShown() then
					local r, g, b, a = GameTooltipTextLeft1:GetTextColor()
					r = r <= 1 and r >= 0 and r or 0
					g = g <= 1 and g >= 0 and g or 0
					b = b <= 1 and b >= 0 and b or 0
					LeaPlusLC:Print(L["Tooltip title color"] .. ": " .. strupper(string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. "。"))
				else
					LeaPlusLC:Print("No tooltip showing.")
				end
				return
			elseif str == "list" then
				-- Enumerate frames
				local frame = EnumerateFrames()
				while frame do 
					if (frame:IsVisible() and MouseIsOver(frame)) then 
						LeaPlusLC:Print(frame:GetName() or string.format("[Unnamed Frame: %s]", tostring(frame)))
					end 
					frame = EnumerateFrames(frame) 
				end
				return
			elseif str == "nohelp" then
				-- Set most help plates to seen
				for i = 1, 100 do
					SetCVarBitfield("closedInfoFrames", i, true)
				end
				TalentMicroButtonAlert:Hide()
				TalentMicroButtonAlert:HookScript("OnShow", TalentMicroButtonAlert.Hide)
				return
			elseif str == "grid" then
				-- Create grid for first use
				if not LeaPlusLC.grid then
					LeaPlusLC.grid = CreateFrame('FRAME') 
					LeaPlusLC.grid:Hide()
					LeaPlusLC.grid:SetAllPoints(UIParent)
					local w, h = GetScreenWidth() * UIParent:GetEffectiveScale(), GetScreenHeight() * UIParent:GetEffectiveScale()
					local ratio = w / h
					local sqsize = w / 20
					local wline = floor(sqsize - (sqsize % 2))
					local hline = floor(sqsize / ratio - ((sqsize / ratio) % 2))
					-- Plot vertical lines
					for i = 0, wline do
						local t = LeaPlusLC.grid:CreateTexture(nil, 'BACKGROUND')
						if i == wline / 2 then t:SetColorTexture(1, 0, 0, 0.5) else t:SetColorTexture(0, 0, 0, 0.5) end
						t:SetPoint('TOPLEFT', LeaPlusLC.grid, 'TOPLEFT', i * w / wline - 1, 0)
						t:SetPoint('BOTTOMRIGHT', LeaPlusLC.grid, 'BOTTOMLEFT', i * w / wline + 1, 0)
					end
					-- Plot horizontal lines
					for i = 0, hline do
						local t = LeaPlusLC.grid:CreateTexture(nil, 'BACKGROUND')
						if i == hline / 2 then	t:SetColorTexture(1, 0, 0, 0.5) else t:SetColorTexture(0, 0, 0, 0.5) end
						t:SetPoint('TOPLEFT', LeaPlusLC.grid, 'TOPLEFT', 0, -i * h / hline + 1)
						t:SetPoint('BOTTOMRIGHT', LeaPlusLC.grid, 'TOPRIGHT', 0, -i * h / hline - 1)
					end	
				end
				-- Show or hide grid
				if LeaPlusLC.grid:IsShown() then
					LeaPlusLC.grid:Hide()
				else
					LeaPlusLC.grid:Show()
				end
				return
			elseif str == "chk" then
				-- List truncated checkbox labels
				if LeaPlusLC["TruncatedLabelsList"] then
					for i, v in pairs(LeaPlusLC["TruncatedLabelsList"]) do
						LeaPlusLC:Print(LeaPlusLC["TruncatedLabelsList"][i])
					end
				else
					LeaPlusLC:Print("Checkbox labels are Ok.")
				end
				return
			elseif str == "cv" then
				-- Print console variable setting
				if arg1 and arg1 ~= "" then
					if GetCVar(arg1) then
						LeaPlusLC:Print(arg1 .. ": |cffffffff" .. GetCVar(arg1))
					else
						LeaPlusLC:Print("Invalid console variable.")
					end
				else
					LeaPlusLC:Print("Missing console variable.")
				end
				return
			elseif str == "play" then
				-- Play sound ID
				if arg1 and arg1 ~= "" then
					if tonumber(arg1) then
						-- Stop last played sound ID
						if LeaPlusLC.SNDcanitHandle then
							StopSound(LeaPlusLC.SNDcanitHandle)
						end
						-- Play sound ID
						LeaPlusLC.SNDcanitPlay, LeaPlusLC.SNDcanitHandle = PlaySound(arg1, "Master", false, false)
					else
						LeaPlusLC:Print("Invalid sound ID.")
					end
				else
					LeaPlusLC:Print("Missing sound ID.")
				end
				return
			elseif str == "stop" then
				-- Stop last played sound ID
				if LeaPlusLC.SNDcanitHandle then
					StopSound(LeaPlusLC.SNDcanitHandle)
				end
				return
			elseif str == "team" then
				-- Assign battle pet team
				local p1, s1p1, s1p2, s1p3, p2, s2p1, s2p2, s2p3, p3, s3p1, s3p2, s3p3 = strsplit(",", arg1 or "", 12)
				if p1 and s1p1 and s1p2 and s1p3 and p2 and s2p1 and s2p2 and s2p3 and p3 and s3p1 and s3p2 and s3p3 then
					if LeaPlusLC:PlayerInCombat() then
						return
					else
						-- Ensure all 3 slots are unlocked
						for i = 1, 3 do
							local void, void, void, void, isLocked = C_PetJournal.GetPetLoadOutInfo(i)
							if isLocked and isLocked == true then
								LeaPlusLC:Print("All 3 battle pet slots need to be unlocked.")
								return
							end
						end
						-- Assign pets
						C_PetJournal.SetPetLoadOutInfo(1, p1)
						C_PetJournal.SetAbility(1, 1, s1p1)
						C_PetJournal.SetAbility(1, 2, s1p2)
						C_PetJournal.SetAbility(1, 3, s1p3)
						C_PetJournal.SetPetLoadOutInfo(2, p2)
						C_PetJournal.SetAbility(2, 1, s2p1)
						C_PetJournal.SetAbility(2, 2, s2p2)
						C_PetJournal.SetAbility(2, 3, s2p3)
						C_PetJournal.SetPetLoadOutInfo(3, p3)
						C_PetJournal.SetAbility(3, 1, s3p1)
						C_PetJournal.SetAbility(3, 2, s3p2)
						C_PetJournal.SetAbility(3, 3, s3p3)
						if PetJournal and PetJournal:IsShown() then
							PetJournal_UpdatePetLoadOut()
						end
					end
				else
					LeaPlusLC:Print("Invalid battle pet team parameter.")
				end
				return
			elseif str == "wipecds" then
				-- Wipe cooldowns
				LeaPlusDB["Cooldowns"] = nil
				ReloadUI()
				return
			elseif str == "tipchat" then
				-- Print tooltip contents in chat
				local numLines = GameTooltip:NumLines()
				if numLines then
					for i = 1, numLines do
						print(_G["GameTooltipTextLeft" .. i]:GetText() or "")
					end
				end
				return
			elseif str == "tiplang" then
				-- Tooltip tag locale code constructor
				local msg = ""
				msg = msg .. 'if GameLocale == "' .. GameLocale .. '" then '
				msg = msg .. 'ttLevel = "' .. LEVEL .. '"; '
				msg = msg .. 'ttBoss = "' .. BOSS .. '"; '
				msg = msg .. 'ttElite = "' .. ELITE .. '"; '
				msg = msg .. 'ttRare = "' .. ITEM_QUALITY3_DESC .. '"; '
				msg = msg .. 'ttRareElite = "' .. ITEM_QUALITY3_DESC .. " " .. ELITE .. '"; '
				msg = msg .. 'ttRareBoss = "' .. ITEM_QUALITY3_DESC .. " " .. BOSS .. '"; '
				msg = msg .. 'ttTarget = "' .. TARGET .. '"; '
				msg = msg .. "end"
				print(msg)
				return
			elseif str == "con" then
				-- Show the developer console
				C_Console.SetFontHeight(28)
				DeveloperConsole:Toggle(true)
				return
			elseif str == "movlist" then
				-- List playable movie IDs
				local count = 0
				for i = 1, 5000 do
					if IsMoviePlayable(i) then
						print(i)
						count = count + 1
					end
				end
				LeaPlusLC:Print("Total movies: |cffffffff" .. count)
				return
			elseif str == "movie" then
				-- Playback movie by ID
				arg1 = tonumber(arg1)
				if arg1 and arg1 ~= "" then
					if IsMoviePlayable(arg1) then
						LeaPlusLC["ForceMoviePlaybackFlag"] = "On"
						MovieFrame_PlayMovie(MovieFrame, arg1)
						LeaPlusLC["ForceMoviePlaybackFlag"] = "Off"
					else
						LeaPlusLC:Print("Movie not playable.")
					end
				else
					LeaPlusLC:Print("Missing movie ID.")
				end
				return
			elseif str == "cin" then
				-- Play opening cinematic (only works if character has never gained XP) (used for testing)
				OpeningCinematic()
				return
			elseif str == "skit" then
				-- Play a test sound kit
				PlaySound("1020", "Master", false, true)
				return
			elseif str == "dup" then
				-- Print music track duplicates 
				local mask, found, badidfound = false, false, false
				for i, e in pairs(LeaPlusLC.ZoneList) do
					if LeaPlusLC.ZoneList[e] then
						for a, b in pairs(LeaPlusLC.ZoneList[e]) do
							local same = {}
							if b.tracks then
								for k, v in pairs(b.tracks) do
									-- Check for bad sound IDs
									local temFile, temSoundID = v:match("([^,]+)%#([^,]+)")
									if temSoundID then
										local temPlay, temHandle = PlaySound(temSoundID, "Master", false, true)
										if temHandle then StopSound(temHandle) end
										temPlay, temHandle = PlaySound(temSoundID, "Master", false, true)
										if not temPlay and not temHandle then
											print("|cffff5400" .. L["Bad ID"] .. ": |r" .. e, v)
											badidfound = true
										else
											if temHandle then StopSound(temHandle) end
										end
									end
									-- Check for duplicate IDs
									if tContains(same, v) and mask == false then 
										mask = true
										found = true
										print("|cffec51ff" .. L["Dup ID"] .. ": |r" .. e, v)
									end
									tinsert(same, v)
									mask = false
								end
							end
						end
					end
				end
				if badidfound == false then 
					LeaPlusLC:Print("No bad sound IDs found.") 
				end
				if found == false then 
					LeaPlusLC:Print("No media duplicates found.") 
				end
				collectgarbage()
				return
			elseif str == "enigma" then
				-- Enigma
				if not LeaPlusLC.enimgaFrame then
					local selectedBtn
					local bt = {}
					local eData = {
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [20]=1, [23]=1, [24]=1, [25]=1, [26]=1, [27]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R4, U2, L4",},
						{[9]=1, [11]=1, [12]=1, [13]=1, [16]=1, [18]=1, [20]=1, [23]=1, [24]=1, [25]=1, [27]=1, [34]=1, [41]=2, "U4, L2, D2, L2, U2",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [19]=1, [25]=1, [26]=1, [32]=1, [39]=1, [40]=1, [41]=2, "L2, U2, R1, U2, L3",},
						{[9]=1, [10]=1, [11]=1, [18]=1, [23]=1, [24]=1, [25]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R2, U2, L2",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [16]=1, [23]=1, [25]=1, [26]=1, [27]=1, [30]=1, [32]=1, [34]=1, [37]=1, [38]=1, [39]=1, [41]=2, "U2, L2, D2, L2, U4, R4",},
						{[12]=1,[13]=1, [18]=1, [19]=1, [25]=1, [32]=1, [33]=1, [40]=1, [41]=2, "L1, U1, L1, U2, R1, U1, R1",},
						{[9]=1, [11]=1, [12]=1, [13]=1, [16]=1, [18]=1, [20]=1, [23]=1, [25]=1, [27]=1, [30]=1, [31]=1, [32]=1, [34]=1, [41]=2, "U4, L2, D3, L2, U3",},
						{[9]=1, [10]=1, [17]=1, [24]=1, [25]=1, [32]=1, [33]=1, [40]=1, [41]=2, "L1, U1, L1, U1, L1, U2, L1",},
						{[9]=1, [16]=1, [17]=1, [18]=1, [19]=1, [20]=1, [27]=1, [34]=1, [41]=2, "U3, L4, U1",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [16]=1, [23]=1, [24]=1, [25]=1, [26]=1, [33]=1, [40]=1, [41]=2, "L1, U2, L3, U2, R4",},
						{[9]=1, [10]=1, [11]=1, [12]=1, [13]=1, [16]=1, [23]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U4, R4",},
						{[11]=1,[12]=1, [13]=1, [18]=1, [23]=1, [24]=1, [25]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R2, U2, R2",},
						{[13]=1,[20]=1, [23]=1, [24]=1, [25]=1, [26]=1, [27]=1, [30]=1, [37]=1, [38]=1, [39]=1, [40]=1, [41]=2, "L4, U2, R4, U2",},
					}
					-- Create frame
					local eFrame = CreateFrame("Frame", nil, UIParent)
					eFrame:SetPoint("TOP", 0, 0)
					eFrame:SetSize(1222, 134)
					eFrame.b = eFrame:CreateTexture(nil, "BACKGROUND")
					eFrame.b:SetAllPoints()
					eFrame.b:SetColorTexture(0, 0, 0, 1)
					eFrame:SetFrameStrata("FULLSCREEN_DIALOG")
					eFrame:SetScale(0.9)
					eFrame:SetToplevel(true)
					eFrame:EnableMouse(true)
					LeaPlusLC.enimgaFrame = eFrame

					-- Right-click to exit
					eFrame:SetScript("OnMouseDown", function(self, btn)
						if btn == "RightButton" then
							eFrame:Hide()
						end
					end)

					-- Create title fontstring
					eFrame.f = eFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
					eFrame.f:SetPoint("BOTTOMLEFT", 10, 10)
					eFrame.f:SetText(L["Choose an Enigma pattern"])
					eFrame.f:SetFont(eFrame.f:GetFont(), 24, nil)

					-- Create close fontstring
					eFrame.x = eFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge") 
					eFrame.x:SetPoint("BOTTOMRIGHT", -10, 10)
					eFrame.x:SetText(L["Right-click to close"])
					eFrame.x:SetFont(eFrame.f:GetFont(), 24, nil)

					-- Create buttons
					for eBtn = 1, #eData do
						local b = CreateFrame("Button", nil, eFrame)
						tinsert(bt, b)
						b:SetSize(94, 94)
						b:SetPoint("TOPLEFT", ((eBtn - 1) % 13) * 94, -2)

						-- Button highlight bar
						b.line = b:CreateTexture(nil, "ARTWORK")
						b.line:SetTexture("Interface\\PLAYERFRAME\\DruidLunarBarHorizontal")
						b.line:SetSize(84, 6)
						b.line:SetPoint("BOTTOM", 0, -4)
						b.line:Hide()

						-- Button textures
						for row = 0, 7 - 1 do
							for col = 0, 7 - 1 do
								local t = b:CreateTexture(nil, "ARTWORK")
								t:SetSize(12, 12)
								t:SetPoint("TOPLEFT", 5 + col * 12, - 5 - row * 12)
								local c = eData[eBtn][row * 7 + col + 1]
								-- Do nothing if element is the solution
								if c and strfind(c, ",") then c = nil end
								-- Color textures
								if c == 2 then
									-- Starting block
									t:SetColorTexture(0, 1, 0)
								elseif c then
									-- Path
									t:SetColorTexture(1, 1, 1)
								else
									-- Background
									t:SetColorTexture(.4, .4, .9)
								end
							end
						end

						-- Button scripts
						b:SetScript("OnEnter", function()
							bt[eBtn].line:Show()
						end)

						b:SetScript("OnLeave", function()
							if b ~= selectedBtn then bt[eBtn].line:Hide() end
						end)

						b:SetScript("OnMouseDown", function(self, btn)
							if btn == "RightButton" then
								-- Right-click to exit
								eFrame:Hide()
								return
							else
								-- Deselect all buttons
								for test = 1, #bt do
									bt[test].line:Hide()
								end
								-- Select current button
								bt[eBtn].line:Show()
								selectedBtn = b
								PlaySoundFile("Sound\\Interface\\PlaceHolder.ogg")
								-- Print button data
								eFrame.f:SetText(L["Enigma"] .. " " .. eBtn .. ": |cffffffff" .. eData[eBtn][#eData[eBtn]])
							end
						end)

					end
				else
					-- Toggle frame
					if LeaPlusLC.enimgaFrame:IsShown() then
						LeaPlusLC.enimgaFrame:Hide()
					else
						LeaPlusLC.enimgaFrame:Show()
					end
				end
				return
			elseif str == "mapinfo" then
				-- Show map information
				local upx, upy = UnitPosition("player")
				upx = upx or 0
				upy = upy or 0
				local void, void, void, isMicroDungeon = GetMapInfo()
				if isMicroDungeon then isMicroDungeon = "Yes" else isMicroDungeon = "No" end
				LeaPlusLC:Print("AreaMapInfo: |cffffffff" .. GetAreaMapInfo(GetCurrentMapAreaID()))
				LeaPlusLC:Print("CurrentMapAreaID: |cffffffff" .. GetCurrentMapAreaID())
				LeaPlusLC:Print("UnitPosition: |cffffffff" .. format("%.00f", upx) .. " " .. format("%.00f", upy))
				LeaPlusLC:Print("Level: |cffffffff" .. GetCurrentMapDungeonLevel())
				LeaPlusLC:Print("Dungeon: |cffffffff" .. isMicroDungeon)
				return
			elseif str == "maploc" then
				-- Show the world coordinates for a movable POI button
				if LeaPlusLC.PlayWithTheMap then
					LeaPlusLC:Print("Maploc is already loaded.  Reload UI to unload it.")
					return
				end
				if GetCVar("miniWorldMap") == "0" then
					LeaPlusLC:Print("You need a windowed map for Maploc.")
					return
				end
				-- Declare locals
				local x, y, inc = 0, 0, 1
				-- Create text frame to show world coordinates
				local textFrame = CreateFrame("FRAME", nil, WorldMapFrame)
				textFrame:ClearAllPoints()
				textFrame:SetPoint("TOP", WorldMapFrame, "TOP", 0, 34)
				textFrame:SetSize(252, 34)
				textFrame:SetFrameLevel(5000)
				textFrame.s = textFrame:CreateTexture(nil, "BACKGROUND")
				textFrame.s:SetAllPoints()
				textFrame.s:SetColorTexture(0.1, 0.1, 0.1, 1.0)
				textFrame.f = textFrame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
				textFrame.f:SetAllPoints()
				textFrame.f:SetFontObject("GameFontNormalLarge")
				textFrame.f:SetFont(textFrame.f:GetFont(), 24, nil)
				textFrame.f:SetText((("%%.%df"):format(0)):format(x) .. "   " .. (("%%.%df"):format(0)):format(y))
				-- Function to update coordinates
				local function SetLocation()
					textFrame.f:SetText((("%%.%df"):format(0)):format(x) .. "   " .. (("%%.%df"):format(0)):format(y))
				end
				-- Create a POI
				local button = CreateFrame("Button", nil, WorldMapPOIFrame)
				LeaPlusLC.PlayWithTheMap = button
				button:SetSize(30, 30)
				button:SetNormalTexture("Interface\\Minimap\\Vehicle-AllianceMagePortal")
				button.HighlightTexture = button:CreateTexture("BoogleHighlightTexture", "HIGHLIGHT")
				button:SetScript("OnEnter", WorldMapPOI_OnEnter)
				button:SetScript("OnLeave", WorldMapPOI_OnLeave)
				button.name = "Maploc"
				button.description = "Show world coordinates for a movable map object"
				button.poiID = 0
				-- Function to position the POI
				local function moveIt()
					local void, locLeft, locTop, locRight, locBottom = GetCurrentMapZone()
					if locLeft and locTop and locRight and locBottom then
						local currLevel, minY, minX, maxY, maxX = GetCurrentMapDungeonLevel()
						if minY and minX and maxY and maxX then
							WorldMapPOIFrame_AnchorPOI(button, (maxY - y) / abs(maxY - minY), (maxX - x) / abs(maxX - minX), 200)
						else
							WorldMapPOIFrame_AnchorPOI(button, (locLeft - y) / abs(locRight - locLeft), (locTop - x) / abs(locBottom - locTop), 200)
						end
					end
				end
				-- Create movement control buttons
				local upBtn = LeaPlusLC:CreateButton("PlayMapUpBtn", WorldMapFrame, "UP", "BOTTOMRIGHT", 72, 151, 60, 25, true, ""); upBtn:SetScale(2); upBtn:SetFrameLevel(5); upBtn:Hide(); upBtn:Show()
				local downBtn = LeaPlusLC:CreateButton("PlayMapDownBtn", WorldMapFrame, "DOWN", "BOTTOMRIGHT", 72, 121, 60, 25, true, ""); downBtn:SetScale(2); downBtn:SetFrameLevel(5); downBtn:Hide(); downBtn:Show()
				local leftBtn = LeaPlusLC:CreateButton("PlayMapLeftBtn", WorldMapFrame, "LEFT", "BOTTOMRIGHT", 72, 91, 60, 25, true, ""); leftBtn:SetScale(2); leftBtn:SetFrameLevel(5); leftBtn:Hide(); leftBtn:Show()
				local rightBtn = LeaPlusLC:CreateButton("PlayMapRightBtn", WorldMapFrame, "RIGHT", "BOTTOMRIGHT", 72, 61, 60, 25, true, ""); rightBtn:SetScale(2); rightBtn:SetFrameLevel(5); rightBtn:Hide(); rightBtn:Show()
				-- Create reset button
				local resetBtn = LeaPlusLC:CreateButton("PlayMapResetBtn", WorldMapFrame, "RESET", "BOTTOMRIGHT", 72, 31, 60, 25, true, ""); resetBtn:SetScale(2); resetBtn:SetFrameLevel(5); resetBtn:Hide(); resetBtn:Show()
				resetBtn:SetScript("OnClick", function()
					local void, locLeft, locTop, locRight, locBottom = GetCurrentMapZone()
					if locLeft and locTop and locRight and locBottom then
						local currLevel, minY, minX, maxY, maxX = GetCurrentMapDungeonLevel()
						if minY and minX and maxY and maxX then
							x = maxX - ((maxX - minX) / 2)
							y = maxY - ((maxY - minY) / 2)
							moveIt()
							SetLocation()
						else
							x = locTop - ((locTop - locBottom) / 2)
							y = locLeft - ((locLeft - locRight) / 2)
							moveIt()
							SetLocation()
						end
					end
				end)
				-- Reset position when map changes zone or dungeon
				local mapFileName1, textureHeight1, textureWidth1, isMicroDungeon1, microDungeonMapName1 = GetMapInfo()
				local floorLevel1 = GetCurrentMapDungeonLevel()
				hooksecurefunc("WorldMapFrame_Update", function()
					local mapFileName2, textureHeight2, textureWidth2, isMicroDungeon2, microDungeonMapName2 = GetMapInfo()
					local floorLevel2 = GetCurrentMapDungeonLevel()
					if mapFileName1 ~= mapFileName2 or microDungeonMapName1 ~= microDungeonMapName2 or floorLevel1 ~= floorLevel2 then
						resetBtn:Click()
						mapFileName1 = mapFileName2
						microDungeonMapName1 = microDungeonMapName2
						floorLevel1 = floorLevel2
					end
				end)
				-- Reset position on startup
				resetBtn:Click()
				-- Set position when zooming
				hooksecurefunc("WorldMapFrame_ResetPOIHitTranslations", moveIt)
				-- Create help button
				local helpBtn = LeaPlusLC:CreateButton("PlayMapHelpBtn", WorldMapFrame, "HELP", "BOTTOMRIGHT", 72, 0, 60, 25, true, ""); helpBtn:SetScale(2); helpBtn:SetFrameLevel(5); helpBtn:Hide(); helpBtn:Show()
				helpBtn.tiptext = "Maploc shows world coordinates for a movable map object.|n|nUse the controls to move the map object.  The object's world coordinates are shown above the map.|n|nHold LSHIFT to go fast.|nHold LALT to go slow.|nHold LCTRL to go REALLY slow.|nReload your UI to exit."
				helpBtn:SetPushedTextOffset(0, 0)
				-- Update script for movement of POI
				textFrame:SetScript("OnUpdate", function()
					if IsLeftShiftKeyDown() then inc = 100
					elseif IsLeftControlKeyDown() then inc = 0.1
					elseif IsLeftAltKeyDown() then inc = 1 end
					if IsMouseButtonDown("LeftButton") and upBtn:IsMouseOver() then
						-- Up button
						local void, tLeft, tTop, tRight, tBottom = GetCurrentMapZone()
						if tLeft and tTop and tRight and tBottom then
							local tLevel, tminY, tminX, tmaxY, tmaxX = GetCurrentMapDungeonLevel()
							if tminY and tminX and tmaxY and tmaxX then
								if x < tmaxX then x = x + inc else x = tmaxX end
								SetLocation(); moveIt()
							else
								if x < tTop then x = x + inc else x = tTop end
								SetLocation(); moveIt()
							end
						end
					elseif IsMouseButtonDown("LeftButton") and downBtn:IsMouseOver() then
						-- Down button
						local void, tLeft, tTop, tRight, tBottom = GetCurrentMapZone()
						if tLeft and tTop and tRight and tBottom then
							local tLevel, tminY, tminX, tmaxY, tmaxX = GetCurrentMapDungeonLevel()
							if tminY and tminX and tmaxY and tmaxX then
								if x > tminX then x = x - inc else x = tminX end
								SetLocation(); moveIt()
							else
								if x > tBottom then x = x - inc else x = tBottom end
								SetLocation(); moveIt()
							end
						end
					elseif IsMouseButtonDown("LeftButton") and leftBtn:IsMouseOver() then
						-- Left button
						local void, tLeft, tTop, tRight, tBottom = GetCurrentMapZone()
						if tLeft and tTop and tRight and tBottom then
							local tLevel, tminY, tminX, tmaxY, tmaxX = GetCurrentMapDungeonLevel()
							if tminY and tminX and tmaxY and tmaxX then
								if y < tmaxY then y = y + inc else y = tmaxY end
								SetLocation(); moveIt()
							else
								if y < tLeft then y = y + inc else y = tLeft end
								SetLocation(); moveIt()
							end
						end
					elseif IsMouseButtonDown("LeftButton") and rightBtn:IsMouseOver() then
						-- Right button
						local void, tLeft, tTop, tRight, tBottom = GetCurrentMapZone()
						if tLeft and tTop and tRight and tBottom then
							local tLevel, tminY, tminX, tmaxY, tmaxX = GetCurrentMapDungeonLevel()
							if tminY and tminX and tmaxY and tmaxX then
								if y > tminY then y = y - inc else y = tminY end
								SetLocation(); moveIt()
							else
								if y > tRight then y = y - inc else y = tRight end
								SetLocation(); moveIt()
							end
						end
					end
					inc = 10
				end)
				LeaPlusLC:Print("Maploc has been loaded.  Reload your UI to unload it.")
				if not WorldMapFrame:IsShown() then
					LeaPlusLC:Print("Open your map to use Maploc.")
				end
				return
			elseif str == "showinst" then
				-- List instance IDs for currently selected Encounter Journal expansion filter dropdown
				for i = 1, 5000 do
					local instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(i, false)
					if instanceID then print(instanceID, name) end
				end
				for i = 1, 5000 do
					local instanceID, name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = EJ_GetInstanceByIndex(i, true)
					if instanceID then print(instanceID, name) end
				end
				return
			elseif str == "marker" then
				-- Prevent showing raid target markers on self
				if not LeaPlusLC.MarkerFrame then
					LeaPlusLC.MarkerFrame = CreateFrame("FRAME")
					LeaPlusLC.MarkerFrame:RegisterEvent("RAID_TARGET_UPDATE")
				end
				LeaPlusLC.MarkerFrame.Update = true
				if LeaPlusLC.MarkerFrame.Toggle == false then
					-- Show markers
					LeaPlusLC.MarkerFrame:SetScript("OnEvent", nil)
					ActionStatus_DisplayMessage(L["Self Markers Allowed"], true)
					LeaPlusLC.MarkerFrame.Toggle = true
				else
					-- Hide markers
					SetRaidTarget("player", 0)
					LeaPlusLC.MarkerFrame:SetScript("OnEvent", function()
						if LeaPlusLC.MarkerFrame.Update == true then
							LeaPlusLC.MarkerFrame.Update = false
							SetRaidTarget("player", 0)
						end
						LeaPlusLC.MarkerFrame.Update = true
					end)
					ActionStatus_DisplayMessage(L["Self Markers Blocked"], true)
					LeaPlusLC.MarkerFrame.Toggle = false
				end
				return
			elseif str == "af" then
				-- Automatically follow player target using ticker
				if LeaPlusLC.followTick then
					-- Existing ticker is active so cancel it
					LeaPlusLC.followTick:Cancel()
					LeaPlusLC.followTick = nil
					FollowUnit("player")
					LeaPlusLC:Print("AutoFollow disabled.")
				else
					-- No ticker is active so create one
					local targetName, targetRealm = UnitName("target")
					if not targetName or not UnitIsPlayer("target") or UnitIsUnit("player", "target") then
						LeaPlusLC:Print("Invalid target.")
						return
					end
					if targetRealm then targetName = targetName .. "-" .. targetRealm end
					if LeaPlusLC.followTick then
						LeaPlusLC.followTick:Cancel()
					end
					FollowUnit(targetName, true)
					LeaPlusLC.followTick = C_Timer.NewTicker(0.5, function()
						FollowUnit(targetName, true)
					end)
					LeaPlusLC:Print(L["AutoFollow"] .. ": |cffffffff" .. targetName .. "|r.")
				end
				return
			elseif str == "admin" then
				-- Preset profile (used for testing)
				LpEvt:UnregisterAllEvents()						-- Prevent changes
				wipe(LeaPlusDB)									-- Wipe settings
				LeaPlusLC:PlayerLogout(true)					-- Reset permanent settings
				-- Automation
				LeaPlusDB["AutomateQuests"] = "On"				-- Automate quests
				LeaPlusDB["AutomateGossip"] = "On"				-- Automate gossip
				LeaPlusDB["AutoAcceptSummon"] = "On"			-- Accept summon
				LeaPlusDB["AutoAcceptRes"] = "On"				-- Accept resurrection
				LeaPlusDB["AutoReleasePvP"] = "On"				-- Release in PvP
				LeaPlusDB["AutoSellJunk"] = "On"				-- Sell junk automatically
				LeaPlusDB["AutoRepairOwnFunds"] = "On"			-- Repair automatically

				-- Social
				LeaPlusDB["NoDuelRequests"] = "On"				-- Block duels
				LeaPlusDB["NoPetDuels"] = "On"					-- Block pet battle duels
				LeaPlusDB["NoPartyInvites"] = "Off"				-- Block party invites
				LeaPlusDB["NoFriendRequests"] = "Off"			-- Block friend requests			
				LeaPlusDB["AcceptPartyFriends"] = "On"			-- Party from friends
				LeaPlusDB["AutoConfirmRole"] = "On"				-- Queue from friends
				LeaPlusDB["InviteFromWhisper"] = "On"			-- Invite from whispers

				-- Chat
				LeaPlusDB["UseEasyChatResizing"] = "On"			-- Use easy resizing
				LeaPlusDB["NoCombatLogTab"] = "On"				-- Hide the combat log
				LeaPlusDB["NoChatButtons"] = "On"				-- Hide chat buttons
				LeaPlusDB["NoSocialButton"] = "On"				-- Hide social button
				LeaPlusDB["UnclampChat"] = "On"					-- Unclamp chat frame
				LeaPlusDB["MoveChatEditBoxToTop"] = "On"		-- Move editbox to top
				LeaPlusDB["NoStickyChat"] = "On"				-- Disable sticky chat
				LeaPlusDB["UseArrowKeysInChat"] = "On"			-- Use arrow keys in chat
				LeaPlusDB["NoChatFade"] = "On"					-- Disable chat fade
				LeaPlusDB["UnivGroupColor"] = "On"				-- Universal group color
				LeaPlusDB["Manageclasscolors"] = "On"			-- Manage class colors
				LeaPlusDB["RecentChatWindow"] = "On"			-- Recent chat window
				LeaPlusDB["RecentChatWidth"] = 1				-- Recent chat width
				LeaPlusDB["RecentChatHeight"] = 0.5				-- Recent chat height
				LeaPlusDB["RecentChatA"] = "BOTTOM"				-- Recent chat position
				LeaPlusDB["RecentChatR"] = "BOTTOM"				-- Recent chat position
				LeaPlusDB["RecentChatX"] = -74					-- Recent chat position
				LeaPlusDB["RecentChatY"] = 88					-- Recent chat position
				LeaPlusDB["MaxChatHstory"] = "Off"				-- Increase chat history

				-- Text
				LeaPlusDB["HideErrorFrameText"] = "On"			-- Hide error messages
				LeaPlusDB["NoHitIndicators"] = "On"				-- Hide portrait text
				LeaPlusDB["HideCraftedNames"] = "On"			-- Hide crafted names
				LeaPlusDB["MailFontChange"] = "On"				-- Resize mail text
				LeaPlusDB["QuestFontChange"] = "On"				-- Resize quest text

				-- Interface
				LeaPlusDB["ShowMapMod"] = "On"					-- Enhance world map
				LeaPlusDB["MinimapMod"] = "On"					-- Customise minimap
				LeaPlusDB["MergeTrackBtn"] = "On"				-- Merge buttons
				LeaPlusDB["HideMinimapZone"] = "On"				-- Hide zone text
				LeaPlusDB["MinimapScale"] = 1.30				-- Minimap scale slider
				LeaPlusDB["TipModEnable"] = "On"				-- Manage tooltip
				LeaPlusDB["TipBackSimple"] = "On"				-- Color backdrops
				LeaPlusDB["LeaPlusTipSize"] = 1.25				-- Tooltip scale slider
				LeaPlusDB["EnhanceDressup"] = "On"				-- Enhance dressup
				LeaPlusDB["ShowVolume"] = "On"					-- Show volume slider
				LeaPlusDB["AhExtras"] = "On"					-- Show auction controls
				LeaPlusDB["StaticCoordsEn"] = "On"				-- Show coordinates
				LeaPlusDB["StaticCoords"] = "Off"				-- Show coordinates frame
				LeaPlusDB["StaticCoordsScale"] = 2.0			-- Coordinates scale
				LeaPlusDB["CoordsA"] = "BOTTOMRIGHT"			-- Coordinates anchor
				LeaPlusDB["CoordsR"] = "BOTTOMRIGHT"			-- Coordinates relative
				LeaPlusDB["CoordsX"] = -300						-- Coordinates X axis
				LeaPlusDB["CoordsY"] = 130						-- Coordinates Y axis
				LeaPlusDB["ShowCooldowns"] = "On"				-- Show cooldowns
				LeaPlusDB["DurabilityStatus"] = "On"			-- Show durability status
				LeaPlusDB["ShowPetSaveBtn"] = "On"				-- Show pet save button
				LeaPlusDB["ShowWowheadLinks"] = "On"			-- Show Wowhead links

				-- Frames
				LeaPlusDB["FrmEnabled"] = "On"					-- Manage frames

				LeaPlusDB["Frames"] = {}						-- Frame profile
				LeaPlusDB["Frames"]["PlayerFrame"] = {}
				LeaPlusDB["Frames"]["PlayerFrame"]["Point"] = "TOPLEFT"
				LeaPlusDB["Frames"]["PlayerFrame"]["Relative"] = "TOPLEFT"
				LeaPlusDB["Frames"]["PlayerFrame"]["XOffset"] = -35
				LeaPlusDB["Frames"]["PlayerFrame"]["YOffset"] = -14
				LeaPlusDB["Frames"]["PlayerFrame"]["Scale"] = 1.20

				LeaPlusDB["Frames"]["TargetFrame"] = {}
				LeaPlusDB["Frames"]["TargetFrame"]["Point"] = "TOPLEFT"
				LeaPlusDB["Frames"]["TargetFrame"]["Relative"] = "TOPLEFT"
				LeaPlusDB["Frames"]["TargetFrame"]["XOffset"] = 190
				LeaPlusDB["Frames"]["TargetFrame"]["YOffset"] = -14
				LeaPlusDB["Frames"]["TargetFrame"]["Scale"] = 1.20

				LeaPlusDB["Frames"]["GhostFrame"] = {}
				LeaPlusDB["Frames"]["GhostFrame"]["Point"] = "CENTER"
				LeaPlusDB["Frames"]["GhostFrame"]["Relative"] = "CENTER"
				LeaPlusDB["Frames"]["GhostFrame"]["XOffset"] = 3
				LeaPlusDB["Frames"]["GhostFrame"]["YOffset"] = -142

				LeaPlusDB["Frames"]["WorldStateAlwaysUpFrame"] = {}
				LeaPlusDB["Frames"]["WorldStateAlwaysUpFrame"]["Point"] = "TOP"
				LeaPlusDB["Frames"]["WorldStateAlwaysUpFrame"]["Relative"] = "TOP"
				LeaPlusDB["Frames"]["WorldStateAlwaysUpFrame"]["XOffset"] = -40
				LeaPlusDB["Frames"]["WorldStateAlwaysUpFrame"]["YOffset"] = -530

				LeaPlusDB["Frames"]["MirrorTimer1"] = {}
				LeaPlusDB["Frames"]["MirrorTimer1"]["Point"] = "TOP"
				LeaPlusDB["Frames"]["MirrorTimer1"]["Relative"] = "TOP"
				LeaPlusDB["Frames"]["MirrorTimer1"]["XOffset"] = 0
				LeaPlusDB["Frames"]["MirrorTimer1"]["YOffset"] = -120

				LeaPlusDB["ManageBuffFrame"] = "On"				-- Manage buff frame
				LeaPlusDB["BuffFrameA"] = "TOPRIGHT"			-- Buff frame anchor
				LeaPlusDB["BuffFrameR"] = "TOPRIGHT"			-- Buff frame relative
				LeaPlusDB["BuffFrameX"] = -271					-- Buff frame X offset
				LeaPlusDB["BuffFrameY"] = 0						-- Buff frame Y offset
				LeaPlusDB["BuffFrameScale"] = 0.80				-- Buff frame scale

				LeaPlusDB["ClassColFrames"] = "On"				-- Class colored frames
				LeaPlusDB["ShowPlayerChain"] = "On"				-- Show player chain
				LeaPlusDB["PlayerChainMenu"] = 3				-- Player chain style
				LeaPlusDB["ShowRaidToggle"] = "On"				-- Show raid toggle button
				LeaPlusDB["CombatPlates"] = "On"				-- Combat plates

				LeaPlusDB["NoAlerts"] = "On"					-- Hide alerts
				LeaPlusDB["NoAchieveAlerts"] = "On"				-- Hide achievement alerts
				LeaPlusDB["NoEncounterAlerts"] = "On"			-- Hide encounter alerts
				LeaPlusDB["NoGarrisonAlerts"] = "On"			-- Hide order hall and garrison alerts
				LeaPlusDB["NoLootAlerts"] = "On"				-- Hide loot alerts
				LeaPlusDB["NoProfessionAlerts"] = "On"			-- Hide profession alerts

				LeaPlusDB["HideBodyguard"] = "On"				-- Hide bodyguard window
				LeaPlusDB["HideTalkingFrame"] = "On"			-- Hide talking frame
				LeaPlusDB["HideCleanupBtns"] = "On"				-- Hide cleanup buttons
				LeaPlusDB["HideBossBanner"] = "On"				-- Hide boss banner
				LeaPlusDB["HideLevelUpDisplay"] = "On"			-- Hide level-up display
				LeaPlusDB["NoGryphons"] = "On"					-- Hide gryphons
				LeaPlusDB["NoClassBar"] = "On"					-- Hide stance bar
				LeaPlusDB["NoCommandBar"] = "On"				-- Hide order hall bar

				-- System
				LeaPlusDB["NoShaders"] = "On"					-- Manage effects
				LeaPlusDB["MaxCameraZoom"] = "On"				-- Max camera zoom
				LeaPlusDB["ViewPortEnable"] = "On"				-- Enable viewport
				LeaPlusDB["ViewPortResize"] = "On"				-- Resize game world
				LeaPlusDB["NoRestedEmotes"] = "On"				-- Silence rested emotes

				LeaPlusDB["NoBagAutomation"] = "On"				-- Disable bag automation
				LeaPlusDB["NoPetAutomation"] = "On"				-- Disable pet automation
				LeaPlusDB["CharAddonList"] = "On"				-- Show character addons
				LeaPlusDB["NoRaidRestrictions"] = "On"			-- Remove raid restrictions
				LeaPlusDB["NoConfirmLoot"] = "On"				-- Disable loot warnings
				LeaPlusDB["NoMapEmote"] = "On"					-- Disable map emote
				LeaPlusDB["SkipCinematics"] = "Off"				-- Skip cinematics
				LeaPlusDB["FasterLooting"] = "On"				-- Faster auto loot
				LeaPlusDB["LockoutSharing"] = "On"				-- Lockout sharing

				-- Settings
				LeaPlusDB["HotkeyMenu"] = 2						-- Leatrix Plus hotkey

				-- Function to assign cooldowns
				local function setIcon(pclass, pspec, sp1, st1, pt1, sp2, st2, pt2, sp3, st3, pt3, sp4, st4, pt4, sp5, st5, pt5)
					-- Set spell ID
					if sp1 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Idn"] = sp1 end
					if sp2 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Idn"] = sp2 end
					if sp3 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Idn"] = sp3 end
					if sp4 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Idn"] = sp4 end
					if sp5 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Idn"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Idn"] = sp5 end
					-- Set stack
					if st1 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Stk"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Stk"] = st1 end
					if st2 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Stk"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Stk"] = st2 end
					if st3 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Stk"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Stk"] = st3 end
					if st4 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Stk"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Stk"] = st4 end
					if st5 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Stk"] = "" else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Stk"] = st5 end
					-- Set pet
					if pt1 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R1Pet"] = true end
					if pt2 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R2Pet"] = true end
					if pt3 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R3Pet"] = true end
					if pt4 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R4Pet"] = true end
					if pt5 == 0 then LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Pet"] = false else LeaPlusDB["Cooldowns"][pclass]["S" .. pspec .. "R5Pet"] = true end
				end

				-- Create main table
				LeaPlusDB["Cooldowns"] = {}

				-- Create class tables
				for index = 1, GetNumClasses() do
					local classDisplayName, classTag, classID = GetClassInfo(index)
					LeaPlusDB["Cooldowns"][classTag] = {}
				end

				-- Assign cooldowns
				setIcon("WARRIOR", 		1, --[[Arms]] 		 	--[[1]] 32216, 0, 0, 	--[[2]] 209574, 0, 0, 	--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Victory Rush, Shattered Defences
				setIcon("WARRIOR", 		2, --[[Fury]]  			--[[1]] 32216, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Victory Rush
				setIcon("WARRIOR", 		3, --[[Protection]]  	--[[1]] 32216, 0, 0, 	--[[2]] 190456, 0, 0, 	--[[3]] 132404, 0, 0, 	--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Victory Rush, Ignore Pain, Shield Block

				setIcon("PALADIN", 		1, --[[Holy]]  			--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 203539, 0, 0, 	--[[4]] 203528, 0, 0, 	--[[5]] 203538, 0, 0) -- nil, nil, Wisdom, Might, Kings
				setIcon("PALADIN", 		2, --[[Protection]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 203539, 0, 0, 	--[[4]] 203528, 0, 0, 	--[[5]] 203538, 0, 0) -- nil, nil, Wisdom, Might, Kings
				setIcon("PALADIN", 		3, --[[Retribution]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 203539, 0, 0, 	--[[4]] 203528, 0, 0, 	--[[5]] 203538, 0, 0) -- nil, nil, Wisdom, Might, Kings

				setIcon("SHAMAN", 		1, --[[Elemental]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 215864, 0, 0, 	--[[5]] 546, 0, 0) -- nil, nil, nil, Rainfall, Water Walking
				setIcon("SHAMAN", 		2, --[[Enhancement]]  	--[[1]] 194084, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 215864, 0, 0, 	--[[5]] 546, 0, 0) -- Flametongue, nil, nil, Rainfall, Water Walking
				setIcon("SHAMAN", 		3, --[[Resto]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 215864, 0, 0, 	--[[5]] 546, 0, 0) -- nil, nil, nil, Rainfall, Water Walking

				setIcon("ROGUE", 		1, --[[Assassination]]  --[[1]] 1784, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 2823, 0, 0, 	--[[5]] 3408, 0, 0) -- Stealth, nil, nil, Deadly Poison, Crippling Poison
				setIcon("ROGUE", 		2, --[[Outlaw]]  		--[[1]] 1784, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 2823, 0, 0, 	--[[5]] 3408, 0, 0) -- Stealth, nil, nil, Deadly Poison, Crippling Poison
				setIcon("ROGUE", 		3, --[[Subtetly]]  		--[[1]] 1784, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 2823, 0, 0, 	--[[5]] 3408, 0, 0) -- Stealth, nil, nil, Deadly Poison, Crippling Poison

				setIcon("DRUID", 		1, --[[Balance]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("DRUID", 		2, --[[Feral]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("DRUID", 		3, --[[Guardian]]  		--[[1]] 192081, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Ironfur
				setIcon("DRUID", 		4, --[[Resto]]			--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)

				setIcon("MONK", 		1, --[[Brewmaster]]  	--[[1]] 125359, 0, 0,	--[[2]] 115307, 0, 0, 	--[[3]] 124274, 0, 0, 	--[[4]] 124273, 0, 0, 	--[[5]] 116781, 0, 0) -- Tiger Power, Shuffle, Moderate Stagger, Heavy Stagger, Legacy of the White Tiger
				setIcon("MONK", 		2, --[[Mistweaver]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("MONK", 		3, --[[Windwalker]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)

				setIcon("MAGE", 		1, --[[Arcane]]  		--[[1]] 235450, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Prismatic Barrier
				setIcon("MAGE", 		2, --[[Fire]]  			--[[1]] 235313, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Blazing Barrier
				setIcon("MAGE", 		3, --[[Frost]]  		--[[1]] 11426, 0, 0, 	--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Ice Barrier

				setIcon("WARLOCK", 		1, --[[Affliction]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("WARLOCK", 		2, --[[Demonology]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("WARLOCK", 		3, --[[Destruction]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)

				setIcon("PRIEST", 		1, --[[Discipline]]  	--[[1]] 17, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Power Word: Shield
				setIcon("PRIEST", 		2, --[[Holy]]  			--[[1]] 17, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Power Word: Shield
				setIcon("PRIEST", 		3, --[[Shadow]]  		--[[1]] 17, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0) -- Power Word: Shield

				setIcon("HUNTER", 		1, --[[Beast Mastery]]  --[[1]] 136, 0, 1, 		--[[2]] 118455, 0, 1, 	--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 5384, 0, 0) -- Mend Pet, nil, nil, nil, Feign Death
				setIcon("HUNTER", 		2, --[[Marksmanship]]  	--[[1]] 136, 0, 1, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 5384, 0, 0) -- Mend Pet, nil, nil, nil, Feign Death
				setIcon("HUNTER", 		3, --[[Survival]]  		--[[1]] 136, 0, 1, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 5384, 0, 0) -- Mend Pet, nil, nil, nil, Feign Death

				setIcon("DEATHKNIGHT", 	1, --[[Blood]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("DEATHKNIGHT", 	2, --[[Frost]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("DEATHKNIGHT", 	3, --[[Unholy]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)

				setIcon("DEMONHUNTER", 	1, --[[Havoc]]  		--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)
				setIcon("DEMONHUNTER", 	2, --[[Vengeance]]  	--[[1]] 0, 0, 0, 		--[[2]] 0, 0, 0, 		--[[3]] 0, 0, 0, 		--[[4]] 0, 0, 0, 		--[[5]] 0, 0, 0)

				-- Other code
				-- SetCVar("weatherDensity", "0")

				-- Reload
				ReloadUI()
			else
				LeaPlusLC:Print("Invalid parameter.")
			end
			return
		else
			-- Toggle the options panel if game options panel is not showing
			if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
			if LeaPlusLC:IsPlusShowing() then
				LeaPlusLC:HideFrames()
				LeaPlusLC:HideConfigPanels()
			else
				LeaPlusLC:HideFrames()
				LeaPlusLC["PageF"]:Show()
			end
			LeaPlusLC["Page"..LeaPlusLC["LeaStartPage"]]:Show()
		end
	end

	-- Slash command for global function
	_G.SLASH_Leatrix_Plus1 = "/ltp"
	_G.SLASH_Leatrix_Plus2 = "/leaplus" 
	_G.SLASH_Leatrix_Plus3 = "/百寶箱" 
	_G.SLASH_Leatrix_Plus4 = "/功能百寶箱" 
	SlashCmdList["Leatrix_Plus"] = function(self)
		-- Run slash command function
		LeaPlusLC:SlashFunc(self)
		-- Redirect tainted variables
		RunScript('ACTIVE_CHAT_EDIT_BOX = ACTIVE_CHAT_EDIT_BOX')
		RunScript('LAST_ACTIVE_CHAT_EDIT_BOX = LAST_ACTIVE_CHAT_EDIT_BOX')
	end

	-- Slash command for UI reload
	_G.SLASH_LEATRIX_PLUS_RL1 = "/rl"
	SlashCmdList["LEATRIX_PLUS_RL"] = function()
		ReloadUI()
	end

----------------------------------------------------------------------
-- 	Create options panel pages (no content yet)
----------------------------------------------------------------------

	-- Function to add menu button
	function LeaPlusLC:MakeMN(name, text, parent, anchor, x, y, width, height)

		local mbtn = CreateFrame("Button", nil, parent)
		LeaPlusLC[name] = mbtn
		mbtn:Show();
		mbtn:SetSize(width, height)
		mbtn:SetAlpha(1.0)
		mbtn:SetPoint(anchor, x, y)

		mbtn.t = mbtn:CreateTexture(nil, "BACKGROUND")
		mbtn.t:SetAllPoints()
		mbtn.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
		mbtn.t:SetAlpha(0.7)
		mbtn.t:Hide()

		mbtn.s = mbtn:CreateTexture(nil, "BACKGROUND")
		mbtn.s:SetAllPoints()
		mbtn.s:SetColorTexture(0.3, 0.3, 0.00, 0.8)
		mbtn.s:Hide()

		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetPoint('LEFT', 16, 0)
		mbtn.f:SetText(L[text])
	
		mbtn:SetScript("OnEnter", function()
			mbtn.t:Show()
		end)

		mbtn:SetScript("OnLeave", function()
			mbtn.t:Hide()
		end)

		return mbtn, mbtn.s

	end

	-- Function to create individual options panel pages
	function LeaPlusLC:MakePage(name, title, menu, menuname, menuparent, menuanchor, menux, menuy, menuwidth, menuheight)

		-- Create frame
		local oPage = CreateFrame("Frame", nil, LeaPlusLC["PageF"]); 
		LeaPlusLC[name] = oPage
		oPage:SetAllPoints(LeaPlusLC["PageF"])
		oPage:Hide();

		-- Add page title
		oPage.s = oPage:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		oPage.s:SetPoint('TOPLEFT', 146, -16)
		oPage.s:SetText(L[title])

		-- Add menu item if needed
		if menu then
			LeaPlusLC[menu], LeaPlusLC[menu .. ".s"] = LeaPlusLC:MakeMN(menu, menuname, menuparent, menuanchor, menux, menuy, menuwidth, menuheight)
			LeaPlusLC[name]:SetScript("OnShow", function() LeaPlusLC[menu .. ".s"]:Show(); end)
			LeaPlusLC[name]:SetScript("OnHide", function() LeaPlusLC[menu .. ".s"]:Hide(); end)
		end

		return oPage;
	
	end

	-- Create options pages
	LeaPlusLC["Page0"] = LeaPlusLC:MakePage("Page0", "Home"			, "LeaPlusNav0", "Home"			, LeaPlusLC["PageF"], "TOPLEFT", 16, -72, 112, 20)
	LeaPlusLC["Page1"] = LeaPlusLC:MakePage("Page1", "Automation"	, "LeaPlusNav1", "Automation"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -112, 112, 20)
	LeaPlusLC["Page2"] = LeaPlusLC:MakePage("Page2", "Social"		, "LeaPlusNav2", "Social"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -132, 112, 20)
	LeaPlusLC["Page3"] = LeaPlusLC:MakePage("Page3", "Chat"			, "LeaPlusNav3", "Chat"			, LeaPlusLC["PageF"], "TOPLEFT", 16, -152, 112, 20)
	LeaPlusLC["Page4"] = LeaPlusLC:MakePage("Page4", "Text"			, "LeaPlusNav4", "Text"			, LeaPlusLC["PageF"], "TOPLEFT", 16, -172, 112, 20)
	LeaPlusLC["Page5"] = LeaPlusLC:MakePage("Page5", "Interface"	, "LeaPlusNav5", "Interface"	, LeaPlusLC["PageF"], "TOPLEFT", 16, -192, 112, 20)
	LeaPlusLC["Page6"] = LeaPlusLC:MakePage("Page6", "Frames"		, "LeaPlusNav6", "Frames"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -212, 112, 20)
	LeaPlusLC["Page7"] = LeaPlusLC:MakePage("Page7", "System"		, "LeaPlusNav7", "System"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -232, 112, 20)
	LeaPlusLC["Page8"] = LeaPlusLC:MakePage("Page8", "Settings"		, "LeaPlusNav8", "Settings"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -272, 112, 20)
	LeaPlusLC["Page9"] = LeaPlusLC:MakePage("Page9", "Media"		, "LeaPlusNav9", "Media"		, LeaPlusLC["PageF"], "TOPLEFT", 16, -292, 112, 20)

	-- Page navigation mechanism
	for i = 0, LeaPlusLC["NumberOfPages"] do
		LeaPlusLC["LeaPlusNav"..i]:SetScript("OnClick", function()
			LeaPlusLC:HideFrames()
			LeaPlusLC["PageF"]:Show();
			LeaPlusLC["Page"..i]:Show();
			LeaPlusLC["LeaStartPage"] = i
		end)
	end

	-- Use a variable to contain the page number (makes it easier to move options around)
	local pg;

----------------------------------------------------------------------
-- 	LC0: Welcome
----------------------------------------------------------------------

	pg = "Page0";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Welcome to Leatrix Plus.", 146, -72);
	LeaPlusLC:MakeWD(LeaPlusLC[pg], "To begin, choose an options page.", 146, -92);

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Support", 146, -132);
	LeaPlusLC:MakeWD(LeaPlusLC[pg], "www.leatrix.com", 146, -152);

----------------------------------------------------------------------
-- 	LC1: Automation
----------------------------------------------------------------------

	pg = "Page1";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Character"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutomateQuests"			,	"Automate quests"				,	146, -92, 	true,	"If checked, quests will be selected, accepted and turned-in automatically.|n|nYou can hold the shift key down when you talk to a quest giver to override this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutomateGossip"			,	"Automate gossip"				,	146, -112, 	true,	"If checked, you can hold a designated modifier key while opening a gossip window to automatically select a single gossip option.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoAcceptSummon"			,	"Accept summon"					, 	146, -132, 	false,	"If checked, summon requests will be accepted automatically unless you are in combat.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoAcceptRes"				,	"Accept resurrection"			, 	146, -152, 	false,	"If checked, resurrection requests will be accepted automatically.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoReleasePvP"			,	"Release in PvP"				, 	146, -172, 	false,	"If checked, you will release automatically after you die in a designated PvP zone.|n|nYou will not release automatically if you have the ability to self-resurrect (soulstone, reincarnation, etc).")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Vendors"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoSellJunk"				,	"Sell junk automatically"		,	340, -92, 	true,	"If checked, all grey items in your bags will be sold automatically when you visit a merchant.|n|nYou can hold the shift key down when you talk to a merchant to override this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoRepairOwnFunds"		, 	"Repair automatically"			,	340, -112, 	true,	"If checked, your gear will be repaired automatically when you visit a suitable merchant.|n|nYou can hold the shift key down when you talk to a merchant to override this setting.")

	LeaPlusLC:CfgBtn("AutoGossipBtn", LeaPlusCB["AutomateGossip"])
	LeaPlusLC:CfgBtn("AutoResBtn", LeaPlusCB["AutoAcceptRes"])
	LeaPlusLC:CfgBtn("AutoReleaseBtn", LeaPlusCB["AutoReleasePvP"])
 	LeaPlusLC:CfgBtn("SellJunkBtn", LeaPlusCB["AutoSellJunk"])
 	LeaPlusLC:CfgBtn("RepairBtn", LeaPlusCB["AutoRepairOwnFunds"])

----------------------------------------------------------------------
-- 	LC2: Social
----------------------------------------------------------------------

	pg = "Page2";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Blocks"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoDuelRequests"			, 	"Block duels"					,	146, -92, 	false,	"If checked, duel requests will be blocked unless the player requesting the duel is in your friends list or guild.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoPetDuels"				, 	"Block pet battle duels"		,	146, -112, 	false,	"If checked, pet battle duel requests will be blocked unless the player requesting the duel is in your friends list or guild.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoPartyInvites"			, 	"Block party invites"			, 	146, -132, 	false,	"If checked, party invitations will be blocked unless the player inviting you is in your friends list or guild.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoFriendRequests"			, 	"Block friend requests"			, 	146, -152, 	false,	"If checked, BattleTag and Real ID friend requests will be automatically declined.|n|nEnabling this option will automatically decline any pending requests.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Groups"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AcceptPartyFriends"		, 	"Party from friends"			, 	340, -92, 	false,	"If checked, party invitations from friends or guild members will be automatically accepted unless you are queued in Dungeon Finder.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AutoConfirmRole"			, 	"Queue from friends"			,	340, -112, 	false,	"If checked, requests initiated by your party leader to join the Dungeon Finder queue will be automatically accepted if the party leader is in your friends list or guild.|n|nThis option requires that you have selected a role for your character in the Dungeon Finder window.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "InviteFromWhisper"			,   "Invite from whispers"			,	340, -132,	false,	"If checked, a group invite will be automatically sent to anyone who whispers a designated keyword to you.|n|nYou need to be either ungrouped or party leader in your own group for this to work.")

 	LeaPlusLC:CfgBtn("InvWhisperBtn", LeaPlusCB["InviteFromWhisper"])

----------------------------------------------------------------------
-- 	LC3: Chat
----------------------------------------------------------------------

	pg = "Page3";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Chat Frame"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UseEasyChatResizing"		,	"Use easy resizing"				,	146, -92,	true,	"If checked, dragging the General chat tab while the chat frame is locked will expand the chat frame upwards.|n|n\If the chat frame is unlocked, dragging the General chat tab will move the chat frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoCombatLogTab" 			, 	"Hide the combat log"			, 	146, -112, 	true,	"If checked, the combat log will be hidden.|n|nThe combat log must be docked in order for this option to work.|n|nIf the combat log is undocked, you can dock it by dragging the tab (and reloading your UI) or by resetting the chat windows (from the chat menu).")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoChatButtons"				,	"Hide chat buttons"				,	146, -132,	true,	"If checked, chat frame buttons will be hidden.|n|nClicking chat tabs will automatically show the latest messages.|n|nUse the mouse wheel to scroll through the chat history.  Hold down SHIFT for page jump or CTRL to jump to the top or bottom of the chat history.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoSocialButton"			,	"Hide social button"			,	146, -152,	true,	"If checked, the social button and quick-join notification will be hidden.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UnclampChat"				,	"Unclamp chat frame"			,	146, -172,	true,	"If checked, you will be able to drag the chat frame to the edge of the screen.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MoveChatEditBoxToTop" 		, 	"Move editbox to top"			,	146, -192, 	true,	"If checked, the editbox will be moved to the top of the chat frame.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Mechanics"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoStickyChat"				, 	"Disable sticky chat"			,	340, -92,	true,	"If checked, sticky chat will be disabled.|n|nNote that this does not apply to temporary chat windows.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UseArrowKeysInChat"		, 	"Use arrow keys in chat"		, 	340, -112, 	true,	"If checked, you can press the arrow keys to move the insertion point left and right in the chat frame.|n|nIf unchecked, the arrow keys will use the default keybind setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoChatFade"				, 	"Disable chat fade"				, 	340, -132, 	true,	"If checked, chat text will not fade out after a time period.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "UnivGroupColor"			,	"Universal group color"			,	340, -152,	true,	"If checked, raid chat and instance chat will both be colored blue (to match the default party chat color).")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "Manageclasscolors"			,	"Use class colors in chat"		,	340, -172,	true,	"If checked, class colors will be used in the chat frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "RecentChatWindow"			,	"Recent chat window"			, 	340, -192, 	true,	"If checked, you can hold down CTRL and click a chat tab to view recent chat in a copy-friendly window.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MaxChatHstory"				,	"Increase chat history"			, 	340, -212, 	true,	"If checked, your chat history will increase to 4096 lines.  If unchecked, the default will be used (128 lines).|n|nEnabling this option may prevent some chat text from showing during login.")

	LeaPlusLC:CfgBtn("RecentChatBtn", LeaPlusCB["RecentChatWindow"])

----------------------------------------------------------------------
-- 	LC4: Text
----------------------------------------------------------------------

	pg = "Page4";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Visibility"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideErrorFrameText"		, 	"Hide error messages"			,	146, -92, 	true,	"If checked, error messages (such as 'Not enough rage') will not be shown.|n|nIf you have the minimap button enabled, you can hold down CTRL and right-click it to toggle error messages without affecting this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoHitIndicators"			, 	"Hide portrait numbers"			,	146, -112, 	true,	"If checked, damage and healing numbers in the player and pet portrait frames will be hidden.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideCraftedNames"			, 	"Hide crafted names"			,	146, -132, 	true,	"If checked, crafted items will no longer show the name of the crafter.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideZoneText"				,	"Hide zone text"				,	146, -152, 	true,	"If checked, zone text will not be shown (eg. 'Ironforge').")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideSubzoneText"			, 	"Hide subzone text"				,	146, -172, 	true,	"If checked, subzone text will not be shown (eg. 'Mystic Quarter').")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Text Size"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MailFontChange"			,	"Resize mail text"				, 	340, -92, 	true,	"If checked, you will be able to change the font size of standard mail text.|n|nThis does not affect mail created using templates (such as auction house invoices).")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "QuestFontChange"			,	"Resize quest text"				, 	340, -112, 	true,	"If checked, you will be able to change the font size of quest text.|n|nEnabling this option will also change the text size of other frames which inherit the same font (such as the Dungeon Finder frame).")

	LeaPlusLC:CfgBtn("HideErrorsBtn", LeaPlusCB["HideErrorFrameText"])
	LeaPlusLC:CfgBtn("MailTextBtn", LeaPlusCB["MailFontChange"])
	LeaPlusLC:CfgBtn("QuestTextBtn", LeaPlusCB["QuestFontChange"])

----------------------------------------------------------------------
-- 	LC5: Interface
----------------------------------------------------------------------

	pg = "Page5";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Enhancements"				, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowMapMod"				, 	"Enhance world map"				, 	146, -92, 	true,	"If checked, you will be able to reveal unexplored areas of the map and show cursor coordinates at the top of the map.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MinimapMod"				,	"Customise minimap"				, 	146, -112, 	true,	"If checked, you will be able to customise and rescale the minimap.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "TipModEnable"				,	"Manage tooltip"				,	146, -132, 	true,	"If checked, the tooltip will be color coded and you will be able to modify the tooltip layout and scale.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "EnhanceDressup"			, 	"Enhance dressup"				,	146, -152, 	true,	"If checked, additional functionality will be added to the dressup frames.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Extras"					, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowVolume"				, 	"Show volume slider"			, 	340, -92, 	true,	"If checked, a master volume slider will be shown on the character sheet.|n|nThe volume slider can be placed in either of two locations on the character sheet.  To toggle between them, hold the shift key down and right-click the slider.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "AhExtras"					, 	"Show auction controls"			, 	340, -112, 	true,	"If checked, additional functionality will be added to the auction house.|n|nBuyout only - create buyout auctions without filling in the starting price.|n|nGold only - set the copper and silver prices at 99 to speed up new auctions.|n|nFind item - search the auction house for the item you are selling.|n|nIn addition, the auction price type and duration settings will be saved account-wide.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "StaticCoordsEn"			, 	"Show coordinates"				, 	340, -132, 	true,	"If checked, coordinates representing your character's location will be shown in a movable, customisable frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowCooldowns"				, 	"Show cooldowns"				, 	340, -152, 	true,	"If checked, you will be able to place up to five beneficial cooldown icons above the target or player frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "DurabilityStatus"			, 	"Show durability status"		, 	340, -172, 	true,	"If checked, a button will be added to the character sheet which will show your equipped item durability when you hover the pointer over it.|n|nIn addition, an overall percentage will be shown in the chat frame when you die.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowPetSaveBtn"			, 	"Show pet save button"			, 	340, -192, 	true,	"If checked, you will be able to save your current battle pet team (including abilities) to a single command.|n|nA button will be added to the Pet Journal.  Clicking the button will toggle showing the assignment command for your current team.  Pressing CTRL/C will copy the command to memory.|n|nYou can then paste the command (with CTRL/V) into the chat window or a macro to instantly assign your team.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowWowheadLinks"			, 	"Show Wowhead links"			, 	340, -212, 	true,	"If checked, Wowhead links will be shown in the world map frame, the achievements frame and the encounter journal frame.")

	LeaPlusLC:CfgBtn("EnhanceMapButton", LeaPlusCB["ShowMapMod"])
	LeaPlusLC:CfgBtn("ModMinimapBtn", LeaPlusCB["MinimapMod"])
	LeaPlusLC:CfgBtn("MoveTooltipButton", LeaPlusCB["TipModEnable"])
	LeaPlusLC:CfgBtn("ModDressupBtn", LeaPlusCB["EnhanceDressup"])
	LeaPlusLC:CfgBtn("ModStaticCoordsBtn", LeaPlusCB["StaticCoordsEn"])
	LeaPlusLC:CfgBtn("CooldownsButton", LeaPlusCB["ShowCooldowns"])

----------------------------------------------------------------------
-- 	LC6: Frames
----------------------------------------------------------------------

	pg = "Page6";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Features"					, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "FrmEnabled"				,	"Manage frames"					, 	146, -92, 	true,	"If checked, you will be able to change the position and scale of the player frame, target frame, world state, ghost frame and timer bar.  Your layout will be saved account-wide.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ManageBuffFrame"			, 	"Manage buff frame"				,	146, -112, 	true,	"If checked, you will be able to change the position and scale of the buff frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ClassColFrames"			, 	"Class colored frames"			,	146, -132, 	true,	"If checked, you will be able to show class coloring in the player frame, target frame and focus frame backgrounds.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowPlayerChain"			, 	"Show player chain"				,	146, -152, 	true,	"If checked, you will be able to show a rare, elite or rare elite chain around the player frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowRaidToggle"			, 	"Raid frame toggle"				,	146, -172, 	true,	"If checked, the button to toggle the raid container frame will be shown just above the raid management frame (left side of the screen) instead of in the raid management frame itself.|n|nThis allows you to toggle the raid container frame without needing to open the raid management frame.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "CombatPlates"				, 	"Combat plates"					,	146, -192, 	true,	"If checked, enemy nameplates will be shown during combat and hidden when combat ends.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Visibility"				, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoAlerts"					,	"Hide alerts"					, 	340, -92, 	true,	"If checked, you will be able to hide alert frames.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideBodyguard"				, 	"Hide bodyguard gossip"			, 	340, -112, 	true,	"If checked, the gossip window will not be shown when you talk to an active garrison bodyguard.|n|nYou can hold the shift key down when you talk to a bodyguard to override this setting.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideTalkingFrame"			, 	"Hide talking frame"			, 	340, -132, 	true,	"If checked, the talking frame will not be shown.|n|nThe talking frame normally appears in the lower portion of the screen when certain NPCs communicate with you.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideCleanupBtns"			, 	"Hide clean-up buttons"			, 	340, -152, 	true,	"If checked, the backpack clean-up button and the bank frame clean-up button will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideBossBanner"			, 	"Hide boss banner"				, 	340, -172, 	true,	"If checked, the boss banner will not be shown.|n|nThe boss banner appears when a boss is defeated.  It shows the name of the boss and the loot that was distributed.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "HideLevelUpDisplay"		, 	"Hide level-up display"			, 	340, -192, 	true,	"If checked, the level-up display will not be shown.|n|nThe level-up display shows encounter objectives, level-ups, pet battle rewards, etc.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoGryphons"				,	"Hide gryphons"					, 	340, -212, 	true,	"If checked, the main bar gryphons will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoClassBar"				,	"Hide stance bar"				, 	340, -232, 	true,	"If checked, the stance bar will not be shown.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoCommandBar"				,	"Hide order hall bar"			, 	340, -252, 	true,	"If checked, the order hall command bar will not be shown.")

	LeaPlusLC:CfgBtn("NoAlertsBtn", LeaPlusCB["NoAlerts"])
	LeaPlusLC:CfgBtn("MoveFramesButton", LeaPlusCB["FrmEnabled"])
	LeaPlusLC:CfgBtn("ClassFramesBtn", LeaPlusCB["ClassColFrames"])
	LeaPlusLC:CfgBtn("ModPlayerChain", LeaPlusCB["ShowPlayerChain"])
	LeaPlusLC:CfgBtn("ManageBuffBtn", LeaPlusCB["ManageBuffFrame"])

----------------------------------------------------------------------
-- 	LC7: System
----------------------------------------------------------------------

	pg = "Page7";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Graphics and Sound"		, 	146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoShaders"					, 	"Manage effects"				, 	146, -92, 	true,	"If checked, you will be able to disable the screen glow, the grey screen of death and the netherworld effect.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "MaxCameraZoom"				, 	"Max camera zoom"				, 	146, -112, 	true,	"If checked, you will be able to zoom out to a greater distance.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ViewPortEnable"			,	"Enable viewport"				,	146, -132, 	true,	"If checked, you will be able to create a viewport.  A viewport adds adjustable black borders around the game world.|n|nThe borders are placed on top of the game world but under the UI so you can place UI elements over them.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoRestedEmotes"			, 	"Silence rested emotes"			,	146, -152, 	true,	"If checked, emote sounds will be silenced while your character is:|n|n- resting|n- in a pet battle|n- at the Hathill Market|n- at the Grim Guzzler|n|nEmote sounds will be enabled when none of the above apply.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Game Options"				, 	340, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoBagAutomation"			, 	"Disable bag automation"		, 	340, -92, 	true,	"If checked, your bags will not be opened or closed automatically when you interact with a merchant, bank or mailbox.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoPetAutomation"			, 	"Disable pet automation"		, 	340, -112, 	true, 	"If checked, battle pets which are automatically summoned will be dismissed within a few seconds.|n|nThis includes dragging a pet onto the first team slot in the pet journal and entering a battle pet team save command.|n|nNote that pets which are automatically summoned during combat will be dismissed when combat ends.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "CharAddonList"				, 	"Show character addons"			, 	340, -132, 	true,	"If checked, the addon list (accessible from the game menu) will show character based addons by default.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoRaidRestrictions"		, 	"Remove raid restrictions"		,	340, -152, 	true,	"If checked, your low level characters will be allowed to join raid groups.|n|nNote that you cannot join a raid group directly with a low level character.  You have to join a party group first then the party leader should convert the party group to a raid group.|n|nReload your UI if the group leader is unable to convert the party group to a raid group.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoConfirmLoot"				, 	"Disable loot warnings"			,	340, -172, 	false,	"If checked, confirmations will no longer appear when you choose a loot roll option or attempt to sell or mail a tradable item.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "NoMapEmote"				, 	"Disable map emote"				,	340, -192, 	true,	"If checked, your character will not perform the reading emote when you open the map.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "SkipCinematics"			, 	"Skip cinematics"				,	340, -212, 	true,	"If checked, in-game cinematics will be skipped if at all possible.|n|nYou can hold the shift key down when a cinematic is about to start to override this setting.|n|nNote that some cinematics cannot be skipped.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "FasterLooting"				, 	"Faster auto loot"				,	340, -232, 	true,	"If checked, the amount of time it takes to auto loot creatures will be significantly reduced.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "LockoutSharing"			, 	"Lockout sharing"				, 	340, -252, 	true, 	"If checked, the 'Display only character achievements to others' setting in the game options panel ('Social' menu) will be permanently checked and locked.")

	LeaPlusLC:CfgBtn("NoShadersBtn", LeaPlusCB["NoShaders"])
	LeaPlusLC:CfgBtn("ModViewportBtn", LeaPlusCB["ViewPortEnable"])

----------------------------------------------------------------------
-- 	LC8: Settings
----------------------------------------------------------------------

	pg = "Page8";

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Addon"						, 146, -72);
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "ShowMinimapIcon"			, "Show minimap button"				, 146, -92,		true,	"If checked, a minimap button will be available.|n|nClick - Toggle options panel.|n|nSHIFT/Left-click - Toggle music.|n|nSHIFT/Right-click - Toggle coordinates (if enabled).|n|nCTRL/Left-click - Toggle minimap target tracking.|n|nCTRL/Right-click - Toggle errors (if enabled).|n|nCTRL/SHIFT/Left-click - Toggle Zygor (if installed).|n|nCTRL/SHIFT/Right-click - Toggle windowed mode.")
	LeaPlusLC:MakeCB(LeaPlusLC[pg], "EnableHotkey"				, "Enable hotkey"					, 146, -112,	true,	"If checked, you will be able to open Leatrix Plus by pressing a designated hotkey.")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Scale", 340, -72);
	LeaPlusLC:MakeSL(LeaPlusLC[pg], "PlusPanelScale", "", 1, 2, 0.1, 340, -92, "%.1f")

	LeaPlusLC:MakeTx(LeaPlusLC[pg], "Transparency", 340, -132);
	LeaPlusLC:MakeSL(LeaPlusLC[pg], "PlusPanelAlpha", "", 0, 1, 0.1, 340, -152, "%.1f")

	LeaPlusLC:CfgBtn("HotkeyBtn", LeaPlusCB["EnableHotkey"])

	LeaPlusLC:ShowMemoryUsage(LeaPlusLC[pg], "TOPLEFT", 146, -262)
