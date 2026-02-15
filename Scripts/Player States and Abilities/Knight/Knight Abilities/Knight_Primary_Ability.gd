extends BaseAbility
class_name SwordAbility

@export var hitbox: Area3D
@export var attack_duration := 0.5

var active := false
var time_left := 0.0

func setup(owner, aim, interact):
	super.setup(owner, aim, interact)
	hitbox.setup(owner)

func process_input(event):
	if event.is_action_pressed("primary") and not active:
		start_attack()

func start_attack():
	print("Yay sword attack")
	active = true
	time_left = attack_duration
	
	hitbox.activate()
	owner_character.play_anim("HumanArmature|Run_swordAttack", true)

func process_physics(delta):
	if not active:
		return

	time_left -= delta
	
	if time_left <= 0.0:
		end_attack()

func end_attack():
	hitbox.deactivate()
	active = false
	owner_character.unlock_animation()
