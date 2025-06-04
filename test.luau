local api3 = require "./api3"
local roblox = require "@lune/roblox"

local cookie = roblox.getAuthCookie()

assert(cookie, "Roblox auth cookie is not available!")

local client = api3.Client(cookie)
local user = client:getBaseUser(591929491)

print(user)
