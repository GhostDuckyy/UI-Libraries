local library = (syn and loadstring(game:HttpGet("https://github.com/GhostDuckyy/UI-Libraries/blob/main/DEADCELL%20REMAKE/source.lua?raw=true"))()) or loadstring(game:HttpGet("https://github.com/GhostDuckyy/UI-Libraries/blob/main/DEADCELL%20REMAKE/Modified/source.lua?raw=true"))();

local theme = {
    ["Default"] = {
        ["Accent"] = Color3.fromRGB(61, 100, 227),
        ["Window Outline Background"] = Color3.fromRGB(39,39,47),
        ["Window Inline Background"] = Color3.fromRGB(23,23,30),
        ["Window Holder Background"] = Color3.fromRGB(32,32,38),
        ["Page Unselected"] = Color3.fromRGB(32,32,38),
        ["Page Selected"] = Color3.fromRGB(55,55,64),
        ["Section Background"] = Color3.fromRGB(27,27,34),
        ["Section Inner Border"] = Color3.fromRGB(50,50,58),
        ["Section Outer Border"] = Color3.fromRGB(19,19,27),
        ["Window Border"] = Color3.fromRGB(58,58,67),
        ["Text"] = Color3.fromRGB(245, 245, 245),
        ["Risky Text"] = Color3.fromRGB(245, 239, 120),
        ["Object Background"] = Color3.fromRGB(41,41,50)
    };    
}

do
    local window = library:new_window({size = Vector2.new(600,450)})
    local page = window:new_page({name = "Example Page"})
	local accent = page:new_section({
		name = "theme",
		size = "Fill"
	});
	local theme_pickers = {};
	theme_pickers.Accent = accent:new_colorpicker({
		name = "accent",
		flag = "theme_accent",
		default = theme["Default"].Accent,
		callback = function(state)
			library:ChangeThemeOption("Accent", state);
		end
	});
	theme_pickers["Window Outline Background"] = accent:new_colorpicker({
		name = "window outline",
		flag = "theme_outline",
		default = theme["Default"]["Window Outline Background"],
		callback = function(state)
			library:ChangeThemeOption("Window Outline Background", state);
		end
	});
	theme_pickers["Window Inline Background"] = accent:new_colorpicker({
		name = "window inline",
		flag = "theme_inline",
		default = theme["Default"]["Window Inline Background"],
		callback = function(state)
			library:ChangeThemeOption("Window Inline Background", state);
		end
	});
	theme_pickers["Window Holder Background"] = accent:new_colorpicker({
		name = "window holder",
		flag = "theme_holder",
		default = theme["Default"]["Window Holder Background"],
		callback = function(state)
			library:ChangeThemeOption("Window Holder Background", state);
		end
	});
	theme_pickers["Window Border"] = accent:new_colorpicker({
		name = "window border",
		flag = "theme_border",
		default = theme["Default"]["Window Border"],
		callback = function(state)
			library:ChangeThemeOption("Window Border", state);
		end
	});
	theme_pickers["Page Selected"] = accent:new_colorpicker({
		name = "page selected",
		flag = "theme_selected",
		default = theme["Default"]["Page Selected"],
		callback = function(state)
			library:ChangeThemeOption("Page Selected", state);
		end
	});
	theme_pickers["Page Unselected"] = accent:new_colorpicker({
		name = "page unselected",
		flag = "theme_unselected",
		default = theme["Default"]["Page Unselected"],
		callback = function(state)
			library:ChangeThemeOption("Page Unselected", state);
		end
	});
	theme_pickers["Section Inner Border"] = accent:new_colorpicker({
		name = "border 1",
		flag = "theme_border1",
		default = theme["Default"]["Section Inner Border"],
		callback = function(state)
			library:ChangeThemeOption("Section Inner Border", state);
		end
	});
	theme_pickers["Section Outer Border"] = accent:new_colorpicker({
		name = "border 2",
		flag = "theme_border2",
		default = theme["Default"]["Section Outer Border"],
		callback = function(state)
			library:ChangeThemeOption("Section Outer Border", state);
		end
	});
	theme_pickers["Section Background"] = accent:new_colorpicker({
		name = "section background",
		flag = "theme_section",
		default = theme["Default"]["Section Background"],
		callback = function(state)
			library:ChangeThemeOption("Section Background", state);
		end
	});
	theme_pickers.Text = accent:new_colorpicker({
		name = "text",
		flag = "theme_text",
		default = theme["Default"].Text,
		callback = function(state)
			library:ChangeThemeOption("Text", state);
		end
	});
	theme_pickers["Risky Text"] = accent:new_colorpicker({
		name = "risky text",
		flag = "theme_risky",
		default = theme["Default"]["Risky Text"],
		callback = function(state)
			library:ChangeThemeOption("Risky Text", state);
		end
	});
	theme_pickers["Object Background"] = accent:new_colorpicker({
		name = "element background",
		flag = "theme_element",
		default = theme["Default"]["Object Background"],
		callback = function(state)
			library:ChangeThemeOption("Object Background", state);
		end
	});
	accent:new_dropdown({
		flag = "settings/menu/effects",
		name = "accent effects",
		options = {
			"None",
			"rainbow",
			"shift",
			"reverse shift"
		},
		default = "none"
	});
	accent:new_slider({
		flag = "settings/menu/effect_speed",
		name = "effect speed",
		min = 0,
		max = 2,
		default = 1,
		float = 0
	});
	(game:GetService("RunService")).Heartbeat:Connect(function()
		local AccentEffect = library.flags["settings/menu/effects"];
		local EffectSpeed = library.flags["settings/menu/effect_speed"];
		if AccentEffect == "rainbow" then
			local Clock = os.clock() * EffectSpeed;
			local Color = Color3.fromHSV(math.abs(math.sin(Clock)), 1, 1);
			library:ChangeThemeOption("Accent", Color);
		end;
		if AccentEffect == "shift" then
			local ShiftOffset = 0;
			local Clock = os.clock() * EffectSpeed + ShiftOffset;
			ShiftOffset = ShiftOffset + 0;
			local Color = Color3.fromHSV(math.abs(math.sin(Clock)), 1, 1);
			library.flags.theme_accent = Color;
			library:ChangeThemeOption("Accent", Color);
		end;
		if AccentEffect == "reverse shift" then
			local ShiftOffset = 0;
			local Clock = os.clock() * EffectSpeed + ShiftOffset;
			ShiftOffset = ShiftOffset - 0;
			local Color = Color3.fromHSV(math.abs(math.sin(Clock)), 1, 1);
			library.flags.theme_accent = Color;
			library:ChangeThemeOption("Accent", Color);
		end;
	end);
	local menu_other = page:new_section({
		name = "Other",
		size = "Fill",
		side = "right"
	});
	menu_other:new_keybind({
		name = "open / close",
		flag = "menu_toggle",
		default = Enum.KeyCode.End,
		mode = "Toggle",
		ignore = true,
		callback = function()
			library:Close();
		end
	});
	menu_other:new_toggle({
		name = "show keybinds list",
		flag = "keybind_list",
		callback = function(state)
			window:set_keybind_list_visibility(state);
		end
	});
	library:Close();
	menu_other:new_seperator({
		name = "theme"
	});
	local theme_tbl = {};
	for i, v in next, theme do
		table.insert(theme_tbl, i);
	end;
	menu_other:new_dropdown({
		name = "select theme:",
		flag = "theme_list",
		options = theme_tbl
	});
	menu_other:new_button({
		name = "load theme",
		callback = function()
			library:SetTheme(theme[library.flags.theme_list]);
			for option, picker in next, theme_pickers do
				picker:set(theme[library.flags.theme_list][option]);
			end;
		end
	});
	menu_other:new_seperator({
		name = "server"
	});
	menu_other:new_button({
		name = "rejoin",
		confirm = true,
		callback = function()
			(game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, game.JobId);
		end
	});
	menu_other:new_button({
		name = "copy join script",
		callback = function()
			setclipboard(("game:GetService(\"TeleportService\"):TeleportToPlaceInstance(%s, \"%s\")"):format(game.PlaceId, game.JobId));
		end
	});
	menu_other:new_button({
		name = "test",
		callback = function()
			library.notify("this is a test notif lol", 5);
		end
	});
end;
