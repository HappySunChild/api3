local BASE_SITE = "roblox.com"

local function getUrl(subdomain: string, path: string)
	return `https://{subdomain}.{BASE_SITE}/{path}`
end

return getUrl
