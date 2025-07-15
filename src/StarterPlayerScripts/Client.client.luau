local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animate = require(ReplicatedStorage:WaitForChild("Animate"))
local Buildings = require(ReplicatedStorage.classes.Building)

local Data = require(script.Parent:WaitForChild("ClientPlayerData"))

local Events: { RemoteEvent } = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

function UpdateCash(cashAmount: number)
	Animate.play(Animate.text(Data.cash.label, Data.cash.amount, cashAmount, true))
	Data.cash.amount = cashAmount
end

function UpdateBuilding(id: string, action: string, data: {})
	local building = Buildings[id]
	if not building then
		return
	end

	building:update(action, data)
end

Events.UpdateCash.OnClientEvent:Connect(UpdateCash)

Events.UpdateBuilding.OnClientEvent:Connect(UpdateBuilding)

-- Events.UpdateResources.OnClientEvent:Connect(
-- 	function(resourcesData: { [string]: { amount: number, maxAmount: number } })
-- 		for resource: string, data in resourcesData do
-- 			Animate.add(Animate.progressBar(plot.resources[resource].bar_fill, data.amount, data.maxAmount))
-- 			Animate.add(Animate.text(plot.resources[resource].label, plot.resources[resource].amount, data.amount))

-- 			plot.resources[resource].amount = data.amount
-- 		end

-- 		Animate.play()
-- 	end
-- )
