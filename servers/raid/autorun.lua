-- USE COMPONENT.GETPRIMARY('filesystem').GETLABEL()
local function contains(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

local function isValid(string)
	return string ~= nil and string ~= 'tmpfs'
end

local function init()
	local term = require('term')
	term.clear()
	print('initializing...')
	os.sleep(0.5)

	local component = require('component')
	local storage = require('storage')
	local fs = require('filesystem')

	local config = storage.load('config', '/home') or {}

	local raidNum = config.raidNum or 0

	local directoryNum = config.directoryNum or 1
	local computerDrives = config.computerDrives or {}
	local raidDrives = config.raidDrives or {}
	local directoryDict = {'B:', 'C:', 'D:', 'E:', 'F:', 'G:', 'H:', 'I:', 'J:', 'K:', 'L:', 'M:', 'N:', 'O:', 'P:', 'Q:', 'R:', 'S:', 'T:', 'U:', 'V:', 'W:', 'X:', 'Y:', 'Z:'}

	print('getting filesystems...')
	local table = component.list('filesystem')

	print('saving filesystems...')
	for index, param in pairs(table) do
		local fsComp = component.proxy(index)
		local label = fsComp.getLabel() or fsComp.fsnode.name

		if isValid(label) then
			if contains(raidDrives, label) == false and label ~= 'A:' and contains(directoryDict, label) == false then
				if label == 'OpenOS' then
					fsComp.setLabel('A:')
					computerDrives[#computerDrives + 1] = fsComp.getLabel()
					print("added 'A:'...")
				elseif label == 'raid' then
					fsComp.setLabel('raid'..raidNum)
					raidNum = raidNum + 1
					raidDrives[#raidDrives + 1] = fsComp.getLabel()
					print("added '"..fsComp.getLabel().."'...")
				else
					fsComp.setLabel(directoryDict[directoryNum])
					directoryNum = directoryNum + 1
					computerDrives[#computerDrives + 1] = fsComp.getLabel()
					print("added '"..fsComp.getLabel().."'...")
				end
			end
			fs.umount('/mnt/'..string.sub(index, 1, 3))
		end
	end

	print('mounting filesystems...')
	for index, param in pairs(computerDrives) do
		fs.mount(param, '/'..param)
		print("mounted '"..param.."'...")
	end

	for index, param in pairs(raidDrives) do
		fs.mount(param, '/'..param)
		print("mounted '"..param.."'...")
	end

	print('finalizing...')
	config.raidNum = raidNum
	config.directoryNum = directoryNum
	config.computerDrives = computerDrives
	config.raidDrives = raidDrives
	storage.save('config', config)
	print('saved config...')
	print('initializing succeeded')
	os.sleep(3)
	term.clear()
	print('yeet')
	term.setCursor(1, 2)
	return false
end

local event = require('event')
function start()
  event.listen("touch", init)
end