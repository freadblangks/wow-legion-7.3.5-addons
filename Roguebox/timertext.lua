local BuffGUITimer, BuffGUITimerSec

function TimerText_Create()
    BuffGUITimer = BuffGUI:CreateFontString("BuffGUITimer")
    BuffGUITimer:SetFont("Interface\\AddOns\\RogueBox\\Eggo.ttf", 40, "OUTLINE")
    BuffGUITimer:SetTextColor(1, 1, 1, 1)
    BuffGUITimer:SetJustifyH("CENTER")
    BuffGUITimer:SetJustifyV("TOP")
    BuffGUITimer:SetPoint("CENTER", "BuffGUI", 58, 30)

    BuffGUITimerSec = BuffGUI:CreateFontString("BuffGUITimerSec")
    BuffGUITimerSec:SetFont("STANDARD_TEXT_FONT", 14, "OUTLINE")
    BuffGUITimerSec:SetTextColor(1, 1, 1, 1)
    BuffGUITimerSec:SetJustifyH("CENTER")
    BuffGUITimerSec:SetJustifyV("TOP")
    BuffGUITimerSec:SetPoint("CENTER", BuffGUITimer, 36, 0)
    BuffGUITimerSec:SetText("秒")
    BuffGUITimerSec:Hide()
end

function TimerText_Show(TimeLeft)
    BuffGUITimer:Show()
    BuffGUITimerSec:Show()
    BuffGUITimer:SetText(TimeLeft)
end

function TimerText_Hide()
    BuffGUITimer:Hide()
    BuffGUITimerSec:Hide()
end