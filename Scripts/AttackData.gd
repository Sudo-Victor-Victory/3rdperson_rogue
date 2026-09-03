class_name AttackData
extends Resource

@export var name: String
@export var animation_name: String

@export var duration: float = 0.4
@export var damage: int = 10

# simple movement hook (we'll expand later)
@export var move_forward: float = 0.0

# combo routing
@export var next_attacks: Array[AttackData] = []
