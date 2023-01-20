local component = require("component")
local data = component.data
local writer = component.os_cardwriter

print("Cardholder username: ")
local username = io.read()
print("Cardholder level: ")
local level = io.read()

-- The table containing the JSON object
-- add other fields in database like status
local json_table = {
    cardholder = {
        name = username,
        id = 0
    },
    access_level = level
}

-- Convert the table to JSON
local json_object = require("json").encode(json_table)
print("Object\n"..type(json_object).."\n"..#json_object.."\n"..json_object)

-- The encryption key
local key = data.random(16) --generating a 128-bit key
local iv = data.random(16) --generating a 128-bit iv
print("\nKey\n"..type(key).."\n"..#key.."\n"..key)
print("\nIV\n"..type(iv).."\n"..#iv.."\n"..iv)

-- Compress the JSON object
local compressed_data = data.deflate(json_object)
print("\nCompressed\n"..type(compressed_data).."\n"..#compressed_data.."\n"..compressed_data)

-- Encrypt the compressed data
local encoded_data = data.encrypt(compressed_data, key, iv)
print("\nEncoded\n"..type(encoded_data).."\n"..#encoded_data.."\n"..encoded_data)

-- local decoded_data = data.decrypt(encoded_data, key, iv)
-- print("\nDecoded\n"..type(decoded_data).."\n"..#decoded_data.."\n"..decoded_data)

-- local decompressed_data = data.inflate(decoded_data)
-- print("\nDecompressed\n"..type(decompressed_data).."\n"..#decompressed_data.."\n"..decompressed_data)

-- Write the encrypted data to the card
writer.write(encoded_data, json_table.cardholder.name.." | "..json_table.access_level, false)