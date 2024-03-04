extends MarginContainer

func _ready():
	$HBoxContainer/VBoxContainer/MenuOptions/Continue.modulate = Color.hex(0x5c5c5cff)

func _on_new_game_gui_input(event):
	if event.is_pressed():
		get_tree().change_scene_to_file("res://Game.tscn")

func _on_exit_gui_input(event):
	if event.is_pressed():
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
