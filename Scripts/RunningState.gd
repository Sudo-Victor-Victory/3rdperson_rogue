extends State

@export var walking_state : State
@export var idle_state : State
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
 


func enter() -> void:
	print("Changed speed to 8")
	parent.SPEED =  8


func exit() -> void:
	parent.SPEED = 3.5
	pass
