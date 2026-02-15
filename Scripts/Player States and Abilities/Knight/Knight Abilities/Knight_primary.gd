extends State

@export var idle_state: State
@export var walking_state: State
@export var running_state: State
@export var attack_duration := 0.5
var time_left := 0.0

func enter():
	super()
	time_left = attack_duration
	print("Activates")
	parent.weapon_hitbox.activate()

func exit():
	print("Deactivates")
	parent.weapon_hitbox.deactivate()

func process_input(event: InputEvent) -> State:
	return null
		
func process_physics(delta: float) -> State:
	time_left -= delta
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
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

	if time_left <= 0.0:
		return _exit_attack()

	return null
	
	
	
func _exit_attack() -> State:
	var is_direction_vector = Input.get_vector("left", "right", "forward", "backward") != Vector2(0,0)
	if Input.is_action_pressed("run") && is_direction_vector:
		return running_state
	elif  is_direction_vector :
		print("Going to walk")
		return walking_state
	else:
		print("Going to idle")
		return idle_state
