extends Control

const cardScene = preload("res://Card/Card.tscn")

signal event_end

@export var cards:Array[Card]

func _ready():
	## This is here just for debugging and should die someday probs?
	if Global.playerDeck.size() != 0:
		cards = Global.playerDeck

	for card in cards:
		var instance = cardScene.instantiate()
		instance.card = card
		instance.card_clicked.connect(_on_card_clicked.bind(card))
		$ScrollContainer/MarginContainer/GridContainer.add_child(instance)

func _on_card_clicked(mouseButton, card: Card):
	if mouseButton == MOUSE_BUTTON_LEFT:
		card.actions.effectAmount += 1
		event_end.emit()
