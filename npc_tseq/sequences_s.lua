function initTaskSequences()
	task_sequences = {}
	ped_sequences = {}
	seq_name = {}
end

function createTaskSequence(name,new_id)
	if type(name) ~= "string" then
		outputDebugString("No name specified for new sequence",2)
		return
	end
	if new_id and type(new_id) ~= "number" then
		outputDebugString("Invalid ID specified for new sequence",2)
		return
	end
	new_id = new_id or #task_sequences+1
	task_sequences[new_id] = {}
	seq_name[new_id] = name
	triggerClientEvent("npc_tseq:onClientTaskSequenceCreate",root,new_id,name)
	return new_id
end

function destroyTaskSequence(id)
	if not task_sequences[id] then
		outputDebugString("Attempt to destroy non-existing sequence",2)
		return
	end
	for npc,seq in pairs(ped_sequences) do
		if seq == id then
			assignTaskSequenceToNPC(npc)
		end
	end
	task_sequences[id] = nil
	seq_name[id] = nil
	triggerClientEvent("npc_tseq:onClientTaskSequenceDestroy",root,id)
end

function renameTaskSequence(id,name)
	if not task_sequences[id] then
		outputDebugString("Attempt to rename non-existing sequence",2)
		return
	end
	if type(name) ~= "string" then
		outputDebugString("No name specified for the sequence",2)
		return
	end
	seq_name[id] = name
	triggerClientEvent("npc_tseq:onClientTaskSequenceRename",root,id,name)
end

function addTaskToTaskSequence(id,taskid,task)
	local sequence = task_sequences[id]
	if not sequence then
		outputDebugString("Attempt to add task to non-existing sequence",2)
		return
	end
	if task then
		table.insert(sequence,taskid,task)
	else
		table.insert(sequence,taskid)
	end
	triggerClientEvent("npc_tseq:onClientTaskSequenceAddTask",root,id,task and taskid or #sequence,task or taskid)
end

function removeTaskFromTaskSequence(id,taskid)
	local sequence = task_sequences[id]
	if not sequence then
		outputDebugString("Attempt to remove task from non-existing sequence",2)
		return
	end
	if not sequence[taskid] then 
		outputDebugString("Attempt to remove non-existing task from the sequence",2)
		return
	end
	table.remove(sequence,taskid)
	triggerClientEvent("npc_tseq:onClientTaskSequenceRemoveTask",root,id,taskid)
end

function editTaskInTaskSequence(id,taskid,task)
	local sequence = task_sequences[id]
	if not sequence then
		outputDebugString("Attempt to edit task in non-existing sequence",2)
		return
	end
	if not sequence[taskid] then
		outputDebugString("Attempt to edit non-existing task",2)
		return
	end
	sequence[taskid] = task
	triggerClientEvent("npc_tseq:onClientTaskSequenceEditTask",root,id,taskid,task)
end

function swapTasksInTaskSequence(id,taskid1,taskid2)
	local sequence = task_sequences[id]
	if not sequence then
		outputDebugString("Attempt to swap tasks in non-existing sequence",2)
		return
	end
	local task1,task2 = sequence[taskid1],sequence[taskid2]
	if not task1 or not task2 then
		outputDebugString("Attempt to swap non-existing tasks in the sequence",2)
		return
	end
	sequence[taskid1],sequence[taskid2] = sequence[taskid2],sequence[taskid1]
	triggerClientEvent("npc_tseq:onClientTaskSequenceSwapTasks",root,id,taskid1,taskid2)
end

function isTaskSequence(id)
	return task_sequences[id] and true or false
end

function sendPlayerSequencesInfo(player)
	for id,sequence in pairs(task_sequences) do
		local name = seq_name[id]
		triggerClientEvent(player,"npc_tseq:onClientTaskSequenceCreate",root,id,name)
		for taskid,task in ipairs(sequence) do
			triggerClientEvent(player,"npc_tseq:onClientTaskSequenceAddTask",root,id,taskid,task)
		end
	end
end
