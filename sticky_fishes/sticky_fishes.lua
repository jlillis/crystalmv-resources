--902 starfish
--2782 oyster closed
--1599 1600 1604 fish
--1602]] 1603 jellyfish
--1609 turtle

function initStickyFishes()
	local animals_data_file = xmlLoadFile("sticky_fishes.xml")
	local animal_nodes = xmlNodeGetChildren(animals_data_file)
	max_animals = #animal_nodes
	local all_players = getElementsByType("player")
	local all_peds = getElementsByType("ped")
	for pednum,ped in ipairs(all_players) do removeElementData(ped,"sticky_fishes_count") end
	for pednum,ped in ipairs(all_peds) do removeElementData(ped,"sticky_fishes_count") end
	addEventHandler("onElementDataChange",root,preventFakeAnimalCountChange)
	addEventHandler("onPlayerSpawn",root,removeFishesOnRespawn)
end
addEventHandler("onResourceStart",resourceRoot,initStickyFishes)

function preventFakeAnimalCountChange(dataname,oldval)
	if dataname ~= "sticky_fishes_count" then return end
	local newval = getElementData(source,"sticky_fishes_count")
	if newval and (not tonumber(newval) or newval > max_animals) or (client and client ~= source and getElementSyncer(source) ~= client) then
		setElementData(source,"sticky_fishes_count",oldval)
	end
end

function removeFishesOnRespawn()
	setElementData(source,"sticky_fishes_count",0)
end
