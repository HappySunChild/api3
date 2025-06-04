local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local BaseUser = require "./BaseUser"

type Self = types.PartialUser
type data = {
	id: number,
	name: string,
	displayName: string,
	hasVerifiedBadge: boolean,
}

return createClass {
	super = function(client: types.Client, data: data)
		return BaseUser(client, data.id)
	end,
	constructor = function(self: Self, _, data: data)
		self.name = data.name
		self.displayName = data.displayName
		self.hasVerifiedBadge = data.hasVerifiedBadge
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<PartialUser @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.PartialUser
