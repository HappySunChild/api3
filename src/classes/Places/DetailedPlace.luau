local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local Place = require "./Place"

type Self = types.DetailedPlace
type data = {
	builder: string,
	builderId: number,
	hasVerifiedBadge: boolean,
	placeId: number,
	universeId: number,
	universeRootPlaceId: number,
	name: string,
	sourceName: string,
	description: string,
	sourceDescription: string,
	price: number,
	isPlayable: boolean,
	reasonProhibited: string,
	imageToken: string,
}

return createClass {
	super = function(client: types.Client, data: data)
		return Place(client, data.placeId)
	end,
	constructor = function(self: Self, client: types.Client, data: data)
		self.builder = data.builder
		self.builderId = data.builderId
		self.hasVerifiedBadge = data.hasVerifiedBadge
		self.universeId = data.universeId
		self.universeRootPlaceId = data.universeRootPlaceId
		self.name = data.name
		self.sourceName = data.sourceName
		self.description = data.description
		self.sourceDescription = data.sourceDescription
		self.price = data.price
		self.isPlayable = data.isPlayable
		self.reasonProhibited = data.reasonProhibited
		self.imageToken = data.reasonProhibited
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<DetailedPlace {self.id}, {self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.DetailedPlace
