extends Node2D

signal event_end

# Called when the node enters the scene tree for the first time.
func _ready():
	$Card.card_clicked.connect(_on_card_clicked.bind($Card))
	$Card2.card_clicked.connect(_on_card_clicked.bind($Card2))
	$Card3.card_clicked.connect(_on_card_clicked.bind($Card3))

func _on_card_clicked(mouseButton, card):
	Global.HuntressDeck.append(CardClass.new({
		cardName = card.cardName,
		amount = card.amount,
		effect = card.effect,
		direction = card.direction,
	}))
	event_end.emit()
