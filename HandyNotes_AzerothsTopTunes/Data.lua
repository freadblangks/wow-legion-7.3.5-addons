
local _, AzerothsTopTunes = ...
local points = AzerothsTopTunes.points
local playerFaction = UnitFactionGroup("player")

-- points[<mapfile>] = { [<coordinates>] = { <quest ID>, <item name>, <notes> } }


----------------------
-- Eastern Kingdoms --
----------------------

points["BlackwingDescent"] = {
	[47377918] = { 38063, "樂譜：Legends of Azeroth", " 區域：暗影之焰穹殿\n首領掉落：奈法利安的末路（機率掉落）" },
}

points["BurningSteppes"] = {
	[23242635] = { 38063, "樂譜：Legends of Azeroth", "團隊副本：黑翼陷窟\n首領掉落：奈法利安的末路（機率掉落）" },
}

points["DeadwindPass"] = {
	[46927479] = { 38093, "樂譜：Karazhan Opera House", "團隊副本：卡拉贊\n首領掉落：歌劇院事件（機率掉落）" },
}

points["Duskwood"] = {
	[23503710] = { 38088, "樂譜：Ghost", "跟孤獨的作曲家說話取得(你必須處於靈魂狀態才能看到NPC)" },
}

points["Karazhan"] = {
	[17713439] = { 38093, "樂譜：Karazhan Opera House", "區域：客房\n首領掉落：歌劇院事件（機率掉落）" },
}

points["StranglethornVale"] = {
	[41285134] = { 38087, "樂譜：Angelic", "在大競技場中央的競技場財寶箱取得\n競技場財寶箱只會在伺服器時間早上/下午的3/6/9/12點刷新" },
}

points["TheCapeOfStranglethorn"] = {
	[46532626] = { 38087, "樂譜：Angelic", "在大競技場中央的競技場財寶箱取得\n競技場財寶箱只會在伺服器時間早上/下午的3/6/9/12點刷新" },
}

points["Tirisfal"] = {
	[17566754] = { 38096, "樂譜：Faerie Dragon", "當醉靈精龍事件進行時，在精靈龍巢拾取\n醉靈精龍事件大約15分鐘刷新一次" },
	[60148499] = { 38095, "樂譜：Lament of the Highborne", "在幽暗城內.\n打開希瓦娜斯的保險箱取得" },
}

points["Undercity"] = {
	[58119388] = { 38095, "樂譜：Lament of the Highborne", "打開希瓦娜斯的保險箱取得" },
}

if playerFaction == "Alliance" then
	points["DunMorogh"] = {
		[31393804] = { 38081, "樂譜：Tinkertown", "副本：諾姆瑞根\n用超級清潔器5200型(位於清潔區)清潔[髒兮兮的東西](小怪機率掉落)後得到的[被清潔器包裝過的盒子]有機率取得" },
		[65802243] = { 38075, "樂譜：Cold Mountain", "在鐵爐堡內\n在荒棄的洞穴的水池釣魚有機會取得" },
	}

	points["Gnomeregan"] = {
		[64946316] = { 38081, "樂譜：Tinkertown", "區域：宿舍\n用超級清潔器5200型(位於清潔區)清潔[髒兮兮的東西](小怪機率掉落)後得到的[被清潔器包裝過的盒子]有機率取得" },
	}

	points["Ironforge"] = {
		[47001983] = { 38075, "樂譜：Cold Mountain", "在荒棄的洞穴的水池釣魚有機會取得" },
	}

	points["NewTinkertownStart"] = {
		[32503700] = { 38081, "樂譜：Tinkertown", "副本：諾姆瑞根\n用超級清潔器5200型(位於清潔區)清潔[髒兮兮的東西](小怪機率掉落)後得到的[被清潔器包裝過的盒子]有機率取得" },
	}
end

if playerFaction == "Horde" then
	points["StranglethornVale"][63852180] = { 38080, "樂譜：Zul'Gurub Voo Doo", "副本：祖爾格拉布\n首領掉落：破神者金度（機率掉落）" }
	points["StranglethornJungle"] = {
		[71953290] = { 38080, "樂譜：Zul'Gurub Voo Doo", "副本：祖爾格拉布\n首領掉落：破神者金度（機率掉落）" },
	}
	points["ZulGurub"] = {
		[50933982] = { 38080, "樂譜：Zul'Gurub Voo Doo", "首領掉落：破神者金度（機率掉落）" },
	}
end


--------------
-- Kalimdor --
--------------

points["Ashenvale"] = {
	[56404923] = { 38090, "樂譜：Magic", "打開走失哨兵的行囊取得(在樹幹中)" }
}

points["Darnassus"] = {
	[43007600] = { 38100, "樂譜：Shalandis Isle", "打開高階祭師的聖匣取得\n在月神殿的第二層，泰蘭妲·語風的對面" },
}

points["Tanaris"] = {
	[61705195] = { 38066, "樂譜：The Shattering", "團隊副本：巨龍之魂\n首領掉落：死亡之翼的狂亂（機率掉落）" },
}

points["Winterspring"] = {
	[68007390] = { 38089, "樂譜：Mountains", "打開冰凍的補給品取得(在塔底)" },
}

if playerFaction == "Horde" then
	points["Mulgore"] = {
		[35882188] = { 38076, "樂譜：Mulgore Plains", "在雷霆崖\n在預見之池的水池釣魚有機會取得" },
	}
	points["ThunderBluff"] = {
		[25701640] = { 38076, "樂譜：Mulgore Plains", "在預見之池的水池釣魚有機會取得" },
	}
end


-------------
-- Outland --
-------------

points["ShadowmoonValley"] = {
	[57384968] = { 38091, "樂譜：The Black Temple", "在典獄官監牢內\n打開看守者的卷軸匣取得" },
	[70994642] = { 38064, "樂譜：The Burning Legion", "團隊副本：黑暗神廟\n首領掉落：伊利丹‧怒風（機率掉落）" },
}


---------------
-- Northrend --
---------------

points["Dragonblight"] = {
	[87335092] = { 38065, "樂譜：Wrath of the Lich King", "團隊副本：納克薩瑪斯\n首領掉落：科爾蘇加德（機率掉落）" },
}

points["HallsofLightning"] = {
	[19185606] = { 38098, "樂譜：Mountains of Thunder", "區域：造物者步道\n首領掉落：洛肯（機率掉落）" },
}

points["IcecrownCitadel"] = {
	[49795290] = { 38092, "樂譜：Invincible", "區域：冰封王座\n首領掉落：巫妖王（機率掉落）" }
}

points["IcecrownGlacier"] = {
	[53838714] = { 38092, "樂譜：Invincible", "團隊副本：冰冠城塞\n首領掉落：巫妖王（機率掉落）" }
}

points["Naxxramas"] = {
	[36542288] = { 38065, "樂譜：Wrath of the Lich King", "區域：亡域上層\n首領掉落：科爾蘇加德（機率掉落）" },
}

points["TheStormPeaks"] = {
	[45292148] = { 38098, "樂譜：Mountains of Thunder", "副本：雷光大廳\n首領掉落：洛肯（機率掉落）" },
}

if playerFaction == "Alliance" then
	points["IcecrownGlacier"][75951993] = { 38094, "樂譜：The Argent Tournament", "商人：任何一位陣營軍需官\n費用：25個[勇士徽印]" }
	points["GrizzlyHills"] = {
		[57113318] = { 38097, "樂譜：Totems of the Grizzlemaw", "跟瑞明頓‧布羅德說話取得\n\n瑞明頓‧布羅德會沿著灰白之丘的大路走動\n(從琥珀松小屋出發，向西經過花崗岩之泉，\n向南經過征服堡，向東經過沃德盧恩，\n向東北穿過灰喉鎮的西邊，向東北穿過西部荒野駐營，\n向東南穿過歐尼克瓦營地，最後走到歐尼克瓦營地南部的塔。)\n\n說話順序：1.<深呼吸。> 2.我在尋找一首曲子… 3.關於野外的曲子。 4.要！" },
	}
end

if playerFaction == "Horde" then
	points["IcecrownGlacier"][75952363] = { 38094, "樂譜：The Argent Tournament", "商人：任何一位陣營軍需官\n費用：25個[勇士徽印]" }
	points["GrizzlyHills"] = {
		[22026934] = { 38097, "樂譜：Totems of the Grizzlemaw", "跟瑞明頓‧布羅德說話取得\n\n瑞明頓‧布羅德會沿著灰白之丘的大路走動\n(從琥珀松小屋出發，向西經過花崗岩之泉，\n向南經過征服堡，向東經過沃德盧恩，\n向東北穿過灰喉鎮的西邊，向東北穿過西部荒野駐營，\n向東南穿過歐尼克瓦營地，最後走到歐尼克瓦營地南部的塔。)\n\n說話順序：1.<深呼吸。> 2.我在尋找一首曲子… 3.關於野外的曲子。 4.要！" },
	}
end


---------------
-- Cataclysm --
---------------

points["DarkmoonFaireIsland"] = {
	[51507505] = { 38099, "樂譜：Darkmoon Carousel", "商人：卻斯特\n費用：90個[暗月獎品卷]." }
}


--------------
-- Pandaria --
--------------

points["TheHiddenPass"] = {
	[48486149] = { 38067, "樂譜：Heart of Pandaria", "團隊副本：豐泉台\n首領掉落：恐懼之煞（機率掉落）" },
}

points["TerraceOfEndlessSpring"] = {
	[38914829] = { 38067, "樂譜：Heart of Pandaria", "首領掉落：恐懼之煞（機率掉落）" },
}

points["ValeofEternalBlossoms"] = {
	[82222928] = { 38102, "樂譜：Song of Liu Lang", "商人：譚杏桃\n費用：100金\n需要博學行者 - 崇敬" },
}

if playerFaction == "Alliance" then
	points["Krasarang"] = {
		[89533354] = { 38071, "樂譜：High Seas", "商人：供應商格蘭特雷\n費用：500個[制霸岬委任徽章]購買" },
	}
end

if playerFaction == "Horde" then
	points["Krasarang"] = {
		[10605360] = { 38072, "樂譜：War March", "商人：「黑齒」歐格姆\n費用：500個[制霸岬委任徽章]購買" },
	}
end


-------------
-- Draenor --
-------------

points["FoundryRaid"] = {
	[48363460] = { 38068, "樂譜：A Siege of Worlds", "區域：大爐缸\n團隊搜尋器：黑手的考驗\n首領掉落：黑手（機率掉落）" },
}

points["Gorgrond"] = {
	[51562724] = { 38068, "樂譜：A Siege of Worlds", "團隊副本：黑石鑄造場\n團隊搜尋器：黑手的考驗\n首領掉落：黑手（機率掉落）" },
}
