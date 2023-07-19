# ReadMe

## Preview
![a](https://github.com/GhostDuckyy/UI-Libraries/blob/main/Gerad's/image.png?raw=true)
## Documentation
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Gerad's/source.lua"))()

local Window = Library:CreateWindow('Gerad') -- :CreateWindow(Title)

local Section = Window:Section('Am Section') -- :Section(Title)

-- Label
Section:Label('Yeah just label') -- :Label(Text)

-- Button
Section:Button('Button', function() -- :Button(Title, callback)
    print('Clicked Button')
end)

-- Toggle
Section:Toggle('Toggles', {flag = 'Toggle'},function(value) -- :Toggle(Title, callback)
    if value then -- if true then
        print('True') -- print true
    else -- else false
        print('False') -- print false
    end
end)

-- Slider?
Section:Slider('Slider', {flag = 'Slider'; Min = 100; Max = 0; Default = 0 ; Precise = false}, function(val) -- :Slider(Title, {info; Min; Max; Default; Precise = true/false}, callback)
    print(val)
end)

-- Textbox
Section:Box('Textbox', {flag = 'Box'}, function(txt) -- :Box(Title, {info}, callback)
    print(tostring(txt))
end)

-- Dropdown
Section:Dropdown('Dropdown', {flag = 'DROP', list = {'1', '2', '3', '4', '5'}, Type = 'Toggle'}, function(options) -- :Dropdown(Title, (info, list, Type = 'Toggle'), callback)
    print(options)
end)

-- Bind
Section:Bind('Bind', {flag = 'BIND'}, function() -- :Bind(Title, {info}, callback)
    print('Tapped Bind')
end)

-- Colorpicker
Section:ColorPicker('Color', {flag = 'PICKER'}, function(clr) -- :ColorPicker(Title, {info}, callback)
    print(clr)
end)

-- Print status
Section:Button('Status', function()
    print('Toggle - ',Library.flags.Toggle)
    print('Slider - ',Library.flags.Slider)
    print('TxtBox - ',Library.flags.Box)
    print('Dropdown - ',Library.flags.DROP)
    print('Bind - ',Library.flags.BIND)
    print('ColorPicker - ',Library.flags.PICKER)
end)
```
