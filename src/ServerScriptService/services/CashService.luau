local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.services.DataService)

local Events = ReplicatedStorage.Remotes.Events

local CashService = {}

function CashService.syncCashValue(player: Player, value: number)
	local leaderstats = player:FindFirstChild("leaderstats")
	local Cash = leaderstats and leaderstats.Cash

	if not leaderstats then
		leaderstats = Instance.new("Folder", player)
		leaderstats.Name = "leaderstats"

		Cash = Instance.new("IntValue", leaderstats)
		Cash.Name = "Cash"
	end

	Cash.Value = value

	Events.UpdateCash:FireClient(player, value)
end

function CashService.giveCash(player: Player, amount: number)
	local profile = DataService.getProfile(player)
	if not profile then
		return
	end

	profile.Data.Cash += amount

	CashService.syncCashValue(player, profile.Data.Cash)
end

function CashService.takeCash(player: Player, amount: number)
	local profile = DataService.getProfile(player)
	if not profile then
		return
	end

	profile.Data.Cash -= amount

	CashService.syncCashValue(player, profile.Data.Cash)
end

return CashService
