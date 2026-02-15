extends RayCast3D

@onready var camera: Camera3D = get_parent()

@export var interact_distance := 200.0
var last_ray_dir: Vector3


func get_interactable():
	if is_colliding():
		return get_collider()
	return null
