local Window = ImGui.new(
"Quick Tools" -- Window Name - REQUIRED
)

Window.AttachToInternalUI = true

local walkspeed_section = Window:Section("WalkSpeed")
local jumppower_section = Window:Section("JumpPower")

local speed = 16;
local jp = 50;

--[[
    WalkSpeed Section
--]]

local speedcheckbox = walkspeed_section:CheckBox("Enable Speed")
local speedbox = walkspeed_section:TextBox("Speed")

speedbox.TextChanged:connect(function()
    speed = tonumber(speedbox.Text);
    
    if speedcheckbox.Toggled  then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)

speedcheckbox.OnToggle:connect(function()
    if speedcheckbox.Toggled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16;
    end
end)

--[[
    JumpPower Section
--]]

local jpcheckbox = jumppower_section:CheckBox("Enable JumpPower")
local jpbox = jumppower_section:TextBox("JumpPower")
jpbox.TextChanged:connect(function()
    jp = tonumber(jpbox.Text);
    
    if jpcheckbox.Toggled  then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jp
    end
end)

jpcheckbox.OnToggle:connect(function()
    if jpcheckbox.Toggled then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = jp
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50;
    end
