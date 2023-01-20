local computer = require("computer")
local event = require("event")
local gpu = require("component").gpu
local keyboard = require("keyboard")

local input = "" -- variable to store the input text
local cursorPos = 1 -- variable to store the cursor position
local selectionStart = 0 -- variable to store the start of the selected text
local selectionEnd = 0 -- variable to store the end of the selected text

function drawInput()
  -- clear the screen
	local w,h = gpu.getResolution()
	gpu.fill(1, 1, w, h, " ")

  -- draw the input text
  gpu.set(1, 1, input)

  -- draw the cursor
  if computer.uptime() % 1 >= 0.5 then
    gpu.set(cursorPos, 1, "|")
  end

  -- draw the selected text
  if selectionStart ~= selectionEnd then
    gpu.setForeground(0x00FF00)
    gpu.set(selectionStart, 1, input:sub(selectionStart, selectionEnd))
    gpu.setForeground(0xFFFFFF)
  end
end

function onTouch(address, x, y, button, playerName)
  if y == 1 then
    -- calculate the position of the cursor
    cursorPos = x
    if button == 0 then
      -- left button press, start a new selection
      selectionStart = cursorPos
      selectionEnd = cursorPos
    elseif button == 2 then
      -- right button press, clear the current selection
      selectionStart = 0
      selectionEnd = 0
    end
  end
  drawInput()
end

event.listen("touch", onTouch)

while true do
  drawInput()
  local name, address, char, code, player = event.pull("key_down")
  if char == "back" then
    -- delete the selected text or the character before the cursor
    if selectionStart ~= selectionEnd then
      input = input:sub(1, selectionStart - 1) .. input:sub(selectionEnd + 1)
      cursorPos = selectionStart
    elseif cursorPos > 1 then
      input = input:sub(1, cursorPos - 2) .. input:sub(cursorPos)
      cursorPos = cursorPos - 1
    end
    selectionStart = 0
    selectionEnd = 0
  elseif char == "enter" then
    -- handle the enter key press
    -- ...
  elseif char == "left" then
    -- move the cursor to the left
    if cursorPos > 1 then
      cursorPos = cursorPos - 1
    end
    if not keyboard.isShiftDown() then
      selectionStart = 0
      selectionEnd = 0
    end
  elseif char == "right" then
    -- move the cursor to the right
    if cursorPos < input:len() then
      cursorPos = cursorPos + 1
    end
    if not keyboard.isShiftDown() then
      selectionStart = 0
      selectionEnd = 0
    end
  elseif char == "shift" then
    -- update the selection
    if selectionStart == 0 and selectionEnd == 0 then
      selectionStart = cursorPos
      selectionEnd = cursorPos
    end
	else
		-- insert the character at the cursor position
		input = input:sub(1, cursorPos - 1) .. char .. input:sub(cursorPos)
		cursorPos = cursorPos + 1
		if not keyboard.isShiftDown() then
			selectionStart = 0
			selectionEnd = 0
		end
	end
	drawInput()
end