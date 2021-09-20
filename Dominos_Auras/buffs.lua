
local AuraModule = Dominos:NewModule('Buff')
local AuraFrame = Dominos:CreateClass('Frame', Dominos.Frame)

function AuraModule:Load()
	self.frame = AuraFrame:New("增益效果")
end

function AuraModule:Unload()
	self.frame:Free()
end

function AuraFrame:New(name)
	local f = AuraFrame.proto.New(self, name)
	f:SetFrameStrata('LOW')
	Goranaws_TemplateManager:New(f, "增益效果")

	return f
end

function AuraFrame:HideBlizz()
	local hideBlizz = self.sets.hideBlizz
	if hideBlizz then
		BuffFrame:Hide()
	else
		BuffFrame:Show()
	end
end

function AuraFrame:GetDefaults()
	return {
		scale = 1,
		point = 'TOPRIGHT',
		y = -10,
		x = -200,
		spacing = 2,
		columns = 10,
		rows = 2,
		isRightToLeft = true,
		isBottomToTop = false,
		method = 1, --time, index or name
		direction = false,
		padding = 0,
		hideBlizz = true,
	}
end

function AuraFrame:GetFilter()
	return "HELPFUL"
end
