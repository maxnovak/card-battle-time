extends Node2D

signal card_clicked

@export
var effect: Global.EffectTypes

@export
var damage: int

@export
var cardName: String

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	if event.is_pressed():
		card_clicked.emit()

func _on_area_2d_mouse_entered():
	position.y = position.y - 30

func _on_area_2d_mouse_exited():
	position.y = position.y + 30

func _ready():
	$DamageContainer/DamageAmount.text = str(damage)
	$NameContainer/CardName.text = cardName
