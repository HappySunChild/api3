local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.GroupMessage
type data = {
	id: number,
	body: string,
	poster: {
		username: string,
		displayName: string,
		userId: number,
		hasVerifiedBadge: boolean,
	}?,
}

return createClass {
	constructor = function(self: Self, client: types.Client, data: data)
		self.id = data.id
		self.body = data.body
		self.poster = if data.poster then PartialUser(client, data.poster :: any) else nil
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			local posterName = if self.poster then `@{self.poster.name}` else "null"
			return tint(`<GroupMessage "{self.body}" - {posterName}>`, "yellow")
		end,
	},
} :: (client: types.Client, data: data) -> types.GroupMessage
