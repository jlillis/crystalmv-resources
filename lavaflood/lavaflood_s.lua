script_serverside = true

function initLavaFlood()
	prev_min_duration = getMinuteDuration()
	prev_weather = {getWeather()}
	prev_sky_gradient = {getSkyGradient()}
	prev_far_clip_dist = getFarClipDistance()
	prev_fog_dist = getFogDistance()
	prev_heat_haze = {getHeatHaze()}
	prev_water_color = {getWaterColor()}
	prev_wave_height = getWaveHeight()
	
	setMinuteDuration(0x7FFFFFFF)
	setWeather(17)
	setSkyGradient(255,96,0,255,96,0)
	setFarClipDistance(200)
	setFogDistance(-20)
	setHeatHaze(128,0,12,18,65,80,80,95,true)
	setWaterColor(255,128,0,255)
	setWaterLevel(-1000)
	setWaveHeight(0)
	lava_level = 0

	last_update_time = getTickCount()
	setTimer(raiseWater,1000,0)

	setLavaRiseSpeed(0)

	addEventHandler("onResourceStop",resourceRoot,uninitLavaFlood)
end
addEventHandler("onResourceStart",resourceRoot,initLavaFlood)

function uninitLavaFlood()
	if prev_min_duration and getMinuteDuration() == 0x7FFFFFFF then setMinuteDuration(prev_min_duration) end

	local w1,w2 = getWeather()
	if w1 == 17 and not w2 then
		setWeather(prev_weather[1])
		if prev_weather[2] then setWeatherBlended(prev_weather[2]) end
	end

	local sr1,sg1,sb1,sr2,sg2,sb2 = getSkyGradient()
	if sr1 == 255 and sg1 == 96 and sb1 == 0 and sr2 == 255 and sg2 == 96 and sb2 == 0 then
		if prev_sky_gradient[1] then
			setSkyGradient(unpack(prev_sky_gradient))
		else
			resetSkyGradient()
		end
	end

	if getFarClipDistance() == 200 then
		if prev_far_clip_dist then
			setFarClipDistance(prev_far_clip_dist)
		else
			resetFarClipDistance()
		end
	end

	if getFogDistance() == -20 then
		if prev_fog_dist then
			setFogDistance(prev_fog_dist)
		else
			resetFogDistance()
		end
	end

	local hh1,hh2,hh3,hh4,hh5,hh6,hh7,hh8,hh9 = getHeatHaze()
	if hh1 == 128 and hh2 == 0 and hh3 == 12 and hh4 == 18 and hh5 == 65 and hh6 == 80 and hh7 == 80 and hh8 == 95 and hh9 == true then
		if prev_heat_haze[1] then
			setHeatHaze(unpack(prev_heat_haze))
		else
			resetHeatHaze()
		end
	end

	local wr,wg,wb,wa = getWaterColor()
	if wr == 255 and wg == 128 and wb == 0 and wa == 255 then
		if prev_water_color[1] then
			setWaterColor(unpack(prev_water_color))
		else
			resetWaterColor()
		end
	end

	resetWaterLevel()

	if getWaveHeight() == 0 then
		setWaveHeight(prev_wave_height)
	end
end

function raiseWater()
	local this_time = getTickCount()
	setLavaLevel(getLavaLevel()+(this_time-last_update_time)*getLavaRiseSpeed())
	last_update_time = this_time
end

-----------------------------------------------

function getLavaLevel()
	return lava_level
end

function setLavaLevel(level)
	level = tonumber(level)
	if not level then return false end
	lava_level = level
	triggerClientEvent("lavaflood:updateWaterLevel",root,level)
	return true
end

function getLavaRiseSpeed()
	return getElementData(resourceRoot,"risespeed")
end

function setLavaRiseSpeed(speed)
	speed = tonumber(speed)
	if not speed then return false end
	setElementData(resourceRoot,"risespeed",speed)
	return true
end

