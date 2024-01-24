class_name EnemyCardClass

var cardName: String
var amount: int
var effect: Global.EffectTypes
var direction: Global.Direction
var abilityRange: Array

func _init(card: Dictionary):
	cardName = card.cardName
	amount = card.amount
	effect = card.effect
	direction = card.get("direction", Global.Direction.UNDEFINED)
	abilityRange = card.get("abilityRange", [])
