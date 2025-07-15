local ServerStorage = game:GetService("ServerStorage")
local ResourcesGenFolder: Folder = ServerStorage.ResourceGen

local ResourceGen = {} :: {
	maxBuffCount: number,
	defaultMultiplier: number,
	buffedMultiplier: number,
}

for _, Data: NumberValue in ResourcesGenFolder:GetChildren() do
	ResourceGen[Data.Name] = Data.Value
end

return ResourceGen
