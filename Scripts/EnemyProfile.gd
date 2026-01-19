class_name EnemyProfile
extends Node3D

@export var visuals: Node3D
@export var fsm: Node   # StateMachine
@export var animation_player: AnimationPlayer
@onready var anim_tree: AnimationTree =  $"Character Visuals/mixamo_base/AnimationTree"

@onready var anim_state = anim_tree.get("parameters/playback")
