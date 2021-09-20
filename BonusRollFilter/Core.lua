local BonusRollFilter = LibStub("AceAddon-3.0"):NewAddon("BonusRollFilter", "AceConsole-3.0", "AceHook-3.0")
local BRF_ShowBonusRoll = false
local BRF_RollFrame = nil
local BRF_UserAction = false

local BRF_NightholdEncounters = {1706,1725,1731,1751,1762,1713,1761,1732,1743,1737}
local BRF_NightmareEncounters = {1703,1744,1738,1667,1704,1750,1726}
local BRF_TrialOfValorEncounters = {1819, 1830, 1829}
local BRF_WorldBossEncounters = {1790,1956,1883,1774,1789,1795,1770,1769,1884,1783,1749,1763,1885,1756,1796}
local BRF_TombOfSargerasEncounters = {1862, 1867, 1856, 1903, 1861, 1896, 1897, 1873, 1898}
local BRF_AntorusEncounters = {1992, 1987, 1997, 1985, 2025, 2009, 2004, 1983, 1986, 1984, 2031}
local BRF_ArugsInvasionEncounters = {2010, 2011, 2012, 2013, 2014, 2015}

local BonusRollFilter_OptionsDefaults = {
    profile = {
        [14] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- World bosses
            [1790] = false,
            [1956] = false,
            [1883] = false,
            [1774] = false,
            [1789] = false,
            [1795] = false,
            [1770] = false,
            [1769] = false,
            [1884] = false,
            [1783] = false,
            [1749] = false,
            [1763] = false,
            [1885] = false,
            [1756] = false,
            [1796] = false,
            -- Argus Invasion Points
            [2010] = false, 
            [2011] = false, 
            [2012] = false, 
            [2013] = false, 
            [2014] = false, 
            [2015] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false,
            -- Antorus, the Burning Throne
            [2031] =  false,
            [1992] =  false, 
            [1987] =  false, 
            [1997] =  false, 
            [1985] =  false, 
            [2025] =  false, 
            [2009] =  false, 
            [2004] =  false, 
            [1983] =  false, 
            [1986] =  false, 
            [1984] =  false, 
        },
        [15] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false,
            -- Antorus, the Burning Throne
            [2031] =  false,
            [1992] =  false, 
            [1987] =  false, 
            [1997] =  false, 
            [1985] =  false, 
            [2025] =  false, 
            [2009] =  false, 
            [2004] =  false, 
            [1983] =  false, 
            [1986] =  false, 
            [1984] =  false, 
        },
        [16] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false,
            -- Antorus, the Burning Throne
            [2031] =  false,
            [1992] =  false, 
            [1987] =  false, 
            [1997] =  false, 
            [1985] =  false, 
            [2025] =  false, 
            [2009] =  false, 
            [2004] =  false, 
            [1983] =  false, 
            [1986] =  false, 
            [1984] =  false, 
        },
        [17] = {
            -- Nighthold
            [1706] = false,
            [1725] = false,
            [1731] = false,
            [1751] = false,
            [1762] = false,
            [1713] = false,
            [1761] = false,
            [1732] = false,
            [1743] = false,
            [1737] = false,
            -- Emerald Nightmare
            [1703] = false,
            [1744] = false,
            [1738] = false,
            [1667] = false,
            [1704] = false,
            [1750] = false,
            [1726] = false,
            -- Trial of Valor
            [1819] = false,
            [1830] = false,
            [1829] = false,
            -- Tomb of Sargeras
            [1862] = false, 
            [1867] = false, 
            [1856] = false, 
            [1903] = false, 
            [1861] = false, 
            [1896] = false, 
            [1897] = false, 
            [1873] = false, 
            [1898] = false,
            -- Antorus, the Burning Throne
            [2031] =  false,
            [1992] =  false, 
            [1987] =  false, 
            [1997] =  false, 
            [1985] =  false, 
            [2025] =  false, 
            [2009] =  false, 
            [2004] =  false, 
            [1983] =  false, 
            [1986] =  false, 
            [1984] =  false, 
        },
        [23] = false
    }
}

local BonusRollFilter_OptionsTable = {
    type = "group",
	name = "骰子過濾",
    args = {
        helpText = {
            name = "選擇 \"不要\" 出現額外戰利品骰子的首領",
            fontSize = "medium",
            type = "description",
        },
        tombOfSargeras = {
            name = "薩格拉斯之墓",
            type = "group",
            order = 1,
            args = {
                tombOfSargerasAllLFROn = {
                    name = "隱藏所有隨機團隊",
                    desc = "隱藏隨機團隊薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                tombOfSargerasAllLFROff = {
                    name = "顯示所有隨機團隊",
                    desc = "顯示隨機團隊薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "隨機團隊",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1862] = "苟洛斯", 
                        [1867] = "惡魔審判官", 
                        [1856] = "哈亞潭", 
                        [1903] = "月光議會", 
                        [1861] = "薩絲茵女士", 
                        [1896] = "荒寂聚合體", 
                        [1897] = "戒守聖女", 
                        [1873] = "墮落化身", 
                        [1898] = "基爾加丹"
                    }
                },
                tombOfSargerasAllNormalOn = {
                    name = "隱藏所有普通",
                    desc = "隱藏普通薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                tombOfSargerasAllNormalOff = {
                    name = "顯示所有普通",
                    desc = "顯示普通薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "普通",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1862] = "苟洛斯", 
                        [1867] = "惡魔審判官", 
                        [1856] = "哈亞潭", 
                        [1903] = "月光議會", 
                        [1861] = "薩絲茵女士", 
                        [1896] = "荒寂聚合體", 
                        [1897] = "戒守聖女", 
                        [1873] = "墮落化身", 
                        [1898] = "基爾加丹"
                    }
                },
                tombOfSargerasdAllHeroicOn = {
                    name = "隱藏所有英雄",
                    desc = "隱藏英雄薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                tombOfSargerasAlHeroicOff = {
                    name = "顯示所有英雄",
                    desc = "顯示英雄薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "英雄",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1862] = "苟洛斯", 
                        [1867] = "惡魔審判官", 
                        [1856] = "哈亞潭", 
                        [1903] = "月光議會", 
                        [1861] = "薩絲茵女士", 
                        [1896] = "荒寂聚合體", 
                        [1897] = "戒守聖女", 
                        [1873] = "墮落化身", 
                        [1898] = "基爾加丹"
                    }
                },
                tombOfSargerasAllMythicOn = {
                    name = "隱藏所有傳奇",
                    desc = "隱藏傳奇薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                tombOfSargerasAllMythicOff = {
                    name = "顯示所有傳奇",
                    desc = "顯示傳奇薩格拉斯之墓所有首領的額外戰利品骰子",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TombOfSargerasEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "傳奇",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1862] = "苟洛斯", 
                        [1867] = "惡魔審判官", 
                        [1856] = "哈亞潭", 
                        [1903] = "月光議會", 
                        [1861] = "薩絲茵女士", 
                        [1896] = "荒寂聚合體", 
                        [1897] = "戒守聖女", 
                        [1873] = "墮落化身", 
                        [1898] = "基爾加丹"
                    }
                }
            }
        },
        nighthold={
            name = "暗夜堡",
            type = "group",
            order = 2,
            args={
                nightholdAllLFROn = {
                    name = "隱藏所有隨機團隊",
                    desc = "隱藏隨機團隊暗夜堡所有首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                nightholdAllLFROff = {
                    name = "顯示所有隨機團隊",
                    desc = "顯示隨機團隊暗夜堡所有首領的額外戰利品骰子",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "隨機團隊",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1706] = "斯寇派隆",
                        [1725] = "時光異象",
                        [1731] = "提里埃斯",
                        [1751] = "法刃艾露莉亞",
                        [1762] = "提克迪奧斯",
                        [1713] = "克羅索斯",
                        [1761] = "大植物學家泰亞恩",
                        [1732] = "星占師伊崔斯",
                        [1743] = "大博學者艾莉珊德",
                        [1737] = "古爾丹",
                    }
                },
                nightholdAllNormalOn = {
                    name = "隱藏所有普通",
                    desc = "隱藏普通暗夜堡所有首領的額外戰利品骰子",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                nightholdAllNormalOff = {
                    name = "顯示所有普通",
                    desc = "顯示普通暗夜堡所有首領的額外戰利品骰子",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "普通",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1706] = "斯寇派隆",
                        [1725] = "時光異象",
                        [1731] = "提里埃斯",
                        [1751] = "法刃艾露莉亞",
                        [1762] = "提克迪奧斯",
                        [1713] = "克羅索斯",
                        [1761] = "大植物學家泰亞恩",
                        [1732] = "星占師伊崔斯",
                        [1743] = "大博學者艾莉珊德",
                        [1737] = "古爾丹",
                    }
                },
                nightholdAllHeroicOn = {
                    name = "隱藏所有英雄",
                    desc = "隱藏英雄暗夜堡所有首領的額外戰利品骰子",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                nightholdAlHeroicOff = {
                    name = "顯示所有英雄",
                    desc = "顯示英雄暗夜堡所有首領的額外戰利品骰子",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "英雄",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1706] = "斯寇派隆",
                        [1725] = "時光異象",
                        [1731] = "提里埃斯",
                        [1751] = "法刃艾露莉亞",
                        [1762] = "提克迪奧斯",
                        [1713] = "克羅索斯",
                        [1761] = "大植物學家泰亞恩",
                        [1732] = "星占師伊崔斯",
                        [1743] = "大博學者艾莉珊德",
                        [1737] = "古爾丹",
                    }
                },
                nightholdAllMythicOn = {
                    name = "隱藏所有傳奇",
                    desc = "隱藏傳奇暗夜堡所有首領的額外戰利品骰子",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                nightholdAllMythicOff = {
                    name = "顯示所有傳奇",
                    desc = "顯示傳奇暗夜堡所有首領的額外戰利品骰子",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightholdEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "傳奇",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1706] = "斯寇派隆",
                        [1725] = "時光異象",
                        [1731] = "提里埃斯",
                        [1751] = "法刃艾露莉亞",
                        [1762] = "提克迪奧斯",
                        [1713] = "克羅索斯",
                        [1761] = "大植物學家泰亞恩",
                        [1732] = "星占師伊崔斯",
                        [1743] = "大博學者艾莉珊德",
                        [1737] = "古爾丹",
                    }
                }
            }
        },
        emeraldNightmare={
            name = "翡翠夢靨",
            type = "group",
            order = 3,
            args={
                emeraldNightmareAllLFROn = {
                    name = "隱藏所有隨機團隊",
                    desc = "隱藏隨機團隊翡翠夢靨所有首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                emeraldNightmareAllLFROff = {
                    name = "顯示所有隨機團隊",
                    desc = "顯示隨機團隊翡翠夢靨所有首領的額外戰利品骰子",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "隨機團隊",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1703] = "奈珊卓拉",
                        [1744] = "艾樂瑞斯．雷弗拉爾",
                        [1738] = "『腐化之心』伊蓋諾斯",
                        [1667] = "厄索克",
                        [1704] = "夢靨之龍",
                        [1750] = "塞納留斯",
                        [1726] = "薩維斯",
                    }
                },
                emeraldNightmareAllNormalOn = {
                    name = "隱藏所有普通",
                    desc = "隱藏普通翡翠夢靨所有首領的額外戰利品骰子",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                emeraldNightmareAllNormalOff = {
                    name = "顯示所有普通",
                    desc = "顯示普通翡翠夢靨所有首領的額外戰利品骰子",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "普通",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1703] = "奈珊卓拉",
                        [1744] = "艾樂瑞斯．雷弗拉爾",
                        [1738] = "『腐化之心』伊蓋諾斯",
                        [1667] = "厄索克",
                        [1704] = "夢靨之龍",
                        [1750] = "塞納留斯",
                        [1726] = "薩維斯",
                    }
                },
                emeraldNightmareAllHeroicOn = {
                    name = "隱藏所有英雄",
                    desc = "隱藏英雄翡翠夢靨所有首領的額外戰利品骰子",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                emeraldNightmareAlHeroicOff = {
                    name = "顯示所有英雄",
                    desc = "顯示英雄翡翠夢靨所有首領的額外戰利品骰子",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "英雄",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1703] = "奈珊卓拉",
                        [1744] = "艾樂瑞斯．雷弗拉爾",
                        [1738] = "『腐化之心』伊蓋諾斯",
                        [1667] = "厄索克",
                        [1704] = "夢靨之龍",
                        [1750] = "塞納留斯",
                        [1726] = "薩維斯",
                    }
                },
                emeraldNightmareAllMythicOn = {
                    name = "隱藏所有傳奇",
                    desc = "隱藏傳奇翡翠夢靨所有首領的額外戰利品骰子",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                emeraldNightmareAllMythicOff = {
                    name = "顯示所有傳奇",
                    desc = "顯示傳奇翡翠夢靨所有首領的額外戰利品骰子",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_NightmareEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "傳奇",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1703] = "奈珊卓拉",
                        [1744] = "艾樂瑞斯．雷弗拉爾",
                        [1738] = "『腐化之心』伊蓋諾斯",
                        [1667] = "厄索克",
                        [1704] = "夢靨之龍",
                        [1750] = "塞納留斯",
                        [1726] = "薩維斯",
                    }
                }
            }
        },
        trialOfValor={
            name = "勇氣試煉",
            type = "group",
            order = 4,
            args={
                trialOfValorAllLFROn = {
                    name = "隱藏所有隨機團隊",
                    desc = "隱藏隨機團隊勇氣試煉所有首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                trialOfValorAllLFROff = {
                    name = "顯示所有隨機團隊",
                    desc = "顯示隨機團隊勇氣試煉所有首領的額外戰利品骰子",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "隨機團隊",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1819] = "歐丁",
                        [1830] = "加爾姆",
                        [1829] = "黑爾雅",
                    }
                },
                trialOfValorAllNormalOn = {
                    name = "隱藏所有普通",
                    desc = "隱藏普通勇氣試煉所有首領的額外戰利品骰子",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                trialOfValorAllNormalOff = {
                    name = "顯示所有普通",
                    desc = "顯示普通勇氣試煉所有首領的額外戰利品骰子",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "普通",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1819] = "歐丁",
                        [1830] = "加爾姆",
                        [1829] = "黑爾雅",
                    }
                },
                trialOfValorAllHeroicOn = {
                    name = "隱藏所有英雄",
                    desc = "隱藏英雄勇氣試煉所有首領的額外戰利品骰子",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                trialOfValorAlHeroicOff = {
                    name = "顯示所有英雄",
                    desc = "顯示英雄勇氣試煉所有首領的額外戰利品骰子",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "英雄",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1819] = "歐丁",
                        [1830] = "加爾姆",
                        [1829] = "黑爾雅",
                    }
                },
                trialOfValorAllMythicOn = {
                    name = "隱藏所有傳奇",
                    desc = "隱藏傳奇勇氣試煉所有首領的額外戰利品骰子",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                trialOfValorAllMythicOff = {
                    name = "顯示所有傳奇",
                    desc = "顯示傳奇勇氣試煉所有首領的額外戰利品骰子",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_TrialOfValorEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "傳奇",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1819] = "歐丁",
                        [1830] = "加爾姆",
                        [1829] = "黑爾雅",
                    }
                }
            }
        },
        antorus={
            name = "安托洛斯，燃燒王座",
            type = "group",
            order = 5,
            args={
                antorusAllLFROn = {
                    name = "隱藏所有隨機團隊",
                    desc = "隱藏隨機團隊燃燒王座所有首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[17][value] = true
                        end
                    end,
                },
                antorusAllLFROff = {
                    name = "顯示所有隨機團隊",
                    desc = "顯示隨機團隊燃燒王座所有首領的額外戰利品骰子",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[17][value] = false
                        end
                    end,
                },
                lfr={
                    name = "隨機團隊",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[17][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[17][key]
                    end,
                    values={
                        [1992] =  "加洛斯碎界者", 
                        [1987] =  "薩格拉斯惡魔犬", 
                        [1997] =  "安托洛斯至高戰事議會", 
                        [1985] =  "『守門者』海瑟貝爾", 
                        [2025] =  "『生命守縛者』伊歐娜", 
                        [2009] =  "『獵魂者』伊莫納爾", 
                        [2004] =  "金加洛斯", 
                        [1983] =  "瓦里瑪薩斯", 
                        [1986] =  "希瓦拉巫女", 
                        [1984] =  "阿格拉瑪",
                        [2031] =  "『滅界者』阿古斯",
                    }
                },
                antorusAllNormalOn = {
                    name = "隱藏所有普通",
                    desc = "隱藏普通燃燒王座所有首領的額外戰利品骰子",
                    order = 4,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                antorusAllNormalOff = {
                    name = "顯示所有普通",
                    desc = "顯示普通燃燒王座所有首領的額外戰利品骰子",
                    order = 5,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "普通",
                    type = "multiselect",
                    order = 6,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1992] =  "加洛斯碎界者", 
                        [1987] =  "薩格拉斯惡魔犬", 
                        [1997] =  "安托洛斯至高戰事議會", 
                        [1985] =  "『守門者』海瑟貝爾", 
                        [2025] =  "『生命守縛者』伊歐娜", 
                        [2009] =  "『獵魂者』伊莫納爾", 
                        [2004] =  "金加洛斯", 
                        [1983] =  "瓦里瑪薩斯", 
                        [1986] =  "希瓦拉巫女", 
                        [1984] =  "阿格拉瑪",
                        [2031] =  "『滅界者』阿古斯",
                    }
                },
                antorusllHeroicOn = {
                    name = "隱藏所有英雄",
                    desc = "隱藏英雄燃燒王座所有首領的額外戰利品骰子",
                    order = 7,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[15][value] = true
                        end
                    end,
                },
                trialOfValorAlHeroicOff = {
                    name = "顯示所有英雄",
                    desc = "顯示英雄燃燒王座所有首領的額外戰利品骰子",
                    order = 8,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[15][value] = false
                        end
                    end,
                },
                heroic={
                    name = "英雄",
                    type = "multiselect",
                    order = 9,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[15][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[15][key]
                    end,
                    values={
                        [1992] =  "加洛斯碎界者", 
                        [1987] =  "薩格拉斯惡魔犬", 
                        [1997] =  "安托洛斯至高戰事議會", 
                        [1985] =  "『守門者』海瑟貝爾", 
                        [2025] =  "『生命守縛者』伊歐娜", 
                        [2009] =  "『獵魂者』伊莫納爾", 
                        [2004] =  "金加洛斯", 
                        [1983] =  "瓦里瑪薩斯", 
                        [1986] =  "希瓦拉巫女", 
                        [1984] =  "阿格拉瑪",
                        [2031] =  "『滅界者』阿古斯",
                    }
                },
                antorusAllMythicOn = {
                    name = "隱藏所有傳奇",
                    desc = "隱藏傳奇燃燒王座所有首領的額外戰利品骰子",
                    order = 10,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[16][value] = true
                        end
                    end,
                },
                antorusAllMythicOff = {
                    name = "顯示所有傳奇",
                    desc = "顯示傳奇燃燒王座所有首領的額外戰利品骰子",
                    order = 11,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_AntorusEncounters) do
                            BonusRollFilter.db.profile[16][value] = false
                        end
                    end,
                },
                mythic={
                    name = "傳奇",
                    type = "multiselect",
                    order = 12,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[16][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[16][key]
                    end,
                    values={
                        [1992] =  "加洛斯碎界者", 
                        [1987] =  "薩格拉斯惡魔犬", 
                        [1997] =  "安托洛斯至高戰事議會", 
                        [1985] =  "『守門者』海瑟貝爾", 
                        [2025] =  "『生命守縛者』伊歐娜", 
                        [2009] =  "『獵魂者』伊莫納爾", 
                        [2004] =  "金加洛斯", 
                        [1983] =  "瓦里瑪薩斯", 
                        [1986] =  "希瓦拉巫女", 
                        [1984] =  "阿格拉瑪",
                        [2031] =  "『滅界者』阿古斯",
                    }
                }
            }
        },
        worldBosses={
            name = "世界首領",
            type = "group",
            order = 6,
            args={
                worldBossesAllOn = {
                    name = "隱藏所有世界首領",
                    desc = "隱藏所有世界首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_WorldBossEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                worldBossesAllOff = {
                    name = "顯示所有世界首領",
                    desc = "顯示所有世界首領的額外戰利品骰子",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_WorldBossEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "世界首領",
                    type = "multiselect",
                    order = 4,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [1790] = "亞娜慕茲",
                        [1956] = "亞破克隆",
                        [1883] = "布魯托魯斯",
                        [1774] = "卡拉米爾",
                        [1789] = "『霜血』督剛",
                        [1795] = "弗洛山",
                        [1770] = "休蒙格里斯",
                        [1769] = "利薇妲斯",
                        [1884] = "梅里費克斯",
                        [1783] = "惡魔納札卡",
                        [1749] = "尼索格",
                        [1763] = "薩索斯",
                        [1885] = "希娃旭",
                        [1756] = "奪魂者",
                        [1796] = "凋萎者吉姆",
                    }
                }
            }
        },
		argusInvasions = {
            name = "阿古斯侵略點",
            type = "group",
            order = 7,
            args = {
                argusBossesAllOn = {
                    name = "隱藏所有阿古斯首領",
                    desc = "隱藏所有阿古斯首領的額外戰利品骰子",
                    order = 1,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_ArugsInvasionEncounters) do
                            BonusRollFilter.db.profile[14][value] = true
                        end
                    end,
                },
                argusBossesAllOff = {
                    name = "顯示所有阿古斯首領",
                    desc = "顯示所有阿古斯首領的額外戰利品骰子",
                    order = 2,
                    type = "execute",
                    func = function(info, val)
                        for key, value in pairs(BRF_ArugsInvasionEncounters) do
                            BonusRollFilter.db.profile[14][value] = false
                        end
                    end,
                },
                normal={
                    name = "阿古斯侵略點首領",
                    type = "multiselect",
                    order = 3,
                    set = function(info, key, value)
                        BonusRollFilter.db.profile[14][key] = value
                    end,
                    get = function(info, key)
                        return BonusRollFilter.db.profile[14][key]
                    end,
                    values={
                        [2010] = "鬼母佛努娜",
                        [2011] = "魔女雅露拉黛兒",
                        [2012] = "審判官梅托",
                        [2013] = "歐庫雷洛斯",
                        [2014] = "梭塔納索",
                        [2015] = "深淵領主邪莫斯",
                    }
                }
            }
        },
        dungeons={
            name = "傳奇地城",
            type = "group",
            order = 8,
            args={
                disable = {
                    name = "傳奇地城",
                    desc = "停用傳奇地城中的額外戰利品骰子",
                    descStyle = "inline",
                    type = "toggle",
                    set = function(info, val) BonusRollFilter.db.profile[23] = val end,
                    get = function(info) return BonusRollFilter.db.profile[23] end
                }
            }
        },
    }
}

function BonusRollFilter:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("BRF_Data", BonusRollFilter_OptionsDefaults)
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BonusRollFilter", BonusRollFilter_OptionsTable)
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("BonusRollFilter_Profiles",LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BonusRollFilter", "骰子過濾")
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("BonusRollFilter_Profiles", "設定檔", "骰子過濾")

    self:RegisterChatCommand("brf", "SlashCommand")
    self:RegisterChatCommand("bonusrollfilter", "SlashCommand")

    self:SecureHookScript(BonusRollFrame, "OnShow", "BonusRollFrame_OnShow")
    self:SecureHookScript(BonusRollFrame.PromptFrame.RollButton, "OnClick", "RollButton_OnClick")
    self:SecureHookScript(BonusRollFrame.PromptFrame.PassButton, "OnClick", "PassButton_OnClick")
end

function BonusRollFilter:RollButton_OnClick()
    BRF_UserAction = true
end

function BonusRollFilter:PassButton_OnClick()
    BRF_UserAction = true
end

function BonusRollFilter:BonusRollFrame_OnShow(frame)
    BRF_RollFrame = frame
    BRF_UserAction = false

    if (BRF_RollFrame.difficultyID == 23) then
        if (self.db.profile[BRF_RollFrame.difficultyID] == true and BRF_ShowBonusRoll == false) then
            self:Print('額外戰利品骰子已隱藏，輸入 /brf show 將它重新顯示出來。')
            BRF_RollFrame:Hide()
        end
    elseif(self.db.profile[BRF_RollFrame.difficultyID][BRF_RollFrame.encounterID] == true and BRF_ShowBonusRoll == false) then
        self:Print('額外戰利品骰子已隱藏，輸入 /brf show 將它重新顯示出來。')
        BRF_RollFrame:Hide()
    end
    BRF_ShowBonusRoll = false
end

function BonusRollFilter:SlashCommand(command)
    if (command == "") then
        self:Print("版本：" .. GetAddOnMetadata("BonusRollFilter", "Version"))
        self:Print("/brf show - 顯示額外戰利品骰子")
        self:Print("/brf config - 開啟設定選項")
    elseif (command == "show") then
        BonusRollFilter:ShowRoll()
    elseif (command == "config") then
        InterfaceOptionsFrame_OpenToCategory("骰子過濾")
        InterfaceOptionsFrame_OpenToCategory("骰子過濾")
    end
end

function BonusRollFilter:ShowRoll()
    if BRF_RollFrame ~= nil and (BRF_RollFrame:IsVisible() == false and time() <= BRF_RollFrame.endTime and BRF_UserAction == false) then
        BRF_ShowBonusRoll = true
        BRF_RollFrame:Show()
    else
        self:Print("沒有可以使用的額外戰利品骰子能夠顯示")
    end
end
