--[[
    If you want to customize the settings (add own sounds or spells, for
    example), you can create a new file called "myconfig.lua" and put
    your own variables in it. A good starting point is probably copying
    this file.
]]--

EnhBloodlustConfig = {};

local config = EnhBloodlustConfig;

-- Bloodlust, Heroism, Time Warp, Ancient Hysteria
config.spells = {2825, 32182, 80353, 90355, 160452, 178207, 230935}

config.sound = {
	-- 加入音樂檔案路徑，一行一首歌用逗號分隔，會隨機播放。
	-- 最後一首歌 (最後一行) 的後面不要加逗號。
	-- 每一行前面加上兩條橫線的歌曲不會播放。
	"Interface\\AddOns\\EnhBloodlust\\BeatSaber.mp3",
	"Interface\\AddOns\\EnhBloodlust\\EatYouUp.mp3",
	"Interface\\AddOns\\EnhBloodlust\\KOF.mp3",
	"Interface\\AddOns\\EnhBloodlust\\GGO.ogg",
	"Interface\\AddOns\\EnhBloodlust\\kakuriyo.ogg"
	-- "Interface\\AddOns\\EnhBloodlust\\FF15-4.ogg",
	-- "Interface\\AddOns\\EnhBloodlust\\FF15-3.ogg",
	-- "Interface\\AddOns\\EnhBloodlust\\FF15-2.ogg",
	-- "Interface\\AddOns\\EnhBloodlust\\FF15-1.ogg",
	-- "Interface\\AddOns\\EnhBloodlust\\Cardcaptor-Sakura-Clear-Card.ogg",
	-- "Interface\\AddOns\\EnhBloodlust\\FF14-light-father.mp3",
	-- "Interface\\AddOns\\EnhBloodlust\\loloSM.mp3",
    -- "Interface\\AddOns\\EnhBloodlust\\EVA.mp3",
	-- "Interface\\AddOns\\EnhBloodlust\\GoGoPowerRanger.mp3",
	-- "Interface\\AddOns\\EnhBloodlust\\haway4562.mp3",
	-- "Interface\\AddOns\\EnhBloodlust\\Pikachu.mp3",
    -- "Interface\\AddOns\\EnhBloodlust\\SailorJupiter.mp3",
	-- "Interface\\AddOns\\EnhBloodlust\\Sailormoon.mp3",
	-- "Interface\\AddOns\\EnhBloodlust\\sailor-starlights.mp3"
}

-- 音樂長度建議40秒，剛好是嗜血的時間。
config.length = 40;

-- 嗜血音樂所使用的聲音頻道，可以使用的值有主音量 "Master" 和法術音效 "SFX"。
config.channel = "Master";

--[[
--Some other examples

--Duration
config.sound = {
    "Sound\\Music\\ZoneMusic\\DMF_L70ETC01.mp3"
}
config.length = 264;

--Short
config.sound = {
    "Interface\\AddOns\\EnhBloodlust\\bloodlust_short.mp3"
}
config.length = 4;

--Long
config.sound = {
    ""Interface\\AddOns\\EnhBloodlust\\bloodlust_mid.mp3""
}
config.length = 40;
]]--
