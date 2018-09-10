function initPositionMarkers()
	pos_marker_root = createElement("npc_tseq:data","npc_tseq:pos_marker_root")
end

function createPositionMarker(x,y,z)
	local posmarker = createElement("posmarker")
	setElementPosition(posmarker,x,y,z)
	setElementParent(posmarker,pos_marker_root)
	return posmarker
end
