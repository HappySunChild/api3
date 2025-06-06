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

export type User = {
	id: number,

	getLink: (User) -> string,
	getFriends: (User) -> { PartialUser },
	getPresence: (User) -> Presence,
	getUsernameHistory: (User, limit: number) -> PageIterator<string>,
	getPrimaryGroup: (User) -> DetailedGroup,
	getGroups: (User) -> { DetailedGroup },
}
export type PartialUser = User & {
	name: string,
	displayName: string,
	hasVerifiedBadge: boolean?,
}
export type DetailedUser = PartialUser & {
	description: string,
}
export type AuthenticatedUser = User & {
	name: string,
	displayName: string,

	getBirthdate: (AuthenticatedUser) -> UserBirthdate,
	getGender: (AuthenticatedUser) -> number,
	getAgeBracket: (AuthenticatedUser) -> number,
	getCountryCode: (AuthenticatedUser) -> string,
	getRobux: (AuthenticatedUser) -> number,
}
export type UsersProvider = {
	getUser: (UsersProvider, userId: number) -> User,
	getDetailedUser: (UsersProvider, userId: number) -> DetailedUser,
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

export type GameInstance<P = Place> = {
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

export type Place = {
	id: number,

	getLink: (Place) -> string,
	getInstances: <P>(P, limit: number, excludeFull: boolean?) -> PageIterator<GameInstance<P>>,
}
export type DetailedPlace = Place & {
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
	getPlace: (PlacesProvider, placeId: number) -> Place,

	getDetailedPlace: (PlacesProvider, placeId: number) -> DetailedPlace,
	getPlaces: (PlacesProvider, placeIds: { number }) -> { DetailedPlace },
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

export type Group = {
	id: number,

	getRoles: (Group) -> { GroupRole },
	getMembers: (Group, limit: number) -> PageIterator<GroupMember>,
	getMembersWithRole: (Group, roleId: number, limit: number) -> PageIterator<PartialUser>,

	getRelationships: (Group, relationshipType: GroupRelationshipType, limit: number) -> { DetailedGroup },
	getSocialLinks: (Group) -> { SocialLink },

	getGroupWall: (Group, limit: number) -> PageIterator<GroupMessage>,

	getAuditLog: (
		Group,
		actionType: GroupActionType,
		limit: number,
		userId: number?
	) -> PageIterator<GroupAuditLog>,
	getSettings: (Group) -> GroupSettings,
	getJoinRequestWithUserId: (Group, userId: number) -> GroupJoinRequest,
	getJoinRequests: (Group, limit: number) -> PageIterator<GroupJoinRequest>,
	getPayoutRestrictions: (Group) -> GroupPayoutRestrictions,
	getPayouts: (Group) -> { GroupPayout },

	getNameHistory: (Group, limit: number) -> PageIterator<string>,
}
export type DetailedGroup = Group & {
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
	getGroup: (GroupsProvider, groupId: number) -> Group,
	getDetailedGroup: (GroupsProvider, groupId: number) -> DetailedGroup,
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
	) -> { DetailedGroup },
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
	getUserPrimaryGroup: (GroupsProvider, userId: number) -> DetailedGroup,
	getUserGroups: (GroupsProvider, userId: number) -> { DetailedGroup },
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

	getUser: (Client, userId: number) -> User,
	getDetailedUser: (Client, userId: number) -> DetailedUser,
	getAuthenticatedUser: (Client) -> AuthenticatedUser,

	getPlace: (Client, placeId: number) -> Place,
	getDetailedPlace: (Client, placeId: number) -> DetailedPlace,

	getGroup: (Client, groupId: number) -> Group,
	getDetailedGroup: (Client, groupId: number) -> DetailedGroup,
}

return nil
