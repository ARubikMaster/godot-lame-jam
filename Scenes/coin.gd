extends CharacterBody2D

@export var particle_scene: PackedScene

func _process(delta):
	var direction = global_position.direction_to($"../../Player".global_position)
	velocity = direction * (15 * ($"../../Player".upgrade_levels["magnet"] - 1))
	move_and_slide()

func _on_coin_body_entered(body):
	print("Body entered")
	if body.is_in_group("player"):
		print("Chest opened")
		
		body.coins += 1
		print("Coin detected")
		
		var particle = particle_scene.instantiate()
		particle.global_position = global_position
		get_parent().add_child(particle)
		
		queue_free()
