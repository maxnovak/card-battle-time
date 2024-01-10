extends "res://state_machine/state.gd"

func enter():
	owner.get_node(^"AnimatedSprite2D").play("hit")

func _on_animation_finished():
	emit_signal("finished", "idle")
