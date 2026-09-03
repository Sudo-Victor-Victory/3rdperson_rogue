class_name PhysicsComponent
extends Node


var external_velocity := Vector3.ZERO

@export var decay := 15.0


func apply_push(dir: Vector3, force: float):
	external_velocity = dir.normalized() * force


func consume_knockback():
	var temp = external_velocity
	external_velocity = Vector3.ZERO
	return temp



func process(delta):
	external_velocity = external_velocity.move_toward(
		Vector3.ZERO,
		decay * delta
	)
