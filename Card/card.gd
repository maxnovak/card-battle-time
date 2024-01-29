extends Control
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

func _ready():
	if direction != Global.Direction.UNDEFINED:
		$Sprite/Direction.visible = true
		if direction == Global.Direction.BACKWARDS:
			$Sprite/Direction.position.x = 40
			$Sprite/Direction.flip_h = false

func _process(_delta):
	$Sprite/DamageContainer/DamageAmount.text = str(amount)
	$Sprite/NameContainer/CardName.text = str(cardName)

func _on_gui_input(event):
	if event.is_pressed():
		card_clicked.emit(event.button_index)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if direction == Global.Direction.FORWARD:
				$Sprite/Direction.position.x = 20
				$Sprite/Direction.flip_h = true
			if direction == Global.Direction.BACKWARDS:
				$Sprite/Direction.position.x = 60
				$Sprite/Direction.flip_h = false
