local _, L = ...

setmetatable(L, {__index = function(L, key)
	local value = tostring(key)
	L[key] = value
	return value
end})

L['ALT key'] = ALT_KEY
L['ALT + CTRL key'] = ALT_KEY_TEXT .. ' + ' .. CTRL_KEY
L['ALT + SHIFT key'] = ALT_KEY_TEXT .. ' + ' .. SHIFT_KEY

local locale = GetLocale()
if(locale == 'zhTW') then
L["Drag items into the window below to add more."] = "將物品拖曳到下方的視窗內，加入忽略清單。"
L["Items blacklisted from potentially being processed."] = "請將要避免不小心被分解處理掉的物品加入忽略清單。"
L["Right-click to remove item"] = "右鍵點一下移除物品"
L['Modifier to show enable %s'] = "一鍵分解/研磨/勘探/開鎖的快速鍵"
L['Item Blacklist'] = "物品忽略清單"
L["Molinari"] = "一鍵分解物品"
L["Molinari Options"] = "專業-分解"

end
