local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

type Self = types.Thumbnail
type data = {
	imageUrl: string,
	targetId: string | number,
	requestId: string?,
	version: string,
	state: string,
}

return createClass {
	constructor = function(self: Self, data: data)
		self.imageUrl = data.imageUrl
		self.targetId = data.targetId
		self.requestId = data.requestId
		self.version = data.version
		self.state = data.state
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<Thumbnail {self.state}:{self.imageUrl}>`, "purple")
		end,
	},
} :: (data: data) -> types.Thumbnail
