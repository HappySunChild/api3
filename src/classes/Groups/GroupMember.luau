local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.GroupMember
type data = {
	user: {
		userId: number,
		username: string,
		displayName: string,
		hasVerifiedBadge: boolean,
	},
	role: {
		id: number,
		name: string,
		rank: number,
	},
}

return createClass {
	constructor = function(self: Self, client: types.Client, data: data)
		self.user = PartialUser(client, data.user :: any)
		self.role = data.role
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<GroupMember {self.user.name}>`, "yellow")
		end,
	},
} :: (client: types.Client, data: data) -> types.GroupMember
