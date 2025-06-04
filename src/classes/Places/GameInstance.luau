local Enum = require "@package/enums"
local types = require "@package/types"

local createClass = require "@utility/createClass"
local generateJoinLink = require "@utility/generateJoinLink"
local tint = require "@utility/tint"

local ThumbnailBatchRequest = require "@classes/Thumbnails/ThumbnailBatchRequest"

type Self = types.GameInstance
type data = {
	id: string,
	maxPlayers: number,
	playing: number,
	playerTokens: { string },
	players: { { playerToken: string, id: number, name: string, displayName: string } },
	fps: number,
	ping: number,
}

return createClass {
	constructor = function(self: Self, data: data, place: types.Place)
		self.place = place

		self.jobId = data.id
		self.fps = data.fps
		self.maxPlayer = data.maxPlayers
		self.ping = data.ping
		self.playerTokens = data.playerTokens
		self.players = data.players
		self.playing = data.playing
	end,
	attributes = {
		getUserThumbnailBatchRequests = function(self: Self)
			local requests = {}

			for _, token in self.playerTokens do
				table.insert(
					requests,
					ThumbnailBatchRequest {
						type = Enum.BatchRequestType.AvatarHeadshot,
						token = token,
						requestId = self.jobId,
					}
				)
			end

			return requests
		end,
		getJoinLink = function(self: Self): string
			return generateJoinLink(self.place.id, self.jobId)
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<GameInstance {self.jobId}>`, "yellow")
		end,
	},
} :: (data: data, place: types.BasePlace) -> types.GameInstance
