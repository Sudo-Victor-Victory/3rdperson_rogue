extends State

@export var running_state : State
@export var idle_state : State

var is_attacking = false
var has_hit_player = false

var connected_parts: Array = []

func enter() -> void:
	if is_attacking:
		return  # 🔥 prevents re-entry reset

	super()

	is_attacking = true
	has_hit_player = false
	parent.movement_enabled = false
	_connect_body_parts()


func exit() -> void:
	_disconnect_body_parts()
	parent.movement_enabled = true
	is_attacking = false


func process_physics(delta: float) -> State:
	if not is_attacking:
		return running_state

	return self


func _connect_body_parts():
	connected_parts.clear()

	var profile = parent.get_node_or_null("CharacterSlot/EnemyProfile")
	if not profile:
		push_error("EnemyProfile not found")
		return

	for part in profile.find_children("*", "Area3D", true, false):

		if not part.has_signal("hit_player"):
			continue

		if not part.hit_player.is_connected(_on_body_part_hit):
			part.hit_player.connect(_on_body_part_hit)

		connected_parts.append(part)

	#print("Connected parts:", connected_parts.size())


func _disconnect_body_parts():
	for part in connected_parts:

		if part and part.has_signal("hit_player"):
			if part.hit_player.is_connected(_on_body_part_hit):
				part.hit_player.disconnect(_on_body_part_hit)

	connected_parts.clear()


func _on_body_part_hit(player: Player):
	if has_hit_player:
		return

	has_hit_player = true

	print("Enemy hit player attempt")

	var health = player.get_node_or_null("HealthComponent")
	if not health:
		return

	# 🔥 PERFECT DODGE CHECK
	if player.is_dodging:
		print("Perfect Dodge!")

		player.dodge_streak += 1
		player.damage_multiplier += 0.25

		_trigger_perfect_dodge_feedback(player)

		return  # IMPORTANT: no damage applied

	# normal hit
	health.apply_damage(10 * player.damage_multiplier)

# Called from animation
func _hit_finished():
	is_attacking = false


func _trigger_perfect_dodge_feedback(player: Player):
	print("SLOW MO / FLASH / FX")

	# optional slow-mo
	Engine.time_scale = 0.3
	await get_tree().create_timer(0.1, true).timeout
	Engine.time_scale = 1.0
