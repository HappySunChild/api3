local createEnum = require "./createEnum"

return createEnum {
	Completed = "Completed",
	InReview = "InReview",
	Pending = "Pending",
	Error = "Error",
	Moderated = "Moderated",
	Blocked = "Blocked",
}
