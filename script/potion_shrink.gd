extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.shrink(0.7)
		queue_free()
