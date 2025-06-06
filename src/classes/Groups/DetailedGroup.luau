local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

local Group = require "./Group"
local GroupMessage = require "./GroupMessage"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.DetailedGroup
type data = {
	id: number,
	name: string,
	description: string,
	memberCount: number,
	hasVerifiedBadge: boolean,
	publicEntryAllowed: boolean,
	isLocked: boolean?,

	owner: {
		userId: number,
		username: string,
		displayName: string,
		hasVerifiedBadge: boolean,
	},
	shout: {
		body: string,
		poster: {
			username: string,
			displayName: string,
			userId: number,
			hasVerifiedBadge: boolean,
		},
	}?,
}

return createClass {
	super = function(client: types.Client, data: data)
		return Group(client, data.id)
	end,
	constructor = function(self: Self, client: types.Client, data: data)
		self.name = data.name
		self.description = data.description
		self.memberCount = data.memberCount
		self.hasVerifiedBadge = data.hasVerifiedBadge
		self.publicEntryAllowed = data.publicEntryAllowed
		self.isLocked = data.isLocked

		self.owner = PartialUser(client, data.owner :: any)
		self.shout = if data.shout ~= nil then GroupMessage(client, data.shout :: any) else nil
	end,
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<DetailedGroup {self.name}>`, "purple")
		end,
	},
} :: (client: types.Client, data: data) -> types.DetailedGroup
