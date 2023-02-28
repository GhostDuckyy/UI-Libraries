local library = loadstring(game:HttpGet("https://github.com/GoHamza/AppleLibrary/blob/main/main.lua?raw=true"))()


local window = library:init("Titlebar", true, Enum.KeyCode.RightShift, true)

window:Divider("I'm a divider!")

local sectionA = window:Section("Test Elements")

sectionA:Divider("I'm another divider!")

sectionA:Button("Click me!", function()
   print("Button clicked.")
end)

sectionA:Label("Lorem ipsum dolor sit amet.")

sectionA:Switch("Switch me!", false, function(a)
   print(a)
end)

sectionA:TextField("Enter text here!", "Enter text here...", function(a)
   print(a)
end)

window:Divider("Just dividin'")

local sectionB = window:Section("Test Notifications")

sectionB:Divider("Dividers are cool!")

sectionB:Button("Temporary Notification", function()
   window:TempNotify("Be careful!", "We are going to beat you up.", "rbxassetid://12608259004")
end)

sectionB:Button("Notification 1", function() window:Notify("Hello!", "I am notification", "Button1", "rbxassetid://12608259004",
   function()
       print(1)
   end)
end)

sectionB:Button("Notification 2", function() window:Notify2("Hello!", "I am notification", "Button 1", "Button 2", "rbxassetid://12608259004",
   function()
       print(1)
   end,
   function()
       print(2)
   end)
end)

window:GreenButton(function()
   print("You clicked the green button!")
end)

sectionA:Select()
