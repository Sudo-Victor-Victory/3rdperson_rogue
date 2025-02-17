extends CharacterBody3D

@onready var animation_player = $"Character Visuals/mixamo_base/AnimationPlayer"
@onready var camera_mount = $"Camera Mount"
@onready var character_visuals = $"Character Visuals"

const JUMP_VELOCITY = 4.5


@export var walking_speed = 3.5
@export var running_speed = 8
var SPEED = 3.5
var is_running = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var horizontal_sensitivity = 0.5
@export var vertical_sensitivity   = 0.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * horizontal_sensitivity))
		### MAY REMOVE LATER ###
		# The line below makes it so the character doesn't rotate upon moving the mouse.
		character_visuals.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * vertical_sensitivity))
		
func _physics_process(delta):
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		is_running = true
	else:
		SPEED = walking_speed
		is_running = false
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#######       THIS MAY BE REPLACED WITH A FSM. ###
	if direction:
		if is_running:
			if animation_player.current_animation != "running":
				animation_player.play("running")
		else:
			if animation_player.current_animation != "walking":
				animation_player.play("walking")
			

		# Makes our character rotate / point to their arrival location
		character_visuals.look_at(position+direction)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
