local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local BaseUser = require "./BaseUser"

type Self = types.AuthenticatedUser & {
	_client: types.Client,
}
type data = {
	id: number,
	name: string,
	displayName: string,
}

return createClass {
	super = function(client: types.Client, data: data)
		return BaseUser(client, data.id)
	end,
	constructor = function(self: Self, client: types.Client, data: data)
		self.name = data.name
		self.displayName = data.displayName
	end,
	attributes = {
		getBirthday = function(self: Self)
			return self._client.users:_getAuthenticatedBirthday()
		end,
		getGender = function(self: Self)
			return self._client.users:_getAuthenticatedGender()
		end,
		getAgeBracket = function(self: Self)
			return self._client.users:_getAuthenticatedAgeBracket()
		end,
		getCountryCode = function(self: Self)
			return self._client.users:_getAuthenticatedCountryCode()
		end,
		getRobux = function(self: Self)
			return self._client.users:_getAuthenticatedRobux()
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<AuthenticatedUser @{self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.AuthenticatedUser
