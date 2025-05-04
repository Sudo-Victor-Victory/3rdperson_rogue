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
	


func exit() -> void:
	pass
	
	
func process_input(event: InputEvent) -> State:
	var is_direction_vector = Input.get_vector("left", "right", "forward", "backward") != Vector2(0,0)
	if Input.is_action_pressed("run") && is_direction_vector:
		return self
	elif  is_direction_vector :
		print("Going to walk")
		return walking_state
	else:
		print("Going to idle")
		return idle_state


func process_physics(delta: float) -> State:
	return self
	
