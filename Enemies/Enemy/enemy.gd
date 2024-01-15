extends Node2D

signal Attack

@export
var health: int

@export
var damage: int

@export
var block: int

@export
var damage_over_time: int

func changeState(new_state):
	$StateMachine._change_state(new_state)

func _on_combat_current_action(actor):
	if actor == Global.Actor.ENEMY && health > 0:
		Attack.emit()

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
