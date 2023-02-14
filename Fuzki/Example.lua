local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Fuzki-UI-Library/main/FuzkiLibrary.lua"))() -- Gets the Library
local Main = Library:Create("Fuzki", "Baseplate") -- Creates Main Window | Fuzki (Hub Name) | Baseplate (Game Name)

local Other = Main:CreateSection("Other") | Creates section with name Other
local Preview = Main:CreateSection("Preview") [size=large]Creates another section with name Preview[/size]

Preview:CreateLabel("Text Label") -- Text Label with text inside of " "
Preview:CreateButton("Button Text", "Button Info", function() -- creates button (CreateButton)
   print("Wow, printed")
end)
Preview:CreateToggle("Toggle Info", function(state) -- creates Toggle
   print(state) -- prints state (true or false)
end)
Preview:CreateBind("Keybind Info", Enum.KeyCode.F, function() -- Enum.KeyCode.F is starting KeyBind
   print("Keybind Was Pressed")
end)
Preview:CreateTextBox("TextBox Info", "PlaceHolder", function(v) -- v= gets textbox text after enter pressed
print(v)
end)
Preview:CreateSlider(16, 500, "Slider Info", function(val) -- 16 (Min value) | 500 (Max value)
print(val) -- prints value 
end)
