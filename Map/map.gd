extends Node2D

const location = preload("res://Map/Location/Location.tscn")

func _ready():
	var previousLocation: Node2D
	for i in range(4):
		var spot = location.instantiate()
		spot.type = LocationClass.LocationTypes.BATTLE
		spot.parent = previousLocation
		spot.position = Vector2(i*100+100, 300)
		add_child(spot, true)
		previousLocation = spot

func _draw():
	for location in find_children("Location*", "Node2D", true, false):
		if location.parent != null:
			draw_line(location.parent.global_position, location.global_position, Color.BLACK, 2.0)
