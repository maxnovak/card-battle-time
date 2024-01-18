class_name CardClass

var cardName: String
var amount: int
var effect: Global.EffectTypes
var direction: Global.Direction
var flippedCard: CardClass
var abilityRange: Array

func _init(card: Dictionary):
	cardName = card.cardName
	amount = card.amount
	effect = card.effect
	direction = card.get("direction", Global.Direction.UNDEFINED)
	flippedCard = card.get("flippedCard")
	abilityRange = card.get("abilityRange", [])
