extends Node2D
class_name Card

signal card_clicked(MouseButton)

@export
var effect: Global.EffectTypes

@export
var amount: int

@export
var direction: Global.Direction

@export
var cardName: String

@export
var abilityRange: Array
var flippedCard: CardClass

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_pressed():
		card_clicked.emit(event.button_index)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			$DamageContainer/DamageAmount.text = str(amount)
			$NameContainer/CardName.text = cardName
			if direction != Global.Direction.UNDEFINED:
				$Direction.position.x = -$Direction.position.x
				$Direction.rotate(deg_to_rad(180))

func _on_area_2d_mouse_entered():
	position.y = position.y - 30
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_area_2d_mouse_exited():
	position.y = position.y + 30
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _ready():
	$DamageContainer/DamageAmount.text = str(amount)
	$NameContainer/CardName.text = cardName
	if direction != Global.Direction.UNDEFINED:
		$Direction.visible = true
		if direction == Global.Direction.BACKWARDS:
			$Direction.position.x = -$Direction.position.x
			$Direction.rotate(deg_to_rad(180))
