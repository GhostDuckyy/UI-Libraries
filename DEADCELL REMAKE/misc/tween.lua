-- custom tween

local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/utility/main/Signal.lua"))()

local render = game:GetService("RunService").RenderStepped
local sqrt, sin, pi, halfpi, doublepi = math.sqrt, math.sin, math.pi, math.pi / 2, math.pi * 2
local next = next
local type = type
local setmetatable = setmetatable
local wait, spawn = task.wait, task.spawn

-- random variables for easing styles idk
local s = 1.70158
local s1 = 2.5949095

local p = 0.3
local p1 = 0.45

local Tween = {}
Tween.__index = Tween

local EasingStyle = {
    [Enum.EasingStyle.Linear] = {
        [Enum.EasingDirection.In] = function(delta)
            return delta
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return delta
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            return delta
        end
    },

    [Enum.EasingStyle.Cubic] = {
        [Enum.EasingDirection.In] = function(delta)
            return delta^3
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return (delta - 1)^3 + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return (4 * delta)^3
            else
                return (4 * (delta - 1))^3 + 1
            end
        end
    },

    [Enum.EasingStyle.Quad] = {
        [Enum.EasingDirection.In] = function(delta)
            return delta^2
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return -(delta - 1)^2 + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return (2 * delta)^2
            else
                return (-2 * (delta - 1))^2 + 1
            end
        end
    },

    [Enum.EasingStyle.Quart] = {
        [Enum.EasingDirection.In] = function(delta)
            return delta^4
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return -(delta - 1)^4 + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return (8 * delta)^4
            else
                return (-8 * (delta - 1))^4 + 1
            end
        end
    },

    [Enum.EasingStyle.Quint] = {
        [Enum.EasingDirection.In] = function(delta)
            return delta^5
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return (delta - 1)^5 + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return (16 * delta)^5
            else
                return (16 * (delta - 1))^5 + 1
            end
        end
    },

    [Enum.EasingStyle.Sine] = {
        [Enum.EasingDirection.In] = function(delta)
            return sin(halfpi * delta - halfpi)
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return sin(halfpi * delta)
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            return 0.5 * sin(pi * delta - pi / 2) + 0.5
        end
    },

    [Enum.EasingStyle.Exponential] = {
        [Enum.EasingDirection.In] = function(delta)
            return 2^(10 * delta - 10) - 0.001
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return 1.001 * -2^(-10 * delta) + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return 0.5 * 2^(20 * delta - 10) - 0.0005
            else
                return 0.50025 * -2^(-20 * delta + 10) + 1
            end
        end
    },

    [Enum.EasingStyle.Back] = {
        [Enum.EasingDirection.In] = function(delta)
            return delta^2 * (delta * (s + 1) - s)
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return (delta - 1)^2 * ((delta - 1) * (s + 1) + s) + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return (2 * delta * delta) * ((2 * delta) * (s1 + 1) - s1)
            else
                return 0.5 * ((delta * 2) - 2)^2 * ((delta * 2 - 2) * (s1 + 1) + s1) + 1
            end
        end
    },

    [Enum.EasingStyle.Bounce] = {
        [Enum.EasingDirection.In] = function(delta)
            if delta <= 0.25 / 2.75 then
                return -7.5625 * (1 - delta - 2.625 / 2.75)^2 + 0.015625
            elseif delta <= 0.75 / 2.75 then
                return -7.5625 * (1 - delta - 2.25 / 2.75)^2 + 0.0625
            elseif delta <= 1.75 / 2.75 then
                return -7.5625 * (1 - delta - 1.5 / 2.75)^2 + 0.25
            else
                return 1 - 7.5625 * (1 - delta)^2
            end
        end,

        [Enum.EasingDirection.Out] = function(delta)
            if delta <= 1 / 2.75 then
                return 7.5625 * (delta * delta)
            elseif delta <= 2 / 2.75 then
                return 7.5625 * (delta - 1.5 / 2.75)^2 + 0.75
            elseif delta <= 2.5 / 2.75 then
                return 7.5625 * (delta - 2.25 / 2.75)^2 + 0.9375
            else
                return 7.5625 * (delta - 2.625 / 2.75)^2 + 0.984375
            end
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.125 / 2.75 then
                return 0.5 * (-7.5625 * (1 - delta * 2 - 2.625 / 2.75)^2 + 0.015625)
            elseif delta <= 0.375 / 2.75 then
                return 0.5 * (-7.5625 * (1 - delta * 2 - 2.25 / 2.75)^2 + 0.0625)
            elseif delta <= 0.875 / 2.75 then
                return 0.5 * (-7.5625 * (1 - delta * 2 - 1.5 / 2.75)^2 + 0.25)
            elseif delta <= 0.5 then
                return 0.5 * (1 - 7.5625 * (1 - delta * 2)^2)
            elseif delta <= 1.875 / 2.75 then
                return 0.5 + 3.78125 * (2 * delta - 1)^2
            elseif delta <= 2.375 / 2.75 then
                return 3.78125 * (2 * delta - 4.25 / 2.75)^2 + 0.875
            elseif delta <= 2.625 / 2.75 then
                return 3.78125 * (2 * delta - 5 / 2.75)^2 + 0.96875
            else
                return 3.78125 * (2 * delta - 5.375 / 2.75)^2 + 0.9921875
            end
        end
    },

    [Enum.EasingStyle.Elastic] = {
        [Enum.EasingDirection.In] = function(delta)
            return -2^(10 * (delta - 1)) * sin(doublepi * (delta - 1 - p / 4) / p)
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return 2^(-10 * delta) * sin(doublepi * (delta - p / 4) / p) + 1
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return -0.5 * 2^(20 * delta - 10) * sin(doublepi * (delta * 2 - 1.1125) / p1)
            else
                return 0.5 * 2^(-20 * delta + 10) * sin(doublepi * (delta * 2 - 1.1125) / p1) + 1
            end
        end
    },

    [Enum.EasingStyle.Circular] = {
        [Enum.EasingDirection.In] = function(delta)
            return -sqrt(1 - delta^2) + 1
        end,

        [Enum.EasingDirection.Out] = function(delta)
            return sqrt(-(delta - 1)^2 + 1)
        end,

        [Enum.EasingDirection.InOut] = function(delta)
            if delta <= 0.5 then
                return -sqrt(-delta^2 + 0.25) + 0.5
            else
                return sqrt(-(delta - 1)^2 + 0.25) + 0.5
            end
        end
    }
}

local function lerp(value1, value2, alpha)
    if type(value1) == "number" then
        return value1 + ((value2 - value1) * alpha)
    end
        
    return value1:lerp(value2, alpha)
end

function Tween.new(object, info, properties)
    return setmetatable({
        Completed = Signal.new(),
        _object = object,
        _time = info.Time,
        _easing = EasingStyle[info.EasingStyle][info.EasingDirection],
        _properties = properties
    }, Tween)
end

function Tween:Play()
    -- Loop through every property to edit
    for property, value in next, self._properties do
        local start_value = self._object[property]

        spawn(function()
            local elapsed = 0
            while elapsed <= self._time and not self._cancelled do            
                local delta = elapsed / self._time

                -- Do the chosen EasingStyle's math
                local alpha = self._easing(delta)

                spawn(function()
                    self._object[property] = lerp(start_value, value, alpha)
                end)

                elapsed += render:Wait()
            end
            
            if not self._cancelled then
                self._object[property] = value
            end
        end)
    end

    spawn(function()
        wait(self._time)

        if not self._cancelled then
            self.Completed:Fire()
        end
    end)
end

function Tween:Cancel()
    self._cancelled = true
end

return Tween
