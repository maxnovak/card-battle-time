extends Node

enum EffectTypes {
	BLOCK,
	DAMAGE,
	DAMAGE_OVER_TIME,
}

enum Actor {
	ENEMY,
	PLAYER,
}

const HuntressDeck = [
	{
		cardName = "Spear",
		damage = "7",
		effect = EffectTypes.DAMAGE,
	},
	{
		cardName = "Spear",
		damage = "7",
		effect = EffectTypes.DAMAGE,
	},
	{
		cardName = "Spear",
		damage = "7",
		effect = EffectTypes.DAMAGE,
	},
	{
		cardName = "Poison",
		damage = "5",
		effect = EffectTypes.DAMAGE_OVER_TIME,
	},
	{
		cardName = "Defend",
		damage = "10",
		effect = EffectTypes.BLOCK,
	},
	{
		cardName = "Defend",
		damage = "10",
		effect = EffectTypes.BLOCK,
	},
	{
		cardName = "Defend",
		damage = "10",
		effect = EffectTypes.BLOCK,
	},
]
