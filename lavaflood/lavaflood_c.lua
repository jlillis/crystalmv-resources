script_clientside = true

function initLavaFlood()
	local sw,sh = guiGetScreenSize()
	local multx,multy = sw/1024,sh/768
	setHeatHaze(128,0,12*multy,18*multy,65*multx,80*multy,80*multx,95*multy,true)

	addEvent("lavaflood:updateWaterLevel",true)
	addEventHandler("lavaflood:updateWaterLevel",root,updateLastWaterLevel)
	setTime(12,0)
	setTimer(healOverTime,500,0)
	setTimer(burnInWater,50,0)
	setTimer(createRandomFires,50,0)
	w1 = createWater(-3000,-3000,0,0,-3000,0,-3000,0,0,0,0,0)
	w2 = createWater(0,-3000,0,3000,-3000,0,0,0,0,3000,0,0)
	w3 = createWater(-3000,0,0,0,0,0,-3000,3000,0,0,3000,0)
	w4 = createWater(0,0,0,3000,0,0,0,3000,0,3000,3000,0)
	updateLastWaterLevel(0)
	addEventHandler("onClientPreRender",root,raiseWater)
end
addEventHandler("onClientResourceStart",resourceRoot,initLavaFlood)

function healOverTime()
	local health = getElementHealth(localPlayer)
	if health < 1 then return end
	setElementHealth(localPlayer,getElementHealth(localPlayer)+2)
end
function burnInWater()
	if isLocalPlayerInWater(localPlayer) then
		local health = getElementHealth(localPlayer)
		if health < 1 then return end
		setElementHealth(localPlayer,getElementHealth(localPlayer)-6)
		setPedOnFire(localPlayer,true)
	end
end

function isLocalPlayerInWater()
	for bone = 1,8 do if isBoneInWater(bone) then return true end end
	for bone = 1,6 do if isBoneInWater(20+bone) or isBoneInWater(30+bone) then return true end end
	for bone = 1,4 do if isBoneInWater(40+bone) or isBoneInWater(50+bone) then return true end end
	return false
end

function isBoneInWater(bone)
	local x,y,z = getPedBonePosition(localPlayer,bone)
	return getWaterLevel(w1) > z
end

function createRandomFires()
	local cx,cy = getCameraMatrix()
	local wz = getWaterLevel(w1)
	local x1,y1,z1 = math.random()*100-50+cx,math.random()*100-50+cy,math.random()*2-1+wz
	local x2,y2,z2 = math.random()*100-50+cx,math.random()*100-50+cy,math.random()*2-1+wz
	local hit,x,y,z = processLineOfSight(x1,y1,z1,x2,y2,z2,true,true,true,true)
	if hit then
		createFire(x,y,z,1+math.random()*4)
	end
end

function updateLastWaterLevel(level)
	last_update_time = getTickCount()
	last_update_level = level
end

function raiseWater(timeslice)
	local time_diff = getTickCount()-last_update_time
	local level = last_update_level+time_diff*getLavaRiseSpeed()
	setWaterLevel(w1,level)
	setWaterLevel(w2,level)
	setWaterLevel(w3,level)
	setWaterLevel(w4,level)
end

function getLavaRiseSpeed()
	return getElementData(resourceRoot,"risespeed")
end

