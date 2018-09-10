function initNPCEditor()
	createNPCListWindow()
	createNPCWindow()

	addCommandHandler("npcs",function()
		setNPCListWindowVisible(not isNPCListWindowVisible())
	end)
end

----------------------------------------------------

function createNPCListWindow()
	local sw,sh = guiGetScreenSize()
	ne_window = guiCreateWindow(sw-424,sh-256,392,224,"NPCs",false)
	ne_npc_list       = guiCreateGridList   (8,88,184,128,false,ne_window)
	ne_npc_list_id    = guiGridListAddColumn(ne_npc_list,"ID",0.2)
	ne_npc_list_name  = guiGridListAddColumn(ne_npc_list,"Name",0.35)
	ne_npc_list_seqid = guiGridListAddColumn(ne_npc_list,"Seq. ID",0.25)
	ne_seq_list       = guiCreateGridList   (200,88,184,128,false,ne_window)
	ne_seq_list_id    = guiGridListAddColumn(ne_seq_list,"ID",0.2)
	ne_seq_list_name  = guiGridListAddColumn(ne_seq_list,"Name",0.6)
	ne_close   = guiCreateButton(8,24,88,24,"Close",false,ne_window)
	ne_create  = guiCreateButton(8,56,88,24,"Create",false,ne_window)
	ne_modify  = guiCreateButton(104,24,88,24,"Modify",false,ne_window)
	ne_get     = guiCreateButton(104,56,88,24,"Get",false,ne_window)
	ne_assign  = guiCreateButton(200,56,88,24,"Assign",false,ne_window)
	ne_start   = guiCreateButton(200,24,88,24,"Start",false,ne_window)
	ne_destroy = guiCreateButton(328,40,56,24,"Destroy",false,ne_window)
	guiGridListSetSortingEnabled(ne_npc_list,false)
	guiGridListSetSortingEnabled(ne_seq_list,false)

	addEventHandler("onClientGUISize",ne_window,resizeNPCListWindow,false)

	addEventHandler("npc_tseq:onClientTaskSequenceCreate",root,addSequenceToNPCList)
	addEventHandler("npc_tseq:onClientTaskSequenceDestroy",root,removeSequenceFromNPCList)
	addEventHandler("npc_tseq:onClientTaskSequenceRename",root,renameSequenceInNPCList)
	addEventHandler("npc_tseq:onClientNPCCreate",root,addNPCToNPCList)
	addEventHandler("npc_tseq:onClientNPCModify",root,renameNPCInNPCList)
	addEventHandler("npc_tseq:onClientNPCAssignSequence",root,setNPCSequenceInNPCList)

	addEventHandler("onClientGUIClick",ne_close,clickCloseNPCWindow,false)
	addEventHandler("onClientGUIClick",ne_create,clickCreateNPC,false)
	addEventHandler("onClientGUIClick",ne_modify,clickModifyNPC,false)
	addEventHandler("onClientGUIClick",ne_get,clickGetNPC,false)
	addEventHandler("onClientGUIClick",ne_assign,clickAssignNPCSequence,false)
	addEventHandler("onClientGUIClick",ne_start,clickStartNPCSequence,false)
	addEventHandler("onClientGUIClick",ne_destroy,clickDestroyNPC,false)

	guiSetVisible(ne_window,false)
end

function resizeNPCListWindow()
	resizeNPCListWindowElement(ne_npc_list,8,88,184,128)
	resizeNPCListWindowElement(ne_seq_list,200,88,184,128)
	resizeNPCListWindowElement(ne_close,8,24,88,24)
	resizeNPCListWindowElement(ne_create,8,56,88,24)
	resizeNPCListWindowElement(ne_modify,104,24,88,24)
	resizeNPCListWindowElement(ne_get,104,56,88,24)
	resizeNPCListWindowElement(ne_assign,200,56,88,24)
	resizeNPCListWindowElement(ne_start,200,24,88,24)
	resizeNPCListWindowElement(ne_destroy,328,40,56,24)
end

function resizeNPCListWindowElement(element,x,y,w,h)
	local ww,wh = guiGetSize(ne_window,false)
	guiSetPosition(element,x*ww/392,20+(y-20)*(wh-20)/(224-20),false)
	guiSetSize(element,w*ww/392,h*(wh-20)/(224-20),false)
end

function setNPCListWindowVisible(visible)
	if type(visible) ~= "boolean" then return end
	setNPCCreatingMode(false)
	guiSetVisible(ne_window,visible)
	guiSetVisible(np_window,visible)
	updateCursorVisibility()
end

function isNPCListWindowVisible()
	return guiGetVisible(ne_window)
end

----------------------------------------------------

function addSequenceToNPCList(id,name)
	local new_row = guiGridListAddRow(ne_seq_list)
	guiGridListSetItemText(ne_seq_list,new_row,ne_seq_list_id,tostring(id),false,true)
	guiGridListSetItemText(ne_seq_list,new_row,ne_seq_list_name,name,false,false)
end

function removeSequenceFromNPCList(id)
	local row = getSequenceRowInNPCList(id)
	if not row then return end
	guiGridListRemoveRow(ne_seq_list,row)
end

function renameSequenceInNPCList(id,name)
	local row = getSequenceRowInNPCList(id)
	if not row then return end
	guiGridListSetItemText(ne_seq_list,row,ne_seq_list_name,name,false,false)
end

function addNPCToNPCList(id,name)
	local new_row = guiGridListAddRow(ne_npc_list)
	guiGridListSetItemText(ne_npc_list,new_row,ne_npc_list_id,tostring(id),false,true)
	guiGridListSetItemText(ne_npc_list,new_row,ne_npc_list_name,name,false,false)
	guiGridListSetItemText(ne_npc_list,new_row,ne_npc_list_seqid,"",false,false)
end

function removeNPCFromNPCList(id)
	local row = getNPCRowInNPCList(id)
	if not row then return end
	guiGridListRemoveRow(ne_npc_list,row)
end

function renameNPCInNPCList(name)
	local row = getNPCRowInNPCList(npc_id[source])
	if not row then return end
	guiGridListSetItemText(ne_npc_list,row,ne_npc_list_name,name,false,false)
end

function setNPCSequenceInNPCList(seqid)
	local row = getNPCRowInNPCList(npc_id[source])
	if not row then return end
	guiGridListSetItemText(ne_npc_list,row,ne_npc_list_seqid,seqid and tostring(seqid) or "",false,true)
end

function getSequenceRowInNPCList(id)
	local count = guiGridListGetRowCount(ne_seq_list)
	for row = 0,count-1 do
		local this_id = tonumber(guiGridListGetItemText(ne_seq_list,row,ne_seq_list_id))
		if this_id == id then
			return row
		end
	end
	return false
end

function getNPCRowInNPCList(id)
	local count = guiGridListGetRowCount(ne_npc_list)
	for row = 0,count-1 do
		local this_id = tonumber(guiGridListGetItemText(ne_npc_list,row,ne_npc_list_id))
		if this_id == id then
			return row
		end
	end
	return false
end

----------------------------------------------------

function clickCloseNPCWindow(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCListWindowVisible(false)
end

function clickCreateNPC(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCCreatingMode(not getNPCCreatingMode())
end

function clickModifyNPC(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCCreatingMode(false)
	local name,skin,veh,wspeed,acc,drspeed,weapon,rep = getNPCWindowData()
	if not name then return end
	local selnpcs = getSelectedNPCsInNPCList()
	for npcnum,npc in pairs(selnpcs) do
		triggerServerEvent("npc_tseq:onNPCModify",npc,name,skin,veh,wspeed,acc,drspeed,weapon,rep)
	end
end

function clickGetNPC(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCCreatingMode(false)
	local npc = getSelectedNPCsInNPCList()[1]
	if not npc then return end
	local id = npc_id[npc]
	setNPCWindowData(npc_name[id],npc_skin[id],npc_veh[id],npc_wspeed[id],npc_acc[id],npc_drspeed[id],npc_weapon[id],npc_repeat[id])
end

function clickAssignNPCSequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCCreatingMode(false)
	local selseq = getSelectedSequenceInNPCList()
	if not selseq then return end
	local selnpcs = getSelectedNPCsInNPCList()
	for npcnum,npc in pairs(selnpcs) do
		triggerServerEvent("npc_tseq:onNPCAssignSequence",npc,selseq)
	end
end

function clickStartNPCSequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCCreatingMode(false)
	local selnpcs = getSelectedNPCsInNPCList()
	for npcnum,npc in pairs(selnpcs) do
		triggerServerEvent("npc_tseq:onNPCStartSequence",npc)
	end
end

function clickDestroyNPC(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setNPCCreatingMode(false)
	local selnpcs = getSelectedNPCsInNPCList()
	for npcnum,npc in pairs(selnpcs) do
		triggerServerEvent("npc_tseq:onNPCDestroy",npc)
	end
end

function getSelectedNPCsInNPCList()
	local selnpcs = {}
	local selitems = guiGridListGetSelectedItems(ne_npc_list)
	for itemnum,item in pairs(selitems) do
		if item.column ~= ne_npc_list_id then
			table.insert(selnpcs,
				npcs[tonumber(guiGridListGetItemText(ne_npc_list,item.row,ne_npc_list_id))]
			)
		end
	end
	return selnpcs
end

function getSelectedSequenceInNPCList()
	local row,col = guiGridListGetSelectedItem(ne_seq_list)
	if not row == -1 then return end
	return tonumber(guiGridListGetItemText(ne_seq_list,row,ne_seq_list_id))
end

----------------------------------------------------

function setNPCCreatingMode(enabled)
	enabled = enabled or nil
	if npc_create_mode == enabled then return end
	npc_create_mode = enabled
	if enabled then
		guiSetProperty(ne_create,"NormalTextColour","FF00C000")
		guiSetProperty(ne_create,"HoverTextColour","FF00C0C0")
		guiSetProperty(ne_create,"PushedTextColour","FF00FF00")
		addEventHandler("onClientClick",root,createNPCOnWorldClick)
	else
		guiSetProperty(ne_create,"NormalTextColour","FFAAAAAA")
		guiSetProperty(ne_create,"HoverTextColour","FFAAAAFF")
		guiSetProperty(ne_create,"PushedTextColour","FFFFFFFF")
		removeEventHandler("onClientClick",root,createNPCOnWorldClick)
	end
end

function getNPCCreatingMode()
	return npc_create_mode
end

function createNPCOnWorldClick(button,state,sx,sy,x,y,z,element)
	if button ~= "left" then return end
	if isPositionOnAnyWindow(sx,sy) then return end
	x,y,z = getMouseWorldPosition()
	if not x then return end
	if state == "down" then
		npc_create_x,npc_create_y,npc_create_z = x,y,z
		return
	end
	if state == "up" and npc_create_x then
		local name,skin,vehicle,wspeed,acc,drspeed,weapon,rep = getNPCWindowData()
		if not name then return end
		local a = -math.deg(math.atan2(x-npc_create_x,y-npc_create_y))
		triggerServerEvent("npc_tseq:onNPCCreate",root,
			name,skin,vehicle,
			npc_create_x,npc_create_y,npc_create_z+1,a,
			wspeed,acc,drspeed,weapon,rep
		)
		npc_create_x,npc_create_y,npc_create_z = nil,nil,nil
	end
end

----------------------------------------------------

function createNPCWindow()
	local sw,sh = guiGetScreenSize()
	np_window = guiCreateWindow(128,sh-312,208,280,"NPC parameters",false)
	guiWindowSetSizable(np_window,false)
	local np_label_name       = guiCreateLabel(8,24,96,24,"Name",false,np_window)
	local np_label_skin       = guiCreateLabel(8,56,96,24,"Skin",false,np_window)
	local np_label_vehicle    = guiCreateLabel(8,88,96,24,"Vehicle",false,np_window)
	local np_label_walkspeed  = guiCreateLabel(8,120,96,24,"Walking speed",false,np_window)
	local np_label_acc        = guiCreateLabel(8,152,96,24,"Weapon accuracy",false,np_window)
	local np_label_drivespeed = guiCreateLabel(8,184,96,24,"Driving speed",false,np_window)
	local np_label_weapon     = guiCreateLabel(8,216,96,24,"Weapon",false,np_window)
	np_edit_name       = guiCreateEdit    (112,24,88,24,"Name",false,np_window)
	np_edit_skin       = guiCreateEdit    (112,56,88,24,"0",false,np_window)
	np_edit_vehicle    = guiCreateEdit    (112,88,88,24,"492",false,np_window)
	np_edit_walkspeed  = guiCreateComboBox(112,120,88,128,"",false,np_window)
	np_edit_acc        = guiCreateEdit    (112,152,88,24,"1",false,np_window)
	np_edit_drivespeed = guiCreateEdit    (112,184,88,24,"40",false,np_window)
	np_edit_weapon     = guiCreateEdit    (112,216,88,24,"0",false,np_window)
	np_edit_repeat     = guiCreateCheckBox(80,248,120,24,"Repeat sequence",false,false,np_window)
	guiComboBoxAddItem(np_edit_walkspeed,"walk")
	guiComboBoxAddItem(np_edit_walkspeed,"run")
	guiComboBoxAddItem(np_edit_walkspeed,"sprint")
	guiComboBoxAddItem(np_edit_walkspeed,"sprintfast")
	guiComboBoxSetSelected(np_edit_walkspeed,0)

	guiSetVisible(np_window,false)
end

function setNPCWindowData(name,skin,veh,wspeed,acc,drspeed,weapon,rep)
	guiSetText(np_edit_name,name)
	guiSetText(np_edit_skin,tostring(skin))
	guiSetText(np_edit_vehicle,tostring(veh))
	guiComboBoxSetSelected(np_edit_walkspeed,wspeed == "run" and 1 or wspeed == "sprint" and 2 or wspeed == "sprintfast" and 3 or 0)
	guiSetText(np_edit_acc,tostring(acc))
	guiSetText(np_edit_drivespeed,tostring(drspeed))
	guiSetText(np_edit_weapon,tostring(weapon))
	guiCheckBoxSetSelected(np_edit_repeat,rep)
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

function getNPCWindowData()
	local name = guiGetText(np_edit_name)
	if name == "" then return end
	local skin = tonumber(guiGetText(np_edit_skin))
	if not skin then return end
	local veh = guiGetText(np_edit_vehicle)
	if veh ~= "" then
		veh = tonumber(veh)
		if not veh then return end
	else
		veh = nil
	end
	local wspeed = guiComboBoxGetItemText(np_edit_walkspeed,guiComboBoxGetSelected(np_edit_walkspeed))
	local acc = tonumber(guiGetText(np_edit_acc))
	if not acc then return end
	local drspeed = tonumber(guiGetText(np_edit_drivespeed))
	if not drspeed then return end
	local weapon = tonumber(guiGetText(np_edit_weapon))
	if not weapon or not valid_weapons[weapon] then return end
	local rep = guiCheckBoxGetSelected(np_edit_repeat)
	return name,skin,veh,wspeed,acc,drspeed,weapon,rep
end
