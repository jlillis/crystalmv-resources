function initSequenceEditor()
	createSequenceListWindow()
	createSequenceWindow()
	createTaskWindow()
	initSequenceEditorDrawing()

	addCommandHandler("tasks",function()
		setSequenceListWindowVisible(not isSequenceListWindowVisible())
	end)
end

----------------------------------------------------

function createSequenceListWindow()
	local sw,sh = guiGetScreenSize()
	sw,sh = sw*0.5,sh*0.5
	sl_window  = guiCreateWindow(32,sh-160,192,320,"Task sequences list",false)
	sl_name    = guiCreateEdit  (8,24,88,24,"Name",false,sl_window)
	sl_create  = guiCreateButton(104,24,88,24,"Create",false,sl_window)
	sl_rename  = guiCreateButton(8,56,88,24,"Rename",false,sl_window)
	sl_edit    = guiCreateButton(104,56,88,24,"Edit",false,sl_window)
	sl_destroy = guiCreateButton(8,288,56,24,"Remove",false,sl_window)
	sl_close   = guiCreateButton(104,288,88,24,"Close",false,sl_window)
	sl_list        = guiCreateGridList(8,88,176,192,false,sl_window)
	sl_list_id     = guiGridListAddColumn(sl_list,"ID",0.2)
	sl_list_name   = guiGridListAddColumn(sl_list,"Name",0.4)
	sl_list_length = guiGridListAddColumn(sl_list,"Length",0.2)
	guiGridListSetSortingEnabled(sl_list,false)

	addEventHandler("onClientGUISize",sl_window,resizeSequenceList,false)

	addEventHandler("npc_tseq:onClientTaskSequenceCreate",root,addSequenceToSequenceList)
	addEventHandler("npc_tseq:onClientTaskSequenceDestroy",root,removeSequenceFromSequenceList)
	addEventHandler("npc_tseq:onClientTaskSequenceRename",root,renameSequenceInSequenceList)
	addEventHandler("npc_tseq:onClientTaskSequenceAddTask",root,increateTaskCountInSequenceList)
	addEventHandler("npc_tseq:onClientTaskSequenceRemoveTask",root,decreateTaskCountInSequenceList)

	addEventHandler("onClientGUIClick",sl_create,clickCreateSequence,false)
	addEventHandler("onClientGUIClick",sl_destroy,clickDestroySequence,false)
	addEventHandler("onClientGUIClick",sl_rename,clickRenameSequence,false)
	addEventHandler("onClientGUIClick",sl_edit,clickEditSequence,false)
	addEventHandler("onClientGUIClick",sl_close,clickCloseSequenceList,false)
	addEventHandler("onClientGUIDoubleClick",sl_list,clickEditSequence,false)

	guiSetVisible(sl_window,false)
end

function resizeSequenceList()
	resizeSequenceListElement(sl_name,8,24,88,24)
	resizeSequenceListElement(sl_create,104,24,88,24)
	resizeSequenceListElement(sl_rename,8,56,88,24)
	resizeSequenceListElement(sl_edit,104,56,88,24)
	resizeSequenceListElement(sl_destroy,8,288,56,24)
	resizeSequenceListElement(sl_close,104,288,88,24)
	resizeSequenceListElement(sl_list,8,88,176,192)
end

function resizeSequenceListElement(element,x,y,w,h)
	local ww,wh = guiGetSize(sl_window,false)
	guiSetPosition(element,x*ww/192,20+(y-20)*(wh-20)/(320-20),false)
	guiSetSize(element,w*ww/192,h*(wh-20)/(320-20),false)
end

function setSequenceListWindowVisible(visible)
	if type(visible) ~= "boolean" then return end
	guiSetVisible(sl_window,visible)
	updateCursorVisibility()
end

function isSequenceListWindowVisible()
	return guiGetVisible(sl_window)
end

----------------------------------------------------

function addSequenceToSequenceList(id,name)
	local new_row = guiGridListAddRow(sl_list)
	guiGridListSetItemText(sl_list,new_row,sl_list_id,tostring(id),false,true)
	guiGridListSetItemText(sl_list,new_row,sl_list_name,name,false,false)
	guiGridListSetItemText(sl_list,new_row,sl_list_length,"0",false,true)
end

function removeSequenceFromSequenceList(id)
	local row = getSequenceRow(id)
	if not row then return end
	guiGridListRemoveRow(sl_list,row)
end

function renameSequenceInSequenceList(id,name)
	local row = getSequenceRow(id)
	if not row then return end
	guiGridListSetItemText(sl_list,row,sl_list_name,name,false,false)
end

function increateTaskCountInSequenceList(id,taskid,task)
	local row = getSequenceRow(id)
	if not row then return end
	local taskcount = tonumber(guiGridListGetItemText(sl_list,row,sl_list_length))
	taskcount = taskcount+1
	guiGridListSetItemText(sl_list,row,sl_list_length,tostring(taskcount),false,true)
end

function decreateTaskCountInSequenceList(id,taskid)
	local row = getSequenceRow(id)
	if not row then return end
	local taskcount = tonumber(guiGridListGetItemText(sl_list,row,sl_list_length))
	taskcount = taskcount-1
	guiGridListSetItemText(sl_list,row,sl_list_length,tostring(taskcount),false,true)
end

function getSequenceRow(id)
	local count = guiGridListGetRowCount(sl_list)
	for row = 0,count-1 do
		local this_id = tonumber(guiGridListGetItemText(sl_list,row,sl_list_id))
		if this_id == id then
			return row
		end
	end
	return false
end

----------------------------------------------------

function getSelectedSequence()
	local row,col = guiGridListGetSelectedItem(sl_list)
	if not row then return false end
	return tonumber(guiGridListGetItemText(sl_list,row,sl_list_id))
end

----------------------------------------------------

function clickCreateSequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	local name = guiGetText(sl_name)
	if name == "" then return end
	triggerServerEvent("npc_tseq:onTaskSequenceCreate",root,name)
end

function clickDestroySequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	local id = getSelectedSequence()
	if not id then return end
	triggerServerEvent("npc_tseq:onTaskSequenceDestroy",root,id)
end

function clickRenameSequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	local name = guiGetText(sl_name)
	if name == "" then return end
	local id = getSelectedSequence()
	if not id then return end
	triggerServerEvent("npc_tseq:onTaskSequenceRename",root,id,name)
end

function clickEditSequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	showSequenceInSequenceEditor(getSelectedSequence())
	setSequenceWindowVisible(true)
end

function clickCloseSequenceList(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setSequenceListWindowVisible(false)
end

----------------------------------------------------

function clearTasksFromSequenceEditor()
	local count = guiGridListGetRowCount(se_list)
	for row = 1,count do
		guiGridListRemoveRow(se_list,0)
	end
end

function showSequenceInSequenceEditor(seqid)
	if se_seqid == seqid then return end
	se_seqid = seqid
	guiSetText(se_seqid_text,"Seq. ID: "..(seqid or "-"))
	clearTasksFromSequenceEditor()
	if not seqid then return end
	local sequence = task_sequences[seqid]
	for taskid,task in ipairs(sequence) do
		local new_row = guiGridListAddRow(se_list)
		guiGridListSetItemText(se_list,new_row,se_list_id,tostring(taskid),false,true)
		guiGridListSetItemText(se_list,new_row,se_list_task,task[1],false,false)
	end
end

function createSequenceWindow()
	local sw,sh = guiGetScreenSize()
	sw,sh = sw*0.5,sh*0.5
	se_window = guiCreateWindow(232,sh-160,192,320,"Task sequence editor",false)
	se_seqid_text = guiCreateLabel(104,24,88,24,"Seq. ID: -",false,se_window)
	guiLabelSetVerticalAlign(se_seqid_text,"center")
	guiLabelSetHorizontalAlign(se_seqid_text,"center")
	se_create   = guiCreateButton(8,24,88,24,"Add",false,se_window)
	se_modify   = guiCreateButton(8,56,88,24,"Modify",false,se_window)
	se_get      = guiCreateButton(8,88,88,24,"Get",false,se_window)
	se_moveup   = guiCreateButton(104,56,88,24,"Move up",false,se_window)
	se_movedown = guiCreateButton(104,88,88,24,"Move down",false,se_window)
	se_destroy  = guiCreateButton(8,288,56,24,"Remove",false,se_window)
	se_close    = guiCreateButton(104,288,88,24,"Close",false,se_window)
	se_list      = guiCreateGridList(8,120,176,160,false,se_window)
	se_list_id   = guiGridListAddColumn(se_list,"ID",0.2)
	se_list_task = guiGridListAddColumn(se_list,"Task",0.65)
	guiGridListSetSortingEnabled(se_list,false)

	addEventHandler("onClientGUISize",se_window,resizeSequenceEditor,false)

	addEventHandler("npc_tseq:onClientTaskSequenceDestroy",root,showNoSequenceInSequenceEditor)
	addEventHandler("npc_tseq:onClientTaskSequenceAddTask",root,addTaskToSequenceEditor)
	addEventHandler("npc_tseq:onClientTaskSequenceRemoveTask",root,removeTaskFromSequenceEditor)
	addEventHandler("npc_tseq:onClientTaskSequenceEditTask",root,editTaskInSequenceEditor)
	addEventHandler("npc_tseq:onClientTaskSequenceSwapTasks",root,swapTasksInSequenceEditor)
	
	addEventHandler("onClientGUIClick",se_create,clickCreateTask,false)
	addEventHandler("onClientGUIClick",se_modify,clickModifyTask,false)
	addEventHandler("onClientGUIClick",se_destroy,clickRemoveTask,false)
	addEventHandler("onClientGUIClick",se_get,clickGetTask,false)
	addEventHandler("onClientGUIClick",se_moveup,clickMoveUpTask,false)
	addEventHandler("onClientGUIClick",se_movedown,clickMoveDownTask,false)
	addEventHandler("onClientGUIClick",se_close,clickCloseSequence,false)

	guiSetVisible(se_window,false)
end

function resizeSequenceEditor()
	resizeSequenceEditorElement(se_create,8,24,88,24)
	resizeSequenceEditorElement(se_seqid_text,104,24,88,24)
	resizeSequenceEditorElement(se_modify,8,56,88,24)
	resizeSequenceEditorElement(se_get,8,88,88,24)
	resizeSequenceEditorElement(se_moveup,104,56,88,24)
	resizeSequenceEditorElement(se_movedown,104,88,88,24)
	resizeSequenceEditorElement(se_destroy,8,288,56,24)
	resizeSequenceEditorElement(se_close,104,288,88,24)
	resizeSequenceEditorElement(se_list,8,120,176,160)
end

function resizeSequenceEditorElement(element,x,y,w,h)
	local ww,wh = guiGetSize(se_window,false)
	guiSetPosition(element,x*ww/192,20+(y-20)*(wh-20)/(320-20),false)
	guiSetSize(element,w*ww/192,h*(wh-20)/(320-20),false)
end

function setSequenceWindowVisible(visible)
	if type(visible) ~= "boolean" then return end
	if isSequenceWindowVisible() == visible then return end
	guiSetVisible(se_window,visible)
	setTaskWindowVisible(visible)
	updateCursorVisibility()
end

function isSequenceWindowVisible()
	return guiGetVisible(se_window)
end

----------------------------------------------------

function showNoSequenceInSequenceEditor(id)
	if id ~= se_seqid then return end
	showSequenceInSequenceEditor()
end

function addTaskToSequenceEditor(id,taskid,task)
	if id ~= se_seqid then return end
	local row = guiGridListInsertRowAfter(se_list,taskid-2)
	guiGridListSetItemText(se_list,row,se_list_id,tostring(taskid),false,true)
	guiGridListSetItemText(se_list,row,se_list_task,task[1],false,false)
	local count = guiGridListGetRowCount(se_list)
	for this_row = row+1,count-1 do
		local this_id = tonumber(guiGridListGetItemText(se_list,this_row,se_list_id))+1
		guiGridListSetItemText(se_list,this_row,se_list_id,tostring(this_id),false,true)
	end
end

function removeTaskFromSequenceEditor(id,taskid)
	if id ~= se_seqid then return end
	guiGridListRemoveRow(se_list,taskid-1)
	local count = guiGridListGetRowCount(se_list)
	for this_row = taskid-1,count-1 do
		local this_id = tonumber(guiGridListGetItemText(se_list,this_row,se_list_id))-1
		guiGridListSetItemText(se_list,this_row,se_list_id,tostring(this_id),false,true)
	end
end

function editTaskInSequenceEditor(id,taskid,task)
	if id ~= se_seqid then return end
	guiGridListSetItemText(se_list,taskid-1,se_list_task,task[1],false,false)
end

function swapTasksInSequenceEditor(id,taskid1,taskid2)
	if id ~= se_seqid then return end
	local row1,row2 = taskid1-1,taskid2-1

	local task1 = guiGridListGetItemText(se_list,row1,se_list_task)
	local task2 = guiGridListGetItemText(se_list,row2,se_list_task)
	guiGridListSetItemText(se_list,row1,se_list_task,task2,false,false)
	guiGridListSetItemText(se_list,row2,se_list_task,task1,false,false)

	local taskid = getSelectedTask()
	local sel1,sel2 = taskid == taskid1,taskid == taskid2
	local row = sel1 and row2 or sel2 and row1
	if row then
		guiGridListSetSelectedItem(se_list,row,1)
	end
end

----------------------------------------------------

function getSelectedTask()
	local row,col = guiGridListGetSelectedItem(se_list)
	return tonumber(guiGridListGetItemText(se_list,row,se_list_id))
end

----------------------------------------------------

function clickCreateTask(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if not se_seqid then return end
	local taskid = getSelectedTask()
	if taskid then
		triggerServerEvent("npc_tseq:onTaskSequenceAddTask",root,se_seqid,taskid,{"(no action)"})
	else
		triggerServerEvent("npc_tseq:onTaskSequenceAddTask",root,se_seqid,{"(no action)"})
	end
end

function clickModifyTask(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if not se_seqid then return end
	local taskid = getSelectedTask()
	if not taskid then return end
	local newtask = getTaskEditorTask()
	if not newtask then return end
	triggerServerEvent("npc_tseq:onTaskSequenceEditTask",root,se_seqid,taskid,newtask)
end

function clickRemoveTask(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if not se_seqid then return end
	local taskid = getSelectedTask()
	if not taskid then return end
	triggerServerEvent("npc_tseq:onTaskSequenceRemoveTask",root,se_seqid,taskid)
end

function clickGetTask(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if not se_seqid then return end
	local taskid = getSelectedTask()
	if not taskid then return end
	setTaskEditorTask(task_sequences[se_seqid][taskid])
end

function clickMoveUpTask(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if not se_seqid then return end
	local taskid1 = getSelectedTask()
	if not taskid1 then return end
	local taskid2 = taskid1-1
	if not task_sequences[se_seqid][taskid2] then return end
	triggerServerEvent("npc_tseq:onTaskSequenceSwapTasks",root,se_seqid,taskid1,taskid2)
end

function clickMoveDownTask(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	if not se_seqid then return end
	local taskid1 = getSelectedTask()
	if not taskid1 then return end
	local taskid2 = taskid1+1
	if not task_sequences[se_seqid][taskid2] then return end
	triggerServerEvent("npc_tseq:onTaskSequenceSwapTasks",root,se_seqid,taskid1,taskid2)
end

function clickCloseSequence(button,state,x,y)
	if button ~= "left" or state ~= "up" then return end
	setSequenceWindowVisible(false)
end

----------------------------------------------------

task_types =
{
	{
		"(no action)",
		{},
		{}
	},
	{
		"walkToPos",
		{"Dest","Dist"},
		{"coord3D","float"}
	},
	{
		"walkAlongLine",
		{"Src","Dest","Off","EndDist"},
		{"coord3D","coord3D","float","float"}
	},
	{
		"walkAroundBend",
		{"Bend","Src","Dest","Off","EndDist"},
		{"coord2D","coord3D","coord3D","float","float"}
	},
	{
		"walkFollowElement",
		{"Tgt","Dist"},
		{"element","float"}
	},
	{
		"shootPoint",
		{"Tgt"},
		{"coord3D"}
	},
	{
		"shootElement",
		{"Tgt"},
		{"element"}
	},
	{
		"killPed",
		{"Tgt","ShtDst","FlwDst"},
		{"element","float","float"}
	},
	{
		"driveToPos",
		{"Dest","Dist"},
		{"coord3D","float"}
	},
	{
		"driveAlongLine",
		{"Src","Dest","Off","EndDist"},
		{"coord3D","coord3D","float","float"}
	},
	{
		"driveAroundBend",
		{"Bend","Src","Dest","Off","EndDist"},
		{"coord2D","coord3D","coord3D","float","float"}
	},
	{
		"waitForGreenLight",
		{"Dir"},
		{"trafficDir"}
	}
}

function createTaskWindow()
	local sw,sh = guiGetScreenSize()
	sh = sh*0.5
	te_window = guiCreateWindow(sw-256-32,sh-160,256,256,"Task editor",false)
	guiWindowSetSizable(te_window,false)
	te_parameters = {}
	te_task = guiCreateComboBox(16,24,192,256,"",false,te_window)
	task_comboitemnum = {}
	for tasknum,tasktype in ipairs(task_types) do
		local taskname,paramnames,paramtypes = tasktype[1],tasktype[2],tasktype[3]
		local taskitem = guiComboBoxAddItem(te_task,taskname)
		task_comboitemnum[taskname] = taskitem
		local y = 64
		local task_param_gui = {}
		te_parameters[taskname] = task_param_gui
		for paramnum,paramname in ipairs(paramnames) do
			local paramtype = paramtypes[paramnum]
			local param_gui_name = guiCreateLabel(8,y,48,24,paramname,false,te_window)
			guiLabelSetVerticalAlign(param_gui_name,"center")
			guiSetVisible(param_gui_name,false)
			table.insert(task_param_gui,param_gui_name)
			if paramtype == "float" then
				local param_gui_float = guiCreateEdit(64,y,64,24,"",false,te_window)
				table.insert(task_param_gui,param_gui_float)
				guiSetVisible(param_gui_float,false)
				setElementData(param_gui_float,"taskdata","float")
			elseif paramtype == "coord2D" then
				local param_gui_x = guiCreateEdit(64,y,40,24,"",false,te_window)
				local param_gui_y = guiCreateEdit(112,y,40,24,"",false,te_window)
				local param_gui_get = guiCreateButton(160,y,40,24,"Get",false,te_window)
				table.insert(task_param_gui,param_gui_x)
				table.insert(task_param_gui,param_gui_y)
				table.insert(task_param_gui,param_gui_get)
				guiSetVisible(param_gui_x,false)
				guiSetVisible(param_gui_y,false)
				guiSetVisible(param_gui_get,false)
				setElementData(param_gui_x,"taskdata","float")
				setElementData(param_gui_y,"taskdata","float")
				setElementData(param_gui_get,"datadest",{param_gui_x,param_gui_y})
				setElementData(param_gui_get,"datatype","coord2D")
			elseif paramtype == "coord3D" then
				local param_gui_x = guiCreateEdit(64,y,40,24,"",false,te_window)
				local param_gui_y = guiCreateEdit(112,y,40,24,"",false,te_window)
				local param_gui_z = guiCreateEdit(160,y,40,24,"",false,te_window)
				local param_gui_get = guiCreateButton(208,y,40,24,"Get",false,te_window)
				table.insert(task_param_gui,param_gui_x)
				table.insert(task_param_gui,param_gui_y)
				table.insert(task_param_gui,param_gui_z)
				table.insert(task_param_gui,param_gui_get)
				guiSetVisible(param_gui_x,false)
				guiSetVisible(param_gui_y,false)
				guiSetVisible(param_gui_z,false)
				guiSetVisible(param_gui_get,false)
				setElementData(param_gui_x,"taskdata","float")
				setElementData(param_gui_y,"taskdata","float")
				setElementData(param_gui_z,"taskdata","float")
				setElementData(param_gui_get,"datadest",{param_gui_x,param_gui_y,param_gui_z})
				setElementData(param_gui_get,"datatype","coord3D")
			elseif paramtype == "element" then
				local param_gui_elm = guiCreateEdit(64,y,128,24,"",false,te_window)
				local param_gui_get = guiCreateButton(200,y,40,24,"Get",false,te_window)
				table.insert(task_param_gui,param_gui_elm)
				table.insert(task_param_gui,param_gui_get)
				guiSetVisible(param_gui_elm,false)
				guiSetVisible(param_gui_get,false)
				guiEditSetReadOnly(param_gui_elm,true)
				setElementData(param_gui_elm,"taskdata","element")
				setElementData(param_gui_get,"datadest",param_gui_elm)
				setElementData(param_gui_get,"datatype","element")
			elseif paramtype == "trafficDir" then
				local param_gui_dir = guiCreateEdit(64,y,40,24,"",false,te_window)
				local param_gui_ns  = guiCreateButton(112,y,32,24,"NS",false,te_window)
				local param_gui_we  = guiCreateButton(152,y,32,24,"WE",false,te_window)
				local param_gui_ped = guiCreateButton(192,y,32,24,"ped",false,te_window)
				table.insert(task_param_gui,param_gui_dir)
				table.insert(task_param_gui,param_gui_ns)
				table.insert(task_param_gui,param_gui_we)
				table.insert(task_param_gui,param_gui_ped)
				guiSetVisible(param_gui_dir,false)
				guiSetVisible(param_gui_ns,false)
				guiSetVisible(param_gui_we,false)
				guiSetVisible(param_gui_ped,false)
				guiEditSetReadOnly(param_gui_dir,true)
				setElementData(param_gui_dir,"taskdata","direction")
				setElementData(param_gui_ns,"datadest",param_gui_dir)
				setElementData(param_gui_we,"datadest",param_gui_dir)
				setElementData(param_gui_ped,"datadest",param_gui_dir)
				setElementData(param_gui_ns,"datatype","direction")
				setElementData(param_gui_we,"datatype","direction")
				setElementData(param_gui_ped,"datatype","direction")
			end
			y = y+32
		end
	end
	te_prev_selected_task = "(no action)"
	addEventHandler("onClientGUIComboBoxAccepted",te_task,showTaskParameters,false)
	addEventHandler("onClientGUIClick",te_window,modifyTaskDataWithButtons)

	guiComboBoxSetSelected(te_task,0)


	guiSetVisible(te_window,false)
end

function setTaskWindowVisible(visible)
	if type(visible) ~= "boolean" then return end
	if isTaskWindowVisible() == visible then return end
	guiSetVisible(te_window,visible)
end

function isTaskWindowVisible()
	return guiGetVisible(te_window)
end

----------------------------------------------------

function showTaskParameters()
	local te_selected_task = guiComboBoxGetItemText(source,guiComboBoxGetSelected(source))
	if te_selected_task == te_prev_selected_task then return end
	if te_prev_selected_task then
		for guinum,guielm in ipairs(te_parameters[te_prev_selected_task]) do
			guiSetVisible(guielm,false)
		end
	end
	if te_selected_task then
		for guinum,guielm in ipairs(te_parameters[te_selected_task]) do
			guiSetVisible(guielm,true)
		end
	end
	te_prev_selected_task = te_selected_task
end

function setTaskEditorTask(task)
	local taskname = task[1]
	local item = task_comboitemnum[taskname]
	if not item then return end
	local task_param_gui = te_parameters[taskname]
	local param_id = 2
	for paramnum,param in ipairs(task_param_gui) do
		if getElementData(param,"taskdata") then
			setTaskParameterValue(param,task[param_id])
			param_id = param_id+1
		end
	end
	guiComboBoxSetSelected(te_task,item)
	triggerEvent("onClientGUIComboBoxAccepted",te_task)
end

function getTaskEditorTask()
	local taskname = te_prev_selected_task
	local task = {taskname}
	local task_param_gui = te_parameters[taskname]
	for paramnum,param in ipairs(task_param_gui) do
		if getElementData(param,"taskdata") then
			local val = getTaskParameterValue(param)
			if not val then return end
			table.insert(task,val)
		end
	end
	return task
end

function getTaskParameterValue(guiparam)
	local paramtype = getElementData(guiparam,"taskdata")
	if paramtype == "float" then
		return tonumber(guiGetText(guiparam))
	elseif paramtype == "element" then
		local dataval = getElementData(guiparam,"dataval")
		return isElement(dataval) and dataval or nil
	elseif paramtype == "direction" then
		local dataval = guiGetText(guiparam)
		return dataval ~= "" and dataval or nil
	end
end

function setTaskParameterValue(guiparam,value)
	local paramtype = getElementData(guiparam,"taskdata")
	if paramtype == "float" then
		guiSetText(guiparam,tostring(value))
	elseif paramtype == "element" then
		setElementData(guiparam,"dataval",value)
		local textval = value and tostring(value):gsub("userdata",getElementType(value)) or ""
		guiSetText(guiparam,textval)
	elseif paramtype == "direction" then
		guiSetText(guiparam,value)
	end
end

----------------------------------------------------

function modifyTaskDataWithButtons(button,state,x,y)
	local datadest = getElementData(source,"datadest")
	if not datadest then return end
	local datatype = getElementData(source,"datatype")
	if datatype == "coord2D" or datatype == "coord3D" or datatype == "element" then
		if data_modifier_button then return end
		if datatype == "coord2D" or datatype == "coord3D" then
			startPosMarkerSearch()
		end
		data_modifier_button = source
		addEventHandler("onClientClick",root,getTaskDataFromWorldClick)
	elseif datatype == "direction" then
		setTaskParameterValue(datadest,guiGetText(source))
	end
end

function getTaskDataFromWorldClick(button,state,sx,sy,x,y,z,element)
	if button ~= "left" or state ~= "down" then return end
	if isPositionOnAnyWindow(sx,sy) then return end
	x,y,z = getMouseWorldPosition()
	local button = data_modifier_button
	local datadest = getElementData(button,"datadest")
	local datatype = getElementData(button,"datatype")
	if datatype == "coord2D" then
		local marker = getActivePosMarker()
		if isElement(marker) then x,y,z = getElementPosition(marker) end
		if x then
			setTaskParameterValue(datadest[1],x)
			setTaskParameterValue(datadest[2],y+1)
		end
	elseif datatype == "coord3D" then
		local marker = getActivePosMarker()
		if isElement(marker) then x,y,z = getElementPosition(marker) end
		if x then
			setTaskParameterValue(datadest[1],x)
			setTaskParameterValue(datadest[2],y)
			setTaskParameterValue(datadest[3],z+1)
		end
	elseif datatype == "element" then
		if x then
			setTaskParameterValue(datadest,element)
		end
	end
	if datatype == "coord2D" or datatype == "coord3D" then
		stopPosMarkerSearch()
	end
	data_modifier_button = nil
	removeEventHandler("onClientClick",root,getTaskDataFromWorldClick)
end
