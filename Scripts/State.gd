# State.gd
class_name State
extends Node

@export var animation_name: String

var parent  # reference to Player or Enemy

func enter():
	if animation_name != "":
		if parent.has_method("play_anim"):
			parent.play_anim(animation_name)

func exit():
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

func process_frame(delta: float) -> State:
	return null
