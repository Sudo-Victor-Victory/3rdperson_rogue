extends Node3D


# Called when the node enters the scene tree for the first time.

var current_state: State

@export var starting_state: State

@export var walking_state: State
@export var running_state: State
@export var idle_state: State

func _ready():
	pass # Replace with function body.

func init(parent: Player) -> void:
	print("Player is " + parent.name)
	for child in get_children():
		print(child.name)
		child.parent = parent
		print("Child " + child.name + " parent of " + child.parent.name)
	print("starting state is " + starting_state.name)
	change_state(starting_state)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_manager_walking():
	if current_state.name != "Walking":
		print("I changed the state to be walking !!!! + " + current_state.name)
		change_state(walking_state)
	pass # Replace with function body..
	# Call the walking state


func _on_input_manager_idle():
	if current_state.name != "Idle":
		print("I changed the state to be idle !!!! + " + current_state.name)
		change_state(idle_state)
		
	pass

func _on_input_manager_running():
	if current_state.name != "Running":
		print("I changed the state to be running !!!! + " + current_state.name)
		change_state(running_state)



func change_state(new_state ) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()
	



