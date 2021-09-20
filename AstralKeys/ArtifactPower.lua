local _, e = ...

local DUNGEON_TABLE = {}
local WEEKLY_AP = {}

--[[
RUSSIAN
Upper Kara   Верхний Каражан
Lowre Kara   Нижний Каражан
]]

DUNGEON_TABLE[197] = {}
--DUNGEON_TABLE[197]['enUS'] 
--DUNGEON_TABLE[197]['ptBR'] 
--DUNGEON_TABLE[197]['deDE'] 
--DUNGEON_TABLE[197]['frFR']
--DUNGEON_TABLE[197]['esMX']
--DUNGEON_TABLE[197]['ruRU']

DUNGEON_TABLE[197]['name'] = '艾薩拉之眼'
DUNGEON_TABLE[198] = {}
DUNGEON_TABLE[198]['name'] = '暗心灌木林'
DUNGEON_TABLE[199] = {}
DUNGEON_TABLE[199]['name'] = '玄鴉堡'
DUNGEON_TABLE[200] = {}
DUNGEON_TABLE[200]['name'] = '英靈殿'
DUNGEON_TABLE[206] = {}
DUNGEON_TABLE[206]['name'] = '奈薩里奧巢穴'
DUNGEON_TABLE[207] = {}
DUNGEON_TABLE[207]['name'] = '看守者鐵獄'
DUNGEON_TABLE[208] = {}
DUNGEON_TABLE[208]['name'] = '靈魂之喉'
DUNGEON_TABLE[209] = {}
DUNGEON_TABLE[209]['name'] = '幽暗地道'
DUNGEON_TABLE[210] = {}
DUNGEON_TABLE[210]['name'] = '眾星之廷'
DUNGEON_TABLE[227] = {}
DUNGEON_TABLE[227]['name'] = '重返卡拉贊：下層'
DUNGEON_TABLE[233] = {}
DUNGEON_TABLE[233]['name'] = '永夜聖殿'
DUNGEON_TABLE[234] = {}
DUNGEON_TABLE[234]['name'] = '重返卡拉贊：上層'
DUNGEON_TABLE[239] = {}
DUNGEON_TABLE[239]['name'] = '三傑議會'

--[[ 
Times
	-1440
	> 1440
	< 2700
	>2700
 Tier 1 Lvl 2 -3
 	-Maw 175
 	-Other 300
 	-HoV, Arc 375

 Tier 2 Lvl 4-6
 	- 290
 	- 475
 	- 600

 Tier 3 Lvl 7-9
 	-325
 	-540
 	-675

 Tier 4 10-14
 	-465
 	-775
 	-1000

 Tier 5 lvl 15+
 	-725
 	-1200
 	-1500
]]

function e.BuildMapTable()
	for map in pairs(DUNGEON_TABLE) do
		local name, mapID, runTime = C_ChallengeMode.GetMapInfo(map)
		local a, b, c = runTime, runTime * .8, runTime * .6
		--DUNGEON_TABLE[map]['name'] = name
		DUNGEON_TABLE[map]['chestTimes'] = {}
		DUNGEON_TABLE[map].chestTimes[1] = a
		DUNGEON_TABLE[map].chestTimes[2] = b
		DUNGEON_TABLE[map].chestTimes[3] = c
		DUNGEON_TABLE[map]['apTier'] = {}
		if runTime == 1440 then
			DUNGEON_TABLE[map].apTier[1] = 175 -- 2-3
			DUNGEON_TABLE[map].apTier[2] = 290 -- 4-6
			DUNGEON_TABLE[map].apTier[3] = 325 -- 7-9
			DUNGEON_TABLE[map].apTier[4] = 465 -- 10-14
			DUNGEON_TABLE[map].apTier[5] = 725 -- 15-19
			DUNGEON_TABLE[map].apTier[6] = 1025 --20-25
		elseif runTime > 1440 and runTime < 2700 then
			DUNGEON_TABLE[map].apTier[1] = 300 
			DUNGEON_TABLE[map].apTier[2] = 475
			DUNGEON_TABLE[map].apTier[3] = 540
			DUNGEON_TABLE[map].apTier[4] = 775
			DUNGEON_TABLE[map].apTier[5] = 1200
			DUNGEON_TABLE[map].apTier[6] = 1700
		elseif runTime == 2700 then
			DUNGEON_TABLE[map].apTier[1] = 375 
			DUNGEON_TABLE[map].apTier[2] = 600
			DUNGEON_TABLE[map].apTier[3] = 675
			DUNGEON_TABLE[map].apTier[4] = 1000
			DUNGEON_TABLE[map].apTier[5] = 1500
			DUNGEON_TABLE[map].apTier[6] = 2125
		end
	end
end


function e.GetMapName(mapID)
	return DUNGEON_TABLE[tonumber(mapID)]['name']
end

local function GetMapTime(mapID, chestCount)
	return DUNGEON_TABLE[mapID].chestTimes[chestCount]
end

local function GetKeyTier(keyLevel)
	if keyLevel < 4 then return 1 end
	if keyLevel > 3 then
		if keyLevel < 7 then
			return 2
		elseif keyLevel < 10 then
			return 3
		elseif keyLevel < 15 then
			return 4
		elseif keyLevel < 20 then
			return 5
		else
			return 6
		end
	end
end

function e.GetMapAP(mapID, keyLevel)
	return DUNGEON_TABLE[tonumber(mapID)]['apTier'][GetKeyTier(tonumber(keyLevel))]
end

WEEKLY_AP[2] = 1250
WEEKLY_AP[3] = 1250
WEEKLY_AP[4] = 1925
WEEKLY_AP[5] = 1925
WEEKLY_AP[6] = 1925
WEEKLY_AP[7] = 2150
WEEKLY_AP[8] = 2150
WEEKLY_AP[9] = 2150 
WEEKLY_AP[10] = 3125
WEEKLY_AP[11] = 3525
WEEKLY_AP[12] = 3925
WEEKLY_AP[13] = 4325
WEEKLY_AP[14] = 4725
WEEKLY_AP[15] = 5000
WEEKLY_AP[16] = 5400
WEEKLY_AP[17] = 5800
WEEKLY_AP[18] = 6200
WEEKLY_AP[19] = 6600
WEEKLY_AP[20] = 7000
WEEKLY_AP[21] = 7400
WEEKLY_AP[22] = 7800

function e.GetWeeklyAP(keyLevel)
	if keyLevel == 0 then return 0 end
	return WEEKLY_AP[keyLevel] or WEEKLY_AP[#WEEKLY_AP]
end

function e.MapApText(mapID, keyLevel)

	local amount = e.GetMapAP(mapID, keyLevel) * e.GetAKBonus(e.ParseAKLevel())
	local s = ''
	local chest1 = e.ConvertToSI(amount/math.floor(GetMapTime(mapID, 1)/60))
	local chest2 = e.ConvertToSI(amount/math.floor(GetMapTime(mapID, 2)/60))
	local chest3 = e.ConvertToSI(amount/math.floor(GetMapTime(mapID, 3)/60))

	return e.ConvertToSI(amount) .. ' 神兵之力\n' .. '+1 ' .. chest1 .. '/分 \n+2 ' .. chest2 .. '/分  \n+3 ' .. chest3 .. '/分'
	
end		
