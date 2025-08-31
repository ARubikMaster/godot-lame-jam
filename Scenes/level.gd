extends Node2D

@export var oxygen_tank_scene: PackedScene
@export var chest_scene: PackedScene
@export var coin_scene: PackedScene
@export var shark_scene: PackedScene

@onready var music = $Music
@onready var music_timer = $MusicTimer
@onready var ui = $UI

var rng = RandomNumberGenerator.new()
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalScript.GameOver = false
	
	$TankSpawnTimer.wait_time = randf_range(3.0, 6.0)
	$TankSpawnTimer.start()

	$ChestSpawnTimer.wait_time = randf_range(10.0, 20.0)
	$ChestSpawnTimer.start()
	
	$CoinSpawnTimer.wait_time = randf_range(1.0, 2.0)
	$CoinSpawnTimer.start()
	
	$SharkSpawnTimer.wait_time = randf_range(3.5, 6.0)
	$SharkSpawnTimer.start()
	
	music.play_music()
	
	var wait_time = rng.randi_range(60, 70)
	music_timer.wait_time = wait_time
	music_timer.start()

func _game_over():
	var depth = $Camera2D.meters
	ui._game_over(depth)

func _on_tank_spawn_timer_timeout():
	$TankSpawnTimer.wait_time = randf_range(3.0, 6.0)
	
	var new_tank = oxygen_tank_scene.instantiate()
	new_tank.global_position = Vector2(randi_range(-300, 300), ($Camera2D.global_position.y + 160) * 1.75)
	$Objects.add_child(new_tank)

func _on_chest_spawn_timer_timeout() -> void:
	$ChestSpawnTimer.wait_time = randf_range(10.0, 20.0)
	
	var new_chest = chest_scene.instantiate()
	new_chest.global_position = Vector2(randi_range(-300, 300), ($Camera2D.global_position.y + 160) * 1.75)
	$Objects.add_child(new_chest)

func _on_coin_spawn_timer_timeout() -> void:
	$CoinSpawnTimer.wait_time = randf_range(1.0, 2.0)
	
	var new_coin = coin_scene.instantiate()
	new_coin.global_position = Vector2(randi_range(-300, 300), ($Camera2D.global_position.y + 160) * 1.75)
	$Objects.add_child(new_coin)

func _on_music_timer_timeout() -> void:
	music.play_music()
	
	rng.randomize()
	var wait_time = rng.randi_range(60, 70)
	music_timer.wait_time = wait_time
	music_timer.start()

func _on_shark_spawn_timer_timeout():
	$SharkSpawnTimer.wait_time = randf_range(3.5, 6.0)
	
	var directions: Array = [Vector2.LEFT, Vector2.RIGHT]
	var new_shark = shark_scene.instantiate()
	
	new_shark.direction = directions.pick_random()
	new_shark.global_position.x = 0
	new_shark.global_position.y = ($Camera2D.global_position.y + 160) * 1.75
	
	$Obstacles.add_child(new_shark)

func _play_sfx():
	$CoinSFX.play()
