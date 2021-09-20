--[[
Copyright 2012-2017 João Cardoso
PetTracker is distributed under the terms of the GNU General Public License (Version 3).
As a special exception, the copyright holders of this addon do not give permission to
redistribute and/or modify it.

This addon is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with the addon. If not, see <http://www.gnu.org/licenses/gpl-3.0.txt>.

This file is part of PetTracker.
--]]

local Addon, ADDON = PetTracker, 'PetTracker'
local Menus = Addon:NewModule('Menus')
local Questions = Addon.Locals.FAQ

function Menus:Startup()
	local Options = self:CreatePanel(Addon.Locals.BattlePet)
	Options:SetChildren(function(self)
		Addon:ForAllModules('AddOptions', self)
	end)

	local Help = self:CreatePanel(HELP_LABEL, Addon.Locals.BattlePet)
	Help:SetChildren(function(self)
		for i = 1, #Questions, 2 do
			local question = self:CreateChild('Header')
			question:SetWidth(400)
			question:SetFont('GameFontNormal')
			question:SetText(Questions[i])

			local answer = self:CreateChild('Header')
			answer:SetWidth(400)
			answer:SetFont('GameFontHighlight')
			answer:SetText(Questions[i+1])
		end
	end)

	local ShowTutorial = SushiButton(Help)
	ShowTutorial:SetText(RESET_TUTORIALS)
	ShowTutorial:SetPoint('LEFT', Help, 'TOP', 170, -70)
	ShowTutorial:SetCall('OnClick', function()
		Addon.Tutorial:Restart()
		HideUIPanel(InterfaceOptionsFrame)
		HideUIPanel(GameMenuFrame)
	end)
end

function Menus:CreatePanel(name, parent)
	local panel = CreateFrame('Frame')
	local group = SushiMagicGroup(panel)

	group:SetAddon(ADDON)
	group:SetFooter('Copyright 2012-2017 João Cardoso')
	panel.parent = parent
	panel.name = name

	InterfaceOptions_AddCategory(panel)
	return group
end

Menus:Startup()