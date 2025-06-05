type Enum<T> = T & {
	fromValue: (Enum<T>, value: any) -> string,
}

local function createEnum<T>(items: T): Enum<T>
	-- lord forgive me for what i'm about to do...
	items = items :: any

	local keys = {}

	for key, value in items :: any do
		if keys[value] ~= nil then
			error(`Invalid Enum! Multiple Enum key collision '{key}' with '{keys[value]}'`, 2)
		end

		keys[value] = key
	end

	function items:fromValue(value: any)
		return keys[value]
	end

	return items
end

return createEnum
