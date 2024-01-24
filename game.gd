extends Node2D

const combatScene = preload("res://Events/Combat/Combat.tscn")
const aquireCardScene = preload("res://Events/AquireCard/AquireCard.tscn")

@onready
var mapHolder = $Scenes/Map

func _on_map_change_scene(type):
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$Sprite2D.texture = texture
	$Scenes.remove_child(mapHolder)
	if type == LocationClass.Types.BATTLE:
		var combat = combatScene.instantiate()
		combat.combat_end.connect(_event_ended.bind(combat))
		$Scenes.add_child(combat)
	if type == LocationClass.Types.CARD:
		var aquireCard = aquireCardScene.instantiate()
		aquireCard.event_end.connect(_event_ended.bind(aquireCard))
		$Scenes.add_child(aquireCard)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished

func _event_ended(event):
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$Sprite2D.texture = texture
	$Scenes.remove_child(event)
	$Scenes.add_child(mapHolder)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished
	event.queue_free()
