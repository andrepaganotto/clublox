local ServerStorage = game:GetService("ServerStorage")
local DrillsFolder: Folder = ServerStorage.Drills
local StoragesFolder: Folder = ServerStorage.Storages

export type BuildingLevel = {
	capacity: number,
	genRate: number?,
	buildTime: number, -- time in seconds
	buildCost: number, -- cost in cash
	prefab: Model,
}

local BuildingLevels = {
	drill = {} :: { BuildingLevel },
	storage = {} :: { BuildingLevel },
}

task.spawn(function()
	for _, level: Instance in StoragesFolder:GetChildren() do
		if not level:IsA("Configuration") then
			continue
		end

		local index = string.split(level.Name, "_")[2]

		local levelData = {}
		for _, property in level:GetChildren() do
			levelData[property.Name] = property.Value
		end

		table.insert(BuildingLevels.storage, index, levelData)
	end

	if #BuildingLevels.storage ~= #StoragesFolder:GetChildren() then
		warn("[StorageLevels]: Theres a level not following the integer order in the folder")
	end
end)

task.spawn(function()
	for _, level: Instance in DrillsFolder:GetChildren() do
		if not level:IsA("Configuration") then
			continue
		end

		local index = string.split(level.Name, "_")[2]

		local levelData = {}
		for _, property in level:GetChildren() do
			levelData[property.Name] = property.Value
		end

		table.insert(BuildingLevels.drill, index, levelData)
	end

	if #BuildingLevels.drill ~= #DrillsFolder:GetChildren() then
		warn("[DrillLevels]: Theres a level not following the integer order in the folder")
	end
end)

return BuildingLevels
