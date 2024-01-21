class_name LocationClass

enum LocationTypes {
	UNDEFINED,
	BOSS,
	BATTLE,
	ITEM,
	VISITED_BOSS,
	VISITED_BATTLE,
	VISITED_ITEM,
}

const LocationTypeMap = {
	LocationTypes.BATTLE : "res://assets/map/unvisted-node-battle.png",
}
