extends BaseAbility

@export var bullet_scene: PackedScene

func process_input(event):

	if event.is_action_pressed("secondary"):
		print("NOTHING HAPPENS RN")
