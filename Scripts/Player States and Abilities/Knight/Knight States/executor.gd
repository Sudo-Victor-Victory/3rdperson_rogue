extends BaseAbility
class_name Executor

@export var hitbox: Area3D

# starting move (Punch1 usually)
@export var default_attack: AttackData

var active := false
var time_left := 0.0

var current_attack: AttackData
var buffered_attack: AttackData = null
var buffer_locked := false

func setup(owner, aim, interact):
	super.setup(owner, aim, interact)
	hitbox.setup(owner)


func process_input(event):
	if event.is_action_pressed("primary"):
		_request_attack()


func _request_attack():
	if not active:
		start_attack(default_attack)
		return

	if current_attack == null:
		return

	if current_attack.next_attacks.is_empty():
		return  # terminal attack = no buffering allowed

	buffered_attack = current_attack.next_attacks[0]
	buffer_locked = true
	print("Buffered:", buffered_attack.name)

func start_attack(attack: AttackData):
	print("Playing:", attack.animation_name)
	buffer_locked = false
	current_attack = attack
	active = true
	time_left = attack.duration

	print("▶ ENTER ATTACK:", attack.name)

	hitbox.activate()
	owner_character.play_anim(attack.animation_name, true)


func process_physics(delta):
	if not active:
		return

	time_left -= delta

	# optional movement hook (simple version)
	if current_attack:
		_apply_forward_movement(current_attack)

	if time_left <= 0.0:
		end_attack()


func _apply_forward_movement(attack: AttackData):
	if attack.move_forward <= 0.0:
		return

	# VERY simple placeholder movement:
	# (later you replace this with real root motion / state machine integration)
	var forward = -owner_character.global_transform.basis.z
	owner_character.global_position += forward * attack.move_forward * 0.1


func end_attack():
	hitbox.deactivate()
	active = false

	print("◼ EXIT ATTACK:", current_attack.name)

	owner_character.unlock_animation()

	# combo transition
	if buffered_attack != null:
		print("↪ COMBO INTO:", buffered_attack.name)
		start_attack(buffered_attack)
		buffered_attack = null

	else:
		current_attack = null
