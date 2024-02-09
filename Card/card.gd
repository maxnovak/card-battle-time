extends Control

signal card_clicked(MouseButton)
signal show_range(range: Array[int])

@export
var card: Card

func _ready():
	$Sprite/NameContainer/CardName.text = str(card.cardName)

func _process(_delta):
	if card.actions == null:
		return
	$Sprite/NameContainer/CardName.text = str(card.cardName)
	if card.actions.effect == Global.EffectTypes.UNDEFINED:
		$Sprite/DamageContainer/DamageAmount.text = ""
	else:
		if card.actions.effect == Global.EffectTypes.DAMAGE:
			$Sprite/DamageContainer/DamageAmount.text = "[color=red]" + str(card.actions.effectAmount) + " Damage [/color]"
		if card.actions.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
			$Sprite/DamageContainer/DamageAmount.text = "[center][color=green]Apply " + str(card.actions.effectAmount) + " Poison[/color][/center]"
	if card.actions.movement == Global.MovementTypes.UNDEFINED:
		$Sprite/MoveContainer/MovementType.text = ""
	else:
		if card.actions.movement == Global.MovementTypes.MOVE_FORWARD:
			$Sprite/MoveContainer/MovementType.text = "Move"
			if card.actions.movementAmount >= 1:
				$Sprite/Forward1.visible = true
			if card.actions.movementAmount >= 2:
				$Sprite/Forward2.visible = true
		if card.actions.movement == Global.MovementTypes.MOVE_BACKWARD:
			$Sprite/MoveContainer/MovementType.text = "Move"
			if card.actions.movementAmount >= 1:
				$Sprite/Backward1.visible = true
			if card.actions.movementAmount >= 2:
				$Sprite/Backward2.visible = true
		if card.actions.movement == Global.MovementTypes.PULL_ENEMY:
			$Sprite/MoveContainer/MovementType.text = "Pull"
			if card.actions.movementAmount >= 1:
				$Sprite/Backward1.visible = true
			if card.actions.movementAmount >= 2:
				$Sprite/Backward2.visible = true
		if card.actions.movement == Global.MovementTypes.PUSH_ENEMY:
			$Sprite/MoveContainer/MovementType.text = "Push"
			if card.actions.movementAmount >= 1:
				$Sprite/Forward1.visible = true
			if card.actions.movementAmount >= 2:
				$Sprite/Forward2.visible = true
	if card.actions.effectRange.size() == 0:
		$Sprite/RangeContainer/RangeText.text = ""
	else:
		$Sprite/RangeContainer/RangeText.text = "Range: "
		$Sprite/RangeContainer/RangeText.text += ",".join(card.actions.effectRange)

func _on_gui_input(event):
	if event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			card_clicked.emit(event.button_index)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			##Needs a rework
			if card.flippedCard != null:
				var newFlip = Card.new()
				newFlip.effect = card.flippedCard.effect
				newFlip.amount = card.flippedCard.effectAmount
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
	if card.actions.effect == Global.EffectTypes.DAMAGE || card.actions.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
		show_range.emit(card.actions.effectRange)
