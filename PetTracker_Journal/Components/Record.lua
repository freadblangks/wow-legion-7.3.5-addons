local Addon = PetTracker
local Record = Addon:NewClass('Button', 'Record', 'PetTrackerRecord')
local L = Addon.Locals

local IdMatch = strrep('%w', 12)
local SpellsMatch = strrep('(%w%w%w)', 3)
local PetMatch = '(%w)' .. SpellsMatch .. '(' .. IdMatch .. ')'

function Record:Display(entry)
	self:Unpack(entry)
	self.Content.When:SetFormattedText('%d/%d/%02d', self.day, self.month, self.year)
	self:SetNormalFontObject(self.won and GameFontGreen or GameFontRed)
	self:SetText(self.won and L.Victory or L.Defeat)
	self:Show()

	for i = 1, 3 do
		local pet = self.pets[i]
		local button = self.Content['Pet' .. i]
		button:SetShown(pet)

		if pet then
			local texture = select(9, C_PetJournal.GetPetInfoByPetID(pet.id))
			button:SetNormalTexture(texture or 'Interface/Icons/INV_Misc_QuestionMark')
			button.id = texture and pet.id
			
			local alive = pet.health > 0
			button.Health:SetWidth(pet.health * 36)
			button.Health:SetShown(alive)
			button.HealthBg:SetShown(alive)
			button.HealthBorder:SetShown(alive)
			button.Dead:SetShown(not alive)
		end
	end
end

function Record:Unpack(entry)
	local winner, date, petData = entry:match('^(%d)(%w%w%w)(.+)$')

	self.won = tonumber(winner) == LE_BATTLE_PET_ALLY
	self.day, self.month, self.year = Addon:UnpackDate(tonumber(date, 16))
	self.pets = {}

	for health, spell1, spell2, spell3, id in petData:gmatch(PetMatch) do
		tinsert(self.pets, {
			id = 'BattlePet-0-' .. id,
			health = tonumber(health, 16) / 15,
			spells = {tonumber(spell1, 16), tonumber(spell2, 16), tonumber(spell3, 16)}
		})
	end
end