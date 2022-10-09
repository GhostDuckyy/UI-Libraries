local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()
local window = engine.new({ text = "rbimgui demo",color = Color3.new() })
window.open()
local tab = window.new({ text = "main" })
window.new({ text = "examples" })
window.new({ text = "credits" })
tab.show()

local dock1 = tab.new("dock")
local button = tab.new("button")
button.event:Connect(function()
    print("button pressed")
end)

dock1.new("slider", {
    size = 100,
    min = 100,
    max = 200,
    value = 120,
    color = Color3.new(0.8,0,0),
}).event:Connect(function(x)
    print("slider value: " .. x)
end)

local folder1 = tab.new("folder", { color = Color3.new(0,0.6,0.6) })
folder1.open()
local cp = folder1.new("color", { text = "color1" })
cp.event:Connect(function(color)
    print("color: ", color)
end)

local dropdown1 = folder1.new("dropdown", { text = "dropdown 1", color = Color3.new(0,0.6,0) })
dropdown1.event:Connect(function(name)
    print("chosen: " .. name)
end)
for i = 1,9 do
    dropdown1.new("option: " .. i)
end
folder1.new("dropdown", { rounding = 10 })
tab.new("label", { text = "hello world!" })
