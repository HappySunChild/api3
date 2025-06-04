local Enum = require "@package/enums"
local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

type Self = types.ThumbnailBatchRequest
type options = {
	type: string,
	token: string,
	requestId: string?,
	format: string?,
	size: string?,
	targetId: number?,
	isCircular: boolean?,
}

return createClass {
	constructor = function(self: Self, options: options)
		self.type = options.type
		self.token = options.token
		self.requestId = options.requestId or ""
		self.format = options.format or Enum.ThumbnailFormat.webp
		self.size = options.size or Enum.UserThumbnailSize.x150
		self.targetId = options.targetId or 0
		self.isCircular = options.isCircular or false
	end,
	attributes = {
		toInfo = function(self: Self)
			return {
				requestId = self.requestId,
				targetId = self.targetId,
				token = self.token,
				type = self.type,
				size = self.size,
				format = self.format,
				isCircular = self.isCircular,
			}
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<ThumbnailBatchRequest {self.token}>`, "purple")
		end,
	},
} :: (options: options) -> types.ThumbnailBatchRequest
