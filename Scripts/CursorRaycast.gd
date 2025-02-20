extends RayCast3D

@onready var player = $"../.."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if is_colliding():
		# Gets collider of object the raycast is hitting
		var hit = get_collider()
		print(hit.name)
		if Input.is_action_just_pressed("secondary"):
			# Calculated the Vector3 representing the distance from selected OBJ to PLAYER
			var distance = hit.transform.origin - (player.transform.origin )
			print("Box position " )
			print(hit.transform.origin)
			print("Vs my own ")
			print(player.transform.origin)
			print("and the diff between the 2???")
			print(distance)
			hit.add_constant_force(-distance)
			print("hi")
