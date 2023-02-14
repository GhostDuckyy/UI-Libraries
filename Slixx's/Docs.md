# Basic Documents
First, we start by calling the **Library**.
```lua
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/insanedude59/UILib/main/source"))();
```
Next, set the **title**.
```lua
lib:SetTitle("Slixx's UI Library")
```
Then, make a **Tab**.
```lua
local tab1 = lib:NewTab("Character", "Character Description Here")
```
**Button**:
```lua
tab1:NewButton("Change WalkSpeed to 50",function() -- title, callback
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)
```
**Toggle**:
```lua
tab1:NewToggle("Autofarm",false,function(value) -- title, default, callback
    print(value)
end)
```
**Slider**:
```lua
tab1:NewSlider("WalkSpeed",16,500,16,function(value) -- title, minimum, maximium, callback
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```
**Textbox**:
```lua
tab1:NewTextBox("WalkSpeed","Enter WalkSpeed Here",function(value) -- title, placeholder, callback
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```
**Dropdown**:
```lua
tab1:NewDropdown("Dropdown thing",{"1","2","3","4","5"},"hi",function(selected) -- title, list, default, callback
	print(selected)
end)
```
