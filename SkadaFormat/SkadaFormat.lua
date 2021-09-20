function SkadaFormatNumber(self,number)
    if number then
        if self.db.profile.numberformat == 1 then
            if number > 100000000 then -- 亿
                return ("%02.2f億"):format(number / 100000000)
            end
            if number > 100000 then    -- 十万
                return ("%d萬"):format(number / 10000)
            end
            return ("%02.2f萬"):format(number / 10000)
        else
            return math.floor(number)
        end
    end
end

local frame= CreateFrame("Frame")
frame:SetScript("OnEvent", function(f, e, ...)
    if Skada.FormatNumber ~= nil and Skada.FormatNumber ~= SkadaFormatNumber then
        Skada.FormatNumber = SkadaFormatNumber
    end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
