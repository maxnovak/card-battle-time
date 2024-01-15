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
		applyCardEffect(card)
		discard.append(card)
		whosAction = Global.Actor.ENEMY

func applyCardEffect(card):
	if card.effect == Global.EffectTypes.DAMAGE:
		$Hero.changeState("attack")
		dealDamage($Enemy, card.damage)
		if $Enemy.health <= 0:
			$Enemy.changeState("hit")
			$Enemy.changeState("death")
		else:
			$Enemy.changeState("hit")
	if card.effect == Global.EffectTypes.BLOCK:
		$Hero.block += card.damage
	if card.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
		$Hero.changeState("poison")
		$Enemy.damage_over_time = card.damage

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
	dealDamage($Hero, $Enemy.damage)
	if $Enemy.damage_over_time > 0:
		$Enemy.changeState("hit")
		$Enemy.health -= $Enemy.damage_over_time
		$Enemy.damage_over_time -= 1
	whosAction = Global.Actor.PLAYER
	if $Hand.get_child_count() == 0:
		dealCards()

func dealDamage(target, amount):
	if target.block >= amount:
		target.block -= amount
	elif target.block > 0:
		amount -= target.block
		target.block = 0
		target.health -= amount
	else:
		target.health -= amount

func _on_attack_timer_timeout():
	CurrentAction.emit(whosAction)
