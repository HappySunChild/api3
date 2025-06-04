local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local GroupMember = require "./GroupMember"

type Self = types.GroupAuditLog
type data = {
	actor: {
		user: {
			hasVerifiedBadge: boolean,
			userId: number,
			username: string,
			displayName: string,
		},
		role: {
			id: number,
			rank: number,
			name: string,
		},
	},
	actionType: string,
	description: any,
}

return createClass {
	constructor = function(self: Self, client: types.Client, data: data)
		self.actionType = data.actionType
		self.description = data.description
		self.actor = GroupMember(client, data.actor)
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<GroupAuditLog "{self.actionType}" by @{self.actor.user.name}>`, "yellow")
		end,
	},
} :: (client: types.Client, data: data) -> types.GroupAuditLog
