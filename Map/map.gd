extends Node2D
class_name Map

const location = preload("res://Map/Location/Location.tscn")

signal change_scene(type: LocationClass.Types)

const LocationTypes = [
	LocationClass.Types.BATTLE,
	LocationClass.Types.CARD,
]
var rng = RandomNumberGenerator.new()

const NumberOfLocations = 4
const LocationStepDistance = 150
const LocationTopMinHeight = 300
const LocationTopMaxHeight = 370
const LocationBottomMinHeight = 200
const LocationBottomMaxHeight = 270
const MountainMinSize = 0.5
const MountainMaxSize = 1.0
const MountainMinX = 25
const MountainMaxX = 990
const MountainTopMinY = 45
const MountainTopMaxY = 150
const MountainBottomMinY = 420
const MountainBottomMaxY = 575

func _ready():
	populateLandscape()
	createLocations()

func createLocations():
	var firstLocation = location.instantiate()
	firstLocation.type = LocationTypes[rng.randi_range(0, LocationTypes.size()-1)]
	firstLocation.position = Vector2(LocationStepDistance,290)
	firstLocation.location_event.connect(_on_location_event.bind(firstLocation))
	firstLocation.available = true
	$Locations.add_child(firstLocation, true)

	#Final Location
	var boss = location.instantiate()
	boss.type = LocationClass.Types.BOSS
	boss.position = Vector2(NumberOfLocations*LocationStepDistance+LocationStepDistance*2, 300)
	boss.location_event.connect(_on_location_event.bind(boss))
	boss.scale = Vector2(1.5, 1.5)
	$Locations.add_child(boss, true)
	
	#top row
	var previousLocation = firstLocation
	for i in range(NumberOfLocations):
		var spot = location.instantiate()
		spot.type = LocationTypes[rng.randi_range(0, LocationTypes.size()-1)]
		spot.parent.append(previousLocation)
		spot.position = Vector2(
			i*LocationStepDistance+LocationStepDistance*2,
			rng.randi_range(LocationTopMinHeight, LocationTopMaxHeight)
		)
		spot.location_event.connect(_on_location_event.bind(spot))
		$Locations.add_child(spot, true)
		previousLocation.child.append(spot)
		previousLocation = spot
		if i == NumberOfLocations - 1:
			boss.parent.append(previousLocation)
			previousLocation.child.append(boss)
#
	#bottom row
	previousLocation = firstLocation
	for i in range(NumberOfLocations):
		var spot = location.instantiate()
		spot.type = LocationTypes[rng.randi_range(0, LocationTypes.size()-1)]
		spot.parent.append(previousLocation)
		spot.position = Vector2(
			i*LocationStepDistance+LocationStepDistance*2,
			rng.randi_range(LocationBottomMinHeight, LocationBottomMaxHeight)
		)
		spot.location_event.connect(_on_location_event.bind(spot))
		$Locations.add_child(spot, true)
		previousLocation.child.append(spot)
		previousLocation = spot
		if i == NumberOfLocations - 1:
			boss.parent.append(previousLocation)
			previousLocation.child.append(boss)



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
	if $DelayStart.is_stopped() && $CloudTimer.is_stopped() && $Clouds.get_child_count() < 3:
		$CloudTimer.start()
		add_cloud()

func _draw():
	for spot in $Locations.get_children():
		for node in spot.parent:
			draw_line(node.global_position, spot.global_position, Color.BLACK, 2.0)

func _on_location_event(type, source):
	source.active = true
	change_scene.emit(type)
	for spot in source.parent:
		spot.active = false
	for spot in source.child:
		spot.available = true

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
