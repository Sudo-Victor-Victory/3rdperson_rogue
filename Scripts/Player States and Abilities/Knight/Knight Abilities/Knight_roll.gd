extends State

@export var idle_state: State
@export var walking_state: State
@export var running_state: State

@export var roll_speed := 10.0
@export var roll_duration := 0.5

var roll_dir: Vector3
var time_left := 0.0

@export var anim_player: AnimationPlayer
func enter() -> void:
	super()
	parent.is_dodging = true
	time_left = roll_duration 
	anim_player.speed_scale = 1.25 / roll_duration
	print("time_left ", time_left)
	var input = Input.get_vector("left", "right", "forward", "backward")

	var forward = parent.camera_pivot_y.transform.basis.z
	var right   = parent.camera_pivot_y.transform.basis.x

	if input == Vector2.ZERO:
		roll_dir = forward
	else:
		roll_dir = (forward * input.y + right * input.x).normalized()

	parent.rotate_visuals_toward(roll_dir)
	parent.velocity.y = 0


func process_physics(delta: float) -> State:

	time_left -= delta 

	parent.velocity.x = roll_dir.x * roll_speed
	parent.velocity.z = roll_dir.z * roll_speed
	if time_left <= 0.0:
		return _exit_roll()

	return null


func _exit_roll() -> State:
	var input = Input.get_vector("left", "right", "forward", "backward")

	if input == Vector2.ZERO:
		return idle_state

	if Input.is_action_pressed("run"):
		return running_state
	anim_player.speed_scale = 1.5
	parent.dodge_streak += 1
	print("Dodge streak:", parent.dodge_streak)
	print("Damage multiplier:", parent.damage_multiplier)
	return walking_state

func exit() -> void :
	super()
	parent.is_dodging = false
