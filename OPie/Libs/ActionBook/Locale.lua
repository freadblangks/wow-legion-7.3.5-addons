local _, T = ...
if T.SkipLocalActionBook then return end
local AB = assert(T.ActionBook:compatible(2, 21), "A compatible version of ActionBook is required.")
local L = AB:locale(true)

local C, z, V = GetLocale(), nil
V =
	C == "deDE" and {
		"Fähigkeiten", "Kampfhaustier", "Kampfhaustiere", "Eigenes Makro", "Ausrüstungsset", "Ausrüstungssets", "Zusätzlicher Aktionsbutton", "Flugreittier", "Bodenreittier", "Gegenstand",
		"Gegenstände", "Makro", "Makros", "Verschiedenes", "Reittier", "Reittiere", "Begleiterfähigkeiten", "Zielmarkierungssymbol", "Weltmarkierung", "Markierungssymbole",
		"Zauber", "Spielzeug", z,
	}
	or C == "esES" and {
		"Habilidades", "Mascota de duelo", "Mascotas de duelo", "Macro personalizado", "Conjunto de equipamientos", "Conjuntos de equipamientos", "Botón de acción extra", "Montura voladora", "Monutra de tierra", "Artículo",
		"Artículos", "Macro", "Macros", "Misceláneo", "Montura", "Monutras", "Habilidades de mascota", "Marcador del mundo", "Marcador del mundo", "Marcadores del mundo",
		"Hechizo", "Juegete", z,
	}
	or C == "esMX" and {
		"Habilidades", "Mascota de duelo", "Mascotas de duelo", "Macro personalizado", "Conjunto de equipamientos", "Conjuntos de equipamientos", "Botón de acción extra", "Montura voladora", "Monutra de tierra", "Artículo",
		"Artículos", "Macro", "Macros", "Misceláneo", "Montura", "Monutras", "Habilidades de mascota", "Marcador del mundo", "Marcador del mundo", "Marcadores del mundo",
		"Hechizo", "Juegete", z,
	}
	or C == "frFR" and {
		"Capacités", "Battle Pet", "Battle pets", "Macro personnalisée", "Équipement de Set", "Equipement de sets", "Extra Action Button", "Montures volante", "Monture terrestre", "Item",
		"Items", "Macro", "Macros", "Divers", "Monture", "Montures", "Capacités du Pet", "Marqueur de RAID", "Marqueur de RAID mondial", "Marqueur de RAID",
		"Sort", "Jouet", z,
	}
	or C == "koKR" and {
		"능력", "애완동물 대전", "애완동물 대전", "사용자 정의 매크로", "장비 구성", "장비 구성", "추가 작업 단추", "나는 탈것", "지상 탈것", "아이템",
		"아이템", "매크로", "매크로", "기타", "탈것", "탈것", "애완동물 능력", "공격대 징표", "공격대 위치 표시기", "공격대 징표",
		"주문", "장난감", z,
	}
	or C == "ruRU" and {
		"Способности", "Боевой питомец", "Боевые питомцы", "Пользовательские макросы", "Комплект экипировки", "Комплекты экипировки", z, z, "Наземные средства передвижения", "Предмет",
		"Предметы", "Макрос", "Макросы", "Разное", "Средство передвижения", "Средства передвижения", "Способности питомцев", "Рейдовая метка", z, "Рейдовые метки",
		"Заклинание", "Игрушки", z,
	}
	or C == "zhCN" and {
		"技能", "战宠", "战宠们", "自定义宏", "套装设定", "成套的设备", "额外动作按钮", "飞行坐骑", "陆地坐骑", "物品",
		"物品", "宏", "宏", "杂项", "坐骑", "坐骑", "宠物技能", "团队标记", "团队世界标记", "团队标记",
		"技能", "玩具", z,
	}
	or C == "zhTW" and {
		"技能", "戰寵", "戰寵", "自訂巨集", "套裝", "套裝", "額外動作按鈕", "飛行坐騎", "地面坐騎", "物品",
		"物品", "巨集", "巨集", "雜項", "坐騎", "坐騎", "寵物技能", "團隊標記圖示", "團隊世界標記圖示", "團隊標記圖示",
		"技能", "玩具", "玩具",
	}
local K = { "Abilities", "Battle Pet", "Battle pets", "Custom Macro", "Equipment Set", "Equipment sets", "Extra Action Button", "Flying Mount", "Ground Mount", "Item", "Items", "Macro", "Macros", "Miscellaneous", "Mount", "Mounts", "Pet abilities", "Raid Marker", "Raid World Marker", "Raid markers", "Spell", "Toy", "Toys" }
for i=1,V and #K or 0 do
	L[K[i]] = V[i]
end