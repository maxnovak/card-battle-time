extends Node2D

var cardScene = preload("res://Card/Card.tscn")

signal DisplayError(message: String)

@export
var handSize = 5

const cardWidthMove = 80

var deckCards: Array[Card] = []
var discard: Array[Card] = []

# Called when the node enters the scene tree for the first time.
func _notification(what):
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		for card in get_children():
			card.position = Vector2(cardWidthMove*(card.get_index()-get_child_count()/2.0), 0)

func _on_card_clicked(mouseButton, card):
	DisplayError.emit("")
	if get_parent().currentPhase != Global.Phases.PLAY_CARD:
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
		DisplayError.emit(reason)
		return

	remove_child(card)
	discard.append(card)
	get_parent().playedCard = card
	get_parent().currentPhase = Global.TurnOrder[Global.TurnOrder.find(get_parent().currentPhase) + 1]

func constructDeck(deck: Array[CardClass]):
	for heroCard in deck:
		var card = cardScene.instantiate()
		card.effect = heroCard.effect
		card.amount = heroCard.amount
		card.abilityRange = heroCard.abilityRange
		card.cardName = heroCard.cardName
		card.direction = heroCard.direction
		card.flippedCard = heroCard.flippedCard
		card.card_clicked.connect(_on_card_clicked.bind(card))
		deckCards.append(card)
	deckCards.shuffle()
	dealCards(handSize)

func is_unplayable(card):
	if card.effect == Global.EffectTypes.MOVEMENT \
		&& card.direction == Global.Direction.FORWARD \
		&& get_parent().hero_position == 2:
		return "Cannot move forward anymore"
	if card.effect == Global.EffectTypes.MOVEMENT \
		&& card.direction == Global.Direction.BACKWARDS \
		&& get_parent().hero_position == 0:
		return "Cannot move back anymore"
	return null

func dealCards(numberOfCards: int):
	if deckCards.size() < numberOfCards:
		discard.shuffle()
		deckCards.append_array(discard)
		discard.clear()

	for i in range(numberOfCards):
		var card = deckCards.pop_front()
		card.position = Vector2(80*i, 0)
		add_child(card, true)

func draw():
	if deckCards.size() == 0:
		shuffleDeck()
	var card = deckCards.pop_front()
	card.position = Vector2(80*get_child_count(), 0)
	add_child(card, true)

func shuffleDeck():
	discard.shuffle()
	deckCards.append_array(discard)
	discard.clear()

func _on_button_pressed():
	if !get_parent().currentPhase == Global.Phases.PLAY_CARD:
		return

	var cards = get_children()
	for card in cards:
		remove_child(card)
		discard.append(card)
	dealCards(handSize-1)
