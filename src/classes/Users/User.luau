local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

type Self = types.User & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client, userId: number)
		self._client = client
		self.id = userId
	end,
	attributes = {
		getLink = function(self: Self): string
			return `https://www.roblox.com/users/{self.id}/profile`
		end,
		getFriends = function(self: Self): { types.PartialUser }
			return self._client.friends:getUserFriends(self.id)
		end,
		getPresence = function(self: Self): types.Presence
			return self._client.presence:getUserPresences({ self.id })[1]
		end,
		getUsernameHistory = function(self: Self, limit: number)
			return self._client.users:getUserUsernameHistory(self.id, limit)
		end,
		getPrimaryGroup = function(self: Self)
			return self._client.groups:getUserPrimaryGroup(self.id)
		end,
		getGroups = function(self: Self)
			return self._client.groups:getUserGroups(self.id)
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<User {self.id}>`, "purple")
		end,
	},
} :: (client: types.Client, userId: number) -> types.User
