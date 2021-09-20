-- Items
--
-- Handle using items with complex requirements.

-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

local FL = LibStub("LibFishing-1.0");

local GSB = FishingBuddy.GetSettingBool;

local CurLoc = GetLocale();

local TUSKARR_ID = 88535;
local TuskarrItem = {
    ["enUS"] = "Sharpened Tuskarr Spear",
    ["tooltip"] = FBConstants.CONFIG_TUSKAARSPEAR_INFO,
    spell = 128357,
    setting = "UseTuskarrSpear",
    ["default"] = false,
}

local TRAWLER_ID = 152556;
local TrawlerTotem = {
    ["enUS"] = "Trawler Totem",
    spell = 251211,
    setting = "UseTrawlerTotem",
    ["tooltip"] = FBConstants.CONFIG_TUSKAARSPEAR_INFO,
    ["default"] = false,
	visible = function(option)
        return PlayerHasToy(TRAWLER_ID);
    end,
}

local buffs = nil
local function WWJD()
    if not buffs then
        buffs = {}
        buffs[1] = 546; -- Shaman Water Walking
        buffs[2] = 3714; -- DK Path of Frost
        buffs[3] = 11319; -- Elixir of Water Walking
        buffs[4] = 175841; -- Draenic Water Walking Elixir
    end
    for _,buff in ipairs(buffs) do
        if FL:HasBuff(buff) then
            return true
        end
    end
end

local function TuskarrPlan(queue)
    if (not GSB(TuskarrItem.setting) or IsMounted()) then
        return
    end

    -- We're not actually carrying a spear with us...
    if GetItemCount(TuskarrItem.id) == 0 then
        return
    end

    local main = FL:GetMainHandItem(true);
    if (main ~= TuskarrItem.id) then
        -- Only use this if we're not using the Legendary pole (Surface Tension)
        if (not TuskarrItem.tension) then
            TuskarrItem.tension = 201944;
        end
        if (FL:HasBuff(TuskarrItem.tension)) then
            local bergbuff, raftbuff, hasberg, hasraft = FishingBuddy.HasRaftBuff();
            if not (hasberg or hasraft or WWJD()) then
                return
            end
        end
    end

    if (main == TuskarrItem.id or not FL:HasBuff(TuskarrItem.spell)) then
        local s,_,_ = GetItemCooldown(TuskarrItem.id);
        local pole = FL:IsFishingPole();
        if (s == 0 and pole) then
            tinsert(queue, {
                ["itemid"] = TuskarrItem.id,
                ["name"] = TuskarrItem[CurLoc],
            })
        end
        if (pole or main == TuskarrItem.id) then
            if (s == 0) then
                tinsert(queue, {
                    ["itemid"] = TuskarrItem.id,
                    ["name"] = TuskarrItem[CurLoc],
                })
            end
            if (main == TuskarrItem.id) then
                local item = FL:GetBestFishingItem(INVSLOT_MAINHAND)
                if item then
                    local name;
                    _, main, name, _ = FL:SplitFishLink(item.link);
                    tinsert(queue, {
                        ["itemid"] = main,
                        ["name"] = name
                    })
                end
            elseif (not pole) then
                tinsert(queue, {
                    ["itemid"] = main,
                    ["name"] = "fishing pole"
                })
            end
        end
    end
end

local function TrawlerPlan(queue)
    if (not GSB(TrawlerTotem.setting) or IsMounted()) then
        return
    end

    if (PlayerHasToy(TRAWLER_ID) and C_ToyBox.IsToyUsable(TRAWLER_ID) and not FL:HasBuff(TrawlerTotem.spell)) then
        local pole = FL:IsFishingPole();
        if (pole) then
            local start, duration, enable = GetItemCooldown(TRAWLER_ID);
            local et = (start + duration) - GetTime();
            if (et <= 0) then
                local _, itemid =  C_ToyBox.GetToyInfo(TRAWLER_ID);
                tinsert(queue, {
                    ["itemid"] = itemid,
                    ["name"] = TrawlerTotem[CurLoc],
                })
            end
        end
    end
end

local LagerItem =  {
    ["enUS"] = "Captain Rumsey's Lager",			     -- 10 for 3 mins
    spell = 45694,
}

-- We always want to drink, so let's skip LibFishing's "lure when we need it"
-- and leave that for FishingAce!
local function LagerPlan(queue)
    if GSB("FishingFluff") and GSB("DrinkHeavily") then
        if not FishingBuddy.GetCurrentSpell() then
            if (GetItemCount(LagerItem.id) > 0 and not FL:HasBuff(LagerItem.spell)) then
                tinsert(queue, {
                    ["itemid"] = LagerItem.id,
                    ["name"] = LagerItem[CurLoc],
                })
                FL:WaitForBuff(LagerItem.spell)
            end
        end
    end
end

local ItemsEvents = {}
ItemsEvents["VARIABLES_LOADED"] = function(started)
    FishingBuddy.SetupSpecialItems({ [TUSKARR_ID] = TuskarrItem }, false, true, true)
    FishingBuddy.SetupSpecialItems({ [TRAWLER_ID] = TrawlerTotem }, false, true, true)
    FishingBuddy.UpdateFluffOption(TUSKARR_ID, TuskarrItem)
    FishingBuddy.UpdateFluffOption(TRAWLER_ID, TrawlerTotem)
    FishingBuddy.RegisterPlan(TuskarrPlan)
    FishingBuddy.RegisterPlan(TrawlerPlan)

    FishingBuddy.SetupSpecialItems({ [34832] = LagerItem }, false, true, true)
    FishingBuddy.RegisterPlan(LagerPlan)
end

FishingBuddy.RegisterHandlers(ItemsEvents);
