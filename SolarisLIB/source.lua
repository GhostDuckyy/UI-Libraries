-- This User Interface Library is brought to you by Solaris Software.
local Solaris = Instance.new("ScreenGui")
Solaris.Name = "dosage's solaris gui"
Solaris.Parent = game.CoreGui
Solaris.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "notiHolder"
NotificationHolder.Parent = game.CoreGui
NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local http = game:GetService("HttpService")

local WhitelistedMouse = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3}
local BlacklistedKeys = {Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Up,Enum.KeyCode.Left,Enum.KeyCode.Down,Enum.KeyCode.Right,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.Escape}

local function CheckKey(tab, key)
	for i, v in next, tab do
		if v == key then
			return true
		end
	end
end



local NotificationFrame = game:GetObjects("rbxassetid://6924028278")[1]
NotificationFrame.ZIndex = 4
NotificationFrame.Parent = NotificationHolder
script = NotificationFrame.NotifScript
local Notify = loadstring(NotificationFrame.NotifScript.Source)()
script = oldScript

local SolarisLib = {
    Themes = {
        Default = {
            MainFrame = Color3.fromRGB(25, 25, 25),
            TopBar = Color3.fromRGB(30, 30, 30),
            TextColor =  Color3.fromRGB(255,255,255),
            Menu = Color3.fromRGB(37, 37, 37),
            TabToggled = Color3.fromRGB(43,43,43),
            Button = Color3.fromRGB(30,30,30),
            ButtonHold = Color3.fromRGB(31,31,31),
            Toggle = Color3.fromRGB(30,30,30),
            ToggleFrame = Color3.fromRGB(55,55,55),
            ToggleToggled = Color3.fromRGB(22, 168, 76),
            Slider = Color3.fromRGB(30,30,30),
            SliderBar = Color3.fromRGB(25, 25, 25),
            SliderInc = Color3.fromRGB(60, 60, 60),
            Dropdown = Color3.fromRGB(30,30,30),
            DropdownItem = Color3.fromRGB(30,30,30),
            Textbox = Color3.fromRGB(30,30,30),
            TextboxFrame = Color3.fromRGB(25, 25, 25),
            Colorpicker = Color3.fromRGB(30,30,30),
            Label = Color3.fromRGB(30,30,30),
            Bind = Color3.fromRGB(30,30,30)
        },
        Discord = {
            MainFrame = Color3.fromRGB(54,57,63),
            TopBar = Color3.fromRGB(47,49,54),
            TextColor =  Color3.fromRGB(255,255,255),
            Menu = Color3.fromRGB(47,49,54),
            TabToggled = Color3.fromRGB(54,57,63),
            Button = Color3.fromRGB(88,101,242),
            ButtonHold = Color3.fromRGB(71,82,196),
            Toggle = Color3.fromRGB(47,49,54),
            ToggleFrame = Color3.fromRGB(67,69,74),
            ToggleToggled = Color3.fromRGB(22, 168, 76),
            Slider = Color3.fromRGB(47,49,54),
            SliderBar = Color3.fromRGB(42,44,49),
            SliderInc = Color3.fromRGB(62,64,69),
            Dropdown = Color3.fromRGB(47,49,54),
            DropdownItem = Color3.fromRGB(47,49,54),
            Textbox = Color3.fromRGB(47,49,54),
            TextboxFrame = Color3.fromRGB(42,44,49),
            Colorpicker = Color3.fromRGB(47,49,54),
            Label = Color3.fromRGB(47,49,54),
            Bind = Color3.fromRGB(47,49,54)
        },
        Blue = {
            MainFrame = Color3.fromRGB(35, 35, 50),
            TopBar = Color3.fromRGB(40, 40, 55),
            TextColor =  Color3.fromRGB(255,255,255),
            Menu = Color3.fromRGB(47, 47, 62),
            TabToggled = Color3.fromRGB(53,53,68),
            Button = Color3.fromRGB(40,40,55),
            ButtonHold = Color3.fromRGB(41,41,56),
            Toggle = Color3.fromRGB(40,40,55),
            ToggleFrame = Color3.fromRGB(65,65,80),
            ToggleToggled = Color3.fromRGB(64, 64, 120),
            Slider = Color3.fromRGB(40,40,55),
            SliderBar = Color3.fromRGB(35, 35, 50),
            SliderInc = Color3.fromRGB(70, 70, 85),
            Dropdown = Color3.fromRGB(40,40,55),
            DropdownItem = Color3.fromRGB(40,40,55),
            Textbox = Color3.fromRGB(40,40,55),
            TextboxFrame = Color3.fromRGB(35, 35, 50),
            Colorpicker = Color3.fromRGB(40,40,55),
            Label = Color3.fromRGB(40,40,55),
            Bind = Color3.fromRGB(40,40,55)
        },
        Red = {
            MainFrame = Color3.fromRGB(50, 35, 35),
            TopBar = Color3.fromRGB(55, 40, 40),
            TextColor =  Color3.fromRGB(255,255,255),
            Menu = Color3.fromRGB(62, 47, 47),
            TabToggled = Color3.fromRGB(68,53,53),
            Button = Color3.fromRGB(55,40,40),
            ButtonHold = Color3.fromRGB(56,41,41),
            Toggle = Color3.fromRGB(55,40,40),
            ToggleFrame = Color3.fromRGB(80,65,65),
            ToggleToggled = Color3.fromRGB(120, 64, 64),
            Slider = Color3.fromRGB(55,40,40),
            SliderBar = Color3.fromRGB(50, 35, 35),
            SliderInc = Color3.fromRGB(85, 70, 70),
            Dropdown = Color3.fromRGB(55,40,40),
            DropdownItem = Color3.fromRGB(55,40,40),
            Textbox = Color3.fromRGB(55,40,40),
            TextboxFrame = Color3.fromRGB(50, 35, 35),
            Colorpicker = Color3.fromRGB(55,40,40),
            Label = Color3.fromRGB(55,40,40),
            Bind = Color3.fromRGB(55,40,40)
        },
        Green = {
            MainFrame = Color3.fromRGB(35, 50, 35),
            TopBar = Color3.fromRGB(40, 55, 40),
            TextColor =  Color3.fromRGB(255,255,255),
            Menu = Color3.fromRGB(47, 62, 47),
            TabToggled = Color3.fromRGB(53,68,53),
            Button = Color3.fromRGB(40,55,40),
            ButtonHold = Color3.fromRGB(41,56,41),
            Toggle = Color3.fromRGB(40,55,40),
            ToggleFrame = Color3.fromRGB(65,80,65),
            ToggleToggled = Color3.fromRGB(64, 120, 64),
            Slider = Color3.fromRGB(40,55,40),
            SliderBar = Color3.fromRGB(35, 50, 35),
            SliderInc = Color3.fromRGB(70, 85, 70),
            Dropdown = Color3.fromRGB(40,55,40),
            DropdownItem = Color3.fromRGB(40,55,40),
            Textbox = Color3.fromRGB(40,55,40),
            TextboxFrame = Color3.fromRGB(35, 50, 35),
            Colorpicker = Color3.fromRGB(40,55,40),
            Label = Color3.fromRGB(40,55,40),
            Bind = Color3.fromRGB(40,55,40)
        }
    },
    Settings = {
        Theme = "Default",
        ShowFriendsOnLaunch = true,
        ShowMusicOnLaunch = false,
        CloseBind = "RightControl"
    },
    Flags = {},
    CurrentTab
}



local MainUI = game:GetObjects("rbxassetid://7835727566")[1]
print("SolarisLib Loaded!")
local function MakeDraggable(topbarobject, object) 
    pcall(function()
		local dragging, dragInput, mousePos, framePos = false
		topbarobject.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				mousePos = input.Position
				framePos = object.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		topbarobject.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)
		UserInputService.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - mousePos
				object.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
			end
		end)
	end)
end


function Ripple(Object)
	spawn(function()
		local Circle = Instance.new("ImageLabel")
		Circle.Parent = Object
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1.000
		Circle.ZIndex = 10
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(210,210,210)
		Circle.ImageTransparency = 0.8
		Circle.Position = UDim2.new(0, Mouse.X - Circle.AbsolutePosition.X, 0, Mouse.Y - Circle.AbsolutePosition.Y)
		local Size = Object.AbsoluteSize.X
		TweenService:Create(Circle, TweenInfo.new(0.5), {Position = UDim2.fromScale(math.clamp(Mouse.X - Object.AbsolutePosition.X, 0, Object.AbsoluteSize.X)/Object.AbsoluteSize.X,Object,math.clamp(Mouse.Y - Object.AbsolutePosition.Y, 0, Object.AbsoluteSize.Y)/Object.AbsoluteSize.Y) - UDim2.fromOffset(Size/2,Size/2), ImageTransparency = 1, Size = UDim2.fromOffset(Size,Size)}):Play()
		spawn(function()
			wait(0.5)
			Circle:Destroy()
		end)
	end)
end

function SolarisLib:Notification(title, desc)
    Notify:New(title,desc)
end    

function SolarisLib:New(Config)
    if not isfolder(Config.FolderToSave) then 
        makefolder(Config.FolderToSave)
    end
    
    if not isfolder(Config.FolderToSave .. "/configs") then 
        makefolder(Config.FolderToSave .. "/configs")
    end
    
    if not isfile(Config.FolderToSave .. "/settings.txt") then
        local content = {}
        for i,v in pairs(SolarisLib.Settings) do
            content[i] = v
        end
        writefile(Config.FolderToSave .. "/settings.txt", tostring(http:JSONEncode(content)))
    end    
    SolarisLib.Settings = http:JSONDecode(readfile(Config.FolderToSave .. "/settings.txt"))

    local closebindbinding = false
    local fs = false
    local tabcount = 0
    local uitoggled = true
    local tabmenutoggled = false
    local TabPreset = game:GetObjects("rbxassetid://6958615840")[1]
    local SectionPreset = game:GetObjects("rbxassetid://7121846230")[1]
    local ContainerPreset = game:GetObjects("rbxassetid://7121886326")[1]
    local MFrame = MainUI.MainFrame
    MainUI.Parent = Solaris
    MFrame.TopBar.TopFrameTitle.Text = Config.Name
    MakeDraggable(MFrame.TopBar, MainUI) 
    local oldScript = script

    local MenuBtnPreset = game:GetObjects("rbxassetid://7037141226")[1]
    local MusicBtn = MenuBtnPreset:Clone()
    MusicBtn.Parent = MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame
    MusicBtn.Position = UDim2.new(0,0,0,5)
    MusicBtn.Text = "Music"
    MusicBtn.MouseEnter:Connect(function() TweenService:Create(MusicBtn,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0}):Play() end)
    MusicBtn.MouseLeave:Connect(function() TweenService:Create(MusicBtn,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play() end)
    local SettingsBtn = MenuBtnPreset:Clone()
    SettingsBtn.Parent = MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame
    SettingsBtn.Position = UDim2.new(0,0,0,25)
    SettingsBtn.Text = "Settings"
    SettingsBtn.MouseEnter:Connect(function() TweenService:Create(SettingsBtn,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0}):Play() end)
    SettingsBtn.MouseLeave:Connect(function() TweenService:Create(SettingsBtn,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play() end)


    function MusicConstructor()
        local abuttonhold = false
        local playing = false
        local MarketplaceService = game:GetService("MarketplaceService")
        local MusicFrame, MusicPreset = game:GetObjects("rbxassetid://7296373622")[1], game:GetObjects("rbxassetid://7296615234")[1]
        MusicFrame.Parent = Solaris
        MusicFrame.ZIndex = 5
        MusicFrame.Visible = SolarisLib.Settings.ShowMusicOnLaunch
        MusicFrame.Frame.Title.Text = "Not Playing"
        MusicFrame.Frame.Progress.ProgressFrame.Size = UDim2.new(0,0,1,0)
        MusicFrame.Frame.AddBtn.AutoButtonColor = false

        MakeDraggable(MusicFrame.Frame.TopBar,MusicFrame)
        MusicFrame.Frame.TopBar.CloseBtn.MouseButton1Click:Connect(function()
            MusicFrame.Visible = false
        end)
        MusicFrame.Frame.TopBar.CloseBtn.MouseEnter:Connect(function() TweenService:Create(MusicFrame.Frame.TopBar.CloseBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}):Play() end)
        MusicFrame.Frame.TopBar.CloseBtn.MouseLeave:Connect(function() TweenService:Create(MusicFrame.Frame.TopBar.CloseBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0.4}):Play() end)
        MusicBtn.MouseButton1Click:Connect(function()
            MusicFrame.Visible = not MusicFrame.Visible
            MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame.Visible = false 
        end)

        local Sound = Instance.new("Sound")
        Sound.Name = "Sound"
        Sound.Parent = MusicFrame
        Sound.Volume = 3
        Sound:Stop()

        local Sounds = {}
        if not isfile(Config.FolderToSave .. "/music.txt") then writefile(Config.FolderToSave .. "/music.txt", tostring(http:JSONEncode({}))) end
        Sounds = http:JSONDecode(readfile(Config.FolderToSave .. "/music.txt"))

        function Save()
            local content = {}
            for i,v in pairs(Sounds) do
                content[i] = v
            end
            writefile(Config.FolderToSave .. "/music.txt", tostring(http:JSONEncode(content)))
        end    

        local function PlaySong(id, title)
            Sound:Stop()
            playing = true
            Sound.SoundId = "rbxassetid://" .. id
            Sound:Resume()
            MusicFrame.Frame.Play.Image = "http://www.roblox.com/asset/?id=6026663719"
            MusicFrame.Frame.Title.Text = title
        end    

        local function RefreshList(list)
            for i,v in next, MusicFrame.Frame.MusicList.Scroll:GetChildren() do
                if v.Name == "Btn" then
                    v:Destroy()
                end    
            end
            for i,v in next, list do
                local success, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, v)
                if success and info.AssetTypeId == 3 then
                    local Btn = MusicPreset:Clone()
                    Btn.Parent = MusicFrame.Frame.MusicList.Scroll
                    Btn.Title.Text = info.Name

                    Btn.MouseButton1Click:Connect(function()
                        PlaySong(v, info.Name)
                    end)

                    Btn.Delete.MouseButton1Click:Connect(function()
                        for g,c in next, Sounds do
                            if c == v then
                                table.remove(Sounds, g)
                            end    
                        end    
                        Save()
                        Btn:Destroy()   
                    end)
                end
            end    
        end 
        
        MusicFrame.Frame.Play.MouseButton1Click:Connect(function()
            playing = not playing
            if playing then Sound:Pause() else Sound:Resume() end
            MusicFrame.Frame.Play.Image = playing and "http://www.roblox.com/asset/?id=6026663699" or "http://www.roblox.com/asset/?id=6026663719"
        end)

        MusicFrame.Frame.AddBtn.MouseButton1Click:Connect(function()
            local id = MusicFrame.Frame.AddSong.Text
            if not table.find(Sounds, id) then
                table.insert(Sounds, id)
                Save()
                RefreshList(Sounds)
            end    
        end)

        MusicFrame.Frame.AddBtn.MouseEnter:Connect(function()
            abuttonhold = true
        end)

        MusicFrame.Frame.AddBtn.MouseLeave:Connect(function()
            abuttonhold = false
        end)

        RefreshList(Sounds)

        game:GetService("RunService").RenderStepped:Connect(function()
            local time = math.floor(Sound.TimePosition)
            local timesecs = time % 60
            local timemins = math.floor(time / 60)
            if string.len(timesecs) < 2 then timesecs = "0" .. timesecs end
            if string.len(timemins) < 2 then timemins = "0" .. timemins end
            local timemax = math.floor(Sound.TimeLength)
            local timemaxsecs = timemax % 60
            local timemaxmins = math.floor(timemax / 60)
            if string.len(timemaxsecs) < 2 then timemaxsecs = "0" .. timemaxsecs end
            if string.len(timemaxmins) < 2 then timemaxmins = "0" .. timemaxmins end
            MusicFrame.Frame.Timer1.Text = timemins .. ":" .. timesecs
            MusicFrame.Frame.Timer2.Text = timemaxmins .. ":" .. timemaxsecs
            MusicFrame.Frame.Progress.ProgressFrame.Size = UDim2.new(Sound.TimePosition / Sound.TimeLength,0,1,0)
        end)

        
        spawn(function()
            while wait() do
                MusicFrame.Frame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].MainFrame
                MusicFrame.Frame.TopBar.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
                MusicFrame.Frame.TopBar.CloseBtn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                MusicFrame.Frame.MusicList.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
                MusicFrame.Frame.AddBtn.BackgroundColor3 = abuttonhold and SolarisLib.Themes[SolarisLib.Settings.Theme].ButtonHold or SolarisLib.Themes[SolarisLib.Settings.Theme].Button
                MusicFrame.Frame.Progress.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Slider
                MusicFrame.Frame.Progress.ProgressFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].SliderInc
                MusicFrame.Frame.AddSong.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Textbox
            end
        end)
    end  

    function SettingsConstructor()
        local Settings, SettingsFrame, TabPreset, ContainerPreset, TogglePreset, BindPreset, DropdownPreset, OptionPreset = {}, game:GetObjects("rbxassetid://7167491516")[1], game:GetObjects("rbxassetid://7177524915")[1], game:GetObjects("rbxassetid://7203599409")[1], game:GetObjects("rbxassetid://7208643984")[1], game:GetObjects("rbxassetid://7219277948")[1], game:GetObjects("rbxassetid://7435055269")[1], game:GetObjects("rbxassetid://7435032496")[1]
        local fs = true
        local SFrame = SettingsFrame.Main
        SettingsFrame.Parent = MFrame
        SFrame.TopBar.CloseBtn.MouseEnter:Connect(function() TweenService:Create(SFrame.TopBar.CloseBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}):Play() end)
        SFrame.TopBar.CloseBtn.MouseLeave:Connect(function() TweenService:Create(SFrame.TopBar.CloseBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0.4}):Play() end)
        SettingsBtn.MouseButton1Click:Connect(function()
            SettingsFrame.Visible = not SettingsFrame.Visible
            MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame.Visible = false 
        end)
        SFrame.TopBar.CloseBtn.MouseButton1Click:Connect(function()
            SettingsFrame.Visible = false
        end)

        function SaveSettings()
            local content = {}
            for i,v in pairs(SolarisLib.Settings) do
                content[i] = v
            end
            writefile(Config.FolderToSave .. "/settings.txt", tostring(http:JSONEncode(content)))
        end    

        
        spawn(function()
            while wait() do
                SFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].MainFrame
                SFrame.TopBar.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
                SFrame.TopBar.CloseBtn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                SFrame.TopBar.TopFrameTitle.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                SFrame.TabHolder.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar

            end
        end)

        function Settings:Tab(text)
            local Tab = TabPreset:Clone()
            local Container = ContainerPreset:Clone()
            Tab.Parent = SFrame.TabHolder
            Tab.Text = text
            Tab.Size = UDim2.new(0,Tab.TextBounds.X,1,0)
            Container.Parent = SFrame.ContainerFolder
            Container.Visible = false

            if fs then
                Tab.TextTransparency = 0
                Container.Visible = true
                fs = false
            end    

            Tab.MouseButton1Click:Connect(function()
                for i,v in next, SFrame.TabHolder:GetChildren() do
                    if v.Name == "Tab" then
                        v.TextTransparency = 0.4
                    end    
                end      
                for i,v in next, SFrame.ContainerFolder:GetChildren() do
                    if v.Name == "Container" then
                        v.Visible = false
                    end    
                end      
                Tab.TextTransparency = 0      
                Container.Visible = true
            end)
            local TabHold = {}
            function TabHold:ToggleSetting(title, desc, def, path)
                local value = SolarisLib.Settings[path] or def
                local Toggle = TogglePreset:Clone()
                Toggle.Parent = Container
                Toggle.Title.Text = title
                Toggle.Desc.Text = desc

                local function Tween(val)
                    TweenService:Create(Toggle.ToggleFrame.ToggleToggled.ToggleIco,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency= val and 0 or 1}):Play()
                    TweenService:Create(Toggle.ToggleFrame.ToggleToggled.ToggleIco,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size= val and UDim2.new(1,-2,1,-2) or UDim2.new(1,-6,1,-6)}):Play()
                end    

                local function SetValue(val)
                    Tween(val)
                    SolarisLib.Settings[path] = val
                    value = val
                    SaveSettings()
                end    

                Tween(value)

                Toggle.MouseButton1Click:Connect(function()
                    SetValue(not value)     
                end)

                spawn(function()
                    while wait() do
                        Toggle.ToggleFrame.ToggleToggled.BackgroundColor3 = value and SolarisLib.Themes[SolarisLib.Settings.Theme].ToggleToggled or SolarisLib.Themes[SolarisLib.Settings.Theme].MainFrame
                        Toggle.ToggleFrame.BackgroundColor3 = value and SolarisLib.Themes[SolarisLib.Settings.Theme].ToggleToggled or SolarisLib.Themes[SolarisLib.Settings.Theme].ToggleFrame
                        Toggle.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)
            end
            function TabHold:BindSetting(title, desc, def, path)
                local value = SolarisLib.Settings[path] or def
                local Bind = BindPreset:Clone()
                Bind.Parent = Container
                Bind.Title.Text = title
                Bind.Desc.Text = desc

                function SetValue(val)
                    closebindbinding = false
                    value = val or value
                    value = value.Name or value
                    Bind.BText.Text = value
                    SolarisLib.Settings[path] = value
                    SaveSettings()
                end    
                SetValue(value)

                Bind.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if closebindbinding then return end
                        closebindbinding = true
                        Bind.BText.Text = "..."
                    end
                end)

                UserInputService.InputBegan:Connect(function(Input)
                    if UserInputService:GetFocusedTextBox() then return end
                    if closebindbinding then
                        local Key
                        pcall(function()
                            if not CheckKey(BlacklistedKeys, Input.KeyCode) then
                                Key = Input.KeyCode
                            end
                        end)
                        pcall(function()
                            if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then
                                Key = Input.UserInputType
                            end
                        end)
                        Key = Key or value
                        SetValue(Key)
                    end
                end)

                spawn(function()
                    while wait() do
                        Bind.Desc.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                        Bind.BText.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                        Bind.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)
            
            end    
            function TabHold:Dropdown(title, desc, list, def, path)
                local opened = false
                local value = SolarisLib.Settings[path] or def
                local Dropdown = DropdownPreset:Clone()
                Dropdown.Parent = Container
                Dropdown.Title.Text = title
                Dropdown.Desc.Text = desc
                Dropdown.Main.Current.Text = value

                function Toggle()
                    Dropdown.Main.Holder.Visible = opened
                    Dropdown.Main.Holder.Size = opened and UDim2.new(1,0,0,Dropdown.Main.Holder.UIListLayout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,0)
                    if opened then
                        if (Dropdown.Main.Holder.UIListLayout.AbsoluteContentSize.Y + Container.UIListLayout.AbsoluteContentSize.Y) > 190 then
                            Container.CanvasSize = UDim2.new(0,0,0,Dropdown.Main.Holder.UIListLayout.AbsoluteContentSize.Y + Container.UIListLayout.AbsoluteContentSize.Y)
                        end    
                    else
                        Container.CanvasSize = UDim2.new(0,0,0,Container.UIListLayout.AbsoluteContentSize.Y) 
                    end
                    TweenService:Create(Dropdown.Main.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = opened and 180 or 0}):Play()
                end   
                
                Dropdown.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        opened = not opened
                        Toggle()
                    end
                end)

                local function AddOptions(opts)
                    for _,option in pairs(opts) do
                        local Option = OptionPreset:Clone()
                        Option.Parent = Dropdown.Main.Holder
                        Option.Text = option

                        Option.MouseButton1Click:Connect(function()
                            value = option
                            SolarisLib.Settings[path] = value
                            Dropdown.Main.Current.Text = value
                            SaveSettings()
                        end)

                        spawn(function()
                            while wait() do
                               Option.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor       
                            end
                        end)
                    end   
                end    

                spawn(function()
                    while wait() do
                        Dropdown.Main.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
                        Dropdown.Main.Holder.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
                    end
                end)
                AddOptions(list)
            end
            return TabHold
        end   
        
        local general = Settings:Tab("General")
        general:ToggleSetting("Show Music On Launch", "Shows the music menu when you load Snow Hub", true, "ShowMusicOnLaunch")
        general:BindSetting("Close Bind", "Hides/Shows the main window when pressed.", Enum.KeyCode.RightControl, "CloseBind")
        
        local appearance = Settings:Tab("Appearance")
        appearance:Dropdown("Theme", "The look of the user interface", {"Default", "Discord", "Red", "Green", "Blue"}, "Default", "Theme")

    end 
    MusicConstructor()
    SettingsConstructor()

    local function OpenTabMenu()
        TweenService:Create(MFrame.TabMenu,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Position = UDim2.new(0,0,0,0)}):Play() 
    end   
    
    local function CloseTabMenu()
        TweenService:Create(MFrame.TabMenu,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Position = UDim2.new(-0.37, -8, 0, 0)}):Play() 
    end 

    MFrame.TopBar.TabListBtn.MouseButton1Click:Connect(function()
        OpenTabMenu()
    end)

    MFrame.TabMenu.Menu.Top.MenuCloseBtn.MouseButton1Click:Connect(function()
        CloseTabMenu()
    end)

    MFrame.TopBar.ButtonHolder.SearchBtn.MouseButton1Click:Connect(function()
        MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.Visible = not MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.Visible
        MFrame.TopBar.TopFrameTitle.Visible = not MFrame.TopBar.TopFrameTitle.Visible
    end)

    MFrame.TopBar.ButtonHolder.CloseBtn.MouseEnter:Connect(function() TweenService:Create(MFrame.TopBar.ButtonHolder.CloseBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}):Play() end)
    MFrame.TopBar.ButtonHolder.CloseBtn.MouseLeave:Connect(function() TweenService:Create(MFrame.TopBar.ButtonHolder.CloseBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0.4}):Play() end)
    MFrame.TopBar.ButtonHolder.SearchBtn.MouseEnter:Connect(function() TweenService:Create(MFrame.TopBar.ButtonHolder.SearchBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}):Play() end)
    MFrame.TopBar.ButtonHolder.SearchBtn.MouseLeave:Connect(function() TweenService:Create(MFrame.TopBar.ButtonHolder.SearchBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0.4}):Play() end)
    MFrame.TopBar.ButtonHolder.MenuBtn.MouseEnter:Connect(function() TweenService:Create(MFrame.TopBar.ButtonHolder.MenuBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}):Play() end)
    MFrame.TopBar.ButtonHolder.MenuBtn.MouseLeave:Connect(function() TweenService:Create(MFrame.TopBar.ButtonHolder.MenuBtn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0.4}):Play() end)
    MFrame.TopBar.TabListBtn.MouseEnter:Connect(function() TweenService:Create(MFrame.TopBar.TabListBtn,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0}):Play() end)
    MFrame.TopBar.TabListBtn.MouseLeave:Connect(function() TweenService:Create(MFrame.TopBar.TabListBtn,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency = 0.4}):Play() end)
    MFrame.TopBar.ButtonHolder.MenuBtn.MouseButton1Click:Connect(function() MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame.Visible = not MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame.Visible end)

    MFrame.TopBar.ButtonHolder.CloseBtn.MouseButton1Click:Connect(function()
        uitoggled = not uitoggled
        MainUI.Visible = uitoggled
    end)


    function SearchConstructor()
        function StitchElements()
            local elms = {}
            for i,v in next, SolarisLib.CurrentTab:GetDescendants() do
                if string.find(v.Name, "element") then
                    table.insert(elms, v)        
                end
            end   
            return elms
        end    

        MFrame.TopBar.ButtonHolder.SearchBtn.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
            for i,v in pairs(StitchElements()) do
                if string.len(MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.Text) >= 1 then
                    if string.find(string.sub(v.Name:lower(),0,-8), MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.Text:lower()) then
                        v.Visible = true
                    else
                        v.Visible = false
                    end 
                else
                    v.Visible = true                 
                end
            end    		
        end)
    end    

    SearchConstructor()
    

	UserInputService.InputBegan:Connect(function(Input)
		if (Input.KeyCode.Name == SolarisLib.Settings.CloseBind or Input.UserInputType.Name == SolarisLib.Settings.CloseBind) and not closebindbinding then
            uitoggled = not uitoggled
            MainUI.Visible = uitoggled
		end
	end)

    spawn(function()
        while wait() do
            MFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].MainFrame
            MFrame.TopBar.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
            MFrame.TopBar.ButtonHolder.CloseBtn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.ButtonHolder.MenuBtn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.ButtonHolder.SearchBtn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.TabListBtn.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.TopFrameTitle.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TabMenu.Menu.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Menu
            MFrame.TabMenu.Menu.Top.MenuCloseBtn.ImageLabel.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].MainFrame
            MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.ButtonHolder.SearchBtn.TextBox.PlaceholderColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
            MFrame.TopBar.ButtonHolder.MenuBtn.MenuFrame.Frame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TopBar
        end
    end)

    function SolarisLib:LoadCfg(cfg)
        local content = http:JSONDecode(cfg)
        table.foreach(content, function(a,b)
            if SolarisLib.Flags[a] then
                spawn(function() SolarisLib.Flags[a]:Set(b) end)
            else
                warn("cfg loader - could not find", a ,b )
            end
        end)
    end
    
    function SolarisLib:SaveCfg(name)
        local content = {}
        for i,v in pairs(SolarisLib.Flags) do
            content[i] = v.Value
        end
        writefile(Config.FolderToSave .. "/configs/" .. name .. ".txt", tostring(http:JSONEncode(content)))
    end
    

    local TabHolder = {}
    function TabHolder:Tab(text)
        local Tab = TabPreset:Clone()
        Tab.AutoButtonColor = false
        Tab.Parent = MFrame.TabMenu.Menu.Holder
        Tab.Text =  text
        Tab.TextSize = 14


        local Container =  ContainerPreset:Clone()
        Container.Parent = MFrame.ContainerFolder
        Container.Visible = false

        if fs == false then
            fs = true
            Container.Visible = true
            Tab.UIPadding.PaddingLeft = UDim.new(0,10)
            Tab.TextTransparency = 0
            Tab.BackgroundTransparency = 0  
            SolarisLib.CurrentTab = Container  
        end    

        spawn(function()
            while wait() do
                Tab.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                Tab.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TabToggled
                Container.CanvasSize = UDim2.new(0,0,0,Container.UIListLayout.AbsoluteContentSize.Y + 26)
            end
        end)


        
        Tab.MouseButton1Click:Connect(function()
            for i,v in next, MFrame.TabMenu.Menu.Holder:GetChildren() do
                if v:IsA("TextButton") then
                    TweenService:Create(v,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0.4}):Play() 
                    TweenService:Create(v,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 1}):Play() 
                    TweenService:Create(v.UIPadding,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{PaddingLeft = UDim.new(0,5)}):Play() 
                end    
                TweenService:Create(Tab,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{TextTransparency = 0}):Play() 
                TweenService:Create(Tab,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{BackgroundTransparency = 0}):Play() 
                TweenService:Create(Tab.UIPadding,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{PaddingLeft = UDim.new(0,10)}):Play() 
            end   
            for i,v in next, MFrame.ContainerFolder:GetChildren() do
                if v.Name == "Container" then
                    v.Visible = false
                end    
                Container.Visible = true
            end
            tabtoggledname = Tab.Name
            CloseTabMenu()
        end)


        local SectionHold = {}
        function SectionHold:Section(text)
            local Section = SectionPreset:Clone()
            Section.Parent = Container
            Section.SectionTitle.Text = text

            spawn(function()
                while wait() do
                    Section.SectionTitle.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    Section.Size = UDim2.new(0.9,0,0,Section.UIListLayout.AbsoluteContentSize.Y)
                end
            end)
            local ItemHold = {}
            function ItemHold:Button(text,callback)
                local Holding = false
                local Button = game:GetObjects("rbxassetid://6937142338")[1]
                Button.Parent = Section
                Button.Name = text .. "element"
                Button.ButtonText.Text = text
                Button.ClipsDescendants = true
                
                Button.MouseButton1Click:Connect(function()
                    callback()
                    Ripple(Button)
                end)
                Button.MouseEnter:Connect(function()
                    Holding = true
                end)
                Button.MouseLeave:Connect(function()
                    Holding = false
                end)

                spawn(function()
                    while wait() do
                       Button.BackgroundColor3 = Holding and SolarisLib.Themes[SolarisLib.Settings.Theme].ButtonHold or SolarisLib.Themes[SolarisLib.Settings.Theme].Button
                       Button.ButtonText.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

            end    
            function ItemHold:Toggle(text,def,flag,callback)
                local Toggle,ToggleMain = {Value = false}, game:GetObjects("rbxassetid://6963155498")[1]
                ToggleMain.Parent = Section
                ToggleMain.ToggleText.Text = text
                ToggleMain.Name = text .. "element"

                function Toggle:Set(value)
					Toggle.Value = value
                    TweenService:Create(ToggleMain.ToggleFrame.ToggleToggled.ToggleIco,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{ImageTransparency= Toggle.Value and 0 or 1}):Play()
                    TweenService:Create(ToggleMain.ToggleFrame.ToggleToggled.ToggleIco,TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size= Toggle.Value and UDim2.new(1,-2,1,-2) or UDim2.new(1,-6,1,-6)}):Play()
					return callback(Toggle.Value)
				end
				
				ToggleMain.MouseButton1Click:Connect(function()
					Toggle.Value = not Toggle.Value
					Toggle:Set(Toggle.Value)           
				end)

                spawn(function()
                    while wait() do
                        ToggleMain.ToggleFrame.ToggleToggled.BackgroundColor3 = Toggle.Value and SolarisLib.Themes[SolarisLib.Settings.Theme].ToggleToggled or SolarisLib.Themes[SolarisLib.Settings.Theme].Toggle
                        ToggleMain.ToggleFrame.BackgroundColor3 = Toggle.Value and SolarisLib.Themes[SolarisLib.Settings.Theme].ToggleToggled or SolarisLib.Themes[SolarisLib.Settings.Theme].ToggleFrame
                        ToggleMain.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Toggle
                        ToggleMain.ToggleText.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

				Toggle:Set(def)
                SolarisLib.Flags[flag] = Toggle
                return Toggle
            end    
            function ItemHold:Slider(text,min,max,start,inc,flag,callback)
                local Slider,SliderMain = {Value = start}, game:GetObjects("rbxassetid://6967573727")[1]
                SliderMain.Parent = Section
                SliderMain.SliderText.Text = text
                SliderMain.Name = text .. "element"
                local dragging = false

                local function move(Input)
                    local XSize = math.clamp((Input.Position.X - SliderMain.SliderFrame.AbsolutePosition.X) / SliderMain.SliderFrame.AbsoluteSize.X, 0, 1)
                    local Increment = inc and (max / ((max - min) / (inc * 4))) or (max >= 50 and max / ((max - min) / 4)) or (max >= 25 and max / ((max - min) / 2)) or (max / (max - min))
                    local SizeRounded = UDim2.new((math.round(XSize * ((max / Increment) * 4)) / ((max / Increment) * 4)), 0, 1, 0) 
                    TweenService:Create(SliderMain.SliderFrame.SliderCurrentFrame,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = SizeRounded}):Play() 
                    local Val = math.round((((SizeRounded.X.Scale * max) / max) * (max - min) + min) * 20) / 20
                    SliderMain.SliderVal.Text = tostring(Val)
                    Slider.Value = Val
                    callback(Slider.Value)
				end
				SliderMain.SliderFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
				SliderMain.SliderFrame.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
				game:GetService("UserInputService").InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then move(input) end end)

                function Slider:Set(val)
                    local a = tostring(val and (val / max) * (max - min) + min) or 0
					SliderMain.SliderVal.Text = tostring(a)
                    SliderMain.SliderFrame.SliderCurrentFrame.Size = UDim2.new((val or 0) / max, 0, 1, 0)
                    Slider.Value = val
					return callback(Slider.Value)
				end	

                spawn(function()
                    while wait() do
                       SliderMain.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Slider
                       SliderMain.SliderFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].SliderBar
                       SliderMain.SliderFrame.SliderCurrentFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].SliderInc
                       SliderMain.SliderText.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                       SliderMain.SliderVal.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)


                Slider:Set(start)
                SolarisLib.Flags[flag] = Slider
                return Slider
            end    
            function ItemHold:Dropdown(text,list,def,flag,callback)
                local Dropdown,DropMain,OptionPreset = {Value = nil, Toggled = false, Options = list}, game:GetObjects("rbxassetid://7027964359")[1], game:GetObjects("rbxassetid://7021432326")[1]
                DropMain.Parent = Section
                DropMain.Btn.Title.Text = text
                DropMain.Name = text .. "element"
                

                local function ToggleDrop()
                    Dropdown.Toggled = not Dropdown.Toggled
                    DropMain.Holder.Size = Dropdown.Toggled and UDim2.new(1,0,0,6+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,0)
                    TweenService:Create(DropMain,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1,0,0,38+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,32)}):Play() 
                    TweenService:Create(DropMain.Btn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = Dropdown.Toggled and 180 or 0}):Play() 
                    DropMain.Holder.Visible = Dropdown.Toggled
                end  

                local function AddOptions(opts)
                    for _,option in pairs(opts) do
                        local Option = OptionPreset:Clone()
                        Option.Parent = DropMain.Holder
                        Option.ItemText.Text = option
                        Option.ClipsDescendants = true

                        Option.MouseButton1Click:Connect(function()
                            Dropdown.Value = option
                            DropMain.Btn.Title.Text = text .. " - " .. option
                            Ripple(Option)
                            return callback(Dropdown.Value)
                        end)

                        spawn(function()
                            while wait() do
                               Option.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].DropdownItem
                               DropMain.Btn.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                            end
                        end)
                    end   
                end    

                function Dropdown:Refresh(opts,del)
                    if del then
                        for _,v in pairs(DropMain.Holder:GetChildren()) do
                            if v:IsA"TextButton" then
								v:Destroy()
                                DropMain.Holder.Size = Dropdown.Toggled and UDim2.new(1,0,0,6+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,0)
                                DropMain.Size = Dropdown.Toggled and UDim2.new(1,0,0,38+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,32)
							end
                        end    
                    end    
                    AddOptions(opts)
                end    
             

                DropMain.Btn.MouseButton1Click:Connect(function()
                    ToggleDrop()
                end)

                function Dropdown:Set(val)
					Dropdown.Value = val
                    DropMain.Btn.Title.Text = text .. " - " .. val
					return callback(Dropdown.Value)
				end

                spawn(function()
                    while wait() do
                       DropMain.Btn.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Dropdown
                       DropMain.Btn.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                       DropMain.Btn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

                Dropdown:Refresh(list,false)
                Dropdown:Set(def)
                SolarisLib.Flags[flag] = Dropdown
                return Dropdown
            end   
            function ItemHold:MultiDropdown(text,list,def,flag,callback)
                local Dropdown,DropMain,OptionPreset = {Value = {}, Toggled = false, Options = list}, game:GetObjects("rbxassetid://7027964359")[1], game:GetObjects("rbxassetid://7021432326")[1]
                DropMain.Parent = Section
                DropMain.Btn.Title.Text = text
                DropMain.Name = text .. "element"
                

                local function ToggleDrop()
                    Dropdown.Toggled = not Dropdown.Toggled
                    DropMain.Holder.Size = Dropdown.Toggled and UDim2.new(1,0,0,6+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,0)
                    TweenService:Create(DropMain,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = Dropdown.Toggled and UDim2.new(1,0,0,38+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,32)}):Play() 
                    TweenService:Create(DropMain.Btn.Ico,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Rotation = Dropdown.Toggled and 180 or 0}):Play() 
                    DropMain.Holder.Visible = Dropdown.Toggled
                end  

                local function AddOptions(opts)
                    for _,option in pairs(opts) do
                        local Option = OptionPreset:Clone()
                        Option.Parent = DropMain.Holder
                        Option.ItemText.Text = option
                        Option.ClipsDescendants = true

                        Option.MouseButton1Click:Connect(function()
                            if table.find(Dropdown.Value, option) then				
								table.remove(Dropdown.Value, table.find(Dropdown.Value, option))
								DropMain.Btn.Title.Text = text .. " - " .. table.concat(Dropdown.Value, ", ")
								callback(Dropdown.Value)
							else
								table.insert(Dropdown.Value, option)
								DropMain.Btn.Title.Text = text .. " - " .. table.concat(Dropdown.Value, ", ")
								callback(Dropdown.Value)
							end
                            Ripple(Option)
                        end)

                        spawn(function()
                            while wait() do
                               Option.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].DropdownItem
                               DropMain.Btn.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                            end
                        end)
                    end   
                end    

                function Dropdown:Refresh(opts,del)
                    if del then
                        for _,v in pairs(DropMain.Holder:GetChildren()) do
                            if v:IsA"TextButton" then
								v:Destroy()
                                DropMain.Holder.Size = Dropdown.Toggled and UDim2.new(1,0,0,6+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,0)
                                DropMain.Size = Dropdown.Toggled and UDim2.new(1,0,0,38+DropMain.Holder.Layout.AbsoluteContentSize.Y) or UDim2.new(1,0,0,32)
							end
                        end    
                    end    
                    AddOptions(opts)
                end    
             

                DropMain.Btn.MouseButton1Click:Connect(function()
                    ToggleDrop()
                end)

                function Dropdown:Set(val)
					Dropdown.Value = val
                    DropMain.Btn.Title.Text = text .. " - " .. table.concat(Dropdown.Value, ", ")
					return callback(Dropdown.Value)
				end

                spawn(function()
                    while wait() do
                       DropMain.Btn.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Dropdown
                       DropMain.Btn.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                       DropMain.Btn.Ico.ImageColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

                Dropdown:Refresh(list,false)
                Dropdown:Set(def)
                SolarisLib.Flags[flag] = Dropdown
                return Dropdown
            end    
            function ItemHold:Colorpicker(text,preset,flag,callback)
                local ColorH, ColorS, ColorV = 1, 1, 1
                local ColorPicker, ColorPreset, DragPreset = {Value = preset, Toggled = false}, game:GetObjects("rbxassetid://7329998014")[1]
                ColorPreset.Hue.Visible, ColorPreset.Color.Visible = ColorPicker.Toggled, ColorPicker.Toggled
                ColorPreset.Parent = Section
                ColorPreset.Btn.Colorpicker.Text = text
                ColorPreset.Name = text .. "element"
                ColorPreset.Btn.Box.BackgroundColor3 = preset
                ColorPreset.Hue.HueGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))}
                local Color = ColorPreset.Color
                local Hue = ColorPreset.Hue
                local HueSelection = ColorPreset.Hue.HueSelection
                local ColorSelection = ColorPreset.Color.ColorSelection
                
                function UpdateColorPicker()
                    ColorPreset.Btn.Box.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
                    Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
                    pcall(callback, ColorPreset.Btn.Box.BackgroundColor3)
                end
    
                ColorPreset.Btn.MouseButton1Click:Connect(function()
                    ColorPicker.Toggled = not ColorPicker.Toggled
                    TweenService:Create(ColorPreset,TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),{Size = ColorPicker.Toggled and UDim2.new(1,0,0,120) or UDim2.new(1,0,0,32)}):Play() 
                    ColorPreset.Hue.Visible, ColorPreset.Color.Visible = ColorPicker.Toggled, ColorPicker.Toggled
                end)

                ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
			    ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

                ColorPreset.Btn.Box.BackgroundColor3 = preset
                Color.BackgroundColor3 = preset
                pcall(callback, ColorPreset.Btn.Box.BackgroundColor3)

                Color.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if ColorInput then
                            ColorInput:Disconnect()
                        end
                        ColorInput = RunService.RenderStepped:Connect(function()
                            local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
                            local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
                            ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
                            ColorS = ColorX
                            ColorV = 1 - ColorY
                            UpdateColorPicker()
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

                spawn(function()
                    while wait() do
                       ColorPreset.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Colorpicker
                       ColorPreset.Btn.Colorpicker.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

                return ColorPicker
            end
            function ItemHold:Label(text)
                local Label, LabelFrame = {}, game:GetObjects("rbxassetid://7032552322")[1]
                LabelFrame.Parent = Section
                LabelFrame.Title.Text = text
                LabelFrame.Name = text .. "element"

                function Label:Set(tochange)
                    LabelFrame.Title.Text = tochange
                    LabelFrame.Name = text .. "element"
                end    

                
                spawn(function()
                    while wait() do
                       LabelFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Label
                       LabelFrame.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

                return Label
            end
            function ItemHold:Textbox(text,disappear,callback)
                local Textbox, TextboxFrame = {}, game:GetObjects("rbxassetid://7147292392")[1]
                TextboxFrame.Parent = Section
                TextboxFrame.Title.Text = text
                TextboxFrame.Name = text .. "element"

                TextboxFrame.Box.Changed:Connect(function()
                    TextboxFrame.Box.Size = UDim2.new(0,TextboxFrame.Box.TextBounds.X + 16,0,22)
                end)
                TextboxFrame.Box.PlaceholderText = "                  "

                TextboxFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        TextboxFrame.Box:CaptureFocus()
					end
				end)
				

                TextboxFrame.Box.FocusLost:Connect(function()
                    local txt = TextboxFrame.Box.Text
                    if disappear then
                        TextboxFrame.Box.Text = ""
                    end  
                    return callback(txt)
				end)

                UserInputService.InputBegan:Connect(function(input)
					if input.KeyCode == Enum.KeyCode.Escape and TextboxFrame.Box:IsFocused() then
						TextboxFrame.Box:ReleaseFocus()
					end
				end)
                
                spawn(function()
                    while wait() do
                       TextboxFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Textbox
                       TextboxFrame.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                       TextboxFrame.Box.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextboxFrame
                       TextboxFrame.Box.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)
                return Textbox
            end    
            function ItemHold:Bind(text,preset,holdmode,flag,callback)
                local Bind, BindFrame = {Value, Binding = false, Holding = false}, game:GetObjects("rbxassetid://7126874744")[1]
                BindFrame.Parent = Section
                BindFrame.Title.Text = text
                BindFrame.Name = text .. "element"

                

                BindFrame.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        if Bind.Binding then return end
                        Bind.Binding = true
                        BindFrame.BText.Text = "..."
                    end
                end)

                UserInputService.InputBegan:Connect(function(Input)
                    if UserInputService:GetFocusedTextBox() then return end
                    if (Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value) and not Bind.Binding then
                        if holdmode then
                            Holding = true
                            callback(Holding)
                        else
                            callback()
                        end
                    elseif Bind.Binding then
                        local Key
                        pcall(function()
                            if not CheckKey(BlacklistedKeys, Input.KeyCode) then
                                Key = Input.KeyCode
                            end
                        end)
                        pcall(function()
                            if CheckKey(WhitelistedMouse, Input.UserInputType) and not Key then
                                Key = Input.UserInputType
                            end
                        end)
                        Key = Key or Bind.Value
                        Bind:Set(Key)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.KeyCode.Name == Bind.Value or Input.UserInputType.Name == Bind.Value then
                        if holdmode and Holding then
                            Holding = false
                            callback(Holding)
                        end
                    end
                end)

                function Bind:Set(key)
                    self.Binding = false
                    self.Value = key or self.Value
                    self.Value = self.Value.Name or self.Value
                    BindFrame.BText.Text = self.Value
				end

                spawn(function()
                    while wait() do
                       BindFrame.BackgroundColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].Bind
                       BindFrame.Title.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                       BindFrame.BText.TextColor3 = SolarisLib.Themes[SolarisLib.Settings.Theme].TextColor
                    end
                end)

				Bind:Set(preset)
                SolarisLib.Flags[flag] = Bind
                return Bind
            end    
            return ItemHold
        end    
        return SectionHold
    end 
    return TabHolder
end    
return SolarisLib
