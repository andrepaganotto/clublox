local TweenService = game:GetService("TweenService")

local DURATION = 1

local tweenInfo = TweenInfo.new(DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local queue = {}

local Animate = {}

function Animate.text(label: TextLabel, from: number, to: number, isCash: boolean): typeof(TweenService:Create())
	local numberValue = Instance.new("NumberValue")
	numberValue.Value = from

	local connection = numberValue:GetPropertyChangedSignal("Value"):Connect(function()
		label.Text = isCash and "$ " .. math.floor(numberValue.Value) or math.floor(numberValue.Value)
	end)

	local tween = TweenService:Create(numberValue, tweenInfo, {
		Value = to,
	})

	tween.Completed:Once(function()
		connection:Disconnect()
		connection = nil
		numberValue:Destroy()
	end)

	return tween
end

-- at the moment this function considers the bar is starting always at 1 and ending at 0, what means its always moving from right to left
function Animate.progressBar(bar: Frame, currVal: number, maxVal: number): typeof(TweenService:Create())
	local tween = TweenService:Create(bar, tweenInfo, {
		Position = UDim2.new(currVal / maxVal * -1 + 1, 0),
	})

	return tween
end

function Animate.add(tween: typeof(TweenService:Create()))
	table.insert(queue, tween)
end

function Animate.play(tween: typeof(TweenService:Create()))
	if tween then
		tween:Play()
		return
	end

	for _, tweenInQueue: typeof(TweenService:Create()) in queue do
		tweenInQueue:Play()
	end
	queue = {}
end

return Animate
