# Zypher
## Documentation
### Loadstring
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/teppyboy/RbxScripts/master/Misc/UI_Libraries/Zypher/Library.lua"))()
```

### Window
```lua
local main = library:CreateMain({
    projName = "UILib", -- Name
    Resizable = true, -- Resize
    MinSize = UDim2.new(0,400,0,400), -- Minimum size
    MaxSize = UDim2.new(0,750,0,500), -- Maximum size
})
```
### Category
```lua
local category = main:CreateCategory("Category") -- <string, categoryName>
```
### Section
```lua
local section = category:CreateSection("Section") -- <string, sectionName>
```

###  Create
Here is a list of interactables you can add to your section.
```
Button, Toggle, Slider, Textlabels, Textbox, Dropdown, Keybind, Colorpicker
```
```lua
section:Create(
    <string, interactableType>,
    <string, interactableName>,
    <function>,
    <options>
)
```
### Label
```lua
section:Create(
    "Textlabel",
    "Hi, text here!"
)
```
### Button
```lua
section:Create(
    "Button",
    "Button",
    function()
        print("button pressed")
    end,
    {
        animated = true,
    }
)
```
### Toggle
```lua
section:Create(
    "Toggle",
    "Toggle",
    function(state)
        print("Current state:", state)
    end,
    {
        default = true,
    }
)
```
### Slider
```lua
section:Create(
    "Slider",
    "Slider",
    function(value)
        print(value)
    end,
    {
        min = 0,
        max = 5,
        -- Optional
        default = 2,
        precise = true, -- ex: 0.1, 0.2, 0.3
        changablevalue = true
    }
)
```
### TextBox
```lua
section:Create(
    "TextBox",
    "TextBox",
    function(input)
        print("Input changed to:", input)
    end,
    {
        text = "I am a textbox"
    }
)
```
### Keybind
```lua
section:Create(
    "KeyBind",
    "KeyBind", 
    function()
        print("Key pressed")
    end,
    {
        default = Enum.KeyCode.K
    }
)
```
### DropDown
```lua
section:Create(
    "DropDown",
    "DropDown", 
    function(current)
        print("Selected to:", current)
    end,
    {
        options = {
            "First",
            "Second",
            "Third",
            "4th",
            "5th",
            "6th"
        },
         -- Optional
        default = "First",
        search = true
    }
)
```
### ColorPicker
```lua
Section:Create(
    "ColorPicker",
    "ColorPicker",
    function(color)
        print("Current color:", color)
    end,
    {
        default = Color3.fromRGB(255,255,255)
    }
)
```
## Final Example
Down here you will have a full example including the ui library. You can use this to get started, but we recommend you to read the documentation.
```lua
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/teppyboy/RbxScripts/master/Misc/UI_Libraries/Zypher/Library.lua"))()

local main = library:CreateMain({
    projName = "UILib",
    Resizable = true,
    MinSize = UDim2.new(0,400,0,400),
    MaxSize = UDim2.new(0,750,0,500),
})

local category = main:CreateCategory("Category")

local section = category:CreateSection("Section")

section:Create(
    "Button",
    "Button",
    function()
        print("button pressed")
    end,
    {
        animated = true,
    }
)
section:Create(
    "Toggle",
    "Toggle",
    function(state)
        print("Current state:", state)
    end,
    {
        default = true,
    }
)
section:Create(
  "Slider",
  "Slider",
  function(value)
      print(value)
  end,
  {
      min = 0,
      max = 5,
      -- Optional
      default = 2,
      precise = true, -- ex: 0.1, 0.2, 0.3
      changablevalue = true
  }
)
section:Create(
    "TextBox",
    "TextBox",
    function(input)
        print("Input changed to:", input)
    end,
    {
        text = "I am a textbox"
    }
)
section:Create(
    "KeyBind",
    "KeyBind", 
    function()
        print("Key pressed")
    end,
    {
        default = Enum.KeyCode.K
    }
)
section:Create(
    "DropDown",
    "DropDown", 
    function(current)
        print("Selected to:", current)
    end,
    {
        options = {
            "First",
            "Second",
            "Third",
            "4th",
            "5th",
            "6th"
        },
         -- Optional
        default = "First",
        search = true
    }
)
section:Create(
    "ColorPicker",
    "ColorPicker", 
    function(Color)
        print("Current color:", Color)
    end,
    {
        default = Color3.fromRGB(0,255,255)
    }
)
```
