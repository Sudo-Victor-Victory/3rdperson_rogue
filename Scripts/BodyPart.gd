extends Area3D

signal body_part_hit(damage)
@export var damage := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(hit) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hit(body):
	if body.is_in_group("projectiles") && body.can_hurt_enemy == true:
		print("Enemy was hit")
		# Calls _on_area_3d_body_part_hit in Enemy.gd
		body_part_hit.emit(damage)
		# Once the projectile hits the enemy we do not track damage.
		body.can_hurt_enemy = false

