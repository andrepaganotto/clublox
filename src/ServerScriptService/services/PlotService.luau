local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)
local ResourceGen = require(ServerScriptService.constants.ResourceGen)

local DataService = require(ServerScriptService.services.DataService)
local ResourceService = require(ServerScriptService.services.ResourceServices)
local BuildingService = require(ServerScriptService.services.BuildingService)
local PlotClass = require(ServerScriptService.classes.Plot)

local PlotService = {}

local PlotModels = workspace:WaitForChild("plots"):GetChildren()
local availablePlots = {}
local plots = {} :: { [Player]: PlotClass.Plot }

for _, model: Model in PlotModels do
        table.insert(availablePlots, PlotClass.new(model))
end

type PlotData = {
	currentlyBuilding: {
		[string]: {
			type: "storage" | "drill",
			resource: Resources.ResourceID,
			finishesAt: number,
		},
	},
	buildings: {
		[string]: typeof(BuildingService.spawn()),
	},
	gen: {
		[Resources.ResourceID]: {
			buffed: boolean,
			multiplier: number,
		},
	},
}

type Plot = PlotClass.Plot & {
        data: PlotData,
        loop: RBXScriptConnection?,
}

function PlotService.create(): PlotData
	print("creating plot")
	local plot: PlotData = {
		currentlyBuilding = {},
		buildings = {},
		gen = {},
	}

	local genRates = {}
	for ResourceID, ResourceData in Resources do
		genRates[ResourceID] = ResourceData.spawnRate
		plot.gen[ResourceID] = false

		-- Starter storages
		plot.buildings[BuildingService.generateID("storage")] = {
			type = "storage",
			resource = ResourceID,
			level = 1,
			stored = 0,
			attachedTo = 1,
			status = "running",
		}

		plot.buildings[BuildingService.generateID("drill")] = {
			type = "drill",
			resource = ResourceID,
			level = 1,
			stored = 0,
			status = "running",
		}
	end

	for i = 1, ResourceGen.maxBuffCount do
		local sum = 0
		for _, val in genRates do
			sum += val
		end

		local draw = math.random() * sum

		for ResourceID, rate in genRates do
			draw -= rate

			if draw < 0 then
				genRates[ResourceID] = 0
				plot.gen[ResourceID] = true
				break
			end
		end
	end

	return plot
end

function PlotService.assign(player: Player, profile)
	if not profile.Data.plot then
		profile.Data.plot = PlotService.create()
	end

	local plot: Plot = table.remove(availablePlots, math.random(1, #availablePlots))
	plot.assigned = true
	plot.data = profile.Data.plot

	ResourceService.addPlot(plot.id, plot.data.gen)

	for id, building in plot.data.buildings do
		local buildingInstance = BuildingService.spawn(id, building, plot)

		if building.type == "drill" then
			ResourceService.addDrill(plot.id, id, buildingInstance)
		end
	end

	plots[player] = plot
end

function PlotService.unassign(player: Player)
	local plot = plots[player]
	if not plot then
		return
	end

	if plot.loop then
		plot.loop:Disconnect()
		plot.loop = nil
	end
	plot.data = nil
	plot.assigned = false

	plots[player] = nil

	table.insert(availablePlots, plot)
end

return PlotService
