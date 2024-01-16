extends Node2D

var cardScene = preload("res://Card.tscn")

signal CurrentAction(actor: Global.Actor)

@export
var hero_position = 1 #0-2 for allowed locations

const hero_positions = [
	{
		x = 150,
		y = 415,
	},
	{
		x = 300,
		y = 415,
	},
	{
		x = 450,
		y = 415,
	},
]

@export
var enemy_position = 1 #0-2 for allowed locations

const enemy_positions = [
	{
		x = 600,
		y = 415,
	},
	{
		x = 750,
		y = 415,
	},
	{
		x = 900,
		y = 415,
	},
]

var deckCards = []
var discard = []
var handCards = []

var whosAction = Global.Actor.PLAYER

func _ready():
	for huntressCard in Global.HuntressDeck:
		var card = cardScene.instantiate()
		card.effect = huntressCard.effect
		card.amount = huntressCard.amount
		card.cardName = huntressCard.cardName
		card.direction = huntressCard.direction
		card.flippedCard = huntressCard.flippedCard
		card.card_clicked.connect(_on_card_clicked.bind(card))
		deckCards.append(card)
	deckCards.shuffle()
	dealCards()

	$Hero.position = Vector2(hero_positions[hero_position].x, hero_positions[hero_position].y)
	$Enemy.position = Vector2(enemy_positions[enemy_position].x, enemy_positions[enemy_position].y)

func _process(_delta):
	$Hero.position = Vector2(hero_positions[hero_position].x, hero_positions[hero_position].y)
	$Enemy.position = Vector2(enemy_positions[enemy_position].x, enemy_positions[enemy_position].y)

func _on_card_clicked(mouseButton, card):
	$GUI/Error.text = ""
	if whosAction != Global.Actor.PLAYER:
		return

	if card.flippedCard == null && mouseButton == MOUSE_BUTTON_RIGHT:
		return

	if card.flippedCard != null && mouseButton == MOUSE_BUTTON_RIGHT:
		var newFlip = CardClass.new({
			cardName = card.flippedCard.cardName,
			amount = card.flippedCard.amount,
			effect = card.flippedCard.effect,
			direction = card.flippedCard.direction,
			flippedCard = CardClass.new({
				cardName = card.cardName,
				amount = card.amount,
				effect = card.effect,
				direction = card.direction,
			}),
		})
		card.effect = newFlip.effect
		card.amount = newFlip.amount
		card.cardName = newFlip.cardName
		card.direction = newFlip.direction
		card.flippedCard = newFlip.flippedCard
		return

	var reason = is_unplayable(card)
	if reason != null:
		$GUI/Error.text = reason
		return

	$AttackTimer.start()
	$Hand.remove_child(card)
	applyCardEffect(card)
	discard.append(card)
	whosAction = Global.Actor.ENEMY

func is_unplayable(card):
	if card.effect == Global.EffectTypes.MOVEMENT \
		&& card.direction == Global.Direction.FORWARD \
		&& hero_position == 2:
		return "Cannot move forward anymore"
	if card.effect == Global.EffectTypes.MOVEMENT \
		&& card.direction == Global.Direction.BACKWARDS \
		&& hero_position == 0:
		return "Cannot move back anymore"
	return null

func applyCardEffect(card):
	if card.effect == Global.EffectTypes.DAMAGE:
		$Hero.changeState("attack")
		dealDamage($Enemy, card.amount)
		if $Enemy.health <= 0:
			$Enemy.changeState("hit")
			$Enemy.changeState("death")
		else:
			$Enemy.changeState("hit")
	if card.effect == Global.EffectTypes.BLOCK:
		$Hero.block += card.amount
	if card.effect == Global.EffectTypes.DAMAGE_OVER_TIME:
		$Hero.changeState("poison")
		$Enemy.damage_over_time = card.amount
	if card.effect == Global.EffectTypes.MOVEMENT:
		if card.direction == Global.Direction.FORWARD:
			hero_position += 1
		if card.direction == Global.Direction.BACKWARDS:
			hero_position -= 1

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
