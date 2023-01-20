local Yeet = {
	test = 'yeet'
}

function Yeet:new(func)
	func()
end

Yeet:new(function()
	print(self.test)
end)