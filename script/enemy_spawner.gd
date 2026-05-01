extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_interval: float = 0.5
@export var spawn_radius: float = 500

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	start_spawning()
	
func start_spawning():
	spawn_enemy()
	get_tree().create_timer(spawn_interval).timeout.connect(start_spawning)
	
func spawn_enemy():
	if player == null:
		return
		
	var enemy = enemy_scene.instantiate()
	enemy.add_to_group("enemy")
	
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
	
	enemy.global_position = player.global_position + offset
	
	get_parent().add_child.call_deferred(enemy)
