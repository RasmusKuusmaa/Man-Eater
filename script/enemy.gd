extends CharacterBody2D

@export var SPEED: float = 100
var player: Node2D

var max_health := 20
var health = max_health

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(delta: float) -> void:
	if player == null:
		print("no palyer")
		return

	var direction = (player.global_position - global_position).normalized()
	velocity = direction * SPEED
	move_and_slide()

func take_damage(dmg: int):
	health -= dmg
	if health <= 0:
		die()
	
func die():
	print('ded')
	queue_free()
