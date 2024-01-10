extends "res://state_machine/state_machine.gd"

@onready var idle = $Idle
@onready var attack = $Attack
@onready var hit = $Hit
@onready var death = $Death

func _ready():
	states_map = {
		"idle": idle,
		"attack": attack,
		"hit": hit,
		"death": death,
	}

func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	super._change_state(state_name)

func _unhandled_input(event):
	# Here we only handle input that can interrupt states, attacking in this case,
	# otherwise we let the state node handle it.
	current_state.handle_input(event)
