local Colors={}
Colors.black=0x000000
Colors.lightGray=0xE1E1E1
Colors.gray=0xA9A9A9
Colors.lightBlue=0x00B6FF
Colors.white=0xFFFFFF
Colors.magenta=0xFF00FF
Colors.yellow=0xFFFF00
Colors.green=0x00FF00
Colors.darkGreen=0x008000
Colors.blue=0x0000ff
Colors.red=0xFF0000
Colors.orange=0xFFA500
Colors.brown=0xA52A2A
Colors.lightRed=0xF00000
Colors.darkGray=0x202020
Colors.mainBackground=0x008080

local Button = {
	x = 1,
	y = 1,
	w = 10,
	h = 1,
	text = "",
	clicked = false,
	active = false
}

function Button:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local CheckBox = {
	x = 1,
	y = 1,
	w = 1,
	h = 1,
	text = "",
	checked = false,
	active = false
}

function CheckBox:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local RadioButton = {
	x = 1,
	y = 1,
	w = 1,
	h = 1,
	text = "",
	checked = false,
	active = false
}

function RadioButton:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local ComboBox = {
	x = 1,
	y = 1,
	w = 10,
	h = 1,
	text = "",
	active = false
}

function ComboBox:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local ListBox = {
	x = 1,
	y = 1,
	w = 10,
	h = 1,
	text = "",
	active = false
}

function ListBox:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local ProgressBar = {
	x = 1,
	y = 1,
	w = 10,
	h = 1,
	text = "",
	active = false
}

function ProgressBar:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local Slider = {
	x = 1,
	y = 1,
	w = 10,
	h = 1,
	text = "",
	active = false
}

function Slider:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local Label = {
	x = 1,
	y = 1,
	w = 10,
	h = 1,
	text = "",
	active = false
}

function Label:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local TextBox = { 
	x = 1,
	y = 1,
	w = 10,
	text = "",
	placeholder = "",
	cursorPos = 1,
	focused = false,
	active = false	
}

function TextBox:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end