extends Node3D

@export var player_scene: PackedScene
@export var enemy_scene: PackedScene

@onready var spawn_points = $"../SpawnPoints"

signal enemy_count_changed(count: int)

var enemy_count := 0


func _ready():
	add_to_group("level_manager")
	call_deferred("spawn_player")
	call_deferred("spawn_enemies")


func spawn_player():
	var player = player_scene.instantiate()
	get_parent().add_child(player)

	var player_spawn = spawn_points.get_node("PlayerSpawn")
	player.global_position = player_spawn.global_position


func spawn_enemies():
	for spawn in spawn_points.get_children():
		if spawn.name.begins_with("EnemySpawn"):
			var enemy = enemy_scene.instantiate()
			get_parent().add_child(enemy)

			enemy.global_position = spawn.global_position

			enemy_count += 1
			enemy.died.connect(_on_enemy_died)

	emit_signal("enemy_count_changed", enemy_count)


func _on_enemy_died():
	enemy_count -= 1
	print("Enemies left:", enemy_count)

	emit_signal("enemy_count_changed", enemy_count)
	

func _enter_tree():
	add_to_group("level_manager")
