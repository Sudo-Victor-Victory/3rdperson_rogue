extends State

@export var walking_state : State
@export var running_state : State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func process_input(event: InputEvent) -> State:
	print("I am in the process input ")
	if (Input.get_vector("left", "right", "forward", "backward") != Vector2(0,0)) \
		&& Input.is_action_pressed("run") :
		print("From idle process I go run")
		return running_state
	elif (Input.get_vector("left", "right", "forward", "backward") != Vector2(0,0)):
		print("From idle process I go walk")
		return walking_state
	else:
		return self


func enter() -> void:
	super()
	parent.velocity = Vector3(0,0,0)


func exit() -> void:
	pass
