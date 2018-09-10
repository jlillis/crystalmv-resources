function initNPCs()
	npc_id = {}
	npcs = {}
	npc_name = {}
	npc_drspeed = {}
	npc_repeat = {}
	npc_donetasks = {}
end

valid_weapons =
{
	[0] = true,[1] = true,[2] = true,[3] = true,[4] = true,[5] = true,[6] = true,[7] = true,[8] = true,
	[9] = true,[10] = true,[11] = true,[12] = true,[14] = true,[15] = true,[16] = true,[17] = true,
	[18] = true,[22] = true,[23] = true,[24] = true,[25] = true,[26] = true,[27] = true,[28] = true,
	[29] = true,[30] = true,[31] = true,[32] = true,[33] = true,[34] = true,[35] = true,[36] = true,
	[37] = true,[38] = true,[39] = true,[40] = true,[41] = true,[42] = true,[43] = true,[44] = true,
	[45] = true,[46] = true
}

function createNPC(name,skin,vehmodel,x,y,z,a,wspeed,acc,drspeed,weapon,rep)
	if type(name) ~= "string" then
		outputDebugString("No name specified for new ped",2)
		return
	end
	local npc = createPed(skin,x,y,z,a)
	if not npc then
		outputDebugString("Failed to create the ped",2)
		return
	end
	exports.npc_hlc:enableHLCForNPC(npc,wspeed,acc,drspeed/180)
	if vehmodel then
		local vehicle = createVehicle(vehmodel,x,y,z,0,0,a)
		if not vehicle then
			destroyElement(npc)
			outputDebugString("Failed to create the vehicle",2)
			return
		end
		setElementData(npc,"vehicle",vehicle)
		warpPedIntoVehicle(npc,vehicle)
	end
	setElementParent(createBlipAttachedTo(npc),npc)
	giveWeapon(npc,weapon,9999,true)

	local new_id = #npcs+1
	npc_id[npc] = new_id
	npcs         [new_id] = npc
	npc_name     [new_id] = name
	npc_drspeed  [new_id] = drspeed
	npc_repeat   [new_id] = rep
	npc_donetasks[new_id] = {}
	addEventHandler("onElementDestroy",npc,destroyNPCData,false)
	addEventHandler("npc_hlc:onNPCTaskDone",npc,continueNPCSequence)
	triggerClientEvent("npc_tseq:onClientNPCCreate",npc,new_id,name,skin,vehmodel,wspeed,acc,drspeed,weapon,rep)
	return npc
end

function continueNPCSequence(task)
	local id = npc_id[source]
	table.insert(npc_donetasks[id],task)
	if not npc_repeat[id] then return end
	moveTasksFromQueue(source)
end

function moveTasksFromQueue(npc)
	local id = npc_id[npc]
	for tasknum,thistask in ipairs(npc_donetasks[id]) do
		exports.npc_hlc:addNPCTask(npc,thistask)
	end
	npc_donetasks[id] = {}
end

function destroyNPCData()
	ped_sequences[source] = nil
	local id = npc_id[source]
	npc_id[source] = nil
	npcs         [id] = nil
	npc_name     [id] = nil
	npc_drspeed  [id] = nil
	npc_repeat   [id] = nil
	npc_donetasks[id] = nil
	local vehicle = getElementData(source,"vehicle")
	if vehicle then destroyElement(vehicle) end
end

function modifyNPC(npc,name,skin,veh,wspeed,acc,drspeed,weapon,rep)
	local id = npc_id[npc]
	if not id then
		outputDebugString("Attempt to rename a non-existing ped",2)
		return
	end
	if type(name) ~= "string" then
		outputDebugString("No name specified for the ped",2)
		return
	end
	if wspeed ~= "walk" and wspeed ~= "run" and wspeed ~= "sprint" and wspeed ~= "sprintfast" then
		outputDebugString("Incorrect walking speed specified",2)
		return
	end
	if type(acc) ~= "number" then
		outputDebugString("Incorrect weapon accuracy specified",2)
		return
	end
	if type(drspeed) ~= "number" then
		outputDebugString("Incorrect driving speed specified",2)
		return
	end
	if not valid_weapons[weapon] then
		outputDebugString("Invalid weapon specified",2)
		return
	end
	if type(rep) ~= "boolean" then
		outputDebugString("Incorrect repetition state specified",2)
		return
	end
	
	local vehicle = getElementData(npc,"vehicle")
	if isElement(vehicle) then
		if veh then
			if getElementModel(vehicle) ~= veh and not setElementModel(vehicle,veh) then
				outputDebugString("Invalid vehicle model specified",2)
				return
			end
		else
			destroyElement(vehicle)
			removeElementData(npc,"vehicle")
		end
		vehicle = nil
	elseif veh then
		local x,y,z = getElementPosition(npc)
		local vehicle = createVehicle(veh,x,y,z,0,0,getPedRotation(npc))
		if not vehicle then
			outputDebugString("Failed to create a vehicle",2)
			return
		end
	end

	if getElementModel(npc) ~= skin and not setElementModel(npc,skin) then
		outputDebugString("Incorrect ped model specified",2)
		if vehicle then destroyElement(vehicle) end
		return
	end

	npc_name[id] = name
	exports.npc_hlc:setNPCWalkSpeed(npc,wspeed)
	exports.npc_hlc:setNPCWeaponAccuracy(npc,acc)
	exports.npc_hlc:setNPCDriveSpeed(npc,drspeed/180)
	npc_drspeed[id] = drspeed
	takeAllWeapons(npc)
	giveWeapon(npc,weapon,9999,true)
	npc_repeat[id] = rep
	if rep then moveTasksFromQueue(npc) end
	triggerClientEvent("npc_tseq:onClientNPCModify",npc,name,skin,veh,wspeed,acc,drspeed,weapon,rep)
end

function assignTaskSequenceToNPC(npc,seq)
	if not isElement(npc) then
		outputDebugString("Attempt to assign sequence to non-existing ped",2)
		return
	end
	ped_sequences[npc] = seq
	triggerClientEvent("npc_tseq:onClientNPCAssignSequence",npc,seq)
end

function startTaskSequenceForNPC(npc)
	if not isElement(npc) then
		outputDebugString("Attempt to start sequence for non-existing ped",2)
		return
	end
	local id = ped_sequences[npc]
	if not id then return end
	local seq = task_sequences[id]
	exports.npc_hlc:clearNPCTasks(npc)
	for taskid,task in ipairs(seq) do
		if task[1] ~= "(no action)" then
			exports.npc_hlc:addNPCTask(npc,task)
		end
	end
end

function sendPlayerNPCsInfo(player)
	for id,npc in pairs(npcs) do
		local name = npc_name[id]
		local skin = getElementModel(npc)
		local vehicle = getPedOccupiedVehicle(npc)
		local vehmodel = vehicle and getElementModel(vehicle) or nil
		local wspeed = exports.npc_hlc:getNPCWalkSpeed(npc)
		local acc = exports.npc_hlc:getNPCWeaponAccuracy(npc)
		local drspeed = npc_drspeed[id]
		local weapon = getPedWeapon(npc)
		local rep = npc_repeat[id]
		triggerClientEvent(player,"npc_tseq:onClientNPCCreate",npc,id,name,skin,vehmodel,wspeed,acc,drspeed,weapon,rep)
		local seq = ped_sequences[npc]
		if seq then
			triggerClientEvent(player,"npc_tseq:onClientNPCAssignSequence",npc,seq)
		end
	end
end
