class_name SliceAbility
extends BaseAbility

@export var slice_scene: PackedScene
@export var preview_scene: PackedScene

var preview: Node3D
var slice: Node3D

var is_placing := false


func process_input(event: InputEvent) -> void:
	if event.is_action_pressed("primary"):
		start_preview()

	if event.is_action_released("primary"):
		confirm_slice()


func process_frame(delta: float) -> void:
	if is_placing:
		update_preview(delta)


func start_preview() -> void:
	if is_placing:
		return

	is_placing = true
	preview = preview_scene.instantiate()
	get_tree().current_scene.add_child(preview)


func update_preview(_delta: float) -> void:
	if not is_instance_valid(preview):
		return

	var hit: Dictionary = get_surface_hit()

	if hit.is_empty():
		return

	var hit_position: Vector3 = hit["position"]
	var hit_normal: Vector3 = hit["normal"]

	var forward: Vector3 = -aim_provider.get_throw_direction().normalized()

	preview.global_position = hit_position

	# Align the preview to the actual world surface,
	# not to the enemy that happens to be in front of it.
	forward = forward.slide(hit_normal).normalized()

	# Safety fallback if the projected direction is nearly zero.
	if forward.length_squared() < 0.001:
		forward = Vector3.FORWARD.slide(hit_normal).normalized()

	var basis := Basis.looking_at(forward, hit_normal)
	preview.global_transform = Transform3D(basis, hit_position)


func confirm_slice() -> void:
	if not is_placing:
		return

	is_placing = false

	if not is_instance_valid(preview):
		return

	var transform: Transform3D = preview.global_transform
	var dir: Vector3 = -transform.basis.z.normalized()

	preview.queue_free()
	preview = null

	spawn_slice(transform, dir)


func spawn_slice(transform: Transform3D, dir: Vector3) -> void:
	var new_slice: Node3D = slice_scene.instantiate()
	get_tree().current_scene.add_child(new_slice)

	new_slice.global_transform = transform
	new_slice.setup(dir)


func get_surface_hit() -> Dictionary:
	var cam: Node3D = aim_provider.get_parent()

	var origin: Vector3 = cam.global_position
	var dir: Vector3 = aim_provider.get_throw_direction().normalized()

	var space_state = owner_character.get_world_3d().direct_space_state

	# Exclude the player, all enemies, and the preview itself
	# if it happens to have a physics collision object.
	var excluded_rids: Array[RID] = []

	if owner_character is CollisionObject3D:
		excluded_rids.append(owner_character.get_rid())

	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")

	for enemy_node in enemies:
		if enemy_node is CollisionObject3D:
			excluded_rids.append(enemy_node.get_rid())

	if preview is CollisionObject3D:
		excluded_rids.append(preview.get_rid())

	# 1. Raycast forward toward the world.
	var query := PhysicsRayQueryParameters3D.create(
		origin,
		origin + dir * 500.0
	)

	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = excluded_rids

	var hit: Dictionary = space_state.intersect_ray(query)

	if not hit.is_empty():
		return hit

	# 2. If nothing was hit, raycast downward from a point ahead.
	var fallback_point: Vector3 = origin + dir * 10.0

	var down_query := PhysicsRayQueryParameters3D.create(
		fallback_point,
		fallback_point + Vector3.DOWN * 100.0
	)

	down_query.collide_with_areas = false
	down_query.collide_with_bodies = true
	down_query.exclude = excluded_rids

	var ground_hit: Dictionary = space_state.intersect_ray(down_query)

	if not ground_hit.is_empty():
		return ground_hit

	# 3. Final fallback.
	return {
		"position": fallback_point,
		"normal": Vector3.UP
	}
