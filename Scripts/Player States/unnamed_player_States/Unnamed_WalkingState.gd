extends State

@export var idle_state : State
@export var running_state : State
@export var roll_state : State

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		return running_state
	if Input.is_action_just_pressed("roll"):
		return roll_state
	return self


func process_physics(delta: float) -> State:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")

	# No movement → return idle
	if input_dir.length() == 0:
		return idle_state

	# Use the yaw pivot for direction (NOT the full camera)
	var cam = parent.camera_pivot_y  

	var forward = cam.transform.basis.z * -1
	var right = cam.transform.basis.x 

	var move_dir = (-input_dir.y * forward) + (input_dir.x * right)
	move_dir.y = 0
	move_dir = move_dir.normalized()

	# Move the character
	parent.velocity.x = move_dir.x * parent.SPEED
	parent.velocity.z = move_dir.z * parent.SPEED

	# Rotate character model only while moving
	parent.rotate_visuals_toward(move_dir)

	return self
