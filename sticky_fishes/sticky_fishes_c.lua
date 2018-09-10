localPlayer = getLocalPlayer()

animal_model = {}
animal_bone = {}
animal_scale = {}
animal_x = {}
animal_y = {}
animal_z = {}
animal_rx = {}
animal_ry = {}
animal_rz = {}

ped_animals = {}
falling_animals = {}

function initStickyFishes()
	local animals_data_file = xmlLoadFile("sticky_fishes.xml")
	local animal_nodes = xmlNodeGetChildren(animals_data_file)
	max_animals = #animal_nodes
	for animal_num,animal_node in ipairs(animal_nodes) do
		local animal_data = xmlNodeGetAttributes(animal_node)
		animal_model[animal_num] = tonumber(animal_data.model)
		animal_bone[animal_num] = tonumber(animal_data.bone)
		animal_scale[animal_num] = tonumber(animal_data.scale)
		animal_x[animal_num] = tonumber(animal_data.x)
		animal_y[animal_num] = tonumber(animal_data.y)
		animal_z[animal_num] = tonumber(animal_data.z)
		animal_rx[animal_num] = tonumber(animal_data.rx)
		animal_ry[animal_num] = tonumber(animal_data.ry)
		animal_rz[animal_num] = tonumber(animal_data.rz)
	end
	addEventHandler("onClientElementDestroy",root,removePedAnimalSlots)
	addEventHandler("onClientElementDataChange",root,addOrRemoveAnimals)
	local all_peds = getElementsByType("ped")
	local all_players = getElementsByType("player")
	for pednum,ped in ipairs(all_peds) do triggerEvent("onClientElementDataChange",ped,"sticky_fishes_count") end
	for pednum,ped in ipairs(all_players) do triggerEvent("onClientElementDataChange",ped,"sticky_fishes_count") end
	addEventHandler("onClientPreRender",root,cycleAllPeds)
end
addEventHandler("onClientResourceStart",resourceRoot,initStickyFishes)

function removePedAnimalSlots()
	ped_animals[source] = nil
end

function addOrRemoveAnimals(dataname,oldval)
	if dataname ~= "sticky_fishes_count" then return end
	local newval = getElementData(source,"sticky_fishes_count") or 0
	oldval = oldval or 0
	if newval > oldval then
		if not ped_animals[source] then ped_animals[source] = {} end
		for animal_num = oldval+1,newval do
			local new_animal = createObject(animal_model[animal_num],0,0,0)
			setObjectScale(new_animal,animal_scale[animal_num])
			exports.bone_attach:attachElementToBone(new_animal,source,animal_bone[animal_num],
				animal_x[animal_num],animal_y[animal_num],animal_z[animal_num],
				animal_rx[animal_num],animal_ry[animal_num],animal_rz[animal_num]
			)
			ped_animals[source][animal_num] = new_animal
		end
	else
		for animal_num = newval+1,oldval do
			local animal = ped_animals[source][animal_num]
			ped_animals[source][animal_num] = nil
			exports.bone_attach:detachElementFromBone(animal)
			setTimer(destroyElement,5000,1,animal)
			local x,y,z = getElementPosition(animal)
			falling_animals[animal] = getGroundPosition(x,y,z)
		end
	end
end

total_time = 0
function cycleAllPeds(timeslice)
	local all_peds = getElementsByType("ped",root,true)
	total_time = total_time+timeslice
	for i,ped in ipairs(all_peds) do checkPedUnderwater(ped) end
	checkPedUnderwater(localPlayer)
	if total_time > 100 then total_time = 0 end
	for animal,groundz in pairs(falling_animals) do
		if isElement(animal) then
			local x,y,z = getElementPosition(animal)
			z = z-timeslice*0.002
			if z < groundz then
				z = groundz
				falling_animals[animal] = nil
			end
			setElementPosition(animal,x,y,z)
		else
			falling_animals[animal] = nil
		end
	end
end

function checkPedUnderwater(ped)
	if ped ~= localPlayer and not isElementSyncer(ped) then return end
	local x,y,z = getElementPosition(ped)
	local wz = getWaterLevel(x,y,z,true)
	if wz then
		wz = wz-z
		if wz > 0.9 and (getElementData(ped,"sticky_fishes_count") or 0) < max_animals then
			setElementData(ped,"sticky_fishes_count",max_animals)
			return
		end
	end
	if total_time <= 100 or isElementInWater(ped) then return end
	local fishcount = getElementData(ped,"sticky_fishes_count") or 0
	local vx,vy,vz = getElementVelocity(ped)
	local speed = (vx*vx+vy*vy+vz*vz)*3
	if math.random() <= speed and fishcount > 0 then
		setElementData(ped,"sticky_fishes_count",fishcount-1)
	end
end
