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

func _hit_finished():
	# Call another function or signal to check for collisions.
	is_attacking = false



func _on_area_3d_body_entered(body):
	if body.name == "Player":
		print("Hello")
	print(body.name)
