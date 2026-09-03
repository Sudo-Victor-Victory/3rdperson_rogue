extends BaseAbility
class_name PistolAbility

var current_weapon: Gun

func setup(owner, aim, interact):
	owner_character = owner

func set_weapon(weapon: Gun):
	current_weapon = weapon

func process_frame(delta):
	if current_weapon:
		current_weapon.process_frame(delta)

func process_input(event):
	# single shot on press
	if event.is_action_pressed("secondary"):
		if current_weapon:
			current_weapon.try_fire()
