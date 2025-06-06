local types = require "@package/types"

local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"

local DetailedPlace = require "@classes/Places/DetailedPlace"
local Place = require "@classes/Places/Place"

type Self = { _client: types.Client } & types.PlacesProvider

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		getPlace = function(self: Self, placeId: number): types.Place
			return Place(self._client, placeId)
		end,
		getDetailedPlace = function(self: Self, placeId: number): types.DetailedPlace
			return self:getPlaces({ placeId })[1]
		end,
		getPlaces = function(self: Self, placeIds: { number }): { types.DetailedPlace }
			local client = self._client
			local placesData =
				client._fetcher:get(getUrl("games", "v1/games/multiget-place-details"), { placeIds = placeIds })

			local places = {}

			for _, data in placesData do
				table.insert(places, DetailedPlace(client, data))
			end

			return places
		end,
	},
} :: (client: types.Client) -> types.PlacesProvider
