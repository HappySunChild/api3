local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

type Self = types.SocialLink
type data = {
	id: number,
	type: string,
	url: string,
	title: string,
}

return createClass {
	constructor = function(self: Self, data: data)
		self.id = data.id
		self.title = data.title
		self.url = data.url
		self.type = data.type
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<SocialLink {self.type}>`, "yellow")
		end,
	},
} :: (data: data) -> types.SocialLink
