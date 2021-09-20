TimelessIsleChest = LibStub("AceAddon-3.0"):NewAddon("TimelessIsleChest", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end

--TimelessIsleChest = HandyNotes:NewModule("TimelessIsleChest", "AceConsole-3.0", "AceEvent-3.0")
--local db
local iconDefault = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS"

TimelessIsleChest.nodes = { }
local nodes = TimelessIsleChest.nodes

nodes["TimelessIsle"] = { }
nodes["CavernofLostSpirits"] = { }
--nodes["Pandaria"] = { }

nodes["TimelessIsle"][36703410] = { "33170", "長滿青苔的箱子", "一次性寶箱#00" }
nodes["TimelessIsle"][25502720] = { "33171", "長滿青苔的箱子", "一次性寶箱#01" }
nodes["TimelessIsle"][27403910] = { "33172", "長滿青苔的箱子", "一次性寶箱#02" }
nodes["TimelessIsle"][30703650] = { "33173", "長滿青苔的箱子", "一次性寶箱#03" }
nodes["TimelessIsle"][22403540] = { "33174", "長滿青苔的箱子", "一次性寶箱#04" }
nodes["TimelessIsle"][22104930] = { "33175", "長滿青苔的箱子", "一次性寶箱#05" }
nodes["TimelessIsle"][24805300] = { "33176", "長滿青苔的箱子", "一次性寶箱#06" }
nodes["TimelessIsle"][25704580] = { "33177", "長滿青苔的箱子", "一次性寶箱#07" }
nodes["TimelessIsle"][22306810] = { "33178", "長滿青苔的箱子", "一次性寶箱#08" }
nodes["TimelessIsle"][26806870] = { "33179", "長滿青苔的箱子", "一次性寶箱#09" }
nodes["TimelessIsle"][31007630] = { "33180", "長滿青苔的箱子", "一次性寶箱#10" }
nodes["TimelessIsle"][35307640] = { "33181", "長滿青苔的箱子", "一次性寶箱#11" }
nodes["TimelessIsle"][38707160] = { "33182", "長滿青苔的箱子", "一次性寶箱#12" }
nodes["TimelessIsle"][39807950] = { "33183", "長滿青苔的箱子", "一次性寶箱#13" }
nodes["TimelessIsle"][34808420] = { "33184", "長滿青苔的箱子", "一次性寶箱#14" }
nodes["TimelessIsle"][43608410] = { "33185", "長滿青苔的箱子", "一次性寶箱#15" }
nodes["TimelessIsle"][47005370] = { "33186", "長滿青苔的箱子", "一次性寶箱#16" }
nodes["TimelessIsle"][46704670] = { "33187", "長滿青苔的箱子", "一次性寶箱#17" }
nodes["TimelessIsle"][51204570] = { "33188", "長滿青苔的箱子", "一次性寶箱#18" }
nodes["TimelessIsle"][55504430] = { "33189", "長滿青苔的箱子", "一次性寶箱#19" }
nodes["TimelessIsle"][58005070] = { "33190", "長滿青苔的箱子", "一次性寶箱#20" }
nodes["TimelessIsle"][65704780] = { "33191", "長滿青苔的箱子", "一次性寶箱#21" }
nodes["TimelessIsle"][63805920] = { "33192", "長滿青苔的箱子", "一次性寶箱#22" }
nodes["TimelessIsle"][64907560] = { "33193", "長滿青苔的箱子", "一次性寶箱#23" }
nodes["TimelessIsle"][60206600] = { "33194", "長滿青苔的箱子", "一次性寶箱#24" }
nodes["TimelessIsle"][49706570] = { "33195", "長滿青苔的箱子", "一次性寶箱#25" }
nodes["TimelessIsle"][53107080] = { "33196", "長滿青苔的箱子", "一次性寶箱#26" }
nodes["TimelessIsle"][52706270] = { "33197", "長滿青苔的箱子", "一次性寶箱#27" }
nodes["TimelessIsle"][61708850] = { "33227", "長滿青苔的箱子", "一次性寶箱#28" }
nodes["TimelessIsle"][44206530] = { "33198", "長滿青苔的箱子", "一次性寶箱" }
nodes["TimelessIsle"][26006140] = { "33199", "長滿青苔的箱子", "一次性寶箱 - 在樹幹上" }
nodes["TimelessIsle"][24603850] = { "33200", "長滿青苔的箱子", "一次性寶箱" }
nodes["TimelessIsle"][29703180] = { "33202", "長滿青苔的箱子", "一次性寶箱" }
--nodes["TimelessIsle"][29703180] = { "33201", "長滿青苔的箱子", "一次性寶箱 - Ordo Lake Lower" }
nodes["TimelessIsle"][28203520] = { "33204", "結實的箱子", "一次性寶箱 - 需要鳥搭載#2" } -- Swapped questid's with 需要鳥搭載#2
nodes["TimelessIsle"][26806490] = { "33205", "結實的箱子", "一次性寶箱 - 需要鳥搭載#1" }
nodes["TimelessIsle"][64607040] = { "33206", "結實的箱子", "一次性寶箱" }
nodes["TimelessIsle"][59204950] = { "33207", "結實的箱子", "一次性寶箱 - 在山洞內" }
nodes["TimelessIsle"][69503290] = { "33208", "悶燃寶箱", "一次性寶箱" }
nodes["TimelessIsle"][54007820] = { "33209", "悶燃寶箱", "一次性寶箱" }
nodes["TimelessIsle"][47602760] = { "33210", "熾炎寶箱", "一次性寶箱" }

nodes["TimelessIsle"][59903130] = { "33201", "長滿青苔的箱子", "一次性寶箱" }  -- Needed Correction

nodes["TimelessIsle"][46703230] = { "33203", "骨蓋寶箱", "一次性寶箱 - 在山下的洞穴內" }
nodes["CavernofLostSpirits"][62903480] = { "33203", "骨蓋寶箱", "一次性寶箱 - 在失落靈魂洞穴內" }
--nodes["Pandaria"][62903480] = { "33203", "骨蓋寶箱", "一次性寶箱 - Cavern of Lost Spirits" }


-- 終極寶藏獵人
nodes["TimelessIsle"][51607460] = { "32969", "閃閃發光的寶箱", "從這裡開始跳", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily.tga" } --Old start 51507360
nodes["TimelessIsle"][49706940] = { "32969", "閃閃發光的寶箱", "需要跳上石柱\n成就：|cffffff00[終極寶藏獵人]|r", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][60204590] = { "32968", "被繩子綁著的寶箱", "從這裡開始走", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily.tga" }
nodes["TimelessIsle"][53904720] = { "32968", "被繩子綁著的寶箱", "需要走過繩子\n成就：|cffffff00[終極寶藏獵人]|r", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][58506010] = { "32971", "迷霧籠罩的寶箱", "在天上\n成就：|cffffff00[終極寶藏獵人]|r\n點擊閃閃發光的紅鶴雕像飛上天空\n需要先拾取「閃閃發光的寶箱」和「被繩子綁著的寶箱」", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

-- Where There's Pirates, There's Booty
nodes["TimelessIsle"][40409300] = { "32957", "水下寶藏", "成就：|cffffff00[黑衣衛的貨物]|r\n殺死周圍的受詛咒的猴人潛水者有機會得到鑰匙", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][16905710] = { "32956", "黑衣衛的貨物", "洞穴的入口", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily.tga" }
nodes["TimelessIsle"][22705890] = { "32956", "黑衣衛的貨物", "成就：|cffffff00[有海盜的地方就有賞金]|r\n寶藏在洞穴內", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][70608090] = { "32970", "閃閃發光的背袋", "成就：|cffffff00[有海盜的地方就有賞金]|r\n用黃金滑翔裝置飛到這裡", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

--[[ function TimelessIsleChest:OnEnable()
end

function TimelessIsleChest:OnDisable()
end ]]--

--local handler = {}


function TimelessIsleChest:OnEnter(mapFile, coord) -- Copied from handynotes
    if (not nodes[mapFile][coord]) then return end
	
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	tooltip:SetText(nodes[mapFile][coord][2])
	if (nodes[mapFile][coord][3] ~= nil) then
	 tooltip:AddLine(nodes[mapFile][coord][3], nil, nil, nil, true)
	end
	tooltip:Show()
end

function TimelessIsleChest:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local options = {
 type = "group",
 name = "永恆之島寶藏",
 desc = "提供永恆之島寶藏的位置",
 get = function(info) return TimelessIsleChest.db.profile[info.arg] end,
 set = function(info, v) TimelessIsleChest.db.profile[info.arg] = v; TimelessIsleChest:Refresh() end,
 args = {
  desc = {
   name = "寶藏圖示設定",
   type = "description",
   order = 0,
  },
  icon_scale = {
   type = "range",
   name = "圖示大小",
   desc = "圖示的大小",
   min = 0.25, max = 2, step = 0.01,
   arg = "icon_scale",
   order = 10,
  },
  icon_alpha = {
   type = "range",
   name = "圖示透明度",
   desc = "圖示的透明度",
   min = 0, max = 1, step = 0.01,
   arg = "icon_alpha",
   order = 20,
  },
  alwaysshow = {
   type = "toggle",
   name = "顯示所有寶藏",
   desc = "顯示所有寶藏不論拾取狀態",
   arg = "alwaysshow",
   order = 2,
  },
  save = {
   type = "toggle",
   name = "在SavedVariables儲存",
   arg = "save",
  },
 },
}

function TimelessIsleChest:OnInitialize()
 local defaults = {
  profile = {
   icon_scale = 1.0,
   icon_alpha = 1.0,
   alwaysshow = false,
   save = true,
  },
 }

 self.db = LibStub("AceDB-3.0"):New("TimelessIsleChestsDB", defaults, true)
 self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function TimelessIsleChest:WorldEnter()
 self:UnregisterEvent("PLAYER_ENTERING_WORLD")

 --self:RegisterEvent("WORLD_MAP_UPDATE", "Refresh")
 --self:RegisterEvent("LOOT_CLOSED", "Refresh")

 --self:Refresh()
 self:ScheduleTimer("RegisterWithHandyNotes", 10)
end

function TimelessIsleChest:RegisterWithHandyNotes()
do
	local function iter(t, prestate)
		if not t then return nil end
		local state, value = next(t, prestate)
		while state do
			    -- questid, chest type, quest name, icon
			    if (value[1] and not TimelessIsleChest:HasBeenLooted(value)) then
				 --print(state)
				 local icon = value[4] or iconDefault
				 return state, nil, icon, TimelessIsleChest.db.profile.icon_scale, TimelessIsleChest.db.profile.icon_alpha
				end
			state, value = next(t, state)
		end
	end
	function TimelessIsleChest:GetNodes(mapFile, isMinimapUpdate, dungeonLevel)
	    if (mapFile == "CavernofLostSpirits" and isMinimapUpdate) then return iter, nodes["Hack"], nil end
		return iter, nodes[mapFile], nil
	end
end
 HandyNotes:RegisterPluginDB("永恆之島寶藏", self, options)
 self:RegisterBucketEvent({ "LOOT_CLOSED" }, 2, "Refresh")
 self:Refresh()
end
 

function TimelessIsleChest:Refresh()
 if (not self.db.profile.save) then
  table.wipe(self.db.char)
 end
 self:SendMessage("HandyNotes_NotifyUpdate", "TimelessIsleChest")
end

function TimelessIsleChest:HasBeenLooted(value)
 if (self.db.profile.alwaysshow) then return false end
 
 if (self.db.char[value[1]] and self.db.profile.save) then return true end
 
 if (IsQuestFlaggedCompleted(value[1])) then
  if (self.db.profile.save and not value[4]) then  -- Save the chest but not if it's a daily
   self.db.char[value[1]] = true;
  end
  
  return true
 end
  
 return false
end