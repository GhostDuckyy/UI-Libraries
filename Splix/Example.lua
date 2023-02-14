local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/insanedude59/SplixUiLib/main/Main"))()

local window = library:new({textsize = 13.5,font = Enum.Font.RobotoMono,name = "YES",color = Color3.fromRGB(225,58,81)})

local tab = window:page({name = "YES2"})

local section1 = tab:section({name = "section1",side = "left",size = 250})

local multisection = tab:multisection({name = "multisection",side = "right",size = 250})

local section2 = multisection:section({name = "section2",side = "right",size = 100})

section1:toggle({name = "toggle",def = false,callback = function(value)
  tog = value
  print(tog)
end})

section1:button({name = "button",callback = function()
   print('hot ui lib')
end})

section1:slider({name = "rate ui lib 1-100",def = 1, max = 100,min = 1,rounding = true,ticking = false,measuring = "",callback = function(value)
   print(value)
end})

section1:dropdown({name = "dropdown",def = "",max = 10,options = {"1","2","3","4","5","6","7","8","9","10"},callback = function(chosen)
   print(chosen)
end})
-- for dropdowns put max to the number of items u have in the opions

section1:buttonbox({name = "buttonbox",def = "",max = 4, options = {"yoyoyo","yo2","yo3","yo4"},callback = function(value)
   print(value)
end})


section1:multibox({name = "multibox",def = {}, max = 4,options = {"1","2","3","4"},callback = function(value)
   print(value)
end})

section1:textbox({name = "textbox",def = "default text",placeholder = "Enter WalkSpeed",callback = function(value)
   print(value)
end})

section1:keybind({name = "set ui keybind",def = nil,callback = function(key)
   window.key = key
end})

local picker = section1:colorpicker({name = "color",cpname = nil,def = Color3.fromRGB(255,255,255),callback = function(value)
   color = value
end})
