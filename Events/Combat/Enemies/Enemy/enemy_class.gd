class_name EnemyClass

var name: String
var resourceName: String
var health: int
var block: int

func _init(enemy: Dictionary):
	name = enemy.name
	resourceName = enemy.resourceName
	health = enemy.health
	block = enemy.block
