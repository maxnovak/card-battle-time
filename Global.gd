extends Node

enum EffectTypes {
	UNDEFINED,
	BLOCK,
	DAMAGE,
	DAMAGE_OVER_TIME,
	MOVEMENT,
}

enum Actor {
	UNDEFINED,
	ENEMY,
	PLAYER,
}

enum Direction {
	UNDEFINED,
	FORWARD,
	BACKWARDS,
}

enum Phases {
	UNDEFINED, #For undefined times
	DRAW, #Draw a card
	PLAY_CARD, #Enable player and let them click things and then disable when not this phase
	PLAYER_COMBAT, #Apply damage or movement or block based on card
	PLAYER_CLEANUP, #Apply DoTs or Status effects or other end of turn things to the Enemy
	ENEMY_ACTION, #Enemy chooses action and does it
	ENEMY_CHOOSES_NEXT_ACTION, #Enemy action is chosen and displayed to player
	ENEMY_CLEANUP, #Apply Enemy DoTs and things
	COMBAT_END,
}

const TurnOrder = [
	Phases.DRAW,
	Phases.ENEMY_CHOOSES_NEXT_ACTION,
	Phases.PLAY_CARD,
	Phases.PLAYER_COMBAT,
	Phases.PLAYER_CLEANUP,
	Phases.ENEMY_ACTION,
	Phases.ENEMY_CLEANUP,
]

var HuntressDeck: Array[CardClass] = [
	CardClass.new({
		cardName = "Dash",
		amount = 1,
		effect = EffectTypes.MOVEMENT,
		direction = Direction.FORWARD,
		flippedCard = CardClass.new({
			cardName = "Dash Back",
			amount = 1,
			effect = EffectTypes.MOVEMENT,
			direction = Direction.BACKWARDS,
		}),
	}),
	CardClass.new({
		cardName = "Dash",
		amount = 1,
		effect = EffectTypes.MOVEMENT,
		direction = Direction.FORWARD,
		flippedCard = CardClass.new({
			cardName = "Dash Back",
			amount = 1,
			effect = EffectTypes.MOVEMENT,
			direction = Direction.BACKWARDS,
		}),
	}),
	CardClass.new({
		cardName = "Spear",
		amount = 7,
		effect = EffectTypes.DAMAGE,
	}),
	CardClass.new({
		cardName = "Spear",
		amount = 7,
		effect = EffectTypes.DAMAGE,
	}),
	CardClass.new({
		cardName = "Spear",
		amount = 7,
		effect = EffectTypes.DAMAGE,
	}),
	CardClass.new({
		cardName = "Poison",
		amount = 5,
		effect = EffectTypes.DAMAGE_OVER_TIME,
	}),
	CardClass.new({
		cardName = "Defend",
		amount = 10,
		effect = EffectTypes.BLOCK,
	}),
	CardClass.new({
		cardName = "Defend",
		amount = 10,
		effect = EffectTypes.BLOCK,
	}),
	CardClass.new({
		cardName = "Defend",
		amount = 10,
		effect = EffectTypes.BLOCK,
	}),
]
