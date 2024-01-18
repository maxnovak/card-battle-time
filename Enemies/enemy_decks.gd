class_name EnemyDecks

var EvilWizardDeck: Array[EnemyCardClass] = [
	EnemyCardClass.new({
		cardName = "Fireblast",
		amount = 5,
		effect = Global.EffectTypes.DAMAGE,
		abilityRange = [1,2]
	}),
	EnemyCardClass.new({
		cardName = "Fireball",
		amount = 15,
		effect = Global.EffectTypes.DAMAGE,
		abilityRange = [0]
	}),
]
