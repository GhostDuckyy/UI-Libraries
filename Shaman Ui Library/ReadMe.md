### Documentation:
```lua
Library: {
   Flags: table
   Window: function {
       Text: string
       Section: function {
           Text: string
           Side: string [Left - Right]
           Label: function {
               Text: string
               Tooltip: string
               Color: color3
               Set: function {
                   Text: string
                   Color: color3
               }
           }
           Button: function {
               Text: string
               Tooltip: string
               Callback: function
           }
           Input: function {
               Text: string
               Tooltip: string
               Placeholder: string
               Callback: function
           }
           Toggle: function {
               Text: string
               Tooltip: string
               Flag: string
               Callback: function
               Set: function {
                   bool {Set(true/false)}
               }
           }
           Slider: function {
               Text: string
               Tooltip: string
               Flag: string
               Postfix: string {What comes after the slider value {Example: % / Studs}}
               Default: number
               Minimum: number
               Maximum: number
               Callback: function
           }
           Keybind: function {
               Text: string
               Tooltip: string
               Default: enum {Enum.KeyCode.X}
               Callback: function
           }
           Dropdown: function {
               Text: string
               Tooltip: string
               Flag: string
               Default: string
               List: table
               Callback: function
               Refresh: function {
                   Text: string
                   List: table
               }
           }
           RadioButton: function {
               Text: string
               Tooltip: string
               Flag: string
               Default: string
               Options: table {Same as dropdown list but with another name}
               Callback: function
           }
       }
   }
}
```
