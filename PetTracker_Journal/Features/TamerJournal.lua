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

local Addon = PetTracker
local Journal = PetTrackerTamerJournal
local L = Addon.Locals


--[[ Startup ]]--

function Journal:Startup()
	HybridScrollFrame_CreateButtons(self.List, 'PetTrackerTamerEntry', 44, 0)
	SetPortraitToTexture(self.portrait, 'Interface/Icons/PetJournalPortrait')

	self.Startup = function() end
	self.TitleText:SetText(L.Rivals)
	self.List.scrollBar.doNotHide = true
	self.Count.Label:SetText(L.TotalTamers)
	self.Count.Number:SetText(#Addon.TamerOrder)
	self.SearchBox:SetText(Addon.Sets.TamerSearch or '')
	self.SearchBox:SetScript('OnTextChanged', self.Search)

	self.Tab1.tip = TEAM
	self.Tab1.Icon:SetTexture('Interface/Icons/ability_hunter_pet_goto')
	self.Tab1.Icon:SetPoint('BOTTOM', 1, 1)
	self.Tab1.Icon:SetSize(27, 29)

	self.Tab2.tip = LOCATION_COLON:sub(0, -2)
	self.Tab2.Icon:SetTexture('Interface/Icons/inv_misc_map03')
	self.Tab2.Icon:SetPoint('BOTTOM', 1, 4)
	self.Tab2.Icon:SetSize(23, 23)

	self.Tab3.tip = HISTORY
	self.Tab3.Icon:SetTexture('Interface/Icons/achievement_challengemode_platinum')
	self.Tab3.Icon:SetPoint('BOTTOM', 1, 2)
	self.Tab3.Icon:SetSize(25, 25)
	
	local map = Addon.Map:Create(123, -43.6, 0)
	local spot = map:CreateTexture(nil, 'OVERLAY')
	spot:SetTexture('Interface/Glues/LoadingScreens/DynamicElements')
	spot:SetTexCoord(0, .5, 0, .5)
	spot:SetSize(30, 30)

	self.Spot = spot
	self.Map:SetScrollChild(map)
	self.Slots = Addon.JournalSlot:CreateLine('TOP', self.Team, 0, 104)
	self.Team.Border.Text:SetText(L.EnemyTeam)
	self.History.LoadButton:SetText(L.LoadTeam)
	self.History.Empty:SetText(L.NoHistory)

	for i = 1, 4 do
		local loot = CreateFrame('Button', '$parentLoot' .. i, self.Card, 'PetTrackerReward')
		loot:SetPoint('TOPRIGHT', -58 + 45 * (i % 2), - 45 * ceil(i/2))
		loot.Count:Show()

		self.Card[i] = loot
	end

	for i = 1, 9 do
		local record = Addon.Record(self.History)
		record:SetPoint('TOP', 0, 40-55*i)
		record:SetID(i)

		self.History[i] = record
	end

	self:SetTamer(Addon.Tamer:Get(Addon.TamerOrder[1]))
	self:SetTab(1)
end


--[[ Events ]]--

function Journal:Search()
	Addon.Sets.TamerSearch = self:GetText()
	self.Instructions:SetShown(self:GetText() == '')
	self:GetParent().List:update()
end

function Journal:SetTab(tab)
	for i = 1,3 do
		local selected = i == tab
		local tab = self['Tab' .. i]

		tab.Hider:SetShown(not selected)
		tab.Highlight:SetShown(not selected)
		tab.TabBg:SetTexCoord(0.01562500, 0.79687500,
			selected and 0.78906250 or 0.61328125, selected and 0.95703125 or 0.78125000)
	end

	self.Team:SetShown(tab == 1)
	self.Map:SetShown(tab == 2)
	self.History:SetShown(tab == 3)
	self.Card:SetShown(tab ~= 3)
	self:Update()
end

function Journal:SetTamer(tamer)
	self:Startup()
	self.List.selected = tamer
	self.List:update()
	self:Update()
end

function Journal:SetRecord(record)
	self.History.selected = record
	self.History:Update()
end


--[[ Redraw ]]--

function Journal.List:update()
	local self = Journal.List
	local off = HybridScrollFrame_GetOffset(self)
	local tamers = {}

	for i, id in pairs(Addon.TamerOrder) do
		local tamer = Addon.Tamer:Get(id)
		if Addon:Filter(tamer, Addon.Sets.TamerSearch) then
			tinsert(tamers, tamer)
		end
	end

	for i, button in ipairs(self.buttons) do
		local tamer = tamers[i + off]

		if tamer then
			button.name:SetText(tamer.name)
			button.model:SetDisplayInfo(tamer.model)
			button.model.level:SetText(tamer:GetLevel())
			button.petTypeIcon:SetTexture(Addon:GetTypeIcon(tamer:GetType()))
			button.model.quality:SetVertexColor(Addon:GetQualityColor(tamer:GetQuality()))
			button.selectedTexture:SetShown(tamer.id == self.selected.id)
		end

		button:SetShown(tamer)
		button.tamer = tamer
	end

	HybridScrollFrame_Update(self, #tamers * 46, self:GetHeight())
end

function Journal:Update()
	local tamer = self.List.selected

	if self.Card:IsShown() then
		self.Card:Display(tamer)
	end

	if self.Team:IsShown() then
		for i, slot in ipairs(self.Slots) do
			slot:Display(tamer[i])
		end
	end

	if self.History:IsShown() then
		self.History:Display(tamer)
	end

	if self.Map:IsShown() then
		SetMapByID(tamer:GetZone())
		self.Map:GetScrollChild():UpdateTiles()
		self.Spot:Show()

		for i = 1, GetNumMapLandmarks() do
			local _,_,_, x,y, _,_,_,_, spot = GetMapLandmarkInfo(i)
			if Addon.TamerLandmarks[spot] == tamer.id then
				return self.Map:GetScrollChild():PlacePOI(self.Spot, x, y)
			end
		end

		self.Spot:Hide()
	end
end

function Journal.Card:Display(tamer)
	self.name:SetText(tamer.name)
	self.zone:SetText(tamer:GetZoneTitle())
	self.quest:SetShown(tamer.quest ~= 0)
	self.model:SetDisplayInfo(tamer.model)
	self.model:SetRotation(.3)

	for i, slot in ipairs(self) do
		slot:Hide()
	end

	if tamer.quest ~= 0 then
		local completed = tamer:IsCompleted()
		local rewards = tamer:GetRewards()

		self.quest.status:SetText(tamer:GetCompleteState())
		self.quest.icon:SetDesaturated(completed)
		self.quest.ring:SetDesaturated(completed)
		self.quest.id = tamer.quest

		for i, loot in pairs(rewards) do
			local slot = self[i]
			slot.icon:SetTexture(loot.icon)
			slot.icon:SetDesaturated(completed)
			slot.Count:SetText(loot.count)
			slot.link = loot.link
			slot:Show()
		end

		if tamer.gold > 0 then
			local slot = self[#rewards+1]
			slot.icon:SetTexture('Interface/icons/inv_misc_coin_01')
			slot.icon:SetDesaturated(completed)
			slot.Count:SetText(tamer.gold)
			slot.link = nil
			slot:Show()
		end
	end
end

function Journal.History:Display(tamer)
	local entries = Addon.Sets.TamerHistory[tamer.id] or {}
	self.Empty:SetShown(#entries == 0)
	self:SetSelected(nil)

	for i, data in ipairs(entries) do
		self[i]:Display(data)
	end

	for i = #entries+1, 9 do
		self[i]:Hide()
	end
end

function Journal.History:SetSelected(selected)
	for i = 1, 9 do
		self[i].Selected:SetShown(selected == i)
	end

	if selected then
		self.LoadButton:Enable()
		self.selected = selected
	else
		self.LoadButton:Disable()
	end
end

function Journal.History:LoadTeam()
	local record = self[self.selected]

	for i, pet in ipairs(record.pets) do
		C_PetJournal.SetPetLoadOutInfo(i, pet.id)

		for k, spell in ipairs(pet.spells) do
			C_PetJournal.SetAbility(i, k, spell)
		end
	end
end


--[[ Make a Tab ]]--

Journal.PanelTab = LibStub('SecureTabs-2.0'):Add(CollectionsJournal, Journal, L.Rivals)
Journal.PanelTab.OnSelect = function()
	Journal:Startup()
end