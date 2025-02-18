extends Node3D

signal walking
signal running
signal jumping
signal idle

var is_running = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_pressed("run"):
		is_running = true
	else:
		is_running = false
	
	if direction:
		if is_running:
			emit_signal("running")
		else:
			emit_signal("walking")
	else:
		emit_signal("idle")
		
		
