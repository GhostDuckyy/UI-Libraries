--[[
    Frostys UI LIB:

    Formatted Text: 
        All text inputs can be modified with different "fake html" tags
        You can use multiples of these in a single string
        eg. "<bold><red>error<sourcesans><white>hello"

        color list:
            Red
            BrightRed
            Blue
            White
            Green
            Purple
            Cyan
            Black
        font list:
            Arial
            SourceSans
            Bold
            Semibold
            Light
            Fantasy

    function main(settings) (eg. "local engine = main()" ) {
        @settings - a dictionary that contains the ui lib's settings
        description = Starts the ui lib program and returns a engine function which is a table

        method init(gui) (eg. "local library = engine:init()" ) {
            description = Initializes a new gui for windows and returns a table to create a column

            method create(type, ...) (eg. "local window = library:create("window", "im a window")" ) {
                description = Allows the ability to create a window and returns the window
                @type - only 1 type which is "window"
                @... - the [string title] & [optional dictionary settings] of the window, the settings are the following:
                    default_size - a UDim2 value which is the default size of the window,
                    default_position - a UDim2 value which is the default position of the window,
                    visible - a boolean which is the starting visibility of the window,

                    resizable - a boolean which says if the window is resizable in game,
                    min - an array with the first and second value being the x,y in pixels being the minimum of what the window can be resized to,
                    max - an array with the first and second value being the x,y in pixels being the maxomum of what the window can be resized to,

                    icon - a rbxassetid containing the icon that will be showed on the window
                
                method create(type, x_size) (eg. "local column = window:create("column", 150)" ) {
                    @type - only 1 type which is "column"
                    @x_size - the x_size in pixels of the column
                    description = Creates a new column for new values to be inputted

                    method create(type, ...) (eg. "local slider = column:create("slider", "im a slider", 0, 100, print)" ) {
                        @type - the values you can create [string]
                        @... - the arguments for the value created
                        description = Creates a new value with the given arguments

                        values: 
                            slider: [string title] [int current] [int max] [function change_function] [(optional) string unit_label]
                            toggle: [string title] [boolean is_toggled] [function change_function]
                            label: [array settings = {text: [string text], font: [string RobloxFont], color: [Color3], size: [int roblox font size]}]
                            dropdown: [string title] [array options with string values as titles] [int selected_number] [function change_function]
                            color_picker: [string title] [Color3 start_color] [function change_function]
                            button: [string title] [function click_function]
                    }
                }
                    
            }

        }

    }

    example code:

    local engine = loadstring(game:HttpGet("https://pastebin.com/raw/iuMkXNRS"))();

    local settings = {
            theme = {
                images = {
                    open_ui_icon = "rbxassetid://4521836217",
                    close_ui_icon = "rbxassetid://4510354080",
                };
                
                colors = {
                    ["primary color"] = Color3.fromRGB(192, 57, 43),
                    ["secondary color"] = Color3.fromRGB(37, 41, 43),
                    ["drag click"] = Color3.fromRGB(106, 30, 23),
                    ["on color"] = Color3.fromRGB(48, 255, 162),
                    ["exit click"] = Color3.fromRGB(255, 50, 50),
                    ["text color"] = Color3.fromRGB(255, 255, 255)
                },
                
                font = "SourceSans",
                hotkey = Enum.KeyCode.RightShift
            };
    }

    local engine = engine(settings);

    local library = engine:init();

    local window = library:create("window", "<semibold>windows", {
        resizable = false,
        default_position = UDim2.new(0, 500, 0, 100),
        default_size = UDim2.new(0, 325, 0, 150)
    });
        
    local column1 = window:create("column", 150);
    column1:create("toggle", "am cool", false, print);
    column1:create("dropdown", "am dropdown", {[1] = "hello", [2] = "<green>hello2", [3] = "<blue>hello3"}, 1, print);
    column1:create("slider", "coolness %", 0, 100, print, "%");
    column1:create("color_picker", "coolness color", Color3.fromRGB(255,0,0), print);
    column1:create("button", "click me for cool", print);

    local column2 = window:create("column", 150);
    column2:create("label", {Text = "a text that <green>can change<purple> \ncolors!", FontSize = 16, Font = "SourceSans", Color3.fromRGB(255,255,255)})

]]
