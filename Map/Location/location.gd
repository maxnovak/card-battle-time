extends Node2D
class_name Location

signal location_event(type: LocationClass.Types)

@export
var type: LocationClass.Types

@export
var parent: Location

var active: bool

func _ready():
	var path = LocationClass.TypeTextureMap[type]
	var locationSprite = load(path)
	$Icon.texture = locationSprite

func _on_area_2d_mouse_entered():
	if active:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

	$Icon.scale = Vector2(2.0, 2.0)
	$Marker.scale = Vector2(2.0, 2.0)
	$Marker.position.y = -26
	$Area2D/CollisionShape2D.scale = Vector2(2.0, 2.0)
	$Tooltip.text = LocationClass.TooltipMap.get(type, "")

func _on_area_2d_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	$Icon.scale = Vector2(1.0, 1.0)
	$Marker.scale = Vector2(1.0, 1.0)
	$Marker.position.y = -14
	$Area2D/CollisionShape2D.scale = Vector2(1.0, 1.0)
	$Tooltip.text = ""

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if !active:
		return

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

func _process(_delta):
	if !active:
		$Icon.modulate = Color.html("#969696")
	else:
		$Icon.modulate = Color.html("#ffffff")
		$Marker.visible = true
