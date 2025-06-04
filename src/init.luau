local types = require "@self/types"

export type GameInstance<P = types.BasePlace> = types.GameInstance<P>
export type BasePlace = types.BasePlace
export type Place = types.Place

export type Presence = types.Presence
export type BaseUser = types.BaseUser
export type User = types.User
export type Friend = types.Friend

export type Thumbnail = types.Thumbnail
export type ThumbnailBatchRequest = types.ThumbnailBatchRequest

export type Client = types.Client

return table.freeze {
	Client = require "@classes/Client",
	Enums = require "@self/enums",

	castToId = require "@utility/castToId",
}
