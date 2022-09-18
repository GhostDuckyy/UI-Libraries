# ReadMe
Made by [**ZCute**](https://v3rmillion.net/member.php?action=profile&uid=1431869) | [V3rmillion Thread](https://v3rmillion.net/showthread.php?tid=1188166)

### Loadstring
```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/Unnamed/main/Library.lua'))()
```

### Preview
Current **themes**: `Starry Night` , `Tokyo Night` , `Dark` .

**Video**

[![video](https://www.programmableweb.com/sites/default/files/styles/facebook_scale_width_200/public/Streamable.jpg?itok=IBVZOrSC)](https://streamable.com/q4jcnb)

**Starry Night**

![a](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.vgy.me%2FMxkAG1.png)

**Tokyo Night**

![b](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.vgy.me%2FyD1Noo.png)

**Dark**

![c](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.vgy.me%2FfFhPGs.png)

### Example
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/Unnamed/main/Library.lua'))()
Library.Theme = "Dark"
local Flags = Library.Flags

local Window = Library:Window({
   Text = "Baseplate"
})

local Tab = Window:Tab({
   Text = "Aiming"
})

local Tab2 = Window:Tab({
   Text = "Visual"
})

local Tab3 = Window:Tab({
   Text = "Visual2"
})

local Tab4 = Window:Tab({
   Text = "Visua3"
})

local Section = Tab:Section({
   Text = "Buttons"
})

local Section2 = Tab2:Section({
   Text = "Buttons2"
})

local Section3 = Tab3:Section({
   Text = "Buttons2"
})
local Section4 = Tab4:Section({
   Text = "Buttons2"
})

Section:Button({
   Text = "Kill All",
   Callback = function()
       warn("Killed All")
   end
})

Section2:Button({
   Text = "Kick",
   Callback = function()
       warn("Kick.")
   end
})

Section2:Keybind({
   Text = "Press",
   Default = Enum.KeyCode.Z,
   Callback = function()
       warn("Pressed.")
   end
})

Section2:Input({
   Text = "Lil Input",
   Callback = function(txt)
       warn(txt)
   end
})

Section:Button({
   Text = "Kill",
   Callback = function()
       warn("Teleported")
   end
})

local drop = Section:Dropdown({
   Text = "Choose",
   List = {"Idk", "Test"},
   Callback = function(v)
       warn(v)
   end
})

Section:Slider({
   Text = "Speed",
   Default = 25,
   Minimum = 0,
   Maximum = 200
})

Section:Toggle({
   Text = "Farm",
   Callback = function(bool)
       warn(bool)
   end
})

Section:Button({
   Text = "Refresh Dropdown",
   Callback = function()
       drop:Remove("Test")
       wait(2)
       drop:Add("123")
   end
})

Tab:Select()
```
