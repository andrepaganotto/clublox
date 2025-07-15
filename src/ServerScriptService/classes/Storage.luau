local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)
local Building = require(ServerScriptService.classes.Building)

export type Storage = Building.Building & {}

local Storage = {}
Storage.__index = Storage

function Storage.new(id: string, data: Building.BuildingData, attachPoint: Part): Storage
	local self: Storage = setmetatable(Building.new(id, data, attachPoint), Storage)

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
