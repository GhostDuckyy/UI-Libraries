# ReadMe
Made by **`xHeptc#2255`** / [V3rmillion Profile](https://v3rmillion.net/member.php?action=profile&uid=1347047) / [V3rmillion Thread](https://v3rmillion.net/showthread.php?tid=1143174)

## Preview
![a](https://garfieldscripts.xyz/assets/img/clipboard-image-8.png)

### Example
```lua
local Fun = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/nightmares.fun-UI-Library/main/source.lua"))()

local window = Fun.Create("UI Library")

local tab = window:Tab("Leak")

local section = tab:Section("Showcase")

section:Toggle("Toggle", function(s)
   print(s)
end)

section:Button("Button", function()
   
end)

section:Label("Label")

section:KeyBind("KeyBind", Enum.KeyCode.E, function()
   
end)

section:Slider("Slider", 16, 200, function()
   
end)

section:Dropdown("Dropdown", {"1", "2", "3"}, function()
   
end)

section:TextBox("Textbox", function()
   
end)
```
