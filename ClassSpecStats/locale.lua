local _, vars = ...;
local Ld, La = {}, {}
local locale = GetLocale()

vars.L = setmetatable({},{
    __index = function(t, s) return La[s] or Ld[s] or rawget(t,s) or s end
})

-- Ld means default (english) if no translation found. So we don't need a translation for "enUS" or "enGB".
Ld["Agi"] = "Agi"
Ld["Crit"] = "Crit"
Ld["Haste"] = "Haste"
Ld["Int"] = "Int"
Ld["Mastery"] = "Mastery"
Ld["Sta"] = "Stam"
Ld["Str"] = "Str"
Ld["Vers"] = "Vers"
Ld["Armor"] = "Armor"

if locale == "deDE" then do end
	La["Agi"] = "Bewegl."
	La["Haste"] = "Tempo"
	La["Crit"] = "Krit"
	La["Int"] = "Int"
	La["Mastery"] = "Meistersch."
	La["Sta"] = "Ausdauer"
	La["Str"] = "St\195\164rke"
	La["Vers"] = "Vielseitigk."
	La["Armor"] = "R\195\188stung"
elseif locale == "ruRU" then do end
	La["Agi"] = "Ловкость"
	La["Haste"] = "Скорость"
	La["Crit"] = "Крит."
	La["Int"] = "Интеллект"
	La["Mastery"] = "Искустность"
	La["Sta"] = "Выносливость"
	La["Str"] = "Сила"
	La["Vers"] = "Универсальность"
	La["Armor"] = "Броня"
elseif locale == "frFR" then do end
	La["Agi"] = "Agi"
	La["Haste"] = "Hâte"
	La["Crit"] = "Crit"
	La["Int"] = "Intel"
	La["Mastery"] = "Maîtrise"
	La["Sta"] = "Endu"
	La["Str"] = "Force"
	La["Vers"] = "Poly"
	La["Armor"] = "Armure"
elseif locale == "koKR" then do end
	La["Agi"] = "민첩성"
	La["Haste"] = "가속"
	La["Crit"] = "치명타"
	La["Int"] = "지능"
	La["Mastery"] = "특화"
	La["Sta"] = "체력"
	La["Str"] = "힘"
	La["Vers"] = "유연성"
	La["Armor"] = "갑옷"
elseif locale == "zhCN" then do end
	La["Agi"] = "敏捷"
	La["Haste"] = "急速"
	La["Crit"] = "暴击"
	La["Int"] = "智力"
	La["Mastery"] = "精通"
	La["Sta"] = "耐力"
	La["Str"] = "力量"
	La["Vers"] = "全能"
	La["Armor"] = "盔甲"
elseif locale == "zhTW" then do end
	La["Agi"] = "敏捷"
	La["Haste"] = "加速"
	La["Crit"] = "致命"
	La["Int"] = "智力"
	La["Mastery"] = "精通"
	La["Sta"] = "耐力"
	La["Str"] = "力量"
	La["Vers"] = "臨機"
	La["Armor"] = "護甲"
end
