local args = {...}
local cmd = 'sendmsg'

for i = 1, #args do
  cmd = cmd .. " " .. args[i]
end

local result = os.execute(cmd)
print(result[1])