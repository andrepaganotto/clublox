local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.services.DataService)

local Events = ReplicatedStorage.Remotes.Events

local CashService = {}

function CashService.clientSync(player: Player, value: number)
	local leaderstats = player:FindFirstChild("leaderstats")
	local cash = leaderstats and leaderstats.Cash

	if not leaderstats then
		leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"

		cash = Instance.new("IntValue", leaderstats)
		cash.Name = "Cash"
	end

	cash.Value = value

	Events.UpdateCash:FireClient(player, value)
end

function CashService.giveCash(player: Player, amount: number)
	local profile = DataService.getProfile(player)
	if not profile or (profile and not profile:IsActive()) then
		return warn("[takeCash]: No profile found for", player)
	end

	profile.Data.cash += amount

	CashService.clientSync(player, profile.Data.cash)
end

function CashService.takeCash(player: Player, amount: number)
	local profile = DataService.getProfile(player)
	if not profile or (profile and not profile:IsActive()) then
		return warn("[takeCash]: No profile found for", player)
	end

	profile.Data.cash -= amount

	CashService.clientSync(player, profile.Data.cash)
end

return CashService
