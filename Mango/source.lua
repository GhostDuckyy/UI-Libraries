if game.CoreGui:FindFirstChild("MangoHub") then
    game.CoreGui.MangoHub:Destroy();
end

if game.CoreGui:FindFirstChild("Sample") then
    game.CoreGui.Sample:Destroy();
end

local MainHolder = {}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Sample = Instance.new("ImageLabel")
Sample.Name = "Sample"
Sample.Parent = game.CoreGui
Sample.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Sample.BackgroundTransparency = 1.000
Sample.Image = "http://www.roblox.com/asset/?id=4560909609"
Sample.ImageColor3 = Color3.fromRGB(75,75,75)
Sample.ImageTransparency = 0.600

local function ClickEfect(object)
    
    local c = Sample:Clone()
    c.Parent = object 
    local x, y = (Mouse.X - c.AbsolutePosition.X), (Mouse.Y - c.AbsolutePosition.Y)
    c.Position = UDim2.new(0, x, 0, y)
    local len, size = 0.35, nil
    if object.AbsoluteSize.X >= object.AbsoluteSize.Y then
        size = (object.AbsoluteSize.X * 1.5)
    else
        size = (object.AbsoluteSize.Y * 1.5)
    end
    c:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.7, (-size / 2), 0.5, (-size / 2)), 'Out', 'Quad', len, true, nil)
    for i = 1, 10 do
        c.ImageTransparency = c.ImageTransparency + 0.05
        wait(len / 12)
    end
    c:Destroy()
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil
   
    local function Update(input)
       local Delta = input.Position - DragStart
       local pos =
          UDim2.new(
             StartPosition.X.Scale,
             StartPosition.X.Offset + Delta.X,
             StartPosition.Y.Scale,
             StartPosition.Y.Offset + Delta.Y
          )
       local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
       Tween:Play()
    end
   
    topbarobject.InputBegan:Connect(
       function(input)
          if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
             Dragging = true
             DragStart = input.Position
             StartPosition = object.Position
   
             input.Changed:Connect(
                function()
                   if input.UserInputState == Enum.UserInputState.End then
                      Dragging = false
                   end
                end
             )
          end
       end
    )
   
    topbarobject.InputChanged:Connect(
       function(input)
          if
             input.UserInputType == Enum.UserInputType.MouseMovement or
                input.UserInputType == Enum.UserInputType.Touch
          then
             DragInput = input
          end
       end
    )
   
    UserInputService.InputChanged:Connect(
       function(input)
          if input == DragInput and Dragging then
             Update(input)
          end
       end
    )
   end



local MangoHub = Instance.new("ScreenGui")
MangoHub.Name = "MangoHub"
MangoHub.Parent = game.CoreGui
MangoHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function MainHolder:Window(HubTitle)

    local FirstTab = false
    local MainFrame = Instance.new("Frame")
    local NotifyList = Instance.new("Frame")
    local NotifyListLayout = Instance.new("UIListLayout")
    local NotifyListPadding = Instance.new("UIPadding")

    function MainHolder:Notify(NotifyTitle, Desc, waittime)
        local NotifyFrame = Instance.new("Frame")
        local NofifyTitle = Instance.new("TextLabel")
        local NotifyDescription = Instance.new("TextLabel")

        NotifyList.Name = "NotifyList"
        NotifyList.Parent = MainFrame
        NotifyList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyList.BackgroundTransparency = 1.000
        NotifyList.Size = UDim2.new(1, 0, 1, 0)

        NotifyListLayout.Name = "NotifyListLayout"
        NotifyListLayout.Parent = NotifyList
        NotifyListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        NotifyListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        NotifyListLayout.Padding = UDim.new(0, 10)
        
        NotifyListPadding.Name = "NotifyListPadding"
        NotifyListPadding.Parent = NotifyList
        NotifyListPadding.PaddingBottom = UDim.new(0, 5)
        NotifyListPadding.PaddingTop = UDim.new(0, 5)

        NotifyFrame.Name = "NotifyFrame"
        NotifyFrame.Parent = NotifyList
        NotifyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyFrame.BackgroundTransparency = 1.000
        NotifyFrame.Position = UDim2.new(0.379095167, 0, 0.0194931775, 0)
        NotifyFrame.Size = UDim2.new(0, 180, 0, 75)
        NotifyFrame.ZIndex = 50
    
        local NotifyFrameStroke = Instance.new("UIStroke")
        NotifyFrameStroke.Parent = NotifyFrame
        NotifyFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        NotifyFrameStroke.Color = Color3.fromRGB(25, 69, 165)
        NotifyFrameStroke.Transparency = 0

        if NotifyTitle == "" then
            NotifyTitle = "Notification"
        end
        
        NofifyTitle.Name = "NofifyTitle"
        NofifyTitle.Parent = NotifyFrame
        NofifyTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NofifyTitle.BackgroundTransparency = 1.000
        NofifyTitle.Position = UDim2.new(0.224444583, 0, 0.106666669, 0)
        NofifyTitle.Size = UDim2.new(0, 103, 0, 21)
        NofifyTitle.Font = Enum.Font.Gotham
        NofifyTitle.Text = NotifyTitle or "Notification"
        NofifyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        NofifyTitle.TextSize = 18.000
        
        NotifyDescription.Name = "NotifyDescription"
        NotifyDescription.Parent = NotifyFrame
        NotifyDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        NotifyDescription.BackgroundTransparency = 1.000
        NotifyDescription.Position = UDim2.new(0.311111122, 0, 0.493333369, 0)
        NotifyDescription.Size = UDim2.new(0, 72, 0, 13)
        NotifyDescription.Font = Enum.Font.Gotham
        NotifyDescription.Text = Desc or "Hello World!"
        NotifyDescription.TextColor3 = Color3.fromRGB(162, 162, 162)
        NotifyDescription.TextSize = 14.000
        wait(waittime or 1)
        TweenService:Create(
            NotifyFrameStroke,
            TweenInfo.new(3, Enum.EasingStyle.Quad),
            {Transparency = 1}
        ):Play()
        TweenService:Create(
            NotifyDescription,
            TweenInfo.new(3, Enum.EasingStyle.Quad),
            {TextTransparency = 1}
        ):Play()
        TweenService:Create(
            NofifyTitle,
            TweenInfo.new(3, Enum.EasingStyle.Quad),
            {TextTransparency = 1}
        ):Play()
        repeat task.wait() until NofifyTitle.TextTransparency == 1
        NotifyFrame:Destroy()
    end

    local MainFrameCorner = Instance.new("UICorner")
    local MainFrameItemsHolder = Instance.new("Frame")
    local MainTitle = Instance.new("TextLabel")
    local HideShowTabsImage = Instance.new("ImageLabel")
    local HideShowTabsImageButton = Instance.new("TextButton")
    local SettingsImage = Instance.new("ImageLabel")
    local SettingsImageButton = Instance.new("TextButton")
    local PluginsImage = Instance.new("ImageLabel")
    local PluginsImageButton = Instance.new("TextButton")
    local HideShowTabsImageText = Instance.new("TextLabel")
    local SettingsImageText = Instance.new("TextLabel")
    local PluginsImageText = Instance.new("TextLabel")
    local TabsFrame = Instance.new("Frame")
    local TabsHolder = Instance.new("Frame")
    local TabsHolder_2 = Instance.new("UIListLayout")
    local TabsLine = Instance.new("Frame")
    local ContainerHold = Instance.new("Frame")
    local SettingsFrame = Instance.new("Frame")
    local SettingsFrameCorner = Instance.new("UICorner")
    local SettingsFrameItems = Instance.new("Frame")
    local SettingsTitle = Instance.new("TextLabel")
    local PluginsFrame = Instance.new("Frame")
    local PluginsFrameCorner = Instance.new("UICorner")
    local PluginsFrameItems = Instance.new("Frame")
    local PluginsTitle = Instance.new("TextLabel")
    local PluginsFrameHolder = Instance.new("Frame")
    local RemoteSpyButton = Instance.new("TextButton")
    local RemoteSpyButtonCorner = Instance.new("UICorner")
    local PluginsButton = Instance.new("TextButton")
    local PluginsButtonCorner = Instance.new("UICorner")

    local MainSearchToggled = false
    local TabsShowToggled = false

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = MangoHub
    MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    MainFrame.Position = UDim2.new(0.224070221, 0, 0.0417287573, 0)
    MainFrame.Size = UDim2.new(0, 641, 0, 513)
    
    MainFrameCorner.CornerRadius = UDim.new(0, 5)
    MainFrameCorner.Name = "MainFrameCorner"
    MainFrameCorner.Parent = MainFrame
    
    MainFrameItemsHolder.Name = "MainFrameItemsHolder"
    MainFrameItemsHolder.Parent = MainFrame
    MainFrameItemsHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    MainFrameItemsHolder.BackgroundTransparency = 1.000
    MainFrameItemsHolder.Size = UDim2.new(0, 641, 0, 59)

    MakeDraggable(MainFrameItemsHolder, MainFrame)
    
    MainTitle.Name = "MainTitle"
    MainTitle.Parent = MainFrameItemsHolder
    MainTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.BackgroundTransparency = 1.000
    MainTitle.Position = UDim2.new(0.0577223077, 0, 0.3898305, 0)
    MainTitle.Size = UDim2.new(0, 65, 0, 13)
    MainTitle.Font = Enum.Font.Gotham
    MainTitle.Text = HubTitle or "MangoHub"
    MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTitle.TextSize = 23.000
    
    HideShowTabsImage.Name = "HideShowTabsImage"
    HideShowTabsImage.Parent = MainFrameItemsHolder
    HideShowTabsImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HideShowTabsImage.BackgroundTransparency = 1.000
    HideShowTabsImage.Position = UDim2.new(0.92043674, 0, 0.288135588, 0)
    HideShowTabsImage.Size = UDim2.new(0, 32, 0, 25)
    HideShowTabsImage.Image = "rbxassetid://6034818372"
    
    HideShowTabsImageButton.Name = "HideShowTabsImageButton"
    HideShowTabsImageButton.Parent = HideShowTabsImage
    HideShowTabsImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HideShowTabsImageButton.BackgroundTransparency = 1.000
    HideShowTabsImageButton.Size = UDim2.new(1, 0, 1, 0)
    HideShowTabsImageButton.Font = Enum.Font.SourceSans
    HideShowTabsImageButton.Text = ""
    HideShowTabsImageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    HideShowTabsImageButton.TextSize = 14.000

    HideShowTabsImageButton.MouseButton1Click:Connect(function()
        if TabsShowToggled == true then
        for i,v in pairs(MainFrameItemsHolder:GetChildren()) do
            if v.ClassName == "TextLabel" and v.Name ~= "MainTitle" and v.Name ~= "TimeText" then
                TweenService:Create(
                    v,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {TextColor3 = Color3.fromRGB(147, 147, 147)}
                ):Play()
            end
        end
        TweenService:Create(
            HideShowTabsImageText,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {TextColor3 = Color3.fromRGB(255, 255, 255)}
        ):Play()
        MainSearchToggled = false

    else
        for i,v in pairs(MainFrameItemsHolder:GetChildren()) do
            if v.ClassName == "TextLabel" and v.Name ~= "MainTitle" and v.Name ~= "TimeText" then
                TweenService:Create(
                    v,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {TextColor3 = Color3.fromRGB(147, 147, 147)}
                ):Play()
            end
        end
    end
    TabsShowToggled = not TabsShowToggled
    end)

    local TabsToggled = true
    HideShowTabsImageButton.MouseButton1Click:Connect(function()
        if TabsToggled == false then

            TweenService:Create(
                HideShowTabsImage,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {Rotation = 0}
            ):Play()

            TweenService:Create(
                TabsFrame,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 615, 0, 32)}
            ):Play()

            TweenService:Create(
                TabsLine,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0}
            ):Play()

            for i,v in pairs(TabsHolder:GetChildren()) do
                if v.ClassName == "TextButton" then
                    TweenService:Create(
                        v,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {TextTransparency = 0}
                    ):Play()
                end
            end

            repeat task.wait() until TabsFrame.Size == UDim2.new(0, 615, 0, 32)

        else
            -- TabsHolder.Visible = false
            TweenService:Create(
                HideShowTabsImage,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {Rotation = 180}
            ):Play()

            TweenService:Create(
                TabsFrame,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 615, 0, 0)}
            ):Play()

            TweenService:Create(
                TabsLine,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            ):Play()

            for i,v in pairs(TabsHolder:GetChildren()) do
                if v.ClassName == "TextButton" then
                    TweenService:Create(
                        v,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {TextTransparency = 1}
                    ):Play()
                end
            end

            repeat task.wait() until TabsFrame.Size == UDim2.new(0, 615, 0, 0)
            -- TabsLine.Visible = false
            -- TabsHolder
        end
        TabsToggled = not TabsToggled
    end)
    
    SettingsImage.Name = "SettingsImage"
    SettingsImage.Parent = MainFrameItemsHolder
    SettingsImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsImage.BackgroundTransparency = 1.000
    SettingsImage.Position = UDim2.new(0.845553756, 0, 0.288135588, 0)
    SettingsImage.Size = UDim2.new(0, 27, 0, 25)
    SettingsImage.Image = "rbxassetid://6031280882"
    
    SettingsImageButton.Name = "SettingsImageButton"
    SettingsImageButton.Parent = SettingsImage
    SettingsImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsImageButton.BackgroundTransparency = 1.000
    SettingsImageButton.Size = UDim2.new(1, 0, 1, 0)
    SettingsImageButton.Font = Enum.Font.SourceSans
    SettingsImageButton.Text = ""
    SettingsImageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    SettingsImageButton.TextSize = 14.000


    local SearchBox = Instance.new("TextBox")
    local SearchBoxCorner = Instance.new("UICorner")
    local MainSearchImage = Instance.new("ImageLabel")
    local MainSearchImageButton = Instance.new("TextButton")
    local MainSearchText = Instance.new("TextLabel")
    
    
    SearchBox.Name = "SearchBox"
    SearchBox.Parent = MainFrameItemsHolder
    SearchBox.BackgroundColor3 = Color3.fromRGB(44, 44, 44)
    SearchBox.Position = UDim2.new(0.307332307, 0, 0.271186769, 0)
    SearchBox.Size = UDim2.new(0, 200, 0, 31)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search here"
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.TextSize = 14.000
    
    SearchBoxCorner.CornerRadius = UDim.new(0, 3)
    SearchBoxCorner.Name = "SearchBoxCorner"
    SearchBoxCorner.Parent = SearchBox
    
    MainSearchImage.Name = "MainSearchImage"
    MainSearchImage.Parent = MainFrameItemsHolder
    MainSearchImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainSearchImage.BackgroundTransparency = 1.000
    MainSearchImage.Position = UDim2.new(0.692667603, 0, 0.288135588, 0)
    MainSearchImage.Size = UDim2.new(0, 27, 0, 25)
    MainSearchImage.Image = "rbxassetid://6031154871"
    
    MainSearchImageButton.Name = "MainSearchImageButton"
    MainSearchImageButton.Parent = MainSearchImage
    MainSearchImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainSearchImageButton.BackgroundTransparency = 1.000
    MainSearchImageButton.Size = UDim2.new(1, 0, 1, 0)
    MainSearchImageButton.Font = Enum.Font.SourceSans
    MainSearchImageButton.Text = ""
    MainSearchImageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    MainSearchImageButton.TextSize = 14.000

    -- https://discord.com/api/webhooks/1025124282356990032/ypicKByffVA2yrXg4INj0qi8KkxbRnviPadDN0u_c4zA5AheTUiSfD0nZuf_Vu93ZWJD

    MainSearchImageButton.MouseButton1Click:Connect(function()
        if MainSearchToggled == false then
            for i,v in pairs(MainFrameItemsHolder:GetChildren()) do
                if v.ClassName == "TextLabel" and v.Name ~= "MainTitle" and v.Name ~= "TimeText" then
                    TweenService:Create(
                        v,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {TextColor3 = Color3.fromRGB(147, 147, 147)}
                    ):Play()
                end
            end
            TweenService:Create(
                MainSearchText,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {TextColor3 = Color3.fromRGB(255, 255, 255)}
            ):Play()

        else
            for i,v in pairs(MainFrameItemsHolder:GetChildren()) do
                if v.ClassName == "TextLabel" and v.Name ~= "MainTitle" and v.Name ~= "TimeText" then
                    TweenService:Create(
                        v,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {TextColor3 = Color3.fromRGB(147, 147, 147)}
                    ):Play()
                end
            end
        end
        MainSearchToggled = not MainSearchToggled
        TabsShowToggled = false
    end)
    local SearchBoxViewToggled = false
    MainSearchImageButton.MouseButton1Click:Connect(function()
        if SearchBoxViewToggled == false then
        TweenService:Create(
            SearchBox,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 200, 0, 31)}
        ):Play()
        TweenService:Create(
            SearchBox,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 0}
        ):Play()
        wait(.01)
        TweenService:Create(
            SearchBox,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {TextTransparency = 0}
        ):Play()

    else
        TweenService:Create(
            SearchBox,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 0, 0, 31)}
        ):Play()
        TweenService:Create(
            SearchBox,
            TweenInfo.new(0.01, Enum.EasingStyle.Quad),
            {TextTransparency = 1}
        ):Play()
        task.wait(0.08)
        TweenService:Create(
            SearchBox,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        ):Play()
    end
    SearchBoxViewToggled = not SearchBoxViewToggled
    end)

    spawn(function()
        TweenService:Create(
            SearchBox,
            TweenInfo.new(0, Enum.EasingStyle.Quad),
            {Size = UDim2.new(0, 0, 0, 31)}
        ):Play()
        TweenService:Create(
            SearchBox,
            TweenInfo.new(0, Enum.EasingStyle.Quad),
            {TextTransparency = 1}
        ):Play()
        task.wait(0.08)
        TweenService:Create(
            SearchBox,
            TweenInfo.new(0, Enum.EasingStyle.Quad),
            {BackgroundTransparency = 1}
        ):Play()
        
    end)
    
    MainSearchText.Name = "MainSearchText"
    MainSearchText.Parent = MainFrameItemsHolder
    MainSearchText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MainSearchText.BackgroundTransparency = 1.000
    MainSearchText.Position = UDim2.new(0.676431417, 0, 0.711864412, 0)
    MainSearchText.Size = UDim2.new(0, 47, 0, 12)
    MainSearchText.Font = Enum.Font.SourceSans
    MainSearchText.Text = "Search"
    MainSearchText.TextColor3 = Color3.fromRGB(147, 147, 147)
    MainSearchText.TextSize = 15.000

    
    SettingsImageButton.MouseButton1Click:Connect(function()
        for i,v in pairs(MainFrameItemsHolder:GetChildren()) do
            if v.ClassName == "TextLabel" and v.Name ~= "MainTitle" and v.Name ~= "TimeText" then
                TweenService:Create(
                    v,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {TextColor3 = Color3.fromRGB(147, 147, 147)}
                ):Play()
            end
        end
        TweenService:Create(
            SettingsImageText,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {TextColor3 = Color3.fromRGB(255, 255, 255)}
        ):Play()
        MainSearchToggled = false
        TabsShowToggled = false
    end)

    spawn(function()
        while task.wait() do
            pcall(function()
                TweenService:Create(
                    SettingsImage,
                    TweenInfo.new(.8, Enum.EasingStyle.Quad),
                    {Rotation = 360}
                ):Play()
                repeat task.wait() until SettingsImage.Rotation == 360
                TweenService:Create(
                    SettingsImage,
                    TweenInfo.new(0, Enum.EasingStyle.Quad),
                    {Rotation = 0}
                ):Play()
            end)
            wait(56)
        end
    end)

    for i,v in pairs(SettingsFrame:GetChildren()) do
        if v.ClassName == "Frame" or v.ClassName == "TextLabel" then
            v.Visible = false
        end
    end

    local SettingsToggled = false
    SettingsImageButton.MouseButton1Click:Connect(function()
        if SettingsToggled == false then
            -- MainHolder:Notify("", "Curently In Development", 1)
            SettingsFrame.Visible = true
            TweenService:Create(
                SettingsFrame,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0}
            ):Play()
            for i,v in pairs(SettingsFrame:GetChildren()) do
                if v.ClassName == "Frame" or v.ClassName == "TextLabel" then
                    v.Visible = true
                end
            end
            TweenService:Create(
                SettingsImage,
                TweenInfo.new(.8, Enum.EasingStyle.Quad),
                {Rotation = 360}
            ):Play()
            repeat task.wait() until SettingsImage.Rotation == 360
            TweenService:Create(
                SettingsImage,
                TweenInfo.new(0, Enum.EasingStyle.Quad),
                {Rotation = 0}
            ):Play()
        else
            TweenService:Create(
                SettingsFrame,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            ):Play()
            for i,v in pairs(SettingsFrame:GetChildren()) do
                if v.ClassName == "Frame" or v.ClassName == "TextLabel" then
                    v.Visible = false
                end
            end
            TweenService:Create(
                SettingsImage,
                TweenInfo.new(.8, Enum.EasingStyle.Quad),
                {Rotation = -360}
            ):Play()
            repeat task.wait() until SettingsImage.Rotation == -360
            TweenService:Create(
                SettingsImage,
                TweenInfo.new(0, Enum.EasingStyle.Quad),
                {Rotation = 0}
            ):Play()
            SettingsFrame.Visible = false
        end
        SettingsToggled = not SettingsToggled
    end)
    
    PluginsImage.Name = "PluginsImage"
    PluginsImage.Parent = MainFrameItemsHolder
    PluginsImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PluginsImage.BackgroundTransparency = 1.000
    PluginsImage.Position = UDim2.new(0.762870431, 0, 0.288135588, 0)
    PluginsImage.Size = UDim2.new(0, 27, 0, 25)
    PluginsImage.Image = "rbxassetid://6022668955"
    
    PluginsImageButton.Name = "PluginsImageButton"
    PluginsImageButton.Parent = PluginsImage
    PluginsImageButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PluginsImageButton.BackgroundTransparency = 1.000
    PluginsImageButton.Size = UDim2.new(1, 0, 1, 0)
    PluginsImageButton.Font = Enum.Font.SourceSans
    PluginsImageButton.Text = ""
    PluginsImageButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    PluginsImageButton.TextSize = 14.000

    spawn(function()
        while task.wait() do
            pcall(function()
                TweenService:Create(
                    PluginsImage,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {Rotation = 10}
                ):Play()
                wait(.4)
                TweenService:Create(
                    PluginsImage,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {Rotation = -10}
                ):Play()
                wait(.4)
                TweenService:Create(
                    PluginsImage,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {Rotation = 180}
                ):Play()
                wait(.4)
                TweenService:Create(
                    PluginsImage,
                    TweenInfo.new(0, Enum.EasingStyle.Quad),
                    {Rotation = 0}
                ):Play()
            end)
            wait(60)
        end
    end)

    PluginsImageButton.MouseButton1Click:Connect(function()
        TweenService:Create(
            PluginsImage,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {Rotation = 10}
        ):Play()
        wait(.4)
        TweenService:Create(
            PluginsImage,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {Rotation = -10}
        ):Play()
        wait(.4)
        TweenService:Create(
            PluginsImage,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {Rotation = 180}
        ):Play()
        wait(.4)
        TweenService:Create(
            PluginsImage,
            TweenInfo.new(0, Enum.EasingStyle.Quad),
            {Rotation = 0}
        ):Play()
    end)

    PluginsImageButton.MouseButton1Click:Connect(function()
        MainHolder:Notify("", "Curently In Development", 1)
        for i,v in pairs(MainFrameItemsHolder:GetChildren()) do
            if v.ClassName == "TextLabel" and v.Name ~= "MainTitle" and v.Name ~= "TimeText" then
                TweenService:Create(
                    v,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {TextColor3 = Color3.fromRGB(147, 147, 147)}
                ):Play()
            end
        end
        TweenService:Create(
            PluginsImageText,
            TweenInfo.new(.3, Enum.EasingStyle.Quad),
            {TextColor3 = Color3.fromRGB(255, 255, 255)}
        ):Play()
        MainSearchToggled = false
        TabsShowToggled = false
    end)

    local PluginToggled = false
    PluginsImageButton.MouseButton1Click:Connect(function()
        if PluginToggled == false then
            PluginsFrame.Visible = true
            TweenService:Create(
                PluginsFrame,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 0}
            ):Play()
            PluginsFrameHolder.Visible = true
            PluginsFrameItems.Visible = true
        else
            PluginsFrameHolder.Visible = false
            PluginsFrameItems.Visible = false
            TweenService:Create(
                PluginsFrame,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            ):Play()
            repeat task.wait() until PluginsFrame.BackgroundTransparency == 1
            PluginsFrame.Visible = false
        end
        PluginToggled = not PluginToggled
    end)

    
    
    HideShowTabsImageText.Name = "HideShowTabsImageText"
    HideShowTabsImageText.Parent = MainFrameItemsHolder
    HideShowTabsImageText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HideShowTabsImageText.BackgroundTransparency = 1.000
    HideShowTabsImageText.Position = UDim2.new(0.907817245, 0, 0.711864412, 0)
    HideShowTabsImageText.Size = UDim2.new(0, 47, 0, 12)
    HideShowTabsImageText.Font = Enum.Font.SourceSans
    HideShowTabsImageText.Text = "Tabs"
    HideShowTabsImageText.TextColor3 = Color3.fromRGB(147, 147, 147)
    HideShowTabsImageText.TextSize = 15.000
    
    SettingsImageText.Name = "SettingsImageText"
    SettingsImageText.Parent = MainFrameItemsHolder
    SettingsImageText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsImageText.BackgroundTransparency = 1.000
    SettingsImageText.Position = UDim2.new(0.82931757, 0, 0.711864412, 0)
    SettingsImageText.Size = UDim2.new(0, 47, 0, 12)
    SettingsImageText.Font = Enum.Font.SourceSans
    SettingsImageText.Text = "Settings"
    SettingsImageText.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsImageText.TextSize = 15.000
    
    PluginsImageText.Name = "PluginsImageText"
    PluginsImageText.Parent = MainFrameItemsHolder
    PluginsImageText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PluginsImageText.BackgroundTransparency = 1.000
    PluginsImageText.Position = UDim2.new(0.746634245, 0, 0.711864412, 0)
    PluginsImageText.Size = UDim2.new(0, 47, 0, 12)
    PluginsImageText.Font = Enum.Font.SourceSans
    PluginsImageText.Text = "Plugins"
    PluginsImageText.TextColor3 = Color3.fromRGB(147, 147, 147)
    PluginsImageText.TextSize = 15.000
    
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TabsFrame.BackgroundTransparency = 1.000
    TabsFrame.Position = UDim2.new(0.0202808119, 0, 0.115009747, 0)
    TabsFrame.Size = UDim2.new(0, 615, 0, 32)
    
    TabsHolder.Name = "TabsHolder"
    TabsHolder.Parent = TabsFrame
    TabsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsHolder.BackgroundTransparency = 1.000
    TabsHolder.Size = UDim2.new(1, 0, 1, 0)
    
    TabsHolder_2.Name = "TabsHolder"
    TabsHolder_2.Parent = TabsHolder
    TabsHolder_2.FillDirection = Enum.FillDirection.Horizontal
    TabsHolder_2.SortOrder = Enum.SortOrder.LayoutOrder
    TabsHolder_2.VerticalAlignment = Enum.VerticalAlignment.Center
    TabsHolder_2.Padding = UDim.new(0, 15)

    TabsLine.Name = "TabsLine"
    TabsLine.Parent = TabsFrame
    TabsLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabsLine.Position = UDim2.new(-0.0178861786, 0, 1.03125, 0)
    TabsLine.Size = UDim2.new(0, 635, 0, 0)
    
    ContainerHold.Name = "ContainerHold"
    ContainerHold.Parent = MainFrame
    ContainerHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ContainerHold.BackgroundTransparency = 1.000
    ContainerHold.Position = UDim2.new(0.00312012481, 0, 0.179337233, 0)
    ContainerHold.Size = UDim2.new(0, 639, 0, 421)

    local SettingsHolder = Instance.new("Frame")
    local SettingsContainer = Instance.new("ScrollingFrame")
    local SettingsContainerLayout = Instance.new("UIListLayout")
    local SettingsContainerPadding = Instance.new("UIPadding")

    function MainHolder:Bind(text, presetbind, callback)
        local Key = presetbind.Name
        local binding = false

        local SettingsBind = Instance.new("TextButton")
        local SettingsBindCorner = Instance.new("UICorner")
        local SettingsBindText = Instance.new("TextLabel")
        local SettingsBindBox = Instance.new("TextLabel")
        local SettingsBindBoxCorner = Instance.new("UICorner")
        local SettingsContainerPadding = Instance.new("UIPadding")
    
        SettingsBind.Name = "SettingsBind"
        SettingsBind.Parent = SettingsContainer
        SettingsBind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        SettingsBind.Position = UDim2.new(0.0166320167, 0, 0, 0)
        SettingsBind.Size = UDim2.new(0, 412, 0, 36)
        SettingsBind.AutoButtonColor = false
        SettingsBind.Font = Enum.Font.Gotham
        SettingsBind.Text = ""
        SettingsBind.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsBind.TextSize = 14.000
    
        SettingsBindCorner.CornerRadius = UDim.new(0, 3)
        SettingsBindCorner.Name = "SettingsBindCorner"
        SettingsBindCorner.Parent = SettingsBind
    
        SettingsBindText.Name = "SettingsBindText"
        SettingsBindText.Parent = SettingsBind
        SettingsBindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SettingsBindText.BackgroundTransparency = 1.000
        SettingsBindText.Position = UDim2.new(9.31322575e-10, 0, 0.253584236, 0)
        SettingsBindText.Size = UDim2.new(0, 102, 0, 17)
        SettingsBindText.Font = Enum.Font.Gotham
        SettingsBindText.Text = text
        SettingsBindText.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsBindText.TextSize = 14.000
    
        SettingsBindBox.Name = "SettingsBindBox"
        SettingsBindBox.Parent = SettingsBind
        SettingsBindBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        SettingsBindBox.Position = UDim2.new(0.56099999, 0, 0.111000001, 0)
        SettingsBindBox.Size = UDim2.new(0, 176, 0, 27)
        SettingsBindBox.Font = Enum.Font.Gotham
        SettingsBindBox.Text = Key
        SettingsBindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsBindBox.TextSize = 14.000
    
        SettingsBindBoxCorner.CornerRadius = UDim.new(0, 3)
        SettingsBindBoxCorner.Name = "SettingsBindBoxCorner"
        SettingsBindBoxCorner.Parent = SettingsBindBox

        SettingsBind.MouseButton1Click:Connect(function()
            SettingsBindBox.Text = "..."
            local inputwait = game:GetService("UserInputService").InputBegan:wait()
            if inputwait.KeyCode.Name ~= "Unknown" then
                SettingsBindBox.Text = inputwait.KeyCode.Name
               Key = inputwait.KeyCode.Name
               return
            end
         end)
         
         local KeyToggled = true
         game:GetService("UserInputService").InputBegan:connect(function(current, pressed)
            if not pressed then
               if current.KeyCode.Name == Key then
                if KeyToggled ~= false then
                  pcall(callback, KeyToggled)
                else
                   pcall(callback, KeyToggled)
                end
                KeyToggled = not KeyToggled
               end
            end
         end)
    end


    function MainHolder:Button(text, callback)

        local SettingsButton = Instance.new("TextButton")
        local SettingsButtonCorner = Instance.new("UICorner")
        local SettingsButtonText = Instance.new("TextLabel")
    
        SettingsButton.Name = "SettingsButton"
        SettingsButton.Parent = SettingsContainer
        SettingsButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        SettingsButton.Position = UDim2.new(0.0166320167, 0, 0, 0)
        SettingsButton.Size = UDim2.new(0, 412, 0, 36)
        SettingsButton.AutoButtonColor = false
        SettingsButton.Font = Enum.Font.Gotham
        SettingsButton.Text = ""
        SettingsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsButton.TextSize = 14.000
    
        SettingsButtonCorner.CornerRadius = UDim.new(0, 3)
        SettingsButtonCorner.Name = "SettingsButtonCorner"
        SettingsButtonCorner.Parent = SettingsButton
    
        SettingsButtonText.Name = "SettingsButtonText"
        SettingsButtonText.Parent = SettingsButton
        SettingsButtonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SettingsButtonText.BackgroundTransparency = 1.000
        SettingsButtonText.Position = UDim2.new(9.41322575e-10, 0, 0.253584236, 0)
        SettingsButtonText.Size = UDim2.new(0, 102, 0, 17)
        SettingsButtonText.Font = Enum.Font.Gotham
        SettingsButtonText.Text = text
        SettingsButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        SettingsButtonText.TextSize = 14.000
        SettingsButtonText.TextXAlignment = Enum.TextXAlignment.Right

        SettingsButton.MouseButton1Click:Connect(function()
            pcall(callback)
            ClickEfect(SettingsButton)
        end)
    end


    SettingsHolder.Name = "SettingsHolder"
    SettingsHolder.Parent = SettingsFrame
    SettingsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsHolder.BackgroundTransparency = 1.000
    SettingsHolder.Position = UDim2.new(0.0161040146, 0, 0.129032314, 0)
    SettingsHolder.Size = UDim2.new(0, 481, 0, 234)

    SettingsContainer.Name = "SettingsContainer"
    SettingsContainer.Parent = SettingsHolder
    SettingsContainer.Active = true
    SettingsContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsContainer.BackgroundTransparency = 1.000
    SettingsContainer.BorderSizePixel = 0
    SettingsContainer.Size = UDim2.new(1, 0, 1, 0)
    SettingsContainer.ScrollBarThickness = 6

    SettingsContainerLayout.Name = "SettingsContainerLayout"
    SettingsContainerLayout.Parent = SettingsContainer
    SettingsContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SettingsContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SettingsContainerLayout.Padding = UDim.new(0, 7)

    SettingsContainerPadding.Name = "SettingsContainerPadding"
    SettingsContainerPadding.Parent = SettingsContainer
    SettingsContainerPadding.PaddingTop = UDim.new(0, 10)

    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = MainFrame
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SettingsFrame.Position = UDim2.new(0.137285501, 0, 0.23196882, 0)
    SettingsFrame.Size = UDim2.new(0, 494, 0, 275)
    SettingsFrame.Visible = false
    SettingsFrame.BackgroundTransparency = 1
    
    SettingsFrameCorner.Name = "SettingsFrameCorner"
    SettingsFrameCorner.Parent = SettingsFrame
    
    SettingsFrameItems.Name = "SettingsFrameItems"
    SettingsFrameItems.Parent = SettingsFrame
    SettingsFrameItems.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsFrameItems.BackgroundTransparency = 1.000
    SettingsFrameItems.Size = UDim2.new(0, 494, 0, 46)
    
    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Parent = SettingsFrameItems
    SettingsTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsTitle.BackgroundTransparency = 1.000
    SettingsTitle.Position = UDim2.new(0.41093117, 0, 0.217391312, 0)
    SettingsTitle.Size = UDim2.new(0, 87, 0, 17)
    SettingsTitle.Font = Enum.Font.Gotham
    SettingsTitle.Text = "Settings"
    SettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsTitle.TextSize = 20.000

    MainHolder:Bind("GUI KeyBind", Enum.KeyCode.RightShift, function(t)
        if t then
            MainFrame.Visible = false
        else
            MainFrame.Visible = true
        end
    end)

    MainHolder:Button("Discord Server", function()
        local req = (syn and syn.request) or (http and http.request) or http_request
        if req then
            req({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    Origin = 'https://discord.com'
                },
                Body = game:GetService('HttpService'):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = game:GetService('HttpService'):GenerateGUID(false),
                    args = {code = "frWQZ4qZHY"}
                })
            })
        end
    end)

    local TimeText = Instance.new("TextLabel")
    
    TimeText.Name = "TimeText"
    TimeText.Parent = MainFrameItemsHolder
    TimeText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TimeText.BackgroundTransparency = 1.000
    TimeText.Position = UDim2.new(0.86, 0, 0.0169491544, 0)
    TimeText.Size = UDim2.new(0, 56, 0, 17)
    TimeText.Font = Enum.Font.Gotham
    TimeText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TimeText.TextSize = 15.000
    TimeText.TextXAlignment = Enum.TextXAlignment.Left

    spawn(function()
        while task.wait(.1) do
            pcall(function()
                TimeText.Text = os.date('%X %p')
            end)
        end
    end)





    
    PluginsFrame.Name = "PluginsFrame"
    PluginsFrame.Parent = MainFrame
    PluginsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PluginsFrame.Position = UDim2.new(0.137285501, 0, 0.23196882, 0)
    PluginsFrame.Size = UDim2.new(0, 494, 0, 275)
    PluginsFrame.Visible = false
    PluginsFrame.BackgroundTransparency = 1
    
    PluginsFrameCorner.Name = "PluginsFrameCorner"
    PluginsFrameCorner.Parent = PluginsFrame
    
    PluginsFrameItems.Name = "PluginsFrameItems"
    PluginsFrameItems.Parent = PluginsFrame
    PluginsFrameItems.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PluginsFrameItems.BackgroundTransparency = 1.000
    PluginsFrameItems.Size = UDim2.new(0, 494, 0, 46)
    
    PluginsTitle.Name = "PluginsTitle"
    PluginsTitle.Parent = PluginsFrameItems
    PluginsTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PluginsTitle.BackgroundTransparency = 1.000
    PluginsTitle.Position = UDim2.new(0.41093117, 0, 0.217391312, 0)
    PluginsTitle.Size = UDim2.new(0, 87, 0, 17)
    PluginsTitle.Font = Enum.Font.Gotham
    PluginsTitle.Text = "Plugins"
    PluginsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    PluginsTitle.TextSize = 20.000
    
    PluginsFrameHolder.Name = "PluginsFrameHolder"
    PluginsFrameHolder.Parent = PluginsFrame
    PluginsFrameHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PluginsFrameHolder.BackgroundTransparency = 1.000
    PluginsFrameHolder.Position = UDim2.new(0.0161040146, 0, 0.129032314, 0)
    PluginsFrameHolder.Size = UDim2.new(0, 481, 0, 234)
    
    RemoteSpyButton.Name = "RemoteSpyButton"
    RemoteSpyButton.Parent = PluginsFrameHolder
    RemoteSpyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    RemoteSpyButton.Position = UDim2.new(0.048856549, 0, 0.145299152, 0)
    RemoteSpyButton.Size = UDim2.new(0, 136, 0, 70)
    RemoteSpyButton.Font = Enum.Font.Gotham
    RemoteSpyButton.Text = "Remote Spy"
    RemoteSpyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RemoteSpyButton.TextSize = 22.000
    RemoteSpyButton.TextWrapped = true

    RemoteSpyButton.MouseButton1Click:Connect(function()
        MainHolder:Notify("", "Loading Hydroxide...", 2)
        local owner = "Upbolt"
        local branch = "revision"
        
        local function webImport(file)
            return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
        end
        
        webImport("init")
        webImport("ui/main")
    end)
    
    RemoteSpyButtonCorner.CornerRadius = UDim.new(0, 6)
    RemoteSpyButtonCorner.Name = "RemoteSpyButtonCorner"
    RemoteSpyButtonCorner.Parent = RemoteSpyButton
    
    PluginsButton.Name = "PluginsButton"
    PluginsButton.Parent = PluginsFrameHolder
    PluginsButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    PluginsButton.Position = UDim2.new(0.666320145, 0, 0.145299152, 0)
    PluginsButton.Size = UDim2.new(0, 136, 0, 70)
    PluginsButton.Font = Enum.Font.Gotham
    PluginsButton.Text = "Plugins"
    PluginsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PluginsButton.TextSize = 22.000
    PluginsButton.TextWrapped = true

    PluginsButton.MouseButton1Click:Connect(function()
        MainHolder:Notify("", "Currently in development", 1.5)
    end)
    
    PluginsButtonCorner.CornerRadius = UDim.new(0, 6)
    PluginsButtonCorner.Name = "PluginsButtonCorner"
    PluginsButtonCorner.Parent = PluginsButton


    
    local Tabs = {}

    function Tabs:Tab(TabTitle)
        local Tab = Instance.new("TextButton")
        local Container = Instance.new("ScrollingFrame")
        local ContainerLayout = Instance.new("UIListLayout")

        Tab.Name = "Tab"
        Tab.Parent = TabsHolder
        Tab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Tab.BackgroundTransparency = 1.000
        Tab.Position = UDim2.new(0.0125195617, 0, 0.296875, 0)
        Tab.Size = UDim2.new(0, 49, 0, 21)
        Tab.Font = Enum.Font.Gotham
        Tab.Text = TabTitle
        Tab.TextColor3 = Color3.fromRGB(143, 143, 143) -- Color3.fromRGB(255, 255, 255)
        Tab.TextSize = 14.000
        
        Container.Name = "Container"
        Container.Parent = ContainerHold
        Container.Active = true
        Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Container.BackgroundTransparency = 1.000
        Container.BorderSizePixel = 0
        Container.Position = UDim2.new(0.0078247739, 0, 0.0166270789, 0)
        Container.Size = UDim2.new(0.98108089, 0, 0.966745853, 0)
        Container.ScrollBarThickness = 8
        Container.Visible = false

        spawn(function()
            wait(1.4)
        local SearchBox2 = SearchBox
        local v2 = {}
        function v2.gettext()
            return SearchBox2.Text
        end
        function v2.GetItems()
            return Container
        end

        SearchBox2.Changed:Connect(function()
           local search = string.lower(v2.gettext())
            for i,v in pairs(v2.GetItems():GetChildren()) do
                if v.ClassName == "TextButton" then
                 local item = string.lower(v.Name)
                    if string.find(item, search) and v.ClassName == "TextButton" then
                        v.Visible = true
                    else
                        v.Visible = false
                    end
                end
            end
        end)
    end)

    
        
        ContainerLayout.Name = "ContainerLayout"
        ContainerLayout.Parent = Container
        ContainerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContainerLayout.Padding = UDim.new(0, 14)

        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

        if FirstTab == false then
            FirstTab = true
            Container.Visible = true
            Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        Tab.MouseButton1Click:Connect(function()
            for i, v in next, TabsHolder:GetChildren() do
                if v.ClassName == "TextButton" then
                   TweenService:Create(
                      v,
                      TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                      {TextColor3 = Color3.fromRGB(143, 143, 143)}
                   ):Play()
                   TweenService:Create(
                      Tab,
                      TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                      {TextColor3 = Color3.fromRGB(255, 255, 255)}
                   ):Play()
                end
             end
             
             for i, v in next, ContainerHold:GetChildren() do
                if v.ClassName == "ScrollingFrame" then
                   v.Visible = false
                end
             end
 
             Container.Visible = true
        end)

        local ContainerItems = {}

        function ContainerItems:Button(Text, callback)
            local Button = Instance.new("TextButton")
            local ButtonCorner = Instance.new("UICorner")
            local ButtonText = Instance.new("TextLabel")

            Button.Name = Text
            Button.Parent = Container
            Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Button.Position = UDim2.new(0.0812800825, 0, 0, 0)
            Button.Size = UDim2.new(0, 465, 0, 36)
            Button.AutoButtonColor = false
            Button.Font = Enum.Font.Gotham
            Button.Text = ""
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14.000
            
            ButtonCorner.CornerRadius = UDim.new(0, 3)
            ButtonCorner.Name = "ButtonCorner"
            ButtonCorner.Parent = Button
            
            ButtonText.Name = "ButtonText"
            ButtonText.Parent = Button
            ButtonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ButtonText.BackgroundTransparency = 1.000
            ButtonText.Position = UDim2.new(0.0172043033, 0, 0.22580646, 0)
            ButtonText.Size = UDim2.new(0, 102, 0, 17)
            ButtonText.Font = Enum.Font.Gotham
            ButtonText.Text = Text
            ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonText.TextSize = 14.000
            ButtonText.TextXAlignment = Enum.TextXAlignment.Left

            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

            Button.MouseButton1Click:Connect(function()
                ClickEfect(Button)
            end)
            Button.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function ContainerItems:Toggle(Text, callback)
            local ToggleToggled = false

            local Toggle = Instance.new("TextButton")
            local ToggleCorner = Instance.new("UICorner")
            local ToggleText = Instance.new("TextLabel")
            local ToggleFrame = Instance.new("Frame")
            local ToggleFrameCorner = Instance.new("UICorner")
            local ToggleImage = Instance.new("ImageLabel")

            Toggle.Name = Text
            Toggle.Parent = Container
            Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Toggle.Position = UDim2.new(0.129133791, 0, 0.110565111, 0)
            Toggle.Size = UDim2.new(0, 465, 0, 36)
            Toggle.AutoButtonColor = false
            Toggle.Font = Enum.Font.Gotham
            Toggle.Text = ""
            Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            Toggle.TextSize = 14.000
            
            ToggleCorner.CornerRadius = UDim.new(0, 3)
            ToggleCorner.Name = "ToggleCorner"
            ToggleCorner.Parent = Toggle
            
            ToggleText.Name = "ToggleText"
            ToggleText.Parent = Toggle
            ToggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.BackgroundTransparency = 1.000
            ToggleText.Position = UDim2.new(0.0172043033, 0, 0.22580646, 0)
            ToggleText.Size = UDim2.new(0, 102, 0, 17)
            ToggleText.Font = Enum.Font.Gotham
            ToggleText.Text = Text
            ToggleText.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleText.TextSize = 14.000
            ToggleText.TextXAlignment = Enum.TextXAlignment.Left
            
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Parent = Toggle
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            ToggleFrame.Position = UDim2.new(0.918279529, 0, 0.152329743, 0)
            ToggleFrame.Size = UDim2.new(0, 28, 0, 24)
            
            ToggleFrameCorner.CornerRadius = UDim.new(0, 3)
            ToggleFrameCorner.Name = "ToggleFrameCorner"
            ToggleFrameCorner.Parent = ToggleFrame
            
            ToggleImage.Name = "ToggleImage"
            ToggleImage.Parent = ToggleFrame
            ToggleImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleImage.BackgroundTransparency = 1.000
            ToggleImage.Size = UDim2.new(1, 0, 1, 0)
            ToggleImage.Image = "rbxassetid://6031094667"
            ToggleImage.ImageTransparency = 1

            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

            Toggle.MouseButton1Click:Connect(function()
                if ToggleToggled == false then
                    TweenService:Create(
                        ToggleImage,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {ImageTransparency = 0}
                    ):Play()

                    TweenService:Create(
                        ToggleImage,
                        TweenInfo.new(.8, Enum.EasingStyle.Quad),
                        {Rotation = 360}
                    ):Play()
                else
                    TweenService:Create(
                        ToggleImage,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {ImageTransparency = 1}
                    ):Play()

                    TweenService:Create(
                        ToggleImage,
                        TweenInfo.new(.8, Enum.EasingStyle.Quad),
                        {Rotation = 0}
                    ):Play()
                end
                ToggleToggled = not ToggleToggled
                pcall(callback, ToggleToggled)
            end)
        end

        function ContainerItems:Slider(text, min, max, start, callback)
            local dragging = false

            local MaxConvertion = tostring(max)

            local Slider = Instance.new("TextButton")
            local SliderCorner = Instance.new("UICorner")
            local SliderText = Instance.new("TextLabel")
            local Value = Instance.new("TextBox")
            local SliderFrame = Instance.new("Frame")
            local SliderFrameCorner = Instance.new("UICorner")
            local SliderFrameIndicator = Instance.new("Frame")
            local SliderFrameIndicatorCorner = Instance.new("UICorner")

            Slider.Name = text
            Slider.Parent = Container
            Slider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Slider.Position = UDim2.new(0.129133791, 0, 0.24570024, 0)
            Slider.Size = UDim2.new(0, 465, 0, 50)
            Slider.AutoButtonColor = false
            Slider.Font = Enum.Font.Gotham
            Slider.Text = ""
            Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
            Slider.TextSize = 14.000
            
            SliderCorner.CornerRadius = UDim.new(0, 3)
            SliderCorner.Name = "SliderCorner"
            SliderCorner.Parent = Slider
            
            SliderText.Name = "SliderText"
            SliderText.Parent = Slider
            SliderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.BackgroundTransparency = 1.000
            SliderText.Position = UDim2.new(0.0172043033, 0, 0.173584253, 0)
            SliderText.Size = UDim2.new(0, 102, 0, 17)
            SliderText.Font = Enum.Font.Gotham
            SliderText.Text = text
            SliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderText.TextSize = 14.000
            SliderText.TextXAlignment = Enum.TextXAlignment.Left
            
            Value.Name = "Value"
            Value.Parent = Slider
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1.000
            Value.Position = UDim2.new(0.910000026, 0, 0.134000003, 0)
            Value.Size = UDim2.new(0, 34, 0, 17)
            Value.Font = Enum.Font.Gotham
            Value.Text = tostring(start and math.floor((start / max) * (max - min) + min) or 0)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 14.000
            Value.TextXAlignment = Enum.TextXAlignment.Right
            
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Parent = Slider
            SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            SliderFrame.Position = UDim2.new(0.0301075261, 0, 0.699999988, 0)
            SliderFrame.Size = UDim2.new(0, 437, 0, 6)
            
            SliderFrameCorner.CornerRadius = UDim.new(0, 3)
            SliderFrameCorner.Name = "SliderFrameCorner"
            SliderFrameCorner.Parent = SliderFrame
            
            SliderFrameIndicator.Name = "SliderFrameIndicator"
            SliderFrameIndicator.Parent = SliderFrame
            SliderFrameIndicator.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderFrameIndicator.Size = UDim2.new((start or 0) / max, 0, 0, 6)
            
            SliderFrameIndicatorCorner.CornerRadius = UDim.new(0, 3)
            SliderFrameIndicatorCorner.Name = "SliderFrameIndicatorCorner"
            SliderFrameIndicatorCorner.Parent = SliderFrameIndicator

            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

            local function slide(input)
                local pos =
                   UDim2.new(
                      math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1),
                      0,
                      0,
                      6
                   )
                   SliderFrameIndicator:TweenSize(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)
                local val = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
                Value.Text = tostring(val)
                pcall(callback, val)
             end
          
             SliderFrame.InputBegan:Connect(
                function(input)
                   if input.UserInputType == Enum.UserInputType.MouseButton1 then
                      slide(input)
                      dragging = true
                   end
                end
             )
          
             SliderFrame.InputEnded:Connect(
                function(input)
                   if input.UserInputType == Enum.UserInputType.MouseButton1 then
                      dragging = false
                   end
                end
             )
          
             UserInputService.InputChanged:Connect(
                function(input)
                   if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                      slide(input)
                   end
                end
             )

             Value.FocusLost:Connect(
                function(ep)
                   if ep then
                    if (tonumber(Value.Text) > max)  then
                        Value.Text = tostring(max)
                        pcall(callback, tostring(Value.Text))
                            TweenService:Create(
                                SliderFrameIndicator,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {Size = UDim2.new((tonumber(Value.Text)) / max, 0, 0, 6)}
                            ):Play()
                    else
                        pcall(callback, tostring(Value.Text))
                        TweenService:Create(
                            SliderFrameIndicator,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad),
                            {Size = UDim2.new((tonumber(Value.Text)) / max, 0, 0, 6)}
                        ):Play()
                    end
                    if (tonumber(Value.Text) < min) then
                        Value.Text = tostring(min)
                        pcall(callback, tostring(Value.Text))
                        TweenService:Create(
                            SliderFrameIndicator,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad),
                            {Size = UDim2.new((tonumber(Value.Text)) / max, 0, 0, 6)}
                        ):Play()
                    else
                        pcall(callback, tostring(Value.Text))
                        TweenService:Create(
                            SliderFrameIndicator,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad),
                            {Size = UDim2.new((tonumber(Value.Text)) / max, 0, 0, 6)}
                        ):Play()
                    end
                    if (tonumber(Value.Text) <= min) then
                        pcall(callback, tostring(Value.Text))
                        TweenService:Create(
                            SliderFrameIndicator,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad),
                            {Size = UDim2.new(0, 0, 0, 6)}
                        ):Play()
                    end
                   end
                end)
          
             Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)
          
             pcall(callback, tostring(Value.Text))
        end

        function ContainerItems:Dropdown(Text, list, callback)
            local dropToggled = false
            local dropfunc = {}


            local Dropdown = Instance.new("TextButton")
            local DropdownCorner = Instance.new("UICorner")
            local DropdownText = Instance.new("TextLabel")
            local Arrow = Instance.new("ImageLabel")
            local DropdownSearch = Instance.new("TextBox")
            local DropdownSearchCorner = Instance.new("UICorner")
            local DropdownFrame = Instance.new("Frame")
            local DropdownFrameLayout = Instance.new("UIListLayout")
            local Item = Instance.new("TextButton")
            local ItemCorner = Instance.new("UICorner")
            local DropdownFramePadding = Instance.new("UIPadding")

            Dropdown.Name = Text
            Dropdown.Parent = Container
            Dropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Dropdown.Position = UDim2.new(0.129133791, 0, 0.110565111, 0)
            Dropdown.Size = UDim2.new(0, 465, 0, 36)
            Dropdown.AutoButtonColor = false
            Dropdown.Font = Enum.Font.Gotham
            Dropdown.Text = ""
            Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            Dropdown.TextSize = 14.000
            
            DropdownCorner.CornerRadius = UDim.new(0, 3)
            DropdownCorner.Name = "DropdownCorner"
            DropdownCorner.Parent = Dropdown
            
            DropdownText.Name = "DropdownText"
            DropdownText.Parent = Dropdown
            DropdownText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownText.BackgroundTransparency = 1.000
            DropdownText.Position = UDim2.new(0.0172043033, 0, 0.253584236, 0)
            DropdownText.Size = UDim2.new(0, 102, 0, 17)
            DropdownText.Font = Enum.Font.Gotham
            DropdownText.Text = Text
            DropdownText.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownText.TextSize = 14.000
            DropdownText.TextXAlignment = Enum.TextXAlignment.Left
            
            Arrow.Name = "Arrow"
            Arrow.Parent = Dropdown
            Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Arrow.BackgroundTransparency = 1.000
            Arrow.Position = UDim2.new(0.918279409, 0, 0.198028564, 0)
            Arrow.Size = UDim2.new(0, 27, 0, 21)
            Arrow.Image = "rbxassetid://6034818372"
            Arrow.Rotation = 180
            
            DropdownSearch.Name = "DropdownSearch"
            DropdownSearch.Parent = Dropdown
            DropdownSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DropdownSearch.BackgroundTransparency = 1.000
            DropdownSearch.Position = UDim2.new(0.576343954, 0, 0.138888896, 0)
            DropdownSearch.Size = UDim2.new(0, 110, 0, 26)
            DropdownSearch.ClearTextOnFocus = false
            DropdownSearch.Font = Enum.Font.Gotham
            DropdownSearch.PlaceholderText = "Search"
            DropdownSearch.Text = ""
            DropdownSearch.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropdownSearch.TextSize = 14.000
            
            DropdownSearchCorner.CornerRadius = UDim.new(0, 3)
            DropdownSearchCorner.Name = "DropdownSearchCorner"
            DropdownSearchCorner.Parent = DropdownSearch
            
            DropdownFrame.Name = "DropdownFrame"
            DropdownFrame.Parent = Container
            DropdownFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            DropdownFrame.Position = UDim2.new(0.137109399, 0, 0.157248154, 0)
            DropdownFrame.Size = UDim2.new(0, 455, 0, 0) -- UDim2.new(0, 455, 0, 211)
            DropdownFrame.Visible = false
            DropdownFrame.BorderSizePixel = 0

            for i,v in pairs(DropdownFrame:GetChildren()) do
                if v.ClassName == "TextButton" then
                    v.BackgroundTransparency = 1
                    v.TextTransparency = 1
                end
            end
            
            DropdownFrameLayout.Name = "DropdownFrameLayout"
            DropdownFrameLayout.Parent = DropdownFrame
            DropdownFrameLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            DropdownFrameLayout.SortOrder = Enum.SortOrder.LayoutOrder
            DropdownFrameLayout.Padding = UDim.new(0, 7)
            
            DropdownFramePadding.Name = "DropdownFramePadding"
            DropdownFramePadding.Parent = DropdownFrame
            DropdownFramePadding.PaddingTop = UDim.new(0, 5)

            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

            Dropdown.MouseButton1Click:Connect(function()
                if dropToggled == false then
                    DropdownFrame.Visible = true
                    TweenService:Create(
                        Arrow,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {Rotation = 0}
                    ):Play()
                    TweenService:Create(
                        DropdownFrame,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {Size = UDim2.new(0, 455, 0, DropdownFrameLayout.AbsoluteContentSize.Y)}
                    ):Play()
                    repeat task.wait() 
                        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)
                    until DropdownFrame.Size == UDim2.new(0, 455, 0, DropdownFrameLayout.AbsoluteContentSize.Y)
                    for i,v in pairs(DropdownFrame:GetChildren()) do
                        if v.ClassName == "TextButton" then
                            TweenService:Create(
                                v,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {BackgroundTransparency = 0}
                            ):Play()
                            TweenService:Create(
                                v,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {TextTransparency = 0}
                            ):Play()
                        end
                    end
                else
                    for i,v in pairs(DropdownFrame:GetChildren()) do
                        if v.ClassName == "TextButton" then
                            TweenService:Create(
                                v,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {BackgroundTransparency = 1}
                            ):Play()
                            TweenService:Create(
                                v,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {TextTransparency = 1}
                            ):Play()
                        end
                    end
                    TweenService:Create(
                        Arrow,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {Rotation = 180}
                    ):Play()
                    TweenService:Create(
                        DropdownFrame,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {Size = UDim2.new(0, 455, 0, 0)}
                    ):Play()
                    repeat task.wait()
                        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)
                    until DropdownFrame.Size == UDim2.new(0, 455, 0, 0)
                    DropdownFrame.Visible = false
                end
                dropToggled = not dropToggled
            end)

            for i,v in pairs(list) do
                local Item = Instance.new("TextButton")
                local ItemCorner = Instance.new("UICorner")

                Item.Name = "Item"
                Item.Parent = DropdownFrame
                Item.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Item.Position = UDim2.new(-0.253846169, 0, 0, 0)
                Item.Size = UDim2.new(0, 443, 0, 30)
                Item.AutoButtonColor = false
                Item.Font = Enum.Font.Gotham
                Item.Text = v
                Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                Item.TextSize = 14.000
                
                ItemCorner.CornerRadius = UDim.new(0, 3)
                ItemCorner.Name = "ItemCorner"
                ItemCorner.Parent = Item

                Item.MouseButton1Click:Connect(function()
                    pcall(callback, Item.Text)
                    DropdownText.Text = Text.." - "..Item.Text

                    for i,v in pairs(DropdownFrame:GetChildren()) do
                        if v.ClassName == "TextButton" then
                            TweenService:Create(
                                v,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {BackgroundTransparency = 1}
                            ):Play()

                            TweenService:Create(
                                v,
                                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                {TextTransparency = 1}
                            ):Play()
                        end
                    end
                    TweenService:Create(
                        Arrow,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {Rotation = 180}
                    ):Play()
                    TweenService:Create(
                        DropdownFrame,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad),
                        {Size = UDim2.new(0, 455, 0, 0)}
                    ):Play()
                    repeat task.wait()
                        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)
                    until DropdownFrame.Size == UDim2.new(0, 455, 0, 0)
                    DropdownFrame.Visible = false
                    dropToggled = not dropToggled
                end)
            end

            function dropfunc:Refresh(newlist)

                for i,v in pairs(DropdownFrame:GetChildren()) do
                    if v.Name == "Item" then
                        v:Destroy()
                    end
                end

                for i,v in next, newlist do
                    local Item = Instance.new("TextButton")
                    local ItemCorner = Instance.new("UICorner")
    
                    Item.Name = "Item"
                    Item.Parent = DropdownFrame
                    Item.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    Item.Position = UDim2.new(0, 0, 0, 0)
                    Item.Size = UDim2.new(0, 443, 0, 30)
                    Item.AutoButtonColor = false
                    Item.Font = Enum.Font.Gotham
                    Item.Text = v
                    Item.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Item.TextSize = 14.000
                    
                    ItemCorner.CornerRadius = UDim.new(0, 3)
                    ItemCorner.Name = "ItemCorner"
                    ItemCorner.Parent = Item
    
                    Item.MouseButton1Click:Connect(function()
                        pcall(callback, Item.Text)
                        DropdownText.Text = Text.." - "..Item.Text
    
                        for i,v in pairs(DropdownFrame:GetChildren()) do
                            if v.ClassName == "TextButton" then
                                TweenService:Create(
                                    v,
                                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                    {BackgroundTransparency = 1}
                                ):Play()
    
                                TweenService:Create(
                                    v,
                                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                                    {TextTransparency = 1}
                                ):Play()
                            end
                        end
                        TweenService:Create(
                            Arrow,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad),
                            {Rotation = 180}
                        ):Play()
                        TweenService:Create(
                            DropdownFrame,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad),
                            {Size = UDim2.new(0, 455, 0, 0)}
                        ):Play()
                        repeat task.wait()
                        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)
                        until DropdownFrame.Size == UDim2.new(0, 455, 0, 0)
                        DropdownFrame.Visible = false
                        dropToggled = not dropToggled
                    end)
                end
            end
            return dropfunc
        end

        function ContainerItems:Label(text)
            local Labelfunc = {}
            local Label = Instance.new("TextButton")
            local LabelCorner = Instance.new("UICorner")
            local LabelText = Instance.new("TextLabel")

            Label.Name = "____" or "Label"
            Label.Parent = Container
            Label.Active = false
            Label.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Label.Position = UDim2.new(0.0812800825, 0, 0, 0)
            Label.Size = UDim2.new(0, 465, 0, 36)
            Label.AutoButtonColor = false
            Label.Font = Enum.Font.Gotham
            Label.Text = ""
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14.000
            
            LabelCorner.CornerRadius = UDim.new(0, 3)
            LabelCorner.Name = "LabelCorner"
            LabelCorner.Parent = Label
            
            LabelText.Name = "LabelText"
            LabelText.Parent = Label
            LabelText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.BackgroundTransparency = 1.000
            LabelText.Position = UDim2.new(0.0172043033, 0, 0.253584236, 0)
            LabelText.Size = UDim2.new(0, 102, 0, 17)
            LabelText.Font = Enum.Font.Gotham
            LabelText.Text = text
            LabelText.TextColor3 = Color3.fromRGB(255, 255, 255)
            LabelText.TextSize = 14.000
            LabelText.TextXAlignment = Enum.TextXAlignment.Left

            Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

            function Labelfunc:Refresh(newText)
                LabelText.Text = newText
            end
            return Labelfunc
        end

        function ContainerItems:TextBox(Text, callback)
        local TextBox = Instance.new("TextButton")
        local TextBoxCorner = Instance.new("UICorner")
        local TextBoxText = Instance.new("TextLabel")
        local Box = Instance.new("TextBox")
        local BoxCorner = Instance.new("UICorner")

        TextBox.Name = Text
        TextBox.Parent = Container
        TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TextBox.Position = UDim2.new(0.0812800825, 0, 0, 0)
        TextBox.Size = UDim2.new(0, 465, 0, 36)
        TextBox.AutoButtonColor = false
        TextBox.Font = Enum.Font.Gotham
        TextBox.Text = ""
        TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBox.TextSize = 14.000

        TextBoxCorner.CornerRadius = UDim.new(0, 3)
        TextBoxCorner.Name = "TextBoxCorner"
        TextBoxCorner.Parent = TextBox

        TextBoxText.Name = "TextBoxText"
        TextBoxText.Parent = TextBox
        TextBoxText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextBoxText.BackgroundTransparency = 1.000
        TextBoxText.Position = UDim2.new(9.31322575e-10, 0, 0.253584236, 0)
        TextBoxText.Size = UDim2.new(0, 102, 0, 17)
        TextBoxText.Font = Enum.Font.Gotham
        TextBoxText.Text = Text
        TextBoxText.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextBoxText.TextSize = 14.000

        Box.Name = "Box"
        Box.Parent = TextBox
        Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Box.Position = UDim2.new(0.561290324, 0, 0.111111112, 0)
        Box.Size = UDim2.new(0, 157, 0, 27)
        Box.Font = Enum.Font.Gotham
        Box.Text = ""
        Box.TextColor3 = Color3.fromRGB(255,255,255)
        Box.TextSize = 14.000

        BoxCorner.CornerRadius = UDim.new(0, 3)
        BoxCorner.Name = "BoxCorner"
        BoxCorner.Parent = Box

        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)

        Box.Focused:Connect(function()
            TweenService:Create(
                Box,
                TweenInfo.new(.3, Enum.EasingStyle.Quad),
                {Size = UDim2.new(0, 176, 0, 27)}
            ):Play()
        end)

            Box.FocusLost:Connect(function()
                pcall(callback, Box.Text)
                TweenService:Create(
                    Box,
                    TweenInfo.new(.3, Enum.EasingStyle.Quad),
                    {Size = UDim2.new(0, 157, 0, 27)}
                ):Play()
            end)
        end

        function ContainerItems:KeyBind(text, presetbind, callback)
            local Key = presetbind.Name
            local binding = false

        local Bind = Instance.new("TextButton")
        local BindCorner = Instance.new("UICorner")
        local BindText = Instance.new("TextLabel")
        local BindBox = Instance.new("TextLabel")
        local BindBoxCorner = Instance.new("UICorner")

        Bind.Name = text or "Bind"
        Bind.Parent = Container
        Bind.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Bind.Position = UDim2.new(0.0812800825, 0, 0, 0)
        Bind.Size = UDim2.new(0, 465, 0, 36)
        Bind.AutoButtonColor = false
        Bind.Font = Enum.Font.Gotham
        Bind.Text = ""
        Bind.TextColor3 = Color3.fromRGB(255, 255, 255)
        Bind.TextSize = 14.000

        BindCorner.CornerRadius = UDim.new(0, 3)
        BindCorner.Name = "BindCorner"
        BindCorner.Parent = Bind

        BindText.Name = "BindText"
        BindText.Parent = Bind
        BindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BindText.BackgroundTransparency = 1.000
        BindText.Position = UDim2.new(9.31322575e-10, 0, 0.253584236, 0)
        BindText.Size = UDim2.new(0, 102, 0, 17)
        BindText.Font = Enum.Font.Gotham
        BindText.Text = text
        BindText.TextColor3 = Color3.fromRGB(255, 255, 255)
        BindText.TextSize = 14.000

        BindBox.Name = "BindBox"
        BindBox.Parent = Bind
        BindBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        BindBox.Position = UDim2.new(0.56099999, 0, 0.111000001, 0)
        BindBox.Size = UDim2.new(0, 176, 0, 27)
        BindBox.Font = Enum.Font.Gotham
        BindBox.Text = Key
        BindBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        BindBox.TextSize = 14.000

        BindBoxCorner.CornerRadius = UDim.new(0, 3)
        BindBoxCorner.Name = "BindBoxCorner"
        BindBoxCorner.Parent = BindBox

        Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 5)
 
        Bind.MouseButton1Click:Connect(function()
            BindBox.Text = "..."
            local inputwait = game:GetService("UserInputService").InputBegan:wait()
            if inputwait.KeyCode.Name ~= "Unknown" then
                BindBox.Text = inputwait.KeyCode.Name
               Key = inputwait.KeyCode.Name
               return
            end
         end)
         
         local KeyToggled = true
         game:GetService("UserInputService").InputBegan:connect(function(current, pressed)
            if not pressed then
               if current.KeyCode.Name == Key then
                if KeyToggled ~= false then
                  pcall(callback, KeyToggled)
                else
                   pcall(callback, KeyToggled)
                end
                KeyToggled = not KeyToggled
               end
            end
         end)
        end

        function ContainerItems:line()
            local Line = Instance.new("TextButton")
            local LineCorner = Instance.new("UICorner")
            
            Line.Name = "Line"
            Line.Parent = Container
            Line.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            Line.Position = UDim2.new(0.340487659, 0, 0.5257985, 0)
            Line.Size = UDim2.new(0, 465, 0, 15)
            Line.AutoButtonColor = false
            Line.Font = Enum.Font.SourceSans
            Line.Text = ""
            Line.TextColor3 = Color3.fromRGB(0, 0, 0)
            Line.TextSize = 14.000
            
            LineCorner.CornerRadius = UDim.new(0, 3)
            LineCorner.Name = "LineCorner"
            LineCorner.Parent = Line
        end
        return ContainerItems
    end
    return Tabs
end

return MainHolder
