extends Node2D

signal DisplayError(message: String)

const cardWidthMove = 80

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
	get_parent().discard.append(card)
	get_parent().playedCard = card
	get_parent().currentPhase = Global.TurnOrder[Global.TurnOrder.find(get_parent().currentPhase) + 1]

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

func _on_button_pressed():
	if !get_parent().currentPhase == Global.Phases.PLAY_CARD:
		return

	var cards = get_children()
	for card in cards:
		remove_child(card)
		get_parent().discard.append(card)
	get_parent().dealCards()
