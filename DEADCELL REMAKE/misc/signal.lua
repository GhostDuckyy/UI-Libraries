-- small signal lib

local newInstance = Instance.new
local setmetatable = setmetatable

local Signal = {}
local Connection = {}

Signal.__index = Signal
Connection.__index = Connection

function Connection.new(signal, callback)
    local connection = signal._signal:Connect(callback)

    signal._count += 1
    signal.Active = true

    return setmetatable({
        Connected = true,
        _signal = signal,
        _connection = connection
    }, Connection)
end

function Connection:Disconnect()
    self._connection:Disconnect()
    self.Connected = false

    self._signal._count -= 1
    self._signal.Active = self._signal._count > 0
end

function Signal.new()
    local bindableEvent = newInstance("BindableEvent")

    return setmetatable({
        Active = false,
        _bindableEvent = bindableEvent,
        _signal = bindableEvent.Event,
        _count = 0,
        _onConnects = {}
    }, Signal)
end

function Signal:OnConnect(callback)
    self._onConnects[#self._onConnects + 1] = callback 
end

function Signal:Fire(...)
    self._bindableEvent:Fire(...)
end

function Signal:Connect(callback)
    for _, connect_callback in next, self._onConnects do
        connect_callback()
    end
    
    return Connection.new(self, callback)
end

function Signal:Wait()
    return self._signal:Wait()
end

function Signal:Destroy()
    self._bindableEvent:Destroy()
    self.Active = false
    setmetatable(self, nil)
end

Signal.DisconnectAll = Signal.Destroy
Signal.Disconnect = Signal.Destroy

return Signal
