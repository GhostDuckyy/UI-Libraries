local library = {flags = {}, ActiveSlider = nil, Count = 0, windows = {}, callbacks = {}, binds = {}, open = true}

---=== Globals ===---
local RunService = game:GetService("RunService")
local Heartbeat = game:GetService("RunService").Heartbeat
local RenderStepped = game:GetService('RunService').RenderStepped
local mouse = game:GetService("Players").LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")


function Tween(Object, Goal, Direction, Style, Time, WaitForTween)
    Style = Style or {}
    local Tween = game:GetService("TweenService"):Create(Object,TweenInfo.new( Time, Style, Direction ), Goal)
    Tween:Play()
    if WaitForTween then
        Tween.Completed:wait()
    end
end

local GlobalRainbowColor;
local GlobalHueColor;
spawn(function()
	while true do
		for i = 0, 1, 1 / 300 do
			GlobalRainbowColor = Color3.fromHSV(i, 1, 1);
			GlobalHueColor = i
			wait()
		end
	end
end)

function library:Create(class, properties)
	local inst = Instance.new(class)
	for property, value in next, properties do
		inst[property] = value
	end
	return inst
end

function ScreenGUIName(length) -- 29 length is ideal
    local str = ""
	for i = 1, length do 
		if i%6 == 0 then
			str = str .. '-'
		else
			str = str .. string.char(math.random(65,90))
		end
    end
    return str
end

---=== Main Part ===----
local ScreenGUI = library:Create('ScreenGui', {Name = ScreenGUIName(29); Parent = game.CoreGui})

function library:CreateWindow(Name)
	self.Toggled = true
	library.Count = library.Count + 1
	local TopBar = library:Create("ImageLabel", {
		Name = "Top Bar";
		Parent = ScreenGUI;
		BackgroundColor3 = Color3.fromRGB(114, 137, 218);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(114, 137, 218);
		BorderSizePixel = 0;
		Position = UDim2.new((library.Count * 0.0155038759) , (( library.Count - 1 )* 208),  0.0246913582, 0);
		Size = UDim2.new(0, 208, 0, 35);
		ZIndex = 2;
		Image = "http://www.roblox.com/asset/?id=4846149319";
		ImageColor3 = Color3.fromRGB(0, 0, 0);
		Active = true;
		Draggable = true;
	});
	local WindowName = library:Create("TextLabel",{
		Name = "Window Name";
		Parent = TopBar;
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(27, 42, 53);
		Position = UDim2.new(0.0500000007, 0, 0.0282485969, 0);
		Size = UDim2.new(0.829987586, 0, 1, 0);
		ZIndex = 3;
		Font = Enum.Font.GothamSemibold;
		Text = Name;
		TextColor3 = Color3.fromRGB(255, 255, 255);
		TextSize = 20.000;
		TextWrapped = true;
		TextXAlignment = Enum.TextXAlignment.Left;
	});
	local WindowToggle = library:Create("TextButton",{
		Name = "Window Toggle";
		Parent = TopBar;
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		BorderSizePixel = 0;
		Position = UDim2.new(0.847619057, 0, 0.142857149, 0);
		Size = UDim2.new(0, 25, 0, 25);
		ZIndex = 4;
		Font = Enum.Font.GothamSemibold;
		Text = "-";
		TextColor3 = Color3.fromRGB(255, 255, 255);
		TextSize = 30.000;
	});
	local WindowToggleBackground = library:Create("ImageLabel",{
		Name = "Window Toggle Background";
		Parent = WindowToggle;
		Active = true;
		AnchorPoint = Vector2.new(0.5, 0.5);
		BackgroundColor3 = Color3.fromRGB(255, 255, 255);
		BackgroundTransparency = 1.000;
		Position = UDim2.new(0.5, 0, 0.5, 0);
		Selectable = true;
		Size = UDim2.new(1, 0, 1, 0);
		ZIndex = 3;
		Image = "rbxassetid://3570695787";
		ImageColor3 = Color3.fromRGB(31, 30, 31);
		ScaleType = Enum.ScaleType.Slice;
		SliceCenter = Rect.new(100, 100, 100, 100);
		SliceScale = 0.060;
	});
	local Container = library:Create("Frame",{
		Name = "Container";
		Parent = TopBar;
		BackgroundColor3 = Color3.fromRGB(116, 166, 253);
		BackgroundTransparency = 1.000;
		BorderColor3 = Color3.fromRGB(114, 137, 218);
		BorderSizePixel = 0;
		ClipsDescendants = true;
		Position = UDim2.new(0, 0, 0.861375749, 0);
		Size = UDim2.new(0, 208, 0, 350);
	});
	local ContainerUIListLayout = library:Create("UIListLayout",{
		Name = "Container UI List Layout";
		Parent = Container;
		SortOrder = Enum.SortOrder.LayoutOrder;
	});
	
	-- Dragger skidded from Jan <3
	local dragging, dragInput, dragStart, startPos, dragObject

	local function update(input)
		if not startPos then return end
		local delta = input.Position - dragStart
		local yPos = (startPos.Y.Offset + delta.Y) < -36 and -36 or startPos.Y.Offset + delta.Y
		dragObject:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, yPos), "Out", "Quint", 0.1, true)
	end
	
	TopBar.InputBegan:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			dragObject = TopBar
			dragging = true
			dragStart = input.Position
			startPos = dragObject.Position
		end
	end)
	TopBar.InputChanged:connect(function(input)
		if dragging and input.UserInputType.Name == "MouseMovement" then
			dragInput = input
		end
	end)
	TopBar.InputEnded:connect(function(input)
		if input.UserInputType.Name == "MouseButton1" then
			dragging = false
		end
	end)
	
	UserInputService.InputChanged:connect(function(input)
		if input.UserInputType.Name == "MouseMovement" then
			if input == dragInput and dragging then
				update(input)
			end
		end
	end)

	WindowToggle.MouseButton1Click:Connect(function()
		self.Toggled = not self.Toggled
		if self.Toggled then
			Tween(Container, {Size =  UDim2.new(0, 208, 0, ContainerUIListLayout.AbsoluteContentSize.Y)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, true)
			WindowToggle.Text = "-"
		else
			Tween(Container, {Size = UDim2.new(0, 208, 0, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, true)
			WindowToggle.Text = "+"
		end
	end)

	local Sections = {}
	function Sections:Section(Name)
		self.Toggled = false
		local Section = {}
		table.insert(self, Section)

		local SectionPart = library:Create("Frame",{
			Name = "SectionPart";
			Parent = Container;
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderSizePixel = 0;
			ClipsDescendants = true;
			Size = UDim2.new(1, 0, 0, 35);
		});
		local SectionContainer = library:Create("Frame",{
			Name = "Section Container";
			Parent = SectionPart;
			BackgroundColor3 = Color3.fromRGB(19, 19, 19);
			BorderSizePixel = 0;
			ClipsDescendants = true;
			Position = UDim2.new(0, 0, 0, 30);
			Size = UDim2.new(0, 208, 0, 0);
		});
		local SectionUIListLayout = library:Create("UIListLayout",{
			Name = "Section UIListLayout";
			Parent = SectionContainer;
			SortOrder = Enum.SortOrder.LayoutOrder;
		});
		local SectionButton = library:Create("ImageButton",{
			Name = "Section Button";
			Parent = SectionPart;
			BackgroundColor3 = Color3.fromRGB(114, 137, 218);
			BackgroundTransparency = 1.000;
			BorderColor3 = Color3.fromRGB(114, 137, 218);
			Size = UDim2.new(1, 0, 0, 35);
			Image = "http://www.roblox.com/asset/?id=4846243410";
			ImageColor3 = Color3.fromRGB(30, 30, 30);
		});
		local SectionTEXT = library:Create("TextLabel",{
			Name = "Section TEXT";
			Parent = SectionButton;
			BackgroundColor3 = Color3.fromRGB(255, 255, 255);
			BackgroundTransparency = 1.000;
			BorderColor3 = Color3.fromRGB(0, 0, 0);
			BorderSizePixel = 0;
			Position = UDim2.new(0.0500000007, 0, -0.0571428575, 0);
			Size = UDim2.new(0, 189, 1, 0);
			Font = Enum.Font.GothamSemibold;
			Text = Name;
			TextColor3 = Color3.fromRGB(255, 48, 51);
			TextSize = 18.000;
			TextXAlignment = Enum.TextXAlignment.Left;
		});
		library:Create("UIPadding",{
			Parent = SectionContainer;
			PaddingBottom = UDim.new(0, 5);
			PaddingTop = UDim.new(0, 6);
		});

		SectionButton.MouseButton1Click:Connect(function()
			self.Toggled = not self.Toggled
			if self.Toggled then
				Tween(SectionContainer, {Size = UDim2.new(0, 208, 0, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, false)
				Tween(SectionPart, {Size = UDim2.new(0, 208, 0, 35)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, false)
				Tween(SectionTEXT, {TextColor3 = Color3.fromRGB(255, 48, 51),}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, false)
			else
				Tween(SectionContainer, {Size = UDim2.new(0, 208, 0, SectionUIListLayout.AbsoluteContentSize.Y + 10 )}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, false)
				Tween(SectionPart, {Size = UDim2.new(0, 208, 0, SectionUIListLayout.AbsoluteContentSize.Y + 35 )}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, false)
				Tween(SectionTEXT, {TextColor3 = Color3.fromRGB(145, 255, 71),}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, true)
				Tween(Container, {Size =  UDim2.new(0, 208, 0, ContainerUIListLayout.AbsoluteContentSize.Y)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
			end
		end)

		function Section:Label(Name)
			local LabelFrame = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			LabelFrame.Name = "Label Frame"
			LabelFrame.Parent = SectionContainer
			LabelFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			LabelFrame.BackgroundTransparency = 0.75
			LabelFrame.BorderSizePixel = 0;
			LabelFrame.Size = UDim2.new(1, 0, 0, 20)

			TextLabel.Parent = LabelFrame
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.Position = UDim2.new(0.0689999983, 0, 0, -3)
			TextLabel.Size = UDim2.new(0.882000029, 0, 0, 25)
			TextLabel.Font = Enum.Font.GothamSemibold
			TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextSize = 15.000
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.Text = Name
			TextLabel.BorderSizePixel = 0;
		end

		function Section:Button(Name, Function)
			local ButtonFrame = library:Create("Frame", {
				Name = "Button Frame";
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Size = UDim2.new(1, 0, 0, 35);
			});
			local Button = library:Create("TextButton", {
				Name = "Button";
				Parent = ButtonFrame;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Size = UDim2.new(1, 0, 0, 35);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
			});
			local ButtonBackground = library:Create("ImageLabel", {
				Name = "Button Background";
				Parent = Button;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);

				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.499760836, 0, 0.485714287, 0);
				Selectable = true;
				Size = UDim2.new(0.90861249, 0, 0.879999995, 0);
				ZIndex = 2;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.075;
			});
			
			--Script part
			Button.MouseButton1Click:connect(Function)

		end

		function Section:Toggle(Name, Options, callback)
			if not library.flags then
				library.flags = {}
			end

			local Toggle = library:Create("Frame",{
				Name = "Toggle";
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(27, 42, 53);
				Position = UDim2.new(0, 0, 0.103244841, 0);
				Size = UDim2.new(1, 0, 0, 35);
			});
			local ToggleTextBackground = library:Create("ImageLabel",{
				Name = "Toggle Text Background";
				Parent = Toggle;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.339941978, 0, 0.485714287, 0);
				Selectable = true;
				Size = UDim2.new(0.588999987, 0, 0.75, 0);
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.075;
			});
			local ToggleText = library:Create("TextLabel",{
				Name = "Toggle Text";
				Parent = ToggleTextBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.0568663031, 0, -0.0324675329, 0);
				Size = UDim2.new(0.959999979, 0, 1, 0);
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
				TextScaled = (string.len(tostring(Name)) > 10 and true) or false;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local ToggleButtonOutline = library:Create("ImageButton",{
				Name = "Toggle Button Outline";
				Parent = Toggle;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.668269217, 0, 0.0285714287, 0);
				Size = UDim2.new(0.177000001, 25, 0.75, 0);
				Image = "http://www.roblox.com/asset/?id=4875185102";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
			});
			local ToggleInsideColor = library:Create("ImageLabel",{
				Name = "Toggle Inside Color";
				Parent = ToggleButtonOutline;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 0, 0.190476194, 0);
				Size = UDim2.new(0.949999988, 0, 0.876999974, 0);
				Image = "http://www.roblox.com/asset/?id=4875187236";
			});
			local ColorGradient = library:Create("UIGradient",{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 48, 51)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 225, 100))};
				Offset = Vector2.new(1, 0);
				Parent = ToggleInsideColor;
			});
			local CirclePart = library:Create("ImageLabel",{
				Name = "Circle Part";
				Parent = ToggleInsideColor;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(255, 255, 255);
				Position = UDim2.new(0.0170000009, 0, 0.0399999991, 0);
				Size = UDim2.new(0, 22, 0, 22);
			});
			local CircleText = library:Create("TextLabel",{
				Name = "Circle Text";
				Parent = CirclePart;
				Active = true;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Size = UDim2.new(1, 0, 1, 0);
				SizeConstraint = Enum.SizeConstraint.RelativeYY;
				ZIndex = 2;
				Font = Enum.Font.GothamSemibold;
				Text = "X";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 20.000;
			});
			local check = library:Create("ImageLabel",{
				Name = "check";
				Parent = CirclePart;
				Active = true;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, -9, 0.5, -9);
				Size = UDim2.new(0.75, 0, 0.75, 0);
				Image = "http://www.roblox.com/asset/?id=4555411759";
				ImageColor3 = Color3.fromRGB(0, 0, 0);
				ImageTransparency = 1.000;
			});

			local location = Options.location or library.flags;
			local flagName = Options.flag or "";
			location[flagName] = Options.Default or flase

			ToggleButtonOutline.MouseButton1Click:Connect(function()
				if callback then callback(not location[flagName]) end
				if location[flagName] then 
					Tween(CirclePart, {Position = UDim2.new(0.017, 0, 0.05, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, false)
					Tween(ColorGradient, {Offset = Vector2.new(1, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
					CircleText.TextTransparency = 0
					check.ImageTransparency = 1
					location[flagName] = false;
				else
					Tween(CirclePart, {Position = UDim2.new(0.6, 0, 0.05, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, false)
					Tween(ColorGradient, {Offset = Vector2.new(-1, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.1, true)
					CircleText.TextTransparency = 1
					check.ImageTransparency = 0
					location[flagName] = true;
				end
			end)
		end

		function Section:Box(Name, Options, callback)
			if not library.flags then
				library.flags = {}
			end
			local Box = library:Create("Frame",{
				Name = "Box";
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 0, 0.103244841, 0);
				Size = UDim2.new(1, 0, 0, 35);
			});
			local BoxTextBackground = library:Create("ImageLabel",{
				Name = "Box Text Background";
				Parent = Box;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.339950055, 0, 0.485714287, 0);
				Selectable = true;
				Size = UDim2.new(0.588999987, 0, 0.75, 0);
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.075;
			});
			local BoxText = library:Create("TextLabel",{
				Name = "Box Text";
				Parent = BoxTextBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.0399726853, 0, 0, 0);
				Size = UDim2.new(0.959999979, 0, 1, 0);
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local BoxValue = library:Create("TextBox",{
				Name = "Box Value";
				Parent = Box;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0.669767678, 0, 0.0857142881, 0);
				Size = UDim2.new(0.177000001, 25, 0.75, 0);
				ZIndex = 2;
				Font = Enum.Font.GothamSemibold;
				PlaceholderText = Options.Default;
				Text = Options.Default or "No value";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
			});
			local BoxValueBackground = library:Create("ImageLabel",{
				Name = "Box Value Background";
				Parent = BoxValue;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.501089334, 0, 0.454545468, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.100;
			});

			local Type = Options.Type or "number"
			local location = Options.location or library.flags;
			local flagName = Options.flag or "";
			location[flagName] = Options.Default or ( Options.Type == 'string' and "") or 0
			
			BoxValue.FocusLost:Connect(function()
				if Type == "string" then
					location[flagName] = tostring(BoxValue.Text)
				else
					local Number = tonumber(BoxValue.Text)
					if Number == nil or Number == "" then
						Number = Options.Default
						BoxValue.Text = Options.Default
					else
						if Options.Min ~= nil and Number < Options.Min then
							Number = Options.Min
							BoxValue.Text = Options.Min
						end
						if Options.Max ~= nil and Number > Options.Max then
							Number = Options.Max
							BoxValue.Text = Options.Max
						end
					end
					location[flagName] = Number
				end
				if callback then callback() end
			end)
		end

		function Section:Bind(Name, Options, callback)
			local Keybind = library:Create("Frame",{
				Name = "Keybind ";
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 0, 0.103244841, 0);
				Size = UDim2.new(1, 0, 0, 35);
			});
			local KeybindTextBackground = library:Create("ImageLabel",{
				Name = "Keybind Text Background";
				Parent = Keybind;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.339950055, 0, 0.485714287, 0);
				Selectable = true;
				Size = UDim2.new(0.588999987, 0, 0.75, 0);
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.075;
			});
			local KeybindText = library:Create("TextLabel",{
				Name = "Keybind Text";
				Parent = KeybindTextBackground;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.042825792, 0, -0.0324675329, 0);
				Size = UDim2.new(0.959999979, 0, 1, 0);
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local KeybindButton = library:Create("TextButton",{
				Name = "Keybind Button";
				Parent = Keybind;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.669444978, 0, 0.0859998465, 0);
				Size = UDim2.new(0.177000001, 25, 0.75, 0);
				ZIndex = 2;
				Font = Enum.Font.GothamSemibold;
				Text = "None";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
			});
			local KeybindBackground = library:Create("ImageLabel",{
				Name = "Keybind Background";
				Parent = KeybindButton;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.501089334, 0, 0.454545468, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.100;
			});

            local banned = {
                Return = true;
                Space = true;
                Tab = true;
                Unknown = true;
            }
            
            local shortNames = {
                RightControl = 'RightCtrl';
                LeftControl = 'LeftCtrl';
                LeftShift = 'LShift';
                RightShift = 'RShift';
                MouseButton1 = "Mouse1";
				MouseButton2 = "Mouse2";
				MouseButton3 = "Mouse3";
            }
            
            local allowed = {
                MouseButton1 = true;
				MouseButton2 = true;
				MouseButton3 = true;
				MouseButton4 = true;
			}  
			
			local location = Options.location or library.flags;
			local flagName = Options.flag or "";
			location[flagName] = Options.Default or Enum.UserInputType.None

			local callback = callback or function() end;

			KeybindButton.MouseButton1Click:Connect(function()
				library.binding = true

				KeybindButton.Text = '...'
				local a, b = game:GetService('UserInputService').InputBegan:wait()
				local name = tostring(a.KeyCode.Name)
				local typeName = tostring(a.UserInputType.Name)

				if a.KeyCode == Enum.KeyCode.Delete then
					location[flagName] = Enum.UserInputType.None
					KeybindButton.Text = 'None'
				elseif (a.UserInputType ~= Enum.UserInputType.Keyboard and (allowed[a.UserInputType.Name]) and (not keyboardOnly)) or (a.KeyCode and (not banned[a.KeyCode.Name])) then
					local name = a.UserInputType ~= Enum.UserInputType.Keyboard and a.UserInputType.Name or a.KeyCode.Name;
                    location[flagName] = (a);
                    KeybindButton.Text = shortNames[name] or name;
                else
                    if location[flagName] then
                        if not pcall(function()
                            return location[flagName].UserInputType
                        end) then
                            local name = tostring(location[flagName])
                            KeybindButton.Text = shortNames[name] or name
                        else
                            local name = location[flagName].UserInputType ~= Enum.UserInputType.Keyboard and location[flagName].UserInputType.Name or location[flagName].KeyCode.Name;
                            KeybindButton.Text = shortNames[name] or name;
                        end
                    end
                end

                wait(0.1)  
                library.binding = false;
			end)

            library.binds[flagName] = {
                location = location;
                callback = callback;
            };
		end

		function Section:Slider(Name, Options, callback)
			local Slider = library:Create("Frame",{
				Name = "Slider";
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 0, 0.412979364, 0);
				Size = UDim2.new(1, 0, 0, 60);
			});
			local BackgroundFrame = library:Create("ImageLabel",{
				Name = "Background Frame";
				Parent = Slider;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.0480000265, 0, 0.0500000007, 0);
				Size = UDim2.new(0.916999996, 0, 0.833333313, 0);
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.125;
			});
			local SliderName = library:Create("TextLabel",{
				Name = "SliderName";
				Parent = BackgroundFrame;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.0230727084, 0, 0, 0);
				Size = UDim2.new(0.616797447, 0, 0.5, 0);
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local slider = library:Create("TextButton",{
				Name = "slider";
				Parent = BackgroundFrame;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Size = UDim2.new(1, 0, 1, 0);
				Font = Enum.Font.GothamSemibold;
				Text = "";
				TextColor3 = Color3.fromRGB(0, 0, 0);
				TextSize = 14.000;
			});
			local line = library:Create("Frame",{
				Name = "line";
				Parent = slider;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
				Position = UDim2.new(0.0727822408, 0, 0.639999986, 0);
				Size = UDim2.new(0, 160, 0, 2);
			});
			local UIGradient = library:Create("UIGradient",{
				Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))};
				Parent = line;
			});
			local fill = library:Create("ImageLabel",{
				Name = "fill";
				Parent = line;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Size = UDim2.new(0, 0, 1, 0);
				ZIndex = 3;
				Image = "rbxassetid://4550094458";
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(4, 4, 296, 296);
			});
			local Frame = library:Create("ImageLabel",{
				Name = "Frame";
				Parent = line;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 0, -4, 0);
				Size = UDim2.new(0, 3, 8, 0);
				ZIndex = 4;
				Image = "rbxassetid://4550094458";
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(4, 4, 296, 296);
			});
			local SliderValue = library:Create("TextBox",{
				Name = "SliderValue";
				Parent = BackgroundFrame;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.689999998, 0, 0.100000001, 0);
				Size = UDim2.new(0.319999993, 0, 0.300000012, 0);
				Font = Enum.Font.GothamSemibold;
				PlaceholderColor3 = Color3.fromRGB(131, 131, 131);
				PlaceholderText = "_____";
				Text = Options.Default or "nil";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
				TextSize = 15.000;
				TextWrapped = true;
			});
			local location = Options.location or library.flags;
			local flagName = Options.flag or "";
			location[flagName] = Options.Default or 0

			Options.Min = Options.Min or 0
			Options.Max = Options.Max or 100
			Options.Default = Options.Default or 0
			Options.Precise = Options.Precise or false
			
			local min = ( Options.Min < 0 and -Options.Min ) or Options.Min 
			local max = ( Options.Max < 0 and -Options.Max ) or Options.Max 
			local diff = max + min

			function SetSliderValue(number)
				if (not number) then return end
					
				local percent = 1 - ((Options.Max - number) / (Options.Max - Options.Min ))
			
				SliderValue.Text = math.floor(number * 100)/100;
				Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.025, false)
				Tween(Frame, {Position = UDim2.new(percent, 0, 0, -7)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.025, true)
				location[flagName] = math.floor(number * 100)/100
				if callback then callback(location[flagName]) end
			end

			SliderValue.FocusLost:Connect(function(e)
				if e and tonumber(SliderValue.Text) then
					local num = tonumber(SliderValue.Text)
					SetSliderValue(math.clamp(num, Options.Min, Options.Max))
				else
					input.Text = location[flagName]
				end
			end)

			game:GetService("UserInputService").InputEnded:connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					held = false
					ActiveSlider = nil
				end
			end)

			slider.MouseButton1Down:connect(function()
				if ActiveSlider == nil then
					ActiveSlider = flagName
					held = true
				end
			end)

			Heartbeat:connect(function()
				if held and ActiveSlider == flagName then
			        local mouse = game:GetService("UserInputService"):GetMouseLocation()
					local percent = (mouse.X - slider.AbsolutePosition.X) / (slider.AbsoluteSize.X)
					percent = math.clamp(percent, 0, 1)
			        local Value = Options.Min + (Options.Max - Options.Min) * percent;
				
			        if not Options.Precise then
					    Value = math.floor(Value);
			        end;
				
			        Tween(fill, {Size = UDim2.new(percent, 0, 1, 0)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.025, false)
			        Tween(Frame, {Position = UDim2.new(percent, 0, 0, -7)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.025, true)
				
			        SliderValue.Text = math.floor(Value * 100)/100
					location[flagName] = math.floor(Value * 100)/100
					
					if callback then callback(location[flagName]) end
				end
			end)
		end

		function Section:Dropdown(Name, Options, callback)
			local Dropdown = library:Create("Frame",{
				Name = "Dropdown";
				BorderSizePixel = 0;
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 0, 0.293107003, 0);
				Size = UDim2.new(1, 0, 0, 40);
			});
			local DropdownButton = library:Create("TextButton",{ -- DROPDOWN TOGGLE
				Name = "Dropdown Button";
				Parent = Dropdown;
				BackgroundColor3 = Color3.fromRGB(80, 80, 80);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				ClipsDescendants = true;
				Size = UDim2.new(1, 0, 0, 40);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				LineHeight = 2.000;
				Text = "";
				TextColor3 = Color3.fromRGB(0, 0, 0);
				TextSize = 14.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			}); 
			local DropdownBackground = library:Create("ImageLabel",{
				Name = "Dropdown Background";
				Parent = DropdownButton;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0.502301931, 0, 0.454545468, 0);
				Selectable = true;
				Size = UDim2.new(0.905082345, 0, 0.909090936, 0);
				ZIndex = 3;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(28, 28, 28);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.080;
			});
			local DropdownName = library:Create("TextLabel",{
				Name = "Dropdown Name";
				Parent = DropdownButton;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0.0765550211, 0, 0, 0);
				Size = UDim2.new(0.842105329, 0, 0, 25);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local ArrowImage = library:Create("ImageLabel",{
				Name = "Arrow Image";
				Parent = DropdownButton;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(27, 42, 53);
				BorderSizePixel = 0;
				Position = UDim2.new(0.789473712, 0, 0.0606060624, 0);
				Size = UDim2.new(0, 25, 0, 25);
				ZIndex = 3;
				Image = "http://www.roblox.com/asset/?id=4877238073";
			});
			local DropLine = library:Create("Frame",{
				Name = "Drop Line";
				Parent = DropdownButton;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BorderColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
				Position = UDim2.new(0.0789406002, 0, 0.75757575, 0);
				Size = UDim2.new(0, 175, 0, 1);
				ZIndex = 3;
			});
			local DropMenu = library:Create("ScrollingFrame",{
				Name = "Drop Menu";
				Parent = Dropdown;
				Active = true;
				BackgroundColor3 = Color3.fromRGB(28, 28, 28);
				BorderColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
				Position = UDim2.new(0.0480000004, 0, 0, 31);
				Size = UDim2.new(0, 189, 0, 0);
				SizeConstraint = Enum.SizeConstraint.RelativeYY;
				ZIndex = 2;
				BottomImage = "";
				CanvasSize = UDim2.new(0, 160, 0, 250);
				MidImage = "http://www.roblox.com/asset/?id=4878091618";
				ScrollBarThickness = 0;
				TopImage = "";
				VerticalScrollBarInset = Enum.ScrollBarInset.Always;
			});
			local DropListLayout = library:Create("UIListLayout",{
				Name = "Drop List Layout";
				Parent = DropMenu;
				HorizontalAlignment = Enum.HorizontalAlignment.Center;
				SortOrder = Enum.SortOrder.LayoutOrder;
				Padding = UDim.new(0, 2);
			});
			library:Create("UIPadding",{
				Name = "Drop Padding";
				Parent = DropMenu;
				PaddingLeft = UDim.new(0, 5);
				PaddingRight = UDim.new(0, 5);
				PaddingTop = UDim.new(0, 5);
			});

			function GetLengthOfDirectory(AAA)
				local length = 0
				for i,v in pairs(AAA) do
					length = length + 1
				end
				return length
			end

			local location = Options.location or library.flags;
			local flagName = Options.flag or "";
			local Dropdown_Type = Options.Type or 'Normal'
			location[flagName] = (Options.Default) or (Dropdown_Type == 'Toggle' and {}) or ("")
			local Dropdown_List = Options.list or {}
			local Dropdown_List_Type = ( #Dropdown_List ~= 0 and "Table" ) or "Directory"
			local CurrentState = false
			local NewSize = 0
			local tweeeeeeeeeeeeening = false
			local function ToggleDropdown(state)
				if not tweeeeeeeeeeeeening then
					CurrentState = state or not CurrentState
					if CurrentState then 
						tweeeeeeeeeeeeening = true
						local ListLength =( Dropdown_List_Type == 'Table' and #Dropdown_List ) or ( GetLengthOfDirectory(Dropdown_List) )
						NewSize = ( ListLength > 3 and 113 ) or (32 * #Dropdown_List + 27)
						DropMenu.CanvasSize = UDim2.new(1, -25, 0, (ListLength * 27) + 32)
						DropMenu.ScrollBarThickness = 5;
						Tween(DropMenu, { Size = UDim2.new(0, 189, 0, NewSize), ScrollBarImageTransparency = 0 }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(ArrowImage, { Rotation = 90 }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(Dropdown, { Size = UDim2.new(1, 0, 0, 40 + NewSize) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(SectionPart, { Size = UDim2.new(0, 208, 0, SectionPart.Size.Y.Offset + NewSize) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)		
						Tween(SectionContainer, { Size = UDim2.new(0, 208, 0, SectionContainer.Size.Y.Offset + NewSize) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, true)
						Tween(Container, {Size =  UDim2.new(0, 208, 0, ContainerUIListLayout.AbsoluteContentSize.Y)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.15, true)
						tweeeeeeeeeeeeening = false
						local DroppedButtonBackground = library:Create("ImageLabel",{
							Name = "Dropdown Search Background";
							Parent = DropMenu;
							BackgroundColor3 = Color3.fromRGB(255, 255, 255);
							BackgroundTransparency = 1.000;
							Size = UDim2.new(1, 0, 0, 25);
							ZIndex = 2;
							Image = "http://www.roblox.com/asset/?id=4878273688";
							ImageColor3 = Color3.fromRGB(45, 45, 45);
						});
						local DroppedSearch = library:Create("TextBox",{
							Name = "Dropdown Searcherino";
							Parent = DroppedButtonBackground;
							BackgroundColor3 = Color3.fromRGB(255, 255, 255);
							BackgroundTransparency = 1.000;
							BorderSizePixel = 0;
							Position = UDim2.new(0, 0, 0, -1);
							Size = UDim2.new(1, 0, 1, 0);
							ZIndex = 4;
							Font = Enum.Font.GothamSemibold;
							PlaceholderText = 'Searchbar';
							Text = "";
							TextColor3 = Color3.fromRGB(255, 255, 255);
							TextSize = 15.000;
						});
						local MagnifyingGlassImage = library:Create("ImageLabel",{
							Name = "MagnifyingGlassImage";
							Parent = DroppedSearch;
							BackgroundTransparency = 1;
							Size = UDim2.new(0, 18, 0, 18);
							Position = UDim2.new(0, 6, 0, 4);
							ZIndex = 3;
							Image = "http://www.roblox.com/asset/?id=3229196465";
							ImageColor3 = Color3.fromRGB(255, 255, 255);
						});
						DroppedSearch:GetPropertyChangedSignal("Text"):connect(function()
							if DroppedSearch:IsFocused() then
								for i,v in pairs(DropMenu:GetChildren()) do
									if v.Name == 'Dropdown Button Background' then
										warn(string.find(string.lower(v['Dropdown Button'].Text), string.lower(DroppedSearch.Text)))
										if string.find(string.lower(v['Dropdown Button'].Text), string.lower(DroppedSearch.Text)) then
											v.Visible = true
										else
											v.Visible = false
										end
									end
								end
							end
						end)
						for i,v in (( Dropdown_List_Type == 'Table' and ipairs ) or pairs )(Dropdown_List) do
							local DroppedButtonBackground = library:Create("ImageLabel",{
								Name = "Dropdown Button Background";
								Parent = DropMenu;
								BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								BackgroundTransparency = 1.000;
								Size = UDim2.new(1, 0, 0, 25);
								ZIndex = 2;
								Image = "http://www.roblox.com/asset/?id=4878273688";
								ImageColor3 = Color3.fromRGB(35, 35, 35);
							});
							local DroppedButton = library:Create("TextButton",{
								Name = "Dropdown Button";
								Parent = DroppedButtonBackground;
								BackgroundColor3 = Color3.fromRGB(255, 255, 255);
								BackgroundTransparency = 1.000;
								BorderSizePixel = 0;
								Position = UDim2.new(0, 0, 0, -1);
								Size = UDim2.new(1, 0, 1, 0);
								ZIndex = 3;
								Font = Enum.Font.GothamSemibold;
								Text = v;
								TextColor3 = ((Dropdown_Type == 'Toggle' and table.find(location[flagName], v)) or (Dropdown_Type == 'Normal' and location[flagName] == v)) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255, 255, 255);
								TextSize = 15.000;
							});
							DroppedButton.MouseButton1Click:Connect(function()
								if Dropdown_Type == 'Toggle' then
									if DroppedButton.TextColor3 == Color3.fromRGB(255,255,255) then
										DroppedButton.TextColor3 = Color3.fromRGB(0,255,0)
									else
										DroppedButton.TextColor3 = Color3.fromRGB(255,255,255)
									end

									local TempTable = {}
									for i,v in pairs(DropMenu:GetChildren()) do
										if v.Name == "Dropdown Button Background" and v["Dropdown Button"].TextColor3 == Color3.fromRGB(0,255,0) then
											table.insert(TempTable, v["Dropdown Button"].Text)
										end
									end
									location[flagName] = TempTable
								else
									location[flagName] = v
									ToggleDropdown(state)
								end
								if callback then callback(not location[flagName]) end
							end)
						end
					else
						tweeeeeeeeeeeeening = true
						DropMenu.CanvasSize = UDim2.new(0, DropMenu.Size.X.Offset, 0, DropMenu.Size.Y.Offset + 12)
						Tween(DropMenu, { Size = UDim2.new(0, 189, 0, 0), ScrollBarImageTransparency = 1 }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(ArrowImage, { Rotation = 0 }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(Dropdown, { Size = UDim2.new(1, 0, 0, 40) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(SectionPart, { Size = UDim2.new(0, 208, 0, SectionPart.Size.Y.Offset - NewSize) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)		
						Tween(SectionContainer, { Size = UDim2.new(0, 208, 0, SectionContainer.Size.Y.Offset - NewSize) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, false)
						Tween(Container, {Size =  UDim2.new(0, 208, 0, ContainerUIListLayout.AbsoluteContentSize.Y)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.25, true)
						tweeeeeeeeeeeeening = false
						for i,v in pairs(DropMenu:GetChildren()) do
							if v.ClassName == 'ImageLabel' then
								v:Destroy()
							end
						end
					end
				end
			end

			DropdownButton.MouseButton1Click:Connect(function()
				ToggleDropdown()
			end)	

		end

		function Section:ColorPicker(Name, Options, callback)
			local ColorPicker = library:Create("Frame",{
				Name = "Color Picker";
				Parent = SectionContainer;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 0, 0.492985964, 0);
				Size = UDim2.new(0, 208, 0, 35);
			});
			local ColorToggleButton = library:Create("TextButton",{
				Name = "Color Toggle Button";
				Parent = ColorPicker;
				BackgroundColor3 = Color3.fromRGB(80, 80, 80);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				ClipsDescendants = true;
				Size = UDim2.new(1, 0, 0, 35);
				ZIndex = 5;
				Font = Enum.Font.GothamSemibold;
				LineHeight = 2.000;
				Text = "";
				TextColor3 = Color3.fromRGB(0, 0, 0);
				TextSize = 14.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local ColorPickerBackground = library:Create("ImageLabel",{
				Name = "Color Picker Background";
				Parent = ColorToggleButton;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0.501999974, 0, 0, 15);
				Selectable = true;
				Size = UDim2.new(0.904999971, 0, 0, 30);
				ZIndex = 3;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(255, 0, 0);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.080;
			});
			local ColorPickerName = library:Create("TextLabel",{
				Name = "Color Picker Name";
				Parent = ColorToggleButton;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 15, 0, 2);
				Size = UDim2.new(0.842105329, 0, 0, 25);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				Text = Name;
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
				TextXAlignment = Enum.TextXAlignment.Left;
			});
			local ColorMenu = library:Create("Frame",{
				Name = "Color Menu";
				Parent = ColorPicker;
				Active = true;
				BackgroundColor3 = Color3.fromRGB(28, 28, 28);
				BorderColor3 = Color3.fromRGB(255, 255, 255);
				BorderSizePixel = 0;
				ClipsDescendants = true;
				Position = UDim2.new(0.0483173206, 0, 0.0904937759, 0);
				Selectable = true;
				Size = UDim2.new(0, 188, 0, 0);
				SizeConstraint = Enum.SizeConstraint.RelativeYY;
				ZIndex = 2;
			});
			local BlueBox = library:Create("TextBox",{
				Name = "BlueBox";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 121, 0, 52);
				Size = UDim2.new(0, 60, 0, 20);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				PlaceholderColor3 = Color3.fromRGB(16, 192, 255);
				PlaceholderText = "B";
				Text = "0";
				TextColor3 = Color3.fromRGB(16, 192, 255);
				TextSize = 15.000;
			});
			local BlueBoxBackground = library:Create("ImageLabel",{
				Name = "BlueBox Background";
				Parent = BlueBox;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 2;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(50, 50, 50);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.040;
			});
			local GreenBox = library:Create("TextBox",{
				Name = "GreenBox";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 121, 0, 29);
				Size = UDim2.new(0, 60, 0, 20);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				PlaceholderColor3 = Color3.fromRGB(0, 255, 64);
				PlaceholderText = "G";
				Text = "0";
				TextColor3 = Color3.fromRGB(0, 255, 64);
				TextSize = 15.000;
			});
			local GreeBoxnBackground = library:Create("ImageLabel",{
				Name = "GreenBox Background";
				Parent = GreenBox;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 2;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(50, 50, 50);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.040;
			});
			local HexBox = library:Create("TextBox",{
				Name = "HexBox";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 121, 0, 75);
				Size = UDim2.new(0, 60, 0, 20);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
				PlaceholderText = "Hex";
				Text = "FF0000";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextScaled = true;
				TextSize = 15.000;
				TextWrapped = true;
			});
			local HexBoxBackground = library:Create("ImageLabel",{
				Name = "HexBox Background";
				Parent = HexBox;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 2;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(50, 50, 50);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.040;
			});
			local RedBox = library:Create("TextBox",{
				Name = "RedBox";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 121, 0, 6);
				Size = UDim2.new(0, 60, 0, 20);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				PlaceholderColor3 = Color3.fromRGB(255, 60, 63);
				PlaceholderText = "R";
				Text = "255";
				TextColor3 = Color3.fromRGB(255, 60, 63);
				TextSize = 15.000;
			});
			local RedBoxBackground = library:Create("ImageLabel",{
				Name = "RedBox Background";
				Parent = RedBox;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 2;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(50, 50, 50);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.040;
			});
			library:Create("UIPadding",{
				Parent = ColorMenu;
				PaddingTop = UDim.new(0, 10);
			});
			local HueSlider = library:Create("ImageButton",{
				Name = "HueSlider";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(255, 255, 255);
				Position = UDim2.new(0, 10, 0, 110);
				Size = UDim2.new(0, 100, 0, 20);
				ZIndex = 3;
				Image = "http://www.roblox.com/asset/?id=4981662027";
			});
			local HueSliderBtn = library:Create("ImageLabel",{
				Name = "HueSliderBtn";
				Parent = HueSlider;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, -5, 0, 5);
				Size = UDim2.new(0, 10, 0, 10);
				ZIndex = 69;
				Image = "http://www.roblox.com/asset/?id=4971957189";
			});
			local OpacitySlider = library:Create("ImageButton",{
				Name = "Opacity Slider";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(255, 255, 255);
				Position = UDim2.new(0, 10, 0, 135);
				Size = UDim2.new(0, 100, 0, 20);
				ZIndex = 3;
				Image = "http://www.roblox.com/asset/?id=4981661543";
			});
			local OpacitySliderGradient = library:Create("ImageLabel",{
				Name = "OpacitySliderGradient";
				Parent = OpacitySlider;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 4;
				Image = "http://www.roblox.com/asset/?id=4981661041";
				ImageColor3 = Color3.fromRGB(255, 0, 4);
			});
			local OpacitySliderBtn = library:Create("ImageLabel",{
				Name = "OpacitySliderBtn";
				Parent = OpacitySlider;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0, 95, 0, 5);
				Size = UDim2.new(0, 10, 0, 10);
				ZIndex = 69;
				Image = "http://www.roblox.com/asset/?id=4971957189";
			});
			local OpacityBox = library:Create("TextBox",{
				Name = "OpacityBox";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 121, 0, 98);
				Size = UDim2.new(0, 60, 0, 20);
				ZIndex = 3;
				Font = Enum.Font.GothamSemibold;
				PlaceholderColor3 = Color3.fromRGB(178, 178, 178);
				PlaceholderText = "Opacity";
				Text = "1";
				TextColor3 = Color3.fromRGB(255, 255, 255);
				TextSize = 15.000;
			});
			local OpacityBackground = library:Create("ImageLabel",{
				Name = "Opacity Background";
				Parent = OpacityBox;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 2;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(50, 50, 50);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.040;
			});
			local RainbowButton = library:Create("TextButton",{
				Name = "Rainbow Button";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Position = UDim2.new(0, 121, 0, 121);
				Size = UDim2.new(0, 60, 0, 20);
				ZIndex = 4;
				Font = Enum.Font.GothamSemibold;
				Text = "Rainbow";
				TextColor3 = Color3.fromRGB(0, 207, 204);
				TextSize = 13.000;
				TextWrapped = true;
			});
			local RainbowButtonbackground = library:Create("ImageLabel",{
				Name = "Rainbow Button background";
				Parent = RainbowButton;
				Active = true;
				AnchorPoint = Vector2.new(0.5, 0.5);
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(38, 0, 255);
				BorderSizePixel = 0;
				Position = UDim2.new(0.5, 0, 0.5, 0);
				Selectable = true;
				Size = UDim2.new(1, 0, 1, 0);
				ZIndex = 3;
				Image = "rbxassetid://3570695787";
				ImageColor3 = Color3.fromRGB(255, 48, 51);
				ScaleType = Enum.ScaleType.Slice;
				SliceCenter = Rect.new(100, 100, 100, 100);
				SliceScale = 0.040;
			});
			local PickerItslef = library:Create("ImageButton",{
				Name = "Picker Itslef";
				Parent = ColorMenu;
				BackgroundColor3 = Color3.fromRGB(255, 0, 0);
				BackgroundTransparency = 1.000;
				BorderColor3 = Color3.fromRGB(0, 0, 0);
				BorderSizePixel = 0;
				Position = UDim2.new(0, 10, 0, 6);
				Size = UDim2.new(0, 100, 0, 100);
				ZIndex = 3;
				Image = "http://www.roblox.com/asset/?id=4974035897";
				ImageColor3 = Color3.fromRGB(255, 0, 0)
			});
			local Lightness = library:Create("ImageLabel",{
				Name = "Lightness";
				Parent = PickerItslef;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Size = UDim2.new(0, 100, 0, 100);
				ZIndex = 3;
				Image = "http://www.roblox.com/asset/?id=4974037264";
			});
			local Darkness = library:Create("ImageLabel",{
				Name = "Darkness";
				Parent = PickerItslef;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				BorderSizePixel = 0;
				Size = UDim2.new(0, 100, 0, 100);
				ZIndex = 3;
				Image = "http://www.roblox.com/asset/?id=4974036202";
				ImageColor3 = Color3.fromRGB(0, 0, 0);
			});
			local SVDot = library:Create("ImageLabel",{
				Name = "SVDot";
				Parent = PickerItslef;
				BackgroundColor3 = Color3.fromRGB(255, 255, 255);
				BackgroundTransparency = 1.000;
				Position = UDim2.new(0.903813541, 0, 0, 0);
				Size = UDim2.new(0, 10, 0, 10);
				ZIndex = 5;
				Image = "http://www.roblox.com/asset/?id=4971957189";
			});

			local location = Options.location or library.flags;
			local flagName = Options.flag or "";
			location[flagName] = { ['Colour'] = Options.Default or Color3.fromRGB(255,255,255); ['Opacity'] = Options.DefaultOpacity or 0 }
			
			local Toggled = false
			local DropTweeningStatus = false
			ColorToggleButton.MouseButton1Click:connect(function()
				if DropTweeningStatus == false then
					if Toggled then
						Toggled = false
						DropTweeningStatus = true
						Tween(ColorPicker, { Size = UDim2.new(0, 208, 0, 35) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, false)
						Tween(ColorMenu, { Size = UDim2.new(0, 188, 0, 0) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
						Tween(SectionPart, { Size = UDim2.new(0, 208, 0, SectionPart.Size.Y.Offset - 155) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)		
						Tween(SectionContainer, {Size = UDim2.new(0, 208, 0, SectionUIListLayout.AbsoluteContentSize.Y + 10)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, false)
						Tween(Container, {Size =  UDim2.new(0, 208, 0, ContainerUIListLayout.AbsoluteContentSize.Y)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, true)
						DropTweeningStatus = false
					else
						Toggled = true
						DropTweeningStatus = true
						Tween(ColorPicker, { Size = UDim2.new(0, 208, 0, 190) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, false)
						Tween(ColorMenu, { Size = UDim2.new(0, 188, 0, 165) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)
						Tween(SectionPart, { Size = UDim2.new(0, 208, 0, SectionPart.Size.Y.Offset + 155) }, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0, true)		
						Tween(SectionContainer, {Size = UDim2.new(0, 208, 0, SectionUIListLayout.AbsoluteContentSize.Y + 10)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, false)
						Tween(Container, {Size =  UDim2.new(0, 208, 0, ContainerUIListLayout.AbsoluteContentSize.Y)}, Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.2, true)
						DropTweeningStatus = false	
					end
				end
			end)

			local GlobalRainbowColor = Color3.new()
			local GlobalRainbowHColor = 1
			local RainbowToggled = false
			local Red_Last = ''
			local Green_Last = ''
			local Blue_Last = ''
			local R, G, B
			local Hex_Last = ''
			local Opacity_Last = ''
			local HexNumber, Hue, Saturation, Value, Color


			function HueMove(Hue)
				HueSliderBtn.Position = UDim2.new(Hue, -5, 0, 5)
			end

			function Tween(Object, Goal, Direction, Style, Time, WaitForTween)
			    Style = Style or {}
			    local Tween = game:GetService("TweenService"):Create(Object,TweenInfo.new( Time, Style, Direction ), Goal)
			    Tween:Play()
			    if WaitForTween then
			        Tween.Completed:wait()
			    end
			end

			local wcag do local f,g,h,a,b,c,d,e=Color3.new(),Color3.new(1,1,1),0.1791,nil do function d(a)return(a<=0.03928)and(a/12.92)or((a + 0.055)/1.055)^2.4 end function e(a)return Color3.new(d(a.r),d(a.g),d(a.b))end function a(a,b)b=e(a)return(0.2126*b.r+0.7152*b.g+0.0722*b.b)end function b(b,c,d,e)d,e=a(b),a(c)if d<e then d,e=e,d end return(d + 0.05)/(e+0.05)end function c(c)return(a(c)>h)and(f)or(g)end end wcag={luminance=a,contrast=b,text=c}end

			spawn(function()
			    while true do
			        for i = 0, 1, 1 / 300 do
			            GlobalRainbowColor = Color3.fromHSV(i, 1, 1);
						GlobalRainbowHColor = i
			            wait()
			        end
			    end
			end)

			function Hex2RGB(Hex)
			    Hex = tonumber(Hex, 16)
			    R = (Hex % 16777216 - Hex % 65536) / 65536
			    G = (Hex % 65536 - Hex % 256) / 256
			    B = Hex % 256
			    return R, G, B
			end

			function RGB2Hex(Red, Green, Blue)
			    return string.upper((string.format("%06x", (Red % 256) * 65536 + (Green % 256) * 256 + Blue % 256)))
			end

			function MoveSatVal(Saturation, Value, rgbGiven, r,g,b)
				if rgbGiven then
					Hue, Saturation, Value = Color3.toHSV(Color3.fromRGB(r, g, b))
					SVDot.Position = UDim2.new(Saturation, -5, 1 - Value, -5)
					HexChanged = true
				else
					SVDot.Position = UDim2.new(Saturation, -5, 1 - Value, -5)
					HexChanged = true
				end
			end

			RainbowButton.MouseButton1Down:connect(function()
				if RainbowToggled then 
					RainbowToggled = false
					RainbowButtonbackground.ImageColor3 = Color3.fromRGB(255, 48, 51)
				else
					RainbowToggled = true
					RainbowButtonbackground.ImageColor3 = Color3.fromRGB(0, 225, 100)
				end
			end)

			RedBox:GetPropertyChangedSignal("Text"):connect(function()
				if RedBox:IsFocused() then
					local isnum = tonumber(RedBox.Text)
			    	if isnum then
			    	    if isnum < 0 or isnum > 255 then
			    	        RedBox.Text = (((isnum < 0) and '0') or ((isnum > 255) and '255'))
			    	    else
			    	        Red_Last = tostring(isnum)
							ColorPickerBackground.ImageColor3 = Color3.fromRGB( isnum, tonumber(GreenBox.Text), tonumber(BlueBox.Text) )
							location[flagName].Colour = Color3.fromRGB( isnum, tonumber(GreenBox.Text), tonumber(BlueBox.Text) )
							if callback then callback(not location[flagName]) end
							ColorPickerName.TextColor3 = wcag.text(ColorPickerBackground.ImageColor3)
			    	    end
			    	else
			    	    RedBox.Text = Red_Last
			    	end
					if RedBox.Text == nil or RedBox.Text == "" then R = 0 else R = tonumber(RedBox.Text) end
					if GreenBox.Text == nil or GreenBox.Text == "" then G = 0 else G = tonumber(GreenBox.Text) end
					if BlueBox.Text == nil or BlueBox.Text == "" then B = 0 else B = tonumber(BlueBox.Text) end
					HexBox.Text = string.upper((string.format("%06x", (R % 256) * 65536 + (G % 256) * 256 + B % 256)))
					Hue, Saturation, Value = Color3.toHSV(Color3.fromRGB(R, G, B))
					PickerItslef.ImageColor3 = Color3.fromHSV(Hue, 1, 1)
					HueMove(Hue)
					MoveSatVal(nil, nil, true, R, G, B)
				end
			end)


			GreenBox:GetPropertyChangedSignal("Text"):connect(function()
				if GreenBox:IsFocused() then
					local isnum = tonumber(GreenBox.Text)
			    	if isnum then
			    	    if isnum < 0 or isnum > 255 then
			    	        GreenBox.Text = (((isnum < 0) and '0') or ((isnum > 255) and '255'))
			    	    else
			    	        Green_Last = tostring(isnum)
							ColorPickerBackground.ImageColor3 = Color3.fromRGB( tonumber(RedBox.Text), isnum, tonumber(BlueBox.Text) )
							location[flagName].Colour = Color3.fromRGB( tonumber(RedBox.Text), isnum, tonumber(BlueBox.Text) )
							if callback then callback(not location[flagName]) end
							ColorPickerName.TextColor3 = wcag.text(ColorPickerBackground.ImageColor3)
			    	    end
			    	else
			    	    GreenBox.Text = Green_Last
			    	end
					if RedBox.Text == nil or RedBox.Text == "" then R = 0 else R = tonumber(RedBox.Text) end
					if GreenBox.Text == nil or GreenBox.Text == "" then G = 0 else G = tonumber(GreenBox.Text) end
					if BlueBox.Text == nil or BlueBox.Text == "" then B = 0 else B = tonumber(BlueBox.Text) end
					HexBox.Text = string.upper((string.format("%06x", (R % 256) * 65536 + (G % 256) * 256 + B % 256)))
					Hue, Saturation, Value = Color3.toHSV(Color3.fromRGB(R, G, B))
					PickerItslef.ImageColor3 = Color3.fromHSV(Hue, 1, 1)
					HueMove(Hue)
					MoveSatVal(nil, nil, true, R, G, B)
				end
			end)

			BlueBox:GetPropertyChangedSignal("Text"):connect(function()
				if BlueBox:IsFocused() then
			    	local isnum = tonumber(BlueBox.Text)
			    	if isnum then
			    	    if isnum < 0 or isnum > 255 then
			    	        BlueBox.Text = (((isnum < 0) and '0') or ((isnum > 255) and '255'))
			    	    else
			    	        Blue_Last = tostring(isnum)
							ColorPickerBackground.ImageColor3 = Color3.fromRGB( tonumber(RedBox.Text), tonumber(GreenBox.Text), isnum )
							location[flagName].Colour = Color3.fromRGB( tonumber(RedBox.Text), tonumber(GreenBox.Text), isnum )
							ColorPickerName.TextColor3 = wcag.text(ColorPickerBackground.ImageColor3)
			    	    end
			    	else
			    	    BlueBox.Text = Blue_Last
			    	end
					if RedBox.Text == nil or RedBox.Text == "" then R = 0 else R = tonumber(RedBox.Text) end
					if GreenBox.Text == nil or GreenBox.Text == "" then G = 0 else G = tonumber(GreenBox.Text) end
					if BlueBox.Text == nil or BlueBox.Text == "" then B = 0 else B = tonumber(BlueBox.Text) end
					HexBox.Text = string.upper((string.format("%06x", (R % 256) * 65536 + (G % 256) * 256 + B % 256)))
					Hue, Saturation, Value = Color3.toHSV(Color3.fromRGB(R, G, B))
					PickerItslef.ImageColor3 = Color3.fromHSV(Hue, 1, 1)
					HueMove(Hue)
					MoveSatVal(nil, nil, true, R, G, B)
				end
			end)

			HexBox:GetPropertyChangedSignal("Text"):connect(function()
				if HexBox:IsFocused() then
					local HexValue = HexBox.Text:gsub("0x", ""):gsub("#", ""):upper()
					if #HexValue >= 6 then
						RedBox.Text, GreenBox.Text, BlueBox.Text =	Hex2RGB(HexValue)

						Hue, Saturation, Value = Color3.toHSV(Color3.fromRGB(R, G, B))
						Color = Color3.fromHSV(Hue, Saturation, Value)
						ColorPickerBackground.ImageColor3 = Color
						location[flagName].Colour = Color
						PickerItslef.ImageColor3 = Color3.fromHSV(Hue, 1, 1)
						ColorPickerName.TextColor3 = wcag.text(ColorPickerBackground.ImageColor3)
						HueMove(1 - Hue)
						MoveSatVal(Saturation, Value)
					
						HexBox:ReleaseFocus()
						HexBox.Text = "#" .. string.upper(HexValue)
					end
			    end
			end)

			OpacityBox:GetPropertyChangedSignal("Text"):connect(function()
				if OpacityBox:IsFocused() then
					local isnum = tonumber(OpacityBox.Text)
			    	if isnum then
			    	    if isnum < 0 or isnum > 1 then
			    	        OpacityBox.Text = (((isnum < 0) and '0') or ((isnum > 1) and '1'))
			    	    else
			    	        Hex_Last = tostring(isnum)
							ColorPickerBackground.ImageTransparency = isnum
							location[flagName].Opacity = isnum
							ColorPickerName.TextColor3 = wcag.text(ColorPickerBackground.ImageColor3)
							OpacityMove(isnum)
			    	    end
			    	else
			    	    OpacityBox.Text = Hex_Last
			    	end
				end
			end)

			game:GetService("UserInputService").InputEnded:connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					SVHeld = false
				end
			end)
			PickerItslef.MouseButton1Down:connect(function()
				SVHeld = true
			end)

			game:GetService("UserInputService").InputEnded:connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					HueHeld = false
				end
			end)
			HueSlider.MouseButton1Down:connect(function()
				HueHeld = true
			end)

			-- Opacity

			function OpacityMove(Opacity)
				OpacitySliderBtn.Position = UDim2.new(Opacity, -5, 0, 5)
			end

			game:GetService("UserInputService").InputEnded:connect(function(input, processed)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					OpacityHeld = false
				end
			end)
			OpacitySlider.MouseButton1Down:connect(function()
				OpacityHeld = true
			end)

			local Hue, Opacity, Saturation, Value, Red, Green, Blue, Hex
			Heartbeat:connect(function()
				RainbowButton.TextColor3 = GlobalRainbowColor
				local Mouse = game:GetService("UserInputService"):GetMouseLocation()
				if HueHeld then
			        local HuePercent = (Mouse.X - HueSlider.AbsolutePosition.X) / (HueSlider.AbsoluteSize.X)
				 	HuePercent = math.clamp(HuePercent, 0, 1)
					Hue = 1 - HuePercent
					HueMove(HuePercent)
				end
			
				if OpacityHeld then
					local OpacityPercent = (Mouse.X - OpacitySlider.AbsolutePosition.X) / (OpacitySlider.AbsoluteSize.X)
					OpacityPercent = math.clamp(OpacityPercent, 0, 1)
					Opacity = 1 - OpacityPercent
					location[flagName].Opacity = Opacity
					OpacityMove(OpacityPercent)
				end
			
			 	if SVHeld then
					local XPos = math.clamp((Mouse.X - PickerItslef.AbsolutePosition.X) / PickerItslef.AbsoluteSize.X, 0, 1)
			       	local YPos = math.clamp((Mouse.Y - 36 - PickerItslef.AbsolutePosition.Y) / PickerItslef.AbsoluteSize.Y, 0, 1)
					Saturation = math.clamp(XPos, 0, 1)
					Value = math.clamp((1 - YPos), 0, 1)
					MoveSatVal(XPos, 1 - YPos)
				end
			
				if RainbowToggled then
					PickerItslef.ImageColor3 = GlobalRainbowColor
					ColorPickerBackground.ImageTransparency = Opacity
					location[flagName].Opacity = Opacity
					ColorPickerBackground.ImageColor3 = GlobalRainbowColor
					location[flagName].Colour = GlobalRainbowColor
				elseif HueHeld or OpacityHeld or SVHeld then
					PickerItslef.ImageColor3 =  Color3.fromHSV(Hue, 1, 1)
					ColorPickerBackground.ImageTransparency = Opacity
					location[flagName].Opacity = Opacity
					ColorPickerBackground.ImageColor3 = Color3.fromHSV(Hue, Saturation, Value)
					location[flagName].Colour = Color3.fromHSV(Hue, Saturation, Value)
				end

				if RainbowToggled or HueHeld or OpacityHeld or SVHeld or HexChanged then
					Red = 255 * ColorPickerBackground.ImageColor3.R
					Green = 255 * ColorPickerBackground.ImageColor3.G
					Blue = 255 * ColorPickerBackground.ImageColor3.B
					Hex = string.upper((string.format("%06x", (Red % 256) * 65536 + (Green % 256) * 256 + Blue % 256)))
					ColorPickerName.TextColor3 = wcag.text(ColorPickerBackground.ImageColor3)
					if RainbowToggled or HueHeld or OpacityHeld or SVHeld or not HexChanged then
						RedBox.Text = math.floor(Red)
						GreenBox.Text = math.floor(Green)
						BlueBox.Text = math.floor(Blue)
						HexBox.Text = Hex
					end
				end

				if OpacityHeld then
					OpacityBox.Text = 1 - math.floor(Opacity* 100)/100
				end
			end)
		end
		return Section
	end
	return Sections	
end

local function isreallypressed(bind, inp)
	local key = bind
	if typeof(key) == "Instance" then
		if key.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == key.KeyCode then
			return true;
		elseif tostring(key.UserInputType):find('MouseButton') and inp.UserInputType == key.UserInputType then
			return true
		end
	end
	if tostring(key):find'MouseButton1' then
		return key == inp.UserInputType
	else
		return key == inp.KeyCode
	end
end

game:GetService("UserInputService").InputBegan:connect(function(input)
	if not library.binding then
		for idx, binds in next, library.binds do
			local real_binding = binds.location[idx];
			if real_binding and isreallypressed(real_binding, input) then
				binds.callback()
			end
		end
	end
end) 
--[[
local Window = library:CreateWindow("I am a epic window")
local Section = Window:Section("Am section")

local Tableeeeeeee = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'Wally', 'Wally Is Cool', 'bit', 'byte', 'megabyte', 'byte-chan:tm: is smart'}

Section:Button("Button", function()
    print('ToggleFlag -', library.flags.EpicFlag)
	print('BoxFlag -', library.flags.BoxFlag)
	print('KeYbInD -', library.flags.KeYbInD)
	print('sliderino -', library.flags.Slideeeeee) 
	print('Dropperino -', library.flags.Dropperino)
	print('ColorPicker -', 'Color3.new(', library.flags.AMCOLOUR.Colour, ') Opacity =', library.flags.AMCOLOUR.Opacity )
	print()
	for i,v in pairs(library.flags.Dropperino) do
		warn(i,v)
	end
	print()
end)
Section:Toggle("Am toggle", {flag = 'EpicFlag', Default = true})
Section:Box('Am box', {flag = 'BoxFlag'})
Section:Label('A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z.')
Section:Bind('am KEYbind', {flag = 'KeYbInD'}, function() print("AAAAAA") end)
Section:Slider('am sliderino', {flag = "Slideeeeee"; Min = -100; Max = 100; Default = 0 ; Precise = false })
Section:Dropdown('ima drop', {flag = 'Dropperino', list = Tableeeeeeee, Type = 'Toggle'})
Section:ColorPicker('colour not color >:D', {flag = 'AMCOLOUR'})
]]
return library
