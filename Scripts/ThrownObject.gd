extends RigidBody3D

@export var damage := 3
var can_hurt_enemy := true


func _ready() -> void:
	set_meta("can_hurt_enemy", true)

	if owner:
		add_collision_exception_with(owner)


func _integrate_forces(_state):
	# Optional cleanup after first hit
	if not get_meta("can_hurt_enemy"):
		queue_free()
