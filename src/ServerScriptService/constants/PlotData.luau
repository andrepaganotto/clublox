local Resources = require(script.Parent.Resources)

export type ResourceEntry = {
	gen: {
		base: number,
		multiplier: number,
	},
	amount: number,
	maxAmount: number,
}

export type Plot = {
	created: boolean,
	lastUpdatedAt: number,
	resources: { [Resources.ResourceID]: ResourceEntry },
}

return {
	lastUpdatedAt = nil,
	buffMultiplier = 1,
	defaultMultiplier = 0.25,
	defaultAmount = 0,
	defaultMaxAmount = 100,
}
