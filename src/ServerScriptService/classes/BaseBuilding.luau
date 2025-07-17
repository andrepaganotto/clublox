local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)
local BuildingLevels = require(ServerScriptService.constants.BuildingLevels)

-- This data is a direct reference to plot data saved in db
export type BuildingData = {
	type: "storage" | "drill",
	resource: Resources.ResourceID,
	level: number,
	stored: number,
	lastGenAt: number?, -- drill only
	attachedTo: number,
	status: "full" | "running" | "building",
}

export type Building = {
	id: string,
	data: BuildingData,
	Instance: Model,
	fill: Part,
	capacity: number,
}

local BaseBuilding = {}
BaseBuilding.__index = BaseBuilding

function BaseBuilding.new(id: string, data: BuildingData, attachPoint: Part): Building
    local self = {
		id = id,
		data = data,
	}

	local level = BuildingLevels[data.type][data.level]

	self.Instance = level.prefab:Clone()
	self.Instance.Name = id
	self.Instance.Parent = attachPoint
	self.Instance:PivotTo(attachPoint:GetPivot())

	self.fill = self.Instance:WaitForChild("fill")
	self.fill.Color = Resources[self.data.resource].color

	self.capacity = level.capacity

    return self
end

return BaseBuilding
