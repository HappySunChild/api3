local types = require "@package/types"

local createClass = require "@utility/createClass"

local Fetcher = require "@utility/network/Fetcher"

local FriendsProvider = require "@providers/Friends"
local GroupsProvider = require "@providers/Groups"
local PlacesProvider = require "@providers/Places"
local PresenceProvider = require "@providers/Presence"
local ThumbnailProvider = require "@providers/Thumbnails"
local UsersProvider = require "@providers/Users"

type Self = types.Client

return createClass {
	constructor = function(self: Self, token: string)
		self._fetcher = Fetcher()

		self.users = UsersProvider(self)
		self.presence = PresenceProvider(self)
		self.thumbnails = ThumbnailProvider(self)
		self.places = PlacesProvider(self)
		self.friends = FriendsProvider(self)
		self.groups = GroupsProvider(self)

		self:setToken(token)
	end,
	attributes = {
		setToken = function(self: Self, token: string)
			self.token = token
			self._fetcher:setHeader("Cookie", token)
		end,
		getUser = function(self: Self, userId: number): types.User
			return self.users:getUser(userId)
		end,
		getDetailedUser = function(self: Self, userId: number): types.DetailedUser
			return self.users:getDetailedUser(userId)
		end,
		getAuthenticatedUser = function(self: Self): types.AuthenticatedUser
			return self.users:getAuthenticatedUser()
		end,
		getPlace = function(self: Self, placeId: number): types.Place
			return self.places:getPlace(placeId)
		end,
		getDetailedPlace = function(self: Self, placeId: number): types.DetailedPlace
			return self.places:getDetailedPlace(placeId)
		end,
		getGroup = function(self: Self, groupId: number): types.Group
			return self.groups:getGroup(groupId)
		end,
		getDetailedGroup = function(self: Self, groupId: number): types.DetailedGroup
			return self.groups:getDetailedGroup(groupId)
		end,
	},
	metatable = table.freeze {
		__tostring = function()
			return `<Client>`
		end,
	},
} :: (token: string) -> types.Client
