local storage = require('storage')
local fs = require('filesystem')

local args = {...}
local command = args[1]
local name = args[2]

local storageName = 'name'

if command == nil then
	print('Usage: name <save|load> <name>')
	return
end

if command == 'save' then
	if name == nil then
		print('Usage: name save <name>')
		return
	end

	local data = {}
	data.name = name

	storage.save(storageName, data)
	print('Saved data to '..storageName..'.json')
	return
end
if command == 'load' then

	local data = storage.load(storageName)

	if data == nil or data.name == nil then
		print('No data found for '..storageName..'.json')
		return
	end

	print('Loaded data from '..storageName..'.json')
	print('Name: '..data.name)
	return
end