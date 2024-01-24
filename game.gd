extends Node2D

const combatScene = preload("res://Events/Combat/Combat.tscn")
const aquireCardScene = preload("res://Events/AquireCard/AquireCard.tscn")

@onready
var mapHolder = $Map

func _on_map_change_scene(type):
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	if type == LocationClass.Types.BATTLE:
		var combat = combatScene.instantiate()
		combat.combat_end.connect(_event_ended.bind(combat))
		add_child(combat)
		remove_child(mapHolder)
	if type == LocationClass.Types.CARD:
		var aquireCard = aquireCardScene.instantiate()
		aquireCard.event_end.connect(_event_ended.bind(aquireCard))
		add_child(aquireCard)
		remove_child(mapHolder)
	$AnimationPlayer.play("fade_in")

func _event_ended(event):
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	add_child(mapHolder)
	remove_child(event)
	event.queue_free()
	$AnimationPlayer.play("fade_in")
