extends Control

@onready var label = $Label
var level_manager

func _ready():
	level_manager = get_tree().get_first_node_in_group("level_manager")

	if level_manager == null:
		push_error("LevelManager not found in group yet")
		return

	level_manager.enemy_count_changed.connect(_on_enemy_count_changed)

	# optional: initialize UI immediately
	label.text = "Enemies Left: %d" % level_manager.enemy_count


func _on_enemy_count_changed(count: int):
	label.text = "Enemies Left: %d" % count
