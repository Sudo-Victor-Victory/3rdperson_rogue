class_name SliceObject
extends Node3D

@export var grow_time: float = 0.20
@export var final_height: float = 8.0

@export var damage: int = 5
@export var push_force: float = 20.0
@export var launch_force: float = 20.0

# How close the slice must be horizontally to count as
# being directly underneath the enemy.
@export var vertical_launch_radius: float = 1.0

@export var solid_slice_scene: PackedScene

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var area: Area3D = $Area3D
@onready var hitbox_shape: CollisionShape3D = $Area3D/CollisionShape3D

var elapsed: float = 0.0

var slice_direction: Vector3 = Vector3.ZERO

var has_hit: bool = false
var has_finished_growing: bool = false


func setup(dir: Vector3) -> void:
	slice_direction = dir.normalized()


func _ready() -> void:
	set_meta("can_hurt_enemy", true)

	if not area.body_entered.is_connected(_on_body_entered):
		area.body_entered.connect(_on_body_entered)

	mesh.scale.y = 0.0

	# Give this slice its own collision shape.
	var box: BoxShape3D = hitbox_shape.shape as BoxShape3D

	if box:
		hitbox_shape.shape = box.duplicate()


func _process(delta: float) -> void:
	if has_finished_growing:
		return

	elapsed += delta

	var t: float = clampf(elapsed / grow_time, 0.0, 1.0)

	# Grow the mesh vertically.
	mesh.scale.y = lerpf(0.0, final_height, t)

	# Grow the hitbox to match the mesh.
	var box: BoxShape3D = hitbox_shape.shape as BoxShape3D

	if box:
		box.size.y = lerpf(0.1, final_height, t)

		hitbox_shape.position.y = box.size.y / 2.0
		mesh.position.y = box.size.y / 2.0

	if elapsed >= grow_time:
		has_finished_growing = true
		finish_growth()


func _on_body_entered(body: Node3D) -> void:
	if has_hit or has_finished_growing:
		return

	# Only launch enemies.
	if not body.is_in_group("enemies"):
		return

	var enemy: Enemy = body as Enemy

	if enemy == null or enemy.current_profile == null:
		return

	has_hit = true

	print("SLICE POS:", global_position)
	print("ENEMY POS:", enemy.global_position)

	# Calculate the horizontal distance from the slice
	# to the enemy, ignoring their heights.
	var horizontal_offset: Vector2 = Vector2(
		enemy.global_position.x - global_position.x,
		enemy.global_position.z - global_position.z
	)

	# The slice must be lower than the enemy and close
	# enough horizontally to count as an upward launch.
	var is_under_enemy: bool = (
		global_position.y < enemy.global_position.y
		and horizontal_offset.length() <= vertical_launch_radius
	)

	var push_direction: Vector3
	var applied_force: float

	if is_under_enemy:
		# Pure vertical launch: no horizontal momentum.
		push_direction = Vector3.UP
		applied_force = launch_force

		print("VERTICAL LAUNCH")

	else:
		# Push horizontally away from the slice.
		push_direction = Vector3(
			horizontal_offset.x,
			0.0,
			horizontal_offset.y
		)

		if push_direction.length_squared() > 0.001:
			push_direction = push_direction.normalized()
		else:
			# Fallback for a near-zero horizontal offset.
			push_direction = Vector3.UP

		applied_force = push_force

	print("PUSH DIRECTION:", push_direction)
	print("APPLIED FORCE:", applied_force)

	enemy.current_profile.apply_slice_hit(
		push_direction,
		damage,
		applied_force,
		self
	)


func get_hit_data() -> Dictionary:
	return {
		"damage": damage,
		"force": push_force,
		"direction": slice_direction
	}


func finish_growth() -> void:
	if not solid_slice_scene:
		push_warning("SolidSlice scene is not assigned.")
		return

	var solid_slice: SolidSlice = solid_slice_scene.instantiate()

	# Preserve the growing slice's final dimensions.
	solid_slice.final_height = final_height
	solid_slice.final_width = mesh.scale.x
	solid_slice.final_depth = mesh.scale.z

	solid_slice.damage = damage

	get_tree().current_scene.add_child(solid_slice)

	# Preserve position and orientation.
	solid_slice.global_transform = global_transform

	queue_free()
