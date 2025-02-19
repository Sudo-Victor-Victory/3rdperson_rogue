extends State

@export var idle_state : State
@export var running_state : State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func enter() -> void:
	super()
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("run"):
		return running_state
	return self


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
