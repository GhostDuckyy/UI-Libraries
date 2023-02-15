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
