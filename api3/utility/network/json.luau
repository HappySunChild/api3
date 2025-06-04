local serde = require "@lune/serde"

local json = table.freeze {
	encode = function(value: any, pretty: boolean?)
		return serde.encode("json", value, pretty)
	end,
	decode = function(value: any)
		return serde.decode("json", value)
	end,
}

return json
