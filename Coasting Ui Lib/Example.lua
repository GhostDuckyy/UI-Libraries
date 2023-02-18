local CoastingLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/Coasting%20Ui%20Lib/source.lua"))()

local AimbotTab = CoastingLibrary:CreateTab("Aimbot")
local MainSection = AimbotTab:CreateSection("Main")
local ConfigSection = AimbotTab:CreateSection("Config")

MainSection:CreateButton("Click Me!", function()
   print("Boo!")    
end)

MainSection:CreateLabel("Namey", "Hello!")

MainSection:CreateToggle("Aimbot", function(boolean)
   print("Aimbot:", boolean)
end)

MainSection:CreateSlider("Field Of View", 0, 150, 50, false, function(value)
   print("Field of View: " .. value)
end)

ConfigSection:CreateColorPicker("Field of View Color", Color3.fromRGB(255, 255, 255), function(color)
   print("Field Of View Color:", color)
end)

ConfigSection:CreateDropdown("Type", {"Mouse", "Character"}, 1, function(option)
   print("Type: " .. option)
end)

ConfigSection:CreateKeybind("Aimbot Bind", Enum.KeyCode.Unknown, false, true, function(boolean)
   print("Aimbot Active:", boolean)
end)
