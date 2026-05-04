extends Node2D

@onready var spawn_timer = $"../CoinSpawnTimer"

@export var coin_scene: PackedScene
@export var spawn_radius: float = 900

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	spawn_timer.timeout.connect(spawn_coin)
	
func spawn_coin():
	if player == null:
		return
	
	var coin = coin_scene.instantiate()
	
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * spawn_radius
	
	coin.global_position = player.global_position + offset
	
	get_parent().add_child.call_deferred(coin)
