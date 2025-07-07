local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)
local plotData = require(ServerScriptService.constants.PlotData)
local DataService = require(ServerScriptService.services.DataService)

local Events = ReplicatedStorage.Remotes.Events

local ResourceService = {}

function ResourceService.clientSync(player: Player, resources: { [string]: { amount: number, maxAmount: number } })
	Events.UpdateResources:FireClient(player, resources)
end

function ResourceService.giveResource(player: Player, resource: Resources.ResourceID, amount: number, _profile): number
	local profile = _profile and _profile or DataService.getProfile(player)
	if not profile or (profile and not profile:IsActive()) then
		return warn("[giveResource]: No profile found for", player)
	end

	local plot: plotData.Plot = profile.Data.plot

	local currentAmount = plot.resources[resource].amount
	local maxAmount = plot.resources[resource].maxAmount

	local finalValue = currentAmount + amount
	local delta = nil

	if finalValue > maxAmount then
		delta = finalValue - maxAmount
		finalValue = maxAmount
	end

	plot.resources[resource].amount = finalValue

	ResourceService.clientSync(player, {
		[resource] = {
			amount = finalValue,
			maxAmount = maxAmount,
		},
	})

	return delta
end

function ResourceService.giveResources(player: Player, resources: { [Resources.ResourceID]: number }, _profile)
	local profile = _profile and _profile or DataService.getProfile(player)
	if not profile or (profile and not profile:IsActive()) then
		return warn("[giveResource]: No profile found for", player)
	end

	local plot = profile.Data.plot

	local delta = {}
	local givenResources = {}
	for resource, amount in resources do
		local currentAmount = plot.resources[resource].amount
		local maxAmount = plot.resources[resource].maxAmount

		local finalValue = currentAmount + amount
		delta[resource] = nil

		if finalValue > maxAmount then
			delta[resource] = finalValue - maxAmount
			finalValue = maxAmount
		end

		plot.resources[resource].amount = finalValue

		givenResources[resource] = { amount = finalValue, maxAmount = maxAmount }
	end

	ResourceService.clientSync(player, givenResources)

	return delta
end

function ResourceService.takeResource(player: Player, resource: string, amount: number)
	local profile = DataService.getProfile(player)
	if not profile or (profile and not profile:IsActive()) then
		return warn("[takeResource]: No profile found for", player)
	end

	local plot = profile.Data.plot

	local currentValue = plot.resources[resource].value
	local finalValue = currentValue - amount
	local delta = nil

	if finalValue < 0 then
		delta = finalValue * -1
		finalValue = 0
	end

	plot.resources[resource].value = finalValue

	ResourceService.clientSync(player, { [resource] = plot.resources[resource] })

	return delta
end

return ResourceService
