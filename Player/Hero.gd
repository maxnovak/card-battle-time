extends Node2D

@export
var health: int

@export
var emotionalHealth: float

@export
var block: int

func _ready():
	$AnimatedSprite2D.play("idle")

func attack():
	$AnimatedSprite2D.play("attack")

func die():
	$AnimatedSprite2D.play("death")

func hit():
	$AnimatedSprite2D.play("take hit")

func idle():
	$AnimatedSprite2D.play("idle")
