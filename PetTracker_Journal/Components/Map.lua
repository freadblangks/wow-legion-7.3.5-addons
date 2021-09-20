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
local Map = Addon:NewClass('Frame', 'Map')

local function textureScale(size)
	local v = 16
	while v < size do
		v = v * 2
	end

	return size / v
end


--[[ Startup ]]--

function Map:Create(tileSize, x, y)
	local frame = self()
	frame:SetSize(tileSize*4, tileSize*2.6)
	frame.tiles, frame.overs = {}, {}
	frame.scale = tileSize/256
	frame.x, frame.y = x, y

	for i = 1, GetNumberOfDetailTiles() do
		local pos = i - 1
		local tile = frame:CreateTexture(nil, 'BACKGROUND')
		tile:SetPoint('TOPLEFT', pos % 4 * tileSize + x, -floor(pos / 4) * tileSize + y)
		tile:SetSize(tileSize, tileSize)

		frame.tiles[i] = tile
	end

	return frame
end

function Map:GetOverlay(i)
	if not self.overs[i] then
		self.overs[i] = self:CreateTexture(nil, 'ARTWORK')
	end

	return self.overs[i]
end


--[[ API ]]--

function Map:UpdateTiles()
	local name = GetMapInfo()
	local path = 'Interface/WorldMap/' .. name .. '\\' .. name
	for i = 1, GetNumberOfDetailTiles() do
		self.tiles[i]:SetTexture(path .. i)
	end

	local j = 1
	for i = 1, GetNumMapOverlays() do
		local name, width, height, x, y = GetMapOverlayInfo(i)
		local x, y = x + self.x / self.scale, y + self.y / self.scale
		local k = 1

		if name and name ~= "" then
			while (height > 0) do
				local large, off = width, x
				local tall = min(256, height)
				local ratio = textureScale(tall)

				while (large > 0) do
					local width = min(256, large)
					local tile = self:GetOverlay(j)
					tile:SetSize(width * self.scale, tall * self.scale)
					tile:SetTexCoord(0, textureScale(width), 0, ratio)
					tile:SetPoint('TOPLEFT', off * self.scale, -y * self.scale)
					tile:SetTexture(name .. k)
					tile:Show()

					large = large - 256
					off = off + 256
					k = k + 1
					j = j + 1
				end

				height = height - 256
				y = y + 256
			end
		end
	end

	for i = j, #self.overs do
		self.overs[i]:Hide()
	end
end

function Map:PlacePOI(object, x, y)
	object:SetPoint('CENTER', self, 'TOPLEFT', x*self:GetWidth() + self.x, -y*self:GetHeight() - self.y)
end