local x = {}
x["Version"] = "|cFFFAFA44裝備屬性建議：|cFF00EA00 2018.3.1|r"

--[[ Deathknight Blood]]
x[250] = "平衡：Str > Haste > Vers > Crit > Mast \n最大輸出：Str > Haste > Crit > Vers > Mast \n生存能力：Str > Haste > Vers > Mast > Crit"
--[[ Deathknight Frost]]
x[251] = "Str > Mast 40% > (Haste 30% = Crit 30%) > Vers"
--[[ Deathknight Unholy]]
x[252] = "Str > Haste 26% > Mast > Crit > Vers > Haste"

--[[ Druid Balance]]
x[102] = "單目標：(Mast = Haste) > (Crit = Vers) > Int \n多目標：Mast > Haste > (Crit = Vers) > Int"
--[[ Druid Feral]]
x[103] =  "遍體鱗傷：Vers > Crit > Haste > Agi > Mast"
--[[ Druid Guardian]]
x[104] = "Armor > Stam > Vers > Mast > Haste > Crit > Agi"
--[[ Druid Restoration]]
x[105] = "補團隊：(Haste ~= Crit) > Mast > Vers > Int \n補坦/傳奇+：Mast > Haste > Crit > Vers > Int"

--[[ Hunter Beastmaster]]
x[253] = "Crit > Haste > Mast > Vers"
--[[ Hunter Marksmanship]]
x[254] = "Mast > Crit > Haste > Vers"
--[[ Hunter Survival]]
x[255] = "Haste > (Crit / Vers) > Mast"

--[[ Mage Arcane]]
x[62] = "Haste > Vers > Crit > Mast > Int"
--[[ Mage Fire]]
x[63] = "Mast > (Haste = Vers) > Int > Crit"
--[[ Mage Fros]]
x[64] = "(Vers = Haste) > Crit 30% > Int > Mast > Crit"

--[[ Monk Brewmaster]]
x[268] = "(Mast = Crit = Vers) > Haste 14.3%"
--[[ Monk Mistweaver]]
x[270] = "標準：Int > Crit > Vers > Haste > Mast \n攻擊補血：Int > Vers > (Haste >= Crit) > Mast \n傳奇+：Int > (Haste = Mast) > Vers > Crit"
--[[ Monk Windwalker]]
x[269] = "單目標：Agi > Mast > Crit > Vers > Haste \n多目標：Agi > Mast > Haste > Crit > Vers"

--[[ Paladin Holy]]
x[65] = "Int > Crit > Mast > Vers > Haste"
--[[ Paladin Protection]]
x[66] = "生存能力：Haste > Vers > Mast > Crit > Stam \n最大輸出：Haste > Crit > Mast > Vers > Stam"
--[[ Paladin Retribution]]
x[70] = "(Mast ~= Haste) > (Vers ~= Crit = Str)"

--[[ Priest Discipline]]
x[256] = "Int > Haste > Crit > Mast > Vers"
--[[ Priest Holy]]
x[257] = "Int > Mast > Crit > Haste > Vers"
--[[ Priest Shadow]]
x[258] = "Haste > Crit > Mast > Vers > Int"

--[[ Rogue Assassination]]
x[259] = "標準：Agi > Mast > Vers > Crit > Haste \n放血：Agi > Vers > Crit > Mast > Haste"
--[[ Rogue Outlaw]]
x[260] = "(Vers = Haste) > Agi > Crit > Mast"
--[[ Rogue Subtlety]]
x[261] = "Agi > (Mast >= Vers) > Crit > Haste"

--[[ Shaman Elemental]]
x[262] = "冰怒：Crit > Haste > Mast > Vers > Int \n卓越術：Crit > Mast > Haste > Vers > Int"
--[[ Shaman Enhancement]]
x[263] = "(Haste = Mast) > Vers > Crit > Agi"
--[[ Shaman Restoration]]
x[264] = "Crit > (Vers = Mast = Haste) > Int"

--[[ Warlock Affliction]]
x[265] = "Mast > Haste > Crit > Vers > Int"
--[[ Warlock Demonology]]
x[266] = "Haste > (Crit = Mast) > Int > Vers"
--[[ Warlock Destruction]]
x[267] = "Haste > Crit > Int > Vers > Mast \nT20 4件套裝：Haste > Mast > Int > Crit > Vers"

--[[ Warrior Arms]]
x[71] = "Mast > (Haste = Vers = Crit) > Str"
--[[ Warrior Fury]]
x[72] = "Haste > Mast > Vers > Crit > Str"
--[[ Warrior Protection]]
x[73] = "Str > Haste > (Mast >= Vers) > Crit > Stam"

--[[ Demon Hunter Havoc]]
x[577] = "經典惡魔之刃：Crit > Haste > Vers > Agi > Mast \n 魔體轉化：Crit > Mast > Vers > Haste > Agi"
--[[ Demon Hunter Vengeance]]
x[581] = "生存能力：Agi > Haste 20% >= Mast > Vers > Crit > Haste \n最大輸出：Agi > Crit >= Vers >= Mast >= Haste \n傳奇+：Agi > Mast > Vers > Haste > Crit"
stats_Table = x
