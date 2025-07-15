local ServerStorage = game:GetService("ServerStorage")
local ResourcesFolder: Folder = ServerStorage.Resources

export type ResourceID = "iron" | "copper" | "coal" | "silicon" | "uranium"

export type Resource = {
	spawnRate: number,
	color: Color3Value,
	layoutOrder: number,
	icon: string,
}

local Resources = {
	iron = {} :: Resource,
	copper = {} :: Resource,
	coal = {} :: Resource,
	silicon = {} :: Resource,
	uranium = {} :: Resource,
}

for _, Resource: Instance in ResourcesFolder:GetChildren() do
	if Resource:IsA("Configuration") and Resources[Resource.Name] ~= nil then
		for _, property in Resource:GetChildren() do
			Resources[Resource.Name][property.Name] = property.Value
		end
	else
		warn("Inconsistency between ServerStorage Resources and Resources module. Failed to load:", Resource.Name)
	end
end

return Resources

-- the spawnRate sum of all resource types MUST ALWAYS BE 1
-- the maxBuffCount MUST ALWAYS BE > 0 and < the amount of Resources
