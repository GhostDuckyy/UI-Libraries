--
-- THIS DOCUMENTATION MIGHT HAVE A FEW MISSING THINGS, just look at the source if you can't get something to work
--
 
--First define the library
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/edJT9EGX", true))()
--To close/open the UI (after it's been initialized) use Library:Close() to toggle it, use the keybind option to quickly make a toggle for it without hassle (there is an example below)
 
--Making a window
local Window = Library:CreateWindow"Window"
--There is a special property for windows which can be set to false (Window.canInit = false), if done so the window will not be initialized when Library:Init() is called
 
--Making a folder
Window:AddFolder"Folder"
--Folders can be used exactly like windows, they can hold all the options, you can even put folders inside of folders inside of folders.. and so on
 
--[[
    Adding otpions
    All options will by default have their flag names set to whatever the text is, unless the flag is set
]]
 
--Label
Window:AddLabel({text = "Label"})
 
--Button
Window:AddButton({text = "Button", flag = "button", callback = function() print"pressed" end})
--The flag for this option will be set to true after the button has been clicked, not sure how many uses there are for this
 
--Toggle
Window:AddToggle({text = "Toggle", flag = "toggle", state = false, callback = function(a) print(a) end})
Window:AddToggle({text = "Toggle", flag = "toggle1", state = true, callback = function(a) print(a) end})
--If the state is set to true by default then it will fire the callback when the library is initialized
 
--List
Window:AddList({text = "List", flag = "list", value = "Value", values = {"Value1", "Value2", "Value3", "Value4"}, callback = function(a) print(a) end})
--If the set value is not in the values table then it will get added to it
 
--Textbox
Window:AddBox({text = "Box", flag = "box", value = "Value", callback = function(a) print(a) end})
 
--Slider
Window:AddSlider({text = "Slider", flag = "slider", value = 100, min = 20, max = 200, float = 0.3, callback = function(a) print(a) end})
Window:AddSlider({text = "Slider", flag = "slider1", value = 0, min = -50, max = 100, callback = function(a) print(a) end})
 
--Keybind
Window:AddBind({text = "Bind", flag = "bind", key = "MouseButton1", callback = function() print"pressed" end}) --key can also be Enum.UserInputType.MouseButton1, instead of the name/string
Window:AddBind({text = "Bind", flag = "bind", hold = true, key = "E" , callback = function(a) if a then print"let go" else print"holding" end end}) --key can also be Enum.KeyCode.E, instead of the name/string
--Window:AddBind({text = "Toggle UI", key = "RightShift", callback = function() library:Close() end})
 
--Color Picker
Window:AddColor({text = "Color", flag = "color", color = Color3.fromRGB(255, 65, 65), callback = function(a) print(a) end})
Window:AddColor({text = "Color", flag = "color", color = {1, 0.2, 0.2}, callback = function(a) print(a) end})
--Uses a table instead of a color value (each value has to range from 0 to 1, think of it as using Color3.new), useful for loading json encoded options from a save file
 
--Initialize the library, so everything will get created
Library:Init()
 
wait(5)
print("Toggle is currently:", Library.flags["toggle"])
print("Second toggle is currently:", Library.flags["toggle1"])
--Flags can be useful for a lot of stuff, get creative with them :)
--You can also get the value/state/key from each option if they're defined
