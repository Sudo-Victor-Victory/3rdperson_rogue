class_name AbilityController
extends Node

@export var primary_ability: Node
@export var secondary_ability: Node

var owner_character

func setup(owner):
	owner_character = owner
	
	if primary_ability:
		primary_ability.setup(owner_character)
	if secondary_ability:
		secondary_ability.setup(owner_character)

func process_input(event: InputEvent):
	if primary_ability:
		primary_ability.process_input(event)
	if secondary_ability:
		secondary_ability.process_input(event)

func process_frame(delta):
	if primary_ability:
		primary_ability.process_frame(delta)
	if secondary_ability:
		secondary_ability.process_frame(delta)

func process_physics(delta):
	if primary_ability:
		primary_ability.process_physics(delta)
	if secondary_ability:
		secondary_ability.process_physics(delta)
