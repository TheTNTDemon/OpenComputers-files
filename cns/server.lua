local event = require("event")
local keyboard = require("keyboard")
local modem = require("component").modem
local data = require("component").data

local serialize = require("serialization").serialize
local unserialize = require("serialization").unserialize

local sPublic, sPrivate = data.generateKeyPair()

local clients = {}

local packet = {
	header = {
		sPublic = sPublic.serialize(),
		iv = data.random(16)
	}
}

modem.open(8080)
modem.broadcast(8080, serialize(packet))

local function recieved(_, _, from, port, _, message, )
	local unserialized = unserialize(message)
	if port == 8080 then
		if clients[from] then
			local decrypted = data.decrypt(unserialized, clients[from].sharedSecret, unserialized.header.iv)
			print("Client "..from.." sent: "..unserialized.body.message)
		else
			clients[from].sharedSecret = data.md5(data.ecdh(sPrivate, unserialized.header.cPublic))
			local decrypted = data.decrypt(unserialized.body, clients[from].sharedSecret, unserialized.header.iv)
			print("Client found: "..from)
			print("said: "..unserialized.body.message or "nothing")
		end
	end

	if port == 8081 then
		local sDecrypted = data.decrypt(message, sPrivate)
		print("Client "..from.." sent: "..sDecrypted)
	end
end

event.listen("modem_message", recieved)

local running = true

while running do
	if keyboard.isShiftDown() then
		running = false
	end
	os.sleep(0.2)
end

event.ignore("modem_message", recieved)