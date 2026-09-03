extends Node
class_name HealthComponent

signal damaged(amount)
signal died

@export var max_health := 100

var health := 100
var owner_character: CharacterBody3D

func _ready():
	health = max_health


func apply_damage(amount):
	health -= amount
	emit_signal("damaged", amount)

	if owner_character:
		if owner_character.has_method("on_damaged"):
			owner_character.on_damaged(amount)

	print("Player HP:", health)

	if health <= 0:
		die()

func die():

	emit_signal("died")
	print("Player died")
