local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local playerSchema = require(ServerScriptService.schemas.playerSchema)

local DataService = {
	Profiles = {},
}

function DataService.getProfile(player: Player): typeof(playerSchema)
	local profile = DataService.Profiles[player]
	return profile
end

return DataService
