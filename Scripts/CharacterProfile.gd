class_name CharacterProfile
extends Node3D


@export var visuals: Node3D
@export var fsm: Node
@export var animation_player: AnimationPlayer

@onready var sword_hitbox: Area3D = (
	$HumanArmature/Skeleton3D/BoneAttachment3D/SwordHitbox
	if has_node("HumanArmature/Skeleton3D/BoneAttachment3D/SwordHitbox")
	else null
)


func get_sword_hitbox() -> Area3D:
	return sword_hitbox


# Main animation entry point
func play(anim_name: String):
	if animation_player == null:
		push_error("AnimationPlayer missing on CharacterProfile")
		return

	if not animation_player.has_animation(anim_name):
		push_error("Animation not found: " + anim_name)
		return
		
	if animation_player.current_animation == anim_name:
		animation_player.stop()
	#print("Requested anim:", anim_name)
	animation_player.play(anim_name)


# Generic shoot request
func request_shoot():
	# Check if we have a "shoot" animation so other chars can't
	if animation_player and animation_player.has_animation("shoot"):
		play("shoot")

# Used to cancel animations. Currently only used in the Knight
func unlock_animation():
	var player_node = get_parent().get_parent()
	if player_node and player_node is Player:
		player_node.unlock_animation()
	else:
		push_error("unlock_animation called but parent is not a Player")
