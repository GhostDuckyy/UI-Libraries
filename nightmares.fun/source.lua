local Fun = {}

local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new



function Fun:DraggingEnabled(frame, parent)
	
    parent = parent or frame
    
    -- stolen from wally or kiriot, kek
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    input.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end


function Fun.Create(title)
    local nightmarefun = Instance.new("ScreenGui")
    local Shadow = Instance.new("ImageLabel")
    local mainFrame = Instance.new("Frame")
    local mainCorner = Instance.new("UICorner")
    local mainSide = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local nightmares = Instance.new("TextLabel")
    local fun = Instance.new("TextLabel")
    local cover = Instance.new("Frame")
    local allTabs = Instance.new("Frame")
    local tabList = Instance.new("UIListLayout")
    local allPages = Instance.new("Frame")
    local pages = Instance.new("Folder")

    Fun:DraggingEnabled(mainFrame, Shadow)
    nightmarefun.Name = "nightmarefun"
    nightmarefun.Parent = game.CoreGui
    nightmarefun.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    nightmarefun.ResetOnSpawn = false

    Shadow.Name = "Shadow"
    Shadow.Parent = nightmarefun
    Shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Shadow.BackgroundTransparency = 1.000
    Shadow.Position = UDim2.new(0.349795759, 0, 0.171759665, 0)
    Shadow.Size = UDim2.new(0, 525, 0, 468)
    Shadow.Image = "http://www.roblox.com/asset/?id=6105530152"
    Shadow.ImageColor3 = Color3.fromRGB(18, 18, 18)

    mainFrame.Name = "mainFrame"
    mainFrame.Parent = Shadow
    mainFrame.BackgroundColor3 = Color3.fromRGB(47, 47, 56)
    mainFrame.Position = UDim2.new(0.0500000007, 0, 0.0780000016, 0)
    mainFrame.Size = UDim2.new(0, 475, 0, 396)

    mainCorner.CornerRadius = UDim.new(0, 6)
    mainCorner.Name = "mainCorner"
    mainCorner.Parent = mainFrame

    mainSide.Name = "mainSide"
    mainSide.Parent = mainFrame
    mainSide.BackgroundColor3 = Color3.fromRGB(37, 37, 44)
    mainSide.Size = UDim2.new(0, 166, 0, 396)

    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = mainSide


    game:GetService("UserInputService").InputBegan:connect(function(current) 
            if current.KeyCode.Name == Enum.KeyCode.LeftAlt.Name then 
                if nightmarefun.Enabled == true then
                    nightmarefun.Enabled = false
                else
                    nightmarefun.Enabled = true
                end
            end
    end)

    nightmares.Name = "nightmares"
    nightmares.Parent = mainSide
    nightmares.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    nightmares.BackgroundTransparency = 1.000
    nightmares.Position = UDim2.new(0.0499999262, 0, 0.0228203665, 0)
    nightmares.Size = UDim2.new(0, 103, 0, 28)
    nightmares.TextXAlignment = Enum.TextXAlignment.Left
    nightmares.Font = Enum.Font.Gotham
    nightmares.Text = " "..title
    nightmares.TextColor3 = Color3.fromRGB(92, 53, 93)
    nightmares.TextSize = 20.000
    nightmares.TextWrapped = true

    fun.Name = "fun"
    fun.Parent = mainSide
    fun.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fun.BackgroundTransparency = 1.000
    fun.Position = UDim2.new(0.622289062, 0, 0.0228203665, 0)
    fun.Size = UDim2.new(0, 54, 0, 27)
    fun.Font = Enum.Font.Gotham
    fun.Text = ""
    fun.TextColor3 = Color3.fromRGB(255, 255, 255)
    fun.TextSize = 20.000
    fun.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    fun.TextWrapped = true

    cover.Name = "cover"
    cover.Parent = mainSide
    cover.BackgroundColor3 = Color3.fromRGB(37, 37, 44)
    cover.BorderSizePixel = 0
    cover.Position = UDim2.new(0.949999988, 0, 0, 0)
    cover.Size = UDim2.new(0, 9, 0, 396)

    allTabs.Name = "allTabs"
    allTabs.Parent = mainSide
    allTabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    allTabs.BackgroundTransparency = 1.000
    allTabs.Position = UDim2.new(0.0499999262, 0, 0.108294941, 0)
    allTabs.Size = UDim2.new(0, 149, 0, 344)

    tabList.Name = "tabList"
    tabList.Parent = allTabs
    tabList.SortOrder = Enum.SortOrder.LayoutOrder

    allPages.Name = "allPages"
    allPages.Parent = mainFrame
    allPages.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    allPages.BackgroundTransparency = 1.000
    allPages.Position = UDim2.new(0.366315782, 0, 0.017676767, 0)
    allPages.Size = UDim2.new(0, 295, 0, 381)

    pages.Name = "pages"
    pages.Parent = allPages

    local tabHandling = {}

    function tabHandling:Tab(tabText)
        --------------------------
        tabText = tabText or "Tab"
        --------------------------
        local tabButton = Instance.new("TextButton")
        tabButton.Name = "tabButton"..tabText
        tabButton.Parent = allTabs
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BackgroundTransparency = 1.000
        tabButton.Size = UDim2.new(0, 149, 0, 35)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tabText
        tabButton.TextColor3 = Color3.fromRGB(87, 87, 104)
        tabButton.TextSize = 16.000

        local newPage = Instance.new("ScrollingFrame")
        newPage.Name = "newPage"..tabText
        newPage.Parent = pages
        newPage.Active = true
        newPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        newPage.BackgroundTransparency = 1.000
        newPage.BorderSizePixel = 0
        newPage.Size = UDim2.new(1, 0, 1, 0)
        newPage.ScrollBarThickness = 6
        newPage.ScrollBarImageColor3 = Color3.fromRGB(127, 97, 145)
        newPage.Visible = false

        local sectionListing = Instance.new("UIListLayout")    
        sectionListing.Name = "sectionListing"
        sectionListing.Parent = newPage
        sectionListing.SortOrder = Enum.SortOrder.LayoutOrder
        sectionListing.Padding = UDim.new(0, 3)

                
        local function UpdateSize()
            local cS = sectionListing.AbsoluteContentSize

            game.TweenService:Create(newPage, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {
                CanvasSize = UDim2.new(0,cS.X,0,cS.Y)
            }):Play()
        end
        UpdateSize()
        newPage.ChildAdded:Connect(UpdateSize)
        newPage.ChildRemoved:Connect(UpdateSize)

        tabButton.MouseButton1Click:Connect(function()
            --Tab Button Functioning
            UpdateSize()
            for i,v in next, allTabs:GetChildren() do
                if v:IsA("TextButton") then
                    game.TweenService:Create(v, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                        TextColor3 = Color3.fromRGB(87, 87, 104)
                    }):Play()
                    UpdateSize()
                end
            end
            game.TweenService:Create(tabButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                TextColor3 = Color3.fromRGB(127, 97, 145)
            }):Play()
            ----------------------
            --Page Functioning
            for i,v in next, pages:GetChildren() do
                v.Visible = false
                UpdateSize()
            end
            newPage.Visible = true
            ----------------------
        end)

        local sectionHandling = {}

        function sectionHandling:Section(sectionName)
            ---
            sectionName = sectionName or "Section"
            ---
            local sectionFrame = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local sectionListLayout = Instance.new("UIListLayout")
            local sectionFrameHead = Instance.new("Frame")
            local UICorner_2 = Instance.new("UICorner")
            local sectionCircle = Instance.new("Frame")
            local UICorner_3 = Instance.new("UICorner")
            local TextLabel = Instance.new("TextLabel")
            local closeSection = Instance.new("ImageButton")

            sectionFrame.Name = "sectionFrame"
            sectionFrame.Parent = newPage
            sectionFrame.BackgroundColor3 = Color3.fromRGB(37, 37, 44)
            sectionFrame.Position = UDim2.new(0, 0, -8.009863e-08, 0)
            sectionFrame.Size = UDim2.new(0.9559322, 0, 0, 36)
            sectionFrame.ClipsDescendants = true

            UICorner.Parent = sectionFrame

            sectionListLayout.Parent = sectionFrame
            sectionListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            sectionListLayout.Padding = UDim.new(0, 3)
            sectionListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

            sectionFrameHead.Name = "sectionFrameHead"
            sectionFrameHead.Parent = sectionFrame
            sectionFrameHead.BackgroundColor3 = Color3.fromRGB(37, 37, 44)
            sectionFrameHead.Position = UDim2.new(0, 0, -8.009863e-08, 0)
            sectionFrameHead.Size = UDim2.new(1, 0, 0, 36)

            UICorner_2.Parent = sectionFrameHead

            sectionCircle.Name = "sectionCircle"
            sectionCircle.Parent = sectionFrameHead
            sectionCircle.BackgroundColor3 = Color3.fromRGB(82, 82, 98)
            sectionCircle.Position = UDim2.new(0.0354609936, 0, 0.388888896, 0)
            sectionCircle.Size = UDim2.new(0, 7, 0, 7)

            UICorner_3.CornerRadius = UDim.new(0, 99)
            UICorner_3.Parent = sectionCircle

            TextLabel.Parent = sectionFrameHead
            TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextLabel.BackgroundTransparency = 1.000
            TextLabel.Position = UDim2.new(0.0992907807, 0, 0.194444448, 0)
            TextLabel.Size = UDim2.new(0, 173, 0, 22)
            TextLabel.Font = Enum.Font.Gotham
            TextLabel.Text = sectionName
            TextLabel.TextColor3 = Color3.fromRGB(82, 82, 98)
            TextLabel.TextSize = 14.000
            TextLabel.TextXAlignment = Enum.TextXAlignment.Left

            

            closeSection.Name = "closeSection"
            closeSection.Parent = sectionFrameHead
            closeSection.BackgroundTransparency = 1.000
            closeSection.Position = UDim2.new(0.889999986, 0, 0.155000001, 0)
            closeSection.Size = UDim2.new(0, 25, 0, 25)
            closeSection.ZIndex = 2
            closeSection.Image = "rbxassetid://3926305904"
            closeSection.ImageColor3 = Color3.fromRGB(82, 82, 98)
            closeSection.ImageRectOffset = Vector2.new(404, 284)
            closeSection.ImageRectSize = Vector2.new(36, 36)
            closeSection.MouseButton1Click:Connect(function()
                if isDropped then
                    isDropped = false
                    sectionFrame:TweenSize(UDim2.new(0.956, 0,0, 36), "In", "Linear", 0.10)
                    game.TweenService:Create(closeSection, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                        Rotation = 0,
                        ImageColor3 = Color3.fromRGB(82, 82, 98)
                    }):Play()
                    game.TweenService:Create(sectionCircle, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                        BackgroundColor3 = Color3.fromRGB(82, 82, 98)
                    }):Play()
                    game.TweenService:Create(TextLabel, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                        TextColor3 = Color3.fromRGB(82, 82, 98)
                    }):Play()
                    wait(0.10)
                    UpdateSize()
                else
                    isDropped = true
                    sectionFrame:TweenSize(UDim2.new(0.956,0, 0, sectionListLayout.AbsoluteContentSize.Y + 8), "In", "Linear", 0.10)
                    game.TweenService:Create(closeSection, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                        Rotation = 180,
                        ImageColor3 = Color3.fromRGB(127, 97, 145)
                    }):Play()
                    game.TweenService:Create(sectionCircle, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                        BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                    }):Play()
                    game.TweenService:Create(TextLabel, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.In),{
                        TextColor3 = Color3.fromRGB(127, 97, 145)
                    }):Play()
                    wait(0.10)
                    UpdateSize()
                end
            end)

            local itemHandling = {}

            function itemHandling:Button(btnText, callback)
                ----
                btnText = btnText or "Click Me!"
                callback = callback or function() end
                ----

                local buttonFrame = Instance.new("Frame")
                local UIListLayout = Instance.new("UIListLayout")
                local TextButton = Instance.new("TextButton")
                local UICorner = Instance.new("UICorner")

                buttonFrame.Name = "buttonFrame"
                buttonFrame.Parent = sectionFrame
                buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                buttonFrame.BackgroundTransparency = 1.000
                buttonFrame.Position = UDim2.new(0.0354609936, 0, 0.168103442, 0)
                buttonFrame.Size = UDim2.new(0, 262, 0, 31)

                UIListLayout.Parent = buttonFrame
                UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                TextButton.Parent = buttonFrame
                TextButton.BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                TextButton.Position = UDim2.new(0.118320614, 0, -0.0813953504, 0)
                TextButton.Size = UDim2.new(0, 262,0, 31)
                TextButton.AutoButtonColor = false
                TextButton.Font = Enum.Font.Gotham
                TextButton.Text = btnText
                TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextButton.TextSize = 14.000

                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = TextButton

                local clickDebounce = false
                local callBackDebounce = false
                local mouseleft

                TextButton.MouseButton1Down:Connect(function()
                    if not clickDebounce then
                        clickDebounce = true
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            Size = UDim2.new(0, 251,0, 28),
                            TextSize = 13
                        }):Play()
                        wait(0.5)
                        clickDebounce = false
                    end
                end)

                TextButton.MouseButton1Click:Connect(function()
                    if not callBackDebounce then
                        callBackDebounce = true	
                        callback()
                        wait(0.5)
                        callBackDebounce = false
                    end
                end)

                TextButton.MouseButton1Up:Connect(function()
                    if mouseleft then
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            Size = UDim2.new(0, 262,0, 31),
                            TextSize = 14
                        }):Play()
                    else
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            Size = UDim2.new(0, 262,0, 31),
                            TextSize = 14
                        }):Play()
                    end
                end)
                TextButton.MouseEnter:Connect(function()
                    if callBackDebounce then
                        mouseleft = false
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            BackgroundColor3 = Color3.fromRGB(73, 56, 84)
                        }):Play()
                    else
                        mouseleft = false
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            BackgroundColor3 = Color3.fromRGB(98, 75, 113)
                        }):Play()
                    end
                end)
                TextButton.MouseLeave:Connect(function()
                    if callBackDebounce then
                        mouseleft = true
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            Size = UDim2.new(0, 262,0, 31),
                            TextSize = 14
                        }):Play()
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                        }):Play()
                    else
                        mouseleft = true
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            Size = UDim2.new(0, 262,0, 31),
                            TextSize = 14
                        }):Play()
                        game.TweenService:Create(TextButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),{
                            BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                        }):Play()
                    end
                end)
            end
            function itemHandling:Toggle(togInfo, callback)
                local tog = false
                togInfo = togInfo or "Toggle"
                callback = callback or function() end
                local toggleFrame = Instance.new("Frame")
                local checkBox = Instance.new("ImageButton")
                local UIListLayout = Instance.new("UIListLayout")
                local checkBoxInfo = Instance.new("TextLabel")

                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = sectionFrame
                toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleFrame.BackgroundTransparency = 1.000
                toggleFrame.Position = UDim2.new(0.0354609936, 0, 0.344827592, 0)
                toggleFrame.Size = UDim2.new(0, 262, 0, 25)

                checkBox.Name = "checkBox"
                checkBox.Parent = toggleFrame
                checkBox.BackgroundColor3 = Color3.fromRGB(47, 47, 56)
                checkBox.BackgroundTransparency = 1.000
                checkBox.Position = UDim2.new(-0.0381679386, 0, 0.0263157934, 0)
                checkBox.Size = UDim2.new(0, 25, 0, 25)
                checkBox.ZIndex = 2
                checkBox.Image = "rbxassetid://3926311105"
                checkBox.ImageColor3 = Color3.fromRGB(62, 62, 74)
                checkBox.ImageRectOffset = Vector2.new(940, 784)
                checkBox.ImageRectSize = Vector2.new(48, 48)

                UIListLayout.Parent = toggleFrame
                UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                UIListLayout.Padding = UDim.new(0, 3)

                checkBoxInfo.Name = "checkBoxInfo"
                checkBoxInfo.Parent = toggleFrame
                checkBoxInfo.BackgroundColor3 = Color3.fromRGB(47, 47, 56)
                checkBoxInfo.BackgroundTransparency = 1.000
                checkBoxInfo.Position = UDim2.new(0.106870227, 0, -0.157894731, 0)
                checkBoxInfo.Size = UDim2.new(0, 200, 0, 19)
                checkBoxInfo.Font = Enum.Font.Gotham
                checkBoxInfo.Text = togInfo
                checkBoxInfo.TextColor3 = Color3.fromRGB(62, 62, 74)
                checkBoxInfo.TextSize = 14.000
                checkBoxInfo.TextXAlignment = Enum.TextXAlignment.Left
                local clickDe = false
                local hoverDe = false

                checkBox.MouseEnter:Connect(function()
                    if not tog then
                        game.TweenService:Create(checkBox, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            ImageColor3 = Color3.fromRGB(53, 53, 63)
                        }):Play()
                    else
                        game.TweenService:Create(checkBox, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            ImageColor3 = Color3.fromRGB(89, 68, 102)
                        }):Play()
                    end
                end)

                checkBox.MouseLeave:Connect(function()
                    if not tog then
                        checkBox.Parent:TweenSize(UDim2.new(0, 262,0, 25), "InOut", "Linear", 0.08)
                        game.TweenService:Create(checkBox, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            ImageColor3 = Color3.fromRGB(62, 62, 74)
                        }):Play()
                    else
                        checkBox.Parent:TweenSize(UDim2.new(0, 262,0, 25), "InOut", "Linear", 0.08)
                        game.TweenService:Create(checkBox, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                            ImageColor3 = Color3.fromRGB(127, 97, 145)
                        }):Play()
                    end
                end)

                checkBox.MouseButton1Down:Connect(function()
                    if not hoverDe then
                        hoverDe = true
                        checkBox.Parent:TweenSize(UDim2.new(0, 255,0, 25), "InOut", "Linear", 0.08)
                        wait(0.8)
                        hoverDe = false
                    end
                end)
                checkBox.MouseButton1Up:Connect(function()
                    checkBox.Parent:TweenSize(UDim2.new(0, 262,0, 25), "InOut", "Linear", 0.08)
                end)

                checkBox.MouseButton1Click:Connect(function()
                    if not clickDe then
                        clickDe = true
                        tog = not tog
                        callback(tog)
                        if tog then
                            game.TweenService:Create(checkBox.Parent.checkBoxInfo, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                TextColor3 = Color3.fromRGB(127, 97, 145)
                            }):Play()
                            checkBox.ImageRectOffset = Vector2.new(4, 836)
                            game.TweenService:Create(checkBox, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                ImageColor3 = Color3.fromRGB(127, 97, 145)
                            }):Play()
                        else
                            game.TweenService:Create(checkBox.Parent.checkBoxInfo, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                TextColor3 = Color3.fromRGB(62, 62, 74)
                            }):Play()
                            checkBox.ImageRectOffset = Vector2.new(940, 784)
                            game.TweenService:Create(checkBox, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                ImageColor3 = Color3.fromRGB(62, 62, 74)
                            }):Play()
                        end
                        wait(0.8)
                        clickDe = false
                    end
                end)
            end
                function itemHandling:TextBox(textInfo, callback)
                    textInfo = textInfo or "Type here"
                    callback = callback or function() end

                    local textBoxFrame = Instance.new("Frame")
                    local UIListLayout = Instance.new("UIListLayout")
                    local TextBox = Instance.new("TextBox")
                    local UICorner = Instance.new("UICorner")

                    textBoxFrame.Name = "textBoxFrame"
                    textBoxFrame.Parent = sectionFrame
                    textBoxFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 52)
                    textBoxFrame.BackgroundTransparency = 1.000
                    textBoxFrame.Position = UDim2.new(0.0354609936, 0, 0.344827592, 0)
                    textBoxFrame.Size = UDim2.new(0, 262, 0, 28)

                    UIListLayout.Parent = textBoxFrame
                    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                    UIListLayout.Padding = UDim.new(0, 3)

                    TextBox.Parent = textBoxFrame
                    TextBox.BackgroundColor3 = Color3.fromRGB(43, 43, 52)
                    TextBox.Position = UDim2.new(0, 0, 0.106060609, 0)
                    TextBox.Size = UDim2.new(0, 262, 0, 26)
                    TextBox.ClearTextOnFocus = false
                    TextBox.Font = Enum.Font.SourceSans
                    TextBox.PlaceholderText = textInfo
                    TextBox.Text = ""
                    TextBox.TextColor3 = Color3.fromRGB(127, 97, 145)
                    TextBox.TextSize = 16.000
                    TextBox.TextWrapped = true

                    UICorner.CornerRadius = UDim.new(0, 5)
                    UICorner.Parent = TextBox

                    function anim(property)
                        if property == "Text" then
                            TextBox:TweenSize(UDim2.new(0, 250,0, 22), "InOut", "Linear", 0.1, true)
                            wait(0.18)
                            TextBox:TweenSize(UDim2.new(0, 262,0, 26), "InOut", "Linear", 0.1, true)
                        end
                    end
                    TextBox.Changed:Connect(anim)

                    TextBox.FocusLost:Connect(function(EnterPressed)
                        if not EnterPressed then return end
                        callback(TextBox.Text)
                        TextBox:TweenSize(UDim2.new(0, 250,0, 22), "InOut", "Linear", 0.1, true)
                        wait(0.18)
                        TextBox:TweenSize(UDim2.new(0, 262,0, 26), "InOut", "Linear", 0.1, true)
                        TextBox.Text = ""  
                    end)
                end

                function itemHandling:Slider(sliderInf, maxvalue, minvalue, callback)

                    local sliderfunc = {}


                    local sliderFrame = Instance.new("Frame")
                    local sliderIinfo = Instance.new("TextLabel")
                    local sliderBtn = Instance.new("TextButton")
                    local UIListLayout = Instance.new("UIListLayout")
                    local SliderDrag = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local UICorner_1 = Instance.new("UICorner")
                    local sliderBox = Instance.new("TextBox")
                    sliderInf = sliderInf or "Slider"
                    minvalue = minvalue or 0
                    maxvalue = maxvalue or 500

                    sliderFrame.Name = "sliderFrame"
                    sliderFrame.Parent = sectionFrame
                    sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    sliderFrame.BackgroundTransparency = 1.000
                    sliderFrame.Position = UDim2.new(0.0354609936, 0, 0.658653855, 0)
                    sliderFrame.Size = UDim2.new(0, 262, 0, 32)

                    sliderIinfo.Name = "sliderIinfo"
                    sliderIinfo.Parent = sliderFrame
                    sliderIinfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    sliderIinfo.BackgroundTransparency = 1.000
                    sliderIinfo.Position = UDim2.new(0, 0, -0.0102040814, 0)
                    sliderIinfo.Size = UDim2.new(0, 169, 0, 18)
                    sliderIinfo.Font = Enum.Font.Gotham
                    sliderIinfo.Text = sliderInf
                    sliderIinfo.TextColor3 = Color3.fromRGB(127, 97, 145)
                    sliderIinfo.TextSize = 14.000
                    sliderIinfo.TextXAlignment = Enum.TextXAlignment.Left

                    sliderBtn.Name = "sliderBtn"
                    sliderBtn.Parent = sliderFrame
                    sliderBtn.BackgroundColor3 = Color3.fromRGB(47, 47, 56)
                    sliderBtn.BorderSizePixel = 0
                    sliderBtn.Position = UDim2.new(0, 0, 0.616923094, 0)
                    sliderBtn.Size = UDim2.new(0, 262, 0, 9)
                    sliderBtn.AutoButtonColor = false
                    sliderBtn.Font = Enum.Font.SourceSans
                    sliderBtn.Text = ""
                    sliderBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    sliderBtn.TextSize = 14.000
                    sliderBtn.ClipsDescendants = true

                    UIListLayout.Parent = sliderBtn
                    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                    SliderDrag.Name = "SliderDrag"
                    SliderDrag.Parent = sliderBtn
                    SliderDrag.BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                    SliderDrag.BorderColor3 = Color3.fromRGB(127, 97, 145)
                    SliderDrag.BorderSizePixel = 0
                    SliderDrag.Size = UDim2.new(0, 0, 0, 9)

                    UICorner.CornerRadius = UDim.new(0, 99)
                    UICorner.Parent = SliderDrag

                    UICorner_1.CornerRadius = UDim.new(0, 99)
                    UICorner_1.Parent = sliderBtn

                    sliderBox.Name = "sliderBox"
                    sliderBox.Parent = sliderFrame
                    sliderBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    sliderBox.BackgroundTransparency = 1.000
                    sliderBox.Position = UDim2.new(0.645038188, 0, 0.0769230798, 0)
                    sliderBox.Size = UDim2.new(0, 92, 0, 14)
                    sliderBox.ClearTextOnFocus = false
                    sliderBox.Font = Enum.Font.Gotham
                    sliderBox.Text = minvalue
                    sliderBox.TextColor3 = Color3.fromRGB(96, 96, 115)
                    sliderBox.TextScaled = true
                    sliderBox.TextSize = 14.000
                    sliderBox.TextWrapped = true
                    sliderBox.TextXAlignment = Enum.TextXAlignment.Right
                    sliderBox.TextEditable = true
                    
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local uis = game:GetService("UserInputService")
                    local Value;
                    sliderBtn.MouseButton1Down:Connect(function()
                        Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 262) * SliderDrag.AbsoluteSize.X) + tonumber(minvalue)) or 0
                        pcall(function()
                            callback(Value)
                        end)
                        SliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - SliderDrag.AbsolutePosition.X, 0, 262), 0, 9), "InOut", "Linear", 0.05, true)
                        moveconnection = mouse.Move:Connect(function()
                            sliderBox.Text = Value
                            Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 262) * SliderDrag.AbsoluteSize.X) + tonumber(minvalue))
                            pcall(function()
                                callback(Value)
                            end)
                            SliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - SliderDrag.AbsolutePosition.X, 0, 262), 0, 9), "InOut", "Linear", 0.05, true)
                        end)
                        releaseconnection = uis.InputEnded:Connect(function(Mouse)
                            if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                                Value = math.floor((((tonumber(maxvalue) - tonumber(minvalue)) / 262) * SliderDrag.AbsoluteSize.X) + tonumber(minvalue))
                                pcall(function()
                                    callback(Value)
                                end)
                                sliderBox.Text = Value
                                SliderDrag:TweenSize(UDim2.new(0, math.clamp(mouse.X - SliderDrag.AbsolutePosition.X, 0, 262), 0, 9), "InOut", "Linear", 0.05, true)
                                moveconnection:Disconnect()
                                releaseconnection:Disconnect()
                            end
                        end)
                    end)

                    function set(property)
                        if property == "Text" then
                            if tonumber(sliderBox.Text) then 
                                if tonumber(sliderBox.Text) <= maxvalue then
                                    Value = sliderBox.Text
                                    SliderDrag:TweenSize(UDim2.new(((tonumber(sliderBox.Text) or minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                                    pcall(function()
                                        callback(Value)
                                    end)
                                end
                                if tonumber(sliderBox.Text) > maxvalue then
                                    sliderBox.Text = maxvalue
                                    Value = maxvalue
                                    SliderDrag:TweenSize(UDim2.new(((maxvalue or minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                                    pcall(function()
                                        callback(Value)
                                    end)
                                end
                                if tonumber(sliderBox.Text) >= minvalue then
                                    Value = sliderBox.Text
                                    SliderDrag:TweenSize(UDim2.new(((tonumber(sliderBox.Text) or minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                                    pcall(function()
                                        callback(Value)
                                    end)
                                end
                                if tonumber(sliderBox.Text) < minvalue then
                                    Value = minvalue
                                    SliderDrag.Size = UDim2.new(((minvalue or minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9)
                                    pcall(function()
                                        callback(Value)
                                    end)
                                end
                            else
                                sliderBox.Text = ""
                            end
                        end
                    end

                    sliderBox.Focused:Connect(function()
                        sliderBox.Changed:Connect(set)
                    end)
                    sliderBox.FocusLost:Connect(function(enterP)
                        if not enterP then
                            if sliderBox.Text == "" then
                                sliderBox.Text = minvalue
                                Value = minvalue
                                SliderDrag:TweenSize(UDim2.new(((minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                                pcall(function()
                                    callback(Value)
                                end)
                            end
                            if tonumber(sliderBox.Text) > tonumber(maxvalue) then
                                Value = maxvalue
                                sliderBox.Text = maxvalue
                                SliderDrag:TweenSize(UDim2.new(((maxvalue or minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                                pcall(function()
                                    callback(Value)
                                end)
                            else
                                Value = tonumber(sliderBox.Text)
                            end
                            if tonumber(sliderBox.Text) < minvalue then
                                sliderBox.Text = minvalue
                                Value = minvalue
                                SliderDrag:TweenSize(UDim2.new(((minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                                pcall(function()
                                    callback(Value)
                                end)
                            else
                                Value = tonumber(sliderBox.Text)
                            end
                        end
                        if tonumber(sliderBox.Text) > maxvalue then
                            sliderBox.Text = maxvalue
                            Value = maxvalue
                            SliderDrag:TweenSize(UDim2.new(((maxvalue or minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                            pcall(function()
                                callback(Value)
                            end)
                        else
                            Value = tonumber(sliderBox.Text)
                        end
                        if tonumber(sliderBox.Text) < minvalue then
                            sliderBox.Text = minvalue
                            Value = minvalue
                            SliderDrag.Size = UDim2.new(((minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9)
                            pcall(function()
                                callback(Value)
                            end)
                        else
                            Value = tonumber(sliderBox.Text)
                        end
                        if sliderBox.Text == "" then
                            sliderBox.Text = minvalue
                            Value = minvalue
                            SliderDrag:TweenSize(UDim2.new(((minvalue) - minvalue) / (maxvalue - minvalue), 0, 0, 9), "InOut", "Linear", 0.05, true)
                            pcall(function()
                                callback(Value)
                            end)
                        end
                    end)
                    return sliderfunc
                end

                function itemHandling:Label(txtLabel)
                    txtLabel = txtLabel or "nightmare.fun"
                    local TextLabel = Instance.new("TextLabel")

                    TextLabel.Parent = sectionFrame
                    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.BackgroundTransparency = 1.000
                    TextLabel.Position = UDim2.new(0.0390070938, 0, 0.826923072, 0)
                    TextLabel.Size = UDim2.new(0, 260, 0, 27)
                    TextLabel.Font = Enum.Font.Gotham
                    TextLabel.Text = txtLabel
                    TextLabel.TextColor3 = Color3.fromRGB(198, 198, 198)
                    TextLabel.TextSize = 14.000
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
                end

                function itemHandling:KeyBind(bindInfo, first, callback)
                    bindInfo = bindInfo or "Press the Key"
                    local oldKey = first.Name
                    callback = callback or function() end

                    local keybindFrame = Instance.new("Frame")
                    local UIListLayout = Instance.new("UIListLayout")
                    local keybindBtn = Instance.new("TextButton")
                    local UICorner = Instance.new("UICorner")
                    local TextLabel = Instance.new("TextLabel")

                    keybindFrame.Name = "keybindFrame"
                    keybindFrame.Parent = sectionFrame
                    keybindFrame.BackgroundColor3 = Color3.fromRGB(43, 43, 52)
                    keybindFrame.BackgroundTransparency = 1.000
                    keybindFrame.Position = UDim2.new(0.0354609936, 0, 0.344827592, 0)
                    keybindFrame.Size = UDim2.new(0, 262, 0, 33)

                    UIListLayout.Parent = keybindFrame
                    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
                    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                    UIListLayout.Padding = UDim.new(0, 3)

                    keybindBtn.Name = "keybindBtn"
                    keybindBtn.Parent = keybindFrame
                    keybindBtn.BackgroundColor3 = Color3.fromRGB(43, 43, 52)
                    keybindBtn.Position = UDim2.new(0, 0, 0.106060609, 0)
                    keybindBtn.Size = UDim2.new(0, 107, 0, 26)
                    keybindBtn.AutoButtonColor = false
                    keybindBtn.Font = Enum.Font.GothamSemibold
                    keybindBtn.Text = oldKey
                    keybindBtn.TextColor3 = Color3.fromRGB(204, 204, 204)
                    keybindBtn.TextSize = 14.000

                    UICorner.CornerRadius = UDim.new(0, 5)
                    UICorner.Parent = keybindBtn

                    TextLabel.Parent = keybindFrame
                    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    TextLabel.BackgroundTransparency = 1.000
                    TextLabel.Position = UDim2.new(0.408396959, 0, 0.893939376, 0)
                    TextLabel.Size = UDim2.new(0, 155, 0, 12)
                    TextLabel.Font = Enum.Font.Gotham
                    TextLabel.Text = "KeyBind"
                    TextLabel.TextColor3 = Color3.fromRGB(127, 97, 145)
                    TextLabel.TextSize = 14.000
                    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

                    keybindBtn.MouseButton1Click:connect(function(e) 
                        keybindBtn.Text = ". . ."
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

                function itemHandling:Dropdown(dropInfo, list, callback)
                    dropInfo = dropInfo or 'Favorite Hub'
                    list = list or {}
                    callback = callback or function() end

                    local DropYSize = 28
                    local dropped = false

                    local dropdownFrame = Instance.new("Frame")
                    local dropdownFrameHeader = Instance.new("Frame")
                    local UICorner = Instance.new("UICorner")
                    local dropdowninfo = Instance.new("TextLabel")
                    local closeDropdown = Instance.new("ImageButton")
                    local dropcover = Instance.new("Frame")
                    local dropListing = Instance.new("UIListLayout")
                    local dropdownCorner = Instance.new("UICorner")

                    dropdownFrame.Name = "dropdownFrame"
                    dropdownFrame.Parent = sectionFrame
                    dropdownFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 58)
                    dropdownFrame.ClipsDescendants = true
                    dropdownFrame.Position = UDim2.new(0.0354609936, 0, 0.495833337, 0)
                    dropdownFrame.Size = UDim2.new(0, 262, 0, 28)

                    dropdownFrameHeader.Name = "dropdownFrameHeader"
                    dropdownFrameHeader.Parent = dropdownFrame
                    dropdownFrameHeader.BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                    dropdownFrameHeader.Size = UDim2.new(0, 262, 0, 28)

                    UICorner.CornerRadius = UDim.new(0, 5)
                    UICorner.Parent = dropdownFrameHeader

                    dropdowninfo.Name = "dropdowninfo"
                    dropdowninfo.Parent = dropdownFrameHeader
                    dropdowninfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    dropdowninfo.BackgroundTransparency = 1.000
                    dropdowninfo.Position = UDim2.new(0.0267175566, 0, 0, 0)
                    dropdowninfo.Size = UDim2.new(0, 197, 0, 28)
                    dropdowninfo.Font = Enum.Font.Gotham
                    dropdowninfo.Text = dropInfo
                    dropdowninfo.TextColor3 = Color3.fromRGB(255, 255, 255)
                    dropdowninfo.TextSize = 15.000
                    dropdowninfo.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
                    dropdowninfo.TextXAlignment = Enum.TextXAlignment.Left

                    closeDropdown.Name = "closeDropdown"
                    closeDropdown.Parent = dropdownFrameHeader
                    closeDropdown.BackgroundTransparency = 1.000
                    closeDropdown.Position = UDim2.new(0.8823663, 0, 0.0857142881, 0)
                    closeDropdown.Size = UDim2.new(0, 25, 0, 25)
                    closeDropdown.ZIndex = 2
                    closeDropdown.Image = "rbxassetid://3926305904"
                    closeDropdown.ImageRectOffset = Vector2.new(404, 284)
                    closeDropdown.ImageRectSize = Vector2.new(36, 36)
                    closeDropdown.MouseButton1Click:Connect(function()
                        if dropped then
                            dropped = false
                            dropdownFrame:TweenSize(UDim2.new(0, 262, 0, 28), 'InOut', 'Linear', 0.08)
                            game.TweenService:Create(closeDropdown, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                Rotation = 0
                            }):Play()
                            wait(0.1)
                            sectionFrame:TweenSize(UDim2.new(0.956,0, 0, sectionListLayout.AbsoluteContentSize.Y + 8), "InOut", "Linear", 0.1)
                            wait(0.1)
                            game.TweenService:Create(dropcover, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                BackgroundTransparency = 1
                            }):Play()
                            wait(0.1)
                            UpdateSize()
                        else
                            dropped = true
                            dropdownFrame:TweenSize(UDim2.new(0, 262, 0, DropYSize), 'InOut', 'Linear', 0.08)
                            game.TweenService:Create(closeDropdown, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                Rotation = 180
                            }):Play()
                            wait(0.1)
                            sectionFrame:TweenSize(UDim2.new(0.956,0, 0, sectionListLayout.AbsoluteContentSize.Y + 8), "InOut", "Linear", 0.1)
                            wait(0.1)
                            game.TweenService:Create(dropcover, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                BackgroundTransparency = 0
                            }):Play()
                            wait(0.1)
                            UpdateSize()
                        end
                    end)

                    dropcover.Name = "dropcover"
                    dropcover.Parent = dropdownFrameHeader
                    dropcover.BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                    dropcover.BackgroundTransparency = 1.000
                    dropcover.BorderSizePixel = 0
                    dropcover.Position = UDim2.new(0, 0, 0.850000024, 0)
                    dropcover.Size = UDim2.new(0, 262, 0, 5)

                    dropListing.Name = "dropListing"
                    dropListing.Parent = dropdownFrame
                    dropListing.HorizontalAlignment = Enum.HorizontalAlignment.Center
                    dropListing.SortOrder = Enum.SortOrder.LayoutOrder
                    dropListing.Padding = UDim.new(0, 4)

                    dropdownCorner.CornerRadius = UDim.new(0, 5)
                    dropdownCorner.Name = "dropdownCorner"
                    dropdownCorner.Parent = dropdownFrame

                        for i,v in next, list do
                            local dropdownButton = Instance.new("Frame")
                            local UIListLayout = Instance.new("UIListLayout")
                            local optionButton = Instance.new("TextButton")
                            local optionCorner = Instance.new("UICorner")

                            dropdownButton.Name = "dropdownButton"
                            dropdownButton.Parent = dropdownFrame
                            dropdownButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                            dropdownButton.BackgroundTransparency = 1.000
                            dropdownButton.Position = UDim2.new(0, 0, 0.284552842, 0)
                            dropdownButton.Size = UDim2.new(0, 251, 0, 28)
        
                            UIListLayout.Parent = dropdownButton
                            UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
                            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                            UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
                            
                            DropYSize = DropYSize + 33
                            optionButton.Name = "optionButton"
                            optionButton.Parent = dropdownButton
                            optionButton.BackgroundColor3 = Color3.fromRGB(127, 97, 145)
                            optionButton.BorderSizePixel = 0
                            optionButton.Position = UDim2.new(0.0667938963, 0, -0.418119699, 0)
                            optionButton.Size = UDim2.new(0, 251, 0, 28)
                            optionButton.AutoButtonColor = false
                            optionButton.Font = Enum.Font.Gotham
                            optionButton.Text = "  "..v
                            optionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            optionButton.TextSize = 14.000
                            optionButton.TextXAlignment = Enum.TextXAlignment.Left
                            optionButton.MouseButton1Click:Connect(function()
                                dropped = false
                                dropdowninfo.Text = v
                                callback(v)
                                dropdownFrame:TweenSize(UDim2.new(0, 262, 0, 28), 'InOut', 'Linear', 0.08)
                                game.TweenService:Create(closeDropdown, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                    Rotation = 0
                                }):Play()
                                wait(0.1)
                                sectionFrame:TweenSize(UDim2.new(0.956,0, 0, sectionListLayout.AbsoluteContentSize.Y + 8), "InOut", "Linear", 0.1)
                                wait(0.1)
                                game.TweenService:Create(dropcover, TweenInfo.new(0.08, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                    BackgroundTransparency = 1
                                }):Play()
                                wait(0.1)
                                UpdateSize()
                            end)

                            optionButton.MouseButton1Down:Connect(function()
                                game.TweenService:Create(optionButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                    Size = UDim2.new(0, 235,0, 26)
                                }):Play()
                            end)
                            optionButton.MouseButton1Up:Connect(function()
                                game.TweenService:Create(optionButton, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                                    Size = UDim2.new(0, 251,0, 28)
                                }):Play()
                            end)
        
                            optionCorner.CornerRadius = UDim.new(0, 5)
                            optionCorner.Name = "optionCorner"
                            optionCorner.Parent = optionButton
                        end 
                end
            return itemHandling
        end
        return sectionHandling
    end
    return tabHandling
end

return Fun
