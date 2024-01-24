extends Node2D

func targetSpace(space: int):
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/Asset 84@2x.png")
	sprite.scale = Vector2(0.01, 0.01)
	sprite.rotate(deg_to_rad(90))
	sprite.position.y = -150
	get_children()[space].add_child(sprite)

func clearTargets():
	for child in get_children():
		for deleteMe in child.get_children():
			child.remove_child(deleteMe)
