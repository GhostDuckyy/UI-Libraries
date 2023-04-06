# Luminosity Interface
Luminosity Interface never uses Methods for class creation; Methods (such as Array:Function()) are almost always exclusively for functions that operate on the instance, instead, for element creation, it always looks like: Luminosity.new().

## Classes
#### Window
```
Luminosity.new(Title, Header, Icon)
```
#### Tab
```
Window.Tab(Title, Icon)
```
#### Container
```
Tab.Folder(Title, Value)
```
```
Tab.Cheat(Title, Value)
```
#### Options
```
Container.TextLabel(Text)
```
```
Container.Button(Text, Callback)
```
```
Container.Switch(Text, Callback)
```
```
Container.Toggle(Text, Callback)
```
```
Container.Textbox(Text, PlaceHolder, Callback)
```
