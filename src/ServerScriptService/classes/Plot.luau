local ServerScriptService = game:GetService("ServerScriptService")

local Resources = require(ServerScriptService.constants.Resources)

export type Plot = {
    id: string,
    model: Model,
    assigned: boolean,
    buildings: {},
    attachPoints: {
        drill: { [Resources.ResourceID]: { Part } },
        storage: { [Resources.ResourceID]: { Part } },
    },
}

local Plot = {}
Plot.__index = Plot

function Plot.new(model: Model): Plot
    local ResourceVeins: Folder = model.veins
    local StorageLines: Folder = model.storages

    local self: Plot = setmetatable({
        id = model.Name,
        model = model,
        assigned = false,
        buildings = {},
        attachPoints = { drill = {}, storage = {} },
    }, Plot)

    for ResourceID in Resources do
        local ResourceVein = ResourceVeins:FindFirstChild(ResourceID)
        local StorageLine = StorageLines:FindFirstChild(ResourceID)

        self.attachPoints.drill[ResourceID] = {}
        self.attachPoints.storage[ResourceID] = {}

        if ResourceVein and StorageLine then
            for _, attachPoint: Part in ResourceVein.attachPoints:GetChildren() do
                local index = string.split(attachPoint.Name, "_")[3]
                table.insert(self.attachPoints.drill[ResourceID], index, attachPoint)
            end

            for _, attachPoint: Part in StorageLine:GetChildren() do
                local index = string.split(attachPoint.Name, "_")[3]
                table.insert(self.attachPoints.storage[ResourceID], index, attachPoint)
            end
        else
            warn(`Theres no {ResourceID} VEIN and/or SLOTS in {model.Name}`)
        end
    end

    return self
end

return Plot
