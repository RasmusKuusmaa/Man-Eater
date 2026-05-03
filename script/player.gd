extends CharacterBody2D

@export var SPEED: float = 1000
var GROW_FACTOR: float = 1.1
var scale_cap:float = 8
var max_health := 100
var health := max_health

@onready var health_bar = $CanvasLayer/HealthBar
var death_screen_scene = preload("res://scenes/death_screen.tscn")
var death_screen

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		
	direction = direction.normalized()
	
	if direction.x != 0:
		$Sprite2D.flip_h = direction.x  < 0
	velocity = direction * SPEED
	
	move_and_slide()
	
	


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		eat_enemy(body)
		
func eat_enemy(enemy):
	take_damage(20)
	enemy.queue_free()
	grow()

func grow():
	var new_scale = scale * GROW_FACTOR
	var clamped = min(new_scale.x, scale_cap)
	
	scale = Vector2(clamped, clamped)

func take_damage(amount):
	health -= amount
	health  = clamp(health, 0, max_health)
	health_bar.value = health
	if health <= 0:
		_on_player_died()
	
func _on_player_died():
	death_screen = death_screen_scene.instantiate()
	add_child(death_screen)
	get_tree().paused = true	
