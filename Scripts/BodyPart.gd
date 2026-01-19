extends Area3D

signal body_part_hit(damage: int)

@export var damage_multiplier := 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)


func _on_body_entered(body: Node) -> void:
	_process_damage_source(body)


func _on_area_entered(area: Area3D) -> void:
	_process_damage_source(area)


func _process_damage_source(source: Node) -> void:
	# Must explicitly allow damage
	if not source.has_meta("can_hurt_enemy") || source.get_meta("can_hurt_enemy") != true:
		return

	#  Godot 4–correct variable check
	if not ("damage" in source):
		return

	var final_damage := int(source.damage * damage_multiplier)
	body_part_hit.emit(final_damage)

	# Prevent multi-hit from same source
	source.set_meta("can_hurt_enemy", false)
