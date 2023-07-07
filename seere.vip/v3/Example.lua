--[[LEAKED BY FIJI https://v3rmillion.net/showthread.php?tid=1208282 ]]

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/0f76/seere_v3/main/UI/Library.lua'))()

local window = library:new({name = "Seere", sub = " v3", offset = 0, size = Vector2.new(600, 650)})
local pages = {
    ["main"] = window:page({name = "Main", default = true})
}
local section = pages.main:section({name = "Section", side = "left", size = 400})
section:toggle({name = "Test toggle", risky = false, state = false, flag = "test_toggle", callback = function() end})
section:divider({name = "Divider"})
section:slider({name = "Slider", min = 1, max = 100, suffix = "%", float = 1, default = 50, flag = "testSlider"})
section:dropdown({name = "Dropdown", options = {"Option 1", "Option 2", "Option 3"}, default = "Option 1", max = 1, scrollable = true, scrollingmax = 5, flag = "dropdown_test"})
section:multibox({name = "Multibox", options = {"Option 1", "Option 2", "Option 3"}, default = "Option 1", max = 2, scrollable = true, scrollingmax = 5, flag = "multibox_test"})
section:button({name = "Button", confirm = false, callback = function() end})
section:colorpicker({name = "Menu Accent", default = Color3.fromRGB(117, 163, 125), tooltip = true, flag = "colorpicker_test", callback = function(val)
    library:change_theme_color("Accent", val)
end})
section:keybind({name = "Menu Keybind", default = Enum.KeyCode.End, mode = "Toggle", blacklist = {}, flag = "keybind_test", callback = function(state)
    library:set_open(not state)
end})
section:textbox({placeholder = "Placeholder", default = "", middle = true, flag = "textbox_test"})
local multisection = pages.main:multisection({name = "Multisection", side = "right"})
multisection:section({name = "one", default = true}):toggle({name = "lol", risky = true, state = false, flag = "second_toggle", callback = function() end})
multisection:section({name = "two", default = false})
library:notify({text = "loaded", time = 5})
library:set_open(true)
