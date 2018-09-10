function initTrafficLightSequence()
	loadSequence()
	setTrafficLightsLocked(true)
	switchToNextState()
	addEventHandler("onResourceStop",resourceRoot,uninitTrafficLightSequence)
end
addEventHandler("onResourceStart",resourceRoot,initTrafficLightSequence)

function uninitTrafficLightSequence()
	setTrafficLightsLocked(false)
end

function loadSequence()
	local state_ids =
	{
		R = {R = 2,Y = 4,G = 3},
		Y = {R = 1,Y = 6,G = 7},
		G = {R = 0,Y = 8,G = 5}
	}
	states = {}
	durations = {}
	local seqfile = xmlLoadFile("sequence.xml")
	local nodes = xmlNodeGetChildren(seqfile)
	for id,node in ipairs(nodes) do
		local attr = xmlNodeGetAttributes(node)
		states[id] = state_ids[attr.NS][attr.WE]
		durations[id] = tonumber(attr.time)
	end
	xmlUnloadFile(seqfile)
	state_count = #states
	state = 0
end

function switchToNextState()
	state = state%state_count+1
	setTrafficLightState(states[state])
	setTimer(switchToNextState,durations[state],1)
end

