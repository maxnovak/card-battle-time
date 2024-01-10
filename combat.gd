extends Node2D

var cardScene = preload("res://Card.tscn")

signal CurrentAction(actor: Global.Actor)

var deckCards = []
var discard = []
var handCards = []

var whosAction = Global.Actor.PLAYER

func _ready():
	for huntressCard in Global.HuntressDeck:
		var card = cardScene.instantiate()
		card.effect = huntressCard.effect
		card.damage = huntressCard.damage
		card.cardName = huntressCard.cardName
		card.card_clicked.connect(_on_card_clicked.bind(card))
		deckCards.append(card)
	deckCards.shuffle()
	dealCards()

func _on_card_clicked(card):
	if whosAction == Global.Actor.PLAYER:
		$AttackTimer.start()
		$Hand.remove_child(card)
		$Hero.changeState("attack")
		applyEnemyDamage(card.damage)
		discard.append(card)
		whosAction = Global.Actor.ENEMY

func applyEnemyDamage(damageAmount):
	$Enemy.health -= damageAmount
	if $Enemy.health <= 0:
		$Enemy.changeState("hit")
		$Enemy.changeState("death")
	else:
		$Enemy.changeState("hit")

func dealCards():
	if deckCards.size() >= 3:
		for i in range(3):
			var card = deckCards.pop_front()
			card.position = Vector2(80*i, 0)
			$Hand.add_child(card, true)
		return

	discard.shuffle()
	deckCards.append_array(discard)
	discard.clear()

	for i in range(3):
		var card = deckCards.pop_front()
		card.position = Vector2(80*i, 0)
		$Hand.add_child(card, true)

func _on_enemy_attack():
	$AttackTimer.start()
	$Enemy.changeState("attack")
	$Hero.changeState("hit")
	whosAction = Global.Actor.PLAYER
	if $Hand.get_child_count() == 0:
		dealCards()

func _on_attack_timer_timeout():
	CurrentAction.emit(whosAction)
