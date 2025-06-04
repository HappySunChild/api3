local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.GroupJoinRequest
type info = {
	requester: {
		userId: number,
		username: string,
		displayName: string,
		hasVerifiedBadge: boolean,
	},
}

return createClass {
	constructor = function(self: Self, client: types.Client, info: info)
		self.requester = PartialUser(client, info.requester :: any)
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<GroupJoinRequest @{self.requester.name}>`, "yellow")
		end,
	},
} :: (client: types.Client, info: info) -> types.GroupJoinRequest
