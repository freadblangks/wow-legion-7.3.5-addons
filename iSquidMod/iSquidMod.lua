--[[
	SquidMod
	Author: SAM (recoded by Ganders) - (Grafic Patch by Imithat)
	Version: 2.56
]]

local iSquidMod = CreateFrame("Frame")

local textures = {
	"hide",
	"griffon",
	"lion",
	"diablo1",
	"diablo1_roth",
	"diablo2",
	"diablo2_roth",
	"diablo3crest",
	"murloc",
	"murloc2",
	"crest",
	"hordecrest",
	"orccrest",
	"allianzcrest",
	"huntercrest",
	"druidcrest",
	"pandacrest",
	"nightelfcrest",
	"priestcrest",
	"dkcrest",
	"magecrest",
	"magecrest2",
	"monkcrest",
	"palacrest",
	"roguecrest",
	"shamancrest",
	"shamancrest2",
	"warlockcrest",
	"warriorcrest",
	"undeadcrest",
	"crusadercrest",
	"axecrest",
	"worg",
	"bfmage",
	"panda",
	"pandakind",
	"swking",
	"draenei",
	"druidtree",
	"druidbear",
	"lichking",
	"nightelf",
	"onyxia",
	"orc",
	"orc2",
	"ysera",
	"drake",
	"bleach",
	"wowlogo",
	"orbdaemon",
	"yulon",
	"xuen",
	"niuzao",
	"minichi",
	"minidroplet",
	"miniporcupette",
	"minisha",
	"minixuen",
	"miniyulon",
}

iSquidModDB = 2


MainMenuBarLeftEndCap:SetParent("UIParent")
MainMenuBarRightEndCap:SetParent("UIParent")

function iSquidMod.SlashCommand(msg)
	local self = iSquidMod
	if strlen(msg) > 0 then
		local command = string.lower(msg)
		local help = true
		if ( command == "random" ) then
			command = math.random( #textures )
		end
		if ( type(command) == "string" ) then
			for i,v in ipairs(textures) do
				if ( command == string.lower(v) ) then
					self:Update(i)
					-- DEFAULT_CHAT_FRAME:AddMessage("iSquidMod: "..string.lower(v))
					help = false
				end
			end
		elseif ( type(command) == "number" ) then
			if textures[command] ~= nil then
				self:Update(command)
				-- DEFAULT_CHAT_FRAME:AddMessage("iSquidMod: "..string.lower(textures[command]))
				help = false
			end
		end

		if ( help == true ) then
			for i,v in ipairs(textures) do
				DEFAULT_CHAT_FRAME:AddMessage("iSquidMod: /squid "..v)
			end
		end
	else
		for i,v in ipairs(textures) do
			DEFAULT_CHAT_FRAME:AddMessage("iSquidMod: /squid "..v)
		end
	end
end
		

function iSquidMod:Update(toggle)
	if ( toggle == 1 ) then
		MainMenuBarLeftEndCap:Hide()
		MainMenuBarRightEndCap:Hide()
	elseif ( toggle == 29 ) then
		MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\iSquidMod\\skin\\emblemLeft.tga")
		MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\iSquidMod\\skin\\emblemRight.tga")
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()
	else
		MainMenuBarLeftEndCap:SetTexture("Interface\\AddOns\\iSquidMod\\skin\\"..textures[toggle]..".tga")
		MainMenuBarRightEndCap:SetTexture("Interface\\AddOns\\iSquidMod\\skin\\"..textures[toggle]..".tga")
		MainMenuBarLeftEndCap:Show()
		MainMenuBarRightEndCap:Show()
	end
	iSquidModDB = toggle
end

iSquidMod:SetScript("OnEvent", function() iSquidMod:Update(iSquidModDB) end)
iSquidMod:RegisterEvent("PLAYER_LOGIN")

SLASH_SQUID1 = "/squid"
SlashCmdList["SQUID"] = iSquidMod.SlashCommand
