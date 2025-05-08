extends State

@export var running_state : State
@export var idle_state : State
@onready var animation_player = $"../../Character Visuals/mixamo_base/AnimationPlayer"
var is_attacking = false # Used to tell if the character is in its attack animation
var can_damage : bool = true # Used to make sure an attack can only deal damage once per collision

func enter() -> void:
	super()
	is_attacking = true


func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	if is_attacking == false:
		return running_state
	else:
		return self

# Is called when the attack animation finishes
func _hit_finished():
	is_attacking = false # false to return enemy to running
	can_damage = true 	 # true to allow the enemy to deal damage again

# When the enemy collides with a body (Characterbody3D, StaticBody3d, RigidBody3d) 
func _on_area_3d_body_entered(body):
	if body.name == "Player" and can_damage:
		parent.emit_signal("damage_player", 10)
		can_damage = false
