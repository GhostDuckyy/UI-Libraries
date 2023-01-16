# Using Atlas Library
### Getting The Library
The following code will load the library code and run it in ROBLOX.
```lua
local Atlas = loadstring(game:HttpGet("https://siegehub.net/Atlas.lua"))()
```
# Library Methods
#### `Library.new`

**Usage**:
Creates a new library window.
**Note**: You should only call this once in your script.
**Example Usage**:
```lua
local Atlas = loadstring(game:HttpGet("https://siegehub.net/Atlas.lua"))()

local UI = Atlas.new({
    Name = "My Script"; -- script name (required)
    ConfigFolder = "MyScript"; -- folder name to save configs to, set this to nil if you want to disable configs saving
    Credit = "Made By RoadToGlory#9879"; -- text to appear if player presses the "i" button on their UI (optional)
    Color = Color3.fromRGB(255,0,0); -- theme color for UI (required)
    Bind = "LeftControl"; -- keybind for toggling the UI, must be a valid KeyCode name
    -- Atlas Loader:
    UseLoader = true; -- whether to use Atlas Loader or not, if set to false than CheckKey and Discord are ignored
    FullName = "My Script Hub"; -- works if UseLoader is set to true, can be same as Name argument, shown on loader frame
    CheckKey = function(inputtedKey) -- works if UseLoader is set to true, where inputtedKey is the key inputted by the player
        return inputtedKey=="key1234"
    end;
    Discord = "https://discord.gg/xu5dDS3Pb9"; -- works if UseLoader is set to true, will be copied to clipboard if player presses "Copy Invite" button
})
```

#### `Library:CreatePage`
**Usage**:
Creates a page in your UI with parameter **`Name`** being the name of the page.

**Example Usage**:
```lua
local UI = Atlas.new({
    Name = "My Script";
    ConfigFolder = "MyScript";
    Credit = "Made By RoadToGlory#9879";
    Color = Color3.fromRGB(255,0,0);
    Bind = "LeftControl";
    UseLoader = true;
    FullName = "My Script Hub";
    CheckKey = function(inputtedKey)
        return inputtedKey=="key1234"
    end;
    Discord = "https://discord.gg/xu5dDS3Pb9";
})

local MyPage = UI:CreatePage("My First Page") -- creates a page
```
#### `Library:Notify`
**Usage**:
Shows a library notification on the bottom left corner of the player's screen with given arguments. Execute the sample code at the top of this page to see how this works and looks.

**Example Usage**:
```lua
local UI = Atlas.new({
    Name = "My Script";
    ConfigFolder = "MyScript";
    Credit = "Made By RoadToGlory#9879";
    Color = Color3.fromRGB(255,0,0);
    Bind = "LeftControl";
    UseLoader = true;
    FullName = "My Script Hub";
    CheckKey = function(inputtedKey)
        return inputtedKey=="key1234"
    end;
    Discord = "https://discord.gg/xu5dDS3Pb9";
})

UI:Notify({
  Title = "My Notification";
  Content = "Hi.";
})
```

#### `Library:Toggle`
**Usage**:
Toggles UI visibility to argument passed, either **`true`** or **`false`**.
If no argument is provided, it will toggle the UI's visibility to the opposite of its current state.
**Note**: This is used internally with the **`Bind`** argument of **`Library.new`**, so it is unlikely you would need to use this.

**Example Usage**:
```lua
local UI = Atlas.new({
    Name = "My Script";
    ConfigFolder = "MyScript";
    Credit = "Made By RoadToGlory#9879";
    Color = Color3.fromRGB(255,0,0);
    Bind = "LeftControl";
    UseLoader = true;
    FullName = "My Script Hub";
    CheckKey = function(inputtedKey)
        return inputtedKey=="key1234"
    end;
    Discord = "https://discord.gg/xu5dDS3Pb9";
})

UI:Toggle(false) -- will change UI's visibility to false

UI:Toggle(true) -- will change UI's visibility to true

UI:Toggle() -- will change UI's visibility to the opposite of its current state, which would be false
```
#### `Library:SetToggle`
**Usage**:
Sets UI's toggle bind, use "Unknown" to disable.
**Note: This is only neccisary when changing the bind after the library is initiated, as this is handled at initiation internally.**

**Example Usage**:
```lua
local UI = Atlas.new({
    Name = "My Script";
    ConfigFolder = "MyScript";
    Credit = "Made By RoadToGlory#9879";
    Color = Color3.fromRGB(255,0,0);
    Bind = "LeftControl";
    UseLoader = true;
    FullName = "My Script Hub";
    CheckKey = function(inputtedKey)
        return inputtedKey=="key1234"
    end;
    Discord = "https://discord.gg/xu5dDS3Pb9";
})

UI:SetToggle("E") -- sets UI toggle bind to KeyCode.E
```

#### `Library:Destroy`
**Usage**:
Destroys the UI, destroys any connections, and stops any coroutines. This method fully cleans up any trace of the UI.

**Example Usage**:
```lua
local UI = Atlas.new({
    Name = "My Script";
    ConfigFolder = "MyScript";
    Credit = "Made By RoadToGlory#9879";
    Color = Color3.fromRGB(255,0,0);
    Bind = "LeftControl";
    UseLoader = true;
    FullName = "My Script Hub";
    CheckKey = function(inputtedKey)
        return inputtedKey=="key1234"
    end;
    Discord = "https://discord.gg/xu5dDS3Pb9";
})

UI:Destroy() -- will destroy the UI
```

# Page Methods
#### `Page:CreateSection`
**Usage**:
Creates a new section in the page with the given name. Page ordering is done in order, so if you create two pages, the first one you create will appear on top while the other is on the bottom.
Note: You must create a section in a page before creating an element, as creating elements is done through a section!

**Example Usage**:
```lua
local MyPage = UI:CreatePage("My First Page")

local MySection = MyPage:CreateSection("My Section") -- creates a section in page with the name passed. This argument is reqiured.
```

# Section Methods
####  `Section:CreateToggle`
