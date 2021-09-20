local Favorites = LibStub("AceAddon-3.0"):GetAddon("Favorites")
function Favorites:UpdateOptions()
	local favTypes = {}
	local selectedFav = 1
	local c = 1
	for i in pairs(Favorites.db.profile.favTypes) do
		favTypes[c] = i
		c = c + 1
	end

	Favorites.favTypes = favTypes
	Favorites.selectedFav = selectedFav
end
function Favorites:SetupOptions()
	Favorites:UpdateOptions()
	self.options = {
		type = "group",
		name = "最愛好友名單",
		childGroups = "tab",
		plugins = {},
		args = {
			author = {
			  name = "|cff1fd700作者：|rJax",
			  type = "description"
			},
			version = {
			  name = "|cff1fd700版本：|r"..GetAddOnMetadata("Favorites", "Version").."\n",
			  type = "description"
			},
			moreoptions={
			  name = "一般",
			  type = "group",
			  args={
				 ccBG = {
				  order = 1,
				  width = "normal",
				  name = "背景顏色",
				  desc = "依據陣營顯示每位好友的背景顏色",
				  type = "toggle",
				  set = function(info,val) self.db.profile.colorBackground = val
										   FriendsList_Update(true)
					    end,
				  get = function(info) return self.db.profile.colorBackground end
				},
				ccOF = {
				  order = 2,
				  width = "double",
				  name = "敵對陣營使用職業顏色",
				  desc = "使用職業顏色顯示敵對陣營的好友",
				  type = "toggle",
				  set = function(info,val) self.db.profile.classColorOppositeFaction = val
										   FriendsList_Update(true)
						end,
				  get = function(info) return self.db.profile.classColorOppositeFaction end
				},
				favTypes={
					order = 3,
					name = "現有的最愛群組",
					type = "select",
					values = Favorites.favTypes,
					get = function(i) return Favorites.selectedFav end,
					set = function(i, v, s) Favorites.selectedFav = v end,
					style = "radio"
				},
				delFav={
					order = 4,
					width = "normal",
					name = "移除群組",
					type = "execute",
					disabled  = function()
						return #Favorites.favTypes == 1 or Favorites.favTypes[Favorites.selectedFav] == "最愛"
					end,
					confirm = function(i,v)
						return "是否確定要移除最愛群組："..Favorites.favTypes[Favorites.selectedFav].."?"
					end,
					func = function(i, v)
						Favorites.db.profile.favTypes[Favorites.favTypes[Favorites.selectedFav]] = nil
						Favorites:UpdateOptions()

						Favorites.options.args.moreoptions.args.favTypes.values = Favorites.favTypes
						--LibStub("AceConfigRegistry-3.0"):NotifyChange("|cff1fd700Favorites|r")
						FriendsList_Update(true)
					end,
			    },
					resetFav={
						order = 8,
						width = "nomral",
						name = "全部重置",
						type = "execute",
						confirm = function(i,v)
							return "是否確定要清除全部的最愛群組?"
						end,
						func = function(i, v)
							for s, j in pairs (Favorites.db.profile.favTypes) do
								if s == "最愛" then
									for ff,_ in pairs (Favorites.db.profile.favTypes[s]) do
										Favorites.db.profile.favTypes[s][ff] = nil
									end
								else
									-- print(s)
									Favorites.db.profile.favTypes[s] = nil
								end
							end
				--			Favorites.db.profile.favTypes["Favorites"] = { }
							Favorites:UpdateOptions()

							Favorites.options.args.moreoptions.args.favTypes.values = Favorites.favTypes
							--LibStub("AceConfigRegistry-3.0"):NotifyChange("|cff1fd700Favorites|r")
							FriendsList_Update(true)
						end,
				    },
				spacer = {
				   type = "description",
				   name="", --use an empty value for name
				   order = 5,
				   width="small", --forces a new line after the items above it
				},
				addFav={
					order = 6,
					name = "新增自訂的最愛群組",
					type = "input",
					get = function() return "" end,
					set = function(i, v)
						Favorites.db.profile.favTypes[v] = { }
						Favorites:UpdateOptions()
						Favorites.options.args.moreoptions.args.favTypes.values = Favorites.favTypes
						--LibStub("AceConfigRegistry-3.0"):NotifyChange("|cff1fd700Favorites|r")
						FriendsList_Update(true)
						end,
			    },
				notes = {
				   type = "description",
				   name="\n\n不能刪除預設的最愛群組。", --use an empty value for name
				   order =7,
				   width="full", --forces a new line after the items above it
				},

			  }
			}
		}
	}
	LibStub("AceConfig-3.0"):RegisterOptionsTable("|cff1fd700Favorites|r", self.options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("|cff1fd700Favorites|r", "好友名單-最愛")
	self:RegisterChatCommand("favs", function() InterfaceOptionsFrame_OpenToCategory("好友名單-最愛") InterfaceOptionsFrame_OpenToCategory("好友名單-最愛") end)
	self:RegisterChatCommand("favorites", function() InterfaceOptionsFrame_OpenToCategory("好友名單-最愛") InterfaceOptionsFrame_OpenToCategory("好友名單-最愛") end)
end
