local NAME, S = ...
local ACD = LibStub("AceConfigDialog-3.0")

local InterfaceOptionsFrameAddOns = _G.InterfaceOptionsFrameAddOns
local OptionsListButtonToggle_OnClick = _G.OptionsListButtonToggle_OnClick
	---------------------
	--- LibDataBroker ---
	---------------------

local dataobject = {
	type = "data source",
	icon = "Interface\\Icons\\Warrior_DisruptingShout",
	OnClick = function(clickedframe, button)
		-- for i, button in ipairs(InterfaceOptionsFrameAddOns.buttons) do
			-- if button.element and button.element.name == NAME and button.element.collapsed then
				-- OptionsListButtonToggle_OnClick(button.toggle)
			-- end
		-- end	
		if ACD.OpenFrames[NAME] then
			ACD:Close(NAME)
		else
			ACD:Open(NAME)
		end		
	--	InterfaceOptionsFrame_OpenToCategory("Objective Announcer")
	end,
	OnTooltipShow = function(tt)
		tt:AddLine("|cffADFF2F"..S.NAME.."|r")
		tt:AddLine("Click to open configuration.")
	end,	
}

LibStub("LibDataBroker-1.1"):NewDataObject(NAME, dataobject)