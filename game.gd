extends Control

const combatScene = preload("res://Events/Combat/Combat.tscn")
const aquireCardScene = preload("res://Events/AquireCard/AquireCard.tscn")

@onready
var mapHolder = $Scenes/Map

@export
var huntressDeck: Array[Card]

func _ready():
	DisplayServer.window_set_min_size(Vector2(1152,648))
	Global.playerDeck += huntressDeck

func _on_map_change_scene(type):
	Input.set_default_cursor_shape(Input.CURSOR_WAIT)
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TransitionImageHolder.texture = texture
	$Scenes.remove_child(mapHolder)
	if type == LocationClass.Types.BATTLE:
		var combat = combatScene.instantiate()
		combat.enemy = "FireWizard"
		combat.combat_end.connect(_event_ended.bind(combat))
		$Scenes.add_child(combat)
	if type == LocationClass.Types.CARD:
		var aquireCard = aquireCardScene.instantiate()
		aquireCard.event_end.connect(_event_ended.bind(aquireCard))
		$Scenes.add_child(aquireCard)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _event_ended(event):
	Input.set_default_cursor_shape(Input.CURSOR_WAIT)
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TransitionImageHolder.texture = texture
	$Scenes.remove_child(event)
	$Scenes.add_child(mapHolder)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished
	event.queue_free()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
