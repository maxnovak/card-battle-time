extends Node2D

@export
var health: int

@export
var emotionalHealth: float

@export
var block: int

func changeState(new_state):
	$StateMachine._change_state(new_state)
