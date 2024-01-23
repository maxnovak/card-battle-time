extends Node2D
class_name Map

const location = preload("res://Map/Location/Location.tscn")

signal change_scene(type: LocationClass.Types)

const LocationTypes = [
	LocationClass.Types.BATTLE,
	LocationClass.Types.CARD,
]
var rng = RandomNumberGenerator.new()

const NumberOfLocations = 8
const LocationStepDistance = 100
const LocationMinHeight = 270
const LocationMaxHeight = 320
const MountainMinSize = 0.5
const MountainMaxSize = 1.0
const MountainMinX = 25
const MountainMaxX = 990
const MountainTopMinY = 45
const MountainTopMaxY = 200
const MountainBottomMinY = 400
const MountainBottomMaxY = 575

func _ready():
	populateLandscape()
	createLocations()

func createLocations():
	var previousLocation: Node2D
	for i in range(NumberOfLocations):
		var spot = location.instantiate()
		spot.type = LocationTypes[rng.randi_range(0, LocationTypes.size()-1)]
		spot.parent = previousLocation
		spot.position = Vector2(
			i*LocationStepDistance+LocationStepDistance,
			rng.randi_range(LocationMinHeight, LocationMaxHeight)
		)
		spot.location_event.connect(_on_location_event)
		add_child(spot, true)
		previousLocation = spot
	var spot = location.instantiate()
	spot.type = LocationClass.Types.BOSS
	spot.parent = previousLocation
	spot.position = Vector2(NumberOfLocations*LocationStepDistance+LocationStepDistance, 300)
	spot.location_event.connect(_on_location_event)
	add_child(spot, true)

func populateLandscape():
	#Top Range
	for i in range(randi_range(1, 3)):
		var mountain = Sprite2D.new()
		mountain.texture = load("res://assets/map/mountain.png")
		mountain.position = Vector2(
			rng.randi_range(MountainMinX, MountainMaxX),
			rng.randi_range(MountainTopMinY, MountainTopMaxY)
		)
		var scale = randf_range(MountainMinSize, MountainMaxSize)
		mountain.scale = Vector2(scale, scale)
		add_child(mountain)

	#Bottom Range
	for i in range(randi_range(1, 3)):
		var mountain = Sprite2D.new()
		mountain.texture = load("res://assets/map/mountain.png")
		mountain.position = Vector2(
			rng.randi_range(MountainMinX, MountainMaxX),
			rng.randi_range(MountainBottomMinY, MountainBottomMaxY)
		)
		var scale = randf_range(MountainMinSize, MountainMaxSize)
		mountain.scale = Vector2(scale, scale)
		add_child(mountain)

func _draw():
	for spot in find_children("Location*", "Node2D", true, false):
		if spot.parent != null:
			draw_line(spot.parent.global_position, spot.global_position, Color.BLACK, 2.0)

func _on_location_event(type):
	change_scene.emit(type)
