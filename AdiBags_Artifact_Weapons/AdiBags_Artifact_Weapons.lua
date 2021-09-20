local AddonName, AddonTable = ...
local L = AddonTable.L

--AdiBags filters
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")
local artifactWeaponFilter = AdiBags:RegisterFilter(L["Artifacts"], 91)
artifactWeaponFilter.uiName = L["artifactWeaponFilter"]
artifactWeaponFilter.uiDesc = L["Put Artifact weapons in their own section."]

function artifactWeaponFilter:Filter(slotData)
  local _, _, quality, _, _ = GetItemInfo(slotData.itemId)
  if (quality == LE_ITEM_QUALITY_ARTIFACT) then
    return L["Artifacts"]
  end
end
