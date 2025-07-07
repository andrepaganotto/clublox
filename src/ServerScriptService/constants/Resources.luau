export type ResourceID = "iron" | "copper" | "coal" | "water"

export type Resource = {
	spawnRate: number,
}

export type Resources = {
	maxBuffCount: number,
	iron: Resource,
	copper: Resource,
	coal: Resource,
	water: Resource,
}

return {
	maxBuffCount = 2,
	iron = {
		spawnRate = 0.25,
	},
	copper = {
		spawnRate = 0.25,
	},
	coal = {
		spawnRate = 0.20,
	},
	water = {
		spawnRate = 0.30,
	},
} :: Resources

-- the spawnRate sum of all resource types MUST ALWAYS BE 1
-- the maxBuffCount MUST ALWAYS BE > 0 and < the amount of Resources
