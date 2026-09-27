class_name PinnedState
extends State

@export var exit_state: State
@export var duration: float = 0.8
@export var pin_damage: int = 25

var timer: float = 0.0
var pin_source: Node3D = null


func setup(source: Node3D) -> void:
	pin_source = source


func enter() -> void:
	super()

	timer = 0.0

	parent.movement_enabled = false
	parent.velocity = Vector3.ZERO

	parent.apply_damage(pin_damage)

	print("ENEMY PINNED")


func process_physics(delta: float) -> State:
	parent.velocity = Vector3.ZERO

	timer += delta

	if timer >= duration:
		return exit_state

	return self


func exit() -> void:
	super()

	parent.movement_enabled = true

	parent.velocity.x = 0.0
	parent.velocity.z = 0.0
