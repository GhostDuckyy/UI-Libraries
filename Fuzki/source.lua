local FuzkiLib = {}

function FuzkiLib:Create(name, gameName)
    name = name or "Name"
    gameName = gameName or "Game Name"
    local InsideFuzki = {}

    local Fuzki = Instance.new("ScreenGui")
    local MainLib = Instance.new("Frame")
    local headerLine = Instance.new("Frame")
    local mainCorner = Instance.new("UICorner")
    local tabMain = Instance.new("Frame")
    local tabFrame = Instance.new("Frame")
    local tabList = Instance.new("UIListLayout")
    local lineTab = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local elements = Instance.new("Frame")
    local elementsCorner = Instance.new("UICorner")
    local elementFolder = Instance.new("Folder")

    Fuzki.Name = "name"
    Fuzki.Parent = game.CoreGui
    Fuzki.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    MainLib.Name = "MainLib"
    MainLib.Parent = Fuzki
    MainLib.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainLib.Position = UDim2.new(0.357499987, 0, 0.162544176, 0)
    MainLib.Size = UDim2.new(0, 469, 0, 484)

    headerLine.Name = "headerLine"
    headerLine.Parent = MainLib
    headerLine.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    headerLine.BorderSizePixel = 0
    headerLine.Position = UDim2.new(0, 0, 0.0909090936, 0)
    headerLine.Size = UDim2.new(0, 469, 0, 1)

    mainCorner.Name = "mainCorner"
    mainCorner.Parent = MainLib

    tabMain.Name = "tabMain"
    tabMain.Parent = MainLib
    tabMain.BackgroundColor3 = Color3.fromRGB(117, 117, 117)
    tabMain.BackgroundTransparency = 1.000
    tabMain.BorderSizePixel = 0
    tabMain.Position = UDim2.new(0.0362473354, 0, 0.111570247, 0)
    tabMain.Size = UDim2.new(0, 435, 0, 36)

    tabFrame.Name = "tabFrame"
    tabFrame.Parent = tabMain
    tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrame.BackgroundTransparency = 1.000
    tabFrame.Size = UDim2.new(0, 435, 0, 36)

    tabList.Name = "tabList"
    tabList.Parent = tabFrame
    tabList.FillDirection = Enum.FillDirection.Horizontal
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    tabList.Padding = UDim.new(0, 1)

    lineTab.Name = "lineTab"
    lineTab.Parent = tabMain
    lineTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    lineTab.BorderSizePixel = 0
    lineTab.Position = UDim2.new(0, 0, 0.972222209, 0)
    lineTab.Size = UDim2.new(0, 435, 0, 1)

    local UserInputService = game:GetService("UserInputService")

    local TopBar = MainLib

    local Camera = workspace:WaitForChild("Camera")

    local DragMousePosition
    local FramePosition
    local Draggable = false
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = true
            DragMousePosition = Vector2.new(input.Position.X, input.Position.Y)
            FramePosition = Vector2.new(MainLib.Position.X.Scale, MainLib.Position.Y.Scale)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Draggable == true then
            local NewPosition = FramePosition + ((Vector2.new(input.Position.X, input.Position.Y) - DragMousePosition) / Camera.ViewportSize)
            MainLib.Position = UDim2.new(NewPosition.X, 0, NewPosition.Y, 0)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Draggable = false
        end
    end)

    title.Name = "title"
    title.Parent = MainLib
    title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1.000
    title.Position = UDim2.new(0.0362473354, 0, 0, 0)
    title.Size = UDim2.new(0, 200, 0, 44)
    title.Font = Enum.Font.GothamSemibold
    title.Text = name.." : "..gameName
    title.TextColor3 = Color3.fromRGB(212, 212, 212)
    title.TextSize = 18.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    elements.Name = "elements"
    elements.Parent = MainLib
    elements.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    elements.BorderSizePixel = 0
    elements.ClipsDescendants = true
    elements.Position = UDim2.new(0.0362473354, 0, 0.198347107, 0)
    elements.Size = UDim2.new(0, 435, 0, 372)

    elementsCorner.CornerRadius = UDim.new(0, 3)
    elementsCorner.Name = "elementsCorner"
    elementsCorner.Parent = elements

    elementFolder.Name = "elementFolder"
    elementFolder.Parent = elements

    function InsideFuzki:CreateSection(tab)
        tab = tab or "tab"
        local tabButton = Instance.new("TextButton")
        local tabCorner = Instance.new("UICorner")
        local elementContainer = Instance.new("ScrollingFrame")
        local elementList = Instance.new("UIListLayout")

        tabButton.Name = "tabButton"..tab
        tabButton.Parent = tabFrame
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.Position = UDim2.new(0.800000012, 0, 0.194444448, 0)
        tabButton.Size = UDim2.new(0, 86, 0, 29)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.TextColor3 = Color3.fromRGB(218, 218, 218)
        tabButton.TextSize = 14.000
        tabButton.Text = tab

        tabCorner.CornerRadius = UDim.new(0, 3)
        tabCorner.Name = "tabCorner"
        tabCorner.Parent = tabButton

        elementContainer.Name = tab.."elementContainer"
        elementContainer.Parent = elementFolder
        elementContainer.Active = true
        elementContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        elementContainer.BackgroundTransparency = 1.000
        elementContainer.Size = UDim2.new(0, 435, 0, 372)
        elementContainer.CanvasSize = UDim2.new(0, 0, 15, 0)
        elementContainer.ScrollBarThickness = 0
        elementContainer.Visible = false    

        elementList.Name = "elementList"
        elementList.Parent = elementContainer
        elementList.SortOrder = Enum.SortOrder.LayoutOrder

        tabButton.MouseButton1Click:Connect(function()
            for i,v in next, elementFolder:GetChildren() do
                v.Visible = false
            end
            for i,v in next, tabFrame:GetChildren() do
                if v:IsA("TextButton") then
                    v.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
                end
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
            elementContainer.Visible = true
        end)
        local Items = {}

        function Items:CreateLabel(text)
            local textLabelFrame = Instance.new("Frame")
            local TextLabel = Instance.new("TextLabel")
            local tglLine = Instance.new("Frame")

            textLabelFrame.Name = "textLabelFrame"
            textLabelFrame.Parent = elementContainer
            textLabelFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabelFrame.BackgroundTransparency = 1.000
            textLabelFrame.Size = UDim2.new(0, 435, 0, 50)

            TextLabel.Parent = textLabelFrame
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(0.0390804596, 0, 0, 0)
            TextLabel.Size = UDim2.new(0, 398, 0, 49)
            TextLabel.Font = Enum.Font.GothamSemibold
            TextLabel.Text = text
            TextLabel.TextColor3 = Color3.fromRGB(212, 212, 212)
            TextLabel.TextSize = 16.000

            tglLine.Name = "tglLine"
            tglLine.Parent = textLabelFrame
            tglLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            tglLine.BorderSizePixel = 0
            tglLine.Position = UDim2.new(0.0390804596, 0, 0.980000019, 0)
            tglLine.Size = UDim2.new(0, 401, 0, 1)
        end
        function Items:CreateButton(text, info, callback)
            text = text or "Button Epic"
            info = info or "Epic Info"
            callback = callback or function() end
        
            local buttonFrame = Instance.new("Frame")
            local btnLine = Instance.new("Frame")
            local btnInfo = Instance.new("TextLabel")
            local TextButton = Instance.new("TextButton")
            local buttonCorner = Instance.new("UICorner")

            buttonFrame.Name = "buttonFrame"
            buttonFrame.Parent = elementContainer
            buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonFrame.BackgroundTransparency = 1.000
            buttonFrame.Size = UDim2.new(0, 435, 0, 50)

            btnLine.Name = "btnLine"
            btnLine.Parent = buttonFrame
            btnLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btnLine.BorderSizePixel = 0
            btnLine.Position = UDim2.new(0.0390804596, 0, 0.980000019, 0)
            btnLine.Size = UDim2.new(0, 401, 0, 1)

            btnInfo.Name = "btnInfo"
            btnInfo.Parent = buttonFrame
            btnInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btnInfo.BackgroundTransparency = 1.000
            btnInfo.Position = UDim2.new(0.0390804596, 0, 0, 0)
            btnInfo.Size = UDim2.new(0, 210, 0, 49)
            btnInfo.Font = Enum.Font.GothamSemibold
            btnInfo.Text = info
            btnInfo.TextColor3 = Color3.fromRGB(212, 212, 212)
            btnInfo.TextSize = 16.000
            btnInfo.TextXAlignment = Enum.TextXAlignment.Left

            TextButton.Parent = buttonFrame
            TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            TextButton.BorderSizePixel = 0
            TextButton.Position = UDim2.new(0.666666687, 0, 0.180000007, 0)
            TextButton.Size = UDim2.new(0, 128, 0, 30)
            TextButton.Font = Enum.Font.GothamSemibold
            TextButton.TextColor3 = Color3.fromRGB(212, 212, 212)
            TextButton.TextSize = 14.000
            TextButton.Text = text

            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Name = "buttonCorner"
            buttonCorner.Parent = TextButton

            TextButton.MouseButton1Click:Connect(function()
                callback()
            end)
            end

            function Items:CreateToggle(info, callback)
                toggle = toggle or "Toggle"
                info = info or "Info"
                callback = callback or function() end

                local toggleFrame = Instance.new("Frame")
                local tglLine = Instance.new("Frame")
                local toggleInfo = Instance.new("TextLabel")
                local toggle = Instance.new("Frame")
                local toggleCorner = Instance.new("UICorner")
                local toggleBtn = Instance.new("TextButton")
                local togCorner = Instance.new("UICorner")

                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = elementContainer
                toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleFrame.BackgroundTransparency = 1.000
                toggleFrame.Size = UDim2.new(0, 435, 0, 50)

                tglLine.Name = "tglLine"
                tglLine.Parent = toggleFrame
                tglLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                tglLine.BorderSizePixel = 0
                tglLine.Position = UDim2.new(0.0390804596, 0, 0.980000019, 0)
                tglLine.Size = UDim2.new(0, 401, 0, 1)

                toggleInfo.Name = "toggleInfo"
                toggleInfo.Parent = toggleFrame
                toggleInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleInfo.BackgroundTransparency = 1.000
                toggleInfo.Position = UDim2.new(0.0390804596, 0, 0, 0)
                toggleInfo.Size = UDim2.new(0, 210, 0, 49)
                toggleInfo.Font = Enum.Font.GothamSemibold
                toggleInfo.Text = info
                toggleInfo.TextColor3 = Color3.fromRGB(212, 212, 212)
                toggleInfo.TextSize = 16.000
                toggleInfo.TextXAlignment = Enum.TextXAlignment.Left

                toggle.Name = "toggle"
                toggle.Parent = toggleFrame
                toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                toggle.Position = UDim2.new(0.891954064, 0, 0.180000007, 0)
                toggle.Size = UDim2.new(0, 30, 0, 30)

                toggleCorner.CornerRadius = UDim.new(0, 3)
                toggleCorner.Name = "toggleCorner"
                toggleCorner.Parent = toggle

                toggleBtn.Name = "toggleBtn"
                toggleBtn.Parent = toggle
                toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Position = UDim2.new(0.060919337, 0, 0.0666666627, 0)
                toggleBtn.Size = UDim2.new(0, 26, 0, 26)
                toggleBtn.Font = Enum.Font.GothamSemibold
                toggleBtn.Text = ""
                toggleBtn.TextColor3 = Color3.fromRGB(212, 212, 212)
                toggleBtn.TextSize = 14.000

                togCorner.CornerRadius = UDim.new(0, 3)
                togCorner.Name = "togCorner"
                togCorner.Parent = toggleBtn

                
                local tog = false
                local ts = game:GetService("TweenService")
                local tsInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

                local off = {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                }
                local on = {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                }

                local playon = ts:Create(toggleBtn,tsInfo, on)
                local playoff = ts:Create(toggleBtn,tsInfo, off)
                toggleBtn.MouseButton1Click:Connect(function()
                    tog = not tog
                    callback(tog)
                    if tog then
                        playon:Play()
                    else
                        playoff:Play()
                    end
                end)
            end
        function Items:CreateBind(info, first, callback)
            info = info or "Info"
            callback = callback or function() end
            local oldKey = first.Name

            local keybindFrame = Instance.new("Frame")
            local tglLine = Instance.new("Frame")
            local bindInf = Instance.new("TextLabel")
            local keybindBtn = Instance.new("TextButton")
            local bindCorner = Instance.new("UICorner")

            keybindFrame.Name = "keybindFrame"
            keybindFrame.Parent = elementContainer
            keybindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            keybindFrame.BackgroundTransparency = 1.000
            keybindFrame.Size = UDim2.new(0, 435, 0, 50)

            tglLine.Name = "tglLine"
            tglLine.Parent = keybindFrame
            tglLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            tglLine.BorderSizePixel = 0
            tglLine.Position = UDim2.new(0.0390804596, 0, 0.980000019, 0)
            tglLine.Size = UDim2.new(0, 401, 0, 1)

            bindInf.Name = info
            bindInf.Parent = keybindFrame
            bindInf.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            bindInf.BackgroundTransparency = 1.000
            bindInf.Position = UDim2.new(0.0390804596, 0, 0, 0)
            bindInf.Size = UDim2.new(0, 210, 0, 49)
            bindInf.Font = Enum.Font.GothamSemibold
            bindInf.Text = "Keybind Info"
            bindInf.TextColor3 = Color3.fromRGB(212, 212, 212)
            bindInf.TextSize = 16.000
            bindInf.TextXAlignment = Enum.TextXAlignment.Left

            keybindBtn.Name = "keybindBtn"
            keybindBtn.Parent = keybindFrame
            keybindBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            keybindBtn.BorderSizePixel = 0
            keybindBtn.Position = UDim2.new(0.891954005, 0, 0.180000007, 0)
            keybindBtn.Size = UDim2.new(0, 30, 0, 30)
            keybindBtn.Font = Enum.Font.GothamSemibold
            keybindBtn.Text = oldKey
            keybindBtn.TextColor3 = Color3.fromRGB(212, 212, 212)
            keybindBtn.TextSize = 14.000

            bindCorner.CornerRadius = UDim.new(0, 3)
            bindCorner.Name = "bindCorner"
            bindCorner.Parent = keybindBtn

            keybindBtn.MouseButton1Click:connect(function(e) 
                keybindBtn.Text = "..."
                local a, b = game:GetService('UserInputService').InputBegan:wait();
                if a.KeyCode.Name ~= "Unknown" then
                    keybindBtn.Text = a.KeyCode.Name
                    oldKey = a.KeyCode.Name;
                end
            end)
    
            game:GetService("UserInputService").InputBegan:connect(function(current, ok) 
                if not ok then 
                    if current.KeyCode.Name == oldKey then 
                        callback()
                    end
                end
            end)
        end
        function Items:CreateTextBox(info, placeholder, callback)
            info = info or "Info"
            placeholder = placeholder or "Type Here"
            callback = callback or function() end

            local textBoxFrame = Instance.new("Frame")
            local btnLine = Instance.new("Frame")
            local textboxInfo = Instance.new("TextLabel")
            local textBoxout = Instance.new("Frame")
            local buttonCorner = Instance.new("UICorner")
            local TextBox = Instance.new("TextBox")

            textBoxFrame.Name = "textBoxFrame"
            textBoxFrame.Parent = elementContainer
            textBoxFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textBoxFrame.BackgroundTransparency = 1.000
            textBoxFrame.Size = UDim2.new(0, 435, 0, 50)

            btnLine.Name = "btnLine"
            btnLine.Parent = textBoxFrame
            btnLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btnLine.BorderSizePixel = 0
            btnLine.Position = UDim2.new(0.0390804596, 0, 0.980000019, 0)
            btnLine.Size = UDim2.new(0, 401, 0, 1)

            textboxInfo.Name = "textboxInfo"
            textboxInfo.Parent = textBoxFrame
            textboxInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textboxInfo.BackgroundTransparency = 1.000
            textboxInfo.Position = UDim2.new(0.0390804596, 0, 0, 0)
            textboxInfo.Size = UDim2.new(0, 210, 0, 49)
            textboxInfo.Font = Enum.Font.GothamSemibold
            textboxInfo.Text = info
            textboxInfo.TextColor3 = Color3.fromRGB(212, 212, 212)
            textboxInfo.TextSize = 16.000
            textboxInfo.TextXAlignment = Enum.TextXAlignment.Left

            textBoxout.Name = "textBoxout"
            textBoxout.Parent = textBoxFrame
            textBoxout.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            textBoxout.ClipsDescendants = true
            textBoxout.Position = UDim2.new(0.666666687, 0, 0.180000007, 0)
            textBoxout.Size = UDim2.new(0, 128, 0, 30)

            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Name = "buttonCorner"
            buttonCorner.Parent = textBoxout

            TextBox.Parent = textBoxout
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.BackgroundTransparency = 1.000
            TextBox.Size = UDim2.new(0, 128, 0, 30)
            TextBox.Font = Enum.Font.GothamSemibold
            TextBox.PlaceholderColor3 = Color3.fromRGB(212, 212, 212)
            TextBox.PlaceholderText = placeholder
            TextBox.Text = ""
            TextBox.TextColor3 = Color3.fromRGB(212, 212, 212)
            TextBox.TextSize = 14.000

            TextBox.FocusLost:Connect(function(EnterPressed)
                if not EnterPressed then return end
                callback(TextBox.Text)
                TextBox.Text = ""
            end)
        end
        function Items:CreateSlider(minvalue, maxvalue, info, callback)
            minvalue = minvalue or 0
            maxvalue = maxvalue or 500
            callback = callback or function() end

            local sliderFrame = Instance.new("Frame")
            local btnLine = Instance.new("Frame")
            local sliderInfo = Instance.new("TextLabel")
            local sliderBtn = Instance.new("TextButton")
            local sliderCorner = Instance.new("UICorner")
            local Frame = Instance.new("Frame")
            local buttonCorner = Instance.new("UICorner")
            local sliderVal = Instance.new("TextLabel")


            sliderFrame.Name = "sliderFrame"
            sliderFrame.Parent = elementContainer
            sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderFrame.BackgroundTransparency = 1.000
            sliderFrame.Size = UDim2.new(0, 435, 0, 50)

            btnLine.Name = "btnLine"
            btnLine.Parent = sliderFrame
            btnLine.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            btnLine.BorderSizePixel = 0
            btnLine.Position = UDim2.new(0.0390804596, 0, 0.980000019, 0)
            btnLine.Size = UDim2.new(0, 401, 0, 1)

            sliderInfo.Name = "sliderInfo"
            sliderInfo.Parent = sliderFrame
            sliderInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderInfo.BackgroundTransparency = 1.000
            sliderInfo.Position = UDim2.new(0.0390804596, 0, 0, 0)
            sliderInfo.Size = UDim2.new(0, 200, 0, 49)
            sliderInfo.Font = Enum.Font.GothamSemibold
            sliderInfo.Text = info
            sliderInfo.TextColor3 = Color3.fromRGB(212, 212, 212)
            sliderInfo.TextSize = 16.000
            sliderInfo.TextXAlignment = Enum.TextXAlignment.Left

            sliderBtn.Name = "sliderBtn"
            sliderBtn.Parent = sliderFrame
            sliderBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            sliderBtn.BorderSizePixel = 0
            sliderBtn.Position = UDim2.new(0.666666687, 0, 0.379999995, 0)
            sliderBtn.Size = UDim2.new(0, 128, 0, 10)
            sliderBtn.Font = Enum.Font.GothamSemibold
            sliderBtn.Text = ""
            sliderBtn.TextColor3 = Color3.fromRGB(212, 212, 212)
            sliderBtn.TextSize = 14.000

            sliderCorner.CornerRadius = UDim.new(0, 3)
            sliderCorner.Name = "sliderCorner"
            sliderCorner.Parent = sliderBtn

            Frame.Parent = sliderBtn
            Frame.BackgroundColor3 = Color3.fromRGB(212, 212, 212)
            Frame.Size = UDim2.new(0, 15, 0, 10)

            buttonCorner.CornerRadius = UDim.new(0, 3)
            buttonCorner.Name = "buttonCorner"
            buttonCorner.Parent = Frame

            sliderVal.Name = "sliderVal"
            sliderVal.Parent = sliderFrame
            sliderVal.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderVal.BackgroundTransparency = 1.000
            sliderVal.Position = UDim2.new(0.459770113, 0, -0.0199999996, 0)
            sliderVal.Size = UDim2.new(0, 80, 0, 49)
            sliderVal.Font = Enum.Font.GothamSemibold
            sliderVal.Text = minvalue.."/"..maxvalue
            sliderVal.TextColor3 = Color3.fromRGB(212, 212, 212)
            sliderVal.TextSize = 16.000
            sliderVal.TextXAlignment = Enum.TextXAlignment.Right

            local mouse = game.Players.LocalPlayer:GetMouse()
            local uis = game:GetService("UserInputService")
            local Value;

            sliderBtn.MouseButton1Down:Connect(function()
                Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 128) * Frame.AbsoluteSize.X) + tonumber(minvalue)) or 0
                pcall(function()
                    callback(Value)
                end)
                Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, 128), 0, 10)
                moveconnection = mouse.Move:Connect(function()
                    sliderVal.Text = Value.."/"..maxvalue
                    Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 128) * Frame.AbsoluteSize.X) + tonumber(minvalue))
                    pcall(function()
                        callback(Value)
                    end)
                    Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, 128), 0, 10)
                end)
                releaseconnection = uis.InputEnded:Connect(function(Mouse)
                    if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                        Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 128) * Frame.AbsoluteSize.X) + tonumber(minvalue))
                        pcall(function()
                            callback(Value)
                        end)
                        Frame.Size = UDim2.new(0, math.clamp(mouse.X - Frame.AbsolutePosition.X, 0, 128), 0, 10)
                        moveconnection:Disconnect()
                        releaseconnection:Disconnect()
                    end
                end)
            end)
        end
    return Items
    end
    return InsideFuzki
end
return FuzkiLib
