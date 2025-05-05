extends State

@export var running_state : State
@export var idle_state : State
@onready var animation_player = $"../../Character Visuals/mixamo_base/AnimationPlayer"

var is_attacking = false
func enter() -> void:
	super()
	is_attacking = true


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	print("Is attacking?")
	print(is_attacking)
	if is_attacking == false:
		return running_state
	else:
		return self

func _on_animation_player_animation_finished(anim_name):
	print("Does this work?")
	if anim_name == "EnemyAttack":
		is_attacking = false
