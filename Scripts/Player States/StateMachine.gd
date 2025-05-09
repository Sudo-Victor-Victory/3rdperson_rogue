extends Node3D


# Called when the node enters the scene tree for the first time.

var current_state: State

@export var starting_state: State

@export var walking_state: State
@export var running_state: State
@export var idle_state: State

func _ready():
	pass # Replace with function body.

# Allows children of State Machine (States themselves) to directly effect the Player
# By making the States children of the player.
func init(player) -> void:
	for child in get_children():
		child.parent = player
	change_state(starting_state)

# Removes the ability of State scripts under a State Machine to effect the Player.
func terminate() -> void:
	for child in get_children():
		child.parent = null
	current_state.exit()
	current_state = null
	
func change_state(new_state) -> void:
	if current_state != null && current_state != new_state:
		current_state.exit()
	current_state = new_state
	current_state.enter()
	

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
