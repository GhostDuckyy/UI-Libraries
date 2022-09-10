# Vynixius
**Made by `RegularVynixu#8039`** | [**Repository**](https://github.com/RegularVynixu/UI-Libraries/tree/main/Vynixius)

### Documentation
```cs
----- Library -----

Library:AddWindow(<table> {
    <table> title {
        <string> title1
        <string> title2
    }
    <table> theme {
        <color3> Accent
        <color3> TopbarColor
        <color3> SidebarColor
        <color3> BackgroundColor
        <color3> SectionColor
        <color3> TextColor
    }  -> optional
    <bool> default
    <keycode> key
})

Library:Notify(<table> {
    <string> title
    <string> text
    <int> duration
    <color3> color
})

----- Window -----

Window:Toggle(<bool> toggled)

Window:SetKey(<keycode> toggleKey)

Window:SetAccent(<color3> accent)

Window:AddTab(<table> {
    <string> name
    <table> options {
        <bool> default
    } 
})

----- Tab -----

Tab:Show()

Tab:Hide()

Tab:AddSection(<table> {
    <string> name
    <table> options {
        <bool> default
    }
})

Tab:AddConfigs(<string> name)

----- Section -----

Section:AddButton(<table> {
    <string> name
    <void> callback
})

-----

Section:AddToggle(<table> {
    <string> name
    <table> options {
        <bool> default
        <string> flag

    }
    <void> callback(<bool> enabled)
})

-----

Section:AddLabel(<table> {
    <string> text
})

-----

Section:AddDualLabel(<table> {
    <table> text {<string> text1, <string> text2}
})

-----

Section:AddClipboardLabel(<table> {
    <string> name
    <void> callback()  ->  must return string
})

-----

Section:AddBox(<table> {
    <string> name
    <table> options {
        <bool> clearonfocus
        <bool> fireonempty
    }
    <void> callback(<string> text)
})

-----

Section:AddBind(<table> {
    <string> name
    <keycode> bind
    <table> options {
        <string> flag
        <bool> default
        <bool> toggleable
        <bool> fireontoggle
    }
    <void> callback(<keycode> bind)
})

Bind:Toggle(<bool> enabled)  ->  only available if 'toggleable' option is set to true

-----

Section:AddSlider(<table> {
    <string> name
    <int> minValue
    <int> maxValue
    <int> value
    <table> options {
        <bool> toggleable
        <string> flag
        <bool> fireontoggle
        <bool> fireondrag
        <bool> rounded
    }
    <void> callback(<int> value)
})

Slider:Set(<int> value)

Slider:Toggle(<bool> enabled)  ->  only available if 'toggleable' option is set to true

-----

Section:AddDropdown(<table> {
    <string> name
    <table> list  ->  array of strings
    <table> options {
        <string> default  ->  string item from list
    }
    <void> callback(<string> selected)
})

Dropdown:Add(<string> name, <void> callback  ->  optional)

Dropdown:Remove(<string> item)  ->  string item from list

Dropdown:SetList(<table> list)  ->  array of strings

Dropdown:ClearList()

-----

Section:AddPicker(<table> {
    <string> name
    <table> options {
        <color3> color
    }
    <void> callback
})

Picker:Set(<int> h, <int> s, <int> v)  ->  array of HSV values

Picker:ToggleRainbow(<bool> enabled)

-----

Section:AddSubSection(<table> {
    <string> name
    <table> options {
        <bool> default
    }
})

----- SubSection -----

SubSection:AddButton(<table> {
    <string> name
    <void> callback
})

-----

SubSection:AddToggle(<table> {
    <string> name
    <table> options {
        <bool> default
        <string> flag

    }
    <void> callback(<bool> enabled)
})

-----

SubSection:AddLabel(<table> {
    <string> text
})

-----

SubSection:AddDualLabel(<table> {
    <table> text {<string> text1, <string> text2}
})

-----

SubSection:AddClipboardLabel(<table> {
    <string> name
    <void> callback()  ->  must return string
})

-----

SubSection:AddBox(<table> {
    <string> name
    <table> options {
        <bool> clearonfocus
        <bool> fireonempty
    }
    <void> callback(<string> text)
})

-----

SubSection:AddBind(<table> {
    <string> name
    <keycode> bind
    <table> options {
        <string> flag
        <bool> default
        <bool> toggleable
        <bool> fireontoggle
    }
    <void> callback(<keycode> bind)
})

Bind:Toggle(<bool> enabled)  ->  only available if 'toggleable' option is set to true

-----

SubSection:AddSlider(<table> {
    <string> name
    <int> minValue
    <int> maxValue
    <int> value
    <table> options {
        <bool> toggleable
        <string> flag
        <bool> fireontoggle
        <bool> fireondrag
        <bool> rounded
    }
    <void> callback(<int> value)
})

Slider:Set(<int> value)

Slider:Toggle(<bool> enabled)  ->  only available if 'toggleable' option is set to true

-----

SubSection:AddDropdown(<table> {
    <string> name
    <table> list  ->  array of strings
    <table> options {
        <string> default  ->  string item from list
    }
    <void> callback(<string> selected)
})

Dropdown:Add(<string> name, <void> callback [optional])

Dropdown:Remove(<string> item)  ->  string item from list

Dropdown:SetList(<table> list)  ->  array of strings

Dropdown:ClearList()

-----

SubSection:AddPicker(<table> {
    <string> name
    <table> options {
        <color3> color
    }
    <void> callback
})

Picker:Set(<int> h, <int> s, <int> v)  ->  array of HSV values

Picker:ToggleRainbow(<bool> enabled)
```
