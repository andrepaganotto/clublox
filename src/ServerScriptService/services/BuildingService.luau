local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)

local Drill = require(ServerScriptService.classes.Drill)
local Storage = require(ServerScriptService.classes.Storage)
local Building = {
	drill = Drill,
	storage = Storage,
}

local Events: { RemoteEvent } = ReplicatedStorage.Remotes.Events

local BuildingService = {}

function BuildingService.generateID(prefix: string): string
	return `{prefix}_{string.sub(HttpService:GenerateGUID(false), 1, 8)}`
end

function BuildingService.update(player: Player, plot)
	for id, building in plot.currentlyBuilding do
		if workspace:GetServerTimeNow() >= building.finishesAt then
			plot[`{building.type}s`][building.resource][id].status = "running"
			plot.currentlyBuilding[id] = nil
		end
	end
end

function BuildingService.spawn(id, data, plot): Drill.Drill | Storage.Storage
	local attachPoints = plot.attachPoints[data.type][data.resource]
	local attachPoint = attachPoints[data.attachedTo or math.random(1, #attachPoints)]

	plot.buildings[id] = Building[data.type].new(id, data, attachPoint)

	return plot.buildings[id]
end

return BuildingService
