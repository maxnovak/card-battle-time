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
