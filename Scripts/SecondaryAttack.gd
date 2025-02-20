extends Node3D
class_name Secondary

@onready var player = $"../../.."


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func physics_process(delta, hit):
	var distance = hit.transform.origin.direction_to(player.transform.origin )
	print(distance)
	print("Vs my own ")
	print(player.transform.origin)
	hit.apply_impulse(distance )
	#hit.move_toward(distance)

	print("hi")
