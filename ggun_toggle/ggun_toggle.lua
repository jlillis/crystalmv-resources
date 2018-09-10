function toggleGGun(player)
	local on = not exports.gravity_gun:isGravityGunEnabled(player)
	exports.gravity_gun:togglePlayerGravityGun(player,on)
	outputChatBox("gravity gun "..(on and "on" or "off"),player)
end
addCommandHandler("ggun",toggleGGun)
