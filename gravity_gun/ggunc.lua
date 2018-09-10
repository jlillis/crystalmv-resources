push_button = "1"

localPlayer = getLocalPlayer()

bindKey("fire","down",function()
	if not getControlState("aim_weapon") then return end
	local ggun_obj = getElementData(localPlayer,"ggun_taken")
	if not ggun_obj then
		return
	elseif getKeyState(push_button) then
		if not isElement(ggun_obj) then ggun_obj = getPedTarget(localPlayer) end
		if not ggun_obj then return end
		local x1,y1,z1 = getElementPosition(localPlayer)
		local x2,y2,z2 = getElementPosition(ggun_obj)
		x2,y2,z2 = x2-x1,y2-y1,z2-z1
		local spd = 1/math.sqrt(x2*x2+y2*y2+z2*z2)
		x2,y2,z2 = x2*spd,y2*spd,z2*spd
		triggerServerEvent("ggun_push",ggun_obj,x2,y2,z2)
	else
		if not isElement(ggun_obj) then
			local target = getPedTarget(localPlayer)
			if target and getElementType(target) ~= "object" then
				triggerServerEvent("ggun_take",target)
			end
		else
			triggerServerEvent("ggun_drop",root)
		end
	end
end)

bindKey("aim_weapon","up",function()
	if isElement(getElementData(localPlayer,"ggun_taken")) then
		triggerServerEvent("ggun_drop",root)
	end
end)

addEventHandler("onClientPreRender",root,function()
	local all_players = getElementsByType("player")
	for plnum,player in ipairs(all_players) do
		local taken = getElementData(player,"ggun_taken")
		if isElement(taken) then
			local x1,y1,z1 = getPedTargetStart(player)
			local x2,y2,z2 = getPedTargetEnd(player)
			x2,y2,z2 = x2-x1,y2-y1,z2-z1
			local dist = 5/math.sqrt(x2*x2+y2*y2+z2*z2)
			x2,y2,z2 = x2*dist,y2*dist,z2*dist
			local fx,fy,fz = x1+x2,y1+y2,z1+z2
			local cx,cy,cz = getElementPosition(taken)
			x2,y2,z2 = fx-cx,fy-cy,fz-cz
			local spd = math.min(0.05*math.sqrt(x2*x2+y2*y2+z2*z2),0.1)
			x2,y2,z2 = x2*spd,y2*spd,z2*spd
			setElementVelocity(taken,x2,y2,z2)
		end
	end
end)