class_name State
extends Node

@export var animation_name: String
@export var SPEED = 3.5

var gravity =  ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var parent: Player

func enter() -> void:
	parent.animation_player.play(animation_name)
	

func exit() -> void:
	pass

func process_frame(delta: float) -> State:
	return null
