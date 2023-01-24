# DropLib v0.3
DropLib is a simple, efficient and beautiful way to quickly build a GUI for your scripts.
It features: All the UI elements you would ever want, super-easy to use yet versatile API, jawdropping sexy defaults, nice and clean animations, In-Game gui updates!!, and much more!
If you have any questions, just dm me on discord: cheb#5214

![Screenshot](https://gitlab.com/0x45.xyz/droplib/-/raw/master/screenshot.png)

## How to get started
1. Read the [Examplecode](#examplecode)
2. Read the [Documentation](#documentation)
3. See what you can [configure](#configuration)
4. ...
5. That should be enough

## Documentation
### Initialize
It is recommended that you keep a local copy of the script, so updates don't break anything and load times are fast
```lua
local gui = loadstring(game:HttpGet("https://gitlab.com/0x45.xyz/droplib/-/raw/master/drop-minified.lua"))():Init(CONFIG,SCREENGUI_PARENT)

--Or if you use DropLib.rbxm
local gui = require(pathToFolder.DropLib):Init(CONFIG,SCREENGUI_PARENT)
```
|CONFIG|SCREENGUI_PARENT|
|--|--|
|(Table)[User-config](#Configuration) which overwrites the default config, default: empty table|(Instance)parent for the screengui, default: game.Player.LocalPlayer.PlayerGui|

### Gui Methods
```lua
gui:CleanUp()
```
Removes everything

```lua
gui:RecursiveUpdateGui()
```
Updates the gui based on the values in gui.Config

### Create Category / Section / SubSection
```lua
local category = gui:CreateCategory(TITLE, POSITION)
local section = category:CreateSection(TITLE)
local subsection = section:CreateSection(TITLE)
```
You can have as many nested sections as you want

|TITLE|POSITION|
|--|--|
|(String)Title|(UDim2)Initial position on screen, default: auto align|

### Category Methods
```lua
category:MoveTo(POSITION)
```
|POSITION|
|--|
|(UDim2) Screen Position|

```lua
category:EnableDraggability()
category:DisableDraggability()
```

### Category & Section Methods
```lua
catOrSec:HideCollapseButton()
catOrSec:ShowCollapseButton()

catOrSec:Collapse()
catOrSec:Expand()
```

### Elements
All of these can be used with a category, (sub-)section

#### Get and Set easily
You don't have to specify a callback function if you don't want to, you can get the value of the element with:
```lua
element:GetValue()
--element could be a switch, colorpicker, etc.
```
You can also set the value with
```lua
element:SetValue(VALUE)
```

#### Button
```lua
local button = catOrSec:CreateButton(TITLE, CALLBACK)
```
|TITLE|CALLBACK|
|--|--|
|(String)Title|(Function)Function called on click|

#### Slider
```lua
local slider = catOrSec:CreateSlider(TITLE, CALLBACK, MIN, MAX, STEP, DYNAMIC, INITIAL)
```
|TITLE|CALLBACK|MIN|MAX|STEP|DYNAMIC|INITIAL|
|--|--|-|--|--|--|--|
|(String)Title|(Function)Function called on change|(Number)Minimum|(Number)Maximum|(Number)Step, default: 0.01|(Boolean)Whether callback is called while user slides, default: false|(Number)Initial value, default: MIN|

#### Switch
```lua
local switch = catOrSec:CreateSwitch(TITLE, CALLBACK, INITIAL)
```
|TITLE|CALLBACK|INITIAL|
|--|--|--|
|(String)Title|(Function)Function called on toggle|(Boolean)Initial state, default: false|

#### Color Picker
```lua
local colorPicker = catOrSec:CreateColorPicker(TITLE, CALLBACK, DYNAMIC, INITIAL)
```
|TITLE|CALLBACK|DYNAMIC|INITIAL|
|--|--|--|--|
|(String)Title|(Function)Function called on toggle|(Boolean)Whether callback is called while color is being picked.|(Color3)Initial color, default: Config.AccentColor|

#### Selector / Dropdown Menu
```lua
local selector = catOrSec:CreateSelector(TITLE, CALLBACK, GETCALL, INITIAL)
```
|TITLE|CALLBACK|GETCALL|INITIAL|
|--|--|--|--|
|(String)Title|(Function)Function called on toggle|(Function)Function that returns a Table from which a element is picked |(Any)Initial , default: nil / empty|

E.g. if you want to list all players, your getcall would be ``` function() return game.Players:GetPlayers() end ```

#### Text Label
```lua
local label = catOrSec:CreateTextLabel(TITLE)
```
|TITLE|
|--|
|(String)Title|

#### Key Detector
```lua
local detector = catOrSec:CreateKeyDetector(TITLE, CALLBACK, INITIAL)
```
|TITLE|CALLBACK|INITIAL|
|--|--|--|
|(String)Title|(Function)Function called on change|(KeyCode)Initial, default: Enum.KeyCode.Unknown|

#### Textbox
```lua
local textbox = catOrSec:CreateTextBox(TITLE, CALLBACK, ACCEPTFORMAT, DYNAMIC, INITIAL)
```
|TITLE|CALLBACK|ACCEPTFORMAT|DYNAMIC|INITIAL|
|--|--|--|--|--|
|(String)Title|(Function)Function called on change|(Pattern)Text has to match this pattern, default: ".+"/Accepts everything|(Boolean)Whether callback is called while user is typing|(String)Initial, default: ""/Empty text|

The AcceptFormat for a number only textbox would be: ```^d+$```

## Configuration
Default configuration (Under Development, alot is gonna change in the near future. Expect to redo your config), change anything to your liking:
```lua
Config.PrimaryColor = Color3.fromRGB(27, 38, 59)
Config.SecondaryColor = Color3.fromRGB(13, 27, 42)
Config.AccentColor = Color3.fromRGB(41, 115, 115)
Config.TextColor =  Color3.new(1,1,1)
Config.Font = Enum.Font.Gotham
Config.TextSize = 13
Config.HeaderWidth = 300
Config.HeaderHeight = 32
Config.EntryMargin = 1
Config.AnimationDuration = 0.4
Config.AnimationEasingStyle = Enum.EasingStyle.Quint
Config.DefaultEntryHeight = 35
```
The configurations are held in gui.Config. When changes are made, make sure to call gui:UpdateGui()

## Examplecode
```lua
local config = {
    ["HeaderWidth"] = 250,
    ["AccentColor"] = Color3.new(0.6,0,0)
}
local gui = loadstring(game:HttpGet("https://gitlab.com/0x45.xyz/droplib/-/raw/master/drop-minified.lua"))():Init(config,game.CoreGui)

gui:CreateCategory("Clean Up"):CreateButton("Click",function() gui:CleanUp() end)
local lpg = gui:CreateCategory("Local Player")

lpg:CreateSlider("Walk Speed", function(ws) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = ws end,0,100,nil,true,game.Players.LocalPlayer.Character.Humanoid.WalkSpeed)
lpg:CreateSlider("Jump Power", function(jp) game.Players.LocalPlayer.Character.Humanoid.JumpPower = jp end,0,200,nil,true,game.Players.LocalPlayer.Character.Humanoid.JumpPower)
lpg:CreateButton("Force Field", function() Instance.new("ForceField",game.Players.LocalPlayer.Character) end)
```
Super simple script which can set the walkspeed, jumppower and create a forcefield. Furthermore, it has a button to delete everything.
In addition to that, it overwrites the headerwidth and the accentcolor

## Building
Although possible, the build system is rather hackish as of right now, so just use the minified version for all your needs.
(Build is done through the plugin Compile.rbxmx and Rojo(ask me on discord on how), where DropLib.lua is selected and the button in the plugin menu is clicked. A merged and minified version should be in workspace)
