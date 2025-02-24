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
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		parent.character_visuals.look_at(parent.position+direction)
		parent.velocity.x = direction.x * parent.SPEED
		parent.velocity.z = direction.z * parent.SPEED
	else:
		return idle_state

	return self
	
