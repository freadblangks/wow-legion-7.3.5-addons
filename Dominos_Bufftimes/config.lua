
--local Dominos_BuffTimes = Dominos_BuffTimes

--[[ Configuration functions ]]--

Dominos_BuffTimes.ignoreOptions = {
	addspell = {
		name = "移除法術",
		desc = "從忽略清單中移除法術技能。",
		type = "execute",
		func = "RemoveSpellFromIgnored",
		order = 200,
	},
}

Dominos_BuffTimes.yourBuffOptions = {
	addspell = {
		name = "移除法術",
		desc = "從玩家增益效果清單中移除法術技能。",
		type = "execute",
		func = "RemoveSpellFromYourBuff",
		order = 200,
	},
}

Dominos_BuffTimes.allDebuffOptions = {
	addspell = {
		name = "移除法術",
		desc = "從任何減益效果清單中移除法術技能。",
		type = "execute",
		func = "RemoveSpellFromAnyDebuff",
		order = 200,
	},
}

Dominos_BuffTimes.selfBuffOptions = {
	addspell = {
		name = "移除法術",
		desc = "從任何自己施放的增益效果清單中移除法術技能。",
		type = "execute",
		func = "RemoveSpellFromSelfBuff",
		order = 200,
	},
}

Dominos_BuffTimes.translatedOptions = {
	addspell = {
		name = "移除法術",
		desc = "從轉換清單中移除法術技能配對。",
		type = "execute",
		func = "RemovePairFromTranslated",
		order = 200,
	},
}

Dominos_BuffTimes.overrideOptions = {
	addspell = {
		name = "移除法術",
		desc = "從取代清單中移除法術技能。",
		type = "execute",
		func = "RemoveSpellFromOverride",
		order = 200,
	},
}

function Dominos_BuffTimes:InitOptions()
	
	local _, playerClass = UnitClass("player")
	self.class = playerClass
	
	self.options = {
		name = "快捷列-增益和減益效果時間",
		desc = "Dominos BuffTimes - 在快捷列按鈕上顯示增益和減益效果的時間",
		type = "group",
		childGroups = "tab",
		handler = Dominos_BuffTimes,
		
		args = {
			ignored = {
				name = "忽略",
				desc = "不要顯示時間的法術技能。",
				type = "group",
				
				args = {
					description = {
						type = "description",
						name = "下面的法術技能不會在快捷列按鈕上顯示時間 (按鈕邊框仍然會顯示顏色)。",
						order = 1,
					},
					spellname = {
						name = "要加入的法術",
						type = "input",
						desc = "要加入到忽略清單的法術技能名稱。",
						set = "AddSpellToIgnored",
						order = 100,
					}, 
				},
			},
			yourbuffs = {
				name = "自己施放的增益效果",
				desc = "只有你自己施放的增益效果才會顯示時間。",
				type = "group",
				
				args = {
					description = {
						type = "description",
						name = "所有在目標身上的增益效果預設都會顯示時間，不論是誰施放的。下面的法術只有你自己施放的才會顯示時間。",
						order = 1,
					},
					spellname = {
						name = "要加入的法術",
						type = "input",
						desc = "要加入到自己施放的清單的法術技能名稱。",
						set = "AddSpellToYourBuff",
						order = 100,
					}, 
				},
			},
			alldebuffs = {
				name = "任何玩家減益效果",
				desc = "不論是誰施放的減益效果都會顯示時間。",
				type = "group",
				
				args = {
					description = {
						type = "description",
						name = "預設只有你自己施放在目標身上的減益效果才會顯示時間。下面的法術不論是誰施放的都會顯示時間。",
						order = 1,
					},
					spellname = {
						name = "要加入的法術",
						type = "input",
						desc = "要加入到任何玩家減益效果清單的法術技能名稱。",
						set = "AddSpellToAnyDebuff",
						order = 100,
					}, 
				},
			},
			selfbuffs = {
				name = "自己身上的增益效果",
				desc = "增益效果的時間只會對你顯示，並且會取代冷卻時間。",
				type = "group",
				
				args = {
					description = {
						type = "description",
						name = "下面的法術技能會在按鈕上顯示你身上的增益效果時間，不論是誰施放的。這些法術技能也會取代冷卻時間。",
						order = 1,
					},
					spellname = {
						name = "要加入的法術",
						type = "input",
						desc = "要加入到任何玩家減益效果清單的法術技能名稱。",
						set = "AddSpellToSelfBuff",
						order = 100,
					}, 
				},
			},
			translated = {
				name = "轉換",
				desc = "法術技能與任何其他法術技能配對符合時，會顯示狀態/時間的法術技能群組",
				type = "group",
				
				args = {
					description = {
						type = "description",
						name = "讓一個法術按鈕顯示另一個法術的時間。左側與右側的任何一個法術技能配對符合時，左側的法術技能按鈕會顯示邊框/時間。",
						order = 1,
					},
					leftspellname = {
						name = "要加入的法術",
						type = "input",
						desc = "要加入的法術名稱。",
						set = "SetLeftTranslatedSpell",
						get = "GetLeftTranslatedSpell",
						order = 100,
					},
					rightspellname = {
						name = "要加入的轉換法術名稱。",
						type = "input",
						desc = "要加入的其他法術名稱。",
						set = "SetRightTranslatedSpell",
						get = "GetRightTranslatedSpell",
						order = 200,
					},
					addspell = {
						name = "新增法術配對",
						desc = "新增法術技能配對到轉換清單。",
						type = "execute",
						func = "AddPairToTranslated",
						order = 300,
					},
				},
			},
			override = {
				name = "取代",
				desc = "將會取代冷卻時間的法術技能。",
				type = "group",
				
				args = {
					description = {
						type = "description",
						name = "下面的法術技能也會取代冷卻時間。",
						order = 1,
					},
					spellname = {
						name = "要加入的法術",
						type = "input",
						desc = "要加入到取代清單的法術名稱。",
						set = "AddSpellToOverride",
						order = 100,
					}, 
				},
			},
			resetAll = {
				name = "重置設定",
				desc = "重置所有增益和減益效果的設定，恢復成預設值。預設值會依據職業和種族而有所不同。",
				type = "execute",
				func = "ResetOptions",
				order = 10,
			},
			showCount = {
                name = "顯示數量",
                desc = "增益和減益效果超過一個時，在按鈕左側顯示數量。",
                type = "toggle",
                get = "GetCountEnabled",
                set = "SetCountEnabled",
                order = 100,
                width = "full",
            },
		},
	}
	
	self:UpdateSpellOptions(self.options.args.ignored.args, self.db.char.ignored, self.ignoreOptions)
	self:UpdateSpellOptions(self.options.args.yourbuffs.args, self.db.char.yourbuffs, self.yourBuffOptions)
	self:UpdateSpellOptions(self.options.args.alldebuffs.args, self.db.char.alldebuffs, self.allDebuffOptions)
	self:UpdateSpellOptions(self.options.args.selfbuffs.args, self.db.char.selfbuffs, self.selfBuffOptions)
	self:UpdateSpellPairOptions(self.options.args.translated.args, self.db.char.translated, self.translatedOptions)
	self:UpdateSpellOptions(self.options.args.override.args, self.db.char.override, self.overrideOptions)
end

function Dominos_BuffTimes:UpdateSpellOptions(optionList, spellList, options)
	-- add new spells that aren't in optionList
	for i in pairs(spellList) do
		-- remove space from spell name
		local intName = string.gsub(i, ' ', '')
		intName = "Spell" .. intName
				
		if not optionList[intName] then
			optionList[intName] = {
				name = i,
				type = "group",
				args = options,
			}
		end
	end
	
	-- remove from optionList spells that aren't in spellList
	for i in pairs(optionList) do
		if i ~= "description" and i ~= "spellname" and not spellList[optionList[i].name] then
			optionList[i] = nil
		end
	end
end

function Dominos_BuffTimes:UpdateSpellPairOptions(optionList, spellList, options)
	-- add new spells that aren't in optionList
	for i in pairs(spellList) do
		-- remove space from spell name
		local intName = string.gsub(i, ' ', '')
		intName = "Spell" .. intName
		
		for j in pairs(spellList[i]) do
			-- get second spell
			local intName2 = string.gsub(j, ' ', '')
			intName2 = "Spell" .. intName2
			if not optionList[intName .. " -> " .. intName2] then
				optionList[intName .. " -> " .. intName2] = {
					name = i .. " -> " .. j,
					type = "group",
					args = options,
				}
			end
		end
	end
	
	-- remove from optionList spells that aren't in spellList
	for i in pairs(optionList) do
		if i ~= "description" and i ~= "leftspellname" and i ~= "rightspellname" and i ~= "addspell" then
			-- extract the spell names
			local checkName = string.gsub(optionList[i].name, ' %-> ', '!')
			local name1, name2 = string.split('!', checkName)
			if name1 and name2 then
				if (not spellList[name1] or not spellList[name1][name2]) then
					optionList[i] = nil
				end
			end
		end
	end
end

function Dominos_BuffTimes:AddSpellToIgnored(info, value)
	self:AddIgnored(value)
	self:UpdateSpellOptions(self.options.args.ignored.args, self.db.char.ignored, self.ignoreOptions)
end

function Dominos_BuffTimes:AddSpellToYourBuff(info, value)
	self:AddYourBuff(value)
	self:UpdateSpellOptions(self.options.args.yourbuffs.args, self.db.char.yourbuffs, self.yourBuffOptions)	
end

function Dominos_BuffTimes:AddSpellToAnyDebuff(info, value)
	self:AddAllDebuff(value)
	self:UpdateSpellOptions(self.options.args.alldebuffs.args, self.db.char.alldebuffs, self.allDebuffOptions)
end

function Dominos_BuffTimes:AddSpellToSelfBuff(info, value)
	self:AddSelfBuff(value)
	self:UpdateSpellOptions(self.options.args.selfbuffs.args, self.db.char.selfbuffs, self.selfBuffOptions)
end

function Dominos_BuffTimes:AddSpellToOverride(info, value)
	self:AddOverride(value)
	self:UpdateSpellOptions(self.options.args.override.args, self.db.char.override, self.overrideOptions)
end

function Dominos_BuffTimes:RemoveSpellFromIgnored(info)
	self:RemoveIgnored(self.options.args.ignored.args[info[#info - 1]].name)
	self:UpdateSpellOptions(self.options.args.ignored.args, self.db.char.ignored, ignoreOptions)
end

function Dominos_BuffTimes:RemoveSpellFromYourBuff(info)
	self:RemoveYourBuff(self.options.args.yourbuffs.args[info[#info - 1]].name)
	self:UpdateSpellOptions(self.options.args.yourbuffs.args, self.db.char.yourbuffs, yourBuffOptions)
end

function Dominos_BuffTimes:RemoveSpellFromAnyDebuff(info)
	self:RemoveAllDebuff(self.options.args.alldebuffs.args[info[#info - 1]].name)
	self:UpdateSpellOptions(self.options.args.alldebuffs.args, self.db.char.alldebuffs, allDebuffOptions)
end

function Dominos_BuffTimes:RemoveSpellFromSelfBuff(info)
	self:RemoveSelfBuff(self.options.args.selfbuffs.args[info[#info - 1]].name)
	self:UpdateSpellOptions(self.options.args.selfbuffs.args, self.db.char.selfbuffs, selfBuffOptions)
end

function Dominos_BuffTimes:RemoveSpellFromOverride(info, value)
	self:RemoveOverride(self.options.args.override.args[info[#info - 1]].name)
	self:UpdateSpellOptions(self.options.args.override.args, self.db.char.override, self.overrideOptions)
end

function Dominos_BuffTimes:SetLeftTranslatedSpell(info, value)
	self.leftTranslatedSpell = value
end

function Dominos_BuffTimes:GetLeftTranslatedSpell(info, value)
	return self.leftTranslatedSpell
end

function Dominos_BuffTimes:SetRightTranslatedSpell(info, value)
	self.rightTranslatedSpell = value
end

function Dominos_BuffTimes:GetRightTranslatedSpell(info, value)
	return self.rightTranslatedSpell
end

function Dominos_BuffTimes:AddPairToTranslated(info)
	self:AddTranslatedSpellPair(self.leftTranslatedSpell, self.rightTranslatedSpell)
	self:UpdateSpellPairOptions(self.options.args.translated.args, self.db.char.translated, self.translatedOptions)
end

function Dominos_BuffTimes:RemovePairFromTranslated(info)
	-- extract the spell names
	local checkName = string.gsub(self.options.args.translated.args[info[#info - 1]].name, ' %-> ', '!')
	local name1, name2 = string.split('!', checkName)
	self:RemoveTranslatedSpellPair(name1, name2)
	self:UpdateSpellPairOptions(self.options.args.translated.args, self.db.char.translated, self.translatedOptions)
end

function Dominos_BuffTimes:SetCountEnabled(info, value)
    self.db.char.countEnabled = value
end

function Dominos_BuffTimes:GetCountEnabled(info, value)
    return self:IsCountEnabled()
end

function Dominos_BuffTimes:IsCountEnabled()
    return self.db.char.countEnabled
end

function Dominos_BuffTimes:ResetOptions()
	self.db.char.ignored = nil
	self.db.char.yourbuffs = nil
	self.db.char.alldebuffs = nil
	self.db.char.selfbuffs = nil
	self.db.char.translated = nil
	self.db.char.override = nil
	
	self:CheckDB()
	
	self:Print('選項已經重置為預設值。')
	
	self:UpdateSpellOptions(self.options.args.yourbuffs.args, self.db.char.yourbuffs, yourBuffOptions)
	self:UpdateSpellOptions(self.options.args.selfbuffs.args, self.db.char.selfbuffs, selfBuffOptions)
	self:UpdateSpellOptions(self.options.args.alldebuffs.args, self.db.char.alldebuffs, allDebuffOptions)
	self:UpdateSpellOptions(self.options.args.ignored.args, self.db.char.ignored, ignoreOptions)
	self:UpdateSpellOptions(self.options.args.translated.args, self.db.char.translated, self.translatedOptions)
	self:UpdateSpellOptions(self.options.args.override.args, self.db.char.override, overrideOptions)
end

--[[ Slash Commands ]]--

function Dominos_BuffTimes:RegisterSlashCommands()
	self:RegisterChatCommand('bufftimes', 'OnCmd')
end

function Dominos_BuffTimes:OnCmd(args)
	local cmd = string.split(' ', args):lower() or args:lower()
	local restOfString = string.gsub(args, cmd .. ' ', '')

	--frame functions
	if cmd == 'ignored' then
		self:ShowIgnored()
	elseif cmd == 'yourbuffs' then
		self:ShowYourBuffs()
	elseif cmd == 'alldebuffs' then
		self:ShowAllDebuffs()
	elseif cmd == 'selfbuffs' then
		self:ShowSelfBuffs()
	elseif cmd == 'override' then
		self:ShowOverride()
	elseif cmd == 'addignored' then
		self:AddIgnored(restOfString)
	elseif cmd == 'removeignored' then
		self:RemoveIgnored(restOfString)
	elseif cmd == 'addyourbuff' then
		self:AddYourBuff(restOfString)
	elseif cmd == 'removeyourbuff' then
		self:RemoveYourBuff(restOfString)
	elseif cmd == 'addalldebuff' then
		self:AddAllDebuff(restOfString)
	elseif cmd == 'removealldebuff' then
		self:RemoveAllDebuff(restOfString)
	elseif cmd == 'addselfbuff' then
		self:AddSelfBuff(restOfString)
	elseif cmd == 'removeselfbuff' then
		self:RemoveSelfBuff(restOfString)
	elseif cmd == 'addoverride' then
		self:AddOverride(restOfString)
	elseif cmd == 'removeoverride' then
		self:RemoveOverride(restOfString)
	elseif cmd == 'translated' then
		self:ShowTranslated()
	elseif cmd == 'addtranslated' then
		restOfString = restOfString:lower()
		local firstSpell, secondSpell = string.split(' ', restOfString)
		self:AddTranslatedSpellPair(firstSpell, secondSpell)
	elseif cmd == 'removetranslated' then
		restOfString = restOfString:lower()
		local firstSpell, secondSpell = string.split(' ', restOfString)
		self:RemoveTranslatedSpellPair(firstSpell, secondSpell)
	elseif cmd == 'resetoptions' then
		self:ResetOptions()
	elseif cmd == 'debugtable' then
		self:DebugOutputTable()
	elseif cmd == 'help' or cmd == '?' then
		self:PrintHelp()
	else
		self:PrintHelp()
	end
end

function Dominos_BuffTimes:PrintHelp(cmd)
	local function PrintCmd(cmd, desc)
		DEFAULT_CHAT_FRAME:AddMessage(format(' - |cFF33FF99%s|r: %s', cmd, desc))
	end
	
	self:Print('Commands (/bufftimes)')
	PrintCmd('ignored', '列出不會在按鈕上顯示時間的法術')
	PrintCmd('addignored <法術名稱>', '新增不會在按鈕上顯示時間的法術')
	PrintCmd('removeignored <法術名稱>', '移除不會在按鈕上顯示時間的法術')
	PrintCmd('yourbuffs', '列出只有自己施放才會顯示時間的增益效果')
	PrintCmd('addyourbuff <法術名稱>', '新增只有自己施放才會顯示時間的增益效果')
	PrintCmd('removeyourbuff <法術名稱>', '移除只有自己施放才會顯示時間的增益效果')
	PrintCmd('alldebuffs', '列出任何人施放都會顯示時間的減益效果')
	PrintCmd('addalldebuff <法術名稱>', '新增任何人施放都會顯示時間的減益效果')
	PrintCmd('removealldebuff <法術名稱>', '移除任何人施放都會顯示時間的減益效果')
	PrintCmd('selfbuffs', '列出自己身上會顯示時間和取代冷卻時間的增益效果')
	PrintCmd('addselfbuff <法術名稱>', '新增自己身上會顯示時間和取代冷卻時間的增益效果')
	PrintCmd('removeselfbuff <法術名稱>', '移除自己身上會顯示時間和取代冷卻時間的增益效果')
	PrintCmd('translated', '列出第一個法術按鈕會顯示另一個法術的狀態/冷卻時間的法術')
	PrintCmd('addtranslated <你的法術> <其他法術>', '新增第一個法術按鈕會顯示另一個法術的狀態/冷卻時間的法術')
	PrintCmd('removetranslated <你的法術> <其他法術>', '移除第一個法術按鈕會顯示另一個法術的狀態/冷卻時間的法術')
	PrintCmd('override', '列出會取代冷卻時間的法術')
	PrintCmd('addoverride <法術名稱>', '新增會取代冷卻時間的法術')
	PrintCmd('removeoverride <法術名稱>', '移除會取代冷卻時間的法術')
	PrintCmd('resetoptions', '重置所有增益和減益效果的設定，恢復成預設值。預設值會依據職業和種族而有所不同。')
end

function Dominos_BuffTimes:ShowIgnored()
	self:Print('不會在按鈕上顯示時間的法術')
	if next(self.db.char.ignored) then
		for i in pairs(self.db.char.ignored) do
			self:Print(i)
		end
	end
end

function Dominos_BuffTimes:ShowYourBuffs()
	self:Print('只有自己施放才會顯示時間的增益效果')
	if next(self.db.char.yourbuffs) then
		for i in pairs(self.db.char.yourbuffs) do
			self:Print(i)
		end
	end
end

function Dominos_BuffTimes:ShowAllDebuffs()
	self:Print('不論任何人施放都會顯示時間的減益效果')
	if next(self.db.char.alldebuffs) then
		for i in pairs(self.db.char.alldebuffs) do
			self:Print(i)
		end
	end
end

function Dominos_BuffTimes:ShowSelfBuffs()
	self:Print('自己身上會顯示時間和取代冷卻時間的增益效果')
	if next(self.db.char.selfbuffs) then
		for i in pairs(self.db.char.selfbuffs) do
			self:Print(i)
		end
	end
end

function Dominos_BuffTimes:ShowOverride()
	self:Print('取代冷卻時間的法術')
	if next(self.db.char.override) then
		for i in pairs(self.db.char.override) do
			self:Print(i)
		end
	end
end

function Dominos_BuffTimes:ShowTranslated()
	self:Print('法術轉換清單')
	if next(self.db.char.translated) then
		for i in pairs(self.db.char.translated) do
			for j in pairs(self.db.char.translated[i]) do
				self:Print(i .. ' -> ' .. j)
			end
		end
	end
end

function Dominos_BuffTimes:AddIgnored(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.ignored[lowerSpell] = 1
	self:Print(lowerSpell .. ' 從此不會在按鈕上顯示增益/減益效果時間')
end

function Dominos_BuffTimes:RemoveIgnored(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.ignored[lowerSpell] = nil
	self:Print(lowerSpell .. ' 現在會在按鈕上顯示增益/減益效果時間')
end
		
function Dominos_BuffTimes:AddYourBuff(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.yourbuffs[lowerSpell] = 1
	self:Print(lowerSpell .. ' 現在會在按鈕上顯示只有自己施放的增益效果時間')
end

function Dominos_BuffTimes:RemoveYourBuff(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.yourbuffs[lowerSpell] = nil
	self:Print(lowerSpell .. ' 現在會在按鈕上顯示任何人施放的增益效果時間')
end

function Dominos_BuffTimes:AddAllDebuff(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.alldebuffs[lowerSpell] = 1
	self:Print(lowerSpell .. ' 現在會在按鈕上顯示任何人施放的減益效果時間')
end

function Dominos_BuffTimes:RemoveAllDebuff(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.alldebuffs[lowerSpell] = nil
	self:Print(lowerSpell .. ' 現在會在按鈕上顯示只有自己施放的減益效果時間')
end

function Dominos_BuffTimes:AddSelfBuff(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.selfbuffs[lowerSpell] = 1
	self:Print(lowerSpell .. ' 現在只會顯示自己身上的法術時間，並且會取代冷卻時間')
end

function Dominos_BuffTimes:RemoveSelfBuff(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.selfbuffs[lowerSpell] = nil
	self:Print(lowerSpell .. ' 現在會顯示任何人身上的法術時間，並且不會取代冷卻時間')
end

function Dominos_BuffTimes:AddOverride(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.override[lowerSpell] = 1
	self:Print(lowerSpell .. ' 現在會取代冷卻時間')
end

function Dominos_BuffTimes:RemoveOverride(spell)
	local lowerSpell = string.lower(spell)
	self.db.char.override[lowerSpell] = nil
	self:Print(lowerSpell .. ' 從此不會取代冷卻時間')
end

function Dominos_BuffTimes:AddTranslatedSpellPair(firstSpell, secondSpell)
	local lowerSpell = string.lower(firstSpell)
	local lowerOtherSpell = string.lower(secondSpell)
	if not self.db.char.translated[lowerSpell] then
		self.db.char.translated[lowerSpell] = {}
	end 
		
	self.db.char.translated[lowerSpell][lowerOtherSpell] = 1
	self:Print(lowerSpell .. ' 現在會顯示冷卻時間，如果偵測到 ' .. lowerOtherSpell)
end

function Dominos_BuffTimes:RemoveTranslatedSpellPair(firstSpell, secondSpell)
	local lowerSpell = string.lower(firstSpell)
	local lowerOtherSpell = string.lower(secondSpell)
	if self.db.char.translated[lowerSpell] then
		self.db.char.translated[lowerSpell][lowerOtherSpell] = nil
	end
	
	self:Print(lowerSpell .. ' 從此不會顯示冷卻時間，如果偵測到 ' .. lowerOtherSpell)
end

function Dominos_BuffTimes:IsIgnored(spell)
	return self.db.char.ignored[spell]
end

function Dominos_BuffTimes:IsYourBuff(spell)
	return self.db.char.yourbuffs[spell]
end

function Dominos_BuffTimes:IsAllDebuff(spell)
	return self.db.char.alldebuffs[spell]
end

function Dominos_BuffTimes:IsSelfBuff(spell)
	return self.db.char.selfbuffs[spell]
end

function Dominos_BuffTimes:IsOverride(spell)
	return self.db.char.override[spell]
end

function Dominos_BuffTimes:GetSpellTranslations(spell)
	local ret = {}
	ret[spell] = 1
	
	if self.db.char.translated[spell] then
		for i in pairs(self.db.char.translated[spell]) do
			ret[i] = 1
		end
	end
	
	return ret
end
