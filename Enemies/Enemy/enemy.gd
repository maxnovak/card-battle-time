extends Node2D

signal Attack

@export
var health: int

@export
var damage: int

func changeState(new_state):
	$StateMachine._change_state(new_state)

func _on_combat_current_action(actor):
	if actor == Global.Actor.ENEMY && health > 0:
		Attack.emit()
