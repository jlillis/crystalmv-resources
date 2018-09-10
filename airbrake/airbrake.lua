function putPlayerInPosition(timeslice)
	local cx,cy,cz,ctx,cty,ctz = getCameraMatrix()
	ctx,cty = ctx-cx,cty-cy
	timeslice = timeslice*0.1
	if getKeyState("num_7") then timeslice = timeslice*4 end
	if getKeyState("num_9") then timeslice = timeslice*0.25 end
	local mult = timeslice/math.sqrt(ctx*ctx+cty*cty)
	ctx,cty = ctx*mult,cty*mult
	if getKeyState("num_8") then abx,aby = abx+ctx,aby+cty end
	if getKeyState("num_2") then abx,aby = abx-ctx,aby-cty end
	if getKeyState("num_6") then abx,aby = abx+cty,aby-ctx end
	if getKeyState("num_4") then abx,aby = abx-cty,aby+ctx end
	if getKeyState("num_add") then abz = abz+timeslice end
	if getKeyState("num_sub") then abz = abz-timeslice end
	setElementPosition(localPlayer,abx,aby,abz)
end

function toggleAirBrake()
	air_brake = not air_brake or nil
	if air_brake then
		abx,aby,abz = getElementPosition(localPlayer)
		addEventHandler("onClientPreRender",root,putPlayerInPosition)
	else
		abx,aby,abz = nil
		removeEventHandler("onClientPreRender",root,putPlayerInPosition)
	end
end

bindKey("num_0","down",toggleAirBrake)

