function initSequenceEditorDrawing()
	sequence_visible = true
	addEventHandler("onClientHUDRender",root,drawSelectedSequence)

	addCommandHandler("showsequence",function()
		sequence_visible = not sequence_visible
	end)
end

function drawSelectedSequence()
	if not sequence_visible then return end
	if se_seqid then
		for tasknum,task in pairs(task_sequences[se_seqid]) do
			local drawFunc = drawTask[task[1]]
			if drawFunc then
				drawFunc(task)
			end
		end
	end
	if isTaskWindowVisible() then
		local task = getTaskEditorTask()
		if task then
			local drawFunc = drawTask[task[1]]
			if drawFunc then
				drawFunc(task)
			end
		end
	end
end

function drawGoToSphere(task)
	drawSphere(task[2],task[3],task[4]-0.99,task[5])
end

function drawGoAlongLine(task)
	drawDirLine(task[2],task[3],task[4]-0.99,task[5],task[6],task[7]-0.99,task[9])
end

function drawGoAroundBend(task)
	drawDirBend(task[2],task[3],task[4],task[5],task[6]-0.99,task[7],task[8],task[9]-0.99,task[11])
end

drawTask = {}

drawTask.walkToPos = drawGoToSphere
drawTask.driveToPos = drawGoToSphere
drawTask.walkAlongLine = drawGoAlongLine
drawTask.driveAlongLine = drawGoAlongLine
drawTask.walkAroundBend = drawGoAroundBend
drawTask.driveAroundBend = drawGoAroundBend
