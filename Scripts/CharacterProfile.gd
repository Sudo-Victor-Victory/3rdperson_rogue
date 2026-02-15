class_name CharacterProfile
extends Node3D

@export var visuals: Node3D
@export var fsm: Node
@export var animation_player: AnimationPlayer
@onready var anim_tree: AnimationTree = $AnimationTree
var anim_state: AnimationNodeStateMachinePlayback


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


func play_locomotion_idle():
	anim_state.travel("HumanArmature|Idle")

func play_locomotion_walk():
	anim_state.travel("HumanArmature|Run")

func play_locomotion_run():
	anim_state.travel("HumanArmature|Run")

func play_roll():
	anim_state.travel("HumanArmature|Roll_sword")
