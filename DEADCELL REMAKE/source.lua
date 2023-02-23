-- settings (so u dont have to scroll)
local settings = {
    folder_name = "zephyrus"; -- stupid shit
    default_accent = Color3.fromRGB(61, 100, 227); -- also stupid shit
};

local drawing = loadstring(game:HttpGet("https://github.com/GhostDuckyy/UI-Libraries/blob/main/DEADCELL%20REMAKE/misc/extension.lua?raw=true"))();
local tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/utility/main/Tween.lua"))()

-- // UI LIBRARY
if not isfolder(settings.folder_name) then
    makefolder(settings.folder_name);
    makefolder(settings.folder_name.."/configs");
    makefolder(settings.folder_name.."/assets");
end;

local images = {
    ['gradient90'] = "https://raw.githubusercontent.com/portallol/luna/main/Gradient.png";
    ['gradient180'] = "https://raw.githubusercontent.com/portallol/luna/main/Gradient180.png";
    ['arrow_down'] = "https://i.imgur.com/tVqy0nL.png";
    ['arrow_up'] = "https://i.imgur.com/SL9cbQp.png";
}
for i,v in next, images do
    if not isfile(settings.folder_name..'/assets/'..i..'.ln') then
        writefile(settings.folder_name..'/assets/'..i..'.ln', syn.crypt.custom.encrypt('aes-ctr',game:HttpGet(v),'4XGudgFuutoHUM2Ctwsq4YrQ','zP5JJWPSIbf5Xuuy'))
    end
    images[i] = syn.crypt.custom.decrypt('aes-ctr',readfile(settings.folder_name..'/assets/'..i..'.ln'),'4XGudgFuutoHUM2Ctwsq4YrQ','zP5JJWPSIbf5Xuuy')
end

local services = setmetatable({}, {
    __index = function(_, k)
        k = (k == "InputService" and "UserInputService") or k
        return game:GetService(k)
    end
})

local client = services.Players.LocalPlayer

local utility = {}
local totalunnamedflags = 0
function utility.dragify(main, dragoutline, object)
    local start, objectposition, dragging, currentpos

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            dragoutline.Visible = true
            objectposition = object.Position
        end
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            currentpos = UDim2.new(objectposition.X.Scale, objectposition.X.Offset + (input.Position - start).X, objectposition.Y.Scale, objectposition.Y.Offset + (input.Position - start).Y)
            dragoutline.Position = currentpos
        end
    end)

    utility.connect(services.InputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then 
            dragging = false
            dragoutline.Visible = false
            object.Position = currentpos
        end
    end)
end
function utility.textlength(str, font, fontsize)
    local text = Drawing.new("Text")
    text.Text = str
    text.Font = font
    text.Size = fontsize

    local textbounds = text.TextBounds
    text:Remove()

    return textbounds
end
function utility.getcenter(sizeX, sizeY)
    return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
end
function utility.table(tbl, usemt)
    tbl = tbl or {}

    local oldtbl = table.clone(tbl)
    table.clear(tbl)

    for i, v in next, oldtbl do
        if type(i) == "string" then
            tbl[i:lower()] = v
        else
            tbl[i] = v
        end
    end

    if usemt == true then
        setmetatable(tbl, {
            __index = function(t, k)
                return rawget(t, k:lower()) or rawget(t, k)
            end,

            __newindex = function(t, k, v)
                if type(k) == "string" then
                    rawset(t, k:lower(), v)
                else
                    rawset(t, k, v)
                end
            end
        })
    end

    return tbl
end
function utility.colortotable(color)
    local r, g, b = math.floor(color.R * 255),  math.floor(color.G * 255), math.floor(color.B * 255)
    return {r, g, b}
end
function utility.tabletocolor(tbl)
    return Color3.fromRGB(unpack(tbl))
end
function utility.round(number, float)
    return float * math.floor(number / float)
end
function utility.getrgb(color)
    local r = color.R * 255
    local g = color.G * 255
    local b = color.B * 255

    return r, g, b
end
function utility.changecolor(color, number)
    local r, g, b = utility.getrgb(color)
    r, g, b = math.clamp(r + number, 0, 255), math.clamp(g + number, 0, 255), math.clamp(b + number, 0, 255)
    return Color3.fromRGB(r, g, b)
end
function utility.nextflag()
    totalunnamedflags = totalunnamedflags + 1
    return string.format("%.14g", totalunnamedflags)
end
function utility.rgba(r, g, b, alpha)
    local rgb = Color3.fromRGB(r, g, b)
    local mt = table.clone(getrawmetatable(rgb))

    setreadonly(mt, false)
    local old = mt.__index

    mt.__index = newcclosure(function(self, key)
        if key:lower() == "a" then
            return alpha
        end

        return old(self, key)
    end)

    setrawmetatable(rgb, mt)

    return rgb
end
local themes = {
    ["Default"] = {
        ["Accent"] = settings.default_accent,
        ["Window Outline Background"] = Color3.fromRGB(39,39,47),
        ["Window Inline Background"] = Color3.fromRGB(23,23,30),
        ["Window Holder Background"] = Color3.fromRGB(32,32,38),
        ["Page Unselected"] = Color3.fromRGB(32,32,38),
        ["Page Selected"] = Color3.fromRGB(55,55,64),
        ["Section Background"] = Color3.fromRGB(27,27,34),
        ["Section Inner Border"] = Color3.fromRGB(50,50,58),
        ["Section Outer Border"] = Color3.fromRGB(19,19,27),
        ["Window Border"] = Color3.fromRGB(58,58,67),
        ["Text"] = Color3.fromRGB(245, 245, 245),
        ["Risky Text"] = Color3.fromRGB(245, 239, 120),
        ["Object Background"] = Color3.fromRGB(41,41,50)
    };
}

local themeobjects = {}
local library = {theme = table.clone(themes.Default),currentcolor = nil, folder = "zephyrus", flags = {}, open = true, mousestate = services.InputService.MouseIconEnabled, cursor = nil, holder = nil, connections = {}, notifications = {}};
local decode = (syn and syn.crypt.base64.decode) or (crypt and crypt.base64decode) or base64_decode
library.gradient = images.gradient90 --decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABuSURBVChTxY9BDoAgDASLGD2ReOYNPsR/+BAfroI7hibe9OYmky2wbUPIOdsXdc1f9WMwppQm+SDGBnUvomAQBH49qzhFEag25869ElzaIXDhD4JGbyoEVxUedN8FKwnfmwhucgKICc+pNB1mZhdCdhsa2ky0FAAAAABJRU5ErkJggg==")
library.utility = utility

function utility.outline(obj, color)
    local outline = drawing:new("Square")
    outline.Parent = obj
    outline.Size = UDim2.new(1, 2, 1, 2)
    outline.Position = UDim2.new(0, -1, 0, -1)
    outline.ZIndex = obj.ZIndex - 1

    if typeof(color) == "Color3" then
        outline.Color = color
    else
        outline.Color = library.theme[color]
        themeobjects[outline] = color
    end

    outline.Parent = obj
    outline.Filled = false
    outline.Thickness = 1

    return outline
end

function utility.create(class, properties)
    local obj = drawing:new(class)

    for prop, v in next, properties do
        if prop == "Theme" then
            themeobjects[obj] = v
            obj.Color = library.theme[v]
        else
            obj[prop] = v
        end
    end

    return obj
end

function utility.changeobjecttheme(object, color)
    themeobjects[object] = color
    object.Color = library.theme[color]
end

function utility.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(library.connections, connection)

    return connection
end

function utility.disconnect(connection)
    local index = table.find(library.connections, connection)
    connection:Disconnect()

    if index then
        table.remove(library.connections, index)
    end
end

function utility.hextorgb(hex)
    return Color3.fromRGB(tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x"..hex:sub(5, 6)))
end

local accentobjs = {}

local flags = {}

local configignores = {}

function library:ConfigIgnore(flag)
    table.insert(configignores, flag)
end
function library:Close()
    self.open = not self.open

    if self.holder then
        self.holder.Visible = self.open
    end

    if self.cursor then
        self.cursor.Visible = self.open
    end
end

function library:ChangeThemeOption(option, color)
    self.theme[option] = color

    for obj, theme in next, themeobjects do
        if rawget(obj, "exists") == true and theme == option then
            obj.Color = color
        end
    end
end
function library:SetTheme(theme)
    self.currenttheme = theme

    self.theme = table.clone(theme)

    for object, color in next, themeobjects do
        if rawget(object, "exists") == true then
            object.Color = self.theme[color]
        end
    end

end
-- // UI ELEMENTS
function library.notify(message, time, color)
    time = time or 5

    local notification = {};

    library.notifications[notification] = true

    do
        local objs = notification;
        local z = 10;

        notification.holder = utility.create('Square', {
            Position = UDim2.new(0, 0, 0, 75);
            Transparency = 0;
            Thickness = 1;
        })
        
        notification.background = utility.create('Square', {
            Size = UDim2.new(1,0,1,0);
            Position = UDim2.new(0, -500, 0, 0);
            Parent = notification.holder;
            Theme = 'Object Background';
            ZIndex = z;
            Thickness = 1;
            Filled = true;
        })

        notification.border1 = utility.create('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            Theme = 'Section Inner Border';
            Parent = notification.background;
            ZIndex = z-1;
            Thickness = 1;
            Filled = true;
        })

        objs.border2 = utility.create('Square', {
            Size = UDim2.new(1,2,1,2);
            Position = UDim2.new(0,-1,0,-1);
            Theme = 'Section Outer Border';
            Parent = objs.border1;
            ZIndex = z-2;
            Thickness = 1;
            Filled = true;
        })

        notification.gradient = utility.create('Image', {
            Size = UDim2.new(1,0,1,0);
            Data = images.gradient90;
            Parent = notification.background;
            Transparency = .5;
            ZIndex = z+1;
        })

        notification.accentBar = utility.create('Square',{
            Size = UDim2.new(0,1,1,1);
            Position = UDim2.new(0,-1,0,0);
            Parent = notification.background;
            Theme = color == nil and 'Accent' or '';
            ZIndex = z+5;
            Thickness = 1;
            Filled = true;
        })

        notification.accentBottomBar = utility.create('Square',{
            Size = UDim2.new(0,0,0,1);
            Position = UDim2.new(0,0,1,0);
            Parent = notification.background;
            Theme = color == nil and 'Accent' or '';
            ZIndex = z+5;
            Thickness = 1;
            Filled = true;
        })

        notification.text = utility.create('Text', {
            Position = UDim2.new(0,5,0,2);
            Theme = 'Text';
            Text = message;
            Outline = true;
            Font = 2;
            Size = 13;
            ZIndex = z+4;
            Parent = notification.background;
        })

        if color then
            notification.accentBar.Color = color;
        end

    end

    function notification:remove()
        self.holder:Remove();
        library.notifications[notification] = nil;
        library.update_notifications()
    end

    task.spawn(function()
        library.update_notifications();
        notification.background.Size = UDim2.new(0, notification.text.TextBounds.X + 10, 0, 19)
        local sizetween = tween.new(notification.accentBottomBar, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,0, 1)})
        sizetween:Play()
        local postween = tween.new(notification.background, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)})
        postween:Play()
        task.wait(time);
        library.update_notifications2(notification)
        task.wait(1.2)
        notification:remove()
    end)

    return notification
end
function library.update_notifications()
    local i = 0
    for v in next, library.notifications do
        local tween = tween.new(v.holder, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,20,0, 75 + (i * 30))})
        tween:Play()
        i = i + 1
    end
end
function library.update_notifications2(drawing) -- i hate this i hate this...
    local tween = tween.new(drawing.background, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -(drawing.background.Size.X.Offset + 10), 0, drawing.background.Position.Y)})
    tween:Play()

    for i,v in pairs(drawing) do
        if type(v) == "table" then
            local tween = tween.new(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0})
            tween:Play()
        end
    end
end
function library.createkeybindlist() -- ctrl c + ctrl v 
    -- settings
    local keybind_list_tbl = {keybinds = {}};
    local keybind_list_drawings = {};
    -- drawings
    local list_outline = utility.create("Square", {Visible = true, Transparency = 1, Theme = "Window Outline Background", Size = UDim2.new(0, 180, 0, 30), Position = UDim2.new(0, 10, 0.4, 0), Thickness = 1, Filled = true, ZIndex = 100}) do
        local outline = utility.outline(list_outline, "Window Border");
        utility.outline(outline, Color3.new(0,0,0));
    end;
    --
    local list_inline = utility.create("Square", {Parent = list_outline, Visible = true, Transparency = 1, Theme = "Window Inline Background", Size = UDim2.new(1,-8,1,-8), Position = UDim2.new(0,4,0,4), Thickness = 1, Filled = true, ZIndex = 101}) do
        local outline = utility.outline(list_inline, "Window Border");
    end;
    --
    local list_accent = utility.create("Square", {Parent = list_inline, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,-2,0,2), Position = UDim2.new(0,1,0,1), Thickness = 1, Filled = true, ZIndex = 101});
    --
    local list_title = utility.create("Text", {Text = "Keybinds", Parent = list_inline, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, OutlineColor = Color3.fromRGB(50,50,50), Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0,5), ZIndex = 101});
    --
    local list_content = utility.create("Square", {Parent = list_outline, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,33), Thickness = 1, Filled = true, ZIndex = 101});
    list_content:AddListLayout(1)
    -- functions
    function keybind_list_tbl:add_keybind(name, key)
        local key_settings = {};
        --
        local key_holder = utility.create("Square", {Parent = list_content, Size = UDim2.new(1,0,0,22), ZIndex = 100, Transparency = 1, Visible = true, Filled = true, Thickness = 1, Theme = "Window Outline Background"}) do
            local outline = utility.outline(key_holder, "Window Border");
            utility.outline(outline, Color3.new(0,0,0));
        end;
        --
        local list_title = utility.create("Text", {Text = tostring(name .." ["..key.."]"), Parent = key_holder, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,2,0,4), ZIndex = 101});
        -- functions
        function key_settings:is_active(state)
            if state then
                utility.changeobjecttheme(list_title, "Accent");
            else
                utility.changeobjecttheme(list_title, "Text");
            end
        end;
        --
        function key_settings:update_text(text)
            list_title.Text = text
        end;
        --
        function key_settings:Remove()
            key_holder:Remove()
            list_title:Remove()
            keybind_list_tbl.keybinds[name] = nil;
            key_settings = nil;
        end;
        --
        keybind_list_tbl.keybinds[name] = name;
        --
        return key_settings;
    end;
    --
    function keybind_list_tbl:remove_keybind(name)
        if name and keybind_list_tbl.keybinds[name] then
            keybind_list_tbl.keybinds[name]:remove()
            keybind_list_tbl.keybinds[name] = nil
        end
    end;
    --
    function keybind_list_tbl:set_visible(state)
        list_outline.Visible = state;
    end;
    --
    utility.connect(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),function()
        list_outline.Position = UDim2.new(0, 10, 0.4, 0)
    end);
    --
    return keybind_list_tbl
end;
--
local pickers = {}
--
function library.createcolorpicker(default, parent, count, flag, callback, offset)
    local icon = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Color = default,
        Parent = parent,
        Transparency = defaultalpha,
        Size = UDim2.new(0, 17, 0, 9),
        Position = UDim2.new(1, -17 - (count * 17) - (count * 6), 0, 4 + offset),
        ZIndex = 8
    })

    local outline = utility.outline(icon, "Section Inner Border")
    utility.outline(outline, "Section Outer Border")

    utility.create("Image", {
        Size = UDim2.new(1, 0, 1, 0),
        Transparency = 0.5,
        ZIndex = 10,
        Parent = icon,
        Data = library.gradient
    })

    local window = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = icon,
        Theme = "Object Background",
        Size = UDim2.new(0, 185, 0, 200),
        Visible = false,
        Position = UDim2.new(1, -185 + (count * 20) + (count * 6), 1, 6),
        ZIndex = 20
    })

    table.insert(pickers, window)

    local outline1 = utility.outline(window, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")

    local saturation = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Color = default,
        Size = UDim2.new(0, 154, 0, 150),
        Position = UDim2.new(0, 6, 0, 6),
        ZIndex = 24
    })

    utility.outline(saturation, "Section Inner Border")

    utility.create("Image", {
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 25,
        Parent = saturation,
        Data = decode("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")
    })

    local saturationpicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = saturation,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(0, 2, 0, 2),
        ZIndex = 26
    })

    utility.outline(saturationpicker, Color3.fromRGB(0, 0, 0))

    local hueframe = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = window,
        Size = UDim2.new(0,15, 0, 150),
        Position = UDim2.new(0, 165, 0, 6),
        ZIndex = 24
    })

    utility.outline(hueframe, "Section Inner Border")

    utility.create("Image", {
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 25,
        Parent = hueframe,
        Data = syn.crypt.base64.decode("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")
    })

    local huepicker = utility.create("Square", {
        Filled = true,
        Thickness = 0,
        Parent = hueframe,
        Color = Color3.fromRGB(255, 255, 255),
        Size = UDim2.new(1,0,0,1),
        ZIndex = 26
    })

    utility.outline(huepicker, Color3.fromRGB(0, 0, 0))

    local rgbinput = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(1, -12, 0, 14),
        Position = UDim2.new(0, 6, 0, 160),
        ZIndex = 24,
        Parent = window
    })

    utility.create("Image", {
        Size = UDim2.new(1, 0, 1, 0),
        Transparency = 0.5,
        ZIndex = 24,
        Parent = rgbinput,
        Data = library.gradient
    })

    local outline2 = utility.outline(rgbinput, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")

    local text = utility.create("Text", {
        Text = string.format("%s, %s, %s", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, 0),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = rgbinput
    })

    local copy = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0, 6, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    utility.create("Image", {
        Size = UDim2.new(1, 0, 1, 0),
        Transparency = 0.5,
        ZIndex = 24,
        Parent = copy,
        Data = library.gradient
    })

    local outline3 = utility.outline(copy, "Section Inner Border")
    utility.outline(outline3, "Section Outer Border")

    utility.create("Text", {
        Text = "copy",
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = copy
    })

    local paste = utility.create("Square", {
        Filled = true,
        Transparency = 1,
        Thickness = 1,
        Theme = "Object Background",
        Size = UDim2.new(0.5, -20, 0, 12),
        Position = UDim2.new(0.5, 15, 0, 180),
        ZIndex = 24,
        Parent = window
    })

    utility.create("Image", {
        Size = UDim2.new(1, 0, 1, 0),
        Transparency = 0.5,
        ZIndex = 24,
        Parent = paste,
        Data = library.gradient
    })

    utility.create("Text", {
        Text = "paste",
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0.5, 0, 0, -2),
        Center = true,
        Theme = "Text",
        ZIndex = 26,
        Outline = true,
        Parent = paste
    })

    local outline4 = utility.outline(paste, "Section Inner Border")
    utility.outline(outline4, "Section Outer Border")

    local mouseover = false


    utility.connect(copy.MouseButton1Click, function()
        library.currentcolor = current_val
    end)

    local function set(color, nopos, setcolor)
        if type(color) == "table" then
            color = Color3.fromHex(color.color)
        end

        if type(color) == "string" then
            color = Color3.fromHex(color)
        end

        local oldcolor = hsv

        hue, sat, val = color:ToHSV()
        hsv = Color3.fromHSV(hue, sat, val)

        if hsv ~= oldcolor then
            icon.Color = hsv

            if not nopos then
                saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)), 0, (math.clamp((1 - val) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 2)))
                huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturation.AbsoluteSize.Y, 0, saturation.AbsoluteSize.Y - 4))
                if setcolor then
                    saturation.Color = hsv
                end
            end

            text.Text = string.format("%s, %s, %s", math.round(hsv.R * 255), math.round(hsv.G * 255), math.round(hsv.B * 255))

            if flag then
                library.flags[flag] = utility.rgba(hsv.r * 255, hsv.g * 255, hsv.b * 255)
            end

            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))

            current_val = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
        end
    end

    utility.connect(paste.MouseButton1Click, function()
        if library.currentcolor ~= nil then
            set(library.currentcolor, false, true)
        end;
    end)

    flags[flag] = set

    set(default)

    local defhue, _, _ = default:ToHSV()

    local curhuesizey = defhue

    local function updatesatval(input)
        local sizeX = math.clamp((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X, 0, 1)
        local sizeY = 1 - math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) + 36) / saturation.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - saturation.AbsolutePosition.Y) / saturation.AbsoluteSize.Y) * saturation.AbsoluteSize.Y + 36, 0, saturation.AbsoluteSize.Y - 2)
        local posX = math.clamp(((input.Position.X - saturation.AbsolutePosition.X) / saturation.AbsoluteSize.X) * saturation.AbsoluteSize.X, 0, saturation.AbsoluteSize.X - 2)

        saturationpicker.Position = UDim2.new(0, posX, 0, posY)

        set(Color3.fromHSV(curhuesizey or hue, sizeX, sizeY), true, false)
    end

    local slidingsaturation = false

    saturation.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingsaturation = true
            updatesatval(input)
        end
    end)

    saturation.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidingsaturation = false
        end
    end)

    local slidinghue = false

    local function updatehue(input)
        local sizeY = 1 - math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) + 36) / hueframe.AbsoluteSize.Y, 0, 1)
        local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y + 36, 0, hueframe.AbsoluteSize.Y - 2)

        huepicker.Position = UDim2.new(0, 0, 0, posY)
        saturation.Color = Color3.fromHSV(sizeY, 1, 1)
        curhuesizey = sizeY

        set(Color3.fromHSV(sizeY, sat, val), true, true)
    end

    hueframe.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidinghue = true
            updatehue(input)
        end
    end)

    hueframe.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slidinghue = false
        end
    end)

    utility.connect(services.InputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then

            if slidinghue then
                updatehue(input)
            end

            if slidingsaturation then
                updatesatval(input)
            end
        end
    end)

    icon.MouseButton1Click:Connect(function()
        for _, picker in next, pickers do
            if picker ~= window then
                picker.Visible = false
            end
        end

        window.Visible = not window.Visible

        if slidinghue then
            slidinghue = false
        end

        if slidingsaturation then
            slidingsaturation = false
        end
    end)

    local colorpickertypes = {}

    function colorpickertypes:set(color)
        set(color)
    end

    return colorpickertypes, window
end
--
function library.createdropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, islist, size, section, sectioncontent)
    local dropdown = utility.create("Square", {
        Filled = true,
        Visible = not islist,
        Thickness = 0,
        Theme = "Object Background",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        ZIndex = 7,
        Parent = holder
    })

    local outline1 = utility.outline(dropdown, "Section Inner Border")
    utility.outline(outline1, "Section Outer Border")
    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = dropdown, Size = UDim2.new(1,0,1,0), ZIndex = 8});

    local value = utility.create("Text", {
        Text = "",
        Font = Drawing.Fonts.Plex,
        Size = 13,
        Position = UDim2.new(0, 2, 0, 0),
        Theme = "Text",
        ZIndex = 9,
        Outline = false,
        Parent = dropdown
    })

    local icon = utility.create("Image", {Data = images.arrow_down, Transparency = 0.5, Visible = true, Parent = dropdown, Size = UDim2.new(0,9,0,6), ZIndex = 9, Position = UDim2.new(1, -13, 0, 4)});

    local contentframe = utility.create("Square", {
        Filled = true,
        Visible = islist or false,
        Thickness = 0,
        Theme = "Object Background",
        Size = islist and size == "Fill" and UDim2.new(1, 0, 1, -30) or islist and size ~= "Fill" and UDim2.new(1,0,0,size) or UDim2.new(1,0,0,0),
        Position = islist and UDim2.new(0, 0, 0, 14) or UDim2.new(0, 0, 1, 6),
        ZIndex = 12,
        Parent = islist and holder or dropdown
    })

    local outline2 = utility.outline(contentframe, "Section Inner Border")
    utility.outline(outline2, "Section Outer Border")
    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = contentframe, Size = UDim2.new(1,0,1,0), ZIndex = 12});

    local contentholder = utility.create("Square", {
        Transparency = 0,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.new(0, 3, 0, 3),
        Parent = contentframe
    })

    if scrollable then
        contentholder:MakeScrollable()
    end

    contentholder:AddListLayout(3)

    local mouseover = false

    local opened = false

    if not islist then
        dropdown.MouseButton1Click:Connect(function()
            opened = not opened
            contentframe.Visible = opened
            icon.Data = opened and images.arrow_up or images.arrow_down
        end)
    end

    local optioninstances = {}
    local count = 0
    local countindex = {}

    local function createoption(name)
        optioninstances[name] = {}

        countindex[name] = count + 1

        local button = utility.create("Square", {
            Filled = true,
            Transparency = 0,
            Thickness = 1,
            Theme = "Object Background",
            Size = UDim2.new(1, 0, 0, 16),
            ZIndex = 14,
            Parent = contentholder
        })

        optioninstances[name].button = button

        local title = utility.create("Text", {
            Text = name,
            Font = Drawing.Fonts.Plex,
            Size = 13,
            Position = UDim2.new(0, 8, 0, 1),
            Theme = "Text",
            ZIndex = 15,
            Outline = true,
            Parent = button
        })

        optioninstances[name].text = title

        if scrollable then
            if count < scrollingmax and not islist then
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end
        else
            if not islist then
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end
        end

        if islist then
            holder.Position = holder.Position
        end

        count = count + 1

        return button, title
    end

    local chosen = max and {}

    local function handleoptionclick(option, button, text)
        button.MouseButton1Click:Connect(function()
            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    utility.changeobjecttheme(text, "Text")

                    library.flags[flag] = chosen
                    callback(chosen)
                else
                    if #chosen == max then
                        utility.changeobjecttheme(optioninstances[chosen[1]].text, "Text")

                        table.remove(chosen, 1)
                    end

                    table.insert(chosen, option)

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 18) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    utility.changeobjecttheme(text, "Accent")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            else
                for opt, tbl in next, optioninstances do
                    if opt ~= option then
                        utility.changeobjecttheme(tbl.text, "Text")
                    end
                end

                chosen = option

                value.Text = option

                utility.changeobjecttheme(text, "Accent")

                library.flags[flag] = option
                callback(option)

            end
        end)
    end

    local function createoptions(tbl)
        for _, option in next, tbl do
            local button, text = createoption(option)
            handleoptionclick(option, button, text)
        end
    end

    createoptions(content)

    local set
    set = function(option)
        if max then
            option = type(option) == "table" and option or {}
            table.clear(chosen)

            for opt, tbl in next, optioninstances do
                if not table.find(option, opt) then
                    --tbl.button.Transparency = 0
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end

            for i, opt in next, option do
                if table.find(content, opt) and #chosen < max then
                    table.insert(chosen, opt)
                    --optioninstances[opt].button.Transparency = 1
                    utility.changeobjecttheme(optioninstances[opt].text, "Accent")
                end
            end

            local textchosen = {}
            local cutobject = false

            for _, opt in next, chosen do
                table.insert(textchosen, opt)

                if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                    cutobject = true
                    table.remove(textchosen, #textchosen)
                end
            end

            value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

            library.flags[flag] = chosen
            callback(chosen)
        end

        if not max then
            for opt, tbl in next, optioninstances do
                if opt ~= option then
                    utility.changeobjecttheme(tbl.text, "Text")
                end
            end

            if table.find(content, option) then
                chosen = option

                value.Text = option

                utility.changeobjecttheme(optioninstances[option].text, "Accent")

                library.flags[flag] = chosen
                callback(chosen)
            else
                chosen = nil

                value.Text = ""

                library.flags[flag] = chosen
                callback(chosen)
            end
        end
    end

    flags[flag] = set

    set(default)

    local dropdowntypes = utility.table({}, true)

    function dropdowntypes:set(option)
        set(option)
    end

    function dropdowntypes:refresh(tbl)
        content = table.clone(tbl)
        count = 0

        for _, opt in next, optioninstances do
            coroutine.wrap(function()
                opt.button:Remove()
            end)()
        end

        table.clear(optioninstances)

        createoptions(tbl)

        if scrollable then
            contentholder:RefreshScrolling()
        end

        value.Text = ""

        if max then
            table.clear(chosen)
        else
            chosen = nil
        end

        library.flags[flag] = chosen
        callback(chosen)
    end

    function dropdowntypes:add(option)
        table.insert(content, option)
        local button, text = createoption(option)
        handleoptionclick(option, button, text)
    end

    function dropdowntypes:remove(option)
        if optioninstances[option] then
            count = count - 1

            optioninstances[option].button:Remove()

            if scrollable then
                contentframe.Size = UDim2.new(1, 0, 0, math.clamp(contentholder.AbsoluteContentSize, 0, (scrollingmax * 16) + ((scrollingmax - 1) * 3)) + 6)
            else
                contentframe.Size = UDim2.new(1, 0, 0, contentholder.AbsoluteContentSize + 6)
            end

            optioninstances[option] = nil

            if max then
                if table.find(chosen, option) then
                    table.remove(chosen, table.find(chosen, option))

                    local textchosen = {}
                    local cutobject = false

                    for _, opt in next, chosen do
                        table.insert(textchosen, opt)

                        if utility.textlength(table.concat(textchosen, ", ") .. ", ...", Drawing.Fonts.Plex, 13).X > (dropdown.AbsoluteSize.X - 6) then
                            cutobject = true
                            table.remove(textchosen, #textchosen)
                        end
                    end

                    value.Text = #chosen == 0 and "" or table.concat(textchosen, ", ") .. (cutobject and ", ..." or "")

                    library.flags[flag] = chosen
                    callback(chosen)
                end
            end
        end
    end

    return dropdowntypes
end
--
local allowedcharacters = {}
local shiftcharacters = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    ["-"] = "_",
    ["="] = "+",
    ["["] = "{",
    ["\\"] = "|",
    [";"] = ":",
    ["'"] = "\"",
    [","] = "<",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~"
}

for i = 32, 126 do
    table.insert(allowedcharacters, utf8.char(i))
end
--
function library.createbox(box, text, callback, finishedcallback)
    box.MouseButton1Click:Connect(function()
        services.ContextActionService:BindActionAtPriority("disablekeyboard", function() return Enum.ContextActionResult.Sink end, false, 3000, Enum.UserInputType.Keyboard)

        local connection
        local backspaceconnection

        local keyqueue = 0

        if not connection then
            connection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode ~= Enum.KeyCode.Backspace then
                        local str = services.InputService:GetStringForKeyCode(input.KeyCode)

                        if table.find(allowedcharacters, str) then
                            keyqueue = keyqueue + 1
                            local currentqueue = keyqueue

                            if not services.InputService:IsKeyDown(Enum.KeyCode.RightShift) and not services.InputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                text.Text = text.Text .. str:lower()
                                callback(text.Text)

                                local ended = false

                                coroutine.wrap(function()
                                    task.wait(0.5)

                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. str:lower()
                                        callback(text.Text)

                                        task.wait(0.02)
                                    end
                                end)()
                            else
                                text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                callback(text.Text)

                                coroutine.wrap(function()
                                    task.wait(0.5)

                                    while services.InputService:IsKeyDown(input.KeyCode) and currentqueue == keyqueue  do
                                        text.Text = text.Text .. (shiftcharacters[str] or str:upper())
                                        callback(text.Text)

                                        task.wait(0.02)
                                    end
                                end)()
                            end
                        end
                    end

                    if input.KeyCode == Enum.KeyCode.Return then
                        services.ContextActionService:UnbindAction("disablekeyboard")
                        utility.disconnect(backspaceconnection)
                        utility.disconnect(connection)
                        finishedcallback(text.Text)
                    end
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    services.ContextActionService:UnbindAction("disablekeyboard")
                    utility.disconnect(backspaceconnection)
                    utility.disconnect(connection)
                    finishedcallback(text.Text)
                end
            end)

            local backspacequeue = 0

            backspaceconnection = utility.connect(services.InputService.InputBegan, function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Backspace then
                    backspacequeue = backspacequeue + 1

                    text.Text = text.Text:sub(1, -2)
                    callback(text.Text)

                    local currentqueue = backspacequeue

                    coroutine.wrap(function()
                        task.wait(0.5)

                        if backspacequeue == currentqueue then
                            while services.InputService:IsKeyDown(Enum.KeyCode.Backspace) do
                                text.Text = text.Text:sub(1, -2)
                                callback(text.Text)

                                task.wait(0.02)
                            end
                        end
                    end)()
                end
            end)
        end
    end)
end
--
local keys = {
    [Enum.KeyCode.LeftShift] = "LeftShift",
    [Enum.KeyCode.RightShift] = "RightShift",
    [Enum.KeyCode.LeftControl] = "LeftControl",
    [Enum.KeyCode.RightControl] = "RightControl",
    [Enum.KeyCode.LeftAlt] = "LeftAlt",
    [Enum.KeyCode.RightAlt] = "RightAlt",
    [Enum.KeyCode.CapsLock] = "CAPS",
    [Enum.KeyCode.One] = "1",
    [Enum.KeyCode.Two] = "2",
    [Enum.KeyCode.Three] = "3",
    [Enum.KeyCode.Four] = "4",
    [Enum.KeyCode.Five] = "5",
    [Enum.KeyCode.Six] = "6",
    [Enum.KeyCode.Seven] = "7",
    [Enum.KeyCode.Eight] = "8",
    [Enum.KeyCode.Nine] = "9",
    [Enum.KeyCode.Zero] = "0",
    [Enum.KeyCode.KeypadOne] = "Numpad1",
    [Enum.KeyCode.KeypadTwo] = "Numpad2",
    [Enum.KeyCode.KeypadThree] = "Numpad3",
    [Enum.KeyCode.KeypadFour] = "Numpad4",
    [Enum.KeyCode.KeypadFive] = "Numpad5",
    [Enum.KeyCode.KeypadSix] = "Numpad6",
    [Enum.KeyCode.KeypadSeven] = "Numpad7",
    [Enum.KeyCode.KeypadEight] = "Numpad8",
    [Enum.KeyCode.KeypadNine] = "Numpad9",
    [Enum.KeyCode.KeypadZero] = "Numpad0",
    [Enum.KeyCode.Minus] = "-",
    [Enum.KeyCode.Equals] = "=",
    [Enum.KeyCode.Tilde] = "~",
    [Enum.KeyCode.LeftBracket] = "[",
    [Enum.KeyCode.RightBracket] = "]",
    [Enum.KeyCode.RightParenthesis] = ")",
    [Enum.KeyCode.LeftParenthesis] = "(",
    [Enum.KeyCode.Semicolon] = ",",
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = "\\",
    [Enum.KeyCode.Comma] = ",",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Slash] = "/",
    [Enum.KeyCode.Asterisk] = "*",
    [Enum.KeyCode.Plus] = "+",
    [Enum.KeyCode.Period] = ".",
    [Enum.KeyCode.Backquote] = "`",
    [Enum.UserInputType.MouseButton1] = "MouseButton1",
    [Enum.UserInputType.MouseButton2] = "MouseButton2",
    [Enum.UserInputType.MouseButton3] = "MouseButton3"
}
-- // UI START
function library:load_config(cfg_name)
    if isfile(cfg_name) then
        local file = readfile(cfg_name)
        local config = game:GetService("HttpService"):JSONDecode(file)

        for flag, v in next, config do
            local func = flags[flag]
            if func then
                func(v)
            end
        end
    end
end;
--
function library:new_window(cfg)
    -- settings
    local window_tbl = {pages = {}, page_buttons = {}, page_accents = {}}; -- store other functions
    local window_size = cfg.size or cfg.Size or Vector2.new(600,400);
    local size_x = window_size.X;
    local size_y = window_size.Y;
    -- drawings
    local window_outline = utility.create("Square", {Visible = true, Transparency = 1, Theme = "Window Outline Background", Size = UDim2.new(0,size_x,0,size_y), Position = UDim2.new(0.5, -(size_x / 2), 0.5, -(size_y / 2)), Thickness = 1, Filled = true, ZIndex = 1}) do
        local outline = utility.outline(window_outline, "Window Border");
        utility.outline(outline, Color3.new(0,0,0));
    end;
    --
    library.holder = window_outline;
    --
    local window_inline = utility.create("Square", {Parent = window_outline, Visible = true, Transparency = 1, Theme = "Window Inline Background", Size = UDim2.new(1,-10,1,-10), Position = UDim2.new(0,5,0,5), Thickness = 1, Filled = true, ZIndex = 2}) do
        local outline = utility.outline(window_inline, "Window Border");
    end;
    --
    local window_accent = utility.create("Square", {Parent = window_inline, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,-2,0,2), Position = UDim2.new(0,1,0,1), Thickness = 1, Filled = true, ZIndex = 2});
    --
    local window_holder = utility.create("Square", {Parent = window_inline, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(1,-30,1,-30), Position = UDim2.new(0,15,0,15), Thickness = 1, Filled = true, ZIndex = 3}) do
        local outline = utility.outline(window_holder, "Window Border");
    end;
    --
    local window_pages_holder = utility.create("Square", {Parent = window_holder, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,25), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 3})
    --
    local window_drag = utility.create("Square", {Parent = window_outline, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,10), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 10})
    --
    local dragoutline = utility.create("Square", {
        Size = UDim2.new(0, size_x, 0, size_y),
        Position = utility.getcenter(size_x, size_y),
        Filled = false,
        Thickness = 1,
        Theme = "Accent",
        ZIndex = 1,
        Visible = false,
    })
    --
    utility.dragify(window_drag, dragoutline, window_outline);
    --
    local window_key_list = library.createkeybindlist();
    window_key_list:set_visible(false);
    -- create page
    function window_tbl:new_page(cfg)
        -- settings
        local page_tbl = {sections = {}};
        local page_name = cfg.name or cfg.Name or "new page";
        -- drawings
        local page_button = utility.create("Square", {Parent = window_pages_holder, Visible = true, Transparency = 1, Theme = "Page Unselected", Size = UDim2.new(0,0,0,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 4}) do
            local outline = utility.outline(page_button, "Window Border");
            table.insert(self.page_buttons, page_button);
            utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = page_button, Size = UDim2.new(1,0,1,0), ZIndex = 4});
        end;
        --
        local page_title = utility.create("Text", {Text = page_name, Parent = page_button, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, OutlineColor = Color3.fromRGB(50,50,50), Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0,6), ZIndex = 4});
        --
        local page_button_accent = utility.create("Square", {Parent = page_button, Visible = false, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,0,1), Thickness = 1, Filled = true, ZIndex = 4}) do
            table.insert(self.page_accents, page_button_accent);
        end;
        --
        local page = utility.create("Square", {Parent = window_holder, Visible = false, Transparency = 0, Size = UDim2.new(1,-40,1,-45), Position = UDim2.new(0,20,0,40), Thickness = 1, Filled = false, ZIndex = 4}) do
            table.insert(self.pages, page);
        end;
        --
        local left = utility.create("Square", {Transparency = 0,Filled = false,Thickness = 1,ZIndex = 4,Parent = page,Size = UDim2.new(0.5, -14, 1, -10);});
        left:AddListLayout(15)
        local right = utility.create("Square", {Transparency = 0,Filled = false,Thickness = 1,Parent = page,ZIndex = 3,Size = UDim2.new(0.5, -14, 1, -10),Position = UDim2.new(0.5, 14, 0, 0);});
        right:AddListLayout(15)
        -- functions
        utility.connect(page_button.MouseButton1Click, function() -- ignore
            for i,v in next, self.page_buttons do
                if v ~= page_button then
                    utility.changeobjecttheme(v, "Page Unselected");
                end;
            end;
            --
            for i,v in next, self.page_accents do
                if v ~= page_button_accent then
                    v.Visible = false;
                end;
            end;
            --
            for i,v in next, self.pages do
                if v ~= page then
                    v.Visible = false;
                end;
            end;
            --
            utility.changeobjecttheme(page_button, "Page Selected");
            page_button_accent.Visible = true;
            page.Visible = true;
        end);
        -- update size
        for _,v in next, self.page_buttons do
            v.Size = UDim2.new(1 / #self.page_buttons, _ == 1 and 1 or _ == #self.page_buttons and -2 or -1, 1, 0);
            v.Position = UDim2.new(1 / (#self.page_buttons / (_ - 1)), _ == 1 and 0 or 2, 0, 0);
        end;
        --
        function page_tbl:open()
            utility.changeobjecttheme(page_button, "Page Selected");
            page_button_accent.Visible = true;
            page.Visible = true;
        end;
        -- create section
        function page_tbl:new_section(cfg)
            -- settings
            local section_tbl = {};
            local section_name = cfg.name or cfg.Name or "new section";
            local section_side = cfg.side == "left" and left or cfg.Side == "left" and left or cfg.side == "right" and right or cfg.Side == "right" and right or left; -- ignore shit code
            local section_size = cfg.size or cfg.Size or 200;
            -- drawings
            local section = utility.create("Square", {Parent = section_side, Visible = true, Transparency = 1, Theme = "Section Background", Size = section_size ~= "Fill" and UDim2.new(1,0,0,section_size) or UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 5}) do
                local outline = utility.outline(section, "Section Inner Border");
                utility.outline(outline, "Section Outer Border")
            end;
            --
            local section_title_cover = utility.create("Square", {Parent = section, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(0,utility.textlength(section_name, Drawing.Fonts.Plex, 13).X + 2,0,4), Position = UDim2.new(0,10,0,-4), Thickness = 1, Filled = true, ZIndex = 5})
            local section_title = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,10,0,-8), ZIndex = 5});
            local section_title_bold = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,11,0,-8), ZIndex = 5});
            --
            local section_content = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, -32, 1, -10),Position = UDim2.new(0, 16, 0, 15),Parent = section,ZIndex = 6});
            section_content:AddListLayout(8)
            -- create toggle
            function section_tbl:new_toggle(cfg)
                -- settings
                local toggle_tbl = {colorpickers = 0};
                local toggle_name = cfg.name or cfg.Name or "new toggle";
                local toggle_risky = cfg.risky or cfg.Risky or false;
                local toggle_state = cfg.state or cfg.State or false;
                local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or cfg.Callback or function() end;
                local toggled = false;
                -- drawings
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 8});
                --
                local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) do
                    local outline = utility.outline(toggle_frame, "Section Inner Border");
                    utility.outline(outline, "Section Outer Border");
                end;
                local gradient = utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = false, Parent = toggle_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                --
                local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Theme = toggle_risky and "Risky Text" or "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-3), ZIndex = 6});
                --local toggle_title_shadow = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,14,0,-2), ZIndex = 5});
                -- functions
                local function setstate()
                    toggled = not toggled
                    if toggled then
                        utility.changeobjecttheme(toggle_frame, "Accent")
                        gradient.Visible = true
                    else
                        utility.changeobjecttheme(toggle_frame, "Object Background")
                        gradient.Visible = false
                    end
                    library.flags[toggle_flag] = toggled
                    callback(toggled)
                end;
                --
                holder.MouseButton1Click:Connect(setstate);
                --
                local function set(bool)
                    bool = type(bool) == "boolean" and bool or false
                    if toggled ~= bool then
                        setstate()
                    end;
                end;
                set(toggle_state);
                flags[toggle_flag] = set;
                -- toggle functions
                local toggletypes = {}
                function toggletypes:set(bool)
                    set(bool)
                end;
                --
                function toggletypes:new_colorpicker(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local colorpicker_tbl = {};
    
                    toggle_tbl.colorpickers += 1
    
                    local cp = library.createcolorpicker(default, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                    function colorpicker_tbl:set(color)
                        cp:set(color, false, true)
                    end

                    return colorpicker_tbl
                end;
                --
                return toggletypes;
            end;
            -- create slider
            function section_tbl:new_slider(cfg)
                -- settings
                local slider_tbl = {};
                local name = cfg.name or cfg.Name or "new slider";
                local min = cfg.min or cfg.minimum or 0;
                local max = cfg.max or cfg.maximum or 100;
                local text = cfg.text or ("[value]/"..max);
                local float = cfg.float or 1;
                local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                local flag = cfg.flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                -- drawings
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,20), Thickness = 1, Filled = true, ZIndex = 6});
                --
                local slider_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(1,0,0,5), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,15)}) do
                    local outline = utility.outline(slider_frame, "Section Inner Border");
                    utility.outline(outline, "Section Outer Border");
                end;
                utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = slider_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                --
                local slider_title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,-2,0,-2), ZIndex = 6});
                --local slider_title_shadow = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,-1,0,-1), ZIndex = 5});
                --
                local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                --
                local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                --
                local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                -- functions
                local function set(value)
                    value = math.clamp(utility.round(value, float), min, max)
            
                    slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
            
                    local sizeX = ((value - min) / (max - min))
                    slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
            
                    library.flags[flag] = value
                    callback(value)
                end
            
                set(default)
            
                local sliding = false
            
                local function slide(input)
                    local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                    local value = ((max - min) * sizeX) + min
            
                    set(value)
                end
            
                utility.connect(slider_drag.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        slide(input)
                    end
                end)
            
                utility.connect(slider_drag.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
            
                utility.connect(slider_fill.InputBegan, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                        slide(input)
                    end
                end)
            
                utility.connect(slider_fill.InputEnded, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
            
                utility.connect(services.InputService.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if sliding then
                            slide(input)
                        end
                    end
                end)
            
                flags[flag] = set
            
                function slider_tbl:set(value)
                    set(value)
                end
                --
                return slider_tbl;
            end;
            -- create button
            function section_tbl:new_button(cfg)
                -- settings
                local button_tbl = {};
                local button_name = cfg.name or cfg.Name or "new button";
                local button_confirm = cfg.confirm or cfg.Confirm or false;
                local callback = cfg.callback or cfg.Callback or function() end;
                -- drawings
                local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 6});
                --
                local button_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7}) do
                    local outline = utility.outline(button_frame, "Section Inner Border");
                    utility.outline(outline, "Section Outer Border");
                end;
                local gradient = utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = button_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                --
                local button_title = utility.create("Text", {Text = button_name, Parent = button_frame, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0,0), ZIndex = 8});
                -- functions
                local clicked, counting = false, false
                utility.connect(button_frame.MouseButton1Click, function()
                    task.spawn(function()
                        if button_confirm then
                            if clicked then
                                clicked = false
                                counting = false
                                utility.changeobjecttheme(button_title, "Text")
                                button_title.Text = button_name
                                callback()
                            else
                                clicked = true
                                counting = true
                                for i = 3,1,-1 do
                                    if not counting then
                                        break
                                    end
                                    button_title.Text = 'confirm '..button_name..'? '..tostring(i)
                                    utility.changeobjecttheme(button_title, "Accent")
                                    wait(1)
                                end
                                clicked = false
                                counting = false
                                utility.changeobjecttheme(button_title, "Text")
                                button_title.Text = button_name
                            end
                        else
                            callback()
                        end;
                    end);
                end);
                utility.connect(button_frame.MouseButton1Down, function()
                    utility.changeobjecttheme(button_frame, "Accent")
                end);
                utility.connect(button_frame.MouseButton1Up, function()
                    utility.changeobjecttheme(button_frame, "Object Background")
                end);
            end;
            -- create dropdown
            function section_tbl:new_dropdown(cfg)
                local dropdown_tbl = {};
                local name = cfg.name or cfg.Name or "new dropdown";
                local default = cfg.default or cfg.Default or nil;
                local content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {};
                local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil;
                local scrollable = cfg.scrollable or false;
                local scrollingmax = cfg.scrollingmax or 10;
                local flag = cfg.flag or utility.nextflag();
                local islist = cfg.list or false;
                local size = cfg.size or 100;
                local callback = cfg.callback or function() end;
                if not max and type(default) == "table" then
                    default = nil
                end
                if max and default == nil then
                    default = {}
                end
                if type(default) == "table" then
                    if max then
                        for i, opt in next, default do
                            if not table.find(content, opt) then
                                table.remove(default, i)
                            elseif i > max then
                                table.remove(default, i)
                            end
                        end
                    else
                        default = nil
                    end
                elseif default ~= nil then
                    if not table.find(content, default) then
                        default = nil
                    end
                end
                --
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = islist and size == "Fill" and UDim2.new(1,0,1,0) or islist and UDim2.new(1,0,0,size+15) or UDim2.new(1, 0, 0, 29),Parent = section_content});
                --
                local title = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, -2, 0, -2),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                });
                --
                return library.createdropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, islist, size)
            end;
            -- create keybind
            function section_tbl:new_keybind(cfg)
                local dropdown_tbl = {};
                local name = cfg.name or cfg.Name or "new keybind";
                local key_name = cfg.keybind_name or cfg.KeyBind_Name or name;
                local default = cfg.default or cfg.Default or nil;
                local mode = cfg.mode or cfg.Mode or "Hold";
                local blacklist = cfg.blacklist or cfg.Blacklist or {};
                local flag = cfg.flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                local ignore_list = cfg.ignore or cfg.Ignore or false;
                local key_mode = mode;
                --
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 29),Parent = section_content});
                --
                local title = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, -2, 0, -2),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                });
                --
                if not offset then
                    offset = -1
                end
            
                local keybindname = key_name or "";
            
                local frame = utility.create("Square",{
                    Theme = "Object Background",
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, -15),
                    Filled = true,
                    Parent = holder,
                    Thickness = 1,
                    ZIndex = 8
                })
            
                local outline1 = utility.outline(frame, "Section Inner Border")
                utility.outline(outline1, "Section Outer Border")
                utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});

                local mode_frame = utility.create("Square",{
                    Theme = "Object Background",
                    Size = UDim2.new(0,44,0,35),
                    Position = UDim2.new(1,10,0,-10),
                    Filled = true,
                    Parent = frame,
                    Thickness = 1,
                    ZIndex = 8,
                    Visible = false
                })
            
                local mode_outline1 = utility.outline(mode_frame, "Section Inner Border")
                utility.outline(mode_outline1, "Section Outer Border")
                utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = mode_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});

                local holdtext = utility.create("Text", {
                    Text = "Hold",
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Theme = key_mode == "Hold" and "Accent" or "Text",
                    Position = UDim2.new(0.5,0,0,2),
                    ZIndex = 8,
                    Parent = mode_frame,
                    Outline = false,
                    Center = true
                })
                
                local toggletext = utility.create("Text", {
                    Text = "Toggle",
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Theme = key_mode == "Toggle" and "Accent" or "Text",
                    Position = UDim2.new(0.5,0,0,18),
                    ZIndex = 8,
                    Parent = mode_frame,
                    Outline = false,
                    Center = true
                })

                local holdbutton = utility.create("Square",{
                    Color = Color3.new(0,0,0),
                    Size = UDim2.new(0,44,0,12),
                    Position = UDim2.new(0,0,0,2),
                    Filled = false,
                    Parent = mode_frame,
                    Thickness = 1,
                    ZIndex = 8,
                    Transparency = 0
                })

                local togglebutton = utility.create("Square",{
                    Color = Color3.new(0,0,0),
                    Size = UDim2.new(0,44,0,12),
                    Position = UDim2.new(0,0,0,20),
                    Filled = false,
                    Parent = mode_frame,
                    Thickness = 1,
                    ZIndex = 8,
                    Transparency = 0
                })
            
                local keytext = utility.create("Text", {
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Theme = "Text",
                    Position = UDim2.new(0,2,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false
                })
                holdbutton.MouseButton1Click:Connect(function()
                    key_mode = "Hold"
                    utility.changeobjecttheme(holdtext, "Accent")
                    utility.changeobjecttheme(toggletext, "Text")
                    mode_frame.Visible = false
                end)
                togglebutton.MouseButton1Click:Connect(function()
                    key_mode = "Toggle"
                    utility.changeobjecttheme(holdtext, "Text")
                    utility.changeobjecttheme(toggletext, "Accent")
                    mode_frame.Visible = false
                end)
                local list_obj = nil;
                if ignore_list == false then
                    list_obj = window_key_list:add_keybind(keybindname, keytext.Text)
                end;
                local removetext = utility.create("Text", { -- im lazy to rename everything sorry
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Color = Color3.fromRGB(245,245,245),
                    Position = UDim2.new(1,-20,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false,
                    Text = "...",
                    Transparency = 0.5
                })
            
                local removetext_bold = utility.create("Text", {
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Color = Color3.fromRGB(245,245,245),
                    Position = UDim2.new(1,-21,0,0),
                    ZIndex = 8,
                    Parent = frame,
                    Outline = false,
                    Center = false,
                    Text = "...",
                    Transparency = 0.5
                })
            
                local remove = utility.create("Square", {Filled = true, Position = UDim2.new(1,-20,0,3),Thickness = 1, Transparency = 0, Visible = true, Parent = frame, Size = UDim2.new(0,utility.textlength("x", 2, 13).X + 10, 0, 10), ZIndex = 13});
                remove.MouseButton1Click:Connect(function()
                    mode_frame.Visible = true
                end)
                local key
                local state = false
                local binding
            
                local function set(newkey)
                    if c then
                        c:Disconnect();
                        if flag then
                            library.flags[flag] = false;
                        end
                        callback(false);
                        if ignore_list == false then
                           list_obj:is_active(false)
                        end
                    end
                    if tostring(newkey):find("Enum.KeyCode.") then
                        newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                    elseif tostring(newkey):find("Enum.UserInputType.") then
                        newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                    end
            
                    if newkey ~= nil and not table.find(blacklist, newkey) then
                        key = newkey
            
                        local text = (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
            
                        keytext.Text = text
                        if ignore_list == false then
                            list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                        end
                    else
                        key = nil
            
                        local text = ""
            
                        keytext.Text = text
                        if ignore_list == false then
                            list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                        end
                    end
            
                    if bind ~= '' or bind ~= nil then
                        state = false
                        if flag then
                            library.flags[flag] = state;
                        end
                        callback(false)
                        if ignore_list == false then
                           list_obj:is_active(state)
                        end
                    end
                end
            
                utility.connect(services.InputService.InputBegan, function(inp)
                    if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                        if key_mode == "Hold" then
                            if flag then
                                library.flags[flag] = true
                            end
                            if ignore_list == false then
                               list_obj:is_active(true)
                            end
                            c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                if callback then
                                    callback(true)
                                end
                            end)
                        else
                            state = not state
                            if flag then
                                library.flags[flag] = state;
                            end
                            callback(state)
                            if ignore_list == false then
                               list_obj:is_active(state)
                            end
                        end
                    end
                end)
            
                set(default)
            
                frame.MouseButton1Click:Connect(function()
                    if not binding then
            
                        keytext.Text = "..."
                        
                        binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                            set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                            utility.disconnect(binding)
                            task.wait()
                            binding = nil
                        end)
                    end
                end)
            
                utility.connect(services.InputService.InputEnded, function(inp)
                    if key_mode == "Hold" then
                        if key ~= '' or key ~= nil then
                            if inp.KeyCode == key or inp.UserInputType == key then
                                if c then
                                    c:Disconnect()
                                    if ignore_list == false then
                                       list_obj:is_active(false)
                                    end
                                    if flag then
                                        library.flags[flag] = false;
                                    end
                                    if callback then
                                        callback(false)
                                    end
                                end
                            end
                        end
                    end
                end)
            
                local keybindtypes = {};
            
                function keybindtypes:set(newkey)
                    set(newkey)
                end
            
                return keybindtypes
            end;
            -- create seperator
            function section_tbl:new_seperator(cfg)
                -- settings
                local seperator_text = cfg.name or cfg.Name or "new seperator";
                -- drawings
                local separator = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, 0, 0, 12),Parent = section_content})
                --
                local separatorline = utility.create("Square", {Size = UDim2.new(1, 0, 0, 1),Position = UDim2.new(0, 0, 0.5, 0),Thickness = 0,Filled = true,ZIndex = 7,Theme = "Object Background",Parent = separator})
                --
                local outline = utility.outline(separatorline, "Section Inner Border")
                utility.outline(outline, "Section Outer Border")
                --
                local sizeX = utility.textlength(seperator_text, Drawing.Fonts.Plex, 13).X
                --
                local separatorborder1 = utility.create("Square", {Size = UDim2.new(0, 1, 1, 2),Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -1),Thickness = 0,Filled = true,ZIndex = 9,Theme = "Section Outer Border",Parent = separatorline})
                --
                local separatorborder2 = utility.create("Square", {Size = UDim2.new(0, 1, 1, 2),Position = UDim2.new(0.5, sizeX / 2 + 5, 0, -1),Thickness = 0,Filled = true,ZIndex = 9,Theme = "Section Outer Border",Parent = separatorline})
                --
                local separatorcutoff = utility.create("Square", {Size = UDim2.new(0, sizeX + 12, 0, 5),Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -2),ZIndex = 8,Filled = true,Theme = "Section Background",Parent = separator})
                --
                local text = utility.create("Text", {Text = seperator_text,Font = Drawing.Fonts.Plex,Size = 13,Position = UDim2.new(0.5, 0, 0, -1),Theme = "Text",ZIndex = 9,Outline = false,Center = true,Parent = separator})
            end;
            -- create colorpicker
            function section_tbl:new_colorpicker(cfg)
                local colorpicker_tbl = {}
                local name = cfg.name or cfg.Name or "new colorpicker";
                local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                local flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or function() end;

                local holder = utility.create("Square", {
                    Transparency = 0,
                    Filled = true,
                    Thickness = 1,
                    Size = UDim2.new(1, 0, 0, 10),
                    ZIndex = 7,
                    Parent = section_content
                })

                local title = utility.create("Text", {
                    Text = name,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Position = UDim2.new(0, -1, 0, -1),
                    Theme = "Text",
                    ZIndex = 7,
                    Outline = false,
                    Parent = holder
                })

                local colorpickers = 0

                local colorpickertypes = library.createcolorpicker(default, holder, colorpickers, flag, callback, -2)

                function colorpickertypes:new_colorpicker(cfg)
                    colorpickers = colorpickers + 1
                    local cp_tbl = {}

                    utility.table(cfg)
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local transparency = cfg.allow_alpha or cfg.Allow_Alpha or false;
                    local defaultalpha = cfg.alpha or cfg.Alpha or 1;

                    local cp = library.createcolorpicker(default, transparency, defaultalpha, holder, colorpickers, flag, callback, -2)
                    function cp_tbl:set(color)
                        cp:set(color, false, true)
                    end
                    return cp_tbl
                end

                function colorpicker_tbl:set(color)
                    colorpickertypes:set(color, false, true)
                end
                return colorpicker_tbl
            end;
            -- create textbox
            function section_tbl:new_textbox(cfg)
                -- settings
                local textbox_tbl = {};
                local placeholder = cfg.placeholder or cfg.Placeholder or "new textbox";
                local default = cfg.Default or cfg.default or "";
                local middle = cfg.middle or cfg.Middle or false;
                local flag = cfg.flag or cfg.Flag or utility.nextflag();
                local callback = cfg.callback or function() end;
                -- drawings
                local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 19),Parent = section_content});
                --
                local textbox = utility.create("Square", {
                    Filled = true,
                    Visible = true,
                    Thickness = 0,
                    Theme = "Object Background",
                    Size = UDim2.new(1, 0, 0, 15),
                    Position = UDim2.new(0, 0, 1, -15),
                    ZIndex = 7,
                    Parent = holder
                })
                local outline1 = utility.outline(textbox, "Section Inner Border")
                utility.outline(outline1, "Section Outer Border")
                utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = textbox, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                --
                local text = utility.create("Text", {
                    Text = default,
                    Font = Drawing.Fonts.Plex,
                    Size = 13,
                    Center = middle,
                    Position = middle and UDim2.new(0.5,0,0,0) or UDim2.new(0, 2, 0, 0),
                    Theme = "Text",
                    ZIndex = 9,
                    Outline = false,
                    Parent = textbox
                })
                --
                local placeholder = utility.create("Text", {
                    Text = placeholder,
                    Font = Drawing.Fonts.Plex,
                    Transparency = 0.5,
                    Size = 13,
                    Center = middle,
                    Position = middle and UDim2.new(0.5,0,0,0) or UDim2.new(0, 2, 0, 0),
                    Theme = "Text",
                    ZIndex = 9,
                    Outline = false,
                    Parent = textbox
                })
                -- functions
                library.createbox(textbox, text,  function(str) 
                    if str == "" then
                        placeholder.Visible = true
                        text.Visible = false
                    else
                        placeholder.Visible = false
                        text.Visible = true
                    end
                end, function(str)
                    library.flags[flag] = str
                    callback(str)
                end)

                local function set(str)
                    text.Visible = str ~= ""
                    placeholder.Visible = str == ""
                    text.Text = str
                    library.flags[flag] = str
                    callback(str)
                end

                set(default)

                flags[flag] = set

                function textbox_tbl:Set(str)
                    set(str)
                end

                return textbox_tbl
            end;
            --
            return section_tbl;
        end;
        -- create multisection (i wanna kill myself after doing this)
        function page_tbl:new_section_holder(cfg) -- SHITTIEST METHOD EVER DONT USE!!!!
            -- settings
            local section_tbl = {buttons = {},accents = {},sections = {}};
            local section_name = cfg.name or cfg.Name or "new section";
            local section_side = cfg.side == "left" and left or cfg.Side == "left" and left or cfg.side == "right" and right or cfg.Side == "right" and right or left; -- ignore shit code
            local section_size = cfg.size or cfg.Size or 200;
            -- drawings
            local section = utility.create("Square", {Parent = section_side, Visible = true, Transparency = 1, Theme = "Section Background", Size = section_size ~= "Fill" and UDim2.new(1,0,0,section_size) or UDim2.new(1,0,1,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 5}) do
                local outline = utility.outline(section, "Section Inner Border");
                utility.outline(outline, "Section Outer Border")
            end;
            --
            local section_title_cover = utility.create("Square", {Parent = section, Visible = true, Transparency = 1, Theme = "Window Holder Background", Size = UDim2.new(0,utility.textlength(section_name, Drawing.Fonts.Plex, 13).X + 2,0,4), Position = UDim2.new(0,10,0,-4), Thickness = 1, Filled = true, ZIndex = 5})
            local section_title = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,10,0,-8), ZIndex = 5});
            local section_title_bold = utility.create("Text", {Text = section_name, Parent = section, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,11,0,-8), ZIndex = 5});
            --
            local section_button_holder = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, -20, 0, 30),Position = UDim2.new(0, 10, 0, 10),Parent = section,ZIndex = 6, Thickness = 1, Filled = true});
            -- create sections
            function section_tbl:new_section(cfg)
                local name = cfg.name or cfg.Name or "new section";
                -- drawings
                local multi_button = utility.create("Square", {Parent = section_button_holder, Visible = true, Transparency = 1, Theme = "Page Unselected", Size = UDim2.new(0,0,0,0), Position = UDim2.new(0,0,0,0), Thickness = 1, Filled = true, ZIndex = 7}) do
                    local outline = utility.outline(multi_button, "Window Border");
                    table.insert(section_tbl.buttons, multi_button);
                    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = multi_button, Size = UDim2.new(1,0,1,0), ZIndex = 7});
                end;
                --
                local multi_title = utility.create("Text", {Text = name, Parent = multi_button, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0,8), ZIndex = 7});
                --
                local multi_button_accent = utility.create("Square", {Parent = multi_button, Visible = false, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,0,1), Position = UDim2.new(0,0,0,1), Thickness = 1, Filled = true, ZIndex = 7}) do
                    table.insert(section_tbl.accents, multi_button_accent);
                end;
                --
                local section_content = utility.create("Square", {Visible = false, Transparency = 0,Size = UDim2.new(1, -32, 1, -50),Position = UDim2.new(0, 16, 0, 50),Parent = section,ZIndex = 6, Thickness = 1, Filled = false}) do
                    table.insert(section_tbl.sections, section_content)
                end;
                section_content:AddListLayout(8)
                -- update size
                for _,v in next, section_tbl.buttons do
                    v.Size = UDim2.new(1 / #section_tbl.buttons, _ == 1 and 1 or _ == #section_tbl.buttons and -2 or -1, 1, 0);
                    v.Position = UDim2.new(1 / (#section_tbl.buttons / (_ - 1)), _ == 1 and 0 or 2, 0, 0);
                end;
                -- functions
                utility.connect(multi_button.MouseButton1Click, function() -- ignore
                    for i,v in next, section_tbl.buttons do
                        if v ~= multi_button then
                            utility.changeobjecttheme(v, "Page Unselected");
                        end;
                    end;
                    --
                    for i,v in next, section_tbl.accents do
                        if v ~= multi_button_accent then
                            v.Visible = false;
                        end;
                    end;
                    --
                    for i,v in next, section_tbl.sections do
                        if v ~= section_content then
                            v.Visible = false;
                        end;
                    end;
                    --
                    utility.changeobjecttheme(multi_button, "Page Selected");
                    multi_button_accent.Visible = true;
                    section_content.Visible = true;
                end);
                local multi_section_tbl = {};
                --
                function multi_section_tbl:open()
                    utility.changeobjecttheme(multi_button, "Page Selected");
                    multi_button_accent.Visible = true;
                    section_content.Visible = true;
                end;
                -- create toggle
                function multi_section_tbl:new_toggle(cfg)
                    -- settings
                    local toggle_tbl = {colorpickers = 0};
                    local toggle_name = cfg.name or cfg.Name or "new toggle";
                    local toggle_risky = cfg.risky or cfg.Risky or false;
                    local toggle_state = cfg.state or cfg.State or false;
                    local toggle_flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or cfg.Callback or function() end;
                    local toggled = false;
                    -- drawings
                    local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,8), Thickness = 1, Filled = true, ZIndex = 8});
                    --
                    local toggle_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(0,8,0,8), Thickness = 1, Filled = true, ZIndex = 7}) do
                        local outline = utility.outline(toggle_frame, "Section Inner Border");
                        utility.outline(outline, "Section Outer Border");
                    end;
                    local gradient = utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = false, Parent = toggle_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                    --
                    local toggle_title = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Theme = toggle_risky and "Risky Text" or "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,13,0,-3), ZIndex = 6});
                    --local toggle_title_shadow = utility.create("Text", {Text = toggle_name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,14,0,-2), ZIndex = 5});
                    -- functions
                    local function setstate()
                        toggled = not toggled
                        if toggled then
                            utility.changeobjecttheme(toggle_frame, "Accent")
                            gradient.Visible = true
                        else
                            utility.changeobjecttheme(toggle_frame, "Object Background")
                            gradient.Visible = false
                        end
                        library.flags[toggle_flag] = toggled
                        callback(toggled)
                    end;
                    --
                    holder.MouseButton1Click:Connect(setstate);
                    --
                    local function set(bool)
                        bool = type(bool) == "boolean" and bool or false
                        if toggled ~= bool then
                            setstate()
                        end;
                    end;
                    set(toggle_state);
                    flags[toggle_flag] = set;
                    -- toggle functions
                    local toggletypes = {}
                    function toggletypes:set(bool)
                        set(bool)
                    end;
                    --
                    function toggletypes:new_colorpicker(cfg)
                        local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                        local flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local colorpicker_tbl = {};
        
                        toggle_tbl.colorpickers += 1
        
                        local cp = library.createcolorpicker(default, holder, toggle_tbl.colorpickers - 1, flag, callback, -4)
                        function colorpicker_tbl:set(color)
                            cp:set(color, false, true)
                        end
    
                        return colorpicker_tbl
                    end;
                    --
                    return toggletypes;
                end;
                -- create slider
                function multi_section_tbl:new_slider(cfg)
                    -- settings
                    local slider_tbl = {};
                    local name = cfg.name or cfg.Name or "new slider";
                    local min = cfg.min or cfg.minimum or 0;
                    local max = cfg.max or cfg.maximum or 100;
                    local text = cfg.text or ("[value]/"..max);
                    local float = cfg.float or 1;
                    local default = cfg.default and math.clamp(cfg.default, min, max) or min;
                    local flag = cfg.flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    -- drawings
                    local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,20), Thickness = 1, Filled = true, ZIndex = 6});
                    --
                    local slider_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(1,0,0,5), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,15)}) do
                        local outline = utility.outline(slider_frame, "Section Inner Border");
                        utility.outline(outline, "Section Outer Border");
                    end;
                    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = slider_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                    --
                    local slider_title = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,-2,0,-2), ZIndex = 6});
                    --local slider_title_shadow = utility.create("Text", {Text = name, Parent = holder, Visible = true, Transparency = 1, Color = Color3.new(0,0,0), Size = 13, Center = false, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0,-1,0,-1), ZIndex = 5});
                    --
                    local slider_value = utility.create("Text", {Text = text, Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = true, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0.5,-6), ZIndex = 8});
                    --
                    local slider_fill = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 1, Theme = "Accent", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7, Position = UDim2.new(0,0,0,0)});
                    --
                    local slider_drag = utility.create("Square", {Parent = slider_frame, Visible = true, Transparency = 0, Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 8, Position = UDim2.new(0,0,0,0)});
                    -- functions
                    local function set(value)
                        value = math.clamp(utility.round(value, float), min, max)
                
                        slider_value.Text = text:gsub("%[value%]", string.format("%.14g", value))
                
                        local sizeX = ((value - min) / (max - min))
                        slider_fill.Size = UDim2.new(sizeX, 0, 1, 0)
                
                        library.flags[flag] = value
                        callback(value)
                    end
                
                    set(default)
                
                    local sliding = false
                
                    local function slide(input)
                        local sizeX = (input.Position.X - slider_frame.AbsolutePosition.X) / slider_frame.AbsoluteSize.X
                        local value = ((max - min) * sizeX) + min
                
                        set(value)
                    end
                
                    utility.connect(slider_drag.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            slide(input)
                        end
                    end)
                
                    utility.connect(slider_drag.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                
                    utility.connect(slider_fill.InputBegan, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = true
                            slide(input)
                        end
                    end)
                
                    utility.connect(slider_fill.InputEnded, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            sliding = false
                        end
                    end)
                
                    utility.connect(services.InputService.InputChanged, function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            if sliding then
                                slide(input)
                            end
                        end
                    end)
                
                    flags[flag] = set
                
                    function slider_tbl:set(value)
                        set(value)
                    end
                    --
                    return slider_tbl;
                end;
                -- create button
                function multi_section_tbl:new_button(cfg)
                    -- settings
                    local button_tbl = {};
                    local button_name = cfg.name or cfg.Name or "new button";
                    local button_confirm = cfg.confirm or cfg.Confirm or false;
                    local callback = cfg.callback or cfg.Callback or function() end;
                    -- drawings
                    local holder = utility.create("Square", {Parent = section_content, Visible = true, Transparency = 0, Size = UDim2.new(1,0,0,15), Thickness = 1, Filled = true, ZIndex = 6});
                    --
                    local button_frame = utility.create("Square", {Parent = holder, Visible = true, Transparency = 1, Theme = "Object Background", Size = UDim2.new(1,0,1,0), Thickness = 1, Filled = true, ZIndex = 7}) do
                        local outline = utility.outline(button_frame, "Section Inner Border");
                        utility.outline(outline, "Section Outer Border");
                    end;
                    local gradient = utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = button_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                    --
                    local button_title = utility.create("Text", {Text = button_name, Parent = button_frame, Visible = true, Transparency = 1, Theme = "Text", Size = 13, Center = true, Outline = false, Font = Drawing.Fonts.Plex, Position = UDim2.new(0.5,0,0,0), ZIndex = 8});
                    -- functions
                    local clicked, counting = false, false
                    utility.connect(button_frame.MouseButton1Click, function()
                        task.spawn(function()
                            if button_confirm then
                                if clicked then
                                    clicked = false
                                    counting = false
                                    utility.changeobjecttheme(button_title, "Text")
                                    button_title.Text = button_name
                                    callback()
                                else
                                    clicked = true
                                    counting = true
                                    for i = 3,1,-1 do
                                        if not counting then
                                            break
                                        end
                                        button_title.Text = 'confirm '..button_name..'? '..tostring(i)
                                        utility.changeobjecttheme(button_title, "Accent")
                                        wait(1)
                                    end
                                    clicked = false
                                    counting = false
                                    utility.changeobjecttheme(button_title, "Text")
                                    button_title.Text = button_name
                                end
                            else
                                callback()
                            end;
                        end);
                    end);
                    utility.connect(button_frame.MouseButton1Down, function()
                        utility.changeobjecttheme(button_frame, "Accent")
                    end);
                    utility.connect(button_frame.MouseButton1Up, function()
                        utility.changeobjecttheme(button_frame, "Object Background")
                    end);
                end;
                -- create dropdown
                function multi_section_tbl:new_dropdown(cfg)
                    local dropdown_tbl = {};
                    local name = cfg.name or cfg.Name or "new dropdown";
                    local default = cfg.default or cfg.Default or nil;
                    local content = type(cfg.options or cfg.Options) == "table" and cfg.options or cfg.Options or {};
                    local max = cfg.max or cfg.Max and (cfg.max > 1 and cfg.max) or nil;
                    local scrollable = cfg.scrollable or false;
                    local scrollingmax = cfg.scrollingmax or 10;
                    local flag = cfg.flag or utility.nextflag();
                    local islist = cfg.list or false;
                    local size = cfg.size or 100;
                    local callback = cfg.callback or function() end;
                    if not max and type(default) == "table" then
                        default = nil
                    end
                    if max and default == nil then
                        default = {}
                    end
                    if type(default) == "table" then
                        if max then
                            for i, opt in next, default do
                                if not table.find(content, opt) then
                                    table.remove(default, i)
                                elseif i > max then
                                    table.remove(default, i)
                                end
                            end
                        else
                            default = nil
                        end
                    elseif default ~= nil then
                        if not table.find(content, default) then
                            default = nil
                        end
                    end
                    --
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = islist and size == "Fill" and UDim2.new(1,0,1,0) or islist and UDim2.new(1,0,0,size+15) or UDim2.new(1, 0, 0, 29),Parent = section_content});
                    --
                    local title = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, -2, 0, -2),
                        Theme = "Text",
                        ZIndex = 7,
                        Outline = false,
                        Parent = holder
                    });
                    --
                    return library.createdropdown(holder, content, flag, callback, default, max, scrollable, scrollingmax, islist, size)
                end;
                -- create keybind
                function multi_section_tbl:new_keybind(cfg)
                    local dropdown_tbl = {};
                    local name = cfg.name or cfg.Name or "new keybind";
                    local key_name = cfg.keybind_name or cfg.KeyBind_Name or name;
                    local default = cfg.default or cfg.Default or nil;
                    local mode = cfg.mode or cfg.Mode or "Hold";
                    local blacklist = cfg.blacklist or cfg.Blacklist or {};
                    local flag = cfg.flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    local ignore_list = cfg.ignore or cfg.Ignore or false;
                    local key_mode = mode;
                    --
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 29),Parent = section_content});
                    --
                    local title = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, -2, 0, -2),
                        Theme = "Text",
                        ZIndex = 7,
                        Outline = false,
                        Parent = holder
                    });
                    --
                    if not offset then
                        offset = -1
                    end
                
                    local keybindname = key_name or "";
                
                    local frame = utility.create("Square",{
                        Theme = "Object Background",
                        Size = UDim2.new(1, 0, 0, 15),
                        Position = UDim2.new(0, 0, 1, -15),
                        Filled = true,
                        Parent = holder,
                        Thickness = 1,
                        ZIndex = 8
                    })
                
                    local outline1 = utility.outline(frame, "Section Inner Border")
                    utility.outline(outline1, "Section Outer Border")
                    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
    
                    local mode_frame = utility.create("Square",{
                        Theme = "Object Background",
                        Size = UDim2.new(0,44,0,35),
                        Position = UDim2.new(1,10,0,-10),
                        Filled = true,
                        Parent = frame,
                        Thickness = 1,
                        ZIndex = 8,
                        Visible = false
                    })
                
                    local mode_outline1 = utility.outline(mode_frame, "Section Inner Border")
                    utility.outline(mode_outline1, "Section Outer Border")
                    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = mode_frame, Size = UDim2.new(1,0,1,0), ZIndex = 8});
    
                    local holdtext = utility.create("Text", {
                        Text = "Hold",
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Theme = key_mode == "Hold" and "Accent" or "Text",
                        Position = UDim2.new(0.5,0,0,2),
                        ZIndex = 8,
                        Parent = mode_frame,
                        Outline = false,
                        Center = true
                    })
                    
                    local toggletext = utility.create("Text", {
                        Text = "Toggle",
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Theme = key_mode == "Toggle" and "Accent" or "Text",
                        Position = UDim2.new(0.5,0,0,18),
                        ZIndex = 8,
                        Parent = mode_frame,
                        Outline = false,
                        Center = true
                    })
    
                    local holdbutton = utility.create("Square",{
                        Color = Color3.new(0,0,0),
                        Size = UDim2.new(0,44,0,12),
                        Position = UDim2.new(0,0,0,2),
                        Filled = false,
                        Parent = mode_frame,
                        Thickness = 1,
                        ZIndex = 8,
                        Transparency = 0
                    })
    
                    local togglebutton = utility.create("Square",{
                        Color = Color3.new(0,0,0),
                        Size = UDim2.new(0,44,0,12),
                        Position = UDim2.new(0,0,0,20),
                        Filled = false,
                        Parent = mode_frame,
                        Thickness = 1,
                        ZIndex = 8,
                        Transparency = 0
                    })
                
                    local keytext = utility.create("Text", {
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Theme = "Text",
                        Position = UDim2.new(0,2,0,0),
                        ZIndex = 8,
                        Parent = frame,
                        Outline = false,
                        Center = false
                    })
                    holdbutton.MouseButton1Click:Connect(function()
                        key_mode = "Hold"
                        utility.changeobjecttheme(holdtext, "Accent")
                        utility.changeobjecttheme(toggletext, "Text")
                        mode_frame.Visible = false
                    end)
                    togglebutton.MouseButton1Click:Connect(function()
                        key_mode = "Toggle"
                        utility.changeobjecttheme(holdtext, "Text")
                        utility.changeobjecttheme(toggletext, "Accent")
                        mode_frame.Visible = false
                    end)
                    local list_obj = nil;
                    if ignore_list == false then
                        list_obj = window_key_list:add_keybind(keybindname, keytext.Text)
                    end;
                    local removetext = utility.create("Text", { -- im lazy to rename everything sorry
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Color = Color3.fromRGB(245,245,245),
                        Position = UDim2.new(1,-20,0,0),
                        ZIndex = 8,
                        Parent = frame,
                        Outline = false,
                        Center = false,
                        Text = "...",
                        Transparency = 0.5
                    })
                
                    local removetext_bold = utility.create("Text", {
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Color = Color3.fromRGB(245,245,245),
                        Position = UDim2.new(1,-21,0,0),
                        ZIndex = 8,
                        Parent = frame,
                        Outline = false,
                        Center = false,
                        Text = "...",
                        Transparency = 0.5
                    })
                
                    local remove = utility.create("Square", {Filled = true, Position = UDim2.new(1,-20,0,3),Thickness = 1, Transparency = 0, Visible = true, Parent = frame, Size = UDim2.new(0,utility.textlength("x", 2, 13).X + 10, 0, 10), ZIndex = 13});
                    remove.MouseButton1Click:Connect(function()
                        mode_frame.Visible = true
                    end)
                    local key
                    local state = false
                    local binding
                
                    local function set(newkey)
                        if c then
                            c:Disconnect();
                            if flag then
                                library.flags[flag] = false;
                            end
                            callback(false);
                            if ignore_list == false then
                               list_obj:is_active(false)
                            end
                        end
                        if tostring(newkey):find("Enum.KeyCode.") then
                            newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                        elseif tostring(newkey):find("Enum.UserInputType.") then
                            newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                        end
                
                        if newkey ~= nil and not table.find(blacklist, newkey) then
                            key = newkey
                
                            local text = (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", ""))
                
                            keytext.Text = text
                            if ignore_list == false then
                                list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                            end
                        else
                            key = nil
                
                            local text = ""
                
                            keytext.Text = text
                            if ignore_list == false then
                                list_obj:update_text(tostring(keybindname.." ["..text.."]"))
                            end
                        end
                
                        if bind ~= '' or bind ~= nil then
                            state = false
                            if flag then
                                library.flags[flag] = state;
                            end
                            callback(false)
                            if ignore_list == false then
                               list_obj:is_active(state)
                            end
                        end
                    end
                
                    utility.connect(services.InputService.InputBegan, function(inp)
                        if (inp.KeyCode == key or inp.UserInputType == key) and not binding then
                            if key_mode == "Hold" then
                                if flag then
                                    library.flags[flag] = true
                                end
                                if ignore_list == false then
                                   list_obj:is_active(true)
                                end
                                c = utility.connect(game:GetService("RunService").RenderStepped, function()
                                    if callback then
                                        callback(true)
                                    end
                                end)
                            else
                                state = not state
                                if flag then
                                    library.flags[flag] = state;
                                end
                                callback(state)
                                if ignore_list == false then
                                   list_obj:is_active(state)
                                end
                            end
                        end
                    end)
                
                    set(default)
                
                    frame.MouseButton1Click:Connect(function()
                        if not binding then
                
                            keytext.Text = "..."
                            
                            binding = utility.connect(services.InputService.InputBegan, function(input, gpe)
                                set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
                                utility.disconnect(binding)
                                task.wait()
                                binding = nil
                            end)
                        end
                    end)
                
                    utility.connect(services.InputService.InputEnded, function(inp)
                        if key_mode == "Hold" then
                            if key ~= '' or key ~= nil then
                                if inp.KeyCode == key or inp.UserInputType == key then
                                    if c then
                                        c:Disconnect()
                                        if ignore_list == false then
                                           list_obj:is_active(false)
                                        end
                                        if flag then
                                            library.flags[flag] = false;
                                        end
                                        if callback then
                                            callback(false)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                
                    local keybindtypes = {};
                
                    function keybindtypes:set(newkey)
                        set(newkey)
                    end
                
                    return keybindtypes
                end;
                -- create seperator
                function multi_section_tbl:new_seperator(cfg)
                    -- settings
                    local seperator_text = cfg.name or cfg.Name or "new seperator";
                    -- drawings
                    local separator = utility.create("Square", {Transparency = 0,Size = UDim2.new(1, 0, 0, 12),Parent = section_content})
                    --
                    local separatorline = utility.create("Square", {Size = UDim2.new(1, 0, 0, 1),Position = UDim2.new(0, 0, 0.5, 0),Thickness = 0,Filled = true,ZIndex = 7,Theme = "Object Background",Parent = separator})
                    --
                    local outline = utility.outline(separatorline, "Section Inner Border")
                    utility.outline(outline, "Section Outer Border")
                    --
                    local sizeX = utility.textlength(seperator_text, Drawing.Fonts.Plex, 13).X
                    --
                    local separatorborder1 = utility.create("Square", {Size = UDim2.new(0, 1, 1, 2),Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -1),Thickness = 0,Filled = true,ZIndex = 9,Theme = "Section Outer Border",Parent = separatorline})
                    --
                    local separatorborder2 = utility.create("Square", {Size = UDim2.new(0, 1, 1, 2),Position = UDim2.new(0.5, sizeX / 2 + 5, 0, -1),Thickness = 0,Filled = true,ZIndex = 9,Theme = "Section Outer Border",Parent = separatorline})
                    --
                    local separatorcutoff = utility.create("Square", {Size = UDim2.new(0, sizeX + 12, 0, 5),Position = UDim2.new(0.5, (-sizeX / 2) - 7, 0.5, -2),ZIndex = 8,Filled = true,Theme = "Section Background",Parent = separator})
                    --
                    local text = utility.create("Text", {Text = seperator_text,Font = Drawing.Fonts.Plex,Size = 13,Position = UDim2.new(0.5, 0, 0, -1),Theme = "Text",ZIndex = 9,Outline = false,Center = true,Parent = separator})
                end;
                -- create colorpicker
                function multi_section_tbl:new_colorpicker(cfg)
                    local colorpicker_tbl = {}
                    local name = cfg.name or cfg.Name or "new colorpicker";
                    local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
    
                    local holder = utility.create("Square", {
                        Transparency = 0,
                        Filled = true,
                        Thickness = 1,
                        Size = UDim2.new(1, 0, 0, 10),
                        ZIndex = 7,
                        Parent = section_content
                    })
    
                    local title = utility.create("Text", {
                        Text = name,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Position = UDim2.new(0, -1, 0, -1),
                        Theme = "Text",
                        ZIndex = 7,
                        Outline = false,
                        Parent = holder
                    })
    
                    local colorpickers = 0
    
                    local colorpickertypes = library.createcolorpicker(default, holder, colorpickers, flag, callback, -2)
    
                    function colorpickertypes:new_colorpicker(cfg)
                        colorpickers = colorpickers + 1
                        local cp_tbl = {}
    
                        utility.table(cfg)
                        local default = cfg.default or cfg.Default or Color3.fromRGB(255, 0, 0);
                        local flag = cfg.flag or cfg.Flag or utility.nextflag();
                        local callback = cfg.callback or function() end;
                        local transparency = cfg.allow_alpha or cfg.Allow_Alpha or false;
                        local defaultalpha = cfg.alpha or cfg.Alpha or 1;
    
                        local cp = library.createcolorpicker(default, transparency, defaultalpha, holder, colorpickers, flag, callback, -2)
                        function cp_tbl:set(color)
                            cp:set(color, false, true)
                        end
                        return cp_tbl
                    end
    
                    function colorpicker_tbl:set(color)
                        colorpickertypes:set(color, false, true)
                    end
                    return colorpicker_tbl
                end;
                -- create textbox
                function multi_section_tbl:new_textbox(cfg)
                    -- settings
                    local textbox_tbl = {};
                    local placeholder = cfg.placeholder or cfg.Placeholder or "new textbox";
                    local default = cfg.Default or cfg.default or "";
                    local middle = cfg.middle or cfg.Middle or false;
                    local flag = cfg.flag or cfg.Flag or utility.nextflag();
                    local callback = cfg.callback or function() end;
                    -- drawings
                    local holder = utility.create("Square", {Transparency = 0, ZIndex = 7,Size = UDim2.new(1, 0, 0, 19),Parent = section_content});
                    --
                    local textbox = utility.create("Square", {
                        Filled = true,
                        Visible = true,
                        Thickness = 0,
                        Theme = "Object Background",
                        Size = UDim2.new(1, 0, 0, 15),
                        Position = UDim2.new(0, 0, 1, -15),
                        ZIndex = 7,
                        Parent = holder
                    })
                    local outline1 = utility.outline(textbox, "Section Inner Border")
                    utility.outline(outline1, "Section Outer Border")
                    utility.create("Image", {Data = library.gradient, Transparency = 0.5, Visible = true, Parent = textbox, Size = UDim2.new(1,0,1,0), ZIndex = 8});
                    --
                    local text = utility.create("Text", {
                        Text = default,
                        Font = Drawing.Fonts.Plex,
                        Size = 13,
                        Center = middle,
                        Position = middle and UDim2.new(0.5,0,0,0) or UDim2.new(0, 2, 0, 0),
                        Theme = "Text",
                        ZIndex = 9,
                        Outline = false,
                        Parent = textbox
                    })
                    --
                    local placeholder = utility.create("Text", {
                        Text = placeholder,
                        Font = Drawing.Fonts.Plex,
                        Transparency = 0.5,
                        Size = 13,
                        Center = middle,
                        Position = middle and UDim2.new(0.5,0,0,0) or UDim2.new(0, 2, 0, 0),
                        Theme = "Text",
                        ZIndex = 9,
                        Outline = false,
                        Parent = textbox
                    })
                    -- functions
                    library.createbox(textbox, text,  function(str) 
                        if str == "" then
                            placeholder.Visible = true
                            text.Visible = false
                        else
                            placeholder.Visible = false
                            text.Visible = true
                        end
                    end, function(str)
                        library.flags[flag] = str
                        callback(str)
                    end)
    
                    local function set(str)
                        text.Visible = str ~= ""
                        placeholder.Visible = str == ""
                        text.Text = str
                        library.flags[flag] = str
                        callback(str)
                    end
    
                    set(default)
    
                    flags[flag] = set
    
                    function textbox_tbl:Set(str)
                        set(str)
                    end
    
                    return textbox_tbl
                end;
                --
                return multi_section_tbl;
            end;
            return section_tbl;
        end;
        --
        return page_tbl;
    end;
    --
    function window_tbl:set_keybind_list_visibility(state)
        window_key_list:set_visible(state);
    end;
    --
    function window_tbl:get_config()
        local configtbl = {}

        for flag, _ in next, flags do
            if not table.find(configignores, flag) then
                local value = library.flags[flag]

                if typeof(value) == "EnumItem" then
                    configtbl[flag] = tostring(value)
                elseif typeof(value) == "Color3" then
                    configtbl[flag] = value:ToHex()
                else
                    configtbl[flag] = value
                end
            end
        end

        local config = game:GetService("HttpService"):JSONEncode(configtbl)
        --
        return config
    end;
    --
    return window_tbl;
end;
return library;
