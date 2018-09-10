red	= tocolor(255,0,0,255)
green	= tocolor(0,255,0,255)
blue	= tocolor(0,0,255,255)

function drawSphere(x,y,z,r)
	local delta_a = math.pi*0.125*0.125
	for a = 0,math.pi*2-delta_a*0.5,delta_a do
		local sin_a0,cos_a0 = math.sin(a)*r,math.cos(a)*r
		local sin_a1,cos_a1 = math.sin(a+delta_a)*r,math.cos(a+delta_a)*r
		drawLineFake3D(x,y+sin_a0,z+cos_a0,x,y+sin_a1,z+cos_a1,red,8)
		drawLineFake3D(x+cos_a0,y,z+sin_a0,x+cos_a1,y,z+sin_a1,green,8)
		drawLineFake3D(x+sin_a0,y+cos_a0,z,x+sin_a1,y+cos_a1,z,blue,8)
	end
end

function drawDirLine(x1,y1,z1,x2,y2,z2,enddist)
	local fx,fy,fz = x1-x2,y1-y2,z1-z2
	local ux,uy,uz = 0,0,1
	local sx,sy,sz = fy*uz-fz*uy,fz*ux-fx*uz,fx*uy-fy*ux
	ux,uy,uz = fy*sz-fz*sy,fz*sx-fx*sz,fx*sy-fy*sx

	local fmult = enddist/math.sqrt(fx*fx+fy*fy+fz*fz)
	local umult = enddist/math.sqrt(ux*ux+uy*uy+uz*uz)*0.5
	local smult = enddist/math.sqrt(sx*sx+sy*sy+sz*sz)*0.5
	do
		local inftest
		inftest = fmult/fmult
		if inftest ~= inftest then return end
		inftest = umult/umult
		if inftest ~= inftest then return end
		inftest = smult/smult
		if inftest ~= inftest then return end
	end

	fx,fy,fz = fx*fmult,fy*fmult,fz*fmult
	ux,uy,uz = ux*umult,uy*umult,uz*umult
	sx,sy,sz = sx*smult,sy*smult,sz*smult
	
	drawLineFake3D(x1,y1,z1,x2,y2,z2,red,8)
	drawLineFake3D(x2+fx-ux,y2+fy-uy,z2+fz-uz,x2+fx+ux,y2+fy+uy,z2+fz+uz,green,8)
	drawLineFake3D(x2+fx-sx,y2+fy-sy,z2+fz-sz,x2+fx+sx,y2+fy+sy,z2+fz+sz,green,8)
	drawLineFake3D(x2,y2,z2,x2+fx-ux,y2+fy-uy,z2+fz-uz,blue,8)
	drawLineFake3D(x2,y2,z2,x2+fx+ux,y2+fy+uy,z2+fz+uz,blue,8)
	drawLineFake3D(x2,y2,z2,x2+fx-sx,y2+fy-sy,z2+fz-sz,blue,8)
	drawLineFake3D(x2,y2,z2,x2+fx+sx,y2+fy+sy,z2+fz+sz,blue,8)
end

function drawDirBend(bx,by,x1,y1,z1,x2,y2,z2,enddist)
	local bz = (z1+z2)*0.5

	drawLineFake3D(bx,by,bz,x1,y1,z1,blue,8)
	drawLineFake3D(bx,by,bz,x2,y2,z2,blue,8)

	x1,y1,z1 = x1-bx,y1-by,z1-bz
	x2,y2,z2 = x2-bx,y2-by,z2-bz
	
	local delta_a = math.pi*0.125*0.125
	for a = 0,math.pi*0.5-delta_a*0.5,delta_a do
		local sin_a0,cos_a0 = math.sin(a),math.cos(a)
		local sin_a1,cos_a1 = math.sin(a+delta_a),math.cos(a+delta_a)
		drawLineFake3D(
			bx+sin_a0*x1+cos_a0*x2,by+sin_a0*y1+cos_a0*y2,bz+sin_a0*z1+cos_a0*z2,
			bx+sin_a1*x1+cos_a1*x2,by+sin_a1*y1+cos_a1*y2,bz+sin_a1*z1+cos_a1*z2,
			red,8
		)
	end

	local a = enddist/getDistanceBetweenPoints2D(x1,y1,x2,y2)*math.pi*0.5
	local sin_a,cos_a = math.sin(a),math.cos(a)
	drawLineFake3D(
		bx,by,bz,bx+sin_a*x1+cos_a*x2,by+sin_a*y1+cos_a*y2,bz+sin_a*z1+cos_a*z2,
		green,8
	)
end

function drawLineFake3D(x1,y1,z1,x2,y2,z2,color)
	local sx1,sy1 = getScreenFromWorldPosition(x1,y1,z1,0x7FFFFFFF)
	if not sx1 then return end
	local sx2,sy2 = getScreenFromWorldPosition(x2,y2,z2,0x7FFFFFFF)
	if not sx2 then return end
	dxDrawLine(sx1,sy1,sx2,sy2,color,2)
end
