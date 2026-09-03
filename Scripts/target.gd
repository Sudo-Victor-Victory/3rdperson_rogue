# Target.gd
extends Area3D

@export var health: int = 0.5
@export var damage_multiplier: float = 5.0

# Optional: if you want to signal other things like score
signal destroyed

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _on_body_entered(body: Node) -> void:
	_process_damage_source(body)

func _on_area_entered(area: Area3D) -> void:
	_process_damage_source(area)

func _process_damage_source(source: Node) -> void:
	# Only accept things explicitly allowed to damage the target
	if not source.has_meta("can_hurt_enemy") || source.get_meta("can_hurt_enemy") != true:
		print("Sorry")
		return
 
	health -= int(source.damage * damage_multiplier)
	print('health ', health)
	# Prevent multi-hit from same projectile
	source.set_meta("can_hurt_enemy", false)

	if health <= 0:
		get_parent().get_parent().queue_free()
