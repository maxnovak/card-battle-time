extends "res://state_machine/state.gd"

func enter():
	owner.get_node(^"AnimatedSprite2D").play("idle")
