local cc = game.Workspace.CurrentCamera
local udim2 = {}
local instance = {}
local library = {}
local main = {
	tabbuttonx = 0
}
local tabs = {}
local sections = {}
local buttons = {}
local toggles = {}
local sliders = {}
local textboxs = {}
local keybinds = {}
local dropdowns = {}
local colorpickers = {}
--
local currentccx = cc.ViewportSize.x
local currentccy = cc.ViewportSize.y
--
local mousedisable = false
local sliderhold = false
local holdingslider = nil
local textboxin = false
local currenttextbox = nil
local keybindin = false
local currentkeybind = nil
local colorpickerenabled = false
local currentcolorpicker = nil
local currentcpcolor = Color3.fromRGB(255,255,255)
local currenttransparency = 0
local currentcpcolortable = {1,1,1}
local cx = 0
local cy = 0
local cyy = 0
local ty = 0
local colorhold = false
local huehold = false
local transphold = false
local ddenabled = false
local ddcontent = nil
local dragging = false
local dragX,dragY = 0,0
--
local cursor
local colorpicker
local cursorenabled = false
local images = {}
local imagecache = {}
local uis = game:GetService('UserInputService')
local rs = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local controls = require(plr.PlayerScripts.PlayerModule):GetControls()
local zoom = (workspace.CurrentCamera.CoordinateFrame.p - plr.Character.Head.Position).magnitude
local maxzoom = plr.CameraMaxZoomDistance
local minzoom = plr.CameraMinZoomDistance
--
images.Cursor = 'https://i.imgur.com/e2RzMxU.png'
--
library.imageset = function(drawing, link)
	local Data = game:HttpGet(link) or link
	pcall(function()drawing['Data' or 'Uri'] = imagecache[link] or Data end)
	imagecache[link] = Data
end
--
local allowedcharacters = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	["One"] = "1",
	["Two"] = "2",
	["Three"] = "3",
	["Four"] = "4",
	["Five"] = "5",
	["Six"] = "6",
	["Seven"] = "7",
	["Eight"] = "8",
	["Nine"] = "9",
	["Zero"] = "0",
	["Space"] = " "
}
local keybindallowed = {
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	["One"] = "1",
	["Two"] = "2",
	["Three"] = "3",
	["Four"] = "4",
	["Five"] = "5",
	["Six"] = "6",
	["Seven"] = "7",
	["Eight"] = "8",
	["Nine"] = "9",
	["Zero"] = "0",
	["Mouse1"] = "M1",
	["Mouse2"] = "M2",
	["Mouse3"] = "M3"
}
--
udim2.snew = function(xscale,xoffset,yscale,yoffset,instance)
	local x
	local y
	local vx,vy = cc.ViewportSize.x,cc.ViewportSize.y
	if instance then
		x = xscale*instance.Size.x+xoffset
		y = yscale*instance.Size.y+yoffset
	else
		x = xscale*vx+xoffset
		y = yscale*vy+yoffset
	end
	return Vector2.new(x,y)
end
--
udim2.pnew = function(xscale,xoffset,yscale,yoffset,instance)
	local x
	local y
	local vx,vy = cc.ViewportSize.x,cc.ViewportSize.y
	if instance then
		x = instance.Position.x+xscale*instance.Size.x+xoffset
		y = instance.Position.y+yscale*instance.Size.y+yoffset
	else
		x = xscale*vx+xoffset
		y = yscale*vy+yoffset
	end
	return Vector2.new(x,y)
end
--
instance.new = function(type)
	local instance = nil
	if type == "Frame" or type == "frame" then
		local frame = Drawing.new("Square")
		frame.Visible = true
		frame.Filled = true
		frame.Thickness = 0
		frame.Color = Color3.fromRGB(255,255,255)
		frame.Size = Vector2.new(100,100)
		frame.Position = Vector2.new(0,0)
		instance = frame
	elseif type == "TextLabel" or "textlabel" then
		local text = Drawing.new("Text")
		text.Font = 3
		text.Visible = true
		text.Outline = true
		text.Center = false
		text.Color = Color3.fromRGB(255,255,255)
		instance = text
	elseif type == "Image" or "image" then
		local image = Drawing.new("Image")
		image.Size = Vector2.new(12,19)
		image.Position = Vector2.new(0,0)
		image.Visible = true
		instance = image
	end
	return instance
end
--//
local imagecache = {}
library.setimage = function(Drawing, Url)
	spawn(function()
		local Data = game:HttpGet(Url) or Url;
		Drawing['Data'] = imagecache[Url] or Data;
		imagecache[Url] = Data;
	end)
end
--
library.updatecursor = function()
	if cursor then
		cursor:Remove()
	end
	cursor = instance.new("Frame")
	cursor.Size = Vector2.new(4,4)
	cursor.Visible = false
end
--
library.makecolorpicker = function()
	local border3 = instance.new("Frame")
	border3.Size = udim2.snew(0,145+10,0,145+10)
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Position = udim2.pnew(0.1,-5,0.3,-5)
	border3.Visible = false
	--
	local border2 = instance.new("Frame")
	border2.Size = udim2.snew(0,145+8,0,145+8)
	border2.Color = Color3.fromRGB(20, 20, 20)
	border2.Position = udim2.pnew(0.1,-4,0.3,-4)
	border2.Visible = false
	--
	local border1 = instance.new("Frame")
	border1.Size = udim2.snew(0,145+2,0,145+2)
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Position = udim2.pnew(0.1,-1,0.3,-1)
	border1.Visible = false
	--
	local frame = instance.new("Frame")
	frame.Size = udim2.snew(0,145,0,145)
	frame.Color = Color3.fromRGB(30, 30, 30)
	frame.Position = udim2.pnew(0.1,0,0.3,0)
	frame.Visible = false
	--
	local color = instance.new("Frame")
	color.Visible = false
	color.Color = Color3.fromRGB(255,0,0)
	color.Size = udim2.snew(0,120,0,120,frame)
	color.Position = udim2.pnew(0,5,0,5,frame)
	local colorimage = Drawing.new("Image")
	colorimage.Visible = false
	colorimage.Size = udim2.snew(0,120,0,120,frame)
	colorimage.Position = udim2.pnew(0,0,0,0,color)
	library.setimage(colorimage,"https://i.imgur.com/HqG6MM1.png")
	--
	local colorborder = instance.new("Frame")
	colorborder.Visible = false
	colorborder.Color = Color3.fromRGB(0,0,0)
	colorborder.Filled = false
	colorborder.Thickness = 1
	colorborder.Size = udim2.snew(1,0,1,0,color)
	colorborder.Position = udim2.pnew(0,0,0,0,color)
	--
	local cursor1 = instance.new("Frame")
	cursor1.Visible = false
	cursor1.Color = Color3.fromRGB(0,0,0)
	cursor1.Size = udim2.snew(0,5,0,5,color)
	cursor1.Position = udim2.pnew(0,-2,0,-2,color)
	--
	local cursor2 = instance.new("Frame")
	cursor2.Visible = false
	cursor2.Color = Color3.fromRGB(255,255,255)
	cursor2.Size = udim2.snew(0,3,0,3,cursor1)
	cursor2.Position = udim2.pnew(0,1,0,1,cursor1)
	--
	local hue = Drawing.new("Image")
	hue.Visible = false
	hue.Size = udim2.snew(0,10,0,120,frame)
	hue.Position = udim2.pnew(1,5,0,0,color)
	library.setimage(hue,"https://i.imgur.com/Nst0hXE.png")
	--
	local hueborder = instance.new("Frame")
	hueborder.Visible = false
	hueborder.Color = Color3.fromRGB(0,0,0)
	hueborder.Filled = false
	hueborder.Thickness = 1
	hueborder.Size = udim2.snew(1,0,1,0,hue)
	hueborder.Position = udim2.pnew(0,0,0,0,hue)
	--
	local cursor3 = instance.new("Frame")
	cursor3.Visible = false
	cursor3.Color = Color3.fromRGB(0,0,0)
	cursor3.Size = udim2.snew(1,2,0,4,hue)
	cursor3.Position = udim2.pnew(0,-1,0,2,hue)
	--
	local cursor4 = instance.new("Frame")
	cursor4.Visible = false
	cursor4.Color = Color3.fromRGB(255,255,255)
	cursor4.Size = udim2.snew(1,-2,1,-2,cursor3)
	cursor4.Position = udim2.pnew(0,1,0,1,cursor3)
	--
	local transparency = Drawing.new("Image")
	transparency.Visible = false
	transparency.Size = udim2.snew(0,120,0,10,color)
	transparency.Position = udim2.pnew(0,0,1,5,color)
	library.setimage(transparency,"https://i.imgur.com/rbW3WNd.png")
	--
	local transpborder = instance.new("Frame")
	transpborder.Visible = false
	transpborder.Color = Color3.fromRGB(0,0,0)
	transpborder.Filled = false
	transpborder.Thickness = 1
	transpborder.Size = udim2.snew(1,0,1,0,transparency)
	transpborder.Position = udim2.pnew(0,0,0,0,transparency)
	--
	local cursor5 = instance.new("Frame")
	cursor5.Visible = false
	cursor5.Color = Color3.fromRGB(0,0,0)
	cursor5.Size = udim2.snew(0,4,1,2,transparency)
	cursor5.Position = udim2.pnew(0,2,0,-1,transparency)
	--
	local cursor6 = instance.new("Frame")
	cursor6.Visible = false
	cursor6.Color = Color3.fromRGB(255,255,255)
	cursor6.Size = udim2.snew(1,-2,1,-2,cursor5)
	cursor6.Position = udim2.pnew(0,1,0,1,cursor5)

	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	colorpicker = {frame = frame,color = color,colorimage = colorimage,colorborder = colorborder,colorcursor = cursor1,colorcursor2 = cursor2,hue = hue,hueborder = hueborder,huecursor = cursor3,huecursor2 = cursor4,transparency = transparency,transpborder = transpborder,transpcursor = cursor5,transpcursor2 = cursor6,borders = borders}
	library.updatecursor()
end
--
library.opencolorpicker = function(info)
	if colorpicker then
		local transp = info.transparency
		local framesize = Vector2.new(0,0)
		local transparency = false
		if transp then
			transparency = true
			framesize = udim2.snew(0,145,0,145)
		else
			transparency = false
			framesize = udim2.snew(0,145,0,130)
		end
		local buttonpar = info.button
		colorpicker.frame.Visible = true
		colorpicker.borders.border1.Visible = true
		colorpicker.borders.border2.Visible = true
		colorpicker.borders.border3.Visible = true
		colorpicker.color.Visible = true
		colorpicker.colorimage.Visible = true
		colorpicker.colorborder.Visible = true
		colorpicker.colorcursor.Visible = true
		colorpicker.colorcursor2.Visible = true
		colorpicker.hue.Visible = true
		colorpicker.hueborder.Visible = true
		colorpicker.huecursor.Visible = true
		colorpicker.huecursor2.Visible = true
		colorpicker.transparency.Visible = transparency
		colorpicker.transpborder.Visible = transparency
		colorpicker.transpcursor.Visible = transparency
		colorpicker.transpcursor2.Visible = transparency
		--
		colorpicker.frame.Size = framesize
		colorpicker.borders.border3.Size = udim2.snew(0,145+10,0,framesize.y+10)
		colorpicker.borders.border2.Size = udim2.snew(0,145+8,0,framesize.y+8)
		colorpicker.borders.border1.Size = udim2.snew(0,145+2,0,framesize.y+2)
		colorpicker.frame.Position = udim2.pnew(1,10,0,2,buttonpar)
		colorpicker.borders.border3.Position = udim2.pnew(0,-5,0,-5,colorpicker.frame)
		colorpicker.borders.border2.Position = udim2.pnew(0,-4,0,-4,colorpicker.frame)
		colorpicker.borders.border1.Position = udim2.pnew(0,-1,0,-1,colorpicker.frame)
		colorpicker.color.Position = udim2.pnew(0,5,0,5,colorpicker.frame)
		colorpicker.colorimage.Position = udim2.pnew(0,5,0,5,colorpicker.frame)
		colorpicker.colorborder.Position = udim2.pnew(0,0,0,0,colorpicker.color)
		colorpicker.colorcursor.Position = udim2.pnew(0,-2,0,-2,colorpicker.color)
		colorpicker.colorcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.colorcursor)
		colorpicker.hue.Position = udim2.pnew(1,5,0,0,colorpicker.color)
		colorpicker.hueborder.Position = udim2.pnew(0,0,0,0,colorpicker.hue)
		colorpicker.huecursor.Position = udim2.pnew(0,-1,0,-2,colorpicker.hue)
		colorpicker.huecursor2.Position = udim2.pnew(0,1,0,1,colorpicker.huecursor)
		colorpicker.transparency.Position = udim2.pnew(0,0,1,5,colorpicker.color)
		colorpicker.transpborder.Position = udim2.pnew(0,0,0,0,colorpicker.transparency)
		colorpicker.transpcursor.Position = udim2.pnew(0,-2,0,-1,colorpicker.transparency)
		colorpicker.transpcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.transpcursor)
		--
		local defcolor = currentcpcolor
		local deftransp = currenttransparency
		local h,s,v = defcolor:ToHSV()
		currentcpcolortable = {h,s,v,deftransp}
		--
		local xmove = s
		local ymove = 1-v
		local hymove = 1-h
		local tymove = deftransp
		cx = xmove
		cy = ymove
		cyy = hymove
		ty = tymove
		local msX = xmove
		local msY = ymove
		if msX<0 then msX=0 end
		if msX>1 then msX=1 end
		if msY<0 then msY=0 end
		if msY>1 then msY=1 end
		local toX = colorpicker.color.Size.x-(colorpicker.color.Size.x*msX)
		local toY = colorpicker.color.Size.y-(colorpicker.color.Size.y*msY)
		local toaddX = 0
		local toaddY = 0
		if toX <= colorpicker.colorcursor.Size.x then
			toaddX = -(colorpicker.colorcursor.Size.x-toX)
		end
		if toY <= colorpicker.colorcursor.Size.y then
			toaddY = -(colorpicker.colorcursor.Size.y-toY)
		end
		colorpicker.color.Color = Color3.fromHSV(h,1,1)
		colorpicker.colorcursor.Position = udim2.pnew(xmove,toaddX,ymove,toaddY,colorpicker.color)
		colorpicker.colorcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.colorcursor)
		colorpicker.huecursor.Position = udim2.pnew(0,-1,hymove,0,colorpicker.hue)
		colorpicker.huecursor2.Position = udim2.pnew(0,1,0,1,colorpicker.huecursor)
		colorpicker.transpcursor.Position = udim2.pnew(tymove,0,0,-1,colorpicker.transparency)
		colorpicker.transpcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.transpcursor)
		--
	end
end
--
library.movehue = function()
	local msY = cyy
	if msY<0 then msY=0 end
	if msY>1 then msY=1 end
	local toY = colorpicker.hue.Size.y-(colorpicker.hue.Size.y*msY)
	local toaddY = 0
	local cyy = msY
	if toY <= colorpicker.huecursor.Size.y then
		toaddY = -(colorpicker.huecursor.Size.y-toY)
	end
	colorpicker.huecursor.Position = udim2.pnew(0,-1,cyy,toaddY,colorpicker.hue)
	colorpicker.huecursor2.Position = udim2.pnew(0,1,0,1,colorpicker.huecursor)
	currentcpcolortable[1] = 1-msY
	colorpicker.color.Color = Color3.fromHSV(currentcpcolortable[1],1,1)
	currentcolorpicker.button.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3]-(0.5*currentcpcolortable[3]))
	currentcolorpicker.color.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
	for i,v in pairs(colorpickers) do
		if v.button == currentcolorpicker.button then
			v.cpcolor = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
		end
	end
end
--
library.movetransp = function()
	local msX = ty
	if msX<0 then msX=0 end
	if msX>1 then msX=1 end
	local toY = colorpicker.transparency.Size.x-(colorpicker.transparency.Size.x*msX)
	local toaddX = 0
	local ty = msX
	if toY <= colorpicker.transpcursor.Size.x then
		toaddX = -(colorpicker.transpcursor.Size.x-toY)
	end
	colorpicker.transpcursor.Position = udim2.pnew(ty,toaddX,0,-1,colorpicker.transparency)
	colorpicker.transpcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.transpcursor)
	currentcpcolortable[4] = 1-msX
	currentcolorpicker.button.Transparency = currentcpcolortable[4]
	currentcolorpicker.color.Transparency = currentcpcolortable[4]
	for i,v in pairs(colorpickers) do
		if v.button == currentcolorpicker.button then
			v.transp = currentcpcolortable[4]
		end
	end
end
--
library.movecpmouse = function()
	local msX = cx
	local msY = cy
	if msX<0 then msX=0 end
	if msX>1 then msX=1 end
	if msY<0 then msY=0 end
	if msY>1 then msY=1 end
	local toX = colorpicker.color.Size.x-(colorpicker.color.Size.x*msX)
	local toY = colorpicker.color.Size.y-(colorpicker.color.Size.y*msY)
	local toaddX = 0
	local toaddY = 0
	local cx = msX
	local cy = msY
	if toX <= colorpicker.colorcursor.Size.x then
		toaddX = -(colorpicker.colorcursor.Size.x-toX)
	end
	if toY <= colorpicker.colorcursor.Size.y then
		toaddY = -(colorpicker.colorcursor.Size.y-toY)
	end
	currentcpcolortable[2] = msX
	currentcpcolortable[3] = 1-msY
	cppos = udim2.pnew(cx,toaddX,cy,toaddY,colorpicker.color)
	colorpicker.colorcursor.Position = cppos
	colorpicker.colorcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.colorcursor)
	currentcolorpicker.button.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3]-(0.5*currentcpcolortable[3]))
	currentcolorpicker.color.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
	for i,v in pairs(colorpickers) do
		if v.button == currentcolorpicker.button then
			v.cpcolor = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
		end
	end
	library.movehue()
	library.movetransp()
end
--
library.movecolorpicker = function()
	if colorpicker and colorpickerenabled then
		local buttonpar = currentcolorpicker.button
		colorpicker.borders.border3.Size = udim2.snew(0,145+10,0,colorpicker.frame.Size.y+10)
		colorpicker.borders.border2.Size = udim2.snew(0,145+8,0,colorpicker.frame.Size.y+8)
		colorpicker.borders.border1.Size = udim2.snew(0,145+2,0,colorpicker.frame.Size.y+2)
		colorpicker.frame.Position = udim2.pnew(1,10,0,2,buttonpar)
		colorpicker.borders.border3.Position = udim2.pnew(0,-5,0,-5,colorpicker.frame)
		colorpicker.borders.border2.Position = udim2.pnew(0,-4,0,-4,colorpicker.frame)
		colorpicker.borders.border1.Position = udim2.pnew(0,-1,0,-1,colorpicker.frame)
		colorpicker.color.Position = udim2.pnew(0,5,0,5,colorpicker.frame)
		colorpicker.colorimage.Position = udim2.pnew(0,5,0,5,colorpicker.frame)
		colorpicker.colorborder.Position = udim2.pnew(0,0,0,0,colorpicker.color)
		colorpicker.hue.Position = udim2.pnew(1,5,0,0,colorpicker.color)
		colorpicker.hueborder.Position = udim2.pnew(0,0,0,0,colorpicker.hue)
		colorpicker.huecursor.Position = udim2.pnew(0,-1,0,-2,colorpicker.hue)
		colorpicker.huecursor2.Position = udim2.pnew(0,1,0,1,colorpicker.huecursor)
		colorpicker.transparency.Position = udim2.pnew(0,0,1,5,colorpicker.color)
		colorpicker.transpborder.Position = udim2.pnew(0,0,0,0,colorpicker.transparency)
		colorpicker.transpcursor.Position = udim2.pnew(0,-2,0,-1,colorpicker.transparency)
		colorpicker.transpcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.transpcursor)
		--
		library.movecpmouse()
	end
end
--
library.closecolorpicker = function()
	if colorpicker then
		colorpicker.frame.Visible = false
		colorpicker.borders.border1.Visible = false
		colorpicker.borders.border2.Visible = false
		colorpicker.borders.border3.Visible = false
		colorpicker.color.Visible = false
		colorpicker.colorimage.Visible = false
		colorpicker.colorborder.Visible = false
		colorpicker.colorcursor.Visible = false
		colorpicker.colorcursor2.Visible = false
		colorpicker.hue.Visible = false
		colorpicker.hueborder.Visible = false
		colorpicker.huecursor.Visible = false
		colorpicker.huecursor2.Visible = false
		colorpicker.transparency.Visible = false
		colorpicker.transpborder.Visible = false
		colorpicker.transpcursor.Visible = false
		colorpicker.transpcursor2.Visible = false
		colorpickerenabled = false
		currentcolorpicker = nil
		currentcpcolor = nil
	end
end
--
library.init = function()
	library.makecolorpicker()
end
--
library.updatecursor()
--//
library.disablemovement = function()
	controls:Disable()
	zoom = (workspace.CurrentCamera.CoordinateFrame.p - plr.Character.Head.Position).magnitude
	plr.CameraMaxZoomDistance = zoom
	plr.CameraMinZoomDistance = zoom
end
--
library.enablemovement = function()
	controls:Enable()
	plr.CameraMaxZoomDistance = maxzoom
	plr.CameraMinZoomDistance = minzoom
end
--
library.opentab = function(tab)
	for i,v in pairs(tabs) do
		if v.tab == tab then
			v.tb.Color = Color3.fromRGB(35, 35, 35)
			v.open = true
		end
	end
	for i,v in pairs(sections) do
		if v.tab == tab then
			v.section.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
			v.label.Visible = true
			v.open = true
		end
	end
	for i,v in pairs(buttons) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.label.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	for i,v in pairs(toggles) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.label.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	for i,v in pairs(sliders) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.slider.Visible = true
			v.label.Visible = true
			v.label2.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	for i,v in pairs(textboxs) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.label.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	for i,v in pairs(keybinds) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.label.Visible = true
			v.value.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	for i,v in pairs(dropdowns) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.line.Visible = true
			v.label.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	if ddenabled and ddcontent then
		for i,v in pairs(ddcontent) do
			v.button:Remove()
			v.label:Remove()
			for z,x in pairs(v.borders) do
				x:Remove()
			end
		end
		ddcontent = nil
		ddenabled = false
	end
	for i,v in pairs(colorpickers) do
		if v.tab == tab then
			v.open = true
			v.button.Visible = true
			v.color.Visible = true
			v.label.Visible = true
			for z,x in pairs(v.borders) do
				x.Visible = true
			end
		end
	end
	library.updatecursor()
	library.closecolorpicker()
end
--
library.closetab = function(tab,leave)
	for i,v in pairs(tabs) do
		if v.tab == tab then
			v.tb.Color = Color3.fromRGB(20, 20, 20)
			v.open = false
			if leave then
				v.lastopen = true
			end
		end
	end
	for i,v in pairs(sections) do
		if v.tab == tab then
			v.section.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
			v.label.Visible = false
			v.open = false
		end
	end
	for i,v in pairs(buttons) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.label.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	for i,v in pairs(toggles) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.label.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	for i,v in pairs(sliders) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.slider.Visible = false
			v.label.Visible = false
			v.label2.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	for i,v in pairs(buttons) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.label.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	for i,v in pairs(textboxs) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.label.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	for i,v in pairs(keybinds) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.label.Visible = false
			v.value.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	for i,v in pairs(dropdowns) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.line.Visible = false
			v.label.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	if ddenabled and ddcontent then
		for i,v in pairs(ddcontent) do
			v.button:Remove()
			v.label:Remove()
			for z,x in pairs(v.borders) do
				x:Remove()
			end
		end
		ddcontent = nil
		ddenabled = false
	end
	for i,v in pairs(colorpickers) do
		if v.tab == tab then
			v.open = false
			v.button.Visible = false
			v.color.Visible = false
			v.label.Visible = false
			for z,x in pairs(v.borders) do
				x.Visible = false
			end
		end
	end
	library.updatecursor()
	library.closecolorpicker()
end
--
local libraryopen = true
--
library.closeui = function()
	for i,v in pairs(tabs) do
		if v.open then
			library.closetab(v.tab,true)
		end
		v.tab.Visible = false
	end
	--
	local topbar = main[1].topbar
	--
	main[1].frame.Visible = false
	main[1].tabbar.Visible = false
	--
	for i,v in pairs(main[1].borders.tabbar) do
		v.Visible = false
	end
	--
	for i,v in pairs(main[1].borders.topbar) do
		v.Visible = false
	end
	--
	for i,v in pairs(tabs) do
		v.tb.Visible = false
		v.tbborder.Visible = false
		v.tbtext.Visible = false
	end
	--
	local border3 = main[1].borders.mainui.border3
	border3.Size = udim2.snew(1,10,1,10,topbar)
	border3.Position = udim2.pnew(0,-5,0,-5,topbar)
	--
	local border2 = main[1].borders.mainui.border2
	border2.Size = udim2.snew(1,8,1,8,topbar)
	border2.Position = udim2.pnew(0,-4,0,-4,topbar)
	--
	local border1 = main[1].borders.mainui.border1
	border1.Size = udim2.snew(1,2,1,2,topbar)
	border1.Position = udim2.pnew(0,-1,0,-1,topbar)
	--
	libraryopen = false
end
--
library.openui = function()
	for i,v in pairs(tabs) do
		if v.lastopen then
			library.opentab(v.tab)
			v.lastopen = false
		end
		v.tab.Visible = true
	end
	--
	local topbar = main[1].topbar
	--
	main[1].frame.Visible = true
	main[1].tabbar.Visible = true
	--
	for i,v in pairs(main[1].borders.tabbar) do
		v.Visible = true
	end
	--
	for i,v in pairs(main[1].borders.topbar) do
		v.Visible = true
	end
	--
	for i,v in pairs(tabs) do
		v.tb.Visible = true
		v.tbborder.Visible = true
		v.tbtext.Visible = true
	end
	--
	local border3 = main[1].borders.mainui.border3
	border3.Size = udim2.snew(1,10,1,10,main[1].frame)
	border3.Position = udim2.pnew(0,-5,0,-5,main[1].frame)
	--
	local border2 = main[1].borders.mainui.border2
	border2.Size = udim2.snew(1,8,1,8,main[1].frame)
	border2.Position = udim2.pnew(0,-4,0,-4,main[1].frame)
	--
	local border1 = main[1].borders.mainui.border1
	border1.Size = udim2.snew(1,2,1,2,main[1].frame)
	border1.Position = udim2.pnew(0,-1,0,-1,main[1].frame)
	--
	libraryopen = true
end
--
library.new = function(info)
	mousedisable = info.mousedisable
	-- mainframe border
	local bordercolor = info.bordercolor or Color3.fromRGB(0, 0, 0)
	local border3 = instance.new("Frame")
	border3.Size = udim2.snew(0,info.size.x+10,0,info.size.y+10+43+20)
	border3.Color = bordercolor
	--
	local border2 = instance.new("Frame")
	border2.Size = udim2.snew(0,info.size.x+8,0,info.size.y+8+43+20)
	border2.Color = Color3.fromRGB(20, 20, 20)
	--
	local border1 = instance.new("Frame")
	border1.Size = udim2.snew(0,info.size.x+2,0,info.size.y+2+43+20)
	border1.Color = bordercolor
	--
	local frame = instance.new("Frame")
	frame.Size = udim2.snew(0,info.size.x,0,info.size.y+43+20)
	frame.Color = Color3.fromRGB(30, 30, 30)
	frame.Position = udim2.pnew(0.5,8-(frame.Size.x/2),0.5,8-(frame.Size.y/2))
	--
	border1.Position = udim2.pnew(0,-1,0,-1,frame)
	border2.Position = udim2.pnew(0,-4,0,-4,frame)
	border3.Position = udim2.pnew(0,-4,0,-4,frame)
	--
	local topbar = instance.new("Frame")
	topbar.Size = udim2.snew(1,0,0,15,frame)
	topbar.Position = udim2.pnew(0,0,0,0,frame)
	topbar.Color = Color3.fromRGB(20, 20, 20)
	--
	local minimize1 = instance.new("Frame")
	minimize1.Size = udim2.snew(0,10,0,2,topbar)
	minimize1.Position = udim2.pnew(1,-15,0.5,-1,topbar)
	minimize1.Color = Color3.fromRGB(255, 255, 255)
	--
	local tabbar = instance.new("Frame")
	tabbar.Size = udim2.snew(1,0,0,20,frame)
	tabbar.Position = udim2.pnew(0,0,1,4,topbar)
	tabbar.Color = Color3.fromRGB(25, 25, 25)
	-- topbar border
	local border4 = instance.new("Frame")
	border4.Size = udim2.snew(0,info.size.x,0,1)
	border4.Color = bordercolor
	border4.Position = udim2.pnew(0,0,1,0,topbar)
	--
	local border5 = instance.new("Frame")
	border5.Size = udim2.snew(0,info.size.x,0,2)
	border5.Color = Color3.fromRGB(20, 20, 20)
	border5.Position = udim2.pnew(0,0,1,0,border4)
	--
	local border6 = instance.new("Frame")
	border6.Size = udim2.snew(0,info.size.x,0,1)
	border6.Color = bordercolor
	border6.Position = udim2.pnew(0,0,1,0,border5)
	-- tabbar border
	local border7 = instance.new("Frame")
	border7.Size = udim2.snew(0,info.size.x,0,1)
	border7.Color = bordercolor
	border7.Position = udim2.pnew(0,0,1,0,tabbar)
	--
	local border8 = instance.new("Frame")
	border8.Size = udim2.snew(0,info.size.x,0,2)
	border8.Color = Color3.fromRGB(20, 20, 20)
	border8.Position = udim2.pnew(0,0,1,0,border7)
	--
	local border9 = instance.new("Frame")
	border9.Size = udim2.snew(0,info.size.x,0,1)
	border9.Color = bordercolor
	border9.Position = udim2.pnew(0,0,1,0,border8)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Position = udim2.pnew(0,5,0.5,-(label.TextBounds.Y/2),topbar)
	local borders = {
		mainui = {
			border1 = border1,
			border2 = border2,
			border3 = border3
		},
		topbar = {
			border4 = border4,
			border5 = border5,
			border6 = border6
		},
		tabbar = {
			border7 = border7,
			border8 = border8,
			border9 = border9
		}
	}
	table.insert(main,{frame = frame,minimise = minimize1,borders = borders,topbar = topbar,tabbar = tabbar,label = label})
	return frame
end
--
library.newtab = function(info)
	local tabbutton = instance.new("Frame")
	tabbutton.Color = Color3.fromRGB(20, 20, 20)
	local border = instance.new("Frame")
	border.Color = Color3.fromRGB(0, 0, 0)
	local text = instance.new("TextLabel")
	text.Text = info.name
	text.Size = 12
	text.Center = true
	--
	local textboundsx = text.TextBounds.x
	local textboundsy = text.TextBounds.y
	tabbutton.Size = udim2.snew(0,textboundsx+15,1,0,main[1].tabbar)
	border.Size = udim2.snew(0,1,1,0,tabbutton)
	tabbutton.Position = udim2.pnew(0,main.tabbuttonx,0,0,main[1].tabbar)
	border.Position = udim2.pnew(1,0,0,0,tabbutton)
	text.Position = udim2.pnew(0.5,0,0.5,-(textboundsy/2),tabbutton)
	--
	local tab = instance.new("Frame")
	tab.Size = udim2.snew(1,0,1,-43,main[1].frame)
	tab.Position = udim2.pnew(0,0,0,43,main[1].frame)
	tab.Color = Color3.fromRGB(30, 30, 30)
	--
	table.insert(tabs,{name = info.name,open = false,lastopen = false,tab = tab,tb = tabbutton,tbborder = border,tbtext = text,tby = main.tabbuttonx,leftsectiony = 0,rightsectiony = 0})
	main.tabbuttonx = main.tabbuttonx+(textboundsx+15+1)
	return tab
end
--
library.newsection = function(info)
	local x = 0
	local y = 0
	local open = false
	if info.side == "left" then x = 10 else x = 165 end
	local sectionyname = info.side.."sectiony"
	for i,v in pairs(tabs) do if v.tab == info.tab then y = v[sectionyname] end end
	for i,v in pairs(tabs) do if v.tab == info.tab then open = v.open end end
	--
	local border3 = instance.new("Frame")
	border3.Size = udim2.snew(0,140+8,0,info.size+8)
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	border3.Position = udim2.pnew(0,x-4,0,10+y-4,info.tab)
	--
	local border2 = instance.new("Frame")
	border2.Size = udim2.snew(0,140+6,0,info.size+6)
	border2.Color = Color3.fromRGB(20, 20, 20)
	border2.Visible = open
	border2.Position = udim2.pnew(0,x-3,0,10+y-3,info.tab)
	--
	local border1 = instance.new("Frame")
	border1.Size = udim2.snew(0,140+2,0,info.size+2)
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	border1.Position = udim2.pnew(0,x-1,0,10+y-1,info.tab)
	--
	local section = instance.new("Frame")
	section.Size = udim2.snew(0,140,0,info.size,info.tab)
	section.Position = udim2.pnew(0,x,0,10+y,info.tab)
	section.Color = Color3.fromRGB(20, 20, 20)
	section.Visible = open
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Center = true
	label.Visible = false
	label.Position = udim2.pnew(0.5,0,0,-(label.TextBounds.Y/2),border2)
	--
	local borders = {
		border3 = border3,
		border2 = border2,
		border1 = border1
	}
	for i,v in pairs(tabs) do if v.tab == info.tab then v[sectionyname] = v[sectionyname]+info.size+15 end end
	table.insert(sections,{section = section,side = info.side,open = open,yaxis = 10,sy = y,label = label,tab = info.tab,borders = borders})
	library.updatecursor()
	return section
end
--
library.newbutton = function(info)
	local open = false
	local y = 0
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0.9,0,0,12,info.section)
	buttonframe.Position = udim2.pnew(0.5,-(buttonframe.Size.x/2),0,y,info.section)
	buttonframe.Color = Color3.fromRGB(20, 20, 20)
	buttonframe.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Center = true
	label.Visible = false
	label.Position = udim2.pnew(0.5,0,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+20+2 end end
	table.insert(buttons,{button = buttonframe,open = false,callback = info.callback,label = label,yb = y,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
library.newtoggle = function(info)
	local open = false
	local y = 0
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--
	local calc = ""
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0,12,0,12,info.section)
	buttonframe.Position = udim2.pnew(0.1,-(buttonframe.Size.x/2+1),0,y,info.section)
	buttonframe.Color = Color3.fromRGB(20, 20, 20)
	buttonframe.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Visible = false
	label.Position = udim2.pnew(1,7,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+20+2 end end
	table.insert(toggles,{button = buttonframe,open = false,callback = info.callback,enabled = false,ty = y,label = label,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
library.newslider = function(info)
	local maxinfo = info.max or 100
	local mininfo = info.min or 0
	local definfo = info.def or mininfo
	local ended = info.ended or false
	local open = false
	local y = 0
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0.9,0,0,6,info.section)
	buttonframe.Position = udim2.pnew(0.5,-(buttonframe.Size.x/2),0,y+10,info.section)
	buttonframe.Color = Color3.fromRGB(20, 20, 20)
	buttonframe.Visible = open
	--
	local slide = instance.new("Frame")
	slide.Size = udim2.snew(0,0,1,0,buttonframe)
	slide.Position = udim2.pnew(0,0,0,0,buttonframe)
	slide.Color = Color3.fromRGB(35, 35, 35)
	slide.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Center = false
	label.Visible = false
	label.Position = udim2.pnew(0,0,0,-16,buttonframe)
	--
	local label2 = instance.new("TextLabel")
	label2.Text = "0"
	label2.Size = 12
	label2.Center = false
	label2.Visible = false
	--
	local calc = buttonframe.Size.X/(maxinfo-mininfo)
	local xval = calc * (definfo-mininfo)
	slide.Size=udim2.snew(0,xval,1,0,buttonframe)
	label2.Text = tostring(definfo)
	label2.Position = udim2.pnew(1,-(label2.TextBounds.x),0,-16,buttonframe)
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+26 end end
	table.insert(sliders,{button = buttonframe,slider = slide,min = mininfo,max = maxinfo,open = false,sy = y,ended = ended,callback = info.callback,label = label,label2 = label2,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
library.newtextbox = function(info)
	local open = false
	local y = 0
	local original = info.name
	local lower = info.lower or false
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0.9,0,0,12,info.section)
	buttonframe.Position = udim2.pnew(0.5,-(buttonframe.Size.x/2),0,y,info.section)
	buttonframe.Color = Color3.fromRGB(20, 20, 20)
	buttonframe.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Center = true
	label.Visible = false
	label.Position = udim2.pnew(0.5,0,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+20+2 end end
	table.insert(textboxs,{button = buttonframe,lower = lower,original = original,open = false,ty = y,callback = info.callback,label = label,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
library.newkeybind = function(info)
	local open = false
	local y = 0
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--
	local calc = ""
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0,20,0,12,info.section)
	buttonframe.Position = udim2.pnew(1,-(buttonframe.Size.x)-7,0,y,info.section)
	buttonframe.Color = Color3.fromRGB(20, 20, 20)
	buttonframe.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Visible = open
	label.Position = udim2.pnew(-5.3,0,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
	--
	local value = instance.new("TextLabel")
	value.Text = info.def or "E"
	value.Size = 12
	value.Visible = open
	value.Center = true
	value.Position = udim2.pnew(0.5,0,0.5,-(value.TextBounds.Y/2)-1,buttonframe)
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+20+2 end end
	table.insert(keybinds,{button = buttonframe,open = false,callback = info.callback,enabled = false,ky = y,label = label,value = value,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
library.newdropdown = function(info)
	local open = false
	local y = 0
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0.9,0,0,12,info.section)
	buttonframe.Position = udim2.pnew(0.5,-(buttonframe.Size.x/2),0,y,info.section)
	buttonframe.Color = Color3.fromRGB(20, 20, 20)
	buttonframe.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Center = true
	label.Visible = open
	label.Position = udim2.pnew(0.5,0,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
	--
	local line = instance.new("Frame")
	line.Size = udim2.snew(0,5,0,1,buttonframe)
	line.Position = udim2.pnew(1,-12.5,0.5,-0.5,buttonframe)
	line.Color = Color3.fromRGB(255, 255, 255)
	line.Visible = open
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+20+2 end end
	table.insert(dropdowns,{button = buttonframe,options = info.options,line = line,open = false,callback = info.callback,label = label,yb = y,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
library.newcolorpicker = function(info)
	local default = info.def or Color3.fromRGB(255,255,255)
	local deftransp = info.transp or 0
	local h,s,v = default:ToHSV()
	local highercol = Color3.fromHSV(h,s,v-(0.5*v))
	local open = false
	local y = 0
	for i,v in pairs(sections) do if v.section == info.section then open = v.open end end
	for i,v in pairs(sections) do if v.section == info.section then y = v.yaxis end end
	--
	local border1 = instance.new("Frame")
	border1.Color = Color3.fromRGB(0,0,0)
	border1.Visible = open
	--
	local border2 = instance.new("Frame")
	border2.Color = Color3.fromRGB(20,20,20)
	border2.Visible = open
	--
	local border3 = instance.new("Frame")
	border3.Color = Color3.fromRGB(0,0,0)
	border3.Visible = open
	--	
	local buttonframe = instance.new("Frame")
	buttonframe.Size = udim2.snew(0,20,0,12,info.section)
	buttonframe.Position = udim2.pnew(1,-(buttonframe.Size.x)-7,0,y,info.section)
	buttonframe.Color = highercol
	buttonframe.Visible = open
	--
	local color = instance.new("Frame")
	color.Size = udim2.snew(0.8,0,0.6,0,buttonframe)
	color.Position = udim2.pnew(0.5,-(color.Size.x/2),0.5,-(color.Size.y/2),buttonframe)
	color.Color = default
	color.Visible = open
	--
	border1.Size = udim2.snew(1,6,1,6,buttonframe)
	border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
	--
	border2.Size = udim2.snew(1,4,1,4,buttonframe)
	border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
	--
	border3.Size = udim2.snew(1,2,1,2,buttonframe)
	border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
	--
	local label = instance.new("TextLabel")
	label.Text = info.name
	label.Size = 12
	label.Visible = open
	label.Position = udim2.pnew(-5.3,0,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
	--
	local borders = {
		border1 = border1,
		border2 = border2,
		border3 = border3
	}
	for i,v in pairs(sections) do if v.section == info.section then v.yaxis = v.yaxis+20+2 end end
	table.insert(colorpickers,{button = buttonframe,transparency = info.transparency,cpcolor = default,transp = deftransp,color = color,open = false,callback = info.callback,enabled = false,ky = y,label = label,borders = borders,section = info.section,tab = info.tab})
	library.updatecursor()
end
--
function mouseLocation()
	return uis:GetMouseLocation()
end
--
function mouseOver(Values)
	local X1, Y1, X2, Y2 = Values[1], Values[2], Values[3], Values[4]
	local ml = mouseLocation()
	return (ml.x >= X1 and ml.x <= (X1 + (X2 - X1))) and (ml.y >= Y1 and ml.y <= (Y1 + (Y2 - Y1)))
end
--
uis.InputBegan:Connect(function(input)
	if keybindin and currentkeybind then
		local character = ""
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			character = "Mouse1"
		end
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			character = "Mouse2"
		end
		if input.UserInputType == Enum.UserInputType.MouseButton3 then
			character = "Mouse3"
		end
		local allowed = false
		for i,v in pairs(keybindallowed) do
			if i == character then
				allowed = true
				character = v
			elseif v == character then
				allowed = true
			end
		end
		if allowed then
			currentkeybind.value.Text = character
			keybindin = false
			library.enablemovement()
			currentkeybind.button.Color = Color3.fromRGB(20,20,20)
			currentkeybind.callback(currentkeybind.value.Text)
			currentkeybind = nil
		end
	end
	if input.UserInputType.Name == 'MouseButton1' then
		if main[1].topbar then
			local vals = {
				main[1].topbar.Position.X-5;
				main[1].topbar.Position.Y-5;
				main[1].topbar.Position.X + main[1].topbar.Size.X+5;
				main[1].topbar.Position.Y + main[1].topbar.Size.Y+5;
			};
			if mouseOver(vals) then
				dragging = true
				dragX,dragY = mouseLocation().X-main[1].topbar.Position.X,mouseLocation().Y-main[1].topbar.Position.Y
			end
		end
		if main[1].minimise and main[1].topbar then
			local vals = {
				udim2.pnew(1,-15,0.5,-5,main[1].topbar).x-2;
				udim2.pnew(1,-15,0.5,-5,main[1].topbar).y-2;
				udim2.pnew(1,-15,0.5,-5,main[1].topbar).x + udim2.snew(0,10,0,10,main[1].topbar).x+2;
				udim2.pnew(1,-15,0.5,-5,main[1].topbar).y + udim2.snew(0,10,0,10,main[1].topbar).y+2;
			};
			if mouseOver(vals) then
				if libraryopen then
					library.closeui()
					libraryopen = false
				else
					library.openui()
					libraryopen = true
				end
			end
		end
		for i,v in pairs(tabs) do
			if libraryopen then
				local vals = {
					v.tb.Position.X;
					v.tb.Position.Y;
					v.tb.Position.X + v.tb.Size.X;
					v.tb.Position.Y + v.tb.Size.Y;
				};
				if mouseOver(vals) then
					if v.open then
						for z,x in pairs(tabs) do
							if x.open then
								library.closetab(x.tab)	
							end
						end
					else
						for z,x in pairs(tabs) do
							if x.open then
								library.closetab(x.tab)
							end
						end
						library.opentab(v.tab)
					end
				end
			end
		end
		for i,v in pairs(buttons) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			if mouseOver(vals) then
				if v.open then
					v.callback()
					spawn(function()
						v.button.Color = Color3.fromRGB(45, 45, 45)
						wait(0.1)
						v.button.Color = Color3.fromRGB(20, 20, 20)
					end)
				end
			end
		end
		for i,v in pairs(toggles) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			if mouseOver(vals) then
				if v.open then
					local val = false
					local col = Color3.fromRGB(20,20,20)
					if v.enabled then
						val = false
						v.enabled = false
						col = Color3.fromRGB(20,20,20)
					else
						val = true
						v.enabled = true
						col = Color3.fromRGB(45,45,45)
					end
					v.enabled = val
					v.callback(val)
					v.button.Color = col
				end
			end
		end
		for i, v in pairs(sliders) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3	;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			if v.open and mouseOver(vals) then
				sliderhold = true
				holdingslider = v
				v.slider.Color = Color3.fromRGB(45,45,45)
				local holder = holdingslider.button
				local slide = holdingslider.slider
				local label = holdingslider.label2
				local max = holdingslider.max
				local min = holdingslider.min
				local msX = (mouseLocation().X-holder.Position.X)
				if msX<0 then msX=0 end
				if msX>holder.Size.X then msX=holder.Size.X end
				slide.Size=Vector2.new(msX,slide.Size.y)
				local calc = (max-min)/holder.Size.x
				local result = calc * msX + min
				label.Text = tostring(math.floor(result))
				label.Position = udim2.pnew(1,-(label.TextBounds.x),0,-16,holder)
				if not holdingslider.ended then
					holdingslider.callback(math.floor(result))
				end
			end
		end
		if textboxin and currenttextbox and currenttextbox.label.Text ~= "" and currenttextbox.label.Text ~= nil then
			textboxin = false
			library.enablemovement()
			currenttextbox.button.Color = Color3.fromRGB(20,20,20)
			currenttextbox.callback(currenttextbox.label.Text)
			currenttextbox.label.Text = currenttextbox.original
			currenttextbox = nil
		end
		for i,v in pairs(textboxs) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			if mouseOver(vals) and textboxin == false then
				if v.open then
					library.disablemovement()
					textboxin = true
					v.label.Text = ""
					currenttextbox = v
					v.button.Color = Color3.fromRGB(35, 35, 35)
				end
			end
		end
		for i,v in pairs(keybinds) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			if mouseOver(vals) and textboxin == false then
				if v.open then
					library.disablemovement()
					keybindin = true
					currentkeybind = v
					v.button.Color = Color3.fromRGB(35, 35, 35)
				end
			end
		end
		if ddenabled and ddcontent then
			for i,v in pairs(ddcontent) do
				local vals = {
					v.button.Position.X-3;
					v.button.Position.Y-3;
					v.button.Position.X + v.button.Size.X+3;
					v.button.Position.Y + v.button.Size.Y+3;
				};
				if mouseOver(vals) then
					for z,x in pairs(dropdowns) do
						if x.button == v.buttonpar then	
							x.callback(v.name)
						end
					end
					for i,v in pairs(ddcontent) do
						v.button:Remove()
						v.label:Remove()
						for z,x in pairs(v.borders) do
							x:Remove()
						end
					end
					ddenabled = false
					ddcontent = nil
					break
				end
			end
		end
		for i,v in pairs(dropdowns) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			if mouseOver(vals) then
				if v.open then
					local buttonpar = nil
					if ddenabled and ddcontent then
						for i,v in pairs(ddcontent) do
							v.button:Remove()
							v.label:Remove()
							for z,x in pairs(v.borders) do
								x:Remove()
							end
							buttonpar = v.buttonpar
						end
						ddenabled = false
					end
					if buttonpar == v.button then 
						--
						ddcontent = nil
					else
						ddcontent = nil
						local tbl = {}
						local count = 0
						for ind,option in pairs(v.options) do
							local border1 = instance.new("Frame")
							border1.Color = Color3.fromRGB(0,0,0)
							border1.Visible = true
							--
							local border2 = instance.new("Frame")
							border2.Color = Color3.fromRGB(20,20,20)
							border2.Visible = true
							--
							local border3 = instance.new("Frame")
							border3.Color = Color3.fromRGB(0,0,0)
							border3.Visible = true
							--
							local buttonframe = instance.new("Frame")
							buttonframe.Size = udim2.snew(1,0,1,0,v.button)
							buttonframe.Position = udim2.pnew(0,0,ind,6*ind,v.button)
							buttonframe.Color = Color3.fromRGB(20, 20, 20)
							buttonframe.Visible = true
							--
							border1.Size = udim2.snew(1,6,1,6,buttonframe)
							border1.Position = udim2.pnew(0,-3,0,-3,buttonframe)
							--
							border2.Size = udim2.snew(1,4,1,4,buttonframe)
							border2.Position = udim2.pnew(0,-2,0,-2,buttonframe)
							--
							border3.Size = udim2.snew(1,2,1,2,buttonframe)
							border3.Position = udim2.pnew(0,-1,0,-1,buttonframe)
							--
							local label = instance.new("TextLabel")
							label.Text = option
							label.Size = 12
							label.Center = true
							label.Visible = true
							label.Position = udim2.pnew(0.5,0,0.5,-(label.TextBounds.Y/2)-1,buttonframe)
							local borders = {
								border1 = border1,
								border2 = border2,
								border3 = border3
							}
							table.insert(tbl,{name = option,button = buttonframe,label = label,borders = borders,ddy = Vector2.new(ind,6*ind),buttonpar = v.button})
						end
						ddenabled = true
						ddcontent = tbl
						library.updatecursor()
					end
				end
			end
		end
		for i,v in pairs(colorpickers) do
			local vals = {
				v.button.Position.X-3;
				v.button.Position.Y-3;
				v.button.Position.X + v.button.Size.X+3;
				v.button.Position.Y + v.button.Size.Y+3;
			};
			local trans = v.transparency or false
			if mouseOver(vals) then
				if v.open then
					if colorpickerenabled and currentcolorpicker == v then
						library.closecolorpicker()
						colorpickerenabled = false
						currentcolorpicker = nil
						currentcpcolor = nil
					else
						colorpickerenabled = true
						currentcolorpicker = v
						currentcolorpicker.transparency = trans
						currentcpcolor = v.cpcolor
						currenttransparency = v.transp
						library.opencolorpicker({button = v.button,transparency = trans})
					end
				end
			end
		end
		if colorpickerenabled then
			if colorpicker.color.Visible then
				local vals = {
					colorpicker.color.Position.X;
					colorpicker.color.Position.Y;
					colorpicker.color.Position.X + colorpicker.color.Size.X;
					colorpicker.color.Position.Y + colorpicker.color.Size.Y;
				};
				if mouseOver(vals) then
					colorhold = true
				end
			end
			if colorpicker.hue.Visible then
				local vals = {
					colorpicker.hue.Position.X;
					colorpicker.hue.Position.Y;
					colorpicker.hue.Position.X + colorpicker.hue.Size.X;
					colorpicker.hue.Position.Y + colorpicker.hue.Size.Y;
				};
				if mouseOver(vals) then
					huehold = true
				end
			end
			if colorpicker.transparency.Visible then
				local vals = {
					colorpicker.transparency.Position.X;
					colorpicker.transparency.Position.Y;
					colorpicker.transparency.Position.X + colorpicker.transparency.Size.X;
					colorpicker.transparency.Position.Y + colorpicker.transparency.Size.Y;
				};
				if mouseOver(vals) then
					transphold = true
				end
			end
		end
	elseif input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Return then
			if textboxin and currenttextbox then
				textboxin = false
				library.enablemovement()
				currenttextbox.button.Color = Color3.fromRGB(20,20,20)
				currenttextbox.callback(currenttextbox.label.Text)
				currenttextbox.label.Text = currenttextbox.original
				currenttextbox = nil
			end
		elseif input.KeyCode == Enum.KeyCode.Backspace then
			if textboxin and currenttextbox then
				currenttextbox.label.Text = currenttextbox.label.Text:gsub(".?$","")
			end
		else
			if textboxin and currenttextbox then
				local character = tostring(input.KeyCode.Name)
				local allowed = false
				for i,v in pairs(allowedcharacters) do
					if i == character then
						allowed = true
						character = v
					elseif v == character then
						allowed = true
					end
				end
				if currenttextbox.lower then
					character = string.lower(character)
				end
				if allowed then
					currenttextbox.label.Text = currenttextbox.label.Text..character
				end
			end
		end
		if keybindin and currentkeybind then
			local character = tostring(input.KeyCode.Name)
			local allowed = false
			for i,v in pairs(keybindallowed) do
				if i == character then
					allowed = true
					character = v
				elseif v == character then
					allowed = true
				end
			end
			if allowed then
				currentkeybind.value.Text = character
				keybindin = false
				library.enablemovement()
				currentkeybind.button.Color = Color3.fromRGB(20,20,20)
				currentkeybind.callback(currentkeybind.value.Text)
				currentkeybind = nil
			end
		end
	end
end)
--
uis.InputEnded:Connect(function(input)
	if input.UserInputType.Name == 'MouseButton1' and sliderhold then
		sliderhold = false
		holdingslider.slider.Color = Color3.fromRGB(35, 35, 35)
		if holdingslider.ended then
			holdingslider.callback(holdingslider.label2.Text)
		end
		holdingslider = nil
	elseif input.UserInputType.Name == 'MouseButton1' and dragging then
		dragging = false
	elseif input.UserInputType.Name == 'MouseButton1' and colorpickerenabled then
		colorhold = false
		huehold = false
		transphold = false
	end
end)
--
uis.InputChanged:Connect(function()
	if sliderhold and holdingslider then
		local holder = holdingslider.button
		local slide = holdingslider.slider
		local label = holdingslider.label2
		local max = holdingslider.max
		local min = holdingslider.min
		local msX = (mouseLocation().X-holder.Position.X)
		if msX<0 then msX=0 end
		if msX>holder.Size.X then msX=holder.Size.X end
		slide.Size=Vector2.new(msX,slide.Size.y)
		local calc = (max-min)/holder.Size.x
		local result = calc * msX + min
		label.Text = tostring(math.floor(result))
		label.Position = udim2.pnew(1,-(label.TextBounds.x),0,-16,holder)
		if not holdingslider.ended then
			holdingslider.callback(math.floor(result))
		end
	end
	if colorpickerenabled and colorhold then
		local msX = (mouseLocation().x-colorpicker.color.Position.x)/colorpicker.color.Size.x
		local msY = (mouseLocation().y-colorpicker.color.Position.y)/colorpicker.color.Size.y
		if msX<0 then msX=0 end
		if msX>1 then msX=1 end
		if msY<0 then msY=0 end
		if msY>1 then msY=1 end
		local toX = colorpicker.color.Size.x-(colorpicker.color.Size.x*msX)
		local toY = colorpicker.color.Size.y-(colorpicker.color.Size.y*msY)
		local toaddX = 0
		local toaddY = 0
		cx = msX
		cy = msY
		if toX <= colorpicker.colorcursor.Size.x then
			toaddX = -(colorpicker.colorcursor.Size.x-toX)
		end
		if toY <= colorpicker.colorcursor.Size.y then
			toaddY = -(colorpicker.colorcursor.Size.y-toY)
		end
		currentcpcolortable[2] = msX
		currentcpcolortable[3] = 1-msY
		cppos = udim2.pnew(cx,toaddX,cy,toaddY,colorpicker.color)
		colorpicker.colorcursor.Position = cppos
		colorpicker.colorcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.colorcursor)
		currentcolorpicker.button.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3]-(0.5*currentcpcolortable[3]))
		currentcolorpicker.color.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
		for i,v in pairs(colorpickers) do
			if v.button == currentcolorpicker.button then
				v.cpcolor = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
				v.callback(currentcpcolortable)
			end
		end
	end
	if colorpickerenabled and huehold then
		local msY = (mouseLocation().y-colorpicker.hue.Position.y)/colorpicker.hue.Size.y
		if msY<0 then msY=0 end
		if msY>1 then msY=1 end
		local toY = colorpicker.hue.Size.y-(colorpicker.hue.Size.y*msY)
		local toaddY = 0
		cyy = msY
		if toY <= colorpicker.huecursor.Size.y then
			toaddY = -(colorpicker.huecursor.Size.y-toY)
		end
		colorpicker.huecursor.Position = udim2.pnew(0,-1,cyy,toaddY,colorpicker.hue)
		colorpicker.huecursor2.Position = udim2.pnew(0,1,0,1,colorpicker.huecursor)
		currentcpcolortable[1] = 1-msY
		colorpicker.color.Color = Color3.fromHSV(currentcpcolortable[1],1,1)
		currentcolorpicker.button.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3]-(0.5*currentcpcolortable[3]))
		currentcolorpicker.color.Color = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
		for i,v in pairs(colorpickers) do
			if v.button == currentcolorpicker.button then
				v.cpcolor = Color3.fromHSV(currentcpcolortable[1],currentcpcolortable[2],currentcpcolortable[3])
				v.callback(currentcpcolortable)
			end
		end
	end
	if colorpickerenabled and transphold then
		local msX = (mouseLocation().x-colorpicker.transparency.Position.x)/colorpicker.transparency.Size.x
		if msX<0 then msX=0 end
		if msX>1 then msX=1 end
		local toX = colorpicker.transparency.Size.x-(colorpicker.transparency.Size.x*msX)
		local toaddY = 0
		ty = msX
		if toX <= colorpicker.transpcursor.Size.x then
			toaddY = -(colorpicker.transpcursor.Size.x-toX)
		end
		colorpicker.transpcursor.Position = udim2.pnew(ty,toaddY,0,-1,colorpicker.transparency)
		colorpicker.transpcursor2.Position = udim2.pnew(0,1,0,1,colorpicker.transpcursor)
		currentcpcolortable[4] = msX
		currentcolorpicker.button.Transparency = 1-currentcpcolortable[4]
		currentcolorpicker.color.Transparency = 1-currentcpcolortable[4]
		for i,v in pairs(colorpickers) do
			if v.button == currentcolorpicker.button then
				v.transp = currentcpcolortable[4]
				v.callback(currentcpcolortable)
			end
		end
	end
	if dragging then
		local msX,msY = mouseLocation().X-dragX,mouseLocation().Y-dragY
		if msX <= 8 then 
			msX = 8 
		elseif msX >= cc.ViewportSize.x-(main[1].frame.Size.x+8) then 
			msX = cc.ViewportSize.x-(main[1].frame.Size.x+8)
		end
		if msY <= 8 then 
			msY = 8 
		elseif msY >= cc.ViewportSize.y-(main[1].frame.Size.y+8) then 
			msY = cc.ViewportSize.y-(main[1].frame.Size.y+8)
		end
		main[1].frame.Position = Vector2.new(msX,msY)
		main[1].borders.mainui.border3.Position = udim2.pnew(0,-5,0,-5,main[1].frame)
		main[1].borders.mainui.border2.Position = udim2.pnew(0,-4,0,-4,main[1].frame)
		main[1].borders.mainui.border1.Position = udim2.pnew(0,-1,0,-1,main[1].frame)
		main[1].topbar.Position = Vector2.new(msX,msY)
		main[1].borders.topbar.border4.Position = udim2.pnew(0,0,1,0,main[1].topbar)
		main[1].borders.topbar.border5.Position = udim2.pnew(0,0,1,0,main[1].borders.topbar.border4)
		main[1].borders.topbar.border6.Position = udim2.pnew(0,0,1,0,main[1].borders.topbar.border5)
		main[1].label.Position = udim2.pnew(0,5,0.5,-(main[1].label.TextBounds.Y/2),main[1].topbar)
		main[1].minimise.Position = udim2.pnew(1,-15,0.5,-1,main[1].topbar)
		main[1].tabbar.Position = udim2.pnew(0,0,1,4,main[1].topbar)
		main[1].borders.tabbar.border7.Position = udim2.pnew(0,0,1,0,main[1].tabbar)
		main[1].borders.tabbar.border8.Position = udim2.pnew(0,0,1,0,main[1].borders.tabbar.border7)
		main[1].borders.tabbar.border9.Position = udim2.pnew(0,0,1,0,main[1].borders.tabbar.border8)
		--
		for i,v in pairs(tabs) do
			v.tb.Position = udim2.pnew(0,v.tby,0,0,main[1].tabbar)
			v.tbtext.Position = udim2.pnew(0.5,0,0.5,-(v.tbtext.TextBounds.y/2),v.tb)
			v.tbborder.Position = udim2.pnew(1,0,0,0,v.tb)
			v.tab.Position = udim2.pnew(0,0,0,43,main[1].frame)
		end
		--
		for i,v in pairs(sections) do
			local x = 0
			if v.side == "left" then x = 10 else x = 165 end
			v.section.Position = udim2.pnew(0,x,0,10+v.sy,v.tab)
			v.borders.border3.Position = udim2.pnew(0,-4,0,-4,v.section)
			v.borders.border2.Position = udim2.pnew(0,-3,0,-3,v.section)
			v.borders.border1.Position = udim2.pnew(0,-1,0,-1,v.section)
			v.label.Position = udim2.pnew(0.5,0,0,-(v.label.TextBounds.Y/2),v.borders.border2)
		end
		--
		for i,v in pairs(buttons) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.yb,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(toggles) do
			v.button.Position = udim2.pnew(0.1,-(v.button.Size.x/2+1),0,v.ty,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(1,7,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(sliders) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.sy+10,v.section)
			v.slider.Position = udim2.pnew(0,0,0,0,v.button)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0,0,0,-16,v.button)
			v.label2.Position = udim2.pnew(1,-(v.label2.TextBounds.x),0,-16,v.button)
		end
		for i,v in pairs(textboxs) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.ty,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(keybinds) do
			v.button.Position = udim2.pnew(1,-(v.button.Size.x)-7,0,v.ky,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(-5.3,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
			v.value.Position = udim2.pnew(0.5,0,0.5,-(v.value.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(dropdowns) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.yb,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
			v.line.Position = udim2.pnew(1,-12.5,0.5,-0.5,v.button)
			if ddenabled and ddcontent then
				for i,v in pairs(ddcontent) do
					v.button.Position = udim2.pnew(0,0,v.ddy.x,v.ddy.y,v.buttonpar)
					v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
					v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
					v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
					v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
				end
			end
		end
		for i,v in pairs(colorpickers) do
			v.button.Position = udim2.pnew(1,-(v.button.Size.x)-7,0,v.ky,v.section)
			v.color.Position = udim2.pnew(0.5,-(v.color.Size.x/2),0.5,-(v.color.Size.y/2),v.button)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(-5.3,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		library.movecolorpicker()
	end
end)
--
rs.RenderStepped:Connect(function()
	if cursor ~= nil then
		if main[1] and main[1].frame then
			local vals = ""
			local vals2 = ""
			if main[1].frame.Visible then
				vals = {
					main[1].frame.Position.X-5;
					main[1].frame.Position.Y-5;
					main[1].frame.Position.X + main[1].frame.Size.X+5;
					main[1].frame.Position.Y + main[1].frame.Size.Y+5;
				};
			else
				vals = {
					main[1].topbar.Position.X-5;
					main[1].topbar.Position.Y-5;
					main[1].topbar.Position.X + main[1].topbar.Size.X+5;
					main[1].topbar.Position.Y + main[1].topbar.Size.Y+5;
				};
			end
			local found = false
			if mouseOver(vals) then
				cursorenabled = true
				local ml = mouseLocation()
				local x,y = cursor.Size.x/2,cursor.Size.y/2
				local calc = Vector2.new(ml.x-x,ml.y-y)
				cursor.Visible = true
				cursor.Position = calc
				found = true
			elseif ddenabled and ddcontent then
				for i,v in pairs(ddcontent) do
					local vals = {
						v.button.Position.X-3;
						v.button.Position.Y-3;
						v.button.Position.X + v.button.Size.X+3;
						v.button.Position.Y + v.button.Size.Y+3;
					};
					if mouseOver(vals) then
						cursorenabled = true
						local ml = mouseLocation()
						local x,y = cursor.Size.x/2,cursor.Size.y/2
						local calc = Vector2.new(ml.x-x,ml.y-y)
						cursor.Visible = true
						cursor.Position = calc
						found = true
					end
				end
			elseif colorpickerenabled and currentcolorpicker then
				local vals = {
					colorpicker.frame.Position.X-5;
					colorpicker.frame.Position.Y-5;
					colorpicker.frame.Position.X + colorpicker.frame.Size.X+5;
					colorpicker.frame.Position.Y + colorpicker.frame.Size.Y+5;
				};
				if mouseOver(vals) then
					cursorenabled = true
					local ml = mouseLocation()
					local x,y = cursor.Size.x/2,cursor.Size.y/2
					local calc = Vector2.new(ml.x-x,ml.y-y)
					cursor.Visible = true
					cursor.Position = calc
					found = true
				end
			end
			if found then
				if mousedisable then 
					uis.MouseIconEnabled = false
				end
			else
				if mousedisable then 
					uis.MouseIconEnabled = true
				end
				cursorenabled = false
			end
		end
	end
	if cc.ViewportSize.x < currentccx or cc.ViewportSize.x > currentccx then
		currentccx = cc.ViewportSize.x
		local msX,msY = udim2.pnew(0.5,8-(main[1].frame.Size.x/2),0.5,8-(main[1].frame.Size.y/2)).x,udim2.pnew(0.5,8-(main[1].frame.Size.x/2),0.5,8-(main[1].frame.Size.y/2)).y
		main[1].frame.Position = Vector2.new(msX,msY)
		main[1].borders.mainui.border3.Position = udim2.pnew(0,-5,0,-5,main[1].frame)
		main[1].borders.mainui.border2.Position = udim2.pnew(0,-4,0,-4,main[1].frame)
		main[1].borders.mainui.border1.Position = udim2.pnew(0,-1,0,-1,main[1].frame)
		main[1].topbar.Position = Vector2.new(msX,msY)
		main[1].borders.topbar.border4.Position = udim2.pnew(0,0,1,0,main[1].topbar)
		main[1].borders.topbar.border5.Position = udim2.pnew(0,0,1,0,main[1].borders.topbar.border4)
		main[1].borders.topbar.border6.Position = udim2.pnew(0,0,1,0,main[1].borders.topbar.border5)
		main[1].label.Position = udim2.pnew(0,5,0.5,-(main[1].label.TextBounds.Y/2),main[1].topbar)
		main[1].minimise.Position = udim2.pnew(1,-15,0.5,-1,main[1].topbar)
		main[1].tabbar.Position = udim2.pnew(0,0,1,4,main[1].topbar)
		main[1].borders.tabbar.border7.Position = udim2.pnew(0,0,1,0,main[1].tabbar)
		main[1].borders.tabbar.border8.Position = udim2.pnew(0,0,1,0,main[1].borders.tabbar.border7)
		main[1].borders.tabbar.border9.Position = udim2.pnew(0,0,1,0,main[1].borders.tabbar.border8)
		--
		for i,v in pairs(tabs) do
			v.tb.Position = udim2.pnew(0,v.tby,0,0,main[1].tabbar)
			v.tbtext.Position = udim2.pnew(0.5,0,0.5,-(v.tbtext.TextBounds.y/2),v.tb)
			v.tbborder.Position = udim2.pnew(1,0,0,0,v.tb)
			v.tab.Position = udim2.pnew(0,0,0,43,main[1].frame)
		end
		--
		for i,v in pairs(sections) do
			local x = 0
			if v.side == "left" then x = 10 else x = 165 end
			v.section.Position = udim2.pnew(0,x,0,10+v.sy,v.tab)
			v.borders.border3.Position = udim2.pnew(0,-4,0,-4,v.section)
			v.borders.border2.Position = udim2.pnew(0,-3,0,-3,v.section)
			v.borders.border1.Position = udim2.pnew(0,-1,0,-1,v.section)
			v.label.Position = udim2.pnew(0.5,0,0,-(v.label.TextBounds.Y/2),v.borders.border2)
		end
		--
		for i,v in pairs(buttons) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.yb,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(toggles) do
			v.button.Position = udim2.pnew(0.1,-(v.button.Size.x/2+1),0,v.ty,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(1,7,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(sliders) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.sy+10,v.section)
			v.slider.Position = udim2.pnew(0,0,0,0,v.button)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0,0,0,-16,v.button)
			v.label2.Position = udim2.pnew(1,-(v.label2.TextBounds.x),0,-16,v.button)
		end
		for i,v in pairs(textboxs) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.ty,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(keybinds) do
			v.button.Position = udim2.pnew(1,-(v.button.Size.x)-7,0,v.ky,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(-5.3,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
			v.value.Position = udim2.pnew(0.5,0,0.5,-(v.value.TextBounds.Y/2)-1,v.button)
		end
		for i,v in pairs(dropdowns) do
			v.button.Position = udim2.pnew(0.5,-(v.button.Size.x/2),0,v.yb,v.section)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
			v.line.Position = udim2.pnew(1,-12.5,0.5,-0.5,v.button)
			if ddenabled and ddcontent then
				for i,v in pairs(ddcontent) do
					v.button.Position = udim2.pnew(0,0,v.ddy.x,v.ddy.y,v.buttonpar)
					v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
					v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
					v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
					v.label.Position = udim2.pnew(0.5,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
				end
			end
		end
		for i,v in pairs(colorpickers) do
			v.button.Position = udim2.pnew(1,-(v.button.Size.x)-7,0,v.ky,v.section)
			v.color.Position = udim2.pnew(0.5,-(v.color.Size.x/2),0.5,-(v.color.Size.y/2),v.button)
			v.borders.border1.Position = udim2.pnew(0,-3,0,-3,v.button)
			v.borders.border2.Position = udim2.pnew(0,-2,0,-2,v.button)
			v.borders.border3.Position = udim2.pnew(0,-1,0,-1,v.button)
			v.label.Position = udim2.pnew(-5.3,0,0.5,-(v.label.TextBounds.Y/2)-1,v.button)
		end
		library.movecolorpicker()
	end
	if cursorenabled == false then
		cursor.Visible = false
	end
end)
--
return library
