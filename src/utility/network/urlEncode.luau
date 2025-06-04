local net = require "@lune/net"

local function urlEncode<V>(value: any)
	if type(value) == "table" then
		local list = {}

		for index = 1, #value do
			table.insert(list, (value :: any)[index])
		end

		return table.concat(list, ",")
	end

	return net.urlEncode(tostring(value))
end

return urlEncode
