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

var activeLocation = 0

func _ready():
	populateLandscape()
	createLocations()

func createLocations():
	var previousLocation: Location
	for i in range(NumberOfLocations):
		var spot = location.instantiate()
		spot.type = LocationTypes[rng.randi_range(0, LocationTypes.size()-1)]
		spot.parent = previousLocation
		spot.position = Vector2(
			i*LocationStepDistance+LocationStepDistance,
			rng.randi_range(LocationMinHeight, LocationMaxHeight)
		)
		spot.location_event.connect(_on_location_event)
		$Locations.add_child(spot, true)
		previousLocation = spot
	#Final Location
	var boss = location.instantiate()
	boss.type = LocationClass.Types.BOSS
	boss.parent = previousLocation
	boss.position = Vector2(NumberOfLocations*LocationStepDistance+LocationStepDistance, 300)
	boss.location_event.connect(_on_location_event)
	boss.scale = Vector2(1.5, 1.5)
	$Locations.add_child(boss, true)

func populateLandscape():
	#Top Range
	for i in range(randi_range(1, 3)):
		var mountain = Sprite2D.new()
		mountain.texture = load("res://assets/map/mountain.png")
		mountain.position = Vector2(
			rng.randi_range(MountainMinX, MountainMaxX),
			rng.randi_range(MountainTopMinY, MountainTopMaxY)
		)
		var mountainScale = randf_range(MountainMinSize, MountainMaxSize)
		mountain.scale = Vector2(mountainScale, mountainScale)
		$Mountains.add_child(mountain)

	#Bottom Range
	for i in range(randi_range(1, 3)):
		var mountain = Sprite2D.new()
		mountain.texture = load("res://assets/map/mountain.png")
		mountain.position = Vector2(
			rng.randi_range(MountainMinX, MountainMaxX),
			rng.randi_range(MountainBottomMinY, MountainBottomMaxY)
		)
		var mountainScale = randf_range(MountainMinSize, MountainMaxSize)
		mountain.scale = Vector2(mountainScale, mountainScale)
		$Mountains.add_child(mountain)

func _process(_delta):
	$Locations.get_children()[activeLocation].active = true
	if $DelayStart.is_stopped() && $CloudTimer.is_stopped() && $Clouds.get_child_count() < 3:
		$CloudTimer.start()
		add_cloud()

func _draw():
	for spot in $Locations.get_children():
		if spot.parent != null:
			draw_line(spot.parent.global_position, spot.global_position, Color.BLACK, 2.0)

func _on_location_event(type):
	change_scene.emit(type)
	activeLocation += 1

func add_cloud():
	var tween = create_tween()
	var cloud = Sprite2D.new()
	cloud.texture = load("res://assets/map/cloud.png")
	var y = rng.randi_range(MountainTopMinY, MountainTopMaxY)
	var size = rng.randf_range(0.75, 1.0)
	cloud.position = Vector2(1088, y)
	cloud.scale = Vector2(size, size)
	$Clouds.add_child(cloud)
	tween.tween_property(cloud, "global_position", Vector2(-100, y), 35.0)
	tween.set_loops()
