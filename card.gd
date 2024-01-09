extends Node2D

signal card_clicked

enum EffectTypes { DAMAGE }

@export
var effect: EffectTypes

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
	$RichTextLabel.text = str(damage)
