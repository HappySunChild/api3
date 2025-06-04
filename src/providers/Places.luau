local types = require "@package/types"

local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"

local BasePlace = require "@classes/Places/BasePlace"
local Place = require "@classes/Places/Place"

type Self = { _client: types.Client } & types.PlacesProvider

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		getBasePlace = function(self: Self, placeId: number): types.BasePlace
			return BasePlace(self._client, placeId)
		end,
		getPlace = function(self: Self, placeId: number): types.Place
			return self:getPlaces({ placeId })[1]
		end,
		getPlaces = function(self: Self, placeIds: { number }): { types.Place }
			local client = self._client
			local placesData =
				client._fetcher:get(getUrl("games", "v1/games/multiget-place-details"), { placeIds = placeIds })

			local places = {}

			for _, data in placesData do
				table.insert(places, Place(client, data))
			end

			return places
		end,
	},
} :: (client: types.Client) -> types.PlacesProvider
