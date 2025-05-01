extends State

@export var walking_state : State
@export var running_state : State


func enter() -> void:
	super()
	# Required because we modify velocity in running/walking
	# and the player will still have that velocity unless stopped
	parent.velocity.x = 0
	parent.velocity.z = 0

func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.get_vector("left", "right", "forward", "backward") != Vector2(0,0):
		if(Input.is_action_pressed("run")):
			print("Running")
			return running_state
		else:
			print("Walking")
			return walking_state
	else:
		return self



func process_physics(delta: float) -> State:
	return self
