local createEnum = require "./createEnum"

return createEnum {
	Offline = 0,
	Online = 1,
	InGame = 2,
	InStudio = 3,
	Invisible = 4,
}
