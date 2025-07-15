local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = player.PlayerGui:WaitForChild("root")

export type ClientPlayerData = {
	cash: {
		label: TextLabel,
		amount: number,
	},
	resources: {
		[string]: {
			label: TextLabel,
			bar_fill: Frame,
			storedTotal: number, -- the sum of all resources stored in storages
			maxCapacity: number, -- the sum of all storages capacity
			buffed: boolean,
		},
	},
	-- plot: {
	-- 	storages: { [string]: Storage },
	-- 	drills: { [string]: Drill },
	-- },
}

local ClientPlayerData: ClientPlayerData = {
	cash = {
		label = gui:WaitForChild("cash_label") :: TextLabel,
		amount = 0,
	},
	resources = {},
	plot = {
		storages = {},
		drills = {},
	},
}

-- TODO > change this so the server tells the client which resources to create UI for, based on a template
-- for _, resource in gui:WaitForChild("resources"):GetChildren() do
-- 	if not resource:IsA("Frame") then
-- 		continue
-- 	end

-- 	local bar = resource:WaitForChild("bar") :: Frame

-- 	ClientPlayerData.resources[resource.Name] = {
-- 		label = bar:WaitForChild("amount_label"),
-- 		bar_fill = bar:WaitForChild("bar_fill"),
-- 		amount = 0,
-- 		maxAmount = 100,
-- 	}
-- end

return ClientPlayerData
