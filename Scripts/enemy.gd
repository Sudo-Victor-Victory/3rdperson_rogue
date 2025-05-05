class_name Enemy
extends CharacterBody3D


var movement_speed = 4.0
var movement_delta 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var navigation_agent_3d = $NavigationAgent3D
@onready var player = $"../../Player"
@onready var enemy_state_machine = $EnemyStateMachine
@onready var animation_player = $"Character Visuals/mixamo_base/AnimationPlayer"

var health = 10
const ATTACK_RANGE = 1.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	enemy_state_machine.init(self)

func _process(delta):
	look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z))
	pass

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	enemy_state_machine.process_physics(delta)


func _on_area_3d_body_part_hit(damage):
	health -= damage
	print("New health ")
	print( health)
	if health <=0:
		print("Enemy died")
		queue_free()


