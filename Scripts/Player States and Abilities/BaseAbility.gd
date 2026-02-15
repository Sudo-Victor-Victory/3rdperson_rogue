class_name BaseAbility
extends Node

var owner_character: Player
var aim_provider
var interact_provider

func setup(owner, aim, interact):
	owner_character = owner
	aim_provider = aim
	interact_provider = interact

func process_input(event): pass
func process_frame(delta): pass
func process_physics(delta): pass
