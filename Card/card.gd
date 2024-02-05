extends Control

signal card_clicked(MouseButton)
signal show_range(range: Array[int])

@export
var card: Card

func _ready():
	$Sprite/NameContainer/CardName.text = str(card.cardName)
	for action in card.actions:
		if action.effect == Global.EffectTypes.MOVE_FORWARD:
			if action.amount >= 1:
				$Sprite/Forward1.visible = true
			if action.amount >= 2:
				$Sprite/Forward2.visible = true
		if action.effect == Global.EffectTypes.MOVE_BACKWARD:
			if action.amount >= 1:
				$Sprite/Backward1.visible = true
			if action.amount >= 2:
				$Sprite/Backward2.visible = true
		if action.effect == Global.EffectTypes.DAMAGE || action.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
			$Sprite/DamageContainer/DamageAmount.text = str(action.amount)

func _process(_delta):
	for action in card.actions:
		if action.effect == Global.EffectTypes.DAMAGE || action.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
			$Sprite/DamageContainer/DamageAmount.text = str(action.amount)
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


func _on_mouse_entered():
	for action in card.actions:
		if action.effect == Global.EffectTypes.DAMAGE || Global.EffectTypes.DAMAGE_OVER_TIME:
			show_range.emit(action.abilityRange)
