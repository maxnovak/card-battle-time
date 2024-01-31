extends Control

signal event_end

# Called when the node enters the scene tree for the first time.
func _ready():
	$GridContainer/Card.card_clicked.connect(_on_card_clicked.bind($GridContainer/Card))
	$GridContainer/Card2.card_clicked.connect(_on_card_clicked.bind($GridContainer/Card2))
	$GridContainer/Card3.card_clicked.connect(_on_card_clicked.bind($GridContainer/Card3))

func _on_card_clicked(mouseButton, card):
	if mouseButton == MOUSE_BUTTON_LEFT:
		Global.HuntressDeck.append(CardClass.new({
			cardName = card.cardName,
			amount = card.amount,
			effect = card.effect,
			direction = card.direction,
			abilityRange = card.abilityRange
		}))
		event_end.emit()
