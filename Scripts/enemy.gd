class_name Enemy
extends CharacterBody3D


@export var movement_speed := 4.0
var movement_delta 

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

@export var default_profile_scene: PackedScene
@onready var visual_root: Node3D = $CharacterSlot
@onready var character_slot := $CharacterSlot
@onready var navigation_agent_3d := $NavigationAgent3D
@onready var player := get_tree().get_first_node_in_group("players")

var current_profile: Node
var enemy_state_machine: Node
var current_animation_player: AnimationPlayer
var last_attack_id := -1


var health := 10
const ATTACK_RANGE := 1.5

signal damage_player(damage) 



func _ready() -> void:
	load_profile(default_profile_scene)
	enemy_state_machine.init(self)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	face_player(delta)

	move_and_slide()
	enemy_state_machine.process_physics(delta)

# Loads the selected character logic 
func load_profile(scene: PackedScene) -> void:
	if current_profile:
		current_profile.queue_free()

	current_profile = scene.instantiate()
	character_slot.add_child(current_profile)

	current_animation_player = current_profile.animation_player
	enemy_state_machine = current_profile.fsm

	call_deferred("_connect_body_parts", current_profile)


# Attaches signals to profile nodes
func _connect_body_parts(node: Node) -> void:
	for child in node.get_children():
		if child is Area3D and child.has_signal("body_part_hit"):
			child.body_part_hit.connect(_on_body_part_hit)
		_connect_body_parts(child)


func _on_body_part_hit(damage: int) -> void:
	health -= damage
	print("Enemy hit! Health:", health)

	if health <= 0:
		die()


func die() -> void:
	print("Enemy died")
	queue_free()

func play_anim(name: String) -> void:
	if current_profile and current_profile.anim_state:
		current_profile.anim_state.travel(name)


# Rotates the character model to face the player
func face_player(delta: float, turn_speed := 8.0) -> void:
	if not player:
		return

	var to_player = player.global_transform.origin - global_transform.origin
	to_player.y = 0

	if to_player.length_squared() < 0.001:
		return

	var target_rot := atan2(to_player.x, to_player.z)
	visual_root.rotation.y = lerp_angle(
		visual_root.rotation.y,
		target_rot,
		delta * turn_speed
	)
