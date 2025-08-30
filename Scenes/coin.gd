extends Area2D

func _on_body_entered(body):
	print("Body entered")
	if body.is_in_group("player"):
		print("Chest opened")
		
		body.coins += 1
		print("Coin detected")
		
		queue_free()
