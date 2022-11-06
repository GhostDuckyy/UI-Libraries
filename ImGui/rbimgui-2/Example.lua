local engine = loadstring(game:HttpGet("https://raw.githubusercontent.com/Singularity5490/rbimgui-2/main/rbimgui-2.lua"))()

local window1 = engine.new({
    text = "window 1",
    size = UDim2.new(300, 200),
})

window1.open()

local tab1 = window1.new({
    text = "tab 1",
})

local label1 = tab1.new("label", {
    text = "this is a cool tab",
    color = Color3.new(1, 0, 0),
})

local button1 = tab1.new("button", {
    text = "button",
})
button1.event:Connect(function()
    print("button was pressed !")
end)

local switch1 = tab1.new("switch", {
    text = "swithc!";
})
switch1.set(true)
switch1.event:Connect(function(bool)
    print("switch set to: ", bool)
end)

local slider1 = tab1.new("slider", {
    text = "slider lol",
    color = Color3.new(0.8, 0.5, 0),
    min = 100,
    max = 1000,
    value = 600.1,
    rounding = 1,
})
slider1.event:Connect(function(x)
    print("slider value: " .. x)
end)
slider1.set(420.69)

local color1 = tab1.new("color", {
    color = Color3.new(0, 0, 1),
    text = "blue balls",
})
color1.event:Connect(function(color)
    print("balls not blue anymore.. now they " .. BrickColor.new(color.r, color.g, color.b).Name:lower())
end)

local dropdown1 = tab1.new("dropdown", {
    text = "some dropdown thing",
})
dropdown1.new("object 1")
dropdown1.new("some other object")
dropdown1.new("yeaH")
dropdown1.event:Connect(function(name)
    print("i chose " .. name .. "!")
end)

local dock1 = tab1.new("dock")

local button2 = dock1.new("button")
button2.event:Connect(function()
    print("button 2 pressed")
end)

local slider2 = dock1.new("slider", { size = 100 })
slider2.event:Connect(function(x)
    print("slider 2 value: ", x)
end)

local folder1 = tab1.new("folder", {
    text = "folder.. yeah",
})

local button3 = folder1.new("button")
button3.event:Connect(function()
    print("button THREE.. pressed.")
end)

folder1.open()
