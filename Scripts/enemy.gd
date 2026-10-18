class_name Enemy
extends CharacterBody3D

@export var movement_speed: float = 4.0

var gravity = ProjectSettings.get_setting(
	"physics/3d/default_gravity"
)

@export var default_profile_scene: PackedScene

@onready var visual_root: Node3D = $CharacterSlot
@onready var character_slot := $CharacterSlot
@onready var navigation_agent_3d := $NavigationAgent3D
@onready var player := get_tree().get_first_node_in_group("players")

var current_profile: EnemyProfile
var enemy_state_machine: Node
var current_animation_player: AnimationPlayer

var active_state: State = null
var move_direction: Vector3 = Vector3.ZERO
var move_speed: float = 0.0

var health: int = 5000000

const ATTACK_RANGE := 1.0

signal damage_player(damage)
signal died

var movement_enabled: bool = true


# ---------------------------------------------------------
# PIN / LAUNCH SYSTEM
# ---------------------------------------------------------

@export var pin_window: float = 0.25

var last_launch_source: Node3D = null
var last_source_impact_time: float = -1000.0

var last_wall_source: Node3D = null
var last_wall_impact_time: float = -1000.0


func _ready() -> void:
	add_to_group("enemies")

	load_profile(default_profile_scene)
	enemy_state_machine.init(self)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if movement_enabled:
		# Normal AI movement.
		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed
	else:
		# Stop retained horizontal movement.
		# Temporary physics states can override this below.
		velocity.x = 0.0
		velocity.z = 0.0

	# States such as Launched can override velocity here.
	enemy_state_machine.process_physics(delta)

	move_and_slide()

	check_wall_collision()

	face_player(delta)

# ---------------------------------------------------------
# COLLISION HANDLING
# ---------------------------------------------------------

func check_wall_collision() -> void:
	if get_slide_collision_count() == 0:
		return

	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)

		var collider: Object = collision.get_collider()

		if not collider is Node3D:
			continue

		var collider_node := collider as Node3D

		# Only treat things in the "walls" group as walls.
		if not collider_node.is_in_group("walls"):
			continue

		# Ignore floors and other mostly-horizontal surfaces.
		var normal: Vector3 = collision.get_normal()

		if abs(normal.y) > 0.5:
			continue

		if enemy_state_machine.current_state:
			var state: State = enemy_state_machine.current_state

			if state.has_method("on_wall_collision"):
				state.on_wall_collision()

				break


# ---------------------------------------------------------
# DAMAGE
# ---------------------------------------------------------

func apply_damage(amount: int) -> void:
	health -= amount

	print(
		"ENEMY DAMAGE:",
		amount,
		" HEALTH:",
		health
	)

	if health <= 0:
		die()


func _on_body_part_hit(damage: int) -> void:
	apply_damage(damage)


# ---------------------------------------------------------
# LAUNCH / PIN
# ---------------------------------------------------------

func launch_from_source(
	source: Node3D,
	direction: Vector3,
	force: float
) -> void:
	if not current_profile:
		return

	var physics: PhysicsComponent = get_physics_component()

	if physics:
		physics.apply_push(direction, force)

	current_profile.launched.setup(source)

	register_source_impact(source)

	enemy_state_machine.force_state(
		current_profile.launched
	)


func register_source_impact(source: Node3D) -> void:
	if source == null:
		return

	var now: float = Time.get_ticks_msec() / 1000.0

	last_launch_source = source
	last_source_impact_time = now

	print("LAUNCH SOURCE HIT:", source.name)

	check_for_pin()


func record_wall_impact(source: Node3D) -> void:
	if source == null:
		return

	var now: float = Time.get_ticks_msec() / 1000.0

	last_wall_source = source
	last_wall_impact_time = now

	print("WALL HIT")

	check_for_pin()


func check_for_pin() -> void:
	if last_launch_source == null:
		return

	if last_wall_source == null:
		return

	if last_launch_source != last_wall_source:
		return

	var time_difference: float = absf(
		last_source_impact_time - last_wall_impact_time
	)

	if time_difference > pin_window:
		return

	print("########################")
	print("        TRUE PIN")
	print("TIME:", time_difference)
	print("SOURCE:", last_launch_source.name)
	print("########################")

	enter_pinned(last_launch_source)


func enter_pinned(source: Node3D) -> void:
	if not current_profile:
		return

	var pinned: PinnedState = current_profile.pinned

	pinned.setup(source)

	enemy_state_machine.force_state(pinned)


# ---------------------------------------------------------
# PROFILE
# ---------------------------------------------------------

func load_profile(scene: PackedScene) -> void:
	if current_profile:
		current_profile.queue_free()

	current_profile = scene.instantiate()

	character_slot.add_child(current_profile)

	current_animation_player = current_profile.animation_player
	enemy_state_machine = current_profile.fsm

	call_deferred("_connect_body_parts", current_profile)


func _connect_body_parts(node: Node) -> void:
	for child in node.get_children():
		if child is Area3D and child.has_signal("body_part_hit"):
			child.body_part_hit.connect(_on_body_part_hit)

		_connect_body_parts(child)


# ---------------------------------------------------------
# GENERAL
# ---------------------------------------------------------

func die() -> void:
	died.emit()
	queue_free()


func play_anim(name: String) -> void:
	if current_profile and current_profile.anim_state:
		current_profile.anim_state.travel(name)


func face_player(delta: float, turn_speed := 8.0) -> void:
	if not player:
		return

	var to_player = player.global_position - global_position
	to_player.y = 0

	if to_player.length_squared() < 0.001:
		return

	var target_rot := atan2(to_player.x, to_player.z)

	visual_root.rotation.y = lerp_angle(
		visual_root.rotation.y,
		target_rot + PI,
		delta * turn_speed
	)


func get_physics_component() -> PhysicsComponent:
	if current_profile:
		return current_profile.physics_component

	return null
