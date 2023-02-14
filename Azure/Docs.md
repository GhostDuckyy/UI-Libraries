
# Documentation
## Loadstring
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/preztel/AzureLibrary/master/uilib.lua", true))()
```
###  Custom Theme
#### How to add theme
Before the loadstring add this.
```lua
_G.CustomTheme = {
    Tab_Color = Color3.fromRGB(255, 255, 255),
    Tab_Text_Color = Color3.fromRGB(0, 0, 0),
    Description_Color = Color3.fromRGB(255, 255, 255),
    Description_Text_Color = Color3.fromRGB(0, 0, 0),
    Container_Color = Color3.fromRGB(255, 255, 255),
    Container_Text_Color = Color3.fromRGB(0, 0, 0),
    Button_Text_Color = Color3.fromRGB(0, 0, 0),
    Toggle_Box_Color = Color3.fromRGB(243, 243, 243),
    Toggle_Inner_Color = Color3.fromRGB(94, 255, 180),
    Toggle_Text_Color = Color3.fromRGB(0, 0, 0),
    Toggle_Border_Color = Color3.fromRGB(225, 225, 225),
    Slider_Bar_Color = Color3.fromRGB(243, 243, 243),
    Slider_Inner_Color = Color3.fromRGB(94, 255, 180),
    Slider_Text_Color = Color3.fromRGB(0, 0, 0),
    Slider_Border_Color = Color3.fromRGB(255, 255, 255),
    Dropdown_Text_Color = Color3.fromRGB(0, 0, 0),
    Dropdown_Option_BorderSize = 1,
    Dropdown_Option_BorderColor = Color3.fromRGB(235, 235, 235),
    Dropdown_Option_Color = Color3.fromRGB(255, 255, 255),
    Dropdown_Option_Text_Color = Color3.fromRGB(0, 0, 0)
}
```
#### Change the color to what you'd like.
## Tab
After u added the main Library Code you will have to create a Tab.
```lua
local AimbotTab = Library:CreateTab("Aimbot", "This is where you modify the Aimbot", true) 
--true means darkmode is enabled and false means its disabled
--if you leave it empty you have a custom theme.
```
![a](https://609170648-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-M8u7ma8cFA82xUPtanI%2F-M8vea4dhQzSv9BEPDf_%2F-M9-EcuorSr-HVoz148m%2FSkjermbilde.JPG?alt=media&token=1ccd99aa-a66c-410c-9bb9-0316d3068aba)

### Button
A button describes itself, it's a button you can click.
```lua
AimbotTab:CreateButton("Inf Jump",  function()  --you dont need "arg" for a button
	print("Clicked")
end)
```
![a](https://609170648-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-M8u7ma8cFA82xUPtanI%2F-M9-Fx0xwmoSp0aj8qY9%2F-M9-GT6yT5DOZ86RYnNo%2FSkjermbilde.JPG?alt=media&token=2f3602f2-4677-467f-a364-f16fc5aff11a)

### Toggle
When you added the Tab you can add multiple things into it, such as a toggle.
```lua
AimbotTab:CreateToggle("Enable Aimbot",  function(arg)  --the (arg) is if the checkbox is toggled or not
if arg then
	print("Aimbot is now : Enabled")
	else
	print("Aimbot is now : Disabled")
	end
end)
```
![a](https://609170648-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-M8u7ma8cFA82xUPtanI%2F-M8vea4dhQzSv9BEPDf_%2F-M9-FA7CdSN4_p3B39u5%2FSkjermbilde.JPG?alt=media&token=d9c7ddbf-f93d-4977-bd7b-e306dc2148cb)

### Slider
You can also add a slider.
```lua
AimbotTab:CreateSlider("Fov Radius",  0,  600,  function(arg)  --the (arg) is the sliders value
	print("Fov Radius is set to:", arg)
end)
```
![a](https://609170648-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-M8u7ma8cFA82xUPtanI%2F-M8vea4dhQzSv9BEPDf_%2F-M9-Fgmito2wUwxj-55H%2FSkjermbilde.JPG?alt=media&token=6c65d6c9-64d7-4cd4-b2a9-44e341e31b7a)

### Dropdown
You can also add a dropdown. A dropdown is a list of options you can choose.
```lua
AimbotTab:CreateDropDown("Aimbot Part",  {"Head",  "Torso"},  function(arg)  --the (arg) is the option you choose
	if arg ==  "Head"  then
		print("HEahshoot")
	elseif arg ==  "Torso"  then
		print("trrrrso")
	end
end)
```
![a](https://609170648-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-M8u7ma8cFA82xUPtanI%2F-M9-Fx0xwmoSp0aj8qY9%2F-M9-G-5lb5XlU6NgsPiR%2FSkjermbilde.JPG?alt=media&token=03ad1bfb-8da7-4363-ab91-b4559ca345de)
#####	 (This is what the dropdown will look like when its opened.)
![a](https://609170648-files.gitbook.io/~/files/v0/b/gitbook-legacy-files/o/assets%2F-M8u7ma8cFA82xUPtanI%2F-M9-Fx0xwmoSp0aj8qY9%2F-M9-GCJOC-x6oy-XLRRF%2FSkjermbilde.JPG?alt=media&token=a71fa4e9-877f-49e3-a7f2-7c4346ea5bfe)
##### (What it looks like when its not opened.)

### Textbox
```lua
AimbotTab:CreateTextbox("Whitelist Player",  function(arg)  --arg is what the text is inside the textbox
	print("Whitelisted: "  .. arg)
end)
```
