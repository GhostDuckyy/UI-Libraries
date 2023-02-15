Tab:
	Library:CreateTab(string name)

Section:
	Tab:CreateSection(string name)

Label:
	Section:CreateLabel(string name, string text)

Button:
	Section:CreateButton(string name, function callback)

Toggle:
	Section:CreateToggle(string name, function callback with first argument as a boolean representative)

Create Slider:
	Section:CreateSlider(string name, int minvalue, int maxvalue, int presetvalue, bool precisemode (decimals), function callback)

Create Color Picker:
	Section:CreateColorPicker(string name, color3 presetcolor, function callback with first argument as a color representative)

Create Dropdown:
	Section:CreateDropdown(string name, table options, int presetoption, function callback with first argument as a option representative)

Create Keybind:
	Section:CreateKeybind(string name, enum presetkeycode, bool keyboardonly, bool holdmode (hold down for true, let go for false), function callback (if hold mode then have a boolean representative as the first argument)
