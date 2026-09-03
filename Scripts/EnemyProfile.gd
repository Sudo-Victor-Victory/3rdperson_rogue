class_name EnemyProfile
extends CharacterProfile


@onready var anim_tree: AnimationTree =  $"Character Visuals/mixamo_base/AnimationTree"

@onready var anim_state = anim_tree.get("parameters/playback")
@onready var physics_component = $"PhysicsComponent"
@onready var stunned = $"EnemyStateMachine/Stunned"
var body_parts: Array = []

func register_body_part(part: Node) -> void:
	body_parts.append(part)
	print(body_parts)

func apply_slice_hit(dir: Vector3, damage: int, force: float):

	var enemy = get_parent().get_parent()

	enemy.health -= damage

	physics_component.apply_push(dir, force)
	stunned.return_state = fsm.current_state
	enemy.enemy_state_machine.force_state(
		stunned
	)
