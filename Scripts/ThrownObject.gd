class_name ThrownObject
extends RigidBody3D

@export var damage: int = 3
@export var launch_force_multiplier: float = 1.0

var can_hurt_enemy: bool = true


func _ready() -> void:
	set_meta("can_hurt_enemy", true)

	contact_monitor = true
	max_contacts_reported = 8

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not can_hurt_enemy:
		return

	if not body is Enemy:
		return

	var enemy: Enemy = body as Enemy

	var speed: float = linear_velocity.length()

	# A stationary object should not launch an enemy.
	if speed < 1.0:
		return

	var direction: Vector3 = linear_velocity.normalized()

	var force: float = speed * launch_force_multiplier

	print("THROWN OBJECT LAUNCHING ENEMY:", enemy.name)

	enemy.launch_from_source(
		self,
		direction,
		force
	)


func _integrate_forces(
	_state: PhysicsDirectBodyState3D
) -> void:
	if not get_meta("can_hurt_enemy", true):
		queue_free()
