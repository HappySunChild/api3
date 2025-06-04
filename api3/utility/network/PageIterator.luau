local types = require "@package/types"

local merge = require "@utility/merge"

type map<T> = (any) -> T
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

local class = {}
local METATABLE = table.freeze {
	__index = class,
	__tostring = function(self)
		return `<PageIterator>`
	end,
}

local function PageIterator<T>(
	fetcher: types.Fetcher,
	options: {
		url: string,
		sortOrder: string?,
		limit: number?,
		query: { [string]: any }?,
		map: map<any>?,
	}
): types.PageIterator<T>
	local newIterator: Self<T> = setmetatable({
		_fetcher = fetcher,
		_url = options.url,
		_limit = options.limit or 10,
		_sortOrder = options.sortOrder,
		_query = options.query,
		_map = options.map,

		_currentCursor = nil,
		_nextCursor = nil,
		_prevCursor = nil,
	}, METATABLE) :: any

	return newIterator
end

function class.isFinished<T>(self: Self<T>)
	return self._nextCursor == nil
end

function class.getCurrentPage<T>(self: Self<T>)
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

	if map then
		for key, value in data do
			data[key] = map(value)
		end
	end

	return data
end

function class.advanceToNextPage<T>(self: Self<T>): boolean
	if self._nextCursor == nil then
		return false
	end

	self._prevCursor = self._currentCursor
	self._currentCursor = self._nextCursor
	self._nextCursor = nil :: any -- proof that casting everything to `any` fixes everything

	return true
end

return PageIterator
