local event = require('event')
local keyboard = require('keyboard')
local term = require('term')
local storage = require('storage')

local running = true

local userStr = ''
function key_down(eventName, playerUUID, key, code)
	local keyStr = keyboard.keys[code]
	if keyStr == 'space' then
		keyStr = ' '
	end
	if keyStr == 'back' then
		keyStr = ''
		userStr = userStr:sub(1, -2)
	end
	if keyStr == 'enter' then
		running = false
		keyStr = ''
	end
	userStr = userStr..keyStr
end

event.listen('key_down', key_down)
event.listen('touch', touch)

while running do
	term.clear()
	print('Type something: '..userStr)
	os.sleep(0.0625)
end

local path = shell.getWorkingDirectory()
shell.setWorkingDirectory('/raid')
storage.save('response', {response = userStr})
shell.setWorkingDirectory(path)

term.clear()
print('you typed "'..userStr..'"')
term.setCursor(1, 2)