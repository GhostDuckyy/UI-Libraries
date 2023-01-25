# Mango UI Library
## UI Library Designed for Easy Use
#### Loadstring
```lua
local MangoLib = loadstring(game:HttpGet("https://pastebin.com/raw/N3sKKx0a"))()
```
#### Notification
```lua
MangoLib:Notify("Notification!", "System Error!")
```
#### Window
```lua
local win = MangoLib:Window("Mango Hub")
```
#### Tab
```lua
local TabFarm = win:Tab("Autofarm")
```
#### Label
```lua
TabFarm:Label("This is A Label")
```
#### Button
```lua
TabFarm:Button("print hi", function()
    print("Hi!")
end)
```
#### Toggle
```lua
TabFarm:Toggle("Print True / False", function(Bool)
    print(tostring(Bool))
end)
```
#### Dropdown
```lua
TabFarm:Dropdown("Select Enemies", {"Bandit", "Crook", "Marine"}, function(EnemyName)
    print(EnemyName)
end)
```
#### Slider
```lua
TabFarm:Slider("Walk Speed", 16, 500, 50, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)
```
#### TextBox
```lua
TabFarm:TextBox("Type Hi", function(Value)
    if Value == "Hi" then
        print("Correct Text")
    else
        print("Incorrect Text")
    end
end)
```
#### KeyBind
```lua
TabFarm:KeyBind("Spam Hi", Enum.KeyCode.B, function(Value)
    while Value do task.wait()
        print("Hi")
    end
end)
```
