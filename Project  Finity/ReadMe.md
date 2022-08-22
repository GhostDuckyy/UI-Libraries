## Documentation: https://detourious.gitbook.io/project-finity/

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Project%20%20Finity/source.lua", true))();
```

## Change log:

[+] Added: **`GetOption()`**
```lua
local dropdown = Sector:Cheat("Dropdown","dropdown",function(x)
    print(x)
end,{options = {"Apple","Banana","Dick"}})

local t = dropdown:GetOption() -- Return dropdown options [table]
for i,v in next, (t) do
  print(i,v)
end
--[[
    Output:
      1 Apple (Index, Value)
      2 Banana (Index, Value)
      3 Dick (Index, Value)
]]
```
