extends State

@export var idle_state : State
@export var running_state : State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _process_physics(delta: float) -> State:
	print("I am using the walking process")
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	var direction = (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		parent.character_visuals.look_at(parent.position+direction)
		parent.velocity.x = direction.x * SPEED
		parent.velocity.z = direction.z * SPEED
	else:
		return idle_state
		
		
		
	return null
	
func enter() -> void:
	super()
	parent.velocity = Vector3(0,0,0)


func exit() -> void:
	pass
