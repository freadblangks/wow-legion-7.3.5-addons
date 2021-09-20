local _, S = ...

local L = {
	enUS = {
		RESET = "Settings have been reset",
		SET = "Current scale is now %.2f",
		USAGE_SCALE = "Sets the scale",
		ERROR_SCALE = "%s is not in the valid range of %s",
	},
	zhTW = {
		RESET = "設定已經重置",
		SET = "目前的縮放大小是 %.2f",
		USAGE_SCALE = "設定縮放大小",
		ERROR_SCALE = "%s 不在有效的數字範圍 %s 以內",
	},
}

L.zhCN = L.zhTW

S.L = setmetatable(L[GetLocale()] or L.enUS, {__index = function(t, k)
	local v = rawget(L.enUS, k) or k
	rawset(t, k, v)
	return v
end})
