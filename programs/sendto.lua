local args = {...}
local to = args[1]
local msg = ''

for i = 2, #args do
	msg = msg .. args[i] .. ' '
end

if to == nil or msg == '' then
	print('Usage: sendto <player> <message>')
	return
end

-- dns/local lookup table

-- send the message
print()