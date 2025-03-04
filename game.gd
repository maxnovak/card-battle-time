extends Control

const mapScene = preload("res://Map/Map.tscn")
const combatScene = preload("res://Events/Combat/Combat.tscn")
const aquireCardScene = preload("res://Events/AquireCard/AquireCard.tscn")
const upgradeCardScene = preload("res://Events/UpgradeCard/UpgradeCard.tscn")
const winScreen = preload("res://Events/WinScreen/WinScreen.tscn")

var mapHolder: Map

@export
var huntressDeck: Array[Card]

func _ready():
	DisplayServer.window_set_min_size(Vector2(1152,648))
	Global.playerDeck = huntressDeck

func _on_map_change_scene(type):
	Input.set_default_cursor_shape(Input.CURSOR_WAIT)
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TransitionImageHolder.texture = texture
	$Scenes.remove_child(mapHolder)
	if type == LocationClass.Types.BATTLE:
		var enemyId = randi_range(0, Global.enemies.size()-1)
		var combat = combatScene.instantiate()
		combat.enemy = Global.enemies[enemyId]
		combat.combat_end.connect(_event_ended.bind(combat))
		$Scenes.add_child(combat)
	if type == LocationClass.Types.CARD:
		var aquireCard = aquireCardScene.instantiate()
		aquireCard.event_end.connect(_event_ended.bind(aquireCard))
		$Scenes.add_child(aquireCard)
	if type == LocationClass.Types.UPGRADE_POWER:
		var upgradeCard = upgradeCardScene.instantiate()
		upgradeCard.event_end.connect(_event_ended.bind(upgradeCard))
		$Scenes.add_child(upgradeCard)
	if type == LocationClass.Types.BOSS:
		var enemyId = randi_range(0, Global.bosses.size()-1)
		var combat = combatScene.instantiate()
		combat.enemy = Global.bosses[enemyId]
		combat.is_boss_fight = true
		combat.combat_end.connect(_event_ended.bind(combat))
		$Scenes.add_child(combat)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _event_ended(event):
	Input.set_default_cursor_shape(Input.CURSOR_WAIT)
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TransitionImageHolder.texture = texture
	$Scenes.remove_child(event)
	if event is Combat && event.is_boss_fight == true:
		var win = winScreen.instantiate()
		$Scenes.add_child(win)
	else:
		$Scenes.add_child(mapHolder)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished
	event.queue_free()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_main_menu_new_game():
	Input.set_default_cursor_shape(Input.CURSOR_WAIT)
	var image = get_viewport().get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	$TransitionImageHolder.texture = texture
	mapHolder = mapScene.instantiate()
	mapHolder.change_scene.connect(_on_map_change_scene)
	$Scenes.add_child(mapHolder)
	$AnimationPlayer.play("side-wipe")
	await $AnimationPlayer.animation_finished
	$Scenes/MainMenu.queue_free()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
