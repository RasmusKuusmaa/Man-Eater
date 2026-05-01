extends CharacterBody2D

@export var SPEED: float = 1000

func _physics_process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		
	direction = direction.normalized()
	velocity = direction * SPEED
	
	move_and_slide()
	
	


func _on_eat_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		eat_enemy(body)
		
func eat_enemy(enemy):
	enemy.queue_free()
