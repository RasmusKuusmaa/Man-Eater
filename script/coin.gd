extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_score(20)
		queue_free()
