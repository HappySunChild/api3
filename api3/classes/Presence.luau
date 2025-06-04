local types = require "@package/types"

local createClass = require "@utility/createClass"
local generateJoinLink = require "@utility/generateJoinLink"

type Self = types.Presence
type data = {
	userId: number,
	userPresenceType: number,
	gameId: string?,
	universeId: number?,
	rootPlaceId: number?,
	lastLocation: string,
}

return createClass {
	constructor = function(self: Self, data: data)
		self.presenceType = data.userPresenceType
		self.lastLocation = data.lastLocation
		self.userId = data.userId
		self.jobId = data.gameId
		self.universeId = data.universeId
		self.rootPlaceId = data.rootPlaceId
	end,
	attributes = {
		getJoinLink = function(self: Self): string
			if not self.rootPlaceId then
				return ""
			end

			return generateJoinLink(self.rootPlaceId, self.jobId)
		end,
		getGameLink = function(self: Self): string
			if not self.rootPlaceId then
				return ""
			end

			return `https://www.roblox.com/games/{self.rootPlaceId}`
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return `<Presence {self.lastLocation}>`
		end,
	},
} :: ({}, data: data) -> types.Presence
