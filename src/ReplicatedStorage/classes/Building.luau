local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Binder = require(ReplicatedStorage.Binder)

local Buildings = {}

local Building = {}
Building.__index = Building
Building.TAG = "Building"
Building.Binder = Binder.new(Building.TAG, Building)

function Building.new(instance: Model)
	local self = setmetatable({
		Instance = instance,
	}, Building)

	local prompt = Instance.new("ProximityPrompt")
	prompt.MaxActivationDistance = 5
	prompt.Parent = self.Instance
	prompt.ActionText = "all can see"

	if instance:IsDescendantOf(workspace) then
		Buildings[self.Instance.Name] = self
	end

	return self
end

function Building:update(action: string, data: any)
	-- hey
end

function Building:destroy()
	self.Instance = nil
end

Building.Binder:bind()

return Buildings
