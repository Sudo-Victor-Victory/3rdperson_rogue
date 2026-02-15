extends RayCast3D

@onready var camera: Camera3D = get_parent()

@export var aim_distance := 500.0
var last_ray_dir: Vector3

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera.project_ray_origin(mouse_pos)
	last_ray_dir = camera.project_ray_normal(mouse_pos)

	global_position = origin
	target_position = last_ray_dir * aim_distance

func get_throw_direction() -> Vector3:
	return last_ray_dir.normalized()
