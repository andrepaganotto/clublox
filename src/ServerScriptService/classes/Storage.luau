local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)
local BaseBuilding = require(ServerScriptService.classes.BaseBuilding)

export type Storage = BaseBuilding.Building & {
        base: BaseBuilding.Building,
}

local Storage = {}
Storage.__index = Storage

function Storage.new(id: string, data: BaseBuilding.BuildingData, attachPoint: Part): Storage
        local building = BaseBuilding.new(id, data, attachPoint)

        local self: Storage = setmetatable({
                base = building,
                data = building.data,
                Instance = building.Instance,
                fill = building.fill,
                capacity = building.capacity,
        }, Storage)

	return self
end

function Storage:Animate() end

function Storage:Upgrade()
	-- TODO > Upgrade logic
end

function Storage:CancelUpgrade()
	-- TODO > Cancel upgrade logic
end

function Storage:Sell()
	-- TODO > Sell logic
end

return Storage
