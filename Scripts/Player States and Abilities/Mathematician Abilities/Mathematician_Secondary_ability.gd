extends BaseAbility

@export var throw_force := 300
@export var hold_distance := 3.0

var held_object: RigidBody3D
var holding := false

func process_input(event):
	if event.is_action_pressed("secondary"):
		if holding:
			throw_object()
		else:
			try_pickup()

func try_pickup():
	var obj = interact_provider.get_interactable()
	
	if obj and obj is RigidBody3D:
		held_object = obj
		held_object.freeze = true
		holding = true

func process_physics(delta):
	if not holding:
		return

	var cam = aim_provider.get_parent()
	var basis = cam.global_transform.basis
	
	var right = basis.x
	var up = basis.y
	var forward = -basis.z

	var target = owner_character.global_position \
		+ forward * 2.5 \
		+ up * 2.0 \
		+ right * 1.2

	# ✨ FLOATING EFFECT
	var time = Time.get_ticks_msec() * 0.002
	var float_offset = up * sin(time) * 0.2
	target += float_offset

	held_object.global_position = held_object.global_position.lerp(target, 8.0 * delta)

	
func throw_object():
	if not held_object:
		return

	holding = false
	held_object.reparent(get_tree().current_scene)
	held_object.freeze = false

	# 🔥 Mark as damage source
	held_object.set_meta("can_hurt_enemy", true)

	var direction = aim_provider.get_throw_direction().normalized()
	direction.y += 0.15
	direction = direction.normalized()

	held_object.linear_velocity = direction * 30.0

	held_object = null
