extends Area2D

@export var particle_scene: PackedScene

func _on_body_entered(body):
	print("Body entered")
	if body.is_in_group("player"):
		print("Chest opened")
		
		body.coins += 1
		print("Coin detected")
		
		var particle = particle_scene.instantiate()
		particle.global_position = global_position
		get_parent().add_child(particle)
		
		queue_free()
