local Luxtl = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Luxware-UI-Library/main/Source.lua"))()

local Luxt = Luxtl.CreateWindow("Wisteria GUI", 6105620301)

local mainTab = Luxt:Tab("Auto-Farm", 6087485864)
local teleportsTab = Luxt:Tab("Teleports")
local autoQTab = Luxt:Tab("Auto-Quest")
local combatTab = Luxt:Tab("Combat")
local creditsTab = Luxt:Tab("Credits")
local cf = creditsTab:Section("Main Credits")
cf:Credit("Luxt: Main Coding")
local cf1 = creditsTab:Section("UI Credits")
cf1:Credit("xHeptc: UI Library")
local cf2 = creditsTab:Section("Helping Credits")
cf2:Credit("Salad: Helping")

local Examples = Luxt:Tab("Examples")
local ff = Examples:Section("All Examples")
ff:Label("Welcome to Wisteria GUI")
ff:Button("TextButton Text", function()
    print("Clicked!")
end)
ff:Toggle("Toggle Me!", function(isToggled)
    print(isToggled) -- prints true or false
end)
ff:KeyBind("Print('Hey') on bind", Enum.KeyCode.R, function() --Enum.KeyCode.R is starting Key
    print('Hey')
end)
ff:TextBox("TextBox Info", "Epic PlaceHolder", function(getText)
    print(getText) -- Prints whatever player types
end)
ff:Slider("WalkSpeed", 16, 503, function(currentValue)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentValue 
end)
ff:DropDown("Favorite Food?", {"Pizza", "Burger", "Sandwiches"}, function(food) -- food is chosen item
    print(food)
end)
