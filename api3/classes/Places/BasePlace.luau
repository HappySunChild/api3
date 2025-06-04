local types = require "@package/types"

local GameInstance = require "./GameInstance"

local PageIterator = require "@utility/network/PageIterator"
local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"
local tint = require "@utility/tint"

type Self = types.BasePlace & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client, placeId: number)
		self._client = client
		self.id = placeId
	end,
	attributes = {
		getInstances = function(
			self: Self,
			limit: number,
			excludeFull: boolean?
		): types.PageIterator<types.GameInstance>
			return PageIterator(self._client._fetcher, {
				url = getUrl("games", `v1/games/{self.id}/servers/0`),
				limit = limit,
				query = {
					excludeFullGames = excludeFull,
				},
				map = function(data: any)
					return GameInstance(data, self)
				end,
			}) :: any
		end,
		getLink = function(self: Self): string
			return `https://www.roblox.com/games/{self.id}/`
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<BasePlace {self.id}>`, "purple")
		end,
	},
} :: (client: types.Client, placeId: number) -> types.BasePlace
