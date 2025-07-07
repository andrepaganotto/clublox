local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = player.PlayerGui:WaitForChild("root")

type ClientPlayerData = {
	cash: {
		label: TextLabel,
		amount: number,
	},
	plot: {
		resources: {
			[string]: {
				label: TextLabel,
				bar_fill: Frame,
				amount: number,
				maxAmount: number,
			},
		},
	},
}

local ClientPlayerData: ClientPlayerData = {
	cash = {
		label = gui:WaitForChild("cash_label") :: TextLabel,
		amount = 0,
	},
	plot = {
		resources = {},
	},
}

-- TODO > change this so the server tells the client which resources to create UI for, based on a template
for _, resource in gui:WaitForChild("resources"):GetChildren() do
	if not resource:IsA("Frame") then
		continue
	end

	local bar = resource:WaitForChild("bar") :: Frame

	ClientPlayerData.plot.resources[resource.Name] = {
		label = bar:WaitForChild("amount_label"),
		bar_fill = bar:WaitForChild("bar_fill"),
		amount = 0,
		maxAmount = 100,
	}
end

return ClientPlayerData
