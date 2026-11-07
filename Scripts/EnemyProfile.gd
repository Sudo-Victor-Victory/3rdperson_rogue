class_name EnemyProfile
extends CharacterProfile

@onready var anim_tree: AnimationTree = $"Character Visuals/mixamo_base/AnimationTree"
@onready var anim_state = anim_tree.get("parameters/playback")

@onready var physics_component: PhysicsComponent = $"PhysicsComponent"

@onready var launched: LaunchState = $"EnemyStateMachine/Launched"
@onready var pinned: PinnedState = $"EnemyStateMachine/Pinned"

var body_parts: Array = []


func register_body_part(part: Node) -> void:
	body_parts.append(part)

	print(body_parts)


func apply_slice_hit(
	dir: Vector3,
	damage: int,
	force: float,
	source: Node3D = null
) -> void:
	var enemy := get_parent().get_parent() as Enemy

	enemy.apply_damage(damage)

	enemy.launch_from_source(
		source,
		dir,
		force
	)
