# Documentation 
## Library core
first we have to add a loadstring for library usage

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/slf0Dev/Ocerium_Project/main/Library.lua"))()
```


### Creating a window

```lua
Window = Library.Main("Your Text","LeftAlt") -- change "LeftAlt" to key that you want will hide gui
```

### Adding tabs and sections
```lua
--//tab
local Tab = Window.NewTab("Your Tab Text")


--//section
local Section = Tab.NewSection("Section Text")

```

### Adding Toggle and Buttons

```lua
--// Button
local Button = Section.NewButton("Button Text",function()
-- code here
end)


--//Toggles
local EnabledToggle = Section.NewToggle("Enabled Toggle",function(bool)
-- code here
end,true) -- "true" is the default value of toggle

local DisabledToggle = Section.NewToggle("Disabled Toggle",function(bool)
-- code here
end,false) -- "false" is the default value of toggle
```

### Adding Sliders

```lua
local SliderPrecise = section.NewSlider("Slider precise",0,100,true,function(value)

end,25)
local SliderNotPrecise = section.NewSlider("Slider not precise",0,100,false,function(value)

end,75)
```
