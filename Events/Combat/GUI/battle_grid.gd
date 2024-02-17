extends Node2D

func targetSpace(space: int):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/Asset 84@2x.png")
	sprite.scale = Vector2(0.01, 0.01)
	sprite.rotate(deg_to_rad(90))
	sprite.position.y = -150
	get_tree().get_nodes_in_group("PlayerNodes")[space-1].add_child(sprite)

func clearTargets():
	for child in get_children():
		for deleteMe in child.get_children():
			child.remove_child(deleteMe)

func _on_hand_show_range(effect_range):
	for space in get_tree().get_nodes_in_group("EnemyNodes"):
		for child in space.get_children():
			child.queue_free()
	for space in effect_range:
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/cards/Asset 84@2x.png")
		sprite.scale = Vector2(0.01, 0.01)
		sprite.rotate(deg_to_rad(90))
		sprite.position.y = -150
		get_tree().get_nodes_in_group("EnemyNodes")[space-1].add_child(sprite)
