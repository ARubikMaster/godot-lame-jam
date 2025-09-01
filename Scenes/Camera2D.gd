extends Camera2D

@export var player: CharacterBody2D
var bg_color_modulate: float = 1
var meters: int = 0
var last_milestone: int = 0

@export var shake_intensity: float = 10.0
@export var shake_duration: float = 0.5
var shake_timer: float = 0.0
var original_offset: Vector2

func _ready():
	original_offset = offset

func _process(delta):
	global_position.y += 50 * delta
	$Sprite2D.region_rect.position.y += 10 * delta
	
	if $Sprite2D.region_rect.position.y >= 384:
		$Sprite2D.region_rect.position.y = 0
	
	if !GlobalScript.GameOver: 
		meters = round(global_position.y / 15.0)
	
	if meters % 100 == 0 and meters != 0 and last_milestone != meters:
		print("Upgrade screen")
		$"../UI".upgrade_screen()
		last_milestone = meters
	
	$PointLight2D.energy = remap(global_position.y / 100.0, 0, 450, 0.2, 0.9)
	bg_color_modulate = remap(global_position.y / 100.0, 0, 450, 1, 0.2)
	$Sprite2D.modulate = Color(bg_color_modulate, bg_color_modulate, bg_color_modulate, 1)

	if shake_timer > 0:
		shake_timer -= delta
		offset = original_offset + Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
	else:
		shake_timer = 0
		offset = original_offset

func _on_gameplay_area_body_exited(body):
	if body == player:
		start_shake(10, 0.25)
		$"../UI"._game_over(meters)
		$"../DamageSFX".play()

func start_shake(intensity: float = -1, duration: float = -1):
	if intensity > 0:
		shake_intensity = intensity
	if duration > 0:
		shake_duration = duration
	shake_timer = shake_duration
