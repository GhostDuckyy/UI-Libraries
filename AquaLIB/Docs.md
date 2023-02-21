# Documentation
Step 1: Import the library
```lua
local lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/TheoTheEpic/AquaLib/main/AquaLib.lua'))()
```
Step 2: Create a window
```lua
local window = lib.createWindow("Aqua", "Aqua Library", true) 
```
Step 3: Create a tab
```lua
local tab1 = window.createTab("Test Tab")
local section1 = tab1.createSection("Test Section", false)
```
Step 4: Add components 
```lua
section1.createText("Hello World")
section1.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value)
	print(value)
end)
tab1.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value)
	print(value)
end)
section1.createButton("Test Button", function()
	print("Button Pressed!")
end)
section1.createToggle("Test Toggle", false, function(value)
	print(value)
end)
section1.createSlider("Test Slider", {defualt = 50, max = 100, min = 1}, function(value)
	print(value)
end)
local textbox = section1.createTextBox("Test TextBox", "Test")
section1.createText("Test Text")

tab1.createButton("Test Button", function()
	print("Button Pressed!")
end)
tab1.createButton("Create Notification", function() 
	window.notification("Test Notification", "Hello World")
end)
tab1.createToggle("Test Toggle", false, function(value)
	print(value)
end)
tab1.createText("Test Text")
tab1.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value)
	print(value)
end)
tab1.createSlider("Test Slider", {defualt = 50, max = 100, min = 1}, function(value)
	print(value)
end)
local textbox = tab1.createTextBox("Test TextBox", "Test")

wait(5)
print(textbox.getText())
textbox.clearText()
```

## Functions
### Library
#### Create Window
lib.createWindow, Usage:
```lua
local window = lib.createWindow("Aqua", "Aqua Library", true) -- lib.createWindow(name, title, draggable)
```
### Window
#### Create tab
window.createTab, Usage:
```lua
local tab = window.createTab("This Is A Tab") -- window.createTab(name)
```
#### Delete tab
window.deleteTab, Usage:
```lua
window.deleteTab("This Is A Tab") -- window.createTab(name)
```
#### Notify
window.notification, Usage:
```lua
window.notification("This Is A Notification!", "Nice") -- window.notification(title, description)
```
#### Delete Window
window.deleteWindow, Usage:
```lua
window.deleteWindow("TestWindow") -- lib.deleteWindow(window name)
```

### Tab
#### Create Section
tab.createSection, Usage:
```lua
local section1 = tab.createSection("Test Section", false) -- tab.createSection(text, is expanded by defualt)
```
#### Button
tab.createButton, Usage:
```lua
tab.createButton("Test Button", function() -- tab.AddButton(text, callback)
    print("Button Pressed!")
end)
```
#### Label
tab.createText, Usage:
```lua
tab.createText("Test Text")  -- tab.createText(text)
```
#### Toggle
tab.createToggle, Usage:
```lua
tab.createToggle("Test Toggle", false, function(value) -- tab.createToggle(text, defualt value, callback)
	print(value)
end)
```
#### Dropdown
tab.createDropdown, Usage:
```lua
tab.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value) -- tab.createDropdown(name, options, callback)
	print(value)
end)
```
#### Slider
tab.createSlider, Usage:
```lua
tab.createSlider("Test Slider", {min = 1, max = 200, defualt = 20}, function(Value) -- tab.createSlider(text, config(min, max, defualt), callback)
	print(Value) -- Will be a number between min and max
end)
```
#### Textbox
tab.createTextBox, Usage:
```lua
local input = tab.createTextBox("Test TextBox", "Test") -- tab.createTextBox(text, placeholder)
```
#### Remove instance
tab.removeInstance, Usage:
```lua
tab.removeInstance("Test TextBox") -- tab.removeInstance(Instance name)
```
### Section
#### Button
section.createButton, Usage:
```lua
section.createButton("Test Button", function() -- section.AddButton(text, callback)
    print("Button Pressed!")
end)
```
#### Label
section.createText, Usage:
```lua
section.createText("Test Text")  -- section.createText(text)
```
#### Toggle
section.createToggle, Usage:
```lua
section.createToggle("Test Toggle", false, function(value) -- section.createToggle(text, defualt value, callback)
	print(value)
end)
```
#### Dropdown
section.createDropdown, Usage:
```lua
section.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value) -- section.createDropdown(name, options, callback)
	print(value)
end)
```
#### Slider
section.createSlider, Usage:
```lua
section.createSlider("Test Slider", {min = 1, max = 200, defualt = 20}, function(Value) -- section.createSlider(text, config(min, max, defualt), callback)
	print(Value) -- Will be a number between min and max
end)
```
#### Textbox
section.createTextBox, Usage:
```lua
local input = section.createTextBox("Test TextBox", "Test") -- section.createTextBox(text, placeholder)
```
#### Remove instance
section.removeInstance, Usage:
```lua
section.removeInstance("Test TextBox") -- section.removeInstance(Instance name)
```

### Text
text.getText, Usage:
```lua
local value = input.getText() -- input.getText()
print(value)
```
text.clearText, Usage:
```lua
input.clearText() -- input.clearText
```

## Misc
Full Example:
```lua
local lib = loadstring(game:HttpGet('https://raw.githubusercontent.com/TheoTheEpic/AquaLib/main/AquaLib.lua'))()

local window = lib.createWindow("This Is A Window", "TestWindow", true) -- lib.createWindow(title, name, draggable)
local tab1 = window.createTab("This Is A Tab") -- window.createTab(name)
local section1 = tab1.createSection("Test Section", false)

section1.createText("Hello World")
section1.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value)
	print(value)
end)
tab1.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value)
	print(value)
end)
section1.createButton("Test Button", function()
	print("Button Pressed!")
end)
section1.createToggle("Test Toggle", false, function(value)
	print(value)
end)
section1.createSlider("Test Slider", {defualt = 50, max = 100, min = 1}, function(value)
	print(value)
end)

local textbox = section1.createTextBox("Test TextBox", "Test")
section1.createText("Test Text")
tab1.createButton("Test Button", function()
	print("Button Pressed!")
end)
tab1.createButton("Create Notification", function() 
	window.notification("Test Notification", "Hello World")
end)
tab1.createToggle("Test Toggle", false, function(value)
	print(value)
end)
tab1.createText("Test Text")
tab1.createDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6", "Option 7", "Option 8", "Option 9", "Option 10"}, "Option 7", function(value)
	print(value)
end)
tab1.createSlider("Test Slider", {defualt = 50, max = 100, min = 1}, function(value)
	print(value)
end)
local textbox = tab1.createTextBox("Test TextBox", "Test")

wait(5)
print(textbox.getText())
textbox.clearText()
```

