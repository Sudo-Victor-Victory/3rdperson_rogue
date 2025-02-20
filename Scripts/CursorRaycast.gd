extends RayCast3D


signal mySignal(signalArg)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if is_colliding():
		# Gets collider of object the raycast is hitting
		var hit = get_collider()
		print(hit.name)
		if Input.is_action_just_pressed("secondary"):
			print("hi")
