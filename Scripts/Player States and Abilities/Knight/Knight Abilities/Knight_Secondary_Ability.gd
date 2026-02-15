extends BaseAbility
class_name RollAbility

@export var roll_speed := 8.0
@export var roll_duration := 1.25

var roll_dir: Vector3
var time_left := 0.0
var active := false

func process_input(event):
	if event.is_action_pressed("roll") and not active:
		start_roll()

func start_roll():
	active = true
	time_left = roll_duration

	var input = Input.get_vector("left", "right", "forward", "backward")

	var forward = owner_character.camera_pivot_y.transform.basis.z
	var right   = owner_character.camera_pivot_y.transform.basis.x

	if input == Vector2.ZERO:
		roll_dir = forward
	else:
		roll_dir = (forward * input.y + right * input.x).normalized()

	owner_character.rotate_visuals_toward(roll_dir)
	owner_character.velocity.y = 0
	
	# Optional: play animation
	owner_character.current_profile.play_roll()
	owner_character.animation_locked = true
func process_physics(delta):
	if not active:
		return

	time_left -= delta

	# Override horizontal movement
	owner_character.velocity.x = roll_dir.x * roll_speed
	owner_character.velocity.z = roll_dir.z * roll_speed

	if time_left <= 0.0:
		end_roll()
		
func end_roll():
	active = false
	
	owner_character.unlock_animation()
	owner_character.refresh_locomotion_animation()
