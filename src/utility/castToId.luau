local function castToId(value: any)
	if type(value) == "table" then
		return value.id
	end

	return tonumber(value)
end

return castToId
