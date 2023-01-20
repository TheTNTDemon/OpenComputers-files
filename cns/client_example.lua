local event = require("event")
local keyboard = require("keyboard")
local modem = require("component").modem
local data = require("component").data

local serialize = require("serialization").serialize
local unserialize = require("serialization").unserialize

local cPublic, cPrivate = data.generateKeyPair()

local dns = nil

local packet = {
	header = {
		cPublic = sPublic.serialize(),
		iv = data.random(16)
	}
}

modem.open(8080)

local function recieved(_, _, from, port, _, message)
	local serialized = serialize(message)
	if port == 8080 then
		if dns then
			
		else
			dns.address = from
			dns.sharedSecret = data.md5(data.ecdh(cPrivate, unserialize(message.header.sPublic)))
			print("DNS found: "..from)

			send()
		end
	end

	if port == 8081 then
		local sDecrypted = data.decrypt(message, sPrivate)
		print("Client "..from.." sent: "..sDecrypted)
	end
end

local function send()
	local iv = data.random(16)
	packet.header.iv = iv
	modem.send(dns, 8081, serialize(data.encrypt(packet, dns.sharedSecret, packet.header.iv)))
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




-- NEW COMPUTER ADDED TO NETWORK
-- server broadcast to all computers on port 53 (DNS) the server's public key

-- client recieves key on port 53 and saves it, and then does some logic to determine if it is a new computer or not
-- client creats a new key pair

-- client sends packet to server on port 53. 
-- both iv and public key will be in header that will encrypt the body with sharedKey (see header), and randomized iv.
-- the header/packet will be encrypted with sharedKey made by server's public key and client's secret key and global iv,
-- packet contains: header with client's public key and iv and body containing some data with computer info (name, uuid, etc)

-- if the client is not in the dns table (sharedKey, name, idk yet), add it and then proceed to process message by decrypting body

-- if server or client wants to send a message, header will be encrypted with sharedKey and global iv,
-- and body will be encrypted with sharedKey and randomized iv thats in header