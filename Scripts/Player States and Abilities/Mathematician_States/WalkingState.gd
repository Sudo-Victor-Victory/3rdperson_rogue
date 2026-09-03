# Walking.gd
extends State

@export var idle_state: State
@export var running_state: State

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		return running_state
	return null

func process_physics(delta: float) -> State:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	if input_dir.length() == 0:
		return idle_state

	# Safe because this is Player-only
	if parent is Player:
		var cam = parent.camera_pivot_y
		var forward = cam.transform.basis.z * -1
		var right = cam.transform.basis.x
		var move_dir = (-input_dir.y * forward) + (input_dir.x * right)
		move_dir.y = 0
		move_dir = move_dir.normalized()

		var speed = parent.get_move_speed()

		parent.velocity.x = move_dir.x * speed
		parent.velocity.z = move_dir.z * speed

		parent.rotate_visuals_toward(move_dir)

	return self
