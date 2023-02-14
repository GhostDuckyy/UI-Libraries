local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/insanedude59/UILib/main/source"))();

lib:SetTitle("Slixx's UI Library") -- name <string>

local tab1 = lib:NewTab("Character", "Character Description Here") -- name <string> description <string>
tab1:NewDropdown("Dropdown thing",{"1","2","3","4","5"},"hi",function(selected) -- name <string> list <table> default <string> callback <function>
	print(selected)
end)
tab1:NewTextBox("WalkSpeed","Enter WalkSpeed Here",function(value) -- name <string> placeholdertext <string> callback <function>
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
tab1:NewToggle("Autofarm",false,function(value) -- name <string> default <bool> callback <function>
    print(value)
end)
tab1:NewSlider("WalkSpeed",16,500,16,function(value) -- name <string> minimum <number> maximium <number> default <number> callback <function>
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
tab1:NewButton("Change WalkSpeed to 50",function()-- name <string> callback <function>
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
end)
