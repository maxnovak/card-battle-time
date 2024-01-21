extends Node2D

@export
var type: LocationClass.LocationTypes

@export
var parent: Node2D

func _ready():
	var path = LocationClass.LocationTypeMap[type]
	var locationSprite = load(path)
	$Icon.texture = locationSprite

func _on_area_2d_mouse_entered():
	$Icon.scale = Vector2(2.0, 2.0)
	$Area2D/CollisionShape2D.scale = Vector2(2.0, 2.0)

func _on_area_2d_mouse_exited():
	$Icon.scale = Vector2(1.0, 1.0)
	$Area2D/CollisionShape2D.scale = Vector2(1.0, 1.0)
