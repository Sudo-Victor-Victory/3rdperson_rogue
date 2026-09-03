# StateMachine.gd
extends Node3D

var current_state: State

@export var starting_state: State

func init(player) -> void:
	for child in get_children():
		if child is State:
			child.parent = player
	change_state(starting_state)

func terminate() -> void:
	for child in get_children():
		if child is State:
			child.parent = null
	if current_state != null:
		current_state.exit()
	current_state = null

func change_state(new_state: State):
	if new_state == null:
		return

	if current_state == new_state:
		return

	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

func process_input(event: InputEvent) -> void:
	if current_state:
		var new_state = current_state.process_input(event)
		if new_state:
			change_state(new_state)

func process_physics(delta: float) -> void:
	if current_state:
		var new_state = current_state.process_physics(delta)
		if new_state:
			change_state(new_state)

func process_frame(delta: float) -> void:
	if current_state:
		var new_state = current_state.process_frame(delta)
		if new_state:
			change_state(new_state)

func force_state(new_state: State):
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
