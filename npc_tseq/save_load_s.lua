function clearPositionMarkers()
	local all_posmarkers = getElementChildren(pos_marker_root)
	for num,posmarker in ipairs(all_posmarkers) do
		destroyElement(posmarker)
	end
end

function savePositionMarkers()
	local pm_file = xmlCreateFile("saved_data/posmarkers.xml","positions")
	if not pm_file then return end
	local posmarkers = getElementChildren(pos_marker_root)
	for num,posmarker in ipairs(posmarkers) do
		local x,y,z = getElementPosition(posmarker)
		local pm_node = xmlCreateChild(pm_file,"pos")
		xmlNodeSetAttribute(pm_node,"x",tostring(x))
		xmlNodeSetAttribute(pm_node,"y",tostring(y))
		xmlNodeSetAttribute(pm_node,"z",tostring(z))
	end
	xmlSaveFile(pm_file)
	xmlUnloadFile(pm_file)
end

function loadPositionMarkers()
	clearPositionMarkers()
	local pm_file = xmlLoadFile("saved_data/posmarkers.xml")
	if not pm_file then return end
	local pm_nodes = xmlNodeGetChildren(pm_file)
	for num,pm_node in ipairs(pm_nodes) do
		local x = tonumber(xmlNodeGetAttribute(pm_node,"x"))
		local y = tonumber(xmlNodeGetAttribute(pm_node,"y"))
		local z = tonumber(xmlNodeGetAttribute(pm_node,"z"))
		createPositionMarker(x,y,z)
	end
	xmlUnloadFile(pm_file)
end

function clearTaskSequences()
	for id,sequence in pairs(task_sequences) do
		destroyTaskSequence(id)
	end
end

function saveTaskSequences()
	local ts_file = xmlCreateFile("saved_data/sequences.xml","sequences")
	if not ts_file then return end
	for id,sequence in pairs(task_sequences) do
		local name = seq_name[id]
		local ts_node = xmlCreateChild(ts_file,"sequence")
		xmlNodeSetAttribute(ts_node,"id",tostring(id))
		xmlNodeSetAttribute(ts_node,"name",name)
		for taskid,task in ipairs(sequence) do
			for parid,parameter in ipairs(task) do
				local partype = type(parameter)
				if partype ~= "number" and partype ~= "string" then
					task = {"(no action)"}
					break
				end
			end
			local task_node = xmlCreateChild(ts_node,"task")
			xmlNodeSetAttribute(task_node,"id",tostring(taskid))
			for parid,parameter in ipairs(task) do
				local partype = type(parameter)
				local par_node = xmlCreateChild(task_node,"parameter")
				xmlNodeSetAttribute(par_node,"id",tostring(parid))
				xmlNodeSetAttribute(par_node,"type",partype)
				xmlNodeSetAttribute(par_node,"value",tostring(parameter))
			end
		end
	end
	xmlSaveFile(ts_file)
	xmlUnloadFile(ts_file)
end

function loadTaskSequences()
	clearTaskSequences()
	local ts_file = xmlLoadFile("saved_data/sequences.xml","sequences")
	if not ts_file then return end
	local ts_nodes = xmlNodeGetChildren(ts_file)
	for ts_num,ts_node in ipairs(ts_nodes) do
		local id = tonumber(xmlNodeGetAttribute(ts_node,"id"))
		local name = xmlNodeGetAttribute(ts_node,"name")
		createTaskSequence(name,id)
		local task_nodes = xmlNodeGetChildren(ts_node)
		for task_num,task_node in ipairs(task_nodes) do
			local taskid = tonumber(xmlNodeGetAttribute(task_node,"id"))
			local task = {}
			local par_nodes = xmlNodeGetChildren(task_node)
			for par_num,par_node in ipairs(par_nodes) do
				local parid = tonumber(xmlNodeGetAttribute(par_node,"id"))
				local partype = xmlNodeGetAttribute(par_node,"type")
				local parameter = xmlNodeGetAttribute(par_node,"value")
				if partype == "number" then parameter = tonumber(parameter) end
				task[parid] = parameter
			end
			addTaskToTaskSequence(id,taskid,task)
		end
	end
	xmlUnloadFile(ts_file)
end
