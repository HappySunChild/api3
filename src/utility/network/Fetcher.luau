local net = require "@lune/net"
local task = require "@lune/task"

local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local json = require "./json"
local urlEncode = require "./urlEncode"

type Self = {
	_headers: { [string]: string | { string } },
	_xcsrf_token: string,
} & types.Fetcher

return createClass {
	constructor = function(self: Self)
		self._headers = {}
		self._xcsrf_token = "X-CSRF-Token"

		self:setHeader("content-type", "application/json")
		self:setHeader("user-agent", "Roblox/WinInet")
		self:setHeader("referer", "https://www.roblox.com/")
	end,
	attributes = {
		setHeader = function(self: Self, name: string, value: string | { string }?)
			self._headers[name] = value
		end,
		getHeader = function(self: Self, name: string): string | { string }?
			return self._headers[name]
		end,
		request = function(
			self: Self,
			url: string,
			method: net.HttpMethod,
			payload: any?,
			query: { [string]: any }?
		): (any, net.FetchResponse)
			local encodedQuery = nil

			if query then
				encodedQuery = {} :: net.HttpQueryMap

				for key, value in query do
					encodedQuery[key] = urlEncode(value)
				end
			end

			local response = net.request {
				url = url,
				method = method,
				headers = self._headers,
				body = if payload then json.encode(payload) else nil,
				query = encodedQuery,
			}

			local statusCode = response.statusCode

			if statusCode == 503 then
				error "Server is not available!"
			elseif statusCode == 429 then
				local resetTime = tonumber(response.headers["x-ratelimit-reset"]) or 30

				print(tint(`Too many requests! Retrying in {resetTime}...`, "red"))

				task.wait(resetTime)

				return self:request(url, method, payload, query)
			end

			return json.decode(response.body), response
		end,
		get = function(self: Self, url: string, query: { [string]: any }?): (any, net.FetchResponse)
			return self:request(url, "GET", nil, query)
		end,
		post = function(self: Self, url: string, payload: any?): (any, net.FetchResponse)
			return self:request(url, "POST", payload)
		end,
		patch = function(self: Self, url: string, payload: any?): (any, net.FetchResponse)
			return self:request(url, "PATCH", payload)
		end,
	},
} :: () -> types.Fetcher
