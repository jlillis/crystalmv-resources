function initNPCTaskSequencer()
	initTaskSequences()
	initPositionMarkers()
	initNPCs()
	initSequenceEditor()
	initPositionMarkerEditor()
	initNPCEditor()

	bindKey("mouse2","both",toggleMouseLook)

	triggerServerEvent("npc_tseq:onPlayerRequestSeqAndNPCInfo",root)
end
addEventHandler("onClientResourceStart",resourceRoot,initNPCTaskSequencer)

function toggleMouseLook()
	if
		isSequenceListWindowVisible() or
		isSequenceWindowVisible() or
		isPositionMarkerWindowVisible() or
		isNPCListWindowVisible()
	then
		showCursor(not isCursorShowing())
	end
end

function updateCursorVisibility()
	showCursor(
		isSequenceListWindowVisible() or
		isSequenceWindowVisible() or
		isPositionMarkerWindowVisible() or
		isNPCListWindowVisible()
	)
end

function isPositionOnWindow(window,x,y)
	local wx,wy = guiGetPosition(window,false)
	local ww,wh = guiGetSize(window,false)
	return x >= wx and y >= wy and x < wx+ww and y < wy+wh
end

function isPositionOnAnyWindow(x,y)
	local all_windows = getElementsByType("gui-window")
	for wnum,window in ipairs(all_windows) do
		if guiGetVisible(window) and isPositionOnWindow(window,x,y) then
			return true
		end
	end
	return false
end

function getMouseWorldPosition()
	local sx,sy = getCursorPosition()
	if not sx then return end
	local sw,sh = guiGetScreenSize()
	sx,sy = sx*sw,sy*sh
	local cx,cy,cz = getCameraMatrix()
	local x,y,z = getWorldFromScreenPosition(sx,sy,1000)
	local hit,hitx,hity,hitz = processLineOfSight(cx,cy,cz,x,y,z)
	if not hit then
		local w,wx,wy,wz = testLineAgainstWater(cx,cy,cz,x,y,z)
		return wx,wy,wz
	else
		local w,wx,wy,wz = testLineAgainstWater(cx,cy,cz,hitx,hity,hitz)
		if w then
			return wx,wy,wz
		else
			return hitx,hity,hitz
		end
	end
end
