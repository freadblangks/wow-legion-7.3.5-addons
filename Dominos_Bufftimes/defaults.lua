

Dominos_BuffTimes.defaults = {
	-- defaults for ignored de/buffs
	["ignored"] = {
		["WARRIOR"] = {'致死打擊'},
		["PALADIN"] = {'光明審判'},
		["DRUID"] = {'痛擊'},
	}, 
	
	-- defaults for buffs that show only for your spells
	["yourbuffs"] = {
		["PRIEST"] = {"恢復"},
		["DRUID"] = {"回春術"},
	},
	
	-- defaults for buffs that show for any caster
	["alldebuffs"] = {
		["WARLOCK"] = {'放逐術', '恐懼術'}
	},
	
	-- defaults for buffs that show only if casted on self
	["selfbuffs"] = {
		-- classes
		["WARRIOR"] = {'盾牆', '狂暴之怒',
					   '魯莽', '法術反射', 
					   '狂怒恢復', '橫掃攻擊', '劍刃風暴',
					   '破釜沉舟'},
					   
		["DEATHKNIGHT"] = {'冰錮堅韌', '反魔法護罩', 
						   '血族之裔', '符文武器幻舞', '巫妖之軀',
						   '駭骨之盾'},
						   
		["DRUID"] = {'狂暴', '求生本能', '猛虎之怒', '突進', 
					 '樹皮術', '星穹連線', '化身：伊露恩天選者'},
					 
		["HUNTER"] = {'威攝', '急速射擊'},
		
		["MAGE"] = {'霜甲術', '喚醒', '寒冰護體', '炎甲術', 
					'隱形術', '祕法強化', '冰寒脈動'},
					
		["PALADIN"] = {'聖佑術',
					   '聖盾術', '復仇之怒'},
	    
	    ["PRIEST"] = {'影散'},
	    
	    ["ROGUE"] = {'閃避', '疾跑', '切割', '消失',
	    			 '暗影披風', '能量刺激', '暗影之舞'},
	    
	    ["SHAMAN"] = {'閃電之盾', '水之盾', '視界術', 
	    			  '嗜血術', '英勇氣概'},
	    
	    ["WARLOCK"] = {'基爾羅格之眼', '靈魂調換'},
	    			   
	    ['MONK'] = {'凝神靈酒', '靈動絕釀',
	    			'石形絕釀'},
	    
	    -- races
	    ["Troll"] = {'狂暴'},
		["Dwarf"] = {'石像形態'},
		["NightElf"] = {'影遁'},
		["Orc"] = {'血之烈怒'},
	},
	
	-- defaults for translated spells/buffs
	["translated"] = {
		["DEATHKNIGHT"] = {
			['plague strike'] = '瘟疫打擊',
			['icy touch'] = '冰結之觸',
		},
		
		["MAGE"] = {
		},
		
		["WARLOCK"] = {
		},
		
		["MONK"] = {
		}
	},
	
	-- defaults for overridden spells that are shown regardless of cooldown
	["override"] = {
		["ROGUE"] = {'宿怨'},
		["MONK"] = {'猛虎出閘', '凝神靈酒', '靈動絕釀'},
	},
}

local function CopyDefaults(src, dest)
	if src then
		for _, val in ipairs(src) do
			dest[val] = 1
		end
	end
end

local function CopyTranslations(src, dest)
	if src then
		for key, val in pairs(src) do
			dest[key] = {[val] = 1}
		end
	end
end

function Dominos_BuffTimes:SetDefaults(playerClass, playerRace)

	-- 改為中文名稱
	local playerClassLoc = UnitClass("player")
	local playerRaceLoc = UnitRace("player")
	self:Print('正在設定預設值給 ' .. playerRaceLoc .. ' ' .. playerClassLoc)
	CopyDefaults(self.defaults.ignored[playerClass], self.db.char.ignored)
	CopyDefaults(self.defaults.ignored[playerRace], self.db.char.ignored)
	
	CopyDefaults(self.defaults.yourbuffs[playerClass], self.db.char.yourbuffs)
	CopyDefaults(self.defaults.yourbuffs[playerRace], self.db.char.yourbuffs)
	
	CopyDefaults(self.defaults.alldebuffs[playerClass], self.db.char.alldebuffs)
	CopyDefaults(self.defaults.alldebuffs[playerRace], self.db.char.alldebuffs)
	
	CopyDefaults(self.defaults.selfbuffs[playerClass], self.db.char.selfbuffs)
	CopyDefaults(self.defaults.selfbuffs[playerRace], self.db.char.selfbuffs)
	
	CopyTranslations(self.defaults.translated[playerClass], self.db.char.translated)
	CopyTranslations(self.defaults.translated[playerRace], self.db.char.translated)
	
	CopyDefaults(self.defaults.override[playerClass], self.db.char.override)
	CopyDefaults(self.defaults.override[playerRace], self.db.char.override)
end

