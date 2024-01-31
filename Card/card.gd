extends Control

signal card_clicked(MouseButton)

@export
var card: Card

func _ready():
	if card.direction != Global.Direction.UNDEFINED:
		$Sprite/Direction.visible = true
		if card.direction == Global.Direction.BACKWARDS:
			$Sprite/Direction.position.x = 40
			$Sprite/Direction.flip_h = false

func _process(_delta):
	$Sprite/DamageContainer/DamageAmount.text = str(card.amount)
	$Sprite/NameContainer/CardName.text = str(card.cardName)

func _on_gui_input(event):
	if event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			card_clicked.emit(event.button_index)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if card.flippedCard != null:
				var newFlip = Card.new()
				newFlip.effect = card.flippedCard.effect
				newFlip.amount = card.flippedCard.amount
				newFlip.cardName = card.flippedCard.cardName
				newFlip.direction = card.flippedCard.direction
				newFlip.flippedCard = card
				if newFlip.direction == Global.Direction.FORWARD:
					$Sprite/Direction.visible = true
					$Sprite/Direction.position.x = 60
					$Sprite/Direction.flip_h = false
				if newFlip.direction == Global.Direction.BACKWARDS:
					$Sprite/Direction.visible = true
					$Sprite/Direction.position.x = 20
					$Sprite/Direction.flip_h = true
				if newFlip.direction == Global.Direction.UNDEFINED:
					$Sprite/Direction.visible = false
				card = newFlip
