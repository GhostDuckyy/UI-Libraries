local Window = Library:new({textsize = number, font = enum, name = string, color = color3})

local Tab = Window:page({name = string})

local Section1 = Tab:section({name = string, side = string, size = number})

local Multisection = Tab:multisection({name = string, side = string, size = number})

local Section2 = Multisection:section({name = string, side = string, size = number})

Section1:toggle({name = string, def = bool, callback = function})

Section1:button({name = string, callback = function})

Section1:slider({name = string, def = number, max = number, min = number, rounding = bool, ticking = bool, measuring = string, callback = function})

Section1:dropdown({name = string, def = string, max = number, options = array, callback = function})
-- For dropdowns, put max to the number of items you have in the options.

Section1:buttonbox({name = string, def = string, max = number, options = array, callback = function})

Section1:multibox({name = string, def = array, max = number, options = array, callback = function})

Section1:textbox({name = string, def = string, placeholder = string, callback = function})

Section1:keybind({name = string, def = type, callback = function})

local Picker = Section1:colorpicker({name = string, cpname = type, def = color3, callback = function})
