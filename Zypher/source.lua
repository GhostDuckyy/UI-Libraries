--[[

    _____                  _                   
   |__  /  _   _   _ __   | |__     ___   _ __ 
     / /  | | | | | '_ \  | '_ \   / _ \ | '__|
    / /_  | |_| | | |_) | | | | | |  __/ | |   
   /____|  \__, | | .__/  |_| |_|  \___| |_|   
           |___/  |_|                          

   Made by: xTheAlex14#3200
   Design: inspiration from Luzu#0001
   
]]

local Library = {}
local Objects = {Background = {}, GrayContrast = {}, DarkContrast = {}, TextColor = {}, SectionContrast = {}, DropDownListContrast = {}, CharcoalContrast = {}}

local Themes = {
	Background = Color3.fromRGB(46, 46, 54),
	GrayContrast = Color3.fromRGB(39, 38, 46),
	DarkContrast = Color3.fromRGB(29, 29, 35),
	TextColor = Color3.fromRGB(255,255,255),
	SectionContrast = Color3.fromRGB(39,38,46),
	DropDownListContrast = Color3.fromRGB(34, 34, 41),
	CharcoalContrast = Color3.fromRGB(21,21,26),
}

function Library:Create(what, propri)
	local instance = Instance.new(what)

	for i, v in next, propri do
		if instance[i] and propri ~= "Parent" then
			instance[i] = v
		end
	end

	return instance
end

local mouse = game.Players.LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")

function Library:CreateMain(Options)

	local nameforcheck = Options.projName
	local Main = {}
	local firstCategory = true

	Main.Screengui = Library:Create("ScreenGui", {
		Name = Options.projName,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
	})

	Main.Motherframe = Library:Create("Frame", {
		Name = "Motherframe",
		BackgroundColor3 = Themes.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, -400, 0.5, -225),
		Size = UDim2.new(0, 700, 0, 460),
	})

	table.insert(Objects.Background, Main.Motherframe)

	-- Drag is not made by me

	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		Main.Motherframe:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), 'Out', 'Linear', 0.01, true)
	end

	Main.Motherframe.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = Main.Motherframe.Position
			repeat
				wait()
			until input.UserInputState == Enum.UserInputState.End
			dragging = false
		end
	end)

	Main.Motherframe.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	Main.Upline = Library:Create("Frame", {
		Name = "Upline",
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0.00899999961, 0),
		ZIndex = 10,
	})

	Main.Uplinegradient = Library:Create("UIGradient", {
		Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 183, 183)),
			ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 248, 248)),
			ColorSequenceKeypoint.new(1.00, Color3.fromRGB(125, 92, 164))
		}
	})

	Main.Sidebar = Library:Create("ScrollingFrame", {
		Name = "Sidebar",
		Active = true,
		BackgroundColor3 = Themes.GrayContrast,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0.00899999309, 0),
		Size = UDim2.new(0.214041099, 0, 0.991376221, 0),
		CanvasSize = UDim2.new(0, 0, 0, 15),
		ScrollBarThickness = 0,
	})

	table.insert(Objects.GrayContrast, Main.Sidebar)

	local Siderbarpadding = Library:Create("UIPadding", {
		PaddingLeft = UDim.new(0.047, 0),
		PaddingTop = UDim.new(0, 15)
	})

	Siderbarpadding.Parent = Main.Sidebar
	Siderbarpadding = nil

	Main.Categorieshandler = Library:Create("Frame", {
		Name = "Categories",
		BackgroundColor3 = Themes.GrayContrast,
		BorderSizePixel = 0,
		Position = UDim2.new(0.214041084, 0, 0.00869414024, 0),
		Size = UDim2.new(0.784817278, 0, 0.991132021, 0),
	})

	table.insert(Objects.GrayContrast, Main.Categorieshandler)

	Main.Categoriesselector = Library:Create("ImageLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(0.95, 0, 0, 30),
		Image = "rbxassetid://3570695787",
		ImageColor3 = Themes.Background,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(100, 100, 100, 100),
		SliceScale = 0.04,
	})

	table.insert(Objects.Background, Main.Categoriesselector)

	local textsize = 18

	if Options.Resizable then 

		local scaling = 18 / 460

		Main.ResizeBtn = Library:Create("TextButton", {
			Name = "ResizeButton",
			BackgroundColor3 = Themes.Background,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -20, 1, -20),
			Size = UDim2.new(0, 20, 0, 20),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 14.000,
		})

		table.insert(Objects.Background, Main.ResizeBtn)

		Main.ResizeBtn.Parent = Main.Motherframe

		local min = Options.MinSize
		local max = Options.MaxSize
		local connection
		local sP
		local MSS
		local size

		local function hasi(v, p)
			local x = v[p]
		end
		local function has(v, p)
			return pcall(function()
				hasi(v, p)
			end)
		end

		Main.ResizeBtn.MouseButton1Down:Connect(function()
			mouse.Icon = "http://www.roblox.com/asset/?id=1283244442"
			sP = Vector2.new(mouse.X, mouse.Y)
			MSS = Main.Motherframe.Size
			connection = RS.Heartbeat:Connect(function()
				if sP then
					local oldtextsize = textsize
					local distance = Vector2.new(mouse.X, mouse.Y) - sP;
					size = (MSS + UDim2.new(0, distance.X, 0, distance.Y))
					if (MSS + UDim2.new(0, distance.X, 0, distance.Y)).X.Offset <= min.X.Offset then
						size = UDim2.new(0, min.X.Offset, 0, size.Y.Offset)
					elseif (MSS + UDim2.new(0, distance.X, 0, distance.Y)).X.Offset >= max.X.Offset then
						size = UDim2.new(0, max.X.Offset, 0, size.Y.Offset)
					end

					if (MSS + UDim2.new(0, distance.X, 0, distance.Y)).Y.Offset <= min.Y.Offset then
						size = UDim2.new(0, size.X.Offset, 0, min.Y.Offset)
					elseif (MSS + UDim2.new(0, distance.X, 0, distance.Y)).Y.Offset >= max.Y.Offset then
						size = UDim2.new(0, size.X.Offset, 0, max.Y.Offset)
					end
					Main.Motherframe.Size = size
					textsize = math.floor(size.Y.Offset * scaling)
					if oldtextsize ~= textsize then
						for i, v in pairs (Main.Motherframe:GetDescendants()) do
							if v.Name ~= "Colorpicker" and has(v, "TextSize") then
								v.TextSize = textsize
							end
						end
					end
				end
			end)
			UIS.InputEnded:Connect(function(Check)
				if Check.UserInputType == Enum.UserInputType.MouseButton1 then
					if connection then
						connection:Disconnect()
						connection = nil
					end
					if mouse.Icon == "http://www.roblox.com/asset/?id=1283244442" then 
						mouse.Icon = ""
					end
				end
			end)
		end)
	end

	local CategoryDistanceCounter = 0

	function Main:CreateCategory(Name)

		local Category = {}

		Category.CButton = Library:Create("TextButton", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			BorderSizePixel = 0,
			Position = UDim2.new(0.027, 0, 0, CategoryDistanceCounter),
			Size = UDim2.new(0.95, 0, 0, 30),
			ZIndex = 2,
			Font = Enum.Font.GothamBold,
			Text = Name,
			Name = Name,
			TextColor3 = Themes.TextColor,
			TextSize = 18,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		})

		table.insert(Objects.TextColor, Category.CButton)

		Category.Container = Library:Create("ScrollingFrame", {
			Name = Name.."Category",
			BackgroundColor3 = Themes.Background,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 15),
			Visible = false,
			ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
			ScrollBarThickness = 4,
		})

		table.insert(Objects.CharcoalContrast, Category.Container)
		table.insert(Objects.Background, Category.Container)

		Category.CPadding = Library:Create("UIPadding", {
			PaddingLeft = UDim.new(0.026, 0),
			PaddingTop = UDim.new(0, 15),
		})

		Category.CLayout = Library:Create("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 15),
		})

		if firstCategory then 
			Category.Container.Visible = true
		end

		Category.CButton.MouseButton1Click:Connect(function()
			TS:Create(Main.Categoriesselector, TweenInfo.new(0.08), {
				Position = Category.CButton.Position - UDim2.new(0.027, 0, 0, 0)
			}):Play()

			for i, v in pairs(Main.Categorieshandler:GetChildren()) do 
				if v:IsA("ScrollingFrame") then 
					v.Visible = false
				end  
			end

			Category.Container.Visible = true
		end)

		function Category:CreateSection(Name)

			local Section = {}

			Section.Container = Library:Create("ImageLabel", {
				Name = Name.."Section",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderSizePixel = 0,
				Position = UDim2.new(0.0272727273, 0, 0, 0),
				Size = UDim2.new(0.973, 0, 0, 35),
				Image = "rbxassetid://3570695787",
				ImageColor3 = Themes.SectionContrast,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(100, 100, 100, 100),
				SliceScale = 0.04,
			})

			table.insert(Objects.SectionContrast, Section.Container)

			Section.SectionPadding = Library:Create("UIPadding", {
				PaddingLeft = UDim.new(0.02, 0),
				PaddingBottom = UDim.new(0, 10),
			})

			Section.SectionLayout = Library:Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			})

			Section.SectionName = Library:Create("TextLabel", {
				Name = "Name",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				BorderSizePixel = 0,
				Position = UDim2.new(-0.00999999978, 0, 0, -10),
				Size = UDim2.new(0.38499999, 0, 0, 25),
				Font = Enum.Font.GothamBold,
				Text = Name,
				TextColor3 = Themes.TextColor,
				TextSize = 18.000,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Bottom,
			})

			table.insert(Objects.TextColor, Section.SectionName)

			function Section:SetText(Text)
				Section.SectionName.Text = Text
			end

			Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 50)

			function Section:Create(Type, Name, CallBack, Options)

				local Interactables = {}

				if Type:lower() == "button" then 

					Interactables.ButtonFrame = Library:Create("Frame", {
						Name = Name.."Button",
						Active = true,
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Position = UDim2.new(0, -44, 0, -34),
						Selectable = true,
						Size = UDim2.new(0.982, 0, 0, 30),
					})

					Interactables.Button = Library:Create("ImageButton", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Position = UDim2.new(0.5, 0, 0.491, 0),
						Size = UDim2.new(1, 0, 0, 30),
						AutoButtonColor = false,
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast, Interactables.Button)

					Interactables.ButtonText = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.100000001, 0, 0, 0),
						Size = UDim2.new(0.8, 0, 0, 30),
						Font = Enum.Font.GothamBold,
						Text = Name,
						TextColor3 = Color3.fromRGB(255,255,255),
						TextSize = 18.000,
					})

					table.insert(Objects.TextColor, Interactables.ButtonText)

					function Interactables:SetButtonText(Text)
						Interactables.ButtonText.Text = Text
					end

					Interactables.Button.MouseButton1Click:Connect(function()

						if Options then
							if Options.animated then 
								TS:Create(Interactables.Button, TweenInfo.new(0.06), {
									Size = UDim2.new(0.96, 0, 0, 25)
								}):Play()
								wait(.07)
								TS:Create(Interactables.Button, TweenInfo.new(0.06), {
									Size = UDim2.new(1, 0, 0, 30)
								}):Play()			
							end
						end

						if CallBack then 
							CallBack()
						end

					end)

					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 40)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 40)

					Interactables.ButtonFrame.Parent = Section.Container

					Interactables.Button.Parent = Interactables.ButtonFrame

					Interactables.ButtonText.Parent = Interactables.Button

				elseif Type:lower() == "slider" then 

					local Min = Options.min or 1
					local Max = Options.max or 0
					local MoveConnection
					local Value = 0

					Interactables.Slider = Library:Create("ImageLabel", {
						Name = Name.."Slider",
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Position = UDim2.new(0, 10, 0, 85),
						Selectable = true,
						Size = UDim2.new(0.982, 0, 0, 50),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast ,Interactables.Slider)

					Interactables.SliderName = Library:Create("TextLabel", {					
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 4, 0, 2),
						Size = UDim2.new(0, 200, 0, 30),
						Font = Enum.Font.GothamBold,
						Text = Name,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					table.insert(Objects.TextColor, Interactables.SliderName)

					Interactables.SliderValue = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.888, 0, 0, 6),
						Size = UDim2.new(0.088, 0, 0, 22),
						Font = Enum.Font.GothamBold,
						Text = Min,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Right,
					})

					table.insert(Objects.TextColor, Interactables.SliderValue)

					Interactables.SliderBackInner = Library:Create("ImageButton", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Position = UDim2.new(0.0120000001, 0, 0, 32),
						Size = UDim2.new(0.974008501, 0, 0, 10),
						AutoButtonColor = false,
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.CharcoalContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.03,
						ZIndex = 1,
					})

					table.insert(Objects.CharcoalContrast, Interactables.SliderBackInner)

					Interactables.SliderInner = Library:Create("ImageLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 1),
						Size = UDim2.new(0, 0, 0, 8),
						ZIndex = 1,
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.TextColor,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.03,				
					})

					table.insert(Objects.TextColor, Interactables.SliderInner)

					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 60)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 60)

					Interactables.Slider.Parent = Section.Container

					Interactables.SliderName.Parent = Interactables.Slider

					Interactables.SliderValue.Parent = Interactables.Slider

					Interactables.SliderBackInner.Parent = Interactables.Slider

					Interactables.SliderInner.Parent = Interactables.SliderBackInner

					if Options.default then 
						Interactables.SliderValue.Text = tostring(Options.default)
						if CallBack then
							CallBack(Options.default)
						end
						local s = (Options.default - Min) / (Max - Min)
						TS:Create(Interactables.SliderInner, TweenInfo.new(0.05), {
							Size = UDim2.new(s, 0, 0, 8)
						}):Play()
					end

					Interactables.SliderBackInner.MouseButton1Down:Connect(function()

						MoveConnection = RS.Heartbeat:Connect(function()
							local s = math.clamp(mouse.X - Interactables.SliderBackInner.AbsolutePosition.X, 0, Interactables.SliderBackInner.AbsoluteSize.X) / Interactables.SliderBackInner.AbsoluteSize.X
							if Options.precise then
								Value = string.format("%.1f", Min + ((Max - Min) * s))
							else
								Value = math.floor(Min + ((Max - Min) * s))
							end
							Interactables.SliderValue.Text = tostring(Value)

							if CallBack then
								CallBack(Value)
							end

							TS:Create(Interactables.SliderInner, TweenInfo.new(0.05), {
								Size = UDim2.new(s, 0, 0, 8)
							}):Play()
						end)

						UIS.InputEnded:Connect(function(Check)
							if Check.UserInputType == Enum.UserInputType.MouseButton1 then
								if MoveConnection then
									MoveConnection:Disconnect()
									MoveConnection = nil
								end
							end
						end)

					end)

				elseif Type:lower() == "toggle" then 

					local State = false

					Interactables.Toggle = Library:Create("ImageButton", {
						Name = Name.."Toggle",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.00576804997, 0, 0.055555556, 0),
						Size = UDim2.new(0.981999993, 0, 0, 35),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast ,Interactables.Toggle)

					Interactables.ToggleText = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.new(0.00800000038, 0, 0.057, 0),
						Size = UDim2.new(0.399576753, 0, 0.857142866, 0),
						Font = Enum.Font.GothamBold,
						Text = Name,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					table.insert(Objects.TextColor, Interactables.ToggleText)

					Interactables.ToggleBack = Library:Create("ImageLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.new(1, -62, 0.114, 0),
						Size = UDim2.new(0, 56, 0, 26),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.CharcoalContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.CharcoalContrast, Interactables.ToggleBack)

					Interactables.ToggleShow = Library:Create("ImageLabel", {						
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1,
						Position = UDim2.new(0.0359999985, 0, 0.115000002, 0),
						Size = UDim2.new(0, 26, 0, 20),
						Image = "rbxassetid://3570695787",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.TextColor, Interactables.ToggleShow)

					if Options then 
						if Options.default then 
							State = true 
							TS:Create(Interactables.ToggleShow, TweenInfo.new(0.1), {
								Position = UDim2.new(0.53, 0, 0.115, 0)
							}):Play()
							if CallBack then 
								CallBack(State)
							end
						end
					end

					Interactables.Toggle.MouseButton1Click:Connect(function()
						State = not State 

						if State then 
							TS:Create(Interactables.ToggleShow, TweenInfo.new(0.1), {
								Position = UDim2.new(0.53, 0, 0.115, 0)
							}):Play()
						else
							TS:Create(Interactables.ToggleShow, TweenInfo.new(0.1), {
								Position = UDim2.new(0.036, 0, 0.115, 0)
							}):Play()
						end

						if CallBack then 
							CallBack(State)
						end

					end)

					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 45)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 45)

					Interactables.Toggle.Parent = Section.Container

					Interactables.ToggleText.Parent = Interactables.Toggle

					Interactables.ToggleBack.Parent = Interactables.Toggle

					Interactables.ToggleShow.Parent = Interactables.ToggleBack

				elseif Type:lower() == "textbox" then

					local Text
					local PlaceHolderText
					if Options then 
						if Options.text then 
							PlaceHolderText = Options.text
						end
					end

					Interactables.TextBox = Library:Create("ImageLabel", {
						Name = Name.."Textbox",
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0192307699, 0, 0.467741936, 0),
						Size = UDim2.new(0.981999993, 0, 0, 35),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast , Interactables.TextBox)

					Interactables.TextBoxName = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0, 4, 0, 2),
						Size = UDim2.new(0.400000006, 0, 0, 30),
						Font = Enum.Font.GothamBold,
						Text = Name,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					table.insert(Objects.TextColor, Interactables.TextBoxName)

					Interactables.TextBoxBack = Library:Create("ImageLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.587970376, 0, 0.114, 0),
						Selectable = true,
						Size = UDim2.new(0.400000006, 0, 0, 26),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.CharcoalContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.030,
					})

					table.insert(Objects.CharcoalContrast, Interactables.TextBoxBack)

					Interactables.ActualTextBox = Library:Create("TextBox", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.0500000007, 0, 0.0384615399, 0),
						Size = UDim2.new(0.920000017, 0, 0, 23),
						Font = Enum.Font.GothamBold,
						PlaceholderText = PlaceHolderText or "Text",
						Text = "",
						TextColor3 = Themes.TextColor,
						TextSize = 14.000,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Right,
					})

					table.insert(Objects.TextColor, Interactables.ActualTextBox)

					Interactables.ActualTextBox.FocusLost:Connect(function()
						Text = Interactables.ActualTextBox.Text

						if CallBack then
							CallBack(Text)
						end
					end)

					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 45)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 45)

					Interactables.TextBox.Parent = Section.Container

					Interactables.TextBoxName.Parent = Interactables.TextBox

					Interactables.TextBoxBack.Parent = Interactables.TextBox

					Interactables.ActualTextBox.Parent = Interactables.TextBoxBack

				elseif Type:lower() == "textlabel" then 

					Interactables.TextLabelBox = Library:Create("ImageLabel", {
						Name = Name.."TextLabel",
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.0192307699, 0, 0.467741936, 0),
						Size = UDim2.new(0.982, 0, 0, 35),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast , Interactables.TextLabelBox)

					Interactables.Textlabel = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0.008, 0, 0, 2),
						Size = UDim2.new(.991, 0, 0, 30),
						Font = Enum.Font.GothamBold,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					table.insert(Objects.TextColor, Interactables.Textlabel)

					if #Name <= 100 then
						Interactables.Textlabel.Text = Name
					end

					function Interactables:SetText(Text)
						if #Text <= 100 then 
							Interactables.Textlabel.Text = Text
						end
					end

					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 45)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 45)

					Interactables.TextLabelBox.Parent = Section.Container

					Interactables.Textlabel.Parent = Interactables.TextLabelBox

				elseif Type:lower() == "keybind" then 

					Interactables.KeyBindBox = Library:Create("ImageLabel", {
						Name = Name.."KeyBind",
						Active = true,
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Position = UDim2.new(0, 10, 0, 235),
						Selectable = true,
						Size = UDim2.new(0.981999993, 0, 0, 35),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast , Interactables.KeyBindBox)

					Interactables.KeyBindName = Library:Create("TextLabel", {						
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.00800000038, 0, 0, 2),
						Size = UDim2.new(0.400000006, 0, 0, 30),
						Font = Enum.Font.GothamBold,
						Text = Name,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					table.insert(Objects.TextColor , Interactables.KeyBindName)

					Interactables.KeyBindButton = Library:Create("ImageButton", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(1, -126, 0, 4),
						Size = UDim2.new(0, 120, 0, 26),
						AutoButtonColor = false,
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.CharcoalContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.CharcoalContrast, Interactables.KeyBindButton)

					Interactables.KeyBindKey = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.64, -30, 0, 0),
						Size = UDim2.new(0, 30, 1, 0),
						Font = Enum.Font.GothamBold,
						Text = "None",
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
					})

					table.insert(Objects.TextColor, Interactables.KeyBindKey)

					local connection
					local changing
					local bind
					local inputconnection
					local checkconnection

					if Options then
						if Options.default then 
							bind = Options.default
							Interactables.KeyBindKey.Text = bind.Name
						end
					end

					Interactables.KeyBindButton.MouseButton1Click:Connect(function()
						changing = true
						Interactables.KeyBindKey.Text = "..."
						connection = game:GetService("UserInputService").InputBegan:Connect(function(i)
							if i.UserInputType.Name == "Keyboard" and i.KeyCode ~= Enum.KeyCode.Backspace then
								Interactables.KeyBindKey.Text = i.KeyCode.Name
								bind = i.KeyCode
								if connection then
									connection:Disconnect()
									connection = nil
									wait(.1)
									changing = false
								end
							elseif i.KeyCode == Enum.KeyCode.Backspace then
								Interactables.KeyBindKey.Text = "None"
								bind = nil
								if connection then
									connection:Disconnect()
									connection = nil 
									wait(.1)
									changing = false
								end
							end
						end)
					end)

					inputconnection = game:GetService("UserInputService").InputBegan:Connect(function(i, GPE)
						if bind and i.KeyCode == bind and not GPE and not connection then
							if CallBack and not changing then
								CallBack(i.KeyCode)
							end
						end
					end)

					checkconnection = game:GetService("CoreGui").ChildRemoved:Connect(function(child)
						if child.Name == nameforcheck then 
							if inputconnection then
								inputconnection:Disconnect()
								inputconnection = nil
							end
							if checkconnection then 
								checkconnection:Disconnect()
								checkconnection = nil
							end 
						end 
					end)

					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 45)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 45)

					Interactables.KeyBindBox.Parent = Section.Container

					Interactables.KeyBindName.Parent = Interactables.KeyBindBox

					Interactables.KeyBindButton.Parent = Interactables.KeyBindBox

					Interactables.KeyBindKey.Parent = Interactables.KeyBindButton

				elseif Type:lower() == "dropdown" then 
					if Options and not Options.search then

						local selectedvalue

						if Options then
							if Options.default and Options.options and not Options.playerlist then
								selectedvalue = Options.default
							elseif Options.default and Options.options and Options.playerlist then
								selectedvalue = Options.default
							elseif not Options.default and Options.options and Options.playerlist then
								selectedvalue = Options.options[1]
							elseif not Options.default and Options.options and not Options.playerlist then
								selectedvalue = Options.options[1]
							elseif not Options.default and not Options.options and Options.playerlist then
								selectedvalue = game:GetService("Players"):GetChildren()[1].Name  
							elseif Options.default and not Options.options and not Options.playerlist then
								selectedvalue = Options.default      
							elseif Options.default and not Options.options and Options.playerlist then
								selectedvalue = Options.default               
							end
						end

						local tablelist

						if Options then
							if Options.options and not Options.playerlist then
								tablelist = Options.options
							elseif Options.options and Options.playerlist then
								tablelist = {}

								for g, f in pairs(Options.options) do
									table.insert(tablelist, f)
								end
								local list = game:GetService("Players"):GetChildren()
								if not Options.plotlist then
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)
										end
									end
								else
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)

											table.insert(tablelist, v.Name.."'s Plot")
										end
									end
								end
							elseif not Options.options and Options.playerlist then
								tablelist = {}
								local list = game:GetService("Players"):GetChildren()
								if not Options.plotlist then 
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)
										end
									end     
								else       
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)

											table.insert(tablelist, v.Name.."'s Plot")
										end
									end										
								end                        
							end
						end

						Interactables.dropdownb = Library:Create("ImageLabel", {
							Name = Name.."DropDown",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.new(0, 11, 0, 40),
							Size = UDim2.new(0.982, 0, 0, 30),
							ImageTransparency = 1,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Themes.DarkContrast,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						table.insert(Objects.DarkContrast , Interactables.dropdownb)

						Interactables.dropdownb.ClipsDescendants = true

						Interactables.dropdown = Library:Create("ImageButton", {
							Name = Name.."DropDown",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 0, 30),
							AutoButtonColor = false,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Themes.DarkContrast,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						table.insert(Objects.DarkContrast , Interactables.dropdown)

						Interactables.arrow = Library:Create("ImageLabel", {
							Name = "Arrow",
							Active = true,
							BackgroundColor3 = Color3.fromRGB(248, 248, 248),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							BorderSizePixel = 0,
							Position = UDim2.new(0.940401852, 0, 0.0333333351, 0),
							Rotation = 90.000,
							Selectable = true,
							Size = UDim2.new(0, 28, 0, 28),
							Image = "http://www.roblox.com/asset/?id=5054982349",
							ImageColor3 = Themes.TextColor,
						})

						table.insert(Objects.TextColor, Interactables.arrow)

						Interactables.selected = Library:Create("TextLabel", {
							Active = false,
							BackgroundColor3 = Color3.fromRGB(248, 248, 248),
							BackgroundTransparency = 1.000,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 4, 0, 0),
							Selectable = false,
							Size = UDim2.new(0.200000003, 200, 1, 0),
							Font = Enum.Font.GothamBold,
							Text = tostring(selectedvalue),
							TextColor3 = Themes.TextColor,
							TextSize = 18.000,
							TextXAlignment = Enum.TextXAlignment.Left,
						})

						table.insert(Objects.TextColor , Interactables.selected)

						Interactables.listb = Library:Create("ImageLabel", {
							Active = true,
							BackgroundColor3 = Color3.fromRGB(248, 248, 248),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.new(0, 0, 0, 40),
							Selectable = true,
							Size = UDim2.new(1, 0, 0, 120),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Themes.DropDownListContrast,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						table.insert(Objects.DropDownListContrast, Interactables.listb)

						Interactables.list = Library:Create("ScrollingFrame", {
							Active = true,
							BackgroundColor3 = Color3.fromRGB(29, 29, 35),
							BackgroundTransparency = 1.000,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							CanvasSize = UDim2.new(0, 0, 0, 0),
							ScrollBarThickness = 3,
							ScrollBarImageColor3 = Themes.CharcoalContrast,
						})

						table.insert(Objects.CharcoalContrast , Interactables.list)

						local tlistlayout = Library:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 10)
						})

						tlistlayout.Parent = Interactables.list
						tlistlayout = nil

						local tpadding = Library:Create("UIPadding", {
							PaddingBottom = UDim.new(0, 10),
							PaddingLeft = UDim.new(0, 10),
							PaddingTop = UDim.new(0, 10),
						})

						tpadding.Parent = Interactables.list
						tpadding = nil

						local dropdownopen = false

						Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 40)
						Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 40)

						Interactables.dropdownb.Parent = Section.Container
						Interactables.dropdown.Parent = Interactables.dropdownb
						Interactables.arrow.Parent = Interactables.dropdown
						Interactables.selected.Parent = Interactables.dropdown
						Interactables.listb.Parent = Interactables.dropdown
						Interactables.list.Parent = Interactables.listb

						local function refreshlist()

							for i, v in next, Interactables.list:GetChildren() do
								if v:IsA("ImageButton") then
									v:Destroy()
								end
							end

							for i, v in next, tablelist do
								local button = Library:Create("ImageButton", {
									Name = string.lower(v),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1.000,
									BorderColor3 = Color3.fromRGB(27, 42, 53),
									Position = UDim2.new(0, 252, 0, 0),
									Size = UDim2.new(0.98, 0, 0, 30),
									ZIndex = 2,
									AutoButtonColor = false,
									Image = "rbxassetid://3570695787",
									ImageColor3 = Themes.DarkContrast,
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(100, 100, 100, 100),
									SliceScale = 0.040,
								})

								table.insert(Objects.DarkContrast, button)

								local buttontext = Library:Create("TextLabel", {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1.000,
									BorderSizePixel = 0,
									Position = UDim2.new(0.078, 0, 0, 0),
									Size = UDim2.new(0.833, 0, 1, 0),
									ZIndex = 2,
									Font = Enum.Font.GothamBold,
									Text = v,
									TextColor3 = Themes.TextColor,
									TextSize = textsize,
								})

								table.insert(Objects.TextColor, buttontext)

								button.Parent = Interactables.list
								buttontext.Parent = button

								button.MouseButton1Click:Connect(function()
									if dropdownopen then

										dropdownopen = not dropdownopen
										Interactables.selected.Text = v
										selectedvalue = v

										if dropdownopen then
											refreshlist()
											TS:Create(Section.Container, TweenInfo.new(0.1), {
												Size = Section.Container.Size + UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
												Size = UDim2.new(0.982, 0, 0, 154)
											}):Play()
											TS:Create(Category.Container, TweenInfo.new(0.1), {
												CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.list, TweenInfo.new(0.1), {
												CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
											}):Play()
											TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
												Rotation = 0
											}):Play()
										else
											refreshlist()
											TS:Create(Section.Container, TweenInfo.new(0.1), {
												Size = Section.Container.Size - UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
												Size = UDim2.new(0.982, 0, 0, 30)
											}):Play()
											TS:Create(Category.Container, TweenInfo.new(0.1), {
												CanvasSize = Category.Container.CanvasSize - UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
												Rotation = 90
											}):Play()
										end

										if CallBack then
											CallBack(selectedvalue)
										end
									end
								end)
							end
						end

						refreshlist()

						function Interactables:SetDropDownList(table)
							tablelist = {}
							if table then 
								if table.options then 
									tablelist = table.options
									refreshlist()
								end
							end
						end

						function Interactables:GetDropDownList()
							return tablelist
						end

						refreshlist()
						

						Interactables.dropdown.MouseButton1Click:Connect(function()
							dropdownopen = not dropdownopen

							if Options.BeforeOpen then 
								Options.BeforeOpen()
							end

							if Options then
								if Options.options and Options.playerlist then
									tablelist = {}

									for g, f in pairs(Options.options) do
										table.insert(tablelist, f)
									end
									local list = game:GetService("Players"):GetChildren()
									if not Options.plotlist then
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)
											end
										end
									else
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)

												table.insert(tablelist, v.Name.."'s Plot")
											end
										end
									end
								elseif not Options.options and Options.playerlist then
									tablelist = {}
									local list = game:GetService("Players"):GetChildren()
									if not Options.plotlist then 
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)
											end
										end     
									else       
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)

												table.insert(tablelist, v.Name.."'s Plot")
											end
										end										
									end                        
								end
							end


							if dropdownopen then
								refreshlist()
								TS:Create(Section.Container, TweenInfo.new(0.1), {
									Size = Section.Container.Size + UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
									Size = UDim2.new(0.982, 0, 0, 154)
								}):Play()
								TS:Create(Category.Container, TweenInfo.new(0.1), {
									CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.list, TweenInfo.new(0.1), {
									CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
								}):Play()
								TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
									Rotation = 0
								}):Play()
							else
								refreshlist()
								TS:Create(Section.Container, TweenInfo.new(0.1), {
									Size = Section.Container.Size - UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
									Size = UDim2.new(0.982, 0, 0, 30)
								}):Play()
								TS:Create(Category.Container, TweenInfo.new(0.1), {
									CanvasSize = Category.Container.CanvasSize - UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
									Rotation = 90
								}):Play()
							end

						end)
					elseif Options and Options.search then

						local selectedvalue

						if Options then
							if Options.default and Options.options and not Options.playerlist then
								selectedvalue = Options.default
							elseif Options.default and Options.options and Options.playerlist then
								selectedvalue = Options.default
							elseif not Options.default and Options.options and Options.playerlist then
								selectedvalue = Options.options[1]
							elseif not Options.default and Options.options and not Options.playerlist then
								selectedvalue = Options.options[1]
							elseif not Options.default and not Options.options and Options.playerlist then
								selectedvalue = game:GetService("Players"):GetChildren()[1].Name  
							elseif Options.default and not Options.options and not Options.playerlist then
								selectedvalue = Options.default      
							elseif Options.default and not Options.options and Options.playerlist then
								selectedvalue = Options.default               
							end
						end

						local tablelist

						if Options then
							if Options.options and not Options.playerlist then
								tablelist = Options.options
							elseif Options.options and Options.playerlist then
								tablelist = {}

								for g, f in pairs(Options.options) do
									table.insert(tablelist, f)
								end
								local list = game:GetService("Players"):GetChildren()
								if not Options.plotlist then
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)
										end
									end
								else
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)

											table.insert(tablelist, v.Name.."'s Plot")
										end
									end
								end
							elseif not Options.options and Options.playerlist then
								tablelist = {}
								local list = game:GetService("Players"):GetChildren()
								if not Options.plotlist then 
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)
										end
									end     
								else       
									for i, v in pairs(list) do
										if v:IsA("Player") then
											table.insert(tablelist, v.Name)

											table.insert(tablelist, v.Name.."'s Plot")
										end
									end										
								end                        
							end
						end

						Interactables.dropdownb = Library:Create("ImageLabel", {
							Name = Name.."DropDown",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.new(0, 11, 0, 40),
							Size = UDim2.new(0.982, 0, 0, 30),
							ImageTransparency = 1,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Themes.DarkContrast,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						table.insert(Objects.DarkContrast , Interactables.dropdownb)

						Interactables.dropdownb.ClipsDescendants = true

						Interactables.dropdown = Library:Create("ImageButton", {
							Name = Name.."DropDown",
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.new(0, 0, 0, 0),
							Size = UDim2.new(1, 0, 0, 30),
							AutoButtonColor = false,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Themes.DarkContrast,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						table.insert(Objects.DarkContrast , Interactables.dropdown)

						Interactables.arrow = Library:Create("ImageLabel", {
							Name = "Arrow",
							Active = true,
							BackgroundColor3 = Color3.fromRGB(248, 248, 248),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							BorderSizePixel = 0,
							Position = UDim2.new(1, -32, 0.0333333351, 0),
							Rotation = 90.000,
							Selectable = true,
							Size = UDim2.new(0, 28, 0, 28),
							Image = "http://www.roblox.com/asset/?id=5054982349",
							ImageColor3 = Themes.TextColor,
						})

						table.insert(Objects.TextColor, Interactables.arrow)

						Interactables.selected = Library:Create("TextBox", {
							Active = false,
							BackgroundColor3 = Color3.fromRGB(248, 248, 248),
							BackgroundTransparency = 1.000,
							BorderSizePixel = 0,
							Position = UDim2.new(0.008, 0, 0, 0),
							Selectable = false,
							Size = UDim2.new(0.65, 0, 1, 0),
							Font = Enum.Font.GothamBold,
							Text = tostring(selectedvalue),
							TextColor3 = Themes.TextColor,
							TextSize = 18.000,
							TextXAlignment = Enum.TextXAlignment.Left,
						})

						table.insert(Objects.TextColor ,Interactables.selected)

						Interactables.listb = Library:Create("ImageLabel", {
							Active = true,
							BackgroundColor3 = Color3.fromRGB(248, 248, 248),
							BackgroundTransparency = 1.000,
							BorderColor3 = Color3.fromRGB(27, 42, 53),
							Position = UDim2.new(0, 0, 0, 40),
							Selectable = true,
							Size = UDim2.new(1, 0, 0, 120),
							ZIndex = 2,
							Image = "rbxassetid://3570695787",
							ImageColor3 = Themes.DropDownListContrast,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(100, 100, 100, 100),
							SliceScale = 0.040,
						})

						table.insert(Objects.DropDownListContrast, Interactables.listb)

						Interactables.list = Library:Create("ScrollingFrame", {
							Active = true,
							BackgroundColor3 = Color3.fromRGB(29, 29, 35),
							BackgroundTransparency = 1.000,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 1, 0),
							ZIndex = 2,
							CanvasSize = UDim2.new(0, 0, 0, 0),
							ScrollBarThickness = 3,
							ScrollBarImageColor3 = Color3.fromRGB(0,0,0),
						})

						table.insert(Objects.CharcoalContrast , Interactables.list)

						local tlistlayout = Library:Create("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 10)
						})

						tlistlayout.Parent = Interactables.list
						tlistlayout = nil

						local tpadding = Library:Create("UIPadding", {
							PaddingBottom = UDim.new(0, 10),
							PaddingLeft = UDim.new(0, 10),
							PaddingTop = UDim.new(0, 10),
						})

						local dropdownopen = false

						tpadding.Parent = Interactables.list
						tpadding = nil

						Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 40)
						Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 40)

						Interactables.dropdownb.Parent = Section.Container
						Interactables.dropdown.Parent = Interactables.dropdownb
						Interactables.arrow.Parent = Interactables.dropdown
						Interactables.selected.Parent = Interactables.dropdown
						Interactables.listb.Parent = Interactables.dropdown
						Interactables.list.Parent = Interactables.listb

						local function refreshlist()

							for i, v in next, Interactables.list:GetChildren() do
								if v:IsA("ImageButton") then
									v:Destroy()
								end
							end

							for i, v in next, tablelist do
								local button = Library:Create("ImageButton", {
									Name = string.lower(v),
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1.000,
									BorderColor3 = Color3.fromRGB(27, 42, 53),
									Position = UDim2.new(0, 252, 0, 0),
									Size = UDim2.new(0.98, 0, 0, 30),
									ZIndex = 2,
									AutoButtonColor = false,
									Image = "rbxassetid://3570695787",
									ImageColor3 = Themes.DarkContrast,
									ScaleType = Enum.ScaleType.Slice,
									SliceCenter = Rect.new(100, 100, 100, 100),
									SliceScale = 0.040,
								})

								table.insert(Objects.DarkContrast, button)

								local buttontext = Library:Create("TextLabel", {
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BackgroundTransparency = 1.000,
									BorderSizePixel = 0,
									Position = UDim2.new(0.078, 0, 0, 0),
									Size = UDim2.new(0.833, 0, 1, 0),
									ZIndex = 2,
									Font = Enum.Font.GothamBold,
									Text = v,
									TextColor3 = Themes.TextColor,
									TextSize = textsize,
								})

								table.insert(Objects.TextColor, buttontext)

								button.Parent = Interactables.list
								buttontext.Parent = button

								button.MouseButton1Click:Connect(function()
									if dropdownopen then

										dropdownopen = not dropdownopen
										Interactables.selected.Text = v
										selectedvalue = v



										if dropdownopen then
											refreshlist()
											TS:Create(Section.Container, TweenInfo.new(0.1), {
												Size = Section.Container.Size + UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
												Size = UDim2.new(0.982, 0, 0, 154)
											}):Play()
											TS:Create(Category.Container, TweenInfo.new(0.1), {
												CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.list, TweenInfo.new(0.1), {
												CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
											}):Play()
											TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
												Rotation = 0
											}):Play()
										else
											refreshlist()
											TS:Create(Section.Container, TweenInfo.new(0.1), {
												Size = Section.Container.Size - UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
												Size = UDim2.new(0.982, 0, 0, 30)
											}):Play()
											TS:Create(Category.Container, TweenInfo.new(0.1), {
												CanvasSize = Category.Container.CanvasSize - UDim2.new(0, 0, 0, 125)
											}):Play()
											TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
												Rotation = 90
											}):Play()
										end

										if CallBack then
											CallBack(selectedvalue)
										end
									end
								end)
							end
						end

						local Found = {}
						local searchtable = {}

						function Interactables:SetDropDownList(table)
							tablelist = {}
							if table then 
								if table.options then 
									tablelist = table.options
									refreshlist()
								end
							end
						end

						function Interactables:GetDropDownList()
							return tablelist
						end

						for f,h in pairs(tablelist) do
							table.insert(searchtable, string.lower(h))
						end

						refreshlist()
						

						Interactables.dropdown.MouseButton1Click:Connect(function()
							dropdownopen = not dropdownopen

							if Options.BeforeOpen then 
								Options.BeforeOpen()
							end

							if Options then
								if Options.options and Options.playerlist then
									tablelist = {}

									for g, f in pairs(Options.options) do
										table.insert(tablelist, f)
									end
									local list = game:GetService("Players"):GetChildren()
									if not Options.plotlist then
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)
											end
										end
									else
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)

												table.insert(tablelist, v.Name.."'s Plot")
											end
										end
									end
								elseif not Options.options and Options.playerlist then
									tablelist = {}
									local list = game:GetService("Players"):GetChildren()
									if not Options.plotlist then 
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)
											end
										end     
									else       
										for i, v in pairs(list) do
											if v:IsA("Player") then
												table.insert(tablelist, v.Name)

												table.insert(tablelist, v.Name.."'s Plot")
											end
										end										
									end                        
								end
							end

							if dropdownopen then
								for f,h in pairs(tablelist) do
									table.insert(searchtable, string.lower(h))
								end	
								refreshlist()
								TS:Create(Section.Container, TweenInfo.new(0.1), {
									Size = Section.Container.Size + UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
									Size = UDim2.new(0.982, 0, 0, 154)
								}):Play()
								TS:Create(Category.Container, TweenInfo.new(0.1), {
									CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.list, TweenInfo.new(0.1), {
									CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
								}):Play()
								TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
									Rotation = 0
								}):Play()
							else
								for f,h in pairs(tablelist) do
									table.insert(searchtable, string.lower(h))
								end	
								refreshlist()
								TS:Create(Section.Container, TweenInfo.new(0.1), {
									Size = Section.Container.Size - UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.dropdownb, TweenInfo.new(0.1), {
									Size = UDim2.new(0.982, 0, 0, 30)
								}):Play()
								TS:Create(Category.Container, TweenInfo.new(0.1), {
									CanvasSize = Category.Container.CanvasSize - UDim2.new(0, 0, 0, 125)
								}):Play()
								TS:Create(Interactables.arrow, TweenInfo.new(0.1), {
									Rotation = 90
								}):Play()
							end

						end)

						local function Edit()
							for i in pairs(Found) do
								Found[i] = nil
							end
							for h, l in pairs(Interactables.list:GetChildren()) do
								if not l:IsA("UIListLayout") and not l:IsA("UIPadding") then
									l.Visible = false
								end
							end
							Interactables.selected.Text = string.lower(Interactables.selected.Text)
						end

						local function Search()
							local Results = {}
							local num
							for i, v in pairs(searchtable) do
								if string.find(v, Interactables.selected.Text) then
									table.insert(Found, v)
								end
							end
							for a, b in pairs(Interactables.list:GetChildren()) do
								for c, d in pairs(Found) do
									if d == b.Name then
										b.Visible = true
									end
								end
							end
							for p, n in pairs(Interactables.list:GetChildren()) do
								if not n:IsA("UIListLayout") and not n:IsA("UIPadding") and n.Visible == true then
									table.insert(Results, n)
									for c, d in pairs(Results) do
										num = c
									end
								end
							end
							if num ~= nil then
								num = num * 40
								Interactables.list.CanvasSize = UDim2.new(0, 0, 0, num) + UDim2.new(0, 0, 0, 20)
								num = 0
							end
						end

						local function Nil()
							for i, v in pairs(Interactables.list:GetChildren()) do
								if not v:IsA("UIListLayout") and not v:IsA("UIPadding") and v.Visible == false then
									TS:Create(Interactables.list, TweenInfo.new(0.1), {
										CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
									}):Play()
									v.Visible = true
								end 
							end
						end


						local SearchLock = true
						Interactables.selected.Changed:connect(function()
							if not SearchLock then
								Edit()
								Search()
							end
							if Interactables.selected.Text == "" then
								Nil()
								TS:Create(Interactables.list, TweenInfo.new(0.1), {
									CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
								}):Play()
							end
						end)


						Interactables.selected.FocusLost:connect(function()
							SearchLock = true
							if Interactables.selected.Text == "" then
								TS:Create(Interactables.list, TweenInfo.new(0.1), {
									CanvasSize = UDim2.new(0, 0, 0, Interactables.list["UIListLayout"].AbsoluteContentSize.Y) + UDim2.new(0, 0, 0, 26)
								}):Play()
								SearchLock = true
								Nil()
								Interactables.selected.Text = tostring(Options.default) or tostring(selectedvalue)
							end
						end)

						Interactables.selected.Focused:connect(function()
							SearchLock = false
						end)
					end

				elseif Type:lower() == "colorpicker" then 

					local colorpickeropen = false
					local colorpickervalue

					Interactables.colorpickerb = Library:Create("ImageButton", {
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						Position = UDim2.new(0, 11, 0, 125),
						Size = UDim2.new(0.982, 0, 0, 35),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Themes.DarkContrast,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					table.insert(Objects.DarkContrast , Interactables.colorpickerb)

					Interactables.colorpickertext = Library:Create("TextLabel", {
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0.008, 0, 0, 2),
						Size = UDim2.new(0.4, 0, 0, 30),
						Font = Enum.Font.GothamBold,
						Text = Name,
						TextColor3 = Themes.TextColor,
						TextSize = 18.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					table.insert(Objects.TextColor, Interactables.colorpickertext)

					Interactables.colorpickerbutton = Library:Create("ImageLabel", {
						Active = true,
						Name = "Value",
						BackgroundColor3 = Color3.fromRGB(248, 248, 248),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(1, -74, 0, 4),
						Selectable = true,
						Size = UDim2.new(0, 70, 0, 26),
						Image = "rbxassetid://3570695787",
						ImageColor3 = Color3.fromRGB(255, 0, 4),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
						SliceScale = 0.040,
					})

					Interactables.ColorpickerFrameBack = Library:Create("Frame", {
						Name = "colorframe",
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(46, 46, 54),
						BorderSizePixel = 0,
						Position = UDim2.new(1, 8, 0, 0),
						Size = UDim2.new(0, 0, 0, 265),
					})

					Interactables.ColorpickerFrame = Library:Create("Frame", {
						Name = "MainFrame",
						BackgroundColor3 = Color3.fromRGB(46, 46, 54),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, 0),
						Size = UDim2.new(0, 220, 0, 265),
					})
					
					table.insert(Objects.Background , Interactables.ColorpickerFrame)

					Interactables.HuePicker = Library:Create("ImageButton", {
						Name = "HuePicker",
						BackgroundColor3 = Color3.fromRGB(46, 46, 54),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 190, 0, 20),
						Size = UDim2.new(0, 10, 0, 150),
						ZIndex = 2,
						Image = "http://www.roblox.com/asset/?id=5118428654",
					})

					Interactables.Rounder = Library:Create("ImageLabel", {
						Name = "Rounder",
						BackgroundColor3 = Color3.fromRGB(46, 46, 54),
						BackgroundTransparency = 1.000,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 1, 0),
						Image = "rbxassetid://4695575676",
						ImageColor3 = Color3.fromRGB(46, 46, 54),
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(128, 128, 128, 128),
						SliceScale = 0.040,
					})

					Interactables.HueRing = Library:Create("ImageLabel", {
						Name = "HueRing",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0, -1, 0, 0),
						Size = UDim2.new(0, 12, 0, 12),
						ZIndex = 2,
						Image = "rbxassetid://3570695787",
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(100, 100, 100, 100),
					})

					Interactables.DarknessPicker = Library:Create("ImageButton", {
						Name = "DarknessPicker",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderColor3 = Color3.fromRGB(221, 221, 221),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 20, 0, 20),
						Size = UDim2.new(0, 150, 0, 150),
						AutoButtonColor = false,
						Image = "rbxassetid://5113592272",
						ImageColor3 = Color3.fromRGB(255, 0, 0),
					})

					Interactables.Light = Library:Create("ImageLabel", {
						Name = "Light",
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Size = UDim2.new(1, 0, 1, 0),
						Image = "rbxassetid://5113600420",
					})

					Interactables.DarknessRing = Library:Create("ImageLabel", {
						Name = "DarknessRing",
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Size = UDim2.new(0, 10, 0, 10),
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						ZIndex = 5,
						Image = "http://www.roblox.com/asset/?id=5674514673",
					})

					Interactables.R = Library:Create("Frame", {
						Name = "R",
						BackgroundColor3 = Color3.fromRGB(72, 72, 85),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 20, 0, 212),
						Size = UDim2.new(0, 30, 0, 2),    
					})

					Interactables.RLabel = Library:Create("TextLabel", {
						Name = "RLabel",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0, 0, 0, -34),
						Size = UDim2.new(0, 30, 0, 15),
						Font = Enum.Font.GothamBold,
						Text = "R:",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					Interactables.RBox = Library:Create("TextBox", {
						Name = "RBox",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, -15),
						Size = UDim2.new(0, 30, 0, 15),
						Font = Enum.Font.GothamBold,
						Text = "255",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextXAlignment = Enum.TextXAlignment.Left,    
					})

					Interactables.G = Library:Create("Frame", {
						Name = "G",
						BackgroundColor3 = Color3.fromRGB(72, 72, 85),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 95, 0, 212),
						Size = UDim2.new(0, 30, 0, 2),
					})

					Interactables.GLabel = Library:Create("TextLabel", {
						Name = "GLabel",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0, 0, 0, -34),
						Size = UDim2.new(0, 30, 0, 15),
						Font = Enum.Font.GothamBold,
						Text = "G:",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					Interactables.GBox = Library:Create("TextBox", {
						Name = "GBox",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, -15),
						Size = UDim2.new(0, 30, 0, 15),
						Font = Enum.Font.GothamBold,
						Text = "255",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					Interactables.B = Library:Create("Frame", {
						Name = "B",
						BackgroundColor3 = Color3.fromRGB(72, 72, 85),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 171, 0, 212),
						Size = UDim2.new(0, 30, 0, 2),
					})

					Interactables.BLabel = Library:Create("TextLabel", {
						Name = "BLabel",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0, 0, 0, -34),
						Size = UDim2.new(0, 30, 0, 15),
						Font = Enum.Font.GothamBold,
						Text = "B:",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					Interactables.BBox = Library:Create("TextBox", {
						Name = "BBox",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						BorderSizePixel = 0,
						Position = UDim2.new(0, 0, 0, -15),
						Size = UDim2.new(0, 30, 0, 15),
						Font = Enum.Font.GothamBold,
						Text = "255",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14.000,
						TextXAlignment = Enum.TextXAlignment.Left,
					})

					Interactables.Done = Library:Create("TextButton", {
						Name = "Done",
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 1.000,
						Position = UDim2.new(0, 60, 0, 227),
						Size = UDim2.new(0, 100, 0, 25),
						Font = Enum.Font.GothamBold,
						Text = "DONE",
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 16.000,
					})

					Interactables.ColorpickerFrameBack.Parent = Main.Motherframe
					Interactables.ColorpickerFrameBack.ClipsDescendants = true
					Interactables.ColorpickerFrame.Parent = Interactables.ColorpickerFrameBack
					Interactables.HuePicker.Parent = Interactables.ColorpickerFrame
					Interactables.Rounder.Parent = Interactables.HuePicker
					Interactables.HueRing.Parent = Interactables.HuePicker
					Interactables.DarknessPicker.Parent = Interactables.ColorpickerFrame
					Interactables.Light.Parent = Interactables.DarknessPicker
					Interactables.DarknessRing.Parent = Interactables.DarknessPicker
					Interactables.R.Parent = Interactables.ColorpickerFrame
					Interactables.RLabel.Parent = Interactables.R
					Interactables.RBox.Parent = Interactables.R
					Interactables.G.Parent = Interactables.ColorpickerFrame
					Interactables.GLabel.Parent = Interactables.G
					Interactables.GBox.Parent = Interactables.G
					Interactables.B.Parent = Interactables.ColorpickerFrame
					Interactables.BLabel.Parent = Interactables.B
					Interactables.BBox.Parent = Interactables.B
					Interactables.Done.Parent = Interactables.ColorpickerFrame


					Section.Container.Size = Section.Container.Size + UDim2.new(0, 0, 0, 45)
					Category.Container.CanvasSize = Category.Container.CanvasSize + UDim2.new(0, 0, 0, 45)

					Interactables.colorpickerb.Parent = Section.Container
					Interactables.colorpickertext.Parent = Interactables.colorpickerb
					Interactables.colorpickerbutton.Parent = Interactables.colorpickerb

					Interactables.colorpickerb.MouseButton1Click:Connect(function()
						colorpickeropen = not colorpickeropen

						for i,v in pairs(Main.Motherframe:GetChildren()) do
							if v.Name == "colorframe" then
								game:GetService("TweenService"):Create(v, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 265)}):Play()
							end
						end

						if colorpickeropen then 
							game:GetService("TweenService"):Create(Interactables.ColorpickerFrameBack, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 265)}):Play()
						end
					end)

					Interactables.Done.MouseButton1Click:Connect(function()
						colorpickeropen = not colorpickeropen
						for i,v in pairs(Main.Motherframe:GetChildren()) do
							if v.Name == "colorframe" then
								game:GetService("TweenService"):Create(v, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 265)}):Play()
							end
						end
					end)

					local h,s,v = 0,0,1
					local color = Color3.fromRGB(255,255,255)
					local r,g,b = 255,255,255

					local hueconnection
					local darknessconnection

					local function Update()

						Interactables.RBox.Text = math.floor(r)
						Interactables.GBox.Text = math.floor(g)
						Interactables.BBox.Text = math.floor(b)
						
						TS:Create(Interactables.HueRing, TweenInfo.new(0.12), {Position = UDim2.new(0, -1, h, -6)}):Play()
						TS:Create(Interactables.DarknessRing, TweenInfo.new(0.12), {Position = UDim2.new(s, 0, 1 - v, 0)}):Play()
					
						Interactables.DarknessPicker.ImageColor3 = Color3.fromHSV(h,1,1)

						Interactables.colorpickerbutton.ImageColor3 = Color3.fromRGB(r,g,b)
					
						local colorvalue = Color3.fromHSV(h,s,v)
					
						if CallBack then 
							CallBack(colorvalue)
						end
					end
					
					Interactables.HuePicker.MouseButton1Down:Connect(function()
						hueconnection = RS.Heartbeat:Connect(function()
							h = 1 - math.clamp(1 - ((mouse.Y - Interactables.HuePicker.AbsolutePosition.Y) / Interactables.HuePicker.AbsoluteSize.Y), 0, 1)
							color = Color3.fromHSV(h,s,v)
					
							r,g,b = math.floor(color.r * 255), math.floor(color.g * 255), math.floor(color.b * 255)
					
							Update()
						end)
					end)
					
					Interactables.DarknessPicker.MouseButton1Down:Connect(function()
						darknessconnection = RS.Heartbeat:Connect(function()
							s = math.clamp((mouse.X - Interactables.DarknessPicker.AbsolutePosition.X) / Interactables.DarknessPicker.AbsoluteSize.X, 0, 1)
							v = 1 - math.clamp((mouse.Y - Interactables.DarknessPicker.AbsolutePosition.Y) / Interactables.DarknessPicker.AbsoluteSize.Y, 0, 1)
							color = Color3.fromHSV(h,s,v)
					
							r,g,b = math.floor(color.r * 255), math.floor(color.g * 255), math.floor(color.b * 255)
					
							Update()
						end)
					end)
					
					Interactables.RBox:GetPropertyChangedSignal("Text"):Connect(function()
						if not hueconnection and not darknessconnection then  
							local Text = Interactables.RBox.Text
					
							if not tonumber(Text) then 
								Interactables.RBox.Text = Interactables.RBox.Text:gsub("%D", "")
							elseif tonumber(Text) > 255 then 
								Interactables.RBox.Text = "255"
							elseif tonumber(Text) and tonumber(Text) <= 255 then 
								r = Text
								local color = Color3.fromRGB(r,g,b)
								h,s,v = Color3.toHSV(color)
								Update()
							end
						end 
					end)
					
					Interactables.GBox:GetPropertyChangedSignal("Text"):Connect(function()
						if not hueconnection and not darknessconnection then 
							local Text = Interactables.GBox.Text
					
							if not tonumber(Text) then 
								Interactables.GBox.Text = Interactables.GBox.Text:gsub("%D", "")
							elseif tonumber(Text) > 255 then 
								Interactables.GBox.Text = "255"
							elseif tonumber(Text) and tonumber(Text) <= 255 then 
								g = Text
								local color = Color3.fromRGB(r,g,b)
								h,s,v = Color3.toHSV(color)
								Update()
							end
						end 
					end)
					
					Interactables.BBox:GetPropertyChangedSignal("Text"):Connect(function()
						if not hueconnection and not darknessconnection then 
							local Text = Interactables.BBox.Text
					
							if not tonumber(Text) then 
								Interactables.BBox.Text = Interactables.BBox.Text:gsub("%D", "")
							elseif tonumber(Text) > 255 then 
								Interactables.BBox.Text = "255"
							elseif tonumber(Text) and tonumber(Text) <= 255 then 
								b = Text
								local color = Color3.fromRGB(r,g,b)
								h,s,v = Color3.toHSV(color)
								Update()
							end
						end 
					end)

					if Options then 
						if Options.default then 
							r,g,b = Options.default.r * 255, Options.default.g * 255, Options.default.b * 255
							h,s,v = Color3.toHSV(Options.default)
							Update()
						end 
					end 
					
					function Library:SetColor(Color)
						r,g,b = Color.r * 255, Color.g * 255, Color.b * 255
						h,s,v = Color3.toHSV(Color)
						Update()
					end
					
					UIS.InputEnded:Connect(function(Mouse)
						if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
							if hueconnection then
								hueconnection:Disconnect()
								hueconnection = nil
							end
							if darknessconnection then
								darknessconnection:Disconnect()
								darknessconnection = nil
							end
						end
					end)
					
				end

				return Interactables

			end

			Section.Container.Parent = Category.Container

			Section.SectionPadding.Parent = Section.Container

			Section.SectionLayout.Parent = Section.Container

			Section.SectionName.Parent = Section.Container

			return Section

		end

		CategoryDistanceCounter = CategoryDistanceCounter + 35

		Category.CButton.Parent = Main.Sidebar

		Category.Container.Parent = Main.Categorieshandler

		Category.CPadding.Parent = Category.Container

		Category.CLayout.Parent = Category.Container

		Main.Sidebar.CanvasSize = Main.Sidebar.CanvasSize + UDim2.new(0, 0, 0, 35)

		firstCategory = false

		return Category

	end

	Main.Screengui.Parent = game:GetService("CoreGui")
	Main.Motherframe.Parent = Main.Screengui
	Main.Upline.Parent = Main.Motherframe
	Main.Uplinegradient.Parent = Main.Upline
	Main.Sidebar.Parent = Main.Motherframe
	Main.Categorieshandler.Parent = Main.Motherframe
	Main.Categoriesselector.Parent = Main.Sidebar

	return Main
end

function Library:SetThemeColor(Theme, Color)
	Themes[Theme] = Color

	if Theme == "TextColor" then 
		for i,v in pairs(Objects.TextColor) do 
			if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then 
				v.TextColor3 = Color
			elseif v:IsA("ImageLabel") then 
				v.ImageColor3 = Color
			end 
		end 
	elseif Theme == "GrayContrast" then 
		for i,v in pairs(Objects.GrayContrast) do 
			if v:IsA("ScrollingFrame") then 
				v.BackgroundColor3 = Color
			elseif v:IsA("ImageLabel") then 
				v.ImageColor3 = Color
			end
		end 
	elseif Theme == "Background" then 
		for i,v in pairs(Objects.Background) do
			if v:IsA("Frame") or v:IsA("TextButton") or v:IsA("ScrollingFrame") then
				v.BackgroundColor3 = Color
			elseif v:IsA("ImageLabel") then 
				v.ImageColor3 = Color
			end 
		end
	elseif Theme == "DarkContrast" then 
		for i,v in pairs(Objects.DarkContrast) do 
			v.ImageColor3 = Color
		end 
	elseif Theme == "SectionContrast" then 
		for i,v in pairs(Objects.SectionContrast) do 
			v.ImageColor3 = Color
		end 
	elseif Theme == "DropDownListContrast" then 
		for i,v in pairs(Objects.DropDownListContrast) do 
			v.ImageColor3 = Color
		end  
	elseif Theme == "CharcoalContrast" then 
		for i,v in pairs(Objects.CharcoalContrast) do 
			if not v:IsA("ScrollingFrame") then 
				v.ImageColor3 = Color
			else
				v.ScrollBarImageColor3 = Color 
			end
		end  	
	end 
end

return Library
