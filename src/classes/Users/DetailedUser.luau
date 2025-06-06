local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local PartialUser = require "./PartialUser"

type Self = types.DetailedUser
type data = {
	id: number,
	name: string,
	displayName: string,
	description: string,
	hasVerifiedBadge: boolean,
}

return createClass {
	super = PartialUser,
	constructor = function(self: Self, _, data: data)
		self.description = data.description
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<DetailedUser @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.DetailedUser
