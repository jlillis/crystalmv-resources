function initPositionMarkers()
	pos_marker_root = getElementByID("npc_tseq:pos_marker_root")
	pos_marker_visible = true

	addCommandHandler("showposmarkers",function()
		togglePosMarkerVisibility(not arePosMarkersVisible())
	end)

	addEventHandler("onClientHUDRender",root,renderPosMarkers)
end

function togglePosMarkerVisibility(visible)
	pos_marker_visible = visible
end

function arePosMarkersVisible()
	return pos_marker_visible
end

function startPosMarkerSearch()
	if searching_pos_markers then return end
	searching_pos_markers = true
	addEventHandler("onClientPreRender",root,findPosMarker)
end

function stopPosMarkerSearch()
	if not searching_pos_markers then return end
	searching_pos_markers = nil
	removeEventHandler("onClientPreRender",root,findPosMarker)
	if isElement(active_pos_marker) then
		active_pos_marker = nil
	end
end

function findPosMarker()
	if isElement(active_pos_marker) then
		active_pos_marker = nil
	end
	if not pos_marker_visible then return end
	local csx,csy = getCursorPosition()
	if not csx then return end
	local sw,sh = guiGetScreenSize()
	csx,csy = csx*sw,csy*sh
	local nearest_marker,nearest_dist = nil,16*16
	local markers = getElementsByType("posmarker",pos_marker_root,false)
	for marknum,marker in ipairs(markers) do
		local x,y,z = getElementPosition(marker)
		local sx,sy,sz = getScreenFromWorldPosition(x,y,z,0,true)
		if sx then
			sx,sy = sx-csx,sy-csy
			local this_dist = sx*sx+sy*sy
			if this_dist < nearest_dist then
				nearest_marker = marker
				nearest_dist = this_dist
			end
		end
	end
	if nearest_marker then
		active_pos_marker = nearest_marker
	end
end

function renderPosMarkers()
	if not pos_marker_visible then return end
	local markers = getElementsByType("posmarker",pos_marker_root,false)
	for marknum,marker in ipairs(markers) do
		local x,y,z = getElementPosition(marker)
		local sx,sy,sz = getScreenFromWorldPosition(x,y,z,0,true)
		if sx then
			local color = marker == active_pos_marker and 0xFFFF0000 or 0xFF00FF00
			dxDrawRectangle(sx-6,sy-6,12,12,0xFF000000)
			dxDrawRectangle(sx-4,sy-4,8,8,color)
		end
	end
end

function getActivePosMarker()
	return active_pos_marker
end
