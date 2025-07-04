export type PlayerProfileData = {
	Cash: number,
	Items: { [number]: any },
}

return {
	Cash = 1000,
	items = {},
} :: PlayerProfileData
