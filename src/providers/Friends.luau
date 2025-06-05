local types = require "@package/types"

local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.FriendsProvider & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		getUserFriends = function(self: Self, userId: number): { types.PartialUser }
			local client = self._client
			local friendInfo = client._fetcher:get(getUrl("friends", `v1/users/{userId}/friends`))

			local friends = {}

			for _, data in friendInfo.data do
				table.insert(friends, PartialUser(client, data))
			end

			return friends
		end,
	},
} :: (client: types.Client) -> types.FriendsProvider
