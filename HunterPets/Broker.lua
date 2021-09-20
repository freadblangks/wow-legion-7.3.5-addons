local LDB = LibStub:GetLibrary("LibDataBroker-1.1");
local LibQTip = LibStub('LibQTip-1.0')

local falseIcon = ("|T%s:%d|t"):format([[Interface\COMMON\Indicator-Red]], 0)
local trueIcon = ("|T%s:%d|t"):format([[Interface\COMMON\Indicator-Green]], 0)


Broker_HunterPets = LDB:NewDataObject("HunterPets", {
  type = "data source",
  text = "Hunter Pets",
  icon = "Interface\\Icons\\ability_physical_taunt"
})


function Broker_HunterPets:OnEnter()
	DrawTooltip(self)
end

function Broker_HunterPets:OnLeave()
end


function DrawTooltip(anchor)
	local QTip = LibQTip:Acquire("HunterPetsOwned", 3, "LEFT", "CENTER", "CENTER");
	QTip:SetAutoHideDelay(0.1, anchor)
	QTip:SmartAnchorTo(anchor)	
	QTip:Clear()

	QTip:SetCellMarginH(0)
	QTip:SetCellMarginV(1)

	QTip:SetCell(QTip:AddLine(), 1, "HunterPets", GameFontNormalLarge, "CENTER", 0)
	QTip:AddSeparator(1, 0.510, 0.773, 1.0)
	QTip:AddLine(" ");
	QTip:SetCell(QTip:AddLine(), 1, "Settings", GameFontNormal, "CENTER", 0)
	QTip:AddSeparator(1, 0.5, 0.5, 0.5)


	local line = QTip:AddLine();
	QTip:SetCell(line, 1, "Auto open Stabled Browser at stable master")
	if (HunterPetsSettings.autoShowBrowser) then
		QTip:SetCell(line, 3, trueIcon, nil, "RIGHT")
	else
		QTip:SetCell(line, 3, falseIcon, nil, "RIGHT")
	end
	QTip:SetCellScript(line, 1, "OnMouseUp", function() HunterPetsSettings.autoShowBrowser = not HunterPetsSettings.autoShowBrowser; DrawTooltip(anchor) end, "")


	local line = QTip:AddLine();
	QTip:SetCell(line, 1, "Tamable pets zone message")
	if (HunterPetsSettings.showZoneTamableText) then
		QTip:SetCell(line, 3, trueIcon, nil, "RIGHT")
	else
		QTip:SetCell(line, 3, falseIcon, nil, "RIGHT")
	end
	QTip:SetCellScript(line, 1, "OnMouseUp", function() HunterPetsSettings.showZoneTamableText = not HunterPetsSettings.showZoneTamableText; DrawTooltip(anchor) end, "")
	QTip:AddSeparator(1, 0.5, 0.5, 0.5)
	QTip:AddLine(" ");

	QTip:SetCell(QTip:AddLine(), 1, "Pets", GameFontNormal, "CENTER", 0)
	QTip:AddSeparator(1, 0.5, 0.5, 0.5)
	QTip:AddLine("Server - Character", "S","FS")
	QTip:AddSeparator(1, 0.5, 0.5, 0.5)
	for realm in pairs(HunterPetsGlobal.data) do
		for character in pairs(HunterPetsGlobal.data[realm]) do
			local numPets, numScanned = HunterPets:GetNumPets(realm, character)
			if (numPets > 0) then
				QTip:AddLine(realm .. " - " .. character,numPets, numScanned)
			end
		end
	end

	QTip:AddLine(" ")
	local line = QTip:AddLine();
	QTip:SetCell(line,1,"Left-click to toggle Hunter Pets UI");
	QTip:SetCellTextColor(line, 1, 0,1,0,1)

	local line = QTip:AddLine();
	QTip:SetCell(line, 1, "Right-click to toggle Stabled Pets UI")
	QTip:SetCellTextColor(line, 1, 0,1,0,1)
	
	QTip:Show();
	QTip.OnRelease = QTip_OnRelease
end

function Broker_HunterPets:OnClick(button)
	if (button == "LeftButton") then
		HunterPetJournal_Toggle()
	end
	if (button == "RightButton") then
		HunterPetsOwned_Toggle()
	end
end