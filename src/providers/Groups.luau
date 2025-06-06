local types = require "@package/types"

local createClass = require "@utility/createClass"
local getUrl = require "@utility/network/getUrl"

local PageIterator = require "@utility/network/PageIterator"

local DetailedGroup = require "@classes/Groups/DetailedGroup"
local Group = require "@classes/Groups/Group"

local GroupAuditLog = require "@classes/Groups/GroupAuditLog"
local GroupJoinRequest = require "@classes/Groups/GroupJoinRequest"
local GroupMember = require "@classes/Groups/GroupMember"
local GroupMessage = require "@classes/Groups/GroupMessage"
local GroupPayout = require "@classes/Groups/GroupPayout"
local GroupRole = require "@classes/Groups/GroupRole"
local SocialLink = require "@classes/Groups/SocialLink"

local PartialUser = require "@classes/Users/PartialUser"

type Self = types.GroupsProvider & {
	_client: types.Client,
}

return createClass {
	constructor = function(self: Self, client: types.Client)
		self._client = client
	end,
	attributes = {
		getGroup = function(self: Self, groupId: number)
			return Group(self._client, groupId)
		end,
		getDetailedGroup = function(self: Self, groupId: number)
			local client = self._client
			local groupData = client._fetcher:get(getUrl("groups", `v1/groups/{groupId}`))

			return DetailedGroup(client, groupData)
		end,
		-- user/roles
		getRoles = function(self: Self, groupId: number)
			local rolesData = self._client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/roles`))

			local roles = {}
			for _, data in rolesData.roles do
				table.insert(roles, GroupRole(data))
			end

			return roles
		end,
		getMembers = function(self: Self, groupId: number, limit: number)
			local client = self._client
			return PageIterator(client._fetcher, {
				url = getUrl("groups", `v1/groups/{groupId}/users`),
				limit = limit,
				map = function(data: any)
					return GroupMember(client, data)
				end,
			})
		end,
		getMembersWithRole = function(self: Self, groupId: number, roleId: number, limit: number)
			local client = self._client
			return PageIterator(client._fetcher, {
				url = getUrl("groups", `v1/groups/{groupId}/roles/{roleId}/users`),
				limit = limit,
				map = function(data: any)
					return PartialUser(client, data)
				end,
			})
		end,
		-- socials
		getRelationships = function(
			self: Self,
			groupId: number,
			relationshipType: types.GroupRelationshipType,
			limit: number
		)
			local client = self._client
			local relationshipData =
				client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/relationships/{relationshipType}`), {
					StartRowIndex = 1,
					MaxRows = limit,
				})

			local groups = {}

			for _, data in relationshipData.relatedGroups do
				table.insert(groups, DetailedGroup(client, data))
			end

			return groups
		end,
		getSocialLinks = function(self: Self, groupId: number)
			local socialData = self._client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/social-links`))

			local socialLinks = {}

			for _, data in socialData.data do
				table.insert(socialLinks, SocialLink(data))
			end

			return socialLinks
		end,
		-- group wall
		getGroupWall = function(self: Self, groupId: number, limit: number)
			local client = self._client
			return PageIterator(client._fetcher, {
				url = getUrl("groups", `v1/groups/{groupId}/wall/posts`),
				limit = limit,
				map = function(data: any)
					return GroupMessage(client, data)
				end,
			})
		end,
		-- admin
		getAuditLog = function(
			self: Self,
			groupdId: number,
			actionType: types.GroupActionType,
			limit: number,
			userId: number?
		)
			local client = self._client
			return PageIterator(client._fetcher, {
				url = getUrl("groups", `v1/groups/{groupdId}/audit-log`),
				limit = limit,
				query = {
					actionType = actionType,
				},
				map = function(data: any)
					return GroupAuditLog(client, data)
				end,
			})
		end,
		getSettings = function(self: Self, groupId: number)
			local groupSettings = self._client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/settings`))
			return groupSettings
		end,
		getJoinRequestWithUserId = function(self: Self, groupId: number, userId: number)
			local client = self._client
			local info = client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/join-requests/users/{userId}`))

			return GroupJoinRequest(client, info)
		end,
		getJoinRequests = function(self: Self, groupId: number, limit: number)
			local client = self._client
			return PageIterator(client._fetcher, {
				url = getUrl("groups", `v1/groups/{groupId}/join-requests`),
				limit = limit,
				map = function(info: any)
					return GroupJoinRequest(client, info)
				end,
			})
		end,
		getPayoutRestrictions = function(self: Self, groupId: number)
			local info = self._client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/payout-restriction`))
			return info
		end,
		getPayouts = function(self: Self, groupId: number)
			local client = self._client
			local payoutsInfo = client._fetcher:get(getUrl("groups", `v1/groups/{groupId}/payouts`))

			local payouts = {}

			for _, info in payoutsInfo.data do
				table.insert(payouts, GroupPayout(client, info))
			end

			return payouts
		end,
		-- extra
		getNameHistory = function(self: Self, groupId: number, limit: number)
			return PageIterator(self._client._fetcher, {
				url = getUrl("groups", `v1/groups/{groupId}/name-history`),
				limit = limit,
				map = function(info: any)
					return info.name
				end,
			})
		end,
		getUserPrimaryGroup = function(self: Self, userId: number)
			local client = self._client
			local info = client._fetcher:get(getUrl("groups", `v1/users/{userId}/groups/primary/role`))

			return DetailedGroup(client, info.group)
		end,
		getUserGroups = function(self: Self, userId: number)
			local client = self._client
			local groupsInfo = client._fetcher:get(getUrl("groups", `v1/users/{userId}/groups/roles`))

			local groups = {}

			for _, info in groupsInfo.data do
				table.insert(groups, DetailedGroup(client, info.group))
			end

			return groups
		end,
	},
} :: (client: types.Client) -> types.GroupsProvider
