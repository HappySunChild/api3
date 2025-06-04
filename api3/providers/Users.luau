local types = require "@package/types"

local createClass = require "@utility/createClass"

local PageIterator = require "@utility/network/PageIterator"
local getUrl = require "@utility/network/getUrl"

local AuthenticatedUser = require "@classes/Users/AuthenticatedUser"
local BaseUser = require "@classes/Users/BaseUser"
local User = require "@classes/Users/User"

type Self = types.UsersProvider & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		-- constructors
		getBaseUser = function(self: Self, userId: number)
			return BaseUser(self._client, userId)
		end,
		getUser = function(self: Self, userId: number)
			local client = self._client
			local userData = client._fetcher:get(getUrl("users", `v1/users/{userId}`)) -- `https://users.roblox.com/v1/users/{userId}`

			return User(client, userData)
		end,
		getAuthenticatedUser = function(self: Self)
			local client = self._client
			local userData = client._fetcher:get(getUrl("users", "v1/users/authenticated"))

			return AuthenticatedUser(client, userData)
		end,
		-- user api methods
		getUserUsernameHistory = function(self: Self, userId: number, limit: number)
			return PageIterator(self._client._fetcher, {
				url = getUrl("users", `v1/users/{userId}/username-history`),
				limit = limit,
				map = function(data: any): string
					return data.name
				end,
			})
		end,
		-- authentication api methods
		_getAuthenticatedBirthday = function(self: Self)
			local birthday = self._client._fetcher:get(getUrl("users", "v1/birthdate"))
			return birthday
		end,
		_getAuthenticatedGender = function(self: Self)
			local gender = self._client._fetcher:get(getUrl("users", "v1/gender"))
			return gender.gender
		end,
		_getAuthenticatedAgeBracket = function(self: Self)
			local ageBracket = self._client._fetcher:get(getUrl("users", "v1/users/authenticated/age-bracket"))
			return ageBracket.ageBracket
		end,
		_getAuthenticatedCountryCode = function(self: Self)
			local countryCode = self._client._fetcher:get(getUrl("users", "v1/users/authenticated/country-code"))
			return countryCode.countryCode
		end,
		_getAuthenticatedRobux = function(self: Self)
			local robux = self._client._fetcher:get(getUrl("economy", "v1/user/currency"))
			return robux.robux
		end,
	},
}
