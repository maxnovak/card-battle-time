extends Node2D

@export
var health: int

@export
var block: int

@export
var damage_over_time: int

@export
var sprite: Resource

@export
var enemy_name: String

@export
var deck: Array[EnemyCardClass]
var discard: Array[EnemyCardClass]
var chosenAction: EnemyCardClass

func init(enemy: EnemyClass):
	enemy_name = enemy.name
	$AnimatedSprite2D.sprite_frames = enemy.sprite
	$AnimatedSprite2D.play("idle")
	health = enemy.health
	block = enemy.block
	deck = enemy.deck
	chooseAction()

func changeState(new_state):
	$StateMachine._change_state(new_state)

func _process(_delta):
	$HealthTracker.text = str(health)
	if block > 0:
		$BlockTracker.text = str(block)
	else:
		$BlockTracker.text = ""
	if damage_over_time > 0:
		$DoTTracker.text = str(damage_over_time)
	else:
		$DoTTracker.text = ""

func chooseAction():
	if deck.is_empty():
		deck.append_array(discard)
		discard.clear()
	chosenAction = deck.pop_front()
	var action = CardActions.new()
	action.effect = chosenAction.effect
	action.effectRange = chosenAction.abilityRange
	action.effectAmount = chosenAction.amount
	$Card.card.actions = action
	$Card.card.cardName = chosenAction.cardName

func playCard():
	discard.append(chosenAction)
