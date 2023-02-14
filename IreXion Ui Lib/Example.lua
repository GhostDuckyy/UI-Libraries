local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/IreXion-UI-Library/main/IreXion%20UI%20Library"))()

local Gui = Library:AddGui({
Title = {"IreXion", "UI Library"},
ThemeColor = Color3.fromRGB(0, 255, 0),
ToggleKey = Enum.KeyCode.RightShift,
})

local Tab = Gui:AddTab("Tab")

local Category = Tab:AddCategory("Category")

local Button = Category:AddButton("Button", function()
print("Button Pressed")
end)

local Toggle = Category:AddToggle("Toggle", false, function(toggle)
print(toggle)
end)

local Box = Category:AddBox("Box", function(str)
print(str)
end)

local Label = Category:AddLabel("Label")

local DualLabel = Category:AddDualLabel({"Label1", "Label2"})

local Slider = Category:AddSlider("Slider", 1, 100, 50, function(val)
print("Slider Value:", val)
end)

local Dropdown = Category:AddDropdown("Dropdown", {
"Item 1",
"Item 2",
"Item 3",
"Item 4",
"Item 5",
"Item 6",
"Item 7",
"Item 8",
"Item 9",
"Item 10",
}, function(name)
print(name)
end)

local Bind = Category:AddBind("Bind", Enum.KeyCode.RightShift, function()
print("Bind Pressed")
end)
