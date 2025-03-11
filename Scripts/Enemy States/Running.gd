extends State

@export var walking_state : State
@export var idle_state : State

func enter() -> void:
	super()
	parent.movement_speed =  5


func exit() -> void:
	parent.movement_speed = 3.5
	


func process_physics(delta: float) -> State:
	# Look into method to D.R.Y.
	if parent.global_position.distance_to(parent.player.global_position) < 10:
		var direction = self.transform.origin
		parent.navigation_agent_3d.set_target_position(parent.player.global_position)
		
		parent.movement_delta = parent.movement_speed * delta
		var next_path_position  = parent.navigation_agent_3d.get_next_path_position()
		var new_velocity  = parent.global_position.direction_to(next_path_position) * parent.movement_delta
		parent.global_position = parent.global_position.move_toward(parent.global_position + new_velocity, parent.movement_delta)
		parent.move_and_slide()
		return self
	if parent.global_position.distance_to(parent.player.global_position) < 20:
		return walking_state
	else:
		return idle_state
	
