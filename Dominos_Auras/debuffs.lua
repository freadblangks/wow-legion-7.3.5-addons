local AuraModule = Dominos:NewModule('Debuff')
local AuraFrame = Dominos:CreateClass('Frame', Dominos.Frame)

function AuraModule:Load()
	self.frame = AuraFrame:New("減益效果")
end

function AuraModule:Unload()
	self.frame:Free()
end

function AuraFrame:New(name)
	local f = AuraFrame.proto.New(self, name)
	f:SetFrameStrata('LOW')
	Goranaws_TemplateManager:New(f, "減益效果")
	return f
end

function AuraFrame:GetDefaults()
	return {
		scale = 1.5,
		point = 'TOPRIGHT',
		y = -120,
		x = -200,
		spacing = 2,
		columns = 5,
		rows = 2,
		isRightToLeft = true,
		isBottomToTop = false,
		method = 1, --time, index or name
		direction = true,
		padding = 0,
	}
end

function AuraFrame:GetFilter()
	return "HARMFUL"
end
