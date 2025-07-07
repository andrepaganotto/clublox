local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ResourcesData = require(ServerScriptService.constants.Resources)

local DataService = require(ServerScriptService.services.DataService)
local ResourceService = require(ServerScriptService.services.ResourceServices)

local PlotData = require(ServerScriptService.constants.PlotData)

local PlotService = {}

local GENERATION_TICK = 8 -- second

local plots = {}

function PlotService.create()
	local plot: PlotData.Plot = {
		lastUpdatedAt = false,
		resources = {},
	}

	local baseRates = {}
	for resource, resourceData in ResourcesData do
		if typeof(resourceData) == "number" then
			continue
		end
		baseRates[resource] = resourceData.spawnRate
		plot.resources[resource] = {
			gen = {
				base = 1, -- create the generator defaults
				multiplier = PlotData.defaultMultiplier,
			},
			amount = PlotData.defaultAmount,
			maxAmount = PlotData.defaultMaxAmount,
		}
	end

	for i = 1, ResourcesData.maxBuffCount do
		local sum = 0
		for _, val in baseRates do
			sum += val
		end

		local draw = math.random() * sum

		for resource, rate in baseRates do
			draw -= rate

			if draw < 0 then
				baseRates[resource] = 0
				plot.resources[resource].gen.multiplier = PlotData.buffMultiplier
				break
			end
		end
	end

	plot.created = true

	return plot
end

function PlotService.start(player: Player, profile)
	local plot: PlotData.Plot = profile.Data.plot

	if not plot.created then
		profile.Data.plot = PlotService.create()
		plot = profile.Data.plot
	end

	local function generate(ticks)
		local resources = {}
		for resource, value in plot.resources do
			resources[resource] = ticks * value.gen.base * value.gen.multiplier
		end

		plot.lastUpdatedAt = workspace:GetServerTimeNow()

		ResourceService.giveResources(player, resources, profile)
	end

	if plot.lastUpdatedAt then
		local secondsOffline = math.floor(workspace:GetServerTimeNow() - plot.lastUpdatedAt)
		print("time offline:", secondsOffline, "generated:")
		generate(secondsOffline)
	end

	local acc = 0
	plots[profile] = RunService.Heartbeat:Connect(function(dt)
		acc += dt
		if acc >= GENERATION_TICK then
			generate(GENERATION_TICK)
			acc %= GENERATION_TICK
		end
	end)
end

function PlotService.stop(profile)
	if plots[profile] then
		plots[profile]:Disconnect()
		plots[profile] = nil
	end
end

return PlotService
