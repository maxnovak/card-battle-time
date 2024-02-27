extends Control

const cardScene = preload("res://Card/Card.tscn")

signal event_end

@export var cards:Array[Card]

func _ready():
	## This is here just for debugging and should die someday probs?
	if Global.playerDeck.size() != 0:
		print(Global.playerDeck.size())
		cards = Global.playerDeck

	for card in cards:
		var instance = cardScene.instantiate()
		instance.card = card
		$ScrollContainer/MarginContainer/GridContainer.add_child(instance)
