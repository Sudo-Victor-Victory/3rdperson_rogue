extends State

@export var idle_state: State
@export var running_state: State
@export var attack_state: State

func process_physics(delta: float) -> State:

	var dist = parent.global_position.distance_to(parent.player.global_position)

	if dist < parent.ATTACK_RANGE:
		return attack_state

	# RUN THRESHOLD (lower bound = 8)
	if dist < 8:
		return running_state

	# IDLE
	if dist > 22:
		return idle_state

	# WALK movement
	parent.navigation_agent_3d.set_target_position(parent.player.global_position)

	var next_pos = parent.navigation_agent_3d.get_next_path_position()
	var dir = parent.global_position.direction_to(next_pos)

	parent.move_direction = dir.normalized()
	parent.move_speed = parent.movement_speed * 0.6

	return self
