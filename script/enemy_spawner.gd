extends Node2D

@onready var spawn_timer = $"../EnemySpawnTimer"

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 0.5
@export var spawn_radius: float = 500


var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	if player == null:
		return
		
	var enemy = enemy_scene.instantiate()
	enemy.add_to_group("enemy")
	
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
	
	enemy.global_position = player.global_position + offset
	
	get_parent().add_child.call_deferred(enemy)
