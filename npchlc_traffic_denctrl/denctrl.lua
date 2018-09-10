function changeDensity(player,cmdname,trtype,density)
	if not trtype and not density then
		outputChatBox("Syntax: /density [type] new_density",player)
		return
	end
	if exports.npchlc_traffic:setTrafficDensity(trtype,density) then
		if density then
			local prevden = exports.npchlc_traffic:getTrafficDensity(trtype)
			outputChatBox(trtype.." traffic density changed from "..prevden.." to "..density)
		else
			outputChatBox("all traffic density changed to "..trtype)
		end
	end
end
addCommandHandler("density",changeDensity)

