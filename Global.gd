extends Node

enum EffectTypes {
	UNDEFINED,
	BLOCK,
	DAMAGE,
	DAMAGE_OVER_TIME,
	COPY_DAMAGE,
}

enum MovementTypes {
	UNDEFINED,
	MOVE_FORWARD,
	MOVE_BACKWARD,
	PULL_ENEMY,
	PUSH_ENEMY,
}

enum Actor {
	UNDEFINED,
	ENEMY,
	PLAYER,
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
	Phases.ENEMY_CHOOSES_NEXT_ACTION,
	Phases.PLAY_CARD,
	Phases.PLAYER_COMBAT,
	Phases.PLAYER_CLEANUP,
	Phases.DRAW,
	Phases.ENEMY_ACTION,
	Phases.ENEMY_CLEANUP,
]

var playerDeck: Array[Card] = []

var enemies: Array[EnemyClass] = [
	EnemyClass.new({
		name = "Goblin",
		resourceName = "Goblin",
		health = 12,
		block = 0,
	}),
]

var bosses: Array[EnemyClass] = [
	EnemyClass.new({
		name = "Fire Wizard",
		resourceName = "FireWizard",
		health = 50,
		block = 0,
	}),
]
