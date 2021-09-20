-- FishingPlans
--
-- Let's make a plan that we can carry through with, allowing us to group
-- item choices instead of handling each item separately.

-- 5.0.4 has a problem with a global "_" (see some for loops below)
local _

local planners = {}
local function RegisterPlan(planner)
    tinsert(planners, planner)
end
FishingBuddy.RegisterPlan = RegisterPlan

local planqueue = {}
local function HavePlans()
    return #planqueue > 0
end
FishingBuddy.HavePlans = HavePlans

local function GetPlan()
    if HavePlans() then
        local head = table.remove(planqueue, 1)
        return true, head.itemid, head.name, head.targetid
    end
    -- return nil
end
FishingBuddy.GetPlan = GetPlan

local function ExecutePlans(force)
    if (force or not HavePlans()) then
        planqueue = {}
        for _,planner in ipairs(planners) do
            planner(planqueue)
        end
    end
end
FishingBuddy.ExecutePlans = ExecutePlans

local PlanEvents = {}
PlanEvents[FBConstants.FISHING_DISABLED_EVT] = function()
    planqueue = {}
end

FishingBuddy.RegisterHandlers(PlanEvents);

if ( FishingBuddy.Debugging ) then
	FishingBuddy.Commands["plans"] = {};
	FishingBuddy.Commands["plans"].func =
        function(what)
            ExecutePlans(what);
            FishingBuddy.Dump(planqueue)
			return true;
		end
end
