class_name Enemy
extends CharacterBody3D


const movement_speed = 4.0
var   movement_delta 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var navigation_agent_3d = $NavigationAgent3D
@onready var player = $"../../Player"
@onready var enemy_state_machine = $EnemyStateMachine




func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	enemy_state_machine.init(self)

func _process(delta):
	var direction = self.transform.origin
	# This is ok
	navigation_agent_3d.set_target_position(player.global_position)
	
	movement_delta = movement_speed * delta
	var next_path_position  = navigation_agent_3d.get_next_path_position()
	var new_velocity  = global_position.direction_to(next_path_position) * movement_delta
	global_position = global_position.move_toward(global_position + new_velocity, movement_delta)
	move_and_slide()


func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
