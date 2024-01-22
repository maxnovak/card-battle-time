extends Node2D

const combatScene = preload("res://Combat/Combat.tscn")
const aquireCardScene = preload("res://Events/AquireCard.tscn")

@onready
var mapHolder = $Map

func _on_map_change_scene(type):
	if type == LocationClass.Types.BATTLE:
		remove_child(mapHolder)
		var combat = combatScene.instantiate()
		combat.combat_end.connect(_event_ended.bind(combat))
		add_child(combat)
	if type == LocationClass.Types.CARD:
		remove_child(mapHolder)
		var aquireCard = aquireCardScene.instantiate()
		aquireCard.event_end.connect(_event_ended.bind(aquireCard))
		add_child(aquireCard)

func _event_ended(event):
	remove_child(event)
	event.queue_free()
	add_child(mapHolder)
