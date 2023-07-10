local VLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/vep1032/VepStuff/main/VL"))()
local w = VLib:Window("VEP HUB", "GAMENAME", "G")
local tab = w:Tab("Tab 1")
w:Tab("Tab 2")

tab:Button("Button",function()
  print("Pressed!")
end)

tab:Toggle("Toggle",function(t)
  print(t)
end)


tab:Slider("Slider",0,100,70,function(t)
  print(t)
end)


tab:Dropdown("Dropdown",{"Option 1", "Option 2", "Option 3", "Option 4", "Option 5"},function(t)
  print(t)
end)

tab:Colorpicker("Colorpicker",Color3.fromRGB(255, 1, 1),function(t)
  print(t)
end)

tab:Textbox("Textbox", true,function(t)
  print(t)
end)

tab:Label("Label")
