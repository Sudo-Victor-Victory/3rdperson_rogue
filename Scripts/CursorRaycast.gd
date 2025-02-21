extends RayCast3D

@onready var player = $"../.."

# Offset off the base player model
var relative_offset = Vector3(-2,3, 0)

# Max distance between player & selected object
var stop_distance = 1.5

var move_force = 2
var throw_force = 2

# Has the user pressed RMB to select
var secondary_select = false
# Has the user pressed RMB to throw
var secondary_throw = false



var throwable = null
func _process(delta):
	if Input.is_action_just_pressed("secondary"):
		if secondary_throw:
			print("I called throw")
			throw_the_thing()
		elif is_colliding():
			# Gets collider of object the raycast is hitting
			secondary_select = true
			throwable = get_collider()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if secondary_select:
		# Gets collider of object the raycast is hitting
		do_the_thing(throwable)


			
func do_the_thing(throwable):
		# Where the player is (and the offset at the top left of the player model)
		var target_position = player.global_transform.origin + relative_offset
		
		# Calculate the direction: the diff between the character & the collided obj.
		var direction = (target_position - throwable.global_transform.origin).normalized()
		
		# Calculate the distance from the collided obj to the player
		var distance_to_target = throwable.global_transform.origin.distance_to(target_position)
		
		
		if secondary_select && distance_to_target > stop_distance:
			# Apply force to move the obj
			throwable.apply_impulse(direction * move_force)
		else:
			# Stop all force on objs.
			throwable.linear_velocity = Vector3(0,0,0)
			throwable.angular_velocity = Vector3(0,0,0)

			# Set the collided obj to the player to apply all transforms on the player to the obj.
			throwable.reparent(player)
			# Freeze the object so gravity doesn't drag it to the floor
			throwable.freeze = true
			secondary_select = false
			secondary_throw = true
			
			
func throw_the_thing():
	# Apply physics on collided obj
	throwable.freeze = false
	# add it back to the game world
	throwable.reparent(get_tree().root)
	print(throwable.get_parent().name)
	
	var direction = self.to_global(self.target_position.normalized()) * -1
	
	throwable.apply_impulse(direction * move_force * throw_force)


	throwable = null
	secondary_throw = false
	
