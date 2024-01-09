extends "res://state_machine/state.gd"
# The stagger state end with the stagger animation from the AnimationPlayer.
# The animation only affects the Body Sprite2D's modulate property so it
# could stack with other animations if we had two AnimationPlayer nodes.

func enter():
	owner.get_node(^"AnimatedSprite2D").play("hit")

func _on_animation_finished():
	emit_signal("finished", "idle")
