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
	


func process_physics(delta: float) -> State:
	if parent.global_position.distance_to(parent.player.global_position) < 10:
		return running_state
	if parent.global_position.distance_to(parent.player.global_position) < 20:
		var direction = self.transform.origin
		# This is ok
		parent.navigation_agent_3d.set_target_position(parent.player.global_position)
		
		parent.movement_delta = parent.movement_speed * delta
		var next_path_position  = parent.navigation_agent_3d.get_next_path_position()
		var new_velocity  = parent.global_position.direction_to(next_path_position) * parent.movement_delta
		parent.global_position = parent.global_position.move_toward(parent.global_position + new_velocity, parent.movement_delta)
		parent.move_and_slide()
	else:
		return idle_state
	
	
	return self
