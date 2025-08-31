extends Camera2D

@export var player: CharacterBody2D
var bg_color_modulate: float = 1
var meters: int = 0

var last_milestone: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#move gameplay area down
	global_position.y += 50 * delta
	if !GlobalScript.GameOver: 
		meters = round(global_position.y / 15.0)
	
	#check if meters is a multiple of 150
	if meters % 100 == 0 and not meters == 0 and not last_milestone == meters:
		$"../UI".upgrade_screen()
		last_milestone = meters
	
	#adjust vignette effect and background color based on gameplay area depth
	$PointLight2D.energy = remap(global_position.y / 100.0, 0, 450, 0.2, 0.9)
	bg_color_modulate = remap(global_position.y / 100.0, 0, 450, 1, 0.2)
	$bg_placeholder.modulate = Color(bg_color_modulate, bg_color_modulate, bg_color_modulate, 1)
	
func _on_gameplay_area_body_exited(body):
	if body == player:
		get_parent()._game_over()
