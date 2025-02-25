extends RayCast3D

@onready var player = $"../.."
@onready var primary_ball = $"../../PrimaryBall"

# Offset off the base player model
var relative_offset = Vector3(-2,3, 0)

# Max distance between player & selected object
var stop_distance = 1.5

var move_force = 2
var throw_force = 4

var hold_counter : float = 0.0
var hold_time : float = 1.0

# Rigidbody3d references that allow us to call physics functions on
var throwable = null
var ball = null


# Checks if the user has pressed the primary fire button
var primary_fire = false
# Has the user pressed RMB to select
var secondary_pickup = false
# Has the user pressed RMB to throw
var secondary_throw = false

func _process(delta):
	if Input.is_action_just_pressed("secondary"):
		if secondary_throw:
			print("I called throw")
			throw_object(throwable)
			secondary_throw = false
		elif is_colliding():
			# Gets collider of object the raycast is hitting
			secondary_pickup = true
			throwable = get_collider()

	if Input.is_action_pressed("primary"):
		if !primary_fire:
			ball = primary_ball.duplicate()
			ball.visible = true
			player.add_child(ball)
			ball.get_child(0).disabled = false
			primary_fire = true
		
		hold_counter += delta
		if hold_counter > 0.1:
			# Rigidbody3d does not like its scale being modified. Workaround is mod. its children.
			ball.get_node("CollisionShape3D").scale += Vector3(hold_counter * 0.001 ,  hold_counter * 0.001, hold_counter * 0.001)
			ball.get_node("MeshInstance3D").scale += Vector3(hold_counter * 0.001 ,  hold_counter * 0.001, hold_counter * 0.001)
	
	if Input.is_action_just_released("primary") :
		throw_object(ball)
		hold_counter = 0.0
		primary_fire = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if secondary_pickup:
		# Gets collider of object the raycast is hitting
		secondary_pickup_player(throwable)
		
		
func secondary_pickup_player(throwable):
		# Where the player is (and the offset at the top left of the player model)
		var target_position = player.global_transform.origin + relative_offset
		
		# Calculate the direction: the diff between the character & the collided obj.
		var direction = (target_position - throwable.global_transform.origin).normalized()
		
		# Calculate the distance from the collided obj to the player
		var distance_to_target = throwable.global_transform.origin.distance_to(target_position)
		
		if secondary_pickup && distance_to_target > stop_distance:
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
			secondary_pickup = false
			secondary_throw = true
			
func throw_object(obj):
	# Apply physics on collided obj
	obj.freeze = false
	# add it back to the game world
	obj.reparent(get_tree().root)
	# Calculates a normalized global direction from the raycast's current position towards the
	# Raycast's destination point. It works !!!!!
	# Has Vector3(2,0,0) to get object to be in the same x position before the offset change
	var global_direction = ((global_basis * target_position) + Vector3(2,0,0)).normalized()

	# Applies physics on the object.
	obj.apply_impulse(global_direction * move_force * throw_force)
