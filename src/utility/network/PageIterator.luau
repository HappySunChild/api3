local types = require "@package/types"

local createClass = require "@utility/createClass"
local merge = require "@utility/merge"

type Self<T> = types.PageIterator<T> & {
	_fetcher: types.Fetcher,
	_url: string,
	_limit: number,
	_sortOrder: string?,
	_query: { [string]: any }?,
	_map: map<T>?,

	_currentCursor: string?,
	_nextCursor: string?,
	_prevCursor: string?,
}
type map<T> = (any) -> T
type options<T> = {
	url: string,
	sortOrder: string?,
	limit: number?,
	query: { [string]: any }?,
	map: map<T>?,
}

return createClass {
	constructor = function<T>(self: Self<T>, fetcher: types.Fetcher, options: options<T>)
		self._fetcher = fetcher
		self._url = options.url
		self._limit = options.limit or 10
		self._sortOrder = options.sortOrder
		self._query = options.query
		self._map = options.map
		self._currentCursor = nil
		self._nextCursor = nil
		self._prevCursor = nil
	end,
	attributes = {
		isFinished = function<T>(self: Self<T>)
			return self._nextCursor == nil
		end,
		getCurrentPage = function<T>(self: Self<T>)
			local pageData = self._fetcher:get(
				self._url,
				merge({
					cursor = self._currentCursor,
					limit = self._limit,
					sortOrder = self._sortOrder,
				}, self._query)
			)

			self._nextCursor = pageData.nextPageCursor
			self._prevCursor = pageData.previousPageCursor

			local data = pageData.data
			local map = self._map

			if map and data ~= nil then
				for key, value in data do
					(data :: any)[key] = map(value)
				end
			end

			return data
		end,
		advanceToNextPage = function<T>(self: Self<T>): boolean
			if self._nextCursor == nil then
				return false
			end

			self._prevCursor = self._currentCursor
			self._currentCursor = self._nextCursor
			self._nextCursor = nil :: any -- proof that casting everything to `any` fixes everything

			return true
		end,
	},
	metatable = table.freeze {
		__tostring = function()
			return "<PageIterator>"
		end,
	},
} :: (fetcher: types.Fetcher, options: options<unknown>) -> types.PageIterator<unknown>
