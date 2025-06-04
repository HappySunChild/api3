local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local PartialUser = require "./PartialUser"

type Self = types.User
type data = {
	id: number,
	name: string,
	displayName: string,
	description: string,
	hasVerifiedBadge: boolean,
}

return createClass {
	super = function(client: types.Client, data: data)
		return PartialUser(client, data)
	end,
	constructor = function(self: Self, _, data: data)
		self.description = data.description
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<User @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.User
