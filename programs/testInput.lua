local message = '0123456789'
local posInput = 1
local sizeInput = 5
local add = 'a'

local function insert(str1, str2, pos)
	return str1:sub(1,pos)..str2..str1:sub(pos+1)
end

-- print(insert(message, add, 1))
print(message:sub(pos, pos+sizeInput))

local function keyDown(event, player, key, code)
	local keyStr = keyboard.keys[code]
	if keyStr == 'space' then
		keyStr = ' '
	end
	if keyStr == 'back' then
		keyStr = ''
		userStr = userStr:sub(1, -2)
	end
	if keyStr == 'enter' then
		done = true
		keyStr = ''
	end
	userStr = userStr..keyStr
end