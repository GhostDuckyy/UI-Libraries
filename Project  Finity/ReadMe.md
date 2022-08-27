## Documentation: https://detourious.gitbook.io/project-finity/

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/Ui-Librarys/main/Project%20%20Finity/source.lua", true))();
```

## Change log:
[+] Added: **`GetOption()`**

[+] Added: **`ClearOption()`**

Example:
```lua
local dropdown = Sector:Cheat("Dropdown","dropdown",function(x)
    print(x)
end,{options = {"Apple","Banana","Cat","Dick"}})

local t = dropdown:GetOption() -- Return dropdown options [table]
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
```
