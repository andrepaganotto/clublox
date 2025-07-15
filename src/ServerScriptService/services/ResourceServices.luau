local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local Drill = require(ServerScriptService.classes.Drill)

local Resources = require(ServerScriptService.constants.Resources)
local ResourceGen = require(ServerScriptService.constants.ResourceGen)

local Events: { RemoteEvent } = ReplicatedStorage.Remotes.Events

local GENERATION_TICK = 8 -- second

local ResourceService = {
	plots = {} :: {
		[string]: {
			loop: RBXScriptConnection,
			gen: { [Resources.ResourceID]: boolean },
			drills: { [string]: Drill.Drill },
		},
	},
}

function ResourceService.clientSync(player: Player, resources: { [string]: { amount: number, maxAmount: number } })
	Events.UpdateResources:FireClient(player, resources)
end

function ResourceService.generate(PlotID: string, ticks: number)
	local plot = ResourceService.plots[PlotID]
	if not plot then
		return
	end

	local updated = {}
	print("generating")
	for DrillID, drill: Drill.Drill in plot.drills do
		if drill.data.status == "running" then
			local multiplier = plot.gen[drill.data.resource] and ResourceGen.buffedMultiplier
				or ResourceGen.defaultMultiplier
			local resourceAmount = drill:Generate(ticks * multiplier)

			updated[DrillID] = resourceAmount
		end
	end

	print(updated)
	-- Events.UpdateDrills:FireClient(player, updated)
end

function ResourceService.addDrill(PlotID: string, DrillID: string, drill: Drill.Drill)
	local plot = ResourceService.plots[PlotID]
	if not plot then
		return
	end

	plot.drills[DrillID] = drill
end

function ResourceService.addPlot(PlotID: string, gen)
	local acc = 0
	print(gen)
	ResourceService.plots[PlotID] = {
		gen = gen,
		drills = {},
		loop = RunService.Heartbeat:Connect(function(dt)
			acc += dt
			if acc >= GENERATION_TICK then
				ResourceService.generate(PlotID, GENERATION_TICK)
				acc %= GENERATION_TICK
			end

			-- BuildingService.update(player, plot)
		end),
	}
end

return ResourceService
