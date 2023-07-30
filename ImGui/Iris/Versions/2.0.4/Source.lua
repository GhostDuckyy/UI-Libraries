local __bundle_require, __bundle_loaded, __bundle_register, __bundle_modules = (function(superRequire)
	local loadingPlaceholder = {[{}] = true}

	local register
	local modules = {}

	local require
	local loaded = {}

	register = function(name, body)
		if not modules[name] then
			modules[name] = body
		end
	end

	require = function(name)
		local loadedModule = loaded[name]

		if loadedModule then
			if loadedModule == loadingPlaceholder then
				return nil
			end
		else
			if not modules[name] then
				if not superRequire then
					local identifier = type(name) == 'string' and '\"' .. name .. '\"' or tostring(name)
					error('Tried to require ' .. identifier .. ', but no such module has been registered')
				else
					return superRequire(name)
				end
			end

			loaded[name] = loadingPlaceholder
			loadedModule = modules[name](require, loaded, register, modules)
			loaded[name] = loadedModule
		end

		return loadedModule
	end

	return require, loaded, register, modules
end)(require)
__bundle_register("__root", function(require, _LOADED, __bundle_register, __bundle_modules)
--!optimize 2
-- local Types = require(script.Types)

--- @class Iris
--- 
--- Iris; contains the library.
local Iris = {}

Iris._started = false -- has Iris.connect been called yet
Iris._globalRefreshRequested = false -- refresh means that all GUI is destroyed and regenerated, usually because a style change was made and needed to be propogated to all UI
Iris._localRefreshActive = false -- if true, when _Insert is called, the widget called will be regenerated
Iris._widgets = {}
Iris._rootConfig = {} -- root style which all widgets derive from
Iris._config = Iris._rootConfig
Iris._rootInstance = nil
Iris._rootWidget = {
	ID = "R",
	type = "Root",
	Instance = Iris._rootInstance,
	ZIndex = 0,
}
Iris._states = {} -- Iris.States
Iris._postCycleCallbacks = {}
Iris._connectedFunctions = {} -- functions which run each Iris cycle, connected by the user
-- these following variables aid in computing Iris._cycle, they are variable while the code to render widgets is being caleld
Iris._IDStack = {"R"}
Iris._usedIDs = {} -- hash of IDs which are already used in a cycle, value is the # of occurances so that getID can assign a unique ID for each occurance
Iris._stackIndex = 1 -- Points to the index that IDStack is currently in, when computing cycle
Iris._cycleTick = 0 -- increments for each call to Cycle, used to determine the relative age and freshness of generated widgets
Iris._widgetCount = 0 -- only used to compute ZIndex, resets to 0 for every cycle
Iris._lastWidget = Iris._rootWidget -- widget which was most recently rendered

function Iris._generateSelectionImageObject()
	if Iris.SelectionImageObject then
		Iris.SelectionImageObject:Destroy()
	end
	local SelectionImageObject = Instance.new("Frame")
	Iris.SelectionImageObject = SelectionImageObject
	SelectionImageObject.BackgroundColor3 = Iris._config.SelectionImageObjectColor
	SelectionImageObject.BackgroundTransparency = Iris._config.SelectionImageObjectTransparency
	SelectionImageObject.Position = UDim2.fromOffset(-1, -1)
	SelectionImageObject.Size = UDim2.new(1, 2, 1, 2)
	SelectionImageObject.BorderSizePixel = 0

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Thickness = 1
	UIStroke.Color = Iris._config.SelectionImageObjectBorderColor
	UIStroke.Transparency = Iris._config.SelectionImageObjectBorderColor
	UIStroke.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = SelectionImageObject

	local Rounding = Instance.new("UICorner")
	Rounding.CornerRadius = UDim.new(0, 2)
	Rounding.Parent = SelectionImageObject
end

function Iris._generateRootInstance()
	-- unsafe to call before Iris.connect
	Iris._rootInstance = Iris._widgets["Root"].Generate(Iris._widgets["Root"])
	Iris._rootInstance.Parent = Iris.parentInstance
	Iris._rootWidget.Instance = Iris._rootInstance
end

function Iris._deepCompare(t1, t2)
	-- unoptimized ?
	for i, v1 in next, t1 do
		local v2 = t2[i]
		if type(v1) == "table" then
			if v2 and type(v2) == "table" then
				if Iris._deepCompare(v1, v2) == false then
					return false
				end
			else
				return false
			end
		else
			if type(v1) ~= type(v2) or v1 ~= v2 then
				return false
			end
		end
	end

	return true
end

function Iris._getID(levelsToIgnore)
	if Iris._nextWidgetId then
		local ID = Iris._nextWidgetId
		Iris._nextWidgetId = nil
		return ID
	end
	local i = 1 + (levelsToIgnore or 1)
	local ID = ""
	local levelInfo = debug.info(i, "l")
	while levelInfo ~= -1 and levelInfo ~= nil do
		ID = ID .. "+" .. levelInfo
		i = i + 1
		levelInfo = debug.info(i, "l")
	end
	if Iris._usedIDs[ID] then
		Iris._usedIDs[ID] = Iris._usedIDs[ID] + 1
	else
		Iris._usedIDs[ID] = 1
	end

	return ID .. ":" .. Iris._usedIDs[ID]
end

function Iris.SetNextWidgetID(ID)
	Iris._nextWidgetId = ID
end

function Iris._generateEmptyVDOM()
	return {
		["R"] = Iris._rootWidget
	}
end

Iris._lastVDOM = Iris._generateEmptyVDOM()
Iris._VDOM = Iris._generateEmptyVDOM()

function Iris._cycle()
	Iris._rootWidget.lastCycleTick = Iris._cycleTick
	if Iris._rootInstance == nil or Iris._rootInstance.Parent == nil then
		Iris.ForceRefresh()
	end

	for _, widget in next, Iris._lastVDOM do
		if widget.lastCycleTick ~= Iris._cycleTick then
			-- a widget which used to be rendered was no longer rendered, so we discard
			Iris._DiscardWidget(widget)
		end
	end

	Iris._lastVDOM = Iris._VDOM
	Iris._VDOM = Iris._generateEmptyVDOM()

	for _, callback in next, Iris._postCycleCallbacks do
		callback()
	end

	if Iris._globalRefreshRequested then
		-- rerender every widget
		--debug.profilebegin("Iris Refresh")
		Iris._generateSelectionImageObject()
		Iris._globalRefreshRequested = false
		for _, widget in next, Iris._lastVDOM do
			Iris._DiscardWidget(widget)
		end
		Iris._generateRootInstance()
		Iris._lastVDOM = Iris._generateEmptyVDOM()
		--debug.profileend()
	end
	Iris._cycleTick = Iris._cycleTick + 1
	Iris._widgetCount = 0
	table.clear(Iris._usedIDs)

	if Iris.parentInstance:IsA("GuiBase2d") and math.min(Iris.parentInstance.AbsoluteSize.X, Iris.parentInstance.AbsoluteSize.Y) < 100 then
		error("Iris Parent Instance is too small")
	end
	local compatibleParent = (
		Iris.parentInstance:IsA("GuiBase2d") or 
		Iris.parentInstance:IsA("CoreGui") or 
		Iris.parentInstance:IsA("PluginGui") or 
		Iris.parentInstance:IsA("PlayerGui")
	) 
	if compatibleParent == false then
		error("Iris Parent Instance cant contain GUI")
	end
	--debug.profilebegin("Iris Generate")
	for _, callback in next, Iris._connectedFunctions do
		-- local status: boolean, _error: string = pcall(callback)
		-- if not status then
		--     Iris._stackIndex = 1
		--     error(_error, 0)
		-- end
		callback() -- this is useful to see the full stack trace of any issues.
		if Iris._stackIndex ~= 1 then
			-- has to be larger than 1 because of the check that it isint below 1 in Iris.End
			Iris._stackIndex = 1
			error("Callback has too few calls to Iris.End()", 0)
		end
	end
	--debug.profileend()
end

function Iris._GetParentWidget()
	return Iris._VDOM[Iris._IDStack[Iris._stackIndex]]
end

--- @prop Args table
--- @within Iris
--- Provides a list of every possible Argument for each type of widget.
--- For instance, `Iris.Args.Window.NoResize`.
--- The Args table is useful for using widget Arguments without remembering their order.
--- ```lua
--- Iris.Window({"My Window", [Iris.Args.Window.NoResize] = true})
--- ```
Iris.Args = {}

function Iris._EventCall(thisWidget, eventName)
	local Events = Iris._widgets[thisWidget.type].Events
	local Event = Events[eventName]
	local _msg = "widget %s has no event of name %s"
	assert(Event ~= nil, _msg:format(tostring(thisWidget.type), tostring(eventName)))
	--assert(Event ~= nil, `widget {thisWidget.type} has no event of name {eventName}`)
	
	if thisWidget.trackedEvents[eventName] == nil then
		Event.Init(thisWidget)
		thisWidget.trackedEvents[eventName] = true
	end
	return Event.Get(thisWidget)
end

Iris.Events = {}

--- @function ForceRefresh
--- @within Iris
--- Destroys and regenerates all instances used by Iris. useful if you want to propogate state changes.
--- :::caution Caution: Performance
--- Because this function Deletes and Initializes many instances, it may cause **performance issues** when used with many widgets.
--- In **no** case should it be called every frame.
--- :::
function Iris.ForceRefresh()
	Iris._globalRefreshRequested = true
end

function Iris._NoOp()

end
--- @function WidgetConstructor
--- @within Iris
--- @param type string -- Name used to denote the widget
--- @param widgetClass table -- table of methods for the new widget
function Iris.WidgetConstructor(type, widgetClass)
	local Fields = {
		All = {
			Required = {
				"Generate",
				"Discard",
				"Update",

				-- not methods !
				"Args",
				"Events",
				"hasChildren",
				"hasState"
			},
			Optional = {

			}
		},
		IfState = {
			Required = {
				"GenerateState",
				"UpdateState"
			},
			Optional = {

			}
		},
		IfChildren = {
			Required = {
				"ChildAdded"
			},
			Optional = {
				"ChildDiscarded"
			}
		}
	}

	local thisWidget = {}
	for _, field in next, Fields.All.Required do
		local _msg = "field %s is missing from widget %s, it is required for all widgets"
		assert(widgetClass[field] ~= nil, _msg:format(tostring(field), tostring(type)))
		thisWidget[field] = widgetClass[field]
	end
	for _, field in next, Fields.All.Optional do
		if widgetClass[field] == nil then
			thisWidget[field] = Iris._NoOp
		else
			thisWidget[field] = widgetClass[field]
		end
	end
	if widgetClass.hasState then
		for _, field in next, Fields.IfState.Required do
			local _msg = "field %s is missing from widget %s, it is required for all widgets with state"
			assert(widgetClass[field] ~= nil, _msg:format(tostring(field), tostring(type)))
			thisWidget[field] = widgetClass[field]
		end
		for _, field in next, Fields.IfState.Optional do
			if widgetClass[field] == nil then
				thisWidget[field] = Iris._NoOp
			else
				thisWidget[field] = widgetClass[field]
			end
		end
	end
	if widgetClass.hasChildren then
		for _, field in next, Fields.IfChildren.Required do
			local _msg = "field %s is missing from widget %s, it is required for all widgets with children"
			assert(widgetClass[field] ~= nil, _msg:format(tostring(field), tostring(type)))
			thisWidget[field] = widgetClass[field]
		end
		for _, field in next, Fields.IfChildren.Optional do
			if widgetClass[field] == nil then
				thisWidget[field] = Iris._NoOp
			else
				thisWidget[field] = widgetClass[field]
			end
		end
	end

	Iris._widgets[type] = thisWidget
	Iris.Args[type] = thisWidget.Args
	local ArgNames = {}
	for index, argument in next, thisWidget.Args do
		ArgNames[argument] = index
	end
	for index, _ in next, thisWidget.Events do
		if Iris.Events[index] == nil then
			Iris.Events[index] = function()
				return Iris._EventCall(Iris._lastWidget, index)
			end
		end
	end
	thisWidget.ArgNames = ArgNames
end

--- @function UpdateGlobalConfig
--- @within Iris
--- @param deltaStyle table -- a table containing the changes in style ex: `{ItemWidth = UDim.new(0, 100)}`
--- Allows callers to customize the config which **every** widget will inherit from.
--- It can be used along with Iris.TemplateConfig to easily swap styles, ex: ```Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorLight) -- use light theme```
--- :::caution Caution: Performance
--- this function internally calls [Iris.ForceRefresh] so that style changes are propogated, it may cause **performance issues** when used with many widgets.
--- In **no** case should it be called every frame.
--- :::
function Iris.UpdateGlobalConfig(deltaStyle)
	for index, style in next, deltaStyle do
		Iris._rootConfig[index] = style
	end
	Iris.ForceRefresh()
end

--- @function PushConfig
--- @within Iris
--- @param deltaStyle table -- a table containing the changes in style ex: `{ItemWidth = UDim.new(0, 100)}`
--- Allows callers to cascade a style, meaning that styles may be locally and hierarchically applied.
--- Each call to Iris.PushConfig must be paired with a call to [Iris.PopConfig].
--- For example:
--- ```lua
--- Iris.PushConfig({TextColor = Color3.fromRGB(128, 0, 256)})
---     Iris.Text({"Colored Text!"})
--- Iris.PopConfig()
--- ```
function Iris.PushConfig(deltaStyle)
	local ID = Iris.State(-1)
	if ID.value == -1 then
		ID:set(deltaStyle)
	else
		-- compare tables
		if Iris._deepCompare(ID:get(), deltaStyle) == false then
			-- refresh local
			Iris._localRefreshActive = true
			ID:set(deltaStyle)
		end
	end
	Iris._config = setmetatable(deltaStyle, {
		__index = Iris._config
	})
end

--- @function PopConfig
--- @within Iris
--- Ends a PushConfig style.
--- Each call to [Iris.PushConfig] must be paired with a call to Iris.PopConfig.
function Iris.PopConfig()
	Iris._localRefreshActive = false
	Iris._config = getmetatable(Iris._config).__index
end

--- @class State
--- This class wraps a value in getters and setters, its main purpose is to allow primatives to be passed as objects.
--- Constructors for this class are available in [Iris]
local StateClass = {}
StateClass.__index = StateClass

--- @method get
--- @within State
--- @return any
--- Returns the states current value.
function StateClass:get() -- you can also simply use .value
	return self.value
end

--- @method set
--- @within State
--- allows the caller to assign the state object a new value, and returns the new value.
function StateClass:set(newValue)
	self.value = newValue
	for _, thisWidget in next, self.ConnectedWidgets do
		Iris._widgets[thisWidget.type].UpdateState(thisWidget)
	end
	for _, thisFunc in next, self.ConnectedFunctions do
		thisFunc(newValue)
	end
	return self.value
end

--- @method onChange
--- @within State
--- Allows the caller to connect a callback which is called when the states value is changed.
function StateClass:onChange(funcToConnect)
	table.insert(self.ConnectedFunctions, funcToConnect)
end

--- @function State
--- @within Iris
--- @param initialValue any -- The initial value for the state
--- Constructs a new state object, subsequent ID calls will return the same object
--- :::info
--- Iris.State allows you to create "references" to the same value while inside your UI drawing loop.
--- For example:
--- ```lua
--- Iris:Connect(function()
---     local myNumber = 5;
---     myNumber = myNumber + 1
---     Iris.Text({"The number is: " .. myNumber})
--- end)
--- ```
--- This is problematic. Each time the function is called, a new myNumber is initialized, instead of retrieving the old one.
--- The above code will always display 6.
--- ***
--- Iris.State solves this problem:
--- ```lua
--- Iris:Connect(function()
---     local myNumber = Iris.State(5)
---     myNumber:set(myNumber:get() + 1)
---     Iris.Text({"The number is: " .. myNumber})
--- end)
--- ```
--- In this example, the code will work properly, and increment every frame.
--- :::
function Iris.State(initialValue)
	local ID = Iris._getID(2)
	if Iris._states[ID] then
		return Iris._states[ID]
	end
	Iris._states[ID] = {
		value = initialValue,
		ConnectedWidgets = {},
		ConnectedFunctions = {}
	}
	setmetatable(Iris._states[ID], StateClass)
	return Iris._states[ID]
end

--- @function State
--- @within Iris
--- @param initialValue any -- The initial value for the state
--- Constructs a new state object, subsequent ID calls will return the same object, except all widgets connected to the state are discarded, the state reverts to the passed initialValue
function Iris.WeakState(initialValue)
	local ID = Iris._getID(2)
	if Iris._states[ID] then
		if #Iris._states[ID].ConnectedWidgets == 0 then
			Iris._states[ID] = nil
		else
			return Iris._states[ID]
		end
	end
	Iris._states[ID] = {
		value = initialValue,
		ConnectedWidgets = {},
		ConnectedFunctions = {}
	}
	setmetatable(Iris._states[ID], StateClass)
	return Iris._states[ID]
end

--- @function ComputedState
--- @within Iris
--- @param firstState State -- State to bind to.
--- @param onChangeCallback function -- callback which should return a value transformed from the firstState value
--- Constructs a new State object, but binds its value to the value of another State.
--- :::info
--- A common use case for this constructor is when a boolean State needs to be inverted:
--- ```lua
--- Iris.ComputedState(otherState, function(newValue)
---     return not newValue
--- end)
--- ```
--- :::
function Iris.ComputedState(firstState, onChangeCallback)
	local ID = Iris._getID(2)

	if Iris._states[ID] then
		return Iris._states[ID]
	else
		Iris._states[ID] = {
			value = onChangeCallback(firstState.value),
			ConnectedWidgets = {},
			ConnectedFunctions = {}
		}
		firstState:onChange(function(newValue)
			Iris._states[ID]:set(onChangeCallback(newValue))
		end)
		setmetatable(Iris._states[ID], StateClass)
		return Iris._states[ID]
	end
end
-- constructor which uses ID derived from a widget object
function Iris._widgetState(thisWidget, stateName, initialValue)
	local ID = thisWidget.ID .. stateName
	if Iris._states[ID] then
		Iris._states[ID].ConnectedWidgets[thisWidget.ID] = thisWidget
		return Iris._states[ID]
	else
		Iris._states[ID] = {
			value = initialValue,
			ConnectedWidgets = {[thisWidget.ID] = thisWidget},
			ConnectedFunctions = {}
		}
		setmetatable(Iris._states[ID], StateClass)
		return Iris._states[ID]
	end
end

--- @within Iris
--- @function Init
--- @param parentInstance Instance | nil -- instance which Iris will place UI in. defaults to [PlayerGui] if unspecified
--- @param eventConnection RBXScriptSignal | () -> {} | nil
--- @return Iris
--- Initializes Iris. May only be called once.
--- :::tip
--- Want to stop Iris from rendering and consuming performance, but keep all the Iris code? simply comment out the `Iris.Init()` line in your codebase.
--- :::
function Iris.Init(parentInstance, eventConnection)
	if parentInstance == nil then
		-- coalesce to playerGui
		parentInstance = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
	end
	if eventConnection == nil then
		-- coalesce to Heartbeat
		eventConnection = game:GetService("RunService").Heartbeat
	end
	Iris.parentInstance = parentInstance
	assert(not Iris._started, "Iris.Connect can only be called once.")
	Iris._started = true

	Iris._generateRootInstance()
	Iris._generateSelectionImageObject()
	
	task.spawn(function()
		if typeof(eventConnection) == "function" then
			while true do
				eventConnection()
				Iris._cycle()
			end
		elseif eventConnection ~= nil then
			eventConnection:Connect(function()
				Iris._cycle()
			end)
		end
	end)

	return Iris
end

--- @within Iris
--- @method Connect
--- @param callback function -- allows users to connect a function which will execute every Iris cycle, (cycle is determined by the callback or event passed to Iris.Init)
function Iris:Connect(callback) -- this uses method syntax for no reason.
	table.insert(Iris._connectedFunctions, callback)
end

function Iris._DiscardWidget(widgetToDiscard)
	local widgetParent = widgetToDiscard.parentWidget
	if widgetParent then
		Iris._widgets[widgetParent.type].ChildDiscarded(widgetParent, widgetToDiscard)
	end
	Iris._widgets[widgetToDiscard.type].Discard(widgetToDiscard)
end

function Iris._GenNewWidget(widgetType, arguments, widgetState, ID)
	local parentId = Iris._IDStack[Iris._stackIndex]
	local thisWidgetClass = Iris._widgets[widgetType]

	local thisWidget = {}
	setmetatable(thisWidget, thisWidget)

	thisWidget.ID = ID
	thisWidget.type = widgetType
	thisWidget.parentWidget = Iris._VDOM[parentId]
	thisWidget.trackedEvents = {}

	thisWidget.ZIndex = thisWidget.parentWidget.ZIndex + (Iris._widgetCount * 0x40) + Iris._config.ZIndexOffset

	thisWidget.Instance = thisWidgetClass.Generate(thisWidget)
	thisWidget.Instance.Parent = Iris._config.Parent and Iris._config.Parent or Iris._widgets[thisWidget.parentWidget.type].ChildAdded(thisWidget.parentWidget, thisWidget)

	thisWidget.arguments = arguments
	thisWidgetClass.Update(thisWidget)

	local eventMTParent
	if thisWidgetClass.hasState then
		if widgetState then
			for index, state in next, widgetState do
				if not (type(state) == "table" and getmetatable(state) == StateClass) then
					widgetState[index] = Iris._widgetState(thisWidget, index, state)
				end
			end
			thisWidget.state = widgetState
			for _, state in next, widgetState do
				state.ConnectedWidgets[thisWidget.ID] = thisWidget
			end
		else
			thisWidget.state = {}
		end

		thisWidgetClass.GenerateState(thisWidget)
		thisWidgetClass.UpdateState(thisWidget)

		thisWidget.stateMT = {} -- MT cant be itself because state has to explicitly only contain stateClass objects
		setmetatable(thisWidget.state, thisWidget.stateMT)

		thisWidget.__index = thisWidget.state
		eventMTParent = thisWidget.stateMT
	else
	   eventMTParent = thisWidget
	end
	-- im very upset that this function exists.
	eventMTParent.__index = function(_, eventName)
		return function()
			return Iris._EventCall(thisWidget, eventName)
		end
	end
	return thisWidget
end

function Iris._Insert(widgetType, args, widgetState)
	local thisWidget
	local ID = Iris._getID(3)
	--debug.profilebegin(ID)

	local thisWidgetClass = Iris._widgets[widgetType]
	Iris._widgetCount = Iris._widgetCount + 1

	if Iris._VDOM[ID] then
		-- error("Multiple widgets cannot occupy the same ID", 3)
		return Iris._ContinueWidget(ID, widgetType)
	end

	local arguments = {}
	if args ~= nil then
		if type(args) ~= "table" then
			--error("Args must be a table.", 3)
			args = {args}
		end
		for index, argument in next, args do
			arguments[thisWidgetClass.ArgNames[index]] = argument
		end
	end
	table.freeze(arguments)

	if Iris._lastVDOM[ID] and widgetType == Iris._lastVDOM[ID].type then
		-- found a matching widget from last frame
		if Iris._localRefreshActive then
			Iris._DiscardWidget(Iris._lastVDOM[ID])
		else
			thisWidget = Iris._lastVDOM[ID]
		end
	end
	if thisWidget == nil then
		-- didnt find a match, generate a new widget
		thisWidget = Iris._GenNewWidget(widgetType, arguments, widgetState, ID)
	end

	if Iris._deepCompare(thisWidget.arguments, arguments) == false then
		-- the widgets arguments have changed, the widget should update to reflect changes.
		thisWidget.arguments = arguments
		thisWidgetClass.Update(thisWidget)
	end

	thisWidget.lastCycleTick = Iris._cycleTick

	if thisWidgetClass.hasChildren then
		Iris._stackIndex = Iris._stackIndex + 1
		Iris._IDStack[Iris._stackIndex] = thisWidget.ID
	end

	Iris._VDOM[ID] = thisWidget
	Iris._lastWidget = thisWidget

	--debug.profileend()

	return thisWidget
end

function Iris._ContinueWidget(ID, widgetType)
	local thisWidgetClass = Iris._widgets[widgetType]
	local thisWidget = Iris._VDOM[ID]

	if thisWidgetClass.hasChildren then
		Iris._stackIndex = Iris._stackIndex + 1
		Iris._IDStack[Iris._stackIndex] = thisWidget.ID
	end

	Iris._lastWidget = thisWidget
	return thisWidget
end

--- @within Iris
--- @function Append
--- Allows the caller to insert any Roblox Instance into the current parent Widget.
function Iris.Append(userInstance)
	local parentWidget = Iris._GetParentWidget()
	local widgetInstanceParent
	if Iris._config.Parent then
		widgetInstanceParent = Iris._config.Parent
	else
		widgetInstanceParent = Iris._widgets[parentWidget.type].ChildAdded(parentWidget, {type = "userInstance"})
	end
	userInstance.Parent = widgetInstanceParent
end

--- @within Iris
--- @function End
--- This function marks the end of any widgets which contain children. For example:
--- ```lua
--- -- Widgets placed here **will not** be inside the tree
--- Iris.Tree({"My First Tree"})
---     -- Widgets placed here **will** be inside the tree
--- Iris.End()
--- -- Widgets placed here **will not** be inside the tree
--- ```
--- :::caution Caution: Error
--- Seeing the error `Callback has too few calls to Iris.End()` or `Callback has too many calls to Iris.End()`?
--- Using the wrong amount of `Iris.End()` calls in your code will lead to an error. Each widget called which might have children should be paired with a call to `Iris.End()`, **Even if the Widget doesnt currently have any children**.
--- :::
function Iris.End()
	if Iris._stackIndex == 1 then
		error("Callback has too many calls to Iris.End()", 2)
	end
	Iris._IDStack[Iris._stackIndex] = nil
	Iris._stackIndex = Iris._stackIndex - 1
end

--- @within Iris
--- @prop TemplateConfig table
--- TemplateConfig provides a table of default styles and configurations which you may apply to your UI.
Iris.TemplateConfig = require("config")
Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark) -- use colorDark and sizeDefault themes by default
Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeDefault)
Iris.UpdateGlobalConfig(Iris.TemplateConfig.utilityDefault)
Iris._globalRefreshRequested = false -- UpdatingGlobalConfig changes this to true, leads to Root being generated twice.

--- @within Iris
--- @function ShowDemoWindow
--- ShowDemoWindow is a function which creates a Demonstration window. this window contains many useful utilities for coders, and serves as a refrence for using each part of the library.
--- Ideally, the DemoWindow should always be available in your UI.
Iris.ShowDemoWindow = require("demoWindow")(Iris)

require("widgets")(Iris)

--- @class Widgets
--- Each widget is available through Iris.<widget name\>

--- @prop Text Widget
--- @within Widgets
--- A simple Textbox.
---
--- ```json 
--- hasChildren: false,
--- hasState: false,
--- Arguments: {
---     Text: String
--- },
--- Events: {
---     hovered: boolean
--- }
--- ```
Iris.Text = function(args)
	return Iris._Insert("Text", args)
end

--- @prop TextColored Widget
--- @within Widgets
--- A simple Textbox, which has colored text.
---
--- ```json
--- hasChildren: false,
--- hasState: false,
--- Arguments: {
---     Text: String,
--- 	Color: Color3
--- },
--- Events: {
---     hovered: boolean
--- }
--- ```
Iris.TextColored = function(args)
	return Iris._Insert("TextColored", args)
end

--- @prop TextWrapped Widget
--- @within Widgets
--- A simple Textbox, which has wrapped text.
--- The width of the text is determined by the ItemWidth config field.
---
--- ```json 
--- hasChildren: false,
--- hasState: false,
--- Arguments: {
---     Text: String,
---     Color: Color3
--- },
--- Events: {
---     hovered: boolean
--- }
--- ```
Iris.TextWrapped = function(args)
	return Iris._Insert("TextWrapped", args)
end

--- @prop Button Widget
--- @within Widgets
--- A simple button.
---
--- ```json 
--- hasChildren: false,
--- hasState: false,
--- Arguments: {
---     Text: String
--- },
--- Events: {
---     clicked: boolean,
---     hovered: boolean
--- }
--- ```
Iris.Button = function(args)
	return Iris._Insert("Button", args)
end

--- @prop SmallButton Widget
--- @within Widgets
--- A simple button, with reduced padding.
---
--- ```json 
--- hasChildren: false,
--- hasState: false,
--- Arguments: {
---     Text: String
--- },
--- Events: {
---     clicked: boolean,
---     hovered: boolean
--- }
--- ```
Iris.SmallButton = function(args)
	return Iris._Insert("SmallButton", args)
end

--- @prop Separator Widget
--- @within Widgets
--- A vertical or horizonal line, depending on the context, which visually seperates widgets.
---
--- ```json 
--- hasChildren: false,
--- hasState: false
--- ```
Iris.Separator = function(args)
	return Iris._Insert("Separator", args)
end

--- @prop Indent Widget
--- @within Widgets
--- Indents its child widgets.
---
--- ```json 
--- hasChildren: true,
--- hasState: false,
--- Arguments: {
---     Width: Number
--- }
--- ```
Iris.Indent = function(args)
	return Iris._Insert("Indent", args)
end

--- @prop SameLine Widget
--- @within Widgets
--- Positions its children in a row, horizontally
---
--- ```json 
--- hasChildren: true,
--- hasState: false,
--- Arguments: {
---     Width: Number
---     VerticalAlignment: Enum.VerticalAlignment
--- }
--- ```
Iris.SameLine = function(args)
	return Iris._Insert("SameLine", args)
end

--- @prop Group Widget
--- @within Widgets
--- Layout Widget, contains its children as a single group
---
--- ```json 
--- hasChildren: true,
--- hasState: false
--- ```
Iris.Group = function(args)
	return Iris._Insert("Group", args)
end

--- @prop Checkbox Widget
--- @within Widgets
--- A checkbox which can be checked or unchecked.
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string
--- },
--- Events: {
---     checked: boolean,
---     unchecked: boolean,
---     hovered: boolean
--- },
--- States: {
---     isChecked: boolean
--- }
--- ```
Iris.Checkbox = function(args, state)
	return Iris._Insert("Checkbox", args, state)
end

--- @prop RadioButton Widget
--- @within Widgets
--- A single button used to represent a single state when used with multiple radio buttons.
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Index: any
--- },
--- Events: {
---     activated: boolean,
---     deactivated: boolean,
---     hovered: boolean
--- },
--- States: {
---     index: any
--- }
--- ```
Iris.RadioButton = function(args, state)
	return Iris._Insert("RadioButton", args, state)
end

--- @prop Tree Widget
--- @within Widgets
--- A collapsable tree which contains children, positioned vertically.
---
--- ```json 
--- hasChildren: true,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     SpanAvailWidth: boolean,
---     NoIndent: boolean
--- },
--- Events: {
---     collapsed: boolean,
---     uncollapsed: boolean,
---     hovered: boolean
--- },
--- States: {
---     isUncollapsed: boolean
--- }
--- ```
Iris.Tree = function(args, state)
	return Iris._Insert("Tree", args, state)
end

--- @prop CollapsingHeader Widget
--- @within Widgets
--- A collapsable header designed for top level window widget management.
---
--- ```json 
--- hasChildren: true,
--- hasState: true,
--- Arguments: {
---     Text: string,
--- },
--- Events: {
---     collapsed: boolean,
---     uncollapsed: boolean,
---     hovered: boolean
--- },
--- States: {
---     isUncollapsed: boolean
--- }
--- ```
Iris.CollapsingHeader = function(args, state)
	return Iris._Insert("CollapsingHeader", args, state)
end

--- @prop DragNum Widget
--- @within Widgets
--- A field which allows the user to click and drag their cursor to enter a number
--- You can ctrl + click to directly input a number, like InputNum
--- You can hold Shift to increase speed, and Alt to decrease speed
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: number,
---     Min: number,
---     Max: number,
---     Format: string,
--- },
--- Events: {
---     numberChanged: boolean,
---     hovered: boolean
--- },
--- States: {
---     number: number,
---     editingText: boolean
--- }
--- ```
Iris.DragNum = function(args, state)
	return Iris._Insert("DragNum", args, state)
end

--- @prop SliderNum Widget
--- @within Widgets
--- A field which allows the user to slide a grip to enter a number within a range
--- You can ctrl + click to directly input a number, like InputNum
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: number,
---     Min: number,
---     Max: number,
---     Format: string,
--- },
--- Events: {
---     numberChanged: boolean,
---     hovered: boolean
--- },
--- States: {
---     number: number,
---     editingText: boolean
--- }
--- ```
Iris.SliderNum = function(args, state)
	return Iris._Insert("SliderNum", args, state)
end

--- @prop InputNum Widget
--- @within Widgets
--- A field which allows the user to enter a number.
--- Also has buttons to increment and decrement the number.
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: number,
---     Min: number,
---     Max: number,
---     Format: string,
---     NoButtons: boolean,
---     NoField: boolean
--- },
--- Events: {
---     numberChanged: boolean,
---     hovered: boolean
--- },
--- States: {
---     number: number
--- }
--- ```
Iris.InputNum = function(args, state)
	return Iris._Insert("InputNum", args, state)
end

--- @prop InputVector2 Widget
--- @within Widgets
--- A field which allows for the input of a Vector2.
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: Vector2,
---     Min: Vector2,
---     Max: Vector2,
---     Format: string
--- },
--- Events: {
---     numberChanged: boolean
--- },
--- States: {
---     number: Vector2
--- }
--- ```
Iris.InputVector2 = function(args, state)
    return Iris._Insert("InputVector2", args, state)
end

--- @prop InputVector3 Widget
--- @within Widgets
--- A field which allows for the input of a Vector3.
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: Vector3,
---     Min: Vector3,
---     Max: Vector3,
---     Format: string
--- },
--- Events: {
---     numberChanged: boolean
--- },
--- States: {
---     number: Vector3
--- }
--- ```
Iris.InputVector3 = function(args, state)
    return Iris._Insert("InputVector3", args, state)
end

--- @prop InputUDim Widget
--- @within Widgets
--- A field which allows for the input of a UDim.
---
--- ```json 
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: UDim,
---     Min: UDim,
---     Max: UDim,
---     Format: string
--- },
--- Events: {
---     numberChanged: boolean
--- },
--- States: {
---     number: UDim
--- }
--- ```
Iris.InputUDim = function(args, state)
    return Iris._Insert("InputUDim", args, state)
end

--- @prop InputUDim2 Widget
--- @within Widgets
--- A field which allows for the input of a UDim2.
---
--- ```json
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Increment: UDim2,
---     Min: UDim2,
---     Max: UDim2,
---     Format: string
--- },
--- Events: {
---     numberChanged: boolean
--- },
--- States: {
---     number: UDim
--- }
--- ```
Iris.InputUDim2 = function(args, state)
    return Iris._Insert("InputUDim2", args, state)
end

--- @prop InputColor3 Widget
--- @within Widgets
--- A field which allows for the input of a Color3.
---
--- ```json
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     UseFloats: boolean,
--- 	UseHSV: boolean,
---     Format: string
--- },
--- Events: {
---     numberChanged: boolean
--- },
--- States: {
---     color: Color3
--- }
--- ```
Iris.InputColor3 = function(args, state)
    return Iris._Insert("InputColor3", args, state)
end

--- @prop InputColor4 Widget
--- @within Widgets
--- A field which allows for the input of a Color3 and transparency.
---
--- ```json
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     UseFloats: boolean,
--- 	UseHSV: boolean,
---     Format: string
--- },
--- Events: {
---     numberChanged: boolean
--- },
--- States: {
---     color: Color3,
--- 	transparency: number
--- }
--- ```
Iris.InputColor4 = function(args, state)
    return Iris._Insert("InputColor4", args, state)
end

--- @prop InputText Widget
--- @within Widgets
--- A field which allows the user to enter text.
---
--- ```json
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     TextHint: string
--- },
--- Events:  {
---     textChanged: boolean,
---     hovered: boolean
--- }
--- States: {
---     text: string
--- }
--- ```
Iris.InputText = function(args, state)
	return Iris._Insert("InputText", args, state)
end

--- @prop Tooltip Widget
--- @within Widgets
--- Displays a text label next to the cursor
---
--- ```json
--- hasChildren: false,
--- hasState: false,
--- Arguments: {
---     Text: string,
--- }
--- ```
Iris.Tooltip = function(args)
	return Iris._Insert("Tooltip", args)
end

--- @prop Selectable Widget
--- @within Widgets
--- An object which can be selected.
---
--- ```json
--- hasChildren: false,
--- hasState: true,
--- Arguments: {
---     Text: string,
---     Index: any,
---     NoClick: boolean
--- },
--- Events: {
---     selected: boolean,
--- 	unselected: boolean,
--- 	active: boolean
--- },
--- States: {
---     index: any
--- }
--- ```
Iris.Selectable = function(args, state)
	return Iris._Insert("Selectable", args, state)
end

--- @prop Combo Widget
--- @within Widgets
--- A selection box to choose a value from a range of values.
---
--- ```json 
--- hasChildren: true,
--- hasState: true,
--- Arguments: {
---     Text: string,
--- 	NoButton: boolean,
--- 	NoPreview: boolean
--- },
--- Events: {
---     opened: boolean,
--- 	closed: boolean,
--- 	clicked: boolean
--- },
--- States: {
---     index: any,
--- 	isOpened: boolean
--- }
--- ```
Iris.Combo = function(args, state)
	return Iris._Insert("Combo", args, state)
end

--- @prop ComboArray Widget
--- @within Widgets
--- A selection box to choose a value from an array.
---
--- ```json 
--- hasChildren: true,
--- hasState: true,
--- Arguments: {
---     Text: string,
--- 	NoButton: boolean,
--- 	NoPreview: boolean
--- },
--- Events: {
---     opened: boolean,
--- 	closed: boolean,
--- 	clicked: boolean
--- },
--- States: {
---     index: any,
--- 	isOpened: boolean
--- },
--- Extra: {
--- 	selectionArray: { any }	
--- }
--- ```
Iris.ComboArray = Iris.ComboArray

--- @prop InputEnum Widget
--- @within Widgets
--- A selection box to choose a value from an Enum.
---
--- ```json 
--- hasChildren: true,
--- hasState: true,
--- Arguments: {
---     Text: string,
--- 	NoButton: boolean,
--- 	NoPreview: boolean
--- },
--- Events: {
---     opened: boolean,
--- 	closed: boolean,
--- 	clicked: boolean
--- },
--- States: {
---     index: any,
--- 	isOpened: boolean
--- },
--- Extra: {
--- 	enumType: Enum	
--- }
--- ```
Iris.InputEnum = Iris.InputEnum

--- @prop Table Widget
--- @within Widgets
--- A layout widget which allows children to be displayed in configurable columns and rows.
---
--- ```json
--- hasChildren: true,
--- hasState: false,
--- Arguments: {
---     NumColumns: number,
---     RowBg: boolean,
---     BordersOuter: boolean,
---     BordersInner: boolean
--- },
--- Events: {
---     hovered: boolean
--- }
--- ```
Iris.Table = function(args, state)
	return Iris._Insert("Table", args, state)
end

--- @function NextColumn
--- @within Widgets
--- In a table, moves to the next available cell. if the current cell is in the last column,
--- then the next cell will be the first column of the next row.
Iris.NextColumn = Iris.NextColumn

--- @function SetColumnIndex
--- @within Widgets
--- @param index number
--- In a table, directly sets the index of the column
Iris.SetColumnIndex = Iris.SetColumnIndex

--- @function NextRow
--- @within Widgets
--- In a table, moves to the next available row,
--- skipping cells in the previous column if the last cell wasn't in the last column
Iris.NextRow = Iris.NextRow

--- @prop Window Widget
--- @within Widgets
--- A Window. should be used to contain most other Widgets. Cannot be inside other Widgets.
---
--- ```json
--- hasChildren: true,
--- hasState: true,
--- Arguments: {
---     Title: string,
---     NoTitleBar: boolean,
---     NoBackground: boolean,
---     NoCollapse: boolean,
---     NoClose: boolean,
---     NoMove: boolean,
---     NoScrollbar: boolean,
---     NoResize: boolean
--- },
--- Events: {
---     closed: boolean,
---     opened: boolean,
---     collapsed: boolean,
---     uncollapsed: boolean,
---     hovered: boolean
--- },
--- States: {
---     size: Vector2,
---     position: Vector2,
---     isUncollapsed: boolean,
---     isOpened: boolean,
---     scrollDistance: number
--- }
--- ```
Iris.Window = function(args, state)
	return Iris._Insert("Window", args, state)
end

--- @function SetFocusedWindow
--- @within Widgets
--- sets the Window widget to be focused
--- @param thisWidget table
Iris.SetFocusedWindow = Iris.SetFocusedWindow


return Iris
end)
__bundle_register("widgets", function(require, _LOADED, __bundle_register, __bundle_modules)
-- local Types = require(script.Parent.Types)

local widgets = {}

return function(Iris)

    widgets.GuiService = game:GetService("GuiService")
    widgets.RunService = game:GetService("RunService")
    widgets.UserInputService = game:GetService("UserInputService")

    widgets.ICONS = {
        RIGHT_POINTING_TRIANGLE = "\u{25BA}",
        DOWN_POINTING_TRIANGLE = "\u{25BC}",
        MULTIPLICATION_SIGN = "\u{00D7}", -- best approximation for a close X which roblox supports, needs to be scaled about 2x
        BOTTOM_RIGHT_CORNER = "\u{25E2}", -- used in window resize icon in bottom right
        CHECK_MARK = "rbxasset://textures/AnimationEditor/icon_checkmark.png",
        ALPHA_BACKGROUND_TEXTURE = "rbxasset://textures/meshPartFallback.png" -- used for color4 alpha
    }

    widgets.IS_STUDIO = widgets.RunService:IsStudio()
    function widgets.getTime()
        -- time() always returns 0 in the context of plugins
        if widgets.IS_STUDIO then
            return os.clock()
        else
            return time()
        end
    end

    function widgets.findBestWindowPosForPopup(refPos, size, outerMin, outerMax)
        local CURSOR_OFFSET_DIST = 20
        
        if refPos.X + size.X + CURSOR_OFFSET_DIST > outerMax.X then
            if refPos.Y + size.Y + CURSOR_OFFSET_DIST > outerMax.Y then
                -- placed to the top
                refPos = refPos + Vector2.new(0, - (CURSOR_OFFSET_DIST + size.Y))
            else
                -- placed to the bottom
                refPos = refPos + Vector2.new(0, CURSOR_OFFSET_DIST)
            end
        else
            -- placed to the right
            refPos = refPos + Vector2.new(CURSOR_OFFSET_DIST, 0)
        end

        local clampedPos = Vector2.new(
            math.max(math.min(refPos.X + size.X, outerMax.X) - size.X, outerMin.X),
            math.max(math.min(refPos.Y + size.Y, outerMax.Y) - size.Y, outerMin.Y)
        )
        return clampedPos
    end

    function widgets.isPosInsideRect(pos, rectMin, rectMax)
        return pos.X > rectMin.X and pos.X < rectMax.X and pos.Y > rectMin.Y and pos.Y < rectMax.Y
    end

    function widgets.extend(superClass, subClass)
        local newClass = table.clone(superClass)
        for index, value in next, subClass do
            newClass[index] = value
        end
        return newClass
    end

    function widgets.UIPadding(Parent, PxPadding)
        local UIPaddingInstance = Instance.new("UIPadding")
        UIPaddingInstance.PaddingLeft = UDim.new(0, PxPadding.X)
        UIPaddingInstance.PaddingRight = UDim.new(0, PxPadding.X)
        UIPaddingInstance.PaddingTop = UDim.new(0, PxPadding.Y)
        UIPaddingInstance.PaddingBottom = UDim.new(0, PxPadding.Y)
        UIPaddingInstance.Parent = Parent
        return UIPaddingInstance
    end

    function widgets.UIListLayout(Parent, FillDirection, Padding)
        local UIListLayoutInstance = Instance.new("UIListLayout")
        UIListLayoutInstance.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayoutInstance.Padding = Padding
        UIListLayoutInstance.FillDirection = FillDirection
        UIListLayoutInstance.Parent = Parent
        return UIListLayoutInstance
    end

    function widgets.UIStroke(Parent, Thickness, Color, Transparency)
        local UIStrokeInstance = Instance.new("UIStroke")
        UIStrokeInstance.Thickness = Thickness
        UIStrokeInstance.Color = Color
        UIStrokeInstance.Transparency = Transparency
        UIStrokeInstance.Parent = Parent
        return UIStrokeInstance
    end

    function widgets.UICorner(Parent, PxRounding)
        local UICornerInstance = Instance.new("UICorner")
        UICornerInstance.CornerRadius = UDim.new(PxRounding ~= nil and 0 or 1, PxRounding or 0)
        UICornerInstance.Parent = Parent
        return UICornerInstance
    end

    function widgets.UISizeConstraint(Parent, MinSize, MaxSize)
        local UISizeConstraintInstance = Instance.new("UISizeConstraint")
        UISizeConstraintInstance.MinSize = MinSize or UISizeConstraintInstance.MinSize -- made these optional
        UISizeConstraintInstance.MaxSize = MaxSize or UISizeConstraintInstance.MaxSize
        UISizeConstraintInstance.Parent = Parent
        return UISizeConstraintInstance
    end

    -- below uses Iris

    function widgets.applyTextStyle(thisInstance)
        thisInstance.FontFace = Font.fromEnum(Iris._config.TextFont)
        thisInstance.TextSize = Iris._config.TextSize
        thisInstance.TextColor3 = Iris._config.TextColor
        thisInstance.TextTransparency = Iris._config.TextTransparency
        thisInstance.TextXAlignment = Enum.TextXAlignment.Left

        thisInstance.AutoLocalize = false
        thisInstance.RichText = false
    end

    function widgets.applyInteractionHighlights(Button, Highlightee, Colors)
        local exitedButton = false
        Button.MouseEnter:Connect(function()
            Highlightee.BackgroundColor3 = Colors.ButtonHoveredColor
            Highlightee.BackgroundTransparency = Colors.ButtonHoveredTransparency

            exitedButton = false
        end)

        Button.MouseLeave:Connect(function()
            Highlightee.BackgroundColor3 = Colors.ButtonColor
            Highlightee.BackgroundTransparency = Colors.ButtonTransparency

            exitedButton = true
        end)

        Button.InputBegan:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) then
                return
            end
            Highlightee.BackgroundColor3 = Colors.ButtonActiveColor
            Highlightee.BackgroundTransparency = Colors.ButtonActiveTransparency
        end)

        Button.InputEnded:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) or exitedButton then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Highlightee.BackgroundColor3 = Colors.ButtonHoveredColor
                Highlightee.BackgroundTransparency = Colors.ButtonHoveredTransparency
            end
            if input.UserInputType == Enum.UserInputType.Gamepad1 then
                Highlightee.BackgroundColor3 = Colors.ButtonColor
                Highlightee.BackgroundTransparency = Colors.ButtonTransparency
            end
        end)
        
        Button.SelectionImageObject = Iris.SelectionImageObject
    end

    function widgets.applyInteractionHighlightsWithMultiHighlightee(Button, Highlightees)
        local exitedButton = false
        Button.MouseEnter:Connect(function()
            for _, Highlightee in next, Highlightees do
                Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonHoveredColor
                Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonHoveredTransparency
    
                exitedButton = false
            end
        end)

        Button.MouseLeave:Connect(function()
            for _, Highlightee in next, Highlightees do
                Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonColor
                Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonTransparency

                exitedButton = true
            end
        end)

        Button.InputBegan:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) then
                return
            end
            for _, Highlightee in next, Highlightees do
                Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonActiveColor
                Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonActiveTransparency
            end
        end)

        Button.InputEnded:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) or exitedButton then
                return
            end
            for _, Highlightee in next, Highlightees do
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonHoveredColor
                    Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonHoveredTransparency
                end
                if input.UserInputType == Enum.UserInputType.Gamepad1 then
                    Highlightee[1].BackgroundColor3 = Highlightee[2].ButtonColor
                    Highlightee[1].BackgroundTransparency = Highlightee[2].ButtonTransparency
                end
            end
        end)
        
        Button.SelectionImageObject = Iris.SelectionImageObject
    end

    function widgets.applyTextInteractionHighlights(Button, Highlightee, Colors)
        local exitedButton = false
        Button.MouseEnter:Connect(function()
            Highlightee.TextColor3 = Colors.ButtonHoveredColor
            Highlightee.TextTransparency = Colors.ButtonHoveredTransparency

            exitedButton = false
        end)

        Button.MouseLeave:Connect(function()
            Highlightee.TextColor3 = Colors.ButtonColor
            Highlightee.TextTransparency = Colors.ButtonTransparency

            exitedButton = true
        end)

        Button.InputBegan:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) then
                return
            end
            Highlightee.TextColor3 = Colors.ButtonActiveColor
            Highlightee.TextTransparency = Colors.ButtonActiveTransparency
        end)

        Button.InputEnded:Connect(function(input)
            if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Gamepad1) or exitedButton then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Highlightee.TextColor3 = Colors.ButtonHoveredColor
                Highlightee.TextTransparency = Colors.ButtonHoveredTransparency
            end
            if input.UserInputType == Enum.UserInputType.Gamepad1 then
                Highlightee.TextColor3 = Colors.ButtonColor
                Highlightee.TextTransparency = Colors.ButtonTransparency
            end
        end)
        
        Button.SelectionImageObject = Iris.SelectionImageObject
    end

    function widgets.applyFrameStyle(thisInstance, forceNoPadding, doubleyNoPadding)
        -- padding, border, and rounding
        -- optimized to only use what instances are needed, based on style
        local FramePadding = Iris._config.FramePadding
        local FrameBorderSize = Iris._config.FrameBorderSize
        local FrameBorderColor = Iris._config.BorderColor
        local FrameBorderTransparency = Iris._config.ButtonTransparency
        local FrameRounding = Iris._config.FrameRounding
        
        if FrameBorderSize > 0 and FrameRounding > 0 then
            thisInstance.BorderSizePixel = 0

            local uiStroke = Instance.new("UIStroke")
            uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            uiStroke.LineJoinMode = Enum.LineJoinMode.Round
            uiStroke.Transparency = FrameBorderTransparency
            uiStroke.Thickness = FrameBorderSize
            uiStroke.Color = FrameBorderColor

            widgets.UICorner(thisInstance, FrameRounding)
            uiStroke.Parent = thisInstance

            if not forceNoPadding then
                widgets.UIPadding(thisInstance, Iris._config.FramePadding)
            end
        elseif FrameBorderSize < 1 and FrameRounding > 0 then
            thisInstance.BorderSizePixel = 0

            widgets.UICorner(thisInstance, FrameRounding)
            if not forceNoPadding then
                widgets.UIPadding(thisInstance, Iris._config.FramePadding)
            end
        elseif FrameRounding < 1 then
            thisInstance.BorderSizePixel = FrameBorderSize
            thisInstance.BorderColor3 = FrameBorderColor
            thisInstance.BorderMode = Enum.BorderMode.Inset

            if not forceNoPadding then
                widgets.UIPadding(thisInstance, FramePadding - Vector2.new(FrameBorderSize, FrameBorderSize))
            elseif not doubleyNoPadding then
                widgets.UIPadding(thisInstance, -Vector2.new(FrameBorderSize, FrameBorderSize))
            end
        end
    end

    widgets.EVENTS = {
        hover = function(pathToHovered)
            return {
                ["Init"] = function(thisWidget)
                    local hoveredGuiObject = pathToHovered(thisWidget)
                    hoveredGuiObject.MouseEnter:Connect(function()
                        thisWidget.isHoveredEvent = true
                    end)
                    hoveredGuiObject.MouseLeave:Connect(function()
                        thisWidget.isHoveredEvent = false
                    end)
                    thisWidget.isHoveredEvent = false
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.isHoveredEvent
                end
            }
        end,

        click = function(pathToClicked)
            return {
                ["Init"] = function(thisWidget)
                    local clickedGuiObject = pathToClicked(thisWidget)
                    thisWidget.lastClickedTick = -1

                    clickedGuiObject.MouseButton1Click:Connect(function()
                        thisWidget.lastClickedTick = Iris._cycleTick + 1
                    end)
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastClickedTick == Iris._cycleTick
                end
            }
        end,

        rightClick = function(pathToClicked)
            return {
                ["Init"] = function(thisWidget)
                    local clickedGuiObject = pathToClicked(thisWidget)
                    thisWidget.lastRightClickedTick = -1

                    clickedGuiObject.MouseButton2Click:Connect(function()
                        thisWidget.lastRightClickedTick = Iris._cycleTick + 1
                    end)
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastRightClickedTick == Iris._cycleTick
                end
            }
        end,

        doubleClick = function(pathToClicked)
            return {
                ["Init"] = function(thisWidget)
                    local clickedGuiObject = pathToClicked(thisWidget)
                    thisWidget.lastClickedTime = -1
                    thisWidget.lastClickedPosition = Vector2.zero
                    thisWidget.lastDoubleClickedTick = -1

                    clickedGuiObject.MouseButton1Down:Connect(function(x, y)
                        local currentTime = widgets.getTime()
                        local isTimeValid = currentTime - thisWidget.lastClickedTime < Iris._config.MouseDoubleClickTime
                        if isTimeValid and (Vector2.new(x, y) - thisWidget.lastClickedPosition).Magnitude < Iris._config.MouseDoubleClickMaxDist then
                            thisWidget.lastDoubleClickedTick = Iris._cycleTick + 1
                        else
                            thisWidget.lastClickedTime = currentTime
                            thisWidget.lastClickedPosition = Vector2.new(x, y)
                        end
                    end)
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastDoubleClickedTick == Iris._cycleTick
                end
            }
        end,

        ctrlClick = function(pathToClicked)
            return {
                ["Init"] = function(thisWidget)
                    local clickedGuiObject = pathToClicked(thisWidget)
                    thisWidget.lastCtrlClickedTick = -1

                    clickedGuiObject.MouseButton1Click:Connect(function()
                        if widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
                            thisWidget.lastCtrlClickedTick = Iris._cycleTick + 1
                        end
                    end)
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastCtrlClickedTick == Iris._cycleTick
                end
            }
        end
    }

    function widgets.discardState(thisWidget)
        for _, state in next, thisWidget.state do
            state.ConnectedWidgets[thisWidget.ID] = nil
        end
    end

    require("widgets/Root")       (Iris, widgets)
    require("widgets/Text")       (Iris, widgets)
    require("widgets/Button")     (Iris, widgets)
    require("widgets/Format")     (Iris, widgets)
    require("widgets/Checkbox")   (Iris, widgets)
    require("widgets/RadioButton")(Iris, widgets)
    require("widgets/Tree")       (Iris, widgets)
    require("widgets/Input")      (Iris, widgets)
    require("widgets/Combo")      (Iris, widgets)
    require("widgets/Table")      (Iris, widgets)
    require("widgets/Window")     (Iris, widgets)
end
end)
__bundle_register("widgets/Window", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    local function relocateTooltips()
        if Iris._rootInstance == nil then
            return
        end
        local PopupScreenGui = Iris._rootInstance.PopupScreenGui
        local TooltipContainer = PopupScreenGui.TooltipContainer
        local mouseLocation = widgets.UserInputService:GetMouseLocation() - Vector2.new(0, 36)
        local newPosition = widgets.findBestWindowPosForPopup(mouseLocation, TooltipContainer.AbsoluteSize, Vector2.new(Iris._config.DisplaySafeAreaPadding, Iris._config.DisplaySafeAreaPadding), PopupScreenGui.AbsoluteSize)
        TooltipContainer.Position = UDim2.fromOffset(newPosition.X, newPosition.Y)
    end

    widgets.UserInputService.InputChanged:Connect(relocateTooltips)

    Iris.WidgetConstructor("Tooltip", { 
        hasState = false,
        hasChildren = false,
        Args = {
            ["Text"] = 1
        },
        Events = {

        },
        Generate = function(thisWidget)
            thisWidget.parentWidget = Iris._rootWidget -- only allow root as parent

            local Tooltip = Instance.new("Frame")
            Tooltip.Name = "Iris_Tooltip"
            Tooltip.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
            Tooltip.BorderSizePixel = 0
            Tooltip.BackgroundTransparency = 1
            Tooltip.ZIndex = thisWidget.ZIndex + 1
            Tooltip.LayoutOrder = thisWidget.ZIndex + 1
            Tooltip.AutomaticSize = Enum.AutomaticSize.Y

            local TooltipText = Instance.new("TextLabel")
            TooltipText.Name = "TooltipText"
            TooltipText.Size = UDim2.fromOffset(0, 0)
            TooltipText.ZIndex = thisWidget.ZIndex + 1
            TooltipText.LayoutOrder = thisWidget.ZIndex + 1
            TooltipText.AutomaticSize = Enum.AutomaticSize.XY
    
            widgets.applyTextStyle(TooltipText)
            TooltipText.BackgroundColor3 = Iris._config.WindowBgColor
            TooltipText.BackgroundTransparency = Iris._config.WindowBgTransparency
            TooltipText.BorderSizePixel = Iris._config.PopupBorderSize
            if Iris._config.PopupRounding > 0 then
                widgets.UICorner(TooltipText, Iris._config.PopupRounding)
            end
            TooltipText.TextWrapped = true

            local uiStroke = Instance.new("UIStroke")
            uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            uiStroke.LineJoinMode = Enum.LineJoinMode.Round
            uiStroke.Thickness = Iris._config.WindowBorderSize
            uiStroke.Color = Iris._config.BorderActiveColor
            uiStroke.Parent = TooltipText
            widgets.UIPadding(TooltipText, Iris._config.WindowPadding)

            TooltipText.Parent = Tooltip
            
            return Tooltip
        end,
        Update = function(thisWidget)
            local TooltipText = thisWidget.Instance.TooltipText
            if thisWidget.arguments.Text == nil then
                error("Iris.Text Text Argument is required", 5)
            end
            TooltipText.Text = thisWidget.arguments.Text
            relocateTooltips()
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end
    })

    local windowDisplayOrder = 0 -- incremental count which is used for determining focused windows ZIndex
    local dragWindow -- window being dragged, may be nil
    local isDragging = false
    local moveDeltaCursorPosition -- cursor offset from drag origin (top left of window)

    local resizeWindow -- window being resized, may be nil
    local isResizing = false
    local isInsideResize = false -- is cursor inside of the focused window resize outer padding
    local isInsideWindow = false -- is cursor inside of the focused window
    local resizeFromTopBottom = Enum.TopBottom.Top
    local resizeFromLeftRight = Enum.LeftRight.Left

    local lastCursorPosition

    local focusedWindow -- window with focus, may be nil
    local anyFocusedWindow = false -- is there any focused window?

    local windowWidgets = {} -- array of widget objects of type window

    local function getAbsoluteSize(thisWidget) -- possible parents are GuiBase2d, CoreGui, PlayerGui
        -- possibly the stupidest function ever written
        local size
        if thisWidget.usesScreenGUI then
            size = thisWidget.Instance.AbsoluteSize
        else
            local rootParent = thisWidget.Instance.Parent
            if rootParent:IsA("GuiBase2d") then
                size = rootParent.AbsoluteSize
            else
                if rootParent.Parent:IsA("GuiBase2d") then
                    size = rootParent.AbsoluteSize
                else
                    size = workspace.CurrentCamera.ViewportSize
                end
            end
        end
        return size
    end

    local function quickSwapWindows()
        -- ctrl + tab swapping functionality
        if Iris._config.UseScreenGUIs == false then
            return
        end

        local lowest = 0xFFFF
        local lowestWidget

        for _, widget in next, windowWidgets do
            if widget.state.isOpened.value and (not widget.arguments.NoNav) then
                local value = widget.Instance.DisplayOrder
                if value < lowest then
                    lowest = value
                    lowestWidget = widget
                end
            end
        end

        if lowestWidget.state.isUncollapsed.value == false then
            lowestWidget.state.isUncollapsed:set(true)
        end
        Iris.SetFocusedWindow(lowestWidget)
    end

    local function fitSizeToWindowBounds(thisWidget, intentedSize)
        local windowSize = Vector2.new(thisWidget.state.position.value.X, thisWidget.state.position.value.Y)
        local minWindowSize = (Iris._config.TextSize + Iris._config.FramePadding.Y * 2) * 2
        local usableSize = getAbsoluteSize(thisWidget)
        local safeAreaPadding = Vector2.new(Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.X, Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.Y)

        local maxWindowSize = (
            usableSize -
            windowSize -
            safeAreaPadding
        )
        return Vector2.new(
            math.clamp(intentedSize.X, minWindowSize, math.max(maxWindowSize.X, minWindowSize)),
            math.clamp(intentedSize.Y, minWindowSize, math.max(maxWindowSize.Y, minWindowSize))
        )
    end

    local function fitPositionToWindowBounds(thisWidget, intendedPosition)
        local thisWidgetInstance = thisWidget.Instance
        local usableSize = getAbsoluteSize(thisWidget)
        local safeAreaPadding = Vector2.new(Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.X, Iris._config.WindowBorderSize + Iris._config.DisplaySafeAreaPadding.Y)

        return Vector2.new(
            math.clamp(
                intendedPosition.X,
                safeAreaPadding.X,
                math.max(safeAreaPadding.X, usableSize.X - thisWidgetInstance.WindowButton.AbsoluteSize.X - safeAreaPadding.X)
            ),
            math.clamp(
                intendedPosition.Y,
                safeAreaPadding.Y, 
                math.max(safeAreaPadding.Y, usableSize.Y - thisWidgetInstance.WindowButton.AbsoluteSize.Y - safeAreaPadding.Y)
            )
        )
    end

    Iris.SetFocusedWindow = function(thisWidget)
        if focusedWindow == thisWidget then return end

        if anyFocusedWindow then
            if windowWidgets[focusedWindow.ID] ~= nil then
                -- update appearance to unfocus
                local TitleBar = focusedWindow.Instance.WindowButton.TitleBar
                if focusedWindow.state.isUncollapsed.value then
                    TitleBar.BackgroundColor3 = Iris._config.TitleBgColor
                    TitleBar.BackgroundTransparency = Iris._config.TitleBgTransparency
                else
                    TitleBar.BackgroundColor3 = Iris._config.TitleBgCollapsedColor
                    TitleBar.BackgroundTransparency = Iris._config.TitleBgCollapsedTransparency
                end
                focusedWindow.Instance.WindowButton.UIStroke.Color = Iris._config.BorderColor
            end

            anyFocusedWindow = false
            focusedWindow = nil
        end

        if thisWidget ~= nil then
            -- update appearance to focus
            anyFocusedWindow = true
            focusedWindow = thisWidget
            local TitleBar = focusedWindow.Instance.WindowButton.TitleBar
            TitleBar.BackgroundColor3 = Iris._config.TitleBgActiveColor
            TitleBar.BackgroundTransparency = Iris._config.TitleBgActiveTransparency
            focusedWindow.Instance.WindowButton.UIStroke.Color = Iris._config.BorderActiveColor
            
            windowDisplayOrder = windowDisplayOrder + 1
            if thisWidget.usesScreenGUI then
                focusedWindow.Instance.DisplayOrder = windowDisplayOrder + Iris._config.DisplayOrderOffset
            end

            if thisWidget.state.isUncollapsed.value == false then
                thisWidget.state.isUncollapsed:set(true)
            end

            local firstSelectedObject = widgets.GuiService.SelectedObject
            if firstSelectedObject then
                if focusedWindow.Instance.WindowButton.TitleBar.Visible then
                    -- widgets.GuiService:Select(focusedWindow.Instance.WindowButton.TitleBar)
                else
                    --widgets.GuiService:Select(focusedWindow.Instance.ChildContainer)
                end
            end
        end
    end

    widgets.UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseButton1 then
            Iris.SetFocusedWindow(nil)
        end

        if input.KeyCode == Enum.KeyCode.Tab and (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
            quickSwapWindows()
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isInsideResize and not isInsideWindow and anyFocusedWindow then
                local midWindow = focusedWindow.state.position.value + (focusedWindow.state.size.value / 2)
                local cursorPosition = widgets.UserInputService:GetMouseLocation() - Vector2.new(0, 36) - midWindow

                -- check which axis its closest to, then check which side is closest with math.sign
                if math.abs(cursorPosition.X) * focusedWindow.state.size.value.Y >= math.abs(cursorPosition.Y) * focusedWindow.state.size.value.X then
                    resizeFromTopBottom = Enum.TopBottom.Center
                    resizeFromLeftRight =  math.sign(cursorPosition.X) == -1 and Enum.LeftRight.Left or Enum.LeftRight.Right
                else
                    resizeFromLeftRight = Enum.LeftRight.Center
                    resizeFromTopBottom =  math.sign(cursorPosition.Y) == -1 and Enum.TopBottom.Top or Enum.TopBottom.Bottom
                end
                isResizing = true
                resizeWindow = focusedWindow
            end
        end
    end)

    widgets.UserInputService.TouchTapInWorld:Connect(function(_, gameProcessedEvent)
        if not gameProcessedEvent then
            Iris.SetFocusedWindow(nil)
        end
    end)

    widgets.UserInputService.InputChanged:Connect(function(input)
        if isDragging then
            local mouseLocation
            if input.UserInputType == Enum.UserInputType.Touch then
                local location = input.Position
                mouseLocation = Vector2.new(location.X, location.Y)
            else
                mouseLocation = widgets.UserInputService:getMouseLocation()
            end
            local dragInstance = dragWindow.Instance.WindowButton
            local intendedPosition = mouseLocation - moveDeltaCursorPosition
            local newPos = fitPositionToWindowBounds(dragWindow, intendedPosition)

            -- state shouldnt be used like this, but calling :set would run the entire UpdateState function for the window, which is slow.
            dragInstance.Position = UDim2.fromOffset(newPos.X, newPos.Y)
            dragWindow.state.position.value = newPos
        end
        if isResizing then
            local resizeInstance = resizeWindow.Instance.WindowButton
            local windowPosition = Vector2.new(resizeInstance.Position.X.Offset, resizeInstance.Position.Y.Offset)
            local windowSize = Vector2.new(resizeInstance.Size.X.Offset, resizeInstance.Size.Y.Offset)

            local mouseDelta
            if input.UserInputType == Enum.UserInputType.Touch then
                mouseDelta = input.Delta
            else
                mouseDelta = widgets.UserInputService:GetMouseLocation() - lastCursorPosition
            end

            local intendedPosition = windowPosition + Vector2.new(
                 resizeFromLeftRight == Enum.LeftRight.Left and mouseDelta.X or 0,
                 resizeFromTopBottom == Enum.TopBottom.Top and mouseDelta.Y or 0
            )

            local intendedSize = windowSize + Vector2.new(
                 resizeFromLeftRight == Enum.LeftRight.Left and -mouseDelta.X or resizeFromLeftRight == Enum.LeftRight.Right and mouseDelta.X or 0,
                 resizeFromTopBottom == Enum.TopBottom.Top and -mouseDelta.Y or resizeFromTopBottom == Enum.TopBottom.Bottom and mouseDelta.Y or 0
            )

            local newSize = fitSizeToWindowBounds(resizeWindow, intendedSize)
            local newPosition = fitPositionToWindowBounds(resizeWindow, intendedPosition)

            resizeInstance.Size = UDim2.fromOffset(newSize.X, newSize.Y)
            resizeWindow.state.size.value = newSize
            resizeInstance.Position = UDim2.fromOffset(newPosition.X, newPosition.Y)
            resizeWindow.state.position.value = newPosition
        end

        lastCursorPosition = widgets.UserInputService:getMouseLocation()
    end)

    widgets.UserInputService.InputEnded:Connect(function(input, _)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            local dragInstance = dragWindow.Instance.WindowButton
            isDragging = false
            dragWindow.state.position:set(Vector2.new(dragInstance.Position.X.Offset, dragInstance.Position.Y.Offset))
        end
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isResizing then
            isResizing = false
            resizeWindow.state.size:set(resizeWindow.Instance.WindowButton.AbsoluteSize)
        end

        if input.KeyCode == Enum.KeyCode.ButtonX then
            quickSwapWindows()
        end
    end)

    Iris.WidgetConstructor("Window", {
        hasState = true,
        hasChildren = true,
        Args = {
            ["Title"] = 1,
            ["NoTitleBar"] = 2,
            ["NoBackground"] = 3,
            ["NoCollapse"] = 4,
            ["NoClose"] = 5,
            ["NoMove"] = 6,
            ["NoScrollbar"] = 7,
            ["NoResize"] = 8,
            ["NoNav"] = 9,
        },
        Events = {
            ["closed"] = {
                ["Init"] = function(thisWidget)

                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastClosedTick == Iris._cycleTick
                end
            },
            ["opened"] = {
                ["Init"] = function(thisWidget)

                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastOpenedTick == Iris._cycleTick
                end
            },
            ["collapsed"] = {
                ["Init"] = function(thisWidget)

                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastCollapsedTick == Iris._cycleTick
                end
            },
            ["uncollapsed"] = {
                ["Init"] = function(thisWidget)

                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastUncollapsedTick == Iris._cycleTick
                end
            },
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance.WindowButton
            end)
        },
        Generate = function(thisWidget)
            thisWidget.parentWidget = Iris._rootWidget -- only allow root as parent

            thisWidget.usesScreenGUI = Iris._config.UseScreenGUIs
            windowWidgets[thisWidget.ID] = thisWidget

            local Window
            if thisWidget.usesScreenGUI then
                Window = Instance.new("ScreenGui")
                Window.ResetOnSpawn = false
                Window.DisplayOrder = Iris._config.DisplayOrderOffset
            else
                Window = Instance.new("Folder")
            end
            Window.Name = "Iris_Window"

            local WindowButton = Instance.new("TextButton")
            WindowButton.Name = "WindowButton"
            WindowButton.BackgroundTransparency = 1
            WindowButton.BorderSizePixel = 0
            WindowButton.ZIndex = thisWidget.ZIndex + 1
            WindowButton.LayoutOrder = thisWidget.ZIndex + 1
            WindowButton.Size = UDim2.fromOffset(0, 0)
            WindowButton.AutomaticSize = Enum.AutomaticSize.None
            WindowButton.ClipsDescendants = false
            WindowButton.Text = ""
            WindowButton.AutoButtonColor = false
            WindowButton.Active = false
            WindowButton.Selectable = false
            WindowButton.SelectionImageObject = Iris.SelectionImageObject
            WindowButton.Parent = Window

            WindowButton.SelectionGroup = true
            WindowButton.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
            WindowButton.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
            WindowButton.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
            WindowButton.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
            
            WindowButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Keyboard then return end
                if thisWidget.state.isUncollapsed.value then
                    Iris.SetFocusedWindow(thisWidget)
                end
                if not thisWidget.arguments.NoMove and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragWindow = thisWidget
                    isDragging = true
                    moveDeltaCursorPosition = widgets.UserInputService:GetMouseLocation() - thisWidget.state.position.value
                end
            end)

            local uiStroke = Instance.new("UIStroke")
            uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            uiStroke.LineJoinMode = Enum.LineJoinMode.Miter
            uiStroke.Color = Iris._config.BorderColor
            uiStroke.Thickness = Iris._config.WindowBorderSize

            uiStroke.Parent = WindowButton

            local ChildContainer = Instance.new("ScrollingFrame")
            ChildContainer.Name = "ChildContainer"
            ChildContainer.Position = UDim2.fromOffset(0, 0)
            ChildContainer.BorderSizePixel = 0
            ChildContainer.ZIndex = thisWidget.ZIndex + 2
            ChildContainer.LayoutOrder = thisWidget.ZIndex + 3
            ChildContainer.AutomaticSize = Enum.AutomaticSize.None
            ChildContainer.Size = UDim2.fromScale(1, 1)
            ChildContainer.Selectable = false
			ChildContainer.ClipsDescendants = true

            ChildContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
            ChildContainer.ScrollBarImageTransparency = Iris._config.ScrollbarGrabTransparency
            ChildContainer.ScrollBarImageColor3 = Iris._config.ScrollbarGrabColor
            ChildContainer.CanvasSize = UDim2.fromScale(0, 1)
            ChildContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
            
            ChildContainer.BackgroundColor3 = Iris._config.WindowBgColor
            ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
            ChildContainer.Parent = WindowButton

            widgets.UIPadding(ChildContainer, Iris._config.WindowPadding)

            ChildContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                -- "wrong" use of state here, for optimization
                thisWidget.state.scrollDistance.value = ChildContainer.CanvasPosition.Y
            end)

            ChildContainer.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Keyboard then return end
                if thisWidget.state.isUncollapsed.value then
                    Iris.SetFocusedWindow(thisWidget)
                end
            end)

            local TerminatingFrame = Instance.new("Frame")
            TerminatingFrame.Name = "TerminatingFrame"
            TerminatingFrame.BackgroundTransparency = 1
            TerminatingFrame.LayoutOrder = 0x7FFFFFF0
            TerminatingFrame.BorderSizePixel = 0
            TerminatingFrame.Size = UDim2.fromOffset(0, Iris._config.WindowPadding.Y + Iris._config.FramePadding.Y)
            TerminatingFrame.Parent = ChildContainer

            local ChildContainerUIListLayout = widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
            ChildContainerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

            local TitleBar = Instance.new("Frame")
            TitleBar.Name = "TitleBar"
            TitleBar.BorderSizePixel = 0
            TitleBar.ZIndex = thisWidget.ZIndex + 1
            TitleBar.LayoutOrder = thisWidget.ZIndex + 1
            TitleBar.AutomaticSize = Enum.AutomaticSize.Y
            TitleBar.Size = UDim2.fromScale(1, 0)
            TitleBar.ClipsDescendants = true
            TitleBar.Parent = WindowButton

            TitleBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    if not thisWidget.arguments.NoMove then
                        dragWindow = thisWidget
                        isDragging = true
                        local location = input.Position
                        moveDeltaCursorPosition = Vector2.new(location.X, location.Y) - thisWidget.state.position.value
                    end
                end
            end)

            local TitleButtonSize = Iris._config.TextSize + ((Iris._config.FramePadding.Y - 1) * 2)

            local CollapseArrow = Instance.new("TextButton")
            CollapseArrow.Name = "CollapseArrow"
            CollapseArrow.Size = UDim2.fromOffset(TitleButtonSize,TitleButtonSize)
            CollapseArrow.Position = UDim2.new(0, Iris._config.FramePadding.X + 1, 0.5, 0)
            CollapseArrow.AnchorPoint = Vector2.new(0, 0.5)
            CollapseArrow.AutoButtonColor = false
            CollapseArrow.BackgroundTransparency = 1
            CollapseArrow.BorderSizePixel = 0
            CollapseArrow.ZIndex = thisWidget.ZIndex + 4
            CollapseArrow.AutomaticSize = Enum.AutomaticSize.None
            widgets.applyTextStyle(CollapseArrow)
            CollapseArrow.TextXAlignment = Enum.TextXAlignment.Center
            CollapseArrow.TextSize = Iris._config.TextSize
            CollapseArrow.Parent = TitleBar

            CollapseArrow.MouseButton1Click:Connect(function()
                thisWidget.state.isUncollapsed:set(not thisWidget.state.isUncollapsed.value)
            end)

            widgets.UICorner(CollapseArrow, 1e9)

            widgets.applyInteractionHighlights(CollapseArrow, CollapseArrow, {
                ButtonColor = Iris._config.ButtonColor,
                ButtonTransparency = 1,
                ButtonHoveredColor = Iris._config.ButtonHoveredColor,
                ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
                ButtonActiveColor = Iris._config.ButtonActiveColor,
                ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
            })

            local CloseIcon = Instance.new("TextButton")
            CloseIcon.Name = "CloseIcon"
            CloseIcon.Size = UDim2.fromOffset(TitleButtonSize, TitleButtonSize)
            CloseIcon.Position = UDim2.new(1, -(Iris._config.FramePadding.X + 1), 0.5, 0)
            CloseIcon.AnchorPoint = Vector2.new(1, 0.5)
            CloseIcon.AutoButtonColor = false
            CloseIcon.BackgroundTransparency = 1
            CloseIcon.BorderSizePixel = 0
            CloseIcon.ZIndex = thisWidget.ZIndex + 4
            CloseIcon.AutomaticSize = Enum.AutomaticSize.None
            widgets.applyTextStyle(CloseIcon)
            CloseIcon.TextXAlignment = Enum.TextXAlignment.Center
            CloseIcon.Font = Enum.Font.Code
            CloseIcon.TextSize = Iris._config.TextSize * 2
            CloseIcon.Text = widgets.ICONS.MULTIPLICATION_SIGN
            CloseIcon.Parent = TitleBar

            widgets.UICorner(CloseIcon, 1e9)

            CloseIcon.MouseButton1Click:Connect(function()
                thisWidget.state.isOpened:set(false)
            end)

            widgets.applyInteractionHighlights(CloseIcon, CloseIcon, {
                ButtonColor = Iris._config.ButtonColor,
                ButtonTransparency = 1,
                ButtonHoveredColor = Iris._config.ButtonHoveredColor,
                ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
                ButtonActiveColor = Iris._config.ButtonActiveColor,
                ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
            })

            -- allowing fractional titlebar title location dosent seem useful, as opposed to Enum.LeftRight.

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.BorderSizePixel = 0
            Title.BackgroundTransparency = 1
            Title.ZIndex = thisWidget.ZIndex + 3
            Title.AutomaticSize = Enum.AutomaticSize.XY
            widgets.applyTextStyle(Title)
            Title.Parent = TitleBar
            local TitleAlign
            if Iris._config.WindowTitleAlign == Enum.LeftRight.Left then
                TitleAlign = 0
            elseif Iris._config.WindowTitleAlign == Enum.LeftRight.Center then
                TitleAlign = 0.5
            else
                TitleAlign = 1
            end
            Title.Position = UDim2.fromScale(TitleAlign, 0)
            Title.AnchorPoint = Vector2.new(TitleAlign, 0)

            widgets.UIPadding(Title, Iris._config.FramePadding)

            local ResizeButtonSize = Iris._config.TextSize + Iris._config.FramePadding.X

            local ResizeGrip = Instance.new("TextButton")
            ResizeGrip.Name = "ResizeGrip"
            ResizeGrip.AnchorPoint = Vector2.new(1, 1)
            ResizeGrip.Size = UDim2.fromOffset(ResizeButtonSize, ResizeButtonSize)
            ResizeGrip.AutoButtonColor = false
            ResizeGrip.BorderSizePixel = 0
            ResizeGrip.BackgroundTransparency = 1
            ResizeGrip.Text = widgets.ICONS.BOTTOM_RIGHT_CORNER
            ResizeGrip.ZIndex = thisWidget.ZIndex + 3
            ResizeGrip.Position = UDim2.fromScale(1, 1)
            ResizeGrip.TextSize = ResizeButtonSize
            ResizeGrip.TextColor3 = Iris._config.ButtonColor
            ResizeGrip.TextTransparency = Iris._config.ButtonTransparency
            ResizeGrip.LineHeight = 1.10 -- fix mild rendering issue
            ResizeGrip.Selectable = false
            
            widgets.applyTextInteractionHighlights(ResizeGrip, ResizeGrip, {
                ButtonColor = Iris._config.ButtonColor,
                ButtonTransparency = Iris._config.ButtonTransparency,
                ButtonHoveredColor = Iris._config.ButtonHoveredColor,
                ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
                ButtonActiveColor = Iris._config.ButtonActiveColor,
                ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
            })

            ResizeGrip.MouseButton1Down:Connect(function()
                if not anyFocusedWindow or not (focusedWindow == thisWidget) then
                    Iris.SetFocusedWindow(thisWidget)
                    -- mitigating wrong focus when clicking on buttons inside of a window without clicking the window itself
                end
                isResizing = true
                resizeFromTopBottom = Enum.TopBottom.Bottom
                resizeFromLeftRight = Enum.LeftRight.Right
                resizeWindow = thisWidget
            end)

            local ResizeBorder = Instance.new("TextButton")
            ResizeBorder.Name = "ResizeBorder"
            ResizeBorder.BackgroundTransparency = 1
            ResizeBorder.BorderSizePixel = 0
            ResizeBorder.ZIndex = thisWidget.ZIndex
            ResizeBorder.LayoutOrder = thisWidget.ZIndex
            ResizeBorder.Size = UDim2.new(1, Iris._config.WindowResizePadding.X * 2, 1, Iris._config.WindowResizePadding.Y * 2)
            ResizeBorder.Position = UDim2.fromOffset(-Iris._config.WindowResizePadding.X, -Iris._config.WindowResizePadding.Y)
            WindowButton.AutomaticSize = Enum.AutomaticSize.None
            ResizeBorder.ClipsDescendants = false
            ResizeBorder.Text = ""
            ResizeBorder.AutoButtonColor = false
            ResizeBorder.Active = true
            ResizeBorder.Selectable = false
            ResizeBorder.Parent = WindowButton

            ResizeBorder.MouseEnter:Connect(function()
                if focusedWindow == thisWidget then
                    isInsideResize = true
                end
            end)
            ResizeBorder.MouseLeave:Connect(function()
                if focusedWindow == thisWidget then
                    isInsideResize = false
                end
            end)

            WindowButton.MouseEnter:Connect(function()
                if focusedWindow == thisWidget then
                    isInsideWindow = true
                end
            end)
            WindowButton.MouseLeave:Connect(function()
                if focusedWindow == thisWidget then
                    isInsideWindow = false
                end
            end)

            ResizeGrip.Parent = WindowButton

            return Window
        end,
        Update = function(thisWidget)
            local WindowButton = thisWidget.Instance.WindowButton
            local TitleBar = WindowButton.TitleBar
            local Title = TitleBar.Title
            local ChildContainer = WindowButton.ChildContainer
            local ResizeGrip = WindowButton.ResizeGrip
            local TitleBarWidth = Iris._config.TextSize + Iris._config.FramePadding.Y * 2

            if thisWidget.arguments.NoResize then
                ResizeGrip.Visible = true
            else
                ResizeGrip.Visible = false
            end
            if thisWidget.arguments.NoScrollbar then
                ChildContainer.ScrollBarThickness = 0
            else
                ChildContainer.ScrollBarThickness = Iris._config.ScrollbarSize
            end
            if thisWidget.arguments.NoTitleBar then
                TitleBar.Visible = false
                ChildContainer.Size = UDim2.new(1, 0, 1, 0)
                ChildContainer.CanvasSize = UDim2.new(0, 0, 1, 0)
                ChildContainer.Position = UDim2.fromOffset(0, 0)
            else
                TitleBar.Visible = true
                ChildContainer.Size = UDim2.new(1, 0, 1, -TitleBarWidth)
                ChildContainer.CanvasSize = UDim2.new(0, 0, 1, -TitleBarWidth)
                ChildContainer.Position = UDim2.fromOffset(0, TitleBarWidth)
            end
            if thisWidget.arguments.NoBackground then
                ChildContainer.BackgroundTransparency = 1
            else
                ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
            end
            local TitleButtonPaddingSize = Iris._config.FramePadding.X + Iris._config.TextSize + Iris._config.FramePadding.X * 2
            if thisWidget.arguments.NoCollapse then
                TitleBar.CollapseArrow.Visible = false
                TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, Iris._config.FramePadding.X)
            else
                TitleBar.CollapseArrow.Visible = true
                TitleBar.Title.UIPadding.PaddingLeft = UDim.new(0, TitleButtonPaddingSize)
            end
            if thisWidget.arguments.NoClose then
                TitleBar.CloseIcon.Visible = false
                TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, Iris._config.FramePadding.X)
            else
                TitleBar.CloseIcon.Visible = true
                TitleBar.Title.UIPadding.PaddingRight = UDim.new(0, TitleButtonPaddingSize)
            end

            Title.Text = thisWidget.arguments.Title or ""
        end,
        Discard = function(thisWidget)
            if focusedWindow == thisWidget then
                focusedWindow = nil
                anyFocusedWindow = false
            end
            if dragWindow == thisWidget then
                dragWindow = nil
                isDragging = false
            end
            if resizeWindow == thisWidget then
                resizeWindow = nil
                isResizing = false
            end
            windowWidgets[thisWidget.ID] = nil
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        ChildAdded = function(thisWidget)
            return thisWidget.Instance.WindowButton.ChildContainer
        end,
        UpdateState = function(thisWidget)
            local stateSize = thisWidget.state.size.value
            local statePosition = thisWidget.state.position.value
            local stateIsUncollapsed = thisWidget.state.isUncollapsed.value
            local stateIsOpened = thisWidget.state.isOpened.value
            local stateScrollDistance = thisWidget.state.scrollDistance.value

            local WindowButton = thisWidget.Instance.WindowButton

            WindowButton.Size = UDim2.fromOffset(stateSize.X, stateSize.Y)
            WindowButton.Position = UDim2.fromOffset(statePosition.X, statePosition.Y)

            local TitleBar = WindowButton.TitleBar
            local ChildContainer = WindowButton.ChildContainer
            local ResizeGrip = WindowButton.ResizeGrip

            if stateIsOpened then
                if thisWidget.usesScreenGUI then
                    thisWidget.Instance.Enabled = true
                    WindowButton.Visible = true
                else
                    WindowButton.Visible = true
                end
                thisWidget.lastOpenedTick = Iris._cycleTick + 1
            else
                if thisWidget.usesScreenGUI then
                    thisWidget.Instance.Enabled = false
                    WindowButton.Visible = false
                else
                    WindowButton.Visible = false
                end
                thisWidget.lastClosedTick = Iris._cycleTick + 1
            end

            if stateIsUncollapsed then
                TitleBar.CollapseArrow.Text = widgets.ICONS.DOWN_POINTING_TRIANGLE
                ChildContainer.Visible = true
                if thisWidget.arguments.NoResize ~= true then
                    ResizeGrip.Visible = true
                end
                WindowButton.AutomaticSize = Enum.AutomaticSize.None
                thisWidget.lastUncollapsedTick = Iris._cycleTick + 1
            else
                local collapsedHeight = Iris._config.TextSize + Iris._config.FramePadding.Y * 2
                TitleBar.CollapseArrow.Text = widgets.ICONS.RIGHT_POINTING_TRIANGLE

                ChildContainer.Visible = false
                ResizeGrip.Visible = false
                WindowButton.Size = UDim2.fromOffset(stateSize.X, collapsedHeight)
                thisWidget.lastCollapsedTick = Iris._cycleTick + 1
            end

            if stateIsOpened and stateIsUncollapsed then
                Iris.SetFocusedWindow(thisWidget)
            else
                TitleBar.BackgroundColor3 = Iris._config.TitleBgCollapsedColor
                TitleBar.BackgroundTransparency = Iris._config.TitleBgCollapsedTransparency
                WindowButton.UIStroke.Color = Iris._config.BorderColor

                Iris.SetFocusedWindow(nil)
            end

            -- cant update canvasPosition in this cycle because scrollingframe isint ready to be changed
            if stateScrollDistance and stateScrollDistance ~= 0 then
                local callbackIndex = #Iris._postCycleCallbacks + 1
                local desiredCycleTick = Iris._cycleTick + 1
                Iris._postCycleCallbacks[callbackIndex] = function()
                    if Iris._cycleTick == desiredCycleTick then
                        ChildContainer.CanvasPosition = Vector2.new(0, stateScrollDistance)
                        Iris._postCycleCallbacks[callbackIndex] = nil
                    end
                end
            end
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.size == nil then
                thisWidget.state.size = Iris._widgetState(thisWidget, "size", Vector2.new(400, 300))
            end
            if thisWidget.state.position == nil then
                thisWidget.state.position = Iris._widgetState(
                    thisWidget,
                    "position",
                     anyFocusedWindow and focusedWindow.state.position.value + Vector2.new(15, 45) or Vector2.new(150, 250)
                )
            end
            thisWidget.state.position.value = fitPositionToWindowBounds(thisWidget, thisWidget.state.position.value)
            thisWidget.state.size.value = fitSizeToWindowBounds(thisWidget, thisWidget.state.size.value)

            if thisWidget.state.isUncollapsed == nil then
                thisWidget.state.isUncollapsed = Iris._widgetState(thisWidget, "isUncollapsed", true)
            end
            if thisWidget.state.isOpened == nil then
                thisWidget.state.isOpened = Iris._widgetState(thisWidget, "isOpened", true)
            end
            if thisWidget.state.scrollDistance == nil then
                thisWidget.state.scrollDistance = Iris._widgetState(thisWidget, "scrollDistance", 0)
            end
        end
    })
end
end)
__bundle_register("widgets/Table", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    local tableWidgets = {}

    table.insert(Iris._postCycleCallbacks, function()
        for _, v in next, tableWidgets do
            v.RowColumnIndex = 0
        end
    end)

    Iris.NextColumn = function()
        Iris._GetParentWidget().RowColumnIndex = Iris._GetParentWidget().RowColumnIndex + 1
    end
    Iris.SetColumnIndex = function(ColumnIndex)
        local ParentWidget = Iris._GetParentWidget()
        assert(ColumnIndex >= ParentWidget.InitialNumColumns, "Iris.SetColumnIndex Argument must be in column range")
        ParentWidget.RowColumnIndex = math.floor(ParentWidget.RowColumnIndex / ParentWidget.InitialNumColumns) + (ColumnIndex - 1)
    end
    Iris.NextRow = function()
        -- sets column Index back to 0, increments Row
        local ParentWidget = Iris._GetParentWidget()
        local InitialNumColumns = ParentWidget.InitialNumColumns
        local nextRow = math.floor((ParentWidget.RowColumnIndex + 1) / InitialNumColumns) * InitialNumColumns
        ParentWidget.RowColumnIndex = nextRow
    end

    Iris.WidgetConstructor("Table", {
        hasState = false,
        hasChildren = true,
        Args = {
            ["NumColumns"] = 1,
            ["RowBg"] = 2,
            ["BordersOuter"] = 3,
            ["BordersInner"] = 4
        },
        Events = {
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            tableWidgets[thisWidget.ID] = thisWidget

            thisWidget.InitialNumColumns = -1
            thisWidget.RowColumnIndex = 0
            -- reference to these is stored as an optimization
            thisWidget.ColumnInstances = {}
            thisWidget.CellInstances = {}

            local Table = Instance.new("Frame")
            Table.Name = "Iris_Table"
            Table.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, 0))
            Table.BackgroundTransparency = 1
            Table.BorderSizePixel = 0
            Table.ZIndex = thisWidget.ZIndex + 1024 -- allocate room for 1024 cells, because Table UIStroke has to appear above cell UIStroke
            Table.LayoutOrder = thisWidget.ZIndex
            Table.AutomaticSize = Enum.AutomaticSize.Y
            Table.ClipsDescendants = true

            widgets.UIListLayout(Table, Enum.FillDirection.Horizontal, UDim.new(0, 0))

            widgets.UIStroke(Table, 1, Iris._config.TableBorderStrongColor, Iris._config.TableBorderStrongTransparency)


            return Table
        end,
        Update = function(thisWidget)
            local thisWidgetInstance = thisWidget.Instance
            local ColumnInstances = thisWidget.ColumnInstances

            if thisWidget.arguments.BordersOuter == false then
                thisWidgetInstance.UIStroke.Thickness = 0
            else
                thisWidget.Instance.UIStroke.Thickness = 1
            end

            if thisWidget.InitialNumColumns == -1 then
                if thisWidget.arguments.NumColumns == nil then
                    error("Iris.Table NumColumns argument is required", 5)
                end
                thisWidget.InitialNumColumns = thisWidget.arguments.NumColumns

                for i = 1, thisWidget.InitialNumColumns do
                    local column = Instance.new("Frame")
                    column.Name = ("Column_%s"):format(tostring(i))
                    column.BackgroundTransparency = 1
                    column.BorderSizePixel = 0
                    local ColumnZIndex = thisWidget.ZIndex + 1 + i
                    column.ZIndex = ColumnZIndex
                    column.LayoutOrder = ColumnZIndex
                    column.AutomaticSize = Enum.AutomaticSize.Y
                    column.Size = UDim2.new(1 / thisWidget.InitialNumColumns, 0, 0, 0)
                    --column.ClipsDescendants = true

                    widgets.UIListLayout(column, Enum.FillDirection.Vertical, UDim.new(0, 0))

                    ColumnInstances[i] = column
                    column.Parent = thisWidgetInstance
                end

            elseif thisWidget.arguments.NumColumns ~= thisWidget.InitialNumColumns then
                -- its possible to make it so that the NumColumns can increase,
                -- but decreasing it would interfere with child widget instances
                error("Iris.Table NumColumns Argument must be static")
            end

            if thisWidget.arguments.RowBg == false then
                for _,v in next, thisWidget.CellInstances do
                    v.BackgroundTransparency = 1
                end
            else
                for rowColumnIndex, v in next, thisWidget.CellInstances do
                    local currentRow = math.ceil((rowColumnIndex) / thisWidget.InitialNumColumns)
                    v.BackgroundTransparency =  currentRow % 2 == 0 and Iris._config.TableRowBgAltTransparency or Iris._config.TableRowBgTransparency
                end
            end

            if thisWidget.arguments.BordersInner == false then
                for _,v in next, thisWidget.CellInstances do
                    v.UIStroke.Thickness = 0
                end
            else
                for _,v in next, thisWidget.CellInstances do
                    v.UIStroke.Thickness = 0.5
                end
            end
        end,
        Discard = function(thisWidget)
            tableWidgets[thisWidget.ID] = nil
            thisWidget.Instance:Destroy()
        end,
        ChildAdded = function(thisWidget)
            if thisWidget.RowColumnIndex == 0 then
                thisWidget.RowColumnIndex = 1
            end
            local potentialCellParent = thisWidget.CellInstances[thisWidget.RowColumnIndex]
            if potentialCellParent then
                return potentialCellParent
            end
            local cell = Instance.new("Frame")
            cell.AutomaticSize = Enum.AutomaticSize.Y
            cell.Size = UDim2.new(1, 0, 0, 0)
            cell.BackgroundTransparency = 1
            cell.BorderSizePixel = 0
            widgets.UIPadding(cell, Iris._config.CellPadding)
            local selectedParent = thisWidget.ColumnInstances[((thisWidget.RowColumnIndex - 1) % thisWidget.InitialNumColumns) + 1]
            local newZIndex = selectedParent.ZIndex + thisWidget.RowColumnIndex
            cell.ZIndex = newZIndex
            cell.LayoutOrder = newZIndex
            cell.Name = ("Column_%s"):format(tostring(thisWidget.RowColumnIndex))
            -- cell.Name = `Cell_{thisWidget.RowColumnIndex}`

            widgets.UIListLayout(cell, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

            if thisWidget.arguments.BordersInner == false then
                widgets.UIStroke(cell, 0, Iris._config.TableBorderLightColor, Iris._config.TableBorderLightTransparency)
            else
                widgets.UIStroke(cell, 0.5, Iris._config.TableBorderLightColor, Iris._config.TableBorderLightTransparency)
                -- this takes advantage of unintended behavior when UIStroke is set to 0.5 to render cell borders,
                -- at 0.5, only the top and left side of the cell will be rendered with a border.
            end

            if thisWidget.arguments.RowBg ~= false then
                local currentRow = math.ceil((thisWidget.RowColumnIndex) / thisWidget.InitialNumColumns)
                local color =  currentRow % 2 == 0 and Iris._config.TableRowBgAltColor or Iris._config.TableRowBgColor
                local transparency =  currentRow % 2 == 0 and Iris._config.TableRowBgAltTransparency or Iris._config.TableRowBgTransparency

                cell.BackgroundColor3 = color
                cell.BackgroundTransparency = transparency
            end

            thisWidget.CellInstances[thisWidget.RowColumnIndex] = cell
            cell.Parent = selectedParent
            return cell
        end
    })
end
end)
__bundle_register("widgets/Combo", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    local function onSelectionChange(thisWidget)
        if type(thisWidget.state.index.value) == "boolean" then
            thisWidget.state.index:set(not thisWidget.state.index.value)
        else
            thisWidget.state.index:set(thisWidget.arguments.Index)
        end
    end

    Iris.WidgetConstructor("Selectable", {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["Index"] = 2,
            ["NoClick"] = 3
        },
        Events = {
            ["selected"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastSelectedTick == Iris._cycleTick
                end
            },
            ["unselected"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastUnselected == Iris._cycleTick
                end            
            },
            ["active"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.state.index.value == thisWidget.arguments.Index
                end
            },
            ["clicked"] = widgets.EVENTS.click(function(thisWidget)
                return thisWidget.Instance.SelectableButton
            end),
            ["rightClicked"] = widgets.EVENTS.rightClick(function(thisWidget)
                return thisWidget.Instance.SelectableButton
            end),
            ["doubleClicked"] = widgets.EVENTS.doubleClick(function(thisWidget)
                return thisWidget.Instance.SelectableButton
            end),
            ["ctrlClicked"] = widgets.EVENTS.ctrlClick(function(thisWidget)
                return thisWidget.Instance.SelectableButton
            end),
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance.SelectableButton
            end)
        },
        Generate = function(thisWidget)
            local Selectable = Instance.new("Frame")
            Selectable.Name = "Iris_Selectable"
            Selectable.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, Iris._config.TextSize))
            Selectable.BackgroundTransparency = 1
            Selectable.BorderSizePixel = 0
            Selectable.ZIndex = thisWidget.ZIndex
            Selectable.LayoutOrder = thisWidget.ZIndex
            Selectable.AutomaticSize = Enum.AutomaticSize.None

            local SelectableButton = Instance.new("TextButton")
            SelectableButton.Name = "SelectableButton"
            SelectableButton.Size = UDim2.new(1, 0, 1, Iris._config.ItemSpacing.Y - 1)
            SelectableButton.Position = UDim2.fromOffset(0, -bit32.rshift(Iris._config.ItemSpacing.Y, 1))
            SelectableButton.ZIndex = thisWidget.ZIndex + 1
            SelectableButton.LayoutOrder = thisWidget.ZIndex + 1
            SelectableButton.BackgroundColor3 = Iris._config.HeaderColor
            widgets.applyFrameStyle(SelectableButton)
            widgets.applyTextStyle(SelectableButton)

            thisWidget.ButtonColors = {
                ButtonColor = Iris._config.HeaderColor,
                ButtonTransparency = 1,
                ButtonHoveredColor = Iris._config.HeaderHoveredColor,
                ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
                ButtonActiveColor = Iris._config.HeaderActiveColor,
                ButtonActiveTransparency = Iris._config.HeaderActiveTransparency,
            }

            SelectableButton.MouseButton1Down:Connect(function()
                if thisWidget.arguments.NoClick ~= true then
                    onSelectionChange(thisWidget)
                end
            end)

            widgets.applyInteractionHighlights(SelectableButton, SelectableButton, thisWidget.ButtonColors)

            SelectableButton.Parent = Selectable
    
            return Selectable
        end,
        Update = function(thisWidget)
            local SelectableButton = thisWidget.Instance.SelectableButton
            SelectableButton.Text = thisWidget.arguments.Text or "Selectable"
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.index == nil then
                if thisWidget.arguments.Index ~= nil then
                    error("a shared state index is required for Selectables with an Index argument", 5)
                end
                thisWidget.state.index = Iris._widgetState(thisWidget, "index", false)
            end
        end,
        UpdateState = function(thisWidget)
            local SelectableButton = thisWidget.Instance.SelectableButton
            if thisWidget.state.index.value == (thisWidget.arguments.Index or true) then
                thisWidget.ButtonColors.ButtonTransparency = Iris._config.HeaderTransparency
                SelectableButton.BackgroundTransparency = Iris._config.HeaderTransparency
                thisWidget.lastSelectedTick = Iris._cycleTick + 1
            else
                thisWidget.ButtonColors.ButtonTransparency = 1
                SelectableButton.BackgroundTransparency = 1
                thisWidget.lastUnselectedTick = Iris._cycleTick + 1
            end
        end
    })

    local AnyOpenedCombo = false
    local ComboOpenedTick = -1
    local OpenedCombo

    local function UpdateChildContainerTransform(thisWidget)
        local Iris_Combo = thisWidget.Instance
        local PreviewContainer = Iris_Combo.PreviewContainer
        local PreviewLabel = PreviewContainer.PreviewLabel
        local ChildContainer = thisWidget.ChildContainer

        local ChildContainerBorderSize = Iris._config.PopupBorderSize
        local ChildContainerHeight = thisWidget.LabelHeight * math.min(thisWidget.NumChildrenForSize, 8) - 2 * ChildContainerBorderSize
        local ChildContainerWidth = UDim.new(0, PreviewContainer.AbsoluteSize.X - 2 * ChildContainerBorderSize)
        ChildContainer.Size = UDim2.new(ChildContainerWidth, UDim.new(0, ChildContainerHeight))

        local ScreenSize = ChildContainer.Parent.AbsoluteSize

        if PreviewLabel.AbsolutePosition.Y + thisWidget.LabelHeight + ChildContainerHeight > ScreenSize.Y then
            -- too large to fit below the Combo, so is placed above
            ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + ChildContainerBorderSize, 0, PreviewLabel.AbsolutePosition.Y - ChildContainerBorderSize - ChildContainerHeight)
        else
            ChildContainer.Position = UDim2.new(0, PreviewLabel.AbsolutePosition.X + ChildContainerBorderSize, 0, PreviewLabel.AbsolutePosition.Y + thisWidget.LabelHeight + ChildContainerBorderSize)
        end
    end

    widgets.UserInputService.InputBegan:Connect(function(inputObject)
        if inputObject.UserInputType ~= Enum.UserInputType.MouseButton1 and inputObject.UserInputType ~= Enum.UserInputType.MouseButton2 and inputObject.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if AnyOpenedCombo == false then
            return
        end
        if ComboOpenedTick == Iris._cycleTick then
            return
        end
        local MouseLocation = widgets.UserInputService:GetMouseLocation() - Vector2.new(0, 36)
        local ChildContainer = OpenedCombo.ChildContainer
        local rectMin = ChildContainer.AbsolutePosition - Vector2.new(0, OpenedCombo.LabelHeight)
        local rectMax = ChildContainer.AbsolutePosition + ChildContainer.AbsoluteSize
        if not widgets.isPosInsideRect(MouseLocation, rectMin, rectMax) then
            OpenedCombo.state.isOpened:set(false)
        end
    end)
    
    Iris.WidgetConstructor("Combo", {
        hasState = true,
        hasChildren = true,
        Args = {
            ["Text"] = 1,
            ["NoButton"] = 2,
            ["NoPreview"] = 3,
        },
        Events = {
            ["clicked"] = widgets.EVENTS.click(function(thisWidget)
                return thisWidget.Instance
            end),
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end),
            ["opened"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastOpenedTick == Iris._cycleTick
                end
            },
            ["closed"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastClosedTick == Iris._cycleTick
                end
            }
        },
        Generate = function(thisWidget)
            thisWidget.ContentWidth = Iris._config.ContentWidth
            thisWidget.LabelHeight = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
            thisWidget.NumChildrenForSize = 0

            local Combo = Instance.new("Frame")
            Combo.Name = "Iris_Combo"
            Combo.Size = UDim2.fromScale(1, 0)
            Combo.AutomaticSize = Enum.AutomaticSize.Y
            Combo.BackgroundTransparency = 1
            Combo.BorderSizePixel = 0
            Combo.ZIndex = thisWidget.ZIndex
            Combo.LayoutOrder = thisWidget.ZIndex
            widgets.UIListLayout(Combo, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.Y))

            local PreviewContainer = Instance.new("TextButton")
            PreviewContainer.Name = "PreviewContainer"
            PreviewContainer.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
            PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y
            widgets.applyFrameStyle(PreviewContainer, true, true)
            PreviewContainer.BackgroundTransparency = 1
            PreviewContainer.ZIndex = thisWidget.ZIndex + 2
            PreviewContainer.LayoutOrder = thisWidget.ZIndex + 2
			PreviewContainer.Text = ""
            PreviewContainer.AutoButtonColor = false
            widgets.UIListLayout(PreviewContainer, Enum.FillDirection.Horizontal, UDim.new(0, 0))

            PreviewContainer.Parent = Combo

            local PreviewLabel = Instance.new("TextLabel")
            PreviewLabel.Name = "PreviewLabel"
            PreviewLabel.Size = UDim2.new(1, 0, 0, 0)
            PreviewLabel.BackgroundColor3 = Iris._config.FrameBgColor
            PreviewLabel.BackgroundTransparency = Iris._config.FrameBgTransparency
            PreviewLabel.BorderSizePixel = 0
            PreviewLabel.ZIndex = thisWidget.ZIndex + 3
            PreviewLabel.LayoutOrder = thisWidget.ZIndex + 3
            PreviewLabel.AutomaticSize = Enum.AutomaticSize.Y
            widgets.applyTextStyle(PreviewLabel)
            widgets.UIPadding(PreviewLabel, Iris._config.FramePadding)

            PreviewLabel.Parent = PreviewContainer

            local DropdownButtonSize = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
            local DropdownButton = Instance.new("TextLabel")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(0, DropdownButtonSize, 0, DropdownButtonSize)
            DropdownButton.BackgroundColor3 = Iris._config.ButtonColor
            DropdownButton.BackgroundTransparency = Iris._config.ButtonTransparency
            DropdownButton.BorderSizePixel = 0
            DropdownButton.ZIndex = thisWidget.ZIndex + 4
            DropdownButton.LayoutOrder = thisWidget.ZIndex + 4
            widgets.applyTextStyle(DropdownButton)
            DropdownButton.TextXAlignment = Enum.TextXAlignment.Center

            DropdownButton.Parent = PreviewContainer

            local textLabelHeight = Iris._config.TextSize + Iris._config.FramePadding.Y * 2

            -- for some reason ImGui Combo has no highlights for Active, only hovered.
            -- so this deviates from ImGui, but its a good UX change
            widgets.applyInteractionHighlightsWithMultiHighlightee(PreviewContainer, {
                {
                    PreviewLabel, {
                        ButtonColor = Iris._config.FrameBgColor,
                        ButtonTransparency = Iris._config.FrameBgTransparency,
                        ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                        ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                        ButtonActiveColor = Iris._config.FrameBgActiveColor,
                        ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
                    }
                },
                {
                    DropdownButton, {
                        ButtonColor = Iris._config.ButtonColor,
                        ButtonTransparency = Iris._config.ButtonTransparency,
                        ButtonHoveredColor = Iris._config.ButtonHoveredColor,
                        ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
                        -- Use hovered for active
                        ButtonActiveColor = Iris._config.ButtonHoveredColor,
                        ButtonActiveTransparency = Iris._config.ButtonHoveredColor,
                    }
                }
            })

            PreviewContainer.InputBegan:Connect(function(inputObject)
                if AnyOpenedCombo and OpenedCombo ~= thisWidget then
                    return
                end
                if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                    thisWidget.state.isOpened:set(not thisWidget.state.isOpened.value)
                end
            end)

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextLabel"
            TextLabel.Size = UDim2.fromOffset(0, textLabelHeight)
            TextLabel.BackgroundTransparency = 1
            TextLabel.BorderSizePixel = 0
            TextLabel.ZIndex = thisWidget.ZIndex + 5
            TextLabel.LayoutOrder = thisWidget.ZIndex + 5
            TextLabel.AutomaticSize = Enum.AutomaticSize.X
            widgets.applyTextStyle(TextLabel)

            TextLabel.Parent = Combo

            local ChildContainer = Instance.new("ScrollingFrame")
            ChildContainer.Name = "ChildContainer"
            ChildContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
            ChildContainer.ScrollBarImageTransparency = Iris._config.ScrollbarGrabTransparency
            ChildContainer.ScrollBarImageColor3 = Iris._config.ScrollbarGrabColor
            ChildContainer.ScrollBarThickness = Iris._config.ScrollbarSize
            ChildContainer.CanvasSize = UDim2.fromScale(0, 0)
            ChildContainer.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
            
            ChildContainer.BackgroundColor3 = Iris._config.WindowBgColor
            ChildContainer.BackgroundTransparency = Iris._config.WindowBgTransparency
            ChildContainer.BorderSizePixel = 0
            -- Unfortunatley, ScrollingFrame does not work with UICorner
            -- if Iris._config.PopupRounding > 0 then
            --     widgets.UICorner(ChildContainer, Iris._config.PopupRounding)
            -- end

            local uiStroke = Instance.new("UIStroke")
            uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            uiStroke.LineJoinMode = Enum.LineJoinMode.Round
            uiStroke.Thickness = Iris._config.WindowBorderSize
            uiStroke.Color = Iris._config.BorderColor
            uiStroke.Parent = ChildContainer
            widgets.UIPadding(ChildContainer, Vector2.new(2, Iris._config.WindowPadding.Y - Iris._config.ItemSpacing.Y))
            -- appear over everything else
            ChildContainer.ZIndex = thisWidget.ZIndex + 6
            ChildContainer.LayoutOrder = thisWidget.ZIndex + 6
			ChildContainer.ClipsDescendants = true

            local ChildContainerUIListLayout = widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
            ChildContainerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top

            local RootPopupScreenGui = Iris._rootInstance.PopupScreenGui
            ChildContainer.Parent = RootPopupScreenGui
            thisWidget.ChildContainer = ChildContainer

            return Combo
        end,
        Update = function(thisWidget)
            local Iris_Combo = thisWidget.Instance
            local PreviewContainer = Iris_Combo.PreviewContainer
            local PreviewLabel = PreviewContainer.PreviewLabel
            local DropdownButton = PreviewContainer.DropdownButton
            local TextLabel = Iris_Combo.TextLabel

            TextLabel.Text = thisWidget.arguments.Text or "Combo"
            
            if thisWidget.arguments.NoButton then
                DropdownButton.Visible = false
                PreviewLabel.Size = UDim2.new(1, 0, 0, 0)
            else
                DropdownButton.Visible = true
                local DropdownButtonSize = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
                PreviewLabel.Size = UDim2.new(1, - DropdownButtonSize, 0, 0)
            end

            if thisWidget.arguments.NoPreview then
                PreviewLabel.Visible = false
				PreviewContainer.Size = UDim2.new(0, 0, 0, 0)
				PreviewContainer.AutomaticSize = Enum.AutomaticSize.X
            else
                PreviewLabel.Visible = true
				PreviewContainer.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
				PreviewContainer.AutomaticSize = Enum.AutomaticSize.Y
            end
        end,
        ChildAdded = function(thisWidget, thisChild)
            -- default to largest size if there are widgets other than selectables inside the combo
            if thisChild.type ~= "Selectable" then
                thisWidget.NumChildrenForSize = thisWidget.NumChildrenForSize + 10
            else
                thisWidget.NumChildrenForSize = thisWidget.NumChildrenForSize + 1
            end
            UpdateChildContainerTransform(thisWidget)
            return thisWidget.ChildContainer
        end,
        ChildDiscarded = function(thisWidget, thisChild)
            if thisChild.type ~= "Selectable" then
                thisWidget.NumChildrenForSize = thisWidget.NumChildrenForSize - 10
            else
                thisWidget.NumChildrenForSize = thisWidget.NumChildrenForSize - 1
            end  
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.index == nil then
                thisWidget.state.index = Iris._widgetState(thisWidget, "index", "No Selection")
            end
            thisWidget.state.index:onChange(function()
                if thisWidget.state.isOpened.value then
                    thisWidget.state.isOpened:set(false)
                end
            end)
            if thisWidget.state.isOpened == nil then
                thisWidget.state.isOpened = Iris._widgetState(thisWidget, "isOpened", false)
            end
        end,
        UpdateState = function(thisWidget)
            local Iris_Combo = thisWidget.Instance
            local PreviewContainer = Iris_Combo.PreviewContainer
            local PreviewLabel = PreviewContainer.PreviewLabel
            local DropdownButton = PreviewContainer.DropdownButton
            local ChildContainer = thisWidget.ChildContainer

            if thisWidget.state.isOpened.value then
                AnyOpenedCombo = true
                OpenedCombo = thisWidget
                ComboOpenedTick = Iris._cycleTick
                thisWidget.lastOpenedTick = Iris._cycleTick + 1

                -- ImGui also does not do this, and the Arrow is always facing down
                DropdownButton.Text = widgets.ICONS.RIGHT_POINTING_TRIANGLE
                ChildContainer.Visible = true

                UpdateChildContainerTransform(thisWidget)
            else
                if AnyOpenedCombo then
                    AnyOpenedCombo = false
                    OpenedCombo = nil
                    thisWidget.lastClosedTick = Iris._cycleTick + 1
                end
                DropdownButton.Text = widgets.ICONS.DOWN_POINTING_TRIANGLE
                ChildContainer.Visible = false
            end

            local stateIndex = thisWidget.state.index.value
            PreviewLabel.Text =  (typeof(stateIndex) == "EnumItem") and stateIndex.Name or tostring(stateIndex)
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end
    })

    Iris.ComboArray = function(args, state, SelectionArray)
        local defaultState
        if state == nil then
            defaultState = Iris.State(SelectionArray[1])
        else
            defaultState = state
        end
        local thisWidget = Iris._Insert("Combo", args, defaultState)
        local sharedIndex = thisWidget.state.index
        for _, Selection in next, SelectionArray do
            Iris._Insert("Selectable", {Selection, Selection}, {index = sharedIndex})
        end
        Iris.End()

        return thisWidget
    end

    Iris.InputEnum = function(args, state, enumType)
        local defaultState
        if state == nil then
            defaultState = Iris.State(enumType[1])
        else
            defaultState = state
        end
        local thisWidget = Iris._Insert("Combo", args, defaultState)
        local sharedIndex = thisWidget.state.index
        for _, Selection in next, enumType:GetEnumItems() do
            Iris._Insert("Selectable", {Selection.Name, Selection}, {index = sharedIndex})
        end 
        Iris.End()

        return thisWidget
    end
end
end)
__bundle_register("widgets/Input", function(require, _LOADED, __bundle_register, __bundle_modules)
local UserInputService = game:GetService("UserInputService")
return function(Iris, widgets)

    local numberChanged = {
        ["Init"] = function(thisWidget)

        end,
        ["Get"] = function(thisWidget)
            return thisWidget.lastNumchangeTick == Iris._cycleTick
        end
    }

    local function GenerateRootFrame(thisWidget, name)
        local Frame = Instance.new("Frame")
        Frame.Name = name
        Frame.Size = UDim2.new(Iris._config.ContentWidth, UDim.new(0, 0))
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.ZIndex = thisWidget.ZIndex
        Frame.LayoutOrder = thisWidget.ZIndex
        Frame.AutomaticSize = Enum.AutomaticSize.Y
        widgets.UIListLayout(Frame, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.ItemInnerSpacing.X))

        return Frame
    end

    local function GenerateInputField(thisWidget)
        local InputField = Instance.new("TextBox")
        InputField.Name = "InputField"
        widgets.applyFrameStyle(InputField, true)
        widgets.applyTextStyle(InputField)
        InputField.ZIndex = thisWidget.ZIndex + 2
        InputField.LayoutOrder = thisWidget.ZIndex + 2
        InputField.Size = UDim2.new(1, 0, 1, 0)
        InputField.BackgroundTransparency = 1
        InputField.ClearTextOnFocus = false
        InputField.TextTruncate = Enum.TextTruncate.AtEnd
        InputField.Visible = false

        return InputField
    end

    local function GenerateTextLabel(thisWidget)
        local textLabelHeight = Iris._config.TextSize + Iris._config.FramePadding.Y * 2

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Name = "TextLabel"
        TextLabel.Size = UDim2.fromOffset(0, textLabelHeight)
        TextLabel.BackgroundTransparency = 1
        TextLabel.BorderSizePixel = 0
        TextLabel.ZIndex = thisWidget.ZIndex + 4
        TextLabel.LayoutOrder = thisWidget.ZIndex + 4
        TextLabel.AutomaticSize = Enum.AutomaticSize.X
        widgets.applyTextStyle(TextLabel)

        return TextLabel
    end

    local abstractInputVector3 = {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["Increment"] = 2,
            ["Min"] = 3,
            ["Max"] = 4,
            ["Format"] = 5,
        },
        Events = {
            ["numberChanged"] = numberChanged,
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function()
            
        end,
        Update = function(thisWidget)
            if thisWidget.arguments.Increment and typeof(thisWidget.arguments.Increment) ~= "Vector3" then
                error("Iris.InputVector2 'Increment' Argument must be a Vector3", 5)
            end
            if thisWidget.arguments.Min and typeof(thisWidget.arguments.Min) ~= "Vector3" then
                error("Iris.InputVector2 'Min' Argument must be a Vector3", 5)
            end
            if thisWidget.arguments.Max and typeof(thisWidget.arguments.Max) ~= "Vector3" then
                error("Iris.InputVector2 'Max' Argument must be a Vector3", 5)
            end
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input Vector3"
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.number == nil then
                local Min = thisWidget.arguments.Min or Vector3.zero
                local Max = thisWidget.arguments.Max or (Vector3.one * 100)
                thisWidget.state.number = Iris._widgetState(thisWidget, "number", Vector3.new(math.clamp(0, Min.X, Max.X), math.clamp(0, Min.Y, Max.Y), math.clamp(0, Min.Z, Max.Z)))
            end
        end,
        UpdateState = function(thisWidget)
            local InputFieldX = thisWidget.Instance.InputFieldX
            local InputFieldY = thisWidget.Instance.InputFieldY
            local InputFieldZ = thisWidget.Instance.InputFieldZ

            local newTextX = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.X or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value.X)
            local newTextY = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.Y or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value.Y)
            local newTextZ = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.Z or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value.Z)

            InputFieldX.Text = newTextX
            InputFieldY.Text = newTextY
            InputFieldZ.Text = newTextZ
        end
    }

    local abstractInputVector2 = {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["Increment"] = 2,
            ["Min"] = 3,
            ["Max"] = 4,
            ["Format"] = 5,
        },
        Events = {
            ["numberChanged"] = numberChanged,
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)

        end,
        Update = function(thisWidget)
            if thisWidget.arguments.Increment and typeof(thisWidget.arguments.Increment) ~= "Vector2" then
                error("Iris.InputVector2 'Increment' Argument must be a Vector2", 5)
            end
            if thisWidget.arguments.Min and typeof(thisWidget.arguments.Min) ~= "Vector2" then
                error("Iris.InputVector2 'Min' Argument must be a Vector2", 5)
            end
            if thisWidget.arguments.Max and typeof(thisWidget.arguments.Max) ~= "Vector2" then
                error("Iris.InputVector2 'Max' Argument must be a Vector2", 5)
            end
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input Vector2"
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.number == nil then
                local Min = thisWidget.arguments.Min or Vector2.zero
                local Max = thisWidget.arguments.Max or (Vector2.one * 100)
                thisWidget.state.number = Iris._widgetState(thisWidget, "number", Vector2.new(math.clamp(0, Min.X, Max.X), math.clamp(0, Min.Y, Max.Y)))
            end
        end,
        UpdateState = function(thisWidget)
            local InputFieldX = thisWidget.Instance.InputFieldX
            local InputFieldY = thisWidget.Instance.InputFieldY
            local newTextX = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.X or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value.X)
            local newTextY = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.Y or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value.Y)
            InputFieldX.Text = newTextX
            InputFieldY.Text = newTextY
        end
    }

    local abstractInputUDim = widgets.extend(abstractInputVector2, {
        Update = function(thisWidget)
            if thisWidget.arguments.Increment and typeof(thisWidget.arguments.Increment) ~= "UDim" then
                error("Iris.InputUDim 'Increment' Argument must be a UDim", 5)
            end
            if thisWidget.arguments.Min and typeof(thisWidget.arguments.Min) ~= "UDim" then
                error("Iris.InputUDim 'Min' Argument must be a UDim", 5)
            end
            if thisWidget.arguments.Max and typeof(thisWidget.arguments.Max) ~= "UDim" then
                error("Iris.InputUDim 'Max' Argument must be a UDim", 5)
            end
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input UDim"
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.number == nil then
                local Min = thisWidget.arguments.Min or UDim.new(0, 0)
                local Max = thisWidget.arguments.Max or UDim.new(1, 1920)
                thisWidget.state.number = Iris._widgetState(thisWidget, "number", UDim.new(math.clamp(0, Min.Scale, Max.Scale), math.clamp(0, Min.Offset, Max.Offset)))
            end
        end,
        UpdateState = function(thisWidget)
            local InputFieldScale = thisWidget.Instance.InputFieldScale
            local InputFieldOffset = thisWidget.Instance.InputFieldOffset
            local formatTextScale = thisWidget.arguments.Format or "%.3f"
            local formatTextOffset = thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.Offset or 1) >= 1 and "%d" or "%f")
            local newTextScale = string.format("Scale: " .. formatTextScale, thisWidget.state.number.value.Scale)
            local newTextOffset = string.format("Offset: " .. formatTextOffset, thisWidget.state.number.value.Offset)
            InputFieldScale.Text = newTextScale
            InputFieldOffset.Text = newTextOffset
        end
    })

    local abstractInputUDim2 = widgets.extend(abstractInputVector2, {
        Update = function(thisWidget)
            if thisWidget.arguments.Increment and typeof(thisWidget.arguments.Increment) ~= "UDim2" then
                error("Iris.InputUDim2 'Increment' Argument must be a UDim2", 5)
            end
            if thisWidget.arguments.Min and typeof(thisWidget.arguments.Min) ~= "UDim2" then
                error("Iris.InputUDim2 'Min' Argument must be a UDim2", 5)
            end
            if thisWidget.arguments.Max and typeof(thisWidget.arguments.Max) ~= "UDim2" then
                error("Iris.InputUDim2 'Max' Argument must be a UDim2", 5)
            end
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input UDim2"
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.number == nil then
                local Min = thisWidget.arguments.Min or UDim2.new(UDim.new(0, 0), UDim.new(0, 0))
                local Max = thisWidget.arguments.Max or UDim2.new(UDim.new(1, 1920), UDim.new(1, 1080))
                thisWidget.state.number = Iris._widgetState(
                    thisWidget,
                    "number",
                    UDim2.new(
                        UDim.new(math.clamp(0, Min.X.Scale, Max.X.Scale), math.clamp(0, Min.X.Offset, Max.X.Offset)),
                        UDim.new(math.clamp(0, Min.Y.Scale, Max.Y.Scale), math.clamp(0, Min.Y.Offset, Max.Y.Offset))
                    )
                )
            end
        end,
        UpdateState = function(thisWidget)
            local InputFieldXScale = thisWidget.Instance.InputFieldXScale
            local InputFieldXOffset = thisWidget.Instance.InputFieldXOffset
            local formatTextScale = thisWidget.arguments.Format or "%.3f"
            local formatTextOffset = thisWidget.arguments.Format or ((thisWidget.arguments.Increment and thisWidget.arguments.Increment.Offset or 1) >= 1 and "%d" or "%f")

            local newTextXScale = string.format("X Scale: " .. formatTextScale, thisWidget.state.number.value.X.Scale)
            local newTextXOffset = string.format("X Offset: " .. formatTextOffset, thisWidget.state.number.value.X.Offset)
            InputFieldXScale.Text = newTextXScale
            InputFieldXOffset.Text = newTextXOffset

            local InputFieldYScale = thisWidget.Instance.InputFieldYScale
            local InputFieldYOffset = thisWidget.Instance.InputFieldYOffset
            local newTextYScale = string.format("Y Scale: " .. formatTextScale, thisWidget.state.number.value.Y.Scale)
            local newTextYOffset = string.format("Y Offset: " .. formatTextOffset, thisWidget.state.number.value.Y.Offset)
            InputFieldYScale.Text = newTextYScale
            InputFieldYOffset.Text = newTextYOffset
        end
    })

    local abstractInputColor3 = {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["UseFloats"] = 2,
            ["UseHSV"] = 3,
            ["Format"] = 4,
        },
        Update = function(thisWidget)
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input Color3"

            -- dumb trick to call updateState only after initialization
            if thisWidget.state then
                thisWidget.state.color:set(thisWidget.state.color.value)
            end
        end,
        Events = {
            ["numberChanged"] = numberChanged,
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)

        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.color == nil then
                thisWidget.state.color = Iris._widgetState(thisWidget, "color", Color3.new())
            end
        end,
        UpdateState = function(thisWidget)
            local InputFieldR = thisWidget.Instance.InputFieldR
            local InputFieldG = thisWidget.Instance.InputFieldG
            local InputFieldB = thisWidget.Instance.InputFieldB
            local UseFloats = thisWidget.arguments.UseFloats
            local formatText = thisWidget.arguments.Format or (UseFloats and "%.3f" or "%d")
            local PrefixTable = {"R: ", "G: ", "B: ", "H: ", "S: ", "V: "}
            local HSVOffset =  thisWidget.arguments.UseHSV and 3 or 0
            local R, G, B
            if thisWidget.arguments.UseHSV then
                R, G, B = thisWidget.state.color.value:ToHSV()
            else
                R, G, B = thisWidget.state.color.value.R, thisWidget.state.color.value.G, thisWidget.state.color.value.B
            end
            local newTextR = string.format(PrefixTable[HSVOffset + 1] .. formatText, R * (UseFloats and 1 or 255))
            local newTextG = string.format(PrefixTable[HSVOffset + 2] .. formatText, G * (UseFloats and 1 or 255))
            local newTextB = string.format(PrefixTable[HSVOffset + 3] .. formatText, B * (UseFloats and 1 or 255))
            InputFieldR.Text = newTextR
            InputFieldG.Text = newTextG
            InputFieldB.Text = newTextB

            local PreviewColor = thisWidget.Instance.PreviewColorBox.PreviewColor
            PreviewColor.BackgroundColor3 = thisWidget.state.color.value
        end
    }

    local abstractInputColor4 = {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["UseFloats"] = 2,
            ["UseHSV"] = 3,
            ["Format"] = 4,
        },
        Update = function(thisWidget)
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input Color3"

            -- dumb trick to call updateState only after initialization
            if thisWidget.state then
                thisWidget.state.color:set(thisWidget.state.color.value)
            end
        end,
        Events = {
            ["numberChanged"] = numberChanged,
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)

        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.color == nil then
                thisWidget.state.color = Iris._widgetState(thisWidget, "color", Color3.new())
            end
            if thisWidget.state.transparency == nil then
                thisWidget.state.transparency = Iris._widgetState(thisWidget, "transparency", 0)
            end
        end,
        UpdateState = function(thisWidget)
            local InputFieldR = thisWidget.Instance.InputFieldR
            local InputFieldG = thisWidget.Instance.InputFieldG
            local InputFieldB = thisWidget.Instance.InputFieldB
            local InputFieldA = thisWidget.Instance.InputFieldA
            local UseFloats = thisWidget.arguments.UseFloats
            local formatText = thisWidget.arguments.Format or (UseFloats and "%.3f" or "%d")
            local PrefixTable = {"R: ", "G: ", "B: ", "A: ", "H: ", "S: ", "V: ", "A: "}
            local HSVOffset =  thisWidget.arguments.UseHSV and 4 or 0
            local R, G, B
            local A = thisWidget.state.transparency.value
            if thisWidget.arguments.UseHSV then
                R, G, B = thisWidget.state.color.value:ToHSV()
            else
                R, G, B = thisWidget.state.color.value.R, thisWidget.state.color.value.G, thisWidget.state.color.value.B
            end
            local newTextR = string.format(PrefixTable[HSVOffset + 1] .. formatText, R * (UseFloats and 1 or 255))
            local newTextG = string.format(PrefixTable[HSVOffset + 2] .. formatText, G * (UseFloats and 1 or 255))
            local newTextB = string.format(PrefixTable[HSVOffset + 3] .. formatText, B * (UseFloats and 1 or 255))
            local newTextA = string.format(PrefixTable[HSVOffset + 4] .. formatText, A * (UseFloats and 1 or 255))

            InputFieldR.Text = newTextR
            InputFieldG.Text = newTextG
            InputFieldB.Text = newTextB
            InputFieldA.Text = newTextA

            local PreviewColor = thisWidget.Instance.PreviewColorBox.PreviewColor
            PreviewColor.BackgroundColor3 = thisWidget.state.color.value
            PreviewColor.Transparency = A
        end
    }

    do -- Iris.DragNum
        local AnyActiveDragNum = false
        local LastMouseXPos = 0
        local ActiveDragNum
    
        widgets.UserInputService.InputEnded:Connect(function(inputObject)
            if inputObject.UserInputType == Enum.UserInputType.MouseButton1 and AnyActiveDragNum then
                AnyActiveDragNum = false
                ActiveDragNum = nil
            end
        end)
    
        local function updateActiveDrag()
            local currentMouseX = widgets.UserInputService:GetMouseLocation().X
            local mouseXDelta = currentMouseX - LastMouseXPos
            LastMouseXPos = currentMouseX
            if AnyActiveDragNum == false then
                return
            end
    
            local oldNum = ActiveDragNum.state.number.value
    
            local Min = ActiveDragNum.arguments.Min or -1e5
            local Max = ActiveDragNum.arguments.Max or 1e5
    
            local Increment = (ActiveDragNum.arguments.Increment or 1)
            Increment = Increment * (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)) and 10 or 1
            Increment = Increment * (widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightAlt)) and 0.1 or 1
    
            local newNum = math.clamp(oldNum + (mouseXDelta * Increment), Min, Max)
            ActiveDragNum.state.number:set(newNum)
        end
    
        local function InputFieldContainerOnClick(thisWidget, x, y)
            local currentTime = widgets.getTime()
            local isTimeValid = currentTime - thisWidget.lastClickedTime < Iris._config.MouseDoubleClickTime
            local isCtrlHeld = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
            if (isTimeValid and (Vector2.new(x, y) - thisWidget.lastClickedPosition).Magnitude < Iris._config.MouseDoubleClickMaxDist) or isCtrlHeld then
                thisWidget.state.editingText:set(true)
            else
                thisWidget.lastClickedTime = currentTime
                thisWidget.lastClickedPosition = Vector2.new(x, y)
    
                AnyActiveDragNum = true
                ActiveDragNum = thisWidget
                updateActiveDrag()
            end
        end
    
        widgets.UserInputService.InputChanged:Connect(updateActiveDrag)
    
        Iris.WidgetConstructor("DragNum", {
            hasState = true,
            hasChildren = false,
            Args = {
                ["Text"] = 1,
                ["Increment"] = 2,
                ["Min"] = 3,
                ["Max"] = 4,
                ["Format"] = 5,
            },
            Events = {
                ["numberChanged"] = numberChanged,
                ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                    return thisWidget.Instance
                end)
            },
            Generate = function(thisWidget)
                local DragNum = GenerateRootFrame(thisWidget, "Iris_DragNum")
    
                local InputFieldContainer = Instance.new("TextButton")
                InputFieldContainer.Name = "InputFieldContainer"
                widgets.applyFrameStyle(InputFieldContainer)
                widgets.applyTextStyle(InputFieldContainer)
                widgets.UISizeConstraint(InputFieldContainer, Vector2.new(1, 0))
                InputFieldContainer.TextXAlignment = Enum.TextXAlignment.Center
                InputFieldContainer.ZIndex = thisWidget.ZIndex + 1
                InputFieldContainer.LayoutOrder = thisWidget.ZIndex + 1
                InputFieldContainer.Size = UDim2.new(1, 0, 0, 0)
                InputFieldContainer.AutomaticSize = Enum.AutomaticSize.Y
                InputFieldContainer.AutoButtonColor = false
                InputFieldContainer.Text = ""
                InputFieldContainer.BackgroundColor3 = Iris._config.FrameBgColor
                InputFieldContainer.BackgroundTransparency = Iris._config.FrameBgTransparency
                InputFieldContainer.Parent = DragNum
                InputFieldContainer.ClipsDescendants = true
    
                widgets.applyInteractionHighlights(InputFieldContainer, InputFieldContainer, {
                    ButtonColor = Iris._config.FrameBgColor,
                    ButtonTransparency = Iris._config.FrameBgTransparency,
                    ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                    ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                    ButtonActiveColor = Iris._config.FrameBgActiveColor,
                    ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
                })
    
                local InputField = GenerateInputField(thisWidget)
                InputField.Parent = InputFieldContainer
    
                InputField.FocusLost:Connect(function()
                    local newValue = tonumber(InputField.Text:match("-?%d+%.?%d*"))
                    if newValue ~= nil then
                        newValue = math.clamp(newValue, thisWidget.arguments.Min or -math.huge, thisWidget.arguments.Max or math.huge)
                        if thisWidget.arguments.Increment then
                            newValue = math.floor(newValue / thisWidget.arguments.Increment) * thisWidget.arguments.Increment
                        end
                        thisWidget.state.number:set(newValue)
                        thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                    else
                        InputField.Text = thisWidget.state.number.value
                    end
    
                    thisWidget.state.editingText:set(false)
    
                    InputField:ReleaseFocus(true)
                    -- there is a very strange roblox UI bug where for some reason InputFieldContainer will stop sinking input unless this line is here
                    -- it only starts sinking input again once a different UI is interacted with
                end)
    
                InputField.Focused:Connect(function()
                    InputField.SelectionStart = 1
                end)
    
                thisWidget.lastClickedTime = -1
                thisWidget.lastClickedPosition = Vector2.zero
    
                InputFieldContainer.MouseButton1Down:Connect(function(x, y)
                    InputFieldContainerOnClick(thisWidget, x, y)
                end)
    
                local TextLabel = GenerateTextLabel(thisWidget)
                TextLabel.Parent = DragNum
    
                return DragNum
            end,
            Update = function(thisWidget)
                local TextLabel = thisWidget.Instance.TextLabel
                TextLabel.Text = thisWidget.arguments.Text or "Input Slider"
            end,
            Discard = function(thisWidget)
                thisWidget.Instance:Destroy()
                widgets.discardState(thisWidget)
            end,
            GenerateState = function(thisWidget)
                if thisWidget.state.number == nil then
                    local Min = thisWidget.arguments.Min or 0
                    local Max = thisWidget.arguments.Max or 100
                    thisWidget.state.number = Iris._widgetState(thisWidget, "number", math.clamp(0, Min, Max))
                end
                if thisWidget.state.editingText == nil then
                    thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
                end
            end,
            UpdateState = function(thisWidget)
                local InputFieldContainer = thisWidget.Instance.InputFieldContainer
                local InputField = InputFieldContainer.InputField
                local newText = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value)
                InputFieldContainer.Text = newText
                InputField.Text = tostring(thisWidget.state.number.value)
    
                if thisWidget.state.editingText.value then
                    InputField.Visible = true
                    InputField:CaptureFocus()
                    InputFieldContainer.TextTransparency = 1
                else
                    InputField.Visible = false
                    InputFieldContainer.TextTransparency = 0
                end
            end
        })
    end

    do -- Iris.SliderNum
        local AnyActiveSliderNum = false
        local ActiveSliderNum

        widgets.UserInputService.InputEnded:Connect(function(inputObject)
            if (inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch) and AnyActiveSliderNum then
                AnyActiveSliderNum = false
                ActiveSliderNum = nil
            end
        end)
        local function updateActiveSlider()
            if AnyActiveSliderNum == false then
                return
            end

            local InputFieldContainer = ActiveSliderNum.Instance.InputFieldContainer
            local GrabBar = InputFieldContainer.GrabBar

            local Increment = ActiveSliderNum.arguments.Increment or 1
            local Min = ActiveSliderNum.arguments.Min or 0
            local Max = ActiveSliderNum.arguments.Max or 100

            local GrabPadding = Iris._config.FramePadding.X
            local decimalFix = Increment < 1 and 0 or 1 -- ??? ?? ??? ?
            local GrabNumPossiblePositions = math.floor((decimalFix + Max - Min) / Increment)
            local PositionRatio = (widgets.UserInputService:GetMouseLocation().X - (InputFieldContainer.AbsolutePosition.X + GrabPadding)) / (InputFieldContainer.AbsoluteSize.X - 2 * GrabPadding)

            local NewNumber = math.clamp(math.floor(PositionRatio * GrabNumPossiblePositions) * Increment + Min, Min, Max)
            if ActiveSliderNum.state.number.value ~= NewNumber then
                ActiveSliderNum.state.number:set(NewNumber)
            end
        end
        widgets.UserInputService.InputChanged:Connect(updateActiveSlider)

        local function InputFieldContainerOnClick(thisWidget)
            local isCtrlHeld = widgets.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or widgets.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
            if isCtrlHeld then
                thisWidget.state.editingText:set(true)
            else
                AnyActiveSliderNum = true
                ActiveSliderNum = thisWidget
                updateActiveSlider()
            end
        end

        Iris.WidgetConstructor("SliderNum", {
            hasState = true,
            hasChildren = false,
            Args = {
                ["Text"] = 1,
                ["Increment"] = 2,
                ["Min"] = 3,
                ["Max"] = 4,
                ["Format"] = 5,
            },
            Events = {
                ["numberChanged"] = numberChanged,
                ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                    return thisWidget.Instance
                end)
            },
            Generate = function(thisWidget)
                local SliderNum = GenerateRootFrame(thisWidget, "Iris_SliderNum")

                local InputFieldContainer = Instance.new("TextButton")
                InputFieldContainer.Name = "InputFieldContainer"
                widgets.applyFrameStyle(InputFieldContainer)
                widgets.applyTextStyle(InputFieldContainer)
                widgets.UISizeConstraint(InputFieldContainer, Vector2.new(1, 0))
                InputFieldContainer.TextXAlignment = Enum.TextXAlignment.Center
                InputFieldContainer.ZIndex = thisWidget.ZIndex + 1
                InputFieldContainer.LayoutOrder = thisWidget.ZIndex + 1
                InputFieldContainer.Size = UDim2.new(1, 0, 0, 0)
                InputFieldContainer.AutomaticSize = Enum.AutomaticSize.Y
                InputFieldContainer.AutoButtonColor = false
                InputFieldContainer.Text = ""
                InputFieldContainer.BackgroundColor3 = Iris._config.FrameBgColor
                InputFieldContainer.BackgroundTransparency = Iris._config.FrameBgTransparency
                InputFieldContainer.Parent = SliderNum
                InputFieldContainer.ClipsDescendants = true

                local OverlayText = Instance.new("TextLabel")
                OverlayText.Name = "OverlayText"
                OverlayText.Size = UDim2.fromScale(1, 1)
                OverlayText.BackgroundTransparency = 1
                OverlayText.BorderSizePixel = 0
                OverlayText.ZIndex = thisWidget.ZIndex + 10
                widgets.applyTextStyle(OverlayText)
                OverlayText.TextXAlignment = Enum.TextXAlignment.Center
                OverlayText.Parent = InputFieldContainer
                OverlayText.ClipsDescendants = true

                widgets.applyInteractionHighlights(InputFieldContainer, InputFieldContainer, {
                    ButtonColor = Iris._config.FrameBgColor,
                    ButtonTransparency = Iris._config.FrameBgTransparency,
                    ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                    ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                    ButtonActiveColor = Iris._config.FrameBgActiveColor,
                    ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
                })

                local InputField = GenerateInputField(thisWidget)
                InputField.Parent = InputFieldContainer

                InputField.FocusLost:Connect(function()
                    local newValue = tonumber(InputField.Text:match("-?%d+%.?%d*"))
                    if newValue ~= nil then
                        newValue = math.clamp(newValue, thisWidget.arguments.Min or -math.huge, thisWidget.arguments.Max or math.huge)
                        if thisWidget.arguments.Increment then
                            newValue = math.floor(newValue / thisWidget.arguments.Increment) * thisWidget.arguments.Increment
                        end
                        thisWidget.state.number:set(newValue)
                        thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                    else
                        InputField.Text = thisWidget.state.number.value
                    end

                    thisWidget.state.editingText:set(false)

                    InputField:ReleaseFocus(true)
                    -- there is a very strange roblox UI bug where for some reason InputFieldContainer will stop sinking input unless this line is here
                    -- it only starts sinking input again once a different UI is interacted with
                end)

                InputField.Focused:Connect(function()
                    InputField.SelectionStart = 1
                end)

                InputFieldContainer.InputBegan:Connect(function(inputObject)
                    if inputObject.UserInputType == Enum.UserInputType.MouseButton1 or inputObject.UserInputType == Enum.UserInputType.Touch then
                        InputFieldContainerOnClick(thisWidget)
                    end
                end)

                local GrabBar = Instance.new("Frame")
                GrabBar.Name = "GrabBar"
                GrabBar.ZIndex = thisWidget.ZIndex + 3
                GrabBar.LayoutOrder = thisWidget.ZIndex + 3
                --GrabBar.Size = UDim2.new(0, 0, 1, 0)
                GrabBar.AnchorPoint = Vector2.new(0, 0.5)
                GrabBar.Position = UDim2.new(0, 0, 0.5, 0)
                GrabBar.BorderSizePixel = 0
                GrabBar.BackgroundColor3 = Iris._config.SliderGrabColor
                GrabBar.Transparency = Iris._config.SliderGrabTransparency
                if Iris._config.GrabRounding > 0 then
                    widgets.UICorner(GrabBar, Iris._config.GrabRounding)
                end
                GrabBar.Parent = InputFieldContainer

                local TextLabel = GenerateTextLabel(thisWidget)
                TextLabel.Parent = SliderNum

                return SliderNum
            end,
            Update = function(thisWidget)
                local TextLabel = thisWidget.Instance.TextLabel
                local InputFieldContainer = thisWidget.Instance.InputFieldContainer
                local GrabBar = InputFieldContainer.GrabBar
                TextLabel.Text = thisWidget.arguments.Text or "Input Slider"

                local Increment = thisWidget.arguments.Increment or 1
                local Min = thisWidget.arguments.Min or 0
                local Max = thisWidget.arguments.Max or 100

                local grabScaleSize = math.max(1 / math.floor((1 + Max - Min) / Increment), Iris._config.GrabMinSize / InputFieldContainer.AbsoluteSize.X)
                
                GrabBar.Size = UDim2.new(grabScaleSize, 0, 1, 0)
            end,
            Discard = function(thisWidget)
                thisWidget.Instance:Destroy()
                widgets.discardState(thisWidget)
            end,
            GenerateState = function(thisWidget)
                if thisWidget.state.number == nil then
                    local Min = thisWidget.arguments.Min or 0
                    local Max = thisWidget.arguments.Max or 100
                    thisWidget.state.number = Iris._widgetState(thisWidget, "number", math.clamp(0, Min, Max))
                end
                if thisWidget.state.editingText == nil then
                    thisWidget.state.editingText = Iris._widgetState(thisWidget, "editingText", false)
                end
            end,
            UpdateState = function(thisWidget)
                local InputFieldContainer = thisWidget.Instance.InputFieldContainer
                local GrabBar = InputFieldContainer.GrabBar
                local InputField = InputFieldContainer.InputField
                local newText = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value)
                local OverlayText = InputFieldContainer.OverlayText
                OverlayText.Text = newText
                InputField.Text = tostring(thisWidget.state.number.value)

                local Increment = thisWidget.arguments.Increment or 1
                local Min = thisWidget.arguments.Min or 0
                local Max = thisWidget.arguments.Max or 100
        
                local GrabPadding = Iris._config.FramePadding.X
                local decimalFix = Increment < 1 and 0 or 1 -- ??? ?? ??? ?
                local GrabNumPossiblePositions = math.floor((decimalFix + Max - Min) / Increment)
                local PositionRatio = (thisWidget.state.number.value - Min) / (Max - Min)
                local MaxScaleSize = 1 - (GrabBar.AbsoluteSize.X / (InputFieldContainer.AbsoluteSize.X - 2 * GrabPadding))
                local GrabBarPos = math.clamp(math.floor(PositionRatio * GrabNumPossiblePositions) / GrabNumPossiblePositions, 0, MaxScaleSize)
                GrabBar.Position = UDim2.new(GrabBarPos, 0, 0.5, 0)

                if thisWidget.state.editingText.value then
                    InputField.Visible = true
                    OverlayText.Visible = false
                    GrabBar.Visible = false
                    InputField:CaptureFocus()
                    InputFieldContainer.TextTransparency = 1
                else
                    InputField.Visible = false
                    OverlayText.Visible = true
                    GrabBar.Visible = true
                    InputFieldContainer.TextTransparency = 0
                end
            end
        })
    end

    Iris.WidgetConstructor("InputNum", {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["Increment"] = 2,
            ["Min"] = 3,
            ["Max"] = 4,
            ["Format"] = 5,
            ["NoButtons"] = 6,
            ["NoField"] = 7
        },
        Events = {
            ["numberChanged"] = numberChanged,
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            local InputNum = GenerateRootFrame(thisWidget, "Iris_InputNum")
    
            local inputButtonsWidth = Iris._config.TextSize
    
            local InputField = Instance.new("TextBox")
            InputField.Name = "InputField"
            widgets.applyFrameStyle(InputField)
            widgets.applyTextStyle(InputField)
			widgets.UISizeConstraint(InputField, Vector2.new(1, 0))
            InputField.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputField.ZIndex = thisWidget.ZIndex + 1
            InputField.LayoutOrder = thisWidget.ZIndex + 1
			InputField.Size = UDim2.new(1, 0, 0, 0)
            InputField.AutomaticSize = Enum.AutomaticSize.Y
            InputField.BackgroundColor3 = Iris._config.FrameBgColor
            InputField.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputField.ClearTextOnFocus = false
            InputField.TextTruncate = Enum.TextTruncate.AtEnd
            InputField.Parent = InputNum
			InputField.ClipsDescendants = true
    
            InputField.FocusLost:Connect(function()
                local newValue = tonumber(InputField.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(newValue, thisWidget.arguments.Min or -math.huge, thisWidget.arguments.Max or math.huge)
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment) * thisWidget.arguments.Increment
                    end
                    thisWidget.state.number:set(newValue)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    InputField.Text = thisWidget.state.number.value
                end
            end)
    
            InputField.Focused:Connect(function()
                InputField.SelectionStart = 1
            end)
    
            local SubButton = widgets.abstractButton.Generate(thisWidget)
            SubButton.Name = "SubButton"
            SubButton.ZIndex = thisWidget.ZIndex + 2
            SubButton.LayoutOrder = thisWidget.ZIndex + 2
            SubButton.TextXAlignment = Enum.TextXAlignment.Center
            SubButton.Text = "-"
            SubButton.Size = UDim2.fromOffset(inputButtonsWidth - 2, inputButtonsWidth)
            SubButton.Parent = InputNum
    
            SubButton.MouseButton1Click:Connect(function()
                local isCtrlHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                local changeValue = (thisWidget.arguments.Increment or 1) * (isCtrlHeld and 100 or 1)
                local newValue = thisWidget.state.number.value - changeValue
                newValue = math.clamp(newValue, thisWidget.arguments.Min or -math.huge, thisWidget.arguments.Max or math.huge)
                thisWidget.state.number:set(newValue)
                thisWidget.lastNumchangeTick = Iris._cycleTick + 1
            end)
    
            local AddButton = widgets.abstractButton.Generate(thisWidget)
            AddButton.Name = "AddButton"
            AddButton.ZIndex = thisWidget.ZIndex + 3
            AddButton.LayoutOrder = thisWidget.ZIndex + 3
            AddButton.TextXAlignment = Enum.TextXAlignment.Center
            AddButton.Text = "+"
            AddButton.Size = UDim2.fromOffset(inputButtonsWidth - 2, inputButtonsWidth)
            AddButton.Parent = InputNum
    
            AddButton.MouseButton1Click:Connect(function()
                local isCtrlHeld = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                local changeValue = (thisWidget.arguments.Increment or 1) * (isCtrlHeld and 100 or 1)
                local newValue = thisWidget.state.number.value + changeValue
                newValue = math.clamp(newValue, thisWidget.arguments.Min or -math.huge, thisWidget.arguments.Max or math.huge)
                thisWidget.state.number:set(newValue)
                thisWidget.lastNumchangeTick = Iris._cycleTick + 1
            end)
    
            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputNum
    
            return InputNum
        end,
        Update = function(thisWidget)
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input Num"
    
            thisWidget.Instance.SubButton.Visible = not thisWidget.arguments.NoButtons
            thisWidget.Instance.AddButton.Visible = not thisWidget.arguments.NoButtons
            local InputField = thisWidget.Instance.InputField
            InputField.Visible = not thisWidget.arguments.NoField
    
            local inputButtonsTotalWidth = Iris._config.TextSize * 2 + Iris._config.ItemInnerSpacing.X * 2 + Iris._config.WindowPadding.X + 4
            if thisWidget.arguments.NoButtons then
                InputField.Size = UDim2.new(1, 0, 0, 0)
            else
                InputField.Size = UDim2.new(1, -inputButtonsTotalWidth, 0, 0)
            end
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.number == nil then
                local Min = thisWidget.arguments.Min or 0
                local Max = thisWidget.arguments.Max or 100
                thisWidget.state.number = Iris._widgetState(thisWidget, "number", math.clamp(0, Min, Max))
            end
        end,
        UpdateState = function(thisWidget)
            local InputField = thisWidget.Instance.InputField
            InputField.Text = string.format(thisWidget.arguments.Format or ((thisWidget.arguments.Increment or 1) >= 1 and "%d" or "%f"), thisWidget.state.number.value)
        end
    })

    Iris.WidgetConstructor("InputVector2", widgets.extend(abstractInputVector2, {
        Generate = function(thisWidget)
            local InputNum = GenerateRootFrame(thisWidget, "Iris_InputVector2")

            local InputWidth = UDim.new(1 / 2, (- Iris._config.ItemInnerSpacing.X) / 2)
        
            local InputFieldX = Instance.new("TextBox")
            InputFieldX.Name = "InputFieldX"
            widgets.applyFrameStyle(InputFieldX)
            widgets.applyTextStyle(InputFieldX)
			widgets.UISizeConstraint(InputFieldX, Vector2.new(1, 0))
            InputFieldX.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldX.ZIndex = thisWidget.ZIndex + 1
            InputFieldX.LayoutOrder = thisWidget.ZIndex + 1
			InputFieldX.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldX.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldX.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldX.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldX.ClearTextOnFocus = false
            InputFieldX.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldX.ClipsDescendants = true
            InputFieldX.Parent = InputNum
    
            InputFieldX.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldX.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.X or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.X or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.X) * thisWidget.arguments.Increment.X
                    end
                    thisWidget.state.number:set(Vector2.new(newValue, thisWidget.state.number.value.Y))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    InputFieldX.Text = thisWidget.state.number.value.X
                end
            end)
    
            InputFieldX.Focused:Connect(function()
                InputFieldX.SelectionStart = 1
            end)

            local InputFieldY = Instance.new("TextBox")
            InputFieldY.Name = "InputFieldY"
            widgets.applyFrameStyle(InputFieldY)
            widgets.applyTextStyle(InputFieldY)
			widgets.UISizeConstraint(InputFieldY, Vector2.new(1, 0))
            InputFieldY.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldY.ZIndex = thisWidget.ZIndex + 2
            InputFieldY.LayoutOrder = thisWidget.ZIndex + 2
			InputFieldY.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldY.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldY.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldY.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldY.ClearTextOnFocus = false
            InputFieldY.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldY.ClipsDescendants = true
            InputFieldY.Parent = InputNum
    
            InputFieldY.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldY.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Y or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Y or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Y) * thisWidget.arguments.Increment.Y
                    end
                    thisWidget.state.number:set(Vector2.new(thisWidget.state.number.value.X, newValue))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    InputFieldY.Text = thisWidget.state.number.value.Y
                end
            end)
    
            InputFieldY.Focused:Connect(function()
                InputFieldY.SelectionStart = 1
            end)
    
            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputNum
    
            return InputNum
        end
    }))
    
    Iris.WidgetConstructor("InputVector3", widgets.extend(abstractInputVector3, {
        Generate = function(thisWidget)
            local InputNum = GenerateRootFrame(thisWidget, "Iris_InputVector3")

            local InputWidth = UDim.new(1 / 3, - math.round(Iris._config.ItemInnerSpacing.X * (2/3)))
        
            local InputFieldX = Instance.new("TextBox")
            InputFieldX.Name = "InputFieldX"
            widgets.applyFrameStyle(InputFieldX)
            widgets.applyTextStyle(InputFieldX)
			widgets.UISizeConstraint(InputFieldX, Vector2.new(1, 0))
            InputFieldX.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldX.ZIndex = thisWidget.ZIndex + 1
            InputFieldX.LayoutOrder = thisWidget.ZIndex + 1
			InputFieldX.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldX.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldX.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldX.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldX.ClearTextOnFocus = false
            InputFieldX.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldX.ClipsDescendants = true
            InputFieldX.Parent = InputNum
    
            InputFieldX.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldX.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.X or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.X or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.X) * thisWidget.arguments.Increment.X
                    end
                    thisWidget.state.number:set(Vector3.new(newValue, thisWidget.state.number.value.Y, thisWidget.state.number.value.Z))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    InputFieldX.Text = thisWidget.state.number.value.X
                end
            end)
    
            InputFieldX.Focused:Connect(function()
                InputFieldX.SelectionStart = 1
            end)

            local InputFieldY = Instance.new("TextBox")
            InputFieldY.Name = "InputFieldY"
            widgets.applyFrameStyle(InputFieldY)
            widgets.applyTextStyle(InputFieldY)
			widgets.UISizeConstraint(InputFieldY, Vector2.new(1, 0))
            InputFieldY.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldY.ZIndex = thisWidget.ZIndex + 2
            InputFieldY.LayoutOrder = thisWidget.ZIndex + 2
			InputFieldY.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldY.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldY.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldY.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldY.ClearTextOnFocus = false
            InputFieldY.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldY.ClipsDescendants = true
            InputFieldY.Parent = InputNum
    
            InputFieldY.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldY.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Y or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Y or math.huge
                    )                    
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Y) * thisWidget.arguments.Increment.Y
                    end
                    thisWidget.state.number:set(Vector3.new(thisWidget.state.number.value.X, newValue, thisWidget.state.number.value.Z))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    InputFieldY.Text = thisWidget.state.number.value.Y
                end
            end)
    
            InputFieldY.Focused:Connect(function()
                InputFieldY.SelectionStart = 1
            end)

            local InputFieldZ = Instance.new("TextBox")
            InputFieldZ.Name = "InputFieldZ"
            widgets.applyFrameStyle(InputFieldZ)
            widgets.applyTextStyle(InputFieldZ)
			widgets.UISizeConstraint(InputFieldZ, Vector2.new(1, 0))
            InputFieldZ.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldZ.ZIndex = thisWidget.ZIndex + 3
            InputFieldZ.LayoutOrder = thisWidget.ZIndex + 3
			InputFieldZ.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldZ.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldZ.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldZ.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldZ.ClearTextOnFocus = false
            InputFieldZ.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldZ.ClipsDescendants = true
            InputFieldZ.Parent = InputNum
    
            InputFieldZ.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldZ.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Z or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Z or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Z) * thisWidget.arguments.Increment.Z
                    end
                    thisWidget.state.number:set(Vector3.new(thisWidget.state.number.value.X, thisWidget.state.number.value.Y, newValue))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    InputFieldZ.Text = thisWidget.state.number.value.Z
                end
            end)
    
            InputFieldZ.Focused:Connect(function()
                InputFieldZ.SelectionStart = 1
            end)
    
            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputNum
    
            return InputNum
        end
    }))

    Iris.WidgetConstructor("InputUDim", widgets.extend(abstractInputUDim, {
        Generate = function(thisWidget)
            local InputUDim = GenerateRootFrame(thisWidget, "Iris_InputUDim")

            local InputWidth = UDim.new(1 / 2, (- Iris._config.ItemInnerSpacing.X) / 2)

            local InputFieldScale = Instance.new("TextBox")
            InputFieldScale.Name = "InputFieldScale"
            widgets.applyFrameStyle(InputFieldScale)
            widgets.applyTextStyle(InputFieldScale)
			widgets.UISizeConstraint(InputFieldScale, Vector2.new(1, 0))
            InputFieldScale.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldScale.ZIndex = thisWidget.ZIndex + 1
            InputFieldScale.LayoutOrder = thisWidget.ZIndex + 1
			InputFieldScale.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldScale.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldScale.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldScale.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldScale.ClearTextOnFocus = false
            InputFieldScale.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldScale.ClipsDescendants = true
            InputFieldScale.Parent = InputUDim
    
            InputFieldScale.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldScale.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Scale or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Scale or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Scale) * thisWidget.arguments.Increment.Scale
                    end
                    thisWidget.state.number:set(UDim.new(newValue, thisWidget.state.number.value.Offset))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.number:set(thisWidget.state.number.value)
                end
            end)
    
            InputFieldScale.Focused:Connect(function()
                InputFieldScale.SelectionStart = 1
            end)

            local InputFieldOffset = Instance.new("TextBox")
            InputFieldOffset.Name = "InputFieldOffset"
            widgets.applyFrameStyle(InputFieldOffset)
            widgets.applyTextStyle(InputFieldOffset)
			widgets.UISizeConstraint(InputFieldOffset, Vector2.new(1, 0))
            InputFieldOffset.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldOffset.ZIndex = thisWidget.ZIndex + 2
            InputFieldOffset.LayoutOrder = thisWidget.ZIndex + 2
			InputFieldOffset.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldOffset.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldOffset.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldOffset.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldOffset.ClearTextOnFocus = false
            InputFieldOffset.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldOffset.ClipsDescendants = true
            InputFieldOffset.Parent = InputUDim
    
            InputFieldOffset.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldOffset.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Offset or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Offset or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Offset) * thisWidget.arguments.Increment.Offset
                    end
                    thisWidget.state.number:set(UDim.new(thisWidget.state.number.value.Scale, newValue))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.number:set(thisWidget.state.number.value)
                end
            end)
    
            InputFieldOffset.Focused:Connect(function()
                InputFieldOffset.SelectionStart = 1
            end)
    
            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputUDim
    
            return InputUDim
        end
    }))

    Iris.WidgetConstructor("InputUDim2", widgets.extend(abstractInputUDim2, {
        Generate = function(thisWidget)
            local InputUDim2 = GenerateRootFrame(thisWidget, "Iris_InputUDim2")

            local InputWidth = UDim.new(1 / 4, - math.round(Iris._config.ItemInnerSpacing.X * (3/4)))

            local InputFieldXScale = Instance.new("TextBox")
            InputFieldXScale.Name = "InputFieldXScale"
            widgets.applyFrameStyle(InputFieldXScale)
            widgets.applyTextStyle(InputFieldXScale)
			widgets.UISizeConstraint(InputFieldXScale, Vector2.new(1, 0))
            InputFieldXScale.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldXScale.ZIndex = thisWidget.ZIndex + 1
            InputFieldXScale.LayoutOrder = thisWidget.ZIndex + 1
			InputFieldXScale.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldXScale.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldXScale.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldXScale.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldXScale.ClearTextOnFocus = false
            InputFieldXScale.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldXScale.ClipsDescendants = true
            InputFieldXScale.Parent = InputUDim2
    
            InputFieldXScale.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldXScale.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.X.Scale or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.X.Scale or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.X.Scale) * thisWidget.arguments.Increment.X.Scale
                    end
                    thisWidget.state.number:set(UDim2.new(UDim.new(newValue, thisWidget.state.number.value.X.Offset), thisWidget.state.number.value.Y))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.number:set(thisWidget.state.number.value)
                end
            end)
    
            InputFieldXScale.Focused:Connect(function()
                InputFieldXScale.SelectionStart = 1
            end)

            local InputFieldXOffset = Instance.new("TextBox")
            InputFieldXOffset.Name = "InputFieldXOffset"
            widgets.applyFrameStyle(InputFieldXOffset)
            widgets.applyTextStyle(InputFieldXOffset)
			widgets.UISizeConstraint(InputFieldXOffset, Vector2.new(1, 0))
            InputFieldXOffset.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldXOffset.ZIndex = thisWidget.ZIndex + 2
            InputFieldXOffset.LayoutOrder = thisWidget.ZIndex + 2
			InputFieldXOffset.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldXOffset.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldXOffset.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldXOffset.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldXOffset.ClearTextOnFocus = false
            InputFieldXOffset.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldXOffset.ClipsDescendants = true
            InputFieldXOffset.Parent = InputUDim2
    
            InputFieldXOffset.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldXOffset.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.X.Offset or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.X.Offset or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.X.Offset) * thisWidget.arguments.Increment.X.Offset
                    end
                    thisWidget.state.number:set(UDim2.new(UDim.new(thisWidget.state.number.value.X.Scale, newValue), thisWidget.state.number.value.Y))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.number:set(thisWidget.state.number.value)
                end
            end)
    
            InputFieldXOffset.Focused:Connect(function()
                InputFieldXOffset.SelectionStart = 1
            end)

            local InputFieldYScale = Instance.new("TextBox")
            InputFieldYScale.Name = "InputFieldYScale"
            widgets.applyFrameStyle(InputFieldYScale)
            widgets.applyTextStyle(InputFieldYScale)
			widgets.UISizeConstraint(InputFieldYScale, Vector2.new(1, 0))
            InputFieldYScale.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldYScale.ZIndex = thisWidget.ZIndex + 3
            InputFieldYScale.LayoutOrder = thisWidget.ZIndex + 3
			InputFieldYScale.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldYScale.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldYScale.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldYScale.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldYScale.ClearTextOnFocus = false
            InputFieldYScale.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldYScale.ClipsDescendants = true
            InputFieldYScale.Parent = InputUDim2
    
            InputFieldYScale.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldYScale.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Y.Scale or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Y.Scale or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Y.Scale) * thisWidget.arguments.Increment.Y.Scale
                    end
                    thisWidget.state.number:set(UDim2.new(thisWidget.state.number.value.X, UDim.new(newValue, thisWidget.state.number.value.Y.Offset)))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.number:set(thisWidget.state.number.value)
                end
            end)
    
            InputFieldYScale.Focused:Connect(function()
                InputFieldYScale.SelectionStart = 1
            end)

            local InputFieldYOffset = Instance.new("TextBox")
            InputFieldYOffset.Name = "InputFieldYOffset"
            widgets.applyFrameStyle(InputFieldYOffset)
            widgets.applyTextStyle(InputFieldYOffset)
			widgets.UISizeConstraint(InputFieldYOffset, Vector2.new(1, 0))
            InputFieldYOffset.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldYOffset.ZIndex = thisWidget.ZIndex + 4
            InputFieldYOffset.LayoutOrder = thisWidget.ZIndex + 4
			InputFieldYOffset.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldYOffset.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldYOffset.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldYOffset.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldYOffset.ClearTextOnFocus = false
            InputFieldYOffset.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldYOffset.ClipsDescendants = true
            InputFieldYOffset.Parent = InputUDim2
    
            InputFieldYOffset.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldYOffset.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        thisWidget.arguments.Min and thisWidget.arguments.Min.Y.Offset or -math.huge,
                        thisWidget.arguments.Max and thisWidget.arguments.Max.Y.Offset or math.huge
                    )
                    if thisWidget.arguments.Increment then
                        newValue = math.floor(newValue / thisWidget.arguments.Increment.Y.Offset) * thisWidget.arguments.Increment.Y.Offset
                    end
                    thisWidget.state.number:set(UDim2.new(thisWidget.state.number.value.X, UDim.new(thisWidget.state.number.value.Y.Scale, newValue)))
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.number:set(thisWidget.state.number.value)
                end
            end)
    
            InputFieldYOffset.Focused:Connect(function()
                InputFieldYOffset.SelectionStart = 1
            end)
    
            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.ZIndex = thisWidget.ZIndex + 5
            TextLabel.LayoutOrder = thisWidget.ZIndex + 5
            TextLabel.Parent = InputUDim2
    
            return InputUDim2
        end
    }))

    Iris.WidgetConstructor("InputColor3", widgets.extend(abstractInputColor3, {
        Generate = function(thisWidget)
            local InputColor = GenerateRootFrame(thisWidget, "Iris_InputColor3")

            local PreviewColorSize = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
            local totalOffset = Iris._config.ItemInnerSpacing.X * 3 + PreviewColorSize + 1
            local InputWidth = UDim.new(1 / 3, (- totalOffset) / 3)
        
            local InputFieldR = Instance.new("TextBox")
            InputFieldR.Name = "InputFieldR"
            widgets.applyFrameStyle(InputFieldR)
            widgets.applyTextStyle(InputFieldR)
			widgets.UISizeConstraint(InputFieldR, Vector2.new(1, 0))
            InputFieldR.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldR.ZIndex = thisWidget.ZIndex + 1
            InputFieldR.LayoutOrder = thisWidget.ZIndex + 1
			InputFieldR.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldR.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldR.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldR.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldR.ClearTextOnFocus = false
            InputFieldR.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldR.ClipsDescendants = true
            InputFieldR.Parent = InputColor
    
            InputFieldR.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldR.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    local newValueColor
                    if thisWidget.arguments.UseHSV then
                        local H, S, V = thisWidget.state.color.value:ToHSV()
                        newValueColor = Color3.fromHSV(newValue, S, V)
                    else
                        newValueColor = Color3.new(newValue, thisWidget.state.color.value.G, thisWidget.state.color.value.B)
                    end
                    thisWidget.state.color:set(newValueColor)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.color:set(thisWidget.state.color.value)
                end
            end)
    
            InputFieldR.Focused:Connect(function()
                InputFieldR.SelectionStart = 1
            end)

            local InputFieldG = Instance.new("TextBox")
            InputFieldG.Name = "InputFieldG"
            widgets.applyFrameStyle(InputFieldG)
            widgets.applyTextStyle(InputFieldG)
			widgets.UISizeConstraint(InputFieldG, Vector2.new(1, 0))
            InputFieldG.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldG.ZIndex = thisWidget.ZIndex + 2
            InputFieldG.LayoutOrder = thisWidget.ZIndex + 2
			InputFieldG.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldG.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldG.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldG.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldG.ClearTextOnFocus = false
            InputFieldG.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldG.ClipsDescendants = true
            InputFieldG.Parent = InputColor
    
            InputFieldG.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldG.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    local newValueColor
                    if thisWidget.arguments.UseHSV then
                        local H, S, V = thisWidget.state.color.value:ToHSV()
                        newValueColor = Color3.fromHSV(H, newValue, V)
                    else
                        newValueColor = Color3.new(thisWidget.state.color.value.R, newValue, thisWidget.state.color.value.B)
                    end
                    thisWidget.state.color:set(newValueColor)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.color:set(thisWidget.state.color.value)
                end
            end)
    
            InputFieldG.Focused:Connect(function()
                InputFieldG.SelectionStart = 1
            end)

            local InputFieldB = Instance.new("TextBox")
            InputFieldB.Name = "InputFieldB"
            widgets.applyFrameStyle(InputFieldB)
            widgets.applyTextStyle(InputFieldB)
			widgets.UISizeConstraint(InputFieldB, Vector2.new(1, 0))
            InputFieldB.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldB.ZIndex = thisWidget.ZIndex + 3
            InputFieldB.LayoutOrder = thisWidget.ZIndex + 3
			InputFieldB.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldB.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldB.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldB.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldB.ClearTextOnFocus = false
            InputFieldB.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldB.ClipsDescendants = true
            InputFieldB.Parent = InputColor
    
            InputFieldB.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldB.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    local newValueColor
                    if thisWidget.arguments.UseHSV then
                        local H, S, V = thisWidget.state.color.value:ToHSV()
                        newValueColor = Color3.fromHSV(H, S, newValue)
                    else
                        newValueColor = Color3.new(thisWidget.state.color.value.R, thisWidget.state.color.value.G, newValue)
                    end
                    thisWidget.state.color:set(newValueColor)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.color:set(thisWidget.state.color.value)
                end
            end)
    
            InputFieldB.Focused:Connect(function()
                InputFieldB.SelectionStart = 1
            end)

            local PreviewColorBox = Instance.new("Frame")
            PreviewColorBox.Name = "PreviewColorBox"
            PreviewColorBox.BackgroundColor3 = Iris._config.FrameBgColor
            PreviewColorBox.BackgroundTransparency = Iris._config.FrameBgTransparency
            PreviewColorBox.BorderSizePixel = 0
            PreviewColorBox.ZIndex = thisWidget.ZIndex + 4
            PreviewColorBox.LayoutOrder = thisWidget.ZIndex + 4
            PreviewColorBox.Size = UDim2.fromOffset(PreviewColorSize, PreviewColorSize)
            PreviewColorBox.Parent = InputColor

            local PreviewColor = Instance.new("Frame")
            PreviewColor.Name = "PreviewColor"
            PreviewColor.BorderSizePixel = 0
            PreviewColor.ZIndex = thisWidget.ZIndex + 5
            PreviewColor.LayoutOrder = thisWidget.ZIndex + 5
            PreviewColor.Size = UDim2.new(1, -2, 1, -2)
            PreviewColor.Position = UDim2.fromOffset(1, 1)
            PreviewColor.Parent = PreviewColorBox

            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputColor
    
            return InputColor
        end
    }))

    Iris.WidgetConstructor("InputColor4", widgets.extend(abstractInputColor4, {
        Generate = function(thisWidget)
            local InputColor = GenerateRootFrame(thisWidget, "Iris_InputColor3")

            local PreviewColorSize = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
            local totalOffset = Iris._config.ItemInnerSpacing.X * 4 + PreviewColorSize
            local InputWidth = UDim.new(1 / 4, (- totalOffset) / 4 - 1)
        
            local InputFieldR = Instance.new("TextBox")
            InputFieldR.Name = "InputFieldR"
            widgets.applyFrameStyle(InputFieldR)
            widgets.applyTextStyle(InputFieldR)
			widgets.UISizeConstraint(InputFieldR, Vector2.new(1, 0))
            InputFieldR.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldR.ZIndex = thisWidget.ZIndex + 1
            InputFieldR.LayoutOrder = thisWidget.ZIndex + 1
			InputFieldR.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldR.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldR.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldR.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldR.ClearTextOnFocus = false
            InputFieldR.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldR.ClipsDescendants = true
            InputFieldR.Parent = InputColor
    
            InputFieldR.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldR.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    local newValueColor
                    if thisWidget.arguments.UseHSV then
                        local H, S, V = thisWidget.state.color.value:ToHSV()
                        newValueColor = Color3.fromHSV(newValue, S, V)
                    else
                        newValueColor = Color3.new(newValue, thisWidget.state.color.value.G, thisWidget.state.color.value.B)
                    end
                    thisWidget.state.color:set(newValueColor)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.color:set(thisWidget.state.color.value)
                end
            end)
    
            InputFieldR.Focused:Connect(function()
                InputFieldR.SelectionStart = 1
            end)

            local InputFieldG = Instance.new("TextBox")
            InputFieldG.Name = "InputFieldG"
            widgets.applyFrameStyle(InputFieldG)
            widgets.applyTextStyle(InputFieldG)
			widgets.UISizeConstraint(InputFieldG, Vector2.new(1, 0))
            InputFieldG.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldG.ZIndex = thisWidget.ZIndex + 2
            InputFieldG.LayoutOrder = thisWidget.ZIndex + 2
			InputFieldG.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldG.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldG.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldG.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldG.ClearTextOnFocus = false
            InputFieldG.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldG.ClipsDescendants = true
            InputFieldG.Parent = InputColor
    
            InputFieldG.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldG.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    local newValueColor
                    if thisWidget.arguments.UseHSV then
                        local H, S, V = thisWidget.state.color.value:ToHSV()
                        newValueColor = Color3.fromHSV(H, newValue, V)
                    else
                        newValueColor = Color3.new(thisWidget.state.color.value.R, newValue, thisWidget.state.color.value.B)
                    end
                    thisWidget.state.color:set(newValueColor)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.color:set(thisWidget.state.color.value)
                end
            end)
    
            InputFieldG.Focused:Connect(function()
                InputFieldG.SelectionStart = 1
            end)

            local InputFieldB = Instance.new("TextBox")
            InputFieldB.Name = "InputFieldB"
            widgets.applyFrameStyle(InputFieldB)
            widgets.applyTextStyle(InputFieldB)
			widgets.UISizeConstraint(InputFieldB, Vector2.new(1, 0))
            InputFieldB.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldB.ZIndex = thisWidget.ZIndex + 3
            InputFieldB.LayoutOrder = thisWidget.ZIndex + 3
			InputFieldB.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldB.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldB.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldB.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldB.ClearTextOnFocus = false
            InputFieldB.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldB.ClipsDescendants = true
            InputFieldB.Parent = InputColor
    
            InputFieldB.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldB.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    local newValueColor
                    if thisWidget.arguments.UseHSV then
                        local H, S, V = thisWidget.state.color.value:ToHSV()
                        newValueColor = Color3.fromHSV(H, S, newValue)
                    else
                        newValueColor = Color3.new(thisWidget.state.color.value.R, thisWidget.state.color.value.G, newValue)
                    end
                    thisWidget.state.color:set(newValueColor)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.color:set(thisWidget.state.color.value)
                end
            end)
    
            InputFieldB.Focused:Connect(function()
                InputFieldB.SelectionStart = 1
            end)

            local InputFieldA = Instance.new("TextBox")
            InputFieldA.Name = "InputFieldA"
            widgets.applyFrameStyle(InputFieldA)
            widgets.applyTextStyle(InputFieldA)
			widgets.UISizeConstraint(InputFieldA, Vector2.new(1, 0))
            InputFieldA.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputFieldA.ZIndex = thisWidget.ZIndex + 3
            InputFieldA.LayoutOrder = thisWidget.ZIndex + 3
			InputFieldA.Size = UDim2.new(InputWidth, UDim.new(0, 0))
            InputFieldA.AutomaticSize = Enum.AutomaticSize.Y
            InputFieldA.BackgroundColor3 = Iris._config.FrameBgColor
            InputFieldA.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputFieldA.ClearTextOnFocus = false
            InputFieldA.TextTruncate = Enum.TextTruncate.AtEnd
			InputFieldA.ClipsDescendants = true
            InputFieldA.Parent = InputColor
    
            InputFieldA.FocusLost:Connect(function()
                local newValue = tonumber(InputFieldA.Text:match("-?%d+%.?%d*"))
                if newValue ~= nil then
                    newValue = math.clamp(
                        newValue,
                        0,
                        thisWidget.arguments.UseFloats and 1 or 255
                    )
                    if thisWidget.arguments.UseFloats ~= true then
                        newValue = newValue/255
                    end
                    thisWidget.state.transparency:set(newValue)
                    thisWidget.lastNumchangeTick = Iris._cycleTick + 1
                else
                    thisWidget.state.transparency:set(thisWidget.state.transparency.value)
                end
            end)
    
            InputFieldA.Focused:Connect(function()
                InputFieldA.SelectionStart = 1
            end)

            local PreviewColorBox = Instance.new("Frame")
            PreviewColorBox.Name = "PreviewColorBox"
            PreviewColorBox.BackgroundColor3 = Iris._config.FrameBgColor
            PreviewColorBox.BackgroundTransparency = Iris._config.FrameBgTransparency
            PreviewColorBox.BorderSizePixel = 0
            PreviewColorBox.ZIndex = thisWidget.ZIndex + 4
            PreviewColorBox.LayoutOrder = thisWidget.ZIndex + 4
            PreviewColorBox.Size = UDim2.fromOffset(PreviewColorSize, PreviewColorSize)
            PreviewColorBox.Parent = InputColor

            local PreviewColorBackground = Instance.new("ImageLabel")
            PreviewColorBackground.Name = "PreviewColorBackground"
            PreviewColorBackground.BorderSizePixel = 0
            PreviewColorBackground.ZIndex = thisWidget.ZIndex + 5
            PreviewColorBackground.LayoutOrder = thisWidget.ZIndex + 5
            PreviewColorBackground.Size = UDim2.new(1, -2, 1, -2)
            PreviewColorBackground.Position = UDim2.fromOffset(1, 1)
            PreviewColorBackground.Image = widgets.ICONS.ALPHA_BACKGROUND_TEXTURE
            PreviewColorBackground.Parent = PreviewColorBox

            local PreviewColor = Instance.new("Frame")
            PreviewColor.Name = "PreviewColor"
            PreviewColor.BorderSizePixel = 0
            PreviewColor.ZIndex = thisWidget.ZIndex +  6
            PreviewColor.LayoutOrder = thisWidget.ZIndex + 6
            PreviewColor.Size = UDim2.new(1, -2, 1, -2)
            PreviewColor.Position = UDim2.fromOffset(1, 1)
            PreviewColor.Parent = PreviewColorBox

            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputColor
    
            return InputColor
        end
    }))
    
    Iris.WidgetConstructor("InputText", {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["TextHint"] = 2
        },
        Events = {
            ["textChanged"] = {
                ["Init"] = function(thisWidget)
    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastTextchangeTick == Iris._cycleTick
                end
            },
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            local textLabelHeight = Iris._config.TextSize
    
            local InputText = GenerateRootFrame(thisWidget, "Iris_InputText")
    
            local InputField = Instance.new("TextBox")
            InputField.Name = "InputField"
            widgets.applyFrameStyle(InputField)
            widgets.applyTextStyle(InputField)
			widgets.UISizeConstraint(InputField, Vector2.new(1, 0)) -- prevents sizes beaking when getting too small.
            InputField.UIPadding.PaddingLeft = UDim.new(0, Iris._config.ItemInnerSpacing.X)
            InputField.UIPadding.PaddingRight = UDim.new(0, 0)
            InputField.ZIndex = thisWidget.ZIndex + 1
            InputField.LayoutOrder = thisWidget.ZIndex + 1
            InputField.AutomaticSize = Enum.AutomaticSize.Y
            InputField.Size = UDim2.new(1, 0, 0, 0)
            InputField.BackgroundColor3 = Iris._config.FrameBgColor
            InputField.BackgroundTransparency = Iris._config.FrameBgTransparency
            InputField.ClearTextOnFocus = false
            InputField.Text = ""
            InputField.PlaceholderColor3 = Iris._config.TextDisabledColor
            InputField.TextTruncate = Enum.TextTruncate.AtEnd
			InputField.ClipsDescendants = true
    
            InputField.FocusLost:Connect(function()
                thisWidget.state.text:set(InputField.Text)
                thisWidget.lastTextchangeTick = Iris._cycleTick
            end)
    
            InputField.Parent = InputText
    
            local TextLabel = GenerateTextLabel(thisWidget)
            TextLabel.Parent = InputText
    
            return InputText
        end,
        Update = function(thisWidget)
            local TextLabel = thisWidget.Instance.TextLabel
            TextLabel.Text = thisWidget.arguments.Text or "Input Text"
    
            thisWidget.Instance.InputField.PlaceholderText = thisWidget.arguments.TextHint or ""
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.text == nil then
                thisWidget.state.text = Iris._widgetState(thisWidget, "text", "")
            end
        end,
        UpdateState = function(thisWidget)
            thisWidget.Instance.InputField.Text = thisWidget.state.text.value
        end
    })
end
end)
__bundle_register("widgets/Tree", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    local abstractTree = {
        hasState = true,
        hasChildren = true,
        Events = {
            ["collasped"] = {
                ["Init"] = function(thisWidget)
    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget._lastCollapsedTick == Iris._cycleTick
                end
            },
            ["uncollapsed"] = {
                ["Init"] = function(thisWidget)
    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget._lastUncollapsedTick == Iris._cycleTick
                end
            },
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        ChildAdded = function(thisWidget)
            local ChildContainer = thisWidget.Instance.ChildContainer
            local isUncollapsed = thisWidget.state.isUncollapsed.value
    
            thisWidget.hasChildren = true
            ChildContainer.Visible = isUncollapsed and thisWidget.hasChildren
    
            return thisWidget.Instance.ChildContainer
        end,
        UpdateState = function(thisWidget)
            local isUncollapsed = thisWidget.state.isUncollapsed.value
            local Arrow = thisWidget.ArrowInstance
            local ChildContainer = thisWidget.Instance.ChildContainer
            Arrow.Text = (isUncollapsed and widgets.ICONS.DOWN_POINTING_TRIANGLE or widgets.ICONS.RIGHT_POINTING_TRIANGLE)
    
            if isUncollapsed then
                thisWidget.lastUncollaspedTick = Iris._cycleTick + 1
            else
                thisWidget.lastCollapsedTick = Iris._cycleTick + 1
            end
    
            ChildContainer.Visible = isUncollapsed and thisWidget.hasChildren
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.isUncollapsed == nil then
                thisWidget.state.isUncollapsed = Iris._widgetState(thisWidget, "isUncollapsed", false)
            end
        end
    }

    Iris.WidgetConstructor("Tree", widgets.extend(abstractTree, {
        Args = {
            ["Text"] = 1,
            ["SpanAvailWidth"] = 2,
            ["NoIndent"] = 3
        },
        Generate = function(thisWidget)
            local Tree = Instance.new("Frame")
            Tree.Name = "Iris_Tree"
            Tree.BackgroundTransparency = 1
            Tree.BorderSizePixel = 0
            Tree.ZIndex = thisWidget.ZIndex
            Tree.LayoutOrder = thisWidget.ZIndex
            Tree.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, 0))
            Tree.AutomaticSize = Enum.AutomaticSize.Y
    
            thisWidget.hasChildren = false
    
            widgets.UIListLayout(Tree, Enum.FillDirection.Vertical, UDim.new(0, 0))
    
            local ChildContainer = Instance.new("Frame")
            ChildContainer.Name = "ChildContainer"
            ChildContainer.BackgroundTransparency = 1
            ChildContainer.BorderSizePixel = 0
            ChildContainer.ZIndex = thisWidget.ZIndex + 1
            ChildContainer.LayoutOrder = thisWidget.ZIndex + 1
            ChildContainer.Size = UDim2.fromScale(1, 0)
            ChildContainer.AutomaticSize = Enum.AutomaticSize.Y
            ChildContainer.Visible = false
			ChildContainer.ClipsDescendants = true
            ChildContainer.Parent = Tree
    
            widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
            
            local ChildContainerPadding = widgets.UIPadding(ChildContainer, Vector2.new(0, 0))
            ChildContainerPadding.PaddingTop = UDim.new(0, Iris._config.ItemSpacing.Y)
    
            local Header = Instance.new("Frame")
            Header.Name = "Header"
            Header.BackgroundTransparency = 1
            Header.BorderSizePixel = 0
            Header.ZIndex = thisWidget.ZIndex
            Header.LayoutOrder = thisWidget.ZIndex
            Header.Size = UDim2.fromScale(1, 0)
            Header.AutomaticSize = Enum.AutomaticSize.Y
            Header.Parent = Tree
    
            local Button = Instance.new("TextButton")
            Button.Name = "Button"
            Button.BackgroundTransparency = 1
            Button.BorderSizePixel = 0
            Button.ZIndex = thisWidget.ZIndex
            Button.LayoutOrder = thisWidget.ZIndex
            Button.AutoButtonColor = false
            Button.Text = ""
            Button.Parent = Header
    
            widgets.applyInteractionHighlights(Button, Header, {
                ButtonColor = Color3.fromRGB(0, 0, 0),
                ButtonTransparency = 1,
                ButtonHoveredColor = Iris._config.HeaderHoveredColor,
                ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
                ButtonActiveColor = Iris._config.HeaderActiveColor,
                ButtonActiveTransparency = Iris._config.HeaderActiveTransparency,
            })
    
            local uiPadding = widgets.UIPadding(Button, Vector2.zero)
            uiPadding.PaddingLeft = UDim.new(0, Iris._config.FramePadding.X)
            local ButtonUIListLayout = widgets.UIListLayout(Button, Enum.FillDirection.Horizontal, UDim.new(0, Iris._config.FramePadding.X))
            ButtonUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
            local Arrow = Instance.new("TextLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.fromOffset(Iris._config.TextSize, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.BorderSizePixel = 0
            Arrow.ZIndex = thisWidget.ZIndex
            Arrow.LayoutOrder = thisWidget.ZIndex
            Arrow.AutomaticSize = Enum.AutomaticSize.Y
    
            widgets.applyTextStyle(Arrow)
            Arrow.TextXAlignment = Enum.TextXAlignment.Center
            Arrow.TextSize = Iris._config.TextSize - 4
    
            Arrow.Parent = Button
            thisWidget.ArrowInstance = Arrow
    
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextLabel"
            TextLabel.Size = UDim2.fromOffset(0, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.BorderSizePixel = 0
            TextLabel.ZIndex = thisWidget.ZIndex
            TextLabel.LayoutOrder = thisWidget.ZIndex
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY
            TextLabel.Parent = Button
            local TextPadding = widgets.UIPadding(TextLabel,Vector2.new(0, 0))
            TextPadding.PaddingRight = UDim.new(0, 21)
    
            widgets.applyTextStyle(TextLabel)
    
            Button.MouseButton1Click:Connect(function()
                thisWidget.state.isUncollapsed:set(not thisWidget.state.isUncollapsed.value)
            end)
    
            return Tree
        end,
        Update = function(thisWidget)
            local Button = thisWidget.Instance.Header.Button
            local ChildContainer = thisWidget.Instance.ChildContainer
            Button.TextLabel.Text = thisWidget.arguments.Text or "Tree"
            if thisWidget.arguments.SpanAvailWidth then
                Button.AutomaticSize = Enum.AutomaticSize.Y
                Button.Size = UDim2.fromScale(1, 0)
            else
                Button.AutomaticSize = Enum.AutomaticSize.XY
                Button.Size = UDim2.fromScale(0, 0)
            end
    
            if thisWidget.arguments.NoIndent then
                ChildContainer.UIPadding.PaddingLeft = UDim.new(0, 0)
            else
                ChildContainer.UIPadding.PaddingLeft = UDim.new(0, Iris._config.IndentSpacing)
            end
    
        end
    }))
    
    Iris.WidgetConstructor("CollapsingHeader", widgets.extend(abstractTree, {
        Args = {
            ["Text"] = 1,
        },
        Generate = function(thisWidget)
            local CollapsingHeader = Instance.new("Frame")
            CollapsingHeader.Name = "Iris_CollapsingHeader"
            CollapsingHeader.BackgroundTransparency = 1
            CollapsingHeader.BorderSizePixel = 0
            CollapsingHeader.ZIndex = thisWidget.ZIndex
            CollapsingHeader.LayoutOrder = thisWidget.ZIndex
            CollapsingHeader.Size = UDim2.new(Iris._config.ItemWidth, UDim.new(0, 0))
            CollapsingHeader.AutomaticSize = Enum.AutomaticSize.Y
    
            thisWidget.hasChildren = false
    
            widgets.UIListLayout(CollapsingHeader, Enum.FillDirection.Vertical, UDim.new(0, 0))
    
            local ChildContainer = Instance.new("Frame")
            ChildContainer.Name = "ChildContainer"
            ChildContainer.BackgroundTransparency = 1
            ChildContainer.BorderSizePixel = 0
            ChildContainer.ZIndex = thisWidget.ZIndex + 1
            ChildContainer.LayoutOrder = thisWidget.ZIndex + 1
            ChildContainer.Size = UDim2.fromScale(1, 0)
            ChildContainer.AutomaticSize = Enum.AutomaticSize.Y
            ChildContainer.Visible = false
			ChildContainer.ClipsDescendants = true
            ChildContainer.Parent = CollapsingHeader
    
            widgets.UIListLayout(ChildContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
            
            local ChildContainerPadding = widgets.UIPadding(ChildContainer, Vector2.new(0, 0))
            ChildContainerPadding.PaddingTop = UDim.new(0, Iris._config.ItemSpacing.Y)
    
            local Header = Instance.new("Frame")
            Header.Name = "Header"
            Header.BackgroundTransparency = 1
            Header.BorderSizePixel = 0
            Header.ZIndex = thisWidget.ZIndex
            Header.LayoutOrder = thisWidget.ZIndex
            Header.Size = UDim2.fromScale(1, 0)
            Header.AutomaticSize = Enum.AutomaticSize.Y
            Header.Parent = CollapsingHeader
    
            local Collapse = Instance.new("TextButton")
            Collapse.Name = "Collapse"
            Collapse.BackgroundColor3 = Iris._config.HeaderColor
            Collapse.BackgroundTransparency = Iris._config.HeaderTransparency
            Collapse.BorderSizePixel = 0
            Collapse.ZIndex = thisWidget.ZIndex
            Collapse.LayoutOrder = thisWidget.ZIndex
            Collapse.Size = UDim2.new(1, 2 * Iris._config.FramePadding.X, 0, 0)
            Collapse.Position = UDim2.fromOffset(-4, 0)
            Collapse.AutomaticSize = Enum.AutomaticSize.Y
            Collapse.Text = ""
            Collapse.AutoButtonColor = false
			Collapse.ClipsDescendants = true
            Collapse.Parent = Header
    
            widgets.UIPadding(Collapse, Vector2.new(2 * Iris._config.FramePadding.X, Iris._config.FramePadding.Y)) -- we add a custom padding because it extends on both sides
            widgets.applyFrameStyle(Collapse, true, true)
    
            widgets.applyInteractionHighlights(Collapse, Collapse, {
                ButtonColor = Iris._config.HeaderColor,
                ButtonTransparency = Iris._config.HeaderTransparency,
                ButtonHoveredColor = Iris._config.HeaderHoveredColor,
                ButtonHoveredTransparency = Iris._config.HeaderHoveredTransparency,
                ButtonActiveColor = Iris._config.HeaderActiveColor,
                ButtonActiveTransparency = Iris._config.HeaderActiveTransparency,
            })
    
            local ButtonUIListLayout = widgets.UIListLayout(Collapse, Enum.FillDirection.Horizontal, UDim.new(0, 2 * Iris._config.FramePadding.X))
            ButtonUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    
            local Arrow = Instance.new("TextLabel")
            Arrow.Name = "Arrow"
            Arrow.Size = UDim2.fromOffset(Iris._config.TextSize, 0)
            Arrow.BackgroundTransparency = 1
            Arrow.BorderSizePixel = 0
            Arrow.ZIndex = thisWidget.ZIndex
            Arrow.LayoutOrder = thisWidget.ZIndex
            Arrow.AutomaticSize = Enum.AutomaticSize.Y
    
            widgets.applyTextStyle(Arrow)
            Arrow.TextXAlignment = Enum.TextXAlignment.Center
            Arrow.TextSize = Iris._config.TextSize - 4

            Arrow.Parent = Collapse
            thisWidget.ArrowInstance = Arrow
    
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextLabel"
            TextLabel.Size = UDim2.fromOffset(0, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.BorderSizePixel = 0
            TextLabel.ZIndex = thisWidget.ZIndex
            TextLabel.LayoutOrder = thisWidget.ZIndex
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY
            TextLabel.Parent = Collapse
            local TextPadding = widgets.UIPadding(TextLabel,Vector2.new(0, 0))
            TextPadding.PaddingRight = UDim.new(0, 21)
    
            widgets.applyTextStyle(TextLabel)
    
            Collapse.MouseButton1Click:Connect(function()
                thisWidget.state.isUncollapsed:set(not thisWidget.state.isUncollapsed.value)
            end)
    
            return CollapsingHeader
        end,
        Update = function(thisWidget)
            local Collapse = thisWidget.Instance.Header.Collapse
            Collapse.TextLabel.Text = thisWidget.arguments.Text or "Collapsing Header"
        end
    }))
end
end)
__bundle_register("widgets/RadioButton", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    Iris.WidgetConstructor("RadioButton", {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1,
            ["Index"] = 2
        },
        Events = {
            ["selected"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastSelectedTick == Iris._cycleTick
                end
            },
            ["unselected"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastUnselectedTick == Iris._cycleTick
                end
            },
            ["active"] = {
                ["Init"] = function(thisWidget)
                    
                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.state.index.value == thisWidget.arguments.Index
                end
            },
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            local RadioButton = Instance.new("TextButton")
            RadioButton.Name = "Iris_RadioButton"
            RadioButton.BackgroundTransparency = 1
            RadioButton.BorderSizePixel = 0
            RadioButton.Size = UDim2.fromOffset(0, 0)
            RadioButton.Text = ""
            RadioButton.AutomaticSize = Enum.AutomaticSize.XY
            RadioButton.ZIndex = thisWidget.ZIndex
            RadioButton.AutoButtonColor = false
            RadioButton.LayoutOrder = thisWidget.ZIndex
    
            local buttonSize = Iris._config.TextSize + 2 * (Iris._config.FramePadding.Y - 1)
            local Button = Instance.new("Frame")
            Button.Name = "Button"
            Button.Size = UDim2.fromOffset(buttonSize, buttonSize)
            Button.ZIndex = thisWidget.ZIndex + 1
            Button.LayoutOrder = thisWidget.ZIndex + 1
            Button.Parent = RadioButton
            Button.BackgroundColor3 = Iris._config.FrameBgColor
            Button.BackgroundTransparency = Iris._config.FrameBgTransparency
    
            widgets.UICorner(Button)
    
            local Circle = Instance.new("Frame")
            Circle.Name = "Circle"
            Circle.Position = UDim2.fromOffset(Iris._config.FramePadding.Y, Iris._config.FramePadding.Y)
            Circle.Size = UDim2.fromOffset(Iris._config.TextSize - 2, Iris._config.TextSize - 2 )
            Circle.ZIndex = thisWidget.ZIndex + 1
            Circle.LayoutOrder = thisWidget.ZIndex + 1
            Circle.Parent = Button
            Circle.BackgroundColor3 = Iris._config.CheckMarkColor
            Circle.BackgroundTransparency = Iris._config.CheckMarkTransparency
            widgets.UICorner(Circle)
    
            widgets.applyInteractionHighlights(RadioButton, Button, {
                ButtonColor = Iris._config.FrameBgColor,
                ButtonTransparency = Iris._config.FrameBgTransparency,
                ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                ButtonActiveColor = Iris._config.FrameBgActiveColor,
                ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
            })
    
            RadioButton.MouseButton1Click:Connect(function()
                thisWidget.state.index:set(thisWidget.arguments.Index)
            end)
    
            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextLabel"
            widgets.applyTextStyle(TextLabel)
            TextLabel.Position = UDim2.new(0,buttonSize + Iris._config.ItemInnerSpacing.X, 0.5, 0)
            TextLabel.ZIndex = thisWidget.ZIndex + 1
            TextLabel.LayoutOrder = thisWidget.ZIndex + 1
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextLabel.BackgroundTransparency = 1
            TextLabel.BorderSizePixel = 0
            TextLabel.Parent = RadioButton
    
            return RadioButton
        end,
        Update = function(thisWidget)
            thisWidget.Instance.TextLabel.Text = thisWidget.arguments.Text or "Radio Button"
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.index == nil then
                thisWidget.state.index = Iris._widgetState(thisWidget, "index", thisWidget.arguments.Value)
            end
        end,
        UpdateState = function(thisWidget)
            local Circle = thisWidget.Instance.Button.Circle
            if thisWidget.state.index.value == thisWidget.arguments.Index then
                -- only need to hide the circle
                Circle.BackgroundTransparency = Iris._config.CheckMarkTransparency
                thisWidget.lastSelectedTick = Iris._cycleTick + 1
            else
                Circle.BackgroundTransparency = 1
                thisWidget.lastUnselectedTick = Iris._cycleTick + 1
            end
        end
    })
end
end)
__bundle_register("widgets/Checkbox", function(require, _LOADED, __bundle_register, __bundle_modules)


return function(Iris, widgets)
    Iris.WidgetConstructor("Checkbox", {
        hasState = true,
        hasChildren = false,
        Args = {
            ["Text"] = 1
        },
        Events = {
            ["checked"] = {
                ["Init"] = function(thisWidget)

                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastCheckedTick == Iris._cycleTick
                end
            },
            ["unchecked"] = {
                ["Init"] = function(thisWidget)

                end,
                ["Get"] = function(thisWidget)
                    return thisWidget.lastUncheckedTick == Iris._cycleTick
                end
            },
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            local Checkbox = Instance.new("TextButton")
            Checkbox.Name = "Iris_Checkbox"
            Checkbox.BackgroundTransparency = 1
            Checkbox.BorderSizePixel = 0
            Checkbox.Size = UDim2.fromOffset(0, 0)
            Checkbox.Text = ""
            Checkbox.AutomaticSize = Enum.AutomaticSize.XY
            Checkbox.ZIndex = thisWidget.ZIndex
            Checkbox.AutoButtonColor = false
            Checkbox.LayoutOrder = thisWidget.ZIndex

            local CheckboxBox = Instance.new("ImageLabel")
            CheckboxBox.Name = "CheckboxBox"
            CheckboxBox.AutomaticSize = Enum.AutomaticSize.None
            local checkboxSize = Iris._config.TextSize + 2 * Iris._config.FramePadding.Y
            CheckboxBox.Size = UDim2.fromOffset(checkboxSize, checkboxSize)
            CheckboxBox.ZIndex = thisWidget.ZIndex + 1
            CheckboxBox.LayoutOrder = thisWidget.ZIndex + 1
            CheckboxBox.Parent = Checkbox
            CheckboxBox.ImageColor3 = Iris._config.CheckMarkColor
            CheckboxBox.ImageTransparency = Iris._config.CheckMarkTransparency
            CheckboxBox.ScaleType = Enum.ScaleType.Fit
            CheckboxBox.BackgroundColor3 = Iris._config.FrameBgColor
            CheckboxBox.BackgroundTransparency = Iris._config.FrameBgTransparency
            widgets.applyFrameStyle(CheckboxBox, true)

            widgets.applyInteractionHighlights(Checkbox, CheckboxBox, {
                ButtonColor = Iris._config.FrameBgColor,
                ButtonTransparency = Iris._config.FrameBgTransparency,
                ButtonHoveredColor = Iris._config.FrameBgHoveredColor,
                ButtonHoveredTransparency = Iris._config.FrameBgHoveredTransparency,
                ButtonActiveColor = Iris._config.FrameBgActiveColor,
                ButtonActiveTransparency = Iris._config.FrameBgActiveTransparency,
            })

            Checkbox.MouseButton1Click:Connect(function()
                local wasChecked = thisWidget.state.isChecked.value
                thisWidget.state.isChecked:set(not wasChecked)
            end)

            local TextLabel = Instance.new("TextLabel")
            TextLabel.Name = "TextLabel"
            widgets.applyTextStyle(TextLabel)
            TextLabel.Position = UDim2.new(0,checkboxSize + Iris._config.ItemInnerSpacing.X, 0.5, 0)
            TextLabel.ZIndex = thisWidget.ZIndex + 1
            TextLabel.LayoutOrder = thisWidget.ZIndex + 1
            TextLabel.AutomaticSize = Enum.AutomaticSize.XY
            TextLabel.AnchorPoint = Vector2.new(0, 0.5)
            TextLabel.BackgroundTransparency = 1
            TextLabel.BorderSizePixel = 0
            TextLabel.Parent = Checkbox

            return Checkbox
        end,
        Update = function(thisWidget)
            thisWidget.Instance.TextLabel.Text = thisWidget.arguments.Text or "Checkbox"
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
            widgets.discardState(thisWidget)
        end,
        GenerateState = function(thisWidget)
            if thisWidget.state.isChecked == nil then
                thisWidget.state.isChecked = Iris._widgetState(thisWidget, "checked", false)
            end
        end,
        UpdateState = function(thisWidget)
            local Checkbox = thisWidget.Instance.CheckboxBox
            if thisWidget.state.isChecked.value then
                Checkbox.Image = widgets.ICONS.CHECK_MARK
                thisWidget.lastCheckedTick = Iris._cycleTick + 1
            else
                Checkbox.Image = ""
                thisWidget.lastUncheckedTick = Iris._cycleTick + 1
            end
        end
    })
end
end)
__bundle_register("widgets/Format", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    Iris.WidgetConstructor("Separator", {
        hasState = false,
        hasChildren = false,
        Args = {
    
        },
        Events = {
            
        },
        Generate = function(thisWidget)
            local Separator = Instance.new("Frame")
            Separator.Name = "Iris_Separator"
            Separator.BorderSizePixel = 0
            if thisWidget.parentWidget.type == "SameLine" then
                Separator.Size = UDim2.new(0, 1, 1, 0)
            else
                Separator.Size = UDim2.new(1, 0, 0, 1)
            end
            Separator.ZIndex = thisWidget.ZIndex
            Separator.LayoutOrder = thisWidget.ZIndex
    
            Separator.BackgroundColor3 = Iris._config.SeparatorColor
            Separator.BackgroundTransparency = Iris._config.SeparatorTransparency
    
            widgets.UIListLayout(Separator, Enum.FillDirection.Vertical, UDim.new(0,0))
            -- this is to prevent a bug of AutomaticLayout edge case when its parent has automaticLayout enabled
    
            return Separator
        end,
        Update = function(thisWidget)
    
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end
    })
    
    Iris.WidgetConstructor("Indent", {
        hasState = false,
        hasChildren = true,
        Args = {
            ["Width"] = 1,
        },
        Events = {
            
        },
        Generate = function(thisWidget)
            local Indent = Instance.new("Frame")
            Indent.Name = "Iris_Indent"
            Indent.BackgroundTransparency = 1
            Indent.BorderSizePixel = 0
            Indent.ZIndex = thisWidget.ZIndex
            Indent.LayoutOrder = thisWidget.ZIndex
            Indent.Size = UDim2.fromScale(1, 0)
            Indent.AutomaticSize = Enum.AutomaticSize.Y
    
            widgets.UIListLayout(Indent, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))
            widgets.UIPadding(Indent, Vector2.new(0, 0))
    
            return Indent
        end,
        Update = function(thisWidget)
            local indentWidth
            if thisWidget.arguments.Width then
                indentWidth = thisWidget.arguments.Width
            else
                indentWidth = Iris._config.IndentSpacing
            end
            thisWidget.Instance.UIPadding.PaddingLeft = UDim.new(0, indentWidth)
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end,
        ChildAdded = function(thisWidget)
            return thisWidget.Instance
        end
    })
    
    Iris.WidgetConstructor("SameLine", {
        hasState = false,
        hasChildren = true,
        Args = {
            ["Width"] = 1,
            ["VerticalAlignment"] = 2
        },
        Events = {
            
        },
        Generate = function(thisWidget)
            local SameLine = Instance.new("Frame")
            SameLine.Name = "Iris_SameLine"
            SameLine.BackgroundTransparency = 1
            SameLine.BorderSizePixel = 0
            SameLine.ZIndex = thisWidget.ZIndex
            SameLine.LayoutOrder = thisWidget.ZIndex
            SameLine.Size = UDim2.fromScale(1, 0)
            SameLine.AutomaticSize = Enum.AutomaticSize.Y
    
            widgets.UIListLayout(SameLine, Enum.FillDirection.Horizontal, UDim.new(0, 0))
    
            return SameLine
        end,
        Update = function(thisWidget)
            local itemWidth
            local uiListLayout = thisWidget.Instance.UIListLayout
            if thisWidget.arguments.Width then
                itemWidth = thisWidget.arguments.Width
            else
                itemWidth = Iris._config.ItemSpacing.X
            end
            uiListLayout.Padding = UDim.new(0, itemWidth)
            if thisWidget.arguments.VerticalAlignment then
                uiListLayout.VerticalAlignment = thisWidget.arguments.VerticalAlignment
            else
                uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            end
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end,
        ChildAdded = function(thisWidget)
            return thisWidget.Instance
        end
    })
    
    Iris.WidgetConstructor("Group", {
        hasState = false,
        hasChildren = true,
        Args = {
    
        },
        Events = {
            
        },
        Generate = function(thisWidget)
            local Group = Instance.new("Frame")
            Group.Name = "Iris_Group"
            Group.Size = UDim2.fromOffset(0, 0)
            Group.BackgroundTransparency = 1
            Group.BorderSizePixel = 0
            Group.ZIndex = thisWidget.ZIndex
            Group.LayoutOrder = thisWidget.ZIndex
            Group.AutomaticSize = Enum.AutomaticSize.XY
            Group.ClipsDescendants = true
    
            local uiListLayout = widgets.UIListLayout(Group, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.X))
    
            return Group
        end,
        Update = function(thisWidget)
    
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end,
        ChildAdded = function(thisWidget)
            return thisWidget.Instance
        end
    })
end
end)
__bundle_register("widgets/Button", function(require, _LOADED, __bundle_register, __bundle_modules)

return function(Iris, widgets)
    local abstractButton = {
        hasState = false,
        hasChildren = false,
        Args = {
            ["Text"] = 1
        },
        Events = {
            ["clicked"] = widgets.EVENTS.click(function(thisWidget)
                return thisWidget.Instance
            end),
            ["rightClicked"] = widgets.EVENTS.rightClick(function(thisWidget)
                return thisWidget.Instance
            end),
            ["doubleClicked"] = widgets.EVENTS.doubleClick(function(thisWidget)
                return thisWidget.Instance
            end),
            ["ctrlClicked"] = widgets.EVENTS.ctrlClick(function(thisWidget)
                return thisWidget.Instance
            end),
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.fromOffset(0, 0)
            Button.BackgroundColor3 = Iris._config.ButtonColor
            Button.BackgroundTransparency = Iris._config.ButtonTransparency
            Button.AutoButtonColor = false
        
            widgets.applyTextStyle(Button)
            Button.AutomaticSize = Enum.AutomaticSize.XY
        
            widgets.applyFrameStyle(Button)
        
            widgets.applyInteractionHighlights(Button, Button, {
                ButtonColor = Iris._config.ButtonColor,
                ButtonTransparency = Iris._config.ButtonTransparency,
                ButtonHoveredColor = Iris._config.ButtonHoveredColor,
                ButtonHoveredTransparency = Iris._config.ButtonHoveredTransparency,
                ButtonActiveColor = Iris._config.ButtonActiveColor,
                ButtonActiveTransparency = Iris._config.ButtonActiveTransparency,
            })
    
            Button.ZIndex = thisWidget.ZIndex
            Button.LayoutOrder = thisWidget.ZIndex
    
            return Button
        end,
        Update = function(thisWidget)
            local Button = thisWidget.Instance
            Button.Text = thisWidget.arguments.Text or "Button"
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end
    }
    widgets.abstractButton = abstractButton
    
    Iris.WidgetConstructor("Button", widgets.extend(abstractButton, {
        Generate = function(thisWidget)
            local Button = abstractButton.Generate(thisWidget)
            Button.Name = "Iris_Button"
    
            return Button
        end
    }))
    
    Iris.WidgetConstructor("SmallButton", widgets.extend(abstractButton, {
        Generate = function(thisWidget)
            local SmallButton = abstractButton.Generate(thisWidget)
            SmallButton.Name = "Iris_SmallButton"
    
            local uiPadding = SmallButton.UIPadding
            uiPadding.PaddingLeft = UDim.new(0, 2)
            uiPadding.PaddingRight = UDim.new(0, 2)
            uiPadding.PaddingTop = UDim.new(0, 0)
            uiPadding.PaddingBottom = UDim.new(0, 0)
    
            return SmallButton
        end
    }))
end
end)
__bundle_register("widgets/Text", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    local abstractText = {
        hasState = false,
        hasChildren = false,
        Args = {
            ["Text"] = 1
        },
        Events = {
            ["hovered"] = widgets.EVENTS.hover(function(thisWidget)
                return thisWidget.Instance
            end)
        },
        Generate = function(thisWidget)
            local Text = Instance.new("TextLabel")
            Text.Size = UDim2.fromOffset(0, 0)
            Text.BackgroundTransparency = 1
            Text.BorderSizePixel = 0
            Text.ZIndex = thisWidget.ZIndex
            Text.LayoutOrder = thisWidget.ZIndex
            Text.AutomaticSize = Enum.AutomaticSize.XY

            widgets.applyTextStyle(Text)
            widgets.UIPadding(Text, Vector2.new(0, 2))

            return Text
        end,
        Update = function(thisWidget)
            local Text = thisWidget.Instance
            if thisWidget.arguments.Text == nil then
                error("Iris.Text Text Argument is required", 5)
            end
            Text.Text = thisWidget.arguments.Text
        end,
        Discard = function(thisWidget)
            thisWidget.Instance:Destroy()
        end
    }

    Iris.WidgetConstructor("Text", widgets.extend(abstractText, {
        Generate = function(thisWidget)
            local Text = abstractText.Generate(thisWidget)
            Text.Name = "Iris_Text"

            return Text
        end
    }))

    Iris.WidgetConstructor("TextColored", widgets.extend(abstractText, {
        Args = {
            ["Text"] = 1,
            ["Color"] = 2
        },
        Generate = function(thisWidget)
            local Text = abstractText.Generate(thisWidget)
            Text.Name = "Iris_TextColored"

            return Text
        end,
        Update = function(thisWidget)
            local Text = thisWidget.Instance
            if thisWidget.arguments.Text == nil then
                error("Iris.Text Text Argument is required", 5)
            end
            Text.Text = thisWidget.arguments.Text
            if thisWidget.arguments.Color == nil then
                error("Iris.TextColored Color argument is required", 5)
            end 
            Text.TextColor3 = thisWidget.arguments.Color
        end
    }))

    Iris.WidgetConstructor("TextWrapped", widgets.extend(abstractText, {
        Generate = function(thisWidget)
            local TextWrapped = abstractText.Generate(thisWidget)
            TextWrapped.Name = "Iris_TextWrapped"
            TextWrapped.TextWrapped = true

            return TextWrapped
        end
    }))
end
end)
__bundle_register("widgets/Root", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris, widgets)
    local NumNonWindowChildren = 0
    Iris.WidgetConstructor("Root", {
        hasState = false,
        hasChildren = true,
        Args = {

        },
        Events = {
        
        },
        Generate = function(thisWidget)
            local Root = Instance.new("Folder")
            Root.Name = "Iris_Root"

            local PseudoWindowScreenGui
            if Iris._config.UseScreenGUIs then
                PseudoWindowScreenGui = Instance.new("ScreenGui")
                PseudoWindowScreenGui.ResetOnSpawn = false
                PseudoWindowScreenGui.DisplayOrder = Iris._config.DisplayOrderOffset
            else
                PseudoWindowScreenGui = Instance.new("Folder")
            end
            PseudoWindowScreenGui.Name = "PseudoWindowScreenGui"
            PseudoWindowScreenGui.Parent = Root

            local PopupScreenGui
            if Iris._config.UseScreenGUIs then
                PopupScreenGui = Instance.new("ScreenGui")
                PopupScreenGui.ResetOnSpawn = false
                PopupScreenGui.DisplayOrder = Iris._config.DisplayOrderOffset + 1024 -- room for 1024 regular windows before overlap

                local TooltipContainer = Instance.new("Frame")
                TooltipContainer.Name = "TooltipContainer"
                TooltipContainer.AutomaticSize = Enum.AutomaticSize.XY
                TooltipContainer.Size = UDim2.fromOffset(0, 0)
                TooltipContainer.BackgroundTransparency = 1
                TooltipContainer.BorderSizePixel = 0

                widgets.UIListLayout(TooltipContainer, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.FrameBorderSize))

                TooltipContainer.Parent = PopupScreenGui
            else
                PopupScreenGui = Instance.new("Folder")
            end
            PopupScreenGui.Name = "PopupScreenGui"
            PopupScreenGui.Parent = Root
            
            local PseudoWindow = Instance.new("Frame")
            PseudoWindow.Name = "PseudoWindow"
            PseudoWindow.Size = UDim2.new(0, 0, 0, 0)
            PseudoWindow.Position = UDim2.fromOffset(0, 22)
            PseudoWindow.BorderSizePixel = Iris._config.WindowBorderSize
            PseudoWindow.BorderColor3 = Iris._config.BorderColor
            PseudoWindow.BackgroundTransparency = Iris._config.WindowBgTransparency
            PseudoWindow.BackgroundColor3 = Iris._config.WindowBgColor
            PseudoWindow.AutomaticSize = Enum.AutomaticSize.XY

            PseudoWindow.Selectable = false
            PseudoWindow.SelectionGroup = true
            PseudoWindow.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
            PseudoWindow.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
            PseudoWindow.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
            PseudoWindow.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

            PseudoWindow.Visible = false
            widgets.UIPadding(PseudoWindow, Iris._config.WindowPadding)

            widgets.UIListLayout(PseudoWindow, Enum.FillDirection.Vertical, UDim.new(0, Iris._config.ItemSpacing.Y))

            PseudoWindow.Parent = PseudoWindowScreenGui
            
            return Root
        end,
        Update = function(thisWidget)
            if NumNonWindowChildren > 0 then
                thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = true
            end
        end,
        Discard = function(thisWidget)
            NumNonWindowChildren = 0
            thisWidget.Instance:Destroy()
        end,
        ChildAdded = function(thisWidget, childWidget)
            if childWidget.type == "Window" then
                return thisWidget.Instance
            elseif childWidget.type == "Tooltip" then
                return thisWidget.Instance.PopupScreenGui.TooltipContainer
            else
                NumNonWindowChildren = NumNonWindowChildren + 1
                thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = true

                return thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow
            end
        end,
        ChildDiscarded = function(thisWidget, childWidget)
            if childWidget.type ~= "Window" then
                NumNonWindowChildren = NumNonWindowChildren - 1
                if NumNonWindowChildren == 0 then
                    thisWidget.Instance.PseudoWindowScreenGui.PseudoWindow.Visible = false
                end
            end
        end
    })
end
end)
__bundle_register("demoWindow", function(require, _LOADED, __bundle_register, __bundle_modules)
return function(Iris)
    local showMainWindow = Iris.State(true)
    local showRecursiveWindow = Iris.State(false)
    local showRuntimeInfo = Iris.State(false)
    local showStyleEditor = Iris.State(false)
    local showWindowlessDemo = Iris.State(false)

    local function helpMarker(helpText)
        Iris.PushConfig({TextColor = Iris._config.TextDisabledColor})
            Iris.Text({"(?)"})
        Iris.PopConfig()

        Iris.PushConfig({ContentWidth = UDim.new(0, 350)})
        if Iris.Events.hovered() then
            Iris.Tooltip({helpText})
        end
        Iris.PopConfig()
    end

    -- shows each widgets functionality
    local widgetDemos = {
        Basic = function()
            Iris.Tree({"Basic"})
                Iris.SameLine()
                    Iris.Text({"Simple, common widgets"})
                    helpMarker("The Widgets shown are, in order, Iris.Button, Iris.SmallButton, Iris.Text, Iris.TextWrapped, Iris.TextColored, and Iris.RadioButton")
                Iris.End()
				local radioButtonState = Iris.State(1)
                Iris.Button({"Button"})
                Iris.SmallButton({"SmallButton"})
                Iris.Text({"Text"})
                Iris.TextWrapped({string.rep("Text Wrapped ", 5)}) 
                Iris.TextColored({"Colored Text", Color3.fromRGB(255, 128, 0)})
				Iris.SameLine()
					Iris.RadioButton({"Index '1'", 1}, {index = radioButtonState})
					Iris.RadioButton({"Index 'two'", "two"}, {index = radioButtonState})
                    if Iris.RadioButton({"Index 'false'", false}, {index = radioButtonState}).active() == false then
                        if Iris.SmallButton({"Select last"}).clicked() then
                            radioButtonState:set(false)
                        end
                    end
				Iris.End()
				Iris.Text({"The Index is: " .. tostring(radioButtonState.value)})
            Iris.End()
        end,

        Tree = function()
            Iris.Tree({"Trees"})
                Iris.Tree({"Tree using SpanAvailWidth", [Iris.Args.Tree.SpanAvailWidth] = true})
                    helpMarker("SpanAvailWidth determines if the Tree is selectable from its entire with, or only the text area")
                Iris.End()

                local tree1 = Iris.Tree({"Tree with Children"})
                    Iris.Text({"Im inside the first tree!"})
                    Iris.Button({"Im a button inside the first tree!"})
                    Iris.Tree({"Im a tree inside the first tree!"})
                        Iris.Text({"I am the innermost text!"})
                    Iris.End()
                Iris.End()

                Iris.Checkbox({"Toggle above tree"}, {isChecked = tree1.state.isUncollapsed})
                
            Iris.End()
        end,

		CollapsingHeader = function()
			Iris.Tree({"Collapsing Headers"})
				Iris.CollapsingHeader({"A header"})
					Iris.Text({"This is under the first header!"})
				Iris.End()

				local secondHeader = Iris.State(true)
				Iris.CollapsingHeader({"Another header"}, { isUncollapsed = secondHeader })
					if Iris.Button({"Shhh... secret button!"}).clicked() then
						secondHeader:set(true)
					end
				Iris.End()
			Iris.End()
		end,

        Group = function()
            Iris.Tree({"Groups"})
                Iris.SameLine()
                    Iris.Group()
                        Iris.Text({"I am in group A"})
                        Iris.Button({"Im also in A"})
                    Iris.End()
                    Iris.Separator()
                    Iris.Group()
                        Iris.Text({"I am in group B"})
                        Iris.Button({"Im also in B"})
                        Iris.Button({"Also group B"})
                    Iris.End()
                Iris.End()
            Iris.End()
        end,

        Indent = function()
            Iris.Tree({"Indents"})
                Iris.Text({"Not Indented"})
                Iris.Indent()
                    Iris.Text({"Indented"})
                    Iris.Indent({7})
                        Iris.Text({"Indented by 7 more pixels"})
                    Iris.End()
                    Iris.Indent({-7})
                        Iris.Text({"Indented by 7 less pixels"})
                    Iris.End()
                Iris.End()
            Iris.End()
        end,

        Input = function()
            Iris.Tree({"Input"})
                local NoField, NoButtons, Min, Max, Increment, Format = 
                Iris.State(false), Iris.State(false), Iris.State(0), Iris.State(100), Iris.State(1), Iris.State("%d")

                Iris.PushConfig({ContentWidth = UDim.new(1, -120)})
                local InputNum = Iris.InputNum({"Input Number",
                    [Iris.Args.InputNum.NoField] = NoField.value,
                    [Iris.Args.InputNum.NoButtons] = NoButtons.value,
                    [Iris.Args.InputNum.Min] = Min.value,
                    [Iris.Args.InputNum.Max] = Max.value,
                    [Iris.Args.InputNum.Increment] = Increment.value,
                    [Iris.Args.InputNum.Format] = Format.value,
                })
                Iris.PopConfig()
                Iris.Text({"The Value is: " .. InputNum.number.value})
                if Iris.Button({"Randomize Number"}).clicked() then
                    InputNum.number:set(math.random(1,99))
                end
                local NoFieldCheckbox = Iris.Checkbox({"NoField"}, {isChecked = NoField})
                local NoButtonsCheckbox = Iris.Checkbox({"NoButtons"}, {isChecked = NoButtons})
                if NoFieldCheckbox.checked() and NoButtonsCheckbox.isChecked.value == true then
                    NoButtonsCheckbox.isChecked:set(false)
                end
                if NoButtonsCheckbox.checked() and NoFieldCheckbox.isChecked.value == true then
                    NoFieldCheckbox.isChecked:set(false)
                end

                Iris.PushConfig({ContentWidth = UDim.new(1, -120)})
                Iris.InputVector2({"InputVector2"})
                Iris.InputVector3({"InputVector3"})
                Iris.InputUDim({"InputUDim"})
                Iris.InputUDim2({"InputUDim2"})
                local UseFloats = Iris.State(false)
                local UseHSV = Iris.State(false)
                local sharedColor = Iris.State(Color3.new())
                local myColor3 = Iris.InputColor3({"InputColor3", UseFloats:get(), UseHSV:get()}, {color = sharedColor})
                local myColor4 = Iris.InputColor4({"InputColor4", UseFloats:get(), UseHSV:get()}, {color = sharedColor})
                Iris.SameLine()
                    Iris.Text({sharedColor:get():ToHex()})
                    Iris.Checkbox({"Use Floats"}, {isChecked = UseFloats})
                    Iris.Checkbox({"Use HSV"}, {isChecked = UseHSV})
                Iris.End()

                Iris.PopConfig()

                Iris.Separator()

                Iris.SameLine()
                    Iris.Text({"Slider Numbers"})
                    helpMarker("ctrl + click slider number widgets to input a number")
                Iris.End()
                Iris.PushConfig({ContentWidth = UDim.new(1, -120)})
                    Iris.SliderNum({"Slide Int", 1, 1, 8})
                    Iris.SliderNum({"Slide Float", 0.01, 0, 100})
                    Iris.SliderNum({"Small Numbers", 0.001, -2, 1, "%f radians"})
                    Iris.SliderNum({"Odd Ranges", 0.001, -math.pi, math.pi, "%f radians"})
                    Iris.SliderNum({"Big Numbers", 1e4, 1e5, 1e7})
                    Iris.SliderNum({"Few Numbers", 1, 0, 3})
                Iris.PopConfig()

                Iris.Separator()

                Iris.SameLine()
                    Iris.Text({"Drag Numbers"})
                    helpMarker("ctrl + click or double click drag number widgets to input a number, hold shift/alt while dragging to increase/decrease speed")
                Iris.End()
                Iris.PushConfig({ContentWidth = UDim.new(1, -120)})
                    Iris.DragNum({"Drag Int"})
                    Iris.DragNum({"Slide Float", 0.001, -10, 10})
                    Iris.DragNum({"Percentage", 1, 0, 100, "%d %%"})
                Iris.PopConfig()
            Iris.End()
        end,

        InputText = function()
            Iris.Tree({"Input Text"})
                Iris.PushConfig({ContentWidth = UDim.new(0, 250)})
                local InputText = Iris.InputText({"Input Text Test", [Iris.Args.InputText.TextHint] = "Input Text here"})
                Iris.PopConfig()
                Iris.Text({"The text is: " .. InputText.text.value})
            Iris.End()
        end,

        Tooltip = function()
            Iris.PushConfig({ContentWidth = UDim.new(0, 250)})
            Iris.Tree({"Tooltip"})
                if Iris.Text({"Hover over me to reveal a tooltip"}).hovered() then
                    Iris.Tooltip({"I am some helpful tooltip text"})
                end
                local dynamicText = Iris.State("Hello ")
                local numRepeat = Iris.State(1)
                if Iris.InputNum({"# of repeat", 1, 1, 50}, {number = numRepeat}).numberChanged() then
                    dynamicText:set(string.rep("Hello ", numRepeat:get()))
                end
                if Iris.Checkbox({"Show dynamic text tooltip"}).isChecked.value then
                    Iris.Tooltip({dynamicText:get()})
                end
            Iris.End()
            Iris.PopConfig()
        end,

        Selectable = function()
            Iris.Tree({"Selectable"})
                local sharedIndex = Iris.State(2)
                Iris.Selectable({"Selectable #1", 1}, {index = sharedIndex})
                Iris.Selectable({"Selectable #2", 2}, {index = sharedIndex})
                if Iris.Selectable({"Double click Selectable", 3, true}, {index = sharedIndex}).doubleClicked() then
                    sharedIndex:set(3)
                end
                Iris.Selectable({"Impossible to select", 4, true}, {index = sharedIndex})
                if Iris.Button({"Select last"}).clicked() then
                    sharedIndex:set(4)
                end
                Iris.Selectable({"Independent Selectable"})
            Iris.End()
        end,

        Combo = function()
            Iris.Tree({"Combo"})
                Iris.PushConfig({ContentWidth = UDim.new(1, -120)})
                    local sharedComboIndex = Iris.State("No Selection")
                    Iris.SameLine()
                        local NoPreview = Iris.Checkbox({"No Preview"})
                        local NoButton = Iris.Checkbox({"No Button"})
                        if NoPreview.checked() and NoButton.isChecked.value == true then
                            NoButton.isChecked:set(false)
                        end
                        if NoButton.checked() and NoPreview.isChecked.value == true then
                            NoPreview.isChecked:set(false)
                        end
                    Iris.End()
                    Iris.Combo({"Basic Usage", NoButton.isChecked:get(), NoPreview.isChecked:get()}, {index = sharedComboIndex})
                        Iris.Selectable({"Select 1", "One"}, {index = sharedComboIndex})
                        Iris.Selectable({"Select 2", "Two"}, {index = sharedComboIndex})
                        Iris.Selectable({"Select 3", "Three"}, {index = sharedComboIndex})
                    Iris.End()

                    Iris.ComboArray({"Using ComboArray"}, {index = "No Selection"}, {"Red", "Green", "Blue"})

                    local sharedComboIndex2 = Iris.State("7 AM")
                    Iris.Combo({"Combo with Inner widgets"}, {index = sharedComboIndex2})
                        Iris.Tree({"Morning Shifts"})
                            Iris.Selectable({"Shift at 7 AM", "7 AM"}, {index = sharedComboIndex2})
                            Iris.Selectable({"Shift at 11 AM", "11 AM"}, {index = sharedComboIndex2})
                            Iris.Selectable({"Shist at 3 PM", "3 PM"}, {index = sharedComboIndex2})
                        Iris.End()
                        Iris.Tree({"Night Shifts"})
                            Iris.Selectable({"Shift at 6 PM", "6 PM"}, {index = sharedComboIndex2})
                            Iris.Selectable({"Shift at 9 PM", "9 PM"}, {index = sharedComboIndex2})
                        Iris.End()
                    Iris.End()

                    local InputEnum = Iris.InputEnum({"Using InputEnum"}, {index = Enum.UserInputState.Begin}, Enum.UserInputState)
                    Iris.Text({"Selected: " .. InputEnum.index:get().Name})
                Iris.PopConfig()
            Iris.End()
        end
    }
    local widgetDemosOrder = {"Basic", "Tree", "CollapsingHeader", "Group", "Indent", "Input", "InputText", "Tooltip", "Selectable", "Combo"}

    local function recursiveTree()
        local theTree = Iris.Tree({"Recursive Tree"})
        if theTree.state.isUncollapsed.value then
            recursiveTree()
        end
        Iris.End()
    end

    local function recursiveWindow(parentCheckboxState)
        Iris.Window({"Recursive Window"}, {size = Iris.State(Vector2.new(150, 100)), isOpened = parentCheckboxState})
            local theCheckbox = Iris.Checkbox({"Recurse Again"})
        Iris.End()
        if theCheckbox.isChecked.value then
            recursiveWindow(theCheckbox.isChecked)
        end
    end

    -- shows list of runtime widgets and states, including IDs. shows other info about runtime and can show widgets/state info in depth.
    local function runtimeInfo()
        local runtimeInfoWindow = Iris.Window({"Runtime Info"}, {isOpened = showRuntimeInfo})
            local lastVDOM = Iris._lastVDOM
            local states = Iris._states

            local rollingDT = Iris.State(0)
            local lastT = Iris.State(os.clock())

            local t = os.clock()
            local dt = t - lastT.value
            rollingDT.value = rollingDT.value + (dt - rollingDT.value) * 0.2
            lastT.value = t
            Iris.Text({string.format("Average %.3f ms/frame (%.1f FPS)", rollingDT.value*1000, 1/rollingDT.value)})

            Iris.Text({string.format(
                "Window Position: (%d, %d), Window Size: (%d, %d)",
                runtimeInfoWindow.position.value.X, runtimeInfoWindow.position.value.Y,
                runtimeInfoWindow.size.value.X, runtimeInfoWindow.size.value.Y
            )})

            Iris.SameLine()
                Iris.Text({"Enter an ID to learn more about it."})
                helpMarker("every widget and state has an ID which Iris tracks to remember which widget is which. below lists all widgets and states, with their respective IDs")
            Iris.End()

            Iris.PushConfig({ItemWidth = UDim.new(1, -150)})
            local enteredText = Iris.InputText({"ID field"}, {text = Iris.State(runtimeInfoWindow.ID)}).text.value
            Iris.PopConfig()

            Iris.Indent()
                local enteredWidget = lastVDOM[enteredText]
                local enteredState = states[enteredText]
                if enteredWidget then
                    Iris.Table({1, [Iris.Args.Table.RowBg] = false})
                        Iris.Text({string.format("The ID, \"%s\", is a widget", enteredText)})
                        Iris.NextRow()

                        Iris.Text({string.format("Widget is type: %s", enteredWidget.type)})
                        Iris.NextRow()

                        Iris.Tree({"Widget has Args:"}, {isUncollapsed = Iris.State(true)})
                            for i,v in next, enteredWidget.arguments do
                                Iris.Text({i .. " - " .. tostring(v)})
                            end
                        Iris.End()
                        Iris.NextRow()

                        if enteredWidget.state then
                            Iris.Tree({"Widget has State:"}, {isUncollapsed = Iris.State(true)})
                            for i,v in next, enteredWidget.state do
                                Iris.Text({i .. " - " .. tostring(v.value)})
                            end
                            Iris.End()
                        end
                    Iris.End()

                elseif enteredState then
                    Iris.Table({1, [Iris.Args.Table.RowBg] = false})
                        Iris.Text({string.format("The ID, \"%s\", is a state", enteredText)})
                        Iris.NextRow()

                        Iris.Text({string.format("Value is type: %s, Value = %s", typeof(enteredState.value), tostring(enteredState.value))})
                        Iris.NextRow()

                        Iris.Tree({"state has connected widgets:"}, {isUncollapsed = Iris.State(true)})
                            for i,v in next, enteredState.ConnectedWidgets do
                                Iris.Text({i .. " - " .. v.type})
                            end
                        Iris.End()
                        Iris.NextRow()

                        Iris.Text({string.format("state has: %d connected functions", #enteredState.ConnectedFunctions)})
                    Iris.End()
                else
                    Iris.Text({string.format("The ID, \"%s\", is not a state or widget", enteredText)})
                end
            Iris.End()

            if Iris.Tree({"Widgets"}).isUncollapsed.value then
                local widgetCount = 0
                local widgetStr = ""
                for _, v in next, lastVDOM do
                    widgetCount = widgetCount + 1
                    widgetStr = widgetStr .. "\n" .. v.ID .. " - " .. v.type
                end

                Iris.Text({"Number of Widgets: " .. widgetCount})

                Iris.Text({widgetStr})
            end
            Iris.End()
            if Iris.Tree({"States"}).isUncollapsed.value then
                local stateCount = 0
                local stateStr = ""
                for i, v in next, states do
                    stateCount = stateCount + 1
                    stateStr = stateStr .. "\n" .. i .. " - " .. tostring(v.value)
                end

                Iris.Text({"Number of States: " .. stateCount})

                Iris.Text({stateStr})
            end
            Iris.End()
        Iris.End()
    end

    -- allows users to edit state
    local styleEditor
    do
        styleEditor = function()
            local selectedPanel = Iris.State(1)

            local styleList = {
                {"Sizing", function()
                    local UDims = {"ItemWidth", "ContentWidth"}
                    for _, vUDim in next, UDims do
                        local Input = Iris.InputUDim({vUDim}, {number = Iris.WeakState(Iris._config[vUDim])})
                        if Input.numberChanged() then
                            Iris.UpdateGlobalConfig({[vUDim] = Input.number:get()})
                        end
                    end

                    local Vector2s = {
                        "WindowPadding",
                        "WindowResizePadding",
                        "FramePadding",
                        "ItemSpacing",
                        "ItemInnerSpacing",
                        "CellPadding",
                        "DisplaySafeAreaPadding",
                    }
                    for _, vVector2 in next, Vector2s do
                        local Input = Iris.InputVector2({vVector2}, {number = Iris.WeakState(Iris._config[vVector2])})
                        if Input.numberChanged() then
                            Iris.UpdateGlobalConfig({[vVector2] = Input.number:get()})
                        end
                    end

                    local Numbers = {
                        "TextSize",
                        "FrameBorderSize",
                        "FrameRounding",
                        "GrabRounding",
                        "WindowBorderSize",
                        "PopupBorderSize",
                        "PopupRounding",
                        "ScrollbarSize",
                        "GrabMinSize"
                    }
                    for _, vNumber in next, Numbers do
                        local Input = Iris.InputNum({vNumber}, {number = Iris.WeakState(Iris._config[vNumber])})
                        if Input.numberChanged() then
                            Iris.UpdateGlobalConfig({[vNumber] = Input.number:get()})
                        end
                    end

                    local Enums = {"WindowTitleAlign", "TextFont"}
                    for _, vEnum in next, Enums do
                        local Input = Iris.InputEnum({vEnum}, {index = Iris.WeakState(Iris._config[vEnum])}, Iris._config[vEnum].EnumType)
                        if Input.closed() then
                            Iris.UpdateGlobalConfig({[vEnum] = Input.index:get()})
                        end
                    end
                end},
                {"Colors", function()
                    local color3s = {"BorderColor", "BorderActiveColor"}

                    for _, vColor in next, color3s do
                        local Input = Iris.InputColor3({vColor}, {color = Iris.WeakState(Iris._config[vColor])})
                        if Input.numberChanged() then
                            Iris.UpdateGlobalConfig({[vColor] = Input.color:get()})
                        end
                    end

                    local color4s = {
                        "Text",
                        "TextDisabled",
                        "WindowBg",
                        "ScrollbarGrab",
                        "TitleBg",
                        "TitleBgActive",
                        "TitleBgCollapsed",
                        "MenubarBg",
                        "FrameBg",
                        "FrameBgHovered",
                        "FrameBgActive",
                        "Button",
                        "ButtonHovered",
                        "ButtonActive",
                        "SliderGrab",
                        "SliderGrabActive",
                        "Header",
                        "HeaderHovered",
                        "HeaderActive",
                        "SelectionImageObject",
                        "SelectionImageObjectBorder",
                        "TableBorderStrong",
                        "TableBorderLight",
                        "TableRowBg",
                        "TableRowBgAlt",
                        "NavWindowingHighlight",
                        "NavWindowingDimBg",
                        "Separator",
                        "CheckMark"
                    }

                    for _, vColor in next, color4s do
                        local Input = Iris.InputColor4({vColor},
                            {
                                color = Iris.WeakState(Iris._config[vColor.."Color"]),
                                transparency = Iris.WeakState(Iris._config[vColor.."Transparency"])
                            }
                        )
                        if Input.numberChanged() then
                            Iris.UpdateGlobalConfig({
                                [vColor.."Color"] = Input.color:get(),
                                [vColor.."Transparency"] = Input.transparency:get()
                            })
                        end
                    end
                end},
            }
    
            Iris.Window({"Style Editor"}, {isOpened = showStyleEditor})
                Iris.Text({"Customize the look of Iris in realtime."})
                Iris.SameLine()
                    if Iris.SmallButton({"Light Theme"}).clicked() then
                        Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorLight)
                    end
                    if Iris.SmallButton({"Dark Theme"}).clicked() then
                        Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark)
                    end
                Iris.End()
                Iris.SameLine()
                    if Iris.SmallButton({"Classic Size"}).clicked() then
                        Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeDefault)
                    end
                    if Iris.SmallButton({"Larger Size"}).clicked() then
                        Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear)
                    end
                Iris.End()
                if Iris.SmallButton({"Reset Everything"}).clicked() then
                    Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark)
                    Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeDefault)
                end
                Iris.Separator()
                Iris.SameLine()
                    for i, v in ipairs(styleList) do
                        Iris.RadioButton({v[1], i}, {index = selectedPanel})
                    end
                Iris.End()
                styleList[selectedPanel:get()][2]()
            Iris.End()
        end
    end

    -- showcases how events can be used
    local function widgetEventInteractivity()
        Iris.CollapsingHeader({"Widget Event Interactivity"})
            local clickCount = Iris.State(0)
            if Iris.Button({"Click to increase Number"}).clicked() then
                clickCount:set(clickCount:get() + 1)
            end
            Iris.Text({"The Number is: " .. clickCount:get()})

            Iris.Separator()

            local showEventText = Iris.State(false)
            local selectedEvent = Iris.State("clicked")
            Iris.SameLine()
                Iris.RadioButton({"clicked", "clicked"}, {index = selectedEvent})
                Iris.RadioButton({"rightClicked", "rightClicked"}, {index = selectedEvent})
                Iris.RadioButton({"doubleClicked", "doubleClicked"}, {index = selectedEvent})
                Iris.RadioButton({"ctrlClicked", "ctrlClicked"}, {index = selectedEvent})
            Iris.End()
            Iris.SameLine()
                if Iris.Button({selectedEvent:get() .. " to reveal text"})[selectedEvent:get()]() then
                    showEventText:set(not showEventText:get())
                end
                if showEventText:get() then
                    Iris.Text({"Here i am!"})
                end
            Iris.End()

            Iris.Separator()

            local showTextTimer = Iris.State(0)
            Iris.SameLine()
                if Iris.Button({"Click to show text for 20 frames"}).clicked() then
                    showTextTimer:set(20)
                end
                if showTextTimer:get() > 0 then
                    Iris.Text({"Here i am!"})
                end
            Iris.End()
            showTextTimer:set(math.max(0, showTextTimer:get() - 1))
            Iris.Text({"Text Timer: " .. showTextTimer:get()})

            local checkbox0 = Iris.Checkbox({"Event-tracked checkbox"})
            Iris.Indent()
                Iris.Text({"unchecked: " .. tostring(checkbox0.unchecked())})
                Iris.Text({"checked: " .. tostring(checkbox0.checked())})
            Iris.End()
            Iris.SameLine()
            if Iris.Button({"Hover over me"}).hovered() then
                Iris.Text({"The button is hovered"})
            end
            Iris.End()
        Iris.End()
    end

    -- showcases how state can be used
    local function widgetStateInteractivity()
        Iris.CollapsingHeader({"Widget State Interactivity"})
            local checkbox0 = Iris.Checkbox({"Widget-Generated State"})
            local _msg = "isChecked: %s\n"
            -- Iris.Text({`isChecked: {checkbox0.state.isChecked.value}\n`})
            Iris.Text({_msg:format(tostring(checkbox0.state.isChecked.value))})
            
            local checkboxState0 = Iris.State(false)
            local checkbox1 = Iris.Checkbox({"User-Generated State"}, {isChecked = checkboxState0})
            Iris.Text({_msg:format(tostring(checkbox1.state.isChecked.value))})

            local checkbox2 = Iris.Checkbox({"Widget Coupled State"})
            local checkbox3 = Iris.Checkbox({"Coupled to above Checkbox"}, {isChecked = checkbox2.state.isChecked})
            Iris.Text({_msg:format(tostring(checkbox3.state.isChecked.value))})

            local checkboxState1 = Iris.State(false)
            local checkbox4 = Iris.Checkbox({"Widget and Code Coupled State"}, {isChecked = checkboxState1})
            local Button0 = Iris.Button({"Click to toggle above checkbox"})
            if Button0.clicked() then
                checkboxState1:set(not checkboxState1:get())
            end
            Iris.Text({_msg:format(tostring(checkboxState1.value))})

            local checkboxState2 = Iris.State(true)
            local checkboxState3 = Iris.ComputedState(checkboxState2, function(newValue)
                return not newValue
            end)
            local checkbox5 = Iris.Checkbox({"ComputedState (dynamic coupling)"}, {isChecked = checkboxState2})
            local checkbox5 = Iris.Checkbox({"Inverted of above checkbox"}, {isChecked = checkboxState3})
            Iris.Text({_msg:format(tostring(checkboxState3.value))})


        Iris.End()
    end

    -- showcases how dynamic styles can be used
    local function dynamicStyle()
        Iris.CollapsingHeader({"Dynamic Styles"})
            local colorH = Iris.State(0)
            Iris.SameLine()
            if Iris.Button({"Change Color"}).clicked() then
                colorH:set(math.random())
            end
            Iris.Text({"Hue: " .. math.floor(colorH:get() * 255)})
            helpMarker("Using PushConfig with a changing value, this can be done with any config field")
            Iris.End()
            Iris.PushConfig({TextColor = Color3.fromHSV(colorH:get(), 1, 1)})
                Iris.Text({"Text with a unique and changable color"})
            Iris.PopConfig()
        Iris.End()
    end

    -- showcases how tables can be used
    local function tablesDemo()
        local showTablesTree = Iris.State(false)

        Iris.CollapsingHeader({"Tables & Columns"}, {isUncollapsed = showTablesTree})
        if showTablesTree.value == false then
            -- optimization to skip code which draws GUI which wont be seen.
            -- its a trade off because when the tree becomes opened widgets will all have to be generated again.
            -- Dear ImGui utilizes the same trick, but its less useful here because the Retained mode Backend
        Iris.End()
        else
            Iris.SameLine()
                Iris.Text({"Table using NextRow and NextColumn syntax:"})
                helpMarker("calling Iris.NextRow() in the outer loop, and Iris.NextColumn()in the inner loop")
            Iris.End()
            Iris.Table({3})
                for i = 1, 4 do
                    Iris.NextRow()
                    for i2 = 1, 3 do
                        Iris.NextColumn()
                        -- Iris.Text({`Row: {i}, Column: {i2}`})
                        local _msg = "Row: %s, Column: %s"
                        Iris.Text({_msg:format(tostring(i), tostring(i2))})
                    end
                end
            Iris.End()

            Iris.Text({""})

            Iris.SameLine()
                Iris.Text({"Table using NextColumn only syntax:"})
                helpMarker("only calling Iris.NextColumn() in the inner loop, the result is identical")
            Iris.End()

            Iris.Table({2})
                for i = 1, 4 do
                    for i2 = 1, 2 do
                        Iris.NextColumn()
                        local _msg = "Row: %s, Column: %s"
                        -- Iris.Text({`Row: {i}, Column: {i2}`})
                        Iris.Text({_msg:format(tostring(i), tostring(i2))})
                    end
                end
            Iris.End()

            Iris.Separator()

            local TableRowBg = Iris.State(false)
            local TableBordersOuter = Iris.State(false)
            local TableBordersInner = Iris.State(true)
            local TableUseButtons = Iris.State(true)
            local TableNumRows = Iris.State(3)

            Iris.Text({"Table with Customizable Arguments"})
            Iris.Table({
                4,
                [Iris.Args.Table.RowBg] = TableRowBg.value,
                [Iris.Args.Table.BordersOuter] = TableBordersOuter.value,
                [Iris.Args.Table.BordersInner] = TableBordersInner.value
            })
                for i = 1, TableNumRows:get() do
                    for i2 = 1, 4 do
                        Iris.NextColumn();
                        if TableUseButtons.value then
                            local _msg = "Month: %s, Week: %s"
                            Iris.Button({_msg:format(tostring(i), tostring(i2))})
                        else
                            local _msg = "Month: %s, Week: %s"
                            Iris.Text({_msg:format(tostring(i), tostring(i2))})
                        end
                    end
                end
            Iris.End()

            Iris.Checkbox({"RowBg"}, {isChecked = TableRowBg})
            Iris.Checkbox({"BordersOuter"}, {isChecked = TableBordersOuter})
            Iris.Checkbox({"BordersInner"}, {isChecked = TableBordersInner})
            Iris.SameLine()
                Iris.RadioButton({"Buttons", true}, {index = TableUseButtons})
                Iris.RadioButton({"Text", false}, {index = TableUseButtons})
            Iris.End()
            Iris.InputNum(
                {
                    "Number of rows",
                    [Iris.Args.InputNum.Min] = 0,
                    [Iris.Args.InputNum.Max] = 100,
                    [Iris.Args.InputNum.Format] = "%d",
                    [Iris.Args.InputNum.NoField] = true
                }, 
                {number = TableNumRows}
            )

        Iris.End()
        end
    end

	local function layoutDemo()
		Iris.CollapsingHeader({"Widget Layout"})
			Iris.Tree({"Content Width"})
				local value = Iris.State(50)
				local index = Iris.State(Enum.Axis.X)

				Iris.Text({"The Content Width is a size property which determines the width of input fields."})
				Iris.SameLine()
					Iris.Text({"By default the value is UDim.new(0.65, 0)"})
					helpMarker("This is the default value from Dear ImGui.\nIt is 65% of the window width.")
				Iris.End()
				Iris.Text({"This works well, but sometimes we know how wide elements are going to be and want to maximise the space."})
				Iris.Text({"Therefore, we can use Iris.PushConfig() to change the width"})

				Iris.Separator()

				Iris.SameLine()
					Iris.Text({"Content Width = 150 pixels"})
					helpMarker("UDim.new(0, 150)")
				Iris.End()
				Iris.PushConfig({ContentWidth = UDim.new(0, 150)})
					Iris.DragNum({"number", 1, 0, 100}, {number = value})
					Iris.InputEnum({"axis"}, {index = index}, Enum.Axis)
				Iris.PopConfig()

				Iris.SameLine()
					Iris.Text({"Content Width = 50% window width"})
					helpMarker("UDim.new(0.5, 0)")
				Iris.End()
				Iris.PushConfig({ContentWidth = UDim.new(0.5, 0)})
					Iris.DragNum({"number", 1, 0, 100}, {number = value})
					Iris.InputEnum({"axis"}, {index = index}, Enum.Axis)
				Iris.PopConfig()

				Iris.SameLine()
					Iris.Text({"Content Width = -150 pixels from the right side"})
					helpMarker("UDim.new(1, -150)")
				Iris.End()
				Iris.PushConfig({ContentWidth = UDim.new(1, -150)})
					Iris.DragNum({"number", 1, 0, 100}, {number = value})
					Iris.InputEnum({"axis"}, {index = index}, Enum.Axis)
				Iris.PopConfig()
			Iris.End()
		Iris.End()
	end	

    -- showcases how widgets placed outside of a window are placed inside root
    local function windowlessDemo()
        Iris.PushConfig({ItemWidth = UDim.new(0, 150)})
            Iris.SameLine()
                Iris.TextWrapped({"Windowless widgets"})
                helpMarker("Widgets which are placed outside of a window will appear on the top left side of the screen.")
            Iris.End()
            Iris.Button()
            Iris.Tree()
                Iris.InputText()
            Iris.End()
        Iris.PopConfig()
    end

    -- main demo window
    return function()
        local NoTitleBar = Iris.State(false)
        local NoBackground = Iris.State(false)
        local NoCollapse = Iris.State(false)
        local NoClose = Iris.State(true)
        local NoMove = Iris.State(false)
        local NoScrollbar = Iris.State(false)
        local NoResize = Iris.State(false)
        local NoNav = Iris.State(false)

        if showMainWindow.value == false then
            Iris.Checkbox({"Open main window"}, {isChecked = showMainWindow})
            return
        end

        Iris.Window({"Iris Demo Window",
            [Iris.Args.Window.NoTitleBar] = NoTitleBar.value,
            [Iris.Args.Window.NoBackground] = NoBackground.value,
            [Iris.Args.Window.NoCollapse] = NoCollapse.value,
            [Iris.Args.Window.NoClose] = NoClose.value,
            [Iris.Args.Window.NoMove] = NoMove.value,
            [Iris.Args.Window.NoScrollbar] = NoScrollbar.value,
            [Iris.Args.Window.NoResize] = NoResize.value,
            [Iris.Args.Window.NoNav] = NoNav.value
        }, {size = Iris.State(Vector2.new(600, 550)), position = Iris.State(Vector2.new(100, 25)), isOpened = showMainWindow})

            Iris.Text{"Iris says hello. (2.0.4)"}
            Iris.Separator()

            Iris.Table({3, false, false, false})
                Iris.NextColumn()
                Iris.Checkbox({"Recursive Window"}, {isChecked = showRecursiveWindow})
                Iris.NextColumn()
                Iris.Checkbox({"Runtime Info"}, {isChecked = showRuntimeInfo})
                Iris.NextColumn()
                Iris.Checkbox({"Style Editor"}, {isChecked = showStyleEditor})
                Iris.NextColumn()
                Iris.Checkbox({"Windowless"}, {isChecked = showWindowlessDemo})
            Iris.End()

            Iris.Separator()

            Iris.CollapsingHeader({"Window Options"})
                Iris.Table({3, false, false, false})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoTitleBar"}, {isChecked = NoTitleBar})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoBackground"}, {isChecked = NoBackground})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoCollapse"}, {isChecked = NoCollapse})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoClose"}, {isChecked = NoClose})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoMove"}, {isChecked = NoMove})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoScrollbar"}, {isChecked = NoScrollbar})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoResize"}, {isChecked = NoResize})
                    Iris.NextColumn()
                    Iris.Checkbox({"NoNav"}, {isChecked = NoNav})
                Iris.End()
            Iris.End()

            widgetEventInteractivity()

            widgetStateInteractivity()

			Iris.CollapsingHeader({"Recursive Tree"})
            	recursiveTree()
			Iris.End()

            dynamicStyle()

            Iris.Separator()

            Iris.CollapsingHeader({"Widgets"})
                for _, name in next, widgetDemosOrder do
                    widgetDemos[name]()
                end
            Iris.End()

            tablesDemo()

			layoutDemo()
        Iris.End()

        if showRecursiveWindow.value then
            recursiveWindow(showRecursiveWindow)
        end
        if showRuntimeInfo.value then
            runtimeInfo()
        end
        if showStyleEditor.value then
            styleEditor()
        end
        if showWindowlessDemo.value then
            windowlessDemo()
        end
    end
end
end)
__bundle_register("config", function(require, _LOADED, __bundle_register, __bundle_modules)
local TemplateConfig = {
    colorDark = { -- Dear, ImGui default dark
        TextColor = Color3.fromRGB(255, 255, 255),
        TextTransparency = 0,
        TextDisabledColor = Color3.fromRGB(128, 128, 128),
        TextDisabledTransparency = 0,

        BorderColor = Color3.fromRGB(110, 110, 125), 
        -- Dear ImGui uses 110, 110, 125
        -- The Roblox window selection highlight is 67, 191, 254
        BorderActiveColor = Color3.fromRGB(160, 160, 175), -- does not exist in Dear ImGui

        BorderTransparency = 0, 
        BorderActiveTransparency = 0,
        -- BorderTransparency will be problematic for non UIStroke border implimentations
        -- is not implimented because of this

        WindowBgColor = Color3.fromRGB(15, 15, 15),
        WindowBgTransparency = 0.072,

        ScrollbarGrabColor = Color3.fromRGB(128, 128, 128),
        ScrollbarGrabTransparency = 0,

        TitleBgColor = Color3.fromRGB(10, 10, 10),
        TitleBgTransparency = 0,
        TitleBgActiveColor = Color3.fromRGB(41, 74, 122),
        TitleBgActiveTransparency = 0,
        TitleBgCollapsedColor = Color3.fromRGB(0, 0, 0),
        TitleBgCollapsedTransparency = 0.5,

		MenubarBgColor = Color3.fromRGB(36, 36, 36),
		MenubarBgTransparency = 0,

        FrameBgColor = Color3.fromRGB(41, 74, 122),
        FrameBgTransparency = 0.46,
        FrameBgHoveredColor = Color3.fromRGB(66, 150, 250),
        FrameBgHoveredTransparency = 0.46,
        FrameBgActiveColor = Color3.fromRGB(66, 150, 250),
        FrameBgActiveTransparency = 0.33,

        ButtonColor = Color3.fromRGB(66, 150, 250),
        ButtonTransparency = 0.6,
        ButtonHoveredColor = Color3.fromRGB(66, 150, 250),
        ButtonHoveredTransparency = 0,
        ButtonActiveColor = Color3.fromRGB(15, 135, 250),
        ButtonActiveTransparency = 0,

        SliderGrabColor = Color3.fromRGB(66, 150, 250),
        SliderGrabTransparency = 0,
        SliderGrabActiveColor = Color3.fromRGB(117, 138, 204),
        SliderGrabActiveTransparency = 0,

        HeaderColor = Color3.fromRGB(66, 150, 250),
        HeaderTransparency = 0.69,
        HeaderHoveredColor = Color3.fromRGB(66, 150, 250),
        HeaderHoveredTransparency = 0.2,
        HeaderActiveColor = Color3.fromRGB(66, 150, 250),
        HeaderActiveTransparency = 0,

        SelectionImageObjectColor = Color3.fromRGB(255, 255, 255),
        SelectionImageObjectTransparency = 0.8,
        SelectionImageObjectBorderColor = Color3.fromRGB(255, 255, 255),
        SelectionImageObjectBorderTransparency = 0,

        TableBorderStrongColor = Color3.fromRGB(79, 79, 89),
        TableBorderStrongTransparency = 0,
        TableBorderLightColor = Color3.fromRGB(59, 59, 64),
        TableBorderLightTransparency = 0,
        TableRowBgColor = Color3.fromRGB(0, 0, 0),
        TableRowBgTransparency = 1,
        TableRowBgAltColor = Color3.fromRGB(255, 255, 255),
        TableRowBgAltTransparency = 0.94,

        NavWindowingHighlightColor = Color3.fromRGB(255, 255, 255),
        NavWindowingHighlightTransparency = 0.3,
        NavWindowingDimBgColor = Color3.fromRGB(204, 204, 204),
        NavWindowingDimBgTransparency = 0.65,

        SeparatorColor = Color3.fromRGB(110, 110, 128),
        SeparatorTransparency = 0.5,

        CheckMarkColor = Color3.fromRGB(66, 150, 250),
        CheckMarkTransparency = 0
    },
    colorLight = { -- Dear, ImGui default light
        TextColor = Color3.fromRGB(0, 0, 0),
        TextTransparency = 0,
        TextDisabledColor = Color3.fromRGB(153, 153, 153),
        TextDisabledTransparency = 0,

        BorderColor = Color3.fromRGB(64, 64, 64),
        -- Dear ImGui uses 0, 0, 0, 77
        -- The Roblox window selection highlight is 67, 191, 254
        BorderActiveColor = Color3.fromRGB(64, 64, 64), -- does not exist in Dear ImGui

        -- BorderTransparency = 0.5,
        -- BorderTransparency will be problematic for non UIStroke border implimentations
        -- will not be implimented because of this

        WindowBgColor = Color3.fromRGB(240, 240, 240),
        WindowBgTransparency = 0,

        TitleBgColor = Color3.fromRGB(245, 245, 245),
        TitleBgTransparency = 0,
        TitleBgActiveColor = Color3.fromRGB(209, 209, 209),
        TitleBgActiveTransparency = 0,
        TitleBgCollapsedColor = Color3.fromRGB(255, 255, 255),
        TitleBgCollapsedTransparency = 0.5,

		MenubarBgColor = Color3.fromRGB(219, 219, 219),
		MenubarBgTransparency = 0,

        ScrollbarGrabColor = Color3.fromRGB(96, 96, 96),
        ScrollbarGrabTransparency = 0,

        FrameBgColor = Color3.fromRGB(255, 255, 255),
        FrameBgTransparency = 0.6,
        FrameBgHoveredColor = Color3.fromRGB(66, 150, 250),
        FrameBgHoveredTransparency = 0.6,
        FrameBgActiveColor = Color3.fromRGB(66, 150, 250),
        FrameBgActiveTransparency = 0.33,

        ButtonColor = Color3.fromRGB(66, 150, 250),
        ButtonTransparency = 0.6,
        ButtonHoveredColor = Color3.fromRGB(66, 150, 250),
        ButtonHoveredTransparency = 0,
        ButtonActiveColor = Color3.fromRGB(15, 135, 250),
        ButtonActiveTransparency = 0,

        HeaderColor = Color3.fromRGB(66, 150, 250),
        HeaderTransparency = 0.31,
        HeaderHoveredColor = Color3.fromRGB(66, 150, 250),
        HeaderHoveredTransparency = 0.2,
        HeaderActiveColor = Color3.fromRGB(66, 150, 250),
        HeaderActiveTransparency = 0,

        SliderGrabColor = Color3.fromRGB(61, 133, 224),
        SliderGrabTransparency = 0,
        SliderGrabActiveColor = Color3.fromRGB(66, 150, 250),
        SliderGrabActiveTransparency = 0,

        SelectionImageObjectColor = Color3.fromRGB(0, 0, 0),
        SelectionImageObjectTransparency = 0.8,
        SelectionImageObjectBorderColor = Color3.fromRGB(0, 0, 0),
        SelectionImageObjectBorderTransparency = 0,

        TableBorderStrongColor = Color3.fromRGB(145, 145, 163),
        TableBorderStrongTransparency = 0,
        TableBorderLightColor = Color3.fromRGB(173, 173, 189),
        TableBorderLightTransparency = 0,
        TableRowBgColor = Color3.fromRGB(0, 0, 0),
        TableRowBgTransparency = 1,
        TableRowBgAltColor = Color3.fromRGB(77, 77, 77),
        TableRowBgAltTransparency = 0.91,

        NavWindowingHighlightColor = Color3.fromRGB(179, 179, 179),
        NavWindowingHighlightTransparency = 0.3,
        NavWindowingDimBgColor = Color3.fromRGB(51, 51, 51),
        NavWindowingDimBgTransparency = 0.8,

        SeparatorColor = Color3.fromRGB(99, 99, 99),
        SeparatorTransparency = 0.38,
        
        CheckMarkColor = Color3.fromRGB(66, 150, 250),
        CheckMarkTransparency = 0
    },

    sizeDefault = { -- Dear, ImGui default
        ItemWidth = UDim.new(1, 0),
        ContentWidth = UDim.new(0.65, 0),

        WindowPadding = Vector2.new(8, 8),
        WindowResizePadding = Vector2.new(6, 6),
        FramePadding = Vector2.new(4, 3),
        ItemSpacing = Vector2.new(8, 4),
        ItemInnerSpacing = Vector2.new(4, 4),
        CellPadding = Vector2.new(4, 2),
        DisplaySafeAreaPadding = Vector2.new(0, 0),
        IndentSpacing = 21,

        TextFont = Enum.Font.Code,
        TextSize = 13,
        FrameBorderSize = 0,
        FrameRounding = 0,
        GrabRounding = 0,
        WindowBorderSize = 1,
        WindowTitleAlign = Enum.LeftRight.Left,
        PopupBorderSize = 1,
        PopupRounding = 0,
        ScrollbarSize = 7,
        GrabMinSize = 10,
    },
    sizeClear = { -- easier to read and manuveure
        ItemWidth = UDim.new(1, 0),
        ContentWidth = UDim.new(0.65, 0),

        WindowPadding = Vector2.new(12, 8),
        WindowResizePadding = Vector2.new(8, 8),
        FramePadding = Vector2.new(6, 4),
        ItemSpacing = Vector2.new(8, 8),
        ItemInnerSpacing = Vector2.new(8, 8),
        CellPadding = Vector2.new(4, 4),
        DisplaySafeAreaPadding = Vector2.new(8, 8),
        IndentSpacing = 25,

        TextFont = Enum.Font.Ubuntu,
        TextSize = 15,
        FrameBorderSize = 1,
        FrameRounding = 4,
        GrabRounding = 4,
        WindowBorderSize = 1,
        WindowTitleAlign = Enum.LeftRight.Center,
        PopupBorderSize = 1,
        PopupRounding = 4,
        ScrollbarSize = 9,
        GrabMinSize = 14,
    },

    utilityDefault = {
        UseScreenGUIs = true,
        Parent = nil,
        DisplayOrderOffset = 127,
        ZIndexOffset = 0,

        MouseDoubleClickTime = 0.30, -- Time for a double-click, in seconds.
        MouseDoubleClickMaxDist = 6.0, -- Distance threshold to stay in to validate a double-click, in pixels.
    }
}

return TemplateConfig
end)
return __bundle_require("__root")
