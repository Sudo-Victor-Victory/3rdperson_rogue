class_name SliceAbility
extends BaseAbility

@export var slice_scene: PackedScene
@export var preview_scene: PackedScene

var preview: Node3D
var slice: Node3D

var is_placing := false


func process_input(event):

	if event.is_action_pressed("primary"):
		start_preview()

	if event.is_action_released("primary"):
		confirm_slice()


func process_frame(delta):
	if is_placing:
		update_preview(delta)


func start_preview():
	if is_placing:
		return

	is_placing = true
	preview = preview_scene.instantiate()
	get_tree().current_scene.add_child(preview)


func update_preview(delta):
	if not preview:
		return

	var hit = get_surface_hit()

	var forward = -aim_provider.get_throw_direction().normalized()

	if hit:
		preview.global_position = hit.position

		forward = forward.slide(hit.normal).normalized()

		var basis = Basis.looking_at(forward, hit.normal)
		preview.global_transform = Transform3D(basis, hit.position)
	else:
		preview.global_position = hit.position


func confirm_slice():
	if not is_placing:
		return

	is_placing = false

	var transform := preview.global_transform

	# Get the direction the preview is actually facing
	var dir := -transform.basis.z.normalized()

	preview.queue_free()
	preview = null

	spawn_slice(transform, dir)

func spawn_slice(transform: Transform3D, dir: Vector3):

	var slice = slice_scene.instantiate()
	get_tree().current_scene.add_child(slice)

	slice.global_transform = transform
	slice.setup(dir)
	
func get_surface_hit():
	var cam = aim_provider.get_parent()

	var origin = cam.global_position
	var dir = aim_provider.get_throw_direction().normalized()

	var space_state =  owner_character.get_world_3d().direct_space_state

	# 1) forward ray
	var query = PhysicsRayQueryParameters3D.create(
		origin,
		origin + dir * 500.0
	)

	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.exclude = [owner_character.get_rid()]

	var hit = space_state.intersect_ray(query)

	if hit:
		return hit

	# 2) fallback: ray DOWN from predicted point
	var fallback_point = origin + dir * 10.0

	var down_query = PhysicsRayQueryParameters3D.create(
		fallback_point,
		fallback_point + Vector3.DOWN * 100.0
	)

	down_query.collide_with_bodies = true
	down_query.exclude = [owner_character.get_rid()]

	var ground_hit = space_state.intersect_ray(down_query)

	if ground_hit:
		return ground_hit

	# 3) final fallback
	return {
		"position": fallback_point,
		"normal": Vector3.UP
	}
