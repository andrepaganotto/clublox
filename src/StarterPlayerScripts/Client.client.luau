local clientData = require(script.Parent:WaitForChild("ClientPlayerData"))
local plot = clientData.plot

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animate = require(script.Parent.ui:WaitForChild("Animate"))

local Events = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

Events.UpdateCash.OnClientEvent:Connect(function(cashAmount: number)
	Animate.play(Animate.text(clientData.cash.label, clientData.cash.amount, cashAmount, true))
	clientData.cash.amount = cashAmount
end)

Events.UpdateResources.OnClientEvent:Connect(
	function(resourcesData: { [string]: { amount: number, maxAmount: number } })
		for resource: string, data in resourcesData do
			Animate.add(Animate.progressBar(plot.resources[resource].bar_fill, data.amount, data.maxAmount))
			Animate.add(Animate.text(plot.resources[resource].label, plot.resources[resource].amount, data.amount))

			plot.resources[resource].amount = data.amount
		end

		Animate.play()
	end
)
