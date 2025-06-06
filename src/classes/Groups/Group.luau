local types = require "@package/types"

local createClass = require "@utility/createClass"
local tint = require "@utility/tint"

type Self = types.Group & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client, groupId: number)
		self._client = client
		self.id = groupId
	end,
	attributes = {
		getRoles = function(self: Self)
			return self._client.groups:getRoles(self.id)
		end,
		getMembers = function(self: Self, limit: number)
			return self._client.groups:getMembers(self.id, limit)
		end,
		getMembersWithRole = function(self: Self, roleId: number, limit: number)
			return self._client.groups:getMembersWithRole(self.id, roleId, limit)
		end,
		getRelationships = function(self: Self, relationshipType: types.GroupRelationshipType, limit: number)
			return self._client.groups:getRelationships(self.id, relationshipType, limit)
		end,
		getSocialLinks = function(self: Self)
			return self._client.groups:getSocialLinks(self.id)
		end,
		getGroupWall = function(self: Self, limit: number)
			return self._client.groups:getGroupWall(self.id, limit)
		end,
		getAuditLog = function(self: Self, actionType: types.GroupActionType, limit: number, userId: number?)
			return self._client.groups:getAuditLog(self.id, actionType, limit, userId)
		end,
		getSettings = function(self: Self)
			return self._client.groups:getSettings(self.id)
		end,
		getJoinRequestWithUserId = function(self: Self, userId: number)
			return self._client.groups:getJoinRequestWithUserId(self.id, userId)
		end,
		getJoinRequests = function(self: Self, limit: number)
			return self._client.groups:getJoinRequests(self.id, limit)
		end,
		getPayoutRestrictions = function(self: Self)
			return self._client.groups:getPayoutRestrictions(self.id)
		end,
		getPayouts = function(self: Self)
			return self._client.groups:getPayouts(self.id)
		end,
		getNameHistory = function(self: Self, limit: number)
			return self._client.groups:getNameHistory(self.id, limit)
		end,
	},
	metatable = table.freeze {
		__tostring = function(self: Self)
			return tint(`<Group {self.id}>`, "purple")
		end,
	},
} :: (client: types.Client, groupId: number) -> types.Group
