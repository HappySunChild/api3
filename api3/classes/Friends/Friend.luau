local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local BaseUser = require "@classes/Users/BaseUser"

type Self = types.Friend
type data = {
	name: string,
	displayName: string,
	id: number,
}

return createClass {
	super = function(client: types.Client, data: data)
		return BaseUser(client, data.id)
	end,
	constructor = function(self: Self, client: types.Client, data: data)
		self.name = data.name
		self.displayName = data.displayName
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<Friend @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.Friend
