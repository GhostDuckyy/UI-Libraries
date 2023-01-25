# ReadMe
`source.lua` is added some dropdown function

`modded.lua` is same as `source.lua` but added more theme (in-coming)

**Documentation**: https://detourious.gitbook.io/project-finity/

## **Loadstring**:

**Default**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Project%20%20Finity/source.lua", true))();
```
**Modded**
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Project%20%20Finity/modded.lua", true))();
```

## Change log:
[+] Added: **`GetOption()`**

[+] Added: **`ClearOption()`**

[+] Added: **`Cheat:SetLabel()`**

Example:
```lua
local dropdown = Sector:Cheat("Dropdown","dropdown",function(x)
    print(x)
end,{options = {"Apple","Banana","Cat","Dick"}})

local t = dropdown:GetOption() -- Return dropdown options <table>
for i,v in next, (t) do
  print(i,v)
end
--[[
    Output:
     -> Index, Value
       1 Apple
       2 Banana
       3 Cat
       4 Dick
]]
dropdown:ClearOption()

local label = Sector:Cheat("label","1")

local btn = Sector:Cheat("button","Apple",function()
    print("Apple")
end)

while task.wait(.5) do
    label:SetLabel(math.random(1,999))
    btn:SetLabel(math.random(1,999))
end

```
