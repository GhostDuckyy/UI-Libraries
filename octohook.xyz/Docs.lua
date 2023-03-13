--[[
    // -- Notes -- \\

    After you create the menu, set library.menu to that menu you created by doing library.menu = menu
    After creating all your tabs and options, refresh the menu so they update by doing library.menu:refresh()

    // -- Documentation -- \\

    option:set_enabled(enabled <boolean>)
    option:set_text(text <string>)

    -- menu
    local menu = library:create('menu', properties <table>)
    library.menu = menu

    text <string>
    size <udim2>
    position <udim2>


    -- tab
    local tab = menu:tab(properties <table>)

    text <string>
    order <number>

    -- section
    local section = tab:section(properties <table>)

    text <string>
    side <number>


    -- toggle
    local toggle = section:toggle(properties <table>)
    
    default <boolean>
    text <string>
    order <number>
    enabled <boolean>
    callback <function>
    

    -- slider
    local slider = section:slider(properties <table>)
    local slider = toggle:slider(properties <table>)
    
    default <number>
    min <number>
    max <number>
    increment <number>
    text <string>
    order <number>
    enabled <boolean>
    callback <function>


    -- colorpicker
    local colorpicker = section:colorpicker(properties <table>)
    local colorpicker = toggle:colorpicker(properties <table>)
    
    default <color3>
    default_opacity <number>
    text <string>
    order <number>
    enabled <boolean>
    callback <function> [color, opacity]


    -- keybind
    local keybind = section:keybind(properties <table>)
    local keybind = toggle:keybind(properties <table>)
    
    default <keycode> <userinputtype>
    mode <string> [toggle, hold, always]
    text <string>
    order <number>
    enabled <boolean>
    callback <function>


    -- textbox
    local textbox = section:textbox(properties <table>)
    local textbox = toggle:textbox(properties <table>)
    
    default <string>
    placeholder <string>
    text <string>
    order <number>
    enabled <boolean>
    callback <function>

    -- button
    local button = section:button(properties <table>)
    
    text <string>
    order <number>
    enabled <boolean>
    callback <function>

    -- separator
    local separator = section:separator(properties <table>)
    
    text <string>
    order <number>
    enabled <boolean>
]]
