extends CharacterBody3D

class_name Player

@onready var camera_pivot_y = $"CameraPivotY"
@onready var camera_pivot_x = $"CameraPivotY/CameraPivotX"

@onready var character_slot = $"CharacterSlot"

@export var default_character: PackedScene
@export var knight_character: PackedScene
var weapon_hitbox: Area3D

var current_profile: CharacterProfile
var current_animation_player: AnimationPlayer
var current_state_machine
var ability_controller
var current_visuals: Node3D
const JUMP_VELOCITY = 4.5

@export var walking_speed = 3.5
@export var running_speed = 8
var SPEED = 3.5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var horizontal_sensitivity = 0.5
@export var vertical_sensitivity = 0.5
@onready var aim_provider = $"CameraPivotY/CameraPivotX/Camera3D/AimRay"
@onready var interaction_ray = $CameraPivotY/CameraPivotX/Camera3D/InteractionRay
var animation_locked := false
func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if default_character:
		load_character(default_character)


func load_character(profile_scene: PackedScene):
	if current_profile:
		current_state_machine.terminate()
		current_profile.queue_free()

	current_profile = profile_scene.instantiate()
	character_slot.add_child(current_profile)

	current_visuals = current_profile.visuals
	current_animation_player = current_profile.animation_player
	current_state_machine = current_profile.fsm
	ability_controller = current_profile.get_node("AbilityController")
	ability_controller.setup(self, aim_provider, interaction_ray)
	# Connects weapon to player model
	weapon_hitbox = null 
	if current_profile.has_method("get_sword_hitbox"): 
		var hitbox = current_profile.get_sword_hitbox() 
		if hitbox: 
			weapon_hitbox = hitbox
			weapon_hitbox.setup(self) 

	current_state_machine.init(self)



func _input(event):
	if event is InputEventMouseMotion:

		# Yaw (left/right) — rotate the Y pivot ONLY
		camera_pivot_y.rotate_y(deg_to_rad(-event.relative.x * horizontal_sensitivity))

		# Pitch (up/down) — rotate the X pivot ONLY
		# maybe keep the negative
		camera_pivot_x.rotate_x(deg_to_rad(event.relative.y * -vertical_sensitivity))

		# Clamp pitch so camera cannot look under player
		var pitch = camera_pivot_x.rotation_degrees.x
		pitch = clamp(pitch, -45, 65)   # tune values as needed
		camera_pivot_x.rotation_degrees.x = pitch


	if current_state_machine:
		current_state_machine.process_input(event)
	if ability_controller:
		ability_controller = current_profile.get_node("AbilityController")
		ability_controller.process_input(event)
	
	if Input.is_action_pressed("switch"):
		current_state_machine.terminate()
		load_character(knight_character)


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	move_and_slide()

	if current_state_machine:
		current_state_machine.process_physics(delta)
	if ability_controller:
		ability_controller.process_physics(delta)

func _process(delta):
	if current_state_machine:
		current_state_machine.process_frame(delta)
	if ability_controller:
		ability_controller.process_frame(delta)

func rotate_visuals_toward(direction: Vector3):
	if current_visuals == null:
		return

	var flat_dir = Vector3(direction.x, 0, direction.z)
	if flat_dir.length() < 0.01:
		return

	flat_dir = flat_dir.normalized()
	var target_rot = atan2(-flat_dir.x, -flat_dir.z)

	var current_rot = current_visuals.rotation.y
	current_visuals.rotation.y = lerp_angle(current_rot, target_rot, 0.18)  


func play_anim(name: String, lock := false) -> void:
	if animation_locked and not lock:
		return

	if current_profile and current_profile.anim_state:
		current_profile.anim_state.travel(name)

	animation_locked = lock
	
	
func unlock_animation():
	animation_locked = false



func refresh_locomotion_animation():
	if animation_locked:
		return

	var input = Input.get_vector("left", "right", "forward", "backward")

	if input == Vector2.ZERO:
		current_profile.play_locomotion_idle()
	elif Input.is_action_pressed("run"):
		current_profile.play_locomotion_run()
	else:
		current_profile.play_locomotion_walk()
