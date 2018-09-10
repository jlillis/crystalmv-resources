function initPositionMarkerEditor()
	addEvent("npc_tseq:onPositionMarkerCreate",true)
	addEvent("npc_tseq:onPositionMarkerMove",true)
	addEvent("npc_tseq:onPositionMarkerDestroy",true)

	addEventHandler("npc_tseq:onPositionMarkerCreate",pos_marker_root,createPosMarkerInEditor)
	addEventHandler("npc_tseq:onPositionMarkerMove",pos_marker_root,changePosMarkerPositionInEditor)
	addEventHandler("npc_tseq:onPositionMarkerDestroy",pos_marker_root,destroyPosMarkerInEditor)
end

function createPosMarkerInEditor(x,y,z)
	createPositionMarker(x,y,z)
end

function changePosMarkerPositionInEditor(x,y,z)
	setElementPosition(source,x,y,z)
end

function destroyPosMarkerInEditor()
	destroyElement(source)
end
