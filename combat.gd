extends Node2D

var cardScene = preload("res://Card.tscn")

signal PhaseChange(phase: Global.Phases)

@export
var hero_position = 1 #0-2 for allowed locations

const hero_positions = [
	{
		x = 150,
	},
	{
		x = 300,
	},
	{
		x = 450,
	},
]

@export
var enemy_position = 1 #0-2 for allowed locations

const enemy_positions = [
	{
		x = 600,
	},
	{
		x = 750,
	},
	{
		x = 900,
	},
]

var deckCards: Array[Card] = []
var discard: Array[Card] = []
var playedCard: Card
var currentPhase: Global.Phases: set = set_phase

func _ready():
	for huntressCard in Global.HuntressDeck:
		var card = cardScene.instantiate()
		card.effect = huntressCard.effect
		card.amount = huntressCard.amount
		card.abilityRange = huntressCard.abilityRange
		card.cardName = huntressCard.cardName
		card.direction = huntressCard.direction
		card.flippedCard = huntressCard.flippedCard
		card.card_clicked.connect($Hand._on_card_clicked.bind(card))
		deckCards.append(card)
	deckCards.shuffle()
	dealCards()

	$Enemy.init(EnemyClass.new({
		name = "Evil Wizard",
		sprite = "",
		deck = EnemyDecks.new().EvilWizardDeck,
		health = 50,
		block = 0,
	}))

	currentPhase = Global.TurnOrder[0] as Global.Phases

func _process(_delta):
	$Hero.position = Vector2(hero_positions[hero_position].x, $Hero.position.y)
	$Enemy.position = Vector2(enemy_positions[enemy_position].x, $Enemy.position.y)

func set_phase(value):
	if currentPhase != value:
		currentPhase = value
		PhaseChange.emit(value)

func applyCardEffect(card):
	if card.effect == Global.EffectTypes.DAMAGE:
		$Hero.changeState("attack")
		if !enemy_position in card.abilityRange:
			return
		dealDamage($Enemy, card.amount)
		if $Enemy.health <= 0:
			## Fix these state changes later
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

func shuffleDeck():
	discard.shuffle()
	deckCards.append_array(discard)
	discard.clear()

func enemyAttack():
	$Enemy.changeState("attack")
	if !hero_position in $Enemy.chosenAction.abilityRange:
		return
	$Hero.changeState("hit")
	dealDamage($Hero, $Enemy.chosenAction.amount)

func dealDamage(target, amount):
	if target.block >= amount:
		target.block -= amount
	elif target.block > 0:
		amount -= target.block
		target.block = 0
		target.health -= amount
	else:
		target.health -= amount

func _on_phase_change(phase):
	if $Enemy.health == 0:
		currentPhase = Global.Phases.COMBAT_END
	if !$AttackTimer.is_stopped():
		await $AttackTimer.timeout

	if phase == Global.Phases.DRAW:
		if deckCards.size() == 0:
			shuffleDeck()
		var card = deckCards.pop_front()
		card.position = Vector2(80*$Hand.get_child_count(), 0)
		$Hand.add_child(card, true)
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.PLAY_CARD:
		$GUI/Button.disabled = false
		pass

	if phase == Global.Phases.PLAYER_COMBAT:
		$AttackTimer.start()
		applyCardEffect(playedCard)
		playedCard = null
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.PLAYER_CLEANUP:
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.ENEMY_ACTION:
		$AttackTimer.start()
		$Enemy.playCard()
		enemyAttack()
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]

	if phase == Global.Phases.ENEMY_CHOOSES_NEXT_ACTION:
		$Enemy.chooseAction()
		$"GUI/Battle Grid".clearTargets()
		for target in $Enemy.chosenAction.abilityRange:
			$"GUI/Battle Grid".targetSpace(target)
		currentPhase = Global.TurnOrder[Global.TurnOrder.find(currentPhase) + 1]
		pass

	if phase == Global.Phases.ENEMY_CLEANUP:
		if $Enemy.damage_over_time > 0:
			$Enemy.changeState("hit")
			$Enemy.health -= $Enemy.damage_over_time
			$Enemy.damage_over_time -= 1
		currentPhase = Global.TurnOrder[0] as Global.Phases
