extends Node2D

@export var oxygen_tank_scene: PackedScene
@export var chest_scene: PackedScene

@onready var music = $Music
@onready var music_timer = $MusicTimer
@onready var ui = $UI

var rng = RandomNumberGenerator.new()
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$TankSpawnTimer.wait_time = randf_range(3.5, 5.0)
	$ChestSpawnTimer.wait_time = randf_range(10.0, 20.0)
	
	music.play_music()
	
	rng.randomize()
	var wait_time = rng.randi_range(60, 70)
	music_timer.wait_time = wait_time
	music_timer.start()

func _game_over():
	get_tree().quit() #placeholder

func _on_tank_spawn_timer_timeout():
	$TankSpawnTimer.wait_time = randf_range(3.5, 5.0)
	
	var new_tank = oxygen_tank_scene.instantiate()
	new_tank.global_position = Vector2(randi_range(-300, 300), ($Camera2D.global_position.y + 160) * 1.75)
	add_child(new_tank)

func _on_chest_spawn_timer_timeout() -> void:
	$ChestSpawnTimer.wait_time = randf_range(10.0, 20.0)
	
	var new_chest = chest_scene.instantiate()
	new_chest.global_position = Vector2(randi_range(-300, 300), ($Camera2D.global_position.y + 160) * 1.75)
	add_child(new_chest)

func _on_music_timer_timeout() -> void:
	music.play_music()
	
	rng.randomize()
	var wait_time = rng.randi_range(60, 70)
	music_timer.wait_time = wait_time
	music_timer.start()
