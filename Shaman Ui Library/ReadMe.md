## ReadMe
Made by [**ZCute**](https://v3rmillion.net/member.php?action=profile&uid=1431869) / [**Thread**](https://v3rmillion.net/showthread.php?pid=8349869#pid8349869) <V3rmillion>
### Github
[**Repository**](https://github.com/Rain-Design/Libraries/tree/main/Shaman)

[**Source**](https://github.com/Rain-Design/Libraries/blob/main/Shaman/Library.lua) / [**Raw**](https://raw.githubusercontent.com/Rain-Design/Libraries/main/Shaman/Library.lua)

#### Waypoints
[Docs](https://github.com/GhostDuckyy/Ui-Librarys/tree/main/Shaman%20Ui%20Library#documentation) | [Example](https://github.com/GhostDuckyy/Ui-Librarys/tree/main/Shaman%20Ui%20Library#example)

### Picture:
![photo 1](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.vgy.me%2FcOo65A.png)
![photo 2](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.vgy.me%2FpnDNX8.png)

### Documentation:
```cs
Library: {
   Flags: <table>
   Window: <function> {
       Text: <string>
       Section: <function> {
           Text: <string>
           Side: <string> [Left / Right]
           Label: function {
               Text: <string>
               Tooltip: <string>
               Color: <color3>
               Set: <function> {
                   Text: <string>
                   Color: <color3>
               }
           }
           Button: <function> {
               Text: <string>
               Tooltip: <string>
               Callback: <function>
           }
           Input: <function> {
               Text: <string>
               Tooltip: <string>
               Placeholder: <string>
               Callback: <function>
           }
           Toggle: <function> {
               Text: <string>
               Tooltip: <string>
               Flag: <string>
               Callback: <function>
               Set: function {
                   <boolean> | Example: Set(true / false)
               }
           }
           Slider: <function> {
               Text: <string>
               Tooltip: <string>
               Flag: <string>
               Postfix: <string> | What comes after the slider value {Example: % / Studs}
               Default: <number>
               Minimum: <number>
               Maximum: <number>
               Callback: <function?
           }
           Keybind: function {
               Text: <string>
               Tooltip: <string>
               Default: <Enum.Keycode> | Example: Enum.KeyCode.RightControl
               Callback: <function>
           }
           Dropdown: <function> {
               Text: <string>
               Tooltip: <string>
               Flag: <string>
               Default: <string>
               List: <table>
               Callback: <function>
               Refresh: <function> {
                   Text: <string>
                   List: <table>
               }
           }
           RadioButton: <function> {
               Text: <string>
               Tooltip: <string>
               Flag: <string>
               Default: <string>
               Options: <table> | Note: Same as dropdown list but with another name
               Callback: <function>
           }
       }
   }
}
```

### Example:
```lua
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Rain-Design/Libraries/main/Shaman/Library.lua'))()
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

local ChamsSection = Tab2:Section({
    Text = "Chams"
})

local Section = Tab:Section({
    Text = "Aimbot"
})

local Section2 = Tab:Section({
    Text = "FOV"
})

local Section3 = Tab:Section({
    Text = "Misc",
    Side = "Right"
})

ChamsSection:Toggle({
    Text = "Enabled"
})

ChamsSection:Toggle({
    Text = "Color"
})

ChamsSection:Toggle({
    Text = "Filled"
})

ChamsSection:Toggle({
    Text = "Team Check"
})

Section:Toggle({
    Text = "Enabled"
})

Section:Toggle({
    Text = "Wall Check"
})

Section:Toggle({
    Text = "Smooth Aimbot"
})

Section2:Toggle({
    Text = "Enabled"
})

Section2:Toggle({
    Text = "Filled FOV"
})

Section2:Toggle({
    Text = "FOV Transparency",
    Tooltip = "Changes your fov transparency."
})

Section2:Button({
    Text = "Reset FOV",
    Tooltip = "This resets your aimbot fov."
})

Section3:Toggle({
    Text = "Infinite Ammo"
})

Section3:Toggle({
    Text = "No Spread"
})

Section3:Toggle({
    Text = "No Bullet Drop",
    Default = true
})

Section3:Toggle({
    Text = "Full Auto"
})

local a = Section3:Toggle({
    Text = "No Recoil"
})

local label = Section3:Label({
    Text = "This is a label.",
    Color = Color3.fromRGB(217, 97, 99),
    Tooltip = "This is a label."
})

local dropdown = Section:Dropdown({
    Text = "Dropdown",
    List = {"Head","Torso","Random"},
    Flag = "Choosen",
    Callback = function(v)
        warn(v)
    end
})

Section:RadioButton({
    Text = "RadioButton",
    Options = {"Legit","Blatant"},
    Callback = function(v)
        warn(v)
    end
})

Section:Toggle({
    Text = "Silent Aimbot"
})

Section:Input({
    Placeholder = "Webhook URL",
    Flag = "URL"
})

Section:Keybind({
    Default = Enum.KeyCode.E,
    Text = "Aimbot Key",
    Callback = function()
        warn("Pressed")
    end
})

Section:Slider({
    Text = "Slider Test",
    Default = 5,
    Minimum = 0,
    Maximum = 50,
    Flag = "SliderFlag",
    Callback = function(v)
        warn(v)
    end
})

Tab:Select()

wait(5)

--[[dropdown:Refresh({
    List = {"Head", "Feet"}
})--]]

label:Set({
    Text = "This is a red label."
})

a:Set(true)
```
