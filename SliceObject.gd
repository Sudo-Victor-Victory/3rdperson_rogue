class_name SliceObject
extends Node3D

@export var grow_time := 0.20
@export var final_height := 8.0

@onready var mesh := $MeshInstance3D
@onready var area := $Area3D
@onready var hitbox_shape := $Area3D/CollisionShape3D

var elapsed := 0.0

@export var damage := 5
@export var push_force := 20.0
@export var launch_force := 20.0

var slice_direction := Vector3.ZERO
var has_hit := false


func setup(dir: Vector3):
	# Keep this only as a fallback/reference
	slice_direction = dir.normalized()


func _ready():

	set_meta("can_hurt_enemy", true)

	area.body_entered.connect(_on_body_entered)

	mesh.scale.y = 0.0

	var box := hitbox_shape.shape as BoxShape3D
	hitbox_shape.shape = box.duplicate()


func _process(delta):

	if elapsed >= grow_time:
		return

	elapsed += delta

	var t = clamp(elapsed / grow_time, 0.0, 1.0)

	mesh.scale.y = lerp(0.0, final_height, t)

	var box := hitbox_shape.shape as BoxShape3D
	box.size.y = lerp(0.1, final_height, t)

	hitbox_shape.position.y = box.size.y / 2.0
	mesh.position.y = box.size.y / 2.0


func _on_body_entered(body):

	if has_hit:
		return

	if body.is_in_group("enemies"):

		has_hit = true

		print("SLICE POS:", global_position)
		print("ENEMY POS:", body.global_position)

		# Direction from slice -> enemy
		var push_direction = body.global_position - global_position

		# Normal horizontal push
		push_direction.y = 0
		push_direction = push_direction.normalized()

		# If the slice is underneath the enemy, launch upward
		if global_position.y < body.global_position.y:
			push_direction.y = 1.0
			push_direction = push_direction.normalized()

		print("PUSH DIRECTION:", push_direction)

		body.current_profile.apply_slice_hit(
			push_direction,
			damage,
			push_force
		)


func get_hit_data():

	return {
		"damage": damage,
		"force": push_force,
		"direction": slice_direction
	}
