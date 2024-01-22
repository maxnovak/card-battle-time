extends Node2D

const location = preload("res://Map/Location/Location.tscn")

const LocationTypes = [
	LocationClass.Types.BATTLE,
	LocationClass.Types.CARD,
]
var rng = RandomNumberGenerator.new()

func _ready():
	var previousLocation: Node2D
	for i in range(8):
		var spot = location.instantiate()
		spot.type = LocationTypes[rng.randi_range(0, LocationTypes.size()-1)]
		spot.parent = previousLocation
		spot.position = Vector2(i*100+100, 300)
		add_child(spot, true)
		previousLocation = spot
	var spot = location.instantiate()
	spot.type = LocationClass.Types.BOSS
	spot.parent = previousLocation
	spot.position = Vector2(8*100+100, 300)
	add_child(spot, true)

func _draw():
	for location in find_children("Location*", "Node2D", true, false):
		if location.parent != null:
			draw_line(location.parent.global_position, location.global_position, Color.BLACK, 2.0)
