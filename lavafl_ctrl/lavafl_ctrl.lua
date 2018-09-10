function initLFControl()
	addCommandHandler("lavaspeed",function(source,cmdname,speed) exports.lavaflood:setLavaRiseSpeed(speed) end)
	addCommandHandler("lavalevel",function(source,cmdname,level) exports.lavaflood:setLavaLevel(level) end)
end
addEventHandler("onResourceStart",resourceRoot,initLFControl)

