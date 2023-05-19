local SolarisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

--[[SolarisLib:New({
  Name - Title of the UI <string>
  FolderToSave - Name of the folder where the UI files will be stored <string>
})]]
local win = SolarisLib:New({
  Name = "SolarisLib",
  FolderToSave = "SolarisLibStuff"
})

--win:Tab(title <string>)
local tab = win:Tab("Tab 1")

--tab:Section(title <string>)
local sec = tab:Section("Elements")

--sec:Button(title <string>, callback <function>)
sec:Button("Button", function()
  SolarisLib:Notification("Test", "This is a notification test.")
end)

--sec:Toggle(title <string>,default <boolean>, flag <string>, callback <function>)
local toggle = sec:Toggle("Toggle", false,"Toggle", function(t)
  print(t)
end)

--[[
toggle:Set(state <boolean>)
]]

--sec:Slider(title <string>,default <number>,max <number>,minimum <number>,increment <number>, flag <string>, callback <function>)
local slider = sec:Slider("Slider", 0,25,0,2.5,"Slider", function(t)
  print(t)
end)

--[[
slider:Set(state <number>)
]]

--sec:Dropdown(title <string>,options <table>,default <string>, flag <string>, callback <function>)
local dropdown = sec:Dropdown("Dropdown", {"a","b","c","d","e"},"","Dropdown", function(t)
  print(t)
end)

--[[
Dropdown:Refresh(options <table>, deletecurrent <boolean>)
Dropdown:Set(option <string>)
]]

--sec:MultiDropdown(title <string>,options <table>,default <table>, flag <string>, callback <function>)
local multidropdown =sec:MultiDropdown("Multi Dropdown", {"a","b","c","d","e"},{"b", "c"},"Dropdown", function(t)
  print(table.concat(t, ", "))
end)

--[[
Dropdown:Refresh(options <table>, deletecurrent <boolean>)
Dropdown:Set(option <table>)
]]

--sec:Colorpicker(title <string>, default <color3>, flag <string>, callback <function>)
sec:Colorpicker("Colorpicker", Color3.fromRGB(255,255,255),"Colorpicker", function(t)
  print(t)
end)

--sec:Textbox(title <string> ,disappear <boolean>, callback <function>)
sec:Textbox("Textbox", true, function(t)
  print(t)
end)

--sec:Bind(title <string>, default <keycode>, hold <boolean>, flag <string>, callback <function>)
sec:Bind("Hold Bind", Enum.KeyCode.E, true, "BindHold", function(t)
  print(t)
end)

sec:Bind("Normal Bind", Enum.KeyCode.F, false, "BindNormal", function()
  print("Bind pressed")
end)

--[[
bind:Set(state <keycode>)
]]

--sec:Label(text <string>)
local label = sec:Label("Label")

--[[
label:Set(text <string>)
]]
local tab2 = win:Tab("Tab 2")
