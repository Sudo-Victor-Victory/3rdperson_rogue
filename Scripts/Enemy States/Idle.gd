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

	return self


func process_physics(delta: float) -> State:
	print(parent.global_position.distance_to(parent.player.global_position))
	if parent.global_position.distance_to(parent.player.global_position) < 10:
		return running_state
	elif parent.global_position.distance_to(parent.player.global_position) < 20:
		return walking_state
		
	return self
