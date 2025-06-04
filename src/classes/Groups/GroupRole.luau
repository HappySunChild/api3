local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

type Self = types.GroupRole
type data = types.GroupRole

return createClass {
	constructor = function(self: Self, data: Self)
		self.id = data.id
		self.name = data.name
		self.description = data.description
		self.memberCount = data.memberCount
		self.rank = data.rank
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<GroupRole {self.name}>`, "yellow")
		end,
	},
} :: (data: data) -> types.GroupRole
