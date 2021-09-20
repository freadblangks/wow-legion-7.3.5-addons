-- Talent Set Manager
-- by Vildiesel - EU Well of Eternity

local addonName, addonTable = ...

local locale = GetLocale()
addonTable.L = {}
local L = addonTable.L

--local debug
--[===[@debug@
--debug = true
--@end-debug@]===]

-- let's set them twice to be sure (in v1.1.5 the repository missed some languages)

--if debug then
 L["set_already_exists"] = "A talent set with that name already exists"
 L["sets_limit_reached"] = "You cannot create any more new talent sets."
 L["confirm_save_set"] = "Would you like to save the talent set '%s'?"
 L["confirm_delete_set"] = "Are you sure you want to delete the talent set %s?"
 L["confirm_overwrite_set"] = "You already have a talent set named %s. Would you like to overwrite it?"
 L["link_equipment"] = "Link Equipment"
 L["current_equipment"] = "Current: %s"
 L["equipment_menu_title1"] = "Select an equipment set to be equipped"
 L["equipment_menu_title2"] = "along with this set of talents:"
 L["equipment_not_found"] = "The equipment set %s was not found and has been unlinked from the talent set %s"
 L["no_talent_sets"] = "No %s talent sets available"
 L["macro_comment"] = "automatically generated, do not modify"
 L["macro_limit_reached"] = "Macro limit reached"
 L["custom_macro_desc_lc"] = "|cff00ffffLeft-Click|r for more info."
 L["custom_macro_desc_rc"] = "|cff00ffffRight-Click|r this button to delete the macro"
 L["custom_macro_desc1"] = "To be used in actionbars, a talent set needs its own macro."
 L["custom_macro_desc2"] = "Dragging the talent set, automatically creates it in your character macros."
 L["not_available_in_combat"] = "Not available in combat"
 L["help_title1"] = "Right click to ignore tiers"
 L["help_string1"] = "By right-clicking on any talent in the Talent Frame, its tier's background will become red and will not be saved when clicking the save button. When learning a set containing ignored tiers, only the talents on the available tiers (i.e. the ones that don't have a red background) will be changed."
 L["talents_changed"] = "Talents Changed"
 
 L["options_talent_highlight_icon"] = "Talent Highlight Icon"
 L["options_chat_filter"] = "Talent chat message filter"
 L["options_chat_filter_show"] = "Do not filter"
 L["options_chat_filter_group"] = "Group into a single line"
 L["options_chat_filter_hide"] = "Hide entirely"
 L["options_ignored_tiers_background_color"] = "Ignored tiers background color"
 L["options_hide_info_button"] = "Hide Info Button"
 L["options_auto_equip_chatmsg"] = "Chat notification"

 L["search_icon"] = "Search Icon"
 L["autoequip_equipment_opt"] = "Automatically wear linked equipment when changing specialization"
 L["autoequip_equipment_msg"] = "Using equipment set %s"
 L["autoequip_specs_description"] = "Main talent group:"
 L["autoequip_no_linked_equip_found"] = "No linked equipment found"
 
 L["quick_talent_selection"] = "Quick Talent Selection"
 L["quick_talent_selection_canchange"] = "|cff00ff00Talents can be changed|r"
 L["quick_talent_selection_cannotchange"] = "|cffff0000Talents cannot be changed|r"
 --return
--end

if locale == "zhTW" then 
L["autoequip_equipment_msg"] = "使用套裝設定 %s"
L["autoequip_equipment_opt"] = "切換專精時自動穿上連結的套裝"
L["autoequip_no_linked_equip_found"] = "無法找到連結的套裝"
L["autoequip_specs_description"] = "主要天賦組合："
L["confirm_delete_set"] = "是否確定要刪除天賦設定 %s?"
L["confirm_overwrite_set"] = "天賦設定名稱 '%s' 已經存在，是否確定要覆蓋取代?"
L["confirm_save_set"] = "是否要儲存天賦設定 '%s'?"
L["current_equipment"] = "目前: %s"
L["custom_macro_desc1"] = "要在快捷列上使用，需要幫天賦設定專屬的巨集。"
L["custom_macro_desc2"] = "拖曳天賦設定，會自動在你的角色中建立巨集。"
L["custom_macro_desc_lc"] = "|cff00ffff左鍵|r取得更多資訊。"
L["custom_macro_desc_rc"] = "|cff00ffff右鍵|r點擊這個按鈕來刪除巨集"
L["equipment_menu_title1"] = "選擇這個天賦設定"
L["equipment_menu_title2"] = "要搭配的裝備設定:"
L["equipment_not_found"] = "無法找到裝備設定 %s，已經取消和天賦設定 %s 的連結。"
L["help_string1"] = "右鍵點擊天賦框架上的任何天賦，那一整層的背景都會變成紅色，即使按下儲存按鈕時也不會儲存。學習天賦時，若其中包含被忽略的那一層，只有其他層 (不是紅色背景) 的天賦會更改。"
L["help_title1"] = "右鍵點擊忽略一整層天賦"
L["link_equipment"] = "連結裝備"
L["macro_comment"] = "這是自動產生的，請勿修改。"
L["macro_limit_reached"] = "巨集數目已達最大限制"
L["no_talent_sets"] = "無法使用天賦設定 %s"
L["not_available_in_combat"] = "戰鬥中無法使用"
L["options_auto_equip_chatmsg"] = "在聊天視窗顯示通知"
L["options_talent_highlight_icon"] = "天賦顯著標示圖示"
L["options_chat_filter"] = "天賦聊天訊息過濾"
L["options_chat_filter_group"] = "顯示為一行"
L["options_chat_filter_hide"] = "完全隱藏"
L["options_chat_filter_show"] = "不要過濾"
L["options_hide_info_button"] = "隱藏資訊按鈕"
L["options_ignored_tiers_background_color"] = "忽略忽略一整層天賦的背景顏色"
L["quick_talent_selection"] = "快速選擇天賦"
L["quick_talent_selection_canchange"] = "|cff00ff00天賦可以更改|r"
L["quick_talent_selection_cannotchange"] = "|cffff0000天賦無法更改|r"
L["search_icon"] = "搜尋圖示"
L["set_already_exists"] = "名稱相同的天賦設定已經存在"
L["sets_limit_reached"] = "無法建立更多新的天賦設定。"
L["talents_changed"] = "天賦已經變更"
L["addon_name"] = "天賦管理員"
L["addon_note"] = "Talent Set Manager 讓你可以儲存和學習天賦設定，快速切換整組天賦。"
L["Talent Set Manager"] = "天賦"
L["Talent Set Manager - "] = "天賦管理員 - "
L["|cff00ffffTalent Set Manager|r - "] = "|cff00ffff天賦管理員|r - "

else -- enUS
L["autoequip_equipment_msg"] = "Using equipment set %s"
L["autoequip_equipment_opt"] = "Automatically wear linked equipment when changing specialization"
L["autoequip_no_linked_equip_found"] = "No linked equipment found"
L["autoequip_specs_description"] = "Main talent group:"
L["confirm_delete_set"] = "Are you sure you want to delete the talent set %s?"
L["confirm_overwrite_set"] = "You already have a talent set named %s. Would you like to overwrite it?"
L["confirm_save_set"] = "Would you like to save the talent set '%s'?"
L["current_equipment"] = "Current: %s"
L["custom_macro_desc_lc"] = "|cff00ffffLeft-Click|r for more info."
L["custom_macro_desc_rc"] = "|cff00ffffRight-Click|r this button to delete the macro"
L["custom_macro_desc1"] = "To be used in actionbars, a talent set needs its own macro."
L["custom_macro_desc2"] = "Dragging the talent set, automatically creates it in your character macros."
L["equipment_menu_title1"] = "Select an equipment set to be equipped"
L["equipment_menu_title2"] = "along with this set of talents:"
L["equipment_not_found"] = "The equipment set %s was not found and has been unlinked from the talent set %s"
L["help_string1"] = "By right-clicking on any talent in the Talent Frame, its tier's background will become red and will not be saved when clicking the save button. When learning a set containing ignored tiers, only the talents on the available tiers (i.e. the ones that don't have a red background) will be changed."
L["help_title1"] = "Right click to ignore tiers"
L["link_equipment"] = "Link Equipment"
L["macro_comment"] = "automatically generated, do not modify"
L["macro_limit_reached"] = "Macro limit reached"
L["no_talent_sets"] = "No %s talent sets available"
L["not_available_in_combat"] = "Not available in combat"
L["options_auto_equip_chatmsg"] = "Chat notification"
L["options_chat_filter"] = "Talent chat message filter"
L["options_chat_filter_group"] = "Group into a single line"
L["options_chat_filter_hide"] = "Hide entirely"
L["options_chat_filter_show"] = "Do not filter"
L["options_hide_info_button"] = "Hide Info Button"
L["options_ignored_tiers_background_color"] = "Ignored tiers background color"
L["options_talent_highlight_icon"] = "Talent Highlight Icon"
L["quick_talent_selection"] = "Quick Talent Selection"
L["quick_talent_selection_canchange"] = "|cff00ff00Talents can be changed|r"
L["quick_talent_selection_cannotchange"] = "|cffff0000Talents cannot be changed|r"
L["search_icon"] = "Search Icon"
L["set_already_exists"] = "A talent set with that name already exists"
L["sets_limit_reached"] = "You cannot create any more new talent sets."
L["talents_changed"] = "Talents Changed"

L["addon_name"] = "Talent Set Manager"
L["addon_note"] = "Allows you to store and learn entire sets of talents"
L["Talent Set Manager"] = true
L["Talent Set Manager - "] = true
L["|cff00ffffTalent Set Manager|r - "] = true

end
