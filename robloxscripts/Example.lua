local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/forumsLib/main/source.lua"))()
local Forums = Library.new("robloxscripts.com")

local preview = Forums:NewSection("Preview")
local preview1 = Forums:NewSection("Function Preview")

preview:NewButton("Button Example", function()
print("join   now!")
end)
preview:NewToggle("Toggle Example", function(state)
print("Toggle: "..state)
end)
preview:NewTextBox("Box Example", function(text)
print(text)
end)
preview:NewSlider("Slider Example", 0, 400, function(value)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
preview:NewKeybind("Key Example", Enum.KeyCode.E, function()
Forums:UIMinimize()
end)
local list = {
    "Option 1",
    "Option 2",
    "Option 3",
}
preview:NewDropdown("Dropdown Example", list, function(item)
   
end)

preview1:Seperator()

local btn = preview1:NewButton("This Button Will Update", function()
    print("Button")
end)
preview1:NewButton("Update Button Above!", function()
    btn:Update("Wow, It Updated!!")
end)

preview1:Seperator()
getgenv().stt = false
local toggle = preview1:NewToggle("Status: ", function(status)
    getgenv().stt = status
end)
coroutine.wrap(function()
    while wait() do
        toggle:Update("Status: "..tostring(getgenv().stt))
    end
end)()
preview1:Seperator()

getgenv().newTxt = "Update This Text"
local box = preview1:NewTextBox("Update This Text", function(newText)
    getgenv().newTxt = newText
end)
coroutine.wrap(function()
    while wait() do
        box:Update(tostring(getgenv().newTxt))
    end
end)()

preview1:Seperator()

local key = preview1:NewKeybind("This Key Will Update", Enum.KeyCode.E, function()
Forums:UIMinimize()
end)
preview1:NewButton("Update to Q", function()
    key:Update(Enum.KeyCode.Q)
end)
preview1:NewButton("Update to F", function()
    key:Update(Enum.KeyCode.F)
end)
preview1:NewButton("Update to O", function()
    key:Update(Enum.KeyCode.O)
end)

preview1:Seperator()

local drop = preview1:NewDropdown("Player List", {"Update To Get Players"}, function(item)
   
end)
local plrTable = {}
preview1:NewButton("Update Player List", function()
    for i,v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer then
            table.insert(plrTable, v.Name)
        end
    end
    drop:Refresh(plrTable)
end)

preview1:Seperator()
