extends Control

const cardScene = preload("res://Card/Card.tscn")

signal event_end

@export var cards:Array[Card]

# Called when the node enters the scene tree for the first time.
func _ready():
	for card in cards:
		var instance = cardScene.instantiate()
		instance.card = card
		instance.card_clicked.connect(_on_card_clicked.bind(card))
		$GridContainer.add_child(instance)

func _on_card_clicked(mouseButton, card):
	if mouseButton == MOUSE_BUTTON_LEFT:
		Global.playerDeck.append(card)
		event_end.emit()
