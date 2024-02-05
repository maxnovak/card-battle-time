class_name EnemyClass

var name: String
var sprite: String
var deck: Array[EnemyCardClass]
var health: int
var block: int

func _init(enemy: Dictionary):
	name = enemy.name
	sprite = enemy.sprite
	health = enemy.health
	block = enemy.block
