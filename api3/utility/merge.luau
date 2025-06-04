local function merge(base: any, ...: any): any
	for _, other in { ... } do
		for key, value in other do
			base[key] = value
		end
	end

	return base
end

return merge
