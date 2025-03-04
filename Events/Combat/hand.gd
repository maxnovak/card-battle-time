extends Control

var cardScene = preload("res://Card/Card.tscn")

signal DisplayError(message: String)
signal show_range(range: Array[int])

@export
var handSize = 5

const cardWidthMove = 150

var deckCards: Array[Card] = []
var discard: Array[Card] = []

func _on_card_clicked(_mouseButton, card):
	DisplayError.emit("")
	var cardResource = card.card
	if get_parent().get_parent().currentPhase != Global.Phases.PLAY_CARD:
		return

	remove_child(card)
	discard.append(cardResource)
	get_parent().get_parent().playedCard = cardResource
	get_parent().get_parent().currentPhase = Global.TurnOrder[Global.TurnOrder.find(get_parent().get_parent().currentPhase) + 1]

func _show_range(effect_range: Array[int]):
	show_range.emit(effect_range)

func constructDeck(deck: Array[Card]):
	for heroCard in deck:
		deckCards.append(heroCard)
	deckCards.shuffle()
	dealCards(handSize)

func dealCards(numberOfCards: int):
	if deckCards.size() < numberOfCards:
		discard.shuffle()
		deckCards.append_array(discard)
		discard.clear()

	for i in range(numberOfCards):
		var drawnCard = deckCards.pop_front()
		var card = cardScene.instantiate()
		card.card = drawnCard
		card.card_clicked.connect(_on_card_clicked.bind(card))
		card.show_range.connect(_show_range)
		add_child(card, true)

func draw():
	if deckCards.size() == 0:
		shuffleDeck()
	var drawnCard = deckCards.pop_front()
	var card = cardScene.instantiate()
	card.card = drawnCard
	card.card_clicked.connect(_on_card_clicked.bind(card))
	card.show_range.connect(_show_range)
	add_child(card, true)

func shuffleDeck():
	discard.shuffle()
	deckCards.append_array(discard)
	discard.clear()

func _on_button_pressed():
	if !get_parent().get_parent().currentPhase == Global.Phases.PLAY_CARD:
		return

	var cards = get_children()
	for card in cards:
		remove_child(card)
		discard.append(card.card)
	dealCards(handSize-1)
