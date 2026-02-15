extends BaseAbility
class_name MathPrimaryAbility

@export var primary_ball_scene: PackedScene
@export var throw_force := 8.0
@export var charge_scale_rate := 0.3

var current_ball: RigidBody3D
var charging := false
var hold_time := 0.0
func process_input(event):
	if event.is_action_pressed("primary") and not charging:
		start_charge()

	if event.is_action_released("primary") and charging:
		release()

func start_charge():
	charging = true
	hold_time = 0.0
	
	current_ball = primary_ball_scene.instantiate()
	current_ball.freeze = true
	current_ball.visible = true
	current_ball.add_collision_exception_with(owner_character)
	current_ball.add_to_group("projectiles")
	current_ball.set_meta("can_hurt_enemy", true)
	current_ball.damage = 5
	get_tree().current_scene.add_child(current_ball)

	# Spawn above player
	var cam = aim_provider.get_parent()
	var basis = cam.global_transform.basis
	var up = basis.y
	var forward = -basis.z

	current_ball.global_position = owner_character.global_position + up * 2.5 + forward * 1.5

func process_frame(delta):
	if not charging:
		return
	
	hold_time += delta
	
	var scale_factor = 1.0 + hold_time * charge_scale_rate
	current_ball.scale = Vector3.ONE * scale_factor
	
	# Keep ball at aim origin while charging
	var cam = aim_provider.get_parent()
	var basis = cam.global_transform.basis
	var up = basis.y
	var forward = -basis.z

	var target = owner_character.global_position \
		+ up * 2.5 \
		+ forward * 1.5

	# Hover effect
	var time = Time.get_ticks_msec() * 0.002
	target += up * sin(time) * 0.2

	current_ball.global_position = current_ball.global_position.lerp(target, 8.0 * delta)
	
func release():
	charging = false
	
	var direction = aim_provider.get_throw_direction().normalized()
	direction.y += 0.1
	direction = direction.normalized()

	var power = 20.0 + hold_time * 15.0
	current_ball.freeze = false
	current_ball.get_node("CollisionShape3D").disabled =false 
	current_ball.linear_velocity = direction * power
