extends State

@export var walking_state: State
@export var idle_state: State
@export var attack_state: State

func enter() -> void:
	super()

func process_physics(delta: float) -> State:

	var dist = parent.global_position.distance_to(parent.player.global_position)

	if dist < parent.ATTACK_RANGE:
		return attack_state

	# WALK THRESHOLD (upper bound = 12)
	if dist > 22:
		return idle_state

	if dist > 12:
		return walking_state

	# RUN movement
	parent.navigation_agent_3d.set_target_position(parent.player.global_position)

	var next_pos = parent.navigation_agent_3d.get_next_path_position()
	var dir = parent.global_position.direction_to(next_pos)

	parent.move_direction = dir.normalized()
	parent.move_speed = parent.movement_speed * 1.3

	return self
