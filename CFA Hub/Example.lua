local uilibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kiet1308/tvkhub/main/rac"))()
local windowz = uilibrary:CreateWindow("UI Library", "Game Name", true)

local Page1 = windowz:CreatePage("Page I")


local Section1 = Page1:CreateSection("Section Name")

Section1:CreateSlider("Slider Example", {Min = 16, Max = 500, DefaultValue = 30}, function(Value)
   print(Value)
end)

Section1:CreateToggle("Toggle Example", {Toggled=false , Description = false}, function(Value)
   print(Value)
end)

Section1:CreateButton("Button Example", function ()
   print("Button Cliked!")
end)

Section1:CreateTextbox("TextBox", false, function (vv)
   print(vv)
end)

Section1:CreateDropdown("Dropdown ", {
   List = {"Value1", "Value2", "Value3", "Value4"},
   Default = "None"}, function(value)
       print(value)
end)

Section1:CreateColorPicker("Color Picker", Color3.fromRGB(255, 255, 255), function ()
   print("fsf")
end)

local dropdown = Section1:CreateDropdown("Refresh Dropdown ", {
   List = {"Value1", "Value2", "Value3", "Value4"},
   Default = "None"}, function(value)
       print(value)
end)



Section1:CreateButton("Refresh Example", function ()
   local newlist = {"resf", "uwua", "fsk"}
   dropdown:Clear()
   wait(1)
   dropdown:Add(newlist)
end)
