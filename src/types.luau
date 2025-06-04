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
	getFriends: (BaseUser) -> { Friend },
	getPresence: (BaseUser) -> Presence,
	getUsernameHistory: (BaseUser, limit: number) -> PageIterator<string>,
}
export type PartialUser = BaseUser & {
	name: string,
	displayName: string,
	hasVerifiedBadge: boolean,
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

export type Friend = BaseUser & {
	name: string,
	displayName: string,
}
export type FriendsProvider = {
	getUserFriends: (FriendsProvider, userId: number) -> { Friend },
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

-- Client

export type Client = {
	_fetcher: Fetcher,

	token: string,

	thumbnails: ThumbnailProvider,
	users: UsersProvider,
	friends: FriendsProvider,
	presence: PresenceProvider,
	places: PlacesProvider,

	setToken: (Client, token: string) -> (),

	getBaseUser: (Client, userId: number) -> BaseUser,
	getUser: (Client, userId: number) -> User,
	getAuthenticatedUser: (Client) -> AuthenticatedUser,
	
	getBasePlace: (Client, placeId: number) -> BasePlace,
	getPlace: (Client, placeId: number) -> Place,
}

return nil
