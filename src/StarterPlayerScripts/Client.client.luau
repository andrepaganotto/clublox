local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")

local player = Players.LocalPlayer

local gui = player.PlayerGui:WaitForChild("Main")
local cashTextLabel = gui:WaitForChild("Cash") :: TextLabel

Events.UpdateCash.OnClientEvent:Connect(function(cashAmount: number)
	cashTextLabel.Text = `$ {cashAmount}`
end)
