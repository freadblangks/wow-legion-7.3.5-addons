local function ZoneInfo(...)
   local t = {}
   for i=1, select("#", ...), 2 do
      local MapID = select(i, ...)
      local ZoneName = select(i+1, ...)
      t[MapID] = ZoneName
   end
   return t
end

local function findZoneID(zone)
	for cID_new, cname in next, {GetMapContinents()} do
		if type(cname) == "string" then
			local cID = cID_new / 2
			for zID, zname in pairs(ZoneInfo(GetMapZones(cID))) do
				if (zname == zone) then
					return zID
				else
					for sZID, sZName in pairs(ZoneInfo(GetMapSubzones(zID))) do
						if (sZName == zone) then
							return sZID
						end
					end
				end
			end
		end
	end
	return -1
end

local function textureScale(size)
	local v = 16
	while v < size do
		v = v * 2
	end

	return size / v
end

function HunterPetLocations_Toggle()
	if HunterPetLocations:IsShown() then
		HunterPetLocations:Hide()
	else
		HunterPetLocations:Show()
	end
end

function HunterPetLocations_Update(index)
	if not HunterPetLocations then return end
	self = HunterPetLocations
	local zone = HunterPets.Locations[HunterPets.Pets.Location[index]];

	local zoneID = findZoneID(zone);

	if (zoneID > -1) then
		SetMapByID(zoneID);
		local name, textureHeight, _, isMicroDungeon, microDungeonName = GetMapInfo();

		local path;

		if not isMicroDungeon then
			path = 'Interface/WorldMap/' .. name .. '\\' .. name
		else
			path = "Interface/WorldMap/MicroDungeon/"..name.."/"..microDungeonName.."1_";
		end

		if (HunterPets.Pets.MapData[index][1] > 0) then
			path = path..HunterPets.Pets.MapData[index][1].."_"
		end

		for i = 1, GetNumberOfDetailTiles() do
			self.tiles[i]:SetTexture(path .. i)
		end
		local j = 1
		for i = 1, GetNumMapOverlays() do
			local name, width, height, x, y = GetMapOverlayInfo(i)
--			local x, y = x * self.scale, y * self.scale
			local k = 1

			if name and name ~= "" then
				while (height > 0) do
					local large, off = width, x
					local tall = min(256, height)
					local ratio = textureScale(tall)

					while (large > 0) do
						local width = min(256, large)
						if not self.overlay[j] then
							self.overlay[j] = self.Map:CreateTexture(nil, "ARTWORK")
						end
						local tile = self.overlay[j]
						tile:SetSize(width * self.scale, tall * self.scale)
						tile:SetTexCoord(0, textureScale(width), 0, ratio)
						tile:SetPoint('TOPLEFT', self.Map, 'TOPLEFT', off * self.scale, -y * self.scale)
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

		for i = j, #self.overlay do
			self.overlay[i]:Hide()
		end

		local numPoints = 1;
		for i=2, #HunterPets.Pets.MapData[index], 2 do
			local offsetX, offsetY = (HunterPets.Pets.MapData[index][i]/100)*ceil(HunterPetLocations.Map:GetWidth()), (HunterPets.Pets.MapData[index][i+1]/100)*ceil(HunterPetLocations.Map:GetHeight())
			if not self.points[numPoints] then
				self.points[numPoints] = self.Map:CreateTexture(nil, "OVERLAY")
			end
			local pTex = self.points[numPoints];
			pTex:SetSize(16,16);
			pTex:SetPoint("CENTER",self.Map, "TOPLEFT", offsetX, -offsetY)
			pTex:SetTexCoord(0.27,0.35,0.02,0.11);
			pTex:SetTexture('Interface/Minimap/ObjectIcons');
			pTex:Show()
			numPoints = numPoints+1;
		end

		for i = numPoints, #self.points do
			self.points[i]:Hide();
		end
	end
end

function HunterPetLocations_OnLoad(self)
	HunterPetLocations.tileSize = 102;
	HunterPetLocations.scale = self.tileSize / 256;
	HunterPetLocations.tiles = {};
	HunterPetLocations.overlay = {};
	HunterPetLocations.points = {};

	for i = 1, GetNumberOfDetailTiles() do
		local pos = i - 1
		local tile = self.Map:CreateTexture(nil, 'BACKGROUND')
		tile:SetPoint('TOPLEFT', pos % 4 * self.tileSize, -floor(pos / 4) * self.tileSize)
		tile:SetSize(self.tileSize, self.tileSize)

		HunterPetLocations.tiles[i] = tile
	end
end
