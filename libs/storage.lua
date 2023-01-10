local json = require('json')

local Storage = {}

function Storage.load(name)
	local file = io.open('/data/'..name..'.json', 'r')

	if not file then
		return nil
	end

	local data = io.read('*a')
	io.close(file)

	return json.decode(data)
end

function Storage.save(name, data)
	local file = io.open('/data/'..name..'.json', 'w')

	io.write(json.encode(data))
	io.close(file)
end

return Storage