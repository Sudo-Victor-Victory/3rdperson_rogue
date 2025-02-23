extends CharacterBody3D


const SPEED = 0.001

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var navigation_agent_3d = $NavigationAgent3D
@onready var player = $"../../Player"

var speed = 2
var accel = 10


func _process(delta):
	var direction = Vector3()
	print("player position ")
	print(player.global_position)
	navigation_agent_3d.target_position = player.global_position
	print("next path?")
	print(navigation_agent_3d.get_next_path_position())
	direction = (navigation_agent_3d.get_next_path_position() - global_position * -1).normalized() 
	print("Direction")
	print(direction)
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

