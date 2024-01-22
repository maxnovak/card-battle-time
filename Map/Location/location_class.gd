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

const TypeTextureMap = {
	Types.UNDEFINED: "",
	Types.BATTLE : "res://assets/map/unvisted-battle.png",
	Types.BOSS : "res://assets/map/unvisted-boss.png",
	Types.CARD : "res://assets/map/unvisted-card.png",
	Types.VISITED_BATTLE : "res://assets/map/visted.png",
	Types.VISITED_BOSS : "res://assets/map/visted.png",
	Types.VISITED_CARD : "res://assets/map/visted.png",
}

const VisitedLocationMap = {
	Types.BATTLE : Types.VISITED_BATTLE,
	Types.BOSS : Types.VISITED_BOSS,
	Types.CARD : Types.VISITED_CARD,
}

const TooltipMap = {
	Types.BATTLE : "Fight some enemies",
	Types.BOSS : "Final Fight",
	Types.CARD : "Pick up a new card",
}
