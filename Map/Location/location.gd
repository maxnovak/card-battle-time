extends Node2D
class_name Location

signal location_event(type: LocationClass.Types)

@export
var type: LocationClass.Types

@export
var parent: Location

func _ready():
	var path = LocationClass.TypeTextureMap[type]
	var locationSprite = load(path)
	$Icon.texture = locationSprite

func _on_area_2d_mouse_entered():
	$Icon.scale = Vector2(2.0, 2.0)
	$Area2D/CollisionShape2D.scale = Vector2(2.0, 2.0)
	$Tooltip.text = LocationClass.TooltipMap.get(type, "")

func _on_area_2d_mouse_exited():
	$Icon.scale = Vector2(1.0, 1.0)
	$Area2D/CollisionShape2D.scale = Vector2(1.0, 1.0)
	$Tooltip.text = ""

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		location_event.emit(type)
		type = LocationClass.VisitedLocationMap[type]
		var path = LocationClass.TypeTextureMap[type]
		var locationSprite = load(path)
		$Icon.texture = locationSprite
		$Icon.scale = Vector2(1.0, 1.0)
		$Area2D/CollisionShape2D.scale = Vector2(1.0, 1.0)
		$Tooltip.text = ""
		$Area2D.disconnect("mouse_entered", _on_area_2d_mouse_entered)
		$Area2D.disconnect("input_event", _on_area_2d_input_event)
