local AddonName, AddonTable = ...
AddonTable.L = {}
local L = AddonTable.L
local locale = GetLocale()

--Name and description
L["Artifacts"] = true
L["Put Artifact weapons in their own section."] = true

-- Insert new locales like:
-- if locale == 'ruRU' then
--   L["Artifacts"] = "beep boop"
-- elseif locale == 'koKR' then
--   L["Artifacts"] = "beep boop"
-- end

-- Replace remaining true values by their key
for k,v in pairs(L) do if v == true then L[k] = k end end
