local PistolShotGUIImp
local PistolShotGUIImpag

function CreatePistolGUI()
    local PistolShotGUI = CreateFrame("Frame", "PistolShotGUI", UIParent)
    PistolShotGUI:SetWidth(420)
    PistolShotGUI:SetHeight(420)
    PistolShotGUI:SetPoint("CENTER", UIParent)

    PistolShotGUIImp = PistolShotGUI:CreateTexture("impGraphic")
    PistolShotGUIImp:SetTexture("Interface\\AddOns\\RogueBox\\Guns.tga")
    PistolShotGUIImp:SetWidth(420)
    PistolShotGUIImp:SetHeight(420)
    PistolShotGUIImp:SetPoint("CENTER", 0, 0)
    PistolShotGUIImp:Hide()

    PistolShotGUIImpag = PistolShotGUIImp:CreateAnimationGroup("PistolShotGUIImpag")
    local PistolShotGUIImpanimation = PistolShotGUIImpag:CreateAnimation("Scale", "PistolShotGUIImpanimation")
    PistolShotGUIImpanimation:SetScale(1.2, 1.2)
    PistolShotGUIImpanimation:SetDuration(4)
    PistolShotGUIImpanimation:SetSmoothing("IN_OUT")
    PistolShotGUIImpanimation:SetEndDelay(26)
end

function HasShot()
    --PistolShotGUIImp:Show()
    --PistolShotGUIImpag:Play()
end

function EndShot()
    PistolShotGUIImp:Hide()
    PistolShotGUIImpag:Stop()
end