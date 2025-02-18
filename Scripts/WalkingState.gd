extends State

@export var idle_state : State
@export var running_state : State


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func enter() -> void:
	super()
	parent.velocity = Vector3(0,0,0)


func exit() -> void:
	pass
