--NOTE:
-- THIS SCRIPT IS MEANT TO BE READ IN ORDER TO TEACH HOW TO USE THE LIBRBARY.
-- THIS MEANS SOME TOGGLES MAY CHANGE THE VALUES OF OTHER ELEMENTS ON THE UI
-- THESE AREN'T BUGS, THEY'RE JUST SHOWING YOU HOW TO DO THINGS

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/cueshut/saves/main/compact"))()
UI = UI.init("Showcase", "v1.0.0", "SHOWCASE")

local AimOne, AimTwo = UI:AddTab("Aim", "Silent Aim") do
local Section = AimOne:AddSeperator("Silent Aim") do
local masterToggle = Section:AddToggle({
title = "Enabled",
desc = "This is a small tip which will appear when the user hovers over this toggle. It works on all elements",
callback = function(state)
print("Toggled: ", state)
end
})

local fovToggle, fovColor
fovToggle, fovColor = Section:AddToggle({
title = "Display field of view",
checked = true,
callback = function(state)
print("FOV display toggled", state)
print("FOV color", fovToggle.colorpicker.getColor(), fovColor.getColor())
print("silent aim enabled", masterToggle.getToggled())

fovColor.setColor(Color3.new(0,1,0))
end,
colorpicker = {
default = Color3.new(0,0.5,1),
callback = function(color)
print("New FOV color selected: ", color)
end
}
})


local slider = Section:AddSlider({
title = "Field of view",
values = {min=0,max=250,default=50},
callback = function(set)
print("FOV has been set to: ", set)
end,
})

Section:AddToggle({
title = "Test slider return",
callback = function()
print(slider.getValue())
slider.setPercent(0.8) --DESPITE "setPercent" IT EXPECTS VALUE 0-1. 80% of 250
wait(3)
slider.setValue(75) --set literally to 75
end
})

local bodyparts = { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Arm" }
local selection = Section:AddSelection({
title = "Bodyparts",
options = bodyparts,
callback = function(selected)
print("Selected the following:")
for _,i in pairs(selected) do print(" -", bodyparts[i]) end
end
})

Section:AddToggle({
title = "Test selection",
callback = function()
print("Currently selected: ")
for _,i in pairs(selection.getSelected()) do print(" -", i) end
selection.setDropdownExpanded(true)
wait(1)
selection.setSelected({1,2,5}) --head, torso, left leg
wait(2)
selection.setOptions({"carrot", "rhubarb", "olive"})

end
})
end
local Section = AimTwo:AddSeperator("Tuning") do
   Section:AddToggle({
       title = "Do tuning"
   })

local fruit = {"lime", "lemon", "mango", "nut"}
local dropdown = Section:AddDropdown({
title = "Demonstrative dropdown",
options = fruit,
callback = function(selected, actual) --selected = the index of the item in the "options" list. Actual = its actual text
print(selected, fruit[selected], actual)
end
})

Section:AddToggle({
title = "Test dropdown",
callback = function()
print("Selected", dropdown.getSelected())
dropdown.setDropdownExpanded(true)
wait(1)
dropdown.setSelected(3) --mango
wait(2)
dropdown.setOptions({"carrot", "rhubarb", "olive"})

end
})
end
end
local TabTwo = UI:AddTab("Second tab", "some other things")
