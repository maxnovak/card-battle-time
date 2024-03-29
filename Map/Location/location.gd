extends Control
class_name Location

signal location_event(type: LocationClass.Types)

@export
var type: LocationClass.Types

@export
var parent: Array[Location]

@export
var child: Array[Location]

var active: bool
var available: bool

func _ready():
	var path = LocationClass.TypeTextureMap[type]
	var locationSprite = load(path)
	$Icon.texture = locationSprite
	$Marker.play("idle")

func _on_mouse_entered():
	if !available:
		return
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2,2), 0.1)
	$Tooltip.text = LocationClass.TooltipMap.get(type, "")

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), 0.1)
	$Tooltip.text = ""

func _on_gui_input(event):
	if !available:
		return

	if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
		set_default_cursor_shape(Control.CURSOR_ARROW)
		$Icon.set_default_cursor_shape(Control.CURSOR_ARROW)
		location_event.emit(type)
		type = LocationClass.VisitedLocationMap[type]
		var path = LocationClass.TypeTextureMap[type]
		var locationSprite = load(path)
		$Icon.texture = locationSprite
		self.scale = Vector2(1.0, 1.0)
		$Tooltip.text = ""
		disconnect("mouse_entered", _on_mouse_entered)
		disconnect("gui_input", _on_gui_input)

func _process(_delta):
	if !available:
		$Icon.modulate = Color.html("#969696")
	else:
		$Icon.modulate = Color.html("#ffffff")
	if active:
		$Marker.visible = true
	else:
		$Marker.visible = false
