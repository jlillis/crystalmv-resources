function initNPCs()
	npc_id = {}
	npcs = {}

	npc_name = {}
	npc_skin = {}
	npc_veh = {}
	npc_wspeed = {}
	npc_acc = {}
	npc_drspeed = {}
	npc_weapon = {}
	npc_repeat = {}

	addEvent("npc_tseq:onClientNPCCreate",true)
	addEvent("npc_tseq:onClientNPCModify",true)
	addEvent("npc_tseq:onClientNPCAssignSequence",true)

	addEventHandler("npc_tseq:onClientNPCCreate",root,createNPC)
	addEventHandler("npc_tseq:onClientNPCModify",root,modifyNPC)
end

function createNPC(id,name,skin,veh,wspeed,acc,drspeed,weapon,rep)
	npc_id[source] = id
	npcs       [id] = source
	npc_name   [id] = name
	npc_skin   [id] = skin
	npc_veh    [id] = veh
	npc_wspeed [id] = wspeed
	npc_acc    [id] = acc
	npc_drspeed[id] = drspeed
	npc_weapon [id] = weapon
	npc_repeat [id] = rep
	addEventHandler("onClientElementDestroy",source,destroyNPC,false)
end

function destroyNPC()
	local id = npc_id[source]
	removeNPCFromNPCList(id)
	npc_id[source] = nil
	npcs       [id] = nil
	npc_name   [id] = nil
	npc_skin   [id] = nil
	npc_veh    [id] = nil
	npc_wspeed [id] = nil
	npc_acc    [id] = nil
	npc_drspeed[id] = nil
	npc_weapon [id] = nil
	npc_repeat [id] = nil
end

function modifyNPC(name,skin,veh,wspeed,acc,drspeed,weapon,rep)
	local id = npc_id[source]
	npc_name   [id] = name
	npc_skin   [id] = skin
	npc_veh    [id] = veh
	npc_wspeed [id] = wspeed
	npc_acc    [id] = acc
	npc_drspeed[id] = drspeed
	npc_weapon [id] = weapon
	npc_repeat [id] = rep
end
