local needToUpdateMap = true
local lastAngle = -999
local lastUnitX, lastUnitY = -999, -999
local lastScale = -999
local lastMapFileName = -999
local lastForceCounter = 100

local lastPlayerPosX = -1
local lastPlayerPosY = -1
local lastActivePointX = -1
local lastActivePointY = -1
local lastActivePointM = -1
local lastActivePointF = -1

local lastEnabled = -1

local DGV = DugisGuideViewer
if not DGV then return end

local GPS = DGV:RegisterModule("GPSArrowModule")

if GPS then
	GPS.visualMapOverlays = {}
end

--Map dimensions when scale is 1
local nativeMapWidthPx = 224
local nativeMapHeightPx = 146

GPS.Options = {
	initialWidth = 150,
	--initialHeight --height is calculated automatically.
	--initialX = 450, --not used anymore. The position is the same as old arrow
	--initialY = -25, --not used anymore. The position is the same as old arrow
	initialZoom = 4,
	zoomMax = 80,
	zoomMin = 0.3,
	borderPath = "Interface/BattlefieldFrame/UI-BattlefieldMinimap-Border.blp", --Original
	arrowPath = "Interface\\AddOns\\DugisGuideViewerZ\\Artwork\\arrow_map.tga",
	playerArrowSize = function()
		local normalizedFactor = ((DGV:GetDB(DGV_GPS_ARROW_SIZE) or DGV:GetDefaultValue(DGV_GPS_ARROW_SIZE)) - 1) / 9
		return  25 + 50 * normalizedFactor
	end,
	--partyArrowSize = 8, --not used
	--raidArrowSize = 8, --not used
	opacity = 0.2,
	darkBackgroundAlpha = 0.5,
	locked = false,
	--showPlayers = true,
	oldArrowThesholdDistance = 35,
	autoZoom = function()
		return DGV:UserSetting(DGV_GPS_ARROW_AUTOZOOM)
	end,
	autoZoomDuration_sec = 2,
	autoZoomDistanceFromEdge = 20,
	removeFog = true,
	minimapShowTreshold = 0.7, --bigger => zoom needs to be bigger more to see minimap
	minimapArea = 4, --bigger => bigger minimap area is shown => performance is lower. If minimapShowTreshold will be lower then this parameter should be increased. Integers only.
};

function GPS.GetScaleYdFactor()
	return (DGV:GetCurrentMapDimension()/500) / GPS.Scale()
end

function GPS.RefreshAndCenter()
	lastUnitX = -1
	GPS.CenterPlayerOnMap()
	GPS.RefreshPOIs()
	GPS.RefreshWorldQuests()
end

function GPS.UpdateArrowSize()
	GPSArrowIcon.Texture:SetWidth(GPS.Options.playerArrowSize())
	GPSArrowIcon.Texture:SetHeight(GPS.Options.playerArrowSize())	
end

local poiTable = {}
GPS.TaskPOIArray = {}

local lastSize = 10
function GPS.UpdateSize()
	local normalizedFactor = ((DGV:GetDB(DGV_GPS_MAPS_SIZE) or DGV:GetDefaultValue(DGV_GPS_MAPS_SIZE)) - 1) / 9
	
	GPS.Options.initialWidth = 150 * (normalizedFactor + 0.5)
	GPS.Options.initialHeight = GPS.Options.initialWidth * (nativeMapHeightPx / nativeMapWidthPx)
	GPS.SetSize(GPS.Options.initialWidth, GPS.Options.initialHeight)	
	
	GPS.RefreshAndCenter()
	
	LuaUtils:Delay(1, function()
		lastPlayerPosX = -1
	end)
	
	if (DGV:GetDB(DGV_GPS_MAPS_SIZE) or DGV:GetDefaultValue(DGV_GPS_MAPS_SIZE)) > lastSize then
		GPS.FixTopPosition()
		GPS.PlaceButtonsOutideMapIfNeeded()
	end
	
	lastSize = (DGV:GetDB(DGV_GPS_MAPS_SIZE) or DGV:GetDefaultValue(DGV_GPS_MAPS_SIZE))
	
	GPS.UpdateBorder()
end

function GPS.GetMapOverlaysFactor()
	return nativeMapWidthPx / (4*256) 
end

local BATTLEFIELD_TAB_SHOW_DELAY = 0.2;
local BATTLEFIELD_TAB_FADE_TIME = 0.15;
local DEFAULT_BATTLEFIELD_TAB_ALPHA = 0.75;
local DEFAULT_POI_ICON_SIZE = 22;
local BATTLEFIELD_MINIMAP_UPDATE_RATE = 0.1;
local NUM_BATTLEFIELDMAP_POIS = 50;

local BG_VEHICLES = {};

GPS.ShouldLoad = function()
	return true
end

function GPS:Initialize()
	
	lastSize = DGV:GetDB(DGV_GPS_MAPS_SIZE) or DGV:GetDefaultValue(DGV_GPS_MAPS_SIZE)
	
	GPS.Unload = function()
		if GPSArrowScroll then
			GPSArrowScroll:Hide()
			GPSArrowTab:SetAlpha(0)
		end
	end
	
	function GPS.Scale()
		return (GPSArrow.scale or 1 ) --*UIParent:GetScale()
	end

	function GPS.GetRealMapPx()
		--0.871287
		return 4 * GPSArrow1:GetWidth()* GPS.Scale() * 0.99, 3 * GPSArrow1:GetHeight() * 0.871287 * GPS.Scale()
	end

	function GPS.GetMapPxCenter()
		local w, h = GPS.GetRealMapPx()
		return 0.5 * w, -0.5 * h
	end

	function GPS.UpdatePlayerArrow(force)
		local shouldUpdate = false
		if force then
			shouldUpdate = true
			lastForceCounter = 100
		end
		
		if lastForceCounter > 0 then
			shouldUpdate = true
			lastForceCounter = lastForceCounter - 1
		end
		
		local angleRadians = GetPlayerFacing_dugi()
		GPSArrowIcon.Texture:SetRotation(angleRadians)
		
		local angle = 0
		
		local unitX, unitY = GetPlayerMapPosition("player")
		local mapFileName, textureHeight, _, isMicroDungeon, microDungeonMapName = GetMapInfo();
		
		if angle ~= lastAngle or GPSArrow.scale ~= lastScale or unitX ~= lastUnitX or  unitY ~= lastUnitY or lastMapFileName~=mapFileName then
			lastForceCounter = 100
			shouldUpdate = true
		end
		
		if shouldUpdate then
			GPS.CenterPlayerOnMap()
		end
		
		lastAngle = angle
		lastUnitX, lastUnitY = unitX, unitY
		lastScale = GPSArrow.scale
		lastMapFileName = mapFileName
	end

	function GPS.CenterPlayerOnMap()
		local unitX, unitY = GetPlayerMapPosition("player")
		
		if unitX == 0 and unitY == 0 then
			unitX, unitY = 0.5, 0.5
			GPSArrowIcon:SetAlpha(0)
		else
			GPSArrowIcon:SetAlpha(1)
		end
		
		if lastUnitX == unitX and lastUnitY == unitY then
			--Position was not changed
			return
		end
		
		lastUnitX, lastUnitY = unitX, unitY
		if unitX == 0 and unitY == 0 or unitX == nil then
			unitX, unitY = 0.5, 0.5
		end
		GPS.MoveMapToPoint(unitX, unitY)
	end

	function GPS.OnMouseWheel(self, delta) 
		if delta > 0 then
			 GPSArrow.scale = GPSArrow.scale * 1.1
		else
			GPSArrow.scale = GPSArrow.scale * 0.9
		end
		
		local maxZoomFactor = GPS.Options.zoomMax * (DGV:GetCurrentMapDimension()/5000)
		
		if  GPSArrow.scale > maxZoomFactor then
			GPSArrow.scale = maxZoomFactor
		end
		
		if  GPSArrow.scale < GPS.Options.zoomMin then
			GPSArrow.scale = GPS.Options.zoomMin
		end

		GPS.Zoom(GPSArrow.scale)
		GPS.RefreshAndCenter()
	end

	local visualQuests = {}
	function GPS.RefreshQuests()
		-------------PLAYER
		--taking into account player position	
		local unitX, unitY = GetPlayerMapPosition("player")	
		
		if not unitX or not unitY or (unitX == 0 or unitY == 0)then
			needToUpdateMap = true
			return
		end
		
		---------------------------------------	
		--Transform positions
		LuaUtils:foreach(visualQuests, function(poiButton)
			local posX, posY = poiButton.originalX, poiButton.originalY
			posX = posX * GPSArrowPOI:GetWidth()
			posY = posY * GPSArrowPOI:GetHeight()
			poiButton:ClearAllPoints()
			poiButton:SetPoint("CENTER", GPSArrowPOI, "TOPLEFT", posX, -posY)
		end)
	end

	function GPS.AddPOIButton(poiButton, posX, posY, frameLevelOffset, questID)
		poiButton.originalX, poiButton.originalY = posX, posY
		poiButton:SetFrameLevel(poiButton:GetParent():GetFrameLevel() + frameLevelOffset)
		visualQuests[questID] = poiButton
		GPS.RefreshQuests()
	end

	function GPS.WorldMapPOIFrame_SelectPOI(questID)
		-- POIs can overlap each other, bring the selection to the top
		local poiButton = QuestPOI_FindButton(GPSArrowPOI, questID)
		if ( poiButton ) then
			QuestPOI_SelectButton(poiButton)
			poiButton:Raise()
		else
			QuestPOI_ClearSelection(GPSArrowPOI)
		end
	end

	function GPS.DrawQuestBlobs()
		GPSArrowBlob:DrawNone()

		local questID = QuestMapFrame_GetDetailQuestID() or GetSuperTrackedQuestID()
		if not IsQuestComplete(questID) then
			GPSArrowBlob:DrawBlob(questID, true)
		end
	end

	function GPS.RefreshPOIs()
		QuestPOI_ResetUsage(GPSArrowPOI)

		local detailQuestID = QuestMapFrame_GetDetailQuestID()
		local poiButton
		
		GetQuestPOIs(poiTable)
		
		for index, questID in pairs(poiTable) do
			if ( not detailQuestID or questID == detailQuestID ) then
				local _, posX, posY = QuestPOIGetIconInfo(questID)
				if ( posX and posY ) then
					if ( IsQuestComplete(questID) ) then
						poiButton = QuestPOI_GetButton(GPSArrowPOI, questID, "map", nil)
					else
						-- if a quest is being viewed there is only going to be one POI and it's going to have number 1
						poiButton = QuestPOI_GetButton(GPSArrowPOI, questID, "numeric", (detailQuestID and 1) or index)
					end
					GPS.AddPOIButton(poiButton, posX, posY, WORLD_MAP_POI_FRAME_LEVEL_OFFSETS.TRACKED_QUEST, questID)
				end
			end
		end
		
		GPS.WorldMapPOIFrame_SelectPOI(GetSuperTrackedQuestID())
		QuestPOI_HideUnusedButtons(GPSArrowPOI)
		GPS.DrawQuestBlobs()
		GPS.UpdateQuestsVisibility()
	end

	function GPS.OnShow(self)
		--SetMapToCurrentZone();
		GPS.Update();
		GPS.UpdateOpacity();
	end

	function GPS.OnHide(self)
		GPS.ClearTextures();
	end

	function GPS.UpdateTitlePosition()
		local bordX = GPSArrowBorder:GetLeft()
		local bordW = GPSArrowBorder:GetWidth()
		local textW = GPS.title:GetWidth()
		
		GPS.title:ClearAllPoints()
		
		if bordX and bordW and textW then
			if (bordW * 0.5 + bordX) < (textW * 0.5) then
				GPS.title:SetPoint("TOPLEFT", GPSArrowScroll, "BOTTOMLEFT", -bordX, -10)
				return 
			end
			
			if bordW < textW and (textW * 0.5 + bordX + bordW * 0.5) > GetScreenWidth() then
				local x = GetScreenWidth() - (bordX + bordW)
				GPS.title:SetPoint("TOPRIGHT", GPSArrowScroll, "BOTTOMRIGHT", x, -10)
				return 
			end
		end
		
		GPS.title:SetPoint("TOP", GPSArrowScroll, "BOTTOM", 0, -10)
	end
	
	function GPS.RefreshBorder()
		local factor = GPSArrowScroll:GetWidth() / 150
		
		GPSArrowBorder:SetWidth(GPSArrowScroll:GetWidth() + 7)
		GPSArrowBorder:SetHeight(GPSArrowScroll:GetHeight()+ 9)
		GPSArrowBackground:SetWidth(GPSArrowScroll:GetWidth() + 17 * factor)
		GPSArrowBackground:SetHeight(GPSArrowScroll:GetHeight() + 15 * factor)
		
		GPSArrowBorder:ClearAllPoints()
		GPSArrowBorder:SetPoint("TOP", GPSArrowScroll, 0, 6)
		
		GPS.UpdateTitlePosition()
	end

	function GPS.SetSize(w, h)
		GPSArrowScroll:SetWidth(w)
		GPSArrowScroll:SetHeight(h)
		GPS.RefreshBorder()
	end

	function GPS.UpdateWaypointSizeOnMinimapBattle()
		if DugisArrowGlobal and DugisArrowGlobal.waypoints then
			for i = 1, #DugisArrowGlobal.waypoints do
				local point = DugisArrowGlobal.waypoints[i]
				if point and point.GPSArrowPoint then
					point.GPSArrowPoint:SetWidth(16 / (GPS.Scale() or 1))
					point.GPSArrowPoint:SetHeight(16 / (GPS.Scale() or 1))
				end
			end
		end
	end

	function GPS.UpdateQuestsVisibility()
		local unitX, unitY = GetPlayerMapPosition("player")	
		if unitX == 0 and unitY == 0 then
			GPSArrowPOI.hidden = true
		else
			GPSArrowPOI:SetScale(1 / GPS.Scale()) 
			GPSArrowPOI.hidden = false
		end
		GPS.UpdatePOISVisibility()
	end

	--Scale of the internal map (internal map dimentions)
	function GPS.Zoom(scale)
		GPSArrow.scale = scale
		
		--Removing fog
		if overlayTexturesGPS then
			local factor = GPS.GetMapOverlaysFactor()
			LuaUtils:foreach(overlayTexturesGPS, function(texture)
				if type(texture) == "table" then
					texture:ClearAllPoints()
					texture:SetPoint("TOPLEFT", GPSArrow, texture.orgX * factor, texture.orgY * factor)
					texture:SetWidth(texture.orgW * factor)
					texture:SetHeight(texture.orgH * factor)
					
					if not GPS.Options.removeFog then
						texture:Hide()
					end
				end
			end)	
		end		
		
		GPSArrow:SetScale(scale)
		
		GPSArrowBackground.Texture:SetAllPoints(GPSArrowScroll)
		
		GPSArrowBorder:ClearAllPoints()
		GPSArrowScroll:SetClampedToScreen(true)
		
		GPS.RefreshBorder()
		
		GPS.UpdateWaypointSizeOnMinimapBattle()
		
		GPSArrowScroll:UpdateScrollChildRect()
		GPS.UpdatePlayerArrow(true)
		GPS.UpdateQuestsVisibility()
		
		GPSArrow:Show()
		
		GPS.UpdateMinimapAlpha()
	end


	--     0,0 ....1......2......>
	--        .
	--        .
	--        1
	--        .
	--        .
	--        2
	--        .
	--        v

	function GPS.LocalMapPoint2ScaledPixelMapPoint(nx, ny)
		local mapW = GPSArrow:GetWidth() * GPS.Scale()
		local mapH = GPSArrow:GetHeight() * GPS.Scale()
		return nx * mapW, ny * mapH
	end

	function GPS.MoveMapToPoint(nx, ny)
		local scaledMapPointPixelX, scaledMapPointPixelY = GPS.LocalMapPoint2ScaledPixelMapPoint(nx, ny)
		local scrollBoxW = GPSArrowScroll:GetWidth()
		local scrollBoxH = GPSArrowScroll:GetHeight()
		
		local newScrollX = (scrollBoxW * 0.5) - scaledMapPointPixelX
		local newScrollY = (scrollBoxH * 0.5) - scaledMapPointPixelY
		
		GPSArrowScroll:SetHorizontalScroll(-newScrollX / GPS.Scale())
		GPSArrowScroll:SetVerticalScroll(-newScrollY / GPS.Scale())
	end

	local lastIndoors = IsIndoors()
	function GPS.CheckIndoorsChange() 
		if lastIndoors ~= IsIndoors()then
			GPS.UpdateMinimapTextures()
			GPS.UpdateMinimapAlpha()
		end
		lastIndoors = IsIndoors()
	end
	
	local lastC, lastZ, lastM, lastF =  GetCurrentMapContinent(), GetCurrentMapZone(), GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
	function GPS.OnEvent(self, event, ...)
		if ( event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" or event == "NEW_WMO_CHUNK" ) then
			if GPSArrow:IsShown() then
				if ( not WorldMapFrame:IsShown() ) then
					SetMapToCurrentZone();
					GPS.Update();
				end
			end
			
			GPS.CheckIndoorsChange() 
		elseif ( event == "WORLD_MAP_UPDATE" ) then
			if ( GPSArrow:IsVisible() ) then
				GPS.Update();
			end
			
			if DGV.OnMapChangeUpdateGPSArrow then
				DGV:OnMapChangeUpdateGPSArrow( )
			end
			
			local c, z, m, f = GetCurrentMapContinent(), GetCurrentMapZone(), GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
			
			if lastM ~= m or lastF ~= f or lastC ~= c or lastZ ~= z then
				OverrideMapOverlays()
				
				GPS.UpdateMinimapTextures()
				GPSArrowMinimap:SetAlpha(0)
				GPSArrowMinimap.alpha = 0
				
				GPS.ZoomMapTo0()
				
				GPS.zoneChanged = true
			else
				GPS.CheckIndoorsChange() 
			end
			
			lastM, lastF, lastC, lastZ = m, f, c, z
			
			GPS.UpdateOpacity()
			
		elseif event == "MINIMAP_UPDATE_ZOOM" then
			GPS.CheckIndoorsChange() 
		elseif event == "ZONE_CHANGED_INDOORS" then
			GPS.CheckIndoorsChange() 
		end
	end
	
	function GPS.ZoomMapTo0()
		local playerX, playerY = GetPlayerMapPosition("player")
		
		local mapW_yd = DGV:GetCurrentMapDimension()
		
		if (playerX == 0 and playerY == 0) or mapW_yd == 1 then
			GPS.Zoom(1)
			GPS.RefreshAndCenter()
			return true
		end
	end
	
	local currentZooming = nil
	function GPS.ZoomSmoothly(newScale, duration, onEnd, breakFunction, targetChanged)
		local initM, initF = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
		
		if GPS.zooming then
			if targetChanged then
			    currentZooming.shouldBeCanceled = true
				GPS.zooming = false
			else
				return
			end
		end
		
		GPS.zooming = true
		duration = duration or GPS.Options.autoZoomDuration_sec
		local currentZoom = GPSArrow.scale
		local diff = newScale - currentZoom
		currentZooming = LuaUtils:ProcessInTime(duration, function(value)
			value = LuaUtils.inOutQuad(value, 0, 1)
			GPS.Zoom(currentZoom + (diff * value))
			GPS.RefreshAndCenter()
			
			local currentM, currentF = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
			
			if currentM ~= initM or currentF~=initF then
				GPS.zooming = false
				GPS.ZoomMapTo0()
				return "break"
			end
			
		end, function()  
			if onEnd then
				onEnd()
			end
			GPS.zooming = false
			currentZooming = nil
		end)
	end
	
	function GPS.CurrentDistanceToEdges(dx_yd, dy_yd)
		local mapW_yd, mapH_yd = DGV:GetCurrentMapDimension()
		
		--For scale = 1
		local viewportW_yd = (GPS.Options.initialWidth / nativeMapWidthPx) * mapW_yd
		local viewportH_yd = (GPS.Options.initialHeight / nativeMapHeightPx) * mapH_yd
		
		--For current scale
		local viewportWs_yd = viewportW_yd / GPSArrow.scale
		local viewportHs_yd = viewportH_yd / GPSArrow.scale
		
		local distanceXtoEdge_yd = viewportWs_yd * 0.5 - math.abs(dx_yd)
		local distanceYtoEdge_yd = viewportHs_yd * 0.5 - math.abs(dy_yd)
		
		return distanceXtoEdge_yd, distanceYtoEdge_yd
	end
	
	function GPS.ResolveScale(dx_yd, dy_yd, distanceXtoEdge_yd, distanceYtoEdge_yd)
		local mapW_yd, mapH_yd = DGV:GetCurrentMapDimension()
		
		--For scale = 1
		local viewportW_yd = (GPS.Options.initialWidth / nativeMapWidthPx) * mapW_yd
		local viewportH_yd = (GPS.Options.initialHeight / nativeMapHeightPx) * mapH_yd
		
		local viewportWs_yd = (distanceXtoEdge_yd + math.abs(dx_yd))/0.5 
		local viewportHs_yd = (distanceYtoEdge_yd + math.abs(dy_yd))/0.5 
		
		--For current scale
		local sx = viewportW_yd /viewportWs_yd
		local sy = viewportH_yd /viewportHs_yd
		
		return sx, sy
	end
	
	function GPS.CalculatedAutoZoomDistanceFromEdge()
		local mapW_yd = DGV:GetCurrentMapDimension()
		--Limiting to 6000 to prevent useless very high zoom in on large maps
		if mapW_yd > 6000 then
			mapW_yd = 6000
		end
		return GPS.Options.autoZoomDistanceFromEdge / (mapW_yd / 1000)
	end
		
	--Current distances
	local dist_yd, dx_yd, dy_yd, pointM, pointF
	function GPS.UpdateMode(force, onlyMode, onWaypointChanged)
	
		local duration = 0.7
		if onWaypointChanged then
			duration = 0
		end
		
		if (dist_yd and dist_yd > GPS.Options.oldArrowThesholdDistance and DGV:UserSetting(DGV_ENABLED_GPS_ARROW))
			and not DGV.wayframe.button:IsShown()  then
			GPS.SetMode("GPS-arrow", force, duration)
		else
			GPS.SetMode("old-arrow", force, duration)
		end
		
		if onlyMode then
			return
		end
		
		-------AUTOZOOM-------
		if not GPS.Options.autoZoom() then
			return
		end
  
		local DugisArrow = DugisArrowGlobal
  
		local playerX, playerY = GetPlayerMapPosition("player")
		
		local active_point = DugisArrow:GetActivePoint()
		
		if active_point == nil 
		or (lastPlayerPosX == playerX and lastPlayerPosY == playerY
		and active_point.x == lastActivePointX  and active_point.y == lastActivePointY  and active_point.m == lastActivePointM  and active_point.f == lastActivePointF)
		then
			--Player position didnt change and active point didn't change
			return
		end
		
		local targetChanged = (active_point.x ~= lastActivePointX  
		or active_point.y ~= lastActivePointY  or active_point.m ~= lastActivePointM  
		or active_point.f ~= lastActivePointF)
		
		lastPlayerPosX, lastPlayerPosY = playerX, playerY
		lastActivePointX, lastActivePointY, lastActivePointM, lastActivePointF = active_point.x, active_point.y, active_point.m, active_point.f
		
		if dist_yd then
			local DugisArrow = DugisArrowGlobal
			
			local pointX, pointY = DugisArrow:GetActivePoint().x * nativeMapWidthPx, DugisArrow:GetActivePoint().y * nativeMapHeightPx
			local playerX, playerY = GetPlayerMapPosition("player")
			
			if not playerX then
				return
			end
			
			playerX, playerY = playerX * nativeMapWidthPx, playerY * nativeMapHeightPx
			
			local viewportW, viewportH = GPSArrowScroll:GetWidth(), GPSArrowScroll:GetHeight()
			
			local needZoomOut, needZoomIn
			local distanceXtoEdge_yd, distanceYtoEdge_yd = GPS.CurrentDistanceToEdges(dx_yd, dy_yd)
			
			local m, f = GetCurrentMapAreaID(), GetCurrentMapDungeonLevel()
			local mapW_yd, mapH_yd = DGV:GetMapDimension(m, f)
			
			--Player is on some different map so let him zoom
			if  (pointM ~= m or pointF ~= f) and (playerX == 0 and playerY == 0) then
				return
			end
			
			local mapSizeFactor = mapW_yd / 900
			local distanceWaypointToEdgesMin = GPS.CalculatedAutoZoomDistanceFromEdge() * mapSizeFactor
			local distanceWaypointToEdgesMax = distanceWaypointToEdgesMin + GPS.CalculatedAutoZoomDistanceFromEdge() * mapSizeFactor
			
			local neededZoomChange = 1
			local needReZoom = false
			
			if distanceXtoEdge_yd < distanceWaypointToEdgesMin or distanceYtoEdge_yd < distanceWaypointToEdgesMin 
			or (math.abs(distanceXtoEdge_yd) > distanceWaypointToEdgesMax and math.abs(distanceYtoEdge_yd) > distanceWaypointToEdgesMax)
			then
				--Average
				local distanceWaypointToEdges = (distanceWaypointToEdgesMin + distanceWaypointToEdgesMax) * 0.5
				local sX, sY = GPS.ResolveScale(dx_yd, dy_yd, distanceWaypointToEdges, distanceWaypointToEdges)
				needReZoom = true
				
				if sX < sY then
					neededZoomChange = sX
				else
					neededZoomChange = sY
				end
				
				if neededZoomChange <= 0.5 then
					return
				end
			end
			
			if needReZoom then
				GPS.ZoomSmoothly(neededZoomChange, GPS.Options.autoZoomDuration_sec, nil, nil, targetChanged)
			end
		end
	end	
		
	function GPS.DistanceChanged(dist_yd_, dx_yd_, dy_yd_, pointM_, pointF_)
		dist_yd, dx_yd, dy_yd, pointM, pointF = dist_yd_, dx_yd_, dy_yd_, pointM_, pointF_
		GPS.UpdateMode()
	end	
	
	function GPS.SetMode(mode, force, duration)
		
		if duration == nil then
			duration = 0.7
		end
		
		if GPS.currentMode == mode and mode == "GPS-arrow" and GPSArrowScroll:GetAlpha() ~= 0 and not force then
			return
		end
		
		if GPS.currentMode == mode and mode == "old-arrow" and DGV.wayframe:GetAlpha() ~= 0 and not force then
			return
		end
		
		GPS.currentMode = mode
		
		local initialWayframeAlpha = DGV.wayframe:GetAlpha()
		local initialGPSAlpha = GPSArrowScroll:GetAlpha()
		
		if mode == "GPS-arrow" then
			LuaUtils:ProcessInTime(duration, function(value)
				if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
					DGV.wayframe:SetAlpha(initialWayframeAlpha * (1-value))
					local delta = 1 - initialGPSAlpha
					GPSArrowScroll:SetAlpha(initialGPSAlpha + delta * value)
				end

			end, function()
				GPS.RefreshBorder()
			end)
		end
		
		if mode == "old-arrow" then
			LuaUtils:ProcessInTime(duration, function(value)
				local delta = 1 - initialWayframeAlpha
				if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
					DGV.wayframe:SetAlpha(initialWayframeAlpha + delta * value)
					GPSArrowScroll:SetAlpha(initialGPSAlpha * (1-value))
				end
			end, function()
				GPS.RefreshBorder()
			end)
		end		
	end
	
	function GPS.PlaceOutisideMap(frameToBePlaced, dX, dY, margin)
		local screenW, screenH = GetScreenWidth(), GetScreenHeight()
		local onOffX, onOffY = frameToBePlaced:GetLeft(), frameToBePlaced:GetTop()
		local mapX, mapY = GPSArrowScroll:GetLeft(), GPSArrowScroll:GetTop()
		
		--Map box 
		local mW = GPSArrowScroll:GetWidth()
		local mH = GPSArrowScroll:GetHeight()
		
		if onOffX + margin > mapX 
		and (onOffX - margin) < (mapX + mW)
		and onOffY - margin < mapY 
		and (onOffY + margin) > (mapY - mH)
		then
			frameToBePlaced:ClearAllPoints()
			frameToBePlaced:SetPoint("TOPLEFT", UIParent, mapX + mW + dX, -(screenH - mapY) + dY)
		end
	end
	
	function GPS.FixTopPosition()
		local top = GetScreenHeight() - GPSArrowTab:GetTop()
		if top < -10 then
			if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
				local point, relativeTo, relativePoint, xOfs, yOfs = GPSArrowScroll:GetPoint(1)
				local arrowTop = GetScreenHeight() - DGV.wayframe:GetTop()
				local diff = GPSArrowScroll:GetHeight() * 0.5 - arrowTop
				GPSArrowScroll:ClearAllPoints()
				GPSArrowScroll:SetPoint(point, relativeTo, relativePoint, xOfs, -diff)
			else
				local point, relativeTo, relativePoint, xOfs, yOfs = GPSArrowScroll:GetPoint(1)
				yOfs = -20
				GPSArrowScroll:ClearAllPoints()
				GPSArrowScroll:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
			end
		end
	end
	
	function GPS.PlaceButtonsOutideMapIfNeeded()
		GPS.PlaceOutisideMap(DugisOnOffButton, 20, 5, 20)
		GPS.PlaceOutisideMap(DugisSecureQuestButton, 25, -69, 25)
		if DGV.Modules.Target then
			GPS.PlaceOutisideMap(DGV.Modules.Target.Frame, 25, -35, 25)
		end
	end

	function GPS.UpdatePOISVisibility()
		--POIs
		if DGV:UserSetting(DGV_GPS_ARROW_POIS) and not GPSArrowPOI.hidden then
			GPSArrowPOI:Show()
		else
			GPSArrowPOI:Hide()
		end
	end
	
	function GPS.HasSomeWaypoints()
		return DugisArrowGlobal and DugisArrowGlobal.waypoints and #DugisArrowGlobal.waypoints > 0
	end
	
	function GPS.ShuldBeGPSShown()
		return (GPS.HasSomeWaypoints() or not DGV:UserSetting(DGV_GPS_AUTO_HIDE)) 
		and DGV:UserSetting(DGV_ENABLED_GPS_ARROW)
	end
	
	function GPS.UpdateMerged(resetPosition)
		if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
			GPSArrowScroll:ClearAllPoints()
			GPSArrowScroll:SetPoint("CENTER", DGV.wayframe, 0, 0)
			GPS.title:SetAlpha(1)
			GPS.tta:SetAlpha(1)
			GPS.status:SetAlpha(1)
			GPS.PlaceButtonsOutideMapIfNeeded()
		else
			DGV.wayframe:SetAlpha(1)
			GPSArrowScroll:ClearAllPoints()
			local w = GPSArrowScroll:GetWidth()
			local x, y =  DGV.wayframe:GetLeft(), GetScreenHeight() - GPSArrowScroll:GetTop()
			
			if resetPosition then
				y = GetScreenHeight() - DGV.wayframe:GetTop() - 25
			end
			
			local xShift =  DGV.wayframe:GetWidth() + 80
			
			if x >  GetScreenWidth() * 0.5 then
				xShift = -w - 80
			end
			
			GPSArrowScroll:SetPoint("TOPLEFT", UIParent,"TOPLEFT" , x + xShift, -y)
			GPSArrowScroll:SetAlpha(1)
			GPS.title:SetAlpha(0)
			GPS.tta:SetAlpha(0)
			GPS.status:SetAlpha(0)
		end
		
		GPS.FixTopPosition()
		
		GPS.UpdateMode(true)
	end
	
	function GPS.WaypointsChanged()
		GPS.UpdateMode(true, true, true)
		
		if not GPS.HasSomeWaypoints() then
			lastActivePointX = nil
		end
	end
	
	function GPS.UpdateBorder()
		GPSArrowBorder:SetBackdrop({edgeFile = DGV:GetGPSBorderPath(), tile = false, tileSize = 32, edgeSize = 16})
	end
	
	function GPS.UpdateVisibility()
		GPS.UpdateBorder()
	
		if GPS.ShuldBeGPSShown() then
			if not GPS.HasSomeWaypoints() and GPSArrow.scale ~= 1 then
				LuaUtils:Delay(0.3, function()
					if not GPS.HasSomeWaypoints() and (DugisArrowGlobal.waypoints or DugisArrowGlobal.waypointsRemoved) then
						GPS.Zoom((DGV:GetDB(DGV_GPS_MAPS_SIZE) or DGV:GetDefaultValue(DGV_GPS_MAPS_SIZE)) * 0.10 + 0.25)
						GPS.RefreshAndCenter()
						
						if  GPSArrowScroll:GetAlpha() ~= 1  then
							GPSArrowScroll:Show()
							LuaUtils:ProcessInTime(1, function(value)
								GPSArrowScroll:SetAlpha(value)
							end)		
						end
					end
				end)
			end
		
			GPSArrowScroll:Show()
		else
			GPSArrowScroll:Hide()
			GPSArrowTab:SetAlpha(0)
		end
		
		if not GPS.HasSomeWaypoints() then
			GPS.title:Hide()
			GPS.tta:Hide()
			GPS.status:Hide()
		else
			GPS.title:Show()
			GPS.tta:Show()
			GPS.status:Show()
		end
		
		if lastEnabled ~= DGV:UserSetting(DGV_ENABLED_GPS_ARROW) 
		and (DGV:UserSetting(DGV_ENABLED_GPS_ARROW)) then
			--Move buttons outside map box
			LuaUtils:Delay(0.5, function()
				GPS.PlaceButtonsOutideMapIfNeeded()
			end)
		end
		
		lastEnabled = DGV:UserSetting(DGV_ENABLED_GPS_ARROW)
	end	
	
	--Updates 
	function GPS.Update()
		-- Fill in map tiles
		local mapFileName, textureHeight, _, isMicroDungeon, microDungeonMapName = GetMapInfo();
		if (isMicroDungeon and (not microDungeonMapName or microDungeonMapName == "")) then
			return;
		end

		if ( not mapFileName ) then
			if ( GetCurrentMapContinent() == WORLDMAP_COSMIC_ID ) then
				mapFileName = "Cosmic";
			else
				-- Temporary Hack (copy of a "temporary" 6 year hack)
				mapFileName = "World";
			end
		end
		local texName;
		local dungeonLevel = GetCurrentMapDungeonLevel();
		if (DungeonUsesTerrainMap()) then
			dungeonLevel = dungeonLevel - 1;
		end

		local path;
		if (not isMicroDungeon) then
			path = "Interface\\WorldMap\\"..mapFileName.."\\"..mapFileName;
		else
			path = "Interface\\WorldMap\\MicroDungeon\\"..mapFileName.."\\"..microDungeonMapName.."\\"..microDungeonMapName;
		end

		if dungeonLevel > 0 then
			path = path..dungeonLevel.."_";
		end
		
		local numDetailTiles = GetNumberOfDetailTiles();
		for i=1, numDetailTiles do
			texName = path..i;
			_G["GPSArrow"..i]:SetTexture(texName);
		end

		-- Setup the POI's
		local iconSize = DEFAULT_POI_ICON_SIZE * GetBattlefieldMapIconScale();
		local numPOIs = GetNumMapLandmarks();
		
		if ( NUM_BATTLEFIELDMAP_POIS < numPOIs ) then
			for i=NUM_BATTLEFIELDMAP_POIS+1, numPOIs do
				GPS.CreatePOI(i);
			end
			NUM_BATTLEFIELDMAP_POIS = numPOIs;
		end
		
		for i=1, NUM_BATTLEFIELDMAP_POIS do
			local battlefieldPOIName = "GPSArrowPOI"..i;
			local battlefieldPOI = _G[battlefieldPOIName];
			
			if battlefieldPOI then
				if ( i <= numPOIs ) then
					local landmarkType, name, description, textureIndex, x, y, maplinkID, showInBattleMap = C_WorldMap.GetMapLandmarkInfo(i);
					if ( WorldMap_ShouldShowLandmark(landmarkType) and showInBattleMap ) then
						local x1, x2, y1, y2 = GetPOITextureCoords(textureIndex);
						_G[battlefieldPOIName.."Texture"]:SetTexCoord(x1, x2, y1, y2);
						x = x * GPSArrow:GetWidth();
						y = -y * GPSArrow:GetHeight();
						battlefieldPOI:SetPoint("CENTER", "GPSArrow", "TOPLEFT", x, y );
						battlefieldPOI:SetWidth(iconSize);
						battlefieldPOI:SetHeight(iconSize);
						battlefieldPOI:Show();
					else
						battlefieldPOI:Hide();
					end
				else
					battlefieldPOI:Hide();
				end
			end
		end
		
		needToUpdateMap = true
		GPS.UpdatePlayerArrow()
	end

	function GPS.ClearTextures()
		for i=1, GPSArrow:GetAttribute("NUM_BATTLEFIELDMAP_OVERLAYS") do
			_G["GPSArrowOverlay"..i]:SetTexture(nil);
		end
		local numDetailTiles = GetNumberOfDetailTiles();
		for i=1, numDetailTiles do
			_G["GPSArrow"..i]:SetTexture(nil);
		end
	end

	function GPS.CreatePOI(index)
		local frame = CreateFrame("Frame", "GPSArrowPOI"..index, GPSArrow);
		frame:SetWidth(DEFAULT_POI_ICON_SIZE);
		frame:SetHeight(DEFAULT_POI_ICON_SIZE);
		
		local texture = frame:CreateTexture(frame:GetName().."Texture", "BACKGROUND");
		texture:SetAllPoints(frame);
		texture:SetTexture("Interface\\Minimap\\POIIcons");
	end

	local lastMouseOverCheck = GetTime()
	local hovering = false
	function GPS.OnUpdate(self, elapsed)
		if needToUpdateMap then
			GPS.UpdatePlayerArrow()
			GPS.RefreshQuests()
		end
		
		if (GetTime() - lastMouseOverCheck) > 0.5 and not hovering then
			if GPSArrowScroll:IsMouseOver() and GPSArrowScroll:IsVisible() and GPSArrowScroll:GetAlpha() == 1 then
				
				if not (GPSArrowTab:GetAlpha() == 1) then
					hovering = true
					LuaUtils:ProcessInTime(0.2, function(value)
						GPSArrowTab:SetAlpha(value)
					end, function()
						hovering = false
					end)
				end
			else
				if not GPSArrowTab:IsMouseOver() and not GPS.isDragging then
					GPSArrowTab:SetAlpha(0)
				end
			end
			lastMouseOverCheck = GetTime()
		end
		
		
		-- Throttle updates
		if ( GPSArrow.updateTimer < 0 ) then
			GPSArrow.updateTimer = BATTLEFIELD_MINIMAP_UPDATE_RATE;
		else
			GPSArrow.updateTimer = GPSArrow.updateTimer - elapsed;
			return;
		end
		GPSArrow.resizing = false
		
		GPS.UpdatePlayerArrow()
	end

	function GPS.GetMapsOpacity()
		return DGV:GetDB(DGV_GPS_MAPS_OPACITY) or DGV:GetDefaultValue(DGV_GPS_MAPS_OPACITY)
	end
	
	function GPS.SetMapsAlpha(value)
		local numDetailTiles = GetNumberOfDetailTiles();
		for i=1, numDetailTiles do
			_G["GPSArrow"..i]:SetAlpha(value);
		end
		
		if overlayTexturesGPS then
			LuaUtils:foreach(overlayTexturesGPS, function(texture)
				if type(texture) == "table" then
					texture:SetAlpha(value);
				end
			end)	
		end	
		
		if GPSArrow:GetAttribute("NUM_BATTLEFIELDMAP_OVERLAYS") then
			for i=1, GPSArrow:GetAttribute("NUM_BATTLEFIELDMAP_OVERLAYS") do
				_G["GPSArrowOverlay"..i]:SetAlpha(mapsAlpha);
			end
		end
		
	end
	
	function GPS.UpdateOpacity()
		local bordersAlpha = DGV:GetDB(DGV_GPS_BORDER_OPACITY) or DGV:GetDefaultValue(DGV_GPS_BORDER_OPACITY)
		local mapsAlpha = GPS.GetMapsOpacity()
		
		
		local darkBackgroundAlpha = GPS.Options.darkBackgroundAlpha
		
		if mapsAlpha < darkBackgroundAlpha then
			darkBackgroundAlpha = mapsAlpha
		end
		
		GPSArrowBackground:SetAlpha(darkBackgroundAlpha)
		
		GPSArrowOptions.mapsAlpha = mapsAlpha
		
		if GPSArrowPOI then
			--GPSArrowPOI:SetAlpha(mapsAlpha);
		end
		
		GPSArrowBorder:SetAlpha(bordersAlpha);
		
		if not GPSArrowMinimap or GPSArrowMinimap:GetAlpha() == 0 then
			GPS.SetMapsAlpha(mapsAlpha)
		end
	end

	-------------------------------------------------------------------
	-------------------------- World Quests ---------------------------
	-------------------------------------------------------------------


	----------------------------------------------
	-------------- System Event Handler ----------
	----------------------------------------------
	function GPS.RefreshWorldQuests()
		local mapAreaID     = GetCurrentMapAreaID()
		local taskInfo      = C_TaskQuest.GetQuestsForPlayerByMapID(mapAreaID)
		local numTaskPOIs   = taskInfo and #taskInfo or 0

		local hasWorldQuests = false
		local taskIconIndex = 1

		if numTaskPOIs > 0 then
			for i, info in ipairs(taskInfo) do
				if HaveQuestData(info.questId) then
					local taskPOI
					local isWorldQuest = QuestUtils_IsQuestWorldQuest(info.questId)
					if isWorldQuest then
						taskPOI = GPS.TryCreatingWorldQuestPOIDD(info, taskIconIndex)
					end

					if taskPOI then
						GPS.AddPOIButton(taskPOI, info.x, info.y, isWorldQuest and WORLD_MAP_POI_FRAME_LEVEL_OFFSETS.WORLD_QUEST or WORLD_MAP_POI_FRAME_LEVEL_OFFSETS.BONUS_OBJECTIVE, info.questId)
						taskPOI.questID = info.questId
						taskPOI.numObjectives = info.numObjectives
						taskPOI:Show()

						taskIconIndex = taskIconIndex + 1

						if ( isWorldQuest ) then
							hasWorldQuests = true
						end
					end
				end
			end
		end

		-- Hide unused icons in the pool
		for i = taskIconIndex, #GPS.TaskPOIArray do
			GPS.TaskPOIArray[i]:Hide()
		end
	end

	function GPS.GetTaskPOI(index)
		local button = GPS.TaskPOIArray[index]

		while #GPS.TaskPOIArray < index do
			button = CreateFrame("Button", nil, GPSArrowPOI)
			button:SetFlattensRenderLayers(true)
			button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

			button.Texture = button:CreateTexture(nil, "BACKGROUND")
			button.Texture:SetPoint("CENTER")

			button.Glow = button:CreateTexture(nil, "BACKGROUND", -2)
			button.Glow:SetSize(50, 50)
			button.Glow:SetPoint("CENTER")
			button.Glow:SetTexture("Interface/WorldMap/UI-QuestPoi-IconGlow.tga")
			button.Glow:SetBlendMode("ADD")

			button.SelectedGlow = button:CreateTexture(nil, "OVERLAY", 2)
			button.SelectedGlow:SetBlendMode("ADD")

			button.CriteriaMatchGlow = button:CreateTexture(nil, "BACKGROUND", -1)
			button.CriteriaMatchGlow:SetAlpha(.6)
			button.CriteriaMatchGlow:SetBlendMode("ADD")

			button.SpellTargetGlow = button:CreateTexture(nil, "OVERLAY", 1)
			button.SpellTargetGlow:SetAtlas("worldquest-questmarker-abilityhighlight", true)
			button.SpellTargetGlow:SetAlpha(.6)
			button.SpellTargetGlow:SetBlendMode("ADD")
			button.SpellTargetGlow:SetPoint("CENTER", 0, 0)

			button.Underlay = button:CreateTexture(nil, "BACKGROUND")
			button.Underlay:SetWidth(34)
			button.Underlay:SetHeight(34)
			button.Underlay:SetPoint("CENTER", 0, -1)

			button.TimeLowFrame = CreateFrame("Frame", nil, button)
			button.TimeLowFrame:SetSize(22, 22)
			button.TimeLowFrame:SetPoint("CENTER", -10, -10)
			button.TimeLowFrame.Texture = button.TimeLowFrame:CreateTexture(nil, "OVERLAY")
			button.TimeLowFrame.Texture:SetAllPoints(button.TimeLowFrame)
			button.TimeLowFrame.Texture:SetAtlas("worldquest-icon-clock")

			WorldMap_ResetPOI(button, true, false)

			GPS.TaskPOIArray[#GPS.TaskPOIArray + 1] = button
		end

		return button
	end

	function GPS.TryCreatingWorldQuestPOIDD(info, taskIconIndex)
		if ( WorldMap_IsWorldQuestSuppressed(info.questId) or not WorldMap_DoesWorldQuestInfoPassFilters(info) ) then
			return nil
		end

		local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = GetQuestTagInfo(info.questId)

		local taskPOI = GPS.GetTaskPOI(taskIconIndex)
		local selected = info.questId == GetSuperTrackedQuestID()

		local isCriteria = WorldMapFrame.UIElementsFrame.BountyBoard:IsWorldQuestCriteriaForSelectedBounty(info.questId)
		local isSpellTarget = SpellCanTargetQuest() and IsQuestIDValidSpellTarget(info.questId)

		taskPOI.worldQuest = true
		taskPOI.Texture:SetDrawLayer("OVERLAY")

		WorldMap_SetupWorldQuestButton(taskPOI, worldQuestType, rarity, isElite, tradeskillLineIndex, info.inProgress, selected, isCriteria, isSpellTarget)

		C_TaskQuest.RequestPreloadRewardData(info.questId)

		if rarity ~= LE_WORLD_QUEST_QUALITY_EPIC then
			local _, texture, name, quality, r, g, b
			local qid = info.questId
			if GetNumQuestLogRewards(qid) > 0 then
				_, texture, _, quality = GetQuestLogRewardInfo(1, qid)
				r, g, b = GetItemQualityColor(quality)
			elseif GetQuestLogRewardMoney(qid) > 0 then
				texture = "Interface/ICONS/INV_Misc_Coin_01"
				r, g, b = 0.85, 0.7, 0
			elseif GetNumQuestLogRewardCurrencies(qid) > 0 then
				for i = 1, GetNumQuestLogRewardCurrencies(qid)  do
				   name, texture = GetQuestLogRewardCurrencyInfo(i, qid)
				   if name == WORLD_QUEST_REWARD_FILTERS_ORDER_RESOURCES then
					  break
				   end
				end
				r, g, b = 0.6, 0.4, 0.1
			end
		end

		return taskPOI
	end
	
	local GPSMinimapTextures = {}

	function GPS.UpdateMinimapTextures()
		if not GPSArrowMinimap then
			GPSArrowMinimap = CreateFrame("Frame", "GPSArrowMinimap", GPSArrow)
			GPSArrowMinimap:SetPoint("TOPLEFT",GPSArrow, 0,0)
			GPSArrowMinimap:SetWidth(225)
			GPSArrowMinimap:SetHeight(225)
			GPSArrowMinimap:SetAlpha(GPS.GetMapsOpacity())
			GPSArrowMinimap.alpha = GPS.GetMapsOpacity()
		end
		
		local TERRAIN_MAGIC =  1600/3
		local TERRAIN_PATH = 'world/minimaps/%s/map%02d_%02d'
		local UNDERWATER_PATH = 'world/minimaps/%s/noliquid_map%02d_%02d'
		
		local areaID = GetCurrentMapAreaID()
		GPSArrowMinimap.isDisplayed = false
		local _, _, _, isMicroDungeon = GetMapInfo()
		local floorNum, dBRx, dBRy, dTLx, dTLy = GetCurrentMapDungeonLevel()
		
		if not isMicroDungeon and not IsIndoors() then
			local terrainMapID = GetAreaMapInfo(areaID) or -1
			
			--print("terrainMapID", terrainMapID, "areaID", areaID, "floorNum", floorNum)
			
			local _, TLx, TLy, BRx, BRy = GetCurrentMapZone()
			
			if DungeonUsesTerrainMap() then
				floorNum = floorNum - 1
			end
			
			if floorNum > 0 then
				TLx, TLy, BRx, BRy = dTLx, dTLy, dBRx, dBRy
			end
			
			if TLx 
			and TLx ~= 0 
			and DGV.TERRAIN_MAPS[terrainMapID]
			and areaID ~= 1184 --Argus
			and areaID ~= 613 --Vashj'ir
			and (floorNum ~= 0 or TLx ~=0 or  TLy ~=0 or  BRx ~=0 or BRy ~=0)
			then
				local areaWidth, areaHeight = abs(BRx-TLx), abs(BRy-TLy)	
				
				local sizeBaseW = 219
				local sizeBaseH = sizeBaseW * (668 / 1002)
				
				local tileSize = sizeBaseW/areaWidth*TERRAIN_MAGIC
				local iTileX, fTileX = math.modf(32-TLx/TERRAIN_MAGIC)
				local iTileY, fTileY = math.modf(32-TLy/TERRAIN_MAGIC)
				local tileOffsetX, tileOffsetY = (TLx-((iTileX-32)*-TERRAIN_MAGIC))/areaWidth, (TLy-((iTileY-32)*-TERRAIN_MAGIC))/areaHeight
				local numTilesX, numTilesY = ceil((areaWidth+fTileX*TERRAIN_MAGIC)/TERRAIN_MAGIC), ceil((areaHeight+fTileY*TERRAIN_MAGIC)/TERRAIN_MAGIC)
				
				local n = 0
				for y=1,numTilesY do
					for x=1,numTilesX do
					
						--For optimization purposes. Displayed is only close area to current player position. Check minimapArea option for more details
						local playerIn = false
						
						local unitX, unitY = GetPlayerMapPosition("player")
					
						if (unitX == 0 or unitX == nil) and (unitY == 0 or unitY == nil) then
							unitX, unitY = 0.5, 0.5
						end
					
						local currentNormXMin = (x - 1 - GPS.Options.minimapArea)/numTilesX
						local currentNormXMax = (x + GPS.Options.minimapArea)/numTilesX
						
						local currentNormYMin = (y - 1 - GPS.Options.minimapArea)/numTilesY
						local currentNormYMax = (y + GPS.Options.minimapArea)/numTilesY
						
						if unitX >= currentNormXMin and unitX <= currentNormXMax
						and unitY >= currentNormYMin and unitY <= currentNormYMax then
							playerIn = true
						end
					
						if playerIn then
							n = n + 1
							if not GPSMinimapTextures[n] then
								GPSMinimapTextures[n] = GPSArrowMinimap:CreateTexture(nil, "BACKGROUND", nil, true)
								GPSMinimapTextures[n]:SetAlpha(1)
							end
							local texture = GPSMinimapTextures[n]
							
							local textureWidth, textureHeight = tileSize, tileSize
							local textureOffsetX, textureOffsetY = tileOffsetX*sizeBaseW+tileSize*(x-1), -tileOffsetY*sizeBaseH-tileSize*(y-1)
							local left, right, top, bottom = 0, 1, 0, 1
							if numTilesX == 1 and numTilesY == 1 then -- only 1 tile.. trim from all sides
								textureWidth, textureHeight = sizeBaseW, sizeBaseH
								textureOffsetX, textureOffsetY = 0, 0
								left = fTileX
								top = fTileY
								right = (sizeBaseW+fTileX*tileSize)/tileSize
								bottom = (sizeBaseH+fTileY*tileSize)/tileSize
							elseif numTilesX == 1 then -- only 1 tile wide, trim from left and right
								textureWidth = sizeBaseW
								textureOffsetX = 0
								left = fTileX
								right = (sizeBaseW+fTileX*tileSize)/tileSize
							elseif numTilesY == 1 then -- only 1 tile tall, trim from top and bottom
								textureHeight = sizeBaseH
								textureOffsetY = 0
								top = fTileY
								bottom = (sizeBaseH+fTileY*tileSize)/tileSize
							elseif y == 1 and x == 1 then -- top left corner, trim from top and left
								textureWidth, textureHeight = tileSize - fTileX*tileSize, tileSize - fTileY*tileSize
								textureOffsetX, textureOffsetY = 0, 0
								left = fTileX
								top = fTileY
							elseif y == 1 and x == numTilesX then -- top right corner
								textureWidth, textureHeight = sizeBaseW - textureOffsetX, tileSize - fTileY*tileSize
								textureOffsetY = 0
								top = fTileY
								right = textureWidth/tileSize
							elseif y == numTilesY and x == numTilesX then -- bottom right corner
								textureWidth, textureHeight = sizeBaseW - textureOffsetX, textureOffsetY + sizeBaseH
								right = textureWidth/tileSize
								bottom = textureHeight/tileSize
							elseif y == numTilesY and x == 1 then -- bottom left corner
								textureWidth, textureHeight = tileSize - fTileX*tileSize, textureOffsetY + sizeBaseH
								textureOffsetX = 0
								left = fTileX
								bottom = textureHeight/tileSize
							elseif y == 1 then -- top row
								textureHeight = tileSize - fTileY*tileSize
								textureOffsetY = 0
								top = fTileY
							elseif x == numTilesX then -- right column
								textureWidth = sizeBaseW - textureOffsetX
								right = textureWidth/tileSize
							elseif y == numTilesY then -- bottom row
								textureHeight = textureOffsetY + sizeBaseH
								bottom = textureHeight/tileSize
							elseif x == 1 then -- left column
								textureWidth = tileSize - fTileX*tileSize
								textureOffsetX = 0
								left = fTileX
							end
							
							texture:SetTexCoord(left, right, top, bottom)
							texture:SetPoint('TOPLEFT', textureOffsetX, textureOffsetY)
							
							local paf = (areaID == 610 or areaID == 614 or areaID == 615) and UNDERWATER_PATH or TERRAIN_PATH
							local texturePath = paf:format(DGV.TERRAIN_MAPS[terrainMapID], iTileX+(x-1), iTileY+(y-1))
							texture:SetTexture(texturePath, false)
							texture:SetSize(textureWidth, textureHeight)
							texture:Show()
						end
					end
				end
				
				for i=n+1,#GPSMinimapTextures do
					GPSMinimapTextures[i]:Hide()
				end
				
				GPSArrowMinimap:Show()
				GPSArrowMinimap.isDisplayed = true
				return
			else
				GPSArrowMinimap:Hide()
				return
			end
		end
		
		for i=1,#GPSMinimapTextures do
			GPSMinimapTextures[i]:Hide()
		end
	end

	local UpdateMinimapAlpha_awaiting = false
	function GPS.UpdateMinimapAlpha()
		if not GPSArrowMinimap or UpdateMinimapAlpha_awaiting then
			return
		end
		
		if not DGV:UserSetting(DGV_GPS_MINIMAP_TERRAIN_DETAIL) or not GPSArrowMinimap.isDisplayed then
			GPS.SetMapsAlpha(GPS.GetMapsOpacity())
			GPSArrowMinimap:SetAlpha(0)
			GPSArrowMinimap.alpha = 0
			GPSArrowMinimap:Hide()
			return
		else
			GPSArrowMinimap:Show()
		end
		
		--Fading in progress
		if GPS.fading then
			LuaUtils:Delay(1, function()
				UpdateMinimapAlpha_awaiting = false
				GPS.UpdateMinimapAlpha()
			end)
			UpdateMinimapAlpha_awaiting = true
			return
		end
		
		local factor = GPS.GetScaleYdFactor()
		
		local newAlpha = 0
		local oldAlpha = GPSArrowMinimap.alpha
		local shouldFade = false
		if factor < GPS.Options.minimapShowTreshold then
			newAlpha = GPS.GetMapsOpacity()
		end
		
		if newAlpha ~= oldAlpha then
			GPS.fading = true
			LuaUtils:ProcessInTime(0.5, function(value)
				if GPS.zoneChanged then
					GPS.fading = false
					GPS.zoneChanged = false
					return "break"
				end 
			
				local val = oldAlpha + value * (newAlpha - oldAlpha)
				GPSArrowMinimap:SetAlpha(val)
				GPSArrowMinimap.alpha = val
				
				if newAlpha > 0 then
					GPS.SetMapsAlpha((1-value) * GPS.GetMapsOpacity())
				else
					GPS.SetMapsAlpha(value * GPS.GetMapsOpacity())
				end
				
			end, function()  
				GPSArrowMinimap:SetAlpha(newAlpha)
				GPSArrowMinimap.alpha = newAlpha
				GPS.zoneChanged = false
				GPS.fading = false
			end)	
		end
	end
	
	GPS.Load = function()
		lastUnitY = -1
		GPS.loaded = true
		lastForceCounter = 100
		
		lastEnabled = DGV:UserSetting(DGV_ENABLED_GPS_ARROW)
		
		if not GPSArrow.registeredEvents then
			GPSArrow:SetAttribute("NUM_BATTLEFIELDMAP_OVERLAYS",0);
			GPSArrow:RegisterEvent("PLAYER_ENTERING_WORLD");
			GPSArrow:RegisterEvent("ZONE_CHANGED");
			GPSArrow:RegisterEvent("ZONE_CHANGED_NEW_AREA");
			GPSArrow:RegisterEvent("WORLD_MAP_UPDATE");
			GPSArrow:RegisterEvent("NEW_WMO_CHUNK");
			GPSArrow:RegisterEvent("MINIMAP_UPDATE_ZOOM");
			GPSArrow:RegisterEvent("ZONE_CHANGED_INDOORS");
			
			GPSArrow:SetScript("OnShow", GPS.OnShow)
			GPSArrow:SetScript("OnHide", GPS.OnHide)
			GPSArrow:SetScript("OnEvent", GPS.OnEvent)
			GPSArrow:SetScript("OnUpdate", GPS.OnUpdate)
			
			GPSArrow.registeredEvents = true
		end
		
		GPSArrow.updateTimer = 0;
		
		if not GPSArrowOverlayFrame then
			CreateFrame("FRAME", "GPSArrowOverlayFrame", GPSArrow)
			GPSArrow.map_overlay = GPSArrowOverlayFrame
			
			GPSArrow.map_overlay:SetAllPoints()
			GPSArrow.map_overlay:EnableMouse(false)
			GPSArrow.map_overlay:SetScript("OnUpdate", function()
				GPS.UpdatePlayerArrow()
			end)
		end
		
		--Fixing oryginal Zoom Map player position
		local worldMapWidth, worldMapHeight = WorldMapDetailFrame:GetSize()
		local tileSize = GPSArrow1:GetWidth()
		local worldTileSize = WorldMapDetailTile1:GetWidth()
		GPSArrow:SetSize(worldMapWidth / worldTileSize * tileSize, worldMapHeight / worldTileSize * tileSize)
		
		if ( not GPSArrowOptions ) then
			GPSArrowOptions = GPS.Options;
		end

		GPS.UpdateOpacity();
		
		GPSArrowBorder:ClearAllPoints()
		
		if not GPSArrowScroll then
			CreateFrame("ScrollFrame", "GPSArrowScroll", UIParent)
			
			GPSArrowScroll:SetSize(300, 200)
			GPSArrowScroll:SetScrollChild(GPSArrow)            
			
			GPSArrowScroll:UpdateScrollChildRect()
			GPSArrowScroll:SetVerticalScroll(0)
			GPSArrowScroll:SetHorizontalScroll(0)
			
			GPSArrowScroll:EnableMouseWheel(true)
			
			GPSArrowScroll:HookScript("OnMouseWheel", GPS.OnMouseWheel)
			
			GPSArrowScroll:ClearAllPoints()
			GPSArrowScroll:SetPoint("CENTER", DGV.wayframe, 0, 0)
			
			GPS.UpdateBorder()
			
		end
		
		if not GPS.status then
			GPS.status = GPSArrowScroll:CreateFontString("OVERLAY", nil, "GameFontNormalSmall")
			GPS.tta = GPSArrowScroll:CreateFontString("OVERLAY", nil, "GameFontNormalSmall")
			GPS.title = GPSArrowScroll:CreateFontString("OVERLAY", nil, "GameFontHighlightSmall")
			
			hooksecurefunc(GPS.title, "SetText", function()
				GPS.UpdateTitlePosition()
			end)
		end

		GPS.status:SetText("")
		GPS.tta:SetText("")
		GPS.title:SetText("")

		if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
			GPSArrowScroll:SetAlpha(0)
			DGV.wayframe:SetAlpha(0)
		else
			GPS.title:SetAlpha(0)
			GPS.tta:SetAlpha(0)
			GPS.status:SetAlpha(0)
		end

		GPSArrow:EnableMouseWheel(false)
		GPSArrow:EnableMouse(false)

		GPSArrowBorder:SetParent(GPSArrowScroll)
		GPSArrowBackground:SetParent(GPSArrowScroll)
	 
		GPSArrowBorder:SetFrameStrata(GPSArrowScroll:GetFrameStrata())
		
		GPSArrowBackground:SetFrameStrata(GPSArrowScroll:GetFrameStrata())
		GPSArrowBackground:SetFrameLevel(GPSArrowScroll:GetFrameLevel()-1)
		
		if not GPSArrowPOIFrame then
			CreateFrame("FRAME", "GPSArrowPOIFrame", GPSArrow)
		end
		GPSArrowPOI = GPSArrowPOIFrame
		GPSArrowPOI:SetAllPoints()
	   
	   
		if not GPSArrowBlobFrame then
			CreateFrame("QuestPOIFrame", "GPSArrowBlobFrame", GPSArrowPOI)
			GPSArrowBlob = GPSArrowBlobFrame
			GPSArrowBlob:SetAllPoints(GPSArrowPOI)
			WorldMapBlobFrame_OnLoad(GPSArrowBlob)
			
			local function WorldMapPOIButton_Init(self)
			end
			
			QuestPOI_Initialize(GPSArrowPOI, WorldMapPOIButton_Init)
			GPSArrowPOI.initialized = true
		end

		GPSArrowBlob:SetFrameStrata(GPSArrow.map_overlay:GetFrameStrata())
		GPSArrowBlob:SetFrameLevel(GPSArrow.map_overlay:GetFrameLevel()-1)

		
		QuestMapFrame_UpdateAll()
	 
		local debugBorders = false
		if debugBorders then
			GUIUtils:HighlightFrame(GPSArrow)
		end
		
		if not GPS.hookedQuestMapFrame_UpdateAll then
			hooksecurefunc("QuestMapFrame_UpdateAll", function()
				GPS.RefreshPOIs()
				GPS.RefreshWorldQuests()
			end)
			
			GPS.hookedQuestMapFrame_UpdateAll = true
		end
		
		
		GPS.Zoom(GPS.Options.initialZoom)
	
		GPSArrowIcon.Texture:SetTexture(GPS.Options.borderPath)
		GPSArrowIcon:SetFrameStrata(GPSArrowUnitPositionFrame:GetFrameStrata())
		GPSArrowIcon:SetFrameLevel(GPSArrowUnitPositionFrame:GetFrameLevel() + 1)
		GPSArrowIcon.Texture:SetTexture(GPS.Options.arrowPath)
		GPS.UpdateArrowSize()

		GPSArrowIcon:SetParent(GPSArrowScroll)
	
		GPSArrowTab:EnableMouse(true)
		GPSArrowScroll:SetMovable(true)
		
		GPSArrowTab:SetScript("OnMouseDown", function() 
			if DugisArrowGlobal:GetSetting("gps_locked") then
				return
			end
			if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
				DugisArrowFrame:StartMoving()  
			else
				GPSArrowScroll:StartMoving()  
			end
			GPS.isDragging = true
		end)
			
		GPSArrowTab:SetScript("OnMouseUp", function() 
			if DGV:UserSetting(DGV_GPS_MERGE_WITH_DUGI_ARROW) then
				GPS.UpdateTitlePosition()
				DugisArrowFrame.OnActionButtonDragStop(true)  
			else
				GPSArrowScroll:StopMovingOrSizing()  
			end
			GPS.FixTopPosition()
			GPS.isDragging = false
		end)
	
		GPS.UpdateSize()
	
		GPSArrowScroll:Hide()
		GPSArrowTab:SetAlpha(0)
		GPSArrowBlob:Show()
		GPSArrowIcon:Show()
		
		GPS.DrawQuestBlobs()
		
		GPS.UpdatePlayerArrow(true)
		
		GPS.UpdateVisibility()
		
		GPSArrowTab:SetPoint("TOPLEFT", "GPSArrowScroll", "TOPLEFT", -4, 32);
		
		if not GPSArrowMinimap then
			GPS.UpdateMinimapTextures()
		end
		
	end
end

