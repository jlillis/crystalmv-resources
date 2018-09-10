function initPositionMarkerEditor()
	createPosMarkerWindow()

	addCommandHandler("positions",function()
		setPositionMarkerWindowVisible(not isPositionMarkerWindowVisible())
	end)
end

----------------------------------------------------

function createPosMarkerWindow()
	local sw,sh = guiGetScreenSize()
	sw = sw*0.5
	pm_window = guiCreateWindow(sw-144,sh-80,296,56,"Position Markers",false)
	pm_create  = guiCreateButton(8,24,64,24,"Create",false,pm_window)
	pm_move    = guiCreateButton(80,24,64,24,"Move",false,pm_window)
	pm_destroy = guiCreateButton(152,24,64,24,"Remove",false,pm_window)
	pm_close   = guiCreateButton(224,24,64,24,"Close",false,pm_window)

	addEventHandler("onClientGUISize",pm_window,resizePosMarkerWindow,false)
	
	addEventHandler("onClientGUIClick",pm_window,clickChangePosMarkerEditorMode)
	addEventHandler("onClientGUIClick",pm_close,clickClosePosMarkerEditor,false)

	pm_mode = "none"

	guiSetVisible(pm_window,false)
end

function resizePosMarkerWindow()
	resizePosMarkerWindowElement(pm_create,8,24,64,24)
	resizePosMarkerWindowElement(pm_move,80,24,64,24)
	resizePosMarkerWindowElement(pm_destroy,152,24,64,24)
	resizePosMarkerWindowElement(pm_close,224,24,64,24)
end

function resizePosMarkerWindowElement(element,x,y,w,h)
	local ww,wh = guiGetSize(pm_window,false)
	guiSetPosition(element,x*ww/296,20+(y-20)*(wh-20)/(56-20),false)
	guiSetSize(element,w*ww/296,h*(wh-20)/(56-20),false)
end

function setPosMarkerEditorMode(mode)
	if pm_mode == mode then mode = "none" end
	local prev_button,this_button
	if pm_mode == "create" then
		prev_button = pm_create
	elseif pm_mode == "move" then
		prev_button = pm_move
	elseif pm_mode == "destroy" then
		prev_button = pm_destroy
	end
	if mode == "create" then
		this_button = pm_create
	elseif mode == "move" then
		this_button = pm_move
	elseif mode == "destroy" then
		this_button = pm_destroy
	end
	if prev_button then
		guiSetProperty(prev_button,"NormalTextColour","FFAAAAAA")
		guiSetProperty(prev_button,"HoverTextColour","FFAAAAFF")
		guiSetProperty(prev_button,"PushedTextColour","FFFFFFFF")
	end
	if this_button then
		guiSetProperty(this_button,"NormalTextColour","FF00C000")
		guiSetProperty(this_button,"HoverTextColour","FF00C0C0")
		guiSetProperty(this_button,"PushedTextColour","FF00FF00")
	end
	if pm_mode == "none" then
		startPosMarkerSearch()
		addEventHandler("onClientClick",root,doPositionMarkerActionOnWorldClick)
	end
	if mode == "none" then
		stopPosMarkerSearch()
		removeEventHandler("onClientClick",root,doPositionMarkerActionOnWorldClick)
		moved_marker = nil
	end
	pm_mode = mode
end

function setPositionMarkerWindowVisible(visible)
	if type(visible) ~= "boolean" then return end
	if not visible then
		setPosMarkerEditorMode("none")
	end
	guiSetVisible(pm_window,visible)
	updateCursorVisibility()
end

function isPositionMarkerWindowVisible()
	return guiGetVisible(pm_window)
end

----------------------------------------------------

function clickChangePosMarkerEditorMode(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if source == pm_create then
		setPosMarkerEditorMode("create")
	elseif source == pm_move then
		setPosMarkerEditorMode("move")
	elseif source == pm_destroy then
		setPosMarkerEditorMode("destroy")
	end
end

function clickClosePosMarkerEditor(button,state,x,y)
	setPositionMarkerWindowVisible(false)
end

----------------------------------------------------

function doPositionMarkerActionOnWorldClick(button,state,sx,sy,x,y,z,element)
	if button ~= "left" then return end
	if not arePosMarkersVisible() then return end
	if pm_mode == "move" then
		if state == "down" then
			if moved_marker then return end
			if isPositionOnAnyWindow(sx,sy) then return end
			moved_marker = getActivePosMarker()
			addEventHandler("onClientPreRender",root,moveMarkerToCursor)
		else
			local mx,my,mz = getMouseWorldPosition()
			if not mx then return end
			if isElement(moved_marker) then
				triggerServerEvent("npc_tseq:onPositionMarkerMove",moved_marker,mx,my,mz)
				removeEventHandler("onClientPreRender",root,moveMarkerToCursor)
				moved_marker = nil
			end
		end
	elseif pm_mode == "create" then
		if state ~= "down" then return end
		if isPositionOnAnyWindow(sx,sy) then return end
		local mx,my,mz = getMouseWorldPosition()
		if not mx then return end
		triggerServerEvent("npc_tseq:onPositionMarkerCreate",root,mx,my,mz)
	elseif pm_mode == "destroy" then
		if state ~= "down" then return end
		if isPositionOnAnyWindow(sx,sy) then return end
		local marker = getActivePosMarker()
		if not isElement(marker) then return end
		triggerServerEvent("npc_tseq:onPositionMarkerDestroy",marker)
	end
end

function moveMarkerToCursor()
	if not isElement(moved_marker) then
		removeEventHandler("onClientPreRender",root,moveMarkerToCursor)
		return
	end
	local sw,sh = guiGetScreenSize()
	local x,y,z = getMouseWorldPosition()
	if not x then return end
	setElementPosition(moved_marker,x,y,z)
end
