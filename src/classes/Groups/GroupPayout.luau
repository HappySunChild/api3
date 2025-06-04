local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.GroupPayout
type info = {
	user: {
		hasVerifiedBadge: boolean,
		userId: number,
		username: string,
		displayName: string,
	},
	percentage: number,
}

return createClass {
	constructor = function(self: Self, client: types.Client, info: info)
		self.percentage = info.percentage
		self.user = PartialUser(client, info.user :: any)
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<GroupPayout @{self.user.name} {self.percentage}%>`, "yellow")
		end,
	},
} :: (client: types.Client, info: info) -> types.GroupPayout
