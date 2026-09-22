class_name SolidSlice
extends ThrownObject

@export var final_height: float = 8.0
@export var final_width: float = 1.0
@export var final_depth: float = 1.0


@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	super._ready()

	freeze = true
	continuous_cd = true

	set_meta("can_hurt_enemy", true)

	add_to_group("projectiles")

	setup_dimensions()


func setup_dimensions() -> void:
	mesh.scale = Vector3(
		final_width,
		final_height,
		final_depth
	)

	var box := collision_shape.shape as BoxShape3D

	if box:
		box = box.duplicate()
		collision_shape.shape = box

		box.size = Vector3(
			final_width,
			final_height,
			final_depth
		)

	mesh.position.y = final_height / 2.0

	collision_shape.position.y = final_height / 2.0
