extends State

@export var walking_state : State
@export var idle_state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
 


func enter() -> void:
	super()
	parent.SPEED =  8


func exit() -> void:
	parent.SPEED = 3.5
	
	
func process_input(event: InputEvent) -> State:
	var is_direction_vector = Input.get_vector("left", "right", "forward", "backward") != Vector2(0,0)
	if Input.is_action_pressed("run") && is_direction_vector:
		return self
	elif  is_direction_vector :
		return walking_state
	else:
		return idle_state


func process_physics(delta: float) -> State:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = parent.transform.basis * Vector3(input_dir.x * -1, 0, input_dir.y)

	if direction.length() > 0.01:
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
	else:
		return idle_state

	
