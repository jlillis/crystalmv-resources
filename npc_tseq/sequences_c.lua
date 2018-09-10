function initTaskSequences()
	task_sequences = {}

	addEvent("npc_tseq:onClientTaskSequenceCreate",true)
	addEvent("npc_tseq:onClientTaskSequenceDestroy",true)
	addEvent("npc_tseq:onClientTaskSequenceRename",true)
	addEvent("npc_tseq:onClientTaskSequenceAddTask",true)
	addEvent("npc_tseq:onClientTaskSequenceRemoveTask",true)
	addEvent("npc_tseq:onClientTaskSequenceEditTask",true)
	addEvent("npc_tseq:onClientTaskSequenceSwapTasks",true)
	addEvent("npc_tseq:onClientTaskSequenceAssignToNPC",true)

	addEventHandler("npc_tseq:onClientTaskSequenceCreate",root,createTaskSequence)
	addEventHandler("npc_tseq:onClientTaskSequenceDestroy",root,destroyTaskSequence)
	addEventHandler("npc_tseq:onClientTaskSequenceAddTask",root,addTaskToSequence)
	addEventHandler("npc_tseq:onClientTaskSequenceRemoveTask",root,removeTaskFromSequence)
	addEventHandler("npc_tseq:onClientTaskSequenceEditTask",root,editTaskInSequence)
	addEventHandler("npc_tseq:onClientTaskSequenceSwapTasks",root,swapTasksInSequence)
end

function createTaskSequence(id)
	task_sequences[id] = {}
end

function destroyTaskSequence(id)
	task_sequences[id] = nil
end

function addTaskToSequence(id,taskid,task)
	table.insert(task_sequences[id],taskid,task)
end

function removeTaskFromSequence(id,taskid)
	table.remove(task_sequences[id],taskid)
end

function editTaskInSequence(id,taskid,task)
	task_sequences[id][taskid] = task
end

function swapTasksInSequence(id,taskid1,taskid2)
	local sequence = task_sequences[id]
	sequence[taskid1],sequence[taskid2] = sequence[taskid2],sequence[taskid1]
end
