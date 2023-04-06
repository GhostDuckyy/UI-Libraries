local library = loadstring(game:HttpGet("https://github.com/WetCheezit/UI-Libs/blob/main/Exodus.lua?raw=true"))()
local window = library:Load{playerlist = true}

library.Playerlist:button{name = "Prioritize", callback = function(list, plr)
    if not list:IsTagged(plr, "Prioritized") then
        list:Tag{player = plr, text = "Prioritized", color = fromRGB(255, 0, 0)}
    else
        list:RemoveTag(plr, "Prioritized")
    end
end}

library.Playerlist:button{name = "Ignore", callback = function(list, plr)
    if not library.Playerlist:IsTagged(plr, "Ignored") then
        library.Playerlist:Tag{player = plr, text = "Ignored", Color = fromRGB(120, 120, 120)}
    else
        library.Playerlist:RemoveTag(plr, "Ignored")
    end
end}

library.Playerlist:Label{name = "Rank: ", handler = function(plr)
    return "1e+9"
end}

library.Playerlist:Label{name = "Team: ", handler = function(plr)
    return "Ghosts", fromRGB(209, 118, 0)
end}

local watermark = library:Watermark("exodus | dev | test | 2.3b fps")

window:SettingsTab(watermark)
local tab = window:Tab("rage")
local tab2 = window:Tab("visuals")

window:Tab("legit"):Section{
    Side = "Middle"
}

tab:Section{}
local sec = tab:Section{
    Side = "Right"
}

local label = sec:Label("fart")
label:Set("hi")

sec:Button{}
sec:Button{}
sec:Button{}
sec:Button{}

sec:Dropdown{content = {"hi", "bye"}}

sec:Button{}

local m = sec:Separator()
sec:Button{name = "save config", callback = function() library:SaveConfig("fart") end}
sec:Button{name = "load config", callback = function() library:LoadConfig("fart", true) end}
sec:Button{callback = function() m:Set("testing 123") end}

local tog = sec:Toggle{}
tog:Slider{}

local f = tog:Colorpicker{alpha = 1}
f:SetAlpha(0.5)

tog:Colorpicker{}

local togel = sec:Toggle{}
togel:Colorpicker{alpha = 1}
togel:Colorpicker{}

local togel = sec:Toggle{}
togel:Slider{}

local fartel = sec:Toggle{name = "aimbot"}
fartel:Dropdown{}
fartel:Keybind{mode = "hold", listname = "aimbot share fr"}

local fartel = sec:Toggle{name = "keybind toggle"}
fartel:Keybind{}

sec:Box{
    callback = function(str)
        print(str)
    end,
    clearonfocus = false
}

sec:Slider{}
sec:Keybind{}

local label = sec:Label("fart")
local enemies, teammates = tab:MultiSection{
    Side = "Right",
    Sections = {"enemies", "teammates"}
}

enemies:Button{}
enemies:Button{}

teammates:Button{}
teammates:Button{}
teammates:Button{name = "fart"}
teammates:Button{}

local label = teammates:Label("fart")
label:Set("hi")

local tab2 = window:Tab("test")
local f = tab2:SubTab("hi")
local g = tab2:SubTab("testf")
local r = f:Section{name = "fart"}

r:Button{}
local r = g:Section{name = "poop"}
r:Button{}

library:Init()
--wait(10)
--library:Unload()
library:Notify{duration = 3, Color = fromRGB(0, 0, 0)}
task.wait(1)
library:Notify{duration = 3, Color = fromRGB(0, 0, 0)}
