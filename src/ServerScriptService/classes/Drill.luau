local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)

local Building = require(ServerScriptService.classes.Building)
local BuildingLevels = require(ServerScriptService.constants.BuildingLevels)

export type Drill = Building.Building & {
	genRate: number,
}

local Drill = {}
Drill.__index = Drill

function Drill.new(id: string, data: Building.BuildingData, attachPoint: Part): Drill
	local self: Drill = setmetatable(Building.new(id, data, attachPoint), Drill)

	-- this is setted up everytime the building gets instanciated so it gets the latest update from the server data
	-- whenever the base genRate of a drill level is changed the server will always have the latest value, so do the drill
	self.genRate = BuildingLevels.drill[self.data.level].genRate

	return self
end

function Drill:Generate(ticks: number): number
	local generatedAmount = self.data.stored + (ticks * self.genRate)

	if generatedAmount > self.capacity then
		generatedAmount = self.capacity
		self.data.status = "full"
	end

	self.data.stored = generatedAmount
	self.data.lastGenAt = workspace:GetServerTimeNow()

	return generatedAmount
end

function Drill:Animate() end

function Drill:Collect()
	-- fire the server to collect this drill resources
end

function Drill:Upgrade()
	-- TODO > Upgrade logic
end

function Drill:CancelUpgrade()
	-- TODO > Cancel upgrade logic
end

function Drill:Sell()
	-- TODO > Sell logic
end

return Drill
