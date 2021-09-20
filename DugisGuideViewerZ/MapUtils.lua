local mapdata = LibStub("LibMapData-1.0-Dugi")
local astrolabe = DongleStub("Astrolabe-1.0-Dugi")
local DGV = DugisGuideViewer
DGV.astrolabe = astrolabe
DGV.mapdata = mapdata
local GetCreateTable, InitTable = DGV.GetCreateTable, DGV.InitTable
local _

function DGV:Waypoint2MapCoordinates(waypoint)
    local wpx, wpy, wpm, wpf = waypoint.x/100, waypoint.y/100, waypoint.map, waypoint.floor
    local currentFloor = GetCurrentMapDungeonLevel()
    if wpf and currentFloor~=wpf then
        wpx, wpy = DGV:TranslateWorldMapPosition(wpm, wpf, wpx, wpy, wpm, currentFloor)
    end
    wpx = wpx * DugisMapOverlayFrame:GetWidth();
    wpy = -wpy * DugisMapOverlayFrame:GetHeight();

    return wpx, wpy
end

function DGV:IsPlayerPosAvailable()
    return GetPlayerMapPosition("player")
end

--/run DGV:ShowMapData(mapId, ...)
function DGV:ShowMapData(mapId, ...)
	local tbl = {}
	local mapData = {}
	tbl[mapId] = mapData
	local numFloors = select("#", ...)
	LuaUtils:DugiSetMapByID(mapId)
	local _, TLx, TLy, BRx, BRy = GetCurrentMapZone();
	if ( TLx and TLy and BRx and BRy ) then
		if not ( TLx < BRx ) then
			TLx = -TLx;
			BRx = -BRx;
		end
		if not ( TLy < BRy) then
			TLy = -TLy;
			BRy = -BRy;
		end
		mapData.width = BRx - TLx
		mapData.height = BRy - TLy
		mapData.xOffset = TLx
		mapData.yOffset = TLy
	end
	if ( numFloors > 0 ) then
		for i = 1, numFloors do
			local f = select(i, ...)
			SetDungeonMapLevel(f);
			local _, TLx, TLy, BRx, BRy = GetCurrentMapDungeonLevel();
			if ( TLx and TLy and BRx and BRy ) then
				mapData[f] = {};
				if not ( TLx < BRx ) then
					TLx = -TLx;
					BRx = -BRx;
				end
				if not ( TLy < BRy) then
					TLy = -TLy;
					BRy = -BRy;
				end
				mapData[f].width = BRx - TLx
				mapData[f].height = BRy - TLy
				mapData[f].xOffset = TLx
				mapData[f].yOffset = TLy
			end
		end
	end
	DGV:DebugFormat("ShowMapData", "tbl", tbl)
end

function DGV:GetMapNameFromID(mapId)
	--return mapdata:MapLocalize(mapId) old method calling it from LibMapData
	if mapId then 
		return GetMapNameByID(mapId) -- get it from game. 
	else
		return nil
	end
end

function DGV:GetMapIDFromName(mapName)
	if mapName then
		return mapdata:MapAreaId(mapName)
	else
		return 0
	end 
end

--[[function DGV:InitMapping( )
	DGV:initAnts()
	DGV.DugisArrow:initArrow()
end]]

function DGV:TranslateWorldMapPosition(map, floor, x, y, M, F)
	return astrolabe:TranslateWorldMapPosition(map, floor, x, y, M, F)
end

function DGV:PlaceIconOnMinimap( icon, mapID, mapFloor, x, y)
	if x and y and mapID then
		astrolabe:PlaceIconOnMinimap(icon, mapID, mapFloor, x, y)
	end
end

function DGV:GetMapID(ContToUse, ZoneToUse)
	return astrolabe:GetMapID(ContToUse, ZoneToUse)
end

-- If forcedAbsoluteX and forcedAbsoluteY are nill the absolute position of the icon will not be calculated but forcedAbsoluteX and forcedAbsoluteY will be used instead
function DGV:PlaceIconOnWorldMap( frame, icon, mapID, mapFloor, x, y, forcedAbsoluteX, forcedAbsoluteY)		
	if x and y and mapID then
		astrolabe:PlaceIconOnWorldMap(frame, icon, mapID, mapFloor, x, y, forcedAbsoluteX, forcedAbsoluteY)
	end
	
	DGV:CheckForArrowChange()
	
	if DGV.WrongInstanceFloor --[[or not DGV.WaypointsShown]] then
		icon.icon:Hide()
	else
		icon.icon:Show()
	end
end

function DGV:ComputeDistance( m1, f1, x1, y1, m2, f2, x2, y2 )
	
	return astrolabe:ComputeDistance( m1, f1, x1, y1, m2, f2, x2, y2 )
end

function DGV:GetMapDimension(m1, f1)
	return astrolabe:GetMapDimension(m1, f1);
end

local lastM, lastF = 0, 0
local GetCurrentMapDimension_cache = nil
function DGV:GetCurrentMapDimension()
	local m, f = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
	if lastM ~= m or lastF ~= f or GetCurrentMapDimension_cache == nil then
		GetCurrentMapDimension_cache = {DGV:GetMapDimension(m, f)}
	end
	lastM, lastF = m, f
	return unpack(GetCurrentMapDimension_cache)
end

function DGV:IsValidDistance( m, f, x, y )
	local dist, dx, dy = DGV:GetDistanceFromPlayer(m, f, x, y)
	if dist and dx and dy then
		return true
	end
end

function DGV:GetDistanceFromPlayer(m, f, x, y)
	local pmap, pfloor, px, py = DGV:GetPlayerPosition()
	return astrolabe:ComputeDistance(pmap, pfloor, px, py, m, f, x/100, y/100) 
end

function DGV:WorldMapFrameOnShow()
	DGV:OnMapChangeUpdateArrow( )
end
WorldMapFrame:HookScript( "OnShow", DGV.WorldMapFrameOnShow )


function DGV:GetUnitPosition( unit, noMapChange )
	return astrolabe:GetUnitPosition( unit, noMapChange )
end


function DGV:GetPlayerPosition()

    local x, y = GetPlayerMapPosition("player")
    if x == nil then
        x, y = 0, 0 
    end
    
    if x and y and x > 0 and y > 0 then
	local map, floor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
        floor = floor or self:GetDefaultFloor(map)
        return map, floor, x, y
    end

    if WorldMapFrame:IsVisible() then
        return
    end

    LuaUtils:DugiSetMapToCurrentZone()
    local x, y = GetPlayerMapPosition("player")
    if x == nil then
        x, y = 0, 0 
    end

    if x <= 0 and y <= 0 then
        return
    end

    local map, floor = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel();
    floor = floor or self:GetDefaultFloor(map)
    return map, floor, x, y
end

function DGV:GetPlayerMapPositionDisruptive()
	local orig_mapId, orig_level = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
	LuaUtils:DugiSetMapToCurrentZone()
	local DugisArrow = DGV.Modules.DugisArrow
	local m1, f1, x1, y1 =  DGV.astrolabe:GetUnitPosition("player")
	if not m1 or m1==0 then
		m1, f1, x1, y1 = 
			DugisArrow.map, DugisArrow.floor,
			DugisArrow.pos_x, DugisArrow.pos_y
	end
	if orig_mapId~=m1 or orig_level~=f1 then
		LuaUtils:DugiSetMapByID(orig_mapId)
		SetDungeonMapLevel(orig_level)
	end
	return m1, f1, x1, y1
end

function DGV:GetDefaultFloor(map)
    local floors = astrolabe:GetNumFloors(map) == 0 and 0 or 1
    return floors == 0 and 0 or 1
end

local czLookup = {}
local function LookupSubzones(cIndex, zMapId, ...)
	for loopIndex=1, select("#", ...), 2 do
		local sMapId = select(loopIndex, ...)
		local sName = select(loopIndex + 1, ...)
		local sIndex = math.floor(loopIndex/2)
		czLookup[sMapId] = {cIndex, sIndex, sName, zMapId, "subzone"}
	end
end

local function LookupZones(cIndex,  ...)
	for loopIndex=1, select("#", ...), 2 do
		local zMapId = select(loopIndex, ...)
		local zName = select(loopIndex + 1, ...)
		local zIndex = math.floor(loopIndex/2)
		czLookup[zMapId] = {cIndex, zIndex, zName, nil, "zone"}
		LookupSubzones(cIndex, zMapId, GetMapSubzones(zMapId))
	end
end

local function LookupContinents(...)
	for loopIndex=1, select("#", ...), 2 do
		local cMapId = select(loopIndex, ...)
		local cName = select(loopIndex + 1, ...)
		local cIndex = math.floor(loopIndex/2) + 1
		czLookup[cMapId] = {0, cIndex, cName, nil, "continent"}
		LookupZones(cIndex, GetMapZones(cIndex))
	end
end

LookupContinents(GetMapContinents())

local function ContinentName2ContinentId(continentName, ...)
	for loopIndex=1, select("#", ...), 2 do
		local cMapId = select(loopIndex, ...)
		local cName = select(loopIndex + 1, ...)
        local cIndex = math.floor(loopIndex/2) + 1
        if cName == continentName then
            return cIndex
        end
    end
end

--zone name[:continent name]
function DGV:GetZoneIdByName(name)
	if name == "Vale of Eternal Blossoms" then return 811 end --cheap fix otherwise it returns 937 which is another map of the same name but not used. 
	if type(name)~="string" then return nil end
    
    local zoneName_continentName = LuaUtils:split(name, ":")
    local zoneName = zoneName_continentName[1]
    local continentName = nil
    local continentId = nil
    
    if zoneName_continentName[2] ~= nil then
        continentName = zoneName_continentName[2]
        continentId = ContinentName2ContinentId(continentName, GetMapContinents())
    end
    
	zoneName = zoneName:lower():trim()
    
    local resultContinent = nil
    local resultZone = nil
    local resultSubzone = nil
    
	for id, tbl in pairs(czLookup) do
		if tbl[3]:lower():trim()==zoneName then
            local cIndex = tonumber(tbl[1])
        
            if tbl[5] == "continent" then
                resultContinent = id
            end
            
            if tbl[5] == "zone" then
                if continentId == nil or continentId == cIndex then
                    resultZone = id
                end
            end
            
            if tbl[5] == "subzone" then
                if continentId == nil or continentId == cIndex then
                    resultSubzone = id
                end
            end
		end
	end
    
    --print(resultContinent, resultZone, resultSubzone)
     
    if resultZone then
        return resultZone
    end
   
    if resultSubzone then
        return resultSubzone
    end    
    
    if resultContinent then
        return resultContinent
    end
end

local function getCZ(mapId)
	local c, z 
	if czLookup[mapId] then 
		c, z = unpack(czLookup[mapId])
	end
	return c or 0, z or 0
end

function DGV:GetCZByMapId(mapId)
	if getCZ(mapId) == 0 then 
		return 12, 0
	else
		return getCZ(mapId)
	end
--[[	if mapId == 1052 or 
	mapId == 1048 or
	mapId == 1044 or
	mapId == 1068
	then
		return 10, 0
	end
	return getCZ(mapId)]]
end

function DGV.ContinentMapIterator(invariant, control)
	while true do
		control, tbl = next(czLookup, control)
		if not control then return end
		if tbl[1]==invariant then
			return control
		end
	end
end

DGV.TERRAIN_MAPS =  {
[0]="azeroth",
[1]="kalimdor",
[30]="pvpzone01",
[33]="shadowfang",
[36]="deadminesinstance",
[37]="pvpzone02",
[47]="razorfenkraulinstance",
[129]="razorfendowns",
[169]="emeralddream",
[189]="monasteryinstances",
[209]="tanarisinstance",
[269]="cavernsoftime",
[289]="schoolofnecromancy",
[309]="zul'gurub",
[329]="stratholme",
[451]="development",
[469]="blackwinglair",
[489]="pvpzone03",
[509]="ahnqiraj",
[529]="pvpzone04",
[530]="expansion01",
[531]="ahnqirajtemple",
[532]="karazahn",
[533]="stratholme raid",
[534]="hyjalpast",
[543]="hellfirerampart",
[559]="pvpzone05",
[560]="hillsbradpast",
[562]="bladesedgearena",
[564]="blacktemple",
[566]="netherstormbg",
[568]="zulaman",
[571]="northrend",
[572]="pvplordaeron",
[573]="exteriortest",
[574]="valgarde70",
[575]="utgardepinnacle",
[578]="nexus80",
[580]="sunwellplateau",
[585]="sunwell5manfix",
[595]="stratholmecot",
[599]="ulduar70",
[600]="draktheronkeep",
[601]="azjol_uppercity",
[602]="ulduar80",
[603]="ulduarraid",
[604]="gundrak",
[605]="development_nonweighted",
[607]="northrendbg",
[608]="dalaranprison",
[609]="deathknightstart",
[615]="chamberofaspectsblack",
[616]="nexusraid",
[617]="dalaranarena",
[618]="orgrimmararena",
[619]="azjol_lowercity",
[624]="wintergraspraid",
[628]="isleofconquest",
[631]="icecrowncitadel",
[632]="icecrowncitadel5man",
[638]="gilneas",
[643]="abyssalmaw_interior",
[644]="uldum",
[645]="blackrockspire_4_0",
[648]="lostisles",
[649]="argenttournamentraid",
[650]="argenttournamentdungeon",
[654]="gilneas2",
[655]="gilneasphase1",
[656]="gilneasphase2",
[657]="skywalldungeon",
[658]="quarryoftears",
[659]="lostislesphase1",
[660]="deephomeceiling",
[661]="lostislesphase2",
[668]="hallsofreflection",
[669]="blackwingdescent",
[670]="grimbatoldungeon",
[671]="grimbatolraid",
[719]="mounthyjalphase1",
[720]="firelands1",
[724]="chamberofaspectsred",
[725]="deepholmedungeon",
[726]="cataclysmctf",
[727]="stv_mine_bg",
[728]="thebattleforgilneas",
[730]="maelstromzone",
[731]="desolacebomb",
[732]="tolbarad",
[734]="ahnqirajterrace",
[736]="twilighthighlandsdragonmawphase",
[746]="uldumphaseoasis",
[751]="redgridgeorcbomb",
[754]="skywallraid",
[755]="uldumdungeon",
[757]="baradinhold",
[761]="gilneas_bg_2",
[764]="uldumphasewreckedcamp",
[859]="zul_gurub5man",
[860]="newracestartzone",
[861]="firelandsdailies",
[870]="hawaiimainland",
[930]="scenarioalcazisland",
[938]="cotdragonblight",
[939]="cotwaroftheancients",
[940]="thehouroftwilight",
[951]="nexuslegendary",
[959]="shadowpanhideout",
[960]="easttemple",
[961]="stormstoutbrewery",
[962]="thegreatwall",
[967]="deathwingback",
[968]="eyeofthestorm2.0",
[971]="jadeforestalliancehubphase",
[972]="jadeforestbattlefieldphase",
[974]="darkmoonfaire",
[975]="turtleshipphase01",
[976]="turtleshipphase02",
[977]="maelstromdeathwingfight",
[980]="tolvirarena",
[994]="mogudungeon",
[996]="moguexteriorraid",
[998]="valleyofpower",
[999]="bftalliancescenario",
[1000]="bfthordescenario",
[1001]="scarletsanctuaryarmoryandlibrary",
[1004]="scarletmonasterycathedralgy",
[1005]="brewmasterscenario01",
[1007]="newscholomance",
[1008]="mogushanpalace",
[1009]="mantidraid",
[1010]="mistsctf3",
[1011]="mantiddungeon",
[1014]="monkareascenario",
[1019]="ruinsoftheramore",
[1024]="pandafishingvillagescenario",
[1028]="moguruinsscenario",
[1029]="ancientmogucryptscenario",
[1030]="ancientmogucyptdestroyedscenario",
[1031]="provinggroundsscenario",
[1035]="valleyofpowerscenario",
[1043]="ringofvalorscenario",
[1048]="brewmasterscenario03",
[1049]="blackoxtemplescenario",
[1050]="scenarioklaxxiisland",
[1051]="scenariobrewmaster04",
[1061]="hordebeachdailyarea",
[1062]="alliancebeachdailyarea",
[1064]="moguislanddailyarea",
[1066]="stormwindgunshippandariastartarea",
[1074]="orgrimmargunshippandariastart",
[1116]="draenor",
[1075]="theramorescenariophase",
[1076]="jadeforesthordestartingarea",
[1095]="hordeambushscenario",
[1098]="thunderislandraid",
[1099]="navalbattlescenario",
[1101]="defenseofthealehousebg",
[1102]="hordebasebeachscenario",
[1103]="alliancebasebeachscenario",
[1104]="alittlepatiencescenario",
[1105]="goldrushbg",
[1106]="jainadalaranscenario",
[1112]="blacktemplescenario",
[1120]="thunderkinghordehub",
[1121]="thunderislandalliancehub",
[1123]="lightningforgemoguislandprogressionscenario",
[1124]="shipyardmoguislandprogressionscenario",
[1126]="hordehubmoguislandprogressionscenario",
[1128]="moguislandeventshordebase",
[1129]="moguislandeventsalliancebase",

[1220]="Troll Raid",
[1669]="Argus 1",
[646]="deephome",
}