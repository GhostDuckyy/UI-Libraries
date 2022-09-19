# ReadMe
drawing api ui lib made by **coolmat72** (coolmatt72#6707) & **walter**

### Preview
[Video](https://streamable.com/vkrrix)

### Documentation
```lua
library.new(table)
table = {
	size = vector2
	name = string
	mousedisable = bool
}
--
library.newtab(table)
table = {
	name = string
}
--
library.newsection(table)
table = {
	name = string
	tab = instance
	side = "right" / "left"
	size = number (y size of section)
}
--
library.newbutton(table)
table = {
	name = string
	section = instance
	tab = instance
	callback = function
}
--
library.newtoggle(table)
table = {
	name = string
	section = instance
	tab = instance
	callback = function
}
--
library.newslider(table)
table = {
	name = string
	ended = bool
	min = number
	max = number
	def = number
	section = instance
	tab = instance
	callback = function
}
--
library.newtextbox(table)
table = {
	name = string
	section = instance
	lower = bool
	tab = instance
	callback = function
}
--
library.newdropdown(table)
table = {
	name = string
	options = table
	section = instance
	tab = instance
	callback = function
}
--
library.newcolorpicker(table)
table = {
	name = string
	def = Color3
	transp = number
	section = instance
	tab = instance
	transparency = bool
	callback = function
}
```
