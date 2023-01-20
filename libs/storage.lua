local json = require('json')
local shell = require('shell')

local Storage = {}

local function openDirectory(name, directory)
	local path = shell.getWorkingDirectory()
	shell.setWorkingDirectory(directory)
	local file = io.open(name..'.json', 'w')

	return file, path
end

function Storage.load(name, directory)
	local directory = directory or 'A:'
	local file, path = openDirectory(name, directory)

	if not file then
		return false
	end

	local data = file:read('*a')
	io.close(file)
	local filtered = data or '{}'
	print(data)
	shell.setWorkingDirectory(path)
	return json.decode(filtered)
end

function Storage.save(name, data, directory)
	local directory = directory or 'A:'
	local file, path = openDirectory(name, directory)

	file:write(json.encode(data))
	shell.setWorkingDirectory(path)
	io.close(file)
end

-- function Storage.delete(directory, name)
		
-- end

return Storage -- /mnt/3ed for testing