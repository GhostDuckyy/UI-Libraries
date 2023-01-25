local MangoLib = loadstring(game:HttpGet("https://pastebin.com/raw/N3sKKx0a"))()

spawn(function()
MangoLib:Notify("System", "Setting Script Up!")
end)

local TabFarm = MangoLib:Tab("Autofarm")

TabFarm:Button("Print Hi", function()
print("Hi")
end)

TabFarm:Slider("Walk Speed", 16, 500, 40, function(v)
    WalkSpeedValue = v
end)

TabFarm:Toggle("Toggle WalkSpeed", function(v) -- v = Value
    State = t
    if State then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
    end
end)

TabFarm:Dropdown("Select Enemy", {"Bandit", "Marine"}, function(t)
    print(t)
end)

TabFarm:TextBox("Type in Key", function(t)
    if t == "Mango" then
        print("Correct Key")
    else
        print("Incorrect Key")
    end
end)

TabFarm:KeyBind("Start Attacking", Enum.KeyCode.V, function(t)
    StartAttacking = t
end)

spawn(function()
    while task.wait() do
        if StartAttacking then
            pcall(function()
                print("Attacking")
            end)
        end
    end
end) 
