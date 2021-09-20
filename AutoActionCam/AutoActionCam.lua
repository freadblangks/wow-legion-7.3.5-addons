local frame = CreateFrame("Frame", "AutoActionCam")
local options = { 
    "full",     "basic",         "default",     "off",    
    "headMove", "heavyHeadMove", "lowHeadMove", "noHeadMove";  
    "focusOn", "focusOff",
}

-- Color the message and print it in the chat window
function printInChat(msg)
    DEFAULT_CHAT_FRAME:AddMessage(msg, 127/255, 219/255, 1.0)
end

-- Execute an ActionCam command
function SetCam(cmd)
    ConsoleExec("ActionCam " .. cmd)
end

-- Register events and unregister the warning message
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:RegisterEvent("ZONE_CHANGED")
UIParent:UnregisterEvent("EXPERIMENTAL_CVAR_CONFIRMATION_NEEDED")

-- Function to call when a registered event is fired
function frame:OnEvent(event, ...)
    if event == "ZONE_CHANGED_NEW_AREA" then
        local instanceBool, instanceType = IsInInstance()
        if instanceBool == true or not instanceType == "none" then
            SetCam("basic")
        else
            SetCam(CamSetting["mode"])
            if not CamSetting["head"] == nil then
                SetCam(CamSetting["head"])
            end
            if not CamSetting["focus"] == nil then
                SetCam(CamSetting["focus"])
            end
        end
    end
    if event == "ADDON_LOADED" and ... == "AutoActionCam" then
        if CamSetting == nil then -- First load
            CamSetting = {
                ["mode"] = "basic",
                ["head"] = nil,
                ["focus"] = nil,
            }
            printInChat("動感鏡頭插件第一次載入，使用預設設定。")
        end
    end
    if event == "PLAYER_LOGIN" then -- Load settings
        SetCam(CamSetting["mode"])
        if not CamSetting["head"] == nil then
            SetCam(CamSetting["head"])
        end
        if not CamSetting["focus"] == nil then
            SetCam(CamSetting["focus"])
        end
    end
end
frame:SetScript("OnEvent", frame.OnEvent)

SLASH_AAC1 = "/aac"
function slashHandler(msg)
    if msg == "reset" then -- reset options
        CamSetting = nil
        printInChat("動感鏡頭插件已經恢復為預設值，請輸入 /reload 重新載入以生效。")
    end

    if msg == "profile" then -- Print current settings
        printInChat("動感鏡頭插件目前使用下面的設定")
        printInChat("- 模式: " .. CamSetting["mode"])
        if not CamSetting["head"] == nil then
            printInChat("- 頭部擺動: " .. CamSetting["head"])
        end
        if not CamSetting["focus"] == nil then
            printInChat("- 聚焦目標: " .. CamSetting["focus"])
        end
    end
    
    if msg == "list" then -- Help message
        printInChat("動感鏡頭插件可以使用的選項")
        printInChat("- 動感鏡頭模式")
        printInChat("    full (預設), basic, default, off")
        printInChat("- 跟隨頭部擺動程度")
        printInChat("    headMove (預設), heavyHeadMove, lowHeadMove, noHeadMove")
        printInChat("- 對焦目標")
        printInChat("    focusOn (預設), focusOff")
    end
    
    for i = 1, 12 do
        if msg == options[i] then
            if i >= 1 and i <= 4 then -- ActionCam mode
                CamSetting = {
                    ["mode"] = msg,
                    ["head"] = nil,
                    ["focus"] = nil,
                }
                SetCam(CamSetting["mode"])
                break
            elseif i >= 5 and i <= 8 then -- Intensity of head movement
                CamSetting["head"] = msg
                SetCam(CamSetting["head"])
                break
            elseif i >= 9 and i <= 10 then -- Which target to focus
                CamSetting["focus"] = msg
                SetCam(CamSetting["focus"])
                break
            end
        end
    end
    
    if msg == "" then
        printInChat("指令語法: /aac <option> 和可接受的選項參數")
        printInChat("- profile: 顯示目前設定")
        printInChat("- list: 顯示所有可使用的設定和選項參數")
        printInChat("- reset: 重設為預設值")
    end
end
SlashCmdList["AAC"] = slashHandler
