extends Node2D

signal PhaseChange(phase: Global.Phases)
signal combat_end

@export
var hero_position = 1 #0-2 for allowed locations

const hero_positions = [
	{
		x = 150,
	},
	{
		x = 300,
	},
	{
		x = 450,
	},
]

@export
var enemy_position = 1 #0-2 for allowed locations

const enemy_positions = [
	{
		x = 600,
	},
	{
		x = 750,
	},
	{
		x = 900,
	},
]

var playedCard: Card
var currentPhase: Global.Phases: set = set_phase

func _ready():
	$Hand.constructDeck(Global.playerDeck)
	$Enemy.init(EnemyClass.new({
		name = "Evil Wizard",
		sprite = "",
		health = 50,
		block = 0,
	}))

	currentPhase = Global.TurnOrder[0] as Global.Phases

func _process(_delta):
	$Hero.position = Vector2(hero_positions[hero_position].x, $Hero.position.y)
	$Enemy.position = Vector2(enemy_positions[enemy_position].x, $Enemy.position.y)

func set_phase(value):
	if currentPhase != value:
		currentPhase = value
		PhaseChange.emit(value)

func applyCardEffect(card: CardActions):
	if card.effect == Global.EffectTypes.DAMAGE:
		$Hero.changeState("attack")
		if !enemy_position in card.abilityRange:
			return
		dealDamage($Enemy, card.amount)
		if $Enemy.health <= 0:
			## Fix these state changes later
			$Enemy.changeState("hit")
			$Enemy.changeState("death")
		else:
			$Enemy.changeState("hit")
	if card.effect == Global.EffectTypes.BLOCK:
		$Hero.block += card.amount
	if card.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
		$Hero.changeState("poison")
		$Enemy.damage_over_time = card.amount
	if card.effect == Global.EffectTypes.MOVE_FORWARD && hero_position < 2:
		hero_position += 1
	if card.effect == Global.EffectTypes.MOVE_BACKWARD && hero_position > 0:
		hero_position -= 1

func enemyAttack():
	$Enemy.changeState("attack")
	if !hero_position in $Enemy.chosenAction.abilityRange:
		return
	$Hero.changeState("hit")
	dealDamage($Hero, $Enemy.chosenAction.amount)

func dealDamage(target, amount):
	if target.block >= amount:
		target.block -= amount
	elif target.block > 0:
		amount -= target.block
		target.block = 0
		target.health -= amount
	else:
		target.health -= amount

func _on_phase_change(phase):
	if phase == Global.Phases.COMBAT_END:
		combat_end.emit()

	if $Enemy.health <= 0:
		currentPhase = Global.Phases.COMBAT_END
		return
	if !$AttackTimer.is_stopped():
		await $AttackTimer.timeout

	if phase == Global.Phases.DRAW:
		$Hand.draw()
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.PLAY_CARD:
		pass

	if phase == Global.Phases.PLAYER_COMBAT:
		$AttackTimer.start()
		for action in playedCard.actions:
			applyCardEffect(action)
		playedCard = null
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.PLAYER_CLEANUP:
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.ENEMY_ACTION:
		$AttackTimer.start()
		$Enemy.playCard()
		enemyAttack()
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.ENEMY_CHOOSES_NEXT_ACTION:
		$Enemy.chooseAction()
		$"GUI/Battle Grid".clearTargets()
		for target in $Enemy.chosenAction.abilityRange:
			$"GUI/Battle Grid".targetSpace(target)
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.ENEMY_CLEANUP:
		if $Enemy.damage_over_time > 0:
			$Enemy.changeState("hit")
			$Enemy.health -= $Enemy.damage_over_time
			$Enemy.damage_over_time -= 1
		currentPhase = Global.TurnOrder[0] as Global.Phases
