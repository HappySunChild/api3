local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local User = require "./User"

type Self = types.PartialUser
type data = {
	id: number?,
	userId: number?,
	name: string?,
	username: string?,
	displayName: string,
	hasVerifiedBadge: boolean,
}

return createClass {
	super = function(client: types.Client, data: data)
		return User(client, data.id or data.userId or -1)
	end,
	constructor = function(self: Self, _, data: data)
		self.name = data.name or data.username or "!UNKNOWN"
		self.displayName = data.displayName
		self.hasVerifiedBadge = data.hasVerifiedBadge
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<PartialUser @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.PartialUser
