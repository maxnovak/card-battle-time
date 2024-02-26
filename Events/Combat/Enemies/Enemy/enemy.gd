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
var deck: Array[Card]
var discard: Array[Card]
var chosenAction: Card
var resourceName: String

func init(enemy: EnemyClass):
	var resourceFolder = "res://Events/Combat/Enemies/Enemy/EnemyResources/" + enemy.resourceName + "/"
	var files = DirAccess.get_files_at(resourceFolder + "Cards/")
	for card in files:
		deck.append(load(resourceFolder + "Cards/" + card.replace(".remap", "")))
	enemy_name = enemy.name
	$AnimatedSprite2D.sprite_frames = load(resourceFolder + "animations.tres")
	$AnimatedSprite2D.play("idle")
	health = enemy.health
	block = enemy.block
	resourceName = enemy.resourceName

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
	$Card.card.actions = chosenAction.actions
	$Card.card.cardName = chosenAction.cardName

func reposition():
	discard.append(chosenAction)
	var resourceFolder = "res://Events/Combat/Enemies/Enemy/EnemyResources/" + resourceName + "/"
	chosenAction = load(resourceFolder + "reposition.tres")
	$Card.card.actions = chosenAction.actions
	$Card.card.cardName = chosenAction.cardName

func playCard():
	discard.append(chosenAction)
