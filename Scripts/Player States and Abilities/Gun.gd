extends Node3D
class_name Gun

@export var shoot_animation: String
@export var bullet_scene: PackedScene
@export var fire_rate := 0.15   # seconds between shots
@export var max_ammo := 12       # optional
@export var reload_time := 1.0   # optional
@export var shoot_anim_name: String
@export var reload_anim_name: String


# References
var owner_character
var aim_provider: Node3D
@onready var gun_anim_player: AnimationPlayer = $Pistol/AnimationPlayer

# Internal state
var _fire_timer := 0.0
var _current_ammo := max_ammo
var _is_reloading := false

func setup(character, aim_node: Node3D):
	owner_character = character
	aim_provider = aim_node
	_current_ammo = max_ammo

func process_frame(delta):
	if _fire_timer > 0:
		_fire_timer -= delta

# Can call this from ability
func try_fire():
	if _is_reloading:
		return

	if _fire_timer > 0:
		return

	if _current_ammo <= 0:
		reload()
		return

	fire()
	_fire_timer = fire_rate

func fire():
	# 1. Play character shoot animation
	if owner_character.current_profile and owner_character.current_profile.animation_player:
		owner_character.play_anim(shoot_animation, true)

	# 2. Play gun animation, always restart
	if gun_anim_player and gun_anim_player.has_animation(shoot_anim_name):
		gun_anim_player.stop()
		gun_anim_player.play(shoot_anim_name, 0.0)

	# 3. Spawn bullet
	if bullet_scene and aim_provider:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_transform = aim_provider.global_transform
		bullet.direction = aim_provider.get_throw_direction()

	_current_ammo -= 1

func reload():
	if _is_reloading:
		return
	_is_reloading = true
	# optionally add reload animation here
	print("RELOADING")
	gun_anim_player.play(reload_anim_name)
	await get_tree().create_timer(reload_time).timeout
	_current_ammo = max_ammo
	_is_reloading = false
