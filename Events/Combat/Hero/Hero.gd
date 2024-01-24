extends Node2D

@export
var health: int

@export
var block: int

@export
var damage_over_time: int

func changeState(new_state):
	$StateMachine._change_state(new_state)

func _process(_delta):
	$HealthTracker.text = str(health)
	if block > 0:
		$BlockTracker.text = str(block)
	else:
		$BlockTracker.text = ""
