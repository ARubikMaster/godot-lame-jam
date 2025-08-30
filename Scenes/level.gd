extends Node2D

@export var oxygen_tank_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$TankSpawnTimer.wait_time = randf_range(3.5, 5.0)

func _game_over():
	get_tree().quit() #placeholder

func _on_tank_spawn_timer_timeout():
	$TankSpawnTimer.wait_time = randf_range(3.5, 5.0)
	
	var new_tank = oxygen_tank_scene.instantiate()
	new_tank.global_position = Vector2(randi_range(-300, 300), ($Camera2D.global_position.y + 160) * randf_range(1.5, 2))
	add_child(new_tank)
