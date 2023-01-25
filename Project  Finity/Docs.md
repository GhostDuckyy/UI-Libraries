# Introduction
> General information about Project Finity.

### What is Project Finity?
Project Finity is a user interface library (commonly known as a "UI library") designed for people like you to create easily nice-looking user interfaces for scripts that you dream of. It's primary purpose was to assist in my creation of scripts, but many others wanted to use it too. This brought me to the decision to allow you all to use it too!

### Why should I use Project Finity?
Project Finity is new, community-oriented, packed with features and it's easy to use! Anything the community wants for Project Finity is something I try my best to deliver. 

### What does Project Finity have?
Here are a few of the loved features by the community:
> Dark/light appearance modes

> Many different cheat modules for you to optimize your script

> Sleek and soft design, providing the best experience for your users

> Community-oriented suggestions frequently being added

# Project Finity Library
**Project Finity** has a variety of different modules for you to customize your cheat. Below is the documentation on how to use each of them.
## Documentation
### Finity
```lua
local Finity = loadstring(game:HttpGet("http://finity.vip/scripts/finity_lib.lua"))()
```
Use the above line of code before you run any of **Project Finity's** UI methods.

#### Constructor
|Constructor| Description | Return Types |
|--|--|--|
| Finity.new([, boolean is_dark_mode]) | Creates a new Finity pseudo-instance. | FinityWindow

#### Properties
| Property | Default Value |
|--|--|
| is_dark_mode | **false** |
| toggle_key | Enum.KeyCode.**Semicolon** |

### FinityWindow
```lua
local FinityWindow = Finity.new(true) -- 'true' means dark mode is enabled
```
A **FinityWindow** is essentially the main backbone of the UI.
#### Methods
| Method | Description | Return Types |
|--|--|--|
| FinityWindow:Category(string name) | Creates a new FinityCategory with a name. | FinityCategory |
| FinityWindow.ChangeToggleKey(**Enum** keycode) | Changes the key to toggle the window. | nil|

> Because of the way Finity works, multiple categories with the same name are allowed, _however_, it may be confusing for your users.

### FinityCategory
```lua
local FinityCategory = FinityWindow:Category("name") -- name is the name of the FinityCategory
```
A **FinityCategory** is an easy and dynamic way to categorize the modules of the script you're making into general categories.

For example, let's say I was making a cheat for Apocalypse Rising 2: I would be able to use multiple FinityCategory instances to be able to categorize different types of cheats, such as Visuals, Guns, Items, Zombies, and/or Client cheat. You get the idea, right? Cool beans!

Below are the methods of a FinityCategory.
#### Methods
| Method | Description | Return Types |
|--|--|--|
| FinityCategory:Sector(**string** name) | Creates a new FinitySector with a name. | FinitySector |

> Because of the way Finity works, multiple sectors with the same name are allowed, _however_, it may be confusing for your users. Less confusing than duplicate categories, I hope. 😅

#### Properties
| Property | Default Value |
|--|--|
| name | nil |


### FinitySector
```lua
local FinitySector = FinityCategory:Sector("name") -- name is the name of the FinityCategory
```
A **FinitySector** instance is essentially a mini-category, allowing for even more categorization.

For example, it would allow you to sub-categorize a "Visuals" category into things like "Player Visuals," "Zombie Visuals," and "Item Visuals."

Below are the methods associated with a **FinitySector**.

#### Methods
| Method | Description | Return Types |
|--|--|--|
| FinitySector:Cheat(**string** type,**string** name [, **function** callback, **array** data]) | Creates a new FinityCheat with a type and a name. (Optional: callback function & data) | FinityCheat |

#### Properties
| Property | Default Value |
|--|--|
| Name | nil |


### FinityCheat
```lua
local FinityCheat = FinitySector:Cheat("type", "name", function (NewValue)
    print(NewValue)
end, {})
```
A **FinityCheat** is a cheat modules useful for hooking callbacks to toggles in order to have a smooth and organized script.

There are many different types of cheat modules. Here's a table to compare them all:
| Cheat Module Type | Description |
|--|--|
| Checkbox | The checkbox is useful for having a user control the state of something. Fires callback with the new state of the checkbox. |
| Dropdown | The dropdown is useful for having a user choose from a list of things. Fires the callback with the option that was chosen as a string. |
| Slider | The slider is useful for having a user choose between a range of numbers. Fires the callback with the new value of the slider. |
| Textbox | The textbox is useful for having the user enter a custom value. Fires the callback with the new value of the textbox as a string. |
| Button | The button is nice for a user to trigger a specific action. Fires the callback when clicked with no arguments. |
| Keybind | The keybind is useful for performing an action when a key is pressed. Fires the callback when the key is changed or pressed. |
| Colorpicker | This is nice for choosing a certain color in range. Fires the callback each time the color is changed with the new Color3. |
| Label | The label is useful for displaying information to a user. Doesn't fire anything. |
