local types = require "@package/types"

local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"

local Presence = require "@classes/Presence/Presence"

type Self = types.PresenceProvider & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		getUserPresences = function(self: Self, users: { number }): { types.Presence }
			local client = self._client

			local presenceData = client._fetcher:post(getUrl("presence", "v1/presence/users"), { userIds = users })
			local presences = {}

			for _, data in presenceData.userPresences do
				table.insert(presences, Presence(data))
			end

			return presences
		end,
	},
} :: (client: types.Client) -> types.PresenceProvider
