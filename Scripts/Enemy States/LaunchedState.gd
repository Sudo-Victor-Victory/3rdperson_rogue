class_name LaunchState
extends State

@export var exit_state: State

@export var duration: float = 0.6
@export var deceleration: float = 20.0
@export var wall_damage: int = 10

var timer: float = 0.0
var velocity: Vector3 = Vector3.ZERO

var launch_source: Node3D = null
var wall_hit: bool = false


func setup(source: Node3D) -> void:
	launch_source = source


func enter() -> void:
	super()
	print("I GOT LAUNCHED")

	timer = 0.0
	wall_hit = false

	parent.movement_enabled = false

	var physics: PhysicsComponent = parent.get_physics_component()

	if physics:
		velocity = physics.consume_knockback()
	else:
		velocity = Vector3.ZERO


func process_physics(delta: float) -> State:
	timer += delta

	parent.velocity = velocity

	velocity = velocity.move_toward(
		Vector3.ZERO,
		deceleration * delta
	)

	if timer >= duration:
		return exit_state

	return self


func exit() -> void:
	super()

	parent.movement_enabled = true

	parent.velocity.x = 0.0
	parent.velocity.z = 0.0


func on_wall_collision() -> void:
	if wall_hit:
		return

	wall_hit = true

	print("LAUNCHED ENEMY HIT WALL")

	parent.apply_damage(wall_damage)

	if launch_source:
		parent.record_wall_impact(launch_source)
