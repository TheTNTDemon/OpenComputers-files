local json = require('json')

local table = {}

table.test1 = 'test1'

table.test3 = {}
table.test3.age = 20
table.test3.name = 'test3'

print(table.test1)
print(table.test3)
print(table)

local file = io.open('data/test.json', 'w')
	local jsonTable = json.encode(table)

if file then
	file:write(jsonTable)
	file:close()
end