function initNPCEditor()
	addEvent("npc_tseq:onNPCCreate",true)
	addEvent("npc_tseq:onNPCDestroy",true)
	addEvent("npc_tseq:onNPCModify",true)
	addEvent("npc_tseq:onNPCAssignSequence",true)
	addEvent("npc_tseq:onNPCStartSequence",true)

	addEventHandler("npc_tseq:onNPCCreate",root,createNPCInEditor)
	addEventHandler("npc_tseq:onNPCDestroy",root,destroyNPCInEditor)
	addEventHandler("npc_tseq:onNPCModify",root,modifyNPCInEditor)
	addEventHandler("npc_tseq:onNPCAssignSequence",root,assignNPCSequenceInEditor)
	addEventHandler("npc_tseq:onNPCStartSequence",root,startNPCSequenceInEditor)
end

function createNPCInEditor(name,skin,veh,x,y,z,a,wspeed,acc,drspeed,weapon,rep)
	createNPC(name,skin,veh,x,y,z,a,wspeed,acc,drspeed,weapon,rep)
end

function destroyNPCInEditor()
	if not isElement(source) then return end
	destroyElement(source)
end

function modifyNPCInEditor(name,skin,veh,wspeed,acc,drspeed,weapon,rep)
	modifyNPC(source,name,skin,veh,wspeed,acc,drspeed,weapon,rep)
end

function assignNPCSequenceInEditor(seqid)
	assignTaskSequenceToNPC(source,seqid)
end

function startNPCSequenceInEditor()
	startTaskSequenceForNPC(source)
end
