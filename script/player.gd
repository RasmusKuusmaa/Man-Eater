extends CharacterBody2D

@onready var health_bar = $UI/HealthBar
@onready var score_label = $UI/ScoreLabel
@onready var attack_area = $AttackArea

@export var SPEED: float = 1000
@export var min_speed = 200

var GROW_FACTOR: float = 1.1
var scale_cap:float = 8
var max_health := 100
var health := max_health
var dmg_speed_effect = 100
var score := 0

var attack_damage := 100
var attack_cooldown := 0.3
var can_attack := true


var death_screen_scene = preload("res://scenes/death_screen.tscn")
var death_screen

func _ready() -> void:
	score_label.text = "Score: " + str(score)
	health_bar.value = health

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
	
	
	if Input.is_action_pressed("attack") and can_attack:
		perform_attack()
	move_and_slide()
	
func perform_attack():
	can_attack = false
	attack_area.monitoring = true
	
	await  get_tree().create_timer(0.1).timeout
	attack_area.monitoring = false
	
	await  get_tree().create_timer(attack_cooldown).timeout	
	can_attack = true


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		eat_enemy(body)
		
func eat_enemy(enemy):
	take_damage(2)
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
	SPEED = max(SPEED - dmg_speed_effect, min_speed)
	if health <= 0:
		_on_player_died()
	
func _on_player_died():
	death_screen = death_screen_scene.instantiate()
	add_child(death_screen)
	get_tree().paused = true	

func add_score(gain: int):
	score += gain
	print(score) 
	score_label.text = "score: " + str(score)


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(attack_damage)
			print("attatcked")
