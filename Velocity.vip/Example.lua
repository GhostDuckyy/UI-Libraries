local library = loadstring(game:HttpGet("https://github.com/GhostDuckyy/UI-Libraries/blob/main/Velocity.vip/source.lua?raw=true"))() do --// ui main
    local ui = {} do
        ui.window = library.init_window("Window", {size = Vector2.new(600, 420), name = "anis private cracked 2023 $$$ :troll:", drag_tween = true})
        ui.pages = {} do
            ui.pages.aiming = ui.window.create_page(ui.window, {name = "Aiming"})
            ui.pages.players = ui.window.create_page(ui.window, {name = "Players"})
            ui.pages.visuals = ui.window.create_page(ui.window, {name = "Visuals"})
            ui.pages.misc = ui.window.create_page(ui.window, {name = "Misc"})
            ui.pages.settings = ui.window.create_page(ui.window, {name = "Settings"})
        end
        ui.pages.visuals:set_default()
    end
    
    do --// setup ui
        do --// visuals tab
            do --// player esp
                local player_esp_section = ui.pages.players:new_section({name = "player esp", side = "left", size = 212})
                player_esp_section:new_toggle({name = "enabled", risky = false, flag = "player_esp_enabled", callback = function()
                    
                end})
                player_esp_section:new_toggle({name = "name", risky = false, flag = "player_esp_name_enabled", callback = function()
                    
                    settings.SetPreviewNameProperty("Visible", library.flags.player_esp_name_enabled)
                end}):new_colorpicker({default = Color3.fromRGB(255, 255, 255), flag = "player_esp_name_color", callback = function() 
                    
                    settings.SetPreviewNameProperty("Color", library.flags.player_esp_name_color)
                end})
                player_esp_section:new_toggle({name = "box", risky = false, flag = "player_esp_box_enabled", callback = function()
                    
                    settings.SetPreviewBoxVisible(library.flags.player_esp_box_enabled)
                end}):new_colorpicker({default = Color3.fromRGB(255, 255, 255), flag = "player_esp_box_color", callback = function() 
                    
                    settings.SetPreviewBoxColor(library.flags.player_esp_box_color, Color3.fromRGB(0, 0, 0))
                end})
                player_esp_section:new_toggle({name = "health bar", risky = false, flag = "player_esp_health_bar_enabled", callback = function()
                    
                    settings.SetPreviewHealthBarVisible(library.flags.player_esp_health_bar_enabled)
                end})
                
                player_esp_section:new_toggle({name = "distance", risky = false, flag = "player_esp_distance_enabled", callback = function()
                    
                    settings.SetPreviewDistanceProperty("Visible", library.flags.player_esp_distance_enabled)
                end}):new_colorpicker({default = Color3.fromRGB(255, 255, 255), flag = "player_esp_distance_color", callback = function() 
                    
                    settings.SetPreviewDistanceProperty("Color", library.flags.player_esp_distance_color)
                end})
                player_esp_section:new_toggle({name = "weapon", risky = false, flag = "player_esp_weapon_enabled", callback = function()
                    
                    settings.SetPreviewWeaponProperty("Visible", library.flags.player_esp_weapon_enabled)
                end}):new_colorpicker({default = Color3.fromRGB(255, 255, 255), flag = "player_esp_weapon_color", callback = function() 
                    
                    settings.SetPreviewWeaponProperty("Color", library.flags.player_esp_weapon_color)
                end})
        
                local esp_settings_container = player_esp_section:new_container({name = "settings", size = 50, scroll = true, open = false})
                esp_settings_container:new_toggle({name = "hide friendly players", risky = false, flag = "esp_settings_team_check", callback = function()
                    
                end})
                esp_settings_container:new_toggle({name = "use roblox display names", risky = false, flag = "esp_settings_display_names", callback = function()
                    
                end})
            end

            do --// world visuals
                local world_visuals_section = ui.pages.visuals:new_section({name = "world visuals", side = "right", size = 170})
            end

            do --// other drawings
                local drawings_section = ui.pages.visuals:new_section({name = "drawings", side = "left", size = 120})
                drawings_section:new_toggle({name = "watermark", risky = false, flag = "drawings_watermark_enabled", callback = function()
                    CHEAT_CLIENT.objects.watermark.Visible = library.flags.drawings_watermark_enabled
                end}):new_colorpicker({default = Color3.fromRGB(255, 255, 255), flag = "drawings_watermark_color", callback = function() 
                    CHEAT_CLIENT.objects.watermark.Color = library.flags.drawings_watermark_color
                end})
                local fov_circle_toggle = drawings_section:new_toggle({name = "fov circle", risky = false, flag = "drawings_fov_enabled", callback = function()
                    CHEAT_CLIENT.objects.fov_circle.Visible = library.flags.drawings_fov_enabled
                    CHEAT_CLIENT.objects.fov_circle_outline.Visible = library.flags.drawings_fov_enabled
                end})
                fov_circle_toggle:new_colorpicker({default = Color3.fromRGB(0, 0, 0), flag = "drawings_fov_outline_color", callback = function() 
                    CHEAT_CLIENT.objects.fov_circle_outline.Color = library.flags.drawings_fov_outline_color
                end})
                fov_circle_toggle:new_colorpicker({default = Color3.fromRGB(255, 255, 255), flag = "drawings_fov_color", callback = function() 
                    CHEAT_CLIENT.objects.fov_circle.Color = library.flags.drawings_fov_color
                end})
                drawings_section:new_slider({name = "radius", min = 75, max = 1000, default = 100, flag = "drawings_fov_radius", callback = function()
                    CHEAT_CLIENT.objects.fov_circle.Radius = library.flags.drawings_fov_radius
                    CHEAT_CLIENT.objects.fov_circle_outline.Radius = library.flags.drawings_fov_radius
                end})
                drawings_section:new_dropdown({name = "origin", options = {"mouse", "screen center"}, default = "mouse", flag = "drawings_origin", callback = function()
                    if library.flags.drawings_origin == "screen center" then
                        CHEAT_CLIENT.objects.watermark.Position = Vector2.new(CHEAT_CLIENT.camera.ViewportSize.X / 2, CHEAT_CLIENT.camera.ViewportSize.Y / 2 + game.GuiService:GetGuiInset(game.GuiService).Y)
                        CHEAT_CLIENT.objects.fov_circle.Position = Vector2.new(CHEAT_CLIENT.camera.ViewportSize.X / 2, CHEAT_CLIENT.camera.ViewportSize.Y / 2)
                        CHEAT_CLIENT.objects.fov_circle_outline.Position = Vector2.new(CHEAT_CLIENT.camera.ViewportSize.X / 2, CHEAT_CLIENT.camera.ViewportSize.Y / 2)
                    end
                end})
            end
        end
    
        do --// combat tab
            do --// aimlock
                local aimlock_section = ui.pages.aiming:new_section({name = "aimlock", side = "left", size = 140})
                aimlock_section:new_toggle({name = "enabled", risky = false, flag = "combat_aimlock_enabled"})
                aimlock_section:new_keybind({name = "lock on keybind", default = Enum.UserInputType.MouseButton2, mode = "Hold", flag = "combat_aimlock_keybind"})
                aimlock_section:new_slider({name = "aim speed", min = 0, max = 1, float = 0.01, default = 1, flag = "combat_aimlock_speed"})
                aimlock_section:new_dropdown({name = "target part", options = {"Head", "HumanoidRootPart"}, default = "Head", flag = "target_target_part"})
            end
        end

        do --// misc tab
            do --// player
                local player_section = ui.pages.misc:new_section({name = "player", side = "left", size = 90})
                player_section:new_toggle({name = "enable speed", risky = true, flag = "player_speed_toggle"}):new_slider({name = "walk speed", min = 0, max = 100, default = 0, flag = "player_speed_value"})
                player_section:new_toggle({name = "enable jump", risky = true, flag = "player_jump_toggle"}):new_slider({name = "jump height", min = 0, max = 20, default = 0, flag = "player_jump_value"})
                player_section:new_toggle({name = "semi godmode", risky = true, flag = "player_god_mode"})
            end

            do --// player
                local camera_section = ui.pages.visuals:new_section({name = "camera", side = "left", size = 115})
                camera_section:new_toggle({name = "enable fov", risky = false, flag = "camera_fov_toggle"}):new_slider({name = "walk speed", min = 0, max = 120, default = 0, flag = "camera_fov_value"})
                camera_section:new_toggle({name = "enable zoom", risky = false, flag = "camera_zoom_toggle"}):new_slider({name = "jump height", min = 0, max = 120, default = 0, flag = "camera_zoom_value"})
                camera_section:new_keybind({name = "zoom keybnind", default = Enum.UserInputType.MouseButton2, mode = "Hold", flag = "camera_zoom_keybind"})
            end
        end
    
        do --// settings tab
            do --// ui settings
                local ui_settings_section = ui.pages.settings:new_section({name = "ui settings", side = "left", size = 200})
                ui_settings_section:new_keybind({name = "open / close", default = Enum.KeyCode.End, mode = "Toggle", flag = "ui_keybind", callback = function()
                    library:SetOpen(library.flags.ui_keybind)
                end})
        
                ui_settings_section:new_colorpicker({name = "menu accent", default = Color3.fromRGB(255, 255, 255), flag = "ui_menu_accent", callback = function() 
                    library:ChangeThemeOption("Accent", library.flags.ui_menu_accent)
                end})
        
                ui_settings_section:new_button({name = "rejoin current server", confirm = true, callback = function()
                    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId)
                end})
        
                ui_settings_section:new_button({name = "copy LUA server connect", confirm = false, callback = function()
                    setclipboard(("game:GetService('TeleportService'):TeleportToPlaceInstance(%s, '%s')"):format(game.PlaceId, game.JobId))
                end})

                ui_settings_section:new_button({name = "copy JS server connect", confirm = false, callback = function()
                    setclipboard(("Roblox.GameLauncher.joinGameInstance(%s, %s)"):format(game.PlaceId, game.JobId))
                end})
            end
            
            do --// configs
                local config_section = ui.pages.settings:new_section({name = "configuration", side = "right", size = 200})
                local configs_dropdown = config_section:new_dropdown({name = "configs", options = {}, flag = "configs_dropdown"})
                for i,v in pairs(listfiles(settings.folder_name .. "/configs")) do
                    configs_dropdown:add(v:split([[\]])[2])
                end
                config_section:new_textbox({placeholder = "config name", flag = "configs_config_name"})
                config_section:new_button({name = "create", callback = function()
                    local config = ui.window:get_config()
                    writefile(settings.folder_name .. "/configs/" .. library.flags.configs_config_name .. ".txt", tostring(config))
                    configs_dropdown:add((settings.folder_name .. [[/configs\]] .. library.flags.configs_config_name .. ".txt"):split([[\]])[2])
                end})
                config_section:new_button({name = "save", callback = function()
                    local config = ui.window:get_config()
                    writefile(settings.folder_name .. "/configs/" .. library.flags.configs_dropdown, tostring(config))
                end})
                config_section:new_button({name = "load", callback = function()
                    library:load_config(settings.folder_name .. "/configs/" .. library.flags.configs_dropdown)
                end})
                config_section:new_button({name = "delete", callback = function()
                    delfile(settings.folder_name .. "/configs/" .. library.flags.configs_dropdown)
                    configs_dropdown:remove(library.flags.configs_dropdown)
                end})
            end
        end
    end
    
    library.notify("anis private cracked injected, press END to toggle user interface")
end

settings.TogglePreviewVisibility(true)
library:SetOpen(true)
