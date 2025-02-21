class_name Player
extends CharacterBody3D


@onready var animation_player = $"Character Visuals/mixamo_base/AnimationPlayer"
@onready var camera_mount = $"Camera Mount"
@onready var character_visuals = $"Character Visuals"
@onready var state_machine = $StateMachine

@onready var ray_cast_3d = $"Camera Mount/RayCast3D"


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
	state_machine.init(self)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * horizontal_sensitivity))
		### MAY REMOVE LATER ###
		# The line below makes it so the character doesn't rotate upon moving the mouse.
		character_visuals.rotate_y(deg_to_rad(event.relative.x * horizontal_sensitivity))
		
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * vertical_sensitivity))
		


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
		# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	move_and_slide()
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
