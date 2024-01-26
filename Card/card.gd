extends Node2D
class_name Card

signal card_clicked(MouseButton)

@export
var effect: Global.EffectTypes

@export
var amount: int: set = setAmount

@export
var direction: Global.Direction

@export
var cardName: String: set = setName

@export
var abilityRange: Array
var flippedCard: CardClass

func setAmount(value):
	amount = value
	$DamageContainer/DamageAmount.text = str(amount)

func setName(value):
	cardName = value
	$NameContainer/CardName.text = cardName

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_pressed():
		card_clicked.emit(event.button_index)
		if event.button_index == MOUSE_BUTTON_RIGHT:
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
	if direction != Global.Direction.UNDEFINED:
		$Direction.visible = true
		if direction == Global.Direction.BACKWARDS:
			$Direction.position.x = -$Direction.position.x
			$Direction.rotate(deg_to_rad(180))
