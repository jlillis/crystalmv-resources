function initSequenceEditor()
	addEvent("npc_tseq:onTaskSequenceCreate",true)
	addEvent("npc_tseq:onTaskSequenceDestroy",true)
	addEvent("npc_tseq:onTaskSequenceRename",true)
	addEvent("npc_tseq:onTaskSequenceAddTask",true)
	addEvent("npc_tseq:onTaskSequenceRemoveTask",true)
	addEvent("npc_tseq:onTaskSequenceEditTask",true)
	addEvent("npc_tseq:onTaskSequenceSwapTasks",true)

	addEventHandler("npc_tseq:onTaskSequenceCreate",root,createSequenceInEditor)
	addEventHandler("npc_tseq:onTaskSequenceDestroy",root,destroySequenceInEditor)
	addEventHandler("npc_tseq:onTaskSequenceRename",root,renameSequenceInEditor)
	addEventHandler("npc_tseq:onTaskSequenceAddTask",root,addTaskToSequenceInEditor)
	addEventHandler("npc_tseq:onTaskSequenceRemoveTask",root,removeTaskFromSequenceInEditor)
	addEventHandler("npc_tseq:onTaskSequenceEditTask",root,editTaskInSequenceInEditor)
	addEventHandler("npc_tseq:onTaskSequenceSwapTasks",root,swapTasksInSequenceInEditor)
end

function createSequenceInEditor(name)
	local seq = createTaskSequence(name)
end

function destroySequenceInEditor(id)
	destroyTaskSequence(id)
end

function renameSequenceInEditor(id,name)
	renameTaskSequence(id,name)
end

function addTaskToSequenceInEditor(id,taskid,task)
	addTaskToTaskSequence(id,taskid,task)
end

function removeTaskFromSequenceInEditor(id,taskid)
	removeTaskFromTaskSequence(id,taskid)
end

function editTaskInSequenceInEditor(id,taskid,task)
	editTaskInTaskSequence(id,taskid,task)
end

function swapTasksInSequenceInEditor(id,taskid1,taskid2)
	swapTasksInTaskSequence(id,taskid1,taskid2)
end
