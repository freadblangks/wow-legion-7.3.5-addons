local _, e = ...

local AK_BONUS = {}

AK_BONUS[0] = 1
AK_BONUS[1] = 1.25
AK_BONUS[2] = 1.5
AK_BONUS[3] = 1.9
AK_BONUS[4] = 2.4
AK_BONUS[5] = 3
AK_BONUS[6] = 3.75
AK_BONUS[7] = 4.75
AK_BONUS[8] = 6
AK_BONUS[9] = 7.5
AK_BONUS[10] = 9.5
AK_BONUS[11] = 12
AK_BONUS[12] = 15
AK_BONUS[13] = 18.75
AK_BONUS[14] = 23.5
AK_BONUS[15] = 29.5
AK_BONUS[16] = 37
AK_BONUS[17] = 46.5
AK_BONUS[18] = 58
AK_BONUS[19] = 73
AK_BONUS[20] = 91
AK_BONUS[21] = 114
AK_BONUS[22] = 143
AK_BONUS[23] = 179
AK_BONUS[24] = 224
AK_BONUS[25] = 250
AK_BONUS[26] = 1001
AK_BONUS[27] = 1301
AK_BONUS[28] = 1701
AK_BONUS[29] = 2201
AK_BONUS[30] = 2901
AK_BONUS[31] = 3801
AK_BONUS[32] = 4901
AK_BONUS[33] = 6401
AK_BONUS[34] = 8301
AK_BONUS[35] = 10801
AK_BONUS[36] = 14001
AK_BONUS[37] = 18201
AK_BONUS[38] = 23701
AK_BONUS[39] = 30801
AK_BONUS[40] = 40001
AK_BONUS[41] = 160001
AK_BONUS[42] = 208001
AK_BONUS[43] = 270401
AK_BONUS[44] = 351501
AK_BONUS[45] = 457001
AK_BONUS[46] = 594001
AK_BONUS[47] = 772501
AK_BONUS[48] = 1004001
AK_BONUS[49] = 1305001
AK_BONUS[50] = 1696501
AK_BONUS[51] = 2205501
AK_BONUS[52] = 2867501
AK_BONUS[53] = 3727501
AK_BONUS[54] = 4846001
AK_BONUS[55] = 6300001

-- Returns artifact bonus percent
-- @param akLevel integer value representing artifact level
function e.GetAKBonus()
	return AK_BONUS[math.min(e.Week + 35, #AK_BONUS)]
	--return AK_BONUS[tonumber(akLevel)]
end

--Gets Artifact Knowledge level
function e.ParseAKLevel()
	return math.min(e.Week + 35, #AK_BONUS)
end
