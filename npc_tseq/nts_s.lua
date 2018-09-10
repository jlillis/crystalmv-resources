function initNPCTaskSequencer()
	initTaskSequences()
	initPositionMarkers()
	initNPCs()
	initSequenceEditor()
	initPositionMarkerEditor()
	initNPCEditor()

	addEvent("npc_tseq:onPlayerRequestSeqAndNPCInfo",true)
	addEventHandler("npc_tseq:onPlayerRequestSeqAndNPCInfo",root,sendPlayerSeqAndNPCInfo)

	addCommandHandler("loadnts",loadNTSData)
	addCommandHandler("savents",saveNTSData)
end
addEventHandler("onResourceStart",resourceRoot,initNPCTaskSequencer)

function sendPlayerSeqAndNPCInfo()
	sendPlayerSequencesInfo(source)
	sendPlayerNPCsInfo(source)
end

function loadNTSData()
	loadPositionMarkers()
	loadTaskSequences()
end

function saveNTSData()
	savePositionMarkers()
	saveTaskSequences()
end
