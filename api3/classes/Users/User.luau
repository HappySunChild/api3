local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local BaseUser = require "./BaseUser"

type Self = types.User
type data = {
	description: string,
	displayName: string,
	name: string,
	id: number,
}

return createClass {
	super = function(client: types.Client, data: data)
		return BaseUser(client, data.id)
	end,
	constructor = function(self: Self, client: types.Client, data: data)
		self.name = data.name
		self.displayName = data.displayName
		self.description = data.description
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<User @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.User
