class_name LocationClass

enum Types {
	UNDEFINED,
	BOSS,
	BATTLE,
	CARD,
	VISITED_BOSS,
	VISITED_BATTLE,
	VISITED_CARD,
}

const TypeMap = {
	Types.BATTLE : "res://assets/map/unvisted-battle.png",
	Types.BOSS : "res://assets/map/unvisted-boss.png",
	Types.CARD : "res://assets/map/unvisted-card.png",
	Types.VISITED_BATTLE : "res://assets/map/visted.png",
	Types.VISITED_BOSS : "res://assets/map/visted.png",
	Types.VISITED_CARD : "res://assets/map/visted.png",
}

const TooltipMap = {
	Types.BATTLE : "Fight some enemies",
	Types.BOSS : "Final Fight",
	Types.CARD : "Pick up a new card",
}
