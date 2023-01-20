local event = require("event")
local keyboard = require("keyboard")
local term = require("term")
local gpu = require("component").gpu
local unicode = require("unicode")
local computer = require("computer")

-- element classes:
-- Colors
-- Button
-- Label
-- TextBox

local Colors = {}
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
	type = "button",
	x = 1,
	y = 1,
	h = 1,
	text = "",
	clicked = false,
	active = false,
	button = 0
}

function Button:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.text = "["..o.text.."]"
	o.w = #o.text
	gui.objects[#gui.objects + 1] = o
	return #gui.objects
end

function Button:draw()
	gpu.setBackground(Colors.gray)
	gpu.setForeground(Colors.black)
	gpu.set(self.x, self.y, self.text)
end

function Button:isClicked(x, y, button)
	if self.button == button and x >= self.x and x <= self.x - 1 + self.w 
	and y >= self.y and y <= self.y - 1 + self.h then
		return true
	end
	return false
end

local Label = {
	type = "label",
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
	type = "textbox",
	x = 1,
	y = 1,
	s = 1,
	h = 1,
	text = " ",
	placeholder = "",
	cursorPos = 1,
	inputPos = 1,
	focused = false,
	active = false
}

function TextBox:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	o.w = o.s + 2
	gui.objects[#gui.objects + 1] = o
	return #gui.objects
end

function TextBox:draw()
	gpu.setBackground(Colors.gray)
	gpu.setForeground(Colors.black)
	local message = ""
	for i = 1, self.s - #self.text do
		message = message.." "
	end
	message = self.text..message
	message = message:sub(self.inputPos, self.inputPos + self.s)
	gpu.set(self.x, self.y, "["..message.."]")
	if self.focused then
		if computer.uptime() % 1 >= 0.5 then
			gpu.set(self.x + self.cursorPos, self.y, unicode.char(9144))
		end
	end
end

function TextBox:isClicked(x, y, button)
	if x >= self.x and x <= self.x - 1 + self.w 
	and y >= self.y and y <= self.y - 1 + self.h then
		return true
	end
	return false
end
-- print(message:sub(pos, pos+sizeInput))

function TextBox:insert(str1, str2, pos)
	return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

function TextBox:handleKey(code)
	local keyStr = keyboard.keys[code]
	local add = 1
	if keyStr == "space" then
		keyStr = " "
	end
	if keyStr == "back" then
		keyStr = ""
		self.text = self.text:sub(1, #self.text - 2)
		self.text = self.text.." "
		if self.cursorPos > 1 then
			add = -1
		end
	end
	if keyStr == "enter" then
		output = self.text
		keyStr = ""
	end
	self.text = self:insert(self.text, keyStr, #self.text - 1)
	if self.cursorPos < self.s then
		self.cursorPos = self.cursorPos + add
	else
		self.inputPos = self.inputPos + add
	end
end

-- gui

local running = true
local w, h = gpu.getResolution()

gui = {
	objects = {}
}

function gui:draw()
	for i = 1, #self.objects do
		self.objects[i]:draw()
	end
end

function gui:setDefaultColors()
	gpu.setBackground(Colors.black)
	gpu.setForeground(Colors.white)
end

-- gui logic

local exitButtonId = Button:new({x = 1, y = h, text = unicode.char(1805).."Start", clicked = function() running = false end})
local searchTextBoxId = TextBox:new({x = gui.objects[exitButtonId].w + 2, y = h, s = 7, placeholder = "Search...", clicked = function(self) self.focused = true end})

local function touch(event, player, x, y, button, entity)
	for i = 1, #gui.objects do
		if gui.objects[i].isClicked then
			if gui.objects[i]:isClicked(x, y, button) then
				gui.objects[i]:clicked(gui.objects[i])
			elseif gui.objects[i].type == "textbox" and gui.objects[i].focused == true then
				gui.objects[i].focused = false
			end
		end
	end
end

output = nil
local function key_down(eventName, playerUUID, key, code)
	for i = 1, #gui.objects do
		if gui.objects[i].type == "textbox" and gui.objects[i].focused then
			gui.objects[i]:handleKey(code)
		end
	end
end

event.listen("touch", touch)
event.listen("key_down", key_down)

while running do
	-- clear screen
	term.clear()
	-- draw background
	gpu.setBackground(Colors.mainBackground)
	gpu.fill(1, 1, w, h, " ")
	-- draw taskbar
	gpu.setBackground(Colors.lightGray)
	gpu.fill(1, h, w, 1," ")
	-- draw objects
	gui:draw()
	-- set to default colors
	gui:setDefaultColors()
	-- output text box if exists
	if output then 
		gpu.set(1, 1, "Output: "..output)
	end
	-- debug
	-- sleep
	os.sleep(0.05)
end

event.ignore("touch", touch)
event.ignore("key_down", key_down)
term.clear()
term.setCursor(1, 1)