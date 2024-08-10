local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ContentProvider = game:GetService("ContentProvider")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

ContentProvider:PreloadAsync({"rbxassetid://3570695787", "rbxassetid://2708891598", "rbxassetid://4155801252", "rbxassetid://4695575676", "rbxassetid://4155801252"})

local Library = {
    Theme = {
        MainColor = Color3.fromRGB(255, 75, 75),
        BackgroundColor = Color3.fromRGB(35, 35, 35),
        UIToggleKey = Enum.KeyCode.RightControl,
        TextFont = Enum.Font.SourceSansBold,
        EasingStyle = Enum.EasingStyle.Quart
    },
    LibraryColorTable = {},
    TabCount = 0,
    FirstTab = nil,
    CurrentlyBinding = false,
    RainbowColorValue = 0,
    HueSelectionPosition = 0
}

local function DarkenObjectColor(object, amount)
    local ColorR = (object.r * 255) - amount
    local ColorG = (object.g * 255) - amount
    local ColorB = (object.b * 255) - amount
   
    return Color3.fromRGB(ColorR, ColorG, ColorB)
end

local function SetUIAccent(color)
    for i, v in pairs(Library.LibraryColorTable) do
        if HasProperty(v, "ImageColor3") then
            if v ~= "CheckboxOutline" and v.ImageColor3 ~= Color3.fromRGB(65, 65, 65) then
                v.ImageColor3 = color
            end
        end

        if HasProperty(v, "TextColor3") then
            if v.TextColor3 ~= Color3.fromRGB(255, 255, 255) then
                v.TextColor3 = color
            end
        end
    end
end

local function RippleEffect(object)
    spawn(function()
        local Ripple = Instance.new("ImageLabel")

        Ripple.Name = "Ripple"
        Ripple.Parent = object
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 1.000
        Ripple.ZIndex = 8
        Ripple.Image = "rbxassetid://2708891598"
        Ripple.ImageTransparency = 0.800
        Ripple.ScaleType = Enum.ScaleType.Fit

        Ripple.Position = UDim2.new((Mouse.X - Ripple.AbsolutePosition.X) / object.AbsoluteSize.X, 0, (Mouse.Y - Ripple.AbsolutePosition.Y) / object.AbsoluteSize.Y, 0)
        TweenService:Create(Ripple, TweenInfo.new(1, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Position = UDim2.new(-5.5, 0, -5.5, 0), Size = UDim2.new(12, 0, 12, 0)}):Play()

        wait(0.5)
        TweenService:Create(Ripple, TweenInfo.new(1, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()

        wait(1)
        Ripple:Destroy()
    end)
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
    
    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end
    
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)
    
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local UILibrary = Instance.new("ScreenGui")
local Main = Instance.new("ImageLabel")
local Border = Instance.new("ImageLabel")
local Topbar = Instance.new("Frame")
local UITabs = Instance.new("Frame")
local Tabs = Instance.new("Frame")
local TabButtons = Instance.new("ImageLabel")
local TabButtonLayout = Instance.new("UIListLayout")

UILibrary.Name = HttpService:GenerateGUID(false)
UILibrary.Parent = CoreGui
UILibrary.DisplayOrder = 1
UILibrary.ZIndexBehavior = Enum.ZIndexBehavior.Global

Main.Name = "Main"
Main.Parent = UILibrary
Main.BackgroundColor3 = Library.Theme.BackgroundColor
Main.BackgroundTransparency = 1.000
Main.Position = UDim2.new(0.590086579, 0, 0.563882053, 0)
Main.Size = UDim2.new(0, 450, 0, 0)
Main.ZIndex = 2
Main.Image = "rbxassetid://3570695787"
Main.ImageColor3 = Library.Theme.BackgroundColor
Main.ScaleType = Enum.ScaleType.Slice
Main.SliceCenter = Rect.new(100, 100, 100, 100)
Main.SliceScale = 0.050

Border.Name = "Border"
Border.Parent = Main
Border.BackgroundColor3 = Library.Theme.MainColor
Border.BackgroundTransparency = 1.000
Border.Position = UDim2.new(0, -1, 0, -1)
Border.Size = UDim2.new(1, 2, 1, 2)
Border.Image = "rbxassetid://3570695787"
Border.ImageColor3 = Library.Theme.MainColor
Border.ScaleType = Enum.ScaleType.Slice
Border.SliceCenter = Rect.new(100, 100, 100, 100)
Border.SliceScale = 0.050
Border.ImageTransparency = 1

Topbar.Name = "Topbar"
Topbar.Parent = Main
Topbar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Topbar.BackgroundTransparency = 1.000
Topbar.Size = UDim2.new(0, 450, 0, 15)
Topbar.ZIndex = 2

UITabs.Name = "UITabs"
UITabs.Parent = Main
UITabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
UITabs.BackgroundTransparency = 1.000
UITabs.ClipsDescendants = true
UITabs.Size = UDim2.new(1, 0, 1, 0)

Tabs.Name = "Tabs"
Tabs.Parent = UITabs
Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Tabs.BackgroundTransparency = 1.000
Tabs.Position = UDim2.new(0, 13, 0, 41)
Tabs.Size = UDim2.new(0, 421, 0, 209)
Tabs.ZIndex = 2

TabButtons.Name = "TabButtons"
TabButtons.Parent = UITabs
TabButtons.BackgroundColor3 = Library.Theme.MainColor
TabButtons.BackgroundTransparency = 1.000
TabButtons.Position = UDim2.new(0, 14, 0, 16)
TabButtons.Size = UDim2.new(0, 419, 0, 25)
TabButtons.ZIndex = 2
TabButtons.Image = "rbxassetid://3570695787"
TabButtons.ImageColor3 = Library.Theme.MainColor
TabButtons.ScaleType = Enum.ScaleType.Slice
TabButtons.SliceCenter = Rect.new(100, 100, 100, 100)
TabButtons.SliceScale = 0.050
TabButtons.ClipsDescendants = true

TabButtonLayout.Name = "TabButtonLayout"
TabButtonLayout.Parent = TabButtons
TabButtonLayout.FillDirection = Enum.FillDirection.Horizontal
TabButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder

TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 250)}):Play()
TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()

table.insert(Library.LibraryColorTable, Border)
table.insert(Library.LibraryColorTable, TabButtons)
MakeDraggable(Topbar, Main)

local function CloseAllTabs()
    for i, v in pairs(Tabs:GetChildren()) do
        if v:IsA("Frame") then
            v.Visible = false
        end
    end
end

local function ResetAllTabButtons()
    for i, v in pairs(TabButtons:GetChildren()) do
        if v:IsA("ImageButton") then
            TweenService:Create(v, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
        end
    end
end

local function KeepFirstTabOpen()
    for i, v in pairs(Tabs:GetChildren()) do
        if v:IsA("Frame") then
            if v.Name == (Library.FirstTab .. "Tab") then
                v.Visible = true
            else
                v.Visible = false
            end
        end
    end

    for i, v in pairs(TabButtons:GetChildren()) do
        if v:IsA("ImageButton") then
            if v.Name:find(Library.FirstTab .. "TabButton") then
                TweenService:Create(v, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 15)}):Play()
            else
                TweenService:Create(v, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
            end
        end
    end
end

local function ToggleUI()
    Library.UIOpen = not Library.UIOpen
            
    if Library.UIOpen then
        TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 0)}):Play()
        TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
    elseif not Library.UIOpen then
        TweenService:Create(Main, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 250)}):Play()
        TweenService:Create(Border, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
    end
end

coroutine.wrap(function()
    while wait() do
        Library.RainbowColorValue = Library.RainbowColorValue + 1/255
        Library.HueSelectionPosition = Library.HueSelectionPosition + 1

        if Library.RainbowColorValue >= 1 then
            Library.RainbowColorValue = 0
        end

        if Library.HueSelectionPosition == 105 then
            Library.HueSelectionPosition = 0
        end
    end
end)()


function Library:CreateTab(name)
    local NameTab = Instance.new("Frame")
    local NameTabButton = Instance.new("ImageButton")
    local Title = Instance.new("TextLabel")
    local SectionLayout = Instance.new("UIListLayout")
    local SectionPadding = Instance.new("UIPadding")
    
    local TabElements = {}
    Library.TabCount = Library.TabCount + 1

    if Library.TabCount == 1 then
        Library.FirstTab = name
    end

    NameTab.Name = (name .. "Tab")
    NameTab.Parent = Tabs
    NameTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTab.BackgroundTransparency = 1.000
    NameTab.Size = UDim2.new(1, 0, 1, 0)
    NameTab.ZIndex = 2

    NameTabButton.Name = (name .. "TabButton")
    NameTabButton.Parent = TabButtons
    NameTabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameTabButton.BackgroundTransparency = 1.000
    NameTabButton.Size = UDim2.new(0, 84, 0, 25)
    NameTabButton.ZIndex = 2
    NameTabButton.Image = "rbxassetid://3570695787"
    NameTabButton.ImageColor3 = Library.Theme.MainColor
    NameTabButton.ScaleType = Enum.ScaleType.Slice
    NameTabButton.SliceCenter = Rect.new(100, 100, 100, 100)
    NameTabButton.SliceScale = 0.050
    
    Title.Name = "Title"
    Title.Parent = NameTabButton
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.ZIndex = 2
    Title.Font = Library.Theme.TextFont
    Title.Text =  name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 15.000

    SectionLayout.Name = "SectionLayout"
    SectionLayout.Parent = NameTab
    SectionLayout.FillDirection = Enum.FillDirection.Horizontal
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 25)

    SectionPadding.Name = "SectionPadding"
    SectionPadding.Parent = NameTab
    SectionPadding.PaddingTop = UDim.new(0, 12)

    NameTab.Visible = true

    table.insert(Library.LibraryColorTable, NameTabButton)
    CloseAllTabs()
    ResetAllTabButtons()
    TweenService:Create(NameTabButton, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 15)}):Play()

    KeepFirstTabOpen()

    NameTabButton.MouseButton1Down:Connect(function()
        CloseAllTabs()
        ResetAllTabButtons()

        NameTab.Visible = true
        TweenService:Create(NameTabButton, TweenInfo.new(0.3, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 15)}):Play()
    end)

    function TabElements:CreateSection(name)
        local NameSection = Instance.new("ImageLabel")
        local SectionBorder = Instance.new("ImageLabel")
        local SectionTitle = Instance.new("TextLabel")
        local SectionContent = Instance.new("ScrollingFrame")
        local SectionContentLayout = Instance.new("UIListLayout")

        local SectionElements = {}

        NameSection.Name = (name .. "Section")
        NameSection.Parent = NameTab
        NameSection.BackgroundColor3 = Library.Theme.MainColor
        NameSection.BackgroundTransparency = 1.000
        NameSection.Position = UDim2.new(0, 0, 0.0574162677, 0)
        NameSection.Size = UDim2.new(0, 197, 0, 181)
        NameSection.ZIndex = 4
        NameSection.Image = "rbxassetid://3570695787"
        NameSection.ImageColor3 = Library.Theme.BackgroundColor
        NameSection.ScaleType = Enum.ScaleType.Slice
        NameSection.SliceCenter = Rect.new(100, 100, 100, 100)
        NameSection.SliceScale = 0.050
        
        SectionBorder.Name = "SectionBorder"
        SectionBorder.Parent = NameSection
        SectionBorder.BackgroundColor3 = Library.Theme.MainColor
        SectionBorder.BackgroundTransparency = 1.000
        SectionBorder.Position = UDim2.new(0, -1, 0, -1)
        SectionBorder.Size = UDim2.new(1, 2, 1, 2)
        SectionBorder.ZIndex = 3
        SectionBorder.Image = "rbxassetid://3570695787"
        SectionBorder.ImageColor3 = Library.Theme.MainColor
        SectionBorder.ScaleType = Enum.ScaleType.Slice
        SectionBorder.SliceCenter = Rect.new(100, 100, 100, 100)
        SectionBorder.SliceScale = 0.050
        
        SectionTitle.Name = "SectionTitle"
        SectionTitle.Parent = NameSection
        SectionTitle.BackgroundColor3 = Library.Theme.BackgroundColor
        SectionTitle.BorderSizePixel = 0
        SectionTitle.Text = name
        SectionTitle.Position = UDim2.new(0.5, (-SectionTitle.TextBounds.X - 5) / 2, 0, -12)
        SectionTitle.Size = UDim2.new(0, SectionTitle.TextBounds.X + 5, 0, 22)
        SectionTitle.ZIndex = 4
        SectionTitle.Font = Library.Theme.TextFont
        SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        SectionTitle.TextSize = 14.000
        
        SectionContent.Name = "SectionContent"
        SectionContent.Parent = NameSection
        SectionContent.Active = true
        SectionContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SectionContent.BackgroundTransparency = 1.000
        SectionContent.BorderColor3 = Color3.fromRGB(27, 42, 53)
        SectionContent.BorderSizePixel = 0
        SectionContent.Size = UDim2.new(1, 0, 1, 0)
        SectionContent.ZIndex = 4
        SectionContent.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        SectionContent.ScrollBarImageColor3 = Color3.fromRGB(85, 85, 85)
        SectionContent.ScrollBarThickness = 4
        SectionContent.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

        SectionContentLayout.Name = "SectionContentLayout"
        SectionContentLayout.Parent = SectionContent
        SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

        table.insert(Library.LibraryColorTable, SectionBorder)

        SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionContent.CanvasSize = UDim2.new(0, 0, 0, SectionContentLayout.AbsoluteContentSize.Y + 15)
        end)

        function SectionElements:CreateLabel(name, text)
            local NameLabel = Instance.new("TextLabel")

            NameLabel.Name = (name .. "Label")
            NameLabel.Parent = SectionContent
            NameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.BackgroundTransparency = 1.000
            NameLabel.Text = text
            NameLabel.Size = UDim2.new(0, 197, 0, NameLabel.TextBounds.Y)
            NameLabel.ZIndex = 5
            NameLabel.Font = Library.Theme.TextFont
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 15.000

            local function ChangeText(newtext)
                NameLabel.Text = newtext
            end

            NameLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
                if NameLabel.Text ~= "" then
                    TweenService:Create(NameLabel, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, NameLabel.TextBounds.Y)}):Play()
                else
                    TweenService:Create(NameLabel, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 0)}):Play()
                end
            end)

            return {
                ChangeText = ChangeText
            }
        end

        function SectionElements:CreateButton(name, callback)
            local NameButton = Instance.new("Frame")
            local Button = Instance.new("TextButton")
            local ButtonRounded = Instance.new("ImageLabel")

            NameButton.Name = (name .. "Button")
            NameButton.Parent = SectionContent
            NameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameButton.BackgroundTransparency = 1.000
            NameButton.Size = UDim2.new(0, 197, 0, 35)
            NameButton.ZIndex = 5

            Button.Name = "Button"
            Button.Parent = NameButton
            Button.BackgroundColor3 = Library.Theme.MainColor
            Button.BackgroundTransparency = 1.000
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0.454314709, -76, 0.528571427, -12)
            Button.Size = UDim2.new(0, 168, 0, 25)
            Button.ZIndex = 6
            Button.Font = Library.Theme.TextFont
            Button.Text = name
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 15.000
            Button.ClipsDescendants = true

            ButtonRounded.Name = "ButtonRounded"
            ButtonRounded.Parent = Button
            ButtonRounded.Active = true
            ButtonRounded.AnchorPoint = Vector2.new(0.5, 0.5)
            ButtonRounded.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonRounded.BackgroundTransparency = 1.000
            ButtonRounded.Position = UDim2.new(0.5, 0, 0.5, 0)
            ButtonRounded.Selectable = true
            ButtonRounded.Size = UDim2.new(1, 0, 1, 0)
            ButtonRounded.ZIndex = 5
            ButtonRounded.Image = "rbxassetid://3570695787"
            ButtonRounded.ImageColor3 = Library.Theme.MainColor
            ButtonRounded.ScaleType = Enum.ScaleType.Slice
            ButtonRounded.SliceCenter = Rect.new(100, 100, 100, 100)
            ButtonRounded.SliceScale = 0.050

            Button.MouseButton1Down:Connect(function()
                TweenService:Create(ButtonRounded, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = DarkenObjectColor(Library.Theme.MainColor, 20)}):Play()

                RippleEffect(Button)
                callback(Button)
            end)

            Button.MouseButton1Up:Connect(function()
                TweenService:Create(ButtonRounded, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
            end)

            Button.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    TweenService:Create(ButtonRounded, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageColor3 = Library.Theme.MainColor}):Play()
                end
            end)

            table.insert(Library.LibraryColorTable, ButtonRounded)
        end

        function SectionElements:CreateToggle(name, callback)
            local NameToggle = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Toggle = Instance.new("TextButton")
            local CheckboxOutline = Instance.new("ImageLabel")
            local CheckboxTicked = Instance.new("ImageLabel")
            local TickCover = Instance.new("Frame")

            local Toggled = false

            NameToggle.Name = (name .. "Toggle")
            NameToggle.Parent = SectionContent
            NameToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameToggle.BackgroundTransparency = 1.000
            NameToggle.Size = UDim2.new(0, 197, 0, 35)
            NameToggle.ZIndex = 5
            
            Title.Name = "Title"
            Title.Parent = NameToggle
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 13, 0, 0)
            Title.Size = UDim2.new(0, 149, 0, 35)
            Title.ZIndex = 5
            Title.Font = Library.Theme.TextFont
            Title.Text = name
            Title.TextColor3 = Color3.fromRGB(185, 185, 185)
            Title.TextSize = 15.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            Toggle.Name = "Toggle"
            Toggle.Parent = NameToggle
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.BackgroundTransparency = 1.000
            Toggle.Position = UDim2.new(0, 161, 0, 7)
            Toggle.Size = UDim2.new(0, 20, 0, 20)
            Toggle.ZIndex = 5
            Toggle.AutoButtonColor = false
            Toggle.Font = Library.Theme.TextFont
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.TextSize = 14.000

            CheckboxOutline.Name = "CheckboxOutline"
            CheckboxOutline.Parent = Toggle
            CheckboxOutline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxOutline.BackgroundTransparency = 1.000
            CheckboxOutline.Position = UDim2.new(0.5, -12, 0.5, -12)
            CheckboxOutline.Size = UDim2.new(0, 24, 0, 24)
            CheckboxOutline.ZIndex = 5
            CheckboxOutline.Image = "http://www.roblox.com/asset/?id=5416796047"
            CheckboxOutline.ImageColor3 = Color3.fromRGB(65, 65, 65)

            CheckboxTicked.Name = "CheckboxTicked"
            CheckboxTicked.Parent = Toggle
            CheckboxTicked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxTicked.BackgroundTransparency = 1.000
            CheckboxTicked.Position = UDim2.new(0.5, -12, 0.5, -12)
            CheckboxTicked.Size = UDim2.new(0, 24, 0, 24)
            CheckboxTicked.ZIndex = 5
            CheckboxTicked.Image = "http://www.roblox.com/asset/?id=5416796675"
            CheckboxTicked.ImageColor3 = Color3.fromRGB(65, 65, 65)

            TickCover.Name = "TickCover"
            TickCover.Parent = Toggle
            TickCover.BackgroundColor3 = Library.Theme.BackgroundColor
            TickCover.BorderSizePixel = 0
            TickCover.Position = UDim2.new(0.5, -7, 0.5, -7)
            TickCover.Size = UDim2.new(0, 14, 0, 14)
            TickCover.ZIndex = 5

            local function SetState(state)
                if state then
                    TweenService:Create(Title, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    TweenService:Create(TickCover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0)}):Play()
                    TweenService:Create(CheckboxOutline, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Library.Theme.MainColor}):Play()
                    TweenService:Create(CheckboxTicked, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Library.Theme.MainColor}):Play()
                elseif not state then
                    TweenService:Create(Title, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(185, 185, 185)}):Play()
                    TweenService:Create(TickCover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -7, 0.5, -7), Size = UDim2.new(0, 14, 0, 14)}):Play()
                    TweenService:Create(CheckboxOutline, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Color3.fromRGB(65, 65, 65)}):Play()
                    TweenService:Create(CheckboxTicked, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Color3.fromRGB(65, 65, 65)}):Play()
				end
				
                callback(Toggled)
			end
			
			Toggle.MouseButton1Down:Connect(function()
                Toggled = not Toggled
				SetState(Toggled)
            end)

            table.insert(Library.LibraryColorTable, CheckboxOutline)
            table.insert(Library.LibraryColorTable, CheckboxTicked)

            return {
                SetState = SetState
            }
        end

        function SectionElements:CreateSlider(name, minimumvalue, maximumvalue, presetvalue, precisevalue, callback)
            local NameSlider = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local SliderBackground = Instance.new("ImageLabel")
            local SliderIndicator = Instance.new("ImageLabel")
            local CircleSelector = Instance.new("ImageLabel")
            local SliderValue = Instance.new("ImageLabel")
            local Value = Instance.new("TextBox")

            local SliderDragging = false
            local StartingValue = presetvalue
    
            if StartingValue == nil then
                StartingValue = presetvalue
            end

            NameSlider.Name = (name .. "Slider")
            NameSlider.Parent = SectionContent
            NameSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameSlider.BackgroundTransparency = 1.000
            NameSlider.Position = UDim2.new(0, 0, 0.497237563, 0)
            NameSlider.Size = UDim2.new(0, 197, 0, 50)
            NameSlider.ZIndex = 5
            
            Title.Name = "Title"
            Title.Parent = NameSlider
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.BorderColor3 = Color3.fromRGB(27, 42, 53)
            Title.Position = UDim2.new(0, 12, 0, 0)
            Title.Size = UDim2.new(0, 121, 0, 35)
            Title.ZIndex = 5
            Title.Font = Library.Theme.TextFont
            Title.Text = name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            SliderBackground.Name = "SliderBackground"
            SliderBackground.Parent = NameSlider
            SliderBackground.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            SliderBackground.BackgroundTransparency = 1.000
            SliderBackground.Position = UDim2.new(0.0600000359, 0, 0.699999988, 0)
            SliderBackground.Size = UDim2.new(0, 169, 0, 4)
            SliderBackground.ZIndex = 5
            SliderBackground.Image = "rbxassetid://3570695787"
            SliderBackground.ImageColor3 = Color3.fromRGB(55, 55, 55)
            SliderBackground.ScaleType = Enum.ScaleType.Slice
            SliderBackground.SliceCenter = Rect.new(100, 100, 100, 100)
            SliderBackground.SliceScale = 0.150
            
            SliderIndicator.Name = "SliderIndicator"
            SliderIndicator.Parent = SliderBackground
            SliderIndicator.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            SliderIndicator.BackgroundTransparency = 1.000
            SliderIndicator.Size = UDim2.new(((StartingValue or minimumvalue) - minimumvalue) / (maximumvalue - minimumvalue), 0, 1, 0)
            SliderIndicator.ZIndex = 5
            SliderIndicator.Image = "rbxassetid://3570695787"
            SliderIndicator.ImageColor3 = Library.Theme.MainColor
            SliderIndicator.ScaleType = Enum.ScaleType.Slice
            SliderIndicator.SliceCenter = Rect.new(100, 100, 100, 100)
            SliderIndicator.SliceScale = 0.150
            
            CircleSelector.Name = "CircleSelector"
            CircleSelector.Parent = SliderIndicator
            CircleSelector.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CircleSelector.BackgroundTransparency = 1.000
            CircleSelector.Position = UDim2.new(0.986565471, -7, 0.75, -7)
            CircleSelector.Size = UDim2.new(0, 12, 0, 12)
            CircleSelector.ZIndex = 5
            CircleSelector.Image = "rbxassetid://3570695787"
            
            SliderValue.Name = "SliderValue"
            SliderValue.Parent = NameSlider
            SliderValue.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            SliderValue.BackgroundTransparency = 1.000
            SliderValue.Position = UDim2.new(0.764771521, -12, 0.400000006, -12)
            SliderValue.Size = UDim2.new(0, 42, 0, 19)
            SliderValue.ZIndex = 5
            SliderValue.Image = "rbxassetid://3570695787"
            SliderValue.ImageColor3 = Color3.fromRGB(65, 65, 65)
            SliderValue.ScaleType = Enum.ScaleType.Slice
            SliderValue.SliceCenter = Rect.new(100, 100, 100, 100)
            SliderValue.SliceScale = 0.030
            
            Value.Name = "Value"
            Value.Parent = SliderValue
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1.000
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.ZIndex = 5
            Value.Font = Library.Theme.TextFont
            Value.Text = tostring(StartingValue or precisevalue and tonumber(string.format("%.2f", StartingValue)))
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 14.000

            local function Sliding(input)
                local SliderPosition = UDim2.new(math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1), 0, 1, 0)
                TweenService:Create(SliderIndicator, TweenInfo.new(0.02, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = SliderPosition}):Play()
    
                local NonSliderPreciseValue = math.floor(((SliderPosition.X.Scale * maximumvalue) / maximumvalue) * (maximumvalue - minimumvalue) + minimumvalue)
                local SliderPreciseValue = ((SliderPosition.X.Scale * maximumvalue) / maximumvalue) * (maximumvalue - minimumvalue) + minimumvalue
    
                local SlidingValue = (precisevalue and SliderPreciseValue or NonSliderPreciseValue)
                SlidingValue = tonumber(string.format("%.2f", SlidingValue))
    
                Value.Text = tostring(SlidingValue)
                callback(SlidingValue)
            end
    
            Value.FocusLost:Connect(function()
                if not tonumber(Value.Text) then
                    Value.Text = tostring(StartingValue or precisevalue and tonumber(string.format("%.2f", StartingValue)))
                elseif Value.Text == "" or tonumber(Value.Text) <= minimumvalue then
                    Value.Text = minimumvalue
                elseif Value.Text == "" or tonumber(Value.Text) >= maximumvalue then
                    Value.Text = maximumvalue
                end
    
                TweenService:Create(SliderIndicator, TweenInfo.new(0.02, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(((tonumber(Value.Text) or minimumvalue) - minimumvalue) / (maximumvalue - minimumvalue), 0, 1, 0)}):Play()
                callback(tonumber(Value.Text))
            end)
    
            CircleSelector.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SliderDragging = true
                end
            end)
            
            CircleSelector.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SliderDragging = false
                end
            end)
            
            CircleSelector.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Sliding(input)
                end
            end)
        
            UserInputService.InputChanged:Connect(function(input)
                if SliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Sliding(input)
                end
            end)

            local function SetSliderValue(value)
                Value.Text = value
                TweenService:Create(SliderIndicator, TweenInfo.new(0.02, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(((tonumber(Value.Text) or minimumvalue) - minimumvalue) / (maximumvalue - minimumvalue), 0, 1, 0)}):Play()
                callback(tonumber(Value.Text))
            end

            callback(StartingValue)
            table.insert(Library.LibraryColorTable, SliderIndicator)

            return {
                SetSliderValue = SetSliderValue
            }
        end

        function SectionElements:CreateColorPicker(name, presetcolor, callback)
            local NameColorPicker = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local ColorPickerToggle = Instance.new("ImageButton")
            local ColorPicker = Instance.new("ImageLabel")
            local Color = Instance.new("ImageLabel")
            local ColorRound = Instance.new("ImageLabel")
            local ColorSelection = Instance.new("ImageLabel")
            local RValue = Instance.new("ImageLabel")
            local ValueR = Instance.new("TextLabel")
            local GValue = Instance.new("ImageLabel")
            local ValueG = Instance.new("TextLabel")
            local BValue = Instance.new("ImageLabel")
            local ValueB = Instance.new("TextLabel")
            local RainbowToggle = Instance.new("Frame")
            local RainbowToggleTitle = Instance.new("TextLabel")
            local Toggle = Instance.new("TextButton")
            local CheckboxOutline = Instance.new("ImageLabel")
            local CheckboxTicked = Instance.new("ImageLabel")
            local TickCover = Instance.new("Frame")
            local Hue = Instance.new("ImageLabel")
            local UIGradient = Instance.new("UIGradient")
            local HueSelection = Instance.new("ImageLabel")
            
            local ColorPickerToggled = false
            local OldToggleColor = Color3.fromRGB(0, 0, 0)
            local OldColor = Color3.fromRGB(0, 0, 0)
            local OldColorSelectionPosition = nil
            local OldHueSelectionPosition = nil
            local ColorH, ColorS, ColorV = 1, 1, 1
            local RainbowColorPicker = false
            local ColorPickerInput = nil
            local ColorInput = nil
            local HueInput = nil

            NameColorPicker.Name = (name .. "ColorPicker")
            NameColorPicker.Parent = SectionContent
            NameColorPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameColorPicker.BackgroundTransparency = 1.000
            NameColorPicker.Position = UDim2.new(0, 0, 0.138121545, 0)
            NameColorPicker.Size = UDim2.new(0, 197, 0, 32)
            NameColorPicker.ClipsDescendants = true

            Title.Name = "Title"
            Title.Parent = NameColorPicker
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 13, 0, 0)
            Title.Size = UDim2.new(0, 151, 0, 30)
            Title.ZIndex = 5
            Title.Font = Library.Theme.TextFont
            Title.Text = name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15.000
            Title.TextXAlignment = Enum.TextXAlignment.Left
            
            ColorPickerToggle.Name = "ColorPickerToggle"
            ColorPickerToggle.Parent = NameColorPicker
            ColorPickerToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorPickerToggle.BackgroundTransparency = 1.000
            ColorPickerToggle.Position = UDim2.new(0, 139, 0, 5)
            ColorPickerToggle.Size = UDim2.new(0, 42, 0, 20)
            ColorPickerToggle.ZIndex = 5
            ColorPickerToggle.Image = "rbxassetid://3570695787"
            ColorPickerToggle.ImageColor3 = presetcolor
            ColorPickerToggle.ScaleType = Enum.ScaleType.Slice
            ColorPickerToggle.SliceCenter = Rect.new(100, 100, 100, 100)
            ColorPickerToggle.SliceScale = 0.030
            
            ColorPicker.Name = "ColorPicker"
            ColorPicker.Parent = NameColorPicker
            ColorPicker.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ColorPicker.BackgroundTransparency = 1.000
            ColorPicker.ClipsDescendants = true
            ColorPicker.Position = UDim2.new(0.0599999987, 0, 0, 30)
            ColorPicker.Size = UDim2.new(0, 169, 0, 175)
            ColorPicker.ZIndex = 10
            ColorPicker.Image = "rbxassetid://3570695787"
            ColorPicker.ImageColor3 = Color3.fromRGB(45, 45, 45)
            ColorPicker.ScaleType = Enum.ScaleType.Slice
            ColorPicker.SliceCenter = Rect.new(100, 100, 100, 100)
            ColorPicker.SliceScale = 0.070
            ColorPicker.ImageTransparency = 1

            Color.Name = "Color"
            Color.Parent = ColorPicker
            Color.BackgroundColor3 = presetcolor
            Color.BorderSizePixel = 0
            Color.Position = UDim2.new(0, 9, 0, 10)
            Color.Size = UDim2.new(0, 124, 0, 105)
            Color.ZIndex = 10
            Color.Image = "rbxassetid://4155801252"
            
            ColorRound.Name = "ColorRound"
            ColorRound.Parent = Color
            ColorRound.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorRound.BackgroundTransparency = 1.000
            ColorRound.ClipsDescendants = true
            ColorRound.Size = UDim2.new(1, 0, 1, 0)
            ColorRound.ZIndex = 10
            ColorRound.Image = "rbxassetid://4695575676"
            ColorRound.ImageColor3 = Color3.fromRGB(45, 45, 45)
            ColorRound.ScaleType = Enum.ScaleType.Slice
            ColorRound.SliceCenter = Rect.new(128, 128, 128, 128)
            ColorRound.SliceScale = 0.050
    
            ColorSelection.Name = "ColorSelection"
            ColorSelection.Parent = Color
            ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            ColorSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ColorSelection.BackgroundTransparency = 1.000
            ColorSelection.Position = UDim2.new(presetcolor and select(3, Color3.toHSV(presetcolor)))
            ColorSelection.Size = UDim2.new(0, 18, 0, 18)
            ColorSelection.ZIndex = 25
            ColorSelection.Image = "rbxassetid://4953646208"
            ColorSelection.ScaleType = Enum.ScaleType.Fit
            
            RValue.Name = "RValue"
            RValue.Parent = ColorPicker
            RValue.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            RValue.BackgroundTransparency = 1.000
            RValue.Position = UDim2.new(0, 10, 0, 123)
            RValue.Size = UDim2.new(0, 42, 0, 19)
            RValue.ZIndex = 10
            RValue.Image = "rbxassetid://3570695787"
            RValue.ImageColor3 = Color3.fromRGB(65, 65, 65)
            RValue.ScaleType = Enum.ScaleType.Slice
            RValue.SliceCenter = Rect.new(100, 100, 100, 100)
            RValue.SliceScale = 0.030
            
            ValueR.Name = "ValueR"
            ValueR.Parent = RValue
            ValueR.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ValueR.BackgroundTransparency = 1.000
            ValueR.Size = UDim2.new(1, 0, 1, 0)
            ValueR.ZIndex = 11
            ValueR.Font = Library.Theme.TextFont
            ValueR.Text = "R: 255"
            ValueR.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueR.TextSize = 14.000
            
            GValue.Name = "GValue"
            GValue.Parent = ColorPicker
            GValue.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            GValue.BackgroundTransparency = 1.000
            GValue.Position = UDim2.new(0, 64, 0, 123)
            GValue.Size = UDim2.new(0, 42, 0, 19)
            GValue.ZIndex = 10
            GValue.Image = "rbxassetid://3570695787"
            GValue.ImageColor3 = Color3.fromRGB(65, 65, 65)
            GValue.ScaleType = Enum.ScaleType.Slice
            GValue.SliceCenter = Rect.new(100, 100, 100, 100)
            GValue.SliceScale = 0.030
            
            ValueG.Name = "ValueG"
            ValueG.Parent = GValue
            ValueG.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ValueG.BackgroundTransparency = 1.000
            ValueG.Size = UDim2.new(1, 0, 1, 0)
            ValueG.ZIndex = 11
            ValueG.Font = Library.Theme.TextFont
            ValueG.Text = "G: 255"
            ValueG.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueG.TextSize = 14.000
            
            BValue.Name = "BValue"
            BValue.Parent = ColorPicker
            BValue.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            BValue.BackgroundTransparency = 1.000
            BValue.Position = UDim2.new(0, 119, 0, 123)
            BValue.Size = UDim2.new(0, 42, 0, 19)
            BValue.ZIndex = 10
            BValue.Image = "rbxassetid://3570695787"
            BValue.ImageColor3 = Color3.fromRGB(65, 65, 65)
            BValue.ScaleType = Enum.ScaleType.Slice
            BValue.SliceCenter = Rect.new(100, 100, 100, 100)
            BValue.SliceScale = 0.030
            
            ValueB.Name = "ValueB"
            ValueB.Parent = BValue
            ValueB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ValueB.BackgroundTransparency = 1.000
            ValueB.Size = UDim2.new(1, 0, 1, 0)
            ValueB.ZIndex = 11
            ValueB.Font = Library.Theme.TextFont
            ValueB.Text = "B: 255"
            ValueB.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValueB.TextSize = 14.000
            
            RainbowToggle.Name = "RainbowToggle"
            RainbowToggle.Parent = ColorPicker
            RainbowToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            RainbowToggle.BackgroundTransparency = 1.000
            RainbowToggle.Position = UDim2.new(0, 10, 0, 143)
            RainbowToggle.Size = UDim2.new(0, 160, 0, 35)
            RainbowToggle.ZIndex = 10
            
            RainbowToggleTitle.Name = "RainbowToggleTitle"
            RainbowToggleTitle.Parent = RainbowToggle
            RainbowToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            RainbowToggleTitle.BackgroundTransparency = 1.000
            RainbowToggleTitle.Size = UDim2.new(0, 124, 0, 30)
            RainbowToggleTitle.ZIndex = 10
            RainbowToggleTitle.Font = Library.Theme.TextFont
            RainbowToggleTitle.Text = "Rainbow"
            RainbowToggleTitle.TextColor3 = Color3.fromRGB(185, 185, 185)
            RainbowToggleTitle.TextSize = 15
            RainbowToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            Toggle.Name = "Toggle"
            Toggle.Parent = RainbowToggle
            Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.BackgroundTransparency = 1.000
            Toggle.Position = UDim2.new(0, 131, 0, 5)
            Toggle.Size = UDim2.new(0, 20, 0, 20)
            Toggle.ZIndex = 10
            Toggle.AutoButtonColor = false
            Toggle.Font = Library.Theme.TextFont
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle.TextSize = 14.000
            
            CheckboxOutline.Name = "CheckboxOutline"
            CheckboxOutline.Parent = Toggle
            CheckboxOutline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxOutline.BackgroundTransparency = 1.000
            CheckboxOutline.Position = UDim2.new(0.5, -12, 0.5, -12)
            CheckboxOutline.Size = UDim2.new(0, 24, 0, 24)
            CheckboxOutline.ZIndex = 10
            CheckboxOutline.Image = "http://www.roblox.com/asset/?id=5416796047"
            CheckboxOutline.ImageColor3 = Color3.fromRGB(65, 65, 65)
            
            CheckboxTicked.Name = "CheckboxTicked"
            CheckboxTicked.Parent = Toggle
            CheckboxTicked.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            CheckboxTicked.BackgroundTransparency = 1.000
            CheckboxTicked.Position = UDim2.new(0.5, -12, 0.5, -12)
            CheckboxTicked.Size = UDim2.new(0, 24, 0, 24)
            CheckboxTicked.ZIndex = 10
            CheckboxTicked.Image = "http://www.roblox.com/asset/?id=5416796675"
            CheckboxTicked.ImageColor3 = Color3.fromRGB(65, 65, 65)

            TickCover.Name = "TickCover"
            TickCover.Parent = Toggle
            TickCover.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            TickCover.BorderSizePixel = 0
            TickCover.Position = UDim2.new(0.5, -7, 0.5, -7)
            TickCover.Size = UDim2.new(0, 14, 0, 14)
            TickCover.ZIndex = 10
            
            Hue.Name = "Hue"
            Hue.Parent = ColorPicker
            Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Hue.BackgroundTransparency = 1.000
            Hue.Position = UDim2.new(0, 136, 0, 10)
            Hue.Size = UDim2.new(0, 25, 0, 105)
            Hue.ZIndex = 10
            Hue.Image = "rbxassetid://3570695787"
            Hue.ScaleType = Enum.ScaleType.Slice
            Hue.SliceCenter = Rect.new(100, 100, 100, 100)
            Hue.SliceScale = 0.050

            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
            UIGradient.Rotation = 270
            UIGradient.Parent = Hue
            
            HueSelection.Name = "HueSelection"
            HueSelection.Parent = Hue
            HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
            HueSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSelection.BackgroundTransparency = 1.000
            HueSelection.Position = UDim2.new(0.48, 0, 1 - select(1, Color3.toHSV(presetcolor)))
            HueSelection.Size = UDim2.new(0, 18, 0, 18)
            HueSelection.ZIndex = 10
            HueSelection.Image = "rbxassetid://4953646208"
            HueSelection.ScaleType = Enum.ScaleType.Fit

            local function SetRGBValues()
                ValueR.Text = ("R: " .. math.floor(ColorPickerToggle.ImageColor3.r * 255))
                ValueG.Text = ("G: " .. math.floor(ColorPickerToggle.ImageColor3.g * 255))
                ValueB.Text = ("B: " .. math.floor(ColorPickerToggle.ImageColor3.b * 255))
            end
    
            local function UpdateColorPicker(nope)
                ColorPickerToggle.ImageColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
                Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
    
                SetRGBValues()
                callback(ColorPickerToggle.ImageColor3)
            end
    
            ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
            ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
            ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
    
            ColorPickerToggle.ImageColor3 = presetcolor
            Color.BackgroundColor3 = presetcolor
            SetRGBValues()
            callback(Color.BackgroundColor3)
    
            Color.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if RainbowColorPicker then return end
    
                    if ColorInput then
                        ColorInput:Disconnect()
                    end
                    
                    ColorInput = RunService.RenderStepped:Connect(function()
                        local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                        local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
    
                        ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                        ColorS = ColorX
                        ColorV = 1 - ColorY
    
                        UpdateColorPicker(true)
                    end)
                end
            end)
    
            Color.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if ColorInput then
                        ColorInput:Disconnect()
                    end
                end
            end)
    
            Hue.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if RainbowColorPicker then return end
    
                    if HueInput then
                        HueInput:Disconnect()
                    end
                    
                    HueInput = RunService.RenderStepped:Connect(function()
                        local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
    
                        HueSelection.Position = UDim2.new(0.48, 0, HueY, 0)
                        ColorH = 1 - HueY
    
                        UpdateColorPicker(true)
                    end)
                end
            end)
    
            Hue.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if HueInput then
                        HueInput:Disconnect()
                    end
                end
            end)
    
            Toggle.MouseButton1Down:Connect(function()
                RainbowColorPicker = not RainbowColorPicker
            
                if ColorInput then
                    ColorInput:Disconnect()
                end
    
                if HueInput then
                    HueInput:Disconnect()
                end
    
                if RainbowColorPicker then              
                    TweenService:Create(RainbowToggleTitle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    TweenService:Create(TickCover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0)}):Play()
                    TweenService:Create(CheckboxOutline, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Library.Theme.MainColor}):Play()
                    TweenService:Create(CheckboxTicked, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Library.Theme.MainColor}):Play()
    
                    OldToggleColor = ColorPickerToggle.ImageColor3
                    OldColor = Color.BackgroundColor3
                    OldColorSelectionPosition = ColorSelection.Position
                    OldHueSelectionPosition = HueSelection.Position
    
                    while RainbowColorPicker do
                        ColorPickerToggle.ImageColor3 = Color3.fromHSV(Library.RainbowColorValue, 1, 1)
                        Color.BackgroundColor3 = Color3.fromHSV(Library.RainbowColorValue, 1, 1)
            
                        ColorSelection.Position = UDim2.new(1, 0, 0, 0)
                        HueSelection.Position = UDim2.new(0.48, 0, 0, Library.HueSelectionPosition)
            
                        SetRGBValues()
                        callback(Color.BackgroundColor3)
                        wait()
                    end
                elseif not RainbowColorPicker then
                    ColorPickerToggle.ImageColor3 = OldToggleColor
                    Color.BackgroundColor3 = OldColor
    
                    ColorSelection.Position = OldColorSelectionPosition
                    HueSelection.Position = OldHueSelectionPosition
    
                    SetRGBValues()
                    callback(ColorPickerToggle.ImageColor3)

                    TweenService:Create(RainbowToggleTitle, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(185, 185, 185)}):Play()
                    TweenService:Create(TickCover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -7, 0.5, -7), Size = UDim2.new(0, 14, 0, 14)}):Play()
                    TweenService:Create(CheckboxOutline, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Color3.fromRGB(65, 65, 65)}):Play()
                    TweenService:Create(CheckboxTicked, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageColor3 = Color3.fromRGB(65, 65, 65)}):Play()
                end
            end)

            ColorPickerToggle.MouseButton1Down:Connect(function()
                ColorPickerToggled = not ColorPickerToggled

                if ColorPickerToggled then
                    TweenService:Create(NameColorPicker, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 210)}):Play()
                    TweenService:Create(ColorPicker, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
                elseif not ColorPickerToggled then
                    TweenService:Create(NameColorPicker, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 32)}):Play()
                    TweenService:Create(ColorPicker, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                end
            end)

            table.insert(Library.LibraryColorTable, CheckboxOutline)
            table.insert(Library.LibraryColorTable, CheckboxTicked)
        end

        function SectionElements:CreateDropdown(name, options, presetoption, callback)
            local NameDropdown = Instance.new("Frame")
            local TitleToggle = Instance.new("TextButton")
            local Dropdown = Instance.new("ImageLabel")
            local DropdownContentLayout = Instance.new("UIListLayout")

            local DropdownToggled = true
            local SelectedOption = options[presetoption]

            NameDropdown.Name = (name .. "Dropdown")
            NameDropdown.Parent = SectionContent
            NameDropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameDropdown.BackgroundTransparency = 1.000
            NameDropdown.Position = UDim2.new(0, 0, 0.773480654, 0)
            NameDropdown.Size = UDim2.new(0, 197, 0, 35)
            NameDropdown.ZIndex = 5

            TitleToggle.Archivable = false
            TitleToggle.Name = "TitleToggle"
            TitleToggle.Parent = NameDropdown
            TitleToggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TitleToggle.BackgroundTransparency = 1.000
            TitleToggle.BorderSizePixel = 0
            TitleToggle.Position = UDim2.new(0, 13, 0, 0)
            TitleToggle.Size = UDim2.new(0, 167, 0, 30)
            TitleToggle.ZIndex = 7
            TitleToggle.Font = Library.Theme.TextFont
            TitleToggle.Text = (name .. " - " .. SelectedOption)
            TitleToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TitleToggle.TextSize = 15.000
            TitleToggle.TextXAlignment = Enum.TextXAlignment.Left

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = NameDropdown
            Dropdown.BackgroundColor3 = Library.Theme.BackgroundColor
            Dropdown.BackgroundTransparency = 1.000
            Dropdown.Position = UDim2.new(0, 15, 0, 30)
            Dropdown.Size = UDim2.new(0, 165, 0, 0)
            Dropdown.ZIndex = 15
            Dropdown.Image = "rbxassetid://3570695787"
            Dropdown.ImageColor3 = Color3.fromRGB(45, 45, 45)
            Dropdown.ScaleType = Enum.ScaleType.Slice
            Dropdown.SliceCenter = Rect.new(100, 100, 100, 100)
            Dropdown.SliceScale = 0.050
            Dropdown.ClipsDescendants = true

            DropdownContentLayout.Name = "DropdownContentLayout"
            DropdownContentLayout.Parent = Dropdown
            DropdownContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

            local function ResetAllDropdownItems()
                for i, v in pairs(Dropdown:GetChildren()) do
                    if v:IsA("TextButton") then
                        TweenService:Create(v, TweenInfo.new(0.25, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    end
                end
            end

            local function ClearAllDropdownItems()
                for i, v in pairs(Dropdown:GetChildren()) do
                    if v:IsA("TextButton") then
                        v:Destroy()
                    end
                end

                DropdownToggled = true
                TweenService:Create(TitleToggle, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                TweenService:Create(NameDropdown, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 35)}):Play()
                TweenService:Create(Dropdown, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 165, 0, 0)}):Play()
            end

            for i, v in pairs(options) do
                local NameButton = Instance.new("TextButton")

                NameButton.Name = (v .. "DropdownButton")
                NameButton.Parent = Dropdown
                NameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                NameButton.BackgroundTransparency = 1.000
                NameButton.BorderSizePixel = 0
                NameButton.Size = UDim2.new(0, 165, 0, 25)
                NameButton.ZIndex = 15
                NameButton.AutoButtonColor = false
                NameButton.Font = Library.Theme.TextFont
                NameButton.Text = v
                NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameButton.TextSize = 15.000

                table.insert(Library.LibraryColorTable, NameButton)

                if v == SelectedOption then
                    NameButton.TextColor3 = Library.Theme.MainColor
                end

                NameButton.MouseButton1Down:Connect(function()
                    SelectedOption = v
                    ResetAllDropdownItems()
                    TitleToggle.Text = (name .. " - " .. SelectedOption)
                    TweenService:Create(NameButton, TweenInfo.new(0.35, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.MainColor}):Play()
                    callback(NameButton.Text)
                end)

                NameButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        TweenService:Create(NameButton, TweenInfo.new(0.35, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
                    end
                end)

                NameButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        TweenService:Create(NameButton, TweenInfo.new(0.35, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                    end
                end)
            end
            
            TitleToggle.MouseButton1Down:Connect(function()
                DropdownToggled = not DropdownToggled
            
                if DropdownToggled then
                    TweenService:Create(TitleToggle, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    TweenService:Create(NameDropdown, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 35)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 165, 0, 0)}):Play()
                elseif not DropdownToggled then
                    TweenService:Create(TitleToggle, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(185, 185, 185)}):Play()
                    TweenService:Create(NameDropdown, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 197, 0, 35 + DropdownContentLayout.AbsoluteContentSize.Y)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.5, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {Size = UDim2.new(0, 165, 0, DropdownContentLayout.AbsoluteContentSize.Y)}):Play()
                end
            end)

            local function Refresh(newoptions, newpresetoption, newcallback)
                ClearAllDropdownItems()

                local SelectedOption = newoptions[newpresetoption]
                TitleToggle.Text = (name .. " - " .. SelectedOption)

                for i, v in pairs(newoptions) do
                    local NameButton = Instance.new("TextButton")
    
                    NameButton.Name = (v .. "Button")
                    NameButton.Parent = Dropdown
                    NameButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    NameButton.BackgroundTransparency = 1.000
                    NameButton.BorderSizePixel = 0
                    NameButton.Size = UDim2.new(0, 165, 0, 25)
                    NameButton.ZIndex = 15
                    NameButton.AutoButtonColor = false
                    NameButton.Font = Library.Theme.TextFont
                    NameButton.Text = v
                    NameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    NameButton.TextSize = 15.000
    
                    if v == SelectedOption then
                        NameButton.TextColor3 = Library.Theme.MainColor
                    end
    
                    NameButton.MouseButton1Down:Connect(function()
                        SelectedOption = v
                        ResetAllDropdownItems()
                        TitleToggle.Text = (name .. " - " .. SelectedOption)
                        TweenService:Create(NameButton, TweenInfo.new(0.35, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.MainColor}):Play()
                        newcallback(NameButton.Text)
                    end)
    
                    NameButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            TweenService:Create(NameButton, TweenInfo.new(0.35, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 0.95}):Play()
                        end
                    end)
    
                    NameButton.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            TweenService:Create(NameButton, TweenInfo.new(0.35, Library.Theme.EasingStyle, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
                        end
                    end)
                end
            end

            return {
                Refresh = Refresh
            }
        end

        function SectionElements:CreateKeybind(name, presetbind, keyboardonly, holdmode, callback)
            local NameKeybind = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local KeybindButtonBorder = Instance.new("ImageLabel")
            local KeybindButton = Instance.new("TextButton")

            local OldBind = presetbind.Name
            local LoadFromPreset = false
            local JustBinded = false

            local NotAllowedKeys = {
                Return = true,
                Space = true,
                Tab = true,
                Unknown = true,
                MouseButton1 = true
            }

            local AllowedMouseTypes = {
                MouseButton2 = true,
                MouseButton3 = true
            }

            local ShortenedNames = {
                LeftShift = "LShift",
                RightShift = "RShift",
                LeftControl = "LCtrl",
                RightControl = "RCtrl",
                LeftAlt = "LAlt",
                RightAlt = "RAlt",
                CapsLock = "Caps",
                One = "1",
                Two = "2",
                Three = "3",
                Four = "4",
                Five = "5",
                Six = "6",
                Seven = "7",
                Eight = "8",
                Nine = "9",
                Zero = "0",
                KeypadOne = "Num-1",
                KeypadTwo = "Num-2",
                KeypadThree = "Num-3",
                KeypadFour = "Num-4",
                KeypadFive = "Num-5",
                KeypadSix = "Num-6",
                KeypadSeven = "Num-7",
                KeypadEight = "Num-8",
                KeypadNine = "Num-9",
                KeypadZero = "Num-0",
                Minus = "-",
                Equals = "=",
                Tilde = "~",
                LeftBracket = "[",
                RightBracket = "]",
                RightParenthesis = ")",
                LeftParenthesis = "(",
                Semicolon = ";",
                Quote = "'",
                BackSlash = "\\",
                Comma = ",",
                Period = ".",
                Slash = "/",
                Asterisk = "*",
                Plus = "+",
                Period = ".",
                Backquote = "`",
                MouseButton1 = "M1",
                MouseButton2 = "M2",
                MouseButton3 = "M3"
            }

            NameKeybind.Name = (name .. "Keybind")
            NameKeybind.Parent = SectionContent
            NameKeybind.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            NameKeybind.BackgroundTransparency = 1.000
            NameKeybind.Position = UDim2.new(0, 0, 0.138121545, 0)
            NameKeybind.Size = UDim2.new(0, 197, 0, 35)

            Title.Name = "Title"
            Title.Parent = NameKeybind
            Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 13, 0, 0)
            Title.Size = UDim2.new(0, 151, 0, 30)
            Title.ZIndex = 5
            Title.Font = Library.Theme.TextFont
            Title.Text = name
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 15.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            KeybindButtonBorder.Name = "KeybindButtonBorder"
            KeybindButtonBorder.Parent = NameKeybind
            KeybindButtonBorder.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            KeybindButtonBorder.BackgroundTransparency = 1.000
            KeybindButtonBorder.Position = UDim2.new(0, 139, 0, 5)
            KeybindButtonBorder.Size = UDim2.new(0, 42, 0, 20)
            KeybindButtonBorder.ZIndex = 5
            KeybindButtonBorder.Image = "rbxassetid://3570695787"
            KeybindButtonBorder.ImageColor3 = Color3.fromRGB(65, 65, 65)
            KeybindButtonBorder.ScaleType = Enum.ScaleType.Slice
            KeybindButtonBorder.SliceCenter = Rect.new(100, 100, 100, 100)
            KeybindButtonBorder.SliceScale = 0.030

            KeybindButton.Name = "KeybindButton"
            KeybindButton.Parent = KeybindButtonBorder
            KeybindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.BackgroundTransparency = 1.000
            KeybindButton.Size = UDim2.new(1, 0, 1, 0)
            KeybindButton.ZIndex = 5
            KeybindButton.Font = Library.Theme.TextFont
            KeybindButton.Text = (ShortenedNames[presetbind.Name] or ShortenedNames[presetbind] or presetbind.Name or "None")
            KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            KeybindButton.TextSize = 15.000
            KeybindButton.TextWrapped = true
            
            if LoadFromPreset then
                KeybindButton.Text = presetbind
            end

            if presetbind == Enum.KeyCode.Unknown or presetbind == "Unknown" then
                KeybindButton.Text = "None"
            end

            KeybindButton.MouseButton1Click:Connect(function()
                if Library.CurrentlyBinding then return end

                KeybindButton.Text = "..."

                local Input, Bruh = UserInputService.InputBegan:wait()
                Library.CurrentlyBinding = true

                if Input.KeyCode.Name == "Backspace" or Input.KeyCode.Name == "Delete" then
                    KeybindButton.Text = "None"
                    OldBind = Enum.KeyCode.Unknown.Name
                    Library.CurrentlyBinding = false
                    JustBinded = false
                    return
                end
                
                if (Input.UserInputType ~= Enum.UserInputType.Keyboard and (AllowedMouseTypes[Input.UserInputType.Name]) and (not keyboardonly)) or (Input.KeyCode and (not NotAllowedKeys[Input.KeyCode.Name])) then
                    local BindName = ((Input.UserInputType ~= Enum.UserInputType.Keyboard and Input.UserInputType.Name) or Input.KeyCode.Name)
                    KeybindButton.Text = ShortenedNames[BindName] or BindName
                    OldBind = BindName
                    Library.CurrentlyBinding = false
                    JustBinded = true
                else
                    KeybindButton.Text = ShortenedNames[OldBind] or OldBind
                    Library.CurrentlyBinding = false
                end
            end)
            
            if not holdmode then
                UserInputService.InputBegan:Connect(function(input, gameprocessedevent) 
                    if not gameprocessedevent then
                        if UserInputService:GetFocusedTextBox() then return end
                        if OldBind == Enum.KeyCode.Unknown.Name then return end
                        if JustBinded then JustBinded = false return end

                        local BindName = ((input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType.Name) or input.KeyCode.Name)

                        if BindName == OldBind then 
                            callback()
                        end
                    end
                end)
            else
                UserInputService.InputBegan:Connect(function(input, gameprocessedevent) 
                    if not gameprocessedevent then
                        if UserInputService:GetFocusedTextBox() then return end
                        if OldBind == Enum.KeyCode.Unknown.Name then return end
                        if JustBinded then JustBinded = false return end

                        local BindName = ((input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType.Name) or input.KeyCode.Name)

                        if BindName == OldBind then 
                            callback(true)
                        end
                    end
                end)

                UserInputService.InputEnded:Connect(function(input, gameprocessedevent) 
                    if not gameprocessedevent then
                        if UserInputService:GetFocusedTextBox() then return end
                        if OldBind == Enum.KeyCode.Unknown.Name then return end
                        if JustBinded then JustBinded = false return end

                        HoldModeToggled = false
                        local BindName = ((input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType.Name) or input.KeyCode.Name)

                        if BindName == OldBind then 
                            callback(false)
                        end
                    end
                end)
            end
        end

        SectionContent.CanvasSize = UDim2.new(0, 0, 0, SectionContentLayout.AbsoluteContentSize.Y + 15)

        return SectionElements
    end

    return TabElements
end

return Library
