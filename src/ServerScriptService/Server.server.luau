local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)
local PlotService = require(ServerScriptService.services.PlotService)

local DataService = require(ServerScriptService.services.DataService)
local CashService = require(ServerScriptService.services.CashService)
local ResourceService = require(ServerScriptService.services.ResourceServices)
local BuildingService = require(ServerScriptService.services.BuildingService)

local Events: { RemoteEvent } = ReplicatedStorage.Remotes.Events

local Players = game:GetService("Players")

local ProfileStore = require(ServerScriptService.lib.ProfileStore)
local PlayerProfileData = require(ServerScriptService.constants.PlayerProfileData)
local PlayerStore = ProfileStore.New("PlayerStore", PlayerProfileData)

local function init(player: Player, profile: typeof(PlayerStore:StartSessionAsync()))
	-- DataService.resetProfile(profile)
	PlotService.assign(player, profile)
	-- PlotService.start(player, profile)

	-- local plot = profile.Data.plot :: typeof(PlotService.create())
	-- local dataToLoad = {
	-- 	cash = profile.Data.cash,
	-- 	resources = {},
	-- 	drills = {},
	-- 	storages = {},
	-- }

	-- for ResourceID, ResourceData in Resources do
	-- 	dataToLoad.resources[ResourceID] = {
	-- 		color = ResourceData.color,
	-- 		icon = ResourceData.icon,
	-- 		layoutOrder = ResourceData.layoutOrder,
	-- 		buffed = plot.gen[ResourceID].buffed,
	-- 		storedTotal = 0,
	-- 		maxCapacity = 0,
	-- 	}

	-- 	for id, storage in plot.storages[ResourceID] do
	-- 		dataToLoad.resources[ResourceID].storedTotal += storage.stored
	-- 		dataToLoad.resources[ResourceID].maxCapacity += storage.capacity

	-- 		dataToLoad.storages[id] = {
	-- 			resource = ResourceID,
	-- 			level = storage.level,
	-- 			stored = storage.stored,
	-- 			capacity = storage.capacity,
	-- 			status = storage.status,
	-- 		}
	-- 	end

	-- 	for id, drill in plot.drills[ResourceID] do
	-- 		dataToLoad.drills[id] = {
	-- 			resource = ResourceID,
	-- 			level = drill.level,
	-- 			stored = drill.stored,
	-- 			capacity = drill.capacity,
	-- 			status = drill.status,
	-- 		}
	-- 	end
	-- end

	-- Events.LoadPlayerData:FireClient(player, dataToLoad)
end

local function playerAdded(player: Player)
	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile()

		profile.OnSessionEnd:Connect(function()
			DataService.Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			DataService.Profiles[player] = profile
			print(`Profile loaded for {player.DisplayName}!`)

			-- Player data successfully loaded
			init(player, profile)
		else
			profile:EndSession()
		end
	else
		player:Kick(`Profile load fail - Please rejoin`)
	end
end

local function playerRemoving(player: Player)
	local profile = DataService.Profiles[player]
	if profile then
		PlotService.unassign(player)
		profile:EndSession()
		DataService.Profiles[player] = nil
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(playerAdded, player)
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
