extends Node2D
class_name Map

const location = preload("res://Map/Location/Location.tscn")

signal change_scene(type: LocationClass.Types)

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
		spot.location_event.connect(_on_location_event)
		add_child(spot, true)
		previousLocation = spot
	var spot = location.instantiate()
	spot.type = LocationClass.Types.BOSS
	spot.parent = previousLocation
	spot.position = Vector2(8*100+100, 300)
	spot.location_event.connect(_on_location_event)
	add_child(spot, true)

func _draw():
	for spot in find_children("Location*", "Node2D", true, false):
		if spot.parent != null:
			draw_line(spot.parent.global_position, spot.global_position, Color.BLACK, 2.0)


func _on_location_event(type):
	print(LocationClass.Types.keys()[type])
	change_scene.emit(type)
