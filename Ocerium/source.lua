local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")

local Library = {
	["Theme"] = {
	        ["Font"] = "RobotoMono",
		["AccentColor"] = Color3.fromRGB(0,175,255),
		["FontColor"] = Color3.fromRGB(255,255,255),
		["HideKey"] = "LeftAlt"
	}
}


local CreateModule = {
    reg = {}
}

local function AddToReg(Instance)
    table.insert(CreateModule["reg"],Instance)
end

function CreateModule.Instance(instance,properties)
    local CreatedInstance

    if typeof(instance) == "string" then
        CreatedInstance = Instance.new(instance)
        
        for property,value in next,properties do
            CreatedInstance[property] = value
        end
    end
    return CreatedInstance;
end

local function Darker(Col,coe)
    local H,S,V = Color3.toHSV(Col)
    return Color3.fromHSV(H,S,V / (coe or 1.5));
end

local function Brighter(Col,coe)
    local H,S,V = Color3.toHSV(Col)
    return Color3.fromHSV(H,S,V * (coe or 1.5));
end


function Library.Main(Name,X,Y)

	for i,v in next,game.CoreGui:GetChildren() do
		if v.Name == "OcerLib" then
			v:Destroy()
		end
	end

	local OcerLib = CreateModule.Instance("ScreenGui",{
		Name = "OcerLib";
		Parent = game.CoreGui;
	})

    local Load = CreateModule.Instance("Frame",{
		Name = "LoadFrame";
		Parent = OcerLib;
		BackgroundColor3 = Color3.fromRGB(30,30,35);
        BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0.3,0,0.25,0);
        ZIndex = 5;
	})

    local LoadCorner = CreateModule.Instance("UICorner",{
        Parent = Load;
        Name = "Corner";
        CornerRadius = UDim.new(0,5);
    })

    local Topbar = CreateModule.Instance("Frame",{
		Name = "Topbar";
		Parent = OcerLib;
		BackgroundColor3 = Darker(Color3.fromRGB(30,30,35),1.15);
		BorderSizePixel = 0;
		Position = UDim2.new(0.3,0,0.25,0);
		Size = UDim2.new(0,X,0,30);
        Active = true;
        Draggable = true;
        Visible = false;
        ZIndex = 3;
	})

    local Corner = CreateModule.Instance("UICorner",{
        Parent = Topbar;
        Name = "Corner";
        CornerRadius = UDim.new(0,5);
    })



    Topbar.Changed:Connect(function(Property)
        if Property == "Position" then
            Load.Position = Topbar.Position
        end
    end)

	local NameLabel = CreateModule.Instance("TextLabel",{
		Parent = Topbar;
		Font = Enum.Font[Library["Theme"]["Font"]];
		Text = Name;
		TextSize = 16;
		TextColor3 = Library["Theme"]["FontColor"];
		TextXAlignment = Enum.TextXAlignment.Left;
		BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0,10,0,0);
		Size = UDim2.new(0.2,0,1,0);
        ZIndex = 3;
	})


	--//ContainerCode

	local Container = CreateModule.Instance("Frame",{
		Parent = Topbar;
		Name = "Container";
		BackgroundColor3 = Color3.fromRGB(30,30,33);
		BorderSizePixel = 0;
		Position = UDim2.new(0,0,1,-5);
		Size = UDim2.new(1,0,0,Y);
        ClipsDescendants = true;
	})

    local Border = CreateModule.Instance("Frame",{
		Name = "Border";
		Parent = Topbar;
		BackgroundColor3 = Color3.fromRGB(30,30,35);
        BackgroundTransparency = 0.99;
		BorderSizePixel = 0;
		Position = UDim2.new(0,0,0,0);
        ZIndex = 5;
	})

    local StrokeBorder = CreateModule.Instance("UIStroke",{
        Parent = Border;
        Name = "Stroke";
        Thickness = 1;
        Color = Library["Theme"]["AccentColor"];
        Transparency = 0.5;
    })

    local CornerBorder = CreateModule.Instance("UICorner",{
        Parent = Border;
        Name = "Corner";
        CornerRadius = UDim.new(0,5);
    })

    Load.Size = UDim2.new(0,Topbar.Size.X.Offset,0,Topbar.Size.Y.Offset + Container.Size.Y.Offset -5);
    Border.Size = UDim2.new(0,Topbar.Size.X.Offset,0,Topbar.Size.Y.Offset + Container.Size.Y.Offset -5);
    spawn(function()
        wait(0.2)
        TweenService:Create(Load,TweenInfo.new(0.3),{BackgroundTransparency = 0}):Play()
        wait(0.45)
        TweenService:Create(Load,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
        Topbar.Visible = true
    end)
    local Corner = CreateModule.Instance("UICorner",{
        Parent = Container;
        Name = "Corner";
        CornerRadius = UDim.new(0,5);
    })

    local Pages = CreateModule.Instance("Frame",{
		Parent = Container;
		Name = "Tabs";
        BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0,0,0,0);
		Size = UDim2.new(1,0,1,0);
	})

    local PageLayout = CreateModule.Instance("UIPageLayout",{
        Parent = Pages;
        Name = "PagesLayout";
        Padding = UDim.new(0,10);
        TweenTime = 0;
        EasingDirection = Enum.EasingDirection.Out;
        EasingStyle = Enum.EasingStyle.Sine;
        FillDirection = Enum.FillDirection.Vertical;
        HorizontalAlignment = Enum.HorizontalAlignment.Center;
    })


	local TabsButtons = CreateModule.Instance("Frame",{
		Parent = Topbar;
		Name = "TabsButtons";
        BackgroundTransparency = 1;
		BorderSizePixel = 0;
		Position = UDim2.new(0.3,0,0,0);
		Size = UDim2.new(0.7,0,1,0);
        ZIndex = 3;
	})


	local ButtonsList = CreateModule.Instance("UIListLayout",{
		Parent = TabsButtons;
        FillDirection = Enum.FillDirection.Horizontal;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0,10)
	})

    local IsGuiOpened = true


    InputService.InputBegan:Connect(function(input,IsTyping)
        if input.KeyCode == Enum.KeyCode[Library["Theme"]["HideKey"]] and not IsTyping then
            spawn(function()
                TweenService:Create(Load,TweenInfo.new(0.15),{BackgroundTransparency = 0}):Play()
                wait(0.2)
                TweenService:Create(Load,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
                Topbar.Visible = not Topbar.Visible
            end)
        end
    end)

	local InMain = {}
    local TabCount = 0


    function InMain.Nofitication(HeaderText,Text) -- not working
        local Bar = CreateModule.Instance("Frame",{
            Parent = OcerLib;
            Name = HeaderText;
            BackgroundColor3 = Color3.fromRGB(30,30,33);
            BorderSizePixel = 0;
            Position = UDim2.new(0.6,0,0.65,0);
            Size = UDim2.new(0.15,0,0.07,0);
            ClipsDescendants = true;
        })

        local HeaderLabel = CreateModule.Instance("TextLabel",{
            Parent = Bar;
            Font = Enum.Font[Library["Theme"]["Font"]];
            Text = HeaderText;
            TextSize = 22;
            TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
            TextXAlignment = Enum.TextXAlignment.Left;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.07,0,0.1,0);
            Size = UDim2.new(1,0,0.15,0);
        })

        local InformationLabel = CreateModule.Instance("TextLabel",{
            Parent = Bar;
            Font = Enum.Font[Library["Theme"]["Font"]];
            Text = Text;
            TextSize = 18;
            TextColor3 = Library["Theme"]["FontColor"];
            TextXAlignment = Enum.TextXAlignment.Left;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.1,0,0.125,0);
            Size = UDim2.new(1,0,0.85,0);
        })
    end

	function InMain.Tab(Text)
        TabCount += 1

		local TabButton = CreateModule.Instance("TextButton",{
			Parent = TabsButtons;
			Name = "TabsButtons";
            BackgroundTransparency = 1;
			BorderSizePixel = 0;
			Position = UDim2.new(0,0,0,0);
			Size = UDim2.new(0.15,0,1,0);
			Font = Enum.Font[Library["Theme"]["Font"]];
			Text = Text;
			TextSize = 15;
			TextXAlignment = Enum.TextXAlignment.Center;
			AutoButtonColor = false;
            AutomaticSize = Enum.AutomaticSize.X;
            ZIndex = 3;
		})

        local IsTabActive = CreateModule.Instance("BoolValue",{
            Parent = TabButton;
            Name = "IsActive";
            Value = (TabCount == 1 and true or TabCount ~= 1 and false)
        })

        TabButton.TextColor3 = (IsTabActive.Value and Library["Theme"]["FontColor"] or not IsTabActive.Value and Darker(Library["Theme"]["FontColor"],2))


		TabButton.MouseEnter:Connect(function()
            if IsTabActive.Value then
                TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Library["Theme"]["FontColor"]}):Play()
            else
                TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],1.5)}):Play()
            end
		end)

		TabButton.MouseLeave:Connect(function()
            if not IsTabActive.Value then
			    TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],2)}):Play()
            else
                TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],1.2)}):Play()
            end
		end)



        local Page = CreateModule.Instance("ScrollingFrame",{
            Parent = Pages;
            Name = Text;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0,0,0,0);
            Size = UDim2.new(0.95,0,1,0);
            CanvasSize = UDim2.new(0,0,0,0);
            AutomaticCanvasSize = Enum.AutomaticSize.Y;
            ScrollBarThickness = 0;
            ScrollBarImageTransparency = 1;
        })

        local PageList = CreateModule.Instance("Frame",{
            Parent = Page;
            Name = "PageList";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.015,0,0.015,0);
            Size = UDim2.new(0.5,0,1,0);
        })

        local PageList2 = CreateModule.Instance("Frame",{
            Parent = Page;
            Name = "PageList2";
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0.52,0,0.015,0);
            Size = UDim2.new(0.5,0,1,0);
        })

        local ElementsList = CreateModule.Instance("UIListLayout",{
            Parent = PageList;
            Padding = UDim.new(0,15);
            HorizontalAlignment = Enum.HorizontalAlignment.Left;
            SortOrder = Enum.SortOrder.LayoutOrder;
        })

        local ElementsList2 = CreateModule.Instance("UIListLayout",{
            Parent = PageList2;
            Padding = UDim.new(0,15);
            HorizontalAlignment = Enum.HorizontalAlignment.Left;
            SortOrder = Enum.SortOrder.LayoutOrder;
        })

        local Fader = CreateModule.Instance("Frame",{
            Parent = Page;
            Name = 'Fader';
            BackgroundColor3 = Color3.fromRGB(30,30,33);
            BorderSizePixel = 0;
            Position = UDim2.new(0,0,0,0);
            Size = UDim2.new(1,0,1,0);
            ZIndex = 2;
        })

        local ign = CreateModule.Instance("Frame",{
            Parent = PageList;
            Name = 'ign';
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0,0,0,0);
            Size = UDim2.new(0,0,0,0);
            LayoutOrder = -99;
        })

        local ign2 = CreateModule.Instance("Frame",{
            Parent = PageList;
            Name = 'ign';
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0,0,0,0);
            Size = UDim2.new(0,0,0,5);
            LayoutOrder = 999;
        })

        local ign3 = CreateModule.Instance("Frame",{
            Parent = PageList2;
            Name = 'ign';
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0,0,0,0);
            Size = UDim2.new(0,0,0,0);
            LayoutOrder = -99;
        })

        local ign4 = CreateModule.Instance("Frame",{
            Parent = PageList2;
            Name = 'ign';
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            Position = UDim2.new(0,0,0,0);
            Size = UDim2.new(0,0,0,5);
            LayoutOrder = 999;
        })

        TabButton.MouseButton1Click:Connect(function()
            for i,v in next,Pages:GetChildren() do
                if v.Name ~= Text and v:FindFirstChild("Fader") then
                    TweenService:Create(v.Fader,TweenInfo.new(0.3),{BackgroundTransparency = 0}):Play()
                    spawn(function()
                        wait(0.32)
                        PageLayout:JumpTo(Page)
                        TweenService:Create(Fader,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
                    end)
                end
            end

            for i,v in next,TabsButtons:GetChildren() do
                if v.ClassName == "TextButton" and v.Name ~= Text then
                    v.IsActive.Value = false
                    TweenService:Create(v,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],2)}):Play()
                end
            end
            IsTabActive.Value = true
            TweenService:Create(TabButton,TweenInfo.new(0.3),{TextColor3 = Library["Theme"]["FontColor"]}):Play()
        end)

        if TabCount == 1 then
            PageLayout:JumpTo(Page)
            TweenService:Create(Fader,TweenInfo.new(0.3),{BackgroundTransparency = 1}):Play()
        end
        local InPage = {}

        function InPage.Section(Text)
            local InSection = {}

            local Column = PageList
            if ElementsList.AbsoluteContentSize.Y > ElementsList2.AbsoluteContentSize.Y then
                Column = PageList2
            end

            local Section = CreateModule.Instance("Frame",{
                Parent = Column;
                Name = Text;
                BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15);
                BorderSizePixel = 0;
                BorderColor3 = Brighter(Color3.fromRGB(32,32,37),1.5);
                Position = UDim2.new(0,0,0,0);
                Size = UDim2.new(0.95,0,0,30);
                AutomaticSize = Enum.AutomaticSize.Y;
            })

            local Corner = CreateModule.Instance("UICorner",{
                Parent = Section;
                Name = "Corner";
                CornerRadius = UDim.new(0,5);
            })

            local Stroke = CreateModule.Instance("UIStroke",{
                Parent = Section;
                Name = "Stroke";
                Thickness = 1;
                Color = Color3.fromRGB(40,40,40);
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
            })

            local SectionLabel = CreateModule.Instance("TextLabel",{
                Parent = Section;
                Font = Enum.Font[Library["Theme"]["Font"]];
                Text = Text;
                TextSize = 16;
                TextColor3 = Library["Theme"]["FontColor"];
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = UDim2.new(0,5,0,1);
                Size = UDim2.new(1,0,0,20);
            })

            
            local SectionElements = CreateModule.Instance("Frame",{
                Parent = Section;
                Name = Text;
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = UDim2.new(0,0,0,0);
                Size = UDim2.new(1,0,1,0);
            })

            local SectionList = CreateModule.Instance("UIListLayout",{
                Parent = SectionElements;
                Padding = UDim.new(0,5);
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            local ign = CreateModule.Instance("Frame",{
                Parent = SectionElements;
                Name = 'ign';
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = UDim2.new(0,0,0,0);
                Size = UDim2.new(0,0,0,20);
                LayoutOrder = -999;
            })

            local ign2 = CreateModule.Instance("Frame",{
                Parent = SectionElements;
                Name = 'ign';
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = UDim2.new(0,0,0,0);
                Size = UDim2.new(0,0,0,0);
                LayoutOrder = 999;
            })

            function InSection.Button(Text,func)
                local Button = CreateModule.Instance("TextButton",{
                    Parent = SectionElements;
                    Name = Text;
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15);
                    BorderSizePixel = 1;
                    BorderColor3 = Color3.fromRGB(40,40,40);
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(0.95,0,0,20);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    Text = Text;
                    TextSize = 16;
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    AutoButtonColor = false;
                })


                local Corner = CreateModule.Instance("UICorner",{
                    Parent = Button;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                local Stroke = CreateModule.Instance("UIStroke",{
                    Parent = Button;
                    Name = "Stroke";
                    Thickness = 1;
                    Color = Color3.fromRGB(40,40,40);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                })

                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button,TweenInfo.new(0.3),{TextColor3 = Library["Theme"]["FontColor"]}):Play()
                    TweenService:Create(Button,TweenInfo.new(0.3),{BackgroundColor3 = Color3.fromRGB(32,32,37)}):Play()
                end)
        
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],1.5)}):Play()
                    TweenService:Create(Button,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                end)
                Button.MouseButton1Click:Connect(function()
                    spawn(function() func() end)
                end)
                AddToReg(Button)
                return Button;
            end
            function InSection.KeyBind(Text,func,defkey)
                local Keybind = CreateModule.Instance("TextLabel",{
                    Parent = SectionElements;
                    Name = Text or "Keybind";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(0.95,0,0,25);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    Text = "";
                    TextSize = 16;
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    TextXAlignment = Enum.TextXAlignment.Left;
                })

                local Label = CreateModule.Instance("TextLabel",{
                    Parent = Keybind;
                    Name = "Label";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(60,60,60);
                    Position = UDim2.new(0,60,0,0);
                    Size = UDim2.new(1,-50,1,0);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    Text = Text;
                    TextSize = 16;
                    TextXAlignment = Enum.TextXAlignment.Left;
                })

                local Keybinder = CreateModule.Instance("TextButton",{
                    Parent = Keybind;
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15);
                    BorderSizePixel = 0;
                    AnchorPoint = Vector2.new(0,0.5);
                    Position = UDim2.new(0,0,0.5,0);
                    Size = UDim2.new(0,50,0,20);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    Text = defkey or "...";
                    TextSize = 16;
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    TextXAlignment = Enum.TextXAlignment.Center;
                    AutoButtonColor = false;
                })

                local Corner = CreateModule.Instance("UICorner",{
                    Parent = Keybinder;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                local Stroke = CreateModule.Instance("UIStroke",{
                    Parent = Keybinder;
                    Name = "Stroke";
                    Thickness = 1;
                    Color = Color3.fromRGB(40,40,40);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                })

                local Picked,Picking = false

                local Key = defkey or nil
                InputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard and Picking and input.KeyCode ~= Enum.KeyCode[_G.Theme["HideKey"]] then
                        Key = tostring(input.KeyCode):gsub("Enum.KeyCode.","")
                        Picked = true
                    end
                end)

                Keybinder.MouseButton1Click:Connect(function()
                    Picking = true
                    Keybinder.Text = "..."
                    spawn(function()
                        repeat wait() until Picked
                        Keybinder.Text = Key
                        spawn(function() func(Key) end)
                        Picking = false
                        Picked = false
                    end)
                end)
                AddToReg(Keybind)
            end
            function InSection.Checkbox(Text,func,defbool)
                local Checkbox = CreateModule.Instance("TextButton",{
                    Parent = SectionElements;
                    Name = Text;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(60,60,60);
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(0.95,0,0,20);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    Text = "";
                    TextSize = 16;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    AutoButtonColor = false;
                })

                local Corner1 = CreateModule.Instance("UICorner",{
                    Parent = Checkbox;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                local Stroke1 = CreateModule.Instance("UIStroke",{
                    Parent = Checkbox;
                    Name = "Stroke";
                    Thickness = 1;
                    Color = Color3.fromRGB(40,40,40);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                })

                local Label = CreateModule.Instance("TextLabel",{
                    Parent = Checkbox;
                    Name = "Label";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(60,60,60);
                    Position = UDim2.new(0,27,0,0);
                    Size = UDim2.new(1,-25,1,0);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    Text = Text;
                    TextSize = 16;
                    TextXAlignment = Enum.TextXAlignment.Left;
                })

                local IsActive = CreateModule.Instance("BoolValue",{
                    Parent = Checkbox;
                    Name = "IsActive";
                })

                IsActive.Value = defbool or false

                Label.TextColor3 = (IsActive.Value and Library["Theme"]["FontColor"] or not IsActive.Value and Darker(Library["Theme"]["FontColor"],1.5))

                local Checked = CreateModule.Instance("Frame",{
                    Parent = Checkbox;
                    Name = 'Cube';
                    BackgroundTransparency = 0;
                    BackgroundColor3 = (IsActive.Value and Library["Theme"]["AccentColor"] or not IsActive.Value and Darker(Color3.fromRGB(32,32,37),1.15));
                    BorderSizePixel = 0;
                    AnchorPoint = Vector2.new(0,0.5);
                    Position = UDim2.new(0,5,0.5,0);
                    Size = UDim2.new(0,15,0,15);
                })

                local Corner = CreateModule.Instance("UICorner",{
                    Parent = Checked;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                local Stroke = CreateModule.Instance("UIStroke",{
                    Parent = Checked;
                    Name = "Stroke";
                    Thickness = 1;
                    Color = Color3.fromRGB(40,40,40);
                })

                IsActive.Changed:Connect(function()
                    if IsActive.Value then
                        TweenService:Create(Label,TweenInfo.new(0.3),{TextColor3 = Library["Theme"]["FontColor"]}):Play()
                        TweenService:Create(Checked,TweenInfo.new(0.3),{BackgroundColor3 = Library["Theme"]["AccentColor"]}):Play()
                        spawn(function() func(IsActive.Value) end)
                    else
                        TweenService:Create(Checked,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                        TweenService:Create(Label,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],1.5)}):Play()
                        spawn(function() func(IsActive.Value) end)
                    end
                end)

                Checkbox.MouseButton1Click:Connect(function()
                    IsActive.Value = not IsActive.Value
                end)
                AddToReg(Checkbox)
                return Checkbox;
            end
            function InSection.Slider(Text,min,max,func,precise,defvalue)
                local Slider = CreateModule.Instance("TextLabel",{
                    Parent = SectionElements;
                    Name = Text;
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(60,60,60);
                    Position = UDim2.new(0,22,0,0);
                    Size = UDim2.new(0.95,0,0,40);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    Text = Text;
                    TextSize = 16;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    TextYAlignment = Enum.TextYAlignment.Top;
                })

                local Bar = CreateModule.Instance("Frame",{
                    Parent = Slider;
                    Name = 'Bar';
                    BackgroundTransparency = 0;
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15);
                    BorderSizePixel = 0;
                    AnchorPoint = Vector2.new(0,0.5);
                    Position = UDim2.new(0,0,0.75,0);
                    Size = UDim2.new(1,0,0,20);
                    ClipsDescendants = true;
                })

                local ValueLabel = CreateModule.Instance("TextLabel",{
                    Parent = Bar;
                    Name = "Label";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(60,60,60);
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(1,0,1,0);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    Text = tostring(defvalue) .. "/".. max  or tostring(min) .. "/".. max ;
                    TextSize = 16;
                    TextXAlignment = Enum.TextXAlignment.Center;
                    ZIndex = 2;
                })

                local Progress = CreateModule.Instance("Frame",{
                    Parent = Bar;
                    Name = 'Progress';
                    BackgroundTransparency = 0;
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.05);
                    BorderSizePixel = 0;
                    AnchorPoint = Vector2.new(0,0.5);
                    Position = UDim2.new(0,0,0.5,0);
                    Size = UDim2.new(0,0,1,0);
                })

                local Corner = CreateModule.Instance("UICorner",{
                    Parent = Bar;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                local Stroke = CreateModule.Instance("UIStroke",{
                    Parent = Bar;
                    Name = "Stroke";
                    Thickness = 1;
                    Color = Color3.fromRGB(40,40,40);
                })

                local Corner2 = CreateModule.Instance("UICorner",{
                    Parent = Progress;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                

                local Mouse = game.Players.LocalPlayer:GetMouse()

				local function UpdateSlider(val)
					local percent = (val - min) / (max - min)

					percent = math.clamp(percent, 0, 1)

					Progress:TweenSize(UDim2.new(percent, 0, 1, 0),"Out","Sine",1,true)
				end

				UpdateSlider(defvalue)

				local IsSliding,Dragging = false
				local RealValue = defvalue
				local value
				local function move(Pressed)
					IsSliding = true;
					local pos = UDim2.new(math.clamp((Pressed.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1), 0, 1, 0)
					local size = UDim2.new(math.clamp((Pressed.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1), 0, 1, 0)
					Progress:TweenSize(size, "Out", "Quart", 0.2,true);
					RealValue = (((pos.X.Scale * max) / max) * (max - min) + min)
					value = (precise and string.format("%.1f", tostring(RealValue))) or (math.floor(RealValue))
					ValueLabel.Text = tostring(value) .. "/".. max 
					func(value)
				end

				Bar.InputBegan:Connect(function(Pressed)
					if Pressed.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
						IsSliding = false
                        move(Pressed)
                        TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Library["Theme"]["AccentColor"],1.2)}):Play()
					end
				end)

				Bar.InputEnded:Connect(function(Pressed)
					if Pressed.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = false
						IsSliding = false
                        TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Library["Theme"]["AccentColor"],1.7)}):Play()
                        move(Pressed)
					end
				end)

				game:GetService("UserInputService").InputChanged:Connect(function(Pressed)
					if Dragging and Pressed.UserInputType == Enum.UserInputType.MouseMovement then
                        move(Pressed)
					end
				end)

				Bar.MouseEnter:Connect(function()
					TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Library["Theme"]["AccentColor"],1.7)}):Play()
				end)

				Bar.MouseLeave:Connect(function()
					if not Dragging then
						TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.05)}):Play()
					end
                    if Dragging then
                        spawn(function()
                            repeat wait() until not Dragging
                            TweenService:Create(Progress,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.05)}):Play()
                        end)
                    end
				end)
                AddToReg(Slider)
                return Slider;
            end
            function InSection.Dropdown(Text,Selectables,ind,func)
                local Dropdown = CreateModule.Instance("Frame",{
                    Parent = SectionElements;
                    Name = Text;
                    BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15);
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(40,40,40);
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(0.95,0,0,20);
                    ClipsDescendants = true;
                })
                local DropdownButton = CreateModule.Instance("TextButton",{
                    Parent = Dropdown;
                    Name = "DropdownButton";
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    BorderColor3 = Color3.fromRGB(40,40,40);
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(1,0,0,20);
                    Font = Enum.Font[Library["Theme"]["Font"]];
                    Text = "  " .. Text;
                    TextSize = 16;
                    TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Enum.TextYAlignment.Center;
                    AutoButtonColor = false;
                })

                local DropdownImage = CreateModule.Instance("ImageLabel",{
                    Parent = DropdownButton;
                    AnchorPoint = Vector2.new(0, 0.5);
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.9, 0, 0.5, 0);
                    Size = UDim2.new(0, 20, 0, 20);
                    Image = "rbxassetid://3926305904";
                    ImageColor3 = Color3.fromRGB(136, 136, 136);
                    ImageRectOffset = Vector2.new(44, 404);
                    ImageRectSize = Vector2.new(36, 36);
                    Rotation = 0;
                })


                local List = CreateModule.Instance("ScrollingFrame",{
                    Parent = Dropdown;
                    Name = 'List';
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0,0,0,20);
                    Size = UDim2.new(1,0,0,0);
                    CanvasSize = UDim2.new(0,0,0,0);
                    AutomaticCanvasSize = Enum.AutomaticSize.Y;
                    ScrollBarThickness = 0;
                    ScrollBarImageTransparency = 1;
                })

                
                local DropdownList = CreateModule.Instance("UIListLayout",{
                    Parent = List;
                    Padding = UDim.new(0,5);
                    HorizontalAlignment = Enum.HorizontalAlignment.Center;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                })

                CreateModule.Instance("Frame",{
                    Parent = List;
                    Name = 'ign';
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0,0,0,0);
                    Size = UDim2.new(0,0,0,0);
                    LayoutOrder = -99999;
                })

                local Corner = CreateModule.Instance("UICorner",{
                    Parent = Dropdown;
                    Name = "Corner";
                    CornerRadius = UDim.new(0,5);
                })

                local Stroke = CreateModule.Instance("UIStroke",{
                    Parent = Dropdown;
                    Name = "Stroke";
                    Thickness = 1;
                    Color = Color3.fromRGB(40,40,40);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                })

                local IsOpened = false

                DropdownButton.MouseButton1Click:Connect(function()
                    IsOpened = not IsOpened
                    if IsOpened then
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,120),"Out","Quart",0.3,true)
                        List:TweenSize(UDim2.new(1,0,0,100),"Out","Quart",0.3,true)
                        TweenService:Create(DropdownImage,TweenInfo.new(0.3),{Rotation = 180}):Play()
                    else
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,20),"Out","Quart",0.3,true)
                        List:TweenSize(UDim2.new(1,0,0,0),"Out","Quart",0.3,true)
                        TweenService:Create(DropdownImage,TweenInfo.new(0.3),{Rotation = 0}):Play()
                    end
                end)

                local function NewSelectable(string,value)
                    local Selectable = CreateModule.Instance("TextButton",{
                        Parent = List;
                        Name = string;
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        BorderColor3 = Color3.fromRGB(40,40,40);
                        Position = UDim2.new(0,0,0,0);
                        Size = UDim2.new(0.95,0,0,20);
                        Font = Enum.Font[Library["Theme"]["Font"]];
                        Text = "  " .. string;
                        TextSize = 16;
                        TextColor3 = Darker(Library["Theme"]["FontColor"],1.5);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextYAlignment = Enum.TextYAlignment.Center;
                        AutoButtonColor = false;
                    })

                    local Corner = CreateModule.Instance("UICorner",{
                        Parent = Selectable;
                        Name = "Corner";
                        CornerRadius = UDim.new(0,5);
                    })
    
                    local Stroke = CreateModule.Instance("UIStroke",{
                        Parent = Selectable;
                        Name = "Stroke";
                        Thickness = 1;
                        Color = Color3.fromRGB(40,40,40);
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
                    })

                    Selectable.MouseEnter:Connect(function()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{TextColor3 = Library["Theme"]["FontColor"]}):Play()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{BackgroundColor3 = Color3.fromRGB(32,32,37)}):Play()
                    end)
            
                    Selectable.MouseLeave:Connect(function()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{TextColor3 = Darker(Library["Theme"]["FontColor"],1.5)}):Play()
                        TweenService:Create(Selectable,TweenInfo.new(0.3),{BackgroundColor3 = Darker(Color3.fromRGB(32,32,37),1.15)}):Play()
                    end)

                    Selectable.MouseButton1Click:Connect(function()
                        spawn(function() func(string,value) end)
                        DropdownButton.Text = "  " .. string
                        Dropdown:TweenSize(UDim2.new(0.95,0,0,20),"Out","Quart",0.3,true)
                        List:TweenSize(UDim2.new(1,0,0,0),"Out","Quart",0.3,true)
                        TweenService:Create(DropdownImage,TweenInfo.new(0.3),{Rotation = 0}):Play()
                        IsOpened = false
                    end)
                end

                for string,value in next,Selectables do
                    if ind == 1 then
                        NewSelectable(tostring(string),tostring(value))
                    elseif ind == 2 then
                        NewSelectable(tostring(value),tostring(string))
                    end
                end
                local InDropdown = {}
                function InDropdown.Refresh(selec)
                    for i,v in next,List:GetChildren() do
                        if v.ClassName == "TextButton" then
                            v:Destroy()
                        end
                    end
                    wait()
                    for string,value in next,selec do
                        if ind == 1 then
                            NewSelectable(tostring(string),tostring(value))
                        elseif ind == 2 then
                            NewSelectable(tostring(value),tostring(string))
                        end
                    end
                end
                AddToReg(Dropdown)
                return InDropdown;
            end

            return InSection;
        end
        return InPage;
	end
	return InMain;
end

return Library;
