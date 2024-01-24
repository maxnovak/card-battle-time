extends "res://state_machine/state_machine.gd"

@onready var attack = $Attack
@onready var death = $Death
@onready var hit = $Hit
@onready var idle = $Idle
@onready var poison = $Poison

func _ready():
	states_map = {
		"attack": attack,
		"death": death,
		"hit": hit,
		"idle": idle,
		"poison": poison,
	}

func _change_state(state_name):
	# The base state_machine interface this node extends does most of the work.
	if not _active:
		return
	super._change_state(state_name)
