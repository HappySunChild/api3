local function defaultSuper(): any
	return {} :: any
end

local function createClass(
	info: {
		constructor: any?,
		super: any?, -- this should be a function, but you can't union those with nil without it freaking out
		attributes: { [string]: any }?,
		metatable: any?,
	}
): (...any) -> any
	return function(...: any)
		local constructor = info.constructor
		local super = info.super or defaultSuper
		local attributes = info.attributes
		local metatable = info.metatable

		local newObject = super(...) :: any?

		if newObject == nil then
			return nil
		end

		if attributes then
			for index, method in attributes do
				(newObject :: any)[index] = method
			end
		end

		if constructor then
			constructor(newObject, ...)
		end

		if metatable then
			setmetatable(newObject, metatable)
		end

		return newObject
	end
end

return createClass
