local library = {
    toggled = true;
    binding = false;
    binds = {};
}

if getgenv and getgenv().hattUI then
    getgenv().hattUI:Destroy()
end

local HttpService = game:GetService("HttpService")
do
    local contentProvider = game:GetService("ContentProvider")
    local userInputService = game:GetService("UserInputService")
    local runService = game:GetService("RunService")

    contentProvider:PreloadAsync({
		"rbxassetid://5880691637";
		"rbxassetid://5882688826";
		"rbxassetid://4896743658";
		"rbxassetid://4894670678";
		"rbxassetid://4892761119";
		"rbxassetid://5880482965";
        "rbxassetid://4892463081";
        "rbxassetid://5882871047";
    })

    local originalSize
    local originalObjectY
    local originalContainerY
    local dynamicContainerBottomYPos

    local originalTabY
    local originalTabContainerY
    local dynamicTabContainerBottomYPos

    local tabList = {}
    local dropList = {}
    local main = {}
    main.__index = main
    local tabs = {}
    tabs.__index = tabs
    local labels = {}
    labels.__index = labels

    local function isInGui(frame)
        if not frame then return end

        local mouseLocation = userInputService:GetMouseLocation()
        local mouse = Vector2.new(mouseLocation.X, mouseLocation.Y - 36)

        local x1, x2 = frame.AbsolutePosition.X, frame.AbsolutePosition.X + frame.AbsoluteSize.X
        local y1, y2 = frame.AbsolutePosition.Y, frame.AbsolutePosition.Y + frame.AbsoluteSize.Y
        
        return (mouse.X >= x1 and mouse.X <= x2) and (mouse.Y >= y1 and mouse.Y <= y2)
    end

    function main:resize()
        local y = 0

        for i,v in pairs(self.container:GetChildren()) do
            if not v:IsA("UIListLayout") then
                y = y + v.AbsoluteSize.Y
            end
        end

        self.object.Size = UDim2.new(0, 180, 0, y + 57)
    end

    function main:getOrder()
        local count = 0

        for i,v in pairs(self.container:GetChildren()) do
            if not v:IsA("UIListLayout") then
                count = count + 1
            end
        end

        return count
    end

    function tabs:getOrder()
        local count = 0

        for i,v in pairs(self.container:GetChildren()) do
            if not v:IsA("UIListLayout") then
                count = count + 1
            end
        end

        return count
    end

    local m = game.Players.LocalPlayer:GetMouse()

    local function isHoveringOverObj(obj)
        local tx = obj.AbsolutePosition.X
        local ty = obj.AbsolutePosition.Y
        local bx = tx + obj.AbsoluteSize.X
        local by = ty + obj.AbsoluteSize.Y
        if m.X >= tx and m.Y >= ty and m.X <= bx and m.Y <= by then
            return true
        end
    end

    local function Resize(part,new,_delay)
        local TweenService = game:GetService("TweenService")
        _delay = _delay or 0.5
        local tweenInfo = TweenInfo.new(_delay, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(part, tweenInfo, new)
        tween:Play()
    end

    local function CreateDrag(gui)
        local UserInputService = game:GetService("UserInputService")
        local dragging
        local dragInput
        local dragStart
        local startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            Resize(gui, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.16)
        end
        
        gui.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isHoveringOverObj(gui.frame.topBorder) then
                dragging = true
                dragStart = input.Position
                startPos = gui.Position
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        gui.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    function main:window(name)
        local newWindow = library:createElement("ImageLabel", {
            Name = name;
            Size = UDim2.new(0, 180, 0, 50);
            Position = UDim2.new(0, 10, 0, 40);
            Image = "rbxassetid://4894670678";
            ImageColor3 = Color3.fromRGB(15, 15, 15);
            ImageTransparency = 0.5;
            ScaleType = Enum.ScaleType.Slice;
            SliceCenter = Rect.new(5, 5, 434, 297);
            BackgroundTransparency = 1;
            ClipsDescendants = true;
            library:createElement("ImageLabel", {
                Name = "frame";
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(40, 40, 40);
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 454, 297);
                BackgroundTransparency = 1;
                library:createElement("ImageLabel", {
                    Name = "topBorder";
                    Size = UDim2.new(1, 0, 0, 35);
                    Position = UDim2.new(0, 0, 0, 0);
                    Image = "rbxassetid://4892463081";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 125);
                    BackgroundTransparency = 1;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(0, 180, 0, 35);
                        Position = UDim2.new(0, 15, 0, 0);
                        Text = name;
                        TextWrapped = true;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        Font = Enum.Font.GothamSemibold;
                        TextSize = 16;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("ImageLabel", {
                        Name = "logo";
                        Size = UDim2.new(0, 24, 0, 20);
                        Position = UDim2.new(1, -30, 0, 7);
                        Image = "rbxassetid://5882871047";
                        BackgroundTransparency = 1;
                        ZIndex = 3;
                    });
                    library:createElement("Frame", {
                        Name = "line";
                        Size = UDim2.new(1, 0, 0, 2);
                        Position = UDim2.new(0, 0, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35);
                    })
                })
            });
            library:createElement("ImageLabel", {
                Name = "containerBorder";
                Size = UDim2.new(0, 160, 1, -55);
                Position = UDim2.new(0, 10, 0, 45);
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(33, 33, 33);
                ImageTransparency = 0;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                BackgroundTransparency = 1;
                ZIndex = 3;
                library:createElement("ImageLabel", {
                    Name = "Container";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    BackgroundTransparency = 1;
                    ClipsDescendants = false;
                    ZIndex = 3;
                    library:createElement("UIListLayout", {
                        SortOrder = 2;
                        Name = "list";
                    })
                });
            });
            Parent = library.container;
        })
        CreateDrag(newWindow)

        local window = setmetatable({
            toggled = true;
            object = newWindow;
            container = newWindow.containerBorder.Container;
        }, main)

        return window
    end

    function main:newTab(name)
        local newTab = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(1, 0, 0, 35);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            ZIndex = 3;
            library:createElement("TextButton", {
                Name = "button";
                Size = UDim2.new(1, 0, 0, 25);
                Position = UDim2.new(0, 0, 0, 5);
                Text = "";
                AutoButtonColor = false;
                BackgroundTransparency = 1;
                ZIndex = 3;
                library:createElement("TextLabel", {
                    Name = "title";
                    Size = UDim2.new(1, -35, 1, 0);
                    Position = UDim2.new(0, 35, 0, 0);
                    BackgroundTransparency = 1;
                    Text = name;
                    TextColor3 = Color3.fromRGB(250, 250, 250);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Font = Enum.Font.GothamSemibold;
                    TextSize = 12;
                    ZIndex = 3;
                });
                library:createElement("ImageLabel", {
                    Name = "toggleOutline";
                    Size = UDim2.new(0, 20, 0, 20);
                    Position = UDim2.new(0, 5, 0, 5/2);
                    Image = "rbxassetid://4892761119";
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(6, 6, 14, 14);
                    BackgroundTransparency = 1;
                    ZIndex = 3;
                    library:createElement("ImageLabel", {
                        Name = "toggle";
                        Size = UDim2.new(0, 0, 0, 0);
                        Position = UDim2.new(0.5, 0, 0.5, 0);
                        Image = "rbxassetid://5880482965";
                        BackgroundTransparency = 1;
                        ZIndex = 3;
                    })
                })
            });
            Parent = self.container;
        })

        local container = library:createElement("Frame", {
            Name = "container";
            Size = UDim2.new(0, 200, 0, 0);
            Position = UDim2.new(0, 10, 0, 47);
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            ZIndex = 2;
            ClipsDescendants = true;
            library:createElement("UIListLayout", {
                Name = "list";
                SortOrder = 2;
            });
            Parent = self.object;
        })

        local tab = setmetatable({
            toggled = false;
            parentObject = self.object;
            parentContainer = self.container;
            object = newTab;
            container = container;
            check = newTab.button.toggleOutline.toggle;
            flags = {};
            spFuncs = {};
        }, tabs)
        table.insert(tabList, tab)

        local containerSizeY = 0

        function tab.spFuncs:SimClck()
            if tab.toggled == false then
                tab.toggled = not tab.toggled

                for i,v in pairs(dropList) do
                    if v.toggled then
                    
                        v.toggled = false
                        local frame = v.object.border.frame

                        if not v.usesToggles then
                            frame.label.TextTransparency = 0
                            frame.label.Text = v.l[v.f]
                        end

                        tab.parentObject:TweenSize(UDim2.new(0, tab.parentObject.AbsoluteSize.X, 0, originalTabY), "In", "Quad", 0.15, true)
                        v.container.Parent.Parent.Parent:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.15, true)

                        v.arrow.Rotation = 0
                        wait(0.15)

                    end
                end
                
                for i,v in pairs(tabList) do
                    if v ~= tab and v.toggled then
                        spawn(function()
                            v.toggled = false
                            v.check:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "In", "Quad", 0.15, true)
                            v.container:TweenPosition(UDim2.new(0, 10, 0, 47), "In", "Quad", 0.15, true)
                            wait(0.15)

                            v.container.Size = UDim2.new(0, 200, 0, 0)
                        end)
                    end
                end

                if tab.toggled then
                    local y = 0

                    for i,v in pairs(tab.container:GetChildren()) do
                        if not v:IsA("UIListLayout") then
                            y = y + v.AbsoluteSize.Y
                        end
                    end

                    tab.check:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Elastic", 0.75, true)
                    tab.parentObject:TweenSize((y == 0 and originalSize) or (y <= originalContainerY and UDim2.new(0, 392, 0, originalObjectY)) or UDim2.new(0, 392, 0, (y + originalObjectY) - originalContainerY + 3), "Out", "Quad", 0.15, true)
                    spawn(function()
                        wait(0.15)
                    
                        if tab.toggled then
                    
                            tab.container.Size = UDim2.new(0, 200, 0, y)
                            tab.container:TweenPosition(UDim2.new(0, 180, 0, 47), "Out", "Quad", 0.15, true)
                            wait(0.15)

                            originalTabY = tab.parentObject.AbsoluteSize.Y
                            originalTabContainerY = tab.container.AbsoluteSize.Y
                            dynamicContainerBottomYPos = tab.parentContainer.AbsolutePosition.Y + tab.parentContainer.AbsoluteSize.Y
                            dynamicTabContainerBottomYPos = tab.container.AbsolutePosition.Y + tab.container.AbsoluteSize.Y

                        end
                    end)
                else
                    tab.check:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0.5, 0), "In", "Quad", 0.15, true)
                    tab.container:TweenPosition(UDim2.new(0, 10, 0, 47), "In", "Quad", 0.15, true)
                    spawn(function()
                        wait(0.15)
                        
                        if tab.toggled then
                        
                            tab.container.Size = UDim2.new(0, 200, 0, 0)
                            tab.parentObject:TweenSize(originalSize, "In", "Quad", 0.15, true)

                        end
                    end)
                end
            end
        end

        newTab.button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                spawn(function()
                    tab.spFuncs:SimClck()
                end)
            end
        end)

        self:resize()
        
        originalSize = UDim2.new(0, self.object.AbsoluteSize.X, 0, self.object.AbsoluteSize.Y)
        originalObjectY = self.object.AbsoluteSize.Y
        originalContainerY = self.container.AbsoluteSize.Y
        dynamicContainerBottomYPos = tab.parentContainer.AbsolutePosition.Y + tab.parentContainer.AbsoluteSize.Y
        dynamicTabContainerBottomYPos = tab.container.AbsolutePosition.Y + tab.container.AbsoluteSize.Y

        return tab
    end

    function tabs:label(name, text)
        local newLabel = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 35);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 26);
                Position = UDim2.new(0, 0, 0, 5);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(225, 58, 75);
                ImageTransparency = 0.35;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                library:createElement("ImageButton", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    ClipsDescendants = true;
                    library:createElement("TextLabel", {
                        Name = "text";
                        Size = UDim2.new(1, -10, 1, -10);
                        Position = UDim2.new(0, 5, 0, 5);
                        Text = text;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        BackgroundTransparency = 1;
                    });
                })
            });
            Parent = self.container;
        })

        local label = setmetatable({
            object = newLabel;
            tabObject = self.object;
            parentObject = self.parentObject;
            container = self.container;
            textBox = newLabel.border.frame.text;
        }, labels)

        while not label.textBox.TextFits do
            runService.RenderStepped:Wait()
            newLabel.Size = newLabel.Size + UDim2.new(0, 0, 0, 10);
            newLabel.border.Size = newLabel.border.Size + UDim2.new(0, 0, 0, 10)
        end

        return label
    end

    function labels:changeText(text)
        self.textBox.Text = text;

        local function getToggled()
            for i,v in pairs(tabList) do
                if self.tabObject == v.object then return v.toggled end
            end

            return false
        end

        if self.textBox.TextFits then
            while self.textBox.TextFits do
                runService.RenderStepped:Wait()

                if getToggled() then
                    self.parentObject.Size = self.parentObject.Size + UDim2.new(0, 0, 0, -10)
                    self.container.Size = self.container.Size + UDim2.new(0, 0, 0, -10)
                end

                self.object.Size = self.object.Size + UDim2.new(0, 0, 0, -10)
                self.object.border.Size = self.object.border.Size + UDim2.new(0, 0, 0, -10)
            end

            self.object.Size = self.object.Size + UDim2.new(0, 0, 0, 10)
            self.object.border.Size = self.object.border.Size + UDim2.new(0, 0, 0, 10)

            if getToggled() then
                self.parentObject.Size = self.parentObject.Size + UDim2.new(0, 0, 0, 10)
                self.container.Size = self.container.Size + UDim2.new(0, 0, 0, 10)
            end

        else
            while not self.textBox.TextFits do
                runService.RenderStepped:Wait()

                if getToggled() then
                    self.parentObject.Size = self.parentObject.Size + UDim2.new(0, 0, 0, 10)
                    self.container.Size = self.container.Size + UDim2.new(0, 0, 0, 10)
                end

                self.object.Size = self.object.Size + UDim2.new(0, 0, 0, 10)
                self.object.border.Size = self.object.border.Size + UDim2.new(0, 0, 0, 10)
            end
        end

        if not getToggled() then return end

        originalTabY = self.parentObject.AbsoluteSize.Y
        originalTabContainerY = self.container.AbsoluteSize.Y
    end

    function tabs:textbox(name, options, callback)
        local default = options.default or "..."
        local location = options.location or self.flags
        local flag = options.flag or ""
        local callback = callback or function() end

        local newTextBox = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 45);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 35);
                Position = UDim2.new(0, 0, 0, 5);
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(25, 25, 25);
                ImageTransparency = 0.5;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                BackgroundTransparency = 1;
                ClipsDescendants = true;
                library:createElement("ImageLabel", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    BackgroundTransparency = 1;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(1, -8, 0.5, 0);
                        Position = UDim2.new(0, 8, 0, 0);
                        Text = name;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("ImageLabel", {
                        Name = "textBorder";
                        Size = UDim2.new(0, 135, 0, 15);
                        Position = UDim2.new(0, 35, 0, 16);
                        Image = "rbxassetid://4894670678";
                        ImageColor3 = Color3.fromRGB(25, 25, 25);
                        ImageTransparency = 0.5;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(5, 5, 434, 297);
                        BackgroundTransparency = 1;
                        library:createElement("ImageLabel", {
                            Name = "textFrame";
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            Image = "rbxassetid://4894670678";
                            ImageColor3 = Color3.fromRGB(70, 70, 70);
                            ScaleType = Enum.ScaleType.Slice;
                            SliceCenter = Rect.new(5, 5, 434, 297);
                            BackgroundTransparency = 1;
                            ClipsDescendants = true;
                            library:createElement("TextBox", {
                                Name = "textInput";
                                Size = UDim2.new(1, 0, 1, 0);
                                Position = UDim2.new(0, 0, 0, 0);
                                Text = default;
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 12;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            })
                        })
                    });
                })
            });
            Parent = self.container;
        })

        local textBox = newTextBox.border.frame.textBorder.textFrame.textInput

        textBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed then return end

            location[flag] = textBox.Text
            callback(location[flag])
        end)
    end

    function tabs:colorSelector(name, options, callback)
        local location = options.location or self.flags
        local flag = options.flag or ""
        local default = options.default or Color3.fromRGB(255, 255, 255)
        local callback = callback or function() end

        location[flag] = default

        local R = math.floor(default.R * 255)
        local G = math.floor(default.G * 255)
        local B = math.floor(default.B * 255)

        local newColorSelector = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 160);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 151);
                Position = UDim2.new(0, 0, 0, 5);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(200, 58, 75);
                ImageTransparency = 0.35;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                library:createElement("ImageLabel", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    ClipsDescendants = true;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(1, 0, 0, 25);
                        Position = UDim2.new(0, 0, 0, 0);
                        Text = name;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("ImageLabel", {
                        Name = "redBorder";
                        Size = UDim2.new(1, -10, 0, 25);
                        Position = UDim2.new(0, 5, 0, 25);
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://4894670678";
                        ImageColor3 = Color3.fromRGB(25, 25, 25);
                        ImageTransparency = 0.35;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(5, 5, 434, 297);
                        library:createElement("ImageLabel", {
                            Name = "frame";
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            BackgroundTransparency = 1;
                            Image = "rbxassetid://4894670678";
                            ImageColor3 = Color3.fromRGB(40, 40, 40);
                            ScaleType = Enum.ScaleType.Slice;
                            SliceCenter = Rect.new(5, 5, 434, 297);
                            ClipsDescendants = true;
                            library:createElement("TextLabel", {
                                Name = "redLabel";
                                Size = UDim2.new(0.1, 0, 0.1, 0);
                                Position = UDim2.new(0.015, 0, 0.5, -1);
                                Text = "R";
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 10;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            });
                            library:createElement("ImageLabel", {
                                Name = "gradientSelectorBorder";
                                Size = UDim2.new(0.65, 0, 0.65, 0);
                                Position = UDim2.new(0.25/2, 0, 0.35/2, 0);
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                BackgroundTransparency = 1;
                                library:createElement("ImageLabel", {
                                    Name = "gradientSelector";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(255, 255, 255);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    library:createElement("UIGradient", {
                                        Name = "gradient";
                                        Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 0, 0));
                                    });
                                    library:createElement("Frame", {
                                        Name = "slider";
                                        Size = UDim2.new(0, 2, 1, 0);
                                        BorderSizePixel = 0;
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                                        Position = UDim2.new(math.clamp(R / 255, 0, 0.98), 0, 0, 0);
                                    })
                                });
                            });
                            library:createElement("ImageLabel", {
                                Name = "selectedColorBorder";
                                Size = UDim2.new(0.09, 0, 0.65, 0);
                                Position = UDim2.new(0.87, 0, 0.35/2, 0);
                                BackgroundTransparency = 1;
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.35;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                library:createElement("ImageLabel", {
                                    Name = "selectedColor";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(R, 0, 0);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                })
                            })
                        })
                    });
                    library:createElement("ImageLabel", {
                        Name = "greenBorder";
                        Size = UDim2.new(1, -10, 0, 25);
                        Position = UDim2.new(0, 5, 0, 55);
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://4894670678";
                        ImageColor3 = Color3.fromRGB(25, 25, 25);
                        ImageTransparency = 0.35;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(5, 5, 434, 297);
                        library:createElement("ImageLabel", {
                            Name = "frame";
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            BackgroundTransparency = 1;
                            Image = "rbxassetid://4894670678";
                            ImageColor3 = Color3.fromRGB(40, 40, 40);
                            ScaleType = Enum.ScaleType.Slice;
                            SliceCenter = Rect.new(5, 5, 434, 297);
                            ClipsDescendants = true;
                            library:createElement("TextLabel", {
                                Name = "greenLabel";
                                Size = UDim2.new(0.1, 0, 0.1, 0);
                                Position = UDim2.new(0.015, 0, 0.5, -1);
                                Text = "G";
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 10;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            });
                            library:createElement("ImageLabel", {
                                Name = "gradientSelectorBorder";
                                Size = UDim2.new(0.65, 0, 0.65, 0);
                                Position = UDim2.new(0.25/2, 0, 0.35/2, 0);
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                BackgroundTransparency = 1;
                                library:createElement("ImageLabel", {
                                    Name = "gradientSelector";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(255, 255, 255);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    library:createElement("UIGradient", {
                                        Name = "gradient";
                                        Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 255, 0));
                                    });
                                    library:createElement("Frame", {
                                        Name = "slider";
                                        Size = UDim2.new(0, 2, 1, 0);
                                        BorderSizePixel = 0;
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                                        Position = UDim2.new(math.clamp(G / 255, 0, 0.98), 0, 0, 0);
                                    })
                                });
                            });
                            library:createElement("ImageLabel", {
                                Name = "selectedColorBorder";
                                Size = UDim2.new(0.09, 0, 0.65, 0);
                                Position = UDim2.new(0.87, 0, 0.35/2, 0);
                                BackgroundTransparency = 1;
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.35;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                library:createElement("ImageLabel", {
                                    Name = "selectedColor";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(0, G, 0);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                })
                            })
                        })
                    });
                    library:createElement("ImageLabel", {
                        Name = "blueBorder";
                        Size = UDim2.new(1, -10, 0, 25);
                        Position = UDim2.new(0, 5, 0, 85);
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://4894670678";
                        ImageColor3 = Color3.fromRGB(25, 25, 25);
                        ImageTransparency = 0.35;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(5, 5, 434, 297);
                        library:createElement("ImageLabel", {
                            Name = "frame";
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            BackgroundTransparency = 1;
                            Image = "rbxassetid://4894670678";
                            ImageColor3 = Color3.fromRGB(40, 40, 40);
                            ScaleType = Enum.ScaleType.Slice;
                            SliceCenter = Rect.new(5, 5, 434, 297);
                            ClipsDescendants = true;
                            library:createElement("TextLabel", {
                                Name = "blueLabel";
                                Size = UDim2.new(0.1, 0, 0.1, 0);
                                Position = UDim2.new(0.015, 0, 0.5, -1);
                                Text = "B";
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 10;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            });
                            library:createElement("ImageLabel", {
                                Name = "gradientSelectorBorder";
                                Size = UDim2.new(0.65, 0, 0.65, 0);
                                Position = UDim2.new(0.25/2, 0, 0.35/2, 0);
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                BackgroundTransparency = 1;
                                library:createElement("ImageLabel", {
                                    Name = "gradientSelector";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(255, 255, 255);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    library:createElement("UIGradient", {
                                        Name = "gradient";
                                        Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 255));
                                    });
                                    library:createElement("Frame", {
                                        Name = "slider";
                                        Size = UDim2.new(0, 2, 1, 0);
                                        BorderSizePixel = 0;
                                        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                                        Position = UDim2.new(math.clamp(B / 255, 0, 0.98), 0, 0, 0);
                                    })
                                });
                            });
                            library:createElement("ImageLabel", {
                                Name = "selectedColorBorder";
                                Size = UDim2.new(0.09, 0, 0.65, 0);
                                Position = UDim2.new(0.87, 0, 0.35/2, 0);
                                BackgroundTransparency = 1;
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.35;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                library:createElement("ImageLabel", {
                                    Name = "selectedColor";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(0, 0, B);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                })
                            })
                        })
                    });
                    library:createElement("ImageLabel", {
                        Name = "finalBorder";
                        Size = UDim2.new(1, -10, 0, 25);
                        Position = UDim2.new(0, 5, 0, 115);
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://4894670678";
                        ImageColor3 = Color3.fromRGB(25, 25, 25);
                        ImageTransparency = 0.35;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(5, 5, 434, 297);
                        library:createElement("ImageLabel", {
                            Name = "frame";
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            BackgroundTransparency = 1;
                            Image = "rbxassetid://4894670678";
                            ImageColor3 = Color3.fromRGB(40, 40, 40);
                            ScaleType = Enum.ScaleType.Slice;
                            SliceCenter = Rect.new(5, 5, 434, 297);
                            ClipsDescendants = true;
                            library:createElement("TextLabel", {
                                Name = "redLabel";
                                Size = UDim2.new(0.1, 0, 0.1, 0);
                                Position = UDim2.new(0.015, 0, 0.5, -1);
                                Text = "R";
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 10;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            });
                            library:createElement("ImageLabel", {
                                Name = "redButtonBorder";
                                Size = UDim2.new(0, 30, 0, 15);
                                Position = UDim2.new(0, 20, 0, 4);
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.5;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                BackgroundTransparency = 1;
                                library:createElement("ImageLabel", {
                                    Name = "redButtonFrame";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(70, 70, 70);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    library:createElement("TextBox", {
                                        Name = "redLabel";
                                        Size = UDim2.new(1, 0, 1, 0);
                                        Position = UDim2.new(0, 0, 0, 0);
                                        Text = R;
                                        TextColor3 = Color3.fromRGB(250, 250, 250);
                                        TextSize = 12;
                                        TextWrapped = true;
                                        Font = Enum.Font.GothamSemibold;
                                        BackgroundTransparency = 1;
                                    })
                                })
                            });
                            library:createElement("TextLabel", {
                                Name = "greenLabel";
                                Size = UDim2.new(0.1, 0, 0.1, 0);
                                Position = UDim2.new(0.27, 0, 0.5, -1);
                                Text = "G";
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 10;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            });
                            library:createElement("ImageLabel", {
                                Name = "greenButtonBorder";
                                Size = UDim2.new(0, 30, 0, 15);
                                Position = UDim2.new(0, 68, 0, 4);
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.5;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                BackgroundTransparency = 1;
                                library:createElement("ImageLabel", {
                                    Name = "greenButtonFrame";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(70, 70, 70);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    library:createElement("TextBox", {
                                        Name = "greenLabel";
                                        Size = UDim2.new(1, 0, 1, 0);
                                        Position = UDim2.new(0, 0, 0, 0);
                                        Text = G;
                                        TextColor3 = Color3.fromRGB(250, 250, 250);
                                        TextSize = 12;
                                        TextWrapped = true;
                                        Font = Enum.Font.GothamSemibold;
                                        BackgroundTransparency = 1;
                                    })
                                })
                            });
                            library:createElement("TextLabel", {
                                Name = "blueLabel";
                                Size = UDim2.new(0.1, 0, 0.1, 0);
                                Position = UDim2.new(0.53, 0, 0.5, -1);
                                Text = "B";
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 10;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            });
                            library:createElement("ImageLabel", {
                                Name = "blueButtonBorder";
                                Size = UDim2.new(0, 30, 0, 15);
                                Position = UDim2.new(0, 116, 0, 4);
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.5;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                BackgroundTransparency = 1;
                                library:createElement("ImageLabel", {
                                    Name = "blueButtonFrame";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(70, 70, 70);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                    library:createElement("TextBox", {
                                        Name = "blueLabel";
                                        Size = UDim2.new(1, 0, 1, 0);
                                        Position = UDim2.new(0, 0, 0, 0);
                                        Text = B;
                                        TextColor3 = Color3.fromRGB(250, 250, 250);
                                        TextSize = 12;
                                        TextWrapped = true;
                                        Font = Enum.Font.GothamSemibold;
                                        BackgroundTransparency = 1;
                                    })
                                })
                            });
                            library:createElement("ImageLabel", {
                                Name = "selectedColorBorder";
                                Size = UDim2.new(0.09, 0, 0.65, 0);
                                Position = UDim2.new(0.87, 0, 0.35/2, 0);
                                BackgroundTransparency = 1;
                                Image = "rbxassetid://4894670678";
                                ImageColor3 = Color3.fromRGB(25, 25, 25);
                                ImageTransparency = 0.35;
                                ScaleType = Enum.ScaleType.Slice;
                                SliceCenter = Rect.new(5, 5, 434, 297);
                                library:createElement("ImageLabel", {
                                    Name = "selectedColor";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    Image = "rbxassetid://4894670678";
                                    ImageColor3 = Color3.fromRGB(R, G, B);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 434, 297);
                                    BackgroundTransparency = 1;
                                    ClipsDescendants = true;
                                })
                            })
                        })
                    });
                })
            });
            Parent = self.container;
        })

        local selectors = {
            red = {
                slider = newColorSelector.border.frame.redBorder.frame.gradientSelectorBorder.gradientSelector.slider;
                selectedColor = newColorSelector.border.frame.redBorder.frame.selectedColorBorder.selectedColor;
            };
            green = {
                slider = newColorSelector.border.frame.greenBorder.frame.gradientSelectorBorder.gradientSelector.slider;
                selectedColor = newColorSelector.border.frame.greenBorder.frame.selectedColorBorder.selectedColor;
            };
            blue = {
                slider = newColorSelector.border.frame.blueBorder.frame.gradientSelectorBorder.gradientSelector.slider;
                selectedColor = newColorSelector.border.frame.blueBorder.frame.selectedColorBorder.selectedColor;
            };
        }

        local textBoxes = {
            finalColor = newColorSelector.border.frame.finalBorder.frame.selectedColorBorder.selectedColor;
            red = {
                textBox = newColorSelector.border.frame.finalBorder.frame.redButtonBorder.redButtonFrame.redLabel;
            };
            green = {
                textBox = newColorSelector.border.frame.finalBorder.frame.greenButtonBorder.greenButtonFrame.greenLabel;
            };
            blue = {
                textBox = newColorSelector.border.frame.finalBorder.frame.blueButtonBorder.blueButtonFrame.blueLabel;
            };
        }
        
        local function updateColors(color, num)
            if color == "red" then
                R = num
                selectors[color].selectedColor.ImageColor3 = Color3.fromRGB(R, 0, 0)
            elseif color == "green" then
                G = num
                selectors[color].selectedColor.ImageColor3 = Color3.fromRGB(0, G, 0)
            elseif color == "blue" then
                B = num
                selectors[color].selectedColor.ImageColor3 = Color3.fromRGB(0, 0, B)
            else
                return
            end

            textBoxes[color].textBox.Text = num

            textBoxes.finalColor.ImageColor3 = Color3.fromRGB(R, G, B)

            selectors[color].slider:TweenPosition(UDim2.new(math.clamp(num / 255, 0, 0.98), 0, 0, 0), "Out", "Quad", 0.15, true)

            location[flag] = Color3.fromRGB(R, G, B)
            callback(location[flag])
        end

        for i,v in pairs(selectors) do
            local renderStepped, inputBegan, inputEnded

            local connected = false

            local slider = v.slider
            local container = slider.Parent
            local selectedColor = v.selectedColor

            container.MouseEnter:Connect(function()
                local function update()
                    if renderStepped then renderStepped:Disconnect() end

                    renderStepped = runService.RenderStepped:Connect(function()
                        local mouse = userInputService:GetMouseLocation()
                        local percent = (mouse.X - container.AbsolutePosition.X) / (container.AbsoluteSize.X)

                        percent = math.clamp(percent, 0, 1)
                        percent = tonumber(string.format("%.2f", percent))

                        local num = math.floor(percent * 255)

                        updateColors(i, num)
                    end)
                end

                local function disconnect()
                    if renderStepped then renderStepped:Disconnect() end
                    if inputBegan then inputBegan:Disconnect() end
                    if inputEnded then inputEnded:Disconnect() end
                    if mouseDown then mouseDown:Disconnect() end
                    if mouseUp then mouseUp:Disconnect() end
                end

                inputBegan = container.InputBegan:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                    connected = true
                    update()
                end)

                inputEnded = container.InputEnded:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                    if not connected then return end
                    disconnect()
                    connected = false
                end)
            end)
        end

        for i,v in pairs(textBoxes) do
            if type(v) == "table" then

                local slider = selectors[i].slider

                local first = true

                v.textBox:GetPropertyChangedSignal("Text"):Connect(function()
                    v.textBox.Text = v.textBox.Text:gsub("%D+", "")
                end)

                v.textBox.FocusLost:Connect(function(enterPressed)
                    if not enterPressed then 
                        if i == "red" then
                            v.textBox.Text = R
                        elseif i == "green" then
                            v.textBox.Text = G
                        elseif i == "blue" then
                            v.textBox.Text = B
                        end

                        return 
                    end

                    v.textBox.Text = math.clamp(tonumber(v.textBox.Text), 0, 255)

                    updateColors(i, tonumber(v.textBox.Text))
                end)

            end
        end
    end

    function tabs:button(name, callback)
        local callback = callback or function() end

        local newButton = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 35);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 26);
                Position = UDim2.new(0, 0, 0, 5);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(200, 58, 75);
                ImageTransparency = 0.35;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                library:createElement("ImageButton", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    ClipsDescendants = true;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(1, 0, 1, 0);
                        Position = UDim2.new(0, 0, 0, 0);
                        Text = name;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("ImageLabel", {
                        Name = "mouseIcon";
                        Size = UDim2.new(0, 14, 0, 18);
                        Position = UDim2.new(0, 5, 0, 3);
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://5880691637";
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(6, 6, 14, 14);
                        BackgroundTransparency = 1;
                    })
                })
            });
            Parent = self.container;
        })

        newButton.border.frame.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            callback()
        end)
    end

    function tabs:toggle(name, options, useBind, bindOptions, callback)
        local location = options.location or self.flags
        local flag = options.flag or ""
        local default = options.default or false
        local callback = callback or function() end

        location[flag] = default

        local newToggle = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 35);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 26);
                Position = UDim2.new(0, 0, 0, 5);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(25, 25, 25);
                ImageTransparency = 0.5;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                library:createElement("ImageLabel", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    ClipsDescendants = true;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(1, -10, 1, 0);
                        Position = UDim2.new(0, 10, 0, 0);
                        Text = name;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("ImageButton", {
                        Name = "button";
                        Size = UDim2.new(0, 18, 0, 18);
                        Position = UDim2.new(1, -26, 0, 3);
                        BackgroundTransparency = 1;
                        Image = "rbxassetid://4892761119";
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(6, 6, 14, 14);
                        BackgroundTransparency = 1;
                        library:createElement("ImageLabel", {
                            Name = "toggle";
                            Size = (location[flag] and UDim2.new(1, 0, 1, 0)) or UDim2.new(0, 0, 0, 0);
                            Position = (location[flag] and UDim2.new(0, 0, 0, 0)) or UDim2.new(0.5, 0, 0.5, 0);
                            Image = "rbxassetid://5880482965";
                            BackgroundTransparency = 1;
                        })
                    })
                })
            });
            Parent = self.container;
        })

        local button = newToggle.border.frame.button

        local click = function()
            location[flag] = not location[flag]
            callback(location[flag])
            button.toggle:TweenSizeAndPosition((location[flag] and UDim2.new(1, 0, 1, 0)) or UDim2.new(0, 0, 0, 0), (location[flag] and UDim2.new(0, 0, 0, 0)) or UDim2.new(0.5, 0, 0.5, 0), (location[flag] and 'Out') or 'In', (location[flag] and 'Elastic') or 'Quad', (location[flag] and 0.75) or 0.15, true)
        end

        if useBind then
            local shortNames = {
                LeftControl = "LeftCtrl";
                LeftShift = "LShift";
                RightShift = "RShift";
                MouseButton1 = "Mouse1";
                MouseButton2 = "Mouse2";
            }

            local banned = {
                Return = true;
                Space = true;
                Tab = true;
                Unknown = true;
                RightControl = true;
            }

            local allowed = {
                MouseButton1 = true;
                MouseButton2 = true;
            }

            local bindLocation = bindOptions.location or self.flags
            local bindFlag = bindOptions.flag or ""
            local kbOnly = bindOptions.kbonly or false
            local bindDefault = bindOptions.default or nil

            local passed = true
            if kbOnly and tostring(bindDefault):find("MouseButton") then
                passed = false
            end
            
            if passed then
                bindLocation[bindFlag] = bindDefault
            end

            local name = (bindDefault and (shortNames[bindDefault.Name] or bindDefault.Name)) or "None"

            local bind = library:createElement("ImageLabel", {
                Name = "bindBorder";
                Size = ((bindDefault and shortNames[bindDefault.Name] or name == "None") and UDim2.new(0, 50, 0, 15)) or UDim2.new(0, 30, 0, 15);
                Position = ((bindDefault and shortNames[bindDefault.Name] or name == "None") and UDim2.new(0, 115, 0, 4)) or UDim2.new(0, 135, 0, 4);
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(25, 25, 25);
                ImageTransparency = 0.5;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                BackgroundTransparency = 1;
                library:createElement("ImageLabel", {
                    Name = "bindFrame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(70, 70, 70);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    BackgroundTransparency = 1;
                    ClipsDescendants = true;
                    library:createElement("TextButton", {
                        Name = "bindLabel";
                        Size = UDim2.new(1, 0, 1, 0);
                        Position = UDim2.new(0, 0, 0, 0);
                        Text = name;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        BackgroundTransparency = 1;
                    })
                });
                Parent = newToggle.border.frame;
            })

            bind.bindFrame.bindLabel.MouseButton1Click:Connect(function()
                library.binding = true

                bind.bindFrame.bindLabel.Text = "..."

                local input, b = userInputService.InputBegan:Wait()

                if (input.UserInputType ~= Enum.UserInputType.Keyboard and allowed[input.UserInputType.Name] and not kbOnly) or (input.KeyCode and not banned[input.KeyCode.Name]) then
                    local name = (input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType.Name) or ((input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Escape) and "None") or input.KeyCode.Name
                    
                    if name == "None" then
                        bindLocation[bindFlag] = nil
                    else
                        bindLocation[bindFlag] = input
                    end

                    if shortNames[name] then
                        bind:TweenSizeAndPosition(UDim2.new(0, 50, 0, 15), UDim2.new(0, 115, 0, 4), "Out", "Quad", 0.15, true)
                        bind.bindFrame.bindLabel.Text = shortNames[name]
                    else
                        bind:TweenSizeAndPosition((string.len(name) > 3 and UDim2.new(0, 50, 0, 15)) or UDim2.new(0, 30, 0, 15), (string.len(name) > 3 and UDim2.new(0, 115, 0, 4)) or UDim2.new(0, 135, 0, 4), 'Out', 'Quad', 0.15, true)
                        bind.bindFrame.bindLabel.Text = name
                    end
                else
                    if bindLocation[bindFlag] then
                        local name

                        if (not pcall(function()
                            return bindLocation[bindFlag].UserInputType
                        end)) then
                            name = tostring(bindLocation[bindFlag])
                        else
                            name = (bindLocation[bindFlag].UserInputType ~= Enum.UserInputType.Keyboard and bindLocation[bindFlag].UserInputType.Name) or bindLocation[bindFlag].KeyCode.Name
                        end

                        if shortNames[name] then
                            bind:TweenSizeAndPosition(UDim2.new(0, 50, 0, 15), UDim2.new(0, 115, 0, 4), 'Out', 'Quad', 0.15, true);
                            bind.bindFrame.bindLabel.Text = shortNames[name]
                        else
                            bind:TweenSizeAndPosition((string.len(name) > 3 and UDim2.new(0, 50, 0, 15)) or UDim2.new(0, 30, 0, 15), (string.len(name) > 3 and UDim2.new(0, 115, 0, 4)) or UDim2.new(0, 135, 0, 4), 'Out', 'Quad', 0.15, true)
                            bind.bindFrame.bindLabel.Text = name
                        end
                    end
                end

                wait(0.1)
                library.binding = false
            end)

            library.binds[bindFlag] = {
                location = bindLocation;
                call = click;
            }
        end

        button.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            click()
        end)
    end

    function tabs:slider(name, options, sliderCallback, useToggle, toggleOptions)
        local sLocation = options.location or self.flags
        local sFlag = options.flag or ""
        local min = options.min or 0
        local max = options.max or 1
        local sDefault = (options.default ~= nil and math.floor(math.clamp(options.default, min, max))) or min
        local sCallback = sliderCallback or function() end

        sLocation[sFlag] = sDefault

        local newSlider = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 55);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 45);
                Position = UDim2.new(0, 0, 0, 5);
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(25, 25, 25);
                ImageTransparency = 0.5;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                BackgroundTransparency = 1;
                ClipsDescendants = true;
                library:createElement("ImageLabel", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    BackgroundTransparency = 1;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(1, -8, 0.5, 0);
                        Position = UDim2.new(0, 8, 0, 0);
                        Text = name;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("ImageLabel", {
                        Name = "valueButtonBorder";
                        Size = UDim2.new(0, 35, 0, 15);
                        Position = UDim2.new(0, 155, 0, 4);
                        Image = "rbxassetid://4894670678";
                        ImageColor3 = Color3.fromRGB(25, 25, 25);
                        ImageTransparency = 0.5;
                        ScaleType = Enum.ScaleType.Slice;
                        SliceCenter = Rect.new(5, 5, 434, 297);
                        BackgroundTransparency = 1;
                        library:createElement("ImageLabel", {
                            Name = "valueButtonFrame";
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            Image = "rbxassetid://4894670678";
                            ImageColor3 = Color3.fromRGB(70, 70, 70);
                            ScaleType = Enum.ScaleType.Slice;
                            SliceCenter = Rect.new(5, 5, 434, 297);
                            BackgroundTransparency = 1;
                            ClipsDescendants = true;
                            library:createElement("TextBox", {
                                Name = "valueLabel";
                                Size = UDim2.new(1, 0, 1, 0);
                                Position = UDim2.new(0, 0, 0, 0);
                                Text = tostring(sDefault);
                                TextColor3 = Color3.fromRGB(250, 250, 250);
                                TextSize = 12;
                                TextWrapped = true;
                                Font = Enum.Font.GothamSemibold;
                                BackgroundTransparency = 1;
                            })
                        })
                    });
                    library:createElement("Frame", {
                        Name = "container";
                        BorderSizePixel = 0;
                        Size = UDim2.new(0, (useToggle and 150) or 175, 0, 8);
                        Position = UDim2.new(0, (useToggle and 35) or 10, 0, 27);
                        BackgroundTransparency = 1;
                        library:createElement("Frame", {
                            Name = "sliderBar";
                            Size = UDim2.new(1, 0, 0, 2);
                            Position = UDim2.new(0, 0, 0, 3);
                            BorderSizePixel = 0;
                            library:createElement("Frame", {
                                Name = "moveBar";
                                Size = UDim2.new(((sDefault - min) / (max - min)), 0, 1, 0);
                                Position = UDim2.new(0, 0, 0, 0);
                                BorderSizePixel = 0;
                                BackgroundColor3 = Color3.fromRGB(200, 58, 75);
                                BackgroundTransparency = 0;
                            });
                            library:createElement("ImageLabel", {
                                Name = "circleBorder";
                                Size = UDim2.new(0, 10, 0, 10);
                                Position = UDim2.new(((sDefault - min) / (max - min)), 0, 0, -4);
                                BackgroundTransparency = 1;
                                Image = "rbxassetid://4896743658";
                                ImageColor3 = Color3.fromRGB(100, 100, 100);
                                ImageTransparency = 0.3;
                                library:createElement("ImageLabel", {
                                    Name = "circleFrame";
                                    Size = UDim2.new(1, -2, 1, -2);
                                    Position = UDim2.new(0, 1, 0, 1);
                                    BackgroundTransparency = 1;
                                    Image = "rbxassetid://4896743658";
                                    ImageColor3 = Color3.fromRGB(255, 255, 255);
                                    ScaleType = Enum.ScaleType.Slice;
                                    SliceCenter = Rect.new(5, 5, 5, 5);
                                })
                            })
                        })
                    })
                })
            });
            Parent = self.container;
        })

        if useToggle then
            local tLocation = toggleOptions.location or self.flags
            local tFlag = toggleOptions.flag or ""
            local tDefault = toggleOptions.default or false
            local tCallback = toggleOptions.callback or function() end

            tLocation[tFlag] = tDefault

            local sliderToggle = library:createElement("ImageButton", {
                Name = "button";
                Size = UDim2.new(0, 18, 0, 18);
                Position = UDim2.new(0, 8, 0, 21);
                Image = "rbxassetid://4892761119";
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(6, 6, 14, 14);
                BackgroundTransparency = 1;
                library:createElement("ImageLabel", {
                    Name = "toggle";
                    Size = (tLocation[tFlag] and UDim2.new(1, 0, 1, 0)) or UDim2.new(0, 0, 0, 0);
                    Position = (tLocation[tFlag] and UDim2.new(0, 0, 0, 0)) or UDim2.new(0.5, 0, 0.5, 0);
                    Image = "rbxassetid://5880482965";
                    BackgroundTransparency = 1;
                });
                Parent = newSlider.border.frame;
            })

            sliderToggle.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

                tLocation[tFlag] = not tLocation[tFlag]
                tCallback(tLocation[tFlag])
                sliderToggle.toggle:TweenSizeAndPosition((tLocation[tFlag] and UDim2.new(1, 0, 1, 0)) or UDim2.new(0, 0, 0, 0), (tLocation[tFlag] and UDim2.new(0, 0, 0, 0)) or UDim2.new(0.5, 0, 0.5, 0), (tLocation[tFlag] and 'Out') or 'In', (tLocation[tFlag] and 'Elastic') or 'Quad', (tLocation[tFlag] and 0.75) or 0.15, true)
            end)
        end

        local renderStepped, inputBegan, inputEnded, mouseDown, mouseUp
        local connected = false
        local first = true

        local container = newSlider.border.frame.container
        local textBox = newSlider.border.frame.valueButtonBorder.valueButtonFrame.valueLabel

        container.MouseEnter:Connect(function()
            local function update()
                if renderStepped then renderStepped:Disconnect() end

                renderStepped = runService.RenderStepped:Connect(function()
                    local mouse = userInputService:GetMouseLocation()
                    local percent = (mouse.X - container.AbsolutePosition.X) / (container.AbsoluteSize.X)

                    percent = math.clamp(percent, 0, 1)
                    percent = tonumber(string.format("%.2f", percent))

                    if first then
                        container.sliderBar.circleBorder.Position = UDim2.new(((sDefault - min) / (max - min)), -4, 0, -4)
                        container.sliderBar.moveBar.Size = UDim2.new(((sDefault - min) / (max - min)), -4, 0, 2)
                        first = false
                    end

                    container.sliderBar.circleBorder:TweenPosition(UDim2.new(math.clamp(percent, 0, 1), -4, 0, -4), 'Out', 'Quad', 0.15, true)
                    container.sliderBar.moveBar:TweenSize(UDim2.new(math.clamp(percent, 0, 1), -4, 0, 2), 'Out', 'Quad', 0.15, true)

                    local num = min + (max - min) * percent
                    local value = math.floor(num)

                    textBox.Parent.Parent:TweenSizeAndPosition((string.len(tostring(value)) > 3 and UDim2.new(0, 45, 0, 15)) or UDim2.new(0, 30, 0, 15), (string.len(tostring(value)) > 3 and UDim2.new(0, 140, 0, 4)) or UDim2.new(0, 155, 0, 4), 'Out', 'Quad', 0.15, true)

                    textBox.Text = value
                    sLocation[sFlag] = tonumber(value)
                    sCallback(sLocation[sFlag])
                end)
            end

            local function disconnect()
                if renderStepped then renderStepped:Disconnect() end
                if inputBegan then inputBegan:Disconnect() end
                if inputEnded then inputEnded:Disconnect() end
                if mouseDown then mouseDown:Disconnect() end
                if mouseUp then mouseUp:Disconnect() end
            end

            inputBegan = container.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                update()
            end)

            inputEnded = container.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                disconnect()
            end)

            mouseDown = container.sliderBar.circleBorder.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                connected = true
                update()
            end)

            mouseUp = container.sliderBar.circleBorder.InputEnded:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                if not connected then return end
                disconnect()
                connected = false
            end)
        end)

        textBox:GetPropertyChangedSignal("Text"):Connect(function()
            textBox.Text = textBox.Text:gsub("[^%-%d]", "")
            textBox.Parent.Parent:TweenSizeAndPosition((string.len(textBox.Text) > 3 and UDim2.new(0, 45, 0, 15)) or UDim2.new(0, 30, 0, 15), (string.len(textBox.Text) > 3 and UDim2.new(0, 140, 0, 4)) or UDim2.new(0, 155, 0, 4), 'Out', 'Quad', 0.15, true)
        end)

        textBox.FocusLost:Connect(function(enterPressed)
            if not enterPressed then return end

            textBox.Text = math.floor(math.clamp(tonumber(textBox.Text), min, max))
            textBox.Parent.Parent:TweenSizeAndPosition((string.len(textBox.Text) > 3 and UDim2.new(0, 45, 0, 15)) or UDim2.new(0, 30, 0, 15), (string.len(textBox.Text) > 3 and UDim2.new(0, 140, 0, 4)) or UDim2.new(0, 155, 0, 4), 'Out', 'Quad', 0.15, true)
            sLocation[sFlag] = tonumber(textBox.Text)
            sCallback(sLocation[sFlag])

            container.sliderBar.circleBorder:TweenPosition(UDim2.new(((math.floor(math.clamp(tonumber(textBox.Text), min, max)) - min) / (max - min)), -4, 0, -4), 'Out', 'Quad', 0.15, true)
            container.sliderBar.moveBar:TweenSize(UDim2.new(((math.floor(math.clamp(tonumber(textBox.Text), min, max)) - min) / (max - min)), -4, 0, 2), 'Out', 'Quad', 0.15, true)
        end)
    end

    function tabs:dropdown(name, useToggles, options, callback)
        local location = options.location or self.flags
        local flag = not useToggles and options.flag or ""
        local callback = callback or function() end
        local list = options.list or {}
        local default = options.default or list[1].Name

        if not useToggles then
            location[flag] = default
        end

        local newDropdown = library:createElement("Frame", {
            Name = name;
            Size = UDim2.new(0, 200, 0, 35);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            library:createElement("ImageLabel", {
                Name = "border";
                Size = UDim2.new(1, 0, 0, 26);
                Position = UDim2.new(0, 0, 0, 5);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(25, 25, 25);
                ImageTransparency = 0.5;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                ZIndex = 2;
                library:createElement("ImageButton", {
                    Name = "frame";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    ZIndex = 2;
                    library:createElement("TextLabel", {
                        Name = "label";
                        Size = UDim2.new(1, -10, 0, 25);
                        Position = UDim2.new(0, 10, 0, 0);
                        Text = default;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        TextSize = 12;
                        TextWrapped = true;
                        Font = Enum.Font.GothamSemibold;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        BackgroundTransparency = 1;
                        ZIndex = 2;
                    })
                })
            });
            Parent = self.container;
        })

        local arrow = library:createElement("ImageLabel", {
            Name = "arrow";
            Size = UDim2.new(0, 11, 0, 6);
            Position = UDim2.new(1, -25, 0, 10);
            BackgroundTransparency = 1;
            Image = "rbxassetid://5882688826";
            ImageColor3 = Color3.fromRGB(30, 30, 30);
            ZIndex = 2;
            Parent = newDropdown.border;
        })

        local container = library:createElement("Frame", {
            Name = "containerFrame";
            Size = UDim2.new(1, 0, 0, 0);
            BackgroundTransparency = 1;
            LayoutOrder = self:getOrder();
            ZIndex = 1;
            ClipsDescendants = true;
            library:createElement("ImageLabel", {
                Name = "containerBorder";
                Size = UDim2.new(0.9, 0, 1, 0);
                Position = UDim2.new(0.05, 0, 0, 0);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(25, 25, 25);
                ImageTransparency = 0.3;
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                ClipsDescendants = true;
                ZIndex = 1;
                library:createElement("ImageLabel", {
                    Name = "container";
                    Size = UDim2.new(1, -2, 1, -2);
                    Position = UDim2.new(0, 1, 0, 1);
                    BackgroundTransparency = 1;
                    Image = "rbxassetid://4894670678";
                    ImageColor3 = Color3.fromRGB(60, 60, 60);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 297);
                    ClipsDescendants = true;
                    ZIndex = 1;
                    library:createElement("ScrollingFrame", {
                        Name = "scroll";
                        Size = UDim2.new(1, 0, 1, 0);
                        Position = UDim2.new(0, 0, 0, 0);
                        CanvasSize = UDim2.new(0, 0, 0, (useToggles and #list * 27) or #list * 22);
                        ScrollingEnabled = #list > 5;
                        ScrollBarThickness = (#list > 5 and 2) or 0;
                        ScrollBarImageTransparency = (#list > 5 and 0) or 1;
                        ScrollingDirection = Enum.ScrollingDirection.Y;
                        ElasticBehavior = Enum.ElasticBehavior.Never;
                        BackgroundTransparency = 1;
                        library:createElement("UIListLayout", {
                            Name = "list";
                            SortOrder = 2;
                        })
                    })
                })
            });
            Parent = self.container;
        })

        local button = newDropdown.border.frame

        local dropDown = {
            toggled = false;
            object = newDropdown;
            arrow = arrow;
            container = container.containerBorder.container.scroll;
            l = location;
            f = flag;
            usesToggles = useToggles;
        }
        table.insert(dropList, dropDown)

        for i,v in pairs(list) do
            local listItem = library:createElement("TextButton", {
                Name = v.Name;
                Size = UDim2.new(1, 0, 0, useToggles and 27 or 22);
                BackgroundTransparency = 1;
                Text = v.Name;
                TextColor3 = Color3.fromRGB(250, 250, 250);
                TextSize = 12;
                TextWrapped = true;
                Font = Enum.Font.GothamSemibold;
                LayoutOrder = i;
                ZIndex = 1;
                Parent = dropDown.container;
            })

            local toggle
            if useToggles then
                toggle = library:createElement("ImageButton", {
                    Name = "button";
                    Size = UDim2.new(0, 16, 0, 16);
                    Position = UDim2.new(0, 150, 0, 4);
                    Image = "rbxassetid://4892761119";
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(6, 6, 14, 14);
                    BackgroundTransparency = 1;
                    library:createElement("ImageLabel", {
                        Name = "toggle";
                        Size = (location[v.flag] and UDim2.new(1, 0, 1, 0)) or UDim2.new(0, 0, 0, 0);
                        Position = (location[v.flag] and UDim2.new(0, 0, 0, 0)) or UDim2.new(0.5, 0, 0.5, 0);
                        Image = "rbxassetid://5880482965";
                        BackgroundTransparency = 1;
                    });
                    Parent = listItem;
                })
            end

            if i ~= #list then
                local underline = library:createElement("Frame", {
                    Name = "underline";
                    Size = UDim2.new(0.8, 0, 0, 2);
                    Position = UDim2.new(0.1, 0, 1, -2);
                    BackgroundColor3 = Color3.fromRGB(100, 100, 100);
                    BorderSizePixel = 0;
                    BackgroundTransparency = 0.3;
                    ZIndex = 1;
                    Parent = listItem;
                })
            end

            local function switch()
                if useToggles then
                    location[v.flag] = not location[v.flag]
                    callback(location[v.flag])
                    toggle.toggle:TweenSizeAndPosition((location[v.flag] and UDim2.new(1, 0, 1, 0)) or UDim2.new(0, 0, 0, 0), (location[v.flag] and UDim2.new(0, 0, 0, 0)) or UDim2.new(0.5, 0, 0.5, 0), (location[v.flag] and 'Out') or 'In', (location[v.flag] and 'Elastic') or 'Quad', (location[v.flag] and 0.75) or 0.15, true)
                else
                    dropDown.toggled = false

                    button.label.TextTransparency = 0
                    button.label.Text = listItem.Text

                    self.parentObject:TweenSize(UDim2.new(0, self.parentObject.AbsoluteSize.X, 0, originalTabY), "In", "Quad", 0.15, true)
                    self.container:TweenSize(UDim2.new(0, self.container.AbsoluteSize.X, 0, originalTabContainerY), "In", "Quad", 0.15, true)

                    newDropdown.border.arrow.Rotation = 0
                    container:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.15, true)
                    
                    location[flag] = tostring(listItem.Text)
                    callback(location[flag])
                end
            end

            listItem.InputBegan:Connect(function(input)
                if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                switch()
            end)

            if useToggles then
            
                toggle.InputBegan:Connect(function(input)
                    if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
                    switch()
                end)

            end
        end

        button.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

            dropDown.toggled = not dropDown.toggled

            if not useToggles then
                newDropdown.border.frame.label.TextTransparency = (dropDown.toggled and 0.5) or 0
                newDropdown.border.frame.label.Text = (dropDown.toggled and name) or location[flag]
            end

            local y = 0
            if #list > 5 then
                if useToggles then y = 5 * 27 else y = 5 * 22 end
            else
                for i,v in pairs(dropDown.container:GetChildren()) do
                    if not v:IsA("UIListLayout") then
                        y = y + v.AbsoluteSize.Y
                    end
                end
            end

            for i,v in pairs(dropList) do
                if v ~= dropDown and v.toggled then 
                    v.toggled = false
                    
                    v.arrow.Rotation = 0;
                    v.container.Parent.Parent.Parent:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.15, true)
                    wait(0.15)

                    if not useToggles then
                        v.object.border.frame.label.TextTransparency = 0
                        v.object.border.frame.label.Text = v.l[v.f]
                    end
                end
            end

            if dynamicTabContainerBottomYPos + y > dynamicContainerBottomYPos - 7 or not dropDown.toggled then
                self.parentObject:TweenSize(UDim2.new(0, self.parentObject.AbsoluteSize.X, 0, (dropDown.toggled and originalTabY + ((dynamicTabContainerBottomYPos + y) - dynamicContainerBottomYPos + 7)) or originalTabY), (dropDown.toggled and "Out") or "In", "Quad", 0.15, true)
            end

            self.container:TweenSize(UDim2.new(0, self.container.AbsoluteSize.X, 0, (dropDown.toggled and originalTabContainerY + y) or originalTabContainerY), (dropDown.toggled and 'Out') or 'In', 'Quad', 0.15, true)
            newDropdown.border.arrow.Rotation = (dropDown.toggled and 180) or 0
            container:TweenSize(UDim2.new(1, 0, 0, (dropDown.toggled and y) or 0), (dropDown.toggled and "Out") or "In", "Quad", 0.15, true)
        end)

        userInputService.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if not dropDown.toggled or (isInGui(newDropdown.border) or isInGui(container.containerBorder)) then return end

            dropDown.toggled = false

            if not useToggles then
                newDropdown.border.frame.label.TextTransparency = 0
                newDropdown.border.frame.label.Text = location[flag]
            end

            container:TweenSize(UDim2.new(1, 0, 0, 0), "In", "Quad", 0.15, true)
            self.parentObject:TweenSize(UDim2.new(0, self.parentObject.AbsoluteSize.X, 0, originalTabY), "In", "Quad", 0.15, true)
            self.container:TweenSize(UDim2.new(0, self.container.AbsoluteSize.X, 0, originalTabContainerY), "In", "Quad", 0.15, true)

            newDropdown.border.arrow.Rotation = 0
        end)
    end

    function library:createElement(class, data)
        local obj = Instance.new(class)
        
        for i,v in pairs(data) do
            if i ~= "Parent" then
            
                if typeof(v) == "Instance" then
                    v.Parent = obj
                else
                    obj[i] = v
                end
            end
        end
        
        obj.Parent = data.Parent
        return obj
    end
    
    function library:createWindow(name)
        if not library.container then
            library.container = self:createElement("ScreenGui", {
                self:createElement("Frame", {
                    Name = "Container";
                    Size = UDim2.new(1, -30, 1, 0);
                    Position = UDim2.new(0, 20, 0, 20);
                    BackgroundTransparency = 1;
                    Active = false;
                });
            }):FindFirstChild("Container")
        end

        if syn and syn.protect_gui then
            syn.protect_gui(library.container.Parent)
        end

        library.container.Parent.Parent = game:GetService("CoreGui");

        if not library.options then
            library.options = setmetatable({}, {__index = defaults})
        end

        if getgenv then
            getgenv().hattUI = library.container
        end

        local window = main:window(name)
        return window
    end

    function library:notify(title, text, timeout)
        local timeout = timeout or 5

        local notification = library:createElement("ImageLabel", {
            Name = "border";
            Size = UDim2.new(0, 200, 0, 75);
            Position = UDim2.new(1.1, 0, 0.87, 0);
            BackgroundTransparency = 1;
            Image = "rbxassetid://4894670678";
            ImageColor3 = Color3.fromRGB(200, 58, 75);
            ImageTransparency = 0.35;
            ScaleType = Enum.ScaleType.Slice;
            SliceCenter = Rect.new(5, 5, 434, 297);
            library:createElement("ImageLabel", {
                Name = "frame";
                Size = UDim2.new(1, -2, 1, -2);
                Position = UDim2.new(0, 1, 0, 1);
                BackgroundTransparency = 1;
                Image = "rbxassetid://4894670678";
                ImageColor3 = Color3.fromRGB(40, 40, 40);
                ScaleType = Enum.ScaleType.Slice;
                SliceCenter = Rect.new(5, 5, 434, 297);
                ClipsDescendants = true;
                library:createElement("ImageLabel", {
                    Name = "topBorder";
                    Size = UDim2.new(1, 0, 0, 30);
                    Position = UDim2.new(0, 0, 0, 0);
                    Image = "rbxassetid://4892463081";
                    ImageColor3 = Color3.fromRGB(50, 50, 50);
                    ScaleType = Enum.ScaleType.Slice;
                    SliceCenter = Rect.new(5, 5, 434, 125);
                    BackgroundTransparency = 1;
                    library:createElement("TextLabel", {
                        Name = "title";
                        Size = UDim2.new(0, 200, 0, 30);
                        Position = UDim2.new(0, 15, 0, 0);
                        Text = title;
                        TextWrapped = true;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextColor3 = Color3.fromRGB(250, 250, 250);
                        Font = Enum.Font.GothamSemibold;
                        TextSize = 14;
                        BackgroundTransparency = 1;
                    });
                    library:createElement("Frame", {
                        Name = "line";
                        Size = UDim2.new(1, 0, 0, 2);
                        Position = UDim2.new(0, 0, 1, -2);
                        BorderSizePixel = 0;
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35);
                    })
                });
                library:createElement("TextLabel", {
                    Name = "text";
                    Size = UDim2.new(0, 180, 0, 40);
                    Position = UDim2.new(0, 10, 0, 30);
                    Text = text;
                    TextColor3 = Color3.fromRGB(250, 250, 250);
                    TextWrapped = true;
                    Font = Enum.Font.GothamSemibold;
                    TextSize = 12;
                    BackgroundTransparency = 1;
                })
            });
            Parent = library.container;
        })
        spawn(function()
            wait(0.2)

            notification:TweenPosition(UDim2.new(0.88, 0, 0.87, 0), "In", "Quad", 0.25, true)

            wait(timeout)

            notification:TweenPosition(UDim2.new(1.1, 0, 0.87, 0), "In", "Quad", 0.25, true)

            wait(0.25)

            notification:Destroy()
        end)
    end

    local function isReallyPressed(bind, input)
        if typeof(bind) == "Instance" then
            if bind.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bind.KeyCode then
                return true
            elseif tostring(bind.UserInputType):find("MouseButton") and input.UserInputType == bind.UserInputType then
                return true
            end
        end

        if tostring(bind):find("MouseButton1") then
            return bind == input.UserInputType
        else
            return bind == input.KeyCode
        end
    end

    userInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightControl then
            library.toggled = not library.toggled
            --library.container:TweenPosition(UDim2.new(0, (library.toggled and 20) or (-30 - (library.container:GetChildren()[1].frame.AbsolutePosition.X + library.container:GetChildren()[1].frame.AbsoluteSize.X)), 0, library.container.AbsolutePosition.Y), "Out", "Quad", 0.15, true)
            library.container.Visible = not library.container.Visible
        end

        if library.binding then return end

        for i,v in pairs(library.binds) do
            if v.location[i] ~= nil then

                local realBinding = v.location[i]

                if realBinding and isReallyPressed(realBinding, input) then
                    v.call()
                end

            end
        end
    end)
end
