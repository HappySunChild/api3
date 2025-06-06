local types = require "@self/types"

export type GameInstance<P = types.Place> = types.GameInstance<P>
export type Place = types.Place
export type DetailedPlace = types.DetailedPlace

export type Presence = types.Presence
export type User = types.User
export type DetailedUser = types.DetailedUser

export type Thumbnail = types.Thumbnail
export type ThumbnailBatchRequest = types.ThumbnailBatchRequest

export type Client = types.Client

return table.freeze {
	Client = require "@classes/Client",
	Enums = require "@self/enums",

	castToId = require "@utility/castToId",
}
