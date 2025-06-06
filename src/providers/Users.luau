local types = require "@package/types"

local createClass = require "@utility/createClass"

local PageIterator = require "@utility/network/PageIterator"
local getUrl = require "@utility/network/getUrl"

local AuthenticatedUser = require "@classes/Users/AuthenticatedUser"
local DetailedUser = require "@classes/Users/DetailedUser"
local PartialUser = require "@classes/Users/PartialUser"
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
		getUser = function(self: Self, userId: number)
			return User(self._client, userId)
		end,
		getDetailedUser = function(self: Self, userId: number)
			local client = self._client
			local userData = client._fetcher:get(getUrl("users", `v1/users/{userId}`)) -- `https://users.roblox.com/v1/users/{userId}`

			return DetailedUser(client, userData)
		end,
		getAuthenticatedUser = function(self: Self)
			local client = self._client
			local userData = client._fetcher:get(getUrl("users", "v1/users/authenticated"))

			return AuthenticatedUser(client, userData)
		end,
		getUserFromUsername = function(self: Self, username: string): types.PartialUser
			return self:getUsersFromUsernames({ username })[1]
		end,
		getUsersFromUsernames = function(self: Self, usernames: { string }): { types.PartialUser }
			local client = self._client
			local userData = client._fetcher:post(getUrl("users", "v1/usernames/users"), {
				usernames = usernames,
				excluseBannedUsers = false,
			})

			local users = {}

			for _, data in userData.data do
				table.insert(users, PartialUser(client, data))
			end

			return users
		end,
		getUsersFromIds = function(self: Self, userIds: { number }): { types.PartialUser }
			local client = self._client
			local userData = client._fetcher:post(getUrl("users", "v1/users"), {
				userIds = userIds,
				excluseBannedUsers = false,
			})

			local users = {}

			for _, data in userData.data do
				table.insert(users, PartialUser(client, data))
			end

			return users
		end,
		searchUsersWithKeyword = function(self: Self, keyword: string, limit: number, sessionId: string?)
			local client = self._client
			return PageIterator(client._fetcher, {
				url = getUrl("users", "v1/users/search"),
				limit = limit,
				query = {
					keyword = keyword,
					sessionId = sessionId,
				},
				map = function(data: any)
					return PartialUser(client, data)
				end,
			})
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
		_getAuthenticatedBirthdate = function(self: Self)
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
} :: (client: types.Client) -> types.UsersProvider
