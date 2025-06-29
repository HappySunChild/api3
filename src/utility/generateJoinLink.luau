local function generateJoinLink(placeId: number, jobId: string?): string
	local link = `roblox://experiences/start?placeId={placeId}`

	if jobId then
		link ..= `&gameInstanceId={jobId}`
	end

	return link
end

return generateJoinLink
