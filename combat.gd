extends Node2D

var cardScene = preload("res://Card.tscn")

var deckCards = []
var handCards = []

enum Actor {
	Enemy,
	Player,
}
#
#var whosAction = Actor.Player

func _ready():
	for i in range(20):
		var card = cardScene.instantiate()
		card.effect = card.EffectTypes.DAMAGE
		card.damage = i
		card.card_clicked.connect(_on_card_clicked.bind(card))
		deckCards.append(card)
	deckCards.shuffle()
	for i in range(5):
		var card = deckCards.pop_front()
		card.position = Vector2(80*i, 0)
		$Hand.add_child(card, true)

func _on_card_clicked(card):
	#if whosAction == Actor.Player:
		applyDamage(card.damage)
		card.queue_free()
		#whosAction = Actor.Enemy

func applyDamage(damageAmount):
	$EvilWizard.health -= damageAmount
	if $EvilWizard.health <= 0:
		$EvilWizard.changeState("death")
	else:
		$EvilWizard.changeState("hit")
