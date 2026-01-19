extends Area3D

@export var damage := 5

var owner_character: CharacterBody3D


func setup(owner: CharacterBody3D) -> void:
	owner_character = owner
	# Monitoring is used for the Area3d to report if it has collisions
	monitoring = false
	set_meta("can_hurt_enemy", false)
	add_to_group("melee")


func activate() -> void:
	# Monitoring is used for the Area3d to report if it has collisions
	monitoring = true
	set_meta("can_hurt_enemy", true)


func deactivate() -> void:
	# Monitoring is used for the Area3d to report if it has collisions
	monitoring = false
	set_meta("can_hurt_enemy", false)
