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
