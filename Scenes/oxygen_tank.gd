extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		#add air to player
		get_parent().get_parent().get_node("BubbleSFX").play()
		body.air_left = clamp(body.air_left + 50, 0, body.max_air)
		queue_free()
