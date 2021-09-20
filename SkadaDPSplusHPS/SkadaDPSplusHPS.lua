local L = LibStub("AceLocale-3.0"):GetLocale("Skada", false)

local Skada = Skada

local mod = Skada:NewModule("0傷害+治療")

local function getHealsplusDamage(player)
      return (player.damage+player.healing)
end

local function getDPSplusHPS(set, player)
      local totaltime = Skada:PlayerActiveTime(set, player)
      return getHealsplusDamage(player) / math.max(1,totaltime)
end

local function getRaidDPSplusHPS(set)
      if set.time > 0 then
            return (set.damage+set.healing) / math.max(1, set.time)
      else
            local endtime = set.endtime
            if not endtime then
                  endtime = time()
            end
            return (set.damage+set.healing) / math.max(1, endtime - set.starttime)
      end
end

local function dpsplushps_tooltip(win, id, label, tooltip)
	local set = win:get_selected_set()
	local player = Skada:find_player(set, id)
	if player then
		local totaltime = Skada:PlayerActiveTime(set, player)
		tooltip:AddLine(player.name)
		tooltip:AddDoubleLine(L["DPS"]..":", Skada:FormatNumber(player.damage / math.max(1,totaltime)), 255,255,255,255,255,255)
		tooltip:AddDoubleLine(L["HPS"]..":", Skada:FormatNumber(player.healing / math.max(1,totaltime)), 255,255,255,255,255,255)
	end
end

function mod:Update(win, set)
      local maxvalue = 0
      for i, player in ipairs(set.players) do
            local rw = getHealsplusDamage(player)
            if rw > maxvalue then
                  maxvalue = rw
            end
      end
      local nr = 1
      for i, player in ipairs(set.players) do
            if player.damage > 0 or player.healing > 0 then
                  local rw = getHealsplusDamage(player)
                  local mypercent = (player.damage+player.healing) / maxvalue
                  local percentformatted=(string.format("%02.1f%%", rw*100/(set.damage+set.healing)))
                  local d = win.dataset[nr] or {}
                  win.dataset[nr] = d
                  d.id = player.id
                  d.label = player.name
                  d.value = player.damage + player.healing
                  d.valuetext = Skada:FormatValueText(
                        Skada:FormatNumber(rw), self.metadata.columns.Damage,
                        Skada:FormatNumber(getDPSplusHPS(set, player)), self.metadata.columns.DPS,
                        percentformatted, self.metadata.columns.Percent
                        )
                  d.class = player.class
                  d.role = player.role
                  nr = nr + 1
            end
      end
      win.metadata.maxvalue = maxvalue

end

function mod:OnEnable()
      mod.metadata = {tooltip = dpsplushps_tooltip, columns = {Damage= true, DPS = true, Percent = false}}
      Skada:AddMode(self)
end

function mod:OnDisable()
      Skada:RemoveMode(self)
end

function mod:GetSetSummary(set)
      return Skada:FormatValueText(
            Skada:FormatNumber(set.damage+set.healing), self.metadata.columns.Damage,
            Skada:FormatNumber(getRaidDPSplusHPS(set)), self.metadata.columns.DPS
            )
end
