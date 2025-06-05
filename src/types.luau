local net = require "@lune/net"

export type Fetcher = {
	setHeader: (Fetcher, name: string, value: string?) -> (),
	getHeader: (Fetcher, name: string) -> string?,

	request: (
		Fetcher,
		url: string,
		method: net.HttpMethod,
		payload: any?,
		query: { [string]: any }?
	) -> (any, net.FetchResponse),
	get: (Fetcher, url: string, query: { [string]: any }?) -> (any, net.FetchResponse),
	post: (Fetcher, url: string, payload: any?) -> (any, net.FetchResponse),
	patch: (Fetcher, url: string, payload: any?) -> (any, net.FetchResponse),
}
export type PageIterator<T> = {
	isFinished: (PageIterator<T>) -> boolean,
	getCurrentPage: (PageIterator<T>) -> { T },
	advanceToNextPage: (PageIterator<T>) -> boolean,
}

-- Users

type UserBirthdate = {
	birthDay: number,
	birthMonth: number,
	birthYear: number,
}

export type BaseUser = {
	id: number,

	getLink: (BaseUser) -> string,
	getFriends: (BaseUser) -> { PartialUser },
	getPresence: (BaseUser) -> Presence,
	getUsernameHistory: (BaseUser, limit: number) -> PageIterator<string>,
	getPrimaryGroup: (BaseUser) -> Group,
	getGroups: (BaseUser) -> { Group },
}
export type PartialUser = BaseUser & {
	name: string,
	displayName: string,
	hasVerifiedBadge: boolean?,
}
export type User = PartialUser & {
	description: string,
}
export type AuthenticatedUser = BaseUser & {
	name: string,
	displayName: string,

	getBirthdate: (AuthenticatedUser) -> UserBirthdate,
	getGender: (AuthenticatedUser) -> number,
	getAgeBracket: (AuthenticatedUser) -> number,
	getCountryCode: (AuthenticatedUser) -> string,
	getRobux: (AuthenticatedUser) -> number,
}
export type UsersProvider = {
	getBaseUser: (UsersProvider, userId: number) -> BaseUser,
	getUser: (UsersProvider, userId: number) -> User,
	getAuthenticatedUser: (UsersProvider) -> AuthenticatedUser,
	getUserFromUsername: (UsersProvider, username: string) -> PartialUser?,
	getUsersFromUsernames: (UsersProvider, usernames: { string }) -> { PartialUser },
	getUsersFromIds: (UsersProvider, userIds: { number }) -> { PartialUser },
	searchUsersWithKeyword: (
		UsersProvider,
		keyword: string,
		limit: number,
		sessionId: string?
	) -> PageIterator<PartialUser>,

	getUserUsernameHistory: (UsersProvider, userId: number, limit: number) -> PageIterator<string>,

	_getAuthenticatedGender: (UsersProvider) -> number,
	_getAuthenticatedBirthdate: (UsersProvider) -> UserBirthdate,
	_getAuthenticatedAgeBracket: (UsersProvider) -> number,
	_getAuthenticatedCountryCode: (UsersProvider) -> string,
	_getAuthenticatedRobux: (UsersProvider) -> number,
}

-- Friends

export type FriendsProvider = {
	getUserFriends: (FriendsProvider, userId: number) -> { PartialUser },
}

-- Presence

export type Presence = {
	presenceType: number,
	lastLocation: string,

	userId: number?,
	jobId: string?,
	universeId: number?,
	rootPlaceId: number?,

	getGameLink: (Presence) -> string,
	getJoinLink: (Presence) -> string,
}
export type PresenceProvider = {
	getUserPresences: (PresenceProvider, users: { number }) -> { Presence },
}

-- Thumbnails

export type ThumbnailBatchRequest = {
	requestId: string,
	targetId: number,
	token: string,
	type: string,
	size: string,
	format: string,
	isCircular: boolean,

	toInfo: (
		ThumbnailBatchRequest
	) -> {
		requestId: string,
		targetId: number,
		token: string,
		type: string,
		size: string,
		format: string,
		isCircular: string,
	},
}

export type Thumbnail = {
	imageUrl: string,
	targetId: string | number,
	requestId: string?,
	version: string,
	state: string,
}
export type ThumbnailProvider = {
	getUserThumbnails: (
		ThumbnailProvider,
		users: { number },
		options: {
			type: string?,
			size: string?,
			isCircular: boolean?,
			format: string?,
		}
	) -> { Thumbnail },
	getBatchThumbnails: (ThumbnailProvider, requests: { ThumbnailBatchRequest }) -> { Thumbnail },
}

-- Places

export type GameInstance<P = BasePlace> = {
	place: P,

	jobId: string,
	maxPlayer: number,
	playing: number,
	fps: number,
	ping: number,

	players: {
		{
			playerToken: string,
			id: number,
			name: string,
			displayName: string,
		}
	},
	playerTokens: { string },

	getUserThumbnailBatchRequests: (GameInstance) -> { ThumbnailBatchRequest },
	getJoinLink: (GameInstance) -> string,
}

export type BasePlace = {
	id: number,

	getLink: (BasePlace) -> string,
	getInstances: <P>(P, limit: number, excludeFull: boolean?) -> PageIterator<GameInstance<P>>,
}
export type Place = BasePlace & {
	builder: string,
	builderId: number,
	hasVerifiedBadge: boolean,
	id: number,
	universeId: number,
	universeRootPlaceId: number,
	name: string,
	sourceName: string,
	description: string,
	sourceDescription: string,
	price: number,
	isPlayable: boolean,
	reasonProhibited: string,
	imageToken: string,
}
export type PlacesProvider = {
	getBasePlace: (PlacesProvider, placeId: number) -> BasePlace,

	getPlace: (PlacesProvider, placeId: number) -> Place,
	getPlaces: (PlacesProvider, placeIds: { number }) -> { Place },
}

-- Groups

export type GroupRelationshipType = "enemies" | "allies"
export type GroupActionType = keyof<typeof(require "@package/enums/GroupActionType")>
export type GroupMessage = {
	id: number?,
	body: string,
	poster: PartialUser?,
}
export type GroupAuditLog = {
	actor: GroupMember,
	actionType: string,
	description: any,
}
export type GroupPayout = {
	user: PartialUser,
	percentage: number,
}
export type GroupRole = {
	id: number,
	name: string,
	description: string,
	rank: number,
	memberCount: number,
}
export type GroupMember = {
	user: PartialUser,
	role: { id: number, name: string, rank: number },
}
export type GroupJoinRequest = {
	requester: PartialUser,
}
export type SocialLink = {
	id: number,
	type: string,
	url: string,
	title: string,
}
type GroupPayoutRestrictions = {
	canUseRecurringPayout: boolean,
	canUseOneTimePayout: boolean,
}
type GroupSettings = {
	isApprovalRequired: boolean,
	areEnemiesAllowed: boolean,
	areGroupFundsVisible: boolean,
	areGroupGamesVisible: boolean,
	isGroupNameChangeEnabled: boolean,
}

export type BaseGroup = {
	id: number,

	getRoles: (BaseGroup) -> { GroupRole },
	getMembers: (BaseGroup, limit: number) -> PageIterator<GroupMember>,
	getMembersWithRole: (BaseGroup, roleId: number, limit: number) -> PageIterator<PartialUser>,

	getRelationships: (BaseGroup, relationshipType: GroupRelationshipType, limit: number) -> { Group },
	getSocialLinks: (BaseGroup) -> { SocialLink },

	getGroupWall: (BaseGroup, limit: number) -> PageIterator<GroupMessage>,

	getAuditLog: (
		BaseGroup,
		actionType: GroupActionType,
		limit: number,
		userId: number?
	) -> PageIterator<GroupAuditLog>,
	getSettings: (BaseGroup) -> GroupSettings,
	getJoinRequestWithUserId: (BaseGroup, userId: number) -> GroupJoinRequest,
	getJoinRequests: (BaseGroup, limit: number) -> PageIterator<GroupJoinRequest>,
	getPayoutRestrictions: (BaseGroup) -> GroupPayoutRestrictions,
	getPayouts: (BaseGroup) -> { GroupPayout },

	getNameHistory: (BaseGroup, limit: number) -> PageIterator<string>,
}
export type Group = BaseGroup & {
	name: string,
	description: string,
	memberCount: number,
	hasVerifiedBadge: boolean,
	publicEntryAllowed: boolean,
	isLocked: boolean?,

	owner: PartialUser,
	shout: GroupMessage?,
}
export type GroupsProvider = {
	getBaseGroup: (GroupsProvider, groupId: number) -> BaseGroup,
	getGroup: (GroupsProvider, groupId: number) -> Group,
	-- user/roles
	getRoles: (GroupsProvider, groupId: number) -> { GroupRole },
	getMembers: (GroupsProvider, groupId: number, limit: number) -> PageIterator<GroupMember>,
	getMembersWithRole: (GroupsProvider, groupId: number, roleId: number, limit: number) -> PageIterator<PartialUser>,
	-- socials
	getRelationships: (
		GroupsProvider,
		groupId: number,
		relationType: GroupRelationshipType,
		limit: number
	) -> { Group },
	getSocialLinks: (GroupsProvider, groupId: number) -> { SocialLink },
	-- group wall
	getGroupWall: (GroupsProvider, groupId: number, limit: number) -> PageIterator<GroupMessage>,
	-- admin
	getAuditLog: (
		GroupsProvider,
		groupId: number,
		actionType: GroupActionType,
		limit: number,
		userId: number?
	) -> PageIterator<GroupAuditLog>,
	getSettings: (GroupsProvider, groupId: number) -> GroupSettings,
	getJoinRequestWithUserId: (GroupsProvider, groupId: number, userId: number) -> GroupJoinRequest?,
	getJoinRequests: (GroupsProvider, groupId: number, limit: number) -> PageIterator<GroupJoinRequest>,
	getPayoutRestrictions: (GroupsProvider, groupId: number) -> GroupPayoutRestrictions,
	getPayouts: (GroupsProvider, groupId: number) -> { GroupPayout },
	-- misc
	getNameHistory: (GroupsProvider, groupId: number, limit: number) -> PageIterator<string>,
	getUserPrimaryGroup: (GroupsProvider, userId: number) -> Group,
	getUserGroups: (GroupsProvider, userId: number) -> { Group },
}

-- Client

export type Client = {
	_fetcher: Fetcher,

	token: string,

	thumbnails: ThumbnailProvider,
	users: UsersProvider,
	friends: FriendsProvider,
	presence: PresenceProvider,
	places: PlacesProvider,
	groups: GroupsProvider,

	setToken: (Client, token: string) -> (),

	getBaseUser: (Client, userId: number) -> BaseUser,
	getUser: (Client, userId: number) -> User,
	getAuthenticatedUser: (Client) -> AuthenticatedUser,

	getBasePlace: (Client, placeId: number) -> BasePlace,
	getPlace: (Client, placeId: number) -> Place,

	getBaseGroup: (Client, groupId: number) -> BaseGroup,
	getGroup: (Client, groupId: number) -> Group,
}

return nil
