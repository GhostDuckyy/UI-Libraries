
local plr = game:GetService('Players').LocalPlayer
local runS = game:GetService('RunService')
local pgui = plr.PlayerGui
local mouse = plr:GetMouse()
local uis = game:GetService("UserInputService")

local lib = {
	SelectedTab = nil,
	Tabs = {},
}

for i,v in next,game:GetService("CoreGui"):GetChildren() do
	if v.Name == "ScriptedUI" then
		v:Destroy()
	end
end
local windows = {}

local baseui = Instance.new("ScreenGui")
if not runS:IsStudio() then
	if syn then
		syn.protect_gui(baseui)
	end
	baseui.Parent = game:GetService('CoreGui')
else
	baseui.Parent = pgui
end
baseui.Name = "ScriptedUI"
baseui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local BG = Instance.new("Frame")
BG.BackgroundColor3 = Color3.fromRGB(20,20,20)
BG.Position = UDim2.new(0.5,0,0.5,0)
BG.AnchorPoint = Vector2.new(0.5,0.5)
BG.Size = UDim2.fromOffset(743, 448)
BG.Parent = baseui
BG.Name = "BackgroundFrame"
BG.Active = true
BG.Draggable = true

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 16)
bgCorner.Parent = BG

--// Tab holder

local TabBG = Instance.new("Frame")
TabBG.BackgroundColor3 = Color3.fromRGB(25,23,26)
TabBG.Size = UDim2.fromOffset(183, 448)
TabBG.Parent = BG

local TabBGCorner = Instance.new("UICorner")
TabBGCorner.CornerRadius = UDim.new(0, 8)
TabBGCorner.Parent = TabBG

local Inliner = Instance.new("Frame")
Inliner.BackgroundColor3 = Color3.fromRGB(25,23,26)
Inliner.Size = UDim2.fromOffset(126, 448)
Inliner.BorderSizePixel = 0
Inliner.Position = UDim2.fromScale(1, 0)
Inliner.AnchorPoint = Vector2.new(1, 0)
Inliner.Parent = TabBG

local HideTabButton = Instance.new("ImageLabel")
HideTabButton.Parent = TabBG
HideTabButton.BackgroundTransparency = 1.000
HideTabButton.BorderSizePixel = 0
HideTabButton.Position = UDim2.new(0.86445713, 0, 0.0267857164, 0)
HideTabButton.Size = UDim2.new(0, 50, 0, 50)
HideTabButton.Image = "http://www.roblox.com/asset/?id=6031625146"
HideTabButton.ImageColor3 = Color3.fromRGB(20,20,20)

local InsideCircle = Instance.new("ImageLabel")
InsideCircle.Name = "InsideCircle"
InsideCircle.Parent = HideTabButton
InsideCircle.AnchorPoint = Vector2.new(0.5, 0.5)
InsideCircle.BackgroundTransparency = 1.000
InsideCircle.BorderSizePixel = 0
InsideCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
InsideCircle.Size = UDim2.new(0, 33, 0, 33)
InsideCircle.Image = "http://www.roblox.com/asset/?id=6031625146"
InsideCircle.ImageColor3 = Color3.fromRGB(30,30,30)

local InsideArrow = Instance.new("ImageLabel")
InsideArrow.Name = "InsideArrow"
InsideArrow.Parent = HideTabButton
InsideArrow.AnchorPoint = Vector2.new(0.5, 0.5)
InsideArrow.BackgroundTransparency = 1.000
InsideArrow.BorderSizePixel = 0
InsideArrow.Position = UDim2.new(0.5, 0, 0.5, 0)
InsideArrow.Size = UDim2.new(0, 30, 0, 30)
InsideArrow.Image = "http://www.roblox.com/asset/?id=6034818375"

local UITitle = Instance.new("TextLabel")
UITitle.Name = "UITitle"
UITitle.Parent = TabBG
UITitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UITitle.BackgroundTransparency = 1.000
UITitle.BorderSizePixel = 0
UITitle.Position = UDim2.new(0.125207946, 0, 0.046875, 0)
UITitle.Size = UDim2.new(0, 135, 0, 32)
UITitle.Font = Enum.Font.GothamBlack
UITitle.Text = "Default Title"
UITitle.TextColor3 = Color3.fromRGB(80,80,80)
UITitle.TextSize = 18
UITitle.TextScaled = true;

UITitle.TextXAlignment = Enum.TextXAlignment.Left

local TabButtons = Instance.new("ScrollingFrame")
TabButtons.Name = "TabButtons"
TabButtons.Parent = TabBG
TabButtons.Active = true
TabButtons.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TabButtons.BackgroundTransparency = 1.000
TabButtons.BorderSizePixel = 0
TabButtons.Position = UDim2.new(0, 0, 0.136160716, 0)
TabButtons.Size = UDim2.new(0, 183, 0, 387)
TabButtons.ScrollBarThickness = 0

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabButtons
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

function lib:SetTitle(title)
	UITitle.Text = tostring(title)
end

lib:SetTitle("Cheeto Hub Premium | FF2")
function lib:Toggle()
	baseui.Enabled = not baseui.Enabled;
end
uis.InputBegan:Connect(function(key,gp)
	if gp then return end

	if key.KeyCode == Enum.KeyCode.LeftControl then
		lib:Toggle()
	end
end)

function lib:NewTab(name, desc)
	local tabFuncs = {}

	local TabButton = Instance.new("TextButton")
	TabButton.Name = name
	TabButton.Parent = TabButtons
	TabButton.AnchorPoint = Vector2.new(0.5, 0)
	TabButton.BackgroundColor3 = #lib.Tabs == 0 and Color3.fromRGB(45,40,50) or Color3.fromRGB(35,35,35) -- SELECTED: Color3.fromRGB(231, 231, 255)
	TabButton.BorderSizePixel = 0
	TabButton.BackgroundTransparency = #lib.Tabs == 0 and 0 or 1 -- 0: SELECTED / HOVERED
	TabButton.Position = UDim2.new(0.5, 0, 0, 0)
	TabButton.Size = UDim2.new(0, 155, 0, 35)
	TabButton.AutoButtonColor = false
	TabButton.Font = Enum.Font.GothamMedium
	TabButton.Text = ""
	TabButton.TextColor3 = Color3.fromRGB(105, 108, 255)
	TabButton.TextSize = 14.000

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 4)
	TabCorner.Parent = TabButton

	local TabTitle = Instance.new("TextLabel")
	TabTitle.Parent = TabButton
	TabTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabTitle.BackgroundTransparency = 1.000
	TabTitle.Size = UDim2.new(1, 0, 1, 0)
	TabTitle.Font = Enum.Font.GothamBold
	TabTitle.Text = name
	TabTitle.TextColor3 = #lib.Tabs == 0 and Color3.fromRGB(105, 108, 255) or Color3.fromRGB(70,70,70) -- SELECTED: Color3.fromRGB(105, 108, 255)
	TabTitle.TextSize = 14.000
	TabTitle.TextStrokeColor3 = Color3.fromRGB(105, 108, 255)

	local sectionBG = Instance.new("Frame")
	sectionBG.BackgroundColor3 = Color3.fromRGB(24,24,24)
	sectionBG.Position = UDim2.fromScale(0.284, 0.046)
	sectionBG.Visible = #lib.Tabs == 0 and true or false
	sectionBG.Size = UDim2.fromOffset(504, 410)
	sectionBG.Parent = BG

	local sectionbgCorner = Instance.new("UICorner")
	sectionbgCorner.CornerRadius = UDim.new(0, 16)
	sectionbgCorner.Parent = sectionBG

	local SectionTitle = Instance.new("TextLabel")
	SectionTitle.Name = "SectionTitle"
	SectionTitle.Parent = sectionBG
	SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SectionTitle.BackgroundTransparency = 1.000
	SectionTitle.Position = UDim2.new(0.0575396828, 0, 0, 0)
	SectionTitle.Size = UDim2.new(0, 129, 0, 49)
	SectionTitle.Font = Enum.Font.SourceSansItalic
	SectionTitle.Text = name
	SectionTitle.TextColor3 = Color3.fromRGB(105, 122, 141)
	SectionTitle.TextSize = 24.000
	SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

	local Description = Instance.new("TextLabel")
	Description.Name = "Description"
	Description.Parent = sectionBG
	Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Description.BackgroundTransparency = 1.000
	Description.Position = UDim2.new(0.0575396828, 0, 0.0684210509, 0)
	Description.Size = UDim2.new(0, 129, 0, 49)
	Description.Font = Enum.Font.SourceSansSemibold
	Description.Text = desc or ""
	Description.TextColor3 = Color3.fromRGB(80,80,80)
	Description.TextSize = 20.000
	Description.TextXAlignment = Enum.TextXAlignment.Left

	local ScrollingFrame = Instance.new("ScrollingFrame")
	ScrollingFrame.Parent = sectionBG
	ScrollingFrame.Active = true
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.0575396828, 0, 0.197368339, 0)
	ScrollingFrame.Size = UDim2.new(0, 475, 0, 329)
	ScrollingFrame.ScrollBarThickness = 6
	ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(28,28,28)
	ScrollingFrame.ScrollingEnabled = true


	local UIListLayout_2 = Instance.new("UIListLayout")
	UIListLayout_2.Parent = ScrollingFrame
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.Padding = UDim.new(0, 10)


	local UIPadding = Instance.new("UIPadding")
	UIPadding.Parent = ScrollingFrame
	UIPadding.PaddingLeft = UDim.new(0.00100000005, 0)
	UIPadding.PaddingTop = UDim.new(0, 1)

	local layout = UIListLayout_2
	local script = ScrollingFrame
	script.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + layout.Padding.Offset + 50)

	script.ChildAdded:Connect(function()
		script.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + layout.Padding.Offset + 50)
	end)



	local tabtable = {
		button = TabButton,
		TitleInstance = TabTitle,
		sectionBG = sectionBG,
	}
	table.insert(lib.Tabs, tabtable)
	if not lib.SelectedTab then
		lib.SelectedTab = tabtable
	end
	TabButton.MouseButton1Click:Connect(function()
		if not lib.SelectedTab or lib.SelectedTab.button ~= tabtable.button then
			lib.SelectedTab.sectionBG.Visible = false
			lib.SelectedTab.button.BackgroundColor3 = Color3.fromRGB(35,35,35)
			lib.SelectedTab.button.BackgroundTransparency = 1
			lib.SelectedTab.TitleInstance.TextColor3 = Color3.fromRGB(70,70,70)

			lib.SelectedTab = tabtable
			lib.SelectedTab.sectionBG.Visible = true
			lib.SelectedTab.button.BackgroundColor3 = Color3.fromRGB(45,40,50)
			lib.SelectedTab.button.BackgroundTransparency = 0
			lib.SelectedTab.TitleInstance.TextColor3 = Color3.fromRGB(105, 108, 255)
		end
	end)



	function tabFuncs:NewButton(name, callback)
		local Button = Instance.new("TextButton")
		Button.Name = "Button"
		Button.Parent = ScrollingFrame
		Button.BackgroundColor3 = Color3.fromRGB(28,28,28)
		Button.Position = UDim2.new(0, 0, 0.427631587, 0)
		Button.Size = UDim2.new(0.949999988, 0, 0, 35)
		Button.AutoButtonColor = false
		Button.Font = Enum.Font.SourceSans
		Button.Text = ""
		Button.TextColor3 = Color3.fromRGB(0, 0, 0)
		Button.TextSize = 14.000

		local UICorner_18 = Instance.new("UICorner")
		UICorner_18.Parent = Button

		local ToggleText_4 = Instance.new("TextLabel")
		ToggleText_4.Name = "ToggleText"
		ToggleText_4.Parent = Button
		ToggleText_4.BackgroundColor3 = Color3.fromRGB(105,121,144)
		ToggleText_4.BackgroundTransparency = 1.000
		ToggleText_4.Size = UDim2.new(1, 0, 1, 0)
		ToggleText_4.Font = Enum.Font.SourceSansSemibold
		ToggleText_4.Text = name
		ToggleText_4.TextColor3 = Color3.fromRGB(105,121,144)
		ToggleText_4.TextSize = 16.000
		Button.MouseButton1Down:Connect(function()
			Button.BackgroundColor3 = Color3.fromRGB(32,32,32)
		end)
		Button.MouseButton1Up:Connect(function()
			Button.BackgroundColor3 = Color3.fromRGB(28,28,28)
		end)
		if type(callback) == "function" then
			spawn(function()
				Button.MouseButton1Click:Connect(callback)
			end)
		end
	end

	function tabFuncs:NewToggle(name, default, callback)
		local togglefuncs = {
			enabled = default;
		}
		local Toggle = Instance.new("TextButton")
		Toggle.Name = "Toggle"
		Toggle.Parent = ScrollingFrame
		Toggle.BackgroundColor3 = Color3.fromRGB(27,27,27)
		Toggle.Size = UDim2.new(0.949999988, 0, 0, 50)
		Toggle.AutoButtonColor = false
		Toggle.Font = Enum.Font.SourceSans
		Toggle.Text = ""
		Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.TextSize = 14.000
		Toggle.BackgroundTransparency = 1

		local UICorner_12 = Instance.new("UICorner")
		UICorner_12.Parent = Toggle

		local ToggleText = Instance.new("TextLabel")
		ToggleText.Name = name
		ToggleText.Parent = Toggle
		ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleText.BackgroundTransparency = 1.000
		ToggleText.Position = UDim2.new(0.10780859, 0, 0, 0)
		ToggleText.Size = UDim2.new(0, 228, 0, 50)
		ToggleText.Font = Enum.Font.SourceSansSemibold
		ToggleText.Text = name
		ToggleText.TextColor3 = Color3.fromRGB(105, 122, 141)
		ToggleText.TextSize = 18.000
		ToggleText.TextTransparency = 0.340
		ToggleText.TextXAlignment = Enum.TextXAlignment.Left

		local Checkbox = Instance.new("Frame")
		Checkbox.Name = name
		Checkbox.Parent = Toggle
		Checkbox.Active = true
		Checkbox.AnchorPoint = Vector2.new(0, 0.5)
		Checkbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
		Checkbox.Position = UDim2.new(0, 16, 0.5, 0)
		Checkbox.Size = UDim2.new(0, 20, 0, 20)

		local UICorner_13 = Instance.new("UICorner")
		UICorner_13.CornerRadius = UDim.new(0, 4)
		UICorner_13.Parent = Checkbox

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Checkbox
		UIStroke.Color = Color3.fromRGB(72,74,76)

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.Parent = Checkbox
		ImageLabel.Visible = false
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(70,70,70)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(1, -4, 1, -4)
		ImageLabel.Image = "http://www.roblox.com/asset/?id=6031094667"
		togglefuncs.enabled = default
		spawn(function()
			callback(togglefuncs.enabled)
		end)
		if not togglefuncs.enabled then
			ImageLabel.Visible = false
			ToggleText.TextTransparency = 0.340
			Checkbox.BackgroundColor3 = Color3.fromRGB(30,30,30)
			UIStroke.Color = Color3.fromRGB(72,74,76)
		else
			ToggleText.TextTransparency = 0
			ImageLabel.Visible = true
			Checkbox.BackgroundColor3 = Color3.fromRGB(105, 108, 255)
			UIStroke.Color = Color3.fromRGB(72,74,76)
		end

		Toggle.MouseButton1Click:Connect(function()
			if togglefuncs.enabled then
				togglefuncs.enabled = false
				ImageLabel.Visible = false
				game:GetService("TweenService"):Create(ToggleText,TweenInfo.new(0.15),{TextTransparency = 0.34},"InOut","Sine"):Play()
				game:GetService("TweenService"):Create(Checkbox,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(30,30,30)},"InOut","Sine"):Play()
				game:GetService("TweenService"):Create(UIStroke,TweenInfo.new(0.15),{Color = Color3.fromRGB(60,60,60)},"InOut","Sine"):Play()
			else
				togglefuncs.enabled = true
				ToggleText.TextTransparency = 0
				ImageLabel.Visible = true

				game:GetService("TweenService"):Create(ToggleText,TweenInfo.new(0.15),{TextTransparency = 0},"InOut","Sine"):Play()
				game:GetService("TweenService"):Create(Checkbox,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(105, 108, 255)},"InOut","Sine"):Play()
				game:GetService("TweenService"):Create(UIStroke,TweenInfo.new(0.15),{Color = Color3.fromRGB(60,60,60)},"InOut","Sine"):Play()

			end
			spawn(function()
				callback(togglefuncs.enabled)   
			end)
		end)




	end
	function tabFuncs:NewSlider(name,minimium,maximium,default,callback)
		local Slider = Instance.new("TextButton")
		Slider.AutoButtonColor = false
		Slider.Name = name
		Slider.TextTransparency = 1
		Slider.Parent = ScrollingFrame
		Slider.Size = UDim2.new(0.95,0,0,50)
		Slider.BackgroundColor3 = Color3.fromRGB(25,25,25)
		Slider.BackgroundTransparency = 0;
		Slider.BorderSizePixel = 0


		local UICorner = Instance.new("UICorner",Slider)
		UICorner.CornerRadius = UDim.new(0,8)

		local SliderBG = Instance.new("Frame")
		SliderBG.Name = "SliderBG"
		SliderBG.Parent = Slider
		SliderBG.AnchorPoint = Vector2.new(0, 0.5)
		SliderBG.Position = UDim2.new(0,16,0.67,0)
		SliderBG.BackgroundColor3 = Color3.fromRGB(25,25,25)
		SliderBG.Size = UDim2.new(0,418,0,7)
		SliderBG.Visible = true;
		SliderBG.BorderSizePixel = 0

		local SliderText = Instance.new("TextLabel")
		SliderText.Parent = Slider;
		SliderText.Text = name
		SliderText.Name = "SliderText"
		SliderText.BackgroundTransparency = 1;
		SliderText.TextSize = 18;
		SliderText.AnchorPoint = Vector2.new(1,0)
		SliderText.TextColor3 = Color3.fromRGB(105,122,141)
		SliderText.Font = Enum.Font.SourceSansSemibold
		SliderText.Position = UDim2.new(0,16,0.2, 0)
		SliderText.TextXAlignment = Enum.TextXAlignment.Center

		local pad = Instance.new("UIPadding",SliderText)
		pad.PaddingLeft = UDim.new(0,124)

		local SliderValue = Instance.new("TextLabel")
		SliderValue.AnchorPoint = Vector2.new(0.5,0.5)
		SliderValue.TextSize = 18
		SliderValue.Parent = Slider
		SliderValue.Position = UDim2.new(0.8,0,0.16,0)
		SliderValue.TextColor3 = Color3.fromRGB(105,122,141)
		SliderValue.TextTransparency = 0.53
		SliderValue.Font = Enum.Font.SourceSansSemibold
		SliderValue.BorderSizePixel = 0;
		SliderValue.BackgroundTransparency = 1;
		SliderValue.Text = minimium

		local minvalue = minimium;
		local maxvalue = maximium;

		local Bar = Instance.new("Frame")
		Bar.Parent = SliderBG
		Bar.BackgroundColor3 = Color3.fromRGB(105,108,255)
		Bar.Size = UDim2.new(0.1,0,0,7)
		Bar.AnchorPoint = Vector2.new(0,0.5)
		Bar.Position = UDim2.new(0,0,0.5,0)
		Bar.BorderSizePixel = 0

		local corner = Instance.new("UICorner")
		corner.Parent = Bar;
		corner.CornerRadius = UDim.new(0,4)


		callback  = callback or function() end
		local script = Slider
		local sliderbutton = script
		local sliderframe = Bar
		local slidertext = SliderText

		local mouse = plr:GetMouse()
		local uis = game:GetService("UserInputService")


		SliderValue.Text = default
		callback(default)

		sliderbutton.MouseButton1Down:Connect(function()
			local rel = (mouse.X - SliderBG.AbsolutePosition.X)
			local relpercent = (rel / SliderBG.AbsoluteSize.X)*100
			local realpercent = math.clamp((maxvalue - minvalue)*(relpercent / 100)+minvalue,minvalue,maxvalue)
			SliderValue.Text = tostring(math.round(realpercent))
			Bar:TweenSize(UDim2.new(0,math.clamp(mouse.X - SliderBG.AbsolutePosition.X,0,418),0,7),Enum.EasingDirection.In,Enum.EasingStyle.Linear,0.1,true)
			spawn(function()
				callback(realpercent)
			end)
			local move = mouse.Move:Connect(function()
				local rel = (mouse.X - SliderBG.AbsolutePosition.X)
				local relpercent = (rel / SliderBG.AbsoluteSize.X)*100
				local realpercent = math.clamp((maxvalue - minvalue)*(relpercent / 100)+minvalue,minvalue,maxvalue)
				SliderValue.Text = tostring(math.round(realpercent))
				Bar:TweenSize(UDim2.new(0,math.clamp(mouse.X - SliderBG.AbsolutePosition.X,0,418),0,7),Enum.EasingDirection.In,Enum.EasingStyle.Linear,0.1,true)
				spawn(function()
					callback(realpercent)
				end)
			end)
			uis.InputEnded:Connect(function(key)
				if key.UserInputType == Enum.UserInputType.MouseButton1 then
					move:Disconnect()
				end
			end)
		end)
	end
	function tabFuncs:NewDropdown(name,list,default,callback)
		local Dropdown = Instance.new("TextButton")
		Dropdown.Name = "Dropdown"
		Dropdown.Parent = ScrollingFrame
		Dropdown.Size = UDim2.new(0.95,0,0,50)
		Dropdown.BackgroundColor3 = Color3.fromRGB(25,25,25)
		Dropdown.TextTransparency = 1
		Dropdown.ZIndex = 50
		Dropdown.AutoButtonColor = false

		local DropdownText = Instance.new("TextLabel")
		DropdownText.Parent = Dropdown
		DropdownText.TextColor3 = Color3.fromRGB(105,122,141)
		DropdownText.TextSize = 18;
		DropdownText.BackgroundTransparency = 1;
		DropdownText.Size = UDim2.new(0,228,0,50)
		DropdownText.Position = UDim2.new(0.0313,0,0,0)
		DropdownText.TextXAlignment = Enum.TextXAlignment.Left
		DropdownText.BorderSizePixel = 0;
		DropdownText.Font = Enum.Font.SourceSansSemibold
		DropdownText.Text = name;
		DropdownText.ZIndex = 50


		local UICorner = Instance.new("UICorner")
		UICorner.Parent = Dropdown
		UICorner.CornerRadius = UDim.new(0,8)

		local List = Instance.new('ScrollingFrame')
		List.ScrollingEnabled = true
		List.Name = "List"
		List.Parent = Dropdown;
		List.Size = UDim2.new(0,455,0,115)
		List.BackgroundTransparency = 1;
		List.Position = UDim2.new(-0.031,0,0.58,0)
		List.ZIndex = 50
		List.Visible = false
		List.AutomaticSize = Enum.AutomaticSize.XY
		local vis = false;
        
		Dropdown.MouseButton1Down:Connect(function()
			Dropdown.List.Visible = not Dropdown.List.Visible

			if Dropdown.List.Visible then
				DropdownText.Text = name
				List.BackgroundTransparency = 1;
			end
		end)
		   
		  callback(default)
		  DropdownText.Text = tostring(default)



		local Layout = Instance.new("UIListLayout")
		Layout.Parent = List
		Layout.Padding = UDim.new(0,2)
		Layout.FillDirection = Enum.FillDirection.Vertical

		local Padding = Instance.new("UIPadding")
		Padding.Parent = List
		Padding.PaddingLeft = UDim.new(0,40)
		Padding.PaddingTop = UDim.new(0,32)
		if type(list) == "table" then
			for i,v in next,list do

				local Option = Instance.new("TextButton")
				Option.Parent = List;
				Option.Name = v
				Option.ZIndex = 50
				Option.TextTransparency = 1

				local Corner = Instance.new("UICorner")
				Corner.Parent = Option;
				Corner.CornerRadius = UDim.new(0,8)

				local OptionText = Instance.new("TextLabel")
				Option.ZIndex = 50
				OptionText.Parent = Option
				OptionText.BackgroundTransparency = 1;
				OptionText.Font = Enum.Font.SourceSansSemibold
				OptionText.TextSize = 18
				OptionText.TextColor3 = Color3.fromRGB(105,122,141)
				OptionText.TextTransparency = 0
				OptionText.Position = UDim2.new(0.013, 0,0.5, 0)
				OptionText.TextXAlignment = Enum.TextXAlignment.Left

				OptionText.Text = tostring(v)
				Option.Size = UDim2.new(0.95,0,-0.113,50)
				Option.BackgroundColor3 = Color3.fromRGB(27,27,27)
				Option.AutoButtonColor = false

				local pad = Instance.new("UIPadding",OptionText)
				pad.PaddingLeft = UDim.new(0,100)

				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0,8)
				Option.MouseButton1Down:Connect(function()
					Option.Parent.Visible = false
					DropdownText.Text = OptionText.Text
					List.BackgroundTransparency = 0;
					spawn(function()
						callback(tostring(v))
					end)
				end)
			end
		end
	end
	function tabFuncs:NewDropdown(name,list,default,callback)
		local Dropdown = Instance.new("TextButton")
		Dropdown.Name = "Dropdown"
		Dropdown.Parent = ScrollingFrame
		Dropdown.Size = UDim2.new(0.95,0,0,50)
		Dropdown.BackgroundColor3 = Color3.fromRGB(25,25,25)
		Dropdown.TextTransparency = 1
		Dropdown.ZIndex = 50
		Dropdown.AutoButtonColor = false

		local DropdownText = Instance.new("TextLabel")
		DropdownText.Parent = Dropdown
		DropdownText.TextColor3 = Color3.fromRGB(105,122,141)
		DropdownText.TextSize = 18;
		DropdownText.BackgroundTransparency = 1;
		DropdownText.Size = UDim2.new(0,228,0,50)
		DropdownText.Position = UDim2.new(0.0313,0,0,0)
		DropdownText.TextXAlignment = Enum.TextXAlignment.Left
		DropdownText.BorderSizePixel = 0;
		DropdownText.Font = Enum.Font.SourceSansSemibold
		DropdownText.Text = name;
		DropdownText.ZIndex = 50


		local UICorner = Instance.new("UICorner")
		UICorner.Parent = Dropdown
		UICorner.CornerRadius = UDim.new(0,8)

		local List = Instance.new('ScrollingFrame')
		List.ScrollingEnabled = true
		List.Name = "List"
		List.Parent = Dropdown;
		List.Size = UDim2.new(0,455,0,115)
		List.BackgroundTransparency = 1;
		List.Position = UDim2.new(-0.031,0,0.58,0)
		List.ZIndex = 50
		List.Visible = false
		List.AutomaticSize = Enum.AutomaticSize.XY
		vis = false;

		Dropdown.MouseButton1Down:Connect(function()
			Dropdown.List.Visible = not Dropdown.List.Visible

			if Dropdown.List.Visible then
				DropdownText.Text = name
				List.BackgroundTransparency = 1;
			end
		end)


		local Layout = Instance.new("UIListLayout")
		Layout.Parent = List
		Layout.Padding = UDim.new(0,2)
		Layout.FillDirection = Enum.FillDirection.Vertical

		local Padding = Instance.new("UIPadding")
		Padding.Parent = List
		Padding.PaddingLeft = UDim.new(0,40)
		Padding.PaddingTop = UDim.new(0,32)
		if type(list) == "table" then
			for i,v in next,list do

				local Option = Instance.new("TextButton")
				Option.Parent = List;
				Option.Name = v
				Option.ZIndex = 50
				Option.TextTransparency = 1

				local Corner = Instance.new("UICorner")
				Corner.Parent = Option;
				Corner.CornerRadius = UDim.new(0,8)

				local OptionText = Instance.new("TextLabel")
				Option.ZIndex = 50
				OptionText.Parent = Option
				OptionText.BackgroundTransparency = 1;
				OptionText.Font = Enum.Font.SourceSansSemibold
				OptionText.TextSize = 18
				OptionText.TextColor3 = Color3.fromRGB(105,122,141)
				OptionText.TextTransparency = 0
				OptionText.Position = UDim2.new(0.013, 0,0.5, 0)
				OptionText.TextXAlignment = Enum.TextXAlignment.Left

				OptionText.Text = tostring(v)
				Option.Size = UDim2.new(0.95,0,-0.113,50)
				Option.BackgroundColor3 = Color3.fromRGB(27,27,27)
				Option.AutoButtonColor = false

				local pad = Instance.new("UIPadding",OptionText)
				pad.PaddingLeft = UDim.new(0,100)

				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0,8)
				Option.MouseButton1Down:Connect(function()
					Option.Parent.Visible = false
					DropdownText.Text = OptionText.Text
					List.BackgroundTransparency = 0;
					spawn(function()
						callback(tostring(v))
					end)
				end)
			end
		end
	end
	function tabFuncs:NewTextBox(name,placeholdertext,callback)
	   local TextBox = Instance.new("TextButton")
	   TextBox.Name = "TextBox"
	   TextBox.Parent = ScrollingFrame
	   TextBox.Size = UDim2.new(0.95,0,0,50)
	   TextBox.BackgroundColor3 = Color3.fromRGB(27,27,27)
	   TextBox.TextTransparency = 1;
	   TextBox.AutoButtonColor = false;
	   TextBox.BackgroundTransparency = 1
	   
	   local UICorner = Instance.new('UICorner')
	   UICorner.Parent = TextBox;
	   UICorner.CornerRadius = UDim.new(0,8)
	   
	   local BoxText = Instance.new("TextLabel")
	   BoxText.Text = name
	   BoxText.Name = "BoxText"
	   BoxText.Parent = TextBox;
	   BoxText.Position = UDim2.new(0.0313,0,0,25)
	   BoxText.BackgroundTransparency = 1;
	   BoxText.TextSize = 18;
	   BoxText.TextColor3 = Color3.fromRGB(105,122,141)
	   BoxText.Font = Enum.Font.SourceSansSemibold
	   BoxText.TextXAlignment = Enum.TextXAlignment.Left;
	   local pad = Instance.new("UIPadding",BoxText)
	   pad.PaddingLeft = UDim.new(0,10)
	   
	   local Box = Instance.new("TextBox")
	   Box.Parent = TextBox
	   Box.Size = UDim2.new(0,333,0,50)
	   Box.Position = UDim2.new(0.283,0,0,0)
	   Box.BackgroundColor3 = Color3.fromRGB(24,24,24)
	   Box.TextColor3 = Color3.fromRGB(105,122,141)
	   Box.Font = Enum.Font.SourceSansSemibold
	   Box.BorderSizePixel = 0;
	   Box.TextSize = 16
	   Box.PlaceholderColor3 = Color3.fromRGB(105,100,100)
	   Box.PlaceholderText = placeholdertext
	   Box.Text = ""
	   
	   local corner = Instance.new("UICorner",Box)
	   corner.CornerRadius = UDim.new(0,8)
	   
	   local callback = callback or function() end
	   Box.FocusLost:Connect(function()
	       callback(Box.Text)
        end)
    end
    return tabFuncs
end
return lib
