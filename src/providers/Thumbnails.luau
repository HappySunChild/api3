local Enum = require "@package/enums"
local types = require "@package/types"

local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"

local Thumbnail = require "@classes/Thumbnails/Thumbnail"

type Self = types.ThumbnailProvider & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		getUserThumbnails = function(
			self: Self,
			users: { number },
			options: {
				type: string?,
				size: string?,
				isCircular: boolean?,
				format: string?,
			}
		)
			local thType = options.type or Enum.UserThumbnailType.FullBody
			local thSize = options.size or Enum.UserThumbnailSize.x150
			local thFormat = options.format or Enum.ThumbnailFormat.webp

			local client = self._client

			local thumbnailData = client._fetcher:get(getUrl("thumbnails", `v1/users/{thType}`), {
				userIds = users,
				isCircular = options.isCircular,
				size = thSize,
				format = thFormat,
			})

			local thumbnails = {}

			for _, data in thumbnailData.data do
				table.insert(thumbnails, Thumbnail(data))
			end

			return thumbnails
		end,
		getBatchThumbnails = function(self: Self, requests: { types.ThumbnailBatchRequest })
			local payload = {}

			for index, request in requests do
				payload[index] = request:toInfo()
			end

			local client = self._client
			local thumbnailData = client._fetcher:post(getUrl("thumbnails", "v1/batch"), payload)

			local thumbnails = {}

			for _, data in thumbnailData.data do
				table.insert(thumbnails, Thumbnail(data))
			end

			return thumbnails
		end,
	},
} :: (client: types.Client) -> types.ThumbnailProvider
