extends Area3D

@export var speed := 60.0
@export var damage := 10

var direction: Vector3

func _ready() -> void:
	set_meta("can_hurt_enemy", true)
		
func _physics_process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if body.has_signal("body_part_hit"):
		body.emit_signal("body_part_hit", damage)
	queue_free()
