extends State

var duration := 0.5
var timer := 0.0

var return_state: State
var velocity := Vector3.ZERO

@export var knockback_decay := 5.0


func enter():

	print("I Am in stunned!!!!")

	parent.movement_enabled = false

	timer = 0

	var physics = parent.get_physics_component()

	if physics:
		velocity = physics.consume_knockback()
		print("STUN VELOCITY:", velocity)


func process_physics(delta):

	timer += delta

	parent.velocity.x = velocity.x
	parent.velocity.z = velocity.z

	velocity = velocity.move_toward(
		Vector3.ZERO,
		knockback_decay * delta
	)


	if timer >= duration:

		parent.movement_enabled = true

		if return_state:
			return return_state

	return self
