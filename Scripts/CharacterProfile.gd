class_name CharacterProfile
extends Node3D

@export var visuals: Node3D
@export var fsm: Node
@export var animation_player: AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var sword_hitbox: Area3D = (
	$HumanArmature/Skeleton3D/BoneAttachment3D/SwordHitbox
	if has_node("HumanArmature/Skeleton3D/BoneAttachment3D/SwordHitbox")
	else null
)

func get_sword_hitbox() -> Area3D:
	return sword_hitbox

func _ready():
	anim_tree.active = true
	anim_state = anim_tree.get("parameters/playback")
