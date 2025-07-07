local ServerScriptService = game:GetService("ServerScriptService")
local ProfileStore = require(ServerScriptService.lib.ProfileStore)

local DataService = require(ServerScriptService.services.DataService)
local CashService = require(ServerScriptService.services.CashService)
local ResourceService = require(ServerScriptService.services.ResourceServices)
local PlotService = require(ServerScriptService.services.PlotService)

local Players = game:GetService("Players")

local PlayerProfileData = require(ServerScriptService.constants.PlayerProfileData)
local PlayerStore = ProfileStore.New("PlayerStore", PlayerProfileData)

local function init(player: Player, profile: typeof(PlayerStore:StartSessionAsync()))
	-- DataService.resetProfile(profile)
	PlotService.start(player, profile)
	CashService.clientSync(player, profile.Data.cash)
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
		PlotService.stop(profile)
		profile:EndSession()
		DataService.Profiles[player] = nil
	end
end

for _, player in Players:GetPlayers() do
	task.spawn(playerAdded, player)
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)
