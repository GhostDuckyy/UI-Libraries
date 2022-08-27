## Read me
Every exploit will have build-in **ImGui** i think.
### Documentation:
```html
ImGui
    -> new(<string> Window_Name, <Vector2?> Window_Size) > Creates a new Windows
        Properties:
            -> AttachToInternalUI > This means it will be toggled with the INS key, like the regular Fluxus Internal UI. 
            -> Size [ WRITE ONLY ]
            -> Style [ WRITE ONLY ] 
            -> Visible
        Functions:
            -> Section(<string> Section_Name)
                -> Button(<string> Button_Text, <bool?> Same_Line, <Vector2?> Size);
                      Events:
                          -> OnClick()
                      Properties:
                          -> Text
                          -> Visible
                          -> Size [ WRITE ONLY ] 
                -> Label(<string> Label_Text, <bool?> Same_Line)
                      Properties:
                          -> Text
                          -> Visible
                -> BulletLabel(<string> Label_Text, <bool?> Same_Line)
                      Properties:
                          -> Text
                          -> Visible
                -> TextBox(<string?> Hint/DefaultText, <Vector2?> Size)
                      Events:
                          -> TextChanged()
                      Properties: 
                          -> Text [ READ ONLY ]
                          -> Hint 
                          -> MultiLine
                          -> Visible 
                -> CheckBox(<string> CheckBox_Text, <Vector2?> Size)
                      Events:
                          -> OnToggle()
                      Properties:
                          -> Visible
                          -> Toggled

    -> Styles > Styles for the ImGui
        -> Default
        -> Custom
        -> Light
        -> Classic
```
## Supported
### Fluxus

[website](https://fluxteam.net/) / [discord](https://fluxteam.net/external-files/discord.php)

[docs](https://github.com/GhostDuckyy/Ui-Librarys/blob/main/ImGui/Fluxus/documentation.html) / [raw](https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/ImGui/Fluxus/documentation.html)

[example](https://github.com/GhostDuckyy/Ui-Librarys/blob/main/ImGui/Fluxus/example.lua) / [raw](https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/ImGui/Fluxus/example.lua)

Fluxus: Added build-in **ImGui** ( Working-in-progress ) - 10:31 a.m. Saturday, 20 August 2022

### Oxygen U
[website](https://oxygenu.xyz/) / [discord](https://discord.gg/3f7f2JK3Rc)

Oxygen U `2.1`: Added build-in **ImGui** - 9:13 p.m. Monday, 22 August 2022
