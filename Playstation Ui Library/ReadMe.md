## Documentation / Example
```lua
local Link = loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Playstation%20Ui%20Library/Source'))()

local Win = Link:CreateWindow('Name','Yeah Info') -- :CreateWindow(Title,Info) Note: info no space

local Tab = Win:addPage('Tab', 2, true, 6) -- :addPage(Title, Scoll Size, Visible, elementspacing)
-- Note: Dont have update function


-- Label
Tab:addLabel('This a Label', 'Label info') -- :addLabel(Title, Info)

-- Button
Tab:addButton('This a button', function() -- :addButton(Title, callback)
    print('Clicked Button')
end)

-- Toggles
Tab:addToggle('Toggle', function(value) -- :addToggle(Title, callback)
    if value then -- if true then
        print('True') -- print true
    else -- else false
        print('False') -- print false
    end
end)

-- Slider
Tab:addSlider('Slider', 1,100, function(value) -- :addSlider(Title, min, max, callback)
    print(value)
end)

-- TextBox
Tab:addTextBox('Textbox', 'Textbox Info', function(text) -- :addTextBox(Title, Info)
    print(text)
end)

-- Dropdown
Tab:addDropdown('This is DropDown', {'1', '2', '3', '4', '5'}, 4, function(options) -- :addDropdown(Title, {'List', 'Yeah'}, Scroll Size, callback)
    print(options)
end)
```

**Very HOT!**
