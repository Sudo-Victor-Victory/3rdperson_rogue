class_name State
extends Node

@export var animation_name: String

var parent  # Player reference

func enter():
	if animation_name != "":
		parent.play_anim(animation_name)

	else:
		push_error("State entered with empty animation_name")
func exit():
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
