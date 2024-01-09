extends Node2D

@export
var health: int

@export
var damage: int

func changeState(new_state):
	$StateMachine._change_state(new_state)
