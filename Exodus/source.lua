--[[
    Render object class thing for UI Libraries
]]

repeat task.wait() until game:IsLoaded()

-- Localization
local fromRGB = Color3.fromRGB
local newUDim2 = UDim2.new
local newVector2 = Vector2.new
local newDrawing = Drawing.new
local newInstance = Instance.new
local remove = table.remove
local spawn = task.spawn
local genv = getgenv()
local getupvalue = debug.getupvalue

local Signal={}local Connection={}Signal.__index=Signal;Connection.__index=Connection;function Connection.new(signal,callback)local connection=signal._signal:Connect(callback)signal._count+=1;signal.Active=true;return setmetatable({Connected=true,_signal=signal,_connection=connection},Connection)end;function Connection:Disconnect()self._connection:Disconnect()self.Connected=false;self._signal._count-=1;self._signal.Active=self._signal._count>0 end;function Signal.new()local bindableEvent=newInstance("BindableEvent")return setmetatable({Active=false,_bindableEvent=bindableEvent,_signal=bindableEvent.Event,_count=0},Signal)end;function Signal:OnConnect(callback)self._onConnect=callback end;function Signal:Fire(...)self._bindableEvent:Fire(...)end;function Signal:Connect(callback)if self._onConnect then self._onConnect()end;return Connection.new(self,callback)end;function Signal:Wait()return self._signal:Wait()end;function Signal:Destroy()self._bindableEvent:Destroy()self.Active=false;setmetatable(self,nil)end;Signal.DisconnectAll=Signal.Destroy;Signal.Disconnect=Signal.Destroy
local List={}do List.__index=List;function List.new(object,padding)return setmetatable({_contentSize=0,_padding=padding,_positions={},_object=object,_objects={},_indexes={},_sizes={}},List)end;function List:AddObject(object)local size=object.AbsoluteSize.Y;local idx=#self._objects+1;local padding=#self._objects*self._padding;local position=self._contentSize;if object.Parent~=self._object then object.Parent=self._object end;object.Position=newUDim2(0,0,0,position)self._objects[idx]=object;self._positions[object]=position;self._indexes[object]=idx;self._sizes[object]=size;self._contentSize+=size+self._padding end;function List:RemoveObject(object)local size=self._sizes[object]+self._padding;local idx=self._indexes[object]for i,obj in next,self._objects do if i>idx then self._indexes[obj]-=1;self._positions[obj]-=size;obj.Position=newUDim2(0,0,0,self._positions[obj])end end;remove(self._objects,idx)self._contentSize-=size end;function List:UpdateObject(object)local diff=object.AbsoluteSize.Y-self._sizes[object]local idx=self._indexes[object]for i,obj in next,self._objects do if i>idx then self._positions[obj]+=diff;obj.Position=newUDim2(0,0,0,self._positions[obj])end end;self._sizes[object]+=diff;self._contentSize+=diff end end
local Tween={}do Tween.__index=Tween;local render=game:GetService("RunService").RenderStepped;local sqrt,sin,pi,halfpi,doublepi=math.sqrt,math.sin,math.pi,math.pi/2,math.pi*2;local type=type;local wait=task.wait;local s=1.70158;local s1=2.5949095;local p=0.3;local p1=0.45;local EasingStyle={[Enum.EasingStyle.Linear]={[Enum.EasingDirection.In]=function(delta)return delta end,[Enum.EasingDirection.Out]=function(delta)return delta end,[Enum.EasingDirection.InOut]=function(delta)return delta end},[Enum.EasingStyle.Cubic]={[Enum.EasingDirection.In]=function(delta)return delta^3 end,[Enum.EasingDirection.Out]=function(delta)return(delta-1)^3+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return(4*delta)^3 else return(4*(delta-1))^3+1 end end},[Enum.EasingStyle.Quad]={[Enum.EasingDirection.In]=function(delta)return delta^2 end,[Enum.EasingDirection.Out]=function(delta)return-(delta-1)^2+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return(2*delta)^2 else return(-2*(delta-1))^2+1 end end},[Enum.EasingStyle.Quart]={[Enum.EasingDirection.In]=function(delta)return delta^4 end,[Enum.EasingDirection.Out]=function(delta)return-(delta-1)^4+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return(8*delta)^4 else return(-8*(delta-1))^4+1 end end},[Enum.EasingStyle.Quint]={[Enum.EasingDirection.In]=function(delta)return delta^5 end,[Enum.EasingDirection.Out]=function(delta)return(delta-1)^5+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return(16*delta)^5 else return(16*(delta-1))^5+1 end end},[Enum.EasingStyle.Sine]={[Enum.EasingDirection.In]=function(delta)return sin(halfpi*delta-halfpi)end,[Enum.EasingDirection.Out]=function(delta)return sin(halfpi*delta)end,[Enum.EasingDirection.InOut]=function(delta)return 0.5*sin(pi*delta-pi/2)+0.5 end},[Enum.EasingStyle.Exponential]={[Enum.EasingDirection.In]=function(delta)return 2^(10*delta-10)-0.001 end,[Enum.EasingDirection.Out]=function(delta)return 1.001*-2^(-10*delta)+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return 0.5*2^(20*delta-10)-0.0005 else return 0.50025*-2^(-20*delta+10)+1 end end},[Enum.EasingStyle.Back]={[Enum.EasingDirection.In]=function(delta)return delta^2*(delta*(s+1)-s)end,[Enum.EasingDirection.Out]=function(delta)return(delta-1)^2*((delta-1)*(s+1)+s)+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return(2*delta*delta)*((2*delta)*(s1+1)-s1)else return 0.5*((delta*2)-2)^2*((delta*2-2)*(s1+1)+s1)+1 end end},[Enum.EasingStyle.Bounce]={[Enum.EasingDirection.In]=function(delta)if delta<=0.25/2.75 then return-7.5625*(1-delta-2.625/2.75)^2+0.015625 elseif delta<=0.75/2.75 then return-7.5625*(1-delta-2.25/2.75)^2+0.0625 elseif delta<=1.75/2.75 then return-7.5625*(1-delta-1.5/2.75)^2+0.25 else return 1-7.5625*(1-delta)^2 end end,[Enum.EasingDirection.Out]=function(delta)if delta<=1/2.75 then return 7.5625*(delta*delta)elseif delta<=2/2.75 then return 7.5625*(delta-1.5/2.75)^2+0.75 elseif delta<=2.5/2.75 then return 7.5625*(delta-2.25/2.75)^2+0.9375 else return 7.5625*(delta-2.625/2.75)^2+0.984375 end end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.125/2.75 then return 0.5*(-7.5625*(1-delta*2-2.625/2.75)^2+0.015625)elseif delta<=0.375/2.75 then return 0.5*(-7.5625*(1-delta*2-2.25/2.75)^2+0.0625)elseif delta<=0.875/2.75 then return 0.5*(-7.5625*(1-delta*2-1.5/2.75)^2+0.25)elseif delta<=0.5 then return 0.5*(1-7.5625*(1-delta*2)^2)elseif delta<=1.875/2.75 then return 0.5+3.78125*(2*delta-1)^2 elseif delta<=2.375/2.75 then return 3.78125*(2*delta-4.25/2.75)^2+0.875 elseif delta<=2.625/2.75 then return 3.78125*(2*delta-5/2.75)^2+0.96875 else return 3.78125*(2*delta-5.375/2.75)^2+0.9921875 end end},[Enum.EasingStyle.Elastic]={[Enum.EasingDirection.In]=function(delta)return-2^(10*(delta-1))*sin(doublepi*(delta-1-p/4)/p)end,[Enum.EasingDirection.Out]=function(delta)return 2^(-10*delta)*sin(doublepi*(delta-p/4)/p)+1 end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return-0.5*2^(20*delta-10)*sin(doublepi*(delta*2-1.1125)/p1)else return 0.5*2^(-20*delta+10)*sin(doublepi*(delta*2-1.1125)/p1)+1 end end},[Enum.EasingStyle.Circular]={[Enum.EasingDirection.In]=function(delta)return-sqrt(1-delta^2)+1 end,[Enum.EasingDirection.Out]=function(delta)return sqrt(-(delta-1)^2+1)end,[Enum.EasingDirection.InOut]=function(delta)if delta<=0.5 then return-sqrt(-delta^2+0.25)+0.5 else return sqrt(-(delta-1)^2+0.25)+0.5 end end}}local function lerp(value1,value2,alpha)if type(value1)=="number"then return value1+((value2-value1)*alpha)end;return value1:lerp(value2,alpha)end;function Tween.new(object,info,properties)return setmetatable({Completed=Signal.new(),_object=object,_time=info.Time,_easing=EasingStyle[info.EasingStyle][info.EasingDirection],_properties=properties},Tween)end;function Tween:Play()for property,value in next,self._properties do local start_value=self._object[property]spawn(function()local elapsed=0;while elapsed<=self._time and not self._cancelled do local delta=elapsed/self._time;local alpha=self._easing(delta)spawn(function()self._object[property]=lerp(start_value,value,alpha)end)elapsed+=render:Wait()end;if not self._cancelled then self._object[property]=value end end)end;spawn(function()wait(self._time)if not self._cancelled then self.Completed:Fire()end end)end;function Tween:Cancel()self._cancelled=true end end

-- Library
genv.render_cache = render_cache or {}

genv.clear_renders = clear_renders or function()
    for _, render in next, render_cache do
        render:Destroy(true)
    end

    genv.render_cache = {}
end

local services = setmetatable({}, {
    __index = function(self, key)
        if not rawget(self, key) then
            local service = game:GetService(key)
            rawset(self, service, service)

            return service
        end
    
        return rawget(self, key)
    end
})

local is_synX = islclosure(newDrawing)

local line_mt = is_synX and getupvalue(newDrawing, 4)
local newrender = is_synX and getupvalue(newDrawing, 1) or newDrawing

local destroy = is_synX and getupvalue(line_mt.__index, 3) or function(drawing)
    drawing:Remove()
end

local setproperty = is_synX and getupvalue(line_mt.__newindex, 4) or setrenderproperty or function(object, property, value)
    object[property] = value
end

local getproperty = is_synX and getupvalue(line_mt.__index, 4) or getrenderproperty or function(object, property)
    return object[property]
end

local function round_position(position)
    return newVector2(math.floor(position.X), math.floor(position.Y));
end

local function queue_property_set(object, property, value)
    if object.AbsoluteVisible then
        setproperty(object._render, property, value)
    else
        object._queue[property] = value
    end
end

local Render = {Fonts = Drawing.Fonts, ZIndex = 1000000}

local classes = {
    Text = {
        Parent = {nil, "table", "nil"},
        Visible = {true, "boolean"},
        ZIndex = {1, "number"},
        Transparency = {1, "number"},
        Ignored = {true, "boolean"},
        Color = {fromRGB(255, 255, 255), "Color3"},
        Text = {"Text", "string"},
        Font = {Render.Fonts.Plex, "number"},
        Center = {false, "boolean"},
        Size = {13, "number"},
        Outline = {true, "boolean"},
        OutlineColor = {fromRGB(0, 0, 0), "Color3"},
        Position = {newUDim2(0, 0, 0, 0), "UDim2"},
    },

    Image = {
        Parent = {nil, "table", "nil"},
        Visible = {true, "boolean"},
        ZIndex = {1, "number"},
        Transparency = {1, "number"},
        Ignored = {false, "boolean"},
        Data = {"", "string"},
        OutlineColor = {fromRGB(0, 0, 0), "Color3"},
        Outline = {false, "boolean"},
        Size = {newUDim2(0, 100, 0, 100), "UDim2"},
        Position = {newUDim2(0, 0, 0, 0), "UDim2"}
    },

    Square = {
        Parent = {nil, "table", "nil"},
        Visible = {true, "boolean"},
        ZIndex = {1, "number"},
        Transparency = {1, "number"},
        Ignored = {false, "boolean"},
        Color = {fromRGB(255, 255, 255), "Color3"},
        Size = {newUDim2(0, 100, 0, 100), "UDim2"},
        Position = {newUDim2(0, 0, 0, 0), "UDim2"},
        OutlineColor = {fromRGB(0, 0, 0), "Color3"},
        Outline = {true, "boolean"},
        Thickness = {1, "number"},
        Filled = {true, "boolean"}
    }
}

local objects = {}

local function calculate_udim2(position, size)
    local x = size.X * position.X.Scale
    local y = size.Y * position.Y.Scale

    local newposition = newVector2(x + position.X.Offset, y + position.Y.Offset)

    return newposition
end

local function mouse_over(object)
    local posX, posY = object.AbsolutePosition.X, object.AbsolutePosition.Y
    local size = object.AbsoluteSize or object.TextBounds
    local sizeX, sizeY = posX + size.X, posY + size.Y
    local position = services.UserInputService:GetMouseLocation()

    if position.X >= posX and position.Y >= posY and position.X <= sizeX and position.Y <= sizeY then
        return true
    end

    return false
end

local function mouse_over_higher_object(object)
    local position = services.UserInputService:GetMouseLocation()

    for obj, _ in next, objects do
        if obj.AbsoluteVisible and obj.Transparency >= object.Transparency and obj.ZIndex > object.ZIndex then
            local posX, posY = obj.AbsolutePosition.X, obj.AbsolutePosition.Y
            local size = obj.AbsoluteSize or obj.TextBounds
            local sizeX, sizeY = posX + size.X, posY + size.Y

            if position.X >= posX and position.Y >= posY and position.X <= sizeX and position.Y <= sizeY then
                return true
            end
        end
    end
end

local function count_table(tbl)
    local count = 0

    for _, _ in next, tbl do
        count += 1
    end

    return count
end

local events = {}
local changed_events = {}

services.UserInputService.InputBegan:Connect(function(input, gpe)
    for object, events in next, events do
        if events.MouseButton1Down.Active or events.MouseButton1Click.Active or events.InputEnded.Active or events.InputBegan.Active then
            if object.AbsoluteVisible and mouse_over(object) and not mouse_over_higher_object(object) then
                if events.InputBegan.Active then
                    events._inputBegan[input] = true
                    events.InputBegan:Fire(input, gpe)
                end

                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    events._mouseDown = true

                    if events.MouseButton1Down.Active then
                        events.MouseButton1Down:Fire()
                    end
                end
            end
        end
    end
end)

local last_update = tick()

services.UserInputService.InputChanged:Connect(function(input, gpe)
    if tick() - last_update > 0.1 then
        last_update = tick()
        for object, events in next, changed_events do
            if events.MouseEnter.Active or events.MouseLeave.Active or events.InputChanged.Active then
                if object.AbsoluteVisible and mouse_over(object) then
                    if not events._mouseEntered and events.MouseEnter.Active then
                        events.MouseEnter:Fire(input)
                    end

                    events._mouseEntered = true

                    if events.InputChanged.Active then
                        events.InputChanged:Fire(input, gpe)
                    end
                elseif events._mouseEntered then
                    events._mouseEntered = false

                    if events.MouseLeave.Active then
                        events.MouseLeave:Fire()
                    end
                end
            end
        end
    end
end)

services.UserInputService.InputEnded:Connect(function(input, gpe)
    for object, events in next, events do
        if events.MouseButton1Up.Active or events.MouseButton1Click.Active or events.InputEnded.Active then
            if events._inputBegan[input] then
                events._inputBegan[input] = false

                if events.InputEnded.Active then
                    events.InputEnded:Fire(input, gpe)
                end
            end

            if object.AbsoluteVisible and mouse_over(object) and not mouse_over_higher_object(object) then
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if events.MouseButton1Up.Active then
                        events.MouseButton1Up:Fire()
                    end

                    if events._mouseDown and events.MouseButton1Click.Active then
                        events.MouseButton1Click:Fire()
                    end

                    events._mouseDown = false
                end
            end
        end
    end
end)

Render.__newindex = function(self, property, value)
    if self._exists then
        local properties = classes[self._class]
        if properties[property] and not properties[property].readonly and (typeof(value) == properties[property][2] or typeof(value) == properties[property][3]) then
            self:Set(property, value)
        end
    end
end

Render.__index = function(self, property)
    return rawget(self, "_properties")[property] == nil and (Render[property] or rawget(self, "_events")[property] or rawget(self, property)) or rawget(self, "_properties")[property]
end

function Render.new(class)
    if classes[class] then
        local object = {
            _render = newrender(class),
            _children = {},
            _events = {
                MouseButton1Click = Signal.new(),
                MouseButton1Down = Signal.new(),
                MouseButton1Up = Signal.new(),
                MouseEnter = Signal.new(),
                MouseLeave = Signal.new(),
                InputBegan = Signal.new(),
                InputChanged = Signal.new(),
                InputEnded = Signal.new(),
                _mouseEntered = false,
                _mouseDown = false,
                _inputBegan = {}
            },
            _properties = {},
            _cacheIndex = #genv.render_cache + 1,
            _exists = true,
            _queue = {},
            _childrenIndex = nil,
            _class = class,
            _outline = nil,
            _list = nil,
            _listConnection = nil,
            Changed = Signal.new()
        }

        genv.render_cache[object._cacheIndex] = object
        events[object] = object._events

        object._events.MouseEnter:OnConnect(function()
            changed_events[object] = object._events
        end)

        object._events.MouseLeave:OnConnect(function()
            changed_events[object] = object._events
        end)

        object._events.InputChanged:OnConnect(function()
            changed_events[object] = object._events
        end)

        setmetatable(object, Render)
        objects[object] = true

        for property, values in next, classes[class] do
            if not values.readonly then
                object:Set(property, values[1])
            end
        end
        
        return object
    end
end

function Render:Set(property, value)
    self.Changed:Fire(property)

    if property == "Parent" then
        if self._properties.Parent then
            remove(self.Parent._children, self._childrenIndex)
        end

        if value ~= nil then
            value._children[#value._children + 1] = self
            rawset(self, "_childrenIndex", #value._children)

            if value._list then
                value._list:AddObject(self)
            end
        end
        
        self._properties.Parent = value

        self:Set("Position", self.Position or newUDim2(0, 0, 0, 0))

        if self._class ~= "Text" then
            self:Set("Size", self.Size or newUDim2(0, 100, 0, 100))
        end

        self:Set("Visible", self.Visible == nil and true or self.Visible)
        
        return
    end

    if property == "Position" then
        local new_position

        if self.Parent then
            new_position = self.Parent.AbsolutePosition + calculate_udim2(value, self.Parent.AbsoluteSize)
        else
            new_position = calculate_udim2(value, workspace.CurrentCamera.ViewportSize)
        end

        new_position = round_position(new_position);
        self._properties.Position = value

        if self._outline and self.AbsoluteVisible then
            setproperty(self._outline, "Position", new_position - newVector2(1, 1))
        end

        self._properties.AbsolutePosition = new_position
        queue_property_set(self, "Position", new_position)

        self:UpdateChildren("Position")

        return
    end

    if property == "Size" then
        if typeof(value) == "UDim2" then
            local new_size

            if self.Parent then
                new_size = calculate_udim2(value, self.Parent.AbsoluteSize)
            else
                new_size = calculate_udim2(value, workspace.CurrentCamera.ViewportSize)
            end

            if self._outline and self.AbsoluteVisible then
                setproperty(self._outline, "Size", new_size + newVector2(2, 2))
            end
            
            self._properties.AbsoluteSize = new_size
            self._properties.Size = value

            if self.Parent and self.Parent._list then
                self.Parent._list:UpdateObject(self)
            end

            queue_property_set(self, "Size", new_size)

            self:UpdateChildren("Size")
            self:UpdateChildren("Position")

            return
        else
            self._properties.Size = value

            setproperty(self._render, "Size", value) 
            self._properties.TextBounds = getproperty(self._render, "TextBounds")
    
            return
        end
    end

    if property == "Font" then
        self._properties.Font = value

        setproperty(self._render, "Font", value) 
        self._properties.TextBounds = getproperty(self._render, "TextBounds")

        return
    end

    if property == "Ignored" then
        if value then
            objects[self] = nil
        else
            objects[self] = true
        end

        self._properties.Ignored = value
        return
    end

    if property == "Outline" and self._class ~= "Text" then
        if value then
            rawset(self, "_outline", newrender("Square"))
            setproperty(self._outline, "Visible", self._properties.AbsoluteVisible)
            setproperty(self._outline, "Color", self.OutlineColor or fromRGB(0, 0, 0))
            setproperty(self._outline, "Filled", true)
            setproperty(self._outline, "Size", self.AbsoluteSize + newVector2(2, 2))
            setproperty(self._outline, "Position", self.AbsolutePosition - newVector2(1, 1))
            setproperty(self._outline, "ZIndex", (self.ZIndex or 1) - 1)
        elseif self._outline then
            destroy(self._outline)
            rawset(self, "_outline", nil)
        end

        self._properties.Outline = value
        return
    end

    if property == "OutlineColor" and self._class ~= "Text" then
        if self._outline then
            setproperty(self._outline, "Color", value)
        end

        self._properties.OutlineColor = value
        return
    end

    if property == "Visible" then
        local new_visible

        if self.Parent then
            new_visible = value and self.Parent.AbsoluteVisible or false
        else
            new_visible = value
        end

        if self._outline then
            setproperty(self._outline, "Visible", new_visible)
        end

        self._properties.AbsoluteVisible = new_visible
        self._properties.Visible = value

        self:UpdateChildren("Visible")
        
        if new_visible then
            self:UpdateQueue()
        end

        setproperty(self._render, "Visible", new_visible)

        return
    end

    if property == "Transparency" then
        if value ~= value then
           value = 0 
        end
        
        if self._outline then
            setproperty(self._outline, "Transparency", value)
        end
    end

    if property == "ZIndex" then
        if self._outline and self.AbsoluteVisible then
            setproperty(self._outline, "ZIndex", value + Render.ZIndex - 1)
        end

        self._properties.ZIndex = value
        queue_property_set(self, "ZIndex", value + Render.ZIndex)

        return
    end

    if property == "Text" then
        self._properties.Text = value

        setproperty(self._render, "Text", value)
        self._properties.TextBounds = getproperty(self._render, "TextBounds")

        return
    end

    self._properties[property] = value
    queue_property_set(self, property, value) 
end

function Render:UpdateQueue()
    for property, value in next, self._queue do
        setproperty(self._render, property, value)

        if self._outline and (property == "Position" or property == "Size" or property == "ZIndex") then
            setproperty(self._outline, property, property == "ZIndex" and value - 1 or property == "Size" and value + newVector2(2, 2) or property == "Position" and value - newVector2(1, 1))
        end

        self:UpdateChildren(property)
    end

    self._queue = {}
end

function Render:UpdateChildren(property)
    if property == "Position" then
        for _, child in next, self._children do
            local new_position = round_position(self.AbsolutePosition + calculate_udim2(child.Position, self.AbsoluteSize));
            child._properties.AbsolutePosition = new_position

            queue_property_set(child, "Position", new_position)
            
            if child._outline and self.AbsoluteVisible then
                setproperty(child._outline, "Position", new_position - newVector2(1, 1))
            end

            if child._class ~= "Text" then
                child:UpdateChildren("Position")
            end
        end
    elseif property == "Visible" then
        for _, child in next, self._children do
            local new_visible = child._properties.Visible and self.AbsoluteVisible
            child._properties.AbsoluteVisible = new_visible

            setproperty(child._render, "Visible", new_visible)
                
            if child._outline then
                setproperty(child._outline, "Visible", new_visible)
            end

            if new_visible then
                child:UpdateQueue()
            end

            child:UpdateChildren("Visible")
        end
    elseif property == "Size" then
        for _, child in next, self._children do
            if child._class ~= "Text" then
                local new_size = calculate_udim2(child.Size, self.AbsoluteSize)
                child._properties.AbsoluteSize = new_size

                queue_property_set(child, "Size", new_size)
                
                if child._outline and self.AbsoluteVisible then
                    setproperty(child._outline, "Size", new_size + newVector2(2, 2))
                end

                child:UpdateChildren("Size")
            end
        end
    end
end

function Render:Destroy(from_clear)
    if self._exists then
        rawset(self, "_exists", false)
        destroy(self._render)

        if self._outline then
            destroy(self._outline)
        end

        for _, event in next, self._events do
            if typeof(event) == "table" and event.Destroy then
                event:Destroy()
            end
        end

        if not from_clear then
            remove(genv.render_cache, self._cacheIndex)

            for i, object in next, genv.render_cache do
                if i >= self._cacheIndex then
                    rawset(object, "_cacheIndex", object._cacheIndex - 1)
                end
            end

            local i, child = next(self._children)

            while child do
                remove(self._children, i)
                child:Destroy()
                
                i, child = next(self._children)
            end
        end

        objects[self] = nil

        if events[self] then
            events[self] = nil
        end

        if self.Parent then
            if self.Parent._children[self._childrenIndex] == self then
                remove(self.Parent._children, self._childrenIndex)
            end

            if self.Parent._list and self._class ~= "Text" then
                self.Parent._list:RemoveObject(self)
            end
        end

        if self._listConnection then
            self._listConnection:Disconnect()
        end
    end
end

function Render:GetChildren()
    return self._children
end

function Render:AddList(padding)
    if self._class == "Square" then
        rawset(self, "_list", List.new(self.AbsolutePosition, padding))

        for _, child in next, self._children do
            self._list:AddObject(child)
        end
    end
end

function Render:Tween(info, values)
    if self._currentTween then
        self._currentTween:Cancel()
    end

    local animation = Tween.new(self, info, values)
    animation:Play()

    rawset(self, "_currentTween", animation)

    return animation
end

-- library stuff

local upper = string.upper
local round, clamp, floor = math.round, math.clamp, math.floor
local newInfo = TweenInfo.new
local newColor3, fromHex, fromHSV = Color3.new, Color3.fromHex, Color3.fromHSV
local decode = (syn and syn.crypt.base64.decode) or (crypt and crypt.base64decode) or base64_decode
local unpack, clear, clone, find, concat = table.unpack, table.clear, table.clone, table.find, table.concat
local request = syn and syn.request or request
local inset = services.GuiService:GetGuiInset().Y
local wait = task.wait

local library = {
    objects = {},
    text = {},
    notifications = {},
    drag_outlines = {},
    config_objects = {},
    player_cache = {},
    lists = {},
    windows = {},
    opening = false,
    theme_objects = {objects = {}, outlines = {}},
    connections = {},
    flags = {},
    initialized = false,
    open = false,
    unloaded = false,
    performance_drag = true,
    paste_textbox = newInstance("TextBox"),
    unnamed_flags = 0,
    tween_speed = 0.1,
    easing_style = Enum.EasingStyle.Quart,
    toggle_speed = 0.2,
    notification_speed = 0.5,
    notification_x = "right",
    notification_y = "bottom",
    watermark_x = "left",
    watermark_y = "top",
    font = worldtoscreen ~= nil and 1 or 2,
    font_size = 13,
    themes = {
        Default = {
            ["Accent"] = fromRGB(113, 93, 133),
            ["Window Background"] = fromRGB(30, 30, 30),
            ["Window Border"] = fromRGB(65, 65, 65),
            ["Black Border"] = fromRGB(10, 10, 10),
            ["Text"] = fromRGB(210, 210, 210),
            ["Disabled Text"] = fromRGB(110, 110, 110),
            ["Tab Background"] = fromRGB(25, 25, 25),
            ["Tab Border"] = fromRGB(45, 45, 45),
            ["Section Background"] = fromRGB(30, 30, 30),
            ["Section Border"] = fromRGB(45, 45, 45),
            ["Object Background"] = fromRGB(25, 25, 25),
            ["Object Border"] = fromRGB(45, 45, 45),
            ["Dropdown Option Background"] = fromRGB(19, 19, 19)
        }
    }
}

library.theme = clone(library.themes["Default"]);
library.paste_textbox.Position = newUDim2(-200, 0, 0, 0)

function Render:Create(class, properties, no_cache)
    properties = properties or {}

    local object = Render.new(class)

    if not no_cache then
        library.objects[object] = object
    end

    if class == "Text" then
        library.text[object] = object
    end

    if self ~= Render then
        object.Parent = self
    end

    for property, value in next, properties do
        if property == "Theme" then
            library.theme_objects.objects[object] = value
            property = "Color"
            value = library.theme[value]
        end

        if property == "OutlineTheme" then
            library.theme_objects.outlines[object] = value
            property = "OutlineColor"
            value = library.theme[value]
        end

        object[property] = value
    end

    return object
end

local utility = {}

utility.formatted_metatable = {
    __index = function(self, key)
        if typeof(key) == "string" then
            return rawget(self, key:lower())
        end
    
        return rawget(self, key)
    end,

    __newindex = function(self, key, value)
        if typeof(key) == "string" then
            return rawset(self, key:lower(), value)
        end
    
        return rawset(self, key, value)
    end
}

function utility.format(tbl, metatable)
    local old = clone(tbl)
    clear(tbl)

    for key, value in next, old do
        if typeof(key) == "string" then
            tbl[key:lower()] = value
        else
            tbl[key] = value
        end
    end

    if metatable then
        setmetatable(tbl, utility.formatted_metatable)
    end
end

function utility.defaults(tbl, defaults)
    for option, default in next, defaults do
        if tbl[option] == nil then
            tbl[option] = default
        end
    end
end

function utility.color_add(color1, color2)
    return newColor3(color1.R + color2.R, color1.G + color2.G, color1.B + color2.B)
end

function utility.auto_button_color(button, color, hover, click, holder)
    holder = holder or button

    local is_theme = typeof(color) == "string"

    --local mouse_over = false
    local mouse_down = false

    --[[local enter = holder.MouseEnter:Connect(function()
        mouse_over = true
        button.Color = utility.color_add((is_theme and library.theme[color] or color), hover)
    end)

    local leave = holder.MouseLeave:Connect(function()
        mouse_over = false
        button.Color = (is_theme and library.theme[color] or color)
    end)]]

    local down = holder.MouseButton1Down:Connect(function()
        mouse_down = true
        button.Color = utility.color_add((is_theme and library.theme[color] or color), click)
    end)

    local up = holder.MouseButton1Up:Connect(function()
        mouse_down = false
        --button.Color = mouse_over and utility.color_add((is_theme and library.theme[color] or color), hover) or (is_theme and library.theme[color] or color)
        button.Color = is_theme and library.theme[color] or color
    end)

    return function()
        --enter:Disconnect()
        --leave:Disconnect()
        down:Disconnect()
        up:Disconnect()
    end
end

function utility.getclipboard(release_ctrl)
    if not iswindowactive() then
        services.UserInputService.WindowFocused:Wait()
    end
    
    library.paste_textbox.Parent = services.CoreGui
    library.paste_textbox:CaptureFocus()
    
    if not is_synX then
        keypress(Enum.KeyCode.LeftControl)
        keypress(Enum.KeyCode.V)
        keyrelease(Enum.KeyCode.V)

        if release_ctrl then
            keyrelease(Enum.KeyCode.LeftControl)
        end
    else
        keypress(0x11)
        keypress(0x56)
        keyrelease(0x56)

        if release_ctrl then
            keyrelease(0x11)
        end
    end
    
    library.paste_textbox:GetPropertyChangedSignal("Text"):Wait()
    
    local clipboard = library.paste_textbox.Text
    library.paste_textbox.Parent = nil
    
    return clipboard
end

function utility.textbox(object, text, placeholder, clear_on_focus, default)
    local max_size = object.AbsoluteSize.X - 48

    local box = {
        FocusLost = Signal.new(),
        Changed = Signal.new()
    }

    local str = default
    local key_queue = 0
    local indicator = false
    local all_selected = false
    local focused = false
    local current_uncut_str = ""

    local highlight = object:Create("Square", {
        Outline = false,
        Color = fromRGB(120, 150, 200),
        ZIndex = text.ZIndex - 1,
        Visible = false
    })

    local function update_highlight(visible)
        highlight.Size = newUDim2(0, text.TextBounds.X, 0, text.TextBounds.Y)

        if text.Center then
            highlight.Position = newUDim2(text.Position.X.Scale, text.Position.X.Offset - (text.TextBounds.X / 2), text.Position.Y.Scale, text.Position.Y.Offset)
        else
            highlight.Position = text.Position
        end

        highlight.Visible = visible
    end

    local function update_text()
        local will_cut = utility.text_length(str, library.font, 13).X > max_size
        current_uncut_str = not will_cut and str or current_uncut_str
        
        box.Changed:Fire(str)

        text.Text = current_uncut_str == "" and placeholder .. (indicator and "|" or "") or current_uncut_str .. (will_cut and "..." or "") .. (indicator and "|" or "")

        library.theme_objects[text] = str == "" and library.theme["Disabled Text"] or library.theme["Text"]
        text.Color = str == "" and library.theme["Disabled Text"] or library.theme["Text"]
    end

    update_text()

    local function finish()
        focused = false

        library.unfocus_current_textbox = nil
        services.ContextActionService:UnbindAction("disable_keyboard_input")
        
        if all_selected then
            update_highlight(false)
            all_selected = false
        end

        indicator = false
        update_text()

        box.FocusLost:Fire(str)
    end

    object.MouseButton1Click:Connect(function()
        focused = true

        library.unfocus_current_textbox = finish

        services.ContextActionService:BindAction("disable_keyboard_input", function()
            return Enum.ContextActionResult.Sink
        end, false, Enum.UserInputType.Keyboard)

        if clear_on_focus then
            str = ""
            update_text()
        end

        spawn(function()
            while focused do
                indicator = true
                update_text()
                update_highlight(highlight.Visible)

                wait(0.5)

                indicator = false
                update_text()
                update_highlight(highlight.Visible)

                wait(0.5)
            end
        end)
    end)
    
    library:Connect(services.UserInputService.InputBegan, function(input)
        if focused then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Return then
                    finish()
                elseif input.KeyCode ~= Enum.KeyCode.Backspace then
                    key_queue += 1
                    local current_queue = key_queue

                    local key_str = services.UserInputService:GetStringForKeyCode(input.KeyCode):lower()

                    if key_str ~= "" then
                        if input:IsModifierKeyDown(Enum.ModifierKey.Shift) then
                            key_str = key_str:upper()
                        end

                        if input:IsModifierKeyDown(Enum.ModifierKey.Ctrl) then
                            if input.KeyCode == Enum.KeyCode.A then
                                all_selected = true
                                update_highlight(true)
                                return
                            elseif input.KeyCode == Enum.KeyCode.C then
                                if all_selected then
                                    setclipboard(str)
                                else
                                    setclipboard("")
                                end

                                return
                            elseif input.KeyCode == Enum.KeyCode.V then
                                if all_selected then
                                    all_selected = false
                                    update_highlight(false)
                                    str = utility.getclipboard(false)
                                else
                                    str ..= utility.getclipboard(false)
                                end

                                update_text()

                                return
                            end
                        end

                        if all_selected then
                            all_selected = false
                            str = ""
                            update_text()

                            update_highlight(false)
                        end

                        str ..= key_str
                        update_text()

                        wait(0.5)

                        spawn(function()
                            while input.UserInputState ~= Enum.UserInputState.End and key_queue == current_queue do
                                str = str .. key_str
                                update_text()
                                wait(0.02)
                            end
                        end)
                    end
                else
                    key_queue += 1
                    local current_queue = key_queue

                    if all_selected then
                        all_selected = false
                        str = ""
                        update_text()
                        update_highlight(false)

                        return
                    else
                        str = str:sub(1, -2)
                    end
                    
                    update_text()

                    wait(0.5)

                    spawn(function()
                        while input.UserInputState ~= Enum.UserInputState.End and key_queue == current_queue do
                            str = str:sub(1, -2)
                            update_text()
                            wait(0.02)
                        end
                    end)
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 and focused then
                finish()
            end
        end
    end)

    function box:Set(txt)
        str = txt
        update_text(true)
    end

    return box
end

function utility.round(number, float)
    return float * round(number / float)
end

function utility.dragify(object, drag_outline)
    local start, object_position, dragging, currentpos

    library:Connect(object.InputBegan, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            start = input.Position
            object_position = object.Position

            if library.performance_drag then
                drag_outline.Visible = true
                drag_outline.Position = object_position
            end
        end
    end)

    library:Connect(services.UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local new_position = newUDim2(object_position.X.Scale, object_position.X.Offset + (input.Position - start).X, object_position.Y.Scale, object_position.Y.Offset + (input.Position - start).Y)

            if not library.performance_drag then
                if (object.AbsolutePosition - calculate_udim2(new_position, workspace.CurrentCamera.ViewportSize)).Magnitude > 3 then
                    object.Position = new_position
                end
            else
                drag_outline.Position = new_position
            end
        end
    end)

    library:Connect(services.UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then 
            dragging = false

            if library.performance_drag then
                drag_outline.Visible = false
                object.Position = drag_outline.Position
            end
        end
    end)
end

function utility.text_length(str, font, size)
    local text = Render.new("Text")
    text.Text = str
    text.Font = font 
    text.Size = size

    local textbounds = text.TextBounds
    text:Destroy()

    return textbounds
end

function utility.center(sizeX, sizeY)
    return newUDim2(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
end

function utility.tostring(input)
    return ("%.14g"):format(input)
end

function utility.new_flag()
    library.unnamed_flags += 1
    return utility.tostring(library.unnamed_flags)
end

local components = {}

function components.tooltip(object, text)
    local tooltip = Render:Create("Square", {
        ZIndex = 998,
        Theme = "Object Background",
        Visible = false,
        OutlineTheme = "Object Border"
    })

    local value_text = tooltip:Create("Text", {
        Text = text,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, 2),
        Theme = "Text",
        Center = true,
        ZIndex = 999
    })

    tooltip.Size = newUDim2(0, value_text.TextBounds.X + 20, 0, 17)

    object.MouseEnter:Connect(function()
        tooltip.Visible = true
    end)

    object.MouseLeave:Connect(function()
        tooltip.Visible = false
    end)

    library:Connect(services.UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            tooltip.Position = newUDim2(0, input.Position.X, 0, input.Position.Y + 16)
        end
    end)
end

function components.separator(section, str, zindex)
    zindex = zindex or 10;
    str = str or ""

    local holder = section.content:Create("Square", {
        Size = newUDim2(1, 0, 0, 12),
        Transparency = 0,
        Outline = false
    })

    local text = holder:Create("Text", {
        Text = str,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, 0),
        Theme = "Text",
        ZIndex = zindex,
        Center = true
    })

    local str_empty = str ~= ""

    local line_1 = holder:Create("Square", {
        Size = newUDim2(0.5, str_empty and -text.TextBounds.X / 2 - 6 or 0, 0, 1),
        Position = newUDim2(0, 0, 0.5, 0),
        ZIndex = zindex - 1,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    local line_2 = holder:Create("Square", {
        Size =  newUDim2(0.5, str_empty and -text.TextBounds.X / 2 - 6 or 0, 0, 1),
        Position = newUDim2(0.5, str_empty and text.TextBounds.X / 2 + 6 or 0, 0.5, 0),
        ZIndex = zindex - 1,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    local separator_types = {}

    function separator_types:Set(str)
        text.Text = str

        local size = newUDim2(0.5, -text.TextBounds.X / 2 - 6, 0, 1)
        line_1.Size = size
        line_2.Size = size

        line_2.Position = newUDim2(0.5, text.TextBounds.X / 2 + 6, 0.5, 0)
    end

    utility.format(separator_types, true)
    return separator_types
end

function components.button(section, options, zindex)
    zindex = zindex or 9;

    utility.format(options)

    utility.defaults(options, {
        name = "button",
        callback = function() end
    })

    local button = section.content:Create("Square", {
        Size = newUDim2(1, 0, 0, 15),
        ZIndex = zindex,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    if options.tooltip then
        components.tooltip(button, options.tooltip)
    end

    utility.auto_button_color(button, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    local text = button:Create("Text", {
        Text = options.name,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, 1),
        Theme = "Text",
        Center = true,
        ZIndex = zindex + 1
    })

    button.MouseButton1Click:Connect(options.callback)

    section:Resize()

    local button_types = {}

    function button_types:Set(str)
        text.Text = str
    end

    utility.format(button_types, true)
    return button_types
end

function components.toggle(holder, options, zindex)
    zindex = zindex or 9;

    utility.format(options)

    utility.defaults(options, {
        default = false,
        ignored = options.noconfig or options.ignoreconfig or options.configignore or false,
        flag = utility.new_flag(),
        callback = function() end
    })

    holder.toggled = false

    if not options.default then
        library.flags[options.flag] = options.default
        options.callback(options.default)
    end

    if options.tooltip then
        components.tooltip(holder.main, options.tooltip)
    end

    local icon = holder.main:Create("Square", {
        Size = newUDim2(0, 9, 0, 9),
        Position = newUDim2(0, 0, 0, 2),
        ZIndex = zindex,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    icon:Create("Image", {
        Size = newUDim2(1, 0, 1, 0),
        Transparency = 0.4,
        ZIndex = zindex + 1,
        Data = decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABuSURBVChTxY9BDoAgDASLGD2ReOYNPsR/+BAfroI7hibe9OYmky2wbUPIOdsXdc1f9WMwppQm+SDGBnUvomAQBH49qzhFEag25869ElzaIXDhD4JGbyoEVxUedN8FKwnfmwhucgKICc+pNB1mZhdCdhsa2ky0FAAAAABJRU5ErkJggg==")
    })

    holder.text.Position = newUDim2(0, 16, 0, 0)

    local disconnect_auto_color = utility.auto_button_color(icon, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8), holder.main)
    local current_tween = nil

    local function toggle()
        if current_tween then
            current_tween:Cancel()
        end

        holder.toggled = not holder.toggled

        if not holder.toggled then
            if holder.keybind and holder.keybind_mode ~= "hold" and library.keybind_list:Exists(holder.name) then
                library.keybind_list:ChangeObjectTheme(holder.name, "Disabled Text")
            end

            if holder.keybind_mode == "hold" and holder.key and library.keybind_list:Exists(holder.name) then
                library.keybind_list:Remove(holder.name)
            end

            disconnect_auto_color = utility.auto_button_color(icon, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8), holder.main)
        else
            if holder.keybind and holder.keybind_mode ~= "hold" and library.keybind_list:Exists(holder.name) then
                library.keybind_list:ChangeObjectTheme(holder.name, "Accent")
            end

            if holder.keybind_mode == "hold" and holder.key then
                if not library.keybind_list:Exists(holder.name) then
                    library.keybind_list:Add(holder.name, "Disabled Text")
                end

                library.keybind_list:Change(holder.name, ("[%s] %s"):format(holder.key_str, holder.name))
            end

            disconnect_auto_color()
        end

        current_tween = library:ChangeThemeObject(icon, holder.toggled and "Accent" or "Object Background")

        library.flags[options.flag] = holder.toggled
        options.callback(holder.toggled)
    end

    if options.default then
        toggle()
    end

    holder.toggle = toggle
    holder.main.MouseButton1Click:Connect(toggle)
    holder.section:Resize()

    local toggle_types = {}

    if not options.ignored then
        library.config_objects[options.flag] = toggle_types
    end

    function toggle_types:Set(bool)
        if holder.toggled ~= bool then
            toggle()
        end
    end

    function toggle_types:Slider(options)
        return components.slider(holder, options, zindex + 2)
    end

    function toggle_types:Dropdown(options)
        return components.dropdown(holder, options, zindex + 2)
    end

    function toggle_types:Colorpicker(options)
        return components.colorpicker(holder, options, zindex + 2)
    end

    function toggle_types:Keybind(options)
        return components.keybind(holder, options, zindex + 2)
    end

    utility.format(toggle_types, true)
    return toggle_types
end

function components.box(section, options, zindex)
    zindex = zindex or 9

    utility.format(options)

    utility.defaults(options, {
        name = "box",
        default = "",
        ignored = options.noconfig or options.ignoreconfig or options.configignore or false,
        flag = utility.new_flag(),
        clearonfocus = true,
        callback = function() end
    })

    local box = section.content:Create("Square", {
        Size = newUDim2(1, 0, 0, 15),
        ZIndex = zindex,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    if options.tooltip then
        components.tooltip(box, options.tooltip)
    end

    local text = box:Create("Text", {
        Text = options.default == "" and options.name or options.default,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, 1),
        Theme = options.default == "" and "Disabled Text" or "Text",
        Center = true,
        ZIndex = zindex + 2
    })

    local box = utility.textbox(box, text, options.name, options.clearonfocus, options.default)

    local function set(str)
        box:Set(str)
        options.callback(str)
    end

    box.FocusLost:Connect(function(str)
        library.flags[options.flag] = str
        options.callback(str)
    end)

    section:Resize()

    local box_types = {}

    if not options.ignored then
        library.config_objects[options.flag] = box_types
    end

    function box_types:Set(str)
        set(str)
    end

    utility.format(box_types, true)
    return box_types
end

function components.slider(holder, options, zindex)
    zindex = zindex or 11

    utility.format(options)

    utility.defaults(options, {
        default = options.min or 1,
        ignored = options.noconfig or options.ignoreconfig or options.configignore or false,
        float = 0.1,
        suffix = "/" .. (options.min and utility.tostring(options.max) or "1"),
        min = 0,
        max = 1,
        flag = utility.new_flag(),
        callback = function() end
    })

    local current_value

    if options.tooltip then
        components.tooltip(holder.main, options.tooltip)
    end

    local slider = holder.main:Create("Square", {
        Size = newUDim2(1, 0, 0, 10),
        Position = newUDim2(0, 0, 0, 18),
        ZIndex = zindex,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    utility.auto_button_color(slider, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    local fill = slider:Create("Square", {
        Size = newUDim2(0, 0, 1, 0),
        Position = newUDim2(0, 0, 0, 0),
        ZIndex = zindex + 1,
        Ignored = true,
        Theme = "Accent",
        Outline = false
    })

    fill:Create("Image", {
        Size = newUDim2(1, 0, 1, 0),
        Transparency = 0.5,
        ZIndex = zindex + 2,
        Data = decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABuSURBVChTxY9BDoAgDASLGD2ReOYNPsR/+BAfroI7hibe9OYmky2wbUPIOdsXdc1f9WMwppQm+SDGBnUvomAQBH49qzhFEag25869ElzaIXDhD4JGbyoEVxUedN8FKwnfmwhucgKICc+pNB1mZhdCdhsa2ky0FAAAAABJRU5ErkJggg==")
    })

    local value_text = slider:Create("Text", {
        Text = "",
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, -2),
        Theme = "Text",
        Center = true,
        ZIndex = zindex + 2
    })

    local plus = holder.main:Create("Text", {
        Text = "+",
        Font = library.font,
        Ignored = false,
        Size = library.font_size,
        Position = newUDim2(1, -7, 0, 0),
        Theme = "Text",
        ZIndex = zindex
    })

    local minus = holder.main:Create("Text", {
        Text = "-",
        Font = library.font,
        Ignored = false,
        Size = library.font_size,
        Position = newUDim2(1, -21, 0, 0),
        Theme = "Text",
        ZIndex = zindex
    })

    holder.plus = plus; holder.minus = minus

    if holder.keybind then
        plus.Position = newUDim2(1, -(13 + holder.keybind.AbsoluteSize.X), 0, 0)
        minus.Position = newUDim2(1, -(29 + holder.keybind.AbsoluteSize.X), 0, 0)
    end

    if holder.colorpickers and holder.colorpickers > 0 then
        holder.plus.Position = newUDim2(1, -(7 + holder.colorpickers * 24), 0, 0)
        holder.minus.Position = newUDim2(1, -(21 + holder.colorpickers * 24), 0, 0)
    end

    local current_tween

    local function set(value)
        value = clamp(utility.round(tonumber(value), options.float), options.min, options.max)
        value_text.Text = utility.tostring(value) .. options.suffix

        if value ~= current_value then
            current_value = value
            fill:Tween(newInfo(library.tween_speed, library.easing_style), {Size = newUDim2((value - options.min) / (options.max - options.min), 0, 1, 0)})
        end

        library.flags[options.flag] = value
        options.callback(value)
    end

    set(options.default)

    local function slide(input)
        local sizeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        local value = clamp((options.max - options.min) * sizeX + options.min, options.min, options.max)

        set(value)
    end

    local sliding = false

    slider.MouseButton1Down:Connect(function()
        sliding = true
        slide{Position = services.UserInputService:GetMouseLocation()}
    end)

    library:Connect(services.UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)

    library:Connect(services.UserInputService.InputChanged, function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            slide(input)
        end
    end)

    plus.MouseButton1Click:Connect(function()
        set(current_value + options.float)
    end)

    minus.MouseButton1Click:Connect(function()
        set(current_value - options.float)
    end)

    holder.main.Size = newUDim2(1, 0, 0, 28)
    holder.section:Resize()

    local slider_types = {}

    if not options.ignored then
        library.config_objects[options.flag] = slider_types
    end

    function slider_types:Set(value)
        set(value)
    end

    utility.format(slider_types, true)
    return slider_types
end

local keys = {
    [Enum.KeyCode.LeftShift] = "L-SHIFT",
    [Enum.KeyCode.RightShift] = "R-SHIFT",
    [Enum.KeyCode.LeftControl] = "L-CTRL",
    [Enum.KeyCode.RightControl] = "R-CTRL",
    [Enum.KeyCode.LeftAlt] = "L-ALT",
    [Enum.KeyCode.RightAlt] = "R-ALT",
    [Enum.KeyCode.CapsLock] = "CAPSLOCK",
    [Enum.KeyCode.KeypadOne] = "NUM-1",
    [Enum.KeyCode.KeypadTwo] = "NUM-2",
    [Enum.KeyCode.KeypadThree] = "NUM-3",
    [Enum.KeyCode.KeypadFour] = "NUM-4",
    [Enum.KeyCode.KeypadFive] = "NUM-5",
    [Enum.KeyCode.KeypadSix] = "NUM-6",
    [Enum.KeyCode.KeypadSeven] = "NUM-7",
    [Enum.KeyCode.KeypadEight] = "NUM-8",
    [Enum.KeyCode.KeypadNine] = "NUM-9",
    [Enum.KeyCode.KeypadZero] = "NUM-0",
    [Enum.KeyCode.Home] = "HOME",
    [Enum.KeyCode.PageUp] = "PAGE-UP",
    [Enum.KeyCode.PageDown] = "PAGE-DOWN",
    [Enum.KeyCode.End] = "END",
    [Enum.KeyCode.Tab] = "TAB",
    [Enum.UserInputType.MouseButton1] = "MOUSE-1",
    [Enum.UserInputType.MouseButton2] = "MOUSE-2",
    [Enum.UserInputType.MouseButton3] = "MOUSE-3"
}

local blacklisted_keys = {
    [Enum.KeyCode.W] = true,
    [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true,
    [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Space] = true,
    [Enum.KeyCode.Escape] = true,
    [Enum.KeyCode.Backspace] = true,
    [Enum.KeyCode.Slash] = true,
    [Enum.KeyCode.Delete] = true,
    [Enum.KeyCode.Insert] = true
}

local enums = {}

for _, enum in next, Enum.UserInputType:GetEnumItems() do
    enums[enum] = true
end

for _, enum in next, Enum.KeyCode:GetEnumItems() do
    enums[enum] = true
end

function components.keybind(holder, options, zindex)
    zindex = zindex or 11

    utility.format(options)

    utility.defaults(options, {
        ignored = options.noconfig or options.ignoreconfig or options.configignore or false,
        listignored = options.listignore or options.ignorelist or options.nolist or false,
        mode = "normal",
        blacklist = {},
        flag = utility.new_flag(),
        callback = function() end
    })

    holder.name = options.listname or holder.name
    options.mode = options.mode:lower()

    local old = clone(options.blacklist)
    options.blacklist = {}

    for key, _ in next, blacklisted_keys do
        options.blacklist[key] = true
    end

    for _, key in next, old do
        options.blacklist[key] = true
    end

    if options.tooltip then
        components.tooltip(holder.main, options.tooltip)
    end

    if not options.listignored and holder.toggle and options.mode ~= "hold" then
        library.keybind_list:Add(holder.name, holder.toggled and "Accent" or "Disabled Text")
    end

    local keybind = holder.main:Create("Square", {
        Size = newUDim2(0, 0, 0, 13),
        Position = newUDim2(1, 0, 0, 0),
        ZIndex = zindex,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    holder.keybind = keybind
    holder.keybind_mode = options.mode

    utility.auto_button_color(keybind, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    local value = keybind:Create("Text", {
        Text = "",
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, 0),
        Theme = "Disabled Text",
        Center = true,
        ZIndex = zindex + 1
    })
    
    local function set(key)
        if typeof(key) == "string" then
            if key:find("KEY") then
                key = Enum.KeyCode[key:gsub("KEY_", "")]
            elseif key:find("INPUT") then
                key = Enum.UserInputType[key:gsub("INPUT_", "")]
            end
        end

        if options.blacklist[key] then
            key = nil
        end

        if key and enums[key] and (keys[key] or services.UserInputService:GetStringForKeyCode(key) ~= "") then
            local key_str = keys[key] or services.UserInputService:GetStringForKeyCode(key)
            holder.key_str = key_str

            if not options.listignored then
                if not library.keybind_list:Exists(holder.name) then
                    if options.mode == "hold" then
                        if not holder.toggle or holder.toggled then
                            library.keybind_list:Add(holder.name, "Disabled Text")
                        end
                    else
                        library.keybind_list:Add(holder.name, "Accent")
                    end
                end

                if library.keybind_list:Exists(holder.name) then
                    library.keybind_list:Change(holder.name, ("[%s] %s"):format(key_str, holder.name))
                end
            end

            library:ChangeThemeObject(value, "Text")
            value.Text = key_str

            keybind.Size = newUDim2(0, value.TextBounds.X + 25, 0, 13)
            keybind.Position = newUDim2(1, -(value.TextBounds.X + 25), 0, 0)

            if holder.plus and holder.minus then
                holder.plus.Position = newUDim2(1, -(13 + keybind.AbsoluteSize.X), 0, 0)
                holder.minus.Position = newUDim2(1, -(29 + keybind.AbsoluteSize.X), 0, 0)
            end

            holder.key = key

            library.flags[options.flag .. "_holding"] = false
            library.flags[options.flag] = key
            options.callback(key, true)
        else
            holder.key_str = "NONE"

            if not options.listignored and library.keybind_list:Exists(holder.name) then
                library.keybind_list:Remove(holder.name)
            end

            library:ChangeThemeObject(value, "Disabled Text")
            value.Text = "NONE"

            keybind.Size = newUDim2(0, 53, 0, 13)
            keybind.Position = newUDim2(1, -53, 0, 0)

            if holder.plus and holder.minus then
                holder.plus.Position = newUDim2(1, -(13 + keybind.AbsoluteSize.X), 0, 0)
                holder.minus.Position = newUDim2(1, -(29 + keybind.AbsoluteSize.X), 0, 0)
            end

            holder.key = nil

            library.flags[options.flag .. "_holding"] = true
            library.flags[options.flag] = nil
            options.callback(nil, true)
        end
    end

    set(options.default)

    local binding
    keybind.MouseButton1Click:Connect(function()
        if binding then
            library:Disconnect(binding)
        end

        library:ChangeThemeObject(value, "Disabled Text")
        value.Text = "..."
        
        keybind.Size = newUDim2(0, value.TextBounds.X + 25, 0, 13)
        keybind.Position = newUDim2(1, -(value.TextBounds.X + 25), 0, 0)

        if holder.plus and holder.minus then
            holder.plus.Position = newUDim2(1, -(13 + keybind.AbsoluteSize.X), 0, 0)
            holder.minus.Position = newUDim2(1, -(29 + keybind.AbsoluteSize.X), 0, 0)
        end

        binding = library:Connect(services.UserInputService.InputBegan, function(input)
            set(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
            library:Disconnect(binding)
            wait()
            binding = nil
        end)
    end)

    library:Connect(services.UserInputService.InputBegan, function(input)
        if not binding and (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType) == library.flags[options.flag] then
            if holder.toggle and options.mode ~= "hold" then
                holder.toggle()
            end

            if options.mode == "hold" and (holder.toggled ~= nil and holder.toggled) then
                library.keybind_list:ChangeObjectTheme(holder.name, "Accent")
                library.flags[options.flag .. "_holding"] = true
            end
        
            options.callback(library.flags[options.flag], false, options.mode == "hold" and true)
        end
    end)

    if options.mode == "hold" then
        library:Connect(services.UserInputService.InputEnded, function(input)
            if (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType) == library.flags[options.flag] then
                if not holder.toggle or holder.toggled then
                    library.keybind_list:ChangeObjectTheme(holder.name, "Disabled Text")
                end

                library.flags[options.flag .. "_holding"] = false
                options.callback(library.flags[options.flag], false, false)
            end
        end)
    end

    local keybind_types = {}

    if not options.ignored then
        library.config_objects[options.flag] = keybind_types
    end

    function keybind_types:Set(key)
        set(key)
    end

    utility.format(keybind_types, true)
    return keybind_types
end

function components.dropdown(holder, options, zindex)
    zindex = zindex or 11

    utility.format(options)
    options.multi = options.multi or options.multiselect or options.multibox or options.multiple

    utility.defaults(options, {
        ignored = options.noconfig or options.ignoreconfig or options.configignore or false,
        content = {},
        multi = false,
        flag = utility.new_flag(),
        callback = function() end
    })

    local option_objects = {}
    local current = options.multi and {} or nil

    local dropdown = holder.main:Create("Square", {
        Size = newUDim2(1, 0, 0, 15),
        Position = newUDim2(0, 0, 0, 18),
        ZIndex = zindex,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    if options.tooltip then
        components.tooltip(dropdown, options.tooltip)
    end

    utility.auto_button_color(dropdown, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    local value_text = dropdown:Create("Text", {
        Text = "NONE",
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0, 6, 0, 1),
        Theme = "Disabled Text",
        ZIndex = zindex + 1
    })

    local open_button = dropdown:Create("Text", {
        Text = "+",
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(1, -9, 0, 1),
        Theme = "Text",
        Center = true,
        ZIndex = zindex + 1
    })

    local content_frame = holder.main:Create("Square", {
        Size = newUDim2(1, 0, 0, 0),
        Position = newUDim2(0, 0, 1, 4),
        ZIndex = zindex + 9,
        Visible = false,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    local content_holder = content_frame:Create("Square", {
        Transparency = 0,
        Size = newUDim2(1, -6, 1, -6),
        Position = newUDim2(0, 3, 0, 3),
        Outline = false
    })

    content_holder:AddList(3)

    local function update_value()
        if not options.multi then
            value_text.Text = current or "NONE"
            library:ChangeThemeObject(value_text, current and "Text" or "Disabled Text")
        else
            local current_text = {}

            if #current > 0 then
                for _, option in next, current do
                    current_text[#current_text + 1] = option

                    local text = concat(current_text, ", ")
                    value_text.Text = text

                    if value_text.TextBounds.X > dropdown.AbsoluteSize.X - 48 then
                        remove(current_text, #current_text)
                        value_text.Text = concat(current_text, ", ") .. ", ..."

                        return
                    end
                end

                library:ChangeThemeObject(value_text, "Text")
            else
                value_text.Text = "NONE"
                library:ChangeThemeObject(value_text, "Disabled Text")
            end
        end
    end

    local set
    set = function(chosen, ignore)
        if not options.multi then
            local is_config = false
            if chosen:sub(1, 4) == "SET_" then
                chosen = chosen:sub(5)
                is_config = true
            end

            if chosen ~= current then
                current = chosen
                
                for name, option in next, option_objects do
                    if name ~= chosen and option.chosen then
                        option.chosen = false
                        option.object:Tween(newInfo(library.tween_speed, library.easing_style), {Transparency = 0})
                        library:ChangeThemeObject(option.text, "Disabled Text")
                    end
                end

                update_value()

                local option_object = option_objects[chosen];

                if (option_object) then
                    option_object.chosen = true
                    option_object.object:Tween(newInfo(library.tween_speed, library.easing_style), {Transparency = 1})

                    library:ChangeThemeObject(option_object.text, "Text")

                    library.flags[options.flag] = chosen
                    options.callback(chosen)
                end
            else
                if not is_config then
                    current = nil

                    update_value()

                    local option_object = option_objects[chosen];

                    if (option_object) then
                        option_object.chosen = false
                        option_object.object:Tween(newInfo(library.tween_speed, library.easing_style), {Transparency = 0})

                        library:ChangeThemeObject(option_object.text, "Disabled Text")
                        
                        library.flags[options.flag] = nil
                        options.callback(nil)
                    end
                else
                    library.flags[options.flag] = chosen
                    options.callback(chosen)
                end
            end
        else
            if typeof(chosen) == "table" then
                for _, option in next, chosen do
                    if not find(current, option) then
                        set(option, true)
                    end
                end

                library.flags[options.flag] = current
                options.callback(current)

                return
            end

            local idx = find(current, chosen)

            if not idx then
                current[#current + 1] = chosen

                update_value()
                option_objects[chosen].chosen = true
                option_objects[chosen].object:Tween(newInfo(library.tween_speed, library.easing_style), {Transparency = 1})

                library:ChangeThemeObject(option_objects[chosen].text, "Text")

                if not ignore then
                    library.flags[options.flag] = current
                    options.callback(current)
                end
            else
                remove(current, idx)

                update_value()
                option_objects[chosen].chosen = false
                option_objects[chosen].object:Tween(newInfo(library.tween_speed, library.easing_style), {Transparency = 0})

                library:ChangeThemeObject(option_objects[chosen].text, "Disabled Text")
                
                library.flags[options.flag] = current
                options.callback(current)
            end
        end
    end

    local function create_option(name)
        local object = content_holder:Create("Square", {
            Size = newUDim2(1, 0, 0, 16),
            ZIndex = zindex + 10,
            Transparency = 0,
            Theme = "Dropdown Option Background",
            Outline = false
        })
        
        local text = object:Create("Text", {
            Text = name,
            Font = library.font,
            Size = library.font_size,
            Position = newUDim2(0, 6, 0, 1),
            Ignored = true,
            Theme = "Disabled Text",
            ZIndex = zindex + 11
        })

        object.MouseButton1Click:Connect(function()
            set(name)
        end)
        
        local option = {object = object, text = text, chosen = false}
        option_objects[name] = option

        content_frame.Size = newUDim2(1, 0, 0, content_holder._list._contentSize + 3)

        return option
    end

    for _, option in next, options.content do
        create_option(option)
    end

    if options.default then
        set(options.default)
    else
        library.flags[options.flag] = options.multi and {} or nil
        options.callback(options.multi and {} or nil)
    end

    local function open_dropdown()
        content_frame.Visible = not content_frame.Visible
        open_button.Text = content_frame.Visible and "-" or "+"
    end

    dropdown.MouseButton1Click:Connect(open_dropdown)
    
    holder.main.Size = newUDim2(1, 0, 0, 33)
    holder.section:Resize()

    local dropdown_types = {}

    if not options.ignored then
        library.config_objects[options.flag] = dropdown_types
    end

    function dropdown_types:Set(option)
        set(option)
    end

    function dropdown_types:Add(option)
        create_option(option)
    end

    function dropdown_types:Remove(option)
        option_objects[option].object:Destroy()
        content_frame.Size = newUDim2(1, 0, 0, content_holder._list._contentSize + 3)

        if not options.multi then
            if current == option then
                current = nil
                update_value()
                
                library.flags[options.flag] = nil
                options.callback(nil)
            end 
        else
            local idx = find(current, option)

            if idx then
                remove(current, idx)
                update_value()
                
                library.flags[options.flag] = current
                options.callback(current)
            end
        end
    end

    function dropdown_types:Refresh(tbl)
        if not options.multi then
            for _, option in next, option_objects do
                option.object:Destroy()
            end

            clear(option_objects)

            for _, option in next, tbl do
                create_option(option)
            end

            current = nil
            update_value()
            
            library.flags[options.flag] = nil
            options.callback(nil)
        else
            for _, option in next, option_objects do
                option.object:Destroy()
            end

            clear(option_objects)
            clear(current)

            for _, option in next, tbl do
                create_option(option)
            end

            update_value()

            library.flags[options.flag] = {}
            options.callback{}
        end
    end

    function dropdown_types:Exists(option)
        return option_objects[option] and true or false
    end

    utility.format(dropdown_types, true)
    return dropdown_types
end

function components.colorpicker(holder, options, zindex)
    zindex = zindex or 11

    utility.format(options)

    utility.defaults(options, {
        name = "colorpicker",
        default = fromRGB(255, 255, 255),
        ignored = options.noconfig or options.ignoreconfig or options.configignore or false,
        flag = utility.new_flag(),
        callback = function() end
    })

    if options.tooltip then
        components.tooltip(holder, options.tooltip)
    end

    local sliding_saturation, sliding_hue, sliding_alpha = false, false, false
    local hue_position
    local current_color, hue, sat, val, alpha

    local icon = holder.main:Create("Square", {
        Size = newUDim2(0, 18, 0, 9),
        Position = newUDim2(1, -(18 + holder.colorpickers * (holder.colorpickers * 24)), 0, 2),
        ZIndex = zindex,
        OutlineTheme = "Object Border"
    })

    holder.colorpickers += 1

    if holder.plus and holder.minus then
        holder.plus.Position = newUDim2(1, -(7 + holder.colorpickers * 24), 0, 0)
        holder.minus.Position = newUDim2(1, -(21 + holder.colorpickers * 24), 0, 0)
    end

    icon:Create("Image", {
        Size = newUDim2(1, 0, 1, 0),
        ZIndex = zindex - 1,
        Data = decode("iVBORw0KGgoAAAANSUhEUgAAABIAAAAKBAMAAABLZROSAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURb+/v////5nD/3QAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAVSURBVBjTY2AQhEIkliAWSLY6QQYAknwC7Za+1vYAAAAASUVORK5CYII=")
    })

    local window = icon:Create("Square", {
        Theme = "Object Background",
        Size = newUDim2(0, options.alpha and 192 or 176, 0, 179),
        Visible = false,
        Outline = false,
        Position = newUDim2(1, -(options.alpha and 192 or 176), 1, 5),
        ZIndex = zindex + 13
    })

    window:Create("Text", {
        Text = options.name,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0, 6, 0, 3),
        Theme = "Text",
        ZIndex = zindex + 16
    })

    window:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Background",
        OutlineTheme = "Black Border",
        ZIndex = zindex + 12,
    })

    window:Create("Square", {
        Size = newUDim2(1, 0, 0, 19),
        ZIndex = zindex + 14,
        Theme = "Window Background",
        Outline = false
    }):Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = zindex + 13,
        OutlineTheme = "Black Border"
    });

    window:Create("Square", {
        Size = newUDim2(1, 0, 1, -19),
        Position = newUDim2(0, 0, 0, 19),
        ZIndex = zindex + 15,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    });

    local saturation_frame = window:Create("Square", {
        Color = options.default,
        Size = newUDim2(0, 164, 0, 110),
        Position = newUDim2(0, 6, 1, -154),
        OutlineTheme = "Object Border",
        ZIndex = zindex + 16
    })

    saturation_frame:Create("Image", {
        Size = newUDim2(1, 0, 1, 0),
        ZIndex = zindex + 17,
        Ignored = true,
        Data = decode("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")
    })

    local saturation_picker = saturation_frame:Create("Square", {
        Size = newUDim2(0, 2, 0, 2),
        ZIndex = zindex + 18,
        OutlineColor = fromRGB(0, 0, 0)
    })

    local hue_frame = window:Create("Image", {
        Size = newUDim2(1, -12, 0, 9),
        ZIndex = zindex + 16,
        Position = newUDim2(0, 6, 1, -37),
        Outline = true,
        OutlineTheme = "Object Border",
        Data = decode("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")
    })

    local hue_picker = hue_frame:Create("Square", {
        Size = newUDim2(0, 1, 1, 0),
        ZIndex = zindex + 17,
        OutlineColor = fromRGB(0, 0, 0)
    })

    local alpha_frame, alpha_picker

    if options.alpha then
        alpha_frame = window:Create("Square", {
            Size = newUDim2(0, 9, 0, 110),
            Position = newUDim2(1, -15, 1, -154),
            Visible = options.alpha,
            ZIndex = zindex + 16,
            OutlineTheme = "Object Border"
        })
    
        alpha_frame:Create("Image", {
            Size = newUDim2(1, 0, 1, 0),
            ZIndex = zindex + 17,
            Ignored = true,
            Transparency = 1,
            Data = decode("iVBORw0KGgoAAAANSUhEUgAAAAkAAABuCAYAAAD1YDnyAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAFMSURBVFhHvZMhTMNQFEX/WOZwKBwON4dDNMHN4XBzc3M43BwOh8PhULip1s3hcLg53Nxcue9mIy/ty/8kDfcktzlpsv97xEZ1XacjVVUdLKWmaQ6W0slfNmrbdgIh/tf+1PCX3YUvu7MPP4WQQR8evuzO6s4gRFN3DiG5unFpvaOjWd0FhOTqwiv8ekdHs7pLCNHUTSFEU3cFIZq6awjR1N1AiKZuBiG5uuLsEX6Hn9XdQkiurjh7hFf4Wd0dhGjq5hCiqVtAiKZuCSGaunsI0dQ9QMjguuKsbgUhg+uKs7pHCNHUPUGIpu4ZQjR1LxCiqXuFEE3dG4Ro6t4hJFcX/mv9ekdHs7o1hOTqwiv8ekdHs7rfOzR1GwjR1H1AiKbuE0I0dV8QoqnbQkiurjh7hN/hZ3XfEJKrK84e4RV+VreDEE3dHkL+uy6NfwDz0OfO0eCa+AAAAABJRU5ErkJggg==")
        })
    
        alpha_picker = alpha_frame:Create("Square", {
            Size = newUDim2(1, 0, 0, 1),
            ZIndex = zindex + 18,
            OutlineTheme = "Object Border"
        })
    end

    local box = window:Create("Square", {
        Size = newUDim2(1, -12, 0, 15),
        Position = newUDim2(0, 6, 1, -21),
        ZIndex = zindex + 16,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    })

    local box_text = box:Create("Text", {
        Text = "",
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0.5, 0, 0, 1),
        Theme = "Text",
        Center = true,
        ZIndex = zindex + 17
    })

    local input = utility.textbox(box, box_text, "R, G, B", false, "")

    local function set(color, opacity, from_input, no_picker_update)
        if typeof(color) == "table" then
            opacity =  color.alpha
            color = fromHex(color.color)
        end

        if not options.alpha then
            opacity = 1
        end

        hue, sat, val = color:ToHSV()

        if current_color ~= color or alpha ~= opacity then
            current_color = color
            alpha = opacity

            if options.alpha then
                icon.Transparency = opacity
            end

            icon.Color = color

            if options.alpha then
                alpha_frame.Color = color
            end

            if not no_picker_update then
                saturation_frame.Color = fromHSV(hue, 1, 1)
                saturation_picker.Position = newUDim2(sat, 0, 1 - val, 0)

                hue_picker.Position = newUDim2(hue, 0, 0, 0)
                hue_position = hue

                if options.alpha then
                    alpha_picker.Position = newUDim2(0, 0, 1 - opacity, 0)
                end
            end

            if not from_input then
                input:Set(("%s, %s, %s"):format(round(color.R * 255), round(color.G * 255), round(color.B * 255)))
            end

            library.flags[options.flag] = color

            if options.alpha then
                library.flags[options.flag .. "_alpha"] = opacity
            end

            options.callback(color, options.alpha and opacity or nil)
        end
    end

    set(options.default, options.alpha)

    local function update_saturation(input)
        local sizeX = clamp((input.Position.X - saturation_frame.AbsolutePosition.X) / saturation_frame.AbsoluteSize.X, 0, 1)
        local sizeY = clamp(1 - (input.Position.Y - saturation_frame.AbsolutePosition.Y + inset) / saturation_frame.AbsoluteSize.Y, 0, 1)

        local posX = clamp(sizeX * saturation_frame.AbsoluteSize.X, 0, saturation_frame.AbsoluteSize.X - 2)
        local posY = clamp(saturation_frame.AbsoluteSize.Y - sizeY  * saturation_frame.AbsoluteSize.Y, 0, saturation_frame.AbsoluteSize.Y - 2)

        saturation_picker.Position = newUDim2(0, posX, 0, posY)
        set(fromHSV(hue_position, sizeX, sizeY), alpha, false, true)
    end

    local function update_hue(input)
        local sizeX = clamp((input.Position.X - hue_frame.AbsolutePosition.X) / hue_frame.AbsoluteSize.X, 0, 1)
        local posX = clamp(sizeX * hue_frame.AbsoluteSize.X, 0, hue_frame.AbsoluteSize.X - 2)

        hue_position = sizeX
        hue_picker.Position = newUDim2(0, posX, 0, 0)
        saturation_frame.Color = fromHSV(sizeX, 1, 1)

        set(fromHSV(sizeX, sat, val), alpha, false, true)
    end

    local function update_alpha(input)
        local sizeY = clamp(1 - (input.Position.Y - alpha_frame.AbsolutePosition.Y + inset) / alpha_frame.AbsoluteSize.Y, 0, 1)
        local posY = clamp(alpha_frame.AbsoluteSize.Y - sizeY  * alpha_frame.AbsoluteSize.Y, 0, alpha_frame.AbsoluteSize.Y - 2)

        alpha_picker.Position = newUDim2(0, 0, 0, posY)
        set(fromHSV(hue_position, sat, val), sizeY, false, true)
    end

    saturation_frame.MouseButton1Down:Connect(function()
        sliding_saturation = true
        update_saturation{Position = services.UserInputService:GetMouseLocation() - newVector2(0, 36)}
    end)

    hue_frame.MouseButton1Down:Connect(function()
        sliding_hue = true
        update_hue{Position = services.UserInputService:GetMouseLocation()}
    end)

    if options.alpha then
        alpha_frame.MouseButton1Down:Connect(function()
            sliding_alpha = true
            update_alpha{Position = services.UserInputService:GetMouseLocation() - newVector2(0, 36)}
        end)
    end

    library:Connect(services.UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding_saturation, sliding_hue, sliding_alpha = false, false, false
        end
    end)

    library:Connect(services.UserInputService.InputChanged, function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if sliding_saturation then
                update_saturation(input)
            elseif sliding_hue then
                update_hue(input)
            elseif sliding_alpha then
                update_alpha(input)
            end
        end
    end)

    input.FocusLost:Connect(function(color)
        if color:find("%d+[, ]%s?%d+[, ]%s?%d+") then
            local colors = {}
    
            for str in color:gmatch("%d+") do
                colors[#colors + 1] = clamp(tonumber(str), 0, 255)
            end

            set(fromRGB(colors[1], colors[2], colors[3]), 1, true)
        end

        input:Set(("%s, %s, %s"):format(round(current_color.R * 255), round(current_color.G * 255), round(current_color.B * 255)))
    end)

    icon.MouseButton1Click:Connect(function()
        if holder.section.tab.current_colorpicker and holder.section.tab.current_colorpicker ~= window then
            holder.section.tab.current_colorpicker.Visible = false
        end

        holder.section.tab.current_colorpicker = window
        window.Visible = not window.Visible
    end)

    local colorpicker_types = {}

    if not options.ignored then
        library.config_objects[options.flag] = colorpicker_types
    end

    function colorpicker_types:Set(color)
        set(color)
    end

    function colorpicker_types:SetAlpha(alpha)
        set(fromHSV(hue_position, sat, val), alpha)
    end

    utility.format(colorpicker_types, true)
    return colorpicker_types
end

function components.subgroup(holder, options, zindex)
    zindex = zindex or 11;

    utility.format(options);

    utility.defaults(options, {
        name = "subgroup"
    });

    local icon = holder.main:Create("Square", {
        Size = newUDim2(0, 18, 0, 9),
        Position = newUDim2(1, -20, 0, 2),
        ZIndex = zindex,
        OutlineTheme = "Object Border"
    });

    icon:Create("Image", {
        Size = newUDim2(1, 0, 1, 0),
        ZIndex = zindex - 1,
        Data = decode("iVBORw0KGgoAAAANSUhEUgAAABIAAAAKBAMAAABLZROSAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAGUExURb+/v////5nD/3QAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAAVSURBVBjTY2AQhEIkliAWSLY6QQYAknwC7Za+1vYAAAAASUVORK5CYII=")
    });

    local window = icon:Create("Square", {
        Theme = "Object Background",
        Size = newUDim2(0, 200, 0, 179),
        Visible = false,
        Outline = false,
        Position = newUDim2(1, 5, 0, 0),
        ZIndex = zindex + 13
    });

    window:Create("Text", {
        Text = options.name,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0, 6, 0, 3),
        Theme = "Text",
        ZIndex = zindex + 16
    });

    window:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Background",
        OutlineTheme = "Black Border",
        ZIndex = zindex + 12,
    });

    window:Create("Square", {
        Size = newUDim2(1, 0, 0, 19),
        ZIndex = zindex + 14,
        Theme = "Window Background",
        Outline = false
    }):Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = zindex + 13,
        OutlineTheme = "Black Border"
    });

    window:Create("Square", {
        Size = newUDim2(1, 0, 1, -19),
        Position = newUDim2(0, 0, 0, 19),
        ZIndex = zindex + 15,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    });

    icon.MouseButton1Click:Connect(function()
        if holder.section.tab.current_subgroup and holder.section.tab.current_subgroup ~= window then
            holder.section.tab.current_subgroup.Visible = false;
        end

        holder.section.tab.current_subgroup = window;
        window.Visible = not window.Visible;
    end);

    local group_types = {};

    utility.format(group_types, true);
    return group_types;
end

function components.list(options)
    utility.format(options)

    utility.defaults(options, {
        name = options.title or "indicator list",
        sizex = 200,
        content = {},
        position = newUDim2(0, 16, 0, 42),
        flag = utility.new_flag(),
        callback = function() end
    })

    local objects = {}

    local list = Render:Create("Square", {
        Size = newUDim2(0, options.sizex, 0, 32),
        ZIndex = 43,
        Theme = "Window Background",
        Position = options.position,
        Outline = false
    }, true)

    list:Create("Square", {
        Size = newUDim2(1, 0, 1, -22),
        Position = newUDim2(0, 0, 0, 22),
        ZIndex = 44,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    }, true)

    library.lists[list] = list

    list:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 42,
        OutlineTheme = "Black Border"
    }, true)

    local title = list:Create("Text", {
        Text = options.name,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0, 6, 0, 4),
        Theme = "Text",
        ZIndex = 44
    }, true)

    local list_content = list:Create("Square", {
        Size = newUDim2(1, 0, 0, 0),
        Position = newUDim2(0, 6, 0, 28),
        Transparency = 0,
        Outline = false
    }, true)

    list_content:AddList(3)

    local drag_outline = Render:Create("Square", {
        Size = newUDim2(0, options.sizex, 0, 100),
        Thickness = 1,
        Filled = false,
        Visible = false,
        Theme = "Accent",
        Outline = false,
        ZIndex = 41,
    }, true)

    library.drag_outlines[drag_outline] = true

    drag_outline:Create("Square", {
        Size = newUDim2(1, 0, 1, 0),
        Filled = false,
        Theme = "Black Border",
        ZIndex = 40,
        Thickness = 2,
        Outline = false
    }, true)

    utility.dragify(list, drag_outline)

    local function update_flag(no_callback)
        local tbl = {}

        for str, _ in next, objects do
            tbl[#tbl + 1] = str
        end

        library.flags[options.flag] = tbl

        if not no_callback then
            options.callback(tbl)
        end
    end

    local function add(str, theme)
        theme = theme or "Text"

        objects[str] = list_content:Create("Square", {
            Size = newUDim2(1, 0, 0, 13),
            Transparency = 0,
            Outline = false
        }, true):Create("Text", {
            Text = str,
            Font = library.font,
            Size = library.font_size,
            Theme = theme,
            ZIndex = 44
        }, true)

        list.Size = newUDim2(0, options.sizex, 0, list_content._list._contentSize + 32)
        drag_outline.Size = newUDim2(0, options.sizex, 0, list_content._list._contentSize + 32)

        update_flag(true)
    end

    for _, str in next, options.content do
        add(str)
    end

    update_flag()

    local list_types = {object = list}

    function list_types:Set(str)
        title.Text = str
    end

    function list_types:Exists(str)
        return objects[str] and true or false
    end

    function list_types:Change(object, str)
        objects[object].Text = str
    end

    function list_types:ChangeObjectTheme(object, theme)
        library:ChangeThemeObject(objects[object], theme)
    end

    function list_types:Remove(object)
        objects[object].Parent:Destroy()
        objects[object] = nil

        list.Size = newUDim2(0, options.sizex, 0, list_content._list._contentSize + 32)
        drag_outline.Size = newUDim2(0, options.sizex, 0, list_content._list._contentSize + 32)

        update_flag(true)
    end

    function list_types:Add(str, theme)
        add(str, theme)
    end

    function list_types:Toggle()
        list.Visible = not list.Visible
    end

    utility.format(list_types, true)
    return list_types
end

function library:Connect(event, callback)
    local connection = event:Connect(callback)
    self.connections[connection] = true

    return connection
end

function library:Disconnect(connection)
    connection:Disconnect()
    self.connections[connection] = nil
end

function library:ChangeFont(font)
    font = font:lower()
    self.font = font == "plex" and Render.Fonts.Plex or font == "ui" and Render.Fonts.UI or font == "monospace" and Render.Fonts.Monospace or font == "system" and Render.Fonts.System

    for _, text in next, self.text do
        text.Font = self.font
    end
end

function library:ChangeFontSize(size)
    self.font_size = size

    for _, text in next, self.text do
        text.Size = size
    end
end

function library:Unload(fade)
    self.unloaded = true

    for connection, _ in next, self.connections do
        library:Disconnect(connection)
    end

    if fade then
        if self.holder.Visible then
            self:Toggle()
            wait(self.tween_speed + 0.5)
        end
    end

    if self.unfocus_current_textbox then
        self.unfocus_current_textbox()
    end

    services.ContextActionService:UnbindAction("disable_keyboard_input")
    services.ContextActionService:UnbindAction("disable_mouse_input")

    self.holder:Destroy()

    if (self.watermark and typeof(self.watermark) ~= "function") then
        self.watermark:Destroy()
    end

    if (self.Playerlist) then
        self.Playerlist.object:Destroy()
    end

    for list, _ in next, library.lists do
        list:Destroy()
    end

    for window, _ in next, library.windows do
        window:Destroy()
    end

    for outline, _ in next, library.drag_outlines do
        outline:Destroy()
    end

    for _, notification in next, self.notifications do
        notification:Destroy()
    end
end

function library:Toggle()
    if not self.opening then
        self.opening = true
        self.Playerlist.object.Visible = self.Playerlist.toggled and not self.open or false

        for window, types in next, library.windows do
            window.Visible = types.Visible and not self.open or false;
        end

        if self.holder.Visible then
            self.open = false

            for _, object in next, self.objects do
                if object.AbsoluteVisible then
                    local old = object.Transparency
                    local tween = object:Tween(newInfo(self.toggle_speed, library.easing_style), {Transparency = 0})

                    tween.Completed:Connect(function()
                        wait(0.1)
                        object.Transparency = old
                    end)
                end
            end

            wait(self.toggle_speed)

            if self.unfocus_current_textbox then
                self.unfocus_current_textbox()
            end

            services.ContextActionService:UnbindAction("disable_mouse_input")
            services.ContextActionService:UnbindAction("disable_keyboard_input")

            self.holder.Visible = not self.holder.Visible
        else
            self.open = true
            self.holder.Visible = not self.holder.Visible

            for _, object in next, self.objects do
                if object.AbsoluteVisible then
                    local old = object.Transparency
                    object.Transparency = 0
                    object:Tween(newInfo(self.toggle_speed, library.easing_style), {Transparency = old})
                end
            end
        end

        spawn(function()
            wait(self.toggle_speed + 0.1)
            self.opening = false
        end)
    end
end

function library:FadeIn()
    self.holder.Visible = true
    self.holder.Visible = false

    wait(0.1)
    self:Toggle()

    if self.watermark and typeof(self.watermark) ~= "function" then
        self.watermark.Visible = true
    end
end

function library:Init()
    self:LoadConfig(library:GetAutoLoadConfig());
    self:FadeIn();
    self.initialized = true;
end

function library:CreateFolder(name)
    local folder = ("%s\\%s\\%s"):format(self.folder, self.game, name)

    if not isfolder(folder) then
        makefolder(folder)
    end

    return folder
end

function library:CreateFile(folder, name, extension)
    extension = extension or self.extension

    if typeof(name) == "string" and name:find("%S+") then
        local folder = self:CreateFolder(folder)
        local file = ("%s\\%s.%s"):format(folder, name, extension)

        writefile(file, extension == "json" and "{}" or "")

        return true
    end
end

function library:SaveFile(folder, name, extension, data)
    extension = extension or self.extension

    if typeof(name) == "string" and name:find("%S+") then
        local folder = self:CreateFolder(folder)
        local file = ("%s\\%s.%s"):format(folder, name, extension)

        if isfile(file) then
            writefile(file, data)
        end
    end
end

function library:GetFile(folder, name, extension)
    extension = extension or self.extension

    if typeof(name) == "string" and name:find("%S+") then
        local folder = self:CreateFolder(folder)
        local file = ("%s\\%s.%s"):format(folder, name, extension)

        if isfile(file) then
            return readfile(file)
        end
    end
end

function library:GetFiles(folder)
    local folder = ("%s\\%s\\%s"):format(self.folder, self.game, folder)
    local files = isfolder(folder) and listfiles(folder) or {}
    local file_tbl = {}

    for i, file in next, files do
        file_tbl[file:gsub(".*\\", ""):split(".")[1]] = readfile(file)
    end

    return file_tbl
end

function library:DeleteFile(folder, name, extension)
    if typeof(name) == "string" and name:find("%S+") then
        local folder = ("%s\\%s\\%s"):format(self.folder, self.game, folder)
        local file = ("%s\\%s.%s"):format(folder, name, extension)

        if isfile(file) then
            delfile(file)

            return true
        end
    end
end

function library:CreateConfig(name)
    if name ~= "auto_load" then
        return self:CreateFile("configs", name)
    end
end

function library:SetAutoLoadConfig(name)
    local folder = ("%s\\%s"):format(self.folder, self.game)
    local file = ("%s\\%s.%s"):format(folder, "auto_load", "txt")

    writefile(file, name)
end

function library:GetAutoLoadConfig()
    local folder = ("%s\\%s"):format(self.folder, self.game)
    local file = ("%s\\%s.%s"):format(folder, "auto_load", "txt")

    if (isfile(file)) then
        return readfile(file);
    end
end

function library:SaveConfig(name)
    if typeof(name) == "string" and name:find("%S+") then
        local config = {}

        for flag, object in next, self.config_objects do
            local value = self.flags[flag]

            if typeof(value) == "EnumItem" then
                if tostring(value):find("KeyCode") then
                    config[flag] = "KEY_" .. tostring(value):gsub("Enum.KeyCode.", "")
                else
                    config[flag] = "INPUT_" .. tostring(value):gsub("Enum.UserInputType.", "")
                end
            elseif typeof(value) == "Color3" then
                config[flag] = {color = value:ToHex(), alpha = self.flags[flag .. "_alpha"]}
            elseif object.Refresh and typeof(value) == "string" then
                config[flag] = "SET_" .. value
            else
                config[flag] = value
            end
        end

        self:SaveFile("configs", name, self.extension, services.HttpService:JSONEncode(config))

        return true
    end
end

function library:LoadConfig(name)
    if typeof(name) == "string" then
        local file = self:GetFile("configs", name, self.extension)

        if file then
            self.current_config = name
            local config = services.HttpService:JSONDecode(file)

            for flag, value in next, config do
                local object = self.config_objects[flag]

                if object then
                    object:Set(value)
                end
            end

            library:LoadTheme(self.flags["selected_theme"]);

            if (self.theme_colorpickers) then
                for option, colorpicker in next, self.theme_colorpickers do
                    colorpicker:Set(self.theme[option])
                end
            end

            return true
        end
    end
end

function library:GetConfigs()
    local configs = self:GetFiles("configs")
    local configs_tbl = {}

    for config, _ in next, configs do
        if not config:find("auto_load.") then
            configs_tbl[#configs_tbl + 1] = config
        end
    end

    return configs_tbl
end

function library:DeleteConfig(name)
    return self:DeleteFile("configs", name, self.extension)
end

function library:ChangeThemeObject(object, theme, outline)
    library.theme_objects[outline and "outlines" or "objects"][object] = theme
    return object:Tween(newInfo(self.tween_speed, library.easing_style), {[outline and "OutlineColor" or "Color"] = self.theme[theme]})
end

function library:UpdateTheme()
    for object, color in next, self.theme_objects.objects do
        object.Color = self.theme[color]
    end

    for object, color in next, self.theme_objects.outlines do
        object.OutlineColor = self.theme[color]
    end
end

function library:ChangeThemeOption(option, color)
    self.theme[option] = color
    self:UpdateTheme()
end

function library:OverrideTheme(tbl)
    for option, color in next, tbl do
        self.theme[option] = color
    end

    self:UpdateTheme()
end

function library:LoadTheme(name)
    if self.themes[name] then
        self.theme = clone(self.themes[name])
        self:UpdateTheme()
    elseif (typeof(name) == "string") then
        local folder = self.folder .. "\\themes"
        local file = ("%s\\%s.json"):format(folder, name)

        if isfile(file) then
            local theme = services.HttpService:JSONDecode(readfile(file))

            for option, color in next, theme do
                theme[option] = fromHex(color)
            end

            library:OverrideTheme(theme)
        end
    end
end

function library:SaveTheme(name)
    if typeof(name) == "string" and name:find("%S+") then
        if self.themes[name] then
            name = name .. " (1)"
        end

        local theme = {}

        for option, color in next, self.theme do
            theme[option] = color:ToHex()
        end

        local theme_str = services.HttpService:JSONEncode(theme)
        local folder = self.folder .. "\\themes"
        local file = ("%s\\%s.%s"):format(folder, name, self.extension)

        if not isfolder(folder) then
            makefolder(folder)
        end

        writefile(file, theme_str)

        return true
    end
end

function library:GetThemes()
    local folder = self.folder .. "\\themes"
    local themes = {}

    for theme, _ in next, self.themes do
        themes[#themes + 1] = theme
    end

    if isfolder(folder) then
        for _, theme in next, listfiles(folder) do
            themes[#themes + 1] = theme:gsub(folder .. "\\", ""):split(".")[1]
        end
    end

    return themes
end

function library:DeleteTheme(name)
    if typeof(name) == "string" then
        local folder = self.folder .. "\\themes"
        local file = ("%s\\%s.%s"):format(folder, name, self.extension)

        if isfile(file) then
            delfile(file)
            return true
        end
    end
end

function library:Loader(options)
    utility.format(options);

    utility.defaults(options, {
        title = "Exodus",
        description = "Loading...",
        percentage = 50,
        date = "16/01/22",
        added = {},
        changed = {},
        removed = {},
        callback = function() end,
    });

    local sizeX = 310;
    local sizeY = 123;

    local window = Render:Create("Square", {
        Size = newUDim2(0, sizeX, 0, 22),
        Position = utility.center(sizeX, sizeY),
        ZIndex = 140,
        Outline = false,
        Visible = true,
        Transparency = 0
    });

    window:Create("Text", {
        Text = options.title,
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0, 6, 0, 4),
        Theme = "Text",
        ZIndex = 124
    });

    local main = window:Create("Square", {
        Size = newUDim2(1, 0, 0, sizeY),
        ZIndex = 123,
        Theme = "Window Background",
        Outline = false
    });

    main:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 122,
        OutlineTheme = "Black Border"
    });

    local background = main:Create("Square", {
        Size = newUDim2(1, 0, 1, -22),
        Position = newUDim2(0, 0, 0, 22),
        ZIndex = 125,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    });

    local holder = background:Create("Square", {
        Size = newUDim2(1, -12, 1, -12),
        Position = newUDim2(0, 6, 0, 6),
        Transparency = 0,
        Visible = true,
        Outline = false
    });

    local change_log = holder:Create("Square", {
        Visible = false,
        Size = newUDim2(1, 0, 0, 0),
        Position = newUDim2(0, 0, 0, 97),
        ZIndex = 128,
        Theme = "Tab Background",
        Outline = false
    });

    change_log:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Tab Border",
        ZIndex = 127,
        OutlineTheme = "Black Border"
    });

    change_log:Create("Text", {
        Text = "Changelog - Last Update: " .. options.date,
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0, 6, 0, 4),
        Theme = "Text",
        ZIndex = 129
    });

    local bound_addition = 0;

    for _, text in next, options.added do
        bound_addition += change_log:Create("Text", {
            Text = "+ " .. text,
            Font = self.font,
            Size = self.font_size,
            Position = newUDim2(0, 6, 0, 20 + bound_addition),
            Color = newColor3(0.46, 1, 0.69),
            ZIndex = 129
        }).TextBounds.Y;
    end

    for _, text in next, options.changed do
        bound_addition += change_log:Create("Text", {
            Text = "* " .. text,
            Font = self.font,
            Size = self.font_size,
            Position = newUDim2(0, 6, 0, 20 + bound_addition),
            Theme = "Disabled Text",
            ZIndex = 129
        }).TextBounds.Y;
    end

    for _, text in next, options.removed do
        bound_addition += change_log:Create("Text", {
            Text = "- " .. text,
            Font = self.font,
            Size = self.font_size,
            Position = newUDim2(0, 6, 0, 20 + bound_addition),
            Color = newColor3(1, 0.258823, 0.258823),
            ZIndex = 129
        }).TextBounds.Y;
    end

    change_log.Size = newUDim2(1, 0, 0, bound_addition + 26);

    local textbounds = utility.text_length(options.description, self.font, self.font_size);

    local description_text = holder:Create("Text", {
        Text = options.description,
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0.5, -textbounds.X * 0.5, 0, 2.5),
        Theme = "Text",
        ZIndex = 126
    });

    local slider = holder:Create("Square", {
        Size = newUDim2(1, 0, 0, 10),
        Position = newUDim2(0, 0, 0, 25),
        ZIndex = 126,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    });

    local fill = slider:Create("Square", {
        Size = newUDim2(options.percentage * 0.01, 0, 1, 0),
        ZIndex = 127,
        Ignored = true,
        Theme = "Accent",
        Outline = false
    });

    fill:Create("Image", {
        Size = newUDim2(1, 0, 1, 0),
        Transparency = 0.5,
        ZIndex = 128,
        Data = decode("iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABuSURBVChTxY9BDoAgDASLGD2ReOYNPsR/+BAfroI7hibe9OYmky2wbUPIOdsXdc1f9WMwppQm+SDGBnUvomAQBH49qzhFEag25869ElzaIXDhD4JGbyoEVxUedN8FKwnfmwhucgKICc+pNB1mZhdCdhsa2ky0FAAAAABJRU5ErkJggg==")
    })

    local load = holder:Create("Square", {
        Position = newUDim2(0, 0, 0, 42),
        Size = newUDim2(0.5, -4, 0, 20),
        ZIndex = 126,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    });

    utility.auto_button_color(load, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    load:Create("Text", {
        Text = "Load",
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0.5, 0, 0, 3),
        Theme = "Text",
        Center = true,
        ZIndex = 127
    });

    local close = holder:Create("Square", {
        Position = newUDim2(0.5, 4, 0, 42),
        Size = newUDim2(0.5, -4, 0, 20),
        ZIndex = 126,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    });

    utility.auto_button_color(close, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    close:Create("Text", {
        Text = "Close",
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0.5, 0, 0, 3),
        Theme = "Text",
        Center = true,
        ZIndex = 127
    });

    local changelog = holder:Create("Square", {
        Position = newUDim2(0, 0, 0, 69),
        Size = newUDim2(1, 0, 0, 20),
        ZIndex = 126,
        Theme = "Object Background",
        OutlineTheme = "Object Border"
    });

    utility.auto_button_color(changelog, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))

    changelog:Create("Text", {
        Text = "Changelog",
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0.5, 0, 0, 3),
        Theme = "Text",
        Center = true,
        ZIndex = 127
    });

    local function resize()
        main.Size = newUDim2(1, 0, 0, sizeY + (change_log.Visible and 34 + bound_addition or 0));
        window.Position = utility.center(window.AbsoluteSize.X, main.AbsoluteSize.Y);
    end

    load.MouseButton1Click:Connect(options.callback);

    changelog.MouseButton1Click:Connect(function()
        change_log.Visible = not change_log.Visible;
        resize();
    end);

    resize();

    local loader_types = {};

    function loader_types:Set(description, percentage)
        local textbounds = utility.text_length(description, library.font, library.font_size);
        description_text.Text = description;
        description_text.Position = newUDim2(0.5, -textbounds.X * 0.5, 0, 2.5);

        fill.Size = newUDim2(percentage * 0.01, 0, 1, 0);
    end

    function loader_types:Close()
        window:Destroy();
    end

    close.MouseButton1Click:Connect(function()
        loader_types:Close();
    end);

    utility.format(loader_types, true);
    return loader_types;
end

local left = library.notification_x == "left"
local top = library.notification_y == "top"

library.notification_holder = Render:Create("Square", {
    Transparency = 0,
    Size = newUDim2(0, 1, 0, 36),
    Position = newUDim2(left and 0 or 1, left and 10 or -10, top and 0 or 1, top and 10 or -46),
    Outline = false
}, true)

function library:ChangeNotificationPosition(x, y)
    self.notification_x = x and x:lower() or self.notification_x
    self.notification_y = y and y:lower() or self.notification_y

    if self.notification_holder then
        local left = self.notification_x == "left"
        local top = self.notification_y == "top"

        for _, notification in next, self.notification_holder:GetChildren() do
            if notification._currentTween then
                notification._currentTween:Cancel()
                notification._currentTween.Completed:Fire()
            end
        end

        self.notification_holder.Position = newUDim2(left and 0 or 1, left and 10 or -10, top and 0 or 1, top and 10 or -46)

        for i, notification in next, self.notifications do
            notification.Position = newUDim2(0, left and 0 or -notification.AbsoluteSize.X, 0, top and (i - 1) * 46 or (-i + 1) * 46)
        end
    end
end

function library:Notify(options)
    utility.format(options)

    utility.defaults(options, {
        title = "warn",
        message = "moderator found or whatever server hop aaaaaaaaaaa",
        duration = 1
    })

    local left = self.notification_x == "left"
    local top = self.notification_y == "top"

    local notification = Render:Create("Square", {
        ZIndex = 5,
        Theme = "Window Background",
        Parent = self.notification_holder,
        Outline = false
    }, true)

    local idx = #self.notifications + 1
    self.notifications[idx] = notification

    notification:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Background",
        OutlineTheme = "Black Border",
        ZIndex = 4,
    });

    notification:Create("Square", {
        Size = newUDim2(1, 0, 0, 19),
        ZIndex = 6,
        Theme = "Window Background",
        Outline = false
    }):Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 5,
        OutlineTheme = "Black Border"
    });

    notification:Create("Square", {
        Size = newUDim2(1, 0, 1, -19),
        Position = newUDim2(0, 0, 0, 19),
        ZIndex = 7,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    });

    notification:Create("Text", {
        Text = options.title,
        Font = library.font,
        Size = library.font_size,
        Ignored = true,
        Position = newUDim2(0, 6, 0, 3),
        [options.color and "Color" or "Theme"] = options.color or "Accent",
        ZIndex = 8,
        Outline = true,
    }, true)

    local message = notification:Create("Text", {
        Text = options.message,
        Font = library.font,
        Ignored = true,
        Size = library.font_size,
        Position = newUDim2(0, 6, 0, 24),
        Theme = "Text",
        ZIndex = 8,
        Outline = true,
    }, true)

    notification.Size = newUDim2(0, message.TextBounds.X + 30, 0, 40)

    notification.Position = newUDim2(left and -1 or 1, left and -(notification.AbsoluteSize.X + 12) or 12, 0, top and (idx - 1) * 46 or (-idx + 1) * 46)
    notification:Tween(newInfo(self.notification_speed, library.easing_style), {Position = newUDim2(0, left and 0 or -notification.AbsoluteSize.X, 0, top and (idx - 1) * 46 or (-idx + 1) * 46)})

    local function dismiss()
        local idx = find(self.notifications, notification)
        remove(self.notifications, idx)

        notification:Tween(newInfo(self.notification_speed, library.easing_style), {Position = newUDim2(self.notification_x == "left" and -1 or 1, self.notification_x == "left" and -(notification.AbsoluteSize.X + 12) or 12, 0, self.notification_y == "top" and (idx - 1) * 46 or (-idx + 1) * 46)}).Completed:Connect(function()
            notification:Destroy()

            for i, notification in next, self.notifications do
                notification:Tween(newInfo(self.notification_speed, library.easing_style), {Position = newUDim2(0, self.notification_x == "left" and 0 or -notification.AbsoluteSize.X, 0, self.notification_y == "top" and (i - 1) * 46 or (-i + 1) * 46)})
            end
        end)
    end

    notification.MouseButton1Click:Connect(dismiss)

    spawn(function()
        wait(options.duration)
        dismiss()
    end)
end

function library:ChangeWatermarkPosition(x, y)
    self.watermark_x = x and x:lower() or self.watermark_x
    self.watermark_y = y and y:lower() or self.watermark_y

    if self.watermark then
        self.watermark.Position = newUDim2(self.watermark_x == "left" and 0 or 1, self.watermark_x == "left" and 16 or -(self.watermark.AbsoluteSize.X + 16), self.watermark_y == "top" and 0 or 1, self.watermark_y == "top" and 16 or -36)
    end
end

function library:Watermark(str)
    self.watermark = Render:Create("Square", {
        Position = newUDim2(0, 16, 0, 16),
        ZIndex = 63,
        Visible = false,
        Theme = "Window Background",
        Outline = false
    }, true)

    self.watermark:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 62,
        OutlineTheme = "Black Border"
    }, true)

    local text = self.watermark:Create("Text", {
        Text = str,
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0, 8, 0, 3),
        Theme = "Text",
        ZIndex = 64,
        Outline = true,
    }, true)

    local watermark_types = {}

    function watermark_types:Toggle()
        library.watermark.Visible = not library.watermark.Visible
    end

    function watermark_types:Set(str)
        text.Text = str
        library.watermark.Size = newUDim2(0, text.TextBounds.X + 16, 0, 20)

        library.watermark.Position = newUDim2(library.watermark_x == "left" and 0 or 1, library.watermark_x == "left" and 16 or -(library.watermark.AbsoluteSize.X + 16), library.watermark_y == "top" and 0 or 1, library.watermark_y == "top" and 16 or -36)
    end

    watermark_types:Set(str)

    utility.format(watermark_types, true)
    return watermark_types
end

function library:List(options)
    return components.list(options)
end

function library:Playerlist(max_players)
    local list = Render:Create("Square", {
        Size = newUDim2(0, 400, 0, 406),
        Position = newUDim2(0, self.holder.AbsolutePosition.X + self.window_x / 2 + 362, 0, self.holder.AbsolutePosition.Y),
        ZIndex = 23,
        Theme = "Window Background",
        Outline = false,
    })

    list:Create("Square", {
        Size = newUDim2(1, 0, 1, -22),
        Position = newUDim2(0, 0, 0, 22),
        ZIndex = 24,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border",
    })

    list:Create("Text", {
        Text = "Playerlist",
        Font = library.font,
        Size = library.font_size,
        Position = newUDim2(0, 6, 0, 4),
        Theme = "Text",
        ZIndex = 24
    }, true)

    local scroll_object = list:Create("Square", {
        Size = newUDim2(1, 0, 1, 0),
        Transparency = 0,
        Outline = false,
        Ignored = true,
        ZIndex = 32
    })

    scroll_object.MouseEnter:Connect(function()
        services.ContextActionService:BindAction("disable_mouse_input", function()
            return Enum.ContextActionResult.Sink
        end, false, Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3, Enum.UserInputType.MouseWheel)
    end)

    scroll_object.MouseLeave:Connect(function()
        services.ContextActionService:UnbindAction("disable_mouse_input")
    end)

    list:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 22,
        OutlineTheme = "Black Border"
    }, true)

    local drag_outline = Render:Create("Square", {
        Size = newUDim2(0, 400, 0, 406),
        Thickness = 1,
        Filled = false,
        Theme = "Accent",
        Visible = false,
        Outline = false,
        ZIndex = 21,
    }, true)

    library.drag_outlines[drag_outline] = true

    drag_outline:Create("Square", {
        Size = newUDim2(1, 0, 1, 0),
        Filled = false,
        Theme = "Black Border",
        ZIndex = 20,
        Thickness = 2,
        Outline = false
    }, true)

    utility.dragify(list, drag_outline)
    
    local holder = list:Create("Square", {
        Size = newUDim2(1, -20, 1, -60),
        Position = newUDim2(0, 6, 0, 28),
        Transparency = 0,
        Outline = false
    })

    holder:AddList(4)

    local labels = {}
    local current_scroll = 0
    local players = {}
    local player_data = {}
    local current_player
    local cutoff = 194
    local scrolling = false
    local tile_size = 18
    local max_bars = floor((list.AbsoluteSize.Y + 94 - cutoff) / (tile_size + 4))
    max_players = max_players - max_bars

    local indicator_holder = list:Create("Square", {
        Size = newUDim2(0, 4, 1, -126),
        Position = newUDim2(1, -10, 0, 28),
        Theme = "Tab Background",
        Outline = false,
        ZIndex = 30
    })

    local indicator = indicator_holder:Create("Square", {
        ZIndex = 31,
        Theme = "Accent",
        Outline = false,
        Ignored = true,
        Size = newUDim2(1, 0, 1 / max_players, 0)
    })

    local card = list:Create("Square", {
        ZIndex = 27,
        Theme = "Section Background",
        Position = newUDim2(0, 6, 1, -88),
        OutlineTheme = "Section Border",
        Size = newUDim2(1, -12, 0, 80)
    })

    local name = card:Create("Text", {
        Text = "",
        Font = library.font,
        Size = library.font_size,
        Center = false,
        Position = newUDim2(0, 60, 0, 8),
        Theme = "Text",
        ZIndex = 28
    })

    local headshot_bg = card:Create("Square", {
        ZIndex = 29,
        Theme = "Object Background",
        OutlineTheme = "Object Border",
        Position = newUDim2(0, 6, 0, 6),
        Size = newUDim2(0, 48, 0, 48)
    })

    local headshot = headshot_bg:Create("Image", {
        ZIndex = 30,
        Position = newUDim2(0, 2, 0, 2),
        Size = newUDim2(1, -2, 1, -2)
    })
    
    local fix = headshot_bg:Create("Square", {
        ZIndex = 31,
        Theme = "Object Background",
        Outline = false,
        Position = newUDim2(0, 0, 0, 1),
        Size = newUDim2(1, 0, 0, 2)
    })

    local function update()
        for plr, data in next, player_data do
            local i = find(players, plr)
            data.bar.Visible = ((i - current_scroll) * tile_size + (i - current_scroll - 1) * 4 + tile_size / 2 < (list.AbsoluteSize.Y + 94 - cutoff) and i > current_scroll)
        end
    end

    local function handle_player()
        local data = player_data[current_player]

        name.Text = data and data.name or ""
        headshot.Data = data and data.image or ""

        for _, handler in next, labels do
            handler(current_player)
        end
    end

    local function create_card(plr)
        if not player_data[plr].image then
            current_player = plr
            player_data[plr].name = plr.Name

            spawn(function()
                local thumbnail_data = services.HttpService:JSONDecode(syn.request{Url = ("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%s&size=60x60&format=Png"):format(plr.UserId), Method = "GET"}.Body)
                local image = syn.request{Url = thumbnail_data.data[1].imageUrl, Method = "GET"}.Body

                player_data[plr].image = image
                
                if current_player == plr then
                    headshot.Data = image
                end
            end)
        else
            if current_player ~= plr then
                current_player = plr
            else
                current_player = nil
            end
        end

        handle_player()
    end

    local function create_player(plr)
        if not self.unloaded then
            local idx = #players + 1
            players[idx] = plr

            local bar = Render:Create("Square", {
                ZIndex = 27,
                Theme = "Section Background",
                OutlineTheme = "Section Border",
                Size = newUDim2(1, 0, 0, tile_size)
            })

            local bounds = bar:Create("Text", {
                Text = plr.Name,
                Font = library.font,
                Size = library.font_size,
                Center = false,
                Position = newUDim2(0, 12, 0, 2),
                Theme = "Text",
                ZIndex = 28
            }).TextBounds.X

            player_data[plr] = {tags = {}, tag_size = bounds + 32, name = plr.Name, bar = bar}

            -- parent after cuz my extension is goofy like that
            bar.Parent = holder

            update()

            bar.MouseButton1Click:Connect(function()
                create_card(plr)
            end)
        end
    end

    local function remove_plr(plr)
        local idx = find(players, plr)
        remove(players, idx)

        player_data[plr].bar:Destroy()
        player_data[plr] = nil

        --update the list cuz it doesnt update itself for some reason
        holder.Position = holder.Position
        update()
    end

    local function scroll(amount)
        current_scroll = clamp(amount, 0, max_players)

        if current_scroll > 0 then
            holder.Position = newUDim2(0, 6, 0, current_scroll * -tile_size - ((current_scroll) * 4) + 28)
        else
            holder.Position = newUDim2(0, 6, 0, 28)
        end

        indicator.Position = newUDim2(0, 0, (1 / (max_players + 1)) * current_scroll)
        update()
    end

    local function update_scroll(input)
        local sizeY = clamp((input.Position.Y - indicator_holder.AbsolutePosition.Y + inset) / indicator_holder.AbsoluteSize.Y, 0, 1)
        local value = round(clamp(max_players * sizeY, 0, max_players))

        scroll(value)
    end

    indicator_holder.MouseButton1Down:Connect(function()
        scrolling = true
        update_scroll{Position = services.UserInputService:GetMouseLocation() - newVector2(0, 36)}
    end)

    self:Connect(services.UserInputService.InputChanged, function(input)
        if scrolling and input.UserInputType == Enum.UserInputType.MouseMovement then
            update_scroll(input)
        end
    end)

    self:Connect(services.UserInputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            scrolling = false
        end
    end)

    scroll_object.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            if input.Position.Z > 0 then
                scroll(current_scroll - 1)
            else
                scroll(current_scroll + 1)
            end
        end
    end)

    self:Connect(services.Players.PlayerRemoving, remove_plr)
    self:Connect(services.Players.PlayerAdded, create_player)

    for _, plr in next, services.Players:GetChildren() do
        create_player(plr)
    end

    self.Playerlist = {button_size = 0, labels = 0, object = list, toggled = true}

    function library.Playerlist:Button(options)
        utility.format(options)

        utility.defaults(options, {
            name = "button",
            callback = function() end
        })

        local button = card:Create("Square", {
            ZIndex = 29,
            Theme = "Object Background",
            OutlineTheme = "Object Border"
        })
    
        if options.tooltip then
            components.tooltip(button, options.tooltip)
        end
    
        utility.auto_button_color(button, "Object Background", fromRGB(3, 3, 3), fromRGB(8, 8, 8))
    
        local text = button:Create("Text", {
            Text = options.name,
            Font = library.font,
            Size = library.font_size,
            Position = newUDim2(0.5, 0, 0, 1),
            Theme = "Text",
            Center = true,
            ZIndex = 30
        })

        self.button_size += text.TextBounds.X + 38
        button.Size = newUDim2(0, text.TextBounds.X + 32, 0, 15)
        button.Position = newUDim2(1, -self.button_size, 1, -21)

        button.MouseButton1Click:Connect(function()
            options.callback(self, current_player)
        end)
    end

    function library.Playerlist:Label(options)
        utility.format(options)

        utility.defaults(options, {
            name = "User ID: ",
            handler = function(plr)
                return plr.UserId
            end
        })

        local label = card:Create("Text", {
            Font = library.font,
            Size = library.font_size,
            Center = false,
            Position = newUDim2(0, 60, 0, 24 + (self.labels * 14)),
            Theme = "Text",
            ZIndex = 28
        })

        local function handle(plr)
            if plr then
                label.Visible = true

                local text, color = options.handler(plr)
                label.Text = options.name .. text
                
                if color then
                    library:ChangeThemeObject(label, nil)
                    label.Color = color
                else
                    library:ChangeThemeObject(label, "Text")
                end
            else
                label.Visible = false
            end
        end

        labels[#labels + 1] = handle
        handle(current_player)

        self.labels += 1
    end

    function library.Playerlist:Tag(options)
        utility.format(options)

        utility.defaults(options, {
            player = services.Players.LocalPlayer,
            text = "PRIORITIZED",
            color = fromRGB(255, 0, 0)
        })

        local data = player_data[options.player]
        
        local tag = data.bar:Create("Text", {
            Text = options.text,
            Font = library.font,
            Size = library.font_size,
            Center = false,
            Position = newUDim2(0, data.tag_size, 0, 2),
            Color = options.color,
            ZIndex = 28
        })

        data.tag_size += tag.TextBounds.X + 8
        data.tags[options.text] = tag
    end

    function library.Playerlist:RemoveTag(player, text)
        local data = player_data[player]
        local tag = data.tags[text]

        if tag then
            data.tag_size -= tag.TextBounds.X + 8
            data.tags[text] = nil

            for _, object in next, data.tags do
                if object.Position.X.Offset > tag.Position.X.Offset then
                    object.Position -= newUDim2(0, tag.TextBounds.X + 8, 0, 0)
                end
            end

            tag:Destroy()
        end
    end

    function library.Playerlist:IsTagged(player, tag)
        return player_data[player].tags[tag]
    end

    utility.format(library.Playerlist, true)
end

function library:Window(options)
    utility.format(options);

    utility.defaults(options, {
        title = "Window",
        visible = true,
        doublecolumns = true,
        sizex = 200,
        sizey = 260,
    });

    local window = Render:Create("Square", {
        Size = newUDim2(0, options.sizex, 0, 22),
        Position = newUDim2(0, self.holder.AbsolutePosition.X - self.window_x / 2 + options.sizex - 62, 0, self.holder.AbsolutePosition.Y),
        ZIndex = 99,
        Outline = false,
        Visible = options.visible,
        Transparency = 0
    })

    window:Create("Text", {
        Text = options.title,
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0, 6, 0, 4),
        Theme = "Text",
        ZIndex = 74
    })

    local main = window:Create("Square", {
        Size = newUDim2(1, 0, 0, options.sizey),
        ZIndex = 73,
        Theme = "Window Background",
        Outline = false
    })

    local drag_outline = Render:Create("Square", {
        Size = newUDim2(0, options.sizex, 0, options.sizey),
        Thickness = 1,
        Filled = false,
        Visible = false,
        Theme = "Accent",
        Outline = false,
        ZIndex = 72,
    }, true)

    library.drag_outlines[drag_outline] = true

    drag_outline:Create("Square", {
        Size = newUDim2(1, 0, 1, 0),
        Filled = false,
        Theme = "Black Border",
        Thickness = 2,
        Outline = false
    }, true)

    utility.dragify(window, drag_outline)

    main:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 72,
        OutlineTheme = "Black Border"
    })

    local background = main:Create("Square", {
        Size = newUDim2(1, 0, 1, -22),
        Position = newUDim2(0, 0, 0, 22),
        ZIndex = 75,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    });

    local holder = background:Create("Square", {
        Size = newUDim2(1, -12, 1, -12),
        Position = newUDim2(0, 6, 0, 6),
        Transparency = 0,
        Visible = true,
        Outline = false
    });

    local left_column = holder:Create("Square", {
        Transparency = 0,
        Outline = false,
        Size = newUDim2(1 / 2, -6, 1, 0)
    });

    left_column:AddList(12);

    local right_column = holder:Create("Square", {
        Transparency = 0,
        Outline = false,
        Size = newUDim2(1 / 2, -6, 1, 0),
        Position = newUDim2(1 / 2, 6, 0, 0)
    });

    right_column:AddList(12);

    local window_types = {Visible = options.visible, tab = holder, tab_buttons = {}, text_bounds = 0, double_columns = options.doublecolumns, left_column = left_column};
    self.windows[window] = window_types;

    --[[function window_types:SubTab(name)
        self.has_subtabs = true
        local first = #self.tab:GetChildren() == 2

        local tab_button = self.tab:Create("Text", {
            Text = name,
            Font = library.font,
            Size = library.font_size,
            Center = false,
            Position = newUDim2(0, self.text_bounds, 0, 0),
            Theme = first and "Text" or "Disabled Text",
            ZIndex = 79
        })

        self.tab_buttons[tab_button] = true
        self.text_bounds += tab_button.TextBounds.X + 7

        local tab = self.tab:Create("Square", {
            Size = newUDim2(1, 0, 1, -12),
            Position = newUDim2(0, 0, 0, 19),
            Transparency = 0,
            Visible = first,
            Outline = false
        })

        local left_column = tab:Create("Square", {
            Transparency = 0,
            Outline = false,
            Size = newUDim2(1 / 2, -6, 1, 0)
        });

        left_column:AddList(12);

        local right_column = tab:Create("Square", {
            Transparency = 0,
            Outline = false,
            Size = newUDim2(1 / 2, -6, 1, 0),
            Position = newUDim2(1 / 2, 6, 0, 0)
        });

        right_column:AddList(12);

        tab_button.MouseButton1Click:Connect(function()
            if not tab.Visible then
                for _, object in next, self.tab:GetChildren() do
                    if object ~= tab and object._class ~= "Text" then
                        object.Visible = false
                    end
                end

                for object, _ in next, self.tab_buttons do
                    if object ~= tab_button then
                        library:ChangeThemeObject(object, "Disabled Text")
                    end
                end

                library:ChangeThemeObject(tab_button, "Text")
                tab.Visible = true
            end
        end)

        local column_types = clone(self)

        column_types.has_subtabs = false
        column_types.SubTab = nil
        column_types.right_column = right_column
        column_types.left_column = left_column

        return column_types
    end]]

    function window_types:Section(options)
        if self.has_subtabs then return end

        utility.format(options);

        utility.defaults(options, {
            name = "Section",
            side = "left",
        });

        local side = options.side:lower();
        local column = self.double_columns and (side == "left" and left_column or right_column) or left_column;

        local section = column:Create("Square", {
            Size = newUDim2(1, 0, 0, 40),
            ZIndex = 77,
            Theme = "Section Background",
            OutlineTheme = "Section Border"
        });

        local title_background = section:Create("Square", {
            Size = newUDim2(1, 0, 0, 18),
            ZIndex = 79,
            Theme = "Section Background",
            OutlineTheme = "Section Border"
        });

        title_background:Create("Text", {
            Text = options.name,
            Font = library.font,
            Size = library.font_size,
            Position = newUDim2(0, 6, 0, 2),
            Theme = "Text",
            ZIndex = 80
        });

        local section_content = section:Create("Square", {
            Size = newUDim2(1, -10, 0, 0),
            Position = newUDim2(0, 5, 0, 23),
            Transparency = 0,
            Visible = true,
            Outline = false
        });

        section_content:AddList(8);

        local section_types = {tab = window_types, main = section, content = section_content, Resize = function(self)
            if self.content._list._contentSize + 20 > self.main.AbsoluteSize.Y then
                self.main.Size = newUDim2(1, 0, 0, self.content._list._contentSize + 20)
            end
        end};

        function section_types:Label(str)
            str = str or "label"

            local label = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                Outline = false
            }):Create("Text", {
                Text = str,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 78
            })

            self:Resize()

            local label_types = {}

            function label_types:Set(str)
                label.Text = str
            end

            utility.format(label_types, true)
            return label_types
        end

        function section_types:Separator(str)
            return components.separator(self, str, 80)
        end

        function section_types:Button(options)
            return components.button(self, options, 79)
        end

        function section_types:Toggle(options)
            utility.format(options)
            options.name = options.name or "toggle"

            local holder = {colorpickers = 0, section = self, name = options.name}

            holder.main = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                ZIndex = 80,
                Outline = false
            })

            holder.text = holder.main:Create("Text", {
                Text = options.name,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 79
            })

            return components.toggle(holder, options, 79);
        end

        function section_types:Box(options)
            return components.box(self, options, 79)
        end

        function section_types:Slider(options)
            utility.format(options)
            options.name = options.name or "slider"

            local holder = {section = self}

            holder.main = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                ZIndex = 80,
                Outline = false
            })

            holder.main:Create("Text", {
                Text = options.name,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 79
            })

            return components.slider(holder, options, 81)
        end

        function section_types:Dropdown(options)
            utility.format(options)
            options.name = options.name or "dropdown"

            local holder = {section = self}

            holder.main = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                Outline = false
            })

            holder.main:Create("Text", {
                Text = options.name,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 78
            })

            return components.dropdown(holder, options, 81)
        end

        function section_types:Keybind(options)
            utility.format(options)
            options.name = options.name or "keybind"

            local holder = {section = self, name = options.name}

            holder.main = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                ZIndex = 80,
                Outline = false
            })

            holder.text = holder.main:Create("Text", {
                Text = options.name,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 79
            })

            self:Resize()

            return components.keybind(holder, options, 81)
        end

        function section_types:Colorpicker(options)
            utility.format(options)
            options.name = options.name or "colorpicker"

            local holder = {colorpickers = 0, section = self}

            holder.main = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                ZIndex = 80,
                Outline = false
            })

            holder.text = holder.main:Create("Text", {
                Text = options.name,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 79
            })

            self:Resize()

            return components.colorpicker(holder, options, 81)
        end

        function section_types:Subgroup(options)
            utility.format(options);
            options.name = options.name or "subgroup";

            local holder = {section = self}

            holder.main = self.content:Create("Square", {
                Size = newUDim2(1, 0, 0, 13),
                Transparency = 0,
                ZIndex = 80,
                Outline = false
            });
            
            holder.text = holder.main:Create("Text", {
                Text = options.name,
                Font = library.font,
                Size = library.font_size,
                Theme = "Text",
                ZIndex = 79
            });

            self:Resize();

            return components.subgroup(holder, options, 81);
        end

        utility.format(section_types, true);
        return section_types;
    end

    function window_types:Toggle()
        window_types.Visible = not window_types.Visible;

        if library.open then
            window.Visible = window_types.Visible
        end
    end

    utility.format(window_types, true);
    return window_types;
end

function library:Load(options)
    utility.format(options)

    utility.defaults(options, {
        title = options.name or "exodus",
        theme = "Default",
        overrides = {},
        folder = "exodus",
        extension = "json",
        game = "universal",
        tweenspeed = options.animspeed or 0.1,
        easingstyle = Enum.EasingStyle.Linear,
        togglespeed = 0.2,
        notificationspeed = options.notifspeed or 0.2,
        notificationxalignment = "right",
        notificationyalignment = "bottom",
        watermarkxalignment = "left",
        watermarkyalignment = "top",
        playerlist = false,
        playerlistmax = options.maxplayers or 32,
        performancedrag = true,
        keybindlist = true,
        font = worldtoscreen ~= nil and "system" or "plex",
        fontsize = 13,
        discord = "6wp393UeCc",
        sizex = 700,
        sizey = 550
    })

    options.font = options.font:lower()

    self.font_size = options.fontsize
    self.font = Render.Fonts[options.font:lower():gsub("^%l", upper)]
    self.tween_speed = options.tweenspeed
    self.easing_style = options.easingstyle
    self.toggle_speed = options.togglespeed
    self.notification_speed = options.notificationspeed
    self.notification_x = options.notificationxalignment:lower()
    self.notification_y = options.notificationyalignment:lower()
    self.watermark_x = options.watermarkxalignment:lower()
    self.watermark_y = options.watermarkyalignment:lower()
    self.window_x = options.sizex
    self.window_y = options.sizey
    self.performance_drag = options.performancedrag
    self.theme = clone(self.themes[options.theme])
    self.folder = options.folder
    self.discord = options.discord
    self.keybind_list_default = options.keybindlist
    self.extension = options.extension
    self.game = options.game

    for theme, value in next, options.overrides do
        self.theme[theme] = value
    end

    self.keybind_list = components.list{name = "Keybinds", flag = "keybind list", position = newUDim2(0, 16, 0.5, -100)}

    if not options.keybindlist then
        self.keybind_list:Toggle()
    end

    self.holder = Render:Create("Square", {
        Size = newUDim2(0, options.sizex, 0, 22),
        Position = utility.center(options.sizex, options.sizey),
        ZIndex = 100,
        Outline = false,
        Visible = false,
        Transparency = 0
    })

    if options.playerlist then
        self:Playerlist(options.playerlistmax)
    end

    self.title_bounds = self.holder:Create("Text", {
        Text = options.title .. " |  ",
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(0, 6, 0, 4),
        Theme = "Text",
        ZIndex = 4
    }).TextBounds.X
    
    self.holder:Create("Text", {
        Text = "X",
        Font = self.font,
        Size = self.font_size,
        Position = newUDim2(1, -19, 0, 4),
        Theme = "Text",
        ZIndex = 4
    }).MouseButton1Click:Connect(function()
        library:Toggle()
    end)
    
    local main = self.holder:Create("Square", {
        Size = newUDim2(1, 0, 0, options.sizey),
        ZIndex = 3,
        Theme = "Window Background",
        Outline = false
    })

    local drag_outline = Render:Create("Square", {
        Size = newUDim2(0, options.sizex, 0, options.sizey),
        Thickness = 1,
        Filled = false,
        Visible = false,
        Theme = "Accent",
        Outline = false,
        ZIndex = 2,
    }, true)

    library.drag_outlines[drag_outline] = true

    drag_outline:Create("Square", {
        Size = newUDim2(1, 0, 1, 0),
        Filled = false,
        Theme = "Black Border",
        Thickness = 2,
        Outline = false
    }, true)

    utility.dragify(self.holder, drag_outline)

    main:Create("Square", {
        Size = newUDim2(1, 2, 1, 2),
        Position = newUDim2(0, -1, 0, -1),
        Theme = "Window Border",
        ZIndex = 2,
        OutlineTheme = "Black Border"
    })

    local tab_background = main:Create("Square", {
        Size = newUDim2(1, 0, 1, -22),
        Position = newUDim2(0, 0, 0, 22),
        ZIndex = 5,
        Theme = "Tab Background",
        OutlineTheme = "Tab Border"
    })
    
    local window_types = {tab_buttons = {}, text_bounds = library.title_bounds, player_cache = {}}

    function window_types:Tab(name)
        name = name or "tab"
        
        local first = #tab_background:GetChildren() == 0

        local tab_button = library.holder:Create("Text", {
            Text = name,
            Font = library.font,
            Size = library.font_size,
            Center = false,
            Position = newUDim2(0, self.text_bounds, 0, 4),
            Theme = first and "Text" or "Disabled Text",
            ZIndex = 4
        })

        self.tab_buttons[tab_button] = true
        self.text_bounds += tab_button.TextBounds.X + 7

        local tab = tab_background:Create("Square", {
            Size = newUDim2(1, -12, 1, -12),
            Position = newUDim2(0, 6, 0, 6),
            Transparency = 0,
            Visible = first,
            Outline = false
        })

        local left_column = tab:Create("Square", {
            Transparency = 0,
            Outline = false,
            Size = newUDim2(1 / 3, -6, 1, 0)
        })

        left_column:AddList(12)

        local middle_column = tab:Create("Square", {
            Transparency = 0,
            Outline = false,
            Size = newUDim2(1 / 3, -6, 1, 0),
            Position = newUDim2(1 / 3, 3, 0, 0)
        })

        middle_column:AddList(12)

        local right_column = tab:Create("Square", {
            Transparency = 0,
            Outline = false,
            Size = newUDim2(1 / 3, -6, 1, 0),
            Position = newUDim2(2 / 3, 6, 0, 0)
        })

        right_column:AddList(12)

        tab_button.MouseButton1Click:Connect(function()
            if not tab.Visible then
                for _, object in next, tab_background:GetChildren() do
                    if object ~= tab then
                        object.Visible = false
                    end
                end

                for object, _ in next, self.tab_buttons do
                    if object ~= tab_button then
                        library:ChangeThemeObject(object, "Disabled Text")
                    end
                end

                library:ChangeThemeObject(tab_button, "Text")
                tab.Visible = true
            end
        end)

        local tab_types = {tab = tab, middle_column = middle_column, right_column = right_column, left_column = left_column, has_subtabs = false, text_bounds = 0, tab_buttons = {}}

        function tab_types:SubTab(name)
            self.has_subtabs = true
            local first = #self.tab:GetChildren() == 3

            local tab_button = self.tab:Create("Text", {
                Text = name,
                Font = library.font,
                Size = library.font_size,
                Center = false,
                Position = newUDim2(0, self.text_bounds, 0, 0),
                Theme = first and "Text" or "Disabled Text",
                ZIndex = 5
            })
    
            self.tab_buttons[tab_button] = true
            self.text_bounds += tab_button.TextBounds.X + 7
    
            local tab = self.tab:Create("Square", {
                Size = newUDim2(1, 0, 1, -12),
                Position = newUDim2(0, 0, 0, 19),
                Transparency = 0,
                Visible = first,
                Outline = false
            })
    
            local left_column = tab:Create("Square", {
                Transparency = 0,
                Outline = false,
                Size = newUDim2(1 / 3, -6, 1, 0)
            })
    
            left_column:AddList(12)
    
            local middle_column = tab:Create("Square", {
                Transparency = 0,
                Outline = false,
                Size = newUDim2(1 / 3, -6, 1, 0),
                Position = newUDim2(1 / 3, 3, 0, 0)
            })
    
            middle_column:AddList(12)
    
            local right_column = tab:Create("Square", {
                Transparency = 0,
                Outline = false,
                Size = newUDim2(1 / 3, -6, 1, 0),
                Position = newUDim2(2 / 3, 6, 0, 0)
            })
    
            right_column:AddList(12)

            tab_button.MouseButton1Click:Connect(function()
                if not tab.Visible then
                    for _, object in next, self.tab:GetChildren() do
                        if object ~= tab and object._class ~= "Text" then
                            object.Visible = false
                        end
                    end
    
                    for object, _ in next, self.tab_buttons do
                        if object ~= tab_button then
                            library:ChangeThemeObject(object, "Disabled Text")
                        end
                    end
    
                    library:ChangeThemeObject(tab_button, "Text")
                    tab.Visible = true
                end
            end)

            local column_types = clone(self)

            column_types.has_subtabs = false
            column_types.SubTab = nil
            column_types.middle_column = middle_column
            column_types.right_column = right_column
            column_types.left_column = left_column

            return column_types
        end

        function tab_types:MultiSection(options)
            if self.has_subtabs then return end

            utility.format(options)

            utility.defaults(options, {
                side = "left",
                sections = {
                    "section"
                }
            })

            local text_bounds = 6

            options.side = options.side:lower()
            local column = options.side == "middle" and self.middle_column or options.side == "right" and self.right_column or self.left_column
            local sections = {}

            local section = column:Create("Square", {
                Size = newUDim2(1, 0, 0, 40),
                ZIndex = 6,
                Theme = "Section Background",
                OutlineTheme = "Section Border"
            })

            local border = section:Create("Square", {
                Size = newUDim2(1, 2, 1, 2),
                Position = newUDim2(0, -1, 0, -1),
                Theme = "Section Background",
                OutlineTheme = "Black Border",
                ZIndex = 6,
            })

            local main = section:Create("Square", {
                Size = newUDim2(1, 0, 0, 18),
                ZIndex = 7,
                Theme = "Section Background",
                Outline = false
            })

            local main_border = main:Create("Square", {
                Size = newUDim2(1, 2, 1, 2),
                Position = newUDim2(0, -1, 0, -1),
                Theme = "Section Border",
                ZIndex = 6,
                OutlineTheme = "Black Border"
            });

            local background = section:Create("Square", {
                Size = newUDim2(1, 0, 1, -18),
                Position = newUDim2(0, 0, 0, 18),
                ZIndex = 8,
                Theme = "Section Background",
                OutlineTheme = "Section Border"
            });

            for i, name in next, options.sections do
                local first = i == 1

                local section_button = main:Create("Text", {
                    Text = name,
                    Font = library.font,
                    Size = library.font_size,
                    Position = newUDim2(0, text_bounds, 0, 2),
                    Theme = first and "Text" or "Disabled Text",
                    ZIndex = 10
                })

                text_bounds += section_button.TextBounds.X + 7

                local section_content = section:Create("Square", {
                    Size = newUDim2(1, -10, 0, 0),
                    Position = newUDim2(0, 5, 0, 23),
                    Transparency = 0,
                    Visible = first,
                    Outline = false
                })

                section_content:AddList(8)

                section_button.MouseButton1Click:Connect(function()
                    if not section_content.Visible then
                        for _, object in next, section:GetChildren() do
                            if object ~= tab and object ~= border and object ~= main and object ~= background then
                                object.Visible = false
                            end
                        end
        
                        for _, object in next, main:GetChildren() do
                            if object ~= section_button and object ~= main_border then
                                library:ChangeThemeObject(object, "Disabled Text")
                            end
                        end
        
                        library:ChangeThemeObject(section_button, "Text")
                        section_content.Visible = true
                    end
                end)


                local section_types = {tab = tab_types, main = section, content = section_content, Resize = function(self)
                    if self.content._list._contentSize + 20 > self.main.AbsoluteSize.Y then
                        self.main.Size = newUDim2(1, 0, 0, self.content._list._contentSize + 20)
                    end
                end}

                function section_types:Label(str)
                    str = str or "label"
    
                    local label = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        Outline = false
                    }):Create("Text", {
                        Text = str,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 8
                    })
    
                    self:Resize()
    
                    local label_types = {}
    
                    function label_types:Set(str)
                        label.Text = str
                    end
    
                    utility.format(label_types, true)
                    return label_types
                end

                function section_types:Separator(str)
                    return components.separator(self, str)
                end
    
                function section_types:Button(options)
                    return components.button(self, options)
                end
    
                function section_types:Toggle(options)
                    utility.format(options)
                    options.name = options.name or "toggle"
    
                    local holder = {colorpickers = 0, section = self, name = options.name}
    
                    holder.main = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        ZIndex = 10,
                        Outline = false
                    })
                    
                    holder.text = holder.main:Create("Text", {
                        Text = options.name,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 9
                    })
    
                    return components.toggle(holder, options)
                end

                function section_types:Box(options)
                    return components.box(self, options)
                end

                function section_types:Slider(options)
                    utility.format(options)
                    options.name = options.name or "slider"
    
                    local holder = {section = self}
                    
                    holder.main = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        ZIndex = 10,
                        Outline = false
                    })
                    
                    holder.main:Create("Text", {
                        Text = options.name,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 9
                    })
    
                    return components.slider(holder, options)
                end

                function section_types:Dropdown(options)
                    utility.format(options)
                    options.name = options.name or "dropdown"
    
                    local holder = {section = self}
                    
                    holder.main = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        Outline = false
                    })

                    holder.main:Create("Text", {
                        Text = options.name,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 8
                    })
    
                    return components.dropdown(holder, options)
                end

                function section_types:Keybind(options)
                    utility.format(options)
                    options.name = options.name or "keybind"
    
                    local holder = {section = self, name = options.name}
    
                    holder.main = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        ZIndex = 10,
                        Outline = false
                    })
                    
                    holder.text = holder.main:Create("Text", {
                        Text = options.name,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 9
                    })

                    self:Resize()
    
                    return components.keybind(holder, options)
                end

                function section_types:Colorpicker(options)
                    utility.format(options)
                    options.name = options.name or "colorpicker"

                    local holder = {colorpickers = 0, section = self}

                    holder.main = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        ZIndex = 10,
                        Outline = false
                    })

                    holder.text = holder.main:Create("Text", {
                        Text = options.name,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 9
                    })

                    self:Resize()

                    return components.colorpicker(holder, options)
                end

                function section_types:Subgroup(options)
                    utility.format(options);
                    options.name = options.name or "subgroup";

                    local holder = {section = self}

                    holder.main = self.content:Create("Square", {
                        Size = newUDim2(1, 0, 0, 13),
                        Transparency = 0,
                        ZIndex = 10,
                        Outline = false
                    });

                    holder.text = holder.main:Create("Text", {
                        Text = options.name,
                        Font = library.font,
                        Size = library.font_size,
                        Theme = "Text",
                        ZIndex = 9
                    });

                    self:Resize();

                    return components.subgroup(holder, options);
                end

                utility.format(section_types, true)
                sections[#sections + 1] = section_types
            end

            return unpack(sections)
        end

        function tab_types:Section(options)
            utility.format(options)

            utility.defaults(options, {
                name = "section",
                side = "left"
            })

            return self:MultiSection{
                side = options.side,
                sections = {options.name}
            }
        end

        utility.format(tab_types, true)
        return tab_types
    end

    function window_types:SettingsTab(watermark, unload)
        unload = unload or function() library.unload(library) end

        local settings = self:Tab("Settings")
        local configs = settings:Section{name = "Configs"}
        local autoload

        local config_dropdown = configs:Dropdown{
            name = "Config",
            default = self.current_config,
            content = library:GetConfigs(),
            flag = "selected_config",
            callback = function(selected)
                if (autoload) then
                    local auto_load_config = library:GetAutoLoadConfig();

                    if (selected == auto_load_config) then
                        autoload:set(true);
                    end
                end
            end
        }

        configs:Button{
            name = "Refresh Configs",
            callback = function()
                config_dropdown:Refresh(library:GetConfigs())
            end
        }

        configs:Box{
            name = "Config Name",
            flag = "config_name",
            ignored = true
        }

        configs:Button{
            name = "Create Config",
            callback = function()
                if library:CreateConfig(library.flags["config_name"]) and not config_dropdown:Exists(library.flags["config_name"]) then
                    config_dropdown:Add(library.flags["config_name"])
                    library:Notify{title = "Configuration", message = ("Successfully created config '%s'"):format(library.flags["config_name"]), duration = 5}
                end
            end
        }

        configs:Button{
            name = "Save Config",
            callback = function()
                if library.flags["selected_config"] then
                    if (library:SaveConfig(library.flags["selected_config"])) then
                        library:Notify{title = "Configuration", message = ("Successfully saved config '%s'"):format(library.flags["selected_config"]), duration = 5}
                    end
                end
            end
        }

        configs:Button{
            name = "Load Config",
            callback = function()
                if (library:LoadConfig(library.flags["selected_config"])) then
                    library:Notify{title = "Configuration", message = ("Successfully loaded config '%s'"):format(library.flags["selected_config"]), duration = 5}
                end
            end
        }

        configs:Button{
            name = "Delete Config",
            callback = function()
                local selected = library.flags["selected_config"];
                if (selected) then
                    library:DeleteConfig(selected);
                    config_dropdown:Refresh(library:GetConfigs())
                    library:Notify{title = "Configuration", message = ("Successfully deleted config '%s'"):format(selected), duration = 5};
                end
            end
        }

        autoload = configs:Toggle{
            name = "Autoload Config",
            default = false,
            flag = "auto_load",
            callback = function(value)
                if library.initialized then
                    local selected = library.flags["selected_config"];

                    if (selected) then
                        library:SetAutoLoadConfig(value and selected or "");

                        if (value) then
                            library:Notify{title = "Configuration", message = ("Successfully set config '%s' as auto load"):format(library.flags["selected_config"])}
                        end
                    end
                end
            end
        }

        local themes, customTheme = settings:multiSection{Side = "middle", Sections = { "Themes", "Custom Theme" }}
        local theme_colorpickers = {}
        library.theme_colorpickers = theme_colorpickers;

        local theme_options = {"Accent", "Window Background", "Window Border", "Black Border", "Text", "Disabled Text", "Tab Background", "Tab Border", "Section Background", "Section Border", "Object Background", "Object Border", "Dropdown Option Background"}

        local theme_dropdown = themes:Dropdown{
            name = "Theme",
            content = library:GetThemes(),
            flag = "selected_theme",
        }

        themes:Box{
            name = "Theme Name",
            flag = "theme_name",
            ignored = true
        }

        themes:Button{
            name = "Create Theme",
            callback = function()
                if library:SaveTheme(library.flags["theme_name"]) and not config_dropdown:Exists(library.flags["theme_name"]) then
                    theme_dropdown:Add(library.flags["theme_name"])
                end
            end
        }

        themes:Button{
            name = "Save Theme",
            callback = function()
                if library.flags["selected_theme"] then
                    library:Notify{title = "Theme", message = ("Successfully saved theme '%s'"):format(library.flags["selected_theme"])}
                    library:SaveTheme(library.flags["selected_theme"])
                end
            end
        }

        themes:Button{
            name = "Load Theme",
            callback = function()
                library:LoadTheme(library.flags["selected_theme"])

                for option, colorpicker in next, theme_colorpickers do
                    colorpicker:Set(library.theme[option])
                end
            end
        }

        themes:Button{
            name = "Delete Theme",
            callback = function()
                if library:DeleteTheme(library.flags["selected_theme"]) then
                    theme_dropdown:Remove(library.flags["selected_theme"])
                end
            end
        }

        for _, option in next, theme_options do
            theme_colorpickers[option] = customTheme:Colorpicker{
                name = option,
                default = library.theme[option],
                ignored = true,
                flag = option,
                callback = function(color)
                    library:ChangeThemeOption(option, color)
                end
            }
        end

        if watermark then
            local watermark_section = settings:Section{name = "Watermark"}
            watermark:Toggle()

            watermark_section:Toggle{
                name = "Show Watermark",
                default = true,
                flag = "show_watermark",
                callback = function(bool)
                    if library.watermark.Visible ~= bool then
                        watermark:Toggle()
                    end
                end
            }

            watermark_section:Dropdown{
                name = "Watermark Alignment",
                default = library.watermark_y:gsub("^%l", upper) .. " " .. library.watermark_x:gsub("^%l", upper),
                content = {"Top Left", "Top Right", "Bottom Left", "Bottom Right"},
                flag = "watermark_alignment",
                callback = function(alignment)
                    if alignment then
                        alignment = alignment:split(" ")
                        local y, x = alignment[1], alignment[2]
                        library:ChangeWatermarkPosition(x, y)
                    end
                end
            }
        end

        local notifications_section = settings:Section{name = "Notifications"}

        notifications_section:Slider{
            name = "Notification Speed",
            default = library.notification_speed,
            min = 0,
            max = 1,
            callback = function(value)
                library.notification_speed = value;
            end
        }

        notifications_section:Dropdown{
            name = "Notification Alignment",
            default = library.notification_y:gsub("^%l", upper) .. " " .. library.notification_x:gsub("^%l", upper),
            content = {"Top Left", "Top Right", "Bottom Left", "Bottom Right"},
            callback = function(alignment)
                if alignment then
                    alignment = alignment:split(" ")
                    local y, x = alignment[1], alignment[2]
                    library:ChangeNotificationPosition(x, y)
                end
            end
        }

        local misc = settings:Section{name = "Cheat", Side = "right"}

        misc:Toggle{
            name = "Show Keybind List",
            default = library.keybind_list_default,
            flag = "keybind_list",
            callback = function(value)
                if library.keybind_list.object.Visible ~= value then
                    library.keybind_list:Toggle()
                end
            end
        }

        misc:Toggle{
            name = "Show Player List",
            default = library.keybind_list_default,
            flag = "player_list",
            callback = function(value)
                library.Playerlist.toggled = value

                if library.open then
                    library.Playerlist.object.Visible = value
                end
            end
        }

        --[[misc:Toggle{
            name = "Performance Drag",
            default = library.performance_drag,
            flag = "performance_drag",
            callback = function(value)
                library.performance_drag = value
            end
        }]]

        misc:Keybind{
            name = "Menu Key",
            default = Enum.KeyCode.RightShift,
            blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3},
            flag = "menu_key",
            listignored = true,
            callback = function(_, from_setting)
                if not from_setting then
                    library:Toggle()
                end
            end
        }

        misc:Keybind{
            name = "Panic Key",
            default = Enum.KeyCode.End,
            blacklist = {Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3},
            flag = "panic_key",
            listignored = true,
            callback = function(_, from_setting)
                if not from_setting then
                    (unload or function()
                        library:Unload();
                    end)();
                end
            end
        }

        misc:Slider{
            name = "Tween Speed",
            default = library.tween_speed,
            min = 0,
            max = 1,
            flag = "tween_speed",
            callback = function(value)
                library.tween_speed = value;
            end
        }

        misc:Slider{
            name = "Fade Speed",
            default = library.fade_speed,
            min = 0,
            max = 1,
            flag = "fade_speed",
            callback = function(value)
                library.toggle_speed = value;
            end
        }

        misc:Dropdown{
            name = "Easing Style",
            default = tostring(library.easing_style):gsub("Enum.EasingStyle.", ""),
            content = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"},
            flag = "easing_style",
            callback = function(style)
                library.easing_style = Enum.EasingStyle[style]
            end
        }

        misc:Button{
            name = "Unload",
            callback = unload or function()
                library:Unload();
            end
        }

        misc:Button{
            name = "Copy Game Invite (CONSOLE)",
            callback = function()
                setclipboard(('Roblox.GameLauncher.joinGameInstance(%s, "%s")'):format(game.PlaceId, game.JobId))
            end
        }

        misc:Button{
            name = "Copy Game Invite (LUA)",
            callback = function()
                setclipboard(('game:GetService("TeleportService"):TeleportToPlaceInstance(%s, "%s")'):format(game.PlaceId, game.JobId))
            end
        }

        misc:Button{
            name = "Join Discord Server",
            callback = function()
                request{
                    ["Url"] = "http://127.0.0.1:6463/rpc?v=1",
                    ["Method"] = "POST",
                    ["Headers"] = {
                        ["Content-Type"] = "application/json",
                        ["Origin"] = "https://discord.com"
                    },
                    ["Body"] = services.HttpService:JSONEncode{
                        ["cmd"] = "INVITE_BROWSER",
                        ["nonce"] = ".",
                        ["args"] = {code = library.discord}
                    }
                }
            end
        }

        misc:Button{
            name = "Copy Discord Invite",
            callback = function()
                setclipboard(library.discord)
            end
        }

        return settings
    end

    utility.format(window_types, true)
    return window_types
end


--[[local window = library:Load{playerlist = true}

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
]]--

utility.format(library, true)
return library;
