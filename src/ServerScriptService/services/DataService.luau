local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerProfileData = require(ServerScriptService.constants.PlayerProfileData)

local DataService = {
	Profiles = {},
}

function DataService.getProfile(player: Player): typeof(PlayerProfileData)
	local profile = DataService.Profiles[player]
	return profile
end

function DataService.resetProfile(profile)
	profile.Data = PlayerProfileData
end

return DataService
