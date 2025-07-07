local PlotData = require(script.Parent.PlotData)

export type PlayerProfileData = {
	cash: number,
	plot: PlotData.Plot,
}

return {
	cash = 1000,
	plot = {},
} :: PlayerProfileData
