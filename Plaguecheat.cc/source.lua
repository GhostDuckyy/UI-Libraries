local PCR_1 = Instance.new("ScreenGui")
local TweenService = game:GetService('TweenService');
local uis = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local function createInstance(class, props)
	local inst = Instance.new(class)
	for i, v in pairs(props) do
		inst[i] = v
	end

	return inst
end

local function intersects (p, edge)
	local x1, y1 = edge.a.x, edge.a.y
	local x2, y2 = edge.b.x, edge.b.y

	local x3, y3 = p.x, p.y
	local x4, y4 = p.x + 2147483647, p.y

	local den = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)

	if den == 0 then return false end

	local t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / den
	local u = -((x1 - x2) * (y1 - y3) - (y1 - y2) * (x1 - x3)) / den

	if t and u and t > 0 and t < 1 and u > 0 then
		return true
	end
 
	return false
end

local function getCorners(guiObject0)
	local pos = guiObject0.AbsolutePosition
	local size = guiObject0.AbsoluteSize
	local rotation = guiObject0.Rotation

	local a = pos + size/2 - math.sqrt((size.X/2)^2 + (size.Y/2)^2) * Vector2.new(math.cos(math.rad(rotation) + math.atan2(size.Y, size.X)), math.sin(math.rad(rotation) + math.atan2(size.Y, size.X)))
	local b = pos + size/2-math.sqrt((size.X/2)^2 + (size.Y/2)^2) * Vector2.new(math.cos(math.rad(rotation) - math.atan2(size.Y, size.X)), math.sin(math.rad(rotation) - math.atan2(size.Y, size.X)))
	local c = pos + size/2+math.sqrt((size.X/2)^2 + (size.Y/2)^2) * Vector2.new(math.cos(math.rad(rotation) + math.atan2(size.Y, size.X)), math.sin(math.rad(rotation) + math.atan2(size.Y, size.X)))
	local d = pos + size/2+math.sqrt((size.X/2)^2 + (size.Y/2)^2) * Vector2.new(math.cos(math.rad(rotation) - math.atan2(size.Y, size.X)), math.sin(math.rad(rotation) - math.atan2(size.Y, size.X)))

	return { 
		topleft = a, 
		bottomleft = b, 
		topright = d, 
		bottomright = c 
	}
end


function isColliding(guiObject0, guiObject1)		
	if not typeof(guiObject0) == "Instance" or not typeof(guiObject1) == "Instance" then 
		error("argument must be an instance") 
		return 
	end

	local ap1 = guiObject0.AbsolutePosition
	local as1 = guiObject0.AbsoluteSize
	local sum = ap1 + as1

	local ap2 = guiObject1.AbsolutePosition
	local as2 = guiObject1.AbsoluteSize
	local sum2 = ap2 + as2

	local corners0 = getCorners(guiObject0)
	local corners1 = getCorners(guiObject1)

	local edges = {
		{
			a = corners1.topleft,
			b = corners1.bottomleft
		},
		{
			a = corners1.topleft,
			b = corners1.topright
		},
		{
			a = corners1.bottomleft,
			b = corners1.bottomright
		},
		{
			a = corners1.topright,
			b = corners1.bottomright
		}
	}

	local collisions = 0

	for _, corner in pairs(corners0) do
		for _, edge in pairs(edges) do			
			if intersects(corner, edge) then
				collisions += 1
			end			
		end
	end

	if collisions%2 ~= 0 then
		return true
	end

	if (ap1.x < sum2.x and sum.x > ap2.x) and (ap1.y < sum2.y and sum.y > ap2.y) then
		return true
	end

	return false
end




local souid = false;
local index = 0;

local function draggable(obj,extern,parented)
	local globals = {}
	globals.dragging=nil
	globals.uiorigin=nil
	globals.morigin=nil
	obj.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 and souid == false and obj.ZIndex >= index then
			souid = true

			index = obj.ZIndex				
			obj.Parent = PCR_1

			globals.dragging = true
			globals.uiorigin = obj.Position
			globals.morigin = input.Position

			local connection 
			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					globals.dragging = false
					souid = false
					connection:Disconnect()
					if extern then
						if isColliding(parented,obj)  then
							obj.Position = UDim2.new(0.5,0,0.5,0)
							obj.Parent = parented

						end
					end
				end
			end)
		else
			if input.UserInputType == Enum.UserInputType.MouseButton1 and souid==false and obj.ZIndex < index then
				obj.Parent = PCR_1
				souid = true
				index = obj.ZIndex
				globals.dragging = true
				globals.uiorigin = obj.Position
				globals.morigin = input.Position
				local connection 
				connection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						globals.dragging = false
						souid = false
						connection:Disconnect()
						if isColliding(obj,obj.Section)  then
							obj = obj.Section
						end
					end
				end)
			end
		end
	end)
	uis.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and globals.dragging then
			if extern then
				if isColliding(obj,parented) then
					TweenService:Create(parented , TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(19, 26, 35)}):Play()	
				else
					TweenService:Create(parented , TweenInfo.new(0.26, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()	
				end
			end
			local change = input.Position - globals.morigin
			obj.Position = UDim2.new(globals.uiorigin.X.Scale,globals.uiorigin.X.Offset+change.X,globals.uiorigin.Y.Scale,globals.uiorigin.Y.Offset+change.Y)
		end
	end)
end





function OpenedColor(text,ColourDisplay,Action,def)

	local COLORPALLETE = Instance.new("Frame")
	local ANIMATEFRAME01 = Instance.new("Frame")
	local Holder = Instance.new("Frame")
	local BG = Instance.new("Frame")
	local S12 = Instance.new("Frame")
	local ColourWheel = Instance.new("ImageButton")
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	local Picker = Instance.new("ImageLabel")
	local S523 = Instance.new("UICorner")
	local DarknessPicker = Instance.new("ImageButton")
	local UIGradient = Instance.new("UIGradient")
	local Slider = Instance.new("ImageLabel")
	local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
	local S13 = Instance.new("Frame")
	local SDFH = Instance.new("UICorner")
	local ColourDisplayBIG = Instance.new("ImageLabel")
	local UIAspectRatioConstraint_3 = Instance.new("UIAspectRatioConstraint")
	local SETCOLOR = Instance.new("ImageButton")
	local Upper = Instance.new("Frame")
	local TEMPLATETITLE20202 = Instance.new("TextLabel")
	local linedecoupper = Instance.new("Frame")
	local RESETALL = Instance.new('ImageButton')
	RESETALL.Name = "RESETALL"
	RESETALL.Parent = S13
	RESETALL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RESETALL.BackgroundTransparency = 1.000
	RESETALL.BorderSizePixel = 0
	RESETALL.Position = UDim2.new(0.621510208, 0, 0.730036497, 0)
	RESETALL.Size = UDim2.new(0, 15, 0, 15)
	RESETALL.ZIndex = 23
	RESETALL.Image = "rbxassetid://5640320478"

	COLORPALLETE.Name = "COLORPALLETE"
	COLORPALLETE.Parent = PCR_1
	COLORPALLETE.AnchorPoint = Vector2.new(0.5, 0.5)
	COLORPALLETE.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
	COLORPALLETE.BackgroundTransparency = 1.000
	COLORPALLETE.BorderSizePixel = 0
	COLORPALLETE.ClipsDescendants = true
	COLORPALLETE.Position = UDim2.new(0.5, 0, 0.5, 0)
	COLORPALLETE.Size = UDim2.new(0, 272, 0, 150)
	COLORPALLETE.ZIndex = 2
	COLORPALLETE.Visible = false

	ANIMATEFRAME01.Name = "ANIMATEFRAME01"
	ANIMATEFRAME01.Parent = COLORPALLETE
	ANIMATEFRAME01.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ANIMATEFRAME01.Position = UDim2.new(-0.0257352963, 0, -0.00666669384, 0)
	ANIMATEFRAME01.Size = UDim2.new(0, 285, 0, 159)
	ANIMATEFRAME01.ZIndex = 99
	ANIMATEFRAME01.BorderSizePixel = 0;

	Holder.Name = "Holder"
	Holder.Parent = COLORPALLETE
	Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Holder.BackgroundTransparency = 1.000
	Holder.BorderSizePixel = 0
	Holder.Size = UDim2.new(0, 283, 0, 157)

	BG.Name = "BG"
	BG.Parent = Holder
	BG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	BG.BorderColor3 = Color3.fromRGB(91, 133, 197)
	BG.BorderSizePixel = 0
	BG.Position = UDim2.new(0, 0, 0.157927245, 0)
	BG.Size = UDim2.new(0, 272, 0, 125)

	S12.Name = "S12"
	S12.Parent = BG
	S12.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	S12.BorderSizePixel = 0
	S12.Position = UDim2.new(0, 16, 0, 7)
	S12.Size = UDim2.new(0, 156, 0, 107)
	S12.ZIndex = 23

	ColourWheel.Name = "ColourWheel"
	ColourWheel.Parent = S12
	ColourWheel.Active = false
	ColourWheel.AnchorPoint = Vector2.new(0.5, 0.5)
	ColourWheel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColourWheel.BackgroundTransparency = 1.000
	ColourWheel.BorderSizePixel = 0
	ColourWheel.Position = UDim2.new(0.418737918, 0, 0.491852999, 0)
	ColourWheel.Selectable = false
	ColourWheel.Size = UDim2.new(0.599832177, 0, 0.86683917, 0)
	ColourWheel.ZIndex = 25
	ColourWheel.Image = "http://www.roblox.com/asset/?id=6020299385"

	UIAspectRatioConstraint.Parent = ColourWheel
	UIAspectRatioConstraint.AspectRatio = 1.000

	Picker.Name = "Picker"
	Picker.Parent = ColourWheel
	Picker.AnchorPoint = Vector2.new(0.5, 0.5)
	Picker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Picker.BackgroundTransparency = 1.000
	Picker.BorderSizePixel = 0
	Picker.Position = UDim2.new(0.5, 0, 0.5, 0)
	Picker.Size = UDim2.new(0.0900257826, 0, 0.0900257975, 0)
	Picker.Image = "http://www.roblox.com/asset/?id=3678860011"

	S523.Name = "S523"
	S523.Parent = S12

	DarknessPicker.Name = "DarknessPicker"
	DarknessPicker.Parent = S12
	DarknessPicker.Active = false
	DarknessPicker.AnchorPoint = Vector2.new(0.5, 0.5)
	DarknessPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DarknessPicker.BackgroundTransparency = 1.000
	DarknessPicker.BorderSizePixel = 0
	DarknessPicker.Position = UDim2.new(0.854536772, 0, 0.554580271, 0)
	DarknessPicker.Selectable = false
	DarknessPicker.Size = UDim2.new(0.0943329856, 0, 0.88014394, 0)
	DarknessPicker.ZIndex = 25
	DarknessPicker.Image = "rbxassetid://3570695787"
	DarknessPicker.ScaleType = Enum.ScaleType.Slice
	DarknessPicker.SliceCenter = Rect.new(100, 100, 100, 100)
	DarknessPicker.SliceScale = 0.120

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = DarknessPicker

	Slider.Name = "Slider"
	Slider.Parent = DarknessPicker
	Slider.AnchorPoint = Vector2.new(0.5, 0.5)
	Slider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Slider.BackgroundTransparency = 1.000
	Slider.BorderSizePixel = 0
	Slider.Position = UDim2.new(0.491197795, 0, 0.0733607039, 0)
	Slider.Size = UDim2.new(1.28656352, 0, 0.0265010502, 0)
	Slider.ZIndex = 2
	Slider.Image = "rbxassetid://3570695787"
	Slider.ImageColor3 = Color3.fromRGB(255, 74, 74)
	Slider.ScaleType = Enum.ScaleType.Slice
	Slider.SliceCenter = Rect.new(100, 100, 100, 100)
	Slider.SliceScale = 0.120

	UIAspectRatioConstraint_2.Parent = DarknessPicker
	UIAspectRatioConstraint_2.AspectRatio = 0.157

	S13.Name = "S13"
	S13.Parent = BG
	S13.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	S13.BorderSizePixel = 0
	S13.Position = UDim2.new(0, 182, 0, 7)
	S13.Size = UDim2.new(0, 79, 0, 109)
	S13.ZIndex = 23

	SDFH.Name = "SDFH"
	SDFH.Parent = S13

	ColourDisplayBIG.Name = "ColourDisplayBIG"
	ColourDisplayBIG.Parent = S13
	ColourDisplayBIG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColourDisplayBIG.BackgroundTransparency = 1.000
	ColourDisplayBIG.BorderSizePixel = 0
	ColourDisplayBIG.Position = UDim2.new(0.255401969, 0, 0.159329623, 0)
	ColourDisplayBIG.Size = UDim2.new(0.473250836, 0, 0.530204058, 0)
	ColourDisplayBIG.ZIndex = 25
	ColourDisplayBIG.Image = "rbxassetid://3570695787"
	ColourDisplayBIG.ScaleType = Enum.ScaleType.Slice
	ColourDisplayBIG.SliceCenter = Rect.new(100, 100, 100, 100)
	ColourDisplayBIG.SliceScale = 0.120

	UIAspectRatioConstraint_3.Parent = ColourDisplayBIG


	SETCOLOR.Name = "SETCOLOR"
	SETCOLOR.Parent = S13
	SETCOLOR.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SETCOLOR.BackgroundTransparency = 1.000
	SETCOLOR.BorderSizePixel = 0
	SETCOLOR.Position = UDim2.new(0.231911927, 0, 0.730036736, 0)
	SETCOLOR.Size = UDim2.new(0, 15, 0, 15)
	SETCOLOR.ZIndex = 23
	SETCOLOR.Image = "rbxassetid://1489284025"

	Upper.Name = "Upper"
	Upper.Parent = Holder
	Upper.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Upper.BackgroundTransparency = 1.000
	Upper.BorderColor3 = Color3.fromRGB(91, 133, 197)
	Upper.BorderSizePixel = 0
	Upper.Position = UDim2.new(1.07835966e-07, 0, 0, 0)
	Upper.Size = UDim2.new(0, 271, 0, 23)
	Upper.ZIndex = 2

	TEMPLATETITLE20202.Name = "TEMPLATETITLE20202"
	TEMPLATETITLE20202.Parent = Upper
	TEMPLATETITLE20202.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TEMPLATETITLE20202.BackgroundTransparency = 1.000
	TEMPLATETITLE20202.BorderSizePixel = 0
	TEMPLATETITLE20202.Position = UDim2.new(0.00999999978, 0, 0.217391297, 0)
	TEMPLATETITLE20202.Size = UDim2.new(0, 258, 0, 13)
	TEMPLATETITLE20202.ZIndex = 3
	TEMPLATETITLE20202.Font = Enum.Font.SourceSansSemibold
	TEMPLATETITLE20202.Text = text
	TEMPLATETITLE20202.TextColor3 = Color3.fromRGB(197, 197, 197)
	TEMPLATETITLE20202.TextSize = 16.000
	TEMPLATETITLE20202.TextXAlignment = Enum.TextXAlignment.Left

	linedecoupper.Name = "linedecoupper"
	linedecoupper.Parent = Holder
	linedecoupper.BackgroundColor3 = Color3.fromRGB(91, 133, 197)
	linedecoupper.BorderColor3 = Color3.fromRGB(91, 133, 197)
	linedecoupper.BorderSizePixel = 0
	linedecoupper.Position = UDim2.new(0, 0, 0.150589287, 0)
	linedecoupper.Size = UDim2.new(0.961130738, 0, 0, 1)
	linedecoupper.ZIndex = 3
	if COLORPALLETE.Visible == true then
		ANIMATEFRAME01:TweenPosition(UDim2.new(-0.026,0,-0.007,0),'Out','Quint',0.2,true);
		wait(.2)
		COLORPALLETE.BackgroundTransparency = 1;
		Holder.Visible = false
		ANIMATEFRAME01:TweenPosition(UDim2.new(1.077,0,-0.007,0),'Out','Quint',0.2,true);
		wait(.2)
		COLORPALLETE.Visible = false
		ANIMATEFRAME01.Visible = false
	end
	local uis = game:GetService("UserInputService")
	ANIMATEFRAME01.Visible =true
	COLORPALLETE.Visible = true
	ANIMATEFRAME01.Position = UDim2.new(-1.085,0,-0.013,0)
	Holder.Visible = false

	ANIMATEFRAME01:TweenPosition(UDim2.new(-0.026,0,-0.007,0),'Out','Quint',0.2,true);
	wait(.2)
	COLORPALLETE.Visible = true
	COLORPALLETE.BackgroundTransparency = 0;
	Holder.Visible = true
	ANIMATEFRAME01:TweenPosition(UDim2.new(1.077,0,-0.007,0),'Out','Quint',0.2,true);
	wait(.2)
	ANIMATEFRAME01.Position = UDim2.new(-1.085,0,-0.013,0)
	local hsv;

	SETCOLOR.MouseButton1Click:Connect(function()
		ANIMATEFRAME01:TweenPosition(UDim2.new(-0.026,0,-0.007,0),'Out','Quint',0.2,true);
		wait(.2)
		COLORPALLETE.BackgroundTransparency = 1;
		Holder.Visible = false
		ANIMATEFRAME01:TweenPosition(UDim2.new(1.077,0,-0.007,0),'Out','Quint',0.2,true);
		wait(.2)
		ANIMATEFRAME01.Visible = false
		ColourDisplay.ImageColor3 = ColourDisplayBIG.ImageColor3
		COLORPALLETE.Visible = false

		pcall(function()
            Action( Color3.fromRGB(ColourDisplayBIG.ImageColor3.R * 200 ,ColourDisplayBIG.ImageColor3.G * 200 ,ColourDisplayBIG.ImageColor3.B* 200) )
        end)

	end)

	RESETALL.MouseButton1Click:Connect(function()
		ANIMATEFRAME01:TweenPosition(UDim2.new(-0.026,0,-0.007,0),'Out','Quint',0.2,true);
		wait(.2)
		COLORPALLETE.BackgroundTransparency = 1;
		Holder.Visible = false
		ANIMATEFRAME01:TweenPosition(UDim2.new(1.077,0,-0.007,0),'Out','Quint',0.2,true);
		wait(.2)
		COLORPALLETE.Visible = false

		ANIMATEFRAME01.Visible = false

	end)
	local buttonDown = false
	local movingSlider = false


	local function updateColour(centreOfWheel)

		local colourPickerCentre = Vector2.new(
			Picker.AbsolutePosition.X + (Picker.AbsoluteSize.X/2),
			Picker.AbsolutePosition.Y + (Picker.AbsoluteSize.Y/2)
		)
		local h = (math.pi - math.atan2(colourPickerCentre.Y - centreOfWheel.Y, colourPickerCentre.X - centreOfWheel.X)) / (math.pi * 2)

		local s = (centreOfWheel - colourPickerCentre).Magnitude / (ColourWheel.AbsoluteSize.X/2)

		local v = math.abs((Slider.AbsolutePosition.Y - DarknessPicker.AbsolutePosition.Y) / DarknessPicker.AbsoluteSize.Y - 1)


		hsv = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1))


		ColourDisplayBIG.ImageColor3 = hsv
		UIGradient.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, hsv), 
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
		}

	end


	ColourWheel.MouseButton1Down:Connect(function()
		buttonDown = true
	end)

	DarknessPicker.MouseButton1Down:Connect(function()
		movingSlider = true
	end)


	uis.InputEnded:Connect(function(input)

		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		buttonDown = false
		movingSlider = false
	end)


	uis.InputChanged:Connect(function(input)

		if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end


		local mousePos = uis:GetMouseLocation() - Vector2.new(0, game:GetService("GuiService"):GetGuiInset().Y)

		local centreOfWheel = Vector2.new(ColourWheel.AbsolutePosition.X + (ColourWheel.AbsoluteSize.X/2), ColourWheel.AbsolutePosition.Y + (ColourWheel.AbsoluteSize.Y/2))

		local distanceFromWheel = (mousePos - centreOfWheel).Magnitude


		if distanceFromWheel <= ColourWheel.AbsoluteSize.X/2 and buttonDown then

			Picker.Position = UDim2.new(0, mousePos.X - ColourWheel.AbsolutePosition.X, 0, mousePos.Y - ColourWheel.AbsolutePosition.Y)


		elseif movingSlider then

			Slider.Position = UDim2.new(Slider.Position.X.Scale, 0, 0, 
				math.clamp(
					mousePos.Y - DarknessPicker.AbsolutePosition.Y, 
					0, 
					DarknessPicker.AbsoluteSize.Y)
			)	
		end

		updateColour(centreOfWheel)

	end)
	draggable(COLORPALLETE)
end


local MAIN = Instance.new("Frame")
local BG = Instance.new("Frame")
local Upper = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local linedecoupper = Instance.new("Frame")
local DOWNER = Instance.new("Frame")
local WEBSITE = Instance.new("TextLabel")
local LABEL2 = Instance.new("TextLabel")
local linedecoDOWNER = Instance.new("Frame")
local UPPERLABEL = Instance.new("TextLabel")
local limit1 = Instance.new("Frame")



--Properties:

PCR_1.Name = "PCR_1"
PCR_1.Parent = game:GetService("CoreGui")
PCR_1.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PCR_1.ResetOnSpawn = false

MAIN.Name = "MAIN"
MAIN.Parent = PCR_1
MAIN.AnchorPoint = Vector2.new(0.5, 0.5)
MAIN.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
MAIN.BorderSizePixel = 0
MAIN.Position = UDim2.new(0.285505116, 0, 0.649934769, 0)
MAIN.Size = UDim2.new(0, 588, 0, 415)
MAIN.ZIndex = 2

BG.Name = "BG"
BG.Parent = MAIN
BG.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
BG.BorderColor3 = Color3.fromRGB(91, 133, 197)
BG.BorderSizePixel = 0
BG.Position = UDim2.new(0, 0, 0.0615355708, 0)
BG.Size = UDim2.new(0, 588, 0, 365)
BG.ClipsDescendants = true

Upper.Name = "Upper"
Upper.Parent = MAIN
Upper.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Upper.BackgroundTransparency = 1.000
Upper.BorderColor3 = Color3.fromRGB(91, 133, 197)
Upper.BorderSizePixel = 0
Upper.Size = UDim2.new(0, 600, 0, 23)
Upper.ZIndex = 2


UIListLayout.Parent = Upper
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

linedecoupper.Name = "linedecoupper"
linedecoupper.Parent = MAIN
linedecoupper.BackgroundColor3 = Color3.fromRGB(91, 133, 197)
linedecoupper.BorderColor3 = Color3.fromRGB(91, 133, 197)
linedecoupper.BorderSizePixel = 0
linedecoupper.Position = UDim2.new(0, 0, 0.0591259636, 0)
linedecoupper.Size = UDim2.new(1, 0, 0, 1)
linedecoupper.ZIndex = 3

DOWNER.Name = "DOWNER"
DOWNER.Parent = MAIN
DOWNER.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DOWNER.BackgroundTransparency = 1.000
DOWNER.BorderColor3 = Color3.fromRGB(91, 133, 197)
DOWNER.BorderSizePixel = 0
DOWNER.Position = UDim2.new(0, 0, 0.943463266, 0)
DOWNER.Size = UDim2.new(0, 600, 0, 23)
DOWNER.ZIndex = 2

WEBSITE.Name = "WEBSITE"
WEBSITE.Parent = DOWNER
WEBSITE.AnchorPoint = Vector2.new(0.5, 0.5)
WEBSITE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WEBSITE.BackgroundTransparency = 1.000
WEBSITE.BorderSizePixel = 0
WEBSITE.Position = UDim2.new(0.177174687, 0, 0.499190629, 0)
WEBSITE.Size = UDim2.new(0, 197, 0, 23)
WEBSITE.ZIndex = 3
WEBSITE.Font = Enum.Font.ArialBold
WEBSITE.Text = "NerdsInc.gq" 
WEBSITE.TextColor3 = Color3.fromRGB(199, 199, 199)
WEBSITE.TextSize = 14.000
WEBSITE.TextXAlignment = Enum.TextXAlignment.Left

LABEL2.Name = "LABEL2"
LABEL2.Parent = DOWNER
LABEL2.AnchorPoint = Vector2.new(0.5, 0.5)
LABEL2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
LABEL2.BackgroundTransparency = 1.000
LABEL2.BorderSizePixel = 0
LABEL2.Position = UDim2.new(0.795508027, 0, 0.455712378, 0)
LABEL2.Size = UDim2.new(0, 197, 0, 23)
LABEL2.ZIndex = 3
LABEL2.Font = Enum.Font.ArialBold
LABEL2.Text = "Alpha build / âˆž days left"
LABEL2.TextColor3 = Color3.fromRGB(199, 199, 199)
LABEL2.TextSize = 14.000
LABEL2.TextXAlignment = Enum.TextXAlignment.Right

linedecoDOWNER.Name = "linedecoDOWNER"
linedecoDOWNER.Parent = MAIN
linedecoDOWNER.BackgroundColor3 = Color3.fromRGB(91, 133, 197)
linedecoDOWNER.BorderColor3 = Color3.fromRGB(91, 133, 197)
linedecoDOWNER.BorderSizePixel = 0
linedecoDOWNER.Position = UDim2.new(0, 0, 0.941053629, 0)
linedecoDOWNER.Size = UDim2.new(1, 0, 0, 1)
linedecoDOWNER.ZIndex = 10

UPPERLABEL.Name = "UPPERLABEL"
UPPERLABEL.Parent = MAIN
UPPERLABEL.AnchorPoint = Vector2.new(0.5, 0.5)
UPPERLABEL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UPPERLABEL.BackgroundTransparency = 1.000
UPPERLABEL.BorderSizePixel = 0
UPPERLABEL.Position = UDim2.new(0.906523705, 0, 0.0267967135, 0)
UPPERLABEL.Size = UDim2.new(0, 84, 0, 23)
UPPERLABEL.ZIndex = 3
UPPERLABEL.Font = Enum.Font.SourceSansSemibold
UPPERLABEL.Text = "Not loaded."
UPPERLABEL.TextColor3 = Color3.fromRGB(199, 199, 199)
UPPERLABEL.TextSize = 17.000
UPPERLABEL.TextXAlignment = Enum.TextXAlignment.Right

limit1.Name = "limit1"
limit1.Parent = MAIN
limit1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
limit1.BackgroundTransparency = 1.000
limit1.BorderSizePixel = 0
limit1.Position = UDim2.new(0, 0, 0.0615355708, 0)
limit1.Size = UDim2.new(0, 588, 0, 364)
limit1.ZIndex = 5


repeat wait() until game.Players.LocalPlayer




local library = {};
library.sections = {};
local totalSections = 0;

function library:ChangeWeb(site)
	WEBSITE.Text = site
end
function library:ChangeGame(gamee)
	LABEL2.Text = gamee
end

local tweenTime = 0.25
local tweenInfo = TweenInfo.new(
	tweenTime,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out
)


function AddRipple(button,ael,ayo)
	ayo = ayo or Color3.fromRGB(56, 56, 56)
	button.ClipsDescendants = true
	local obj = button
	local function Ripple()
		spawn(
			function()
				local Mouse = game.Players.LocalPlayer:GetMouse()
				local Circle = Instance.new("ImageLabel")
				Circle.Name = "Circle"
				Circle.Parent = obj
				Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Circle.BackgroundTransparency = 1.000
				Circle.ZIndex = 10
				Circle.Image = "rbxassetid://266543268"
				Circle.ImageColor3 = Color3.fromRGB(211, 211, 211)
				Circle.ImageTransparency = 0.6
				local NewX, NewY = Mouse.X - Circle.AbsolutePosition.X, Mouse.Y - Circle.AbsolutePosition.Y
				Circle.Position = UDim2.new(0, NewX, 0, NewY)
				local Size = 0
				if obj.AbsoluteSize.X > obj.AbsoluteSize.Y then
					Size = obj.AbsoluteSize.X * 1
				elseif obj.AbsoluteSize.X < obj.AbsoluteSize.Y then
					Size = obj.AbsoluteSize.Y * 1
				elseif obj.AbsoluteSize.X == obj.AbsoluteSize.Y then
					Size = obj.AbsoluteSize.X * 1
				end
				Circle:TweenSizeAndPosition(
					UDim2.new(0, Size, 0, Size),
					UDim2.new(0.5, -Size / 2, 0.5, -Size / 2),
					"Out",
					"Quad",
					0.2,
					false
				)
				for i = 1, 15 do
					Circle.ImageTransparency = Circle.ImageTransparency + 0.05
					wait()
				end
				Circle:Destroy()
			end
		)
	end
	local Background = Instance.new("Frame")
	local CornerRadius = Instance.new("UICorner")
	Background.Name = "Background"
	Background.Parent = button
	Background.AnchorPoint = Vector2.new(0.5, 0.5)
	Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Background.BackgroundTransparency = 1.000
	Background.ClipsDescendants = true
	Background.Position = UDim2.new(0.5, 0, 0.5, 0)
	Background.Size = UDim2.new(1, 0, 1, 0)
	CornerRadius.CornerRadius = UDim.new(0, 4)
	CornerRadius.Name = "CornerRadius"
	CornerRadius.Parent = Background

	local mouse = game.Players.LocalPlayer:GetMouse()

	local background = button:WaitForChild("Background")

	local active = false
	local hovering = false

	local function OnMouseButton1Down()
		local backgroundFadeIn = TweenService:Create(ael, tweenInfo, { TextColor3 =  ayo})
		backgroundFadeIn:Play()
	end

	local function OnMouseButton1Up()
		local backgroundFadeIn = TweenService:Create(ael, tweenInfo, { TextColor3 = Color3.fromRGB(152, 152, 152) })
		backgroundFadeIn:Play()
	end

	local function OnMouseEnter()
		hovering = true

		local backgroundFadeIn = TweenService:Create(ael, tweenInfo, { TextColor3 = Color3.fromRGB(152, 152, 152) })

		backgroundFadeIn:Play()

		backgroundFadeIn.Completed:Wait()

		local backgroundFadeOut = TweenService:Create(ael, tweenInfo, {TextColor3 = Color3.fromRGB(197, 197, 197)})

		repeat wait() until not hovering

		backgroundFadeOut:Play()
	end


	local function OnMouseLeave()
		hovering = false
		active = false
	end
	button.MouseButton1Down:Connect(OnMouseButton1Down)
	button.MouseButton1Up:Connect(OnMouseButton1Up)
	button.MouseEnter:Connect(OnMouseEnter)
	button.MouseLeave:Connect(OnMouseLeave)
	button.MouseButton1Click:Connect(Ripple)
end
local function getsize(frame)
	local size = 0;
	for i=1,#frame do
		local s = frame:sub(i,i)
		if string.upper(s) == s then
			if s == 'I' then
				size+=4
			else
				size+=12;
			end
		else
			if s == 'i' then
				size+= 4
			else
				size += 10
			end
		end
	end
	return size
end
library.fps = ''

local s,e = pcall(function()
	local k = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
end)

if not s or e then
	library.ms = 'err'
else
	spawn(function()
		game:GetService("RunService").RenderStepped:Connect(function()
			local plr = game:GetService('Players').LocalPlayer
			library.ms =  game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
		end)
	end)
end



function library:AddWatermark(Text)
	local intern = {}
	local size

	size=(#Text) * 7

	--[MAIN]--
	local obj1 = Instance.new("Frame")
	obj1.AnchorPoint = Vector2.new(0, 0.5)
	obj1.BackgroundColor3 = Color3.new(0.0862745, 0.0862745, 0.0862745)
	obj1.BorderSizePixel = 0
	obj1.Position = UDim2.new(0.0109301507, 0, 0.973039031, 0)
	obj1.Size = UDim2.new(0, size, 0, 28)
	obj1.ZIndex = 8
	obj1.Name = [[MAIN]]
	obj1.Visible = true
	obj1.ClipsDescendants = true
	obj1.Parent = PCR_1
	--[UIStroke]--
	local obj2 = Instance.new("UIStroke", obj1)
	obj2.Color = Color3.new(0.309804, 0.458824, 0.67451)

	--[MAIN]--
	local obj3 = Instance.new("Frame", obj1)
	obj3.AnchorPoint = Vector2.new(0.5, 0.5)
	obj3.BackgroundColor3 = Color3.new(0.113725, 0.113725, 0.113725)
	obj3.BorderSizePixel = 0
	obj3.Position = UDim2.new(0.5, 0, 0.5, 0)
	obj3.Size = UDim2.new(1, -6, 1, -6)
	obj3.ZIndex = 7
	obj3.Name = [[MAIN]]

	--[TextLabel]--
	local obj4 = Instance.new("TextLabel", obj3)
	obj4.BackgroundColor3 = Color3.new(1, 1, 1)
	obj4.BackgroundTransparency = 1
	obj4.BorderSizePixel = 0
	obj4.Position = UDim2.new(0.0215827357, 0, 0, 0)
	obj4.Size = UDim2.new(0, 325, 0, 22)
	obj4.Font = Enum.Font.SourceSansSemibold
	obj4.Text = Text
	obj4.TextColor3 = Color3.new(0.772549, 0.772549, 0.772549)
	obj4.TextSize = 16
	obj4.TextXAlignment = Enum.TextXAlignment.Left

	function intern:ChangeText(text)
		local size = #text * 7 + 5
		obj4.Text = text;
		Text = text
		obj1.Size = UDim2.new(0, size, 0, 28)
	end
	local can = true
	function intern:Visible(val)
		if val  == nil then
			return obj1.Visible
		end
		if can then
			val=not val
			if not val then
				can = not can
				obj1.Visible = true
				wait(.5)
				can = not can
			else
				can = not can

				obj1.Visible =false
				wait(.5)
				can = not can
			end
		end

	end
	return intern
end

function library:Init(name)
    for i,v in pairs(Upper:GetChildren()) do
        if v:IsA('TextButton') then
            if v.Name == name then
                TweenService:Create(v , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()	
            else
                TweenService:Create(v , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(138, 138, 138)}):Play()	
            end
        end
    end
    for i,v in pairs(limit1:GetChildren()) do
        if v:IsA('Frame') or v:IsA('ScrollingFrame') then
            if v.Name == name then
                v.Visible = true
            else
                v.Visible = false
            end
        end
    end
end

function library:AddWindow(text)
	local sec = {}
	text=text or 'Not Def'

	local HOLDER = Instance.new("ScrollingFrame")
	local _LEFT = Instance.new("Frame")
	local LUIL = Instance.new("UIListLayout")
	local _RIGHT = Instance.new("Frame")
	local RUIL = Instance.new("UIListLayout")
	local TEMPLATE_TEXT = Instance.new("TextButton")

	TEMPLATE_TEXT.Name = text
	TEMPLATE_TEXT.Parent = Upper
	TEMPLATE_TEXT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TEMPLATE_TEXT.BackgroundTransparency = 1.000
	TEMPLATE_TEXT.BorderSizePixel = 0
	TEMPLATE_TEXT.Position = UDim2.new(0, 0, 0.281214178, 0)
	TEMPLATE_TEXT.Size = UDim2.new(0, 50, 0, 13)
	TEMPLATE_TEXT.ZIndex = 3
	TEMPLATE_TEXT.Font = Enum.Font.SourceSansSemibold
	TEMPLATE_TEXT.Text = text
	TEMPLATE_TEXT.TextColor3 = Color3.fromRGB(138, 138, 138)
	TEMPLATE_TEXT.TextSize = 16.000
	TEMPLATE_TEXT.Size = UDim2.new(0,getsize(text),0,13)


	HOLDER.Name = text
	HOLDER.Parent = limit1
	HOLDER.Active = true
	HOLDER.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HOLDER.BackgroundTransparency = 1.000
	HOLDER.BorderSizePixel = 0
	HOLDER.ClipsDescendants = false
	HOLDER.Position = UDim2.new(0,0,0.019,0)
	HOLDER.Visible = false
	HOLDER.Size = UDim2.new(0, 588, 0, 359)
	HOLDER.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	HOLDER.CanvasSize = UDim2.new(0, 0, 0, 0)
	HOLDER.ScrollBarThickness = 5
	HOLDER.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

	_LEFT.Name = "_LEFT"
	_LEFT.Parent = HOLDER
	_LEFT.AnchorPoint = Vector2.new(0.5, 0.5)
	_LEFT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	_LEFT.BackgroundTransparency = 1.000
	_LEFT.BorderSizePixel = 0
	_LEFT.Position = UDim2.new(0.249334633, 0, 0.508299172, 0)
	_LEFT.Size = UDim2.new(0.5, 0, 0.972153783, 0)
	_LEFT.ZIndex = 3
	_LEFT.ClipsDescendants = true

	LUIL.Name = "LUIL"
	LUIL.Parent = _LEFT
	LUIL.HorizontalAlignment = Enum.HorizontalAlignment.Center
	LUIL.SortOrder = Enum.SortOrder.LayoutOrder
	LUIL.Padding = UDim.new(0, 5)

	_RIGHT.Name = "_RIGHT"
	_RIGHT.Parent = HOLDER
	_RIGHT.AnchorPoint = Vector2.new(0.5, 0.5)   
	_RIGHT.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	_RIGHT.BackgroundTransparency = 1.000
	_RIGHT.BorderSizePixel = 0
	_RIGHT.Position = UDim2.new(0.749334514, 0, 0.508299172, 0)
	_RIGHT.Size = UDim2.new(0.5, 0, 0.972153783, 0)
	_RIGHT.ZIndex = 3
	_RIGHT.ClipsDescendants = true

	RUIL.Name = "RUIL"
	RUIL.Parent = _RIGHT
	RUIL.HorizontalAlignment = Enum.HorizontalAlignment.Center
	RUIL.SortOrder = Enum.SortOrder.LayoutOrder
	RUIL.Padding = UDim.new(0, 5)

	local fghk = Instance.new("UIListLayout")

	TEMPLATE_TEXT.MouseButton1Click:Connect(function()
		for i,v in pairs(Upper:GetChildren()) do
			if v:IsA('TextButton') then
				TweenService:Create(v , TweenInfo.new(0.26, Enum.EasingStyle.Quad    , Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(138, 138, 138)}):Play()	
			end
		end
		TweenService:Create(TEMPLATE_TEXT , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(210, 210, 210)}):Play()	
		for i,v in pairs(limit1:GetChildren()) do
			if v:IsA('Frame') or v:IsA('ScrollingFrame') then
				v.Visible = false
			end
		end
		HOLDER.Visible = true
	end)

	fghk.Name = "fghk"
	fghk.Parent =HOLDER
	fghk.FillDirection = Enum.FillDirection.Horizontal
	fghk.SortOrder = Enum.SortOrder.LayoutOrder
	local function getlarger(num)
		local LeftSize =  LUIL.AbsoluteContentSize.Y
		local RightSize =  RUIL.AbsoluteContentSize.Y
		if num == 1 then
			if LeftSize > RightSize then
				return 'l'    
			elseif LeftSize < RightSize then
				return 'r'
			elseif LeftSize == RightSize then
				return 'r'
			end
		elseif num == 2 then
			return {l=LeftSize,r=RightSize}
		else
			return ''
		end
	end
	local function UpdateMainSize(f,anim)
		HOLDER.ClipsDescendants = true

		if getlarger(1) == 'l' then
			if anim then
				TweenService:Create(HOLDER, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CanvasSize = UDim2.fromOffset(0, getlarger(2).l + 15)}):Play()
			else   
				HOLDER.CanvasSize = UDim2.fromOffset(0, getlarger(2).l + 15)

			end

		elseif getlarger(1) == 'r' then
			if anim then
				TweenService:Create(HOLDER, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CanvasSize = UDim2.fromOffset(0, getlarger(2).r + 15)}):Play()
			else
				HOLDER.CanvasSize = UDim2.fromOffset(0, getlarger(2).r + 15)
				HOLDER.CanvasSize = UDim2.fromOffset(0, getlarger(2).r + 15)
			end
		end

	end

	local function GetSide(typ,input)   
		if typ == 1 then
			local parented;
			local s;
			if (totalSections%2 == 0) then
				parented = _RIGHT
				s= RUIL
			else
				parented = _LEFT
				s= LUIL
			end
			return parented,s
		elseif typ == 2 and input then
			if tonumber(input) == nil then   
				if input == 'Right' or input == 'R' or input == 'r' then
					return _RIGHT,RUIL
				end
				if input == 'Left' or input == 'L' or input == 'l' then
					return _LEFT,LUIL
				end
			else
				if input == 1 then
					return _LEFT,LUIL
				elseif input == 2 then
					return _RIGHT,RUIL   
				else
					return GetSide(1);
				end
			end
		else
			return GetSide(1);
		end
	end
	local section_info = {};
	function sec:UpdateSize()
		UpdateMainSize()
	end
	local function AutoFit(section,list)
		if section and list then
			local x,y =  section.AbsoluteSize.X,list.AbsoluteContentSize.Y  
			local lefts,ls = 0,{};
			local rights,rs = 0,{};
			section.Size = UDim2.fromOffset(x,  y + 8) + UDim2.new(0,0,0,23)

			UpdateMainSize()
		end

	end

	function sec:AddSection(Texto,side)
		local inside = {};
		Texto=Texto or 'Not Defined'
		totalSections+=1;

		local _PARENT,LIST =  GetSide(2,side)
		local SECTIONHOLDER = Instance.new("Frame")
		local Section = Instance.new("Frame")
		local Z_Holder = Instance.new("Frame")
		local HOLDER_2 = Instance.new("Frame")    
		local SECTION2UILIB = Instance.new("UIListLayout")
		local F_line = Instance.new("Frame")
		local A_label = Instance.new("TextLabel")
		local SECTIONIOL = Instance.new("UIListLayout")
		local us = Instance.new('UIStroke');

		us.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		us.LineJoinMode = Enum.LineJoinMode.Round
		us.Thickness = 1;
		us.Transparency =0;
		us.Parent  = Section;
		us.Name = '_STROKE_'
		SECTIONHOLDER.Name = Texto
		SECTIONHOLDER.Parent = _PARENT
		SECTIONHOLDER.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		SECTIONHOLDER.BorderSizePixel = 0      
		SECTIONHOLDER.Position = UDim2.new(0.0289115645, 0, -4.23979145e-08, 0)
		SECTIONHOLDER.Size = UDim2.new(0, 275, 0, 138)
		SECTIONHOLDER.ZIndex = 3	

		if library.sections[SECTIONHOLDER.Name] ~= nil then
			print('ERROR: FUNCTION (AddSection): SECTIONS MUST HAVE DIFFERENT NAMES!!!')
			return 
		else
			library.sections[SECTIONHOLDER.Name] = _PARENT
		end

		Section.Name = "Section"
		Section.Parent = SECTIONHOLDER
		Section.AnchorPoint = Vector2.new(0.5, 0.5)
		Section.BackgroundColor3 = Color3.fromRGB(33, 33, 33)
		Section.BorderSizePixel = 0
		Section.ClipsDescendants = true
		Section.Position = UDim2.new(0.498745143, 0, 0.502499998, 0)    
		Section.Size = UDim2.new(1.003,0,1,0)
		Section.ZIndex = 4

		Z_Holder.Name = "Z_Holder"
		Z_Holder.Parent = Section
		Z_Holder.AnchorPoint = Vector2.new(0.5, 0.5)
		Z_Holder.BackgroundColor3 = Color3.fromRGB(29, 29, 29)
		Z_Holder.BorderSizePixel = 0
		Z_Holder.Position = UDim2.new(2.44783831, 0, 3.13320923, 0)
		Z_Holder.Size = UDim2.new(1, 0, 0.965465486, 0)
		Z_Holder.ZIndex = 4

		HOLDER_2.Name = "HOLDER"
		HOLDER_2.Parent = Z_Holder
		HOLDER_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		HOLDER_2.BackgroundTransparency = 1.000
		HOLDER_2.Position = UDim2.new(0, 4, 0, 5)
		HOLDER_2.Size = UDim2.new(0.981999993, 0, 0.957000017, 0)   
		HOLDER_2.ZIndex = 5

		SECTION2UILIB.Name = "SECTION2UILIB"
		SECTION2UILIB.Parent = HOLDER_2
		SECTION2UILIB.SortOrder = Enum.SortOrder.LayoutOrder
		SECTION2UILIB.HorizontalAlignment = Enum.HorizontalAlignment.Center
		SECTION2UILIB.Padding = UDim.new(0, 5)

		F_line.Name = "F_line"
		F_line.Parent = Section
		F_line.BackgroundColor3 = Color3.fromRGB(91, 133, 197)
		F_line.BorderColor3 = Color3.fromRGB(91, 133, 197)
		F_line.BorderSizePixel = 0
		F_line.Position = UDim2.new(0, 0, 0.099530004, 0)
		F_line.Size = UDim2.new(1, 0, 0, 1)
		F_line.ZIndex = 6

		A_label.Name = "A_label"
		A_label.Parent = Section
		A_label.AnchorPoint = Vector2.new(0.5, 0.5)
		A_label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)  
		A_label.BackgroundTransparency = 1.000
		A_label.BorderSizePixel = 0
		A_label.Position = UDim2.new(0.512401581, 0, 0.0548184477, 0)
		A_label.Size = UDim2.new(0, 267, 0, 22)
		A_label.ZIndex = 3
		A_label.Font = Enum.Font.SourceSansSemibold
		A_label.Text = Texto
		A_label.TextColor3 = Color3.fromRGB(221, 221, 221)
		A_label.TextSize = 17.000
		A_label.TextXAlignment = Enum.TextXAlignment.Left

		SECTIONIOL.Name = "SECTIONIOL"
		SECTIONIOL.Parent = Section
		SECTIONIOL.HorizontalAlignment = Enum.HorizontalAlignment.Center

		SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
		_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);

		AutoFit()
		--TweenService:Create(closeSection , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {Rotation = 0}):Play()	
		UpdateMainSize()

		function inside:AddTextBox(Text,placeholder, CTOF, Type, Action)

			Text=Text or 'Not Defined'
			placeholder = placeholder or 'Input Here'
			CTOF = CTOF or false
			Type = Type or 2

			local filter = '%W+' 
			local filter2 = '%p+'
			local onlunum = '%D+'   
			local onlychars = '%A+'

			local function colador(str,type)
				local str =str
				if type == 1 then
					str= str:gsub(onlunum, ''); -- exclude a-Z
				end
				if type == 2 then
					str= str:gsub(filter2, ''); -- exclude special characters (~!@#$%^&*()_+.,<>?:"}{-=`")
				end
				if type == 3 then
					str= str:gsub(filter, ''); -- exclude special characters + space bar (~!@#$%^&*()_+.,<>?:"}{-=`"  )
				end
				if type == 4 then
					str= str:gsub(onlychars, ''); -- exclude special characters + numbers + space bar (~!@#$%^&*()_+.,<>?:"}{-=`"  0-9) 
				end
				if type == 5 then
					str = str   
				end
				return str
			end

			--[TemplateTexstbox]--
			local obj1 = Instance.new("Frame")
			obj1.BackgroundColor3 = Color3.new(1, 1, 1)
			obj1.BackgroundTransparency = 1
			obj1.BorderSizePixel = 0
			obj1.Position = UDim2.new(0.155858055, 0, 0.392140955, 0)
			obj1.Size = UDim2.new(0, 239, 0, 22)
			obj1.ZIndex = 14
			obj1.Name = [[TemplateTexstbox]]
			obj1.Parent = HOLDER_2
			--[color]--
			local obj2 = Instance.new("Frame", obj1)   
			obj2.AnchorPoint = Vector2.new(1, 0.5)
			obj2.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
			obj2.BorderSizePixel = 0
			obj2.Position = UDim2.new(1.02739561, 0, 0.546084344, 0)
			obj2.Size = UDim2.new(0, 70, 0, 16)
			obj2.ZIndex = 25
			obj2.Name = [[color]]

			--[UIStroke]--
			local obj3 = Instance.new("UIStroke", obj2)
			obj3.Color = Color3.new(0.203922, 0.203922, 0.203922)

			--[UIGradient]--   
			local obj4 = Instance.new("UIGradient", obj3)
			obj4.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(0.705882, 0.705882, 0.705882))})

			--[TextBox]--
			local obj5 = Instance.new("TextBox", obj2)
			obj5.BackgroundColor3 = Color3.new(1, 1, 1)
			obj5.BackgroundTransparency = 1
			obj5.BorderSizePixel = 0
			obj5.Size = UDim2.new(1, 0, 1, 0)
			obj5.ZIndex = 28
			obj5.ClearTextOnFocus = CTOF
			obj5.CursorPosition = -1
			obj5.Font = Enum.Font.ArialBold
			obj5.PlaceholderText = placeholder
			obj5.Text = [[]]
			obj5.TextColor3 = Color3.new(1, 1, 1)   
			obj5.TextSize = 10
			obj5.TextStrokeColor3 = Color3.new(0.639216, 0.639216, 0.639216)

			if #obj5.Text <= 5 then
				obj2:TweenSize(UDim2.new(0,#obj5.PlaceholderText*6,0,16),'Out','Quint',0,true);
			else
				obj2:TweenSize(UDim2.new(0,#obj5.PlaceholderText*6,0,16),'Out','Quint',0,true);

			end
			--[TextLabel]--
			local obj6 = Instance.new("TextLabel", obj1)
			obj6.BackgroundColor3 = Color3.new(0.772549, 0.772549, 0.772549)
			obj6.BackgroundTransparency = 1
			obj6.BorderSizePixel = 0
			obj6.Position = UDim2.new(-0.00865958631, 0, 0.0133694736, 0)
			obj6.Size = UDim2.new(0, 169, 0, 24)
			obj6.ZIndex = 15
			obj6.Font = Enum.Font.SourceSansBold
			obj6.Text = Text
			obj6.TextColor3 = Color3.new(0.772549, 0.772549, 0.772549)
			obj6.TextSize = 14
			obj6.TextXAlignment = Enum.TextXAlignment.Left  

			local AC = function(PassBox)
				PassBox.Text=colador(obj5.Text,Type)

				if PassBox.Text == nil or PassBox.Text == '' then
   
					if #PassBox.Text <= 5 then
						obj2:TweenSize(UDim2.new(0,#PassBox.PlaceholderText*10,0,16),'Out','Quint',0.4,true);
					else
						obj2:TweenSize(UDim2.new(0,#PassBox.PlaceholderText*6,0,16),'Out','Quint',0.4,true);

					end

				else
					obj2:TweenSize(UDim2.new(0,#PassBox.Text*7,0,16),'Out','Quint',0.4,true);
				end
				if #PassBox.Text >= 21 then
					PassBox.Text = string.sub(PassBox.Text,0,21)
				end
				spawn(
					function()
						pcall(function()
							Action(obj5.Text)
						end)  
					end)
			end
			local text = ''
			obj5.Changed:Connect(function()
				if obj5.Text == nil or obj5.Text == ' ' or obj5.Text =='' then
					obj2:TweenSize(UDim2.new(0,#obj5.PlaceholderText*6,0,16),'Out','Quint',0.4,true);
					return
				end
				if text ~= obj5.Text then
					text = obj5.Text
					AC(obj5)
				end
			end)

			SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
			_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);

			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)

		end
 
		function inside:AddSlider(Text,Max,Min,def,Action)
			Text = Text or 'Not Defined'
			Max = Max or 100
			Min =Min or Max/4
			def = def or Max/2
			local mouse = game.Players.LocalPlayer:GetMouse()
			local SliderDef = math.clamp(def, Min, Max) or math.clamp(50, Min, Max)
			local DefaultScale =  (SliderDef - Min) / (Max - Min)
			Action = Action or function() end
			local Value;

			--[Slider]--
			local obj1 = Instance.new("Frame")
			obj1.BackgroundColor3 = Color3.new(0.117647, 0.117647, 0.113725)
			obj1.BackgroundTransparency = 1
			obj1.BorderSizePixel = 0
			obj1.Position = UDim2.new(0.0435978472, 0, 0.255637407, 0)
			obj1.Size = UDim2.new(0, 248, 0, 32)
			obj1.ZIndex = 20
			obj1.Name = [[Slider]]
			obj1.Parent = HOLDER_2
			--[TextLabel]--
			local obj2 = Instance.new("TextLabel", obj1)
			obj2.BackgroundColor3 = Color3.new(1, 1, 1)
			obj2.BackgroundTransparency = 1
			obj2.BorderSizePixel = 0
			obj2.Position = UDim2.new(0.00500635942, 0, 0.0442914963, 0)
			obj2.Size = UDim2.new(0, 197, 0, 10)
			obj2.ZIndex = 21
			obj2.Font = Enum.Font.SourceSansSemibold
			obj2.Text = Text
			obj2.TextColor3 = Color3.new(0.772549, 0.772549, 0.772549)
			obj2.TextSize = 16
			obj2.TextXAlignment = Enum.TextXAlignment.Left

			--[sbt]--
			local obj3 = Instance.new("TextButton", obj1)
			obj3.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
			obj3.BackgroundTransparency = 1
			obj3.BorderSizePixel = 0
			obj3.ClipsDescendants = true
			obj3.Position = UDim2.new(0, 1, 0, 19)
			obj3.Size = UDim2.new(0, 243, 0, 13)
			obj3.ZIndex = 21
			obj3.Font = Enum.Font.SourceSans
			obj3.Text = [[]]
			obj3.TextColor3 = Color3.new(0, 0, 0)
			obj3.TextSize = 1
			obj3.AutoButtonColor = false
			obj3.Name = [[sbt]]

			--[pcntage]--
			local obj4 = Instance.new("TextBox")


			obj4.Name = "pcntage"
			obj4.Parent = obj1
			obj4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			obj4.BackgroundTransparency = 1.000
			obj4.BorderSizePixel = 0
			obj4.Position = UDim2.new(0.79838711, 0, 0, 0)
			obj4.Size = UDim2.new(0, 44, 0, 11)
			obj4.ZIndex = 23
			obj4.ClearTextOnFocus = false
			obj4.Font = Enum.Font.SourceSansBold
			obj4.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
			obj4.Text = def
			obj4.TextColor3 = Color3.fromRGB(90, 90, 90)
			obj4.TextSize = 14.000
			obj4.TextXAlignment = Enum.TextXAlignment.Right

			--[HOLDER_3]--
			local obj5 = Instance.new("Frame", obj1)
			obj5.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
			obj5.BorderSizePixel = 0
			obj5.Position = UDim2.new(-0.002,0,0.491,0)
			obj5.Size = UDim2.new(0, 243, 0, 13)
			obj5.ZIndex = 23
			obj5.Name = [[HOLDER_3]]

			--[SFrame]--
			local obj6 = Instance.new("Frame", obj5)
			obj6.BackgroundColor3 = Color3.new(1, 1, 1)
			obj6.BorderSizePixel = 0
			obj6.Position = UDim2.new(-0.001646191, 0, 0, 0)
			obj6.Size = UDim2.fromScale(DefaultScale,1)
			obj6.ZIndex = 23
			obj6.Name = [[SFrame]]

			--[UIGradient]--
			local obj7 = Instance.new("UIGradient", obj6)
			obj7.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0.345098, 0.509804, 0.752941)), ColorSequenceKeypoint.new(1, Color3.new(0.270588, 0.4, 0.592157))})

			--[UIStroke]--
			local obj8 = Instance.new("UIStroke", obj5)
			obj8.Color = Color3.new(0.203922, 0.203922, 0.203922)

			--[UIGradient]--
			local obj9 = Instance.new("UIGradient", obj8)
			obj9.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(0.533333, 0.533333, 0.533333))})

			local st = def or Max/2
			obj4.FocusLost:Connect(function(n)
				if n then
					if obj4.Text == '' or obj4.Text == ' ' or obj4.Text:find(' ') or obj4.Text == nil then
						Value = tonumber(obj4.Text)
						obj4.Text = st
						local SliderDef = math.clamp(tonumber(obj4.Text), Min, Max) or math.clamp(50, Min, Max)
						local DefaultScale =  (SliderDef - Min) / (Max - Min)
						obj6.Size = UDim2.fromScale(DefaultScale,1)
						pcall(function()
							Action(Value)
						end)
						return
					end
					if tonumber(obj4.Text) > Max then
						obj4.Text = Max
						st = obj4.Text

						Value = tonumber(obj4.Text)
						local SliderDef = math.clamp(tonumber(obj4.Text), Min, Max) or math.clamp(50, Min, Max)
						local DefaultScale =  (SliderDef - Min) / (Max - Min)
						obj6.Size = UDim2.fromScale(DefaultScale,1)
						pcall(function()
							Action(Value)
						end)
						return
					end
					if tonumber(obj4.Text) < Min then
						obj4.Text = Min
						st = obj4.Text

						Value = tonumber(obj4.Text)
						local SliderDef = math.clamp(tonumber(obj4.Text), Min, Max) or math.clamp(50, Min, Max)
						local DefaultScale =  (SliderDef - Min) / (Max - Min)
						obj6.Size = UDim2.fromScale(DefaultScale,1)
						pcall(function()
							Action(Value)
						end)
						return
					end
					st = obj4.Text
					Value = tonumber(obj4.Text)
					local SliderDef = math.clamp(tonumber(obj4.Text), Min, Max) or math.clamp(50, Min, Max)
					local DefaultScale =  (SliderDef - Min) / (Max - Min)
					obj6.Size = UDim2.fromScale(DefaultScale,1)
					pcall(function()
						Action(Value)
					end)
				else
					obj4.Text = st 
					Value = tonumber(obj4.Text)
					local SliderDef = math.clamp(tonumber(obj4.Text), Min, Max) or math.clamp(50, Min, Max)
					local DefaultScale =  (SliderDef - Min) / (Max - Min)
					obj6.Size = UDim2.fromScale(DefaultScale,1)
					return
				end
			end)
			obj4.Changed:Connect(function()
				if #obj4.Text > 7 then
					obj4.Text= st 
					Value = tonumber(obj4.Text)
					local SliderDef = math.clamp(tonumber(obj4.Text), Min, Max) or math.clamp(50, Min, Max)
					local DefaultScale =  (SliderDef - Min) / (Max - Min)
					obj6.Size = UDim2.fromScale(DefaultScale,1)
					return
				end
			end)
			obj3.MouseButton1Down:Connect(function()
				TweenService:Create(obj8 , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {Color = Color3.fromRGB(115, 115, 115)}):Play()
				obj4.TextXAlignment = Enum.TextXAlignment.Right

				Value = ((((tonumber(Max) - tonumber(Min)) / 244) * obj6.AbsoluteSize.X) + tonumber(Min)) or 0
				Value = (Value)
				TweenService:Create(obj4, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()

				obj6.Size = UDim2.new(0, math.clamp(mouse.X - obj6.AbsolutePosition.X, 0, 244), 0, 13)
				moveconnection = mouse.Move:Connect(function()
					obj4.Text = ('%0.2f'):format(Value)
					Value = ((((tonumber(Max) - tonumber(Min)) / 244) * obj6.AbsoluteSize.X) + tonumber(Min))
					Value = (Value)
					pcall(function()
						Action(Value)
					end)
					obj6.Size = UDim2.new(0, math.clamp(mouse.X - obj6.AbsolutePosition.X, 0, 244), 0, 13)
				end)
				releaseconnection = uis.InputEnded:Connect(function(Mouse)
					if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
						Value = ((((tonumber(Max) - tonumber(Min)) / 244) * obj6.AbsoluteSize.X) + tonumber(Min))
						Value =(Value)
						pcall(function()
							Action(Value)
						end)
						obj6.Size = UDim2.new(0, math.clamp(mouse.X - obj6.AbsolutePosition.X, 0, 244), 0, 13)
						moveconnection:Disconnect()
						releaseconnection:Disconnect()
					end
				end)
				obj4.Text = ('%0.2f'):format(Value)
			end)

			obj3.MouseButton1Up:Connect(function()
				TweenService:Create(obj8 , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {Color = Color3.fromRGB(52, 52, 52)}):Play()
				TweenService:Create(obj4, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(126, 126, 126)}):Play()
			end)
			obj3.MouseLeave:Connect(function()
				TweenService:Create(obj4, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextColor3 = Color3.fromRGB(126, 126, 126)}):Play()
				TweenService:Create(obj8 , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {Color = Color3.fromRGB(52, 52, 52)}):Play()
			end)
			SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
			_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)

		end

		function inside:AddLabel(Text)
			Text=Text or 'Not Defined'
			local TextLabel = Instance.new("TextLabel")

			TextLabel.Parent = HOLDER_2
			TextLabel.AutomaticSize =Enum.AutomaticSize.Y

			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0329693519, 0, 0, 0)
			TextLabel.Size = UDim2.new(0, 253, 0, 11)
			TextLabel.ZIndex = 15
			TextLabel.Font = Enum.Font.SourceSansSemibold
			TextLabel.Text = Text
			TextLabel.TextColor3 = Color3.fromRGB(197, 197, 197)
			TextLabel.TextSize = 18.000
			TextLabel.TextWrapped = true
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.TextYAlignment = Enum.TextYAlignment.Top
			
			TextLabel.AutomaticSize = Enum.AutomaticSize.Y


			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
		end
		local function getsize(str)
			local r = 0;
			for i=1,#str do
				r+=1
			end
			if r <= 5 then
				if r == 1 then
					return r * 50
				end
				if r ==2 then
					return r * 25
				end
				if r ==3 then
					return r * 16
				end
				if r == 4 then
					return r * 12
				end
				if r == 5 then
					return r * 10
				end
			end
			return r * 7.5
		end
		function inside:AddToggle(Text,Enabled,keybind,Callback)
			Callback = Callback or function() end
			Text=Text or 'Not Defined'
			local activated = Enabled or false;
			local y = {};

			local TemplateToggle = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			local Interactive = Instance.new("TextButton")
			local color = Instance.new("Frame")
			local UIGradient = Instance.new("UIGradient");
			local UIStroke = Instance.new('UIStroke');

			UIStroke.Parent= color;
			UIStroke.Color = Color3.fromRGB(52,52,52);
			UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
			UIStroke.Thickness = 1;
			UIStroke.Transparency = 0;
			UIStroke.Name = 'UIStroke';

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 180, 180))}
			UIGradient.Parent = UIStroke

			local function Update()
				if activated == false then
					TweenService:Create(color , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(84, 122, 181)}):Play()
					TweenService:Create(TextLabel, tweenInfo, { TextColor3 = Color3.fromRGB(152, 152, 152) }):Play()
					spawn(function()
						pcall(function()
							Callback(activated)
						end)
					end)
					activated = true
				elseif activated == true then
					TweenService:Create(color , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(25,25,25)}):Play()
					TweenService:Create(TextLabel, tweenInfo, { TextColor3 = Color3.fromRGB(84, 84, 84) }):Play()
					spawn(function()
						pcall(function()
							Callback(activated)
						end)
					end)
					activated = false
				end
			end

			TemplateToggle.Name = "TemplateToggle"
			TemplateToggle.Parent = HOLDER_2
			TemplateToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TemplateToggle.BackgroundTransparency = 1.000
			TemplateToggle.BorderSizePixel = 0
			TemplateToggle.Position = UDim2.new(0.155858055, 0, 0.392140955, 0)
			TemplateToggle.Size = UDim2.new(0, 239, 0, 22)
			TemplateToggle.ZIndex = 14

			TextLabel.Parent = TemplateToggle
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.0833906233, 0, 0.0133694736, 0)
			TextLabel.Size = UDim2.new(0, 220, 0, 15)
			TextLabel.ZIndex = 15
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = Text
			TextLabel.TextColor3 = Color3.fromRGB(84, 84, 84)
			TextLabel.TextSize = 14.000
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			Interactive.Name = "Interactive"
			Interactive.Parent = TemplateToggle
			Interactive.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Interactive.BackgroundTransparency = 1.000
			Interactive.BorderSizePixel = 0
			Interactive.Position = UDim2.new(-0.0240641702, 0, 0, 0)
			Interactive.Size = UDim2.new(0, 246, 0, 18)
			Interactive.ZIndex = 20
			Interactive.Font = Enum.Font.SourceSans
			Interactive.Text = ""
			Interactive.TextColor3 = Color3.fromRGB(0, 0, 0)
			Interactive.TextSize = 20.000

			color.Name = "color"
			color.Parent = TemplateToggle
			color.AnchorPoint = Vector2.new(0.5, 0.5)
			color.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			color.BorderSizePixel = 0
			color.Position = UDim2.new(0.0192536544, 0, 0.386994779, 0)
			color.Size = UDim2.new(0, 15, 0, 15)
			color.ZIndex = 15

			local KeyButton = Instance.new("TextButton")
			local h5 = Instance.new("UICorner")


			KeyButton.Name = "KeyButton"
			KeyButton.Parent = TemplateToggle
			KeyButton.AnchorPoint = Vector2.new(1, 0.5)
			KeyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			KeyButton.BorderSizePixel = 0
			KeyButton.ClipsDescendants = true
			KeyButton.Position = UDim2.new(1.00271928, 0, 0.366679788, 0)
			KeyButton.Size = UDim2.new(0, 45, 0, 15)
			KeyButton.ZIndex = 22
			KeyButton.AutoButtonColor = false
			KeyButton.Font = Enum.Font.ArialBold
			if keybind then
				KeyButton.Text = keybind.Name or '. . .'
			else
				KeyButton.Text ='. . .'
			end
			KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyButton.TextSize = 10.000
			KeyButton.TextStrokeColor3 = Color3.fromRGB(45, 45, 45)

			h5.CornerRadius = UDim.new(0, 3)
			h5.Name = "h5"
			h5.Parent = KeyButton
			KeyButton:TweenSize(UDim2.new(0,getsize(KeyButton.Text),0,15),'InOut','Quint',0.2,true)

			if keybind then
				local ischanging = false;
				local KeyCode = keybind
				game:GetService("UserInputService").InputBegan:connect(function(a, gp) 
					if not gp then 
						if (a.KeyCode.Name == KeyCode or a.KeyCode.Name == KeyCode.Name) and ischanging == false then 
							pcall(function()
								Update()
							end)
						end
					end
				end)

				KeyButton.MouseButton1Click:connect(function() 
					game.TweenService:Create(KeyButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(34, 34, 34)
					}):Play()
					KeyButton.Text = ". . ."
					KeyButton:TweenSize(UDim2.new(0,getsize(KeyButton.Text),0,13), "InOut", "Quint", 0.2, true)

					local v1, v2 = game:GetService('UserInputService').InputBegan:wait();
					if v1.KeyCode.Name ~= "Unknown" then
						ischanging = true
						game.TweenService:Create(KeyButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
							BackgroundColor3 = Color3.fromRGB(25, 25, 25)
						}):Play()
						KeyButton:TweenSize(UDim2.new(0,getsize( v1.KeyCode.Name),0,13), "Out", "Quint", 0.3, true)
						KeyButton.Text = v1.KeyCode.Name
						KeyCode = v1.KeyCode.Name;
						wait(.2)
						ischanging = false
					end
				end)
			else
				KeyButton.Visible = false
			end
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
			function y:UpdateValue(val)
				activated = val
				Update(a)
			end
			Update(a)

			Interactive.MouseButton1Click:Connect(Update)
			Interactive.MouseEnter:Connect(function()
				TweenService:Create(UIStroke , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {Color = Color3.fromRGB(115, 115, 115)}):Play()
			end)
			Interactive.MouseLeave:Connect(function()
				TweenService:Create(UIStroke , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {Color = Color3.fromRGB(52, 52, 52)}):Play()

			end)
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
			return y

		end
		function inside:AddSeparateBar()
			local obj1 = Instance.new("Frame")
			obj1.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
			obj1.Position = UDim2.new(0.0159928761, 0, 0.491355002, 0)
			obj1.Size = UDim2.new(0, 258, 0, 3)
			obj1.ZIndex = 22
			obj1.Parent = HOLDER_2
			local obj2 = Instance.new("UICorner", obj1)
			obj2.CornerRadius = UDim.new(1, 10)
			SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
			_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);

			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)


		end
		function inside:AddColorPallete(Text,Color,Action)
			Text = Text or 'Not defined'
			Color = Color or Color3.fromRGB(255,255,255)
			Action = Action or function() end
			local SECTIONCOLOUR = Instance.new("Frame")
			local CCCC3 = Instance.new("UICorner")

			local OPENCLOSE = Instance.new("TextButton")
			local UICorner = Instance.new("UICorner")
			local ColourDisplay = Instance.new("ImageLabel")


			SECTIONCOLOUR.Name = "SECTIONCOLOUR"
			SECTIONCOLOUR.Parent = HOLDER_2
			SECTIONCOLOUR.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			SECTIONCOLOUR.BorderSizePixel = 0
			SECTIONCOLOUR.ClipsDescendants = true
			SECTIONCOLOUR.Position = UDim2.new(0.0251945332, 0, 0.517914712, 0)
			SECTIONCOLOUR.Size = UDim2.new(0, 258, 0, 22)
			SECTIONCOLOUR.ZIndex = 22

			CCCC3.CornerRadius = UDim.new(0, 6)
			CCCC3.Name = "CCCC3"
			CCCC3.Parent = SECTIONCOLOUR

			OPENCLOSE.Name = "OPENCLOSE"
			OPENCLOSE.Parent = SECTIONCOLOUR
			OPENCLOSE.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
			OPENCLOSE.BackgroundTransparency = 1.000
			OPENCLOSE.BorderSizePixel = 0
			OPENCLOSE.ClipsDescendants = true
			OPENCLOSE.Position = UDim2.new(0, 7, 0, 2)
			OPENCLOSE.Size = UDim2.new(0, 243, 0, 18)
			OPENCLOSE.ZIndex = 23
			OPENCLOSE.AutoButtonColor = false
			OPENCLOSE.Font = Enum.Font.SourceSansSemibold
			OPENCLOSE.Text = Text
			OPENCLOSE.TextColor3 = Color3.fromRGB(255, 255, 255)
			OPENCLOSE.TextSize = 16.000
			OPENCLOSE.TextXAlignment = Enum.TextXAlignment.Left

			UICorner.CornerRadius = UDim.new(0, 5)
			UICorner.Parent = OPENCLOSE

			ColourDisplay.Name = "ColourDisplay"
			ColourDisplay.Parent = SECTIONCOLOUR
			ColourDisplay.BackgroundColor3 = Color
			ColourDisplay.BackgroundTransparency = 1.000
			ColourDisplay.BorderSizePixel = 0
			ColourDisplay.Position = UDim2.new(0, 220, 0, 4)
			ColourDisplay.Size = UDim2.new(0, 29, 0, 14)
			ColourDisplay.ZIndex = 23
			ColourDisplay.Image = "rbxassetid://3570695787"
			ColourDisplay.ScaleType = Enum.ScaleType.Slice
			ColourDisplay.SliceCenter = Rect.new(100, 100, 100, 100)
			ColourDisplay.SliceScale = 0.120
			ColourDisplay.ImageColor3 = Color
			SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
			_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
			AutoFit(SECTIONHOLDER,SECTION2UILIB)
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 

			OPENCLOSE.MouseButton1Click:Connect(function()
				OpenedColor(Text,ColourDisplay,Action,Color)
			end)
		end
		function inside:AddKeyBind(Text,KeyCode,Action)
			Text = Text or 'Not Defined'
			KeyCode = KeyCode or Enum.KeyCode.RightAlt
			Action = Action or function() end

			local TemplateKBIND = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			local Interactive = Instance.new("TextButton")
			local KeyButton = Instance.new("TextButton")
			local h5 = Instance.new("UICorner")

			TemplateKBIND.Name = "TemplateKBIND"
			TemplateKBIND.Parent = HOLDER_2
			TemplateKBIND.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TemplateKBIND.BackgroundTransparency = 1.000
			TemplateKBIND.BorderSizePixel = 0
			TemplateKBIND.Position = UDim2.new(0.155858055, 0, 0.392140955, 0)
			TemplateKBIND.Size = UDim2.new(0, 239, 0, 22)
			TemplateKBIND.ZIndex = 14

			TextLabel.Parent = TemplateKBIND
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(-0.0121270986, 0, 0.0133694736, 0)
			TextLabel.Size = UDim2.new(0, 242, 0, 15)
			TextLabel.ZIndex = 15
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.Text = Text
			TextLabel.TextColor3 = Color3.fromRGB(197, 197, 197)
			TextLabel.TextSize = 14.000
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			Interactive.Name = "Interactive"
			Interactive.Parent = TemplateKBIND
			Interactive.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Interactive.BackgroundTransparency = 1.000
			Interactive.BorderSizePixel = 0
			Interactive.Position = UDim2.new(-0.0240641963, 0, 0, 0)
			Interactive.Size = UDim2.new(0, 246, 0, 18)
			Interactive.ZIndex = 20
			Interactive.Font = Enum.Font.SourceSans
			Interactive.Text = ""
			Interactive.TextColor3 = Color3.fromRGB(0, 0, 0)
			Interactive.TextSize = 20.000

			KeyButton.Name = "KeyButton"
			KeyButton.Parent = TemplateKBIND
			KeyButton.AnchorPoint = Vector2.new(1, 0.5)
			KeyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			KeyButton.BorderSizePixel = 0
			KeyButton.ClipsDescendants = true
			KeyButton.Position = UDim2.new(1.00271928, 0, 0.366679788, 0)
			KeyButton.Size = UDim2.new(0, 45, 0, 15)
			KeyButton.ZIndex = 55
			KeyButton.AutoButtonColor = false
			KeyButton.Font = Enum.Font.ArialBold
			KeyButton.Text = KeyCode.Name
			KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyButton.TextSize = 10.000
			KeyButton.TextStrokeColor3 = Color3.fromRGB(45, 45, 45)

			h5.CornerRadius = UDim.new(0, 3)
			h5.Name = "h5"
			h5.Parent = KeyButton


			local ischanging = false;
			game:GetService("UserInputService").InputBegan:connect(function(a, gp) 
				if not gp then 
					if (a.KeyCode.Name == KeyCode or a.KeyCode.Name == KeyCode.Name) and ischanging == false then 
						pcall(function()
							Action(a.KeyCode)
						end)
					end
				end
			end)

			KeyButton.MouseButton1Click:connect(function() 
				game.TweenService:Create(KeyButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
					BackgroundColor3 = Color3.fromRGB(34, 34, 34)
				}):Play()
				KeyButton.Text = ". . ."
				KeyButton:TweenSize(UDim2.new(0,getsize(KeyButton.Text),0,13), "InOut", "Quint", 0.2, true)

				local v1, v2 = game:GetService('UserInputService').InputBegan:wait();
				if v1.KeyCode.Name ~= "Unknown" then
					ischanging = true
					game.TweenService:Create(KeyButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
						BackgroundColor3 = Color3.fromRGB(25, 25, 25)
					}):Play()
					KeyButton:TweenSize(UDim2.new(0,getsize( v1.KeyCode.Name),0,13), "Out", "Quint", 0.3, true)
					KeyButton.Text = v1.KeyCode.Name
					KeyCode = v1.KeyCode.Name;
					wait(.2)
					ischanging = false
				end
			end)

			SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
			_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
		end
		function inside:AddDropdown(Text,tbl,sel,Action)
			Text = Text or 'Not Defined'
			tbl = tbl or {'Not','Defined','Option'}
			sel = sel or tbl[2] or '.-. bruh dude like fr, put one valid SIMPLE table.'
			Action = Action or function() end

			local K  =false
			local s =nil


			local DRPDOWN = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local Toggle = Instance.new("TextButton")
			local _456fg = Instance.new("UICorner")
			local TextLabel = Instance.new("TextLabel")
			local TextLabel_2 = Instance.new("TextLabel")
			local UIListLayout = Instance.new("UIListLayout")


			--Properties:

			DRPDOWN.Name = "DRPDOWN"
			DRPDOWN.Parent = HOLDER_2
			DRPDOWN.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
			DRPDOWN.BorderSizePixel = 0
			DRPDOWN.ClipsDescendants = true
			DRPDOWN.Position = UDim2.new(0.0362365209, 0, 0.69055295, 0)
			DRPDOWN.Size = UDim2.new(0, 252, 0, 25)
			DRPDOWN.ZIndex = 27

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = DRPDOWN

			Toggle.Name = "Toggle"
			Toggle.Parent = DRPDOWN
			Toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			Toggle.BorderSizePixel = 0
			Toggle.ClipsDescendants = true
			Toggle.Size = UDim2.new(0, 252, 0, 22)
			Toggle.AutoButtonColor = false
			Toggle.Font = Enum.Font.SourceSansSemibold
			Toggle.Text = "  "
			Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			Toggle.TextSize = 16.000

			_456fg.CornerRadius = UDim.new(0, 4)
			_456fg.Name = "456fg"
			_456fg.Parent = Toggle

			TextLabel.Parent = Toggle
			TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.44808808, 0, 0.454545468, 0)
			TextLabel.Size = UDim2.new(0, 208, 0, 18)
			TextLabel.ZIndex = 30
			TextLabel.Font = Enum.Font.SourceSansSemibold
			TextLabel.Text = Text
			TextLabel.TextColor3 = Color3.fromRGB(197, 197, 197)
			TextLabel.TextSize = 16.000
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left

			TextLabel_2.Parent = Toggle
			TextLabel_2.AnchorPoint = Vector2.new(0.5, 0.5)
			TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_2.BackgroundTransparency = 1.000
			TextLabel_2.BorderSizePixel = 0
			TextLabel_2.Position = UDim2.new(0.91685158, 0, 0.550000012, 0)
			TextLabel_2.Size = UDim2.new(0, 14, 0, 14)
			TextLabel_2.ZIndex = 30
			TextLabel_2.Font = Enum.Font.SourceSansSemibold
			TextLabel_2.Text = "+"
			TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel_2.TextSize = 16.000
			TextLabel_2.TextXAlignment = Enum.TextXAlignment.Right

			UIListLayout.Parent = DRPDOWN
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 3)

			for i,v in pairs(tbl) do
				local OPTION = Instance.new("TextButton")
				local _456fg_2 = Instance.new("UICorner")
				local TextLabel_3 = Instance.new("TextLabel")
				OPTION.Name = "OPTION"
				OPTION.Parent = DRPDOWN
				OPTION.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
				OPTION.BorderSizePixel = 0
				OPTION.ClipsDescendants = true
				OPTION.Position = UDim2.new(0.055555556, 0, 0.378787875, 0)
				OPTION.Size = UDim2.new(0, 233, 0, 16)
				OPTION.ZIndex = 29
				OPTION.AutoButtonColor = false
				OPTION.Font = Enum.Font.SourceSansSemibold
				OPTION.Text = ''
				OPTION.TextColor3 = Color3.fromRGB(255, 255, 255)
				OPTION.TextSize = 16.000

				_456fg_2.CornerRadius = UDim.new(0, 4)
				_456fg_2.Name = "456fg"
				_456fg_2.Parent = OPTION

				TextLabel_3.Parent = OPTION
				TextLabel_3.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel_3.BackgroundTransparency = 1.000
				TextLabel_3.BorderSizePixel = 0
				TextLabel_3.Position = UDim2.new(0.501999259, 0, 0.441162109, 0)
				TextLabel_3.Size = UDim2.new(0, 125, 0, 15)
				TextLabel_3.Font = Enum.Font.SourceSansSemibold
				TextLabel_3.Text = v
				TextLabel_3.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel_3.TextSize = 15.000

				if sel == v and v ~= Toggle.Text then
					TweenService:Create(OPTION , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()	
					s = sel;
				else
					TweenService:Create(OPTION , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(37,37,37)}):Play()	
				end

				OPTION.MouseButton1Click:Connect(function()
					for i,v in pairs(DRPDOWN:GetChildren()) do
						if v:IsA("TextButton") and v ~= Toggle then
							TweenService:Create(v , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(37,37,37)}):Play()	
						end	
					end
					s=TextLabel_3.Text
					TweenService:Create(OPTION , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.InOut), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()	
					pcall(function()
						Action(s)
					end)
				end)

				SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
				task.wait()
				_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
				task.wait()
				UpdateMainSize(nil,true)

				AddRipple(OPTION,TextLabel_3)
			end

			Toggle.MouseButton1Click:Connect(function()
				if not K then
					TweenService:Create(TextLabel_2 , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.Out), {Rotation = 180}):Play()	
					DRPDOWN:TweenSize(UDim2.fromOffset(DRPDOWN.AbsoluteSize.X,  UIListLayout.AbsoluteContentSize.Y + 11),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true) 
					K = not K
				else
					DRPDOWN:TweenSize(UDim2.new(0,DRPDOWN.AbsoluteSize.X,0, 25),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true) 
					TweenService:Create(TextLabel_2 , TweenInfo.new(0.26, Enum.EasingStyle.Quad , Enum.EasingDirection.Out), {Rotation = 0}):Play()	
					K = not K
				end
				wait(.3)
				SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true) 
				wait(.2)
				_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true) 
				wait(.2)
				UpdateMainSize(nil,true)

			end)




			AddRipple(Toggle,TextLabel_2,Color3.fromRGB(180, 180, 180))
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 

			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
		end
		function inside:AddButton(Text,Callback)
			Callback = Callback or function() end
			Text=Text or 'Not Defined'
			local TemplateButton = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			local Interactive = Instance.new("TextButton")
			local UICorner = Instance.new("UICorner")

			TemplateButton.Name = "TemplateButton"
			TemplateButton.Parent = HOLDER_2
			TemplateButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			TemplateButton.BorderSizePixel = 0
			TemplateButton.Position = UDim2.new(0.0430313908, 0, 0, 0)
			TemplateButton.Size = UDim2.new(0, 243, 0, 21)
			TemplateButton.ZIndex = 14
			TemplateButton.ClipsDescendants = true
			TextLabel.Parent = TemplateButton
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0, 0, 0, 0)
			TextLabel.Size = UDim2.new(0,243,0,19)
			TextLabel.ZIndex = 15
            TextLabel.Text=Text
			TextLabel.Font = Enum.Font.SourceSansBold
			TextLabel.TextColor3 = Color3.fromRGB(84, 84, 84)
			TextLabel.TextSize = 17.000

			Interactive.Name = "Interactive"
			Interactive.Parent = TemplateButton
			Interactive.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Interactive.BackgroundTransparency = 1.000
			Interactive.BorderSizePixel = 0
			Interactive.Position = UDim2.new(0, 0, 0, 0)
			Interactive.Size = UDim2.new(0,243,0,21)
			Interactive.ZIndex = 20
			Interactive.Font = Enum.Font.SourceSans
			Interactive.Text = ""
			Interactive.TextColor3 = Color3.fromRGB(0, 0, 0)
			Interactive.TextSize = 18.000
			--Interactive.ClipsDescendants = true
			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = TemplateButton
			local UIGradient = Instance.new("UIGradient");
			local UIStroke = Instance.new('UIStroke');

			UIStroke.Parent= TemplateButton;
			UIStroke.Color = Color3.fromRGB(52,52,52);
			UIStroke.LineJoinMode = Enum.LineJoinMode.Round;
			UIStroke.Thickness = 1;
			UIStroke.Transparency = 0;
			UIStroke.Name = 'UIStroke';

			UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 180, 180))}
			UIGradient.Parent = UIStroke

			Interactive.MouseButton1Click:Connect(function()
				spawn(function()
					pcall(function()
						Callback()
					end)
				end)
			end)
			SECTIONHOLDER.Size = UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 8) + UDim2.new(0,0,0,23)
			_PARENT.Size = UDim2.new(_PARENT.Size.X.Scale, _PARENT.Size.X.Offset , 0 ,LIST.AbsoluteContentSize.Y + 15);
			SECTIONHOLDER:TweenSize(UDim2.fromOffset(SECTIONHOLDER.AbsoluteSize.X,  SECTION2UILIB.AbsoluteContentSize.Y + 42),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			wait()
			_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 
			UpdateMainSize(nil,true)
		end			
		AutoFit(SECTIONHOLDER,SECTION2UILIB)
		_PARENT:TweenSize(UDim2.fromOffset(_PARENT.AbsoluteSize.X,  LIST.AbsoluteContentSize.Y + 15),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true) 

		return inside
	end

	return sec
end




draggable(MAIN)

-- to check fps (not mine function so yeah) --
spawn(function()
	local TimeFunction = RunService:IsRunning() and time or os.clock
	local LastIteration, Start
	local FrameUpdateTable = {}
	local function HeartbeatUpdate()
		LastIteration = TimeFunction()
		for Index = #FrameUpdateTable, 1, -1 do
			FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
		end

		FrameUpdateTable[1] = LastIteration
		library.fps = tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))) .. " FPS"
		UPPERLABEL.Text = library.fps
	end

	Start = TimeFunction()
	RunService.Heartbeat:Connect(HeartbeatUpdate)
end)
library.GUI = PCR_1 

return library
